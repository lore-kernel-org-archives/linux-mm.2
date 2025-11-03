Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB98CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543698E003B; Mon,  3 Nov 2025 03:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F5008E002A; Mon,  3 Nov 2025 03:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3758E003B; Mon,  3 Nov 2025 03:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD638E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:19:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BECBE586C8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:19:06 +0000 (UTC)
X-FDA: 84068595492.08.292FF68
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 841E5A000D
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:19:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KBs+1h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Elm6Yjki;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KBs+1h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Elm6Yjki;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762157944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPAKFxV4WCdjb87dxxJgN6RLPpiYUsGfxeA/knVg7pI=;
	b=H4QpY8uPColwqBAyD3dL9MF28kiPejGvaJYKI3vaWftWk7o0xmWPmzqOAeX/WQncXYCoSy
	yZJBiopviv1rm/c4a1l6qptLzICaP5pQMgCy9T1Ayocps2XTkxKd+eDY86fe0DuJaMrssj
	TGUoUKfzL+9fXR48xY8Fv0MrysGAAtU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KBs+1h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Elm6Yjki;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KBs+1h;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Elm6Yjki;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762157944; a=rsa-sha256;
	cv=none;
	b=8lGmw53eala8mgTsyCjyEUIvvd/Hc5UB1PQypYe54yDSLRVt9nqSRFNw/DLQMjh+T4utcy
	erk1dJnx3nJ2++r1p/kg7vNnAJp6CaeSteCUg4tOlZv6zS36ROSQdN71cVdICUZwm11gTg
	mVj6/q1ZLgvpOxNLRKlDIiZld02UF6o=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1524D21B0C;
	Mon,  3 Nov 2025 08:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPAKFxV4WCdjb87dxxJgN6RLPpiYUsGfxeA/knVg7pI=;
	b=o7KBs+1hiZj6a1B13uDGEQ6i8QewLRf0/uK6k7VVlQI0ZH4oKNhwBrsVvT+ZuYOcucZ98g
	LNwl6q6wiCC34Xbsya1kuqFuXTDjp1Sis3qY6T8CG7FMGR5Wb704pCyjAuX7+vXBWKOBZ6
	4AB9hKVCARa1MNpdpEUZVfq7skerSp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPAKFxV4WCdjb87dxxJgN6RLPpiYUsGfxeA/knVg7pI=;
	b=Elm6YjkiWTjTTixkffDtRGHuU7/BR3Asa2O8aoO7DZrBhWpnjXgMHINeEtvTjzvy6ESM6S
	4fedW+Bu15xKdYBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157943; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPAKFxV4WCdjb87dxxJgN6RLPpiYUsGfxeA/knVg7pI=;
	b=o7KBs+1hiZj6a1B13uDGEQ6i8QewLRf0/uK6k7VVlQI0ZH4oKNhwBrsVvT+ZuYOcucZ98g
	LNwl6q6wiCC34Xbsya1kuqFuXTDjp1Sis3qY6T8CG7FMGR5Wb704pCyjAuX7+vXBWKOBZ6
	4AB9hKVCARa1MNpdpEUZVfq7skerSp8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157943;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPAKFxV4WCdjb87dxxJgN6RLPpiYUsGfxeA/knVg7pI=;
	b=Elm6YjkiWTjTTixkffDtRGHuU7/BR3Asa2O8aoO7DZrBhWpnjXgMHINeEtvTjzvy6ESM6S
	4fedW+Bu15xKdYBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 02CA21364F;
	Mon,  3 Nov 2025 08:19:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3UepAHdlCGnUZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:19:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4641DA2A64; Mon,  3 Nov 2025 09:19:02 +0100 (CET)
Date: Mon, 3 Nov 2025 09:19:02 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 06/25] ext4: introduce s_min_folio_order for future BS >
 PS support
Message-ID: <eywbqqzeiiz63dqsxrvetpqyj3poniywbvm4wwpcacmr6skaqb@ircbveu4srgi>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-7-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-7-libaokun@huaweicloud.com>
X-Stat-Signature: 7mc96oqyi6otbqweygt4t7p6sygiej74
X-Rspamd-Queue-Id: 841E5A000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762157944-788833
X-HE-Meta: U2FsdGVkX1/NdI10uSxCWjdwBF9FLBQti01CVE2kZOEZOwm1hpmai+r3zEHs7QVgVOWGn7s2fe3SC2ocbs532X9TyK+HHzQgjdH+u8g71pTwmoCkiQZhGJbWZ3m9kVuQOQM+GgiC1l2d+Qo+SP48eN2v59O8Xels3GXxiCR07ycCc5ToiabhmPdJ7Wu239B0vXJ6Co16ARidAd3Q3+v5cBu2bhX1IWEY9jg6nCxD5ia3kD5BJbpVng5lfigIx+Kx7MMYrEkPjFmj6F2awUtThEwmsR/Kg1Al7aURMDPWBgMeO5C5o1Na4MuqoZVjtYMW7p3GvjKA+s7j3qx4pmgtZ3A4cuf6GrS9+hHsqneCXSHzhuwZaCuOLcmYa3zia6nbutSFLLxEECMIyPqNWvhr7WQm1aJCCMCEnNH5uTvWo4553ymYlqzVWMG2ABXi5cPuoC1SdlE52LrfncJNWGtFhxoJ22PYNh/3CEf+tGE3drf/3rzJCQbja04G63+y5rc2JG6iqHD9Tvykbr+MEAysIjc6YCnONJxKNlMCX+szAi5IULelMAN7c/gXFvCh8OoGdimiFl9XPHdAwIMhWYQ/YjKC2kXFtG2ap52poYgjcNUtX6sjwq8sEmJMlQ8hZMnhVQOH9tS6lpVp8XRsU7GZPHsrSaUm39Bo/dIUto+7oFv2P7iaEzlNmurWPmd/AwsfdcHAiMH/ohTWjIPkXDMlirJhxdYmsWN049VU0zn+1xmIadW85Gaj2CPtLUyQ6hequxYYMcJFjWsyCxW6B3hXjPDYqOqupMWvENu5UTpVNmzPmAC2nAtQbpKjqY9u0Xf9/KhSqKykIGZCPEAo3nZbZeeezbleOaxO5tgXvU3z4inlC6inkaFWMV0+BOnIxrZ/G6x/+E8hQ77lzxGf6oYPWBGkBgRxxXWkUWzRMBGqnW9SSZmifyeWXEswPz/kzMz5Q734ejoMAfFzDCOUFpy
 16n37NFI
 ae5ck6qE5xoNV0/Y3949GpHWItstbJohkLPoIFkSPJ1IS7+h4Ifw6eh6M/LW/RwNUwHCid4rtzS0BysY2ve7K9/fWjCSnkEyD/KsqDhptNg4c8QgDgh1FbrSF5nXgwjm+qh+E0Lq+mRvt15yHyY3RCcgsVGa/uOLpxnhUPjtoVPMlmxYJo/+KmXnMF/kivJz8w4wulQD7W19mTOc2bREybAKeH6Xtt6BZvPC1s2ivOHQ9nE55sBJHHAug1tNC3/q/A7btzF36f+xLiR4OFpCSXt/lOBi71lPIcN1BKnZLdlWgUbX2DbL9LGvDjbVA4O19l5Rkqo/djaYP82WdwCb/BKCZAzDaqNDxvJImK7ebjHz1h7tWfRaqjWok009XX/+LpTQDSysBwWieWLY3QC+h9rE9+HlXD9Oqbik/hacKTRl/v2i3CuZyrRdYUaUFNZkw8TFGmEL5d4aCWgxNrPL8/YKw8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:02, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> This commit introduces the s_min_folio_order field to the ext4_sb_info
> structure. This field will store the minimum folio order required by the
> current filesystem, laying groundwork for future support of block sizes
> greater than PAGE_SIZE.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h  |  3 +++
>  fs/ext4/inode.c |  3 ++-
>  fs/ext4/super.c | 10 +++++-----
>  3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 93c2bf4d125a..bca6c3709673 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1677,6 +1677,9 @@ struct ext4_sb_info {
>  	/* record the last minlen when FITRIM is called. */
>  	unsigned long s_last_trim_minblks;
>  
> +	/* minimum folio order of a page cache allocation */
> +	unsigned int s_min_folio_order;
> +
>  	/* Precomputed FS UUID checksum for seeding other checksums */
>  	__u32 s_csum_seed;
>  
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index a63513a3db53..889761ed51dd 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5174,7 +5174,8 @@ void ext4_set_inode_mapping_order(struct inode *inode)
>  	if (!ext4_should_enable_large_folio(inode))
>  		return;
>  
> -	mapping_set_folio_order_range(inode->i_mapping, 0,
> +	mapping_set_folio_order_range(inode->i_mapping,
> +				      EXT4_SB(inode->i_sb)->s_min_folio_order,
>  				      EXT4_MAX_PAGECACHE_ORDER(inode));
>  }
>  
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index aa5aee4d1b63..d353e25a5b92 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5100,11 +5100,8 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
>  	 * If the default block size is not the same as the real block size,
>  	 * we need to reload it.
>  	 */
> -	if (sb->s_blocksize == blocksize) {
> -		*lsb = logical_sb_block;
> -		sbi->s_sbh = bh;
> -		return 0;
> -	}
> +	if (sb->s_blocksize == blocksize)
> +		goto success;
>  
>  	/*
>  	 * bh must be released before kill_bdev(), otherwise
> @@ -5135,6 +5132,9 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
>  		ext4_msg(sb, KERN_ERR, "Magic mismatch, very weird!");
>  		goto out;
>  	}
> +
> +success:
> +	sbi->s_min_folio_order = get_order(blocksize);
>  	*lsb = logical_sb_block;
>  	sbi->s_sbh = bh;
>  	return 0;
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

