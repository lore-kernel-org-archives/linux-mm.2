Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD88AC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF046B008A; Mon,  7 Sep 2026 12:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6DD6B0092; Mon,  7 Sep 2026 12:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B5E96B009B; Mon,  7 Sep 2026 12:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7606B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:45:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 34BFC801F9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:45:28 +0000 (UTC)
X-FDA: 85187541936.15.74DE32C
Received: from mta0.migadu.com (out-160.mta0.migadu.com [91.218.175.160])
	by imf02.hostedemail.com (Postfix) with ESMTP id B223B80003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:45:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E11nSGYU;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc6MGrnTFqPOHRNZArCbRz8raYJunEYGf39QT/Y0QQw=;
	b=6RHKkbF9LkC5W6+12r+tSsZEYv5IiDNZDDHtiN7fGUfROF56J4gWAyvfxfclulO4a7iBif
	YaQgti9jdcKLCyUv1gYGf61smnSGxWFVdcoVvUi0U+8SzUxY23kQyJmQdkIBYjKK057s0n
	2eS17cXRNECBA3DiL8ZEJyx79WrtEO0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799525;
	b=ohHNk2zj2XXrD/5rwpRY8e+Gs4S5K4a8tB+6hJ51fHD9kI8GTGjLRYtrY+NrQ8SPA6DF6p
	S/zIuvo5Tx64CF9jLiMI2vtLFHgx/bfZqpT4HSX9Uz37c24hIvu2mwrVkpM74MOdrt/gBU
	ujEAdQ367jm1LE/SuR2iqtH9dVJsmPs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E11nSGYU;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.160 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mA7P/Qe1tvxUEQLZlPrgfbJg0c6VIZe0R0iXWMkfLmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788799523; v=1; x=1789404323;
 b=E11nSGYUdFDOKkZEOPkTm2YxFAzEOKlNI8sSZFUvCSIyQLC1YygSwlGE1iHVJFpLwtucE0Fu
 YYktdxxUDnVQwqq3ue65c/Yo6t0OAYZjFqLPLh2RH9D8nxDUdxFacmtLDoLfdt4YSJlymhzQF7j
 ea+Dmb7tbknUTrQYlJ+hOm2g=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f0a5260ef7ab4742;
	Mon, 07 Sep 2026 16:45:04 +0000
X-Mizu-Trace-ID: f0a5260ef7ab4742
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	david@redhat.com,
	willy@infradead.org,
	jannh@google.com,
	paulmck@kernel.org,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] proc/task_mmu: remove unnecessary helpers
Date: Mon,  7 Sep 2026 09:44:57 -0700
Message-ID: <20260907164500.3920334-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907063918.3432401-2-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B223B80003
X-Stat-Signature: s374eo1ghm4c8ebrgtr8g5w9fi5w3xwi
X-HE-Tag: 1788799524-603607
X-HE-Meta: U2FsdGVkX18uzucssgMeIqCpgH/1OSLGIjLDKJwDQydSQ3neXVqMeP2IhVggLhio+c3SRHCLsokaQo21D5BZ5XydGtazDUdpuwF0A4hnnUekYRoR1v/FuLYp/wY0QgQvBdwsqJrUR5VCQEisgA/TMFCagBVWqKPkTV6rk0ChtSBVKuP8WoLJlx6LsCS1xDexS6+WkzqulW9qZdNGO6lv6XfpsWooyu8ohblGroQ1Kn3uLSzGoIlnm5TK54wUBdBS979IKalpThQ7H1Njl+DpSbjgd3P4atEuKAyyp+J+RTgFmPCo4PTeoe7GhiXShQCCIF3SmMDDsZFEq7wnuxG0ElzkpGE93eMr1eOq70R00BxbMdJJByRFtXJBw6FqDxruoBC+qMSxubER0KblKe0U1T2c+kZRb0y0Eu3gN9cmv/Wa1GJ3gh9aD7b4kcdzxthdfCS7AuWdwBIdt5Lw6hN9caTF1RQ73b4cWAJmrcIB1gWzzr0y+GbJmsumdoJIEvcthQkPT+2eYHqTeT8hlZmpU82SMHrUQylkIXxJi1V33cQDz2oNHScuRTXakF0Fpbj8dNmgprs57JfidQRoWTILHAdaTtfGqjyyvuHxEUzSv4bz6CMpvhX9Ud3ZnMwckv4wvgcZ6pfuC8nTpGpajniv01vswYLDNix2B/66tWFHI5idFl5efvf8q5Vcp7fFZi+1s4tnpLr83Jd44D03OTyBaOW+RJ/1eMohtFS7486XDL47Mqc+Wxwv5ERUlUGUvJe+811Lj44v6UeMKeM1wTnHOMBDNoRl90y7Av0Wk+DULlQnGd4mYdKd84nLYeMA0hCHVE5LutlXghBN5dvlBWw0ag+80xc0lVxQ2nT0lKa19HppKmY/wa0bgDkdpOZ824uQysLGGIfwQW6IQE4TApbiKBEYNZdCb9CTCjiH3G3mnoh+GCJlATXgjJBqj0PI+GedpdUVcCvsqXWUnBKiAAV
 kmm5y/ys
 a82GacMCGkzhY3WoPyRFUQn8/Xj46g38E9qv8io7d3HmxbocUeavSjCUFAhWt39v2cC4F0jnzajetWyeyM0PRqGDRgAf8ap3Wxc/b+HwkBHvYVvfAtZAnrYhehutO5IezW78EadOEgCGZkfgCF0lBA3xuoD+6C4emPeeILAWmM6IhJLZfh/IxCVdN3Yh4NTpU09H3FGasrvWQNN+FQHOaOCXjd4HN40A3O+E9gDIabRoD1BUeGgMdeaNx45tbHegyUd+w1tqvAmT2mkfyoj5oMC2jtgmAUhQkdh9bRk0pcsGTPHd1Q2NyLtCDbsGJ6sBM8+Z1urCo2BXuDne31pAP11C2jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  6 Sep 2026 23:39:14 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> When per-vma locks were behind a config option, a number of helper
> functions were needed to simplify the locking code. Now that these
> locks are universally available, we can do a little cleanup.
> Remove lock_vma_range(), unlock_vma_range(), query_vma_setup(),
> query_vma_teardown() helpers.
> 
> No functional change intended.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 67 ++++++++++++----------------------------------
>  1 file changed, 17 insertions(+), 50 deletions(-)

Change makes sense independent of the series as well.

Acked-by: Usama Arif <usama.arif@linux.dev>

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
> 

