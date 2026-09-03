Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67927C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63ADE6B0096; Thu,  3 Sep 2026 06:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611CE6B00A6; Thu,  3 Sep 2026 06:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527FD6B00AA; Thu,  3 Sep 2026 06:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 300566B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:40:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA07CA452F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:40:13 +0000 (UTC)
X-FDA: 85172106306.09.C1D17A5
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9125040007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:40:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IpHCXVTb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yL9nMtS62QK3zYwx3B5GW9BYRqbY/gYOshDMmkR+f8c=;
	b=ZoaTsdJ8WyYoHLO9owrjdmVeINeOVW4B2QS7usunGcmP/Tc48xWmfAUnOsLvntIEiWKjKh
	VUQCbwonixUnsfUFbuLSM0QMkN+Yt41pjb9q5R9StjHBXUhBp2qFYav8/9W7xBbDjd7oVd
	BywjZW2D4kVibappok7Q8Mh40xlygoQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IpHCXVTb;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf11.hostedemail.com: domain of yilun.xu@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432011;
	b=mcRCHDaoXbP0u99F7mnMk/gMlYT1jnPWQsbx/atHmMEfPr6OloxybVrF82scQHJOB8x+fR
	rEAhlh8A0Hdu5G2YjiP6wMRNti5eK0u0VWwIYQZ5BkC0wpIZzEC+k+jXF+LeTKmJqX090S
	8FDm5KlQO+DR53Hu7avXChPL0st54kE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788432010; x=1819968010;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BYVJynyohII4KtOhdVCwIs7zjy1IbgGwaJjNCx9gEDs=;
  b=IpHCXVTbWa/cV2I3bv2jF4xZNqFTOV7Wl/vlu8kICN8YPFG+xzlRZWbF
   FeHL1p+UO04gQOlXRQ78BOOHMYn4sxfLSe+YWMd3v/3+HK+eWX14mSpqf
   7xJBuVFOV1F/bvlVo4uNyJTBgO+wuG2hOF8vGKsGHNct2DWd8BobgN7kO
   FcCUKfSWer24WaqJZgLJRqiXmgcrZUunhY4/Ehn38BwC3aLUq3G1LzCx5
   ASayFEaDnUNnwrW50MCl3oNwmYmiAcAVDRR5M5uWTYyLN29Mzt3bHnT3A
   /zyDGEqRdrDoResGWxzU3UDUW+rb+KbkEFv02WW/g7lolX2mOcO2ONrpW
   Q==;
X-CSE-ConnectionGUID: ttFw1rERT4+J4E7tA3yXbA==
X-CSE-MsgGUID: AM4afrpeSAKhlrLltWzdJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="106430690"
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="106430690"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 03:40:09 -0700
X-CSE-ConnectionGUID: 3+W4Vo7IQim3ma8iAFHTfw==
X-CSE-MsgGUID: 0CWgmwMFQYekpaJG+/3VSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,259,1779174000"; 
   d="scan'208";a="269153261"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa008.jf.intel.com with ESMTP; 03 Sep 2026 03:40:05 -0700
Date: Thu, 3 Sep 2026 18:40:04 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: david@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com, yilun.xu@intel.com,
	xiaoyao.li@intel.com, sohil.mehta@intel.com,
	adrian.hunter@intel.com, kishen.maloor@intel.com,
	tony.lindgren@linux.intel.com, peter.fang@intel.com,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	chao.gao@intel.com, artem.bityutskiy@linux.intel.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/virt/tdx: Add extra memory to TDX module for the
 extensions
Message-ID: <aplOhHWvaxqUJDqu@yilunxu-OptiPlex-7050>
References: <20260821032920.256225-1-yilun.xu@linux.intel.com>
 <20260821032920.256225-5-yilun.xu@linux.intel.com>
 <aohvlMO7ehqcVW96@thinkstation>
 <aowMYbHKK4b0O5P6@yilunxu-OptiPlex-7050>
 <apE8yHrGx/bfifV9@yilunxu-OptiPlex-7050>
 <apf6WFKun8z4ejG8@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apf6WFKun8z4ejG8@thinkstation>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: yh5keqhey7arrbj9fbron848ymupdrff
X-Rspamd-Queue-Id: 9125040007
X-HE-Tag: 1788432010-781289
X-HE-Meta: U2FsdGVkX19oNEoqjrApXqorTwp6iWWJ2DhboL3UlTD0bdYCU3QVVgho3k6ift67BEReE2tbrjmfvbZ2ko9WAQ3M+g+IRCwW1WNKkZ600darSPVdT37LKiFa6IhIJ2HS9T4WtbrYcFAFKUgLfd+heSLgP1aO+lV6vNKOHVCpEN4B9agOQ4qPjYb4db1sqQmD4vLOYYNJK33NSsIbHVS6szcn1foN/VXuFqihkT/00qu22LAKOnpPVrb3j3deXelB7aGDHWdAbvUhgJ50yA6tkCQyZyofty4OjoGfWMHU3noECk9Mp/S59T64d6Ds1TVS9Z1SOkgUKtQoruJW7z0IuEoPBrh8ZtABp61cXOKgcujJPEvclpAgkXuSXriV6oPFe7EbfoxKuBu65P8Wyqf39Qd7Jt6CSKXmsAyC9zvDgQsybqDxRbgB4eRtgqTVPzcJNbyyNH/C58RFT0Z2aDeatPyT+EVr7xmlfZbTo228i0m1KcwxClePp8PI9OiMNqGdZc+sLsKK25OIGWCAQom/ZmbKSHTlb7azFVWuxfeswc/vIyTHoLEvvtigBncZqBAJuxe0TsuQ9NGdxICGZQ/ONuqOG9vBOWAW/YBh070nbFPSDjoPq4M/BYsq7zxAoTAgRopKnaoEH6R3VBUuHP2ikP2QxMVgIOL5Rb5pKQU19AnYrrD9JTAkD2yPo+GSvaZ3I/1+sG10YgM/o62Ab0NUAL4f9q3FF6pT/ijAR17a1H64Qn+6s6tGEUEeGC4MXXiHsUIlcQineQQes+w4EUyms2seXL2zEZc312GAKnLEPUGzSnniF77yUcOD+sR5SI6gKT+Yp0tSey+7GW6PrF/2VETu4jac2oy2X5OE3dR3ESicsKWc/0jl3yhrrYokOTsDjMe/IHvcoDGD51SqC226ayv3n7btCADCjNTJIZJrT2lqodyonAJV+hSj6d5v5H03yKbV85aIx+uTRVdqJQH
 LCWG5CoS
 LPnZhpb5Huk/JO1ncP0jy9a3J0BNDuCXViXr6DBGJookC159b94gkgugbN/iL3RAx9ElcAfL1Lz1gm91fiTIo9gtaxYdG31uU16w7Dky3Hl0gRZsDRYVUs546rbm1bOihe2nDqCHkBGODrv6xUmEKS11Xv1EUCvKnhIEB/1xkhoQLJjSyuMzfRu28MMPaj0p8j1ex/O8tjG2G9VYkLOE0scnDy4vTCP+BrGFeJftk1fZwPZcAs3w+9GH0qjvmkhEdj0+x8dBDy/smWPI58VNDwKaaT922WQPpGROs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 11:54:25AM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 28, 2026 at 03:46:16PM +0800, Xu Yilun wrote:
> > > > > +	page = alloc_contig_pages(required_pages, GFP_KERNEL, numa_mem_id(),
> > > > > +				  &node_online_map);
> > > > 
> > > > Why contiguous? TDH.EXT.MEM.ADD takes a list of page addresses and the loop
> > > > below writes every one of them out separately.
> > > > 
> > > > alloc_pages_bulk() fits the chunking that is already here, and a short
> > > > return can be handled per chunk. alloc_contig_pages() isolates and migrates
> > > > to get its range and fails TDX init outright when it cannot find one. PAMT
> > > 
> > > Yeah, this is not the ABI requirement, but the kernel's consideration. A
> > > brief reasoning in the commit log: avoiding permanent memory fragmentation
> > > and buddy allocator efficiency loss.
> > > 
> > > Also there is some discussion:
> > > 
> > > https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/
> > > 
> > > TL;DR
> > >   - The memory will never return to the kernel.
> > >   - There is chance that this tens of megabytes will fragment tens of
> > >     gigabytes of memory forever.
> > >   - The chance of fragmentation is actually low since at boot up, but
> > >     let the buddy allocator take care of these never-returned memory
> > >     is not necessary and lowers its efficiency.
> > 
> > Hi Kiryl & David:
> > 
> > I see there is another suggestion that the whole memory adding process
> > could be a little simpler if we allocate & add pages 4k by 4k [1],
> > rather than one-time pre-allocation. The concern of this alternative is,
> > as said above, memory fragmentation.
> > 
> > [1] https://lore.kernel.org/lkml/f48b83feb2ee1d3c88b5a1627cf35b4b282d3f90.camel@intel.com/
> > 
> > And I've realized the memory fragmentation discussion is not actually
> > closed in previous thread [2]. We need more input.
> > 
> > [2] https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/
> > 
> > Let me give a brief overview of the problem:
> > 
> > Intel TDX (Trust Domain Extensions) is a feature for confidential
> > computing. A secure firmware called "TDX module" runs in an isolated
> > environment to provide services about security.
> > 
> > In Linux, the host initializes TDX module at boot up time
> > (subsys_initcall()). During the initialization, the host must donate
> > tens of mega bytes physical memory (35M ~ 110M in the forseeable
> > future) to the TDX module. These memory will *never be revoked* cause
> > the TDX Module initialization is a one way path.
> > 
> > The TDX Module doesn't require this memory be physically contiguous. But
> > the kernel side concern is if we do PAGE_SIZE allocation, it may
> > permanently fragment memory regions, stop them from allocating 2M huge
> > pages. In worst case, ~50G (110M * 512) memory regions affacted.
> > 
> > So is the physically contiguous allocation really a better choice here?
> > We appreciate inputs from mm folks. Thanks!
> 
> What matters for fragmentation is not contiguity, it is how many
> pageblocks are left partially occupied by unmovable pages that are never
> freed.
> 
> So you can ask one pageblock at a time with
> 
> 	page = alloc_pages(GFP_KERNEL | __GFP_NOWARN, order);
> 
> with fallback to lower order if you must.
> 
> It also fits the ABI: pageblock_order is 9 on x86, i.e. 512 pages, which
> is exactly TDX_HPA_LIST_MAX_NR_PAGES. One allocation is one full HPA list
> is one TDH.EXT.MEM.ADD, so the allocation loop and the chunking loop
> become the same loop.
> 
> But alloc_contig_pages() might be a good enough approximation for
> per-pageblock allocation if we do it during the boot when fragmentation
> is low.

IIUC, you mean alloc_contig_pages() also gives good de-fragmentation
that we need. But it would be slightly easier to fail cause it requires
extra contiguity that we don't need.

Multiple alloc_pages(order-9) meets our requirement exactly but the
falling back to lower order may create more fragments. And we can do
this because of the ABI definition - an HPA_LIST could happen to hold
an entire pageblock.

If I have to choose, I prefer alloc_contig_pages(). It doesn't have to
depend on HPA_LIST ABI details.

> 
> My alloc_pages_bulk() suggestion is wrong. It doesn't get any control
> over allocation placement. It will tap in the per-CPU cache first.
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

