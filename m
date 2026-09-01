Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52420C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2327B6B00A5; Mon, 31 Aug 2026 23:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3626B00AA; Mon, 31 Aug 2026 23:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA176B00AB; Mon, 31 Aug 2026 23:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D88986B00A5
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:39:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 53CE28028E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:39:54 +0000 (UTC)
X-FDA: 85163789508.06.869E18B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BFD1F160002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:39:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1ZOcW+G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788233992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AndJ4eRb4pdKGxDByf2P4c70B3XEzx3uFUPqOt3vFjY=;
	b=kgL42EnN5zL8Gu6uq8OWc09UMOTitpKnJM/5Hu02GjhRG2DTucgDi3hJL3+iINb52C8G3T
	kQIbk0I47aKOj8bTvKh3lX3HF90YVP1jUT2twCeU/QhMo/qDyoi/GgnazozIeH7MVpqYlC
	ax1gkuLiJznA3ECqp01kkefCrGPfZOU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788233992;
	b=hYyxOrPtrtuCz7TTCzcT6p9wqL1/jGF1t4cytCQfLq5gW3Y5BeKHKs0HAF//glD/8/W6rD
	+eyidMNqY7zaHAJaV7yEbriD+XfHG8JZ+t0EPW6Zump0j5BbhtKx8D7BN7spysH2Mnc0Di
	zrvOOQaKVhkR2aqM+BteZ0LsccJLU5s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1ZOcW+G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D725601DE;
	Tue,  1 Sep 2026 03:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB231F000E9;
	Tue,  1 Sep 2026 03:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788233991;
	bh=AndJ4eRb4pdKGxDByf2P4c70B3XEzx3uFUPqOt3vFjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1ZOcW+GX/q3zz3IfTc1ajde78AEI40EmdOEmSdDC8yoYz/3WIP7LXMYbvKXXG71H
	 V2ViaAn4YiOy2C2I4uuzOH3fQVI0ZzXdvQw9CAmoBVj46MN42yA/8OCJx5zHKMHKCh
	 0cgRHfOrzwC4kfbiFM4lkkalBIV6otkOGyhuQPIEtiYJz81oMdOWl1hxkfBYDlT5qk
	 49Icz/S6RNGEzEH7gr0W/ooStQAxRQhmwKNW79a94HulwkGzgXvZkI81HoLZZh5qEm
	 mDN0pu79DUTzFgPSIlYyVs0kLyJM+xt5W4cAvvBDT7RGjzz4K/PLbRwAIa4RjOKdNg
	 /jAdNNYGvcyHg==
From: SJ Park <sj@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] docs/core-api: memory-allocation: add k[mz]alloc_obj() and clarify kmalloc
Date: Mon, 31 Aug 2026 20:39:38 -0700
Message-ID: <20260901033938.91859-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831-docs-memalloc-guide-v1-1-547718c274c1@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFD1F160002
X-Stat-Signature: 8csbuuf6bi4z3hwddxnztsfef9xi9pq3
X-Rspam-User: 
X-HE-Tag: 1788233992-270414
X-HE-Meta: U2FsdGVkX1/aUE7gYqbpu+SkmQiT/jVMFnvTXfYUldYnGq7xzHNn3AX6RCLYB243exTZzCm5CyBAZT5H3NXRSZc8MH1vJCfr1MyL8QYB8zpr7qyWsYnMiXsEhToswYiHzd8fN3IUOWDoYvn9Nl0+tua5o+zujuu6MHuYmqGm//iPy5fz55KKNWyg3QOhYsTXoScJ9Yus6IZGn55QXVkyOnWjFd3kViZjyIQNdDUPwDHFyUS2mOoE9GZysC7/zyiE9yeJFNC/sdqTlQfRJ2Ftkno17VHQL1/qTZ2uVPN+dRHcIhQfVDqxVHQOuV8DsIx29ogcxYT9YIuYTeIc2T54KiBN6a7G+zl9JZrw9R4H2CAKmmAWrCpwr9nQKc/4RaMkpwmV8t1f4wKrVPUiERZxuDwBzhH7ZCna9iiePKzD50yNpPHrZccKcyIUYt+44LM2eE7g25SSXFeTF9mgHXhOBVIhxxUaPvMVCNNdweo18saw2OPwNKGXI83jPDMhj+Ze0iwWHBTPsqkCRy3aFMtl2C3IWb09jV8ZQyS1GjKiHtTD+9JLTCJP7ox55M47JBEaZe7GN1Pej+TjKciDaJud0KvsStw91jrFiQSdQ7piV1mB84l+PYhmAeRbZQb/Pr7ag/Ai4Ux0PiJWhpiRuWwjCDsrZwEhSFhi7cQ2moTHJ752SahY2cEIdZJbRUYI/Q6t3fcRWZMnqnU76jLcSLu4RnETQtKAHL808O4EwdrrfHcjhivnRuepRqHNrLrEhQ8GQ4BzuAaA5EyHp2KGnMzGmVhqRw9/ZnZmY01W3ON4QkBdJg3L9Ilr0t3zet8IMvN2qWFzBBQKs+vfSsEFq+7ZSquS9VL6+6GWJ27141D4GEY2KBVZ4u4NMYUHRaVzeIIXtu9SqeiJll/CyqxRkd+8kXTCd3x/DAR8IRm+J72vm5gC7cvL2j4gX7K8MRZBeKh3rU7dsxEopvKIOmwbE+Y
 rEuZns1l
 YS3O+kkw7K7/NhrcU9YG/oBf6p+cNFAcVt1ooTu+gnvAovQ6VnR6EO/kc+PTBoKtRiAELT/w/QpfKDSOqbH3nT15dzGhC+xkwyQJq0zgOupDPugP56YVXQdvgonrOodsB5QHnh1N4L50AvwYL1O/Eyj7rL4IY9CozrMRxjsRm6QVyDqS2DfdNCZIqFIPuuuGmISKw9KQ4ez5hn4Qa9YyNt+oCVe/bu0Z3pF5QpbB6cGN9KxyZUtcxWdyfZ/WzdNhyC9VgvHFAl49v+GeDXb3vyerWdmDqge/Tg/Ft
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 18:13:01 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Since v7.0 the most used memory allocation function is kzalloc_obj().
> 
> Update hte memory-allocation guide to describe k[mz]alloc_obj() family

s/hte/the/

> and make kzalloc_obj() the first answer to "How should I allocate
> memory?" question.
> 
> While on it, clarify description of kmalloc() size limitations.

Looks good improvements to me.

> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: SJ Park <sj@kernel.org>

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

As the commit message says "Since v7.0 the most used memory allocation function
is kzalloc_obj()", should we s/7.2/7.0/ ?

I also feel like the above sentence might not really needed, or can be
version-neutral, e.g., Since its introduction, vast majoritiy of ... switched
to use ... ?  No strong opinion.

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

I initially thought if it makes look more consistent by using kmalloc() instead
of `kmalloc`.  But seems anyway we are mixing those here and there.  So I have
no opinion.

> +
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
> -- 
> 2.53.0


Thanks,
SJ

