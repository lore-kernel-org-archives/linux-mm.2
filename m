Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 996BBF9D0CA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 12:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5366B0088; Tue, 14 Apr 2026 08:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E9B6B008A; Tue, 14 Apr 2026 08:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A366B6B0092; Tue, 14 Apr 2026 08:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D20C6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:28:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FC2AC13B2
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:28:58 +0000 (UTC)
X-FDA: 84657090756.21.520DA70
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id D3EEB20003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 12:28:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9TbBTi2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XdoxE3nX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pIm8/heN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgs93AZz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776169736; a=rsa-sha256;
	cv=none;
	b=uiXg5WuHAJk1Bqh5QAotqySm6rGS0Z0iYtjdwDhqzj59PZ2x/50I9ylnzkRBjk81X63f8Y
	ElOxlqWVtZOyON2Om900WJQnJ3bCwCKwU3RePT+u6uuAoXYczdNKcYUf8YfLQm8aVr1ejy
	NAui/W9oXSAM5CEbFQ5rHjmLItzMfpI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9TbBTi2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XdoxE3nX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="pIm8/heN";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=rgs93AZz;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776169736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVEho8Ms8/HIAqhCfZUSO6x6cxhfOdq33qNwNAiuoY8=;
	b=f5gXGcbPHltF+D69w8EPSLsxU+inBTIem9+lFGNkT9c++3O60RKp4rDS++GbR45UzL132e
	HScfxveTNUWzcYYgd6pMLgDtcDINFrSwhLisHkBJaLNureIXEmz3Nw8WGZZdt3m3O6S9zD
	tMofARrmwjlB86oFze1Lcu4yI0oBu6w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EFF635BDD9;
	Tue, 14 Apr 2026 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776169734; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qVEho8Ms8/HIAqhCfZUSO6x6cxhfOdq33qNwNAiuoY8=;
	b=c9TbBTi2jtPBz6EtoIsm01SjEfB3q8Hb42bfB34dS1snFyE1Kzv+iPka9RQBqK5K/2Rf7R
	NZ5XKH0N1lv9b977bkp0/z1pIThuJkxoJDGSIAcSndq0xHpQH6cs2g5eCYL7lmPYi8feTf
	RfHD/fX62X1ZBuJcFjN1vZIYUYNgmPs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776169734;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qVEho8Ms8/HIAqhCfZUSO6x6cxhfOdq33qNwNAiuoY8=;
	b=XdoxE3nXlVDeacrd+lACcZEaNLgGXbMs8GXhRaY/F3Hr6v9eybjLN6cX5sS/5HXZAVxws/
	ee0FjOuqjVKaLSBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776169732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qVEho8Ms8/HIAqhCfZUSO6x6cxhfOdq33qNwNAiuoY8=;
	b=pIm8/heN6PFnq62uVwa7anogYZWLnhLGiqhyWeNZKl7X3Y8zf3qYurXHIRy+pt7ekFjpSh
	z7hvw5+gzSQCs9jJFtCT2kjCUTXnj74bknrxbDndVjKkOk0gBgpszQst+vwpC3aeWRiX/v
	Kw7cY0ilqNORIecZxmqv7+xCJXqYxU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776169732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qVEho8Ms8/HIAqhCfZUSO6x6cxhfOdq33qNwNAiuoY8=;
	b=rgs93AZzIRp1LtGRVrlwZVZu/w239QWqdbbJJCOwkae6tOk5dPVIPLhfy0UPnq5sLST4gL
	ujk4nsMCc3Bs+NAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E5CD94B443;
	Tue, 14 Apr 2026 12:28:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HScVOAQz3mlDBAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 14 Apr 2026 12:28:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A5146A0B66; Tue, 14 Apr 2026 14:28:52 +0200 (CEST)
Date: Tue, 14 Apr 2026 14:28:52 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jens Axboe <axboe@kernel.dk>, 
	stable@vger.kernel.org, 
	Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
Subject: Re: [PATCH] mm: Call ->free_folio() directly in
 folio_unmap_invalidate()
Message-ID: <ima4xpxokjy6yxkpdewjnzzrh3gqwurtf4bhuic5fbitkvltie@33zwpb7rniut>
References: <20260413184314.3419945-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413184314.3419945-1-willy@infradead.org>
X-Stat-Signature: wwr7s893zysuuup5x6weh89zehu3go5c
X-Rspamd-Queue-Id: D3EEB20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776169735-334401
X-HE-Meta: U2FsdGVkX1+vxQaJajp1GMfET8E3VifjuWDlVTVW0QtLwzyueJd95NnCTYwyRCz20jhPFnEk0pAUY68e1fFH4wPj0Rsbv7q6VgT+e/o3Zwhz4rc+1T6kCV5xeL8WwQiiUMgxWMr8V8i1UfuuxKD25YNC4dkObZw/MfypwFzMt+Uz72fTMBV/p6wYO/KmSCK1zVMpd/IRfC/Ecd/yQci3n94DjLEERLlEdSyMELQqJgmjBJI1mQjsgpHhoTHApX2fkLjt3RBMravbpXCFadhPHb/4I2eDGEo+9huioMU8s1XhUo/59DkyoisQUOsVDP63+GKlWMZ8aAZjTkSOH4GipDZMplYlbQKEXTdOD+QcBtlY9qcq59zN8ywcgsrcPcj9XLLCiVDc6VY/Neo3XrF/zd03g5MSRWkE2NMZSoExkwgKYxE/MZ70RphHYh8gKzZ+MG7dOB0jrWooT7m8DrdsTnTiWvyWCO2K9vw0B2WDIHaD+XudIHvIU6eJ13Cw1QyXzFEILoGE8YI3zrAdrTx8GoU2yF9uOyZuXHXSS2ztim3laXy3ncceSGHejE5sRjTtSvtEY2mBFJY5tvsrvRLQOmsJj/Cm4Qge71fKGOfQcWxcxyGYLeTGXdy0jAOaOuHfAxLbdeZUdZTobR8lylM53bM8VYbcqzkjJQJhY7oW2uNtxkWVyByCdNeQfJFrL3oss8FUwmEwx/Z/I6VrB/9/sNRkRLcIIRF/DDwu5LWIfa/lZB0HCcw9vpBp/tCP8sXfbHHMFdlj3BjOzyOHpreRBoOhUjtN+kfFMR/on9fuyzjCu7g0b1DulAQOgY910afhxHF63kUoBp/9mCoeXvnl+di2WeRkP3ImTHq2bD25SYvafws1F9ibIIhkhn117aZK37DePmHMf9uGkts0zXS+O+u/aqbV25ZRfr956d3+zXwUeVsxaEXXDKS6/8W5T8hrs/MNs+l0zDN4E1bgdIa
 SIXoC9Gr
 fmXMS692EGOmHCzpR/iVx9EvZzICFlRQSDpDS+QaoQ7ynakMvOdRCalf53d3xnndurvLLmRgVQkoxcvKHDMIh96zb1qgxFOKAruwBfqW1xe0N2jsg1N5JmLab2I+arUGvgvMaImP5StE+cgbYP7kS27rXXSwBzosO2Mlffs6d9NyGrqfOu4HSAsJe8YP1nNvwdW/UklIbjhs1wYl2THypmqHQiawukQQCUy0MNx1b6lBUy+V9VZfDqXge6Q3YY5Iiieuix3ZH2QecoVTwqo+6FMXMK6oE6ol4OxHHG1yoXfVQ6BYLv5hfO6jkVsNUP0LkUmvY4ZkVI4kFgEBN8ZUznfUv+CiKeGLoj3JhJesHoPFuSl0xHMWxhi+0+LYEsbn4d+LPb382fsMN56fCiFgM6fjCxOT79D7KyvWRGg+Sz8/gbMbvW1BhqO3eqWIw0AC7V0rfnA3a/TSxxu+G1zkvHACXXGS4qkyyeV1lbaMx1/ETlcGw7XfSNvQipBbiB9mBD2zzRyG8vV1b0QOJyaXT/QeA6leI4eIePetv9PQaIH7VOyIbQUqkiVrAV8i0OaHyvLUeJIOVu9G+FaM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-04-26 19:43:11, Matthew Wilcox (Oracle) wrote:
> We can only call filemap_free_folio() if we have a reference to (or hold a
> lock on) the mapping.  Otherwise, we've already removed the folio from the
> mapping so it no longer pins the mapping and the mapping can be removed,
> causing a use-after-free when accessing mapping->a_ops.
> 
> Follow the same pattern as __remove_mapping() and load the free_folio
> function pointer before dropping the lock on the mapping.  That lets
> us make filemap_free_folio() static as this was the only caller outside
> filemap.c.
> 
> Fixes: 4a9e23159fd3 (mm/truncate: add folio_unmap_invalidate() helper)
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: stable@vger.kernel.org
> Reported-by: Google Big Sleep <big-sleep-vuln-reports+bigsleep-501448199@google.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

The fix looks good to me. Regarding the Fixes tag, Christoph is right that
at that point and even for some time after that folio_unmap_invalidate()
was fine as it was only called when holding inode reference. It was more
like fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when
writeback completes") when the problem started.

								Honza

> ---
>  mm/filemap.c  | 3 ++-
>  mm/internal.h | 1 -
>  mm/truncate.c | 6 +++++-
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 406cef06b684..5a4fecb24257 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -228,7 +228,8 @@ void __filemap_remove_folio(struct folio *folio, void *shadow)
>  	page_cache_delete(mapping, folio, shadow);
>  }
>  
> -void filemap_free_folio(struct address_space *mapping, struct folio *folio)
> +static void filemap_free_folio(const struct address_space *mapping,
> +		struct folio *folio)
>  {
>  	void (*free_folio)(struct folio *);
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index cb0af847d7d9..546114d3ee44 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -540,7 +540,6 @@ unsigned find_lock_entries(struct address_space *mapping, pgoff_t *start,
>  		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
>  unsigned find_get_entries(struct address_space *mapping, pgoff_t *start,
>  		pgoff_t end, struct folio_batch *fbatch, pgoff_t *indices);
> -void filemap_free_folio(struct address_space *mapping, struct folio *folio);
>  int truncate_inode_folio(struct address_space *mapping, struct folio *folio);
>  bool truncate_inode_partial_folio(struct folio *folio, loff_t start,
>  		loff_t end);
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 12467c1bd711..8617a12cb169 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -622,6 +622,7 @@ static int folio_launder(struct address_space *mapping, struct folio *folio)
>  int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
>  			   gfp_t gfp)
>  {
> +	void (*free_folio)(struct folio *);
>  	int ret;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> @@ -648,9 +649,12 @@ int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
>  	xa_unlock_irq(&mapping->i_pages);
>  	if (mapping_shrinkable(mapping))
>  		inode_lru_list_add(mapping->host);
> +	free_folio = mapping->a_ops->free_folio;
>  	spin_unlock(&mapping->host->i_lock);
>  
> -	filemap_free_folio(mapping, folio);
> +	if (free_folio)
> +		free_folio(folio);
> +	folio_put_refs(folio, folio_nr_pages(folio));
>  	return 1;
>  failed:
>  	xa_unlock_irq(&mapping->i_pages);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

