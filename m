Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FE2C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60C76B00C4; Wed,  2 Sep 2026 06:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B122E6B00C6; Wed,  2 Sep 2026 06:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00896B00C8; Wed,  2 Sep 2026 06:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62EC96B00C4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:54:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE64740194
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:54:38 +0000 (UTC)
X-FDA: 85168513836.26.2C03BBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B5F8940007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:54:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJ4DuF0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toiCPx/Xo3CxoxeFdRWkRsbGBlbaJnbbv6UdXivnwDM=;
	b=oaNzsC32bEfk6Tdvh7mdwTPURLKKFpzpTLe/ZKCKdN+7PfjUaFGrxl2L4Otdgo5a+OTCA2
	nGBTYFslcCxA25EiBuk8qI1LjZywhNzZ6YcUWSNZcpWwybQ5ytxsw9+1HhmvpuP8Wt8k/B
	AMRoY7WFPpE922r/Ph4xYgEyaQh7nmw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cJ4DuF0x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346476;
	b=ysT/VWzrN74ysTWUQiuIQzj2WdUcm/YWzp4n8dajsL4E7ES46no4+tbsPqPwzZVPDZwOWV
	ilG0DqEtZgZKWXQGilAM/hpPFQiroXjP9sAAden57rgKoeUT4IjIduzskW7CbxgoYGYlSx
	c1GED0BH9CEoq9mhg6XT4XTzfXFyE9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B56E408D3;
	Wed,  2 Sep 2026 10:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E53951F00A3A;
	Wed,  2 Sep 2026 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788346475;
	bh=toiCPx/Xo3CxoxeFdRWkRsbGBlbaJnbbv6UdXivnwDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cJ4DuF0xNel9voHgbF7jEGIo6ASgi+vWwKwvv7GPgZi5ugPe1WRKwICeSVz1+1qhB
	 O2QvkB5C4rpIWKSqfe+uzT6THlHsudHhtXLkcStaAoTdZagjswkXt7vqCTFhFinDXb
	 4dd7L+Cjs50oHI0KuqdnLYsH9YqdPFQgDsuHCoIKd6oQAx2ThuHxBTvXnvs5Aaou/x
	 uXj6m2PzxUYwXBmpvdSPZC8ksvXJRSALxRdprqVB9SvQRUzP/yU157F/403AzU8v0B
	 o96cZBlMB16fPH2A3l2J8T4v/R1R5z4PbdBhuzv2MD4ocBSkohiE2i9kpOzOow2sEg
	 HTwygDlO8H7DA==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 819FD198005C;
	Wed,  2 Sep 2026 06:54:27 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 02 Sep 2026 06:54:30 -0400
X-ME-Sender: <xms:YgCYarXBvjvZGqPEtJ_y73RXDYypiATMN4F4hljLdpW9z6Ne1whWAQ>
    <xme:YgCYapv7p1ifq_V19ZZx_TLDwEkw6wB7DiL-mD5O7Tg6MdHk9KmiOMoLY85KEYx2l
    OkmEp6XU01Ho0hcvdzMN5lN6g15ovu7u5IV3Bn5tHlHztVMBgy5QJI>
X-ME-Received: <xmr:YgCYat4UqdISDI2sgAmbeEOGPepGlpyWlHK8r40159UtVyXbY3gptW6CA2s>
X-ME-Proxy-Cause: dmFkZTGyzMkWjg7IQnEoIuXNQDp6x76pYUr/rcWepSAosl6HnZGHMGZrOsuoHHWZ2rorFR
    zigkDOWu1PcgQYHXoVRDHrqDSZRPr+5W4Vg0KX2Li1EjI8OOqXrM6xWmq9bsPUuLwKI17R
    j+EumYXVk6yj2jr9bKHQGhGz+CQ1JYJPM0pE+aq29uv+Rb2waUhGeanqn55pH7ar0s5w3y
    JJsNPTDmEs9Sw0IgYXtyurhLAvBXoprebD+atHmZhq3GEi6lE8ND0Ffm8P/3qksPTNP7g7
    DH1Tr8GiUcpyGdivOsuUqfCGwxdfY5r6Sk6gY5ajvKl4Q4HANcgM2hcvNwcVp6lCDSFUJd
    WcrkC1qw+Wp4Dpmcvp2SeQ4tDHgJfSU3J8A7Ao2bGeBPxEd/v8mvtT5M2F+YKBGRxp74lk
    3E0AjxjyL+n4qePADWK0VQuFnAY9bGF/jyEC8rVztUz/JIWn9ls4pJd8bNOWKA0xLPMk5X
    Fxn3GdaNZFu2GZXRybqiVA5Mp8l6C2WCvHTGbuP9wGbXYkFK2xbmqYEiClq4IXBYlO9Lg2
    Oi/8gwZH1fsTrFpxGg1STby8abZb1JOuuFyZ9iO4cagnlwKABSgao8wBhS7NhcVxLiC3FF
    AS+dMGOfEdyog41YR0Myj0kT+ddpqc9FBMJfGGKV8zsoLh+QSfxUoZ+903Mw
X-ME-Proxy: <xmx:YgCYagXs_SukH0KtqMtj0ndW_s7zzQgp7LZE5wo0QeOpwIuQcmpuvg>
    <xmx:YwCYapMbzZqFzG8qUBbzyFGqPlH03_gFXtUyvXKdkokvmWwteTkL1Q>
    <xmx:YwCYanE4Elqi6EoyImY-flnTh6H7vB6Mlc05Cs6_NFY_9DnllTiCcw>
    <xmx:YwCYauo0UVEPy1YrgD19E_eDeuVtQmap5rE78Eb6qiXIrSG80H5_Tg>
    <xmx:YwCYagq0aItg5HtoPeiTvEu_paJqAxqB2A54EUW3Lji8vBkefS-5AbRm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Sep 2026 06:54:26 -0400 (EDT)
Date: Wed, 2 Sep 2026 11:54:25 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: david@kernel.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, 
	yilun.xu@intel.com, xiaoyao.li@intel.com, sohil.mehta@intel.com, 
	adrian.hunter@intel.com, kishen.maloor@intel.com, tony.lindgren@linux.intel.com, 
	peter.fang@intel.com, baolu.lu@linux.intel.com, zhenzhong.duan@intel.com, 
	chao.gao@intel.com, artem.bityutskiy@linux.intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH 4/6] x86/virt/tdx: Add extra memory to TDX module for the
 extensions
Message-ID: <apf6WFKun8z4ejG8@thinkstation>
References: <20260821032920.256225-1-yilun.xu@linux.intel.com>
 <20260821032920.256225-5-yilun.xu@linux.intel.com>
 <aohvlMO7ehqcVW96@thinkstation>
 <aowMYbHKK4b0O5P6@yilunxu-OptiPlex-7050>
 <apE8yHrGx/bfifV9@yilunxu-OptiPlex-7050>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apE8yHrGx/bfifV9@yilunxu-OptiPlex-7050>
X-Stat-Signature: ytbqiuerzejjykrs9no8awgpens498zh
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B5F8940007
X-Rspam-User: 
X-HE-Tag: 1788346476-747839
X-HE-Meta: U2FsdGVkX1+bjx+gn/68+G0i6+EeW3C2YQUgk4s4zv2g6edobNsCFP+HOpfx1C0S2XbYIecDk4UaT+BexYESX7R9rcfqO3UrIZ+hhYX+182lmh3ZmfcFswlenlmGdtrELRzONbtQahzti1+3WVOJReREA+bNdyKgqyAXmIMQy1omrwdp8ZYXqj5QXE+CEtmVsEZU0/t4HMEhq+0x0VHb6O+tosRfYs97QZVpgb+l/IAS8ztVTCrL6mEITfep4cFqprr5JH136HOO5l7q9XBjsSbXs+WS4Ga7M9KNTricB7cbQAzZORxiHBwlRXOxfl4J+/73i8QILd1WhLd+Kca4Z3ns+zubgCbfXSJKvO9HIltFO7bVvwR//OufLSF9zhX0/0qnjOWKRLZBUO2U4bq/xy1/NXnPS10aK5uDG2+A5MO5MdSCPj3Kv4K9xFDbrMJ9MzrOk96B3dbiV7G/hYmzCrwcSzDJyuSsFOGXdaJKt6FTGt/shrqgfKkHTqNd4kOfxTOMni+e2jbC00qJ1Cb8vlIfUg8HEouVgVMvxd9vMtcESL2qtLxbIMyciG6N8+jyrcVlGGu0fEakPc8MFZAsZi4wkt4jo3s+hRJzwQu96mBMKv3yZMzNND0vWlLOsnWHDH6qRm6YZd1qcMRblzJRIshauuEZd6ZRul06K25R8/hb8bx1KhdsZPXp+520pDYiZFNU/PGY9R2UljyaEpgu5bTtldNkkB8n2RRLFps68fzZ1kINLIGKZGU+vllo9Yp75UqPsN9swq5acYPrEo/Pu1Yq02vX5lWcp7aeuDJtjTxD/ljPVdv+SplbCv63zW8EZuC8poSiu2/jhJTYq1Wy+mq4+ofeVET4OBDOy1iZ28dLj9Igjh8nIxQwfK4sjZwQjWzKCIkKRHoz75yEGsE7WPtILB6ehLasrFrMuqhw1P6MSw4780sqwgkuotRCCuyUOBOzj9rC9lBYrHJtm6o
 cvip1vpf
 Zu960UEcKqkuaKnBjhTQzYR1emk5jbrSWIFVGMVgRXsIsCV88AOgfpVo5lRWVRmYPQvaNL8jUmDVSG3M/0YLShxFmF/mpY97KhpdPg+8MGwxKhhRQr7KnlTk/gyf/eSc+ulvHpSTnlyGOmophaCKnNR3ww01obZb8TTr+QwrJlNeqbPwbIAXSnph2kRuAyKD0mqgL567oDoqyUxJ5Cyq3s+47BF+qao7Qbm2Q++tJllLmQ6a8sS6ArU7Z+l4Y0xiPGA4EnYeyLKruuHyf9ZGz/JBKBtADeKzpk7hHD6ofaEzQBEYeJHDo2HkgiiK3LnhhBtF4C4rLZU3CfgQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:46:16PM +0800, Xu Yilun wrote:
> > > > +	page = alloc_contig_pages(required_pages, GFP_KERNEL, numa_mem_id(),
> > > > +				  &node_online_map);
> > > 
> > > Why contiguous? TDH.EXT.MEM.ADD takes a list of page addresses and the loop
> > > below writes every one of them out separately.
> > > 
> > > alloc_pages_bulk() fits the chunking that is already here, and a short
> > > return can be handled per chunk. alloc_contig_pages() isolates and migrates
> > > to get its range and fails TDX init outright when it cannot find one. PAMT
> > 
> > Yeah, this is not the ABI requirement, but the kernel's consideration. A
> > brief reasoning in the commit log: avoiding permanent memory fragmentation
> > and buddy allocator efficiency loss.
> > 
> > Also there is some discussion:
> > 
> > https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/
> > 
> > TL;DR
> >   - The memory will never return to the kernel.
> >   - There is chance that this tens of megabytes will fragment tens of
> >     gigabytes of memory forever.
> >   - The chance of fragmentation is actually low since at boot up, but
> >     let the buddy allocator take care of these never-returned memory
> >     is not necessary and lowers its efficiency.
> 
> Hi Kiryl & David:
> 
> I see there is another suggestion that the whole memory adding process
> could be a little simpler if we allocate & add pages 4k by 4k [1],
> rather than one-time pre-allocation. The concern of this alternative is,
> as said above, memory fragmentation.
> 
> [1] https://lore.kernel.org/lkml/f48b83feb2ee1d3c88b5a1627cf35b4b282d3f90.camel@intel.com/
> 
> And I've realized the memory fragmentation discussion is not actually
> closed in previous thread [2]. We need more input.
> 
> [2] https://lore.kernel.org/all/167d9540-2d9a-4367-bc68-b96494bc4044@intel.com/
> 
> Let me give a brief overview of the problem:
> 
> Intel TDX (Trust Domain Extensions) is a feature for confidential
> computing. A secure firmware called "TDX module" runs in an isolated
> environment to provide services about security.
> 
> In Linux, the host initializes TDX module at boot up time
> (subsys_initcall()). During the initialization, the host must donate
> tens of mega bytes physical memory (35M ~ 110M in the forseeable
> future) to the TDX module. These memory will *never be revoked* cause
> the TDX Module initialization is a one way path.
> 
> The TDX Module doesn't require this memory be physically contiguous. But
> the kernel side concern is if we do PAGE_SIZE allocation, it may
> permanently fragment memory regions, stop them from allocating 2M huge
> pages. In worst case, ~50G (110M * 512) memory regions affacted.
> 
> So is the physically contiguous allocation really a better choice here?
> We appreciate inputs from mm folks. Thanks!

What matters for fragmentation is not contiguity, it is how many
pageblocks are left partially occupied by unmovable pages that are never
freed.

So you can ask one pageblock at a time with

	page = alloc_pages(GFP_KERNEL | __GFP_NOWARN, order);

with fallback to lower order if you must.

It also fits the ABI: pageblock_order is 9 on x86, i.e. 512 pages, which
is exactly TDX_HPA_LIST_MAX_NR_PAGES. One allocation is one full HPA list
is one TDH.EXT.MEM.ADD, so the allocation loop and the chunking loop
become the same loop.

But alloc_contig_pages() might be a good enough approximation for
per-pageblock allocation if we do it during the boot when fragmentation
is low.

My alloc_pages_bulk() suggestion is wrong. It doesn't get any control
over allocation placement. It will tap in the per-CPU cache first.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

