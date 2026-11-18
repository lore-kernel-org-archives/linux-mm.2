Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA61360A2611
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hcjoV049
Received: by kanga.kvack.org (Postfix)
	id 16C7B6B05B1; Wed, 18 Nov 2026 09:18:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144A26B05B3; Wed, 18 Nov 2026 09:18:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05A176B05B4; Wed, 18 Nov 2026 09:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D69636B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:18:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 648F412076D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:18:08 +0000 (UTC)
X-FDA: 85448444256.09.1B0C5CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF39C4000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:18:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcjoV049;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dw8kfo0jr+5HnxA4ZRVp7iOwPegZqFvAC4q9TGpP07U=;
	b=w5DkthbZJPo1nkiWEmVwd/bYoha1REBOUlawhVEJ2FgVvWXk/Y38H2OqUCBAttXSx0T+K/
	GwvzoVhwouMxa9ITwBjlYLA1Lx3fGCDsapD/lEUs3KTAEJ2vp0dVMn+PB55CEEeEJb4cSp
	g8FrIpzI+eAn8UhpLJytJdgGPNiRXG0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hcjoV049;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011486;
	b=eX4deaEd24hSjNnrlk1sqSzODTGen4NuoJ9GAl2UzdfxzTXww1066fwV78TR47OMMc98UD
	QbMFAQhVSYClkV4bzGsE//kCkm4bu/r+jsupYbKYtXjpJTbYaijZxJylL/fWJB+RbLPNmr
	+yZiiTKK20trIHA+CoHAssPAzbLQ7oE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3289161884;
	Wed, 18 Nov 2026 14:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E360C1F000C4;
	Wed, 18 Nov 2026 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011485;
	bh=dw8kfo0jr+5HnxA4ZRVp7iOwPegZqFvAC4q9TGpP07U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hcjoV049icqMAqOW/hYn+GtbP550DC9ZCxh1djiAIYxD5bhiR5bxmNaKM+xKbb9RD
	 LAJ9NaCx2SsaUPDUboVSqG/cBj/qhdcP2jLYhO8qlLGLXUaNbEU0t+Lzo56lZb1HCw
	 w8NIqcNkhyfvPKtmxh0ZZiWN+uwczWz7X2JD+N5xKV8PPc5KOo0hzKhmkiBi9iWmjt
	 1BwyP9EBC74Rguwwa1WnsKhgFDuovM5D41N78CtFfc7BiSBmENU/E1EyQDGmULe4eL
	 KCaNQzMe1IOyAVOkSYJuJTFBBH4rrvtXnvtjxAB6YGnO2ryUHBWVI+2w8+WJ2Y9So1
	 5kucFx7ApUHBQ==
Date: Wed, 18 Nov 2026 16:17:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
Message-ID: <av2zkUpYGmGWPx8T@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
 <avzsFxVqO27Vf4Db@chrisdown.name>
 <3C50E682-848F-4788-9238-923D5E292DEE@linux.dev>
 <av1M9itGiTF1Akqi@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av1M9itGiTF1Akqi@chrisdown.name>
X-Rspamd-Queue-Id: AF39C4000A
X-Rspam-User: 
X-Stat-Signature: qmkwhkhptoxdgc1ac7pt7uehx5idwcpi
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795011486-851132
X-HE-Meta: U2FsdGVkX1/rtc/BzAlIVW9P2ijhfECfiAEUKlK8+CpPH5TpM6lZETqn/B+2KKz85YlOgjKeBj5X+nqznDJFvUMBQXxZifHJhblpR5YD4H47OashvTOseTPNPCx9nRAGFBiucjm8zUfgGcfWLrKYhSwUy/HRDsjArO5y1rAc7cYskaZFzW1JKu3sD5Ga4s2d9V37quyePmN6Jgz/tFvR8XgeDYQoMJUBSKpNchVKUHJCsiVAsUabrlpkb1xEWrVqxd1T2BFn4gop3/IhMHsHugXZzm407oTJ5GQCr4ieWFT0qujcYip9pNAF5kkNiK92LFgYadqNcrUiqafswukPDStRwsWRIX38nAHGwUMoJ8sptGyd//78jjgNMEv92FBijj4grZdre7huczaPWE/wCmwVKSksbgMkOf81TAGCWAHLxigaM5/gqDppfIAVPEFAz9eMt8/xWs2YmSK/ie5mg+MmPfRu9w9J4ta3iPo6jL04/JT5vaaJka3G5HWPPY1xDgFRflHpA9I8urkCLAuxdAw+mCuFlHV/wpPZng+qy1uBnFLOwNg29RCL2NVdEtwWtNbBpewysjNTlCSFXE+l5/KSFL3QaPKHoabGrVByZhaeReifzFc0ZemKiahEp14TSbIebeIdp32vnLe0FXecPtxgwWegU3bh8bu3NR4CL95Wdlph3+vPZyn+a7In+0NXw2/YJLt95NLYNFx7zTyQOx59bzR6xmNxL0R9lGovHlAmWFEERY1FT1t7aBqG6ddr57LN6wbXtT4ONCCIKlPhPB5DStY7OgHzuo1IRfkKLjWpVfqjVTsSBhGU4dTJRIvDTFDC3bTb1hrBBvDXxrclhOtXqW6k0LJl7ZH+CYaDXWt+Q7a6mdAXuxLl3uZ5SXcUNDvVwZeFcZjtozrHCAWcB1w0zegZZHZf6AGjBMsAdGCixFiWSnpkkRMMBwf0rGX08TgNrDYhzDXcFlj80nv
 x98QZ56D
 4NLn2xch1E2Zf+VbICyHU2f1EOhMirxSq4qi74JV5YJv7arrnsAg4Atznl9rHw/JIGwopMttjBVmhTx13d0Sl+kqpLrMyEHGtOWx5pFN5rAsh2HC4FRuD2VMeFSizn9nPJQBeFJ47GbGskn7dL6CxK4JfckMWnPvgLE9CFppX2+VI5zm/C+tscpVU5XGYAawJonXoKsq9i86Eu+4CCKyg8kWcoIk5C1sDaKvLRjN1B52/7hhf51ZVyNypu8TbJsDIuZM54Vl40+TEfYMyYDPmXeusdIvJFTjVl2xlY+o9KDI5VWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:00:06PM -0800, Chris Down wrote:
> Hi Muchun,
> 
> Muchun Song writes:
> > Mike's suggestion considerably simplifies the code, and early page_ext is
> > only needed by optional debugging and instrumentation users. I would prefer
> > to keep this approach.
> 
> You're probably right. 

I think so :)
The memap_alloc() that essentially allocates the memory map does 

	memblock_alloc_try_nid_raw(size, align, min_addr,
				   MEMBLOCK_ALLOC_NOLEAKTRACE, nid);

so we anyway may end up with reserved memory in ZONE_MOVABLE.

Until recently we had memory map allocation before the zones were setup, so
there wasn't much we could do about it, but ...

> But can I cheekily suggest something in the middle perhaps? :-)
> 
> Given the zones are already set up before page_ext_alloc() runs, perhaps
> you can pass the start of the node's ZONE_MOVABLE as max_addr to
> memblock_alloc_try_nid() when the node has one. The general idea is:
> 
>     struct zone *movable = &NODE_DATA(nid)->node_zones[ZONE_MOVABLE];
>     phys_addr_t max_addr = MEMBLOCK_ALLOC_ACCESSIBLE;
> 
>     if (!zone_is_empty(movable))
>             max_addr = PFN_PHYS(movable->zone_start_pfn);
>     addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
>                                   max_addr, nid);
>     if (!addr && max_addr != MEMBLOCK_ALLOC_ACCESSIBLE)
>             addr = memblock_alloc_try_nid(size, PAGE_SIZE,
>                                           __pa(MAX_DMA_ADDRESS),
>                                           MEMBLOCK_ALLOC_ACCESSIBLE, nid);

... with zone extents known we could take it even further :)

page_ext is treated as the memory map in many ways, so we can allocate the
early page_ext sections with memmap_alloc().
And since the latter always runs after zones are set up it could include
this change.

But I think this should come as a separate series that also could move
memmap_boot_pages_add to memmap_alloc().
 
> I briefly tried that and it seems to work quite nicely.
> 
> But I don't object to it even without that, so feel free to add either way:
> 
> Reviewed-by: Chris Down <chris@chrisdown.name>
> 
> Thanks!
> 
> Chris

-- 
Sincerely yours,
Mike.

