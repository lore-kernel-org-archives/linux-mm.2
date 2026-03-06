Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F62FCC05A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 259A96B0093; Fri,  6 Mar 2026 13:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 203CD6B0096; Fri,  6 Mar 2026 13:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC746B0098; Fri,  6 Mar 2026 13:36:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF10A6B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:36:35 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98D4F1A064A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:36:35 +0000 (UTC)
X-FDA: 84516493950.02.04DAC5A
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf25.hostedemail.com (Postfix) with ESMTP id 65B70A000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:36:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="r V4gAnP";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BQ1vmXmm;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772822193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pTPaXqxgwHDvp03QfXEc5xrZACRdvuBS2Z+HP6tANU=;
	b=EscObvn5osu3GNpaC1YKyMPJewGN2t7dkQMpHj7vJHFHJd95BGEBylrJEWeR4pWVyy4HK5
	5zRIg/sfeoh1liY+XYj+c/Bg7JDtBDSyKcKjXayO+wpbLkB8fTV98QEfHHsmdlJQNtRPUW
	GqTLupiEe/XkipPo/m7pO8SLhh44sfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772822193; a=rsa-sha256;
	cv=none;
	b=Peyk6qUTK5782sNGQWW5StcrG3SqgRwOeuP7g6qRgX5efIoqIet1UE1bWep8qcViZxrteW
	EOVcROqSsrYNWOI2Kjl1ZleLUmCf87p/lGZzDwqAOQErZ8y+AgvDgJC1VK0ytyJ8/go/u+
	Al6ORKm6531i9k6W6Eupax9V/ZzdSBM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="r V4gAnP";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BQ1vmXmm;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CD82C140019B;
	Fri,  6 Mar 2026 13:36:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 06 Mar 2026 13:36:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1772822192; x=
	1772908592; bh=2pTPaXqxgwHDvp03QfXEc5xrZACRdvuBS2Z+HP6tANU=; b=r
	V4gAnPixTzzEHTLVdQZycCQsUOByNvAmzU6psupSOmpbmUytB2Ff0c0F/TAcL8zm
	cu4iY4oj97Wm6bkUTwl/Uuir1IvGN8gkAtZ0kfcRluPH0licc2TR8e9gl+yLHxZl
	TfTAFi9rZBrh+hrsouXa8eRYansgqXZGIFTco9EMbyru37lJSy64lCu+QADVkcBG
	7Bj5C7ehlEN5NVm/HFvKKX4lqw25HQi5dFkqTHeq8TE32cuAWlsNZkyj2jUhcR/5
	C2zadpiNoybGIt6RHcuxRxcd1u5YSFN6u0QlQYQh4zFq+i07bKKG5n7rlF6nxG1/
	/ehXNyYSgPMfHUPX/CeFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772822192; x=1772908592; bh=2pTPaXqxgwHDvp03QfXEc5xrZACRdvuBS2Z
	+HP6tANU=; b=BQ1vmXmm1dF3H/rZikqOPN1gW8jvAZDvJcwIYa/bDA2T62Mdykj
	bKmtnqpui/kigmmo88I8JaRjIriusRzvjl5IsnwjCOS3ia3oF7qc/36q23MlqUNc
	3JiP+3cxp8QkZ0pICc90w4syKpeoNRaYF4OYEHxowhjxaAtk3WK1LK+Sd2WY+XT9
	wE0mRqPYA4nNOrbJEDWBTY3P0v52jUW9cUiaFCDUjxjch3i3L1MjBb33ryn4EZh8
	ViQpZE9fsvGTbYqtisDC/1QTfdSCMWvFY9s85Ay4Gg8GNJFfSiEz/h5/Cl6AaqEj
	LisM6lxbZKA9f4lNd6MnuaAgXN+ef/oIw4w==
X-ME-Sender: <xms:sB6raXkO3HTbsqAseTrmyo5vI8hcxLCNw9C6UtKDrTDJXIqxGwZW2A>
    <xme:sB6raZUdxZtG61tHXMYsZV5rh7Fg4NhUi-WxmC9urP9piYNXAagLXhetr2t6yV5AK
    6Wcxpn4yH72r4UvWVCI8IPYhuqdMc3jcDPmZPZrM-f_jxiMuekrZ1U>
X-ME-Received: <xmr:sB6raUeS2VzRQzWeX2q8zJ2zZlVXlYF0yS3tsTnmQ54_ZyEo5wLzpqxKirgt3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjedttdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvg
    grugdrohhrghdprhgtphhtthhopegtrghrghgvshestghlohhuughflhgrrhgvrdgtohhm
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopeifihhllhhirghmrdhkuhgthhgrrhhskhhisehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvrhhnvghlqdhtvggrmhestghlohhuughflhgrrhgvrdgtohhm
X-ME-Proxy: <xmx:sB6rafld6T4kTc__iWBEOr7MOlKfc6tHEzLApN0mdyuQRQ2qARUhnw>
    <xmx:sB6raeD2VdPTU7fcmOoxwmVKGukDPYvhJCG0kw6bGGKad3WgO-_uYg>
    <xmx:sB6raZfbH0ovGCEUbLQRm9DAASMbv8iLjd9J9UDYECKVnY1kRJWZCQ>
    <xmx:sB6raR4vu26qAHggOlP6YS4UmQZDnL13b8pTHmvtrSchkvtzCLC8ug>
    <xmx:sB6rabH-fUjQKSyMRWgPkp_pQq9ZWDK5ECaC7Fhe_Nqrz32AH81gQKBt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Mar 2026 13:36:31 -0500 (EST)
Date: Fri, 6 Mar 2026 18:36:30 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chris J Arges <carges@cloudflare.com>, akpm@linux-foundation.org, 
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aasddOvIfcMYp3sk@thinkstation>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aasAo8qRCV9XSuax@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65B70A000F
X-Stat-Signature: o14g666qe34oqk8oauofy1hyn54t16xt
X-HE-Tag: 1772822193-254314
X-HE-Meta: U2FsdGVkX19/bD6c5VMSS+O4tZrIv6J+PRHcRTDQuVk7f6ryuUHWT2CoaGXPCtghlHCdZCtFnDTqRGOrmQdSP88akIDh+IqkPVX1sBysWMpMGf6Re3K8vxtVXHO+4eajj+dCVNNiuvH8S+schtxOWBwjSspXfHCi/ideiAVCyuRaEPrOaeY9uZYA/1KKLqdPAdx0h7BXURsqdWZXWxv00QHAIcDsgXgEAz6U2+61tXPu4dgN9kR+/04yXmjEQFKC5ly/cvs+VK0IcZb3V0whxj1uXT5Qtv+GEgFCBBphWUZEumfnZ53Ofmjs6vgeffg8V2nX1guGTuNuK2+6R7FxTp4U9ZmX1K62LEiEyZYb0TtaIJMTeNUQTpyAGDPPZ2fB+34mjU63PK5P33q2Gw+09v6Wg0NL7yMW/YgOCTUQpP0FjWWlYna2iGcazUYpN9DsPkTqI7zY2ih1/pGgH4UpTGqLk0uwhVwxUxalpbjBrJJFA/YxRFQ0jhDAVZZxNNPyHsItjQnlmPz4D6GG1/wTmmZHGm/5lUnexNQjOzr+yXyzFFsMFSefKeETBLwqo2qI0dMQpXEUyreP8T6rzgLM1mTk7/jICFkIROT9Cvr1SoC2IsRIxxFUB0rSfobY7UJAXTlbyTWgSDOpkZhfCdNQ66cqQgpkEpYo3/T57w7dYk/6RYfT7K3kpuQN5Rc6dE2DiZWl2MtJk53OO8TNVc/1B2QBRaGPiMtKu+8ma0J1RV39dSM0FNH6E0Mqht+hSVPCqlzWxCdgPLG6RUc2PPEJUECq3ZOOi6UvEZmhFclS1Hs+b/nHgzRA0yO/MWVGv52lw0oXcK5gXSwUVZHPf8SszNaeUmsuojlfX5rHck/gwWeya683tpI9WpeapbsCm3F2lGMMlvLC9wOgIbmvLETDMEVfW4eDKylP6JMkqLbeMrEuhAm6j4qYsTKyYDqzBoE7wH1/bVJUuJtYdbm4AZs
 eW5gFlQX
 y49y4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 04:28:19PM +0000, Matthew Wilcox wrote:
> On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > folio_split() needs to be sure that it's the only one holding a reference
> > > to the folio.  To that end, it calculates the expected refcount of the
> > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > freezing will fail.
> > > 
> > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > the entire folio_split can happen, then it calls folio_try_get() and
> > > succeeds, but it no longer covers the index we were looking for.  That's
> > > what the xas_reload() is trying to prevent -- if the index is for a
> > > folio which has changed, then the xas_reload() should come back with a
> > > different folio and we goto repeat.
> > > 
> > > So how did we get through this with a reference to the wrong folio?
> > 
> > What would xas_reload() return if we raced with split and index pointed
> > to a tail page before the split?
> > 
> > Wouldn't it return the folio that was a head and check will pass?
> 
> It's not supposed to return the head in this case.  But, check the code:
> 
>         if (!node)
>                 return xa_head(xas->xa);
>         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
>                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
>                 entry = xa_entry(xas->xa, node, offset);
>                 if (!xa_is_sibling(entry))
>                         return entry;
>                 offset = xa_to_sibling(entry);
>         }
>         return xa_entry(xas->xa, node, offset);
> 
> (obviously CONFIG_XARRAY_MULTI is enabled)
> 
> !node is almost certainly not true -- that's only the case if there's a
> single entry at offset 0, and we're talking about a situation where we
> have a large folio.
> 
> I think we have two cases to consider; one where we've allocated a new
> node because we split an entry from order >=6 to order <6, and one where
> we just split an entry that stays at the same level in the tree.
> 
> So let's say we're looking up an entry at index 1499 and first we got
> a folio that is at index 1024 order 9.  So first, let's look at what
> happens if it's split into two order-8 folios.  We get a reference on the
> first one, then we calculate offset as ((1499 >> 6) & 63) which is 23.
> Unless folio splitting is buggy, the original folio is in slot 16 and
> has sibling entries in 17,18,19 and the new folio is in slot 20 and has
> sibling entries in 21,22,23.  So we should find a sibling entry in slot
> 23 that points to 20, then return the new folio in slot 20 which would
> mismatch the old folio that we got a refcount on.
> 
> Then let's consider what happens if we split the index at 1499 into an
> order-0 folio.  folio split allocated a new node and put it at offset 23
> (and populated the new node, but we don't need to be concerned with that
> here).  This time the lookup finds the new node and actually returns the
> node instead of a folio.  But that's OK, because we'ree just checking
> for pointer equality, and there's no way this node compares equal to
> any folio we found (not least because it has a low bit set to indicate
> this is a node and not a pointer).  So again the pointer equality check
> fails and we drop the speculative refcount we obtained and retry the loop.

Thanks for the analysis. It is very helpful. I don't understand xarray
internals.

> Have I missed something?  Maybe a memory ordering problem?

I also considered reclaim/refault scenario, but I don't see anything.

Maybe memory ordering. Who knows. I guess we need more breadcrumbs.

The proposed change doesn't fix anything, but hides the problem.
It would be better to downgrade the VM_BUG_ON_FOLIO() to a warning +
retry.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

