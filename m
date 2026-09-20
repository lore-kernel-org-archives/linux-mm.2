Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE705C982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 08:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9115C6B008C; Sun, 20 Sep 2026 04:46:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D756B0093; Sun, 20 Sep 2026 04:46:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3746B0092; Sun, 20 Sep 2026 04:46:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A22E6B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 04:46:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 899A81C26F2
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:46:31 +0000 (UTC)
X-FDA: 85233509382.08.A9B4008
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33285C0003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:46:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=krfdrHso;
	spf=pass (imf10.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789893989;
	b=4Y7hTlOo4Tk0HtjlA6tDeCs7OTqI7IE5ZbjdzTjJR/LEaQBZtK1K2531R+hhFqOo30uacn
	pmEMqjiWLYogxT6GOKN2xXJTgxrJmR/aEaCGYbI2aaARjrEu+mRum52eQlHK4XTdKTVmNC
	M+khW3PRJykk5dee5Rhx4DSeLNwEZeM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=krfdrHso;
	spf=pass (imf10.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789893989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8f/7efMiC6ft/Zrjv2n+Em6z0opx8zWnbRPBMtnAXTM=;
	b=nbZmDGvilCCGGDSPZuiX8630cshyjp7GLph1s+VxQzc4zRBB3iaWJG9eDctggwGo9NyKL+
	UDY9czzH1U/Ks3Ljd9N3UAWs7Vv0OPEL5kymVOUa+h5Q8B2dP/MEYw/bdJba7Zngg32Q9d
	NcHqYL3MCaaiEKcpPP1wnOWBxc3pKxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789893989; x=1821429989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HAcgfKHkNgLlXaIqIJX2qqZ64BIXaJH3XvIA/CZsUSI=;
  b=krfdrHso335js07b9S0q/BYAaTbRjQVwh4Ob5zBEgexhMGOe/7Jz87k3
   PKE24yrj8H0uQDBOn6r+uP3AXhaI+3i5VNgCvjVBUxhdH81vzE3cgDoF0
   iYxEuGaHPWV/K3je9rQcZXkTI1nF2Z/X5UR5dW5UVjF7zEcfl7Fb8u1ta
   nEFSQpGJiNYOozgLiD4GJ68txyMT4AvYik1/RXxfK+5oJv4lQPrI9Ylv1
   8jvmwm893DdhIQFUejwSi1eYUwSmHyd9hzg22JVYQZzYtQAXyYnzqOl/N
   SkZcJezbCu22LpnWU1ugUsbEsCdJ5kU0+FGBdI5dzk6rTqtFF66o1U5+z
   A==;
X-CSE-ConnectionGUID: 4fJjBk0bTvWB/eMmMjOyow==
X-CSE-MsgGUID: e3i5n/wNSRWu8YU9pBcJEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="77968082"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="77968082"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2026 01:46:28 -0700
X-CSE-ConnectionGUID: IQ8rWYG7SHOHwwNte+lCjQ==
X-CSE-MsgGUID: 4/rIdET0QGuGZFjtqW9S+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="3543410"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa013.fm.intel.com with ESMTP; 20 Sep 2026 01:46:25 -0700
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
Subject: [PATCH v10 1/2] mm/memory_hotplug: make shrink_zone_span() more robust
Date: Sun, 20 Sep 2026 04:49:45 -0400
Message-ID: <20260920084946.3266279-2-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920084946.3266279-1-yuan1.liu@intel.com>
References: <20260920084946.3266279-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33285C0003
X-Stat-Signature: 84ufj16b7emrizt5rhwjqyk171cqd1sp
X-HE-Tag: 1789893989-689361
X-HE-Meta: U2FsdGVkX18dpjxBmk1+HCVoAy0WyDO46pnq2N6yUfMe/pmHF++HjXkqOvFsRaWU8yc/JdoWb8pU+U7WZtqcv6uIOA8UPQ33ti+rjDYBi+SDcBGELEz3ApeZBkDhYZLOmc05P7inKlgK5/b/6NA04rcNXSEEoKGNLjEdtxljq/3CibSBAvS4FmRvu57tpH2nYnXvCfBbJJ24dAyXjnjzCQxNnohpu7D5kA8uI4w6MF26qKFWYvF/jt08xkBt9Q+MzjDZsRZfiukOqJlw20trhkDagRfzN3pBpSpscFoj0eRbzFVepsQkeN0AwFWY4CmMwlzyQ2R4M6qZOgADH3xCd1kDITHNVzLjo1l6SZgr1OL9vhUcyO1CKY6/6At15i2nHRSuCetVK13Aoo9IVCpxKXzVJDBq8Po3s35uOfBrACsKcekLzm6y5CJhT3zO/lZg0mVMNv9H8DyCX3Uzp35p6gUJfzBVBa3e9Prf6sQUx6hpC1BL8IYLmfX1Zl5UIXhlIKn8Sy0yyux9hUo8z4WGmgNYwrgLKjM753r4sGSPlKIUmAX8m3UdgKq6RiSMfdZcWbwwqx3eM5EE31D+b57m0sK+uWATJSKWFfe8+VvworQtoDe5w0kiDXIPl0Wj1U/DI7hnLo5rQZ2XMHLUyUW8+f7YpflAKmB/v/3wE18YmpF5K2z989/+ukoPZjTZZ4alrXXJ/Rbuujw9dKASI7Rj9B0jfq3JBpJXTZ+tvLqWsAE09a4S5CXvpXNnyx/SDtkCsPSUe34uzEdLxFxZwt4OQb63HubAjsKUL6WOZjNQhHthAyFJOUXGdt0+JYB2LrW1IWzw8pkj4XktSfavm6yQT59tU1f7MTGkTi9ct0UdQ91CeKP9lkHcOis2vRhtRYMiK5ppIIg2b91mB+uW003CzxYz6vYr1OLF38RRg93af89xRWLFP9mQ+ZlzWowu/9ZKKF9keHs0h8efoU5YTKT
 NiWpjLJP
 2MinUNY1p5dYzbTzm0CUKujyBmea00ZaqEY71pNL/bEL1WBZ0w+OmxpzMTTgZRapeCRnKD38sj6c0a0dP5r8hxRo8GBkTWNh14EGQsGP04a8xq9wO9y7nu0X7lcjUYU44dLbuAhRVjySEMG8dgS0iLmr1mnOV5KAAJb+yryqonx2h3rFOv6H5Hp+lWd+nKlEwJqmyc0n2VKXziGNBiXio0w3T4wlLHuPPMXvn5fzl8H+v/+QFmc3QI4eI5yt5fqcGc0koxETFVz1AU7rcL5imAuPQtFTLgosjlxiqsJLcVgdz7cV617DeR44maQFQh1Mc6/RTgzYG1hghvaz2AgsssrLiI+MH9/nK4WxK
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


