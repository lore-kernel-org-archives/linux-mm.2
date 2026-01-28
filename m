Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45619D35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11486B0092; Wed, 28 Jan 2026 04:30:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6176B0093; Wed, 28 Jan 2026 04:30:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993D46B0095; Wed, 28 Jan 2026 04:30:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 875EA6B0092
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2586B594FE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:49 +0000 (UTC)
X-FDA: 84380853018.08.A6AB2CA
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5415340006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XTWpQV9N;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
	b=t6nKtjnxn/96BmV3U4a/5ko0034+ZPnv3H0jQBCwzKC/PdGsTrIP+qi7I9LdfONH1QSf9k
	QtYOx8X/Hgh8PYh5OtgK0bbS5km1Sq+PqufQSXsP6fJuh0Z2StU3Y2vi0CB9h6PePeFCbj
	HLT/S43M5zLji1kh8AQt8OFe0sptE7Q=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XTWpQV9N;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592647; a=rsa-sha256;
	cv=none;
	b=qRri4bea52S9nrSXB/9WQ6rBUh+3G08IIS3pX+Ti77nxf5/hieNniSomJ6rF0jH7qItCRB
	wEodDef/dg9YzjUjxjrgfoqumOaIWhwGs1wqM7SYvYqKknEOiyhidoQZQdZ4UVDQDfdMEj
	5QTAOROmeRBxaSSJfUHHn+TDxgurUzk=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-352e2c59264so4518136a91.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592646; x=1770197446; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
        b=XTWpQV9NBQLArPqwRQg07hWapSmRwivcein/WZ7dOZA160LOSd5ggr1IYN7vtIzBdA
         xBGGuqdaftcjw9A9GX/FMwfmxSbRjkV8EHCblSey6U7mFSjZz5tFzstJCoAmwP7bixVc
         OFo3yGV0ufX/pv3JoT4EqmCwE2s63MsffsozxchawlTAV4R/S+SeJkH/rg4kYF4Vycmc
         i5KC9SwiEJ5pdCf5zjWBX4w8q5zwWi9sRBfkEjjakQu0V1cm8cI77IxU4/SaLdkXAq9U
         pVh4ib5Cos55TqH88LrRkGj0gKsQ8B6d49HdQctLX+Zt65Y1SgiXfNBI0zFQxkX2HUtc
         CVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592646; x=1770197446;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aAw5ZLwfH3aOqNw+8qnqKgdPaynl21dDWoO/xPxb8Vc=;
        b=JqVuLyGT0c9/lHUcvk7ZCWjZGH11N/HGT5MwKxzHG64JuLiKc48sm10rINioz5frwS
         n/jcZKePMofQq+1Bf7Apz1LhwgPaerUvYGB1XZpY7sBbp2eMz/oU1JKwFjJGB5z4Y1aZ
         dpJ4bT/cyF74FqYmyd67P8J1nwDK5IVamxKoqcW+sZNUvESMzCmzc+RRWkBsQf/BPwfQ
         zNdPFiCQuokcyZmXZu9Az0oWPztvpB31R1xSFETFGwpz+yiim0QK8ij3k6QpERRp6IRZ
         JRkw8sXo5mj9dagxyXRcx34dr4nNDoKbbH2Enc2cOE7faLDqtcOAmBYG6rTwAos4kXcw
         lTwA==
X-Gm-Message-State: AOJu0YyU8E8NJt30zgO+nmRkyndBjPm14iiST+YE+kCTySZbhjI9mP2a
	0pP9HMDeGhqaevsrDeJakJlVPo+lqbhGskzHT8L1hnB7/UGd57VqwvHz
X-Gm-Gg: AZuq6aL6rQNcGGZ/+d6QL65RNTjJkLqKQf0lXmmBSCqGP5soorDvRnukKqh7y81s/fg
	Tz9q8RkvQ8X2S4hDvah8o2ph3EDaOFrcKysZWoqN1AciVUSU6MM+fT8JAV+YL7EUEvYJgxz40Bz
	F6YJkJ7IyMV/tXcY6klYBqHdFPFOAcHfH63IOmamo3/pqgf3UFAmEjWCPYxgXeOSu2RbNGBu+kz
	q88KjDSsyDxK59+eFIrQ0J4G5FuBALRUMstF7uF4vjaGVuXKLIqmSK6EKDgccokPBHlUuoABhuR
	d3xHNuDTadVR9F5kk8QlwacYeN/elNpJYGRQQBhVmb7NEoEKv9sGmevA5n/wdB/o5AUsxMX2qQS
	LMlgyugLdVLxoOH2bZiPQ6yiMzD8A1h2XF1Cfsni/HEr4byQzQTYhiWywsj9VZAsVqLtd0bPFpb
	9ITqoeil03DdItrpNSjpaJzWx4tf+XLnD7TSg2/QImhuOHf+1448SsKqO3Hg==
X-Received: by 2002:a17:90b:2f04:b0:340:ad5e:cb with SMTP id 98e67ed59e1d1-353fecdcfabmr4259352a91.8.1769592646111;
        Wed, 28 Jan 2026 01:30:46 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:45 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:28 +0800
Subject: [PATCH v2 04/12] mm, swap: consolidate bad slots setup and make it
 more robust
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-4-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=4411;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=OidTajkMc0iGAT4CQSZ4FaMMIJHOoz6IAuhiV5n7RgI=;
 b=cmDmAT8wUMiXX1gPvgA7bHsM5uiECNHeKtIvXly1+RBv9uooWAdTksHnja5oCbt81l6FmPKio
 PhDaU+N3Zy1AhsScxqi1FhSMKzBvxMFEkNRKnMayV5T5SAlUDMCxC8G
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5415340006
X-Stat-Signature: 51yq74wmryira1k9fergjnuhqhdyad7t
X-Rspam-User: 
X-HE-Tag: 1769592647-814456
X-HE-Meta: U2FsdGVkX18MPSmxJcv7GTL1a7TVnV2+cJ3EaHbScK+PxWWVMmdwpJcdJjAFVqmp45iWlGB/pPI/NHu3PBWj3u9SXlYq9XDTyqeOf3Re+rCfGich9efwgu5W7HTWnOLbjI9nEaOHUIVsrF48mgkhrh8bOhDOnLxMf7zLaFwppkXUb+GpVMMum14HFtKx4eFfW6mvHg+QfcNodAr9kC30vima6TmLeUXO2GH8oMPdn4TtqVxsx4683HwQe28WzDIV9z207hBU0TREBmWoFAMEazuauTInGJZwEvOayDLRK9D5rEVJVxo/3FJPk+VfgNM8bMqRwmzAAK4mFmhotB/JCJwogHjSHB1pRiG/1c7QVr6OJ4QngrgauaYZtdw/fKQKAlu4lOKQsFp3f4jL4u3kU9T36pOoe9VyY45kMAS2w6UihNhyDGzheOvDftNm/aGOWA+ai4lOf2iO9grh0Z89gZfHOFQVBY9dmKrouauOSud/EzBv6WZIW9nPvApRgr9gZbtM+0J1IK6wM6KkXi5wGgyqubZJ8kyFHlD6ifzYWZb1oP8gNjyileu/OXB4zdc7PCmJntFfj7mIVZYtSt0xtHVUtriiaLuz6v/o8RYLh/zIC7hgOVhtGYaxB2AieXX2QvUOy6pT1eeTYFr5lOTL97JHllb9YQrAiygZJhx1nkvgL5SbRtFEbFztSwzPulZcPyLkCELM5lTCgtu+4sGBGCjj57Re67s4l24kSkAVaJ50uVZ5k3Ay684rhLHg4O15Cn9O9TlsiWglQzcJT6+D8knCKOpTTyOE1p/b49cQtQGwAKtIj+64Rn00StkNlsU+g/eQDYgCQroULSZnA9vZCUIQJgTK6gBuWAuFjr3fT7wfpCiq1DiBT4UvsPyq53VLjqOAS0T6umdWQH9A9es0znlceHkfKodVR3vvSU8fEzkEBfb4MEBAdqwa1Wp0P+kEXt40ADa4/y2mKrrOOQY
 cFul6SoG
 ykc1AMAassVddzo781gV4wec7tQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

In preparation for using the swap table to track bad slots directly,
move the bad slot setup to one place, set up the swap_map mark, and
cluster counter update together.

While at it, provide more informative logs and a more robust fallback if
any bad slot info looks incorrect.

Fixes a potential issue that a malformed swap file may cause the cluster
to be unusable upon swapon, and provides a more verbose warning on a
malformed swap file

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 68 +++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 30 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 80bf0ea098f6..df8b13eecab1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -743,13 +743,37 @@ static void relocate_cluster(struct swap_info_struct *si,
  * slot. The cluster will not be added to the free cluster list, and its
  * usage counter will be increased by 1. Only used for initialization.
  */
-static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster_info,
-				       unsigned long offset)
+static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
+				       struct swap_cluster_info *cluster_info,
+				       unsigned int offset, bool mask)
 {
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_table *table;
 	struct swap_cluster_info *ci;
 
+	/* si->max may got shrunk by swap swap_activate() */
+	if (offset >= si->max && !mask) {
+		pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->max);
+		return 0;
+	}
+	/*
+	 * Account it, skip header slot: si->pages is initiated as
+	 * si->max - 1. Also skip the masking of last cluster,
+	 * si->pages doesn't include that part.
+	 */
+	if (offset && !mask)
+		si->pages -= 1;
+	if (!si->pages) {
+		pr_warn("Empty swap-file\n");
+		return -EINVAL;
+	}
+	/* Check for duplicated bad swap slots. */
+	if (si->swap_map[offset]) {
+		pr_warn("Duplicated bad slot offset %d\n", offset);
+		return -EINVAL;
+	}
+
+	si->swap_map[offset] = SWAP_MAP_BAD;
 	ci = cluster_info + idx;
 	if (!ci->table) {
 		table = swap_table_alloc(GFP_KERNEL);
@@ -3216,30 +3240,12 @@ static int setup_swap_map(struct swap_info_struct *si,
 			  union swap_header *swap_header,
 			  unsigned long maxpages)
 {
-	unsigned long i;
 	unsigned char *swap_map;
 
 	swap_map = vzalloc(maxpages);
 	si->swap_map = swap_map;
 	if (!swap_map)
 		return -ENOMEM;
-
-	swap_map[0] = SWAP_MAP_BAD; /* omit header page */
-	for (i = 0; i < swap_header->info.nr_badpages; i++) {
-		unsigned int page_nr = swap_header->info.badpages[i];
-		if (page_nr == 0 || page_nr > swap_header->info.last_page)
-			return -EINVAL;
-		if (page_nr < maxpages) {
-			swap_map[page_nr] = SWAP_MAP_BAD;
-			si->pages--;
-		}
-	}
-
-	if (!si->pages) {
-		pr_warn("Empty swap-file\n");
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
@@ -3270,26 +3276,28 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 	}
 
 	/*
-	 * Mark unusable pages as unavailable. The clusters aren't
-	 * marked free yet, so no list operations are involved yet.
-	 *
-	 * See setup_swap_map(): header page, bad pages,
-	 * and the EOF part of the last cluster.
+	 * Mark unusable pages (header page, bad pages, and the EOF part of
+	 * the last cluster) as unavailable. The clusters aren't marked free
+	 * yet, so no list operations are involved yet.
 	 */
-	err = swap_cluster_setup_bad_slot(cluster_info, 0);
+	err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
 	if (err)
 		goto err;
 	for (i = 0; i < swap_header->info.nr_badpages; i++) {
 		unsigned int page_nr = swap_header->info.badpages[i];
 
-		if (page_nr >= maxpages)
-			continue;
-		err = swap_cluster_setup_bad_slot(cluster_info, page_nr);
+		if (!page_nr || page_nr > swap_header->info.last_page) {
+			pr_warn("Bad slot offset is out of border: %d (last_page: %d)\n",
+				page_nr, swap_header->info.last_page);
+			err = -EINVAL;
+			goto err;
+		}
+		err = swap_cluster_setup_bad_slot(si, cluster_info, page_nr, false);
 		if (err)
 			goto err;
 	}
 	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
-		err = swap_cluster_setup_bad_slot(cluster_info, i);
+		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
 		if (err)
 			goto err;
 	}

-- 
2.52.0


