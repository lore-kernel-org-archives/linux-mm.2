Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9028108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 610306B0089; Fri, 20 Mar 2026 05:57:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E65D6B008A; Fri, 20 Mar 2026 05:57:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE096B008C; Fri, 20 Mar 2026 05:57:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9836B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:57:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EDD1140131
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:57:51 +0000 (UTC)
X-FDA: 84565989942.08.6A51682
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 41E332000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:57:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQRWsGQH;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZhQy9sYfs9QbFM4ofQ8Qic3K9F6jlM21wqnv9KjgSM=;
	b=dKWiYWW+TzkqC9se4M2RHDzXg4p2kHsp0McKJ57UmcXU6JoH7xo1F7cVM7hddy4wZ6ecDH
	Rzliv1xz6CVWu1tnB0LxMyv1ZCxKSYiQ8mIu+rXYC0pOrLBwIS/BSHveFqOpnCq+VXRdiV
	+udRzXruQrgHO3R3S7XkkzpSShACnIw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQRWsGQH;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000669; a=rsa-sha256;
	cv=none;
	b=ygxv30iUIdzD+nktKtQ7rthcsK8PaP0pOu0KGTRwndKaYRgi20vuFzm2K2VYDnW9lqoFyA
	c2ihWCDTaevT7c78mMRiYrmJhlHpx2CKDM0+u8sOgdDI2uLiJRreoN4LqeHKfsifxW2+BE
	aa+0ev7StgwBTNdY+6PHgWjsksQVzwU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 840DC60127;
	Fri, 20 Mar 2026 09:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857BBC4CEF7;
	Fri, 20 Mar 2026 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000668;
	bh=BHH+c4Y1mXQAFcGaqGCCWfuTYkgGp//q1BrbsXIDSaQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QQRWsGQH7qeVicMQ3QSUVrL6+6ykgppWH2udWWMxJcvzUOilTI2D7Y834vvr9Cqyt
	 icef8KeIyRBqnM8w4ArrDNWl6Ob6UJXBNgrvlMt/tBdIreYgyDBKMJlUoyuOasLmfa
	 iMtWGY20neqLWTJ9QFVatHUq5kcOHBKCnWsq8XUDgm0NFAhoArRULvDwYK/kV6czLG
	 7ILzyx2cbMCcr+fQ27sX6WdG5X0iCQZVcM/UkIyri/M4ayLGpsmDafgz5CXXcO9/eT
	 NoXV7TLdZ3AryMYN76uq3e720RaA8DpDZue8f2q9/TUxNy/PRtDVcIeYSQDOm+3jmm
	 Zksp5/xFc4XNg==
Message-ID: <1d300b3b-2476-4381-b8df-a680f486b284@kernel.org>
Date: Fri, 20 Mar 2026 10:57:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/23] mm: convert do_brk_flags() to use vma_flags_t
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vineet Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Brian Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Dinh Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej Mosnacek <omosnace@redhat.com>, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, selinux@vger.kernel.org
References: <cover.1773846935.git.ljs@kernel.org>
 <981ed1afcd19115432e61778e7d226a36f8f5c2b.1773846935.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <981ed1afcd19115432e61778e7d226a36f8f5c2b.1773846935.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qnrgdzkg89cshc8updpbokkwybpfh7bu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 41E332000C
X-HE-Tag: 1774000669-387287
X-HE-Meta: U2FsdGVkX195ev+VsBWVNMZZBhN9vBRXr2hZjMbvk9PwC0quiVo17fqtJXuoNT3JyZdX4AwpZ/7gb6eOziKg9hma2q9DHqChpAJxEBS+oB5gvee5F6lWylDGXtFpM1Hj2f9GKMlEnAja7DVuhCC3gpWV4lsRcLC8Vkun+TYCYhJAegd9WM0TNmdPmcm0oaZ2OTbbHWn9L21KpRoXRpqRsUoQnflodBgUH5TiIfdXHiDrruIzvEMRsDpFx7OvyYZ7TL8ZjDeTmYjk6V+8rHQIyf17tFH5SAEa+agCT6xCOrtTKp9GLWG3w3I6nRsJdyGkpzCy+izpjEUn5oH5I3M113bhqzb7CwTSq52kr10Nt8G08kCNpIUd5ZEicda3VX+M+R8ognlypjd5jiiplKSYf8iyZ82Nlc4mlDb2/Z2via/vnx3gh8/R6KLF5B9Hh0VpSxXTMrIQ4xh+O2CbJSJoO/lczgwiNMLnUTP1Av+4dYEeslkANgxgREJWDPRaHOjxxxaGG5y2XiXEuun4vPRBVAcePAyHAigwyXtLOJv+5rIfPj3V1y6QTLzjGpB7X1/Gaw6o9u8QDkvFgXqLBhoN1DMIBnbmd6bVXX4Hg/knjQJc8+BTz0NSaro+FwbtzQ6vrFq0m5VnPEGiRLKEbuM8su6rYIH+5Csf8VgjFZha24lzW51XmO50BdGAmcSCrFC0eg8FPr0hFFvrivDULRsUwu6FNj8Q3Cwa1tnKB8NNt5qccnQ6LhhASdWAA0NJv4T12WoerAtn/drYpJgxZ3ZK5M1x1BYBK1scZMkyTY72nnGRmkA16wC2sbGNCT1ym5VxG+EZDFjiIWxGmBlOPvAlgMM7pFOAx+rmoCKlb8RyBB+kBrwzpMOd/OyewxybkUfXW0L6hT44/ZY8HXUXKNrIWceEkX45jMjAEBKYUmDx1XWNt2bHyGPT0vONsZR/t8n7MAHLuZD+0dfBIYYgH8F
 dhBrGMVB
 UmjbT7oK3jEyJsZUGpTESCKrlH9wtsMpI9PEL6sTOaeG99ahgGnqpvKjP/MD+OHTRGjNzI/DZsx5vqHyniwRr0BqjhpP85I3t5+V4nwa4aYqXqJ2SeaP2X+kl+zuXQiU6ZG5DwJ0ZAnM9JsrcRUsK+B4XQptwtDDvHKVABiwJ+FezzIQeg8ro9QdX7/zPDkTiWUStjmqmutvr1TiA8vHjgSsctD6FLbdQjtFuOmSw3TmL+B4CIXBZdTtzUYwxwEIVG4dbJPQw9m5csHdZGCHCMV3tHmSp8VtKYhIkj53zxFut0Ge+Fu8xUJlZUI3vVWxt0ILkqocR19lIAgpMq94GjGXY8qCO/SemfMK5yyT4YiSLw1JOPvgIo4VgozykQAPwPEGGIQfEZQJcAm2/DfX/Oqkmw8g3W3ogpbpy3GaSCUWeO/RfbUzD3H2cOwKpZtwuq3/v3TS1L6c/thgEIwNsyynvQjpw5FEDwZJC/X2H3Gf+RN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 16:50, Lorenzo Stoakes (Oracle) wrote:
> In order to be able to do this, we need to change VM_DATA_DEFAULT_FLAGS
> and friends and update the architecture-specific definitions also.
> 
> We then have to update some KSM logic to handle VMA flags, and introduce
> VMA_STACK_FLAGS to define the vma_flags_t equivalent of VM_STACK_FLAGS.
> 
> We also introduce two helper functions for use during the time we are
> converting legacy flags to vma_flags_t values - vma_flags_to_legacy() and
> legacy_to_vma_flags().

Nit: this was done by an earlier patch.

> This enables us to iteratively make changes to break these changes up into
> separate parts.
> 
> We use these explicitly here to keep VM_STACK_FLAGS around for certain
> users which need to maintain the legacy vm_flags_t values for the time
> being.
> 
> We are no longer able to rely on the simple VM_xxx being set to zero if
> the feature is not enabled, so in the case of VM_DROPPABLE we introduce
> VMA_DROPPABLE as the vma_flags_t equivalent, which is set to
> EMPTY_VMA_FLAGS if the droppable flag is not available.
> 
> While we're here, we make the description of do_brk_flags() into a kdoc
> comment, as it almost was already.
> 
> We use vma_flags_to_legacy() to not need to update the vm_get_page_prot()
> logic as this time.
> 
> Note that in create_init_stack_vma() we have to replace the BUILD_BUG_ON()
> with a VM_WARN_ON_ONCE() as the tested values are no longer build time
> available.
> 
> We also update mprotect_fixup() to use VMA flags where possible, though we
> have to live with a little duplication between vm_flags_t and vma_flags_t
> values for the time being until further conversions are made.
> 
> Finally, we update the VMA tests to reflect these changes.
> 
> Acked-by: Paul Moore <paul@paul-moore.com>	[SELinux]
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

More nits below:

> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
> index b39cc1127e1f..e25d0d18f6d7 100644
> --- a/arch/arm64/include/asm/page.h
> +++ b/arch/arm64/include/asm/page.h
> @@ -46,7 +46,12 @@ int pfn_is_map_memory(unsigned long pfn);
>  
>  #endif /* !__ASSEMBLER__ */
>  
> -#define VM_DATA_DEFAULT_FLAGS	(VM_DATA_FLAGS_TSK_EXEC | VM_MTE_ALLOWED)
> +#ifdef CONFIG_ARM64_MTE
> +#define VMA_DATA_DEFAULT_FLAGS	append_vma_flags(VMA_DATA_FLAGS_TSK_EXEC, \
> +						 VMA_MTE_ALLOWED_BIT)

I wonder what's the bloat-o-meter impact of these #define's (this
arm64-specific one isn't the only one) being no longer compile-time-constants?

> +#else
> +#define VMA_DATA_DEFAULT_FLAGS	VMA_DATA_FLAGS_TSK_EXEC
> +#endif
>  
>  #include <asm-generic/getorder.h>
>  

> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h

>  
> +#define VMA_STACK_FLAGS	append_vma_flags(VMA_STACK_DEFAULT_FLAGS,	\
> +		VMA_STACK_BIT, VMA_ACCOUNT_BIT)
> +
> +/* Temporary until VMA flags conversion complete. */
> +#define VM_STACK_FLAGS vma_flags_to_legacy(VMA_STACK_FLAGS)
> +
>  #define VM_STARTGAP_FLAGS (VM_GROWSDOWN | VM_SHADOW_STACK)
>  
>  #ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
> @@ -536,8 +547,6 @@ enum {
>  #define VM_SEALED_SYSMAP	VM_NONE
>  #endif
>  
> -#define VM_STACK_FLAGS	(VM_STACK | VM_STACK_DEFAULT_FLAGS | VM_ACCOUNT)
> -
>  /* VMA basic access permission flags */
>  #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
>  #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
> @@ -547,6 +556,9 @@ enum {
>   */
>  #define VM_SPECIAL (VM_IO | VM_DONTEXPAND | VM_PFNMAP | VM_MIXEDMAP)
>  
> +#define VMA_SPECIAL_FLAGS mk_vma_flags(VMA_IO_BIT, VMA_DONTEXPAND_BIT, \
> +				       VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT)

Should VM_SPECIAL be also redefined using vma_flags_to_legacy()?

> +
>  /*
>   * Physically remapped pages are special. Tell the
>   * rest of the world about it:
> @@ -1412,7 +1424,7 @@ static __always_inline void vma_desc_set_flags_mask(struct vm_area_desc *desc,
>   * vm_area_desc object describing a proposed VMA, e.g.:
>   *
>   * vma_desc_set_flags(desc, VMA_IO_BIT, VMA_PFNMAP_BIT, VMA_DONTEXPAND_BIT,
> - *		VMA_DONTDUMP_BIT);
> + *              VMA_DONTDUMP_BIT);

Looks like spurious tabs-to-space change inconsistent with other instances.

>   */
>  #define vma_desc_set_flags(desc, ...) \
>  	vma_desc_set_flags_mask(desc, mk_vma_flags(__VA_ARGS__))
> @@ -4059,7 +4071,6 @@ extern int replace_mm_exe_file(struct mm_struct *mm, struct file *new_exe_file);
>  extern struct file *get_mm_exe_file(struct mm_struct *mm);
>  extern struct file *get_task_exe_file(struct task_struct *task);
>  
> -extern bool may_expand_vm(struct mm_struct *, vm_flags_t, unsigned long npages);
>  extern void vm_stat_account(struct mm_struct *, vm_flags_t, long npages);
>  
>  extern bool vma_is_special_mapping(const struct vm_area_struct *vma,
> diff --git a/mm/internal.h b/mm/internal.h
> index f98f4746ac41..80d8651441a7 100644

> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9681f055b9fc..eaa724b99908 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c

> @@ -773,19 +778,24 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  
>  	change_protection(tlb, vma, start, end, mm_cp_flags);
>  
> -	if ((oldflags & VM_ACCOUNT) && !(newflags & VM_ACCOUNT))
> +	if (vma_flags_test(&old_vma_flags, VMA_ACCOUNT_BIT) &&
> +	    !vma_flags_test(&new_vma_flags, VMA_ACCOUNT_BIT))
>  		vm_unacct_memory(nrpages);
>  
>  	/*
>  	 * Private VM_LOCKED VMA becoming writable: trigger COW to avoid major
>  	 * fault on access.
>  	 */
> -	if ((oldflags & (VM_WRITE | VM_SHARED | VM_LOCKED)) == VM_LOCKED &&
> -			(newflags & VM_WRITE)) {
> -		populate_vma_page_range(vma, start, end, NULL);
> +	if (vma_flags_test(&new_vma_flags, VMA_WRITE_BIT)) {
> +		const vma_flags_t mask =
> +			vma_flags_and(&old_vma_flags, VMA_WRITE_BIT,
> +				      VMA_SHARED_BIT, VMA_LOCKED_BIT);
> +
> +		if (vma_flags_same(&mask, VMA_LOCKED_BIT))

That converts the original logic 1:1, but I wonder if it's now feasible to
write it more obviously as "VMA_LOCKED_BIT must be set, VM_WRITE_BIT and
VM_SHARED_BIT must not" ?

> +			populate_vma_page_range(vma, start, end, NULL);
>  	}
>  
> -	vm_stat_account(mm, oldflags, -nrpages);
> +	vm_stat_account(mm, vma_flags_to_legacy(old_vma_flags), -nrpages);
>  	vm_stat_account(mm, newflags, nrpages);
>  	perf_event_mmap(vma);
>  	return 0;

> diff --git a/mm/vma.h b/mm/vma.h
> index cf8926558bf6..1f2de6cb3b97 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h

> +static inline bool is_data_mapping_vma_flags(const vma_flags_t *vma_flags)
> +{
> +	const vma_flags_t mask = vma_flags_and(vma_flags,
> +			VMA_WRITE_BIT, VMA_SHARED_BIT, VMA_STACK_BIT);
> +
> +	return vma_flags_same(&mask, VMA_WRITE_BIT);

Ditto?

> +}
>  
>  static inline void vma_iter_config(struct vma_iterator *vmi,
>  		unsigned long index, unsigned long last)
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 8134e1afca68..5cee8b7efa0f 100644

