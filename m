Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63DEDCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171406B008A; Wed, 14 Oct 2026 13:58:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC876B0098; Wed, 14 Oct 2026 13:58:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3AB6B008A; Wed, 14 Oct 2026 13:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEFE36B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FCFE140708
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:09 +0000 (UTC)
X-FDA: 85321990698.21.39BB9EE
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6101940016
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WJiogpjv;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bK/BWDZAO2OK/KTNrMPySMyjNClCeAdL4aMTxK9K6Oc=;
	b=tu3jy2bC9l+43k+C93Hjeg4NhWgqhoZkWrkaIY3iOf55gMTgG6kA2MVAm5bLkCRnUYRDXd
	N/mr0eKp/ZHdghOnSx2GVDVCplDW+0KsLQqhczacVDvvY2bv6dJH4U6GJszl9kp2O/yrXo
	ewEuwjakCrzeixHIpaYc6+vlRDfNKts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WJiogpjv;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.44 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000687;
	b=dUAVYScuaLwjkrc/t/XZSMFOpDUptqld0OAZUugDJ1KTw7FLRNrgtjISve0xkbaEJl/HbJ
	JpGu4z+ACciovf2bFF49eB6w85psLBKZa2dmVL5xQEfbc6D6crGs7+Rfdq/DD3hyVhJ4qa
	1hz2UM+CNwBl1uLiZcAnwQfxPSI7HPU=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-917ad52d7b6so7342046d6.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000686; x=1792605486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bK/BWDZAO2OK/KTNrMPySMyjNClCeAdL4aMTxK9K6Oc=;
        b=WJiogpjv1f1bM3EiWLUTb0fufSeGqPvDm7DUTfm7IsMx3VwER9lcJswMSxKTjDCTTk
         soPK2NOVHP/Nm5lbeO+knMwQSprXkDn6yQjDDNV3slNRhQUAUTMrPuyZQwStIyH5Ih9b
         xOkPUM5hDZB8HJasFAre/Q991ZufTepd4caOhtKajggHwofRwgSNzCsgvDGdXnzyXj6I
         DY/uFb1OUCtP77wQtoGpHG5w/+0xgBoWAhE5uGgjL/cSFLIvG1+rYHkaaBQ4KYFx7U/c
         hiV0NVDlVYk76Lxj9Oji8LJI0H2gnmMOa2qfkVlay0frd4I6Si5u8NWhdFvZ5hR5Oqej
         5zFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000686; x=1792605486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bK/BWDZAO2OK/KTNrMPySMyjNClCeAdL4aMTxK9K6Oc=;
        b=KRjIG+Lm86Iyka9Z5vq3eonPP4gyNJz27UMkz6z2lpcAvynPaJJPGF+zjyKQRy933K
         MH8LY3RHVn6oedlOrlBFrdI/B/iXMp29GN/Bztw4W80E67KUOynP5j6a2T3Aa5g2xUUP
         +FhW6Ck/EOhVIRWx2fW+udRPFoUE7LywD7eWmMzxG/ClkppAqhq9f1Xn0eSBb2pG/Bv6
         rhxdte5ECoD8zimcVLI43QC4jZGZyM1BaI/9AqtPjdLIrpGlAm3GDn9NQ6yH58USDg9+
         fEfCNRWzwjLeMcM1Mz5IBa9EkZQLwdXD3HpTe+cyRMTMTCmrd+1XXBr24PKKJU2ACfDc
         BO+Q==
X-Forwarded-Encrypted: i=1; AKwUvBwoErYdaAiCBO1d8jZICwstAO43g9NdQ3kEhoTIeUBUfW1frXU2tjberPblD227CDKnboBVBKXhCQ==@kvack.org
X-Gm-Message-State: AFq9FYLFA5m7blO1UST2N1TVZeq5y3lF2ZLTLpwkHHIges4+uMqcd5DQ
	CPiTVdtPjW6zpi8NT0QCxzcfj9onq/nhO16x7e3fcYFG45Ipu6qORLb161CqE0ULsRU=
X-Gm-Gg: AYBFou2ugZMyBLMQin0mRCRbQ97E5KySPjF65PlQV66B1f8Jxx3VhP0v3lMldP7fEza
	cSLp+B+vv4uHVEfJ5qCfk6r66Kc79NteRstO7674HdVVCZBMkOz8EzX2kqsUlgRjffJaylpxS30
	U7q0mm7BO8dVd9eKEYo1vI2XHMXFkx85QhM+UL2iDbdzaveK6EjOlpzRFRPZhTxOoE4wWEjdgTf
	CUEjeVY8dQLOAFvI9m+vqARZz19i47wMG4T9W/kFGCb9Z4ZHjfp+RO9twCjLm4FC4N2QnEwtoZ/
	yn7Ebm4bgGuqIJC0LcUENLQE2v0ppK0XNW385aibOcQ4VVCrW5DjGEFHAz5m6ECsRcLyWjg8Zv3
	g6/sIoVFFBnD2WBfhr3bGUHoOe1cou8tK8rkWpaXzKFBgLbsXqQKWDcIVKMss1o9HIFni21YzLq
	Ip+B1cN8ZKh/xeuypLylZ0jNNFbPll9O3AYQlysMJXDQu1HkmKdx+nXLOFRLxiE6AjU+tEQVsb9
	jnKTsuJUumWNO/T6D1SNahhD+l8d5oKC5cy0m93fH4Ozm5O0Pb8NVevVjaZ
X-Received: by 2002:a05:620a:1720:b0:93e:c12c:9b69 with SMTP id af79cd13be357-93ec12c9eb7mr2613825985a.68.1792000686355;
        Wed, 14 Oct 2026 10:58:06 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:06 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 1/8] selftests/mm: add MADV_COLD and MADV_PAGEOUT contract tests
Date: Wed, 14 Oct 2026 13:57:49 -0400
Message-ID: <20261014175756.2035176-2-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6101940016
X-Rspam-User: 
X-Stat-Signature: 3br4bzccchfm79niqho31k9ipg4cahn1
X-HE-Tag: 1792000687-455530
X-HE-Meta: U2FsdGVkX18txc86Ax7ee5l15wxsBNegYtjOrfB7eyU1RGA1PFZj+4T3VcC0+26ca1gvCZqpWfBm5YKTbtf+1eMP4eiuKJ2y77ONblJEz2+M0CiBvJoM/kcrnbykU7abnGlQImbYUaN7XEhkijK/oKpQJz4B/yEIdvEXTbOwF5St/KVysYevx84tMGmoLKcP2goBqZ80ZVXE/LwU2nO85i3c7a44pCCfZWW1tMJB3wK62IeycfRxBe/DwAr6wKbFz2WitYlgTxbR+1GQWRH53OxFRA2mahkbPEBCS/4Te77+M3wCQHlUq5KTt5uhqYwytxN7Pjp7iLp4vV6FQObXDXNC3u1992HpGnOhNmPLk5B3EUQADydj93+xzuJ/KcS21mJoJjx/1WPohACIAQ88hSQDYPGkmi3k5aKLV9mcyAf65m7zWdNKi9RzZwseAyxfXr4fLLPIj8zLYIU0Ua6n8yPwN7UuxkMiqxRE+2vaFHQ7bZBdH2QfUDtM5TrnHsctf9lNj2mw0ESjBM8lrzqQLqwAiuxs456JRyXddoyg7b6gBHQ2Xrxnj4egbDr1hk0MgHxB68bvDdVFBbrCR7UMaLsycyipce1l/Sjq9oU0oVXLZrIj2lQ//cXi9Y2SnxCjAhr7EUDuEGg3qwE9ZZiILzUXzI0pf8i6pYviaEA/yc4CoY9KyFTs5nk5lUVMXMjkOIoW9KrvkIL5Vt4t5F1YLIUdHMJuxenqqjZCDc45t4EjsqZooS8mzvXphZY5lKMFPzpoHHsy5aL8y2ZuNtlx7dFYtHSpqxaDOry+b1y8flzpXv952i9uBbga6TeT4iqZDEXHUaf8PcKjJJR8nVVmb0vUSHDBc+TLn7KLG/diu1aPnSecZ1hTsut8In+S64tuv1vMxQj+Dkz/1KlN0EMkA0iHYTOY9dLazd7PMy0/UOTazsaf9df2fLD3M0NaK77oHWPwVcwyvf0I0Mcmw7K
 6T7TgJpp
 OS7cHUweYiXv8j8Cqv21NU49nQswYhmmN0Bpff8DcbFEFg1q6SYiu/duuAMTGm8ndOYfdoeCH8N+Ike0TjS9bPqwWhEhPOsKhydScvifLahsmKb5wbifpoJuj7NjFDc3w86YO5UC8c4RHdGfVeMx4vTtR0lPq46Kt/gtJxkEVFlTDYXWjoBxpDByZBDQOy9UY/cI4Rbty+Z+ww/DsIlL9aPMce8htbzn6En/qhoFtEOjkmihTcO1SqCif+CLnOfxJlolED3f3kVhwuA3OMZzbok7ahKF8uCLuylUW0PLh7RsPSljXwbecSqP1/7LUiSQTHV4A+c+bgxbXik4gFU+G1yyZ0Bog3qfw5Lk+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLD and MADV_PAGEOUT share a page-table walker covering ordinary
PTEs, PTE-mapped large folios and huge PMDs. Existing selftests provide
little coverage of its range, folio-state and permission decisions.

Add a kselftest harness test for both hints, starting with the most basic
behavior userspace relies on: MADV_COLD neither populates a PTE hole nor
faults a swapped page back in, and neither hint may be applied to a locked
VMA.

The swapped-page test skips when swap is unavailable.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/Makefile        |   2 +
 tools/testing/selftests/mm/ksft_madvise.sh |   4 +
 tools/testing/selftests/mm/madvise.c       | 134 +++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh  |   5 +
 4 files changed, 145 insertions(+)
 create mode 100755 tools/testing/selftests/mm/ksft_madvise.sh
 create mode 100644 tools/testing/selftests/mm/madvise.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index beacc0f87304..07d61110eb24 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -69,6 +69,7 @@ TEST_GEN_FILES += hugetlb-shm
 TEST_GEN_FILES += hugetlb-soft-offline
 TEST_GEN_FILES += khugepaged
 TEST_GEN_FILES += madv_populate
+TEST_GEN_FILES += madvise
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_populate
 ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
@@ -156,6 +157,7 @@ TEST_PROGS += ksft_ksm.sh
 TEST_PROGS += ksft_ksm_numa.sh
 TEST_PROGS += ksft_madv_guard.sh
 TEST_PROGS += ksft_madv_populate.sh
+TEST_PROGS += ksft_madvise.sh
 TEST_PROGS += ksft_memfd_secret.sh
 TEST_PROGS += ksft_memory_failure.sh
 TEST_PROGS += ksft_migration.sh
diff --git a/tools/testing/selftests/mm/ksft_madvise.sh b/tools/testing/selftests/mm/ksft_madvise.sh
new file mode 100755
index 000000000000..29cbbca800f2
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_madvise.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t madvise
diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
new file mode 100644
index 000000000000..bb4efb92e6da
--- /dev/null
+++ b/tools/testing/selftests/mm/madvise.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * MADV_COLD and MADV_PAGEOUT tests.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <stdbool.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest_harness.h"
+#include "vm_util.h"
+
+/* Reclaim can fail transiently, so retry for up to a second. */
+#define PAGEOUT_RETRIES 100
+
+static size_t page_size;
+
+FIXTURE(madvise)
+{
+	int pagemap_fd;
+};
+
+FIXTURE_SETUP(madvise)
+{
+	page_size = getpagesize();
+
+	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	ASSERT_GE(self->pagemap_fd, 0);
+}
+
+FIXTURE_TEARDOWN(madvise)
+{
+	close(self->pagemap_fd);
+}
+
+/* Page out the range until its first page is swapped. */
+static bool pageout_until_swapped(struct __test_metadata *_metadata,
+				  char *mapping, size_t size, int pagemap_fd)
+{
+	int retry;
+
+	for (retry = 0; retry < PAGEOUT_RETRIES; retry++) {
+		ASSERT_EQ(madvise(mapping, size, MADV_PAGEOUT), 0);
+		if (pagemap_is_swapped(pagemap_fd, mapping))
+			return true;
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/*
+ * Both hints are best effort, so these tests check what userspace can rely
+ * on: which mappings are accepted, which pages must never be reclaimed, and
+ * that neither hint changes memory contents or populates the range. A test
+ * that needs a page to be reclaimed first checks that reclaim works at all,
+ * and skips if it does not.
+ */
+
+/* Neither hint may populate a hole between two populated pages. */
+static void check_skips_pte_hole(struct __test_metadata *_metadata,
+				 int pagemap_fd, int advice)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, 3 * page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	mapping[2 * page_size] = 1;
+	ASSERT_FALSE(pagemap_is_populated(pagemap_fd, mapping + page_size));
+
+	ASSERT_EQ(madvise(mapping, 3 * page_size, advice), 0);
+	ASSERT_FALSE(pagemap_is_populated(pagemap_fd, mapping + page_size));
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[2 * page_size], 1);
+
+	ASSERT_EQ(munmap(mapping, 3 * page_size), 0);
+}
+
+TEST_F(madvise, cold_skips_pte_hole)
+{
+	check_skips_pte_hole(_metadata, self->pagemap_fd, MADV_COLD);
+}
+
+/* Neither hint may be applied to locked memory. */
+TEST_F(madvise, locked_vma_is_rejected)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	if (mlock(mapping, page_size))
+		SKIP(return, "could not lock a page");
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* Neither hint may fault a swapped page back in. */
+static void check_skips_swapped_pte(struct __test_metadata *_metadata,
+				    int pagemap_fd, int advice)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+	if (!pageout_until_swapped(_metadata, mapping, page_size, pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not swap the page");
+
+	ASSERT_EQ(madvise(mapping, page_size, advice), 0);
+	ASSERT_TRUE(pagemap_is_swapped(pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+TEST_F(madvise, cold_skips_swapped_pte)
+{
+	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_COLD);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a1b45a3dedae..0e6a24659d12 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -53,6 +53,8 @@ separated by spaces:
 	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
 - madv_populate
 	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
+- madvise
+	test madvise(2) MADV_COLD and MADV_PAGEOUT
 - memfd_secret
 	test memfd_secret(2)
 - process_mrelease
@@ -330,6 +332,9 @@ CATEGORY="madv_guard" run_test ./guard-regions
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+# MADV_COLD and MADV_PAGEOUT tests
+CATEGORY="madvise" run_test ./madvise
+
 # PROCESS_MADV test
 CATEGORY="process_madv" run_test ./process_madv
 
-- 
2.56.0


