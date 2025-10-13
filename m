Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D603ECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 22:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB96B8E00B0; Mon, 13 Oct 2025 18:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E699F8E00A2; Mon, 13 Oct 2025 18:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D587C8E00B0; Mon, 13 Oct 2025 18:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C14998E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:25:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72A545A0AB
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:25:28 +0000 (UTC)
X-FDA: 83994523536.03.E85EA66
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8E058120005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:25:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v00Fjc84;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760394326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwYZKlSFt2TFGtm4ACaHZ9tJu+i/5nUbp4Hg7BFfIes=;
	b=jPaCOp9RAyPOm/ZT3dEyPBEY0EfzaeA6ID97dU242L0MuQFnJ3bPeoGGixHfxIpP4YtOLP
	6Fm5gR58oIDQr3huceXZtpCerOrh29XI/yyugp29+4OHGZvcjJqVrn7bhBuwWPa7U4JxcZ
	aI171kqFaul5Z30pTssTL1swy2sukoY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760394326; a=rsa-sha256;
	cv=none;
	b=CsIWZYMvzeZqIYN8fcqQDZYUB4eRmL5oItWTJFMDxI9Q2D4MTK9c7noqeTpj0iACQq7ac9
	VQt+GiZ2zvduN+banIWztBkQhEHrz/NmneARgGd6xKPMxWvWcJznH6o1rUwrlWTLU2Pnz4
	3fvpXil1rih2NNEP95yRq1FoA7UoE0U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v00Fjc84;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 13 Oct 2025 15:25:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760394322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RwYZKlSFt2TFGtm4ACaHZ9tJu+i/5nUbp4Hg7BFfIes=;
	b=v00Fjc845Tfg/YtbSUJqnqhYCp/u8vSfS8Gy3jolcyVjPw4OT7EJXAuPp4uoVf8yEIHJCw
	/AlKO4S4ddhigi8M5LktsJpBcZ0Tae50MwChbNJsshp2ZlM97DLNe8bn4hLAr/k7uI+R61
	yOkKcTX+Jx3XmMbtBG3X9TWd9ZCPqAY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>, 
	Network Development <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Willem de Bruijn <willemb@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Yunsheng Lin <linyunsheng@huawei.com>, 
	Huacai Zhou <zhouhuacai@oppo.com>, Harry Yoo <harry.yoo@oracle.com>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <5ytqerlevrsaldgww6jhiqljim35bxruicrq7hj5rumt3lywto@3ejpuuar45hx>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <dhmafwxu2jj4lu6acoqdhqh46k33sbsj5jvepcfzly4c7dn2t7@ln5dgubll4ac>
 <CAADnVQKEhfFTSkn6f_PJr6xMcjB4d45E_+TsU6+945f2XD1SmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQKEhfFTSkn6f_PJr6xMcjB4d45E_+TsU6+945f2XD1SmA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: qaaz9cyo7qjraf69ekhpindte1fpppzm
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E058120005
X-HE-Tag: 1760394326-39602
X-HE-Meta: U2FsdGVkX19+5xL10ChV6pXwSeMPbuD4pR5E6fYx8XpHcbV9+0K/qFEHMYT50K0rFXCASAl03WKwe2P3phEaFqbDMbLxO92GtI9A2dJEotb4u0go0nWmlA0BlmfeUjrqdVB0QFRIqGIGiB804+/bp+gs/EY6DrpsBUezPZsuEo/incN2ZgTWHKF2VCQTV8sVEI8LqaanbIcivVcqHq/hVNxbj6s1CqbsyP0KVWeGSJfsnh6Xk+mG7X5lhTVZ5Cur9STCjYzlR2kJPJ6pMfGgbzUGxKyxYMF3bs/yVUKXEoUe+s4/+l1HgtJmc9TW8MzUyQlA7lE85IClaKUZkU/jrnEqcm2kKWHDCchi1I2IWnHa1wtmTQVJrfPQknwenJAOhrHCRxKESaxtP2IxjoF8M/oJ3IovXCzsA6FhgEpO187ot6hQs4iXYBFmI6CmBcMRwYkO1ZBq13GXd/EtVUlTBi7bX6VSUnOG6lhxSbaqGDhT83OLPqxpwUJdvE2J6C/A4UcnNTUpPPxALkqQOWR1woNMfN62pZDgTqvLs4CnQXFVpxK+KSmJqiwdSYfmnI7jSLlD0YklFOaWFH+A1Vv6P1R483Voh2jz7d03eNoKEDAfLEXwkNj1ExMI6gP08s+xNPTVZk8+Pr+kcGO7EgN9EglOoSxk3cDFOdKyp88Xe/UiX+qUi1WzjzmdI+Hpd7/uDTt9LQQQFpEID8SGMezVcnXXpBmyhPkTDKIztKbB/JTSxItIZ9uhqIq8s0s96BKmYObPqJI/VKfTKQ9kHjounmyvYHlNM+/PPxHPyt+q+teOJpIIleE7qkBJZMHNzxlIVXzaHh3cj1Dce57J0S96u/F+u/hxTNat8ajzZ16oCipdAOqlGXgsTP2okyxLk/I1I/p4wFLGUa4YR2djfVyML/k7KwxyITcvvO7yPasJSepba6j60Hk8Qc66vZiVVMN/tj6NM5AHFQi2vlxDfas
 wC8Hl4x7
 JL5X8WC3Xu2nPBDm+Eha/YMOpu48WKqW529+VeQcTNiJbOXLxGS0x4wSJJWYEgck0n8+70YI3MAwdg1uEUIW9z2hRRd9DqUTPEYX2VlP4fjLxtHPU90Lgtmn7I/r5JTXMnPhwNJqD0BlGkgv+fcPzoMAPOQ6o/LHCWt+nbxYO3e+M0NTmQ8VGlrhzjEuTuGaO9cK0Jc18qjZs/TEiq6WlTrTQzId9HDMaL7VHF4X6Q655hL90/pwu8bw1Sh0S6O44wkod9CGCKS1Fi92j7D/Xcd4r5QkXFT0Nzq3jGABVJsqX5gw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 02:53:17PM -0700, Alexei Starovoitov wrote:
> On Mon, Oct 13, 2025 at 2:35 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Oct 13, 2025 at 08:30:13PM +0200, Vlastimil Babka wrote:
[...]
> > >
> > > I'm a bit worried about proliferating "~__GFP_RECLAIM" allocations now that
> > > we introduced alloc_pages_nolock() and kmalloc_nolock() where it's
> > > interpreted as "cannot spin" - see gfpflags_allow_spinning(). Currently it's
> > > fine for the page allocator itself where we have a different entry point
> > > that uses ALLOC_TRYLOCK, but it can affect nested allocations of all kinds
> > > of debugging and accounting metadata (page_owner, memcg, alloc tags for slab
> > > objects etc). kmalloc_nolock() relies on gfpflags_allow_spinning() fully
> > >
> > > I wonder if we should either:
> > >
> > > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > > determine it precisely.
> > >
> > > 2) keep __GFP_KSWAPD_RECLAIM for allocations that remove it for purposes of
> > > not being disturbing (like proposed here), but that can in fact allow
> > > spinning. Instead, decide to not wake up kswapd by those when other
> > > information indicates it's an opportunistic allocation
> > > (~__GFP_DIRECT_RECLAIM, _GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC,
> > > order > 0...)
> > >
> > > 3) something better?
> > >
> >
> > For the !allow_spin allocations, I think we should just add a new __GFP
> > flag instead of adding more complexity to other allocators which may or
> > may not want kswapd wakeup for many different reasons.
> 
> That's what I proposed long ago, but was convinced that the new flag
> adds more complexity. 

Oh somehow I thought we took that route because we are low on available
bits.

> Looks like we walked this road far enough and
> the new flag will actually make things simpler.
> Back then I proposed __GFP_TRYLOCK which is not a good name.
> How about __GFP_NOLOCK ? or __GFP_NOSPIN ?

Let's go with __GFP_NOLOCK as we already have nolock variants of the
allocation APIs. 

