Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89F69D13C0D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 13:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48F96B0088; Mon, 26 Jan 2026 08:42:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6ED6B0089; Mon, 26 Jan 2026 08:42:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEFB6B008A; Mon, 26 Jan 2026 08:42:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4C96B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:42:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B4651602E2
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:42:05 +0000 (UTC)
X-FDA: 84374228610.11.A51980A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9A8C7C0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 13:42:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owfdidsi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="FGq94/7w";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vBJZc1qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/FC07lqM";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769434923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rfZY7YT/x2O6vUyq6hh8AAEHXXvrurd7nwEreYarD3k=;
	b=5XssFcS0XN31tvieJGZyghjUoSpVxQWBzVwdIVtm/4/+GhT5PxcWNlR8/n5rVBnGOONh3X
	Fwvc8EqXo09PpyacPC0JkRvFJl3DjS76krYyfhVpnnyNIIG2il+19OVXxBvkW661SVqYhL
	GQ3pwqERmf3lQ2KLve5LnTqJ5iyeuyY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=owfdidsi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="FGq94/7w";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vBJZc1qc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/FC07lqM";
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769434923; a=rsa-sha256;
	cv=none;
	b=W6lciZQg8NVpJxWw8ACnu6Gf8oWcSm5Jo7DX/f3LH3lde8V1C7mqvZJIYK4Yx2gCW7+wHa
	NJkvRC8HGUaqjF8Efj0iLHQ68WyY6oNQQot8Kf4hTVXyDN2+HkGtBQElE9vd/R6LxPoJzH
	FhUMlfVswEkaNmxJBPq9wm0I+BnNBpQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAFF15BCE3;
	Mon, 26 Jan 2026 13:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769434921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rfZY7YT/x2O6vUyq6hh8AAEHXXvrurd7nwEreYarD3k=;
	b=owfdidsiAmgz4uaYDiwOPZl3b7eKSyNSjSov9V0zdULg3flxl1Og9Ivmvm08nlnmeIkYm6
	jGVmiTe92MzZFejn8ggjTIIBfi9KtxIZhH32cUGEj9odq5m2xlRSNp48YvxLbjt16LbxJ1
	0ZKTy7mqeEeKVx31KUhmOb7k6g0Ipzc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769434921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rfZY7YT/x2O6vUyq6hh8AAEHXXvrurd7nwEreYarD3k=;
	b=FGq94/7wl9b3dpgRVN7WQP5VrnrYmORbHJSxGPc6/lpwbodJfSLdM4UlpA/oV63SQaxAtW
	wrkmBVn4A3TUkaCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769434920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rfZY7YT/x2O6vUyq6hh8AAEHXXvrurd7nwEreYarD3k=;
	b=vBJZc1qcWGxeu3m8UNysIJ79bLRuEC7OlIi8BIYreJyaRVVlRApRdg+yefSrKx4+GtFi/m
	OAO9R2kt45EJ1YKGfF4ifZhpWDYu+ke60+3zCecAPz6QrMDDJcjVKk681DDyZboyMVXKhq
	DZJEMhqfqM/xXsmYQICykuFFMfFmeT8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769434920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rfZY7YT/x2O6vUyq6hh8AAEHXXvrurd7nwEreYarD3k=;
	b=/FC07lqMVMDwYRUpJn4PljxAxODnKS6oyJEXM42BukOgoOHgxU7PtrY1DtP3wGUwSrRTc1
	ma8M172qRtLTzwAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCC91139E9;
	Mon, 26 Jan 2026 13:42:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8lTDLShvd2nIZAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 13:42:00 +0000
Message-ID: <6c4162c5-1703-45db-b9ca-96ecd8ce551f@suse.cz>
Date: Mon, 26 Jan 2026 14:42:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/10] mm/vma: update vma_assert_locked() to use
 lockdep
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
 <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <538762f079cc4fa76ff8bf30a8a9525a09961451.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w4fdpfgscwdkchwb5u757zoabjcwqm5c
X-Rspamd-Queue-Id: 9A8C7C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769434922-539066
X-HE-Meta: U2FsdGVkX1/tkxODyA5TYqLKy17NdVPUCzW57h/jTWOhgls5IU3huayg/ed3TvPiDll7NEEjvdrby/6ROQfwjwRG5f/xZxSZqtb1CUDVXvCSyqYwFtZlg5yHr811bTHWETu53HjfG8DmZ4tes49m9tjlxS1lwtz9B1i+25W7486taV/5ZcWqYbUvpnAP7fqvz3Y0dISoprEvmGmKBVYTy+bW/Z8ZIippoxOehXK1EStbF0YQO4R4o4KiM+xwQetWzOtrQuLyLeYv0N7WjOiDWLWfCQSpJEgosUUbalphWUR9FUMAJ3YorWDqvuy/MqbUJuNRWp4YbrEALhkgjNWQSI9tfnMr5jt+E6Yuwta/g6M/ZsCcm+Lz+wc2hXBkMP3S5c84E2e+RUu2ORn/74cTFtnHVyovw6UYn8s4Ot1q4h6TXm4yr3STid7nrqXhMCMSbfis/A1OzVyxCf5SFwf6BvxaqIfPBDAN192ovels7WpgVFmN9PAnG8H3mmx0CI1lsarYCfvd+d0GVaFaPGIHw22yNO4YNfPScweShkWJTE1a0weUU5QoQAmDM9Ox4uIUvdsRe1eIpTp7eDSrvBBsVyXJfEZYn2uGlNwP6xeqU3P0lUxAH1AYwA3zosOifeLlDAgPA0KEJnhMQDWrlEqhKbYzOXKh7wDHXyCMQadbid7aSiolxtrU+zGPkSk9AzcUTgLxC/59LCysMT2EhA0rRSSCw5HlyR76AJ1YYV3vc8BCRcEmCBHip9N2uacKwgCPI4Me7CzYrCXAigIXnvRPiguuDosVZF7rnel/Up1NNJc/MDF2HomNXex7vPfP79bcnU/gWH35mtPvzfs0NFDYEMUynp6kwnui88VSEHiKt220U7XNenn+UYX/dYNUSsHhnAAuT6gi0MIGArrETozcRafK4uM0C/WjUTkYguvsI8euItMVhCxvz3NdtPWx40AsMYb9LpQdN4Yf4Xxv/Tq
 CxL3Ak4g
 CylQm0wBog29wL3VdbdGCkHsgwd+PEVaiG9Cvp4W63OHMDkDQii3rLcJu5OCPwefg8wy5za5vQZ9UQI69g1egyHv+e8tpk0V1bD45BT1z7pexg0z4HJpQ8mWenMl/w9C/CUBBHrNbFRHQJZJUS4Jw8hhwn8PQga3daKqeExlExiS4RowkaAoo48odepetnz5yMO5SXA77niWPW7EZ99yLVTycYUl/asYUhTfIRWZ0urb97wqa5cXSX15XYxFRIUOrvEx0uWmJrgHyqeTbAlutnU4ijLZRy1HNQvEefnf33jmswA7L8vDlGkUb2P6JEh1XpKMpCneZGJYCDOhYcdsymeFZpglydvZ0r8rclWdKrEjc7Dx1COkHKKv7n+6MAU6+v5622/leHix8SLyN+iTSOIa3Pp5S9kzYTRMAIYSJF1sAY+F0AV1yWLC6famK8v7JXrPOhtqedBMQeWk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 21:12, Lorenzo Stoakes wrote:
> We can use lockdep to avoid unnecessary work here, otherwise update the
> code to logically evaluate all pertinent cases and share code with
> vma_assert_write_locked().
> 
> Make it clear here that we treat the VMA being detached at this point as a
> bug, this was only implicit before.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Nit:

> ---
>  include/linux/mmap_lock.h | 41 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 23bde4bd5a85..4a0aafc66c5d 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -322,19 +322,56 @@ int vma_start_write_killable(struct vm_area_struct *vma)
>  	return __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_KILLABLE);
>  }
>  
> +/**
> + * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
> + * @vma: The VMA to assert.
> + */
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  {
>  	VM_WARN_ON_ONCE_VMA(!__is_vma_write_locked(vma), vma);
>  }
>  
> +/**
> + * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
> + * lock and is not detached.
> + * @vma: The VMA to assert.
> + */
>  static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
> +	unsigned int refcnt;
> +
> +	/*
> +	 * If read-locked or currently excluding readers, then the VMA is
> +	 * locked.
> +	 */
> +#ifdef CONFIG_LOCKDEP
> +	if (lock_is_held(&vma->vmlock_dep_map))
> +		return;

Wouldn't this work a tiny bit better?

	if (!lock_is_held(&vma->vmlock_dep_map))
		vma_assert_write_locked(vma);
	return;

> +#endif
> +
>  	/*
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
>  	 * details of possible refcnt values.
>  	 */
> -	VM_WARN_ON_ONCE_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
> -			    !__is_vma_write_locked(vma), vma);
> +	refcnt = refcount_read(&vma->vm_refcnt);
> +
> +	/*
> +	 * In this case we're either read-locked, write-locked with temporary
> +	 * readers, or in the midst of excluding readers, all of which means
> +	 * we're locked.
> +	 */
> +	if (refcnt > 1)
> +		return;
> +
> +	/* It is a bug for the VMA to be detached here. */
> +	VM_WARN_ON_ONCE_VMA(!refcnt, vma);
> +
> +	/*
> +	 * OK, the VMA has a reference count of 1 which means it is either
> +	 * unlocked and attached or write-locked, so assert that it is
> +	 * write-locked.
> +	 */
> +	vma_assert_write_locked(vma);
>  }
>  
>  static inline bool vma_is_attached(struct vm_area_struct *vma)


