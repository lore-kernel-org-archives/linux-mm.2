Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73E7CD040D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 21:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3443D6B008A; Mon,  5 Jan 2026 16:40:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C0C6B0093; Mon,  5 Jan 2026 16:40:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248B26B0095; Mon,  5 Jan 2026 16:40:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 126E56B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:40:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E9548ACE1
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:40:20 +0000 (UTC)
X-FDA: 84299229000.29.B0B7629
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE26820005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:40:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767649218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oAnZ48fmTHVdLtNN5MtS2ftPnhyAxK3NEPNhRN/Ax7M=;
	b=B7gBHxBNYo/TxJ/F4WwCMf5pXGyS68wMw+ZQtWdiuoiaZ/CSBNwqQVVKfGN04i0Vq5TB8b
	ujwSkUKy7BGyiwiw5qVS8H2KJAxmSKscks+hWxMzxV5VmaddU4BU0DhAoZWKEdz50A2I0y
	+J+S+dFmOn4Iusqy4/5tQoymcIwfrTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767649218; a=rsa-sha256;
	cv=none;
	b=CC2qjGIFb5b95EKj1cbePf7gLub0liyW/oqW43Aoet09Gffc07PmAmaAz5fUjT3pqittgu
	I+axlQ4tHBIz7VU+Ea0dfhIDxdmEEsqjXkqQ8neR0WNz+7fMD1yfkZUlz98nT/TizdCoKy
	hCxuU75X3Z1lmFoHoS1EiIx90mXp6X0=
Received: from omf03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DBF31AE85;
	Mon,  5 Jan 2026 21:40:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id E27946000B;
	Mon,  5 Jan 2026 21:40:13 +0000 (UTC)
Date: Mon, 5 Jan 2026 16:40:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark
 Williams <clrkwllms@kernel.org>, Mel Gorman <mgorman@techsingularity.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, stable@vger.kernel.org, kernel test robot
 <oliver.sang@intel.com>, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH mm-hotfixes] mm/page_alloc: prevent pcp corruption with
 SMP=n
Message-ID: <20260105164036.32a22c2e@gandalf.local.home>
In-Reply-To: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
References: <20260105-fix-pcp-up-v1-1-5579662d2071@suse.cz>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18uqG90fClQgYqM+gD7rF9u4JBB5PDylXs=
X-HE-Meta: U2FsdGVkX18D8vhglud99GU7CXmQ3Vimslye/1+TjZjBXISc1kIieVs/XQKSr4g6+QlVr7/o2HccNhzJQETTMl/B3o7ZZ56IUoHf+eDzwZQpMU3U7Kxey0/E/eyNuopzOc9dYfGhezalTsrvwlIiLoSX4GAONhfUChSXPxSdcw1SQnIxlwxuhU2ylSOQB12csT3H+njuA4KavBrP7AnFflX+0Wzx3ckM6TQLMNk/Hg8irAcqYims6mxoijVg+8zN6RVMSh0T96rx17VrqsQCPD8gXu9HHDiVQaVi4wdFyYT8UtwbpxS2cd+aIawIEQ8o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE26820005
X-Stat-Signature: 7nuqsgdj3h9hzx7tpa8ej48rkpshrfas
X-HE-Tag-Orig: 1767649213-413291
X-HE-Tag: 1767649218-157167
X-HE-Meta: U2FsdGVkX1+xImIJidX83AxyC4kCSppUins8lFPyGUcqqJa83YLkxuKs0GSfECfNmE3jj37d4MmVCqOwsptAKA8GZ0ze5m89eODm3SwFrzAN8+kK3l3c+Kbvo7PLYrEtS6b5xq+T7KsSTkfrZJzOV8yq8W0jbkUBRkHlhYLOQVra1dafT6iOoA5b9KCY1rPu1K+UeOI1nBNN19/dTjBGQwrWhL+wHV7+gND9CMbyzhoKcMtfBvP8vKH/iPP2UcOIA9tTL9LaJ2JVnowztD/DFuJJKk5qXq8B0seV0hd5/zDns9whem0pUOZ7zjeSTliYNEsd5w7Hd9/Sn8EvefkCRIRYlqQI/Hzbf2nW7n6Erh+YSpVWlvOefLhrdi/d6irNi/4O0neuMaaDfY2ouTz+kxhEycy3evQ7XHYQJ1x7Lth+0v9CD8slLmFf53EO9CnXzjyvjRzp3kwj0LqMw0s7aNTRTMleBI4W6Mz3zZtlZEnFFlP/0/rohYIYqt9GqLxcEkAaDGCmhiPa8JsJ641waAiY/IPjgKQDtUG5CR9+9lZier4/GSErdfsWtAqOCmkwh70uYUs0+LbJAlUU6Ig5SUEWMiDK+9q3bgJLLuPIJyauRnZlacmArceC/KK9CLumq2JFm1M3+p8ZHm01lq9NQ81hF2GLW3f0Cu0Yn3TEEiQTQXWipHuGngZE0JmRPdhbRUmY3I06S91dnmaJ4Y+EcOVzt9vf8VGe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 05 Jan 2026 16:08:56 +0100
Vlastimil Babka <vbabka@suse.cz> wrote:

> +++ b/mm/page_alloc.c
> @@ -167,6 +167,31 @@ static inline void __pcp_trylock_noop(unsigned long *flags) { }
>  	pcp_trylock_finish(UP_flags);					\
>  })
>  
> +/*
> + * With the UP spinlock implementation, when we spin_lock(&pcp->lock) (for i.e.
> + * a potentially remote cpu drain) and get interrupted by an operation that
> + * attempts pcp_spin_trylock(), we can't rely on the trylock failure due to UP
> + * spinlock assumptions making the trylock a no-op. So we have to turn that
> + * spin_lock() to a spin_lock_irqsave(). This works because on UP there are no
> + * remote cpu's so we can only be locking the only existing local one.
> + */
> +#if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
> +static inline void __flags_noop(unsigned long *flags) { }
> +#define spin_lock_maybe_irqsave(lock, flags)		\
> +({							\
> +	 __flags_noop(&(flags));			\
> +	 spin_lock(lock);				\
> +})
> +#define spin_unlock_maybe_irqrestore(lock, flags)	\
> +({							\
> +	 spin_unlock(lock);				\
> +	 __flags_noop(&(flags));			\
> +})
> +#else
> +#define spin_lock_maybe_irqsave(lock, flags)		spin_lock_irqsave(lock, flags)
> +#define spin_unlock_maybe_irqrestore(lock, flags)	spin_unlock_irqrestore(lock, flags)
> +#endif
> +

These are very generic looking names for something specific for
page_alloc.c. Could you add a prefix of some kind to make it easy to see
that these are specific to the mm code?

 mm_spin_lock_maybe_irqsave() ?

Thanks,

-- Steve

