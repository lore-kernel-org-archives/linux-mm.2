Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EA3C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9A126B0093; Wed,  9 Sep 2026 05:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A906B0098; Wed,  9 Sep 2026 05:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A128F6B0099; Wed,  9 Sep 2026 05:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74CD46B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:49:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C155140159
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:49:24 +0000 (UTC)
X-FDA: 85193751048.25.202DD2F
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B40BC0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:49:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TF5sNR0N;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UufK0vMlC6Z+KADxCs5ZoL9LcMsl7R0DiwRuRItb70g=;
	b=5MzFhEQe5lEkeOnvJsfUWeIZjmx/mdZfwDlJyaEtxszLRtV/Ii9+aaSpsFqcOjRd8sZH9n
	JgBXxjUOoe4S79WMQtrjrLoN/nqKXSkXGJUZAn17bsE+ffaTcH2dfvdsUu6Jlodr/RfGbR
	Fw6j2xNKdK8wMjQ1rDvLqv6NHGr3qsc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947363;
	b=q3fkzI1Qq3vFLgFS9M0wp2aOrWyML351x+DzsVzPw3llwLloXlOrsX427yByarQnKLzG53
	rzdsGiaMlKuRkS1alvURGbj+FfsCMLUiEWkpFzbEnO2NaNObCUciOi6DNBAhWcmiry72wE
	IuPb+H/Aqj1WnQKUsDDvaUz+u+Qfu9o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TF5sNR0N;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d46e4cdcaso7870437b3.3
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788947362; x=1789552162; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UufK0vMlC6Z+KADxCs5ZoL9LcMsl7R0DiwRuRItb70g=;
        b=TF5sNR0Ns4eXPxosaBdi1vmOj/kUbC5zR8x3rTh1uPs2DK2Qml8Ea4PyHClgBNOX2i
         aJ0rVDiHL12m88S4wlHaDGDzPAsonTcUusU7qptjIii+nhWmFsdgnXOWFWDqW/ZNGDUo
         O6geDjR7VLUbr8AbDju2iAmwbbhShvd1HCeGznQWtPaags5IVHlEXN4TI5GXyBLFdQBy
         ukRn0fttMbkFrtZ1IRWPT0QyHaSItL3+m5j5sDBv6qZcyUfB5drHpBkoYVL67/lbGPla
         eLzWhsK76GY4qkwkSFuSHCoC087WWPiVrPFOQam+fUjXWZEergFLwJqNuYN+9AV86s/s
         9vUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947362; x=1789552162;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UufK0vMlC6Z+KADxCs5ZoL9LcMsl7R0DiwRuRItb70g=;
        b=bDOp6iplF5ySoD5Jq8bNPlw90nQs2gUtUGt/F84PI7KIyu7wVzu+cfCK7RYiKwXrg2
         dDNau9PfJiNowHeO2LeEc6xb1G83JPtCngi04lk1uPsQX4r3fgQbG7PvqyIK4nkxh5mF
         4NjXzKbyT+EnCCPUDIp3nEnbCmLRTaxnl7ie5GmXUyoEY6jgjPs81YefeOuyBVUb65ce
         ZFA/nUp2OLI7CASa3ONzyd2Bhp3etCXBLgshpPXDi+goXrMQ13oZu1r7JirDz7d/zuEJ
         xmSDcxD3lNE63Heh0GDZfldawLg3duP3AsrMS1wVOste3BzjboTIQ8MiNI2ts3QUm3FI
         wTrA==
X-Forwarded-Encrypted: i=1; AKwUvBx8KV9vkKa0cp36yJbK9DlfOhuS6sRvfsIEz27oXRfIojRasnbeyhzaNc2Rd9gDdgAt0PKydqgB0Q==@kvack.org
X-Gm-Message-State: AFuF++lpkhd0pN9WGN2IctU0ejGWG5zM5LvuMHoYgzkSoKYDkM3XBTOx
	9meOrQTtvtV5wDxvMuW5V4H9OoXRoXZnLDabcjyujF9gT6KnRH2RJvb1XEn2ZJka6Q==
X-Gm-Gg: AYBFou2cWimZubqm2X3FMxq3Tmlm1/LD3mRMyeB7JsF6UCSPD6FhvDHwdxo7L3V8K3T
	7x06llFPHmng3ZqFw2eG6/5l73TgMj0719ay2sSy9H9Lkn1x4SeNoyKSE3CZBnvRc+hDpavpmLi
	AejOP4c3LPIXhvDX9qgBvHVOSv6HV8cbN1BHPm4cvejd+P7MD50knR52TcgdLJ4AY42J4dtrcGg
	a0vofJPHkjJrM/KEfP+r91ymkXRa/t3r1gTg0xAYxsxGpz4vuVMSL03dg21bLmVpaEd29I7FMWW
	2fgTrbBHcT4eKTgkzzyDxIJzlG4qt3BZyGUAdPGMyxSXlyfJBCFHS9b429wpUMkXcaHlJr0o4p8
	EWbPS1ZO3PEZaLkF+mVHzBNpQiBYAZCFyKfimoSJ6JmlyxIUxtzvXPMcZPjzZRG3el6JyVLwAcm
	2Vo/9TbpqJhTccoV/XctpGCfFLU+d4oZsdPb4HdoO4xxOtopr/6YSaG4DiIxEEyHLwP2hUfuE2G
	YTwiLdVogkQrLdIAgNtQawtGy4DrQn3m45jBIeZKn+4va6nDnmSHJY0Pw0=
X-Received: by 2002:a05:690c:e3f2:b0:87c:35a5:4aea with SMTP id 00721157ae682-87f22b7eaf5mr23815837b3.6.1788947361454;
        Wed, 09 Sep 2026 02:49:21 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-87149600f48sm107580907b3.13.2026.09.09.02.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:49:20 -0700 (PDT)
Date: Wed, 9 Sep 2026 02:49:15 -0700 (PDT)
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
Subject: [PATCH v2 04/26] mm/fbatch: lru bit set, no extra ref, while folio
 on per-cpu fbatch
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <61e15506-940f-3532-5fc9-4086f7612c10@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B40BC0004
X-Stat-Signature: u1j7xgaunhwk6kd99qbb8nno996i4pta
X-Rspam-User: 
X-HE-Tag: 1788947362-804254
X-HE-Meta: U2FsdGVkX1+0ReJatnmu18bDCwGYLXabl11/qMkCaoKezUwzQtRTzgstf4U7ke1ZJniI9ouXEJ/DDF7xUxf+nAe/+cDVyKjV32cvLc/uzPokOCt0ns+6boauLRKGYWNwg6hi8C+furFAYfUfV3vN1IgC/VhiF6Na8GE4/0rK8dJ+zqyukYayHqum814G/vfa4WNm4OmA9TSiejAYwB66mMJNQzWMkP6RtZwfRQZU56EQECUXX+ykv3OmYN5h5EbO8lXsZdi6jOVzO3WNyROZpYf4Nji+2SiCJJVlH1OSJBTUutXiSuLaolxtRL5Uwb6pF0+9TXjmMWO0pHlyazFox473R1DNGR/89wjniYs+lSRo95Hdps2eEtOUJ7tPFF83j8omAPY0pq7RC4cpYT381i4M+MsejE6IrMKFA1xK4n7YSPFLeLpd9CeJOoLiDrl3adjB493uO+YEAvDUbeyV3+xLbM78kHNGfLgXia7GmIv2GM8CvRD8PGRjAFVVudxg8Dvco8bTf94Bxha1ihk356BHtLnSQ5pSiH93nZSK59QOJ0OuF/qjoDwgnDWygN5TydIbPJ7NMAE96DRTe9unRsq7boBQIg/Cp9vS+R/TVxDzEbHjb5Ibyaj7+HvjmOVEILcmiZj7HSiUshnO+iHAuQS3qVzJq6msetiyMmF5GZ5DsY2i7rIKyBCqmJLK7b7zvLlVb0ncKqDij4+WVpl0Hw93fFZqhTrRfThWxpyzHN8ZvfhzGV8ISUUbDDFucEGocicNUAfBlT/lcZzI3zy4Qe81wuVqFcFJGEATUERc/ZyaEOSiWDR96K7EDoCUdZ1vR54Ct80bRFtDkBxkWgW08UVEo/8B8cueNLfu3dT03Iak8oF23VfEIxZdFeV3QuUl/6vlvruKMgu2FQ0yfHamw/XJc/GcmEXM/Ar06AZ6E35hw+HQ260rI+P0qYBOETlJcYP/EPuRTYB4UxkXn38
 cmJp8IgA
 kqgn3vBy4erzBKaHN3R3IN+UacVCZtipmgGQCgy5/b8JvYGJmHbziU8tSkok0fv24jslOKZlCDORIGhgVJnP3mH9DSKUtUa3vFwuVotNq3Au4HmGH7bmWDj+73/cTLmD7e54pVRSEDH7CPvuD+12KD0g7OqyW/ODPhumSetWJtYV980fnDXtQq2JSes5KyibVXsDAyfXr9XDy82jSpPyXegu7Bf8x4U63CInBmb6m6umgQQkNmJmu0nsGzjCOJxXPcUfSvFShhh03iKMoW525xUDXyEP8EYIGsWU2KCCDlMf+H3tUwiz1K6bKFzBAZ8QGT7lsniMeM4fOqlwjfdap51vX5phAYsrrM4iBSxuNCr/1daAui0jjsmZdiVyuboTP4XY0ATZp2UufCVzcUIBso9mzpngKY6pItXf5EzBdSWnHM8M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Treat folios on a per-cpu fbatch as if they were already on the lruvec:
with PG_lru set, without holding an extra reference. This will enable
the removal of most lru_add_drain() and lru_add_drain_all() calls soon.

Recognize such a folio by 0x02 set in the folio->lru.next pointer by
folio_add_lru(). Then lruvec_del_folio() (aided by "lru_add_del_folio")
can pretend to unlink it, and folio_batch_move_lru()'s lru_add case can
check whether one of the others has already moved it to lruvec.

(That bit is also used in a transient way by set_page_pfmemalloc(), to
inform interested callers whether page_is_pfmemalloc(): but those callers
are in networking, not putting folios on LRU; and accept that any use of
the page->lru field already erases page_is_pfmemalloc() information.)

Let folio->lru.next point to the lru_add fbatch entry, but this is now
just for debugging: it seemed to be important for folio_batch_move_lru()
to distinguish fresh from stale entries, but then it turned out that it
has to processs them identically.

Activate, deactivates and move_tail, holding no reference on the folio,
might come to act on a stale folio when the fbatch is drained: but it's
acquired by try_get and test_clear_lru, so safe even when suboptimal.

Reclaim is not an exact science, and there have been no complaints of
missed actions since 5.11 commit fc574c23558c ("mm/swap.c: serialize
memcg changes in pagevec_lru_move_fn") introduced the TestClearPageLRU
protocol: so don't expect complaints of a few surprisingly taken actions.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 include/linux/mm_inline.h |  25 ++++++++
 include/linux/mm_types.h  |   6 +-
 mm/folio.c                | 119 +++++++++++++-------------------------
 mm/huge_memory.c          |   6 +-
 4 files changed, 74 insertions(+), 82 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..8420b1276535 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -343,6 +343,29 @@ static inline void folio_migrate_refs(struct folio *new, const struct folio *old
 }
 #endif /* CONFIG_LRU_GEN */
 
+enum {
+	LRU_NEXT_NEVER_TAIL = 0,	/* Used by a tail's compound_head */
+	LRU_NEXT_BATCHED = 1,		/* Not used by any aligned pointer */
+	NR_LRU_NEXT_FLAGS
+};
+
+static __always_inline
+bool lru_add_del_folio(struct folio *folio)
+{
+	unsigned long lru_next = READ_ONCE(folio->lru_next);
+
+	/* BUG_ON(folio_test_lru(folio) && folio_ref_count(folio)); */
+	if (!(lru_next & BIT(LRU_NEXT_BATCHED)))
+		return false;
+
+	WRITE_ONCE(folio->lru.next, LIST_POISON1);
+	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
+
+	/* Ensure folio->lru_next visible when folio_set_lru() called later */
+	smp_mb__before_atomic();
+	return true;
+}
+
 static __always_inline
 void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
 {
@@ -384,6 +407,8 @@ void lruvec_del_folio(struct lruvec *lruvec, struct folio *folio)
 
 	if (lru_gen_del_folio(lruvec, folio, false))
 		return;
+	if (lru_add_del_folio(folio))
+		return;
 
 	if (lru != LRU_UNEVICTABLE)
 		list_del(&folio->lru);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 6d815f6440c9..fe6220b97cf3 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -85,6 +85,8 @@ struct page {
 	 * WARNING: bit 0 of the first word is used for PageTail(). That
 	 * means the other users of this union MUST NOT use the bit to
 	 * avoid collision and false-positive PageTail().
+	 * Bit 1 of the first word is used by page_is_pfmemalloc().
+	 * Bit 1 of the first word (lru_next) is also used by folio_add_lru().
 	 */
 	union {
 		struct {	/* Page cache and anonymous pages */
@@ -410,10 +412,8 @@ struct folio {
 			union {
 				struct list_head lru;
 	/* private: avoid cluttering the output */
-				/* For the Unevictable "LRU list" slot */
 				struct {
-					/* Avoid compound_info */
-					void *__filler;
+					unsigned long lru_next;
 	/* public: */
 					unsigned int mlock_count;
 	/* private: */
diff --git a/mm/folio.c b/mm/folio.c
index b9dc4f5e10a6..e743cd539b9e 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -152,57 +152,34 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	int i;
 	struct lruvec *lruvec = NULL;
 	unsigned long flags = 0;
-	struct folio_batch free_fbatch;
-	bool is_lru_add = (move_fn == lru_add);
-
-	/*
-	 * If we're adding to the LRU, preemptively filter dead folios. Use
-	 * this dedicated folio batch for temp storage and deferred cleanup.
-	 */
-	if (is_lru_add)
-		folio_batch_init(&free_fbatch);
 
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
-		/* block memcg migration while the folio moves between lru */
-		if (!is_lru_add && !folio_test_clear_lru(folio))
-			continue;
-
-		/*
-		 * Filter dead folios by moving them from the add batch to the temp
-		 * batch for freeing after this loop.
-		 *
-		 * We're bypassing normal cleanup. Clear flags that are not
-		 * applicable to dead folios.
-		 *
-		 * Since the folio may be part of a huge page, unqueue from
-		 * deferred split list to avoid a dangling list entry.
-		 */
-		if (is_lru_add && folio_ref_freeze(folio, 1)) {
-			__folio_clear_active(folio);
-			__folio_clear_unevictable(folio);
-			folio_unqueue_deferred_split(folio);
+		if (!folio_try_get(folio)) {
 			fbatch->folios[i] = NULL;
-			folio_batch_add(&free_fbatch, folio);
 			continue;
 		}
 
+		if (!folio_test_clear_lru(folio))
+			continue;
+
+		/* Do not add to LRU if it has already been added */
+		if (move_fn == lru_add && !lru_add_del_folio(folio))
+			goto restore_lru;
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
+		/* Do add to LRU if not already there (move_fn skipped) */
+		if (lru_add_del_folio(folio))
+			lruvec_add_folio(lruvec, folio);
+restore_lru:
 		folio_set_lru(folio);
 	}
 
 	if (lruvec)
 		lruvec_unlock_irqrestore(lruvec, flags);
-
-	/* Cleanup filtered dead folios. */
-	if (is_lru_add) {
-		mem_cgroup_uncharge_folios(&free_fbatch);
-		free_unref_folios(&free_fbatch);
-	}
-
 	folios_put(fbatch);
 }
 
@@ -211,8 +188,6 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 {
 	unsigned long flags;
 
-	folio_get(folio);
-
 	if (disable_irq)
 		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
@@ -273,7 +248,6 @@ static void lru_activate(struct lruvec *lruvec, struct folio *folio)
 	if (folio_test_active(folio) || folio_test_unevictable(folio))
 		return;
 
-
 	lruvec_del_folio(lruvec, folio);
 	folio_set_active(folio);
 	lruvec_add_folio(lruvec, folio);
@@ -289,37 +263,12 @@ void folio_activate(struct folio *folio)
 	    !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_activate);
-}
-
-static void __lru_cache_activate_folio(struct folio *folio)
-{
-	struct folio_batch *fbatch;
-	int i;
-
-	local_lock(&cpu_fbatches.lock);
-	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
-
 	/*
-	 * Search backwards on the optimistic assumption that the folio being
-	 * activated has just been added to this batch. Note that only
-	 * the local batch is examined as a !LRU folio could be in the
-	 * process of being released, reclaimed, migrated or on a remote
-	 * batch that is currently being drained. Furthermore, marking
-	 * a remote batch's folio active potentially hits a race where
-	 * a folio is marked active just after it is added to the inactive
-	 * list causing accounting errors and BUG_ON checks to trigger.
+	 * XXX: It is curiously difficult to recreate safely the old
+	 * __lru_cache_activate_folio() optimization (folio_set_active()
+	 * directly if it's on the local lru_add fbatch): revisit later.
 	 */
-	for (i = folio_batch_count(fbatch) - 1; i >= 0; i--) {
-		struct folio *batch_folio = fbatch->folios[i];
-
-		if (batch_folio == folio) {
-			folio_set_active(folio);
-			break;
-		}
-	}
-
-	local_unlock(&cpu_fbatches.lock);
+	folio_batch_add_and_move(folio, lru_activate);
 }
 
 #ifdef CONFIG_LRU_GEN
@@ -410,16 +359,7 @@ void folio_mark_accessed(struct folio *folio)
 		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
-		/*
-		 * If the folio is on the LRU, queue it for activation via
-		 * cpu_fbatches.lru_activate. Otherwise, assume the folio is in a
-		 * folio_batch, mark it active and it'll be moved to the active
-		 * LRU on the next drain.
-		 */
-		if (folio_test_lru(folio))
-			folio_activate(folio);
-		else
-			__lru_cache_activate_folio(folio);
+		folio_activate(folio);
 		folio_clear_referenced(folio);
 		workingset_activation(folio);
 	}
@@ -439,6 +379,10 @@ EXPORT_SYMBOL(folio_mark_accessed);
  */
 void folio_add_lru(struct folio *folio)
 {
+	struct folio_batch *fbatch;
+	unsigned long lru_next;
+	bool full;
+
 	VM_BUG_ON_FOLIO(folio_test_active(folio) &&
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
@@ -458,7 +402,26 @@ void folio_add_lru(struct folio *folio)
 			folio_mark_accessed(folio);
 	}
 
-	folio_batch_add_and_move(folio, lru_add);
+	local_lock(&cpu_fbatches.lock);
+	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
+
+	/* Storing this address is only for debugging */
+	lru_next = (unsigned long)&fbatch->folios[fbatch->nr];
+	/* This mask will do nothing on 64-bit */
+	lru_next &= ~(BIT(NR_LRU_NEXT_FLAGS) - 1);
+	lru_next |= BIT(LRU_NEXT_BATCHED);
+	folio->lru_next = lru_next;
+
+	full = !folio_batch_add(fbatch, folio);
+
+	/* Ensure folio->lru_next visible to folio_test_clear_lru() callers */
+	smp_mb__before_atomic();
+	folio_set_lru(folio);
+
+	if (full || !folio_may_be_lru_cached(folio) || lru_cache_disabled())
+		folio_batch_move_lru(fbatch, lru_add);
+
+	local_unlock(&cpu_fbatches.lock);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..c7510d875433 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3995,8 +3995,12 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		}
 
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-		if (do_lru)
+		if (do_lru) {
 			lruvec = folio_lruvec_lock(folio);
+			/* Move from fbatch to lruvec before lru_add_split_folio()s */
+			if (lru_add_del_folio(folio))
+				lruvec_add_folio(lruvec, folio);
+		}
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, xas,
 					     mapping, split_type);
-- 
2.51.0


