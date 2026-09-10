Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2795C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D746B0092; Thu, 10 Sep 2026 11:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13E7B6B0093; Thu, 10 Sep 2026 11:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02D456B0095; Thu, 10 Sep 2026 11:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD31B6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:43:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6463380526
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:12 +0000 (UTC)
X-FDA: 85198271424.23.68B5DD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AD9F5180009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:43:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtcfTxtw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789054990;
	b=Znckrk0vdMtPxJ8iGK3AIo/x04Ubsv/itHW3+F/ydunLBce95WhOJ30qk7xM8C3L55n916
	Jd8ZjKqHhLEMUMqchM+jluUD3RHhjEGQ482UKqf7cg45xgXEXYMYnwqSr3y7dJ/yjB/vry
	cFHXxmdE8+ALP/xMm9nXc13o9I3Nv0k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PtcfTxtw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdfnsdvWI0jRNqVLMdcR0r8HJLdhTYwH56oScH4f4Pk=;
	b=lfO4GSMG1tf+7n4+af77zlbirGonmhcVyQ9TldV5nOIoRvlkmRRMtYmYVf/ppcuMaRWXp8
	wXyXYwiAP1INDnWYQOGta9zbuzx3s0YpSti8k4RyJLscgzatg1Hxg8w85gs1rrBs7jfDvg
	vZB0U8LoFZ+R/ZhahCfJxEbi6DV83EA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C53F74023B;
	Thu, 10 Sep 2026 15:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F481F000FF;
	Thu, 10 Sep 2026 15:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054989;
	bh=jdfnsdvWI0jRNqVLMdcR0r8HJLdhTYwH56oScH4f4Pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PtcfTxtw45R5MAhwdS6U8KTXfpVokzs3jxEpTI9fNqRYbNG8tO8oIN6VOk4J/zpDz
	 l7fF5oH34xgjuorX5jaiX4Okbtal8yV2+Ib/6+GIFhJDLrwb322Bveh2+XiuaylYCO
	 AoVYaUg2TSwF1stGN0IDxRm6IkaSSDb3QA6faezOvPq743U0knl01zmkYvEXucPnkg
	 k2ony48DnokaTCyyOYp3/M1dr9W8WQ3Dp8YpTbf8CpSybrx/yDod3z5IgtNcC4cM1u
	 FDlYntAFMq7ttb+PBptS7mI34Tg5IF8nzjCEirqMMhG63KvuJxmnK5W7yvjTISPWaw
	 TLY8z5R14Sm8Q==
Date: Thu, 10 Sep 2026 16:43:03 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
Message-ID: <aqLOusjRNlQtQsj-@gremlin>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907063918.3432401-2-surenb@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AD9F5180009
X-Stat-Signature: mjpjwgtf7psbw5n7z5ki1sxwg4edxq5o
X-HE-Tag: 1789054990-697096
X-HE-Meta: U2FsdGVkX1/uqWb8IqTJDharEHBB+O01iU8546UrA5rQWADuJg7u6MUriEtkx4dfzk6yK63Yxelc9j1/CWRYSPfQpfiibi/3zxku5pXYOBupp97HQaxj9CS87eeQrLLpU6umS7HlADyvlsNG8Upl6InAyKwM1M8GLXcrHQdvA9oy2/WiiiuzxPxO4Ep55kOIZV1+tcN6azLtI36HTtw939O5UNweQK4rM+6EViN6odXGPn3mDALlbI1cDO3FVZEcLzM7Zp4o6Kw4SrLP0OwKKFGQLTvrkqLmD0b0U0q36IsVZve08QkTtKrddqFnhdbKAKoY5Os/g2bsd8YOp28+hnY7RpDW3AXFQZxTHTsqj2t2bqWQPlDmCbH+u0EuT0CYuBmfcSCJ5tIDPDH7XCtYr/wdmKpgiawPQxUUpAavh6iWDkiWErU3/UqYfVjktFgZuZacsX7vi4EaFXwdC0ahWpJBf5cWxK6IU8iyk5TRTtVmLOzC7c1YHZnsGh8CIddPCu1ifLgw/moLRuzKYvjFHsf7AM8xfqVWiidcTdhrMRD8yErZ/XzJzi/l64jigM8Sqod/vNl/CfKcpqjQAdowRlvSqrtRoiSsqbJeecQ2NxBK0do83SieF9nCBTwHFFOSrH0drUaQN8Nzzncm7qxMrlneK8CRW2f0X0CTpe0ktuZA1PRZOnt4W7CsNXk+E8MSA4J29u806JR3SghkxuWfJp4yEz5lpJUf0UWrKb1brB1oVgWTxGmjk4TspsNZJV2L8t6c30jLDpU/4YYTmuELEp8aHa2o9hAmS7QiaQ2YQR1u6dYamf88PTDLN/rPEYrt4gRapTlmsnTkLW+YM3kB50A9feT+M9C93kPMcDsVBDS3tDnAKFwStDoAVY96FyxCOhsmVqdPW9iTjwGlTKShotgIipgiNzgHa6mZzBuPk2ADS1fnwZWyRC/Gk8psfqkeLfGIN8odAjFc0Ku8cSH
 ndiQZkyn
 56MMR0P4r75hA19hE8pobIaltmJUYnRBY5UhhQF0MiEm3CLRAo4K8b6IqPVuSdNfDmzXQLNGtr6rHh5Tr2XZ2DB2SWk2na5sqmfV+0SIWdUu/3vUrbY4r0lK65a6vAcXizZH3npiHcduGpF8JfmxW4o6GXO+I7LTDdOxiIJhYA2Msa2H1YKP+ndIcF/uA4ZsJBAEcjfO266eSCeOJcZ2ysWfZBzbT+E5PqaSlAGTVLH2kRrPkU+RHTrNuvWVNYVjHFEYE0l4A+aQT+ekeZVBquJG9yFT67VrvNW/jptKxx6KNsIA/gLBnCfnIagkWcFKipvcH54Ui7+96b8ftw8wFgeUyHjWBkxftN9Jd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 06, 2026 at 11:39:14PM -0700, Suren Baghdasaryan wrote:
> When per-vma locks were behind a config option, a number of helper
> functions were needed to simplify the locking code. Now that these
> locks are universally available, we can do a little cleanup.
> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> query_vma_teardown() helpers.

Oh nice :)

>
> No functional change intended.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

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

--
Cheers, Lorenzo

