Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D1FCFA47B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5896B0026; Fri, 21 Nov 2025 01:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C8D6B0027; Fri, 21 Nov 2025 01:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEA46B0029; Fri, 21 Nov 2025 01:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE676B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:49:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0B404590D7
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:49:42 +0000 (UTC)
X-FDA: 84133688604.20.38D4606
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 042FBC000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:49:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LfFscgXA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763707779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Z2wSgy2zyNNpnV1+nFigOTTA+9f/wicUJMD/M0cv00=;
	b=ALBbqj0B5PtokrIrbT0gmqDa7PmeJyh4psw/A6yw5QJ9MiLyxdzddksqsrcOY78Wb+ubC3
	u8RJ94crdupR9ME3FVd0mp+FTmd1bJKwbMYzf9QOZBCtNZXjvNFwAbok7kIM3vm4f81IGW
	l7Ae9zO7SeMDZcCp32R3y2yPsONgCpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763707779; a=rsa-sha256;
	cv=none;
	b=8XfL+rEoEoMemV9RdHt3veGX9ffdaVz5WR6AfIF8OESzFQqlhdBqqXj4fvzuw0nkS9zbBW
	d/0dwWbAIre1Vc5EaSWQpVRguqHdq2vE0oHV6xpa3CJZRuncVSVc5Y+Jr2wWen+n+op6ML
	EPYKyM/QOI2QroPCCg1SsK6pynvF2rc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LfFscgXA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+8a242fb3b4bb83c2bb93+8125+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Z2wSgy2zyNNpnV1+nFigOTTA+9f/wicUJMD/M0cv00=; b=LfFscgXAyljwTAzbKdofiwBSIr
	YWYUsofssn/tG0skiwGrltv9b8ePvZePS7jNfK4RiziTFvUhkQwfCVX/Lhj34YMREUQNJtx3cnCgo
	7h6LtpoUjQ/SHzly93tP7y0XPAcX+U9M/upev6JqoLrk4y1DP9fa1XHxIggGAPOwcKCENGyKgCkoS
	l7IE7EycCTEb4p1yAlk1+4qtFZu0vsjCOPrWRmB2Rfq+uRivgN5cuIFXfFhaRUGjJTorUn1WlZCXR
	MePwiN9IDZ21Z1yUzef3f1Kaz1xYhy1CXVJqw8KHuyYeBDZBIBIgusRaoCC+kZf163AJiYgRPDfEr
	QKnUeDaw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vMKxa-00000007wJZ-1QWX;
	Fri, 21 Nov 2025 06:49:34 +0000
Date: Thu, 20 Nov 2025 22:49:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] f2fs: improve readahead for POSIX_FADV_WILLNEED
Message-ID: <aSALfvLUObUGSx-e@infradead.org>
References: <20251121014202.1969909-1-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251121014202.1969909-1-jaegeuk@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: snknhyqikydxnnojt7t3yiqxxk7qiuf9
X-Rspam-User: 
X-Rspamd-Queue-Id: 042FBC000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1763707778-131959
X-HE-Meta: U2FsdGVkX1/oT3wq/FrynOTDDZotFmz3cUDHtKIEt5F1EvYWXL6L+4qcaXwXbo0zWpt143nDH4xI0WKo07mzx3Pc84/QiTs1L7pezbEtXLgkzR7goPkB9EY7cXdHXh2kRls6LFsK5yW0IIMytcVXiQ9fawLG9x1v+mgyVR49Bj8zvpQN5zTuCVnKzaamUkRw31nHnmsWfSzqWlwynIiFSATQPgfgfoR3M5kbGQ8RRzJuFM3SabrjGmBCOij7IHywhh6ecQiUJK+B7j3tph0ux3EzsRyZUtSLzCMhn2nuFKFQ3oaq6A8MvOh0ltPTZe7Nqrbv54R3y46XH9yIH/QiVu0JCi7rJrAxlONtnYrTqS8E6fGjerOSpWDNdcBR4KT2vnKv6kQQqMVPnCazt4OgQVU/K9c/zFFS/c/C3GkL9z3DVR+3GzhjAvPG+h30TvezAZWqWfPIjySTyiGeXfQS3ESwpDeU+Ieu5zOf5V9o/xcvRH76760lCuWnUDsG1csaVdNSUHjJsnwwXK9/MHbQDQgrCTMjU3bNZLIiL+yzCeBbktKLiuX5/W+PjD4C6kZe4qYeN212S7KGxNrb7t9W+HbKvc3LBOJT1aSaJ55AawYDxABlYxXW2DlptJ7uwIa8afDp8YvnUrBLRPTKFMwiEY5xvmsrbh1HA9w4tMBaS227gMgfabxhBGCm+Xm/CSMr1Q+d2FDC/6ZIpgg5MzPmVuoET9mHFy3bRoutEhIGUBQs+3TTUrOt9Qv4aywpNWt5xwYLH9v+UI9A7c7CPNPEydlUdt0hkXGFkKYJ95UTYV3s7jNQF/KPSdo1+guuJ7eKDi8vZ+LF/i2NGmaSN8MH9Pw6OmMjU60y51isRUWemQ/RLPNUBOTh6IDGznfncCwakczd6zPUwzSla7spokVChIoP/V62Ig7YnuyJU5T+wtPWoooc4ENVoxyFHj9soKFXg2HAJ62J0qm6x93jM9W
 8CVnCoJ7
 ShgJdkQ6JFt42aWfpc7lhGbXyRYbd451SF7l0j6ifFjEUuNndv4zdqtBKh/WXmhTCwbb4xaQXYLpP7ZOguvfJRUPqEsEimahYedR4qdl1745M3UWpTSkCamPs0n0wVNX0ODu1Et+rQU5rXVQhKeDnI/D+4HqvWC/hZY+G8Yo4HT5/FbeS3C3VweznBVE1tezu8exiuSYY1/8cYpaVJGH5ID55Exl/7MO9nYFEkr+Of+NJ93oYKeb0mWVeLIBjpXzlyenJ+luJHaNj8r2437SWIpfWev1J3diSaDDQY5s5CoklYDlE52BgYydNMSaUQbfRGA/fQ/wgsjs2hD55f9GcjsPIHt0ifh2v6obWnGXtsJVlwYMgd0gjnS1LkmNhtGgUgaQ216TJhveone8tdxM9BpJfjhN0qh8mChO4Mmt0ZBBo6jsUzgD5G00a8Z+RMgoyBr7giXEJdAOzY1J8qFH/ScfU76iioz5GnWayHJZkLVsH9mVeFOG1OylA9FRDltGiaq6Aq1EvdEmS/7XfNd2VjaLVFXrZ51LONe1raR5Jt21140cem98KKA3a7nBYHwQV80+o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 01:42:01AM +0000, Jaegeuk Kim wrote:
> This patch boosts readahead for POSIX_FADV_WILLNEED.

How?  That's not a good changelog.

Also open coding the read-ahead logic is not a good idea.  The only
f2fs-specific bits are the compression check, and the extent precaching,
but you surely should be able to share a read-ahead helper with common
code instead of duplicating the logic.

> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/data.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/f2fs/f2fs.h |  1 +
>  fs/f2fs/file.c |  9 +++++---
>  3 files changed, 68 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index a0433c8a4d84..d95974d79fb3 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2710,6 +2710,67 @@ static void f2fs_readahead(struct readahead_control *rac)
>  	f2fs_mpage_readpages(inode, rac, NULL);
>  }
>  
> +int f2fs_readahead_pages(struct file *file, loff_t offset, loff_t len)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct address_space *mapping = file->f_mapping;
> +	pgoff_t start_index = offset >> PAGE_SHIFT;
> +	loff_t endbyte = offset + len;
> +	pgoff_t end_index;
> +	unsigned long nrpages;
> +	unsigned long ra_pages = (16 * 1024 * 1024) / PAGE_SIZE;
> +	DEFINE_READAHEAD(ractl, NULL, &file->f_ra, mapping, start_index);
> +
> +	if (!S_ISREG(inode->i_mode))
> +		return -EOPNOTSUPP;
> +
> +	/* Should be read only. */
> +	if (!(file->f_mode & FMODE_READ))
> +		return -EBADF;
> +
> +	/* Do not support compressed file for large folio. */
> +	if (f2fs_compressed_file(inode))
> +		return -EINVAL;
> +
> +	if (!mapping || len < 0)
> +		return -EINVAL;
> +
> +	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
> +		return -EINVAL;
> +
> +	/* Load extent cache at the first readahead. */
> +	f2fs_precache_extents(inode);
> +
> +	/*
> +	 * Careful about overflows. Len == 0 means "as much as possible".  Use
> +	 * unsigned math because signed overflows are undefined and UBSan
> +	 * complains.
> +	 */
> +	if (!len || endbyte > i_size_read(inode) || endbyte < len)
> +		endbyte = i_size_read(inode) - 1;
> +	else
> +		endbyte--;		/* inclusive */
> +
> +	/* First and last PARTIAL page! */
> +	end_index = endbyte >> PAGE_SHIFT;
> +
> +	if (start_index > end_index)
> +		return 0;
> +
> +	nrpages = end_index - start_index + 1;
> +
> +	while (nrpages) {
> +		unsigned long this_chunk = min(nrpages, ra_pages);
> +
> +		ractl.ra->ra_pages = this_chunk;
> +
> +		page_cache_sync_ra(&ractl, this_chunk << 1);
> +
> +		nrpages -= this_chunk;
> +	}
> +	return 0;
> +}
> +
>  int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
>  {
>  	struct inode *inode = fio_inode(fio);
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 3340db04a7c2..934287cc5624 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -4047,6 +4047,7 @@ int f2fs_init_bio_entry_cache(void);
>  void f2fs_destroy_bio_entry_cache(void);
>  void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, struct bio *bio,
>  			  enum page_type type);
> +int f2fs_readahead_pages(struct file *file, loff_t offset, loff_t len);
>  int f2fs_init_write_merge_io(struct f2fs_sb_info *sbi);
>  void f2fs_submit_merged_write(struct f2fs_sb_info *sbi, enum page_type type);
>  void f2fs_submit_merged_write_cond(struct f2fs_sb_info *sbi,
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index d7047ca6b98d..b6f71efd6d2a 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -5305,9 +5305,12 @@ static int f2fs_file_fadvise(struct file *filp, loff_t offset, loff_t len,
>  		filp->f_mode &= ~FMODE_RANDOM;
>  		spin_unlock(&filp->f_lock);
>  		return 0;
> -	} else if (advice == POSIX_FADV_WILLNEED && offset == 0) {
> -		/* Load extent cache at the first readahead. */
> -		f2fs_precache_extents(inode);
> +	} else if (advice == POSIX_FADV_WILLNEED) {
> +		if (offset == 0 && len == -1) {
> +			f2fs_precache_extents(inode);
> +			return 0;
> +		}
> +		return f2fs_readahead_pages(filp, offset, len);
>  	}
>  
>  	err = generic_fadvise(filp, offset, len, advice);
> -- 
> 2.52.0.487.g5c8c507ade-goog
> 
> 
---end quoted text---

