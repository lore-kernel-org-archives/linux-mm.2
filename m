Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A5DDFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B3B6B00E1; Tue, 28 Apr 2026 16:47:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBAF6B00E3; Tue, 28 Apr 2026 16:47:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D29C6B00E4; Tue, 28 Apr 2026 16:47:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 621126B00E1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C55B1B977E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:14 +0000 (UTC)
X-FDA: 84709149588.13.2461042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6E6A7A0002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xf2bKYwj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdUfw4IeCgIMCoAWsWkDKE0oeNspEa5ioTGezq5wVp4=;
	b=fNZTztzICx88y9n4lvHHyOVL1UWKZ8ecaIZawO/r+gvT0O4kiyigI7IYIRyMpoGF2WcdQw
	wGXbRYy5F2AYJpQcsAEv4Ok0FaP0GQbGg5Uh3UCZQQYQlS6l3mSTJVFpua7WzCSeOPqn5C
	WJVRZryT0ZDMPt4JalwYCsMVpEgN1to=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xf2bKYwj;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409232; a=rsa-sha256;
	cv=none;
	b=BtIIWMUxLS/IkV5QYyNnH/YvUuYkU7WOiYKhGLnH5ey5WzLqExgYb0ieBeT131yK9wVlD9
	WCGXHJ1d0inZ7lN4Iiy0xB4/EwjVxJsDCYifxkG+3wUZ/Z0Y57vZwFlehUfZlmUJVtbGip
	UoBRkjcFIBiPnqzMsjKyPB/F0Ma5YXc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A37543FE5;
	Tue, 28 Apr 2026 20:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE85C2BCB3;
	Tue, 28 Apr 2026 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409231;
	bh=CU6G6tj4vXedgJRhFz5ZO5lzJp2jRWmWy6Up5ktVms4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xf2bKYwjJNCV0jae+hBeDEUsIB0+8jRcPCQXAcudSDX/F9tO1cfzBnm8wsLiTAvUX
	 If+od6ZnFzX1TD+BUaI3r+Ny98ua9IL+pVEJUlG5N5N0PiUKmpWyZezLBJGCORN3rT
	 Z63kLXbawnCR+gmhiSfWJnUr30DtQnkalg0wM/U8qTa54ErJlXsS98TWy5DzYp8w2e
	 uarmut0FN4qz9Y8vIwS8ZUTk0sHc3iMsOZPYEzvA2WPKz0WequNRtV2RO771KxcVLg
	 yORPZaBPWmTa3L+7BSb/yEa+b3goCczuHCNVr5jLQdNRNLCCCoMz4QOfZhjhI4GjC0
	 7ROblFqdW2QSg==
Date: Tue, 28 Apr 2026 22:47:01 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
Message-ID: <afEcxTmjX20zyx44@kernel.org>
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E6A7A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: epq5m8uao95rdwaznn3dyo7bkeh7rrxj
X-HE-Tag: 1777409232-615059
X-HE-Meta: U2FsdGVkX1/9bzSQxc8TAjru5PgT1sObux7ynWiJL3oRpwPYEBJlXSktTdKFE4O4LKAanU3jZobNO78ehb3Zp9bdpzkzCcrNCe6hVcXyGNX0qrjq4OrIvZ62m4gh4oIj2hi/8kFbPy9spd44RgfPo8nOrTcrMwhdJ7XXQyvghhiBO0GFVl4hgp0qJOKD380iFaYJCUG1u/xNPiPLDmY4fex2BeRWtoiA8oCQl1sMV4kLe6TOEVXSP2lThBRc9RdYl/M2ZP0XxXnInO9hqUWwJ693S45aRDvkc6PaufMAaMrOun7MKfIkU3wlalbw57PgKozPyVaJxpTTzK3DMGGdkpyY3SK+3o1fiZkzrA9vCAWuD1jf10yOa4qeTXynKzIBaz+WIdD0znn+8pRivCBOc6ZFjLPkDjj3j4Ysh45QGIS6UT0xsMphN80jyPcP1kS3awc3qN5izDLNsI1AHRoSdNvSGu15gd6W+vhrm1rtu4CMDAIHpawejLuzbJ4Uv+ABE2dQC4aIUd41ehQnLIa/3q5Pdmo374JI6MlaIs355Cw73csJB+Hb34LTlhIhv9507aJIJgu+Tatx98LMJz15tpFaldN3thk/8k2Pw8afQlj+PubfrgBOPwVQsr8f1zGU++PLfERDu5QLI6b+EdTe3GlJNx1nyccTtjWgEsGgpow9KncWlY36grFYi3lh4VcTfoCj35NuBytyVSzvtqDRotEEdqCG5N8hwqDzIoaflNuwpWuhM8/XBcBoOn19fyLPgiLLseLDQi5YZAKYS+xwq52kw3HpvBi6Gbaemz49QP1wPxNXAwU3jn9JHO5wQeXvGE8Z0702QEIzThpj6BC9UY1/go1HP4Zu9raiVRWFkQfVjgOkgvdiUPg6qpUtShONrOKlct97Vp7KFMtvK+iVxmtE6suSY4EZwQpA0KVipnkqSr3PSf/lQubQmu4Y7rz9gUrQbfSH6Xo8Bvam2zk
 5XgKQtbF
 Z6/sXzO/tIMTWF8ViMLFEg6LjMEcAL1PaOCbaZ9q0QKGqY7lc9j5iKfZUhxvMCQDMnbYxB98hQxHR20FR9JDZaN6+ZOCSyD93Wj0jkBihx+pReWsm8urwPNmUFwHlPpKr5CaRYz5NfrmY+MO6y9VXzw+0Jj7V+KL8dWCl334ROSjttuZocjb9PE3LT3m4KexK6pFAioxzgBlDx4VvhD/aYO83GcGI17zVUvDr8uam96faDlyZ+vCW+81zluOwyrYumZYva4ED/DcyOoXecaNfSwR6qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 12:29:36PM +0200, David Hildenbrand (Arm) wrote:
> In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched
> from freeing non-boot page tables through __free_pages() to
> pagetable_free().
> 
> However, the function is also called to free vmemmap pages.
> 
> Given that vmemmap pages are not page tables, already the page_ptdesc(page)
> is wrong. But worse, pagetable_free() calls
> 
> 	__free_pages(page, compound_order(page));
> 
> As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
> except for HVO, which doesn't apply here -- we will only free the first
> page when freeing a PMD-sized vmemmap page, leaking the other ones.
> 
> Fix it by properly decoupling pagetable and vmemmap freeing.
> free_pagetable() no longer has to mess with SECTION_INFO, as only the
> vmemmap is marked like that in register_page_bootmem_memmap().
> 
> While at it, just wire up the altmap parameter for remove_pte_table().
> Also, the indentation in remove_pmd_table() is messed up, let's fix that
> while touching it.
> 
> Note that we'll try to get rid of that bootmem info handling soon. For
> now, we'll handle it similar to free_pagetable(), just avoiding the
> ifdef.
> 
> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> Reproduced and tested with a simple VM with a virtio-mem device,
> repeatedly adding and removing memory.
> 
> Found by code inspection while working on bootmem_info removal.
> ---
>  arch/x86/mm/init_64.c | 43 +++++++++++++++++++++++++++----------------
>  1 file changed, 27 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index df2261fa4f98..8d03e44a7fb9 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(struct page *page, int order)
>  #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
>  		enum bootmem_type type = bootmem_type(page);
>  
> -		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
> +		if (type == MIX_SECTION_INFO) {
>  			while (nr_pages--)
>  				put_page_bootmem(page++);
>  		} else {
> @@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(struct page *page, int order)
>  	}
>  }
>  
> -static void __meminit free_hugepage_table(struct page *page,
> +static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
>  		struct vmem_altmap *altmap)
>  {
> -	if (altmap)
> -		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
> -	else
> -		free_pagetable(page, get_order(PMD_SIZE));
> +	if (altmap) {
> +		vmem_altmap_free(altmap, 1u << order);
> +	} else if (PageReserved(page)) {
> +		unsigned long nr_pages = 1 << order;
> +
> +		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
> +		    bootmem_type(page) == SECTION_INFO) {
> +			while (nr_pages--)
> +				put_page_bootmem(page++);
> +		} else {
> +			free_reserved_pages(page, nr_pages);
> +		}
> +	} else {
> +		__free_pages(page, order);
> +	}
>  }
>  
>  static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
> @@ -1093,7 +1104,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
>  
>  static void __meminit
>  remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
> -		 bool direct)
> +		 bool direct, struct vmem_altmap *altmap)
>  {
>  	unsigned long next, pages = 0;
>  	pte_t *pte;
> @@ -1118,7 +1129,7 @@ remove_pte_table(pte_t *pte_start, unsigned long addr, unsigned long end,
>  			return;
>  
>  		if (!direct)
> -			free_pagetable(pte_page(*pte), 0);
> +			free_vmemmap_pages(pte_page(*pte), 0, altmap);
>  
>  		spin_lock(&init_mm.page_table_lock);
>  		pte_clear(&init_mm, addr, pte);
> @@ -1153,25 +1164,25 @@ remove_pmd_table(pmd_t *pmd_start, unsigned long addr, unsigned long end,
>  			if (IS_ALIGNED(addr, PMD_SIZE) &&
>  			    IS_ALIGNED(next, PMD_SIZE)) {
>  				if (!direct)
> -					free_hugepage_table(pmd_page(*pmd),
> -							    altmap);
> +					free_vmemmap_pages(pmd_page(*pmd),
> +							   PMD_ORDER, altmap);
>  
>  				spin_lock(&init_mm.page_table_lock);
>  				pmd_clear(pmd);
>  				spin_unlock(&init_mm.page_table_lock);
>  				pages++;
>  			} else if (vmemmap_pmd_is_unused(addr, next)) {
> -					free_hugepage_table(pmd_page(*pmd),
> -							    altmap);
> -					spin_lock(&init_mm.page_table_lock);
> -					pmd_clear(pmd);
> -					spin_unlock(&init_mm.page_table_lock);
> +				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
> +						   altmap);
> +				spin_lock(&init_mm.page_table_lock);
> +				pmd_clear(pmd);
> +				spin_unlock(&init_mm.page_table_lock);
>  			}
>  			continue;
>  		}
>  
>  		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
> -		remove_pte_table(pte_base, addr, next, direct);
> +		remove_pte_table(pte_base, addr, next, direct, altmap);
>  		free_pte_table(pte_base, pmd);
>  	}
>  
> 
> ---
> 
> base-commit: a2ddbfd1af0f54ea84bf17f0400088815d012e8d
> 
> change-id: 20260428-vmemmap-ab4b949aa727
> 
> --
> 
> Cheers,
> 
> David
> 

-- 
Sincerely yours,
Mike.

