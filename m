Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46E3C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23306B0099; Fri, 26 Jun 2026 12:21:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3D36B00F2; Fri, 26 Jun 2026 12:21:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B436B00F4; Fri, 26 Jun 2026 12:21:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 494D16B0099
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:21:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BE3DA1C2EC3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:21:57 +0000 (UTC)
X-FDA: 84922580274.12.D74CE2F
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 026BBA0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:21:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lh5YAxDu;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782490916;
	b=HfjysieVvSDraBA0dA1FZqqxRE/GL5cmZK/sEnX/U2VbqWKdw0OSFCgGpGHiD4HpMDHB5Y
	k/zuVjXEP7BU3k/aHHD0TAiw0Jdt6XRGbxB+LvC6GD/HiJNeQifENPMvty2NQbHGlj8DL9
	ivxUfF2PnDNVnk8jtKuU2UgiBw40djU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782490916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBlnVq/S0dm/GPydxBpVJQrOU3YgiAXnWHM/7A5IJg4=;
	b=XmBi1D7HHK5ahcQEMz5LSKkpTAHIjH0oVnqDGUnhDbN0ktHTjhdfoa4T1G0IV5ePDOT5DQ
	/peM0Gz7NzQwJSG9claGXETUysKLWEP2SbOpRYBHevy5ta+Gu5iFsLknOcizkyCMAPDQ7c
	SEGtYQqloBpzNrMM93FXCNCEDZrTiyc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lh5YAxDu;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3996c9eeebeso10086371fa.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782490914; x=1783095714; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VBlnVq/S0dm/GPydxBpVJQrOU3YgiAXnWHM/7A5IJg4=;
        b=lh5YAxDuWSS9CBAnKF+IsQHEejIWLYK+o3+lr+LZU2ASx28qmJhq2h3XpHvaSabJxe
         WxvVui3L6nN0OiAFY5ggobTxYHEQvmc9lrB1A8WRT5pJ6FFeoDYsc7VOBvUx/5znIoUl
         wQDMFO5hHmjaiTN5qdTwHq8UkwL7ZiwzoHeKGTae40z9+hXX/Hau88NSFH+EQ9dYyXuh
         yh+FgwT3K5huqC4tGz2S4SHfOp4Tvv7kxROft10E2OyllvQ5H2zCKf40eammPEp+GQpf
         5BbdCd3Sk4W4BBVPaZOhtPqCNhLaozCiLD1yTA77zKe0kHzOtnI5DbzmbqYsMNKcZWKX
         mKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782490914; x=1783095714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBlnVq/S0dm/GPydxBpVJQrOU3YgiAXnWHM/7A5IJg4=;
        b=eMhCQsBGip57NxXKSqnpeKKXcJHjG35Q7fjoYlOJRk4XDqjhPto9HUUf5OVtYSz3Dy
         BrbiQlPzQwcfTuPsK+0H+wI7l/CW0OO89eYOKJriJ03niKC5BtAL2IcJlev9PXoMeSXa
         W5sEtF/HmvLjBl0TxN3gfd4HMWtiI8NvP4IjptFHBq8CGM/vxKuJB+MsuJBEjSAzUxJm
         JAqx1ZOG9ihYI2BBZXUcgCbsRnscm/JuUlmvTm0eGOYIP1ClJQqAd8J2OUVPaPJR3rL8
         1NyY88kcl7Tl8Cbrp+CliwrIKoIrGGmL8tbwZainHjGk4aHPG3f1tDZU5nBtF5BrQYZm
         rshg==
X-Gm-Message-State: AOJu0YwVRVVBM2IqegfUzEMyAIWRkoy52YQzya23IbHAOeEwhzoiJErE
	HeEGxTh6SpV2Nit2arIDqAWKAnwps1DuxMDq+jOZ8Qe+4+gJHTGO1CTu
X-Gm-Gg: AfdE7cmjV/kqq3Y4trb/63Qfffjy/SJqpT/Puz9gtfQLu42znzKjFJwzGaNyofEa5X1
	QCkLXNFNohaeBJQFjRcVuBt12JJ1JV8D7zr+Mv3IdxKBKDQ1bd3ixjazcIgWRtNIzwjBlF9ALlg
	i3aRSim7Q6cPKENinPOSv4/lrvqNx6KRaMu5HUPe5051+F0FcF+JjYQNLdhwMxvRu7pt4TGw3GK
	iyYrhyZ+1Cux0ZR/p7F+UMAyGP7RFprjZ63O3/YaibiamlJcxDnWJNp6oMT07NU6lXNhAXGM+If
	KGBAFnJfvvJsTEQ2neIjd6ValU/FFAuulHWf2iW89HKTaogkVqMq6zs2bpYgWBMx2Kucr0pTXmm
	F4SKPQABhOAjbwsN97P9XIQyEnOuinkfZ1LdzWo+cXRl6criPnejncie4XIPICdhI
X-Received: by 2002:a05:6512:608d:b0:5aa:6ede:5b with SMTP id 2adb3069b0e04-5aea1f3c096mr2475000e87.14.1782490913622;
        Fri, 26 Jun 2026 09:21:53 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ae9d8fb537sm2467551e87.21.2026.06.26.09.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 09:21:53 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 26 Jun 2026 18:21:51 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: Re: [PATCH v4 3/6] mm/vmalloc: Extract vmap_set_ptes() to
 consolidate PTE mapping logic
Message-ID: <aj6nH7bJBI4sOmxE@milan>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-4-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618084726.1070022-4-jiangwen6@xiaomi.com>
X-Stat-Signature: igbb9riz4po4jmia7je6zf7n4iijtbpp
X-Rspamd-Queue-Id: 026BBA0005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782490915-772392
X-HE-Meta: U2FsdGVkX18vaifADYGYGpR1sd7JqJQqnBMxECPi/Ry8ATATjOwaE5DSaTcX9eWHxUosEMoIY0cJqtQfXbBFxqmkASRPq+8lZAD9XGaAfQeCVRgTLGXedXwl5+qe38+BY4okzZpjYmJBS1ZFlJOevjx0WFbedQduF/Q08vQSTFuOM0Aai8co2/a0gtFxhHDDOyifdvlxyyTuo/6TMQf8y8Izy+1HrwPZZd4rPAjxDzaqx2tSL/JGcdm8AHlpAn/qi8gn318w+P5yC1uUPoX8DEjAoczayP0/476IJiCqPjFqMI82TS2KEpVmYR9UihCfALl/2nLdLe5Mdzp4g3lXmFbWw5xxEY4JBkrFvgu+l8qIRcvrZ+N+xMokUOW0qwkLAIxskLz4uQi7oZCrU5wMI96pyCrD052y2Ysf/yaFDG5GZZ6CZ4xm2LCAcu61ATCbS78B7jIfalO5hmhfZ2WTnoDSivtp7xh4gfO45dAVccw8E+K3be8M9sVxbxeGz04CU+ldkQyi9q8VdLfsrrD2aJkLAE8aCZAVJQ3pOObteCPIdwXBr9rdY5hYJc67cIqeWPfSOKNaa1zrNExZNc74SN8R7YAskaNYUrMCInObTpmoydCun/8p18No4yGygb4yaIT2/YgkKukv1Uu+cAtYWIwOPLjfsRV0ZVyv4Ax71RmeUvfzsbGwidWmNPpwMUj52R3VMPT2JtK2ztAFEccfaAUaq5BjI2SQ1tjfkyrlRH/M0eo4Db738vEjyaKXKkY2HAIOoGsMCdWfBlzdkwbDk5eVq9xXPDcbfm4JeDe/6mYzEfOAvq6kK6bhYAnt+x2ep9aC4vj7UHXVx+QocEohIz6B02HZPHWwIYPzRzZ9z6LCLlAWmCW23Gxw9tM+TGSH8E71ogWe62DTJAnisDVYJpF/PQE3Rs0/89/XzaMOqZ9rUfAAGK3to8T/ur3TKhddm0SCVSrgbIuVtrvkQ6L
 bkTg6//w
 aTHFt+trgxP1zz/yzXfQi8gsPqZYYAeqSjy6YmuIQy3G7wNkJ04r+O2D1tI8kFsCaDnm8qzv012mjB6iQFeO6hpNZs4Wft42oBJA3Jjjz72SIvWE8+XyJdSQ6uSogpnKPt5aRAEYIJm3Eqh37k53WtXRKg1EzoyJ0mQLp3HWMXRrwCiT8IfpIVT/37Acz3b84J4Cku8t0cEpFXrXIjmuWAGaAz+AmqQE7/KxqFfW0MHKZeJwaKZMszPAY66dnKGY88REw8HaeMOQDYiaxETmELHIgtbgDtabuHgtgttnsa86aQaSdj/57U4cnSSZRTJKgUmzr8MGB9QuS1XB2O0JXrmEwAcj+SRTFmQhgT13RRDhO/FqDKMRPewx05fR6KEwdWsEst0uXfJ2qlpRWjN1Ri2L9fmQ9i4qTCHvpTX/kjd/KkrErD//VLiULCXEClRfJISQNBlIv9r2pl2PZhFivN1DFcka5PlSO/iIv92OXvGDufMTxIFlkhuBGOC+DlZ8IYZ7RlJgWi4dgXESKJ6zirUgng2efIhQrCtw20eCfjmgO6RxMJt6BvXQdqP+OcfFC5CCTMDY8V8kwEkiSnW6pyvm2I/eCnqQW7vcBu+dt9PdkOPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:47:23PM +0800, Wen Jiang wrote:
> Extract the common PTE mapping logic from vmap_pte_range() into a
> shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> PTE mappings in a single function, preparing for the next patch which
> will extend vmap_pages_pte_range() to also use this helper.
> 
> The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
> so callers no longer need to handle the conditional compilation.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 44 +++++++++++++++++++++++++++++++-------------
>  1 file changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2c2f74a07f396..6660f240d27c9 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -91,6 +91,35 @@ struct vfree_deferred {
>  static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
>  
>  /*** Page table manipulation functions ***/
> +
> +/*
> + * Set PTE mappings for the given PFN. Try CONT_PTE mappings first when
> + * supported, otherwise fall back to PAGE_SIZE mappings.
> + *
> + * Return: mapping size.
> + */
> +static __always_inline unsigned long vmap_set_ptes(pte_t *pte,
> +		unsigned long addr, unsigned long end, u64 pfn,
> +		pgprot_t prot, unsigned int max_page_shift)
> +{
> +#ifdef CONFIG_HUGETLB_PAGE
> +	if (max_page_shift > PAGE_SHIFT) {
> +		unsigned long size;
> +
> +		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> +		if (size != PAGE_SIZE) {
> +			pte_t entry = pfn_pte(pfn, prot);
> +
> +			entry = arch_make_huge_pte(entry, ilog2(size), 0);
> +			set_huge_pte_at(&init_mm, addr, pte, entry, size);
> +			return size;
> +		}
> +	}
> +#endif
> +	set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> +	return PAGE_SIZE;
> +}
> +
>  static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			phys_addr_t phys_addr, pgprot_t prot,
>  			unsigned int max_page_shift, pgtbl_mod_mask *mask)
> @@ -119,19 +148,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  			BUG();
>  		}
>  
> -#ifdef CONFIG_HUGETLB_PAGE
> -		size = arch_vmap_pte_range_map_size(addr, end, pfn, max_page_shift);
> -		if (size != PAGE_SIZE) {
> -			pte_t entry = pfn_pte(pfn, prot);
> -
> -			entry = arch_make_huge_pte(entry, ilog2(size), 0);
> -			set_huge_pte_at(&init_mm, addr, pte, entry, size);
> -			pfn += PFN_DOWN(size);
> -			continue;
> -		}
> -#endif
> -		set_pte_at(&init_mm, addr, pte, pfn_pte(pfn, prot));
> -		pfn++;
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> +		pfn += PFN_DOWN(size);
>  	} while (pte += PFN_DOWN(size), addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();
> -- 
> 2.34.1
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

