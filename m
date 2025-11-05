Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FFDECCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8216D8E0018; Wed,  5 Nov 2025 04:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D12D8E0008; Wed,  5 Nov 2025 04:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A478E0018; Wed,  5 Nov 2025 04:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 500BD8E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:28:07 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF150160255
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:28:06 +0000 (UTC)
X-FDA: 84076026972.19.2D90389
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id E8FD22000C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:28:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcKn8+v3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/GfKYWd";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcKn8+v3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/GfKYWd";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eiK/n4EgZp2ORAGmnfzTUx8SD4Z3Zzb4q6XlQaVRjg=;
	b=jGE0wUq0kiyI/4bRbXAx24p3+prwiiVsseJe3Juh2FmUMQZlCyR05PviWyvvLfSSO5huSU
	/260hrivCA7jpTqP92Nuo051rACE3fex6uV1Dfsn8t9Tt5ngiZlbp3+hT0lnjdfoQRX1Du
	xzW+suDI8MK/v86c1nHA8JLJxggTdbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334885; a=rsa-sha256;
	cv=none;
	b=7bGXaj4Ja5Rb0RypD5cYlGnI0n39UhS6CaqFdrV0Kz1zio+fe0mOuMBBukqOrkKrkJJKW0
	ao9X6EyJ5YWdNOPp3EHDhnbkizq5z08AaHPZ/m03SZiZ/91zAct1BYxKN4SZ8wbhK7rSjP
	+gVdLU5zUtE4Acu0qUcyQVU4balo4rY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcKn8+v3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/GfKYWd";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pcKn8+v3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/GfKYWd";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7AE0921182;
	Wed,  5 Nov 2025 09:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eiK/n4EgZp2ORAGmnfzTUx8SD4Z3Zzb4q6XlQaVRjg=;
	b=pcKn8+v3WOaCh6LJf36XqWId7sz0FkZNc9S9M1xluLF49a4ZTDLPmM2FaiFarkOyDtJ6ld
	D75o7kjx+lCzgDN/hpSjyLtB9yeAv4G5npKqzzvHh4EvyCADFRAWR28S4fE1SWZQGk1QV8
	pGYDm+MJT0p4ya4aQiKDkhbfXpgGLQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eiK/n4EgZp2ORAGmnfzTUx8SD4Z3Zzb4q6XlQaVRjg=;
	b=V/GfKYWdyvA3hKkw8/iYaA6f+2rAQ8Axn3PMphVuZwBYDuMz5rj3jJwaODUgQQIKTJ2zkp
	scrSoQdINNac4iCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334883; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eiK/n4EgZp2ORAGmnfzTUx8SD4Z3Zzb4q6XlQaVRjg=;
	b=pcKn8+v3WOaCh6LJf36XqWId7sz0FkZNc9S9M1xluLF49a4ZTDLPmM2FaiFarkOyDtJ6ld
	D75o7kjx+lCzgDN/hpSjyLtB9yeAv4G5npKqzzvHh4EvyCADFRAWR28S4fE1SWZQGk1QV8
	pGYDm+MJT0p4ya4aQiKDkhbfXpgGLQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334883;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9eiK/n4EgZp2ORAGmnfzTUx8SD4Z3Zzb4q6XlQaVRjg=;
	b=V/GfKYWdyvA3hKkw8/iYaA6f+2rAQ8Axn3PMphVuZwBYDuMz5rj3jJwaODUgQQIKTJ2zkp
	scrSoQdINNac4iCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7125F132DD;
	Wed,  5 Nov 2025 09:28:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PUmeG6MYC2kpGwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:28:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3B95DA083B; Wed,  5 Nov 2025 10:28:03 +0100 (CET)
Date: Wed, 5 Nov 2025 10:28:03 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 17/25] ext4: support large block size in
 ext4_block_write_begin()
Message-ID: <5p7pwuf2zjf7feneef57gvxc2pa46l346igllimpdvvtnrv6v3@js75oockzrgw>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-18-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-18-libaokun@huaweicloud.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E8FD22000C
X-Stat-Signature: mjpzboysrsekycamw5b3y7ggprn9oi6b
X-HE-Tag: 1762334884-165880
X-HE-Meta: U2FsdGVkX18PrCOJzSA2PGMLqPLm44tqr0zJXCIexLV+sQdBB+aK6pIhuMgFNUn1y2eJ9FMYtJp0TcXLMvYD5LXxgAoDyPC2BSKspMm2qXX9gc81AXUj4xMygaDcP8GfRnaOlnhCWzuWYDbXq1QGN01HPgHUnad81FrpExgu81K5RtdrYW4EPy61YhyugNUnfGoZFXl4p+3H/FP8pSVEFg+YXWF2V01hoezkHM77/BSJTWq6YforlhBNnzB/tm/X10bDllHJHK9yZw98xR4gga6W+xCrlNqk3fz0ZFE9AUekfvAMcmlobDWte6W0Qysi+4ZbYodWRWfUa3r2sQ7b5bVOyeAefYjd5VOQrzX/mGfSBMs2b3siUBShiEfX/Y7fT89zoZvZ7PYQmlrucOfTyl52blhd0/xT0ZPrTW8MYehrm2B5/+aW3rTDQfIDC+mIWqxlOQpr8N7hJftswfs51LjSXVjTc5FuqCMyty/JKPNiYn5/6cS5Jtm1W7gBVydWaZXiSGrjY1xXBNQJBU+aXO7MFAt/ggx2BAJHzjU6qwHm87/KsJwdQppEPIywsL+zFyYkUT7LNWMlAcwAzxgthIHA2DbcCDNBbouyEaiGa2jS3S4Q6wHgfRaR++O/1LU73f4EAwsVWEgF6ZafBPj6d5+KSLxuKGtBXXws3f1dlSWNUTBO9lmH72uRS3K92DFRpq/gAexwo1088kjux142ganGByagIU3a8p7PExN1jC6Wb07xowZMkK6BM7NSTgmHaU7UFJtUrQOJyHXNEUidljqKJoupasPeOAMyqXSyifRMBOSjCDXbZvL47UWQzILb22Dp+twv6sH1TisSaV4Q/tvW1xaBplHsZXn2V6nv4Nfrw11jsIPGGVeJ0WY66vL5OFZxQrOArJvB+uWEsDWfNRcGXF3ZdIcsnuLkVuegzYDmJtp4Fs/+XRdBdWBtXqj8UKK2W83Qm6qCxdZ7vaf
 UTmz59FT
 8gwLr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:13, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> Use the EXT4_P_TO_LBLK() macro to convert folio indexes to blocks to avoid
> negative left shifts after supporting blocksize greater than PAGE_SIZE.
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
> index 73c1da90b604..d97ce88d6e0a 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -1162,8 +1162,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  	unsigned block_start, block_end;
>  	sector_t block;
>  	int err = 0;
> -	unsigned blocksize = inode->i_sb->s_blocksize;
> -	unsigned bbits;
> +	unsigned int blocksize = i_blocksize(inode);
>  	struct buffer_head *bh, *head, *wait[2];
>  	int nr_wait = 0;
>  	int i;
> @@ -1172,12 +1171,12 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
>  	BUG_ON(!folio_test_locked(folio));
>  	BUG_ON(to > folio_size(folio));
>  	BUG_ON(from > to);
> +	WARN_ON_ONCE(blocksize > folio_size(folio));
>  
>  	head = folio_buffers(folio);
>  	if (!head)
>  		head = create_empty_buffers(folio, blocksize, 0);
> -	bbits = ilog2(blocksize);
> -	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
> +	block = EXT4_P_TO_LBLK(inode, folio->index);
>  
>  	for (bh = head, block_start = 0; bh != head || !block_start;
>  	    block++, block_start = block_end, bh = bh->b_this_page) {
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

