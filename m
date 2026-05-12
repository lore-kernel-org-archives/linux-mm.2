Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DF74CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 10:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779136B008C; Tue, 12 May 2026 06:37:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A0A6B0092; Tue, 12 May 2026 06:37:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FDA6B0093; Tue, 12 May 2026 06:37:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56EC86B008C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:37:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146638CD7F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:01 +0000 (UTC)
X-FDA: 84758415042.22.5CF9DA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 419AC80008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:36:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhlJ53dc;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778582219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2p708K+IRgiD+m2A4hQQHdnVQYni2LsF+JtgdgWfWcA=;
	b=k5EPSitkM0MoVpA/QEhlPDkYyHJik7FYYGIKsR1Z24LxKWBCCAo3ViF6RQgwA4jOiECy4P
	lqvv2n0MclbbGFJBtAnZH5xebcuNlisZU6lL7IvwP+AxeAPAvhlt4rak+fexxxSwlW2ZuN
	+Ysbu1lY8UvlFT6FteKYQn8EL7JkjL4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lhlJ53dc;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778582219; a=rsa-sha256;
	cv=none;
	b=RPYv2VB6OAlLGi6IiRZf5haUzIxUy5wDHgs0c9EdPsQdVk1MAQF36Z34Bo5Rp8oXaZ7Pzf
	c1MwT9021esCxnSsqw7cBJsjw9C4aSD5MR3HIGh0hPZ8DqoEeS9uhdPppZ+G+1r9iDZidD
	8ZE1css3xgh0YSl3hxAoVS92+/wBCWM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D43543A06;
	Tue, 12 May 2026 10:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B7AC2BCB0;
	Tue, 12 May 2026 10:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582218;
	bh=ifiiTIiRXCnHmOD37Bvgeqg4zW7Gr4q05xjPMaDkNRI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lhlJ53dcGZBBqoHiKDeEwdDXg71WNZ1BtgcUHaAh3matP6wkuRYkenuaV/9ZXg1jn
	 aB9eHL7GlrhfxM8EskOYqOpN6xLo9j1jCf8rkShFmyTey/zx5kgDSLgevsTqGrcePz
	 /4p4gjYs6F91D+dLdkR+fsAqOScbkzL4my5mU/PyvD/f1ZnMGkSJF3KHceIxRNMETo
	 iWsaIrzNet9DI8ZOfoNHHBwuKUGXnuD6586FTF3R50iUoURNz7nUQLH3OBIggAvgiE
	 x5dLanodJZ7DFC7OeYBrhuj4Bx5xs4YYhp3VnUCkGNyOBAm3rUbcYrFrXIk1fTNnZ3
	 1CgYM3SFRtTYw==
Message-ID: <afc2202a-2e0b-43e0-9556-06be2da33c83@kernel.org>
Date: Tue, 12 May 2026 12:36:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>,
 David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
 Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org,
 Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
References: <20260511200136.3201646-1-elver@google.com>
 <20260511200136.3201646-2-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260511200136.3201646-2-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 419AC80008
X-Stat-Signature: gxg4bzipfzdgima49egs5xj667qgz9tw
X-HE-Tag: 1778582219-786974
X-HE-Meta: U2FsdGVkX1/bSuIBlVakIDNrQl7wxlQtoZU8MdU4jcO6v8Si/HZky6qvtuyyhoISCvCthrp6bj2TvovrkeC9gdlJxsc3KwTAVN1IiFqzEwRWxDVMvqwwUj74O74PDs1Kc84kg1rF9JULs5aRY52kkSi4ElJskiIhcbbQEHMK62rAwIsD5iboLXWNjI/K9j2qCsAgdGUctgZNqm3COV9p/9ylhxkMAVwyuFILP2nTdHZ2UXUlhs+gl5X2chGZGcIVOwnMQ2pH7Wmt9OYjiD+368uACjlT48kY7cdGaq3+ro27RNAoslqFHqJev01zBPN37id218ja7yp2Ylbv9tXwhzZvwJsWCzCcQbS489UuQWVuF99a8K6X7XgdDo0OJfraO0niW5S/52AEWR6KQCR/kjA6j8LWvZRJGyWfgvcUVbBn2vNmdQ4FCDQZp540QsnU9N6eF+2nODg5sxoQI/Tnrm4774nMdEYvj21OJUPLXc2T6TtV2lAzvMxgyjY7nHi0Ju3pQAKnlrcNg+kY4OolZ50nJ1QQcemw6M8hzSFjw3jIisvREpQsgfUkKonKMNDCNe0BV4FZDqAF+WBu/vN1Zkj485zCYtxSd6NSwK0BDW2Iplc7m6IfXJ9L372wX1nE05jFd1yuua0tKZnTFdULpKP44QusWlEcKURAnMbezkZCO6j81PgTaTDzaZ66WF9keKyLogZJY8rc2rTw4qwF+44VyM/m1pU7+8HuV5uFxDuRi3kKUaRwWI+aqxqbN3cWQG+LZIXGubSUe7cBD4JXv8FVDFKAs4GD9SXyXSmzUbBGYLVVOWEWtSzmsomm1MeOggLnL7RIa6Y8NQOACojo5fnGibaMPXEFmET8nw67irLG6CSAoGKdDmvzIpIWpB5QGQLIDXEDsac8bgJGBAAaigFzaljo1E0rJk34i1WxHtrN29rc/UfFV4s3gzlwrTIQ3BJcxrNJ4VWS8cRZNY6
 XMqxCPue
 uIu31o9j9P/8G3E9oIvwkSaqIUvVHMOGYeKHSVYzIgXZ9BRV+l+x35kzpGgtODGh5d04dvPEDfo6UUUfCvTIbioRFuGAJAftP1CzKEGiPKTcMp0W5inQ4aLZ5rtNU5X6IFGEOhZkeIuslJcA6dN8mj0rEcSv3do5eLjqHM+lycIAc0rHzZEJbxpPdVpp7l3U6tfY3RiQi0ruBLJuVzDum4ofJ8JZaXx3sfLK4tZZlaKCbExsjZtJCPKPrUEgOuLZyppKfYo2Wv9XzPVvK3eJBXWIx9r4uXD4N5MTXVisAH+C3B1pPCdfR/WCgfvC4leT1Fm90YVPv2gYeW2WWPUpbgPIKuGztWoJCyjNhLtGvWEb9O3/rByxyBwnVl1ZY2XX7T6Fs6VcsnB6ftr99dyRtRwEr7nEe18TkZl5sLwDllEICU+LOw+9GVKaQb2YyBCW2y05EjiLU5ADisj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 22:00, Marco Elver wrote:
> When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> to identify the allocation site. _RET_IP_, however, evaluates to the
> caller's parent's instruction pointer rather than the actual allocation
> site; this would lead to collisions where a function performs multiple
> allocations.
> 
> With the generalization to kmalloc_token_t, we now generate the token at
> the outermost macro, and using _THIS_IP_ would fix this for all cases.

Hm but it means in patch 1 we make things even worse and then fix them
again, and also improve what was suboptimal prior to the series.
Would it be instead possible to reorder patches 1 and 2 so we improve the
current state first, and then introduce typed partitioning without any
changes to the randomized one? (aside from changing the previously correcly
used cases _RET_IP_ to _CODE_LOCATION_).

> Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> the address of a local label, which is considered broken by both GCC [1]
> and Clang [2] because label addresses are only expected to be used with
> computed gotos. While the generic version more or less works today, it
> is known to be brittle. For example, Clang -O2 always returns 1 when
> this function is inlined:
> 
>         static inline unsigned long get_ip(void)
>         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> 
> To provide a reliable unique identifier without breaking architectures
> relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> to _THIS_IP_ where architectures provide a safe implementation, and
> falls back to a zero-cost static marker where _THIS_IP_ is broken.
> 
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071 [1]
> Link: https://github.com/llvm/llvm-project/issues/138272 [2]
> Signed-off-by: Marco Elver <elver@google.com>
> ---
> v4:
> * New patch.
> ---
>  include/linux/instruction_pointer.h | 24 ++++++++++++++++++++++++
>  include/linux/slab.h                |  2 +-
>  2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/instruction_pointer.h b/include/linux/instruction_pointer.h
> index aa0b3ffea935..ea5bc756bd99 100644
> --- a/include/linux/instruction_pointer.h
> +++ b/include/linux/instruction_pointer.h
> @@ -8,6 +8,30 @@
>  
>  #ifndef _THIS_IP_
>  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> +/*
> + * The current generic definition of _THIS_IP_ is considered broken by GCC [1]
> + * and Clang [2]. In particular, the address of a label is only expected to be
> + * used with a computed goto.
> + *
> + *   [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=120071
> + *   [2] https://github.com/llvm/llvm-project/issues/138272
> + *
> + * Mark it as broken, so that appropriate fallback options can be implemented
> + * for architectures that do not define their own _THIS_IP_.
> + */
> +#define HAS_BROKEN_THIS_IP
> +#endif
> +
> +/*
> + * _CODE_LOCATION_ provides a unique identifier for the current code location.
> + * When _THIS_IP_ is broken (generic version), we fall back to a static marker
> + * which guarantees uniqueness and resolves to a constant address at link time,
> + * avoiding runtime overhead and compiler optimizations breaking it.
> + */
> +#ifdef HAS_BROKEN_THIS_IP
> +#define _CODE_LOCATION_ ({ static const char __here; (unsigned long)&__here; })
> +#else
> +#define _CODE_LOCATION_ _THIS_IP_
>  #endif
>  
>  #endif /* _LINUX_INSTRUCTION_POINTER_H */
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index c232f8a10af6..efab6b2ccf21 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -503,7 +503,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
>  typedef struct { unsigned long v; } kmalloc_token_t;
>  #ifdef CONFIG_KMALLOC_PARTITION_RANDOM
>  extern unsigned long random_kmalloc_seed;
> -#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _RET_IP_ })
> +#define __kmalloc_token(...) ((kmalloc_token_t){ .v = _CODE_LOCATION_ })
>  #elif defined(CONFIG_KMALLOC_PARTITION_TYPED)
>  #define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_infer_alloc_token(__VA_ARGS__) })
>  #endif


