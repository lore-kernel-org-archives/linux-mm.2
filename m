Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1405DF34C6B
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 17:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489516B0088; Mon, 13 Apr 2026 13:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467A96B008A; Mon, 13 Apr 2026 13:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3798F6B0092; Mon, 13 Apr 2026 13:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2934C6B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:43:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C18751A02D0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:43:54 +0000 (UTC)
X-FDA: 84654255588.18.559E257
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73589C0009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:43:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cKwV1QYz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQe3Mkfb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cKwV1QYz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQe3Mkfb;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776102232; a=rsa-sha256;
	cv=none;
	b=7VaaD8hWX2tWRHd95ru9FhdH+EutsqX56CdC449BIynS+PV6u0cgw6KWhoHolbuo0ut8am
	/P5rYhdmEeRr9ZcNfzd0MVhKCJ8F8An1Ivb7b85AM9VDqjJrU+k8Bw8GLg/mu9xzbCM5Td
	RdHJsxFQSzZydHGMdfSirJB0yOHxthU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cKwV1QYz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQe3Mkfb;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cKwV1QYz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rQe3Mkfb;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776102232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6FuKmcXLR07Fw6pjG6z+dAgssBozguHf37YZWpjsEQ=;
	b=21hBwU+BE5DtaimTBJLsc8vdXBgL7FjYh8BifqiaFnFx7Vh65Y9djLJeeBtdtCr2rg0AaY
	2h3btOo0cYKrX6HIm1T/sa0IjrldTAK3Qi45tB+81dcBeLkmVp9iLsdA7Tq/vrQKAPT+aL
	xhL3/gnIu93uPRvpKTMQ4psmomCROvM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B60BD5BD3E;
	Mon, 13 Apr 2026 17:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776102230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W6FuKmcXLR07Fw6pjG6z+dAgssBozguHf37YZWpjsEQ=;
	b=cKwV1QYz1GSOpXcoJnqcN01IEtlRs793+honbozuKFEC8VyeP3SkJtPP6t/oQgHWclBGM0
	FUCX939RJ7zw0DgJeXe+G+xkHhqvaWcJ7pEWBC3PYuOGlO7XKwHIyofmhEImtDJUEcALkL
	Sad0YRziyKt2CAt8eSsneiA9W1NChSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776102230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W6FuKmcXLR07Fw6pjG6z+dAgssBozguHf37YZWpjsEQ=;
	b=rQe3Mkfb+UKAwYCDfjjuovY8Tr3CSJ19JO19jRWk3nIYkSYZoNgvHRHHWscAB3C3xgCGxG
	aedN/zUVhwMAMDBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776102230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W6FuKmcXLR07Fw6pjG6z+dAgssBozguHf37YZWpjsEQ=;
	b=cKwV1QYz1GSOpXcoJnqcN01IEtlRs793+honbozuKFEC8VyeP3SkJtPP6t/oQgHWclBGM0
	FUCX939RJ7zw0DgJeXe+G+xkHhqvaWcJ7pEWBC3PYuOGlO7XKwHIyofmhEImtDJUEcALkL
	Sad0YRziyKt2CAt8eSsneiA9W1NChSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776102230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W6FuKmcXLR07Fw6pjG6z+dAgssBozguHf37YZWpjsEQ=;
	b=rQe3Mkfb+UKAwYCDfjjuovY8Tr3CSJ19JO19jRWk3nIYkSYZoNgvHRHHWscAB3C3xgCGxG
	aedN/zUVhwMAMDBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EEFE14AFE5;
	Mon, 13 Apr 2026 17:43:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DCwUOFUr3Wm0QAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Apr 2026 17:43:49 +0000
Date: Mon, 13 Apr 2026 19:43:44 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take
 PAGE_SIZE index
Message-ID: <ad0rUB4FuNUOJ1pN@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-4-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-4-jane.chu@oracle.com>
X-Stat-Signature: 8fognxh1qpgoxm9ng5mobm3z45u5xk1k
X-Rspamd-Queue-Id: 73589C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776102232-954877
X-HE-Meta: U2FsdGVkX19umfJ1ftezAl4UkbpOusdX+NCYNhau5FwPaAQ54bTedIHgsodmyqGJTx8DzbFEbv9Oupl0uNL8jxG5eRIK5YshF+c5p83yrpAGgH2TCrAjWHPZl3fWEOoQKoq0DH1+5+9baE4p4ET3avWflh8LD2NMzkqiuwJafu6stbE1phWyDk+ak6cyRi4kJ8ZQIGj/B5IlHJHIKAFKQqXybteegAcZUEHBRiN+0/poxu1lbnl5WbohtkAUalqhDLKU3KC1KUUZEgA7YDl4v8dxcdULm4vNAPDcsIcMb696KDcajB1KqRe6eUuFMomh4NkOqlk0NGXcEBTUsfU/ZL2BCLTkyYOqGLUvxZQ6geTJbtZ5H7fjjAGcIKMThsh3J4qCeZbDiB41DvSZUXkNRG39oufVKiN23fa1RDww3h7vdXsmI+ZVCJnDvPmNhvK8xnrGczcPJQLYYJIkw8rRM2XyKzsAnHK1ZZU9K7s6sDru1n2x8gpXAKdCncXU0J/LzJ3jx695WPAcrRzIjDQtwEUfNxdxjULUPxiFdv4lrperMG+Xl3+Ef9PYhtldJi9Yi31etC6mLtSxAbJdSSYj26nv9JkhGqN/3kmSSBOzy910nWplL5FuOmgQ/Z73SB3jzcat+ykOomgFnDCf0VnxPMXZdQ0z9bz+u6unwM/zCUFoFdG9b8LjiBcMzK7v0xg6U6UHtL9MhpDDfrf4Y/FBDXjpUxpGK5XewoVCdjtUzrrVpWVSlwbDvqvkrmPJFf4+NLWyka8skIGNrZESPjJWfPpVr3Zcf7wrbF94SXTb9H1+JKFen7G6zTfMZ9AFXXW5GlR9ShQwrbe4yGdnY5uV90FqOTOMjLmGbgPSiyoonpowSlL/SbLR7Mk845HHZWUQh5bXvUk4775v33y4Lw6caCPTjKrOJvvpNDHouNc8zdld9a+lP4IgmvC8gKrO5liB4Po2BnEKjr7nvZt/zGR
 HsRjEp1B
 nidhAchjTE1jH/H6P3fjRK/ILYJ87Q9QLGpBTTmdl/jHlmdxzcSXcAHjCc7+UZDaXhIeP6a1Cr3iKc0YcItSLEr3lgxH+Zwwyb5SW/C9yX9f+ribyK41z5W3SZYbgqWBo8a7ZrElFKDPeFGaX/LjFWjPlKAFtn+iNNMkA0E/PmVgpqitT4E6Yc3UiGQhZoQUqLfFI1/1oRVQhCPx2uBhQBia6u1Ek7Ugpu12IJTdAsst4i7EoEiHBr7umb6mtCt2rOPnhCMoRfsIaCn6DCUAcAyZ4mVgwCg/smYFA0l6DzHsfEm5kdqGHsbtDajxjgW19+2joO1KEzgijpBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:54PM -0600, Jane Chu wrote:
> hugetlb_fault_mutex_hash() is used to serialize faults and page cache
> operations on the same hugetlb file offset. The helper currently expects
> its index argument in hugetlb page granularity, so callers have to
> open-code conversions from the PAGE_SIZE-based indices commonly used
> in the rest of MM helpers.
> 
> Change hugetlb_fault_mutex_hash() to take a PAGE_SIZE-based index
> instead, and perform the hugetlb-granularity conversion inside the helper.
> Update all callers accordingly.
> 
> This makes the helper interface consistent with filemap_get_folio(),
> and linear_page_index(), while preserving the same lock selection for
> a given hugetlb file offset.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  fs/hugetlbfs/inode.c | 19 ++++++++++---------
>  mm/hugetlb.c         | 28 +++++++++++++++++++---------
>  mm/memfd.c           | 11 ++++++-----
>  mm/userfaultfd.c     |  7 +++----
>  4 files changed, 38 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index cf79fb830377..e24e9bf54e14 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -575,7 +575,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  	struct address_space *mapping = &inode->i_data;
>  	const pgoff_t end = lend >> PAGE_SHIFT;
>  	struct folio_batch fbatch;
> -	pgoff_t next, index;
> +	pgoff_t next, idx;
>  	int i, freed = 0;
>  	bool truncate_op = (lend == LLONG_MAX);
>  
> @@ -586,15 +586,15 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  			struct folio *folio = fbatch.folios[i];
>  			u32 hash = 0;
>  
> -			index = folio->index >> huge_page_order(h);
> -			hash = hugetlb_fault_mutex_hash(mapping, index);
> +			hash = hugetlb_fault_mutex_hash(mapping, folio->index);
>  			mutex_lock(&hugetlb_fault_mutex_table[hash]);
>  
>  			/*
>  			 * Remove folio that was part of folio_batch.
>  			 */
> +			idx = folio->index >> huge_page_order(h);
>  			remove_inode_single_folio(h, inode, mapping, folio,
> -						  index, truncate_op);
> +						  idx, truncate_op);

Since this is the only place we call remove_inode_single_folio(), and that we do not
the index (at least index >> huge_page_order()) directly in this function, would it not be
better to make remove_inode_single_folio do the conversion itself? 

Also, I am thinking out loud here but we do have a few places where we
go: idx = index >> huge_page_order() to convert it into hugepage units, but the casual
reader might be a bit puzzled about that.
So, would it be worth to have implement an inline helper with an accurate name
to do that? It might help whoever reads that?


-- 
Oscar Salvador
SUSE Labs

