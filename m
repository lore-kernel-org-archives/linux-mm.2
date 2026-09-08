Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8E5C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45A26B0093; Tue,  8 Sep 2026 13:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23306B0095; Tue,  8 Sep 2026 13:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C0A6B0096; Tue,  8 Sep 2026 13:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B1A0E6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:59:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37D55C0761
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:59:13 +0000 (UTC)
X-FDA: 85191356586.25.9B4986E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6FE1FC0005
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:59:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f5D4Cy2E;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788890351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRhCXB5d+1xHpm+rHDVsJTBtyYPUGsVwslLkzk8euVU=;
	b=h9yEHYd2XtrlY8MUq9OWmYdVYz31b2gWU+uuVVQTGJ0ZIwFc85PPJh4CWXM5lIJ090QzkH
	FLZzO5bbcumTwqv0pzDWKFwpmiBvaXJ8cNJtiubkYxbVOdKwG1nk43b2kJzhMBtMMSVtty
	h8mO4G9DDXc+/2axzvgdVnhdswLvu38=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=f5D4Cy2E;
	spf=pass (imf10.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788890351;
	b=eWcg1gT50y6FaPVcCHsX4qA8SKNFroxCqxv7FM68JB8IlbTRkkI4Cd0rATNpCVp/+qnMCP
	MqHdM98Cm76atWuHb5V0KxYIplie3Ksvse+WcBGZYDJyE17ZGj32Z3k+NrZ4KYA0K5nXvr
	7BaLBK3Y/JWowVLLYgpyU5tYWqoZFsg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vRhCXB5d+1xHpm+rHDVsJTBtyYPUGsVwslLkzk8euVU=; b=f5D4Cy2ENteVaqqdHK2Qw8PBcd
	ge7qhzuCUKrwp3+FuAUV+NnRGTHl8qITS0yLk5+4d9u+OHSLGZb3QmAjowan7mBqZ//bzKve4CeTb
	XUUrhD3lzgxpoZfMMkCTlbtUDcCKqMOwQKSzq6RMP0Nth6d/wFfQUDbjKA/F1Qn8IhepP+I10UYFX
	SjFH04NFhDqGX0ckuS4cyw1LJqd19MhJdLMJM5l1rxakfpKT4khy1/ZtpN1dO8ZEHdZM1SG34UvLO
	LluzgX5rw6RKDldJrK3wVIQTTvRp7trL1ASSxe1wL2FuGiZJSEIlYUKJH4wKrON6S6KPnI69QVuth
	52m+rnaw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4066-00000009v1E-3w6K;
	Tue, 08 Sep 2026 17:59:07 +0000
Date: Tue, 8 Sep 2026 13:58:41 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, ljs@kernel.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
Message-ID: <qtx5xilsefyuqmhybk6s4i7pogz36tiara6wfayijj6oahbpu2@vrafyynbnb5d>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-2-surenb@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6FE1FC0005
X-Stat-Signature: dppaswhhh5wwnq6zrmbme7t38dtufzeo
X-Rspam-User: 
X-HE-Tag: 1788890350-432576
X-HE-Meta: U2FsdGVkX18kii1jPJ38G1cwcUsXGBEJiVQagoa1bjcaIVqtcnFh+xttw9/8tye1sbanzKOLi8S/aog818rCs0TiSzFyX7CSGf/rwelEFk+BkiscYRNAdIRFaIBZvOF81G/xMub5GNUYNGzVV45JocwHfFANw+AhqL57rtEnYfV76sr76GxUQloJ2TXn6zrMX+M5lXdJC8icov1RczO4zl7UcD5UmhkxGx3/AThKTgxveVbZemm6mSX9cirHbQh4bFOQB0UNM7EmykVgHcMlQTkh5qVTwPmw2EQg9fZLeKo3XvKESIEo5A0LED7ocmefgjxZv4mhGWAd7PgDHdiaZCcL+HDiV7VseKVyH4axsiAfA5d1ShPbO6rryO7zI0AqqmtVs2xjwlY2Zbmn2FDDtVB533Az9Y3x94dAElaxnthPnECM6BvoL/Z8zGnO0OdCQLDrdC9LDi2r02dRwNaTqVL6Mr83PWYF8TWTkDcO+I1kSoJqxpq/TI30gmPv9KPzQIN0yXRDBkfUm/hSuWYHRf+CF9vPHwQqYaWaikilHofXhxUE4H5B7ncQ1LTf2UYok4fQ3Ul08vCyfFj1z9pRk0Q6hft+wYTRLxOfCWGiOEzentdglS3mf4LbKYF4JTzZhmWcfnEjDv2wmr+hdRoQFYUc8rbjbkrzVgt0kWcWVMwGxR4FpLqJw1EhDxq/JDzXxI15NuAc12hw8AM4F/nzkDpNRa8LCyjP+xyZJsr59jn5/LKXYDZP+oy9IQuylUSGBfTM2yAoDYq6oTnV1PJQ3M8hj8vCYNldx7Tnqdyy4bR2DsK/AOVQ0ImRCZdQIDeMYFBRBM+NJd78I/jAENIqPfVDkBOZwDb/Z0Kvw71cCo+/LkhR+SyF4ubseMcLEm6DWcOoJ5lvkD6p+7y/jJgPLrG+Y2aOGobHsizv6Yw1DXG/zjBMxxOtYPNmeXYO41CQCvnVkZWbaGlEtZ2mkgU
 8tf5nB6M
 fSaBGFaoC17R+mgfcoCiXPSsI8+Z3mPvjmsZv+HBrsI6WdWtYEcnkWgOiFHJC9ivo7Eb3SiIU998BSqIvJxU4bFTt5szcR49tBylmT40/slJ64O6pLGL2LLB6cwpKFUk3C9m0p/kdkAX0x9Q/xmquARQXBkUiD/1exrDW5Dh6NyTZc6zwyo1oq5i9FszHd0nqjiZ36pibhNhANw+awIKOMY/WePcwoVwFpxaZYpxmEDQxiGIB6MPz5xfH0E6huiPuOgRTovvWrA9CwkYuXfzww9ypT+oXc2pRBu/9i5PubegZbMI5dzi8r7TWraxgKve7KyoAJ7CX2wVCQdhlMLAWOR/1vVydnoohswwrMyZFw8ADXqXTFbHWbSq7OGwHk/e/JMnkVB53M73CfVVeNsN4njK4QWi2HcLN6jZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/06 11:39PM, Suren Baghdasaryan wrote:
> When per-vma locks were behind a config option, a number of helper
> functions were needed to simplify the locking code. Now that these
> locks are universally available, we can do a little cleanup.
> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> query_vma_teardown() helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  fs/proc/task_mmu.c | 67 ++++++++++++----------------------------------
>  1 file changed, 17 insertions(+), 50 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e671b4fd8ded..2f500d639db5 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -160,25 +160,6 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>  
> -static inline bool lock_vma_range(struct seq_file *m,
> -				  struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	rcu_read_lock();
> -	reset_lock_ctx(lock_ctx);
> -
> -	return true;
> -}
> -
> -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	if (lock_ctx->mmap_locked) {
> -		unlock_ctx_mm(lock_ctx);
> -	} else {
> -		unlock_ctx_vma(lock_ctx);
> -		rcu_read_unlock();
> -	}
> -}
> -
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  					   loff_t last_pos)
>  {
> @@ -286,13 +267,8 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
>  		return NULL;
>  	}
>  
> -	if (!lock_vma_range(m, lock_ctx)) {
> -		mmput(mm);
> -		put_task_struct(priv->task);
> -		priv->task = NULL;
> -		return ERR_PTR(-EINTR);
> -	}
> -
> +	rcu_read_lock();
> +	reset_lock_ctx(lock_ctx);
>  	/*
>  	 * Reset current position if last_addr was set before
>  	 * and it's not a sentinel.
> @@ -325,7 +301,12 @@ static void m_stop(struct seq_file *m, void *v)
>  		return;
>  
>  	release_task_mempolicy(priv);
> -	unlock_vma_range(&priv->lock_ctx);
> +	if (priv->lock_ctx.mmap_locked) {
> +		unlock_ctx_mm(&priv->lock_ctx);
> +	} else {
> +		unlock_ctx_vma(&priv->lock_ctx);
> +		rcu_read_unlock();
> +	}
>  	mmput(mm);
>  	put_task_struct(priv->task);
>  	priv->task = NULL;
> @@ -518,21 +499,6 @@ static int pid_maps_open(struct inode *inode, struct file *file)
>  		PROCMAP_QUERY_VMA_FLAGS				\
>  )
>  
> -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	reset_lock_ctx(lock_ctx);
> -
> -	return 0;
> -}
> -
> -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	if (lock_ctx->mmap_locked)
> -		unlock_ctx_mm(lock_ctx);
> -	else
> -		unlock_ctx_vma(lock_ctx);
> -}
> -
>  static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_locking_ctx *lock_ctx,
>  						     unsigned long addr)
>  {
> @@ -653,12 +619,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
>  	if (!mm || !mmget_not_zero(mm))
>  		return -ESRCH;
>  
> -	err = query_vma_setup(&lock_ctx);
> -	if (err) {
> -		mmput(mm);
> -		return err;
> -	}
> -
> +	reset_lock_ctx(&lock_ctx);
>  	vma = query_matching_vma(&lock_ctx, karg.query_addr, karg.query_flags);
>  	if (IS_ERR(vma)) {
>  		err = PTR_ERR(vma);
> @@ -732,7 +693,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
>  		vm_file = get_file(vma->vm_file);
>  
>  	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
> -	query_vma_teardown(&lock_ctx);
> +	if (lock_ctx.mmap_locked)
> +		unlock_ctx_mm(&lock_ctx);
> +	else
> +		unlock_ctx_vma(&lock_ctx);
>  	mmput(mm);
>  
>  	if (karg.build_id_size) {
> @@ -773,7 +737,10 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
>  	return 0;
>  
>  out:
> -	query_vma_teardown(&lock_ctx);
> +	if (lock_ctx.mmap_locked)
> +		unlock_ctx_mm(&lock_ctx);
> +	else
> +		unlock_ctx_vma(&lock_ctx);
>  	mmput(mm);
>  out_file:
>  	if (vm_file)
> -- 
> 2.55.0.979.g7e5102b832-goog
> 

