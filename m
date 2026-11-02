Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE10A606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E7O1MaO9
Received: by kanga.kvack.org (Postfix)
	id E1AF16B05B4; Mon,  2 Nov 2026 04:09:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2996B05B5; Mon,  2 Nov 2026 04:09:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08836B05B6; Mon,  2 Nov 2026 04:09:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B281F6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:09:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 306F8A0C1C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:09:30 +0000 (UTC)
X-FDA: 85389605700.22.32C434C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8501980004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:09:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7O1MaO9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793610568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b/cF6WMzcjKaJKZ5oQKJkStJ8KKrbT8J01NBjCuG4xA=;
	b=ypSExk+VVvE8PNH+T0C4uFLB9bE9tGulBHNoedkADCoerzyk/i+aAeqbKaDdUeUoODgcx2
	ZwAxyvYVeChkRzjQyKGVZxrulMxeuS6TQSY57xlg5vQSKzmBp7PtEUm70E4fvWc89v1fNX
	dvYVOq8woWtn/3lnV9vYPwNtSPQniM0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793610568;
	b=mqaBWniWgQHawoobciQhzo0DoJ+r1dRkfYAbIJRic+ECfYtnOkCpuZXX2nkVg7erZxsBcY
	UZMprTHNzr4/RjMT86G7qmDDP8h5JTULfuoiVnotaGutBJdae95r35kR4+bD2hDNfcG6IB
	BnBalBNmU3GN09tuCZgCxXe0H4637xU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E7O1MaO9;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C88E243D80;
	Mon,  2 Nov 2026 09:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BECB1F000C1;
	Mon,  2 Nov 2026 09:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610567;
	bh=b/cF6WMzcjKaJKZ5oQKJkStJ8KKrbT8J01NBjCuG4xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E7O1MaO9SjuMyxTFmrgaga3GDsG+Fg7gKkAhGPXB6FQWs+hFpLzvqUX88ZE0tAYjC
	 AXABiP5xrYUF7z9zwjGYYGloS56DzTVoFij3UTR5frb+bI5TbMrdN6HcdEO9zCEiPB
	 +URPLLdf8JBZ8VSxGiJ3sp7Ug0JxLpGrZIyupnMGn7glvjdjgMm39ep4O9YSjfzQ7u
	 MOUuVe1D4WA+A4pq4+svuYVsIj+/QRz/FaDwnmcLfFDltdW9CLAaDbPVHrT5NUUQ8W
	 Rhpxp3gI6PdMDqi/cYgCnqRLxV3DJ5beHMTtvg3hrWiHYCVHNX9MetcvQ4FiHppZI0
	 kn0+5LH/hEM7A==
Date: Mon, 2 Nov 2026 09:09:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
Message-ID: <auhTLSjyu-sNlQAB@gremlin>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8501980004
X-Stat-Signature: sqzdsudpt8fy5atxgh3kijg6o6qcf5hc
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793610568-542121
X-HE-Meta: U2FsdGVkX1+TzyPVFwdZFi+e28KTDr6HFfSbZdnDjc+b+TqwkWG7rMKdrVaf8R9tsfZAf83WFDPREWBfQ3QRPi0B/spyZjR8BQ4Z2CnO5jUUYpmLJ1U8fDZ2RSbhYhD1n9VRD80cLJjvJ2KROGwLbbWQriUxu8oXwYES0HywNbMCchTVTvzrsEcOCfMklp9cuAvgE0MVxJQpfklw02lylhn2x5oubfcLm4gM62jh5k2tZ+wKzd5LMTQjviAEZmSQKldzJVxgUIX8r/X3NTXqMMmcfhjx2mxGDQYk4NJYj+RCmMqDN5GwGRrGbfymcSy8uSEqi6WlgV7+K+qXgr6nRoxpIgMaylVDE0N+N16rAaTcbVEhmgEDjK9vLbU0HnZNgNBNkYnweh7MiL6oV4hwWAgDLAR/YQ2vWBYk5Ub8QGtXN3Aa5+9pZR3FaOwKPJ5ZJzM+t5g0/MtC5H7bbgzrK//C/exIrIa8QSk9/NAAJELZK3d0UdQ9dkiLn13hg7wJMlcegwUnfn7SE6BylgxLRB+dmlslGl/ZI0mK8w2J6jjqj4XPPF+01IY8CdGFzrnvtRVsf0E8klZbM6xVnEOUHiqHtSTOsqYl+O8R9IKTiw8tKTYhKel3wghKNs0VVWieBXbYEUzu3vRGv2QFbsRt9598ev08y3JXT5hAo9I+ip77jBIC33QRCe9eTG3ITiXaFT049Ii+aSy5rew+kzUhGqy4fQGfD0GoGGL3QT0zcJsSH3Gqzc6YX17NtUpDZHKjtI+XcYqnZSA4SOz22LOYQ97iWfjd2UUtLAcA5sq72dMOTpZmgg0lVMWU2xmp7IdE5mZl1ZTdcEHTJTI5g+uc8+tBA+5KFTFuc5vNgWdO4J1NwoxmplXuGFDBAnTEpu1bHcajYdQTr7UD2su3H0+hekjyZ634F7PAlM6dxOAZ6rJL/5TpWUfmN2FrVgJ8vafUiV2k0ik+3dZna9QZR5b
 Xic49x7h
 ERWNw8nP7c4md6CBeQFAh9cXRXavGTVv5xEpR48elb1ZafPJNV0p2A5EiOGIRu0ppCXLOdegXZ8HmxDLEpTEdsRV4MmPZ68ghMKI6EubeHwHVmwJOsWgbDrJo9OB4GJ4N1Uk0fbmoYaLkmb5/prUDDeeWt2VUUMz0TKgBC7VOj3Ky0EHKuu18C+qmNL2hiwlmxS8wJZz+cPJ2xY4BzF8cny897ORInHIn6AZ0WCoesYCFrIMD3UdwiQx/9pmIFpt5t8m2Zx9h12+JBkzP7iSm8m623RnKl36mqmMWpgGshhgFx69uvjCkeDI1jm6YmGonJjYYRlrOCGOEgPs59tu+6C9MINV2UDbrdnC1LPErDZh5dBmGysuxgdVDevbZIRbgfxQvBiihXqwHdd9qFTI6MSJYC/vPnBawis4aRXAySfekZwGsIkFUsLhuiUaciklDxQTWxPFfIiKS1wGQHtoD55DNxH0vhZdRwz3FTBDWFwXoJVQGKlKBUxEOpV0Ddti2cZNYUg1cy6A89kAGnmxLl0IsKLWiIAswBVLkwlrsfkVEl3r9aH6VAhfGfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:34:48PM +0100, Vlastimil Babka (SUSE) wrote:
> Johannes is a long-time expert and reviewer for the page allocator and
> has agreed to step up to a co-maintainer role, so do that. Thanks!
>
> Additionally, page allocator is joining the MM transition, following the
> MM core updates from David [1].
>
> Patches will be collected in the mm/page_alloc git tree and integrated
> via the mm/linux integration tree. To signify the change from Andrew's
> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
> on most patches via the catch-all MM entry. David prefers not being
> added for mail volume reasons.
>
> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Well deserved, congrats Johannes!

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b68bc3626709..d7cfb28a9029 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17720,15 +17720,15 @@ F:	include/uapi/linux/oom.h
>  F:	mm/oom_kill.c
>
>  MEMORY MANAGEMENT - PAGE ALLOCATOR
> -M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	Vlastimil Babka <vbabka@kernel.org>
> +M:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Suren Baghdasaryan <surenb@google.com>
>  R:	Michal Hocko <mhocko@suse.com>
>  R:	Brendan Jackman <brendan.jackman@linux.dev>
> -R:	Johannes Weiner <hannes@cmpxchg.org>
>  R:	Zi Yan <ziy@nvidia.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mm/page_alloc.git page_alloc/for-next
>  F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
>
> --
> 2.56.0
>

--
Cheers, Lorenzo

