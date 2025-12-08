Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77EED3B7DE
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 11:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FBE6B0005; Mon,  8 Dec 2025 06:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C50356B0007; Mon,  8 Dec 2025 06:19:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65CE6B0008; Mon,  8 Dec 2025 06:19:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A63146B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:19:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 595F7C0A8C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:19:50 +0000 (UTC)
X-FDA: 84196058940.15.20C3818
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 80BD41C0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 11:19:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KJyCOd0s;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765192788; a=rsa-sha256;
	cv=none;
	b=EBwBVTUrQycrAbGn4gOKB6TdwGiIuqHlsaVdc3Zhjg0e1R4ahi/+1ECbEz23zWjKuR9Crd
	v0GjqmrItHIPnBvsGnTiOSwieSxq7JnqDvwzjqpuQiCL439m3YGmfe9wRJ/RoGVLjgk6yI
	QNOeFl533HVg/OvYQ5Ziiu9yPk2LiRY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765192788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJ+UX1f/i7J9Lg9XaP0g4tjEJcH8V9NR5R44t+064a8=;
	b=bBfxkwZRZJfRXiCYpZijcOEdrlTgScuHZExTH6Xxr5Qyl/zWKoQaO2M9+13gmC5olf8dJU
	qeVzA3ABR71kVJQPC6qe6j1UzQb+B+8dWriAD09rJeoFhmAOe9MlChwQWO/udOEIiz8QB3
	sVocw9sN4ns072YKinkIi4lOC8rYI9k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KJyCOd0s;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 788B34446B;
	Mon,  8 Dec 2025 11:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DCAC19421;
	Mon,  8 Dec 2025 11:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765192787;
	bh=utFRhFXUCE6FElyvINX/I4j0gvr5jg6S50AXtbxYzJ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KJyCOd0sbc5PFglHH+kOhFKv/Fw0iRUEQWpq9FLXAuO1oDYIgOazxilVyYyuaQ+Cr
	 A15raKGZnm/DWRk/wHCbfQ6IZ1a7Qk0jKfr65KHHgz8ffFIcYWqWYCDdxg4WcdFPns
	 +yxdBylwRBYyOiZtySBX1W6eQa2AvxdcG4TqTsYGlrc+f3yoG0p6VS2iJwo+wx42ZE
	 +FoUSa0QUEKcF9HxrUpnyXcCxtQy6/PUhRXCsCwH2icnb0kpAnnErOlMJekBCH2U9u
	 tqhvP6c7NAgeSxEiYfDWFeFR9lqYEBx6hwa7YmTN5fRq3hzWFIfoRlLrfPen/e5WHe
	 5bZ+vKJfmrz1g==
Message-ID: <3b7ff190-4efe-47d0-82fb-68135a031b0f@kernel.org>
Date: Mon, 8 Dec 2025 12:19:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 05/37] mm/{mprotect,memory}: (no upstream-aimed
 hack) implement MM_CP_DAMON
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251208062943.68824-1-sj@kernel.org>
 <20251208062943.68824-6-sj@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251208062943.68824-6-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 80BD41C0007
X-Stat-Signature: wtd5xrnrc5uszhwxzg7hcemfb7kf7b58
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765192788-936867
X-HE-Meta: U2FsdGVkX1/CqIZvCjvHmj6X7wKjsNRrwGSYjHz7Vf7VJVqf097N0rNQMAetCLtyvXXwgB3yHEW3HI197D8NO7EGS3gSlrik62umZADO8He7xOoXss6u1gRrqqrCjoBuCO50ZPiK+kEwAiGZo4DHa/NJHIiCXNofi7puYlK8Km65YVgoE1sTyHA+LWnYlvdAPiMwDFt/vajFH5dkcIzKHC07jLpXKwdhEHTHDsMJok3nrwtMXv4qVbsQGlbrTzNNCn14SJTpiKdTbZAwSuRvbmLATXKUmuiYu2cZqs79OMgrogAqyo+B1Jl4quxxyeebZDerawqyWPf+qvpgipH2o/gHJFIysccl1aWoOrGcCbsZvbK2V4gGKFtSf7XQtr9qk9J+OKENcHusOwP2FinEKkIpDoY5WxcJihXxazXNa0YTRoa51B4GiGLoonrgPEkLzenDcZmyhhKaShBywePwyLRa5eRi/rJP3e5dwC5gYu1uHhN6iSub4vqDwVl6MI8fmE3VqHjj17J5AQhOZLsjD2qKGNoUW1BvqrFAmnol1VyTm0exUWoKXZBRN9z7BvBfOCqJUQTteYFQaCTvqY+uHHF69yVc3IoIH5f6Fax5lGjH/FLch58wkd6/PMpZ7OjEEjnaceQxgjoovjemMtNqaYmw3k0D+LhUgiGT2hHlOUkS2ueDIf9rx/hywo4cSd6E5OG3ZVnZ1+PqAdkXRKqY5BiP66ICjoCvN+J931R+RDIkBlk36FT555/n28sCODJiPnsKBs2owTfcdPxUH+iC6apbRBl0kvosIfNG5Pl+iF/4am/7omm4d69z77jXBQrjCSyG2EF06JSJXbxdIzg/cgYz9U/EsJddCzQBE6NbVOj76xsWMC4ITgl4L1qAI4mw2ROfKsDiEGeELhWFUWKWDvuluQ3AMBHroEiWkmz5zrO06Ge2/TAFKHTOQkM17XIfSsL2EuErGFOo84ZqM+y
 MNKu3tYr
 SwXTedHCLjAf5l5kLKht5GKULzGCj1lsKd3l0CtraeqQjcNqbrJK94Vw0EXR3lEW7y7TsarvfGgkbGKGYYYIwaAzpr1buyTRtMyfDWj3XZexjEo59Cx/kHbW2M67BIogv3TLAsvf68clgdglJGVPv/Tyh7sriIwxZoSWTSUjiZr7GlDx77Ir8rv51j6kxku3i635W/teQkomxna5rUE1TSDKabOZu0j+/AzBvTD6oVqIHWY7YQUTxWDRiMxi9KjQeHZ49ju05x34RcrQCq0jemUNc+eFdAZd3Z3IvlcVaV13AI1HS+tuRBntwV+7XsiQX6uauV9dyQYLnUq9It0UrYftIVEo8m3fkp/hi47E6IrceGH2ykKBwPt79dYihZfTEZqSK6LUPP67t2t5t1gGkCZGhVLerrwCklcRzjWDH2tdvYZo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/8/25 07:29, SeongJae Park wrote:
> Note that this is not upstreamable as-is.  This is only for helping
> discussion of other changes of its series.
> 
> DAMON is using Accessed bits of page table entries as the major source
> of the access information.  It lacks some additional information such as
> which CPU was making the access.  Page faults could be another source of
> information for such additional information.
> 
> Implement another change_protection() flag for such use cases, namely
> MM_CP_DAMON.  DAMON will install PAGE_NONE protections using the flag.
> To avoid interfering with NUMA_BALANCING, which is also using PAGE_NON
> protection, pass the faults to DAMON only when NUMA_BALANCING is
> disabled.
> 
> Again, this is not upstreamable as-is.  There were comments about this
> on the previous version, and I was unable to take time on addressing
> those.  As a result, this version is not addressing any of those
> previous comments.  I'm sending this, though, to help discussions on
> patches of its series, except this one.  Please forgive me adding this
> to your inbox without addressing your comments, and ignore.  I will
> establish another discussion for this part later.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   include/linux/mm.h |  1 +
>   mm/memory.c        | 60 ++++++++++++++++++++++++++++++++++++++++++++--
>   mm/mprotect.c      |  5 ++++
>   3 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 553cf9f438f1..2cba5a0196da 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2848,6 +2848,7 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>   #define  MM_CP_UFFD_WP_RESOLVE             (1UL << 3) /* Resolve wp */
>   #define  MM_CP_UFFD_WP_ALL                 (MM_CP_UFFD_WP | \
>   					    MM_CP_UFFD_WP_RESOLVE)
> +#define MM_CP_DAMON                        (1UL << 4)
>   
>   bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>   			     pte_t pte);
> diff --git a/mm/memory.c b/mm/memory.c
> index 6675e87eb7dd..5dc85adb1e59 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -78,6 +78,7 @@
>   #include <linux/sched/sysctl.h>
>   #include <linux/pgalloc.h>
>   #include <linux/uaccess.h>
> +#include <linux/damon.h>
>   
>   #include <trace/events/kmem.h>
>   
> @@ -6172,6 +6173,54 @@ static vm_fault_t wp_huge_pud(struct vm_fault *vmf, pud_t orig_pud)
>   	return VM_FAULT_FALLBACK;
>   }
>   
> +/*
> + * NOTE: This is only poc purpose "hack" that will not be upstreamed as is.
> + * More discussions between all stakeholders including maintainers of MM core,
> + * NUMA balancing, and DAMON should be made to make this upstreamable.
> + * (https://lore.kernel.org/20251128193947.80866-1-sj@kernel.org)
> + *
> + * This function is called from page fault handler, for page faults on
> + * P{TE,MD}-protected but vma-accessible pages.  DAMON is making the fake
> + * protection for access sampling purpose.  This function simply clear the
> + * protection and report this access to DAMON, by calling
> + * damon_report_page_fault().
> + *
> + * The protection clear code is copied from NUMA fault handling code for PTE.
> + * Again, this is only poc purpose "hack" to show what information DAMON want
> + * from page fault events, rather than an upstream-aimed version.
> + */
> +static vm_fault_t do_damon_page(struct vm_fault *vmf, bool huge_pmd)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct folio *folio;
> +	pte_t pte, old_pte;
> +	bool writable = false, ignore_writable = false;
> +	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
> +
> +	spin_lock(vmf->ptl);
> +	old_pte = ptep_get(vmf->pte);
> +	if (unlikely(!pte_same(old_pte, vmf->orig_pte))) {
> +		pte_unmap_unlock(vmf->pte, vmf->ptl);
> +		return 0;
> +	}
> +	pte = pte_modify(old_pte, vma->vm_page_prot);
> +	writable = pte_write(pte);
> +	if (!writable && pte_write_upgrade &&
> +			can_change_pte_writable(vma, vmf->address, pte))
> +		writable = true;
> +	folio = vm_normal_folio(vma, vmf->address, pte);
> +	if (folio && folio_test_large(folio))
> +		numa_rebuild_large_mapping(vmf, vma, folio, pte,
> +				ignore_writable, pte_write_upgrade);
> +	else
> +		numa_rebuild_single_mapping(vmf, vma, vmf->address, vmf->pte,
> +				writable);
> +	pte_unmap_unlock(vmf->pte, vmf->ptl);
> +
> +	damon_report_page_fault(vmf, huge_pmd);
> +	return 0;
> +}
> +
>   /*
>    * These routines also need to handle stuff like marking pages dirty
>    * and/or accessed for architectures that don't do it in hardware (most
> @@ -6236,8 +6285,11 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>   	if (!pte_present(vmf->orig_pte))
>   		return do_swap_page(vmf);
>   
> -	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
> +	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
> +		if (sysctl_numa_balancing_mode == NUMA_BALANCING_DISABLED)
> +			return do_damon_page(vmf, false);
>   		return do_numa_page(vmf);
> +	}
>   
>   	spin_lock(vmf->ptl);
>   	entry = vmf->orig_pte;
> @@ -6363,8 +6415,12 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>   		return 0;
>   	}
>   	if (pmd_trans_huge(vmf.orig_pmd)) {
> -		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma))
> +		if (pmd_protnone(vmf.orig_pmd) && vma_is_accessible(vma)) {
> +			if (sysctl_numa_balancing_mode ==
> +					NUMA_BALANCING_DISABLED)
> +				return do_damon_page(&vmf, true);
>   			return do_huge_pmd_numa_page(&vmf);
> +		}

I recall that we had a similar discussion already. Ah, it was around 
some arm MTE tag storage reuse [1].

The idea was to let do_*_numa_page() handle the restoring so we don't 
end up with such duplicated code.

[1] 
https://lore.kernel.org/all/20240125164256.4147-1-alexandru.elisei@arm.com/

-- 
Cheers

David

