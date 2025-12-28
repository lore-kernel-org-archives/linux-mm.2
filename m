Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4F3D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 21:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38AE6B0089; Sun, 28 Dec 2025 16:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E28D6B008A; Sun, 28 Dec 2025 16:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90FD06B008C; Sun, 28 Dec 2025 16:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 804F16B0089
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 16:01:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3802F1A010F
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:01:36 +0000 (UTC)
X-FDA: 84270100992.12.88021B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 58FBC40018
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 21:01:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFWZMLhh;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766955694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mLN4jy8raEgHuh738HphvOpBbQlCM4mbdVw99D6NfM=;
	b=4mGl0x3xeKdCYiJj4vDTnq+hFg8kkkg64MDj32FW+D9FKKX/ybGVvK21ARtoHzSJhlkPgE
	w56GhK+8jCzxXhFqYQTZUGsujexva5qoOAD8HzS9J9RKo92qU7/RAMhUMjspYJ17qWpn6p
	ZESm2ySFs6rDs57sTP5Z5Pigs/7wMb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFWZMLhh;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766955694; a=rsa-sha256;
	cv=none;
	b=wt/lhyKAWsh2V/7IMbzw26DucyoPc6rjqGrB/pUqz/InhsCkXK9l/4Zp+EsW8+ewm/BS9b
	qKfqFwyPWj+wSjiXD4TMytVhv3Dv4oyCJOkXONckydfrawC8j91E9YGFD4uQj9po5Ay73Z
	shVDh4fUJL/aGng5abPs5YfoX5xF5pg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6563543FAB;
	Sun, 28 Dec 2025 21:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9092CC4CEFB;
	Sun, 28 Dec 2025 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766955693;
	bh=E40TfozfMTRWLVhTkV2adBCHelIThaQvQ1777er0xX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bFWZMLhhI3RJJiSLADl8BpMm0BnLpwhbEOOJBd3TJEaErP26PcymDPdJB8E0wNQGX
	 LQri8Y9MhXUjljPf8CBpX8MYh0c305UBBWQaKV/8DNAk0siTJYEH5X5l/qa4PuAB4J
	 g3Ywaj8l911WWFB9uSVchXMVdsIOLCgQUjy4vv8kN/EOHlg1NGKb3AQUcim4Kq54s8
	 hBRaWcdK0VCiBVDWTtafozyrIn+fbNeuJxqZDC8kjakUY2n9h4AqMwjg42eOCxiRdZ
	 zQSGSrm9UG+tKzprdCJgRPZbV2//qkUbJ4jtY/WivRUzbqP4nQlVvubZ//5oP32m1I
	 xgF1E7r3+kc7Q==
Date: Sun, 28 Dec 2025 23:01:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <aVGao3KAyKxXrIo6@kernel.org>
References: <20251219115812.65855-1-pilgrimtao@gmail.com>
 <20251219115812.65855-2-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219115812.65855-2-pilgrimtao@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 58FBC40018
X-Stat-Signature: ya9zdomdgkfsddsi84kaznukrytynixp
X-Rspam-User: 
X-HE-Tag: 1766955694-999732
X-HE-Meta: U2FsdGVkX1/RbwDitCS+KzdytWvJHRdhYCIkq6+jDnDsGXKVfHy1cVNehBrmZ8ZCalOXimyp/B5jJA3fOfCxAeGQTb+Zw0hLB7xFVxVV4QTkSQW1/JK2JbOVBFaubrW6exP5VqCI81C5f10k2s6Kr+mP8x2G+fgP3hbxpZq/DpWYamDmBA2cN0gz7py+bOYC0CMZU4rGOHQsp602ZeM23x7pUlALkMZxg7VsZtphnK/dmEn33wdPUAaaZXue+eMqBveFSONYTyO+7J/l+PP7cC+EZG1Wmf/tYoTC7XZuq2uEWn1Wv+fPe8ONZfxwwxtkMPP/Siyvayv6yzTVAU2pp9toUQ29guoamy9Tdkzp87R0uKtU3Ph6wUshgUOBchhxL3bLT0fg5DD7OB15xT89959O80EnAmMtm0WdhtIU9ZqzOCqHzxcFJNAfnp4Ym9Vo+4pTnsz9VEcpyQYfTYC4tVhzIzHDZxj4eInuiQV1gtMKZZaJlOSGFVOm6ZZxKytEXg+Qs+JbgrpRBnMDAY4x2+YBZOm7K94PHwFrqCvRVnVO2R+YQxhzdDsJKeX9OAqI+vSpEicHm+DEnDYNCrfOgX84UOtnw2/mEyhOruUXc2R/pUsTd4UXxn5TJw0l5lv0MfC412UTFv0TKVlqlLex+7lwWXJ3qzyMcj3GBI4bOEGFUWPER+dP9l2LglZugMlaabh9klHFkFCjjC4Ff8qsHDBocxNqSM247cgCVtCi2wA+YUVpeUBbvR9Oo19RaA8VNIt6MeaPSjBIuSlD1gniH1jB23vsmlUa3BeGgLAAaa/a6UCKaBSmm8T26Ak+QZ0lASZW9yEeadj8XS8L49/9l8WMgcgSlfojCVzrXayydfIIL1+FKO35de+WBMCjd8Idry+eWkWYuJefN7q6KxzIgI2i9/M6w2N4V6hPBLBWE6ZJIi8OxIbIkbDyQQVQKMGWN6yy5J+2GS/gOeXjmPF
 xp+V8pQ5
 f8SISTEcH2ibfSHOZlXQZuqDqswJ5Nk2mNq407zuWZm8IAkjSriq2CZXe/apX1WEs8w+G704E4V94tGHUHBJIiktHzf36TFUb7lmB1M13i2ZigJbepPx6jTKeorYZv6KhHhvfh3d5/FfQv41HdWe1W1h0ShnL0OsBCt2aDS5HzrrtNUaHq95jL1EUnpEQNgAsIwUZAeRwammMRiNvuh0YWbRxREnqmXzNEZELjPSqb3eOJRUSWqH4TFTvqUruz21lAw+pKPniioHGnWapNQL6jSXf3OfHBirqYlGzvhBTf56bYT21seBpBHexUib+wtjZtdFNw/Lam1S6PVscIeFsPToS0Cg23+qyG52IyymMgHi9c/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 07:58:10PM +0800, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.
> 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> when vmemmap_alloc_block returns NULL.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/sparc/mm/init_64.c | 47 ++++++++++++++---------------------------
>  1 file changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index df9f7c444c39..858eaa6615ea 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>  EXPORT_SYMBOL(_PAGE_CACHE);
>  
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> -			       int node, struct vmem_altmap *altmap)
> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> +			       unsigned long addr, unsigned long next)
>  {
>  	unsigned long pte_base;
>  
> @@ -2595,39 +2595,24 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>  
>  	pte_base |= _PAGE_PMD_HUGE;
>  
> -	vstart = vstart & PMD_MASK;
> -	vend = ALIGN(vend, PMD_SIZE);
> -	for (; vstart < vend; vstart += PMD_SIZE) {
> -		pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
> -		unsigned long pte;
> -		p4d_t *p4d;
> -		pud_t *pud;
> -		pmd_t *pmd;
> -
> -		if (!pgd)
> -			return -ENOMEM;
> -
> -		p4d = vmemmap_p4d_populate(pgd, vstart, node);
> -		if (!p4d)
> -			return -ENOMEM;
> -
> -		pud = vmemmap_pud_populate(p4d, vstart, node);
> -		if (!pud)
> -			return -ENOMEM;
> +	pmd_val(*pmd) = pte_base | __pa(p);
> +}
>  
> -		pmd = pmd_offset(pud, vstart);
> -		pte = pmd_val(*pmd);
> -		if (!(pte & _PAGE_VALID)) {
> -			void *block = vmemmap_alloc_block(PMD_SIZE, node);
> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> +				unsigned long addr, unsigned long next)
> +{
> +	int large = pmd_leaf(*pmdp);
>  
> -			if (!block)
> -				return -ENOMEM;
> +	if (large)
> +		vmemmap_verify((pte_t *)pmdp, node, addr, next);
>  
> -			pmd_val(*pmd) = pte_base | __pa(block);
> -		}
> -	}
> +	return large;
> +}
>  
> -	return 0;
> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> +			       int node, struct vmem_altmap *altmap)
> +{
> +	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
>  }
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Sincerely yours,
Mike.

