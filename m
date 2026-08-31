Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C17C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90C96B0092; Mon, 31 Aug 2026 13:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B414E6B0095; Mon, 31 Aug 2026 13:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A089A6B0096; Mon, 31 Aug 2026 13:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8286B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:20:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7861801D3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:20:26 +0000 (UTC)
X-FDA: 85162228452.14.2110A52
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6134240003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:20:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e3qOWSeQ;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788196824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQUHwKk0U77GfMYQ/2B5fWOyPHpUKlicsOQQN5flvaI=;
	b=IrnbJ/QsFkHSt3Bmamv2jV8tkLWgWiUPZXDSyZZES1KwO2s04a9sVT4AtB1MIIuTRrfp5N
	lQ1xy3QifQwxHfoz8EVekpwiiwVvFedv1xC03/CoHehsBy5+HNscPz5XgYWxwbE/7o0e/b
	IZTh2LZXgTocWLnz/AtCpRu1of/Y51s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788196824;
	b=SLn8vFkqHoUm1En+abcpiNEb1QgZUSQU5qqAZVH5NSx6yoZvJbCfg6mxOsxrmzUhkuhMXX
	uUAiGDl9ZwlIpHr3R13t+JsxZUY0YRYbHCKVgezkicaBb3b8x+fABISA4c+u49VamTTwzh
	aMyrInNP7OUmoXmWc91WyAclBX/5ZCs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e3qOWSeQ;
	spf=pass (imf17.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=pQUHwKk0U77GfMYQ/2B5fWOyPHpUKlicsOQQN5flvaI=; b=e3qOWSeQPOB4I33XJBkgSPh4V0
	Hdtl6j8ja41PVzOkvoVC2RB8LJvnFAkXaSAHdcDAGNj3ca3Uu5aec1OSyU5U9QqvHh9nzHGCdQqHc
	MeejhveBfSkwi+6C90XWAyNrfklIhaWlIer5V+uE/Ng2l0pMK6o6cEwnCCwHsF2wJL2vfOiSPu3NB
	4VHGV0yAlGQvPYZMPDhajMcKwv6fWZyheCYt+98hKkOcmqcuTAS4uWE8jIlKPk53DRUW2dzq4w6Rl
	Wtrkh7W6jrd1dTPX99tuYszUAh7lTqlB3mBEuOfnIdLE6N1dhrC7QlOmWbbfgoapJ95GzcCNGzEL8
	PjAYmU0A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x15gD-0000000A9zs-2le5;
	Mon, 31 Aug 2026 17:20:21 +0000
Message-ID: <de391463-3e2d-488e-bb9d-94fd2cf8b5bb@infradead.org>
Date: Mon, 31 Aug 2026 10:20:20 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add
 k[mz]alloc_obj() and clarify kmalloc
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260831-docs-memalloc-guide-v1-0-547718c274c1@kernel.org>
 <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6134240003
X-Stat-Signature: jy3xjatj38hchso3axgar5degc4whc39
X-HE-Tag: 1788196824-372447
X-HE-Meta: U2FsdGVkX18T+l6oNDkNkPT8ax0YtjdoryfH/G+xZFSldxymIyO+p8dIEOiuthwQgLRYaePzbELNSipno53h1qQK+XboCmw5f+pyY99YyKyDik1WnGedZz7j7a4xlQb16Y90OhXWko5E4Xg0FDmdq8W/NKdELn4Xco4h9bImxCPv0BU+4ZJJK60CQ0d4LvEqKNrGe7Tz9mSxrXOFZ+zITOCmWSHElwEPSim+hj1q7Yl0oBqITCDg8d+5fG9k94x2v6jgL3oIDAMyxhSVZm9E+LiTBmGgK53OOwzK7WNLDHAV3VJnMcv/gK9s+oB0qeu51OQLiyBkFvx/ZE3+OEyhxmiXzP0lFM+sKl3QndyZbobZlaKZdZWWH41DDUT6YauwF0MUpiZQPjywx4Dby/acdVpykAJiSmZXwIMJwRFq1X/igEVvjPA9jH93LXQqdL5fwQ6XP5KCJsK1zKC/6GKUMiek801cxxJ0Jl3HbYg3cdzdtpQRTVGf3Grw71+VA7itFtkPs3EfQPAEFIi5ihr6ux8k6aKoR7Xp0sqx/GbTio51/59NXlRzwb+Acb6ORaic24/HJwOnVEalABlPQcIN/AuaIgzuJptRUIHtPXebjgKkdAHBBOma0xkYgwX6iMw/Dl/fwCCESRQ1rTXrT2S14jZWFXnTWGZ8MVvYkYD4kdIEh5fbK1U2gS8uu4NZZPkZRncwuG+kj4BcRmGTcqUet05dwvZR+X9MYMHN/A8oB+z+UUd3gNltKag3tJlqhpl/C+wHrj+rbvPZ15eLmOf6Y119RN482U4iBlFCAUOYBl4owzuz9JnjRt9eBpYe4DHpuoQvZ3L+prY1QXBy3lqYkrd+wy2Wu17abyyfSCtTNLT+j+zf1aH3zYoG8Eg1sSm8+niS5/wXNsp9ozL0FkI5inUPcxlJZ2M6J7uAjWTkmNED45YbB1WfVuB6/QMSVDbapG3TZdAOgodOdV2LagX
 QemNK6Ge
 Ik2kzbMtx4u1qPy/aOhNfibiuXubGvqNu8oXX2oX+IujTTxt5JIMCRBP2q7rvx7Dnvp/IdvnS2E+x6f6Vnr4m4RTO9of1MoNj1NURie7WUiLavZih/q7sAfZJXycGxc+pdi1CJd45PAxh/NWDmxpAOx9atSQApqfSWY0P+LU8Pu9py4fe8gvV8VNSaqOT45wWpLv2m6KA/t4r6ausf21OqoTJu9+flSD8jGU09Q8s/ZP9gUHIkt3JlTAyyq66ThUvntMSH5p3OlwDbe5eMb2WBBeyc45jBzaUikllWkqBd63iHWt83jI4ms406hZ4b8TfXtxD77awso84lX7pkxnyTFUmP3ZbozUdj60XnWEMOBvTZfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/26 8:13 AM, Mike Rapoport (Microsoft) wrote:
> Since v7.0 the most used memory allocation function is kzalloc_obj().
> 
> Update hte memory-allocation guide to describe k[mz]alloc_obj() family
> and make kzalloc_obj() the first answer to "How should I allocate
> memory?" question.
> 
> While on it, clarify description of kmalloc() size limitations.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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

                                                              `MAX_ORDER`; the

> +same limit also applies to the page allocator.
> +
> +Internally, slab allocator differentiates allocations of different orders and

               the slab allocator
?

> +delegates larger allocations to the page allocator, but for the users of
> +`kmalloc` family it is entirely transparent.
> +
> +For large allocations that do not require physically contiguous memory you can
> +use vmalloc() and vzalloc() family.
>  
>  If you are not sure whether the allocation size is too large for
>  `kmalloc`, it is possible to use kvmalloc() and its derivatives. It will
> 

-- 
~Randy


