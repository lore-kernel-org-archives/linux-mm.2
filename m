Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16236CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7329A8E0039; Mon,  3 Nov 2025 03:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709628E002A; Mon,  3 Nov 2025 03:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61F4A8E0039; Mon,  3 Nov 2025 03:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50E988E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:14:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07CEF160A84
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:14:19 +0000 (UTC)
X-FDA: 84068583438.01.33F140E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id A189216000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:14:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VQ+j7uxN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ILcOvWE3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VQ+j7uxN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ILcOvWE3;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762157657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCdxGDoqhxMX2on1WCoiMvZKcJKb7d7apOzd7GJhudg=;
	b=XaGwlo1WvBKPLrTn6tvdMsN7U9ukYBFQs3hjf3u0LLhBGNndGARtjBKfsafoFZaFvhmT9d
	T9uiLwty+oKmlNYA+FzyZEQm3jPFIcEknpUBcksTg8aT7KsESu/XWmFL6WrWmB98vQBZpz
	2Ahm7Xzs01UAMpRFvcqMoOQjm5dg+Qo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VQ+j7uxN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ILcOvWE3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VQ+j7uxN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ILcOvWE3;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762157657; a=rsa-sha256;
	cv=none;
	b=K+s8prhbRpL4RraQtA2QX5p9vtjuB6Hm8TvZO7LKqqnz025F+VGmfDwhApIuSH03pwa3nz
	gOSYdWFvsrjdbJiRgaky0VtHi30BxrCfCeKvbCQU+IHDlekPBUxpe1uBjfFxtQ5CLdA6N4
	y3Pl8RpCqddW+r7m469XngPrsCUaC0g=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A075B21EC9;
	Mon,  3 Nov 2025 08:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCdxGDoqhxMX2on1WCoiMvZKcJKb7d7apOzd7GJhudg=;
	b=VQ+j7uxNDcVsNPTHd3unaB+kEhcNnjs6bCHaF5ZxN9bXsiexkAeteKfEmlgA4MgQTwbgxa
	X3oBxfZVFo4NfcWRmG/LUEHk7zkbH7OX4zoNdm+vgbzjXP+Ppdj91X4+Ufa32ldnR2kdWD
	J7GCM/W+E1rZlUfHDFKC4y/9qmBGZYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCdxGDoqhxMX2on1WCoiMvZKcJKb7d7apOzd7GJhudg=;
	b=ILcOvWE3ko+Lu34V3dlOGO/OykohZmnSXALd+aOofNHRb+gfNSERLcnFd/Fk5p3Clu1xsN
	By3x0es9kLP96JBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762157654; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCdxGDoqhxMX2on1WCoiMvZKcJKb7d7apOzd7GJhudg=;
	b=VQ+j7uxNDcVsNPTHd3unaB+kEhcNnjs6bCHaF5ZxN9bXsiexkAeteKfEmlgA4MgQTwbgxa
	X3oBxfZVFo4NfcWRmG/LUEHk7zkbH7OX4zoNdm+vgbzjXP+Ppdj91X4+Ufa32ldnR2kdWD
	J7GCM/W+E1rZlUfHDFKC4y/9qmBGZYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762157654;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lCdxGDoqhxMX2on1WCoiMvZKcJKb7d7apOzd7GJhudg=;
	b=ILcOvWE3ko+Lu34V3dlOGO/OykohZmnSXALd+aOofNHRb+gfNSERLcnFd/Fk5p3Clu1xsN
	By3x0es9kLP96JBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E7321364F;
	Mon,  3 Nov 2025 08:14:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qa3DIlZkCGlZYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:14:14 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0DE2A2A64; Mon,  3 Nov 2025 09:14:09 +0100 (CET)
Date: Mon, 3 Nov 2025 09:14:09 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 07/25] ext4: support large block size in
 ext4_calculate_overhead()
Message-ID: <qmsx753xemvacoaghwhv6emusazmlynv54qqxwsdfsoaoeqre4@bp2lgrdufaim>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-8-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-8-libaokun@huaweicloud.com>
X-Spamd-Bar: /
X-Rspamd-Action: no action
X-Stat-Signature: y7bxu3qcuh44tgwgmtqwejagfk4pjbsp
X-Rspamd-Queue-Id: A189216000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1762157656-385932
X-HE-Meta: U2FsdGVkX19zoA1CVbB9rsjzxGPGY4ynSpTi0gI+sB2NEU7gq5zpdGQtKKC5+PfgscCPxLxbySvo13cpJfQRuevJwrLNs++HxL5g9bQj72U5VDC4oDuwkCnVediBkdoTkMrKbWlQrLhEtO879pPLPHhJwmsBPKL1xIt5xb1J8PuqmKY7wi4tY6eVNG9FUdC/PRxvKgx4CErTbLOraXEYC7o2CgoHON8Ak26sqE+QYEthEtYFCik1IEyE+jDLP78jDmSJTdAvLjyC7NjAxrEdsfBN6q+gZ0iyV4h8A36B/C+FnVXlN9Qsragl1kfrsMTWIA7/BPWGyD6eQfPWW8342EKrqMD53g9osF7Xj8F1a5m4yjZKKv/um7GvX5KNJKi1otLeSKqdi8SKxF9XuZ72sdARQhZdv9HWYaL/raftYo6L+Umu77WLIG4l0kGfz8pythXhq5F7p4P2Md/8LW/W7h4zjsqOd5jrNy4oxzjsmfmQCamQd16hUiXMquRUsPI5RYGotkSMG72rlPVIDiptjafEc78mtngu9OLIOnYz0ycXZg4cZZw/zFoa5NezufRlbn6MNO9NtPQHAVD+VZMPwhoirtSi6C4NdzmE2CK/N7o/clf11181ozy1zTdKNkJxyReaLefws4nDDTK/chacaUBxl60YQ5h0qX4cR5mQ3Cd9c2CvaKHez5BsGKtW3ISIAGLu/kSf477l7kYdvTVtbQJvedvAuXMBjJmQ3LakaquG2nDiMCxegmAivN5woRoW0CxHQT/92wqk5mbN9HH5zdA6mnGCZXpMmlh5OCdCAOcTKtGeEYcQrS39Gx5CGy9Tk1ELVVtyZjsyBsbfHoz0Tn6hlbC2UHJcuRbfn4FqPoBH1eQTocqVnujkEAjpgmXuffxvfbWT07eCNUtR9cYV4GXZsoZItWAqJtJgflMuiCr6j40ciNa2Ii4mqyxGWkMHPusLymkI33edeMp63D9
 REJzsXmj
 begbqgnpn5Fl7RcnZ7395pD464zWkS16tw8+NO2Z3sH0m1DihzxTvGvLtlO8qTLpaexvvXk1NbecDICTwbAupYpC0BNoeJ7Mvy89QKOwewCVC07bnY3M0pOV5OQse6JLBDGHHvhRCPBwkNgrEecNP0QsMf62wcSwY/DZWsM5YTd9Tw8jaOG3jq5BdUw8Xy+2jwyp0GLPj8JXIGvDT9Hvh7L+qsqrYhWSOgbT7l8RAdZpVUx3VKiuqM1PzSmyuU147ZKgSZjdfVVEUXOZmdO36fGgvYaQLw/A+RwzU3dLSmGmNB06hhN6RO0c/GYlAQgskIw360D/fMys/94BZMHcwb2euuyt6zpe8x2EWw02c5CW8N4bzemrgzK9//xYupVOFkDj5jhmU52n569V3+V/sY7k/FRY7x8xCuUzvJgyA2i5EHd9ciuoXjSUJvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:03, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> ext4_calculate_overhead() used a single page for its bitmap buffer, which
> worked fine when PAGE_SIZE >= block size. However, with block size greater
> than page size (BS > PS) support, the bitmap can exceed a single page.
> 
> To address this, we now use __get_free_pages() to allocate multiple pages,
> sized to the block size, to properly support BS > PS.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

One comment below:

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d353e25a5b92..7338c708ea1d 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -4182,7 +4182,8 @@ int ext4_calculate_overhead(struct super_block *sb)
>  	unsigned int j_blocks, j_inum = le32_to_cpu(es->s_journal_inum);
>  	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
>  	ext4_fsblk_t overhead = 0;
> -	char *buf = (char *) get_zeroed_page(GFP_NOFS);
> +	gfp_t gfp = GFP_NOFS | __GFP_ZERO;
> +	char *buf = (char *)__get_free_pages(gfp, sbi->s_min_folio_order);

I think this should be using kvmalloc(). There's no reason to require
physically contiguous pages for this...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

