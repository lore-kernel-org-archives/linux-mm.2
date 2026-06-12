Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C8DCD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030636B009F; Fri, 12 Jun 2026 01:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 007C66B00A1; Fri, 12 Jun 2026 01:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87506B00A3; Fri, 12 Jun 2026 01:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47386B009F
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:27:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92557140360
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:27:11 +0000 (UTC)
X-FDA: 84870127062.05.2F0EB3A
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id D6AEF40002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:27:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FhKVk9tP;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781242029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4h74kcxJkFPwFOo5Mrw9gW8GX36OPR00MRCmR90JPNU=;
	b=2APT+vv88dhCa8LZTL/PEMo5VIdWQ04O0GC0LU5TIHK97PQxtHigXyn9kxWsRTDxZVAbqi
	I5W+0f4sS1VG8AwxXVH93e+hQow6k8cyQPlmuVHAqh9hxjuQp2y3mKdKFx4/UPOv+ZbPHr
	TLfA2Wd9+BwL682j2UfQzMCxfZ+WYl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781242029;
	b=JMWf1GHkzw4Fd0CKoYwwv4BjMFXzEIobF5MMWBg+FEv2a/acilM9xIeh9HOsksdktoJPTU
	1oiBOPYDcERlQFiGtBLsm4+yopo67yD2pjBWv316jLw/9yTUVrJhn/nt2PsS6yDWenqDHK
	zbLdQErPhJACG6rGmFR5iY+3rn3BndE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FhKVk9tP;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Jun 2026 13:26:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781242026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4h74kcxJkFPwFOo5Mrw9gW8GX36OPR00MRCmR90JPNU=;
	b=FhKVk9tPR9od9h9I7gPVRNxgWrFle6W6cYkv2sScxzuHrqE+O5WO6CoLjTgIs7QeogntS8
	RzrIpsfM0UjJOLH4cGzjwP18JOd7L7VfgvUxMNHdCdeWLLvlMAoC/8mTVGQPqsal6+wB09
	pdeW7MKR+F/sKHu2EsIlxXSFJFiZezU=
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
Subject: Re: [PATCH v2 08/16] mm/slab: pass alloc_flags to new slab allocation
Message-ID: <aiuX6SRATJoaq-jH@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D6AEF40002
X-Rspam-User: 
X-Stat-Signature: njt3w1iu35rwu5aii5nyisen4yjj9xa6
X-Rspamd-Server: rspam08
X-HE-Tag: 1781242028-215451
X-HE-Meta: U2FsdGVkX1+yw2hLKosakSoEVuVtRp1d+Q+WiG8b8webXZ5/V9R9e7H+twfj1y2jz0o4mOExVmcjeeg7+tdr6zLRt22pXvqXRsIzMDxWhXNZ8LfdYpwzO6Kh2p1bO+fjCrYmuQaEdFtq+SNMPYQ4Nsj0KEycpejTYuNcfBrPk0KMB0RuXTQRe7OkVglqzF4EEjxgIIAfxSxqT8sRB12x0geBd4ANuhsQW8UgkaTxRjKoEB806d8vBRTmFiwDibZySYxBhQIP7TIY6VhkQdgDawnslW4AhIYAnAEErtIblifBjf17etYHuY4j/Pm+lO5VqiqRr8JErnJ+f8z6fsXwFWPbOCcP4NtWrbBQMFzDDSikhGS6l2MQQCjTxPBeVWPPtcxaELtIt/TXBFWgB18Wy3ew1aV/GnBXh3aR3vYnGSiz9+9RZ0hmTrp+SU1JAuP2GfMQtJfcar3baKKVOPIaCd0dE76nk50s+RveoahCwgnHHvVncXEx+pHddtrdZOPydzygeAKZeRgeSGnNFPyo/LwFD/g9mpUVPxoN3EuoVdn6N/G71WDWyPMSkzAMt78jSCTjiwyTo8pylX+gMwvyNcAu2qtetk+EhfsedMZ+9mmrNuSKLNcQdJkNDoVQg6h+vpEofIaLO5B/L5h3QJfMnpHzViiRGPvNVj4c59Bjc0DXX5EyxaUkbGhQGTKRi5NGelufH0/LQnrNYbm0O7BW6BxJhlqHf5L+2KwZ35711JgxQRwPI/RheGTAsl9TMKwVGzLqIf8qA9oWR90uM0YEkpVdJhqcX3Jh2K6Y7yUZrGFD1HSPsD0c2AzQwpFRgzuYt3O8gcQO+fgkin8g2eKiZpwlGsKRgtYfqSI37O35ieLyPOa7CnEFn+JAjZP3Hnb8f9D3HUuGTjuHYotXOZ3GOIXFP/m7zOO3Yxg/AqYt++14Rvg0iOpSmG9XCAb+ekaq3s7A33KxEObjw2Tw6ZZ
 nTKQg7zL
 3faux5P9VRALda7u7AtlBRbcZcnWvg2pvs/7wfLoSNBdEqXSVbSU8m1FLrG/FEiNM8IfX5wnG3XPjE9Ls0sKTR1sWqK0OpsToOOr+sSCGkxZ4DBrgpTaPj0b2WOcDZPDsNHKbPROEe9qf2mevV+DI15mP5ZK2Lq1vBn62zLSyytLL6YmlN1EC80qudKsh9YGd2fhMTSWQ9Wp+5YJx2EUV82Vp6AuaGz7dI5vn8c4vRLJGe5Cu8lQxHEu3AIL1wrznrtreSLDw7952jwPAkdjWPw462w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:10PM +0200, Vlastimil Babka (SUSE) wrote:
> Add the alloc_flags parameter to allocate_slab() and new_slab()
> so it can be used to determine if spinning is allowed, independently
> from gfp flags.
> 
> refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
> reached from contexts that allow spinning.
> 
> Also change how trynode_flags are constructed in ___slab_alloc() to
> achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
> of a branch. It will now also not upgrade in cases where gfp is weaker
> than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from
> kmalloc_nolock() - which is more correct anyway.
> 
> During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
> Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
> eliminate them, but it's not a big problem that would need a separate
> fix.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 98b79e5e7679..8f6ca3d5fdfa 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
>  }
>  
>  /* Allocate and initialize a slab without building its freelist. */
> -static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
> +static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
> +				  unsigned int alloc_flags, int node)
>  {
> -	bool allow_spin = gfpflags_allow_spinning(flags);
> +	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);

nit: allow_spin doesn't depend on `flags` now, so it seems we can delete the
comments:

/*
 * __GFP_RECLAIM could be cleared on the first allocation attempt,
 * so pass allow_spin flag directly.
 */

Otherwise, looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

