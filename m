Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFCBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C8CD9001A3; Thu, 14 Aug 2025 12:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577F3900172; Thu, 14 Aug 2025 12:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441619001A3; Thu, 14 Aug 2025 12:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D45900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:23:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA30383577
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:23:03 +0000 (UTC)
X-FDA: 83775882246.23.7DB2B68
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F117100005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:23:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755188582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9E7QOfStBz0vXdG6NVQ0zsmIE9heN8GKfR205mEOHBQ=;
	b=hVnLzDPjtuXrBmJp3TpW+ZhYRZOaVFfIR2Qwc1eYhUEfWBJLpD9CEgjHdeL6CbI6gIEX2L
	L4h6aTrUAngAp8Yit4PuixO2uSvt/MnTlyA4pAhARgrXrPzQ96zGAZmPt7Z8p9+L2xPMFg
	zo+4SlkZOcQFLGnXSI2G/fcXJbL0SwA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755188582; a=rsa-sha256;
	cv=none;
	b=EpVuwrpcbCQE13z06TnYpZUsnxnojRYtwn8Vmrzy+JC6+caC/nJOHoqubzfYA6NL9wjyN3
	oiXWddDI2QDeGlamGn3PD1ZdvSH9ozusvde8dcgiG5Xzu+Fqmmu0EC2pfF9I51f0NffMag
	o7qrD4jbWERTxua95s1VKfyCpMBCAsY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4c2r7K1ch5z6L4wB;
	Fri, 15 Aug 2025 00:20:13 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id AD6E714010C;
	Fri, 15 Aug 2025 00:22:57 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Thu, 14 Aug
 2025 18:22:57 +0200
Date: Thu, 14 Aug 2025 17:22:55 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Chaitanya S Prakash <chaitanyas.prakash@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, "Yang
 Shi" <yang@os.amperecomputing.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Kevin Brodsky
	<kevin.brodsky@arm.com>, Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>, Zhenhua Huang
	<quic_zhenhuah@quicinc.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 1/2] arm64/mm: Allow __create_pgd_mapping() to propagate
 pgtable_alloc() errors
Message-ID: <20250814172255.000039ca@huawei.com>
In-Reply-To: <20250813145607.1612234-2-chaitanyas.prakash@arm.com>
References: <20250813145607.1612234-1-chaitanyas.prakash@arm.com>
	<20250813145607.1612234-2-chaitanyas.prakash@arm.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.66]
X-ClientProxiedBy: lhrpeml100004.china.huawei.com (7.191.162.219) To
 frapeml500008.china.huawei.com (7.182.85.71)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F117100005
X-Stat-Signature: qqtahtpbcgon94og9wt9wgswhysou4oq
X-HE-Tag: 1755188581-583683
X-HE-Meta: U2FsdGVkX1+qir/tpEIZRHixt1GGvckPYv326z1Ygs0T0a93zPuP7XsQad24rcVd4XnMgVrictsdv5z4p4N6iOlA61PR8aWSB4ITcp2YG7rxLZzvr9GaGuYt3UmjmcWphQfIp7YgiIF44bQIRPEwqCveHEYdiziokA1Llhrg5WZuMkSSmxMjArsZf2DH8qqP5ahai1xbw1+A61Nx6HXMtKPb5xa2qRzkHLO6ydhF/NyO9HmaDcY0TCzSKdp52pZcnLiJ4pKr8jDryYE6PyqUNMMOEF9WpBJ1vCbr6ZWkUCHXFlKGWL3MSk96XuAOb+Q0+KeFPz6N6ZSoOUmOLCFqF5ApyHKfp7EEQqJhbspCdaWwbkG973Xn/0YthGIT+QSasYeTiMbKjkQ5aYV2+KsHFZdbprZx4wRBGppkwPKpYmDdwqVTrS8E0r35gXsDvWPEDLvoLpwhh1d9iln/C7yUWvS2/ActEVQmlEP2IZxEio/wIDiNqB4X21T9TR+9FCUK7egymUx7UVhWdOpOT3mTfqems/jxNz3/ftitLpd+bv/cShG2QeyN3fUhIyTf6B51Ffb6/miaT6OJTurIFiO/OHuL8l29gBZdxlkbsAB+UCoDm5023XqHkIr2I4GYizCuTuLdn8QYsaHPCrnhE+DQGDQUU/68dOmBsgIJWPk9G6YRu6FwoVnD/wclZ3PZBgtT9kF+SMEetDRI5QjNufnM7hScOcRH+t98CcH/mzuEIX4ROATf/aIEDC86Gnd03O4AaSRfX2OvCevDe/ZN0/7AVoLY32t7R3oYU6OjyOcDF8tTihjiENj5LKuGIDJcAqr+CNtm2qXSgoOxcVMxDiXH9Sca0AD6UxokXGHbYHx28n3L2GFS9fJq7M/fRsKyhJ28UwjuqlrCuRyoBU4u/1cXX/R3vd8zyy3SmyzijOB+FM/ZFd/EF0tr026TErTPiAWxpVtR4SscjO4l7Iv+l9O
 2MJ/83bY
 rinOHGEBEW57m2i62Q/SSBxBUcVQTgtJPa4q69Cq3sXjxWGblYJaA1gtS6aGRpMmiLj1X10doQRRf70bIfUvDJpCUN+793Vzi09e1ftpZv/NkaRFv98D3ZQWJX4TL/CMZAJXB4yGfZeyXlyUMBVcdAQCCA3drT8dy9Sn6twCC+D/FU6yET40cJXpswNize9j8AsYs/9WmkMlgTrcgRC/yJGxic7BbU7TCftExyW8PzK4bUUBSvKsZpqCHZeoQvJ3jJ+Ce0Mq7xZP4CT+RsbfuSENjXOEkAkMEgfcOY2njxqTmsx0dSgwzgG77jaib+YCxpdi8Gg+50lMDIBY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 20:26:06 +0530
Chaitanya S Prakash <chaitanyas.prakash@arm.com> wrote:

> arch_add_memory() is used to hotplug memory into a system but as a part
> of its implementation it calls __create_pgd_mapping(), which uses
> pgtable_alloc() in order to build intermediate page tables. As this path
> was initally only used during early boot pgtable_alloc() is designed to
> BUG_ON() on failure. However, in the event that memory hotplug is
> attempted when the system's memory is extremely tight and the allocation
> were to fail, it would lead to panicking the system, which is not
> desirable. Hence update __create_pgd_mapping and all it's callers to be
> non void and propagate -ENOMEM on allocation failure to allow system to
> fail gracefully.
> 
> But during early boot if there is an allocation failure, we want the
> system to panic, hence create a wrapper around __create_pgd_mapping()
> called ___create_pgd_mapping() which is designed to BUG_ON(ret), if ret
> is non zero value. All the init calls are updated to use the wrapper
> rather than the modified __create_pgd_mapping() to restore
> functionality.
> 
> Signed-off-by: Chaitanya S Prakash <chaitanyas.prakash@arm.com>

> ---
>  arch/arm64/mm/mmu.c | 156 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 117 insertions(+), 39 deletions(-)
> 
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 00ab1d648db62..db7f45ef16574 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -196,12 +196,13 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
>  	} while (ptep++, addr += PAGE_SIZE, addr != end);
>  }
>  
> -static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
> +static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
>  				unsigned long end, phys_addr_t phys,
>  				pgprot_t prot,
>  				phys_addr_t (*pgtable_alloc)(enum pgtable_type),
>  				int flags)
>  {
> +	int ret = 0;
>  	unsigned long next;
>  	pmd_t pmd = READ_ONCE(*pmdp);
>  	pte_t *ptep;
> @@ -215,6 +216,10 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
>  			pmdval |= PMD_TABLE_PXN;
>  		BUG_ON(!pgtable_alloc);
>  		pte_phys = pgtable_alloc(TABLE_PTE);
> +		if (!pte_phys) {
> +			ret = -ENOMEM;

return -ENOMEM;

When I saw this I wondered if local style was to always exit at the end of
functions, but it isn't so early returns should be fine and simplify this
a fair bit.

> +			goto out;
> +		}
>  		ptep = pte_set_fixmap(pte_phys);
>  		init_clear_pgtable(ptep);
>  		ptep += pte_index(addr);
> @@ -246,12 +251,16 @@ static void alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
>  	 * walker.
>  	 */
>  	pte_clear_fixmap();
> +
> +out:
> +	return ret;

	return 0;

>  }
>  
> -static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
> +static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  		     phys_addr_t phys, pgprot_t prot,
>  		     phys_addr_t (*pgtable_alloc)(enum pgtable_type), int flags)
>  {
> +	int ret = 0;
>  	unsigned long next;
>  
>  	do {
> @@ -271,22 +280,27 @@ static void init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
>  			BUG_ON(!pgattr_change_is_safe(pmd_val(old_pmd),
>  						      READ_ONCE(pmd_val(*pmdp))));
>  		} else {
> -			alloc_init_cont_pte(pmdp, addr, next, phys, prot,
> -					    pgtable_alloc, flags);
> +			ret = alloc_init_cont_pte(pmdp, addr, next, phys, prot,
> +						  pgtable_alloc, flags);
> +			if (ret)
> +				break;

	return ret;

>  
>  			BUG_ON(pmd_val(old_pmd) != 0 &&
>  			       pmd_val(old_pmd) != READ_ONCE(pmd_val(*pmdp)));
>  		}
>  		phys += next - addr;
>  	} while (pmdp++, addr = next, addr != end);
> +
> +	return ret;
return 0;

Same in the other cases where there is nothing else to do and they are simply
early error returns.


>  }

>  
> -static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
> +static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
>  				 unsigned long virt, phys_addr_t size,
>  				 pgprot_t prot,
>  				 phys_addr_t (*pgtable_alloc)(enum pgtable_type),
>  				 int flags)
>  {
> +	int ret = 0;
> +
>  	mutex_lock(&fixmap_lock);
> -	__create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
> -				    pgtable_alloc, flags);
> +	ret = __create_pgd_mapping_locked(pgdir, phys, virt, size, prot,
> +					  pgtable_alloc, flags);
>  	mutex_unlock(&fixmap_lock);

Could use guard(mutex)(&fixmap_lock);
but maybe not worth introducing that stuff just to simplify this.

> +
> +	return ret;
> +}
> +
> +static void ___create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
> +				  unsigned long virt, phys_addr_t size,
> +				  pgprot_t prot,
> +				  phys_addr_t (*pgtable_alloc)(enum pgtable_type),
> +				  int flags)
> +{
> +	int ret = 0;
> +
> +	ret = __create_pgd_mapping(pgdir, phys, virt, size, prot, pgtable_alloc,
> +				   flags);
> +	BUG_ON(ret);
>  }
>  
>  #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
> @@ -485,9 +553,11 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
>  {
>  	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
>  	struct ptdesc *ptdesc = pagetable_alloc(GFP_PGTABLE_KERNEL & ~__GFP_ZERO, 0);
> -	phys_addr_t pa;
> +	phys_addr_t pa = 0;
> +
> +	if (!ptdesc)
> +		goto out;

I'd return 0 here.
>  
> -	BUG_ON(!ptdesc);
>  	pa = page_to_phys(ptdesc_page(ptdesc));
>  
>  	switch (pgtable_type) {
> @@ -505,6 +575,7 @@ static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm,
>  		break;
>  	}
>  
> +out:
>  	return pa;
>  }
>  
> @@ -533,8 +604,8 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
>  			&phys, virt);
>  		return;
>  	}
> -	__create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> -			     NO_CONT_MAPPINGS);
> +	___create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
> +			      NO_CONT_MAPPINGS);
>  }
>  
> @@ -1369,23 +1440,30 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  	if (can_set_direct_map())
>  		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>  
> -	__create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
> -			     size, params->pgprot, pgd_pgtable_alloc_init_mm,
> -			     flags);
> +	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
> +				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
> +				   flags);
> +
> +	if (ret)
> +		goto out;
>  
>  	memblock_clear_nomap(start, size);
>  
>  	ret = __add_pages(nid, start >> PAGE_SHIFT, size >> PAGE_SHIFT,
>  			   params);
> -	if (ret)
> -		__remove_pgd_mapping(swapper_pg_dir,
> -				     __phys_to_virt(start), size);
> -	else {
> +	if (ret) {
> +		goto out;
> +	} else {
>  		/* Address of hotplugged memory can be smaller */
>  		max_pfn = max(max_pfn, PFN_UP(start + size));
>  		max_low_pfn = max_pfn;
>  	}
>  
> +	return 0;
> +
> +out:
> +	__remove_pgd_mapping(swapper_pg_dir,
> +			      __phys_to_virt(start), size);
This one is fine as common cleanup to do.

Jonathan

>  	return ret;
>  }
>  


