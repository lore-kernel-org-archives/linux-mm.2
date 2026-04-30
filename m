Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36609CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023196B00A8; Thu, 30 Apr 2026 16:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16886B00AB; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1B696B00AA; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ABC3E6B00AC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AD241A01BC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:06 +0000 (UTC)
X-FDA: 84716346372.26.9B5E310
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id E554F140002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LR1ytMFQ;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580584; a=rsa-sha256;
	cv=none;
	b=RMADkO+ZzMKRxxRA2TFSV1guP9123JJD9lKjXTdCY6gTgUvtZ7NoZsqNXR4hdEdbX3vg0u
	2nmreyRTY6Q5FIHvkkO1Ps3yrOjwXqQL8uWC1q2ICE+6c/0nr17F8vMRv9JL33nMAOXHCW
	vDbyF5cLgfOSzfG/7dEftSfj1j1ze0g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LR1ytMFQ;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NuFX7HMe61DX0R5+yhLwHu0GA171H/phSLKgu4HycPA=;
	b=OqLa/73NREq93xPwS2rCwQ8zSwMQ1p1zJPeE4x/gmwdcv+eTGX1h4wGxlHA3G+iJaHEtRD
	UToeYn/Fznvk8ehrEedtk+SZB0ry8Ql2oiKmTher3xdu6X474sWRIf3zbOr8HHuVtlqLqO
	8nzwiatCBOhi0CtAVdANF6SBJdP9Cic=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NuFX7HMe61DX0R5+yhLwHu0GA171H/phSLKgu4HycPA=; b=LR1ytMFQ/Tn3hp1V+kyzCC8Dpw
	nYcVzEGfF+4dRAnSI42hjsEx0li4luxUgFBpeJ+F+yGCZdjrCE77CFMPJzS0b4zlk/JSuwZveO9e1
	brKZlcjL36JzPCBeEEPV9rta/nNwOX8M/jKs1jrJypCRxkb+TeJCmuoX4LUoEes+85VOby9tKOMRb
	z8LYHpRRDE8lE4aox+zC2OlmQlNkNn2aFuK62HnrKuwMRADh5FtbAu/Q/wE3sPXgR1/mZa2E/LORX
	nH7khGFjpx/o+em6bIVcv3euJupr7N5LEChQZJHrBSriJjyX/gW1zcMNxXIrmA+L2LoHXrqz3/+Y0
	WO51Bfsg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1Wa5;
	Thu, 30 Apr 2026 16:22:41 -0400
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
Subject: [RFC PATCH 36/45] mm: page_alloc: add alloc_flags parameter to __rmqueue_smallest
Date: Thu, 30 Apr 2026 16:21:05 -0400
Message-ID: <20260430202233.111010-37-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pikz8o55hd6f6z8y79i4ox5dbbcihd3w
X-Rspam-User: 
X-Rspamd-Queue-Id: E554F140002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777580584-980433
X-HE-Meta: U2FsdGVkX1/5HbYjbQNmZimq98C2ZLDVP5X5iQcH/CURsBgvswFdVYjCOP9fXVIixMCS/kzjFNIgXWxIOUY/jF8BGSNW8VUGD5azqxkYAySSRgQCsiijy3rLedTLKs2CGrKVBAmTIg2VHkMHEoTlE3/QNxGkTI7YmnhCpw2RylQ1ECtcACwnLVTnXm9pR1FYLCAeDTWU6aHOIe3hA/NqDwoW6/HC0ALN1EhGzXMr1krbP/WM1WrE+diDM+a7EyF3iVZevxzwXOQont/YKrONsDBvCRQwHXQ2Ke96O1T9DPBcHVtwl8GwbuxotCU8gTXvvi8sXy4pGu/nCCs3lDmJjvJ5cfU6u2VN5ePX6EwvlXdERKGkvP5xhHNo5T1y6aipQXLRMqWLxS02ak+jR/mGuF/Dy59wHVBQ2OOhM1vDqHbIXxBXRPFJpFQIGsqSKmMX/kMo4QKgEkuL9wcKU6UEnpoJOuRbhmK1/j/2nNiwpE4Cs4zELuwB6/r7TX5tsq8OcYnlnWkg4jlT0z1M0rFB74fPSho+B7Q1GdWiXJenMvliil8Qt2UDSzQJyJxCPpddRSVc3zx8DLKJVb/2S8ZU5nk0WEeEhdDltQC+WrWAzsAXsUqJzLtLLEMHW9RFs4+I4PMCdgqEW+pxgm6HVtnxgl2F7OQLNIW9kzqVr0cxZCFPAxoZHJ1sSemv203U2r9cCi6l59ZHe8JO01nB7Ak5Y6Y55qbNOweSOmZn/otcEtK0dX/jVrMak+i1ALcL/8cOfgBgjx9G8sa4xjd5f1UrQTgyqxuvHYHEY6fomCkEHtxBJpX6RegEnI/SI7C+nsiwS/dEoaMQ6QzT5PSHy8raWLp6Q1TBdmpQZVNX2kSN/QsByTblTmgRVTCcngYZ1OdRXB/keeRcB+ZOza8RBdskryQqgbXII/o6oSAP4pEwM6s35hKcP1z7rHJGNfHShNiZzRR/hvSp/f5VwGLyWao
 fyxelJ7W
 dX8dopEHFTYYrnh4VoI2GYurhnwWi57CeXTeK4cYFubN+RBfwc7L2p6z2Ac9HSaymZ/2cEEu6TI6THRuve4CRrfJhVSG2liUsxCo13k/2z+tMLDPpi5VfjUp9QwqIDEzexo9KgDbuVakMYbH8Jv54ulnpdgH2NzhKp3A1j9c6mGE3zMzGJgFRw35xY7ymEQjuzHWQrYnw3p/Es+ZAHAhHzA36I41ajb3q/rwVBsoSrLwg1K8Afdx2m7BvwGI21nLyaJgUpdI5wYLD6WM9GT3zR4bPcwaOv3pfALWO4TS4eo3FjzrditKQfZLO4BFoJ7AnLsrKssG7q7I82WWYuNGA+DlsE0IWnsMw58vH0YfWyfrzwg3bbZNYB1Xw5LCYv/jxeXIm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

Plumb alloc_flags through __rmqueue_smallest so that subsequent
diagnostic tracepoints (and any future logic that needs to react to
allocation flags) can observe and use it. No behavioural change: the
parameter is added to the signature and threaded through every caller,
but nothing inside __rmqueue_smallest acts on it yet.

Callers passing 0 for alloc_flags are paths that synthesise an
allocation outside of the normal alloc_flags-tracking flow
(__rmqueue_cma_fallback, the fallback in try_to_claim_block).

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/page_alloc.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8d6d5b47f63..d621e84bf664 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2816,7 +2816,8 @@ struct spb_tainted_walk {
 
 static __always_inline
 struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
-				int migratetype, struct spb_tainted_walk *walk)
+				int migratetype, unsigned int alloc_flags,
+				struct spb_tainted_walk *walk)
 {
 	unsigned int current_order;
 	struct free_area *area;
@@ -3240,7 +3241,7 @@ static inline bool noncompatible_cross_type(int start_type, int fallback_type)
 static __always_inline struct page *__rmqueue_cma_fallback(struct zone *zone,
 					unsigned int order)
 {
-	return __rmqueue_smallest(zone, order, MIGRATE_CMA, NULL);
+	return __rmqueue_smallest(zone, order, MIGRATE_CMA, 0, NULL);
 }
 #else
 static inline struct page *__rmqueue_cma_fallback(struct zone *zone,
@@ -3715,7 +3716,7 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (sb)
 		spb_update_list(sb);
 #endif
-	return __rmqueue_smallest(zone, order, start_type, NULL);
+	return __rmqueue_smallest(zone, order, start_type, 0, NULL);
 }
 
 /*
@@ -4116,7 +4117,8 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 	 */
 	switch (*mode) {
 	case RMQUEUE_NORMAL:
-		page = __rmqueue_smallest(zone, order, migratetype, walkp);
+		page = __rmqueue_smallest(zone, order, migratetype,
+					  alloc_flags, walkp);
 		if (page)
 			return page;
 		/*
@@ -5171,7 +5173,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		}
 		if (alloc_flags & ALLOC_HIGHATOMIC)
 			page = __rmqueue_smallest(zone, order,
-						  MIGRATE_HIGHATOMIC, NULL);
+						  MIGRATE_HIGHATOMIC,
+						  alloc_flags, NULL);
 		if (!page) {
 			enum rmqueue_mode rmqm = RMQUEUE_NORMAL;
 
@@ -5186,7 +5189,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
 				page = __rmqueue_smallest(zone, order,
 							  MIGRATE_HIGHATOMIC,
-							  NULL);
+							  alloc_flags, NULL);
 
 			if (!page) {
 				spin_unlock_irqrestore(&zone->lock, flags);
-- 
2.52.0


