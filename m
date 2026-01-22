Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD51D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA6A6B02CA; Thu, 22 Jan 2026 12:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78ED6B02CD; Thu, 22 Jan 2026 12:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA836B02CA; Thu, 22 Jan 2026 12:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88CE66B02CA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 59194160490
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:52 +0000 (UTC)
X-FDA: 84360219384.01.0A9F579
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id AD3012000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xPPmpmTKKGtwcKrMZhyigmXqmhh12wwthRA5S3g/JzU=;
	b=L/rNTP0LJZZh1cRdw/SnBdYJvEGvCvlxJQEr1WPpkUbOgHTtp1s3PqSFlUxbKo1aSnQS6F
	FX9OatfHu1oNusFrHP8GIPMYp+qNDD3k9xH1U2nAkelrL9tInY1Dap26+2VBNlDUMwyXfz
	U3ojj2YMIRJAqp0RnBeLd3oNe5bmQCo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101370; a=rsa-sha256;
	cv=none;
	b=EK0G5y+yiMpuI5+YKKYPymuTnmKLKjSb5mRMPURCVl1PE8yE195WmgoGZYf1lwHBz8CM5B
	n/+cp0pThNiHT/9syTcBJpyY2xQvOte3ykRksyveN+1TRtqRGBuLAIoLu5klo2u0Suoo9D
	Dlk7i7PFDNk89o4QJR1Dqng4U42DED4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 429D81684;
	Thu, 22 Jan 2026 09:02:43 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7CCD93F632;
	Thu, 22 Jan 2026 09:02:48 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v3 9/9] selftests/mm: report SKIP in pfnmap if a check fails
Date: Thu, 22 Jan 2026 17:02:24 +0000
Message-ID: <20260122170224.4056513-10-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD3012000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mfs6hy7b1gy5tt8sysjfcqknt1pm4h6x
X-HE-Tag: 1769101370-292443
X-HE-Meta: U2FsdGVkX18UT50NWM2nb3/UlHAiLTsNQUiKMzT5LtPMHZz6pMnfrj8orYBZtpfXwbvb9ePCDp+wGc+CVHKhKuKMB4Jr5aQy93XY/FhndvqSiu+gaLqLLvLUK1LV0IvCZeMgtzyLb9jORDDk9LkidSPDILsZZoadaB8auUcwYx0Pusu4ytmzedQ/K4zb/DxJmQKM8pJx0TAO8U8jTb5XSRwLpL/zbc1xo5tILDGZ2mCoaO9SfqxfzXv0gx6PnkeJK6t4x8drhiqBBSHW2kVF+x32rwFp8YihIMzmiKxsNqWCrz+YYUVHJccjIIXinD4lleTN7AcIvaF5Rwf/SAwx/QcEr2wRvvV1Ak6Ng6Hg+gZ1OPh0RaYixVsJpGL0eS4oNwQ1j3nh+NAcgd/DtH13CI0farPk9UkmEzBcM+oBUB1PaObbiIVNec5FFn/pinMseOb5ZdfX1a4Zryy2I2FcxIfAG2FuT1Gpga9KYb87vZ3WY2X1Ob9BkrkVoKzXyPixqpCpshEvja3TE+pAvKBKLWIwICIoo0CxzUeNGyRlzP9JkYTlE0Hy8m0IR5q2TWj3FuU9aDeAZ2TPplFDKmiDbd/1vR8Kw2xQCyNzFYxwDKpyrv/P864yb+Iavq/0OeckBf969q6qW+tQ1yIhhEzFvF+C1ZqFAwzFplPUA03IKYjUl7dJlQGMO/xu0HkUYRg5r2ihnDZD3k0WKPW9eCSuAxqMCIetya5BHWd7RI4hwM32HnWmpFEIUpLAxbzXNavc6Gsw7eRhMKnKrzhCJL4CrlwOuWeKpFOxrRJlpSCfaKHbZXeIVM5X+pNz989gZBRJuCtTSqmdZZeGpJ9l26/N5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pfnmap currently checks the target file in FIXTURE_SETUP(pfnmap),
meaning once for every test, and skips the test if any check fails.

The target file is the same for every test so this is a little
overkill. More importantly, this approach means that the whole suite
will report PASS even if all the tests are skipped because kernel
configuration (e.g. CONFIG_STRICT_DEVMEM=y) prevented /dev/mem from
being mapped, for instance.

Let's ensure that KSFT_SKIP is returned as exit code if any check
fails by performing the checks in pfnmap_init(), run once. That
function also takes care of finding the offset of the pages to be
mapped and saves it in a global. The file is now opened only once
and the fd saved in a global, but it is still mapped/unmapped for
every test, as some of them modify the mapping.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pfnmap.c | 84 ++++++++++++++++++-----------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 45b5f1cf6019..4f550822385a 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -25,8 +25,12 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#define DEV_MEM_NPAGES	2
+
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
+static off_t file_offset;
+static int fd;
 
 static void signal_handler(int sig)
 {
@@ -88,7 +92,7 @@ static int find_ram_target(off_t *offset,
 			break;
 
 		/* We need two pages. */
-		if (end > start + 2 * pagesize) {
+		if (end > start + DEV_MEM_NPAGES * pagesize) {
 			fclose(file);
 			*offset = start;
 			return 0;
@@ -97,11 +101,48 @@ static int find_ram_target(off_t *offset,
 	return -ENOENT;
 }
 
+static void pfnmap_init(void)
+{
+	size_t pagesize = getpagesize();
+	size_t size = DEV_MEM_NPAGES * pagesize;
+	void *addr;
+
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		int err = find_ram_target(&file_offset, pagesize);
+
+		if (err)
+			ksft_exit_skip("Cannot find ram target in '/proc/iomem': %s\n",
+				       strerror(-err));
+	} else {
+		file_offset = 0;
+	}
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
+
+	/*
+	 * Make sure we can map the file, and perform some basic checks; skip
+	 * the whole suite if anything goes wrong.
+	 * A fresh mapping is then created for every test case by
+	 * FIXTURE_SETUP(pfnmap).
+	 */
+	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
+	if (addr == MAP_FAILED)
+		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
+
+	if (!check_vmflag_pfnmap(addr))
+		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
+
+	if (test_read_access(addr, size, pagesize))
+		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
+
+	munmap(addr, size);
+}
+
 FIXTURE(pfnmap)
 {
-	off_t offset;
 	size_t pagesize;
-	int dev_mem_fd;
 	char *addr1;
 	size_t size1;
 	char *addr2;
@@ -112,31 +153,10 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
-		/* We'll require two physical pages throughout our tests ... */
-		if (find_ram_target(&self->offset, self->pagesize))
-			SKIP(return,
-				   "Cannot find ram target in '/proc/iomem'\n");
-	} else {
-		self->offset = 0;
-	}
-
-	self->dev_mem_fd = open(file, O_RDONLY);
-	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '%s'\n", file);
-
-	self->size1 = self->pagesize * 2;
+	self->size1 = DEV_MEM_NPAGES * self->pagesize;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
-	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '%s'\n", file);
-
-	if (!check_vmflag_pfnmap(self->addr1))
-		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
-
-	/* ... and want to be able to read from them. */
-	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
+			   fd, file_offset);
+	ASSERT_NE(self->addr1, MAP_FAILED);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -148,8 +168,6 @@ FIXTURE_TEARDOWN(pfnmap)
 		munmap(self->addr2, self->size2);
 	if (self->addr1 != MAP_FAILED)
 		munmap(self->addr1, self->size1);
-	if (self->dev_mem_fd >= 0)
-		close(self->dev_mem_fd);
 }
 
 TEST_F(pfnmap, madvise_disallowed)
@@ -189,7 +207,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
+			   fd, file_offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -259,8 +277,12 @@ int main(int argc, char **argv)
 		if (strcmp(argv[i], "--") == 0) {
 			if (i + 1 < argc && strlen(argv[i + 1]) > 0)
 				file = argv[i + 1];
-			return test_harness_run(i, argv);
+			argc = i;
+			break;
 		}
 	}
+
+	pfnmap_init();
+
 	return test_harness_run(argc, argv);
 }
-- 
2.51.2


