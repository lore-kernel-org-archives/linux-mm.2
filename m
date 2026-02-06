Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A162EE208C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 11:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48676B0089; Fri,  6 Feb 2026 06:35:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF62C6B0092; Fri,  6 Feb 2026 06:35:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02426B0093; Fri,  6 Feb 2026 06:35:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D2C76B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 06:35:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46924B3D3C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:35:18 +0000 (UTC)
X-FDA: 84413825916.29.8EE1CC4
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7A3D2180008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 11:35:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PvrvO4Tl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770377716; a=rsa-sha256;
	cv=none;
	b=57u+xRed7YdxxLaNiaNwbprcIZWxUiMrWyV/BEPh2NL2mKIck59aNnUkX/J58DOdD7JEvT
	bwt4w4X8fYXubvBffE/QMTL2zfi+K/ypyA4ic4p/acrE1aFTUZo04KlqE7plXOcp1OnO0Z
	aa4fR4m23XddeUP6D1JB1HhrCh9y3Qk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PvrvO4Tl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770377716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyNHzyO8yNbJalRk1JwWUSdFphKI36stzx00uDbxggc=;
	b=FsIS0/hTDjXxnrfmsShSAjrFapSTNSBgGNLrwXYAZBZA34/xSpSLIHija/joNMwx61N57p
	7ApcboWC604xM5zAXvJooTqgSMSxhBtf/I7CDEVsoXtYwVvULHKHiwTIcKCvj23ITeS7bY
	LAjn94Vw204OgZj64zbcVIUPOrlbiYk=
Date: Fri, 6 Feb 2026 19:35:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770377714;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fyNHzyO8yNbJalRk1JwWUSdFphKI36stzx00uDbxggc=;
	b=PvrvO4TlSq5kSmx6TeVpwJ30Ld0Wga6wWmLevrybCJJvVG1oYyRICSSJKkp8g/3226N6zG
	ai9NzwpDIO/QpoCqbj2iGynly9F1IVfvK75h3Xhz3RzapcKFVqj3j4ISB+8w6nLbbNogsS
	2a0ucmdBZz7yw6Ch8fx9UgiQxl4CjjI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: let need_slab_obj_exts() return false if
 SLAB_NO_OBJ_EXT is set
Message-ID: <koypivw3zonvakx3k2ji5ti4oy5yv6t2yaretkbh6dd2f5h5uh@gjbuxu7ryph4>
References: <20260205120709.425719-1-hao.li@linux.dev>
 <aYU7l6P2ikKvnrWT@hyeyoo>
 <67ebb9f2-b383-4b68-949e-239d8c7b18f0@suse.cz>
 <aYW732VZACRIzr-r@hyeyoo>
 <e924ce7e-29c8-4853-b1c2-3495b8cf8427@suse.cz>
 <aYXAqQFGfru8aC6M@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYXAqQFGfru8aC6M@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A3D2180008
X-Stat-Signature: qczy6pxdp747pymh6f8optk75fh6bzeq
X-HE-Tag: 1770377716-159798
X-HE-Meta: U2FsdGVkX1/pycm7sVC/T2fFUF5AHvE3Ijol1bnWMw+ckSIhM6M5h+jpYVU9dTY1KF471Y0iaUcIs/epyvsyFRTBncm9tM8e4wVHzBdukCRWbdTnJsdqXLb1ZN81E65nGDqmNFldmcAcdJ4qVS5WmAFbws758yCPTPooKqGZLYG0JVERligFgJgl8KpCIWDqzbfWbMPMGOZSXcwZ1BuFOyWC81kIljV6QOGz4nA1LYVHLWhy14tckKYA98/LVCE/gpLQzoWr6+lJA6VXsaDlHKc64qHM21qktt/ciB2DPgyux7bnzv3KQSUYc71AzGVGGWuNfqbhyQx06lz18jwLjB1bDe82FM1pSA5h+IV69Zg3FHJK/kUF8sLvkBUqpf7kNOumaJxLAK1HvZljmU1Z4Erqgh+mP5gsV0yEStX+VQJwZjwbooPHjKLIFLGycWfdIeJZbrXqBszhr5VGDlzGuEH1MWha+1Ekf4Fakh3M/MyHFVH8zaFoph8bnbQ7KLrkAKV3N4OFPSVJH/cnuZehHTHZAixfUyXrMQ6mApv2HcU/mo4+FFEPhPHIJg/OOYzyLJcbNyCGm46G6k1YFeOx3ysdEeXXQ+NGhSiinWxReY3dUjikySDmw53hJWta8bZWl31p596l5abUzkfTGv5O7Vn6zyHghYF9k7cJC72Tf64s6zt3kIIDRvNn805gwSxM0C1gseDWEiOQfDXd7vUBMkUI6RWgkfR8i1Ts0aUHWnZ9botoLTYnB/KJin6m3zXJ8vFEM2bWwYbuxuy1iHeHfcSJ3nrSiBq6YM5+dWEpE+x/0/k/wnwQGH4XIriExD7zwynRzitFilMKQXA98IzPBc3H9Vrm8wL1yBs+Bgs2L04Sg8AG3GaHIJ++tIJ844eGX1gW7AtIp09agocaIz9nPfMylUMWoLcx4UxuKOGK9Jn/moAHdEFF7hIVPv5eEQRstLqzlKzhgmZ9UU236Zf
 g9yc7/8L
 bQCeAmxvTSlT+ic/bPKOxsQCPmmN24A3G9/fNF4BvTBwuSca6e++wcVT380F6V4wfvwjib4u9zaTC7qzrsiFo2ul5TeFsOFs595rKldI+Pmvl3lhU/4HL33Sd56bYbnMM5dZShDv0C8ZJZ6ZWm9BCpzc+tSgxELNreu1GdUX/a3HMjx/Ugb/dVjXAUVBHAQaa6Q5lRnMJvMnT44P/Aqmx8rWPAQ5rGoWg0vXCwrVolb3PRF/z7J9/tGcnWxqiiJzy+dhonZhpN9Uz2DzX3WH2UMKrlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 07:21:29PM +0900, Harry Yoo wrote:
> On Fri, Feb 06, 2026 at 11:03:08AM +0100, Vlastimil Babka wrote:
> > On 2/6/26 11:01, Harry Yoo wrote:
> > > On Fri, Feb 06, 2026 at 10:40:54AM +0100, Vlastimil Babka wrote:
> > >> On 2/6/26 01:53, Harry Yoo wrote:
> > >> > On Thu, Feb 05, 2026 at 08:07:23PM +0800, Hao Li wrote:
> > >> >> SLAB_NO_OBJ_EXT is set for boot caches, but need_slab_obj_exts() doesn't
> > >> >> check this flag. We should return false unconditionally when
> > >> >> SLAB_NO_OBJ_EXT is set.
> > >> >> 
> > >> >> Signed-off-by: Hao Li <hao.li@linux.dev>
> > >> >> ---
> > >> > 
> > >> > Looks reasonable to me,
> > >> > Acked-by: Harry Yoo <harry.yoo@oracle.com>
> > >> 
> > >> Thanks, added to slab/for-7.0/obj_metadata
> > >> I think it doesn't change anything at the moment?
> > > 
> > > ...unless you enable memory allocation profiling :)
> > 
> > If I do, would kmem_cache or kmem_cache_node caches gotten obj_exts in
> > leftover space?
> 
> /me builds and tests a new kernel with mem profiling always enabled...
> 
> Yes, but only if merging is disabled.
> 
> If you disable slab merging with `slab_nomerge`, kmem_cache gets
> obj_exts from SLAB_OBJ_EXTS_IN_OBJ.
> 
> When I enable debug feature slab_debug=P (and thus change s->size),
> kmem_cache_node gets obj_exts from SLAB_OBJ_EXTS_IN_OBJ.

Thanks for testing, this matches what I've seen too.

Besides, even if the two boot caches, kmem_cache and kmem_cache_node, go through
the SLAB_OBJ_EXT_IN_OBJ path, it seems it wouldn't cause real trouble. We'd just
end up doing some unnecessary memset. So, as Vlastimil said, this patch is
mostly about doing the right thing.

-- 
Thanks,
Hao

> 
> -- 
> Cheers,
> Harry / Hyeonggon

