Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 408EAC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40FA86B0005; Sun, 12 Jul 2026 03:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E7916B0088; Sun, 12 Jul 2026 03:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FD816B0093; Sun, 12 Jul 2026 03:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEE26B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:46:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E70B4087D
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:46:28 +0000 (UTC)
X-FDA: 84979342056.30.2E0373C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 892071C0006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:46:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YnV5CLLN;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783842386;
	b=1NQ+/QTpzfKyXeP8ATKvHh494cHWyqWKY9QHQhnZxmKClEcKlvAecWeZBO6+i4XiIHsTap
	m29mcdxQQ8HvFHS4D1784fufxUNvVabtH1OJvywVT/UhrjxPDaWmD3ue8Erzxr4KIxfIGG
	E8PCTtilnGwXL+KPwnJXkF+xdYnqV5Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YnV5CLLN;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaWTjqm9JXhXtr4kD+z/Qmo/k+uwJ7cEWIhik1ibKBM=;
	b=P2fltbrRaYUuMP4J6YXo1EqlGVPmg0/LxYRa7f3AWnUmJik3ZFlKeFeT3ur3jyd48OfR5p
	wWsL1uOT+k8JujHy2SYV7VKuqY1TwDiZjYzDO3NlUc3HLUtNmWKkw7vFgKJPWKZN9nny5m
	9yLBk/6HwebbUq4snBJux8q0LOjwvc8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B1BA1682;
	Sun, 12 Jul 2026 00:46:21 -0700 (PDT)
Received: from [10.163.129.143] (unknown [10.163.129.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C97F3F85F;
	Sun, 12 Jul 2026 00:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783842385; bh=nohsd7GiLakObGLBaDIO4H+sVaQd7yxCodOtnB+4Jxk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YnV5CLLNFnCF8n0m7G1DlD52+qpTPsqCfAvqMWKko4vIjG5vQF3+EDtL/TowISGrD
	 Jks/j+ZCOhOowMhkoA7z0I626qdfwRYb+sNFzeo7vJarzWxk5cRtdIyqs/N/S0Vn+V
	 nbo69oXFxbzeFtCUOsbNptWEYbXqYGZaGsASZh48=
Message-ID: <daed9269-b397-4f6b-bfda-6d81e1be2f52@arm.com>
Date: Sun, 12 Jul 2026 13:16:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] Revert "arm64: Enable vmalloc-huge with ptdump"
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260710-series-vmap-race-fix-v1-2-5b3794c113fe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 892071C0006
X-Stat-Signature: qncsth3brof7cgcnj1fa1cuhka7q4cin
X-HE-Tag: 1783842386-733940
X-HE-Meta: U2FsdGVkX1/n6Rx3oXtiazh8m9bjcGliYwa199ulOcuO7zcOzafGDj5sjng+Xp6TT7VRGTwo1rVYe6i4ChxZpKaiMuYT+8lc5SbDlLHgdpO+4gUqyJZ0LiOEZdd/SOirEsIscwGTfsR28NbM92elBCkm1akNG256ZfZyTjTPBunuTQllHia57oO/raTAegQou+PRGzzXWMgXa4yGdqIiIAznbHMCmUrX+TrXSZsykhosVWs6/RLW41AUZPIziuJzX/r2iDOnOFW9qScQKDUiTiExCiNDLlC36MeGwWpWE+N+3qyA5768xar5cJfqVq4wtdwclchGItoMe1DqOyS+PuzLBBqi9+mUrVeS5z6TcWvi7Vyg++WjVGPRxPpci5/8AcWuQuqCIzYSMM15G8inPPU+iwLlylTSZ1qocsCH0z1vO+CYEwbG6OzVAcovw9d8fK/KVKduBvTeXykknWlcimc8h52nVpziV7oWgPIQTMUz4hZsqOKxMLME4g40KOIfa0J+o9exZzIyL41YFnSzQfyaTQO9CZZPxByds21gLpUhNe9LEV/vLmiEooVv8cywU/LuChj1Osv3iqJoSzEU5wvtdk6w9527C3MJflOV9HCxmXESk+pIwV1j+wTSzLbcFllI3t6FytxlU8Acz8MCROT3Jw/mgMC/YPuNYHcWMRSa3vRqhk0m2q+53kvRsUcWZBM+ju0XSPpfGOeFvzOnC4QWuDFA/7TLxSf/URK/x3DXL7EAhUrPaAlVp/NLTaj/IkfG8JtdZEVonMG6wODtpJvvZdZjcz+9MYt2LpsWmh8bBnJsxuxc1bmWUrgFtV+4jT4wPDIovv7I0f2DB1Ozdmyhp5q2b4Y29+Y7Jzl43XKNBju9YGax6aXBg8uGOm4eif9dEGYfgjgA3tjeAcjaKKeNTVG7mXnMDp/3qtaHQ85VEAziAY110g3jBWercM4LYGukm0CgHuGL4I00Dkl
 QeZMiSLM
 Wq9Kbl50WO1SyVlrv8fSDfiAaUhMfQD4lKVt8WtVMHXXaY1rfpdpf5+hfE5RyCrlaXQhFAZJzr1VctWGDaLzvuf87Hy464PGBhZa0PUxn8iAwTdrXqU8fyu4kQIQ0RcLWZLrEepKHZEdByFEX7R3W2QVaDI2tMJm+h3+Fec8DFna4pQS4BFvvlSmsJSKqI78/Lb4lxN3cHjE+OtQ1bLxoMpiboyspo6yWEl7KI3p4CoL00Ubqw9DecyGkaWWJSkHcPSri/lwu/KizIF937p1k6vnznj2/fiQ1WQMoRbqHmqHIW9fwicFQLfPZ3tHOfbeV/rF+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/07/26 4:19 pm, Lorenzo Stoakes wrote:
> This partially reverts commit fa93b45fd397 ("arm64: Enable vmalloc-huge
> with ptdump"), retaining vmalloc-huge support but eliminating the now
> redundant mitigation against a race between huge vmap page table freeing
> and ptdump, as this issue has now been fixed at core.
> 
> We also simultaneously remove the arm64 ifdeffery when acquiring the mmap
> read lock upon vmap huge page table promotion as it is no longer required.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

As pointed out by Mike, the subject line doesn't fit. Perhaps just start with
"Partially revert ..."


Reviewed-by: Dev Jain <dev.jain@arm.com>

>  arch/arm64/include/asm/ptdump.h |  2 --
>  arch/arm64/mm/mmu.c             | 43 ++++-------------------------------------
>  arch/arm64/mm/ptdump.c          | 11 ++---------
>  mm/vmalloc.c                    | 15 +++-----------
>  4 files changed, 9 insertions(+), 62 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
> index 5b374a6ab34a..50a195eda8ed 100644
> --- a/arch/arm64/include/asm/ptdump.h
> +++ b/arch/arm64/include/asm/ptdump.h
> @@ -7,8 +7,6 @@
>  
>  #include <linux/ptdump.h>
>  
> -DECLARE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
> -
>  #ifdef CONFIG_PTDUMP
>  
>  #include <linux/mm_types.h>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index f2be501468ce..f723bcf68174 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -49,8 +49,6 @@
>  #define NO_CONT_MAPPINGS	BIT(1)
>  #define NO_EXEC_MAPPINGS	BIT(2)	/* assumes FEAT_HPDS is not used */
>  
> -DEFINE_STATIC_KEY_FALSE(arm64_ptdump_lock_key);
> -
>  u64 kimage_voffset __ro_after_init;
>  EXPORT_SYMBOL(kimage_voffset);
>  
> @@ -1857,8 +1855,7 @@ int pmd_clear_huge(pmd_t *pmdp)
>  	return 1;
>  }
>  
> -static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
> -			       bool acquire_mmap_lock)
> +int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
>  {
>  	pte_t *table;
>  	pmd_t pmd;
> @@ -1870,25 +1867,13 @@ static int __pmd_free_pte_page(pmd_t *pmdp, unsigned long addr,
>  		return 1;
>  	}
>  
> -	/* See comment in pud_free_pmd_page for static key logic */
>  	table = pte_offset_kernel(pmdp, addr);
>  	pmd_clear(pmdp);
>  	__flush_tlb_kernel_pgtable(addr);
> -	if (static_branch_unlikely(&arm64_ptdump_lock_key) && acquire_mmap_lock) {
> -		mmap_read_lock(&init_mm);
> -		mmap_read_unlock(&init_mm);
> -	}
> -
>  	pte_free_kernel(NULL, table);
>  	return 1;
>  }
>  
> -int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
> -{
> -	/* If ptdump is walking the pagetables, acquire init_mm.mmap_lock */
> -	return __pmd_free_pte_page(pmdp, addr, /* acquire_mmap_lock = */ true);
> -}
> -
>  int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
>  {
>  	pmd_t *table;
> @@ -1904,36 +1889,16 @@ int pud_free_pmd_page(pud_t *pudp, unsigned long addr)
>  	}
>  
>  	table = pmd_offset(pudp, addr);
> -
> -	/*
> -	 * Our objective is to prevent ptdump from reading a PMD table which has
> -	 * been freed. In this race, if pud_free_pmd_page observes the key on
> -	 * (which got flipped by ptdump) then the mmap lock sequence here will,
> -	 * as a result of the mmap write lock/unlock sequence in ptdump, give
> -	 * us the correct synchronization. If not, this means that ptdump has
> -	 * yet not started walking the pagetables - the sequence of barriers
> -	 * issued by __flush_tlb_kernel_pgtable() guarantees that ptdump will
> -	 * observe an empty PUD.
> -	 */
> -	pud_clear(pudp);
> -	__flush_tlb_kernel_pgtable(addr);
> -	if (static_branch_unlikely(&arm64_ptdump_lock_key)) {
> -		mmap_read_lock(&init_mm);
> -		mmap_read_unlock(&init_mm);
> -	}
> -
>  	pmdp = table;
>  	next = addr;
>  	end = addr + PUD_SIZE;
>  	do {
>  		if (pmd_present(pmdp_get(pmdp)))
> -			/*
> -			 * PMD has been isolated, so ptdump won't see it. No
> -			 * need to acquire init_mm.mmap_lock.
> -			 */
> -			__pmd_free_pte_page(pmdp, next, /* acquire_mmap_lock = */ false);
> +			pmd_free_pte_page(pmdp, next);
>  	} while (pmdp++, next += PMD_SIZE, next != end);
>  
> +	pud_clear(pudp);
> +	__flush_tlb_kernel_pgtable(addr);
>  	pmd_free(NULL, table);
>  	return 1;
>  }
> diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
> index 1c20144700d7..5a76c59b5ada 100644
> --- a/arch/arm64/mm/ptdump.c
> +++ b/arch/arm64/mm/ptdump.c
> @@ -283,13 +283,6 @@ void note_page_flush(struct ptdump_state *pt_st)
>  	note_page(pt_st, 0, -1, pte_val(pte_zero));
>  }
>  
> -static void arm64_ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm)
> -{
> -	static_branch_inc(&arm64_ptdump_lock_key);
> -	ptdump_walk_pgd(st, mm, NULL);
> -	static_branch_dec(&arm64_ptdump_lock_key);
> -}
> -
>  void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
>  {
>  	unsigned long end = ~0UL;
> @@ -318,7 +311,7 @@ void ptdump_walk(struct seq_file *s, struct ptdump_info *info)
>  		}
>  	};
>  
> -	arm64_ptdump_walk_pgd(&st.ptdump, info->mm);
> +	ptdump_walk_pgd(&st.ptdump, info->mm, NULL);
>  }
>  
>  static void __init ptdump_initialize(void)
> @@ -360,7 +353,7 @@ bool ptdump_check_wx(void)
>  		}
>  	};
>  
> -	arm64_ptdump_walk_pgd(&st.ptdump, &init_mm);
> +	ptdump_walk_pgd(&st.ptdump, &init_mm, NULL);
>  
>  	if (st.wx_pages || st.uxn_pages) {
>  		pr_warn("Checked W+X mappings: FAILED, %lu W+X pages found, %lu non-UXN pages found\n",
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 9d0f1fdd6af3..537ff7b3c412 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -170,10 +170,7 @@ static int vmap_try_huge_pmd(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	 * Therefore, acquire the mmap read lock to prevent use-after-free when
>  	 * freeing page tables.
>  	 */
> -#ifndef CONFIG_ARM64
> -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> -#endif
> -	{
> +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
>  		if (!pmd_free_pte_page(pmd, addr))
>  			return 0;
>  		return pmd_set_huge(pmd, phys_addr, prot);
> @@ -230,10 +227,7 @@ static int vmap_try_huge_pud(pud_t *pud, unsigned long addr, unsigned long end,
>  		return pud_set_huge(pud, phys_addr, prot);
>  
>  	/* See comment in vmap_try_huge_pmd(). */
> -#ifndef CONFIG_ARM64
> -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> -#endif
> -	{
> +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
>  		if (!pud_free_pmd_page(pud, addr))
>  			return 0;
>  		return pud_set_huge(pud, phys_addr, prot);
> @@ -290,10 +284,7 @@ static int vmap_try_huge_p4d(p4d_t *p4d, unsigned long addr, unsigned long end,
>  		return p4d_set_huge(p4d, phys_addr, prot);
>  
>  	/* See comment in vmap_try_huge_pmd(). */
> -#ifndef CONFIG_ARM64
> -	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm)
> -#endif
> -	{
> +	scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
>  		if (!p4d_free_pud_page(p4d, addr))
>  			return 0;
>  		return p4d_set_huge(p4d, phys_addr, prot);
> 


