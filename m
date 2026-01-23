Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B882D72366
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 10:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6F66B04A0; Fri, 23 Jan 2026 05:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A8D6B04A2; Fri, 23 Jan 2026 05:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E676B04A3; Fri, 23 Jan 2026 05:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6986B04A0
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 05:02:09 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2CA621403F9
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:02:09 +0000 (UTC)
X-FDA: 84362787978.12.BB78B7D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id A365B40009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:02:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kukvdrpF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d05H+LcN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kukvdrpF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d05H+LcN;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769162527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFcDC4EXejW+tdxTtQmYrC9+v+ryY4NIc5XHObwVz8g=;
	b=uAfpV9621ZVjIg0NtA87TSIimVPBfkAgqeHCG4F7Mb5zCOu1G/C9msD/oBUtaqoXzwN13+
	lPpj+NOvx/UN3E7AC7YYsHRWep1CElCwMP84pJ87LLOj+p3jLw4Fgo3Uoo2q9kubNw2NOy
	vf4rl+C17U01sdXxv/gWyusQ5W2OE4Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kukvdrpF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d05H+LcN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kukvdrpF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=d05H+LcN;
	spf=pass (imf04.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769162527; a=rsa-sha256;
	cv=none;
	b=wljG2pY2KVVyx/4PqYsvrLZZa+lhtt1SZmQeAgiPpbpjFIJjPsdCN/uy4im1B55OffkIty
	Ns+jw3d9/91idAEUIYMQRkUZzNWPdMmnS8vJ9AVhoKcYnrkXSM54JyVfzPiOnkRSljepR1
	IGiS058pp47C5FIIx0dGi5PoNtMupk8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8E2E55BCC7;
	Fri, 23 Jan 2026 10:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769162524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZFcDC4EXejW+tdxTtQmYrC9+v+ryY4NIc5XHObwVz8g=;
	b=kukvdrpFf6yZI02Qq04CjaOhdk7y/QHfRtxeqCHP1Qk2X/+rIb4VypK2OYNFOT6XLPG07w
	99vnWWNT7lGWVlmkf4VuLptH615oa+e1dSAF/NC3eSiL71Ljxk0KbTXsJGHzyH6VnC1l0e
	hDqIXEO71KfT5L9zzbTowbL62i7jY2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769162524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZFcDC4EXejW+tdxTtQmYrC9+v+ryY4NIc5XHObwVz8g=;
	b=d05H+LcNK4hxzca7d/VFTxxcrynqHVgBTYGDKJ1IYVWf6gqYTcbZkSZHRMYVNfuGQCns6a
	KD8wStzWk5Lp4oAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769162524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZFcDC4EXejW+tdxTtQmYrC9+v+ryY4NIc5XHObwVz8g=;
	b=kukvdrpFf6yZI02Qq04CjaOhdk7y/QHfRtxeqCHP1Qk2X/+rIb4VypK2OYNFOT6XLPG07w
	99vnWWNT7lGWVlmkf4VuLptH615oa+e1dSAF/NC3eSiL71Ljxk0KbTXsJGHzyH6VnC1l0e
	hDqIXEO71KfT5L9zzbTowbL62i7jY2Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769162524;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZFcDC4EXejW+tdxTtQmYrC9+v+ryY4NIc5XHObwVz8g=;
	b=d05H+LcNK4hxzca7d/VFTxxcrynqHVgBTYGDKJ1IYVWf6gqYTcbZkSZHRMYVNfuGQCns6a
	KD8wStzWk5Lp4oAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 625E1136AA;
	Fri, 23 Jan 2026 10:02:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I1SsFxxHc2k3HAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 10:02:04 +0000
Message-ID: <76e112da-a8b6-4004-9bce-2dcc29dea7fc@suse.cz>
Date: Fri, 23 Jan 2026 11:02:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
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
 <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: A365B40009
X-Rspamd-Server: rspam07
X-Stat-Signature: rrk83iebaxzwohon34pbpfmgh4cemn5a
X-HE-Tag: 1769162526-722359
X-HE-Meta: U2FsdGVkX19Hy4umSAGw9tlmRqCqz9H1fNWd68r9jMyN/0bMJytbszx7ApfVgKTZWMpAsMWaxWFWpk/cYbRY8rQw5Rm4P0GJjYGAgcHZf7TPSdF4fXp1YsIQ04K7XcBkZkHavJqhozwT0L1TZuEzkNe6SEEnJ91/P9aQ0Xbu6/pTUfTrcn7tLWgYXjtJiNgF/z0Asc3lyeAa6UEqXaQHj6uybFLLDGsl++j9usqsHpDTBkdYl8MiyymOPlRiSuptttF2ltCpCX1xJa1cAi3XTDILcfMFrWEOrPVAssFDYYMCu9NzFrr3D6YGk/LzpjzQVJLhGMWFNBtx9M3vGoov38YJBvLKyW0/FaoP5OI3XvBnVHGnOTE8NLoz1YlKyk/FualKyRlfSBNlZlt43ucmm2G8gx7rSkBaIjspsHGzmAhLz5zUuQoONHm/qR9gSlhnixxdXyb97DWYCQlcWBVa37587DY+lgSg6M1rMVG7vpID0cugJZKRi8ViUVtK98buUC4jPBnlmPrchmPR9uj93xflIATTDxsIdz0s7y1sHfmfEzTYgp3Mkus2dGQ/yh9tBx8SPyMcfuClUzbqGIsn7fVlG3hUB99UyURp3I1JRJP20wdufA+teNjqIpPkQcAwuDpBemK3o7h+slGhFL6kwQ9Tfqs2IFD87nSc97zBEC6M3fwHM6wMGtFZWk7BRsCVsn97P6yeJPGq72LbmsLbMMpHaYUqJbg3jmY9IRWJym2qvlGJP5biXhgGd82pA0ds6zM3Xw3FuZUDT5pLgpgoEHMVsutJXr4jFVbn1+Rq0CBxoc8aikKY75eWH70z2zWydzda6L0e7yCQRot5CdzN751d6w9c+BJt9/YNWKw/POiuUc+LNORLF5Pm9XtqN44wW3hdkJAG8p/ix/pCFgAqFRIIwH5Oiht0yiOw/bHcuTDLbM0dp1U2N2qaRcfEFNo2K+aip6txRTXQVBLakdy
 dPAIUJ44
 56gZ0eMXOvVaJDDJxGkOgDYUoOuEPn9kdxlEqdHpzTlnuVr8PPEDNaSsMNFtDUuB8Mwo2tc5QL5o1yvLAzk1wVuAdE1llvf1/cgkycPMndycbZA9FPeLS02TmIWiyZ1omrn27MUD7KlDhGbDP9blv9vaBLClwru0nEbVzTO33Em17bTH7Rer6N/Jfy+5dCVMalxgI5JoK/7954gWQ1wUtKSsJnVP87fZvPPVMlAZp2F8J2gQpJ2sK9pNG9aCoippczjv6CewfDEbaDyPTR4HcgaDuYyDFAkuio0Ze/b+cqg1IMJQZ2CQzWdQ6YJpNEOPUtrNWAz7AoWEzulLKfh1dlIuYg7cO1rCYqAmmrqIBEGiERVgdGyhJPu6MqUsapVnph5o4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:01, Lorenzo Stoakes wrote:
> It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
> error (but only when waiting for readers in TASK_KILLABLE state), and
> having the return value be stored in a stack variable called 'locked' is
> further confusion.
> 
> More generally, we are doing a lock of rather finnicky things during the
> acquisition of a state in which readers are excluded and moving out of this
> state, including tracking whether we are detached or not or whether an
> error occurred.
> 
> We are implementing logic in __vma_enter_exclusive_locked() that
> effectively acts as if 'if one caller calls us do X, if another then do Y',
> which is very confusing from a control flow perspective.
> 
> Introducing the shared helper object state helps us avoid this, as we can
> now handle the 'an error arose but we're detached' condition correctly in
> both callers - a warning if not detaching, and treating the situation as if
> no error arose in the case of a VMA detaching.
> 
> This also acts to help document what's going on and allows us to add some
> more logical debug asserts.
> 
> Also update vma_mark_detached() to add a guard clause for the likely
> 'already detached' state (given we hold the mmap write lock), and add a
> comment about ephemeral VMA read lock reference count increments to clarify
> why we are entering/exiting an exclusive locked state here.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 91 insertions(+), 53 deletions(-)
> 
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index f73221174a8b..75166a43ffa4 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
> 
> +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
> +struct vma_exclude_readers_state {
> +	/* Input parameters. */
> +	struct vm_area_struct *vma;
> +	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> +	bool detaching;
> +
> +	bool detached;
> +	bool exclusive; /* Are we exclusively locked? */
> +};
> +
>  /*
>   * Now that all readers have been evicted, mark the VMA as being out of the
>   * 'exclude readers' state.
>   *
>   * Returns true if the VMA is now detached, otherwise false.
>   */
> -static bool __must_check __vma_exit_exclusive_locked(struct vm_area_struct *vma)
> +static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state *ves)
>  {
> -	bool detached;
> +	struct vm_area_struct *vma = ves->vma;
> +
> +	VM_WARN_ON_ONCE(ves->detached);
> +	VM_WARN_ON_ONCE(!ves->exclusive);

I think this will triger when called on wait failure from
__vma_enter_exclusive_locked(). Given the other things Suren raised about
the field, I wonder if it's worth keeping it?

> -	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> -					 &vma->vm_refcnt);
> +	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> +					      &vma->vm_refcnt);
>  	__vma_lockdep_release_exclusive(vma);
> -	return detached;
> +}
> +

> @@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> 
>  void vma_mark_detached(struct vm_area_struct *vma)
>  {
> -	bool detached;
> +	struct vma_exclude_readers_state ves = {
> +		.vma = vma,
> +		.state = TASK_UNINTERRUPTIBLE,
> +		.detaching = true,
> +	};
> +	int err;
> 
>  	vma_assert_write_locked(vma);
>  	vma_assert_attached(vma);
> @@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
>  	 * details of possible refcnt values.
>  	 */
> -	detached = __vma_refcount_put(vma, NULL);
> -	if (unlikely(!detached)) {
> -		/* Wait until vma is detached with no readers. */
> -		if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> -			/*
> -			 * Once this is complete, no readers can increment the
> -			 * reference count, and the VMA is marked detached.
> -			 */
> -			detached = __vma_exit_exclusive_locked(vma);
> -			WARN_ON_ONCE(!detached);
> -		}
> +	if (likely(__vma_refcount_put(vma, NULL)))
> +		return;

Seems to me it would be worthwhile splitting this function to an
static-inline-in-header vma_mark_detached() that does only the asserts and
__vma_refcount_put(), and keeping the function here as __vma_mark_detached()
(or maybe differently named since the detaching kinda already happened with
the refcount put... __vma_mark_detached_finish()?) handling the rare case
__vma_refcount_put() returns false.

> +
> +	/*
> +	 * Wait until the VMA is detached with no readers. Since we hold the VMA
> +	 * write lock, the only read locks that might be present are those from
> +	 * threads trying to acquire the read lock and incrementing the
> +	 * reference count before realising the write lock is held and
> +	 * decrementing it.
> +	 */
> +	err = __vma_enter_exclusive_locked(&ves);
> +	if (!err && !ves.detached) {
> +		/*
> +		 * Once this is complete, no readers can increment the
> +		 * reference count, and the VMA is marked detached.
> +		 */
> +		__vma_exit_exclusive_locked(&ves);
>  	}
> +	/* If an error arose but we were detached anyway, we don't care. */
> +	WARN_ON_ONCE(!ves.detached);
>  }
> 
>  /*
> --
> 2.52.0


