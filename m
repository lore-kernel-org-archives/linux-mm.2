Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA9DC98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 14:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0FD6B008A; Wed, 23 Sep 2026 10:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281176B0096; Wed, 23 Sep 2026 10:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149366B0098; Wed, 23 Sep 2026 10:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFDF06B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:35:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3A3EB1C338C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:35:04 +0000 (UTC)
X-FDA: 85245274128.28.C386F01
Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6A16340010
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:35:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G+beyQvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790174102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CxuB9ejzTC3o9hFwevWHCxu5Fr62XzfQUzmljnivqK4=;
	b=WMG+85mmtzej2nBRXWIqE763whBsjOu8fL2l6VXrLCN8MAwMkV61H6R9RQe8Xj2L7djtbi
	8s/SJWxBWuU9QFTm6kwyCjVBFMgRReG6gSXmebwnO6pbgtE1bAIw4FlC3icviHPQfmweIx
	iFlZYxSDAwYlRPqBDu1D+VmYrY1QJWE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G+beyQvu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.225.99 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790174102;
	b=eYK6N3Jz968j3yh6Id3HX9FBMulkaeVfjQJDefVM201ct+T8Pd7Ill9zTMFAEHvIC2Pe50
	Qkb/iFRJpoC6/2a/BTFVFRDN0+1+QvI1dazoBmJD4EeOzCRDtbdVtNJLKQvWA8qtLw/0tC
	w3Us6pmeRloUqAbP87LlbaGpe3OuRZM=
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4885d4825adso671232f8f.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790174101; x=1790778901; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CxuB9ejzTC3o9hFwevWHCxu5Fr62XzfQUzmljnivqK4=;
        b=G+beyQvu4baPDfsX/GnSGtaa381um6i54sQQ1kvlSNOTz0Q+gigMAvOaepkZ7SknPK
         CJmPPxq/EEGwCfxfIvdFQCSBhBUZJKV7t1K64N34O74gFXAeBBRuu5pYvJvR9ldW9UUe
         641dhlYiLWZyVlJvv5ZjqkBwI8lsp6CzEOjOJszcO11KOVZjRBTwtH2G3VWD9rT57Jr0
         DOE6gTPLR769yja2pzkDQajirzZJPKlwV0SHKr9ndzvJLdEIDV/JOjdJu/WRbOQkkaRr
         PvM5Sp4XIJKtlVioluEVXxJOVOzg2prdaqwUWeHGATrX0uFoCSrv2u2RgDMl/e6SSWgA
         18bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790174101; x=1790778901;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxuB9ejzTC3o9hFwevWHCxu5Fr62XzfQUzmljnivqK4=;
        b=qAjcSohrRrKp3hoe0lpsXi2YVxUcAQhvM4OwbyCOw6IsLLF1PnLMxK+itlVI9e4Lt9
         8/Jtdhdd2rI8Q/aRMHPtj7m5yq6XVZp4AHSKF++WHKztqoZeSuOs0AakkbuwAk4xbTm1
         FvOmaasSw4slOFTbpXzs3Zha1qSy3l8fqzMhaY2qHFVHGlhUc1jLNR+DDM1RWhSEblC2
         4BNLyLaCBGI/JgbyptqQ9IkLxqnhOkjZrnPX1RKTChNcI2MWUcW2e8A5rYTBVeh2sXhZ
         SgphNt5KXYxy1S8MzOTP5ORFhGIGpONM4SQvSU6wouRD+jJjLV10k3y7a5QSacWkd78P
         bQAA==
X-Forwarded-Encrypted: i=1; AKwUvBzjlFUKT4s25/yzV9drhIwfpfLoB4pGChMyqfbOQDdjrV779mm1DXr+eJNBeGlMLkzpFXxjXi2i+g==@kvack.org
X-Gm-Message-State: AFuF++lZH0vkgPS5Bc7ZT2CGrcNmdP7SLLsPLxuMi9oYB3HUe8QFscYi
	v44nypkw5jqCo5uvGLUZYZxbmM/dQ+fhPCK11l0uvzRvSylpvbbr3hvc
X-Gm-Gg: AYBFou1U/FVsi18jUEQ52wBixS9DjeOV4xzt3pM+mH/6KX4SmYxFBmI8MLsedxCdbLM
	/xX0Z0WuK+p4HP+AxHA2102N0xy1DLCz8i5dgoNoLhQplXxiTVuHNNcl2CBMqtiO1kpu87eUUXX
	bSom2KEn1ZliPEIsyocmyD/F1ztNH8ScQW/Q3ZnnPeyzsF7spf2GbDD2GNSS2Jv5snyGjq70uRY
	NGDxav4esuVDEVUNzsEQ346CkYK8xM+ik2OiBw5vLPixyOKYCxCWFN3ZYyoxhv5EsnHZgtdwsVj
	yL/rSVhyLE6uT+pvaiasiadotWMC9TpGju3LJ8CPaMhe56WtjAUChPe9CsJ3/1aKagLlkgEXDpv
	C8ZznV309t63aGvMXT43fHMy8WkoaFTs/eV3ZfR4Ey2hmQ4rkoaMhR4oW38UmY7J4eE3wKtAps8
	CtJe4kYGkUs9CeOGdUOJ11vipKSgKq7Z5TGuceuWsrZtEmMku9HI2OcjSe4bMWk4msQSzy4TxiJ
	s6x9YH8o/kjTohGfHRBBqRrP0mZMX+YIGIw6JquqTbafZFPlICDDGOewYQFguQLdrg97r6su0xG
	4lUP59S80MEswiTdUNuj
X-Received: by 2002:a05:6000:703:b0:486:e901:e59 with SMTP id ffacd0b85a97d-48867093c7bmr5013070f8f.31.1790174100524;
        Wed, 23 Sep 2026 07:35:00 -0700 (PDT)
Received: from KASONG-MC4 (11.pool90-167-203.static.orange.es. [90.167.203.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868779472sm7703114f8f.23.2026.09.23.07.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 07:34:59 -0700 (PDT)
Date: Wed, 23 Sep 2026 16:34:54 +0200
From: Kairui Song <ryncsn@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arPhtkrM-khhmgnN@KASONG-MC4>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
X-Stat-Signature: zscijgg3msk8jhzf9dzd9x77u1guhmxf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6A16340010
X-HE-Tag: 1790174102-289656
X-HE-Meta: U2FsdGVkX19WyW6yXH/i+H3jPuIkfAW0UG4y9VQ0yyufGKcCgwnUdNnPzRXQRMvs3O6ODVPUwiSYjMvgT7Q+5QFuhEiSIypWx5QvAyQgFtuCK6M3rNJYl45S6Ysw4a/x7So/Y6KbfBhb7XDeVJJLlYh06w3FZ9mtZOtvTQWZtumufJIRMkqpKtRSxsKWyW/1eRd5TQXo2nOOrdgBFbfH2HjElyhUqaN8LNjnoWS5Kq16+O55HbdbYrYjG/6t1RDgomyt0sHElhk7HEW1H6YJ5BUHhnbXC4CUgRILX978tQ60WbYFhbSmvQqMDe2eN5Ujszt1LeVXcYdFvq1GXNM6CRjPzIu+l1fPSdFf21i2U19V8LlanUAq+xw38gRe/GNFIdo9geKjcxAiFqQpTizmI0RCqJ04TdCCeRTPQAjbUUcJCv1nifcWK9qeQLGNM1pV0GDv7k2/LQK0ex99lJ7X9NpHhFtsnmmJsthMbvLxcdr72dYDVM53X6XSLhYbWCjkeoN8nvLWjJKIexGQz4beEPb2IzWR/8WMqE9rHTtpkOItiUODvuvsYQkHoG7a8DDhp13xpcstGoA+U71sC70ajRrKoCx+Gb/CAo9LF8BRQ5RR8iqmowIGTXQGPwN8IxzClIlcEnSupIM1OnGtlwkKQDwI/nCBg+rGkR86hK32PBXYWuqlApnqvl4ki/+QHzlozPEh/fCdTlUMoulK36aeHfDdNGa/fcyYCR5Zp0Ye1x1oMdzRNr06C6IHUOceNgBCaUP3Rz6Mg4YgwUOTt5eumr8xDr0qxIxski4UFK4A5OKGjV4HCSdhHvfjKon3TPzkZImE10adDovaHFZr+Zxd1kbUYt30yVw8c3ButBw0lMa9KVZnmiZG3CCmOwYcWKq2c2MGGLf8wOX2PzAE21gRXBecm5alRzcYipwEIm4O/LSTOWPCs8rmFhDH3wz5bG3HqQrZUOMt7goxNvbYCcp
 A/PfFtIP
 SENISw+CssVlAHfAbMSdqF893TSESozrGCAnHDuWlpbM9pWsbUksxkTjN/4ReVANF/m6aySAVMchFVXjhXnAiWLpB2Uvmx7ukxsZe43GzjFz//VjDPsKM8zTEoQ97KDGypHVKxmKLYh22qDxtbrRa751AqLZjK2ZGph+LagnAI3dJkG21dj5Ji155VqAtoEDnAXhHz6odIuFeEccwo3Rk9h46d6I7085ZlzpLkrV4gmE9NTs4PDZ/7hsc0OFxMDgh4DYwG1vCzd1BnVGmx3GWKPpNJ5Vck2dG4pZ7cGeB7i2Ic+RWZoie9VJPzfGmzHPQ/J4/hXKgRPjxfGPSTRnZjYmvCVZEJI6qFOiIgl1Fhc0oNZKbmcKrGqIvucpiT0XbuKXhJqkUp+OVT4AugD7ZEr9LRsVsIQVyx8HCExgvN1Iq0bq33KpU0uLtIRj+p9LstIeVP0ia2UcAdFBMPJLvuIB+8QO32qcT5WLVBbGHIevbkA8PKN6BfB0YoZwtZXkcPKaUY1Jzkcyw9O471Tt64aESr+bHa4ZoXGSTtYTYEY8m/zU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:27:01AM +0100, Gregory Price wrote:
> On Mon, Sep 21, 2026 at 12:01:18PM +0200, Kairui Song wrote:
> > > First of all, the traditional swap counter has a very well-defined
> > > meaning. It is the size of the memory that, when accessed, requires a
> > > page fault. A page fault adds significant latency to memory access
> > 
> > Yeah I agree on this. Swap just about makes resources not directly
> > accessible by the CPU act as RAM, whether that is storage on disk,
> > compressed memory, or a network resource, all accessed through a page
> > fault. I hope we won't make this fuzzy in the future by introducing
> > too many magics.
> 
> Hm.  The counters are already fuzzy - the accounting is already doing
> two different jobs.
> 
> Suppose we want to allow 24GB of logically swapped memory, backed by up
> to 8GB of compressed RAM at a 3:1 ratio, but permit only 4GB of physical
> swap.
> 
> Today we have:
>   memory.swap.max  = ?     /* logical memory requiring a fault */
>   memory.zswap.max = 8 GB  /* RAM consumed by compressed data */
> 
> If memory.swap.max is 4 GB, zswap stops after 4 GB of logical pages,
> despite consuming only 1.33GB of RAM.
> 
> If memory.swap.max is 24 GB, zswap may reach 8GB of memory consumption,
> but the cgroup may also consume up to 24GB of physical swap instead of
> the desired 4GB limit.

Hmm, I mean, this sound a limitation of the zswap.max and not swap.max,
swap.max is doing a prefect job here limiting the logically swapped
out memory.

> 
> memory.swap.max is simply overloaded - there is no way for us to express
> both limits.

Limitation of physical layer is some swap tiering issue I believe. We
don't have swap tiering at the moment, so we can't do that, right?

With tiering limit setting swap.max = 24G seems totally fine here.

> Could we preserve the existing swap semantics and add a physical swap
> counter instead?
> 
>   memory.swap.max  = 24GB  /* logical swapped memory */
>   memory.zswap.max =  8GB  /* compressed RAM limit */
>   memory.pswap.max =  4GB  /* physical storage limit */
> 
> These limits would be independent and compose naturally.
> 
> For a zswap-only workload where we care about RAM consumption but cannot
> predict the compression ratio:
> 
>   memory.swap.max  = max
>   memory.zswap.max = 8GB
>   memory.pswap.max = 0
> 
> For a workload that performs poorly after more than 7GB of its logical
> memory requires swap faults:
> 
>   memory.swap.max  = 7GB   /* workload-specific latency/SLO limit */
>   memory.zswap.max = 8GB   /* uniform compressed-RAM allowance */
>   memory.pswap.max = 0     /* zswap only */
> 
> In short:
> 
>   memory.swap   = logical swap       - workload/SLO limit
>   memory.pswap  = physical swap      - storage limit
>   memory.zswap  = compressed memory  - RAM limit
> 
> This would preserve the existing memory.swap semantics while allowing
> both backing resources to be constrained independently.

Yeah, this part seems better, but a pswap vs zswap still seems maybe
too specific for one single usage? Or too board to be over rided. :)
A actual tiering limit seems better to me.

