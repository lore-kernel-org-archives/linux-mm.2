Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DBEDCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C488E0035; Mon, 13 Oct 2025 08:00:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033CA8E0007; Mon, 13 Oct 2025 08:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8C518E0035; Mon, 13 Oct 2025 08:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D95748E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:00:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72F3DC03B1
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:00:25 +0000 (UTC)
X-FDA: 83992948410.17.C2BB964
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31AD7A0016
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:00:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o3So9e0U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wqt8mG8b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o3So9e0U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wqt8mG8b;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760356823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+4ozAoCHFVPL2RaeOvGtQnbmZ7SwKWEtlu18MyCihJ0=;
	b=trZLLLmcRmMal+zw1N3ywd49HRqrTQmwhy30FKyGx6heSv0s3sby1p1Ixg9TRl7HJJZpC3
	15dHKmEmZPwHdk5w3BUEAcPpfr3szOrFwQ1Nzi0VxTKobZKwyM8x+Ywhk2xn8kdPrUsqPw
	daQN4HVl5+GEA0YUSFMvORh+Cd9DNJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760356823; a=rsa-sha256;
	cv=none;
	b=6JJ8FzGKMvOT3dmfYKte3qcB7t5OgqYYdeK6aygi+os01S93z5m/cYdmR2Px7pRabCzKdh
	LiUm29d5ESupAWkTG2tGe/4WhZyaFqLhzONP62t0rgjLMQZJDhuX7iL8pf8kHyYn+b5Eka
	JKGMP4wZkjLeQIPAIf0hR+i8DJW2Oas=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o3So9e0U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wqt8mG8b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o3So9e0U;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Wqt8mG8b;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B9FBC219BD;
	Mon, 13 Oct 2025 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4ozAoCHFVPL2RaeOvGtQnbmZ7SwKWEtlu18MyCihJ0=;
	b=o3So9e0Uth84O+PnIEh4Oun1iPQuZvVVPoCQHorbtKIwuu6mUgAwnbxgqugoKaZ+hKRSH5
	72mtDq2nhfqyGwMaACw7/a0TRsBTLgKar+wCPOoZVBdoRX1jz/WcNTz2KMAjy2i7nAYrXr
	po9DR7+9gbCBDVqbqs2APg8qOr6o1ts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4ozAoCHFVPL2RaeOvGtQnbmZ7SwKWEtlu18MyCihJ0=;
	b=Wqt8mG8b+3z6+GM7rCsz8+6pGorvjFjHtNKSx6T1X04EmFMGoXIOJQZmbr/RpktbXZgXJY
	gv9d+SK1c1CvXfAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356821; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4ozAoCHFVPL2RaeOvGtQnbmZ7SwKWEtlu18MyCihJ0=;
	b=o3So9e0Uth84O+PnIEh4Oun1iPQuZvVVPoCQHorbtKIwuu6mUgAwnbxgqugoKaZ+hKRSH5
	72mtDq2nhfqyGwMaACw7/a0TRsBTLgKar+wCPOoZVBdoRX1jz/WcNTz2KMAjy2i7nAYrXr
	po9DR7+9gbCBDVqbqs2APg8qOr6o1ts=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356821;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+4ozAoCHFVPL2RaeOvGtQnbmZ7SwKWEtlu18MyCihJ0=;
	b=Wqt8mG8b+3z6+GM7rCsz8+6pGorvjFjHtNKSx6T1X04EmFMGoXIOJQZmbr/RpktbXZgXJY
	gv9d+SK1c1CvXfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A729C13874;
	Mon, 13 Oct 2025 12:00:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id L1/OKNXp7Gj0AwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 12:00:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4C3FFA0A58; Mon, 13 Oct 2025 14:00:17 +0200 (CEST)
Date: Mon, 13 Oct 2025 14:00:17 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/10] mm: remove filemap_fdatawrite_wbc
Message-ID: <2iplfhsl7b6nsq7nf6fhre2udcqeujph6mfg22afssqhnvpdwd@pknnzyakfwxs>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-9-hch@lst.de>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Stat-Signature: owqexcrmhjrh5yna6k7r47onxr9mir41
X-Rspam-User: 
X-Rspamd-Queue-Id: 31AD7A0016
X-HE-Tag: 1760356822-501462
X-HE-Meta: U2FsdGVkX18zdf7p0jyf/Yg8wjkuwMiEPceVOqpIpoFwL4brk9YLglF5ji3Gd/iKpjSOVG49xavTdrFSmu6jflz0wuDzxVCAfm5Vjc//zd6lwBL+/xF9d4Z1RNnr+RTdRAqJqrGyk3BiTkJ62qYn2lJCSFZUL+ZBHfcR5kRyIEqjgsz2WjlHTDIRtQrnw2m6pIsHjwSsu60IVXk4ZTauEhu/p8Eeo4QD3zKFF/M+UJwqx9etMk8wwxd3cSFlU+7IsVMIlPHK4ne3HH/M6cOHEJW9szP/6hNv2TdNC4eTKtk5U3UlvJHtbAzXOyfSeDF9AmVeBAYIEipue88LgUCIaHoveBQ9QrXA/MELhjhhjCahibjX9bnul75iQAac9cn0/NhGaXNN9Kz3q/cRvamzF7yWhcjF97QNTXavBZOF1AlLQxov7IgRT8QfH9nz5AT9hyTFvrlmJCHYicnNi7qB9Zp6Atl34nLUuGMF6OM6k7Gc2gwTNQQEWonoF8he/RTcTbrrDqdezZqLyReEtLWOiooae6HNaHHCCtop5BVCQZGoetAqiluesLVa8QWiccsqnIuP6Zm2FNKKYokhGGnH/LVpVa8PVAAyXchFf4Gr15DdTWZWu9fCP3IM0a4drrhxWiTNQFFmASFLBhY1Y+tXzb0TH/b5VNpSKrX5j6ogcZkLcOaq9EDp13wqLIpkmxsVUx/2BBN9eccO+HhHA03FiT1SqrFUjrkhnYuQuLy19x8kJJXtmXWBkjy26htWyGDiUwitq41RglnOqF09brSP8eRfa/2UwvOEoea7iXHFFTwI88chGJwsTW4RdhU61YkqZerQlveSCO+Y2G03D0augdITF51QdIrkITwNqXYATr18rcTPZkI+IIA8nOfByNVRwd6jvAjXtuoF93jfCrWOn1Vcnu/mp6KOeIQKXurzoH2gtAx+VRlPfc5mDzFFUTtv5+Z3Mds2/moC+cIu8np
 gdRVcFly
 VHjIj7eastrzIICqqZW3pg+oohQVjtGPRRqMb65Te2ZteFLc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:58:03, Christoph Hellwig wrote:
> Replace filemap_fdatawrite_wbc, which exposes a writeback_control to the
> callers with a __filemap_fdatawrite helper that takes all the possible
> arguments and declares the writeback_control itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/pagemap.h |  2 --
>  mm/filemap.c            | 54 ++++++++++++++---------------------------
>  2 files changed, 18 insertions(+), 38 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index fc060ce2d31d..742ba1dd3990 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -61,8 +61,6 @@ int filemap_fdatawrite_range(struct address_space *mapping,
>  		loff_t start, loff_t end);
>  int filemap_check_errors(struct address_space *mapping);
>  void __filemap_set_wb_err(struct address_space *mapping, int err);
> -int filemap_fdatawrite_wbc(struct address_space *mapping,
> -			   struct writeback_control *wbc);
>  int kiocb_write_and_wait(struct kiocb *iocb, size_t count);
>  
>  static inline int filemap_write_and_wait(struct address_space *mapping)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index bbd5d5eaa661..26b692dbf091 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -366,31 +366,30 @@ static int filemap_check_and_keep_errors(struct address_space *mapping)
>  	return 0;
>  }
>  
> -/**
> - * filemap_fdatawrite_wbc - start writeback on mapping dirty pages in range
> - * @mapping:	address space structure to write
> - * @wbc:	the writeback_control controlling the writeout
> - *
> - * Call writepages on the mapping using the provided wbc to control the
> - * writeout.
> - *
> - * Return: %0 on success, negative error code otherwise.
> - */
> -int filemap_fdatawrite_wbc(struct address_space *mapping,
> -			   struct writeback_control *wbc)
> +static int __filemap_fdatawrite(struct address_space *mapping, loff_t start,
> +		loff_t end, enum writeback_sync_modes sync_mode,
> +		long *nr_to_write)
>  {
> +	struct writeback_control wbc = {
> +		.sync_mode	= sync_mode,
> +		.nr_to_write	= nr_to_write ? *nr_to_write : LONG_MAX,
> +		.range_start	= start,
> +		.range_end	= end,
> +	};
>  	int ret;
>  
>  	if (!mapping_can_writeback(mapping) ||
>  	    !mapping_tagged(mapping, PAGECACHE_TAG_DIRTY))
>  		return 0;
>  
> -	wbc_attach_fdatawrite_inode(wbc, mapping->host);
> -	ret = do_writepages(mapping, wbc);
> -	wbc_detach_inode(wbc);
> +	wbc_attach_fdatawrite_inode(&wbc, mapping->host);
> +	ret = do_writepages(mapping, &wbc);
> +	wbc_detach_inode(&wbc);
> +
> +	if (!ret && nr_to_write)
> +		*nr_to_write = wbc.nr_to_write;
>  	return ret;
>  }
> -EXPORT_SYMBOL(filemap_fdatawrite_wbc);
>  
>  /**
>   * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
> @@ -412,14 +411,7 @@ EXPORT_SYMBOL(filemap_fdatawrite_wbc);
>  int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>  				loff_t end, int sync_mode)
>  {
> -	struct writeback_control wbc = {
> -		.sync_mode = sync_mode,
> -		.nr_to_write = LONG_MAX,
> -		.range_start = start,
> -		.range_end = end,
> -	};
> -
> -	return filemap_fdatawrite_wbc(mapping, &wbc);
> +	return __filemap_fdatawrite(mapping, start, end, sync_mode, NULL);
>  }
>  
>  int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> @@ -475,18 +467,8 @@ EXPORT_SYMBOL(filemap_flush);
>   */
>  int filemap_fdatawrite_kick_nr(struct address_space *mapping, long *nr_to_write)
>  {
> -	struct writeback_control wbc = {
> -		.nr_to_write = *nr_to_write,
> -		.sync_mode = WB_SYNC_NONE,
> -		.range_start = 0,
> -		.range_end = LLONG_MAX,
> -	};
> -	int ret;
> -
> -	ret = filemap_fdatawrite_wbc(mapping, &wbc);
> -	if (!ret)
> -		*nr_to_write = wbc.nr_to_write;
> -	return ret;
> +	return __filemap_fdatawrite(mapping, 0, LLONG_MAX, WB_SYNC_NONE,
> +			nr_to_write);
>  }
>  EXPORT_SYMBOL_FOR_MODULES(filemap_fdatawrite_kick_nr, "btrfs");
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

