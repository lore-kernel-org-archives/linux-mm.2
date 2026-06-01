Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7830CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E446B0487; Mon,  1 Jun 2026 13:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 135F86B0489; Mon,  1 Jun 2026 13:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0252E6B048A; Mon,  1 Jun 2026 13:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0F8E6B0487
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:34:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 705F81A03EE
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:34:29 +0000 (UTC)
X-FDA: 84832043058.12.E52EFEC
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8549D20007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:34:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gTb7dgLM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780335267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdZl1JqvXa8x+O2FgoLF+eh6j2BB3hLfw/Br1aD0zu8=;
	b=tmW7JHVLasOtOOE87h/JaxcgVvMwbMolgnDrcbev+0bnzxm2FJpwqmXKxdPiDun0E3n6+f
	Rg9q5HGuqUkA0oO/YQszScK333kqoYeNFaLrtDMUB9qXYOgYmIjCllXWy+q5cpunno3MBv
	NUNoNv07OjsF8woYcOKaT30oWN0BZXE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gTb7dgLM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780335267;
	b=YeFeUr0gBBUL/7vEsbClrmoLIght2U0YKj6K5BH6GQtLsSYTx7ud2d17yi5c8RLKzTVZ0Q
	Xi9IHtKKtMOE9nVU2A9q8wHyNUm0KRN8DYEqn3ngqjIg8+VNuiY70FnnzQVcXBy8368xTd
	JQmQnJUZ1Bng+3iJ3HQO8iuEuNMJyMI=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aa2c25c632so11838796e87.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780335266; x=1780940066; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZdZl1JqvXa8x+O2FgoLF+eh6j2BB3hLfw/Br1aD0zu8=;
        b=gTb7dgLMqvbKGABDkiOrTkj3F7dKsAktnTMd3Rw2xvS0Z5/LlStHwqzh9W0buJM7wO
         LC2Hsd7QhGS18eUoI8wqTKi/05kRSA5FbqTHrzdNpWTUbpkE4GkfnCFPjpA/GzHNlf4o
         g4NYBRppsaH6WZuuaWthlOVSOiPY+VC7d4eg17Bi7W9gg8m06yBnXeWP18yiHMHcTLN9
         k2Eb74bF/ZxBQXxlHm2OCRNE70A7LTNLvFxGAxmT71sQXd9pmDya6DkjerA+twUoRB/V
         hypzuFN4RfR0rNq+ZgIpBTFv6atyvX4iQoXCWtOUgsC7u69STklQbXPN1v311rXK05Qe
         p3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780335266; x=1780940066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZdZl1JqvXa8x+O2FgoLF+eh6j2BB3hLfw/Br1aD0zu8=;
        b=SQ9mFphs5TTdoQCZs492Cj7fVUxWiChXSjJ+R596lCNw2WmFcZCszTAkplGi6VbfU7
         znQNlV7V9dF6F1WoQa4eORAIWUXBtFNN6l7vzDOL24XnBGuOX9ghbb/8sCDf6j5id2LB
         P1dLDx7lJT6xfhOhu1Xitu5kW0QerOPE7r/xDBqq27UkPISS0PvGd+CGfAiIWz5MngU1
         Ou86T9hj7ZXNpGYoqLrq4pS2Gz1LItqjw9WcPkp9670msjK4xeI/8M+bUT/4JP6aSPXY
         RH4tw7UOKpyGXg44Ci+/QVN6E6cmTqTuLcnQiUggiWA6o4kh3IYTMeRVB7UOvMD0LvGc
         eMuQ==
X-Gm-Message-State: AOJu0Yzy5Nod+pCjKU5yYK4TcYIX1Qalx0oIbSXYj9XyieTQNQcXKXw6
	TWSmq5xFcLtPpr1XkHyMU4WMs/p9vI5JFdCpSBB6NJtlPTWOpkA/t7Qc
X-Gm-Gg: Acq92OFebAMYnnqf4JZx3AfmB1MXD+w8b5aVs4LBFvn/o5n1IbJUHAa73OVBE+PM1VK
	iFy3S9ZvHJzm3ZD2qUxg1mvNEq7uKfF5ZEflV5Ixn1wwPPMIJlTS75tR+ZKhTmOXieMhLikfhjA
	ECrtIt0GL0tbfmS67ZSm+UaKR3Nj52O2Kk7QO9J71MnUfvb/Wr9WbCDObNkObXWn5YYK1DPxUkB
	e3ftPHf4RNsa3XhxFt2BQhd45R1Gm8O3SY+RqKvXIyqqS1XCaF2ww8G7N3pOil08htmgeI26aVl
	eIEy57zGBRciAwgILr6LLYTme4oZf+SV2fIB0fPDoFg9C0oEK9yI47iSkdERbtqQJIIhJ92r9Xz
	EgFIj1hUiw3FJZTKdeK7zr/zAbE8Us4mw2oag6ASFk+N3Mdz+xWQ91r7twkyot+6Rs2QkbVigCE
	2E2umvIs8kOA==
X-Received: by 2002:a05:6512:6319:b0:5aa:70f9:b0b8 with SMTP id 2adb3069b0e04-5aa7430a39amr259985e87.10.1780335265467;
        Mon, 01 Jun 2026 10:34:25 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa62f7f539sm1696560e87.4.2026.06.01.10.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 10:34:25 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 1 Jun 2026 19:34:23 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
Subject: Re: [PATCH v3 3/6] mm/vmalloc: Extract vmap_set_ptes() to
 consolidate PTE mapping logic
Message-ID: <ah3Cn3YnefIVJDo2@milan>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-4-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522053146.83209-4-jiangwenxiaomi@gmail.com>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tt441pgn99phn487xy4ie7a3mmsbmdfp
X-Rspamd-Queue-Id: 8549D20007
X-HE-Tag: 1780335267-434034
X-HE-Meta: U2FsdGVkX193PTehzTNkqVD3MwJzLv2H5jJ4msO9jXeCUakHKWFoXgTLTMQIIlZm9LFXdr1Oz4hABazBL9djzIpHEKLqfz+B/Rr76pXTaa3pSvEu8PfQUs9Nnxm/DhvYKs2XGTkqwGf2SYhJT/7N3M3W1jroHuLD0KO/88R3pofw6r81jQSLQvt7k9WrlMHS+MPnezHrlXBTiKmS3PhEbh4gqpVdm7aOrUydYokX/dB1DwzZsGSa55kYjFX7k7DXtOspoPagM77z+ab/xZPBwQiTmibUKbCMQUYaJ+a7qF63Nu6myuYXEk4TZihLvCXh/TggP2fF8drYeW434yz/LeM3S/VOOdyrEzEnViwoFFNLJ3MmmsGmzi3XJH/9P5YisqqnHvr4i2H+leISasL3kKS3GTBxMpCEaYitCDWqBeD981E8oxoYSboaF8MXfp/dfq6NWEac1po0DbW8svBPKQW4ZXRb6cYvVoqF+QSwB34hPo0nx3s/nKWUiLn1x5+DH+vq6Phf12xZ96Gsz82mmEGvzNwuQgTIO3oSzsd1HIz0I4hTjjxWBXEvJfoZR25JHizYHSUk6BMSPaYsSbJ97c9x43RtrcomzNiVIMtTbUcFATy3pnlNP1SMbxrqXT6be4ohi3GgdrXFAvQWPpP+lwprqfOATCzFwMaDAxG5wa+TaaVZYX3Ljfvs8ss3c52PJz9UuuPhrqMVtiS0VfyHRC3jO14LuRz/Rn14CB/yBhooJLfyfazkwPv6xinsoOSY3gbeDapk8/seOJg3Ruol/5FFtvbPW0z3On1H8m7QzrmqKKi/RGCrqy4LWyFjB5oHCsunMLCtBtI4ZvCh9FUak6/iSxjtcgRNR1IOEXonSSsc3w7WoHTmDkSv3qfeFPZAAI9KjOLAyWRPBRvz/W/yq4ERe0yO9Gj4yKJ2osbO72FURmP7wJ8UPwZ7ciMflARDfNIVpqRvzn1+IYWEBqK
 mM0X0Usc
 waTZ6m7VM40TGvMY5xH9qGhS3TZyMSXa6sgT82SIw2x+c+c3EWmcLd7D++rd+0rFsWhA6q+pt2udpHPWLU+1Ck5H5rGrhwwZZRH2b11/HGkTTKpHFnFGlvSwcl58uub0UK2ZQ1UNuqnkNJlVyQH1HJNooyWTHV3nCDVsFktNDJ9hC9Zlnx6e/wuqXW9AcDrANyarmcWgB/k3z3ZEQF+4pDeFKruaRB5Fa+gS/QtReLzJyhuab6/sNIdrbnwb5XgcPHbTtDNhq6vY3W148eyC8FMTHS7prw25ykCRMjUhm96gUIQxFjzUu4KKNWzojjOTqF+/ynf3iUuSgeavkgXB9r89lp/ZI8V1OIqKwre17wxgtodzodCtmG8MhnPELuDOxUS0KKjKJV1+aoumTpmtGVnobcTy+5cTj97dgktVGL/dYuLV7tLym2e58mMsdRtohp/1J4kh/SiFQk+1NqKi6CK9wOM4WC9WTYqkhK8XH2c4o9neoLtnFo+z8QY/RvkcNms9hPI1K8/pCQSnntGswKUAYhP9y6Pcgmo5lDgOpMhH5mumu6+PSyQhDkXbHgGoGWMOBh6lNh/f9NmlgyOwodYc4N1MKgwnCHiC4nvkif/x1AUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 01:31:43PM +0800, Wen Jiang wrote:
> Extract the common PTE mapping logic from vmap_pte_range() into a
> shared helper vmap_set_ptes(). This handles both CONT_PTE and regular
> PTE mappings in a single function, preparing for the next patch which
> will extend vmap_pages_pte_range() to also use this helper.
> 
> The #ifdef CONFIG_HUGETLB_PAGE guard is moved inside vmap_set_ptes(),
> so callers no longer need to handle the conditional compilation.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 49 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 2c2f74a07f396..53fd4ee460ea4 100644
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
> @@ -98,7 +127,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	pte_t *pte;
>  	u64 pfn;
>  	struct page *page;
> -	unsigned long size = PAGE_SIZE;
> +	unsigned long size;
> +	unsigned int steps;
>  
>  	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
>  		return -EINVAL;
> @@ -119,20 +149,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
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
> -	} while (pte += PFN_DOWN(size), addr += size, addr != end);
> +		size = vmap_set_ptes(pte, addr, end, pfn, prot, max_page_shift);
> +		steps = PFN_DOWN(size);
> +	} while (pte += steps, pfn += steps, addr += size, addr != end);
>  
>  	lazy_mmu_mode_disable();
>  	*mask |= PGTBL_PTE_MODIFIED;
> -- 
> 2.34.1
> 
IMO, we should add just a helper with "no functional change" and second
patch will extend it.

Otherwise you added a helper which has already been slightly modified.

--
Uladzislau Rezki

