Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C74CD0D142
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC0D6B009E; Wed,  7 Jan 2026 11:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C795B6B009F; Wed,  7 Jan 2026 11:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E6E6B00A0; Wed,  7 Jan 2026 11:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA936B009E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:49:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C400B94A1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:05 +0000 (UTC)
X-FDA: 84305752650.04.148131D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id D0A9A140008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804544; a=rsa-sha256;
	cv=none;
	b=W1HHwJkbGoEgGhZhk2LsJyR2+wAHJYjysVWRib+peiIzJ0bmYOI+b7/IwSNXa7G1cWCuvQ
	HVUwgK7pR9ecEwKby+mwaF+h7p2OMWO+vgT5n/5nY7eaaOvqUelkM6yAqSzqPgy9ZnwA9O
	mX6hCWeZNY7AvjoYErJn96Oi0/Vuw64=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=03AZyPENj3xKxuMq8GafvX8nbZFbNBmiIe2gNxYbWfE=;
	b=daVk8cPHMEsqpnYWcG20NXiPvZ0+NunMO/8KXKoKYMQYWDYbkfNRD8P6GuDhgZ0GbqsJbb
	68SWdrnQSsHDy+fGdvVd2jTZuSLJCmsAtrDqwElqKU/qRktGY+migSpJXrQphB0N6ldd2e
	jj8Er+sFdKbb/eLyG3WAVXZWT2WwCdU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A97021595;
	Wed,  7 Jan 2026 08:48:56 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43EA53F5A1;
	Wed,  7 Jan 2026 08:49:02 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 8/8] selftests/mm: report SKIP in pfnmap if a check fails
Date: Wed,  7 Jan 2026 16:48:42 +0000
Message-ID: <20260107164842.3289559-9-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D0A9A140008
X-Stat-Signature: ojx9xkguyguph8eze15s6yh16pfgm9fz
X-Rspam-User: 
X-HE-Tag: 1767804543-774849
X-HE-Meta: U2FsdGVkX1+/d131KIx/XqHKtvXRFHXFpJEnoeGgzqDwpdsZKIsm92yAOeXPmdBJuGv3fhR/tFZNtWvU4iJiXkOmafmZP+g+ydCl2x63pi3nuZ0t/AZH/Ck7JpsQzhHYvurAZZTRkD126eWJgkADUCvwKNqorTGm7uRwCAfBspnSNqo9tkHjoIxBGltxHOwuXYhJbc82JuNQTobqqVN3kUUmpc5eEAVw6t4kjXsPkAm3zlPUN196HNYSONoh5ANfLIetzzCbd0ib+h3iYb6zt2N5eexCX/co1xS7vzrlH+WnqcCjIJyBoDZ2FCSACx4pbuHLSfQW4yCDjHlPS9my7I6M2zr6QV8o9Ad6zGV3+zm/Fln/fZHQDfzzev5N1TLwTlTBu+Rnr4/P24ZAsWDtUbIStKixLJzuE03G8cOcfCF9G5T+J30F/C3xF5unhFWPtbUGLmvJ4VrPjHSHy6idAAkhxNr3vQ8JiE5TPFAsEIl3U3YffQQFysazYqHOyxYLz32vrzveUsdk7laiXX8Qn3S9viEaPtiOba1onodF1BXOFE/t25hd2RmeOCeONPnztItA+37u9Agt6BDf91dLZq2fh9eFU61AL8LVBoYY2hfbqpwvP+99/696PtQKWX4zjp0wMzpFIxAA2LRlaSI5wHky0an8HfKQpTghiQ+R1P/hB+nU8JGdj0oEPBIHziQVTUpYypzUS9r0CueU7nlgnc56xcdLFnE5KHMREek/MTDx3xMrkFBsBrRGqCZ3aBYU9DYUa8m0+79/UP9hyVUmXBDKshOk4TvLVawyFPL2WJto+0uhr0aZrmls8qh7QOQvRKeGYHGoVcFd/1c3K8xHqj8j7DfwAJePGAwwD4CWPjbrfaIRkbDk6kRgpXTzRT5LrXN8OqW6r5AiF+ZA1oQXYGcR+YEpWvzGAtkfCDrO0QI6mUWo+OkvY9xpml07A0QLmSu7bNjQo4ARCKfexjI
 QHKoGG8y
 gRRyPouuWGGV0/xOlsYX/L+HgatxCKaAMHioRw4bNzr0GFBkwpuL//p8YgQkpRG3DQViDUm2nFmfj6q4p6BVJ76/eqk+bmiqvOQBdBea8Y8f1sWCrnlKZVD31wMoXD2bgbdZpumcZ1thd0/GdwbRiC1f6Iw==
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
mapped and saves it in a global. The file is still mapped/unmapped
for every test, as some of them modify the mapping.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pfnmap.c | 81 ++++++++++++++++++++---------
 1 file changed, 55 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 35b0e3ed54cd..e41d5464130b 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -25,8 +25,11 @@
 #include "kselftest_harness.h"
 #include "vm_util.h"
 
+#define DEV_MEM_NPAGES	2
+
 static sigjmp_buf sigjmp_buf_env;
 static char *file = "/dev/mem";
+static off_t file_offset;
 
 static void signal_handler(int sig)
 {
@@ -88,7 +91,7 @@ static int find_ram_target(off_t *offset,
 			break;
 
 		/* We need two pages. */
-		if (end > start + 2 * pagesize) {
+		if (end > start + DEV_MEM_NPAGES * pagesize) {
 			fclose(file);
 			*offset = start;
 			return 0;
@@ -97,9 +100,49 @@ static int find_ram_target(off_t *offset,
 	return -ENOENT;
 }
 
+static void pfnmap_init(void)
+{
+	size_t pagesize = getpagesize();
+	size_t size = DEV_MEM_NPAGES * pagesize;
+	int fd;
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
+	/*
+	 * Make sure we can open and map the file, and perform some basic
+	 * checks; skip the whole suite if anything goes wrong.
+	 * A fresh mapping is then created for every test case by
+	 * FIXTURE_SETUP(pfnmap).
+	 */
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		ksft_exit_skip("Cannot open '%s': %s\n", file, strerror(errno));
+
+	addr = mmap(NULL, size, PROT_READ, MAP_SHARED, fd, file_offset);
+	if (addr == MAP_FAILED)
+		ksft_exit_skip("Cannot mmap '%s': %s\n", file, strerror(errno));
+
+	if (!check_vmflag_pfnmap(addr))
+		ksft_exit_skip("Invalid file: '%s'. Not pfnmap'ed\n", file);
+
+	if (test_read_access(addr, size))
+		ksft_exit_skip("Cannot read-access mmap'ed '%s'\n", file);
+
+	munmap(addr, size);
+	close(fd);
+}
+
 FIXTURE(pfnmap)
 {
-	off_t offset;
 	size_t pagesize;
 	int dev_mem_fd;
 	char *addr1;
@@ -112,31 +155,13 @@ FIXTURE_SETUP(pfnmap)
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
 	self->dev_mem_fd = open(file, O_RDONLY);
-	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '%s'\n", file);
+	ASSERT_GE(self->dev_mem_fd, 0);
 
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
-	if (test_read_access(self->addr1, self->size1))
-		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
+			   self->dev_mem_fd, file_offset);
+	ASSERT_NE(self->addr1, MAP_FAILED);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -189,7 +214,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->offset);
+			   self->dev_mem_fd, file_offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -258,8 +283,12 @@ int main(int argc, char **argv)
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


