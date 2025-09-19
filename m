Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F05CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CD28E000A; Fri, 19 Sep 2025 15:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D0B8E0001; Fri, 19 Sep 2025 15:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5A48E000A; Fri, 19 Sep 2025 15:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 274068E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:52:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E2D761A075E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:31 +0000 (UTC)
X-FDA: 83907046902.01.A5070B8
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1714F140007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RK+7wzy8;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758311550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5514hkUU6j/LpNp+jQR2Vw3xX4bDEVjgpb6NqfXeu0=;
	b=LOFLUo/7VxT9zDJX97t7B7kScK/wg6cPLH9ACvbZDmDAGWug5v/E1z0uODndKTANY20XCb
	6xUeuh4Hwt+FicrcVugFuAq7tfgX9YaEDvKKieemJjJjRBXkm2ogPASrpOVMxAydtef3Yf
	7sul2itoUbCB7BpFcehG5o5HMduajPE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758311550; a=rsa-sha256;
	cv=none;
	b=nsVMupjEBCtMvu7Aj1VcUP9klGyXjiVTunc7URktR5I8IHfiJvJQw1oddmBU+JqzEm1WKN
	fnKOJhYR1MLXetA6I3WLDAdBJKFxrVTowwCTZYv3obAbEjr2n5tCUA+lSgtUChM7CRGeo5
	yggJlx0ujoTfVBxpil3grSVvSjj5GxI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RK+7wzy8;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-723ad237d1eso24060087b3.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758311549; x=1758916349; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5514hkUU6j/LpNp+jQR2Vw3xX4bDEVjgpb6NqfXeu0=;
        b=RK+7wzy8U2WGj+powywnNyKFhFJwkYoBwioSatU/Get5VdeSVn/IeBDgf71AXtI8gk
         wVZIgAZsWEIWBdA5GZD8S/cKeEZLXyjzQ1muh5Azdsfo1mikgY8OWqNColu8oXixko6V
         7PQxsWOY2zpqJ8TqtUYcn2V5cKSfp1oDmwvTWDhCZzRkqfxo3Nt0CoaOxvFTFPjVSiaL
         Jlk1l8peUS32TunlrJ+bCdF7gZS8vfLH1s+B3EsTWSld9wNqBbLM5JStCMyXGSysauLm
         V/4lhPj297ydjfdzDxe3XjOf5crc+f8MdProToIQ06NZljpEgV8jbHzRWatNWdM98tq7
         2TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758311549; x=1758916349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5514hkUU6j/LpNp+jQR2Vw3xX4bDEVjgpb6NqfXeu0=;
        b=XfVvsSGKk8Rsl7UH03p+ykcY7zJdhUIdtxgpLBXU6uVR8t2tCYQh1t2C7Mg43xC9GP
         NgKQcNBphERAEM+P8iOfqC9c7FxoJyJgLsUpmz19/SLhpQEyR520IcABZMVcpj+rbDl+
         FIivXHPsmUZStGCMcJ0TK1bJN9ymSXNQAfZj4RaLu3vwF3GHy0tF/OlZjKuqXeA0PPkZ
         xrRPtgfMIz0U0C5K+adacVi+CTdfFjHm8cJ6bvXopGJqlo2zzHU+bH1VYMXFhSr0fOve
         nTzZ3Ujd9fubl21OyXbeACbXqMgl6uwbz3OFakdsj23ar5pQCYytH1x5pNBNgX+yOW44
         xjPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYam6SQP2bYXVlsp2BVhckT7mvnJTLrmfy+P919mid3VSqxJ/LHjutnKP4gjFQOhwXVQ2ah8sIkA==@kvack.org
X-Gm-Message-State: AOJu0Yw9rphMAkCooLdAbi3wi/AmbvcI0Lqhw/m0bpeAZjai9MArNbTs
	TjzEs3OcNwr/mq5TdC1BNKRZL0M4hXLWnTyn+hPNWiA/OE9LfpmV8Yoo
X-Gm-Gg: ASbGnctzBV6l+PwcKYzd82uHT6yZ9yGAPa4cDRtyIIaXCp/A4k3MsUHBjLrmgERDF3W
	B4Tw37gC41+LBxhyU2CkbmqPzCUgmUB3ZdvqUZezlagtCHow04cNf1SJQXKkiSzKoITdSd05AGd
	KElAhkySaklLjVRb2iwxsvPsJctmpV3GKwN8JUnlIMeakaYB0HpN8KzjvThad4+OVnKZe3iXEsm
	sVZ8ZOxO3aY0MpNTNbMpRfzw4FqXDN6cHTRGzs0v0B3E3eR4pFbRva57blcws6GeD/i2K/TFnjH
	E812VjvSsX7zfYM6BARbGBPTVKJXmutf3LIJkZf6BCv7hrOcaOKqTUS0LBKXnqXNjXCLiY/+ecG
	w3vJHHAtSAjVAvqcv2kKA/fXbRY5/8h944FZLxtbfLDlsOu71I6er
X-Google-Smtp-Source: AGHT+IEVBz0LvxtgrKD8uQV/kHRpMtKxa5IqUhA+Ja3x1EMKQQ8NgxEBIv4STTROBqXMAS7ua4+BRw==
X-Received: by 2002:a05:690c:6812:b0:72f:d215:60c9 with SMTP id 00721157ae682-73d3c0162afmr46956397b3.26.1758311549074;
        Fri, 19 Sep 2025 12:52:29 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:e::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-739716caf81sm16662397b3.1.2025.09.19.12.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 12:52:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 4/4] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Fri, 19 Sep 2025 12:52:22 -0700
Message-ID: <20250919195223.1560636-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
References: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1714F140007
X-Stat-Signature: whd6p6ibz4fcrk9jzi8gntt65pr5x98w
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758311549-782180
X-HE-Meta: U2FsdGVkX18VB0ga7WyLncO/ZPGtM8LlN3gLO6LI1PsjacHqYDnGkOX3v++n4bbHcVvWy0r1t9bErViuSAfnNE2FYTdMDDX8QxirQ/kKZOBRU2E1Tw0WcxRHEY7QnL5qLRwFT2bUhDwUVmqdB9YrYVx8mAN9o5qZzABh2zuPTAttb5ld5cIUE4PeSROE7W4F7BAnUwymfGDjEF4FKmVDoqUQ+w0MyDNBWUJUGftrtTjBE7NhlJJR8+vm9gI+SsXXcrdKeJjnnm8aqXBtwUMWPH3hNQmtTc85GawnDANEGB4CDtT99mJ23NsLBKzTP3CbmDqbAf+0ozn17e8ga/wZO1uxgSJvNbrtkX9IoO87IkO00FBInaVRAE/kLYZEBO1iwqHx+KiFJEAARuU6zxw4YCxIQUgDV9fR1DkxxwMVwzlrbTDHs/wOXCrv4Ibz4p3QBEAz+PiE55gix9I/gWSDi2HHrE5M7DAINoVTPMplm5tT5uwZoqrOK4OxofI9oluMZXC3qhrMfea40QaCa7o7Rr/xZjf8/1bBZIjekEXlLJW3IlCr0V1T7/g1xu3Jo7WPZ16BklAHr5ZV9zk3+HqBVzIM3J7/kzt9FSEPty1iWhNXLUX0sl2T2be6uE93uGwW2E7JhSbb9P1XJwhC84Jtf5vXBuN7j4rOpLHU6oCpJJwdkBCq7X58Emqp6CrukHehmkjDXyM4Cv9Kd1ZmXTrO5eU3cBFDEBvT+WcnLijZgXLeZ/lQmFRqYZMN3aTAXwouRGvx7AKTJMbyDlaKtgoRDqzQ017jiLinBWK7XJ70g/TBs83nxkeGdDQLha8E4tC2/rS2lcTvpzv7dBybvvrnHNcnmiGXxglM/JJJeVZtnvJFX3x7ASy7zXdZvaf91r9zZABI8Ecu4n9qGrB1lDPJJuSkQfbZ7dq0XHQxQvomVcvk3H/R2o27rtKFoscoIqgG81N+WpbiZu4r/mod4ER
 ERoLewPo
 qTj32N45XjLYXyAKuiR2V+6d9A/e2w6VdgwhoQU/8S+fyFEOeuNd/OcpCRON1MWV9jni6Rf7AYvFn3hfH2A6x1B6xE1qxXOeod81y5RlppToxmOFh6YHip7RbSjDoeyLrisYlRuDNZLRv3WA/Yv87Qh5hK3l2Fe296mj0sf+XH/cXubckCaDH0Ir0kmWe449lW1jAI++iYKjGBwspbBQaASoB81dX7nRwFlrO8K3jSHq7VWqSMAJN8bVHiVytO1IaDK0Nrc7wPJA9j+jxjQgnrLsHegKjAecBfZY03gXN/qadOiVsbkF6NaEMtKgGgm/PZUj7dplGUK3pKtAaryjKXyinwXdXvVVnXaWQ5J22e+GL6Yqq7/21jTu7iCLkhoal7o5YNq2xf3LKcTCaq+87VckkliqGLwCeyrPB9kfVx0j7xCYk8nFjK+Xil4snqDGe81jwK62yg7Lc5zUClyzZPHZtcGbAlolLgVrFuk/qnrxRYK+0hkmlvg/8R1/1Arhveq8uLV0epid5akoZAMzk3jaZNXf3NFyqGPXbSBtqxstcXw7nhbrKCvdFQ5REoQvwcOfudEhxAqOf/Yn3CAbrBfwAD9CE0lbyzGUdmYRdXzIUGSkS0m4WKH49S9pfL6pgX/b/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before returning, free_frozen_page_commit calls free_pcppages_bulk using
nr_pcp_free to determine how many pages can appropritately be freed,
based on the tunable parameters stored in pcp. While this number is an
accurate representation of how many pages should be freed in total, it
is not an appropriate number of pages to free at once using
free_pcppages_bulk, since we have seen the value consistently go above
2000 in the Meta fleet on larger machines.

As such, perform batched page freeing in free_pcppages_bulk by using
pcp->batch member. In order to ensure that other processes are not
starved of the pcp (and zone) lock, free the pcp lock.

Note that because free_frozen_page_commit now performs a spinlock inside the
function (and can fail), the function may now return with a freed pcp.
To handle this, return true if the pcp is locked on exit and false otherwise.

Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 467e524a99df..dc9412e295dc 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2821,11 +2821,19 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
 	return high;
 }
 
-static void free_frozen_page_commit(struct zone *zone,
+/*
+ * Tune pcp alloc factor and adjust count & free_count. Free pages to bring the
+ * pcp's watermarks below high.
+ *
+ * May return a freed pcp, if during page freeing the pcp spinlock cannot be
+ * reacquired. Return true if pcp is locked, false otherwise.
+ */
+static bool free_frozen_page_commit(struct zone *zone,
 		struct per_cpu_pages *pcp, struct page *page, int migratetype,
 		unsigned int order, fpi_t fpi_flags)
 {
 	int high, batch;
+	int to_free, to_free_batched;
 	int pindex;
 	bool free_high = false;
 
@@ -2864,17 +2872,34 @@ static void free_frozen_page_commit(struct zone *zone,
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return;
+		return true;
 	}
 	high = nr_pcp_high(pcp, zone, batch, free_high);
-	if (pcp->count >= high) {
-		free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-				   pcp, pindex);
+	to_free = nr_pcp_free(pcp, batch, high, free_high);
+	while (to_free > 0 && pcp->count >= high) {
+		to_free_batched = min(to_free, batch);
+		free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 		if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 		    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 				      ZONE_MOVABLE, 0))
 			clear_bit(ZONE_BELOW_HIGH, &zone->flags);
+
+		high = nr_pcp_high(pcp, zone, batch, free_high);
+		to_free -= to_free_batched;
+		if (pcp->count >= high) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(UP_flags);
+
+			pcp_trylock_prepare(UP_flags);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			if (!pcp) {
+				pcp_trylock_finish(UP_flags);
+				return false;
+			}
+		}
 	}
+
+	return true;
 }
 
 /*
@@ -2922,8 +2947,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
-		pcp_spin_unlock(pcp);
+		if (free_frozen_page_commit(zone, pcp, page, migratetype, order,
+					    fpi_flags))
+			pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
@@ -3022,8 +3048,9 @@ void free_unref_folios(struct folio_batch *folios)
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
-					order, FPI_NONE);
+		if (!free_frozen_page_commit(zone, pcp, &folio->page,
+					migratetype, order, FPI_NONE))
+			pcp = NULL;
 	}
 
 	if (pcp) {
-- 
2.47.3

