Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD5BAC79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C6D6B008A; Wed,  9 Sep 2026 10:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0ECB6B0095; Wed,  9 Sep 2026 10:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0016B0096; Wed,  9 Sep 2026 10:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 742596B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:25:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A446EA0255
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:25:41 +0000 (UTC)
X-FDA: 85194447282.18.47BE124
Received: from mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 45B238000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:25:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KChA5PLT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KChA5PLT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963939;
	b=iygaNZhv0rKMfc7LQM6s0Ke1/truBJvZeoJdZzcFKyHfLwNJfxuxW6LBk+SIr4n3vZkrw/
	Fmloh+J/dt1mWHFhQV2fXZemuULKt+QZjTQQcVP8VnV6F/MhSYqfgvtuanYPi/Wm7XuwiA
	YRhB3RW6u5s969ITzCmKUO95Ez+2U2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TqnOoBMPyjBKLaPzCFKipDo5MnAqUhfg/53HlF80ZU0=;
	b=m7k/cOvFRLHNFkQPgHvZYawkVLcSIBolj5GqRTf6g33JvvaLMvrQXC38tktNrV9JCSlCQX
	PBVs2vVi5mCLL0eK9/wv3m8wD56Gg/2e0sEBySIUTKtxUu8ZopZxEzk8HqXNnSLZcFXjxi
	ECqHDQO6cPLlHWEh0/hOg0mblNZ/iTg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=65Vd1i575pVwFDqS0HjAKVD37s76Yk2EfVlhKLF5ST0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788963934; v=1; x=1789568734;
 b=KChA5PLTPKUOIRTqIcchHU+xoTSze9zXsMyJi8mdnc357VRf3FKeKWU3PX81BQTcVJ+3c8e7
 6oUrJxKV2dKloDn2YSVkyE5pJnIaPYLGKUF5qJ5Zhj05XUOAKdGRYM4X7LPXGbdO0Zz3DcyQzk9
 eQvKR9wIbnL/vTTPOerrDckw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 54d0913fc2edb7e6;
	Wed, 09 Sep 2026 14:25:34 +0000
X-Mizu-Trace-ID: 54d0913fc2edb7e6
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
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
Date: Wed,  9 Sep 2026 07:25:26 -0700
Message-ID: <20260909142527.1601051-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907063918.3432401-5-surenb@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 45B238000D
X-Stat-Signature: wqchz7wquhajiw3tfr5ipe6r1xhms5e6
X-Rspamd-Server: rspam01
X-HE-Tag: 1788963939-772481
X-HE-Meta: U2FsdGVkX18Cn/li0HTRIw9Jk1aqZFo97n8sXOUw/QYIPXe1amJ0IlL1gcdwdTTJ7WJxwODn5t6KHzvc6Bg/d+aaQqJesPvcupvTNJbbWDQIfs3VdYWb6oHuv4WcSljsyoShtgcPwpHATAPQ/gLwOFsLy3a4RmTXvHAmu08Q4A3DrUYTgIq6z+KlvEsHobc1nr7+H67TsUpCspJ/gILnNM05SxsatKWEwcR4vfPz0tUgFBu1pRrJe4jHc0S4IiLrWIzptWSHz/QLsvM7kQXbknvne/BISzmQRlxbDG+UkaB+iG5CmnYg6P4+XMw8BpzNY+9bABno0++S27ujsEv0IQXe46RSEdDJawQy1/XUP4LcKkIfZqAQDofaaiSgA634p3T4SnJw7fqW+Au0iWiJl351/yzod0SwrO5jGPD5eH/Wbf4KtiUwtLiVZYD+q43IKyw9Q7EccdQRLDJ8YUKAUUO+t6x0Mw4QO5NLmVUIpdyQi2q66x4RWovXrFKie2JFb1oBdKg3ik6rQe55lndigG0RNVhqmsKfK0ctI1D/Aiv8/aw8/ZGFo2iLhcUX1YjgE1Kb5ZEa5JQHLC3gMYpm+6BLjR6Isjaxi01PfKDQps8lBLFmRKg77a/opynm/TK+VHMHkvb7Au6O7WWLG9qNt6novm9lnon4QO3Yy6qAEnsA5fMtJdYqM66KDZQKqt+xOHBampf6mmMg8sBcS9UdsaRRaci8OrWCriA207/wIEoE+FwvUCK921RQH2F0Tn6f5GSDL0DwmtjhkRXbA6uYtXHZOAIY0JH1dFcSIi1AcrIvxjaJvNOhNxo5RXSKqVJvNUgJoiCA0Yant4gpI3fhj8jcInJtJclkHI2NRFNor3hAhaArriG6tsFMwdFUDw+bN21nYTkG3XW225bD6asOeZlflMVnolRoeGIiLEP2/4Kp4Qw8Rlo9qG5ZNKn1qXdS1p4wKwR40wpq6tFmTYu
 8RJs7981
 A0WhGjCQ2NcEk3bWEdhrOQ/o1VxbOC2DXeWeXBAH4Lu8Hn90RGKGQRi97Rzr1ldba+tkNcBmJaDRTZmbMKydoHJF0VWuJEanZ9IVQtpOXal4dGCGS+cJ5iRuAljjqbR1abJejpEYidwKxlCAw4rjULNvVcYbzV1wwxUUfpouYnM2oMQDSiv5oIq2XkVK3gsS+CduybqLa1f8Zu7HVs4u3TrmeuEqzpbSmSBBR9FRXbUteYiMuM5qMEgksf3AEP/KgoAqg3qHR8gq6D83Wcy3N9dEkgAJRhKhQZJpwve/fNp0AzvcIhptr5GmFj9devBTDp/E6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  6 Sep 2026 23:39:17 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> proc/pid/smaps_rollup can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> required to safely traverse the VMA tree and VMA lock stabilizes the
> VMA being processed and the pagetable walk.
> Note that we have to keep the logic to drop mmap_lock on contention
> because even when using per-VMA locks we might have to fall back to
> holding the mmap_lock.
> 
> Running Paul's contention benchmark [1] shows considerable improvement
> both in median and in the worst case latencies:
> 
> Execution command: run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> --busyduration 2 --procfile smaps_rollup
> 
> Baseline:
>    Median   Minimum   Maximum
>     0.174     0.161     2.553
>     0.174     0.164     2.663
>     0.174     0.165     2.664
>     0.174     0.166     2.679
>     0.174     0.167     2.691
>     0.174     0.168     2.704
>     0.174     0.169     2.729
>     0.174     0.172     2.741
>     0.174     0.174     2.745
>     0.174     0.174     2.755
>     0.174     0.175     2.790
>     0.174     0.177     2.809
>     0.174     0.179     3.096
>     0.174     0.183     3.144
>     0.174     0.184     3.158
>     0.174     0.185     3.175
>     0.174     0.185     4.568
>     0.174     0.198     4.821
>     0.174     0.214     5.143
>     0.174     0.251     5.220
> 
> Patched:
>    Median   Minimum   Maximum
>     0.007     0.007     1.952
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.955
>     0.007     0.007     1.957
>     0.007     0.007     1.969
>     0.007     0.007     2.065
>     0.007     0.007     2.075
>     0.007     0.007     2.146
>     0.007     0.007     2.195
>     0.007     0.007     2.223
>     0.007     0.007     2.259
>     0.007     0.007     2.488
>     0.007     0.007     2.562
>     0.007     0.007     2.599
>     0.007     0.007     2.697
>     0.007     0.007     3.030
>     0.007     0.007     3.075
>     0.007     0.007     3.145
>     0.007     0.007     3.225
> 
> Remove now unused lock_ctx_mm() and move unlock_ctx_vma() next to
> unlock_ctx_mm() as they are logically related.
> 
> Remove a long comment about 4 cases that we handle when dropping the
> mmap lock in the middle of VMA walk due to contention. The first 3
> cases explained there are handled naturally and only case 4 needs to
> be handled in a special way, which is done in smap_gather_stats() by
> gathering stats from the portion of the VMA that has not yet been
> processed.
> For posterity, moving this comment here:
> 
> After dropping the lock, there are four cases to
> consider. See the following example for explanation.
> 
>   +------+------+-----------+
>   | VMA1 | VMA2 | VMA3      |
>   +------+------+-----------+
>   |      |      |           |
>  4k     8k     16k         400k
> 
> Suppose we drop the lock after reading VMA2 due to
> contention, then we get:
> 
> 	last_vma_end = 16k
> 
> 1) VMA2 is freed, but VMA3 exists:
> 
>    vma_next(vmi) will return VMA3.
>    In this case, just continue from VMA3.
> 
> 2) VMA2 still exists:
> 
>    vma_next(vmi) will return VMA3.
>    In this case, just continue from VMA3.
> 
> 3) No more VMAs can be found:
> 
>    vma_next(vmi) will return NULL.
>    No more things to do, just break.
> 
> 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> 
>    vma_next(vmi) will return VMA' whose range
>    contains last_vma_end.
>    Iterate VMA' from last_vma_end.
> 
> [1] https://github.com/paulmckrcu/proc-mmap_sem-test
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  fs/proc/task_mmu.c | 153 ++++++++++++++++++---------------------------
>  1 file changed, 60 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 3351decd1172..641a155b0c61 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,28 +130,12 @@ static void release_task_mempolicy(struct proc_maps_private *priv)
>  }
>  #endif
>  
> -static int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	int ret = mmap_read_lock_killable(lock_ctx->mm);
> -
> -	if (!ret)
> -		lock_ctx->mmap_locked = true;
> -
> -	return ret;
> -}
> -
>  static void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	mmap_read_unlock(lock_ctx->mm);
>  	lock_ctx->mmap_locked = false;
>  }
>  
> -static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -	lock_ctx->locked_vma = NULL;
> -	lock_ctx->mmap_locked = false;
> -}
> -
>  static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  {
>  	if (lock_ctx->locked_vma) {
> @@ -160,6 +144,12 @@ static void unlock_ctx_vma(struct proc_maps_locking_ctx *lock_ctx)
>  	}
>  }
>  
> +static void reset_lock_ctx(struct proc_maps_locking_ctx *lock_ctx)
> +{
> +	lock_ctx->locked_vma = NULL;
> +	lock_ctx->mmap_locked = false;
> +}
> +
>  static struct vm_area_struct *get_next_vma(struct proc_maps_private *priv,
>  					   loff_t last_pos)
>  {
> @@ -1376,12 +1366,14 @@ static int show_smap(struct seq_file *m, void *v)
>  static int show_smaps_rollup(struct seq_file *m, void *v)
>  {
>  	struct proc_maps_private *priv = m->private;
> +	struct proc_maps_locking_ctx *lock_ctx = &priv->lock_ctx;
> +	struct mm_struct *mm = lock_ctx->mm;
>  	struct mem_size_stats mss = {};
> -	struct mm_struct *mm = priv->lock_ctx.mm;
> +	unsigned long last_vma_end = 0;
> +	unsigned long vma_start = 0;
>  	struct vm_area_struct *vma;
> -	unsigned long vma_start = 0, last_vma_end = 0;
> +	loff_t pos = 0;
>  	int ret = 0;
> -	VMA_ITERATOR(vmi, mm, 0);
>  
>  	priv->task = get_proc_task(priv->inode);
>  	if (!priv->task)
> @@ -1392,89 +1384,60 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  		goto out_put_task;
>  	}
>  
> -	ret = lock_ctx_mm(&priv->lock_ctx);
> -	if (ret)
> -		goto out_put_mm;
> -
>  	hold_task_mempolicy(priv);
> -	vma = vma_next(&vmi);
> +	rcu_read_lock();
> +	reset_lock_ctx(lock_ctx);
>  
> +	vma_iter_init(&priv->iter, mm, 0);
> +	vma = proc_get_vma(m, &pos);
>  	if (unlikely(!vma))
>  		goto empty_set;
>  
> -	vma_start = vma->vm_start;
> -	do {
> -		smap_gather_stats(priv, vma, &mss, vma->vm_start);
> -		last_vma_end = vma->vm_end;
> +	if (!IS_ERR(vma) && vma != get_gate_vma(lock_ctx->mm))
> +		vma_start = vma->vm_start;
> +
> +	while (vma) {
> +		if (IS_ERR(vma)) {
> +			ret = PTR_ERR(vma);
> +			goto out_unlock;
> +		}
> +
> +		if (vma == get_gate_vma(lock_ctx->mm))
> +			break;
>  
>  		/*
> -		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * If after retaking the lock, already reported VMA grew or
> +		 * merged with the next one, smap_gather_stats() will gather
> +		 * stats for the remaining portion by starting at last_vma_end.
>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> -				goto out_put_mm;
> -			}
> +		smap_gather_stats(priv, vma, &mss, last_vma_end);

Patch 3 made smap_gather_stats() reject starts below the VMA, while this
function initializes last_vma_end to zero.

The first ordinary VMA is therefore skipped. lock_next_vma() can also
return a VMA beginning after the requested position, so the first VMA
after every unmapped gap is skipped as well. This causes
smaps_rollup to underreport RSS, PSS, swap, and the other accumulated
values.

I think you need:
  unsigned long start = max(last_vma_end, vma->vm_start);
  smap_gather_stats(priv, vma, &mss, start);



> +		last_vma_end = vma->vm_end;
>  
> +		/*
> +		 * If the VMA lock is not taken, we hold the often contended
> +		 * mmap lock. This can happen if we had to fall back to the
> +		 * mmap lock.
> +		 *
> +		 * To relieve pressure, check if it is indeed contended, then
> +		 * temporarily release it.
> +		 */
> +		if (lock_ctx->mmap_locked &&
> +		    mmap_lock_is_contended(lock_ctx->mm)) {
> +			unlock_ctx_mm(lock_ctx);
>  			/*
> -			 * After dropping the lock, there are four cases to
> -			 * consider. See the following example for explanation.
> -			 *
> -			 *   +------+------+-----------+
> -			 *   | VMA1 | VMA2 | VMA3      |
> -			 *   +------+------+-----------+
> -			 *   |      |      |           |
> -			 *  4k     8k     16k         400k
> -			 *
> -			 * Suppose we drop the lock after reading VMA2 due to
> -			 * contention, then we get:
> -			 *
> -			 *	last_vma_end = 16k
> -			 *
> -			 * 1) VMA2 is freed, but VMA3 exists:
> -			 *
> -			 *    vma_next(vmi) will return VMA3.
> -			 *    In this case, just continue from VMA3.
> -			 *
> -			 * 2) VMA2 still exists:
> -			 *
> -			 *    vma_next(vmi) will return VMA3.
> -			 *    In this case, just continue from VMA3.
> -			 *
> -			 * 3) No more VMAs can be found:
> -			 *
> -			 *    vma_next(vmi) will return NULL.
> -			 *    No more things to do, just break.
> -			 *
> -			 * 4) (last_vma_end - 1) is the middle of a vma (VMA'):
> -			 *
> -			 *    vma_next(vmi) will return VMA' whose range
> -			 *    contains last_vma_end.
> -			 *    Iterate VMA' from last_vma_end.
> +			 * Even though we previously fell back to mmap lock,
> +			 * we try taking VMA lock for the next VMA, since it
> +			 * might not be under modification. In the worst case
> +			 * we will fall back to mmap lock again.
>  			 */
> -			vma = vma_next(&vmi);
> -			/* Case 3 above */
> -			if (!vma)
> -				break;
> -
> -			/* Case 1 and 2 above */
> -			if (vma->vm_start >= last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, vma->vm_start);
> -				last_vma_end = vma->vm_end;
> -				continue;
> -			}
> -
> -			/* Case 4 above */
> -			if (vma->vm_end > last_vma_end) {
> -				smap_gather_stats(priv, vma, &mss, last_vma_end);
> -				last_vma_end = vma->vm_end;
> -			}
> +			rcu_read_lock();
> +			reset_lock_ctx(lock_ctx);
> +			/* Resume from the last position. */
> +			pos = last_vma_end;
> +			vma_iter_init(&priv->iter, mm, pos);
>  		}
> -	} for_each_vma(vmi, vma);
> +		vma = proc_get_vma(m, &pos);
> +	}
>  
>  empty_set:
>  	show_vma_header_prefix(m, vma_start, last_vma_end, 0, 0, 0, 0);
> @@ -1483,10 +1446,14 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
>  
>  	__show_smap(m, &mss, true);
>  
> +out_unlock:
> +	if (lock_ctx->mmap_locked) {
> +		unlock_ctx_mm(lock_ctx);
> +	} else {
> +		unlock_ctx_vma(lock_ctx);
> +		rcu_read_unlock();
> +	}
>  	release_task_mempolicy(priv);
> -	unlock_ctx_mm(&priv->lock_ctx);
> -
> -out_put_mm:
>  	mmput(mm);
>  out_put_task:
>  	put_task_struct(priv->task);
> -- 
> 2.55.0.979.g7e5102b832-goog
> 
> 

