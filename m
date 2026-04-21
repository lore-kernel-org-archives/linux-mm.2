Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 363F5F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0746B0089; Tue, 21 Apr 2026 13:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C83E6B008A; Tue, 21 Apr 2026 13:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDDD6B008C; Tue, 21 Apr 2026 13:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2A16B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:22:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A2811B9771
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:22:46 +0000 (UTC)
X-FDA: 84683232732.19.7543450
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8EA1E180010
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:22:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APakOZVU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776792164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CExu14qwKB/OkgSONz80lVERz1l1eBW9xm8Eu8zKp4w=;
	b=42cYnq6ekDShLKVRJjlc9b3m7oPXt3j+Bo2jUdVh5ZuiLCXx5j+cXBwuWnKWXpq0NBUYDG
	2b2V6YHdtrszgLGv2LvXPfwTW0HyHw2CRgJjtBrgEjebjU6F2DqNAJs9WjRjSNv73J4tvA
	1ol4Mz5VQUQK+8b5K+0Sc9qaNsYnOi8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APakOZVU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776792164; a=rsa-sha256;
	cv=none;
	b=uXj479BckJP83JX33M0ErC3Y9jvYIhK+YdUSHMN4Yo7mIznAThge8rlxXYqhQV/NvZKswL
	h1YYYB5Scyny3hgWWAMQyUXliezmlmN5cnOXgtv0qOJKb+604LUL2wO5oUvWZVNngBXQmZ
	AqZhLmRg73LCCNxjaR0TQpkM0VSCBqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86FA760142;
	Tue, 21 Apr 2026 17:22:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EBAC2BCB0;
	Tue, 21 Apr 2026 17:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776792163;
	bh=nNMDSilb+/zXGXVw/f0Wvgf6NfzWoClrWzQe893lPEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=APakOZVU5qkL6vWUVTFAYa7wyo8CQ/+TvO3KSSP5ZRkDiG7GeNDpX9/D3iHleKfe1
	 MLfTi0udDG+jOpm+5Xn4s1LPuyDV1GjPm5WyWeylmQcPRpTdUr4wN6Wphw9pRBWjvp
	 AFg73IKKfpBPJxMEn0orz74mE/laLUKi9r0tIzNilLIjUUoRRx6ZmVFNLcpHJ2jhqO
	 9u6201KZx3sh5Vh5HklBamSzUt8geRNlHbsS29kwq6LjTPzkRABmYgpIHbRj1EegtK
	 3rpG+i7AR/Kg7ZinHcHxHHk8cKqG2KeeONe/KAX35msVFasIfncY2lD0aiM3rVQyVg
	 VyqNHsIu0GGSQ==
Date: Tue, 21 Apr 2026 10:22:42 -0700
From: Kees Cook <kees@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>, Jann Horn <jannh@google.com>,
	KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>,
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v2] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <202604210954.84C57E5E0@keescook>
References: <20260415143735.2974230-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415143735.2974230-1-elver@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8EA1E180010
X-Stat-Signature: q9iwr6wzdztur1ao3sig8te6ixqtu7aa
X-HE-Tag: 1776792164-614042
X-HE-Meta: U2FsdGVkX182hfNA2LtR26LMZISUyjU9Ey4X/9FQyoQFjwM3v2EkwF9HgLCDjJOOaYBvwiMHaPuyrL3xL/u7jkhLLnT2xDltLjOesSl2erxu6FIAW3PeOp7w3gV84w0N7YUhnnctCeZyrJl3xPO9GV0sijOXq8cPvXrajNAXHy+C51T6eg7p7Er2C7UHu+y91lhvR+YTHil6ENdptcD+QJhmFmu9nBRgjE8a2FK71vjIGwoLaxrsggfcohLKXyT/krmqBBOlWbrnkV36MNRrqGo2XhWWp1fw3wIO4sU/qJ/8eUG/kqDa5NbUW3bpd7HvMg8xP1TLrAvCXJLwnS0RxaDJ049vA6TA3EjB3eVFT7YV/dK17dINEnPN/vOSbX5UE2VRxwj0AYXnCUt1DL+a7dp1Yrfys966i6MOszW1FM2z+HW+tOOIKP8+77oFcD6JViK5jYp67HmCVtNZEJnnc2+3QIMU0hIwdkj8e4AsTH+bFvtxd7T3zM79k6+FBrrGnfX8BcjBFHc3QCpHv0iPQikcFTnT6FUyo9Qd4ot71OA0LvfIjd8MqWvzOdWtRbtdj4h63W7HvWyV7y5cCIbl8qsntGKnqhEDWhNYdVNldEQxXpWO9zbr56Jj3u8G6fKp27vKLzAyocldVmb1iU5digJPEpA5IqLw4hsVeSlYqkPL8hAkPbN3YBqsFsU4Pm/XgUQooyt6DoxU2XKgwAe83x7wIXRExCG4fJYVBqpnZF737WDScgq5M7F2rzijhUoFP3GY4sIfEcT0V2nWSzCgIEWq9f2J45bn9apwDZ97ZpTOGtbSBVVQYxdQk3zC6rGZflnjis3LCztPpfJUiHGGaCxFzjpEnZS0AsFHmnx/7QPJoDMn2a20pneN+Ywv+oQ49GoTwdjl5ugSSiuFgLZzCoYoDQWAstXJ371FQ93dTywtqMylLpjj69pohtM18ZGWp0B14GT5T4pQLQvjJcD
 j3W7y780
 mPCn8V715eKo/9r3IA5n42ne7GGf8vcSwsMf6vPq3xC6EhGssCBScJ5Bk5SlGvZ5kzB4aY6xiLKT1v6Ea68S2zNFMwZG/blYtqMgxDDc2Oeg6nYygS80twplPGvJolHLiiynta3hKgQSKw6+tnTyefNQcqfhoSX4930b8Ql/G97CntpXOcMYVbU9p0yJlHLvzskHsQHMHA4S3Q8qabWGixSBN+Dg30WdKwRRuZ9WneeX642AREgZImYwc1QHnPZpNhpmWl+3vqv6Pj8gO3ZbWA+xvYVK++IpbnJGVl3IYD/NBpYDQYoT9Y58aGwA3JGhuVosp3sGP6um62zKhk56rPvO6kvfB7Zm1oCOI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 04:37:05PM +0200, Marco Elver wrote:
> The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> the compiler to infer an allocation type from arguments commonly passed
> to memory-allocating functions and returns a type-derived token ID. The
> implementation passes kmalloc-args to the builtin: the compiler performs
> best-effort type inference, and then recognizes common patterns such as
> `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> fallback token (default: 0) is chosen.
> 
> Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> expressed, and therefore ensures there's not much drift in which
> patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> compiler recognizes via the cast to TYPE*.

Great! I'm glad this gets deterministically handled for the kmalloc_obj*
cases.

> Additionally, when I compile my kernel with -Rpass=alloc-token, which
> provides diagnostics where (after dead-code elimination) type inference
> failed, I see 186 allocation sites where the compiler failed to identify
> a type (down from 966 when I sent the RFC [4]). Some initial review
> confirms these are mostly variable sized buffers, but also include
> structs with trailing flexible length arrays.

For the call-site-partitioning series[1] I sent before, I had
per-site caches for fixed-sized allocations and size bucket caches for
variably-sized allocations. I'd like to see something similar for this
series. Specifically, I replaced "kmalloc_slab" with "choose_slab" that
did O(1) to find the dedicated cache/bucket for the allocation[2].

In this case, we now have a build-time-constant value that it should be
possible to use to look up a _single_ dedicated cache/bucket for the
given unique type: there is no need to do hashing.

> [...]
> -config RANDOM_KMALLOC_CACHES
> -	default n
> +config PARTITION_KMALLOC_CACHES
>  	depends on !SLUB_TINY
> -	bool "Randomize slab caches for normal kmalloc"
> +	bool "Partitioned slab caches for normal kmalloc"
>  	help
> -	  A hardening feature that creates multiple copies of slab caches for
> -	  normal kmalloc allocation and makes kmalloc randomly pick one based
> -	  on code address, which makes the attackers more difficult to spray
> -	  vulnerable memory objects on the heap for the purpose of exploiting
> -	  memory vulnerabilities.
> +	  A hardening feature that creates multiple isolated copies of slab
> +	  caches for normal kmalloc allocations. This makes it more difficult
> +	  to exploit memory-safety vulnerabilities by attacking vulnerable
> +	  co-located memory objects. Several modes are provided.
>  
>  	  Currently the number of copies is set to 16, a reasonably large value

The "16" buckets seems to hold for TYPED_KMALLOC_CACHES too? My goal
with the earlier type-partitioning was to get _total_ isolation, not
simply bucketed: 1 cache (or sizes-bucket) for each type. The "16"
limitation from RANDOM_KMALLOC_CACHES was kind of arbitrary due to the
hashing.

>  	  that effectively diverges the memory objects allocated for different
>  	  subsystems or modules into different caches, at the expense of a
> -	  limited degree of memory and CPU overhead that relates to hardware and
> -	  system workload.
> +	  limited degree of memory and CPU overhead that relates to hardware
> +	  and system workload.
> +
> +choice
> +	prompt "Partitioned slab cache mode"
> +	depends on PARTITION_KMALLOC_CACHES
> +	default RANDOM_KMALLOC_CACHES

I think this should be adjusted a bit:

config CC_HAS_ALLOC_TOKEN
	def_bool $(cc-option,-falloc-token-max=123)

...
choice
	prompt "Partitioned slab cache mode"
	depends on PARTITION_KMALLOC_CACHES
	default TYPED_KMALLOC_CACHES if CC_HAS_ALLOC_TOKEN
	default RANDOM_KMALLOC_CACHES

And actually, perhaps a global rename of the options so the selection
naming is at the end of the CONFIG phrase, and bundle the on/off into
the choice:


choice
	prompt "Partitioned slab cache mode"
	depends on PARTITION_KMALLOC_CACHES
	default KMALLOC_PARTITION_TYPED if !SLUB_TINY && CC_HAS_ALLOC_TOKEN
	default KMALLOC_PARTITION_RANDOM if !SLUB_TINY
	default KMALLOC_PARTITION_NONE

config KMALLOC_PARTITION_NONE
...
config KMALLOC_PARTITION_RANDOM
	depends on !SLUB_TINY
...
config KMALLOC_PARTITION_TYPED
	depends on !SLUB_TINY && CC_HAS_ALLOC_TOKEN

-Kees

[1] https://lore.kernel.org/lkml/20240809072532.work.266-kees@kernel.org/
[2] https://lore.kernel.org/lkml/20240809073309.2134488-5-kees@kernel.org/

-- 
Kees Cook

