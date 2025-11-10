Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21D1CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46CED8E0035; Mon, 10 Nov 2025 10:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C968E0033; Mon, 10 Nov 2025 10:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4CA8E0035; Mon, 10 Nov 2025 10:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA228E0033
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:51:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9529C0182
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:51:31 +0000 (UTC)
X-FDA: 84095137182.27.E656B22
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 622AAC0017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:51:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KHGEHoKm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hFY/7tkY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KHGEHoKm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hFY/7tkY";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E1xGuYFXeq4wBXS5RbbG9hVQUEgFzhzN4Y+tuhwK4Hk=;
	b=vCOuPncCJSmlc/0yVv/US00MLB8V5wbcdlkaLxu1dHVoXDziyHHPeaixa7XGfJ6KhTMqie
	S6iI7V5Yp/EJ62x93ScEbSzkc5uuYFn8cWztb5xvxJqydqa/1/z/Ij7R0XQM6Xwb0Cc1vf
	oaD3whM7his/R0GvUXBsPT8OOrwdLgg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KHGEHoKm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hFY/7tkY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KHGEHoKm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="hFY/7tkY";
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789889; a=rsa-sha256;
	cv=none;
	b=d7FZIadLhjNjucXBfmyUqdh3enxNH9OpswrQd7vBkwZZMqD4+gPUGZSNST2EF+ejXijfaA
	BKVvWCn51GC7Zq6DDwonZ35DS0fGCEGLd9pERxSjCY/2nOT0O8t/MvYdawllPEtCK7IeX2
	rWMfZDobiB2MYupi2iOl0ATVYY4L4h8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A9521FF89;
	Mon, 10 Nov 2025 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762789887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1xGuYFXeq4wBXS5RbbG9hVQUEgFzhzN4Y+tuhwK4Hk=;
	b=KHGEHoKmSNIeawnv9BSS7Wuq12+rxdviaKc3/MkzLJwQs+lecF6UpPhcL2UUFdbMnxKB61
	mcq3GjYPvL0z9HP5MSD8zZKpgVnjweLd76//wdi40sQhI9HpYNlAeLmK8cqmQduJ2IkhKm
	cLe6LSr63bbDwnQBEhQ92FP/WueI1Qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762789887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1xGuYFXeq4wBXS5RbbG9hVQUEgFzhzN4Y+tuhwK4Hk=;
	b=hFY/7tkYSJkZupijhLdaXwAia/ra/uW7fqiD3fqN51tETN1pJaufwHVLhJm3YZ+/TaY0vp
	z0Ri44Q+XnGDeZDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762789887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1xGuYFXeq4wBXS5RbbG9hVQUEgFzhzN4Y+tuhwK4Hk=;
	b=KHGEHoKmSNIeawnv9BSS7Wuq12+rxdviaKc3/MkzLJwQs+lecF6UpPhcL2UUFdbMnxKB61
	mcq3GjYPvL0z9HP5MSD8zZKpgVnjweLd76//wdi40sQhI9HpYNlAeLmK8cqmQduJ2IkhKm
	cLe6LSr63bbDwnQBEhQ92FP/WueI1Qk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762789887;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=E1xGuYFXeq4wBXS5RbbG9hVQUEgFzhzN4Y+tuhwK4Hk=;
	b=hFY/7tkYSJkZupijhLdaXwAia/ra/uW7fqiD3fqN51tETN1pJaufwHVLhJm3YZ+/TaY0vp
	z0Ri44Q+XnGDeZDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AB0914488;
	Mon, 10 Nov 2025 15:51:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MzPiFP8JEmnZYQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 10 Nov 2025 15:51:27 +0000
Message-ID: <945fbe45-1ee7-4108-b01a-a8d2b0bb9cfe@suse.cz>
Date: Mon, 10 Nov 2025 16:51:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/8] mm: add atomic VMA flags and set VM_MAYBE_GUARD as
 such
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
 <cda9d4c073d773ef6c2cf2939d66cf80544cff40.1762531708.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cda9d4c073d773ef6c2cf2939d66cf80544cff40.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 622AAC0017
X-Stat-Signature: 6jsqbymitdb7d418pcqskhsd7tmiw87s
X-Rspam-User: 
X-HE-Tag: 1762789889-330738
X-HE-Meta: U2FsdGVkX1+UgrzunlZvPOm/S5ZLR2dEmiQnqe/RaoeFvdpJgP2N+l9Jza4QkRWR8Pt4F4dgA8fNzdmO/htj0kDDzNOVBfbDOEETiZfCYuZTG9UfzZITD5Adj1kQKO+aFzXb+6kafIT3lhqIy5e7wZ4q35r3ueIffsAJBLdMU+u5ZYB5Gr7BJFMp5zELT1AWzMnpj6XSuUNIzMUKK3tN1iTVDf43vX+j5xGOJpE0rj5ewLnq7IyE3ZOZ1CTjraeRZQpd1OJ6BiCrLA7LN9OHC/M57CCDTcPMjY9Bilu59rlARQS4XZcOaUE69DJBhgpZ2PEuWdjnWKC81nRdl2n80aX+pTAPZ1O96XlEORNwZn6Ff/z4sPP+DgQn1Vpa+p9NbVsU5ySukXWur9Nk4uyIuHdvjAw/yGpMK1uh0CWh8b5ke5Hecb46gqgPdJdRnRAa9K0kbyQcl02Q5uY4i6vQIpyjteIS2+1kTG0YQD57C6OQiNvQkdkwaRSwIxHf/jEWsEv8bAqq3nddlicrDFbVh0EwLz8gtk9GbPFLelA2qq07lJdrCAzv4DXUtU6Sl9vlE6p9Q1/gnLaeceg0jpmcsR5yO3jMlN7jT0F/bUM9z2w64Oc5fpWFstgwwvvV1lhMfrzNSjUADc7aUi5MUkpOiJDcrRqNe5iltSP9o4umUGEGl4YkeX0adfiejtZrUqjKoL6c4LciCwv/hZnh00yqZUbzaqVcsSqRhrCXtkYOlFylGQliUWMBWrLgtrJtKI9tiwpVrRGWrp39XzRH7B+fagqHpqrtl7YJgIq92Rdx3Gz1dz2S+KUT7Zn/3pQfCZwGAslLqGDn2IuLR5EUTptHk4IiccKT+FlPsQf4kp/Q0mAUP1xtSk1orB0lq3UTfzn+q27Z1aSVfO/vsfGsQcbEcLoGUBDVknffgCEBCpDHh92wHtypDEHXjfAn80bZgwsqeBkDEhljJtQEfh+O45u
 6lmaMygF
 C5o2WudnWv/qyAjFATlMFfb0z/+cmkvaWlh/BkLdpMLIYJYMpBec16cY887EcdjnqBuQdQTh3TNncGU672ZyqUOWNvcoLIxEbJJ+d24UQow6RXziWyqXJaGIBY7arhA/7EH8mrGYq6ZfAZ0XvHsGzxK2O4VRmf360OcmaLLWiNsnw26nAizY2o/27TZPLplUPxqTFJFWwJBdXv4br6C05BThVvpoM9sg8GNZJt+qFKKI7/m+Us9VURXVdTf60iS44LnsepO5SP4B5OkO56zgUWKygXprho5JR6QaYbciTNfIV+fxgwm9bsPq3FTQIAbYiBHi62jnz5cE0cCRX6N45wSwse0ybHz5up0J+16DsdbhKXQxA9OH6+mkkZDiw4aQ9+O/CAVbR3Vd3PPA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/7/25 17:11, Lorenzo Stoakes wrote:
> This patch adds the ability to atomically set VMA flags with only the mmap
> read/VMA read lock held.
> 
> As this could be hugely problematic for VMA flags in general given that all
> other accesses are non-atomic and serialised by the mmap/VMA locks, we
> implement this with a strict allow-list - that is, only designated flags
> are allowed to do this.
> 
> We make VM_MAYBE_GUARD one of these flags.
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mm.h | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 2a5516bff75a..699566c21ff7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -518,6 +518,9 @@ extern unsigned int kobjsize(const void *objp);
>  /* This mask represents all the VMA flag bits used by mlock */
>  #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
>  
> +/* These flags can be updated atomically via VMA/mmap read lock. */
> +#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
> +
>  /* Arch-specific flags to clear when updating VM flags on protection change */
>  #ifndef VM_ARCH_CLEAR
>  # define VM_ARCH_CLEAR	VM_NONE
> @@ -860,6 +863,45 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
>  	__vm_flags_mod(vma, set, clear);
>  }
>  
> +static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
> +				       int bit)
> +{
> +	const vm_flags_t mask = BIT(bit);
> +
> +	/* Only specific flags are permitted */
> +	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
> + * valid flags are allowed to do this.
> + */
> +static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
> +{
> +	/* mmap read lock/VMA read lock must be held. */
> +	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
> +		vma_assert_locked(vma);
> +
> +	if (__vma_flag_atomic_valid(vma, bit))
> +		set_bit(bit, &vma->__vm_flags);
> +}
> +
> +/*
> + * Test for VMA flag atomically. Requires no locks. Only specific valid flags
> + * are allowed to do this.
> + *
> + * This is necessarily racey, so callers must ensure that serialisation is
> + * achieved through some other means, or that races are permissible.
> + */
> +static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
> +{
> +	if (__vma_flag_atomic_valid(vma, bit))
> +		return test_bit(bit, &vma->__vm_flags);
> +}

Hm clang is unhappy here.

./include/linux/mm.h:932:1: error: non-void function does not return a value in all control paths [-Werror,-Wreturn-type]
  932 | }
      | ^
1 error generated.

I don't have CONFIG_WERROR enabled though, so not sure why it's not just a
warning, as the function is unused until patch 5/8 which adds a "return
false" here. So it's just a potential bisection annoyance with clang.

Andrew could you move that hunk from to this patch? Thanks.

> +
>  static inline void vma_set_anonymous(struct vm_area_struct *vma)
>  {
>  	vma->vm_ops = NULL;


