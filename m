Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4FAC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC39E6B0095; Mon, 24 Aug 2026 10:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4DA96B0099; Mon, 24 Aug 2026 10:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEB56B009F; Mon, 24 Aug 2026 10:27:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59F8C6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:27:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFBBDA0164
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:27:53 +0000 (UTC)
X-FDA: 85136392026.24.44F7E4B
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B1F212000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:27:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uFL5cpzU;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581672;
	b=yLLfmX1/DZx4Nnh/ROe3FNSMhmBT3xqkBUNNjxfB9xFsHmJ1DCzaOCpcA2HiBPq7VEk05v
	ZO2swGIc/O3dC/urIEBqna+5wd6ALH33fVdKUscV/g+LnsgLh6p2kG+qgM0ONNDQh9j/yd
	zf8s7CgZCJJgL5xtFO/+2F/RvXTbB2k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uFL5cpzU;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M66vr5Wj9LfuIyfBX17/YRcr9cErJu0CoiHB0PAp+Bg=;
	b=P5o7RdD77DzsP+7ph92JoHmTig1qh6Y1EiKH8rF0DW799tA2tRVoa3UG3o5J3vRcfpagSo
	HSl9BQKNtLwmcjIpBXGYcm+I2Oppj0OXdIZEaUfWeesAAyQW+8fXco+kIll/RHsgwrvsWt
	UlaeBNVvErmThjMuWtW1rk4JKeL9ZM0=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-7dbcb505578so40883087b3.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787581671; x=1788186471; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M66vr5Wj9LfuIyfBX17/YRcr9cErJu0CoiHB0PAp+Bg=;
        b=uFL5cpzU+7xbYECtHeq5zJQBLG4mAptlOXfdZCL4VQXFrFo9H00AkQHkahBJ+CZXzp
         5yn/CKzXuQ6KdtOaKTUN1eUNex1lex1YRqaWQof49XP9RRneV8gI44XhaJkIOvPgiOBg
         zhbqJKCsXi3aU9d7mMzrjtXt2rxErKs6aV2PcYwfY8auLc/2BKaPijGrI/iZR3iEDSFP
         zi3z6BioUXchI0cRRnGu9n8NDQr+pnqcU4MlH37vexjjYvPfNbaMdHxXo087J3LIiKKT
         xS8LCh8RndR9uygAjM615UMFP1eDC/gShOKW0fCi9zf0xSnHkEvNfPurwc6jHxO/7p7k
         B5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787581671; x=1788186471;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M66vr5Wj9LfuIyfBX17/YRcr9cErJu0CoiHB0PAp+Bg=;
        b=AxUYKiU6ZiIfnzilflCGYLtFKeOicImhEDTcAtQSafGA2QpifwFhfZq5MVxJuOaQ6q
         m6Y3SeSSCqJ/Z8azmbUvc4AoW0N6fDTvCmnID2VoE3PD+SiKvX9iNHrReEKgEoPqql5s
         FY4r25Kl+y1nD1BT/aBULLZ1xGsZgqOeNP49thybnqWukz47+exuBnJg02cT7OK7/7va
         jC64nf1hzvem1nClYRibEDvrqZxw9nC+YrUedtUXMmnyuNKyiF4LtKHidqEyt0UegAdJ
         S2qeNpEMAwOT0tSKkalOu8T27L+Jvtl5G4cs00ad3VUePjThzKJODQzBQwA+c0wqJC63
         TGSg==
X-Forwarded-Encrypted: i=1; AHgh+RrURsZ7M2mJR4lQBY7nlOEodjuldDHo/PDHPyI3IP7RMdeYZcqazQuocZm7R4gvs+35KljTodZG8w==@kvack.org
X-Gm-Message-State: AFuF++lksZICtNoQTUwvl8R6aZYBQBsspwdReVW/jZ95xVasMIg2poG9
	4OGsm6GDz2PU4yP724P0Hi13umIpL0n/+1nnFLlnyU+1DiRMsgJr2n2LDZb9fAD7CA==
X-Gm-Gg: AR+sD12GsONMMSngq+K6EPz0OTBq7k7ugdcMnyFocLzM/Mh994QAQnAmoohxw0ylFWk
	Xk5AR2Rb5KY/XIeT8mUsA9Q7AtXlQiBe8KlAg+oH9CvygBvFgVpiZ8VttQZ5BL2/SK8XFPvE/RZ
	l8yasWzVM8CT/HpQu8c2Xk0lHtctwyYuSFOPOIX/LRq0bvLQUI4SxDgHQB9r6j5/Fv07u8Ogf9M
	rt9LFdOjVLWbMLPKUYJgTr5bU2KmT5MBfj69AWdGsnQysCvc86nn6Re11pzIyK1q/XS/1ICfadi
	ZmR8Czc7dxANHNDse+aFHBnKmHixnzd4ZcQLEeBF9Z61SIxBWQ3z3MSzKJHVQg5aH74oIHvXO+X
	qhITRhLd9gq6x/lkvZNfcDvOYemUX3plM714sh27+8uEW4N5AA6tdrz9/qPDWyxlsxpv7nT3B9c
	Z+oDuTBEoatAZbO0dcaQh5a8VkRqTpACxr/h3fHiWgiE1y/SGtsiT8Opzp9mAiUmAtmFl+LBcN5
	4nRbsfYRQAcDwD7SzxE/isHGKJBjGHBg86dwelaVfljuhGL
X-Received: by 2002:a05:690c:6d81:b0:851:5445:ad5b with SMTP id 00721157ae682-8515445b0cfmr26010647b3.1.1787581670595;
        Mon, 24 Aug 2026 07:27:50 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84cacacb78fsm33749697b3.49.2026.08.24.07.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:27:48 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:27:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 15/25] mm/fbatch: remove shake_folio() shake_page() from
 memory-failure
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <213f92b1-7ac2-189c-4656-ba7d00cc7666@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3B1F212000C
X-Stat-Signature: qjocuyjypi8k5k797xpbebdnzcqs31ps
X-HE-Tag: 1787581672-411685
X-HE-Meta: U2FsdGVkX18IUTqVM1w+P1rCwQCZ7iReykoBCMTdVxRdpgs9f//ziV+p3U+Ssow3fTaFozhGBeqLqDXwiNfl7BuiDWMcFQ8dLxE8JiKMsBKOxCAKE5omIU+kcgnCJaiUFr3iIn2kxSl+VGReLREvY4CpheOIxuc+01fUyaCc8F8AVrbCpxWl7qSoMHA9ZGLuzUwVvpcdngL2kHLTDaOOlz8d0gOIpiIf6GWCqu8607vEYsv4WFlihGMtzv3N/kdF6hLKnMIwezd3SfaR6FAAQuEDntMAQ6z487RYDIBiL+F7842hnrqZxe3kzyglY5ai0y5YD06Rk+7JX+jvGwss1cNefzQ2O1EJyOcSLPeMcMgNYtM307y5Uk/OWpRxa+i4ijPFN8ZM1PZUQYxxUvtLb3b3dl3w34tFLrRsL1UoDdTn/M4xx2Dg4MyDfI8bsn9BNzacnhue0ZSXNVXz7SXvEIgQRboraeN0+BDioyKo7J/4s22l3jAhRZqQLORwrMP97hblHihv7Hkv4yLuPPLjRqDMOpOVWPKyY90ylhNMhuM+lHvkIwb6F0GrZtVHRjWeMiiIXRUVt7jny6Dyz1GLRTbqC8yRzwMMDZDwqomxcYIKc8xstHI9w5yY4C05BghefpXGW9ziiwfHK+k1FbNXHXAtDG0gCtje9jCHg/kfdzunTgUIiLzrBNkp4OkqXQFA8zbzTbvpPtVucyNtKZZJLNVsQkvG238d4e1OAMuFTJEXXkYBn7c50OfASmcQwhqIIUCqawsUj7A9gc7vm5bPPVNYD+lTxsIycgVwbGHW09njGQVqZMUQIx2c8aAcasSqtMGL6IhweqbcctizEq347MXXzzhBoL7TRXk0LDiz2CVZAA/2QuSRxEIeeQiLm3The+KbUQ8Y8dywg7d52TPxjJphRedsj17xbXoPdoqDXkbuGD4y3TjKcfWfu9GrGBH+zoCU6Z9dJWtvovDJr6L
 wYfg96Jy
 UowsvRRuZrAaRqj3IQSEwl5UxtQzweIVPb3YqjvuHdrqIk1Nuc5WQdxf5HH5IgBelDU83AK6DWMwqsjycw926gifL9JG06ECVf9BebqZNIw1nBVN/BxhCIzRt+8fFc4o36LbIYA6tSxwopPV8A/lF5dmwDtv+zgSJ7Pm4U+sR0OLd+CTEvlS2t2RZxTv37YdIywRf7It8lkCdHFCkSnLzUfjGz7DElQIBR/zABfbugcvSyqk8yE7/TogH/0nXckHqYPd76CvYjL3FsNmQq/c3t+Eb5GnWayxQgiOm9t7cR74NfMtZ6QgWlERu72Fmp3JocXO0qoNk01m2/g9hGpzkKxjh3BywmzrniTeByBWxI9OsxWd0p1xeyyAaokE/PbGn7vMLNKrLEeOXYTjff/98jETyKC1cRr5be3ITPuOX0kolcX+YARaokbtFoKKb0DWLTf/LvORHiZJl2d9D6iv5UmnHBGoL3AAj1Dx8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shake_folio()'s lru_add_drain_all() no longer serves a purpose, now that
the per-cpu fbatch references are gone. Are the retries in get_any_page()
then still useful? Not obvious, so keep them.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/hwpoison-inject.c |  1 -
 mm/internal.h        |  1 -
 mm/memory-failure.c  | 38 +-------------------------------------
 3 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index a11222572f97..9eab4b7d25b2 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -118,7 +118,6 @@ static int hwpoison_inject(void *data, u64 val)
 	if (!hwpoison_filter_enable)
 		goto inject;
 
-	shake_folio(folio);
 	/*
 	 * This implies unable to support non-LRU pages except free page.
 	 */
diff --git a/mm/internal.h b/mm/internal.h
index ff4bd3a14539..9a25552cbd83 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1140,7 +1140,6 @@ static inline bool node_reclaim_enabled(void)
  */
 #ifdef CONFIG_MEMORY_FAILURE
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
-void shake_folio(struct folio *folio);
 typedef int hwpoison_filter_func_t(struct page *p);
 void hwpoison_filter_register(hwpoison_filter_func_t *filter);
 void hwpoison_filter_unregister(void);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index aaf14608b30e..2a6a01e260ed 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -310,30 +310,6 @@ static int kill_proc(struct to_kill *tk, unsigned long pfn, int flags)
 	return ret;
 }
 
-/*
- * Unknown page type encountered. Try to check whether it can turn PageLRU by
- * lru_add_drain_all.
- */
-void shake_folio(struct folio *folio)
-{
-	if (folio_test_hugetlb(folio))
-		return;
-	/*
-	 * TODO: Could shrink slab caches here if a lightweight range-based
-	 * shrinker will be available.
-	 */
-	if (folio_test_slab(folio))
-		return;
-
-	lru_add_drain_all();
-}
-EXPORT_SYMBOL_GPL(shake_folio);
-
-static void shake_page(struct page *page)
-{
-	shake_folio(page_folio(page));
-}
-
 static unsigned long dev_pagemap_mapping_shift(struct vm_area_struct *vma,
 		unsigned long address)
 {
@@ -1459,10 +1435,8 @@ static int get_any_page(struct page *p, unsigned long flags)
 			 * We raced with (possibly temporary) unhandlable
 			 * page, retry.
 			 */
-			if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
-				shake_page(p);
+			if (pass++ < GET_PAGE_MAX_RETRY_NUM)
 				goto try_again;
-			}
 			ret = -EIO;
 			goto out;
 		}
@@ -1477,7 +1451,6 @@ static int get_any_page(struct page *p, unsigned long flags)
 		 */
 		if (pass++ < GET_PAGE_MAX_RETRY_NUM) {
 			put_page(p);
-			shake_page(p);
 			count_increased = false;
 			goto try_again;
 		}
@@ -1627,7 +1600,6 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 	LIST_HEAD(tokill);
 	bool unmap_success;
 	bool forcekill;
-	bool mlocked = folio_test_mlocked(folio);
 
 	/*
 	 * Here we are interested only in user-mapped pages, so skip any
@@ -1658,13 +1630,6 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 		pr_err("%#lx: failed to unmap page (folio mapcount=%d)\n",
 		       pfn, folio_mapcount(folio));
 
-	/*
-	 * try_to_unmap() might put mlocked page in lru cache, so call
-	 * shake_page() again to ensure that it's flushed.
-	 */
-	if (mlocked)
-		shake_folio(folio);
-
 	/*
 	 * Now that the dirty bit has been propagated to the
 	 * struct page and all unmaps done we can decide if
@@ -2554,7 +2519,6 @@ int memory_failure(unsigned long pfn, int flags)
 	 * The check (unnecessarily) ignores LRU pages being isolated and
 	 * walked by the page reclaim code, however that's not a big loss.
 	 */
-	shake_folio(folio);
 
 	folio_lock(folio);
 
-- 
2.51.0


