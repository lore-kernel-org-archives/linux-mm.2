Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A03FD68BEE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80F76B0088; Thu, 18 Dec 2025 03:44:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2ED56B0089; Thu, 18 Dec 2025 03:44:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93B356B008A; Thu, 18 Dec 2025 03:44:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2AC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:44:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24CB613C2CF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:44:20 +0000 (UTC)
X-FDA: 84231955080.15.76A2AD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 84747C0004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:44:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ukyez4lu;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766047458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9ilmbycFZ17klnTpkRcI12XjTZeqEwRnaOxOXHC9GI=;
	b=4JI3dTs41I2lier7a1Bft8EXIB1pbLdluQXJqevUetlJNVtCHzt282JS/W/7Xr+6nWF+Wx
	0mJnFVmVOnZKzD7H+NLomwZzf2kbaKluf+9gbrefv51vdPEfAvk1rxZq6Ilw9nUd6Caq5D
	GHeGckLNloAN6JV1dmj4ZT0wYf4ildg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ukyez4lu;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766047458; a=rsa-sha256;
	cv=none;
	b=cRMu9EHC/eusqmqSojnE9/QMWd2fwDIe2dxJbc59GHPoq2vRmfnTSUt8/N2bCgQ/dmmgxf
	Iad+68812YgmytGMl2hVgVzniPY9t2xRs7x71xhadz9iAMC84CJh03526bCldNPNDHIHeO
	tyCM51uVRXc7qTaEXZIPaD1H3jmlchE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CAC7C60121;
	Thu, 18 Dec 2025 08:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F222C4CEFB;
	Thu, 18 Dec 2025 08:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766047457;
	bh=bALsCqvSTHwwYz8QmGh55URvGVsNoAOBLrpOS8lJtd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ukyez4lu8CFjM7JHpAeVJUdVpCmSNa2wj7Xmg4xLozKRmW+/KY0M+f0iioxKKlRTL
	 MOUts3mwjSzKX67ovaxIYmBNpvgrrAzZ9u6ATvCzXCBkLXJbIsMCNErjsHjF8TxrXa
	 wKWVwOruiNMyYjvM1EA+WfC7ufzB4g/NF7tjwsmrZnbvvJVNIkamoprSGdtnrT0cdu
	 A29w2x9UtFTaS+jALpDaZr/zllPmWQHu6NgzdCLlKIQhzuw7A5NZovaTCoCqUtTg1d
	 XERd6gK0dUi9ML0LgD4E+lq+5eyToLHmBKOEgsF3eKAVuabLCKU8mXzruRiNi6sZiS
	 yEX5hzI3wzYwg==
Message-ID: <d373f7b0-f822-4c31-990c-41a6cdc76db3@kernel.org>
Date: Thu, 18 Dec 2025 09:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
To: chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net,
 andreas@gaisler.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
Cc: kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
 chengkaitao@kylinos.cn, willy@infradead.org, zhengqi.arch@bytedance.com,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251217120858.18713-1-pilgrimtao@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251217120858.18713-1-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84747C0004
X-Stat-Signature: 5cc4e1kfzw59ryzsx4hsgeuhnrbts5nt
X-Rspam-User: 
X-HE-Tag: 1766047458-640154
X-HE-Meta: U2FsdGVkX19HKr+MjB8ko7+HDUrfMHba5yGyWMRJngOm152xKkIQkcNCoNIz6fEeNS42L44yapPzeyxrYI5KNz69/4dOApXY+ufCo/30eyPjMWnV0nGB2t0JfTZ8cYi1TVXKW+it9w3EoiGTxz4PdvqtQBs7oMZFYiQXebneRaxsc3twsL1iG4OKFyknNTO0L4v2+6RL+8HkCfYgSD2pNgEVCqV22ukERR5EHDKWg03mXh1lgIylrFjfP6nBBFmcy1LRjF9ihu8fWMliKvbE4suH+Kl5PLpn5kIKbQNyRuQQlP2Ow2hoO2/Dc414dqr7JPI327c9hE3G6wO04pEBY68GR/uQgwe388XML+8LsiKWBbAogCGhRaiAVaw8LJBim50TUvCI31RcpEcY1OgkQHk76fYJCpTdFiDYh5Yg0L15VM0SFxS36ayafDB8usCsx251lKrDR6MTQTMF4y66iXKOKRP6Wlg94f5v6F62l/Zs2H5Op2W7qUOxDHxC5/BtsmyHnIs5WF3kQJe4jV/hQE66f/7Yv/2EFxU8AKj9xNDjhCxoP8zsZCxJog9gfkjDHFlkgGYV/3doIpRiJ5CWELYOiY1wVb3TqqbhIgvBBwYhZAjvgqUx9HWfoMOdppBYbKVwru5n95l7NOSrGx7+U6i1DXP74MxQOOWy7mEL2KyxlyqlR6m/w/TY7ue7k8wVMIR32mmlk9ZrVKyngwZdGnU7p8CAkAOH8r4r7h2x+bqkcK06S+09mT8UGt5XTq3cCTV1AdnlkBR6mpC8dpTbA5tpKoZ47j0//Dwjb+1RMhEWXiyJR8Vnok2qRbCQtle117JlzZ3sDWm87/DpfQWpZ3eP1AIn9tezPFTe+uNyinyUDAGagKKzvmIi7GS9b6JscqnUzt7vuXpy7y2FkjqeTeQvzQoVtyDHGKGhl41Mh0qw00iF55Q9Yd/5n2stih4cn+JBl2yS+Rbj5L2cUOz
 66m+dQnM
 AvDwqeBMuZQIdZk8+Gi5kLP1IY5myJVfDtg/r7ktbqbRYn3WoXkXU7b6dDqxjPsjMHvLysR7hBYJ1RINx1I0kADANHkt4Yt9gci2+07zEwGivQMgpU5H4cvk5HxaIximuF5V8R1rqbypUg2aPzhhMaMx/l/9n+Z2p0VxcwZB1N+0GgM2mu4naRGO5K6Ry1XTcbGUG+7YC+CdrPIKeRNVpHnx+PQepaSzODUQ/0ANjZ7NlJ3cd6IT6eyTK45HMWzrOhAs3S7JIlJpmdGoOjQXrHMtsY+RtLaQrSCs9B37EyCxVtVMYJAgpq5RyK8UY5UHmv4M61l90mfhuzbP13zL7p1mXCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 13:08, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. Added the vmemmap_false_pmd function to accommodate architectures
> that do not support basepages.
> 2. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>   arch/sparc/mm/init_64.c | 56 ++++++++++++++++-------------------------
>   include/linux/mm.h      |  1 +
>   mm/sparse-vmemmap.c     |  7 +++++-
>   3 files changed, 28 insertions(+), 36 deletions(-)
> 
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index df9f7c444c39..a80cdfa6ba98 100644
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@ -5,7 +5,7 @@
>    *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
>    *  Copyright (C) 1997-1999 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
>    */
> -
> +
>   #include <linux/extable.h>
>   #include <linux/kernel.h>
>   #include <linux/sched.h>
> @@ -2397,11 +2397,11 @@ void __init paging_init(void)
>   	 * work.
>   	 */
>   	init_mm.pgd += ((shift) / (sizeof(pgd_t)));
> -	
> +
>   	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
>   
>   	inherit_prom_mappings();
> -	
> +
>   	/* Ok, we can use our TLB miss and window trap handlers safely.  */
>   	setup_tba();
>   

Bunch of unrelated changes that should not go in here.

> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>   EXPORT_SYMBOL(_PAGE_CACHE);
>   
>   #ifdef CONFIG_SPARSEMEM_VMEMMAP
> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> -			       int node, struct vmem_altmap *altmap)
> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
> +			       unsigned long addr, unsigned long next)
>   {
>   	unsigned long pte_base;
>   
> @@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>   
>   	pte_base |= _PAGE_PMD_HUGE;
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
> -
> -		pmd = pmd_offset(pud, vstart);
> -		pte = pmd_val(*pmd);
> -		if (!(pte & _PAGE_VALID)) {
> -			void *block = vmemmap_alloc_block(PMD_SIZE, node);
> +	pmd_val(*pmd) = pte_base | __pa(p);
> +}
>   
> -			if (!block)
> -				return -ENOMEM;
> +bool __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> +{
> +	return true;
> +}
>   
> -			pmd_val(*pmd) = pte_base | __pa(block);
> -		}
> -	}
> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
> +				unsigned long addr, unsigned long next)
> +{
> +	vmemmap_verify((pte_t *)pmdp, node, addr, next);
> +	return 1;
> +}
>   
> -	return 0;
> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
> +			       int node, struct vmem_altmap *altmap)
> +{
> +	return vmemmap_populate_hugepages(vstart, vend, node, altmap);
>   }
>   #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>   
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 15076261d0c2..5e005b0f947d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size, int node,
>   void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
>   void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>   		     unsigned long addr, unsigned long next);
> +bool vmemmap_false_pmd(pmd_t *pmd, int node);
>   int vmemmap_check_pmd(pmd_t *pmd, int node,
>   		      unsigned long addr, unsigned long next);
>   int vmemmap_populate_basepages(unsigned long start, unsigned long end,
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 37522d6cb398..bd54b8c6f56e 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>   {
>   }
>   
> +bool __weak __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
> +{
> +	return 0;
> +}
> +

Reading that function I have absolutely no clue what this is supposed to 
do. :)

Also, why are you passing pmd+node when sparc ignores them completely 
and statically returns "true" ?

If you can tell me what the semantics of that function should be, maybe 
we can come up with a more descriptive name.

-- 
Cheers

David

