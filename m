Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB171D72353
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C98E6B045C; Fri, 23 Jan 2026 03:48:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A8D6B045E; Fri, 23 Jan 2026 03:48:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438F06B045F; Fri, 23 Jan 2026 03:48:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30D516B045C
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:48:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF13614017E
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:48:32 +0000 (UTC)
X-FDA: 84362602464.01.A1A8332
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7639C20006
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:48:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y36rdCWE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJBlGkpA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BJOv0lsi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oBputGBP;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qEh0kdQ3RnJonUDaVBHzBDZl/b1uLfRxPAVFaAKaIaw=;
	b=0HeewG/QFhqXJ2oJf0hqfhrzYVqOMdX1MbeoR8XTtNQzgYKGDlt9lEPBuc6d16mjxhSt+2
	DnI45ZzlJMY6m6WofkGQI3LI2jX1Os5sOmrET86ntWmfGAmCYucWldykxObygViyqHV+vR
	ULuwv41fqu+hvffhBNJbAuyOYZoJhXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=y36rdCWE;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gJBlGkpA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BJOv0lsi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oBputGBP;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158110; a=rsa-sha256;
	cv=none;
	b=cVPU41P2s8xaok5PzoGcbsHK4UGQpic8B3giDxyulGF5gbz5wrqln6kvk+koqyae6Na/lU
	Gg0sq9+9FJIUPYNcfGti8rEd1wTQVWU1/HyzKbYcqhPNuPLVj+L7GLCjJ9Xzlh68ZcQLpb
	6l4ugXw0Pyrt76z0to98BGmA/4rVmKU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E416A5BCCE;
	Fri, 23 Jan 2026 08:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769158109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qEh0kdQ3RnJonUDaVBHzBDZl/b1uLfRxPAVFaAKaIaw=;
	b=y36rdCWEuJr4EJKki8VvqeTgiMAfJ6y+Kxs/RYod3kCK61jv8oEnXo1cn60thsZ4HmPm1e
	4lKxMnSmciwYmnGl2Ys1UGIHALxaCd7iwT2TgFpkDpOqEoaXNM7k6/FwzVHnpc1bbKkcgD
	dY4S2NmOO8C1I1K3tAVtQxYa0Mhi6eQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769158109;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qEh0kdQ3RnJonUDaVBHzBDZl/b1uLfRxPAVFaAKaIaw=;
	b=gJBlGkpAoZ5wYwOtU9ZtHy4XIYizb0RxMTE2suB/ymtJ9j1FJF0ObTyv1jClxzAqkQaLQ8
	ta7NSVntkVBV3HDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769158108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qEh0kdQ3RnJonUDaVBHzBDZl/b1uLfRxPAVFaAKaIaw=;
	b=BJOv0lsiDqbRa2cFYIYFD8z2hc1yCu7dL10yxEKVRWwjhCmutfWvdEMHwADfIYaJDW4otm
	V0vU7zdkVhcshilGfue+EDs7uFB7ygrr7digQn5wFG+QSEmz6ZWw0lYlieFiQWk7pyR1rY
	sx2Lek6eIBTenSjaKaxvDzX0ig+Z5O8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769158108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qEh0kdQ3RnJonUDaVBHzBDZl/b1uLfRxPAVFaAKaIaw=;
	b=oBputGBPHAFrCsSJRBjyN/X01ve86zrVyuLLyiMiH+woj2antMUUVFZr1sfrwVpxsSk8WD
	pWONmoMvOy67ArDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B80711395E;
	Fri, 23 Jan 2026 08:48:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pn6ULNw1c2lNUAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 08:48:28 +0000
Message-ID: <763b5f50-2367-4a56-9410-5636458ca2dc@suse.cz>
Date: Fri, 23 Jan 2026 09:48:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4brma4kb63txp3mx4inm9eec8t81393r
X-Rspamd-Queue-Id: 7639C20006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769158110-866617
X-HE-Meta: U2FsdGVkX18qi/15wEmgnO3m4Okr9Qaskw8FuzqnuywYg5C6+os3/YlD6cjAZDwzO/LaIKuERTQdkryBJZ1Qh/8E+/YWDaVMuTTtqxIxnhNNau3sCvoaJXRKsVZbQju6TkoHTa41nUEXr/pwxC00E4nZmYttnpMFanqHQqhe7SyKgEg1VGgQ0YHmMvq46fIeSslr6VRzTBDKQ51taE4TxICqfQ4NQMzkZaDK0C4KNi/aW/RbrJp+mK8kxKWT5fXcNk722nVlZSMKNQly1SGWHiL4oBSUKHuAiDZUzG5lhbJVFf+Wtn8Gp9viwUbcERx03mSgfhaBDyO54K6llsjhPMOIFPEuZpvqcE1IS8fZ0se2mNFmmW81UWWJwgMWnuq5hBABROf2fH2eg/YCu/u8IJcbTNDoZkBaXcSR585ibnT56QFJUNBObQv3PwjB7e3zXfqrKxiq3DQJZxphgxwh5QjnlIZOxwxYvUuaalTurY/naUFFnylSug1fecEIEkFcyxQq7Mp6jg/wiIgUMWbYPUQN/Q6bOHoyMGwlYCBXn1tH54r5hcQ2g0a81j6MG3L8J/8+j0Z4rNba0kspiwiiwlZIYGQTX1nq8v05qekcr66yN/iPDvBQwyX9cgXFlYfXLAjVbypF1O3E03//b0pUU/Mlqr+8jE6pcasq9YyN0+idok4DnCjcRaF9rjmEZxjD5bxrw9vQCTHaNUAJHuR1wAdacVv3FbFyU1WpUO83a3xk59jG6fbTtPxp5hd3gRUqDS0pGbKi2bSRbLu8Y/38EfkpsjZJlXbPNxaebVCiC7q/Jy8QEAJwLWef8z2KvvkbPZ9/5A3WZNfvbE+/r1hxZWjx3COZjAyfjDuxowmotyq8yEUvGtadwOA7+6ihrWVQLKhRqfBfcC2pelk+tKUN4oEDa/ZD0sOVdfAkdgUtTtgNrAGJFloaYXG5BJkOUMghvcbFcg1mTSHJKXNGk/H
 WjUJEiaM
 vs1PGThZS6mDEowDlj6nz625Q4ayoFDoTWP8xQxtE0xtPQrKzyKABLMxF9zQCM2an3jHIq3zfuJxgfRiul4ve0TScrzr9QbttRaouIgCXqx4bpSFVWBQCe8uLUKdzuERReounRjtd4ZN300wIl3UrUIDwK2QxXqMxQ8xV6uv7fyHaQEWBWAGYS6VbjaTPxYcWSpNIiNKwjF/Jy7dTcvffmBe+D8FkbIPh8S4Wy60V7AWTHlz6ylIq+45N0+X7eUNLbOPqnaMxDwlrVgNMNn3qGhUD8zBleZstbyr5RBnRlqW+/UWDIYWCF0OGGI7X+6xIbP6niXulf9wfFHxhhkmzSVjdBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:01, Lorenzo Stoakes wrote:
> The code is littered with inscrutable and duplicative lockdep incantations,
> replace these with defines which explain what is going on and add
> commentary to explain what we're doing.
> 
> If lockdep is disabled these become no-ops. We must use defines so _RET_IP_
> remains meaningful.
> 
> These are self-documenting and aid readability of the code.
> 
> Additionally, instead of using the confusing rwsem_*() form for something
> that is emphatically not an rwsem, we instead explicitly use
> lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> are doing something rather custom here and these make more sense to use.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Nits:

> ---
>  include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
>  mm/mmap_lock.c            | 10 +++++-----
>  2 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 0b3614aadbb4..da63b1be6ec0 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const struct mm_struct *mm)
> 
>  #ifdef CONFIG_PER_VMA_LOCK
> 
> +/*
> + * VMA locks do not behave like most ordinary locks found in the kernel, so we
> + * cannot quite have full lockdep tracking in the way we would ideally prefer.
> + *
> + * Read locks act as shared locks which exclude an exclusive lock being
> + * taken. We therefore mark these accordingly on read lock acquire/release.
> + *
> + * Write locks are acquired exclusively per-VMA, but released in a shared
> + * fashion, that is upon vma_end_write_all(), we update the mmap's seqcount such
> + * that write lock is de-acquired.

de-acquired -> released?

> + * We therefore cannot track write locks per-VMA, nor do we try. Mitigating this
> + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.

"... which has to be held in order to take a VMA write lock" ?

> + * We do, however, want to indicate that during either acquisition of a VMA
> + * write lock or detachment of a VMA that we require the lock held be exclusive,
> + * so we utilise lockdep to do so.
> + */
> +#define __vma_lockdep_acquire_read(vma) \
> +	lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
> +#define __vma_lockdep_release_read(vma) \
> +	lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +#define __vma_lockdep_acquire_exclusive(vma) \
> +	lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_)
> +#define __vma_lockdep_release_exclusive(vma) \
> +	lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> +#define __vma_lockdep_stat_mark_acquired(vma) \
> +	lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> +
>  static inline void mm_lock_seqcount_init(struct mm_struct *mm)
>  {
>  	seqcount_init(&mm->mm_lock_seq);
> @@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_struct *vma)
>  	int refcnt;
>  	bool detached;
> 
> -	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -
> +	__vma_lockdep_release_read(vma);
>  	detached = __vma_refcount_put(vma, &refcnt);
>  	/*
>  	 * __vma_enter_locked() may be sleeping waiting for readers to drop
> @@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(struct vm_area_struct *vma, int
>  							      VM_REFCNT_LIMIT)))
>  		return false;
> 
> -	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +	__vma_lockdep_acquire_read(vma);
>  	return true;
>  }
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index ebacb57e5f16..9563bfb051f4 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  	if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt))
>  		return 0;
> 
> -	rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> +	__vma_lockdep_acquire_exclusive(vma);
>  	err = rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>  		   state);
> @@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  			WARN_ON_ONCE(!detaching);
>  			err = 0;
>  		}
> -		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +		__vma_lockdep_release_exclusive(vma);
>  		return err;
>  	}
> -	lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> +	__vma_lockdep_stat_mark_acquired(vma);
> 
>  	return 1;
>  }
> @@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
>  {
>  	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
>  					  &vma->vm_refcnt);
> -	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +	__vma_lockdep_release_exclusive(vma);
>  }
> 
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> @@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
>  		goto err;
>  	}
> 
> -	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +	__vma_lockdep_acquire_read(vma);
> 
>  	if (unlikely(vma->vm_mm != mm))
>  		goto err_unstable;
> --
> 2.52.0


