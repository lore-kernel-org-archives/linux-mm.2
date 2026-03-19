Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E1E5109192A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 22:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 698726B0095; Thu, 19 Mar 2026 18:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A5A6B009F; Thu, 19 Mar 2026 18:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EB06B00A0; Thu, 19 Mar 2026 18:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44D406B0095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:28:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1A6C14077D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:28:12 +0000 (UTC)
X-FDA: 84564252024.03.B752226
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11C19A0012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:28:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u2GRaSqc;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773959291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NxRP+rNYRzKmKCBpTsg1CQrlyZqPvLPg5mV8Q39hi4=;
	b=F6p59lwAnewlIHecYezTacQ7xF193w07E09D4btKh4a90GmagT/rNmMkxTNtS7MF6MQ+mF
	H5rr4aosc0VjZmTVFGLgWu3EE+KO8xcHmbrdacDkl9iIc2ZNPRcrylZ4hm9z7w9kFkewEV
	8zcUQHtWbyXkUi2Q91xIICbzCcwWaeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773959291; a=rsa-sha256;
	cv=none;
	b=HqKUn6Gr4diqg6+V9uB3YS2sLL1IspOD8+JkYBKxkdWE/LC6XGUGToorn6HGUGig4DkWRq
	Loi3MQlGDyLu6rQk+8+1qNmZdRq62YHknBnMjHPunqOtJWMDBN9CONL97XQZvD5HQnpMsL
	zkWrhf18+JoUS8VV3jnoDzgNrqvG/2A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u2GRaSqc;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB85B43242;
	Thu, 19 Mar 2026 22:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736A1C19424;
	Thu, 19 Mar 2026 22:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773959289;
	bh=HQBHjY6WL4dQJ8ojlBwwq31sBZ53V4/gE6x2BhV+bhM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=u2GRaSqcFmaR6OcoTkut2IibX2qv527mUSd91YmxtV55/w0woORr1WWAB33KRJP9K
	 Pw3euyn9AcAzIWO7wxJy0eTesPAozDjW5+wKhbfQBQ7rEg9XfN2LoO82Y13/6hHW0z
	 tsFCXs7woMStRrTxxy/Krwu+UiEHQpk6M9rt1vBQ=
Date: Thu, 19 Mar 2026 15:28:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
Message-Id: <20260319152808.fce61386fdf2934d7a3b0edb@linux-foundation.org>
In-Reply-To: <20260319083153.2488005-1-hao.ge@linux.dev>
References: <20260319083153.2488005-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11C19A0012
X-Stat-Signature: 3yhggowbit19mfarg5ik4bqe85q6s8ia
X-HE-Tag: 1773959290-20877
X-HE-Meta: U2FsdGVkX199SB/lc/NNYAtK0WUFBTxg3C9MV1CR9QiKvItUTaPgZREXbfbDR6+mmlokyCnd0AOxoj3sKtxi0MhZ+gk3YJke6r3xdTSOAwfaXoScBwHHen8NSffNMMAz6Ok/C3H+KpyYJELCiBjO/d8dRwR6O1K22H4REXmcPRZuswdto1/D35Wum1BYQAiPzu4gUfjsWdYb/chC1vsxeS/itRlARKwOUBYc9t6lzLWZ9zbAZtIO4hmhFSnd1d44i7yfQqqWrFqi22gt3MoNpZU1qwz2dqqF3R9VaIs0OTIfG4ino3bjERiTBnqg7VsMctLbaeIim8HnNCnytwtRDKBKC/pon5/zW4X2lcXq3bl+Nk5I6qb0UUjmt95U4ONpYMo4NqWpUkVpucjKvtkH5JtfK0Vq7EOkPaApcgIAtPAu30MvLSAAEAwkvqktvZp5XXvGc3eG1pLw8yzWFWTarcMgHm5KOn8ah+aV+yIlu0hbLPh+XyYylDgS5x8MBbGpVmUHv5UY8Zdot2jYo+meN0PZ9REObPbYb4dylcZy8RwJcLcwi2+NKQMR6DvpPVHqTyT+M9l+xEywupbEgtX+sjC9h2LsqT+bT5I/7ADgXTQ6TSKsewPMGPJb9UEjAaKyANPkHlVPwI2jVtQmIjMyIXiSWXhN4DVI1sRD8FPHaw8dhiL8ZXmqI7Gu3HIpmI2YyO8HhytW1aPVQDyHw1J36r25bip0pKiXsn1liMD+wFzQbH8ViPaDvgQIcieKqU7grnvKNjTO4HzJsR+pyBjGrWHAzykttpj7ltYE3XRgOLXhKTAQQBV1EHfifPefM+KncxGorgJcyuynTtvgnOJXTB0KPa9/vAET51xuhXn46ioyLtSrGm/703OF+8OGrQT7LsszA7suy4kwYMR11/EaPDw0JBJAYdeUJ0A8V7zFqQo5VGAfJ6qnWrZq1U87+DbSZBJQvsPh3xayRCp7cU/
 IXJBrwNG
 Ad9RyA+SrsW9SZoiF4M9OTAgl39ii5h6oOBHtoWygqkVYapxUXdX9otDxVrQvzYG+/BPM9oVgJwNuAcFGvHHaju++klBMpG8ibfVkkQk4e+zrlToQHY3ht/tDd2TLlVUzjW6a3gvsMSa0Fh7k+PnBije66xQmgUTj7ijtcEr1v7RdDWCXocHZJtifoeJ7iQCoJbnonpQykjRRpYXL1Nv3yLHVKY/KFZ47rrDiIpq1n6n1LLB2QDxMXtAI4Kg+yEN4l/fRlzF2JWVq9yzP0/Dui2vLcI8djBoUKQik/Pxf6q4TCv9dj5mTEGsC2WSb6zhMyRd4zAh28Ta1GYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Due to initialization ordering, page_ext is allocated and initialized
> relatively late during boot. Some pages have already been allocated
> and freed before page_ext becomes available, leaving their codetag
> uninitialized.
> 
> A clear example is in init_section_page_ext(): alloc_page_ext() calls
> kmemleak_alloc(). If the slab cache has no free objects, it falls back
> to the buddy allocator to allocate memory. However, at this point page_ext
> is not yet fully initialized, so these newly allocated pages have no
> codetag set. These pages may later be reclaimed by KASAN,which causes
> the warning to trigger when they are freed because their codetag ref is
> still empty.
> 
> Use a global array to track pages allocated before page_ext is fully
> initialized, similar to how kmemleak tracks early allocations.
> When page_ext initialization completes, set their codetag
> to empty to avoid warnings when they are freed later.
> 
> ...
>
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(union codetag_ref *ref)
>  
>  #ifdef CONFIG_MEM_ALLOC_PROFILING
>  
> +bool mem_profiling_is_available(void);
> +void alloc_tag_add_early_pfn(unsigned long pfn);
> +
>  #define ALLOC_TAG_SECTION_NAME	"alloc_tags"
>  
>  struct codetag_bytes {
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 58991ab09d84..a5bf4e72c154 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -6,6 +6,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/module.h>
>  #include <linux/page_ext.h>
> +#include <linux/pgalloc_tag.h>
>  #include <linux/proc_fs.h>
>  #include <linux/seq_buf.h>
>  #include <linux/seq_file.h>
> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
>  
>  static struct codetag_type *alloc_tag_cttype;
>  
> +/*
> + * State of the alloc_tag
> + *
> + * This is used to describe the states of the alloc_tag during bootup.
> + *
> + * When we need to allocate page_ext to store codetag, we face an
> + * initialization timing problem:
> + *
> + * Due to initialization order, pages may be allocated via buddy system
> + * before page_ext is fully allocated and initialized. Although these
> + * pages call the allocation hooks, the codetag will not be set because
> + * page_ext is not yet available.
> + *
> + * When these pages are later free to the buddy system, it triggers
> + * warnings because their codetag is actually empty if
> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> + *
> + * Additionally, in this situation, we cannot record detailed allocation
> + * information for these pages.
> + */
> +enum mem_profiling_state {
> +	DOWN,			/* No mem_profiling functionality yet */
> +	UP			/* Everything is working */
> +};
> +
> +static enum mem_profiling_state mem_profiling_state = DOWN;
> +
> +bool mem_profiling_is_available(void)
> +{
> +	return mem_profiling_state == UP;
> +}
> +
> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> +
> +#define EARLY_ALLOC_PFN_MAX		256
> +
> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];

It's unfortunate that this isn't __initdata.

> +static unsigned int early_pfn_count;
> +static DEFINE_SPINLOCK(early_pfn_lock);
> +
>
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct page *page, struct task_struct *task,
>  		alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
>  		update_page_tag_ref(handle, &ref);
>  		put_page_tag_ref(handle);
> +	} else {
> +		/*
> +		 * page_ext is not available yet, record the pfn so we can
> +		 * clear the tag ref later when page_ext is initialized.
> +		 */
> +		if (!mem_profiling_is_available())
> +			alloc_tag_add_early_pfn(page_to_pfn(page));
>  	}
>  }

All because of this, I believe.  Is this fixable?

If we take that `else', we know we're running in __init code, yes?  I
don't see how `__init pgalloc_tag_add_early()' could be made to work. 
hrm.  Something clever, please.


