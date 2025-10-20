Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0B1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39AD68E000C; Mon, 20 Oct 2025 05:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372408E0002; Mon, 20 Oct 2025 05:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2613F8E000C; Mon, 20 Oct 2025 05:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 116018E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:34:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8D9D11AD2B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:34:45 +0000 (UTC)
X-FDA: 84017982930.02.D4B5380
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 83DD04000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:34:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mFkp3atQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9VZHlyVs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tEH4hGHS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=heeIs2Rt;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760952884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=586HgrKwXL/CuLgCJVGk9xjDAYqg9yJZZ9H3nn0c7dk=;
	b=7RuLsq1vOyg9Kz7bHu/uG8K+3X9iYcOQSnkj6//z7o8X26FY/qGexAAFuL31kMIkDwd8Y7
	8+u3Q/VgsTYJA7v4B5eKH9By9fUogGJrDmNh8cEv/xuM1XfAxO44esMunJ6yEDARBzSwuP
	AiMYbmfdH/Z/GMqYtsTFqRMQlToai8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760952884; a=rsa-sha256;
	cv=none;
	b=CkG8tkKmly0BnnTQUvr0CwpdsfXQqdsS/m4Vd1f+LB7xPobUwkvzK/e5w1QYuM/S+ZnCQp
	zKq808+fnUoIQ/4/Z51+/Jf0OIOTCrjSAv9W3plI3z/0PS/Tjs+6h5sBKyHEvyZ8xfPo/Y
	cWMB7YTzj6YX6EenbRHHRL+ASLeeQpI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mFkp3atQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9VZHlyVs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tEH4hGHS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=heeIs2Rt;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CF9C921168;
	Mon, 20 Oct 2025 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952878; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=586HgrKwXL/CuLgCJVGk9xjDAYqg9yJZZ9H3nn0c7dk=;
	b=mFkp3atQlAVT+0yl8lRdhIhnlwdVbNqAGmtxzkM7/Q/yXyS3nRuRIJws6JzfAJmCRdLRC/
	XG3C53MecpZKoBdKe3gQPIYkxKsnsGUGLs2ceE1dsB2eqfALQpCuuuclT+VjyfXqg3VOl7
	dGhFchb7hZktk2AvdI+aQZoAeIdzd6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952878;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=586HgrKwXL/CuLgCJVGk9xjDAYqg9yJZZ9H3nn0c7dk=;
	b=9VZHlyVsYS7V2qb1ILpSLp8b9tlQHQqeQGiKZ5PNj7EwAMMoh0QTAj3WbTtqLKchi0oIb9
	OCBllEs9wmHZr2AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=586HgrKwXL/CuLgCJVGk9xjDAYqg9yJZZ9H3nn0c7dk=;
	b=tEH4hGHS9stepa4KIDU7TrDNXS1BCyLwGWk/TIAdHTnWKDzEKYAJnXujfW2rfmyRdSAijW
	xWSb9rITL8ayNiCHE4pBbWhz/jicx04JiWIXpDb9K61HUu5TiT80fVc5mpISwfUg513zLo
	T0Lx5wn1z2TQY1C5hjWlzqixKk3ZdSo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952873;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=586HgrKwXL/CuLgCJVGk9xjDAYqg9yJZZ9H3nn0c7dk=;
	b=heeIs2Rtcc/YWvixmcShz8E2YYYU0DBy6NikUfqTg+P//k+mtkSPJvUZfCNsIk3pzbPk5c
	LHNpprNHDL8XBRAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C13E813AAD;
	Mon, 20 Oct 2025 09:34:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id puInLykC9mi2CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 09:34:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 79670A0856; Mon, 20 Oct 2025 11:34:33 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:34:33 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Message-ID: <ledzremc2x4ehhs6kfovuwexxyic6cwlqbb55dbtm4hnvovynr@tbm5cp6qt73u>
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015062728.60104-2-hch@lst.de>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 83DD04000D
X-Rspamd-Server: rspam02
X-Stat-Signature: wiw5hse9bra9ojstk6t6ey5yhhrz4ec8
X-HE-Tag: 1760952883-38192
X-HE-Meta: U2FsdGVkX1+Z5hNJzrS+1/aBGRnX9u/+Nfcb4DM/cLzy48QcPy29HTMv5bCZCu/v6uMRkB4V420VAtQVMdx0ySu8o+udEBVjO0D2wUTWK3Q4ltJ4rVFCto/Uu9XxreFxNlb6PIeSLL7TA/gRnhQdSpVS2f0zV1XJdA4wSXMd+BCzU/5GkHPM/mSHB4+bhtHGRfamycD27R3wDjd3bt79CDEIm/mRptrKsRZjLiw2EY2EhjecyNE+GbCRuJ2SYMpTeNupyrmqnsNfWiHcKOWNUEPa5BPMXeKctNDspaAccI7jSjNjFu1YusoiDDgY/u1B5FGfJd0N6JtxIv2ZxdlA60QMQkDl/ixXoz9/T1vzLvtu63+URWwpOwRB6zFzPCtcC+enU88xjFoA6I4MWzEJRCGQHDVrG4w0JBnHAY6BfQ7ImzZU1TDDFY9B6u5GsnfXusjHt6u3xgKG2RCG4y1zmgPGtXLFUDBeDXPtdcnUvhrBYirsUIPqh8+dxYzYfks3MZ++sEiMPGI/TvRmiJ9IgKVv22lsF/DzL3iZs4jJyIY07IiO9xeK+xx+IVeEmJgQCOt++jXhpFKCp9hKPdvmuOYd5UG5mPIy+clJ6bdUNbl0Nvm0kv7obLSdXM3dVAaRFl0s7I7sA8lDuRwa/26bTKTzolWBVqi1PtAPHwHEZSrkVu/cixmqjalWdf72eNYOLMU6a8s9pPfdzmzDBcVR9yJ1UuLqD8rGWQC3YqzbZ8E8dnqPODDruBu6Z+exCUBDWRFrXDSNJZvL8VRET5HnOtE/kcP4mNcThCm1ILv7s/EUr3P5gurMwVVb8eXtBgfs70NB0EuXmTHDJqXSNP3XWvs00N/9DdVY9ZLbVXh6uLIh2U0ftajRtNtpD1QQmWTQs1fvggQXAG48yfy3dUbWOtrijOucD4hnSwZXllTonUjHPZBFYTJ7paBFT4wxiYTv+N5w1bqQErTyPzEZ2A/
 1L6gO7Za
 F7eEp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 15-10-25 15:27:14, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

