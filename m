Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 582A8E9A04A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A476B0005; Thu, 19 Feb 2026 10:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B8376B0089; Thu, 19 Feb 2026 10:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590046B008A; Thu, 19 Feb 2026 10:28:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42F4B6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:28:13 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3348C20E5
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:11 +0000 (UTC)
X-FDA: 84461587182.25.924D7DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A52BFC000B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:28:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2b18wc6;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771514889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Qd1PSalibMgj9dyYWg9c6JP2+0EVzbf59GUaTntrOk=;
	b=PXQbEcNyU6oan17phsmWklm6OFF6WEIMvycjnJV5Ugb6SZo8smnpuHS4CN43DOkhstklCI
	UYldueRl/vYZLDB3tMexgKDPz4YdxCkiLR8EjLx7t804lU5WEuwUn2bB+oU7dwNzIcM6kW
	E6+htC2r1E4o1ZhhvSBn3C/cfZXvjAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771514889; a=rsa-sha256;
	cv=none;
	b=H+a853ELePSnFF3b4PWchqOvzsbc9Rig/nJHL0Jaj51qgoSR/umtvsepymskDKsqe6gtIE
	uS6T3jXYt884WQaSHh/wfw9rTgeA07CxMj05VSLOSt6BlStEXFwVcrlmi2LAWekhUre/3C
	0DBO40c+fax8GdOAGy0ZZxQuWL8z7C0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j2b18wc6;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 707004397E;
	Thu, 19 Feb 2026 15:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD2C4CEF7;
	Thu, 19 Feb 2026 15:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771514888;
	bh=f4Q0mhC4V5Y1asWnAo+wPk5z+L+junl4lth36hRUhyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j2b18wc6d8mKObuZDZcbcIzuupy9GJ/thgIBg/Geg9r845Ph6HT6NQzzAyfPmnPeN
	 E5/CyUXcPyZHN9V9pLkvTLJKvqauNZDU2T9pd374HGXN5NDlIU4WeQvOa4MoG17faH
	 jRH1Ika0OtMWy6/S0rGd8uzMhW5BS+BUQPBHA6aYtPvIpmv9zEpStMJ52CZL+R+50I
	 CKUFAFsJ/5I9MXIAU/bxDMOb4gpVXwL8+uqbt46XE08DKQHgJo00yS5ZpC3Qw1DHmu
	 H/fC6R+uT+H/JdVIxC6RNXfVW+9l+EX1CLTA5CaaGqaXwnp5W8AcHHygPdSlHTcO3l
	 a4vWEEWXhMHlw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9E165F40069;
	Thu, 19 Feb 2026 10:28:06 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Thu, 19 Feb 2026 10:28:06 -0500
X-ME-Sender: <xms:BiyXaSh7HBXQNSREZ5GQTO2WV5i1NhFZ8ryZ_Alk-MRfwTfck-k7NA>
    <xme:BiyXaffgNbCTEdoP33CulgWG3gG79R_JHCXPt9Sd_NkNvhSKCy-FPmlhz5h7XKj4B
    M9L-MrfwS5i3KYzBunIhBShkUbQ8A-iFF1uMxJfhQWaVKgowTvtgQ>
X-ME-Received: <xmr:BiyXaRX-oA8j7iDQHcvLzJ5FQO5_1Y1ErBvsdj65lsJz0Fcor-mxiSjHwUJwPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehkeelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepgeeiheeuvdduuefftefhueejkeekjedvheelffelveegfffhhfejvdefgeetjefh
    necuffhomhgrihhnpehlfihnrdhnvghtnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshho
    nhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnh
    gvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepfeegpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehlshhfqdhptgeslhhishhtshdrlhhinhhugidqfhhouhhn
    uggrthhiohhnrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorh
    hgpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrd
    guvgdprhgtphhtthhopehmihhnghhosehrvgguhhgrthdrtghomh
X-ME-Proxy: <xmx:BiyXaRwphHrl39b5guLltfZoFC0ZL1bvkaAiFc7Rc7ohaSp4QeNPCQ>
    <xmx:BiyXaQAO6Gh-mQV5rvWGekc362e0ejIDtdDd2PMGyA_lgXoDslZvow>
    <xmx:BiyXaf7s4WUy409gHc6U0jZaBFXB9mlOdLwjZVjd8dfywbGg32n8jw>
    <xmx:BiyXafkQKO-A1qgRNR6gL7NxwVaLLcUKuOtgNZjHhWbV6jnDGlwMBg>
    <xmx:BiyXaadypQgu7_PRoxtocQw3DnRPcxvLy1DQSU8zlazHBEvR6jktoQud>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Feb 2026 10:28:04 -0500 (EST)
Date: Thu, 19 Feb 2026 15:27:59 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <aZcrj4iYLzXk7SPz@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <20260219151729.GK1282955@noisy.programming.kicks-ass.net>
 <20260219152045.GR1395416@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219152045.GR1395416@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam09
X-Stat-Signature: oqcs5np9zcdu68mys8xh4o7f6rb773c4
X-Rspamd-Queue-Id: A52BFC000B
X-Rspam-User: 
X-HE-Tag: 1771514889-107891
X-HE-Meta: U2FsdGVkX187OiNv+ZBgMhC6uEzuAS2DlDfGmdJkMgrd4p4ASq4MTr3e4LiOui2rXv8ICkyKWxudpFmWyE+MusYe6cazjs4kq1p/eWyx88Y33iWT5wziLpU6cH3cNN4YBKKyMV40h18+9MHs71af0Ddn9m99yM3eI9mpKOQma/wpxzH2lxpsHIOVbAzP08K+18lRPFpn6l3LX27FUU7bO793o2EskjSSz89GYH+5DSusls07JDvzzZ7URK7uGCGojubC1KjDESDvf0I8aS8ifILeDWrENuk8/is7PtPGB5rHr55kHO//AZO8KOajXh67ZaD8/PgJEfKLvLSvQZaMzLdnrwY8McHfUG1mUdro4pGoudlYwpuorXyBI/SCj3Y0/6tO4h4GaXxtzISIJ6vnF/DQmGoFYAqDrhFsokCvaUbmHnIiaQx6737bFhnbOiLoY6ZC14J+darRT/FLBUpbywIJOFayko8BCOdFQTYzeuRvg4dtQ7eXfn3ola7o6dNqpYsTa2G1do250ZYjm/aKdVXudy53+zfxfqTbHlw+HKdm7oxJ8YYBejmlBXM7uwpAWcD8iJHYxoWbr+hMMNV9G7OaY/0GrynjWFCFc5YG9GACMzuwm+nuprjbiRJ/YP4r/AIIY9itZpk7tFBq9ncT25G90sPvP4KRClVCFscBqnp1C81V/zMUHfKVrtU5ahklBv84UDhOObV3bxT226Mlcr71D5uQIZBzYjnzpqFcbpJfx6p7XBl9vxt6JlkwSnZy+NUgsK0CnZZV8rbESW/BvShb0ZFYacxnpgBkdzx3qAQPrw3rPlpSzdvD/mTiVMoHDBRDNq+EExOIU3pBPs/JjiVnVlNsMNY/qiBC3LNDckfgNpwdIXLCJ/fQlsWADAOCueU26VFdkUYoo9wmgsoJErG8AciNwh7rHz/zpv9RZIz8kEEvA2E+nZve0pG5/+4ATjlmsg1YIukGwb3tTy8
 W91hOEtG
 IEu0JmvgGoGvXcvGmh4H//eZoXi5pKe0yXwSVphniBlKu22y8loImydeYQDUnI+Uw3mOL9AgGqHVOXHYW75Vbk7ffYnog3YYnZRek3FXuhm/pmVdAr9m8y4v1jupBz6z/rOH3aM4XpoCySTN72ebUEQylvcQ9MIeYSUN9cAfCUjtJXk/lcaOzOAb7iwPOJRe+yxNJwLY+x/uiOQTeUmuutkRQot8COVY/CKJK8fD4hV1KteQa5cv0qXBHYjRa1lMHcDeCg8Zv4I0LlxpFvQ+ckIhqJQF+2MMbwNg6Tv4gzvAUw99A35VZTyGEnoyoHukR7U/n8h/pLp3n5gW9poS4QY1qGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:20:45PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 19, 2026 at 04:17:29PM +0100, Peter Zijlstra wrote:
> > On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > > No, there's no new hardware (that I know of). I want to explore what page size
> > > means.
> > > 
> > > The kernel uses the same value - PAGE_SIZE - for two things:
> > > 
> > >   - the order-0 buddy allocation size;
> > > 
> > >   - the granularity of virtual address space mapping;
> > > 
> > > I think we can benefit from separating these two meanings and allowing
> > > order-0 allocations to be larger than the virtual address space covered by a
> > > PTE entry.
> > 
> > Didn't AA do this a decade ago or somesuch?
> 
>   https://lwn.net/Articles/240914/

Oh, 2007. It predates me in kernel. Will read up. Thanks!

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

