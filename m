Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C29C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 08:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE47E6B0155; Thu, 23 Jul 2026 04:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47426B0157; Thu, 23 Jul 2026 04:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E386B0158; Thu, 23 Jul 2026 04:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A66CF6B0155
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:45:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19597A0425
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:58 +0000 (UTC)
X-FDA: 85019408796.17.2DF0C3D
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9192A1C000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Slp45kXG;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784796356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bB5nbXzOEEQWRYmh1v50F16YhcXrxa7ul/dckHOhha4=;
	b=GJexK2Vmjc4kii7Qh4MELrnFtQQygggegtQYdhxdhLq/1Kg8IipH9n1r4wDOZ133nfhSh+
	4LT2w913Sqiq5SpMWth8dV5i/ItmdRo+z5blXA4jMVbPTM0DHfeGVZqhnXXUBaL1GShIhT
	h1eWFzSTjmzAD4xms6S8OcmFZooGWjs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784796356;
	b=DBlW1wgdvr5/WSdJj64n8/ghm/V3A4XZAcOQu8hzYIjbQtbdvPJjaENxCP94y6DFV9hxge
	C1kAXVcNvOjIHcEzOynzfB8GK8JHmA6IBt9ZXi03hiq1TPLGRC1C4ccasQd3YAGAVG0t/Z
	y6xh11IyaPaZuX9CgLWuV/HCgwj9dS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Slp45kXG;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784796356; x=1816332356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7rbY+wmZoNdck+weN1iewQCGpYuqzUNthhhl13Abfnc=;
  b=Slp45kXGTl5xpTpJI7QjDpEcPCKiPdxuovtQ+skDsflWc8T80842V2l+
   9FMWYtGmqlD6/EHJRm2BB4HRY9WyWa9ZjxvZS4Tg2sASvX6RS6MSouX5r
   M59ciCTocXSjZGfYvOMrn6xMUFFIdKFp8luSLfjni2ZNUbvs4R/fCFpYQ
   kcblU9dU4iVilni1hwteKcQRs51kBOAMnlZgDiAYDIiabp8xvrKY3RSoP
   ScSeKRUEAIgWaZZnBXBSFohFsZPAD/c2zpVAkZJMBJYavYq7CW+WhyQFH
   yuihpKfJM9dZeDkvCFPZ6yqVUbIECuZO8uJjOgAzR6Yc8ah8U/TqlFzVX
   g==;
X-CSE-ConnectionGUID: L9eXbrXGSFSJtwbavkUwig==
X-CSE-MsgGUID: vzsC8KwATb2l9smUVKLJtQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="72986449"
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="72986449"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 01:45:54 -0700
X-CSE-ConnectionGUID: FUhMTWgORFmJguJuC3tvsA==
X-CSE-MsgGUID: ID6ghIrQTSmIBXZJFQdXXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,180,1779174000"; 
   d="scan'208";a="254966703"
Received: from spr10.sh.intel.com (HELO localhost) ([10.239.23.75])
  by fmviesa007.fm.intel.com with ESMTP; 23 Jul 2026 01:45:52 -0700
From: Yuan Liu <yuan1.liu@intel.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span() subsection boundary checks
Date: Thu, 23 Jul 2026 04:49:46 -0400
Message-ID: <20260723084946.189392-3-yuan1.liu@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723084946.189392-1-yuan1.liu@intel.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9192A1C000A
X-Stat-Signature: 57czuaaj6pj34nkcu6hqd6fqqe3pch36
X-Rspam-User: 
X-HE-Tag: 1784796355-780983
X-HE-Meta: U2FsdGVkX1+XfCjGV7mLrS8H8c3atKO7+dCW+mo4s1a+zlNsYHatGIY1fQwdZZ9g69Lsu/039jVzeJgq6eiv5+R2PN8zLgtaqRMkF1bDe7D7WuXO2t8ZKufm7PXzNDYq7GoL4Hjh6OSRZp4/ccfLjex0CZTn3OaedM+/GpoS0eejwSQHtLbdkHTo22DaCHxVZcRfrsSOQvBW2rr3Govp9C/rfN9mZpGcwzbH8mwEhWUQsCRPLwCCDmHEzBWW7ctLKsAEzj/omkisuWM5TlQYaAL1wsI/rgS3pm9Hxkx31y0ReRoBH93WEpj9+jsOwPn2q2gHypgAPmkE4zjRFEJ+E2ouQBw4uIvbjjA0+TD/br9cLe1JCDz4K3HLXuCkameY3ed4zeJnG3rUlpAhg9tvqSpyw3Ba88q9slQEEKEtRjNIKIz/MGbFm9KUR4uG1+MErA8LxTX3QIJiTBBabsxqVTGw6HOX7QFisATZ6OVtYm1EbOLtjA7SJNIleUqD5h2Ye+vd5n3Zk01/QkovdvaMWNSFRqN7jQkMCvAoMpqY+01/W3iOpYLWLl6A1cRyiwG7Dqo50vgCFJo83ToRmWricZAGMP2RRa2AarCg0i4RM4c9nScoPV8FoJb8Zn+4vbVdaJLakYpuZbK7jnBnEL8wAHIOX4uhbEkfxoZNOIx1TDwjBJ1Tm7UsGtihSg6T2HTtkRCGOm/4D+tPmcj6ixJ3Alh/25QORBLFz+X05Y0U1Y1RYsqqTazfojkD1tfa8bUQ0KZRqycZ3jqprzK+ynrVU0Tyt3WbpdkOngcwpkruuKk7ScQ0UzxJgMDhrNMvQP/z4axgI1PK/NpIVg/0jFxNAOxbNJUsPZlRFsRh3nxGNg1za1lBIwAmLx4RERxHkFx4hPERColiV7lTwrcVz+ej0w6nXV35WtscReisY+yu+tvKdDjcSSMpc6skV1NOrfEAO7ikOC6avh60NsZNSYv
 h+Lea7hL
 IqFX7ogDuyNwzfx6Rs9BDLXsRXl5SmNURP1cGmXUCwIIT1zHFvjU1oQq607oPPy2NbmrEsEw1r1kuwQ30VfGx9bRmTrWB21Xg3qRwaC8iD8Rxq5wnGDrbBF5Szvc9BjE7nHJUAwZViqpQPDtCyTWGr8e24Fgr/6rpIRiY5c0lwLMfHzaXs6MJziQLDaD+iRllKwK0U8OrgVRXrcXtnuDozeW/OSSMAIgsJvbUIw4pA/Qnz0Itjd5jrF02PNeYzS8ijCTJeFToxd37db/wkfGYDj/gQ1uSn3axbgzFkJUf/VwRAJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When shrinking a zone span after removing a PFN range,
find_smallest_section_pfn() and find_biggest_section_pfn()
only checked one edge PFN in each subsection for nid/zone matching.

If a memory or hole boundary falls in the middle of a subsection,
that edge PFN may belong to a different nid/zone, causing the helpers
to miss a valid PFN within that subsection.

Fix this by checking both subsection edge PFNs for nid/zone matching.
Keep a single pfn_to_online_page() check per subsection, since online
state is the same for all PFNs in a subsection.

Reviewed-by: Jason Zeng <jason.zeng@intel.com>
Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
---
 mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 4c699fd9c479..3a281d595207 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
 				     unsigned long start_pfn,
 				     unsigned long end_pfn)
 {
-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(start_pfn)))
-			continue;
+	unsigned long next_pfn;
 
-		if (unlikely(pfn_to_nid(start_pfn) != nid))
-			continue;
+	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
+		unsigned long tail_pfn;
 
-		if (zone != page_zone(pfn_to_page(start_pfn)))
+		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
+		tail_pfn = next_pfn - 1;
+
+		if (unlikely(!pfn_to_online_page(start_pfn)))
 			continue;
 
-		return start_pfn;
+		if (likely(pfn_to_nid(start_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(start_pfn)))
+			return start_pfn;
+
+		if (likely(pfn_to_nid(tail_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(tail_pfn)))
+			return start_pfn;
 	}
 
 	return 0;
@@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
 				    unsigned long start_pfn,
 				    unsigned long end_pfn)
 {
-	unsigned long pfn;
+	unsigned long pfn, prev_pfn;
 
 	/* pfn is the end pfn of a memory section. */
 	pfn = end_pfn - 1;
-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
-		if (unlikely(!pfn_to_online_page(pfn)))
-			continue;
+	for (; pfn >= start_pfn; pfn = prev_pfn) {
+		unsigned long head_pfn;
 
-		if (unlikely(pfn_to_nid(pfn) != nid))
-			continue;
+		prev_pfn = pfn - PAGES_PER_SUBSECTION;
+		head_pfn = prev_pfn + 1;
 
-		if (zone != page_zone(pfn_to_page(pfn)))
+		if (unlikely(!pfn_to_online_page(pfn)))
 			continue;
 
-		return pfn;
+		if (likely(pfn_to_nid(pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(pfn)))
+			return pfn;
+
+		if (likely(pfn_to_nid(head_pfn) == nid) &&
+		    zone == page_zone(pfn_to_page(head_pfn)))
+			return pfn;
 	}
 
 	return 0;
-- 
2.47.3


