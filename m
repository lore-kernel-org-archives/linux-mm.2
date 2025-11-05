Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FA9CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0778E000B; Wed,  5 Nov 2025 04:26:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29A98E0008; Wed,  5 Nov 2025 04:26:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAAF8E000B; Wed,  5 Nov 2025 04:26:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 885F28E0008
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:26:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AC4E13A085
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:26:48 +0000 (UTC)
X-FDA: 84076023696.10.A2CE3E4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id A1E4B100017
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:26:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9tYzCnF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V8/edqQ4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a2GTD0gV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qXaS4806;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762334806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=li6o80IDGYsi/HbFc5gcJrYIZ6xt1ndrYA5Yrhm9wNM=;
	b=Ki+SJ9o0/urYyQnw47cLCmPvwNmAS5YRfYWbvE9FKA+a3AXE9yKYrZ7klKOM/qGS+2/aGj
	SzCLe7N76qN67AA5GT/evJ84T2dBndZvAJUtJkVq/U581g42Nca6PE+E4+BGiazKaoSjXb
	c+Guyoj+aQ3aDFwwtC7fInJSlA1cIoc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762334806; a=rsa-sha256;
	cv=none;
	b=qy7OP14xtTriIspqVeyNiQuoVzFZK0NMS4cZDMeAwobRvSr47YUVWKAEhe/DiJDaTJqTvr
	pJUtJH2lvu+xxDp/Y2v54NjL+unSRikkQHx044JiFcpIGtr889EcsQu50BaYT+lOYNCaXW
	1nyumrUWvsDtjFRKCo3xCwOi/cmQhWg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L9tYzCnF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V8/edqQ4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=a2GTD0gV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qXaS4806;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1435021188;
	Wed,  5 Nov 2025 09:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334804; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=li6o80IDGYsi/HbFc5gcJrYIZ6xt1ndrYA5Yrhm9wNM=;
	b=L9tYzCnFnPxMFuFnOfQRCTNTtEyMVQOdkUn+7rLE2UtBCcgYApNO7kUwOkaSzFkAs9fbWX
	964rhJRj5yIOXynF6JT64L3PtB+cspGGo4RcpfBq3sWR6ecTtuY4girAmeXOLX6TtOq4Vh
	CEcAGYDAaKZM+TIG1DOW6P6FDz006Eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334804;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=li6o80IDGYsi/HbFc5gcJrYIZ6xt1ndrYA5Yrhm9wNM=;
	b=V8/edqQ4VYHBV3+J/0iSOO02dNdLpMV2fSfXdDwrCTDjabtF1W5I7gxFonx995PwgeLR25
	sTstR3kE12ZLp3CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762334803; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=li6o80IDGYsi/HbFc5gcJrYIZ6xt1ndrYA5Yrhm9wNM=;
	b=a2GTD0gV0mhZgLZteeOUH4zQxnnXtQbZDxi7zdllqLOtx5VQGvPPU9nUvVsiONPPSqFPTr
	ZFQhfmuur98C5FER/YijuSEk/hNFtqpSeUoA1cttZQ/iB9Txtrirhl+WgBnJXZItaEDv8T
	sLJJEhLrTLWvh0rOXg1Lh1z9lgaHrjw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762334803;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=li6o80IDGYsi/HbFc5gcJrYIZ6xt1ndrYA5Yrhm9wNM=;
	b=qXaS4806tt+tAI2XoSRPECl8tFg0HBvPluO4XJm0TKioJkPUJ7nSG9G2QydtTvidgBS1Em
	oMV8YsNRY3Pb6OCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08375132DD;
	Wed,  5 Nov 2025 09:26:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AksAAlMYC2nRGQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Nov 2025 09:26:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AE55FA083B; Wed,  5 Nov 2025 10:26:42 +0100 (CET)
Date: Wed, 5 Nov 2025 10:26:42 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 16/25] ext4: support large block size in
 ext4_mpage_readpages()
Message-ID: <svvbzbdnlvd5bvcbale6xe2qtdaf4ddr3rlrphqv3spcy6dxpt@cynxzantfcmu>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-17-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-17-libaokun@huaweicloud.com>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A1E4B100017
X-Stat-Signature: o8x4go6wpiyqmnf61nhxsmos9mnt6ga5
X-HE-Tag: 1762334805-428477
X-HE-Meta: U2FsdGVkX194rikJMwsUOyz3/i5vRzgrAzqwmorTTcIRXmQ1pihtreYvMy0AmD5f/7rxvR7wR26F6Q7ODZUaxhqmj0+Kdep73CoYa+DIIK/9lGrBNsR917JDPkMoz31RCqUdYB0tUZK4Zjs591uDtZBdacG/7RhokcrMyfhhhvTn0ffonwWbXSsxo9hq9K3/3BfmXLavAdWFpfdhCyBXGAXcu60OPmv51+9QE7MVuW0mZEa0BPluukHPQFtO5P9bScZ1OIl7pgqtY/1S8FDdukD59wRqDgiIqgTtdjXF1yJMd1TCkgsBSwJLLnfHwyPtILU2ODVjVuSAYh1MzIIqtM7hMgx2I83UoSHF00lOy4xRCLEw0rpqtcIInf5qlDlRhu1EJ62CNbeG1/ntXPQu+F/vS4Ekf+oD/eTPh17rh8nh+EDefUuab/HwprRY7UjnhNU58cE1aiQTnhjANqV5BBy8/tn7qOZllaSdKQF2MK3cYIGmKiExgHhmGhbG1rKT277Y/9rMAuL7R2tCNZJC6QsJSH2PGu4RvYPlBhifHt+LRyFgOwDUeguvhZwMQYl8qZRpu5SqHydTcIwtlzFZXmLwOOsl64mcF2HmnU+tNDVhsdeQv4Jkn7NtNLTPRHeP2xhSncs1eqa0TWXBQE8luU+41NnB6gDIc9liqUGE8vYZenbhEBe+G8v5cfPbvBB4q2vaI3xeeDz4HzT1MCAYuJerpOhuIjmJ/BsDeDXz5sO5c0qKBqfcX+u6zpvh0ofPb/Rvp8QjzfNe708y2BvqCGJIzq/7/s0gn5TO2Rrf87dS87kOfK/czLctpKODvZLN1nb71Q5BJM7jLegqdbePv8A7f2ufVoCkTjNTjWIgtCJtBGqzoRpltB4DJOjipBgQmJSXOQ+W4wozefaOSd8E2/OnAB8Vba+nvFEDp7qvaVs/CijslnxnAMYocy051C1xbCaMPVetXkxrXFXTdkf
 XgeTmk1U
 7oK4GPRX0td8StJDO65c8bYTyi4R+HGDjvwMQ5sJ7lLvQv1i3QXOx3ok/+LjtzTmHvfv8jEWXi4w178YVHH5AdarIc/jyi9DjKl0EesPrxazabP/pzwHAEur+f6j9wNqfKLh9IQY1Ov+mEG6/YRmO6V5Kx0jKdGHgOOGsSGSEGGrVPsMszlp6G75fTGv+9YSUIJ4hJ0n9LawkXFp9XtwE6jU3iuTr77Tg9XE9lsp+E1fkFjtzxDJy0Wzv6+3qGrqtTrbTxtfnqvNYfzvlGlf70s+kpvxedM/w3xYWI4yPiKNTEbDyN1vjI/bVHOgxaqbNo7qoAC9FRwFtTWTLjiQEhI/l1T+TKxWWhogW262IMty6Uvi8o7sxKHPPmCOfHei9FarIie9pFdJQlqmRKx3NumYfSeQPOgzoDvI0cIF+Bn5OuAcLTBUUbWBZXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:12, libaokun@huaweicloud.com wrote:
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
>  fs/ext4/readpage.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
> index f329daf6e5c7..8c8ec9d60b90 100644
> --- a/fs/ext4/readpage.c
> +++ b/fs/ext4/readpage.c
> @@ -213,9 +213,7 @@ int ext4_mpage_readpages(struct inode *inode,
>  {
>  	struct bio *bio = NULL;
>  	sector_t last_block_in_bio = 0;
> -
>  	const unsigned blkbits = inode->i_blkbits;
> -	const unsigned blocks_per_page = PAGE_SIZE >> blkbits;
>  	const unsigned blocksize = 1 << blkbits;
>  	sector_t next_block;
>  	sector_t block_in_file;
> @@ -251,9 +249,8 @@ int ext4_mpage_readpages(struct inode *inode,
>  
>  		blocks_per_folio = folio_size(folio) >> blkbits;
>  		first_hole = blocks_per_folio;
> -		block_in_file = next_block =
> -			(sector_t)folio->index << (PAGE_SHIFT - blkbits);
> -		last_block = block_in_file + nr_pages * blocks_per_page;
> +		block_in_file = next_block = EXT4_P_TO_LBLK(inode, folio->index);
> +		last_block = EXT4_P_TO_LBLK(inode, folio->index + nr_pages);
>  		last_block_in_file = (ext4_readpage_limit(inode) +
>  				      blocksize - 1) >> blkbits;
>  		if (last_block > last_block_in_file)
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

