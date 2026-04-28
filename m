Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E2EFFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4396B008C; Tue, 28 Apr 2026 05:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B786B0092; Tue, 28 Apr 2026 05:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7AFA6B0093; Tue, 28 Apr 2026 05:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B96206B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:47:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CA7740519
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:47:39 +0000 (UTC)
X-FDA: 84707487438.11.F3AE869
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1BE2018000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:47:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="c6QFc5a/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7zQ9NhAX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="c6QFc5a/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7zQ9NhAX;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777369657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeEGehnM9Yn+J3vQq2ELaGTuX8Ip21wZTc9U7YhwItM=;
	b=eB7H5cG9RKCdW2bFWBu4oD/4XiMKfq3BFiRw0rikTvaTckKpYqTw3KOh8RpG5426LzWn5u
	d160rffGEXWR8IHwJSwV2aZYhpipfYFF94cm9+jJmjfXfFk3kOFLwsYTTC9IOHxSxlZXG2
	oT0u/ZiN4yhRfmo+RH5svK6gSTU6K/Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777369657; a=rsa-sha256;
	cv=none;
	b=oWCHbV4owGC+R76toIFIyszt8/p2ozhZAix1B3WQwMj+lJHm0lkPKlQG1n2Yo43tNJVXfZ
	AtwIpTQXi33bppzNwmMkgdF8WJbriqUuKnR3j86j9Zh2C6pp96NEFLXbIcEtT0ZzUy3MoA
	PgCKjYLS0R12Trpc+DsC/GfR8FWGtdw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="c6QFc5a/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7zQ9NhAX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="c6QFc5a/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7zQ9NhAX;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4BF7B6A81E;
	Tue, 28 Apr 2026 09:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777369655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeEGehnM9Yn+J3vQq2ELaGTuX8Ip21wZTc9U7YhwItM=;
	b=c6QFc5a/JqyARhwEhPQWDHb0BYoTskOtR1t5ipRXRzaPvzRFM1cPBs6MqRz+1oTQPeKE4n
	ESIdZAAcy2an4BROa+8lnCdwz6siLlz5ga6bdZjg0JhUDSpoPL6VtU3qjx4243U4SKylID
	fu6gBKlzjsVm6GaDrFYlYOGOEqkVDuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777369655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeEGehnM9Yn+J3vQq2ELaGTuX8Ip21wZTc9U7YhwItM=;
	b=7zQ9NhAXvAd5X6khVdPAvbrqVoMB1ucnNNDT48svOE02IjSzJro0znxBCoVsqZ5FH/iMlS
	xyjBqyWBTZfYsiAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777369655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeEGehnM9Yn+J3vQq2ELaGTuX8Ip21wZTc9U7YhwItM=;
	b=c6QFc5a/JqyARhwEhPQWDHb0BYoTskOtR1t5ipRXRzaPvzRFM1cPBs6MqRz+1oTQPeKE4n
	ESIdZAAcy2an4BROa+8lnCdwz6siLlz5ga6bdZjg0JhUDSpoPL6VtU3qjx4243U4SKylID
	fu6gBKlzjsVm6GaDrFYlYOGOEqkVDuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777369655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VeEGehnM9Yn+J3vQq2ELaGTuX8Ip21wZTc9U7YhwItM=;
	b=7zQ9NhAXvAd5X6khVdPAvbrqVoMB1ucnNNDT48svOE02IjSzJro0znxBCoVsqZ5FH/iMlS
	xyjBqyWBTZfYsiAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 36F91593B0;
	Tue, 28 Apr 2026 09:47:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id JqxmDTeC8GluBgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 28 Apr 2026 09:47:35 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F062AA0B62; Tue, 28 Apr 2026 11:47:34 +0200 (CEST)
Date: Tue, 28 Apr 2026 11:47:34 +0200
From: Jan Kara <jack@suse.cz>
To: fujunjie <fujunjie1@qq.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: Re: [PATCH v3 1/2] mm/filemap: count only the faulting address as a
 mmap hit
Message-ID: <pkmextergrngpi2cr62ggyxo6dx2fcof4jkr3767ji2sie6rxi@zyhhraxrqycn>
References: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
 <tencent_756F151FE66F3D80479A6F982C0AB8569F09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_756F151FE66F3D80479A6F982C0AB8569F09@qq.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BE2018000F
X-Stat-Signature: efs5ebxt89y7gr4d551kxtyfujsfu179
X-Rspam-User: 
X-HE-Tag: 1777369656-189905
X-HE-Meta: U2FsdGVkX19gowrkh+p4bdziVggeDPo9+q5OluTB2Km/bsSMl3Alb4zc4eYUJOjqThBCHcBKG13tX+U/UotnkYa460ro2k1E0L3xAj1WQvIpuzv7I9QmED+/FS4wXoZic9BuCir+YwyDhx0S97gc8B/Z+cHLe3k5u+fYNhM145CCPrZgYOuQ239mCJXExHVbtFCG9cpbrBwf5opMRPcE/RnDv3fq8dCkj9sOXkK6YPrTa9zEWmrCVoNpAeTa81ZiQ8dxJvgqRnOU5VjNJRYnj4CBgd22KN/U5vUivVULl6J+wl56K38ugv4Uz5AfjULZT4+3Bi5pjMqoWoXApaLDdfasOmQRwZGJJnMwyuHb27UTfIkPNGDB3ZckmAJ+L9X6zYUHd1jTOJriwyQzBjPbjudiRLgtNCH9ncy7E8bk+L9XJS1L4i5p0RDsUY2hpmwxrYY17TnKslLQ8EyuOYAJgiUcZZ4ssL1WZmYW6xvZZhqEVi4m9BLnqWY9jZM1/SgC0KVNeDB5QIDa5c+KgFPRaHPnCNyvcd5CdaAA7wFQ7NLr3fO8ebEfkchFkCB0OZJ4GfAdO7zZsGw1hNwaCujB1fosnNflAxaSzYgZu6JQxBplRb8yeedwgKHamDWMLq0KEX4Rgrq9am/X0wIgoUrEXT/yLQqyOa/DLdXTavxgdVHahqTx9v8nBB8nIKooSWL55EOD8YBTuCF1kByCNlVqFyN1FiDgGQ79Th+uFaS0CZwlpOWRPaUQoL5re8x45lkgW/TxLYN48QtoptooYLKBLTILoDvPC/HlOrFNYHxZAYReUDOyPyXVJ8mieze0TPJQEKvONgDuCRpFnuHoAt2grQtsh3IvWVP+mst+3zIKWzE2i5ljuipHxRrIqgQje/GwBEPcUhfFDJBuXADjzmKVRq8OS2a3u2wWsLqzqt6ihTBdTJtmcg+00lPZpRujDKgFbc3poWen7yrobwBnwfK
 EOZgJUW4
 Jc+xZAOQwbPb88y4kfjGAD/w8cR3htoAy3IAt9W4BXTmJpufERqEgof7tOiPrb+5pq7jRR79vVf9WNPwTPn6hJ9R5AoZg0TlSkOP/sk6eKTNa5tZ753ZGZ9DbtRt1jZGrMay/b+Uv1fM4fErYvfnd7DeV4DE+US3qdFddmnyU9in7ciPtdXU/2rWKzXRNk22Zx4sue6tTMK7btyTgjsGeHSIKVWMuzOVnraxTclMwUOn6o5/EqaGICnxd6vtAWW/iA6p+LzAV8E+AkDfKTuklSRa15vksgEXB/0W/oz8jhWf46juP29mB4E7lW8Ku0+suTT8D1Lhg9IKNtsRCfNpstDUVQi+meUnk9ZtiJcWUNFYoI9Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 28-04-26 01:59:43, fujunjie wrote:
> filemap_map_pages() reduces file->f_ra.mmap_miss when fault-around maps
> folios that are already present in the page cache.  That hit accounting
> is too generous because fault-around can install PTEs around the
> faulting address even though the fault only proves that the faulting
> address was accessed.
> 
> Move the mmap_miss update back into filemap_map_pages(), drop the
> mmap_miss argument from the helper functions, and decrement mmap_miss
> only when the helper return value shows that the faulting address was
> mapped.  Keep the existing workingset-folio behavior unchanged.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 62 ++++++++++++++++++++++++++++++------------------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c1..543e51c32397 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3747,8 +3747,7 @@ static struct folio *next_uptodate_folio(struct xa_state *xas,
>  static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  			struct folio *folio, unsigned long start,
>  			unsigned long addr, unsigned int nr_pages,
> -			unsigned long *rss, unsigned short *mmap_miss,
> -			pgoff_t file_end)
> +			unsigned long *rss, pgoff_t file_end)
>  {
>  	struct address_space *mapping = folio->mapping;
>  	unsigned int ref_from_caller = 1;
> @@ -3780,16 +3779,6 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  		if (PageHWPoison(page + count))
>  			goto skip;
>  
> -		/*
> -		 * If there are too many folios that are recently evicted
> -		 * in a file, they will probably continue to be evicted.
> -		 * In such situation, read-ahead is only a waste of IO.
> -		 * Don't decrease mmap_miss in this scenario to make sure
> -		 * we can stop read-ahead.
> -		 */
> -		if (!folio_test_workingset(folio))
> -			(*mmap_miss)++;
> -
>  		/*
>  		 * NOTE: If there're PTE markers, we'll leave them to be
>  		 * handled in the specific fault path, and it'll prohibit the
> @@ -3836,7 +3825,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>  
>  static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  		struct folio *folio, unsigned long addr,
> -		unsigned long *rss, unsigned short *mmap_miss)
> +		unsigned long *rss)
>  {
>  	vm_fault_t ret = 0;
>  	struct page *page = &folio->page;
> @@ -3844,10 +3833,6 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
>  	if (PageHWPoison(page))
>  		goto out;
>  
> -	/* See comment of filemap_map_folio_range() */
> -	if (!folio_test_workingset(folio))
> -		(*mmap_miss)++;
> -
>  	/*
>  	 * NOTE: If there're PTE markers, we'll leave them to be
>  	 * handled in the specific fault path, and it'll prohibit
> @@ -3882,7 +3867,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  	vm_fault_t ret = 0;
>  	unsigned long rss = 0;
>  	unsigned int nr_pages = 0, folio_type;
> -	unsigned short mmap_miss = 0, mmap_miss_saved;
>  
>  	/*
>  	 * Recalculate end_pgoff based on file_end before calling
> @@ -3921,6 +3905,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  	folio_type = mm_counter_file(folio);
>  	do {
>  		unsigned long end;
> +		vm_fault_t map_ret;
>  
>  		addr += (xas.xa_index - last_pgoff) << PAGE_SHIFT;
>  		vmf->pte += xas.xa_index - last_pgoff;
> @@ -3928,13 +3913,34 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		end = folio_next_index(folio) - 1;
>  		nr_pages = min(end, end_pgoff) - xas.xa_index + 1;
>  
> -		if (!folio_test_large(folio))
> -			ret |= filemap_map_order0_folio(vmf,
> -					folio, addr, &rss, &mmap_miss);
> -		else
> -			ret |= filemap_map_folio_range(vmf, folio,
> -					xas.xa_index - folio->index, addr,
> -					nr_pages, &rss, &mmap_miss, file_end);
> +		if (!folio_test_large(folio)) {
> +			map_ret = filemap_map_order0_folio(vmf, folio, addr,
> +							   &rss);
> +		} else {
> +			unsigned long start = xas.xa_index - folio->index;
> +
> +			map_ret = filemap_map_folio_range(vmf, folio, start,
> +							  addr, nr_pages, &rss,
> +							  file_end);
> +		}
> +		ret |= map_ret;
> +
> +		/*
> +		 * If there are too many folios that are recently evicted
> +		 * in a file, they will probably continue to be evicted.
> +		 * In such situation, read-ahead is only a waste of IO.
> +		 * Don't decrease mmap_miss in this scenario to make sure
> +		 * we can stop read-ahead.
> +		 */
> +		if ((map_ret & VM_FAULT_NOPAGE) &&
> +		    !folio_test_workingset(folio)) {
> +			unsigned short mmap_miss;
> +
> +			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
> +			if (mmap_miss)
> +				WRITE_ONCE(file->f_ra.mmap_miss,
> +					   mmap_miss - 1);
> +		}
>  
>  		folio_unlock(folio);
>  	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
> @@ -3944,12 +3943,6 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  out:
>  	rcu_read_unlock();
>  
> -	mmap_miss_saved = READ_ONCE(file->f_ra.mmap_miss);
> -	if (mmap_miss >= mmap_miss_saved)
> -		WRITE_ONCE(file->f_ra.mmap_miss, 0);
> -	else
> -		WRITE_ONCE(file->f_ra.mmap_miss, mmap_miss_saved - mmap_miss);
> -
>  	return ret;
>  }
>  EXPORT_SYMBOL(filemap_map_pages);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

