Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F1CBD77880
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 16:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567386B0517; Fri, 23 Jan 2026 11:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5148D6B0518; Fri, 23 Jan 2026 11:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1856B0519; Fri, 23 Jan 2026 11:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22C306B0517
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:56:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5F6FD3307
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:56:04 +0000 (UTC)
X-FDA: 84363831048.15.DA56F6F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 53FD4100005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 16:56:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X7CAej10;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybBh15QO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X7CAej10;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybBh15QO;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769187362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSHcmTaOgyJ3QuCyEZtrSdPqnVt4EqkAgAHM6oep9TY=;
	b=oZNC4u3tLJnp9aZmwn5kBgxdG/yydH1wSXSLgld9PNQXk+hhBP5pC0qHfE2JgwCqFqHHIL
	fWgaYcGYG/iAap/X/LKtdM6go/517+7XQl5rtwT30WxL+u4DNPrthPY1xR3gcpvI8dcI2P
	bXqn3ctlvBoBbYMrynqyo9+oyL4xvps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769187362; a=rsa-sha256;
	cv=none;
	b=pcMnqh5QHA5N5uo0xvk76RjYy6EWo8xxtNBafLYNV29L5FgRFPrfD4dvrYF12FZB9/+Cuz
	euxMXRc/ZiDgEQ/gBsooV3elU+xogngW4g+e67GVpp315v1+ql2p+ALgNsj1hYe6Uw/kWL
	G40Pzllxd+97nzmSDSR7+U8NtlC+flk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X7CAej10;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybBh15QO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=X7CAej10;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ybBh15QO;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6037A33838;
	Fri, 23 Jan 2026 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769187360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSHcmTaOgyJ3QuCyEZtrSdPqnVt4EqkAgAHM6oep9TY=;
	b=X7CAej10e5EJ0Xbqj96GilGrmesN6uIkdTRE+NIIIZCM/oiuz5ED2QXS0LpsSeiXlX2Yvi
	6ifzxVvB53xSoOBZnZRWC3s2+jRvqs+n/TEuWI6iaizpcPSm56rg43WsmuVqcdGzcVZeaC
	VgJgy8ABVQXJ5+ZAo3ZElztGZQLqpTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769187360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSHcmTaOgyJ3QuCyEZtrSdPqnVt4EqkAgAHM6oep9TY=;
	b=ybBh15QOSfeNuSWn6ChA6Dk51J4zXNx2M2YGicUZwzygmLN1P8XmJszJ71tCiuM/dfP2E3
	CKw46kHVoQu6+lBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769187360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSHcmTaOgyJ3QuCyEZtrSdPqnVt4EqkAgAHM6oep9TY=;
	b=X7CAej10e5EJ0Xbqj96GilGrmesN6uIkdTRE+NIIIZCM/oiuz5ED2QXS0LpsSeiXlX2Yvi
	6ifzxVvB53xSoOBZnZRWC3s2+jRvqs+n/TEuWI6iaizpcPSm56rg43WsmuVqcdGzcVZeaC
	VgJgy8ABVQXJ5+ZAo3ZElztGZQLqpTw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769187360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JSHcmTaOgyJ3QuCyEZtrSdPqnVt4EqkAgAHM6oep9TY=;
	b=ybBh15QOSfeNuSWn6ChA6Dk51J4zXNx2M2YGicUZwzygmLN1P8XmJszJ71tCiuM/dfP2E3
	CKw46kHVoQu6+lBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 318BF136AA;
	Fri, 23 Jan 2026 16:56:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QTPACyCoc2m5PQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 16:56:00 +0000
Message-ID: <1d360d08-aceb-4d0e-81ce-4544215603f6@suse.cz>
Date: Fri, 23 Jan 2026 17:55:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 09/10] mm/vma: update vma_assert_locked() to use
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
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <fbaa0ab025c1f345e559df2b1045b223663806ef.1769086312.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <fbaa0ab025c1f345e559df2b1045b223663806ef.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 53FD4100005
X-Stat-Signature: opmo6gcn5dqrcwspro1rp4p48uahm5dd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769187362-681946
X-HE-Meta: U2FsdGVkX1+PM9KC5LuONyTSex1HejvROVcfJka1RWOW/R7uK4ZQMSfl98lfPOExtfL2LJxoN9HMwpINdFt4mGLSVPSkx4vUkPpsg+mgjQo4IBSQPhHplNgX8fgQ7kl9GHTcT8UjCA7phqwFxTIvaqk07kQmKcbzJrFJ0uH0qD4k9FS777VBZlti10XGTdVdDlPvCx9RODkkO5U0iZcDwlaYK/JqxfnS6KGR4yA54wqAVZNQ70v+8wf3QLTOUnukqy84R2NjSCuf4mjtnQ5jYkeDYRRhuxjSqvbYGePcegKequ1ZE4W3LZWo3nBamWYXtFoSZRe9irLxBzHcoSsdQ4lNr0qTIXtTbtBkxRrYaxKOOQ78syQEEPoj5DXP++9dDTrIkddrmmxOKI+qgZuGPC5y5O+2Z/Y7XHPRaZVKFUB1XPDhSgOXWs2+BMlTdURYuRBK0Dadcjs7L/ZbzM34JoR0n/j0q+ndi9YHOcEP7bt9OGbq+J+vW9rnzNmr45wRfryftStpxVH2FX+0dZEWGT7T8kojH1NSpqTOrayfrfhE/opU3U9yMnEwwhXgoODf23EYoh+FTAUDCEdI6sZlLzlEo3NArkTAajs3MToUKzJbiY0ShTkJf0lEFrhHRnccp04CNtjntL2Lk4rr4tXtE1ktWtZh53UtfgYrHJ7z5lcTsk9olLFt4v6a2+hILfDX+Hu4v7wI+COPaeQAFe2snk9m5addTYv7gkhjHJlQUK3kjkgZKF4LbX5d0otOJmonyVBWxPks5vnqpWDb51A6UF4hKcq05KUY5eI8N8aVB+UQOdSCKhEcKYkYw4EgQNpI4nz/8yHlgglDfno8ONIF94xm6fCQMx3ERocmJO9xuPtDILUimDCNjSuNHK5zLtyumAAKFM+BFYyNOer9R086keq30+hF789jzS56uTdyyhHXkbAmfZOJWwB7gjY1Y8DxNKN4Vv/5tWX/AQF2HX0
 YI1gMf+P
 YzaQ5VPAovudoB5JoEfg60+pSuAM0njmFcGEbz40sd3TPjIjaWVSdlM3Gs58wJ7yBojQbP79hJ7YwlHij5xq7m/6XbeQI52lviPa2NVKVIMoY0I6wdqu8qYtzfa8wbDwWFe2rGsefIYJnPC5doHxUZjMoGUbwf001H8KXhdiBg7IaJLvAtdWFV/SesmpLGCE9bqqZMVn59wZ/5DY8RIDKkFFLJzkfeKdSYgZPdO7T9qH9SA5mdXJMH3WkHvJV9NIGNGkitmI03tEDAg5JReg49p0MkekqeWlezbtnIpbPb0XL9j3IgJ04EBgcZO1jP63P6se46uvJ06fRoY6YgioJStFz16itlNv6wEkEtR1QPEANYwdDJt4gnrBJ+wKgSseMB5Z31a8vjZrALBfnlrl4GailtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 14:02, Lorenzo Stoakes wrote:
> +/**
> + * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
> + * lock and is not detached.
> + * @vma: The VMA to assert.
> + */
>  static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
> -	unsigned int mm_lock_seq;
> +	unsigned int refs;
> 
>  	/*
>  	 * See the comment describing the vm_area_struct->vm_refcnt field for
>  	 * details of possible refcnt values.
>  	 */
> -	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
> -		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
> +
> +	/*
> +	 * If read-locked or currently excluding readers, then the VMA is
> +	 * locked.
> +	 */
> +#ifdef CONFIG_LOCKDEP
> +	if (lock_is_held(&vma->vmlock_dep_map))
> +		return;
> +#endif
> +
> +	refs = refcount_read(&vma->vm_refcnt);
> +
> +	/*
> +	 * In this case we're either read-locked, write-locked with temporary
> +	 * readers, or in the midst of excluding readers, all of which means
> +	 * we're locked.
> +	 */
> +	if (refs > 1)
> +		return;
> +
> +	/* It is a bug for the VMA to be detached here. */
> +	VM_BUG_ON_VMA(!refs, vma);
> +

Yeah previously this function was all VM_BUG_ON() but since that's now
frowned upon, can we not do it anymore?
Seem we do have VM_WARN_ON_ONCE_VMA().

> +	/*
> +	 * OK, the VMA has a reference count of 1 which means it is either
> +	 * unlocked and attached or write-locked, so assert that it is
> +	 * write-locked.
> +	 */
> +	vma_assert_write_locked(vma);
>  }
> 
>  static inline bool vma_is_attached(struct vm_area_struct *vma)
> --
> 2.52.0


