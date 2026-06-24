Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB39CDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 08:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33EE06B0088; Wed, 24 Jun 2026 04:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316CF6B008A; Wed, 24 Jun 2026 04:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254426B008C; Wed, 24 Jun 2026 04:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F38D76B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:17:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51941C1614
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:17:43 +0000 (UTC)
X-FDA: 84914102406.28.162D0B5
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id DC15340005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xfX5P/kx";
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782289061;
	b=VwlrHTWRNy0V2xDBITX3fZemsP/g5BtB00DncSi32iP3CUOpixOxTFffR2/G3RmJRbz7HG
	M/UfIruwBhIGUR+cZkWb/vCXeyq+9lBM2jgkG9zS/2QyLcIbycXuU01gKqPVJzKLLJ7eNQ
	h+eGMFGjJhzwj0xttPLVf/SdSU1lbwM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782289061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/nKRSL+C76nTG6IfkT7RdZALB2h8ggPQxXITJrd/wQ=;
	b=MIl7AHQZTKz+fDroZMHtfVnPV0dpdohWMjMmJ+GP5H61Tz7RZ7E9xLIwTd04xhzr3XWYZL
	2cmA/qTm0Tz5KY1cZ0ZciykdnkNrytjvdN9xq13twBXGmmLaZuxl7DnMXUr/JW7v1ALh4e
	yGo79at7QTTxqhSTLvqQ4WemkbBIXZQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="xfX5P/kx";
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 24 Jun 2026 16:17:27 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782289056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y/nKRSL+C76nTG6IfkT7RdZALB2h8ggPQxXITJrd/wQ=;
	b=xfX5P/kxONqYtqmA8LrK8K1LITzFURH7e1PZyKzNPO+yvNYToXWHi6s0KDn9x71zptkoUl
	Yx+MZA70sl/l9O4+KMEXR4exfwXrufcsRt58lBoystT5PRAJOR4NUHzQwdZg7IxKZJRfDa
	uch/goecRjkznyDLNiSYZUjhWZdRou8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: deduplicate NUMA policy calculation in
 allocation paths
Message-ID: <ajuSNGf9aZyyS4mx@fedora>
References: <20260623110952.411041-1-hao.li@linux.dev>
 <0c69b68d-7c67-4d3a-9f90-86a56bc229e7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c69b68d-7c67-4d3a-9f90-86a56bc229e7@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: wcrgrg4oup6peu51tsux8k8f4csnyfbg
X-Rspamd-Queue-Id: DC15340005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782289059-689387
X-HE-Meta: U2FsdGVkX1/e/M/MbatFdjHYAey0ah6IcKye5DALDK8+8SiJqvCGIHh68DpdqV+4NNdEAzIQSGfxpIM5VjsUtZAZ6EIaFbY4k0EVh/7zixF20zNVq89i9cNbXYtH2qvBo59B4uVjceZSn05OzOGs6oE34B6umnK3aPRNAZer/f3ElK+N5pYNW6aNp+VjCZUdAsoEaHCHgS0j0uY+sdsqCP1bRZWmsAxjMhsxL+0UgNHCqT51/mATBp7fTw6pF4rZepGsiOFv1o31fCJmWIOvstHN4udrDTsxO6MVANdP9OYJFNuGPjk6JD4iCfqG/QVnWv9QOsqFp+j9oOmT/uDwNS4yXvrAVUcTm13FxXT3bOZod4hW47jOzaVFhTYGnvvBlhKHZwQSJFCs9UmAJPYbQJKLEL+A9lpZmss1BiyfZQ/wQJ+K8NGLZIFkik+HITPCFAuaEy8L8d7Az/NnYn59JQd9xwyShyZBXUMgOdNrz6rwXvqx23eUiolZkEdRh8C+wmAMzwKb8XLNoxtsWR1LBPTq414LWh8eTVoJp6P6gsASF90lPbCNSek+NyiznM0/AqvxWTGYkWlCwE20lrmVM3jbEQUfjer4jaceysqzhEvDMJukwbmbSsQQGmYvITtQMDE3TZcQdntQNoE5qc1BY2aKZGG0VWxol4deTe32aKcEP3hyOZPIAzwHjB25lmtD8cPgbtiRbnBFomWford96sbWHMHWMe89/IXEedzyWawpqkjiZKH5GRgy6XXkMCIi0RI9X8JbjTdgKQTt17Sb5JyU75umjMmxF80bgyOnjkqCfVikvEoqFxY5Rf8YKb6OMOfqfMhxRZUIh5RoejwISt2Hm2xz9DmJ/CFnh/tpl38B3dEbN84TV/3Wvrzz9OgI8dvrZNd9ak9RxZ2DZD3h6tXQLUn0toKQegJ4VQbwqdKaGCNuBrD9jLy2z1cwp1RC3V15rVMQBhcKRgegxdJ
 JafNN7V2
 HvEoCuNry88MLevch3YSA6u1uzcUZ8VfA8skRkK9CgnHGDYN/scD+B4FCbrmBAn4DTcPmkZW9RGE5OzyoCQ5FM7DY0GWtBYekRA4CFZiifr0YbtANcDC+Oh20Yk3gK6vn8SNOS0HXd1pI6ygrXMPpq4SPBbAiWJQNR/fYgNfBzO6AW1flGWn/gjyxuqaZA42APsZo3A3I2U//Lg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 02:14:55PM +0900, Harry Yoo wrote:
> 
> 
> On 6/23/26 8:04 PM, Hao Li wrote:
> > Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
> > NUMA policy independently. Since they are called consecutively in paths
> > like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
> > redundant code snippets.
> 
> Right.
> 
> > Introduce a helper function to resolve the NUMA policy once, eliminating
> > the duplicated code and reducing execution overhead.
> 
> Nice.
> 
> > Also remove __slab_alloc_node() function because it is almost empty.
> 
> Nice!
> 
> > The callers of __slab_alloc_node now call ___slab_alloc() directly.
> > 
> > Additional notes:
> > 
> >   Previously, when slab_strict_numa was enabled, alloc_from_pcs() and
> >   __slab_alloc_node() could each resolve the task mempolicy, so
> >   MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE could advance the
> >   interleave state twice for a single object allocation attempt.
> >
> >   With this change, the strict NUMA node is resolved once and reused by
> >   both alloc_from_pcs() and ___slab_alloc().
> 
> Nice catch!
> 
> >   This is a behavior change, but it better matches the intent of
> >   selecting one policy node for one allocation attempt.
> 
> Right.
> 
> and I think backporting is unnecessary here.
> 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > Changes in v2:
> >   * Use a better function name apply_strict_numa_policy() (Thanks Harry)
> >   * Remove almost empty function __slab_alloc_node.
> >   * Add a local variable, strict_node, so the retry path in
> >     __kmalloc_nolock_noprof() computes the strict NUMA node from the original
> >     node parameter instead of a previously resolved node value.
> 
> What about overriding 'node' before retry label instead?
> 
>         node = apply_strict_numa_policy(node);
>         [...]
> retry:
>         [...]
> 

I agree! I originally used a separate strict_node variable mostly to keep the
old retry behavior intact. But looking at it now, the retry is really just an
internal fallback for the same requested object allocation. There's no strong
reason to advance the MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE state again
on each retry.

> Otherwise LGTM.

Thanks!

-- 
Thanks,
Hao

