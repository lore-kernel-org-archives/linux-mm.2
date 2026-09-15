Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D16C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 12:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D756B0088; Tue, 15 Sep 2026 08:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE6E6B0093; Tue, 15 Sep 2026 08:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0F0E6B0095; Tue, 15 Sep 2026 08:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C60EF6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:52:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F5D1A3D32
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:52:29 +0000 (UTC)
X-FDA: 85215985218.10.5A1F476
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 86B0F100009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:52:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W70QDnQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789476747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxbZuNqffFNOIdaT0/KALBdxjs/EeQM9S6uRMEGgp/g=;
	b=b04Cum5xE+C1vvsVi4M0ZE+wu9ni86lJzJN+2qgaYhf8QjBFRNTX4VINSadXdRObhTRlI3
	dOkJNCItUoZxkRT5+oumNMyvPR8TPjpbyOPDn+hOgaS7dSyPf72HKix0tfAub7b4JLkpy8
	BE2/V8pQkGdbZVTK0aj/DBWsg+yjKQI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789476747;
	b=w5aUvrAyFqXGFvmXJrXJzSTew1G1o6acQn/JL943SmFBpK2u2daKXCXxhh5rBBlGl5Fv49
	NVy+KhbJ74bsFLqHdnephTBF6TnddLgK9NnRqksv6mRz6qk8Fe4T/TGjpUep8P7q9OzUOr
	Otq3BOhlNM6IAIxgHxp3h+J/rLZ4Rxg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W70QDnQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 064BB602A8;
	Tue, 15 Sep 2026 12:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8361F000FF;
	Tue, 15 Sep 2026 12:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789476746;
	bh=xxbZuNqffFNOIdaT0/KALBdxjs/EeQM9S6uRMEGgp/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W70QDnQstn6nkN/6eJiK2L4CeDsYQO7VSfN7e5dtSZ9Ip+oOiS4tiuercU+j1EL0A
	 gF+UjpVEYA1DcaJ4esEkfojNun5QzqHaHSgaqvE4BJkRmC0dsCKiGA3dcfX0NtwulD
	 FIUeb+eHkwdo6ox84GTqw6Bw0FMqiazL/tSZ31KRkXk6TAN3a+rFXIC3gMJHzTz91I
	 duvpOe4F6k2PLkHX2wDNgb9YQc2iR3BpMSeRiWY73IG5FxkzTVFzLoQQdOuaZp9IYC
	 agaxHZ1CCCLbjb3uWuLCJoNfjMOGCvR5qAaOaHtNZOPFSExjrWcuzFpyHUZt0fLjTD
	 NudaPCN+36Vcg==
Date: Tue, 15 Sep 2026 15:52:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Message-ID: <aqk_hNZCVCyx5Mj_@kernel.org>
References: <20260914072929.1883794-1-yuan1.liu@intel.com>
 <20260914072929.1883794-3-yuan1.liu@intel.com>
 <aqjfyGeQaL4g2EcA@kernel.org>
 <PH7PR11MB69325D48C3419508FFD8B8BEA3BA2@PH7PR11MB6932.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB69325D48C3419508FFD8B8BEA3BA2@PH7PR11MB6932.namprd11.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86B0F100009
X-Stat-Signature: 9ciz95hafc6hf1wduat3qqag565cjux8
X-HE-Tag: 1789476747-698467
X-HE-Meta: U2FsdGVkX19QI3VfF9HRErFQ+ZcOGrFtug9ieOOPapJ+Gj8fl/te9rps0teayWGIz97yLRSMPBvVGuBDf6hD+HvsIiXZ7blH9ejxOJubs8nLcsKQRmd/+HihBSIljNxDXR5QQI2sXFr3KgehLvH8ysYJv1ihGxMbLDW8suZ3A2xugZACVMkK6vQbJ7bQ3i3epTd1duGXA4cY22IG+Iw8vNMf21XHrwm1YfDbtUwyU0kR/9aWDSLqDcIB0tMwOcv/5p3PjF7kdLHrU41i1GGPtITeU7h0/Edca4ffo1ICQxHuKgL406j+PiyQ1soyTGeSZjA2zTKtFTQS4Ag9pcpx++ai2MBxZWZYNxr020jV6YmVp0u+mU6VrQTrwUUG8ZcxD88XiBJtQX6ZjRS65y/haIvVUtj3nf3s9hz5mQVAx3w2BfUvJL2ctg4UX5kVMnjVGUUqpRNj/OA/6FQR18JJ8gH5OmYaM5y5m/VMHzlN9MkC2EHwRwV/Qx5zSo4QJEAh6QrlAXkcl4oCOzB9ociqo/X1n6e0gqeL1cLSq9aksHK3uLXc3g5GF76CoZbU7WdVIyVtCf3kutR2qunqnc+DuRaROrBmRilpR91p35efK329i9kWs58syN445Vwa2xL1f+dThts+FhAlgA4SpCPbzBak5+1pwe9E8d0xpshVvGl+EPYiKWsTrFCfido7D+DfXK2C8BT94eLVSWjoswn/s61YJCGNHKmD4OIq6XBAaMsn3G922buQ5tJAyK7l6CAiJvAOtSvs0ibH39AVH/M6DXj+EKptXKaDQoNXGmzz9foNjDQd3LgILjrGF4Ph0SAIsYjvd3gtIrkBqOC8o6hyNkL67T5gNJm7AT1LKMfrmxbtYJ3+owV+xnI0c0/m9ub4gMt9LyJ+WeWWnDI9N0wKKwinbhodshtHEqBSI8Qu1DCcsYdFa/9Nvqu6ELPxcOi4tBZ0FEm+S2zQTpFfV8g
 dsDzdu59
 9VNNKm1EFnP/1nh1LGizbiEJoyOYQWSAvA3aS5z5Vpb8JgBYaN8FrZKQoetfECt4sEtABWYqY3xRfitRiv2yKceS71jJ12zavrTxZc24BpZ/6VP0Lu76aWByyPYYITjp1/I/aYmkSjrwg9qHLcAh1/dwso4PEXrjXmtpXydAUpwQN12NknjLWdiI13aFYdQnH3lMy9oSjMRoKg9eo4gh51RqJ/s9kbywSRw2Pax70cceRXcwFbMZdpuetelWU5nRYW391Rig32W3AIIztI4p370pmpxteqFKPk6iBP5cJ4toEQlvp4PQGDZCmGPcn6Gr0IXfjR3ym6YyuLWvDKu+Xe+LWulgBoh/aMPa/GueecN8DOxPxDKgPC8WmEJe+XIGkHgTpu+MkEbNdxyOW9/AQFtye8sgWieXVYmAnYUULi9PlgB8lTrTCSR831zVi3FZ/493Rdj4+J0bRhKqYmQ85rCWfIBVRKxH62QqBuzP2YvdEM/y0e7gO5FsPH3nzOGr69jXc2mOXMAAyR5n/rYD/j2jG63pHp4Ln6WLFjlcdLBRcdPaYFposD8Q/idM9wUvzwayb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 10:40:01AM +0000, Liu, Yuan1 wrote:
> > -----Original Message-----
> > From: Mike Rapoport <rppt@kernel.org>
> > Sent: Tuesday, September 15, 2026 2:04 PM
> > To: Liu, Yuan1 <yuan1.liu@intel.com>
> > Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
> > <osalvador@suse.de>; Wei Yang <richard.weiyang@gmail.com>; linux-
> > mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>; Chen Zhang
> > <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; Chen, Yu C
> > <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
> > <tianyou.li@intel.com>; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v9 2/2] mm/memory_hotplug: optimize zone contiguous
> > check when changing pfn range
> > 
> > Hi,
> > 
> > On Mon, Sep 14, 2026 at 03:29:29AM -0400, Yuan Liu wrote:
> > > When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> > > zone, set_zone_contiguous() rescans the entire zone pageblock-by-
> > pageblock
> > > to rebuild zone->contiguous. For large zones this is a significant cost
> > > during memory hotplug and hot-unplug.
> > >
> > > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > > index 1533aebafb68..d40a8ff23370 100644
> > > --- a/mm/mm_init.c
> > > +++ b/mm/mm_init.c
> > > @@ -817,22 +817,39 @@ void __meminit init_deferred_page(unsigned long
> > pfn, int nid)
> > >   *   zone/node above the hole except for the trailing pages in the last
> > >   *   section that will be appended to the zone/node below.
> > >   */
> > > -static void __init init_unavailable_range(unsigned long spfn,
> > > -					  unsigned long epfn,
> > > -					  int zone, int node)
> > > +static unsigned long __init init_unavailable_range(unsigned long spfn,
> > > +						   unsigned long epfn,
> > > +						   int zone, int node)
> > >  {
> > > +	unsigned long next_chunk_pfn __maybe_unused = spfn;
> > >  	unsigned long pfn;
> > > -	u64 pgcnt = 0;
> > > +	u64 online_pgcnt = 0, pgcnt = 0;
> > > +	bool is_online = true;
> > >
> > >  	for_each_valid_pfn(pfn, spfn, epfn) {
> > >  		__init_single_page(pfn_to_page(pfn), pfn, zone, node);
> > >  		__SetPageReserved(pfn_to_page(pfn));
> > >  		pgcnt++;
> > > +
> > > +		/*
> > > +		 * With vmemmap, at this stage all pages in an early section
> > > +		 * have a valid memmap and are marked as online. However, only
> > > +		 * subsections in the subsection map are actually online.
> > > +		 */
> > 
> > I'm having trouble parsing this comment. Shouldn't is say that some
> > subsections in a section can be offline because of holes?
> > 
> > Other than that
> > 
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Maybe we could add some more comments here
> /*
>  * With vmemmap, at this stage all pages in an early section
>  * have a valid memmap and are marked as online. However,
>  * subsection-sized holes within a section are offline, only
>  * subsections in the subsection map are actually online.
>  */

I don't see how adding almost identical cryptic comment in another place
helps.
 
> > > +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> > > +		if (pfn >= next_chunk_pfn) {
> > > +			is_online = pfn_section_valid(__pfn_to_section(pfn),
> > pfn);
> > > +			next_chunk_pfn = min(SUBSECTION_ALIGN_UP(pfn + 1),
> > epfn);
> > > +		}
> > > +#endif
> > > +		if (is_online)
> > > +			online_pgcnt++;
> > >  	}
> > >
> > >  	if (pgcnt)
> > >  		pr_info("On node %d, zone %s: %lld pages in unavailable
> > ranges\n",
> > >  			node, zone_names[zone], pgcnt);
> > > +	return online_pgcnt;
> > >  }
> > >
> > >  /*
> > 
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.

