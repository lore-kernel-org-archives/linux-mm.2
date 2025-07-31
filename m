Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF5CFC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75FB16B009E; Thu, 31 Jul 2025 12:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C0F6B009F; Thu, 31 Jul 2025 12:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA816B00A0; Thu, 31 Jul 2025 12:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9ED6B009E
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:03:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F258B1DBE41
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:41 +0000 (UTC)
X-FDA: 83725030242.08.02A13EA
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1B7051C0020
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XTlO2Afh;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nNsfnv5oOEoHrVu8M1Ul0UCXOUQx26YVPJa+Wwgspps=;
	b=ZTXgg4MU2ahEb8ze2T91SXtQ0e6QZPMHhzp9d2F+NeTwn0FqBvOqRohUW3P53D8JQ/qMj5
	cYmy/fNjtu40i0SfEtCPuFJWV290GEWj1lPai8YlLqZbp6qPO/OK7KSVTcU59O6rfC4rDW
	Jsc6s7kX/TyMf/EFoYLk4b6TrrKvf5E=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=XTlO2Afh;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977820; a=rsa-sha256;
	cv=pass;
	b=K4siYqPegxNJME9QiLWys3C70IIuhrOqLPwPmyunqKnQj0ISPOdraU/9BbJoLDU4IgPjsv
	r6PhdULM31JrWBhwfDWFOfgpl4JQbwjRowVfhhuz+m9kc5wZ2D72XX6aOOzVPYgzOiD50o
	wrlC7btCw2irktIQyGsGEQ8/BmQgia0=
ARC-Seal: i=1; a=rsa-sha256; t=1753977804; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iEVfjkrhIlNGAugbgFyCabDELVet8GzqTY2X6nWM90rubx0LHgFlnh6/IohJGrywKzD8VKMl/eXABP/+cUP1q3imNAwURRm6jAD3NkwpZn53TWIuO7b1+dh23V2P+K3nxYE1rXOrIBQD9DK/V2jsbTX5J7b6wFebmCZBrz+bYxE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977804; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=nNsfnv5oOEoHrVu8M1Ul0UCXOUQx26YVPJa+Wwgspps=; 
	b=cz37pqdSHlICiZWOPkv6Gy+lqmKdFmOvcy3i7ESUm4jWnfebkMT9ajcGt8HxnvpXbnnlfxzgrQyls0vYbT4cujWpiZLa0zEk1bK07/blkK++6WN3TgxftRDAKQNvcZfpqKJbdQYSGmLSob1tm3mw46U9WAQc3BkxFtA1M6sVDSg=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977804;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=nNsfnv5oOEoHrVu8M1Ul0UCXOUQx26YVPJa+Wwgspps=;
	b=XTlO2AfhdGBuUf01q109R44FA2Ye3p1dZraw5yjGh/xsp6aWi43kSFycH9CpGIw8
	SKuV5dyfAL9vvs1ffJHq4uPgaNxrj8OG1G2lZ3c3kn1rmchCIHjQcC9QOWsFcoiDUhP
	eO3qd+etbhxquw7LjvNK+rJ3TXTN21JvijGgJO24=
Received: by mx.zohomail.com with SMTPS id 1753977802350358.12218677283863;
	Thu, 31 Jul 2025 09:03:22 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 7/8] selftests/mm: Mark unused arguments with __unused
Date: Thu, 31 Jul 2025 21:01:31 +0500
Message-Id: <20250731160132.1795351-8-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B7051C0020
X-Rspamd-Server: rspam06
X-Stat-Signature: ubs7i9kzgz8xxj3j6mm5oyyoosqu41mu
X-HE-Tag: 1753977819-630288
X-HE-Meta: U2FsdGVkX18ztSnj8+p9nSXpnMx3Ni9oK8ByEdIWpFPOplKW3K9T/JZohNOCdgFli3bJHCQO/a7yfJL3e0PLleZ0J26T+vKm39bK3WxVKGos68d1DvIy23vRfqogUCAC/tOCzRpEUCn+EcMjfAYbACc1uY+oc0+UJcqnQMPtxSgLu8AmqwQQpD+noVLTM/CRFZooVHUsSbgfbgH1OkXe5qk+topl9cr40v4rGX9P2/vyEqdPiRhVqUMbPq2DWL9dJGomRejL9IeimR8UgRiWu1jkvjzTxxnIeYB9bBtWfJrC4ckgx//L+I6Xb57wSV7LTU6aPH+1t54AxrDm9ayExtDibPxqqLUo1lI3igoptKubKB+gJETG47eZtni9eL3SPeheREtmwpf90NJTlwqsQrPzkza7qUFZMKSUzkLSAD0VSryd7L+d4CV9utv87uyUWHOM3tlNhs4sjWlZLjus7nw4vOPoZqkm5b7f7WZZ1MoRCTc61frIBvAj2urW0yw6GhriTiH6gWE+KsxAXpDIeEccKsdt8NMmwKp73qsR5x3r0NsFkS5B6ZCFixK8CHyMomHjbvSaP/9gBH/NRCsZxUC9ldI53Q1pauzFHnIGOwPGCByUpu3FkBystdTrRb5Z/Mr9AfziebHh2Xj3o0p6hpgi3fx7pfbqnMq0aX1bePJ2kHBVvdQmzzapGsB4mucxmHw+P/fzvUkkkrAt1KBAEo2phVPrICV4ZI3lnQm9GgBn4eR5ZXJp8wfVGwbOJLonGJMB6L00pT3PKR/y0LL6VTTrUYpBuZA1HEceW6EIVxNIZ3cmeIvzFLxZxFyJlxJ6DAKZPRdTEXPlzUlCTSgrljrjFL1VP+FoR04F3C723N+pP9272LhWkRuVfNej3OsNRQJAp27JDlxzQX+WlJKtn7cvuLenodCHHqBOTS/bSiWC6Sa8T1l1vtn+WXvCW0xDjaPlSLB6g/76MxsWzQg
 +ASL2iIa
 chlSy2rH4DFnDHtFhBWDpXkQUkNKESUJZjr+RLHqSa0NbDUViONBK7P5yo2FvMF1J1u81cKvJZ6CkIPwruaS5rM5c0gWN3yVLI2xi3WttuLyUP21alL97hlMB6wUf6MKmMOFfSFZy77EuwfysG58CkFk2ytoYJ/Ze97gJjdl96M1CFlytt4cNkvKoIKVdubuOB3/oEfy2TWXnQiOmhKWA2zcnM8kq3ZTHjG6K2TlQTbVmF7Sd0XvoL9qTRAyYskKyOBr9v2lvbPwx7kw2LYCXz/DXakIA8SmCnFTjzs+mII2DAUDycCAlx/wyLpSWixY2drjuyxuoWnEbR0QzK3rofOS2P9ioSIQZVfmUnypKN+SGCLgyr1nV5bPP2gLdMy1X8h2lIDZpkYuPu4+1UAdKU6yy9pjjfmPQxjvOrnVPZaCunFgaGldyiwo7tw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mark the arguments which cannot be removed with __unused attribute.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 .../selftests/mm/hugetlb_fault_after_madv.c    |  4 ++--
 .../testing/selftests/mm/hugetlb_madv_vs_map.c |  6 +++---
 tools/testing/selftests/mm/pkey-arm64.h        |  5 +++--
 tools/testing/selftests/mm/pkey-powerpc.h      |  2 +-
 tools/testing/selftests/mm/pkey-x86.h          |  3 ++-
 .../selftests/mm/pkey_sighandler_tests.c       | 10 +++++-----
 tools/testing/selftests/mm/protection_keys.c   | 18 +++++++++---------
 7 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index e2640529dbb29..72706c64fe57c 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -28,7 +28,7 @@ static void signal_handler(int signal)
 }
 
 /* Touch the memory while it is being madvised() */
-void *touch(void *unused)
+void *touch(void __unused *unused)
 {
 	char *ptr = (char *)huge_ptr;
 
@@ -41,7 +41,7 @@ void *touch(void *unused)
 	return NULL;
 }
 
-void *madv(void *unused)
+void *madv(void __unused *unused)
 {
 	usleep(rand() % 10);
 
diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
index 8f122a0f08281..64a1455940394 100644
--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
+++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -33,7 +33,7 @@ size_t mmap_size;
 char *huge_ptr;
 
 /* Touch the memory while it is being madvised() */
-void *touch(void *unused)
+void *touch(void __unused *unused)
 {
 	for (int i = 0; i < INLOOP_ITER; i++)
 		huge_ptr[0] = '.';
@@ -41,7 +41,7 @@ void *touch(void *unused)
 	return NULL;
 }
 
-void *madv(void *unused)
+void *madv(void __unused *unused)
 {
 	for (int i = 0; i < INLOOP_ITER; i++)
 		madvise(huge_ptr, mmap_size, MADV_DONTNEED);
@@ -54,7 +54,7 @@ void *madv(void *unused)
  * The other hugepage should be flipping from used <-> reserved, because
  * of madvise(DONTNEED).
  */
-void *map_extra(void *unused)
+void *map_extra(void __unused *unused)
 {
 	void *ptr;
 
diff --git a/tools/testing/selftests/mm/pkey-arm64.h b/tools/testing/selftests/mm/pkey-arm64.h
index 8e9685e03c441..a9cacf3732f60 100644
--- a/tools/testing/selftests/mm/pkey-arm64.h
+++ b/tools/testing/selftests/mm/pkey-arm64.h
@@ -81,11 +81,12 @@ static inline int get_arch_reserved_keys(void)
 	return NR_RESERVED_PKEYS;
 }
 
-static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
+static inline void expect_fault_on_read_execonly_key(void __unused *p1, int __unused pkey)
 {
 }
 
-static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+static inline void *malloc_pkey_with_mprotect_subpage(long __unused size, int __unused prot,
+						      u16 __unused pkey)
 {
 	return PTR_ERR_ENOTSUP;
 }
diff --git a/tools/testing/selftests/mm/pkey-powerpc.h b/tools/testing/selftests/mm/pkey-powerpc.h
index 17bf2d1b0192e..8a367c32a9dd6 100644
--- a/tools/testing/selftests/mm/pkey-powerpc.h
+++ b/tools/testing/selftests/mm/pkey-powerpc.h
@@ -93,7 +93,7 @@ static inline int get_arch_reserved_keys(void)
 			return NR_RESERVED_PKEYS_64K_3KEYS;
 }
 
-static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
+static inline void expect_fault_on_read_execonly_key(void __unused *p1, int __unused pkey)
 {
 	/*
 	 * powerpc does not allow userspace to change permissions of exec-only
diff --git a/tools/testing/selftests/mm/pkey-x86.h b/tools/testing/selftests/mm/pkey-x86.h
index f7ecd335df1e6..27688c04abd35 100644
--- a/tools/testing/selftests/mm/pkey-x86.h
+++ b/tools/testing/selftests/mm/pkey-x86.h
@@ -157,7 +157,8 @@ static inline void expect_fault_on_read_execonly_key(void *p1, int pkey)
 	expected_pkey_fault(pkey);
 }
 
-static inline void *malloc_pkey_with_mprotect_subpage(long size, int prot, u16 pkey)
+static inline void *malloc_pkey_with_mprotect_subpage(long __unused size, int __unused prot,
+						      u16 __unused pkey)
 {
 	return PTR_ERR_ENOTSUP;
 }
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index eb4ef8532c0bf..638477494ff3a 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -110,7 +110,7 @@ static inline u64 pkey_reg_restrictive_default(void)
 	return set_pkey_bits(PKEY_REG_ALLOW_NONE, 0, PKEY_DISABLE_ACCESS);
 }
 
-static void sigsegv_handler(int signo, siginfo_t *info, void *ucontext)
+static void sigsegv_handler(int __unused signo, siginfo_t *info, void __unused *ucontext)
 {
 	pthread_mutex_lock(&mutex);
 
@@ -122,7 +122,7 @@ static void sigsegv_handler(int signo, siginfo_t *info, void *ucontext)
 	syscall_raw(SYS_exit, 0, 0, 0, 0, 0, 0);
 }
 
-static void sigusr1_handler(int signo, siginfo_t *info, void *ucontext)
+static void sigusr1_handler(int __unused signo, siginfo_t *info, void __unused *ucontext)
 {
 	pthread_mutex_lock(&mutex);
 
@@ -132,7 +132,7 @@ static void sigusr1_handler(int signo, siginfo_t *info, void *ucontext)
 	pthread_mutex_unlock(&mutex);
 }
 
-static void sigusr2_handler(int signo, siginfo_t *info, void *ucontext)
+static void sigusr2_handler(int __unused signo, siginfo_t __unused *info, void __unused *ucontext)
 {
 	/*
 	 * pkru should be the init_pkru value which enabled MPK 0 so
@@ -155,7 +155,7 @@ static void raise_sigusr2(void)
 	 */
 }
 
-static void *thread_segv_with_pkey0_disabled(void *ptr)
+static void *thread_segv_with_pkey0_disabled(void __unused *ptr)
 {
 	/* Disable MPK 0 (and all others too) */
 	__write_pkey_reg(pkey_reg_restrictive_default());
@@ -165,7 +165,7 @@ static void *thread_segv_with_pkey0_disabled(void *ptr)
 	return NULL;
 }
 
-static void *thread_segv_pkuerr_stack(void *ptr)
+static void *thread_segv_pkuerr_stack(void __unused *ptr)
 {
 	/* Disable MPK 0 (and all others too) */
 	__write_pkey_reg(pkey_reg_restrictive_default());
diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 6281d4c61b50e..65bc9ba59f72b 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -309,7 +309,7 @@ static char *si_code_str(int si_code)
 
 static int pkey_faults;
 static int last_si_pkey = -1;
-static void signal_handler(int signum, siginfo_t *si, void *vucontext)
+static void signal_handler(int __unused signum, siginfo_t *si, void *vucontext)
 {
 	ucontext_t *uctxt = vucontext;
 	int trapno;
@@ -889,7 +889,7 @@ static void close_test_fds(void)
 	nr_test_fds = 0;
 }
 
-static void test_pkey_alloc_free_attach_pkey0(int *ptr, u16 pkey)
+static void test_pkey_alloc_free_attach_pkey0(int *ptr, u16 __unused pkey)
 {
 	int i, err;
 	int max_nr_pkey_allocs;
@@ -1106,7 +1106,7 @@ static void test_pkey_syscalls_on_non_allocated_pkey(int *ptr, u16 pkey)
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
-static void test_pkey_syscalls_bad_args(int *ptr, u16 pkey)
+static void test_pkey_syscalls_bad_args(int *ptr, u16 __unused pkey)
 {
 	int err;
 	int bad_pkey = NR_PKEYS+99;
@@ -1132,7 +1132,7 @@ static void become_child(void)
 }
 
 /* Assumes that all pkeys other than 'pkey' are unallocated */
-static void test_pkey_alloc_exhaust(int *ptr, u16 pkey)
+static void test_pkey_alloc_exhaust(int __unused *ptr, u16 __unused pkey)
 {
 	int err;
 	int allocated_pkeys[NR_PKEYS] = {0};
@@ -1238,7 +1238,7 @@ static void arch_force_pkey_reg_init(void)
  * a long-running test that continually checks the pkey
  * register.
  */
-static void test_pkey_init_state(int *ptr, u16 pkey)
+static void test_pkey_init_state(int __unused *ptr, u16 __unused pkey)
 {
 	int err;
 	int allocated_pkeys[NR_PKEYS] = {0};
@@ -1397,7 +1397,7 @@ static void *get_pointer_to_instructions(void)
 	return p1;
 }
 
-static void test_executing_on_unreadable_memory(int *ptr, u16 pkey)
+static void test_executing_on_unreadable_memory(int __unused *ptr, u16 pkey)
 {
 	void *p1;
 	int scratch;
@@ -1429,7 +1429,7 @@ static void test_executing_on_unreadable_memory(int *ptr, u16 pkey)
 	pkey_assert(!ret);
 }
 
-static void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
+static void test_implicit_mprotect_exec_only_memory(int __unused *ptr, u16 __unused pkey)
 {
 	void *p1;
 	int scratch;
@@ -1478,7 +1478,7 @@ static void test_implicit_mprotect_exec_only_memory(int *ptr, u16 pkey)
 }
 
 #if defined(__i386__) || defined(__x86_64__)
-static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
+static void test_ptrace_modifies_pkru(int __unused *ptr, u16 __unused pkey)
 {
 	u32 new_pkru;
 	pid_t child;
@@ -1601,7 +1601,7 @@ static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
 #endif
 
 #if defined(__aarch64__)
-static void test_ptrace_modifies_pkru(int *ptr, u16 pkey)
+static void test_ptrace_modifies_pkru(int __unused *ptr, u16 __unused pkey)
 {
 	pid_t child;
 	int status, ret;
-- 
2.39.5


