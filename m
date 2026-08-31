Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7CBC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CDF36B0088; Mon, 31 Aug 2026 06:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F366B008A; Mon, 31 Aug 2026 06:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698246B008C; Mon, 31 Aug 2026 06:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C8EA6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:06:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2662C03FC
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:06:32 +0000 (UTC)
X-FDA: 85161135024.08.72492D9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 99FC340006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:06:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKwu2asG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yIyma6zn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hmYbXGPh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NxsPq1pR;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788170790;
	b=BohLq6IfdN6zpW7bg6Q0zLFLW9/ffU0S5o1M7sw4QW5lqF7wMoOS7D2eZx7Dy3muiCocxF
	QQQL4b5xmYQqLq0Uo0UB2nx/lWvNmLu7NaLuOt/V/3TM84az7pj7rrTObpEb/YTy8/chJr
	f2nYX4oeS/DCaBhDTnTIepO+YDxhHGM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKwu2asG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yIyma6zn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hmYbXGPh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NxsPq1pR;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788170790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUNwtZYE0BZEojiBC/c0w28QoGhVaGYNfF8bWOZe0J0=;
	b=jFY1/G5jQiGjCj0GgsaDKDAI4DHPSvyOcpZLMREbeM9HyF2YD4z3TCRuRaR+X1eIE1aSqq
	oTcMuPFTAgIwySPOKmTdloGHgp3dnzdZjGkYjPEc6s0tTw7GS76OhdoG2YSMEcrPUg0pY0
	tZeB0NIsC2ZXZ1opJ4PiLrrb49VB1b8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BFE4A22347;
	Mon, 31 Aug 2026 10:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170785; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SUNwtZYE0BZEojiBC/c0w28QoGhVaGYNfF8bWOZe0J0=;
	b=jKwu2asGObmXrCsHXGJTde/JBaodQf9kqgWIndpdOxVluroTDfauMTBO87hFsi47W9KcoG
	jTgX2l/rLJlcsCTFRacAZ2K+zTVb5Ooi78ojcnFceF6jE/F3XQrDGXyyTV6GSINgRdKdUj
	IGjwvAFewJgqf5MAhcrCXoZPYAYhKWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170785;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SUNwtZYE0BZEojiBC/c0w28QoGhVaGYNfF8bWOZe0J0=;
	b=yIyma6znJVeJA846qMD4dW9M6BkaUTMQadp7YwBU7cxzIj4+DotGWnUz5DXezz9prWZN7K
	fKkGBq2AfP44yZCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788170780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SUNwtZYE0BZEojiBC/c0w28QoGhVaGYNfF8bWOZe0J0=;
	b=hmYbXGPhmUjtMThBiWN66fg3p2akpd1bjj3OoOiVFs9FqqACy6WhIHqVFhAJTkl1C9V1+q
	4nQmI7fdTVlE1EMLQLRBwvK+u5HOeSd+xpKRCs3tU7rsnpdEWJiPkZ77htZDfLDb0/QQZQ
	fcH0uzgkh6yNv79d9TeAp2ZjkITPx4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788170780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SUNwtZYE0BZEojiBC/c0w28QoGhVaGYNfF8bWOZe0J0=;
	b=NxsPq1pRW+nFN8R1t1REtUrjBb1pfxdB/lVWZH7awRQ22iz9nXcNbdcQkRu+rVA5x1pYaz
	Zl45bp/pNmdh+iDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D1FC13682;
	Mon, 31 Aug 2026 10:06:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Li5UJhxSlWoodwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:06:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 2C9C8A13B5; Mon, 31 Aug 2026 12:06:20 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:06:20 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 8/9] filemap: Remove redundant FGP_NOFS
Message-ID: <d3w3bedhmbl7d2ssfq2ov43safj7hynj7rpwztdiu22fkasrhm@e4qjbeohazgv>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-9-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-9-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: u4tzfo6pe9od7nnqwqqmqaihqt81zx5a
X-Rspamd-Queue-Id: 99FC340006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788170790-739281
X-HE-Meta: U2FsdGVkX190tyhlYka3d1kbs3F7F82AqUmuhRggnhtoLMuvQKAzTy12gpwO4nEaU1BYAZlMfJBtoB152+m0KtC4kb61y3F8Fwo8FXYU1VArIt1kRj9FwYfH28Fte+9Y4FWTAap30coSP8ENMYOP6JhRzgwnGlovZlEx1FmUu4aHCSd2jgIP3IvLuiKUbsKqyvjxuh84sojQgi1sHY+AxRJ1jAk4VBAktyDtqTsG5GYnzKWSRksBZY84etQEXdq2v5GDNvogGjII2lNBOFK33APzWCfKMrJXdhr/eLmtmV4wM71S1+b3f6bWCDszGwpQctKAgxai/DPy8Ik2K0DmKQwtzQ+aJ8p23143BrBXOKFcvk+OKXN0A9M5sV1iHKVKGpF/08FUZ2jsbHNT1+GdzqMaQLM5aBI6GKRvRkDnCrIbQMYjp8EZjZi6PYuHw/36+jLC196d+1RQ36B5eqLEoEIKrH8az1z4E64ltWJg/iDjtCdf+mzirO3HHEktKukmemkKSGmTsoMhwBYSQ8pBHbBM7E3Jw6jc3UWyYkbVO8Do6l2LOL82jtljPYKFtZLvgFTz1septtY8LsknvGvvdgLRmzHiCBEcPwoMQi3Sn9P9mD0xietPA1OXjoTVidCReGUDOSws6PRCflFCbGazQw6LP4rUyv4pJXsAdx2C2dfxqd1VzQFtZD3QGvxdTyWh2nnPMwQ/bJWC9cgoOLvDqRg3ARxGQrtzSrjf0EMcDsbm9MhQO+LgbROtAx2DSin1XcRAAyjBRoevdEjJxc/Hb6vQH7pY1jFI+n0umshnNK4hwa2tv+/MelwlFX7nxilxErrzubsXrL3dqI2ti3vU8xsSOajtIHw0HoY23/T0vCD4179n8sk4n4rEM0CBXeRXoS63lf9KUMPkVdXljCDmqfU0b6thI4O6BL0NI/7uUfEyH4ucryXI6owdBlrj5vfHIbMip8SLc8jDELANNbV
 g3tv/Ebw
 faZf7CqWhgg59j/eqVeVl6r/dVS7iOwqWXzM7f5ohT8KkIKL0pTJhOV8s0zTntb15Cmd1sJnnnzev+FiLB+4Z6N9C76qGx+r4jnexT7rhxGreHb99ieT+gWJxM20CB09xE9CfNfMqjsqCDqwkDTXT638p+2vHVV/mAHr9pw2l3sOi1I4gKUJFA17GXGXNwp3sMf5kfNoUE8Eyj+Oz6eXDgZIubNmCK4y8RnJ6d3Z/KGLbpQZgbRE92LEGzENor/XThGVdswyTT6uYzuErh8v77KCfD5w+ZZAtmXb6kbCVpzg/GDJXUzBz3nU0hcKvunVsdPLVaMjkNRZtnbS4Hf5gN1CIi87tqKppHPzrLnizcDIdcQIx/60GUMQL9mthAe5sUEmjmjbaD8FykedWedKkWiS+N3ucxRbZjZGHEADn8Bkf04qAZWe36pzobsBpXMGOb2tKLSFCnitmeq7lKX+HaYSC5hqaiO7F3mGS8NhUvJEExIDbyP/1eTsnpwVZsKZPHOeZLnyH2CFPYYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:55, Matthew Wilcox (Oracle) wrote:
> The flags already include FGP_NOWAIT which prohibits all reclaim, not
> just reclaiming from the filesystem.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/pagemap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 0adfa6605653..3974b063a049 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -929,7 +929,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
>  				pgoff_t index)
>  {
>  	return pagecache_get_page(mapping, index,
> -			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
> +			FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
>  			mapping_gfp_mask(mapping));
>  }
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

