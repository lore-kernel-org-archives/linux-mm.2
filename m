Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4168606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pNSI9xBg
Received: by kanga.kvack.org (Postfix)
	id 0C6916B05B0; Fri,  6 Nov 2026 03:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077856B05B1; Fri,  6 Nov 2026 03:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA89C6B05B2; Fri,  6 Nov 2026 03:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C831E6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:29:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ADDD3120CA9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:29:07 +0000 (UTC)
X-FDA: 85404019134.30.A829A82
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf02.hostedemail.com (Postfix) with ESMTP id 91AEC80004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 08:29:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNSI9xBg;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793953746;
	b=fWhxaHqra056B+3hedLy5MLCHAYk/n5PmmKXirDs6/PcR0VmiUhdlOmAv3GMRhJG9sEqJO
	TQMCAVU9g5BWEvlDlI5+XKnkQowAh0zFmQSECVG006fInbncM+7nEElAvyRAdd59OmDWZ1
	L6I3Il2dYg0Rvac3L3tXbH8OwnmjV+8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pNSI9xBg;
	spf=pass (imf02.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793953746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNiRRJr/HqM32dNtBujr6juLiRF2qd5NxM6dnan6eNs=;
	b=zS0SHYEXwgkusC+Lq+mC9gYJgu2SXIwQyLK/LCsEuT7F3KmoSfM2EwdaG2WDinyJ35snPK
	Vy5ojIExxn5ZZFG0sZ2ArrFxSxROnxE95BSR7OUOgKQuFqyTJF3vBQSW2UqNpm3ykQj2Bz
	qkODEJt5uJh+91/z7MK1i72/RAsC7MM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tlJTpDnDjtAtZ2QazRj8y5qDCk5dt7YWwEJXMbA6c4o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793953739; v=1; x=1794558539;
 b=pNSI9xBgbIn3g3QR07UWBPgC8ngpZPPXPV/9eEgnbwgNCgNpAbFInyRWIsf4JuKB+7gWCwMg
 voW3mCi/v8ZXU4/koDQQiJFLZLxDjKBU/e3hoTZaN1IaCJkBkm5Sv/SremiLRs+qHoReG7DAoqM
 jUz5lRxC83OHpaogPylZxFhI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id b2a43df8ec8d98e8;
	Fri, 06 Nov 2026 08:28:59 +0000
X-Mizu-Trace-ID: b2a43df8ec8d98e8
X-Migadu-Flow: FLOW_OUT
Date: Fri, 6 Nov 2026 16:28:49 +0800
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev,
	liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
	jannh@google.com, pfalcato@suse.de, kees@kernel.org, ziy@nvidia.com,
	gourry@gourry.net, anthony.yznaga@oracle.com, linux-mm@kvack.org,
	wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH] mm/ksm: fix ksm_exit() deadlock on exec error path
Message-ID: <au2PwSAxOU3W9pwF@dgvxl46587.localhost.localdomain>
References: <20261106013906.2229780-1-tujinjiang@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106013906.2229780-1-tujinjiang@huawei.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91AEC80004
X-Stat-Signature: q5k6x7t9oyufozih4ib9jfysmds831ho
X-Rspam-User: 
X-HE-Tag: 1793953742-849581
X-HE-Meta: U2FsdGVkX1937BmaogobO/WYLeoysxaGzeMlRY9v3mCu57PcIRecyWTMW/bGwmUTZ1OGg7D5I44np8BpTT20Wg++WtMWfOvfFN37C+u+UV3j9cA6eObRedA41XxCPJYlHpjxcQJD+5qPceQdCPppgs+9f+mNt6Um8elkzDSzR0JUEut6yBymrjfraamCLKpTslXd5CSOokkJiWqVbBvexovl1vasUV3Ocny8OXEMwFN7lBi3lZ3y5Sgh8oulJGBmo6+bM+pvGMy7h/Z67xIVAAbcebxnsagpnz2Z1k2ElDEduwPXbrRUcF7hGaxUscNQjgCP/7SFxpRcDeab9nBTsrZ8arkPMDIyvs3sOcCQzpNbvj757DabtYeX8EY8N2MPe/n2TYLW/8I+Ejusi1VHS94YhsO5r1jg0UCYNuLJg35jj2T3lm1EgaAu3M0fK1tx+fP4Pn/gzJm9kmnm8Au6eGaonx8GPRzYGZONkNR4Cl0NyoQk1x5FW/ISEF5hZzBkWth7KLpUPWlFI39LxP8PRI/QRA2SNlYWQBTwjmLGbP83iOZEDYiv3DVCYD7kk4Vr1gngKtfsW+LX6+++o0BDtGXwLiOSCwPhcD4QKUrPyamUP+2sicEhO4B8ZSaArIcsyVhTZBlIVxIexT4wKdfsLXoFELhVUtmNBmUtO/3E3IJgwaCTYaavPfZ5tcfbeXdxrnLHfSvvHm2qRE5yA7F50ewuOGOqS02YVJwvZuv4zw3c3VcrGzU9BBgw67lbfH+JHGdXt+NSI8p0e2qe+GtOYFZim5D65Ub9aKmPBrG/UMjDG5nulMd9UrhJnuhLLcceGoF4+oI6GrCwbTnU6ggEZo+707a+sbGrXAnNZVBroEiXG2EX+CK763WYjQuR5XQmsyX9zz0mEIPJKLMt2n2nMQa6wp6GFPIT+TOz0r32vJrNt8jBVjizkmde7W4+wWx/SBS0YbL+Q0uCMuCwQlB
 qGpYlRz2
 NKLOUuyrw+8HRwWaFgUEeVChyrH+uyxbQNuKKM7G3eqNu2NLCNMlc8bJkpUmemYKAO7vLW6Bw6ENElZn4xw/2DhKQbu25VuNVtyf31Q3FwULGKY7qZRK4KGJZZZRRCb+TT8o/XFFzszfW2OVURf5Sut7+3xrayNHTMwu/mzwcLfcYgjGzPfo1RmaVdhMHXng6fYhMaTxd0kJdB6Hvoe39EeK23CtC995k/EVONcPKDDWUKZoh73EJaRKVFHrOGrjPBmdY0w5pwNee6xOysrz7Q6UBFkIaA1lhzuUIM/IJAglMlXZXIbEuFxBmP5sXQwqrBFlIoSBH5VrLTe4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 09:39:06AM +0800, Jinjiang Tu wrote:
> create_init_stack_vma() registers the new mm with ksmd via ksm_execve()
> while holding mmap_write_lock(), and calls ksm_exit() before dropping the
> lock. When insert_vm_struct() fails, __ksm_exit() takes mmap_write_lock()
> again when the mm is ksmd's current scan cursor, leading to deadlock.
> 
> The early registration is no longer needed after commit 590c03ca6a3f
> ("mm/ksm: fix exec/fork inheritance support for prctl"). ksm_vma_flags()

We can go into more detail. like: 
"The early registration ksm_execve() during the exec() is no longer required,
since when the process subsequently carries out the actual memory-allocation
operations, such as brk() or mmap(), ksm_vma_flags is invoked to re-check
MMF_VM_MERGE_ANY and register the mm with KSM."

> calls __ksm_enter() when the first mergeable VMA is created. Remove
> ksm_execve() and its stubs.
> 
> Tested with ksm_functional_tests, all tests pass.

If possible, can you provide a reproducible testcase in
tools/testing/selftests/mm/ksm_functional_tests.c in V2 ?

Generally Looks good to me, thanks!

Acked-by: Xu Xin (vivo) <xu.xin@linux.dev>

Thanks!

> 
> Fixes: 3a9e567ca45f ("mm/ksm: fix ksm exec support for prctl")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  include/linux/ksm.h               | 13 -------------
>  mm/ksm.c                          | 16 +++++++++-------
>  mm/vma_exec.c                     | 10 ----------
>  tools/testing/vma/include/stubs.h |  5 -----
>  4 files changed, 9 insertions(+), 35 deletions(-)
> 
> diff --git a/include/linux/ksm.h b/include/linux/ksm.h
> index d39d0d5483a2..5e228935cede 100644
> --- a/include/linux/ksm.h
> +++ b/include/linux/ksm.h
> @@ -66,14 +66,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>  	}
>  }
>  
> -static inline int ksm_execve(struct mm_struct *mm)
> -{
> -	if (mm_flags_test(MMF_VM_MERGE_ANY, mm))
> -		return __ksm_enter(mm);
> -
> -	return 0;
> -}
> -
>  static inline void ksm_exit(struct mm_struct *mm)
>  {
>  	if (mm_flags_test(MMF_VM_MERGEABLE, mm))
> @@ -118,11 +110,6 @@ static inline void ksm_fork(struct mm_struct *mm, struct mm_struct *oldmm)
>  {
>  }
>  
> -static inline int ksm_execve(struct mm_struct *mm)
> -{
> -	return 0;
> -}
> -
>  static inline void ksm_exit(struct mm_struct *mm)
>  {
>  }
> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b189..2e0f894208d8 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2777,11 +2777,11 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  
>  		mm_slot_free(mm_slot_cache, mm_slot);
>  		/*
> -		 * Only clear MMF_VM_MERGEABLE. We must not clear
> -		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
> -		 * perhaps their mm_struct has just been added to ksm_mm_slot
> -		 * list, and its process has not yet officially started running
> -		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
> +		 * Only clear MMF_VM_MERGEABLE. MMF_VM_MERGE_ANY is the
> +		 * per-process setting inherited across exec, so it must
> +		 * stay set until userspace disables it with
> +		 * prctl(PR_SET_MEMORY_MERGE, 0). A later mergeable VMA
> +		 * re-registers the mm through ksm_vma_flags().
>  		 */
>  		mm_flags_clear(MMF_VM_MERGEABLE, mm);
>  		mmap_read_unlock(mm);
> @@ -2909,8 +2909,10 @@ vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
>  		vma_flags_set(&vma_flags, VMA_MERGEABLE_BIT);
>  		/*
>  		 * Generally, the flags here always include MMF_VM_MERGEABLE.
> -		 * However, in rare cases, this flag may be cleared by ksmd who
> -		 * scans a cycle without finding any mergeable vma.
> +		 * However, a newly execed process has not been added to
> +		 * ksm_mm_slot. The first mergeable VMA registers the mm
> +		 * with ksmd here. ksmd can also clear it after a full scan
> +		 * cycle without finding any mergeable VMA.
>  		 */
>  		if (unlikely(!mm_flags_test(MMF_VM_MERGEABLE, mm)))
>  			__ksm_enter(mm);
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 586c52155942..2c644e18b55d 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -128,14 +128,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>  		goto err_free;
>  	}
>  
> -	/*
> -	 * Need to be called with mmap write lock
> -	 * held, to avoid race with ksmd.
> -	 */
> -	err = ksm_execve(mm);
> -	if (err)
> -		goto err_ksm;
> -
>  	vma_flags_set_mask(&flags, VMA_STACK_FLAGS);
>  	vma_set_anonymous(vma);
>  
> @@ -163,8 +155,6 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
>  	return 0;
>  
>  err:
> -	ksm_exit(mm);
> -err_ksm:
>  	mmap_write_unlock(mm);
>  err_free:
>  	*vmap = NULL;
> diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
> index f786a585caf0..9ab4e524f78e 100644
> --- a/tools/testing/vma/include/stubs.h
> +++ b/tools/testing/vma/include/stubs.h
> @@ -55,11 +55,6 @@ static inline void free_pgd_range(struct mmu_gather *tlb,
>  {
>  }
>  
> -static inline int ksm_execve(struct mm_struct *mm)
> -{
> -	return 0;
> -}
> -
>  static inline void ksm_exit(struct mm_struct *mm)
>  {
>  }
> -- 
> 2.54.0
> 

