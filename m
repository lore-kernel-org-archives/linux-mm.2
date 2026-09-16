Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2AEC982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00AEA6B008C; Wed, 16 Sep 2026 18:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23AB6B0092; Wed, 16 Sep 2026 18:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39A46B0093; Wed, 16 Sep 2026 18:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBADA6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:48:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52C6DA01B7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:34 +0000 (UTC)
X-FDA: 85221116148.18.68FFAA7
Received: from mail-oi2-f13.google.com (mail-oi2-f13.google.com [74.125.231.205])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83EE0C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:48:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eb+cjHL5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789598912;
	b=tXrWZE/bqbxnRXob653jYsgXySb3fzkFk6UHiqa7M3QT5Ec51DIuBZUQAYjiCzD2kcpWDr
	x+RD9x0vy1A40kcEgNvK+xOgV5/Zzn5WL+Is0QXIaUSOT1LPF/gPBET8wtXd9NyRIamU6F
	w7kwp2yY92T/MQC0bjOHNjZ4EvDmJYo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eb+cjHL5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789598912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O//kPRqm92umksxbPoaUg/VRllgTguXLWE1QLEZxLq0=;
	b=TqCGRvf4npt29Qe9y/IzGhNQgpAsZ9ne82NaGkofQiWmlLyVQtw6PUkorjS0UEKCMLNewE
	Wxr4JN4ejA/beb5ac3IJzd0t/+MZL+3ooz+gzN0HI9Nv55+CIGAqzO3hvRUb3Zga8nyk4i
	vENZt00vilFOBUJfk3h5Xx+Hbdb8vDU=
Received: by mail-oi2-f13.google.com with SMTP id 5614622812f47-4b37a39a42dso86055b6e.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789598911; x=1790203711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O//kPRqm92umksxbPoaUg/VRllgTguXLWE1QLEZxLq0=;
        b=eb+cjHL5R0LSluwlKFpbvURMEL0AhJ4BLREiJ/5cFTtoAmtiRVMzaNa9n1nqtL5gZw
         mNzbhzg2kKib0MxykkBqWjw9yT1LRCdV/dra9TwbJAPHq0uSqwsw4//b7T7h+MKlAtvi
         rmhcogX3mhxSrlwFGpUeetawqTbiZiVBhdpX3u6xYHrfhJsl8G1xE7tJiIRWJpMnwjJ9
         l3BYQEPGSX/cjtlF2cwWi1iM2dCqF5ODSfqgBI8HITPiRcDEpNLxcs7nyed+6XEGruHB
         R7GYI11JjJGcFBzuF7IVS+U9fknLtZHIozexnWfe8MwucXFdxxWmR1/rbwPKEofAuhA3
         y5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789598911; x=1790203711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O//kPRqm92umksxbPoaUg/VRllgTguXLWE1QLEZxLq0=;
        b=0P0A7KQAQwV4oQInKkTeD9ZXWktKOdFn2LAC/+jhbz4fogL/mwQrZ5aphf2+SvTN91
         lqEDdTDgV4EcchB6MySXlxFXNvAw8VgPJxEW4ZZhUSEYjgavkaOdaU/RZpDek0m7V8du
         qZLD7ha2NaOwQzxFkzJvsGScnN3jQzFC+b+b6ibF35Fzo2yvaDyvQbd4aaxY1KzrtSXd
         2Iqnt5SdtfDuuL32+GCIP5pGqBmSLW+KfUPWkdoUoieF/53I3RCahKupm7apwPjozEEx
         dhjVw9xmOieQDPxkSMonQ3J8egmxcMJwkMIPAKLeMKAEKqssRKCwC3/EhmfMPisnqm/s
         x9Xw==
X-Forwarded-Encrypted: i=1; AKwUvBziEZyt3LXWrTQN/+C6rrRLW5/WeHxiTULJOjev355dL3Hg9jFtcu9swrJeYvI3snbn6dLB3fqx4Q==@kvack.org
X-Gm-Message-State: AFuF++nxn+00iOb6pV5gWjwYM7pDIJWyGvboKpvY6aJNsXDEIuQVhdyo
	zvEiJko9u09pjt8uPLYcnaHeEzUD7QZzzUBW9NORpHuC90Y+9UA3nqp9
X-Gm-Gg: AYBFou275q1Xusz95CC9xL+pk/DklF8W5CnjfZcIOUZ2vHV3stehalrgp/F4fZMw+8D
	CEFGi/vcwJhwTeTKZ/y6FL5kAVynOlYWzL1cK0hI1kfxXKkFjR8AjcO//tOT1DiWrMn5lA4gvam
	GE5oXUHEevsVRwamEVZF3c5Lq+TPfs8lLSHNE2IOZ8HfRE8abYVu4Hkw7tEX3Ft6VqPThno0xhO
	joCivpwWCXMEFok9qz0KwLrqmIeinxgYS65WKHA+Nl9cPzoTLCsebX1p2PMlx9fCgyYDondlTXv
	O4NSdj2WyqvIkX0Xl6FPO9exYV5eM8zu2FRUbJyoeV/wxCB7P6NgzJXPJqBa9muh+lUO1N4r3Vd
	eZJ6pkaX6XUqHzGM6D3Xse1GsI20m6bQPTh+WIuA6XxH3rAspRdkDHWUHb4cY0sHWjQJzyYGUFS
	h8Y2q4WWs5v2SWF4eXb7fgvAj6p5DuZdhujlBKwgcw7yR7Dp6ALXFMqd2XBN/Pt0U77NMbH35+h
	T0Sxpa4oirb9iDtLY/ORUd3d7/dD1RSYk224Ie5KMI3I5XuMKw=
X-Received: by 2002:a05:6808:5027:b0:4b3:3e1:499b with SMTP id 5614622812f47-4cb6958bf2emr1048250b6e.6.1789598911506;
        Wed, 16 Sep 2026 15:48:31 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:59::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4cb6a3d9bf9sm1117762b6e.1.2026.09.16.15.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 15:48:29 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/3] mm/huge_memory: make thp_underused() work for mTHP folios
Date: Wed, 16 Sep 2026 15:44:35 -0700
Message-ID: <20260916224437.1164512-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916224437.1164512-1-joannelkoong@gmail.com>
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83EE0C0005
X-Stat-Signature: yrkhu6kz9upj8qtpkubaghfqoj45kacy
X-HE-Tag: 1789598912-90138
X-HE-Meta: U2FsdGVkX1/0lQxToUKBtwKx6+KcfLi/QZ0FL/KNZg2BuhtnnzoasWF+EeX23gZnm+rDwqQoR0jHjMX1oTC1j39KKE58Z3Y7S384CxA4kAgVuVroIBeXL2AwShkfy1DdCmF+++vk/ysUVXKC48WkXbOQ/mHQVFSJRvO8UmBkieRlrpR3CK5glaP/+UG0adNqizOuJgLyCiTOkj/DXmOtSGHTZleGb2TXjiCBbU1HO1+Y/cASLX76ufXiyWnVApZmi1QKKjrlpMy4YSVzRCY2dmijqG+T/kFwqNcIL+WN97rdxNVfaUppUkkN49CYpqcwk/UoEO7R8MWxXEWVStaI47tU8AGQU91G977lJAV4axKTHT5XaA2SK7x3LjX0D+6boulCeeNRpZJIzUvb9dZlubSCY87KLmO8ltQe1dlpRrL89Jz57C/IcaI0FkYOPZsu3Hn1A/uSVIuWrDAlqw+BvRRj0kQAUtOY5PdZUXzdat2SB5Ep80lXKJbiuVMup0q38zuVUfSIgmHgq46I+0X+vtmYpFMf5JCUyRMUJNjVlhpcjsKYHbxlf9JQ479RwcKAmn+6tMRegIt/qTG5M/QrkSs7O6qGKkfGaVZ9eZ2YVIBHqjvVKfanHe45sHUR0no34MRj8RWLatTD4tBDKi3Yv1uK6aLYBWDJY0Y1zqbfXRmfBpN+MbTUYcImduoFrElOK8ICVzEP9iNaEQb1SRODAb/tdZhCU0mREkcroHmjJ9Bd2P2XkSr7YYwV5jND4hs+Bj/J+4lLzh2yaEU8jz/cjG/czaCvvg0uID8vZ5bd//5vCt0xZd2OFv5eGTS+Gc48DEWSPTEW8tFQXguqwe67NTIDqHKCkZHBdAA3LcB4rbgy3C2yLIzAmqTXdBB8C0lXAV4oKBDB9v3DuHlRGCk37CpGySKvU/NauBM5kmVi0W2FXcsjAPc0pyKDws0vj/UNZAv22EamdQjoM4Hf39U
 8FXekZK4
 h7uxFGOGL7A7nRYkF0qLm+T6R2zF8CwZ8N+bfivaXFXq9h0Drm1O8GNMxrhgzZTLGExqJ2xO+2LKPp2nxPIaLg+vUQsPzPCHYhdkqkc1IYB3JTrXOLS4NKgJX1/xmJixPcszUhnmF/Ak42uYbmuxSAR4O+Fo9EKyRrwwIgYlpkimIiMVySYaNco7aUz+y/rtoIC0LCR64STiT6DSENf5D69DH+qBvJ8StfGAIRF+UWAdp2wlbvxUy2SzyFot/M5X4WzKaudlbFWkH0PQ5GdkFzcW3doA/8S/hZl7tvTKWdcyVF2uH2uX2WkqugkoJZDRGhpqXoKYHi/iIRhyjukCNkBvGWri/zKvE/XNLQbJKJPJCeVkkhWZpksfrVEY5brvtoL2sNbcRVI/5BZEMb9gr2cza/Nl7N5ptqbdvbIZ4byop06dV/C64+APQ/CdhLuyhRTNRhduYF5k7fs6XygezurIE83J+xMnP6HHb4tnoR2Rw2Mtjwpz97AeJZ7XprjeNUhSbgqlhTMmAZuWW0O70KZfbUSfQCXaiDtvJIcmQZLB2TnpDq9IQxFp7CFUiI1L7h/uG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_underused() decides whether a large folio on the deferred split list
is underused and should be split so that its zero-filled subpages can be
reclaimed.

Today it only ever checks if the folio is underused on PMD-sized folios.
As such, thp_underused() assumes throughout that the folio has
HPAGE_PMD_NR pages. A later patch will be queueing anonymous mTHP folios
on the deferred split list as well, at which point this assumption will
not be correct anymore.

Generalize thp_underused() to be folio-size-aware instead of hardcoded
to PMD-sized folios. The check for whether a folio can ever be underused
is moved into its own function, thp_can_be_underused(), as this will get
reused in the next patch when determining if the folio should get added
to the deferred split queue.

khugepaged_max_ptes_none keeps its meaning as an absolute number of
pages, which is also how khugepaged applies it when collapsing to PMD
order. It is deliberately not scaled down per folio order (collapse
rejected proportional scaling of intermediate values because it either
lets the memory footprint creep or ends up confusing to reason about).
Read as an absolute count, this knob gains a useful second meaning for
mTHP as being the smallest folio size that takes part in underused
splitting at all.

There is no functional change, as for a PMD-sized folio nr_pages is
HPAGE_PMD_NR.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a..c6ca2a541128 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4541,6 +4541,23 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	return unqueued;	/* useful for debug warnings */
 }
 
+static bool thp_can_be_underused(unsigned long nr_pages,
+				 unsigned long max_ptes_none)
+{
+	/*
+	 * The sysctl maximum means the user tolerates any number of zero-filled
+	 * pages, so nothing is ever underused.
+	 */
+	if (max_ptes_none == HPAGE_PMD_NR - 1)
+		return false;
+
+	/*
+	 * A folio no larger than the number of zero-filled pages the user
+	 * tolerates can never exceed it. It can never be underused.
+	 */
+	return nr_pages > max_ptes_none;
+}
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4602,25 +4619,27 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 
 static bool thp_underused(struct folio *folio)
 {
-	int num_zero_pages = 0, num_filled_pages = 0;
-	int i;
+	const unsigned long max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned long nr_pages = folio_nr_pages(folio);
+	unsigned long num_zero_pages = 0, num_filled_pages = 0;
+	unsigned long i;
 
-	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
+	if (!thp_can_be_underused(nr_pages, max_ptes_none))
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
 		return false;
 
-	for (i = 0; i < folio_nr_pages(folio); i++) {
+	for (i = 0; i < nr_pages; i++) {
 		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
-			if (++num_zero_pages > khugepaged_max_ptes_none)
+			if (++num_zero_pages > max_ptes_none)
 				return true;
 		} else {
 			/*
 			 * Another path for early exit once the number
 			 * of non-zero filled pages exceeds threshold.
 			 */
-			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
+			if (++num_filled_pages >= nr_pages - max_ptes_none)
 				return false;
 		}
 	}
-- 
2.52.0


