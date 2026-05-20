Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13DBCD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395566B009F; Wed, 20 May 2026 11:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A206B00A0; Wed, 20 May 2026 11:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD406B00A2; Wed, 20 May 2026 11:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00B8A6B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:00:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0A0C1A0370
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:46 +0000 (UTC)
X-FDA: 84788110092.02.19D1C55
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FC084001C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:00:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hvoqZOeC;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1c9ByeJjCfG0gYJvGtiXQ9M/uTq5YaBvLV18O1MJ0UU=;
	b=h92elLFteQLAPhf0QE/q5y7n+UDCtKfncXSyaueM6Eo6g2HJYcfRJGha10UJS2SRdZVM0x
	ThIAsimUbx7acxkQXpjGx9iJiVDSKobifFS3Nu/069nt0tbdS2Nn/ArUWRNOR0bGiAiHlT
	r6HUrA1yCAwlVgV8i/YVsPwOfb5mGH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289245; a=rsa-sha256;
	cv=none;
	b=SeittjvT6eM325tqmQUbNz8ZuIu5rURbPns5OB1AJEMu5AUjdyELnGShTwSt09hYELpSxt
	DdIrGyUGe94pAwsNg4+WUtVbgKuTMfxei5V+v9C6cBkJlUnMwpJKpRna29xPXBC5oW2Jyn
	CD63D0UvI0AxKWXUME8q1lS/mZS0vQ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hvoqZOeC;
	spf=pass (imf12.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1c9ByeJjCfG0gYJvGtiXQ9M/uTq5YaBvLV18O1MJ0UU=; b=hvoqZOeCLBvtxCldkLZmtJCI3C
	vkbEdJDYrqh8kpeznCytOLOHIZOliqZlJyNZbgbxYe91iqQkd2biXISW8EiEczS2hLPuiRbopm408
	cEYPlcyvs/1U0hI+iKCAPqZhgvTI2uNjuy0kE3004UXGzZAYuVE0VmGf6aRFD1/lpfRuMIKng/FKK
	hWwPc1X3+5iC5BNoE4Xg9gPCUxhdvrMe+LiuifKYFS4pf+ePmN+Q85nGCEnQpzm3gZRtlRQ/FYzrF
	Nha6i8e55ePs8+CWc2bnIoi7AcPruD0KOBeJL4Xzi0zb2Ps7NOkw3x9qsIMrLvw5awqMD1QlOrJf5
	I0DCVcYg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-0T4O;
	Wed, 20 May 2026 11:00:28 -0400
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
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 04/40] mm: mm_init: fix zone assignment for pages in unavailable ranges
Date: Wed, 20 May 2026 10:59:10 -0400
Message-ID: <20260520150018.2491267-5-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FC084001C
X-Stat-Signature: xhjhdatmun77gcjopiekmafzy91qeoir
X-Rspam-User: 
X-HE-Tag: 1779289244-336127
X-HE-Meta: U2FsdGVkX18W0xe3bEMAwsKlfhBDUt71OIE1PWzQbcwmPe9dfd4SKYtFEZqQAfJpGC+qQ6+O9nlvALwG7RHz8zbNPWi/w8EgRT/Dm1FG+qRQA4a9ABJwn8PZITN7WlJMvqsvYx3xJVd2hV/d4SWemov+86/1Ta1yfNU7cqCkCTLck4NJeTa1aXEGDm1QvB2WHB0jfGGFIykCc3qTLC9Whu4MEDi+2GQFKUthKNAGadYRTt7uFB0Am0EufMyrMPL+6SfLtdRRjyY0go0xe7lR8sU0mfaeC2KiDe5UdkPzVmejaXHP+2931QVNXuv2mRM621rQuyQldx7Q2Hx3/yf+XH34DKYd8q+EKXkqQ7aNXeBdtFY18BJ3NXi+xN+qvzK3FaFV2GP0hGy2NMrurDvKC45zMha5pXb5NObpxI3CoQz6onzGUy7+Sapi3CjGW9G1PiemgWJcA+V2XYU7Q7uBNdGMoZII3hRi6pPUvBCCh22O4bH/GVUXZNB0NoLFN7kZ1CrDcaC7x4/J3/K0dc0Ldd9XPuT48sTcT9J/mS4eNPmutjIXvSvohoShf3ARfhBfoT38pgU5lcy37tmfx5TiWPwsVej/cqdRNdcqrsd0LLr7YgDYwUPsXZoIwP7NmnbFyigoYHXDsz2q8hFF6/WiB5t/e9TqSMq2FtT/4hCFqh68BdpadTimeoI+P7zYjTrO8w37qv3GuIjRBet9tGaWnfMuxH9xngi6EHzlzV/1BEWOgCwcEDzaCltAcUP/tN4U7/Gba0FkLtsq1e/PJ78zVgTqjePXi3YZhqLtvnzDit955EyN5K8+BGowgLlyMUouBf764TeXl8rJ3m2J7Sf9qMlPt1dlghK3MGofZ56o8iKcRsJIZGqVWs/tUBlDCrqcEhQNOBlBB+Wzt/NwF8Biz+L64LhyyPsIYYRaL+hgNJ1+p1bDKnvl05a6+X5nfvyNOZHnPhYvynYTsJArVZF
 F5x4j8nh
 pi1PcDNWorusdspm24R+MbA7fSm6mVa7iW3PVPR+oD6Z3RLa5JnQP9NWkT2Xqm7VxJtdO7M1ix3dILJWNso7bbWtIMVz/XsJBSK9Xy67Gc6342RNcw2La3xzAneLdR68Oh+cQqePmdNy3BGABZZyeCjdpgh5rOdZzRIhd2LCXm7NVYw09mcsiAPp6J74dQsKLXOIdfhGSDwHTlnE0MvXBqJyncJjNDbgpz50SongmDdUXZ4aOzkkb6GIYH/zOdHrHXHmNyo4NATVdBuIWWh2fkt3Zd9mDWnFDN2jE5K6ZP+XsxSP0y9IQSuBSnOEcSSIDLHf9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_unavailable_range() initializes struct pages for memory holes between
memblock regions.  It receives a zone ID from its caller, but that zone ID
is simply the last zone processed in memmap_init()'s iteration -- it does
not necessarily match the zone that actually spans each PFN in the hole.

When an unavailable range straddles a zone boundary (e.g. a hole between
DMA32 and Normal), all pages in the hole get tagged with the wrong zone in
page->flags.  Any later page_zone() call on such a page returns the wrong
zone, which can cause accounting confusion or crashes when code assumes the
returned zone is valid for that page.

Fix by looking up the correct zone for each PFN in the hole.  This is init-
only code running once at boot, so the per-page zone lookup has no
performance impact.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/mm_init.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1bc909da9c13..47a222e49fc9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -834,9 +834,27 @@ static void __init init_unavailable_range(unsigned long spfn,
 {
 	unsigned long pfn;
 	u64 pgcnt = 0;
+	pg_data_t *pgdat = NODE_DATA(node);
+	int zid = zone;
 
 	for_each_valid_pfn(pfn, spfn, epfn) {
-		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
+		/*
+		 * The caller's zone may not match the PFN when unavailable
+		 * ranges straddle zone boundaries.  Look up the correct zone
+		 * so page->flags encodes the right zone for page_zone().
+		 */
+		if (!zone_spans_pfn(&pgdat->node_zones[zid], pfn)) {
+			int z;
+
+			for (z = 0; z < MAX_NR_ZONES; z++) {
+				if (zone_spans_pfn(&pgdat->node_zones[z], pfn)) {
+					zid = z;
+					break;
+				}
+			}
+		}
+
+		__init_single_page(pfn_to_page(pfn), pfn, zid, node);
 		__SetPageReserved(pfn_to_page(pfn));
 		pgcnt++;
 	}
-- 
2.54.0


