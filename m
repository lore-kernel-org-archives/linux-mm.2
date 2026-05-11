Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B50D6CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 15:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29ECB6B00AA; Mon, 11 May 2026 11:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274AD6B00D9; Mon, 11 May 2026 11:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18AB46B00DA; Mon, 11 May 2026 11:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD036B00AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:37:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDE081C0098
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:37:43 +0000 (UTC)
X-FDA: 84755544006.21.C9A59E9
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id D86DA180004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 15:37:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h8H5Rfbb;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778513861; a=rsa-sha256;
	cv=none;
	b=ZgXwch9KkNltbLrQs/6Rk5zTkBXQvnsv0rKsxLWTogs0hYmJJfdY46hQGgjVS3oykMZaVw
	r5Xnfxgpcl84vaHCU+85WgSLW8ixe8FVPwtHASQUo3EmdkJAyB1Gf2aKzgdnROGbeyqwui
	HH4++Cuig8usaAduyttdN+r18Ztfg1M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h8H5Rfbb;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.44 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778513861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4o7InZBqCk+7loPCj3VNzWtQgfmKxcMnRJsXC1AWBtY=;
	b=plygIWjR2PSm/8ZSNFIHoFznSqvjOS0a9J2GNAwpobKzCvNtxCcNGKyj40uVy15ofUFz1f
	Rxa3+9iiJrbbvM8djWn+fLAdkZ3KgdMyTllKZFeDW/rIc88F13vPvdkBI+I+T6XPi2zy3k
	s7Kz/gyf1j1i6xyyoNSFVQtJ8UCgh68=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-6314287380bso1937038137.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 08:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778513861; x=1779118661; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4o7InZBqCk+7loPCj3VNzWtQgfmKxcMnRJsXC1AWBtY=;
        b=h8H5RfbbgzfIZl+CUyN+VHcJ75zD53yz494Eqg4M5XzwnuA77eR8Whe/y6tXwk3nZI
         ItS1POrKToEFgDvMu1YzgTDnYfevwx5rUGWWd6WFdmkU8LWZ9bc0Yd9plCJ19ebeQbQH
         8YpAfs5rUAZBSg9cZV/E6wcH0SZvHoXlHOo2fWdKk8UecU//u6NbHRM5RSdr5I3suKnU
         IAB1f62p4QeS0gChkwdXpuvlfd674N/43ZWGdok9I1qfEiZFv/mzPityleg++jBc+RrP
         CnzSY+7k2cA++kAdE11np/4XD8bLoURKNub3rlcFWKnaPNKrvor+sMhEv/F2s+q3t6oI
         aNMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778513861; x=1779118661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4o7InZBqCk+7loPCj3VNzWtQgfmKxcMnRJsXC1AWBtY=;
        b=fewizglp17x6RzyT+BlQ0/Ubt0PMB8iiAV0oF6R/8UQbFl7m+nVY5JovbR53lyAXTy
         nvVuRBD4fHkYN83ZVbkg4qMIEEoj+uQBIWpR4hfEaBUbeJWDD4v5J8YuQz98yAK1jB3c
         uqf8018Xe8a3c7JI4qKa3OmWqfSTVJQnGmSHPOCBzcvubUi6UuTfHE6MlpNubhQt7rk/
         6OCIhVes3jwGux1SAdDubL7gyjFh7r2QsYzDvWHnenwqQsRBFIVmSKDisNolOvTuoibj
         iocQ64fbOixADJrvi5ZP1OW9HnqYPOFMFc41tPKcnt19NIN4PPA3Fsr+TBOV+BdjgWco
         p2dw==
X-Forwarded-Encrypted: i=1; AFNElJ+H/QiQNC98+EM4aAVX6nrCiLvCQYN8gOFG5Ea78elLAMT9FH5Yawr4QCViXBVFdILel0Cy0hL3aw==@kvack.org
X-Gm-Message-State: AOJu0YweQMm9j5R6CxMzZ1yWMC1O8xMYhMed9BM4v94gMNDeOZmxs0oC
	SaggXsaNk1cn3lJ2k0XFNE2ZEphafidILjrDaor6FFGWxU/CIEEhkSFfALDvt/u34tU=
X-Gm-Gg: Acq92OFe47RzWzg0Txpw0wimoNLk15zvRAwZzWMhbx+1qEQsHR+l1YbqQECn+WTRd5D
	4Z7Ev6sl0XUGGm6Eq1py9seaNZjAEimxIIpO44S/6rFapy7Ok9PpyaV5FSrg03EWILvZwj1Dmrt
	MLNrlvrh4FRvZEiXL4oCC7IuySxRKWIKlcBh4LDfBztrhJVlUt007cYMgkzt9Iwzcb4Y9e3BpQh
	6QqDVk1phhy4boeZG2O1srgUVNU+zXahiPM1vTdVLnWLnxuSnCycqAeiFh0CQ8Ppd0qj816su33
	bS9/ULNGZPNwnn9YxmgRGHH3i+x5W0z6JiTD3izkS8Qsmy8kVCAIOumefN8uAow9hGZQSlWtnpB
	q8XpMoTEAiN4y5eCgoNfE8q9ZJgyMSH3YKro4eQnjNvUC698Ia5nXpDn97RnZF92Pv8c3CXyhJC
	GFSXuDREZHimsJFwZ4pe329aqHQIJ2rxjQ4l6W2y7N7hZ82EoDtEzzIBDcO5ZLVig/T4bNQjWme
	3Y/578OuQzJcTVB67nfgnE=
X-Received: by 2002:a05:6102:5a85:b0:633:4d1a:65e4 with SMTP id ada2fe7eead31-6334d29b73amr3014460137.12.1778513860817;
        Mon, 11 May 2026 08:37:40 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8bf39c81b1csm97160166d6.28.2026.05.11.08.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 08:37:40 -0700 (PDT)
Date: Mon, 11 May 2026 11:37:37 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
X-Stat-Signature: f44buqnr5zafiwxbeid1wuqqut6qom8i
X-Rspam-User: 
X-Rspamd-Queue-Id: D86DA180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1778513861-954989
X-HE-Meta: U2FsdGVkX19jkB8nhWLOBoXiaRMWvejxiwumLByHQhUZ2Y0mP+PkZkXIUnUo9+743mtWvyvvytK9i+9MepMcDsxO41hcD5RitLli53l6E/iif7CD0nC9jJvw+Kv9iz9+nj244CqMXn4UVMCOZ9WD76ANP1NgmCtJCyzz6xAfb+VBF0Pj2DmTnXqi2a1W3e4e4+dWoJ7LrfX1BClpcXqKyco1YjYNZvZFRCUTgtMneDeaQu4JLQCxOSnQD4iG7jnSeUHBMocIqEZ9EwBm9SJBYkOQrKYW6tXiK34ckAqH/c65jqJHClxaTT+iewMLdjKPRmK9Onbq+HHNtSbGCfGKyzN3GJi2hIK6vlZCHZl76Ka/C1Oxwka7dFuPlC5DjaFg+hp5RTBjG89hq9td+sE/rGTN7miMaVTtKIoF4B02dVpj0NoxtqcLQzHHRvr3ODRCm459sd9cc1USxHGQNg+LqZRLcUasbYlbQJmOjiTDic57yzpSqC/UW8H2bIfQ4+J+RAhzYzTyDjgnUfvGYfR6WSX+eO15qcdqCsgpr2tn/IT9HoBtgBJJnlr7DPJ9EuRIFfac8B/Z+CXcU8dSdfbi9/JCIlpXPMkhG43vas8/lFcG0g0cnvFktYqbpcMWzIMg2VNbdxoMfsHI/N2prqtxP8RH2lPZB8rQrKb9SEVpvtvQ4PVdaIqHRTTBlcA52e2HIICoEiWUG1oCDIRF8K9RHJtUGmga7cNFcXjbh+uw2A01AbEHc7kCsmcfsQVbZZCCod8CmWNgiOR5X9DjgJXReKlBdwTFObFnDj2GBozrBygejrHocfrnNyKQU1Wpzum16RUwGa3dHmgYaLktgDQ0IfoprLkLPOmoyyHgPIWJ0O0UVrWgzP8U6VRNpJPBC0vf6e0hfeabWXQfxZ87I/Bp6RFaEP/KeCt5AonSGwaVxcp/iFuO3LnGAORPr1gLO9C0vKewBx8sj9uNDnfXasH
 Tq/oTQwa
 VOq9cLjdigGwcEWOFEABBKHJBGXmizz8hJwJNX+g7GCl+t7WTsolBv1oXUvWqqJEbIboH++iGW41pmwooPzQC9gsneYN+/nEmdHR7D71qv0RUD/KIyCphvlVgbJw0+vZY4SkYKepxNRteawPvyAYn1gNXrKUSItFk9EtzEe80piTEuNx8YgzP5TX/G6bN5tLXR7jqMFP5kXKENWSnxuXz/A49XX2iAzWZMOzqQmnLA1whzWcpm5xHSc76O0yncp52AKmNtF72HTGYqBe8Fr+pz9CYKiA+dBd0SYWNFsubrraNSK2eUUAEfpaiJtOkaAaQplc2eO7u7xjOJc+UO3M+ai78Njmm7CwH0z8THmYXej/q3ObsXTWfnD8xEooUdrMCgqI0SB5cmelp6Os63UfsfxZ98x0CPMWY/sj6+MrkElId/H6uOkDQ/xLERFPsvFCkVmuQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> Thread a user virtual address from vma_alloc_folio() down through
> the page allocator to post_alloc_hook(). This is plumbing
> preparation for a subsequent patch that will use user_addr to
> call folio_zero_user() for cache-friendly zeroing of user pages.
> 
> The user_addr is stored in struct alloc_context and flows through:
>   vma_alloc_folio -> folio_alloc_mpol -> __alloc_pages_mpol ->
>   __alloc_frozen_pages -> get_page_from_freelist -> prep_new_page ->
>   post_alloc_hook

This is the nitty-est of all nits, but when doing this can we please
prefer stack style?

  vma_alloc_folio 
    folio_alloc_mpol 
      __alloc_pages_mpol 
        __alloc_frozen_pages 
          get_page_from_freelist 
            prep_new_page 
              post_alloc_hook

Claude has a bad habit of writing changelog changes this way, and it's
painful for a human to try to read.

> 
> USER_ADDR_NONE ((unsigned long)-1) is used for non-user
> allocations, since address 0 is a valid userspace mapping.
> 

> +/*
> + * Sentinel for user_addr: indicates a non-user allocation.
> + * Cannot use 0 because address 0 is a valid userspace mapping.
> + */
> +#define USER_ADDR_NONE	((unsigned long)-1)

Ehm, hm.  Does -1 hold as a non-user address across all architectures?

What about in linear addressing / no VM mode?

> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 7ccbda35b9ad..ee35c5367abc 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -337,7 +337,7 @@ static inline struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
>  static inline struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>  		struct mempolicy *mpol, pgoff_t ilx, int nid)
>  {
> -	return folio_alloc_noprof(gfp, order);
> +	return __folio_alloc_noprof(gfp, order, numa_node_id(), NULL);
>  }
>  #endif
>  

This change seems out of place unless i'm missing something.


> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be047..a999f3ead852 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1806,7 +1806,8 @@ struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
>  }
>  
>  static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
> -		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry)
> +		int nid, nodemask_t *nmask, nodemask_t *node_alloc_noretry,
> +		unsigned long addr)

                       user_addr?  uaddr?

> @@ -1823,7 +1824,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>  	if (alloc_try_hard)
>  		gfp_mask |= __GFP_RETRY_MAYFAIL;
>  
> -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> +	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask, addr);

Not on you, but the changes in hugetlb.c as a whole are :[

We do all of this to pass USER_ADDR_NONE all over the place, but the
alternative is having a separate function specifically for user-land
bound allocations.

So the trade off is:
   a) churn the current interface for everyone
   b) add a user_ variant and know people will just get it wrong

IIRC you said the consequence of getting wrong here is subtle corruption
if a caller got it wrong, and this was related to cache flushing for the
provided user address?

Stupid question: Does this not apply to kernel allocations as well? Or
is it simply a matter of the cache having stale data that could leak,
and therefore it's not a concern in-kernel?

~Gregory

