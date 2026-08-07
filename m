Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68305C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 03:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4D76B007B; Thu,  6 Aug 2026 23:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F0E6B0088; Thu,  6 Aug 2026 23:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E896B008A; Thu,  6 Aug 2026 23:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA2806B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 23:22:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49FADA0286
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:22:13 +0000 (UTC)
X-FDA: 85073024946.25.8A9974F
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53C692000D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:22:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DR5VXbAi;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786072930;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHc5p3lKJbmPBh7ge2UhBNPTqES+fAoQf4O+7yGB4mc=;
	b=ko+qoihMlBU7pqdgWejgwrkiWsiD6d7J9qVDWWi7BUneBCKHCR5heEk0vbsPYBK4ZF6fwu
	krfXm7V0pRVmSM3lnR+TWo4Cz8Nc2BYCKtGF54mv7swbqFrs52GKcXF0oSxlCUOVe/Sl9b
	rbSJfYFaibUclb80Cd9OOHxothpcYuc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DR5VXbAi;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786072930;
	b=VTD0Q8B6fg6Ser2vAUB4BM3Wq8irZK94OfqmVjkXNKPWZiJkVMJPqrgCt99LIOtBs3lrDr
	dEktEKQrxWFe920w52xVJzzTCpuW0vJz0bjjxymb26cIiDIZP0vWijelpeAOd2gd4jBYC0
	4MjSCZv/FL12pRjIaMXZuKEzAljN5jY=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c20755e8295so119337466b.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 20:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786072929; x=1786677729; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kHc5p3lKJbmPBh7ge2UhBNPTqES+fAoQf4O+7yGB4mc=;
        b=DR5VXbAiTDeWwOoCrujR5/YUx6oEA4KTMVagtlTheP0icq4yiuTXbzoNCRSPAc0I1d
         G1dUqpCH9EbtpRmnoLiQW1fIlenK7ZqAXG7eiebFyNHme5xaxsIO3ZEAmV/IO/Z1U26B
         h/l6KLN8KZtAbVIsmEiY/MiGrw0O0i7AJU1AFSYomUkx1zkq03hhtoGVGD+lmDi73XLj
         H3v+8yEhJha2PA8HMmT8POSvxJeh2kqWbuiTAxcXAZQFjIoid7bgma/1mA0Gtt8AZbX0
         j+t2UgxwVcfhWuToHL6hnFU9t7jl9St4c14AlkVt6VObCbYLumKtvOoba4tpXsL3QbrD
         Z0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786072929; x=1786677729;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kHc5p3lKJbmPBh7ge2UhBNPTqES+fAoQf4O+7yGB4mc=;
        b=gBXsizwSqFywA64bE7RyCYGNUYMBMwRtT7TmC/dKYygG343GI+rx9kNriq7gXKHiei
         kXNajZOksuS4JVjTaYItPAcN/j2ruK3luBUmaK4IHD9YLPWaVMdnv1+RhB4F+MDWGkBn
         CCrKobemhWpITwIqTlpnNllcIIGeR4ER/BT+3SSaxRPl3vUxaR46nvsiPvaaOVdPkSiY
         ISOtDgzlCWlffm4Hxn4q32JPlXfA+/0zXtH/LzPlR21dhJ9d3O1miARU1AGJelRzHznQ
         Y7iLo38J+JvkieyvIbPn74rB2LWmZh1QEuzg8dYL6kB/TPEUaMpXoAMGLwfni23d9pwQ
         cU8g==
X-Forwarded-Encrypted: i=1; AHgh+RrWdnT/yj77pBblWCYJfxBauOw0XBvVdlW2L5NPnMKTq4i+zTQISm4OChkZ9xGsk1id43f0uSRMCg==@kvack.org
X-Gm-Message-State: AOJu0YyoPyEDppkXGIduPzo++eUyLkyRqhKNCrOtBe7a45RxDM/xIEHv
	0fsTo69XQK1pP0ZBuSi9Axwzr2vEYvQYRutcUM287zdvmUAoe/P0AV/d
X-Gm-Gg: AR+sD10lpr8o7Gmc3IbpgC2uSSjflugPbXLyy7/f98kSnFQzM7G9y+wdPFLa5oZGWKY
	/lkahQfrllF9I+4PF/bIdGHysLEfGhPM0g8DHpTfo9Par4THEVRD8J+/F3oN/m/A/TYOtLfNYq+
	R3jEfdTwSLpzpC2H//ahhEc9Cxhqkpveb8SAJRfTvP7TUAYd0CuONNt2tDk7PkjJTR5UVyD5VYI
	Ys5CpPtq00i71dTEGjbRTXo02aDgt1YOv+4T9jsodtwoL69+6chvAE62pu7uDiA+kpuR4H7TIQ6
	UQqSua5XOXbc+E6MsBZKEbGqAK5sVET2rDG2jlZpRAcRmktzVdg97A1oG4wQWv2wCS1VT0JsD0t
	rUUirJxDEe2wVW3ATnq25kQjMKab5T7s0Ty/HSvWA4qi0LxN4pJb04ZNQ7GikBtlQs3LauOfWeR
	VBQnyDl9OKgnq24gKeobq7DkK3YoWJrSpC8yNlPefMxM+BmTtviNyDNwJx7U/T6p06OHFUDw==
X-Received: by 2002:a17:907:d9e:b0:c1c:2218:f317 with SMTP id a640c23a62f3a-c2057d85210mr515418366b.2.1786072928434;
        Thu, 06 Aug 2026 20:22:08 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1967117c7sm1589944a12.28.2026.08.06.20.22.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2026 20:22:07 -0700 (PDT)
Date: Fri, 7 Aug 2026 03:22:05 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Nanhai Zou <nanhai.zou@intel.com>, Pan Deng <pan.deng@intel.com>,
	Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	Jason Zeng <jason.zeng@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Message-ID: <20260807032205.ykhxbapx6nhg5hpt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
 <ff4fe959-c0e2-46f0-91d6-0839c90d62e8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff4fe959-c0e2-46f0-91d6-0839c90d62e8@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53C692000D
X-Stat-Signature: t3454peq665rcitcjdnbxib3zrouxiri
X-HE-Tag: 1786072930-955847
X-HE-Meta: U2FsdGVkX18NqvWf96sSInSQjLQuMDr6oTOjapN3I19PiNk1PpuPKWGCzSm1hEXC8v0tOhoFktFvZywe6YYiQ/NqihWItSH/jmlLc2aQT9nQwkTra+9ApJX3ynRSNWsIFfpr7Y6oa2mfAYZuFgHIUunsBWujaAmk0nyAjQ135go+8SBe3mMHqhfC7DIXEKe6ZdXGLLR0dXCi0hkO279eLuCXxmH/j8s3ificwqvhFa+C5LJznWiY4mIue2kydb5Q3GfVLVpU+fcLJyW70uDoqvNSppb/rFz5GybNbgcnKpCs94REuGvg22rnJMzKP5xHZELgfi7OHe/e3bzL/vWZHbMUn35TFHpnEpimHEe7/9rf7vHjtNYk5RQYATaOyegVFFuemh2Neyf48N/dHqXWWk5bpsPQgC5mxMDxcLzmAwWjf+oa+5faDydwrVKPS8Vp8UJMPRRPXTY9lCbQ/WzkrTGz4uTzJqn6mcA5fnA7OyO2JeIDRgbcIg4VrblA+6l6gG07Ufy8a0BnqPQi4E7v7AzxU9i4EVDQIKOMGeYGwsH1CzKKKcNTbiusdqhzimiWaXUY8XaYScKIJlA30DRoIDbwO+APxf/RJyApxkZu62VbWWWHCS7ZyA6jIrtPdhj3U/Y4HqYFdoh4XI4QSo5TJqJn6RhSi705Jy6O3lOdk/m98jzCzBHBhFtQ6b+/MemWnZnmJQid9ZO+2rJMklPEe68U2p/u2sVEB5AJEHB+oCQiJVvcuDgwuVtOy0jblY84bAHXmldbGnvWViGCdlVzwrWL5ZZWd5YShKxsteNEE6hFB3s4g5Lf95YldBAdaRgurgEzTWqYfVOu+3ovnhCskQvuKqCJWMsavxCU2Z0FDC80f0c+/ibM4OpFSLs8Xkgx5y2ABLd4mPDhzOmCs4a+ZCBr5r+gc1E93XwDAtEaYPwIUplXq8ZYSiT81JRW1gctTtYuzhTo41e5n+fP7fn
 BLrJY4+5
 DAfF57/zrSwV/VtpubyLtrFnD2MrY55ET9IytvSgs+AqGowmoDq9beU0ohdwjoyWabH2s79AP3HXOaC1GwJ4wgYsUMjVnwUydZWfrPWEjNc4rhckM/I+vkQ9iezrhW0Mkk/1mtixMc+nOJFyetOBaTRat5ddXiwnZEXiiC0dTNB9j/bVKUor9N2khMDAnpykxZGBV3GAdlO/qyRcmiizg8rnLLpJ5jgJmQgayJsB1DH6q+Q1e0hijOClzkuNME0NShz1dkzVpm4RRKRN2+rjKSdLQChyL7QREsH5EFTZN/VX6LBz2j3on44QKCCsA0CzvSOC35EzggNq/M1EhgJjHGAC6+9u2JOfFGcEmNhRkJ+7h+qf+RkWJurtxbtSmjbmRtsPo6QXUJXw472owdwU3rXUr6ZqutWPsRyG9svM9VDNAHpxd2o+9+lwH/zepICljxl7Br99rrmT0Rn39S5H9N78v0AdaNvdtEscNwsrSvkZdeytmQAbzk4Td2+s8e4ZG1ZorEwHou/YUKconzcwL57zm0B4eSqyG29GXK4HK0D2AyoSVycdNpfSwZgy4eG8eO5/Aq3J4uUXBAfV2bOJrlBge1tSKEoOkvl7oAMPctxCqSml8FO3Y+Rzz2w8Gjmm4oSL8AZUJNscehBfiuXAawv0V9dcByzl1X1al0rGAX7sC0S8i8ATwbRola3u1kYj1LbMyGaemnCwKCRIptyYm0hyoKhBkeVosKv87jgmn2ZlWlsJ4bc3VwXD4np4dackLsu9Y7fddQHWUQhNzYAeG+VNsQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 01:02:29PM +0200, David Hildenbrand (Arm) wrote:
>On 7/23/26 10:49, Yuan Liu wrote:
>> When shrinking a zone span after removing a PFN range,
>> find_smallest_section_pfn() and find_biggest_section_pfn()
>> only checked one edge PFN in each subsection for nid/zone matching.
>> 
>> If a memory or hole boundary falls in the middle of a subsection,
>> that edge PFN may belong to a different nid/zone, causing the helpers
>> to miss a valid PFN within that subsection.
>> 
>> Fix this by checking both subsection edge PFNs for nid/zone matching.
>> Keep a single pfn_to_online_page() check per subsection, since online
>> state is the same for all PFNs in a subsection.
>> 
>> Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> ---
>>  mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
>>  1 file changed, 27 insertions(+), 15 deletions(-)
>> 
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 4c699fd9c479..3a281d595207 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -427,17 +427,24 @@ static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>>  				     unsigned long start_pfn,
>>  				     unsigned long end_pfn)
>>  {
>> -	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>> -		if (unlikely(!pfn_to_online_page(start_pfn)))
>> -			continue;
>> +	unsigned long next_pfn;
>>  
>> -		if (unlikely(pfn_to_nid(start_pfn) != nid))
>> -			continue;
>> +	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
>> +		unsigned long tail_pfn;
>>  
>> -		if (zone != page_zone(pfn_to_page(start_pfn)))
>> +		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
>> +		tail_pfn = next_pfn - 1;
>> +
>> +		if (unlikely(!pfn_to_online_page(start_pfn)))
>>  			continue;
>>  
>> -		return start_pfn;
>> +		if (likely(pfn_to_nid(start_pfn) == nid) &&
>> +		    zone == page_zone(pfn_to_page(start_pfn)))
>> +			return start_pfn;
>> +
>> +		if (likely(pfn_to_nid(tail_pfn) == nid) &&
>> +		    zone == page_zone(pfn_to_page(tail_pfn)))
>> +			return start_pfn;
>>  	}
>>  
>>  	return 0;
>> @@ -448,21 +455,26 @@ static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>>  				    unsigned long start_pfn,
>>  				    unsigned long end_pfn)
>>  {
>> -	unsigned long pfn;
>> +	unsigned long pfn, prev_pfn;
>>  
>>  	/* pfn is the end pfn of a memory section. */
>>  	pfn = end_pfn - 1;
>> -	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
>> -		if (unlikely(!pfn_to_online_page(pfn)))
>> -			continue;
>> +	for (; pfn >= start_pfn; pfn = prev_pfn) {
>> +		unsigned long head_pfn;
>>  
>> -		if (unlikely(pfn_to_nid(pfn) != nid))
>> -			continue;
>> +		prev_pfn = pfn - PAGES_PER_SUBSECTION;
>> +		head_pfn = prev_pfn + 1;
>>  
>> -		if (zone != page_zone(pfn_to_page(pfn)))
>> +		if (unlikely(!pfn_to_online_page(pfn)))
>>  			continue;
>>  
>> -		return pfn;
>> +		if (likely(pfn_to_nid(pfn) == nid) &&
>> +		    zone == page_zone(pfn_to_page(pfn)))
>> +			return pfn;
>> +
>> +		if (likely(pfn_to_nid(head_pfn) == nid) &&
>> +		    zone == page_zone(pfn_to_page(head_pfn)))
>> +			return pfn;
>>  	}
>>  
>>  	return 0;
>
>
>I think improving that should be patch #1.
>
>But I think we can do much better code-wise. What about the following
>cleanup instead:
>
>
>>From 6e9ea094daf8d04c0b119b780572a846334f8164 Mon Sep 17 00:00:00 2001
>From: "David Hildenbrand (Arm)" <david@kernel.org>
>Date: Wed, 5 Aug 2026 12:52:55 +0200
>Subject: [PATCH] mm/memory_hotplug: make shrink_zone_span() more robust
>
>Let's make shrink_zone_span() more robust by checking in
>find_smallest_section_pfn() / find_biggest_section_pfn() that start+end
>of the subsection.
>
>While at it, clean up the function heavily, factoring the core check
>out into subsection_overlaps_zone().
>
>There likely is no need to check for the nid first: we require
>SPARSEMEM_VMEMMAP_ENABLE where pfn_to_page() is cheap, and the
>pfn_to_nid() on CONFIG_NUMA would do a pfn_to_page() either way. So
>let's just drop that for now.
>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
> mm/memory_hotplug.c | 59 ++++++++++++++++++---------------------------
> 1 file changed, 24 insertions(+), 35 deletions(-)
>
>diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>index 226ab9cb078ad..79937f9672d01 100644
>--- a/mm/memory_hotplug.c
>+++ b/mm/memory_hotplug.c
>@@ -425,49 +425,39 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
> 	return err;
> }
> 
>-/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>-static unsigned long find_smallest_section_pfn(int nid, struct zone *zone,
>-				     unsigned long start_pfn,
>-				     unsigned long end_pfn)
>+static bool subsection_overlaps_zone(unsigned long pfn, struct zone *zone)
> {
>-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(start_pfn)))
>-			continue;
>+	const unsigned long start_pfn = ALIGN_DOWN(pfn, PAGES_PER_SUBSECTION);
>+	const unsigned long end_pfn = start_pfn + PAGES_PER_SUBSECTION - 1;
> 
>-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>-			continue;
>+	/* All pages in a subsection are either online or offline. */
>+	if (unlikely(!pfn_to_online_page(start_pfn)))
>+		return false;
> 
>-		if (zone != page_zone(pfn_to_page(start_pfn)))
>-			continue;
>+	/* Checking start+end is sufficient. */
>+	return zone == page_zone(pfn_to_page(start_pfn)) ||
>+	       zone == page_zone(pfn_to_page(end_pfn));
>+}

Hi, David

I am thinking if we could initialize each subsection to only one zone, we may
reduce the complexity?

For example, in init_unavailable_range() align spfn to subsection and init the
head unaligned part to previous zone?

Do you think this is reasonable?

> 
>-		return start_pfn;
>+/* find the smallest valid pfn in the range [start_pfn, end_pfn) */
>+static unsigned long find_smallest_section_pfn(struct zone *zone,
>+		unsigned long start_pfn, unsigned long end_pfn)
>+{
>+	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>+		if (subsection_overlaps_zone(start_pfn, zone))
>+			return start_pfn;
> 	}
>-
> 	return 0;
> }
> 
> /* find the biggest valid pfn in the range [start_pfn, end_pfn). */
>-static unsigned long find_biggest_section_pfn(int nid, struct zone *zone,
>-				    unsigned long start_pfn,
>-				    unsigned long end_pfn)
>+static unsigned long find_biggest_section_pfn(struct zone *zone,
>+		unsigned long start_pfn, unsigned long end_pfn)
> {
>-	unsigned long pfn;
>-
>-	/* pfn is the end pfn of a memory section. */
>-	pfn = end_pfn - 1;
>-	for (; pfn >= start_pfn; pfn -= PAGES_PER_SUBSECTION) {
>-		if (unlikely(!pfn_to_online_page(pfn)))
>-			continue;
>-
>-		if (unlikely(pfn_to_nid(pfn) != nid))
>-			continue;
>-
>-		if (zone != page_zone(pfn_to_page(pfn)))
>-			continue;
>-
>-		return pfn;
>+	for (; end_pfn >= start_pfn; end_pfn -= PAGES_PER_SUBSECTION) {
>+		if (subsection_overlaps_zone(end_pfn - 1, zone))
>+			return end_pfn - 1;
> 	}
>-
> 	return 0;
> }
> 
>@@ -475,7 +465,6 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 			     unsigned long end_pfn)
> {
> 	unsigned long pfn;
>-	int nid = zone_to_nid(zone);
> 
> 	if (zone->zone_start_pfn == start_pfn) {
> 		/*
>@@ -484,7 +473,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 		 * In this case, we find second smallest valid mem_section
> 		 * for shrinking zone.
> 		 */
>-		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>+		pfn = find_smallest_section_pfn(zone, end_pfn,
> 						zone_end_pfn(zone));
> 		if (pfn) {
> 			zone->spanned_pages = zone_end_pfn(zone) - pfn;
>@@ -500,7 +489,7 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
> 		 * In this case, we find second biggest valid mem_section for
> 		 * shrinking zone.
> 		 */
>-		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>+		pfn = find_biggest_section_pfn(zone, zone->zone_start_pfn,
> 					       start_pfn);
> 		if (pfn)
> 			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
>-- 
>2.43.0
>
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

