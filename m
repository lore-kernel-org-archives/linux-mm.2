Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 719B8CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 593A76B008A; Wed, 20 May 2026 04:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56AF26B008C; Wed, 20 May 2026 04:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A87C6B0092; Wed, 20 May 2026 04:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3992A6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:33:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBD114022D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:33:27 +0000 (UTC)
X-FDA: 84787134054.09.24155FB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 83269160007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:33:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="LKcU7SO/";
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779266006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vO2N/YgEg5E8m+kngBVqb9XWRRPBDPVUkeSxM7SOUM=;
	b=0CQ5Fm8TPlZvvzAXMMJmTVzCqvaboMOQjowaa2tqwETSnU8UN9ZgzOETpn+57k7OI+V0iF
	T+utljJY7acMZq2fhYIy1p31z0vi8Bodwi+/+eQ3/HpcHvPCWtu7ZCRdrvIEVNa0z5xKJX
	BOzk/SE05gm5lI2ZEWII+fBchCZlNVA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="LKcU7SO/";
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779266006; a=rsa-sha256;
	cv=none;
	b=dXVDLyueOfxEqen2ppPcDreOF4KH7n0iCWzmb4vOYOZZef6VcN97RZdJXw7J7LB9fi83RD
	kfr3++l7cYS18hiV4js0RzMbE9/9py/WGJD1rBark2KLKk8FAIkOJze+z2uVVXOr4TYuEy
	N5a+xV2WFUSR9HF121Cp28HpaWGILc4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E24B0266C;
	Wed, 20 May 2026 01:33:18 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C7D83F85F;
	Wed, 20 May 2026 01:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779266004; bh=vGEPRPX6ZX8Y66ynLlt6pqISPcc9o7/7NkKmvEgRWyo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=LKcU7SO/0AajG3cfXHPYD10MOQho8VLzIRr6D8DbNr7NDZ92cxoMoPi/hzxcUkdO6
	 +wWWBmwtTvVA6+tJSxw+rCk5lMFW8z4Mp9KGX+RsGKHxLy5KJ7deSEdt3zj8UKPa8Z
	 Zm3LCXdQH0kxlysuJWU9MJ4WL7rAPiZDqYiVOMsU=
Message-ID: <32fd8890-7c06-4a2d-9b8d-691a2d6b44aa@arm.com>
Date: Wed, 20 May 2026 14:03:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] kasan: avoid re-poisoning tag-based kmalloc redzones
From: Dev Jain <dev.jain@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, harry@kernel.org, ryabinin.a.a@gmail.com
Cc: surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, kasan-dev@googlegroups.com,
 anshuman.khandual@arm.com, catalin.marinas@arm.com
References: <20260513105734.3380544-1-dev.jain@arm.com>
 <20260513105734.3380544-3-dev.jain@arm.com>
 <14da7ffe-1332-45d0-86d6-e9d9ae0a4fe0@arm.com>
 <2609d691-5e70-4baa-8e58-99f5ea708c6a@arm.com>
 <4061d696-1567-41fe-9ff9-af408ca6d4bd@arm.com>
Content-Language: en-US
In-Reply-To: <4061d696-1567-41fe-9ff9-af408ca6d4bd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83269160007
X-Stat-Signature: sdmgt3ndmqqi9mwnrbs5ryqocric8imr
X-HE-Tag: 1779266005-608521
X-HE-Meta: U2FsdGVkX19+AkwzkkGVBWZJ6Ne1hs5OnO2ncQX5fkWyrLZzRfClM2dSjjUPqsOCPfwBC6u/vX7+AydmYOVXkCtTJA/Adn84xs5gIXnfZG9vVksV0lskIJgFkxizOAJdLs7r3oDvJHo/HDK+TVTtiLQZ+yKDXFQ7A1TGPhTaP77ewQUFU8PaGfxN2NvF2vYlCsRPlHOYe2bj7Q8Ja9+Q9WqIs1IkwFjU6UezRJ6i6xhctfw2Y0mBkPEcOZx4s0VljBxlBF0p6Zb5/yEamm+RPO05iL0fVXX0DC6QBPkhA75OlWm/On58y8FzNUDYvHuBntfjLr9YG+M53m2kZakfv9BaIaaXsskjn6Y/EjhTdBDxNZDM3uW/wNysIELCxMfn4lWkqz8nL1n6NYy4X9/Q64RqszSm/PMdtPbaJxeXDzqS3y8/bIOAcjO/5mbn7xgMuYeKIznF8hurfQm0ujKGpNpW42OD0rlgsZgivEvvRLXfzsjWvNwtlhTzxgPZHA2m+iazVfmTeFsZFR/fsnfUbptc133OyLNAksVDZCde1ThnGpZzLHmnp2eQGMR4IkKDdRSB5ZV9Y+NVykGPZGeFvGbMoffHBiMVEzri+a+b3D1Rp4PC/hu2RCXDLCmEiH1vOHTtNBnmNMJujU97uXzfLyAyaCg5arAVFKoxmeQXd49I46piziczuhJT+HjIfYE08XpBf3TeXebEHf6snXYLwMtMNh56o2Rpvnx8R55VoD84p1UIiRdkH0A6M8ObK1sfSXakvJCuJpEXr5abb/FU1oiiuIVEkAgNPUxWFXql8ZJSI2pu3t8l+mTflDYs6Vylsd60AwczbOjt4WH9hv+CVr6ytvtULPnhCxg3AUQ+rjBLlSUqeqB7cp7LzkRjBz5x691f62hEvA8BJVqCM05FYp39UbhI6vueKUkWVwdJwFmRm65wG4pyRj6U1BlN576oIhM730K5XXGh8ktA4mn
 38RQ/iNc
 mpoRE5ulyyIqp3pBQ5mvzIqgFT5U8CIJmieA6+wHWLrMF0SW+9Uf8KmFmHVVtJWSXhRjGWoBexB9N+RzxtbuEsf4K3DTb9aYLlXlbVhXGmQ/I3b7348nOyDZR2U90fLP4y9ucZHhfahbXt/X616tQ79Om7UvGti5MgIDiiZIkt5Ev02k4R3wBEyJY/Q1rYkXy3A368nHWTxd+Cg8WgT+gRFy1bQrzJuq58Twj4daC5bdJ8cckUxvYQlwcuKrSjwx4RvRxaE2h1BbaCP51+P6uNYp5V+z/wYhwPHcYshT4FCzYKdA9pPhPosfWEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> I got the problem now. The problem is that krealloc() does not know what was the
> old allocation size.
> 
> So only talking about HW tags, can't we simply do the following. We can use
> HW tags integrated init to initialize only the part we want to unpoison.
> 
> 
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index b7d05c2a6d93d..c424be3cd02bb 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -474,7 +474,7 @@ void * __must_check __kasan_krealloc(const void *object, size_t size, gfp_t flag
>  	 * Part of it might already have been unpoisoned, but it's unknown
>  	 * how big that part is.
>  	 */
> -	kasan_unpoison(object, size, false);
> +	kasan_unpoison(object, size, want_init_on_alloc(flags));
> 
>  	slab = virt_to_slab(object);
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 0baa906f39ab8..62ee59fc389d8 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6686,7 +6686,7 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
>  		goto alloc_new;
> 
>  	/* Zero out spare memory. */
> -	if (want_init_on_alloc(flags)) {
> +	if (want_init_on_alloc(flags) && !kasan_has_integrated_init()) {
>  		kasan_disable_current();
>  		if (orig_size && orig_size < new_size)
>  			memset(kasan_reset_tag(p) + orig_size, 0, new_size - orig_size);


Okay, this would overwrite the data which we still need.


> 
> 
> 
>>
>

