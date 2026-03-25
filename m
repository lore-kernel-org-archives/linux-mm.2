Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2733109C050
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 17:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C9D6B0092; Wed, 25 Mar 2026 13:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD636B0093; Wed, 25 Mar 2026 13:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF826B0095; Wed, 25 Mar 2026 13:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD5C66B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:55:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A160BBC02A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:05 +0000 (UTC)
X-FDA: 84585336570.02.4FF4208
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7C48C10000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:55:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774461304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElkSFE4zkrAUfKBrDHv1SHTi9nOrwBxw2lfXih57/Rg=;
	b=guOa+xf83yEMh+TfrvBYLerZZcbkzBFQdDGkFIxBpcSij9EgJqNgOOUo/WHlAaS99bf4w3
	s9FI7CedimcH7iClNMl12RkGQRv8zNKyESyBTGq+2kD0N+tMMfdHdTHj1Xr0mdCIvGs/OD
	sWNWDODVDvLrPT2zjWpYhaJPB5A3xlM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774461304; a=rsa-sha256;
	cv=none;
	b=pyUETZgv0+9B9mcbRAvdG7kCWryIpsgcdxjGm2ZTeCu2XVPppZZ0is2wlsO3g1AJJmLrpj
	0zXVo0w8LCfred5oEy808tKwniSRMjbL3+uXqXpPLAhAevx8hPsTapmAtLDx5ytNdchRtJ
	h30gRPlpisBVljFqbkD2DWAesi3HKkM=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 02:55:01 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com
Subject: [PATCH v5 4/4] mm: swap: filter swap allocation by memcg tier mask
Date: Thu, 26 Mar 2026 02:54:53 +0900
Message-Id: <20260325175453.2523280-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260325175453.2523280-1-youngjun.park@lge.com>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C48C10000C
X-Stat-Signature: nyzh7o331z8t9od3dignf4p7e67wto5j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774461303-944102
X-HE-Meta: U2FsdGVkX19bszE3ixQDCmv6tSvuk1H5yykCX+/dg3FN8xtuoJ02V7Wv/ZZsBzobsIqfsP5tJeZDyOZC+/hYRFd3XdHzKrPPlyAuT81DT1gN6ZI8NZ2Kf4cnJFEjUhaRzbLMYtxNs7UJqMAdApEd4k382rqXKJ4/K0FEJJnBIWc+dUbuqvzIKcTPY7cCvUnjy83m8BE94t+cXyhsiBy3kSh66W/LMzpR6I87ppjGZ+QQtQ5IFVnWQMfSoD9KXqEDuQRzZ8wgAf4hj7+PDoNDD9+h4OPJ4f1F5MWQZ3pWAP+GYsiSfO5nKFTdnoFyJPsF2ymZ97Pcoa6elzAbvihevYeykcJ/pNMHY17l7izS3/z6fUCotVhZenDSh/yH8mO1a9pl/sdY2rlNOCasxpY0bQ5D/yB4bz0ygeli3MLmzn4Sb96/lsehe27gAjg8pvbOkupO0Cxe2UGffu5nXS5erqEDj3Wkffs4GIFsZTfwFcWT8G0eVxI2/G2kizK3Ub0Y/J6SdbW+9riFV2WwwG5zUmAoo7yTa7/tATLokkvrP33U0rqQAfXoJ5RKnb8xmrEHe18pZTNwzau5VyjqhLpnsuA1cS2CNTXoVfx+B5QFIPQLFNgkzMk4K5zDewGBDhabx3vFbeFuNiYQ7pRu2Pj+2YOOXvI3wqwqOvdk08Ekui2BFY7pLqXPrtrM8Q5Ul2oVTi5Sn2uBs+6FCz5x49DrY7Yd6s2xTO0An/KTlL+B/AvYk2HHOgYy5nkZeVYxt1MgjM2xj6levbj7Bw052YXs4D2JRXA/Tz/4Lwg4siDVvkbmB8K5YDLe3uBIxfVeVyUdxltDzhsbcZR7rqZt2xFUj26pvx4klQwFztWqu7BVYA+VsfqF2Fe4QtpTzo5F6mvmc4IxEN7SMumsdjv3n9TDXFdTdDUtO7FhY1uYIY4v7Pj/cCIG4xjCOwKoibv3fO6E5TjS2nq2hGoZ3Cled2s
 lcNFnfC+
 iGgaPvEmSzqTK0Qmii4oCSpfoDV6W5qzBSWEgmF5sqse9xlEBjW9iEZ/j3PHkemU8TI85/9MAU5ufBJkHNwE/MR7rPH/4tJxepnNSqmB/T0a0B+wfFTnF2sJZekRlc2lFZnsSU1IfxSjTdQw3qfw4gQYe797y2AS7clRj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply memcg tier effective mask during swap slot allocation to
enforce per-cgroup swap tier restrictions.

In the fast path, check the percpu cached swap_info's tier_mask
against the folio's effective mask. If it does not match, fall
through to the slow path. In the slow path, skip swap devices
whose tier_mask is not covered by the folio's effective mask.

This works correctly when there is only one non-rotational
device in the system and no devices share the same priority.
However, there are known limitations:

 - When multiple non-rotational devices exist, percpu swap
   caches from different memcg contexts may reference
   mismatched tiers, causing unnecessary fast path misses.

 - When multiple non-rotational devices are assigned to
   different tiers and same-priority devices exist among
   them, cluster-based rotation may not work correctly.

These edge cases do not affect the primary use case of
directing swap traffic per cgroup. Further optimization is
planned for future work.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 645e10c3af28..627b09e57c1d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1352,15 +1352,22 @@ static bool swap_alloc_fast(struct folio *folio)
 	struct swap_cluster_info *ci;
 	struct swap_info_struct *si;
 	unsigned int offset;
+	int mask = folio_tier_effective_mask(folio);
 
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
+		!get_swap_device_info(si))
+		return false;
+
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!offset) {
+		put_swap_device(si);
 		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1379,10 +1386,14 @@ static bool swap_alloc_fast(struct folio *folio)
 static void swap_alloc_slow(struct folio *folio)
 {
 	struct swap_info_struct *si, *next;
+	int mask = folio_tier_effective_mask(folio);
 
 	spin_lock(&swap_avail_lock);
 start_over:
 	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
+		if (!swap_tiers_mask_test(si->tier_mask, mask))
+			continue;
+
 		/* Rotate the device and switch to a new cluster */
 		plist_requeue(&si->avail_list, &swap_avail_head);
 		spin_unlock(&swap_avail_lock);
-- 
2.34.1


