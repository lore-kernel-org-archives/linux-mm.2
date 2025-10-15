Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D0BCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925928E003C; Wed, 15 Oct 2025 11:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD108E0005; Wed, 15 Oct 2025 11:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A878E003C; Wed, 15 Oct 2025 11:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 742828E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:57:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DD7FC01EA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:57:39 +0000 (UTC)
X-FDA: 84000803838.29.0C1B51D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DFC418000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:57:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsqZpuLe;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760543857; a=rsa-sha256;
	cv=none;
	b=w+xH80twJMOia2gcSySbmTIvQd2Z6dxsd2EMcNtjomuKJ82BnKvSdgFYrJU8Hn40jAej0U
	c71IFAANdpNutCipNaTIfhdzx5bxtXoycM0XDvnzpPMx7ziIWp8NCoaCqbdvJexlNcbZ8o
	w2nqgS1X2mCFzkd8vN98Zayo+lg6moQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AsqZpuLe;
	spf=pass (imf16.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760543857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6MI39VXJNyWxhohnVytMmvBfc5S1x4wjmRjei7LORk=;
	b=VU73c1wP/eSXp3bAD5cUnJd5t3dQdUd3BW77kcIH2iwVPsldkBtvv9VuprsaQbjEFh8NIN
	AFbeHNgkWu8yOrLKZpVWCkHx8cfceoT1Yn99XWQaGzT1t6er/LVU5GG1PK/BiKaePNyzrW
	IOYCTQkoZS+WjrjHaGaEVWpsZRsGUmQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A5A9D6268F;
	Wed, 15 Oct 2025 15:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C90C4CEF8;
	Wed, 15 Oct 2025 15:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760543856;
	bh=L9eEBgq9kVR228meSPkGxZ3vkQI/SsTPs5KKMheDOI0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AsqZpuLeHDlEbV+mcFlstjldZa5307khUTTe1vqzlDUxkDiz7lbPvWH8nXO1qsLAN
	 E/Z6ycm1VUYDzsjh+u5NNvkkTzywNLJGvezre9NQx+AGyeLyHCjvdQBnZHy2v4aTPv
	 iV+7jR+98mVMp7Wj06Jqdq6BN67dm3tVeLcSw8TziFFslLWRYF24ACuhmUzjqS17VN
	 X2z9j6W5GQH3uhFB2UR5lj+tT+boFK7Fi2dNBMJ282U8PyvD7ZIqZEJW5VBQqFa4HC
	 KqeqZt5rNMPjunDLjZ5h7FuEwSqu+wH5yEzIgFMYubJ64ZzUHfmOBPWWl9Oby1f6M7
	 iCC7SIIsXxnlw==
Date: Wed, 15 Oct 2025 08:57:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <20251015155735.GC6178@frogsfrogsfrogs>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-3-hch@lst.de>
X-Rspam-User: 
X-Stat-Signature: umjyt1383opa319qccti7fdr1d8hnsds
X-Rspamd-Queue-Id: 6DFC418000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1760543857-509518
X-HE-Meta: U2FsdGVkX1950D6I7BBsqsdOX8v5AzT5jSue2dv5ilkNvkm9+aB8yE8eTq01jAch9XrcwEX3shyawcUsmaZ1MVwJX6Zz1dB6U77yGUzOLtz8Ob+Mvaf7hf4+06pGIXofjEEd2Bz3HQm2WRtp88Wm0YUfBYbdHuZb9haFmEYT0onXKUgr7MgAGmOnfW4BDCw+oKaERuZFaJ6MEWBJVObJ5MdbtjBlztuLQsZt8gNUWB/2YGbjwQtBmYdDOt4z1W/xONcHNBilqssXrXEmYvkMTOgYJCOGdDrnaIkySYSOEau0eAFAvNT2ZAC9qtrGQAAA9IebfQPy4SELWFkjrAgllFLgwfqWfPPwy49mN1zzrYQBWhJwOYnZObMuqSZk3mirRy83l/O0uFxeSaz15iedq8ZRoR0wtJOCVi1mi37BDe8MGdwoCfCYL4TITpbebpb/H/ZaI8FJr+8MfCdGUd7rNQujedT7t222UBHy25Mb1z0PACgNvmt4WCXtCaXyzj0ZVdYfthIUK1g6XfVCKSargUfoq7kEZhIeXurKexWoUtjqwbtdwUCc4oV8Fq20Wh8qF/kocc+lZGBO9tE+vMiPCsE+SIm58kXv8qmpj+KHDZAGJ7Ac9cZRyTtPMQci/8MBbxu71+2EPSwl+1wnmv3hPr8q2xVuSGVA9JMYGullcSFnI+tBv/E5HvfSudnT3Hu6jPUGjNfWD7FA6gUNHyzYnMEkWiFZSVakMjcATDpMiu7qtK5LZyvzfD3m+KCUtiillvyPj6WvHvCM7bC6/AubnGDNc78u1WXSmxQjkcQumOmqWVdqw21b+hrtkGdLf6j3a05D82WdFdLOEA5S/ZEniM9IeKTc0UAaktTW6TmXX/d8ebMpl2fmnmRJsBiJAZuGx3fKGr9EkZi42cpZReHlLY2CbeFPTJRigVfwSe27oL9zBUYQ/2Ko7k5bYTa0BGrrKKf19DDobshC84dNToU
 7glG+pBN
 ue/HsgSyp5yp9PpNwKGHu4VvIbl8eK95wvviFM4f0cQqns54Gomf4xxG7X0lkVW5Plw6LyI8ljf2/dzSHWYT0B2iZSOpeqPqtmgTwh9PWR4mjVUoH2E2NCUkIlqcq0nvLD6TbqSR5H7ETxdRCfyegDZD9qJpFrs5KkPHTC9V/AvkYuE2d3RTGcM2h5v2R/5uAEA0dA55ruHqYMkqSkdcI0oEbFRCUY3P7gvZdP8p46ahwgrw0hSphII82pp0KhEiPMY/H6IFDve3p+esYkr7itEk2y7hZ4KhAHK29XT7zHmpqQF7LNvR2bktPXqfN+KvXUFonODLP5iE1aUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:27:15PM +0900, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that
> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.

I havea a few side-questy questions about this patch:

Should this be some sort of BDI field?  Maybe there are other workloads
that create a lot of dirty pages and the sysadmin would like to be able
to tell the fs to schedule larger chunks of writeback before switching
to another inode?

XFS can have two volumes, should we be using the rtdev's bdi for
realtime files and the data dev's bdi for non-rt files?  That looks like
a mess to sort out though, since there's a fair number of places where
we just dereference super_block::s_bdi.

Also I have no idea what we'd do for filesystem raid -- synthesize a bdi
for that?  And then how would you advertise that such-and-such fd maps
to a particular bdi?

(Except for the first question, I don't view the other Qs as blocking
issues; the mechanical code change looks ok to me aside from
s_min_writeback_pages should be long like Ted said)

--D

> Signed-off-by: Christoph Hellwig <hch@lst.de>
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
> index c895146c1444..23f1f10646b7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	unsigned int		s_min_writeback_pages;
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

