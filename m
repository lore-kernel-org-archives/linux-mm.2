Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50405C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633576B00BB; Tue,  1 Sep 2026 01:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A026B00BC; Tue,  1 Sep 2026 01:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F91A6B00BD; Tue,  1 Sep 2026 01:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 219B26B00BB
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:26:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9ABE8120343
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:23 +0000 (UTC)
X-FDA: 85164057846.07.833763F
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf30.hostedemail.com (Postfix) with ESMTP id D64B580003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:26:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NbuKe9wE;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788240381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2324N8NqMJWCOuZoR6Mdo/PY58zFk3TdBkontOtLp6s=;
	b=ddzOKUpCEyxc5CKRsOY+G2n76Y3tfIdxyoI6sxX/I+FixrZF1emna8fOFexrNiurt13zUe
	YemcXBgo+Th3hspgSJhXKrTT4XLPl+gAGjlOtqjlCp6vNq0Ehjwd7kdV3cTPrkvN/Mtty6
	enV81y2prS022MBlVyGWmyCARHjQdc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788240381;
	b=RdDiXgI1VS0ToBLtTfEyV4q7nVqX6UXpGyUr1yb1BMoW4mFi2J7vDTjkrdnkk124v0r76J
	Cj4n+d+HEKeJUNngtRhwfDV22Hf8WE3sTDcLff3uRG2Qp8Aur6/kUgJMw88be7DV+4TY46
	A9PHONusf1dLXmtYVE466hjY+ZgnsHU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NbuKe9wE;
	spf=pass (imf30.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788240381; x=1819776381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LC+ES9Zs+P62Cj43NmP5rnYbecoNxXcSCIKuWyYw+ws=;
  b=NbuKe9wELUk+vw7Nr9XOpU18gJk4Q0v9k0+5gqJFoUBnox282C6EnPu1
   kSA4tUUz6UvkRQdGlOfZMwj0OVqSAItZrLnplW0/aVoF9dC8sk6Bj+vCY
   3+AMlC252qRgvklDyvjkXPABz71BGNAkJRIqK1/WfftzbQAb3pCVDPSiY
   6mHl1om5xDTgBFWHSW5IKBTTjLaW+TXCyrX6qL9Kd6hwvABFAnPixHHt6
   ttBpF0L28Yt4cbw4UUU8VbtKEwOmIWfX7C/HYchdJ3GS5fEBO5tR0u/FN
   MfAo+UEMuBRjK6WyuMGgCHWXlnJuYmLsjyy93g6tHvYMhOCJ0XP/FPzTS
   Q==;
X-CSE-ConnectionGUID: hqpseNSjQq6ffPZSFx25Tw==
X-CSE-MsgGUID: 70ZDLn47Qg+zWEUE5q/KYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="106178886"
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="106178886"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 22:26:20 -0700
X-CSE-ConnectionGUID: sx7L6WB1ShKyXMiIStET/A==
X-CSE-MsgGUID: r5Qnre0GT9GQmfAOd0TZCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,255,1779174000"; 
   d="scan'208";a="292482084"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa002.fm.intel.com with ESMTP; 31 Aug 2026 22:26:17 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Jason Zeng <jason.zeng@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 1/2] mm/memory_hotplug: make shrink_zone_span() more robust
Date: Tue,  1 Sep 2026 01:29:49 -0400
Message-ID: <20260901052950.3284540-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901052950.3284540-1-yuan1.liu@intel.com>
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D64B580003
X-Stat-Signature: zg9dj5bb8n81p6gcwjhnbm74f7h76ci4
X-HE-Tag: 1788240380-607856
X-HE-Meta: U2FsdGVkX1/do9Xfbo6NhG4aTz4TygrJWNGEfHQ8Ue8a7gEyKQRlvrYYBE9h2iZ0WeXnayG/Hil9xHVXOVZJJ0H6jSncIZgjNAjrfeS+eYy7l1ZFaTf+bK7KI1oYPIABsaP01P5DYR6CoOI4/n8D19U5LzU3vcWNnpUhfhhTeLLspdeuIDUGIiw512gPRtxeAQhe0DTCK0YZQoONp61mBrdJe1GaU8e01L2QUvMyHBAw3HN1ZP5ZhqGGyacHlcOQ4D3dilfNEur+PrPdR05AnfhkIalPdbkUSrMXBI7jzbaCAYPt9lsK19h67TOtk5Dp9yqsv6BJZ6qN4phKWDBFad2PEd+0DK8s7d4JtdCbWDS/GZVdsw+D+O9ygH9P/6siK1X7J6gjJWKNuaEeS4TMvhaNVoN1/DKMfLn2NHxF/MgJsh0NLGHTgGa8Yz6Jm0F5tad5/3+aG7qkRGQHk/dtCRI2kxN+sf4qP4lVtTjsZULLQZ5sPfCIn+0J0PYzETzKUQvLckU8C9W/Bfia79OI/Kk1uw+TTCFLUnW7EZCM8wggQ69eue4Uyorx+WYPf/nb8z2C1lYSjLRaom7nsSlcOLQFvlSl3v8Gu9C5iFC6kt/YH97uLXQpFfxH9QC7P0GGO5nlKROBIBS8lCRgIDVGnIr1BHGfnggUGrueEbwtjG94kwIf1TvX543hBUX0Yt24f4Yjy8QoiLOn+aq+/Cf4Te+yls/EKhwvexIwrXZN1uXgcU0xg/oaxna2iOC1N5Z4Q8bTu7QPMrJ3DiVj4+fWIcUhO8qmGtLVtq0efnMn996C1tYJ+c4NWsP1ht92p8uoc4NRaH7sjzyicLynB+VYDiSfV3A6AJ1CDGgNveLM4sqZ40cOD7ubDFzpGtBXXadAPw3qCh9wd45RJJ8+LJuyNgCH4ErREHvlECQta2+sB1f/0gf2gxOU8FzEDO8JUsGJHZREEzp2Wg2jhFlF1UC
 slncMg3h
 S5jD/9iOf5L3ItV7VzHu4g4KCgCTPQWsXu/y4uqNYeb/l3gkmSthnNDyIcIMNuhWkbZk/hX5rIVH0pHF3VZS/DKS1KvciOyj/uLHzvtFfD9VFYJHaGapOF0cmM0NoAf7ylyqFaYhGx0aJa8CoCgPdsW3liIAZ1ZJm/+LxHHTAcXuIVmxj06f4b+5UuQl6dq0IoB8PMPw6vI0OnM99wYXgWMuoZMi9bDE7TjDz9ksJLOqNVMa8xAck9T12NQJzUdmJkWuQMNhpayDJHezzTQXyJgetjeav1O2jHsBsZAnO47CWBFkoJPI1shC9IzgaZHswISXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Let's make shrink_zone_span() more robust by checking in
find_smallest_section_pfn() / find_biggest_section_pfn() that the
start and end PFNs of the subsection are within the zone.

While at it, clean up the function by factoring the core check out
into subsection_overlaps_zone().

There likely is no need to check the nid first. We require
SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
So let's just drop that for now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Yuan Liu <yuan1.liu@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..9f19876ec3ec 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -425,49 +425,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 	return err;
 }
 
-/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
-static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
-				     unsigned long start_pfn,
-				     unsigned long end_pfn)
+static bool subsection_overlaps_zone(unsigned long pfn, struct zone *zone)
 {
-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(start_pfn)))
-			continue;
+	const unsigned long start_pfn = ALIGN_DOWN(pfn, PAGES_PER_SUBSECTION);
+	const unsigned long end_pfn = start_pfn + PAGES_PER_SUBSECTION - 1;
 
-		if (unlikely(pfn_to_nid(start_pfn) != nid))
-			continue;
+	/* All pages in a subsection are either online or offline. */
+	if (unlikely(!pfn_to_online_page(start_pfn)))
+		return false;
 
-		if (zone != page_zone(pfn_to_page(start_pfn)))
-			continue;
+	/* Checking start+end is sufficient. */
+	return zone == page_zone(pfn_to_page(start_pfn)) ||
+	       zone == page_zone(pfn_to_page(end_pfn));
+}
 
-		return start_pfn;
+/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
+static unsigned long find_smallest_section_pfn(struct zone *zone,
+		unsigned long start_pfn, unsigned long end_pfn)
+{
+	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
+		if (subsection_overlaps_zone(start_pfn, zone))
+			return start_pfn;
 	}
-
 	return 0;
 }
 
 /* find the biggest valid pfn in the range [start_pfn, end_pfn). */
-static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
-				    unsigned long start_pfn,
-				    unsigned long end_pfn)
+static unsigned long find_biggest_section_pfn(struct zone *zone,
+		unsigned long start_pfn, unsigned long end_pfn)
 {
-	unsigned long pfn;
-
-	/* pfn is the end pfn of a memory section. */
-	pfn = end_pfn - 1;
-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(pfn)))
-			continue;
-
-		if (unlikely(pfn_to_nid(pfn) != nid))
-			continue;
-
-		if (zone != page_zone(pfn_to_page(pfn)))
-			continue;
-
-		return pfn;
+	for (; end_pfn > start_pfn; end_pfn -= PAGES_PER_SUBSECTION) {
+		if (subsection_overlaps_zone(end_pfn - 1, zone))
+			return end_pfn - 1;
 	}
-
 	return 0;
 }
 
@@ -475,7 +465,6 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
 	unsigned long pfn;
-	int nid = zone_to_nid(zone);
 
 	if (zone->zone_start_pfn == start_pfn) {
 		/*
@@ -484,7 +473,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		 * In this case, we find second smallest valid mem_section
 		 * for shrinking zone.
 		 */
-		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
+		pfn = find_smallest_section_pfn(zone, end_pfn,
 						zone_end_pfn(zone));
 		if (pfn) {
 			zone->spanned_pages = zone_end_pfn(zone) - pfn;
@@ -500,7 +489,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		 * In this case, we find second biggest valid mem_section for
 		 * shrinking zone.
 		 */
-		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
+		pfn = find_biggest_section_pfn(zone, zone->zone_start_pfn,
 					       start_pfn);
 		if (pfn)
 			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
-- 
2.47.3


