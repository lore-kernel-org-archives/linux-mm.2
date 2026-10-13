Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DB3CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 07:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B6E6B008A; Tue, 13 Oct 2026 03:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973C76B0096; Tue, 13 Oct 2026 03:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890456B008A; Tue, 13 Oct 2026 03:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 687316B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:41:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1D7F14095C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:41:39 +0000 (UTC)
X-FDA: 85316808318.20.98DA3EB
Received: from mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 98B8440002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:41:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pb/tUTfG";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791877298;
	b=x2F8tzgb8bgI4qqFimfOyGS9NGJal4s4jaXT2rjNSPXytZeo+QKO/1VfEzqD8rqCbrLCer
	BMwwGR2kHG1/dz7ZK9Y0nibmgQ/BWTkcEy5rJ5Y8EdK/j0FZFMkxAZZsmUqXG2tH666PkU
	OmeJaTFsxvi19N1ij8QAtJ7lalxEWog=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pb/tUTfG";
	spf=pass (imf27.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791877298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9kF/iQYp1617YjEVWNsDjIjRKYqFUY4b0KuHQnLKac=;
	b=6FEdKbvjiD//ZrdE5jYdQ9c5LC2WPZsSHHTk5Fzg0Ra0u/c+3XghXEPBIHVcNDjDKFiGpy
	mb1/xfJCBz4lHPf0wNRlUFwggb2BrGp4Y62KxjFgbhV5/BfJniODoNdrK5FBbjVbDljua5
	LNfaIf3jljTBRd999N6Q7GHFA1DIZjI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dCjzHOQNME5B1ha6ad1OSZB47ZNEjiT4g8WoAGSuXsA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791877295; v=1; x=1792482095;
 b=pb/tUTfGoq4gbg2A7piA7CLNvPVNdn8PyCcsK9jb5bqo/uEQJ+pGenMMz75dubZjIT4it8wl
 Sh8IDJwRxdYsJ8DI6/Cg15HcrThz9zgwNJhukKGy8jTiH0vlRK58C3ZEd3CHCIzpiJ3nzz9NihV
 FBiWe4IKFAEiK3RndTiZd2Jk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eb4468346502167b;
	Tue, 13 Oct 2026 07:41:35 +0000
X-Mizu-Trace-ID: eb4468346502167b
X-Migadu-Flow: FLOW_OUT
Message-ID: <ed833aa7-90fa-4c44-a423-c5b689ede379@linux.dev>
Date: Tue, 13 Oct 2026 15:42:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
To: Abhishek Bapat <abhishekbapat@google.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
References: <cover.1791410885.git.abhishekbapat@google.com>
 <1f77364a04d0ae20cf07efaca779756f92ec39f6.1791410886.git.abhishekbapat@google.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <1f77364a04d0ae20cf07efaca779756f92ec39f6.1791410886.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i9pekeycmdt1eanux377xushbms1em5b
X-Rspamd-Queue-Id: 98B8440002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791877297-707584
X-HE-Meta: U2FsdGVkX1+U7qkjnYb9iw7ZXXEtbVDE9cKUZZLW2NY6j9KwvU+iMXvSol71uGVWdkofBy7LQ5aWCMBV/uUX9p/BKm7qvmraSoa3bKySgQ7wuUuwFPdwgKRF0QcXRchm+8833AZ3JOD/CgwtJMfhKL1nu5RcN7CvQjSG224hgyYLDScCUnHBhQYBHKY4uQ9I9djmf7wXPfvrSnNY8JRiTezk0IEseTg3BtOhhSgHau5HOEhSPP8FwappkHqLn43Tlpx1A6zPV37U50mWj2VlRBBJDidrV1Rs+8CLC/4PTXvtv5Oml9PqLHlDHxyXHt37jC6lZx5ojxKshG0EdMM/uqmDp+AzCnLhNJPIc2uRLFwc9n5wWVEIq7b3lr20EHF3m82e2b0ODBERKEGfYKb6gN9xzUiq+eU07sTnEmvwWnCDX5MR7aCNIGCQAf1yHANv4sZxaSAnpeHFaavzXJUZRDmbA3MD9Jod+sOifCkZi0Se9rzLL4ZPY6bNNvfPQs5sCstugx0xOm8jIGUqfskBEF024WheN/Jzkn4Ivaa1fZb4dJ9B2cvp5/ZRzDENulGxvgitvCrxY3wejfTTdDhQAkQIcQ81I/ArkcwjnWHmgO0oQXQYMbyN9HAZB5IdIosgynjry8bltGNy8pr6KodesYNDjAI91An/1xEGJemEuL1LvizH7cYu3EC/7pq1UCGyBr1QBwrRDykYsdxp4bz6FQ5XLL5xGia60PWI0vRttn1DppTEFfIPOoLi98ICxskSlb2DM9RdqPjddOKzJKmAgGoFhLD4YfjU254ewHli86sLfa1Pd7S2A+Y745JGdev02n69tRSwE1OiXLOeLL7fr6WXXaXtczpt8SiE5WnlprzQzvbNERjJLefY2O5e0wp4KCglWgm5Ig64yMOGFalP8QBfiV66HY2dFKxLJSTqBij8DsWpYCwOCUujENhyydYfjDQuni1RLSzWtJvMTgX
 /yhJ2XK/
 zvZEx6AW6Z1lGn7VXeh39PRRAcphJRSrJSJAC9+52TUJ6YxYqC7idHYzE8WsDKbddSSQ0EjM+/UnO768a6q47X9OYwqsa6aiCZIa1JqLJUeHwFd9BTa1kB9uw484ZdEfd4teIrlO+83+JU13goCPH/bjXxT3pKa+UBr3s6EU1Lzh6VIeR9XLA7Xw6AkIy0GvlG2wtsLGYCIcg7UeRHmEqoXcBnP1y5VhKIhd7DqoC+M5nFNTNJXmcaPHXeYS+IqK49kXi4dSw7kTM2XH68pfPXnwHVWFRnevamrTaGbMyMbIavoMQfXf2iLTl48TTBx/3X042wvI9CyEuD4UuxxHZJqaGbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek


On 2026/10/8 06:40, Abhishek Bapat wrote:
> Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> toggle tracing on allocation call sites. Userspace tools can use the
> existing filtering mechanism to specify the set of tags to toggle
> tracing for.
> 
> To facilitate low overhead execution for non-targeted call sites, add a
> new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
> activation. Protect these conditional branch evaluations using the global
> `alloc_tag_trace_key` static branch and an inline static key check
> pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
> This ensures that the trace events are entirely skipped when no
> allocation call sites are being actively traced, leaving only a NOP on
> the allocation fast path.
> 
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  Documentation/mm/allocation-profiling.rst |  20 ++++
>  include/linux/alloc_tag.h                 |  47 +++++---
>  include/linux/codetag.h                   |   5 +-
>  include/uapi/linux/alloc_tag.h            |  13 +++
>  mm/alloc_tag.c                            | 128 ++++++++++++++++++++--
>  5 files changed, 187 insertions(+), 26 deletions(-)
> 
> diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/mm/allocation-profiling.rst
> index b241450394df..63b668466342 100644
> --- a/Documentation/mm/allocation-profiling.rst
> +++ b/Documentation/mm/allocation-profiling.rst
> @@ -149,6 +149,26 @@ expose the full call stack and the lifetime of individual allocations:
>  - slab and percpu: the address of the object's `codetag_ref`
>  - page allocator: the `struct page` pointer of the head page
>  
> +Events are only emitted for tags that have tracing turned on and while profiling
> +is enabled. When no tag is traced, the hooks are behind a static branch.
> +
> +Enabling Tracing
> +----------------
> +
> +Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE_TRACE`
> +ioctl on `/proc/allocinfo`. It takes the same filter as used by
> +`ALLOCINFO_IOC_GET_AT`; an empty mask selects all tags. Size limits in the
> +filter are checked once, against the tag's size at the time of the call. Tags
> +already in the requested state are skipped and a -ENOENT is returned if no
> +tag matched.
> +
> +Tracing is turned off for a module's tags when the module is unloaded.
> +
> +Memory allocated before a tag was enabled has no alloc event but will still
> +produce a free event. Likewise, memory alive when tag is disabled will not
> +produce a free event. Tools should expect unmatched frees after enabling and
> +missing frees after disabling.
> +
>  Correlating the events
>  ----------------------
>  
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 49825177d8c8..94697b28053a 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(void)
>  				   &mem_alloc_profiling_key);
>  }
>  
> -static inline bool alloc_tag_trace_enabled(void)
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
>  {
> -	return static_branch_unlikely(&alloc_tag_trace_key);
> +	atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> +}
> +
> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> +{
> +	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE);
> +}
> +
> +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> +{
> +	atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> +}
> +
> +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> +{
> +	atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> +}
> +
> +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
> +{
> +	return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
> +}
> +
> +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
> +{
> +	if (static_branch_unlikely(&alloc_tag_trace_key))
> +		return tag && alloc_tag_is_traced(tag);
> +	return false;
>  }
>  
>  void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
> @@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_tag *tag);
>  
>  static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
>  {
> -	if (alloc_tag_trace_enabled())
> +	if (alloc_tag_trace_enabled(tag))
>  		__alloc_tag_trace_hit(tag);
>  }
>  
> @@ -225,7 +252,7 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
>  	if (likely(alloc_tag_ref_set(ref, tag))) {
>  		this_cpu_add(tag->counters->bytes, bytes);
>  
> -		if (alloc_tag_trace_enabled())
> +		if (alloc_tag_trace_enabled(tag))
>  			/* Trace successful allocs with their unique ptr */
>  			alloc_tag_trace_mem_alloc(ptr, tag, bytes);
>  	}
> @@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes, const voi
>  	this_cpu_sub(tag->counters->bytes, bytes);
>  	this_cpu_dec(tag->counters->calls);
>  
> -	if (alloc_tag_trace_enabled())
> +	if (alloc_tag_trace_enabled(tag))
>  		/* Trace frees with their unique ptr */
>  		alloc_tag_trace_mem_free(ptr, tag, bytes);
>  
>  	ref->ct = NULL;
>  }
>  
> -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> -{
> -	tag->ct.flags |= CODETAG_FLAG_INACCURATE;
> -}
> -
> -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> -{
> -	return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> -}
> -
>  #define alloc_tag_record(p)	((p) = current->alloc_tag)
>  
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index a25a085c2df1..f728295d50c0 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -18,6 +18,7 @@ struct module;
>  
>  /* codetag flags */
>  #define CODETAG_FLAG_INACCURATE	(1 << 0)
> +#define CODETAG_FLAG_TRACE_ON	(1 << 1)
>  
>  /*
>   * An instance of this structure is created in a special ELF section at every
> @@ -25,7 +26,7 @@ struct module;
>   * an array of these.
>   */
>  struct codetag {
> -	unsigned int flags;
> +	atomic_t flags;
>  	unsigned int lineno;
>  	const char *modname;
>  	const char *function;
> @@ -71,7 +72,7 @@ struct codetag_iterator {
>  	.function	= __func__,			\
>  	.filename	= __FILE__,			\
>  	.lineno		= __LINE__,			\
> -	.flags		= 0,				\
> +	.flags		= ATOMIC_INIT(0),		\
>  }
>  
>  void codetag_lock_module_list(struct codetag_type *cttype);
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
> index 7d4618bea043..dafcba2f7e2c 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -85,9 +85,20 @@ struct allocinfo_get_at {
>  	struct allocinfo_tag_data data;
>  };
>  
> +struct allocinfo_toggle_traces {
> +	/* inputs */
> +	/*
> +	 * Tags matching the filter are toggled; an empty mask selects all tags.
> +	 * Size criteria are checked once, against the tag's size at call time.
> +	 */
> +	struct allocinfo_filter filter;
> +	__u64 enable;
> +};
> +
>  #define _ALLOCINFO_IOC_CONTENT_ID	0
>  #define _ALLOCINFO_IOC_GET_AT		1
>  #define _ALLOCINFO_IOC_GET_NEXT		2
> +#define _ALLOCINFO_IOC_TOGGLE_TRACE	3
>  
>  #define ALLOCINFO_IOC_BASE		0xA6
>  #define ALLOCINFO_IOC_CONTENT_ID	_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_CONTENT_ID,	\
> @@ -96,5 +107,7 @@ struct allocinfo_get_at {
>  					      struct allocinfo_get_at)
>  #define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
>  					     struct allocinfo_tag_data)
> +#define ALLOCINFO_IOC_TOGGLE_TRACE	_IOW(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_TOGGLE_TRACE,	\
> +					    struct allocinfo_toggle_traces)
>  
>  #endif /* _UAPI_ALLOC_TAG_H */
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index ca2412a67312..262f00f2bba9 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
>  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
>  EXPORT_SYMBOL(alloc_tag_trace_key);
>  
> +static atomic_t alloc_tag_trace_cnt = ATOMIC_INIT(0);
> +
> +/*
> + * As `codetag_lock_module_list` is a read lock, we need an additional mutex
> + * to protect against the race conditions involved in the alloc tag trace
> + * toggle path.
> + */
> +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> +
>  struct alloc_tag_kernel_section kernel_tags = { NULL, 0 };
>  unsigned long alloc_tag_ref_mask;
>  int alloc_tag_ref_offs;
> @@ -296,7 +305,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>  		return false;
>  
>  	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> -		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
> +		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
>  		if (inaccurate != !!(filter->inaccurate))
>  			return false;
>  	}
> @@ -317,6 +326,23 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>  	return true;
>  }
>  
> +/*
> + * Checks that a user supplied filter only uses known fields and that its size
> + * range, if any, is not inverted.
> + */
> +static bool allocinfo_filter_valid(const struct allocinfo_filter *filter)
> +{
> +	if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
> +		return false;
> +
> +	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> +	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> +	    filter->min_size > filter->max_size)
> +		return false;
> +
> +	return true;
> +}
> +
>  /*
>   * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
>   * profiling data and returns it to userspace.
> @@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
>  	if (copy_from_user(&params, arg, sizeof(params)))
>  		return -EFAULT;
>  
> -	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> -		return -EINVAL;
> -
> -	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> -	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> -	    params.filter.min_size > params.filter.max_size)
> +	if (!allocinfo_filter_valid(&params.filter))
>  		return -EINVAL;
>  
>  	priv = m->private;
> @@ -443,6 +464,75 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>  	return ret;
>  }
>  
> +static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
> +{
> +	if (enable) {
> +		if (alloc_tag_is_traced(tag))
> +			return;
> +
> +		alloc_tag_set_traced(tag);
> +		if (atomic_fetch_inc(&alloc_tag_trace_cnt) == 0)
> +			static_branch_enable(&alloc_tag_trace_key);
> +	} else {
> +		if (!alloc_tag_is_traced(tag))
> +			return;
> +
> +		alloc_tag_clear_traced(tag);
> +		if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> +			static_branch_disable(&alloc_tag_trace_key);
> +	}
> +}
> +
> +/*
> + * Toggles tracing on every allocation tag that matches the user supplied
> + * filter. An empty filter mask selects all tags, same as for
> + * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not an error.
> + */
> +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_toggle_traces params;
> +	struct codetag_iterator iter;
> +	struct codetag *ct;
> +	struct alloc_tag_counters counters;
> +	bool fetched_counters;
> +	int matches = 0, ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (!allocinfo_filter_valid(&params.filter))
> +		return -EINVAL;
> +
> +	codetag_lock_module_list(alloc_tag_cttype);
> +
> +	iter = codetag_get_ct_iter(alloc_tag_cttype);
> +
> +	/* Toggle tracing on all codetags that match */
> +	while ((ct = codetag_next_ct(&iter))) {
> +		fetched_counters = false;
> +		if (matches_filter(ct, &params.filter, &counters, &fetched_counters)) {
> +			matches++;
> +
> +			mutex_lock(&alloc_tag_trace_mutex);

Could we grab and drop alloc_tag_trace_mutex outside the loop?


> +			alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable);
> +			mutex_unlock(&alloc_tag_trace_mutex);
> +		}
> +	}
> +
> +	if (matches == 0)
> +		/* Nothing matched the filter */
> +		ret = -ENOENT;
> +	else
> +		ret = 0;
> +
> +	codetag_unlock_module_list(alloc_tag_cttype);
> +
> +	return ret;
> +}
> +
>  /*
>   * Entry point ioctl function for /proc/allocinfo routing requests to fetch the
>   * layout content ID, seek to a specific tag, or read sequential tags.
> @@ -463,6 +553,9 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
>  	case ALLOCINFO_IOC_GET_NEXT:
>  		ret = allocinfo_ioctl_get_next(file->private_data, arg);
>  		break;
> +	case ALLOCINFO_IOC_TOGGLE_TRACE:
> +		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> @@ -492,8 +585,6 @@ static const struct proc_ops allocinfo_proc_ops = {
>  
>  void __alloc_tag_trace_hit(struct alloc_tag *tag)
>  {
> -	if (unlikely(!tag))
> -		return;
>  	trace_alloc_tag_hit(tag);
>  }
>  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> @@ -1031,6 +1122,24 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
>  	return 0;
>  }
>  
> +static void unload_module(struct module *mod, struct codetag *start, struct codetag *stop)
> +{
> +	struct alloc_tag *start_tag = ct_to_alloc_tag(start);
> +	struct alloc_tag *stop_tag = ct_to_alloc_tag(stop);
> +	struct alloc_tag *tag;
> +
> +	/*
> +	 * Turn tracing off for the tags of the module being unloaded. Without
> +	 * this, `alloc_tag_trace_cnt` would never reach zero and tracing would
> +	 * stay enabled forever.
> +	 *
> +	 * `alloc_tag_trace_mutex` is not needed here as this code path is
> +	 * protected by a `down_write(&cttype->mod_lock)`.
> +	 */
> +	for (tag = start_tag; tag < stop_tag; tag++)
> +		alloc_tag_trace_toggle(tag, false);
> +}
> +
>  static void replace_module(struct module *mod, struct module *new_mod)
>  {
>  	MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> @@ -1357,6 +1466,7 @@ static int __init alloc_tag_init(void)
>  		.alloc_section_mem	= reserve_module_tags,
>  		.free_section_mem	= release_module_tags,
>  		.module_load		= load_module,
> +		.module_unload		= unload_module,
>  		.module_replaced	= replace_module,
>  #endif
>  	};

