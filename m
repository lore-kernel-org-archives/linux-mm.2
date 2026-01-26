Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FFECF65E2
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218036B0089; Mon, 26 Jan 2026 06:30:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5DA6B008C; Mon, 26 Jan 2026 06:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A866B0092; Mon, 26 Jan 2026 06:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E9ED56B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:30:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C3BF1602BD
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:30:09 +0000 (UTC)
X-FDA: 84373896138.02.C173715
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 16FD58000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:30:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jEr4glGR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TQHAVaVP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jEr4glGR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TQHAVaVP;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769427007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMXsNVIbJcRWNnmTLehkbJwWT1v6LVL2CqMeFT6xWo4=;
	b=E9wfLEgSqfgvGU6Ced2Q0d7+TI/hL+SmY4kzxb6XfDz5tlEQ+7PdrghmtWtVTZ4Nqj6+R/
	LfVd3abqwwJfTMuHWEbi2EM+CX+dFl8GzuX2DL5oC82CXHb22q23/xvkRcquZ9Nv7qT62d
	G7CZKdMIMB2v4/zyKIy3+M1XQ13GgZw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jEr4glGR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TQHAVaVP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jEr4glGR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TQHAVaVP;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769427007; a=rsa-sha256;
	cv=none;
	b=q5NUts3g9V1j9zgB2o0bHKHWJTHY5hmPX6gNIonJ3nUNUTKiW7ucv4moXDW/04QcyaIIOy
	D6sLP3beSF0EnHpN47QoVWjE5bO055jixfc7pqix2OZYT/YJR1qvla47TAA7LtXxKSPmZM
	V5La4yh7r+izMtyaXXbkh+HoNYt4FFg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72C2B33783;
	Mon, 26 Jan 2026 11:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769427005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMXsNVIbJcRWNnmTLehkbJwWT1v6LVL2CqMeFT6xWo4=;
	b=jEr4glGRQekbTWtRE7HCbPDfTIauKsguh4ls0lNX1lM8wY4zLR/QdDqLYX5yt5bL4Nm+SI
	BKiG0qf0276P3P0Rm1xG3RuOCMC682yt+msU2/cUrvdg/JI40EJbQlxyWNoLMl1Qj9v3Bz
	vqwTu2Ey8Az0sKWVS8JbVneQ4pigVL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769427005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMXsNVIbJcRWNnmTLehkbJwWT1v6LVL2CqMeFT6xWo4=;
	b=TQHAVaVP5iyx4qmsY85erek0KuQs1wJC1VTfVQcIJu/xU4r1sr/IvZbliNimm4Cs1NsL/F
	B4fyYlKf4OAzLEBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769427005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMXsNVIbJcRWNnmTLehkbJwWT1v6LVL2CqMeFT6xWo4=;
	b=jEr4glGRQekbTWtRE7HCbPDfTIauKsguh4ls0lNX1lM8wY4zLR/QdDqLYX5yt5bL4Nm+SI
	BKiG0qf0276P3P0Rm1xG3RuOCMC682yt+msU2/cUrvdg/JI40EJbQlxyWNoLMl1Qj9v3Bz
	vqwTu2Ey8Az0sKWVS8JbVneQ4pigVL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769427005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=rMXsNVIbJcRWNnmTLehkbJwWT1v6LVL2CqMeFT6xWo4=;
	b=TQHAVaVP5iyx4qmsY85erek0KuQs1wJC1VTfVQcIJu/xU4r1sr/IvZbliNimm4Cs1NsL/F
	B4fyYlKf4OAzLEBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44C42139E9;
	Mon, 26 Jan 2026 11:30:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MgNlED1Qd2n7VwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 26 Jan 2026 11:30:05 +0000
Message-ID: <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz>
Date: Mon, 26 Jan 2026 12:30:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document
 __is_vma_write_locked()
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
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16FD58000D
X-Stat-Signature: jfrtgqka8uw7yqq1rw9xiuce6xxpw9xj
X-Rspam-User: 
X-HE-Tag: 1769427006-925606
X-HE-Meta: U2FsdGVkX1/6Db8oGnbEMJsYLN+MExj9qVvRGGqbYN9lmF+geOpSqmeKkj/aJ4LsbeeaXfRfLNsYZY9toK+x/Nw0vMNNAP61ofypx8SRHi62t0cwunynw/kkfawI3MITnAktJAFLflRlYatnVGI8TJMMror8zfTP8d1QYRpclvw+hTlPh6IKXGdJ4MqCMPa/cnemKi7118yd4SOaAaV5+IE0/lzAt4fSn/iYMC7XFOXkK8lczwmmcOWU4fRG+cP3HOK3SUfYay9pyfyfXUolECQvplEDP6F/Q1JTUSK5H/RyXDj2a0MovSzNWVq2qEGi9I2PULjYLKHscGwF8nx2lmJ1xXcMXBVkn9pExcgJtdE1fBvBrh7vJ8NtmLx3dbNykD2oAcLNcbDxh0YvWnCi41rT1s3KhtQfCZMAjyIs3W7PmrRcNCRU3VyTLGvCbvjzFRDCTCHVfwmTuoPL07e3gb8y9Enx7tjpvUXWazQfGdg/APk8QVL9eKF2nOp+g+25bCgiu5ckYk4AmqhjOo8gjOuFaqX8Ktg6F4UU7LZO+cEbE8BT/xC64TbeQPuM0LBZyyMF+p6lC2XohErcoeNjrjCcAqdIz42BjMpIDMV5vzG6j2f04SC1lfbuMfRQn4vGMBLxErOniU9T4UOlj2E3Rx4GaVF5VC+Y+fMjzkAWz/1OdUKkxcyg/LwxY1s+JmP2ddtzTDWLoRqM3+n131/ReFyi3P1CmA9sh0NiDwlVmMZq5DGnmDGk2gL7v6uWOr7Oa4Yl5immXHgnplK6edd3flCLI2jBIq3p1EomRJaAY4r62BrI+LqTwZIJZbPUm4ZD4U7SvCLDIuWrPH0MSAGZWkBSmqyqI5frSjIH1Qp0847Xk0tHLI/fxg6SDBa8ga+da8KToki/8tY9Y0bSlQmXhSH824i/zPOccmwWoJKHApo4i1uX+PKYQOBn60/LUvKYYl8yoaZ83acpW9n5u2K
 DNRPkaHG
 zGmvJ5uKCeAdD7YpOizE0+SVHXvqz76onLNA4jrQkRWVwOvMzKpjNJljJbZo+GLI7gFVMWHWphu+gJLnQToYRytmKXff+er+igd6vw93SR6aQhyxAVXBnLSdczQXob7q9N8+ziRP6Txl8WlmGIIWOwTUGJCNcI/scEJc/BFq3k2dAD3VyRqvDbmeraibLZ+7tPZRoxPLd1JULENfzP/DmmOMyzuamfTRNomQCAcNXa4QFxyjiHpmxlNlbft4O29JTmoDYAQtr9SccaiYakHUGZGXvUGaNaGFADjgHGi69fL+2whQ4m8HPq9eyp9kbVYgUPy620jseIX1/bGIeJThy3VXD79pXeDmS2blAFyGmZPX1o/9vszYYZfvKBoIAGzAKoHgodawrWuTpSn8jCdfnFk3/6k9tmEH04Y0myyYeX03iwa8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/23/26 21:12, Lorenzo Stoakes wrote:
> We don't actually need to return an output parameter providing mm sequence
> number, rather we can separate that out into another function -
> __vma_raw_mm_seqnum() - and have any callers which need to obtain that
> invoke that instead.
> 
> The access to the raw sequence number requires that we hold the exclusive
> mmap lock such that we know we can't race vma_end_write_all(), so move the
> assert to __vma_raw_mm_seqnum() to make this requirement clear.
> 
> Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
> VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not invoke
> oopses when we can avoid it.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Few nits:

> ---
>  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++-----------------
>  1 file changed, 25 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 678f90080fa6..23bde4bd5a85 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>  	vma_refcount_put(vma);
>  }
>  
> -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
> -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
> +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
>  {
> +	const struct mm_struct *mm = vma->vm_mm;
> +
> +	/* We must hold an exclusive write lock for this access to be valid. */
>  	mmap_assert_write_locked(vma->vm_mm);
> +	return mm->mm_lock_seq.sequence;
> +}
>  
> +/*
> + * Determine whether a VMA is write-locked. Must be invoked ONLY if the mmap
> + * write lock is held.
> + *
> + * Returns true if write-locked, otherwise false.
> + *
> + * Note that mm_lock_seq is updated only if the VMA is NOT write-locked.

This line is no longer applicable.

> + */
> +static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
> +{
>  	/*
>  	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
>  	 * mm->mm_lock_seq can't be concurrently modified.
>  	 */
> -	*mm_lock_seq = vma->vm_mm->mm_lock_seq.sequence;
> -	return (vma->vm_lock_seq == *mm_lock_seq);
> +	return vma->vm_lock_seq == __vma_raw_mm_seqnum(vma);
>  }
>  
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
> @@ -281,12 +294,10 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
>   */
>  static inline void vma_start_write(struct vm_area_struct *vma)
>  {
> -	unsigned int mm_lock_seq;
> -
> -	if (__is_vma_write_locked(vma, &mm_lock_seq))
> +	if (__is_vma_write_locked(vma))
>  		return;
>  
> -	__vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> +	__vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPTIBLE);

At this point I think __vma_start_write() could just perform
__vma_raw_mm_seqnum() itself and we can remove the param.
It could possibly make the inline code smaller.


