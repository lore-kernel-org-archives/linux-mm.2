Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EB9CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2943B8E0047; Fri, 17 Oct 2025 11:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BB78E001F; Fri, 17 Oct 2025 11:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1822C8E0047; Fri, 17 Oct 2025 11:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 026B98E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:45:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96749B708A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:45:08 +0000 (UTC)
X-FDA: 84008029896.19.8821FFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0308520004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:45:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kym3Qj/1";
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760715907; a=rsa-sha256;
	cv=none;
	b=BGGhkHNpJ0CdwLairIEfAitVBmdVOLz/mRd451pj8lJPjGiDggDiHWTdQyUBK5TDTpqUWr
	bd5leMGF8Op3lpO9gy8zk1v86LuoZmY/qVi+aBOhWsLpPczK7i1YAGiZVnR92dZP5h9C6m
	ox33Mw0UqUF9gi+9eznk4samJSwxp7A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Kym3Qj/1";
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760715907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1c1dv8QjcSijwB4PTfLy/R64Ra9NB8M/WbGg411sG0=;
	b=JSdVNjgpuWFWONi+xWTpEI6lSuK95v6Zo1kwZ0fyDC8OkOV0qLBwJqABd1GHrzWTsemzkU
	oWAY80He/0mh5A4YPbktyRs0JUbETGmbl812ATZdjDgsIOVyg8MfbfBD5jVGpb28ZCIGwy
	l2KuM5/0RR4nkOsbCQxeu3pGS7Vx1c4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7218F6465D;
	Fri, 17 Oct 2025 15:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17664C4CEE7;
	Fri, 17 Oct 2025 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760715906;
	bh=hsyaCroZlOpyDIPtwc0w/ZFBWjk/QkbVl30D1Hma/F8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kym3Qj/1oqjNnBDMDOACUt16lqnELIDADwAxk+3t/U1kOC8GbtA+5DL8fdqFb8mCV
	 3OTmnKNuU/eMWWUmPt5dJXe/TpD7eBOyMFKFxMJGqSP4+ztRVP7EPp9ptY9vYagCmY
	 qco02GBiZXkDgYVL/iMcgrlh3o+vsM6T+RcnUAi+gzkPZxidI/a3/5fDhWVcJje5YL
	 m+XEa9bLIjdI1tNIwcFarMeMtqY6b0wUnu0UuSCnY3UY4me6QKUvLFZ+xu77BJtHBw
	 4eGZTLs/5p+ErJLOaf0q+x/3hoa1TyhfGPFKbsRy0MIMLBGTXW2LcLPJzru4NmuZY8
	 Q7g532pVrbEmQ==
Date: Fri, 17 Oct 2025 08:45:05 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251017154505.GE6174@frogsfrogsfrogs>
References: <20251017034611.651385-1-hch@lst.de>
 <20251017034611.651385-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-3-hch@lst.de>
X-Rspam-User: 
X-Stat-Signature: sxkuxx36hqin88nixa9way5a94a7m35p
X-Rspamd-Queue-Id: 0308520004
X-Rspamd-Server: rspam09
X-HE-Tag: 1760715906-687036
X-HE-Meta: U2FsdGVkX18ROJJYq2yt25Xa0C63Vt1OyTZZn6Q5t1M6qqZS+A3gNku2dgEmNjavzeB14ODwMQaLwTsciHp+gfH3wczwOGQ3AGRN4fG+celmHqfHqfKFdBZ3ZEuJ/tkK5C9lklfkMhMOQm/08eMm49zRCpU63p5ijmBjqTqhEKciTK+nI5nyOjeHXKurX1IOvUwDCcFzCEjbRwLRmoIjgVJL190KWCl95tUZcwGUdDUiEEAVvpeXO6aUNgGjmMmFeLuElutcUQHLjfepquRMgu5U45BePcXrcGoZUVQIcojAU1fTLYYLnigKuzBMtztxA9OdRP8qDzGRibg0z81lxxbWe1N8Bl0HKJAnOaXZXh9jgM1M43ZNvdcw8rVm2s3W2B4cfGHeohO6/CQdnE1LreOTxrRfDEtXNuLwpjsdW2HY2KSNDpnhygX0R8/tbRHPYSRqsUPSwbILzn6pjSd4uUNiYyUqr+NdQXRtkPqqr5ZznoLRtwJaxGYxCCOZo1EPfdYF6j3wzgt22K8JxVB0gn3o6/jv8BpKaczyg32iAnovIW5QXQUE+rzJgUZ0IOcQ/Ba1e+qfLfQaZYx4N/oo3RFFTko6iTA4WdTiv3IGuRhuPaUFhxKs3EOhIiwIsW0mrGUw98uMdRzX5Vf241IKqKFYmo+Q9M46GEmXL2YjNnV97IXuy9umkoU0Dm5bo4/z2SAjDkBuZaXzSFR3kTPbdZ27F73B4bmEO4ejjdt0zRBrEUH5tUWb4O9mJbqLezOBlxm4ij/6sWBwWUoB9HC7vkrKmNN5LguyN6esW6rlzsAVKydgDd/6gaT0Q3fxdMUhYeTMhpH4f3ZQLb4ifta4zJ6wD9i+ZJ50N5YXaZ+yFZUzjASLTw7LP9GrlTluKZchAGaZr4ERGNFnqHhzGZsePdh2KAX9q9Z6feQ5uhAVi6ey3is6loBVSlfoizpPouxpbd5ByX6juPvshv7AdpK
 r9PBleri
 vtavKhUYAbSKfeYAZFniwiWoN4Umbfwimp+3Ca/hvfV8/gtnbd1vELUFl4cqdBYNjhRCTrrMZGSxQHQyhH6Vk29l2xRrrSaLNxRv+E0vcUXYqWFu1TM/Q5y0tYOuNdiF1jmVRD8ApUZWGHuTYVMAiA06T21F1buNIigOM1msxqQqc2/d8mI1mTHAu4vZtUJj+FRmYKuE/elFyrRtyQN+rsWcFvF391tGCoQVEJY1+RoE3l2o/HQmDpF13mlvQWfFLugG73O8kBA4bA8dpneVFjS4U9q03YLbQ+yOzxyLbYps6pq5gQkIVZJrxg31o0AM2RKb3HZzwddorbXN7GKmkUnpchCFMrlIVhiSJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 05:45:48AM +0200, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB means that written back
> inodes on rotational media are switched a lot.  Besides introducing
> additional seeks, this also can lead to extreme file fragmentation on
> zoned devices when a lot of files are cached relative to the available
> writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

The comment in the next patch satisfies me sufficiently, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/fs-writeback.c         | 14 +++++---------
>  fs/super.c                |  1 +
>  include/linux/fs.h        |  1 +
>  include/linux/writeback.h |  5 +++++
>  4 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 11fd08a0efb8..6d50b02cdab6 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -31,11 +31,6 @@
>  #include <linux/memcontrol.h>
>  #include "internal.h"
>  
> -/*
> - * 4MB minimal write chunk size
> - */
> -#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -1874,8 +1869,8 @@ static int writeback_single_inode(struct inode *inode,
>  	return ret;
>  }
>  
> -static long writeback_chunk_size(struct bdi_writeback *wb,
> -				 struct wb_writeback_work *work)
> +static long writeback_chunk_size(struct super_block *sb,
> +		struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	long pages;
>  
> @@ -1898,7 +1893,8 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	pages = min(wb->avg_write_bandwidth / 2,
>  		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
>  	pages = min(pages, work->nr_pages);
> -	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
> +	return round_down(pages + sb->s_min_writeback_pages,
> +			sb->s_min_writeback_pages);
>  }
>  
>  /*
> @@ -2000,7 +1996,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		inode->i_state |= I_SYNC;
>  		wbc_attach_and_unlock_inode(&wbc, inode);
>  
> -		write_chunk = writeback_chunk_size(wb, work);
> +		write_chunk = writeback_chunk_size(inode->i_sb, wb, work);
>  		wbc.nr_to_write = write_chunk;
>  		wbc.pages_skipped = 0;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 5bab94fb7e03..599c1d2641fe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -389,6 +389,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  		goto fail;
>  	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
>  		goto fail;
> +	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
>  	return s;
>  
>  fail:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..ae6f37c6eaa4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	long			s_min_writeback_pages;
>  } __randomize_layout;
>  
>  static inline struct user_namespace *i_user_ns(const struct inode *inode)
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 22dd4adc5667..49e1dd96f43e 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -374,4 +374,9 @@ bool redirty_page_for_writepage(struct writeback_control *, struct page *);
>  void sb_mark_inode_writeback(struct inode *inode);
>  void sb_clear_inode_writeback(struct inode *inode);
>  
> +/*
> + * 4MB minimal write chunk size
> + */
> +#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> +
>  #endif		/* WRITEBACK_H */
> -- 
> 2.47.3
> 
> 

