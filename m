Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A04C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030B46B009B; Mon, 31 Aug 2026 06:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23536B009D; Mon, 31 Aug 2026 06:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12F86B009E; Mon, 31 Aug 2026 06:08:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C15CB6B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:08:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5173A1C1CD7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:08:05 +0000 (UTC)
X-FDA: 85161138930.26.65EB324
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 461F5100008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:08:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aNRfX8vx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C2FBLfRx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="bYP23/Jw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HJyZzCAq;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=aH4Nn6sVBajjR74iQ4Hvf+AGT7uHNemHG0VdRn9DYMor7XRkYLC++R5U7d+Xm8Zr5N2AtY
	hkLmllXtCohB68Js/LP6LPDJ73wajbeXH92PvxdqrgsMsY+VCWSfIwraXgAkGwIbkyNV25
	eMSFDCYkMGKi/7qoG852iTTltbxpIWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170883;
	b=oJa3CopCfKAxv1atTeVB1GIZJbkE9sQb/VOMLpjKbh7mSk5HfrlSotrxHos2I48vgfBsqu
	kjMt1UJsrUindbeXeiEFQO5saxpmYdbcEaG0PVxI895p7lxORa0X/swyR41E1eYRfC4222
	r0moy1C54YrgJMhzsL85GRE4ohdN9vY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aNRfX8vx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C2FBLfRx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="bYP23/Jw";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HJyZzCAq;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D72481FB3C;
	Mon, 31 Aug 2026 10:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=aNRfX8vxxjM3odxsdfJV6wO0jG1NqkuTD9HoFNIODpmSWjCxeNfMdMYvhmzKQjujswSnS/
	rsw2myUH73slSIpAbHyQIpFfxod/SQ2iQvVYWJoq5Caq6Mw/C9sC61t5fOi17IYtnepOde
	7PSGZ/7EJG/gjRtw+IKV6ViVMkT9ZzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=C2FBLfRx5w0FhBlYmUEqJBJeiO+tYeVwOm3uAqGwG+EH4A/5oSH+COi7OpJf0RrTmcyy3Y
	+8lyiHRF5PTrfjCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=bYP23/JwEC8Iz5BXzI8ktYpWIGLxXVJ+2iWwruUdHZ9/LPZaqgfV59aDVFEPG5i3JOTaks
	2uIp7s/5M7c+SLxJsp+nlM5EyOiFQZtnegZ12+DPLgrtIOdAQeUPZb/CMSXHltIUiRLDts
	FI0VoUMNgmd+3o2uc4+mgVVrJDfjYtY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kgcS0o3Xgc0q06A194A0nwAi34yqPqnCWzQ7aKp6YgU=;
	b=HJyZzCAqmkoMNCvobtYJW6f9ASXIDXGTYKAyP3rU5YD/8sFndO8X/CKnGEI4bW/Uok/xuJ
	kiVj+Hpb5awsiaBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A253D13682;
	Mon, 31 Aug 2026 10:07:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vNCfJ3lSlWobeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:07:53 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 39461A13B5; Mon, 31 Aug 2026 12:07:45 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:07:45 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] nfs: Remove redundant FGP_NOFS
Message-ID: <qabnsbfd2jknm6g6h2jqlavbpxiem3f2rfu6lwozmlt264aknw@6vxajyigvkaz>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-5-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-5-willy@infradead.org>
X-Rspamd-Action: no action
X-Stat-Signature: 5iawfpiss7g7kpf87ois3hbxhmxqn9wd
X-Rspamd-Queue-Id: 461F5100008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788170883-749926
X-HE-Meta: U2FsdGVkX1/FTiEFyxpUL3YxUAyyLFM6QlZBgN0R+fK0PSey0o0P/RCLbTwooaR+jPgGLM3hpQQ2xwQ81WMwfBSzmTZpGEkS5QWYCvbF+q6YMqkddmKF3yaz4oDgrYyPHucRHIM6uWUAgcFNEEph0K7LEdl9yEbFJgRRvwW+csTI9+sW3FctBZGe7PlVceFjD5CWyPR9otPyyJl339pdUOW5R0HthNOrMQRDyz7gfzsSRdZjqqwwROlg9QW0MNMSpsed5U5k09hKRQV8wwT8kMtlwW8IRzNID7Vd2XZdbpL+nAuiLjh608bWEc1Xp+SlNSG8zsDEnQJLbHpwOUSglEy/RtyqlTLMsWSdPxhKSIZDMZrL8YqceB3VnI1WSPNJIjoKunoz5ibffWpxMf8DKTx2jFiSAeSOK7wnlvnk/yRE2sa6Ddo/Bvrn6XvCoZwL8wATe4JqmRcgVQHE+wsPQeZVyVWZMfv2/p4aIz2kh05iP9Dn26ahdHxreVHUzVzLuqMmkgfloN8+WTIrizyPHq/4ClTORZ2qPv/Gm86hNGkK86UJ7t5KuJGm7s9zd7ede5ajpTPZe1UXQB/jd8CrCAPrif8ooe70mWAJWKOLCylRKeucBywjVYLlMaAQcYvefJKb6wmFCsaFI7G8oNj+KYHRVIckDaiRBVxXsU+jpNYyiYAWzGQgnx64x/hVUwEeQTZ7Z43WLCi2DUI9Qn8IEuvUBXRLja1nX8CWIkN7qXzkyWhxoJ19+y0vGS5YK83howGtKSzDDVNPXJp/usJtN/oyHOnVd1OtxihVpoN68FTzAGNpsaaCQ7mbgC0Y8CbIoeHU27/XUJHB1makbD6YlU2FqXtrfa1ih9qz+NQhMd6HEtBzgC3ooVNW0/vkAhwnOnpCA05C9pXS/yUzWgxh7UMGvfACakrXy+XFmg2Sui0Tmj5K8xr905xl+WIapaS2r70H86sgvd4hOxvIEqL
 r1wbRI6A
 i0oDBFvHhI3b8wJaJm+5Pwt6CI8IJn3F4eXxahkbxDyWNhyAvr+vkHgHSfNCMsDBuPH9lg2H2z3XllOJCJF90hAwCLq11OpwJWKod2DSgnDgubYLeJW9R9YSY5lvmSmSi0rA2xJw7NudT53l+3LvYsuII0hgWlGZ5V97NZJmXh9aqm+DMBiiUH3h3om3GLS2N9KIwORsJ7N+jRqlZNLea20/Wsf7zRzpiO9Z7D9BJ9bmNmcEGXYNhof8vhjJVg+z8/bWqj+3dk4W4M6aDuoZPg7QUFAkyrSSHseQ3daB5im8K0Z7R7g5bW59fZlmln4ixHus5ZSJmypsiXZ0o9e78T7gz5a4h0UbNlvY2jPp+vbTOSTtjZOUoYlLpZH8+73Ydr6xIfDts3RiJ7UI2+MV0Xm6Vo79aWAzmOwy+KaiXVpPE2SecoP8M2Hy8wZ+1IHLvfOenak77XJnl0jG7QnXXQ7Jw3M4Yn3OmTom3a7N2QXS4sch5SUBoZJH9Jtjgwpj2Cois7T8jJmcPiZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:51, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Obvious enough :) feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/nfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 49394123bd09..e34125a8a2e2 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -447,7 +447,7 @@ static struct folio *nfs_readdir_folio_get_next(struct address_space *mapping,
>  	struct folio *folio;
>  
>  	folio = __filemap_get_folio(mapping, index,
> -			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
> +			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
>  			mapping_gfp_mask(mapping));
>  	if (IS_ERR(folio))
>  		return NULL;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

