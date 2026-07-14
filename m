Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67230C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537FD6B0093; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9326B0095; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE026B0096; Tue, 14 Jul 2026 05:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05EDA6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:32:18 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63E031402DE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:18 +0000 (UTC)
X-FDA: 84986866356.05.A0B9777
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF0812000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=etlFJxK8;
	spf=pass (imf31.hostedemail.com: domain of 3HgJWaggKCNM8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3HgJWaggKCNM8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTwXaMbWixpG13O8sS4fpRBsh80OpAwJDb/b9qaatlE=;
	b=rnXJrvlUMvj9LVsSp1laU52g5+bJ5WAm7Z3rCc2Y79e8mB8sbLPMTjv5kQRKOaI9qLxqcg
	bxezQTYVVNLQ2IfqQOJxem1KGWCu+QBzsrclKuBISIzvjmc6Q0V1102tQyYHHDbdyM421y
	s6DNcYKKHxW/m67QthFDGInLFCrX6Uo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=etlFJxK8;
	spf=pass (imf31.hostedemail.com: domain of 3HgJWaggKCNM8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3HgJWaggKCNM8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021536;
	b=OU2zBp60nu5fnpkuFvYo+ZvlVX8xr6PVCUr+oE6bNmMVWSzbiLccTX/jUiDoIQBZ5VHJK9
	qamnrA4ZbeXJrimr8sUHPFbHTN5IHvBeYKN8rgmhVyDDmgzAnDza1EkfIFoBTFVFut3/RV
	+Zqk81bYeFJ95vF0EmJ3SvK3p+3Xlio=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-472bdd6f529so2494693f8f.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021535; x=1784626335; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LTwXaMbWixpG13O8sS4fpRBsh80OpAwJDb/b9qaatlE=;
        b=etlFJxK8orQQ76gJh6Z5Fy2jMZN1VJGJbGD+siEdmm/vOfAixOKyK1PfHkfARG2LsD
         CCdB4NjuJ+onUM1Y6uCOXU+izM6HkKdASnsp4MOSW2hUE1o4Y3sNQ/A7V3hFgCimuR49
         gPMNlC+p/dOt9tE2iXC+heS+dmm25pxqtxffMV7geFTxS/rEEEDEoj0FymQpPmILcSSS
         7xv2TRXJ10a+2omJdarP4zL1UeKo6/CouBJdq7PnAcaobMf6wxn59ZPZmiC13HqXnn9H
         MI5POdMuH4fb7p3JQ9KmA0Q03qY17BDHr+ioqEx1nJqn3ApFTVL/9A+TdwftRl8wPEb4
         9ijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021535; x=1784626335;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LTwXaMbWixpG13O8sS4fpRBsh80OpAwJDb/b9qaatlE=;
        b=Me1NXd+7vNqhio4q/y8hRulbkbHzFqEGg6WG5XZrC5NQOMbpvMI+pNVUOQMMpA4Ggg
         O2T6UQ9VoMMHO04Lp6o2EJSNSFtiu4C2iudhZJ7Wx3LfrmIasTdPT2TYOePRHqW160U3
         V7bwpLjS96xuMX2s1fCjyF2JwNkx9y/gqbrtUX6gKQ+nW3eip45huJxwAGojLrg53XaG
         G3d1YSNephN+WIcMCfGARJ+2BwiRqb2lCckVpAaDURsWIYO4pgFUy3DqrJyK2pKr6XRB
         ZIZgiPfKIVq0D4hxNN/WxLf5iOmhp3buk93APknSgG4O8CfU3OmhH9NXzlkPMzcM65bu
         94XA==
X-Gm-Message-State: AOJu0Yy4A7qDlryppzqjyxuuaREYfDKCCCnpEcW5RRqgAM7DMGHY4AKp
	ABYPFXNBNECLyLAlI/jp7x5qw0CIyNQUsOrGoQ+mkQi2/PKu8hUgTXNAH1fLAkZK+oq+auV18Gu
	PGDJeWoMx+aqZoA==
X-Received: from wrte4.prod.google.com ([2002:a5d:5004:0:b0:45e:6a78:7fad])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f87:0:b0:475:f0c2:5b00 with SMTP id ffacd0b85a97d-47f488dea53mr1863182f8f.54.1784021534601;
 Tue, 14 Jul 2026 02:32:14 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:31:59 +0000
In-Reply-To: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Mime-Version: 1.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-1-3c20ed032b14@google.com>
Subject: [PATCH v2 1/4] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF0812000A
X-Stat-Signature: 81wo3ytcbdw9fyffe3iianxszpxgwek7
X-HE-Tag: 1784021536-336427
X-HE-Meta: U2FsdGVkX1++jKSH3oVNGfx6yoxhCzT1E+8ICrxce6OgnxbkFmlBRXdYRp0uAGvirW5SaTydhi6WIUvrjl6DaC711+zHBvzUdbccpNPLD4WU4DGUUC3F3Phw+B7JPQazjzUP6YVkaFno90+pPSN3JbNaHUPc7YZQZmt/MKn8LAsHQKw9uwSjNsrd92eCn8NUncj5D1dcWcY+yUU8dxsGSFgLgd1sB+TnZufvozYh43PRg2jAIQrhbBqBcehhV2OlGaHb11sr0ueUiDkiUypRSH9AVhuuzCcjLu4uyjtpex/4pa6ef5Q64KYeSFh6+g3pyWhAl3pxrVCQg4fv9qsjUoJNBwUHZXvKPr8sqL7S34Z/FSBhVC1DYvzyTxmvnfE5LC0Qf2cgLatuRFT84qNf8LRTPbnbLgOMkWxsNO4Yr/0IrejqygXroDPklqvJNX2dij6N/Elok2e4FGCRewfFgWtyRTch8YDw/rhN70W9yjRNpdggSkJfmM0RTtGtlmJvRslH48EFEKcdrjiRA1XIDaN+vJY2MRThh5rUOe1PW+fMYDztSKbjLGU1si0RjegTa96ZnQbTWS4uuUoIol+ZZ/MeHcDN4o2SB9tMqZVo4UmQKc3pbTtEmXzYB5iEpu7yzn/zn12F9DZHYumM+HjoerUkaUsMrKASL9Liu5zY98t+Ofn00WeWjK4zcIgLYWWvqh4IFT0c7+0I9j96P/IK8UlaVbxt/ywlK5Zv5nXZ+n2ZXuvVdlXlKL3fX0VvOh26fAyVO5Hd7SxmXE2eRNN1QujG4ifKxjP7XJ7VAM+4441vXNmdyyVF1Ol8o08Qrw1CHIzKlyUMaSRpvAiloNBB25ZJcQghd9lIma+FiMTl520M+sjk755pp1hnDzpKPgZQq2KyK2zoa0CzRjYGW7T8IzlG0jqUiU2GrhyTXl9/g9dJzGFmqEyVza91XthdoTFvXXih9LHuz+NPf089yBS
 RKBzrZkW
 +gpXIkgFnwlU9KFr9dG0LBtPlryuLP1k8zH2Q3EN9SOT0Ky6O7QDPQ9qND4HleCccqrWtU7YykVY25LgRTqzVRO2JdQb/fdmxXTjTbH+DerH/Z7kdNh5w+5mIqoCKLeK7r0lpRXDUtNaVwtdGD0mqdDxwBH0UwoOG7eVj9G0J3noauWJH+PXK5XuGH0vnFJHFIaa5KkGY15YruJOcU0H9Q3Ar4unWX+17zRKxG5uyZCr3bSCHOEuSPJ8gn6s8ZRfU1Y2MMPd51HMQcXHnHY85UVZbVOZj8/tS7Mzj6ZLBj+VKaSiqD0TwSR10ntFsJG6TcYaL7fjAyz7vftSPTxwhbor5m3JO/uhBvLB5ktc14xdsRhapEZJh7mVVus9woYYQbQLvMBIeNbTWD1naZml0sx+QcttMwTx1qEd2U67oy8UprzHJ9CsjpyZXjbyhBbznBjzn2ud0dmoahsbppIJxsSqNLrwhzH3Y76KYbhIcs5MLO0GlS/3AqRJUVQIHki+/clA/KBTJkvzaqBRIz/Xv+wMXx+7bMFGBEqNmDcY7dJdwC64cd88jqKoA7P8hS95vht2DXfD0mXGjT2zovUGfoRWlSGii73LQFefuVJsutsKOul3+pWZz4pJAIOom4aCvDXBRG1iA+EN6ZdEbYg3BCJaNy7PevzIvonCt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As discussed in the linked patch, the there is some inconsistency between
"trylock" and "nolock" nomenclature, let's align it. Since "nolock" is
used in the public API it seems to have more mindshare so do that.

The linked patch did this for the ALLOC_ flag but forgot about FPI_.

Link: https://lore.kernel.org/all/20260703-alloc-trylock-v5-1-c87b714e19d3@google.com/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9c97a86da2b9f..f3f08d0313cfc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -90,7 +90,7 @@ typedef int __bitwise fpi_t;
 #define FPI_TO_TAIL		((__force fpi_t)BIT(1))
 
 /* Free the page without taking locks. Rely on trylock only. */
-#define FPI_TRYLOCK		((__force fpi_t)BIT(2))
+#define FPI_NOLOCK		((__force fpi_t)BIT(2))
 
 /* free_pages_prepare() has already been called for page(s) being freed. */
 #define FPI_PREPARED		((__force fpi_t)BIT(3))
@@ -1419,7 +1419,7 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 	page_table_check_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
 
-	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
+	if (!PageHighMem(page) && !(fpi_flags & FPI_NOLOCK)) {
 		debug_check_no_locks_freed(page_address(page),
 					   PAGE_SIZE << order);
 		debug_check_no_obj_freed(page_address(page),
@@ -1558,7 +1558,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 	struct llist_head *llhead;
 	unsigned long flags;
 
-	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+	if (unlikely(fpi_flags & FPI_NOLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
@@ -1569,7 +1569,7 @@ static void free_one_page(struct zone *zone, struct page *page,
 
 	/* The lock succeeded. Process deferred pages. */
 	llhead = &zone->trylock_free_pages;
-	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_TRYLOCK))) {
+	if (unlikely(!llist_empty(llhead) && !(fpi_flags & FPI_NOLOCK))) {
 		struct llist_node *llnode;
 		struct page *p, *tmp;
 
@@ -2882,7 +2882,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 	if (pcp->free_count < (batch << CONFIG_PCP_BATCH_SCALE_MAX))
 		pcp->free_count += (1 << order);
 
-	if (unlikely(fpi_flags & FPI_TRYLOCK)) {
+	if (unlikely(fpi_flags & FPI_NOLOCK)) {
 		/*
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
@@ -2979,7 +2979,7 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		migratetype = MIGRATE_MOVABLE;
 	}
 
-	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
+	if (unlikely((fpi_flags & FPI_NOLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
 		     && (in_nmi() || in_hardirq()))) {
 		add_page_to_zone_llist(zone, page, order);
 		return;
@@ -3002,7 +3002,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
 
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
-	__free_frozen_pages(page, order, FPI_TRYLOCK);
+	__free_frozen_pages(page, order, FPI_NOLOCK);
 }
 
 /*
@@ -5410,7 +5410,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_frozen_pages(page, order,
-				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
 		page = NULL;
 	}
 
@@ -5533,7 +5533,7 @@ EXPORT_SYMBOL(__free_pages);
  */
 void free_pages_nolock(struct page *page, unsigned int order)
 {
-	___free_pages(page, order, FPI_TRYLOCK);
+	___free_pages(page, order, FPI_NOLOCK);
 }
 
 /**

-- 
2.54.0


