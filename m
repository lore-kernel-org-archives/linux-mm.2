Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E16D7496F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFBBF6B0088; Fri, 19 Dec 2025 04:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F786B0089; Fri, 19 Dec 2025 04:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF346B008A; Fri, 19 Dec 2025 04:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA36A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:33:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AD8A13B0F3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:33:36 +0000 (UTC)
X-FDA: 84235708032.03.5A96B15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E97DC40004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:33:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zuh6QYOA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136814; a=rsa-sha256;
	cv=none;
	b=BqIn6oYR4Bk2nb/mHqN2SKt+XN+kMItswOwHlE79+25YG2qbbb8+P9Go1Hxddr3Kakp6Mh
	Fne139gQ/DCaMKBUjLQKNfGY7OsjpVUfG7hZmHBjBcpVPeWgaw2QX5ex2Am88yAlwSugkr
	v6NQV4kw4bpXIcMJgwQrcOVaPCdE4R8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zuh6QYOA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0Kf5+Nz+mO2ccqz6oPuNVTRe9bZE/YbCp/qdCalR6M=;
	b=tLTSK4dkdZDMMdsVSZkVe16MD6QJKUcwInreyBLP0hIizxqL2QZ5b3aFmCEDpC6xiweQbp
	ZWnZRZ3EeRmJ1X17e8dfQEcmLa25TfPgHfmkwPE2aB1x5ZmaRt/qXOzd+arw9CqE4UPFUN
	f6FMm3z9d3m5R1GN+0dtUImRlaPeK2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6BC726001D;
	Fri, 19 Dec 2025 09:33:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862DCC116D0;
	Fri, 19 Dec 2025 09:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766136814;
	bh=8gogU4puAS1Eixl5xxRff+w5BC9Gk8ktr3c7vX414Ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zuh6QYOAWUvaiFNc1+kuSjpiYs3pjbjJ3Csu4iZZciekNaLP+wHcr3huE7B51cq7A
	 XCy2GoY/9siUVelznccVcqkr/TOAdqEbIOjTScA7H+NXGQieAGDI8ze/HFfBK+RP3i
	 55TnbAvYDcT+pVGl74NAqmFDb/zu2OWf5hM7dKB5JHfZ7ZRAotDMLnCfEV9YDnYXTt
	 brZSd34Bi5e9O+BZm1bKE/WZEQ/W38LIcPpJiwBR+eIPQSq4g1cjXqONwl/1GhC+HP
	 tE76QBIZCXDJiQm93GUZ4FaAWIqXdm7QfhkMauUB0ng04S1xfsNoKeZ7HGARq3jpkb
	 F1zkulauKJObA==
Date: Fri, 19 Dec 2025 11:33:25 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/3] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
Message-ID: <aUUb5RvsLLfPlrcN@kernel.org>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
 <20251218174749.45965-2-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218174749.45965-2-pilgrimtao@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E97DC40004
X-Rspamd-Server: rspam10
X-Stat-Signature: yw9kxpsxy7yd8b8a91n7rsiaffqi9w5p
X-HE-Tag: 1766136814-850663
X-HE-Meta: U2FsdGVkX18p2aOdtaEpWljCOUfPDdE8chS4VdGoBE7m9v1C2PRrQ7OgVnqAjpbLGzp8bliiOpcDuCz53QtPyNCZlSfZhVYyYpPlCbwBFCgAlXC+5ZuIwdI3GAdjDadp7KlMpmzEFfRR9JmD47klfL77yE6pvqkiaAs6PQdce0t8UksigpbechH1sN3ILZR1zQHtaOOxn2l6YyT4LUvXuRZ/qADhkyuk3YR5Tq9RrhopY1+6/OhQmu+6GXcDHENQIxLFLzMNSrX3kYbXhjRTWsbD8LqIzcqbARk3unM1InnWbtbp7U4GB8W8U2dT/Srk4tgX9tUUJIXb9tX7g/A9e5VQmA5yn0eRjcTGKffnoV0CgUntO3LHlOB3J/xwg1gvWdDaFJVng2Q6fx2+QqsvsK+vNEKaihT5gE/mKxd5+6FWUA4WD1MH1dokKT6+gQ0oN4ijTU/spG6u+HL20os2dUzR2lRULwaryFOn8X3lrNpDEk4DZRIL6QG7ZiVq6t6/6TefS0vX5rbC76ByiDGF44S/Qdfl4MBwpJacXvAgJhLrwATlpnD/2TX4GWudbn4bxAMujlE6WwnTqlkJwHcok7VXFj0Xd4ZpcLmC81o1FW06VcJiR/0tchRJsvL2zGfo+OCpvWNLhuBJU+auJa+ILmU/QkKiYzVXRMGvY33VBTCsui90DhN02lnE3dpaxJcZCFpNAvd6phva6eUAxLBhJw3+xEBFbQyqW0o1WgRdKM0NC1xsWyCVFOKwxojeMyn13EkFk9tpcFvhSYXM3sN4OmnS8Vud8fTLx8ogtfKMRAwGqJLXfp+vqUXKtzWojaQyMhhckvsZC8fAIJBtsuKpRMZPzuYUm8aliPzRS2oD3BPw64bDn4ArRy7cCD81CSSgIMK7u46UHJGrxp5xyx1irp2gr0yw209VnRJ9EJsfUh5a3jaMaPHk/MUN1uw6GOzuxcwPeuq8srJsmiGtfWM
 /WBWL+7d
 G3SLTaQmhFlpWwn+HBlrzLqYM3AWXN2SBkgJwU8qe3QWdjjSOQ6Sdkuv9lABp8A3XvKY/46STRj7M3G++IA4foByYaqQIXXWTfab1GaNQ3Mb97fBCt50dxpKRcEMENuMeVLgtAZnYbZhfwu8m8bxEXagGcCzNR+zm25hzLjYBE65x53K9BUQ5sMyhnH7BqQmRngEJnnnbwvET84/y2mJQ7pUMvMbaHtaZcIJVjPCvahAM2dCklLf7ok2Ml2YOBw3UqIAcQsqwcYzjDpHNuv9sE/GN2SFbhJSU996z7qWpoUbe538=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 01:47:47AM +0800, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> 1. In the SPARC architecture, reimplemented vmemmap_populate using
> vmemmap_populate_hugepages.
> 2. Allow the SPARC arch to fallback to vmemmap_populate_basepages(),
> when vmemmap_alloc_block returns NULL.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---
>  arch/sparc/mm/init_64.c | 47 ++++++++++++-----------------------------
>  1 file changed, 14 insertions(+), 33 deletions(-)
> 
> diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
> index df9f7c444c39..f477ab1b4f08 100644
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
> @@ -2595,39 +2595,20 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
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
> -
> -		pmd = pmd_offset(pud, vstart);
> -		pte = pmd_val(*pmd);
> -		if (!(pte & _PAGE_VALID)) {
> -			void *block = vmemmap_alloc_block(PMD_SIZE, node);
> -
> -			if (!block)
> -				return -ENOMEM;
> +	pmd_val(*pmd) = pte_base | __pa(p);
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

This should return 1 only if the pmd actually maps a large page, see x86
and powerpc implementations for example.

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

