Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39ED4CDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 07:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD266B00EA; Thu, 25 Jun 2026 03:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A56F6B00EC; Thu, 25 Jun 2026 03:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BAD96B00ED; Thu, 25 Jun 2026 03:39:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6D9D6B00EA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 03:39:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 733041405F6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:53 +0000 (UTC)
X-FDA: 84917635866.05.5EEFEB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CA69B4000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:39:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftIouGIb;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782373191;
	b=VPXc5f/wdRJcPjTcBIzDW34qBrbB0E61FAU9J0G+6IJ/J4EC267a1VyBJih5/TKwup5jYZ
	3idgfOMpFOwBZWmaMDOZ9XYR8IdhKzzym4r+Ah7ACdfGLCo7tcNynjh5S/4kvh148250fL
	V3m23Eu8kTyUo8pDhNBAo38w3EX1oXc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782373191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+nN8YPY6FvgX/MyAFKnpv3UfsMso7OqDwdTVU5IpME=;
	b=B01pQgBbuidMXBz5UTkXUqddDkPpEDw4jblhMRnTFh2cHct3/S2M0mXUVRsoM/bUmtjQta
	nUcWOpGyEu0x7IB/6EF5oX6GmkFDBRgPp8eaa5ZO0WGBOdxvBRHOFG+sUI5GeZBywi1FCr
	/lJE7ehVCYBfFkoZs7Ick9VZtg3Uzck=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftIouGIb;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C992B44023;
	Thu, 25 Jun 2026 07:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99C51F00A3A;
	Thu, 25 Jun 2026 07:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782373190;
	bh=s+nN8YPY6FvgX/MyAFKnpv3UfsMso7OqDwdTVU5IpME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ftIouGIbjylri8Kvfke8oEPPfNhoHjEMCy1g0bISWEG95ICf/t2wZYfadI4Vn9gAm
	 5JcSDQpIvloVh9UoBjK+2vKo5jZSo+HOUc1qtgOL37dKIFzo5fNEy7IBw+VsKTfxVH
	 l6Wc8vfUY0cr8XxjqYvUxdbg3D5gpQuEK/OVOk0hEiVAJ4bs1/4ykdtgjAnHwgsYYW
	 e9v6Gv5EmZGsZI/Ne0ahYegl8UcojPMQ7fwgbF0WWEzeDnqdgoIaM9T87b/K/Yc/O2
	 0Y+GHaYEZrhHQHXzsWbwvUJSoAtDW13+NDNiMpjcIZahgK7Er5iOfQyFtHcwix3Zu6
	 xfXlbau9hhrGw==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/mm_init: don't overlap NORMAL and MOVABLE zones with kernelcore=mirror
Date: Thu, 25 Jun 2026 10:39:39 +0300
Message-ID: <20260625073941.145014-2-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260625073941.145014-1-rppt@kernel.org>
References: <20260625073941.145014-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CA69B4000D
X-Stat-Signature: wpbiyeqemf6upx54ayc4o9csmptodp6j
X-HE-Tag: 1782373191-262899
X-HE-Meta: U2FsdGVkX18kStI1GCw2B+l+JcZFqTEY381X8n4VfjWjuCP6DWINPnokKjdPda85ZiLUrohJFiUz9p8JHuwkZai53Zrf9WgAfWgt5Atz0wh1Ac86uYPUyyLjGy9JI5l+nYCn1XntrZDjcRHa3tqWBrVMxBvy9IsDJkKNGj9jKqJJyZWA1+DNJhJulY7wKpIznuvHBMbNKkfKYXUEk7dnoMzOSZO3b64e78YRdNVtELnji16Q/ZJG5SMxZZgd3emUBfnUVa+T5UZbX62WOAoXzc5m4vk2IejFWYXTafaYfNs3bcFn3saL3+MbrvyILYQUdSUniUt/j1bZRTStj0+wdDDWY/ScA/dhDbzBXpJgqgC2yhE7nJsQc61fhntktIVfaEdb28Xam/MGDlKz6tA5KMa+6ifIbH5vkcztbzIxypsmYTdhE+ou2VGfP0hzZB3ni+gJ3uc2BxBrf2h6lSf1KL+oHU+PuPA2sAvcdaVL7/YgUb5Hf/4dnyFa+AS3FYAPqWjrjyFhtWPCevFiX2WtNuJYEhFDNZOSI0XmYeiqUpoV/aWVX7GiDeWcq6pwALPj5t2ngC9WIfoM9o+H3dQhPYpo9AO3zkBfHiBUQW4/qWksKMkkIlc7l/8aRlMu6tGPS4GW2WV9nqz8w5myCu1PxY9ONg+hKfqDAHYHQGTEw6Axaj+L49PTrD6+SlHjyf5m81R0zGOzL1A8o9NI4v9SiZ0l8ytX6siCfyf6+m2OxLIVg5IFQ5Mz+/gvJ8DGqthJuGGXZEi5A+Vc/UTG4iy3dhFFMJB/bA+fRCdyy3qARibeeePOH3aZz56CEsa8H7j7R8likIfUo6MCCkgHaEJhq0+QZaR3k/O8tkNCUUdl6nSh+YYp1/gdMoe6+FpXsquXXIGXAwqF0TNZ9blyrTKly+vln9mCErBHUveiehy89gfvL20pbnU+DsdMjBs46j9HXl9V6GnI+aHDNkkMuL3
 mbpEMyOT
 8KP8qZ7Fccqm7fBoeSNa0fbW77Z2uZHBx/pXBf6Nkr6cZ+IXDXyMfbRFS40o8J/O1V1jEvaoenlI6L8leZRK8A469r3+WWIaujM6UfB2Kwy1+oddIUNdN8Dvdimz8OHQxSpUYvCkocCTJOVbBq1pgrbo9DYNaTp915ihPLHOKFVRq3dFSLzNCcDB3M8fdEWCK9cipCahJahSQGj8yOEQJOMSZGPRbw0G9cClYwoazRFG5mFFiNsyW+x2+++tmk8rVTW3D+o/xUixvk9ZQdg5ZblWkbKzaTwRhYcw6vJj0o/8W1XrRUmRSq2VwTMxyEeS88lB/BxMz/rRYS+DKPNfZwm8MTfeCmtpGUQXEZp5Qu5xNHknsP41Q7GNzDZKytisUaX81
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When kernelcore or movablecore kernel parameters define size of the
NORMAL and MOVABLE zones as percents of the total memory or by absolute
value, ZONE_NORMAL is clamped at the beginning of ZONE_MOVABLE.

However, when kernelcore=mirror the ZONE_NORMAL span is not changed but
rather pages from ZONE_MOVABLE counted as absent in ZONE_NORMAL.

Make the behaviour of kernelcore= parameter uniform and treat mirror
just as another way to size the zones.

Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..dce9dc9f2302 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1159,9 +1159,8 @@ static void __init adjust_zone_range_for_zone_movable(int nid,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
 		/* Adjust for ZONE_MOVABLE starting within this range */
-		} else if (!mirrored_kernelcore &&
-			*zone_start_pfn < zone_movable_pfn[nid] &&
-			*zone_end_pfn > zone_movable_pfn[nid]) {
+		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
+			   *zone_end_pfn > zone_movable_pfn[nid]) {
 			*zone_end_pfn = zone_movable_pfn[nid];
 
 		/* Check if this whole range is within ZONE_MOVABLE */
@@ -1209,40 +1208,11 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
 					unsigned long zone_start_pfn,
 					unsigned long zone_end_pfn)
 {
-	unsigned long nr_absent;
-
 	/* zone is empty, we don't have any absent pages */
 	if (zone_start_pfn == zone_end_pfn)
 		return 0;
 
-	nr_absent = __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-
-	/*
-	 * ZONE_MOVABLE handling.
-	 * Treat pages to be ZONE_MOVABLE in ZONE_NORMAL as absent pages
-	 * and vice versa.
-	 */
-	if (mirrored_kernelcore && zone_movable_pfn[nid]) {
-		unsigned long start_pfn, end_pfn;
-		struct memblock_region *r;
-
-		for_each_mem_region(r) {
-			start_pfn = clamp(memblock_region_memory_base_pfn(r),
-					  zone_start_pfn, zone_end_pfn);
-			end_pfn = clamp(memblock_region_memory_end_pfn(r),
-					zone_start_pfn, zone_end_pfn);
-
-			if (zone_type == ZONE_MOVABLE &&
-			    memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-
-			if (zone_type == ZONE_NORMAL &&
-			    !memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
-		}
-	}
-
-	return nr_absent;
+	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
 }
 
 /*
-- 
2.53.0


