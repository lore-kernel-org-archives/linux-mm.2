Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6E0CCF2F2
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 12:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5CD6B019B; Mon, 19 Jan 2026 07:06:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FE96B019C; Mon, 19 Jan 2026 07:06:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6BB6B019D; Mon, 19 Jan 2026 07:06:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8508A6B019B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:06:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22A21BAE2B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 12:06:52 +0000 (UTC)
X-FDA: 84348587064.13.CADE084
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2EBB6C000C
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 12:06:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujesgdvy;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768824410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpMiDKyrIJgj/yq5I6LOa2WeBqzXUsHVn4Q35ITZoyg=;
	b=OTuCEl+uz3YsCBwxKtdANBadXIQpVu+TfbG9qjURRD6rzJHG6tZ8yZgaC5+bT86PwjcELn
	N3Io6NEKYgmPd6WQ+aH12LcETwkFuEFMSygDSATh26OXv3GnpQTnsGk4WnIOKiEhT7kY6M
	kCmnqboMQDXABMy3jCfSkfLkzL3XEI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768824410; a=rsa-sha256;
	cv=none;
	b=GLBqktk9WZmQ+EprAiX1kUDxgPmGUQ2VsHo4NGd9fdCmZ08hi/sT1vgkeYzzeOEnznQsKF
	MDK6FBQObJIMMYiDcSz9kv/NlhBjvIFer9rFWalZ5iNcmmGsy39CjgDVTQdo48gcemCz/k
	k3UhKJTexglesraoxkizPNCoP/DFW7s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ujesgdvy;
	spf=pass (imf28.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 19 Jan 2026 20:06:35 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768824407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lpMiDKyrIJgj/yq5I6LOa2WeBqzXUsHVn4Q35ITZoyg=;
	b=ujesgdvyRBm28X880BAWZx79BMQ8RohqEjA7JqLuDJpP/DmSQXgQ+8bYT7NuR+jJvmzVhR
	ljG7a5fFdVjNZaMsXyB0IzFcHjxszBq1zB2xjT5RXzCvPaoGf+cnw3Vk3/ji1INMlA3uik
	Aum7CZXs5jKjjyUuw5WRcMWNV65zXr4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 07/21] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Message-ID: <gv3ixsxai47hjv2pzpnptcjeqw7ikt5nnds22hkxlbtk7wgnfd@rzzcijtth6f6>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-7-5595cb000772@suse.cz>
 <aW2zmf4dXL5C_Iu2@hyeyoo>
 <e4831aab-40e6-48ec-a4b9-1967bd0d6a4c@suse.cz>
 <008029ff-3fd8-49cf-8aa7-71b98dc15be9@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <008029ff-3fd8-49cf-8aa7-71b98dc15be9@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EBB6C000C
X-Rspam-User: 
X-Stat-Signature: ej5owuo5op1oh3cfdwgr9csep64syhet
X-HE-Tag: 1768824409-225192
X-HE-Meta: U2FsdGVkX19OZ+UK5B1W9MZYKNdtF9UwCfvNTl9mBcjMtHvZ0gia6jQuOsV1p2gbYbcW1U9MYwzQSU8s+NjqGtsRBGx5vZMA80Rf6KfOLkXVIlrAqLkLYgYhqSIHfTUCOrz+P6n7NbDpNjcf/tTBQ68jIhqq8yBUe9Go/vU1cdsusMytWtP4Tvr2en0YW8HaLzpNs31serJbZfOqcytrRwEEGf6S8QWbVtjQ2YFSwBQgkQzhdKdM+uq+yqiioxGQMzrk+0RQ6DeCfpCajC28brlQoX8BdyUoXyD7saBaQIX9SIcuudc/qV74GHd+NeYGXhDrNfxoEEhtVB2vCj5zAM8QyvM38NBBKSltlTPhVGfQlBh0hukFfKYhw5xzUW88/n3gimzbTS3Mz9hRdWELsAJbeOPjFhbhz1THuqg9/Lsi5Sd7RkvE3S+VRqOZv4IAblBb3pFWZbFu3bb2rHeRVvUNqDDI/dSv1T3L7391B06C8NL3YON659ZirYxhjQ8cqCaTzrzQumcBrg55ke2ywK3zRGoZHmewNavC4EglR/MnGUc8dxQvOjKl9Wb1Vm6szcL+95v4evZ+yJV2s5o9KpVICm2FbbWyFppMhhUbgvc/Xx3ULjYJYyBhNs8p2vTO7tpx9a+tZ2scWmIkCoC+L0SDlV7qkFiLFRHk8+uilelZlx/KBmg74cv3Mwy+o9ZNCx05uh0gZK6SPMV0ecJMyTvXYFtJKWOWmglXek2AP/rsaC3cuIlUFbFktwueHLkQ5i4NTR0ZGV9l3khUaSZt/c0UYiE/m6lTi/dKFrr1E12SuVHU+yc0HoC3tmtxUNU4BRAP10zamV/qbN6L/i9PMELsVeX56i0/2hsI2NMn/XVICqQCzEGxwDXydFKTgJzgkjNr5mHBKr+sFIjj371Gjspa15uactzw/pS/awWR0G75+VDC6NaPZZiseRpIxIWWXPO8SCAYxr4gLI5ZlWP
 4JkuAhEZ
 4A7qqboQjpyn4Wkji0UPDUhEbfP5rbU1jWyWi3e+acuYx8KEXLrraBjn/TL1O8tJdy/i91c9kj4cK1wlWwdTFEHHHPDs74Hfc0ZtHIyiUXdFP/t+9GwrVGxBx2onVz3lAqefBa0Wg/m/nXPw0s70+iJwS4WPkJdb3hDadwvRZPaY1eKGNDxgf88IP/R3lag7Z7i+BfpufTzdR9TfL0w2gtzu/XeQ3HK2sGPf63gaGBrRscSnlLn1gDgQNLmE95m7egrvhnUB2j95hCXHV9iFKeyyyzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:23:04AM +0100, Vlastimil Babka wrote:
> On 1/19/26 11:09, Vlastimil Babka wrote:
> > On 1/19/26 05:31, Harry Yoo wrote:
> >> On Fri, Jan 16, 2026 at 03:40:27PM +0100, Vlastimil Babka wrote:
> >>> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> >>> kmalloc_nolock() and kfree_nolock() will continue working properly and
> >>> not spin when not allowed to.
> >>> 
> >>> Percpu sheaves themselves use local_trylock() so they are already
> >>> compatible. We just need to be careful with the barn->lock spin_lock.
> >>> Pass a new allow_spin parameter where necessary to use
> >>> spin_trylock_irqsave().
> >>> 
> >>> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> >>> for now it will always fail until we enable sheaves for kmalloc caches
> >>> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
> >>> 
> >>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> >>> ---
> >> 
> >> Looks good to me,
> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > 
> > Thanks.
> > 
> >> 
> >> with a nit below.
> >> 
> >>>  mm/slub.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------------------
> >>>  1 file changed, 56 insertions(+), 23 deletions(-)
> >>> 
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index 706cb6398f05..b385247c219f 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -6703,7 +6735,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
> >>>  
> >>>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id())
> >>>  	    && likely(!slab_test_pfmemalloc(slab))) {
> >>> -		if (likely(free_to_pcs(s, object)))
> >>> +		if (likely(free_to_pcs(s, object, true)))
> >>>  			return;
> >>>  	}
> >>>  
> >>> @@ -6964,7 +6996,8 @@ void kfree_nolock(const void *object)
> >>>  	 * since kasan quarantine takes locks and not supported from NMI.
> >>>  	 */
> >>>  	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
> >>> -	do_slab_free(s, slab, x, x, 0, _RET_IP_);
> >>> +	if (!free_to_pcs(s, x, false))
> >>> +		do_slab_free(s, slab, x, x, 0, _RET_IP_);
> >>>  }
> >> 
> >> nit: Maybe it's not that common but should we bypass sheaves if
> >> it's from remote NUMA node just like slab_free()?
> > 
> > Right, will do.
> 
> However that means sheaves will help less with the defer_free() avoidance
> here. It becomes more obvious after "slab: remove the do_slab_free()
> fastpath". All remote object frees will be deferred. Guess we can revisit
> later if we see there are too many and have no better solution...

This makes sense to me, and the commit looks good as well. Thanks!

Reviewed-by: Hao Li <hao.li@linux.dev>

> 
> >>>  EXPORT_SYMBOL_GPL(kfree_nolock);
> >>>  
> >>> @@ -7516,7 +7549,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
> >>>  		size--;
> >>>  	}
> >>>  
> >>> -	i = alloc_from_pcs_bulk(s, size, p);
> >>> +	i = alloc_from_pcs_bulk(s, flags, size, p);
> >>>  
> >>>  	if (i < size) { >  		/*
> >>> 
> >> 
> > 
> 

