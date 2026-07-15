Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FF5C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:29:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48A536B00B4; Wed, 15 Jul 2026 09:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461E86B00B9; Wed, 15 Jul 2026 09:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350626B00BB; Wed, 15 Jul 2026 09:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFAA06B00B9
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:29:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C2E6C0134
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:41 +0000 (UTC)
X-FDA: 84990725442.04.DA58957
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id A3AF820006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJfXWfHP;
	spf=pass (imf13.hostedemail.com: domain of 3CmlXaggKCJM6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3CmlXaggKCJM6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mf72NgjR/YGP7OyZOYwhsTao63XeRdktGGMG23Y8QgY=;
	b=K6XkoAiZ3RxxAEvA7DxY7xinCgwvo0LBnqRROHKqw2CFosHG344VjRDiYcuHvNuexKwy32
	Qfvzc+K5lWkE5kkfU3OLPM2zv43tzqyZzEVi5oRfDE1kG+1DOcxfThMF0sahJfYY1iaeFJ
	wXCkq+g3ZQLv4G0yMyek3gdMReOIWUY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JJfXWfHP;
	spf=pass (imf13.hostedemail.com: domain of 3CmlXaggKCJM6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3CmlXaggKCJM6xz79xAy3BB381.zB985AHK-997Ixz7.BE3@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113419;
	b=M6veE09ClMgPKQwafoOZTHqg8y7WhD86hryKeMUct5SKee2x47Ta176a/C5SE43jkgmIkN
	HG0MZLLxD/RM+QwsqQVC/V4P0wq6A9RO/9AZiqRDD9P08Q/mvR2wDK9w7fOQP7JSU/51ZU
	Ug7xYPWwf2YLtP7mDHaGROAnnFFLHjg=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493ba771d1bso20290995e9.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113418; x=1784718218; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mf72NgjR/YGP7OyZOYwhsTao63XeRdktGGMG23Y8QgY=;
        b=JJfXWfHP7as8ZP5c5M9MhHdoLiXbbVk1lxOJUMAK1W3vlWgokSemTbZUygAf2Shlgx
         kyjYLjWgKp9rqBGRDcor8VGEjMFoj6KNYtpY61pJwnhyjyIXflOUJ2J7kmdhGDSlfgtu
         gEnjoza2av5D4HPTdQRXFmM9vCHjWzPFRVO3DxEkpowDlrT6BZvNZ2tLxWUZNiCaP18+
         ML2tJl71HISKarc3OAdM7Xx7ThGlUWWKxT9/63ruF66tv0KcXtHVx4DmF/sAsQ56hi6u
         dtCb37XHrUlpKtpa5PpDQPKmylF4xG1ycExktdWNoIsCaZ9RD4LDfh/NU8PhsjKujB+V
         oPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113418; x=1784718218;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mf72NgjR/YGP7OyZOYwhsTao63XeRdktGGMG23Y8QgY=;
        b=A7EzWeWEQK/vlV2BfEtQtsfMSdZWQ1MXq56tROPeOg2m9OOqhHrEaPhi07hs5w7Uno
         8NqPiQw6On+e4MPAA/crF+/uWj9/9lbmtUmFRY3172CN9vNAc5cVGEoUchdnh9ZQWCNn
         sTbT8pniMOLQmAVraCEKgrZdmzB1v/futYB5CnZUFkldThHdH8qxSvBq+d2vj077IxDs
         IPmdda0lsTh1squO1P+hxdeC57v5WQhMnc6tvVIv7spCqVdQ4VCdBU5oUBnS+kPulRCV
         bW/nBb5wKhGh2z6IokvaTXN+5NabVP/bOTPdrcBfyPKcsSV6a0P8lLDiVe64OxuUGNAw
         MG6g==
X-Gm-Message-State: AOJu0YxWlSQnh2Yr6hDZy1M8ZV/0i2bH5SYiH18A62oFF0n3vJIaJDTQ
	SHGlt3t5VyWNMQ6/47Tmj1VFIy2ZYsYgmpizi8RGr9pzzL+96UddcMytlgguyL8t/xD370XoCS+
	QnYvbWut+BA7fIA==
X-Received: from wmat13.prod.google.com ([2002:a05:600c:6d0d:b0:495:3c56:7eb1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3223:b0:495:50c:259c with SMTP id 5b1f17b1804b1-495050c29d0mr54629235e9.7.1784113418268;
 Wed, 15 Jul 2026 04:03:38 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:18 +0000
In-Reply-To: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Mime-Version: 1.0
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-1-fc4d246f705d@google.com>
Subject: [PATCH v3 1/4] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3AF820006
X-Stat-Signature: c983myofojqk49ugbgnds8no4mfsyntj
X-HE-Tag: 1784113419-18851
X-HE-Meta: U2FsdGVkX1/O5qmdH7yc4CiB4ifauULT3VTn1O+PIDoFT8lZm12qzRGpxBYAnkYJnfBCauFyRvdi7DcL8IAbw5yKKtNSKCCyfGmDQD1wIvB/IFOnSXFG+BelqkBEDJKrtfj55Xu5caQgWkRFgOv8SA0J3CNQZVJPGjWNblPvZVSI9JRicBPhDhVPOLOxI3g5b9zdR/GR8TwS8fy9+P/yOuq8DxuZiOnMMSGH0icWbQiSGw+zuLSmMgT9Id0MKNjVy5tzGgo8HgGAohf/8mRLyXsGvhA+ron7mEUaGw0FaG/jcSDZobcNUp7AD5Swalf0pG1CyjZ+HjhDnMj57gg6mPxEw+/TXRAIqmmEbTG+v4KvgzbBTiBqUZJU3SD8AVfOAymBF1WvjugMKnjc1z33DOKcdniHxG+5dQHI3nH4CopRKIRM1MCSiXoDnEKh6XUon8YBNjK8HXv5zx+zmiVTRiZ+a5H1eUhynkGHQd5zCjxIk627I/qSxsebp73xjQISS+2xMoKJuLJMG75C7cRNHYYzWocHE2X2hAWQax+OGIGNt6vynfGZlIIVEDv2ZpGLLnDulo6qsffJ3MqckiOo5XLeGCE/lEYvwSXRYfL6B4QEbfZzxLFezTvbVEp3G8z/QUoDiZCC/hA2SlZ8s+gbs3elnN/IDsDYSPeZsGFSQekCH3BHcxG8rB13whmyZ4I/xJHIs6IGyM9KjX54mtFP+fz3hB/JuFdNnwDhhAcKyUVnb7on6MVVTfwM3BksLksvGcbZtRiLP86fJ6N6XgIUuG9a9UJ+wAQnyqgnqDC3Wj8QxWn2554m7SzJnSRWuYpRknbufRCvMU47D6KiRvxvitbq+VLL61mNDn8iEvziAKpxv6iRKHDzBcr44X0nNPMfVzWunWVEXzOoy2r/qp8qxG4CirfGvGYjHGQoKANvkQR2liNoryuF8op70AVOiz2MVIaPsiHMt7T9kYnJIui
 bL/riAqU
 e/GCK1k2Jw+62pOs7mZrlqRlVTWQHUNWhqWLNGoOlI0dEZv0a4bhZt1lmrfmeNv4nL7mG5SGu4imUzv+GDVKQBta3KkQn+ipw18HXLqazWMQ3jYvCXJYTblVqVjzVhdQmJ9sjfffi3PzBCl0twg14K6WnGTVPzadpsAY35VCXrC3h+64NGRLwCzDH3KWVv/r23ZYQk44h2JzeAhO4GRaalw83HEj9zmgAKGK0DmKmRdZVg2KzGuKy+vZGYiOR39VdexIxsQoogzEVWmsJaASJzjagvxB0nmJ2XTjPvrIuOOtSoPPTkAsKqLGiN1rmKDvXAT16Op4BWvargXhtK/Is5rhmzs6fXuk+klcPUEwq9Y4rkt1waps6Z2TOU0lf6xHwI8NRVO1g7wEP7qZ+Hh3mv1b5XzDb5HbD3rk7uy6xRXVXvtWWax1KCC73PQzy1WI5f5kdWIY/oMsrV8aWdcx7Bh/FfvrXGW4+hFWFt0y+99D3/2MJGM0aZA28lI35nxlgt0hCkYr+xJ6kvpbPk7a53hR5lQCaVFWfl8IRO2nN0+Tu/Tc2zzFp6VzjAe3fYmHUlP1/X/uxC95X5IbJIdLilpogRLBfNvfncw8EwtOY90asFOzugjkutF4DUooKCout3ZIu9A6fx3DUvDFFsRRo96DwMPrDqebiplviDEQUQtQNC/yCqvB9U17tfg==
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index af63558391345..c2da85e69a0f8 100644
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
@@ -5399,7 +5399,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_frozen_pages(page, order,
-				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
 		page = NULL;
 	}
 
@@ -5522,7 +5522,7 @@ EXPORT_SYMBOL(__free_pages);
  */
 void free_pages_nolock(struct page *page, unsigned int order)
 {
-	___free_pages(page, order, FPI_TRYLOCK);
+	___free_pages(page, order, FPI_NOLOCK);
 }
 
 /**

-- 
2.54.0


