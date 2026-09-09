Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E8FC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583FA6B009B; Wed,  9 Sep 2026 06:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D646B00A0; Wed,  9 Sep 2026 06:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADC46B00A3; Wed,  9 Sep 2026 06:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 104A56B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:12:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A244AA37CD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:12:45 +0000 (UTC)
X-FDA: 85193809890.12.88805E7
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAA421C0006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:12:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YThEWMQ/";
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX03VdslkeGAuZnZEXnLni54ZZj7BtxRxhR+YMJ/+OA=;
	b=yRkOH0VvZVHVUwOf4MiI3Y4Obn/yA9V2y8uQhSUDI02KB4loIO3rVQtgEvNviSko5ji64l
	1mvZgqtdjQvjqZwvzPMtGMRM8LrCEKkE8PtBmRGF+pDMrV0GKLTgIPT2SaqN8E30XQA1n9
	8lOk5eqUDvJwiUS1uNMe004l0/8+IxM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YThEWMQ/";
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948763;
	b=mlsUqvPSYUgb6FYiMiaA213F8HhG2z6Td/2ttP8xIAdrE9b7uVBvRcQJnzAXFZY0L8+gzU
	kXD1BZcxHYkIIeA41lz886PNIlha47W02TVTSNJSp9R2wENOLc3/mWGlPj+R38u3hd4A6g
	Lw4IAr/RYHeCIsSH/E56av1QhDSc0S8=
Received: by mail-yx2-f12.google.com with SMTP id 956f58d0204a3-66e4ab1ba47so1168951d50.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948763; x=1789553563; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bX03VdslkeGAuZnZEXnLni54ZZj7BtxRxhR+YMJ/+OA=;
        b=YThEWMQ/iH6NC9BDKb8xU15CWNFG29W5MH4FRqmEUI7IdaG5ymv7dqKnr7A06zI/yg
         I5eHjmy5Vbk1/9EBYj6jSx+5ftBtJqdc4yuW8dsxfdHXtLGyhMYYMATauB4sWw0WF4Vl
         b9FHjqrMGQ3EJKsbunqS1rJWsJAUq8Y1u4qzDxLpSRAIT2Ko9TmFEGN6uFMob2xlG4Vz
         x8MavlaOmrlUeQQ8YvFycK3Byon+M9pMXKN1gCm9sC+0Bx9tvKcXpZtKBXoFjo1TEoDv
         +yzwaSpHZJAIsgksN6EfPOrrjZk1E24qUIklCTVCu2cIXP63hA9zSbGjUyCstsaCXnU0
         +KKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948763; x=1789553563;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bX03VdslkeGAuZnZEXnLni54ZZj7BtxRxhR+YMJ/+OA=;
        b=pwCXDPsybkI0UQCoV4rDf0J1QIvv3mWWyCpS3Z+C5TJrLiRVavonz7GvU7cHdL+xpL
         46V4Pp6XkPVRLewqHBw8FW5/ie2ETqYNfK1DNEyvMr4Td+PsGSDEnHNqf8++QMmwF/fD
         FDgCznsQx1j39e+T124YtbJ1rcuscduKHTjVqznI+Hz9bJRM+CB5FW2hF7ZfSI80lD4h
         NZI9E/RU6o+E0pmEWzyNy7T/894OeqFaB/Gh/TD51fHKfJoMkBdq++2vppCwz1R0Yvqb
         lYv/1Z6TEEuIYUGHnwy8QGuL5Ec6qebkwcTJGqn6yUb9paxEScZSQRYvf9cKvEb1w+rA
         cDCQ==
X-Forwarded-Encrypted: i=1; AKwUvByqsxq4gAecyp2dq6jUfsxkrPa5QQlWaH0cQ6z/mdebpRlEFrDZGw3BWvRyWzdxS8gOWPfg6iBpjQ==@kvack.org
X-Gm-Message-State: AFuF++kMJ17eu3kRyY4jq51U+Roup/V058XB33aF2BZtdNOEdP2ZoIRl
	W8JOABB8iX8B8SCrhzAbflJy6ljvrjKzbbYrdKmGn9OgU3OMJJ2P0SVKzWjon2p0oQ==
X-Gm-Gg: AYBFou091wllbExybW2jQYUZaqR/hJBUBnpQ6UiHQ/TrjuwEyoBwLWqh1X4iouHf1oU
	T5Sgud7YSWpZHjngHMAMivXy0w4UOkIoPHnfDLXBu/wU4111PMNj8lsULauvqam9l70d+MEHYfM
	w9EFZg7c2YX8XHapV5PjOb9dQNmckNTMz0cyBRVh761QHnUZZQwEs8v+QCo+F9eypWRiA8wGZ8V
	ANhBeKL7LOc9XNu/pr5RU2rOwsSyVFTyIgsp1hSLnyrUcQ2XxLQNF9YOEwkp3tPtRsioS8J+Vyc
	CQACncPijpKIUA5j0EDxfrxHMdZAIfooa34Nlvp7DWDMMNHVFIHMlB54bF6nJAWDyPsApPfF4zk
	YlN0HzACJ7wz4ODR4g9TDDo3kVYEA+4DXmTL9/PeZomDPH604qOxzAbYIprT32ts8szUJOZOLN8
	kMLBgPNLebKkWRnGdoNWbmhfqkFIZ6vQWCo+wX4nYxYzHvTPUEqKWqevwjSRxfulKnzR1DdjcB4
	QiM3gYqGEa3NwcbdkTo9/OigfqiRgsPW9LcDSFUdPWsJv85s1JEJ8HWfkc=
X-Received: by 2002:a05:690e:1243:b0:66f:d290:6336 with SMTP id 956f58d0204a3-670f4914bc5mr2669673d50.10.1788948762060;
        Wed, 09 Sep 2026 03:12:42 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-670febedc44sm2574235d50.11.2026.09.09.03.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:12:41 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:12:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
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
Subject: [PATCH v2 15/26] mm/fbatch: remove shake_folio() shake_page() from
 memory-failure
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <29067356-073c-2c36-a78b-7d7d4920aae3@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: 1aqgxnmttmmrujrwzzjx1j4n59mj7gr7
X-Rspamd-Queue-Id: AAA421C0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1788948763-661872
X-HE-Meta: U2FsdGVkX18mRWZWKWriz8VitdHx7FkDMEgc/nFwoZLqygcUVAzgIj8A+zc/5hMkQA71ZlQ9QrOJ8Ul9xXDWmWE1fpgZSTuVZFIRL7rEygr6/BWKshdkvq2BsM2v3B08oNHFL/w6QIWpBqcV8pvVaWCGcuhbBwn6IaC5qqntoqqlee+6AKrTDbEBuBIzH1aATk2n1l5xV+zABOyMo4GrcidYuDdtbeq8WVYzZ12J7+SAc/DIY3dJvouhjyi/JXV5H9OauFqs5yVQ8mTMEKafNZgemfVw/HN/YEXW93VhlVjpCsiFL8kBtCnl2bLSmWQIBc45yltgrbLjdgCGWDuthqvL/CcU+ZJKhl6lOYQoOHRraSKdWMavmg1mKIbnALMSFv5RuchRbloSqn4CJTof6op+yQSqHmJpkE4VLhTIeXZR6j3BIx0PJc9JXSEe7jY/B+RISYv6hfANCzzPFkFKiELGdCNZVRFfWlilhUYYGBsWbNq+raFESM17QtJeDX3YjMQ0UJkMliclXvuuQHky/kce+gGWUfe9wAKwXTEovjrS5eWNhL7J6bd6w2k4OvLgZ7kSDvWs6yWIaSU04xDjFHimCEp/7EY6Xp/no1q9eFL7ot6CYh1n2XBWuj52zutA1j9hRlj+y2f7oGYblWfF0b6ECEaD/25UoeBE52ELJuhb+iC8spy6qKVIR/zoqOh2H18iMizG55fm57SmXj4bUH59TDc82ef4kWYUxAkCpJ662zWQBFTei2OHKWEnLlERitrVc/gMpvEEqmrIVLkNVJTWN1CV9rO4hMKMmdFTztMhDLDYG3wl6mMxirdnZNyADMORCSYFzLOhgn41rgAxg/VVY68mdKMP/ckN5IGWQCD95QyNQNupa40knz7njGfMArneyciLfwOHvsIlbSekSlD0tyOxrtFc5BBkGFseXM8BEqkfM06h6wl9WxYRBoOXac9j0815rIkXIrEm8ta
 dauvvMji
 IJ6gHUasfzbZlrIE4ZZwgdhKnP8U9m+4iFajEeugIjkvm80NgdIoN4TYWjfJxNGAsQjM5u2xhPwoxsi4l6ia/z+QiGDTovVZKjscOt9JhF3SsPo/Y6ubvtjl2Ns2gSZxw1L88lAd3UVWPFeR6TeKR5xnmI5K1NDrpRqZVb33QejkglY1/3gzQjfG4uBgyfj7c/tjSWvTO5aeuirKeDtw3boOpWvHxV3M//GIbqUEjk7iiL5bPwIZAjkDaRgydp0rCXF0zRV+89iuvtx6UnjRAlMeC3Rc/Mx+k3e8xfoHmJMYQdjPnhCOp74235qjwlU2w1laanOH07cERvcOIyyR0YB8+Dcc7ZsbCONe25ZfgHIQo3iOlUJeeajq07a671eo+9j/u0kYE26/3XZN3tyYxXRm1rMtCNrV5ln5uiXTTaWXUiJ10q0mfDROy4eirkJZ8XBqNOAmRwmYBiXQvoNdWiIcry2BOqi5/NMmrS6ySpIc2/GrWjI3FQrVHcg==
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
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
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
index 40bd128a58ae..6700fff13675 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1171,7 +1171,6 @@ static inline bool node_reclaim_enabled(void)
  */
 #ifdef CONFIG_MEMORY_FAILURE
 int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, bool must_kill);
-void shake_folio(struct folio *folio);
 typedef int hwpoison_filter_func_t(struct page *p);
 void hwpoison_filter_register(hwpoison_filter_func_t *filter);
 void hwpoison_filter_unregister(void);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..d0abbe13447e 100644
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


