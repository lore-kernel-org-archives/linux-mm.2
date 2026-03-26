Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEBC3109E535
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 01:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F09D6B0088; Wed, 25 Mar 2026 21:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1CA6B0089; Wed, 25 Mar 2026 21:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B75A6B008C; Wed, 25 Mar 2026 21:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F146A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:47:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9759A13C028
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:47:35 +0000 (UTC)
X-FDA: 84586527270.17.EC637FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7A73A000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:47:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jtj7IzO+;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774489654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYtiHYwEgEEdUPeqglJL2ZoQxhKggH1llo4jf1KxxXI=;
	b=WeQUJvB1oWDOP5okYV9Xp5djMBlIO4KGVlPObYrlVDhSHS+gyBu51dd13SCeFCvHkq4lC9
	6+WWit7rxsVIdQi/Rkcp4FXPmGD/j4exO8SNGtlH44uW2aWJWuKlDmm4LBhmRDr1DLumiY
	Ip/nBJ48Y9MdJit1O9Q2gvQBeq7/Ops=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jtj7IzO+;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774489654; a=rsa-sha256;
	cv=none;
	b=1Jh0bVjgZp5swbVwXpaHv+W8N05KuhlUIZQEpGLPdLITq8xs0ZjP9mXaaUC1XpyowIB+RN
	BB/T1Tmzc7BWi3xA19k+qH1bfH2ahOfIKWIMbffRz2fYQsrhsO5TMe5PJUcbvWdvDueVHG
	W7PAFwO6tYBuDHRHmRNaL9rR4TKRMqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A43460053;
	Thu, 26 Mar 2026 01:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7919BC4CEF7;
	Thu, 26 Mar 2026 01:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774489653;
	bh=EW9TUvgR9VGdaSKo9kQFZS2JNfhcVmdVBa0AARxk664=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jtj7IzO+dpHanbe/iwWtGWloyTziBit4y3ySohvy9/DF+oCh3FqkDQeGT3rEusXIw
	 dCx7Nnk/JUIet4yTVIr3Ca9RumAM1HMst7c7+cxAiv84P5Oe6DzMJT658wH10XAjym
	 TXtGp+m9kQGevYT12KZ+gx7Z/PVBVF80RYs7qO1E=
Date: Wed, 25 Mar 2026 18:47:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Matthew Wilcox
 <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>, Eero Kelly
 <eero.kelly@dfinity.org>, Andrew Battat <andrew.battat@dfinity.org>, Adam
 Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Message-Id: <20260325184731.791eda3b81cee4ad3f3ec17e@linux-foundation.org>
In-Reply-To: <20260323163717.184107-1-ziy@nvidia.com>
References: <20260323163717.184107-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E7A73A000D
X-Stat-Signature: xn9f8dsj5k7km7najsekes5qxctobgnw
X-Rspamd-Server: rspam06
X-HE-Tag: 1774489653-579978
X-HE-Meta: U2FsdGVkX19yiWyxSOqPwZ8vFv2nZJ2/Le3UNqlXhFahFFnum+eJMprMaqxIrKiKyxGBij0oMOGEg5H93SOhJZjfoPk6nLzav7WEdOLwE0PesQOfKtn+nv0EulNri0esxPhRwqj+XMhCIvGPyX9fg3jT3tR/YWj6pnE/WsUGjFIPcL2WsoMJ9vEJOp6tWKbf87uojP535b9TsHID35XomgmSUyEKB8y2gmESVBbESwZvz1Xly98/2hZBjb6EzunByUgUBglHql0T/AJY6dmGIUMXhB/8YPKi9ongit0OwiIjdniD5SuvEvmoz9Gwy8MIbzAttA45TPAzzqw+E9Wnj8aNADWfRTwxNLIZQx52O/6PcAchPON8Xz9hbXhMyDV/9wu83gQLLXPwLvzgX3WbvQbrAnLqQypWkeoh71V/u/6iw7bBWpbJ5gdD/qCik8mH080h9xD/zvm7SmvNZHXp8NXaKebkGqQlF/iRNb4PXSNIMfu7JnUDPTaD0oz2jghAPjqhdW0AojXpHnxoVOvB2p9zsunrOOzviaEmt17BsyUY227/hnvCaIYFRCcBjR6+5Thassb0V6PyIUItj8zp3nHhy6TQAN5J6s+5M1T6vZiCQwulpmG5jlGsuo/RzQK9Xr1RaoeL12RSWM6fGocWllOAFSVmmidD4bMPJN6htPgP5hr3o8kB3CyHF7Qix7IHL6wEdZPTfMUgPbNL3cWA/q4BAiuOtY6EJXQ1wMfObBNKHDRx7pJNOv04tqb6D1JB2wmINDKHMJxNzxcLZnnVEcCwmeNGuwLXCVitZ8Ic5YQ1L2jPjLoN8mcBjkaLd65eEGDFdkJP8MI4NEIVpbQwegxa8+6vGXhFtJn7qV7TICvBejdjCSNLGBeD95c/RlSjz59KZQjOV6efBdHiHsJ96+qvGbf8qOrKcFRemEjsUj46xRom7IEEJOUrQyPZ8+3vmh8MM6NXuB9zv5xw/yg
 8VhUcrtw
 cb/t/Cr9Uac2Ze3fGOnF3qOyXWPdjWx6t6qvXCZcNXDxS99pB+yvSQXj4Sr6t3RTYRL0WSD0pvUsUQIbuNryzKo9MWDujsql0YB2mieDfL60aw2hQ/0hZtKvvyV36Sl6gL8s3WaIazpjOO9y7ucok4o4u1f8CQy8dlKynEBRL/GeQeCOQu6xTfOBYekUnxPqFruVvGUL8r1W9FYNxpZo5NLlle/2xrVdbuPFP0GwcBHWnVo3IcNpuqjJj6sbYlHfarBGXq1LoZX0XeyHD3V5ko/qyvB6HqHC8yru/JFPe+oVT+6mD9xAhmQb6ZxWnoacgfCu2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 12:37:17 -0400 Zi Yan <ziy@nvidia.com> wrote:

> The added folio_split_race_test is a modified C port of the race condition
> test from [1]. The test creates shmem huge pages, where the main thread
> punches holes in the shmem to cause folio_split() in the kernel and
> a set of 16 threads reads the shmem to cause filemap_get_entry() in the
> kernel. filemap_get_entry() reads the folio and xarray split by
> folio_split() locklessly. The original test[2] is written in rust and uses
> memfd (shmem backed). This C port uses shmem directly and use a single
> process.
> 
> Note: the initial rust to C conversion is done by Cursor.

Thanks for the poke, I did indeed miss this.

I'll toss the previous version and its three -fixes.  {lease check that
those -fixes were incorporated here.

Here's how v5 alters mm.git.  It's quite a large update.


 tools/testing/selftests/mm/folio_split_race_test.c |   95 +++++------
 1 file changed, 44 insertions(+), 51 deletions(-)

--- a/tools/testing/selftests/mm/folio_split_race_test.c~a
+++ a/tools/testing/selftests/mm/folio_split_race_test.c
@@ -44,8 +44,8 @@ uint64_t pmd_pagesize;
 /* Shared control block: control reading threads and record stats */
 struct shared_ctl {
 	atomic_uint_fast32_t stop;
-	atomic_size_t reader_failures;
-	atomic_size_t reader_verified;
+	atomic_uint_fast64_t reader_failures;
+	atomic_uint_fast64_t reader_verified;
 	pthread_barrier_t barrier;
 };
 
@@ -59,7 +59,7 @@ static void fill_page(unsigned char *bas
 }
 
 /* Returns true if valid, false if corrupted. */
-static bool check_page(unsigned char *base, size_t page_idx)
+static bool check_page(unsigned char *base, uint64_t page_idx)
 {
 	unsigned char *page_ptr = base + page_idx * page_size;
 	uint64_t expected_idx = (uint64_t)page_idx;
@@ -68,7 +68,7 @@ static bool check_page(unsigned char *ba
 	memcpy(&got_idx, page_ptr, 8);
 
 	if (got_idx != expected_idx) {
-		size_t off;
+		uint64_t off;
 		int all_zero = 1;
 
 		for (off = 0; off < page_size; off++) {
@@ -78,15 +78,19 @@ static bool check_page(unsigned char *ba
 			}
 		}
 		if (all_zero) {
-			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %" PRIu64 ") is ALL ZEROS\n",
-				page_idx,
-				(page_idx * page_size) / pmd_pagesize);
+			ksft_print_msg("CORRUPTED: page %" PRIu64
+				       " (huge page %" PRIu64
+				       ") is ALL ZEROS\n",
+				       page_idx,
+				       (page_idx * page_size) / pmd_pagesize);
 		} else {
-			ksft_print_msg(
-				"CORRUPTED: page %zu (huge page %" PRIu64 "): expected idx %zu, got %" PRIu64 "\n",
-				page_idx, (page_idx * page_size) / pmd_pagesize,
-				page_idx, got_idx);
+			ksft_print_msg("CORRUPTED: page %" PRIu64
+				       " (huge page %" PRIu64
+				       "): expected idx %" PRIu64
+				       ", got %" PRIu64 "\n",
+				       page_idx,
+				       (page_idx * page_size) / pmd_pagesize,
+				       page_idx, got_idx);
 		}
 		return false;
 	}
@@ -97,8 +101,8 @@ struct reader_arg {
 	unsigned char *base;
 	struct shared_ctl *ctl;
 	int tid;
-	atomic_size_t *failures;
-	atomic_size_t *verified;
+	atomic_uint_fast64_t *failures;
+	atomic_uint_fast64_t *verified;
 };
 
 static void *reader_thread(void *arg)
@@ -107,9 +111,9 @@ static void *reader_thread(void *arg)
 	unsigned char *base = ra->base;
 	struct shared_ctl *ctl = ra->ctl;
 	int tid = ra->tid;
-	atomic_size_t *failures = ra->failures;
-	atomic_size_t *verified = ra->verified;
-	size_t page_idx;
+	atomic_uint_fast64_t *failures = ra->failures;
+	atomic_uint_fast64_t *verified = ra->verified;
+	uint64_t page_idx;
 
 	pthread_barrier_wait(&ctl->barrier);
 
@@ -154,14 +158,14 @@ static void create_readers(pthread_t *th
 }
 
 /* Run a single iteration. Returns total number of corrupted pages. */
-static size_t run_iteration(void)
+static uint64_t run_iteration(void)
 {
-	size_t reader_failures, reader_verified;
+	uint64_t reader_failures, reader_verified;
 	struct reader_arg args[NUM_READER_THREADS];
 	pthread_t threads[NUM_READER_THREADS];
 	unsigned char *mmap_base;
 	struct shared_ctl ctl;
-	size_t i;
+	uint64_t i;
 
 	memset(&ctl, 0, sizeof(struct shared_ctl));
 
@@ -195,7 +199,7 @@ static size_t run_iteration(void)
 		if (madvise(mmap_base + i * page_size,
 			    PUNCH_SIZE_FACTOR * page_size, MADV_REMOVE) != 0) {
 			ksft_exit_fail_msg(
-				"madvise(MADV_REMOVE) failed on page %zu: %d\n",
+				"madvise(MADV_REMOVE) failed on page %" PRIu64 ": %d\n",
 				i, errno);
 		}
 
@@ -214,7 +218,7 @@ static size_t run_iteration(void)
 	reader_verified = atomic_load_explicit(&ctl.reader_verified,
 					       memory_order_acquire);
 	if (reader_failures)
-		ksft_print_msg("Child: %zu pages verified, %zu failures\n",
+		ksft_print_msg("Child: %" PRIu64 " pages verified, %" PRIu64 " failures\n",
 			       reader_verified, reader_failures);
 
 	munmap(mmap_base, FILE_SIZE);
@@ -242,13 +246,15 @@ static void thp_settings_cleanup(void)
 int main(void)
 {
 	struct thp_settings current_settings;
-	bool failed = false;
-	size_t failures;
-	size_t iter;
+	uint64_t corrupted_pages;
+	uint64_t iter;
 
 	ksft_print_header();
 
-	if (!thp_is_enabled())
+	page_size = getpagesize();
+	pmd_pagesize = read_pmd_pagesize();
+
+	if (!thp_available() || !pmd_pagesize)
 		ksft_exit_skip("Transparent Hugepages not available\n");
 
 	if (geteuid() != 0)
@@ -268,37 +274,24 @@ int main(void)
 
 	ksft_set_plan(1);
 
-	page_size = getpagesize();
-	pmd_pagesize = read_pmd_pagesize();
-
 	ksft_print_msg("folio split race test\n");
-	ksft_print_msg("===================================================\n");
-	ksft_print_msg("Shmem size:       %" PRIu64 " MiB\n", FILE_SIZE / 1024 / 1024);
-	ksft_print_msg("Total pages:     %" PRIu64 "\n", TOTAL_PAGES);
-	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
-	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,
-		       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
-	ksft_print_msg("Iterations:      %d\n", NUM_ITERATIONS);
-
-	for (iter = 1; iter <= NUM_ITERATIONS; iter++) {
-		failures = run_iteration();
-		if (failures > 0) {
-			failed = true;
-			ksft_print_msg(
-				"FAILED on iteration %zu: %zu pages corrupted by MADV_REMOVE!\n",
-				iter, failures);
+
+	for (iter = 0; iter < NUM_ITERATIONS; iter++) {
+		corrupted_pages = run_iteration();
+		if (corrupted_pages > 0)
 			break;
-		}
 	}
 
-	if (failed) {
-		ksft_test_result_fail("Test failed\n");
-		ksft_exit_fail();
-	} else {
+	if (iter < NUM_ITERATIONS)
+		ksft_test_result_fail("FAILED on iteration %" PRIu64
+				      ": %" PRIu64
+				      " pages corrupted by MADV_REMOVE!\n",
+				      iter, corrupted_pages);
+	else
 		ksft_test_result_pass("All %d iterations passed\n",
 				      NUM_ITERATIONS);
-		ksft_exit_pass();
-	}
+
+	ksft_exit(iter == NUM_ITERATIONS);
 
 	return 0;
 }
_


