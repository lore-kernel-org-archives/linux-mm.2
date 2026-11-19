Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47EA606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lRSsvKq9
Received: by kanga.kvack.org (Postfix)
	id 05E3F6B05CE; Thu, 19 Nov 2026 08:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034B26B05DA; Thu, 19 Nov 2026 08:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8D936B0646; Thu, 19 Nov 2026 08:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B98126B05CE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:23:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43657A893F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:23:35 +0000 (UTC)
X-FDA: 85451935590.14.6972F9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 848A1A000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:23:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRSsvKq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795094613;
	b=YTf1YXj5eXZl/t4A5ADKTvdx/PAAgEZa4h6CU15U0+nAOzNOLu7Ci7HfpBMbXZfZJPv4qB
	XxLO429pgIiW9lsRZt9EpDfmFzeYk23Ld+cS54RN+wlXUluxdaONH98wcs3yVP+P7fYoBh
	4TdeGaJXfbeJw1iNk0mcUjCZWu5OJMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795094613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTpzirKbp7wgHPt5BJeerlD4lUmv8WbyAY5FQdaUO/o=;
	b=r61/ch6kRQRwEcFUW98NeiweG8JAnLVW05HJXbLO0m886Morq8f3ppY3PatiXI2yMhT4Qi
	RK1/fTVAB/G5qcAGgE00l2MiOlZ4i4yB0CtNxSaVy9t94qpEHc7kBIxCiGk9zje3P0IHgi
	+oq4SU+sUFYVgKLOhfffyExz8DBkHD8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRSsvKq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9132840B84;
	Thu, 19 Nov 2026 13:23:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29741F000C5;
	Thu, 19 Nov 2026 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795094612;
	bh=NTpzirKbp7wgHPt5BJeerlD4lUmv8WbyAY5FQdaUO/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lRSsvKq96cZP+ZvRxMNmPxuVc7KhlNo9eMqm29qw5DCKm45kIjq33tGklLv9RPJtf
	 t6RczbudOiO2LMymrjP1y6LNb0aKcSGmOGp5FyT39efpLlLCf4U5LM+D+0c/GEkpEk
	 gzlaW5UItrxJlnlfb6IGjMLEfo+1drnDc6D3D5fDt3ljoFk7YVMqR5uyF224lzM8BC
	 YpzLpMQHBIf97+teq849ecYAptGyyN8oUAFtXco7o1CZm37j9zpvCmiY+QZUqaDYUX
	 tgLbo8AGY4TxoMAcqT7WjgnDica4lHZWfD+Fxm5cNuVOxC/Nms9Huo8Cruy2SVPeqx
	 icQJxqxZWq4zA==
Date: Thu, 19 Nov 2026 14:23:26 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Nilay Vaish <nilayvaish@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_owner: fix double decrement of stack count on
 unpoison
Message-ID: <av74TpCUPQkXFkOH@localhost.localdomain>
References: <20261118212819.403059-1-nilayvaish@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118212819.403059-1-nilayvaish@google.com>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 848A1A000C
X-Stat-Signature: edybj6nae3mf3jh756cqro6dogksaibr
X-HE-Tag: 1795094613-726010
X-HE-Meta: U2FsdGVkX19XgGlSp9aJ7NYH+cEN25WFEj8ooZbrH/fyJ/h5ijzJaKzNKxYgA6CQL+HyqtXp28mVXzThf2N20rfwYzu6Sn+bCLaCRMlEyspzsQxkdSdmTK7QcYBpZ2ch/pfpch8sIpFWrCz54bUCzq26G0mmGGlcb0KwcfSfaTc0Fo6GmoELKVtFHd9rtxx+5k3OsNhgVP9OQZ1pNQhN9h/2Svi31OF76AN4A3xNNRN4L+PLBeC8JvpIHoQhJ5By3sFU1gMkjYDFESv/uyVQTXpU0fhMeIbcR6l55TYuitVSWjw9X9DltEGslvCbrnIYkGQSOA5AzjsCaVs4fPPNZ8JYNUv3drbx81Hr85cDhk7bpffRrIaC5Q9sCFHb1Ae5/DZgW0bflloBSdYGMJzej+eSzaU79ji+oM9VlKu47/W0TgxdXc2KjGqtjwJ38F1lrgYs3nr5XDFrXm9BG7h6T0Yf1sZWn776yo3Gp5CqLN160EY1+TBTP5sU/A61nAb5febjZqN2fHFGk0/uw+b6yBM1Vvy2rxagMVVNZYrXYMIPxSt7nyDoY8cW0zD7PGwMXgmHufYKUh0WjSvetLE31ZZvxnwi18TC7FZ43tSfHOPrfvqoLVgtrvAMrQOzs6wqPbHhJPd0sdlckxqfqFlgv15z84ssBTz4n3vXOJxbog++H+6EkM5CJekIgqkw6gWyxM23ZVtjVNNebDqXFSjju5Cwm+BVC5CYcTcz+8cBpZbdgEnJJbEozglfvCiweS24Y0WwF/+vfJkdVBkYp7qk5mpRPPrXJuZEjNK67RTYXlj227jvf8nkxmqmQqYVd7CqzhUaCXfTpvbb0UYsNHAv2yQxQErk5Q0pR7Sj11s4NTwzntH8p54rUdGVqCkunXKzgf4JfjSC/shVuGCzaRvrkHeKJ/TNt4cgEA6tmyQY7FDQJfzI0JGMspbWFI10upDLPCChiNBg0UqLEQTzv07
 dp2oqbuG
 BRC4ZUPABYDCNKfmMZHU1VlLHLg0eacwCDE6t836OfWVRDBER+Oi2fX+NzkxeJdEgOJqeO8QO4LTYQcy39cHLPZ8nzCrP3r7bwymJ28FggbzLn/i+ku9OOQLZpHRUgVxbCchrhEC/H14l8WGp7ZwEftTdFso66KiuqjaNI6NG/huWThv/A21+T5nA+iRZMq6cA8dd+c4cNJjP/y/KXgCg1dPCZfdVpJUn1h2O3BTNbMYMJni+YpV8FXfpQGD10jHSWZW/qBeH6mQXBtTqKCwO8d/ggwnYlKumaXXYKVuNInFT1UGIIhZb+J4XvKRPjiGcwUC72QlHJbfCiiFy549O6ahk0Ydbh7WIaecfa2EYFZ/f3Ywk0fVtwc7Hngv1ZgDaBvFBxYsmqkAnmGdG/IQ6Dj8hYPCwisC8er2h4bXNn6URA4/rSS2HvxvQ3e81NuyhskFgvXEkc3pgRmLnMuT8LpUc6Ifxi1hf22MWsWambxDnO37qX1wfzePD8Lb/RVD7v0lvNXVx6aEq2EkGhzlHOAXB5LNURrL6iSGZtOV5ckdP0WK6D6pEvMPIJa4O5LhLgx4P6Ss3+jHN2LLm413P3qotovVsyO47qzkg+9cwjp6p0l8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 01:28:19PM -0800, Nilay Vaish wrote:
> page_owner counts, for each allocation stack, how many pages allocated
> from that stack are still in use. The count is incremented when a page
> is allocated and decremented in __reset_page_owner() when it is freed.
> 
> A page that is hwpoisoned while in use and later unpoisoned passes
> through free_pages_prepare() twice:
> 
>   1. On poisoning, the last reference is dropped. free_pages_prepare()
>      calls reset_page_owner() but, because the page is PageHWPoison(),
>      keeps it off the free lists.
> 
>   2. On unpoisoning, unpoison_memory() drops the poison reference and
>      free_pages_prepare() calls reset_page_owner() again, this time
>      really freeing the page.
> 
> __reset_page_owner() decrements the stack count both times, although
> the page was allocated only once. The first call clears
> PAGE_EXT_OWNER_ALLOCATED, but the second call never checks it.
> 
> If this drives the count to zero while the stack is still in use,
> stackdepot treats the record as freed and warns on every later
> allocation or free that uses the same stack:
> 
>   dec_stack_record_count: refcount went to 0 for 92274844 handle
>   WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x5c/0x70
>   Call Trace:
>    __set_page_owner+0x110/0x290
>    get_page_from_freelist+0x1225/0x1440
>    __alloc_frozen_pages_noprof+0x1fc/0x1b00
>    __folio_alloc_noprof+0x12/0xa0
>    alloc_migration_target+0x81/0x1e0
>    migrate_pages_batch+0x1f2/0x14c0
>    migrate_pages+0x9c3/0xca0
>    soft_offline_page+0x189/0x570
> 
> A single soft offline followed by an unpoison is enough to trigger it,
> because the migration-target stack that the offlined page is accounted
> to usually has very few pages.
> 
> Fix it by decrementing the stack count only if PAGE_EXT_OWNER_ALLOCATED
> was still set, i.e. only the first time the page is freed.
> 
> To reproduce, boot with page_owner=on and CONFIG_HWPOISON_INJECT, soft
> offline anonymous pages with madvise(MADV_SOFT_OFFLINE), and unpoison
> each old PFN through debugfs hwpoison/unpoison-pfn. Without this patch
> the first cycle prints the message above and 2200 cycles produce 6597
> warnings. With it, the same run is clean and all stack counts return
> to their initial values.
> 
> Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

Nit below:

> ---
>  mm/page_owner.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 02bb304b53cf..0793a460d615 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -320,11 +320,13 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  	depot_stack_handle_t alloc_handle;
>  	struct page_owner *page_owner;
>  	u64 free_ts_nsec = local_clock();
> +	bool allocated;
>  
>  	page_ext = page_ext_get(page);
>  	if (unlikely(!page_ext))
>  		return;
>  
> +	allocated = test_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
>  	page_owner = get_page_owner(page_ext);
>  	alloc_handle = page_owner->handle;
>  	page_ext_put(page_ext);
> @@ -339,7 +341,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  	__update_page_owner_free_handle(page, handle, order, current->pid,
>  					current->tgid, free_ts_nsec);
>  
> -	if (alloc_handle != early_handle)
> +	if (allocated && alloc_handle != early_handle) {
>  		/*
>  		 * early_handle is being set as a handle for all those
>  		 * early allocated pages. See init_pages_in_zone().
> @@ -348,6 +350,7 @@ void __reset_page_owner(struct page *page, unsigned short order)
>  		 * their refcount either.
>  		 */

I would expand this comment to integrate the allocated logic.
Because someone might think that every page hitting this function should have
been previously allocated. 

 

-- 
Oscar Salvador
SUSE Labs

