Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA925C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41336B0088; Mon, 31 Aug 2026 06:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3796B0099; Mon, 31 Aug 2026 06:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9BE6B009F; Mon, 31 Aug 2026 06:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEFB66B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:12:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 398ED120465
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:12:04 +0000 (UTC)
X-FDA: 85161148968.20.176395A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id C2C2218000B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:12:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A1cs8iP+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xjG79jMA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F+W7yegO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o4nK9Cvo;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788171122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L58Z7+BXjdSqb3Vh9n8TDNy2pZxNZI0wP+OuP60u9BQ=;
	b=O+lzHaaIlDG0q5Ql1aSJjg+p3Ar/6DvmiDjkXODt7srYUsYHJ3vKdIybsWa7cvrDE5ryZ3
	OjujFl47ei/vB4dtTbI2JhzOEtaCaRbPIdzBPWpw6xPxmoMqOamTs6FaNC8EiR6wqvTp23
	6grj2/p0YQjC3Ram33nLX9RFW14A/iY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788171122;
	b=4rJDQpukyyNfXi4lzK5nhTLnMNv+QPq7noT84cqWMTs0YJ9lVCJcyIFYwINPSHuRTTGH3z
	evOSQ6M99kvjISCecUfOUMAgGkLJbwCK2hJRkcIpdOaY+1hpUxPGNkCkcYn1ED8aui/5+x
	VQCxjQvQzl/Ixt9Y7WUWLRjKOxCidBo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=A1cs8iP+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=xjG79jMA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=F+W7yegO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=o4nK9Cvo;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 481B11FB86;
	Mon, 31 Aug 2026 10:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788171116; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L58Z7+BXjdSqb3Vh9n8TDNy2pZxNZI0wP+OuP60u9BQ=;
	b=A1cs8iP+Nvyyux++q0vtbMa3kH8cI64Ua+JXZ3doMv37YUyN6i6MUwvKScUqv4zGOiMkI7
	0asjHhByYIBYKrlmWDoiALVvUNpDsELSmrdS1USnP8/tEalHdoZi5+h6Z24vA9kyVtLcpV
	rNxkPYv1HgsK/oxX4nBFrN3DA0IXaOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788171116;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L58Z7+BXjdSqb3Vh9n8TDNy2pZxNZI0wP+OuP60u9BQ=;
	b=xjG79jMAZv7ON1n3tUBENQUqE/7TTqLmTnH+VeBN7NN4zMK43kKnRIFXyBdPEaRq12IcEl
	Fpi9bK3txwfCOEDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1788171112; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L58Z7+BXjdSqb3Vh9n8TDNy2pZxNZI0wP+OuP60u9BQ=;
	b=F+W7yegO8lF8Zxf8amh5VWl6oahxp5Hh6GwJLyL/oKyRWViCy1g0WLDkRWUrSGrEiVOZiY
	RYWcFc0LIHfuMC+s0ovTElTgB1fzA0qhPB52C0MwARE0f/73BFUC3CtiFoe0jMzqytECQL
	QDjGbU1OEohAUkq3r3ybPCcbLXaawVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1788171112;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L58Z7+BXjdSqb3Vh9n8TDNy2pZxNZI0wP+OuP60u9BQ=;
	b=o4nK9Cvoz6WVPfkrCSBPa+eFBQwLBoRiLh9TgJmTbXQL+N79z47Fy4WidY40CcLTKJEZ7X
	T8j1Yzcrdhfiv3Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2891C13682;
	Mon, 31 Aug 2026 10:11:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bZnlCWhTlWoXfQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 31 Aug 2026 10:11:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id B8034A13B5; Mon, 31 Aug 2026 12:11:51 +0200 (CEST)
Date: Mon, 31 Aug 2026 12:11:51 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Christian Brauner <christian@brauner.io>, Jan Kara <jack@suse.cz>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, linux-erofs@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, ntfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/9] squashfs: Remove use of FGP_NOFS
Message-ID: <kg2pupprlig5gqaqgjydpxfkrsi42bu2li6cingcmu3aidqhyp@afi5wxdrauk6>
References: <20260830041901.2668-1-willy@infradead.org>
 <20260830041901.2668-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830041901.2668-8-willy@infradead.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2C2218000B
X-Stat-Signature: e6yfoyym4d8g8rfn6o9t141kc13d7qjk
X-HE-Tag: 1788171121-121846
X-HE-Meta: U2FsdGVkX19Odwsnu1+B/dpH0fPb+83qIWmuRGMZxrG0ydTjS7P0ckbdgKhrJLVZ5sJvbpTeio7tegoc3BBTUf2VIDJ/D5yuuvYfODE333VYXbGiFPj31nqz9ia5zYFkJHeSXa33cR88b0qaZp/IZqRtUVYxUPGpv3gp22FFN/fRNkIU3M/jKQTX7vPoLqmHzTJmdFl+Tn20+TdTGDYbEEC9BbHUiERrRxllV60LKf7dYAhnnlMdkq3HEczu8YOSurv9x/FR3FxeySXZ8LyHGhyFu1UG/HTNOG6E/iv6CiYsS27kfh4fHFV4UiaR7Cl1EVqwG+3/E/19tT0Czrbya1D7qsLpw22chXbEwbH4E4McnM47dk06+EMIRMLUXl9buefLpLXIvfPGAg6RCSwPzBXcs7o1HL7ruhNWHzagqYF5hvefjycHuHVNdMbv3f4X32j7ahn6cEqVVuikpJA+NSuB1p1zc/+TU46OYWUZD8nOmg2LAYzKGcfIfVY7JXplA+fiCd11k2S23kuRSrbjInEHE0vg7dTmyMLan3XOTLCvHZPYuiWRO8wsI/NEy8a5/MVAesAGzPQqX8+E7f85NKFmLmpWkIw+H6ewjjGHPfbfJYwixCosqSJ9MqMvPKq+4iouT3fiPZKSSnlNeCeZdfWp6KKVY3JYcWQtIIsR5NGhLodrm8NGarLU/RTBf7kldzjqTTzjsSWqSYkCBC3Svw7q3fPYLdbWTMalj35sTmrVFcHcmWgekkNLByeT6kI8pfCpGg/X6DEy5kll/4Xn16aGe70cz4XuTTfaYlvZVIztI2uwwo5mkzXrts08grgJQx6Y8phYW+IomymX6Zh+8tkUxSgSiU64wgFnAX85vwO+KGe/vrsHLsRAr2z/GFt2Jmp2goHmJFWij6UspK6Iu6cVQpmmn6XJ17ij8BIcIArlv5L/MDLas8XNPrJBjtIGdq8yDr5rUlu6cEWVchj
 mSZ2V1Sg
 ZPd86WQN1BUhrcXsMBrWnwpF2JB6XIKEx5wmaItwXDQbFbgb6iz/KkuR/jwv9ZYue889it9jDOa41D7/cmRPNiqr71bDdsk0U+TVlmSS6lBEKPkd0t54tpGNNFxQWWnAA00+U8z3L8MTT7nnxEWyDSZla+9SdXfIfjBq8Y9rjXrW2tsuLmfi9uP9ywATVngP1CsUjIMRy0yhWVqDmmjcFMEPt2Cl2gUau5w/BJPKdICaaoScx8ZZFeD6UEXqS+i2+k3ybJQ+Ya4TVhoyYq4q1DDvcexCDI8Xy1pAGBhWJzFauQGprNsQOXSOIrNgd8Alj7ZsquE1it1jVfo6d0AbTEqYgAzIkotB66RwpZ8uG97JquDLB+Gy9IgE4FXFEgN2VnV/6Fk1KQjBd8CCMNq9GFZ3DHpFJTGGRIGS97Uoc0fzODuXWYcufDJGxLHXTqkwaVqY+YjfwmGAhNyjznWXGlkD5pdPZqRPSTlFOETWFyKMA2LoFrSOWxsskELXfkVrlho6fypzU+zpvlwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 30-08-26 05:18:54, Matthew Wilcox (Oracle) wrote:
> Since we can allocate memory while holding a folio locked, we cannot
> allow page reclaim to call into the filesystem and attempt to compact
> the folio we're currently holding locked.  Use memalloc_nofs_save()
> instead of FGP_NOFS here.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/squashfs/file.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
> index d83594ce91d2..34c550a266bc 100644
> --- a/fs/squashfs/file.c
> +++ b/fs/squashfs/file.c
> @@ -398,6 +398,7 @@ void squashfs_copy_cache(struct folio *folio,
>  	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
>  	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
>  	int start_index = folio->index & ~mask, end_index = start_index | mask;
> +	unsigned int nofs = memalloc_nofs_save();

Why do you need this? The only allocation I can see is the one using
FGP_NOWAIT below...

								Honza

>  
>  	/*
>  	 * Loop copying datablock into pages.  As the datablock likely covers
> @@ -415,7 +416,7 @@ void squashfs_copy_cache(struct folio *folio,
>  
>  		push_folio = (i == folio->index) ? folio :
>  			__filemap_get_folio(mapping, i,
> -					FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
> +					FGP_LOCK | FGP_CREAT | FGP_NOWAIT,
>  					mapping_gfp_mask(mapping));
>  
>  		if (IS_ERR(push_folio))
> @@ -430,6 +431,8 @@ void squashfs_copy_cache(struct folio *folio,
>  		if (i != folio->index)
>  			folio_put(push_folio);
>  	}
> +
> +	memalloc_nofs_restore(nofs);
>  }
>  
>  /* Read datablock stored packed inside a fragment (tail-end packed block) */
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

