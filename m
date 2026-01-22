Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4987D46977
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A76C6B02CF; Thu, 22 Jan 2026 12:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 151806B02D0; Thu, 22 Jan 2026 12:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E706B02D2; Thu, 22 Jan 2026 12:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DCE2D6B02CF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:36:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2EF91A048D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:08 +0000 (UTC)
X-FDA: 84360303216.29.B519033
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18D478000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:36:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gz56qCRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Prk6qaKw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gz56qCRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Prk6qaKw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769103366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ttVLbS1EQH+SUZwhe3qFir1AokWqLiXVKEmUj65jE4=;
	b=Hbzlq1krI5kflnM7GSqHGKgt2U1LpWXRqZlfDMPOcY7o6XHQzXbSjsXdrihXsqGWNL9tz7
	dPFYJQkKWQ7OWVxlyiirLyQAt/LnVc/FXcEPRsbdYbe/a9E73Ztabkf2Gt+GZjSM4iCPbQ
	Um6RaAfNJ4lvogyu/HxGCelPclLlUKM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gz56qCRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Prk6qaKw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gz56qCRo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Prk6qaKw;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769103366; a=rsa-sha256;
	cv=none;
	b=5QHHctV6uSNwRu8rU18l6hYFwZLb0mp51iLFDgVq6caYuf+BZpKdG3Cw88oUn7d+1QdVEj
	e9A8zeXJuyLhpMILnu+pG6Z7savL7t+SWZH6ZZTSmuSsFzoKPmfCiXaOo++/FSPB5VPwUw
	sZYEOWgJ6iSF6Og8O09RaLME5koKrH4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F9A35BCCC;
	Thu, 22 Jan 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769103364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ttVLbS1EQH+SUZwhe3qFir1AokWqLiXVKEmUj65jE4=;
	b=gz56qCRoeVtMN5QwHjFgzDaibvocW4pKuKUGejIT62F98nwolknWKTEURp5QkI3igxcKqw
	Ww5FCUrVdbcFfQuP5X5gvWjkBkQ96ja7/6RQ+I1ZGdagnlopB/dVGZRK2SRPob7y+/0M1S
	vfPf1YfDcb/KduaYWRdnZzFj9MwXHkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769103364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ttVLbS1EQH+SUZwhe3qFir1AokWqLiXVKEmUj65jE4=;
	b=Prk6qaKwGD8vyQFoGJPoHVRwEGJ1uhtztMAJphAbjSfH9UEbStKxMYQ3T6qVQQwUjoqk4e
	kxMe/WO2cVOUxyCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769103364; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ttVLbS1EQH+SUZwhe3qFir1AokWqLiXVKEmUj65jE4=;
	b=gz56qCRoeVtMN5QwHjFgzDaibvocW4pKuKUGejIT62F98nwolknWKTEURp5QkI3igxcKqw
	Ww5FCUrVdbcFfQuP5X5gvWjkBkQ96ja7/6RQ+I1ZGdagnlopB/dVGZRK2SRPob7y+/0M1S
	vfPf1YfDcb/KduaYWRdnZzFj9MwXHkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769103364;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=2ttVLbS1EQH+SUZwhe3qFir1AokWqLiXVKEmUj65jE4=;
	b=Prk6qaKwGD8vyQFoGJPoHVRwEGJ1uhtztMAJphAbjSfH9UEbStKxMYQ3T6qVQQwUjoqk4e
	kxMe/WO2cVOUxyCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7FF713533;
	Thu, 22 Jan 2026 17:36:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kZReNANgcmkvWwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 22 Jan 2026 17:36:03 +0000
Message-ID: <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
Date: Thu, 22 Jan 2026 18:36:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
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
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 18D478000D
X-Stat-Signature: rhab9ia6p7zx1i1q8hoffz78tddh8qjg
X-Rspam-User: 
X-HE-Tag: 1769103365-972266
X-HE-Meta: U2FsdGVkX183WlS2Ikncoy6HYcVZc0Ehojwi1bP5MCmPDqw/yig7EogrXFQYqPGxEcuRi0QuHN05d0OaScgd/7b6bOxBoGK+Y9ARmiwRCKbgX7ynO7gfpIMwedGz3GMTmSGRxbNr7fKe/wbdLxQxmQuj0tm4Ud9x6M2j9GJWdrRpERvWWxs2TFTlovcpJt+vGW6B9lAhKtIkD9x1tBdx0VV20BjyksKKslNhOYfgxGhi89k+qO0V/laB8WSIFXoPqQA4nBnbmfOyt6EmPbu8AUzvf2Ui/mfSIsheTlDTMNFkT9V8h49nM70WbnFHn5tQ/2oaZYPbZnAq/RrIWW/KPy4W1JwXlsM80JuxuZRLVZb2DDZKlUZ/wTY741sTAEIJzD+EoGJZ2SmA9D+oxDRUKRBOuaCe10sf10cva4aP/R1bGK9GTUYZac1LKJ6epwL1GN7mjMgxci3EThxIHiUVjaie9TK+8SmBEvUBPW3U5mZcwze7YDIWM5J/yfzlAzgPuhuGcK2MNyDPDMgaA6UmNEvL8xRpaVEuo4nyaFt4bIMb3EOUL+u+KcGTnMhwKZKJexPblH2K/QI9Zz1srs4wfk81o9XModRFD0R8v6sn9/o/OU2dF14yiyMHQJLwwTGo0zqD9lycWKKWn7v02yHbwGxzNK7MLkFexkIkzgbfZPOO1XlmTJ58ounztmONxO06UdWnNOp94pD+hMPWGzUVUXAZaThLf6xHztvWaFy8KZQ51lsfEBencLK4T15ZPGetWKZvX9i40MqFl/ZlPSqnVispTNXWu61Jo9UQ+JM8A1ihi/HnxJwyoJ/GbkyUI5VGeft9VzjFsYVZOD78CmlrUuxehUS7arNd3tUU/gxa/5Z2dcWAFsjHQLy8P2yW1Mf87tf4wmwJqyCC2yrMkiGNQmiieo5OG8cA08mQqnMZW+1cObEwH6dLtijgDHhOni69ALHVfV6gfEKK3kPtvqL
 yt5AlMhH
 u2kuCnsvpWpD+8F0kt4c8QNPvvA/mG8sKNI6nRHtThsqRw+jTlgYqgkQqxp1mAA7I/2dFegF++MqVGEO/HPHuMf/tlzbtsoh+LyrYvtNTOHPN/h2M0cTenXPxIOy4yy1kNQFrUNOWqN+CUtCWD9cpYmcUeB6OujsxinvE+Q/ujDeVkD5rKVUrQOL3ZE2HCxVkHLtn7AW4gGN/OytqVt0i52HBiB2mNsOnZjgI+MjA9BetShmnlYl02GaCoESfKpvg8Bda4cah13D5XdtyBHWO/cPgnX8P8eKTxEVRtiapyXAThR+8cdF7QPPEB4QHD8K8GJ4PIInfyOuWQnswXxsaSIHMw2BeZgEQbJCNYxdxanMhHTPyB76QfZkzkv00PrFyjv9E/4TaqC0lpXQFp1ZU78zsPjICdXkbgpjMZ/8+jUIS3Cs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:01, Lorenzo Stoakes wrote:
> The is_vma_writer_only() function is misnamed - this isn't determining if
> there is only a write lock, as it checks for the presence of the
> VM_REFCNT_EXCLUDE_READERS_FLAG.
> 
> Really, it is checking to see whether readers are excluded, with a
> possibility of a false positive in the case of a detachment (there we
> expect the vma->vm_refcnt to eventually be set to
> VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
> eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> 
> Rename the function accordingly.
> 
> Relatedly, we use a finnicky __refcount_dec_and_test() primitive directly
> in vma_refcount_put(), using the old value to determine what the reference
> count ought to be after the operation is complete (ignoring racing
> reference count adjustments).
> 
> Wrap this into a __vma_refcount_put() function, which we can then utilise
> in vma_mark_detached() and thus keep the refcount primitive usage
> abstracted.
> 
> Also adjust comments, removing duplicative comments covered elsewhere and
> adding more to aid understanding.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Again very useful, thanks!

> ---
>  include/linux/mmap_lock.h | 62 +++++++++++++++++++++++++++++++--------
>  mm/mmap_lock.c            | 18 +++++-------
>  2 files changed, 57 insertions(+), 23 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index a764439d0276..0b3614aadbb4 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -122,15 +122,27 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
>  	vma->vm_lock_seq = UINT_MAX;
>  }
> 
> -static inline bool is_vma_writer_only(int refcnt)
> +/**
> + * are_readers_excluded() - Determine whether @refcnt describes a VMA which has
> + * excluded all VMA read locks.
> + * @refcnt: The VMA reference count obtained from vm_area_struct->vm_refcnt.
> + *
> + * We may be raced by other readers temporarily incrementing the reference
> + * count, though the race window is very small, this might cause spurious
> + * wakeups.

I think this part about spurious wakeups belongs more to the usage of the
function in vma_refcount_put()? Because there are no wakeups done here. So
it should be enough to explain how it can be false positive like in the
paragraph below.

> + *
> + * In the case of a detached VMA, we may incorrectly indicate that readers are
> + * excluded when one remains, because in that scenario we target a refcount of
> + * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
> + * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
> + *
> + * However, the race window for that is very small so it is unlikely.
> + *
> + * Returns: true if readers are excluded, false otherwise.
> + */
> +static inline bool are_readers_excluded(int refcnt)

I wonder if a include/linux/ header should have such a generically named
function (I understand it's necessary for it to be here). Maybe prefix the
name and make the comment not a kerneldoc because it's going to be only the
vma locking implementation using it and not the vma locking end-users? (i.e.
it's "intermediate").

>  {
>  	/*
> -	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
> -	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
> -	 * attached. Waiting on a detached vma happens only in
> -	 * vma_mark_detached() and is a rare case, therefore most of the time
> -	 * there will be no unnecessary wakeup.
> -	 *
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
>  	 * details of possible refcnt values.
>  	 */
> @@ -138,18 +150,42 @@ static inline bool is_vma_writer_only(int refcnt)
>  		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
>  }
> 
> +static inline bool __vma_refcount_put(struct vm_area_struct *vma, int *refcnt)

Basically change are_readers_excluded() like this, with __vma prefix?

But this one could IMHO use use some comment (also not kerneldoc) saying
what the return value and *refcnt indicate?

> +{
> +	int oldcnt;
> +	bool detached;
> +
> +	detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> +	if (refcnt)
> +		*refcnt = oldcnt - 1;
> +	return detached;
> +}
> +
> +/**
> + * vma_refcount_put() - Drop reference count in VMA vm_refcnt field due to a
> + * read-lock being dropped.
> + * @vma: The VMA whose reference count we wish to decrement.
> + *
> + * If we were the last reader, wake up threads waiting to obtain an exclusive
> + * lock.
> + */
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
>  {
> -	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
> +	/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt. */
>  	struct mm_struct *mm = vma->vm_mm;
> -	int oldcnt;
> +	int refcnt;
> +	bool detached;
> 
>  	rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -	if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
> 
> -		if (is_vma_writer_only(oldcnt - 1))
> -			rcuwait_wake_up(&mm->vma_writer_wait);
> -	}
> +	detached = __vma_refcount_put(vma, &refcnt);
> +	/*
> +	 * __vma_enter_locked() may be sleeping waiting for readers to drop
> +	 * their reference count, so wake it up if we were the last reader
> +	 * blocking it from being acquired.
> +	 */
> +	if (!detached && are_readers_excluded(refcnt))
> +		rcuwait_wake_up(&mm->vma_writer_wait);
>  }
> 
>  /*
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 75dc098aea14..ebacb57e5f16 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -130,25 +130,23 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
> 
>  void vma_mark_detached(struct vm_area_struct *vma)
>  {
> +	bool detached;
> +
>  	vma_assert_write_locked(vma);
>  	vma_assert_attached(vma);
> 
>  	/*
> -	 * We are the only writer, so no need to use vma_refcount_put().
> -	 * The condition below is unlikely because the vma has been already
> -	 * write-locked and readers can increment vm_refcnt only temporarily
> -	 * before they check vm_lock_seq, realize the vma is locked and drop
> -	 * back the vm_refcnt. That is a narrow window for observing a raised
> -	 * vm_refcnt.
> -	 *
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
>  	 * details of possible refcnt values.
>  	 */
> -	if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> +	detached = __vma_refcount_put(vma, NULL);
> +	if (unlikely(!detached)) {
>  		/* Wait until vma is detached with no readers. */
>  		if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) {
> -			bool detached;
> -
> +			/*
> +			 * Once this is complete, no readers can increment the
> +			 * reference count, and the VMA is marked detached.
> +			 */
>  			__vma_exit_locked(vma, &detached);
>  			WARN_ON_ONCE(!detached);
>  		}
> --
> 2.52.0


