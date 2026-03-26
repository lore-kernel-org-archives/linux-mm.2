Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40A210A88F5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F976B0088; Thu, 26 Mar 2026 13:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1086B008A; Thu, 26 Mar 2026 13:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0DC06B008C; Thu, 26 Mar 2026 13:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C127F6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:47:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8135A1A053B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:47:30 +0000 (UTC)
X-FDA: 84588946260.26.D79D8E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B62AEA0002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:47:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVhjgK8G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774547248; a=rsa-sha256;
	cv=none;
	b=mF5yF1ctH9BzG0UE0N487XGrwmVV6YU5Om1TbxRlczsatVYIj9lPdSW8PBAZYQc0gqFyh+
	vz+a/eUO4upVKy034VWA9vocKv3T70jQ/WL77wp5qC+lxCegHq4pfNK/C0yn4pNymC8Bf8
	Kh5Sp8ToGN8tkPKEmHElMKDEQ+pYT5o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WVhjgK8G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774547248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClNZmmt7/DuufbAG22btXQTihR3/iUKnZFS4OWdyu/M=;
	b=4CP4MtjW6pdSKWpKrzd07Enykjy6gsrhJTq4kVve+zO3fohXV/2HOAditJHJ3TUwX7oXNN
	48o0uo8k5e3NtlkWsm3Ow/LQgj8XrLagkvGqaaa/sZNjbnYatnsIMFKGRPEARr+CaLjKWo
	vQfQIPLKxsd6FHz6HYUYVO4zXQynIJk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 381FD60054;
	Thu, 26 Mar 2026 17:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EB15C2BCB0;
	Thu, 26 Mar 2026 17:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774547247;
	bh=gjlcKSW1jg7hpudpA3j7TSDpTKC3ZH1jovemX67eUk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WVhjgK8G+avnzkT9J4VCT5Ajwxv6Nw9lmhdBxKPu+G2YJKdOL14UdGqe50F4snrsC
	 NVH+vSXSNf1HHbcFR/+f2x9y41eI3bC6CK5CO2EGCT6m+5FeNcEK93Duev8ok+9hLh
	 rltr8Yn1nZgTgXAnHwz02Uom0SDFAYzzp8BUPSDFQcn/9p92NixbjGM6ByVbKiqJl9
	 l7MArtg/eUk3khx3v5Lz27EaZh5r5yPNSHtay3vvbl5y+Z0qPwyHIEiRtKXYW17sAU
	 6blLKMq7likwowCKZf94wRZoENiVNmvcVTbnzCe0GL/P4Ss4qa8lEN5FnbCpC1whtw
	 1O9wc36/6bl2g==
Date: Thu, 26 Mar 2026 17:47:25 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 5/6] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <7d558eaa-99d5-4421-9dac-ba17441691f9@lucifer.local>
References: <20260326080836.695207-1-surenb@google.com>
 <20260326080836.695207-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326080836.695207-6-surenb@google.com>
X-Stat-Signature: ud1t5m7jg4icry3n45i6c61rs8ff9o3m
X-Rspamd-Queue-Id: B62AEA0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774547248-540903
X-HE-Meta: U2FsdGVkX18qxHdXAitO4pROicM5KymOYNgIPMnm2nUH8+CMhriByLorPOW6pNyosvH2RN1ZkY4D/ZYthiVT1w4t1sHM36wUTHKONc87JTYfwZqJFtfpnPModPuuPeuNyeXVDi8Cj9iCRHTVV9JYDBU6xpbTtj2hTJt1dapnVbE1yVxAFkxNzbcqp0qHaSHVzapF+eCzx/W74RLvlIbcGCRlvZPb3g1Gi1zcbaNlf3ecGMICXcVbrUpMiTZedSNQU4ONykwziDUGYxyZWxWjYBlFKWHDtkjhH4vMjpkBG6SY2UhL13M+mcDFv8qUqYIMpOLxzVylOXe43GKOt8zL9iNPGlamE17h9epMvfOWw9B1LSeVwR3YRM4GdiA0zXkgbUScHQz1CFp9/1wNCT3MxeawK6ceVQAkhhj7ojyKeFsMAx8KSsd4YCCBnnNULMNbDPcigUfAd8o/Ypociv9nP/T/Mu+qc1idTwHAhEzUcyo9Q1h7s3EbZoY7/onMLsazSQQ+5BmefNjple2sL1f/iugZJhavmIhPxl6mb4BmmjCxRUlAu+sQ4exhCq0/kIZ32lJhsnn+dEe/XtqvzYP5hRRxL7OsYo5ZHVuZ4B+1lgOH0dAQCFkTTtMSk6+RHwaFb8cpu2P1TIRGptSB27HfSeo7Lhr5qpunVpyKTAQ8UbqxVzr2D466eM7cmC/9S4Vodr5dLXBuqF7YS1Hmx6xmdTOUamFyl8CHM+f48LtGIKhuLTpkRTK9grKj0nFUR18oMr05zLAqjVuUQCN4sx8gr0TOJwoE/e5SDvNgc4Jt3miVuIVLiFz2gpCQv5urcLz0VSBqVzD1tBTol/6e6VIn9yoazBm05wkOufKjxQL1xHYkpd7vWCKZL8TZvUzeA88xP4nnz6LJ0cSYuPi++asVrvntye5JrZpD5dIRaWErtMWP2LkuMywvQCA64nH4xxak/BklmjzStt4DLlCLU/8
 uWWrqOXC
 ZNrj1fCdqHCkuQ7LKzrea7fAE1WtEzoVY6f9p4WObc6R4zyg60iJTnwCZN178vl1MN/uuwGpgvxeVjqg4Tk5p4aPtBcW9soLR0MNNs9NMZdKaDGr/pgqSaXZa2X9t+wN/Klh00Kyu9QJblT9yd2QoMrM5hNqDuMWXEcAJgQ/mZMTXBnlFavTsI9a2Tzc2CPa+Tv94sO/NOo1uq6D1NRB9i7b4mwcY+nwhJDi3m+aG8CA6mGHSSBg/FUolyqYIJASy/7ZVjBEf4zsC8J7eV8c3wnF2yhLdrA9ylS0QrMWNmSoc8gsv6++/t4AACCQScQHvjCsMoXErOBHf7KlRnKyzU562fTEBa/4qftxPS9nhxDX44f9u0BfIY6fiSTh4F8n6iVSr88h4zHcLnriDsQdhETdxPpUG0ZmIovNBU+Vvb8MQ4Vge2kEAjhDbMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:08:35AM -0700, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  fs/proc/task_mmu.c | 12 ++++++------
>  mm/mempolicy.c     |  1 +
>  mm/pagewalk.c      | 22 +++++++++++++++-------
>  3 files changed, 22 insertions(+), 13 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..33e5094a7842 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1774,15 +1774,15 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  	struct vm_area_struct *vma;
>  	enum clear_refs_types type;
>  	int itype;
> -	int rv;
> +	int err;
>
>  	if (count > sizeof(buffer) - 1)
>  		count = sizeof(buffer) - 1;
>  	if (copy_from_user(buffer, buf, count))
>  		return -EFAULT;
> -	rv = kstrtoint(strstrip(buffer), 10, &itype);
> -	if (rv < 0)
> -		return rv;
> +	err = kstrtoint(strstrip(buffer), 10, &itype);
> +	if (err)
> +		return err;
>  	type = (enum clear_refs_types)itype;
>  	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
>  		return -EINVAL;
> @@ -1824,7 +1824,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  						0, mm, 0, -1UL);
>  			mmu_notifier_invalidate_range_start(&range);
>  		}
> -		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> +		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
>  		if (type == CLEAR_REFS_SOFT_DIRTY) {
>  			mmu_notifier_invalidate_range_end(&range);
>  			flush_tlb_mm(mm);
> @@ -1837,7 +1837,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  	}
>  	put_task_struct(task);
>
> -	return count;
> +	return err ? : count;
>  }
>
>  const struct file_operations proc_clear_refs_operations = {
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index c38a90487531..336753a4b2b2 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -969,6 +969,7 @@ static const struct mm_walk_ops queue_pages_lock_vma_walk_ops = {
>   *      (a hugetlbfs page or a transparent huge page being counted as 1).
>   * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
>   * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
> + * -EINTR - walk got terminated due to pending fatal signal.
>   */
>  static long
>  queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 3ae2586ff45b..eca7bc711617 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -443,14 +443,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
>  		mmap_assert_write_locked(mm);
>  }
>
> -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> -					 enum page_walk_lock walk_lock)
> +static int process_vma_walk_lock(struct vm_area_struct *vma,
> +				 enum page_walk_lock walk_lock)
>  {
>  #ifdef CONFIG_PER_VMA_LOCK
>  	switch (walk_lock) {
>  	case PGWALK_WRLOCK:
> -		vma_start_write(vma);
> -		break;
> +		return vma_start_write_killable(vma);
>  	case PGWALK_WRLOCK_VERIFY:
>  		vma_assert_write_locked(vma);
>  		break;
> @@ -462,6 +461,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>  		break;
>  	}
>  #endif
> +	return 0;
>  }
>
>  /*
> @@ -505,7 +505,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
>  			if (ops->pte_hole)
>  				err = ops->pte_hole(start, next, -1, &walk);
>  		} else { /* inside vma */
> -			process_vma_walk_lock(vma, ops->walk_lock);
> +			err = process_vma_walk_lock(vma, ops->walk_lock);
> +			if (err)
> +				break;
>  			walk.vma = vma;
>  			next = min(end, vma->vm_end);
>  			vma = find_vma(mm, vma->vm_end);
> @@ -722,6 +724,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (start >= end || !walk.mm)
>  		return -EINVAL;
> @@ -729,7 +732,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;
>  	return __walk_page_range(start, end, &walk);
>  }
>
> @@ -752,6 +757,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (!walk.mm)
>  		return -EINVAL;
> @@ -759,7 +765,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;
>  	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
>  }
>
> --
> 2.53.0.1018.g2bb0e51243-goog
>

