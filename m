Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AADDCD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C976B0005; Thu, 11 Jun 2026 22:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE576B0088; Thu, 11 Jun 2026 22:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEECD6B008C; Thu, 11 Jun 2026 22:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA5606B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:44:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620308D0A4
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:44:10 +0000 (UTC)
X-FDA: 84869716260.18.5CC55FA
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5B42D1C000D
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:44:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DJg4zoKP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781232248;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKA0Ut3WlW3n5UQsohG5A8jL7XKlqbjEiKYDixP3dak=;
	b=I24IDDg4MlgfPo8fFeVn/ezgu5E+IBx5SsH7B3a4i/cWOGIjzye/hV7B4lBkZCQswd0UGc
	OZ2IdOVMP3V3TfT+hUEqMcciBPkcsk5rGjKZCWsDALGzlZvUi8D85sG4ARGgisHr3VKtiJ
	Uw/jvaJSR6w+qhnx+BNfCDC8x/qktgU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DJg4zoKP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781232248;
	b=C3w3qG7pMz8BdsFpdiKGAr51dbFjmytQV4dfB0a80wIb0V+GWjO/T3NmT39cSnoW0vSaHa
	2f0a0qBLUb6uPL8tpaaUCVbbjdV4sO1HWW0uLtVRzHybhmwCRUy5WX2F2H4+Rz4zVciIX2
	GEEZy3hudxywxuY5vN5voHyYlcMg5HY=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bf1141c26ecso59908466b.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 19:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781232247; x=1781837047; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKA0Ut3WlW3n5UQsohG5A8jL7XKlqbjEiKYDixP3dak=;
        b=DJg4zoKPCZmrjtm7a3afQrfpWfGOh4+zGCU/X0IxtdXfFnY8T4+Je2144F3bBYOu9v
         evc0nc5BOlENfxkYo6KmuzUp9e9m6IFBc6I3/s+vIpineJDUZ1q3f6WJQwgP8iEdg68/
         7UnXMR58VQMUFRhzchUs60xi4fAhw9xzirwPL2Zf9L/wM1vJz/DwARgPr0e9rO39eACm
         apW15CvODP3yWGL44Y5DwuGvcaYTGsOoEhbBTJMVPwhO8O6PKavndoEsacBheoWgNf+O
         wt/660PkFx1m3/Z1G3IvnqiwL/p5SxVeixziy5AcJFJehCksIqK5RblC+Sg3D/5F4BJE
         hVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232247; x=1781837047;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FKA0Ut3WlW3n5UQsohG5A8jL7XKlqbjEiKYDixP3dak=;
        b=XWVS0nD87vCAkrBihth3d8yuJk5GPVMS+iygmKuinpHhkuThfvlb9gyCeB/Od91BG8
         kqIjSa8mHQ7sNtMLmabiF9d+8TR5RVFLCs2E7R7Z5dLeMxpfecTjQfahGtWAMnUlzD5H
         VYjPNEsd6qKbdslu1OaBgh7BcO/rrvatZ/jeTzkA/19So56LS5Buov+IYhMfk4RXUkhM
         HxuNKgpFIHmyXyMk8q7qiwh7v2X87Or6UF76vjMS9tLGsDwEnlHnKyZ0VUhVLrrdOSxT
         BOC01DHnsMdjUBBPotiwN2yzoa0RwS1Vd96zTtINFZQNPD9o2TFvlZpcU93FKrXT8DoK
         jhhg==
X-Forwarded-Encrypted: i=1; AFNElJ+IqtwWOKfsdFDFOx9SVs6ZH5OWDSxt/50wz1FWzzp6UrIuxxVUZZzO9RtcDMfBKuvLLcNIvbCs0g==@kvack.org
X-Gm-Message-State: AOJu0YzzGUuKmNuhbZOWPkeH6oNun33DNI8lovz+3oXXbN05N3/qmw+K
	42mNWheZwhCBWbby3bpdGVPEPWRKNb5mVSJHyiHQfWqBxGJc9sBZxrnT
X-Gm-Gg: Acq92OGTMXpeyMPK9oLhIwPouCuMwHsY/LIvO3LVm3MZ4TMEvea8ir55nV4Qd7QimBA
	XlTFc9Itp1P2yPaTSDXBiGvVaDP0IaJvvwZLuxciNMdyhnGFNsjNMQ7AqpbDcruimmukknWNfuS
	gpjzvs7pxkPvdH+AXEGc2vfV/2JeFvIa4AmD0vZOY0JIZTtx0RC+XrIAqlc5kEazgksIkJ12kMy
	9UVroqUYFrBqcrbt+NhOYpzM1KLF7Fq9TR3LMIwQg4T3OgI3gijf7acSLrxu7HzwgBYOLdEiTYd
	Kd7SMnuhcpTVVF1z+UpvhmKC+s4I1gVWx/N2meCWfWM0zhm8TcsrcLKy9S+3oGTtKKYFqHI/n7C
	fJ2R87mhrjF3wSm+uKonnSEzXlS2Cxn3dXwa556Ey7ImFQjpoEjjP3YWrHn8xje4oI0p7Y0+FnR
	HjB/635HJPv1mKzo23/Cx2fw==
X-Received: by 2002:a17:907:3e0b:b0:bec:427b:f5b0 with SMTP id a640c23a62f3a-bfe27b26ad5mr21063066b.14.1781232246550;
        Thu, 11 Jun 2026 19:44:06 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb4420854sm46252066b.7.2026.06.11.19.44.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Jun 2026 19:44:05 -0700 (PDT)
Date: Fri, 12 Jun 2026 02:44:04 +0000
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
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Message-ID: <20260612024404.suzszzpzj3x7e7cu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <20260521033303.7jg66h4sxwi4l3cm@master>
 <MW4PR11MB6936A4383B3EC638A4B24ED1A30F2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <20260525083554.6x6l5y46icekegzg@master>
 <MW4PR11MB69363A902465ABC015CE5E2BA3122@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB69363A902465ABC015CE5E2BA3122@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9u8wjt3wdnt4mri4s7x1w8mgnqqhkf5p
X-Rspamd-Queue-Id: 5B42D1C000D
X-HE-Tag: 1781232248-288738
X-HE-Meta: U2FsdGVkX1/gmUCZuZ77RFJPd0TAX+MXXWve0Cn3EAEkq/T7skwVF2M4vGTal0KU8Criz9RVJsDw14DL1ysB4o7bfj6ox9k05hfGZlkci3nDrHQpMAQibvxMV9tt7Wa6Un260/lJwuJRaMzmrV9fVHhQOn3NGGFAQOmzXj/hXDatcxO1teirrQuMprRA50+m6JbSwA2Z+PKG4gHKBCRBoir86aGTf9T3fbYWvoAq+o3J961do3Z7wcmDRlXdv6XtndSQ7qQ59CKvkG4/eQPkgh/r9hfj7d6gVHXEAm3UGdN1mA6oILarH3g68feRMLcCi8ic5AgcBTlLvrqdK12IjbML9FmFpc2CZmVb5KlVHOUttsjWGLV4PErK5QWk2sIqAxKbpMLrZqIky9/idCgelTpLeXeRDxzmh0z8hy1kRqgBOHD/uFT4rVGP/NumQsyGZV7olAwOdMu5g33k+/Hz25/czMOxddivMXThZMNwgUdKaCxJUG/md2OAqlk9l5Ws3UloKVw4SixeyFLorhf6vAzXa8/qc/gKo9s6NT/9A3+MxVOcLMCwKdlSSWf39JqS2uxyGixf9Af0RWPdzJ5RPiMFSvnIrTc0K9Yk+90FESvkDZ7/yaZGsXitXEZXEmrBKvPGv9+FdW0qAqVSZQwOimokaHd+Eflx1yhzeksXx2xqezmO5g5iZBFtloqmmPXtq4RLGtz2zt4rYyUI/+4e5KdHu1Mp2yFuDuzbaIcpJGw9LqPGmrfCj4Egvpe0z1Ct8XBCZquVumR9BCr9emnCMm3FHNyr9S1D9g0t5a8kQWG6bQ3ap85CCUyJTMelxrL30l7IDl21KkfQDqAvlJOlBdcmYwW7LYIXxqmIBbqMO3loLL54Zo5KHepQIVOJLdOrd2g+nFFCIEaU4rPkxFz0PkwDCjf4vyTGBOmHSXHufZJW5SXvqlexoZN00FRaTBA5/OaOSKtzfjpHJ04aDX2
 dIk4ZaCk
 wZk/HsTEQJjLbhKKNaC15vF4zHs+Q9jyMAbmVf+l+HdycVv/8IXZWQL54n08THZ8oxksQ+i0jGo7Fo2+mlhEHvkAKIo9apUeBRPEM2Vbgjlu6wjsIEsR+BNyZneo/W5Hg0DzjUWLgTi3P7ZdgZZlQWz6hfTysNwiJD5+yUKlbmgvMEsJ6bledMrTnzi0MQcO+mcyvf+THDiHjyjos9Ms2TEdhTpq4BmRQprKG7FQ2WvFdiOKz5rNvnRJxjUyp2ZR0l8ghBzenlYko63HH2VibGXO+uZ60FbP/HbqCE1Yn2DFYFp1VD6yuxzCuqhCulhV0/YA1xDghA1INNfxPvg2iqsvDlehL/AVXhr5xg6SUYOkzmE6dXnft444T3ePSYCk6OSqIilW7tEDOleFPTl3TEIrsRBKp5CTKYKchH1bAkEsMz6Ucmcih82Ph1m6aKzsUyeL7lGcIUQ6Kprxp1Fa4ER755dxEDtYoIAO7mQt5BfQg+OnyqcjhKiwg+Rehy2mCwkxdrFklcWS5mFMH0zVjrHfJEO3Vh+Kty76qJy57g3RtFHW+JQv7vv3jN67UlYOTu/8mxpLd22yN3oiagy3jkXGLHhQUvmBRNwx0oMqW//QxNFJ1upY1l/Y8wEL59Fg0ZWH76R5BjrajFdaVrD7km1HhLjwAJxZOLb+cO1GUcWxrPj4IzyEKBxwIc7IJlDSPzt1SZt0aFETm4EOtdXmGqg1BZzZkgUkz+tcqJEspxLDRFT48jidheOdUzeKxftzh6II2LeoROV7TqiKNa0Z7vQnwHOQrYyO8L/NvzlqBrmCKXl98kYHg2mqs2ICdJpUWMxanAztSlqC2Ly1siPI6sA5nq2a74NIlnk+y8Bc4l9CMRYLIexRDA5MVXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 07:55:11AM +0000, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Sent: Monday, May 25, 2026 4:36 PM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>
>> Cc: Wei Yang <richard.weiyang@gmail.com>; David Hildenbrand
>> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
>> <rppt@kernel.org>; linux-mm@kvack.org; Hu, Yong <yong.hu@intel.com>; Zou,
>> Nanhai <nanhai.zou@intel.com>; Tim Chen <tim.c.chen@linux.intel.com>;
>> Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Yu C <yu.c.chen@intel.com>;
>> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
>> Zhang <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking to
>> the outer loop
>> 
>> On Fri, May 22, 2026 at 07:43:38AM +0000, Liu, Yuan1 wrote:
>> >> Subject: Re: [PATCH v5 1/5] mm: move mirrored memory overlap checking
>> to
>> >> the outer loop
>> >>
>> >> On Wed, May 20, 2026 at 05:34:53AM -0400, Yuan Liu wrote:
>> >> >Move the overlap memmap initialization check from memmap_init_range()
>> >> >to memmap_init(), and replace the per-PFN check with a memblock-based
>> >> >check.
>> >>
>> >> The description is a little simple.
>> >>
>> >> Even I know the purpose, I feel confused at the first glance.
>> >
>> >Thanks for the review.
>> >I will try to rephrase it and provide a clearer description in the next
>> version.
>> >
>> >> >
>> >> >Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> >> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> >> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> >> >---
>> >> > mm/mm_init.c | 29 +++++------------------------
>> >> > 1 file changed, 5 insertions(+), 24 deletions(-)
>> >> >
>> >> >diff --git a/mm/mm_init.c b/mm/mm_init.c
>> >> >index f9f8e1af921c..24e103a402b0 100644
>> >> >--- a/mm/mm_init.c
>> >> >+++ b/mm/mm_init.c
>> >> >@@ -783,28 +783,6 @@ void __meminit init_deferred_page(unsigned long
>> pfn,
>> >> int nid)
>> >> > 	__init_deferred_page(pfn, nid);
>> >> > }
>> >> >
>> >> >-/* If zone is ZONE_MOVABLE but memory is mirrored, it is an
>> overlapped
>> >> init */
>> >> >-static bool __meminit
>> >> >-overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>> >> >-{
>> >> >-	static struct memblock_region *r __meminitdata;
>> >> >-
>> >> >-	if (mirrored_kernelcore && zone == ZONE_MOVABLE) {
>> >> >-		if (!r || *pfn >= memblock_region_memory_end_pfn(r)) {
>> >> >-			for_each_mem_region(r) {
>> >> >-				if (*pfn < memblock_region_memory_end_pfn(r))
>> >> >-					break;
>> >> >-			}
>> >> >-		}
>> >> >-		if (*pfn >= memblock_region_memory_base_pfn(r) &&
>> >> >-		    memblock_is_mirror(r)) {
>> >> >-			*pfn = memblock_region_memory_end_pfn(r);
>> >> >-			return true;
>> >> >-		}
>> >> >-	}
>> >> >-	return false;
>> >> >-}
>> >> >-
>> >> > /*
>> >> >  * Only struct pages that correspond to ranges defined by
>> >> memblock.memory
>> >> >  * are zeroed and initialized by going through __init_single_page()
>> >> during
>> >> >@@ -891,8 +869,6 @@ void __meminit memmap_init_range(unsigned long
>> size,
>> >> int nid, unsigned long zone
>> >> > 		 * function.  They do not exist on hotplugged memory.
>> >> > 		 */
>> >> > 		if (context == MEMINIT_EARLY) {
>> >> >-			if (overlap_memmap_init(zone, &pfn))
>> >> >-				continue;
>> >> > 			if (defer_init(nid, pfn, zone_end_pfn)) {
>> >> > 				deferred_struct_pages = true;
>> >> > 				break;
>> >> >@@ -956,6 +932,7 @@ static void __init memmap_init(void)
>> >> > 	int i, j, zone_id = 0, nid;
>> >> >
>> >> > 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
>> >> {
>> >> >+		struct memblock_region *r = &memblock.memory.regions[i];
>> >> > 		struct pglist_data *node = NODE_DATA(nid);
>> >> >
>> >> > 		for (j = 0; j < MAX_NR_ZONES; j++) {
>> >> >@@ -964,6 +941,10 @@ static void __init memmap_init(void)
>> >> > 			if (!populated_zone(zone))
>> >> > 				continue;
>> >> >
>> >> >+			if (mirrored_kernelcore && j == ZONE_MOVABLE &&
>> >> >+			    memblock_is_mirror(r))
>> >> >+				continue;
>> >> >+
>> >>
>> >> So you have figured out the memory layout of mirror memory?
>> >>
>> >> Would you mind elaborate?
>> >
>> >I have a Xeon server, collected mirror memory layout information as below
>> by using follow changes:
>> >
>> >int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t
>> size)
>> > {
>> >-       if (!mirrored_kernelcore)
>> >+       int ret;
>> >+       phys_addr_t end = base + size - 1;
>> >+
>> >+       pr_info("memblock_mark_mirror: base=%pa, size=%pa,
>> mirrored_kernelcore=%d\n",
>> >+               &base, &size, mirrored_kernelcore);
>> >+
>> >+       if (!mirrored_kernelcore) {
>> >+               pr_info("memblock_mark_mirror: mirrored_kernelcore not
>> enabled, skipping\n");
>> >                return 0;
>> >+       }
>> >
>> >        system_has_some_mirror = true;
>> >
>> >-       return memblock_setclr_flag(&memblock.memory, base, size, 1,
>> MEMBLOCK_MIRROR);
>> >+       ret = memblock_setclr_flag(&memblock.memory, base, size, 1,
>> MEMBLOCK_MIRROR);
>> >+       pr_info("memblock_mark_mirror: marked [%pa-%pa] as MIRROR,
>> ret=%d\n",
>> >+               &base, &end, ret);
>> >+       return ret;
>> > }
>> >
>> >Here is the detailed layout information:
>> >
>> 
>> Thanks for the detailed output.
>> 
>> After some investigation, I got two things to discuss here:
>> 
>>   * current mirror memory would disable memmap defer init
>>   * confirm the mirror memory layout and may simplify handling
>> 
>> Before discussion, let me mark the key point in the output below.
>> 
>> >Case 1: efibootmgr -m t -M 0
>> >Enable mirror memory below 4GB, and no mirror memory above 4G
>> >
>> >=== zoneinfo summary ===
>> >node   zone       start_pfn    end_pfn      start_addr         end_addr
>> >------ ---------- ------------ ------------ ------------------ ----------
>> ---
>> >0      DMA        0x1          0xfff        0x1000             0xffffff
>> >0      DMA32      0x1000       0xfffff      0x1000000          0xffffffff
>> >0      Normal     0x100000     0x7fbffff    0x100000000        0x7fbfffffff
>> >0      Movable    0x140000     0x7fbffff    0x140000000        0x7fbfffffff
>> 
>> (1) Normal and Movable zone end with the same address, so overlapped.
>> 
>> >1      Normal     0x7fc0000    0xff7ffff    0x7fc0000000
>> 0xff7fffffff
>> >1      Movable    0x8000000    0xff7ffff    0x8000000000
>> 0xff7fffffff
>> 
>> The same as (1).
>> 
>> >
>> >node  start                end                  size              flags   mirror   pfn_range
>> >----  -------------------- -------------------- ------------ ------------ --- -------- ------------------
>> >0     0x0000000000001000   0x000000000009dfff   0x000000000009d000 0x2    yes      0x1-0x9e
>> >0     0x000000000009f000   0x000000000009ffff   0x0000000000001000 0x2    yes      0x9f-0xa0
>> >0     0x0000000000100000   0x0000000066416fff   0x0000000066317000 0x2    yes      0x100-0x66417
>> >0     0x00000000777ff000   0x00000000777fffff   0x0000000000001000 0x2    yes      0x777ff-0x77800
>> >0     0x0000000100000000   0x000000013fffffff   0x0000000040000000 0x2    yes      0x100000-0x140000
>> 
>> (2) You mentioned no mirror memory above 4G. If my understanding is
>> correct, 4G's
>> address is 0x100000000. So why this range is marked mirror? Is there some
>> limitation for this?
>
>Hi Wei
>
>efibootmgr enables mirror memory below 4 GB through the -m (--mirror-below-4G)
>option, and configures the percentage of memory to be mirrored above 4 GB through
>the -M (--mirror-above-4G) option.
>

The efibootmgr command used here is: efibootmgr -m t -M 0

This means we expect it configure 0% memory to be mirrored above 4G. But we
see the range [0x100000000, 0x13ffffff] is mirrored, which is above 4G.

Also for the range in node 1, we have mirrored memory.

So I am afraid the behavior is not what it literally means. Or I missed
something?

While more critical thing to confirm is ...

>My understanding is that the layout of mirrored memory is determined by the BIOS.

... after the BIOS configuration, kernel would only see
contiguous mirrored memory for each NUMA node, right? So that we could handle
mirrored memory correctly.

BTW, I mentioned two issues in last reply:

  * error on node span calculation
  * defer_init misbehavior with mirrored memory

Have you checked about it? Is my finding reasonable?

-- 
Wei Yang
Help you, Help me

