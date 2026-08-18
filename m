Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D69FC5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 08:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D8EB6B015F; Tue, 18 Aug 2026 04:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888DA6B0160; Tue, 18 Aug 2026 04:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7787A6B0161; Tue, 18 Aug 2026 04:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 557556B015F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 04:53:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB3BCA0B79
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:28 +0000 (UTC)
X-FDA: 85113776496.27.7C2CBC1
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf13.hostedemail.com (Postfix) with ESMTP id 203CD20006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:53:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jQNrtuX6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787043206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3DcRzi7VZE0LI60741vC8TAW/5PoAYt9yOXIYYjF8s=;
	b=t0h39LE8UgGeLXviM4Srj7aZgMQMvml07tbx7zhn91r8GD7ySagJVErPFwr2mN3AzRNcre
	baw/dK2IGHZpU8Q6xAUXwPRa+XYPedSJJLLCifSc8w/ImT090hHht959L00T5/bqvdfCAz
	wrV/2NND2I6T3Xt32YjI4uFvtxSFZ+Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jQNrtuX6;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf13.hostedemail.com: domain of yuan1.liu@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787043206;
	b=mUItZAWocwCdmPSa/xpwLgjXpdSyoV8RFzalkN/GarNCs3NMvLexiuhFKBNTFjHX8PPVOM
	+fh1rX3+W2HtdN2Q/bLhBwR7ky1mB5iMZlZ/jakg5l2SQ4ilzUA0nf6qkqT2QM1eg1JfcE
	CH9XHcmRhVvwpImkk2PBbE2fSMIvxME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787043206; x=1818579206;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=49j4fxstgTRL5iumzWsULPLrhk82aBqfzo4vGvGaiyg=;
  b=jQNrtuX6QZ0kinpNNu5XD+xZaws+cI0jMoLZxA84QWOHBLzPEp1YNN/D
   PkfhbDOCNRjzW4CmX+eyoBlY2ucYWACzf1xkuviG+rg0z3zbjZXIUI5CO
   ntUKqBKuqY8vfysPJYoWWmLDR1aInLbRvWte04bnSgqUHAzGQKI5JQLg1
   vhLKHzBTZR1ml6yVuV1GHuBY574m8j/OfgDYIwY7Grbp7BQolzS0CdcHr
   2jKrG3A0KyI6b8PX2eNgcfOMWXYf62n7eXjPOFshTugjeuBV2h8n7SMXq
   z+/d7K6BHKhJ+hQryLiUc8aNNqRpNijFXeIeMJtNLp9icu7Q5ucrAiKWC
   g==;
X-CSE-ConnectionGUID: ZSBV3XRYQrSGHmJpEmSwjA==
X-CSE-MsgGUID: +MG8FVPwQRi7k/yPzCbVJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87292222"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87292222"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 01:53:25 -0700
X-CSE-ConnectionGUID: DTsgAjWrQmG36uO08YDwbA==
X-CSE-MsgGUID: F31xNNF9Sxq373JezwsqPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="262539338"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa008.fm.intel.com with ESMTP; 18 Aug 2026 01:53:21 -0700
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
Subject: [PATCH v7 1/2] mm/memory_hotplug: make shrink_zone_span() more robust
Date: Tue, 18 Aug 2026 04:57:01 -0400
Message-ID: <20260818085702.3395529-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260818085702.3395529-1-yuan1.liu@intel.com>
References: <20260818085702.3395529-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mjxyysypfw7e6kk1hparddh6ctda6doy
X-Rspamd-Queue-Id: 203CD20006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787043205-271329
X-HE-Meta: U2FsdGVkX1+Xq7CTQCwj2j0qREHuRh8smtwpOtAmKQ05NfBbwFdwXqfAC1O5n9V6dBQA0DEuLknhukSiZa2sC4woiTRE1OfzXBbYtKQFEbbjskHyCyeZtqQfSgbEQcDM1SbT/sHy2CGap2/Ze0J8/ck8/9jm9I5Tm6eNbuaEuzVn2plSNITNGB3JYUa5dBqikVIQXCH8p/vA0DdTMVdEsuWa2ga+pNnaU83KG4hC8wStHr7A5RgPb0EU2yTui0JBB6Sdcrlu4QRhQkRVaju0mLx2tQbDBY8gIkr8whp7sBcuSob2WpLSsuoS3v35QjxEgcWKYQhBfRvIcom3CQ9K3g5Ocbt+yQ7E+s+4U9VDGAanIGB2lW8BGNggiOLVQyffhK0EvnCjU+KOGFzbEQy/V8EQ3HqJXhsrFXQFrfzxaoi5m1meUrAs7OgW6rdPfgwkfDtOuNzQPlIDI30gaIFLsb2naj3+g6w9rtUWi4YInOL4VljvMAtWKaqUrcR3NkGB+mQTrxLYj+U07EAx3ACbGG8a3tZNZ1+YdDcS88H1dhiUKkywYklrWsRUwwxoGs1fFs0ClbkQm9eJmszUf39/+69TXEetr848uME0k+g5rO+EfItvhtSIYL5YA7wdqHxUNPyzuGgHmMgP3E7qsfTlcVpdw77qWfb8ZBBjSoEfekbKBEbFHy0vyU+dSefhZxlYfpirIpLuY17wjZqy1Oboetnsh0m0gd2X668IOC+da90eZHVbS+kQkQhV015/MkTzMW7QNk6feZeVFJ4C6TCEw5d8PQwCb7vthaaVHZHraL/n0I59JsgmWrV5Cuoe6L02Rl1nmm75YyCkmYo9cnpieEa6keFHvlZgKLJjPcckzFgaRuQyLw/YLZoM2BEdVP17lC3Wiukq7qGno1pdoof1lBFp9mXswUbzLo0TPaxc/UnYMo17xQyh6/w3NOBxCyBVB8iw4aJPhzc/YPT5KQL
 z+LDzhLc
 DX6kWSau/cPDgLjxFv227MwucalfWagKRqOKytaOn+mxssm191lOrszHTjIyybvSRxMyaqJi2sqrbqxY4cY3dO3qFWeFpa7UHrTO4uiDliVUjRHNuTy/4YBr1OxT+KtTXAtneT+iqAIYtQXoz8J8QfGfTuibEIZexhiB7BY/oYRCxeTolGAifD2bmvXNLSLPbvledpAKWe7mT2lPU2XgHP3xBA4drdtciZ7Q9K7U9WESA1EB3XdA3U+fiJ1i73mUIelUMjGzFV6xbA389p4k7uC2ipKokED0oQTNWc+xVHkstH4hAgclD7222wWYjrNGcs2Yj
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
index 7ac19fab2263..cd82e79f0782 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -422,49 +422,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
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
+	for (; end_pfn >= start_pfn; end_pfn -= PAGES_PER_SUBSECTION) {
+		if (subsection_overlaps_zone(end_pfn - 1, zone))
+			return end_pfn - 1;
 	}
-
 	return 0;
 }
 
@@ -472,7 +462,6 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 			     unsigned long end_pfn)
 {
 	unsigned long pfn;
-	int nid = zone_to_nid(zone);
 
 	if (zone->zone_start_pfn == start_pfn) {
 		/*
@@ -481,7 +470,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
 		 * In this case, we find second smallest valid mem_section
 		 * for shrinking zone.
 		 */
-		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
+		pfn = find_smallest_section_pfn(zone, end_pfn,
 						zone_end_pfn(zone));
 		if (pfn) {
 			zone->spanned_pages = zone_end_pfn(zone) - pfn;
@@ -497,7 +486,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
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


