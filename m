Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A5F0C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A8E6B0088; Thu, 24 Sep 2026 04:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51A816B008A; Thu, 24 Sep 2026 04:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4096B6B008C; Thu, 24 Sep 2026 04:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 192CD6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:16:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91E5B40215
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:16:47 +0000 (UTC)
X-FDA: 85247949654.13.1EBFB90
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf11.hostedemail.com (Postfix) with ESMTP id B270C40008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:16:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajv2nv9j;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790237805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZpaaxhg93AHnSRuQmnW7aJHjBTqxb2VTUtX52NwcAc=;
	b=PDf1aUEg8IKHrmf+0+AHQfZB0AlY/dpQYSDNH+VmzhlZDZgyiSXny8ltHxfuOy0QdgPEij
	c2zxtkizUvhnc+ftyy8aCXnmPoj6osXcceo+nyjrthkcs8Bwb5gMJ3Thtes18EkaVuQ9pf
	ZwtvSv5R6524md2WkrRExH/vjIHQJfk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ajv2nv9j;
	spf=pass (imf11.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790237805;
	b=KVUbnuIPsjNnRun5WmCWKFgFnlnwAGVQt3JLzDtnb6j7MCV7v+cbi6oRIxHPewtrKaWVr2
	/KayIV2xn4i1j+L2L2we3yoVQEzelW2E89uhdu7yqFWEAJh5I4LiWpglkL9bOq/AsHF2dB
	Or8v97y2zlyDVAQL53G6u7eejn54+P8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4zWOSTBNfGb9w1wTIc0wuOpgNTBigCOzpfBfTYk5Zus=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790237800; v=1; x=1790842600;
 b=ajv2nv9jhNgTG68frvsyQvul9M/2R9b6yiAg966ErSx5rCqi9b/0jTU473eNtaZMCviFPBRR
 cX7VzqwUjVdDuCHZUM01vR2VuDCMwO0Z4+4XMev01Knr9TfWOHEqPrcPMXqyRssF23SznuQhAil
 H0tCNzgY35PGFXSsz9w0oFxU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ece7adc700c99cc0;
	Thu, 24 Sep 2026 08:16:40 +0000
X-Mizu-Trace-ID: ece7adc700c99cc0
X-Migadu-Flow: FLOW_OUT
Message-ID: <0e2db0a0-663e-45fc-b073-126b8e80b625@linux.dev>
Date: Thu, 24 Sep 2026 16:17:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] alloc_tag: Introduce IOCTLs to toggle allocation
 tracepoints
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <cover.1790025465.git.abhishekbapat@google.com>
 <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <95bf63d2b9ef14f6610d6543b6892d266e4dc5c6.1790025465.git.abhishekbapat@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B270C40008
X-Stat-Signature: 4ifegyg5zn67b9tj65t3n1xeq9ypgu3r
X-HE-Tag: 1790237803-592583
X-HE-Meta: U2FsdGVkX19tLF+3WX0n/5puXRH+nxKbwGLBfmSkQY0tIicGKWMi1wL+EZ0XLt4g8EeaIKuDwp55e9riXmV2+6HNqi3ERRmpGaPzHzA4Qd6DrMslerjjG+m/StaQeO7KdwwHFv4PiIw+4abLoICDSGOnTOee3BsfULj2UMa8Cyoq/Z3+3GxKVAUtPBx4VlwVXY5+ljrrXKkCZnx1TiU/Nj5M4xG8U1MNIi1xU+8ntPO2zWhvppEanMa3xMe7FWjcjSTP1CYYbM2ujDN1MYaeMTcgzBl36lrwA4i13wvZHMbfTTEcb/VP7fejupys2JOxZE8e3T3C7mshC+/kniw48DyOmOS7XOON8NRSqADoRVqLV2TE525hBBZ3sH+WjuxD/ZK7XciqracFjxGX8UvyunEabOa/nep9w72VNkyKq0oWBMp6UEJi9xXb8UcFw0XRrgbeY7WjoE4P5yP9iaBKySWgSD3mfhpIPQOu9QYN+Hf7eMdaTEH/fHCiFQyj1uJposJ+P3KWzlGNFau8dtlFRZMTqceiZFiwhrFenLlSFRuFO91GX5BJ1hhvRu1TLLJPsJwAhHzSEvAz5UMdBYs3jVb4prBmoUk/0Lb4twiqAx9EY4HDpd6zYVPZaLAjxpgER4I3nr5cOCrzYlGnVSM61v+N0bXq92CDToqcj1A4aCFRBQWZYZby7YgeScBbfesFeDQ51bPA3em5Nw0zkjFbkNJSoDw4nzGT0Ti0+EIPfzpNTQxtRTzaZzDX7exAewG1lqZBEUkpDxx4ZurD+jq/QTo34eDtr+SsDXUg1ovcs08sl/A/OXXVvMrLu0CYIuXHT2tswzFoZP+pWuqQ8I2LhrYibEKAcNFP6m5z7/nhGZv3zzm5UHY7UpfdFN44qzz44Vo0+KrDGTCL1hlDSGmRDMrnAZYbSee9ReaVKzP6Ldq/Y3OVsfZil6+453oKR4VJZGDwASz+5FGWu7Mn55i
 7pNnuqvO
 MHJ2cQXYeek+osF57Q2EY+Udn0qcODyDL5+h+WPap2tgKm5Ra8+1cbp9Oin45mfcAvOOMK1CPO/DlU1dJm5NOQEJBKFgJ3xCd+uiYSCvBCsvyNoEcsHg50lkFECRApLtGaaI7pSgD1IvC6rz/09yc08LmQ55CB5wv939bUoUoY+/hXENWlAYg6kyb+4M79hiTol6hNFuVJ671C7coq7/bQYIHvWueOT4lgiReHPRD3Jx7XhC4byQ66m2PGTFgnTYazCak2IX0r+xl0cMuYw9iAl6k+h888rHW8HWyhMzAIaY/VEV4q35oZWq8u+YLTZ8h8qZZxUc8NQdCWnAfUarvKWTrFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Abhishek

On 2026/9/22 05:26, Abhishek Bapat wrote:
> Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> toggle tracing on exact allocation call sites. Userspace tools can
> use the existing filtering mechanism to specify the set of tags to
> toggle tracing for.
> 
> To facilitate low overhead execution for non-targeted call sites, add a
> new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
> activation. Protect these conditional branch evaluations using a global
> `alloc_tag_trace_key` static branch and an inline static key check
> pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
> This ensures that the trace events are entirely skipped when no
> allocation call sites are being actively traced, leaving only a NOP on
> the allocation fast path.
> 
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> ---
>  include/linux/alloc_tag.h      |  39 ++++++++----
>  include/linux/codetag.h        |   5 +-
>  include/uapi/linux/alloc_tag.h |   9 +++
>  mm/alloc_tag.c                 | 110 ++++++++++++++++++++++++++++++++-
>  4 files changed, 147 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 2994934cf44a..dc86f8997476 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(void)
>  				   &mem_alloc_profiling_key);
>  }
>  
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> +{
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
>  static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag)
>  {
> -	return static_branch_unlikely(&alloc_tag_trace_key);
> +	if (static_branch_unlikely(&alloc_tag_trace_key))
> +		return tag && alloc_tag_is_traced(tag);
> +	return false;
>  }
>  
>  void alloc_tag_trace_mem_alloc(union codetag_ref *ref, struct alloc_tag *tag,
> @@ -255,16 +282,6 @@ static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes)
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
> index 7d4618bea043..069ab8341e87 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -85,9 +85,16 @@ struct allocinfo_get_at {
>  	struct allocinfo_tag_data data;
>  };
>  
> +struct allocinfo_toggle_traces {
> +	/* inputs */
> +	struct allocinfo_tag fields;
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
> @@ -96,5 +103,7 @@ struct allocinfo_get_at {
>  					      struct allocinfo_get_at)
>  #define ALLOCINFO_IOC_GET_NEXT		_IOR(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_GET_NEXT,	\
>  					     struct allocinfo_tag_data)
> +#define ALLOCINFO_IOC_TOGGLE_TRACE	_IOW(ALLOCINFO_IOC_BASE, _ALLOCINFO_IOC_TOGGLE_TRACE,	\
> +					    struct allocinfo_toggle_traces)
>  
>  #endif /* _UAPI_ALLOC_TAG_H */
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index a5339767efd5..fb179321a2a1 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -61,6 +61,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
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
> @@ -297,7 +306,7 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
>  		return false;
>  
>  	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> -		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
> +		inaccurate = alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
>  		if (inaccurate != !!(filter->inaccurate))
>  			return false;
>  	}
> @@ -444,6 +453,81 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
>  	return ret;
>  }
>  
> +static bool alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
> +{
> +	if (enable) {
> +		if (alloc_tag_is_traced(tag))
> +			return false;
> +
> +		alloc_tag_set_traced(tag);
> +		if (atomic_fetch_inc(&alloc_tag_trace_cnt) == 0)
> +			static_branch_enable(&alloc_tag_trace_key);
> +	} else {
> +		if (!alloc_tag_is_traced(tag))
> +			return false;
> +
> +		alloc_tag_clear_traced(tag);
> +		if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> +			static_branch_disable(&alloc_tag_trace_key);
> +	}
> +
> +	return true;
> +}
> +
> +/*
> + * Toggles context capture for a specified allocation.
> + */
> +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __user *arg)
> +{
> +	struct allocinfo_toggle_traces params;
> +	struct codetag_iterator iter;
> +	struct codetag *ct;
> +	int matches = 0, successes = 0, ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	codetag_lock_module_list(alloc_tag_cttype);
> +
> +	struct allocinfo_filter filter = {
> +		.mask = ALLOCINFO_FILTER_MASK_MODNAME |
> +		       ALLOCINFO_FILTER_MASK_FUNCTION |
> +		       ALLOCINFO_FILTER_MASK_FILENAME |
> +		       ALLOCINFO_FILTER_MASK_LINENO,
> +		.fields = params.fields,
> +	};
> +
> +	iter = codetag_get_ct_iter(alloc_tag_cttype);
> +
> +	/* Toggle tracing on all codetags that match */
> +	while ((ct = codetag_next_ct(&iter))) {
> +		if (matches_filter(ct, &filter, NULL, NULL)) {
> +			matches++;
> +
> +			mutex_lock(&alloc_tag_trace_mutex);
> +			if (alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!params.enable))
> +				successes++;
> +			mutex_unlock(&alloc_tag_trace_mutex);
> +		}
> +	}
> +
> +	if (matches == 0)
> +		/* Nothing matched the filter */
> +		ret = -ENOENT;
> +	else if (successes == 0)
> +		/* Items matched, but were already in the requested state */
> +		ret = -EINVAL;

Why do we return -EINVAL in this path?
-EINVAL can mislead users into thinking their arguments are wrong.
That's not the case; the trace request they want is already active.
Maybe -EEXIST ?

Thanks
Best Regards
Hao

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
> @@ -464,6 +548,9 @@ static long allocinfo_ioctl(struct file *file, unsigned int cmd,
>  	case ALLOCINFO_IOC_GET_NEXT:
>  		ret = allocinfo_ioctl_get_next(file->private_data, arg);
>  		break;
> +	case ALLOCINFO_IOC_TOGGLE_TRACE:
> +		ret = allocinfo_ioctl_toggle_trace(file->private_data, arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> @@ -493,8 +580,6 @@ static const struct proc_ops allocinfo_proc_ops = {
>  
>  void __alloc_tag_trace_hit(struct alloc_tag *tag)
>  {
> -	if (unlikely(!tag))
> -		return;
>  	trace_alloc_tag_hit(tag);
>  }
>  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> @@ -1043,6 +1128,24 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
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
> @@ -1369,6 +1472,7 @@ static int __init alloc_tag_init(void)
>  		.alloc_section_mem	= reserve_module_tags,
>  		.free_section_mem	= release_module_tags,
>  		.module_load		= load_module,
> +		.module_unload		= unload_module,
>  		.module_replaced	= replace_module,
>  #endif
>  	};

