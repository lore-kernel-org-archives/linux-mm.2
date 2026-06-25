Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E122CCDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 09:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C413D6B00B7; Thu, 25 Jun 2026 05:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCBB46B00B8; Thu, 25 Jun 2026 05:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A94B26B00B9; Thu, 25 Jun 2026 05:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F0CB6B00B7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:58:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 04574120622
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:58:50 +0000 (UTC)
X-FDA: 84917986062.08.8D5E194
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28F5B140006
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:58:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KE+1w3WQ;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782381529;
	b=wXfnd5uwJsgz/7Ivu/mXIuyCOHVtcoL1NbCXRBhE5naXQ8L/Vc82ep7+akjnhBSwZQsN1J
	yZyTlE6z/rzHAN4lOcs+mWWcasDriyJhSkgfu0jNMAJyycEYthLWfFMiUjIn21CeQ1eYBH
	GtubjrJAf+ik1V2dDTQMcpGZ++e1KTU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782381529;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+mgaYB1zk7FVDo1slH3uPPqS1c5uJ+o/ELPZE4pSZw=;
	b=vTgaG9bUyccsxcFcket8i88zMC2xzqBfQq/PgI903+n7yepL8qqAlMMAHtpqDQQHvC+PPN
	cn1otV+P1eo80HosX2UAEOsmI/qtFzPaDYM4goYzihP/ceWSKl5yyw8i41S4VugSr79ai0
	F0G/juy9ruJgKr9GFpC6ZgUDejaYjl4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KE+1w3WQ;
	spf=pass (imf26.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c0c15bd6b8fso261679366b.0
        for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782381528; x=1782986328; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+mgaYB1zk7FVDo1slH3uPPqS1c5uJ+o/ELPZE4pSZw=;
        b=KE+1w3WQiHu7L7+crrFsiAv/ssRLZLPNvi9DnNjA8tI+u60BEEj8S/sM+x/Alsjiup
         IMtdi7yMPUBbDWgotfYw1RbHRv5zphjSvc+PdSSGrrRCygvJEYNv9/yL8+HMhy4esofH
         NlXReASFxaSyGTnSCdqrJvZ5B5QJJJXFe2fI6rY2nuSevUUWVHV0ZjXrjBQaWXqpgubX
         mzu/qQIPLWfMJLA21vXTHHG1lOsQ+XceJoGMhTaRPTdna9fmXccU1DZktln+EJzzp6IK
         dHJ7VuEciSUH2npLv4woyedZvFEJNWp6mFZ/VU7PaVc44dxTCxTLlqiZgJmAb0+OMSlm
         bOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782381528; x=1782986328;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+mgaYB1zk7FVDo1slH3uPPqS1c5uJ+o/ELPZE4pSZw=;
        b=J9ljp3rVs3L0DylBk9iR1NeBaSrpFm7eQes7L+seCN9va0PWns3G5Xcm+fABGai4oj
         ABFy+CpCff0SQ4kPcIdK/6+UYC1kAt4q14XLusp1dkFFl+Qtlnye1+Mg3wDS8xmN6p8H
         t6dqE+UeXzCiWxzZPJGBNy9U7tEZ3j3CoOjI/jRAGTkxn1EQn33QuhWihsEXcwqgInqB
         qO3y+yWNKVOxNEN1KO9/SgSZun6Ovn7UmBaNXuHV/1gpYaZcAvcafCBfO0+ra+XkOIdn
         JRGATJvKmqRUd65M2jtzooOBR6/25HeIXzBGQ3+wQDFOpWc4KDuUncWk46TE1K+vI90L
         euaw==
X-Gm-Message-State: AOJu0YzepAXjYERtaKBqDKXdlc7SdSzQBRQu82rbBLD5ZEdT3i1E+BU8
	6tb+y+9M7NOgxf2XzPNeIIIv1ZSKKpv8r+8QVIMjuzK9dzKjq9k1ZFzi
X-Gm-Gg: AfdE7cmLDZCOrk2HbC5zXkfaw4vT1yH0Gi0l4q16ukZIVQ392+3cAvmQB33PW1dnYEJ
	0/8EV/Z2lidKC9jJx6JpJJMM2no0mIxMQXYxLKcn2zcMrV6dUelGKNaYutAFynceBhI09eda8Ud
	DJ/FmOFWid6WNmLscaauHco+3wn1l7/ONbcxqTtt5F3jolVtcL3HckPaT+sx4lk1iZe1lf1CuG4
	jfRuxxm77vSi7rjYjjiidjCd4NcBJWYVsDI/ntLFa1hr8Jh66kpsbIkU8Nc1/SODoAwRjFG/lF6
	dRiNQMvfBdxrl6bAUIxNZLfYfmOhTM7bbkJe4DIl4W206ncmCavBgpAHQHkMR+zCagXq+yllcVf
	PcEodwFkpMOyM5pMMmvBpPS6WZgs4iZnHytGWKLmWCkfkTQ7WIgGGfM+we26QFEKasAZUjZd2qm
	c7ZHACG/IQmLA=
X-Received: by 2002:a17:907:c084:b0:bfe:fa65:771b with SMTP id a640c23a62f3a-c1205eb808dmr113755466b.26.1782381527769;
        Thu, 25 Jun 2026 02:58:47 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbc27e76sm149199566b.27.2026.06.25.02.58.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jun 2026 02:58:47 -0700 (PDT)
Date: Thu, 25 Jun 2026 09:58:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Taku Izumi <izumi.taku@jp.fujitsu.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yuan Liu <yuan1.liu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mm_init: drop overlap_memmap_init()
Message-ID: <20260625095846.4e2tl3fbduc24erg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260625073941.145014-1-rppt@kernel.org>
 <20260625073941.145014-3-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625073941.145014-3-rppt@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 28F5B140006
X-Stat-Signature: 3sw68bnmys7tdtwbx4iedbqc3xhgr96d
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782381529-843085
X-HE-Meta: U2FsdGVkX19nIPoDxQjBxmVfuFAQMCWBBHn3rdBn21tTljstLgouxI29pFKKUv6VxUJdgqL36YhYZMYbzx6Wnynj24FvypJQTbr3zOFpvE1ZzlyRR1eATu90JcANSYyBGNd4oRPXUgsXiIKs4i9Pvilrey5HEtycsmFihq4hC4iRaTN16nHmol29IgCzYsNltqaWWupoghVrTOGGT9CkbTVDxaFPLH++qFT7UaY1n5AtceJujNmmUxJndvgWiWajdXYltK+H+pxwYRyzVtw4vMKPItnuW4qpbdspF7+6RxVn6FwnftlNbziuApq0k1OWwiSXfHkLiQqQHyTnhvURTP4yHIprZWijap/Dx5wC6lvDR0ie/J+AFxf8td3KE4fdN4hR6/5npQjiX0ogMw7UsXNwq8GBgbiFqgLMDWcfucCPWMXZAoCtS9wBj+G7aHu3qqncc81DS81n/2uHcXyVlExxiMxQYH7cZcZXVljPS24X1YQsVGnZvk+Sdlbhc9OnE9NROxCt7t0bixzS6UEt/4hOrquRhzL6Df9/ofAC3Zcqb2ai/6OTjZ3htHyNvXEu+81MqKWYk0S76Gic+jQlVbBoVypyT8P9lTjGmC1TjEqRKnZWA5woRwENRJa0KkCntI2oOvLf/Z3virbt+2+MMfF8LaSMRg7GXBGCO25W7kDy2c+rAhfifdVjfSygTg73biTCC46QIPXwy/x7pkoJAlbCDg4Dh4ScNpAp2vVPwa3excatfRECHJnkFDvKw3hFphpeyLtAavKDuMoLL9xOdcO5Ow7KAhKEIsVOD7WEE8KonEJ/ZXn000H1p8HXduEGyKeJdfkKS2cVJeaAN7X5bvcjYB23xaGkDVHb4T44m0Jx4Hh+yQ/hh+Z0Yu9hUjJTIbMRF2YGGNMZ562vKOBdCBz4yjN4MJWbvDZB1ll4gQoKAR3X1+CeMWRLulBPwMrOGxHZRkKIYnQ88AmqiaA
 P0xDgloH
 pbIo9cYGGa8yOLAzwlaUAyDO26HsgJzPaPhECV6gczyuYKfTvdLnwZ6AHPEt9RBhdBFFkhKvyZ+mekK1y9ZVGCuFdH8BulvnTWlFKW0Aw3ju4Y9hxagf8LV017Z1G6FZoa/E8f7Ey8hjiOi14oc5i21hxtFMy79NXSx688WrFN53CV1dgZ9BkcBUqmbA4adg4WYRu54CHQuE2wYxgZmTdfQh3b6CTH7MbqX5sHEmTZn3gmUaATFJ69vQSHGHf37OBNEBNH09g+QEWqHzxJL03lpckZmQMQjygIORg/1wi344rO6MWzDrCiqC+YeFKXn3x+EMtEEczg2aZuDu5x5tLAeyc66zadjB/QMfJTevbElibslJn7bWDCUitalHuqLGT8t7u/YK1f16TM4knkGNx9JSQn6kr5lIYsiNcABEoCBdxku99h73sxAZDSbAAyJoilC6IBtxCB+o4NvINcWxE0ZJhi6CK6+ts2YIN5jF0wNH4wd2BnJvrMO+W7/3NDnq1rrV6JV1yeG52VSBcfLDmQB/tSi03+Rw6VNAGpj4z8o4aGonDQ6DQxquZ08pgD6b4sDDJju4zLyZZFCYNxTVErDRc8SAko7FKTqLVKuDyXEVldkL9jdo+/hTC2YkIOlIphKgASlriFsdXJrflVisBXf4LD2KhKTwFGDyyY+6tFhviqHoIQYSbEF9EztrhOmpeC4hyt6N49gLe6sJTN3/j87ClVdsv1JNzDT5RXlQ3BPhLF8ondYiVy9WUFxPxtkXFladkc22QLw2bYM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 10:39:40AM +0300, Mike Rapoport wrote:
>From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
>When ZONE_NORMAL and ZONE_MOVABLE could overlap because kernelcore=mirror
>didn't reduce the span of ZONE_NORMAL, initialization of the memory map had
>to skip overlapping pages during initialization of ZONE_MOVABLE to avoid
>double initialization of the same struct pages.
>
>Since kernelcore=mirror works now the same way as other variants of
>kernelcore=/movablecore=, and adjusts the span of ZONE_NORMAL, there can't
>be an overlap between ZONE_NORMAL and ZONE_MOVABLE.
>
>Remove overlap_memmap_init().
>

Hi, Mike

Do you think this is valuable to mention the double init for the overlapped
range?

>Co-developed-by: Wei Yang <richard.weiyang@gmail.com>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>---
> mm/mm_init.c | 24 ------------------------
> 1 file changed, 24 deletions(-)
>
>diff --git a/mm/mm_init.c b/mm/mm_init.c
>index dce9dc9f2302..6f0a71ccca30 100644
>--- a/mm/mm_init.c
>+++ b/mm/mm_init.c
>@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long pfn, int nid)
> 	__init_deferred_page(pfn, nid);
> }
> 
>-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an overlapped init */
>-static bool __meminit
>-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>-{
>-	static struct memblock_region *r __meminitdata;
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
>@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
> 		 * function.  They do not exist on hotplugged memory.
> 		 */
> 		if (context == MEMINIT_EARLY) {
>-			if (overlap_memmap_init(zone, &pfn))
>-				continue;
> 			if (defer_init(nid, pfn, zone_end_pfn)) {
> 				deferred_struct_pages = true;
> 				break;
>-- 
>2.53.0

-- 
Wei Yang
Help you, Help me

