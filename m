Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695CFFCE07B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB34A6B0095; Thu, 26 Feb 2026 08:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5D4F6B0096; Thu, 26 Feb 2026 08:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FBC6B0098; Thu, 26 Feb 2026 08:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A35256B0095
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:22:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74EE816014C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:22:01 +0000 (UTC)
X-FDA: 84486670842.02.CA05815
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22A13180003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:21:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PBiBvZ97;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yKJKpq1w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PBiBvZ97;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yKJKpq1w;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772112119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fDaSkVhy0E33BiFULWhZdEJNcGyrApfeqESCYAmwD8=;
	b=UeXL6TZPzA+niJXGypu8G9xXR/Km5ew2Si+gFrf2whfIUC3U1a1UuxQS8W7AhcZ6I3Eaq3
	kBUE61ldDwXbofxfRsMH+kPwYQd8K/taObBhIQ8YiOXSQ8Jx4h8u1bc5IzMSkXLiGMpCsE
	uFMKvfqs8VxOn+XW77TA25NldsrONoI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PBiBvZ97;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yKJKpq1w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PBiBvZ97;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yKJKpq1w;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772112119; a=rsa-sha256;
	cv=none;
	b=DER3F2Jb46Wd1PSDuL0wxDXUxlAUeDpc17NCjH6VcQaa13/kuCUU8GfXTuVJykMO1+29yv
	N5hIovY9Oo5wrHh3VkHPWXi3tbSu8ZME22G+HNO65obLGQBVGWfRJ4vEaUh1ktcmBJOBZN
	O72WS868TOne1g0J1sZv2cJtLY2EnlE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 903213FD91;
	Thu, 26 Feb 2026 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772112117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fDaSkVhy0E33BiFULWhZdEJNcGyrApfeqESCYAmwD8=;
	b=PBiBvZ97kx3nE8Sx3Iqr2jG5qsX80nZ2QZEXA7XtGku+vlcy2CmVQufsvmFLIxPxb6R1o+
	VNcFM/i1N7uvIMZ63qlWZj58vjqkIC6cLtuo7yRQmA94JTf46RvXW3UqZaRhz2rU5qYpm5
	5uC0hdfRgvc4icWc/ipstowyGMbsuZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772112117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fDaSkVhy0E33BiFULWhZdEJNcGyrApfeqESCYAmwD8=;
	b=yKJKpq1wn5G35h25U8MPNWJFk0Rth71l9BQh2uX7wTyWNc7We7QYgoCHRktLaHztRqM8kO
	HbJyGRl/FuICxXDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772112117; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fDaSkVhy0E33BiFULWhZdEJNcGyrApfeqESCYAmwD8=;
	b=PBiBvZ97kx3nE8Sx3Iqr2jG5qsX80nZ2QZEXA7XtGku+vlcy2CmVQufsvmFLIxPxb6R1o+
	VNcFM/i1N7uvIMZ63qlWZj58vjqkIC6cLtuo7yRQmA94JTf46RvXW3UqZaRhz2rU5qYpm5
	5uC0hdfRgvc4icWc/ipstowyGMbsuZY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772112117;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fDaSkVhy0E33BiFULWhZdEJNcGyrApfeqESCYAmwD8=;
	b=yKJKpq1wn5G35h25U8MPNWJFk0Rth71l9BQh2uX7wTyWNc7We7QYgoCHRktLaHztRqM8kO
	HbJyGRl/FuICxXDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F8F23EA62;
	Thu, 26 Feb 2026 13:21:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yNo1G/VIoGn1UQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Feb 2026 13:21:57 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 234ABA0A27; Thu, 26 Feb 2026 14:21:57 +0100 (CET)
Date: Thu, 26 Feb 2026 14:21:57 +0100
From: Jan Kara <jack@suse.cz>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1] mm: annotate data race of f_ra.prev_pos
Message-ID: <2xzc3lp6ehtjwbzip4i5muh4g6oep4l72zh3j6sablfghbvbau@kh7famgorzrh>
References: <20260226084020.163720-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226084020.163720-1-jiayuan.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 22A13180003
X-Rspamd-Server: rspam02
X-Stat-Signature: 6m4rwogzaot75m4ec8je1m8ebjwi11ts
X-HE-Tag: 1772112118-797115
X-HE-Meta: U2FsdGVkX1+E/uLiRPQYTnsYDmbAzcrxtduOpF/yThG4K+JdGr+yYXnrAyOBM5Wxc5uHCa3grY78W3Y/mbnzaSty+RysYwTTVfknMq7B7gReCSN8+c+wGiiSQcol/EbHmgX/ip/Ry9CJzCWd2Jg63yZ6PJDPDjYOB2UWO8rr+J03vIj+3UKPjC3i3Echjo2zaSr24x9pi5Eq1iHKu9xyDx7EVej8apaWv0YNpHfapnR5fT50tcN3ngekekG4ephzN/HnM5YSBKAynDnZtGOA+hs3n8o6BHQa/3PJPiOZwBWKwyuas2KkiobzBS/sQA5Hvj/nzOfUASN2mDwIehdtX/hFIGhb/Ic7lu6PF6U9fMx6fCHmuUiOO6qpltj7SpWNpqc1uapOzM+SOlZ4jMkv9+GYKuGw1sYJw+7RzaIqe4rrPyR0dCwu/mLTINfgBMBCjiEqxVcc4WRB8wXjhP65VnE91XhSjbXZjJmt2bnluULXebfdUGQDxVTbrrxkDC8QSY1mbKEJEVsgHS8vvxgKCf9CkXMHDulRC2SvEecX9dwatp/pqsxqkwzR4jBfQqJ2k+iR1/vJ23h+HHRCULlT4fcAgi3ullDdXDZixwlwlykWGNc5bENOWOZu5MWjycUBK1oyYzkOM/CiFo/6J+lk2jcGcigJ40JpjQ0Vhbb59kI0mEtHMRqrXAh07QQ5CpamTXdlSkweidRsv37shIdZXYmFY7gN1CXpbvnjFeT0khVSWGniSpBH3tAYa1GOq22DHIWLf/Iw2US0C+Ip/8DMX9OIwtcSzxDfsA3VmgBGp/Ifm1TJial6iq/2W5Qz7IZ2qpwX/YiTGfriD0yc1vmTZDs1AEmBZ5dbjUZYl1VreJCUmnkKtyI8fz1E6pMFIFVsSwBfTcPX4r9EU5sq+XJlJX7fVa6P1Qv378wXUpnoBdx/PMVW9lUYZEhIORd0PbG8GSUNpRdHStwBX8swvAt
 tEoLFw3k
 f/ZoZbrfV3kV9Yu1rKXsP3Jr3w6PNwPx+dwVl/DFKHOPXzAjJmZ9pcV++My1OAVyoOaYBrLdsyuMkUTetQ8RXSsn3Obu+lm8DVFULE7rPoe7q85+YrnzrEaPEeYSrugohOfCbNQAXSG7g9WQE2l77Ae+iJ2nxMafDqNH7PAiRlgPbhsqBdl2oEPNoVWEvI7UMCvyxzW+l7U0CzbPL6bB824GxVi3PGazbq43fK/PCJ/qlqxULUuLUO27fr25DmGuk+2wgLgj/4yDDBJPaAbYi1HUVUgLMBW6sbETr1LDCgOQF6dP7Adt23MmDq5PxEzPoAssFI9DqC4QGCgme6uaWR6iqtiAw/BYATssXqlCG0OVuNlsiU7BxLraB1pw+kwV5p3rBTnfUkoPLwS1uxzldQOuLniSYh7k7E9E0rUblwhIHy/gvpgHtfdwoVXwU/Z46hog4Wv3wvOXJwem4Ujyv08QmaOZruvW2upLB1XpMsrI2anoUJoG93VsCwPhj3cED9VMILNIqw6TWg8Ezhvp7WezK/bZDu9H+tMwle2xrXQKC454MeiKYSbVfOGP1sD0ZQ6RPOh+66PJM9pzftQqw4sDDVs0JAIluLWAfjE4sXPXdZxcPazPMGpJytvSKFy3uVJ3HE2RkavKnLl0zWXL7On58TE2+xSovaE3u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 26-02-26 16:40:07, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> KCSAN reports a data race when concurrent readers access the same
> struct file:
> 
>   BUG: KCSAN: data-race in filemap_read / filemap_splice_read
> 
>   write to 0xffff88811a6f8228 of 8 bytes by task 10061 on cpu 0:
>    filemap_splice_read+0x523/0x780 mm/filemap.c:3125
>    ...
> 
>   write to 0xffff88811a6f8228 of 8 bytes by task 10066 on cpu 1:
>    filemap_read+0x98d/0xa10 mm/filemap.c:2873
>    ...
> 
> Both filemap_read() and filemap_splice_read() update f_ra.prev_pos
> without synchronization. This is a benign race since prev_pos is only
> used as a hint for readahead heuristics in page_cache_sync_ra(), and a
> stale or torn value merely results in a suboptimal readahead decision,
> not a correctness issue.
> 
> Use WRITE_ONCE/READ_ONCE to annotate all accesses to prev_pos across
> the tree for consistency and silence KCSAN.
> 
> Reported-by: syzbot+6880f676b265dbd42d63@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=6880f676b265dbd42d63
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Given this, I think it would be much less intrusive and also more
explanatory to just mark prev_pos with __data_racy with appropriate reason
you're mentioning in the changelog.

								Honza

> ---
>  fs/ext4/dir.c                    | 2 +-
>  fs/ntfs3/fsntfs.c                | 2 +-
>  include/trace/events/readahead.h | 2 +-
>  mm/filemap.c                     | 6 +++---
>  mm/readahead.c                   | 4 ++--
>  mm/shmem.c                       | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index 28b2a3deb954..1ddf7acce5ca 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -200,7 +200,7 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  					sb->s_bdev->bd_mapping,
>  					&file->f_ra, file, index,
>  					1 << EXT4_SB(sb)->s_min_folio_order);
> -			file->f_ra.prev_pos = (loff_t)index << PAGE_SHIFT;
> +			WRITE_ONCE(file->f_ra.prev_pos, (loff_t)index << PAGE_SHIFT);
>  			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
>  			if (IS_ERR(bh)) {
>  				err = PTR_ERR(bh);
> diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
> index 0df2aa81d884..d1232fc03c08 100644
> --- a/fs/ntfs3/fsntfs.c
> +++ b/fs/ntfs3/fsntfs.c
> @@ -1239,7 +1239,7 @@ int ntfs_read_run_nb_ra(struct ntfs_sb_info *sbi, const struct runs_tree *run,
>  			if (!ra_has_index(ra, index)) {
>  				page_cache_sync_readahead(mapping, ra, NULL,
>  							  index, 1);
> -				ra->prev_pos = (loff_t)index << PAGE_SHIFT;
> +				WRITE_ONCE(ra->prev_pos, (loff_t)index << PAGE_SHIFT);
>  			}
>  		}
>  
> diff --git a/include/trace/events/readahead.h b/include/trace/events/readahead.h
> index 0997ac5eceab..63d8df6c2983 100644
> --- a/include/trace/events/readahead.h
> +++ b/include/trace/events/readahead.h
> @@ -101,7 +101,7 @@ DECLARE_EVENT_CLASS(page_cache_ra_op,
>  		__entry->async_size = ra->async_size;
>  		__entry->ra_pages = ra->ra_pages;
>  		__entry->mmap_miss = ra->mmap_miss;
> -		__entry->prev_pos = ra->prev_pos;
> +		__entry->prev_pos = READ_ONCE(ra->prev_pos);
>  		__entry->req_count = req_count;
>  	),
>  
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 63f256307fdd..d3e2d4b826b9 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2771,7 +2771,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  	int i, error = 0;
>  	bool writably_mapped;
>  	loff_t isize, end_offset;
> -	loff_t last_pos = ra->prev_pos;
> +	loff_t last_pos = READ_ONCE(ra->prev_pos);
>  
>  	if (unlikely(iocb->ki_pos < 0))
>  		return -EINVAL;
> @@ -2870,7 +2870,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
>  
>  	file_accessed(filp);
> -	ra->prev_pos = last_pos;
> +	WRITE_ONCE(ra->prev_pos, last_pos);
>  	return already_read ? already_read : error;
>  }
>  EXPORT_SYMBOL_GPL(filemap_read);
> @@ -3122,7 +3122,7 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
>  			len -= n;
>  			total_spliced += n;
>  			*ppos += n;
> -			in->f_ra.prev_pos = *ppos;
> +			WRITE_ONCE(in->f_ra.prev_pos, *ppos);
>  			if (pipe_is_full(pipe))
>  				goto out;
>  		}
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 7b05082c89ea..de49b35b0329 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -142,7 +142,7 @@ void
>  file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
>  {
>  	ra->ra_pages = inode_to_bdi(mapping->host)->ra_pages;
> -	ra->prev_pos = -1;
> +	WRITE_ONCE(ra->prev_pos, -1);
>  }
>  EXPORT_SYMBOL_GPL(file_ra_state_init);
>  
> @@ -584,7 +584,7 @@ void page_cache_sync_ra(struct readahead_control *ractl,
>  	}
>  
>  	max_pages = ractl_max_pages(ractl, req_count);
> -	prev_index = (unsigned long long)ra->prev_pos >> PAGE_SHIFT;
> +	prev_index = (unsigned long long)READ_ONCE(ra->prev_pos) >> PAGE_SHIFT;
>  	/*
>  	 * A start of file, oversized read, or sequential cache miss:
>  	 * trivial case: (index - prev_index) == 1
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5e7dcf5bc5d3..03569199baf4 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3642,7 +3642,7 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
>  		len -= n;
>  		total_spliced += n;
>  		*ppos += n;
> -		in->f_ra.prev_pos = *ppos;
> +		WRITE_ONCE(in->f_ra.prev_pos, *ppos);
>  		if (pipe_is_full(pipe))
>  			break;
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

