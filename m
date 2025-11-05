Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE7B3CCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8788E0014; Wed,  5 Nov 2025 04:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF938E0005; Wed,  5 Nov 2025 04:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5918E0014; Wed,  5 Nov 2025 04:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDB888E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:59:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 938D2140266
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:59:41 +0000 (UTC)
X-FDA: 84076106562.04.428C576
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 23DB3180018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:59:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kI0QejRy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m415Ww6m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kI0QejRy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m415Ww6m;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762336779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1Ss//4cSgMvifGeWImkl64oHq4TXjdrB0of3t6e6oo=;
	b=qu65eK6GagYeFNd6Q7Y5oAr8bjsMIMJKL0AZfiiOfhevICYvrGtXD4qZ8Muk+dk7A573Bn
	XgHzgzLvDIOCeC/HSG4GWsKCFfQEQmf05P7JLp1a/2qVJ/WQJT67lHThRLT74S0uI3v5pZ
	KQWBtAhs5I8BgvOCU+6tMRTClqeCt+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762336779; a=rsa-sha256;
	cv=none;
	b=Hduj9s436VUbhltk+RSVmlzX8OsczsDo9DDnVceI2gvtmgUHmzmjlE1utn6wRrAjsMpSJQ
	4FE6WjKRqLvWUMbT/DWxTyk1xxYlcMeWs4ugeZrt9os/z6W8wE+82ahIYwxgdo4PkL5xxU
	vWFtVZq3Zsz15Ov136sYACcOdY1Upeg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kI0QejRy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m415Ww6m;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kI0QejRy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m415Ww6m;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 64B542116F;
	Wed,  5 Nov 2025 09:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762336777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r1Ss//4cSgMvifGeWImkl64oHq4TXjdrB0of3t6e6oo=;
	b=kI0QejRy1xQMo6/OlQcZ/X1tRn0MFaHDbTEU7srbrDJ5m8CqwFoxjrEA5qNMv3kcwW6pyo
	2hIybOCZzJkELbu7gmzmz8KIqaVgzg5vEzTgo+sHldpBWvYhfLit+xb1Fiu6JA6/aqQdaF
	7rPrDUb/RLq64PjxJDTdrGRy9aSO3uA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762336777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r1Ss//4cSgMvifGeWImkl64oHq4TXjdrB0of3t6e6oo=;
	b=m415Ww6mKZ1x8BvTd7SrZRtqgGp5HzBCazCYjdlSnSWJHQTIki9uPWO6uWwVsZIIvOXEvD
	DjDDVVmycJCtKFAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762336777; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r1Ss//4cSgMvifGeWImkl64oHq4TXjdrB0of3t6e6oo=;
	b=kI0QejRy1xQMo6/OlQcZ/X1tRn0MFaHDbTEU7srbrDJ5m8CqwFoxjrEA5qNMv3kcwW6pyo
	2hIybOCZzJkELbu7gmzmz8KIqaVgzg5vEzTgo+sHldpBWvYhfLit+xb1Fiu6JA6/aqQdaF
	7rPrDUb/RLq64PjxJDTdrGRy9aSO3uA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762336777;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=r1Ss//4cSgMvifGeWImkl64oHq4TXjdrB0of3t6e6oo=;
	b=m415Ww6mKZ1x8BvTd7SrZRtqgGp5HzBCazCYjdlSnSWJHQTIki9uPWO6uWwVsZIIvOXEvD
	DjDDVVmycJCtKFAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5B2EC13699;
	Wed,  5 Nov 2025 09:59:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pnBBFgkgC2l+OgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:59:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1C8C8A083B; Wed,  5 Nov 2025 10:59:37 +0100 (CET)
Date: Wed, 5 Nov 2025 10:59:37 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 24/25] ext4: add checks for large folio incompatibilities
 when BS > PS
Message-ID: <arj5yptdhk2tptkqu6q2kwbyhh5cx4ncfyz3hfhlfikx57yf4a@nolkehxy2kqs>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-25-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-25-libaokun@huaweicloud.com>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 23DB3180018
X-Stat-Signature: szfg6e8swndbdpyhg4pgt7b66rt9xtha
X-HE-Tag: 1762336778-265898
X-HE-Meta: U2FsdGVkX18QQqcPdTGjnpfURffvF9tdnuaTId4U/azP8qGrRgJOgOTkmKRcnhflX9kPRHGO3DCDnERZvsVZX7VyK9MP0TAP76CG2t1D2Qkbaq1Dub6SxRaG5F++q7NidvkQMSxXBR2XNuXwLyol3euDR3hkProQoIXKDCHNDpRY0oHX6tcVPP3DmoMUITWD9hYb8ANnl4/FxpJ9tpbF5UWlC21207L9vorNtwB6hBdm7IDl7tOM2A4Bj7INfAdmtTXDj4ZfHVNMk8gwlBLGsio/fRm5hNgaPsJeaHbHyXk9q/mshLrFnVvpPvYNFrrWy2P1MFDA92/A27glQOJYVjTWxqos1yNyYw6uMqjNHe52HIfIrI/KGoGVQPHfJqsDLZzGoolLcSPiTaCr6FBLgzfJHE3nxibjRSe7if7HVs2X4HrxeoefxiQNSaRVWPYSNOSzCcAn0OlSVln4yCEYkCdJV1RyA04XdWO5nWwJ9VruzDuuymxTVcybVlbbamPnNl2Quog7DIfcM/kiDrdEn4PsRU5KxdOvKEet79fHOkcFSM09Tr9I+BHd9behdOnH6J7Yjgtr/90lYwI/YZ6mmA1ZzezifPl18cdchJ5BExVBbOr4oWfIi9MOMDtaJxL+e/pFGtO9I65ODPu4MuECjtmMMvC/gAutPLXAnNXkFZKlVWroVc4am6e2LysL2cWoN+7KrmNISfrxB9i/kSIS4pOO9DGcfPp8z4mFmQF9lLTPK6Nv/CkKSGRS8uMegqAgw685VY+WVpuouibg60bZTw02BgvIDLEtItlcDccxZ+WKcxHKBCtpQ6lLDSTy/mPNquiB3pWOWA6ikoXRUjv0aBqWX8nez5l6jP8XpSL9oska0kefXoxpJ1buVmSv5covnzKFHILBTZX7QU9FDBxyXcXcJE8n0i53PJZioLJv2KndZmAd9aREypcKiSsaoo7p4OHISK0fJIXBD+jWlyB
 4/ijNVN3
 EzHz7vf9RywA0k/G6qYQmXQi3ztdmmbXdKv9pv/SiGekTciBb3D4DhGuwbTUQkXR/RD5igjqoxhOzojgwzFeYR0gafbS3HZt3aAhq9Q5WEHezeWQxPODL+YPTcdbRoRx77Hq2NUkXlLoc74XMatBhOPQM85WzRcEqPmRY4uSqAt01i57kjdxo65kUKhj+3I+2OBUYmdvZ1g+pX6RqQd0yZd4iNPNUlIj6mcewi1N200LJ0mgkxxwLSjkRQ3rZkt2dUr7aIDQGDs7bbAAQ05mMYFNR78QAmydrSqUmVgexxqJY9qnfqrPXgqvfb436BZbAhYn53gL75NZj15E4tQyN8C4ybAhv7Rp7Bs9ZvJHKaKiduPF25G2J32eyqWlm/0TRmG4lG2wE3zZONUyviuzPxClDaJH6+hGDZKSL/yFdR/IjF6A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:20, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Supporting a block size greater than the page size (BS > PS) requires
> support for large folios. However, several features (e.g., verity, encrypt)
> and mount options (e.g., data=journal) do not yet support large folios.
> 
> To prevent conflicts, this patch adds checks at mount time to prohibit
> these features and options from being used when BS > PS. Since the data
> mode cannot be changed on remount, there is no need to check on remount.
> 
> A new mount flag, EXT4_MF_LARGE_FOLIO, is introduced. This flag is set
> after the checks pass, indicating that the filesystem has no features or
> mount options incompatible with large folios. Subsequent checks can simply
> test for this flag to avoid redundant verifications.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h  |  3 ++-
>  fs/ext4/inode.c | 10 ++++------
>  fs/ext4/super.c | 26 ++++++++++++++++++++++++++
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 8223ed29b343..f1163deb0812 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1859,7 +1859,8 @@ static inline int ext4_get_resgid(struct ext4_super_block *es)
>  enum {
>  	EXT4_MF_MNTDIR_SAMPLED,
>  	EXT4_MF_FC_INELIGIBLE,	/* Fast commit ineligible */
> -	EXT4_MF_JOURNAL_DESTROY	/* Journal is in process of destroying */
> +	EXT4_MF_JOURNAL_DESTROY,/* Journal is in process of destroying */
> +	EXT4_MF_LARGE_FOLIO,	/* large folio is support */
>  };
>  
>  static inline void ext4_set_mount_flag(struct super_block *sb, int bit)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index b3fa29923a1d..04f9380d4211 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -5143,14 +5143,12 @@ static bool ext4_should_enable_large_folio(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
>  
> -	if (!S_ISREG(inode->i_mode))
> -		return false;
> -	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA ||
> -	    ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
> +	if (!ext4_test_mount_flag(sb, EXT4_MF_LARGE_FOLIO))
>  		return false;
> -	if (ext4_has_feature_verity(sb))
> +
> +	if (!S_ISREG(inode->i_mode))
>  		return false;
> -	if (ext4_has_feature_encrypt(sb))
> +	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
>  		return false;
>  
>  	return true;
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 7338c708ea1d..fdc006a973aa 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5034,6 +5034,28 @@ static const char *ext4_has_journal_option(struct super_block *sb)
>  	return NULL;
>  }
>  
> +static int ext4_check_large_folio(struct super_block *sb)
> +{
> +	const char *err_str = NULL;
> +
> +	if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
> +		err_str = "data=journal";
> +	else if (ext4_has_feature_verity(sb))
> +		err_str = "verity";
> +	else if (ext4_has_feature_encrypt(sb))
> +		err_str = "encrypt";
> +
> +	if (!err_str) {
> +		ext4_set_mount_flag(sb, EXT4_MF_LARGE_FOLIO);
> +	} else if (sb->s_blocksize > PAGE_SIZE) {
> +		ext4_msg(sb, KERN_ERR, "bs(%lu) > ps(%lu) unsupported for %s",
> +			 sb->s_blocksize, PAGE_SIZE, err_str);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
>  			   int silent)
>  {
> @@ -5310,6 +5332,10 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
>  
>  	ext4_apply_options(fc, sb);
>  
> +	err = ext4_check_large_folio(sb);
> +	if (err < 0)
> +		goto failed_mount;
> +
>  	err = ext4_encoding_init(sb, es);
>  	if (err)
>  		goto failed_mount;
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

