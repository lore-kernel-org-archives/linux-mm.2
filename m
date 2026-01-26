Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE545D13C29
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 14:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E958C6B0088; Mon, 26 Jan 2026 09:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43CD6B0089; Mon, 26 Jan 2026 09:50:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F6F6B008A; Mon, 26 Jan 2026 09:50:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C55E06B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 09:50:39 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E44B1607D2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:50:39 +0000 (UTC)
X-FDA: 84374401398.11.799CFBD
Received: from smtp-out3.simply.com (smtp-out3.simply.com [94.231.106.210])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F80C80014
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:50:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=D8+GIGWK;
	spf=pass (imf02.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769439037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARP0Pw/Fo5FtnRzlhI9dsRF360HgZtwUjmen8yDukTk=;
	b=2SFi+vFzXjdyLDDH8eiGK9EsDhnM6Rw0dTG0+0jnA7uY92XhqKE8Ife8VN2s2DdQEiQ1Ta
	yG+Uf56ObrBfnjWzpE7OKyb0huTjwcwy1bPif7vp/evhVWQxA+lgqC9sxC6zrPsK/KNODn
	JqVAtq7ksCxHURixEjN92q80tK5AWKU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769439037; a=rsa-sha256;
	cv=none;
	b=pFubQfEvPvys6IFWfxg1HlJ8Fi29/i435R/WLCbMrwsSZC2/0wOFsWtptyuSQ6OtaGtXbU
	pgXsaHJNu4iOIRZn2Z4hpv4x4jvpH8Niqx1dWclzgo4d2bVbUMonVUiDw+g3Ran0jY/Q4p
	/O9mX77ZNye+dk1DL3vc8LSkx7Jh0ME=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none ("invalid DKIM record") header.d=gaisler.com header.s=simplycom2 header.b=D8+GIGWK;
	spf=pass (imf02.hostedemail.com: domain of andreas@gaisler.com designates 94.231.106.210 as permitted sender) smtp.mailfrom=andreas@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com
Received: from localhost (localhost [127.0.0.1])
	by smtp.simply.com (Simply.com) with ESMTP id 4f0BKl5YR7z1DPk2;
	Mon, 26 Jan 2026 15:50:35 +0100 (CET)
Received: from [10.10.15.30] (h-98-128-223-123.NA.cust.bahnhof.se [98.128.223.123])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by smtp.simply.com (Simply.com) with ESMTPSA id 4f0BKk6h2Fz1DDV2;
	Mon, 26 Jan 2026 15:50:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
	s=simplycom2; t=1769439035;
	bh=ARP0Pw/Fo5FtnRzlhI9dsRF360HgZtwUjmen8yDukTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D8+GIGWKbpOYGKqPOqVI+1SKk+U1HacWqBBdSlIWTlvf+ZpgAe7caqNNkYbV4pLHJ
	 NbbLeq7u3X2qDdnwgtask4C9cOxmPGV3oH3cnb/NXmRfPDug4rzXS+ur1sgJyYHG+H
	 XQgiYcE9WXsaObs2wL9UsNFqibjRxQ0UnoJKA0RDyJyEvLb3ytcizSFESPplkfE7rn
	 WnXbg0p3S8ll1Chxrf2fxvqshC/osR2PIfU5BpkILcSyxSxJdF6+FzMnzMBe0Vhuoy
	 NSshafDDO9d77JX7vQNDZnGcSc9uEj5JF9pl7g0VPKBxlDhj/mp1rC5pqn76Sf8EQj
	 NFsrz6sR+mRsw==
Message-ID: <aaf30e1e-be55-4212-b096-69f71bafd406@gaisler.com>
Date: Mon, 26 Jan 2026 15:50:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
To: chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net,
 akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
Cc: kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
 chengkaitao@kylinos.cn, willy@infradead.org, zhengqi.arch@bytedance.com,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260111074453.66728-1-pilgrimtao@gmail.com>
 <20260111074453.66728-2-pilgrimtao@gmail.com>
Content-Language: en-US
From: Andreas Larsson <andreas@gaisler.com>
In-Reply-To: <20260111074453.66728-2-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7F80C80014
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: o9gh87ywd7opxp547einef3bkmi4r4u8
X-HE-Tag: 1769439037-427182
X-HE-Meta: U2FsdGVkX19pl2eIvzWrBRL1B7P+f7GXS0B0cRNSgnk4tEoWWipMojyleS21S1aJvHey5DbgchE5vTxhPHUS1DgHq0/f7L2sETm6JfpcCK8HekNYQ8ndKNVAs9HlYHHMBcjffJ/40aWwpnt6thrDPrPYUCnSNvHz0qwpUTxfsIksDMhmFj3YYx9uQ4SsOIEez3TL7+FXrp+0AHJaw6L5lHFhoMVUnrRqJMv35S/2pBmOI22zdSvX/z7NKW6KdiFgkBsRzWcxxl/suD91UH/UUvn70COXk2tnwo3bQ6Cmri2tk4CpnIOb6PSj/L3lhlEfjIkcOFDmnexF6qApuDbVKgh00GNTf3kTFryFDEDNkS+yUzH49GKTdL19Fpg+GD86QyYkj2U/nVVgpFr5/jpldlChkljyS6sRhSJDEwARvyaD5PGyspsTkufWK7cw2Xg08XdGw04mcZAKGVoSn0YWafeLjmoe6g5vipXbGiQH3ziIsOkx+urJMGC0UUBoeGv2rjtyFhkWp0E5l8d55wamNuN/l90RPRjc+dbLpD4BUBRKNGGNRDEbHyktEHuEHLlamT1rb1V/GCWOoTbli1POVHl2Ka2hYECay8AJ6qLaAYNYCs2ELexj7eADkXEqTSQNloLH5JX9M5i0Whm3BLWPMaAu1V2qwzKS6nd/BAR2o4WkhK7gD4uLVmEF+hIPUuI7Vmn/VT9w9i26wVbWvL/NdTVlHFDqFWxiDUW56TL5LDTMsYrTAeYJKNAD4dZcLpQGpkS2+xb5XiC5Z/XjL+El3yQM5c7c8Se596E5qXXkBfBFdW4Uf+Hrl/8kaRqscgHvpjtiPlWrdcxUinzhfQ5GSfkC58PxS+obCl8wwdf1iLFlgbLbNUpjLpp6xO5D2h3EFtI2SKvCr9r1XKnnKdaa5FzPpZr5a7H0FkpLDJ+tls+nxWMSlIqo96xe110WeLZK+XqDIDo/O5DHNDqc+Bq
 eUN5tmBg
 uIxqY3Sfo33eTg9S9Mkkrm29vyTt87o1y2AU0uK8v6nUZCDC/oyl/2PzUgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-11 08:44, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.
> 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> when vmemmap_alloc_block returns NULL.

This patch seems to potentially make more functional changes than what
the descriptions gives impression of.

Given the amount of changes this seems to introduce, more on that below,
I'd like to see more description on the changes and why they can be done
than this.

Nit: use active language, "reimplement", not "reimplemented".


> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

It seems that this patch removes alignment of both start and end. Is
this a functional change in practice or are these always aligned for
some other reason?


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

It is not the same thing, but is this equivalent to if
(pmd_none(pmdp_get(pmd))) at this point?


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


This change introduces using vmemmap_alloc_block_buf() instead of
vmemmap_alloc_block() seems to introduce two new behaviours that was not
in use for sparc64 before:

1) Using altmap_alloc_block_buf() for a non-null altmap, that was not
   used before. Also the fallback to vmemmap_populate_basepages() passes
   on altmap.

2) Trying sparse_buffer_alloc() before vmemmap_alloc_block(), which was
   not done before.

Neither the commit message nor the cover letter touches upon this. Could
you elaborate here?


Given all the (at least seeming) functional changes could you share how
you tested this change?

Cheers,
Andreas


