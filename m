Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D5CD58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00D396B008C; Mon,  2 Mar 2026 04:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD7B6B0092; Mon,  2 Mar 2026 04:13:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00716B0093; Mon,  2 Mar 2026 04:13:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC0FD6B008C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:13:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 695978CB4B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:13:35 +0000 (UTC)
X-FDA: 84500559990.26.23539BA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 27B2C40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:13:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IvEjFCwM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AqAAIUzO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F9W9Vysl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7AZC4XVw;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yiUa0ECJNPtkTnLKrDvGHBfFKQ79sQHYL43l9NzCiHc=;
	b=ZRUPWI5EPXgD4FPaTj7HJbYpjSVLfk+PtJ9Bm+ojL/JYcWScUOoZHDJQP3Z3bsj5EE5kiV
	WKDEI2Fr0rPXxk8IxyFSWABHjALfpy5Bj88xxHoRWu2SOGr6nXkdd8CG0Hzz72KbuZXDl1
	4yzzUoBUGMui4Nrq3y5DaFMs7vEAABk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=IvEjFCwM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AqAAIUzO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F9W9Vysl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7AZC4XVw;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442813; a=rsa-sha256;
	cv=none;
	b=BphYPF8fgiQKXFmyKxgv811DZCMTzQmsa10JJlLOLpq3LfwGdfHMSJF73saGH2RsyE/6Sd
	r90krRyeil7VDPUJKYVLePlUyeiAne0UKue+kExLDAW2d6qOkCwYUflMQBpS12TEBYAzA4
	9N+iWHc421g1/s9+ZonlUwqsgMPhnno=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 310733E7C9;
	Mon,  2 Mar 2026 09:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772442811; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiUa0ECJNPtkTnLKrDvGHBfFKQ79sQHYL43l9NzCiHc=;
	b=IvEjFCwMg8Ig9GtG1dDAi58hup1nQvtBAtjeECQAyWwZdCIo/N2Wtz9V4ScqMC3i1Kc/9P
	BJl8rCMRij6Dzd7CULioRD1AxUHgYCUfs/G8b7USMupWSeSxwvTSSVBBvhg1adhiQUbsDL
	N8sjoY6XUREb5Rjda6utCrHWcrwv+6o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772442811;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiUa0ECJNPtkTnLKrDvGHBfFKQ79sQHYL43l9NzCiHc=;
	b=AqAAIUzOF2Yy8M0YGYw+xIT5ecVWBxEF7GGlyH2RlDAtVRjY8xURwtY0Fge1fc1Eu6m1b4
	1IWqT4IXLYEjjuCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772442810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiUa0ECJNPtkTnLKrDvGHBfFKQ79sQHYL43l9NzCiHc=;
	b=F9W9VyslnpsJVBa1jGUWLmw0W8jMV2z6VYvjzKm7M03b5bnq9P5qwL7/U0i1ZSQU6C2pbI
	YsbQUDFVtuTCrLlmWhf7TnblMwGoP1Lob8tLesykv8mR+l4wD8IjEbdEXww5Ti9BrUDE7t
	y0ogEiknF9fugD7F1izz71MC8hRbBh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772442810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yiUa0ECJNPtkTnLKrDvGHBfFKQ79sQHYL43l9NzCiHc=;
	b=7AZC4XVwYmP//tW6373ZF3FORac015k3gIhkGjb//YXMNtGKxtqEb4iA817SUEpzMJ1ChM
	YqxVvGdP8on/5MDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 174783EA69;
	Mon,  2 Mar 2026 09:13:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sbavBbpUpWnXYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Mar 2026 09:13:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CAF0DA0A27; Mon,  2 Mar 2026 10:13:29 +0100 (CET)
Date: Mon, 2 Mar 2026 10:13:29 +0100
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH RFC v3 2/2] block: enable RWF_DONTCACHE for block devices
Message-ID: <blipvn6pfxno5a2cih3e7y2l7g3cbj4yjb6hhwxrer26ma5x55@ez6hhpdfsi63>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
 <20260227-blk-dontcache-v3-2-cd309ccd5868@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-blk-dontcache-v3-2-cd309ccd5868@columbia.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: 27B2C40004
X-Rspamd-Server: rspam08
X-Stat-Signature: 9c9n1sm6eqrs7dezm6p3e6qthwej1p9c
X-HE-Tag: 1772442812-145428
X-HE-Meta: U2FsdGVkX1+xvbd20J9QNPL/iPVUZEc9yRrJIqgz+tg2eYcNP+9x+LVzjYDUu5e0yi8nxIEU8UGGZ53OJpmLT6bFPitUZc3NNDLslX7kNv0ogwObcu43n7zMQZgWqV4oBQ0JZIY+AoJzVRLtEkKYeI3ryX7AnXGdhyUsS11sjjA9oBdNRTYfwfooyer+Z5y1ZVOgHcpw6Of1PiuHyvhDwvi6ezXqqI/JsBUF5PFOk+Ov3YjUVzXEu75ZKZI6pvYgrvdYTwJu/utCwA3WkokzPUB2WksliqvGQAdVG5KBj2xUGYRpTuk8j7fxjsw7PxhEhFclZmZE4MtDIsWlnCaR+RZcer8awtzcl+gaetzCTSxSxYKsxlF4SnUY+adKlYcqvMsv4bdl20wvXa1O0G8q7rgJFpnYh1YvYeQDm67Upetp5CvaW8bOfPjWyVlep5/yLaBNBlix7f8c4lW8GnfPggAeVgWOi/j2SOShOAUniZUe2/DJp6M6NFP/4QkwIEsKm/NU/nYW+s7hrMC7MvK3sY4AVfZO+SD6ZrpwHKxzBrc5ph6zzverwt1FsXg913cM+LuX0AZj+Y7nVeHJV/1npLDQVXqFRSdq7h5X8FakkCWV7ulct9rk111XYs0L3n+fZrVGBi7X6f2ahA68R/d5yJ1kP4tXkSrqiHkBRVQU0ZNIQPgj1JfKVwkB0FVS2n0hr7niymgi05TjczZIOFT+JjPHYH8m65O3m7owVB99YfGPjLZuz1hsiUM1uaD9M0Z17g1FoHo3x/sa9ty/RdkPt/G3fW7NFwt+27yOBWL+E3KDAKHJgv1Do0WMS2PNBeGMAmQie6ne6CtGTLYlYNYe+U3YBdpjCaGRQk8OhAZ7XQYfUD0qsGs/Jz2u15nVmynhWcpVQLlk7gBgCvRr3OSe1BUyOoEkMLjL5QyUUn+odaHG+f3sbtjdpciIgEcEx1g47xviSKPSrizTZsmQ7W/
 /AMEUvIA
 MsfpN4rMp7DhcOLezR1eaCJn3a6Ep0fNee9H2MquDC03AZq0vsaykYgqdbmKfFw5iIt4JD5E6p01s7iplUzDNZ4TCrJcbM02BKMCJv3LU1e6fCripWRE0Ry+EZqB/g5Fe7+uujEKqA/8rPBeaM7QofJ3RZl01skNubDC+vsHsDgKS000K5iRjtMGoyw/peghEmLzozwfm7BFIa2jN8I3alZFDelks5GCRRyfWG+JQghrorgzUJVknuU++AzoNB+jRC30RRqjp3CFmZnYryxkmE3RGxAnmwUN5gyPG5sWE0SrAFdofjZGhTtTc9VggYZrckqn9LxMfsqGJ3Bswh7VcKCfmPujaHeG8ZXqLc231qCJDnU2x/5vG8/DkbpnYWmAxqQgSJF/s2eToMI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 27-02-26 11:41:08, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD paths, add block_write_begin_iocb() which threads
> the kiocb through so that buffer_head-based I/O can use DONTCACHE
> behavior. The existing block_write_begin() is preserved as a wrapper
> that passes a NULL iocb.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/fops.c                |  5 +++--
>  fs/buffer.c                 | 19 ++++++++++++++++---
>  include/linux/buffer_head.h |  3 +++
>  3 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 4d32785b31d9..d8165f6ba71c 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -505,7 +505,8 @@ static int blkdev_write_begin(const struct kiocb *iocb,
>  			      unsigned len, struct folio **foliop,
>  			      void **fsdata)
>  {
> -	return block_write_begin(mapping, pos, len, foliop, blkdev_get_block);
> +	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
> +				     blkdev_get_block);
>  }
>  
>  static int blkdev_write_end(const struct kiocb *iocb,
> @@ -967,7 +968,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 838c0c571022..18f1d128bb19 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -2241,14 +2241,19 @@ EXPORT_SYMBOL(block_commit_write);
>   *
>   * The filesystem needs to handle block truncation upon failure.
>   */
> -int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block)
>  {
>  	pgoff_t index = pos >> PAGE_SHIFT;
> +	fgf_t fgp_flags = FGP_WRITEBEGIN;
>  	struct folio *folio;
>  	int status;
>  
> -	folio = __filemap_get_folio(mapping, index, FGP_WRITEBEGIN,
> +	if (iocb && iocb->ki_flags & IOCB_DONTCACHE)
> +		fgp_flags |= FGP_DONTCACHE;
> +
> +	folio = __filemap_get_folio(mapping, index, fgp_flags,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio))
>  		return PTR_ERR(folio);
> @@ -2263,6 +2268,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  	*foliop = folio;
>  	return status;
>  }
> +
> +int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block)
> +{
> +	return block_write_begin_iocb(NULL, mapping, pos, len, foliop,
> +				      get_block);
> +}
>  EXPORT_SYMBOL(block_write_begin);
>  
>  int block_write_end(loff_t pos, unsigned len, unsigned copied,
> @@ -2591,7 +2603,8 @@ int cont_write_begin(const struct kiocb *iocb, struct address_space *mapping,
>  		(*bytes)++;
>  	}
>  
> -	return block_write_begin(mapping, pos, len, foliop, get_block);
> +	return block_write_begin_iocb(iocb, mapping, pos, len, foliop,
> +				     get_block);
>  }
>  EXPORT_SYMBOL(cont_write_begin);
>  
> diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
> index b16b88bfbc3e..ddf88ce290f2 100644
> --- a/include/linux/buffer_head.h
> +++ b/include/linux/buffer_head.h
> @@ -260,6 +260,9 @@ int block_read_full_folio(struct folio *, get_block_t *);
>  bool block_is_partially_uptodate(struct folio *, size_t from, size_t count);
>  int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
>  		struct folio **foliop, get_block_t *get_block);
> +int block_write_begin_iocb(const struct kiocb *iocb,
> +		struct address_space *mapping, loff_t pos, unsigned len,
> +		struct folio **foliop, get_block_t *get_block);
>  int __block_write_begin(struct folio *folio, loff_t pos, unsigned len,
>  		get_block_t *get_block);
>  int block_write_end(loff_t pos, unsigned len, unsigned copied, struct folio *);
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

