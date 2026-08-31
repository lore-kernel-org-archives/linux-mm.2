Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A14D6C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3756B009E; Mon, 31 Aug 2026 09:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBC76B009F; Mon, 31 Aug 2026 09:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1346B00A0; Mon, 31 Aug 2026 09:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5608C6B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BE1ABC014A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:01:02 +0000 (UTC)
X-FDA: 85161574764.29.791FBD7
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf13.hostedemail.com (Postfix) with ESMTP id E74522000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:01:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=lyE6qyKj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VNqZwd9w;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788181261;
	b=vf0S6Ma91zrgm7VFcFw4YJaB6bSewmXzLUwvXs3GtWJ9hBNbZvW7Tpa4UAX4AU88+CrA1S
	+y64ujGL8Xrk30Y1GMpMO0pd3TmrNHBMToKJ40nH5FH8IWBnYJ7XzYTiL2dU0J9thXmfFD
	lQwMmAl/6aW0x/tiDOER72C7hpzQdU0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=lyE6qyKj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VNqZwd9w;
	spf=pass (imf13.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788181261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVKRVR8QAa3+pNGan/n7Vu6OKGnK3U7HFuskJ9RSYns=;
	b=I7n5uhIrybwSmN+wUZVd9dqtugaLS5f8ANox1jt2uhZFb9IE2dL5+KzLYEXwqG4CeH8j0F
	4b+Ka4f+rRmqC24DZZvhmUxV4AkhRYJaH8HxsUFYDysxWWqHq9PAjGUixvSd1mVWCpDhXT
	5FZBajsAOnZqJ5oqoyyPeHW2ZrNikEk=
Date: Mon, 31 Aug 2026 15:00:57 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788181258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVKRVR8QAa3+pNGan/n7Vu6OKGnK3U7HFuskJ9RSYns=;
	b=lyE6qyKjPXT1Qxi/43WwjoH1OJeBQ3ngIPaLC80rD3A0Ijx4uH9sE9dQbYHt235OWu76xv
	5hPIUKh8o8FOxu8jafjHXxa01Otyf2nExAEovTKKDCKq6SDVZoj7biMn2aqFdmauYWaZei
	fH19P+pdJGPk37qhIPk/oQCFFTuU0ZWAXr1pSb9fBeIE4CMhwLCSXUa88/N4MdPRlatVAl
	AMAQH98/Jf2HlJZr/B2E7IDdZkiuVpAU5hN3avLgxD4QEvnJL1tdvtq/qbe70oBK0F2f8I
	w1CpwqzpBtPhMCkGPxfuYZ+A16FbHg2tVX2or6tfvoez7HDa42DnTG+FsYixwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788181258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVKRVR8QAa3+pNGan/n7Vu6OKGnK3U7HFuskJ9RSYns=;
	b=VNqZwd9weJWTl4G/a215AAzey2BWbnZFMvlcNcL/18S2VuRfDyDdUqJ0MSUTSUdOoJewGL
	nK/ILA+zUhqFj3Dw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: ThangNN99 <ngocthang2710.1999@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	syzbot+acf142088e0182172e58@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm/slab: don't use kfree_rcu sheaves on PREEMPT_RT in
 kvfree_call_rcu()
Message-ID: <20260831130057.HLukQ-zm@linutronix.de>
References: <20260831053846.107974-1-ngocthang2710.1999@gmail.com>
 <20260831060633.6831-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260831060633.6831-1-ngocthang2710.1999@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 9e7n6z98jxwwdnxpekjuky5xwap6txox
X-Rspamd-Queue-Id: E74522000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788181260-102094
X-HE-Meta: U2FsdGVkX1+gbIlD1j2wNUnVgVtMiQp6Awam4QXHdiQgdJLObA8fNnXut9Yl0Awdk5+c/8V6rj4lQmPC7afydsRS+GJQXv8I5nr2PR7i7Ri6br4KaMApCbgkCW2/WqqL5Qh8hedY7i61Dv8xJth2xq97jKncKBeuV6jBHv3NwEjZ+vdh6KtB4y3aTh7M/EjQpMUZpexr9/34K6QXsZr6PZmwbI7UhBqil8NMHEdvziM1QVNInAG7sayBCFKLKPAR69iTeSz2sjh/q9HG/Sp0zpXk00RnnlHjFKgDqxr7/70uvaED1zdtO3sid04Qi3ElKtdm8QyKc2psMRCWLdzvUVn+9B5Vkzn8iMYck7MJdKFXwRG1slq+nZlSjp/Abqeso8Iy0xnax/NkR64CecelGretsmOKif7jHaSmDVGcnGLlsb9Et2BT/3YBAYyV3pbzysTvRM1f3lbgxhairBjYrpXnObhLtnm3vTVWTBh2EWw06EL5Az4wt3F3qTmrtGyEGXtcwvSHZzwiXKNQ1lApM48PLK92Q6HVI6UYDoVRsf64uwh1da9tOWYKMoKt1vMRcmKmpWYkxGNGugc3Hip9/8lNNj6pKtB00yAEhXfYk+kCUcoY8GgScFCz5MHTLsgxOrHUQk8l6TRKowY4wuN8gkMUwHRK3LnXcqpn1MOnYvEf0J1J1reTuw+rPwvgAAVeK/kTHRfngdxOtC7ovw6BYc1y3CJs3bWDuVEnAhm8iDSObmjDSWEi8mTdgFAvUTUoqvWftiU/T4EYyCtZVR1/aXahw/WBRVMGyDOr+9IcwtdjGePpomdmFzNaexCXPO6/+jfzFyYvPoyCLZBLtcVqzCTjyju6NtSFUjjvFcIy2bm8KxlaLIsi5OVJxDO/iWWVvMFnKlmiD71iV9VZXoYvAVdRMrhFC8ln3BbZLK7Nfph8df5o7H0S4LslYZsqk2Z69k4dUmwURiDphPGsDpL
 3KBjK11Z
 brRBM2n7o7a+Z1fViZ/UKbBpRw661Ts74EPrUNAVdIYeJsa4zNzE+8FGT7KJ3MnEJIYY51aknltnps2Z4EIoM11JDYautcIMRI+U91vXR01k2Sn2+3PFY0Aq6SLZaZJfHglTh2CVAyVrOoNZLrIJkSKBe8M8Wpok69GxYSFkbvVSF10oeIr3Sc2bxbeVPd1yxaOWpQS91GhBmRNV+bpddCd6uPQR2xUshJju2nEwLFzHZ6yW30a3PtrdhkGdyP7VRPsuGTNL+1rl37at2cFBWNNgMHdPCcO03t/MputDign0JWwuJ7IygwwgbI+HaKR6wUEiEYE5Slp2zHAjQu/Owie8eYxnnfjEgdcVMjBwY20TU3JbU3bxKpeDnrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 13:06:32 [+0700], ThangNN99 wrote:
> syzbot reports a possible circular locking dependency between
> &p->pi_lock and the per-CPU kfree_rcu sheaf lock (_T->lock) on
> PREEMPT_RT:
>=20
>   __balance_push_cpu_stop()               [holds p->pi_lock, raw]
>     select_fallback_rq()
>       cpuset_cpus_allowed_fallback()
>         set_cpus_allowed_force()
>           kfree_rcu(ac.user_mask)
>             kvfree_call_rcu()
>               kfree_rcu_sheaf()
>                 __kfree_rcu_sheaf()
>                   local_trylock(&s->cpu_sheaves->lock)   <- _T->lock
>=20
> set_cpus_allowed_force() uses kfree_rcu() instead of kfree() here
> specifically because it can be called with p->pi_lock (a raw
> spinlock) held, and plain kfree() may sleep under PREEMPT_RT.

A raw_spinlock_t. Please don't invent new things.

=E2=80=A6
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index b19ba1b31484..3de1eabe6c77 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1667,15 +1667,8 @@ static bool kfree_rcu_sheaf(void *obj)
>  {
>  	struct kmem_cache *s;
>  	struct slab *slab;
> -	unsigned int free_flags =3D SLAB_FREE_DEFAULT;
> -
> -	/*
> -	 * It is not safe to spin on PREEMPT_RT because the kernel might be
> -	 * holding a raw spinlock and slab acquires sleeping locks.
> -	 */
> -	if (IS_ENABLED(CONFIG_PREEMPT_RT))
> -		free_flags =3D SLAB_FREE_NOLOCK;
> =20
> +	/* Callers on PREEMPT_RT never reach here, see kvfree_call_rcu(). */
>  	if (is_vmalloc_addr(obj))
>  		return false;
> =20
> @@ -1685,7 +1678,7 @@ static bool kfree_rcu_sheaf(void *obj)
> =20
>  	s =3D slab->slab_cache;
>  	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa_mem_i=
d()))
> -		return __kfree_rcu_sheaf(s, obj, free_flags);
> +		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);
> =20
>  	return false;
>  }
> @@ -2034,7 +2027,14 @@ void kvfree_call_rcu(struct kvfree_rcu_head *head,=
 void *ptr)
>  	if (!head)
>  		might_sleep();
> =20
> -	if (kfree_rcu_sheaf(ptr))
> +	/*
> +	 * Callers may hold a raw spinlock here on PREEMPT_RT (e.g.
> +	 * set_cpus_allowed_force() with p->pi_lock held), and the sheaf/barn

No. All callers of set_cpus_allowed_force() hold task_struct::pi_lock.

> +	 * locks are also taken as blocking locks elsewhere, so trying them
> +	 * here creates a lockdep-visible ordering conflict. Skip sheaves on
> +	 * PREEMPT_RT.
> +	 */
> +	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))

Given that this can hold the pi_lock I am not a big of this trylock
underneath. So skipping it is my favorite.

>  		return;
> =20
>  	// Queue the object but don't yet schedule the batch.
> diff --git a/mm/slub.c b/mm/slub.c
> index f9b56cb439e7..1e8bad7a018e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6088,10 +6088,10 @@ static void rcu_free_sheaf(struct rcu_head *head)
>  /*
>   * kvfree_call_rcu() can be called while holding a raw_spinlock_t. Since
>   * __kfree_rcu_sheaf() may acquire a spinlock_t (sleeping lock on PREEMP=
T_RT),
> - * this would violate lock nesting rules. Therefore, kvfree_call_rcu() a=
voids
> - * this problem by passing SLAB_FREE_NOLOCK on PREEMPT_RT.
> + * this would violate lock nesting rules. kvfree_call_rcu() avoids this =
by
> + * bypassing the sheaves layer on PREEMPT_RT.
>   *
> - * However, lockdep still complains that it is invalid to acquire spinlo=
ck_t
> + * lockdep still complains that it is invalid to acquire spinlock_t
>   * while holding raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is=
 a
>   * spinning lock. Tell lockdep that acquiring spinlock_t is valid here
>   * by temporarily raising the wait-type to LD_WAIT_CONFIG. Skip the lock=
dep map

Sebastian

