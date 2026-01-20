Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F2BD2ECE9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4520D6B0408; Tue, 20 Jan 2026 08:57:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429816B040A; Tue, 20 Jan 2026 08:57:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380976B040B; Tue, 20 Jan 2026 08:57:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2943D6B0408
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:27 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E36C5D240A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:26 +0000 (UTC)
X-FDA: 84352494492.13.FA388F3
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id 736594000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6JHAzYT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917445; a=rsa-sha256;
	cv=none;
	b=cPruC0CP/qmpWmSVhv07iFxbK9W7rifUjQJCZ1L1akYATJtX8uTv3RaRe1W/AsiNuDbxpz
	BAAzXQJ5v2KewCvxiceFeFXcVkBnvhwx13tZUCMF1dYiUBnIf8TpkcR5+5qyzIBmUq7L6s
	z5zmL0BDw80SxgCqaUpVlBlBOMoi4Ms=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6JHAzYT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QpIyoYC+nMbp9UGDZ9Nxjg5u3kmtjxXbnx4WVI4Sas=;
	b=ZN0unVsGLEcTQlr5ijhdw6CYDHeEqBms746A3jiha+ZWNqy0eua9/hzkXc7DiDPyK2lbpp
	guTymWTOCApZjGtw+qsQkW938ksnNLrXTsWUxo9FF91T+FCyRThXi8ihd0U6tWSE+nnSNh
	1lDUCvudDZBxfsbsyAtmkC14zC1UfSs=
Date: Tue, 20 Jan 2026 21:56:59 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768917441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3QpIyoYC+nMbp9UGDZ9Nxjg5u3kmtjxXbnx4WVI4Sas=;
	b=e6JHAzYTer8dwPRGR1RoD5wGWxmDjRMRSfZ1c9MzzHBJ7goTcJKS5Tu8Zn3JaZ81CklAVP
	oDfb1KooYntJajk4+sX6nG2gzYJXiLA1k+uhwVAtMqIiqFllSnsM0XAa1yJA413UF19O8Y
	AtcKzru917XR3HbX9bvZkO07qmFz3Rs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Eric Dumazet <edumazet@google.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev
Subject: Re: [PATCH] slab: replace cache_from_obj() with inline checks
Message-ID: <vyhpr6lq5rb6qgkshksg26a5ns5gd5ryqu46pqx2z5twy2gzlx@t4xaze2lhoen>
References: <20260120-b4-remove_cache_from_obj-v1-1-ace30c41eecf@suse.cz>
 <imazcyfzfkxofsnriyp5wa5v6yzszozljircucw2tgj6zex2ee@ytew6wy4kkh6>
 <8bd3c3e8-9865-4467-86d5-17d891f6f21b@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd3c3e8-9865-4467-86d5-17d891f6f21b@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 736594000A
X-Stat-Signature: cgrg8x3t76niextj4ds7ur4yepysx5qy
X-Rspam-User: 
X-HE-Tag: 1768917443-536534
X-HE-Meta: U2FsdGVkX1+pUKXx7XPtBwewTQ6c92XJbPi9pnOnT3gKa/ZudmXJIXVXi8hKUULc5BO7nkVKiMydJuIaVyGupG9G8DV2EMiUtQAWGzZTVmRZpG6Yp9O95WpLlsDkLP4TMmJJx0Yud59sf9fRb1uMdCdb+08rsgiQC1iH73s9CdpLC900xyyfAT4pFWvmuLEZy0DqFzURoGDKWdgR7o7MhowEu9otDIa/2Ymov46gkcHkEmFb7VoeFXXHKKmhB5JrJI0iJbsL13g2h+PWjZ4u/Mmvy9xPl4Bl3I+BhQSZE1S+b3zMGK9hW9ooNMBtSBmQhQzDP5I1JQ8Y21TnOTVuEHknqPSHRC/wcXqhu1INFZnnjfk+rmulrT6GGELzua6wqJ2EEcLszp8Yf/MN/9tCmFiYR2TcL1ceNXMYJbO/flHAXrOY2a9AMM4ZY1BZK+G4lzLrqiXEcx5t7hXFwN/eQRPrfOKAYizOGQWL9Ggm8cRvoXgv0+29gBbUWqDcj4CbwdxIhgUqXdEGkzQHnXoxwfCEYVj6M+wzR0oP03cnPRz2lcKRbLpYothr0FYydv9yOmVdyVh+hGRPrrKMyeyquFEZiuthiizULgnvXly/zs0PnPc7nRm2rQsa6L8HX5CJWqQUG/eiuRKZFwiS+GceIqA2QbXgb0gvi8WyX1Bxa/IKhvgQJJJAZ649/HRGsBCUQSlz6DWOuImMVIWjXlozH5Tie44gUmRC7c/NX75m/HpRqkrCM8fy2RkbLBwTqGEBnWLBlznS7QIb+cfL/rihmYoMtwQ+g15DobEx7Vt5vKdybGvJv4jYYze0K/VfjVfHrigq6J4Bu5hR2TrBzhqMllA3P7Mj+iO/SvYgL+6iRO6Uuihpbdqqz2CBhuJKpqH93bEUsOKCEgBxKudw5dxm+tFZo3PdiUWMIuJPZYzdbkAUz1MwwpW/iwTpm6p8raiUgFVrq64PYuJ2VprNisZ
 pw9++SIX
 JMfYklz9yMGky+Ajnfx+D8aYkvcL5a/FBkMTTLlx2LpB2QbIZVwWcu7ERakHRrTZI8FLTaVdcjHElbJXmE4rhIr4goM+S/Xyx42f/vpwvfDnpsnU/LFM3ABh+d2WXuQGs3+c5VqlFHTYo9wgViSSoi+8BNroREE8oQET2fdXKUZWIBEE0n48obQ6ZD/AeyurLjKAYEXUET4MJFEzclCy+0AoQ3s/IH7Di9e29FxGoKVmFVkY6Bg3k5o9YaD6DumudSMAc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 01:55:09PM +0100, Vlastimil Babka wrote:
> On 1/20/26 12:57, Hao Li wrote:
> 
> >> @@ -6774,11 +6770,21 @@ static inline struct kmem_cache *cache_from_obj(struct kmem_cache *s, void *x)
> >>   */
> >>  void kmem_cache_free(struct kmem_cache *s, void *x)
> >>  {
> >> -	s = cache_from_obj(s, x);
> >> -	if (!s)
> >> -		return;
> >> +	struct slab *slab;
> >> +
> >> +	slab = virt_to_slab(x);
> >> +
> >> +	if (IS_ENABLED(CONFIG_SLAB_FREELIST_HARDENED) ||
> >> +	    kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
> >> +
> >> +		if (unlikely(!slab || (slab->slab_cache != s))) {
> >> +			warn_free_bad_obj(s, x);
> > 
> > Just to make sure I'm understanding correctly, are we intentionally not
> > releasing the object x in this case? Thanks.
> 
> Yes, it means something went wrong so it's better not to do anything.

Got it, that makes sense - thanks!

> That was true before this patch as well.

I'm still not entirely sure I follow. I read the original code, and it seems
like it retrieved the real cache from the object and released the object into
that correct cache. Did I misunderstand something?

-- 
Thanks,
Hao

> 
> >> +			return;
> >> +		}
> >> +	}
> >> +
> >>  	trace_kmem_cache_free(_RET_IP_, x, s);
> >> -	slab_free(s, virt_to_slab(x), x, _RET_IP_);
> >> +	slab_free(s, slab, x, _RET_IP_);
> >>  }
> >>  EXPORT_SYMBOL(kmem_cache_free);
> >>  
> >> @@ -7305,7 +7311,7 @@ int build_detached_freelist(struct kmem_cache *s, size_t size,
> >>  		df->s = slab->slab_cache;
> >>  	} else {
> >>  		df->slab = slab;
> >> -		df->s = cache_from_obj(s, object); /* Support for memcg */
> >> +		df->s = s;
> >>  	}
> >>  
> >>  	/* Start new detached freelist */
> >> 
> >> ---
> >> base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
> >> change-id: 20260120-b4-remove_cache_from_obj-190fcaf16789
> >> 
> >> Best regards,
> >> -- 
> >> Vlastimil Babka <vbabka@suse.cz>
> >> 
> 

