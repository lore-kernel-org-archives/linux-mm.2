Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D53FFC61DC6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55146B0095; Fri, 28 Aug 2026 03:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDE3C6B0096; Fri, 28 Aug 2026 03:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA83E6B0098; Fri, 28 Aug 2026 03:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870A96B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:46:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 969594026F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:46:25 +0000 (UTC)
X-FDA: 85149895530.29.5998919
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3EBD9C0007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:46:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bXBZqMcy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787903182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ9epRFniGkJqFGW+0pTkknh7RYKNgmGqk8M8bpDtks=;
	b=aQkEplv4PNQ0vv/G+uB9E8wb8nxYyywCI7vBAvHmThRg1uzrYRl64du4tpyfvp4QC4TSng
	k8CYh3cjIcp0B86XX3HoebtrIQGYEkQIkBC5TiDG5ofDYqZAHfBm/IoKAgmKmsyakQc4Ju
	92SwWxMFZ/xfvLzpnsvM1kvbQNtaCrY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bXBZqMcy;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf10.hostedemail.com: domain of yilun.xu@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=yilun.xu@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787903182;
	b=ei8XUrT9SRVvezDfzWtzC18qKShzdUGs46FzWGYlMMrTzGZm+5iarqcD8SPTlED6R4eJ/9
	Pt4u8O6VuDB43RKqKNjlHVqpFlIYN/wju+D+5ged4Q7HUUU8Fp/kmoUap3xYXpAmdWPX5p
	ig9a+fnwwF0lFgLLMtPHzoLPHx53Cx8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787903183; x=1819439183;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FGipmyMz958iY6A+TN8aB96juz7DcHiErilOO3Ic4+Y=;
  b=bXBZqMcyCt71c63ZVH7lPjCDEzcEAkfx3DYDKcww1SbRpwODA5ty74sL
   W8fpgALkvR2wGLQngDDt4FGoCiZiwh8gl9jZZlVRFcKor1UUyRtLcylZW
   KCrwGOxE14nqIyrynCO+xvNHMv2WKulDRO01D+643ApfxkK4i2enGHWcN
   8as5k3MfuAE4q6vduGXQKO2U9YfY0taiDehzsDRo8NI8ADbchZbZHBMWL
   M9IN0WCicbAp5KRtNabCFJsg8HzE/VZJKg9AxtUwS/hZ20bY7oyvMygLU
   pwLBqzhK2/6C3vkJtkkj2sxGnqe6cWUIuq6GAUJuCxCT1GmFovaj8m7wz
   g==;
X-CSE-ConnectionGUID: ovV/fQT8QwC4Ej7cKvR3Rw==
X-CSE-MsgGUID: duaH2Fg8Rpe3s1Gcjklgqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99569640"
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="99569640"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2026 00:46:21 -0700
X-CSE-ConnectionGUID: McO27ZScT52UaVA+WBVg0g==
X-CSE-MsgGUID: O/t3SgKfRBOFjbMLE7p+sA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,248,1779174000"; 
   d="scan'208";a="267498472"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.47.46])
  by orviesa008.jf.intel.com with ESMTP; 28 Aug 2026 00:46:17 -0700
Date: Fri, 28 Aug 2026 15:46:16 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Kiryl Shutsemau <kas@kernel.org>, david@kernel.org, linux-mm@kvack.org
Cc: x86@kernel.org, linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com,
	yilun.xu@intel.com, xiaoyao.li@intel.com, sohil.mehta@intel.com,
	adrian.hunter@intel.com, kishen.maloor@intel.com,
	tony.lindgren@linux.intel.com, peter.fang@intel.com,
	baolu.lu@linux.intel.com, zhenzhong.duan@intel.com,
	chao.gao@intel.com, artem.bityutskiy@linux.intel.com,
	kvm@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/virt/tdx: Add extra memory to TDX module for the
 extensions
Message-ID: <apE8yHrGx/bfifV9@yilunxu-OptiPlex-7050>
References: <20260821032920.256225-1-yilun.xu@linux.intel.com>
 <20260821032920.256225-5-yilun.xu@linux.intel.com>
 <aohvlMO7ehqcVW96@thinkstation>
 <aowMYbHKK4b0O5P6@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aowMYbHKK4b0O5P6@yilunxu-OptiPlex-7050>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6jwatwaeepeshdo4k1hm9ieefz4y9zog
X-Rspamd-Queue-Id: 3EBD9C0007
X-HE-Tag: 1787903182-633193
X-HE-Meta: U2FsdGVkX1/Mehr6S6rHoK1EKib+DgbVeyq7s1Xt6rrTO1Q12CDH61ma630Xy+igYjpd+NzIL/I2NsYF4bJTBjguflBtfEVPm2swuXG5QfKOfPOdC8dxjXHbe6YSjn4BOgsGub0tLht7SfWBymiiGoxDGmmNpGxeRXtgMdIOHK/NHYPGst0N78l8TtlNocN8oSQxESLBGB0jm3T1D07jw6qisCspJAVgg8jXE+wXJUoKa2sqSi3vopwAg8I2Um025Mb+Y3V7WX0mHgjffbUGgXLcQRxfn7CpIZQb03jidnyyj+PH3UTCUta0XN4d409B7zzTfa98d6Kl5rTEhfD+R+AOpiu83YYHKMRte/tXte5lcTJ2wiys78072eLSx1APo5c6bZO41XLR0a9RohJxhdf6v6Vog5HJ/j/9Weoboa9yY1HQaSyUM2h8Sk01RZpAEx/iG/uADuxRbcr+KJkceXoqdKc4BRQgWEnumSrKwP9Z2q0OnqoErZWfw9vcNbXIQrWrnFNhhPLStGYD79sIrn0DlsK6xK8nm8y4B7G+ryneOqQseuNQPT0ug8AO58h/zt1chA4+t0ylydkdgjgR37nr/QGsM1jU2nQFJczafnwhQHcdy1gv102A4swa++rPs2gvlmIP4GVQc00OvnOcN9aazr0Y5jvXQFrHB+Di3EX35lcWKmsMCU/l7n5EFMra31YvQRUWBUPYtY6gFE4uEQuUYrH+5vPo5T3Jf5jJD2gAeyrbm+9V59/XfuuHYsFY69FrRH7IeR+RzOo9ZMjnw6utdLEiISufoUBNpkcXiztqHhqeb5lrAIQeXBh7t3MIfdIOg3umXNXpbxkmUjuOCus0oEmg9faZDX46IDH1OIfjZgs8Obdhy0qr5UI0Fg18EP70VtDu3o9bBgeESgVOoMNcURFQCeaWbv4ViUzQ3o7Riy0/jUKhGXkeOJsVOuNxCfBK8/XP6HWygl2VkOC
 CnedUDfQ
 jsiBIqaxrghTR5vqvUuoKL7vg3YARua6R8fsxEDfELoNPtRuJmUOOZ448tZdXE0Qfo+KXCD3QlbxmNmaxp33m0mxfmx7fCQfFISDXt0oTmRV/Iz+8gTgCe6pWeaAoi+tpvqODvjv/P4kg3Lv8jnLLXWCuBxIPmayuLCGSwf8d+J/qisjfhuPT7F8+WSqk/zg0rVDC0+bpOirTKEplTPiKCT7FpIeR5wr+U8+duvhssJMh55n/19vIz/d1Lmt9IZXxAuAEhMZv17Tqe9GdiYuCOcprOCMUSgkruYfZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > +	page = alloc_contig_pages(required_pages, GFP_KERNEL, numa_mem_id(),
> > > +				  &node_online_map);
> > 
> > Why contiguous? TDH.EXT.MEM.ADD takes a list of page addresses and the loop
> > below writes every one of them out separately.
> > 
> > alloc_pages_bulk() fits the chunking that is already here, and a short
> > return can be handled per chunk. alloc_contig_pages() isolates and migrates
> > to get its range and fails TDX init outright when it cannot find one. PAMT
> 
> Yeah, this is not the ABI requirement, but the kernel's consideration. A
> brief reasoning in the commit log: avoiding permanent memory fragmentation
> and buddy allocator efficiency loss.
> 
> Also there is some discussion:
> 
> https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/
> 
> TL;DR
>   - The memory will never return to the kernel.
>   - There is chance that this tens of megabytes will fragment tens of
>     gigabytes of memory forever.
>   - The chance of fragmentation is actually low since at boot up, but
>     let the buddy allocator take care of these never-returned memory
>     is not necessary and lowers its efficiency.

Hi Kiryl & David:

I see there is another suggestion that the whole memory adding process
could be a little simpler if we allocate & add pages 4k by 4k [1],
rather than one-time pre-allocation. The concern of this alternative is,
as said above, memory fragmentation.

[1] https://lore.kernel.org/lkml/f48b83feb2ee1d3c88b5a1627cf35b4b282d3f90.camel@intel.com/

And I've realized the memory fragmentation discussion is not actually
closed in previous thread [2]. We need more input.

[2] https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/

Let me give a brief overview of the problem:

Intel TDX (Trust Domain Extensions) is a feature for confidential
computing. A secure firmware called "TDX module" runs in an isolated
environment to provide services about security.

In Linux, the host initializes TDX module at boot up time
(subsys_initcall()). During the initialization, the host must donate
tens of mega bytes physical memory (35M ~ 110M in the forseeable
future) to the TDX module. These memory will *never be revoked* cause
the TDX Module initialization is a one way path.

The TDX Module doesn't require this memory be physically contiguous. But
the kernel side concern is if we do PAGE_SIZE allocation, it may
permanently fragment memory regions, stop them from allocating 2M huge
pages. In worst case, ~50G (110M * 512) memory regions affacted.

So is the physically contiguous allocation really a better choice here?
We appreciate inputs from mm folks. Thanks!

Yilun

> 
> > needs it because the TDMR ABI describes each PAMT as base+size. This does
> > not.
> > 
> > > +	if (!page) {
> > > +		ret = -ENOMEM;
> > > +		goto out_free_hpa_list;
> > > +	}
> > > +
> > > +	added_pages = 0;
> > > +	while (added_pages < required_pages) {
> > > +		unsigned int chunk_pages = min(required_pages - added_pages,
> > > +					       TDX_HPA_LIST_MAX_NR_PAGES);
> > > +		struct page *chunk = page + added_pages;
> > > +		unsigned int i;
> > > +
> > > +		for (i = 0; i < chunk_pages; i++)
> > > +			hpa_list->phys[i] = page_to_phys(chunk + i);
> > > +
> > > +		ret = tdx_ext_mem_add(hpa_list, chunk_pages);
> > > +		if (ret) {

