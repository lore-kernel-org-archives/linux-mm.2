Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D560FF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 434E96B00B6; Tue, 24 Mar 2026 01:51:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E58E6B00B9; Tue, 24 Mar 2026 01:51:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211376B00B7; Tue, 24 Mar 2026 01:51:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10B0F6B00A7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:51:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CDAE0141566
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:51:30 +0000 (UTC)
X-FDA: 84579884340.17.75BD6DA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 784FF40006;
	Tue, 24 Mar 2026 05:51:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CurszMOX;
	spf=none (imf12.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CurszMOX;
	spf=none (imf12.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331488; a=rsa-sha256;
	cv=none;
	b=oyYY7ZJXogewIKBr2ewGy3n/tluiblGtwXDH/olDNRyG7qTnO+GYRjA+/iQ3griqbeX++s
	Sjxv3ryS0cSnaFyXFGm9+RWyEudszMqPxYH7YblT5lISlHO2KQPalnEaKs1ONzRns7y/lW
	Z4Fr43uz8qcSk54wCJcuQui2eiuyuMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Qhcwd5bLWmbX4iOORTI1ctkG6Y56agSySiJ3Dl8qJw=;
	b=b/9h7taTXBT55XSf2kb4MuPJ/Xvy+H50+P4YjP0oe7JB1rjGNjtZBwgxXyYKuYVxnzHXsQ
	bG5gPKFHy31gHzIXYEmjunKqJmU+4zcVLu1ldODhJZcGZsiGJVOhY1DkIzKJETyAX6Eb+T
	XZVr3Nj2MFl6Hin/n/qj7+OnFi0nmYk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8Qhcwd5bLWmbX4iOORTI1ctkG6Y56agSySiJ3Dl8qJw=; b=CurszMOXNg4J0vooSV/GEEJb0H
	t0clDvt0GRpK6YgFOCkmeiOpbZ+KLmgsfcldobKYgygUKeIj1elktK0oh1OG9bMsaB/BuLlgQR00L
	swmC6PtZbsUUkqqbYdliD2a3B9ZULcveD5z7+rdx6Bv06HD5BiIcPiB0XcWIKx7xgLAzSaEzHEBYR
	dkk5q3CSK+k1klVE+0rrD+qGTLfTBIjX5yoxwVL/lmh6HS/98tuEJ3vQUynTYPXYtcn9VV9jmFQYN
	vmDERM7EEBL6dZXgm16Q3bsCZApUah+fdc0GheVqN+t0G8+09PkgT31FpfHQTPEzdirxctCbXpvva
	ne3uHj1w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4ufk-00000000cbP-0HAz;
	Tue, 24 Mar 2026 05:51:24 +0000
Date: Mon, 23 Mar 2026 22:51:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/41] fs: Provide functions for handling
 mapping_metadata_bhs directly
Message-ID: <acImXDl7MTsmVK_U@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-72-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-72-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 784FF40006
X-Stat-Signature: p434qbdimspquzei4f48gr5bk6a3zggw
X-Rspam-User: 
X-HE-Tag: 1774331488-616875
X-HE-Meta: U2FsdGVkX1+rElXS3Xt7/heVRrdLTCSReK6paB6Bl+SE1JiXQ8gubavrkF1KXs6MiP9S17fLb3VJhRe1ZQw5H7zMdbJInGa0TxDnlK7RgmyaO3GhzD13vRjxy+jSElTK5FrMldAViRAaWoRaGMg+GZMWsui+RsgQNFAIBGZXkbHUuJbyvzIcQQKjRxSLy7MhBtkrk+Z002vSESn2Iu3sO2KFsS2e56b8VKePsxmQdMhN3s4vFWUFDsju75PjH70DSeacfKOhYezSlQz+Kh6+4/Ho+zuWCZwFyzGdY7apLbBHVNRZMP0tOUJEA+IZUFPii7Thy8h9LJnhMMqC616Th9cNs14WtvzHlil1XRdEYYy6BniGJyrIc6Hu2j/XkRe2y17da3cV7penu5cDAWSZ2rBQXyJ/t3j/tYyGchfvhcV5tVYwWYEP7dMPDlSHoP5kp8glBm/KGWtUY32uRn22CXED4yji26fA9QTXq4/tMux9gbms+7xyvkIp9ves1gBIWZCzrEyhva4fSqoDLJ0KZrX7IKa+QkOEiA4kYCMU5mqdluGvGOeA1YsySkufngloUjsd0fLPEqVhyA/l+2POgaMt7cIzgNedw7UowLxbOG/QrkKZceQ9w4n9q5WiIQKsEwKwsxdEDrgmW0pan3C6nS2sVwppumDQ6yX5gPRxuocWmCHgt4C7BXiLT+igPL1YCkTE/ThxP5Mn+ORPoC4L/eeGgHzbhrq/tIXs68myCJD7cBfb7rydFNWPEvXqfcBQbXxyrk7pxewRESTndBNX1cQ3KZrzcKsIiJE54xQ4qXhEbdbNvpDcy8er+XEZdlEoS1viAJQzIGpamFHJ7whLLcJGNkH9xPH4CQsBFhGbl4SmtR6EbjPaLIVz9RcwtuFN5jJgWnaLhpFBUJ7A0X7SvbLtx1HvmUSiCEeWbMwbTtaLYAw/7GQlhmck6Jz2t28uwUqL8dj1USLae0oAkGo
 vx/Prjc+
 U/uz+jA81pi/EjBhtkURVHreCf5MqczmBVi7tRxwafNEIa26295y383H9ltj33ZfSd+xEY0kZTdmiV1pUum2twmXQDuD39kTYwEMy+v9QRCOG8nVZeGQ1SOM8ggETRzDVKbtuhZpBQw2hghVzEzDG505PbF0DZBMcdmprm492mScRvMFKLRGe6iSIFGxlpYDmVHuywwGBmc1/3WQxwxZuU5CE7+G/S9+2vy9IV+tR8NDWp+22pCPQ0V39VOsPokLhaOz3VVf1PwlpD/sSZPtFh5DrTBH18MwzsRfk8/yR7+S0iHHhhppJnRhb2IpA0IuupsesjcokhlZm4CIoNNFymzTtuVKeT616BKZ0OxHTscZBZ74Rkcp0NlSIUgToDtCN7PNe6aAMGyhm5Kwb/VVwvKeLS+j3w2FqfCTQge/zCQfrOZncQRaaCsKx21q0Bc3ZK8OQ3CBKkAd9HSz4JuhFb1ifWZRFPB60O3hYtTwwj55QgFOgDL5tFGxA+a1DQSPzf7oZvOTsFCEJts8+yDXDU7MUtsLzMF1ZJWF6dOtqHm6rR8U5ZjcYQVdd7C5aQMaoa4nPISG86h83V5/C2exqm5b0n9Qm94kG5jMcmLmcYGEleeghuLa/9xaNlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:41:26PM +0100, Jan Kara wrote:
> As part of transition toward moving mapping_metadata_bhs to fs-private
> part of the inode, provide functions for operations on this list
> directly instead of going through the inode / mapping.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/buffer.c                 | 93 +++++++++++++++++--------------------
>  include/linux/buffer_head.h | 45 ++++++++++++++----
>  2 files changed, 80 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index c70f8027bdd1..43aca5b7969f 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -467,31 +467,25 @@ EXPORT_SYMBOL(mark_buffer_async_write);
>   * a successful fsync().  For example, ext2 indirect blocks need to be
>   * written back and waited upon before fsync() returns.
>   *
> - * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
> - * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
> - * management of a list of dependent buffers in mapping_metadata_bhs struct.
> + * The functions mmb_mark_buffer_dirty(), mmb_sync_buffers(), mmb_has_buffers()
> + * and mmb_invalidate_buffers() are provided for the management of a list of
> + * dependent buffers in mapping_metadata_bhs struct.
>   *
>   * The locking is a little subtle: The list of buffer heads is protected by
>   * the lock in mapping_metadata_bhs so functions coming from bdev mapping
>   * (such as try_to_free_buffers()) need to safely get to mapping_metadata_bhs
>   * using RCU, grab the lock, verify we didn't race with somebody detaching the
>   * bh / moving it to different inode and only then proceeding.
> - *
> - * FIXME: mark_buffer_dirty_inode() is a data-plane operation.  It should
> - * take an address_space, not an inode.  And it should be called
> - * mark_buffer_dirty_fsync() to clearly define why those buffers are being
> - * queued up.
> - *
> - * FIXME: mark_buffer_dirty_inode() doesn't need to add the buffer to the
> - * list if it is already on a list.  Because if the buffer is on a list,
> - * it *must* already be on the right one.  If not, the filesystem is being
> - * silly.  This will save a ton of locking.  But first we have to ensure
> - * that buffers are taken *off* the old inode's list when they are freed
> - * (presumably in truncate).  That requires careful auditing of all
> - * filesystems (do it inside bforget()).  It could also be done by bringing
> - * b_inode back.
>   */
>  
> +void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping)
> +{
> +	spin_lock_init(&mmb->lock);
> +	INIT_LIST_HEAD(&mmb->list);
> +	mmb->mapping = mapping;
> +}
> +EXPORT_SYMBOL(mmb_init);
> +
>  static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
>  			         struct buffer_head *bh)
>  {
> @@ -533,12 +527,12 @@ bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
>  EXPORT_SYMBOL_GPL(mmb_has_buffers);
>  
>  /**
> - * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
> - * @mapping: the mapping which wants those buffers written
> + * mmb_sync_buffers - write out & wait upon all buffers in a list
> + * @mmb: the list of buffers to write
>   *
> - * Starts I/O against the buffers at mapping->i_metadata_bhs and waits upon
> - * that I/O. Basically, this is a convenience function for fsync().  @mapping
> - * is a file or directory which needs those buffers to be written for a
> + * Starts I/O against the buffers in the given list and waits upon
> + * that I/O. Basically, this is a convenience function for fsync().  @mmb is
> + * for a file or directory which needs those buffers to be written for a
>   * successful fsync().
>   *
>   * We have conflicting pressures: we want to make sure that all
> @@ -553,9 +547,8 @@ EXPORT_SYMBOL_GPL(mmb_has_buffers);
>   * buffer stays on our list until IO completes (at which point it can be
>   * reaped).
>   */
> -int sync_mapping_buffers(struct address_space *mapping)
> +int mmb_sync_buffers(struct mapping_metadata_bhs *mmb)

mmb and buffers in the same name feels a bit redundant.

mmc_sync_all?  mapping_sync_buffers?

> +int generic_mmb_fsync_noflush(struct file *file,
> +			      struct mapping_metadata_bhs *mmb,
> +			      loff_t start, loff_t end, bool datasync)

mmb_fsync?  mapping_buffers_fsync?

> +int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
> +		      loff_t start, loff_t end, bool datasync)
>  {
>  	struct inode *inode = file->f_mapping->host;
>  	int ret;
>  
> -	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
> +	ret = generic_mmb_fsync_noflush(file, mmb, start, end, datasync);
>  	if (!ret)
>  		ret = blkdev_issue_flush(inode->i_sb->s_bdev);
>  	return ret;
>  }
> -EXPORT_SYMBOL(generic_buffers_fsync);
> +EXPORT_SYMBOL(generic_mmb_fsync);

Same naming, but do we even need this function?  One the
mapping_metadata_bhs has to be passed in, the file system needs a
wrapper anyway, at which point open coding the flush is not really
much of a burden.


