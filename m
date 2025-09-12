Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0359CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95398E001F; Fri, 12 Sep 2025 05:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EF08E0006; Fri, 12 Sep 2025 05:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97A28E001F; Fri, 12 Sep 2025 05:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B32FC8E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:33:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62D4C5AE15
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:33:59 +0000 (UTC)
X-FDA: 83880086598.27.EB3E331
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id D34F11C000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:33:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SBD4qWAA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NrKTC+6b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SBD4qWAA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NrKTC+6b;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIEvWluIt/3hHf2nY08Re+PsbA3Bh0WPIK+tjQ6kpQM=;
	b=w08NYV7wUbn3M2b7uCvLdVtuRPj6noortlEtozhI4waghEwdDhEE92FcruUcbiFtmgY93p
	74Zlg/H+sGnDsPTqS6/zcW395Zt1EjPHp11gBr8bDMc7vu4jRHgs2d2DRjmFZcuUTNkQQR
	4JR9VbSj1eu/PVveiayX5VskLoZd0bg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SBD4qWAA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NrKTC+6b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SBD4qWAA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NrKTC+6b;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669637; a=rsa-sha256;
	cv=none;
	b=RTXx1C/NDELsdY1V9QBheKyfVoS+jqldTmWYBz2yLadSkhc5+D/qwSngBH8Gym2iDoff2L
	Iib15PpXR3l6Os2+uMFHzOmwFgoSMyDxaxOSAnf79cFXUHj6VH3Zgngh5MTZ840d21cCV2
	VzNxNekTsKu9LTI2uSf4mBA2UEsPlRk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9EF5F5D411;
	Fri, 12 Sep 2025 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757669634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sIEvWluIt/3hHf2nY08Re+PsbA3Bh0WPIK+tjQ6kpQM=;
	b=SBD4qWAALkAcqt7V+v//nRfulWIPPr9LP0eaMhiE8t5WezghRIqIPYTZHwG7Cxzn4medcb
	21K+Is4WZYQk7ttHI6wPQO06czV/Of5JZqDlpLgf5uEv7s9JWc/mXwnveHRfiyiuDhZrCP
	v6WJq6hjrrbyG6T5eo0Pd6yAGRdaT4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757669634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sIEvWluIt/3hHf2nY08Re+PsbA3Bh0WPIK+tjQ6kpQM=;
	b=NrKTC+6bBvvCg9iz7DlnIjnkDKKIFG39a9AJWHUV/r1e0hhL14uiNhNoY0T211z88whl+2
	RoJtrrpA4uIDV0BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757669634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sIEvWluIt/3hHf2nY08Re+PsbA3Bh0WPIK+tjQ6kpQM=;
	b=SBD4qWAALkAcqt7V+v//nRfulWIPPr9LP0eaMhiE8t5WezghRIqIPYTZHwG7Cxzn4medcb
	21K+Is4WZYQk7ttHI6wPQO06czV/Of5JZqDlpLgf5uEv7s9JWc/mXwnveHRfiyiuDhZrCP
	v6WJq6hjrrbyG6T5eo0Pd6yAGRdaT4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757669634;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sIEvWluIt/3hHf2nY08Re+PsbA3Bh0WPIK+tjQ6kpQM=;
	b=NrKTC+6bBvvCg9iz7DlnIjnkDKKIFG39a9AJWHUV/r1e0hhL14uiNhNoY0T211z88whl+2
	RoJtrrpA4uIDV0BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79F02136DB;
	Fri, 12 Sep 2025 09:33:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9/p0HQLpw2juQgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 12 Sep 2025 09:33:54 +0000
Message-ID: <c4b4f741-72b8-42ad-87f8-a2fc6f758156@suse.cz>
Date: Fri, 12 Sep 2025 11:33:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab v5 0/6] slab: Re-entrant kmalloc_nolock()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org
Cc: harry.yoo@oracle.com, shakeel.butt@linux.dev, mhocko@suse.com,
 bigeasy@linutronix.de, andrii@kernel.org, memxor@gmail.com,
 akpm@linux-foundation.org, peterz@infradead.org, rostedt@goodmis.org,
 hannes@cmpxchg.org
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D34F11C000D
X-Stat-Signature: 8w8nioo8i8j88ju85gf8ke8nbujuii8j
X-HE-Tag: 1757669636-960454
X-HE-Meta: U2FsdGVkX1/loxdB/ZQQ8iIEIAxUDOHmrchetqrDudydGWh1iI5QoU2wRJtpPnfSZ5F6NcOMFVssWvzyjIDAKnrzndE/9skYaLwLt+CFvYAqhdxAZ8g8p+9A1V6rB06C/2DrIuaer9SxjU6Q8RlTUfwAv/b43RPE/n+L2nqK0lVgFI7Kz2cSQPnzwXZtWN8ZfN3kjVgkDvkEKJRqIptGhtgXX4DDKRqtX4fxJ78deIaEI0YaEyCLQKsZHtL6/U5pNi3Kq4qQ1+oeQTUF8MtlsFjGuWV7seiu1ILW4eJaU0CnnHwOc3oX2/Xzv95oViUGIwxD48iFAkv5zcANjPDw4e9j9VaiGJ/+1jqVlrh4iUsFaxm0TXKm+gn//4BB2zEZPm7hywqBIS00dz3oDejVFefZaLQ9bvLxLdBpe4H9HyXsWAUu/JYeWKWb4kRXjYuSKVI2LL0w+rA9wFcrU7+pVMrEzfW65+jmwkEU7nsCYN85J0JWGwl1pTq6dDPnD/1mApTY6tVYFdrVBVGmDp/rnckdLSLUP2Ek25VwhTcxlCTfx2yX1jRTB31jzdKYp5NV3QQ1vkyJzk0Nvl5my7s1veWIIq8fwYvR0Y0ovlhpfAdb1m+a8coFu/sk3jnEfjzPL8fEyRtcIqZyjmM1IbbT7xK86bfigdqoAibg4DqvsTS/EZNttuTfnglMPJtlLBVjRk1fmy3MDdWyKDxHinhcVchMURKQzKXPRQc4r8GDuyUGN9k7Z3aRyKpuH+e5CK9J+TKJz0T0fs0sv85mktnqmMDTiF+6p9sFYpO5uwTYXmd45pQrPf2GeSHFz6x09VSSGyufksQzo+z4CHbxRdBMcno5RYJ18zEogTcteBj9QVgUv3zQq8aNzqu+Ix164bO+Kz5/BKFlLm1hdJEWW+42VpeccpPDZi+lh+oUsVFGnpZV+jb2PATTda50vqcYzU91BwwxwgPyPr+ymUiZfJB
 AjZvczu8
 8wKgRxgs7q1JKIWduKKSWmPJEXz9w0VeEtuWv8gFn+BUeZcJD3cAuzJbNQLlOE4xU9Fx5Xs48PXimZvzJzpLRfh7g92G3PZCu/rTeJJNEN8Nr51xgi0s4Y/uOA3VZlkeJnjO+kLVGMEf9tZYFjksLum4XS5yb1vzDj8cbIIj0xjOb1RGx1PDKJzqfPili7G5CMb73/FLbhwAUCr9dopq4bxBobGFEoTQwI1XE8koZrTuIf1A9vAg9HgQWFMgoA8u3rSvJHWucyfQem0lotedppU5Hj+7FJL/rQ4RHe3RzI+OX2GG5YCWzl2b0uxP2SaoQifbXa257GWTb9STXv383IiXusPPZV/H0kJBSke5Mf0L8iOoKps7Bjg/cXTlfYqid3MEyGnwxkudEyt4C5qeMWv8Chi7YsQAXcj0ebTxyztp/ULqy5UlfmvOqTgv+O+8M4W/bM9kD13RDKIo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/25 03:00, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Overview:
> 
> This patch set introduces kmalloc_nolock() which is the next logical
> step towards any context allocation necessary to remove bpf_mem_alloc
> and get rid of preallocation requirement in BPF infrastructure.
> In production BPF maps grew to gigabytes in size. Preallocation wastes
> memory. Alloc from any context addresses this issue for BPF and
> other subsystems that are forced to preallocate too.
> This long task started with introduction of alloc_pages_nolock(),
> then memcg and objcg were converted to operate from any context
> including NMI, this set completes the task with kmalloc_nolock()
> that builds on top of alloc_pages_nolock() and memcg changes.
> After that BPF subsystem will gradually adopt it everywhere.
> 
> The patch set is on top of slab/for-next that already has
> pre-patch "locking/local_lock: Expose dep_map in local_trylock_t." applied.
> I think the patch set should be routed via vbabka/slab.git.

Thanks, added to slab/for-next. There were no conflicts with mm-unstable
when tried locally.

> v4->v5:
> - New patch "Reuse first bit for OBJEXTS_ALLOC_FAIL" to free up a bit
>   and use it to mark slabobj_ext vector allocated with kmalloc_nolock(),
>   so that freeing of the vector can be done with kfree_nolock()
> - Call kasan_slab_free() directly from kfree_nolock() instead of deferring to
>   do_slab_free() to avoid double poisoning
> - Addressed other minor issues spotted by Harry
> 
> v4:
> https://lore.kernel.org/all/20250718021646.73353-1-alexei.starovoitov@gmail.com/
> 
> v3->v4:
> - Converted local_lock_cpu_slab() to macro
> - Reordered patches 5 and 6
> - Emphasized that kfree_nolock() shouldn't be used on kmalloc()-ed objects
> - Addressed other comments and improved commit logs
> - Fixed build issues reported by bots
> 
> v3:
> https://lore.kernel.org/bpf/20250716022950.69330-1-alexei.starovoitov@gmail.com/
> 
> v2->v3:
> - Adopted Sebastian's local_lock_cpu_slab(), but dropped gfpflags
>   to avoid extra branch for performance reasons,
>   and added local_unlock_cpu_slab() for symmetry.
> - Dropped local_lock_lockdep_start/end() pair and switched to
>   per kmem_cache lockdep class on PREEMPT_RT to silence false positive
>   when the same cpu/task acquires two local_lock-s.
> - Refactorred defer_free per Sebastian's suggestion
> - Fixed slab leak when it needs to be deactivated via irq_work and llist
>   as Vlastimil proposed. Including defer_free_barrier().
> - Use kmem_cache->offset for llist_node pointer when linking objects
>   instead of zero offset, since whole object could be used for slabs
>   with ctors and other cases.
> - Fixed "cnt = 1; goto redo;" issue.
> - Fixed slab leak in alloc_single_from_new_slab().
> - Retested with slab_debug, RT, !RT, lockdep, kasan, slab_tiny
> - Added acks to patches 1-4 that should be good to go.
> 
> v2:
> https://lore.kernel.org/bpf/20250709015303.8107-1-alexei.starovoitov@gmail.com/
> 
> v1->v2:
> Added more comments for this non-trivial logic and addressed earlier comments.
> In particular:
> - Introduce alloc_frozen_pages_nolock() to avoid refcnt race
> - alloc_pages_nolock() defaults to GFP_COMP
> - Support SLUB_TINY
> - Added more variants to stress tester to discover that kfree_nolock() can
>   OOM, because deferred per-slab llist won't be serviced if kfree_nolock()
>   gets unlucky long enough. Scraped previous approach and switched to
>   global per-cpu llist with immediate irq_work_queue() to process all
>   object sizes.
> - Reentrant kmalloc cannot deactivate_slab(). In v1 the node hint was
>   downgraded to NUMA_NO_NODE before calling slab_alloc(). Realized it's not
>   good enough. There are odd cases that can trigger deactivate. Rewrote
>   this part.
> - Struggled with SLAB_NO_CMPXCHG. Thankfully Harry had a great suggestion:
>   https://lore.kernel.org/bpf/aFvfr1KiNrLofavW@hyeyoo/
>   which was adopted. So slab_debug works now.
> - In v1 I had to s/local_lock_irqsave/local_lock_irqsave_check/ in a bunch
>   of places in mm/slub.c to avoid lockdep false positives.
>   Came up with much cleaner approach to silence invalid lockdep reports
>   without sacrificing lockdep coverage. See local_lock_lockdep_start/end().
> 
> v1:
> https://lore.kernel.org/bpf/20250501032718.65476-1-alexei.starovoitov@gmail.com/
> 
> Alexei Starovoitov (6):
>   locking/local_lock: Introduce local_lock_is_locked().
>   mm: Allow GFP_ACCOUNT to be used in alloc_pages_nolock().
>   mm: Introduce alloc_frozen_pages_nolock()
>   slab: Make slub local_(try)lock more precise for LOCKDEP
>   slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
>   slab: Introduce kmalloc_nolock() and kfree_nolock().
> 
>  include/linux/gfp.h                 |   2 +-
>  include/linux/kasan.h               |  13 +-
>  include/linux/local_lock.h          |   2 +
>  include/linux/local_lock_internal.h |   7 +
>  include/linux/memcontrol.h          |  12 +-
>  include/linux/rtmutex.h             |  10 +
>  include/linux/slab.h                |   4 +
>  kernel/bpf/stream.c                 |   2 +-
>  kernel/bpf/syscall.c                |   2 +-
>  kernel/locking/rtmutex_common.h     |   9 -
>  mm/Kconfig                          |   1 +
>  mm/internal.h                       |   4 +
>  mm/kasan/common.c                   |   5 +-
>  mm/page_alloc.c                     |  55 ++--
>  mm/slab.h                           |   7 +
>  mm/slab_common.c                    |   3 +
>  mm/slub.c                           | 495 +++++++++++++++++++++++++---
>  17 files changed, 541 insertions(+), 92 deletions(-)
> 


