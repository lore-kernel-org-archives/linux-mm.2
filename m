Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 131F5606A33C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SApFq5WF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SApFq5WF
Received: by kanga.kvack.org (Postfix)
	id 39A946B05C3; Mon,  9 Nov 2026 07:20:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371A16B05C4; Mon,  9 Nov 2026 07:20:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288596B05C5; Mon,  9 Nov 2026 07:20:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBC136B05C3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:20:29 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BDF4160636
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:20:29 +0000 (UTC)
X-FDA: 85415488578.15.3C3F273
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68C2C20005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:20:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SApFq5WF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SApFq5WF;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794226827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcGWRSLO8Yfbujxln+iu8vgkMzCPp+fOVFLW3VDJHEw=;
	b=nGhZ9i0d1AyvCqmuhvC+kCJkjPQQMJG7h4NeFPukFdAXokLF1yqgWG0ZNKBd+t9/HjHIgO
	txvR3bJu65J3cwd5WPRdJV95e/HRFajkSEa6RAJHlgqUFBLCH2gApmOzeOaViwJJvZr4/n
	eZwFZSlfu9otZg5cH1G65mOebwLj3FE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794226827;
	b=dgH3ejIMr/6ekSRguBma+2Pyd95W0UU/ekX0NNoNV96UZnLJrDDeHjlMvPOaKsjbirCftn
	+STTku0FBvFbBDsEF9gwUG/bmuf6uyxBOzyXwI1eYW2s4hUV1pkTvtJ3HfjFtTWzjNC5+t
	Ot7jihdBCMjCUqA8+HtR5UudNuy2pcg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SApFq5WF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ut7+3u6S;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SApFq5WF;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B4F11F7B0;
	Mon,  9 Nov 2026 12:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794226825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YcGWRSLO8Yfbujxln+iu8vgkMzCPp+fOVFLW3VDJHEw=;
	b=ut7+3u6SWUn9H8Jk66vEquo6iEFh7zATkMxP+B0KrFpqdOTRAYkB5eSvqIDm4Rftcg06HF
	f7tCAJLzEpBvUUmWwknN84Sa+PrtyJG9nxQ4uagQy4WqPiSGG6MhXP7Lp3Tpooe8AZqVzX
	1EqRV98wGShKrD9PbU/12/Bb4A/d288=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794226825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YcGWRSLO8Yfbujxln+iu8vgkMzCPp+fOVFLW3VDJHEw=;
	b=SApFq5WFZKP1QJxdXVdmiFrXqZfJWpmJ9J498Q0lnZH6aJAC8jzrJFO5frmz50TRQOq2eL
	BC6YY8lV1FJQEoCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794226825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YcGWRSLO8Yfbujxln+iu8vgkMzCPp+fOVFLW3VDJHEw=;
	b=ut7+3u6SWUn9H8Jk66vEquo6iEFh7zATkMxP+B0KrFpqdOTRAYkB5eSvqIDm4Rftcg06HF
	f7tCAJLzEpBvUUmWwknN84Sa+PrtyJG9nxQ4uagQy4WqPiSGG6MhXP7Lp3Tpooe8AZqVzX
	1EqRV98wGShKrD9PbU/12/Bb4A/d288=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794226825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YcGWRSLO8Yfbujxln+iu8vgkMzCPp+fOVFLW3VDJHEw=;
	b=SApFq5WFZKP1QJxdXVdmiFrXqZfJWpmJ9J498Q0lnZH6aJAC8jzrJFO5frmz50TRQOq2eL
	BC6YY8lV1FJQEoCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BA5E13302;
	Mon,  9 Nov 2026 12:20:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TyZzEYm68WqqXgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 12:20:25 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E3A9B21FF2; Mon, 09 Nov 2026 13:20:20 +0100 (CET)
Date: Mon, 9 Nov 2026 13:20:20 +0100
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	lczerner@redhat.com, tytso@mit.edu, hughd@google.com, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: skip empty finite ranges in
 truncate_pagecache_range
Message-ID: <tbwekv4fqz3w74jgyy3pqvg3hvfi4erosgwnxwao5lwsrc7hp7@aaxxwdkkte4x>
References: <20261027211505.22044-1-dennylin0707@gmail.com>
 <20261104182700.88789-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104182700.88789-1-dennylin0707@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: jkbxy9peax4gddgtf71pnmph7bb4kwrj
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 68C2C20005
X-Rspam-User: 
X-HE-Tag: 1794226827-261366
X-HE-Meta: U2FsdGVkX1+sXF7aHdORTfTYy/ej6qXmy978Ys1oj/tzDe/UMubfYYE6iOTBVotwhhSdapPDBPdRep/jxpX251O7uEPTidU6gBcGHUN614P4egk4TzbiA38OQ+GfLDPd+teKiohijBHDHEVgVZzCF0hWJxgj2e7aj7iLtwmoOJZR60nh53Eks76btW8s6Lng0t8dtzRVmsplKmda8YMD2U/c2BjkA1p2IAggfUITYmENRuHdUrsU/oKKXqOXGfSsZHTM2T78yJpcycH47OEE5DtZUbSw+DyaU+q07A52e3UPkvtqEnaI8AEGfhfaipECZ6uNvAxCUKq27GWhcXSerCLUxyaS7qmCgVbz5JWpoKM2pzgi+0dhGYUeeAeDUtL+4Yzq2AQa8NGDPt3KpdequZxCptb5HRKueolYQHvPS3pwVBeGORz3wn/HnZQpR1rkugWd+SIWJhag/kOzOIpmluYzB9fxq4JWP1FTbyi7DDEzOT8NdJSRT8DN+M1wBuCHcxApY2rgrirk85uGj4lmo8RTfnZjGIX2Hioy0N07ND/ZmhQqguCIFdpNv/PFBFZpwPbbq3A+2RXpeSUIOvN+0RLd6UM0WVFVgDCBxDp3a3ArA87TwhaSIHcB/VyH6QnvDWLORz0tLocZ0bFZgloJMUa3TgwmnVUzf8yyoxIbl8FBJBDZ+V9KKNfQ3YXsrpJk4kSIm8fUODstOjgisasAPMtNMNQQQ2Iq1GAhb4CAKef8wFQ3s7A8JkprD2oSDDfsLTFNjVPHqTpjWwIhBaKio0pqdnoOzYO34GToVPcU1fWtfFbJB2HxOTQ9LtqIu0FZtOl7NSGXzvIT9DcHhGuXQYoTUC5cuafsthobaL98ZbyucGSwSPrfb0yH8ixiqL5/8RRxLg+rfDY+gJ19GOy6dpeNhMkLAnyPJdgQ5Mf4eigKz+UEiJy4wZbtsyIejxDEpHiJUZffuAKPaKEWmKe
 fq5wqDVj
 i9eCCKth29wzI+1LGCV1GhQrx198upQNUzEXKB8aJ7lyMxdXQmtP317b0eaXYp/0UTGIxdLlvADL669JnCtkS3UYdIPG1eEfspW4UXNAY2u3z+WlhDH2QwDV7PUOJW8lSr2lWxynAoM6pkjECgAPRe9uS/ag0rdGb2TjhasIIO8Xqwcz8dodjj0AC9Q4pyl6aTfByZ9PYVosuSWFOd6JQlZk28XIcChvVVfPEuq4kKQ8qkur5vOQwB/+VDrPh0ecr6QWLUTX45Xj/pZxig+YEey0ur3q5oNomwog6s/SlKyBjPfW/kx7oT8sqSd7TE7u6CwU1qgqC8HqlLVd8r/jSuquAJZrloZGXqmEfhSB7NA+JsjFc1G8QsT6nQLM1v3dwtawE/4cgiFVs5Cg90kpYk1yI9T8OhIf0BDjrpGsv8n8FuFGAo7kbMchMGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 04-11-26 18:27:00, Hungyu Lin wrote:
> For a finite range ending before the first page boundary,
> truncate_pagecache_range() calculates unmap_end as -1. The unsigned
> comparison then treats the empty full-page interval as nonempty.
> 
> For example, lstart == 0 and lend == 0 cause unmap_mapping_range() to be
> called with a zero length, meaning unmap to EOF. Punching one byte at
> offset zero in a mapped FUSE file can therefore remove mappings outside
> the hole, causing unnecessary page-table work and subsequent faults.
> 
> Set unmap_end to zero for these small finite ranges so that the existing
> unsigned comparison skips the empty interval. Explicitly handle lend ==
> -1 and lend == LLONG_MAX with LLONG_MAX, preserving EOF handling and
> avoiding wrapping in the endpoint calculation at the largest inclusive
> end.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Fixes: 5a7203947a1d ("mm: teach truncate_inode_pages_range() to handle non page aligned ranges")
> Link: https://lore.kernel.org/r/20261027211505.22044-1-dennylin0707@gmail.com
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Nice! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Compute unmap_end directly as suggested by Jan Kara, keeping the
>   original condition for calling unmap_mapping_range().
> - Handle the EOF sentinel and LLONG_MAX explicitly.
> 
>  mm/truncate.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 733d2713a87..2c1f4a6c336 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -945,7 +945,15 @@ void truncate_pagecache_range(struct inode *inode, loff_t lstart, loff_t lend)
>  {
>  	struct address_space *mapping = inode->i_mapping;
>  	loff_t unmap_start = round_up(lstart, PAGE_SIZE);
> -	loff_t unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
> +	loff_t unmap_end;
> +
> +	if (lend == -1 || lend == LLONG_MAX)
> +		unmap_end = LLONG_MAX;
> +	else if (lend < PAGE_SIZE - 1)
> +		unmap_end = 0;
> +	else
> +		unmap_end = round_down(1 + lend, PAGE_SIZE) - 1;
> +
>  	/*
>  	 * This rounding is currently just for example: unmap_mapping_range
>  	 * expands its hole outwards, whereas we want it to contract the hole
> 
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> -- 
> 2.50.1 (Apple Git-155)
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

