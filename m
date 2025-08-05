Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0BDC87FCF
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CAAA6B009E; Mon,  4 Aug 2025 21:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A20B6B009F; Mon,  4 Aug 2025 21:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7F76B00A1; Mon,  4 Aug 2025 21:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D2586B009E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:36:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C09B5140ABA
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:36:58 +0000 (UTC)
X-FDA: 83740990116.22.FDF8E71
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 111DA140002
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:36:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QQ8Q5dnW;
	spf=pass (imf23.hostedemail.com: domain of 3N2CRaAkKCIg46pm34mzys00sxq.o0yxuz69-yyw7mow.03s@flex--sudarsanm.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3N2CRaAkKCIg46pm34mzys00sxq.o0yxuz69-yyw7mow.03s@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754357817; a=rsa-sha256;
	cv=none;
	b=4U97hyBASqlR7APdjCkLB/RYHv08UqSn6YmmkjTl89W2RFDwdqeBt+olMEb/FGRhH8Nqye
	0jPpGyBNh2BGW/+TYxmQjilvmRjpstzLL/AU2f3uM8msCdwUJ2YUC/+kgdkfrgdob0sokf
	RRf+9BwNSPnUjXROU9ORsTSLwc6X1LY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QQ8Q5dnW;
	spf=pass (imf23.hostedemail.com: domain of 3N2CRaAkKCIg46pm34mzys00sxq.o0yxuz69-yyw7mow.03s@flex--sudarsanm.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3N2CRaAkKCIg46pm34mzys00sxq.o0yxuz69-yyw7mow.03s@flex--sudarsanm.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754357817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EWDIRG94rF/jhpzQYk9pekkna8f6TwTEVOGNiOzScoU=;
	b=bUhlZ3w5J9F4DhxBPI86DnT/JKK/i3/tB8SPzeKRdJ944A9FAqgi0pC2QqJ9SMKEGF3/ux
	aZTHeWdVzQIQiX5tJWfE0avhWLWaGyjIy6BHttXVplTjMa/e7ZTfSogZdr7gnQ8/rZr6HM
	A6QcaNBEUopDDnB/FMRxDXXdocIXY5s=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bd757bbccso3421690b3a.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 18:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754357816; x=1754962616; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=EWDIRG94rF/jhpzQYk9pekkna8f6TwTEVOGNiOzScoU=;
        b=QQ8Q5dnW++O85dZO2X50Bnl+ZckM2VfjQV7Op9op1Zqn5QlAk5vwmWCjwokvfWhZBG
         qXRwOVYyOD6jP1qkJIet5uf8TnMsU8Ska7F90GaeiXDN2odeWlQ5jwzQThTqz4rDCe0F
         qt/09l8btg99NFWk7tTzhi9/g1t/Y+sBDiPJSy4qGPS8q+QoXSr/NgIeOykm1WL5n7k+
         jKmbp1sCPwt7PKxCIK0V8ELCI+ZWHz0oWyYUC9RxXaxoIMwrhg1NvnUdeWIEhk4tzj28
         DHU4NZSk/EvJtV5UfxQd5LSOu8OjvPDyzCE5JCrZSMkndr5M004UO8nq4qY+rYTL+riW
         xQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754357816; x=1754962616;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EWDIRG94rF/jhpzQYk9pekkna8f6TwTEVOGNiOzScoU=;
        b=hYXIFHB0lFEWvJKT5bzLGkOklKWAMOtS7SWo8KQ9/8DDM2HZh5hpuDXmtIjC1vbamj
         YLYKBm8oi56FG1ggPLHs/+CZzF5plDwLeuVjm1JI7DNTBJkgN7wQBYcrIg1UzkcL7ls6
         PlE4L5SpNHEl7ljGfdlX49vPFNa8zd0r2NdMWSQ1jAEA3eZRKUWZXVHVicW4EHWKtmf5
         52easAHyeHAKdHzf+EDLDF+07TxqdRiyw+oiADFYzrnmr6NUKUQY6ZJ3Lq6GUH0hsWUS
         JL4U2J3L94BTa0Ia3Di+8ciMLh8uC7MyhN4boGAscvyiBHA7Wxl77fGV2ER/obDshJs2
         qMYA==
X-Forwarded-Encrypted: i=1; AJvYcCXvQzhq81AalKhW6HmWsvqs5zmSOmMFu3UyYTS61pqGYELGP9rbW9uNq1YU+1gYcmnAFrsp5jD+Hg==@kvack.org
X-Gm-Message-State: AOJu0YzES89TeFK5Re2t0eAdEOhA9KbxrzZ0JBJEERd9/C6gRAEB/J0S
	draA6/VVVgyOTPAq0KkMetlzaFe+ZBEt4nLmgTlImNDNl6TO0AMSzRKxZxb/9zYEVIV4nDLOwyu
	P6febdq8a50/pPEKR6Q==
X-Google-Smtp-Source: AGHT+IEP4Ogt0yYMTIBcyMkZVXGHn1+5yaxjZGFBUoanUVK2ZcSy/N7vLmJir+3zYOINgjYWp9TiiN0hN/ltZ0Y=
X-Received: from pgdq17.prod.google.com ([2002:a63:9811:0:b0:b2b:f469:cf78])
 (user=sudarsanm job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:7287:b0:240:27c:fcc6 with SMTP id adf61e73a8af0-240027d0352mr9585169637.42.1754357815911;
 Mon, 04 Aug 2025 18:36:55 -0700 (PDT)
Date: Mon,  4 Aug 2025 18:36:29 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805013629.47629-1-sudarsanm@google.com>
Subject: [PATCH v3] selftests/mm: pass filename as input param to VM_PFNMAP tests
From: Sudarsan Mahendran <sudarsanm@google.com>
To: linux-kselftest@vger.kernel.org, David Hildenbrand <david@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	trivial@kernel.org, Sudarsan Mahendran <sudarsanm@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 111DA140002
X-Stat-Signature: x9wn1qk41j3t4u97joqq6scjuag9yzku
X-HE-Tag: 1754357816-654919
X-HE-Meta: U2FsdGVkX1/5Ho2iUiLmHLgdRPF4ln0O4o+vEKLoOGzqQMJbqG24xSlyv2efuypTuEMb/Ny0KHQka4+CK90uxuCNMQJS+yo3tHxIsVNeb1KgDefoUvN0q/Rm71hmLfOqkE+KqlX0+m2N7K0fxjtdCO6z7u2FOQhxi/v0DWe2sBjSdt560AESkVQID1DC+S2+k0Bg4ciAJjY2UOsIXryF6gSc268gfuslhHgTFWANK93ApOQ6qVEi507ZJrhOAhoornNNoVzvcUdbhTfDCCqrt4YtFsTUEQoxXZ/VANfF8yZy1NxTrL3NB8/E5n54iT4/iAft2W4fq3Zv2HDN7v3Hv0HLkJICxHNmRxFjlCPmyIPCw1/I+XvgPDPPaPPB3EsRoxIMPKb4Sy75MgPj4jKW6wSOkgy1qa4D0xp0Eceq3jEwqRw/51L+XkR8W9uv2+Ni9HZ8XHz2W+RzGdXgOdjQ89M6nEfzX7qE9yI+0W51lZN6U6yDZpt8cWwGvvnMkkVD82U3BdeZyLeOZpsotahp9ROCVcLw+gZhlOrFnDJyrud5eFieyF7O1O6s3oNLNX/ojpCvvpVLts1osaJJ1gynOPAMeLnFxApZciC+VxDRHc3+2h4zbR7OQ9PredDscvUE9XS6rC8UJIouUfsH7DPFW+akaEtQSl+/paXxpspf3oUC0Qr2zmURecUxLnLWa2ahqmQP/iYQukA51KBK3awnX0dIlvYtW3COCR2QrVpdU2mbikRyLz9AXuB5nUdycQuMn2MEBx/nqoRoyXNmbRAe8LaIR0sN9+mhbWNOHccbdQhh4ru9t3UHzcgjeRMS3xGlEqg9dCtTpQbmXoFgpwwuGIqJbJAt7yI7eDLuYHGG1qbsLdTp1k12p/O6kuqe4xQs7Lu4dyWHu0kgnIzzuq94u43/OdWdKz6XjNVVSxIS5G5gekITzBGsKsvUyuzicT290S8DYVsozmztt3UWewR
 iJfgjKeF
 /vQ+M9Jo9ezriNlRdX7MMKwrPTi+fwzQmxBT8n5vHiJObRJV0M4EmjqvJVj8e2RtbhCRIovSRB3V2uaGz4GDQzzliQ6dtGVlzmCweTeNJEBMr+v6IFQxByMTTdO1iaCyyNMwf3xibsZ3c5XcYxLN53zFPKu0XN2ZM+XQUwQN3lDP9g2N2kO9g4i6O77VwasqivrK2u99OKCnuKjl40GE4xnz96X6PFnbCe2TZ/aMM5tP2kkyJs16l6kPZy0HWn/D8tSne0XHGYcZnxS7Q1JjENHEckd47quopyoLhrxPmHnXo9Nb70ZiGSx/aH2dWcHeC0dDa9ez9RLqqeq93mM2nheU4W+Y99aB7qui3Ib0nSheA9qBjqJTXAXcMfsG8MEpkeACReZ1DH5IbUHq5hpRrozBIqrE1qKPA5uTFrwKB/bmMgtzw7YC8reiqFRojY2+q3sVLAkL5nO83+aX94ffN1CyQUDMdjtXJnIR2i6Q6ufuWjaub/zUcq7+jAIBBiXvYTMTz5SXKA/GuRkjsC81gHtQKQ78ml3Af0bdVMdEoj1+ZtTP2FIuRYyj+jBkCfzTkMbn1srwCpiwHZ+9r2XD147tvwBloUuYRUNvtnZxCiMg1Qio=
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
	pfnmap -r pfnmap.madvise_disallowed -- randfile.txt
	TAP version 13
	1..1
	# Starting 1 tests from 1 test cases.
	#  RUN           pfnmap.madvise_disallowed ...
	#      SKIP      Invalid file: 'randfile.txt'. Not pfnmap'ed

Signed-off-by: Sudarsan Mahendran <sudarsanm@google.com>
---

v2 -> v3:
* Add check_vmflag_pfnmap func
* Re-use existing check_vmflag_io func
* Verify pfnmap using mmap addr
* Rename phys_addr to offset

v1 -> v2:
* Add verify_pfnmap func to sanity check the input param
* mmap with zero offset if filename != '/dev/mem'

---
 tools/testing/selftests/mm/pfnmap.c  | 48 ++++++++++++++++++++--------
 tools/testing/selftests/mm/vm_util.c | 14 ++++++--
 tools/testing/selftests/mm/vm_util.h |  1 +
 3 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/mm/pfnmap.c b/tools/testing/selftests/mm/pfnmap.c
index 866ac023baf5..88659f0a90ea 100644
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
@@ -51,7 +53,7 @@ static int test_read_access(char *addr, size_t size, size_t pagesize)
 	return ret;
 }
 
-static int find_ram_target(off_t *phys_addr,
+static int find_ram_target(off_t *offset,
 		unsigned long long pagesize)
 {
 	unsigned long long start, end;
@@ -91,7 +93,7 @@ static int find_ram_target(off_t *phys_addr,
 		/* We need two pages. */
 		if (end > start + 2 * pagesize) {
 			fclose(file);
-			*phys_addr = start;
+			*offset = start;
 			return 0;
 		}
 	}
@@ -100,7 +102,7 @@ static int find_ram_target(off_t *phys_addr,
 
 FIXTURE(pfnmap)
 {
-	off_t phys_addr;
+	off_t offset;
 	size_t pagesize;
 	int dev_mem_fd;
 	char *addr1;
@@ -113,23 +115,31 @@ FIXTURE_SETUP(pfnmap)
 {
 	self->pagesize = getpagesize();
 
-	/* We'll require two physical pages throughout our tests ... */
-	if (find_ram_target(&self->phys_addr, self->pagesize))
-		SKIP(return, "Cannot find ram target in '/proc/iomem'\n");
+	if (strncmp(file, "/dev/mem", strlen("/dev/mem")) == 0) {
+		/* We'll require two physical pages throughout our tests ... */
+		if (find_ram_target(&self->offset, self->pagesize))
+			SKIP(return,
+				   "Cannot find ram target in '/proc/iomem'\n");
+	} else {
+		self->offset = 0;
+	}
 
-	self->dev_mem_fd = open("/dev/mem", O_RDONLY);
+	self->dev_mem_fd = open(file, O_RDONLY);
 	if (self->dev_mem_fd < 0)
-		SKIP(return, "Cannot open '/dev/mem'\n");
+		SKIP(return, "Cannot open '%s'\n", file);
 
 	self->size1 = self->pagesize * 2;
 	self->addr1 = mmap(NULL, self->size1, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->phys_addr);
+			   self->dev_mem_fd, self->offset);
 	if (self->addr1 == MAP_FAILED)
-		SKIP(return, "Cannot mmap '/dev/mem'\n");
+		SKIP(return, "Cannot mmap '%s'\n", file);
+
+	if (!check_vmflag_pfnmap(self->addr1))
+		SKIP(return, "Invalid file: '%s'. Not pfnmap'ed\n", file);
 
 	/* ... and want to be able to read from them. */
 	if (test_read_access(self->addr1, self->size1, self->pagesize))
-		SKIP(return, "Cannot read-access mmap'ed '/dev/mem'\n");
+		SKIP(return, "Cannot read-access mmap'ed '%s'\n", file);
 
 	self->size2 = 0;
 	self->addr2 = MAP_FAILED;
@@ -182,7 +192,7 @@ TEST_F(pfnmap, munmap_split)
 	 */
 	self->size2 = self->pagesize;
 	self->addr2 = mmap(NULL, self->pagesize, PROT_READ, MAP_SHARED,
-			   self->dev_mem_fd, self->phys_addr);
+			   self->dev_mem_fd, self->offset);
 	ASSERT_NE(self->addr2, MAP_FAILED);
 }
 
@@ -246,4 +256,14 @@ TEST_F(pfnmap, fork)
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
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 5492e3f784df..2cebe4212db8 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -402,7 +402,7 @@ unsigned long get_free_hugepages(void)
 	return fhp;
 }
 
-bool check_vmflag_io(void *addr)
+static bool check_vmflag(void *addr, const char *flag)
 {
 	char buffer[MAX_LINE_LENGTH];
 	const char *flags;
@@ -419,13 +419,23 @@ bool check_vmflag_io(void *addr)
 		if (!flaglen)
 			return false;
 
-		if (flaglen == strlen("io") && !memcmp(flags, "io", flaglen))
+		if (flaglen == strlen(flag) && !memcmp(flags, flag, flaglen))
 			return true;
 
 		flags += flaglen;
 	}
 }
 
+bool check_vmflag_io(void *addr)
+{
+	return check_vmflag(addr, "io");
+}
+
+bool check_vmflag_pfnmap(void *addr)
+{
+	return check_vmflag(addr, "pf");
+}
+
 /*
  * Open an fd at /proc/$pid/maps and configure procmap_out ready for
  * PROCMAP_QUERY query. Returns 0 on success, or an error code otherwise.
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b8136d12a0f8..ec1f61f30fe7 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -84,6 +84,7 @@ int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
 unsigned long get_free_hugepages(void);
 bool check_vmflag_io(void *addr);
+bool check_vmflag_pfnmap(void *addr);
 int open_procmap(pid_t pid, struct procmap_fd *procmap_out);
 int query_procmap(struct procmap_fd *procmap);
 bool find_vma_procmap(struct procmap_fd *procmap, void *address);
-- 
2.50.1.565.gc32cd1483b-goog


