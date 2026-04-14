Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6B07ED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8BA6B008A; Tue, 14 Apr 2026 04:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0902C6B0093; Tue, 14 Apr 2026 04:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE89E6B0095; Tue, 14 Apr 2026 04:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE3A46B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:02:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72C76C1C2F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:02:15 +0000 (UTC)
X-FDA: 84656418630.22.4C63BBE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id B53AA140002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:02:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BKODt+GP;
	spf=none (imf26.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776153733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZB6wvifj9UkY04zogY2eepEJ7vJgc4ipMPW1svIE5s=;
	b=w1I9M7O95y0/udX2ZWO79QMoLagxf84szca+gY+Bg3HXH7Upc+cY1/eiky36Aqw8nWkdv9
	cVFzudvfX7p71CiCQ1SN2vwT4lLRAbhMSYv8jgkzxMKtrkSU/gJ0r9VbT2ylPYvZsgk8rq
	QNdvTFRct4b0JCWG5Z78Ja0KbeyW9pQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=BKODt+GP;
	spf=none (imf26.hostedemail.com: domain of BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c83a8b98330cc0662794+8269+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776153733; a=rsa-sha256;
	cv=none;
	b=zAKOqWU/WE0f72J7/uinqPqALrjgaOmS+WzmMoBoRvr8plGCCcr1DQtmZj9v7IY+Hmx9sH
	+OUzDNXAl75yP18daEk6DbD5oLIg9ZVwWhLpUJGDehTa7zUMwGTwkwBRfofLFIhbmewGix
	lSt6g+4yInt6PdnSR/qgRSyI1cPt1WY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jZB6wvifj9UkY04zogY2eepEJ7vJgc4ipMPW1svIE5s=; b=BKODt+GPW9p8gckvhmEzBDeovM
	wqjOZdWiQpjfsdFwasDJbeSyV1AqWAVoYN270d7OovdVHqprwb3rELyb7GvKxKNXlDqjz1hV4PBgB
	F+vRjsj82DftHnjaDVxXt0XGXbKctogIuMnooOIyN5lzMMQovFl9VpWNQKxCw1TcksVHmfW34k7sU
	Bm0B1Z3xqzZ5uDCP7h/j5A7XeApCCBPMpffhyRteG12gbaMxhZ87v73y+lxwrt1CYoO+V/H2VDZ5m
	cDxRO5goNOHIKuBlt63dySKrgwNXRwoLD6FMw77xH5FrUH3FStfna+P9q6fWUm354zueWv83Wdf+j
	3QzoY9Wg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCYip-0000000Gw6B-0Hmo;
	Tue, 14 Apr 2026 08:02:11 +0000
Date: Tue, 14 Apr 2026 01:02:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-api@vger.kernel.org
Subject: Re: [PATCH v2] f2fs: another way to set large folio by remembering
 inode number
Message-ID: <ad30g9xMs9wNJhFb@infradead.org>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adhPZxtbZxgU-37v@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: B53AA140002
X-Stat-Signature: s6rbt6x9njsetemwkjece1i7uaqasmd3
X-Rspamd-Server: rspam06
X-HE-Tag: 1776153733-4475
X-HE-Meta: U2FsdGVkX198Uh/l63qARYEUS3l+mgyJp5BfV6HX9ACQq/7iqvrGsoLjkjg9MqjTXh81SUfnq0OC44dWczgGMRGQ3jJFGljzcO40SPcsD8JUA1GFUkU28b6sx67hzeKTDvr96ZXZ6wavpCzHKhQ1FPNx+mk0khlVzvxDsmfdV7C1phmM4iSkYI/0XzkTcwTq7aDurBHhakBrTEFfFo8xxVL4L1vSGjY4QPScro6C5sDbHt6f+gkE49Dp9Y9ip+iWwlaGjuxfCPAApVxpsqY5uJPDBz2Ni0ogOcU86WLgR8R0iHpvVqIBSO0wrWLSjYY3ytpVPQcHwTdljc64INOxtEedIADGKZlvF+/dws/qeZNMxMMzAVZsEmBakkTh5eG0Polq0MjQ5+RKsPH7U7Gm4uPqMT/XmiZ/HDn6nzAH7PqXlzk9xK8hPNfl02tnYoNN0EHFYPosPkhQJN+AdmvA7/MEevQFyatr95wlc++c6TffRNfNjwH3S+TrgMd+e/uLkEng3nOu0uUylsRd2zMhVYu80/DFZa4vuDXqVlkQHT7n5Uly1tTsDbzGAm7dBMH8aa8jsebGyofKX0k0ZUN+UKswh0nTmpGKYYtXHoR7xsZgRItiyFlZ83YHf9LiH9sDOLdn6r+F99X72LzFJQGdOqq6w4VXidq/p+sg07JmZNkWkt2UH+DEpDVq5MZNh4WQI6NnX2lGo8oEYuxwiJSFPkOZMQjbfFoCsrjOqbP05gNXdkEY/VDcTc8sBU/WaCypF0+ooLv+FYUI/R50+UkJYeU83Fr0+CTh9d3MT3VVIqFNh1lY8Uq3jXwtO4OYv/yxO7Aap3kKPSLLX88UFkDlwnplNHUbxrE/PwNg4+ivXjTJswOmbJamq1hxR93C+pLq5NSpOVZ9uBhSowfN2S0nk6p+Bh3GVVlTvSBKVVgGuRRV/BOfMNDVw2lMXlVC9f7JXr3hLgz89uS+zJcmYfZ
 mwaZO+6M
 +RMh3g/dxrgIHxEQY4Uc6YV/cImUlk+PSkhrYQdTRMR4OQ9O+/ZQNesQ7BnELA2ChjCcivlNgMsfDAhLl+fuhdP47XPw26LLfwcURfqScazsav5yjbR0UzgrRM6pHuFWb0rfKrVOnoFEU+soK758yFB7opWFTqxLWf/OfJPCpP6XP8sPDU8IOQWlhLoSddz4YOjsvuNcQAOhAypAFX3RcBlR2Z7h7vgSW06syW9g2hUv3qtiCLTfObBbi/8QaQyHxxINCPVNP/mwEUn8N42owFNG2Ot66dTnozDPxMCedQr3vtmW7HzvqRflwzrPsRqZXDfl/nkeX8bKViB9omLMAHThVt/XkA8cHVF+Y/bY9GqP93JtauRXp+baDTLMqzUowun5FFpgzrNRu/p5CNUrCKBuj7cuIBe0qdDtuLoXJr/9WNmW0Rq8QL0mb8QJp4OMWFMVpJrdp68JDFwI4ZUInRwZxh4cjY4t648djkqJwrSUPVoikHc36Fc6sLupye2gr1FJC+gmBWKyGXEaZ2Gatlkrzqh/aoy7WW+uM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please add the relevant mailing lists when adding new user interfaces.

And I'm not sure hacks working around the proper large folio
implementation are something that should be merged upstream.

On Fri, Apr 10, 2026 at 01:16:23AM +0000, Jaegeuk Kim wrote:
> enum {
>        F2FS_XATTR_FADV_LARGEFOLIO,
> };
> 
> unsigned int value = BIT(F2FS_XATTR_FADV_LARGEFOLIO);
> 
> 1. setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
>  -> register the inode number for large folio
> 2. chmod(0400, file)
>  -> make Read-Only
> 3. fsync() && close() && open(READ)
>  -> f2fs_iget() with large folio
> 4. open(WRITE), mkwrite on mmap, chmod(WRITE)
>  -> return error
> 5. close() and open()
>  -> goto #3
> 6. unlink
>  -> deregister the inode number
> 
> Suggested-by: Akilesh Kailash <akailash@google.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  
>   Log from v1:
>    - add a condition in f2fs_drop_inode
>    - add Doc
> 
>  Documentation/filesystems/f2fs.rst | 41 ++++++++++++++++++++++++++----
>  fs/f2fs/checkpoint.c               |  2 +-
>  fs/f2fs/data.c                     |  2 +-
>  fs/f2fs/f2fs.h                     |  1 +
>  fs/f2fs/file.c                     | 11 ++++++--
>  fs/f2fs/inode.c                    | 19 +++++++++++---
>  fs/f2fs/super.c                    |  7 +++++
>  fs/f2fs/xattr.c                    | 35 ++++++++++++++++++++++++-
>  fs/f2fs/xattr.h                    |  6 +++++
>  9 files changed, 111 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/filesystems/f2fs.rst b/Documentation/filesystems/f2fs.rst
> index 7e4031631286..de899d0d3088 100644
> --- a/Documentation/filesystems/f2fs.rst
> +++ b/Documentation/filesystems/f2fs.rst
> @@ -1044,11 +1044,14 @@ page allocation for significant performance gains. To minimize code complexity,
>  this support is currently excluded from the write path, which requires handling
>  complex optimizations such as compression and block allocation modes.
>  
> -This optional feature is triggered only when a file's immutable bit is set.
> -Consequently, F2FS will return EOPNOTSUPP if a user attempts to open a cached
> -file with write permissions, even immediately after clearing the bit. Write
> -access is only restored once the cached inode is dropped. The usage flow is
> -demonstrated below:
> +This optional feature is triggered by two mechanisms: the file's immutable bit
> +or a specific xattr flag. In both cases, F2FS ensures data integrity by
> +restricting the file to a read-only state while large folios are active.
> +
> +1. Immutable Bit Approach:
> +Triggered when the FS_IMMUTABLE_FL is set. This is a strict enforcement
> +where the file cannot be modified at all until the bit is cleared and
> +the cached inode is dropped.
>  
>  .. code-block::
>  
> @@ -1078,3 +1081,31 @@ demonstrated below:
>     Written 4096 bytes with pattern = zero, total_time = 29 us, max_latency = 28 us
>  
>     # rm /data/testfile_read_seq
> +
> +2. XATTR fadvise Approach:
> +A more flexible registration via extended attributes.
> +
> +.. code-block::
> +
> +    enum {
> +        F2FS_XATTR_FADV_LARGEFOLIO,
> +    };
> +    unsigned int value = BIT(F2FS_XATTR_FADV_LARGEFOLIO);
> +
> +    /* Registers the inode number for large folio support in the subsystem.*/
> +    # setxattr(file, "user.fadvise", &value, sizeof(unsigned int), 0)
> +
> +    /* The file must be made Read-Only to transition into the large folio path. */
> +    # fchmod(0400, fd)
> +
> +    /* clean up dirty inode state. */
> +    # fsync(fd)
> +
> +    /* Drop the inode cache.
> +    # close(fd)
> +
> +    /* f2fs_iget() instantiates the inode with large folio support.*/
> +    # open()
> +
> +    /* Returns -EOPNOTSUPP or error to protect the large folio cache.*/
> +    # open(WRITE), mkwrite on mmap, or chmod(WRITE)
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 01e1ba77263e..fdd62ddc3ed6 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -778,7 +778,7 @@ void f2fs_remove_ino_entry(struct f2fs_sb_info *sbi, nid_t ino, int type)
>  	__remove_ino_entry(sbi, ino, type);
>  }
>  
> -/* mode should be APPEND_INO, UPDATE_INO or TRANS_DIR_INO */
> +/* mode should be APPEND_INO, UPDATE_INO, LARGE_FOLIO_IO, or TRANS_DIR_INO */
>  bool f2fs_exist_written_data(struct f2fs_sb_info *sbi, nid_t ino, int mode)
>  {
>  	struct inode_management *im = &sbi->im[mode];
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 965d4e6443c6..5e46230398d7 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2494,7 +2494,7 @@ static int f2fs_read_data_large_folio(struct inode *inode,
>  	int ret = 0;
>  	bool folio_in_bio;
>  
> -	if (!IS_IMMUTABLE(inode) || f2fs_compressed_file(inode)) {
> +	if (f2fs_compressed_file(inode)) {
>  		if (folio)
>  			folio_unlock(folio);
>  		return -EOPNOTSUPP;
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index e40b6b2784ee..02bc6eb96a59 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -381,6 +381,7 @@ enum {
>  /* for the list of ino */
>  enum {
>  	ORPHAN_INO,		/* for orphan ino list */
> +	LARGE_FOLIO_INO,	/* for large folio case */
>  	APPEND_INO,		/* for append ino list */
>  	UPDATE_INO,		/* for update ino list */
>  	TRANS_DIR_INO,		/* for transactions dir ino list */
> diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> index c0220cd7b332..64ba900410fc 100644
> --- a/fs/f2fs/file.c
> +++ b/fs/f2fs/file.c
> @@ -2068,9 +2068,16 @@ static long f2fs_fallocate(struct file *file, int mode,
>  
>  static int f2fs_release_file(struct inode *inode, struct file *filp)
>  {
> -	if (atomic_dec_and_test(&F2FS_I(inode)->open_count))
> +	if (atomic_dec_and_test(&F2FS_I(inode)->open_count)) {
>  		f2fs_remove_donate_inode(inode);
> -
> +		/*
> +		 * In order to get large folio as soon as possible, let's drop
> +		 * inode cache asap. See also f2fs_drop_inode.
> +		 */
> +		if (f2fs_exist_written_data(F2FS_I_SB(inode),
> +					    inode->i_ino, LARGE_FOLIO_INO))
> +                       d_drop(filp->f_path.dentry);
> +	}
>  	/*
>  	 * f2fs_release_file is called at every close calls. So we should
>  	 * not drop any inmemory pages by close called by other process.
> diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
> index 89240be8cc59..e100bc5a378c 100644
> --- a/fs/f2fs/inode.c
> +++ b/fs/f2fs/inode.c
> @@ -565,6 +565,20 @@ static bool is_meta_ino(struct f2fs_sb_info *sbi, unsigned int ino)
>  		ino == F2FS_COMPRESS_INO(sbi);
>  }
>  
> +static void f2fs_mapping_set_large_folio(struct inode *inode)
> +{
> +	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> +
> +	if (f2fs_compressed_file(inode))
> +		return;
> +	if (f2fs_quota_file(sbi, inode->i_ino))
> +		return;
> +	if (IS_IMMUTABLE(inode) ||
> +	    (f2fs_exist_written_data(sbi, inode->i_ino, LARGE_FOLIO_INO) &&
> +	     !(inode->i_mode & S_IWUGO)))
> +	    mapping_set_folio_min_order(inode->i_mapping, 0);
> +}
> +
>  struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(sb);
> @@ -620,9 +634,7 @@ struct inode *f2fs_iget(struct super_block *sb, unsigned long ino)
>  		inode->i_op = &f2fs_file_inode_operations;
>  		inode->i_fop = &f2fs_file_operations;
>  		inode->i_mapping->a_ops = &f2fs_dblock_aops;
> -		if (IS_IMMUTABLE(inode) && !f2fs_compressed_file(inode) &&
> -		    !f2fs_quota_file(sbi, inode->i_ino))
> -			mapping_set_folio_min_order(inode->i_mapping, 0);
> +		f2fs_mapping_set_large_folio(inode);
>  	} else if (S_ISDIR(inode->i_mode)) {
>  		inode->i_op = &f2fs_dir_inode_operations;
>  		inode->i_fop = &f2fs_dir_operations;
> @@ -895,6 +907,7 @@ void f2fs_evict_inode(struct inode *inode)
>  	f2fs_remove_ino_entry(sbi, inode->i_ino, APPEND_INO);
>  	f2fs_remove_ino_entry(sbi, inode->i_ino, UPDATE_INO);
>  	f2fs_remove_ino_entry(sbi, inode->i_ino, FLUSH_INO);
> +	f2fs_remove_ino_entry(sbi, inode->i_ino, LARGE_FOLIO_INO);
>  
>  	if (!is_sbi_flag_set(sbi, SBI_IS_FREEZING)) {
>  		sb_start_intwrite(inode->i_sb);
> diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> index ccf806b676f5..11d1e0c99ac1 100644
> --- a/fs/f2fs/super.c
> +++ b/fs/f2fs/super.c
> @@ -1844,6 +1844,13 @@ static int f2fs_drop_inode(struct inode *inode)
>  			return 1;
>  		}
>  	}
> +	/*
> +	 * In order to get large folio as soon as possible, let's drop
> +	 * inode cache asap. See also f2fs_release_file.
> +	 */
> +	if (f2fs_exist_written_data(sbi, inode->i_ino, LARGE_FOLIO_INO) &&
> +	    !is_inode_flag_set(inode, FI_DIRTY_INODE))
> +		return 1;
>  
>  	/*
>  	 * This is to avoid a deadlock condition like below.
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 941dc62a6d6f..0c0e44c2dcdd 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -44,6 +44,16 @@ static void xattr_free(struct f2fs_sb_info *sbi, void *xattr_addr,
>  		kfree(xattr_addr);
>  }
>  
> +static int f2fs_xattr_fadvise_get(struct inode *inode, void *buffer)
> +{
> +	if (!buffer)
> +		goto out;
> +	if (mapping_large_folio_support(inode->i_mapping))
> +		*((unsigned int *)buffer) |= BIT(F2FS_XATTR_FADV_LARGEFOLIO);
> +out:
> +	return sizeof(unsigned int);
> +}
> +
>  static int f2fs_xattr_generic_get(const struct xattr_handler *handler,
>  		struct dentry *unused, struct inode *inode,
>  		const char *name, void *buffer, size_t size)
> @@ -61,10 +71,29 @@ static int f2fs_xattr_generic_get(const struct xattr_handler *handler,
>  	default:
>  		return -EINVAL;
>  	}
> +	if (handler->flags == F2FS_XATTR_INDEX_USER &&
> +	    !strcmp(name, "fadvise"))
> +		return f2fs_xattr_fadvise_get(inode, buffer);
> +
>  	return f2fs_getxattr(inode, handler->flags, name,
>  			     buffer, size, NULL);
>  }
>  
> +static int f2fs_xattr_fadvise_set(struct inode *inode, const void *value)
> +{
> +	unsigned int new_fadvise;
> +
> +	new_fadvise = *(unsigned int *)value;
> +
> +	if (new_fadvise & BIT(F2FS_XATTR_FADV_LARGEFOLIO))
> +		f2fs_add_ino_entry(F2FS_I_SB(inode),
> +				inode->i_ino, LARGE_FOLIO_INO);
> +	else
> +		f2fs_remove_ino_entry(F2FS_I_SB(inode),
> +				inode->i_ino, LARGE_FOLIO_INO);
> +	return 0;
> +}
> +
>  static int f2fs_xattr_generic_set(const struct xattr_handler *handler,
>  		struct mnt_idmap *idmap,
>  		struct dentry *unused, struct inode *inode,
> @@ -84,6 +113,10 @@ static int f2fs_xattr_generic_set(const struct xattr_handler *handler,
>  	default:
>  		return -EINVAL;
>  	}
> +	if (handler->flags == F2FS_XATTR_INDEX_USER &&
> +	    !strcmp(name, "fadvise"))
> +		return f2fs_xattr_fadvise_set(inode, value);
> +
>  	return f2fs_setxattr(inode, handler->flags, name,
>  					value, size, NULL, flags);
>  }
> @@ -842,4 +875,4 @@ int __init f2fs_init_xattr_cache(void)
>  void f2fs_destroy_xattr_cache(void)
>  {
>  	kmem_cache_destroy(inline_xattr_slab);
> -}
> \ No newline at end of file
> +}
> diff --git a/fs/f2fs/xattr.h b/fs/f2fs/xattr.h
> index bce3d93e4755..455f460d014e 100644
> --- a/fs/f2fs/xattr.h
> +++ b/fs/f2fs/xattr.h
> @@ -24,6 +24,7 @@
>  #define F2FS_XATTR_REFCOUNT_MAX         1024
>  
>  /* Name indexes */
> +#define F2FS_USER_FADVISE_NAME			"user.fadvise"
>  #define F2FS_SYSTEM_ADVISE_NAME			"system.advise"
>  #define F2FS_XATTR_INDEX_USER			1
>  #define F2FS_XATTR_INDEX_POSIX_ACL_ACCESS	2
> @@ -39,6 +40,11 @@
>  #define F2FS_XATTR_NAME_ENCRYPTION_CONTEXT	"c"
>  #define F2FS_XATTR_NAME_VERITY			"v"
>  
> +/* used for F2FS_USER_FADVISE_NAME */
> +enum {
> +	F2FS_XATTR_FADV_LARGEFOLIO,
> +};
> +
>  struct f2fs_xattr_header {
>  	__le32  h_magic;        /* magic number for identification */
>  	__le32  h_refcount;     /* reference count */
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 
> 
---end quoted text---

