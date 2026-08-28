Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F31C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A43C6B0088; Fri, 28 Aug 2026 09:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655FD6B008A; Fri, 28 Aug 2026 09:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BF86B008C; Fri, 28 Aug 2026 09:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 269A96B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:36:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 89B2D1403A3
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:36:31 +0000 (UTC)
X-FDA: 85150777782.25.DA24842
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6FF6A000F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:36:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zHr5gm9u;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=2slVRRU9;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q2R0OExeXoLUYFz9ysgWw29sTN/8ZU4lxybQbrXgrZA=;
	b=d94zraWANbA9zB4d3ucZZH1SWLOO5DGKl2hgnLvtq/c8+O9klAu0Y/c+vJdyalqOAVQZOh
	dAELfQW3Fk23XDBKnmIzUFMonCe8zPXYgLo0+gkCHjH9g6po9GRfCk+E9Bv5P70f8N2QBk
	pLdS5zYVulWmhJ6Q6rVuWMWhePspigc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zHr5gm9u;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=2slVRRU9;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924190;
	b=KaujLN7mh9ROlsMhMgnqSZBDQK+QIBA4uFHnw53OTCBKktQfMuaxVkuKhJNUCsB+fE4jlL
	YYydZrabDysdpUrfBqVqpxveun+UOp+JGOqwScF5AB9XW3XNjTHW1rqs57wmrIcr8mNBSI
	oSxrfPQ1EFoMbZOm0p9d4JchuCm7pfU=
Date: Fri, 28 Aug 2026 15:36:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787924182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q2R0OExeXoLUYFz9ysgWw29sTN/8ZU4lxybQbrXgrZA=;
	b=zHr5gm9uJuQjJaXQweR/D4yoAZIHaeIlhRtOxuM7xYfNDxomg3PvGnrXsvi2LhBnduI+1g
	Puj4mPxNDqKrow+lXe6p/m3FfqH9dks62FzRj9uE3ArSrxKZAlAbg5DieZzD7TQx8wiUsz
	VtKSbVgIxqyr1NYWJjwiN/amwniaCzF8b89m/0RJVhEYiqEs/qLTtZWlAm2UFTPLlSfvMh
	Oahq3izuqq6VGWa8c7D+ctlV6AAmyH1bitLxM9g22/pYE02kVc6BHdBx2uKwXHd4GjJH7w
	saOSvYbOSReT1k23eIS23OM/bq1Ww4og3bFMIgkMrDxpfZFTEuaA0K2KW2tr+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787924182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q2R0OExeXoLUYFz9ysgWw29sTN/8ZU4lxybQbrXgrZA=;
	b=2slVRRU98UPacC+TgkLGX3+5I6jfQVk3efEXBJ5yWyG54KCToYRd3d3ZEA1xWi1HMwwKEu
	Qn6vvf+pLEb51rDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: David Stevens <stevensd@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260828133620._x2XfJR_@linutronix.de>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260827232948.2520558-7-stevensd@google.com>
X-Stat-Signature: 9bh7eu14g7n77ob4n9uwtsrdobs1p9en
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6FF6A000F
X-Rspam-User: 
X-HE-Tag: 1787924189-512935
X-HE-Meta: U2FsdGVkX1/Ll1CSrpEX65k/EoL2yK5rYcY1cbcrOoXWGXJXbD0ed2ofg3EvQqZWSjOpBdMZ/tjrMTNvbFn7Zk5S7v4pBL6Icd1Eiq5+04WxF3Q9LjQqNWtstK8CPUhLKNMaaZIv3Hc+aAfBqd/fzhDuu3UQIK2Z8Er7N7a2V6xUp6/lQ8I3emVjT73t7B6ret113SZIcPRdIqLFEV8l/h5sfUU84zPZ8mERnuSNuLKtdvuMydANWFAhSv3OcdtMfi/Zq60fe1YYtX7T/oI9vG5TRUPzutf9Ty+FBo1zf6ldXE+nAO2nx7a0hUtZaDVhBfuL7KmE6AOpS3uC3BKwPpfOMi3QO93gQZeuLhIUIc/hW/FTZ9miJB91vsEf3eK34sBg7AOtxGs3MGSY8Mv60U1MaZ+yCs/6sMWT15GtaInPGXvy5A2ET5WXmgVwK2NN1rkGvWjNd2vas8SUgUwzVh8carqAv41piid84FUvAQ2GLHC0mJqnHbQTmIOWAoYlfLf2zB6+g96fUt7SHfGrepFZIIx8HTTIy8DmIcN5yD6affkVTsTUlc4WSQ+9fSWv65eoLTnQXJnR2E18BZ6l623JFyhrqIBgT2pkGCyryg4LL0N9R48SuuL+bJJW9Y6sF03e/HMJWo9GcsMhHZSD8HGTKgLINavAHy2aQ6MR++TQO9Qh9B6oubupA5uqq/iaiZ0dDkfedpWjbUjVyb2AxG/V/rHn5cpqWe+0HTg4GQFe/0hvf4GyUAEyv8iyIWWjWcX6mM78S+Cwnb0vCAxUMd/dOtm+rPoupRJSAF5p5jdjxFY288BVwBB8yOaIxXv5kLzSAflqsImKJn9r0SBPlcKR1x+jahpSQySg/0kH0Yh1zBwh5cVnTbi1yl9o2YnomoJGbB9p/gIVX9bLWxRGm5Qi9sKl2cbT17lCNMfJVZBsT9WVC7aaD8iSY7Ooa3hWK9Hmq1fI8BHS5MN76ks
 yhLlVsB3
 lJdQDNAR8bLWss4IwQI5i5kpZmomjburnfIItV04BEnJ1HYnMbOrkQLePDZfLoQZhgYgVY6FknRsEwBjzfXo7hPIv445N8aenLq9WwXEw/BuuzhNt5svVhEdTNYv4W2kHKNe458px6hofQoEasPBAp/1Tl9uwCXGkO5aEk16NZYQAG2OH31DTduvQqcxyXNAMjkXe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-27 16:29:44 [-0700], David Stevens wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index fa7507ac8e13..adb4a5957996 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1534,6 +1534,24 @@ config VMAP_STACK
>  	  backing virtual mappings with real shadow memory, and KASAN_VMALLOC
>  	  must be enabled.
>  
> +config HAVE_ARCH_RECLAIMABLE_STACK
> +	def_bool n
> +
> +config RECLAIMABLE_STACK
> +	default !PREEMPT_RT && !PROC_KCORE

This shouldn't default like this for RT. It either is useable or it is
not.

> +	bool "Allow stacks of some blocked threads to be reclaimed"
> +	depends on VMAP_STACK && !STACK_GROWSUP
> +	depends on HAVE_ARCH_RECLAIMABLE_STACK
> +	depends on !DEBUG_STACK_USAGE
> +	depends on !KASAN_VMALLOC # TODO: add support for this
> +	depends on !DEBUG_KMEMLEAK # TODO: add support for this
> +	help
> +	  Enable this to allow the unused portion of kernel stacks of most
> +	  blocked tasks to be reclaimed.
> +
> +	  The wakeup latency of tasks with reclaimed stacks may increase,
> +	  especially while the system is under memory pressure.

It says *may* increase and on RT it _definitely_ will increase since
there is a kworker involved not to mention the memory allocation itself.
Anyway. This either needs to stay away from PREEMPT_RT or find a way to
exclude at the very least mlock()ed tasks.
Did lockdep see this?

If I understood the whole exercise correct then you have a kernel stack
of two pages and in best case you can unmap and release the second page
while the task is napping.

What might be a tad simpler is to memset(,0,) the remaining part of the
stack. Since the stack is vmap-ed it should be swapped out on its own
without additional tricks. That memset() would help zram to compress
better so it uses less memory. ta-da.

What also should be simpler (and I am not saying just to move you away
from the scheduler) is to have a shrinker which iterates over all tasks
which are marked for reclaim and then similar to swap just unmap both
stack pages and release the second page which is not used.
Upon wake up the task should create a page_fault which would be used to
allocate the second stack page and map the whole stack again.

This sounds simpler.

Sebastian

