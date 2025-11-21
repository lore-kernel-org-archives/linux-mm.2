Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16A15CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4C86B002E; Fri, 21 Nov 2025 13:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4B06B002F; Fri, 21 Nov 2025 13:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4958C6B0088; Fri, 21 Nov 2025 13:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 347976B002E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:05:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6EC9BAB44
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:05:05 +0000 (UTC)
X-FDA: 84135390570.12.C1EDF64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 45411A000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:05:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBgTcmnw;
	spf=pass (imf15.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763748304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC3icBuqtZ0GfaLUA3JxzPLWmRSzr8gw7aoWfCMFgK0=;
	b=0T/0X/KWghTGgibk4F23Vd3AewJMX0kSdYBBvjOkGf75SQhaD0H+pPXEYNsQAborfmqYIe
	U+IVRUt+Mc8R+pBbKSE4w+rgrcLZtzqGxfo20QPhg9bG534LIKZ2Sp/vwpa5dZdqKt9024
	b3SxuS2aItETWlapqj1RDJzjExwcH2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763748304; a=rsa-sha256;
	cv=none;
	b=IZJvZUj5ETMKfBAvAZSlrisZpx75tAK/eh2Does4g2YmOPBJ7cX+/+Y/vGseilqHl4hSmO
	4rSbGFBh5iwAKVkeX1ZyyQiFSsZHktUbeUOJBkUMtxzNz8JIEbU3N5drq2B7UgeZexjQJ3
	o5uqmqAs8N8hoSFVI+GJwQMqRlyacu8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aBgTcmnw;
	spf=pass (imf15.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6090601B8;
	Fri, 21 Nov 2025 18:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231CCC116C6;
	Fri, 21 Nov 2025 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763748303;
	bh=6jQ6lGWb2XGclgEVJ+zij91b54xGPUPNrXP9Fgrtip4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aBgTcmnwJrZ1+/3QcGrLPplzwWBbMG+3sWVbJLN1FsK+6Kd7TvClQcCxFCTylY8zh
	 bfV/FQTodj3YEi+N3PF57piWGirT4j0ZXDbtvQRA80cYog4nLcINqIjq4+8pVQlCEO
	 diWY6pz2yAwitgblNOcfwLJCKnM02+OEkF4tkSSiusXhvzMDGAX+K+LiEMpobifCDa
	 tAga5HiW01jocQrnJg4JeQVKaoFqpO1fukO2xgYHh/Hf+Ubi+MZ792YjRom0ISUGgL
	 XRNkFcXIL5uYrSSuBvlL4gQPCkE0wTsQO2lFHsDOD58f+G8DRIuICTeZpXjS/gcaSO
	 JOIzIy32Es22g==
Date: Fri, 21 Nov 2025 18:05:01 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] f2fs: improve readahead for POSIX_FADV_WILLNEED
Message-ID: <aSCpzRW8mUhNnjHB@google.com>
References: <20251121014202.1969909-1-jaegeuk@kernel.org>
 <aSALfvLUObUGSx-e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSALfvLUObUGSx-e@infradead.org>
X-Stat-Signature: qd4ifgrx9bmn5nbxbzbx94eptwqmih5y
X-Rspam-User: 
X-Rspamd-Queue-Id: 45411A000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763748304-430535
X-HE-Meta: U2FsdGVkX184s+g26G8RaHDyuYUHrCf0WaH9BiTJY7RLYLDmtMFpxrcr0UGBP+2G9d5B68tO293VlMeUWeaCT3uJx6YDCItU61JUOZm5i9LYMD/P/qo5Byb60MS3qat8aEemO1J4pD1ryalUil/nDdSdMRYJob3aiTb5d6yEJEE27Ou3WWgGsrKJrtswPF4YTRZhUWMvk5zWHUZGXxfodmOEAGByuYWtt/q2w+4goWzIvqOrghmOxPJtoY1POgQd6OhKzvdgdzPMYNqBigghCc0qI2cCONccIPZYiYardPHmaf51nl/T/g4gKHha+V/vfEpngHkeo7b+fikx52KM8BZZwudboRccCB1r9akPqI2BWVIpyODhcDooXeBlIGpYTcwQt5DWMTuVJO0lTIhr8h/+K6NDeq0AZfXrRWaioGNQ2l17KpqQyVZ7ELsP6wxrNJSHUApE+9+2x5yhc0dVXg0/QmxyYhxdOhBbuVaPFC8jAyd5zUGO+NcFfb/6lYVxuH/gZExOwol9Q1VVakfEughSgLY6Ued/zk0gPc2XQ/EEOf33Xgq2fSsPzI8s0MOPuYIOAhW4HzKxqNmqtoU1tdvUQes5Z31lWi0PeyhvnP+lAd1epjUhBH6CpE/4CEltULX7s7Fpa2LFi0l2OcxBq3rFZvfaTZEzPEOZAdX2elQ4wHz/Pd1ywEZbqelhFxZ+jb9htUF9OYCdup94aWjNOGH0VQxE7Gm7OUYNl38aIh09341xPPiGrfJq1Vd9WYweCX3tNkyqu+ZHNwrZbkyODt7Xihxx67GLPZ5zCPkevvBLwVZp/VtOO+xRg24IWOjR9uQszKDAlnenLP7wYtOdT7nd/ORoO2jmzgIDw46wC0gffscqCswZmSlIbNkIWmr1rvtDT9Cx6R+D23S5Wyam7Cf4QLDqnFlHX1ZYbRwreOBOn6A+GXjEJethFJA33mAQdz4tA7X1uDpBN5qktCD
 QTXmWee+
 Ar7BqISe/+7ddmx8Z96hwkNpe2gQfA2s1z+V1MdYKYMg1SbYQyPQfYogQcxHiA8rJQ4UtvWAZuhwW3J9N0aeLdWZChgW1WDGjpmgHWEzVF+AVk9+Nic6b3yV6K7vzJHVFPpSf0W7SZnPkmwfpwNWgj1XSVBnAPVGbqvTfw9EvoeJ8fzE6CMaqlqAbtWR0//FWdHHherLTkcRjey/UYta0jCsIMQY8rfUvePMtIsvZeJPZ7rgxmfVVdDRc0TXngdWHTm1pbfv5R2pSGJ6rgl2UnA/fUqTUK0X3VQ4mraPXQjW761OYtXZLt8XyaZ7x/PznpAA7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20, Christoph Hellwig wrote:
> On Fri, Nov 21, 2025 at 01:42:01AM +0000, Jaegeuk Kim wrote:
> > This patch boosts readahead for POSIX_FADV_WILLNEED.
> 
> How?  That's not a good changelog.
> 
> Also open coding the read-ahead logic is not a good idea.  The only
> f2fs-specific bits are the compression check, and the extent precaching,
> but you surely should be able to share a read-ahead helper with common
> code instead of duplicating the logic.

Ok, let me try to write up and post a generic version of the changes.

> 
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  fs/f2fs/data.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  fs/f2fs/f2fs.h |  1 +
> >  fs/f2fs/file.c |  9 +++++---
> >  3 files changed, 68 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > index a0433c8a4d84..d95974d79fb3 100644
> > --- a/fs/f2fs/data.c
> > +++ b/fs/f2fs/data.c
> > @@ -2710,6 +2710,67 @@ static void f2fs_readahead(struct readahead_control *rac)
> >  	f2fs_mpage_readpages(inode, rac, NULL);
> >  }
> >  
> > +int f2fs_readahead_pages(struct file *file, loff_t offset, loff_t len)
> > +{
> > +	struct inode *inode = file_inode(file);
> > +	struct address_space *mapping = file->f_mapping;
> > +	pgoff_t start_index = offset >> PAGE_SHIFT;
> > +	loff_t endbyte = offset + len;
> > +	pgoff_t end_index;
> > +	unsigned long nrpages;
> > +	unsigned long ra_pages = (16 * 1024 * 1024) / PAGE_SIZE;
> > +	DEFINE_READAHEAD(ractl, NULL, &file->f_ra, mapping, start_index);
> > +
> > +	if (!S_ISREG(inode->i_mode))
> > +		return -EOPNOTSUPP;
> > +
> > +	/* Should be read only. */
> > +	if (!(file->f_mode & FMODE_READ))
> > +		return -EBADF;
> > +
> > +	/* Do not support compressed file for large folio. */
> > +	if (f2fs_compressed_file(inode))
> > +		return -EINVAL;
> > +
> > +	if (!mapping || len < 0)
> > +		return -EINVAL;
> > +
> > +	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
> > +		return -EINVAL;
> > +
> > +	/* Load extent cache at the first readahead. */
> > +	f2fs_precache_extents(inode);
> > +
> > +	/*
> > +	 * Careful about overflows. Len == 0 means "as much as possible".  Use
> > +	 * unsigned math because signed overflows are undefined and UBSan
> > +	 * complains.
> > +	 */
> > +	if (!len || endbyte > i_size_read(inode) || endbyte < len)
> > +		endbyte = i_size_read(inode) - 1;
> > +	else
> > +		endbyte--;		/* inclusive */
> > +
> > +	/* First and last PARTIAL page! */
> > +	end_index = endbyte >> PAGE_SHIFT;
> > +
> > +	if (start_index > end_index)
> > +		return 0;
> > +
> > +	nrpages = end_index - start_index + 1;
> > +
> > +	while (nrpages) {
> > +		unsigned long this_chunk = min(nrpages, ra_pages);
> > +
> > +		ractl.ra->ra_pages = this_chunk;
> > +
> > +		page_cache_sync_ra(&ractl, this_chunk << 1);
> > +
> > +		nrpages -= this_chunk;
> > +	}
> > +	return 0;
> > +}
> > +
> >  int f2fs_encrypt_one_page(struct f2fs_io_info *fio)
> >  {
> >  	struct inode *inode = fio_inode(fio);
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 3340db04a7c2..934287cc5624 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -4047,6 +4047,7 @@ int f2fs_init_bio_entry_cache(void);
> >  void f2fs_destroy_bio_entry_cache(void);
> >  void f2fs_submit_read_bio(struct f2fs_sb_info *sbi, struct bio *bio,
> >  			  enum page_type type);
> > +int f2fs_readahead_pages(struct file *file, loff_t offset, loff_t len);
> >  int f2fs_init_write_merge_io(struct f2fs_sb_info *sbi);
> >  void f2fs_submit_merged_write(struct f2fs_sb_info *sbi, enum page_type type);
> >  void f2fs_submit_merged_write_cond(struct f2fs_sb_info *sbi,
> > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > index d7047ca6b98d..b6f71efd6d2a 100644
> > --- a/fs/f2fs/file.c
> > +++ b/fs/f2fs/file.c
> > @@ -5305,9 +5305,12 @@ static int f2fs_file_fadvise(struct file *filp, loff_t offset, loff_t len,
> >  		filp->f_mode &= ~FMODE_RANDOM;
> >  		spin_unlock(&filp->f_lock);
> >  		return 0;
> > -	} else if (advice == POSIX_FADV_WILLNEED && offset == 0) {
> > -		/* Load extent cache at the first readahead. */
> > -		f2fs_precache_extents(inode);
> > +	} else if (advice == POSIX_FADV_WILLNEED) {
> > +		if (offset == 0 && len == -1) {
> > +			f2fs_precache_extents(inode);
> > +			return 0;
> > +		}
> > +		return f2fs_readahead_pages(filp, offset, len);
> >  	}
> >  
> >  	err = generic_fadvise(filp, offset, len, advice);
> > -- 
> > 2.52.0.487.g5c8c507ade-goog
> > 
> > 
> ---end quoted text---

