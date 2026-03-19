Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D3E108E1F7
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 12:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3706C6B0498; Thu, 19 Mar 2026 08:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347E16B049A; Thu, 19 Mar 2026 08:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 284B26B049B; Thu, 19 Mar 2026 08:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1693F6B0498
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:09:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C412D1B81C7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:09:09 +0000 (UTC)
X-FDA: 84562692018.02.63C98F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id E526280009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:09:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773922148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4DTzozNkv/PKuF/wQ+fzHFN2ZGVuXIT5KkghnSHy7U=;
	b=vjsMbdE6qJRqKRvRbUv6bGnk7zgvSv4TTlsh+pQxW+GvTg4OVWLgajjSlfmz9/UKhyuGXU
	Q8D1tVDrQQ5+6jO7alT8E3ZQhE6B45hSkG0kZk1wm+Mc0nb3SCikR/NOcVo9YKc6m+JBf6
	u5xkd1rkrGQyAQpLMLDI9yQB8sWm4fU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773922148; a=rsa-sha256;
	cv=none;
	b=2nvizXvVtbM3LG2x/k7jcUWhrzGYF9WKpADSpzike3B7/no1/PuhXF/Li4ksx7Pp3hszx9
	9VyeaodYJzohQqU56EPqbRr25XW6IAdEGeiLumdsZ8AK45ekb/Tt4dl2KgPslAGlf+g/kS
	sNKUi+5rx8bvKYhaczXxFj8h8SWFH4A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA7B91A25;
	Thu, 19 Mar 2026 05:09:00 -0700 (PDT)
Received: from [10.57.85.34] (unknown [10.57.85.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 185B93F778;
	Thu, 19 Mar 2026 05:09:02 -0700 (PDT)
Message-ID: <dc85cda7-cf66-4bfa-92ab-af23f550562a@arm.com>
Date: Thu, 19 Mar 2026 12:09:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] fork: skip MTE tagging for kernel stacks
Content-Language: en-GB
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260319114952.3241359-1-usama.anjum@arm.com>
 <20260319114952.3241359-3-usama.anjum@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260319114952.3241359-3-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E526280009
X-Stat-Signature: hxyfbwgduzsqa5ap3ha3cp9k86hjqzph
X-Rspam-User: 
X-HE-Tag: 1773922147-935228
X-HE-Meta: U2FsdGVkX18qWpYvIo13m7evnS7AVnIph2t19Ek57rD3aGqD47T5pJjJLJJ3lhRK6vehVZPPV3pwhhtPuBww0DIuVJjuBNW4MJBfacqNRgz710vLvZOvj/jKDivydA1hIokgN5/y4DFnDtCFu+wvq6pyejNM+jBgEwGqyo2sLiZYofbKVtycVVBLy0YLcRt++b8abWbq//2arsFfR1366X/uEkHadHn/PpmnYsNkDdTGC/OSbJyHSEyUY2HBXHVWhCZIyGk9+DC1UX+JFiZrykXXYs+JdMpOlXDYVxjHLrjiXCVDx0aSX1OlqKZ/eMgbko4CT5kB7vRq8Vrf376NtxuzVGewdsctDLq38eB1dWdjfA3nMpmhnisJBp2Pz65H7XPIZ3XvzEIaQM6LeLzMAx2LlCYQgO3Ph9q75z9YVoApQwUwQJ9XQMIglWR3dQvTqzEcnObgKN/DIHqdsCn4hJVtzq3vAzsBgxCOwAzi1JMeNyn0U1BSwusJPSt57FzkBgEANKhzYWhoX7JyRKrg5cFfT88mhSYgBKR5m7720d7xodifcb8Y7629MgJAypTZugSxBlrhybqXmH6ulOW/i0ZFSBXp7NvmVQeoSoO077nCihjbu31jwNhSsLrPjeslpdvwmPuVlCBFbwUDqtHsp9bpy9TBLQiJJ6VxEQz5NmYFrP7t/PJ6Jed+EJyOigVXsORWr1sMRtPKUy4/8SRwj6uU5kBZL1q5pmGi+RHrZQwVRteIEnuhJITJqtj2lj1R383Xa5timit+WBrgNNVKv/jbK7jp8cU9FfZTpdc/9aBOi/p9acbmmPXfJMC2trCCkp9T3XMmVXs/2eMxbsxgOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19/03/2026 11:49, Muhammad Usama Anjum wrote:
> The stack pointer always uses the match-all tag, so MTE never checks
> tags on stack accesses. Tagging stack memory on every thread creation
> is pure overhead.
> 
> - Pass __GFP_SKIP_KASAN in gfp_mask for vmalloc-backed stacks so the
>   vmalloc path skips HW tag setup (see previous patch).
> - For the cached VMAP reuse path, skip kasan_unpoison_range() when HW
>   tags are enabled since the memory will only be accessed through the
>   match-all tagged SP.
> - For the normal page allocator path, pass __GFP_SKIP_KASAN directly
>   to the page allocator.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  kernel/fork.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index bb0c2613a5604..2baf4db39b5a4 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -345,7 +345,8 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  		}
>  
>  		/* Reset stack metadata. */
> -		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
> +		if (!kasan_hw_tags_enabled())
> +			kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
>  
>  		stack = kasan_reset_tag(vm_area->addr);
>  
> @@ -358,7 +359,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  	}
>  
>  	stack = __vmalloc_node(THREAD_SIZE, THREAD_ALIGN,
> -				     GFP_VMAP_STACK,
> +				     GFP_VMAP_STACK | __GFP_SKIP_KASAN,

Perhaps cleaner to include __GFP_SKIP_KASAN in GFP_VMAP_STACK ?

>  				     node, __builtin_return_address(0));
>  	if (!stack)
>  		return -ENOMEM;
> @@ -410,7 +411,8 @@ static void thread_stack_delayed_free(struct task_struct *tsk)
>  
>  static int alloc_thread_stack_node(struct task_struct *tsk, int node)
>  {
> -	struct page *page = alloc_pages_node(node, THREADINFO_GFP,
> +	struct page *page = alloc_pages_node(node,
> +					     THREADINFO_GFP | __GFP_SKIP_KASAN,

I think there are some other places that could benefit from __GFP_SKIP_KASAN;
see arm64's arch_alloc_vmap_stack(), which allocates stacks for efi, irq and
sdei. I think these are allocated at boot, so not really performance sensitive,
but we might as well be consistent?

You've also missed the alloc_thread_stack_node() implementation for !VMAP when
PAGE_SIZE > STACK_SIZE.

All of these sites use THREADINFO_GFP so perhaps it is better to just define
THREADINFO_GFP to include __GFP_SKIP_KASAN ?

Thanks,
Ryan


>  					     THREAD_SIZE_ORDER);
>  
>  	if (likely(page)) {


