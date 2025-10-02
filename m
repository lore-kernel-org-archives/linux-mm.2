Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6294CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D118E000A; Thu,  2 Oct 2025 16:46:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5F38E0001; Thu,  2 Oct 2025 16:46:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C986F8E000A; Thu,  2 Oct 2025 16:46:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9D888E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:46:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 796B7160657
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:45 +0000 (UTC)
X-FDA: 83954357970.04.4CFD17D
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 92FD71C0009
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wuej+Vnc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438003; a=rsa-sha256;
	cv=none;
	b=pKsY9PGW6i3DkhIOMLjxSB4LeEbf4X/20NiFNYNI+ENGclbikgm084nd1HplysQ3iywmA4
	m1aUIeHk/AQleK18/Tka+G+p32beyj00/M4V4WDEbcNapw6rxmgOAYDv6HW78ty3vGpqB7
	okJ8P+9uHp9idPdRH9M1Jt8HpfmonFk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wuej+Vnc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBa7sIAa7lZB7AE0W4U5YndRgjFk5P+mjzsHi3y1lyA=;
	b=Xpm2SIo9VbndvwF5NbIMhaIarCQxB4a/Sv8huiCEfqa9U6OpMrZPiBeRRZsKtNZTpts40Q
	yNnVapstvGpa91DPufuNe/quDHQ71/4UVlvLPYSIO5vdE9VR3Yv/MSUwZ+6maCaH7YrxF3
	gsSF5qGBqwUNE3dfNgSx3qYxK60rySM=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-71d5fe46572so20425817b3.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 13:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759438003; x=1760042803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBa7sIAa7lZB7AE0W4U5YndRgjFk5P+mjzsHi3y1lyA=;
        b=Wuej+VncaxC02a1RyGmwWOxdYPNIC5JzHnp9eO/6YJJ1x0pT+/Kzf7nZt4WbDlBOxW
         ZIjsJNEUmTkX9XAa3oYQGCMxShVtGFLMUIWSx3Ks7j78hmqkxUBEi4+M2Mgf9hfUmols
         Q9ndXoZZ0eoPrVTFRB7NWGtuPoTxgsjiUsrvlih93szuvekWKyGkkqTFOObz64fLrDjW
         nyVlhctsxfWfliH3eB0iCQF5bWx4FvLiOFPPUYVfragh/0ryhUxkAEQ6xFncr95sfnWK
         IN8d5q0pluFMq/Fvno9uXhNlPrJ43JiQIVOA3LStrt9tPhT+V+5XoMLDOA6i7ZaHkHJ1
         MyNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759438003; x=1760042803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OBa7sIAa7lZB7AE0W4U5YndRgjFk5P+mjzsHi3y1lyA=;
        b=lBP4+2xdNUyPiu66zG5FLEVNi2n7zndfHxbm6uhouZjYNOqxqxZ1xz7qHpxG6BAPnX
         1aMWTs6vZ8j2jSJuqr9/zdyttBFp0kv8ZFL6Luu/CWC36u91pf3bFTak0aAoSwh2YIyP
         a4a2orooN/CRtLWclw3+oBuQhcGixN0xvB6MTaP2uoU7uKRdTjIsuL/fSdyIs+iR/4iR
         JcQh0w0VoP3sVz6fL92YqKhFZ769kaFHM6h2xVsAcwR7Hjj3e6VDrxw32+7ZwTIkUQ5f
         f11WyjbPZAEostPDsZmfa0XXrL9lxO9V8Ob1yGP8ZlISFWskDa+M3wDt91tplGDrZ7Lh
         Obew==
X-Forwarded-Encrypted: i=1; AJvYcCW+y9JbQFyhnnG/Ek/mnx6yP64+efkp6TkU8hIWorOHnpjyfI8BSxF9NS5z/0ROfw5D4dUBqf8HXQ==@kvack.org
X-Gm-Message-State: AOJu0YyCZVHMfkkvo6XuNlBI5W8XOeE16DmH363ieIRj0LQJoDRiJryo
	dN6FsODdhHgtdXNTyXtr7qkD/R9bjJJm56hWtCT9O8RhLsFTbPxZanu1
X-Gm-Gg: ASbGncsXtUd9SEP+6cVxNyDcXgLv9qWBcEytX9eBOmvhfvjyPEwOTvoqnvLETjB8fWE
	6kTGfllJ37XSAxfP+cKJGh12lZD/+yZazxk9aIlqmWpLrKMbSVaKCrEzzjrBzIP2KsWRhZ9HYnJ
	fI2XE9qMflXLsB3PLTIgCa6fVmbSM60cYxXQQGyPvamj/6IqPGw41nT11HkBUfM+egE1F6+HQMA
	G3ajIVxIpCSehs3ILeOBTCwhc3UYKbGPlGNH5YPLvbCsQjbEVcquqV3jTtXyogQ2+wBLV2uGONT
	59+aliht0ItDEAMDFqJeQSWZpDVtzv56GwD1SGnMgac7WXcJ4WGv/LlIorArwULLlb8Ans4IfX0
	6WbLgZJQynwfi3y7i2ng/V78/pKEnH87JDHdYN8gFKXhOypFGN2WKgp8NUyJgwwScsKUHET96BR
	UkPohrmBfN5fQ=
X-Google-Smtp-Source: AGHT+IENI2go9fghJpen+tUDrCCnqIsPZ10tsTLEeBnhI7cBoG/y7/sR3qgtxNTvBex2gqOGrkvgtA==
X-Received: by 2002:a05:690c:a4c8:b0:77f:771e:fb78 with SMTP id 00721157ae682-77f81b6c90amr49034987b3.18.1759438002398;
        Thu, 02 Oct 2025 13:46:42 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77f81d1444asm11412977b3.42.2025.10.02.13.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 13:46:41 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 3/3] mm/page_alloc: Batch page freeing in free_frozen_page_commit
Date: Thu,  2 Oct 2025 13:46:33 -0700
Message-ID: <20251002204636.4016712-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92FD71C0009
X-Stat-Signature: 6ik6y5pygiob4t51qupf6p8wfrerwm58
X-Rspam-User: 
X-HE-Tag: 1759438003-9445
X-HE-Meta: U2FsdGVkX19AfGd+/4/KX+jgYVVPLP+sVjFSwW82K1OVya5upG/dQ/nmqB5kCycokm3QpIxZ6jLaXY/AkVNgiSnnHc/ofC4JWrt3srf6QxT55CpNdALFzCNtiXyhj8JKBYJSHrPgKexagAyaNNvSkPvPZrKHl1G4Ab9/ZBfktpA3bTYMOCN3sVzjNEr0YECX8cIfjaPfrWuiRmjyPZphBpTihWBkdKxDDGeRFWorpxiv1q1ubJMYle8L9iJL5S14MHnADxmC0q6MTYGdM8XMjzV6h3hN38jbxJefiLI4rfVB/P7/dPPJLZINcimdLRyoF6QHk45u12hLuhb146s4KveEsZbDRnneFyDvHopti2qM1geZK6rW7e6HFOS81xLhzIO4kmK5dUjLB1xOT4IuiPoKQMIVmR7HKWRL14J7A5new9m/NgD1t1zHlk6geVoOFRTG6VAxJbx9ZtJ/tQRt+S5YR5uRj/Yu8UNqGCZDdaSzsJj5TmPjD55empGnL1N1ZHotXqnkpn+VAqM2HLMgP6LDII+vCfG8UQ3Xnf4FtjtcKIzkWg5FuTGmPDbKY2uGoLYbU9/eeo+kkMY2Xtsi2Wk87pouwDq+Ymea2ZasKIIYn51n3Lez0PlVQXk/+ozoj3YYUSZfBafGQQ38HOAbrSUWErG3xtMCv7MwR8O5b/VVqjcbU4ROYaqSKw57Sresfm0Cj4UEJ3v59linlHp30VjBcq8lGiMXWRGPmMZWxpaf9i4osALJoZOyoTosMYbq071MsO46SWBYv+cmtqtDpMkzWvuOEpR0igVxBr3MViL9iixkL1SZOm4DVB/IcfM2siXaTQ1YbcnPsmK1OfCeh1YZL9c2/3n9vUDyJYi8DviWDxi1DvlABGa95mMUupNIefRchknhNnXh7mQy8nAl1CRTtt7KqVcjWOEQt8sq9RqqMpZkeEIo4G04wehaB6tbiahj/G4CbmFdUglgVRY
 ZRXE2L98
 Rh06wEnFF8OE/8ymXuPEv8r1leOyFx9L51qv+z+TG6C10Vxw5PpzZr4y3LrzQ6OPiPWJDXTiweGhH88KpKooTDHg0APWdcLc5egNNnz99RTUpLr+vCjHrMKo786FGzviKjYZlRjx4pqO/Cn04HfitoMKCn/P1A+DiSQ1nEddmAhDgax05wZ3wke0o0SQk80EXArksFmjcFajK/IPG0hm9qilFwSf9Qt6yeVfIS6JLUvM19xJol2UpXtfxmM1xxJcDidGP9khYVz5cT+9OW63OSuZ+QG9zjq7OZQ74JreluaFi8SWMtmUFOoBbzX/HwDTlNjazAfimN287OGvyC35g+HLYWxyci1KDv2/XNa6QlwkXjxWpR2UgugMRRBlPq1IsiI47Ie2j2Nxsqr+hhP593kK76gGasEvwROFA1rTXIvddJYE8HYZ3Bxck4xD0rfUCjJN2rBXH+clUkDBSQgLAJbFhlArs5W1Qm1XuW12U6s3YAXJHi/UYWRGIVuEMHu2uRjWUQ6VtqFWhrmyRBRp8jDPQ3HU6m2KM2F1jYXnafpjV/8cQP6+9OBASxPRKzICxT/pQawMKW9Z+SO428REWbmKrRCYkMnTLxEVH3v3lEuyAsolSpm4VLcYlZHh+9taxMkwJ
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
starved of the zone lock, free both the zone lock and pcp lock to yield to
other threads.

Note that because free_frozen_page_commit now performs a spinlock inside the
function (and can fail), the function may now return with a freed pcp.
To handle this, return true if the pcp is locked on exit and false otherwise.

In addition, since free_frozen_page_commit must now be aware of what UP
flags were stored at the time of the spin lock, and because we must be
able to report new UP flags to the callers, add a new unsigned long*
parameter UP_flags to keep track of this.

Suggested-by: Chris Mason <clm@fb.com>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 66 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f525f197c5fd..9b9f5a44496c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2818,12 +2818,21 @@ static int nr_pcp_high(struct per_cpu_pages *pcp, struct zone *zone,
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
-		unsigned int order, fpi_t fpi_flags)
+		unsigned int order, fpi_t fpi_flags, unsigned long *UP_flags)
 {
 	int high, batch;
+	int to_free, to_free_batched;
 	int pindex;
+	int cpu = smp_processor_id();
 	bool free_high = false;
 
 	/*
@@ -2861,15 +2870,20 @@ static void free_frozen_page_commit(struct zone *zone,
 		 * Do not attempt to take a zone lock. Let pcp->count get
 		 * over high mark temporarily.
 		 */
-		return;
+		return true;
 	}
 
 	high = nr_pcp_high(pcp, zone, batch, free_high);
 	if (pcp->count < high)
-		return;
+		return true;
+
+	to_free = nr_pcp_free(pcp, batch, high, free_high);
+	if (to_free == 0)
+		return true;
 
-	free_pcppages_bulk(zone, nr_pcp_free(pcp, batch, high, free_high),
-			   pcp, pindex);
+free_batch:
+	to_free_batched = min(to_free, batch);
+	free_pcppages_bulk(zone, to_free_batched, pcp, pindex);
 	if (test_bit(ZONE_BELOW_HIGH, &zone->flags) &&
 	    zone_watermark_ok(zone, 0, high_wmark_pages(zone),
 			      ZONE_MOVABLE, 0)) {
@@ -2887,6 +2901,35 @@ static void free_frozen_page_commit(struct zone *zone,
 		    next_memory_node(pgdat->node_id) < MAX_NUMNODES)
 			atomic_set(&pgdat->kswapd_failures, 0);
 	}
+	high = nr_pcp_high(pcp, zone, batch, free_high);
+	to_free -= to_free_batched;
+	if (pcp->count >= high) {
+		pcp_spin_unlock(pcp);
+		pcp_trylock_finish(*UP_flags);
+
+		pcp_trylock_prepare(*UP_flags);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		if (!pcp) {
+			pcp_trylock_finish(*UP_flags);
+			return false;
+		}
+
+		/*
+		 * Check if this thread has been migrated to a different
+		 * CPU. If that is the case, give up and indicate that
+		 * the pcp is returned in an unlocked state.
+		 */
+		if (smp_processor_id() != cpu) {
+			pcp_spin_unlock(pcp);
+			pcp_trylock_finish(*UP_flags);
+			return false;
+		}
+	}
+
+	if (to_free > 0 && pcp->count >= high)
+		goto free_batch;
+
+	return true;
 }
 
 /*
@@ -2934,7 +2977,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 	pcp_trylock_prepare(UP_flags);
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
-		free_frozen_page_commit(zone, pcp, page, migratetype, order, fpi_flags);
+		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
+						order, fpi_flags, &UP_flags))
+			return;
 		pcp_spin_unlock(pcp);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
@@ -3034,8 +3079,11 @@ void free_unref_folios(struct folio_batch *folios)
 			migratetype = MIGRATE_MOVABLE;
 
 		trace_mm_page_free_batched(&folio->page);
-		free_frozen_page_commit(zone, pcp, &folio->page, migratetype,
-					order, FPI_NONE);
+		if (!free_frozen_page_commit(zone, pcp, &folio->page,
+				migratetype, order, FPI_NONE, &UP_flags)) {
+			pcp = NULL;
+			locked_zone = NULL;
+		}
 	}
 
 	if (pcp) {
-- 
2.47.3

