Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E2AD1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E831A6B00CE; Fri, 20 Mar 2026 14:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E341C6B00CF; Fri, 20 Mar 2026 14:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D252E6B00D2; Fri, 20 Mar 2026 14:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B761E6B00CE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81D4B1B747B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:54 +0000 (UTC)
X-FDA: 84567265188.26.A5EADA0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADC871A0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hPldwufR;
	spf=pass (imf19.hostedemail.com: domain of 3t5C9aQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3t5C9aQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9aSRnDL3pRDJil+a68nW+puWSy5HdAwOwwJrBBZtDNI=;
	b=SYtRMZVR0/OJXmtgqBwTzZkcdkYzacG9XIKjiphaJVFwL/8x1Zj5jT7wvK/2yzio8etFik
	YdkY56m1/LgySh0l6VMOrObbBsDIHnk+SgulcwdWR4OqkRXxpPSb+45Z59lEqBLeYWVk5c
	N/8zQju4t5FpBxM7TI4s81M9xoJVmdw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031032; a=rsa-sha256;
	cv=none;
	b=i0uPVvm8B/QQEvStTy4pisAQpmQRyhGF5LGkNgodH+8kW7oHlVicLnXtPvVAebYSHXZq+5
	vUrEMUk5vj5ebHAAJdJ/IvzJSjiE+oqBSYzSba/8wKxpkkz2Ls0VhOsgMe20Uz125+1tIq
	8S6Snmk3B8+82aL2VBFCblsBOVwksK8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hPldwufR;
	spf=pass (imf19.hostedemail.com: domain of 3t5C9aQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3t5C9aQgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48532df52c5so25754545e9.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031031; x=1774635831; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9aSRnDL3pRDJil+a68nW+puWSy5HdAwOwwJrBBZtDNI=;
        b=hPldwufRoPnrnmBwqxtE6pXYu/oJ24Wn7vLkY09qZxC1Z8mGHOMeRTM6qjUjuepBOK
         VTt+3YfLhEQtmzT9HUJeBkkeW+VnybGBWKteVElzoE5oxTo0oe3/SHTemtCEUcGbscY5
         ENSC75LSrOpvsanblsZgKhndoW5tAld5tDQ6TdAq0NypegeGPYnmrGo1i7t4YUVKIxRD
         6aCr5xTxoJC8/cz3xplj+MCHMtmhq5Tnp+d1GnaVSGmvDTH/lCYcJhBQGkSTRmUNd2X+
         oIotBsBhpBuJnrcYvTvm9TqFQhQrd6XQb3jeaP/MQpDPlmWgk/I3K9zUGrvbk0OS+qWa
         9YGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031031; x=1774635831;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9aSRnDL3pRDJil+a68nW+puWSy5HdAwOwwJrBBZtDNI=;
        b=oxM6dnPImHvAMXQtbESJtU9VekDzORpb668+JJrOKg4e1RH14GytoI0JtMzCEKW3jZ
         VpWi9icQkyKCcpVzS6FFH3lZxffeizU3kjiOJDhtI5dRaSsKa2OpA+37iA10D6PckXQZ
         AaPJV7fFobqIo4n2iIa/i5h5gw0MeEkhJ8bV+gHK7ooRYIy0HajE+pWwMqa1JP99HnY6
         iwrMmY/i5wGe3xSj+D1uxjV1wyszPAzIzWvbZeNebcBZWbVQpQ7yuuyVhFyfHUaHZZl2
         whAv3Go4SrGw4sH8rtgFO0uCKl36jJkhNvzypVkbNkcUagUq/O0Cd+YT+3Xp4Il6jQCk
         wt4A==
X-Gm-Message-State: AOJu0YzQWE7MC/9NZC8aGLRrb0H14Euw8VMoPmrSFL4OYFLqIAmUUtLk
	a49IJou3HXkNAPE4pxz5on/C7j/fmhnE6DqE4nyRy/GdFuiENT7SIP3hpKUuD2ioAdPFmSwInzL
	VKznc3XwENjDxtA==
X-Received: from wmjv1.prod.google.com ([2002:a7b:cb41:0:b0:485:37cb:adc1])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a43:b0:485:40ed:2d1 with SMTP id 5b1f17b1804b1-486fee0fa3dmr57810255e9.17.1774031031171;
 Fri, 20 Mar 2026 11:23:51 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:33 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-9-28bf1bd54f41@google.com>
Subject: [PATCH v2 09/22] mm/page_alloc: don't overload migratetype in find_suitable_fallback()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADC871A0010
X-Stat-Signature: 15zobhbwwpu7abn1pey38beyngefadqu
X-HE-Tag: 1774031032-345146
X-HE-Meta: U2FsdGVkX196dVNLUYeb5ZJAktxpnrru7m4+PnYB/6xO4QKojW7m5EVx0XhIkVv87J7w31OiHhGdRgrJdpS8KQOTezLmHc8PV7eU6FIFvZTBc1wpEm4598q9bw7pKshDSgyvVUmKXv7LlY8aSumtZdrPIQbwh6qBZGOZc+0mhmug1b5Qi2I7IiLtY5SuXTK3tp3CgtcV7f5zmwvOBXHQITfo91M25eHDhWmIRv3fwYz5s03t9nVMMHlzcQ9OAXftQTybbhs9RsmVJdcbHPoUaYqsp/hqFQDLwPdXLRtTq0ABq0aS/fAi/X49QDILs1QOtXiyJxopz8EemshKmHlPtToLHEBePUid3TkStGaJvKLBlcPQXhFbzX1MxxWgzKGkvufKjvcyaZbmQpMdYJia25obNzTwcbSqGpMYoHPYP3qpBwjpmHpG04q1Q3k0w6DwwTVyJS688wjV1YKmZO20pfM+IC71qKWsX+8ELko121hb3myUgLhPVgeZtiMIQ/KcRAzsszsq6fnb8LVJnxoqmmuEBekY2PyzH7+ELzofIVBe68NcZkEuOVx+Gqpyc9NGO2ML+f13DR49/yL+JFbMDD0EQhYbjKBLvEyMKPUP9uzDlAdR27wwAHxdDnXuPEagECuxaZTiIS99xNowS/50hW+r8hPHOE8DSQVpMyxbkTxCmRjXRZD1QLMJmmYOSHG+JBBJ+UvgDmb/qD4PxoXRK9GEFK8vXi9Fi8ojqcMCbG81YOY7T5BCOl5RZH8Ex19+iq+dKFr7km826YFy5G+F/h0snAzxfOBEb8AlPPDJWwvRp6PzPn20+XDAnaX4um2zmHBXoqXbf5djbfO9zKkzwysRcv4FUTQVqpEb7lnM41Ttt1QzBcctpuzR+ATbokwI7pNC+1g1yPsQUtmcBgwexZodvMiKAl+TgJKZX9gtnKn2tY99f9cSRsdChg5Vg5jqnC0RGeReYv3If5nylId
 RjnM41dg
 mYVlLx8PZ3VT9KVIkkxGZeK+LRdMCt7+RBcJEWvqTVaGN2xWIz4FQrWQEzJajP16/89p6+w+yK9TUx5w5m8DmWXaNx8cj6TrZ8XssHe4m8Kk+DuLDFA8P4cFW0YSZ7lxh+5cbjEatt6/GOdXzIn6AD8Ou4wtjU+/pbuN1O4sbjBy0cl+XPHEgBkqCCUBx/twpfkgQsIL4vrD227x957GniEZMEWhVwQewUzm2cuiZdD9z0U4qrzfecSuN6jYMyHzQ44RfxvvnqVpRmTgPcWibRhEWKvhdE0VDj0PMgKhICoy3gaudpwUDbM+/XDdFSSgnQ8vAvSwXeTpnIPPoLsp8141wTrhkleUVAFEosRjq95KkwYpoX/U5Rd93r2cxVL6nRZsbtH5LS5OnufLo9nhSdXp9cmoQyWHcsK4aDjpGEUUrrHKXG2XHCmM2OOrWM7oMVCzaVEnS8gqLC4VhwbdipdR+ThoQA6RVwjbsDjZksBaBHSkOTgVUdoWH0dNj1MG0S4/FgZ4Vi6rh3MmmhlPesOFQtPSpPM6bUZ2WohtXqZnwoFOn4fpgSb2sozNkOjWiWiOmOkauwCS6uoLGCakz3hRkqm3axqME5NsMljgktZhjhFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function currently returns a signed integer that encodes status
in-band, as negative numbers, along with a migratetype.

This function is about to be updated to a mode where this in-band
signaling no longer makes sense. Therefore, switch to a more
explicit/verbose style that encodes the status and migratetype
separately.

In the spirit of making things more explicit, also create an enum to
avoid using magic integer literals with special meanings. This enables
documenting the values at their definition instead of in one of the
callers.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/compaction.c |  3 ++-
 mm/internal.h   | 14 +++++++++++---
 mm/page_alloc.c | 40 +++++++++++++++++++++++-----------------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 32623894a6327..25371a75471dd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2358,7 +2358,8 @@ static enum compact_result __compact_finished(struct compact_control *cc)
 		 * Job done if allocation would steal freepages from
 		 * other migratetype buddy lists.
 		 */
-		if (find_suitable_fallback(area, order, migratetype, true) >= 0)
+		if (find_suitable_fallback(area, order, migratetype, true, NULL)
+		    == FALLBACK_FOUND)
 			/*
 			 * Movable pages are OK in any pageblock. If we are
 			 * stealing for a non-movable allocation, make sure
diff --git a/mm/internal.h b/mm/internal.h
index f4c59534670e4..e3782721a588b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1059,9 +1059,17 @@ static inline void init_cma_pageblock(struct page *page)
 }
 #endif
 
-
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable);
+enum fallback_result {
+	/* Found suitable migratetype, *mt_out is valid. */
+	FALLBACK_FOUND,
+	/* No fallback found in requested order. */
+	FALLBACK_EMPTY,
+	/* Passed @claimable, but claiming whole block is a bad idea. */
+	FALLBACK_NOCLAIM,
+};
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, unsigned int *mt_out);
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0a1dc7866068f..ac077d98019f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2248,25 +2248,29 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable)
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, unsigned int *mt_out)
 {
 	int i;
 
 	if (claimable && !should_try_claim_block(order, migratetype))
-		return -2;
+		return FALLBACK_NOCLAIM;
 
 	if (area->nr_free == 0)
-		return -1;
+		return FALLBACK_EMPTY;
 
 	for (i = 0; i < MIGRATE_PCPTYPES - 1 ; i++) {
 		int fallback_mt = fallbacks[migratetype][i];
 
-		if (!free_area_empty(area, fallback_mt))
-			return fallback_mt;
+		if (!free_area_empty(area, fallback_mt)) {
+			if (mt_out)
+				*mt_out = fallback_mt;
+			return FALLBACK_FOUND;
+		}
 	}
 
-	return -1;
+	return FALLBACK_EMPTY;
 }
 
 /*
@@ -2376,16 +2380,16 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
 	 */
 	for (current_order = MAX_PAGE_ORDER; current_order >= min_order;
 				--current_order) {
-		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, true);
+		enum fallback_result result;
 
-		/* No block in that order */
-		if (fallback_mt == -1)
+		area = &(zone->free_area[current_order]);
+		result = find_suitable_fallback(area, current_order,
+						start_migratetype, true, &fallback_mt);
+
+		if (result == FALLBACK_EMPTY)
 			continue;
 
-		/* Advanced into orders too low to claim, abort */
-		if (fallback_mt == -2)
+		if (result == FALLBACK_NOCLAIM)
 			break;
 
 		page = get_page_from_free_area(area, fallback_mt);
@@ -2415,10 +2419,12 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
 	int fallback_mt;
 
 	for (current_order = order; current_order < NR_PAGE_ORDERS; current_order++) {
+		enum fallback_result result;
+
 		area = &(zone->free_area[current_order]);
-		fallback_mt = find_suitable_fallback(area, current_order,
-						     start_migratetype, false);
-		if (fallback_mt == -1)
+		result = find_suitable_fallback(area, current_order, start_migratetype,
+						false, &fallback_mt);
+		if (result == FALLBACK_EMPTY)
 			continue;
 
 		page = get_page_from_free_area(area, fallback_mt);

-- 
2.51.2


