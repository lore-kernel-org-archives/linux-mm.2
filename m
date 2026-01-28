Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969A7D25B54
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 13:01:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59456B0089; Wed, 28 Jan 2026 08:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC776B008A; Wed, 28 Jan 2026 08:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C94166B008C; Wed, 28 Jan 2026 08:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6C126B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 08:01:48 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78E8F1A0687
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:01:48 +0000 (UTC)
X-FDA: 84381384696.23.2630C4F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 01AA920012
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 13:01:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lfAiaUia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/aYOmMw9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TVgpDQRr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/KvjQTge";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769605306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHgTR5u7+2Ld6JhXFZac6/aalW3XyVnipGQPw5QOKnc=;
	b=8IvbjxzcSt23Q+00tJkORL/wHyulG4tXqI38dvC5qh5esuuF5m6/VfBZWaDxATzqxX8C14
	AjoLPi6sMsGlexL7vXrRNpXZ+6EQgwTulUzcgamju3zhPVlKzkHZmW+zfmiLr7zuVp+Rqe
	3g0QnGiA6c1Y+VBpmEEDhORkXhBZD5c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769605306; a=rsa-sha256;
	cv=none;
	b=BkphAKL6jfe50aqeXOE/o3p79c0q3LeJPYUGXljpm9kglsza+DnXX23wFf22uDXov+EZJY
	fDgnUUEZ450OvTSJ6Wn6fmzdGPoHXhGfBHTUgG9cUNoPoIdFnEV81F/ojQBj8AXNSzuEPJ
	CHqdUHKYI1yl/BpLk7PfMFvaa6UqVDU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lfAiaUia;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/aYOmMw9";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TVgpDQRr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/KvjQTge";
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E514C33BBC;
	Wed, 28 Jan 2026 13:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769605303; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JHgTR5u7+2Ld6JhXFZac6/aalW3XyVnipGQPw5QOKnc=;
	b=lfAiaUiaoV9dna/fbPoPovm7Y8fGHx5CUiYXa2vTjjG9QXJrOTHpmCVRXF1f4qrOyP25tT
	qwTUZl8T+EJriche5cWQgFgUxlbJcLK/qObWctMDDacuBOtcXaggYFj/6P5v0ClT6Z2zYa
	4SQt78gQ5esx7JxvVxljftYQa/9PGdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769605303;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JHgTR5u7+2Ld6JhXFZac6/aalW3XyVnipGQPw5QOKnc=;
	b=/aYOmMw9dXtIWxa9UZT4014X/DE8l3/hPFtV4RKRLqJSnEC5DfWiEJeq6YWgw+/LU6Z0ZO
	dkDOAXm8biZxLOCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769605302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JHgTR5u7+2Ld6JhXFZac6/aalW3XyVnipGQPw5QOKnc=;
	b=TVgpDQRrOuY6Id2At+ZRTw1J6ymPpCquqAKkjXvqEa1RbbPiuocslu7SMLMGmHTjSbObPa
	vrod0bIKgRkg785Fqs8kAAfluGBBWaBLGrAO/ewPcWv8i0DU3aLP+k9PN6RBZe0CLWuJL4
	8TMYm6l/f3wR04scKxCtryXEN0Zq/zc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769605302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JHgTR5u7+2Ld6JhXFZac6/aalW3XyVnipGQPw5QOKnc=;
	b=/KvjQTgeeHpu0gzibXUtjmbvBURSomtUDuo56WndEH2Gd3DSgD61rn6QyaFPzpVIB2ujj4
	rqf2IcQNEz7Kw2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA94E3EA61;
	Wed, 28 Jan 2026 13:01:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OhtXKbYIemmgJwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 28 Jan 2026 13:01:42 +0000
Message-ID: <bae98030-f359-49e7-b294-14aec5a5425e@suse.cz>
Date: Wed, 28 Jan 2026 14:01:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document
 __is_vma_write_locked()
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
 <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz>
 <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
 <CAJuCfpEBHsuGJFAGyXdASpaV_FY0_RBShKZM3QA_9z7ZvAtu6g@mail.gmail.com>
 <425e3040-0522-4af1-a7b9-c9ad04e017e8@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <425e3040-0522-4af1-a7b9-c9ad04e017e8@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 01AA920012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hom8p844hu14sfa61pmeic7guy1npqq8
X-HE-Tag: 1769605305-151037
X-HE-Meta: U2FsdGVkX18Sf7nsNsxjn3daMYjR1P2rV2SOpzOTgGTuYUtgOP3mjZzDFPzqtZusr6u2gGi26AcH7skRh7Rax65dI09sKPRfaYbDH4U2sDM9prnchzn3KhgwgyaOFeTCx7EU6xSAxx8zO60oqRCkE7RQ0V7UHrsq/ISg0PQ8wRlkCD/zpu6dCcZTovCG9uHBT828NQvf02Wq1KmIqubojakTlACGtxEu2cuo7CLjHr75QLY9j91bdq6KVrdlDNy21qcc14YN1s0furhT6NijDaQ1Sn+WIJZM8ZPLrtaiHWF5ClIR4GTCura1rRsAdrHoGYTehdnmNFSQN02La/iXp4U+CLDHj+1hDXHq2rlxmHF0NvkocfJ9jLefmHgH7j8LwN2wUrfvBjULYTXBNoZ1rszWtKUuHKR+zj+Ud8WWq02cRdfJV47v9fxmRBi6hTRNcS3qgiB8W0kLqb2Gzc2pmbFXTIsHNX7mClu3Rvyoe7lTt23jQV/gqeG3/WKtSMMl8/UZpI9b12Py9HiuIwlyI8bVNZunxeagW7eY1JjnGUnnSf/p+kguhZo6BmU1JV7ZXT9NfZBvL9wyp7/kp00c7qh8lvKGKEwXoFV4EFcInJiJqfraOQeuU4omr6LMJtgpUHHUlMYQ+e5jyo7fKI6sf+RliVNEP1oO5Xa3HRd/Bv9CIkREi/meusfK16toxkUA8YeAbnMqgRVGb3rlt6jt8fWCQVQ8mpgGxF5bxPkLeHbSVE9EQUvr2bpcPG9OnL+Ka/kzXK/iOX7BzOMIxVY0XyojeNaSwY/+zhEo2dJBJ0QEKkbeU/o3zR2l6L9Xn4NZjkhbNzRGMC1erMzNxSrIhHJ4VOyIfdKOlubFNXDe9jkQD9oi2bAGmRMDYutaSyRxn1pStDHEC3XpH5Sof+NrX8x3BTLuZuxqbfzN9N6aUIf4Bf+N+Ad4MJO0lXn24DyEjCWIw3J0TXLfYuG+S4q
 gKWh4GOn
 +3nfTli1HLD59WxWwYvDxxW9O4MLUbdEwQOdPq7r375eVNsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/28/26 12:51, Lorenzo Stoakes wrote:
>>
>> >
>> > Thanks!
>> >
>> > >
>> > > Few nits:
>> > >
>> > > > ---
>> > > >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++-----------------
>> > > >  1 file changed, 25 insertions(+), 19 deletions(-)
>> > > >
>> > > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
>> > > > index 678f90080fa6..23bde4bd5a85 100644
>> > > > --- a/include/linux/mmap_lock.h
>> > > > +++ b/include/linux/mmap_lock.h
>> > > > @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_struct *vma)
>> > > >     vma_refcount_put(vma);
>> > > >  }
>> > > >
>> > > > -/* WARNING! Can only be used if mmap_lock is expected to be write-locked */
>> > > > -static inline bool __is_vma_write_locked(struct vm_area_struct *vma, unsigned int *mm_lock_seq)
>> > > > +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
>>
>> This function returns the mm->mm_lock_seq.sequence attribute of mm, so
>> no real commection to VMA. IMO it's better to rename it into
>> __raw_mm_lock_seqnum(const struct mm_struct *mm) and have the callers
>> pass vma->vm_mm.
> 
> Sorry missed these comments.
> 
> We are only ever referencing in terms of VMA's, so I think it makes sense still
> to pass a VMA ptr, even if it just references vma->vm_mm.

FWIW I agree.

> I think the name of the function also makes things pretty clear, given it's
> called essentially 'VMA['s] raw mm seqnum'.
> 
>>
>> > > >  {
>> > > > +   const struct mm_struct *mm = vma->vm_mm;
>> > > > +
>> > > > +   /* We must hold an exclusive write lock for this access to be valid. */
>> > > >     mmap_assert_write_locked(vma->vm_mm);
>>
>> If for some reason you need to keep this function VMA-centric, then in
>> the above line please s/vma->vm_mm/mm
> 
> Ah yeah, maybe if there's a respin? As kinda trivial thing, if that makes sense
> to you!
> 
> Cheers, Lorenzo


