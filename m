Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 398D0606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=f/GH5j6W;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wEysVB6j;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KToIDbJJ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AiZtdrn0
Received: by kanga.kvack.org (Postfix)
	id 4B9796B05B0; Thu,  5 Nov 2026 05:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 490CF6B05B1; Thu,  5 Nov 2026 05:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37F776B05B2; Thu,  5 Nov 2026 05:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12D806B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:54:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A3D6C12086B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:54:55 +0000 (UTC)
X-FDA: 85400757750.19.FF60ADA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4013640005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:54:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="f/GH5j6W";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wEysVB6j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KToIDbJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AiZtdrn0;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793876093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmrvnZ/EMvEeuZnlTBD+xVIwz9BGrfQBmhgJ0E/6Uns=;
	b=KmTcxvhgYy19F9GyPYicy3UpRR8hWqQQG/4tW+cVI0v0WPxW8Si5qLY0orpbeZjxs/26sg
	16u5wGTyuKe/y2WEI14VVz1Zh/8SmYu0AA3DLxXgT1tagGiDG1JL5EmoWiy5eb2K4BRbKZ
	0J1R0uwwfPa3DsHFi08o10hWXnKz2kk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="f/GH5j6W";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=wEysVB6j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KToIDbJJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AiZtdrn0;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793876093;
	b=0hKwBf13ymELvLL6qhbzvFLyMNp2x1wcZ7B2ONnNqBr2BUIgczPLOdrqkt77D7VFAU5nti
	50i9Da5rxmEd4BitgCQEXohrU78ImahHvUXqYfhKHAwICFMw29bH4hR37l4VZ5+Y4dpix9
	qVc+erkgAVyIvYi1SuK/hVsqNzrouXU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B5F4021F8A;
	Thu,  5 Nov 2026 10:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793876091; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pmrvnZ/EMvEeuZnlTBD+xVIwz9BGrfQBmhgJ0E/6Uns=;
	b=f/GH5j6WLHXTIosA4Q9IKyULurUFpMv9+/BYPMq6Rxw8ueFWXCFeDTrfUzIUrNFgf4Nikw
	zEznvo73bLV4awjLYpO5ViCgpog1U9OOxYxg/cgadjr80VvtftyGtFZxuXyPbpNx7wRnrF
	4lkRWlALdbhXbjO0Y+WIwrmBHDbsIlY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793876091;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pmrvnZ/EMvEeuZnlTBD+xVIwz9BGrfQBmhgJ0E/6Uns=;
	b=wEysVB6j2qa61Ws0d3fZhxFRmIXhbmGBCpLlV1PmVRLkJJMbfNnVDQiquBJS3mnGdehk7T
	emuToUGERLyxupDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793876090; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pmrvnZ/EMvEeuZnlTBD+xVIwz9BGrfQBmhgJ0E/6Uns=;
	b=KToIDbJJpYXPRUTNGAM2BUdWs/VNL0vlpFaGyCPhhS9L76pGtBfIozD+Zt24m5s+0pmVy1
	htASFuWBej54OhiKCG5b/84k2DxzdPdND7l17pd/K+LA8HnZKioAJB0qOZg6QW5PfqbDCh
	KA4aGY8pIljZ+5C9+GS2ZjMuhEAFDNg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793876090;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pmrvnZ/EMvEeuZnlTBD+xVIwz9BGrfQBmhgJ0E/6Uns=;
	b=AiZtdrn0oKOknRHwHN42UnOic78MCRHrzJCUS5U8LNVNY4/RdzEqzCcxDOD4GJd8UYJg5V
	syK3fQ1BNdBXYOCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7FD2B133F6;
	Thu,  5 Nov 2026 10:54:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lICiFHpg7GoWRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 10:54:50 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E6C96B696; Thu, 05 Nov 2026 11:54:49 +0100 (CET)
Date: Thu, 5 Nov 2026 11:54:49 +0100
From: Jan Kara <jack@suse.cz>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page-writeback: avoid unnecessary strictlimit
 background wakeups
Message-ID: <fojzqutv5x2umdn44xly7pkgkvesz7lwriah36sq2t3cuuw4ui@ywgowfpmaz34>
References: <20261031070515.3042848-2-thnkslprpt@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261031070515.3042848-2-thnkslprpt@gmail.com>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: 7jxdcf6f4akjsn9r38scqbskgw6ur8ex
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4013640005
X-HE-Tag: 1793876093-701087
X-HE-Meta: U2FsdGVkX19Pg0/yyg8ITf2Tr5dPD2893D9D0Qi5yiGVf+bGtXaCMz3tlT5IKBf5lq/Ppt5NrBH3gDYNNIMb/PrbKxPSN2HX+Nmk6tu0IkcovSGtVrpP3v01y0P/FSmgvnSxC8fyvEWPnGY+k2QfqsvAjhlshMEyHKumOZ76KFjl3ZCYX67pVbvgTnMIPac4xAmfF1i1dnHB60LfQZNzGkSsL0tRwuEr+vpe5fYbt/qAn6BUjOmJ/t8r0pC0DeFN9Y+BBzR9mtccRiax4SirosG9KcauxlX2UgvqBNdx8PnO581AQeDckcB52lKW5R498REeQQbz0RcNa8hGdDibcAdbiSN1h6kdRQw0x1sJyAebgzH5xqqk6GagIGzemDfl80OAzn2STVNotXmBMnt2kpEINL8ZtTnXYKKba9cMh7Tw2TqrgV8rYAEoHQfwIqRdLEsGoWY0hqb8dQ9U0D+HL8p1rC1QYzpv+BeLCEOIbMOSVYoacEg2itA0Yg/woN7ndGiOxq5XStFaoKMu1E0l+BJ1Eogu8dz43iNUAdNAgZ0iwQxsqOR7XCswk6x+4HQwLE76VUqlvjNLfCDpfqT981C+c1YkUFWXJEPy/45sJDWUrRCMy34E4L0f0/c8EcOpoA94VbVzQ4/oY5eGtNO3KnAJFqLjJA5chm0XjcxVzfSG/wIQO8PMGaMeCjE4KvJeslX2u061jZjdHLKhpWD33z1TfB5GXHyjRdwnpAnlBdl10XpvHr1KiT63u0JHVDJJwWqtI/2JPZ4jZ1zZYCxJwn804c9dQ9clU4rlzKCNGjjNtcUchTU0KcNctVrnZnYQPUKYVng1kDZM4mD4RLhQEqqdvfdH/BflcYL8GpjbWifYZ7zUcSj2Nvk/mLqhztj8fJRxzsAeh4VGoglhrlG/B5/12/OI8ZaPXqvJe849ssDYo6A+jL7kbbUAO3l93IN79uiQycctERXH/u2WAZH
 Ef8+2bK0
 001UTjAJRQ0IUyQM9JERFJwmD8JyflnJmCNyhuONhkDqBBlZEHNnuZAyjhVuVoP1e1H0xeo721Wp44xTxkl20N5owLb0ATh3Zr/DRMBWvjvIENwq8iFYssYXbX3z5OCpbky+ejjZBHXzOlbZS2jNY7K/a4GIYStKOQltRqed9sozIVzsTdgU5dQYTXPVfNMeI9qFWWV3TdHuc59ON8ODE0rhuT9rrufLVFBh3kslS1QBQgdy8J8OyCKJ8vwlxV8BSdgYa0dub+IltFqXlkdU5dIrox1g+gg6dUuqYU/jMt0C4XYicg5e6Qe0SeFKPpTWDDrzUF1hcSC1ru4Lkh5DKDtPL5MJxmeEql2CP7UL3OxLzOg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat 31-10-26 09:05:15, Avi Weiss wrote:
> balance_dirty_pages() includes pages under writeback in
> gdtc->wb_dirty when checking the per-wb background threshold for
> strictlimit BDIs. However, wb_over_bg_thresh() only considers
> reclaimable dirty pages when deciding whether to start more
> background writeback.
> 
> This can repeatedly wake the background worker even when there are
> too few dirty pages to write. In a 15-second FUSE writeback test,
> background wakeup requests dropped from 2657 to 682 (74% drop),
> while writeback_start events remained nearly unchanged at 99 and 98.
> 
> Check wb_over_bg_thresh() before starting background writeback through
> the strictlimit condition. Leave the global background threshold
> check and the wakeup required for dirty throttling unchanged.

I assume you've left the gdtc->wb_dirty > gdtc->wb_bg_thresh check in to
reduce times when wb_over_bg_thresh() is called (because it is relatively
costly and this condition is evaluated relatively often)? Maybe it would be
good to add there a comment with explanation like:

/*
 * gdtc->wb_dirty includes pages under writeback so it serves only as a
 * quick check and we use wb_over_bg_thresh() for exact evaluation whether
 * a wakeup is needed
 */

> Fixes: 0437906841d0 ("mm: start background writeback based on per-wb threshold for strictlimit BDIs")
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>

Otherwise the patch looks good so feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 499a35473e4f..cb0c58715b93 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1826,7 +1826,8 @@ static int balance_dirty_pages(struct bdi_writeback *wb,
>  
>  		if (!writeback_in_progress(wb) &&
>  		    (nr_dirty > gdtc->bg_thresh ||
> -		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh)))
> +		     (strictlimit && gdtc->wb_dirty > gdtc->wb_bg_thresh &&
> +		      wb_over_bg_thresh(wb))))
>  			wb_start_background_writeback(wb);
>  
>  		/*
> 
> base-commit: 36aad21d50d1af3f6954bb0c988257a908202477
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

