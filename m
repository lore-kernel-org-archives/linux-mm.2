Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A473DC44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 13:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8044B6B0092; Thu,  9 Jul 2026 09:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B4C26B0093; Thu,  9 Jul 2026 09:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4906B0095; Thu,  9 Jul 2026 09:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 465EB6B0092
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 09:46:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C45321A0192
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:46:49 +0000 (UTC)
X-FDA: 84969363738.17.744401F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 408B840007
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:46:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lf0nvBCM;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783604808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2osXVDxgVvuGU+T2YOX7g61cy9uE4ngVaflraIX5Kjs=;
	b=WeDZO6zdWH4UxU++m9cwHAbP/FPbe5LvVsZ879ctmxdHXqw4e/RTqcUARiHoKfd/y9kkk4
	wIeG5hL8YKe707MoQCWZBxLuDAPJ3JHgShibUzYmGWyjTyPbpI6es8HIHR6uiGTyyGokbj
	qtomoKhY9byfCCV9O7s3/K7erFiKvMc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=lf0nvBCM;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783604808;
	b=8FJNzyIC9wwegFBkvv02FS3IsZIO18SzkwBWgFQdd7crqOHEXo9KY1ueFLRunEGaM+p5jb
	wt0JxSKw/MLDX8wYMBDGtV6cbAspmQAnLAV7F5+LwtDYI4H5x0u8FleLQNsaV+uPDb9wWm
	pKC4DW5wcuFt9SDLbtLBJhmO4D/+UbI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2osXVDxgVvuGU+T2YOX7g61cy9uE4ngVaflraIX5Kjs=; b=lf0nvBCMYSHnQRhvptl+at6CaC
	EvJMHEFfJWWszDemx7tscb7Ycv2hjjWE2JqXJ2TT2xLFWfTSPlF9Kuk4eeMdf2MIUCg5aOcxc09Fp
	BX2vcZkhK3Dn5xVXUS2ZPNeOqnE7RYl27Nzr0KSEeDabX9yGWaDyhatT/mCsrogktEST072KUoaa3
	rFMtCJa6VxFMuN+fKtw+qqbVwECq6f+OQyA+vmlyd4DVz9zgz27DnvE2FdgbEGJ01KyRZ4ksPfBsl
	9t8n7Lkhc+1OVUXakQnHWKiiDoT9Khayoi7TZAPbYtOWCDrtZa7GY2+5VopVVRi9QF/qFMba+Io1c
	P7yw5Pqg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whp5P-00000004vCI-3e6I;
	Thu, 09 Jul 2026 13:46:43 +0000
Date: Thu, 9 Jul 2026 14:46:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Longxing Li <coregee2000@gmail.com>, Theodore Ts'o <tytso@mit.edu>
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: fix use-after-free in ext4 delayed I/O completion
Message-ID: <ak-mQ2DnbaxIO_WU@casper.infradead.org>
References: <20260709075613.854-1-coregee2000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709075613.854-1-coregee2000@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 408B840007
X-Stat-Signature: 4knuxguejhw5zq9e5hhwixktex346n61
X-HE-Tag: 1783604807-469812
X-HE-Meta: U2FsdGVkX18FAIVyHcRs3kjMA6o0y0XoQtfEpGdTt4I5H/y5f+4jRTYn7fm74x1OJMd8yAeWGQ8mJ/NVEZPlVXSdpJXaquE7R3Kyneh2Io4TLR2/JvZYK9JAeEB8WOQ/2NSxoS8L3oKRDBkc8RAfyKy8O7QU77RJdPfbFWzt6j5TBGSlkubuQios129GWWnYG5buTLSjZOKimlZvpZgZFInpF1Auxdaoj8qL5R27X4/r58BLOuU6tIb111gCQTNu9GjLGoOtT/EkcyzLmrm5RmqNpamyzAbxMyNvH3qqMOZqBWE7FO8/AQhVBlOTqop2BRU8afgUtoOaBpFj1kNA5qE1oSxntm2H2i0mslgqOwaGuu3env/aCVAKOv+Wi8Pb+d1QuV85Sxebs8CRA6hITY9UFb11JgSm9JMRlcOtiXZxEGsOw7xFbfkxepExHCUpYL39eU0xwvAiApY18pC7dCrp7wHwtFDpb6ro+5V1110BivH6m9hFaw7xDrx7jYceRF9geZAC6qY6rrElee6/7N+hCsE6xQGkkUHKOYXFSpbLSh9Tj5XVj7bVtWC3f4/3whk6pVcBSKSrB7xS2Da17Uqy1scNd69CNGvA0Rr69WF0Hql127Jk3UN96XYXiG59Zg/qv9Qbxw32b7SuVVlTrhlUmltl9EQn33MkMgB9SIx+slfnDnKYn8uYluVfHt+0qmRz1sZ5U8lIJj7yeLdNDqqXYq6K3HKyCGu53P9iF19n/0g2OnsMhQwJWFlU7GazexDwiofIdO5UxX9SX1ZV6oogBm8KawFLcZ1gIq/JbMzwe2czIkod2OgXZRNru/Jy7ZPWH3wBpf1M7CaIyWhn3H4MJQPHc2ulHrJDte/bGNhwDcqu5hxP7a5Ewko/FqNIzX00mCmyhGtd3rbg01YuPsXNe8iPoWgJrPmgRCYMPFrAlIzTmSECLpu9wapgP8NcHpIPpaBlPGO1hBCGu+7
 bHxiHPlu
 +V7tQd+m4SSTqfaWZRhe+DZ/KAU6RK6a0kKYEDgO1Vc6abJ8rny1FhFZ7tEx/xSAMOutsJyC+C1XFZVBE9zKsYFob3sfO2nFohB1iROR0s4onDnKbVW887CiQ980fI56s6Mez2HSK5XQUbWuLW9BiFVVyGe2pIKY5MDULHLmwP5hd4F/RavoTCxc4rg67rt4maPDhtVNLoUCiihb2QNU0zUEMpvjwKZsy3e/bYV8Ma9vJqTVv1lxn0LWF4oCpC12uqC3NsyudbG3M9GF2kFUhUruj9kopMbnNr8U5BZnlXiknT2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 09, 2026 at 03:56:13PM +0800, Longxing Li wrote:
> ext4_add_complete_io() queues the inode's i_rsv_conversion_work without
> holding an extra reference to the inode. If the inode is unlinked and
> evicted before the delayed work runs, the inode slab object gets freed.
> When ext4_do_flush_completed_IO() later accesses io_end->inode, it is
> accessing a freed/reallocated object -- a use-after-free detected by KASAN.
> 
> Take igrab(inode) when first queueing the work (only when list is empty to
> avoid duplicate references), and drop the reference in
> ext4_do_flush_completed_IO() after processing all io_ends.
> A per-inode bit (i_rsv_need_iput) tracks whether the extra reference
> was taken.
> 
> This is a defense-in-depth fix complementary to the upstream fix
> c678bdc99875 ("ext4: fix inode use after free in ext4_end_io_rsv_work()")
> which adds consistency checks in ext4_io_end_defer_completion(). Both fixes
> address the same root race but from different angles.

Um.  You've cc'd everybody except the maintainer.  And this is already
fixed, but you want to fix it even more?  I don't get it.

(also if this patch isn't AI slop, it's doing a Really Good Job of
pretending to be AI slop.  Why would you choose 'unsigned short' as
the type?)

> Fixes: ce51afb8cc5e ("ext4: abort journal on data writeback failure if in data_err=abort mode")
> Reported-by: Longxing Li <coregee2000@gmail.com>
> Signed-off-by: Longxing Li <coregee2000@gmail.com>
> ---
>  fs/ext4/ext4.h    |  2 ++
>  fs/ext4/page-io.c | 15 +++++++++++++--
>  fs/ext4/super.c   |  1 +
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 56112f201cac..239e6c0a3d3c 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1179,6 +1179,8 @@ struct ext4_inode_info {
>  
>  	/* Lock protecting lists below */
>  	spinlock_t i_completed_io_lock;
> +	/* Track if ext4_add_complete_io() took an extra inode reference. */
> +	unsigned short i_rsv_need_iput:1;
>  	/*
>  	 * Completed IOs that need unwritten extents handling and have
>  	 * transaction reserved
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index 39abfeec5f36..294c0bcbbb7f 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -262,8 +262,12 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
>  
>  	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
>  	wq = sbi->rsv_conversion_wq;
> -	if (list_empty(&ei->i_rsv_conversion_list))
> -		queue_work(wq, &ei->i_rsv_conversion_work);
> +	if (list_empty(&ei->i_rsv_conversion_list)) {
> +		if (igrab(io_end->inode)) {
> +			ei->i_rsv_need_iput = 1;
> +			queue_work(wq, &ei->i_rsv_conversion_work);
> +		}
> +	}
>  	list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
>  	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
>  }
> @@ -291,6 +295,13 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
>  		if (unlikely(!ret && err))
>  			ret = err;
>  	}
> +
> +	/* Release inode reference from ext4_add_complete_io. */
> +	if (ei->i_rsv_need_iput) {
> +		ei->i_rsv_need_iput = 0;
> +		iput(&ei->vfs_inode);
> +	}
> +
>  	return ret;
>  }
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 87205660c5d0..10a5d863d9b9 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1418,6 +1418,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
>  	ei->jinode = NULL;
>  	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
>  	spin_lock_init(&ei->i_completed_io_lock);
> +	ei->i_rsv_need_iput = 0;
>  	ei->i_sync_tid = 0;
>  	ei->i_datasync_tid = 0;
>  	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
> -- 
> 2.34.1
> 

