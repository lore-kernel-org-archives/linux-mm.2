Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005C3C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 022B56B008A; Wed,  5 Aug 2026 07:02:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3CEB6B0092; Wed,  5 Aug 2026 07:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07576B0093; Wed,  5 Aug 2026 07:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04DD6B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:02:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3EBDA40454
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:02:36 +0000 (UTC)
X-FDA: 85066927512.08.022E5F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 75A6914001A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:02:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a2OG/14D";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927754;
	b=35zgUxGKbq+YhV+VeZPuGRiflyJzPPJPLNCgqg6bJ9v80pZYhgBcJVqZs0YJli25H7KhMq
	duDtxUUO2mSKHpe4x8BowW1hPSHeQ/aJTHQqVh45e9Dl5cxtEGFCvyMVA6fIhGpPgdDPnO
	5jL5HyK5tbC6MCal91qFYxpfmzjFfxc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="a2OG/14D";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLxE5qUs1sNIGK998MMucs9/LacSHU2wxGh+jo5l8SM=;
	b=XAId6fkcc6RJgNdjL80cOclGIxJSK16w5tZuja8W4ESZe2AN/vqU3w76AP63ZT0aLv2WWV
	M/UgQ1tyuUfTlh8EtngKOpuCR6p7CVFCNC/PgTz8IaEvW88hE3VwwXtc+p7MFOKb+5iB/p
	yveuOOlQe55bBdPON7LBMfZzbsas8Rk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F13BF600AE;
	Wed,  5 Aug 2026 11:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DF11F000E9;
	Wed,  5 Aug 2026 11:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785927753;
	bh=pLxE5qUs1sNIGK998MMucs9/LacSHU2wxGh+jo5l8SM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a2OG/14DcRTRu37pq6vQtM+Ca5YodwL3Gyv6J3KV7GReTPPQt8gGM9X5001+xQez+
	 DZwzk2QdEBoKC3jm8wuAKv3soQp7qZsBGL3slKAZ/6dUi02loloY8JHFqdPzgPuGhO
	 iGM6z6Nk4I38djrfSrrZOZPZGwPOp0nSNfATLFzjyNb0+i0iWpeNGviGCdYUQL8K47
	 kBYntJmsXQuXce+u39g70sKihTaOor7Iu6V4UrRdhQ/mUMOto+w58TZb3kD/2d4bZi
	 r22qCVGF/vLWpB9Vx/6m5dw+JPy06gigeRpKtvQX87m1HqcPbQNl+vR230oy5thyK1
	 hW6YHUY9oCnIA==
Message-ID: <ff4fe959-c0e2-46f0-91d6-0839c90d62e8@kernel.org>
Date: Wed, 5 Aug 2026 13:02:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260723084946.189392-3-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 75A6914001A
X-Stat-Signature: 6mne3z1fctga6mz3oe35gwutso3i64fn
X-Rspam-User: 
X-HE-Tag: 1785927754-888512
X-HE-Meta: U2FsdGVkX18zpExxKJfxKioZflb0fjUczx/LMyoNZhn8CcZAYpcnMkV1R6FUtCJ3rbj8K59XDWEJfYqDYVW3ipn1LfWpKdES/Q1YkOqzgCuj2LJF2O1x3thSWB7ckyoPVp7IaO78E8Oe7PvVrUbrflAojXDktg4DPT2rdTPj571tkwUUFi2rRc18ZNFCrLVvLnF/bFDldm7Xykmxw/KAgwDhrVoZaaSsZUzZMswShOeYBNgUgPiTpQh0HVjQwhVTa5oPLSmTzl/Q1G9gaJbg5Pi4/P7aq2JWQksJG0q43BgLmeLJymeHgNO17oopJhRPqu4K4cXw61ddcXnPQisF7TcOFfi75XoQVosxpihHUuKfa619t+bJwIIOEKo2MxzpRHcGSSuTmhvNADODzm0Iw2rVqX3SrpV0qSgY6/0xk2Sj+Ub/9AqrDd7xomLapxsqJe3cPo1KiQVeqPrfRqa1R3Lp6Y8VFaXs+ypPD3VrGY2ZC+wM8HlPZOZ6A0DDSY/+8n0FtKbJtSebFHDOiaqp2hsYueXOdpXOga3EPEqhmIro12074vwTpZr/Fdz82dJRbACgiKaHraw70qcIcXo5N+hc+nXYyUup7kCCh6ZMylq4U8w2AeKUWegH4GG+DG+vHvDgvGVa6M4LXdJHo0vDVYiUABcnICf8K2g2LkgoL0THwPose8Hjquwyv5Zhnt+8IrTligeuOqfbfejOz7l12lM5XMiF01JMjFbi+d4pJq2oM4Yw8jqSccDMjm1HtYHrwDwZWJCHlN0uCCn0cD8tCfXqj0FfQEj9Ekk4ygLy/UP+dO833XMm55mU92gDW/F9Zl6FVnAcOhrG+XZSSpFh1q+DQgiZXpI7LeT7ehgz6P3zRWME9xe3x/Fq6OYPkufUqsvbGvqlijeWaoerGV2245Gx8pClXu1inFe8rYhHIxxEdD3ChGe3FUPlJIMDxuIe76uxekp84W56mqBGQ2p
 VadBYtJ4
 uD+RBe+8UkLqEQBAFhVyoykePCSKMwtmrzEc+25aRXtTQ2zwrI0ciRlDvCKLIWg/zm4VNzlsamUr5SDg/2uZYxcbZjkd4Q5C5bK0iPf+LFYrs1Q9KRql3uDF3rw7j/Bs/6viUKbZtTVFtUO4pLW5irLkgsrTyfycEuaYpL1een1QvqlcXJ5K/ze/V5j/OSuIws3FeQ3VHC8v1elZbfUMEvmtyVRwV2OgNjwkx8G13QOisMoS27x8/C4/LHbZKwkqnmJaEo5h5Ox0cTRUxNfW6xwRmXOASKg9+KTYmKjp8efgPxEEhuPNjXkA5YpvK7EzO9wE47Vz3ksUdJhrI3fQZhDamY6abLCYrpJmEEBwCz4A/ul9HdS3SWTF0cVEOK3oFnbEpOKxjtFpM1BbqXf6iH3oX83jL/TAmCECa6kznzvaTJjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 10:49, Yuan Liu wrote:
> When shrinking a zone span after removing a PFN range,
> find_smallest_section_pfn() and find_biggest_section_pfn()
> only checked one edge PFN in each subsection for nid/zone matching.
> 
> If a memory or hole boundary falls in the middle of a subsection,
> that edge PFN may belong to a different nid/zone, causing the helpers
> to miss a valid PFN within that subsection.
> 
> Fix this by checking both subsection edge PFNs for nid/zone matching.
> Keep a single pfn_to_online_page() check per subsection, since online
> state is the same for all PFNs in a subsection.
> 
> Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
>  1 file changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 4c699fd9c479..3a281d595207 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>  				     unsigned long start_pfn,
>  				     unsigned long end_pfn)
>  {
> -	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
> -		if (unlikely(!pfn_to_online_page(start_pfn)))
> -			continue;
> +	unsigned long next_pfn;
>  
> -		if (unlikely(pfn_to_nid(start_pfn) != nid))
> -			continue;
> +	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
> +		unsigned long tail_pfn;
>  
> -		if (zone != page_zone(pfn_to_page(start_pfn)))
> +		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
> +		tail_pfn = next_pfn - 1;
> +
> +		if (unlikely(!pfn_to_online_page(start_pfn)))
>  			continue;
>  
> -		return start_pfn;
> +		if (likely(pfn_to_nid(start_pfn) == nid) &&
> +		    zone == page_zone(pfn_to_page(start_pfn)))
> +			return start_pfn;
> +
> +		if (likely(pfn_to_nid(tail_pfn) == nid) &&
> +		    zone == page_zone(pfn_to_page(tail_pfn)))
> +			return start_pfn;
>  	}
>  
>  	return 0;
> @@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>  				    unsigned long start_pfn,
>  				    unsigned long end_pfn)
>  {
> -	unsigned long pfn;
> +	unsigned long pfn, prev_pfn;
>  
>  	/* pfn is the end pfn of a memory section. */
>  	pfn = end_pfn - 1;
> -	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
> -		if (unlikely(!pfn_to_online_page(pfn)))
> -			continue;
> +	for (; pfn >= start_pfn; pfn = prev_pfn) {
> +		unsigned long head_pfn;
>  
> -		if (unlikely(pfn_to_nid(pfn) != nid))
> -			continue;
> +		prev_pfn = pfn - PAGES_PER_SUBSECTION;
> +		head_pfn = prev_pfn + 1;
>  
> -		if (zone != page_zone(pfn_to_page(pfn)))
> +		if (unlikely(!pfn_to_online_page(pfn)))
>  			continue;
>  
> -		return pfn;
> +		if (likely(pfn_to_nid(pfn) == nid) &&
> +		    zone == page_zone(pfn_to_page(pfn)))
> +			return pfn;
> +
> +		if (likely(pfn_to_nid(head_pfn) == nid) &&
> +		    zone == page_zone(pfn_to_page(head_pfn)))
> +			return pfn;
>  	}
>  
>  	return 0;


I think improving that should be patch #1.

But I think we can do much better code-wise. What about the following
cleanup instead:


From 6e9ea094daf8d04c0b119b780572a846334f8164 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 5 Aug 2026 12:52:55 +0200
Subject: [PATCH] mm/memory_hotplug: make shrink_zone_span() more robust

Let's make shrink_zone_span() more robust by checking in
find_smallest_section_pfn() / find_biggest_section_pfn() that start+end
of the subsection.

While at it, clean up the function heavily, factoring the core check
out into subsection_overlaps_zone().

There likely is no need to check for the nid first: we require
SPARSEMEM_VMEMMAP_ENABLE where pfn_to_page() is cheap, and the
pfn_to_nid() on CONFIG_NUMA would do a pfn_to_page() either way. So
let's just drop that for now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 35 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078ad..79937f9672d01 100644
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
+	for (; end_pfn >= start_pfn; end_pfn -= PAGES_PER_SUBSECTION) {
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
2.43.0


-- 
Cheers,

David

