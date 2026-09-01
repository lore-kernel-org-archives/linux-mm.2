Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BDDC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 10:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4134C6B00B4; Tue,  1 Sep 2026 06:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBD06B00B7; Tue,  1 Sep 2026 06:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300806B00B8; Tue,  1 Sep 2026 06:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E575A6B00B4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 06:17:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3ED2D802DD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:17:09 +0000 (UTC)
X-FDA: 85164790578.12.86FF38B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 72CD440008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:17:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDGR8P53;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788257827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDWASibxaGJJhiXNV7zhT5m/05R5Tf7kS7Q31f7HJsM=;
	b=A9dNyh5lzEKdJoSTPt3304G4iCPCTONJrz+IOKQEzmsFpywq+h9gv+PskUtH90qRo5Qo4w
	AK3xgQiVLhfMP7Fd303KXO1ph8OEvMR6sMIKMfQmNB979ZQxNS+Hra7424BOKGq4BBIkha
	7YbrH3por4ypX7iU+9J58qNoOBHm/1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788257827;
	b=8AsE55YVHeF6fIItfVv1TdBd4DmQ5nF7+ziM4h7jtDuHLmtcs07T9Nrjc5cKx+qV2lavzY
	kcgPX5z8wJejRkLGFTZvUlduGsDHnDc5GxqXJeECldYzIySSjxSHLGKXzj5eTxgoXE8PCi
	BfebeJCMMm/ZwEFHbEhZPspBR/wO+Ag=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kDGR8P53;
	spf=pass (imf17.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D380C60200;
	Tue,  1 Sep 2026 10:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190D81F000E9;
	Tue,  1 Sep 2026 10:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788257826;
	bh=PDWASibxaGJJhiXNV7zhT5m/05R5Tf7kS7Q31f7HJsM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kDGR8P53xawEBJdeOMODGSJcHWXW9PTRwe4zSvQErRx0xNSPPxmDixKdD7kQv64cf
	 +SPu/Xh+GhaFnkV8gbTgIR+sQ0yl6gyMClPAcCGvkk8BP7vaZCTXTu4in3CN8iwiUI
	 OcUAAlj5xchiqvlqiQ0erXY5DpTTSViTxWEuAAv4eDmcBjLZFC5/CU3KlriFWZH9jw
	 9Eaa/DDy9jIkQ1Oa4HEP9AjMXXtBMv8WwOdn7PjkDafjRFKo7r8wHkFD7htgVnBq/t
	 P4XKi3Q+YY+4+TS+pxW3+tqVHZNWeT0/Kt/ScgU0Ieg9QSUGncB41SjWa58oNc6zAJ
	 Z9Nbl7tSBfWhw==
Message-ID: <23db34a1-ba1b-495d-91ea-18419e0dc8df@kernel.org>
Date: Tue, 1 Sep 2026 12:17:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xkzcae4tjc8rspyihtbk3mtagir1y65i
X-Rspamd-Queue-Id: 72CD440008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788257827-473712
X-HE-Meta: U2FsdGVkX1+iwyJAZuIzD81/P37zO3lz2xqqra8ellcFsxbjlftEqA3d13lC3HBg4OuXzS/i8fghNjrF47kTPz+OkZV0XYW1IX3MzppQB2Q3uIjOARUpJhrC4P62unLG2XAjq4vGVloZR2uKRZW0Sc3hA6lZG8at0CJzVBXBo90bzMqvOlMVPsUw5m/XAAoNwRKiHx57vRNl4cDlN7+VfvR3Zco+T2u5zfeEu89IAMj6GPVRDK18HuVTPjeEJExqtNHK34sEAVAjPY1a5avARCAfPpojhDtlnJdXdSNjsip5+sAF/lnC1RURYlmP+QVUHWk3rA0pNurvC8SH/YXRu7ve0Hi35qfIcnD0x48hz1vNqkD4+qRpmdxDCRg0zafF//+dabOy/LTWp/ty1fIJgryycfw0KjQ1eyztxMe43YVhHXYr92PIE8Vc1dotdEMkAk+OGDjWy9D250CEn4tawd9nqdvXSpJflBD6AJaZEyHSTJmzsBpjrcsiqqhucOSAt2Mx4OVLbxFvx0cE1bqG89/jo85EGR21l7/VWF2XWfifgnzVY885lVUU0+enui0HLvFQvgU8+cfEwboPtlZPQVXPQi1aHIR2fqadaXRtiAlP/6UVLXnnPNIn/MUBJYyJMA8X8N47N3WqfwTRVi3ldjT2SLz2XgkmmqZlvJ/rx6HUtqIyHAJ1p2ZVjoCcYT7zOOdN/H2t0C0RXNyHNeDomH5NCpBGzBN9YJFk48ZCGeOkfjFOFQS1QVEh8lkjr2fjAdyw4ekba/lZsa/RQ4e19rKW9FP9YbnNzG2vk5RmyeZdFgpvFriSGJQia01WWhFV1sH1q8QxQV7Gd4Clw9eba7ksyen3/u7GkD66MtdDJvQsbsMX3r4cljvAnxtJbOnSzA5PP43ieECVUkYQHOn0hAtKjncmnfQbspbU1+Z1NDyb1buSDc2TJAnYUzPVPplHsNl4ooZxo+hMJznmDkr
 OqMkQD/w
 f6uD6znAwBjqNsZMODW0NW08ikrVYn4YvCceYRbSXpKChfribxviwTIngkAQAg6cUKlgMCKEhhM/v/PADQX4fsKPv9cmDYQiNS1ppYeJrqXmdAVL4vFX7s7YbSFXNvow5sLNhg9QlvtNz39cZBVLFhEfsrOeNdCRN2pizBlZz5zhzTZC/L2RKGRDRhuLKU/ZRm8ULi1EE31BrPcC/U8XAT00TZUrfGGAZQzsWLLFqkpo4ANCntbYq5HE/ynoZ4dq0ucEEv7/tjg6VZfBzpIArlneEpfzHy9vj6eqBILOfLBYNQenrXtT6Sf7TBBu+7StL2M2/EwUPwoZPKrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 17:13, Mike Rapoport (Microsoft) wrote:
> Since v7.0 the most used memory allocation function is kzalloc_obj().
> 
> Update hte memory-allocation guide to describe k[mz]alloc_obj() family
> and make kzalloc_obj() the first answer to "How should I allocate
> memory?" question.
> 
> While on it, clarify description of kmalloc() size limitations.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Suggestion below:

> ---
>  Documentation/core-api/memory-allocation.rst | 30 +++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/core-api/memory-allocation.rst b/Documentation/core-api/memory-allocation.rst
> index 0f19dd5243239..8ecfa4d35f4f5 100644
> --- a/Documentation/core-api/memory-allocation.rst
> +++ b/Documentation/core-api/memory-allocation.rst
> @@ -19,6 +19,12 @@ Diversity of the allocation APIs combined with the numerous GFP flags
>  makes the question "How should I allocate memory?" not that easy to
>  answer, although very likely you should use
>  
> +::
> +
> +  kzalloc_obj(<VAR_OR_TYPE>);
> +
> +or
> +
>  ::
>  
>    kzalloc(<size>, GFP_KERNEL);
> @@ -139,10 +145,13 @@ allocate memory for an array, there are kmalloc_array() and kcalloc()
>  helpers. The helpers struct_size(), array_size() and array3_size() can
>  be used to safely calculate object sizes without overflowing.
>  
> -The maximal size of a chunk that can be allocated with `kmalloc` is
> -limited. The actual limit depends on the hardware and the kernel
> -configuration, but it is a good practice to use `kmalloc` for objects
> -smaller than page size.
> +Since 7.0 there are type aware kmalloc-family helpers that let you safely and
> +conveniently allocate a single object or arrays of objects with kzalloc_obj()
> +and kmalloc_obj() and their array versions kzalloc_objs() and
> +kmalloc_objs(). These helpers only need the type of the object that should be
> +allocated and the count of elements in the array for the array versions.
> +
> +As of v7.2, vast majority of the memory allocations use kzalloc_obj().
>  
>  The address of a chunk allocated with `kmalloc` is aligned to at least
>  ARCH_KMALLOC_MINALIGN bytes. For sizes which are a power of two, the
> @@ -154,9 +163,16 @@ Chunks allocated with kmalloc() can be resized with krealloc(). Similarly
>  to kmalloc_array(): a helper for resizing arrays is provided in the form of
>  krealloc_array().
>  
> -For large allocations you can use vmalloc() and vzalloc(), or directly
> -request pages from the page allocator. The memory allocated by `vmalloc`
> -and related functions is not physically contiguous.
> +`kmalloc` always allocates physically contiguous memory and the maximal size of
> +a chunk that can be allocated with `kmalloc` is limited by `MAX_ORDER`, the
> +same limit also applies to the page allocator.

Would it be better to say the maximal size is KMALLOC_MAX_SIZE which is
derived from page allocator's MAX_PAGE_ORDER? (Also `MAX_ORDER` doesn't
exist anymore)

> +Internally, slab allocator differentiates allocations of different orders and
> +delegates larger allocations to the page allocator, but for the users of
> +`kmalloc` family it is entirely transparent.
> +
> +For large allocations that do not require physically contiguous memory you can
> +use vmalloc() and vzalloc() family.
>  
>  If you are not sure whether the allocation size is too large for
>  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
> 


