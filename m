Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1DBCCD4F3E
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3FF6B0092; Wed, 13 May 2026 08:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C716B0095; Wed, 13 May 2026 08:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6036B0092; Wed, 13 May 2026 08:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 857E86B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BCE6140BCC
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:21 +0000 (UTC)
X-FDA: 84762342042.07.D359981
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7010CA0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:35:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Rn/MvbXn";
	spf=pass (imf25.hostedemail.com: domain of 3BXAEaggKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3BXAEaggKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778675719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jK8oWMUhgh8u2h0g/pQlZW0WDLVUtUJGpIoHocj5R7o=;
	b=Gz/vXL7UakTLLT/NgVaT+PSy8BOq49k5/pSQhquJaZgl9HVbWP1O5M5m+nlEFsj9Uu7h95
	K10NA3aCwp17Hir3vbFif0RqXFJsoi+g1iLrY+hZN4Sk4hJp6XgkfGpnV/R/MU/LpPdm+i
	rDzrnkMHuFRUai62VesVwXV+a5H8nrk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Rn/MvbXn";
	spf=pass (imf25.hostedemail.com: domain of 3BXAEaggKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3BXAEaggKCE4zqs02q3rw44w1u.s421y3AD-220Bqs0.47w@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778675719; a=rsa-sha256;
	cv=none;
	b=7fXCVeDYyOBmcWTJ2kqQzVDhkaX508ttIA9d4MWKmrQeG3POsEMFA7oTKYqby/BHBYW4HU
	fCTB2gzo/J72DEZmqfSsVFgqQlFKDwtViKFiiOXTN8asTGXpb2RRCn9R/k4mUyQZSFkJ5n
	lvrpvFC8oYqxI3AyrCJ/9OHBiS22CZQ=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43efc93e4f6so4428893f8f.3
        for <linux-mm@kvack.org>; Wed, 13 May 2026 05:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778675718; x=1779280518; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jK8oWMUhgh8u2h0g/pQlZW0WDLVUtUJGpIoHocj5R7o=;
        b=Rn/MvbXnJbgsD+BmS1oJlEdcEzSInuE0VUEQalXVxZFMXsVcMEbBW+aPSlc+3T0rAA
         z27qYJIxNF4KG1j3256TS/qLknIhrLoMT/uRX8S8zt8sQTEwAQ956T5LQPkrIAoC6OeU
         NaTfoEZhVixI2etXix6Ez7P0ME6IRdadJmUNHPtTQw7vplN4NYiJQP3jf+TL+kXJZ2a8
         3MCd3oWk0CT120NZkuuXFR/RCbPKJoCuSi7ikGw1/zevnaG7Jj/WuoE4rLlKfB7NWOQy
         VlI6v5meeT456GD5jqg8BYSZ4kBTcJTy+sT5lzydZmTANTxomT3zNVIgdNkVZRVjhQMx
         AKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778675718; x=1779280518;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jK8oWMUhgh8u2h0g/pQlZW0WDLVUtUJGpIoHocj5R7o=;
        b=MReonEIugjX47+73c7ZHTh5AxXGukYXnTXDhi3O/PQoDmCSsuzfwaqjjUIUk59wTmw
         pPsYgtIv1Sf/unfLK7tf/u9Q/mtv7o6olYYS79h7oCct0f6EbEW2d2rHXRzJoGwvR1nd
         FZgSmA3K9vJ9ZfhSzg2x4/8BPopQGFR1X03dStMwnQFmFpKnH+wUeweHgcLYCeQv75Tb
         cnggTsn40sCXc51Aqh4Ics9Q9zJ5GolFaj6gec8zGxK3qDDf7dmeJkQc5irXemiKvinS
         JgnLhrXmbdxPETInGZ394RQUQzJaYa0iNV/PY9jgyfUBM2E7NFklcQa7/Tu9MhO1DshJ
         p1Lw==
X-Gm-Message-State: AOJu0YwcNTXdRQh5ZZm7MQhvIhZaV8bEIVoozWhOUnwL00OGgR4O1lfz
	audWG620t/60DrURQvH9XB2ux4wNYgIRd1FD+i45w0XwhRA2odaaXjqAW9CKqGe3mvJUlngBdMa
	CAOmgYjNqWrWcUw==
X-Received: from wrbdf7.prod.google.com ([2002:a5d:5b87:0:b0:44b:16d7:6b87])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1acd:b0:44b:c220:f8ce with SMTP id ffacd0b85a97d-45c5762d633mr4903489f8f.6.1778675717362;
 Wed, 13 May 2026 05:35:17 -0700 (PDT)
Date: Wed, 13 May 2026 12:35:14 +0000
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
Mime-Version: 1.0
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20260513-page_alloc-unmapped-prep-v1-2-dacdf5402be8@google.com>
Subject: [PATCH 2/4] mm/page_alloc: don't overload migratetype in find_suitable_fallback()
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7010CA0004
X-Stat-Signature: rkmbnwccq3t1j8heh1zk1jfe9p1ptdpw
X-HE-Tag: 1778675719-508281
X-HE-Meta: U2FsdGVkX1+N+R5XTeso1u+kjdAcGbkDWa9ql6XjNmfLyFtxIdiQGQknJsENG/ZV4cSDZtja10SOlolyEnqhILtq2xJn2oxODU7eFcHVUaQzqnWX0rfaKLT50MQZ3R1quW6aQJOuNHw06RPm2HGowmsFxELb2Fg/4daI4qow4uTM5zqecUqf3FK6r5FDppsprqcoQcggav7DL7NQJY4IrI2SsOOusDD6Zib5zUlnyJZBFYtIw5SA0mRzvcC02LmcZHc3zHVER69zbenFNLIpJPOhXD1lwrciDu/dF7WVB4LiA0CsgPn8088/OczaAraPOX0rEnhUlVP4T5ensjaHY0lPGAVstMgDVi1cSr2wMi3HNp69H8uiSqgBhtzVm3jFMEzE0gKCESLeRQeaDeJ9ogP3mhYiBjBrGdqcp0ST/aK7YYN/zaRLFKJvkDjyhq1XUnJz+N2An43hCqPZYWexL9pkpkdOyt/qThCsUgvvv7+y17/xCWzjbNi0VzjmLejq8N/qeUIy0yeWpeRTstK1EhYuFK4JWDTARx8c9vKAlOuqjYS1bjdD521wFJPvTjdnnQlX+HawI+lUxIoVJliItEihkcco7ezi2GfIsLF8VTiu2VARASO4GW4yO/luJWSyFrF0CoqmjVVqI+TK/OmMxBtD0scN8e8hTfcsZfL14ghiL7ndCqOOYciel8tkF3/xKQgdhQH3i/poVnhH5HZZ59YBsuN2XyvSkeE0u2OL4G7wASbKkAaaLdP14MGBtEZeVRHs4qKbYJniRtovUmKrVUFO+TjTC8RrfnNqngYuqyOFA7/VMPKB2F2RZRHViAC+r5Jm3SzoqPR7IvSpWvYB+L+Prh80LFeKYhnHSEhHuOxEWAqSPiIKuvcgNTshJ/2UKduXK/HIAPxzeC/u7LutsMebbNcn8EXWzUY0si4YVgNdeezJ5rzBSjMWV9iHx/1n9jWKFk5vj3oN+RmxaZb
 sWfDRyZR
 HmAgEwQojPzQNUN8/vzHkPP0o4t8Ct/s+07PivcNXI/9ZCA5sazAeozym+v6R8qtIW4kblwvf53OpwZvFw9uwJD8/xD9zUhi4slX9dM6mVi0iBplWyddooR+n2n7jRJUAILc0rD0ljZuqp4acrQwLfGzhai9sVS1FBNXgG2coDYz2h3TNFTLKzZlCT85p8mygKgz4m/RlrAbs2qioaXuSuyrSQlkQ5o+s96XB5WnmUB2Wc/yYl7cHyy1pH6gbPbqyqg3B19FXzObCuqzVjVO9dlS3dA2K1Z4pKuheaccnPI/ip35KF1g7u8I1MEWzjZWILaDEbXxJptBfuMzFyxaSzsJcYmUmONqkfHoW3TntsR/XgULWXTd22H1NO+iOT0Q5kCqQZ3W52IHF8Lrryy+qTwya62KKNcqUeI12If6uuxzbwW/B3c2WkG7bEbJ4NDTRPsiuahYTQpgNFhY8f/eyCBa98Ri3rkMN7nhpTFBHF67h3LiCWZoFUQfwtdYHMVyccphcFiOyF5AGyr7fsZ8THIhSgKyD3AIEDqMds4kCUPsC8Nv4CZf0eAdid2iXrN6B6S3/AJG8IlkrCUExyMMPEe8nqMukRJ2eIV6MDjmExY+vxwUF5gCN3Jiu13ec0BWdQQrV367OZiAq8scP8pWkgnKv2JnOZXueyfrSPQWZ4Nluqc9wSKfD2YQ0YnHdKnsc1l94NXC+6ieOByHGxSvlRwhHJ3hZEyYj2H/6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function currently returns a signed integer that encodes status
in-band, as negative numbers, along with a migratetype. Switch to a more
explicit/verbose style that encodes the status and migratetype
separately.

In the spirit of making things more explicit, also create an enum to
avoid using magic integer literals with special meanings. This enables
documenting the values at their definition instead of in one of the
callers.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/compaction.c |  3 ++-
 mm/internal.h   | 14 +++++++++++---
 mm/page_alloc.c | 40 +++++++++++++++++++++++-----------------
 3 files changed, 36 insertions(+), 21 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3648ce22c80728b894cffce502d8caa3e4532406..168e63940b78247e08aef8b177a4c68adb36db31 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2340,7 +2340,8 @@ static enum compact_result __compact_finished(struct compact_control *cc)
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
index 5a2ddcf68e0b6d1a9fbaeae07670dd252729f96a..09931b1e535f3f71887b5b6473f93ed21a41c7e7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1104,9 +1104,17 @@ static inline void init_cma_pageblock(struct page *page)
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
+		       int migratetype, bool claimable, int *mt_out);
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c9edffe968ac25b8cd9f6f983bf4c9ba21e73a11..91d83c967bd478982e0161a99d47d3a76bd89992 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2249,25 +2249,29 @@ static bool should_try_claim_block(unsigned int order, int start_mt)
  * we would do this whole-block claiming. This would help to reduce
  * fragmentation due to mixed migratetype pages in one pageblock.
  */
-int find_suitable_fallback(struct free_area *area, unsigned int order,
-			   int migratetype, bool claimable)
+enum fallback_result
+find_suitable_fallback(struct free_area *area, unsigned int order,
+		       int migratetype, bool claimable, int *mt_out)
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
@@ -2377,16 +2381,16 @@ __rmqueue_claim(struct zone *zone, int order, int start_migratetype,
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
@@ -2416,10 +2420,12 @@ __rmqueue_steal(struct zone *zone, int order, int start_migratetype)
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


