Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132D5CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDEA6B008A; Wed, 20 May 2026 06:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A53B6B008C; Wed, 20 May 2026 06:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693AC6B0092; Wed, 20 May 2026 06:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 57FF76B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:08:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE039401C9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:08:18 +0000 (UTC)
X-FDA: 84787373076.28.176547D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49DCE4000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:08:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A6ulyNup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779271697; a=rsa-sha256;
	cv=none;
	b=FjcSOlxZbi0NJMi/Q+ew9mNASxqLO1nlc2/FuV0dq3155oma4D9/4JAAI9iM/sFxcLDLT/
	R/tMr3VbZf8xUpiO/89X9Ir4unl7QPdpuXcq3Cz/EFiHO+OHJa5uyMKfKcX9SSoqNPrb/R
	VsDN7UASldK8JGIif8I+cMuShACSgP4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A6ulyNup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779271697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1plGy0FQ7nYQb+3n+hUO+JVJ5dhvb8hv+ZuBfUYeEk=;
	b=z0Cf8s27pU02v0L2iDPPA4XwqLge0mPAbQBfoyitIy7oSj8ojSY7PVlF8b+tVK0RjsulVR
	HeI4sfMclFqaGTfjHsXzoJUV6De+gMLW+dSyi0GDdtPcmxp4Bv8P68Ut3T/BsOciYE6ulf
	X8+YOFGc8FCaXLBQKE1Mi1QLg9X6574=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B35F26012B;
	Wed, 20 May 2026 10:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09AC1F000E9;
	Wed, 20 May 2026 10:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779271696;
	bh=Q1plGy0FQ7nYQb+3n+hUO+JVJ5dhvb8hv+ZuBfUYeEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A6ulyNuprKY+N3RMw5O3QKkAEAn2+LHCkX+Ddtt0IPU1Auey3PS0MWcnkQRA8pqSq
	 k4Uy3aDScb6hJ9/WXmMiikck/7qM5FzU4DTGv6tfqHA5UM475Iv4oKxzWmDGL9jr2D
	 yyeGCzm/C0r758UKpo8fx7HlkjoXk5CFlrL5Mf1uGbqKhGe/6fG6/2c+ZFf1jKVPjO
	 o9hJcwdsxYVZBvgpzqMdgqMJPVclYlAP0FQWxYbPEZFUoveF1sQIJpnDjTu2VIBqSj
	 R7OGgt7nQ698CTYbnWw5qY1ohfDz/cNTK4zXkxuCK9qW2E0E7/sKt7w0/XnFTezmeg
	 UkBhsvQS9m7cQ==
Date: Wed, 20 May 2026 12:08:13 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Leonardo Bras <leobras.c@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>, Masahiro Yamada <masahiroy@kernel.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush
 work
Message-ID: <ag2IDR-JWn8k3bUG@localhost.localdomain>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-2-leobras.c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519012754.240804-2-leobras.c@gmail.com>
X-Stat-Signature: 453np9o1egbdhyj5ifoa9q7gridhp7im
X-Rspam-User: 
X-Rspamd-Queue-Id: 49DCE4000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1779271697-189514
X-HE-Meta: U2FsdGVkX19R1GDEgjqqR5lhamdUNJh37hAxSCmq2ByeIkB23Yrcfwblrw7XoQ5g0F8fJ9q58T+1AxHkoQMWTCCajYBSkc2sgLG0TmeTB0E4zN1yIGXrCi6kRn8x6cBEbDFKdMqPbrz5AUtGph6FkqnIkCQZ48G/QU94pxaXhYvnv9dtKCHfmf+HhUMqC3AwDbulWhod5hoDzjk0iSwMlcMx0T4xrpSmX/0WwlBWoQkdOjff7eU99Ufsw/4oHs6MI9HcXkxjcXz7FFqoh0itrH+5HWEDTav6fFSEAOl5vwGYBRbJI5/YrOB3ryasBwVlHVmmc2RPJgvuNaXSbmIAFE/Fz9GMrFmwtN6D2jPTE4pGRbdIstc/fWP70DLc7umU47m24Suru+cOuAoz3bQBG2Zr8MqTDJV95N12TQckTOVVo8x+jZdRlfwwYpqkA8ga7sCSxKM9kzv/4e0aDpQ+fXqETsr3JmmMUG0a3cPfu1r/4G02BfFsPhgmzaqRr9P/yhcwdhkaR2fcWcO1z6/WBWp8WCyPSnWI0wjoluY2KBlsXJljjMxP/aUpF3ApJHLas98X+Tlxaloi5jp3Kdeu3zzF6peSK2FpQ/XFFymDI1z+9b5ZguVOWGQOBYWE3V5P5Wp9bpWkS0naK9P50jmNqZSfTg/bUQbhaj/yoCHx0z8D10yw/EJ8tG9y0dn2Mt4fsMGNL6t0RNRKEdUmloumxQYp9E226Zc3HLJlh7PCBLkHpzxK9UKNboBH8c0/3cUutA5lOuk0CtsVxL+z1NnvSO5w+LggsEZQpLQtWYzfKh/voxJVcf99kIiVC+LfZqFfPV8/FLqTU9NfEDUU26Dhy79FlKzelk4/rcxmMBpsoz3Fb/klzYrR8fpu5CW+K2iQgbEvu4riCh4PhDa+qO48dIvZEWUZOyy3jm/3SG/ud6K/IIkkY1R/a7SduNBvzqEXZnox0xrf/0lSmOE1eWf
 cCa5UQ4s
 lpV3Qzyfow1A6d5z56QxJVnqqXrfHvZJj9Rj0rQxJcu2zuDYYdWW4PLDhHc7K8/9xonJPcUGFoX/iQklnA2p08XPupypW8lTaSg5/idk/RmE77LCzT4nrLxTQGFORupb9FtHf/ATtSHARQFpcr9YzC8bhBnfhr9mgIK25JoC95CByCuQCm0lshg6RdfliLAaMxAJzz9AVAChb260vgyrY6wDTXPMYvNw1pSd8qc9E7JcX8xPMj2iby0WSBnktXrBLdtTbyNj5FRXS3rR95Gx5rGaX/AXYbSv560fMwdJZLQUNQUOPnF1Ipp5dHPqyYR6dQAkukLVeuvavDNMv++Dc4ZJBa0nu00mB6ZdqC+89YuP6lYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, May 18, 2026 at 10:27:47PM -0300, Leonardo Bras a écrit :
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.
> 
> On the other hand, for RT workloads this can represent a problem:
> scheduling work on remote cpu that are executing low latency tasks
> is undesired and can introduce unexpected deadline misses.
> 
> It's interesting, though, that local_lock()s in RT kernels become
> spinlock(). We can make use of those to avoid scheduling work on a remote
> cpu by directly updating another cpu's per_cpu structure, while holding
> it's spinlock().
> 
> In order to do that, it's necessary to introduce a new set of functions to
> make it possible to get another cpu's per-cpu "local" lock (pw_{un,}lock*)
> and also do the corresponding queueing (pw_queue_on()) and flushing
> (pw_flush()) helpers to run the remote work.
> 
> Users of non-RT kernels but with low latency requirements can select
> similar functionality by using the CONFIG_PWLOCKS compile time option.
> 
> On CONFIG_PWLOCKS disabled kernels, no changes are expected, as every
> one of the introduced helpers work the exactly same as the current
> implementation:
> pw_{un,}lock*()		->  local_{un,}lock*() (ignores cpu parameter)
> pw_queue_on()  		->  queue_work_on()
> pw_flush()		->  flush_work()
> 
> For PWLOCKS enabled kernels, though, pw_{un,}lock*() will use the extra
> cpu parameter to select the correct per-cpu structure to work on,
> and acquire the spinlock for that cpu.
> 
> pw_queue_on() will just call the requested function in the current
> cpu, which will operate in another cpu's per-cpu object. Since the
> local_locks() become spinlock()s in PWLOCKS enabled kernels, we are
> safe doing that.
> 
> pw_flush() then becomes a no-op since no work is actually scheduled on a
> remote cpu.
> 
> Some minimal code rework is needed in order to make this mechanism work:
> The calls for local_{un,}lock*() on the functions that are currently
> scheduled on remote cpus need to be replaced by either pw_{un,}lock_*(),
> PWLOCKS enabled kernels they can reference a different cpu. It's also
> necessary to use a pw_struct instead of a work_struct, but it just
> contains a work struct and, in CONFIG_PWLOCKS, the target cpu.
> 
> This should have almost no impact on non-CONFIG_PWLOCKS kernels: few
> this_cpu_ptr() will become per_cpu_ptr(,smp_processor_id()) on non-hotpath
> functions.
> 
> On CONFIG_PWLOCKS kernels, this should avoid deadlines misses by
> removing scheduling noise.
> 
> Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

I like it! Just a few observations:

> +#ifndef CONFIG_PWLOCKS
> +
> +typedef local_lock_t pw_lock_t;
> +typedef local_trylock_t pw_trylock_t;
> +
> +struct pw_struct {
> +	struct work_struct work;
> +};
> +
> +#define pw_lock_init(lock)				\
> +	local_lock_init(lock)
> +
> +#define pw_trylock_init(lock)				\
> +	local_trylock_init(lock)
> +
> +#define pw_lock(lock, cpu)				\
> +	local_lock(lock)

For debugging purpose, it would be nice to ensure that in those off-case,
cpu is indeed the local one. Basically all the non-local functions, those that
take a cpu, should verify:

lockdep_assert(cpu == smp_processor_id())

> +
> +#define pw_lock_local(lock)				\
> +	local_lock(lock)
> +
> +#define pw_lock_irqsave(lock, flags, cpu)		\
> +	local_lock_irqsave(lock, flags)
> +
> +#define pw_lock_local_irqsave(lock, flags)		\
> +	local_lock_irqsave(lock, flags)
> +
> +#define pw_trylock(lock, cpu)				\
> +	local_trylock(lock)
> +
> +#define pw_trylock_local(lock)				\
> +	local_trylock(lock)
> +
> +#define pw_trylock_irqsave(lock, flags, cpu)		\
> +	local_trylock_irqsave(lock, flags)
> +
> +#define pw_unlock(lock, cpu)				\
> +	local_unlock(lock)
> +
> +#define pw_unlock_local(lock)				\
> +	local_unlock(lock)
> +
> +#define pw_unlock_irqrestore(lock, flags, cpu)		\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define pw_unlock_local_irqrestore(lock, flags)		\
> +	local_unlock_irqrestore(lock, flags)
> +
> +#define pw_lockdep_assert_held(lock)			\
> +	lockdep_assert_held(lock)
> +
> +#define pw_queue_on(c, wq, pw)				\
> +	queue_work_on(c, wq, &(pw)->work)
> +
> +#define pw_flush(pw)					\
> +	flush_work(&(pw)->work)
> +
> +#define pw_get_cpu(pw)	smp_processor_id()
> +
> +#define pw_is_cpu_remote(cpu)		(false)
> +
> +#define INIT_PW(pw, func, c)				\
> +	INIT_WORK(&(pw)->work, (func))
> +
> +#else /* CONFIG_PWLOCKS */
> +
> +DECLARE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> +
> +typedef union {
> +	spinlock_t sl;
> +	local_lock_t ll;
> +} pw_lock_t;
> +
> +typedef union {
> +	spinlock_t sl;
> +	local_trylock_t ll;
> +} pw_trylock_t;
> +
> +struct pw_struct {
> +	struct work_struct work;
> +	int cpu;
> +};
> +
> +#ifdef CONFIG_PREEMPT_RT
> +#define preempt_or_migrate_disable migrate_disable
> +#define preempt_or_migrate_enable migrate_enable
> +#else
> +#define preempt_or_migrate_disable preempt_disable
> +#define preempt_or_migrate_enable preempt_enable

This can be no-op in !CONFIG_PREEMPT_RT because non-rt spinlocks
disable preemption already.

> +#endif
> +
> +#define pw_lock_init(lock)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_lock_init(lock.sl);					\
> +	else									\
> +		local_lock_init(lock.ll);					\
> +} while (0)

It looks like all these macros could be inline functions.

> +
> +#define pw_trylock_init(lock)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_lock_init(lock.sl);					\
> +	else									\
> +		local_trylock_init(lock.ll);					\
> +} while (0)
> +
> +#define pw_lock(lock, cpu)
> \

And those could have the same local CPU debug check.

> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_lock(per_cpu_ptr(lock.sl, cpu));				\
> +	else									\
> +		local_lock(lock.ll);						\
> +} while (0)
> +
> +#define pw_lock_local(lock)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		preempt_or_migrate_disable();					\
> +		spin_lock(this_cpu_ptr(lock.sl));				\
> +	} else {								\
> +		local_lock(lock.ll);						\
> +	}									\
> +} while (0)
> +
> +#define pw_lock_irqsave(lock, flags, cpu)					\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_lock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> +	else									\
> +		local_lock_irqsave(lock.ll, flags);				\
> +} while (0)
> +
> +#define pw_lock_local_irqsave(lock, flags)					\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		preempt_or_migrate_disable();					\
> +		spin_lock_irqsave(this_cpu_ptr(lock.sl), flags);		\
> +	} else {								\
> +		local_lock_irqsave(lock.ll, flags);				\
> +	}									\
> +} while (0)
> +
> +#define pw_trylock(lock, cpu)							\
> +({										\
> +	int t;									\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		t = spin_trylock(per_cpu_ptr(lock.sl, cpu));			\
> +	else									\
> +		t = local_trylock(lock.ll);					\
> +	t;									\
> +})
> +
> +#define pw_trylock_local(lock)							\
> +({										\
> +	int t;									\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		preempt_or_migrate_disable();					\
> +		t = spin_trylock(this_cpu_ptr(lock.sl));			\
> +		if (!t)								\
> +			preempt_or_migrate_enable();
> \

This is duplicating the RT logic in local_lock_internal.h and it would be
tempting to propose spin_local_lock_t that both pw and RT local_lock could rely
upon. But I'm afraid that would create a less readable result:

- we would need to check the CONFIG_PREEMPT_RT there before doing the
  migrate_disable/enable

- RT local lock don't take the lock on IRQ/NMI, which is fine as pw is not
  expected to be used on the non-threaded parts of IRQs not NMIs. Still that's
  one more conditional to add there.

- we'll need to differenciate local/remote operations.

Well let's stick to what you did for now (Peter might have a different opinion though).

> +	} else {								\
> +		t = local_trylock(lock.ll);					\
> +	}									\
> +	t;									\
> +})
> +
> +#define pw_trylock_irqsave(lock, flags, cpu)					\
> +({										\
> +	int t;									\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		t = spin_trylock_irqsave(per_cpu_ptr(lock.sl, cpu), flags);	\
> +	else									\
> +		t = local_trylock_irqsave(lock.ll, flags);			\
> +	t;									\
> +})
> +
> +#define pw_unlock(lock, cpu)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_unlock(per_cpu_ptr(lock.sl, cpu));			\
> +	else									\
> +		local_unlock(lock.ll);					\
> +} while (0)
> +
> +#define pw_unlock_local(lock)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		spin_unlock(this_cpu_ptr(lock.sl));				\
> +		preempt_or_migrate_enable();					\
> +	} else {								\
> +		local_unlock(lock.ll);						\
> +	}									\
> +} while (0)
> +
> +#define pw_unlock_irqrestore(lock, flags, cpu)					\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_unlock_irqrestore(per_cpu_ptr(lock.sl, cpu), flags);	\
> +	else									\
> +		local_unlock_irqrestore(lock.ll, flags);			\
> +} while (0)
> +
> +#define pw_unlock_local_irqrestore(lock, flags)					\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		spin_unlock_irqrestore(this_cpu_ptr(lock.sl), flags);	\
> +		preempt_or_migrate_enable();					\
> +	} else {								\
> +		local_unlock_irqrestore(lock.ll, flags);			\
> +	}									\
> +} while (0)
> +
> +#define pw_lockdep_assert_held(lock)						\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		lockdep_assert_held(this_cpu_ptr(lock.sl));			\
> +	else									\
> +		lockdep_assert_held(this_cpu_ptr(lock.ll));			\
> +} while (0)
> +
> +#define pw_queue_on(c, wq, pw)							\
> +do {										\
> +	int __c = c;								\
> +	struct pw_struct *__pw = (pw);						\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl)) {		\
> +		WARN_ON((__c) != __pw->cpu);					\
> +		__pw->work.func(&__pw->work);					\
> +	} else {								\
> +		queue_work_on(__c, wq, &(__pw)->work);				\
> +	}									\
> +} while (0)
> +
> +/*
> + * Does nothing if PWLOCKS is set to use spinlock, as the task is already done at the
> + * time pw_queue_on() returns.
> + */
> +#define pw_flush(pw)								\
> +do {										\
> +	struct pw_struct *__pw = (pw);						\
> +	if (!static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		flush_work(&__pw->work);					\
> +} while (0)
> +
> +#define pw_get_cpu(w)			container_of((w), struct pw_struct, work)->cpu
> +
> +#define pw_is_cpu_remote(cpu)		((cpu) != smp_processor_id())
> +
> +#define INIT_PW(pw, func, c)							\
> +do {										\
> +	struct pw_struct *__pw = (pw);						\
> +	INIT_WORK(&__pw->work, (func));						\
> +	__pw->cpu = (c);							\
> +} while (0)
> +
> +#endif /* CONFIG_PWLOCKS */
> +#endif /* LINUX_PWLOCKS_H */
> diff --git a/kernel/pwlocks.c b/kernel/pwlocks.c
> new file mode 100644
> index 000000000000..1ebf5cb979b9
> --- /dev/null
> +++ b/kernel/pwlocks.c
> @@ -0,0 +1,47 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include "linux/export.h"
> +#include <linux/sched.h>
> +#include <linux/pwlocks.h>
> +#include <linux/string.h>
> +#include <linux/sched/isolation.h>
> +
> +DEFINE_STATIC_KEY_MAYBE(CONFIG_PWLOCKS_DEFAULT, pw_sl);
> +EXPORT_SYMBOL(pw_sl);
> +
> +static bool pwlocks_param_specified;
> +
> +static int __init pwlocks_setup(char *str)
> +{
> +	int opt;
> +
> +	if (!get_option(&str, &opt)) {
> +		pr_warn("PWLOCKS: invalid pwlocks parameter: %s, ignoring.\n", str);
> +		return 0;
> +	}
> +
> +	if (opt)
> +		static_branch_enable(&pw_sl);
> +	else
> +		static_branch_disable(&pw_sl);
> +
> +	pwlocks_param_specified = true;
> +
> +	return 1;
> +}
> +__setup("pwlocks=", pwlocks_setup);
> +
> +/*
> + * Enable PWLOCKS if CPUs want to avoid kernel noise.
> + */
> +static int __init pwlocks_init(void)
> +{
> +	if (pwlocks_param_specified)
> +		return 0;
> +
> +	if (housekeeping_enabled(HK_TYPE_KERNEL_NOISE))
> +		static_branch_enable(&pw_sl);
> +
> +	return 0;
> +}
> +
> +late_initcall(pwlocks_init);

That should be a pre-SMP initcall. Otherwise you risk some asymetric calls.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

