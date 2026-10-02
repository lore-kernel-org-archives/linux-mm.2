Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8126CCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F896B00B4; Fri,  2 Oct 2026 05:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA4C6B00B5; Fri,  2 Oct 2026 05:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1876B00B6; Fri,  2 Oct 2026 05:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A14166B00B4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 461D41C2763
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:01 +0000 (UTC)
X-FDA: 85277232642.04.026D03C
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	by imf14.hostedemail.com (Postfix) with ESMTP id 54C6F100003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+HGp6iu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V2NsbUurfee4vSeQVDWDVStNIM+u2hTDas5T+LMf7tQ=;
	b=R//lXh1VdH5K7YBRaF7NiwS3y15Y04TFNmxsyVf1alLtLgJfbUJaK9Y7Y6MaTK2lOUXEPM
	stbkEdavjF9b7uyXuEK//Mv6qwPf2I70BFrhd5LlTgbtdvPhRbDJqFtpaRe8vAXLgxJ/Fp
	zUU21+OI733TFjABJAy9wnmkMqXRWn4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V+HGp6iu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935019;
	b=YCjmY4ZnnN5FLrHqHPrdZwcSqUfDUgCwS02hzNlAb503W5x23piqtWeVuTH6tIr62BkXYj
	2ilbQ0te2RRgetraihHMb3Qp2AMmcr1O+BV5FE78Qh1vReVybebHduiHy1SIyjFmT9KUlk
	3MdSYbQ50sVHYNBaRr+qXwRfXs/q6ls=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=U7fl/g2rQtBLEOOrRTOeLDCwF2LzhxQL9fohkaqezco=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935018; v=1; x=1791539818;
 b=V+HGp6iuRhxNJlToyyu4Db5rTKQ0jAz7Rn/JbvJ5z05atfpJfZbnbUv/vTkap/DEdJbvXJMi
 2m1c2ACvb3JW3sh3jhhVcxiczSrkIdiSP8VUy2B1gSI5dFBt54WgUhu2OT7RHP9BryHN0/taxCz
 Q84662Jr5/kV7aIUeGEVhtR0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 780e5e8d7edcc9b9;
	Fri, 02 Oct 2026 09:56:57 +0000
X-Mizu-Trace-ID: 780e5e8d7edcc9b9
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 16/30] fs/proc: account PMD swap entries in smaps
Date: Fri,  2 Oct 2026 02:52:30 -0700
Message-ID: <20261002095503.3585565-17-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6mob4drhafs6p6whmps4eej7xppznufs
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54C6F100003
X-HE-Tag: 1790935019-62641
X-HE-Meta: U2FsdGVkX18yzBDJShxPsg4Bz6jndUFVk0CMskBewQQdoVMNawe/96UYUSdP2mqyIhItwnuz+Jq1HOlM0vscMXuabIjCzXPXbWAU9cpoRv0RT+0+YojvMc1jhKXD7K6TnWzB931nPEYOAlWFRggpF1U2s1tY9p5Yc4sdD4bP9WrYeScj60Co8GQGt7tVaurpuivyhz7jaqgKQZLcldGEHO5RWYP/6chhA0Y5rvc1YTME5d8VecpQSU3XL8LQhqVVfxa6hlsAdo31+ZbfCiNJ6DfP6STZ6jwJ2u2RRb88p3KduKuMfLdbWYorzD+4g5mTsLbY/qRR1cb/MtTWW6tpxE4/mCWVGpmu/o68VwJMnLIHq7yEN1/eo1gzd8JmQDPqxItuWwYfe+Mq48M4p/feV9fW9HOxxoBSUwp6AjysNf+wAdYB9KcQb1S5gSZlCtTxsUwGe9b/g1SGgDJs9Vw2jjOeYtuI2hMgzt/c5yFiDCbmbDOTwctCcug7JbnuzqC1Xe0O94BP2RJ1uyBJpKui1QZvgRBSL9XDLLE+Bt+n/lwRhLYNCrNc3asElevFQj8uKF60EF5Yd/BmDHGEwdA0zuBEa2AZGaO7cUK3L4fdk0AuKVjyifnAmSX98KbdRPmNRBCRPrIQYqb0KhdHHj7zuo7ohtq2z2c/Jmii6ZCKvBZLYfAkCQEsBTG3PSbaWFlMZndJtnxT6AroNX7pqU8D5udON6ij9IgcB6CJQQmOJXfNjPOdozxmeGfPq41pgjexTPjj7tBUC/C49/6RE7JcXLkxRKUC3QK55M/HUzVtr7jaojCeiNi8MZh7c48WzXSTR9AjpQnQORI/mj2LQjyz3BvheN9zJlhlCjsyOvXDXPHJJ2ykIoMbSYP2i2UJdnp/7QyB4g15xt7lDhGy9sJb13vC0DvbGl4PQCNId2xxI7cp1vIfXQ2pRO/3tpyUSMK0dml9+W6cDWQRGvk0uBO
 Bpu3VY5H
 pu35f1qKYBJBqLJjG4r/Ifmi6kmSKXvqh7Ap76ZDyIb2nNR4qlQ7Xa8FUt9dygbUjh6IUXG4Bsv1XIwA9edneSzCUwZmJkuoPsIqCncgN5cT4cuHqbXfnzA4Z/PdukGuLzgTr+67SFwCxnTgZCw0b6JoLDr1SDFfc+1qbz/sZr6aWoO/8M2u8dZG9u9pA4p2cxFBkkxbIZ7uUoW5Q9ekBbM0FCk4nvBfvDZyCmGIcdlXQLzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smaps_pmd_entry() derives a page from a non-present PMD and gives up if
it cannot. A PMD swap entry carries no PFN, so a swapped-out THP is
missing from both Swap and SwapPss.

The slots of a PMD swap entry can have different swap reference counts,
so SwapPss has to be computed one slot at a time rather than divided
once. Factor that loop out of smaps_pte_entry() and call it from both
levels, then return early: a swapped-out THP is not resident and must
not be added to AnonHugePages or Rss.

While touching PMD softleaf accounting, match the PTE path and treat
device-private PMD entries as fake-present. This lets smaps use
mapcount-based PSS and private/shared accounting instead of treating
them like migration entries.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 41 ++++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 24425e2308951..97c3fd7acf15d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -957,6 +957,25 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+static void smaps_account_swap(struct mem_size_stats *mss,
+			       softleaf_t entry, unsigned long nr_pages)
+{
+	mss->swap += nr_pages << PAGE_SHIFT;
+	do {
+		int swapcount = swp_swapcount(entry);
+
+		if (swapcount >= 2) {
+			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+			do_div(pss_delta, swapcount);
+			mss->swap_pss += pss_delta;
+		} else {
+			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+		}
+		entry.val++;
+	} while (--nr_pages);
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -978,18 +997,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		const softleaf_t entry = softleaf_from_pte(ptent);
 
 		if (softleaf_is_swap(entry)) {
-			int mapcount;
-
-			mss->swap += PAGE_SIZE;
-			mapcount = swp_swapcount(entry);
-			if (mapcount >= 2) {
-				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
-
-				do_div(pss_delta, mapcount);
-				mss->swap_pss += pss_delta;
-			} else {
-				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
-			}
+			smaps_account_swap(mss, entry, 1);
 		} else if (softleaf_has_pfn(entry)) {
 			if (softleaf_is_device_private(entry))
 				present = true;
@@ -1022,8 +1030,15 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_is_swap(entry)) {
+			smaps_account_swap(mss, entry, HPAGE_PMD_NR);
+			return;
+		}
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.0-Meta


