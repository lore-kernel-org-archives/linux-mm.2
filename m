Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F8F0E7E0C4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A846B0005; Mon,  9 Feb 2026 05:56:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04F56B0088; Mon,  9 Feb 2026 05:56:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6856B0089; Mon,  9 Feb 2026 05:56:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4ED6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:56:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37C445AA6A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:56:13 +0000 (UTC)
X-FDA: 84424613826.13.2DB0D54
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id E59A54000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:56:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLdLbtbl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i2ScIvsM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLdLbtbl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i2ScIvsM;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770634571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bipua3Ir60MfzXCM9F8PX40hI/RZj553n1aw8TfsLp4=;
	b=jC+CQz2UlcfpAZVAtoo86nSa0DXSdeouLi+ZgjsvTr0xwkMNOYSoKujR0bzFWl7yh96T2n
	vS5bW2x7S1Sn7wQRA3BgHgujKpUSCugT7CH1o/lB9S5zuiEk8rUkw1/w7YUF6FAWNX4+aW
	6vZOUIcb+tGtOgXtr8iXc2zg2CyPO6I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLdLbtbl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i2ScIvsM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LLdLbtbl;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=i2ScIvsM;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770634571; a=rsa-sha256;
	cv=none;
	b=7rrfyZapChktgwrlR7hNj3Rf6Wu6HzveVTGr148q7uotcvXs7z0t99PHVfFD4eVkeFgerC
	PMpsVplL5oO6wGrl+3rQgY97a2r2HUGLF7AWO9fH+P7hjex0LEasZPx0gqkF4A5dPbsggu
	PyzFmy0DqnBtu01/HRdhmU40vzzveiI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 77A623E6E7;
	Mon,  9 Feb 2026 10:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770634569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bipua3Ir60MfzXCM9F8PX40hI/RZj553n1aw8TfsLp4=;
	b=LLdLbtblriPMs7oqHgHrWSZw+9TIGxDWed6JJXEBvYd+Z0X7qDMcC5007CDpU4vP9uGlxX
	yLT5IBmAzvKnprPK5plWAuq31uEf2FrbHsBElc90PHluZ1i23OdNSgsW2u42kNSgjWHw0I
	tr8HXIlhYNcc3Q9mD5MFQ5XRZ5Me2Ng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770634569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bipua3Ir60MfzXCM9F8PX40hI/RZj553n1aw8TfsLp4=;
	b=i2ScIvsM/XtQxyptLXc4xVw7Ux+pBJNJU80dR1KczOckVNhCT2UJVxyFgKU4gzmADrnOXA
	y+XrvAw5dQTIB2Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770634569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bipua3Ir60MfzXCM9F8PX40hI/RZj553n1aw8TfsLp4=;
	b=LLdLbtblriPMs7oqHgHrWSZw+9TIGxDWed6JJXEBvYd+Z0X7qDMcC5007CDpU4vP9uGlxX
	yLT5IBmAzvKnprPK5plWAuq31uEf2FrbHsBElc90PHluZ1i23OdNSgsW2u42kNSgjWHw0I
	tr8HXIlhYNcc3Q9mD5MFQ5XRZ5Me2Ng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770634569;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Bipua3Ir60MfzXCM9F8PX40hI/RZj553n1aw8TfsLp4=;
	b=i2ScIvsM/XtQxyptLXc4xVw7Ux+pBJNJU80dR1KczOckVNhCT2UJVxyFgKU4gzmADrnOXA
	y+XrvAw5dQTIB2Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62F7A3EA63;
	Mon,  9 Feb 2026 10:56:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MEcmGEm9iWl+WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Feb 2026 10:56:09 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2102CA061E; Mon,  9 Feb 2026 11:56:01 +0100 (CET)
Date: Mon, 9 Feb 2026 11:56:01 +0100
From: Jan Kara <jack@suse.cz>
To: klourencodev@gmail.com
Cc: linux-mm@kvack.org, jack@suse.cz, rppt@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, vbabka@suse.cz, brauner@kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2] mm/fadvise: validate offset in generic_fadvise
Message-ID: <yty3z2cd5icaoyjmw6sq5x5gvkcibfl33ilvsq7ajdic7xkemq@x73k2uvtn6ut>
References: <CAFveykMPrkb=VYwQAjCEARsC_WAGfQXMz_gf8Q0CTHWHooNHVA@mail.gmail.com>
 <20260208135738.18992-1-klourencodev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208135738.18992-1-klourencodev@gmail.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Stat-Signature: neczhn5iqidepatko7j8fnbhhkgjgq81
X-Rspamd-Queue-Id: E59A54000F
X-Rspam-User: 
X-HE-Tag: 1770634570-268889
X-HE-Meta: U2FsdGVkX1/pWwZ/lSI6UPqxsfYMWVtWZHXmR68jyILhvvfi+DS2L5C8apBWTlR5ny8hukn8N0oTPCBy+tzj+nv0oyxZbmQ8i6HhIttzuXKvt+sKGUbqHEfZpeT1z2R41w6jPtOS1GR7HCJpFGxHWKYCW7hq5lHZeLi/hu1dTgQEXnEReVVT8PIudHXZjA1W0dUVKRr9/nVXXBHPIxzzNPHeLyQframAOGN1v8Dv7gWQIiYZuGKoO4BMAvxf4SEfK47XEMSvsnDXrzz/ugZ8cOil/co17Qfdd40VKHs4apjV+eoyU2CgMEOhU0vjbSyBbKSH22UWVPdWxdyLm52vZtYEwLrQVQyKXyBRhOakryVyVW0qLEy31BJ6pOBo47VEiui+It7MoPFpyqYfGuil1cVCmEMBoBWywuM5t4zBRgank8pNgEBz9nhJ+VrEihjp/8IlaP5yuBDKKXih6Oi8D8650YDFD/J4BvU3bCPXT18hTtitn7gLD8VyrcjyGE21KL/X5pk1lmsXJJajgSOrM27sucNyOdL8A0VPO/xCYnOkrYGdluX3x+Gdcb/ax6GVioWwWpderHdMqdTIH76dW0UFVUkPzdMUkj2ccxyqIDGFPu3meT5CG62oKge5S/pr22CNg821YLFKF7I8PA8aWlcxtLKPohoAthoXwxLOTs9jH1iwykUZ1AvHtuUmgiU+e+GSo7zwM3Nftc0OmoeT0Q+51/M8GZdfvD54QEJLpNLxsYMYdZ1LirPuX0YKImP9To7ANeCio8MzHayGO/JEkwni+uBtb/rVqKL9wtc/SuqDPNz8+TMBCmFpXhWu4zA5G67tI/dNXE8mu0uo+cvRsWpavtUJYuWmmEUMArV/hOBx6dnJ6DTbDL5CdnoVbRbS28fG2OBuT9Cvlv+nY4h+CHLH1i6i1h2tF66G0oo0+Ksd/Yi+DIoZaefTJqf+ZF1nz0bQDBHv+7Ed1kvyk7J
 IIVSGaBe
 8ydWb+0HYMDAAwJmmPH8IAkZXPXlKERoVHaf8Xi/dhGlX7Tmx/Jus7HYuwC5iMpa4zAavUsI+DJbegb0xvfRY3oZy2IwBNo8uO3pvb4CrWnOgr2JJqObuGMrSfEtRu2ekQ/qNPjVcXiM7jlzxnzVk1FxoY7k8fHEkaxoZPYgcPPHRXjHZKbwZRcG9+G9OZPYIMHmMnnYXUoQ5KHG4w7besI6skSEHpaTw94O06/cZ0gN4XJZLpMoBI+SR+859gaKguQnBkjIv3JW6gWNt1rsbzEezYijwjRlLmZFGLXdV5fb15ipUrq7QcuiSG/aiiHuyoC32CfbmhnVzopy12b6itiz4o8MTmHKCSjIhZ+zSqX70c/81wcIbGHmDdp/p8LlpDBh3oECMFrNOA2OUoPPc3uoTWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 08-02-26 14:57:38, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> When converted to (u64) for page calculations, a negative offset can
> produce extremely large page indices. This may lead to issues in certain
> advice modes (excessive readahead or cache invalidation).
> 
> Reject negative offsets with -EINVAL for consistent argument validation
> and to avoid silent misbehavior.
> 
> POSIX and the man page do not clearly define behavior for negative
> offset/len. FreeBSD rejects negative offsets as well, so failing with
> -EINVAL is consistent with existing practice. The man page can be
> updated separately to document the Linux behavior.
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>

Indeed. That looks like an oversight. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/fadvise.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 67028e30aa91..b63fe21416ff 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -43,7 +43,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  		return -ESPIPE;
>  
>  	mapping = file->f_mapping;
> -	if (!mapping || len < 0)
> +	if (!mapping || len < 0 || offset < 0)
>  		return -EINVAL;
>  
>  	bdi = inode_to_bdi(mapping->host);
> -- 
> 2.52.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

