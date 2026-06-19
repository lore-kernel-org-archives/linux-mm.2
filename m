Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64D7ECD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 03:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F27306B0088; Thu, 18 Jun 2026 23:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED7B36B008A; Thu, 18 Jun 2026 23:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6D56B008C; Thu, 18 Jun 2026 23:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B00286B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 23:56:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2DEA440329
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:56:51 +0000 (UTC)
X-FDA: 84895301022.15.DD0F5EC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id EE095C0002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 03:56:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k2PYLv9Q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781841409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wifbDAq8EI2ICrdKxvkegaDG7NSADDww2zqkIubQQEo=;
	b=ihXPrWGQFMMJMj5C494x0wknyDkFlec0/9Ls+nhgZ7dCLsz9UxMOribzpv47EbBLD+4oLW
	acrqMbKVB7F3Ae5G3r3k4Fqp1bhMtm1N8SftFy3fI+HJfFZWjr/yp196zHN5HV1w8HHEPI
	VHj9ZP3Sw6/mBl4ZyJTr6c4ErVb33KE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=k2PYLv9Q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781841409;
	b=OiPvLQi1xJjY1JmH57Jul4hzkmG5dF+uFLbRVtaPdRzvhJ+hF4AZSAnW9rf2QgJMJbKCoR
	MTXZEanhfyxEptwlwqPe0q/g87UVQR2q7QVFGq4QVKc6o+0CXXGpyTtpuCqloi/A5yp4fh
	ZR4PNqQWZkATA6cH0glc0kZPMS+OG/g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wifbDAq8EI2ICrdKxvkegaDG7NSADDww2zqkIubQQEo=; b=k2PYLv9QnhBOWOz5lutAaTjL2E
	gBDfu3j5vo2+h/v2ddHGdFQP8/wbvfCGqoCev9d/49MWszhZkswgG5BRWqRCTfTfskI+oDo9nVSSe
	NcwmhKmKZojSPOnfXthpcZcehw7NYA6HxD3V70FvPaWc7N9bSoGTgS6aODg1Oxq/QmHhS3BCzusUi
	8LABhUTJwB5pAlxvp+pA1rds/ZKobwzcTETaBtOuoAUZGurdDrJ61NQEuqjopJDWXe5iwAJX5OB+S
	RUt8Jtc1JBSp+NYGDk4NC4fWxl70QvTNa2i/9HBexrgWnJtrDtaBXHP+c+KGd0W92l/EiiV25HCuX
	/d35Iy6Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1waQLB-0000000Fan8-44Uu;
	Fri, 19 Jun 2026 03:56:26 +0000
Date: Fri, 19 Jun 2026 04:56:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
Message-ID: <ajS96fWbG4dzP3u3@casper.infradead.org>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE095C0002
X-Stat-Signature: cne5isorb3f5au3cz1xm74kod8fq381c
X-Rspam-User: 
X-HE-Tag: 1781841408-594647
X-HE-Meta: U2FsdGVkX1/hY4XJz2LfRTnqkNAAWdBsRFW5D+458vKbh/IOsoNHjSiqxp7+cmY1APZ3N+lktIvS3L/VkFH6vj98BCG4ckAI2Ls4McHd9sQdsLbBIGTPYmGS+uVv67CDbtPyIWBuGhU2Rxk8U0xV1zRxBA5+sM77KiOt/hrr4obEJ3dKViiEONIHWDKP+lGTSas5+OG5CSyqjGmOUl1LR3F8l9RSIqRPzHUm3p/9A+4VPgbqLqOBlKpBvPCCpj4X6EV8qsuuB+Z2twTetNj7HV1Fn5XhZzQwIlffcKK6Ceg/zAuP9NBBY/TzC6XKtuEox6/VXomrwLdgpbu4n6675DAFMJ/W32Y6abKkR8MgcGFbNxgTHsahBYMvdK8aaK7KmvI6tBMu7UcwqxOrO86tYoOGW+3Tt/iAnyhiuxmd9uH0oeAizzXoJVezDH9qrCXgUAnDTdYeIGEMm/ZCaP3nNELH+NUn4tdLfSHDUwJipwlhMd5u0kKhHFRmPDREmz1OSFlnp+FMOoU7Z9m8AWxoUciHV2BjGVR/ZM9V9U4TtTBJY319Fctx3JdtK2CWGbho+0B1fF/IWSWhPn9AUY2kfQU+G3hJprF6drda8noUJ7gxoiObgfejumg8MondhDZ1ihp+4epDNPnYqRE7M73MwXJ2PUIn2h6nNFUODq9OoNM/IdvOlm1r94eQNg5KgD4JgHguJhTSdm3LCS4xiaKo1UYC4qotwSMG4kSFtW+NnTb9p/tHWC9gDqphh7Dh26rcjnTa0q5anjnUA1Fvzst/XCCaivDjiUtZQb+nP8CIOl3T+WH6o7MB4MUNJAB7m6pO6/+qqzrKM4pU/kFHJWfW600Plzz/3k2KbNFWezmOKYpWy9X/iPC1enLsKX0882uJxzTG34HRYrPz2M65ooIL8plpLxkwiAZ89G0l9dU1THFaJ1tK9MGAw6cslwAU1Zdzc+JczUqcyPxT8z7RjTB
 s5Qc7Azh
 eeLmKbLmiJk/yiNAx7TV891EmThWCskvj4S1PcEquc0GEbQhLMbH7Z1e773wmmVPpbStPJ+/jQ5VkRL4SzqfBiN1o70cktzXB7oj3Gv/e1zMMpYcNJhho5EjyqMekNyXEg9u8iPacXFeiIdIdkyV1Ja9OWJeagds0AKuHC/JUvJnQkXrvVbalSKjBgIvJRXheH/9FU5iLAugS7fvAkqx1PuASWQqHlVwj+hxFhJj0w+X5jyVWR5Kqkob0GawVWuVomo0RJTlUwnX+CwRqDB5esOtDIxRVpaBvGOYQe4SuBaACvHv7SrOb3IT/26laUsE/YMCvRVNngNyo/D7HAl5J1IqvvsJ2d5oVpMCEkaeIFTc/LHN17SHtXYqcD9tckk+VqyLWczMQvet+XKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 03:29:42PM +0000, Brendan Jackman wrote:
> +++ b/mm/page_alloc.c
> @@ -5253,24 +5253,98 @@ void free_pages_bulk(struct page **page_array, unsigned long nr_pages)
>  	}
>  }
>  
> -/*
> - * This is the 'heart' of the zoned buddy allocator.
> - */
> -struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> -		int preferred_nid, nodemask_t *nodemask)
> +static inline bool alloc_order_allowed(gfp_t gfp, unsigned int order,
> +				       unsigned int alloc_flags)
>  {
> -	struct page *page;
> -	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> -	struct alloc_context ac = { };
> +

Spurious blank line?

> +	if (alloc_flags & ALLOC_TRYLOCK)
> +		return pcp_allowed_order(order);
[...]
> +/*
> + * GFP flags to set for ALLOC_TRYLOCK i.e. alloc_pages_nolock().
> + *
> + * Do not specify __GFP_DIRECT_RECLAIM, since direct claim is not allowed.
> + * Do not specify __GFP_KSWAPD_RECLAIM either, since wake up of kswapd
> + * is not safe in arbitrary context.
> + *
> + * These two are the conditions for gfpflags_allow_spinning() being true.
> + *
> + * Specify __GFP_NOWARN since failing alloc_pages_nolock() is not a reason
> + * to warn. Also warn would trigger printk() which is unsafe from
> + * various contexts. We cannot use printk_deferred_enter() to mitigate,
> + * since the running context is unknown.
> + *
> + * Specify __GFP_ZERO to make sure that call to kmsan_alloc_page() below
> + * is safe in any context. Also zeroing the page is mandatory for
> + * BPF use cases.

It may be mandatory for BPF, but it seems wasteful for other uses.

> + * Though __GFP_NOMEMALLOC is not checked in the code path below,
> + * specify it here to highlight that alloc_pages_nolock()
> + * doesn't want to deplete reserves.
> + */
> +static const gfp_t gfp_trylock = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC |
> +				__GFP_COMP;

I rather dislike this being turned into a file-scope variable, even a
non-varying variable.  Can't it remain inside a function?

> +/*
> + * This is the 'heart' of the zoned buddy allocator.
> + */
> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
> +		int preferred_nid, nodemask_t *nodemask, unsigned int alloc_flags)
> +{
> +	struct page *page;
> +	gfp_t alloc_gfp; /* The gfp_t that was actually used for allocation */
> +	struct alloc_context ac = { };
> +
> +	/* Other flags could be supported later if needed. */
> +	if (WARN_ON(alloc_flags & ~ALLOC_TRYLOCK))
>  		return NULL;
>  
> +	if (!alloc_order_allowed(gfp, order, alloc_flags))
> +		return NULL;
> +
> +	if (alloc_flags & ALLOC_TRYLOCK) {
> +		VM_WARN_ON_ONCE(gfp & ~__GFP_ACCOUNT);

So the only GFP flag the user is allowed to specify is __GFP_ACCOUNT?
That seems bogus; other flags would be reasonable including all the ones
in gfp_trylock, as well as GFP_HIGHMEM, GFP_DMA, GFP_MOVABLE, GFP_HARDWALL.


