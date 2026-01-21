Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4A3D4694B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 15:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E660B6B0005; Wed, 21 Jan 2026 10:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26E06B0088; Wed, 21 Jan 2026 10:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFED46B0089; Wed, 21 Jan 2026 10:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA5706B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 10:29:04 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72D281A059C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:29:04 +0000 (UTC)
X-FDA: 84356354208.29.C53384A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf03.hostedemail.com (Postfix) with ESMTP id C18A22000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:29:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z5aFqPxz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DFf5AL/v";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CdzVuN4p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FGfQxnT9;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769009342; a=rsa-sha256;
	cv=none;
	b=WDKPLC35OP4FIqnQ87TnZkFvWugmrPFy/XhuGLyfHz/czYFJ97vUrlDCBKIdNP4Rn2TFdA
	1XPzbr7PLMGbcRZiFY6EyQVdK/cgTRebRJLK9PDXPu2znXnW4lBj+7U9kqxhy6NU9PgSj1
	0rpbdbP4hABDyNPTWY6Jqg5t8vUPucs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=z5aFqPxz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="DFf5AL/v";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CdzVuN4p;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FGfQxnT9;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769009342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I0FHLb4bjUo+evoPN2hthMQyW9LCjSkKGPRIsCF3IBc=;
	b=LsUlSAMXJI1U44lExBtGKkvFwJ6Nws0lfpQCLgK0LQvW6s6Qn/aPZPqPZ3s0WgJj+PV+Em
	vgdYTD5zbK54QOFlt8DhYehs0cPxmWK/RCuBcF9hyA9jZi5ZdJEyjy7YKbmwyBz0jhktar
	CuJUo5xd768bLg5gwHYLj5bU8bv2X64=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CD7E25BCF7;
	Wed, 21 Jan 2026 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769009340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I0FHLb4bjUo+evoPN2hthMQyW9LCjSkKGPRIsCF3IBc=;
	b=z5aFqPxzAaj95S8ao+AzdMTPAUrFYESstd4+p3nYryPIqdHZs/TvjZC/Yd7I1XbPr+pA1J
	SNu04sCosxLZeGgnodEnMkLY8cfacZD/UwD6cDjN2hjphnNl2XwJFkbWrNDkA8LRCfzfV6
	2X/EiMO6IJCqjrW+wC/0ahIdNrLnLZA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769009340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I0FHLb4bjUo+evoPN2hthMQyW9LCjSkKGPRIsCF3IBc=;
	b=DFf5AL/viTNbAMgnNoq0w/pnvSYn1XY6sOBMMjDT8kDfhcfyteKRj0451XwTjnZmx05/SW
	VOvzQLtUzNegG6BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769009339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I0FHLb4bjUo+evoPN2hthMQyW9LCjSkKGPRIsCF3IBc=;
	b=CdzVuN4pwFrknGJhvQziJTCODe5fPOupfJl5dcaF9P9nSuFP3eS8Z8c8OTu5b/GccLjjMh
	47ncdAFHth2OGFuMs+hR9gB+ymflWqesYYdx3orJy8boiO5vjh2YTi0OK/3brOR9+gf8tM
	HLLH1lQemS1hJe/1UxofKoleYD6BZxY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769009339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=I0FHLb4bjUo+evoPN2hthMQyW9LCjSkKGPRIsCF3IBc=;
	b=FGfQxnT9uAP+X0855GFJ9i+ScifHWvs6yLXYwTtMoS/odzElML0agMpvadBcD1dp2Egx8U
	CEF1PGz/fT/Ll4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5CA123EA63;
	Wed, 21 Jan 2026 15:28:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Cl1EFrjwcGm6JwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 21 Jan 2026 15:28:56 +0000
Message-ID: <ac7352d8-dc30-4ca2-a2b5-3470ba33e5e1@suse.cz>
Date: Wed, 21 Jan 2026 16:28:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: fix false lockdep warning in __kfree_rcu_sheaf()
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, akpm@linux-foundation.org
Cc: cl@gentwo.org, linux-mm@kvack.org, rientjes@google.com,
 surenb@google.com, hao.li@linux.dev, bigeasy@linutronix.de,
 clrkwllms@kernel.org, rostedt@goodmis.org, paulmck@kernel.org,
 urezki@gmail.com
References: <20260121131639.165960-1-harry.yoo@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260121131639.165960-1-harry.yoo@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C18A22000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 9fgjhcp6kb6457g8d8u3wx3f1wfc68yk
X-HE-Tag: 1769009341-231379
X-HE-Meta: U2FsdGVkX18Tjh5MJtF/ieBxAQaaHGR2BPKVYgluHX1mdWkSOtrUfMhBv+76StSBvkLLrOAnRKUMq6ei3aETe4PaVP1KUF6zMLLpYu4beKD7uU1CNdQqUXPe0mKMddQDeFchP/XeeFtTbojI4U+1bQvzMehZu8RNel09O5DZKOWNircFw6TBGMvOY4YEg0bVQdj367UJ/Jr3jR0dcwtSevs7JdYAkLf+8InIUCyUI+/dH7a4FtHvEtzqmfV7QhRRbvOXgVXfnseD80qPst/P/QYAQU1CqPfAXv5c9Pkt01vfnHKe4F73xkIxVMiGDWBLfeGgs3DrwkzhzOu1mUt9DiEs0QAQleN80mMclR0TJ5XRD+EamIaF1wjc5mKUNgZ8PuCLfvUmrxXvNkzg5snCvjukcDbgFFJb/FbYfWhbOFbKB40iKm/bnjeiQMeQ8ntAUIhljm+FXLrIvcVdCLzYANK4fy3mnQA3+rPb4PyXyYXzFYZSHeWkdB9khhVwYfdb5j39tzwgQpTJ0CoQ/M5r2N70fVUZXUw31GOeoFnvyGqz1bOeXUejcL9TW/glXCfd3sG6WW/YCAWal2phQzw/gArjO+14tC3lmivRhEs3FwCuQbsvlicosAbRo8+2bC33POTM1EVEv+mDasf82am13oWgYzEHTrP3XsGQQzRsVk8sAH3+Zrx0buK1TDv9N5le5zMZbjaNJfh2sjgclBRvncksMlJQ5diOcpVJFGtZGSNUPzDqsO43sYeTKxbWBYsusYu6ca41pywCWbalpg3UeMz2/1wEHNLHCv0TMNbm9IINWlx2lAhSRfXx9hmj9Sp8gaayMnxdxPGsEvYSCDTv4AJ9gIApe51o8CTstapbSF7E1hf9bD00Qbbm5t5+6CHMtYw+wQfYbLBk7n9NOBOW33T0NW82/pNFl8Zb7qCsktzIc42jF5nNrs8HbVwh17EczHPXTEhLnBXKOI2LZHq
 o0Wtu8pg
 UX4EWPAGXuAJvZ2TR7SrDzzqQrpIKKRQFg0jqeZ8WuMLdmz4ksq0dcCt7B7vnJbwJrKmDilB1jxtUlhtobO6oS+1s2YtMxmoBm7OSDUkQQPGWqqCdoa/q3mW2l99WtfJ+xCdqgcMZJSZwZoZhi9OnqL7n638wz+WFSqVogS7GUP402DLDH+wGQZsxWws8oLCYpBNePQuAWm+DUtaWApOI3Q5lPgy1mNPIJ9oxASv3lvcLM81AoBL2tZrUx0cxJd1iePRvNzUeh/gWdN61s14buDIhJsPFNkcdhP7TsFti4GmkcuFZs3q0TdjobBhsIrBkXKzcrDN71cIwWAJt0sBKfeghF/NHMZT4eBHROcr476tXr3ZZ3i6uqUk4EeVoL9jUEfPfFdGG0ZLfvVjzgSaQmaZrL/zQrNmuZBAT8WvxsKHLe9tHsTdsT8GE+FsEsqsbJ8nT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/21/26 14:16, Harry Yoo wrote:
> kvfree_call_rcu() can be called while holding a raw_spinlock_t.
> Since __kfree_rcu_sheaf() may acquire a spinlock_t (which becomes a
> sleeping lock on PREEMPT_RT) and violate lock nesting rules,
> kvfree_call_rcu() bypasses the sheaves layer entirely on PREEMPT_RT.
> 
> However, lockdep still complains about acquiring spinlock_t while holding
> raw_spinlock_t, even on !PREEMPT_RT where spinlock_t is a spinning lock.
> This causes a false lockdep warning [1]:
> 
>  =============================
>  [ BUG: Invalid wait context ]
>  6.19.0-rc6-next-20260120 #21508 Not tainted
>  -----------------------------
>  migration/1/23 is trying to lock:
>  ffff8afd01054e98 (&barn->lock){..-.}-{3:3}, at: barn_get_empty_sheaf+0x1d/0xb0
>  other info that might help us debug this:
>  context-{5:5}
>  3 locks held by migration/1/23:
>   #0: ffff8afd01fd89a8 (&p->pi_lock){-.-.}-{2:2}, at: __balance_push_cpu_stop+0x3f/0x200
>   #1: ffffffff9f15c5c8 (rcu_read_lock){....}-{1:3}, at: cpuset_cpus_allowed_fallback+0x27/0x250
>   #2: ffff8afd1f470be0 ((local_lock_t *)&pcs->lock){+.+.}-{3:3}, at: __kfree_rcu_sheaf+0x52/0x3d0
>  stack backtrace:
>  CPU: 1 UID: 0 PID: 23 Comm: migration/1 Not tainted 6.19.0-rc6-next-20260120 #21508 PREEMPTLAZY
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-0-g155821a1990b-prebuilt.qemu.org 04/01/2014
>  Stopper: __balance_push_cpu_stop+0x0/0x200 <- balance_push+0x118/0x170
>  Call Trace:
>   <TASK>
>   __dump_stack+0x22/0x30
>   dump_stack_lvl+0x60/0x80
>   dump_stack+0x19/0x24
>   __lock_acquire+0xd3a/0x28e0
>   ? __lock_acquire+0x5a9/0x28e0
>   ? __lock_acquire+0x5a9/0x28e0
>   ? barn_get_empty_sheaf+0x1d/0xb0
>   lock_acquire+0xc3/0x270
>   ? barn_get_empty_sheaf+0x1d/0xb0
>   ? __kfree_rcu_sheaf+0x52/0x3d0
>   _raw_spin_lock_irqsave+0x47/0x70
>   ? barn_get_empty_sheaf+0x1d/0xb0
>   barn_get_empty_sheaf+0x1d/0xb0
>   ? __kfree_rcu_sheaf+0x52/0x3d0
>   __kfree_rcu_sheaf+0x19f/0x3d0
>   kvfree_call_rcu+0xaf/0x390
>   set_cpus_allowed_force+0xc8/0xf0
>   [...]
>   </TASK>
> 
> This wasn't triggered until sheaves were enabled for all slab caches,
> since kfree_rcu() wasn't being called with a raw spinlock held for
> caches with sheaves (vma, maple node).
> 
> As suggested by Vlastimil Babka, fix this by using a lockdep map with
> LD_WAIT_CONFIG wait type to tell lockdep that acquiring spinlock_t is valid
> in this case, as those spinlocks won't be used on PREEMPT_RT.
> 
> Note that kfree_rcu_sheaf_map should be acquired using _try() variant,
> otherwise the acquisition of the lockdep map itself will trigger an invalid
> wait context warning.
> 
> Reported-by: Paul E. McKenney <paulmck@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/c858b9af-2510-448b-9ab3-058f7b80dd42@paulmck-laptop [1]
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Thanks a lot! Will add to the sheaves-for-all series.


