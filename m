Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17E82C87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 20:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971156B007B; Thu, 31 Jul 2025 16:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921AC6B0089; Thu, 31 Jul 2025 16:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837B36B008A; Thu, 31 Jul 2025 16:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD8F6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:45:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3CD1A1A0AD2
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:10:24 +0000 (UTC)
X-FDA: 83725651968.16.5CA5A5E
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 804621C000B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:10:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sZlCOQ8C;
	spf=pass (imf18.hostedemail.com: domain of 3rc2LaAkKCMI02liz0ivuowwotm.kwutqv25-uus3iks.wzo@flex--sudarsanm.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3rc2LaAkKCMI02liz0ivuowwotm.kwutqv25-uus3iks.wzo@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753992622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J09bJnyFyHUEqMAMcKAT+RUtJuszd341ngKo2pBlF9A=;
	b=3GCqC56z8gd9t7Lpn4uEuq1N8G73/QspmRuQRDe/UzxlvJD/nU8QFJw064wFeYNDVprBwL
	Dp0zkoBNtIUizI6476hcV3pTPCqUzikCErwoggx7Y+xbrJbFmI0rjO/VxUqSJ0I3ydcqfT
	LgGyNmNFqu6KPFSU+4SN2zEkRwOTP/M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sZlCOQ8C;
	spf=pass (imf18.hostedemail.com: domain of 3rc2LaAkKCMI02liz0ivuowwotm.kwutqv25-uus3iks.wzo@flex--sudarsanm.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3rc2LaAkKCMI02liz0ivuowwotm.kwutqv25-uus3iks.wzo@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753992622; a=rsa-sha256;
	cv=none;
	b=7BiJ114Duu63QKTfCteokpayVDOL0gK54OSvy5OwFOmPVDPJ7LFtQq0DOK25/biwxFzdmV
	ITQZHUHd8JkovtrTpYzutyFRdzdUwgLl8UYbY8wRQqxQXCHBuR5VNw/S2AA2vkgMfcipVJ
	ZmhdzxGIiuQvOm18x+5vp9xltB9n3bQ=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b3928ad6176so1262513a12.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753992621; x=1754597421; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=J09bJnyFyHUEqMAMcKAT+RUtJuszd341ngKo2pBlF9A=;
        b=sZlCOQ8Ca7ApZVVMs5WU1Kku1UYHTdyHhuaYQRLJ4RP1+dEMrc4YHLilzewdDDsPfe
         euM5DjShKMiYBGnpkJhKC9DA573IRQicJAKeq4d8YzxWk4LDbXE59zpKG1trbQaKIi7a
         qg/m5E0nIkCrc73Ze+SXp/KYiXXKcFb36N4cnf53ERG6zjKEtdj357y2SkImWZLYWjWs
         uoI6xjYZ9rIXM/ugZEdV6uoQnL6dJ7XIq1H4skGTR3cxvlmKz5Ej32JRd0gJwFWzNc50
         qtOSmCrpL0exPL5oi8DoBnpnw8fpG77LYyq6LdOH7Ktzs/OzrNafEw+PDjH1jTq1dTpB
         SiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753992621; x=1754597421;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J09bJnyFyHUEqMAMcKAT+RUtJuszd341ngKo2pBlF9A=;
        b=egP8M0eXBe27dwNZssqt1Oucyrgf7K52dQzSAaGrfmCFwhMEgNRLTI61Zkqle9suNQ
         zAmgbg0NQT5v1LGV/pQWH8o3N6VaiqfytF7SSfkS4WAs+OQSk9Zp0DQVTm6UiqbRK+lP
         mp5Sv/Z3ao3iDOZadNY91mkoa0XcBRT1+QjU7iXptmsqQmfCGVRpfyCmjUpRJ/9aWSrT
         TjUMot2FVCcULyr+lAGgDPLm6bPZs/BPrRFK0kJyBe0rUaKi+ijKhO4iw4e5C554G/4G
         ZSEkmK5ebdm5cZXs9+1JgQvfwwwRoDUhyN0ABODHSRKYgQxFBbmZCj3w5MgULS/nXMtK
         qiIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXex2v8qSHRf61sb0OoPTQkHMRjNlpjGP1qBb08DG6VEOb/jfkt4u512JldWkaaDc2bcGZdJsaiIw==@kvack.org
X-Gm-Message-State: AOJu0YyIOT646M1KZgO9qTQE02fFzOeJdOEVnKO/ubzByX7OXh10HDaS
	TKo9nPJjNAtpZXKYX3XuG7g9icHlg0f4IAMmrZ8FTBy/XOUWA5ry2wOGPokADRvssbiAqbxQRdS
	EckGK8hXyY0EF5AmpEA==
X-Google-Smtp-Source: AGHT+IHgx/cYgrYinezSkOTAmAfU/9csyQH9piPDnBU/wf7uG2ssY6nBUVDU1MMbLwCPMAV4sTmBpXU9mwzHGbM=
X-Received: from pgng29.prod.google.com ([2002:a63:375d:0:b0:b31:d832:f7b0])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:8095:b0:23d:dcb9:d50d with SMTP id adf61e73a8af0-23ddcb9f6dcmr3837708637.25.1753992621200;
 Thu, 31 Jul 2025 13:10:21 -0700 (PDT)
Date: Thu, 31 Jul 2025 13:10:09 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250731201009.888945-1-sudarsanm@google.com>
Subject: [PATCH] selftests/mm: pass filename as input param to VM_PFNMAP tests
From: Sudarsan Mahendran <sudarsanm@google.com>
To: linux-kselftest@vger.kernel.org, David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org, Sudarsan Mahendran <sudarsanm@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: otbcjdxhuaq1duamf89hfm4wap6psqg8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 804621C000B
X-Rspam-User: 
X-HE-Tag: 1753992622-454254
X-HE-Meta: U2FsdGVkX19e2e3hvzcqFIkmftsG4x/FrUVqr6yCoXBJ8di9Yo6cpQZPdjbubhXwUNOsJeVOUShx+qUw7dONhKi6tJ58x8bUP/RwcJmyRJy18kWcq8USjoFBN/nxyGcxP1MmFRzE/EuSUSCDV5BHbDZsHCd8fE7bc6CZT23kkdelherVL1WmmQ5eJwXpyTJtorkDB1kIM3v0ax4sbEDG0qIFejru4RHYvB6z6aH8+gIyAIWoThHwyy+6TiUXqT3P2xPDsIkknFGh+ZJ5Cxc5UJD1T6eUyN6Pt4nws8rZZW2/b8j/nH5RsDYhtSzqmB33ma9iMPO270frENEsGTEBvkW4bLBjJD3gVGG0iOJxwJkAkxwjBwK6dTHK4ubhb2am93Uq+QEkP32FPX6Rmta2m6BzuEHxneaB/DjZGwQqDQHLKOp02ZEZ48xKXx6xTLjp41jbChACsvpVBKRWkTrDnjSZ3Kqo0bC7Ih/tVxR9g+y9huafjr2THY+i4voxCN0gIM6awJyXr81xyUwKJGRc/Ys0eBnNQmf13pDQS6zlB1KWL7KtFYS8utxyE9ReWR9SwnD/Tb6mrb0Zx0ZE1YDP/ZJOYmMSVSLR9B04Gk7mReMk+qbHUwDixq/33zDURNeDXOoGBLLcsw1pXM9s4+rdJjx2fsrhuxaWsxOB98H1WCBHcmeIYUTQ0DL98J6Qzuh6gccqzae+2/ozlFe/RHq0XmFiaOw/TNXpNbRz/vGOH5VtSKoOUD2Kq1RiKXgSAvHvlXeluGchJQgL1wK89pQcy1V19UIYtpEpnVI6uRJ43Tw+PxIan5IhQsTQLse1Doy/a2PwpscpRCUGrg5gqh+xe5ZwvSk5Vowg2wbdSkkZlN6fMTUnFn/iWU48MRTqJKNFsKJjrGF7BSTRNevTtlPWdI9Xo9teoPG+Js0BkD7MoDiJknop4HnTALMfm7+1HD9ZVewrg+94ABFWVZyQ3bY
 DQO9cE6A
 QyaG94ErtpMGzevgioWYA1SLoUJuyriwtIaAHAhe5UErbjXHAAgwpnIlHLX09OcYNvQxstCb7bs4P7KW7Td4mSor6iqotNwANl2/5+id/RrI9MhqomGfs63hsyAFu77Kft9wwbBzXwnl1yG17AhHF/W8UhO2b5znt8DwESzezwX4CVLpANeYQ+SXnO6s2WAIh5CWpiWzJheXiEsBRJSJyPCvLd7LHiV1TpsCXjVGfz2ez7GTuhgGNC89fQZkH6SyaLPesaP4/p6cnQ2SOGpPtHrtLUCp+HLJOL1obs+/CuXf5T2b/+lQLC/9uUUWgXpF5kx2/d8CNiYtuSl5QpgtMpygUig9NkmhbJ8WHru4aDDYB3s3de6wnxmq/jk7iR1v/G0k7pSc+mNRGFNqO2wTlVBo1TW/2pPOtGru6Q2a5maZHLVUenqwefN6rbWlHKDu0gy0GNSfoAyPKecT/byuNY/zotFFgzbtHLsN7GHPnSoz73ew/d0m5hzsFKGE606BB6IsdpMdscEr21K2cJVHO0vnGDna0bAzn8JZocFXQ94mJSBSj7fkXeA79IJs9PaXtROiPwNSUJtYPWhVH1Q6abYIcyBcCkppXse6b+1KkehY/laU=
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

Pass random file name as input:
	pfnmap -- /dev/blah
	TAP version 13
	1..6
	# Starting 6 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Cannot open '/dev/blah'

Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
---
 tools/testing/selftests/mm/pfnmap.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 866ac023baf5..2d4e8b165f91 100644
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
@@ -117,19 +119,19 @@ FIXTURE_SETUP(pfnmap)
 	if (find_ram_target(&self->phys_addr, self->pagesize))
 		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
 
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
 
 	/* ... and want to be able to read from them. */
 	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -246,4 +248,14 @@ TEST_F(pfnmap, fork)
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


