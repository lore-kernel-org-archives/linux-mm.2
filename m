Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF0A5CF65DF
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8516B0088; Mon, 26 Jan 2026 06:16:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6846B0089; Mon, 26 Jan 2026 06:16:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DCA6B008A; Mon, 26 Jan 2026 06:16:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8114E6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:16:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0AB5259F88
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:16:13 +0000 (UTC)
X-FDA: 84373861026.08.DFE5232
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 64E4E180006
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:16:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EvyJUtSX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DB1twWGR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EvyJUtSX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DB1twWGR;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769426170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dI/c6j+PqiYrt3tZ5xQSf4a8ZF30BeGQ5tnKSkd0ikA=;
	b=CRQWr4VSvlP0Lqf99PWUmHzoquOy7qtsVEjRXHRz0Cm6e0pwQ9vw7p7cccpMAY2psgfYxY
	g03s6uRAGrh/JsUxFx+exhC9VN4PdV8gso255Z3W8QP+ToHhZpWsZAtVzszq7D5vjJguRu
	NK3Z+PMRBjt3UN4G1IMGcVsQYE1xidw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EvyJUtSX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DB1twWGR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EvyJUtSX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DB1twWGR;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769426170; a=rsa-sha256;
	cv=none;
	b=tOsfcr2iLfCedhsJRrLRqXh18kcjJ0IWhsmg/gUcIoiqIjkuXGOrwMmkR+Fcdc72hNuo2W
	rbDgxmuFRqxQxZxrHH0Il6w5bbpP5BJhKOon6+1gyetw0RQvUO5Zae8ZAkCfiGqtmEbkVg
	lnybwyMd0xnaWWGUlhtZ7yzrIjCpagI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7B8745BD53;
	Mon, 26 Jan 2026 11:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769426168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dI/c6j+PqiYrt3tZ5xQSf4a8ZF30BeGQ5tnKSkd0ikA=;
	b=EvyJUtSXghewzrG6vC86fIzAqxQDa8sFD7I84zYB1c8JrYErws5xw1nG4ZSsL9sUsQaHo6
	W7AA0em2DGXDa4CK/uv8Z/q8DCjjqR0gRBqcVV5kXImWCHSFFNlMAY49hLRkKeyS5g8zI5
	3BW5cEDyVz1hrJnbfK9MW5SjSzMFJEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769426168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dI/c6j+PqiYrt3tZ5xQSf4a8ZF30BeGQ5tnKSkd0ikA=;
	b=DB1twWGR4gOq88xWxkkHqLSFlUJ/AGg6rkDc0f5dwe2EZm2j+tkfXiwWPBwt63jADinO2V
	8VSVuzYFNaXFAzCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769426168; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dI/c6j+PqiYrt3tZ5xQSf4a8ZF30BeGQ5tnKSkd0ikA=;
	b=EvyJUtSXghewzrG6vC86fIzAqxQDa8sFD7I84zYB1c8JrYErws5xw1nG4ZSsL9sUsQaHo6
	W7AA0em2DGXDa4CK/uv8Z/q8DCjjqR0gRBqcVV5kXImWCHSFFNlMAY49hLRkKeyS5g8zI5
	3BW5cEDyVz1hrJnbfK9MW5SjSzMFJEc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769426168;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dI/c6j+PqiYrt3tZ5xQSf4a8ZF30BeGQ5tnKSkd0ikA=;
	b=DB1twWGR4gOq88xWxkkHqLSFlUJ/AGg6rkDc0f5dwe2EZm2j+tkfXiwWPBwt63jADinO2V
	8VSVuzYFNaXFAzCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 49C5613A0F;
	Mon, 26 Jan 2026 11:16:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0yuwEfhMd2l6SgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 11:16:08 +0000
Message-ID: <ba27d41a-2109-4c89-83ce-00ba8b78d249@suse.cz>
Date: Mon, 26 Jan 2026 12:16:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/10] mm/vma: introduce helper struct + thread through
 exclusive lock fns
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
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: n6q946tg97eeic5gt55xtrgcoigpns1p
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 64E4E180006
X-HE-Tag: 1769426170-806613
X-HE-Meta: U2FsdGVkX19JrYoRgLDF/8LsAbgDtbxcPQBIb5ekguByUdKCVzCwV0Q9STLzP6An0BiGQhDRmTFmIsPvaV89hP5Ud2afJORM4nmwKfYEmxmZmKU1hxZAYfKBItklO18IjZFb/iOr9P6nP3yfaefO1lIW9KFd7Y7bLTaxz8wm6HRvfI9xQUR+7MhUDMuBPtMGiCwMawdaAVeQFMd1nQTGWbMbW0jg+eCe5Ch+PIDw2pvQ/m4fUd/CQkTtnhDn824l5hNevsPgx5hTGrVNOT758ALVWvrOYCXrkBHQsZ7eQ73umA8xKWlAUbVNksNUm8fxcxWbNpWnSCzg7mZKvILG/8RgOpBSbO0SeULOVYXLnSK+V9u+8abf0qP+fKroZZqj2nw0/0nHqAreRs70W+9Sl7bsBdCLHSfQkjDeRNtHo1OZwAKBV+eofGf+yyv577g3K4adzbetyMOEmIALEt/ToZBfnokUlxEyE3I5eiq/Pzor106RYrP/v9TSf6FLBoPCw1wui5fA8tmlwFyH00NUX7c+RNGzv73RinDzppP2PxN+Wa0PUOd8D4Tbnk4EyBzsfO1FRwnMvboZ+k+EXRL0zxN+0l9hL2lfNZfoev9YXTgesCaa6OdhDQO+MhQCgpmgeroA+9vRqj+9Ht+QsdrCbs1DWi8wOV6oT5r8TBPKY4R1tx9l/8/g2c4on2FPlXDAEOGtGhGZxqVPOYLQvRY1f1UhiyLPCNaIgjCvFku/r1hb38oLEWYYFPZQY8mV7g2GeRg/xyHH0zLtDUmcXPZaiLUmp19/JZSubyykCQvgl3aBOnKXPinb3KLMb6ZKrdJemUC9J83rG99FsymsEzYzfrGPSrHXexmgHPWizIXjcXE2JZNv+zem3/kpnLO2b/MTUdZahjJI8kpiQGhCYDVuRP/HH4QHE00J73aUZNItsEFk2wp4J/PeMg3bvC3j4hpuTrH5UXRibmVL/yKso6n
 AXbj9jwQ
 ooFPI2UDJFK6Oeo3vJSbx6/JFdWo19FmrkIXR5tJY/hoYvngAHKz0+Igt+5rr7t8cxPi8sQOyZEgaF439kWicgUJGs/pvJE/gIls/xOSrXnQKIpvjsz8t9ARIAFRSWMFNdwEzJu9liw2cL3gse29szf1ZsO+jjOKLA2O8ADIuYK19DOWQ9eNg2Rm3ERG9PFd0ND0bPSayI7Z4z4waelYv4Uwv8rmmxYX6gECXy1Gx9L5/a/9FLYvs+Y0JHsdSHw0EMkAh9xYPVuaz7FwZ6mjNtBo45ZkkWKyR0yB0fEDyVQvI5Z5lNesIEzURVqwDX/wSdz6ooSdBC6FJwxJDzr7nUaoqMK8jdZSIB8Gixxj3OVZdeGlr/pKzB1pZ+eiKhncZ1zdd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 21:12, Lorenzo Stoakes wrote:
> It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an

It's now __vma_start_exclude_readers()

> error (but only when waiting for readers in TASK_KILLABLE state), and
> having the return value be stored in a stack variable called 'locked' is
> further confusion.
> 
> More generally, we are doing a lock of rather finnicky things during the

				 ^ lot?

> acquisition of a state in which readers are excluded and moving out of this
> state, including tracking whether we are detached or not or whether an
> error occurred.
> 
> We are implementing logic in __vma_enter_exclusive_locked() that

again __vma_start_exclude_readers()

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
> Finally, separate vma_mark_detached() into its fast-path component and make
> it inline, then place the slow path for excluding readers in mmap_lock.c.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Great improvement, thanks.

Just some more nits wrt naming.

> ---
>  include/linux/mm_types.h  |  14 ++--
>  include/linux/mmap_lock.h |  23 +++++-
>  mm/mmap_lock.c            | 152 +++++++++++++++++++++-----------------
>  3 files changed, 112 insertions(+), 77 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 12281a1128c9..ca47a5d3d71e 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1011,15 +1011,15 @@ struct vm_area_struct {
>  	 * decrementing it again.
>  	 *
>  	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> -	 * __vma_exit_locked() completion which will decrement the reference
> -	 * count to zero. IMPORTANT - at this stage no further readers can
> -	 * increment the reference count. It can only be reduced.
> +	 * __vma_exit_exclusive_locked() completion which will decrement the

__vma_end_exclude_readers()

> +	 * reference count to zero. IMPORTANT - at this stage no further readers
> +	 * can increment the reference count. It can only be reduced.
>  	 *
>  	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
> -	 * an attached VMA and has yet to invoke __vma_exit_locked(), OR a
> -	 * thread is detaching a VMA and is waiting on a single spurious reader
> -	 * in order to decrement the reference count. IMPORTANT - as above, no
> -	 * further readers can increment the reference count.
> +	 * an attached VMA and has yet to invoke __vma_exit_exclusive_locked(),

__vma_end_exclude_readers()

(also strictly speaking, these would belong to the previous patch, but not
worth the trouble moving)

> +	 * OR a thread is detaching a VMA and is waiting on a single spurious
> +	 * reader in order to decrement the reference count. IMPORTANT - as
> +	 * above, no further readers can increment the reference count.
>  	 *
>  	 * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
>  	 * write-locking or detaching a VMA is waiting on readers to
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index d6df6aad3e24..678f90080fa6 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -358,7 +358,28 @@ static inline void vma_mark_attached(struct vm_area_struct *vma)
>  	refcount_set_release(&vma->vm_refcnt, 1);
>  }
>  
> -void vma_mark_detached(struct vm_area_struct *vma);
> +void __vma_exclude_readers_for_detach(struct vm_area_struct *vma);
> +
> +static inline void vma_mark_detached(struct vm_area_struct *vma)
> +{
> +	vma_assert_write_locked(vma);
> +	vma_assert_attached(vma);
> +
> +	/*
> +	 * The VMA still being attached (refcnt > 0) - is unlikely, because the
> +	 * vma has been already write-locked and readers can increment vm_refcnt
> +	 * only temporarily before they check vm_lock_seq, realize the vma is
> +	 * locked and drop back the vm_refcnt. That is a narrow window for
> +	 * observing a raised vm_refcnt.
> +	 *
> +	 * See the comment describing the vm_area_struct->vm_refcnt field for
> +	 * details of possible refcnt values.
> +	 */
> +	if (likely(!__vma_refcount_put_return(vma)))
> +		return;
> +
> +	__vma_exclude_readers_for_detach(vma);
> +}
>  
>  struct vm_area_struct *lock_vma_under_rcu(struct mm_struct *mm,
>  					  unsigned long address);
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 72f15f606093..b523a3fe110c 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,20 +46,38 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
>  
> +/* State shared across __vma_[enter, exit]_exclusive_locked(). */

__vma_[start,end]_exclude_readers

> +struct vma_exclude_readers_state {
> +	/* Input parameters. */
> +	struct vm_area_struct *vma;
> +	int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> +	bool detaching;
> +
> +	/* Output parameters. */
> +	bool detached;
> +	bool exclusive; /* Are we exclusively locked? */
> +};
> +
>  /*
>   * Now that all readers have been evicted, mark the VMA as being out of the
>   * 'exclude readers' state.
> - *
> - * Returns true if the VMA is now detached, otherwise false.
>   */
> -static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
> +static void __vma_end_exclude_readers(struct vma_exclude_readers_state *ves)
>  {
> -	bool detached;
> +	struct vm_area_struct *vma = ves->vma;
>  
> -	detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> -					 &vma->vm_refcnt);
> +	VM_WARN_ON_ONCE(ves->detached);
> +
> +	ves->detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
> +					      &vma->vm_refcnt);
>  	__vma_lockdep_release_exclusive(vma);
> -	return detached;
> +}
> +
> +static unsigned int get_target_refcnt(struct vma_exclude_readers_state *ves)
> +{
> +	const unsigned int tgt = ves->detaching ? 0 : 1;
> +
> +	return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
>  }
>  
>  /*
> @@ -69,32 +87,29 @@ static bool __must_check __vma_end_exclude_readers(struct vm_area_struct *vma)
>   * Note that this function pairs with vma_refcount_put() which will wake up this
>   * thread when it detects that the last reader has released its lock.
>   *
> - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases where we
> - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal signal
> - * is permitted to kill it.
> + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases
> + * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal
> + * signal is permitted to kill it.
>   *
> - * The function will return 0 immediately if the VMA is detached, or wait for
> - * readers and return 1 once they have all exited, leaving the VMA exclusively
> - * locked.
> + * The function sets the ves->exclusive parameter to true if readers were
> + * excluded, or false if the VMA was detached or an error arose on wait.
>   *
> - * If the function returns 1, the caller is required to invoke
> - * __vma_end_exclude_readers() once the exclusive state is no longer required.
> + * If the function indicates an exclusive lock was acquired via ves->exclusive
> + * the caller is required to invoke __vma_end_exclude_readers() once the
> + * exclusive state is no longer required.
>   *
> - * If state is set to something other than TASK_UNINTERRUPTIBLE, the function
> - * may also return -EINTR to indicate a fatal signal was received while waiting.
> + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
> + * function may also return -EINTR to indicate a fatal signal was received while
> + * waiting.

It says "may also return..." but now doesn't say anywhere that otherwise
it's always 0.

>   */
> -static int __vma_start_exclude_readers(struct vm_area_struct *vma,
> -		bool detaching, int state)
> +static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)

