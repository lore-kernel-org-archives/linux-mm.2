Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96C9C606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qA/9s6i/;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=O5umAqWZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=qA/9s6i/;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=O5umAqWZ
Received: by kanga.kvack.org (Postfix)
	id B91DB6B05BC; Mon, 16 Nov 2026 05:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B427C6B05BD; Mon, 16 Nov 2026 05:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32C36B05BE; Mon, 16 Nov 2026 05:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 78ED86B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:48:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07FE0C0937
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:48:21 +0000 (UTC)
X-FDA: 85440658002.02.8E5330D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE961100003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:48:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qA/9s6i/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O5umAqWZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qA/9s6i/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O5umAqWZ;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+g+4dXU+HuELXyVSUIrp/LWRT/qicQKov3vtoMydt5Q=;
	b=PADfC32IeHCwG1cEbs7A1RZ0k8LmyES2v0ed+sNf2BCwH4nnabrGZwIxcMv3hfopbIz5DM
	LSGG28zGQ9KSSrqV/p1FWELd4ImS9xymQOSZD/FgG7gQByAtNssW6RcBlRzeZao253LKjw
	XJOfikIOlQVVqP3qwOm30jVUaLO8lLw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826099;
	b=HVlMu7VKwJ+p9PjrW0SboF8Vxz+hOX+1F4Ei9k2tnQzTKSz0iY1qJFIMMm1JVd6Yjz7pS1
	nn1WG5JgzkYbHGdcoG9Sb3enbIHaHCprQUQUrCa3VSRcDorsqjAOBTgZsJFOjkwZWZSMpH
	0KqZ2dnCHdeQBj/56txZkC1w4sxw1gY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qA/9s6i/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O5umAqWZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="qA/9s6i/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O5umAqWZ;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBB371FD2A;
	Mon, 16 Nov 2026 10:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+g+4dXU+HuELXyVSUIrp/LWRT/qicQKov3vtoMydt5Q=;
	b=qA/9s6i/u7bq2d9GfPfDcYsFHKP2JgbpHR68H1LO2pBAWlZfn21xRmcd0CMR0GkDTqajkT
	wKB/LEMyrMLZBV6vtzo+gf1ATCHX/vgo5ROuh/7CBmSZYOrLXSyuGlN4SCG3QMKLLixp14
	fqAJep5rcTV2yfnoETsdPdH/reX06VQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+g+4dXU+HuELXyVSUIrp/LWRT/qicQKov3vtoMydt5Q=;
	b=O5umAqWZs5FSuqCVFxNDCA7r3oEFPdQlNVdigiphyohvjI/G/1U2+fH/YzGNu03dmvZvRv
	NiJ2/87ajSRKHbCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826097; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+g+4dXU+HuELXyVSUIrp/LWRT/qicQKov3vtoMydt5Q=;
	b=qA/9s6i/u7bq2d9GfPfDcYsFHKP2JgbpHR68H1LO2pBAWlZfn21xRmcd0CMR0GkDTqajkT
	wKB/LEMyrMLZBV6vtzo+gf1ATCHX/vgo5ROuh/7CBmSZYOrLXSyuGlN4SCG3QMKLLixp14
	fqAJep5rcTV2yfnoETsdPdH/reX06VQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826097;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+g+4dXU+HuELXyVSUIrp/LWRT/qicQKov3vtoMydt5Q=;
	b=O5umAqWZs5FSuqCVFxNDCA7r3oEFPdQlNVdigiphyohvjI/G/1U2+fH/YzGNu03dmvZvRv
	NiJ2/87ajSRKHbCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91B231334C;
	Mon, 16 Nov 2026 10:48:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BlLVG3Hf+mrJegAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 10:48:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 26AE024DA4; Mon, 16 Nov 2026 11:48:17 +0100 (CET)
Date: Mon, 16 Nov 2026 11:48:17 +0100
From: Jan Kara <jack@suse.cz>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH v12 2/7] mm: take a folio off WB_DONTCACHE_DIRTY only if
 it was counted there
Message-ID: <o3eskak6hilkz5kby6w2unwzlwgqk4l7ye35ung5nstovvh3ip@m26252po4ioz>
References: <20261112190911.84702-1-snitzer@kernel.org>
 <20261112190911.84702-3-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112190911.84702-3-snitzer@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: 7smjmtt7qfjobrm67yx4swdjy1kh7wow
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EE961100003
X-Rspam-User: 
X-HE-Tag: 1794826098-223512
X-HE-Meta: U2FsdGVkX18ywJiTM4ItwHakewnRyMlOrySUix+gtEnAf7cpmS3+w5GZF4hlelV4q6Z94aArQBzuO3TRbNVsKDxtlb6Tgs6r+zyph8JYNe1NdrUAgpe4s/GNIQw0SAaoL8795E9COrlixyfi0WOQp07iiA/WdayHX6qnRer/2ZrUNfewQjvGgyBecMGYNtDQ9El3W6m6ZLxwDX53CcwxKU3pZaGiBwFBDU8yIMyHteehaNHvvfNOtGlF9vjdUxqmfpB0ARV7NRbDFq1u1A2nJOgXcnHaxx1ebqeFiwHiJWCHn+/b62uOwKt9566Moy+PuR+pVtQMsI+zZjAj6DTQQkZ0df1OIS2lRBygF7zlQ+LIwMDE7oD3dTnmTo58S4KS/NSBR6eIgm4DjZnU5Oy3ItrOEHQ4OKP7WVLlE3Ja9UIHb5z0yL+2hD7W8cgHR6/4WAun1l2UdyMjyuGmSbWS2Cy94ybk0O+bUAWVafAdn1DZTx2krho5LgdlVP7BTaa5/+1Uf2My84tCsTBor1kFyhI1l1cnDkgaGu3pHPTsJkCUfXETjUx9+YSVGUnmNzN09orjoOGmd46I4piPX+9fpr2EiSFNggWTpdUkgWcr1PTgNS6TueUpLCPmFDnkAs8XA3ChqJ433RPYwcU75WfF+BQd7c81FpMeEgHfyElyYdDJKqjv1GLc11dLQqnb2lzGVbWx5Rj+6oENL3SZ43yDojeZWkvcIuAcmiN8mgW5cSO2U50KlJ/E+9PmOTcTpsoT2hLzu0r06XywitiXzOE4gQAi/rPcZV/nwjsEBJrGKZnc3pdjJAfHG/gQvPxBsfCwVQSJIM7lK7yOK2Ra5hVWFt4FuIFWR12oOBR07JR0EzCGWWyILj8x3PUIas9uvkeghWfsnkKdPD/unndBe9YMSgrMK0/VodqPI9nHT1Q0M9pVxkfQnGApunrrckSLKMvsQiBd0216GB28YqUX+E6
 4wPfkEz0
 z3Y3i+WdjYURR233hOBSdfhpZq/ByvxhOFHlwyCmRbLETQRknOb6UOyz+iCrL9u9l+5kLy+4wFSZAJ5ZTXeX9Q2MEJ+IaOfsdXCOxnRfuv53nowGgpMBSy+Bu2cKoogYDRRNSBVEMp2CjXWO3kQe9zX57HeejWpSNSqfK+2DDvtt23yNqJAEH+kgxUX7ELtnSHe1Fz6WQfO7P02amFXKW1g6Rsc7ASvP1zmSyJcMXkQTye+j1cYDomuQNL4qvjzQ5ALPu8YKtFw4/9/ZXywDtPSfhx0xF5Y8m4+YAPDnHKwvTtfPaVJ5xYZ8JVeYH+G2RDg5jbAxhCLlgbOt9g7nh5NftSEnJXzUdNXOLGANMpRea5NmFPUw8DA09UgQxuUobCzU8p23MSc6jF90sWAbflMbKug3fvIDott/oF76d5PnyWRXXKv0QDB++BQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 14:09:05, Mike Snitzer wrote:
> A cached lookup that finds a dropbehind folio clears the flag and
> subtracts the folio from WB_DONTCACHE_DIRTY if PG_dirty is set.  That
> test races with the dirtying of the folio.  filemap_dirty_folio() sets
> PG_dirty before folio_account_dirtied() counts the folio, so a lookup in
> between subtracts a folio that was never added.  The lookup also does
> not hold the folio lock.  Every other path that subtracts a dirty folio
> from the counter holds it, so the lookup can subtract the folio a second
> time.  Either way the counter drifts, and once it is negative the
> DONTCACHE writeback kick writes nothing.
> 
> Fix this by having filemap_clear_dropbehind() clear the dropbehind flag
> of a folio that a cached lookup found, and take the folio off
> WB_DONTCACHE_DIRTY if it is counted there.  With the folio locked and
> the i_pages lock held, the folio is counted if both PG_dirty and the
> dirty tag are set.  A folio that another task has locked keeps the
> flag.
> 
> Fixes: 88d6f128d06d ("mm: track DONTCACHE dirty pages per bdi_writeback")
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 437113addbddf..98ce955404127 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1956,22 +1956,36 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
>  	return folio;
>  }
>  
> -/* Clear the dropbehind flag of a folio that a cached lookup found. */
> +/*
> + * Clear the dropbehind flag of a folio that a cached lookup found, and take
> + * the folio off WB_DONTCACHE_DIRTY if it is counted there.  With the folio
> + * locked and the i_pages lock held, the folio is counted if both PG_dirty and
> + * the dirty tag are set.  A folio that another task has locked keeps the flag.
> + */
>  static void filemap_clear_dropbehind(struct address_space *mapping,
> -				     struct folio *folio)
> +				     struct folio *folio, bool locked)
>  {
> -	if (!folio_test_clear_dropbehind(folio))
> -		return;
> -	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
> -		struct inode *inode = mapping->host;
> -		struct bdi_writeback *wb;
> -		struct wb_lock_cookie cookie = {};
> -		long nr = folio_nr_pages(folio);
> +	unsigned long flags;
>  
> -		wb = unlocked_inode_to_wb_begin(inode, &cookie);
> -		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> -		unlocked_inode_to_wb_end(inode, &cookie);
> +	if (!locked) {
> +		if (!folio_trylock(folio))
> +			return;
> +		if (unlikely(folio->mapping != mapping))
> +			goto out;
>  	}
> +	if (!mapping_can_writeback(mapping)) {
> +		folio_clear_dropbehind(folio);
> +		goto out;
> +	}
> +	xa_lock_irqsave(&mapping->i_pages, flags);
> +	if (folio_test_clear_dropbehind(folio) && folio_test_dirty(folio) &&
> +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> +			    -folio_nr_pages(folio));
> +	xa_unlock_irqrestore(&mapping->i_pages, flags);
> +out:
> +	if (!locked)
> +		folio_unlock(folio);
>  }
>  
>  /**
> @@ -2105,8 +2119,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio)
>  		return ERR_PTR(-ENOENT);
>  	/* not an uncached lookup, clear uncached if set */
> -	if (!(fgp_flags & FGP_DONTCACHE))
> -		filemap_clear_dropbehind(mapping, folio);
> +	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_dropbehind(folio))
> +		filemap_clear_dropbehind(mapping, folio, fgp_flags & FGP_LOCK);
>  	return folio;
>  }
>  EXPORT_SYMBOL(__filemap_get_folio_mpol);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

