Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36DE606A324
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 14:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=V18JV07i;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=V3WqNeUg;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=V18JV07i;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=V3WqNeUg
Received: by kanga.kvack.org (Postfix)
	id B1B756B05B0; Fri, 27 Nov 2026 09:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBAA6B05B1; Fri, 27 Nov 2026 09:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9932D6B05B2; Fri, 27 Nov 2026 09:41:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 145656B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:41:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DC35A03CE
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:41:21 +0000 (UTC)
X-FDA: 85481161962.17.46F7A3D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53F3520007
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:41:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V18JV07i;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V3WqNeUg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V18JV07i;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V3WqNeUg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795790479;
	b=DyuPlTAT4gZSlnYe8vNtzrbq3IElfdZPdIKescCtx2r+Wgdqj3mqZm1QKR4dkcYfiMweIH
	iM/Up9SEbQoavoVWChfI0rLDoqyYKa/5l2l4iQRXQ3JqBc4gDc7AKxMLkbLZVxik5JyObE
	88dBJLp0G9ix7sFJnFyMwJjzX1QPPuY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795790479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OiMqB0HFqHTXQ26F6nnKmMgWEH3gjayAZHzMcMj1aU=;
	b=eHd5+xIOtSLFwVESUrXqqKMaY2JJjeKu8pBfTo24OHXQWGKbcdl5HxLTd5PBjg1WxTelTi
	MY++wEDK4jo3mplRlR+VesLUmC4veqFDCfb2wKgiFc3+GBGfarXMcbo2nYJzGKVG0birSA
	azFqmhYwkvOGoTVvrUyn1V4hNZXhs04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V18JV07i;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V3WqNeUg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V18JV07i;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V3WqNeUg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ABDEB22936;
	Fri, 27 Nov 2026 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795790477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5OiMqB0HFqHTXQ26F6nnKmMgWEH3gjayAZHzMcMj1aU=;
	b=V18JV07iazluiBay10fP/4fd0aBvpx12c6oF3mwpxHXAz2019+WnkVqDSmKZaSvTDlMhPF
	+XNcC7x/9xS53FynRM9dvfhEdVgtRrrJQHH2ACw69rokKv+FHXTcm7PNCnE8tEKcZQmeJF
	hnt16LEz+mQWdpgZEpYRwU0z+1jzExc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795790477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5OiMqB0HFqHTXQ26F6nnKmMgWEH3gjayAZHzMcMj1aU=;
	b=V3WqNeUgkgQSxLbxSxJo8uXWKoVfkUXxcp5ohyGehBBEEMBEjZJ+8bwnYcECcgLBCveJmp
	KHVJE0UjiSqIGoCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795790477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5OiMqB0HFqHTXQ26F6nnKmMgWEH3gjayAZHzMcMj1aU=;
	b=V18JV07iazluiBay10fP/4fd0aBvpx12c6oF3mwpxHXAz2019+WnkVqDSmKZaSvTDlMhPF
	+XNcC7x/9xS53FynRM9dvfhEdVgtRrrJQHH2ACw69rokKv+FHXTcm7PNCnE8tEKcZQmeJF
	hnt16LEz+mQWdpgZEpYRwU0z+1jzExc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795790477;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5OiMqB0HFqHTXQ26F6nnKmMgWEH3gjayAZHzMcMj1aU=;
	b=V3WqNeUgkgQSxLbxSxJo8uXWKoVfkUXxcp5ohyGehBBEEMBEjZJ+8bwnYcECcgLBCveJmp
	KHVJE0UjiSqIGoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7ECF013432;
	Fri, 27 Nov 2026 14:41:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w90gF42WCWvcXwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 14:41:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 13DF251056; Fri, 27 Nov 2026 15:41:13 +0100 (CET)
Date: Fri, 27 Nov 2026 15:41:13 +0100
From: Jan Kara <jack@suse.cz>
To: Zhao Gongyi <zhaogongyi@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>, 
	Jinchao Wang <wangjinchao600@gmail.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: read folio order limits under the
 invalidate lock
Message-ID: <pmv77fehocb557wy6vtcu2fank4uf54k42n22owpyuxxzxfgkj@46pvovh3r7jg>
References: <20261127072340.73758-1-zhaogongyi@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127072340.73758-1-zhaogongyi@bytedance.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53F3520007
X-Stat-Signature: 3cw3zexusxy4mcoh7i3x996hxs1pdf7m
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795790479-632840
X-HE-Meta: U2FsdGVkX1+IxJGfnDiIb/2VuJ8YNdI7b2947TUM11sBxNBaj059XkojPta9Ee+djP+ZthePRhevpD24FLmKvxsD4Y+G7GCtC6mNV4Kvzwf91cjOmrzHpWv7B9b6ASxwF5IEy5FQGOgJxDAA8ixk1A+VCA2YTH1ryfjfkf91X3zOlVuyTP8o4NLwj6/5dBfW3SUQYR04K5nIiciFLGhKOL+gc0HA4DCkXorIZ0xiD7hTHH50mKsvaV3w0GCeKUs+jTtNQGQgqk8bcP8+8p1YuNFCGSislzNAUlG4fm4XRTDTn/SUKQ73cxg/y1wbFCZln0uKY7HCuWgYCGKLo7FjbaqFj0Ngquh7dJaUzeRZ9PYKXoHOSDRoxqioEmrt8JpRfauzXDHOmKQ84dds447pX5tsis+zdnAyhhdG5y0DoJNy/osTI4aS/cWaWZGFheWzeTUWiQ/93OuPet3U3SJpFkmiCJdM5yP+3k2w1zRCV4velZNKLTi4dExczkyWfPur/PVZUFn3mxPUg3TsUUGJ/W5vHU3ES5a4eI8MHjQdlweiz2V6dSY9wYfvkjLabcmLoCNW9DJlRQwyf9LjTKLokRrThAhpLpCh0uVxKhTNpfFg7OIUVe12KJEXZZA651fYdhxY2gfUJBzCnUIf+qxAyE13qSfuCT0gJzIcOpj1Ks4NFj/K8vgy6WFPxJUotnoWJY23xj2tPQP14I4LhUPQEuA8uxJsDCoxLh3eW2wUzMMkIl6r6lyKz3Sbxl2dnSq/30M/5Wc7xKirC7ZY50cJZRfZRblxdJsrmSCtsIenIY/ZG+JFxtMawkJYP6Q8rEEOCbqq8cF4ZTSsvuK5tQ2wrv0IOgRp0iZsi8gz0E6sDPKh+r0HTlvigHTVMCpGQ2yXtzMcygGa3dM2bkeI0LCnU4tkEnvYuJsKRlHs5kfzr6xV9V2eXRBNad4BiYwUVBxyG66m2rgJ5bEFjCqeCFm
 E0HM14GW
 WUm+RjXX/CwheWXFYHkacF+2FiBPI+/LsRw+4oe2DdFiYJyl2Ts4L2oFzcXehSc33KfeBQdEleJeZDb1W2a/4amy5uKgKYq3iV0htAFjLsWEIUC4noEPC+pzEsbmnpCqf+U+a1qZ5ZRuaMosOvuprgzLOMrl5USSJAmqMp0R3TQDxmnSLh7N0LdUtvdf++vao39dtmr9fDH4JHDy/d7OTU6aYG2XS2jb/WAOYbyLT7PwpJ2Zh3QqmETvkNkcEaWhMS6VVeLoAapD/YR89MplPTPwhOuAj2He3jjGv6SziJhy0AWw65BSx/T7pf5CuvWLzPf9Yr4L6BulNr9BDDKAeJKtDJ1pcaBr0gwRmHEku8vOxWUHTlDFhtyWD1pewSoMc2SgTy/aOdTzN5iTQBzMCN4b3c3BLDfZ/PqSNnMdrjH8d/RB8FrSws05kD6aFS1/XYQeKooJqXnqx42jeM3tsXfnV6snBTcYpY6Ey0LG80TaYBbHHWadeqW6Uz5x/koxIv+t98gfwvr6sAfwqcqP3KbmaDrdeE1lB+JERKoabkJ2oRZpOG8iNBUPVP9PvZs/DgGWUKOytEGlDTL1uimkDu+8Ag1AO0BpcJxZyKAZyUZZs7e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 27-11-26 15:23:40, Zhao Gongyi wrote:
> Block device mmap readahead can race with set_blocksize(), which updates
> the block size and minimum folio order under the exclusive invalidate
> lock. page_cache_ra_order() reads the minimum before taking the shared
> lock and can allocate a folio smaller than the new block size. On the
> buffer-head path this can cause a NULL dereference in guard_bio_eod().
> 
> Take the existing shared invalidate lock before computing the folio order
> limits so they stay valid through allocation and I/O submission.
> 
> Fixes: 47dd67532303 ("block/bdev: lift block size restrictions to 64k")
> Cc: stable@vger.kernel.org # 7.3+
> Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>

Ups, this is hairy. The fix looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Earlier proposals:
>   https://lkml.iu.edu/hypermail/linux/kernel/2511.3/04090.html
>   https://lore.kernel.org/r/aUN9BFdxHQj8ThMS@ndev
> 
> The earlier syzbot retest hit a bug in the fallback path. Since
> b244c89a70b3, the caller holds invalidate_lock before the fallback reads
> min_nrpages. This patch covers the remaining mmap readahead path.
> 
> A/B testing on arm64/QEMU at the declared base commit gave 10/10
> baseline hits via madvise and 6/10 via MAP_POPULATE. Both paths had
> 0/10 hits with this patch. The 20 patched serial logs showed no kernel
> warnings or crashes.
> 
>  mm/readahead.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e5563290..80f3e141d 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -484,7 +484,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  	struct address_space *mapping = ractl->mapping;
>  	pgoff_t start = readahead_index(ractl);
>  	pgoff_t index = start;
> -	unsigned int min_order = mapping_min_folio_order(mapping);
> +	unsigned int min_order;
>  	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
>  	pgoff_t mark;
>  	unsigned int nofs;
> @@ -506,15 +506,17 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  		mark = ULONG_MAX;
>  	}
>  
> +	/* See comment in page_cache_ra_unbounded() */
> +	nofs = memalloc_nofs_save();
> +	filemap_invalidate_lock_shared(mapping);
> +
> +	/* Serialize with set_blocksize() updating the minimum folio order. */
> +	min_order = mapping_min_folio_order(mapping);
>  	new_order = min(mapping_max_folio_order(mapping), new_order);
>  	new_order = min_t(unsigned int, new_order, ilog2(ra->size));
>  	new_order = max(new_order, min_order);
> -
>  	ra->order = new_order;
>  
> -	/* See comment in page_cache_ra_unbounded() */
> -	nofs = memalloc_nofs_save();
> -	filemap_invalidate_lock_shared(mapping);
>  	/*
>  	 * If the new_order is greater than min_order and index is
>  	 * already aligned to new_order, then this will be noop as index
> 
> base-commit: 29378f5cd79a27718ead9717fe7b094b651a8e1e
> -- 
> 2.39.5 (Apple Git-154)
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

