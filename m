Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C563ACCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:41:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16EE8E0026; Mon,  3 Nov 2025 02:41:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF4F8E0015; Mon,  3 Nov 2025 02:41:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05458E0026; Mon,  3 Nov 2025 02:41:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 991C08E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:41:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 321DDBC82A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:41:47 +0000 (UTC)
X-FDA: 84068501454.29.ED92A03
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id C7D394000A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:41:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Fco/1o4Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=36nnXm7N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nz0e0JhF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ruSI0m/z";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762155705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uf4jQTpB9VGe8rGSo1CupspYWZxA+nV5Rkk/NcNgaTk=;
	b=HlHd/IfSn/bILB6sbXSvqEU4Tpyifsee7bOtIFylTltZdPMiHwGIivUUCxKg8I7njX2/LS
	lhmR3msACbq+7g6AW1nBRdr4T+xJuHTWk33QJqiT7DIUprIEmicSaJX9dEzmgyP7ovnv2y
	unXgA26gdRSJNilsRME/VI1wGdzKEts=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Fco/1o4Y";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=36nnXm7N;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nz0e0JhF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ruSI0m/z";
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762155705; a=rsa-sha256;
	cv=none;
	b=3k2hk6DDJXMAg74n/CyqbTCPxL+ZAt3kWw7Lfm6rU6A4f/SPKFUpkIiIv6623G76/P3uBP
	+fWY1nWBYIhp1vx/bLqhd2vDbiXVNhlLsCRuqbgxt+qJ412V5boloQdili044VDw/AdTYG
	fhsFnGRz3nb57S8CA1qkp4IkF3yQFuI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D309D1F787;
	Mon,  3 Nov 2025 07:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf4jQTpB9VGe8rGSo1CupspYWZxA+nV5Rkk/NcNgaTk=;
	b=Fco/1o4YyB8iS5bcU70L/XwLCQmi7qhWcwRKdn0IP7ikTW2SnYYMejZHOhFOlJkj2aqbYv
	7Og4UdFt3FYyg0RAaJiJd87MyeKJqIMGRah3xgjwru1mrFcbM71/MRFI61T4CNKbQ/sX/a
	tExDc26+tFJuMH/kJjt8STWfE9jf66s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf4jQTpB9VGe8rGSo1CupspYWZxA+nV5Rkk/NcNgaTk=;
	b=36nnXm7NdXBObt6o7MmXBreIjaTra9Fc9Esd6P/Sn6DNWcwYHVi8j93/BIkgjqD+wt54Zp
	zJn9a7o979ZCSOAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762155702; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf4jQTpB9VGe8rGSo1CupspYWZxA+nV5Rkk/NcNgaTk=;
	b=nz0e0JhFowNrzf/aSLze8jAtlvEedLy3sCYQJeKOvmoebvnHAa0rrjsHlx4/ew7ybr+Hus
	DaS7mMAkVoD6YCAlLaA0sqopXJS8OVwxLjz1cDgKMnO9Hhgwt88xOvdli9dLflEd33tppW
	k14iL1q7Be1O1sFP4KIK6EZX/kj7JAc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762155702;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uf4jQTpB9VGe8rGSo1CupspYWZxA+nV5Rkk/NcNgaTk=;
	b=ruSI0m/zQZfLi+kTpwut7bmbwxLnOc9AATOzXEy5HyIzV774iyAoJsuyYLIBARDgakIh0N
	CJXb55htoN3cmbAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B7B4813A88;
	Mon,  3 Nov 2025 07:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F6rPLLZcCGlVQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 07:41:42 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 24BF0A2A61; Mon,  3 Nov 2025 08:41:42 +0100 (CET)
Date: Mon, 3 Nov 2025 08:41:42 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 01/25] ext4: remove page offset calculation in
 ext4_block_zero_page_range()
Message-ID: <w7dawsu3tli23h6ezt4u7evprczgbezylnbyh3sqhv5rfimg4q@5vqelz5hsev6>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-2-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-2-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7D394000A
X-Stat-Signature: wnjm8sjrc5qh1tfttxh39g39xipa49s3
X-Rspam-User: 
X-HE-Tag: 1762155704-567449
X-HE-Meta: U2FsdGVkX186/eQXtUh4bJ4qlzNzkp0pr0l0Zw9XecqLbdGdGJZtDVryB8lh9Ky+zh8dxhjWViFIi94Jmtiyq9kVU83CA8CyrZipzuaz++3CpdttS4l3FFV8mSEWHYEQ0ShwTJFnxT4v7P4j393yBDhkh9Nuab7CDGZDH15hX6Pl+ntub2P0mElSMzqAgycUrpVwcAvSQtP1E/4JlHwbq9/nW2b7zUW8UkE8x/5mTenBW8nSjaTkoWbSlJAuUqDv91h5BWwIAzT9CwIe3aQAJ9kKXpyFMz1OiSWRys02O/ZBitk8q99hvB4G56cZ0Wgm2MgxmnZa94AKg1Qx5owqPfAUf5j3i8I/5BQDurq8OB013H+jIwPWuutm21q5SRKV4geYEb6jIDIMS2b4cuOShdoZpRZ7P3kcbu5N3g7Ns72Jqg54h6Pb+BGV74pH9ZOWLEBCLKmLu8qhNiBh4gdxUq9PdVARfxgup2M9dkOtgFp3nhy4phkXt9dmyHG1aU8F4olMfMnyuIOrJs3DyQRDxajpqTzWjtWy4qY/Hz1WEB08cUcMJDhW2oMKFCqipwF1G5+GIMVPvj8pudE/dJLveOBiMTN5shzYsNSwiNitA3Y2XH3dmhAeLW9K7RwdONGm9GYAvlrye5fqN9YrMkzGuJgWI92HaT6HUTy+NJTsRfbLUR0w8ovG7SNCevMhTmCatSlHQ5uHLIC2/FGGuNQQIRBStNpwf8jrkNNV9uDXQcGTYq5QSUmHJNiUa3IFADxZ32SwNw4s2wjtB7yIAWQRZ3rm31xA1xMkMmLg4CbPyOsGF83Lm6ObJpNx2xD6FKXrWwMWbpUwZ/0ymwnRQcKdXr61PJ5YGw1U5fFU63V91iGFb4TTma3hVSZUCjNZmF3D7X+ZZIaP4o1/XI5GsZL2eghLYUlvmAsvy6rcTf8jxfN4YqRJn5b58pVuDmce/rq4CkRXN8a6+uLe2ek3Lz9
 7eCEObQ8
 hLgRTWW8nHr4BygjvxDMRUsoymxDb8Cb/VeKLD/jxWtKgKlHHgVF/+GXzHdD6GnFildgPG56ghqtuEessk2pbs8TqO1vexGGyriLkoIyij/qhWEHYS1yEpjc3DpsOeqfkxs5b6r0sEGOiOBh0RExRxBw+c/xjoK5k2DMA4Ni7NqeiY4y9fvIXMhft9i84QiuetSsm/lE6KP58FXNhZ2QQbvukTl9jwAPPkOKFejuRkBgcVhLaIHIyCZHe+3HJ43A8In6rWjNbDtW7oh1bYaJMga6QKiFKy+ybpgdiEn+lh48/aXhew9pfVkq+5rfRkqQpjJSZ1Yt+YQSTTs5KG/rHrxcQsKfFqssS/J6ssCOHAV5PIw9b3nZp/ZqlgBYoYgPT7iopJS/8jSy566acNv623iEyro8fwqk8BNrhji2TYgITX8us00nwAZO4gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:21:57, libaokun@huaweicloud.com wrote:
> From: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> For bs <= ps scenarios, calculating the offset within the block is
> sufficient. For bs > ps, an initial page offset calculation can lead to
> incorrect behavior. Thus this redundant calculation has been removed.
> 
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index e99306a8f47c..0742039c53a7 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4157,9 +4157,8 @@ static int ext4_block_zero_page_range(handle_t *handle,
>  		struct address_space *mapping, loff_t from, loff_t length)
>  {
>  	struct inode *inode = mapping->host;
> -	unsigned offset = from & (PAGE_SIZE-1);
>  	unsigned blocksize = inode->i_sb->s_blocksize;
> -	unsigned max = blocksize - (offset & (blocksize - 1));
> +	unsigned int max = blocksize - (from & (blocksize - 1));
>  
>  	/*
>  	 * correct length if it does not fall between
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

