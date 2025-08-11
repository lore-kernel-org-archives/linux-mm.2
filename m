Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E649ACA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745E26B011E; Mon, 11 Aug 2025 04:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6486B0120; Mon, 11 Aug 2025 04:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5726B011F; Mon, 11 Aug 2025 04:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 465C66B011C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:11:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E74B382B8C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:11:13 +0000 (UTC)
X-FDA: 83763756426.08.733952F
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F6D81C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:11:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2nv20t+;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754899872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ikirbhZh3RT0runx5vWzABxjEiE566Wspw/E/T7F2Pk=;
	b=nNwy2+KMfL0hF7FDbCqzSX5Hvu/0nJia+bEBp/8KX1ck9dSWK2OzfomKgcHkaWNed0LHXj
	eU9aFdP4zyYqZjV9IXrEUn9Tva2J92blh2axdUwBydME7C/p3+ciNck1Wkb5d8usVrIqgn
	uHhLglgbsCCBXdEDgfvycT7EmKlzUko=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n2nv20t+;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754899872; a=rsa-sha256;
	cv=none;
	b=VeGG1WAMpNt2Blp5Xt9QcSFvFvLDJt3yFXLmwiog7r23PHt1zkSYKOsU/C5bGrHPZjusP1
	GTxx/fSQ4uaCEny02Ta4zP+HCIFZnb/A6v6dV4Nw4LKBNsfh8eimWRlMvKW2R+FVAQPmXC
	bZHs6kKdNmeHCcNwH47sQ2cYYs8TtY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D2CD45C5E02;
	Mon, 11 Aug 2025 08:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3FBC4CEED;
	Mon, 11 Aug 2025 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754899870;
	bh=P9xSC/pyU0TKP/viaDQllfkMkaKCa/vz5pDoZrB8kPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n2nv20t+OZ1SVWjStca14ZouasTHG019rln89ZLHpJCT5fVGXCjBcGNlJzzhnNGnd
	 RP77+2hVojJn3LH+sHswmFc35a5N5G07w+BcQBrDSBs1QW5bUe/dQsj5qzclZXne4M
	 gtByfM5ep5DKuNJXxhk/cfKhYb59v1t7gIjaTB3QnEqLbH5ZPGZrzM9r00LQdq+/Os
	 KnSMBGKo5n2ITzDIWtPy6m9ZMghMsI0pJgZHNfLexUzN64C41ZStFX1xVLkPpf45oA
	 UTug/hqzeCWy1SsGLeLOAqvFBVtfUIHJuTfxqqugzkwcs9lr1AcmXQWykziyo1DHTp
	 Q8SAgfcijMLLA==
Date: Mon, 11 Aug 2025 11:10:55 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
	Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@redhat.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>,
	Alexander Potapenko <glider@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Huth <thuth@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	Joerg Roedel <joro@8bytes.org>,
	Alistair Popple <apopple@nvidia.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	linux-arch@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 2/3] mm: introduce and use
 {pgd,p4d}_populate_kernel()
Message-ID: <aJmlj3bG6qb60Me0@kernel.org>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811053420.10721-3-harry.yoo@oracle.com>
X-Stat-Signature: 6he5symi6x96w1886kj36qqungjzamo1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3F6D81C0003
X-Rspam-User: 
X-HE-Tag: 1754899872-556273
X-HE-Meta: U2FsdGVkX190fObG8MnbknzZzaGHni3u4aPd7kaLsp+dRxZz/PfyjPytWxzfpwnW9zEnsdDugDV0ctuFA3s/CRpH0a2gkJn1htn3gASZc3vPgv+NZ32EhANSJV9y4FL7kgwjNO1vPNHCyjbl8/8fbNjIw1Z66GjuBUP3vUgihWNjxwobL+9WR51mL4j8aRWBjm7JcW4Me3AmNESsvLi2l50Dlow80wg0S25kZ82YHcWhIPkRMVk1nxAhcLj5DpnazIGl0vbtAOpsY4lwADdxXN9BHtwAC6JL7rkFNgkcu+MwyOI2j99wkeVwFuMvsfwseOJ/kMcGSsVVrL/xey20lyHpX08b2dupEz7UpVj+o/pp6fu85VXReV0CdWxwgm3ZdXsve+PRGoTy9bDoJ6YBENcCgP0Kg2qmjzHb01Ct0W7y1YXR1Zd7y36QQtW/uhx9fo+z9mz3YsyB8BDZiMtuPewqiEqHDHdpEildV00oIftpEHfeSx6QvMPRwsji7xwsklF6tkg+PNooeCnUbuSU5eotsw0SB8UL4DdSE3I0ns9uVdMiogj5cfC5sSkEc6Qn4+m+G29vkK6DjpTJGDB3pixRxxOfsguzQxrC3iQ2aEhIUcEb6NsQPCvJut1tMTpABfZHioBuyabWz8cwa7MrgUpiD72PaRjBt7OQONTAeCNGuOBwmflaUNETLXay0g08iQ4oRTt+OSUaBpyYx/cesPK4vGb3fBkTv548R32pD7OY50bPK0mFaGvM+VCb1mf6P9FlrFGH8AXThvAjL9AdQakONoqRUU5/jkUE/s3Uh34+tW6gEs1yIlhLuArRyeooArklr85KyQB+XffBL1E5LC0hXg/0dfWx4LSnXbyoglYr7YOBZL4umRaCwZqSaHDm5+bGuTOsnQsUqefojLyoQCi6t+g7WqeU/hoFejwu+odQcwn3HjtpASXgb8F4OduhE5lMBMTrJMPGrtICoGT
 9Qe59bRt
 lqaoRCX7WJTSppTzORJRmbnDsUORQOC7aQtl28ie01yIrUQGYtAFO2KQv3YnsOWF692cg3VtWWk1sMAsAhc8VzBoN0wQjQFBZsIwOd6kt9b2pWhcqNcDaED7u/8rH5qq98GNrtmEPmFowQFHh81XMseiaO6/Lm7v8Ci7ua8vXWm8s8MsU31MNPPk7QdLCTyil/mHBnn32W6GG5ihYjjyA8Iv/sJ2/lwwRvE325UpBWyrnBrIqZbtX7J/b68WdHkJbzTQ0LVCiFglU0FY5B2fVirXt/S077Vi62SVuGSWe/1G3BxSiMowirwNQu6meJ6t1OZS8HA7SNFBdhkzBdr9qeMMZaSXqc2dTaxPCzulxKDY9wgS8fLP+2+g9Lt0eQFgfhZhTOY+A61TqXxMO1K3doE7NfqoG/uSnGB37XLPb+kI4olhWnxKm08hAd4a5JX6WMSfaNP2IfMmb96NsPb6S/d59eHwXXZpDT20r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:34:19PM +0900, Harry Yoo wrote:
> Introduce and use {pgd,p4d}_populate_kernel() in core MM code when
> populating PGD and P4D entries for the kernel address space.
> These helpers ensure proper synchronization of page tables when
> updating the kernel portion of top-level page tables.
> 
> Until now, the kernel has relied on each architecture to handle
> synchronization of top-level page tables in an ad-hoc manner.
> For example, see commit 9b861528a801 ("x86-64, mem: Update all PGDs for
> direct mapping and vmemmap mapping changes").
> 
> However, this approach has proven fragile for following reasons:
> 
>   1) It is easy to forget to perform the necessary page table
>      synchronization when introducing new changes.
>      For instance, commit 4917f55b4ef9 ("mm/sparse-vmemmap: improve memory
>      savings for compound devmaps") overlooked the need to synchronize
>      page tables for the vmemmap area.
> 
>   2) It is also easy to overlook that the vmemmap and direct mapping areas
>      must not be accessed before explicit page table synchronization.
>      For example, commit 8d400913c231 ("x86/vmemmap: handle unpopulated
>      sub-pmd ranges")) caused crashes by accessing the vmemmap area
>      before calling sync_global_pgds().
> 
> To address this, as suggested by Dave Hansen, introduce _kernel() variants
> of the page table population helpers, which invoke architecture-specific
> hooks to properly synchronize page tables. These are introduced in a new
> header file, include/linux/pgalloc.h, so they can be called from common code.
> 
> They reuse existing infrastructure for vmalloc and ioremap.
> Synchronization requirements are determined by ARCH_PAGE_TABLE_SYNC_MASK,
> and the actual synchronization is performed by arch_sync_kernel_mappings().
> 
> This change currently targets only x86_64, so only PGD and P4D level
> helpers are introduced. In theory, PUD and PMD level helpers can be added
> later if needed by other architectures.
> 
> Currently this is a no-op, since no architecture sets
> PGTBL_{PGD,P4D}_MODIFIED in ARCH_PAGE_TABLE_SYNC_MASK.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/pgalloc.h | 24 ++++++++++++++++++++++++
>  include/linux/pgtable.h |  4 ++--
>  mm/kasan/init.c         | 12 ++++++------
>  mm/percpu.c             |  6 +++---
>  mm/sparse-vmemmap.c     |  6 +++---
>  5 files changed, 38 insertions(+), 14 deletions(-)
>  create mode 100644 include/linux/pgalloc.h
> 
> diff --git a/include/linux/pgalloc.h b/include/linux/pgalloc.h
> new file mode 100644
> index 000000000000..290ab864320f
> --- /dev/null
> +++ b/include/linux/pgalloc.h
> @@ -0,0 +1,24 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_PGALLOC_H
> +#define _LINUX_PGALLOC_H
> +
> +#include <linux/pgtable.h>
> +#include <asm/pgalloc.h>
> +
> +static inline void pgd_populate_kernel(unsigned long addr, pgd_t *pgd,
> +				       p4d_t *p4d)
> +{
> +	pgd_populate(&init_mm, pgd, p4d);
> +	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
> +		arch_sync_kernel_mappings(addr, addr);
> +}
> +
> +static inline void p4d_populate_kernel(unsigned long addr, p4d_t *p4d,
> +				       pud_t *pud)
> +{
> +	p4d_populate(&init_mm, p4d, pud);
> +	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
> +		arch_sync_kernel_mappings(addr, addr);
> +}
> +
> +#endif /* _LINUX_PGALLOC_H */
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index ba699df6ef69..0cf5c6c3e483 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1469,8 +1469,8 @@ static inline void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned
>  
>  /*
>   * Architectures can set this mask to a combination of PGTBL_P?D_MODIFIED values
> - * and let generic vmalloc and ioremap code know when arch_sync_kernel_mappings()
> - * needs to be called.
> + * and let generic vmalloc, ioremap and page table update code know when
> + * arch_sync_kernel_mappings() needs to be called.
>   */
>  #ifndef ARCH_PAGE_TABLE_SYNC_MASK
>  #define ARCH_PAGE_TABLE_SYNC_MASK 0
> diff --git a/mm/kasan/init.c b/mm/kasan/init.c
> index ced6b29fcf76..8fce3370c84e 100644
> --- a/mm/kasan/init.c
> +++ b/mm/kasan/init.c
> @@ -13,9 +13,9 @@
>  #include <linux/mm.h>
>  #include <linux/pfn.h>
>  #include <linux/slab.h>
> +#include <linux/pgalloc.h>
>  
>  #include <asm/page.h>
> -#include <asm/pgalloc.h>
>  
>  #include "kasan.h"
>  
> @@ -191,7 +191,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
>  			pud_t *pud;
>  			pmd_t *pmd;
>  
> -			p4d_populate(&init_mm, p4d,
> +			p4d_populate_kernel(addr, p4d,
>  					lm_alias(kasan_early_shadow_pud));
>  			pud = pud_offset(p4d, addr);
>  			pud_populate(&init_mm, pud,
> @@ -212,7 +212,7 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
>  			} else {
>  				p = early_alloc(PAGE_SIZE, NUMA_NO_NODE);
>  				pud_init(p);
> -				p4d_populate(&init_mm, p4d, p);
> +				p4d_populate_kernel(addr, p4d, p);
>  			}
>  		}
>  		zero_pud_populate(p4d, addr, next);
> @@ -251,10 +251,10 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
>  			 * puds,pmds, so pgd_populate(), pud_populate()
>  			 * is noops.
>  			 */
> -			pgd_populate(&init_mm, pgd,
> +			pgd_populate_kernel(addr, pgd,
>  					lm_alias(kasan_early_shadow_p4d));
>  			p4d = p4d_offset(pgd, addr);
> -			p4d_populate(&init_mm, p4d,
> +			p4d_populate_kernel(addr, p4d,
>  					lm_alias(kasan_early_shadow_pud));
>  			pud = pud_offset(p4d, addr);
>  			pud_populate(&init_mm, pud,
> @@ -273,7 +273,7 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
>  				if (!p)
>  					return -ENOMEM;
>  			} else {
> -				pgd_populate(&init_mm, pgd,
> +				pgd_populate_kernel(addr, pgd,
>  					early_alloc(PAGE_SIZE, NUMA_NO_NODE));
>  			}
>  		}
> diff --git a/mm/percpu.c b/mm/percpu.c
> index d9cbaee92b60..a56f35dcc417 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -3108,7 +3108,7 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
>  #endif /* BUILD_EMBED_FIRST_CHUNK */
>  
>  #ifdef BUILD_PAGE_FIRST_CHUNK
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  
>  #ifndef P4D_TABLE_SIZE
>  #define P4D_TABLE_SIZE PAGE_SIZE
> @@ -3134,13 +3134,13 @@ void __init __weak pcpu_populate_pte(unsigned long addr)
>  
>  	if (pgd_none(*pgd)) {
>  		p4d = memblock_alloc_or_panic(P4D_TABLE_SIZE, P4D_TABLE_SIZE);
> -		pgd_populate(&init_mm, pgd, p4d);
> +		pgd_populate_kernel(addr, pgd, p4d);
>  	}
>  
>  	p4d = p4d_offset(pgd, addr);
>  	if (p4d_none(*p4d)) {
>  		pud = memblock_alloc_or_panic(PUD_TABLE_SIZE, PUD_TABLE_SIZE);
> -		p4d_populate(&init_mm, p4d, pud);
> +		p4d_populate_kernel(addr, p4d, pud);
>  	}
>  
>  	pud = pud_offset(p4d, addr);
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 41aa0493eb03..dbd8daccade2 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -27,9 +27,9 @@
>  #include <linux/spinlock.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sched.h>
> +#include <linux/pgalloc.h>
>  
>  #include <asm/dma.h>
> -#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  
>  #include "hugetlb_vmemmap.h"
> @@ -229,7 +229,7 @@ p4d_t * __meminit vmemmap_p4d_populate(pgd_t *pgd, unsigned long addr, int node)
>  		if (!p)
>  			return NULL;
>  		pud_init(p);
> -		p4d_populate(&init_mm, p4d, p);
> +		p4d_populate_kernel(addr, p4d, p);
>  	}
>  	return p4d;
>  }
> @@ -241,7 +241,7 @@ pgd_t * __meminit vmemmap_pgd_populate(unsigned long addr, int node)
>  		void *p = vmemmap_alloc_block_zero(PAGE_SIZE, node);
>  		if (!p)
>  			return NULL;
> -		pgd_populate(&init_mm, pgd, p);
> +		pgd_populate_kernel(addr, pgd, p);
>  	}
>  	return pgd;
>  }
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

