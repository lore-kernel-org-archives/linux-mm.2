Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1824DCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75099940008; Fri, 12 Sep 2025 11:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72735940007; Fri, 12 Sep 2025 11:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CE1940008; Fri, 12 Sep 2025 11:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 553B9940007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:41:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E578F1DF9A3
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:41:21 +0000 (UTC)
X-FDA: 83881012362.09.F807C54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E67A614000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:41:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LETEawqk;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757691679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsBm1C/SFb+Ex8cUtIoUrwQa8ExtOXnZu4LdgQrs34Y=;
	b=Bq53IG5zYoKLolrNQdh9qyNGR+OYVnNT5o1jQWthyYij1cudjK7rgFSpM1hFrcj9K8RG8T
	umDTi+b006Zy+rfQ8eTYPtrlzYUSbLVY8mmwW0tTj7WkBh4UySUNNP8p71mU1O2gqzP02v
	zwM3Xzdcw1eOgN/3lgOYIFsjYe/gtlQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LETEawqk;
	spf=pass (imf23.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757691679; a=rsa-sha256;
	cv=none;
	b=4+TLXzEmoYm/NIZdFb1DOnci0pZAyx/q75YWEdxxh6Gfwf+AUI6gehq/obyUU9YGnwN59d
	zAvEvCyvJQqjDqmYKxJZvnypngSUlJVJLPOOH1phhhlfZRxUsu6VMjXBx61QRktiNh50zO
	pcSOF+5TF42KPRiMJ15axEAv0STRbvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D877160206;
	Fri, 12 Sep 2025 15:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F098BC4CEFA;
	Fri, 12 Sep 2025 15:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757691678;
	bh=Pnh9rQTYsWlWtV4pH/2q/GaxI6G4+CAlVzB4h1vWAoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LETEawqks87rrqCiHQ5/U14DkW7DlUVM93h+Ie4U9Dl4p6mYpnwLE4ZqR5AO8AEBn
	 dR1WStbWV5V9l9qK3zmkbGLb6UBjJD5O6u+2h3j89D+ciFYRl+Th3glaQUrcx30MQw
	 Tkld+qm5o/EUk3ytI2gfN9O6rIoZULo/ETcpvpu7hO+ViRz3K4/5KAM3ORxWD/wrNh
	 VzvfFXGaRR4rBbOfklPvWEhXKsa2ZRqkYDUG5ukgbSZLfkFDcT7jaZpgTkfZdjy/v2
	 MyF/zZDRovmWQ2/Xn5K5R1uoRrwa3V94yrMqFNfGUqtK21Ok88HhXPDWZ0om90q6el
	 7+N1NeEgpSZYQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3D2FDF40066;
	Fri, 12 Sep 2025 11:41:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 12 Sep 2025 11:41:15 -0400
X-ME-Sender: <xms:Gz_EaOsbf31G_UXVkIOUtD0npSfMH0xLF6dHFR3WGNEPXd02pGS-Dw>
    <xme:Gz_EaBS5LF0vrQqGE-T4tzVT3yWzra1_wjtlfYaSiXICuy4mBnNp-WAsEjzl-yl5s
    DX6ch17wM9xjkcoCGY>
X-ME-Received: <xmr:Gz_EaHnFVMwlGSqkETfEvMPfhx6t1OtXoxkXRZpuyjZpu79YwQupf9WCWtUBKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvleeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeelkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepnhhprggthhgvsehrvg
    guhhgrthdrtghomhdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdguohgtsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhr
    tghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhmpdhrtghpthhtohep
    sggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphhtth
    hopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-ME-Proxy: <xmx:Gz_EaJGoEIfYRYdOJMLO3p1Ayi-LNhwkTjZnkBk9hX6EIQqfnae1mw>
    <xmx:Gz_EaJIMiWEI0LTXh-qd-YU5gzmFymkxr1ZbO2n2SuyFlUmXlbd3sg>
    <xmx:Gz_EaPrAIDTKpJT5sMkEYfN_hCgQIRB427TL9pAeEEF5Ez2_39i48w>
    <xmx:Gz_EaC1u3_UGXrJyTRYAy_bFxc7y2Pox7uFkM5OKfmrYyCh0oq-h0g>
    <xmx:Gz_EaJI2cA6z4MM-kX4yh72tx0H_aTTuhQrmm4VTq_ozAg3kuAhZzXv0>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 12 Sep 2025 11:41:14 -0400 (EDT)
Date: Fri, 12 Sep 2025 16:41:11 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, 	ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
 	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, 	rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, 	akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
 sunnanyong@huawei.com, 	vishal.moola@gmail.com,
 thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
 	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
 	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
 dave.hansen@linux.intel.com, 	jack@suse.cz, cl@gentwo.org,
 jglisse@google.com, surenb@google.com, 	zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 	pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
References: <20250912032810.197475-1-npache@redhat.com>
 <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
 <ab8c2e03-53fb-402c-a674-c2c6ab11f54e@redhat.com>
 <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
X-Rspamd-Queue-Id: E67A614000D
X-Rspamd-Server: rspam05
X-Stat-Signature: zyzd7mhjct48khsq6ipnycqn1hsdoiqc
X-Rspam-User: 
X-HE-Tag: 1757691679-30665
X-HE-Meta: U2FsdGVkX1+McJ1xSK6QFkzBocmQYik9E0PXud0Vi815VaHnn5TWfpzilkf9t/SLowFXWdVtA7yW7A2ezwRelV1hQiNzTM2kJc3uYaBA+ihGcFytnvk/GmJKHNvchPfcHSCoZhNzfnzWKcLn+BKvrpWg/ZWeqYvjVcPaw5fOsf33ADin/Acrkl7gDiAEoYyy3MCzNWJ+TX+Ak+UrV6furRAZQLNdBglj2JzGe49ppWbBWORx4JQ9+v/yyp0AQXgcnif4MYr+y8c/3cf1mqjnK6bvA/+PkYsynfh9G8b8abcFxemaltDEKRe/jL2fByWd1GJtzMPoN6q7F/ExA4uBtIKNPe7+ikVVzmgWiQqWASqqDJo0uRJM5S1f1+7yGoxNkRhErcIdxDvkDi5dPoTZ9Vi3bZRmE2r51VE+QK7Uki67Vl0iJWBYn/VEQdNPHegnglwDYPaYP5SyyceMtJvSE/rKIGdOs59w3qW2LBffLI1PgMGrym80TbpjBey0DNdZUsmffHr+gB47HzXFxN0+WdZCliNQuROB0UXD63NBX+5Osr+7Bq1mOxxdYAGgMW12ECgYQHrxviER1kIsk2bxWVYyRCGexBEwyj9z+Z9zmc347PSIfbbRWqHK6xWZnmmeLZjHckRHzoe/cZAseWb7s/dKPnWjo4bXszYTIH35LQV/E5fPkBKUJBIb4m7pUBMRHzIPIs811gOJZROjf+8SQ2EQ/UtScJq/K8XPvxnCwiDnBRULg+mf86ao8qm/4f/HwOzKuX/boW4hjATzVgS8cevnYK4AmskHrxuZgTpC9qJ4A+1MpjO+2SQQTU8OolCEPPnYoGh0AssPf3UXRod/6bK2RMsPYIxFirX1iQy+LUvZkpio1mbBAwcQ0e4nAh/x7sZNjxnNse2JddO17AVzzuoZgHwb5UPHyzoPtW1xMEpBXrvRRcR7rF7Vf4S0ZTpkJ1TgMqOk/Fbsj4MPctW
 TDHPJWiW
 4fFM/yBaVRBL34Wx0oKHUpCLYKF0NCF+B1I+3AiKcSBchejTWJX3jsv1KPBPlRVtN4KgjqvDcI5rKSKUBGdQSq622B/iZ5Y6nXHGD3H6lGwe4t784oPCCqiNTSVrX06MuKKWEhwEYw3+etJT19CKAmRytBUlZnxWIaFBD0kg86LVfQw4C8dmYI067LV/nfTssOMNvQuItBgjR+QnzlLOVQ5r7D2AeZOFY4+N1bfxWucytOoI2sRu418Nz1WaToEC38AFN4GOn0u/TACKjfhilWZc/mq+/WohxvOIJrjup/WEyI6wLbwyZI8P58R8bsRDbwPDhoLsINSpvFhv6vz8LVwXUzQU/KKMQuIpi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 04:56:47PM +0200, David Hildenbrand wrote:
> On 12.09.25 16:35, Kiryl Shutsemau wrote:
> > On Fri, Sep 12, 2025 at 04:28:09PM +0200, David Hildenbrand wrote:
> > > On 12.09.25 15:47, David Hildenbrand wrote:
> > > > On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > > > > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> > > > > > The following series provides khugepaged with the capability to collapse
> > > > > > anonymous memory regions to mTHPs.
> > > > > > 
> > > > > > To achieve this we generalize the khugepaged functions to no longer depend
> > > > > > on PMD_ORDER. Then during the PMD scan, we use a bitmap to track individual
> > > > > > pages that are occupied (!none/zero). After the PMD scan is done, we do
> > > > > > binary recursion on the bitmap to find the optimal mTHP sizes for the PMD
> > > > > > range. The restriction on max_ptes_none is removed during the scan, to make
> > > > > > sure we account for the whole PMD range. When no mTHP size is enabled, the
> > > > > > legacy behavior of khugepaged is maintained. max_ptes_none will be scaled
> > > > > > by the attempted collapse order to determine how full a mTHP must be to be
> > > > > > eligible for the collapse to occur. If a mTHP collapse is attempted, but
> > > > > > contains swapped out, or shared pages, we don't perform the collapse. It is
> > > > > > now also possible to collapse to mTHPs without requiring the PMD THP size
> > > > > > to be enabled.
> > > > > > 
> > > > > > When enabling (m)THP sizes, if max_ptes_none >= HPAGE_PMD_NR/2 (255 on
> > > > > > 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 for
> > > > > > mTHP collapses to prevent collapse "creep" behavior. This prevents
> > > > > > constantly promoting mTHPs to the next available size, which would occur
> > > > > > because a collapse introduces more non-zero pages that would satisfy the
> > > > > > promotion condition on subsequent scans.
> > > > > 
> > > > > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > > > > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> > > > 
> > > > BTW, I thought further about this and I agree: if we count zero-filled
> > > > pages towards none_or_zero one we can avoid the "creep" problem.
> > > > 
> > > > The scanning-for-zero part is rather nasty, though.
> > > 
> > > Aaand, thinking again from the other direction, this would mean that just
> > > because pages became zero after some time that we would no longer collapse
> > > because none_or_zero would then be higher. Hm ....
> > > 
> > > How I hate all of this so very very much :)
> > 
> > This is not new. Shrinker has the same problem: it cannot distinguish
> > between hot 4k that happened to be zero from the 4k that is there just
> > because of we faulted in 2M a time.
> 
> Right. And so far that problem is isolated to the shrinker.
> 
> To me so far "none_or_zero" really meant "will I consume more memory when
> collapsing". That's not true for zero-filled pages, obviously.

Well, KSM can reclaim these zero-filled memory until we collapse it.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

