Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A166C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247F16B0088; Wed,  8 Jul 2026 12:28:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9A56B008A; Wed,  8 Jul 2026 12:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E84F6B008C; Wed,  8 Jul 2026 12:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D99106B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:28:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6371D1C141D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:28:39 +0000 (UTC)
X-FDA: 84966142758.07.148095F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 15AA0140006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:28:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1n+a7GN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+8ufZLru;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1n+a7GN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+8ufZLru;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783528117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGW9x4QlPkotlXfqozxVSbIvsuCm8d/ta5MfhZyK9WI=;
	b=kEKH8SmA78elNeHWfr9DsmJqS1agHmRKkJlqcdL0me3y0zixeFQsBVWqfFQjknTyqMrK75
	CB1sD1V7SoHjO2655BqfqvVzm1de6ZMXfvqjmK6A5BMtN0QC6PgUmkUTfCMA1uNho7NBhI
	IYD+P8Sx2mD7C7j2z4IHR6lY0bNeKaA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1n+a7GN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+8ufZLru;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x1n+a7GN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+8ufZLru;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783528117;
	b=hewQqB0chbADJyW5S1wvLrL/e0oVVyC1Y4mWI/taHztjPv2lQFx4Az/SKGanW9ub3i7FuE
	Ujrazb4y/h1p6vfXn0Lvkn7yMCSJJTtzKuf/lUTWspcvYlNgv0E2AtJmBrNTNpqnQ66oiR
	ZDuU0tdPni5w72DyCWmm/qQL+qlsrGU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8404E75BE7;
	Wed,  8 Jul 2026 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783528115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGW9x4QlPkotlXfqozxVSbIvsuCm8d/ta5MfhZyK9WI=;
	b=x1n+a7GNyFG9huMkWZEqD9+zC8J/OnSTaPj6X5zWEpRAy8q6y9BrEqJ1+YNFLqDtlsxYLF
	JaWEREIaXymEtxN1+gytrGefMIuJwTO+1LkdCzSp9L0heOIPA6IWSg/4PbRq8RdDOhIt5n
	UOzVuB62wYyQd4p7/vQxJXUqUsxrUig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783528115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGW9x4QlPkotlXfqozxVSbIvsuCm8d/ta5MfhZyK9WI=;
	b=+8ufZLruUQ6whIPPqFGtQq77EcaLjvp7kROJBvdwVwlsN494++jhWf4pad5pOOxk99BVO2
	GrTFDyI8VIUTUCDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783528115; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGW9x4QlPkotlXfqozxVSbIvsuCm8d/ta5MfhZyK9WI=;
	b=x1n+a7GNyFG9huMkWZEqD9+zC8J/OnSTaPj6X5zWEpRAy8q6y9BrEqJ1+YNFLqDtlsxYLF
	JaWEREIaXymEtxN1+gytrGefMIuJwTO+1LkdCzSp9L0heOIPA6IWSg/4PbRq8RdDOhIt5n
	UOzVuB62wYyQd4p7/vQxJXUqUsxrUig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783528115;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TGW9x4QlPkotlXfqozxVSbIvsuCm8d/ta5MfhZyK9WI=;
	b=+8ufZLruUQ6whIPPqFGtQq77EcaLjvp7kROJBvdwVwlsN494++jhWf4pad5pOOxk99BVO2
	GrTFDyI8VIUTUCDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D4FF779AE;
	Wed,  8 Jul 2026 16:28:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SRj0FrJ6TmpndgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 08 Jul 2026 16:28:34 +0000
Date: Wed, 8 Jul 2026 17:28:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Song Liu <song@kernel.org>, Eric Hagberg <ehagberg@janestreet.com>, Zi Yan <ziy@nvidia.com>, 
	Gregg Leventhal <gleventhal@janestreet.com>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable v2] mm/khugepaged: write all dirty file folios
 when collapsing
Message-ID: <ak556WxAZCyqQqbf@pedro-suse.lan>
References: <20260708151357.353173-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708151357.353173-1-pfalcato@suse.de>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 15AA0140006
X-Stat-Signature: 8twgphmawiwuhkgr9o8ewoiejdx1e8mj
X-HE-Tag: 1783528116-973515
X-HE-Meta: U2FsdGVkX18rcBwFhGZxRE4QWrUA1+pu74IBSsQ9Qayu3SP9cW3dTbjvwjAdaYxoEQYSOF9cK73AZqJKLTvoyMc7VJx8hyX7Ca1e2QOTXFlt01TMbxP3jLxtUEaVfVniFBuW9/M38UduoD+rm5unp+1yXUpG/kxaSixGPy54q3+BLvN42mwuke4Rt6ALyoDP0ffS+/ne/RDOnhgc9ywlbZj45gNdJX/K8J+C2T69Fa6EBtUMo45NHTB6pCZtPQ3PXMwDYCjAxv5RReg54yl7z03St7uyqYmSL/Ir1EfYInPG1RmFycMvgEQ6kWiqYYIzsHr46dbwDwWzwK14Aaaq1CjsOTyAlHZF2RDUD5N65MHoQdy7k/hbXmI5J9ZBD74K158NLCRiS4q28HiZoq9CvINH8zIkykQ5gX6pTyZ4mnG/5MWtGzcXpPh2Klx1zHxCTsW7/fjN4PLLbHdq7T53s34CM8mJg6OXW716YAb6wXWlruXQZqNYoK9qqD5m+TsihQd20lx+Fa2sJEYdVEuWCOU2UW549edAyb6Yb5JW/6h0ZqqWVNZXO3rBy0/PLafUzVYGN/FM+Pn++HdFZg87S/JTemuWXR4FpYPpRfOFnN06BjWa+xF8r73XPSROmOq4drqfewwLPrkvBuILYwQbDtq44pZkMGn6OGAgz6L2VBOMEztUVkmDU9zlxs6oxwFVxGC040IhEQCA5gp5wFPvb6uD8p3Z8wcoAa5KrXklLzYLM6O6JsfypSnXVtWe3GKolAuu35z9ua+2S0PtVSI2DYQ33zDFfCfhvieaJp79/Y4NTXQn0Luqy2gyPFd2iGS1g3MGweQT6ODU/9uuMc6TifJTmMryugiNENQxxsbNIi/YTULSmSJOI4Ib7zUYBPXHXvLUyBNfr2+vSuEW8yhiAQBvOdp9TpQpRW7uu/6ie8xBE1g4/HASGLDvj8yMCrg1B8JbBKaugj+AH2kFInK
 KcM0pgtV
 /AQc9KvGHeLSu3G2LoWDI8JYcCsdjUcR1AaMj8w/3pchzpRCMjyVKe6L67Tpl0dzRpIke8T/UEsluEctoe2dta/52dn2fIDkDrxldPYMFyVgqIz1xYgEWoJ1LdThKWmVENgbwmLc5nzwtNGFlH9RN4xrb/0NMxPyVJMM4eIsMYPcZgwnoro2oMU35DxUcg1fijDrHPjbyoeGTjHwpVSNfa/c6jwKfl5125DPl2ZCUBmfizvdn8DAPYKsO7nk+JUSpGbhWFymLWc1rSKcJONjVE/ZuZHbiwD8uIOiPNc7UY+H7g7KkSitu7WS/7QMcznneXim4oNF3G1HvB31WnApsW2dVvXbYPE03Ttx/rRjo7cMh5L0XKukUlyeqDC4z5JaC/s5VkxQij82SuWn2XnpyN1nEFLKkbilLfA4quCi+/qqMsiQkq5G7SyzWoD5LJUOu1p0bR/GjFkpjcaFj2nZR1/D0T9ThIKD/2ONjVs606InW6LDOP6WEzI3YzMoHzRhUdEsOwXLR9UEw1Ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Seems that I accidentally dropped linked list Cc's here, see
https://lore.kernel.org/stable/20260708151357.353173-1-pfalcato@suse.de/

On Wed, Jul 08, 2026 at 04:13:57PM +0100, Pedro Falcato wrote:
> [There is no upstream commit, as this code was removed by upstream
>  commit 044925f9b565 ("mm: fs: remove filemap_nr_thps*() functions and their users")]
> 
> As-is, khugepaged and writable-file opening exclude each other. A file
> cannot be open writeable and have THPs (because the filesystem is not aware
> of them). khugepaged will never collapse file pages for files that are
> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> particular file is dropped. This is fine because nothing could've been
> dirtied.
> 
> However, there is an edge-case: collapse_file() might not be able to
> coexist with concurrent writers, but it can coexist with dirty folios
> (from previous writers). Therefore, the following can happen:
> 
> open(file, O_RDWR)
> write(file)
> close(file)
> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> open(file, O_RDWR)
>  nr_thps > 0
>   truncate_inode_pages()
>     /* THPs are cleared out, but so are the dirty folios */
> 
> When this edge-case happens, there is data loss, as the dirty folios are
> fully discarded.
> 
> Fix it by fully writing back the page cache (and waiting) when collapsing
> file THPs. Doing so provides the guarantee that no dirty folio will be
> observed while there are active THPs. To fully ensure this is safe, the
> invalidate_lock needs to be held while doing the writeout, so that
> do_dentry_open()'s page cache truncation excludes this write-and-wait.
> 
> As a side effect, move the nr_thps counter bumping outside the i_pages
> lock. This is correct since the counter itself is an atomic_t and the
> producer <-> consumer correctness is provided by a full memory barrier:
> smp_mb() in collapse_file()/memory barrier implied by full ordering in
> get_write_access() -> atomic_inc_unless_negative().
> 
> Cc: stable@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Song Liu <song@kernel.org>
> Cc: Eric Hagberg <ehagberg@janestreet.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> Tested-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
> v2:
>  - condition this logic on !mapping_large_folio_support(mapping) (Baolin, Lance, Matthew)
>  - explain why moving the nr_thps bumping outside the i_pages lock is safe (Matthew)
>  - pick up Tested-by from Lance (thank you!)
> 
>  mm/khugepaged.c | 39 +++++++++++++++++++++++++--------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..d6e04041f5dc 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		goto xa_unlocked;
>  	}
>  
> -	if (!is_shmem) {
> +xa_locked:
> +	xas_unlock_irq(&xas);
> +xa_unlocked:
> +
> +	/*
> +	 * If collapse is successful, flush must be done now before copying.
> +	 * If collapse is unsuccessful, does flush actually need to be done?
> +	 * Do it anyway, to clear the state.
> +	 */
> +	try_to_unmap_flush();
> +
> +	if (result == SCAN_SUCCEED && !is_shmem && !mapping_large_folio_support(mapping)) {
> +		/*
> +		 * invalidate_lock as shared excludes against concurrent opens
> +		 * in do_dentry_open() truncating the page cache. This is
> +		 * particularly important if there are dirty folios in transit.
> +		 */
> +		filemap_invalidate_lock_shared(mapping);
>  		filemap_nr_thps_inc(mapping);
>  		/*
>  		 * Paired with the fence in do_dentry_open() -> get_write_access()
>  		 * to ensure i_writecount is up to date and the update to nr_thps
>  		 * is visible. Ensures the page cache will be truncated if the
> -		 * file is opened writable.
> +		 * file is opened writable. If collapse looks to be successful,
> +		 * flush any dirty pages out the page cache. With the nr_thps
> +		 * incremented, there won't be any new writers (nor new dirties).
>  		 */
>  		smp_mb();
> -		if (inode_is_open_for_write(mapping->host)) {
> +		if (inode_is_open_for_write(mapping->host) || filemap_write_and_wait(mapping)) {
>  			result = SCAN_FAIL;
>  			filemap_nr_thps_dec(mapping);
> +			filemap_invalidate_unlock_shared(mapping);
> +			goto rollback;
>  		}
> +		filemap_invalidate_unlock_shared(mapping);
>  	}
>  
> -xa_locked:
> -	xas_unlock_irq(&xas);
> -xa_unlocked:
> -
> -	/*
> -	 * If collapse is successful, flush must be done now before copying.
> -	 * If collapse is unsuccessful, does flush actually need to be done?
> -	 * Do it anyway, to clear the state.
> -	 */
> -	try_to_unmap_flush();
> -
>  	if (result == SCAN_SUCCEED && nr_none &&
>  	    !shmem_charge(mapping->host, nr_none))
>  		result = SCAN_FAIL;
> -- 
> 2.54.0
> 

-- 
Pedro

