Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D60CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:31:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BE728E000D; Wed,  5 Nov 2025 04:31:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196468E0008; Wed,  5 Nov 2025 04:31:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC988E000D; Wed,  5 Nov 2025 04:31:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA4648E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:31:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AA4712B5D5
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:31:05 +0000 (UTC)
X-FDA: 84076034490.27.4C96048
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7897AA0011
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:31:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KuZQtyDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cn3IsDC1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KuZQtyDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cn3IsDC1;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762335063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3v0IBakxPfN80lKZ9HG+/JKVr7LVerWut7g1o96eek=;
	b=ruqE0a9E30xkS3Las7LRW3KObREFm+YrKEiFWweEjIZTn5Bi6RiF5CBiPQ+KUhFvapQwCi
	wSJMajHgbCaKfCqx39Z1ccHawyxEBcOlHm0+Kfi/Oa5SGdKKoysVMSRS+RLqpIqiGqSAZX
	d/fUPB8o6qbxPSuPV7389uMWfCRAkUA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KuZQtyDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cn3IsDC1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KuZQtyDj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cn3IsDC1;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762335063; a=rsa-sha256;
	cv=none;
	b=UG9DECq2jyuI13wAB54/5m+MGGURTKHrMgxFLp3wkSFvC/S1X0JmFuXrIAB1lEFZVAYP5o
	FvBWx0elc7KTK5c0upVk4FqqIgoHJmPSx6A86IZ7yRiqIaRDuni4tshzrmXo3hr0iej+RR
	EzGMogvvormX5VUGJ87Zbq1k1OmyfbE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B9A691F443;
	Wed,  5 Nov 2025 09:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3v0IBakxPfN80lKZ9HG+/JKVr7LVerWut7g1o96eek=;
	b=KuZQtyDjDUi7V99tm5RZCGH6RaZguDOoGjZ3UKdBXbYzrtKjGV6VqRMeSTuk0gMYQpaWs7
	ANBEo3cnhvywej/ZR7p4863VnVib1MuQybQG+sJKjhDvGk+o2esTiXlx/P41jamBcA7X6v
	C5CYJee1QE3CSvn2WIp1rAMlt3uvYgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3v0IBakxPfN80lKZ9HG+/JKVr7LVerWut7g1o96eek=;
	b=cn3IsDC1WuCkmuWAXqBY5fycF9EKm9Cx/1ov+sr8+dV249nzyqfUgdOZSsFaUmVjt5VCIh
	XLspu1adc1xBnpDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762335061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3v0IBakxPfN80lKZ9HG+/JKVr7LVerWut7g1o96eek=;
	b=KuZQtyDjDUi7V99tm5RZCGH6RaZguDOoGjZ3UKdBXbYzrtKjGV6VqRMeSTuk0gMYQpaWs7
	ANBEo3cnhvywej/ZR7p4863VnVib1MuQybQG+sJKjhDvGk+o2esTiXlx/P41jamBcA7X6v
	C5CYJee1QE3CSvn2WIp1rAMlt3uvYgc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762335061;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p3v0IBakxPfN80lKZ9HG+/JKVr7LVerWut7g1o96eek=;
	b=cn3IsDC1WuCkmuWAXqBY5fycF9EKm9Cx/1ov+sr8+dV249nzyqfUgdOZSsFaUmVjt5VCIh
	XLspu1adc1xBnpDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF959132DD;
	Wed,  5 Nov 2025 09:31:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ir3cKlUZC2kpHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:31:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5E667A083B; Wed,  5 Nov 2025 10:30:57 +0100 (CET)
Date: Wed, 5 Nov 2025 10:30:57 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 18/25] ext4: support large block size in
 mpage_map_and_submit_buffers()
Message-ID: <cyxlv42ng4cetw55mzxywfmzoqo7uzeemswnwn3ztfuphdpdiv@bjlhohw3gdzs>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-19-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-19-libaokun@huaweicloud.com>
X-Rspamd-Action: no action
X-Spamd-Bar: /
X-Rspamd-Queue-Id: 7897AA0011
X-Stat-Signature: tnru7xt8ubbaknjx7m7sb7f4cte4w99i
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762335063-142626
X-HE-Meta: U2FsdGVkX19FfTwAZTLvprfh5QWuJWVK0bDzx7QLZ9GnNAdfpXrMAbknpT64GmRWR16NneBqz4UXG/mkEbrff7aN3AeyCKWc2qrXTXluYxHmiPU0lPhiNN5d+8kdcQTu+3kCgqNaIxkW4rreUdCt6bhQOhaEHN/n0NZmEWppbPhdE6kECn8eXtq7/ZkNm0pioGARSInI2LzGUD1foaD70sOw3m9fm8+swZkB4Mf6ju4BWIdCZuu6Ru2fieJkUxHaoR6radBpj/dbpEXsfIeNcpat9BfUb3B6CPC5R49Zt11MA+bdvE3oBMImx1D7+aSkCUPn7MB5Vw/ryMegVOSgwmw97prKS8WXkyA+8SWhPZVgMLo6sozbsyI+Wme7gL8376Oz+KIW4HUZSx2X7iK+eg/Tzkf/t86ZSndt0LcBHl1SwzlvJKS922tvPw9aEXGbZ/YhRwC/kDptKIZjwsnksGSuJ4iGpA9neOPBH2FM7AvtNWei2OK7PucTsvJ9ZOc5jP8gfw8lDQgrxeORJxgvkCnvOQocIAzqPz5eO9pEYmv0mko2GyDzWW6UqE5taJf+AE5XFmRQTRtL7HzLl4LIBScnSSq6WokdhjgA7NV2zMwKGa0V6G35UK1Gw1kCKqgY/BWQyybYKwIVToadoVyVG/QfhZXEIY5zY0gm7oDyRI40ERns8I0bm7GpUoqOVxQgnh2U5VfVvInhr3gl4D87ejT4M6Hp9Q2u0zeLd5n8JPzpTara7WCj5/LLNHw89HzD1A8uCM9J3LFjM0shdX8ftlVhccGJZD46Frp+ZobPUG8pN6DbzGiPZgsrb/1SUXa+Oj898r0hDhR/x+E1+U6Kqcr7KEGJg7BXmvT2KFY0i3bgHa1Nx0xsWtUPEI2NMO5qiwfTZsq5GLVHfWGo/bTFh3u9uEMw+7j3c7BgSJb7q/Lt4I6llqqGVWurXUVmCRBFnNCP+NyFM+DNfG3HYN/
 vKOkZ+Nf
 sEHhU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:14, libaokun@huaweicloud.com wrote:
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
>  fs/ext4/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index d97ce88d6e0a..cbf04b473ae7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2289,15 +2289,14 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>  	struct folio_batch fbatch;
>  	unsigned nr, i;
>  	struct inode *inode = mpd->inode;
> -	int bpp_bits = PAGE_SHIFT - inode->i_blkbits;
>  	pgoff_t start, end;
>  	ext4_lblk_t lblk;
>  	ext4_fsblk_t pblock;
>  	int err;
>  	bool map_bh = false;
>  
> -	start = mpd->map.m_lblk >> bpp_bits;
> -	end = (mpd->map.m_lblk + mpd->map.m_len - 1) >> bpp_bits;
> +	start = EXT4_LBLK_TO_P(inode, mpd->map.m_lblk);
> +	end = EXT4_LBLK_TO_P(inode, mpd->map.m_lblk + mpd->map.m_len - 1);
>  	pblock = mpd->map.m_pblk;
>  
>  	folio_batch_init(&fbatch);
> @@ -2308,7 +2307,7 @@ static int mpage_map_and_submit_buffers(struct mpage_da_data *mpd)
>  		for (i = 0; i < nr; i++) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			lblk = folio->index << bpp_bits;
> +			lblk = EXT4_P_TO_LBLK(inode, folio->index);
>  			err = mpage_process_folio(mpd, folio, &lblk, &pblock,
>  						 &map_bh);
>  			/*
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

