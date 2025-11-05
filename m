Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E35DCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 10:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E538E0008; Wed,  5 Nov 2025 05:14:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7768C8E0003; Wed,  5 Nov 2025 05:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68CB58E0008; Wed,  5 Nov 2025 05:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 578A08E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 05:14:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B600A13A258
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:14:10 +0000 (UTC)
X-FDA: 84076143060.05.2A58C35
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1993B4000E
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:14:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l0cQXXR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4e0fPDMY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l0cQXXR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4e0fPDMY;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762337648; a=rsa-sha256;
	cv=none;
	b=c5lTAC9QFW+B8uHGnz+rWE78IkmfS2LtQwtRo8w8v1ezMy+8/PgmdyfGceHlCOusEkfonk
	CmsM7aH9GxeEg4yQrDyM27Uj30BfaRnan3nSld4nmGOv1O/w+RVViJrfBXSeX9X8uH0Tqa
	aNNIeAXQ2ktdUFNIL+kq4fr11xz+YLo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l0cQXXR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4e0fPDMY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l0cQXXR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4e0fPDMY;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762337648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnRVR2SMvEXU1ELRAdRpW7eZedo4gImxWnnMJ4zuclU=;
	b=RNOIqodbKsnq3IpxdjDcO4+JLyLUnNd/uPxp30EeGhetGInj4u8pv/7pP/CHIVZLsVQRf6
	hgeJzShX3yDjWIgppMrWum4U5ox4znss6KY0cCAU/40fK1tInkHg05udKDvW+K3My7iPRu
	/NVaCYIm6D46VaRD2k4mnCP/XJtt8e4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6A58221194;
	Wed,  5 Nov 2025 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762337646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MnRVR2SMvEXU1ELRAdRpW7eZedo4gImxWnnMJ4zuclU=;
	b=l0cQXXR65kwfMnOQuqf4sI31Lioyf3TVNPKTfrgIj4F6XXWGa9fkHS+kgkKS8YiAr9fqDF
	oj3FT/D2jbICKbvHgBx1QW8QqBdsQ8CGPkg36UDKNd6IqnIuzfxTo56tFt5l4W4k1LCKaf
	ObyaP+p8qJEHf2kXWCaTuW9wJsKJxXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762337646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MnRVR2SMvEXU1ELRAdRpW7eZedo4gImxWnnMJ4zuclU=;
	b=4e0fPDMYKopYKys+zw4ggx2+K8sISKVGpt9q+xE+8lppJSi8hVuDEhD7QzM9Yti4Qzw/jq
	qCleDpry2UkyKACw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762337646; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MnRVR2SMvEXU1ELRAdRpW7eZedo4gImxWnnMJ4zuclU=;
	b=l0cQXXR65kwfMnOQuqf4sI31Lioyf3TVNPKTfrgIj4F6XXWGa9fkHS+kgkKS8YiAr9fqDF
	oj3FT/D2jbICKbvHgBx1QW8QqBdsQ8CGPkg36UDKNd6IqnIuzfxTo56tFt5l4W4k1LCKaf
	ObyaP+p8qJEHf2kXWCaTuW9wJsKJxXo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762337646;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MnRVR2SMvEXU1ELRAdRpW7eZedo4gImxWnnMJ4zuclU=;
	b=4e0fPDMYKopYKys+zw4ggx2+K8sISKVGpt9q+xE+8lppJSi8hVuDEhD7QzM9Yti4Qzw/jq
	qCleDpry2UkyKACw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DC9013699;
	Wed,  5 Nov 2025 10:14:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6KXwFm4jC2mUSQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 10:14:06 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0A2C1A28C2; Wed,  5 Nov 2025 11:14:02 +0100 (CET)
Date: Wed, 5 Nov 2025 11:14:01 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 25/25] ext4: enable block size larger than page size
Message-ID: <yp4gorgjhh6c3qeopjabmknimeifhnpbz63irrrtjpplatnk4k@ycofoucc4ry3>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-26-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-26-libaokun@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1993B4000E
X-Stat-Signature: b6ep4ccbz4egx7a4bz1osshnt77x73pt
X-HE-Tag: 1762337647-99254
X-HE-Meta: U2FsdGVkX18AImHnCA4HR0dAcxR40XCkBC3Ooz2ewDdGpCai3e92tvrS/xN+J1b90nVChY36rLOXmdPSXMYLvdHvazkZky5zAALCaFL1YEJT7llRwbPQZn3iiBba0qat5+boaPuUqBCaGinj3MJtnH8R1qvdboEUNkqcKaVW8KHc8BedJ0yglgXJ3qYmm05epTNVQzUzz46PLto7pmStQv7juX/B8G+KLyTo3MHX6T0iwILDcrxb9y1vZB4FmQe0mw3V5TmQgt5JwjrelocNcPIaRYq43pTwJr9vUBBMQ68bAKvfHRVUSClxz5OrzjjSXJih2hJUkVS6gwFMhHyXWs6OEgpDL7F0Kr+u2GWiEjJ0hsHjzp0S7n11VnuqWPFQcT2KImq3wcM4tWak9hgsuRUmGdArwlV7N41aeLR06xV9V8GiFfw445/2Atg+Ez+w9vFSA7PITVrDhZbQeYDKUItiR56rA5ZZxulbDyJMZY1YMte0qysNsGDkuC168h4hPf/WwdPp4C2c1aaa2+92tTgtYZxrYsu9cKy5+USaY2KIO1fYcQ70dz1mk8tWc6BwSIZPwvoZYcSNhje1Mjg/a1lWdYjhvtoTIBMAK8jNu+RAfVV4DdhcDAbHkcXtYuRWQvrS252fynCmieKL4qLX5ERDvnfykXShGtr8VvX9ZBHzoIFM2/DFrmvTeeFf0JqXhzWp/eK3VbodQLsxRc4irHS/XRQjsA2IJTmuYypyPX59iSemodgY896smilhPMNee9a25RviDyyiTBNgbGRfTNHew1CbXZqKeC4nQFuGDZDyacqVtXmdc4k7cznSJnPHjyyi90mDY1jr2rhhM35R0OKxZH+QwrP0Mn41ptakKeuropiUZvUbeFpwZJXGKaDXG8B6Jjdgrjf53r7vrmk1B9PECEfgNVQQDJZK6sFEVji5XbC2bVoMEpoqjNqGYfb3BeLZUlD5MeFUgZkZvEo
 x1Bxl2Vf
 1jL3FNuoQDvJLyfYKIllFiBq7VSrdQnUYacSjBVpCGVmzjHi35ArPww/DJj2LEyNEDKVT6LegP3p1nBvTg6Hsq0uciKajbpsxRKTKQLdgMbolD7wGnNY8TB/97L3ILiF52bwVOzRkcmK075wzwLrTzBeGNwG3emlHEW0ax+bBv5FiVqPKeUdx2wTpai0Pv7oEOedREQfqXnZNvSVrQNd5/MSgil9RJOle2m4551/+L6E2zTaD3v61GMq8FUNguAbRjDJwQpr5b3+7ANeo0dLe2DChe+rqqaNgWWyvXlUjGbhsKiuhobKANwGxaAhzsUZp+xnvLLWEgV1qimUNdcoBBgQ9XYeyf3v9xIOfrqO4Srrpcmia9d1S2DkH7Z9t4zyYCZ/I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:21, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Since block device (See commit 3c20917120ce ("block/bdev: enable large
> folio support for large logical block sizes")) and page cache (See commit
> ab95d23bab220ef8 ("filemap: allocate mapping_min_order folios in the page
> cache")) has the ability to have a minimum order when allocating folio,
> and ext4 has supported large folio in commit 7ac67301e82f ("ext4: enable
> large folio for regular file"), now add support for block_size > PAGE_SIZE
> in ext4.
> 
> set_blocksize() -> bdev_validate_blocksize() already validates the block
> size, so ext4_load_super() does not need to perform additional checks.
> 
> Here we only need to enable large folio by default when s_min_folio_order
> is greater than 0 and add the FS_LBS bit to fs_flags.
> 
> In addition, mark this feature as experimental.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

...

> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 04f9380d4211..ba6cf05860ae 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5146,6 +5146,9 @@ static bool ext4_should_enable_large_folio(struct inode *inode)
>  	if (!ext4_test_mount_flag(sb, EXT4_MF_LARGE_FOLIO))
>  		return false;
>  
> +	if (EXT4_SB(sb)->s_min_folio_order)
> +		return true;
> +

But now files with data journalling flag enabled will get large folios
possibly significantly greater that blocksize. I don't think there's a
fundamental reason why data journalling doesn't work with large folios, the
only thing that's likely going to break is that credit estimates will go
through the roof if there are too many blocks per folio. But that can be
handled by setting max folio order to be equal to min folio order when
journalling data for the inode.

It is a bit scary to be modifying max folio order in
ext4_change_inode_journal_flag() but I guess less scary than setting new
aops and if we prune the whole page cache before touching the order and
inode flag, we should be safe (famous last words ;).

								Honza

>  	if (!S_ISREG(inode->i_mode))
>  		return false;
>  	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index fdc006a973aa..4c0bd79bdf68 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5053,6 +5053,9 @@ static int ext4_check_large_folio(struct super_block *sb)
>  		return -EINVAL;
>  	}
>  
> +	if (sb->s_blocksize > PAGE_SIZE)
> +		ext4_msg(sb, KERN_NOTICE, "EXPERIMENTAL bs(%lu) > ps(%lu) enabled.",
> +			 sb->s_blocksize, PAGE_SIZE);
>  	return 0;
>  }
>  
> @@ -7432,7 +7435,8 @@ static struct file_system_type ext4_fs_type = {
>  	.init_fs_context	= ext4_init_fs_context,
>  	.parameters		= ext4_param_specs,
>  	.kill_sb		= ext4_kill_sb,
> -	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME,
> +	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME |
> +				  FS_LBS,
>  };
>  MODULE_ALIAS_FS("ext4");
>  
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

