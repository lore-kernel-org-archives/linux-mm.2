Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE3ABF588DE
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:03:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083EA6B0005; Mon, 20 Apr 2026 10:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0351F6B0088; Mon, 20 Apr 2026 10:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4496B0089; Mon, 20 Apr 2026 10:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDA8F6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:03:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79155BC35D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:03:39 +0000 (UTC)
X-FDA: 84679102158.17.2E6E797
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id ABAA0160014
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:03:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bpe+6CmT;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776693817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNgNvY6P366syo0752QeQBx8B2Atm3MzK7wQ6o//uMA=;
	b=O2nOpvuKdv1iEgo51ZSheEtUvP/sVnNMGiv0ZXZkSzjV7y8W5fomnDEZaEXYGfF8OlOi++
	baHuxJAT5Rb5uUhpCX3IoU7XJiJgvjESECAddQYt7/NW9klQPohof14+OJd3BlUy8rj1QN
	+bAJELSjnOmPZ0L6a9QjVIhGy2Ou1MY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Bpe+6CmT;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776693817; a=rsa-sha256;
	cv=none;
	b=DkDNEofn14Vw49jG50rmwXx1RLa9FHvVcQXkxKM2hivK+8ABuuuygZXT62skAs7mUVicgC
	LTUdCUZ4p/+oT4XWfVG8e1hGVu6z9d93GUmIDMr15LGX1Kl9Lu2RIGHo1viYeqVNbEFz9G
	sznb4yDSI6gB83ghex7BQQLUs/+rAmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EFC4060141;
	Mon, 20 Apr 2026 14:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC81C19425;
	Mon, 20 Apr 2026 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776693816;
	bh=OxuN49bK9qrmMSMd11iXbzEzvR4ZpTtBtJ1jENfQcdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bpe+6CmT+5l2LxfZhErSNVrhTl2np05OftUtbE0d/+4jIZEHNdtkB3Eb9oXCwmh7S
	 eYPTeAyLFi5DX2ye5zDrqoIU3R+ffediBPC0fHYqmiiU8A8Yi9RJzj8Q0F+2BCBaww
	 9WXMWw+70oP+sHyb2hLq01uUG/2SlaQqPBhN2LyGGFbvoiXL5rmQhyxC/pc7IUASM3
	 e8ZL6eM0SRk6Cwd7fDzyM33ZeCJ3mU19eALR84hl+c21G0G/b1XnBVqoV+APUy54IC
	 7y01hgTX+UNVBJPhwy7VPYSpd3q66lP/2lxDlSJcFic97WYahmu5Mqpso/nJ0qpCsT
	 56pGO+RzKTEDw==
Date: Mon, 20 Apr 2026 17:03:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
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
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Message-ID: <aeYyMFKvR8MZO6Tq@kernel.org>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
 <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
 <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
X-Stat-Signature: mdxqnie6wgma9zwpy9phuodzn78tks15
X-Rspamd-Queue-Id: ABAA0160014
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776693817-693356
X-HE-Meta: U2FsdGVkX189LlRh8BDwwd0x0XIGIa0nS2YT5QN5+clQ8O5kANhf5I9cBdct+6PG2cAktSvxkgszYIOMD52KbjKateUxgTlwkQb8guLm3R/MUgn2mu6DEYVpUIYccIag1VRBlJKGeeCWQRJGIb2n1HreADuO27fqEWzeEgb2bcDB487hrW54n8wqR5fs60jMPdFn/kr38jSgSP4gZV85w5yvvP762gpokWpgjE8OLkh27CyhqXYnaB9ZcyTV0yRWqQLErQ/dh6prPDF/f52+xx2gawcNNDJlnkN79k50tODx/RHIV/5otaOTUK/0225uM7dPa2ndr+ePyfNuoHm4oX+A/NoCS7uVOoXwwfp6vzsPKcSa57gGFWvHIDtFvyiC0sUj8SXJupGerZ0fjLjYWpVPH4honl26x8LBaOCuw+K8zMc4s8ZswU9dUkYPeIuObo9g5R73F9YzxmYzdJ2Cm8my2MhamZe5MaNy7NORcLyqc7C2nkOoSLINI1TcxFWEB7qpdDORCab1h7XTrR0wMt8StbtIw1apRyhLfpORFW7IKHRIK5KPzecfy0MXiDrKI4CrLcS+yW/9YjNO4KG1Ju5Ogb4VvnRddrGMt5VhztjyyCiXm5PArB5NKNsoPDP5OQK2vraFBUloRtoCk3X749t+K+fkdXKK8w4i/Ju3VRITzBdpHmICXcPlHqoOG1DhZeilRGw2Y9Mbka/TOXE0Og95HiEt/AZFOm5ESQsjkg9rZO0gLzdsyGqrHS/5/hd6WHwYL3x0ee4rIJf4fcNO8kplcpI5OnmllFL7oDJS0/a3GvqYFxGhm2+TD9R1dN60WZBUdPLvwjrmJCiqEik65HhsHAK6WrUKtTWNN1UIdifx0LC3xFCKr1pOXXyATXSamshEfGGB8eALSunpYJP2zHCQllft1Cn64g14kwYXs7huey5pvGhfOtEu12m29DIai7W0a7HbHpPxPjUxtnq
 rplJzilG
 XIT1V2ScImGS/IiwJ4rI7ojsc8Ygd4g1zbL/dz9X63sgquqdB3MqUPGwt4Dp9x2ZxBhQve9FUERQF2IyF3AfUfShwKD6UVRtgS/lKcrkkCr/WT5FLaQpyMhWj/ZIG8DVvvTDStuu+NweOUE+vBQY+ZB8HXigZyfGCBhxo74MY9THla0RYytCj35zh+cIKT3ps6yOUtqI6AQg872KEHRKA1fI4qSqBYmRVcX9x+f/XA9YsF3Dw1fqZ/c3DuQSTvi4aqOte9sxjHDtTiB5wk2dc5pk3L18hLqg3GYSu84h05iPnLmp76jDYZv+UekOSKakm2bn1032Boo+paTS0IYD8WOCjx1ADXFvRIVit32moPmDCa320uv7qjF6OCJHVeQRSZoJ3mbakRQ7Ns31zH6dFP5ZIPRStAMMxq1ycEukbIAKCXoTX+n1YvC4cbVvA9Dn6LsmUMN+G6/7uKMjckUgzNhYPTpMPBeKW1mfJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 06:34:50AM +0000, Liu, Yuan1 wrote:
> 
> > >>> sashiko had several comments
> > >>> https://sashiko.dev/#/patchset/20260408031615.1831922-1-
> > >> yuan1.liu%40intel.com
> > >>>
> > >>> I skipped the ones related to hotplug, but in the mm_init part the
> > >> comment
> > >>> about zones that can have overlapping physical spans when mirrored
> > >>> kernelcore is enabled seems valid.
> > >
> > > Hi David & Mike
> > >
> > > I’ve spent some time working through these issues to better understand
> > them.
> > > For the overlapping physical spans(mirrored kernelcore), should I avoid
> > counting
> > > overlap_memmap_init in memmap_init_range in the next version?
> > > For example, change it as follows:
> > >
> > > +unsigned long __meminit
> > > +memmap_init_range(unsigned long size, int nid, unsigned long zone,
> > > +               unsigned long start_pfn,
> > > +               unsigned long zone_end_pfn,
> > >                 enum meminit_context context,
> > >                 struct vmem_altmap *altmap, int migratetype,
> > >                 bool isolate_pageblock)
> > >  {
> > >         unsigned long pfn, end_pfn = start_pfn + size;
> > > +       unsigned long nr_init = 0;
> > >         struct page *page;
> > >
> > >         if (highest_memmap_pfn < end_pfn - 1)
> > > @@ -893,7 +897,7 @@ void __meminit memmap_init_range(unsigned long size,
> > int nid, unsigned long zone
> > >         if (zone == ZONE_DEVICE) {
> > >                 if (!altmap)
> > > -                       return;
> > > +                       return 0;
> > >
> > >                 if (start_pfn == altmap->base_pfn)
> > >                         start_pfn += altmap->reserve;
> > > @@ -911,6 +915,7 @@ void __meminit memmap_init_range(unsigned long size,
> > int nid, unsigned long zone
> > >                         if (defer_init(nid, pfn, zone_end_pfn)) {
> > >                                 deferred_struct_pages = true;
> > > +                               nr_init += end_pfn - pfn;
> > 
> > It's confusing. Could the remaining range also include overlapping inits?
> > 
> > Maybe the whole "skip overlapping init" should actually be handled on a
> > higher level?
> > 
> > I guess we'd want to skip any memblock_is_mirror(r) regions entirely.
> > 
> > @Mike?
> 
> Hi Mike
> 
> David suggested moving the overlap handling to a higher level and 
> skipping memblock_is_mirror() regions entirely. I think this makes sense.
> 
> Would this work for you, or do you have a different preference?

Looks about right :)
 
> Something like this
> static void __init memmap_init(void)
> {
> ...
>     for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
>         struct pglist_data *node = NODE_DATA(nid);
>         bool is_mirror = mirrored_kernelcore && 
> 				 memblock_is_mirror(&memblock.memory.regions[i]);

I'd add a local memblock_region variable.

> 
>         for (j = 0; j < MAX_NR_ZONES; j++) {
>         ...
> 	      if (is_mirror && j == ZONE_MOVABLE)
>                 continue;
> 
>            memmap_init_zone_range(zone, start_pfn, end_pfn,
>                                   &hole_pfn);
> Best Regards,
> Liu, Yuan1

-- 
Sincerely yours,
Mike.

