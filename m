Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C6DCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B234C6B00A6; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9F36B00AB; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDE86B00A8; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7951F6B00AA
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 443201401AF
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
X-FDA: 84716346372.02.B178304
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 984F710000D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Na/Hu1TO";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYH84USUtbM92TuFOgIUSH8TxfyB6yvkrbhTmn3mpO8=;
	b=K1/T2NtfWYbkzv4hK1qMUFdCYukPEf/NbG2uJ61/ydixvcIbkAb3cDUv5MW189OmPKxeDT
	TdIIwljN/aNqTUt9yXWPzYyWjWNvx1UVtHfgjZLSyPI8tE2Im9+WLveeE+g8j9GuriA89j
	OkkRCh9PIZUCS6drz9HN4Uip87quBi4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580584; a=rsa-sha256;
	cv=none;
	b=W1JWqZHRa9mJlFphc8AYIB59360iyqOly14yVOh0kzQ1YkWsG161YhWeZunN0Kg9QnDV74
	Epg+3CRt656Am/EWFrC6MHkiBVyWyBtENTiEV+J0HsHTPhxona89LWBmrsQHXZzMx408i5
	S/nYEEl7F0dSi8B6QkRFDfNuCYuIR60=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="Na/Hu1TO";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IYH84USUtbM92TuFOgIUSH8TxfyB6yvkrbhTmn3mpO8=; b=Na/Hu1TOZFT6GSbxkHu5RyQ+2c
	NUMDbYi7/nFa1ja+vUqP3hO7Sw/QP4WH+WOpX0HWoDlaKNp+VFr0ZBZ4lH6dPT43TUAruUkJsboJb
	BrzhyC+eFt4YYF5ZCh/lMqU1SW0iOW7tAbEWiHngqviGsh+eQsKiJ8H2NnkGJQQydRX0pRPAAYuZ0
	sdRrEko+G+YVaPJ3b87o/7LAtws/8vSb7H73L8rolvci/DteoUpSJ62LgkMcwg8AqN2pN3tDxmWtF
	ym7OZ+ZDf0VLraqW4xSos+FDU7UJ3cTNZRRzge2Yd51tklyFKwxWivDEQVE5tdLlC9BbleDRxVHMP
	pgnqw/bQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuC-000000001R0-2640;
	Thu, 30 Apr 2026 16:22:40 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 03/45] mm: page_alloc: use trylock for PCP lock in free path to avoid lock inversion
Date: Thu, 30 Apr 2026 16:20:32 -0400
Message-ID: <20260430202233.111010-4-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 984F710000D
X-Stat-Signature: jyozrbzad7z6usdih878a59ha1mzrscp
X-Rspam-User: 
X-HE-Tag: 1777580584-209915
X-HE-Meta: U2FsdGVkX1/HqVzXAWn8rKGqwIF1fyiTq2IsHrYDoOLsavSGM/UpmH9fqLNXzp3KLa6AYj/ZSbkgB+jNjEGaXhZKCK2cfskWKjWUPINuyK00O63fjZb8IvIPKMF4XGQGxwrwu1g/uvRv73gXQGu2+3k0v2Ui1uCTQF/Q+hPenuptVZZe3TPSiK+H6M9eVpxGQ9jKjMKs3wkdJmuOKGBU46YHhFEAg9uGSBpzoNHVRTn3lgKMMaIvrSJ/46V+WP6HqW7UUqUVXDO8WL+7Uxe3CH9Wur6kG/rvS3OnISVEtqDzXK9cLuqasmVDlpzGvIhleYl4VNGWq/0r9CZ93IQTP70kBPbNGwp8XdjBD98dj7tamZ2si3BFQYqQnOe2tHvn8DUg6CCsxbOYQ6PpP248jEJh4eHdGjDPeWkRO8g+HN/pru+9h1KhmS/y4n7v/F99szXSUBHJYXjjdsTsoY7C2sD917eAe/Sa69JhSO6pQK46pBPbWOcDJIcs4NPQQ9TR/u72pE73V793zUCJOhno6UZykWfsfdlJbNjZpkMs0Wg5QDJkoHcWueowzjkElK3wAn+lzavFdnhhZ0JIsuLoLTO2KS3RsAEFqG1RSNXW4AjGnwgpqRR1IuNw/VlKfEjqdmSwPmUucz4TZEH6a9mvyN+7t8PhfiSl6+PVg5utir0tPk88YZuD5bOrENE5iF5l6Li5xEMEUqfgI7ZOTvBV5CJmjB4kCO1YyKMjQ/kxYAZFHgAVYVhuMwKYbR+kO8AwpLnVDgZDoa+62c0mPD3vzXbU2M0GQ+Fjc/RS708xsxc6MeYm7h2kSCgmKj7kIsYke1LzDn6muTfrzU4sY6Iwh3YbIeVtvreWbcVKwnIinNcaHeLZPI0Q3q/x3bPA1jyvK3wV22Ne4LTOBdbZC2hTju0j7I249X6w0Yc2Ggi9E56WXp83Un3Y9ZbRQtBQ/oLfgMJvsnezxH4ormmBOKp
 Ku+j4YYi
 tdigax+619YVzhj6dXGtqnMfXxTkcYSm6fg1CFmigkdB1EMawgQMoPU4eFy/x25kwrQKpfkeerzz+MMtDNljPvIvJD/Xj2tq96lULMRuZud1rdBaoem/ZEHxHQbHnPRg+XrQzQL2XG9Ao10cWagDry+MzhqriWI/rAinWDlMiu+zxXSDk7SNnjLXmY9wMClz8x7VTpmQMbvYT9EnZ/eG6c5x4QXDFVFUwSrnPywTS8RRQSOGAtPP7aN7quffW7SZ+v/7RqIypME1cRwAICrokpH1NdMmgPrUJGQodCMOgkzSGXHTga7qbaEYE5vEEfSj3ybo0pVfsIgENLS2VpVx6+UfX/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

The per-cpu pageblock buddy allocator changed __free_frozen_pages() and
free_unref_folios() to use a blocking spin_lock_irqsave() for the PCP
lock when in_task(), rather than mainline's unconditional trylock via
pcp_spin_trylock().

This breaks a mainline invariant: the allocation path in rmqueue_pcplist()
acquires pcp->lock via pcp_spin_trylock(), which on SMP does
preempt_disable() + spin_trylock() without disabling IRQs.  This means
the alloc path holds pcp->lock with interrupts enabled.

The resulting ABBA deadlock scenario:

  CPU0 (alloc path):  pcp_spin_trylock() acquires pcp->lock (IRQs ON)
                      -> hardirq fires while lock is held
                      -> IRQ handler takes xa_lock
                         (e.g. __folio_end_writeback -> xa_lock)

  CPU1 (free path):   xa_lock held (e.g. slab -> stack_depot_free)
                      -> __free_frozen_pages()
                      -> spin_lock_irqsave(&pcp->lock) BLOCKS
                      -> waits for CPU0

  CPU0 cannot release pcp->lock because it is stuck in hardirq
  waiting for xa_lock held by CPU1.  Deadlock.

The key insight is that pcp_trylock_prepare() is a no-op on SMP, so
pcp_spin_trylock() does not save/restore IRQs.  Any lock taken in
hardirq context that is also held across __free_frozen_pages() creates
this ABBA potential.

Fix by always using spin_trylock_irqsave() for the PCP lock, falling
back to free_one_page() (zone buddy) when the trylock fails.  This
restores the mainline invariant of never blocking on PCP lock acquisition
in the free path.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c0aa39fa2f61..d98eab3e288e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3262,13 +3262,15 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		cache_cpu = raw_smp_processor_id();
 
 	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
-	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
-		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
-			free_one_page(zone, page, pfn, order, fpi_flags);
-			return;
-		}
-	} else {
-		spin_lock_irqsave(&pcp->lock, UP_flags);
+	/*
+	 * Always use trylock: callers may hold locks (e.g. xa_lock via
+	 * slab/stack_depot) that are also taken in hardirq context, and
+	 * pcp->lock is acquired with IRQs enabled on the allocation side.
+	 * A blocking lock here would create an ABBA deadlock potential.
+	 */
+	if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
+		free_one_page(zone, page, pfn, order, fpi_flags);
+		return;
 	}
 
 	if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
-- 
2.52.0


