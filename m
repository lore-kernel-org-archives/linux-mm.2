Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AC0EFD3773
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813576B00AB; Wed, 25 Feb 2026 11:56:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EAD46B00AC; Wed, 25 Feb 2026 11:56:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2B16B00AD; Wed, 25 Feb 2026 11:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58A726B00AB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:56:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04881BA8ED
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:56:14 +0000 (UTC)
X-FDA: 84483581910.22.74739AB
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id A9CBA40006
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:56:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FFPwNoyo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772038573; a=rsa-sha256;
	cv=none;
	b=fNaQVzyR5GzwKXgtBwIVsUZGW3ICdwsrQvFKk+YU4z4EoAmQGxHmoDheJuk9HYv4Rt3zan
	vJnaTjZRG3W6TmN0RHPsSmLiNWC9YAxm73pqUQdBgt4VMOQMXKVVsqpV5p+Cxj+3WEXX9g
	4URjiqSz3pHgG59POvDXJPErpe6w1RA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FFPwNoyo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772038573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rwb9ZB8iGf8KTJOkEtuivHllAa1gLbstzaN/aCan+o=;
	b=K4+QAbRcC7KxKsTOXRk9ZyTTcs7UFWJmN3mK5JG0mnWHtkayUSJAb7Xenh3jAfD6X9/K4W
	/H0On8K5IKakZJUM9Mu1rlB41n/BW3IGK0RezZW0BkTIX8wtS/BEzRaxVxwe6ZvQuoc+eC
	thWups7WRu6jL1zYKLAh3sWLN2wQWfE=
Date: Wed, 25 Feb 2026 08:55:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772038568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1rwb9ZB8iGf8KTJOkEtuivHllAa1gLbstzaN/aCan+o=;
	b=FFPwNoyoqhV82NnpPDbeYKTGPtM2BEZYDwDRl9XwLldIas6KaJOPbCxZAWeYKabMotZwEG
	YcWJ1zYO82FLrAybyYRppCNSXKZdhfch59fw6UcHsMn8vYcRj57HH5icCTV0+knmO0xEQW
	HBXz3CfPvyML+adagDnokYNS5V2LbAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>
Subject: Re: [PATCH 3/3] ptdesc: Account page tables to memcgs again
Message-ID: <aZ8oT-n4a8VDY2AH@linux.dev>
References: <20260225162319.315281-1-willy@infradead.org>
 <20260225162319.315281-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225162319.315281-4-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A9CBA40006
X-Stat-Signature: qob7nccj1h89ysbz89wrud8t6a79z3m7
X-HE-Tag: 1772038572-187003
X-HE-Meta: U2FsdGVkX1+QahGH3iD6A9gVGWte4B5di5544gS5cBd4MGqWgnzkkwj8H/iGNUjFOiwdnNksv3LZWBfyV2byKsMYM3Xfl0wYG/Ddqze00aBDdz+4OuVR5CrtXfiAG4dBJvWA+u73+BFPcy3uQ5aFYjFl/7oHgaBvc/ONMNo1M/Vc3atr05PIwmDPqYgGJAjjxije1AwCFOmLj2B00DmHp3XwWSBn+7S1UDzZ800jJ23SCDx3IwoGk7jO0MULFLPM4G3rnGWGVmVlMrS8n/N8EQfeU2ZQ6e43bL3yWMxNXNV+4YZbvA98Asbx1h63BHy0ZzAA0nlftNTMjEx8dhu7x4TkCFq6fsEe8kbbn3djOO/xigLH3Km8/IP9Vi309bPOSIC7dTSAi/sP376fgdLYxNLdfj7xUWaO6XckNA2t3BptblYMmp1hxeAHXvPjCLDAK59KmnUkDo7CiCATjSDUiKyBp2Wlf5SckOGCkjyTYV8JRR/5+SaRpx3QYpma2Qp0wKKEV+c30vYOSEjgqBi+7cofO/sWO7RSRuLL7PSZNuY219Mx46DsXoB57CyYD6gtluSahOnswIBbCBXxMykPP+87J26GiJqO0F6hYZwygsANA7fC+Yeg3GI116KCVgtrX/7wJ9FULRiybxhCy+V/VSJ22uqPn1S7gFBK4ckjqIFpb+YhZB3vAKJAvO0OSnv+mVqo0x9Buz3u0uWoZGZj9vC4zKxwZKddEk8B5eWBVLWrGYHJuh/X4wlvgxaQ0B1YuLn1RynP3BOdXlR/10+FpYFVh40F01MxuscqBHRZYVGzptO/sc/sAC1t76qM6m39ARUdY5NbC5DIepJqGddPdY4qIAMy/d1I1iIgVIYul+t5BkWcVaz6V0MVHopmqkaxZJAWpnILiozXFtxEqyUTZ/E8uIQFt8b8b0l4kxjh5daELDET3Sn8i9hezF/3vHkoS9B9SjnrDBS+0yeoudw
 ZcV0RXXI
 BxSJ99lvS8qjPmrKdQbVH3USwLDBYr493jWezslwTfW/l0JUcfkLre1YE7f+z/RFPkuXQ4oqxmWys14l/qkCN8m5bBDAHDmnGy/UlZVA1RC20KGlxOKFOqtt+O7YTzPBOY2jorDw/yfPXjjw6eV5qNLveABYyW904Nfu4un2Hgfw9XNCf6FEom86MrfoltCA9g6iBgXE2tqUbibfOewlXi3g/Jx7VadMRvJ2q6r75FU2TTcRF7QtrB2MGlwF/0jdbdDD8ThPkMDXIsL3CM9D02TjrrExe2mFmLwLk+iT/SQ+WleiroqMZkDsReRDN9WWeVtpt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:22:17PM +0000, Matthew Wilcox (Oracle) wrote:
> Commit f0c92726e89f removed the accounting of page tables to memcgs.
> Reintroduce it.
> 
> Fixes: f0c92726e89f (ptdesc: remove references to folios from __pagetable_ctor() and pagetable_dtor())
> Reported-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/mm.h       | 15 +++++++++++++--
>  include/linux/mm_types.h |  6 +++---
>  2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5be3d8a8f806..34bc6f00ed7b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3519,21 +3519,32 @@ static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
>  	return compound_nr(ptdesc_page(ptdesc));
>  }
>  
> +static inline struct mem_cgroup *pagetable_memcg(const struct ptdesc *ptdesc)
> +{
> +#ifdef CONFIG_MEMCG
> +	return ptdesc->pt_memcg;
> +#else
> +	return NULL;
> +#endif
> +}
> +
>  static inline void __pagetable_ctor(struct ptdesc *ptdesc)
>  {
>  	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> +	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
>  
>  	__SetPageTable(ptdesc_page(ptdesc));
> -	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
> +	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
>  }
>  
>  static inline void pagetable_dtor(struct ptdesc *ptdesc)
>  {
>  	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
> +	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
>  
>  	ptlock_free(ptdesc);
>  	__ClearPageTable(ptdesc_page(ptdesc));
> -	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
> +	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
>  }
>  
>  static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 3cc8ae722886..e9b1da04938a 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -564,7 +564,7 @@ FOLIO_MATCH(compound_head, _head_3);
>   * @ptl:              Lock for the page table.
>   * @__page_type:      Same as page->page_type. Unused for page tables.
>   * @__page_refcount:  Same as page refcount.
> - * @pt_memcg_data:    Memcg data. Tracked for page tables here.
> + * @pt_memcg:         Memcg that this page table belongs to.
>   *
>   * This struct overlays struct page for now. Do not modify without a good
>   * understanding of the issues.
> @@ -602,7 +602,7 @@ struct ptdesc {
>  	unsigned int __page_type;
>  	atomic_t __page_refcount;
>  #ifdef CONFIG_MEMCG
> -	unsigned long pt_memcg_data;
> +	struct mem_cgroup *pt_memcg;

This is kernel memory, so this would be struct obj_cgroup * instead of struct
mem_cgroup pointer. We will need something similar to __folio_objcg(), maybe
__ptdesc_objcg() and then call obj_cgroup_memcg() on it. Basically how
folio_memcg() handles the kernel memory.


