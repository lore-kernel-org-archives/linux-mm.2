Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBEECCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60048E0036; Mon, 13 Oct 2025 08:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10AC8E0007; Mon, 13 Oct 2025 08:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D8578E0036; Mon, 13 Oct 2025 08:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85D2F8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:03:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1BCA0C03DD
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:03:29 +0000 (UTC)
X-FDA: 83992956138.09.8293445
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id B225B1C0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:03:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I6Tu6QEx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F5tMp6sH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b+bmMbsY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uZgagJZ4;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760357007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxSdY8AEzXNttMyqmikG4KICkG68sQmVXDungx9myyE=;
	b=olSndPJ5IP7YPmoB5UmIwSl3vNKSo+kjTzl23XH7WmDSHx45dlj//EjzpSpaWx34v06RPu
	sPe10k9Tdhy5cYedcka+gd7YNWcdsgqBcrXPSwzMySTv4z9pSvQyvpfQ5ozKn0xP3HGCiW
	PhcbqFovRvmYW6zEwFuhxQWK1A5e7VQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=I6Tu6QEx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F5tMp6sH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=b+bmMbsY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uZgagJZ4;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760357007; a=rsa-sha256;
	cv=none;
	b=QVdJOUbx5p7ohBapdwQOkRWe7OaQzpmdXI88Ys8bR3Fn6FwobHeULRPFMU9cv4zqjxkSgB
	1N371t/GvAzfXzf2dEyo1fCKqzk6lB+qCzqIBltvj1sXswiB/zTrt79bTdh7jLVzigUWRh
	FwiZ5UQ4y79qwLz4SdVe5sTIOJvzWhQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 53E081F385;
	Mon, 13 Oct 2025 12:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760357005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxSdY8AEzXNttMyqmikG4KICkG68sQmVXDungx9myyE=;
	b=I6Tu6QExFV+dBebEO5FqWa4CnC/ZtZN0xOyEGAncmWdGoa0IVFsax7N9267RYZWCI4yDAe
	BFW3FdZz+2JOTd98CT1+hWculdJYDQ4LNt3cLfzcA4cAZIcrGHgW7En1dyBj0473RkMG9T
	OUcuSbJaN4bH1iJ36A29HSmcMeKxvDw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760357005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxSdY8AEzXNttMyqmikG4KICkG68sQmVXDungx9myyE=;
	b=F5tMp6sHebc1bFNq3o1qlBgdw7WXSa0vxFWNhLozJ6p13Cc8QTGnffMoJWdwcUfP+UgWDy
	WJo390eCPwLnUVDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760357004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxSdY8AEzXNttMyqmikG4KICkG68sQmVXDungx9myyE=;
	b=b+bmMbsYtdbqriqZU30MLE3rigTOge9VFILpR3ZAxAIp87aWzR0HZf5iXLy3Qmlc7o6ht4
	iBQVFePWgwKhRReC07vwR6ym9gJe2q+JZ+tpStLqlpxQvsC3xZPYxQhmVE3Yls+FXyCsJC
	G2vN2Sg2zwqFIUtoWSVWz9su12YR4E0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760357004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gxSdY8AEzXNttMyqmikG4KICkG68sQmVXDungx9myyE=;
	b=uZgagJZ4MaG1boq9mL70Dd8Oh/MLQG+tSddPXnq7M9Ii3bXEdvfa5li/T/T78DRLB8vpiJ
	ZCtWGQBAtDwPq6DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4362513874;
	Mon, 13 Oct 2025 12:03:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TKZxEIzq7GgcBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 12:03:24 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EBC7BA0A58; Mon, 13 Oct 2025 14:03:15 +0200 (CEST)
Date: Mon, 13 Oct 2025 14:03:15 +0200
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
Subject: Re: [PATCH 09/10] mm: remove __filemap_fdatawrite_range
Message-ID: <ggj5mx662pc6557zthvqfbzcjzbltjntvf5ly5bj3czeof6ute@r3cjumpx3gtp>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-10-hch@lst.de>
X-Stat-Signature: bidfj6cpqtnjj4x1ugyzcm955dwhufqw
X-Rspamd-Queue-Id: B225B1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760357006-313108
X-HE-Meta: U2FsdGVkX18bm/mEw7GldOQkTR4ZXYSBF/0BAxnvE7Yu7bjVbCEww0NRjfd3wXPc4LXvAYLYMIkLiEYFGTYlxyGXbMxsLK5iPATI/97v6ifAZQmFGvraQ3yEQvEmqlNLGMkL0yEtfmLPkZoW4em90OH0mpRRkMAH6gB7TIdhUbB5fO06Yw88DeUWgeIqYLJo/MAiwJAKDxZjQSNk8RLOhHI/ozvlWOl1yaWQppCZcbMpsn44Q/1fRoSzGj94TWKCYiuOMqrHv2IEQFykPqTvqcZkxHOkCP41BMmMsavxU39d0Hf2CoCH4eeayyiUPpeWoB+CV13DIKxrroaWnNAEtsHiTtJjv5+EccYE5XgbbMPZb7j7YKKXVbEn8GNnsqYe60WQ7QmtleWR5OsyzLLuI2+1878hvH0LoxtDnC9bPqkDpAE2HhG3ysvu1etvFeLniTwPbU3mVJgcQqCf1ZIQXvbZL7Ch7UvzU9EzoQqZ4Qi7CNn/wZexe7PuvsgBvT5/dbvbQnPzXhU6TnAqeHYoDG4mpn9g+9GPH87R0SUWtKNDZBNWRCMDjfmwtgTKHM6415Pw1k9GHBIvBCFE8UIv4nRs4Nlc78bY/+UydRIIJ1ZD37UquOLQZQxGMSP0csbefG9cIb8PgdMc3zyNV1Ri2q7es7QacSJiDZBt0jL12fwKsMmP7bwLpE5/2A4+vNqEj5jRDX5aw45NNicAQHgWhvPbCjndECygU8IlV5goVbpNkzqZvUGQ9Eix6z30kDQq3DkDItAmYe9R6kXWFUmlvlTsaHMQDtRpC46WGlvDqE5SqfbW+5wk0V0N/LDA0Aqyej2yc8GJbuTMsD9nsUZdnNQRIk3zQ0PevgWlq00fnhlfT9ZDYKeBcEw3FrlIRWdkV1TrcuHFQlbs3Y2WSdjbqRDvPGex8HZNH3i2cZq+hViNCpo96LsqR8R+KZeO+1bEBDZH1qEImFJ2G5WX/An
 Bi7CTjpC
 XjycLprIr2dx3nLyNUvzAa0fpOhvWlZHGctuotS1abQmtkBnAE6kXy0D0HToEMed7p2NkLznPuvZR7q9DwEGq63YGkifJP7ikXkFgOxFtDuHpVrb7sEJaMxbxgbj52ry+Ep5z2jHqhLQnx634LYGkKvt2oNnmBREOLkJObEixEvEIFR3sHPZrXYeZYVUn1l54e/6BWz+rJAys5zuatJcWWhYrL4L0rvhjXJKRwgcachKeGYIF5nsCbzBh1X+uxm02cpVn7GLbzqZCokSfnpg/AVWHPDWajz1GZV2zqGesgZFxZEFpvL4cRN3g/vdoyGzVgJO05N6MDhsBBUc65uKLQwLWUf+1v9wuSDJ4iKQUu2HR91LIyGsjg/5Djuyktl62D4cl4szUBt+nMHKLSgUDnwKAuAclsYa2Aj72/4WPqCtGxCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:58:04, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range and filemap_fdatawrite_range_kick instead
> of the low-level __filemap_fdatawrite_range that requires the caller
> to know the internals of the writeback_control structure and remove
> __filemap_fdatawrite_range now that it is trivial and only two callers
> would be left.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c       |  6 +++---
>  fs/sync.c               | 11 +++++------
>  include/linux/pagemap.h |  2 --
>  mm/fadvise.c            |  3 +--
>  mm/filemap.c            | 25 +++++++------------------
>  5 files changed, 16 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..8b002ab18103 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -807,9 +807,9 @@ static void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
>   * @wbc: writeback_control of interest
>   * @inode: target inode
>   *
> - * This function is to be used by __filemap_fdatawrite_range(), which is an
> - * alternative entry point into writeback code, and first ensures @inode is
> - * associated with a bdi_writeback and attaches it to @wbc.
> + * This function is to be used by filemap_fdatawrite*(), which write back data
> + * from arbitrary threads instead of the main writeback thread to ensure @inode
> + * is associated with a bdi_writeback and attached to @wbc.
>   */
>  void wbc_attach_fdatawrite_inode(struct writeback_control *wbc,
>  		struct inode *inode)
> diff --git a/fs/sync.c b/fs/sync.c
> index 2955cd4c77a3..6d8b04e04c3c 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -280,14 +280,13 @@ int sync_file_range(struct file *file, loff_t offset, loff_t nbytes,
>  	}
>  
>  	if (flags & SYNC_FILE_RANGE_WRITE) {
> -		int sync_mode = WB_SYNC_NONE;
> -
>  		if ((flags & SYNC_FILE_RANGE_WRITE_AND_WAIT) ==
>  			     SYNC_FILE_RANGE_WRITE_AND_WAIT)
> -			sync_mode = WB_SYNC_ALL;
> -
> -		ret = __filemap_fdatawrite_range(mapping, offset, endbyte,
> -						 sync_mode);
> +			ret = filemap_fdatawrite_range(mapping, offset,
> +					endbyte);
> +		else
> +			ret = filemap_fdatawrite_range_kick(mapping, offset,
> +					endbyte);
>  		if (ret < 0)
>  			goto out;
>  	}
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 742ba1dd3990..664f23f2330a 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -55,8 +55,6 @@ static inline int filemap_fdatawait(struct address_space *mapping)
>  bool filemap_range_has_page(struct address_space *, loff_t lstart, loff_t lend);
>  int filemap_write_and_wait_range(struct address_space *mapping,
>  		loff_t lstart, loff_t lend);
> -int __filemap_fdatawrite_range(struct address_space *mapping,
> -		loff_t start, loff_t end, int sync_mode);
>  int filemap_fdatawrite_range(struct address_space *mapping,
>  		loff_t start, loff_t end);
>  int filemap_check_errors(struct address_space *mapping);
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 588fe76c5a14..f1be619f0e58 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -111,8 +111,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  		spin_unlock(&file->f_lock);
>  		break;
>  	case POSIX_FADV_DONTNEED:
> -		__filemap_fdatawrite_range(mapping, offset, endbyte,
> -					   WB_SYNC_NONE);
> +		filemap_fdatawrite_range_kick(mapping, offset, endbyte);
>  
>  		/*
>  		 * First and last FULL page! Partial pages are deliberately
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 26b692dbf091..ec19ed127de2 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -392,32 +392,23 @@ static int __filemap_fdatawrite(struct address_space *mapping, loff_t start,
>  }
>  
>  /**
> - * __filemap_fdatawrite_range - start writeback on mapping dirty pages in range
> + * filemap_fdatawrite_range - start writeback on mapping dirty pages in range
>   * @mapping:	address space structure to write
>   * @start:	offset in bytes where the range starts
>   * @end:	offset in bytes where the range ends (inclusive)
> - * @sync_mode:	enable synchronous operation
>   *
>   * Start writeback against all of a mapping's dirty pages that lie
>   * within the byte offsets <start, end> inclusive.
>   *
> - * If sync_mode is WB_SYNC_ALL then this is a "data integrity" operation, as
> - * opposed to a regular memory cleansing writeback.  The difference between
> - * these two operations is that if a dirty page/buffer is encountered, it must
> - * be waited upon, and not just skipped over.
> + * This is a data integrity operation that waits upon dirty or in writeback
> + * pages.
>   *
>   * Return: %0 on success, negative error code otherwise.
>   */
> -int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
> -				loff_t end, int sync_mode)
> -{
> -	return __filemap_fdatawrite(mapping, start, end, sync_mode, NULL);
> -}
> -
>  int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
>  		loff_t end)
>  {
> -	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
> +	return __filemap_fdatawrite(mapping, start, end, WB_SYNC_ALL, NULL);
>  }
>  EXPORT_SYMBOL(filemap_fdatawrite_range);
>  
> @@ -441,7 +432,7 @@ EXPORT_SYMBOL(filemap_fdatawrite);
>  int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
>  				  loff_t end)
>  {
> -	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_NONE);
> +	return __filemap_fdatawrite(mapping, start, end, WB_SYNC_NONE, NULL);
>  }
>  EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
>  
> @@ -689,8 +680,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
>  		return 0;
>  
>  	if (mapping_needs_writeback(mapping)) {
> -		err = __filemap_fdatawrite_range(mapping, lstart, lend,
> -						 WB_SYNC_ALL);
> +		err = filemap_fdatawrite_range(mapping, lstart, lend);
>  		/*
>  		 * Even if the above returned error, the pages may be
>  		 * written partially (e.g. -ENOSPC), so we wait for it.
> @@ -792,8 +782,7 @@ int file_write_and_wait_range(struct file *file, loff_t lstart, loff_t lend)
>  		return 0;
>  
>  	if (mapping_needs_writeback(mapping)) {
> -		err = __filemap_fdatawrite_range(mapping, lstart, lend,
> -						 WB_SYNC_ALL);
> +		err = filemap_fdatawrite_range(mapping, lstart, lend);
>  		/* See comment of filemap_write_and_wait() */
>  		if (err != -EIO)
>  			__filemap_fdatawait_range(mapping, lstart, lend);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

