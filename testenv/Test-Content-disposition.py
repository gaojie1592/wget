#!/usr/bin/env python3
from sys import exit
from WgetTest import HTTPTest, WgetFile

"""
    This test ensures that Wget parses the Content-Disposition header
    correctly and creates a local file accordingly.
"""
TEST_NAME = "Content Disposition Header"
############# File Definitions ###############################################
File1 = """All that is gold does not glitter,
        Not all those who wander are lost;
        The old that is strong does not wither,
        Deep roots are not reached by the frost.
        From the ashes a fire shall be woken,
        A light from the shadows shall spring;
        Renewed shall be blade that was broken,
        The crownless again shall be king."""

File1_rules = {
    "SendHeader"        : {
        "Content-Disposition" : "Attachment; filename=JRR.Tolkein"
    }
}
A_File = WgetFile ("LOTR", File1, rules=File1_rules)

WGET_OPTIONS = "-d --content-disposition"
WGET_URLS = [["LOTR"]]

Files = [[A_File]]

ExpectedReturnCode = 0
ExpectedDownloadedFiles = [WgetFile ("JRR.Tolkein", File1)]

################ Pre and Post Test Hooks #####################################
pre_test = {
    "ServerFiles"       : Files
}
test_options = {
    "WgetCommands"      : WGET_OPTIONS,
    "Urls"              : WGET_URLS
}
post_test = {
    "ExpectedFiles"     : ExpectedDownloadedFiles,
    "ExpectedRetcode"   : ExpectedReturnCode
}

err = HTTPTest (
                name=TEST_NAME,
                pre_hook=pre_test,
                test_params=test_options,
                post_hook=post_test
).begin ()

exit (err)
