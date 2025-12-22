Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D17E674B8
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 14:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2EB26B0005; Mon, 22 Dec 2025 09:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC986B0089; Mon, 22 Dec 2025 09:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4F16B008A; Mon, 22 Dec 2025 09:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9BC66B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 09:49:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C7D7885B8
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:49:52 +0000 (UTC)
X-FDA: 84247391424.06.6BB2E49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4BF034000F
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:49:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3qFahro;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766414990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7HC/mPrAGRNRkOCrBAOjoyo5kbAM2ERt5Zjzybr+mdA=;
	b=MfY92rKrcuDZqMqomS1nt2HiMsejsj7v5zTkMsHvduDDE/QGrL1pmcn5LZXGo/J0Vz3roD
	fO0RGNrltFYV9UKbNsffLm7DfTcFjPieO18eRbD6t5fNLhtYDkzhpx4idQTBI8khhbVPtF
	1ftGaygSgn0iSazDUcM+6X3HhQPwXWc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3qFahro;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766414990; a=rsa-sha256;
	cv=none;
	b=vr2xblU4n+SBc6fW6xOWCMZUD5Tm+YW7QidJg3BD8fw/awWw1gmuY5SXoy8/V9N77Bwidy
	Cnu+LYfyULSvTnJvdAnqD0bFt0aVwh5hcHqOrcJ+vyzXBsIbhSJo+C1aG9Fud7S2wjgLUH
	0nvfvsagyZ8vKyj0dSNcmCYGA57TrBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FBE4417B1;
	Mon, 22 Dec 2025 14:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D3EC4AF09;
	Mon, 22 Dec 2025 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766414989;
	bh=vGX2ebHS3FUA9kDS3IHb3mZtMfSrYA7vMezy7bzyoVk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3qFahroge6rI/hBe6z07XE9a2/VK4+/lv9eCCDExK9vbGqgq/QB75DRuEdtMZe1p
	 fBr8VhzYpLc9pEt+xsWZZoO+bFFndyqwMzpMr1mDwteisrcygmlbLd+gyp2gDQ6U1o
	 PIonx7xV+e5tKwmzMiapJYPdxE+OyD8rzAwkRnCthVV8UVvejAAW/3++fAIh3MQG51
	 ESJLG85wRzbW5e7ktAUOX6AjEfGIyT9dTtUPi0ppx/gTz4mU0yOX0dd8gmokbeC2Us
	 50baRPjWIRA1IbY9GgGAJmviFXmr9nx2brZjYFYZesTvYT/vKBnRvmOui25IXiEutu
	 0tW8xP3X7YEQA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id E85B8F4006A;
	Mon, 22 Dec 2025 09:49:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 22 Dec 2025 09:49:47 -0500
X-ME-Sender: <xms:i1pJadEB5s4PfmL4VfeBPa8rVwho-OmEcnN6121wT3usdCZIBcRL8w>
    <xme:i1pJaduqe8bBJZ2fNCk7UpOF4uie2JM2FP7iWf5R2MY9xE4AP9_0canUsCj-qqQ0S
    L29ghdlAmOVBJt7wln3grHD8ulZjXMCOpk8JX2wFcIPLkVC92t3sd0>
X-ME-Received: <xmr:i1pJaYiHvTY2m04sxTzBVGh8d8cCv6fRN94kGE3P02QhNVjd9PibOHoLjQ35rQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehjedvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopegrkhhpmh
    eslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:i1pJaa0sQuuP5-tF1CG2yd8RRV71mcDHOC8k7SEUEhenN5uvOAPlrg>
    <xmx:i1pJae5eddop5tXLgu3yJSPnvW2a8_O4MuAJuApNQgw67ollCkw4Xw>
    <xmx:i1pJaUppEP2SKKU2jE8oye7ZexoiZgUIvckyJaRl92VkTkSHoLD1cA>
    <xmx:i1pJadAa74JB_6hTAj2tU0BhjKZ_l9BvO9FtjdxJv_oc2LZiGdJXkw>
    <xmx:i1pJaTylCX1_5TSQ2u3mt5x1jWa40Rt1i7pGfKJBtV9aSLJp5KHr8Cb7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Dec 2025 09:49:47 -0500 (EST)
Date: Mon, 22 Dec 2025 14:49:46 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv2 06/14] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Message-ID: <4ftjalacw753dx7beowgtxs7heckx2eopfcgugxyomgn4qwujd@fxwey4d2wqtn>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-7-kas@kernel.org>
 <34BED0AB-22AF-4107-84FB-543D11BCA136@linux.dev>
 <78326B0A-7845-4D80-8BAE-C2191030F8BC@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78326B0A-7845-4D80-8BAE-C2191030F8BC@linux.dev>
X-Rspamd-Server: rspam02
X-Stat-Signature: zhr6n6yfrbbaashhfjexbbbmy9ido5tg
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BF034000F
X-HE-Tag: 1766414990-948525
X-HE-Meta: U2FsdGVkX18M+dFOCN1byel1dxOCRCQvjlt2hCv1NIRbFwRNliZLyQlV0waxWP9akCxOTV9WcnjxJxYtEZgcO7ZykcbN576nGdMjo6j9B1uij+Lbfb/N0IvTO38kXXRwRlXiu/UIuAMvfrEdJddpdqPEs7KjTDDgnKXL+AIkYhJImCTD/az7P6EmA5dl8c5gyZX5dpQEiQrui2Xi6biGOOjE1JcFGY3isbn3I8E54Yt3DUfHYqXFLbT3hwlDXnrT8qQN7wmbp6/vglvcE7PbXgD+Yba5eWemJnvPfJ5yWGXnBL9nR1iGFSTiclIF2xTNWWfPnd0ItL+dobbIXn8HEHlJrJc46JCJOuaOASmSDaHGWmJncJcQuUEe0LTHiXd2L4P3xvv+PPCoDTmPcuH4cyEkm+FaPXXi1rCjCoqpJ9AysmO49W/ophR85nRKYxwuMVWITY4kEV2IO/5we2MuFARZYhggP7Bcz0olm0dXHSLy4RG0TvbOi4srz72BnUZBnI4GWJEDUMfK58UdJu+P8UZD5UlXz4F6IB13SSRrFikFB7+HKvZ8GfuoF1zVYf8qGoeP+4Y3gy2SaSnmoIf3JpwW2TPytCgHyZon0uLywJNSXELkz+MDCH6JHRjY9jZY99Sbiw4meC3b4wha2X2cOu8LAQ8rzcnELHJta0hVTdX8giPdx8fDWEpbsxv8faHVkn9mwFnlBvnaj3PMo3tKv2aCJ5FwUXciatx6qp5GQcptawVRWIQPAdxnOwj6+DZQe3Z71jFHpsoINB6dyXhJLeZ1cH6WhcqIx0LHKmJ1A79xGR/tdC5xFkcq81zcuYUzRWpmkoFgWRHUkrRoPz63+VT+MLt5+kmwtOnH/Tz8O3IMk9ZM07MVS5f4n6PD/vw31TaKRl+tpbwar2mAbvKaemGyAOwlGZ11rOJOai97zNOFDRIVtNftdTKPJTqGA/kzxLQMWioJh9jBL0TLPMM
 ZwaHfCoD
 IwShQhNEf1BA+2hrWkj7ddEAC6x/Kcf/+06/7mP4faCLaW+UAj+7QAkzrdSpQ0m37Gi0+2O5PfyJX9y/AG8CaQnyxGwYpUgKqiXfuhz2iZwX0nl6Ccxp36IX8mCyA0q/Xt6Cfr1iJ7pPgXNxdA37GFjfto8ggwyIbmRA5MCEWDMx/btBPNj95KGolIj1Eze/FLjTCLDlrFoEPKVbljapmJB5MR6EfYAVbeSc3Mv2NeMTl3wMcTMi2YWe42RKVtVeWazHgMsigNQjQ5/I+o4W8IB3tgXeYwDDgJyowOtvH6XM/dkNK9R2ePbxClz1TRnoF8hIVkSpPlBGZoVGX5G3kuQtyp5esMDuGkHdf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 05:45:16PM +0800, Muchun Song wrote:
> 
> 
> > On Dec 22, 2025, at 15:57, Muchun Song <muchun.song@linux.dev> wrote:
> > 
> > 
> > 
> >> On Dec 18, 2025, at 23:09, Kiryl Shutsemau <kas@kernel.org> wrote:
> >> 
> >> For tail pages, the kernel uses the 'compound_info' field to get to the
> >> head page. The bit 0 of the field indicates whether the page is a
> >> tail page, and if set, the remaining bits represent a pointer to the
> >> head page.
> >> 
> >> For cases when size of struct page is power-of-2, change the encoding of
> >> compound_info to store a mask that can be applied to the virtual address
> >> of the tail page in order to access the head page. It is possible
> >> because struct page of the head page is naturally aligned with regards
> >> to order of the page.
> >> 
> >> The significant impact of this modification is that all tail pages of
> >> the same order will now have identical 'compound_info', regardless of
> >> the compound page they are associated with. This paves the way for
> >> eliminating fake heads.
> >> 
> >> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
> >> applied when the sizeof(struct page) is power-of-2. Having identical
> >> tail pages allows the same page to be mapped into the vmemmap of all
> >> pages, maintaining memory savings without fake heads.
> >> 
> >> If sizeof(struct page) is not power-of-2, there is no functional
> >> changes.
> >> 
> > 
> > Forgot to mention, I believe I stated in the previous version that this
> > mechanism only applies when CONFIG_SPARSEMEM_VMEMMAP is configured.
> > Therefore, you need to wrap the entire mechanism within CONFIG_SPARSEMEM_VMEMMAP.
> > For other configurations, it's difficult to guarantee alignment to a very
> > large size (for example, in the case of CONFIG_SPARSEMEM && !CONFIG_SPARSEMEM_VMEMMAP,
> > vmemmap allocation uses kvmalloc, which only guarantees PAGE_SIZE alignment
> > for the returned address).
> 
> I found that we can call kvmalloc_node_align inside populate_section_memmap (for
> memory hotplug case), so that we can specify the alignment parameter as the
> input size. Then, this mechanism can applied for CONFIG_SPARSEMEM &&
> !CONFIG_SPARSEMEM_VMEMMAP.
> 
> For CONFIG_FLATMEM, we also need similar approach to specify the correct alignment
> in alloc_node_mem_map().

I guess I will need to invest some time to make a test setup with
!VMEMMAP and FLATMEM.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

