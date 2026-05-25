Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28324CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2932C6B0005; Mon, 25 May 2026 12:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B7A6B0088; Mon, 25 May 2026 12:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181126B008A; Mon, 25 May 2026 12:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0323B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:17:10 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F7921C086D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:17:09 +0000 (UTC)
X-FDA: 84806446578.26.4DB437F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6BB91180005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:17:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0Hfg4OMV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TA5BDXsx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KZmdsyIb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gLGhTS17;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779725827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOqps2oswWC8BW2SBX1fhbQKL5egyliEPxPGdscg6ck=;
	b=YkJUz1qGsHQyZtTzEPAUXf4Ni2qbxab8qE352573LX0s3HHyRhfke5/yt1BuTAgXdnPYum
	Hgcf/G47038YthSij+u3K6y2QmxMCs6mQE0xh8JLeac1X+DhsnFW5m7EozmdMue/xw9whK
	d2HJXp4DSU9qFvOy3nGlT4TaEUKkEYU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0Hfg4OMV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TA5BDXsx;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KZmdsyIb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gLGhTS17;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779725827; a=rsa-sha256;
	cv=none;
	b=HaaJE9Rz9fd5fPHpwfOhqDHPOZewLqDMOPujRVAxhjGXuYwuQyqgo5XOyg75yb/6VSwzs2
	Zc4X7mOG+4TLcM/aL1GxGQAJh+l8WD/a2qp95gOP99G0X5XpJXem13OXp1Km+EplhbqOKg
	gAKbynm5N0S8CkGj8KSAp8sXpu658ZQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4E60E67348;
	Mon, 25 May 2026 16:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOqps2oswWC8BW2SBX1fhbQKL5egyliEPxPGdscg6ck=;
	b=0Hfg4OMVKiSiBQRJ0uXGtZ8Y2OWRXaeQiytwwLq/6j+xg3BIXhWCytD16vaK/ReUZN/NPL
	wTnrzYeH1IzgsLoBVI9X1BWRsL/wSZ1JqDbuMcaYTzAvC2hPneYfUoMZhYoWC16zjNTEwt
	xc2g2M2ArcMfdxzR1sP9fIsQFcoLI7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOqps2oswWC8BW2SBX1fhbQKL5egyliEPxPGdscg6ck=;
	b=TA5BDXsxnNOSpg7RYa0vh6dt4KKlarsqZlQ0apRfPWvWV3o6Ue9PynGK1BkRq5WOQXx4Xo
	pSUPkHkhVCFmbCCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779725825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOqps2oswWC8BW2SBX1fhbQKL5egyliEPxPGdscg6ck=;
	b=KZmdsyIbb7noi77UxqpJdYPIHUjs7CUvNMlTRqKv115xDDibEonWbBVtvQVV4YkJtvFrC4
	z7Lz26jmfDAdCWhRJwJ1k8Ri0rR84dk1fSkgSO7kvN0NeADynsPDw7dh649BfG8yV0PPaH
	lCnBK5xO9SgvpQR/Oy4GYVRCiDhLMhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779725825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KOqps2oswWC8BW2SBX1fhbQKL5egyliEPxPGdscg6ck=;
	b=gLGhTS17boEqI8NdUfnjerwDCcLadne4B0nRBdAScThhuAk/POWYmSCZfGFAYNcsmqOPYv
	GicgUS4PiC6xT2Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3F37959D24;
	Mon, 25 May 2026 16:17:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0A1tDwF2FGqxHgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 25 May 2026 16:17:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D5E1FA08D7; Mon, 25 May 2026 18:17:04 +0200 (CEST)
Date: Mon, 25 May 2026 18:17:04 +0200
From: Jan Kara <jack@suse.cz>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
	Miklos Szeredi <miklos@szeredi.hu>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	jfs-discussion@lists.sourceforge.net, linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
X-Stat-Signature: e8mar4mjeogdyc5uonkxn78cskz3nps6
X-Rspamd-Queue-Id: 6BB91180005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779725827-792712
X-HE-Meta: U2FsdGVkX18+i47NEJUrPdNYylhMB1XNxiWCSmsASeWETvRsJQs4yCFCmcSt/H3wzzjbgg763I5k2JL++LxZx097/UI7DzS+3zity1Ywnq4W5qKcoDHitXJBMtv1JE3qzxkzGAvi6nIZT746WcNOcghZKHCQwv4GeRlOldydVhUJ2xTvVGvty0xllD6Xi9QItiHsn2SSJsDqURPVKnkCY6OgUZJzmnxU1F8JyFi6m9dXtJw32UOpK35BsIYuWwe78pmYVah0cn8ivmoDRd/lCZ0qohsI5W+w9pNTktfGR3QpL+0cZgTxKQ64k1LOoSXrC++tfJqa6PSwsZMxsfCegLjtBPW71Cy3iQufLMOjWzEdZusrNUtyXRQSkNfbGL+5MRAqqYV/nOfUMxhhmI7nphUHXYirLnVat6PhqCRYtxDQr6BY91JFw71zlwgCYGxCHipkfn/5YX/Uu6qFTuj2hJLPye1lPX78aBoxA3SSrOij5/RUHSKTraxYUknq+9ddN1m6zbjW25POJxwIb5YxAoYF1NbrtFReJEUBitEnLfxZdU3WQ9VofdHGq8YQmpy2RgrTCbzzAuT4N9zdmAxijztyUyrhQsIWye8oauDaP2q4/LIMKWLGb2nAeX0g9a5muVCUTMHKy9T10o7M5QQyrGXlFdWwQVcwVwaeIFVVmW9JrNo19RyP889Cj2GlZhRKbn2+IM8s0K3R+1m0Cy8YQkDt3ekxJwvWNJppMz3enrFDNCq7m71A4q8xcFjj3pbKkeP3X2PaXJvPTv3eqdqe4hxSuNnYMvEH8MZ6eWnuS9sSMwOtJqmxN+uDVCcxnfIF3Uy4gwNSlX44VOM3CNRw2OncJgpfQAM83HeBILBVLTk3rvhe9Gah0JTFcAmLE+Esg+q24BFnC+xtDFf4PThFXTS72M9tXqgtifCnJv2rJkrELQmO0xKCtVDu1TRtA7OL7UqTZtfhpIybK6XdBbE
 u9Vjo4gs
 eK0/6CB2WWvLq3z89m5HKvcATkVz8DYeTz7wpYg0AkG0gKbxs6AoIY+iHuO/tFD2n8tfy2KhiLSatKlrJRskHOhODJw3hc03IXpZ8RKldUK9TcHyt9no+j/niLhlbviXaKWO/b36l/PMewiInlsT1CX325ujtTDtjZABk6z6Ifhct6aoRG6293Eg4Ot/5NORdP5QGJk+Yuo65/2iwOxb7biteShRHbe3OD/y9T7bbCBShRI3eTJw7LsMu2NSzMkVQNYdxbf+eB/12W20jVzuQxOHjqyhnwlUjDHM7WVtDiR98BtjsKUg98dlr88tRr8cjlOirhdHOwdUpNcCmod/ziF3hFKXvHF3FppcMIjFLr5QJtWyyvwt2IGXV4t03uUdLPE9/pT3h3ayu2909PtVIUwPQTgyPZK5o32YgqWZCFNttEwruL1nhmJQEfipPe8zZQPZhjT3GBaVfW8lNHqV10lw0gfL2/Sg+dSmj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 23-05-26 20:54:22, Mike Rapoport (Microsoft) wrote:
> jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> allocations larger than PAGE_SIZE.
> But kmalloc() can handle such cases with essentially the same fallback.
> 
> Replace use of __get_free_pages() with kmalloc() and simplify
> jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> freed with kfree().
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

I'll just note that we allocate here fs block size large buffer so the same
kind of allocator as we use for folios would be even better. But that's a
different cleanup I guess.

								Honza

> ---
>  fs/jbd2/journal.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
> index 4f397fcdb13c..1137b471e490 100644
> --- a/fs/jbd2/journal.c
> +++ b/fs/jbd2/journal.c
> @@ -2784,7 +2784,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
>  	if (size < PAGE_SIZE)
>  		ptr = kmem_cache_alloc(get_slab(size), flags);
>  	else
> -		ptr = (void *)__get_free_pages(flags, get_order(size));
> +		ptr = kmalloc(size, flags);
>  
>  	/* Check alignment; SLUB has gotten this wrong in the past,
>  	 * and this can lead to user data corruption! */
> @@ -2795,10 +2795,7 @@ void *jbd2_alloc(size_t size, gfp_t flags)
>  
>  void jbd2_free(void *ptr, size_t size)
>  {
> -	if (size < PAGE_SIZE)
> -		kmem_cache_free(get_slab(size), ptr);
> -	else
> -		free_pages((unsigned long)ptr, get_order(size));
> +	kfree(ptr);
>  };
>  
>  /*
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

