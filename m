Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326A1C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7796B0095; Mon, 14 Sep 2026 03:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FD06B0096; Mon, 14 Sep 2026 03:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7F26B0098; Mon, 14 Sep 2026 03:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23FFA6B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:27:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54645C11ED
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:27:43 +0000 (UTC)
X-FDA: 85211538006.27.BF398C8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1886114000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:27:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WSr5DlDQ;
	spf=pass (imf23.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789370861;
	b=7HLxJF1HE2O9SbJmYTQX9jfrvE00au3fR/UN3KurysmvVTLNfWg1+YocoaWjeJ+hqDwtpY
	3b9tp2k+LBsusxqVfl1txm3lIzYnO9PNcxAI/NsBIieteEavhb3gC7jeoQiC1r0NL0QnYR
	mgl0V9jGhva91MXXm44cpnKUNOYb3ls=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=WSr5DlDQ;
	spf=pass (imf23.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789370861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8f/7efMiC6ft/Zrjv2n+Em6z0opx8zWnbRPBMtnAXTM=;
	b=Y7zybRGKC5FHU5V3V+oP7trmJNqFlv1ccG7yg32hX1wjgD7uavZYNmFyXcDWmYixPBe/fH
	/JwAAv7NUZu3ZQSuiqdS5/q2u2k+zZC/hkvq4hplEiOTKxXIBcaJXO+2SSAO2+/wpPbB9P
	P5nDItJGOCHw2Zy6NiSlXiaA0C4/5eM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789370861; x=1820906861;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAcgfKHkNgLlXaIqIJX2qqZ64BIXaJH3XvIA/CZsUSI=;
  b=WSr5DlDQl+4PewdZAaJzegXGEJK+ITgJ2ZT1YbvK9RtCz3ENm8X8GfOe
   CH04S6yOz4RwC5PHnyzj1VkGNgL9nQe5JfnF/HmoE+Dn8jANsAWkfHEi5
   PltzvzSUCOu6l5OyMI9GCVgbLRm7AVZt8Dcy81MasyG1hDXmvIe5N6zR7
   zw4BZPvkw40/30hEhtZaQmLVuYM5nAxMBWRfQuwmE2Qhi7VhwizunVxls
   5DKvAmR7yejNTgJUAZ7nBGbyE47D7g9fHB45Dvs41iSpSPAmr+qX0NvL2
   XxvAM31DztmuvcHuzGxP1I4p9x5yBkVWije4+XQl7UFJ3ggyUgK8Sdd2c
   w==;
X-CSE-ConnectionGUID: dWvkC699TRy0pj9/ycRlxw==
X-CSE-MsgGUID: epaUFu/HR7605mn+NgkbnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11904"; a="100314902"
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="100314902"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 00:27:39 -0700
X-CSE-ConnectionGUID: 9fWNmxtXT+O4SVTqoSzkmA==
X-CSE-MsgGUID: +moyawqkRKSX0CZQCNdHZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,102,1787036400"; 
   d="scan'208";a="271152822"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by orviesa010.jf.intel.com with ESMTP; 14 Sep 2026 00:26:05 -0700
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
Subject: [PATCH v9 1/2] mm/memory_hotplug: make shrink_zone_span() more robust
Date: Mon, 14 Sep 2026 03:29:28 -0400
Message-ID: <20260914072929.1883794-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914072929.1883794-1-yuan1.liu@intel.com>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1886114000A
X-Rspam-User: 
X-Stat-Signature: 5qnw8tk3w6i6ztyo9rnun9cncse14mf7
X-HE-Tag: 1789370860-547111
X-HE-Meta: U2FsdGVkX18B++XgnUl/HjCBVM1KlQKGk6Ook7hSh4NKwA8Tx/H9L8kJqWnSK3zrT4Lgi82UturauRi4Tpl2rRhhuhEijFf4COwvErqajsbxmOQs2wt1O/AYfaebI/yZdfWs+sOIgIjS/lGZYLmyX0VwPNHjOdQOof3BkkF3p0Vhsb7lpKMHe633b92mXZ00r4lNIVuvUlBT0jRDB+bk7K8Ag2bCvVkUt9f8HXRA4HzZVnHz9ARgZuFVElqUNfRLMiP9dzJyuDe4MKjFlT98tPnaAg5drNXKDoc6jkMpZObR5EkqbY6pF4NCyyukXUXocQxgT1mm6ye0QIVILorM6fZuY05ggmVyFYI7feD0Gu3Qtp/3ULj/g4YOiI2I5qyKEIcNilSwYIxPNbwauB73VDeaTkcEfJhJY29ZsPUP4zSzkd0Z1HM8qbPwvWWL7mpcyQbFC0mfkEr1LZAcBKtC34yqb9cScveCk5kLbjYSLIF+m51TXiL2XyJA5JnL7pu5jsZ9ZMx0VoCc5kCnyqixmzUos8wAZt+b6ZBYkP5VqDIXYDvZfIJo7KccXcFQuU17OFSVbVSLeD4Nr3y4xcwAP7DtGZyBb4xIN//siHOZzW14s5iKm5LONr3eY4PI536sa/SfRw5WEzZxNEIW1JuGQ0WhRknVZ7tx5foUHVS1pwRMNwJ1acdJu4iacvxBr4bBbMgPfHgLIuZu5YN222Ht1BdtFMNDhmTBnacEq28QEHczsrS7a5TXjhU5dvVfsRWkpjxOJutXolfqy7GYBaUaORgMUiJ77kvCzPo3J+cGVQ7qg2VBNQCH/fi7lpADefSQEwGNBNhscd6F6eR6SILTTLFWjndCJnxFqQC+uWJNARMIstcf0LnVYIA4Qruino3KQWSnhU/6WxIfblQKvr+S133q6dUtwjRNe66vDYL4WduZsiebx3TBP0w41JZ/v3DsZvCpzcO0U+Seuk0uei6
 9Mj4xGK/
 c1izl09bCsPBlXmaQNpOv7KpPnPpMWIBBPfGXnAKVktpwQwVSraZm8P2xlzJ4RgRGU+cjJ5+fiOpem4U/53cJJTOlj62ZZ7UN0Q/qn1cs/fBZwKvBhbW0Ex7g4+0seyAmveI2QHxpibugy4NNCesouo9pzUEiRBidTqgXrLsk3kemMCEMYJNNul68FHQydcdMpDSKIjiWkNXa9QC59Vw+lSHRAkJ4h+PG1mO/GJBbF8QJJOsnVj084zSt6F8QSmf3C61hNdhbl7AhXdLeUysBvCLcKAyAX/PqbIerpbBcJfmORgYIwraHZJbIBaWZwbrgJ3ItwE1k456K45zPZrR17SitLVOirH1tJkm3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Arm)" <david@kernel.org>

Let's make shrink_zone_span() more robust by checking in
find_smallest_section_pfn() / find_biggest_section_pfn() that the
start or end PFN of the subsection is within the zone.

While at it, clean up the function by factoring the core check out
into subsection_overlaps_zone().

There likely is no need to check the nid first. We require
SPARSEMEM_VMEMMAP_ENABLE, where pfn_to_page() is cheap, and
pfn_to_nid() on CONFIG_NUMA would call pfn_to_page() either way.
So let's just drop that for now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Yuan Liu <yuan1.liu@intel.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
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


