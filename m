Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F02C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5115F6B0098; Tue, 21 Jul 2026 06:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2AE6B0099; Tue, 21 Jul 2026 06:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3CB6B009B; Tue, 21 Jul 2026 06:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1A06B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:46:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DEEF1A0468
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:46:46 +0000 (UTC)
X-FDA: 85012455612.05.5586D00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AF97C20006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:46:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LpSb/m/n";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784630804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dO+PVrm5HMtA1iQW+bv64CElxpl8z6fE8uq5ZpX/a00=;
	b=Bio4S2+ABT/OQB64nkoXVZYy36KbFn7+HaN7Gmio4tmDs+lt1xrvW9X/rI+j4ifCFsEXUt
	pO3DHTL0uoyBqpx+ige1owiVdQt4KoJwSPX+5fogpM2W1FBcA779CTC6Tz88v6HixVP/3g
	5HY9fTCg6gaF5muVYZDHjUG55KGsU4Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LpSb/m/n";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784630804;
	b=PRAdUKUmYr6Y4HiFCBJrWsPKKxdsMm4tQXfVE3WAgtK5twgUFH2VN6fA5syMG7dJJlzXmu
	IDc7H4VN0KiVn2SNRK2f+4wz8ChYJ2NtB7BMT7txJThyV2NmMv/Fb7/iGU/tjdOVi3U/0k
	d/CGVMaxNm6lDdsAHFgl0yEDaYtAk4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84CE9407BC;
	Tue, 21 Jul 2026 10:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B50A1F00A3F;
	Tue, 21 Jul 2026 10:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630803;
	bh=dO+PVrm5HMtA1iQW+bv64CElxpl8z6fE8uq5ZpX/a00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LpSb/m/nFwv6Fxf5E4wwMzA7a+zOz1RBkSBx/X2VMxQsjr3Jh5IKmhspJL2hbmV7V
	 /o2P27drWcfPuhXrKLBUxWzh7xlRF/f+KelYKfm1dhIsE4iZzJS9mR4Jsif7unblPh
	 XyXCRDg8gkRqH/5VgHF31/P3ht3P9mDAaZJolDrrk+J09luZY75llAHOiBc3u95Fkt
	 s1NRRgaO1p+mVXyxHrRrkvd/sVLJLVghF6Vce1FP+c02FIOQ/dt4gh4lLaj+s0nv0N
	 YrVAtJf5Yjlmnu8I1sxzExiRnxIVsfghFGLy6EL3LrC82sPMhJhLsAqM80fja5mayC
	 rxhrYrO/l9lgQ==
Message-ID: <12c63386-f96e-421e-b34c-00548d016f69@kernel.org>
Date: Tue, 21 Jul 2026 12:46:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next v4 5/8] mm/slab: allow kfree_rcu_sheaf() on
 PREEMPT_RT
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
 <20260720-kfree_rcu_nolock-v4-5-964e03c41a4e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260720-kfree_rcu_nolock-v4-5-964e03c41a4e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF97C20006
X-Rspam-User: 
X-Stat-Signature: pwndg8z73ggh8wrqhbtyw4ncuh59hpjq
X-HE-Tag: 1784630804-717988
X-HE-Meta: U2FsdGVkX1/C5wFCf+PqY/Hp9ci7VucgLQ5m5y+jHPZm5aGS9qdGQiw4WmBNL5P7Q3DXj3KKKJ275CnZL4nvtoQfcMpvtansWxKNpx9sDIa+z3jAaX1F2g9wc+JRkfEcQb7nT4nSWcgQPdV4FKXw5lZ9pPncmCqogVR83pvRJfYSapotsHamPRYvOx5adSL9f2uMG+MWNypJX9zJo1mnJaKz26+ikcrIpkH7ARUsSUGbWNzOAMR7yPsbmsXBvspJ73gHDuCCXfNJIj1snP18/mgSBxhnzN1vf+BZ3od7TXo6lGDvwjLv0cSD2ezGd2JELmnkVS09UuCsfyd78q4WjbXe4RtgckZqbkDNJDw7Pj39o1PWbIzg0tAIHjstP7zDWPNY+3Daz1b4B4/84Qv29aLDIJdnaeLL74XpUkha8ALXrfe1K+D3dPUbOiq/1oDCP1fuTYFBVc39uY1YHHYjNRtBCQu93IpygMiniIOTqJ8dehMArvI658yXbGDhcojDzxsbHZh7pGYr97SDOtVuGu0vzaZt1+mC3eDTC0Jt9oWZScnp+2/vKd5xnDJbHtO0Dwc8Ah4VdI/Ov8U7metlotThPPx6MbGTRxOXTMWuwCeSnRN+PnH6Cbtvd5nGJ/Fs6dNYyge1rGjmIwbCkzCHLsKyHTuSVfoykMHpCYLNBsfx0RxAIa9UheAsWWxMfUtfxmaxXO1CwngaixDvpV35s5rXy+mnWrIMl8gswsCLbGqXmDpotSVnDwxMrjLKrPgkRG6ZVKlogT+cy8OzBBsK2+uRkUm5J5ZWKzACwR7Iwln70VXmGm4d5yS330eKE5r3Uy9uSsfPF6SqYIPs+AEKrrUH2TNlBnmhipKilzIkS34LOaJBck9eNGtKQk8ySR6roFvCzVpFCddeh46tU5J9aGfcycqUmPWKY/A2lw6GfWgQcLSwqrb48nTYGokdB6nQobzgNdAMIx5PDACQVXt
 U+hu4+Em
 F9qOy6xyZpssoBMuH2i0ZqhZg68yoXp/Muca4WAcnfyjJIHTPPkczSl9o9811HXerTBqkhBEr5MZAIgS3hnSvp08XflViBB5euIsWfF7kR3RoARul17b3YRGjIPhFTL6AEFFGFNWT141CCa4CnleGljE/YlEHmMEyqSlu1ey9uaEFeXMV3QC3Hvvs4YZVXYTKk2JGV3vjy3o9ChIkp4Jrx2/xaZ/wTdQJC/G6gv3Z2JJygN4Rovy7913LOZF43II4CYqeKu+S4s4Inr/VTCcLED5WlJZPC8dtW63bAgd3A3Nrwjh75CefWu4EQ7Tdd51rnasJn/iAy+Ju4zA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/20/26 14:44, Harry Yoo (Oracle) wrote:
> As suggested by Vlastimil Babka [1], kfree_rcu_sheaf() can be used
> on PREEMPT_RT if we always assume spinning is not allowed on PREEMPT_RT.
> This is because local_trylock and spinlock_t are safe to use with
> trylock and unlock as long as the kernel does not spin and the context
> is not NMI and not hardirq.
> 
> Now that __kfree_rcu_sheaf() knows how to handle SLAB_FREE_NOLOCK,
> relax the limitation and try the sheaves path on PREEMPT_RT as well.
> 
> Keep the lockdep map on non RT kernels. However, do not use the lockdep
> map on PREEMPT_RT to avoid suppressing valid lockdep warnings.
> 
> As pointed by Vlastimil Babka [2], on PREEMPT_RT it is unnecessary to
> defer call_rcu() under IRQ-disabled section or raw spinlock. However,
> let us avoid adding more complexity as the scenario is not supposed
> to be common on PREEMPT_RT, with a hope that call_rcu_nolock() will be
> soon supported in RCU.
> 
> Link: https://lore.kernel.org/linux-mm/6811cc17-8ee4-48c8-8cbf-6bf4d9f98162@kernel.org [1]
> Link: https://lore.kernel.org/linux-mm/40591888-3a87-433e-b3d2-cda1cab543be@kernel.org [2]
> Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> ---
>  mm/slab_common.c | 12 ++++++++++--
>  mm/slub.c        | 17 ++++++++++-------
>  2 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 9c9ae1384f47..8c631bf97cd5 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1595,6 +1595,14 @@ static bool kfree_rcu_sheaf(void *obj)
>  {
>  	struct kmem_cache *s;
>  	struct slab *slab;
> +	unsigned int free_flags = SLAB_FREE_DEFAULT;
> +
> +	/*
> +	 * It is not safe to spin on PREEMPT_RT because the kernel might be
> +	 * holding a raw spinlock and slab acquires sleeping locks.
> +	 */
> +	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> +		free_flags = SLAB_FREE_NOLOCK;
>  
>  	if (is_vmalloc_addr(obj))
>  		return false;
> @@ -1605,7 +1613,7 @@ static bool kfree_rcu_sheaf(void *obj)
>  
>  	s = slab->slab_cache;
>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) == numa_mem_id()))
> -		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
> +		return __kfree_rcu_sheaf(s, obj, free_flags);
>  
>  	return false;
>  }
> @@ -1954,7 +1962,7 @@ void kvfree_call_rcu(struct rcu_head *head, void *ptr)
>  	if (!head)
>  		might_sleep();
>  
> -	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
> +	if (kfree_rcu_sheaf(ptr))
>  		return;
>  
>  	// Queue the object but don't yet schedule the batch.
> diff --git a/mm/slub.c b/mm/slub.c
> index 8afa6b47b1f2..deac315d0f23 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6065,12 +6065,13 @@ static void rcu_free_sheaf(struct rcu_head *head)
>   * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
>   * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMPT_RT),
>   * this would violate lock nesting rules. Therefore, kvfree_call_rcu() avoids
> - * this problem by bypassing the sheaves layer entirely on PREEMPT_RT.
> + * this problem by passing allow_spin = false on PREEMPT_RT.

by passing SLAB_FREE_NOLOCK ?

>   *
>   * However, lockdep still complains that it is invalid to acquire spinlock_t
>   * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a
>   * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
> - * by temporarily raising the wait-type to LD_WAIT_CONFIG.
> + * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lockdep map
> + * on PREEMPT_RT to avoid suppressing valid lockdep warnings.
>   */
>  static DEFINE_WAIT_OVERRIDE_MAP(kfree_rcu_sheaf_map, LD_WAIT_CONFIG);
>  
> @@ -6080,10 +6081,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	struct slab_sheaf *rcu_sheaf;
>  	bool allow_spin = free_flags_allow_spinning(free_flags);
>  
> -	if (WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT)))
> -		return false;
> +	VM_WARN_ON_ONCE(IS_ENABLED(CONFIG_PREEMPT_RT) && allow_spin);
>  
> -	lock_map_acquire_try(&kfree_rcu_sheaf_map);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		lock_map_acquire_try(&kfree_rcu_sheaf_map);
>  
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		goto fail;
> @@ -6181,12 +6182,14 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
>  	local_unlock(&s->cpu_sheaves->lock);
>  
>  	stat(s, FREE_RCU_SHEAF);
> -	lock_map_release(&kfree_rcu_sheaf_map);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		lock_map_release(&kfree_rcu_sheaf_map);
>  	return true;
>  
>  fail:
>  	stat(s, FREE_RCU_SHEAF_FAIL);
> -	lock_map_release(&kfree_rcu_sheaf_map);
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
> +		lock_map_release(&kfree_rcu_sheaf_map);
>  	return false;
>  }
>  
> 


