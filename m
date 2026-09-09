Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE1AC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD3E6B0096; Wed,  9 Sep 2026 09:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16E656B0098; Wed,  9 Sep 2026 09:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D766B00AB; Wed,  9 Sep 2026 09:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C42876B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8085C801EA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:44:14 +0000 (UTC)
X-FDA: 85194342828.03.74BCE44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E8E01100002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:44:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4ZfLeGj;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788961452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fyGxRWWGY/QF48JwkFPc6wv4PEQdRhMGY+73An7lRDA=;
	b=SLBLob/GnKaYjeHW/MSWQFDf5PLpObk4Co8/lScTugaqqYFsuhY6OpaztjKDJRu/8elmGz
	5otC6JgS5TNFJ2CVflI0J6pY47878SnVl0xWWb6wgT+UiOPhujlzswN5S5mRD4MmGG2CW3
	SNFA1Q63h5Tr/f2om8rTuZYYJKXO5bk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788961452;
	b=dxn1FCSZq4bZtW6t8PskwwghTysKVDNP5BSpSVgmzflsZzk5EOoymYL27FtRjXONT1riMt
	30zCr5O8Ra0uJN2MXYcSnnzzogXMC0z6PLG5U8z0LC6Pofn744PB8EFQkmDZ1LF4M1z4u/
	ssEP3qNJe8UpcrO6InX9qHLezvZApco=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4ZfLeGj;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7001C6020A;
	Wed,  9 Sep 2026 13:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB7F1F00A3A;
	Wed,  9 Sep 2026 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788961452;
	bh=fyGxRWWGY/QF48JwkFPc6wv4PEQdRhMGY+73An7lRDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D4ZfLeGjXjLDlMxccI5WKcMqoRn8z0Bqgfi0rV7gUl7oT2SmzTJT6btCL9BfeeXTl
	 KiqHLYruo4SHrnOuqlNN5NtdsZmdgmka0pWd7wZVKknvOx+jU3vBnIeA57rFTYK4bi
	 Jn3TMukKTixqersG7kwJH9mHdFztiNO2s2Y2vWXauuIcwbwiiKcaBXsBx3WH0Q2aqY
	 reGzLdTVRlAKTRazN5kQgqAZMRgw5pcdjI5pH7L5hIY9tNj0Qzr2sD1d7C9oPKcJjZ
	 24ml2xc4FYzp+en8rxvGW936mcEc+m9XYZNly3nn4YJm0wnEPYEpTP2bKqYfRl8Cyi
	 0MblVN0gCkk1w==
Date: Wed, 9 Sep 2026 14:44:06 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	pfalcato@suse.de, willy@infradead.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: bypass datarace check
Message-ID: <aqFWqqvUEiie8cYq@gremlin>
References: <20260909115723.528501-1-trintaeoitogc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909115723.528501-1-trintaeoitogc@gmail.com>
X-Stat-Signature: 57ytbu1yr5rt6bf1ts8wa81cat6tz5zy
X-Rspam-User: 
X-Rspamd-Queue-Id: E8E01100002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788961452-223661
X-HE-Meta: U2FsdGVkX1/adjjFAz2bq8qCv43TDZMyGCECzpcBMA96mK3l6c+7rNkoEph+3Ov14fb8Ki3tZOa6xGC1pN7zPG43UAWinl/pgdDOeQ6f6B7H9I5xkF7kB9aF2OVyHhvlp2T2iDoEnX4fNrZQSqX0ZuHfplDerW/jccc7/EDtoGLXxn0kMy6YwnEhUJsuPdcingnNG+94Z0efVuAAXWMf5dCujc5pPBshh6wSNK+og/liipOjHPODmmDYGJbyO6xMtINWQwHClLtuwjCbUyq6xJPZpbNhc0n5Fva+pYKQIzyCNXHtEEk0Yhwc1Ofy5JBVGjWw5S+KS7Y/LO7jW8+5fnINgXS/JgmyIPbJSndjTRf6cvBj13Ym/MyxTHWUYQmUipIw0Bb4arZUxJkmeWktWOH7vWFlkIW5qHQSmL+gh8GaghylXiIiX2vGdkzF1c0h26uJzPZ5N8sxL+yclsU4O0bkErfaB70ecfy8/0pKbrvcBjWgmX5UOb3IQr8uKFGwr8mLMhDQh8cxPH2dZjVGnRq+PRJpMR7ZFPYg1LU3mpn6Soa5YqDRowg9mKn80OKLO1elaNcn72XHzADKoavLyqeqOIib+1diKzyh+jmseYQy6vECF9fwcnAKNZK1XkmEXiNPfVEkZfbae78yvew0UaPMGKKJWCgL3KUwCF1k2/RYhr5vh64mlc5kWjAow52SppxfpwlO/1JBA7ENqbXwwMwbEGaaynYxNd1sve0ily4GsLRnUsNhm2iMVmdthplg9ZBUzB2shftxhcwVFwhM+kb2BJIc7ymx8lyS/m1CRRh3Tbr9e6RopNFcXytuMpcfmzgarLRKZcy16WwSWgEbXnELA9BFk3l6GvwWvJ0R0yFTG3s5w8PZVDjJ4mYawv6WlL5xuH2FD7hJ7AvVkGYFNkoGvZpJbMcsusob7fiPiKAucMC+dMY4Pel2F6FIMNQkVCU+vGAyuT2BVYak2JB
 6G8AGW0+
 kSKaEnHXg6YvMhtW8knBDLUIIM2d9nnqkTt4ZKHLZdt/4URNDJYIOAx7TOJtXZFd85AiE3ZK1jcX6r2wFIM5iHShKsnDXErAHRd+bi80KzQoSwmC6X5fzaDsBcQvbOLYijHQOkIKKgGV4eaKfcDnIg20k3WnYUsdrS+AWEs7NXa+aH2Q+2GggWU6TMhBn8RVk7XC0gukCI839i25HGnP8JZtct5MDuDLd9d4vX+S9+tOcSbnMiJ2wdwkWDdJbILLg1Gcr/NDjaZhTn6OwLWU7lDXDfS0VN82ueLBzJezJP9J9KfhOruSr98dK8XNt/9/IPSrE/HuSHeyRJo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I started review below but honestly this patch is confused in multiple ways
and it's not entirely clear you really understand what's going on here.

It's also basically implementing what we suggested.

So at this point I think it's easier if I send the patch with a:

Reported-by:
Closes:

tag -> you, this patch.

Thanks!

On Wed, Sep 09, 2026 at 08:57:23AM -0300, Guilherme Giacomo Simoes wrote:
> Despiste kcsan point to a possible race condition problem, this is a

Typos  -> Despite, point -> points

> safe race condition due the access memory ordering, since
> spin_lock(&mm->page_table_lock) have ACQUIRE semantics and ensure the
> ordering mapping.

This sentence is a bit confused. Acquire semantics mean absolutely nothing
unless paired with another operation and etc. etc.

>
> Create a new function called vma_is_faulted(), that return a
> data_race(vma->anon_vma) to bypass kcsan

This sentence reads incomplete? Or missing full stop?

>

Needs a:

Suggested-by: Pedro Falcato <pfalcato@suse.de>

Also:

Assisted-by: LLM?

The list below reads very LLM-ish so I have to ask did you use one etc. etc.

https://docs.kernel.org/process/coding-assistants.html

Perhaps given I am suggesting a lot here a:


> Signed-off-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> ---
>  mm/memory.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 6b8280cfc1db..d85d67927400 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3800,6 +3800,25 @@ static inline vm_fault_t vmf_can_call_fault(const struct vm_fault *vmf)
>  	return VM_FAULT_RETRY;
>  }
>
> +/**
> + * vma_is_faulted - check if a vma has been faulted

Would rather 'has @vma been faulted in?'

> + * @vma: the vma to check
> + *
> + * This is a lockless access that may race with __anon_vma_prepare().

This doesn't belong here. In fact it doesn't belong at all IMO.

> + * The race is safe because:

There isn't a race at all it's KCSAN getting confused because it can't prove
that there isn't.

> + * - The fault handler ensures that the mapping of memory is ordered.

What has that got to do with this function?

> + * - If we read NULL, the caller will re-check

Umm, no? This function doesn't force callers to re-check?

> + * - The page_table_lock provides ACQUIRE semantics for memory ordering

I'm not sure how this relates to anything but again this doesn't really belong
here.

Anyway let's drop all of this please.


> + *
> + * Return: true if vma->anon_vma is non-NULL, false otherwise

This is completely breaking the abstraction.

'true if the VMA is faulted in, otherwise false.'

> + */
> +static inline bool vma_is_faulted(const struct vm_area_struct *vma)

Why in memory.c and why inline if it's in a .c file? This belongs in mm.h with other such helpers.

> +{
> +	/* Lockless check - safe because we re-validate under page_table_lock */

You don't need a comment saying accessing a field esp. with data_race() is
lockless, that's implied...

Maybe:

	/* Benign, see __anon_vma_prepare(). */

> +	return data_race(vma->anon_vma);
> +}
> +
> +
>  /**
>   * __vmf_anon_prepare - Prepare to handle an anonymous fault.
>   * @vmf: The vm_fault descriptor passed from the fault handler.
> @@ -3819,8 +3838,7 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	vm_fault_t ret = 0;
> -
> -	if (likely(vma->anon_vma))
> +	if (likely(vma_is_faulted(vma)))
>  		return 0;

There are other places where this check is done and etc.

>  	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
>  		if (!mmap_read_trylock(vma->vm_mm))
> --
> 2.52.0
>

--
Cheers, Lorenzo

