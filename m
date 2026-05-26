Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA65CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 19:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB786B0005; Tue, 26 May 2026 15:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BCB6B0088; Tue, 26 May 2026 15:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B136B008A; Tue, 26 May 2026 15:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 152006B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:15:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACDEE12045E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:15:36 +0000 (UTC)
X-FDA: 84810525072.17.FCF0D06
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf27.hostedemail.com (Postfix) with ESMTP id DEBC040011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 19:15:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Fbhlw8Pe;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779822935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB5eVTfF0zRDfVbnx1RL/rZVOm/m3B8TjzZiFdbIjUo=;
	b=DvkTIWfgsrO7vkL1Sr39xDI3ZYPWGXNNXsX4/VKzCUckH7MAJkGSurgqq9D1h1aPLONN/w
	R2V8sSSaeHfOERYosWVuNp1379u2vyK5lU++5PHt+uagJ0Aq+9QTC6VRBy4f3INXYAuoCh
	Ew5rpKyrV6gPJPkmr8aOhK9mZxtYOtU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=Fbhlw8Pe;
	spf=pass (imf27.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779822935; a=rsa-sha256;
	cv=none;
	b=lSl1RbWsTp7LHWvqFbbdGT+leDMn8x6X5E4pzlIByHWT4evQZ3qhZWM2LK5ZINcxlQVNlW
	4ODcHiKfDiKjh4BUEtjI25S/2KISCDOs1nS4FmeUd/jjTjn3BiXmWoYpMgUodq786wyJ29
	k5rLFTz7ZVe7pGQc12+gqGg6+Q8NnSU=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 04AC240E30
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1779822933; bh=dB5eVTfF0zRDfVbnx1RL/rZVOm/m3B8TjzZiFdbIjUo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Fbhlw8Peae/8Hn0G1NPZxsR98yGpJoEnjnunxVRipUa/p8k2DOYXmReUgyriFlR9a
	 PBNYfMv2jxeK2gZpaj1+L2TBav0nie5ztMvDq9yzLGzsrlcGRANFjUpqYTmIWOFAJQ
	 ZIsrq+c6yhG/vdCOwxT3+rxOU2Tb9ykSaYe3Zskmz68qZNfsc1dftEyBIWfNGd6By5
	 FxcIq1KClJquic948orLD+YRpnIs/DaTg6h5/prZ9bhv8LbDgV37+tQnuX6GvGELZ1
	 8vYd4KZ7QkBJWo7kqBIIc/NNG/y8FZf+FbJq4b82Hlwmu7RG4hv0d2tC67xYFAHxjC
	 fb4gsW/t4m7mg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b:67c:16ff:fe81:5f9b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 04AC240E30;
	Tue, 26 May 2026 19:15:33 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Leonardo Bras <leobras.c@gmail.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Leonardo Bras <leobras.c@gmail.com>, Peter
 Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will
 Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Harry Yoo
 <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, "Borislav Petkov (AMD)" <bp@alien8.de>, Randy
 Dunlap <rdunlap@infradead.org>, Feng Tang <feng.tang@linux.alibaba.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kees Cook <kees@kernel.org>, Marco
 Elver <elver@google.com>, Jakub Kicinski <kuba@kernel.org>, Li RongQing
 <lirongqing@baidu.com>, Eric Biggers <ebiggers@kernel.org>, "Paul E.
 McKenney" <paulmck@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, Thomas
 =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Thomas
 Gleixner
 <tglx@kernel.org>, Douglas Anderson <dianders@chromium.org>, Gary Guo
 <gary@garyguo.net>, Christian Brauner <brauner@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Coiby Xu <coxu@redhat.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Frederic Weisbecker <frederic@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, Marcelo Tosatti
 <mtosatti@redhat.com>
Subject: Re: [PATCH v4 1/4] Introducing pw_lock() and per-cpu queue & flush
 work
In-Reply-To: <20260519012754.240804-2-leobras.c@gmail.com>
References: <20260519012754.240804-1-leobras.c@gmail.com>
 <20260519012754.240804-2-leobras.c@gmail.com>
Date: Tue, 26 May 2026 13:15:32 -0600
Message-ID: <87tsruvv6z.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: uuxxuatsfqnzzeouig5g8uucy1g9a8yr
X-Rspamd-Queue-Id: DEBC040011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779822934-147062
X-HE-Meta: U2FsdGVkX19eAqSUZWMzMav/s5mr6Z49GlRYZvhiMXwUG0e3VXWpvas4F4O/dHbmfrswMhiGWYkQItfe1iVzkx7JvtVH7JLLi0d7+cCPeSW9sXumuQ0z2g5/xrC+mfGSg243b3ZHMCeJ7gILZWty5NDfAcfnVg48US8Cl5vBAQ0m4QBGSvfgX5H/0BEzcO3WknTNvBYxYYGfF7KBpZEPfy12alL4KwWZq7rnlQlsiGfJ7rl5FQZ7IYm6/fmtXOEvUPzP9OQVlOXo2iQYWVk6UC9lP3QrIyMhkz6lTlu1avsfcj1hYgNQXBrtHV+wMG5GP8wZUx5wYD3QOcnqa4zaI9nvsCEm8HL2vsXv4z4olBqGEjb+v2U5poFBG4iX40IKIY+FJMfw6JX6Fjonj9HQkLQUYTayAN8IrpVajVdGQi/XhqtvcTcJU7NZoqpQNJ/xhernsjGA9PVcJGPCLkMG8Mxu5109wXKsyE27rQm6GiMEQF2aNYKQj99jQLQw4VEuVyEc+hV8Tx6FugPrfC6OIU6UXkPVmcHqRs607DNRNFVrhiYjS26ZRUbQ3DO7uS3Q3lK3JA5sgcnrA0royEYNau02IiRG9vdGVxgYxqGZIJAZ7JNVw/fXrEx60TgZE6J1MsRdzg0J3ql56bbbnUQFhoFXI/t+aIX4B4ECk3EwVpQcX92RX+8PvdLZiaR0P6UEP0vWYObjAyHUcHD7gpEac8KTVLRrAKKypiMjMt4MqbgghQmpZ+a8bAm6Ea8NSJ6F/MteEST+HlCOt0znpAYOAn3oCB1TwSv/QiNqjma5/W59Tg5jBgsvdXzg/BF7a5UAD/CpZL/xVlnPkxToAUsrJKrecjCAzApG52jjRmdBH3R/OaVOmINEKKk0h5DFhqo/q3Ove+f+EDUolUNS15OdgIIaBNRVTVvptLrVJ4zI8aVDfIZmzJ8vvy1xhYJ0AG8mFX/QdLEJeGx/3vXJXKD
 tiwN1Ie6
 CoBKF7gBaD6aier8dzMVnG81YvQHoxrDdJir1t8LDm7c730VqvYcjgFTavwWA9L3Rdn6GGMgs7lYuDZxcDSr0TX006vn4i36JsY6JehwNndamTuTjJAZ3xW6GhNQAJdH9uWYO6MFA2OtZdZddOpmtEGu2IQhh7vMDoA59bdcyPthW8VeGVxFjH8oqh+VZ+je2ED4LWu7Dn6twv4YJ8pwf8JLy+/oXZ6Kt5ZS01TdWM4PjwMRK63RFZk9pK+uBGzCe5D7OF+rtwiHzj2VK1wi7ygdvAKjHLyhXemBtYpPZjVdGBgYBYuZ5Cqk6x2y6HfAki8ZlRzGSxng6BmNHo9cS1l+TwH+nXPy5b4328AyXhFi3dX0yEwAV3M2ewUTv7YMGuMvdNI9IWpZszQywqelmUvwRVjNCKFB4PMw9csn6fvfeQt/Es/WYc6BXqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Leonardo Bras <leobras.c@gmail.com> writes:

> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.

A couple of documentation-related nits:

> ---
>  MAINTAINERS                                   |   7 +
>  .../admin-guide/kernel-parameters.txt         |  10 +
>  Documentation/locking/pwlocks.rst             |  76 +++++

You have added a new RST file here, but haven't added it to the table of
contents in index.rst.  So it won't be part of the docs build.

>  init/Kconfig                                  |  35 +++
>  kernel/Makefile                               |   2 +
>  include/linux/pwlocks.h                       | 265 ++++++++++++++++++
>  kernel/pwlocks.c                              |  47 ++++
>  7 files changed, 442 insertions(+)
>  create mode 100644 Documentation/locking/pwlocks.rst
>  create mode 100644 include/linux/pwlocks.h
>  create mode 100644 kernel/pwlocks.c

[...]

> diff --git a/Documentation/locking/pwlocks.rst b/Documentation/locking/pwlocks.rst
> new file mode 100644
> index 000000000000..09f4a5417bc1
> --- /dev/null
> +++ b/Documentation/locking/pwlocks.rst
> @@ -0,0 +1,76 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========
> +PW (Per-CPU Work) locks
> +=========

The over/underlines should match the text in length.

> +Some places in the kernel implement a parallel programming strategy
> +consisting on local_locks() for most of the work, and some rare remote
> +operations are scheduled on target cpu. This keeps cache bouncing low since
> +cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> +kernels, even though the very few remote operations will be expensive due
> +to scheduling overhead.
> +
> +On the other hand, for RT workloads this can represent a problem:
> +scheduling work on remote cpu that are executing low latency tasks
> +is undesired and can introduce unexpected deadline misses.
> +
> +PW locks help to convert sites that use local_locks (for cpu local operations)
> +and queue_work_on (for queueing work remotely, to be executed
> +locally on the owner cpu of the lock) to a spinlocks.
> +
> +The lock is declared pw_lock_t type.
> +The lock is initialized with pw_lock_init.
> +The lock is locked with pw_lock (takes a lock and cpu as a parameter).
> +The lock is unlocked with pw_unlock (takes a lock and cpu as a parameter).

Did you want that to be an itemized list?  If so, put "- " in front of
each line.

> +The pw_lock_irqsave function disables interrupts and saves current interrupt state,
> +cpu as a parameter.
> +
> +For trylock variant, there is the pw_trylock_t type, initialized with
> +pw_trylock_init. Then the corresponding pw_trylock and pw_trylock_irqsave.
> +
> +work_struct should be replaced by pw_struct, which contains a cpu parameter
> +(owner cpu of the lock), initialized by INIT_PW.
> +
> +The queue work related functions (analogous to queue_work_on and flush_work) are:
> +pw_queue_on and pw_flush.
> +
> +The behaviour of the PW lock functions is as follows:
> +
> +* !CONFIG_PWLOCKS (or CONFIG_PWLOCKS and pwlocks=off kernel boot parameter):
> +        - pw_lock:			local_lock
> +        - pw_lock_irqsave:		local_lock_irqsave
> +        - pw_trylock:			local_trylock
> +        - pw_trylock_irqsave:		local_trylock_irqsave
> +        - pw_unlock:			local_unlock
> +        - pw_lock_local:		local_lock
> +        - pw_trylock_local:		local_trylock
> +        - pw_unlock_local:		local_unlock
> +        - pw_queue_on:         		queue_work_on
> +        - pw_flush:	            	flush_work

This will not render the way you expect it to.  You want a literal block
ere.  So end the text with "...is as follows::"  and indent the entire
literal block.

> +* CONFIG_PWLOCKS (and CONFIG_PWLOCKS_DEFAULT=y or pwlocks=on kernel boot parameter),
> +        - pw_lock:			spin_lock
> +        - pw_lock_irqsave:		spin_lock_irqsave
> +        - pw_trylock:			spin_trylock
> +        - pw_trylock_irqsave:		spin_trylock_irqsave
> +        - pw_unlock:			spin_unlock
> +        - pw_lock_local:		preempt_disable OR migrate_disable + spin_lock
> +        - pw_trylock_local:		preempt_disable OR migrate_disable + spin_trylock
> +        - pw_unlock_local:		preempt_enable OR migrate_enable + spin_unlock
> +        - pw_queue_on:         		executes work function on caller cpu
> +        - pw_flush:            		empty
> +
> +pw_get_cpu(work_struct), to be called from within per-cpu work function,
> +returns the target cpu.
> +
> +On the locking functions above, there are the local locking functions
> +(pw_lock_local, pw_trylock_local and pw_unlock_local) that must only

If you write functions like pw_lock_local(), you'll get automatic cross
links to the kerneldoc documentation ... which I'm sure must exist ...

> +be used to access per-CPU data from the CPU that owns that data,
> +and never remotely. They disable preemption/migration and don't require
> +a cpu parameter, making them a replacement for local_lock functions that
> +does not introduce overhead.
> +
> +These should only be used when accessing per-CPU data of the local CPU.
> +

[...]

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
> +#endif
> +
> +#define pw_lock_init(lock)							\
> +do {										\
> +	if (static_branch_maybe(CONFIG_PWLOCKS_DEFAULT, &pw_sl))		\
> +		spin_lock_init(lock.sl);					\
> +	else									\
> +		local_lock_init(lock.ll);					\
> +} while (0)

Sigh, I guess I was over-optimistic about kerneldoc comments.

Is there a reason why these aren't inline functions?

Thanks,

jon

