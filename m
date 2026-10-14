Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C331FCC6B1C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6A66B0088; Tue, 13 Oct 2026 23:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E3E6B008A; Tue, 13 Oct 2026 23:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB0B6B008C; Tue, 13 Oct 2026 23:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503EE6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:07:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEE8E803F5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:07:48 +0000 (UTC)
X-FDA: 85319747016.03.DD73611
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7AA80180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:07:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vuQb40Ds;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5s0DCVEXwxQzIetSIgDxa8VtpHsOoYszWQdZceIsOI=;
	b=vHUJqGbn4rmbLb47rNvkDfUqoPEBh2O5H1fqF0rhSlOFs0KB/35u3RItrU4C/6mQKrG8tn
	nxA29UHQnRQ/DjaWb0EvXgdItoEjlYDuxWV7eWlYtlEOI9nyTABHOcHFnaDhx6EoZUmdNM
	ZwTHqW2KxxMN8ZBCIHh8w3v0ScVYod4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947266;
	b=jw+RPFJzTWvSnE2peJSvmAKAr5ZuIVM0ztD5UZwCiQ79784a1auFfxp2lG6EKGCZugv9j9
	aPXnXO14ijmKlR92ToL9r7XaaDloa2NdNdLQ3NtIG/tfY2t6cycW0Acy/+4+hQJpk8vaJB
	BPyu9akEGsj4wKDuYb0dsy/kJoVctvY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vuQb40Ds;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9zrs9qqhlsQOOSazO/3qggaoCuwnahB4HwqhsNSdhxM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791947263; v=1; x=1792552063;
 b=vuQb40DsRX01QOyFawelPfbBt0/CIP0WefjaJMr4XsI65Zaj6Hbv1dr/30XjLhSTMalNdHZ3
 Pj11bu6YMIACZA5JnGrpamXHUeiauKuGKWCa4nsJT79UZgSAcGFbuRLcBNtxngPUGcSpyWu0EZg
 6QTgDUITSxBHvEH3p3wrZaeM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cfe85eb0f69d5cf8;
	Wed, 14 Oct 2026 03:07:43 +0000
X-Mizu-Trace-ID: cfe85eb0f69d5cf8
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: joannelkoong@gmail.com
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	lance.yang@linux.dev,
	hughd@google.com
Subject: Re: [PATCH v1] mm: unqueue deferred split folios outside the lruvec lock
Date: Wed, 14 Oct 2026 11:07:37 +0800
Message-ID: <20261014030737.2102-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261013221307.850803-1-joannelkoong@gmail.com>
References: <20261013221307.850803-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7AA80180006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: pid1hz114gj9da96pkta71phqq3isfto
X-HE-Tag: 1791947265-573320
X-HE-Meta: U2FsdGVkX18PXzXIJHh27g/yOZsgqgcftGHvHd+OHrXO9dvkfekbzjiKcAeBHExb+bSNLNN85pkYlwPsa6h3u5Fr8BbCtindLlZuBZvhx1hLjiJfZlxsjpJAglX4epI9oE1dNFAtn8QuqNKR09BHwH4YCf5rvh207lK6CIsnIRt6RSryEdZbM2Fxuh/A9rgkOkU+2VP29/A50cu2Y6/btQ9xsbVnkMX0byWORAWXDbCicMnrVoAaspO3KiNmRh3fce0U1EaGps9uRvT+0/uATxfRGzRsRtk2HBrLDe47tJ6rpRDBxV7byeE6Jd+1cwIiJ+NEhVb+hN8xvCw07b7oX7JMQ6voAucEYmm0OgFUVx/pMr75Afmb6dmDa78K5/72qCneb1Bt5iCxsykkFua6imv+5qzueB1K/MkfNFK3QnEdpreGTS9GAO1EBJXEM8oSMInpWUbzTIFHiYLOU68rNcUbYRlqh4SEA8F2mCcxm6iX9FFD/SA/yB+U9he/2vLjV7CDfWxmunMSQZnUsuxbBU+VBRAH0frbn1lMlg6xgnmZhgyjx1vMwZr3d+A5uWyejDKgdCyOGTaLNRf+kZIE7iGhrcWGTFGL/VOxpBtJUHl+gwbcvJIFYPcaYefTwLkT18vwmUINyDA1osuhbeG3HToFK8gDbAY9DJkV4AtysuTBSM0BHXxSgO3wO7/FGsfBFoywEtv/TNcsBA2um7feXf0i37rSZZEZkUBjNEQ1AQCRHP7vrLImAXyjgvhuetj3cSeWQzf8GEB4yaERsl0FtQIXtstzCkbBfNzvtwf1Ki9WLfd0faCcVH8qHnDFi17lSs6PqzHY5eC6h9frV7ruYRV+MG/31ZBnn6orOiSYgUVESjfwTnESDf0g8WgXNyvreLZR+tCjpRyakeT/Q6pqOescy3pdbOevV3/OU2/3zUdFL5rG3qnjNQaxhZsxF+j78r1BZ2o4a+katA2m0vK
 oVqM/Cic
 q5AZiQXmSaux7OUgHdgTcRScCwqtKO4xVx1JpWX9u+kTY9ilv5wpEwraW0qcnadKPB+zAQ5hY8UqvCAYWPZE1yogHZzVg/gP7fYy/Ufq4ntRQueRCxDL7We53Oblxj91efonDGnD84W7UFV9adTyCJ0Qcw7FTo6xqy9oaM6KlwqQLssTjt4lpPZ6oS0aTatrU82GKFgpIEkDQr/F6hU5SziJxwjFPV1osjCbH7dUSFg0h5gtmhklCC/M3ETBi2wJu9vel877jiSobcn9I7u0e6dkDHQkXoocQNcfz14s0kIfnKbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Oct 13, 2026 at 03:13:07PM -0700, Joanne Koong wrote:
>move_folios_to_lru(), folio_batch_move_lru() and folios_put_refs() call
>folio_unqueue_deferred_split() on folios where the refcount has dropped
>to zero. In these paths, folio_unqueue_deferred_split() is called with
>the lruvec lock often held (move_folios_to_lru() always holds it and
>folio_batch_move_lru()/folios_put_refs() usually hold it for every folio
>in the batch except the first). However, it's not needed to hold the
>lruvec lock.
>
>The lruvec lock protects folio->lru and the reclaim LRU lists whereas
>the deferred split queue lives on folio->_deferred_list in
>deferred_split_lru. The deferred_split_lru is a list_lru with its own
>per-memcg per-node lock.
>
>There are already other existing callers that call
>folio_unqueue_deferred_split() without holding the lruvec lock (eg
>__folio_put(), shrink_folio_list(), __folio_migrate_mapping(), ...).
>
>Add folio_batch_unqueue_deferred_split() and use it in
>move_folios_to_lru(), folio_batch_move_lru(), and folios_put_refs() to
>unqueue each batch of zero-refcount folios from the deferred split list
>after the lruvec lock is released and before
>mem_cgroup_uncharge_folios(). This helps shorten the lruvec lock's
>critical sections, which run with IRQs disabled and are highly
>contended.

Nice work! Thanks!

BTW, have you seen measurable overhead from unqueueing deferred split
folios under the lruvec lock?

Any before/after numbers for this change, including the cost of the extra
pass over the batch?

Cheers, Lance

>Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>---
> mm/folio.c    | 24 +++++++++++++++++++-----
> mm/internal.h |  1 +
> mm/vmscan.c   |  3 ++-
> 3 files changed, 22 insertions(+), 6 deletions(-)
>
>diff --git a/mm/folio.c b/mm/folio.c
>index 35e242b48870..85144078e635 100644
>--- a/mm/folio.c
>+++ b/mm/folio.c
>@@ -109,6 +109,19 @@ EXPORT_SYMBOL(__folio_put);
> 
> typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
> 
>+/*
>+ * Unqueue a batch of folios from the deferred split queue. This must be
>+ * called after the folios' refcounts have dropped to zero and before they
>+ * are uncharged (see comment above __folio_unqueue_deferred_split() for why).
>+ */
>+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch)
>+{
>+	unsigned int i;
>+
>+	for (i = 0; i < folio_batch_count(fbatch); i++)
>+		folio_unqueue_deferred_split(fbatch->folios[i]);
>+}
>+
> static void lru_add(struct lruvec *lruvec, struct folio *folio)
> {
> 	int was_unevictable = folio_test_clear_unevictable(folio);
>@@ -177,14 +190,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
> 		 *
> 		 * We're bypassing normal cleanup. Clear flags that are not
> 		 * applicable to dead folios.
>-		 *
>-		 * Since the folio may be part of a huge page, unqueue from
>-		 * deferred split list to avoid a dangling list entry.
> 		 */
> 		if (is_lru_add && folio_ref_freeze(folio, 1)) {
> 			__folio_clear_active(folio);
> 			__folio_clear_unevictable(folio);
>-			folio_unqueue_deferred_split(folio);
> 			fbatch->folios[i] = NULL;
> 			folio_batch_add(&free_fbatch, folio);
> 			continue;
>@@ -201,6 +210,11 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
> 
> 	/* Cleanup filtered dead folios. */
> 	if (is_lru_add) {
>+		/*
>+		 * Since the folios may be part of a huge page, unqueue them
>+		 * from the deferred split list to avoid a dangling list entry.
>+		 */
>+		folio_batch_unqueue_deferred_split(&free_fbatch);
> 		mem_cgroup_uncharge_folios(&free_fbatch);
> 		free_unref_folios(&free_fbatch);
> 	}
>@@ -1020,7 +1034,6 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
> 			free_huge_folio(folio);
> 			continue;
> 		}
>-		folio_unqueue_deferred_split(folio);
> 		__page_cache_release(folio, &lruvec, &flags);
> 
> 		if (j != i)
>@@ -1035,6 +1048,7 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
> 	}
> 
> 	folios->nr = j;
>+	folio_batch_unqueue_deferred_split(folios);
> 	mem_cgroup_uncharge_folios(folios);
> 	free_unref_folios(folios);
> }
>diff --git a/mm/internal.h b/mm/internal.h
>index 0ca863f2639a..ac72577a6e3e 100644
>--- a/mm/internal.h
>+++ b/mm/internal.h
>@@ -760,6 +760,7 @@ static inline bool folio_unqueue_deferred_split(struct folio *folio)
> 
> 	return __folio_unqueue_deferred_split(folio);
> }
>+void folio_batch_unqueue_deferred_split(struct folio_batch *fbatch);
> 
> static inline struct folio *page_rmappable_folio(struct page *page)
> {
>diff --git a/mm/vmscan.c b/mm/vmscan.c
>index 29b31446fc11..94859a830fb0 100644
>--- a/mm/vmscan.c
>+++ b/mm/vmscan.c
>@@ -2007,9 +2007,9 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
> 		if (unlikely(folio_put_testzero(folio))) {
> 			__folio_clear_lru_flags(folio);
> 
>-			folio_unqueue_deferred_split(folio);
> 			if (folio_batch_add(&free_folios, folio) == 0) {
> 				lruvec_unlock_irq(lruvec);
>+				folio_batch_unqueue_deferred_split(&free_folios);
> 				mem_cgroup_uncharge_folios(&free_folios);
> 				free_unref_folios(&free_folios);
> 				lruvec = NULL;
>@@ -2041,6 +2041,7 @@ static unsigned int move_folios_to_lru(struct list_head *list, bool do_rotate)
> 		lruvec_unlock_irq(lruvec);
> 
> 	if (free_folios.nr) {
>+		folio_batch_unqueue_deferred_split(&free_folios);
> 		mem_cgroup_uncharge_folios(&free_folios);
> 		free_unref_folios(&free_folios);
> 	}
>-- 
>2.52.0
>
>

