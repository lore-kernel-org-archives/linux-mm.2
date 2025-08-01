Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAC5C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893636B008C; Fri,  1 Aug 2025 19:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B366B0093; Fri,  1 Aug 2025 19:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7811E6B0095; Fri,  1 Aug 2025 19:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64AD26B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:46:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D076DC02A7
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:46:16 +0000 (UTC)
X-FDA: 83729824752.22.7370A0C
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16A5414000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:46:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s70L3y7q;
	spf=pass (imf09.hostedemail.com: domain of 3xVGNaAkKCOgceNKbcKXWQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--sudarsanm.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xVGNaAkKCOgceNKbcKXWQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754091975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RCbUWFNAiQIE2SEZGiipZa782xmKSM+6i2HHrci0QuA=;
	b=yPQJh1EaUt0IuV7n86Ea6ZUyYWTASKONA0uSlLC95nXoExe+bP/Y4oz/tKUKH49rDSTeTJ
	+O9rYPrVmD5mnOPEBPjpl1uMnWhJ6lvOV/MXe4yNAlOtH7oeo5mjCr+jznzc+e3hth3IFx
	36+e4cX3q3Rxu3YcVLkMItkqYlmAkmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754091975; a=rsa-sha256;
	cv=none;
	b=oNkTtTrmh5YWxYarPPb0Z9/ja4lBvydPzc/vOe0OynGOxsWl1DXFv3V7EWdDBNjMIJnGPE
	m3Es6pCU9OlhafYiWxKMgbMZ97ZB2VC0XJBH/oInTK9YiAEdFLTzcxZQujSj5A/MbvLvGS
	C6eAxAxAoO2qhl77JomsRrLeY0b9Gdk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=s70L3y7q;
	spf=pass (imf09.hostedemail.com: domain of 3xVGNaAkKCOgceNKbcKXWQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--sudarsanm.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3xVGNaAkKCOgceNKbcKXWQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ea10f801aso3644057a91.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 16:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754091974; x=1754696774; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RCbUWFNAiQIE2SEZGiipZa782xmKSM+6i2HHrci0QuA=;
        b=s70L3y7qqYxdTYF+ZBVLiOJPAlSftzFiAXWFhNLc+NfBVLaFeczGig9gxIbhFSAmY1
         1FPItE0Iw1hhXhG+1yyMMvNvq2AX9UEuGuR5ESMtMSpE/Owvr+OjcXxo/k1nfOss7C8Q
         MTnY6Vl2Bx8Bj1Fx9Y29hHUh9tvoWfuPkMtFljF1zGw6QYsUuxfXCTR6MlmjjtbHwEzQ
         aySL8tz05dEE+ORUuW/N+GySZZQqPa4dtaWgyTsctH9PbWzcK29Ms7VtkUhCFDno7gfz
         s/9RZ13+BZRR8SJ7/alPxe/YoZ9o7j7wJ5qCUyUOTbxibniLtr2+9OGvt5UF8UxM2iAa
         JuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754091974; x=1754696774;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RCbUWFNAiQIE2SEZGiipZa782xmKSM+6i2HHrci0QuA=;
        b=cKd9pYJ+nOjKnstZUdxEZgdwXBCkedmI4arRU37C+4SNOh8WjppTHvBTFlwnRCrP09
         +bdDEdFRElDZIT9ZxQDWi+2bJkKkOQhfOiIgmOWEw12u5UXT9T/7aM1OAIUHGQbbpE4m
         hK48M+4gXiOtq06HPSe59y0aoTyBOmGfP0B/HjgREdsAXnPtBNN5XHrS8kdumHQ265Cu
         FH1dSGoEUN84BeXGPZawug5dFvs3frNyuNUGh+RTdBq96pkn/15C815aqqaAD1SfSR9C
         uSiyAbvSxW1z9s6Q1O5+BOd40gA+6rDeSdDRt8pa5aCyiK4wCUbWnqn0/ivF3m+W5lxY
         JfAg==
X-Forwarded-Encrypted: i=1; AJvYcCUEOEC64UdhGd9kB3gPX7V3vsMuzQ7I/jVBRrAiY/7uPhXlr8Qyk7X2ANNH6Dghlcw2e3K3fRB5ew==@kvack.org
X-Gm-Message-State: AOJu0Yydm8McJsD2++qMdH4IryIGLqdiuwkwRGBwx5sUB4bOGOq2mzlz
	Fx436AUM31QnKhDMh2tU+Rj4B5W9bhbeHgFC6k5ElpX2vhK9Us3po667cQyWUX3IimpJIZXC3zA
	MmIruD5MfKWkOqIq1bw==
X-Google-Smtp-Source: AGHT+IFb+ysewxBs4h3pIvhDOB58xFs76O5xVyYH3xfpChybjlsHQtJ6CB+wmDZbgnZS7YoS4QbL24y0lzKb8BA=
X-Received: from pjvv13.prod.google.com ([2002:a17:90b:588d:b0:31e:cee1:4d04])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3e86:b0:31f:1a3e:fe31 with SMTP id 98e67ed59e1d1-321161ed89fmr1974835a91.11.1754091973873;
 Fri, 01 Aug 2025 16:46:13 -0700 (PDT)
Date: Fri,  1 Aug 2025 16:45:59 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250801234559.1178521-1-sudarsanm@google.com>
Subject: [PATCH v2] selftests/mm: pass filename as input param to VM_PFNMAP tests
From: Sudarsan Mahendran <sudarsanm@google.com>
To: linux-kselftest@vger.kernel.org, David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org, Sudarsan Mahendran <sudarsanm@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16A5414000C
X-Stat-Signature: i6ndfkuk6r3oob6c3yj54t8d5sa3pxqr
X-Rspam-User: 
X-HE-Tag: 1754091974-426744
X-HE-Meta: U2FsdGVkX18KxGmjv9a9c9TzPddNjZCb7uiIe9oMEe+Gi3zzome9YATDu5L8kH8zyDnFG6an/gtgcclmxF6BeWlU37VLYRs6/UxPUnSJdNWwLh8q1trwU+YGmIzzOF/zQdtFntkLG4o1nLtgHvp0+CVBNIOi4vese47NZQT9DWJt9uQvLw9GHrDTNkrgKyMrDpz5J4ravoiBQKfBElvAtn/BjzlkysDccDt2Y+FQHM4bsGyTauuvu++Kfq2ElBTMK+4b9dyv8nVTWDdy/53WfhzVPXYXG5SRhWvfNjdl4ev9uzaeg392ftjq/FXdhanlNB3BOQYRkYZTnBFR97+ZuFQMRHbclip3wXAREA1ou5DYPgOz6bw/0PkMsxJzDx+aN8WD3CT/vEAthoDG5hxjiT5u0trsFI5ISfHZWo8PdAKP4bkb4ESc79ggxo9Gnia3YTuo0N94cvSsiHGdQN+IO2V+M9OHr2//8k/8EyjV09+bAZaAh2U+Tfm7GOsuRzBSEy9LcAIgVQRyXUltdWB2Sb2xyzfS+GmcxV94twNc55vev5Xbi5CCQlsKMKF2fY2/HklHL9fLkHmOUXDIzdL7SCD7MZjllsJN8J8mP09+izyXQr7DBQZTREJWTeQl1zKrAY/SmcWpsneI53GKkerT4eMy3IlRnTNXidb5bXrwCM4Kw8zauAweQgpmemsg5ZW9RxU1Mogm/zT+VvQ+2HJCjBhYjPhS7xX/gZpRLi08QNIbZ0hfqT2IKZjXA0K+NT2JUYxyVvQ3Ya1emkwQqgCVfX+3bZ7/BOVL7cJz+n3b8LR149dvXb7LI8LO32aOySrRyc5Yi6iB/mNuIWBNbPyQAUlYXWRNSLNMChdC8+cYzxvaqcPTUwvEgKC9zeItISZUG0crLk8mXg78W+RTwZyMa2L68Gd3tn2KVdWoBexOIjLuCJKFVl0rC9jakgAAMHa9of4JU4MnRRsY7q0dV+9
 O9qwqN9M
 KIaqDHzxWH0wuTb8Mk6juuVmSpc7L4ZbF6GGADywWW12z5l0bMMU7lWjQ0XMk9zY4IP09FkboyablOiESYGN8Y+wHQNztQG/BTO0DTTMdNGQ7mwLspoDpBXuv3aYq6AomrRnNQ7LfwTmzZ6/BbY9gDn8o+8B/u8i8cXq9Ba4dJG/Frv70IqfwEPyAWLGqkIL4uFBiOa05siURYlnGbSsutzGVijIPWJbo/pCMkU7TYfy0z5+yctTrRKMfVMe7OK3xiaXP1fXKJsYnSUGDxgiUrwW42CD4C91kcfBqmm6rhpuxukKLAtQm580TnbVO6Zt8UA+nEq7NLOnb5yFZfrCOY6PQI4SmKWpeNz5DqE4reG+fX0x9SS8aPnCzT7oAvohHYdP+JEIsrAeoT+aSMk4Oh+cwqiyA0lo6ZW8AJ7aCg9rcHvQ1dX7H6IwXjio9wvNPdzxRTpWHloG/eIO2cQiY+TZ7UG2AgQaQDX3k/Vu5XuK/kt7UHnBUwxmdaBLVWIYdWKzRWz5rck0qTVhfZhYFKyTtZ0i/N1CLFVzT9zI9jwOvgLdrIo6VQ0rCkM8aNyDJIo9mhZfbdt85OpvtB5GuKt4zLRGrEdun9+cR2E+zhwitMOw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable these tests to be run on other pfnmap'ed memory like
NVIDIA's EGM.

Add '--' as a separator to pass in file path. This allows
passing of cmd line arguments to kselftest_harness.
Use '/dev/mem' as default filename.

Existing test passes:
	pfnmap
	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	# PASSED: 6 / 6 tests passed.
	# Totals: pass:6 fail:0 xfail:0 xpass:0 skip:0 error:0

Pass params to kselftest_harness:
	pfnmap -r pfnmap:mremap_fixed
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.mremap_fixed ...
	#            OK  pfnmap.mremap_fixed
	ok 1 pfnmap.mremap_fixed
	# PASSED: 1 / 1 tests passed.
	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Pass non-existent file name as input:
	pfnmap -- /dev/blah
	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Cannot open '/dev/blah'

Pass non pfnmap'ed file as input:
	pfnmap -r pfnmap.madvise_disallowed -- randfile
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Invalid file: 'randfile'. Not pfnmap'ed

Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
---

v1 -> v2:
* Add verify_pfnmap func to sanity check the input param
* mmap with zero offset if filename != '/dev/mem'

---
 tools/testing/selftests/mm/pfnmap.c | 62 ++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 866ac023baf5..e078b961c333 100644
--- a/tools/testing/selftests/mm/pfnmap.c
+++ b/tools/testing/selftests/mm/pfnmap.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Basic VM_PFNMAP tests relying on mmap() of '/dev/mem'
+ * Basic VM_PFNMAP tests relying on mmap() of input file provided.
+ * Use '/dev/mem' as default.
  *
  * Copyright 2025, Red Hat, Inc.
  *
@@ -25,6 +26,7 @@
 #include "vm_util.h"
 
 static sigjmp_buf sigjmp_buf_env;
+static char *file = "/dev/mem";
 
 static void signal_handler(int sig)
 {
@@ -98,6 +100,30 @@ static int find_ram_target(off_t *phys_addr,
 	return -ENOENT;
 }
 
+static int verify_pfnmap(void)
+{
+	FILE *smaps_fp;
+	char line[512];
+	int found_mmap_entry = 0;
+
+	smaps_fp = fopen("/proc/self/smaps", "r");
+	if (!smaps_fp)
+		return -errno;
+	while (fgets(line, sizeof(line), smaps_fp) != NULL) {
+		if (strstr(line, file) && strstr(line, " r--s "))
+			found_mmap_entry = 1;
+
+		if (found_mmap_entry &&
+		    strncmp(line, "VmFlags:", strlen("VmFlags:")) == 0) {
+			if (strstr(line, " pf "))
+				return 0;
+			found_mmap_entry = 0;
+		}
+	}
+	fclose(smaps_fp);
+	return -ENOENT;
+}
+
 FIXTURE(pfnmap)
 {
 	off_t phys_addr;
@@ -113,23 +139,31 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	/* We'll require two physical pages throughout our tests ... */
-	if (find_ram_target(&self->phys_addr, self->pagesize))
-		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		/* We'll require two physical pages throughout our tests ... */
+		if (find_ram_target(&self->phys_addr, self->pagesize))
+			SKIP(return,
+				   "Cannot find ram target in '/proc/iomem'\n");
+	} else {
+		self->phys_addr = 0;
+	}
 
-	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
+	self->dev_mem_fd = open(file, O_RDONLY);
 	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '/dev/mem'\n");
+		SKIP(return, "Cannot open '%s'\n", file);
 
 	self->size1 = self->pagesize * 2;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
 			   self->dev_mem_fd, self->phys_addr);
 	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '/dev/mem'\n");
+		SKIP(return, "Cannot mmap '%s'\n", file);
+
+	if (verify_pfnmap())
+		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
 	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -246,4 +280,14 @@ TEST_F(pfnmap, fork)
 	ASSERT_EQ(ret, 0);
 }
 
-TEST_HARNESS_MAIN
+int main(int argc, char **argv)
+{
+	for (int i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "--") == 0) {
+			if (i + 1 < argc && strlen(argv[i + 1]) > 0)
+				file = argv[i + 1];
+			return test_harness_run(i, argv);
+		}
+	}
+	return test_harness_run(argc, argv);
+}
-- 
2.50.1.565.gc32cd1483b-goog


