Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E201ECCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ACCD8E0041; Mon,  3 Nov 2025 03:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383FF8E002A; Mon,  3 Nov 2025 03:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1548E0041; Mon,  3 Nov 2025 03:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AECD8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:28:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1EBE140AB5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:27:59 +0000 (UTC)
X-FDA: 84068617878.23.478EE68
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8FF9E20003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:27:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DCUlnY/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c0ERLWzA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DCUlnY/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c0ERLWzA;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158477; a=rsa-sha256;
	cv=none;
	b=KTqC6sce9Dk8AQTCW1eNfeLAV2aEN7of5aEwveOqNOaOwcAvUY+jdCTyFfSjH/8mBQfCcH
	bBrxGJuhTDh7xTqilDQcRU3f9w/qIOAwrEYW6/wLLmv9hh0U2R2mKJedsVNbbUwikYhCKf
	1kmK85YpkWC5lAn1hFs3rFowyoXeIr0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DCUlnY/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c0ERLWzA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DCUlnY/z";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c0ERLWzA;
	spf=pass (imf03.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ee5KZvxhugRFMpeq4Qiq/n3Z6f7uctA6ZH0uyPJXPCI=;
	b=o7ryDrs75FK+irZIHwcASPy6V6gNIR3wWrwFQPs/W1NVyFBIlje6qywQHFMYRgRHmcxuZs
	D6A5YJA2kIlCeCX7Ov6PQ7Eyq1Z7fpl0Jw19Zwv4hpSzmlc7UA0omUDG3xCtBt9KFSOzkA
	jXCK1rIUqOmVy124INapd6FYyJLXsQ4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D43421DB0;
	Mon,  3 Nov 2025 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5KZvxhugRFMpeq4Qiq/n3Z6f7uctA6ZH0uyPJXPCI=;
	b=DCUlnY/z3Ky1Xm7HAejt1r3xOlJx51+9ntNJx4rLAM1au4uIxhA/I1M8OZuE94qrPu60kX
	EpDC1vkxqvmvaXNgVg/qOQ0xKL/3Va1UhHOxrIjyBcwG3dlHYVO0tINJ77JXK1M0Hq9rjV
	/Z9dKUSvi/2zuIeoYrXGy/CvkH/+zqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5KZvxhugRFMpeq4Qiq/n3Z6f7uctA6ZH0uyPJXPCI=;
	b=c0ERLWzAYo0wOk3SCD6EFNCY8xqV9JLpQwjjnzLOVniOLfYrVnJ5Uh7SEcq4IcwLxr1AMe
	wSuB8/J/wL2IgSBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158476; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5KZvxhugRFMpeq4Qiq/n3Z6f7uctA6ZH0uyPJXPCI=;
	b=DCUlnY/z3Ky1Xm7HAejt1r3xOlJx51+9ntNJx4rLAM1au4uIxhA/I1M8OZuE94qrPu60kX
	EpDC1vkxqvmvaXNgVg/qOQ0xKL/3Va1UhHOxrIjyBcwG3dlHYVO0tINJ77JXK1M0Hq9rjV
	/Z9dKUSvi/2zuIeoYrXGy/CvkH/+zqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158476;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ee5KZvxhugRFMpeq4Qiq/n3Z6f7uctA6ZH0uyPJXPCI=;
	b=c0ERLWzAYo0wOk3SCD6EFNCY8xqV9JLpQwjjnzLOVniOLfYrVnJ5Uh7SEcq4IcwLxr1AMe
	wSuB8/J/wL2IgSBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBD3A139A9;
	Mon,  3 Nov 2025 08:27:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VYWQOYtnCGkVcAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:27:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4B850A2A64; Mon,  3 Nov 2025 09:27:55 +0100 (CET)
Date: Mon, 3 Nov 2025 09:27:55 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 08/25] ext4: support large block size in ext4_readdir()
Message-ID: <kfzwluvt7sb43pl7fr4qexvflentvgm5y2s52kxg4exe6tsq7n@e4kjkexvwtvg>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-9-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-9-libaokun@huaweicloud.com>
X-Rspam-User: 
X-Stat-Signature: imbh4zgtnxmn1cir6ny7te8544smnhbm
X-Rspamd-Queue-Id: 8FF9E20003
X-Rspamd-Server: rspam09
X-HE-Tag: 1762158477-181131
X-HE-Meta: U2FsdGVkX19HOzw7GOZe1QTU0rH6cjMLoynVfPWCGWx7mEerrPWlNJVyfle4/wEOjpR/l8U806NAhPfKjM35AIabjChEa6CByHBGAo2QMLjGDDLmrPLJ27qog4S3/R3npAdL4WOzI5g+yudBsrx/PHKYnXhVRFjkT+k3XjiAK5PK53xxjlpUWAF1zLOPRzxaL3UByi7pdaiVFn+jdnQV3djMFM/dRGS6jB+FdNJ6ixth5p1HCPtbO/D+ZcswjY52WEB8uepNjxkgfBz4DAsH3wmJfm20d6FckB6uHpUmw2YIvCa2IUCG+KbTxH1AAsZ9orVfCTYXFcsfu1JZ6ENNhXeT2IMS0fE0ii10/vPDnd25ITP26gVSV6yH5uw1NJUWDcrIEglWgsi4ePDvDQmuKp+MITExu/kbsMV8cVENIgIDNSotrcYP62tE6ngWnyZE5zi3608YRbtPpQzo//npYlA8T0Zx/9livOeTftRTDiHFCK0f3tQCZkIGHE/eOTT77ChY3GpixayevGUOw/ki4qoMR5OeeJ4IRUL1R+FCYl2JfR6Q/vSB6sOKY3RAABTMdQ4xOOwdLLO/e4UmixknjECsrKTzreRA2JPfDTa6sqAWzLSS5NHsYjTUhMxcffts4jxUs2+yOunqmnr/8NhNzLW1oufYz9jpEy5jEjtdSyPY6vw8oCeBTVP7bmhQGFRfpPhpah68ioamuiEpZI+WY0GdwBL9Dl6oRPU2XaoiTTfHryaFStjYXZolMQ8OXUrcSogb7zBkSff2vOTtsM5I3Zcn6rxqSb+PfcHeP8Le8O1Hmw3H8teSjokkr/qNFgNXRi518DAkv4ZOT+BUiTqRu4OzwHz+RB+rYo5mk8ps929WNak1ZG9vADutEatTmCr2Ysh7TUFhmJo6SFwyAe13n47t+McTvBxWf8lggSVyJ8RDo5Yrx8HQbGUGxVW4tVFMG9BFXvTLzKdURS6ZSbv
 uHTRMz/V
 2VzM9mOhfBHUhkYmw5KuexdBWd1RmAb6O0iW+2e+8jbi3h2gPM7kWTDl0Dru+pqguZGXK5ameVwoUPJMuGGv5ztp5sSjTLq9wOry9RuZPkQVhU08v7htKo2t5zh6t+NSEGY20M0N/oEcQWjMI3GbeF3xqQzYpzJM71seVLsFzsKgEVVIfe6AGSPJnzFQkWBSP/3S2J60TXJx7Dcv6bjjFxO0f74W2pnOaZbW0EVFZD/g6een/62dIOQkxqEj7eqRW8c+2MwWcd9YZ7L9wWnr4oF4/kaPbXemvVbO93KUGJ99tAJDrCJ+kRgQZ/xXjnmfC7j0A1k1b0EgvItMkqJ+bZvywCMCof1bbg1O455S5WZEV0dT1LlBVRfSTmfuqb53jwyXFsmOXZQDoZkGCuPq25A2NRccaYHmadgeRahZ/9uaVD7CDlqztPwJnmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:04, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> In ext4_readdir(), page_cache_sync_readahead() is used to readahead mapped
> physical blocks. With LBS support, this can lead to a negative right shift.
> 
> To fix this, the page index is now calculated by first converting the
> physical block number (pblk) to a file position (pos) before converting
> it to a page index. Also, the correct number of pages to readahead is now
> passed.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
> index d4164c507a90..256fe2c1d4c1 100644
> --- a/fs/ext4/dir.c
> +++ b/fs/ext4/dir.c
> @@ -192,13 +192,13 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
>  			continue;
>  		}
>  		if (err > 0) {
> -			pgoff_t index = map.m_pblk >>
> -					(PAGE_SHIFT - inode->i_blkbits);
> +			pgoff_t index = map.m_pblk << inode->i_blkbits >>
> +					PAGE_SHIFT;
>  			if (!ra_has_index(&file->f_ra, index))
>  				page_cache_sync_readahead(
>  					sb->s_bdev->bd_mapping,
> -					&file->f_ra, file,
> -					index, 1);
> +					&file->f_ra, file, index,
> +					1 << EXT4_SB(sb)->s_min_folio_order);
>  			file->f_ra.prev_pos = (loff_t)index << PAGE_SHIFT;
>  			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
>  			if (IS_ERR(bh)) {
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

