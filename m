Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44D96CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10728E0017; Wed,  5 Nov 2025 04:21:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7378E000B; Wed,  5 Nov 2025 04:21:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD478E0017; Wed,  5 Nov 2025 04:21:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 803C48E000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:21:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C8C4139E54
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:21:56 +0000 (UTC)
X-FDA: 84076011432.07.9B9E58B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 001E640005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:21:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xeiR4NoS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqvwPEKU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xeiR4NoS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqvwPEKU;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiimWwxWLRmp6RdY8hBpnmT5w5iOYiscsbCX56fNBAM=;
	b=Nk8+4uKySxeehqzvhoL7STIJE7Fj95O0VKAduu4cc+1/O8oLmqu59P6UMqLyNIbOGYrB0g
	+1upnKPtUrt9TrYwL4iN1+f/tEUIQT4MD5OrsHLgxc+nTKFWkRR2GZkAdPNyEJuj79UhJj
	HQny8w2cPWWwGT41T7OCTEVyCXt5egI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334514; a=rsa-sha256;
	cv=none;
	b=T4fKfcVpThTwucuvzQW0gp105KGvYTIqR3te+F5dsJJf4os+ERSU4oSpLuiN8ghDUBeg7E
	BaRmw04PhFPZoXgBjKprM8EDffn/ic+b/2bIG68WLNPMlFrnYmUhUKtlg/m0GOaYsgmcVf
	XDPBBllp2TdbXMN3ftowyOtdbC8Kphs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xeiR4NoS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqvwPEKU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xeiR4NoS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=uqvwPEKU;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 86F8221181;
	Wed,  5 Nov 2025 09:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiimWwxWLRmp6RdY8hBpnmT5w5iOYiscsbCX56fNBAM=;
	b=xeiR4NoS39SfhExjX/IbEG6Ah8riUDdj05SyDWi1Sjm9P9AsioakTVj/b4F3y8W45kAu4W
	5JQ1mVje6U2i+f9ewV8olKWoCRUJJRS+kYHzMD8Px1I5k0884E86/sIlxi5crdmbfWcx4n
	vN0RXs9+aW3yziq5bmUFWj0HmIUlTXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiimWwxWLRmp6RdY8hBpnmT5w5iOYiscsbCX56fNBAM=;
	b=uqvwPEKUZeWCS1Oon506yU+IqoyTApTuNFNmwCAHWz+xxfm0SCKL6bFFw+gnQSOCgnLMrT
	8zuVFDiV0O47eWCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiimWwxWLRmp6RdY8hBpnmT5w5iOYiscsbCX56fNBAM=;
	b=xeiR4NoS39SfhExjX/IbEG6Ah8riUDdj05SyDWi1Sjm9P9AsioakTVj/b4F3y8W45kAu4W
	5JQ1mVje6U2i+f9ewV8olKWoCRUJJRS+kYHzMD8Px1I5k0884E86/sIlxi5crdmbfWcx4n
	vN0RXs9+aW3yziq5bmUFWj0HmIUlTXg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334512;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PiimWwxWLRmp6RdY8hBpnmT5w5iOYiscsbCX56fNBAM=;
	b=uqvwPEKUZeWCS1Oon506yU+IqoyTApTuNFNmwCAHWz+xxfm0SCKL6bFFw+gnQSOCgnLMrT
	8zuVFDiV0O47eWCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7CEA3132DD;
	Wed,  5 Nov 2025 09:21:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x4h8HjAXC2lVFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:21:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 382E2A083B; Wed,  5 Nov 2025 10:21:52 +0100 (CET)
Date: Wed, 5 Nov 2025 10:21:52 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 15/25] ext4: rename 'page' references to 'folio' in
 multi-block allocator
Message-ID: <zi2xv42wg45qbveq4vxtdodencx7zb2esscwensoaka2hiojdr@imra4faaz42g>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-16-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-16-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 001E640005
X-Stat-Signature: zt3ec7qbwt7eqew7yobntiiot9mxk7u3
X-Rspam-User: 
X-HE-Tag: 1762334513-787179
X-HE-Meta: U2FsdGVkX1/5NpfY1hKWOmd23hssjSybgDOmujO2Hi4SHhiniCeZfXfAs6rnMph/8Qg1EgaOcyPxna1HCikUKOlXsgM8sjh60FU22J2kykEh+zZ58Hv/aKdFeJ7QHC8OTphrhaOlMi87rlLBKCUhb3uMATtrHM4wVLm02f16NERbT1NoAq4wX7qs+32u1fKuu5p0Ag4yMC6ec7GaI8E9uS++6ehey/0v7Wa7vAyt2fzvfH0XeeYs1TZ/clGHWj2iOTKUbbakqFqf/YSGlnSU6RMcGtKr6W0uvul2CieuheUSrFB6S1HK2s29uIoaPcYkMvLu5lkPGg6hpen8jR832/K9WUsngwvKW+l3CnJfWsSnMPBPdj5gvPqeEXbOTDcn+kQDp2pkkYMTFGaEYOmeOMWh55km+oyVz3+lLlqRFswh74D9symoIJEQOtA6maPV3TO6tWdE5pIfrJdgPKiSwRoljxgqCoGjqTDoXt9JywKoarh4qP0zfiNjoi5X6dYkOb9AQ2IrjnJP0sPUKwqj4yj6OjuXy2m2BfCVZCNXoAeNAYNyvMjW628vet9zZlftx2pQL2nc6dtKeUpjezcTFwcYNlzOHluHUv3R9tUU+CyzaTZxjCEg2KhQAt/BcBiTfOWvacoqWTJFri3YDHJqNXJyc3bPkjgobz5vYgl363nxipP8DXeUHeP7gBzZswMUeL4wmFuqxhiXxhGA7hKpGQtJ9SNOlLwV2xBV6VGiT5xf6NkqCBUK+WJw3CRSgCuaGDx2O4MtUzG5vSVxdmwm5mifAO8p+MYppdHHJ1IVzxvmyI+vvB/3z7hKZhsp9xtghT0DJxrq6XyXo2NfUMB5dwIQrsnFEOPrtrvsNuvCIpkNyr9MKhQ4+lI8YE6KEb6+cb2rje+5Ex7woWedgBRuAWFeacq9FbGXfL0ppt7SQCRHEnVljFTp07OeKGn4AqFWO8mjS24UUJ1KejVPNX6
 TzGulXvh
 q4LE3e0B9kT1xPUEFk1Fq6ll2gtk+ROQchX91D63MuAdXuVF47dHHaq3Hv14O2Efd6fmb5GssjENu6p3QBwOftT3hcxPtxj4KZV3bznguQvA3ZaeIMweiijIxaGjYtsu4q1wgB/1v21HqtOVTnNHbrc+VT2y22VCBW5NLLrsjZnG9CzdqCV8Ky6TbhAOlv1sGxNuNyY3IFiaLDg0wYzwOzZ3yB7tD2Nda/stVRpzs6YNmwUKY1ghPa+i/JbN6kRrpHgTBLc51XX7/6PZIBpt1GdcVjf+UDfz3DOM0CLbvkcOBbm8JUSWA8+cmMyV6w9PwWImWa2ADfXe/1J9EG+3Cf30xSUFCkL4GvXHJiE4+XVEH0kpnfWYpmZmzxoq8uQ43x0v0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:11, libaokun@huaweicloud.com wrote:
> From: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> The ext4 multi-block allocator now fully supports folio objects. Update
> all variable names, function names, and comments to replace legacy 'page'
> terminology with 'folio', improving clarity and consistency.
> 
> No functional changes.
> 
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/mballoc.c | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 155c43ff2bc2..cf07d1067f5f 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -98,14 +98,14 @@
>   * block bitmap and buddy information. The information are stored in the
>   * inode as:
>   *
> - *  {                        page                        }
> + *  {                        folio                        }
>   *  [ group 0 bitmap][ group 0 buddy] [group 1][ group 1]...
>   *
>   *
>   * one block each for bitmap and buddy information.  So for each group we
> - * take up 2 blocks. A page can contain blocks_per_page (PAGE_SIZE /
> - * blocksize) blocks.  So it can have information regarding groups_per_page
> - * which is blocks_per_page/2
> + * take up 2 blocks. A folio can contain blocks_per_folio (folio_size /
> + * blocksize) blocks.  So it can have information regarding groups_per_folio
> + * which is blocks_per_folio/2
>   *
>   * The buddy cache inode is not stored on disk. The inode is thrown
>   * away when the filesystem is unmounted.
> @@ -1556,7 +1556,7 @@ static int ext4_mb_get_buddy_folio_lock(struct super_block *sb,
>  	return 0;
>  }
>  
> -static void ext4_mb_put_buddy_page_lock(struct ext4_buddy *e4b)
> +static void ext4_mb_put_buddy_folio_lock(struct ext4_buddy *e4b)
>  {
>  	if (e4b->bd_bitmap_folio) {
>  		folio_unlock(e4b->bd_bitmap_folio);
> @@ -1570,7 +1570,7 @@ static void ext4_mb_put_buddy_page_lock(struct ext4_buddy *e4b)
>  
>  /*
>   * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
> - * block group lock of all groups for this page; do not hold the BG lock when
> + * block group lock of all groups for this folio; do not hold the BG lock when
>   * calling this routine!
>   */
>  static noinline_for_stack
> @@ -1618,7 +1618,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
>  	if (e4b.bd_buddy_folio == NULL) {
>  		/*
>  		 * If both the bitmap and buddy are in
> -		 * the same page we don't need to force
> +		 * the same folio we don't need to force
>  		 * init the buddy
>  		 */
>  		ret = 0;
> @@ -1634,7 +1634,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
>  		goto err;
>  	}
>  err:
> -	ext4_mb_put_buddy_page_lock(&e4b);
> +	ext4_mb_put_buddy_folio_lock(&e4b);
>  	return ret;
>  }
>  
> @@ -2227,7 +2227,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
>  	ac->ac_buddy = ret >> 16;
>  
>  	/*
> -	 * take the page reference. We want the page to be pinned
> +	 * take the folio reference. We want the folio to be pinned
>  	 * so that we don't get a ext4_mb_init_cache_call for this
>  	 * group until we update the bitmap. That would mean we
>  	 * double allocate blocks. The reference is dropped
> @@ -2933,7 +2933,7 @@ static int ext4_mb_scan_group(struct ext4_allocation_context *ac,
>  	if (cr < CR_ANY_FREE && spin_is_locked(ext4_group_lock_ptr(sb, group)))
>  		return 0;
>  
> -	/* This now checks without needing the buddy page */
> +	/* This now checks without needing the buddy folio */
>  	ret = ext4_mb_good_group_nolock(ac, group, cr);
>  	if (ret <= 0) {
>  		if (!ac->ac_first_err)
> @@ -4725,7 +4725,7 @@ static void ext4_discard_allocated_blocks(struct ext4_allocation_context *ac)
>  				   "ext4: mb_load_buddy failed (%d)", err))
>  			/*
>  			 * This should never happen since we pin the
> -			 * pages in the ext4_allocation_context so
> +			 * folios in the ext4_allocation_context so
>  			 * ext4_mb_load_buddy() should never fail.
>  			 */
>  			return;
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

