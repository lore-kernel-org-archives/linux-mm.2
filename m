Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA60FCC074
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9401C6B0089; Fri,  6 Mar 2026 15:22:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ED166B008A; Fri,  6 Mar 2026 15:22:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8EF6B008C; Fri,  6 Mar 2026 15:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BAB26B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:22:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEC2D140469
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:22:10 +0000 (UTC)
X-FDA: 84516760020.18.503AB93
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1545C180007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:22:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Z ph/wY/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nmepC9T4;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7EtY5Lz6n2cvujZXVeWfFZYsYZf69ABvyin+RZQ0Q8=;
	b=FPwj95OKTuSXyCTRRVpIwYc14aqu8o7kABRyWT+3T1ip2cAfyF0PvG2HOYvqLqsqPgdeYI
	6hDbbNZhbd5pjX+mjn9mnT9ucQg/3pQo0KNmmX1qe+h/+JEt93RwM4MOX+GsX22ihL6d4d
	BZ9goH3i8UGqIrKmw6Kz6KC6HNF8OFU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828529; a=rsa-sha256;
	cv=none;
	b=HoZDKWV+IsJPErgMld3u3gtn7lPPzNzzRrodZ9Zi6MeJXdIhmv6eCHQ6wb2eUDppiWzg2W
	R5wDBiiF5nTxLKUMYcoHXTU9K9pNpA0/W4MSU8F9h7iQ9Rg/uTtJdJ8mUWlfU2zKzIvofm
	vvVLjR52TdIPFVo60x7e5zbWnT/hMXk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Z ph/wY/";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nmepC9T4;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 8C59EEC0647;
	Fri,  6 Mar 2026 15:22:08 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 06 Mar 2026 15:22:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1772828528; x=
	1772914928; bh=j7EtY5Lz6n2cvujZXVeWfFZYsYZf69ABvyin+RZQ0Q8=; b=Z
	ph/wY/IEol1x6H1EYgH2MfUvAJKVETBUvihjPzrfUUItMoike+nJP6Gjj79USsjY
	G7Nb/VnJRaIVJHiErMWaFPvnSnAzieGuMrr4Xnz3ZZpQ642Bx1b2hy+sm935SU8l
	VM6PDuujyIYot89qIOxlT9vWV1an7kyJ5pVkXC2NpB/4YCkHPohTo2hSpWp8AFVy
	X2mn8H5+v/gJAxDiZhwtyGikHJFETr+Mb5yhirLfjRHL66s97sPBQpd4+IVOkXXG
	pPNqFWlRGl9q6WOEL/QZcx9ApmNR8nfcS4FhHGY/BKyXf7A04U9tdXKZ6LYP5rNC
	rzLmgPXSaJXSzyZW9OKvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1772828528; x=1772914928; bh=j7EtY5Lz6n2cvujZXVeWfFZYsYZf69ABvyi
	n+RZQ0Q8=; b=nmepC9T4PQNYNzYu49wyYt1WVTI6wLnAja7EtozQ1LHUkeid0cB
	2tgb+inndnKSBw7vz93cQMoPjEGlNTnTiNRxSuHZZ+7ZndbVs+YHgRcnbCjigZWO
	YxN4QH6EoFFLBd0ggivx8jJIiHEsWJqUjZJ1lbLN/XZOQVVSvyJpx/X4dz5OzHLH
	U+KW+6e8MUiKe5z/Ty8dTkldeyiG8oNSArU77r/ShgQowhaDK69PtVHPGzFtMzKG
	yWj5iZJ9Y2qYgkRp3kYmFYHK4ovy40DBM2xhe4cWy4MfBAV0mqZ7MqJcZbTv/o2Q
	0+KDCQ7MqzusyTVEdvs26iSIodocTIatMvg==
X-ME-Sender: <xms:cDeraSZhD4Xwlu_I3Z1J0RQ-KeKpb8zuPO7xZo1L_rEqZboM-ub6pg>
    <xme:cDeraT6_Ytt1kLE2krgGHFNRiFMM7_Ds8f9pzCsR40TH74pUjKA8w_TY37oxXOlgQ
    XmZUt_1vtl4kHc5lyyZETXxJ4CsAjKUpnvkthOwtS4WF3Caq_Gt3leY>
X-ME-Received: <xmr:cDeraTw9AagwnLWuCdOrY2z87huJaKQOxy0Ug5U30NEWbZfagYez9IRwpocZIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjedtvdegucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepfeetheejudeujeeikeetudelvdevkeefuddtkedvtdehtdetieeu
    ieetjeeugedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrrhhgvghssegtlhhouhgufh
    hlrghrvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
    pdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprh
    gtphhtthhopeifihhllhhirghmrdhkuhgthhgrrhhskhhisehorhgrtghlvgdrtghomhdp
    rhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epkhgvrhhnvghlqdhtvggrmhestghlohhuughflhgrrhgvrdgtohhm
X-ME-Proxy: <xmx:cDeraUpGQfIldLXk9682Y-7o3-0avsfdCeLPvweJ2txluqIzbPmTUQ>
    <xmx:cDeraV2nKJNfik5xLjmnu0juch-DbW-UEyJXOagtDunSKkpj9faPIw>
    <xmx:cDeradBOoVoIFMshR7OdjXpiRWvJYKzWnpnM2z4-cJfet_aYtTyPXQ>
    <xmx:cDeraWN06mmr6a1wz-k43bwLuWXGhsRw5XMFtXdUKow1R8ga8zLvPA>
    <xmx:cDeraZFrnNViXYE_CX8se2lR_I46rCB7Os4DqptuezI4km-YkMR99bzp>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 6 Mar 2026 15:22:06 -0500 (EST)
Date: Fri, 6 Mar 2026 20:21:59 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Chris Arges <carges@cloudflare.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	william.kucharski@oracle.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC 1/1] mm/filemap: handle large folio split race in
 page cache lookups
Message-ID: <aas3E9P0BP03O8ma@thinkstation>
References: <20260305183438.1062312-1-carges@cloudflare.com>
 <20260305183438.1062312-2-carges@cloudflare.com>
 <aanYdvdJVG6f5WL2@casper.infradead.org>
 <aarVMrFptdXhHsX1@thinkstation>
 <aasAo8qRCV9XSuax@casper.infradead.org>
 <aas06mfCrJuzZd0-@20HS2G4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aas06mfCrJuzZd0-@20HS2G4>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1545C180007
X-Stat-Signature: n1bk6kc4irzqm9nq8q38tx6gdh4uh9pc
X-HE-Tag: 1772828528-64893
X-HE-Meta: U2FsdGVkX199G4RQi/ht466U/jnhoH+0iX17uiXaWMDTdDaDE8jtoL+k8GA4bB8OgSPwinh8liGwQ/xv3GJ9ku7fIa7cNfrU0mG91EOzpvCKYjZwoDMOWinY7b2IvefQIB7aSiKeeCvy3hxmXD1SBqUYnYiHo4oxPF0bpMwRBd62uwSGXKvW7+tfq98ukxUoyGMHohjllLPwdbce+zU3WECkIbq+bWl7sXbu2sNVwiOjlnJi2DAGo701ZmCj2g1Pq4EPvmgr2l1IDJ4wHW0NLpuihkALepccSUxz8HTfX4SyxNyu1fXGeQ3SAcg5l+R/lqvsmwVYTqOZEXwSpeP5e95zzqMmFBoC44H21PPf/yuR7jAS+LMnzkRcJvSeEv+RLXtb1DRTGscqmM1kPg0M94cKW+IQ97GroPCPyLJRAj+t0O0KH9LnlyCcgxNMWVW4CPqFuQCBBRAoE4gbS9FiKZWZiQpWLJGFkce9UVNM/83CULjtl3f/+mMeG5pgX2N+HWJkqaYYMNogPaR8olx1NnisAemgWqg8gWkEpsGTGmy/+0i4xmfW045WDXELk6ASSTTNf24PS1hUG89LMWM3rMKOR2wDQ6Bp0M5+rzgysEUDRG1If3WRh1/F8b8Nx8SYqc8NNjYOlnL8p1ajMfZNdnSfTu3q+dNK50s2X4HoJUDhF+vJOxy0CK0AZpcA8a7wRgYX6FXNYDO1lZYFutx/xKU47EdahQ33eK6lkxAsxwPhSlfKQ1FKhnf42m7xlEmICgdVKFHhNImGE8bFpMpu0Eu4teOb4ChJWP7Vc5uYom4zkFIijZoT2NbPacUdKKOff4/fTM1URSh/ZkYMbyn1rbHD749O2dSiSlg0qrcFnqI5ydbFzZoVfk+1D2LUDROVaJ7jIaflZwIRNGi7d1BY8/BAHPnbxmDtdmiVcIKtZSTYu8tgQkz2bS5Eelku55CLmukWcl6FqZyP8sUF8uY
 OytejyVH
 4G7f5bjlWFJ9HUoUNs/dffO1eabyor30ixmSkTvmXuLmGXMb7Vk1CIrbzOn6eZZraUz+dMXnZWHaZpcUuJ53o4h2m+tLZCH1keudA2MDMbqJ4o4swxHauIvS2GiW5pxnHwJiFWnx9DcoqyAqrjdT20ie8rqafOg8jTibQ4TMVNazepaNooFDcHe8Jr1ofJqxYBTuBAyG5rYh1B319YKY/eiQ25h5l6PEib5LaljA4J28fpkRr5e3Qb5SPtj4EkM9JLijA05gpQsU0//1Wy7POl60gLKbN83mjS6LXasQ8uefYpGJmh4JZSLKVTXOy0rzXlgAlHHXgRw288QlGiKBsqi1ff2Ru7ZVg515i7TG3VKY8NDRdqgQyfs9revseaH6u7YzjBaKSmuyFESqXDcOh3P16LidDQD9nxDBqpueP0N9qSmYrvnxWxV5PeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:11:22PM -0600, Chris Arges wrote:
> On 2026-03-06 16:28:19, Matthew Wilcox wrote:
> > On Fri, Mar 06, 2026 at 02:13:26PM +0000, Kiryl Shutsemau wrote:
> > > On Thu, Mar 05, 2026 at 07:24:38PM +0000, Matthew Wilcox wrote:
> > > > folio_split() needs to be sure that it's the only one holding a reference
> > > > to the folio.  To that end, it calculates the expected refcount of the
> > > > folio, and freezes it (sets the refcount to 0 if the refcount is the
> > > > expected value).  Once filemap_get_entry() has incremented the refcount,
> > > > freezing will fail.
> > > > 
> > > > But of course, we can race.  filemap_get_entry() can load a folio first,
> > > > the entire folio_split can happen, then it calls folio_try_get() and
> > > > succeeds, but it no longer covers the index we were looking for.  That's
> > > > what the xas_reload() is trying to prevent -- if the index is for a
> > > > folio which has changed, then the xas_reload() should come back with a
> > > > different folio and we goto repeat.
> > > > 
> > > > So how did we get through this with a reference to the wrong folio?
> > > 
> > > What would xas_reload() return if we raced with split and index pointed
> > > to a tail page before the split?
> > > 
> > > Wouldn't it return the folio that was a head and check will pass?
> > 
> > It's not supposed to return the head in this case.  But, check the code:
> > 
> >         if (!node)
> >                 return xa_head(xas->xa);
> >         if (IS_ENABLED(CONFIG_XARRAY_MULTI)) {
> >                 offset = (xas->xa_index >> node->shift) & XA_CHUNK_MASK;
> >                 entry = xa_entry(xas->xa, node, offset);
> >                 if (!xa_is_sibling(entry))
> >                         return entry;
> >                 offset = xa_to_sibling(entry);
> >         }
> >         return xa_entry(xas->xa, node, offset);
> > 
> > (obviously CONFIG_XARRAY_MULTI is enabled)
> >
> Yes we have this CONFIG enabled.
> 
> Also FWIW, happy to run some additional experiments or more debugging. We _can_
> reproduce this, as a machine hits this about every day on a sample of ~128
> machines. We also do get crashdumps so we can poke around there as needed.
> 
> I was going to deploy this patch onto a subset of machines, but reading through
> this thread I'm a bit concerned if a retry doesn't actually fix the problem,
> then we will just loop on this condition and hang.

I would be useful to know if the condition is persistent or if retry
"fixes" the problem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

