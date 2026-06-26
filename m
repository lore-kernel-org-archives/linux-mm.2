Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F1DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591B66B0123; Fri, 26 Jun 2026 14:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569C06B0124; Fri, 26 Jun 2026 14:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40BAC6B0125; Fri, 26 Jun 2026 14:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 142636B0123
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 749B7120503
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:42 +0000 (UTC)
X-FDA: 84922884564.04.1F9B45E
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3B1EA000D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uSX8ekRH;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782498160;
	b=qha0uzaJjDQ4uM6w5vKxgdn3H5jarVBUMHXi8xW7OvIy6U9Z2QaPjhopgcPx/mJXr3Zcbw
	26J4bDaq69Tz07Ulb2cy0szz0VAsq9xWSOeN6QXdMhqwlMDIhubYs8yF58+SW8PJ2tL7Fm
	GVK+mDiqBNaYzdPtEP851BPu/YClMvs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Si58C84HX9Fb8r6EvkY+7noECsiq5uUlXevnn3+D3Fw=;
	b=4Klsf16hewubPCAPTK/swPecWSbjDmdo6oz23m0KNo20/wGg0EEMqUBibW33iqh7hvlSCm
	rp0fU5l25MDBT57Eg7CdYyJFY2LI4qkf1TIRX6Rc4c2Tm/xDty8nWUy8jFz/vDWi0MT7gL
	8zMm2OfSuAfwopIhj1RMY1Zwcg72WO0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uSX8ekRH;
	spf=pass (imf25.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51a1fe8f578so13335111cf.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782498159; x=1783102959; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Si58C84HX9Fb8r6EvkY+7noECsiq5uUlXevnn3+D3Fw=;
        b=uSX8ekRHrDu2dAXzIDwe2Oo/xTpD2UwCT7lSZjipzfDe/GW8b/hFyJQCfKe753l34F
         N6/bvCfvNhFa/aL8Tbe8MJIT3DY0sPOZo/NhrDTTqXkd6LYi1Mv+yrCUfJ391zE6fxGg
         kGgl+c2tjkY9RWrI3uEK/Hu6Z8aXOvrZX9ZDOtFxpl4o2qrHMQ5TgI7W4yllm+MSFRoz
         OnlEdSLR8F12lbD2hmKKc/dxWu6KaoC7yrCtN4bdU0fUzKWvcdB3sLU0C9jFdG9DqgcU
         bH2/zjAG6fwlEgFEKJr97LyRrV95evfzXfGbfR2xe79eG8YLHoXEpjI9yZefvf62IidT
         vMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782498159; x=1783102959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Si58C84HX9Fb8r6EvkY+7noECsiq5uUlXevnn3+D3Fw=;
        b=F/uer9JRJ8aqs0sK2r9Yj4aCcl0hz05r6zh8hswnq23tF+oePusG5BX8FoXtqcJR5g
         7MTIuL6smk2oHUAzb/BQXHRP9xwECqGnLb4ad3SqLfI9uMZy8Hv/nadqZf+pkUgjeiCv
         aLgUUfUBovIN4wnXqYaXy5ayoFmi7/rnnXdz6EeHujgXuNHJ9kk1g71E9Yzk4WdkCWse
         1zbDVTnz6BjW0eo2kTmB69fkwbBCgIjRMgpi2wcrYIAN8Gy4Z4JPwVV6gbs/TyDTnX/E
         kOlIkc/cTZvpKEWGCTH7HfNaq/AMYrlCe42QlVKCYqgj21ysMKFYWr0HdeRmQ7VFr+eL
         j0uQ==
X-Forwarded-Encrypted: i=1; AFNElJ+RAp9NKNHPKuvn+yq2cenNF311S6DXBL6TVa9RQ/bbterCTcXCfe16iEjygj0Eq5Nd8w98oJ3SWA==@kvack.org
X-Gm-Message-State: AOJu0Yy3XLhhqQujEkLrfZ9O78z/g8bddZ9uzD3b07YWpUu6T+DOnVoG
	xE+bMFZO2h96i7ZkLGRvtW4FGcBFc09ji+ZuGk0X5qBcBJ/mhxZLFHd3BsqsuVBPwnw=
X-Gm-Gg: AfdE7ckPpQpeCNn7OYvJZHycf/8Q3++cSfV0d2YV/7+NnBS/6uepVEpx5JuyCsfYj8K
	yLa2GL6mFwpFo6AN4uRQvfc4kqGKHQ7WJ8Lcb4U/sIPapm3sPtIpafn4zTi3iVpb75g5Hkr8GJy
	kWA0R5/wvW0a+cC8V18jcGBayKdcrkClbBsbRz6CrJRzUWz8P6fTKKBYKZpkMaRkD/PFAfur4w6
	zsBSUyCUuJzZocgWfSU0jcoR1gfAVVrKRrwQRFd/ldQAwTTJjQ1n7srgaluOUJo8rSItW6fUop8
	Gwchvp+CB7eWWIv+qhpvM2MEEwUTZ6D2tO7C4skusljDS7Yde418iKp4qCqIkPn+O/o4wIiK3Mv
	OOnviX52orqyw4Dq2uYjgO8TPExWCN8qAB6UXN2eFkavSRKroU1VVtvErbaRpOpgSkzmipKOOhk
	9yZTYM5eSp30A=
X-Received: by 2002:ac8:578e:0:b0:516:d657:2c65 with SMTP id d75a77b69052e-51a726e1eb7mr102974601cf.6.1782498158863;
        Fri, 26 Jun 2026 11:22:38 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51a9b5b4sm98694961cf.18.2026.06.26.11.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:22:37 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mm: page_alloc: fix non-movable reclaim storm in defrag_mode
Date: Fri, 26 Jun 2026 14:21:20 -0400
Message-ID: <20260626182215.1107966-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626182215.1107966-1-hannes@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3i7ncwauiy9ghrkh9r8sq7p8cnxms5w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3B1EA000D
X-HE-Tag: 1782498159-345899
X-HE-Meta: U2FsdGVkX187J+YrqZaKJqnAJWGNW0ja+w8c0/x+LbpXyUH25k+zZrWM/svW+vrlVNF+15D+MmxEJRk5jHAUZFcBDLvZV1Gl92of0SZGjcSzVSaxW+bVtGKkef5+qNzXHCWgEk01zyVk/X0BAQg8Cr7H1GCXyZ4znDpl7GCEXCco3aO2brzap5tyvf/HJsz9hqxUDHHL8QjAt+B6ZmE1Q3DTIE6jYYYHpBfVEOshj0HT0q5lpHyZt8S9TITWDsKkHOyqF35YE2dEFKtPXIxSm2qCEd2MCDWu9DXXdhqED+i7fkBFNW7vj7+iyYAzIsmGIl7l9DkV1Z1F6ZTxgaP+1RCh8ApzCNEkhS2/t7iNCJFqHFd/0wHK6Qycqi976bHInnVQpPc348Ir0R5SdJIrolooK+meoZe3tBn6QjAitqb0CqBbwJdDUSvm0KpPLBOWoV+TQZw+IrFdvP2xOlbnOxc491IyGP0Dmx8WtLm9vKuksARmY1zRpGjcc4BceKAHf9tJFwubiM4q2dya6b3aGEd6tC3lZdlgXGDnJJoFWPt4ExqMWmzZf56a6M6/CpgHAI7CsfocQOboWH9K1pRztvcuO5pkOHYBltJFrIONg5nwI31kYXFXp2ji8020dXCQ42abUU6a3oDIABbcmsD8dZGSS/0yZZnXKreGMoMlxRG+xEckaWJI+O5JtcwDrcKE9+CZqn1ploQpjP2etHjMe3MhkA9UBCpDjl9Qt0zhQGOReU62GvAI+g++iRmU11bF+A+ogJXJgMGdxA8lTL/RT1xHliQNzi7dUlkmtg444BAhH4k/FMjaOitXb/3ui5Siqymv/aCHNhHyDk967N9nCbpU+/eiWXhrUb359QGwkbtPiYFDthD/eIOEtMJoBn3gBvyDZqjIyO6+m3dfxeNJBFwYUBcurrk0ZHit7B18caFfDdvHC1lGq+/n81bLS+pWnpUqk34vqYw9o35sQwf
 MhyJ98k4
 ozBwR+Yt6yrAXwlsLRYTCcnGMfQZwrJrozwCuTGE6+mOehf8fL1yFbWaAkEvGlh3pj84Bix5vSwbnHWOkj6RPHBbShaCuoorjx450816JlEPYdwgUozmMszia3wojfzCc/YPtl0lCJt5UuM3wG3O/YJMJW3lveBu0qocLFCp3qHQA3l6nnvdsRTHOC6eZg2KLRc33AgzAgOjwbCIJOuf33Z8I2GwBOtf/wALJo3XHmNAcK+ZPJavPfQ1dByU1hpoy1FkQMKVyhHyoDj2oxU0ujaiVUrem60ZitpGr9/qI1sPdvCLiBXAUGoTvTAuwrK38KKitx3KNLnV7IgfhTHAHj1fk5gMDzZBrudHWT/k9DSv/M/lG11cDZX0fFtUenOhBSwtNBUYpUBLHKQLx4WR3BTZAQ7LQb7Wa/qlOS5OoUi2cRkjCWVA9QuSxEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we deployed defrag_mode into Meta production, pressure spikes and
excessive swapping were observed on some workloads. Tracing confirmed
that this is unmovable/reclaimable requests spinning in the allocator
and direct reclaim, causing excessive amounts of swap.

The initial plan for defrag_mode was to rely on kswapd/kcompactd to
produce blocks, and if those are overwhelmed under high pressure, let
the allocator fall back (__rmqueue_steal()) after its retry loops.
However, that retrying results in more reclaim on some of these
workloads than we'd hoped, sometimes excessively so, spurred on by the
!costly order conditions in should_reclaim_retry().

The storms are dependent on the request type. Reclaim will inevitably
make room in existing movable blocks, since that's where the LRU pages
live. So if movable requests retry on reclaim, they make progress.

When non-movable requests spin in reclaim that isn't productive. They
cannot use the individually freed pages, and the process is unlikely
to accidentally free whole blocks to meet the ALLOC_NOFRAGMENT bar.
They spin and overreclaim excessively, which tanks performance and
triggers userspace guards like swap exhaustion or pressure based OOM.

To fix this, send non-movable requests, regardless of order, into
pageblock reclaim/compaction. This way, they help move things along to
meet the ALLOC_NOFRAGMENT bar. After this patch, the reclaim storms
and excess OOM rates are no longer observed in production.

The longer-term plan is still to have all requests, including the
movable ones, help make blocks to spread the cost of defragmenting
more evenly and fairly; combined with proper watermarking to reduce
allocation latencies in the common case. However, doing this naively
unearths scaling and concurrency limitations in compaction that need
to be addressed first. Promoting just non-movables for now is the
minimally viable bug fix for the above issue.

Fixes: f38356df6474 ("mm: page_alloc: introduce defrag_mode")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/internal.h   |  7 +++++++
 mm/page_alloc.c | 36 +++++++++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..1f636cfc859a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1060,6 +1060,13 @@ struct compact_control {
  */
 struct capture_control {
 	struct compact_control *cc;
+	/*
+	 * Allocation request order. May differ from the compaction
+	 * order: defrag_mode promotes sub-block allocations to
+	 * pageblock-order compaction; capture still matches at the
+	 * original allocation order so prep_new_page() is consistent.
+	 */
+	int order;
 	struct page *page;
 };
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9dee1c47e795..575a99a4c723 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -728,7 +728,7 @@ static inline bool
 compaction_capture(struct capture_control *capc, struct page *page,
 		   int order, int migratetype)
 {
-	if (!capc || order != capc->cc->order)
+	if (!capc || order != capc->order)
 		return false;
 
 	/* Do not accidentally pollute CMA or isolated regions*/
@@ -748,7 +748,7 @@ compaction_capture(struct capture_control *capc, struct page *page,
 		return false;
 
 	if (migratetype != capc->cc->migratetype)
-		trace_mm_page_alloc_extfrag(page, capc->cc->order, order,
+		trace_mm_page_alloc_extfrag(page, capc->order, order,
 					    capc->cc->migratetype, migratetype);
 
 	capc->page = page;
@@ -4147,10 +4147,27 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	unsigned long pflags;
 	unsigned int noreclaim_flag;
 	struct capture_control capc = {
+		.order = order,
 		.page = NULL,
 	};
+	int compact_order = order;
 
-	if (!order)
+	/*
+	 * If fallbacks are not permitted (defrag_mode), we either
+	 * need to reclaim space in a block of matching type, or clear
+	 * out an entire block to allow __rmqueue_claim() to convert.
+	 *
+	 * Reclaim by itself is primarily freeing space in movable
+	 * blocks, since that's where the LRU pages live. So this
+	 * works for movable requests, but not for others.
+	 *
+	 * For those, promote the order to help make blocks, instead
+	 * of spinning in reclaim alone unproductively.
+	 */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		compact_order = max(order, pageblock_order);
+
+	if (!compact_order)
 		return NULL;
 
 	/*
@@ -4166,8 +4183,8 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	fs_reclaim_acquire(gfp_mask);
 	noreclaim_flag = memalloc_noreclaim_save();
 
-	*compact_result = try_to_compact_pages(gfp_mask, order, alloc_flags, ac,
-					       prio, &capc);
+	*compact_result = try_to_compact_pages(gfp_mask, compact_order,
+					       alloc_flags, ac, prio, &capc);
 
 	memalloc_noreclaim_restore(noreclaim_flag);
 	fs_reclaim_release(gfp_mask);
@@ -4203,7 +4220,7 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 		struct zone *zone = page_zone(page);
 
 		zone->compact_blockskip_flush = false;
-		compaction_defer_reset(zone, order, true);
+		compaction_defer_reset(zone, compact_order, true);
 		count_vm_event(COMPACTSUCCESS);
 		return page;
 	}
@@ -4443,9 +4460,14 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
 	struct page *page = NULL;
 	unsigned long pflags;
 	bool drained = false;
+	int reclaim_order = order;
+
+	/* Match the slowpath compaction promotion in __alloc_pages_direct_compact */
+	if ((alloc_flags & ALLOC_NOFRAGMENT) && ac->migratetype != MIGRATE_MOVABLE)
+		reclaim_order = max(order, pageblock_order);
 
 	psi_memstall_enter(&pflags);
-	*did_some_progress = __perform_reclaim(gfp_mask, order, ac);
+	*did_some_progress = __perform_reclaim(gfp_mask, reclaim_order, ac);
 	if (unlikely(!(*did_some_progress)))
 		goto out;
 
-- 
2.54.0


