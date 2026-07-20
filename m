Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3202C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 18:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D5C6B0088; Mon, 20 Jul 2026 14:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2EAB6B008A; Mon, 20 Jul 2026 14:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1B76B008C; Mon, 20 Jul 2026 14:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A55A6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:06:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED79D40275
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:06:30 +0000 (UTC)
X-FDA: 85009934940.25.576C653
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C2D91A000E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:06:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWCsFkTE;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784570789;
	b=vvqFCoSHMm/RNL4tu7HyOCf6w/qAUpseGmmGHLNxBwjYh0ufXh/vxJsbrTPtAgO9VmJ+ld
	PAFRVg92wi0sLhgHMDf+wqJf53jfJVorXE5JtXVLYzCP/Khznkx0cXH7ilybrwiDo1Gx/n
	7ALC5LBwZhMF6E28hUrqc9+QilRhg6Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LWCsFkTE;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784570789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEo3+xzXNoxQF5Zig+V0NoDPZCD01sZ6pyJ78+EGJ+0=;
	b=5kyk070rMY8nDKxe/a2PrUSrKvZldUz/LHFUeMPJjh3Ze7zaD637aS2L2/EJNe2Va19lE3
	9B3pBeCkzcf1O94CjwhDv+hDq5IGI/awRP05JfEdKJFzGuf07fZtYtA0/MqajbbDJ2ERi6
	kiegGLjOLxAojLhqTz9ICcIejn2KhG0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0AC942AF0;
	Mon, 20 Jul 2026 18:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911531F000E9;
	Mon, 20 Jul 2026 18:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784570787;
	bh=nEo3+xzXNoxQF5Zig+V0NoDPZCD01sZ6pyJ78+EGJ+0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LWCsFkTEe2OBn0UC3TwLqYcQX9t2MqAXgzNK1HNURCRtMzAV0HvFWVmWE4QnLZq8I
	 77NfimYhx/SdrdkOIWn1XvLSeXpzwwoX6z3oeNrjYM+9L79e2rDY/lwxW3p9tQYGmR
	 DGiEpe70W3aTc6Mcyb6TijUkQE1sKRFdDWQrCQu21oa1oXLdepN+yLcxCv/ohKqOh4
	 bxYSpmkqUoYNXQrTtNRzjQy2kWMYmzF/kpbinI6Hy0CN3SylovUFkrpuHlBjjPikDT
	 Bs16j0jXkWPgT1Yirf+19hnZQ4xI2zsiA63GuuKbTMfezxOcF1dWOl4jfRFwEK33Fb
	 MgjU/6+xx8sOA==
Message-ID: <bf839033-3955-4f2f-b33f-3fa948b2c2de@kernel.org>
Date: Mon, 20 Jul 2026 20:06:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>,
 Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>,
 Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>,
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev,
 loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C2D91A000E
X-Stat-Signature: tyryszj6t1kme1wwntm17c4phx3xq3se
X-Rspam-User: 
X-HE-Tag: 1784570788-293667
X-HE-Meta: U2FsdGVkX1/AfmNKJREadgSip1TxLdM5YUJyBH2NmNGHdWTjYWp3rjDMf8VOLdhZ1U2Jx8LMdaEw5WlqR9sf7PDl//WGYkXrQNuQGrNKgRbUgKXzMjFpSD9bLTKI13jmiZWVParcmEofYuKcYAtBf4LNQwUaeExdInMlrCFkC6O+zYkEQ70z0x+NwNezEZUNp+H31cp+nQLbGyBUEpd4brwqJcli+DGobzy3zTjfk+lx0qo5FVv4RP5nBH1hD77pbuQS7sXK0yt6o20krp+O0M8obxDnzNW0eOUapeUO+i9Y3q35+JuzC8xSm5gRZZfsigY8vy/oBkS3fmL71e3/MqZpqgHTO719nYf3rLHeHhFJYwpUy1ECt5+dkh7B86GP7AcojyfaNcLVYT2ez+uvj6glDRIOvIoE1AqFkcZG+YtJ/5N1zqAhcEri49qTDfwFF7wXfUN0/xkZBWLutu66VSv7rfgjdOyXFQj6+sXTli3gMtXNKcx3mirx9n2BuBwTH8kngxtVnY+DpgjRNeyGamCkS+5e4NRFsy766bzE1G8EH7gmMcJv5PzGnPkbAGsKeDNgLEUUOc33tUpHc3EVmrMFkQrbjZ9z7UshtT2CuqXw6Xly8o8ffWh1P6H/Xcg+BxlFcN1+Y6Ck3voHT6b/mjYRTHcM4P1yhKoBxHsm+0nH/cHoLLjOM1mNeQDUaj4XqoRAwmDinvMynEijjL0lmk1UjaZ0KUhgEf1orEEJu799kN7kobZUwig4jR/3tsJJu4v1HiVLs0bXJygEqRTrNkNvzbHttTPSKuZgDSszvjjIpPuFMB+6szcr7h+9HzKA/rZ8XT0g1inlgi/Ya97XUBx/RB3rxwBAjXNDEL+jtrEuEehFzkLr45UVOfDRfpHvcvq4ZM2IXLdOeg3/Rm/kDIY5DncV+5iNSjn0bTvXsK2fm5iLKPUWvFbcyO694yqS/iIf2WxTkgenWps1giO
 YumbVOmj
 e63qh23oIMh7VTizK/hCSachqWe+Yl7kUJwWaTuRZGFQpoHa4lVEpaunDmXJ/vjUyYvuMG+7a0hRoTsfhxEQomfFfRWX3XYLfwJUyRotmUPYVpRH+gYXqrTO5GMeYwfBVwVtP2USgnp5i7i8yPQ6jojxl2didBsngldGk3G9+5mF5vqM3bl45W8utxTU2DCrBI1csSciyXJLmhj5V3bNfUkOU45wO9aOsmmyUKyRx7UvDLUfY9pJ5jsIemPKPsJP3BRhwUyoGnttIvs7m1gJoNL/qvn7FbXDsMX1ZRoaMfME7ECxc82a6+EtcH34sEghvoj028vOi4gQML0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/16/26 16:30, Brendan Jackman wrote:
> +++ b/mm/mempolicy.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * mm-internal API for mempolicy.c. Public API lives in
> + * include/linux/mempolicy.h.
> + */
> +#ifndef __MM_MEMPOLICY_H
> +#define __MM_MEMPOLICY_H
> +
> +#include <linux/gfp.h>
> +#include <linux/mempolicy.h>
> +
> +#ifdef CONFIG_NUMA
> +struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> +		struct mempolicy *mpol, pgoff_t ilx, int nid);
> +#else
> +static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> +		struct mempolicy *mpol, pgoff_t ilx, int nid)
> +{
> +	return folio_alloc_noprof(gfp, order);
> +}
> +#endif
> +
> +#define folio_alloc_mpol(...)			alloc_hooks(folio_alloc_mpol_noprof(__VA_ARGS__))
> +
> +unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
> +				unsigned long nr_pages,
> +				struct page **page_array);
> +#define  alloc_pages_bulk_mempolicy(...)				\
> +	alloc_hooks(alloc_pages_bulk_mempolicy_noprof(__VA_ARGS__))

BTW, seems you forgot to delete this bulk stuff from gfp.h?

> +
> +#endif /* __MM_MEMPOLICY_H */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5071177059a96..69f561332bb93 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -41,6 +41,7 @@
>  #include <linux/swapfile.h>
>  #include <linux/iversion.h>
>  #include <linux/unicode.h>
> +#include "mempolicy.h"
>  #include "swap.h"
>  
>  static struct vfsmount *shm_mnt __ro_after_init;
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 5be825911e645..8ccd03c39a407 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -24,6 +24,7 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/sysctl.h>
>  #include "internal.h"
> +#include "mempolicy.h"
>  #include "swap_table.h"
>  #include "swap.h"
>  
> 


