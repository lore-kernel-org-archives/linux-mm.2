Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0242CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67756B008C; Thu, 11 Jun 2026 23:21:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E336B0092; Thu, 11 Jun 2026 23:21:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B1E6B0093; Thu, 11 Jun 2026 23:21:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C59C76B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:21:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D6BC1403B0
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:21:20 +0000 (UTC)
X-FDA: 84869809920.23.29D8A79
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id A762640004
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:21:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IF6AbNNJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781234478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucOrcwvIS+R+Z2bG2Pdy61JNFx4i3uJGRkqwOfdveDc=;
	b=GUhltaqEN8AZbTlDYqM134w8EcJ0uIatxDioxVCQdyZhqqo6vj7NhjW7WCms/qPjenD4Eq
	e6thS7lhBxh4PWJPrCphsOA2DGke0zmAK3WOuCAHJE5CGNahdAqOsBI40LLFXejyOv4ajh
	Cs2sBQR1cV95PM4rvoAMuQ3PeCOroxY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IF6AbNNJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781234478;
	b=hRH0VxnNnsXneYTY08B0vG4T00gRTTvV0kfJtvqqSOTOFLdaYA2l2/2RvXc/37287ML41f
	ZUgfaNUGrqXEpcDQ/byD9J+8SR0wzpYl3r8oQUm+sTvel+yoXEzbhY1ujA8wxfn9cMf/r/
	XLDbSPwNdhE16dwdp2ioO/9O8PYsTn0=
Date: Fri, 12 Jun 2026 11:21:00 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781234476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ucOrcwvIS+R+Z2bG2Pdy61JNFx4i3uJGRkqwOfdveDc=;
	b=IF6AbNNJHEumf0qjYw2tthCa+czfyc1aIgni5OFaOiCD49/mZS3SB6JyVpu9M5JP4hQVZt
	jcn//NZ4eF8E5u1xIAjVJqx4YcwIc7Zc5P8iCHQrMfmdHMfjVhXzRi5tTpU3QkpEi2je/c
	PtxQ/itq38gOnr74PMWrSAWGdwET3pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 11/16] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
Message-ID: <ait6ojueVi38-s85@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A762640004
X-Stat-Signature: tupio8e4fqpr8srn78byk9tuwmkk3jid
X-HE-Tag: 1781234478-897061
X-HE-Meta: U2FsdGVkX1+fRprCAKyg0GwmIG+5pnmICMHOOA0xzrt1wA6St0xLiqQH2m3UGh5lqOt+xcdJfypHuffVJgwqeJ/GU66guzdoCvg9FXpwk2ip+p5etlgMQVn45xUOkQX3U4C3hIRLNz+/5oVPr+VVf5LbOIQRomAdbbxZGpmoeJTuJV8oi4hhUKz1Weipx2Y9OiQhtA28sWOxPV7vHu9fxIwi8JQ07028PAy7fF9vFUYLFBXDqPECzLT6ImTdIQJjI8Cq6t5KI37PxUXZ2ITL0DJHOBG9N0oRne5Oy9XyYeGBOWioQC/WeYnW7oQhn3RXKuzzcsmu4NzWEHcVh0QOnp85m4bqDAmYC+ebNJLe2pHLVua0LkuSNgwDgLGTqT9z1mHs+amN+QyzLM2ux6nN9nNJTbflfOd3A7WmxNKeZKJ1OJgQHerT3EaoI3m95GkufivpZ42IgsgfqMTD3vAlt6xPZTE5hCPNTwVnmGB/x6rF/Yru+q+KaNM2FrkQasbFDKil0IaFxiTHwgrfFVZ6gQq1BOopOKj/oa5iubtZPJe4jrpNATla03M2nXC9u3MeJ1evokefF6l4wq3FLoh5tN7jh3s/NWLeqKnrHEUN3U5ysPfBHKiDIASF5x1wA+2EAKpLQR1yZcFGM+LgKhUu5T4qvFAwIlG/1ME4NzTHgfuuz62kt8fFltVHfwGXgpqB9UJ0ET+wSNA+B8hR4v1VUPv5XV4jS/wxXz66Aqon282lje6G58da9yE1nMq52+97mqNNEXiVrEGdmxxx8TjmYZAVV6yFr0a44+TxGRjGf0BWecAOhSxVdfN87S118O9oy0FrqGYmnuOnH98UR1resmzr9VIi+yH3e12TmmHW/esPmbc+9YD6jsZmxPMYKEXGbaz31Bel4wgakCjStMnYkPQ+XeKoKGBm2+MLlVpJ40blG1n4L0DH8ErTrALMGk9H+KZLw+shVjnga1o7nT5
 WUvccc8J
 hVa5YQA0aX5stoFS9+MPWUqKVWJxAoneFF91Ip0yMAEC3u5RrjMn35rChHwZdnDiHKmEMaZ0e7BE0EXMONsE4WN65ixndgU9HhMnQpwOYXHw3CygdqPjDU8V3V+g4kS9djINKPL8jpQJImFARoPpO/ddeAdVol7jVXkbN0bCD9idITL80KozBdRo1uR/IV0shOfWc5KH9Wjf0dUA38DcTRJ9ljbFvrdcKzgBGBK9mUFQo1bZBrFALqyVHE96Nf/Zp7JmajsHf7bf2hXOgw3qWnM/LQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:13PM +0200, Vlastimil Babka (SUSE) wrote:
> The last user of gfpflags_allow_spinning() in slab is
> alloc_from_pcs_bulk(), which is only called from
> kmem_cache_alloc_bulk().
> 
> It turns out that gfpflags_allow_spinning() is not necessary, because
> kmem_cache_alloc_bulk() is only expected to be called from context that
> does allow spinning, so simply replace it with 'true'.
> 
> With that, we can remove the "@flags must allow spinning" part of the
> kernel doc, as there is no more connection to the gfp flags in the slab
> implementation.
> 
> Also remove a comment in alloc_slab_obj_exts() because there should be
> no more false positives possible due to gfp_allowed_mask during early
> boot.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0b9974bfcb24..ef457e07db83 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  
>  	sz = obj_exts_alloc_size(s, slab, gfp);
>  
> -	/*
> -	 * Note that allow_spin may be false during early boot and its
> -	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
> -	 * architectures with cmpxchg16b, early obj_exts will be missing for
> -	 * very early allocations on those.
> -	 */
>  	if (unlikely(!allow_spin))
>  		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
>  				     slab_nid(slab));
> @@ -4867,7 +4861,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
>  		}
>  
>  		full = barn_replace_empty_sheaf(barn, pcs->main,
> -						gfpflags_allow_spinning(gfp));
> +						/* allow_spin = */ true);

we can remove the `gfp` arg as this function no longer use it.

>  
>  		if (full) {
>  			stat(s, BARN_GET);
> @@ -7333,8 +7327,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
>   * Allocate @size objects from @s and places them into @p.  @size must be larger
>   * than 0.
>   *
> - * Interrupts must be enabled when calling this function and @flags must allow
> - * spinning.
> + * Interrupts must be enabled when calling this function.
>   *
>   * Unlike alloc_pages_bulk(), this function does not check for already allocated
>   * objects in @p, and thus the caller does not need to zero it.
> 
> -- 
> 2.54.0
> 

