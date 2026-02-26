Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35D2FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 08:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1A76B0088; Thu, 26 Feb 2026 03:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 289DB6B0089; Thu, 26 Feb 2026 03:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1964D6B008A; Thu, 26 Feb 2026 03:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 032796B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:42:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C55A140A6B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:42:48 +0000 (UTC)
X-FDA: 84485967216.24.FD32D91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id CA66C1C0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:42:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/Ix/T8P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772095366; a=rsa-sha256;
	cv=none;
	b=roX9oWSORLEUqlPWGkaXKNwu1FT3g0Rhmxz6ddKG9c5p2p19veK0DetIn2M4oGvPfvHwSz
	GvnbIt4olZ+sjjUl9aqchWFCQaahM9b74Z9LqeQAAZfxnMio5fLHoDnq6ERvZHKf5FXeKu
	vyDih4xVFXAK26xrdxGkOhzd6Dijy+4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/Ix/T8P";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772095366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxOilxoigbfrBLkVfYUjooTw9y+gjyPeds9G7tUs5Go=;
	b=fjiZEh0ftU6UNWyoK5r+cllEVcIbMtGj68/xPfWiw0JiO7W4KKpN5Z6pIuhacyafIcQlK+
	jL84/Eh61Bgvn1s94y552saAteOu3AQT1oKVeOmb7d/0bjSbx0nGQyLVdAQEy/tJgDUR4D
	+m06b9JKPCxM0ZOKsQl+7EKw6sBPXGo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3279B60128;
	Thu, 26 Feb 2026 08:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 401C4C19422;
	Thu, 26 Feb 2026 08:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772095365;
	bh=zW1s9sD5DWBrMAAEnEuYwmxFxQgWMEFNnLPq3VWI4IE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J/Ix/T8PGmmSZU01h8WvC2LXp7Jy4EzeUmUVK9WZ3NHKLI6N0XasbpDQy+8Cg7uuZ
	 hGFKRvG8ikHbexZEyl26eex9mjVUOzSo61yUoJaBYXiW/9Qac4Z0wZyqtTq/Wo/TB3
	 hYImKmmyKXW1RGbwI6n/tvyJt2aa1cvdlARcCBHAqaOcQrEbj3HcfflyvIyw0gF5nz
	 nVHWy46sptFfPGCha7tEpSyt2U+xH/mwSd0yGzEh43MbcWUreV+/Wui07vrpJQ5B0h
	 RJZsXtLZsDmVCDlh19mr1625e8u04uqmgfgaq7OdyOMkKFEiRDn/tbI45ulDhZCM88
	 oUtsByduHNyqw==
Message-ID: <06ff4738-e81a-49ab-9204-74a6829d8d8b@kernel.org>
Date: Thu, 26 Feb 2026 09:42:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: simplify scanning progress in pmd
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260226081313.53518-1-vernon2gm@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226081313.53518-1-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA66C1C0002
X-Stat-Signature: de4gkcoewhojdxfmwwhb5g1c5wnqi3b9
X-HE-Tag: 1772095366-138229
X-HE-Meta: U2FsdGVkX1+CuVLDEq4XRiPYSlupl2UFM8da8r3g5b1O+JvWbgrtlLcrUE5glXqqNhDjnzbJwGgBut3ZLrsUyNjrbDNYa4MmAECRGtDbMV+25rqisAixaqzGVw0jqzrfQ11/E2jIoo+uZXvj+FCG8eW02heo9+sNNbGBz9VosNpgHpn5znAyOEz/2IzY/Zog8frpSFUoU1BZSzD7iBXP+hQ1Y71z+y37eEJDW8PejSdWqUpumM101SQQBSY1S7MS9QLazvPzyCNFdhldqVHlnyAA18nKOJAAR4eek3ekPL4B9wpdNhcmlls5wb0ZgZsKMTJBy7gTzFVd/0Z6UryHJEo7PjxVoZ8WaC30y+653bgMdPzEh94vylSNWkJvtsIY9Utv15BjqiIo0PhAE/lS7XEzh9i0M5VdlehbZKYZvhAxrZi8h/IRBXdXnFiB7jjWsMrYuj3x66sBviZ1ipu3hxHl3/m+phSLVSwRCoaG/lG11osBbCMnaAHG+nC4QFQ+Bn5GZlmiUKqZ13D19cfkj3L+r+3b5r9Lcm2uDWK+xvswr4JnKIE/a8PiAVsA9FZnLJHHba557+fppbbezajllLHRfNm8LLrwmMpqkH6okhiYnQ3XxOwIh2k0ePl9R9fu0ZCAxkV7NZJgX3Zb+bSg3uqHyub59wXRDODZyiAGHfh4EaRAJDXrSxRt24FNOgdLq/nThWnCgYLyGtvB7T5kTxSG052QrVv8K26Usfbu2+l9uMxYq4B5zFnHw5/mWwI7CBL7EaqQW3M7JTh2LrNrJmBZ1FtM8Uo0dxAUIuHvt7LN2V0O1+fXppokDWIn8XibNgPuA9/oDrLKYoiTUhX83OU4hxJQ8CSiG7C+RXWgp6YRF5X3h2JO4By1Q+mzopdYy5Jia0za52cUVIOtfib7KezA8AqovSZknpfTC/vIjXJ2hbAmmLKGOrlUiMrDEnRqex2nfJzVWRyYM4+FuPv
 29BkjUd0
 U32jDXh66EWSHhJVCBe//JPIK/aC4Aq0w2O2sGO6hVHUEYjBB8LiSGTf9uhg3ox1wZ444nZ4SAI0h/LeGYIIsd4+5v4OsRTXqa/oF2SV1r0JNoWDiBBgcBZxHIh2Z9t8rA0a5K1jq+jWuhhTPe804hNAw0CLoCSKIT2rgx4SJR7G9n+2HS7GljOzfSY/96hkLcSLSapSDGSqH1Cv3udzLJkyet7Dk9JoIzW+QCWTB9Ft0UVTxrQDP++/Kqm5AXw5csHd4HOxybCVydSnAVTTI3jJggtHpJuUhFwPVfYPtkwPDGOKWrSHuZ+yzQJlxsgSyy8uwpwoy7eZPkKkBniPggWaIm67xS0g7HsBLVbB0V8cQUJA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 09:13, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> Placing "cur_progress" inside "struct collapse_control" makes the
> overall code simpler, there also coincidentally has a 4-bytes hole,
> as shown below:
> 
> struct collapse_control {
>         bool                       is_khugepaged;        /*     0     1 */
>         /* XXX 3 bytes hole, try to pack */
>         u32                        node_load[64];        /*     4   256 */
>         /* XXX 4 bytes hole, try to pack */
>         /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
>         nodemask_t                 alloc_nmask;          /*   264     8 */
> 
>         /* size: 272, cachelines: 5, members: 3 */
>         /* sum members: 265, holes: 2, sum holes: 7 */
>         /* last cacheline: 16 bytes */
> };
> 
> Also rename "cur_progress" to "progress_in_pmd", make it clearer.
> 
> No function changes.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

We should really squash that into the original patch and revisit it.

Because I think we might be able to do even better.

Could we just switch to "cc->progress" like so (modified original patch):


diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4d7baf220ad9..5d67e5e60ece 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -68,7 +68,10 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
+/*
+ * default scan 8*HPAGE_PMD_NR ptes, pte_mapped_hugepage, pmd_mapped,
+ * no_pte_table or vmas every 10 second.
+ */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
@@ -100,6 +103,9 @@ struct collapse_control {
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
 
+	/* Num pages scanned (see khugepaged_pages_to_scan).  */
+	unsigned int progress;
+
 	/* nodemask for allocation fallback */
 	nodemask_t alloc_nmask;
 };
@@ -1247,19 +1253,24 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
 
 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED)
+	if (result != SCAN_SUCCEED) {
+		cc->progress++;
 		goto out;
+	}
 
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
 	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
 	if (!pte) {
+		cc->progress++;
 		result = SCAN_NO_PTE_TABLE;
 		goto out;
 	}
 
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
+		cc->progress++;
+
 		pte_t pteval = ptep_get(_pte);
 		if (pte_none_or_zero(pteval)) {
 			++none_or_zero;
@@ -2370,6 +2381,10 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 		}
 	}
 	rcu_read_unlock();
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+		cc->progress++;
+	else
+		cc->progress += HPAGE_PMD_NR;
 
 	if (result == SCAN_SUCCEED) {
 		if (cc->is_khugepaged &&
@@ -2385,8 +2400,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
 	return result;
 }
 
-static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result *result,
-					    struct collapse_control *cc)
+static void khugepaged_scan_mm_slot(unsigned int progress_max,
+		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
 	__acquires(&khugepaged_mm_lock)
 {
@@ -2394,9 +2409,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
-	int progress = 0;
 
-	VM_BUG_ON(!pages);
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
 
@@ -2419,7 +2432,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
 
-	progress++;
+	cc->progress++;
 	if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
@@ -2429,17 +2442,17 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 		cond_resched();
 		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
-			progress++;
+			cc->progress++;
 			break;
 		}
 		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
-			progress++;
+			cc->progress++;
 			continue;
 		}
 		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
 		if (khugepaged_scan.address > hend) {
-			progress++;
+			cc->progress++;
 			continue;
 		}
 		if (khugepaged_scan.address < hstart)
@@ -2486,7 +2499,6 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			progress += HPAGE_PMD_NR;
 			if (!mmap_locked)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2496,7 +2508,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 				 * correct result back to caller.
 				 */
 				goto breakouterloop_mmap_lock;
-			if (progress >= pages)
+			if (cc->progress >= progress_max)
 				goto breakouterloop;
 		}
 	}
@@ -2527,9 +2539,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
 		collect_mm_slot(slot);
 	}
 
-	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
-
-	return progress;
+	trace_mm_khugepaged_scan(mm, cc->progress, khugepaged_scan.mm_slot == NULL);
 }
 
 static int khugepaged_has_work(void)
@@ -2545,13 +2555,14 @@ static int khugepaged_wait_event(void)
 
 static void khugepaged_do_scan(struct collapse_control *cc)
 {
-	unsigned int progress = 0, pass_through_head = 0;
-	unsigned int pages = READ_ONCE(khugepaged_pages_to_scan);
+	const unsigned int progress_max = READ_ONCE(khugepaged_pages_to_scan);
+	unsigned int pass_through_head = 0;
 	bool wait = true;
 	enum scan_result result = SCAN_SUCCEED;
 
 	lru_add_drain_all();
 
+	cc->progress = 0;
 	while (true) {
 		cond_resched();
 
@@ -2563,13 +2574,12 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 			pass_through_head++;
 		if (khugepaged_has_work() &&
 		    pass_through_head < 2)
-			progress += khugepaged_scan_mm_slot(pages - progress,
-							    &result, cc);
+			khugepaged_scan_mm_slot(progress_max, &result, cc);
 		else
-			progress = pages;
+			cc->progress = progress_max;
 		spin_unlock(&khugepaged_mm_lock);
 
-		if (progress >= pages)
+		if (cc->progress >= progress_max)
 			break;
 
 		if (result == SCAN_ALLOC_HUGE_PAGE_FAIL) {
-- 
2.43.0


-- 
Cheers,

David

