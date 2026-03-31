Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 411C1FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED696B0098; Tue, 31 Mar 2026 06:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9EB16B0099; Tue, 31 Mar 2026 06:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DBC66B009F; Tue, 31 Mar 2026 06:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0D16B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:39:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ACBFE1792
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:39:02 +0000 (UTC)
X-FDA: 84606010524.05.08A7708
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6D828C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:39:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kj7mU3zJ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774953540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUc40uI7e6fpkkzQl3EAlfc1Not7eAQrRynxsM92pZg=;
	b=kbtqtRB/PD3KOzJfg59FrAIumpEn7vDXq9OsacyYjqPO7qntdSOlSc8Om96LDMFjduKgq1
	KK52mqRIYLKWGYieU08pvZe4SJBEFh2Y5zHfu2qJpI1cjF7wFa4zQdr1noctSYzAOtkK6l
	qY+PLVRc/uqdnQRyqZYwKDzIxnhzBBU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kj7mU3zJ;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774953540; a=rsa-sha256;
	cv=none;
	b=lcvpR9DQRyKexwKtJ5K+gKNmQEvc6Y7zLwshxlW5a59Hx9kj+jzWkj4/c+9qa7XeWSDG9h
	CNHd3GCkBrfb4fK9/AB6a/DOAB3SIZ5cpXOwGvVBhVb6nNC6rIC5KZtTnEnD91O1Diuhyu
	qsYl9o+6nC+F9nwaFSKqgfxyO1eksu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56DBC40648;
	Tue, 31 Mar 2026 10:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0EFC19423;
	Tue, 31 Mar 2026 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774953539;
	bh=ns25mF2UrLHOJDvx/LnwaHuyB+Hf+Nyj2xT98c2l78k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kj7mU3zJLCNNKhIQIiBnX3/r4iNBlU6v60RiEgsOF7hVhyKpPx7fHySOX/1HcZ6HT
	 g46QUG/QO0DvQW1+pKythy1s52UNDgvTjrWLTdj5d7spmSO1LFbNQUyRArY7Mj37Z3
	 7GHfGdvFSXRLtrA12eblkVnS0sp8uYMAOeilRIccIqfzkyfaGXDubOLNifxNz+z1EL
	 JmAWQ1FY+eJeiMxXzo4jYsxtkMZYa6oPg7TWrLWfmhPzaBZ1DhSvnKuYoSeP9/E2Xm
	 kG8zGjdKyVcdRF/Y9LgYk7Ghn6/jZmqo2vQFXc8thsNIf/gxryTLdUM9GwUrpEdsQe
	 Zc/hNO6wMpYBA==
Date: Tue, 31 Mar 2026 11:38:57 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 5/6] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <4e1c47a9-77a2-4f29-8de5-37f9958f5885@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327205457.604224-6-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327205457.604224-6-surenb@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D828C0002
X-Stat-Signature: f1b6nfmekabmoao1skjh5yx4hcj6y8bc
X-Rspam-User: 
X-HE-Tag: 1774953540-710432
X-HE-Meta: U2FsdGVkX18YPtWCCfeZnbPgrUSLZdhVOkxQLjz7j1DRq7G7urAJ9XfbD8Z725/DiIRl4aUBtoq6oc30+hk+MUVfqPDbrm1zaHkeAImJieLVcTSbECub6pl03Iv+/CzVR6BjUAxTdWZCTm3H0t4zHvjZxHh3KIXN7QnmEvL+ke37DWcwQNsFxi+W6xy7iqutTn8wzpwiOxHZB8Q+laaerSFPFuL8XuC3NPB8/4/cwFUOzuAvs4AbUwWoxHprPi+b7BR3ZHeaBVdoYPTTG3z/9ioncr+fmcy7IXXHGBSbx3FxmUczf9bMWqyjqOvtf3eH3ifkyiNcYCfbGduCYuFpPqqYHlt2bVueG2TBCXxQFFgButqgzvOXDNGG8fC6H1JURPiKujTvEqm953tvWRORxUR6fS3n/qcnsJQjRFWggyx3vNUvA+Fhc4L653aNowjkQ4HWl4PvoEBWfFdoBrhpf5oJ0gLNASb98hrGfgE7K/zc68F0SEebpa/xU6TKDHKs8/ZFNDkT8R5z1C1atTBKU5L9thPge+FqHmLyIGmb+PnUsw52groT/QhqVqSWVADOZOX2jzWvqoXpWuB21GImIR3p13fZZZPrKkrgPEkIMfJUfOzaUlu4+nat11Xw4Zqc1zQtPp3VRwM4SN3rH28QsO0szOcajj6inklIgzI3JGojO+nCsXCkrFRFZe1OisFWUFsTHceoUA+laGuV5Dnh7DhXmYZjaYjxhuvxCHzhLM0T1qU4PmDT+zr5HZetFYjrg7/BKb9RN38NtvrApGKXhaUwLpkRuQ3KmNrA98vDhg9KA1q/q//1GsjKA0QdtitImsCbPtO281bqF6Ww86kftrUxdDFZFmzsi/+bZXhEffhpBZ0JBV73Nj9pQ9fwJe0nIZdwYqdUZiUOnxVHgjU6Hhqnpy7GpwR/79fgQi1YgvgStrJVqFRE2JVF1DOXAEFItR9kMfplYxbu49sM4QM
 ZxH1PzC4
 /fdoGB6bDstJ7P9cNVNb4vtFaj7srs4PzHH8gTjW8BWNgS1nV+ZY6p7uVMTXFiXWnT1tExV0RMfAdC7j+PanZNwDwM/nF9deeORz5LMqndeP98nfJ7stsgTxBZhaO7f1HSapgtilO65snaU6l4ipJBMMM/pAYW8qEx5ukO77Ned9Jm7pFvoMBRakApMkAMNj2LgB6Ided53RetUghbKo4ssHF+VpSxdjgzPqXkPIbI6plmBH7SaPuF+EKvhwWF4dtmwY+rMRtI5UMAY2UDy1fb8FiuRBbyrh0rhImmMduxgb6bH/c4Y/8xeFKo5cCiXwjfJoWOLIUxk50u4mMFEp2XdULdfH0XjMxczwgk9Czr+uzkOos7wYGx+rZ+waUJ10uL4wQroqTrALcnXaCmQR5Hu8ssi/x7i3h7m8p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 01:54:56PM -0700, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it. When queue_pages_range() fails, check whether it failed due to
> a fatal signal or some other reason and return appropriate error.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 12 ++++++------
>  mm/mempolicy.c     | 10 +++++++++-
>  mm/pagewalk.c      | 22 +++++++++++++++-------
>  3 files changed, 30 insertions(+), 14 deletions(-)
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
> index c38a90487531..51f298cfc33b 100644
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
> @@ -1545,7 +1546,14 @@ static long do_mbind(unsigned long start, unsigned long len,
>  			flags | MPOL_MF_INVERT | MPOL_MF_WRLOCK, &pagelist);
>
>  	if (nr_failed < 0) {
> -		err = nr_failed;
> +		/*
> +		 * queue_pages_range() might override the original error with -EFAULT.
> +		 * Confirm that fatal signals are still treated correctly.
> +		 */
> +		if (fatal_signal_pending(current))
> +			err = -EINTR;
> +		else
> +			err = nr_failed;

Is that really a big deal? Does it really matter if the caller doesn't get
-EINTR in this case? This feels like another sashiko nitpick and is adding a
bunch of additional complexity here.

I mean if you 'filter' error messages you might always end up with an error
that's different than the original...

>  		nr_failed = 0;
>  	} else {
>  		vma_iter_init(&vmi, mm, start);
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

