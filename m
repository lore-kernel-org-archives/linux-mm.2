Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9F4C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39396B0092; Mon, 31 Aug 2026 06:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10876B0096; Mon, 31 Aug 2026 06:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A3B6B009B; Mon, 31 Aug 2026 06:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9558C6B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:07:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F3AECA0433
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:07:22 +0000 (UTC)
X-FDA: 85161137124.19.029AB53
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF9C016000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:07:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ibv5f5Gl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qVXsQE1U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GMxYCD3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0qmeRH23;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170841;
	b=wJJus4GbcKmXZqCN38iNgZqWyjVcmJYYG8FyF81aBbbhMHjKvx2k8JI226xgz5nkpMQiNh
	CHXF1txEzYssf0p8IlIkNoTTTDq5WWmPpMmfmsbhAD0mbZUmi0L6ONjEZVccDbgI2vZYjq
	evGbOYlk8f48/171AyvKJgUXkHmriZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRhEETd/QD3arS4AOP9puZWciLjCr9/ZkGT0N1D6mXg=;
	b=WlQIoKrosI9xAWtte+CY2zDhpPXuO9NYw1zoniVWp/BTu0PPnySbH/63Jglxj6pfJr0AqE
	rebaIwPSSoYa7gNKPM3KIcJO8INXdsUdVS81JNWQ4nFykRe25EdWy4mlsi69YSfz7mIiiD
	3a++P3/Ry3R7Sz64W2WztFBL5LhgmrI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ibv5f5Gl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qVXsQE1U;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GMxYCD3L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0qmeRH23;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 82F5321D5F;
	Mon, 31 Aug 2026 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170835; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VRhEETd/QD3arS4AOP9puZWciLjCr9/ZkGT0N1D6mXg=;
	b=ibv5f5GlLRKMz1Uhp6ulwWFEwjSQYiYK/DTmaEf5F2HTF0I2hlRJJ7vvrYrGocoE5NVFQv
	+pwEe02AgQ0D3AFo2YEMYj6ykews73rfx4vOzlzNmkVVyzzMeU/ASgPpYNo7Lt3WuEhZn0
	ThY6cAelEbb9m+PuLKSBCPkNy8xpVgI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170835;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VRhEETd/QD3arS4AOP9puZWciLjCr9/ZkGT0N1D6mXg=;
	b=qVXsQE1UY3HnYN02bCfPHOEbsIQuIww49jcY36/Hve7xmVaOdTIEUIcImh59T6iGkPPyJo
	F0a5uwbQJ8jM8zCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VRhEETd/QD3arS4AOP9puZWciLjCr9/ZkGT0N1D6mXg=;
	b=GMxYCD3LSTusC10mpBMhUNPSuLBDpLNxsHzlBwwrSQtH3lXKtNnD7WY4Amv8RowU98YNcY
	rl40zgPVkDdvBgE31dedH3H2n3gl+M15EZ9ruGd05GuhxMgY+P45QFfou5wgSUC4IJFSYf
	JYZFZ7F4kFMHGUdzr+V3yCufVP0J4YY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170831;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VRhEETd/QD3arS4AOP9puZWciLjCr9/ZkGT0N1D6mXg=;
	b=0qmeRH239q3ahdU5C6vsri2MusHZcu1kMZz77o3qn7wT51bUKpOcKeK2sgmd5SuJcIZrnM
	YkAivvxBlASrBJCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6322713515;
	Mon, 31 Aug 2026 10:07:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PRAzGE9SlWpgeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:07:11 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 128EAA13B5; Mon, 31 Aug 2026 12:07:11 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:07:11 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 9/9] filemap: Remove FGP_NOFS
Message-ID: <6vnditkfrebo7ylr6g33kvzefn4iahstd3hlzzjvtcfk36dffq@zw4akv7ga6az>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-10-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-10-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF9C016000B
X-Stat-Signature: xxr9qndfi4hzw9bq47gfoi187b68p9sg
X-HE-Tag: 1788170840-270738
X-HE-Meta: U2FsdGVkX1/Ysufb5AFiv7hH0zU6YhFqWqrwA6/+f6uGDNIfwMHGOvFZEbKyv1EEsGhi3XZm21kAQxkZF37Iig2UvLDPF9AXGvRqlrv+ek5QL0G3a0QkhJYZeoo9Pft0P63r0baw6ztDx8ZJlYqT04ll3RPfQOHSP/L8Z9y7q6kebZJRPddijK43SoGywzrFtOz/GUgJz+1HFzK2hYefDOl4E/aUI38NIuo9Z/zaZ9dlhtrNXI3bMNRGMCZpjYMxeZZrtYmIW1peLqy80T4mBXmn9wkFpCLch3U6FHTD8DBEYucIwRbyvqqlhBh7XXDnO/otxhX2gC7GVJhiML+3GL3I47kYDuUsd3SF0B4sAVDOxWNIyDTj0USu138hU5eoUc5VYjk3hQPGlIoQjwnLNOEYw4mCLxaJM4Prgzfk5t6+dutRLOl3JlDhpdX9ligeW2jT3V+IHObJUzdjtAMIl8hbHW8IEfgY8HA07PM4OiK2P7E+PIY04Xn+AvcU0YxBm4rWYuA0qIu/X5YN8d5xyzLjpUALteAMPqtXPL6eDtTflVphvvPl/vcqrkDYjgm1ne8phxbSf6YbG/acX/ZYAu54jxWI7xmSIUqFMqXzcErUA7N3XNhM7LQncY/ID0zaOFGQuC454x35ZatmHSW88g1yrmG1vWDjTUBmZFmdbVPmDSUQM8ld4pokYz+ZUuk/L5WDN48Vqh9ZY+dYsMAcStHr5/pCto+NwHUCfjnG+76HxyoXQ3RbjMp09W2DAjYJmHBjMFIwe4lKQiuH3b8Md2TAkow0Lm37ucPnpTG4BteEsbNU7yD0bVlLZTgxQiR819yb8asaKnAxcVO7McVLIWRmceVG2JVNmL4QBgcY/R0sYJijuqPLaK+yaJJptZI6RvWs7pjmjTXdIq0/iOL7Agi04gRMxCFMjwYo3legTLkturfrRe1Rgn6BcvYEYVTMgNTZb29bWtDwpn5sPOu
 w6rZ48qW
 3JRLv/Qt2UeK6tJxmTAhdmDKoFIif9IIksSojHKry3wqe+2YY9FoDji24UMPV2huigvUs+wZBs3FIlOm9hLjIFJWXjpTGk2cx1tzP3XZ9BoK73UTyiJev0q6TgEY1OOa7qyRzL6drv7kImRazAn2dWgt3YaW22se4vC6VZY5Je/UOLuuYDB5kQDgc+roEmhpXE6r59yWNaNx2bU5BVMo2eBA67mll9cUnnVArPjWPXVqSK8XqOHUTAKsgbwB+dS/5cKlPcGrzCIciRv47BnDXsft3XVPUUV5xtKy1v+hfX7AazBIIPoYidlpS+7BX66akCppHQAfgSfbWXhGDE/c13IJVVY3BLq0OaEKu8vSoCr2e1bRRLz+n9lEktH+OLBdwWPS9Iq+oygQ795H6O5hv9ni18P0Cul66jSSuyw5f7G4ZF7BeoUXl+2H8fvSzKBV7eaXj3RlFrmy9t9NxeSvQbw3fcribgiNSO8O1c0cOC1ro7rekBszOJLxYB9PGkC9UmzKufA/d07Q00g0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:56, Matthew Wilcox (Oracle) wrote:
> There are no more users of FGP_NOFS.  Remove it.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/pagemap.h | 10 ++++------
>  mm/filemap.c            |  2 --
>  2 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 3974b063a049..bff8b7264fb0 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -697,7 +697,6 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
>   *   folio is already in cache.  If the folio was allocated, unlock it
>   *   before returning so the caller can do the same dance.
>   * * %FGP_WRITE - The folio will be written to by the caller.
> - * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
>   * * %FGP_NOWAIT - Don't block on the folio lock.
>   * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
>   * * %FGP_DONTCACHE - Uncached buffered IO
> @@ -710,11 +709,10 @@ typedef unsigned int __bitwise fgf_t;
>  #define FGP_LOCK		((__force fgf_t)0x00000002)
>  #define FGP_CREAT		((__force fgf_t)0x00000004)
>  #define FGP_WRITE		((__force fgf_t)0x00000008)
> -#define FGP_NOFS		((__force fgf_t)0x00000010)
> -#define FGP_NOWAIT		((__force fgf_t)0x00000020)
> -#define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
> -#define FGP_STABLE		((__force fgf_t)0x00000080)
> -#define FGP_DONTCACHE		((__force fgf_t)0x00000100)
> +#define FGP_NOWAIT		((__force fgf_t)0x00000010)
> +#define FGP_FOR_MMAP		((__force fgf_t)0x00000020)
> +#define FGP_STABLE		((__force fgf_t)0x00000040)
> +#define FGP_DONTCACHE		((__force fgf_t)0x00000080)
>  #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
>  
>  #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6afec636881f..e6580291f218 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1994,8 +1994,6 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
>  
>  		if ((fgp_flags & FGP_WRITE) && mapping_can_writeback(mapping))
>  			gfp |= __GFP_WRITE;
> -		if (fgp_flags & FGP_NOFS)
> -			gfp &= ~__GFP_FS;
>  		if (fgp_flags & FGP_NOWAIT) {
>  			gfp &= ~GFP_KERNEL;
>  			gfp |= GFP_NOWAIT;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

