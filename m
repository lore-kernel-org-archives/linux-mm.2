Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27776C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299F96B008C; Mon, 14 Sep 2026 09:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AF56B0096; Mon, 14 Sep 2026 09:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A7F6B0099; Mon, 14 Sep 2026 09:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E66B46B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:26:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7143C140143
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:26:47 +0000 (UTC)
X-FDA: 85212442854.29.F649BED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 96F0F180015
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:26:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVfA7IiV;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789392405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlYwFRzA7o/DVEj1e1cnP7ktHjtNeLhR3AAaGHH8Ug0=;
	b=Tm1mdpF8AiXlfDbnUREt/IHkIMfc47399sSaI2Z20X0icxdndxjR+aRvDwJIIFJIapjFCW
	XXxoBidY2t/f+rTtZNFsnb/vw/oMLWKJR0kmvTSSNL4gsAZvDg2QBHmN9DbDrpefyROlc0
	EcQQO1JSs5CxFi8nIw8tfNKD+q8YidU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789392405;
	b=hW5t8hQu7U6YGKMi0s4hbi6vrB7iLSc7PPDL5p7taKUFYrF5+fkjW+9pJBLz0cfXMcWllT
	VdHjhwtd+N83CFbemTnBEFAt0s9J8XKs6or68J48bJ6L8OZ6JZMCntgLDWESriYjWRi5AQ
	tIFBdoCyPZVn4+VP7N7U1pFj9dmQqIc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LVfA7IiV;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DADA341FFD;
	Mon, 14 Sep 2026 13:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD861F000FF;
	Mon, 14 Sep 2026 13:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789392404;
	bh=YlYwFRzA7o/DVEj1e1cnP7ktHjtNeLhR3AAaGHH8Ug0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LVfA7IiVasTAzRSrRiQszUUtDWQYqay80S/mtUAUne2QZDkIdnbFlLxSzuw89mGL2
	 kzFDYBDe3UKTXgb2xTp5/yrZ00NOM8y1SB3368cKIYF98nTIPL2FKjONdAtxkxUEuv
	 5eGR1Q1I2RYvrXYTaGWW6KJWotvtq7YNnFqeRz7jffklbi9fqKi9Uzsn5YosJfcQLt
	 j4p23sZ8KdrtPEGIdDa6u0v/vp3uWj7kUL0H9qWQdLZKrKbU5g6b59w8EXk5VIyasd
	 9ibkY0UkNJyk5bb+Zf2ReOn1IQYH8x1PxVPvY0Ce5u+/9OmmwJ3w6Dmb3gQHicSR3Y
	 E1XcXKJKkRGJg==
Message-ID: <37f9a01c-4f6f-429d-b221-73ceffd55369@kernel.org>
Date: Mon, 14 Sep 2026 15:26:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/16] mm/page-flags: check page/folio->private instead
 of PG_private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Jan Kara <jack@suse.cz>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-fsdevel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-10-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-10-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: knkn9zhn1q13j83m5agscnj1buncct1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 96F0F180015
X-Rspamd-Server: rspam03
X-HE-Tag: 1789392405-442775
X-HE-Meta: U2FsdGVkX18Bv+BK8wCgEMwwBl1NxOCVczcXCWiGrr94RuIHF5fr+/QZavmgwxFMoX9PrzIUcdyc5rnFfnLpKy1++QABVjviQv6j0uZ+Y0MrWXRDGLaQBiS7q83J9BSrKYKfUYEnDLiT/AN8QvZ3AHAslDmvZtsdcMp+WOyiBpO4rED7pApdIhEAqMqA1RC6CU/j+Zdv1G3W+eC94J/gfyl03AONuyA2IBzhYH+KLP/Xr0TkmuZ9rzzZGUvvrAWW5kcrz9pQIb7tx2MgYBmlDg+tlotJLOp52D1rkkZZUt39iCs3jJ7xdLjMaQi93lMfg1dnZ/RqldV5NA38R1gIkSuE1ndPP5emZMAULg29vfTLqULaSrW7ORxyAwDvwf5oI3ZEj7GloMB9Cr+W7TI39jHznobYB0SEYz2p7Afe7GQC5t9CRhUmsG58fAKnycSINKkXvVi5bnB+Ei48Nh97Ig9SAx4JqdTh97YFh1pz6nRsFBh7FcAfKivaVdaW3pFlNNd6oCY2XVMDWORQbPefnLioN4Om3F4tXcFxuVzXufOCYaU7yYuTacyBjsZFnquWIfMz7FrSI0enDtM0/BehzxXed69LDFrEGme+uiIJ9eoWCXEUVF4Gw/+Oih8btD1zZkF208zmLCn0c+yPEZlMhvbEfBeY8FMJtk47U9CrY/Otrg3zpFnpdhZoQnWp02pkQov4kQSTVsFSgPoz/3hicWqf1VpGHB2EjyjitJigm/2ab4JFwKVGVJW9zZBjQiF+QqMxjW9JPzpTpYcvpcdYmnDXvYnrlifL0FhH3RtXexQSH1AxIji57jSOnUB67qWUEIhVKfUDjC7o2y7wc0R0AFilLqzxekR1qIRjXZo/2v6SvKi1D8xEIj/0f73zQKcKGWdYZqxeSll9D0wvDOwyak7X+vCWD5IQk12uuKYtbA7QjRKrNaN3vSjALvO7uqGrrOUt/roHH3d/vJggYX5
 yifEftKW
 XVXak+qYD+//eeBZgGj2w54RrT5dItetyxBm2Blqs7mVwvcFrIrFJqkEOxJF5yqAPORpC41WB2OvHL2/IIXrVqXv/Besbox2rcQegnFh18Y3lEIbfawtGll3imOcOwuN+aFXD9BG3oJrYrLqRDmYZbCS7co9vQaARAT8gMSzkMFA6dIamY5jqk+3ilJdQ4z0aHumZtAXJS1kaiMfEv00YIjXi81Dd+Yy/7cLZ0WUrwznC585/3pXwUKIAQjKxGYiIRMfv1HOi5YyydlC2okVRk/O/29Mv+HEyJvTYUG2oDubLIjdEBxcZ5MfwlCXezitJNCtkx8FoSQq8KSS8dc2n4lzZAkwhfr9erLeHCEAwHRzBcjmJSagAAohFzHryrVajprnn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> After the changes of the prior commits, page/folio->private != NULL is now
> equivalent to checking PG_private.
> 
> Stop checking PG_private on pages and folios and use page/folio->private
> instead, except swapcache and hugetlb folios, because the former uses a
> field (swp_entry_t swap) overlapping with ->private and the latter sets its
> flags in ->private. Exclude swapcache and hugetlb when the code is meant to
> check PG_private only. PG_swapcache and folio->swap.val cannot be set/clear
> as a whole, so excluding swapcache with folio_test_swapcache() is not
> reliable. Instead, use folio_test_swapbacked(), since PG_swapbacked is
> stable when a folio is added to/removed from swapcache. Add a helper,
> folio_has_attached_private(), for this check.
> 
> folio_expected_ref_count() can be called without folio lock, so annotate
> folio_test_private() with data_race() to avoid triggering race condition
> checks. While at it, annotate folio->mapping too. Add data_race()
> annotation for other lockless callers too.

Shouldn't we just move the data_race() into folio_has_attached_private() and
document there, that it can be called without the folio lock as well? Having the
data_race in multiple callers looks odd.

> 
> folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
> PG_private is no longer checked at page free time.

You can mention here that we will clean this part up next, to remove these
helpers entirely.

[...]

>  	}
>  
>  	/* One reference per page table mapping. */
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 462e89e055485..08988877331ba 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -577,7 +577,23 @@ FOLIO_FLAG(swapbacked, FOLIO_HEAD_PAGE)
>   * for its own purposes.
>   * - PG_private and PG_private_2 cause release_folio() and co to be invoked
>   */
> -PAGEFLAG(Private, private, PF_ANY)
> +
> +static __always_inline bool folio_test_private(const struct folio *folio)
> +{
> +	return folio->private;
> +}
> +
> +static __always_inline int PagePrivate(const struct page *page)
> +{
> +	return !!page->private;
> +}
> +
> +/* no-ops during transition */
> +static __always_inline void folio_set_private(struct folio *folio) { }
> +static __always_inline void folio_clear_private(struct folio *folio) { }
> +static __always_inline void SetPagePrivate(struct page *page) { }
> +static __always_inline void ClearPagePrivate(struct page *page) { }
> +
>  FOLIO_FLAG(private_2, FOLIO_HEAD_PAGE)
>  
>  /* owner_2 can be set on tail pages for anon memory */
> @@ -1169,7 +1185,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>   */
>  #define PAGE_FLAGS_CHECK_AT_FREE				\
>  	(1UL << PG_lru		| 1UL << PG_locked	|	\
> -	 1UL << PG_private	| 1UL << PG_private_2	|	\
> +	 1UL << PG_private_2	|				\
>  	 1UL << PG_writeback	| 1UL << PG_reserved	|	\
>  	 1UL << PG_active 	|				\
>  	 1UL << PG_unevictable	| __PG_MLOCKED | LRU_GEN_MASK)
> @@ -1193,8 +1209,28 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
>  	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
>  
> -#define PAGE_FLAGS_PRIVATE				\
> -	(1UL << PG_private | 1UL << PG_private_2)
> +/**
> + * folio_has_attached_private - check if the folio has private data attached
> + * @folio: The folio to check.
> + *
> + * Use this in code that may encounter swapcache or hugetlb folios but only
> + * wants to detect attached private data. Swapcache stores swp_entry_t in
> + * folio->swap, a union with folio->private, and hugetlb stores its own flags
> + * in folio->private; both are excluded.

This is an implementation detail that is irrelevant for callers. Move that above
the actual checks in the code below.

> + *
> + * NOTE: For swapcache, folio->swap.val PG_swapcache are not set as a whole,
> + * so folio_test_swapcache() is not reliable to exclude swapcache.
> + * Use folio_test_swapbacked() instead, since it remains set when a folio is
> + * added to/removed from swapcache.

Dito, a caller of this function doesn't care.

> + *
> + * Return: true if folio->private is set and the folio is neither swapcache
> + * nor hugetlb.

Can we remove these implementation details here instead and talk about "true if
the folio has private data attached" ?

> + */
> +static inline bool folio_has_attached_private(const struct folio *folio)
> +{
> +	return folio_test_private(folio) && !folio_test_swapbacked(folio) &&
> +	       !folio_test_hugetlb(folio);
> +}
Apart from that LGTM.

-- 
Cheers,

David

