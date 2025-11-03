Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7304CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:26:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249AB8E0040; Mon,  3 Nov 2025 03:26:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2214D8E002A; Mon,  3 Nov 2025 03:26:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DE58E0040; Mon,  3 Nov 2025 03:26:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 060048E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:26:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6B7C1A06A1
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:26:51 +0000 (UTC)
X-FDA: 84068615022.24.09C2091
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8071640006
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:26:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xXvgWBWa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2BoyNGSZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="njdsz/S1";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dGiRpTqG;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2hFRJn2Kyi+oiGmF+GmQxzUb4rMnpUBXOo5howiaPk=;
	b=5wUIeyO7QD6fbwpxhwGqmr6XOtECBG/gVCwbJc+AgbK4ASICbVhYBwvUgUWsTfWiYzvQwd
	jcUuL2/0It2sRys6HUpgEgrbkCSxPrdRRrzuOSpqTuvPVTSRlcQWVfMc71dmWg1+lqVHrs
	hY1gb5AJ7OoL+t92Ta61a5g946ykqCY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xXvgWBWa;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=2BoyNGSZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="njdsz/S1";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=dGiRpTqG;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158409; a=rsa-sha256;
	cv=none;
	b=7KhY2HvdmaDbytFU5b7VfLcL3jzHv/YVDMcT6zgQWK0Q7Fp2XG4BV8jl1rvc4tl8m18Pfy
	5F67eHhgvD2J7ZuwD7WgK7ZXllKjIvB+KSfjCDCWAEhlr+Ov1jpCMLWlc3kL5+azpwLbhV
	HoKqFTyb1b+hSWLPkjNlCfFjRm/1zXU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0D582197D;
	Mon,  3 Nov 2025 08:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2hFRJn2Kyi+oiGmF+GmQxzUb4rMnpUBXOo5howiaPk=;
	b=xXvgWBWaI0TcQXOZru6k0WqUinTS94hmPAx/q4qEy6gzlBs5pu5IscfKajV+wThWG6QVTp
	wVQaPkOlnPCqfOGHhrKflxQhjGULxzOhI4lMbuZBHanygTXaLcbJf1rQkspQfLld+On9ST
	ZEliQZ5dB/qkhpjERcClCXldBX0cF8w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2hFRJn2Kyi+oiGmF+GmQxzUb4rMnpUBXOo5howiaPk=;
	b=2BoyNGSZgTP0nCZtIsQ2EgFbD8osvf1aJ1+ONKPuuxNmX7dEB8kYgbFYBL/DJbWf816Npp
	+YVZIXnDJmIYHKAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2hFRJn2Kyi+oiGmF+GmQxzUb4rMnpUBXOo5howiaPk=;
	b=njdsz/S1Ks3UNOM9LmJYFGUgDv0aboQSkK7JvAtUukyEPtFrLw+Mqt8YzaGau8v1OkMzeR
	4UZABYFAKe7utWKKR3HuRaJk1rpdUpjJBiy8kTUbCYbAo/NPdp6FHSFjIbDAvLNyRFGV0i
	43sWzAXW26wE5f1ZJEKZlj5xqHCk0qs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f2hFRJn2Kyi+oiGmF+GmQxzUb4rMnpUBXOo5howiaPk=;
	b=dGiRpTqGuMsxwpcYYT+YJU5TZbLhUp7CZlcwQIQTmbw1++n+FywebiJETkByfopFU2wle0
	134baiDqb2hA4jDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DDD86139A9;
	Mon,  3 Nov 2025 08:26:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WCEoNkdnCGnZbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:26:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 43236A2A64; Mon,  3 Nov 2025 09:26:47 +0100 (CET)
Date: Mon, 3 Nov 2025 09:26:47 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 10/25] ext4: add EXT4_LBLK_TO_P and EXT4_P_TO_LBLK for
 block/page conversion
Message-ID: <pgrk2x54egzxcvmfi4rra3exooxe3yxuvug6yvbtrgxm2oppym@fy52xh4weeww>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-11-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-11-libaokun@huaweicloud.com>
X-Rspamd-Queue-Id: 8071640006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rsdi8bj3mgctr1dp1s3yh3rp57zawwdx
X-HE-Tag: 1762158409-205212
X-HE-Meta: U2FsdGVkX18BLhzOt6Yf3/Zr7BeRbPwUra3i/vjmh8QnoX9a7+iNzgMJC11YyyUXhOd7gFUDNweXZkF9omaL9kLXPPr3TPA24o7EygyO1CEy0T0EmPiu2PMFcJNsghv7t4PosBigF3rDf2EvHX3yOnjDGbKb8NCbvKANdVFEUkHxx+5s621d4yK487ZUEbVreArrsVBh/2tacUEDzTESO+tOBOecOLRypdgxpO4o/2XNDLbFxHPg4QPfspBa3nBqXmBTY9CChqixKALtVqIIw3PdAIkPYB/M/dcRT4SWt19Unz3dMktof0+8WDJHXy6zXczX7L7tqurBcHpa1N55IZqBPXzj4OwtBdCkoOnsXBB1EsYw0dTXuEH5dZ31ftNP1KKz6xnhMTKw4hd636EbbskJzHNb8chrenLTQi77f/YeuS6BrMM+/LKwPdPyqwe6m0De3oQFDr2bNc+jaie9ToCulXPakoxb+tKQM0t27rllyOM5ShfKaFnGAZL/Ceqba3x3qNoQKfxhYVd/cSQcx+moyx0U8EaCMPh2EZo2+r3dd+ueMJR87Qfi3b7KPmjXfrvLyqfqEhDFyzcKpu4S1q/Zu6Y1nYVhfPanMq8m3ilCXx+OPUnuGNeDl9F6krNJiDYiq63vjL4/rGHaR/DBU5Wmzfqya0grPkOOoF2+05lUZkUV3j3V7bFF1YwpOL+WxgT1mQbv/F/bB2K0yEUwJY6WI2fvHsOTAWcdhrA6ldy7lE8xsvlooks7ozHFnUs8mDHOKJDI0QPNrKjUTnJvtfP7hn0Ld7y0MUxE1L4fXYs4Mhf1xX+T8xo4FQBSbJ9n11i3f5FMWb0weonc87hgelVOg/WUQ94mpqeJ7bxRDvSx2XntJzbYugBPku/MkuN2hq0Dz/oF5hIwZlkhDljjzzj8sCTrUiDIlNyvFHdHN1PvY1qT8RBgU3dxPBGOB6VFgUH8F/W6zNPELIevjzt
 Nng4+vhV
 9RuxfU6ndu/0v8yUCkxmEwCnqKIMMsSBaKLMu/q/RYibEsdi0xDfUjJ7Rfj0KN8c23JoBn9lxlRXHUvyhCGYFU8KipOsvBuDUq6BqvDJHT/H5wN7vE8x3zQegG0IibzHQN3gRPvlT6d4CFjCZzkvy0BhRTggi2KAsRX1U66fXH4uX9TArbMB/1r5Eu2g5PRTN05B2m2Bq7TXYmRqPK844tQZQ1PbWQARhcmWtXKH3Rg/BUVkGw9lHIFM2BtRHmBcHxTRBcPukfXi4a9wKtkNJg8gIj8HOGMIEGu4EuSZ/d4aaHLYNsie37yDxUDxjttHESCyngKvJUqQ18FgNaA8vlddMWkjYiZDDM7UAMorEPjgW8HYXSB3a3QT2ACxx5KL9Bswez09UQXv8JhrlSUDSCIvAR4gTpLbJ6OnHzgFtnCvk+bzZxvbWQKxB6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:06, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> As BS > PS support is coming, all block number to page index (and
> vice-versa) conversions must now go via bytes. Added EXT4_LBLK_TO_P()
> and EXT4_P_TO_LBLK() macros to simplify these conversions and handle
> both BS <= PS and BS > PS scenarios cleanly.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

'P' in the macro names seems too terse :). I'd probably use PG to give a
better hint this is about pages? So EXT4_LBLK_TO_PG() and
EXT4_PG_TO_LBLK(). BTW, patch 8 could already use these macros...

								Honza

> ---
>  fs/ext4/ext4.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 9b236f620b3a..8223ed29b343 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -369,6 +369,12 @@ struct ext4_io_submit {
>  	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
>  #define EXT4_LBLK_TO_B(inode, lblk) ((loff_t)(lblk) << (inode)->i_blkbits)
>  
> +/* Translate a block number to a page index */
> +#define EXT4_LBLK_TO_P(inode, lblk)	(EXT4_LBLK_TO_B((inode), (lblk)) >> \
> +					 PAGE_SHIFT)
> +/* Translate a page index to a block number */
> +#define EXT4_P_TO_LBLK(inode, pnum)	(((loff_t)(pnum) << PAGE_SHIFT) >> \
> +					 (inode)->i_blkbits)
>  /* Translate a block number to a cluster number */
>  #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
>  /* Translate a cluster number to a block number */
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

