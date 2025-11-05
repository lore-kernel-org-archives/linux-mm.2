Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC4BCCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BBD8E000E; Wed,  5 Nov 2025 04:14:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123448E000B; Wed,  5 Nov 2025 04:14:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038D88E000E; Wed,  5 Nov 2025 04:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E71878E000B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:14:03 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A02651A0278
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:14:03 +0000 (UTC)
X-FDA: 84075991566.09.ED07575
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F92CA000D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:14:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DM49Z0AV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QqrZbFsD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DM49Z0AV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QqrZbFsD;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXVULkgdA4xsS+fwyNhdq5btCzXP1JoCzKO3djpV8yo=;
	b=tYDY+/T7h/CH5+8MWEhfweAxWsSFusF4igGfgsR993YPHXFSwnHJYEnV+uq92MPHxOaydH
	FTNsSjtk+Mt7syka7UzNxC2OI1c0zNC9nii7kCHcVjSqGV4iih/Ekic/0DxiSm0YUcYDrW
	CJoQTNDAsdmf2n0k9QWzOVGlYnZXIdU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334041; a=rsa-sha256;
	cv=none;
	b=VaxCvK8FmmieAOC09q9WSzoij18saNEHkPSFAT+L32Fl8frX4vEDCuU7yYGMbihC9shj2A
	YRGNwio+UQc/lIhOE81zyxBUaRnuZsIAHh/kQ4ASferrNj7qbbg7KaUNF8Yn+Q2MuxODoz
	Qt87Mddkn8Rcahbb3kmQ7L0RwpekEgo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DM49Z0AV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QqrZbFsD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DM49Z0AV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QqrZbFsD;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 88A842117A;
	Wed,  5 Nov 2025 09:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVULkgdA4xsS+fwyNhdq5btCzXP1JoCzKO3djpV8yo=;
	b=DM49Z0AVDbdX9K4m55bhvKSEXvqStAOD7sIrHzA2bDCs946x17M1wBUmJl0KvkxTtzOv4r
	J/GnFld1WgFiQx9BLNFwVIqYw3fRfJbcU1YjkAzYcmfPgsN67hftIv0BLEzuJBNfQz21O1
	Q5q6j0oV0lJ+5ArhM/wnnjKTAkCmw3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVULkgdA4xsS+fwyNhdq5btCzXP1JoCzKO3djpV8yo=;
	b=QqrZbFsD8QMZ+iHmxR557wLBgrgr/Tw9H8D62mgtMmeUi4R2sCijayKcLEYoWvYdCqYtph
	IDipEq2zq1JG4sDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVULkgdA4xsS+fwyNhdq5btCzXP1JoCzKO3djpV8yo=;
	b=DM49Z0AVDbdX9K4m55bhvKSEXvqStAOD7sIrHzA2bDCs946x17M1wBUmJl0KvkxTtzOv4r
	J/GnFld1WgFiQx9BLNFwVIqYw3fRfJbcU1YjkAzYcmfPgsN67hftIv0BLEzuJBNfQz21O1
	Q5q6j0oV0lJ+5ArhM/wnnjKTAkCmw3g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LXVULkgdA4xsS+fwyNhdq5btCzXP1JoCzKO3djpV8yo=;
	b=QqrZbFsD8QMZ+iHmxR557wLBgrgr/Tw9H8D62mgtMmeUi4R2sCijayKcLEYoWvYdCqYtph
	IDipEq2zq1JG4sDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 79C33132DD;
	Wed,  5 Nov 2025 09:13:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OkO0HVcVC2kwDQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:13:59 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 36A42A083B; Wed,  5 Nov 2025 10:13:55 +0100 (CET)
Date: Wed, 5 Nov 2025 10:13:55 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 12/25] ext4: support large block size in
 ext4_mb_get_buddy_page_lock()
Message-ID: <5kbyz6ilhj7zde4dtv7fhy33yks3bhs2g6xesdzwptdenrrfdg@ydurgdouhuwn>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-13-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-13-libaokun@huaweicloud.com>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F92CA000D
X-Stat-Signature: aiuk79szxp9qa5jkine3ukjac91wpf43
X-HE-Tag: 1762334041-700627
X-HE-Meta: U2FsdGVkX1+LOSzmomaTCvF3BFiel9OdlgW8xnC8PJGH2u15hTv3ULfAzdU9ZEhfd3KG1u4GQDmou99DLY0vIvq83I6L5xH2a/SjTySuHeBLnnYSdnUVhCxFfhxaR1FVRjGariclzZA6hukZGEojZ0ncUqqYgJ53DzcVyzS3ATX/gyAnC4XpRgH1MfDOHAevGi7ck+gRxngADMtAdNCEZxvcENB6uLzVO/QBudT6Cf2pOvp7DHIEslhccMJe8r5Iso/69AgoLYPKs1pseu56SMX/8FlX6pi3wwOnaootMI4tME+mxF2080BITrUZmptM5Rrr47+OiLbG/BN2qA0b85qdEhzWKL9TBMJKODQ4dIiRTUGbsqTYL+sx6URDCYdgNWMrh++ffLZC+mXlZrcIcwn2qrqi6KubFlKQtGIFpWX0yfOUoOsfkNoezQPQUXAD1Mqqa0lQmJdEJBdTB17QYzuEPsYCZ/AZsdupvV2KIPqPfNDPe9ZyEGMTea//k2NXwLetyqhm8Pg74eW33RCZ27rAOO5gDk8fDfe3IkxRX+JAWwqcsrjEK255Oii0pY+T7lBQ+o1ybPnabpR4jyikftze07Ryr4iYKaFCcc+0DUjSZYfe/97ufQ9aNZ/vHhy1zRnMED8xtpMytF7onQV3ku3elPEPZQInEvmTdpjibDC1WitLLFO325vAIkTtZQ1dal9rh6HGDnipUuDJWLxUO7NpnoxyimGOiZw9kBdVNZU98N2DOX3KvkcPh7iuJqhIfB8QGTxsEgSr2mim0vFZZBSe/KE3MWJqDxYPSVAMMPeudKNJdwu0UkDvFPl9fbEM5CVN/4kKikXxOm36YS77bLg/8GAKAtXbgDwQ3PmFwVf8H0yifZq++LG6ghBm+Xh3Q2LjMjO7GREpDM855Zx5SOMw/3gey4t54lvzSsnogcIYLoLUh13s/e0NrdwD3+T757aoSOH3Ub+kooudEUt
 ojWDH5TQ
 88N2m2caXVSYYY3DoAkhC0UzFc8o3gCvDRdXaVhprt31CkSn7LT8CuoGK0xtHFqMTURoGKdlC4+RcG14/wxHyNF1h/Mmtq5tX2fPKkBT7livTsCrZjhnwAdJ/QQVyjzvp70emRY/DYlNOpxbBHr3z3EHu6ZCILjfqw7eoSncjQho6+Fi8A93zTBKRIZ4J5fXSQ8ambNFlZazSkCEdm1zkbtrxQD9xQ9wfvRxW3IKL/o4V3wQiDndplGJOoUewub0+c/jKd51FV9RF+hxelgXMF8h4iWbB53e4g/if1KKGsVq0FSJRgFXaX3s1lYGRdMWgmqPvXvuT9InKc2wYaz8+X9CQPeqbNZaM79twlJRIBwSratGoV3Sb0K5y+9GQVlzZVqsglTlfuNwEfjA+vVpDYiRg9fc8VtC2AnJ2qwVTaFc5cIhmhtHbf8OMwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:08, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Currently, ext4_mb_get_buddy_page_lock() uses blocks_per_page to calculate
> folio index and offset. However, when blocksize is larger than PAGE_SIZE,
> blocks_per_page becomes zero, leading to a potential division-by-zero bug.
> 
> To support BS > PS, use bytes to compute folio index and offset within
> folio to get rid of blocks_per_page.
> 
> Also, since ext4_mb_get_buddy_page_lock() already fully supports folio,
> rename it to ext4_mb_get_buddy_folio_lock().
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good, just two typo fixes below. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 3494c6fe5bfb..d42d768a705a 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1510,50 +1510,52 @@ static int ext4_mb_init_cache(struct folio *folio, char *incore, gfp_t gfp)
>  }
>  

Let's fix some typos when updating the comment:

>  /*
> - * Lock the buddy and bitmap pages. This make sure other parallel init_group
> - * on the same buddy page doesn't happen whild holding the buddy page lock.
> - * Return locked buddy and bitmap pages on e4b struct. If buddy and bitmap
> - * are on the same page e4b->bd_buddy_folio is NULL and return value is 0.
> + * Lock the buddy and bitmap folios. This make sure other parallel init_group
					     ^^^ makes

> + * on the same buddy folio doesn't happen whild holding the buddy folio lock.
					     ^^ while

> + * Return locked buddy and bitmap folios on e4b struct. If buddy and bitmap
> + * are on the same folio e4b->bd_buddy_folio is NULL and return value is 0.
>   */

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

