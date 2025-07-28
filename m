Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE7E3C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 21:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924B46B008C; Mon, 28 Jul 2025 17:42:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC6F6B0093; Mon, 28 Jul 2025 17:42:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB7C6B0095; Mon, 28 Jul 2025 17:42:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4E36B008C
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:42:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1921D1403EC
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:42:53 +0000 (UTC)
X-FDA: 83714998626.24.7999E42
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 93690100002
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 21:42:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKp8n9Lu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IcXzhZDj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O42lQOT5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c8b42eqb;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753738971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kYLrjhTCwgiO/q5O0ScJ+Y3bmPYFFc08jN4aiaBZLs=;
	b=IBNEqdkVIFP6rIVtCjTrvkewHtqesbi5IwLk2m52FztuOb6avLj/gEb8COhYIwPuJ7gP7s
	021mN2yZr7Ki2mJsOphGzLzzNVOihGMl5GVVyuDXR3GSrOXBDc+KPGsrKSy4q8lNpZDilc
	/v5SGjLN60fqOryTAbuwqYhEcGvkDa4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753738971; a=rsa-sha256;
	cv=none;
	b=JuMJAIKX3kaNZ2kU6flSejNwDwwrR2kdC7GMhNHKBNfs0Zw1W7P2e5/MeBPPAm5alvxyTC
	FijlPYxnc3oYmvq28wYZwmLZFqtrKALT+hQOdvMMZw7AquPiyXz8GXhiaYVAszAoGCYtpS
	bw8UXt/W97FRrmGg8lVsfWAtEVS1hOE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yKp8n9Lu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IcXzhZDj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=O42lQOT5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c8b42eqb;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A390A21289;
	Mon, 28 Jul 2025 21:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753738969; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6kYLrjhTCwgiO/q5O0ScJ+Y3bmPYFFc08jN4aiaBZLs=;
	b=yKp8n9Lu65/pFksaSm0Cx5OX9tRIbQshueFX/jBmJnWOnJz1KOQ6dA3jE60KWsxiPrrraL
	NPKnEXkx164CnsgVF+kvYiTazEu7XGe1MGT8v6n2PrKSTE4gAwHJFnD2AYTnRN/qVv14do
	dyMR2UHQGl8Qwa15SYZZlaMkYDCKM0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753738969;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6kYLrjhTCwgiO/q5O0ScJ+Y3bmPYFFc08jN4aiaBZLs=;
	b=IcXzhZDjDjR6g6ERlgdlz8yyDsvYYF9adQm2odt44Pb09nOIDG6sX5WPcTvaeiK/jZmn9l
	WyuDQZIIFdr06NCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753738967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6kYLrjhTCwgiO/q5O0ScJ+Y3bmPYFFc08jN4aiaBZLs=;
	b=O42lQOT5z03gbYYF/pi0808TLVL+MGfIctZ21WDWl/zots9kHSl1ZQ+NSoBf5c2gTNDa8o
	acpyEDJvep9KDGl5AgG58nekVnoHoKrwaEnBY/eTBTYV+2JQvF56VNXV0lXN1SVZe5A39s
	wqS8RHJmOiJ9dWldp6FO/KomvMhuw0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753738967;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6kYLrjhTCwgiO/q5O0ScJ+Y3bmPYFFc08jN4aiaBZLs=;
	b=c8b42eqb36caReC8Qza4Fx22d8mdh6OPCg53YYswZ1aidvfB5VYbDifalXaLEAKeZL4BgE
	/8E4S7bsrJo678Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8CFFF1368A;
	Mon, 28 Jul 2025 21:42:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sWUNItfuh2gKDwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 28 Jul 2025 21:42:47 +0000
Message-ID: <39fbeb2c-ef42-4898-b0f8-9340a6e9988e@suse.cz>
Date: Mon, 28 Jul 2025 23:42:47 +0200
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93690100002
X-Stat-Signature: 11owjn9uuoo9tdi8b537eus6cujw5e3h
X-Rspam-User: 
X-HE-Tag: 1753738970-159309
X-HE-Meta: U2FsdGVkX1/7IRjj4K5tTI329ynRqx8/eHQ/r9aR0c2JHKCFTzk6hfQnn0kY++jYNqaP49DBslHQ52TUDqK/DvgLrx3gE5hF+aL0pA5Tiq1AJoGlWcxUaKnutQL4oSkTphx0GWNdNby/mPWH2KktkQN31AgKUfCGNMPQdBa0bjcnsd5RKTFR+1SbzMKjyzAnI3rbcs1oehjnABIPt+30VoxoxhYqPEQs9DtGitoxS1aWdVZplSpWqFuCMzjGmC21fsDFJeIA+0Kp3guWnksxhJIx5fBbuc5OAcD9Rd3XSigF+cKpWKx+dm/I24Dw+ubmHB8ZwbPiTis/5uOxDdCUEpyBQQlD+b4q9ldejPiwTVU7BII08NXS0fL9rNhLYJY3M/0GSyhFumqQt17L4Lyr0d318mzTg5NCmqMi26KrxMTd/U5o0EAqDF8ex0rdA/tGNBLvbQjZ0LKUzbdkGjH4+X9ZeaPowPQIAHG3JJssJHzqWBqbsw3Ha7p2zuGyfFnYOg/Zh5/u1IslLIqZTEan3IjDvh2o/7pe1/bXoYXgmNgsR1tSobCIVXNHpBte+GaA0wB1bfjOLQGuaqYEr/zY2/uspAqsW+t0l8ZR5g0OlMAtIc1+cmU+Al+o06UMa2ynj9M2l/rSojx54gXcxar43c7HT+aHeqWANpJyX3PlYPho+6CoFHDBcyMsEqtx6syx0eBgxjc2b4BSkh8wh3lDzeiOnZYinrLO1lZHS0d/d2JQJGsCBUXhT10I/hP1pbfOiHRoGmmxnVR4p6jdSfueUMCLKMyfcqF1SMe5BBf7qqprHbCQEpNm95eBYzSArpr1cTbacdcIAZw5rVH7RYfSfTYVdgEU9nmEBx/MIyU64GYDjhvMnB/mS8mVKvw3gS6wXiqmr1rx12C40sP2D+m7aW221uHkMF0b+YRi4QK/IjHTsql9e5DHgt/wsVE9CMf6gXVHy7Bl9fY2tSf5RLZ
 aAKGCPPl
 ql4a2WDCd3rNyxrMRuEFZFc2uK52GYf31wTgHmaPOyFSO7DarvJQV/5WEjYjOTNcz4ONcciV0ngGAJINYu7/38xDdZhMTsecd1qyabVlEDlnaZfjjk7334egp0UISrwKRbvBTHwpLqLtMwJ089ixMuNhVE29j5D+4wcl0xxCKVdo22CZObD7KfdS8tvsQAIvceFPM+3Ijc1awuGJyn0R0mgyfOrWGQ4W2l3plen1T5rrizOPvbDKLFrTScOmPiJCEgeM1jHnbu58OXpG8liW5X5l3Iplczg8FasCyOvlk2AgyZCEOP/KsLjabILOQxzgvQTR+y18tjmI9iNzA+qPeYgacFp7b81a8wVVYhTnIPVXYovjrCElOMqr75m9dWU8cLZJsCxmgp4GXHX+Qv3hseeNIKjz0YsVfHYrOFv4tNZeJPA9YVSYqujezKQ==
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

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

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


