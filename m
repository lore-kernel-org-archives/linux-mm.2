Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74B1CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:18:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6F68E0003; Mon, 13 Oct 2025 03:18:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEE48E0002; Mon, 13 Oct 2025 03:18:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EBDB8E0003; Mon, 13 Oct 2025 03:18:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7DD8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:18:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 024401DF31F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:18:10 +0000 (UTC)
X-FDA: 83992237182.20.B94579F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 69DD11C0006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:18:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X4R3k1LZ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760339889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xgtby1R+ixjx1pMkTnYHB1m+xGdkMwhg1wnNNo8jU6Q=;
	b=1kmv7pCvJ3K1jxiu9TiIWAR2jyNqIt/MLRGPxSTGZK69zgQIJf8+iqZB13JvhvsPjanTX0
	rw2rjQmyUie8m+JaHWbWNRIiOe3hCXuuN9dlWbAHGPBV+k7Ku9dTF6PR2c5ppiS0++o2JR
	tuLN2Ub/BXDXbjp+DagME0ayeXXnZkE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X4R3k1LZ;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760339889; a=rsa-sha256;
	cv=none;
	b=fF6h4Mf07JxUr4YcsdjQ/WEpYKeSnXu12omjF+2+UUNeDpAzlcRI7+cHLfVHrKPukgFEUI
	5YH6ykwDIrmeSRzTM67JsLg7YPNGnEHRS3FN3nyXVxgHorGJOxiWU18zPfp9uBSgB72MFT
	vws8/gBNs5D4WXOsnBi7gfHZdEDTtuo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08B35602FE;
	Mon, 13 Oct 2025 07:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43EAC4CEE7;
	Mon, 13 Oct 2025 07:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760339887;
	bh=YLv5InJLlW0GnvCcW21BMvEaiqUu0JrGPOOfzqOIL7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X4R3k1LZHzpGoa3CGNOP1VANnxZgqbYFTh3O1uI0UOUZI6egZH7DS9iXzCNanfPj6
	 5l4hRVdl8kug78iGi503BMwTf4nOfB4vvPqzfQblO8bANCTR0IepYFAi8pg4PmXcJl
	 v5mRsMXje08tODxTmyA5OIz0MV0Bp+hR52IAzNGX/P+svL+EdB5DLwEoWOUND+O6Kf
	 YuSG4fNpL6qP9OxqgNyTvU+dffpgHu93yEHMZLAsR25uNDeEeJ6nise1nSkPELIGCx
	 VGgNLmvwA2eaX+H2UuCy8fUgkQfgvKdAEN9XvtoacZlIyOarhWxcIvseAbwa+xrPpj
	 rWlSnFWp2aHtA==
Date: Mon, 13 Oct 2025 10:17:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lu Baolu <baolu.lu@linux.intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v5 2/8] mm: Actually mark kernel page table pages
Message-ID: <aOynozGF70jD3bo_@kernel.org>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
 <20250919054007.472493-3-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919054007.472493-3-baolu.lu@linux.intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 69DD11C0006
X-Stat-Signature: ogqqxmyrhbdx68zgxj715tf8rxwy1kw8
X-Rspam-User: 
X-HE-Tag: 1760339889-651354
X-HE-Meta: U2FsdGVkX1/sQvqGYdDmfxbY7jFB4mOVCmWEdbf186hUg3cSM5B6kXRzcQKS7jAUDUyP4n/Z3+sLtt0zxSRt+qA4KibARmoQZ9qvGn/2rH/b7SSE8dREl0jb1VIzIvJyfyLPpl/8FDB72X8oCego4nmc8QWGlivAbshA+eHo2QXiYVvqGWCHn78yck6aoLLA/KyJuiFegbsS8tLzoT51+5w87bWjlcsOmI+fc464NKX5ZMHb0TuedAq4Q3X1F8bIT7nBChAtssTi3O/JoHEs0oayZhgDHHF5flVS24o3zSujd9wEa3HsctI6gMtIz+mkFSFFq6xBtsNbyQuNzYFV+sTQbOtcvOUkQVqKqEX+ldFlHXReOValJTCeXcraQ0CZxm8MsPGnyNyk43FRo/bITO/m9c2GDunp1gbVeAauUiSJc9c0Wii9S2iMPtKi+/x/FYjLawAaja0LR1tJ54edw8x5I4YJKiHGJlJosXU5+3jRXtXc5kTe01LzoWky/vZm+rYz29u1h3+z5K+nJUv1bDGR3LzgWczAQSZRQWf/PMqvrmznyh+Y7mnp/NWYbi5L4kjxdntaZMihxaeb5qD91DtqTSkAXlB2yFoYLTxLWGkhXgrH84ZWNDHTf5VgVRoLWRh0BBlWljOYyP280GygipciYy1bBeZJ0QHCG9e3uRM1PYSBbVYbxvs7QFjzVAdBIRnoqJFYh1fKClEhncL+ZrETUim0OfihSokBYcZOKHiKgLODFoCIh7a9gxk50N8CVZG21ELqo6Qhqzh2isRYxGoZ1MTBJAABEAfbSpAuCK03UoZCxQiLGvZ4em5vqEFa79AgBMXf6gQrk7MBDGinJcEZHGs3zIjFCiCqmQsnDSugIvc2YoNqrOVpQa10SFIFCn8TGRhtv5xxs4kV5AAETpAOSvjhkl6vVxKvOJzDliA8WPhxnlwdL6ofmOVA3A/Cx5PGPQz2pkitBb+pcEm
 CR+zkoKW
 PKBlCb+oZJn7Ho3ZBAPecAVvYSIc3NERjyYgDtFeP/oFPmDGSiKgLGaASx4vKROVS4ruxPGl4CEBnbjQ1+cdmnCVyQIjC+YRwpPKriU52R63ZlZt1Jqpy3mxNdNDC0/ulMypGXHlG/wEPY/quqAYlQAHhQu7+zfT2JdWQzm5fSkvwr8wiWHJUDByuzFYP9EbW5QRoWWPiER4Z9Krx6aevWfEtYhYoLFc3Ec2yinSfrmcpQ8HiGV/hDzDZAUhiPfx+66xCfOFfMZCw12rNY/7Z5yJJI1pGmEdlRIEBkADfo+mO8DJ4llf5FGS33fDjsleTIKIzbPVDvGOFCMsYcckfDSIm11heUOqtAM8sA1oDdD/FVX4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:00PM +0800, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Now that the API is in place, mark kernel page table pages just
> after they are allocated. Unmark them just before they are freed.
> 
> Note: Unconditionally clearing the 'kernel' marking (via
> ptdesc_clear_kernel()) would be functionally identical to what
> is here. But having the if() makes it logically clear that this
> function can be used for kernel and non-kernel page tables.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/asm-generic/pgalloc.h | 18 ++++++++++++++++++
>  include/linux/mm.h            |  3 +++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
> index 3c8ec3bfea44..b9d2a7c79b93 100644
> --- a/include/asm-generic/pgalloc.h
> +++ b/include/asm-generic/pgalloc.h
> @@ -28,6 +28,8 @@ static inline pte_t *__pte_alloc_one_kernel_noprof(struct mm_struct *mm)
>  		return NULL;
>  	}
>  
> +	ptdesc_set_kernel(ptdesc);
> +
>  	return ptdesc_address(ptdesc);
>  }
>  #define __pte_alloc_one_kernel(...)	alloc_hooks(__pte_alloc_one_kernel_noprof(__VA_ARGS__))
> @@ -146,6 +148,10 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
>  		pagetable_free(ptdesc);
>  		return NULL;
>  	}
> +
> +	if (mm == &init_mm)
> +		ptdesc_set_kernel(ptdesc);
> +
>  	return ptdesc_address(ptdesc);
>  }
>  #define pmd_alloc_one(...)	alloc_hooks(pmd_alloc_one_noprof(__VA_ARGS__))
> @@ -179,6 +185,10 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  		return NULL;
>  
>  	pagetable_pud_ctor(ptdesc);
> +
> +	if (mm == &init_mm)
> +		ptdesc_set_kernel(ptdesc);
> +
>  	return ptdesc_address(ptdesc);
>  }
>  #define __pud_alloc_one(...)	alloc_hooks(__pud_alloc_one_noprof(__VA_ARGS__))
> @@ -233,6 +243,10 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
>  		return NULL;
>  
>  	pagetable_p4d_ctor(ptdesc);
> +
> +	if (mm == &init_mm)
> +		ptdesc_set_kernel(ptdesc);
> +
>  	return ptdesc_address(ptdesc);
>  }
>  #define __p4d_alloc_one(...)	alloc_hooks(__p4d_alloc_one_noprof(__VA_ARGS__))
> @@ -277,6 +291,10 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
>  		return NULL;
>  
>  	pagetable_pgd_ctor(ptdesc);
> +
> +	if (mm == &init_mm)
> +		ptdesc_set_kernel(ptdesc);
> +
>  	return ptdesc_address(ptdesc);
>  }
>  #define __pgd_alloc(...)	alloc_hooks(__pgd_alloc_noprof(__VA_ARGS__))
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..f3db3a5ebefe 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2895,6 +2895,9 @@ static inline void pagetable_free(struct ptdesc *pt)
>  {
>  	struct page *page = ptdesc_page(pt);
>  
> +	if (ptdesc_test_kernel(pt))
> +		ptdesc_clear_kernel(pt);
> +
>  	__free_pages(page, compound_order(page));
>  }
>  
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

