Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F508F94CC0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 03:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8F26B0088; Tue, 21 Apr 2026 23:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A0B6B008A; Tue, 21 Apr 2026 23:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459016B008C; Tue, 21 Apr 2026 23:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 350866B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 23:26:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDEDB161328
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:26:52 +0000 (UTC)
X-FDA: 84684755064.28.E90B946
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id BE1AD40006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:26:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WkXtzcsO;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776828410;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jnuY7BaxyAqTyMW14b2KAmW1GqPqbyMPyZtJcjP7seY=;
	b=MTh3ixAjVN+fiBPV2xkuV9OCxHhGFeNZ1Usj9hdfU0fTfCyS5kLP3cJjo+29aDlw1i8sC8
	AAdsC648DHEvktMX4nUVH7HymTdYweW7xYR1Rus05poKKANjb7PwZBPTaM3tG86nLpSafK
	RFVM9Gh1g2ppWF5LpnHVuAEFGvjaSVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776828410; a=rsa-sha256;
	cv=none;
	b=xE2ZE3g0wjqTZRQ4MSfnCWcfzom79EsEFW0luiBkJBp+hb4G+F/QmB1M3VpfM2Og0lf691
	G4e+kFiesVXVEDwHG6hUTbXAd3CURUU1JmiC2kul7b1Blm6Iog4l+E3KlJUBpWzegn2gQL
	PZETjXGof+P5rXJiIg/fK7VA1Gr/958=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WkXtzcsO;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso50256675e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776828409; x=1777433209; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnuY7BaxyAqTyMW14b2KAmW1GqPqbyMPyZtJcjP7seY=;
        b=WkXtzcsOLgXWKXpRRICwok1XZaaLbgdMpdPaZBFj7/opPwEDiGTLR8RtLYFSZXMJqg
         MWzt2IHp3l6urs/95xdAice3ODLRUK/xQ3WK1SilBDBnK7l1uKMMXO1BZs6sGKUZdz5+
         XOcWbalBQXGn6pOqewVbVaAvOMuc5hV2uQi6NuHaHyyIymHVU07tmyxWSfy4hBW8Kwzy
         53EfFBuITOfd1ZXLS3aBv/u5fCx0Ic16Z3bP6wEEtCUF9tBQQI8gd6ru31zIo4Ph+y0L
         t0AASuUwPFRcngBQJ4zopOmGM6Monu/Mphe9LD3CbEC/A6WqMH4RNmsVlNVTuBfuSs0o
         bf9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776828409; x=1777433209;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jnuY7BaxyAqTyMW14b2KAmW1GqPqbyMPyZtJcjP7seY=;
        b=Phh0ewIzr1ecnyPt5jgK+2zTDhq8Odxrje1uY6zo4Mld8Sr1uIQ78mHqBitKu/Lbg/
         tWQqYFXEuPnauHEPaeNU85xicM7JzxY5d++6P75BwvlL6vlmlOM4I554bYkJrRYiUrYV
         L+1cGGgtxg7u+hdy/K4tcJekHj7iuO1jGJsaXze1HQ7DCxlzKFHvqJs/h6EiVrQgDxAC
         gPy0mEGD8GqSNOhWt2e2ozDGUrgNjIV33RMRzkyscH6zzayhp67M6ES0FA5spLJQZSU6
         DYTjNxERPoxgUyDsF/Ky+sy2QGka2udknDee2LeuhwPjG8m/ZV1wPrUlGjpnbq6itgPJ
         rDNg==
X-Forwarded-Encrypted: i=1; AFNElJ9PrHzcpSdY8fzeAIdC9BODwCL28w58SkTKHyReR2dXtiVcxXfg8p3mhqUcM2VNYt29o2/hQJdTzw==@kvack.org
X-Gm-Message-State: AOJu0Yw/b1RyOSDubO8jV9QlSAi4xIovcIRLzBLHoys94QAJoW4Or33m
	I8KwlMf1wA25+ms0g1dVmgGhaMUbeS2e0yRQd/c0aum3RNnKHU8tnWkM
X-Gm-Gg: AeBDieuKD4V7ujl9NRG93lq847Wj8BG0nDoyA8gbosBrgZXeDOLcixPiMX4ERJFkPu8
	73G2E6+xBLUSQjOJVXxagZJuC0RIhl/ywI/WgAR1O23qmlGvWuFYmRhXs528RCXxoW6VVIk10kn
	n4MrNze1Fiawuhfr3Ly37AI/bqXRoQsVTag9Wrp19hJN23EjbuIie+msYHwjTmY49O3/zmffIJw
	ox3qg4Q4OAz3qefS+Jjt2PfQIf85ali4ZZIprFjFTrjCKaOiVmsBxvXMG96oiju1f3Safm5aFXG
	qJ0jhvijZhZoyrSIHk4OgiMOUYNulzTU+LH+bo9BTbnO5wCkVE5VUtgezTK0eZ89+wUMJsOG8KN
	yG5zhsuxFwYI7QiC6y/H5gXu1gYK0UMvbsco6hYsrzZV8aquZz+vP8iPLNk/UAE/ReWk17QnBCF
	gfx5Wr+cDiJgVeKSsigqScH8j4KtJoFKE6
X-Received: by 2002:a05:600c:8b55:b0:48a:57e1:d8cc with SMTP id 5b1f17b1804b1-48a57e1d8d4mr56062835e9.9.1776828408940;
        Tue, 21 Apr 2026 20:26:48 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e44f69sm44086904f8f.25.2026.04.21.20.26.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2026 20:26:47 -0700 (PDT)
Date: Wed, 22 Apr 2026 03:26:46 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Yuan Liu <yuan1.liu@intel.com>, David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
	Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Message-ID: <20260422032646.vtkdoliudlxgtpv3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
 <20260422011126.thu67icgj5qfbecj@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260422011126.thu67icgj5qfbecj@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: b7koorw9x41xebqyirubqiwbcntgpthr
X-Rspam-User: 
X-Rspamd-Queue-Id: BE1AD40006
X-Rspamd-Server: rspam05
X-HE-Tag: 1776828410-773338
X-HE-Meta: U2FsdGVkX1/MDhnvvT0X3oB6FYTH933O44FfHGmHzolwlPhAprDJ21hTpnVWl2vAiE8TBBgnUoUkXsRTtQcz4mxbDL91NK/2ManmyhKsUK9QWOHYx2bMaP7ddfsPhITtsgmsQF085SxpMfQSCfVK8Obs7Gmi2w7Wz4Eihf0+rnkpy+b9ybX9MxJnaETWJKYsxCMw3+xU0FTw0hy6ByGMeUq3BEuv7Mtn/rrUf2SFYGwSCyKNLPxYFh1i1iLTvdQZR+fJA5X8+z/PW28Uny3QElhldPa3RIBS8TnBu54DUPQqypJ6Euxz7hsNrbXCeFYMsvPz9zc8/6dvaK8tY7pkxV5cG6tH3Vc+6k5aYqxFkf2MBPXRL7anzeX0c3akDWhZ+KZMWg2ToVCz9eXR5Q0Quua5trhPkkdNQp7ofV00xt5t39ltc7723NyGrI4vD5kya1+++3FSZdK0bgSHcORlgGI1szFRoAsw+5i8iuqaJ2WWSACuaNwnbvu8YPWkuTaweGWyVCIwQVXBNen+LtcQC7BB4v0amS3cadONFkbGNKjIurxykHxpVlXuXry+fkPC4rn7x5GK4nZKFmelGz3MZxgJdGoZcqanl/h1ExZOGIceN++j4yM4vMUo6k+JFc3GIPh22ufKw1j3AjdGsK2ccXnimo1Bi72+p+d5Q7tZwC7TJ1mxCJZKwaV059ZJRiZ8nc3pwMfCegLdgyWE3RFHXt0h/4Fbzgq0r8FAKqBTDlwd+gGOrN1K2IFQ/W8IdWMkRAL1YyKhX+urioVRdEs+5Qb8Uj612d9WEJm3flT6tN0qXqi4gEczOy38FqGIFmIGhJ26wnaGf2pgmzlLiu9ZP3B1XtWHgwajr3wJypWGmBUqVI3dLcC9ULPPOKVRYjTQiJtNw/Vmzjo+opHWzQN2i4MFYUrmtPjrv2lH2EBZs1ExDWRvP3r2+H9DIXNptYcLTOkrazHmg47wJQ2n5FA
 qnZ+G3B+
 BC+anDjqDp16ktNi11WlX0lhsx+TvWTuIAjdhBjg2JUdZPmvNEmNRGUtN2oi7RrmsCsCSFmjev67IqOr+VNYBV+BU+x4umsF9FC/oQtHg17B0g1Xn/1UYWrXvkoKKcemPq47+Q8tNsAmMAiDPqApUI4qax93nMEezyCQZeAwnzbOo0LboCxZW7NJja0Jmca3KG6E8vXNj0W3lYsjuuuXkYCQWhEJyLRDhWOvTHqKfoTG3JuKib3tF+eQvX5zwKoIOau4T8FVAsfZycgQ9U3hHtLLThjYwWqzknnML+NJ5ZBuVnV3FevY36Jub2JPlH2QNUdVbo6OY8iIKRL8TKv8kzQeU3IfemFz1Jm6LzcZ9D4HnsDwzjz1gsZHE4bsqOMnOeyNWOSQPfilsrzIfZTH5diQkbm0xlLXwX2nHH0+2YL6sk+TsVGM/h3Yur3g9DX8c+Xv8n5uHirrDkP0ZbzDTDUMN4gv61RfjEpePYj7HWkZr/woeuzE3LvxdE6h9oe02B853PNxHj0EU7ihbX5VVwKoDQ3BHQJsPgI7zeUsCs3S//ncpt3uCkrIzfdTceeLgd2Hd8D/T3pYLO7zDCqn/DCeaf17ZQlJQmy7kPsE1w2FIxJftFT8un3l/E6BmuNC0Gf4F1K+xuPY/DT63Yy1GQ+WhJbPcLK8g23iSTkZdAhvtkbbYvmI2HTmAWZtDQEHKlZwVUTrVksSVMx3IU5u8YVLSDqiz3FiwVZJ+TWJaJ0zhOHyrYTfYYM5CwJqlXR2gzimJETueuWarH90vvir1r6FcvryvduRQ9APPC3IDyr+lhXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 01:11:26AM +0000, Wei Yang wrote:
>On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
>>Move the overlap memmap init check from memmap_init_range() into
>>memmap_init().
>>
>>When mirrored kernelcore is enabled, avoid memory map initialization
>>for overlap regions. There are two cases that may overlap: a mirror
>>memory region assigned to movable zone, or a non-mirror memory region
>>assigned to a non-movable zone but falling within the movable zone
>>range.
>>
>>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>>---
>> mm/mm_init.c | 37 +++++++++++++------------------------
>> 1 file changed, 13 insertions(+), 24 deletions(-)
>>
>>diff --git a/mm/mm_init.c b/mm/mm_init.c
>>index df34797691bd..2b5233060504 100644
>>--- a/mm/mm_init.c
>>+++ b/mm/mm_init.c
>>@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
>> 	}
>> }
>> 
>>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
>>-static bool __meminit
>>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>>-{
>>-	static struct memblock_region *r;
>>-
>>-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>>-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>>-			for_each_mem_region(r) {
>>-				if (*pfn < memblock_region_memory_end_pfn(r))
>>-					break;
>>-			}
>>-		}
>>-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>>-		    memblock_is_mirror(r)) {
>>-			*pfn = memblock_region_memory_end_pfn(r);
>>-			return true;
>>-		}
>>-	}
>>-	return false;
>>-}
>>-
>> /*
>>  * Only struct pages that correspond to ranges defined by memblock.memory
>>  * are zeroed and initialized by going through __init_single_page() during
>>@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>> 		 * function.  They do not exist on hotplugged memory.
>> 		 */
>> 		if (context == MEMINIT_EARLY) {
>>-			if (overlap_memmap_init(zone, &pfn))
>>-				continue;
>> 			if (defer_init(nid, pfn, zone_end_pfn)) {
>> 				deferred_struct_pages = true;
>> 				break;
>>@@ -971,6 +947,7 @@ static void __init memmap_init(void)
>> 
>> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>> 		struct pglist_data *node = NODE_DATA(nid);
>>+		struct memblock_region *r = &memblock.memory.regions[i];
>> 
>> 		for (j = 0; j < MAX_NR_ZONES; j++) {
>> 			struct zone *zone = node->node_zones + j;
>>@@ -978,6 +955,18 @@ static void __init memmap_init(void)
>> 			if (!populated_zone(zone))
>> 				continue;
>> 
>>+			if (mirrored_kernelcore) {
>>+				const bool is_mirror = memblock_is_mirror(r);
>>+				const bool is_movable_zone = (j == ZONE_MOVABLE);
>>+
>>+				if (is_mirror && is_movable_zone)
>>+					continue;
>>+
>>+				if (!is_mirror && !is_movable_zone &&
>>+				    start_pfn >= zone_movable_pfn[nid])
>>+					continue;
>
>IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
>is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.
>
>This means it will skip all memory regions.
>

Did some tests. When mirrored_kernelcore && !memblock_has_mirror(), which
means there is no is_mirror memblock. This will leave zone_movable_pfn[nid] 0.

So for all memory regions, the above logic will skip them.

Adjust the code as below, my local test could pass and kernel bootup as
expected.

From 6351ac79a17edbfd830510fba2959ddc47b17258 Mon Sep 17 00:00:00 2001
From: Wei Yang <richard.weiyang@gmail.com>
Date: Wed, 22 Apr 2026 09:13:24 +0800
Subject: [PATCH] skip overlap region higher level

---
 mm/mm_init.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 79f93f2a90cf..7a85ba58e87f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -916,8 +916,8 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 		 * function.  They do not exist on hotplugged memory.
 		 */
 		if (context == MEMINIT_EARLY) {
-			if (overlap_memmap_init(zone, &pfn))
-				continue;
+			// if (overlap_memmap_init(zone, &pfn))
+			// 	continue;
 			if (defer_init(nid, pfn, zone_end_pfn)) {
 				deferred_struct_pages = true;
 				break;
@@ -974,6 +974,17 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	*hole_pfn = end_pfn;
 }
 
+static bool __init region_overlapped(struct memblock_region *rgn, unsigned long zone_type)
+{
+	if (zone_type == ZONE_MOVABLE && memblock_is_mirror(rgn))
+		return true;
+
+	if (zone_type == ZONE_NORMAL && !memblock_is_mirror(rgn))
+		return true;
+
+	return false;
+}
+
 static void __init memmap_init(void)
 {
 	unsigned long start_pfn, end_pfn;
@@ -985,10 +996,15 @@ static void __init memmap_init(void)
 
 		for (j = 0; j < MAX_NR_ZONES; j++) {
 			struct zone *zone = node->node_zones + j;
+			struct memblock_region *r = &memblock.memory.regions[i];
 
 			if (!populated_zone(zone))
 				continue;
 
+			if (mirrored_kernelcore && zone_movable_pfn[nid] &&
+			    region_overlapped(r, j))
+				continue;
+
 			memmap_init_zone_range(zone, start_pfn, end_pfn,
 					       &hole_pfn);
 			zone_id = j;
@@ -1257,13 +1273,12 @@ static unsigned long __init zone_absent_pages_in_node(int nid,
 			end_pfn = clamp(memblock_region_memory_end_pfn(r),
 					zone_start_pfn, zone_end_pfn);
 
-			if (zone_type == ZONE_MOVABLE &&
-			    memblock_is_mirror(r))
-				nr_absent += end_pfn - start_pfn;
+			if (start_pfn == end_pfn)
+				continue;
 
-			if (zone_type == ZONE_NORMAL &&
-			    !memblock_is_mirror(r))
+			if (region_overlapped(r, zone_type))
 				nr_absent += end_pfn - start_pfn;
+
 		}
 	}
 
Want to confirm, the logic in zone_absent_pages_in_node() only handle
ZONE_NORMAL and ZONE_MOVABLE. So the assumption is ZONE_MOVABLE only could
overlap with ZONE_NORMAL?

When kernelcore=[nn]M is used, the "highest" populated zone is picked up to be
ZONE_MOVABLE, as indicated by find_usable_zone_for_movable(). So looks it is
possible to choose ZONE_DMA32 as ZONE_MOVABLE.

For kernelcore=mirror, we want to eliminate the complexity?

-- 
Wei Yang
Help you, Help me

