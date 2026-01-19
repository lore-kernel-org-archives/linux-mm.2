Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8DAFD29C2E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC906B026D; Mon, 19 Jan 2026 10:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18B3A6B026E; Mon, 19 Jan 2026 10:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062BD6B026F; Mon, 19 Jan 2026 10:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E6D076B026D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:26:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7EED51A019E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:26:47 +0000 (UTC)
X-FDA: 84349090854.19.33004D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 75FB8A0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:26:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG984jl6;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768836405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nexSjARorDxIQfx9gJ+BTBM2rgPoS6E8Ezj3gxT3RUI=;
	b=DdbOCC1yw92oFyNqdW9hTRLPt24o9tEkLa558v/ZFD3wl2P8H717IccbvsXFYJ+lLQx+Ha
	VjH2jeAly+WM3yonoq1/toiITdCc7U5V6wSx5mLz4VUbDB9g1Rxwv9ZqcLjOn5je0IGNDl
	P2pfb42DrPnwj/lWvP2HlTjZuYN6w3k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cG984jl6;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768836405; a=rsa-sha256;
	cv=none;
	b=OOR9mHY9ovtIivJdfw/8vOFWNG3YGSWJtiQYMY28Mkv/TnipuhlliDyRhbfUg+ZTnxZYFp
	1lFPJ0meHtlPdmGmVPkKw0Zrv599N74kWr/3shWW3zfhPVEzx0jVlAMzEfgS5lWzz36rZP
	k4kTc7uya58bNiJSlokPjTpQGurxZ8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6CAE60055
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9EEC4AF09;
	Mon, 19 Jan 2026 15:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768836404;
	bh=KIfEZnvVSwR/fdHFcIyoOb+BmBvRKs+lPm5Ma8PC1uA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cG984jl6D/GEEetT9pBTvZTdcko1whE9z3iBD/BY/wqNGpAgsobpXI485O16FsDAf
	 Hc+sYrgaOf6rNcK2r+1dwWNGhVeI8FNu/kvsF89sEUKwQNhX5rqxKPAX7QFVTNcOmg
	 0Y989hTcpSMd0k6zucQQSy7UN+LCRLIsbCPW9oCLl5BytedKZVuIoPvXyRV9Xiiv0T
	 5b89Vmj2kEbNgjcBIqNMtqsz2qKLyk4Yr1DhaOwulhw80s0P9mmcyrO8Avtxk5q56s
	 6oQV12fy3kxdg6zTbDRGHBBg+JcXa9RCYAtSubQuqQvk9FDt3WPu3jgDn7pBKTc+fj
	 HQfud4hALedwQ==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6C75AF4006A;
	Mon, 19 Jan 2026 10:26:43 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 19 Jan 2026 10:26:43 -0500
X-ME-Sender: <xms:M01uaV8h5uYjMC3XhEQZoZQECbu4ekHgrt-xVwg39BT5oYT5SVNrKA>
    <xme:M01uaVGuylXEbUCNt0zochxUJ0xuojGjv33haUaJhjDjPkbeHyhjA2BqdoXX_gMO8
    HbrQRIHFT7u7YXNO-013mdtZ27Nexvwl7t2f-Hjv8rRi7v8SohzgOM>
X-ME-Received: <xmr:M01uacYERr1mWJ1MDmdYx4mDgbbeDi5s7mjE-syCDNl7k_EPdzjzJK6D4NNxiw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufeejledvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopehosh
    grlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehloh
    hrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihih
    sehnvhhiughirgdrtghomhdprhgtphhtthhopegshhgvsehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtohephhgrnhhnvghs
    segtmhhpgigthhhgrdhorhhg
X-ME-Proxy: <xmx:M01uaRM0DQ2aJPP_GLYEZ8HJ0-d2wLosW4i98UrNgylbn5um2dF9Uw>
    <xmx:M01uaVwplewMWQ15ovxywgMf0zYWAv3McDkYhcESkmXxqLw228lDIw>
    <xmx:M01uaSBu4EUXzX-xiPFUbV_wwP2eqtLHFZds_EfIg6mJEWUJ7o3OSA>
    <xmx:M01uae5tIXEVxqD-1KZJAD_WlmLrP7gp93mERNpmTaJiTyOrSX-ASA>
    <xmx:M01uaQL9y8L0-fzdTOAhdcY8dB9mniwUEt5cfefhgTig97fm5fzZBULx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jan 2026 10:26:41 -0500 (EST)
Date: Mon, 19 Jan 2026 15:26:37 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv3 09/15] mm/hugetlb: Refactor code around vmemmap_walk
Message-ID: <aW5NDEuP_pRLsq9d@thinkstation>
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-10-kas@kernel.org>
 <72e04317-913e-4db1-89ed-61727bbdd01e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72e04317-913e-4db1-89ed-61727bbdd01e@linux.dev>
X-Rspamd-Queue-Id: 75FB8A0005
X-Stat-Signature: xgzh1uzkmpqikatbgskrkyt67gut8j95
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768836405-606514
X-HE-Meta: U2FsdGVkX19vFEUNVy73OJqV9JABbPcCC7dqptTQaMpImU3GI044PSH8vNSqoc1Euk6AQGeA8WZ7F756muVL1Nq++Kp4kyAbUFW+3L29W/e+8936BZCnFvn+8SnsHvJsZo5FAfSwhsn0KGeuEvGXyVTeM+FbOmCEz1f572Ng2RR52sPpqXvDIfPzK59T0tHzpcVVWU3PjOsfJSwF4rqKLGjJnpZzjsWeBxKm5rQ6GGVvoGVm3Op5WiA2fKC+I9CouLukP33tguS703e9EvadOlIzbosKFyqt+urVKsV/Y1nOzwcAXeCvrAEBzBgWYyJvzAh+BKA4fUpAcsE6QdhWJoj0/+5kdOxJjstvkx5gXDWoT94OPLBScU6MqPf0x30msbN2tXmEnSWjUTiEUPYrH6gVIr/Jml3casU9j7kfegIEl5L/WcUXtx1ej2Kk5HPHCjZg+r7S6cb4/p7qfaG2k5spwy/yykPH6xTgSIZI7P7wTKbazmAJXhZ7MV2w+truEqxE+kKalaMl2A6l+RrtHx2CEzQRWtM1h1q9CF/DpAKmYmJ/Qr3npNMzw60y5C8Z1HWGoGWOh5UbzrQDJg64UOqEKDPMOATFSBJgRz+106YR/jbcOfsHyCyh5rLBussPqR19W2k071eKjMZ+vyKkLOISiD4IFEu9wPDl5KY40lEtMb06zFJ+l23wd45qpm0+214JOiJYjGv3aOo0+fgf6WrOxeA1KSLl1ZOFmZu+G3oRH1ao+yFx0bcAVUGkWBAIA+v0XKr/XsynLK9TJL1ai5xrEkf42gTlyvlZkk2n3uLM45KohTKEFrwIKZdaORtXtqEqINOXeK1weEPAqCEPiVEidu+vd1mR4JNfuqpGSEyGnZvIPeFjxA5M7DpgFBQoVyt5t8qluV1LzFJHPrte+K3JdBdzppgYk9ukkveYqO0Ztwa4fXhHva+hWJrsb9c1zexJ870Fmyz9VPl0q9G
 V2ppjoCq
 SC2Vb3GBB2rQbtJ9ZSNkG3EefLiaSVcoROLYj9+ilzxZRaCwJARPJ3vJNKFgPAcrv6ZhYt/U6hvxdvS+/wOzQiPH3r1pCPw3S5WPjuRHIrplNP5mTj/MPeo5sSfO4A3OngsD6x2kW9eEFBsa7NKavqrClIcCUf+keSN2s44QIWRYA/s2OQYZ025BRvhK4ie9MKJE74K+aFwqobXE9SJugQthYn6c1URIrFz2K4yOAUCxzUirGcPthPfXEwk8sX5iT/Ah4nXdZpOQuLFjyw0YJyexRUqhCtMQfN+5RqdRrxfjHp2tuG5sdTG3lT7cceRGzls51zqgY6mM6dW00aDjuP94uGAPZg+mmYCzj3Kf/NSqC2mq/YJV+foguIZQAoHTCeDF7uvCMsBcIlKxLQO4LHUgN97Pyyy9truv1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 06:04:32PM +0800, Muchun Song wrote:
> > @@ -415,29 +377,27 @@ static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
> >    *		to remap.
> >    * @end:	end address of the vmemmap virtual address range that we want to
> >    *		remap.
> > - * @reuse:	reuse address.
> >    * @flags:	modifications to vmemmap_remap_walk flags
> >    *
> >    * Return: %0 on success, negative error code otherwise.
> >    */
> >   static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
> > -			       unsigned long reuse, unsigned long flags)
> > +			       unsigned long flags)
> >   {
> >   	LIST_HEAD(vmemmap_pages);
> >   	struct vmemmap_remap_walk walk = {
> >   		.remap_pte	= vmemmap_restore_pte,
> > -		.reuse_addr	= reuse,
> > +		.vmemmap_start	= start,
> >   		.vmemmap_pages	= &vmemmap_pages,
> >   		.flags		= flags,
> >   	};
> > -	/* See the comment in the vmemmap_remap_free(). */
> > -	BUG_ON(start - reuse != PAGE_SIZE);
> > +	start += HUGETLB_VMEMMAP_RESERVE_SIZE;
> 
> From the @start comment above this function, we can see that the @start
> address is the starting address for the remap operation we want to perform.
> However, the modification here does not conform to the semantics here.
> Therefore, I suggest letting the caller __hugetlb_vmemmap_restore_folio()
> pass the correct parameters itself.
> 
> The reason we previously used the reuse address here is that the
> initialization of ->reuse_page was inside vmemmap_pte_entry. Now,
> ->reuse_page has been removed in your patch.

Fair enough.

> > @@ -466,18 +425,16 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
> >   	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
> >   		synchronize_rcu();
> > +	vmemmap_start	= (unsigned long)folio;
> 
> (unsigned long)&folio->page？The folio is the metadata for contiguous pages,
> while the page is our optimization target. Although their values are the
> same now, their semantics are different.

Okay.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

