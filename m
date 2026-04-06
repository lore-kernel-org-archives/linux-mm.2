Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2994EF4ED4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 12:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1FC6B0088; Mon,  6 Apr 2026 08:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 962E06B0089; Mon,  6 Apr 2026 08:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878A66B008A; Mon,  6 Apr 2026 08:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 766056B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:54:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1861D1B7E88
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:54:19 +0000 (UTC)
X-FDA: 84628124238.02.AACCB9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 505BDC000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:54:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqXfamBM;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775480057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFAx0aX7ouKuirJlSlao3PmLz03hI6Bn/KC/rAlNYhQ=;
	b=su2MG7A6+nQFsfE4HgU75Cipg23YGTzy7+G2G9bgjqNgEG30dPx0Fu4AjVAzTtgmBRHBsJ
	GI4R8ex1RknAiAkK/92WfZMNlPqqVvljo+J8bvtQ6REvaCKwsk0fF4umjqarC3ZUP0dVzo
	uH4ouYPwoVTyXiC1tAoAl9sIgMSFusA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqXfamBM;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775480057; a=rsa-sha256;
	cv=none;
	b=c17T8bp8kpNQfe4VmA0yacJeuCmrqd3akKDx91g0yWR8FHHq7hZ7Uf/ik82mjmcg3MwQEG
	tcZnMPFouIfWct4Tki9OjMjxijm7MfBxOkvT9l3vAOQvA5QIWWhMnlXXaeX5SzyEbrmN4/
	fHlY+9vfP7ORfipyzbFTs7NvfmdeDcc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D32543FF4;
	Mon,  6 Apr 2026 12:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F839C4CEF7;
	Mon,  6 Apr 2026 12:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775480056;
	bh=lmE4691xD8knfB5Qasc9kqe2NEgfhceQd9mqYaNZSg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KqXfamBMiO+cbLoEGuW6uTNbJ99c6BU05Y3w7YvRuPst2gGOuyr1shCiZ2tLlUvqE
	 9FB1hwefQoxk98pRkBOjMpgAQJplh58S8Qk9J1aJqWZYToVDi+kgmJTtTfVmAtE772
	 peaTipxc3+YTMfhQNey2BcKc8LG9c3Fy1mv7/bWPmnFayV5svW9JTvi/DhlngTBVc7
	 kXV6ycNx5Nd9Epyd8bxLC8lRwXdhlSLDIDmxFGDglgIvrhm9zsGPbV7w62nJfrWdr7
	 qvmg0gzmNxj22TedBleto/Ot5KmJs4NJ07WxmfSQmNj9NZNZVV7juxUrfaq/FJwVlp
	 t+3afvVxm5O8w==
Date: Mon, 6 Apr 2026 13:54:13 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>, 
	Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, 
	dri-devel@lists.freedesktop.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <adOqU0UDzpxvQuwA@lucifer>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
X-Rspam-User: 
X-Stat-Signature: w5whhgsyzjhun8enb7dhr7hr4ypy5777
X-Rspamd-Queue-Id: 505BDC000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1775480057-703094
X-HE-Meta: U2FsdGVkX1+l75lCL2ua0TagbqAOokADy16dZGPCNenz4nQcsXI4egIr14MM2pWy0CDo1WuQWPJsUu2tRUgOC7d0Ye2CrThbZwRxTrn3ygR8n+5E55I3cC/fIf30OZc6hISUzh6GHnU33qfnCL75/pvNUvkOr9OGWfkw2/ZmCh4ZnOdj9ZStsZiXNmqwjlaZBbcBDoqJJm9tylGd+GWhSN+TRtZCncivfBIwgHE3zDY8FllecyAJeDVhAAzwQK77KGLCr+Lws/tC3nEmMkvowXVq9FyCfeuxVEorhK3Av5t9fV6aDI823GU3tkKYPFRt2Af6DMvPCjf3dz/BQhWi9aJCFBSqxQRV6LQIijlu8Ri72dOhIw9rlhgkMxLGCIYSCNeVJ0gnJKT5H9Y+zAu6Ufub3Tfm7JxBHr+HRabJ/j9UCmFw8zT9RBrxyF6rNniSg4Xn4U1XPP71HjWftqNTaIAgIifgAAKawwRgOjoEwOKW17hvHnGPZXF1tDf9mN+F8jsHtRvuuCgrPIFuhM2injVd03fIEjWX4pXF3IQqqnqV7Gvec4HDsZFmNWO6CA0280eEMoDddYTxa8A5PrIzZ0xbRTvFguH7KeLkxzjscJZ/EDLwR8Omkq4Sx3EY/Cldz+DkVdvc/D4wFK4GlcEL7e4i0JmyRCbRF6EtTFNav7GGsVGechQisp29JHmN3NQfTYg0ZMbYv5GITkJmowlcz6TjBT19Xy/x30lpzJVH/U7e9e+sqmzDTsnwLc4o/+ZyK0XbYABvH7DAc11wvycAd2qjc91AIaBlcJF1WzlRdo+4NvA4LAl5iLbCfBpTmJrYRHfNbHRR7rfQBiZ1H9/qtAAkk73EAzcXXVQAUoAiiyMrRtkimAhoasErc/raoSuTOsorOrdTCdrmlq7eVmvmhC0OEFw5x9rhhVmJvfOnB/opJ7EBspSPMnOqK7njqtXXNXkg7A2T5DGrW/j4aMj
 qXwxg5K8
 LStkhqpDWPwV0XHAsXDrFrKlq3r0W6/V0fVCTOIRqrf7XnAwaFBYJRqaMV89JtJlx4Q1XO50PZLtDbLsR9KImZuMZitGzYLivvPiiJDXjHfnqj1NhpNU8lkUdpeMdHkXrzc7I1EkA7uU79M82rpEJkKvLcokdiV8rMJEqmATujftSEBxshIv4YeEXysmjm+JjdmLIm/9dShjilN1hXeVr8QZLLpqBG6YzH+S7BqLqT7u3O+c68IAuWQYD11N5ARv1fYdUFeHq2GPq97zDPc0piUQRpxug3bTnSh7ExtBtzldEl4w3W+C8aSSf87DmlvyCK7OoIeR+dIkEwPiyBwlEluEb7z4p0Mbed1vf76ynefGhR9fwQdDkbSQCoRq/P2DQaL9VJytayaGNCnJYh12K/xIfXH0m/M6IzgoGaE+p3XxE3heRwKGBHaMOtO9pSL7562LAAEyYA6RmXExw9AWcJXynN2P/4wev4BXrUGVAc9Fskom2GKiP9l4cW9DJJghSxMdjnX+tlYkAjLHAgsPNCPh6T0u9Kyj1iX/9ITPiBBX+UUvUgAz0CBfy5wNlP6+dIUJOkqGjyc0rhL2kvVp7U3eHh31ZRfs+1dlPyJVZ6d6ZLFdxdot1FdT0YpFMUKwR5ArAgG22baos1DSW23Tz3shXhaHbuSpasF4gFnk+0aCVNjnl6UNjwRsjTiNruiuPfTufgwKWz/F22Y236lmzoD6SunkIp771jNoryGBUVJBXyPmTfo0Vq4tYpn4RlB6qCjd3xXUFnslEDoT1PsuvXXgQho0Y5fFEuRIIeuh0VcP10f16IQ5miccJTouoGtFW/Hcz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi guys,

+cc missing M/R, fsdevel list

So this was merged upstream, and touches mm/, and even has a mm:
prefix... but was taken through a non-mm tree.

I'm confused as to why an mm: patch didn't go through the mm tree, but when
we do stuff like this, isn't the done thing to get maintainer signoff
before doing something like that, anyway?

I see John gave a tag (and he's great so that gives me confidence here),
but we should really follow the procedure on this properly.

So:

$ scripts/get_maintainer.pl --no-git include/linux/migrate.h mm/filemap.c mm/memory.c mm/migrate.c mm/migrate_device.c | grep maintainer
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)
David Hildenbrand <david@kernel.org> (maintainer:MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION)
"Matthew Wilcox (Oracle)" <willy@infradead.org> (maintainer:PAGE CACHE)

Are the maintainers, and there are also 14 reviewers too.

None were even cc'd here which isn't helpful :)

I realise mm process has _perhaps_ not been quite so prescriptive as this
in the past, but we definitely require this going forward, and in general
you should run get_maintainers.pl and cc relevant people to help with the
pain that is kernel email :)

As I don't _think_ anybody noticed it, unfortunately. linux-mm is just too
busy to keep track there, generally.

We are semi-tetchy about this as we've had... fun in the past with some
bigger changes that went through other trees. This is, at least, very
isolated.

Thanks, Lorenzo

On Tue, Feb 10, 2026 at 12:56:53PM +0100, Thomas Hellström wrote:
> If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> trying to acquire the lock of a device-private folio for migration,
> to ram, the function will spin until it succeeds grabbing the lock.
>
> However, if the process holding the lock is depending on a work
> item to be completed, which is scheduled on the same CPU as the
> spinning hmm_range_fault(), that work item might be starved and
> we end up in a livelock / starvation situation which is never
> resolved.
>
> This can happen, for example if the process holding the
> device-private folio lock is stuck in
>    migrate_device_unmap()->lru_add_drain_all()
> sinc lru_add_drain_all() requires a short work-item
> to be run on all online cpus to complete.
>
> A prerequisite for this to happen is:
> a) Both zone device and system memory folios are considered in
>    migrate_device_unmap(), so that there is a reason to call
>    lru_add_drain_all() for a system memory folio while a
>    folio lock is held on a zone device folio.
> b) The zone device folio has an initial mapcount > 1 which causes
>    at least one migration PTE entry insertion to be deferred to
>    try_to_migrate(), which can happen after the call to
>    lru_add_drain_all().
> c) No or voluntary only preemption.
>
> This all seems pretty unlikely to happen, but indeed is hit by
> the "xe_exec_system_allocator" igt test.
>
> Resolve this by waiting for the folio to be unlocked if the
> folio_trylock() fails in do_swap_page().
>
> Rename migration_entry_wait_on_locked() to
> softleaf_entry_wait_unlock() and update its documentation to
> indicate the new use-case.
>
> Future code improvements might consider moving
> the lru_add_drain_all() call in migrate_device_unmap() to be
> called *after* all pages have migration entries inserted.
> That would eliminate also b) above.
>
> v2:
> - Instead of a cond_resched() in hmm_range_fault(),
>   eliminate the problem by waiting for the folio to be unlocked
>   in do_swap_page() (Alistair Popple, Andrew Morton)
> v3:
> - Add a stub migration_entry_wait_on_locked() for the
>   !CONFIG_MIGRATION case. (Kernel Test Robot)
> v4:
> - Rename migrate_entry_wait_on_locked() to
>   softleaf_entry_wait_on_locked() and update docs (Alistair Popple)
> v5:
> - Add a WARN_ON_ONCE() for the !CONFIG_MIGRATION
>   version of softleaf_entry_wait_on_locked().
> - Modify wording around function names in the commit message
>   (Andrew Morton)
>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in do_swap_page")
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v6.15+
> Reviewed-by: John Hubbard <jhubbard@nvidia.com> #v3
> ---
>  include/linux/migrate.h | 10 +++++++++-
>  mm/filemap.c            | 15 ++++++++++-----
>  mm/memory.c             |  3 ++-
>  mm/migrate.c            |  8 ++++----
>  mm/migrate_device.c     |  2 +-
>  5 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..d5af2b7f577b 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list);
>
>  int migrate_huge_page_move_mapping(struct address_space *mapping,
>  		struct folio *dst, struct folio *src);
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  		__releases(ptl);
>  void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
>  int folio_migrate_mapping(struct address_space *mapping,
> @@ -97,6 +97,14 @@ static inline int set_movable_ops(const struct movable_operations *ops, enum pag
>  	return -ENOSYS;
>  }
>
> +static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +	__releases(ptl)
> +{
> +	WARN_ON_ONCE(1);
> +
> +	spin_unlock(ptl);
> +}
> +
>  #endif /* CONFIG_MIGRATION */
>
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..d98e4883f13d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1379,14 +1379,16 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
>
>  #ifdef CONFIG_MIGRATION
>  /**
> - * migration_entry_wait_on_locked - Wait for a migration entry to be removed
> - * @entry: migration swap entry.
> + * softleaf_entry_wait_on_locked - Wait for a migration entry or
> + * device_private entry to be removed.
> + * @entry: migration or device_private swap entry.
>   * @ptl: already locked ptl. This function will drop the lock.
>   *
> - * Wait for a migration entry referencing the given page to be removed. This is
> + * Wait for a migration entry referencing the given page, or device_private
> + * entry referencing a dvice_private page to be unlocked. This is
>   * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE) except
>   * this can be called without taking a reference on the page. Instead this
> - * should be called while holding the ptl for the migration entry referencing
> + * should be called while holding the ptl for @entry referencing
>   * the page.
>   *
>   * Returns after unlocking the ptl.
> @@ -1394,7 +1396,7 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
>   * This follows the same logic as folio_wait_bit_common() so see the comments
>   * there.
>   */
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  	__releases(ptl)

I mean I have to say though I'm happy you propagated the softleaf thing
further at least ;)

>  {
>  	struct wait_page_queue wait_page;
> @@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t *ptl)
>  	 * If a migration entry exists for the page the migration path must hold
>  	 * a valid reference to the page, and it must take the ptl to remove the
>  	 * migration entry. So the page is valid until the ptl is dropped.
> +	 * Similarly any path attempting to drop the last reference to a
> +	 * device-private page needs to grab the ptl to remove the device-private
> +	 * entry.
>  	 */
>  	spin_unlock(ptl);
>
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..20172476a57f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>  				unlock_page(vmf->page);
>  				put_page(vmf->page);
>  			} else {
> -				pte_unmap_unlock(vmf->pte, vmf->ptl);
> +				pte_unmap(vmf->pte);
> +				softleaf_entry_wait_on_locked(entry, vmf->ptl);
>  			}
>  		} else if (softleaf_is_hwpoison(entry)) {
>  			ret = VM_FAULT_HWPOISON;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 4688b9e38cd2..cf6449b4202e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_struct *mm, pmd_t *pmd,
>  	if (!softleaf_is_migration(entry))
>  		goto out;
>
> -	migration_entry_wait_on_locked(entry, ptl);
> +	softleaf_entry_wait_on_locked(entry, ptl);
>  	return;
>  out:
>  	spin_unlock(ptl);
> @@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct vm_area_struct *vma, unsigned long addr, p
>  		 * If migration entry existed, safe to release vma lock
>  		 * here because the pgtable page won't be freed without the
>  		 * pgtable lock released.  See comment right above pgtable
> -		 * lock release in migration_entry_wait_on_locked().
> +		 * lock release in softleaf_entry_wait_on_locked().
>  		 */
>  		hugetlb_vma_unlock_read(vma);
> -		migration_entry_wait_on_locked(entry, ptl);
> +		softleaf_entry_wait_on_locked(entry, ptl);
>  		return;
>  	}
>
> @@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_struct *mm, pmd_t *pmd)
>  	ptl = pmd_lock(mm, pmd);
>  	if (!pmd_is_migration_entry(*pmd))
>  		goto unlock;
> -	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
> +	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
>  	return;
>  unlock:
>  	spin_unlock(ptl);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..deab89fd4541 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  		}
>
>  		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> +			softleaf_entry_wait_on_locked(entry, ptl);
>  			spin_unlock(ptl);
>  			return -EAGAIN;
>  		}
> --
> 2.52.0
>
>

