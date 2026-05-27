Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A7ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A477A6B008A; Wed, 27 May 2026 07:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F3A6B0092; Wed, 27 May 2026 07:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C2B6B0095; Wed, 27 May 2026 07:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 844CC6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:56:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3597F140565
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:56:54 +0000 (UTC)
X-FDA: 84813048348.03.F13AF4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A72FCC000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:56:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NweolyGX;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779883012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksZ5oHiQw0set/5JzEq4vhK20DwRRO7Os6WxXBqwiRA=;
	b=R3W6FCnv019QlL9ezM6/OAyKsuSgLHmiNwuIPXR7L9DbjSb3WBpl4xwbHHo2XQo8DmyvaN
	g8mU3GmKx9KozjeOlBzvxtfbYzOct2ZCFYiwjgqtXtQ/6YkpK6sdRm84jc/DR66n6J5/V4
	7zI2QRSVNQ3Nu+X6J645TbB5g+Ef5pU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NweolyGX;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779883012; a=rsa-sha256;
	cv=none;
	b=AaEhAXO33BaITfCIL87FaZJiD3TGlAX2azWIB8xZWfsbFCK5EtrKlx6q+7HCgOCBQDbYZW
	SyDyq99UlwIugvxd3pgfKiXK44mz96SGfqjhkDUbBg0yH1FBQMr2Lz7zNoikvm48n7Vdin
	FDd8VLYL8zGKnAxRRcPgB7Innu1IMIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35AAA600BB;
	Wed, 27 May 2026 11:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20CF11F000E9;
	Wed, 27 May 2026 11:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779883011;
	bh=ksZ5oHiQw0set/5JzEq4vhK20DwRRO7Os6WxXBqwiRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NweolyGXKEajQ0RagK6sfKNXR3ZzC9vSVU2YLniuEU+Glx+awY5/0FLd0SJ4c2fTA
	 ZEawMCjKSwiuOqJZycIboFWAUXIsXCV3AjZmpmSiUxaUzweLj7Xb3OINPKYt2KuZct
	 pps6h9ZusRXlL+CGq/ZIMQh5wOf0Wucq5+apl8w/QFyWX9GYCW0dUl/bCkG/tbUm2L
	 LOOvm+uurETXlZAVKh1uT8YMvaSSxBD4qqvZJ7FqwYsJXg8WqcAInBwV3ljQt/QVJB
	 4kWeE2s44qxGxrcfoOjgVQp0UjmsVLGZGNOtub+PELBiymmugD3s3Hn2+Rf+jegYJ0
	 jT12W2JGCFVUw==
Date: Wed, 27 May 2026 12:56:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 03/15] mm: introduce anon_vma_tree_t for multiple
 anon_vma topologies
Message-ID: <ahbatfs3G-Qkh7Vk@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <20260527110147.17815-4-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-4-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A72FCC000A
X-Stat-Signature: 6t6c4r69icd4tjo75r4osi878m7swop3
X-HE-Tag: 1779883012-142051
X-HE-Meta: U2FsdGVkX1+tiej4NqAzO3y8VutBrHVq4khIZuXINQ0yJHmTTCF/6z0229lXqVQ+hUEklXCuMb3EIsosh9wW//fMEuvCliCt0UO5Mb1I/s53S2Ktn4IdLT5BSEPFR+FGjAJDYsOtVRWdF5CrZFy1iNk9219fnXn/VdOzh1CtrBe/CE5BQgEKINEswwpIrBhI/i2xvz+7qBv4Qq5J3XjGmgH+0aoy2nb5JKZPgB92+uCK7W32avXFGpDdiSqtfYpol9omwvbubU0WYnIEHbt40UflfAA+9DIcF+/iZEQlT+iN07xXEFQOVc3roeYpgs0iduIsp9/GrEmK9WHLRGFIds+OeypTgTN0DoC8CnDQpGgXBfTedUtA2rtOvXAcPnj+5Ql9C69VgA8Xo/PEiCcFfwilIfrhyZcUSGSAgAg5GO6K0y5A6fsYiAXqd+RhcTg/h054TNGzjKMc5Ik8BV73bryhUOgTJGwKsdUk11Fg7ylifSrkW4urHqPjCPzwioIMimVbh6BHxUtIlWEjT45dDLvVJSkjxX0T9l/HDhHpTXYLcF7qn/LTWD7t1lF6ebVOMTn3FEdyqLqpcN8Lgbd57It14lL9EB3sjQbXcXcJ3dyrgxqCq2nOW5WHHbWHj6tGXl2oXnLfTIvFCTzU/KfIzENA9fspmcZVLmdiOi/IhknPNK+9669PSHDPVmDAd0sz362u3M745UBL3w4cMoY6htMGVz2erS8AK8E/SYHYb9R6ySSUVSqm8suMyZok/1h9eiKCfwzLs5H5FRFXdXWCfECqktVGnD8To5lwVN1eQLCSLcZ3SKJG3q+L++22dNDhv70GHiyJSsAiriXKm16djLxsoTAE+KpZUBFHfBujAWc2jdLlJKe+H4ntbgu1Jo7lwv8mCSU1UnknQJp5waEvL4J/SWf8rK7crH683fl4ETVdOUuduF4MpUiwaoJXBgE4w665bME/Vf26mdyPqSV
 +oUyFwUa
 c2DwHzFY/BEWI6+ks5uHFpH7JDUY4Q+GZVSa9r9HbsptbMeNegz+KiAJWeMDqQvw8SQImfpL8wM0mR3Vj4m13JpeT6NqJaeRPbLhvLPyOJ7N9Ias+jeBL7ixTv/Z6fFhCqqjb3N4TLqJQAQ9owe4sfHMbfNcYTZKc7jAIFU9uKPHhtM13e4w69W8Jx75+Q6i/2tIHKGBJA/Fy+2dWvYgKPIinhcUOC14PS4sYwRtjcvXzcnFma6YbHTftByIJxKz1T9NgaZvo4J6O1B1OSE6UQnYtPyl3pvqU713yX6ihBzvmOG1TKBEW87N3MYA3DsyUGW+XqB2Hv2Fb0N+QC5KTO3ScnZ1XQzAmm6uSBf5WvD/pk7rgCA+dT1vrENdS7ssFTMyaOhrcgb6HF0DeZSnYv3WMKpqAprG+gEaHMuGf3HJGcuffsa9yh1t00NsSZ9FF5hxprb7UBGZXGns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 07:01:35PM +0800, tao wrote:
> Prepare for upcoming ANON_VMA_LAZY support and RCU-based lockless rmap
> traversal by clearly separating anon_vma topology handling from the
> anon_rmap semantics.

RCU is not 'lockless'... and if you truly get RCU semantics you break a bunch of
stuff as I found out.

>
> Prepare for supporting multiple anon_vma topologies by introducing
> lightweight abstractions used by the VMA and rmap code.
>
> Introduce anon_vma_tree_t as the type stored in vma->anon_vma:
>
>     typedef unsigned long anon_vma_tree_t;
>
> It represents a tagged pointer encoding a reference to the anon_vma
> topology. The low bits are reserved as type tags to distinguish
> different implementations (e.g. regular anon_vma and lazy anon_vma).
> This keeps the VMA representation compact while allowing the topology
> to evolve without changing the VMA layout.
>
> Signed-off-by: tao <tao.wangtao@honor.com>

The commit message is at least better on this one, but this approach is again,
predicated on extending a broken abstraction.

You could have saved time and effort by coming forward with this earlier to the
community.

You're also adding a bunch more messy code on top of anon_vma. It's just the
wrong direction.

> ---
>  include/linux/mm_types.h |  3 +++
>  mm/internal.h            | 54 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a308e2c23b82..5f4961ea1572 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -917,6 +917,9 @@ struct vm_area_desc {
>  	struct mmap_action action;
>  };
>
> +/* Tagged pointer stored in vma->anon_vma. Low bits encode anon_vma type. */
> +typedef unsigned long anon_vma_tree_t;
> +
>  /*
>   * This struct describes a virtual memory area. There is one of these
>   * per VM-area/task. A VM area is any part of the process virtual memory
> diff --git a/mm/internal.h b/mm/internal.h
> index 5a2ddcf68e0b..76544ad44ff0 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -246,6 +246,60 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
>  	up_read(&anon_vma->root->rwsem);
>  }
>
> +/* anon_vma_tree_t APIs */
> +
> +static inline anon_vma_tree_t make_anon_vma_tree(struct anon_vma *anon_vma)
> +{
> +	return (anon_vma_tree_t)anon_vma;
> +}

You're literally returning an unsigned long of an anon_vma here?

Why is the anon_rmap_t a wrapped struct and this an unsigned long?

> +
> +static inline struct anon_vma *anon_vma_tree_anon_vma(anon_vma_tree_t anon_tree)
> +{
> +	return (struct anon_vma *)anon_tree;
> +}

The anon_tree is an anon_vma? What?

And it's a tagged pointer but we don't bother clearing any bits right?...!

> +
> +static inline void anon_vma_tree_lock_write(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	anon_vma_lock_write(anon_vma);
> +}
> +
> +static inline int anon_vma_tree_trylock_write(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	return anon_vma_trylock_write(anon_vma);
> +}
> +
> +static inline void anon_vma_tree_unlock_write(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	anon_vma_unlock_write(anon_vma);
> +}
> +
> +static inline void anon_vma_tree_lock_read(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	anon_vma_lock_read(anon_vma);
> +}
> +
> +static inline int anon_vma_tree_trylock_read(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	return anon_vma_trylock_read(anon_vma);
> +}
> +
> +static inline void anon_vma_tree_unlock_read(anon_vma_tree_t anon_tree)
> +{
> +	struct anon_vma *anon_vma = anon_vma_tree_anon_vma(anon_tree);
> +
> +	anon_vma_unlock_read(anon_vma);
> +}
> +

You keep adding more and more code on top of the existing mess. This is NOT what
we want.

>  struct anon_vma *folio_get_anon_vma(const struct folio *folio);
>
>  /* Operations which modify VMAs. */
> --
> 2.17.1
>

