Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAFD2C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2F26B00A5; Tue, 30 Jun 2026 18:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75E236B00A8; Tue, 30 Jun 2026 18:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673046B00A6; Tue, 30 Jun 2026 18:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC746B00A3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:34:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABF6BC03EF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:34:29 +0000 (UTC)
X-FDA: 84938034258.09.36295EF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5F4CA1C0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:34:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WpKr6pNi;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782858868;
	b=4n53j64gcPcHEcRYYbOLevR1U+93q9/UnpOc93plFypke5WP6FVLLgaq8FltP3j82O5QUC
	vvjthd1w3oKA1x6l09hOoYYWc0M9U4eFVn4PPMOl2mjvfOVl2w4KqDufj8oxvG1yTKsRAA
	BzQprzSy6zR52bNt/Xd4mif9WAZ6/bE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782858868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BqAxmW3e1hhXspm1Gh4qNnGjB5Tn65aWNgmzXjJfok=;
	b=vH4ZEohA3IDdBRDZvegczdeo0ENBVzuUvg1QKKsqwnwS5mfhuqsBQX9dNmYeNrLDEJXXx4
	UgP1oQJv2qMsq1GQUMxMkuujSc3K14DpDd4qHBu9CS+eSga8rRphf0MI9KTXyV+iJ0JQyt
	XvE//tj/aAywWYLOQ+uKSLMG2533kRg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WpKr6pNi;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1BqAxmW3e1hhXspm1Gh4qNnGjB5Tn65aWNgmzXjJfok=; b=WpKr6pNidx3q9iJnRzgtyiWoiu
	b8vgmhgbbS8QUDxZXIhz7FswaFl9XJCSeQf73V47deJf040xnTTeUL4xzW1WWdg0Ag1qM6soZ030S
	MDIWUBalfqj7iQlO7skfhgo7545AVisGdzMhJFUXgwI7qREWL7apWFK1ftFg8lEyv2JQ5ZtWiXKEi
	6aA8IsaypyDt1PgMQlizUxmjvuNccOb2xfGLZJNNvRozbhmdtsZaaAKzo+ZyENa62xyxlPwohxweb
	/dle3Je8Y1GHgtEFSPyH+GkuHE+qLos1GqekVWivmSVImTm9uoURrnCme7ol58/vUumL0rRz9qmgO
	LnbEMwkg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weh27-00000005cZQ-1Zuh;
	Tue, 30 Jun 2026 22:34:23 +0000
Date: Tue, 30 Jun 2026 23:34:23 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Gregg Leventhal <gleventhal@janestreet.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akREb81Z15bChEt3@casper.infradead.org>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akQekZUyoKadiGCH@pedro-suse.lan>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5F4CA1C0004
X-Stat-Signature: aakbt74or1po4dqpxh77cps6occdmft1
X-HE-Tag: 1782858867-412895
X-HE-Meta: U2FsdGVkX19FsZfFrCvAYvcn7070maHigCpxT82g6dhLuTAOWdFMjJ39roNTEF3shabjUAUCtbmP6ICNPGST7yv/Hwb1vzCUiMbU1ge26PmKhU0ZUl0Ec4yWXqC5dQXMg/y7FPItZXIekjESh7wvzfAywwmvVsRVw847T870n+bPH+yYPUsTBRyQJsUOmQCIgKMxyyJaSjEjIG3Q+WDs30eXJe0Yw0FvG7o8RRTwXkmWO3ulf7Ub+c147UD1IfhSoSqZsCtwvoWKRetpI0qx1lc+DougD6AZYAXWsBYZmxuuYGtRQc5NP+IdRN4MZoBSn2v7LI1q0VTcNfeOpEk2pvaYE9KK4ZlE9XcKbo/MwqpLlefve/uYsAPR15SBSgysweuIbEQBr5DaLGp1YFwjbv6xCYnQBTNixjUozRVmjw3ZlQJd7u+/dc7yNkAOwFG0rUwZKBrXSfYSLYI61nimvJf+Ac7/rwYrQCwuyk9DGxZ6OUaCwd5Vfy3smyWa2UiqF1b/EhVZ7A2IJWwPypdCGw8R56gm99oiFIGhi6DUSptSJPN91KZU8R+gt9zOyZO42n0y5M85tQJSwdf1/ICJuWpA/Dr3nZwGK9u0blYkuQB4M0rcyKMQl6BV6mROB/QZvMmmHBJom9ef+NQ/BHEZ1eVk+s+6Mcoc/F/ZrejviI94Tb+soV9HzSYk1oSGj/+ISNayVZow2tLarsbezNTYbBaYdNjzdjYWSKhmQN+acbuaZYBIJO34WGrw1M8NEcHF8BqXgWvjYGcsi4CvoC74zT+EYKfmZYfaxlwaxHWJ2YEOHnArnJkYL2DcRADF2UYjJqn/hBNl21k0i2mPBID1+h5jAc3OjeN/rHGMns2gz1i9+eatMACxYDD7vDOPEoh8Qd/B4JWdX+5uBReYPDz/WHtLiRXhQZmSATE3eG/C0OtjouYNg8Wy4yGmL1/2vcEhQB1KrDVtKtxN2RD3FX8
 /F18+9oW
 3g8OlePnpU+uR3vOoW1eZw2EUZljH+iTDrJ8yO8aYw00xY0bz2QJC3ZslPH0eU9iBTiqcEtUxNQwfVGl8HQAG85dobafQQC0TE4JETok2xMIu1L0eOCUfCWiHRjXoaNhKS0qBDWQcmT9iAw8k41guMfJbScHzw9ijgpCRfPQNacQhbktq1hZLG0fnATUziwW7WPXblPbZIBS9aCLbf1tgYS0v2LeITE8s5oYf0i/D9+sLAe4eJ5m+ruiF/6COr4llR/VjSyKnzeQbxd6/wiaUcqRG9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:55:12PM +0100, Pedro Falcato wrote:
> Gregg, if you could test this patch, it would be much appreciated. This patch
> (hopefully) makes it so no dirty folio will ever coexist with a ro-THP, thus
> hopefully sidestepping the entire issue in a simple way. Only compile-tested
> and not reviewed.

I'd suggest this is slightly misplaced; it's actually called in some
failure places (eg:

                if (!folio_isolate_lru(folio)) {
                        result = SCAN_DEL_PAGE_LRU;
                        goto out_unlock;
...
out_unlock:
                folio_unlock(folio);
                folio_put(folio);
                goto xa_unlocked;
...
xa_unlocked:
        try_to_unmap_flush();


I'd expect to see your new code inside the existing 'if (!is_shmem) {' block
immediately before the xa_locked label.  I'd also follow the
inode_is_open_for_write() case and decrement nr_thps there rather than
introducing a new SCAN code.

> -- 
> Pedro

> >From 43d90a937f0b24656a8d0405035c3efcfdf0961e Mon Sep 17 00:00:00 2001
> From: Pedro Falcato <pfalcato@suse.de>
> Date: Tue, 30 Jun 2026 20:48:41 +0100
> Subject: [PATCH] mm/khugepaged: write all dirty folios when collapsing
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/khugepaged.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a97b20617869..3f0f90ab16ba 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -60,6 +60,7 @@ enum scan_result {
>  	SCAN_STORE_FAILED,
>  	SCAN_COPY_MC,
>  	SCAN_PAGE_FILLED,
> +	SCAN_WRITEBACK_FAIL,
>  };
>  
>  #define CREATE_TRACE_POINTS
> @@ -1812,7 +1813,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
>  	LIST_HEAD(pagelist);
>  	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
> -	int nr_none = 0, result = SCAN_SUCCEED;
> +	int nr_none = 0, result = SCAN_SUCCEED, err;
>  	bool is_shmem = shmem_file(file);
>  
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> @@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	 */
>  	try_to_unmap_flush();
>  
> +	/*
> +	 * If collapse looks to be successful, flush any dirty pages
> +	 * out the page cache. With the nr_thps incremented, there won't be
> +	 * any new writers (nor new dirties).
> +	 */
> +	if (result == SCAN_SUCCEED && !is_shmem) {
> +		err = filemap_write_and_wait(mapping);
> +		if (err)
> +			result = SCAN_WRITEBACK_FAIL;
> +	}
> +
>  	if (result == SCAN_SUCCEED && nr_none &&
>  	    !shmem_charge(mapping->host, nr_none))
>  		result = SCAN_FAIL;
> @@ -2210,9 +2222,10 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	/*
>  	 * Undo the updates of filemap_nr_thps_inc for non-SHMEM
>  	 * file only. This undo is not needed unless failure is
> -	 * due to SCAN_COPY_MC.
> +	 * due to SCAN_COPY_MC or SCAN_WRITEBACK_FAIL.
>  	 */
> -	if (!is_shmem && result == SCAN_COPY_MC) {
> +	if (!is_shmem && (result == SCAN_COPY_MC ||
> +	    result == SCAN_WRITEBACK_FAIL)) {
>  		filemap_nr_thps_dec(mapping);
>  		/*
>  		 * Paired with the fence in do_dentry_open() -> get_write_access()
> -- 
> 2.55.0
> 


