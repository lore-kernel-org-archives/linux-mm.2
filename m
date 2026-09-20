Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145ACC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 03:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A386B0088; Sat, 19 Sep 2026 23:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA4D6B008A; Sat, 19 Sep 2026 23:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC026B008C; Sat, 19 Sep 2026 23:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47E6A6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 23:33:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F53140373
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:33:56 +0000 (UTC)
X-FDA: 85232721672.15.A8D6282
Received: from mta1.migadu.com (out-78.mta1.migadu.com [95.215.58.78])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3372D80003
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 03:33:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjFuIBdx;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789875234;
	b=e1Z9uToITe4k07rNv3I2udBLQiJSRPThUYJYeJtkxHgb7BG3wGKtaxSwWyZhbuC1lZfPhk
	s4WJ/+jsr1jM8dLBTLCSTieTRQ9vOU5e+U+T3dQwj83gyN4JS3kUZJFMJ2i0BNepEioHDn
	afpS84rd4NXkrFgDVkFnUjh6FxH3Zdo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MjFuIBdx;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789875234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7ZVtpRa4xG9tmEOcZ/WJOmfdObDCumvMarROr2J/Xo=;
	b=YOlprmU4+DhM5NCyVf1F0bqTlT89BcHu5V/EBqUQVPqroRy7aXO86hERHUfNmjVbePfhv/
	FZTum47TBM3Nx6kz00/oflnKGRc68RV10uI4IHp6/6n7LnV+KsWkxYfyoxTgd7ohGpEOGI
	zYuvFcb0kFm5xlue9gTzFz5gqtjlZu4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hXLqE47HqcLGyqOng+gJY4MA1aiOWDH2fotgfictL0g=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789875232; v=1; x=1790480032;
 b=MjFuIBdxri6mnPIUOZ/bHRkOn9QfFFAQ/Q0tabD86fdfsLaHgHc5pFS1MJG6bPQIFl3Gca6t
 kDUwPfcgXw4TbXfFtT1ksq+r5VLNgYmTTo+y/m6Qe1Fm5WLBb1VtWBJjhIKxd4GXgMgK888pnSb
 W4ddmcOquFJ+NHn4dj3C3t4o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 15499ad898b25d57;
	Sun, 20 Sep 2026 03:33:52 +0000
X-Mizu-Trace-ID: 15499ad898b25d57
X-Migadu-Flow: FLOW_OUT
Date: Sun, 20 Sep 2026 11:33:45 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Mike Rapoport <rppt@kernel.org>
Cc: Wandun Chen <chenwandun1@gmail.com>, catalin.marinas@arm.com,
	will@kernel.org, chenhuacai@kernel.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, robh@kernel.org, saravanak@kernel.org,
	akpm@linux-foundation.org, pasha.tatashin@soleen.com,
	pratyush@kernel.org, m.szyprowski@samsung.com, mark.rutland@arm.com,
	kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
	ruirui.yang@linux.dev, robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, iommu@lists.linux.dev
Subject: Re: [PATCH v6 06/10] memblock: introduce MEMBLOCK_NODUMP flag
Message-ID: <aq9UGXeqmCfuPHdD@fedora>
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <20260902073116.802752-7-chenwandun1@gmail.com>
 <aqzxavL91icLw-Xv@fedora>
 <aq41nFRPtRWTQ7cK@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq41nFRPtRWTQ7cK@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3372D80003
X-Stat-Signature: r814sccxme8c7dasxfjiosxfwwkkafe5
X-HE-Tag: 1789875233-743844
X-HE-Meta: U2FsdGVkX1/easC0lrjLgt5TFgk+uZffMhPBTU/T1EL7oynklYZ9WnwsxUYfD96m2BHJjR9BM7rEbOILamYg/KCYJ0lg5LbdfGU4tJOuHy130tZyUv/C7tOrgQSVppj3SWdNjHDTqnR3YEAjCOlDgGCdMXQBYowH4L1CPck6jNU+U0kOEUtNyB3+jlRXB58WA80t3Nl81e5S1ogYLwNaQ/bnYhsI+BC4Nkd9Sc6S7TwI0cGWoCZ/hL56eYKpF2MrePDOGXNzhZAah8nhHl6yOO3F8CbBI3CGD2U/cUeqjpsDOAehrjTyWSiE5f4HiGDXsVQMnYkxMY2CYXFh9MAeZX5YvIRqbTzxZKjKBWNVieXDS40CpQk1+E6U3pE3ofocVjVZ/51FimuDvWbZLkwmNF9KK2OiJUpAgud/sT6Q8IlzTBD6cKU3t7wSLhXYgfDBZY9jqFEvb8BKCk1v504rxvi3Nc1A/7m54PTCBTEEdnNkkI7crTZsZD0n7REnZNnkRdqsdEuqMDoUI9SMMVAxPOxz3XluW4BadONHxG70iQ+xK+mSBdHSlZx52u02oSABuR8CF6VzHuao0LF9wLrl2ru2KdwwfVa03szpOiIYinxrLz4S4Vw6f/F4/sDECaZwVRv2/Ux71+WtJuiud3KcPHZp51WjQmMnHn+R+e34zj+Am9mtGrMvX3X3E2VsD89O3toqQr/hn58WHsSJHR8bLLpfPRBpZMjdrLAhjA6nArCQZih+xzZgWHci2ihXh5/06U5d0u3Ckk89NNU84jOfEgMKb1nxAh5XGDnf311pkIQlvPUpYNlDeULdJlwEwANfRLYQn2RDq6fbHQjRTlr3FJ3de8Fhp9bpIQwy6HOqT5DBRoivMK5XHazEsu7ARY9T/skaUbTi8GD3NEsKqplwy4+/+TkUXmqvtYxC7s+caoaP30vqVhBw5XpWY2WsVlO/9VT78rgrTBFCU5TVm10
 w3w9q3Pg
 exm7xHrx5aId4IMW47sH2Vvu0LxyIznGmpS+bsrMi+iYjTwwLpxSZYEwgb+gxURF9g9w1DphalcRfEeWTFywUq+eXFR0awtaW46qzKcqoJji04g4zElFyuari8gB+Wxj5bWeYVV3tXsjAabHZy7nt/wWwLxtTCDi/7Uz24Dt3bNKMchd2acnvlMQunTCpmz+5oKhlV8ECC6PAbzvpEX11WYO8/eu0oBDUoHomfuATCMyWynVOxXTis/iYppQUm4WndDlPKjgk6TXzE0P3U4BFxTukuS7BuK7PHqoC+7EJxo73rWTPu+GE6M5SGKbQDJ2+sOwH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/19/26 at 10:11am, Mike Rapoport wrote:
> On Fri, Sep 18, 2026 at 04:08:10PM +0800, Baoquan He wrote:
> > On 09/02/26 at 03:31pm, Wandun Chen wrote:
...snip... 
> > > +/**
> > > + * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
> > > + * @base: the base phys addr of the region
> > > + * @size: the size of the region
> > > + *
> > > + * Mark the region as not to be included in crash dumps.
> > > + *
> > > + * Return: 0 on success, -errno on failure.
> > > + */
> > > +int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
> >       ~~~~~~~~~~~~~~^
> > Is it impossible to use at runtime even thought it claims to be generic?
> 
> This should only happen at boot.
> 
> Allowing modifications of memblock properties in runtime is a can of worms
> I don't want to open.

Thank you. This is why I said this can't be claimed as a generic way to
mark memory region as no dump. The generic way I'd like to see is
at any time of system we can mark any unwanted memory region as no dump.
And it won't impact the behaviour of the current system.

>  
> > > +{
> > > +	return memblock_setclr_flag(&memblock.memory, base, size, 1,
> > > +				    MEMBLOCK_NODUMP);
> > > +}
> > > +
> > >  static bool should_skip_region(struct memblock_type *type,
> > >  			       struct memblock_region *m,
> > >  			       int nid, int flags)
> > > @@ -2887,6 +2902,7 @@ static const char * const flagname[] = {
> > >  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
> > >  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> > >  	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
> > > +	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
> > >  };
> > >  
> > >  static int memblock_debug_show(struct seq_file *m, void *private)
> > > -- 
> > > 2.43.0
> > > 
> 
> -- 
> Sincerely yours,
> Mike.

