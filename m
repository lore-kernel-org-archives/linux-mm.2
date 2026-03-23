Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB677F483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E4F6B0096; Mon, 23 Mar 2026 14:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F21306B0098; Mon, 23 Mar 2026 14:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E37206B0099; Mon, 23 Mar 2026 14:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2DF46B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:04:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83A105C9D1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:04:55 +0000 (UTC)
X-FDA: 84578103750.09.8012B45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BF8B51C0016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:04:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rDtWPwoe;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlKH65tM0cJ9E+G7StIz7cSrPBeWDMnJ+BeKb0hfAd8=;
	b=ypvRr9ahjbW2fNZhNL+/dsod08YgxXn6jcrv76B52e6/THFYxGj1XLr2wmGtbFrCBbexFN
	ZbDB0NE/WvX7w6eshVDMk/t5QSFNcCCivtS53y0RVDX3DWIo1jfra/BTla7J9+mZa1zqpW
	w2oIgr2QmJtuinb29l2NBdPBGQ2gUj4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rDtWPwoe;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289093; a=rsa-sha256;
	cv=none;
	b=EK5Xe48HgYPocKmC4JH8s7B1CQqM3S1tWkBx2CvLotIPnN66EOtOj+gmpGwRJ8dC+NoZLb
	Hn2Oe51kqpTZO7nxCx3JSgaN21dVdP74altF0mQVw+9S2Ztp55I66npA7fkYUqWU15OS6t
	Bfr6ap8DIxHtOc86jxqNrUlFP13Hxow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F48043938;
	Mon, 23 Mar 2026 18:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A87C4CEF7;
	Mon, 23 Mar 2026 18:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774289092;
	bh=CruYFImaZ7t8b4ollGRPZPQSf1fkTcITWStkRCYIOgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rDtWPwoezlO5BESYMPPqNQNwXC0kehS0cJIQC+FBhxL0H17ihZQutq/GjuIR+DiUV
	 i5zcw3qJQtZnj4+CaQx149G/nnT/DghiOJlYmmca5qOVzujJ7sZqPhZoNHex4d7Ymz
	 0QWrWDuBbSKZeJugD02i12xJTXyWNNloLToP1B2CMdIsj2fcFpU777iXF6TxHnhD/C
	 b1uqjKnStXEeadUHqq7Z/EQgEA+bu2gnCs8U5l9UDPAKcTiXdyFwJLS9Kqx5z2/G9x
	 c7RVwWhnMcASmLbIKUyAIrkAzS38Uzs+m/ZjuaSeFkufx7xxPFVlo3qJSFoBHXhaM1
	 mVemqyvThdMNA==
Date: Mon, 23 Mar 2026 18:04:50 +0000
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
Subject: Re: [PATCH v4 4/4] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <1c44dd0b-4f5a-4fc1-983f-f728b31c9e4d@lucifer.local>
References: <20260322054309.898214-1-surenb@google.com>
 <20260322054309.898214-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322054309.898214-5-surenb@google.com>
X-Rspamd-Queue-Id: BF8B51C0016
X-Stat-Signature: ygiozqh8qgzr5qjppam3woh4my59zgdr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774289093-229874
X-HE-Meta: U2FsdGVkX1+izr+sbXyBfPoWld5xsL94XW4Eww5Jo7Wm97oKEFX1KD8WqP/hkrWac43wLn/mzRhaz7mYXDfmk3yqbyPlle2UjB/R6EA+NqnAzc4Zcgb+Wde0pHEqBQajtA9FKL316drEKrgVB7xViZvYreWm+NidT6ntblWv0FDHZYZe8Y+ljftmOGpk9PlnhQfSZOMe4tCiHn2sxa3F6ZLBCDyIonUoctaDJkkIgWPLx1m7y7vV9OpRWycAHCe9vRtC2st9HmVUWStw6F3wGYWmL38X40QaOmAP2T1UFVIwfqRTVlnBR9vjLBc7riQLxq7iJlg/1n7hR4A0lVFi8Ajnb+rUVwaFE+hPBpJf7OznefhhO/dw+fSLVsatstfvM25572oBZ6lWPELUFsjmXHIfwrRc7OQIzwPjfrtopO8CZ4mfKlnEvcBuDhUBqLybWJJ3AakJW2fiRzHi9fC9tZqGAmmH5vlC7ZZVYOmhoWT30du40eggmM2Zhs6yTpI0KdX5ONpLXlqyLZirdzxxl77MD+sYjEDI3COtFKbOXrFtb77ojXMfKUIbdc3orhNCAN5hFGQkt2S08cN1UXVgyC72M50fXd9o9xW/SwJ3+KNtBTfHQQTSULfbT/OnCvbcih5nVnb+y+jgBTgBgU/qmpOGF2AI1OaRqNcsATETtCNt3ysHKk1tOvh4X02YgL1ywaJy3m36kkwPFgGpoTpThV6ZYN8gaMcH6dQXUdsRVI92H93+AmHjCKEZQJnTTkBtt4v4KOpNQu1/v46evG0+T8pRqZB5tVawEoK4oqmHBzt0jdbtiI3r9A1fpjJf0SOidJMPY7fPt1Ij6PIC9QGBEjR199CUSE6tb3PMCk08WCHMHqL5BEtf3nVfCu9ZDw4RQSKht4CyBikFypbvRC05NRnVzWZBlmxLEFDdhxegDWKWHBb8Gso3xyh+UcCEtSfSrnSPW8laJXUnh8VItLG
 wpYXxeNp
 T2hcYaBveITSBQrszZyiVo9QZlI9ZOnBF9c6+a7hfcMgwcTvroHamFik7g2YtPf/AzbCJjvM0OnZo3IT7h/hL6WWGtUk//bccpo9nXr/NBxLuOo4xEL8pq3TgxWpkepzUAI2j9STELaKY0p28gIQJechM+2XXaAApm4zgKVPJTuUWV6psE72Np51BrJx2er9CNDnmSImAMx0kRps4rcjdws+SC9jdwWRTp8qcbks0L1rRhIux71Ai1uc6g57AEma8Qy3h65b0srVPKugKEKD96HgB6carqUjpdufU59C4Zs3Moa4kZHI4ETpdTIXbbMoN9x83eq6S3bF2vNsxnucA42iMbP5cOesxJI0rDFXSuFJu6os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 10:43:08PM -0700, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c |  5 ++++-
>  mm/mempolicy.c     |  1 +
>  mm/pagewalk.c      | 20 ++++++++++++++------
>  3 files changed, 19 insertions(+), 7 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..2fe3d11aad03 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  		struct clear_refs_private cp = {
>  			.type = type,
>  		};
> +		int err;

Maybe better to make it a ssize_t given return type of function?

>
>  		if (mmap_write_lock_killable(mm)) {
>  			count = -EINTR;
> @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  						0, mm, 0, -1UL);
>  			mmu_notifier_invalidate_range_start(&range);
>  		}
> -		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> +		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> +		if (err)
> +			count = err;

Hmm this is gross, but it's an established pattern here, ugh.

Now we have an err though, could we update:

		if (mmap_write_lock_killable(mm)) {
-			count = -EINTR;
+			err = -EINTR;
			goto out_mm;
		}

Then we can just do:

+		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);

And at the end do:

	return err ?: count;

Which possibly _necessitates_ err being a ssize_t.

>  		if (type == CLEAR_REFS_SOFT_DIRTY) {
>  			mmu_notifier_invalidate_range_end(&range);
>  			flush_tlb_mm(mm);
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 929e843543cf..bb5b0e83ce0f 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -969,6 +969,7 @@ static const struct mm_walk_ops queue_pages_lock_vma_walk_ops = {
>   *      (a hugetlbfs page or a transparent huge page being counted as 1).
>   * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
>   * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
> + * -EINTR - walk got terminated due to pending fatal signal.

Thanks!

>   */
>  static long
>  queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index eda74273c8ec..a42cd6a6d812 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -438,14 +438,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
>  		mmap_assert_write_locked(mm);
>  }
>
> -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> +static inline int process_vma_walk_lock(struct vm_area_struct *vma,

NIT: Don't need this to be an inline any longer. May as well fix up while we're
here.

>  					 enum page_walk_lock walk_lock)
>  {
>  #ifdef CONFIG_PER_VMA_LOCK
>  	switch (walk_lock) {
>  	case PGWALK_WRLOCK:
> -		vma_start_write(vma);
> -		break;
> +		return vma_start_write_killable(vma);

LGTM

>  	case PGWALK_WRLOCK_VERIFY:
>  		vma_assert_write_locked(vma);
>  		break;
> @@ -457,6 +456,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>  		break;
>  	}
>  #endif
> +	return 0;
>  }
>
>  /*
> @@ -500,7 +500,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
>  			if (ops->pte_hole)
>  				err = ops->pte_hole(start, next, -1, &walk);
>  		} else { /* inside vma */
> -			process_vma_walk_lock(vma, ops->walk_lock);
> +			err = process_vma_walk_lock(vma, ops->walk_lock);
> +			if (err)
> +				break;

In every other case we set walk.vma = vma or NULL. Is it a problem not setting
it at all in this code path?

>  			walk.vma = vma;
>  			next = min(end, vma->vm_end);
>  			vma = find_vma(mm, vma->vm_end);
> @@ -717,6 +719,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (start >= end || !walk.mm)
>  		return -EINVAL;
> @@ -724,7 +727,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;

LGTM

>  	return __walk_page_range(start, end, &walk);
>  }
>
> @@ -747,6 +752,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (!walk.mm)
>  		return -EINVAL;
> @@ -754,7 +760,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;

LGTM

>  	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
>  }
>
> --
> 2.53.0.1018.g2bb0e51243-goog
>

Thanks, Lorenzo

