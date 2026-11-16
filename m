Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4BB5606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=GQ8MT/a3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=tSvqMv6N;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OHoLwwQ0;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cFtLglZc
Received: by kanga.kvack.org (Postfix)
	id C822F6B00EF; Mon, 16 Nov 2026 05:47:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AEC6B05B0; Mon, 16 Nov 2026 05:47:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A9E6B05BC; Mon, 16 Nov 2026 05:47:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85B436B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:47:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C2EA4095A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:47:44 +0000 (UTC)
X-FDA: 85440656448.14.B93C1E1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id D36671C0007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:47:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GQ8MT/a3";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tSvqMv6N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OHoLwwQ0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cFtLglZc;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826062;
	b=WgU7REJGwOhXTGk9/0Wjz7at914U+tqZi1NIkc8qBbvskxtr4z6ClVKteTvf6sy6kxY/T+
	NyzmOV9Cd8Yj1RPjy7YgbbbpV3c9KfNhF+Lyv/8PG9PgIugJTvDtLsePGS5awBjZlpQpZZ
	VRWAHwdALNeDBGECYYy+PjYH0Voi4C8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTTKVSXYOeC94N9rF1eBh/d2Q5pkxmY2099mbwBlcHc=;
	b=pgrYDtCO+/36OmcT0tfJmpZm0xAxKUVKtjxTTRCAfVxl1ScXq10vy6nPbJ3WB/dqFYK8iJ
	3lcEbyo8+NN3XsZ18dal4nBidfLLPyEui9RmwJQEIYarjFd0EeUCXO16d+xz303XTwJmru
	dLj1OOOPk1X4UfcwU5ztDaNVn5zEbwQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="GQ8MT/a3";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tSvqMv6N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OHoLwwQ0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cFtLglZc;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EED2222290;
	Mon, 16 Nov 2026 10:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826060; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTTKVSXYOeC94N9rF1eBh/d2Q5pkxmY2099mbwBlcHc=;
	b=GQ8MT/a3HQjVMr4dqMSlvqNqSJW41G+GZ5j/3EGKRKzyxebiOCeVZMDjWeFrZ8G+XCZD1r
	L2qx01GWsmVBzJF1h6EHSCXt9pXZTiMeyl3pi+bz86Bx35NQpQb8Ivz4nACPp2qx8rWlaA
	yQDtYpW4HmjrU+LLF3hHx5i9TPGb7GA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826060;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTTKVSXYOeC94N9rF1eBh/d2Q5pkxmY2099mbwBlcHc=;
	b=tSvqMv6Nqy8Zkuk+n90WOu9Ru6DolzbE1N8Yir4OL89YR6Gv+DMh6pQr96+MzNx2/ngjt6
	1lV/HvRFTgcxP0Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794826058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTTKVSXYOeC94N9rF1eBh/d2Q5pkxmY2099mbwBlcHc=;
	b=OHoLwwQ0OTXXk+IuVBwvtezKOCIe3+R8Zb6YmRs0CFCFMWIGSj+xAMC78ZZvuiFJe+icj9
	6s0ERiZCsBbMy4pPuEj+EY5kJv9fmWpsN1eUrELL/sV4aZzxzUQVVuWp2MQSMlYTZQV+Z5
	skLcu9BtCKFjlvxrF46KGo0JMfTGst8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794826058;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTTKVSXYOeC94N9rF1eBh/d2Q5pkxmY2099mbwBlcHc=;
	b=cFtLglZcWyzJKbynjhd0va5QG5ivPkZI+KtyYInk6FzPqsbplQMpbdaZxe3wJIl7xVCAB6
	/Y55bcydBuRG7VDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C796E1334C;
	Mon, 16 Nov 2026 10:47:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eAZJKErf+moaegAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 16 Nov 2026 10:47:38 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 59B4724DA2; Mon, 16 Nov 2026 11:47:38 +0100 (CET)
Date: Mon, 16 Nov 2026 11:47:38 +0100
From: Jan Kara <jack@suse.cz>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	linux-nfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v12 1/7] mm: move clearing the dropbehind flag of a found
 folio into a helper
Message-ID: <t7kkd2xt36h74bc5zihmbmaofkxi74nuca6ku7kyora6mq3jqi@qgwmzgc6tnav>
References: <20261112190911.84702-1-snitzer@kernel.org>
 <20261112190911.84702-2-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112190911.84702-2-snitzer@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Rspamd-Queue-Id: D36671C0007
X-Rspamd-Server: rspam12
X-Stat-Signature: zt3i6tzr6mjyj9ntqcotfnbfi1787rts
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794826061-339442
X-HE-Meta: U2FsdGVkX19KJElH2N/PKNfksXLBTFeF7p2kxnzuCM1pbGQNeZ48T19zyFabNVWNivzHIiIDCFsQkbL+CGYkFx5gp9dksZ4If9He0ugAmf4gmh4ifb+PUbo9qwCE0pP8WRTWog1AvsVEkaURiZwzOgN24T/4eeVqqCwdFD/30ZjK12+j0arNatOafKezaJK1PGyx2WdWK4t1B8MNdUlBjYhFmkzmhtLjMho5PilP915mzONLN6xyY2XjWP+BZ6ibA1kFt37ODEtp9sdWGcUA6W0xXhB4eAmxhM1hwFMZX2dHUqYrbIWRZKeKD9+2jvIFaUHO4mfhufbpmtE6L6ycSAbsYPLkqIZvka9u94JjCx+mlZxzgbu4OqLZ0xB0Z38Co7AvNBGjmUTzqtx96+MLujtvSfMWGCL10PbpZjxONc3siIjmib4rpBdXa8mqSV4+AYuMfcDYdDnSJtcus7k9V03aAU9I1VBMbUzwzOXhs0gEW6DqlU6mtqTNWMnDs6wUIupKRPAUrnSNwkUL0r18P15Rn7GElM2s84jCmSDhXTexwRjdNDxSpaA7EbcQgilxbj5v4uyK0kVZnxbT3kiIJHGXZM6GflEI+aqaeAk9euv5zKDj1yze9LciWCk3GUBSu/G8cOLoQ1Poa4wIcmZ9dGWXRkbycL7Q+9dPjnU9amoFsATJ3CYlWvS/IvHaqZU7UFElTBBovlXNkcoGygfgbE5ykUOPX+KHTILH+ZopJgFAVGXgSdVNMP7HjiCzWHl186tyqJWmuPhQwBtXLESgwh23ga+n+h1nsIdoZEm9On+Rt8fh93cq9h0vvDA4DqszVnoBX7CzxpCMC3I3NaZ3oId+aIsQ78bRrQEOIRnMrBSpvJRIO3IcJBNf0ilZuA75dTIhb9iX08UCQnoqisz+oheLmc1bSc7W25GDhB5bXXKEysulb8D4W5k/8DKC0Fb1359gi+qXnHo9WuksfFU
 VZjGbGb2
 s9tIL3K2uBYOPQZVhgxgklrUNUc/GvcvtAQveCApcFRSxWFe+bD54DrUt6Dx5Bzjx6fgZL/9cPoIXp/kzuFn81FCiHiNT5bqx+TR8Igf0ymV8TcciQDRWj9x2pQXp2Mx7q7YFRtCRyKa8BeoaRCmScYViglZ4wHtPrSNY/KCblJj6eXM/QwCRq7tFDM6Ep7oeInmYg6FAxR7dAKj6QnC/lnSlUQbSDcErJwQ1+pIL4+LFEwUnRyzfuqb1lB2ngRiUC41nxEa5Ud6v/iWLgmbx7ph4/5b0c2CiP20s7fhPfYUAoi3YFBPZKEsu8t044PEtCoTGjbGW5ZOCbjr/VkGLzEk1BVsObbbs9GxVcG59AYZaeYrEYHplAEqaQ1VHjUeQRxRuoOAS8JP0C71LZeIkwfURP70FJHxxKPf45Z8/BF9VjUB92WcgvTpPoq4lclRJUARixPU4QwgqTepw3NSmwSQVIcYzrNK7DgQCZLjxNEdn+0NvLO56GoGI2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 14:09:04, Mike Snitzer wrote:
> Move the code in __filemap_get_folio_mpol() that clears PG_dropbehind
> on a folio found by a cached lookup, and takes the folio off
> WB_DONTCACHE_DIRTY, into filemap_clear_dropbehind().  No functional
> change.  The next patch changes the helper.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Mike Snitzer <snitzer@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 33 ++++++++++++++++++++-------------
>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b04be64a5069f..437113addbddf 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1956,6 +1956,24 @@ void *filemap_get_entry(struct address_space *mapping, pgoff_t index)
>  	return folio;
>  }
>  
> +/* Clear the dropbehind flag of a folio that a cached lookup found. */
> +static void filemap_clear_dropbehind(struct address_space *mapping,
> +				     struct folio *folio)
> +{
> +	if (!folio_test_clear_dropbehind(folio))
> +		return;
> +	if (folio_test_dirty(folio) && mapping_can_writeback(mapping)) {
> +		struct inode *inode = mapping->host;
> +		struct bdi_writeback *wb;
> +		struct wb_lock_cookie cookie = {};
> +		long nr = folio_nr_pages(folio);
> +
> +		wb = unlocked_inode_to_wb_begin(inode, &cookie);
> +		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> +		unlocked_inode_to_wb_end(inode, &cookie);
> +	}
> +}
> +
>  /**
>   * __filemap_get_folio_mpol - Find and get a reference to a folio.
>   * @mapping: The address_space to search.
> @@ -2087,19 +2105,8 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  	if (!folio)
>  		return ERR_PTR(-ENOENT);
>  	/* not an uncached lookup, clear uncached if set */
> -	if (!(fgp_flags & FGP_DONTCACHE) && folio_test_clear_dropbehind(folio)) {
> -		if (folio_test_dirty(folio) &&
> -		    mapping_can_writeback(mapping)) {
> -			struct inode *inode = mapping->host;
> -			struct bdi_writeback *wb;
> -			struct wb_lock_cookie cookie = {};
> -			long nr = folio_nr_pages(folio);
> -
> -			wb = unlocked_inode_to_wb_begin(inode, &cookie);
> -			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
> -			unlocked_inode_to_wb_end(inode, &cookie);
> -		}
> -	}
> +	if (!(fgp_flags & FGP_DONTCACHE))
> +		filemap_clear_dropbehind(mapping, folio);
>  	return folio;
>  }
>  EXPORT_SYMBOL(__filemap_get_folio_mpol);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

