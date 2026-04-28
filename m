Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05753FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:59:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27B906B0088; Tue, 28 Apr 2026 05:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BFE6B008A; Tue, 28 Apr 2026 05:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142826B008C; Tue, 28 Apr 2026 05:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 025F06B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:59:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A31D940561
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:59:45 +0000 (UTC)
X-FDA: 84707517930.03.C8DE9F6
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA9F61C0004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:59:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AgmJ4X1D;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777370384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiTyaQb0gH/enfcQNGJbMNOh9xViBgr4r/Sr0EX4sgQ=;
	b=Qy6QJgI3RssfV9onc+X2e5aiuLeYubdJRT/m8EtRdSoIVJdtPXu0nb5mQj3lwSqAr11Wo6
	6SzwoE7QOqMyJ7duw1fc8yweZZt06K2GhTTSqOen8Fq+gOn3+BMkZzoJKsSw2WhJA2qPCQ
	m53RlPmmDO/V6WTmlO1e+gQO/987p2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777370384; a=rsa-sha256;
	cv=none;
	b=G/vbpJNe1bPi6AClKUhLCWOKs9UznIvjxwLQl3wBAlNmHnZDiNiKkbm/nVTk0Q5ekZaQTx
	J5bfi0sgIpLgkQqlXwrqTM+aFkATwW9V0vlgOC99zhwtLyfOJltIjT5G2Dlq7SFMox+5MV
	ZsBuiF9j0vZdtO6Y5IuGN+ahAHQa6IQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AgmJ4X1D;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 28 Apr 2026 02:59:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777370381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MiTyaQb0gH/enfcQNGJbMNOh9xViBgr4r/Sr0EX4sgQ=;
	b=AgmJ4X1DAE/4K8J4aGBiJGCx4ShRw9Yk4yo1Nm9esDzMbomO1CMTEJ/p/pLVUlLgcw5JT8
	XV2Z30hj2JKnllRiwYLkUE5OtVei/iU193jyjAmZqF+ab+HCajouQKbV7RBj6tp8BVGw2H
	G/eCcKQG4Qs6/d568nEW6YW5nqIjA8Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, yosry@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH] mm: memcontrol: fix rcu unbalance in
 get_non_dying_memcg_end()
Message-ID: <afCEgUMqhLvrYJe7@linux.dev>
References: <20260428030621.94470-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428030621.94470-1-qi.zheng@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA9F61C0004
X-Rspam-User: 
X-Stat-Signature: 5cx4uiehkqpxb6giodtf7ybcet3qqdxr
X-HE-Tag: 1777370383-620756
X-HE-Meta: U2FsdGVkX1/b967cO7dR43Y1CJZENjdeO4IG1YLhK0HnzA0OwaemQAXUPQdeqsNW3hBMqToeUq/4Zm83Q8IITrdBjME3Gw5tUyuAhEDHH8L2qmgrM/y/saB6gVfygnuDWlQYjbDIXV9OmWHzl1sqnE/hvXBNys3+/zCR5yY6cA0DvOw5UQOYs1+okODdc4rAbQnn5R0vfeqKTAhD7wCZ7uMDfnkzM7jS+mfIkostmFiptPbp4lCOaULlojwcrDeGCONugTBkZBw74MjD6LJ6VIE11uMmBd8lEszZEQ0CyH4mL8hWny4qFYjJmm2zH1WkadTcpkPFIgBRk8IsLu2VTkYLze/klyh/dWB4vEbsfMHn/9ORHVEOfp32JbWVSdchGmKYmsrJ+vxIu+dX2jrONphUNtWi7u4l9H9ckzls6296UJ1pK17jUTi4vX1U/cS7vvKYvidKwFisLcAI+z0//2noghsS/qWeLjgKhrocfzwf7tw9fjIyjGnlUBFj18+J/nX22eAL9mOaDbYKDyPA98lLvu7KT67vtbrzXLObMHOfHEq+Ir3TirlxMc4Hh8ia5YPyIKS6GFU4ItIYc1eF2WpT8TFmtNapy62aFteqxu1doo3mXZ+f2cg11r7gqIfhS31KTrfeCPItu3FtbxeT4kr7NtkGGD4rfWjNRAHQ4nHf4zKJdh0e1IA7DQlkh5HvdqC79A8lGIOO558LnU68LdA/Gpr4Kg6INkL+VIaYvNG2vK8+yBdQwsO2gpaJLsJ4Rn75iKmINGAht55bLm8pTlC4J1VC4qKZ3YG5cgjKv9V/jeKPlnBdDXch0D+N149xsrgBVtUJkWCp/S95UEL2STNQaOUVBeuhKELc0fVtozhxxKEoO3TE/+vszN3S15Wsp+tN0IKpHG33SjDjn/Z13ASpWsmV4ccZs6YRYVCT7ZPbRytQVikVAv/yJHknl1wwIf7BGMluqerMWdt8RiQ
 Rmmlu21E
 SAmJmOcf/7dmw/NwqJ8Eniknhhf3g3NltgV1HqSXzMQYZbxc+7wT1GOLaG3FeVINc1pBm63DomR1U1clS74bql4nJeXMIEISrW3H3Jo6wuExXUs2L3pdEDyhtWk7PDGdMsT6j4FFgCR0lElWEDmWtoUaDoJasFvcvHWTFasFv2yqb/qMSWR/FbDN89BLZuKvTApn2BhCZEWwiNXPEHzb4dYLd69k/3z8XrAZF9T7jb1TXqLEvL0jmS5HBSkz1zZcAR8C1NSh/yNJqoiFulDLamEAPPnAOj2X7g0M7YbnxYsnHRuV8KcwWdB/wGnI4Nxf0gbkT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 11:06:21AM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
> evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
> determine whether to acquire or release the RCU read lock.
> 
> However, the result of cgroup_subsys_on_dfl() can change dynamically at
> runtime due to cgroup hierarchy rebinding (e.g., when the memory
> controller is moved between cgroup v1 and v2 hierarchies). This can cause
> the following warning:
> 
>  =====================================
>  WARNING: bad unlock balance detected!
>  7.0.0-next-20260420+ #83 Tainted: G        W
>  -------------------------------------
>  memcg-repro/270 is trying to release lock (rcu_read_lock) at:
>  [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
>  but there are no more locks to release!
> 
>  other info that might help us debug this:
>  1 lock held by memcg-repro/270:
>   #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x285/0x880
> 
>  stack backtrace:
>  CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: G        W           7.0.0-next-20260420+ #
>  Tainted: [W]=WARN
>  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>  Call Trace:
>   <TASK>
>   ? rcu_read_unlock+0x17/0x60
>   dump_stack_lvl+0x77/0xb0
>   print_unlock_imbalance_bug+0xe0/0xf0
>   ? rcu_read_unlock+0x17/0x60
>   lock_release+0x21d/0x2a0
>   rcu_read_unlock+0x1c/0x60
>   do_pte_missing+0x233/0xb40
>   __handle_mm_fault+0x80e/0xcd0
>   handle_mm_fault+0x146/0x310
>   do_user_addr_fault+0x303/0x880
>   exc_page_fault+0x9b/0x270
>   asm_exc_page_fault+0x26/0x30
>  RIP: 0033:0x5590e4eb41ea
>  Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
>  RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
>  RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 00007f73c474d44d
>  RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 000000000000000f
>  RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 00007f73c483a680
>  R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>  R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 00007f73c4869020
>   </TASK>
>  ------------[ cut here ]------------
> 
> Fix this by explicitly tracking the RCU lock state, ensuring that
> rcu_read_unlock() in get_non_dying_memcg_end() is strictly paired with
> the lock acquisition, regardless of any runtime rebinding events.
> 
> Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/memcontrol.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c3d98ab41f1f1..38f48a45b7ae5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -805,12 +805,17 @@ static long memcg_state_val_in_pages(int idx, long val)
>   * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
>   * reparenting of non-hierarchical state_locals.
>   */
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> +							   bool *rcu_locked)
>  {
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +	/* Rebinding can cause this value to be changed at runtime */
> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
> +		*rcu_locked = false;
>  		return memcg;
> +	}
>  
>  	rcu_read_lock();
> +	*rcu_locked = true;
>  
>  	while (memcg_is_dying(memcg))
>  		memcg = parent_mem_cgroup(memcg);
> @@ -818,20 +823,23 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
>  	return memcg;
>  }
>  
> -static inline void get_non_dying_memcg_end(void)
> +static inline void get_non_dying_memcg_end(bool rcu_locked)
>  {
> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +	if (!rcu_locked)
>  		return;
>  
>  	rcu_read_unlock();
>  }
>  #else
> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
> +							   bool *rcu_locked)
>  {
> +	*rcu_locked = false;

We don't need to set rcu_locked to false here as we don't access in !V1 build
option.

With that fixed, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

