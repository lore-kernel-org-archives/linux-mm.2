Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAA2C98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025A26B0088; Thu, 24 Sep 2026 05:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18EA6B008A; Thu, 24 Sep 2026 05:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2EC36B008C; Thu, 24 Sep 2026 05:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B857E6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:51:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D76F5A596F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:51:51 +0000 (UTC)
X-FDA: 85248189222.13.8B98B14
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1501880004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:51:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xZMLpfPT;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790243510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/xbq8w4zV+lOpG5fg640Cu74R6KHbiwPj4h8/5bIjG0=;
	b=cpXj61m733z9ORyKbv6PXU9hGMbjD6bvoXHIh88yLeIinAZjG2vTlWUb6jQ5YV9wT2ttgv
	uh6n1+Z+YqRuzbpZ8tau3T+qW69Vq7cz16hj9GvW07mVPOdVgWI91Kw2tpmOBYiGEwGsiq
	zID3gA08gS9YP6SR7nYMJ3cnTocPUV8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xZMLpfPT;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790243510;
	b=zzfDfeIY4tlzMQtzWJ5JV2M2epR2QTtr6GhxZHi6ISW7DO4S7i993mMvKFZihZhS6efT4b
	w9B01ixYGzTuPQA5D53adGA76B3fFZD5w75OJTsxNWqfxpH0w74wuyjphn4dg2bJqjxRGv
	Ds7+wKKS17jO+SDXSxR5WMOwmkncjok=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Uowqm2jO0yCtBtZYHi4L/i6oyjJ7ieGNuGUp4Pxn/rQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790243505; v=1; x=1790848305;
 b=xZMLpfPTmUslAHyAVqYRqdja9Ug3ngqZ/tRXCIN9oJFG9sArbXb9unJL9OWkdFVa7AgWVvaq
 s+YW38gagSu1HK8wBa5Gt1u12ZCwsQfDcMpAzLf+cRY0zN9Xf2DYBuQE0GdDljOccR+VoRihXp7
 VnBPY1NUzd9Gjv7hxRUMqCxk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id be840ac3b29f6435;
	Thu, 24 Sep 2026 09:51:35 +0000
X-Mizu-Trace-ID: be840ac3b29f6435
X-Migadu-Flow: FLOW_OUT
Message-ID: <76ee3d7a-cee9-4ff3-9d4c-068a46883e30@linux.dev>
Date: Thu, 24 Sep 2026 17:51:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/hugetlb: fix overbroad MMU notifiers for unshared
 PMDs
To: Li Zhe <lizhe.67@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aiqi.i7@bytedance.com,
 akpm@linux-foundation.org, david@kernel.org, osalvador@suse.de
References: <20260924082004.82450-1-lizhe.67@bytedance.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260924082004.82450-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1501880004
X-Rspam-User: 
X-Stat-Signature: uu9tsguqf8un1z3suh6ux4fgo9n4bku9
X-HE-Tag: 1790243507-310310
X-HE-Meta: U2FsdGVkX18Ku7ZGWrEmBZHMI1XzXo5E7UHBtqDnXZZQleuxN6e3qCz5IbLtfRIztKaSxFWbC8KFnAIfrS5c11XBPq+0E6OE2SldzsdXSGvIQOpwinefXgPVGyCQ81gvgbI6//2b1hG4cMZlqnc1oiBbq2SiCGUkCxio1VK8FVrOX39VC8wY6wgJzAHG9Z5+elOTNgbrm/UdrKweSQ2zhKRB8q2o7uctZLxMAZ3LvuHAQ9V7MZhUWiYK8xYBUISY7aosVf1TJJqUmwRX5JtO66wE6YDSNX79tT5hkCctp0O+ddBHhy0AeYgSe987gE6YznLaqK/xjbBd6NuK+ZFrhopHY+m22P8SpQbgpinVbmrX/BXlwhPbr3dkSrVyJaQ0c6kEJmFivwZOlKcV86j7iHh8+fIh/fHsDF4Qyd/SN30P7bi/OtqhlGn62D+mmt/aHRDCXU94TEF4BVMcc0u4FPuB4nCoyxos39KcIApf5MqTapJ+YXyDSsOUg8u0702DBnJBn78owtseQIWSb6jPFo3xyhM4he37EaUsDUpsTSgj3EAnug82l25heDaI55XudQWPlUzVkCXjIHrirTjTsZgptC0PJTHgtSEwxWqgpj+OAUpA1TSATHiSzBkCTjC4D08dCFpx8Yv63cD5x8jgV3h+34gKnagfIjEc0eEGI4LmcIDB5gBoJYIgvUgXxZSko840ocEdz7ZzUVLcqsssvDblpdaAtC5aNVP/0P56QSO31x1N+5En7MrsjkEpyR7zy3A0fCf41EN2eqgAm68Wc327yCbiIoL5YSMmE0Fqcyelr/zFVbOb0KuyANwCFzLlOtArzZmYJBOFy0Vk9g9ln3idrWOz9i/X1tOsJHjwObcakYguHjCgW7D2yEM4lF/X94fOfCl7iPVs7O0uJFIErOYWcgX3la51RzhEAFJAMkt8wd2nn1qa+uy8U87zY9uvNYKrWtZ/1nQBbzYLeLf
 y2+9V6rB
 FXTxLbxdnwJJ4drnFQYFFMJEg+++DBSiQu34pjTp07mQjXNqLQzwsYkKZI3Au0XwHD2gBks9iTO/TuGhAQAdiPoSXJpIyPqDwHlyCBH5SORmxFfiCiEgnnAz6zQRqDgEpkBh0CQmYnO4x3lWfe0uXdWhI2wH2ZhWfwVUX9jBZTGXbXoB9aZCA6BYjRzpWl7u9r6moBERrIpbmjfvHP/hbT3iQV4NCSyTmO28/bmyiyzUALuIJSsd+O8J22HPVaiwMxeTzm6gQ0o8Oa58wiNocvkKuEEm/YaWiiKPO3n7sUpidlu7wGSmYm5rl0TXPojf+21T43t9OJEtiav/mECQb6gDEQHKZBy3eXns0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/24 16:20, Li Zhe wrote:
> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
> PMD sharing is possible. That is only needed when huge_pmd_unshare()
> actually detaches a shared PMD page table, because clearing the PUD
> invalidates the whole PUD-sized virtual address range.
>
> For hugetlbfs hole punch, and similarly for other hugetlb unmap paths,
> a shared mapping can pass the "PMD sharing is possible" range test in
> adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file does
> not currently have any shared PMD page tables. KVM then receives a 1G
> invalidation for a 2M operation and zaps unrelated secondary mappings,
> so the guest has to fault them back in.
>
> Avoid this by tracking active PMD-sharing attachments per hugetlbfs
> inode. The count is incremented only after huge_pmd_share() successfully
> installs a shared PMD table, and decremented when __huge_pmd_unshare()
> actually detaches one. Since huge_pmd_share() can run concurrently under
> i_mmap_lock_read(), use atomic operations for the count. A zero count is
> used to skip the conservative notifier range expansion only after
> excluding concurrent PMD sharing with the mapping write lock.
>
> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
> improves P99 QPS stability while punching pages, reducing the QPS
> degradation ratio from 7.09% to 1.45%.
>
> Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> ---
> v2: https://lore.kernel.org/all/20260922090749.24905-1-lizhe.67@bytedance.com/
> v1: https://lore.kernel.org/all/20260831091023.66581-1-lizhe.67@bytedance.com/
>
> ChangeLogs:
> v2->v3:
> - Rework the sticky state based on Andrew's feedback: use a per-inode
>    counter of active PMD-sharing attachments, so files can return to the
>    no-active-sharing state after PMD sharing ends.
>
> v1->v2:
> - Rework the implementation based on David's suggestion: remember
>    whether PMD sharing ever happened for a hugetlbfs file, and skip the
>    conservative notifier range expansion while it has not. This avoids
>    the per-unmap page-table walk.
>
>   fs/hugetlbfs/inode.c    |  1 +
>   include/linux/hugetlb.h | 43 +++++++++++++++++++++++++++++++++++++++++
>   mm/hugetlb.c            | 13 ++++++++++---
>   3 files changed, 54 insertions(+), 3 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 7611a8470ea26..78e27ce0a6f63 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -921,6 +921,7 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
>   		simple_inode_init_ts(inode);
>   		info->resv_map = resv_map;
>   		info->seals = F_SEAL_SEAL;
> +		hugetlbfs_pmd_sharing_init(inode);
>   		switch (mode & S_IFMT) {
>   		default:
>   			init_special_inode(inode, mode, dev);
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 16c4c4caa126c..6b4f92b7f7ae4 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -12,6 +12,7 @@
>   #include <linux/page_ref.h>
>   #include <linux/list.h>
>   #include <linux/kref.h>
> +#include <linux/atomic.h>
>   #include <linux/pgtable.h>
>   #include <linux/gfp.h>
>   #include <linux/userfaultfd_k.h>
> @@ -509,6 +510,9 @@ struct hugetlbfs_inode_info {
>   	struct inode vfs_inode;
>   	struct resv_map *resv_map;
>   	unsigned int seals;
> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> +	atomic_t pmd_sharing_count;
> +#endif
>   };
>   
>   static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
> @@ -516,6 +520,45 @@ static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode *inode)
>   	return container_of(inode, struct hugetlbfs_inode_info, vfs_inode);
>   }
>   
> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
> +static inline void hugetlbfs_pmd_sharing_init(struct inode *inode)
> +{
> +	atomic_set(&HUGETLBFS_I(inode)->pmd_sharing_count, 0);
> +}
> +
> +static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode)
> +{
> +	atomic_inc(&HUGETLBFS_I(inode)->pmd_sharing_count);
> +}
> +
> +static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode)
> +{
> +	atomic_dec(&HUGETLBFS_I(inode)->pmd_sharing_count);
> +}
> +
> +/*
> + * A 32-bit counter can theoretically wrap, but doing so would require
> + * billions of active PMD-sharing attachments to the same inode and is not
> + * expected in practice. Treat any non-zero value as active so a wrapped
> + * negative value still takes the conservative notifier range.
> + */
> +static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
> +{
> +	return atomic_read(&HUGETLBFS_I(inode)->pmd_sharing_count) != 0;

Testing for non zero covers the negative half of the cycle,
but the 2^32nd increment changes the value back to zero.

The inode-wide total is not bounded by PID_MAX_LIMIT because
one mm can have an attachment in every PUD-sized part of a
large mapping.  For example, a 4-level x86 mm has about
131,000 user PUD slots.  Roughly 32,769 child mms can therefore
create more than 2^32 attachments by faulting one address in
each PUD of a single large inherited MAP_SHARED hugetlb VMA.
This also does not require one backing huge page per
attachment: huge_pte_alloc() installs or shares the PMD table
before hugetlb_no_page() attempts to obtain the huge page.

At the zero value, an unmap can take i_mmap_rwsem for write,
observe no active sharing, and issue only the original narrow
notifier.  Its subsequent __huge_pmd_unshare() can still
clear a PUD and decrement the counter from zero to -1, leaving
the rest of the PUD-sized invalidation unreported.

Could this use a 64-bit or saturating counter so an active
count can never be mistaken for zero?

Therefore, I recommend using atomic64_t.

Thanks,
Muchun

> +}
> +#else
> +static inline void hugetlbfs_pmd_sharing_init(struct inode *inode) {}
> +
> +static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode) {}
> +
> +static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode) {}
> +
> +static inline bool hugetlbfs_pmd_sharing_active(struct inode *inode)
> +{
> +	return false;
> +}
> +#endif
> +
>   extern const struct vm_operations_struct hugetlb_vm_ops;
>   struct file *hugetlb_file_setup(const char *name, size_t size, vma_flags_t acct,
>   				int creat_flags, int page_size_log);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4f6f58bf3db6c..cb27c06d1f7a7 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5361,10 +5361,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
>   	if (!vma->vm_file)	/* hugetlbfs_file_mmap error */
>   		return;
>   
> -	adjust_range_if_pmd_sharing_possible(vma, start, end);
>   	hugetlb_vma_lock_write(vma);
> -	if (vma->vm_file)
> +	if (vma->vm_file) {
>   		i_mmap_lock_write(vma->vm_file->f_mapping);
> +		if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
> +			adjust_range_if_pmd_sharing_possible(vma, start, end);
> +	}
>   }
>   
>   void __hugetlb_zap_end(struct vm_area_struct *vma,
> @@ -5403,7 +5405,10 @@ void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
>   
>   	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
>   				start, end);
> -	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> +	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
> +	if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
> +		adjust_range_if_pmd_sharing_possible(vma, &range.start,
> +						     &range.end);
>   	mmu_notifier_invalidate_range_start(&range);
>   	tlb_gather_mmu(&tlb, vma->vm_mm);
>   
> @@ -7006,6 +7011,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
>   	if (pud_none(*pud)) {
>   		pud_populate(mm, pud,
>   				(pmd_t *)((unsigned long)spte & PAGE_MASK));
> +		hugetlbfs_pmd_sharing_inc(file_inode(vma->vm_file));
>   		mm_inc_nr_pmds(mm);
>   	} else {
>   		ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
> @@ -7037,6 +7043,7 @@ static int __huge_pmd_unshare(struct mmu_gather *tlb,
>   	pud_clear(pud);
>   
>   	tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
> +	hugetlbfs_pmd_sharing_dec(file_inode(vma->vm_file));
>   
>   	mm_dec_nr_pmds(mm);
>   	return 1;


