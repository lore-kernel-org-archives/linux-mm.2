Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C863CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 07:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF6598E0006; Thu, 23 Oct 2025 03:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE838E0002; Thu, 23 Oct 2025 03:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE42D8E0006; Thu, 23 Oct 2025 03:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A94D68E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:10:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 510FB129A13
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:10:17 +0000 (UTC)
X-FDA: 84028505274.07.17BE1FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B0885180003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:10:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WcJFhi8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761203415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMqGJMYRfFxAYf5IaOH6KgByKQxfpp/XiiVrOhM/trU=;
	b=lEh6EUbigf0M1L9Drmoglk0rW7CmTRHqJscJx+TQMs8YUwo43o1L5GZcIoGK7sYdbEyIXM
	LdIgHgCmmISzLO5uSBMUJ9ZgaHuoJx8AQca7HiRb2uiCNmOA8qVLVI+0zeVTqj6slanFJI
	6oTVrgyy84SQgkSyF0kHkydWPN93nq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761203415; a=rsa-sha256;
	cv=none;
	b=RJ22BHcdhCsWCFNxr7GUS1B1cAup0iE9vZob1rgERA0o2sz1aR/89qBgXoMQ2aC/wMLNrH
	DjXP01VXvjuTg5DOv6pBfwoxhrkBu38P0ju5cEhUbQ5je3djWKqfz+WfbXfZSqWj+DYDsC
	NfebyEOyxwglALVzqDVkS/3pnW/pUso=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WcJFhi8t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6363605F3;
	Thu, 23 Oct 2025 07:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49433C4CEE7;
	Thu, 23 Oct 2025 07:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761203414;
	bh=3eigXBLiimevcUcf8KdhhD/v0+6ZZjko+MbkPytVjq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WcJFhi8tSHC6qd0/sKDdW4POrtY8pODQNVNADd8AbwXFN47Qw7Av6RR1wEc8y4kIg
	 JriUhZcFP08MpUvg7WoV5KC/BLx+T15pEJUTAZL4YKbdd0QUPaMUqNe6eKQei9BIPt
	 iZD6Lzb1MPz+qfvA9FiR+0j5SDrjIUzzy36JQEVxXKzf8CYmxDuEhZgEq0imUVzddw
	 FJQ6UC2tuwX6mBhwn7+8RGIo714r6Xcq43rmXGtlGUfLOhwwKygTbmAvh1S+7Y81rB
	 UNChcCRiu/B5WjBWPYRF0OnYurR8gHb34HJqm738Db4V7qykDKpHPE+nJCi3XDtEMS
	 a7N2hWzjZKP2Q==
Date: Thu, 23 Oct 2025 10:10:01 +0300
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
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v7 7/8] mm: Introduce deferred freeing for kernel page
 tables
Message-ID: <aPnUyYS8N9Lp59vS@kernel.org>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-8-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022082635.2462433-8-baolu.lu@linux.intel.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: ram4nxdtc9rz8c996sjfoktwd58n1k1x
X-Rspam-User: 
X-Rspamd-Queue-Id: B0885180003
X-HE-Tag: 1761203415-974578
X-HE-Meta: U2FsdGVkX1+eZyR7+pegQBu8KUlBUSVV4rvgYaDVBGwBfSVRDjU9Wdu4XkUj+CUSVDn+j7R+Ha/26bciLlQsw24vIG72frtSTBMFeixXflSHDH5q+jeHnAoNXORdRfYM0it7zz/HyVhDiVaG9x5ucbLY+aYd+Ko4p/g5qKyMAkk1OJgnhVY+f/Aa1kXmv5cApAiOEmUtsVU6UeSdqbqn+xdwvoa083BE71oMPCjPdo09OVOLlreqeR4wVox0E/GqlXjJgZk1wk5hVrW8ggz+B3QKnp19SQBms0invzjBVV6mMz2E2dtFRypAPJZcbwrHRFa2RV3MUGKPlKwvujGck0vwUgXayZT5in2NrEdlo1QJ7gXDSWtFDtT5Ps/mZ2+VALz3o24Plzx6HPjeMEMLq/jPT2Su+5+VrDfW03xNFKjtof5EZdoEktBa0AZHWEKVbnS/FiOV9wf1Sq2UWm7HVb3chleSXFcg9m3XPPYJOHaHwndWI7+1IpNQWxfTzTqw+uCl5QrpaN6ldjpJ1o/9xGs/k5n4HQouppueZM97UE07ELUzZ63K8pHctCY1zJsWDc5NNQk93EAZGo/dIhOetfnnuMNQzTteVXaKgSBsUeTe/wpiXnTU36ytWtqvCuaJuUkpyQCPKNDGJC7ABHn4HmAqGPjChszSUEexfCd3c+UX5ht/e4x7rEE7fBDrAUCEwEGMe27X/AI/mlYFpYHT94uuXdFO5XnGAuXAskU7YZreY0r3a4W1B2PGy1JGTQEq7JtTiTOLCvJs/v1E35oeRH9h/v/KC4JIdiyz9Z4EQx9seD82Flq2oWhAiOCud7C9s90tjiVY/5O6kMsdPfIAcWUUQSfpbiVvO2bFG7R+2JSOMLSrFA6l7BrfBXybbXJ493pUOZO4zsC6TowG2P/RF1YZv5Lv826Cq9epkmJo1TRn0w7px7h8cE5jvy76gufL2HHg/akgDjBxh8w5Zin
 rqdA12uK
 d890Wc66ZIvsTtyefOWRKCM3qCwEbnhLvF4GcfuphOqqBPfx7hG6YdhNnYhpZa3+g+RHvo3GryKvuvxVUTBshTcZi0KAIGQ5tZiamXTsR0hesPnLfGccyFfSr83gvlO6iaw0pTKglbRJWDgd1B/CAvZQl38BXziWMR7ssqMHt1bq/SXjvjKtCuhppr9QlOCATzzy8oQDueTjAikBWCdHKUJbnQ4LuHocjM3aYpwVpp13aBTiMhlr81mdYAkbRxhZSJLjj7gSl30LVNh8+Sb9y8O3KcUkLbgURdvMwdSPU1f45V3RMpdoZJqD29nXQLbgjL6pMNntCKkoDX1aVaVNS23OA3GUzwoeNK33AnVtP1ISB8F4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 04:26:33PM +0800, Lu Baolu wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This introduces a conditional asynchronous mechanism, enabled by
> CONFIG_ASYNC_KERNEL_PGTABLE_FREE. When enabled, this mechanism defers the
> freeing of pages that are used as page tables for kernel address mappings.
> These pages are now queued to a work struct instead of being freed
> immediately.
> 
> This deferred freeing allows for batch-freeing of page tables, providing
> a safe context for performing a single expensive operation (TLB flush)
> for a batch of kernel page tables instead of performing that expensive
> operation for each page table.
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/Kconfig           |  3 +++
>  include/linux/mm.h   | 16 +++++++++++++---
>  mm/pgtable-generic.c | 37 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 0e26f4fc8717..a83df9934acd 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -908,6 +908,9 @@ config PAGE_MAPCOUNT
>  config PGTABLE_HAS_HUGE_LEAVES
>  	def_bool TRANSPARENT_HUGEPAGE || HUGETLB_PAGE
>  
> +config ASYNC_KERNEL_PGTABLE_FREE
> +	def_bool n
> +
>  # TODO: Allow to be enabled without THP
>  config ARCH_SUPPORTS_HUGE_PFNMAP
>  	def_bool n
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 52ae551d0eb4..d521abd33164 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3031,6 +3031,14 @@ static inline void __pagetable_free(struct ptdesc *pt)
>  	__free_pages(page, compound_order(page));
>  }
>  
> +#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> +void pagetable_free_kernel(struct ptdesc *pt);
> +#else
> +static inline void pagetable_free_kernel(struct ptdesc *pt)
> +{
> +	__pagetable_free(pt);
> +}
> +#endif
>  /**
>   * pagetable_free - Free pagetables
>   * @pt:	The page table descriptor
> @@ -3040,10 +3048,12 @@ static inline void __pagetable_free(struct ptdesc *pt)
>   */
>  static inline void pagetable_free(struct ptdesc *pt)
>  {
> -	if (ptdesc_test_kernel(pt))
> +	if (ptdesc_test_kernel(pt)) {
>  		ptdesc_clear_kernel(pt);
> -
> -	__pagetable_free(pt);
> +		pagetable_free_kernel(pt);
> +	} else {
> +		__pagetable_free(pt);
> +	}
>  }
>  
>  #if defined(CONFIG_SPLIT_PTE_PTLOCKS)
> diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> index 567e2d084071..1c7caa8ef164 100644
> --- a/mm/pgtable-generic.c
> +++ b/mm/pgtable-generic.c
> @@ -406,3 +406,40 @@ pte_t *__pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
>  	pte_unmap_unlock(pte, ptl);
>  	goto again;
>  }
> +
> +#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> +static void kernel_pgtable_work_func(struct work_struct *work);
> +
> +static struct {
> +	struct list_head list;
> +	/* protect above ptdesc lists */
> +	spinlock_t lock;
> +	struct work_struct work;
> +} kernel_pgtable_work = {
> +	.list = LIST_HEAD_INIT(kernel_pgtable_work.list),
> +	.lock = __SPIN_LOCK_UNLOCKED(kernel_pgtable_work.lock),
> +	.work = __WORK_INITIALIZER(kernel_pgtable_work.work, kernel_pgtable_work_func),
> +};
> +
> +static void kernel_pgtable_work_func(struct work_struct *work)
> +{
> +	struct ptdesc *pt, *next;
> +	LIST_HEAD(page_list);
> +
> +	spin_lock(&kernel_pgtable_work.lock);
> +	list_splice_tail_init(&kernel_pgtable_work.list, &page_list);
> +	spin_unlock(&kernel_pgtable_work.lock);
> +
> +	list_for_each_entry_safe(pt, next, &page_list, pt_list)
> +		__pagetable_free(pt);
> +}
> +
> +void pagetable_free_kernel(struct ptdesc *pt)
> +{
> +	spin_lock(&kernel_pgtable_work.lock);
> +	list_add(&pt->pt_list, &kernel_pgtable_work.list);
> +	spin_unlock(&kernel_pgtable_work.lock);
> +
> +	schedule_work(&kernel_pgtable_work.work);
> +}
> +#endif
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

