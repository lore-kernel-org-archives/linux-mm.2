Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04DE0C44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94BDD6B00A1; Fri, 10 Jul 2026 06:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 923736B00A2; Fri, 10 Jul 2026 06:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C45B6B00A3; Fri, 10 Jul 2026 06:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36A9A6B00A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:42:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6FC1A03FA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:45 +0000 (UTC)
X-FDA: 84972528690.15.C86E1A4
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1991F180002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:42:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jf4tr63L;
	spf=pass (imf16.hostedemail.com: domain of 3osxQaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3osxQaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680164;
	b=u4qpQ3AqO6qy+9B0a9gJhHHBofqjSXfBCRwlaO2S+/6z4OyT0wb4LobPZVd51Wl2T9Urmu
	RVDMyA08iPLfiIEPQHsi3DBFsxy9eE4BGb2u4sCviMRDfxZs0BjBTwabODdCan13HLk9Fo
	ASJr5LP0OWP4VwLU4RwDnvzdl+bRtoU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jf4tr63L;
	spf=pass (imf16.hostedemail.com: domain of 3osxQaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3osxQaggKCNcC35DF3G49HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFOgGA5tRZCdjyayy1zy4J6RFFsh/yatP8j3QKMHQdQ=;
	b=A1y6NuMKalxKybAxNdW6wfEnVTi+iR4yG/W3p1rHGfakwfV/J1nBX6xG66UD2/tIW7ywxV
	u6BlbgeIpqEhd4QW4+aZOv4vs5C3DC+tTc0CuqrEWfFeIkVi+w1s4nDIkwfIanjW9PUE8y
	atTr5aUPtY6nPgY1VCCMKp9humZxnF0=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-c15d2ae8d2dso89125966b.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783680163; x=1784284963; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFOgGA5tRZCdjyayy1zy4J6RFFsh/yatP8j3QKMHQdQ=;
        b=jf4tr63LbOQL9o8Kb7pKIx/qBuj3rpZhRnOJCR4SyRPU/bgQneZuK3gz6PM9rfBEs1
         AEDugmvaELat7bNub8HSQSbuuE2dYXEAYJZ6Uqpd3T2GcJGRn1SE8bk3Oolnrhu0N2R0
         W+RjhJhXTkgLm6y6PQdy3ScCIZcbEEvjkMiGYpqk9kOBeTDEKlTs2OOuUNyPxYd0XVd7
         7C+T5gVg46GMxcjK+apr3Rg2btV4W7p8N226VejFwRQZp0KS+udu8GYE1nLedbZq126Z
         T4wGTkDZfNazdsXrUzeTvV5ZlB/AbgI3/wODOuQowr4MnAU8hCnLyvZMzRbGeD/03exW
         xe3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783680163; x=1784284963;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SFOgGA5tRZCdjyayy1zy4J6RFFsh/yatP8j3QKMHQdQ=;
        b=aVELzS4dpSPmwI59XwbySdfH4YHyN4iXC9w6XgBPahi+z7J8eOy89NOL5ddd0uYfUH
         X6ZbZPb32NSdRRGBpo26GunkbD7Qlc5G/MXpEZovJpmQs+RcRfDMTha1LxkymPzxEY8h
         GUrBC7+Dx/UTWraoKYSMSlSSA2BGYbo2NwHSS6z793eYCbXkhycOkdn9PAPZZIKzKNys
         V6QL87tOXd03tw3i88W+2fiOLhvhCjf4pa5QkQewELbCnRLvviTR37Q0zvepx9JRRrzU
         kQF38IKzDGe/2v+pFFp4YW09gj4dc3JMkRSKbnFi+SnRarrs4DDIlfTQbJMBw2kVzLiX
         MKog==
X-Gm-Message-State: AOJu0Yw3iEGLgZEaUbRFlE+g2uAZoxQRz9JlPz1RCkmLuBIWVD+AJmo9
	QrwF9RjQXmiKTPEAz9Zc2R9DFtJ2Yz+jo09tv7uu9hwsJFvQiuIVtD1loOLStoITL634lJAIjRS
	jcJbvTs7RlVE+PA==
X-Received: from ejn24.prod.google.com ([2002:a17:906:598:b0:c12:7dd1:56a5])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7245:b0:c12:b227:614b with SMTP id a640c23a62f3a-c15ce03d925mr500309166b.27.1783680162267;
 Fri, 10 Jul 2026 03:42:42 -0700 (PDT)
Date: Fri, 10 Jul 2026 10:42:21 +0000
In-Reply-To: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
Mime-Version: 1.0
References: <20260710-spin-trylock-followup-v1-0-affb5fe5ed00@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260710-spin-trylock-followup-v1-2-affb5fe5ed00@google.com>
Subject: [PATCH 2/2] mm/page_alloc: rename FPI_TRYLOCK -> FPI_NOLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1991F180002
X-Stat-Signature: zp8xkxfq4tanzw4yn9t7s5whepncs8c4
X-HE-Tag: 1783680163-522401
X-HE-Meta: U2FsdGVkX19nIq+Vfdw5gz+H55X4Dnzb7nv8rlM2ZLB/iGyAqfnDWI2muY5z72pIAYOPafxfHVDATbaq2v50WPORUa7Xqd3W1NjkkKB/D4BMuKoDrE+72sQxQP41jnxnIioE8fcm86l0aI05pchV7kQrcnMWFzYGOWdTBPbSUmpHpDWC0/uazRJVnftf7KRAatsBLvNiepGNctQF7hwIKNBh8zWXRaIKN3uUtXJocxeytXa3jo0NoOuPzPhVJTAlJAl260DrKkkbq0vrWy6MrHk6t5ohH9WjjqUOGk1IfOFRVM4YLeVGYk701Ii48RCD9xyUSt9tPDUFzIZMGrW4iDLmGzY0Wbq1QTmb0jNPeiP35yF7Mcqe0HZe1wGjcvgGwgdVZ7ZHZ7DqXIPWpwuY9fTHQ6/l4PCPhKHH22LrN5xqE0YklyvwWcwWxvsO5JoE+5u2n1uS9uu+lkZZsytnN4WrCLGJCX625Issq6ntI/4okZ9+Zx83NNkeE+nx1ZmF766wHNz2Fze1+oh05g/eiQeOz5PJ0Q5Y4qHiKvfMdUcSFryhn8IZIRZkP76XNS0dTiiIrjzxgUaUHezLBFp+QyaDf1A5/adjke6bttz/aTwakvZru2xSnfy+dVsiG2OiqsxRWKEA2aGzjLvPRMLAOZXLauOWbUsw0mPV0DYwIdMCUr0VhQ6XtmEgbmNLJlrK8chXac4NCpfo6EqDTKosgCVbqgAAXTd7dJuKBpd2ewh77XB/jxV0tHJfsB3Cskv+/1Gz6LkNR3OJ7pAKsNJRbk9oQlWipNVJ2VWC2Ao9fMOWu5GRVxE7otk3wPZERXVz/hn9zyT6W9bl6p7RTRSbnCbsTLl3dDh2tHyY1BawRVdQn6bmXuZ+UTJ4ElHHIZXAmvNIX9Q0NYetQ3wMCyNqZl40NeXkh+lRYQVJbH0eigs0baw4zX0DJ3aOYOi33qpbaMKpOvKcnBnL1mBpBYj
 7zeMbrrO
 NJepmv5QL9cSEmbBQubVVo3kS4U32lha6y7w1+yJePW1afhCILok0+/1LYZ0YtCQg5+RUbvngc+MA1lqedGnF/C1SZjCIBphNWLJE8J3qk+0aYmWAY9fv/AxVMDDRG3KoOK6Bxl5X4LqiB7/spXYVdDfiMUM2ISigdR6MmAyUT/1xSG+xzD2R69iF1afIdxuV4esTao7AMbkGMdTivsytn6q+hXv3MSlE/zM7Vu3+0nmCP4h416Onr4A4LM/9sDzDJFdZ1iCsPQtMFbg3Akp40Uj+UcfzLUTUQzks9gAtwuHJUCweHE85LbknlS1bRhH6zw2jBV8SnUUsRHZJ5V6ATX4rGr/AHZ2HjKQkBVE6z+wWJLIOFBE1CRK5fatUhDgP4fJlMoi/7ivohsCkosE3VEnRuUDYlHvs9JxCa6YByCe9c6PWRCb6kJxOKXbkfw1qB7eKGSsGb3KPAXGcegx/iNJjJ2SAtTvRQ0L10/R93H+bP9xMtoIdVWNyLczMVehGRKn3LZ+UB/tlwJ8O3x2fPnyH5sEkXpXCSmaI66lCwnBadty578wcVXTbPalO3R+wi/hmzOydbcoEQBnqfsgX/Q3HYGiubPe6lAjmwWz0TXnfkE+5s7zmYqKZQ48tU3HV7jeQG8ke9QyKlJbVoZj37DUrtWp4Og90PaCO
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
index 5fe1c11f919d7..ba8d882072de5 100644
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
 
-	if (unlikely((fpi_flags & FPI_TRYLOCK) && !can_spin_trylock())) {
+	if (unlikely((fpi_flags & FPI_NOLOCK) && !can_spin_trylock())) {
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
@@ -3001,7 +3001,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
 
 void free_frozen_pages_nolock(struct page *page, unsigned int order)
 {
-	__free_frozen_pages(page, order, FPI_TRYLOCK);
+	__free_frozen_pages(page, order, FPI_NOLOCK);
 }
 
 /*
@@ -5409,7 +5409,7 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT) && page &&
 	    unlikely(__memcg_kmem_charge_page(page, gfp, order) != 0)) {
 		__free_frozen_pages(page, order,
-				    alloc_flags & ALLOC_NOLOCK ? FPI_TRYLOCK : 0);
+				    alloc_flags & ALLOC_NOLOCK ? FPI_NOLOCK : 0);
 		page = NULL;
 	}
 
@@ -5532,7 +5532,7 @@ EXPORT_SYMBOL(__free_pages);
  */
 void free_pages_nolock(struct page *page, unsigned int order)
 {
-	___free_pages(page, order, FPI_TRYLOCK);
+	___free_pages(page, order, FPI_NOLOCK);
 }
 
 /**

-- 
2.54.0


