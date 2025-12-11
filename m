Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAEAD41D56
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 15:08:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0486B0006; Thu, 11 Dec 2025 10:08:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487FC6B0007; Thu, 11 Dec 2025 10:08:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 350476B0008; Thu, 11 Dec 2025 10:08:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24D126B0006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:08:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFF3EC01FF
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:08:18 +0000 (UTC)
X-FDA: 84207521076.07.95704B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B9DEC1C000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 15:08:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EqFupcXP;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765465696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4hozZxqCPaXLY1mxAFT2lRvZ7mc0q8CG1iaZF4YpSU=;
	b=pUw4XNpqI2G83gg6zbtYlHcGPuDLuBdLaQV4wEp8ai6tkUojthf/grYmpZNsYau0EblPok
	uAleaS67ct1NsO6XWZjTtrQSp/e9uds9VZV4EdvVy+Nfc+VKzgxs+DYz7SSF/RTPGOqeH7
	gshqRT7+i/iu6jdJxAOtb8+0OX9Vl+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EqFupcXP;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765465696; a=rsa-sha256;
	cv=none;
	b=uhATb6GZ76TZsu49uASq9vd2MQ3QGIo37BwJrkJS35PfyGY2fG5khUgSyCGO6QALuwBLBV
	vUMi1+tFkCXpe7+Z6FQitlEcAMSeDrXgQN1tzy+EPQiE9bfc4SRxgpcQMasxrESzQdVylV
	2csGzAU0P2lqbYNG2F5tIcNZs5eOHv4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CCCE9442A1;
	Thu, 11 Dec 2025 15:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF9EC19421;
	Thu, 11 Dec 2025 15:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765465695;
	bh=BuXXa+/Hd8aPc2VP87UCC7y68C4whjwugE7BDLLteE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EqFupcXPpIbRjNZERBCqb+BaJvA5S8+pSFDVI9Ec6bet+KxCQVCiItBgp1rAVnR31
	 NQcBTYgKzQqTy83O5YKzWAUPj84zJa7K4kWXL+sw1zSm1OXkmTaq/a4trqeegtuMPi
	 NyZMFTLUB7ogGliTF1OLBMmSYgMhledSvNQvvscbt4BxG6HXD4/lZtmBHlDRparOQ9
	 vPXjkSVfGeC0U46iP9aMerWp1WPQ7+JY7qeo0r1N+TkcHYPSlIZX0MEtwe0+UvU9rl
	 BJpf2HeErqoLC+ymh33s6uV2Y2aW7NyjUK8j8amPFqOQr63Gbat57xmC3zVhOqAu9f
	 pIGqPdygm1yCQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 791C7F40074;
	Thu, 11 Dec 2025 10:08:14 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 11 Dec 2025 10:08:14 -0500
X-ME-Sender: <xms:Xt46aduxeH6TjbuWN3YyUpuoKhZIZ9C9SgxLB1HiHbWBnW4ypgZ_tQ>
    <xme:Xt46aZYSoAb6cz9vVpS1uNVo_sqv0Y8BDls1wPInwWxbBSJN6pwyue1Rx6fqWOI3n
    sS3cralpP8lb5To0VfEj5TJKfijfD64NKZ_NG6but_9aGz-oVQTNJ5N>
X-ME-Received: <xmr:Xt46aU95JPHUmvLYymSDNlDt7g35jW-AW7gARaL4VR9UEPPU7RfOSlXyA0gHTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvheeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtugfgjgestheksfdttddtjeenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepvddufeetkedvheektdefhfefjeeujeejtdejuedufefhveekkeeffeetvedvffek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepfeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehoshgrlhhvrgguohhrsehsuhhsvgdrug
    gvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehvsggr
    sghkrgesshhushgvrdgtiidprhgtphhtthhopehlohhrvghniihordhsthhorghkvghsse
    horhgrtghlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdho
    rhhgpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:Xt46aRYkCeiSFSsNVmqHqXPbtAxiMe7PRj6SkOXHHNm2iUj-ZQhsSQ>
    <xmx:Xt46aaSJhr1AIk53q-_-w6gmNx8Ldz3q41N5QRsW067qFyjUsdzuYw>
    <xmx:Xt46aYkv4rd8XbECYhIG7zLybfU8rjUpQQCzZEqS0ns_7X-MNVv7vQ>
    <xmx:Xt46aeKbuLXfFuVtCBFdM0HsN4mjkKiun8yEgSI30IFS8PmfaZXzLw>
    <xmx:Xt46acrgi93rqXo8ciNjWMSP4k_1iRFgGXHniNp192frSC-_BzBM4X9u>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Dec 2025 10:08:14 -0500 (EST)
Date: Thu, 11 Dec 2025 15:08:13 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Usama Arif <usamaarif642@gmail.com>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/11] mm/hugetlb: Eliminate fake head pages from vmemmap
 optimization
Message-ID: <5twlonzi3rooao7gyp5g4tyaeevemcx6qhuf4xvdtsi2cykuo4@wrhxmxz63wvn>
References: <20251205194351.1646318-1-kas@kernel.org>
 <4F9E5F2F-4B4D-4CE2-929D-1D12B1DB44F8@linux.dev>
 <m63ub6lxljw7m2mmc3ovbsyfurl7hp4cvx27tmwelcxxrra5m3@eva5tqcdjxtn>
 <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6396CF70-E10F-4939-8E38-C58BE5BF6F91@linux.dev>
X-Stat-Signature: ujek4sgenfhjheeiru959yhjkink1pge
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9DEC1C000A
X-HE-Tag: 1765465696-385043
X-HE-Meta: U2FsdGVkX1/UCmTmikwEnvyV38M2o7PhCERr/om0GGlFgtLKXly/mvgcO3Z+T00JvQCKY0QzFHfQXZrpyzPch7ACB5hx9yjdLDZ2SVJ2kAqIVpJeIPbIY0dJA4uK3C+Zy1RehQ7NCdyhZwo1l9svRu7MAqfBL7MKMHeG7QCKQbzS50vHy/cYiM5F4uYY81LwydoQYR8FDQjfpiWe7O+M8XT93MVgz7hH8ueLKsSxQ4qO6TiUdnI8oUs5yf0wT9VQ5j9+8iXtNscWyxMMUFz7b0w+i0QiakuN+MRohc6LfJVqZv3nnDr5uzvy1Yoo84Eyg7xwQJ4xudkF9PXT9lA8LTm6jPTDmE+hTh6co4Kwm5uFPNm1XU4jnVakO56wL1Bilb05HSS4Knu6j7IekT7Qmqoig9hq5AD84F0bv6ja6/ZYzuzeOJvjIgK2gyBjZu+dlkLFZebFr+JCM6fgi3o6LzSKUH8hbZx3/VqbuadnOosQFnY3+lS86MGOREOHoK1HwyeWchWrg49mOXq/ir0d4scesAw89df7+4uCOVKt2iQ3VpnvaifRmwP4k0eXlw5v8JIaeXElM1HigGfpyDwAUYxcj0XrvFObbrP+oGabp1VcqXDgJe+tRkVklpZr6AAEfP0MKLUiLOecpf/lGxLlZgEWWEFzQ5ibNoDGROjAMpJWjQqYBDshMpGPCcbrjaSfQno0CWecssdx/Qtu1vHkt+XNxuPNPKO6vyQp8afn2If8/WD5eMqw2hG144w5WuNRUHEfMHu855GxTkEK7UnOY0GVzB49WevmTPOc9U8ca/4N8ZKQpaAwyjOQpNz8jZ91kLgUqvlvaUVijnz3q63TnNBsxWO/1xZQFAPat4/KnO3wK0YElqLC9KAWchofHyu9MzCHGpCJ8Owkv3l8VvdqEAVfmY3tf2f86NtvbwBm/8w+L+GujbCFSbpfHB3i9SHhPEPoPjRe7PS1U6iZtKh
 hsb/VdW0
 mLw80DT905k4B8kHfTUkEg0vBJH8xF9pL8NB41sVwynns/Hz2MoESlJqzfFm9IEhQeIMUqQtLAglBOlrL2Oa/yZHqxAOsiCtUxsoU+ww3h9aRPyZzPFha57FKR34G+veN4Mw9caLfPydpc6GXgOAbTVzhGsG6FUM7vdH0siRaHwmULnEHGBJKNorNcfj0uOxU50oPvfQxuhQzC0skk1y+t0dxoFVmazUYUw6Z1DVa4AQHjc94d0csl0tPTIASy5wMruMeYIK3hLvABiTrYRiFcC6CFGAZqhTgu3L5Nt+TYC4+Krq8mKdytzh4RnMV0/yxXAK39Ho/wD9RELc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 10, 2025 at 11:39:24AM +0800, Muchun Song wrote:
> 
> 
> > On Dec 9, 2025, at 22:44, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > On Tue, Dec 09, 2025 at 02:22:28PM +0800, Muchun Song wrote:
> >> The prerequisite is that the starting address of vmemmap must be aligned to
> >> 16MB boundaries (for 1GB huge pages). Right? We should add some checks
> >> somewhere to guarantee this (not compile time but at runtime like for KASLR).
> > 
> > I have hard time finding the right spot to put the check.
> > 
> > I considered something like the patch below, but it is probably too late
> > if we boot preallocating huge pages.
> > 
> > I will dig more later, but if you have any suggestions, I would
> > appreciate.
> 
> If you opt to record the mask information, then even when HVO is
> disabled compound_head will still compute the head-page address
> by means of the mask. Consequently this constraint must hold for
> **every** compound page.  
> 
> Therefore adding your code in hugetlb_vmemmap.c is not appropriate:
> that file only turns HVO off, yet the calculation remains broken
> for all other large compound pages.
> 
> From MAX_FOLIO_ORDER we know that folio_alloc_gigantic() can allocate
> at most 16 GB of physically contiguous memory. We must therefore
> guarantee that the vmemmap area starts on an address aligned to at
> least 256 MB.
> 
> When KASLR is disabled the vmemmap base is normally fixed by a
> macro, so the check can be done at compile time; when KASLR is enabled
> we have to ensure that the randomly chosen offset is a multiple
> of 256 MB. These two spots are, in my view, the places that need
> to be changed.
> 
> Moreover, this approach requires the virtual addresses of struct
> page (possibly spanning sections) to be contiguous, so the method is
> valid **only** under CONFIG_SPARSEMEM_VMEMMAP.
> 
> Also, when I skimmed through the overall patch yesterday, one detail
> caught my eye: the shared tail page is **not** "per hstate"; it is
> "per hstate, per zone, per node", because the zone and node
> information is encoded in the tail page’s flags field. We should make
> sure both page_to_nid() and page_zone() work properly.

Right. Or we can slap compound_head() inside them. 

I stepped onto VM_BUG_ON_PAGE() in get_pfnblock_bitmap_bitidx().
Workarounded with compound_head() for now.

I am not sure if we want to allocate them per-zone. Seems excessive.
But per-node is reasonable.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

