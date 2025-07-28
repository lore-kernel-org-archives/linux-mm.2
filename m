Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA70C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 22:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE526B0092; Mon, 28 Jul 2025 18:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AEE16B0093; Mon, 28 Jul 2025 18:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79DF06B0095; Mon, 28 Jul 2025 18:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B64F6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:04:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC462113926
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:04:05 +0000 (UTC)
X-FDA: 83715052050.22.70D7031
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 84FE31C000B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 22:04:03 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aur0estc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3Tiu0ZvI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qyOrdqqo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qWIj9I4Y;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753740243; a=rsa-sha256;
	cv=none;
	b=BLtyklp3aVfPB9RmgmeNiKgK8/LyjYf5m2HhJou7++f5C0mBYdydt/ptLqMWKsfcn3uP/P
	PAFGbUr7SbSeYV9OuHcxIS2VYBBR6i+F4B4ORttTQjkg53a7Ir6UqW+pmw5XVDJMJN1eDL
	jyTMOg1Zb9nKqr6WnrYQ385Wrvt6szI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aur0estc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3Tiu0ZvI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qyOrdqqo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qWIj9I4Y;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753740243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYm0JPVCG7igVviYXogX2AnfcYTqQGXtreYnHNGaiYA=;
	b=7q2HS6Y6Gce6q8kK/NwJeoKKf2RQ/wQh7S4TqxZsvti6K5yfpSF+EB8GoPAJTO2I1KFwgT
	8UKI06w7QDdRn/TytGKYz3AGqT9jog5Hs8/BXzrN/yuOVesliOepHpkDr76S/XQ9+Zn0ZC
	jIRKBZconQ7QVAcYE19X7EJJdXznw2A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D75711F822;
	Mon, 28 Jul 2025 22:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753740242; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qYm0JPVCG7igVviYXogX2AnfcYTqQGXtreYnHNGaiYA=;
	b=aur0estcgdnrBALgMxmxijj27iCZLwmJoSoGi2vd7G4xE/PdIfXVJOJNUXA/aFu1KAeGTa
	NcZwTGUSrBCesVIzmhfcG6p6pCnXxhv6wPl+ijuMzTGv2UGGmXn6UMLIhPxnBipnXd/wwe
	erJQiQBTmAPQuz9dZPkpi4ZraBaTZ7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753740242;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qYm0JPVCG7igVviYXogX2AnfcYTqQGXtreYnHNGaiYA=;
	b=3Tiu0ZvIMQAzLwCy21XMLFBlg9ALEq/YNQxipeyHrhVzJBe6sLuG1faBvQPMhjNNj3TuOs
	QA+gW2UDjswip/CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753740241; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qYm0JPVCG7igVviYXogX2AnfcYTqQGXtreYnHNGaiYA=;
	b=qyOrdqqowJAThJX2NDdNFui2ptqkmDkFU4UrKt4e7FMwR7ubvOurmqSOvd3/mh0yULfig6
	QiQpEOvWP9I1QgzvGg65mARvh8sIJb3T2I14IeZEktTRI6SWDrajFYPqJyJrOybnTJQXHf
	CGrVbiUHYQReBaUa5LEwXs10VsKDaYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753740241;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qYm0JPVCG7igVviYXogX2AnfcYTqQGXtreYnHNGaiYA=;
	b=qWIj9I4YE+su3SW1nHZk2iViWsrxlm9F8HhrS0Z/NZrn4dREb5zOBDjSwz7ysrky1kPLYa
	Q+R/J6ForZjFWyDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDD951368A;
	Mon, 28 Jul 2025 22:04:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5+ffLdHzh2h0FAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 22:04:01 +0000
Message-ID: <197389ce-9f42-4d6a-91c4-fce116e988b4@suse.cz>
Date: Tue, 29 Jul 2025 00:04:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: jannh@google.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20250728175355.2282375-1-surenb@google.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250728175355.2282375-1-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84FE31C000B
X-Stat-Signature: so8rerj757tc98rbp939cbzhdhtkm6ur
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753740243-204069
X-HE-Meta: U2FsdGVkX191yqTe5YL3lq18h2uhkII29rGU27VlWcPe3PcS9VU+gYugftEYFJOFnBoF0uPLg4BW9L/TJbrqnMDdA/g+pu99i6OKxH0FRjcIp/gwtZ3M6Pf+BMFAPo4Rx600D/sjJlD+3XulD12WG7O2LCpXSyTb2Zx8a0RnQrD2sDEw7kps1KPp38TKs5pl8lxHNme/ebAgTTzksWsIfhSPi8DaykC801zb8glf5IHVgGHBnLch3iExYhCnQkd5eD4j/AeJHEXsQ9lVn4fFZTLST70fo+KTBNGElRApZy1PyrlLgrJxeX+ScV8KgzZlc78+C357+MldCZYFH/MQxc0CdI4OTnM0Xz9V9dyK8qYNseaKk7b/5QkD8y7hcHAcOc+kY2qfL8ox5idVyZqTjtSwqAUCRtjsRQKJqMKUZsGqtvQrR87AjY5KJoRK159Xqywq0uBQ1ZQjbI/qjGhUcmQs808W57kbOPP4qeHDBFLlWgQwPMaajwVwJMzYOwCuKf2njAnsbLD3h5TzopudIYI/A180JzK99tQM0CUEUDWa1WvBYq4rpVXG5Qms5v0Nu6NFjrnq5uJulnSlw6b6NL5w5f8Fh/EabUD+mnkmeQnEvqfIGjwuV/iSJs5i+TX4DJcdVf4bsLtue5nH5AdKXx1YRgShjKYa8AnqofBAZDOTq3Uh1CXSyi6gMc5Ya4p7cIDstNfDNSI/WkfP+3dTCnHKSLN8ZJa51C7lGBAv+bgHxQUYvuvvKcftJDWnZlsl1Jang7il5/5iKX9dpF+GmfiEerTlfo/MSu95n8syWUs1V9pyS04ruUYaqYThHFx3r4VzXmBJ/6ySmNKXVtoMedeJ2XUEQhz4Pjh6Kd9o+xOYsLBrd6zI4GyRdeldubVtQZZ2wkj/4NHc58s68Hr/ir/ZutYa6ljELhraYtKu7YcdJW6no/Pu+7BTEnl/TQroxjmHuOgRcDQnrDqkl6r
 1Q2b0Pgs
 9UNI/Jl3/rCmnGiOaFFdxL0O9upE1MmJ5ohlMAeCTaN6pP5IZ65KaucViEewwlZeO6DwUXsRXweLn3oIh42fSsWczQ0OiGm3rdIJneYLF6DvuBIQQUl6FXYX4mnykK8g9Xa6ejd0XXIzcWhDYs1mLS72kI0RKvHhZBrp0UDUSSi52tAIx39M2LxjwWiZb/slA4esK0EEibV9uj/bygpDMrOfey9EYsyicXwX4YbNFVrZpFMCJIGHOYDBn4N3x0DiEUvbzK7xs02mFlxH7Cnm9WQeEVH5QxPPPus/ZswiKSJR7M1rThMN/ioyUlnBhxki3hToPvDrq+dMGDeB+Nr68uarVYkw1d7ymX8gkbc0MIsAi/qm7vj/wCcSIf455j49p5W+zFiDwUa1mHZl+kJN9MJcIjSCkU7s7P1ohVNRx0jFhYZFuccX/n4s9qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/25 19:53, Suren Baghdasaryan wrote:
> By inducing delays in the right places, Jann Horn created a reproducer
> for a hard to hit UAF issue that became possible after VMAs were allowed
> to be recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.
> 
> Race description is borrowed from Jann's discovery report:
> lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
> rcu_read_lock(). At that point, the VMA may be concurrently freed, and
> it can be recycled by another process. vma_start_read() then
> increments the vma->vm_refcnt (if it is in an acceptable range), and
> if this succeeds, vma_start_read() can return a recycled VMA.
> 
> In this scenario where the VMA has been recycled, lock_vma_under_rcu()
> will then detect the mismatching ->vm_mm pointer and drop the VMA
> through vma_end_read(), which calls vma_refcount_put().
> vma_refcount_put() drops the refcount and then calls rcuwait_wake_up()
> using a copy of vma->vm_mm. This is wrong: It implicitly assumes that
> the caller is keeping the VMA's mm alive, but in this scenario the caller
> has no relation to the VMA's mm, so the rcuwait_wake_up() can cause UAF.
> 
> The diagram depicting the race:
> T1         T2         T3
> ==         ==         ==
> lock_vma_under_rcu
>   mas_walk
>           <VMA gets removed from mm>
>                       mmap
>                         <the same VMA is reallocated>
>   vma_start_read
>     __refcount_inc_not_zero_limited_acquire
>                       munmap
>                         __vma_enter_locked
>                           refcount_add_not_zero
>   vma_end_read
>     vma_refcount_put
>       __refcount_dec_and_test
>                           rcuwait_wait_event
>                             <finish operation>
>       rcuwait_wake_up [UAF]
> 
> Note that rcuwait_wait_event() in T3 does not block because refcount
> was already dropped by T1. At this point T3 can exit and free the mm
> causing UAF in T1.
> To avoid this we move vma->vm_mm verification into vma_start_read() and
> grab vma->vm_mm to stabilize it before vma_refcount_put() operation.
> 
> Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
> Reported-by: Jann Horn <jannh@google.com>
> Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: <stable@vger.kernel.org>

As for further steps, considered replying to [1] but maybe it's better here.

As for a KISS fix including stable, great. Seems a nice improvement to
actually handle "vma->vm_mm != mm" in vma_start_read() like this - good idea!

Less great is that there's now a subtle assumption that some (but not all!)
cases where vma_start_read() returns NULL imply that we dropped the rcu
lock. And it doesn't matter as the callers abort or fallback to mmap sem
anyway in that case. Hopefully we can improve that a bit.

The idea of moving rcu lock and mas walk inside vma_start_read() is indeed
busted with lock_next_vma(). The iterator difference could be perhaps solved
by having lock_vma_under_rcu() set up its own one (instead of MA_STATE) in a
way that vma_next() would do the right thing for it. However there would
still be the difference that lock_next_vma() expects we are already under
rcu lock, and lock_vma_under_rcu() doesn't.

So what we can perhaps do instead is move vma_start_read() to mm/mmap_lock.c
(no other users so why expose it in a header for potential misuse). And then
indeed just make it drop rcu lock completely (and not reacquire) any time
it's returning NULL, document that and adjust callers to that. I think it's
less subtle than dropping and reacquring, and should simplify the error
handling in the callers a bit.

[1]
https://lore.kernel.org/all/CAJuCfpEMhGe_eZuFm__4CDstM9%3DOG2kTUTziNL-f%3DM3BYQor2A@mail.gmail.com/

> ---
> Changes since v1 [1]
> - Made a copy of vma->mm before using it in vma_start_read(),
> per Vlastimil Babka
> 
> Notes:
> - Applies cleanly over mm-unstable.
> - Should be applied to 6.15 and 6.16 but these branches do not
> have lock_next_vma() function, so the change in lock_next_vma() should be
> skipped when applying to those branches.
> 
> [1] https://lore.kernel.org/all/20250728170950.2216966-1-surenb@google.com/
> 
>  include/linux/mmap_lock.h | 23 +++++++++++++++++++++++
>  mm/mmap_lock.c            | 10 +++-------
>  2 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 1f4f44951abe..da34afa2f8ef 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwait *w);
>  #include <linux/tracepoint-defs.h>
>  #include <linux/types.h>
>  #include <linux/cleanup.h>
> +#include <linux/sched/mm.h>
>  
>  #define MMAP_LOCK_INITIALIZER(name) \
>  	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
> @@ -183,6 +184,28 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  	}
>  
>  	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +
> +	/*
> +	 * If vma got attached to another mm from under us, that mm is not
> +	 * stable and can be freed in the narrow window after vma->vm_refcnt
> +	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
> +	 * releasing vma->vm_refcnt.
> +	 */
> +	if (unlikely(vma->vm_mm != mm)) {
> +		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> +		struct mm_struct *other_mm = vma->vm_mm;
> +		/*
> +		 * __mmdrop() is a heavy operation and we don't need RCU
> +		 * protection here. Release RCU lock during these operations.
> +		 */
> +		rcu_read_unlock();
> +		mmgrab(other_mm);
> +		vma_refcount_put(vma);
> +		mmdrop(other_mm);
> +		rcu_read_lock();
> +		return NULL;
> +	}
> +
>  	/*
>  	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
>  	 * False unlocked result is impossible because we modify and check
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 729fb7d0dd59..aa3bc42ecde0 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -164,8 +164,7 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  	 */
>  
>  	/* Check if the vma we locked is the right one. */
> -	if (unlikely(vma->vm_mm != mm ||
> -		     address < vma->vm_start || address >= vma->vm_end))
> +	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
>  		goto inval_end_read;
>  
>  	rcu_read_unlock();
> @@ -236,11 +235,8 @@ struct vm_area_struct *lock_next_vma(struct mm_struct *mm,
>  		goto fallback;
>  	}
>  
> -	/*
> -	 * Verify the vma we locked belongs to the same address space and it's
> -	 * not behind of the last search position.
> -	 */
> -	if (unlikely(vma->vm_mm != mm || from_addr >= vma->vm_end))
> +	/* Verify the vma is not behind of the last search position. */
> +	if (unlikely(from_addr >= vma->vm_end))
>  		goto fallback_unlock;
>  
>  	/*
> 
> base-commit: c617a4dd7102e691fa0fb2bc4f6b369e37d7f509


