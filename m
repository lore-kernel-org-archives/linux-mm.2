Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51FBF94CBA
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 01:11:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A7096B0005; Tue, 21 Apr 2026 21:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930F86B0088; Tue, 21 Apr 2026 21:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8616B0089; Tue, 21 Apr 2026 21:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 683B96B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:11:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01304BEC41
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:11:32 +0000 (UTC)
X-FDA: 84684414066.13.6F879B1
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13EE1120009
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:11:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mGb3tgv8;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776820291;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/dKQLlIMovlF4MngYnXStTFl6ju+hBStgqEHpripIAU=;
	b=OPtjoB7749Iu17gaYY7I+/kopqvMOf559jMZUDACs6KhQB1XyuX/b4ZqXXRo781s1ZII/s
	a/enEKyyDYc9k/GOTbGfuTVKUoacqlhQLAS4AAvLN3ugU+MhhV85iam7DZTwOVkpT3dTWo
	9FyF2qztISWqm2wle516SSInZFugCR8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mGb3tgv8;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776820291; a=rsa-sha256;
	cv=none;
	b=J31zsVuZUZOxLsNFr7+W/94rTZKZmq9a6vsuF1/7x26q0KRb3xU0ZxC5+3QslWOHiOCwGo
	18N/0DeDUigAntwzlm/76X8/fiUYauoE7fTavyBovyUL9BtePtZXqPNUDKxY0Wu5U9AVs/
	KFBxJmDCIyxKgOlIOWunnXokKuyL/aI=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b9c603ec2dfso638348266b.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776820289; x=1777425089; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dKQLlIMovlF4MngYnXStTFl6ju+hBStgqEHpripIAU=;
        b=mGb3tgv8KuyMBjeBZGeEtWlqiXLFY9UNBif+sx2ajcKRzrSQIM8EAex6ZK8L8rS/WT
         Di9Qu2Jm3oJ1iD5jNfJq43vLssTlwObwmsQeC2Ga1PZrF4HwjMCMgsBiQP1GJ9tyuR5G
         AP1P47jmVmpjfCCX1s02spQX0nnRTrOmbLrcTKhkiMB5l8+0Lol8ZmYDn+vNNopHhHzj
         njerH3dBbJp/eS1atkRq16qkRivw8+LedTd5BmCvx3nKfHpZ5qiHKzQq16MNUiQ4wluQ
         5onuYPE/591duTlvewMSTTl2CQTezFN1XjAlY/Tjfv1Tu7jucP4T0TqR2dwGbDOkGx+9
         ak1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776820289; x=1777425089;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/dKQLlIMovlF4MngYnXStTFl6ju+hBStgqEHpripIAU=;
        b=HjTLb/ELyY5jziNyvrSyPdqifJrO0d+sUzj2zzLAGHQqwCY8IiGS6/W3BwJrruCBkI
         tcohk1WpUSnMb7JUNdrKX2qWREGg9WjNdPnYiF+DgZm0Tn70oWeh7ykwIpmXeW+Fgoo2
         rSwOQhEWZx7+YE8Bh2ejFRkAOJOZ1Ya90mjvI3NDUDG3YdwlvUmyEYxdwo1PTmbLJL+S
         ENFyyo6JfGHcBST/B9fDLHGnx++qfhj6/8j6sL8Twp+X+h+wpXHIRjMNYx6Qvn/IV1ky
         loJE0V4rig+gDK6LEjm7n0DwZUByQOA4qxuTwBVH1FAjb80REP+4FvgNoitoe019RX3k
         QM8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/3jkB9Lz8YJLQ18dUVP8TQK/WIAAKYxEx2YQ9T9umYUZr9Be8pQHAtGz1bFWmdqUj1wvQacEFryA==@kvack.org
X-Gm-Message-State: AOJu0YyYCHCmtrHjtrTgqPsNwV5AvLhm8QmTjVctQ6jyyXmvzdiJ0n6N
	a/Gc/6FldBpw8VR+wfqljhLVKtH0sLJWdxVEztRlP3OthJeKBk9RZqnI
X-Gm-Gg: AeBDiet5YZeUVaJHv29/vIsjEfVmtz3Ia9O6DMmAOy5AYYkFhnU5ypamidW4xLR3qhJ
	E8uzxDGJXDVZH/Md9dHG57G7aVpBctGwoajlLGmILqNDguFxE2exoQ9Xz9Pb9tTWuwNW35NHyPf
	yxBxVYySs1xC/xgnWJgjCW5fOnAtrfKDDsccwp28NolpMCj600ZIZT60iicbQzQSFtEIR2DaNEu
	c7iO+vuTSkFDPhbNSZCMKEUVLCh4Byev+XtRCuyjM+IAGgni2rlAaxGtsqpKXi3zXdRn0W8BIW7
	dkC3X+1EJ8YTenT+NFP1g2aAa+Nvq3q9ccu5H7GdGZ3WWeuYQEtDwr47oyromcyXU25t+9jwBFo
	p7Ny+LatZtyLHBOLeqf88/4LTBoU7DmO/wRpx+Vuyv7vtqBq3uA8fsrCYNzYnYxAEIDeNbXaltG
	n0DUL+r0trsL/YduoUXAilqE1G7LI3XsNY
X-Received: by 2002:a17:906:eec4:b0:ba7:79ef:8695 with SMTP id a640c23a62f3a-ba779ef8d42mr565070766b.49.1776820289152;
        Tue, 21 Apr 2026 18:11:29 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba4520c93c7sm481983466b.27.2026.04.21.18.11.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Apr 2026 18:11:28 -0700 (PDT)
Date: Wed, 22 Apr 2026 01:11:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Yuan Liu <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/2] mm: move overlap memory map init check to
 memmap_init()
Message-ID: <20260422011126.thu67icgj5qfbecj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260421125508.2317429-1-yuan1.liu@intel.com>
 <20260421125508.2317429-2-yuan1.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421125508.2317429-2-yuan1.liu@intel.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 3i3wthydfr3gy4y7n8cmfarbwssu1pcy
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13EE1120009
X-HE-Tag: 1776820290-683226
X-HE-Meta: U2FsdGVkX18N4+X6HuHUfG/vCm95O/SOeklHokZY08c88MDq8psVD/asx2ASPPyBAgWvbncFt7claGd474wZomGCJgOmEsyCAbwUukHiM6BD2XH5AvvmrgtQ93yYF/SJKlR+5juO610E+cRhj8S2XNyVSJKY7kO9rJbjXXei3s7zY2DazpH77m9bk/G1/lf7NhD3Y5ozBK4QPYF0NuZUVoHOxERmu+CxJrHvTxAyQQytMiBwCvcj76RklKMRQGomjMLso4cRXwNcD62JKafq3E/Drkssg4Wejy+5cKwLmLdaRFLW7NsKMOnSV9kutSIAA3FRXYIFTTFqYbzN5XRqyPiCRa7cH7wZYsViUxQ6xc1NryOuyrclFplZ9jEmQkeGIBtmBsZXEdX9NjTDis3EffXyKEsqY8lr242qC8fxJ4R7gbjFxIqk2tX+dFIIxm4wXuXHQYp+Qkoo5Hos63uJNgJiM7kZ7P6qQAzwc4W2n7tSqSdRzId1f3WI+YxVDbX+bzRXsubuTgRwcOoOLqLKWbgIYIhAU+V/KX3jiHigFPW4T/OawoV2XQcESOB+3bDk/xAjKkhS4iYDVo9M9er2NrIQwtpdAleagEmShYAdmhFc0wc1oTqqgyCg/jN2xoJQSX4zcW9gLKCgh/XVxKgHxXFbEcEyzQ3VXL3QUijp6l9YUoyVJx3x/e8ibf8VoKuFZ8DNxd7Yu1AV5G5dcYyEosrq2qV2Ph0Npx8VZ2FMwA8Y9V4rdnHy2ZgMuk263eEqEVAYfA8JuPWwT9pgvy5p8Nl2kFOe7Vh9WqXkYap4W2D75vPwvV8XXASWa4aIiNbtoeCJkkQNEqYLXmJJanE1JcUWXGtYIseL+BahPFjGSeHwfRy90GFJ5D3Td56uawWSRndI/81UChm0PIzhQZEw30CDAjKjs/xh6x5YKbPt2KoB567JTCdlQtZsBf2qjotzfGpViyTSr3VK7mci3no
 BQIpSYGo
 05I2i06aarANoK1EJ2zolYsYCrpkuMfQxa0/+87EGKMLqTZsSHFiw7he4UNRTzWDsv6A62CTNFaGxd8T8hGLdjK50k8i3bRHXf0MNJadIXkCyhKgqUDg/igMsHGC5WequH3zj+qBZRj0d1k69axqv93J7hKO+79MkvZGtVKNH4bcRhWiR1pDXhaBk+foIBgWZZcOJ9HIsoXKdEmD3n53bXeJc9SrxoAMUMBvo4C8y+LVpDwh0FPtUIN17CjVub/TGHC3sJ/ecqiRx1+CXhuuVDM08coYLpvkoVmqF220WlKpQQacUHFRn8KahiyqeqZuuDLWtBhxK/rWeDjFGSDfI490zOyx+Rdy+TrJQ50CDtS7K9a7U/TkmlY65w/8uWYyKezT9/+lm0T0yFBCizVecp1H3MmG/wVLQ2n7M4hk00mXaHoFEKMvs4mSa067E1hC167scS0I/CwfzEkYDncNTSySyvJQaxmDvKcpc6/S6k565/+U3CnLOaA15Da4sHxqecuK6KIjc8ABPK4g1ZJP0gbfMWJhCKtDSBtjps9Vq4jdhVqeeZYkxQ5Mx20+mI0IbXdFNr3MFk4DrCdjoUdtmKsD5+4uZ2MOuKmiFvSv5CQYem2njOlnq+uwiRq5pV4B5wxCE/7esQZxNxCIlYW7EnZKh9oKq4H+J4iJ1zR0PdAy9itzCnVTXquDn4ncPZp6zh6w0ztzms9naK+EhtHOLG83hAHuTJpIBVEICYMKkwpDJRqQGgmJIgjVJbwzhwHSMP47sOJrMZfIpAjVjyrRWwHdYlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 08:55:07AM -0400, Yuan Liu wrote:
>Move the overlap memmap init check from memmap_init_range() into
>memmap_init().
>
>When mirrored kernelcore is enabled, avoid memory map initialization
>for overlap regions. There are two cases that may overlap: a mirror
>memory region assigned to movable zone, or a non-mirror memory region
>assigned to a non-movable zone but falling within the movable zone
>range.
>
>Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>---
> mm/mm_init.c | 37 +++++++++++++------------------------
> 1 file changed, 13 insertions(+), 24 deletions(-)
>
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index df34797691bd..2b5233060504 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -797,28 +797,6 @@ void __meminit reserve_bootmem_region(phys_addr_t start,
> 	}
> }
> 
>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
>-static bool __meminit
>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>-{
>-	static struct memblock_region *r;
>-
>-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>-			for_each_mem_region(r) {
>-				if (*pfn < memblock_region_memory_end_pfn(r))
>-					break;
>-			}
>-		}
>-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>-		    memblock_is_mirror(r)) {
>-			*pfn = memblock_region_memory_end_pfn(r);
>-			return true;
>-		}
>-	}
>-	return false;
>-}
>-
> /*
>  * Only struct pages that correspond to ranges defined by memblock.memory
>  * are zeroed and initialized by going through __init_single_page() during
>@@ -905,8 +883,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
> 		 * function.  They do not exist on hotplugged memory.
> 		 */
> 		if (context == MEMINIT_EARLY) {
>-			if (overlap_memmap_init(zone, &pfn))
>-				continue;
> 			if (defer_init(nid, pfn, zone_end_pfn)) {
> 				deferred_struct_pages = true;
> 				break;
>@@ -971,6 +947,7 @@ static void __init memmap_init(void)
> 
> 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> 		struct pglist_data *node = NODE_DATA(nid);
>+		struct memblock_region *r = &memblock.memory.regions[i];
> 
> 		for (j = 0; j < MAX_NR_ZONES; j++) {
> 			struct zone *zone = node->node_zones + j;
>@@ -978,6 +955,18 @@ static void __init memmap_init(void)
> 			if (!populated_zone(zone))
> 				continue;
> 
>+			if (mirrored_kernelcore) {
>+				const bool is_mirror = memblock_is_mirror(r);
>+				const bool is_movable_zone = (j == ZONE_MOVABLE);
>+
>+				if (is_mirror && is_movable_zone)
>+					continue;
>+
>+				if (!is_mirror && !is_movable_zone &&
>+				    start_pfn >= zone_movable_pfn[nid])
>+					continue;

IIUC, when mirrored_kernelcore is set but !memblock_has_mirror() or
is_kdump_kernel(), zone_movable_pfn[nid] is kept to be 0.

This means it will skip all memory regions.

>+			}
>+
> 			memmap_init_zone_range(zone, start_pfn, end_pfn,
> 					       &hole_pfn);
> 			zone_id = j;
>-- 
>2.47.3

-- 
Wei Yang
Help you, Help me

