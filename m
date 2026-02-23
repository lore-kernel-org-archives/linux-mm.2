Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24B4E98DE6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF236B0005; Mon, 23 Feb 2026 10:45:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074E16B0089; Mon, 23 Feb 2026 10:45:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98846B008A; Mon, 23 Feb 2026 10:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D24C36B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:45:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82B591401B2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:45:56 +0000 (UTC)
X-FDA: 84476147112.11.E1B1089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8084040008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:45:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIzj7M6q;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771861554; a=rsa-sha256;
	cv=none;
	b=OQ/1+vENZjII7988APnxbbf7RTyLYUlt40v6mXbltfPvtw1KyyJd/dJJLw5Eh6oGfh7TL7
	nRjRmzSipogakFAcSf8Gx5K3b3BBR76mSwAiHIHlU/NSD4HvYhrj5pt1uuwYU4J5dsF50t
	Wg2pY7xsHv2lWXiq4nM6xIoKYgTHsHU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JIzj7M6q;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771861554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrN8M9Oy17oHRxRgbfmasEd9wYF0GN7zADg08RbfAtw=;
	b=4wkLZnn+gftkbS02tuYbld7PZP29YnJm5vWfsIML3ZGIh4bgNLjlicywfrjhMsZNBE5s8a
	FxgH+8fxudGKgibg8XiOlboPMxx/gqvbUFHb2LKmE3MCwY1H9NReoDakLkmgvT61QBkVFA
	at4zZ9+MmCuYxVQZNFJ3La5eFzmSTYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5905E43DEF;
	Mon, 23 Feb 2026 15:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA280C19423;
	Mon, 23 Feb 2026 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771861553;
	bh=BBxJCHeFC3GBOWJ8Wzc6zAoR4tjTZc+xAp0aFCiqgeQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JIzj7M6qLo/ZDz4MhcDFYj0gWF4BjZp4uABaCPE9PqACpX3Eiu/xVNYaAZDlQ0d6k
	 /SL2J+eTCe8kw8COLJEel7BTc5p+DaXZOidxnqLynqFyyD/KlcZ0JSdsIwVBUjrq5P
	 mHM6ah7waSBf3krhs3ApvG/5pT8KDrvFYgOSuaRcZtMFo6GvZ0DuYs/H2UIKHMjg21
	 vgzvVlpjqVLLJa6Pt0qXvBEh/5K79uQ6HmoLjNJG/5P/96uadcKbd3I3rUC/ax2Ee+
	 Yt8JKuU6X97dnPW9VZHK0XOkaTdgXKAx5EUB2+KeZcGDFw4AEXYYQx8KqbkE6C9/kT
	 5jgRxtj4Lyrig==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id BA965F40088;
	Mon, 23 Feb 2026 10:45:51 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 23 Feb 2026 10:45:51 -0500
X-ME-Sender: <xms:L3acaRyNRcH7-Z46Zd5-cr_POoSSmXzzKN1z9Wf479hEr75CE65U8g>
    <xme:L3acaTKlIoiidVnFAZsPKsNVmQ_RxRg4uvNA3d48GwLRhCQLHTJrmtdFROkIivXIl
    3D3RC4BX5oMBjIC6zr9beNGgXlAofnAIFySPMlKhT85mR6LbpvCnrq0>
X-ME-Received: <xmr:L3acaf9-A8jAxYrNHrig4XdMBnWeEw-ZUApzjKQeXcsP8JyLCKe66uede4ROug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeejiedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeludettdeigfefhffhhfelveeludeuleduvefhgefgueeitedtleffudegfffg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepuggrvhgvrdhhrg
    hnshgvnhesihhnthgvlhdrtghomhdprhgtphhtthhopehkrghlvghshhhsihhnghhhsehg
    ohhoghhlvgdrtghomhdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgr
    tghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    htghhlgieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:L3acaSB1ExZVTeFqLNIwYuQtz_5B2yCEu2nmq4rNTpDT2guFOOC2XQ>
    <xmx:L3acaTAUkIyySzqlkY9yOro3amySkOUP4a9wutVvZalNS61QXijSHQ>
    <xmx:L3acaYxZuOZoKlF5WbxMWot6P3fD38cfqF-pMo-gTQkwKXDM5PF7ZA>
    <xmx:L3acaax9YhCoFrO8gAh48ZlQbmuxtDQ3ANjGMSPTLC6t-LLlKZo2hg>
    <xmx:L3acaQhDWRVOmm_c-vGbBiHFyzH2y7lKIseCYp1nPvAI0A1HagbJ7df9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Feb 2026 10:45:50 -0500 (EST)
Date: Mon, 23 Feb 2026 15:45:49 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, 
	Kalesh Singh <kaleshsingh@google.com>, lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	x86@kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZx1EOLutZd1XrPP@thinkstation>
References: <aZdCl8byz51Q1-v6@thinkstation>
 <17c5708d-3859-49a5-814e-bc3564bc3ac6@kernel.org>
 <aZhErt9DZcWI24_v@thinkstation>
 <d7c7ef63-e40c-40c5-8ce5-a4ca411da832@kernel.org>
 <CAC_TJvd=wKKnj=d3phZsAaarXUdUbZDGauxWNWkQtsFV-MTYEg@mail.gmail.com>
 <32ed82dd-62c3-4a5c-8bae-9465afd7e75f@kernel.org>
 <aZw1DlKHaWvgOtm_@thinkstation>
 <06684dc4-3902-4452-824a-ee2064314d24@kernel.org>
 <7b414e68-4d0b-4d2b-a664-bbbdf314c0d3@intel.com>
 <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <89cc554e-9c6a-4c8d-8c30-573b2eabccac@kernel.org>
X-Rspamd-Queue-Id: 8084040008
X-Stat-Signature: 8xgynb6annseoaxfag7chhwb1xq6umt3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771861554-83623
X-HE-Meta: U2FsdGVkX1+XSbvkO3fgl7K6aVpDg6hVcRybS9eMSpR8pvXJkp+cdLL7Nc3dHt9a/qvp59oakNeCupvIBTHRKn61JCTNUEBYTxprMaXbHAcxBnOZCfZH2wZdvIa1jIZHjTmPL6pogs0dbMJyhC8DmxwsUZXooY9Zg9CYTjJVTGhufKApXNuEqHp0CAkK4/mZgoqNGRvAcgWSq29Aqq0eo/6dx0Oe2kVJAKPB/q3ULwsT1DwwvTuBZ2AdAZqDaqTAOqG9MEapdqAySNpu67lwhIM3J5METs/q2AqCV6VoK4/YzZGBwd2D1HYRVM12PhKeWBCPqrhLyEpzUU1Er/GlvjuHCO2xMsTjYeFJds5maa6xd47Uu8pNN8ex3+yJ9aC3OLEuX8mkjV+Ch3ViaJBFRDF9bJdQnzU/aDblTtt1X8+Gn67/g7Z8pJMr0mpe97l63rki7fpr1bq/9cL7222BNNWnKiCfSWIhFSdLfv9Gy5zuaHEhtfZTK0Df3HLo7s3MFo+HhetWnT20K3BtxL6y1dydgzvUM1HoefGnLUohq8iGoaAI/ynfItNkAcoYO4EF/v7haYLm4/Bm7Ai/E/3JMcnPJA4d84zojz5cjCLghB02Pbk34As1u61JCw3dI9k71VGZ/8IBctfPxJTt5rH1RdD+8V1c0s3SxMuEZUwlQLz6je5SSOX8xiq3gg5Ro/BZRLg8KIzzxlrXNZAOhaVFDGRxLqWIMD5dWzfnaI4UgbXRil6gAFn75uQEmyNnzfTB8L3/mID1hGt00udTmRIB8TI8X72PZphxigYEKZPqUS9j0TCCKtmU6bmnfO9vvnAwYLvBc6UssshpZ01R4tpyW3D3udRorriihgDy8Yp8gZJywQfJhzFAzhmhH5Q6OK1ihdJObCfttmwSbb7A5yi4PDahLQM3lgpv999SaZyvQzDaR5jwXr8rsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 04:31:56PM +0100, David Hildenbrand (Arm) wrote:
> On 2/23/26 16:14, Dave Hansen wrote:
> > On 2/23/26 03:27, David Hildenbrand (Arm) wrote:
> > ...
> > > > BTW, x86-64 SysV ABI allows for 64k page size:
> > > > 
> > > >      Systems are permitted to use any power-of-two page size between
> > > >      4KB and 64KB, inclusive.
> > > > 
> > > > But it doesn't work in practice.
> > > 
> > > Even in well controlled environments you would run in a hyperscaler?
> > 
> > I think what Kirill is trying to say is that "it breaks userspace". ;)
> 
> Yes. Probably similar to Intel proposing an actual 64k page size. Expected.
> :)
> 
> > 
> > A hyperscaler (or other "embedded" environment) might be willing or able
> > to go fix up userspace breakage. I would suspect our high frequency
> > trading friends would be all over this if it shaved a microsecond off
> > their receive times.
> > 
> > The more important question is what it breaks and how badly it breaks
> > things. 5-level paging, for instance, broke some JITs that historically
> > used the new (>48) upper virtual address bits for metadata. The gains
> > from 5-level paging were big enough and the userspace breakage was
> > confined and fixable enough that 5-level paging was viable.
> > 
> > I'm not sure which side a larger base page side will fall on, though. Is
> > it going to be an out-of-tree hack that a few folks use, or will it be
> > more like 5-level paging and be good enough that it goes into mainline?
> 
> Just thinking about VMAs spanning partial pages makes me shiver. Or A
> single page spanning multiple VMAs.

Hate to break it to you, but we have it now upstream :P

THP can span multiple VMAs. And can be partially mapped.

The only new thing is that we allow this for order-0 page now. And you
cannot realistically recover wasted memory -- no deferred split.

> I haven't seen the code yet, but I am certain that I will not like it.
> 
> I'm happy to be proven wrong :)

I will do my best, but no promises :)

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

