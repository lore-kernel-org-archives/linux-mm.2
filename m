Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E60CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42B78E0002; Wed, 10 Sep 2025 01:11:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF1C38E0001; Wed, 10 Sep 2025 01:11:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0E08E0002; Wed, 10 Sep 2025 01:11:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA7D58E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:11:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 412F211AA51
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:11:44 +0000 (UTC)
X-FDA: 83872168128.25.9DA36DD
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D2851C000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:11:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQVOVsTp;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757481102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYMkB0r9HSctXWgIuLRdmWEAYpy9xNa7COuGYriZzdI=;
	b=N+Q00oIyvjYhvGU3YXe0O/Ic5PGbLQEw2DbW0ud/Y2XGgLkswVYWxN5MpqPfmwDdJgLoMQ
	MA0xiOcMC/UJ78DhRd/B9BD3Xoy9LPu39Pp+yK//eTLPQ6IY46ir6CVIxhzrqihxcHWUFx
	7tHkZH5JeSBKtaOwUP8+waKkGwfrSMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757481102; a=rsa-sha256;
	cv=none;
	b=XYk6qEOoQ55OaUtvJiVvA5Cfqfi86OAvAlBB7kBMVB5ysueJ642DQg/Kk5VHiJLxFVz6QO
	p7/skV/+uQgaDmd710XA1moGCb8VA1BlhqadVJCnR8iwn/SekONMXUMSSBI1WEJ0lQrk5S
	1u6ZB/SrrnSrDo4Fgtytp/REb7z9PXE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vQVOVsTp;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <7c890b42-610f-42ec-acf2-b5b9f95209b1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757481099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYMkB0r9HSctXWgIuLRdmWEAYpy9xNa7COuGYriZzdI=;
	b=vQVOVsTpRUiot61+tU/kEjJNwPcwL94BOyb1LO9rBYYKootbsf3ErKWHagw7o5YWMCv3GG
	gxSMzJ4L3x6j5MUJpTEmb4xQ6iR1EnT8axrkykWZ5AvA98wiCwjev9tl44lTmp9FnR6/aY
	itPGUFah10wATaekIMtobALd5RC7sqM=
Date: Wed, 10 Sep 2025 13:11:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 Lance Yang <ioworker0@gmail.com>, david@redhat.com,
 akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 hannes@cmpxchg.org, corbet@lwn.net, ameryhung@gmail.com, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, rientjes@google.com, andrii@kernel.org,
 daniel@iogearbox.net, ast@kernel.org, ryan.roberts@arm.com,
 gutierrez.asier@huawei-partners.com, willy@infradead.org,
 usamaarif642@gmail.com, lorenzo.stoakes@oracle.com, npache@redhat.com,
 dev.jain@arm.com, Liam.Howlett@oracle.com
References: <20250910024447.64788-1-laoar.shao@gmail.com>
 <20250910024447.64788-2-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250910024447.64788-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xmtwa8unfsshrtwbgmp1b3mjr6f9kprr
X-Rspamd-Queue-Id: 1D2851C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757481101-370835
X-HE-Meta: U2FsdGVkX1+/QRvM0rhOgV179vYrtO5UE8DvGzcDWr3YzPUakJYrNWmdW6FZyezrlNjz8nbqVnyyC2K9oPRz082PRRTsAKFmskp9dkcjncRFnZoe9Sw1RxZlQnflH4rkIM0Ok5zZn3ccXecS/xhOdZScg5UmY2+LHANjwBBufbIzs4q7qnFgItavi67W/RsObgZywfa5mn9bmYUmYFgY1b+hXt4wxQI6Rsr3ehXw6yiGNSJFD5uHWyFkgwKbOOXZQpwF67gf0Zq09IixihU14WxUA1FnfEGioaQLlHQMoCJqlBAIjg5TPo6oLS6PGbPVpo/DZneFSEMTVIWnTVYE+jYGQySMHVNh4CSkNNP/PVFdn19inbDyUUTryPH45IluxvLcKPnXotsl6jfuz0VICyLbc/ccQ739Qz1qDsLUAVjcEFGJacMylBBbN8JanaVg5MHzY3I3bHcjckeoIoMOeibRSZkuHdGTC35p3R4aGPHZFROthKV2J+FqQpn61dGS30qgrm9A4KrTDCeiKREbRv0CeiR4T0BpPksyFbv+C96xeh//BSHYOP0PtXgX+Qc7zlqKEmzYCK9eJy+joSe15PAOPde6wkwMJnwN5Ujjzo7c71Qm8b5H1Kx86K+6O1GFIGZolkx7fscle3CQZQ6zADS7KPcymqCfnpW4sYbm0/e6rkCW1hV9Rj5UxCxXVk3Z8mkeYMQ223Xb6PMYLYnv9x+XXu24pUhzKjDaTWJMPTQ4F7sBr8eqBIHr7qSkD7VAbByIYSc4pPEpfsA9iLwrzon+Io0G5jijQMgulpek830rzY0pYOAJGqMHI7cuDFRmZ/lZGtPkrq33sr6GTWWrim5BAwHYg98GRKVCQ2uJi6rVYckiF+3RVItmfJ9jd5M0dTexNZYm7C8KYBBZ26xQ9Lz/WUbD9lfj+UxJX8qsiqNBSAox6PeMoLjbGE86JGCmsz6wtdDxIT+mPaqZ6Y9
 3Pf1z2Go
 ha+oVZhUQLGYlhq+gIhUI8nSvhgk3F7mX15R1WTL+gUomsFJ9zvlCMhsD1RwioAjMcEFsQWNpmYpZGA9F8oHlJDGdVkroVWpVxcq9+IYOWN64BNEbcY7QnHsaiZtvyGqpJ7wX2gYSi9dDMykyUsyBCaIxc1FK0D1Ey4jCxgZ4rzjjmtCq2zAtn8GZS/dfL4Ju9fNWwhOIT7O3UEp3HcDMda4dUHZpqyOxIAV6YXivVBdnkR9uYhS1GuiQ3y+nLBKClo+q1uPmRbDO8CimRgxHMTuK0gVk1PN8BOgJZSAbpzfr3aHo8T+jjB9UdWwJ2Lze9jXuOun1qtwvn6z034XWSzBUcCbwnFCJkowdWRhZpE9L6nkNIUef9xQCD0x8q50hOA2f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Yafang,

On 2025/9/10 10:44, Yafang Shao wrote:
> Since a task with MMF_DISABLE_THP_COMPLETELY cannot use THP, remove it from
> the khugepaged_mm_slot to stop khugepaged from processing it.
> 
> After this change, the following semantic relationship always holds:
> 
>    MMF_VM_HUGEPAGE is set     == task is in khugepaged mm_slot
>    MMF_VM_HUGEPAGE is not set == task is not in khugepaged mm_slot
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Lance Yang <ioworker0@gmail.com>
> ---
>   include/linux/khugepaged.h |  1 +
>   kernel/sys.c               |  6 ++++++
>   mm/khugepaged.c            | 19 +++++++++----------
>   3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> index eb1946a70cff..6cb9107f1006 100644
> --- a/include/linux/khugepaged.h
> +++ b/include/linux/khugepaged.h
> @@ -19,6 +19,7 @@ extern void khugepaged_min_free_kbytes_update(void);
>   extern bool current_is_khugepaged(void);
>   extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>   				   bool install_pmd);
> +bool hugepage_pmd_enabled(void);
>   
>   static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>   {
> diff --git a/kernel/sys.c b/kernel/sys.c
> index a46d9b75880b..a1c1e8007f2d 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -8,6 +8,7 @@
>   #include <linux/export.h>
>   #include <linux/mm.h>
>   #include <linux/mm_inline.h>
> +#include <linux/khugepaged.h>
>   #include <linux/utsname.h>
>   #include <linux/mman.h>
>   #include <linux/reboot.h>
> @@ -2493,6 +2494,11 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>   		mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>   		mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>   	}
> +
> +	if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
> +	    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
> +	    hugepage_pmd_enabled())
> +		__khugepaged_enter(mm);
>   	mmap_write_unlock(current->mm);

One minor style suggestion for prctl_set_thp_disable():

static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
				 unsigned long arg4, unsigned long arg5)
{
	struct mm_struct *mm = current->mm;

	[...]
	if (mmap_write_lock_killable(current->mm))
		return -EINTR;
	[...]
	mmap_write_unlock(current->mm);
	return 0;
}

It initializes struct mm_struct *mm = current->mm; at the beginning, but 
then uses both mm and current->mm. Could you change the calls using
current->mm to use the local mm variable for consistency? Just a nit ;)

Cheers,
Lance
>   	return 0;
>   }
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..88ac482fb3a0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -413,7 +413,7 @@ static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
>   
> -static bool hugepage_pmd_enabled(void)
> +bool hugepage_pmd_enabled(void)
>   {
>   	/*
>   	 * We cover the anon, shmem and the file-backed case here; file-backed
> @@ -445,6 +445,7 @@ void __khugepaged_enter(struct mm_struct *mm)
>   
>   	/* __khugepaged_exit() must not run from under us */
>   	VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm);
> +	WARN_ON_ONCE(mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm));
>   	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
>   		return;
>   
> @@ -472,7 +473,8 @@ void __khugepaged_enter(struct mm_struct *mm)
>   void khugepaged_enter_vma(struct vm_area_struct *vma,
>   			  vm_flags_t vm_flags)
>   {
> -	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> +	if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, vma->vm_mm) &&
> +	    !mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>   	    hugepage_pmd_enabled()) {
>   		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
>   			__khugepaged_enter(vma->vm_mm);
> @@ -1451,16 +1453,13 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
>   
>   	lockdep_assert_held(&khugepaged_mm_lock);
>   
> -	if (hpage_collapse_test_exit(mm)) {
> +	if (hpage_collapse_test_exit_or_disable(mm)) {
>   		/* free mm_slot */
>   		hash_del(&slot->hash);
>   		list_del(&slot->mm_node);
>   
> -		/*
> -		 * Not strictly needed because the mm exited already.
> -		 *
> -		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> -		 */
> +		/* If the mm is disabled, this flag must be cleared. */
> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>   
>   		/* khugepaged_mm_lock actually not necessary for the below */
>   		mm_slot_free(mm_slot_cache, mm_slot);
> @@ -2507,9 +2506,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
>   	/*
>   	 * Release the current mm_slot if this mm is about to die, or
> -	 * if we scanned all vmas of this mm.
> +	 * if we scanned all vmas of this mm, or if this mm is disabled.
>   	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>   		/*
>   		 * Make sure that if mm_users is reaching zero while
>   		 * khugepaged runs here, khugepaged_exit will find


