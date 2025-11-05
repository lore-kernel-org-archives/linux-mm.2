Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A42ECCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AF338E0019; Wed,  5 Nov 2025 04:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FB78E0008; Wed,  5 Nov 2025 04:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850988E0019; Wed,  5 Nov 2025 04:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB868E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:31:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39EA8B7803
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:31:52 +0000 (UTC)
X-FDA: 84076036464.15.2660271
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 985D0120011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:31:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aFsG9XOx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9nFT0QKk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aFsG9XOx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9nFT0QKk;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762335110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dhBI3wtUUGN8VYMC+NN1TmUWEPtpBQKbvGkUzp4Vn4=;
	b=8iO5Th4Jmj7K+yx31d6lbIEfH5wFm9gK2UkQJ2hA+Unm556kXoqDBQ+DiXk2yTbxfDqt9D
	9rK0JWDxpBI0O60yBCDUJpAAIfX5HaGzorkFouukU7Tk1X/TT1hXLIojYHsJYUHFEoAkxb
	28wQnM12n9JO5WCX354CieuSSM8E5v8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aFsG9XOx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9nFT0QKk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aFsG9XOx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9nFT0QKk;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762335110; a=rsa-sha256;
	cv=none;
	b=ApPtnbFRYVWt59ZhirfRYgReGRaORhz6U8XHJ48HLCVRRnjhpQdpLc9MVCpuQY+XyMr2bD
	iNtHkmJBwyAk1k/X2e/mrzT7ZzdLgeB6oilBITk0yPIS9QpC8Jjd+9kOHDZg4lxDiYusOi
	VrPYF3Cpndzt1X4FxXlTTdLjU+CgcWA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0A65A211CD;
	Wed,  5 Nov 2025 09:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dhBI3wtUUGN8VYMC+NN1TmUWEPtpBQKbvGkUzp4Vn4=;
	b=aFsG9XOxNgfZjqF1+TZq/aUlkyMAiG05LcrvqPnchHr6sZXxbpALmJkaW7aGCADJxPrk5n
	RuN8RRXOzucWiSgNK2gBI2JAUjD4iXGWsG6Aa2+Im3OGLAJKF5HG7lRJniHhBZAvgCGngn
	o3m72mdRxiE0fpM5Jxcz8fFg4dty6P0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dhBI3wtUUGN8VYMC+NN1TmUWEPtpBQKbvGkUzp4Vn4=;
	b=9nFT0QKkG7hMvQYQz1w+N4wRwdOEX10tqjL851bdA15QjLQ7JVXzRO2WuQFuVL9qqHMar/
	5HzjHwYO4GhrbgDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dhBI3wtUUGN8VYMC+NN1TmUWEPtpBQKbvGkUzp4Vn4=;
	b=aFsG9XOxNgfZjqF1+TZq/aUlkyMAiG05LcrvqPnchHr6sZXxbpALmJkaW7aGCADJxPrk5n
	RuN8RRXOzucWiSgNK2gBI2JAUjD4iXGWsG6Aa2+Im3OGLAJKF5HG7lRJniHhBZAvgCGngn
	o3m72mdRxiE0fpM5Jxcz8fFg4dty6P0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7dhBI3wtUUGN8VYMC+NN1TmUWEPtpBQKbvGkUzp4Vn4=;
	b=9nFT0QKkG7hMvQYQz1w+N4wRwdOEX10tqjL851bdA15QjLQ7JVXzRO2WuQFuVL9qqHMar/
	5HzjHwYO4GhrbgDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00BF9132DD;
	Wed,  5 Nov 2025 09:31:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nEssAIQZC2n6HgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:31:48 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AD641A083B; Wed,  5 Nov 2025 10:31:47 +0100 (CET)
Date: Wed, 5 Nov 2025 10:31:47 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 19/25] ext4: support large block size in
 mpage_prepare_extent_to_map()
Message-ID: <fgyzoczbfupsdkstxojoodxnny3mjoqj4jn7k26lq7barrtq72@zvw2p5pvglnk>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-20-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-20-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 985D0120011
X-Stat-Signature: 5ks4kzq3aswi5oji5ffemycuwbc9j9u5
X-Rspam-User: 
X-HE-Tag: 1762335109-891992
X-HE-Meta: U2FsdGVkX1+C1KXTKpTUBAZTK8rAcxGYQcmDOoc1sMVy04zS/suOA58pkyIGJPCiO06hWKQ8Z7qsfD+uyc6s6YGTjbOiHI4mdC/4iVOzMBMnBARvInXy863k05ChEByttKVogZKOvXFXytFvODNtQUdltRHHboZk6mPi5jvQZVo8q5TkfDDJI20+cAn6e9S+Kedz9tMm9xk/xLiOfbhXzIW+/htOmLht7OhvdhyNWjRN8fdWnBWd/S2FqW/McO2sj2qJ+9RKaV08nBC5tlvSFvfRMkhpV2xqOg7/qt7u/5kYIM969bvL2H9YFsi4VAGX+8jX1XZgYnttTap7N9HNkb9lWnw4sADEGFNd24qAV53VZSttlyZWY6EElx9EsXccZvhv+sk79/HS5Oyjc2O2Wjmkq+dP2Jv7tkoCWMrTOoiiZ4sB8hwQJyFAxVJTIQM9grq4H9laPrE1w4mFXMPePhNvwq+pG5DuVv23RVmbP0AhM+8abF6atTYs53T8ACzXpGWueHDn79MQ5f6+YrNx5cGm/Fp8rGp1wjGWYLUYHm6my+KPkCwIlDqTxeMOsHkiAkJu/SBHTJLBjUYwNamJ7CoKR5/FL5OaPSZcGzthUq9TZ8qLbWArdAue0IYhuxRDyUFWkG/Z2s6Z7nD8uBV993K1V9qutKHpY+ahnRLpT+/I1PPhzfCj6f08ocwo/ZKPyTHenLOVq9EvwvDe3l4tCA+meAJTc8liO0CCUr6uH1zRjlIFHkmY0U4KLqZp9xwx+AhWqYOkVZEkhHsA49SWYyXs3zWGi+Z0g1wGSEzaJ9q6ozxjMq8cmEB/NJeoW63tIPQMMXVBAz9pIASpZNpA+xqIT0vl6bif/Ag/CE4LU8OEgkNrAC0/ZYj9H/p90GnJ/T4VJqbl7KUvWyH9YAwwbd9U2/OJT35exoqkIC8ctjSLGxHgmee7B2mYrMw0uuPVzCqn2FP+vUFJkxyypq6
 yzwYi2jN
 Fh/eL3x/rDM/PMUpGT59bCmmhV4lf3LOAckaP/XUMv1d3PmccXMg+/LK6ZlFokZgfb7exFQH9o52s3I7sh4qVagCkcNLNgYMI8t76YKKSxJYjVxhqJwhFKBcstYtYJKlJe0cF4IUgrTaIUcQYD4gZWfA42PI30yas9uTFYkBEHFOHKWx/Xr3kjE2ZWoqNhZixY0CJVVgmOYeJHnatn1eBqVgt7OJKYT1QL16N5pM74CYPNen2fvC4Oirz9eo4VPPBJno2A89Pnt0Fk5BPPURQQiql12WIvY239oOUaqFak0Cyk4XrskrQoB9OxREaX3buP8xXAx8U8uA1f1TiZaqYBocYi/iNNZxXAkVKOWmHb4FZyolIr42EI9LrZnYmB9RIDtK7QyTd4XlNGJ/jvS3p1IDdiuPImAgIu7ThEdKUlimQcUhP9SefqPXRTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:15, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Use the EXT4_P_TO_LBLK/EXT4_LBLK_TO_P macros to complete the conversion
> between folio indexes and blocks to avoid negative left/right shifts after
> supporting blocksize greater than PAGE_SIZE.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index cbf04b473ae7..ce48cc6780a3 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2610,7 +2610,6 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  	pgoff_t end = mpd->end_pos >> PAGE_SHIFT;
>  	xa_mark_t tag;
>  	int i, err = 0;
> -	int blkbits = mpd->inode->i_blkbits;
>  	ext4_lblk_t lblk;
>  	struct buffer_head *head;
>  	handle_t *handle = NULL;
> @@ -2649,7 +2648,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  			 */
>  			if (mpd->wbc->sync_mode == WB_SYNC_NONE &&
>  			    mpd->wbc->nr_to_write <=
> -			    mpd->map.m_len >> (PAGE_SHIFT - blkbits))
> +			    EXT4_LBLK_TO_P(mpd->inode, mpd->map.m_len))
>  				goto out;
>  
>  			/* If we can't merge this page, we are done. */
> @@ -2727,8 +2726,7 @@ static int mpage_prepare_extent_to_map(struct mpage_da_data *mpd)
>  				mpage_folio_done(mpd, folio);
>  			} else {
>  				/* Add all dirty buffers to mpd */
> -				lblk = ((ext4_lblk_t)folio->index) <<
> -					(PAGE_SHIFT - blkbits);
> +				lblk = EXT4_P_TO_LBLK(mpd->inode, folio->index);
>  				head = folio_buffers(folio);
>  				err = mpage_process_page_bufs(mpd, head, head,
>  						lblk);
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

