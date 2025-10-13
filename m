Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12CDCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFF58E0008; Mon, 13 Oct 2025 07:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7F08E0007; Mon, 13 Oct 2025 07:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED7C8E0008; Mon, 13 Oct 2025 07:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1A98E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:32:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9673D13AC32
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:32:23 +0000 (UTC)
X-FDA: 83992877766.25.1A075CE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2FA62180010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:32:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c2pY3Q60;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PKyKaGFX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c2pY3Q60;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PKyKaGFX;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760355141; a=rsa-sha256;
	cv=none;
	b=updNacHJ1bRQOpLdTg2/8Kr48k5/RlqmXnr0hbrRqUbaKNUBNyw2UAR9Mt3t9v5os+4sTl
	J8Lcn+jT3IyLWT3dhC4GgKssDcOa3uxRpDMxpfXRfLAfLxNELQ//LVS3Vnt5wpPOshYHCE
	prxPhSyBvjWzx4B7m0N8KQJlpIMzlkQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c2pY3Q60;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PKyKaGFX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c2pY3Q60;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=PKyKaGFX;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760355141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJD2D5sOD1UwFVRnLiisA06ok66jFshkpFT7U5auYaU=;
	b=wmOeFbfNM70QadzeaFMMZL8eDZaF1NkHibkNePQKHNiU2h1VkAThbvztWwugkgBmvb6+8D
	WMZYOnOdtVZD0R5y5F4G/Ta0nMfqA1ko+TGyqyF12logTY+gi7c1tDPgyNA5VknzvJfID5
	8VN9CG8h/yqR5NC2rTba4pli47/6/Oo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4135121A0B;
	Mon, 13 Oct 2025 11:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJD2D5sOD1UwFVRnLiisA06ok66jFshkpFT7U5auYaU=;
	b=c2pY3Q60rdySkJnHio1esw2RtxdDS1I/ROgZuToYDooNtM5rlAyGD3QtN3IG5Biyk9zkDd
	okc+vn2gfnqpE+l51QceqRYB1D59POM0BcYhL7iEbOXycj1ovhLT9DyS1f8xJx6reFNUId
	CuxNanTwAusOc1HkfPI2SLlSS1FzxMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJD2D5sOD1UwFVRnLiisA06ok66jFshkpFT7U5auYaU=;
	b=PKyKaGFXDxUdTiiurMffn9aZFLjkmr8MgiOPS9YDScwKazJYvsQqAb+UV2lM1fMEPkFYXF
	1HdhYBXBMD1JZjAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355139; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJD2D5sOD1UwFVRnLiisA06ok66jFshkpFT7U5auYaU=;
	b=c2pY3Q60rdySkJnHio1esw2RtxdDS1I/ROgZuToYDooNtM5rlAyGD3QtN3IG5Biyk9zkDd
	okc+vn2gfnqpE+l51QceqRYB1D59POM0BcYhL7iEbOXycj1ovhLT9DyS1f8xJx6reFNUId
	CuxNanTwAusOc1HkfPI2SLlSS1FzxMY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355139;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OJD2D5sOD1UwFVRnLiisA06ok66jFshkpFT7U5auYaU=;
	b=PKyKaGFXDxUdTiiurMffn9aZFLjkmr8MgiOPS9YDScwKazJYvsQqAb+UV2lM1fMEPkFYXF
	1HdhYBXBMD1JZjAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 327D61374A;
	Mon, 13 Oct 2025 11:32:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id C3H+C0Pj7GgJZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:32:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CD496A0A58; Mon, 13 Oct 2025 13:32:03 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:32:03 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 01/10] mm: don't opencode filemap_fdatawrite_range in
 filemap_invalidate_inode
Message-ID: <wxziorjgzpc5nlktnl53ctsroriqvwjkuvwsgznl63oeid4cvp@p7mkzimdgltg>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-2-hch@lst.de>
X-Stat-Signature: 5sk9iez45n3egni1wp496wmdjrj1a9wg
X-Rspamd-Queue-Id: 2FA62180010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760355140-444329
X-HE-Meta: U2FsdGVkX18B1A1mQbwiEF2jKZFNJjeh79I5tBOzbusInnVCHIVkT4XIbkjTLDLZHOzbtg3zhNbd8jrreK/6ebrR10QaHxWjPOkJqSAtGAj58myRenG0HWan7gwkHr0pvTt22FbKqAwvHR2sEifLpdPwR3/CfSbcGO/j40wWpmOsZKHE2Hz7WTwa85wADm4uhZsezZE5A3OPT2Vv9jE+tPYUUfa0HWGQe07VPDsfCK1nMHtEJQiVTn6xiCpPsod7suFpgEX6k5Cz8oJRTWKqGYb3cj73VJ/s8fxj2nXwXG6fQkE0PUvp4NrYcRMH2fVgRUtyeqCCx4G4V3omw9KHz0d70sZZLot6yzfQIrSTzH4y2+Zk9D8Dvmoj5p5EB45aMxa8bdy3tMeU0kH5PXtIcmYc+D7M1mrPkzd3Ka2dvONsDfdfGLNb7nOFk3uilnbjTLZ+w125OYeCh9ZSQpZnN+OsvGq1QfSzN9pJpEOIgjOEubU3UwBHM0JW7F/Oo3DYl4BGJeC1D//JHxTj+eYd83pvMmfaiTg9dhxDU+qITaXvo2r+a7OvS9NaA54CJH0A1V3Lb7drAtbG4mnHBXMxzbZNdEiF0SkqYaDYhG9BANv+rs8EcbueDWmggLLQu5/lXarK3hDS37wO7fOnf8uZ6V8BecIEfvO8FAQMpIBjHU1+D1CGq+dCObEN5fEd1TLir7NTGe6WJEVsKdKof2v/yiGWOSfE6edA3wX7zHX9SAAIBXdIUaQs0CIO/quLyxkCGU015teASz+LsoRrfhFn364p5qkZnZ9h0XF24ss0dvlKLAOoJHb347dyFxhhCZq+xcRtZR8J3J7zTSnjbqBJeZ09isFJEHjh4QFw00xmi7ZaYFf0AwXe2MhdIU/vi1uaOfyQvBoJJuU72ILB2/tlRD4tB1EOMWfK/ObTXHwcarp0OmYHYR5zeWyxww6TAGlOnOpzTsdolIUl7UDYfXC
 Oe+kYSfr
 wSmu6L6qWSdOiqpwzmepMyh41nWu3X/DZyM/IK1EaHkXYkve8ib/3t9kQk50hJPLJUpQD3JoJAx81wK03pb9pN/GETVDlqrs6uuamSFDaaTnY4ELZMN+ssLoSUTtQw2yXonroyrVui7zd8hph3qWA0jy4TyrKMzMmfKyB05cSXbz+YWK/FZCXStJRMRqXaX1jsP/h99S15qgpwbdl2uVjHQssvzsT27Qvw0BTlj016ubG9rklTBCzGsogerlVrbaKbsRUFjNmDnlkCtJ3JtYm+vExswk/Yg3ceP72aO/wNTaonMU2PG+/qMT44Vh43MWamA3hkP/d3GILteY0Lifk8rZbDGd8J7wATSN2v6Sazf825ZREhIlJFgocc5WFzdBjU10ylbj7xtzlltY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:57:56, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 13f0259d993c..99d6919af60d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4457,16 +4457,8 @@ int filemap_invalidate_inode(struct inode *inode, bool flush,
>  	unmap_mapping_pages(mapping, first, nr, false);
>  
>  	/* Write back the data if we're asked to. */
> -	if (flush) {
> -		struct writeback_control wbc = {
> -			.sync_mode	= WB_SYNC_ALL,
> -			.nr_to_write	= LONG_MAX,
> -			.range_start	= start,
> -			.range_end	= end,
> -		};
> -
> -		filemap_fdatawrite_wbc(mapping, &wbc);
> -	}
> +	if (flush)
> +		filemap_fdatawrite_range(mapping, start, end);
>  
>  	/* Wait for writeback to complete on all folios and discard. */
>  	invalidate_inode_pages2_range(mapping, start / PAGE_SIZE, end / PAGE_SIZE);
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

