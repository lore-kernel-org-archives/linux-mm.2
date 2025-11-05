Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 239FACCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A48A8E001A; Wed,  5 Nov 2025 04:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BCC8E0008; Wed,  5 Nov 2025 04:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B368E001A; Wed,  5 Nov 2025 04:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4334C8E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:33:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8729B780B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:33:07 +0000 (UTC)
X-FDA: 84076039614.14.A31B164
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id ABAB4C0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:33:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/IzLKtj";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+OGkLBWa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPUxJ8E7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+kwgkb2s;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762335186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=720QJ5QwK5/vr5g/qY55TBuX1V7STFt/v1biLS/zSUc=;
	b=MzAW9CC9Id1CNpRqfFio6k3M+WAeNldSbVSPriI6zRl1PDEjSyVvGIqwa5o3rniRXP0WMi
	ocgpTlw+TzXuBiX+NOhNAY3VVSAro1aPJk0oSNHbhmMBI9TBMWto9Povh+qkHrU/Vkc8TY
	/ff/O+zXPAqnf0BIxk062BSsqI+BE6U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/IzLKtj";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+OGkLBWa;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GPUxJ8E7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+kwgkb2s;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762335186; a=rsa-sha256;
	cv=none;
	b=xD5rYMpEUGW4NOgAZChYoTiLPp4Z8/Qwdd478BgS0HAPYTXFFDYsVUc14vDpSMKWe/UdKN
	CGaHvfXJ8rrlicy0LR/ItmbweF/XA75NmVUl74oCibsjZhxDE5NBSEf0Wf6hMcrt57PiWo
	RNXUhPGj2a75EBgjJ/+L8ThLN/ejLyI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EEE4221186;
	Wed,  5 Nov 2025 09:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335184; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=720QJ5QwK5/vr5g/qY55TBuX1V7STFt/v1biLS/zSUc=;
	b=b/IzLKtjV/0eAAbmf17eH6rNdv8R2um9sbE+sD+meEbCy7bs7qxejCiVOSCU/FsH1i+uzu
	ZDPf1HPEqFuJts7cR/HfGh/7BHZnLqHVbeNv/R6JGJZEg0KxrTMMfKkjoAnjtIB3jC7sqG
	z98+1sv+rG/5Llvi/1KwuZpo20EwvDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335184;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=720QJ5QwK5/vr5g/qY55TBuX1V7STFt/v1biLS/zSUc=;
	b=+OGkLBWaNbzrk+xAlP2+3LXX4So3KFAyvyUh0fDLObqSwVxEM+QzcRPG+7uC3p1ATeXm8x
	2U8BnIhsXul6TpBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=720QJ5QwK5/vr5g/qY55TBuX1V7STFt/v1biLS/zSUc=;
	b=GPUxJ8E7snsfPumu7Mni5yFht/9aqf9kvUjX9sQm5ZoryA4NYy5IzTkmEv+07lGkkgnV9C
	aCTgU+6szYKO5dDqLw88OM4FbleP/BdRG/cDHf1RUbGCLWhMXOqRBqlYvW+xblPeYXsa6P
	ffIBO9EKVaswdWZZBfLrcL+rFRthUFQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=720QJ5QwK5/vr5g/qY55TBuX1V7STFt/v1biLS/zSUc=;
	b=+kwgkb2slUfC1ZEC2lfxhjoL8X0/ffjeTDP6GpQgeG354nOdxItk+VsF3iYCBdDhelPpWv
	vRkc8RY6KvvUrsCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E37E7132DD;
	Wed,  5 Nov 2025 09:33:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hVCKN84ZC2nYHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:33:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A430CA083B; Wed,  5 Nov 2025 10:33:02 +0100 (CET)
Date: Wed, 5 Nov 2025 10:33:02 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 20/25] ext4: support large block size in
 __ext4_block_zero_page_range()
Message-ID: <cyj4y73fcmqykv5xnrixngivx6hfkhczdtuo5rxs6kwqcc4aao@vok4hhzzjbog>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-21-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-21-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABAB4C0003
X-Stat-Signature: 7oeqic596nm3x1r6qqzo1xbwbjxj6f4m
X-Rspam-User: 
X-HE-Tag: 1762335185-915224
X-HE-Meta: U2FsdGVkX18ufa4YVr963ODRygpbKWyXHmi93vHABi89uOqERaPa/VHiPQ9B/QvvVMQsnkvyTdzFlWJFFVtyi9B2V0y78S/SKRdPqDGgTUHoL5uNJ1ubFrM1dhYtMwQmato05Xp+1oKXxqnHI6QRik8xUxqOWiZZC/HUDjMqNxTa8/Rp2it7oFrirpBPrU+bKQsQKXDgQ+i9MQpZ9MArt3MoSrCvjU2FPIdCmckTh4YzZXOUzVEQ0gf+YAyt572VKL5DhBRCLrZa0UfJ1aD+i/EKBynQn7CtwvUvteAu1lOmJxfWdzlIh79MQH0e0sECcrJnTsJ9d93LYhDo8wcVZE7EvYvWjY5TH6bjEV8DdQs13FTgd85DWJ0Pl0k+VzM73L6CRdW7p82ZOBf3T5yrNUUmVr8SoXkYiJh+DSIoI2ZMH9MTSUpJUDWvN490t/RsBrHsVaFE+rf9gGRxcVvTChjXga06OA4H6RaG2HJegQ3Ljjgc9rnpMk9wGumqSjS0tYYZztt9Nylcw8828q0ppngc3RNpJkrKxaEaJttKm0K+ROGUWoc4U2odRu8gZonMqD3PIDZKDCi65+zgx9G3Vo/ASdbyMlPI6bhQHP2m1zKXHk7+7K4Lo3p9yveHCKYFDsqooLqC9hzATNzr1YfzBuJQ7Sw8T9SgYq1qdMEuczvGExsK7/wvBAU4Q7QhqLOreFVk5aBULa8ctqTDc5fIH5R52OLVgtHLyDJgZpPMiC8842/7slBS2c2I7Ip/soF4i/jAxObAGwnqGzDmRVRAog+/TQ/p9bCgCGW3VTkvoGUDNDMmtrS6KjG1C4vqeIOMKomDFI4FNJqWi56cZAUtds693rg+b1ypWpB1EDA/U367CcEW1+gJ/pS4AejxxTazejbQVS+3uh5WqnccjN01D1HuB1eK2i0lfyoJXQS2gC1934SsN3JL37b2d3arVPd0UtEGwkBy79wUuzVoUIs
 npKmfubq
 aRy06ouNZGmu3jQzFM+SRbEYykOTiQ6UDt9Men2YYMRr7g2kvFbobUqetLzANJNfiAa3oPdrolPrjqc9I6UQtLZH0wuJNqBHCNTk06I5ZFDFB1f6dHAwal6rYzhogC0qMk20d5OTb80eB7/yyxxElU+pCtikVAueDqAgiZ+1qZ2WjeD2feY2+4X3x7Vtg7HzdDYAsKv7Sk/L29NgHv2igRbPPNKhDKzO/OGWV7WAHDSZ4QRq/msnhPzQFnGhlgsoBq7wVY78LnY7KIvGcKK55NzDA25eHSoIENZjXX8hDMY7DvDob6jpmXRsEFrIsdM3TwCumV3B0SgdORiGs3k8pna5q85rDBRWPYSRtLmxIP+082YfkrZocWMZcdVwJNkKmOMAwF1q/ihJUW8F+Ce8+cVLDOHuBxY5WiZkqMlyxPxY3faNbSHruO28S5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:16, libaokun@huaweicloud.com wrote:
> From: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> Use the EXT4_P_TO_LBLK() macro to convert folio indexes to blocks to avoid
> negative left shifts after supporting blocksize greater than PAGE_SIZE.
> 
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index ce48cc6780a3..b3fa29923a1d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4066,7 +4066,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
>  
>  	blocksize = inode->i_sb->s_blocksize;
>  
> -	iblock = folio->index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
> +	iblock = EXT4_P_TO_LBLK(inode, folio->index);
>  
>  	bh = folio_buffers(folio);
>  	if (!bh)
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

