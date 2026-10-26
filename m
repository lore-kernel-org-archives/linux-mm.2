Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7656606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=itFUQNJd;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Iypac72U;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=XjgU0Ptl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1jTlf6CB
Received: by kanga.kvack.org (Postfix)
	id CF3DD6B05B0; Mon, 26 Oct 2026 12:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA4246B05B1; Mon, 26 Oct 2026 12:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A946B05B2; Mon, 26 Oct 2026 12:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7B66B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:33:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10B59A8417
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:33:25 +0000 (UTC)
X-FDA: 85365322770.04.5310728
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id DF60D8000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:33:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=itFUQNJd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Iypac72U;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XjgU0Ptl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1jTlf6CB;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793032403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yYf5UWvZ+GcrVAg69TILlqXVI2fvHpzHYVVjWtuH7Kg=;
	b=5FagZB5KzbuI+fxQGwJlWbTAGMQig34uyxFBkmCJrVhQ0h2c/lFVababsIaCI518cB9ATx
	T9zhcmnFnECHLBDMwx0HppOHTKgGzx5ju6lPBWiZqPKGjtmFb8fcNhpgP8u3OWB14Fi0bu
	RZt4Ilhsnmx0bFoJavjd0n3TRQd1YLk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=itFUQNJd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Iypac72U;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XjgU0Ptl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1jTlf6CB;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793032403;
	b=ra/9OVX/hFlER7qRNYCCSL+LKOzhWJUHpMTG9buQbR+rm6QbVAhoTY7l9E2VVMcQPmVnHk
	mINI7TkAG6JtpTXHumYZrEUrKKvxsY8UGXPcCQcNon9slE+S6bryZkhzUMbAmsPGTLzlBS
	P+bx3AEi3cE3oxACtvP6hmvHiAq3+Kg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 21B971F7A3;
	Mon, 26 Oct 2026 16:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793032401; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYf5UWvZ+GcrVAg69TILlqXVI2fvHpzHYVVjWtuH7Kg=;
	b=itFUQNJdXyvJGmDFuqzVC3Wgj8yybg5QcWEeRsYwqj5nzEXUjS0/Z+NNNtgSDtBjNmnxoI
	e2qbFQAs0KMd+9HVQkE5ENS6X8SXg1GCK8HMQS5p9RdFK3Lo/bS0gB8e2U24vkHCFWoojK
	zYaW+hgP8Xq2+PIBSr/E0PRajXKd9PI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793032401;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYf5UWvZ+GcrVAg69TILlqXVI2fvHpzHYVVjWtuH7Kg=;
	b=Iypac72Uy6VsBosAChLXP6YfP+EG3v3d1dAfTsAR8NtC5SrCYyxOeGgc8WJQbw3SVCdBDD
	JcWEtBoXEHD6ITAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793032400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYf5UWvZ+GcrVAg69TILlqXVI2fvHpzHYVVjWtuH7Kg=;
	b=XjgU0PtlvsnMlLIoCHG6nZSOdfgN1SThx2J1hD1bnNOovjaTsto6DwtgEGlLBEywyE/4XN
	70XIBEB9gTonX3a0JwooBax/2+hzNUps4N/WvQcVQcZZYa2UwDo1CnNMwMPGlWd+GpexSo
	yyAl2t6uP/Ts8uajjsWE+CnSFdJFm28=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793032400;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yYf5UWvZ+GcrVAg69TILlqXVI2fvHpzHYVVjWtuH7Kg=;
	b=1jTlf6CBBJwwHOB4ROaNRLi1p9O3txN9e7ypjNbFNqaUMGFHWU6au3TkpCmUCQf6oiIDVl
	JwyYcfz/n45ZfuCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63A6413319;
	Mon, 26 Oct 2026 16:33:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0FTXCM6A32ppOwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 16:33:18 +0000
Date: Mon, 26 Oct 2026 16:33:08 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
	jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, hch@lst.de, ngocthang2710.1999@gmail.com, 
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
Message-ID: <at9_1mf2kLqMX8-W@pedro-suse.tail5790ac.ts.net>
References: <20261026152013.10511-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF60D8000B
X-Stat-Signature: jum4yirz6qudgpqmgggzp6yomf4gnsci
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793032402-94909
X-HE-Meta: U2FsdGVkX1/5e44YMX6zcoEuuHdEX0YhmTmXok9aGiG3OA9dyPi2GZhcd3/NaYnKru8SCZK2Hco39U9njrf7SF28i39vrJrI7BBeAY3G6rlNxGxgJOVq+/TWjNSeSsCY6Yt9CL4IG/ofjWgA8KoBhQGdxCja8dri7xqhglhdOgJLkJ/0J5LBIqlT9oQMFNC06cGq4xdg/spc8ohpIFNOeR/Mg7Bs4qAr3nZWy+OBNWC+t/qGD0q2d6g24h+rvtfdTZdadI3zUx8ileUvPu9qvSNgUchRT13zTcQn14l48IVVw+TFzbkrguxElDOpsRDOawrGSR9Wpr7hCYAyUDmqCoS0H5BzMoPPqorXeBh1yuZ9K5u5xlgYo1lqlFZSL7awMAVBQe2gv1rHREOghwIn4TlaefnFSq3CJNOBtefmctXXf+s3xMAbcNOHDx1H1AaVwHDYuRnztk+i0ar4sK4IwGC7asM7JLLso17CbNztZdU/gZR0biFu/I5+84OY2Oak1PBFY436uq33AH6Uo4inbSnnNWgv87QrBX5ONfRmJ/4xraMRJ/axElpcFGsgDsRxiwU+kcPZw6pVfj2lQh12hQwJbP3Y/44lxDcqG8CG0MAwWjct9IZ1z0QEt+dvT+YGhBY3qPqtqmxQnYYITJgJ7wj+5VJsgDPNPn63fo77ZslI+LAPpJyy0uQUlWHAUHqnFEv5+TDL2R4g/dWfRtA/Ieahl91CSDTDmwa/7m5ZcmVbN2bXp/sIGhH5WVrhWIQl2qZ5D4JkTYVLmdx80vpZ9GHvwWymDQokbom5YX5aC/ZP5/reOqDwpxa777tSdvbQeRPyjMVxc/LtkMPDqIXSv25QxEdbDPCXqhQS+/oJ+vleegGRpRs4M1oGefS1aZPDOmehxu6N1il+vjCmbn9ZuXtSvmr+WpI8xDlIAesOxRBrdiP+OGIOUY/tJcQozDy1tWTK2UG2Zdb99Btlg3b
 0/zvNIOG
 Y0D+9I3iwbQmtnEJ3u7MbDqnuc68jXyLIdGk5by35v5rfFG37Pfo1figu8f/W7BKdcc0uK7c4oeEOR9JrSaL2xmTaAnZVie4Yh95PY201K6YnvfRZHKy2IDVKw4VqA6N8Ejnv9HfVYZyKO/N7nh3cZivA0rNX31hyPnttHIt+sji9L1soZ6BNe6dClZv2MKDpnukSFEJ9AiSFmdn8VaMqFuAu0R7j3rk4qh8IYKbUZsoZ9bVTrd101X5NSgagYRQvQBnN/5KS06bQhQc5rNThddvtFrucVU7R7AyGQsdBnY+WiA29gDQydAcTmmLAPKX+F0FWIPmBDms2tHsF4nrx8bV4OyP6AclqX8ATiq7m5Ngo/rNjqAb1w+ATMC8GRjjD3pksYPgYw6pY6SLRe+U8EORs/KTMnUGnSha7/IzZL5qUjzJtNRKlueOmSHz1+yqR8q/8l0EqfJKO9PuSOMS4SjUPxZKNruoC4dUtxlQzGDxlTNvErX8mncZV2uNCvuPL3pQ+o0fr/5zHk3WgkjToPMOovVH/ctMP0ZhZZPb8aSGFdDCB2tlWKYLtYYJ9kP3+jpgy0QS8xK4KiAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 11:20:13PM +0800, Lance Yang wrote:
> collapse_file() can call page_cache_sync_readahead() while still holding
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
> 
> We need to release those folio locks before starting readahead. On a page
> cache miss, roll back first, populate the collapse range, and retry once.
> Doing readahead after rollback avoids an extra pass when all folios are
> already present. If another miss occurs on retry, give up rather than keep
> retrying while truncate or reclaim removes folios.
> 
> Keep page_cache_sync_readahead() and wait for read I/O with
> filemap_lock_folio(), releasing each folio before moving to the next. The
> existing uptodate check during collapse still handles read errors.
> 
> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> taking mapping->invalidate_lock, so it is unaffected.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Thanks for the patch! This looks almost perfect!

> ---
> v3 -> v4:
>  - Move readahead after rollback and retry collapse once (per Pedro).
>  - Drop the preparation pass and its redundant uptodate check (per
>    Baolin and Pedro). Thanks!
>  - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.dev/
> 
>  mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index da91762f6358..0d3bd9e23613 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	enum scan_result result = SCAN_SUCCEED;
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
> +	bool do_readahead = false;
> +	bool readahead_done = false;
>  
>  	/*
>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> @@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  
>  	mapping_set_update(&xas, mapping);
>  
> +retry:
> +	result = SCAN_SUCCEED;
> +	do_readahead = false;
> +	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
>  	__folio_set_locked(new_folio);
>  	if (is_shmem)
>  		__folio_set_swapbacked(new_folio);
> @@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  			}
>  		} else {	/* !is_shmem */
>  			if (!folio || xa_is_value(folio)) {
> -				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> -				/* drain lru cache to help folio_isolate_lru() */
> -				lru_add_drain();
> -				folio = filemap_lock_folio(mapping, index);
> -				if (IS_ERR(folio)) {
> -					result = SCAN_FAIL;
> -					goto xa_unlocked;
> -				}
> +				do_readahead = !readahead_done;
> +				result = SCAN_FAIL;
> +				goto xa_locked;
>  			} else if (folio_test_dirty(folio)) {
>  				/*
>  				 * This page is dirty because it hasn't
> @@ -2657,6 +2655,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	new_folio->mapping = NULL;
>  
>  	folio_unlock(new_folio);
> +
> +	/* Readahead may take invalidate_lock; source folios are unlocked. */
> +	if (do_readahead) {
> +		for (index = start; index < end;) {
> +			folio = filemap_lock_folio(mapping, index);

I'm not sure if there's a point in locking the folio. If we are retrying,
then the logic above will lock it anyway and check uptodate. So I don't
think there's much of a point doing it here. Right?

So I think we could get away with a filemap_get_folio() here, and no
filemap_lock_folio() after RA. Unless you're intent on waiting for RA
right before failing, but I don't see a point in that.

With that addressed:

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> +			if (IS_ERR(folio)) {
> +				page_cache_sync_readahead(mapping, &file->f_ra,
> +							  file, index, end - index);
> +				folio = filemap_lock_folio(mapping, index);
> +				if (IS_ERR(folio)) {
> +					result = SCAN_FAIL;
> +					goto out_put;
> +				}
> +			}
> +			index = folio_next_index(folio);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +		}
> +		/* Drain the local LRU batch before retrying isolation. */
> +		lru_add_drain();
> +		readahead_done = true;
> +		goto retry;
> +	}
> +out_put:
>  	folio_put(new_folio);
>  out:
>  	VM_BUG_ON(!list_empty(&pagelist));
> -- 
> 2.49.0
> 

-- 
Pedro

