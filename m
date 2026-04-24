Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7747DFDEE58
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 01:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B33F6B0088; Thu, 23 Apr 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964136B008A; Thu, 23 Apr 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8528C6B008C; Thu, 23 Apr 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 723536B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:05:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED1411B920E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:05:41 +0000 (UTC)
X-FDA: 84691656882.10.C5ADF53
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E6CD14000B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 01:05:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bO1KNAZh;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776992739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92hmxtrw01jgdnML3HNZxYWHad+ML6IkMirm0dl8+MU=;
	b=DpWDgl3qFo80K4OiGxtLGfQvLkeogFvJGdQJrqaSiG7tsjAk496LWzY18YybruavVCR/zG
	LTXZfCyg2s5WhpGhknlMrbFXr6WF05tGICFspgwifE9QlerPjQtmWdZvnbQuZ1gfcZA9Hp
	yOoZnfVRdMfkucs9S/j2lhwJT785eqQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bO1KNAZh;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776992739; a=rsa-sha256;
	cv=none;
	b=cqhlhgbxUlLsh/XtjLcW4zz5SFUEpratAgn2/4mchaMAOruyR2VL6P7jI2Sf3tsiXGo8gE
	Drsgn1jpeR6+GcgGETNU7BQ61L6v/Mq1s4r5xXt5Fyw6V5CUf9R7rSLYlJNfbHW1m+/d6B
	FWxRyFH1kbHUqgWJMvBgE5SQirqgX+c=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so12063299a12.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 18:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776992738; x=1777597538; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=92hmxtrw01jgdnML3HNZxYWHad+ML6IkMirm0dl8+MU=;
        b=bO1KNAZhY+Z7WtSHYzdw/5hoaXk360gLaCZdio69kq3PWw4ML8NiKQYqAHffXrjGBF
         oTbCevRVd0bWCtcrS/vwEstZ4JCOU3pFvMGTAuj8pp2n6rDEDO6mt1ELJro2EBnpsg5b
         5GHZknZa/173uhEHvXgmX4U4UP14uwZf8DUx1AQ9F9/UWHZ2X3OCmEkmRmJYTl6unGpK
         DzOZXenwV6pU0Z5+fWk0ppSmar6GmB0vkRRHtE0QP0nx5JkU5KVAbSF3Cj2bMcshcsq7
         yjUdai856d1ZQmYeN7MM3WNnQRTQJBmWWUDhzYrZGO1CXOnj5l7ZmIQXOqFSHbr9Uipv
         dZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776992738; x=1777597538;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=92hmxtrw01jgdnML3HNZxYWHad+ML6IkMirm0dl8+MU=;
        b=beYqW+gYV7qu8odAPIGb7YSNvMw/rOlACaL8aCeSZA7qhywsnwzkqlgxHwtG6YrcAk
         8qPizUqr6LzvL6HCBIsg4wSFf8iJO3SsCRmx7GPxVjFvuEgek2U57sAJeLN9O99qPWH8
         VIqdePH1IrfJhUIJalpqk1GAxhIdea7HpEYVKxbPMfmboh95lip7QG3dPilZX2B9IAR6
         /wlOXRRagsuy1QFKNOfMqNkHC/yldmA9BNwJAJTtFPsbrypVoaMfXP3vExpxshJxdNLs
         oOtnDcS4HNZ1VKduqpejqY1N5H42nCFmQmMclC4jT/oyRs7QN7FdVaxYgKX3MANGz86O
         5SKQ==
X-Forwarded-Encrypted: i=1; AFNElJ9asWSKdEPT0VRq+GOD+DDOtjavDsWCysvdLQ85a6V4ckinRUK4l4cqhvPJPEyyHTBBTMe0LyHXjQ==@kvack.org
X-Gm-Message-State: AOJu0YwRavSuugNi3hGTok17RYVdSfDr1RDW/M1aS9gST53p6kWxCDbp
	hR6e+VH6rsNVWsiAaJSJbMyoGZ27LJ4x+FANrme3+8gHi8pwTSQy1ult
X-Gm-Gg: AeBDieskgvV4NkcH57GfQlpfMeoQ2zg1mh/PBXOJXEEzD/kAA/JTlcIVtPIdBFs31mM
	rbTNSP01DIe5zrp0jjsNkKp1Fyx0+KVSBBlyboSTUFOBtcMcJdeafWAqc4yp9bPpxsY4BSPrwwr
	4x+0pa95tqpGsjEh+Y6Vi4Sr7HH7JMop4ze2KOQNLX+fbw1wIvir63XPnU0Dl2B/xNTYaVtCOtP
	nPfhOFhcEuvJf3LoSW0JBoaug0I6VqUOsbvzb88vzRFNXEV9nLdc9XEcEOknrQtS3/YWqjqCxA9
	4zXcKN6Zg0UDzq+4tb4AGM8MV+tR2A58/HzFkqd5z76/XMUrR3xkcN7WMEFqiXyV26yxeS+Ilme
	Ppm+7+f/0vvXpbFismgY0/f7SPsSNtYvZzXI5bKq2r2C9Yg0zOE9rkE3Si6vjmIQ6C1hOlS1E/w
	cSzRVDivT3wWVuXGbAIjSOVwV2aFJqqQkZ
X-Received: by 2002:a17:907:a60b:b0:ba0:fd75:9c58 with SMTP id a640c23a62f3a-ba41b3e1284mr1347700866b.32.1776992737552;
        Thu, 23 Apr 2026 18:05:37 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba45553e502sm709993966b.61.2026.04.23.18.05.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 Apr 2026 18:05:36 -0700 (PDT)
Date: Fri, 24 Apr 2026 01:05:35 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Message-ID: <20260424010535.54sh5z6nkqt3j6du@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <20260422011126.thu67icgj5qfbecj@master>
 <20260422032646.vtkdoliudlxgtpv3@master>
 <MW4PR11MB6936682EB5EF1993DE7BDAEEA32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB6936682EB5EF1993DE7BDAEEA32D2@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: q7zd7eaf1iarfcqihtpdidamkxxqxc8z
X-Rspamd-Queue-Id: 9E6CD14000B
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776992739-780061
X-HE-Meta: U2FsdGVkX18eJa7ADfvV01E0cU599SoJp6g2cNDhK7BT7H9LJu+caxAAYI/NIK1w2wDkY9z59QET/rA8ujsztUNMEnSwldbemUpDDrGJRgfJTh2nFX5K/ERvKx7giqdv/FpdHf7D4I0bC/YsbEZu+dnEUVFH0S1Y20FEln42Tgib56q63j8Um3L9zSMsideOq774vEDofElSQcLGgPFmL9CIAnN8WF+5fGckP6PFfWzngoRbn9oAlyKBqeNvdekMP17Y4G6FX7Ov+/3KnwK9tzSHVotImWFM8RydLA564wFzmnnzUimx3yR6oYdU+V/H7vX684cGXju9O2X0OkLQjSWTnYJHV7b4FtyGR/J6O3e5+1pNrkx49RwNiG73vlNAEfPyHnEfje92fkarjX0L5ZIjlsJ9bUoeZ0fNAvdnZtRYCWrtgeEk7TPVgPNXYm5rqi1kVHPY+uxZFO8O6af3BAIOUg2D5DYMtrCFZV9g5Kh+5uL5J9ndDAMPpi80U4uqqaK0R/siRgz3N2RIWmNaEIZSYYufXXhbLDn9T6aHji69im0Vv9usHY9eYsCdij5RS5w1TaTtC4iCP0ZswQSj40i8zA1mvt+76CgyU15WYSHLVy8CNRiV/GEsEWlxC6O+Ep2KspSN6waYGhFp7fzmdJ04EjG+5mfFYr540VQd4oE/YN9oqL690A6Apny8BTAFqlue5TRBCWxqy+Ryr3sNVMYxAUZQ9UobioFCkRy0ikjyYaL12Tg5EkX98dyPmZ2dRb22Tmrz9hfvU37l6PLzN6zgJ+ED4vTrEKpNMZ0lGM0FDNHMUo8gj0Gzo8cwPCAZQ+wgJy58CFdPjABngVXKzjAqMOUFQpMRWQC5hWT5+d47+fNjmUIg78P/op7lFr9s/Omb1qYbVJ8DiM+5wCuHDdfZXkkdgwE3rrLgdb2U7cog8kV+Bja6sS7bgZGBLG0w+zfBk+IDDf9GObrxp4I
 xxm4I0Y5
 FD2Y8voe7vgF3BYmNm9nvyKhUgAXOSoan+Oc4lGOPrOx8CuULn2dku8zUKnmblW5+23/WEKhKNBceA+RABzb6bVD82m3+Tl90XB/Lg7Z7FlV1ZiAazVMRw/+Ox7CCh9UirJh+g7JAki/vdGG2y+pfKjXacZsrC3C0hIXUGKxWPjsEi37kg3OntxpBozJgu964/3ghOpSKT8ghB+CkuTg3LLqxdbaNo2xEF+M+97setmGa7/BVk7nxbnbu0rYCLSEJEfB23MKcx0EzKZB2rZ2iVi3aG+lnNskojaVfXggSWuNvXhwQXF0KEsG3NErDiHxzpcmaPL2uki/vL6Vtvi5916ZaNsCZ566Ii2xo9lk0VyPSlmaCp24tpW+tBbEXaWjGyoEoJ2ffjCZvodi6dGVCnmIb+iTc3CejymkjDfQl6B236oFvL9tNb7MWnhGuMweuWkOqYJsBA0ORk53jeHdLgkrLbLbl5gnZC8++79CGjcfE2Gsq+GMWTHPit8Jh5H1MtVClqAo3mYC9FNT8Y9R/aLW3sWN0/ZsLouUa2t9mexltDhb1sfJfAiYOPN/C1ldLitZQg97Dp31LuvMNdb5rIz1RvGgWzE8VwqGagN8I9kGBlGyljd4k6Sw8cDe5bAUJfpC70OigaKJ8xYh2kDTHF3tG6CsJzgovIMDT308TgwGoCSkxH8QMgqLkEnUY7MRjRrAjEI6XU8NlDsVW2R4TpGa1/bLzQ6dCNjQ/wH3XkbCAL+xrWv5142R8nfCOBuyomgZV4pOt3e5Weo6qKQVjcZhMLd7Er26y14DygUmdh9FgXf8860nGloH7iHnvznkuy83K61pNaTeVY4hIDv8yF6lR3QH7ttMWySEkcJkyXWDM7PKlcCiXmTjsT6KuXNR84QOCj6HxMeHSVMAw36QQFIokR0FCwuRNxS1kXPu//BBlhQz72a3ZpH1cvKcuPYtaAybQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 09:28:52AM +0000, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Sent: Wednesday, April 22, 2026 11:27 AM
>> To: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Liu, Yuan1 <yuan1.liu@intel.com>; David Hildenbrand
>> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
>> <rppt@kernel.org>; linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou,
>> Nanhai <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>;
>> Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>;
>> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
>> Zhang <zhangchen.kidd@jd.com>; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
>> memmap_init()
>> 
>> On Wed, Apr 22, 2026 at 01:11:26AM +0000, Wei Yang wrote:
>> >On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
>> >>Move the overlap memmap init check from memmap_init_range() into
>> >>memmap_init().
>> >>
>> >>When mirrored kernelcore is enabled, avoid memory map initialization
>> >>for overlap regions. There are two cases that may overlap: a mirror
>> >>memory region assigned to movable zone, or a non-mirror memory region
>> >>assigned to a non-movable zone but falling within the movable zone
>> >>range.
>> >>
>> >>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> >>---
>> >> mm/mm_init.c | 37 +++++++++++++------------------------
>> >> 1 file changed, 13 insertions(+), 24 deletions(-)
>> >>
>> >>diff --git a/mm/mm_init.c b/mm/mm_init.c
>> >>index df34797691bd..2b5233060504 100644
>> >>--- a/mm/mm_init.c
>> >>+++ b/mm/mm_init.c
>> >>@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t
>> start,
>> >> 	}
>> >> }
>> >>
>> >>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped
>> init */
>> >>-static bool __meminit
>> >>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>> >>-{
>> >>-	static struct memblock_region *r;
>> >>-
>> >>-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>> >>-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>> >>-			for_each_mem_region(r) {
>> >>-				if (*pfn < memblock_region_memory_end_pfn(r))
>> >>-					break;
>> >>-			}
>> >>-		}
>> >>-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>> >>-		    memblock_is_mirror(r)) {
>> >>-			*pfn = memblock_region_memory_end_pfn(r);
>> >>-			return true;
>> >>-		}
>> >>-	}
>> >>-	return false;
>> >>-}
>> >>-
>> >> /*
>> >>  * Only struct pages that correspond to ranges defined by
>> memblock.memory
>> >>  * are zeroed and initialized by going through __init_single_page()
>> during
>> >>@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size,
>> int nid, unsigned long zone
>> >> 		 * function.  They do not exist on hotplugged memory.
>> >> 		 */
>> >> 		if (context == MEMINIT_EARLY) {
>> >>-			if (overlap_memmap_init(zone, &pfn))
>> >>-				continue;
>> >> 			if (defer_init(nid, pfn, zone_end_pfn)) {
>> >> 				deferred_struct_pages = true;
>> >> 				break;
>> >>@@ -971,6 +947,7 @@ static void __init memmap_init(void)
>> >>
>> >> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
>> {
>> >> 		struct pglist_data *node = NODE_DATA(nid);
>> >>+		struct memblock_region *r = &memblock.memory.regions[i];
>> >>
>> >> 		for (j = 0; j < MAX_NR_ZONES; j++) {
>> >> 			struct zone *zone = node->node_zones + j;
>> >>@@ -978,6 +955,18 @@ static void __init memmap_init(void)
>> >> 			if (!populated_zone(zone))
>> >> 				continue;
>> >>
>> >>+			if (mirrored_kernelcore) {
>> >>+				const bool is_mirror = memblock_is_mirror(r);
>> >>+				const bool is_movable_zone = (j == ZONE_MOVABLE);
>> >>+
>> >>+				if (is_mirror && is_movable_zone)
>> >>+					continue;
>> >>+
>> >>+				if (!is_mirror && !is_movable_zone &&
>> >>+				    start_pfn >= zone_movable_pfn[nid])
>> >>+					continue;
>> >
>> >IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
>> >is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.
>> >
>> >This means it will skip all memory regions.
>> >
>> 
>> Did some tests. When mirrored_kernelcore && !memblock_has_mirror(), which
>> means there is no is_mirror memblock. This will leave
>> zone_movable_pfn[nid] 0.
>> 
>> So for all memory regions, the above logic will skip them.
>> 
>> Adjust the code as below, my local test could pass and kernel bootup as
>> expected.
>> 
>> From 6351ac79a17edbfd830510fba2959ddc47b17258 Mon Sep 17 00:00:00 2001
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Date: Wed, 22 Apr 2026 09:13:24 +0800
>> Subject: [PATCH] skip overlap region higher level
>> 
>> ---
>>  mm/mm_init.c | 29 ++++++++++++++++++++++-------
>>  1 file changed, 22 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>> index 79f93f2a90cf..7a85ba58e87f 100644
>> --- a/mm/mm_init.c
>> +++ b/mm/mm_init.c
>> @@ -916,8 +916,8 @@ void __meminit memmap_init_range(unsigned long size,
>> int nid, unsigned long zone
>>  		 * function.  They do not exist on hotplugged memory.
>>  		 */
>>  		if (context == MEMINIT_EARLY) {
>> -			if (overlap_memmap_init(zone, &pfn))
>> -				continue;
>> +			// if (overlap_memmap_init(zone, &pfn))
>> +			// 	continue;
>>  			if (defer_init(nid, pfn, zone_end_pfn)) {
>>  				deferred_struct_pages = true;
>>  				break;
>> @@ -974,6 +974,17 @@ static void __init memmap_init_zone_range(struct zone
>> *zone,
>>  	*hole_pfn = end_pfn;
>>  }
>> 
>> +static bool __init region_overlapped(struct memblock_region *rgn,
>> unsigned long zone_type)
>> +{
>> +	if (zone_type == ZONE_MOVABLE && memblock_is_mirror(rgn))
>> +		return true;
>> +
>> +	if (zone_type == ZONE_NORMAL && !memblock_is_mirror(rgn))
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>  static void __init memmap_init(void)
>>  {
>>  	unsigned long start_pfn, end_pfn;
>> @@ -985,10 +996,15 @@ static void __init memmap_init(void)
>> 
>>  		for (j = 0; j < MAX_NR_ZONES; j++) {
>>  			struct zone *zone = node->node_zones + j;
>> +			struct memblock_region *r = &memblock.memory.regions[i];
>> 
>>  			if (!populated_zone(zone))
>>  				continue;
>> 
>> +			if (mirrored_kernelcore && zone_movable_pfn[nid] &&
>> +			    region_overlapped(r, j))
>> +				continue;
>> +
>>  			memmap_init_zone_range(zone, start_pfn, end_pfn,
>>  					       &hole_pfn);
>>  			zone_id = j;
>> @@ -1257,13 +1273,12 @@ static unsigned long __init
>> zone_absent_pages_in_node(int nid,
>>  			end_pfn = clamp(memblock_region_memory_end_pfn(r),
>>  					zone_start_pfn, zone_end_pfn);
>> 
>> -			if (zone_type == ZONE_MOVABLE &&
>> -			    memblock_is_mirror(r))
>> -				nr_absent += end_pfn - start_pfn;
>> +			if (start_pfn == end_pfn)
>> +				continue;
>> 
>> -			if (zone_type == ZONE_NORMAL &&
>> -			    !memblock_is_mirror(r))
>> +			if (region_overlapped(r, zone_type))
>>  				nr_absent += end_pfn - start_pfn;
>> +
>>  		}
>>  	}
>
>Hi Wei Yang
>
>I ran some tests based on this patch and didn't observe any issues. 
>Thanks for the patch.
>

You are welcome.

Well, maybe we need to do something more. Let me explain what I see.

My assumption of the position of mirror memory is:

   When there is mirror memory in system, all memory in low zone should be
   mirror memory. Non-Mirror memory only could be in the range of ZONE_NORMAL.

   And in the range of ZONE_NORMAL

     * there could be no mirror memory
     * the mirror memory could be at the head or middle in ZONE_NORMAL

Take my test machine as an example, 

    MEMBLOCK configuration:
     memory size = 0x000000017ff7dc00 reserved size = 0x0000000005a9a9c2
     memory.cnt  = 0x3
     memory[0x0]     [0x0000000000001000-0x000000000009efff], 0x000000000009e000 bytes on node 0 flags: 0x0
     memory[0x1]     [0x0000000000100000-0x00000000bffdefff], 0x00000000bfedf000 bytes on node 0 flags: 0x0
     memory[0x2]     [0x0000000100000000-0x00000001bfffffff], 0x00000000c0000000 bytes on node 1 flags: 0x0

The first two memblock region span ZONE_DMA and ZONE_DMA32. The third one span
ZONE_NORMAL.(When kernelcore is not specified).

So I did test with below code change:

@@ -147,6 +148,14 @@ static int __init numa_register_nodes(void)
        }
 
        /* Dump memblock with node info and return. */
+
+       /* Mark mirror by hand */
+       for_each_mem_region(r) {
+               if (i++ < 2)
+                       memblock_mark_mirror(r->base, r->size);
+       }
+

This mark the first two memblock region as mirror. And then use

        memblock_mark_mirror(0x100000000, 0x40000000);
or 
        memblock_mark_mirror(0x140000000, 0x40000000);

To mark the head 1G or second 1G as mirror in the 3rd memblock region to mimic
the overlap case.

So I manually create 3 cases:

A: all ZONE_NORMAL is non-mirror
  memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags: 0x2 mirror
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags: 0x2 mirror
  memory[0x2]     [0x0000000100000000-0x00000001bfffffff], node 1 flags: 0x0 non-mirror

B: head 1G of ZONE_NORMAL is mirror
  memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags: 0x2 mirror
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags: 0x2 mirror
  memory[0x2]     [0x0000000100000000-0x000000013fffffff], node 1 flags: 0x2 mirror
  memory[0x3]     [0x0000000140000000-0x00000001bfffffff], node 1 flags: 0x0 non-mirror

C: second 1G of ZONE_NORMAL is mirror
  memory[0x0]     [0x0000000000001000-0x000000000009efff], node 0 flags: 0x2 mirror
  memory[0x1]     [0x0000000000100000-0x00000000bffdefff], node 0 flags: 0x2 mirror
  memory[0x2]     [0x0000000100000000-0x000000013fffffff], node 1 flags: 0x0 non-mirror
  memory[0x3]     [0x0000000140000000-0x000000017fffffff], node 1 flags: 0x2 mirror
  memory[0x4]     [0x0000000180000000-0x00000001bfffffff], node 1 flags: 0x0 non-mirror

The change I proposed works fine for A/B, but for C pages in
[0x140000000-0x17fffffff] is miss placed.

    Node 1, zone  Normal
            spanned  0
            present  0           <-- missing
            managed  0
    Node 1, zone  Movable
            spanned  786432
            present  524288
            managed  773552      <-- but put in here

The reason is in adjust_zone_range_for_zone_movable(), ZONE_NORMAL is
truncated, since zone_movable_pfn[nid] equals to ZONE_NORMAL's start. So this
range is skipped and then by "accident" it is initialized by
init_unavailable_range() to ZONE_MOVABLE. And then it is freed to ZONE_MOVABLE
in __free_pages_core().

After removing this truncation, the zone stats looks good.

Node 1, zone   Normal
        spanned  786432
        present  262144
        managed  249310
Node 1, zone  Movable
        spanned  786432
        present  524288
        managed  517223

@@ -1204,10 +1204,7 @@ static void __init adjust_zone_range_for_zone_movable(int nid,
                        *zone_start_pfn < zone_movable_pfn[nid] &&
                        *zone_end_pfn > zone_movable_pfn[nid]) {
                        *zone_end_pfn = zone_movable_pfn[nid];
-
-               /* Check if this whole range is within ZONE_MOVABLE */
-               } else if (*zone_start_pfn >= zone_movable_pfn[nid])
-                       *zone_start_pfn = *zone_end_pfn;
+               }
        }
 }

All above analysis is based on my assumption on possible mirror memory
position in system. If my assumption of mirror memory is not true, this may
not be true.

-- 
Wei Yang
Help you, Help me

