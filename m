Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216A3C88E4A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4CD6B008A; Thu, 10 Sep 2026 20:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CB16B008C; Thu, 10 Sep 2026 20:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2BB6B0092; Thu, 10 Sep 2026 20:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7891D6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:57:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B995120676
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:57:19 +0000 (UTC)
X-FDA: 85199667798.30.255C165
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 608C880002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:57:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V+Fhx1i6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 361GjagoKCHgfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=361GjagoKCHgfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V+Fhx1i6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 361GjagoKCHgfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com designates 209.85.215.199 as permitted sender) smtp.mailfrom=361GjagoKCHgfpdkqcdpkjckkcha.Ykihejqt-iigrWYg.knc@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789088237;
	b=n3f6UKwq+RARU+rf0gb8CazZMtXnf45oqjUrPCe6NttJQ5zBPdpjkQAY7h9LPvLyecBOA9
	F70wLT93OATtoIG3NuVyKv+q9yVsQJ6Z/2w+e7Uh85D/WgWt8bG8muIulSx9Y9fKqTfO1w
	Qho5R6NJavXBSlwBkdb5pkUUPhP0e1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789088237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzHPSAfDKEGwk2Qc7G8mI5v1r85OJoGxqZO5j5dMqa4=;
	b=fcZn3sNdXGfq3vfWlW024vLPomwz1TgX5BUS4xkdShGVeQ8ZEaDtB1clhyN8Yt+Go+R/zd
	UvG2FNQQDqGUM05VofgKL5S5ghtz4JpZ/fnw5vIayjF+4ge/xZB5zFwtrmgHnaW9KDn4Pq
	U7o4fSBpwL6+yVBRz2X3ZZdMPtkIOOA=
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1a439db36so373976a12.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789088236; x=1789693036; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CzHPSAfDKEGwk2Qc7G8mI5v1r85OJoGxqZO5j5dMqa4=;
        b=V+Fhx1i6wdZOSpiBS1ZAfP2kx12FEqQ1GJ0BykRqGMoT3AnAY00A6Ow/kRfet5SCQu
         A3uPeoEnEkxjNoWXZ5S5KeNJR9AvoOVBYjesMJjo8roAB85FD2iCmFFNu88a/tuRX+6x
         mjaC+DV6JPFLSN+xDYFe706gNTPGq6+KRSdNcT6YGPr8pdgfgWhuTL/4yJEGTXltTcTE
         Cox9R8VIcaedtTlBwDAe0cZPojbIVYVG+NrBjm2CboduMc3BZ/8b2ZHwmmWl3jR76ORQ
         PoyeDcN6vA1aBxpAVSwHfAABhgBFRYNxyfJK+I3OEV9hBXUobUMiDZ0gRkYBbDwjHiGK
         vhwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789088236; x=1789693036;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CzHPSAfDKEGwk2Qc7G8mI5v1r85OJoGxqZO5j5dMqa4=;
        b=qyUGqgerrIk8Bu6NYzZWEXcDbkBjSgCwBvqBZd9e5PmHIa4s/9wBtlFUxrzbOhmwpS
         /BHL3xzvV4ZeyoPpXuvM51tyxC4aHfcWsyhQ/5VSRS7TpLfxyWMmyfyR6XMB8tlVbaKs
         ANTSQVKZAk7k0LM7fhIUooi8x337IkjI3+1b/lw9HYDT9ykwu9SaMdOky3FvJhRCX+IX
         H04jOti7+pjUBdix7Cg8aLOIs1r2yftYC3rYvwtT1xohyjgHcwgwBgtrLqJnP1XMMMPT
         vJWyKvb51OlLCz/u210ekRh52lCl6mPq/durUzeIWubkZ8YSONie5M7kJpexpfNVxvSB
         WcdA==
X-Forwarded-Encrypted: i=1; AKwUvBwrPeLIhz9g0N0ruLR3sLe/oRShDt8jo8kEOf9PX/GTEcrlhtnNH3PpZjsx+cB4j2u4oGZEWeXUSQ==@kvack.org
X-Gm-Message-State: AFuF++nsFLD2N3ipTRVp+SdJsU3CC4I/DgewmynSA4kTC39PC5nXFRVX
	f8CRytpsuDXEjfePdCOlkL4iYdPJVd1rjEx9BfFZjy1BMN0fmg7C8rMpwS5j7s54qq3bHIAncDN
	N2kIX25UUjIKho1Yxxo2RkQ==
X-Received: from pjbhj5.prod.google.com ([2002:a17:90b:40c5:b0:39d:a25b:58bc])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:570b:b0:398:9be9:ab92 with SMTP id 98e67ed59e1d1-39d9c3521ecmr2312066a91.23.1789088235766;
 Thu, 10 Sep 2026 17:57:15 -0700 (PDT)
Date: Fri, 11 Sep 2026 00:57:15 +0000
In-Reply-To: <20260911000300.1052582-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260911000300.1052582-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911005715.1189347-1-jthoughton@google.com>
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: akpm@linux-foundation.org
Cc: baohua@kernel.org, baolin.wang@linux.alibaba.com, david@kernel.org, 
	dev.jain@arm.com, hughd@google.com, jthoughton@google.com, kas@kernel.org, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, shy828301@gmail.com, usama.arif@linux.dev, 
	ziy@nvidia.com, zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 608C880002
X-Stat-Signature: 5erxurnhji3n7jx5pkcoou1ncdomiroy
X-Rspamd-Server: rspam01
X-HE-Tag: 1789088237-568163
X-HE-Meta: U2FsdGVkX18473WmZi3CqdF+fSApHABtFENnWJITxfPtn2V03hEz/aXaeNiJJ/3vki+fH0grlGsvyAC8k4Dki7/BO6DUN4uDnaGEx70FDV93hUXg0w/jRB2mYKZTUTwU96zB5kx8bkSxtxiul7Ab2lTI1vVCxFyzJ5RvM72OqfXEZqg596DGYToe5AWEtlynzXWdc4L7F96ET1HWb+a0Vl0j61ZDR3OnwaIuqrO9vW1BXQMHR3YT/Vr75GXKAAPt9W2kHzY5j4BcphlZmXLL1oL1QfYfuZ/6dc8/HeFl9UNVE5HQ/0pGL62RJN9oz17nNozDlDQH07dDLlak5v9HxEUBPt9s5e+qwEu6evG3ZUDNO8gqfMsJO4ygo5+MSvDMGxZmlHcF2blX41VMpgbdhcgM3LBjEIv0VNxd2MtsuZ3KoxZr+eg4g7RrAZU5WUAM3xhj7QSXiKBF84sOha22FsRA4DZLg5e/q0z0QrV79YAo3M5Mj++V60EX9Wect6gpjOLMycDXIKNafdnYt2jiT/n2ENWh84v17dCfl6kI74OxCNizFHe8e6xloDCwklePxZf6BCd2tzlg2GrpzwDE4QiecrRo3YPqSXIOP1wHbq6Tug59C/WbSpUl7sfBb+IyCX34h2mZXyqky7tFKzH03P+64WP1eU5JtseOOduRLsLk3LIa/moG5FjXfSvYS6qaykDP0jo4tMt8rQzpySeygEwLL2ED1kBtcGs/IE9fW8K1DHlSGVPWFu/ClRiZWJVaaBQs+oYPn3oYROStPX45ITslZZLmOlzuumk5ht8dFIFdPjTTXWw7FGTqyUkpfgzZmpkxHs+69aSV6QkYPB5cXTfBlwDeNkoRnPlj9o5w7DgOpznUHDkDEzYZcCAh6r9K2DNy4dvC6TNRGlIZcYkU7XQQjFBmZWdk4ZksH8/1CzDbhQfWHy1iCCXxd8UV0/Y3u9XLrt1/5XiB4L3T6+Y
 150drB3r
 H//GX9WGcv7EISJyk2pFggYwVTQCQRvtmYF/dXE/XJBY+0Fvpkhi/HwRPAanA5F+q3HP6ftwxlFFztRNyOomsLmzUYIwJRz3eao0HaQBqTq1ls7aw4i8Ouaj51g2YtU+gWc1aHMfE2mtYzXAzTqSZ0eS48XCvA2nPl4AUQUWWXSE6tb3E3JlRKJ5JlpgQVAc3B/bhOTHd2CFUA84hkXhCwARCmqkmdgjVHfAEJ3Dg0stuMMWzUO8DGz3JEIx8CxusvVJP+ulMqz9yoQgRqv80QViazlaA0g0RqOO5TsUKStJ7UBY7nZbfF3q71O/jYYplu2b0IpKxP6ouWwgdiqiTUOFad77ef45l/Huf3iYTxTMO7N1JsKN4kjuNoj5duCP5op8qpZsC2TGvQ40kqm7CpbUY3WzuqY/f5y3uu/VJk7haTQKQg3M4hgtGgYQhuTJkSo8t4ths5WDKpy5ulHhZ5uwGE9DKrm8oos0eqUgvuQlLoxousKS6jri7c0rC46kSLl6kt3uyTnaQJYGzZnbF78cyr5JaMUnYB5q1FimAVDKNlDLA2KdE7bWdIzqGCgzByws7c10eHum87d7FHfePXHc81zZFHQ+ZfDv5YAnQVUrUs57m4rzPa42qsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Okay so it appears to be a real bug. Here's a diff of what I think would fix it,
though I haven't tested it. I've also included an AI-generated selftest that
checks the behavior when you MADV_COLLAPSE a VMA that maps a shmem file that
had a THP and got truncated.

I'm happy to send this patch on its own to see what others think. I'll test it
properly tomorrow.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e6947fe142ee..db660cd9d75d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1863,6 +1863,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, pgt_pmd;
 	spinlock_t *pml = NULL, *ptl;
+	pgoff_t file_end;
 	int i;
 
 	mmap_assert_locked(mm);
@@ -1901,6 +1902,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (userfaultfd_minor(vma))
 		return SCAN_PTE_UFFD;
 
+	/* Do not map pages past the end of the file. */
+	file_end = DIV_ROUND_UP(i_size_read(file_inode(vma->vm_file)), PAGE_SIZE);
+	if (linear_page_index(vma, haddr) + HPAGE_PMD_NR > file_end)
+		return SCAN_TRUNCATED;
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (IS_ERR(folio))
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e30..794636dfa485 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += collapse_truncate
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/collapse_truncate.c b/tools/testing/selftests/mm/collapse_truncate.c
new file mode 100644
index 000000000000..dd3415c51246
--- /dev/null
+++ b/tools/testing/selftests/mm/collapse_truncate.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test creating a 2M tmpfs file, mapping it 2M-aligned, MADV_NOHUGEPAGE,
+ * writing to each page, truncating 4K off the file, MADV_COLLAPSE, and
+ * attempting to read from the truncated 4K.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <setjmp.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include <sys/syscall.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+
+#ifndef MADV_NOHUGEPAGE
+#define MADV_NOHUGEPAGE 15
+#endif
+
+#ifndef MADV_HUGEPAGE
+#define MADV_HUGEPAGE 14
+#endif
+
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
+#ifndef MFD_CLOEXEC
+#define MFD_CLOEXEC 0x0001U
+#endif
+
+#ifndef __NR_memfd_create
+#if defined(__x86_64__)
+#define __NR_memfd_create 319
+#elif defined(__aarch64__)
+#define __NR_memfd_create 279
+#elif defined(__i386__)
+#define __NR_memfd_create 356
+#endif
+#endif
+
+#define SIZE_2MB (2 * 1024 * 1024UL)
+#define PAGE_SIZE_DEFAULT 4096UL
+
+static inline int sys_memfd_create(const char *name, unsigned int flags)
+{
+#ifdef SYS_memfd_create
+	return syscall(SYS_memfd_create, name, flags);
+#elif defined(__NR_memfd_create)
+	return syscall(__NR_memfd_create, name, flags);
+#else
+	return memfd_create(name, flags);
+#endif
+}
+
+static sigjmp_buf jmpbuf;
+static volatile sig_atomic_t got_sigbus;
+static volatile sig_atomic_t got_sigsegv;
+
+static void sig_handler(int sig, siginfo_t *si, void *unused)
+{
+	if (sig == SIGBUS)
+		got_sigbus = 1;
+	else if (sig == SIGSEGV)
+		got_sigsegv = 1;
+	siglongjmp(jmpbuf, 1);
+}
+
+static void setup_sighandlers(void)
+{
+	struct sigaction act = {
+		.sa_sigaction = sig_handler,
+		.sa_flags = SA_SIGINFO | SA_NODEFER,
+	};
+	sigemptyset(&act.sa_mask);
+	if (sigaction(SIGBUS, &act, NULL))
+		ksft_exit_fail_msg("sigaction(SIGBUS) failed: %s\n", strerror(errno));
+	if (sigaction(SIGSEGV, &act, NULL))
+		ksft_exit_fail_msg("sigaction(SIGSEGV) failed: %s\n", strerror(errno));
+}
+
+static void test_collapse_truncate(bool clear_nohugepage)
+{
+	unsigned long hpage_size = read_pmd_pagesize();
+	unsigned long page_size = psize();
+	size_t truncated_size;
+	const char *test_name;
+	int fd, collapse_ret, collapse_err;
+	void *res, *p;
+	uintptr_t addr, aligned_addr;
+	bool read_succeeded = false;
+	char val = 0;
+
+	if (!hpage_size)
+		hpage_size = SIZE_2MB;
+	if (!page_size)
+		page_size = PAGE_SIZE_DEFAULT;
+
+	truncated_size = hpage_size - page_size;
+	test_name = clear_nohugepage ?
+		"collapse_truncate (clear MADV_NOHUGEPAGE)" :
+		"collapse_truncate (with MADV_NOHUGEPAGE)";
+
+	ksft_print_msg("[RUN] %s\n", test_name);
+
+	/* 1. Create a 2M tmpfs file */
+	fd = sys_memfd_create("collapse_truncate_tmpfs", MFD_CLOEXEC);
+	if (fd < 0) {
+		ksft_test_result_skip("- %s: memfd_create failed: %s\n",
+				      test_name, strerror(errno));
+		return;
+	}
+
+	if (ftruncate(fd, hpage_size) < 0) {
+		ksft_print_msg("ftruncate to %lu failed: %s\n", hpage_size, strerror(errno));
+		close(fd);
+		ksft_test_result_fail("- %s: initial ftruncate failed\n", test_name);
+		return;
+	}
+
+	/* 2. Map it such that the mapping is 2M-aligned */
+	res = mmap(NULL, 2 * hpage_size, PROT_NONE,
+		   MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (res == MAP_FAILED) {
+		ksft_print_msg("reservation mmap failed: %s\n", strerror(errno));
+		close(fd);
+		ksft_test_result_fail("- %s: reservation mmap failed\n", test_name);
+		return;
+	}
+
+	addr = (uintptr_t)res;
+	aligned_addr = (addr + hpage_size - 1) & ~(hpage_size - 1);
+	munmap(res, 2 * hpage_size);
+
+	p = mmap((void *)aligned_addr, hpage_size, PROT_READ | PROT_WRITE,
+		 MAP_SHARED | MAP_FIXED, fd, 0);
+	if (p == MAP_FAILED) {
+		ksft_print_msg("aligned mmap failed: %s\n", strerror(errno));
+		close(fd);
+		ksft_test_result_fail("- %s: aligned mmap failed\n", test_name);
+		return;
+	}
+
+	/* 3. MADV_NOHUGEPAGE the mapping */
+	if (madvise(p, hpage_size, MADV_NOHUGEPAGE) < 0) {
+		ksft_print_msg("madvise(MADV_NOHUGEPAGE) failed: %s\n", strerror(errno));
+		munmap(p, hpage_size);
+		close(fd);
+		ksft_test_result_fail("- %s: madvise(MADV_NOHUGEPAGE) failed\n", test_name);
+		return;
+	}
+
+	/* 4. Write to each page of the mapping */
+	for (size_t offset = 0; offset < hpage_size; offset += page_size) {
+		*(volatile char *)((char *)p + offset) = 'A';
+	}
+
+	/* 5. Truncate 4K off the file */
+	if (ftruncate(fd, truncated_size) < 0) {
+		ksft_print_msg("ftruncate to %lu failed: %s\n", truncated_size, strerror(errno));
+		munmap(p, hpage_size);
+		close(fd);
+		ksft_test_result_fail("- %s: ftruncate -4K failed\n", test_name);
+		return;
+	}
+
+	/*
+	 * If clear_nohugepage is requested, clear VM_NOHUGEPAGE using
+	 * MADV_HUGEPAGE to allow MADV_COLLAPSE to proceed without EINVAL.
+	 */
+	if (clear_nohugepage) {
+		if (madvise(p, hpage_size, MADV_HUGEPAGE) < 0) {
+			ksft_print_msg("madvise(MADV_HUGEPAGE) failed: %s\n", strerror(errno));
+		}
+	}
+
+	/* 6. MADV_COLLAPSE the mapping */
+	collapse_ret = madvise(p, hpage_size, MADV_COLLAPSE);
+	collapse_err = (collapse_ret == 0) ? 0 : errno;
+	ksft_print_msg("madvise(MADV_COLLAPSE) ret=%d (errno=%d: %s)\n",
+		       collapse_ret, collapse_err,
+		       collapse_ret == 0 ? "Success" : strerror(collapse_err));
+
+	if (collapse_ret == 0) {
+		bool is_huge = check_huge_shmem(p, hpage_size, 1, hpage_size);
+		ksft_print_msg("check_huge_shmem: %s\n",
+			       is_huge ? "huge PMD mapped" : "not huge PMD mapped");
+	}
+
+	/* 7. Attempt to read from the last 4K (the one that was truncated) */
+	got_sigbus = 0;
+	got_sigsegv = 0;
+
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		val = *(volatile char *)((char *)p + truncated_size);
+		read_succeeded = true;
+	}
+
+	if (read_succeeded) {
+		ksft_print_msg("Read from truncated 4K succeeded without SIGBUS! val=0x%02x ('%c')\n",
+			       (unsigned char)val, val ? val : ' ');
+		/*
+		 * Accessing beyond EOF of a file-backed mapping MUST result
+		 * in SIGBUS. If the read succeeded, a huge PMD erroneously
+		 * mapped beyond the end of the file.
+		 */
+		ksft_test_result_fail("- %s: read beyond EOF succeeded without SIGBUS (PMD mapped past EOF)\n",
+				      test_name);
+	} else if (got_sigbus) {
+		ksft_print_msg("Caught SIGBUS on reading truncated 4K page as expected\n");
+		ksft_test_result_pass("- %s: SIGBUS received on reading truncated page\n",
+				      test_name);
+	} else if (got_sigsegv) {
+		ksft_print_msg("Caught unexpected SIGSEGV on reading truncated 4K page\n");
+		ksft_test_result_fail("- %s: caught SIGSEGV instead of SIGBUS\n",
+				      test_name);
+	} else {
+		ksft_test_result_fail("- %s: unknown error reading truncated page\n",
+				      test_name);
+	}
+
+	munmap(p, hpage_size);
+	close(fd);
+}
+
+int main(int argc, char *argv[])
+{
+	int opt;
+	bool run_all = true;
+	bool only_nohugepage = false;
+	bool only_clear = false;
+
+	while ((opt = getopt(argc, argv, "nc12h")) != -1) {
+		switch (opt) {
+		case 'n':
+		case '1':
+			only_nohugepage = true;
+			run_all = false;
+			break;
+		case 'c':
+		case '2':
+			only_clear = true;
+			run_all = false;
+			break;
+		case 'h':
+			printf("Usage: %s [-n|-1] [-c|-2] [-h]\n", argv[0]);
+			printf("  -n, -1: Run only test with MADV_NOHUGEPAGE retained\n");
+			printf("  -c, -2: Run only test with MADV_NOHUGEPAGE cleared before collapse\n");
+			printf("  -h:     Show this help message\n");
+			return 0;
+		default:
+			return 1;
+		}
+	}
+
+	ksft_print_header();
+	ksft_set_plan(run_all ? 2 : 1);
+
+	setup_sighandlers();
+
+	if (run_all || only_nohugepage)
+		test_collapse_truncate(false);
+	if (run_all || only_clear)
+		test_collapse_truncate(true);
+
+	ksft_finished();
+}

