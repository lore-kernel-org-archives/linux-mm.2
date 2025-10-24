Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F34CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA498E0081; Fri, 24 Oct 2025 08:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AF88E0042; Fri, 24 Oct 2025 08:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2E778E0081; Fri, 24 Oct 2025 08:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9E068E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:09:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 67AF2496E5
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:09:28 +0000 (UTC)
X-FDA: 84032888016.04.666C1A2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id EF20220003
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:09:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lUfDGig/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mc8jLQtK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lUfDGig/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mc8jLQtK;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761307766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQR+rmk5JJXbJh11H9IDr0zLIVayrC9/4bdXvKTXH9w=;
	b=adBd+tvT0d1tPBhWE7oQUjYfnx1jO6cwfdSIJXl3cvv9BWTU8mikhumckMpDyV6tCGFLgT
	AUDFEGICKlnVVBfZCYXR4w0d1idVzyUFXqey2YdIoGB9eH+9OaP8kJBAaDLAQovX5C3CZ9
	1kPkmP0TatN5Nygakk/xbwzEootti5Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lUfDGig/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mc8jLQtK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="lUfDGig/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mc8jLQtK;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761307766; a=rsa-sha256;
	cv=none;
	b=7OmiIc3BNbVyWrMti309jGwWlgJeLXBV98psIb30g8m0FeOxdXhXhkM/Q/IWxS50tS4Y09
	LBwOZfbI7paHPyWJZdJotJ4K6PLwRiQB7gyJxtGlZ9fTa/5f3hKP2kkEMC5N1v4Sx5Qhct
	XwiO1F0oQOKkGoYitpCU76BH8HFgcyA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F4EA211BF;
	Fri, 24 Oct 2025 12:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761307764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQR+rmk5JJXbJh11H9IDr0zLIVayrC9/4bdXvKTXH9w=;
	b=lUfDGig/qurmVZAmpVVx1+6t4iItNTrwBssMnwosNyjfn/OD41thPRQZws77hFfL6Shbsy
	/S9YqER4is+c4uGjNaQv3YFeDuyT0hStEhOQ2hit/J3SmVLYsa73EEYwWDh/m4urXkFC6I
	jH1zSZOKjUxxP40wfWPq8Sh3ZY1JEYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761307764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQR+rmk5JJXbJh11H9IDr0zLIVayrC9/4bdXvKTXH9w=;
	b=mc8jLQtKYuPOW4qIpvZhNNIhKVbUYxR27PH60LKkwxa7HFmNGDGYRGd0EQxn29H/BahXv3
	NUfOFibub6Ppi6Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761307764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQR+rmk5JJXbJh11H9IDr0zLIVayrC9/4bdXvKTXH9w=;
	b=lUfDGig/qurmVZAmpVVx1+6t4iItNTrwBssMnwosNyjfn/OD41thPRQZws77hFfL6Shbsy
	/S9YqER4is+c4uGjNaQv3YFeDuyT0hStEhOQ2hit/J3SmVLYsa73EEYwWDh/m4urXkFC6I
	jH1zSZOKjUxxP40wfWPq8Sh3ZY1JEYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761307764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TQR+rmk5JJXbJh11H9IDr0zLIVayrC9/4bdXvKTXH9w=;
	b=mc8jLQtKYuPOW4qIpvZhNNIhKVbUYxR27PH60LKkwxa7HFmNGDGYRGd0EQxn29H/BahXv3
	NUfOFibub6Ppi6Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0A0B13693;
	Fri, 24 Oct 2025 12:09:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7k/ONnNs+2ikNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 24 Oct 2025 12:09:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 33729A28AB; Fri, 24 Oct 2025 14:09:23 +0200 (CEST)
Date: Fri, 24 Oct 2025 14:09:23 +0200
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
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@redhat.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 06/10] mm,btrfs: add a filemap_flush_nr helper
Message-ID: <myxuxundkuabvgmym5ayqycxjgzjgcxn35ncuxpmdxgwjc7ht4@utx2jecj6wpq>
References: <20251024080431.324236-1-hch@lst.de>
 <20251024080431.324236-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024080431.324236-7-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: EF20220003
X-Rspamd-Server: rspam03
X-Stat-Signature: 3rpphianabmjcm9arxzayi7k78bntc59
X-HE-Tag: 1761307765-324492
X-HE-Meta: U2FsdGVkX1+Is0HemtpobNtnKE1yt9lO6ogwXPsea3oS4Skcl77X4VPlOqMjMjDl+wVlqf4ShzZLkx39dvTcQaQz+xOdOz/X+HPZOLN3RcxAH907YVWimjWGSjtlPXW/70aUnMGtvV1iF/f+WRME0REUCkNlxsdhi30WRm6x2Rg3xaUlvU0i8HVcdcX216DVmbntfAVkMX94ewieX2jLEzmPUd9b1k12sOvJkb0kp68Y1k1fujImDQ+9I4zAzem/QBCq1H0gzuDWnGuWvb21/52bNktuDCvs8AeHYT8Qb+nYMElhWBzN8snHdYJ0Lv5aocJflRAfWUPnTeXLTjGj1rj9ZiLdEUnMB9U8WQHzUOtlUh2Pwwp/aDQbRocbL0580Oq8vyZogTzZ59qv1Ib2yIdHwD/LtXWqSAvI7zhQl6oeMi8h0O9EFm3P6GbILvqaCHdlNy140esRAwAGXfSo2KS+LSK6/HHFeYHmSn48x4DM5iZdIQNna0QQNy0m8oQhHOOP2WslvzWJ8asDS21/UbEsxLXG4le5jKsokg3Q7Kk4Yhc+sQ0N5ilYzRiAM+NNtMAZ74/5fJqF40k2gJcRmv92xUMNIfCUK89vzAyk9IDeoFB3Dax5D7caU3NZu0a9AlZE7RGEZVHdPPOaO/zccqIlV/h8IIvYJJqOAzc+6BxtXQG6zgL9LpAqXJTk9Mxhm7Qa5+JggYk1N2V1YRpY1qEnL34q7SqSM/1pj7NuBV/UhKxufr1yjZOG8gp96zCxGnbu5DPOZ+rwG0TZkfzwio7VGBO7L6TuV/6x79MgaIiOyNXeNK/TrxHJlrmlBG3dRLV6wxem1/ft0+szae3DAkE20R+kKLnAZ3KkXrSPpk9/H3FE5LycQ7saKjhOZpmIxzEfvwpOx592zNUhjf8BqiMz6qTHgVxb3x/t+GdK1ctM9RIgagAZgLZYSuAK4p1azr8Ey0l8QkBEVMHqf6Z
 M4UUzidu
 Nqic3Lx4L2dCCo3WVcdtPVTUsTt9IX0Fm41uDd76Qo9+d5O44tyJ3nNs+OZEzenE4V1m283XWpVI67PkbdzzpVkBZ402l3gOJTYqYFeyI5P1vMU+Mq8rFXUk8ZlZcBtnwwH/ZuzAvVwqf5y3wgyV/yH6zs52uraGwTZtAztYWxle5zlXJ7QnQKUtPD6ekhhsGFXanMJfjCXuV3MzclmLb7FhkiAtucXvjQb4fC++cvOlGxzwksMws6aiwFh70h64JCSiYQeXYMtmm38SjHDrp5+ujDlSfXob3QD3TnpqCTxjZIqxc7n/uVp2iHc3dwLvykIaSDGHSaFdXi7IZ5+J9xWH9ONG4aHBMvCRNx8FDWPvNb7P5++VJo+ziB57OW/JzDM+6FpdhXhivH1QNEaxZVcgSWvWvPQoLBjCB48Y42alOcSyJ8JNPcO+XxwFu2wQmQ2vnUMkGuKHp0UpQdV6xN80jRof0x30racNtspaPimDREa7860m6R5Bahrek4qVs2bFz4AV+n+EDiBPKMyyYhkPW0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-10-25 10:04:17, Christoph Hellwig wrote:
> Abstract out the btrfs-specific behavior of kicking off I/O on a number
> of pages on an address_space into a well-defined helper.
> 
> Note: there is no kerneldoc comment for the new function because it is
> not part of the public API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/btrfs/inode.c        | 13 ++-----------
>  include/linux/pagemap.h |  1 +
>  mm/filemap.c            | 22 ++++++++++++++++++++++
>  3 files changed, 25 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index b97d6c1f7772..d12b8116adde 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8752,19 +8752,10 @@ static int start_delalloc_inodes(struct btrfs_root *root, long *nr_to_write,
>  			btrfs_queue_work(root->fs_info->flush_workers,
>  					 &work->work);
>  		} else {
> -			struct writeback_control wbc = {
> -				.nr_to_write = *nr_to_write,
> -				.sync_mode = WB_SYNC_NONE,
> -				.range_start = 0,
> -				.range_end = LLONG_MAX,
> -			};
> -
> -			ret = filemap_fdatawrite_wbc(tmp_inode->i_mapping,
> -					&wbc);
> +			ret = filemap_flush_nr(tmp_inode->i_mapping,
> +					nr_to_write);
>  			btrfs_add_delayed_iput(inode);
>  
> -			if (*nr_to_write != LONG_MAX)
> -				*nr_to_write = wbc.nr_to_write;
>  			if (ret || *nr_to_write <= 0)
>  				goto out;
>  		}
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 09b581c1d878..cebdf160d3dd 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -38,6 +38,7 @@ int filemap_invalidate_pages(struct address_space *mapping,
>  int write_inode_now(struct inode *, int sync);
>  int filemap_fdatawrite(struct address_space *);
>  int filemap_flush(struct address_space *);
> +int filemap_flush_nr(struct address_space *mapping, long *nr_to_write);
>  int filemap_fdatawait_keep_errors(struct address_space *mapping);
>  int filemap_fdatawait_range(struct address_space *, loff_t lstart, loff_t lend);
>  int filemap_fdatawait_range_keep_errors(struct address_space *mapping,
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 99d6919af60d..e344b79a012d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -474,6 +474,28 @@ int filemap_flush(struct address_space *mapping)
>  }
>  EXPORT_SYMBOL(filemap_flush);
>  
> +/*
> + * Start writeback on @nr_to_write pages from @mapping.  No one but the existing
> + * btrfs caller should be using this.  Talk to linux-mm if you think adding a
> + * new caller is a good idea.
> + */
> +int filemap_flush_nr(struct address_space *mapping, long *nr_to_write)
> +{
> +	struct writeback_control wbc = {
> +		.nr_to_write = *nr_to_write,
> +		.sync_mode = WB_SYNC_NONE,
> +		.range_start = 0,
> +		.range_end = LLONG_MAX,
> +	};
> +	int ret;
> +
> +	ret = filemap_fdatawrite_wbc(mapping, &wbc);
> +	if (!ret)
> +		*nr_to_write = wbc.nr_to_write;
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_MODULES(filemap_flush_nr, "btrfs");
> +
>  /**
>   * filemap_range_has_page - check if a page exists in range.
>   * @mapping:           address space within which to check
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

