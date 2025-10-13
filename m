Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3222ACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB658E0033; Mon, 13 Oct 2025 07:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882C38E0007; Mon, 13 Oct 2025 07:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF998E0033; Mon, 13 Oct 2025 07:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3FA8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:34:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 479CBB92B9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:34:53 +0000 (UTC)
X-FDA: 83992884066.13.93C6E6A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0EA74140010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:34:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VvBNMu31;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eIxwR+o+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VvBNMu31;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eIxwR+o+;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760355291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZruJ2vBh/q3aJxQpIVa0GdVinSL6t74qWuGCsK+kFcE=;
	b=COSJ1cLUP8gc7JsYS6DTLTJ9GghKBTEuZ/KbBwxXWk/bNi2eEx0ef4QrlztpwjlV4w3Lt1
	T08v3ZiPy48g5j2zCFdCeYA+GpZIaTwni9cu7sPwmr2N3kJHhvQJ40JtmJVe9r16GRluFg
	VR/pkTC5+MqPIYe/Z4h3finjRD0jmBc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760355291; a=rsa-sha256;
	cv=none;
	b=hY4cM3TFtopyPZc92yKVsnl400LJ0ueim15LJTkFtMDUH5nKSzKeSnAVBaqYqfxr30rHly
	gI5htU6R5zqRQyqgZUqzZbxOG5kK/ZKm1/bN9+gqqysm39J90+6eWgllQ1zfzK/gYch0hm
	tlZDxiDHSZ2x7vbd6reNdUf4t7N1DIU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VvBNMu31;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eIxwR+o+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VvBNMu31;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=eIxwR+o+;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C39321A23;
	Mon, 13 Oct 2025 11:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZruJ2vBh/q3aJxQpIVa0GdVinSL6t74qWuGCsK+kFcE=;
	b=VvBNMu317BLFpyXxQhUXDUkOIY2f93s7yBDExd2dJ1Wip2HTbvnMxf2pDOtx1jG+WwGmNr
	NvkgEtj8LFuUQbg0FgsMPMO61RbFJLm5BSFIoUa1LeqiLgGucURHQ0DrD2mFIlVHY/Cqi2
	pXVFeiJmkQ6m8Mq4xjYyrTB0whJQge0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZruJ2vBh/q3aJxQpIVa0GdVinSL6t74qWuGCsK+kFcE=;
	b=eIxwR+o+i99D6DbKhFQXkZC3sTtXrJ9ZPNH+LEnDSYsN/hrMWUAJh0H6bTqAE/+nRdMTEy
	GroDypH7K6FlH7Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZruJ2vBh/q3aJxQpIVa0GdVinSL6t74qWuGCsK+kFcE=;
	b=VvBNMu317BLFpyXxQhUXDUkOIY2f93s7yBDExd2dJ1Wip2HTbvnMxf2pDOtx1jG+WwGmNr
	NvkgEtj8LFuUQbg0FgsMPMO61RbFJLm5BSFIoUa1LeqiLgGucURHQ0DrD2mFIlVHY/Cqi2
	pXVFeiJmkQ6m8Mq4xjYyrTB0whJQge0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZruJ2vBh/q3aJxQpIVa0GdVinSL6t74qWuGCsK+kFcE=;
	b=eIxwR+o+i99D6DbKhFQXkZC3sTtXrJ9ZPNH+LEnDSYsN/hrMWUAJh0H6bTqAE/+nRdMTEy
	GroDypH7K6FlH7Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7623C1374A;
	Mon, 13 Oct 2025 11:34:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FcPUHNnj7GjwaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:34:49 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F1018A0A58; Mon, 13 Oct 2025 13:34:48 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:34:48 +0200
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
Subject: Re: [PATCH 03/10] ocfs2: don't opencode filemap_fdatawrite_range in
 ocfs2_journal_submit_inode_data_buffers
Message-ID: <cqprjkby6ge4vvcxmmxrdhngsbigp2mms4oqxaspai63dkuvgg@3wtgz7qgxgbt>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-4-hch@lst.de>
X-Rspamd-Server: rspam05
X-Stat-Signature: 4utj4yxpbuj6o7qtgpswohydi8caq6nm
X-Rspam-User: 
X-Rspamd-Queue-Id: 0EA74140010
X-HE-Tag: 1760355290-106660
X-HE-Meta: U2FsdGVkX1+FaqNix+pnRgwpygXtQZrKXG4EIgqHOswj+PZgezaCEfOTvhcAnc9SkzZBIrG4PdcC53DDCbt9U6BWZs6VoDUs8y/aKFFp1tH5ifioEpfEYvXnNrg4L8GSq+9+NxZy6rOhiH8bR8YVYkdXXHOpg21H17Ep8w6M5Wz3kIUKTWoxb+WpOf6qgzmoT6vrZkY7hsiLLd5p0scFcDf+Pap7UXzYpZVaBAxbRqdL3hiT9TYPLgj8JlRPyfm60UDkcVAIrum/A/bF+f70EkwC+fz224Ct6FL8CioWwIxDLvKlYc7rU3NQZ2cBm7EGG01LJXsJXmgTLBG6tvz1nAcZWMQOTtBbXIpoRmllV1yoTLWQ5lxAYCFQrw7eh/iERSR9kGk6jqSYfPZleSznTPX06kDVgWhE0DRANrsGJUErBJHVqD0TLFpVRfhGUlYm0mEnARis2NhXMxGw2zC/W0yqaidBOz6vEPHIgZ2Jx2zMfJede5JLvVkiFknwdXd+UBJLOLzVQwwsGo2udXip4S4uu5P1dd8QM6KO89UKVHiiZOYo70dY83q655BqjhljvBJ/0cpgVMYLdfiPvYOfQtcjhT3IHobyXYLq4IgJTr0YnkVywNL71Io6rhGANvcvF7ryy3DFzAouSvxtoq6j4fGOSMACrO9xPrdgAGXS0IAWr9X9H0pOTRMcRit2swyZZM+0EFAR9cOmDaR0ATl27UhWUfaS11K1cufaAW0QrjOX80qk1cJOQ4ykcpOwPDynnzzpaVKNYAgEH7PbEotD8M/SyRarQLugEJeGpW/x63EtrSaN02auma5Q161zf2OhxyZjzet56x5zxDfgJXo+rHI7B97AJG0fj8xp6pD4Nydxh5LfDCR8O5MBMHvuPDMprAY2O9urE0wdGIfRh5LJ+D1GQBepFemcQDcGGp77jm2gesQOgqX8ddLyevHhsPsoRATc5fO2Ka3ipH+px4i
 FHkLbk8V
 mEdT9kLoFTGoxOS9d2QFHc3YzOttP9xlVQI+ORjK9s4LQMGSJLkDaMbqobCyGZBXBu9qcJsX/fdVA+QdFgnnSEuPe2F1+QHXo2r3L61uUDRHA7bVvPE3fRP0w+9pbtDuQMj1F6UyGqHoq65SutNy0uNjrwNRHUfY3MsiJBLjhQwT/xEOXJDunDqyfUWsQHQVDjnPnoxW0t62EZ2L7D9FLhkwQSHOhfbSEx2bgbdpI7ZoYPPncccjSsEVfJBC9oW0Ff8MZMZDbPqaEPiqgID3FXDobEuTDi+69rHFBYfj6uy7KKGGkMy7ArXzPFrn9QSm+VKfsIB84Dzk/HeTjHS3zfIItajcFwfWjCmXs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:57:58, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.  There is a slight change in the conversion
> as nr_to_write is now set to LONG_MAX instead of double the number
> of the pages in the range.  LONG_MAX is the usual nr_to_write for
> WB_SYNC_ALL writeback, and the value expected by lower layers here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ocfs2/journal.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index e5f58ff2175f..85239807dec7 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -902,15 +902,8 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
>  
>  static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
> -	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
> -	struct writeback_control wbc = {
> -		.sync_mode =  WB_SYNC_ALL,
> -		.nr_to_write = mapping->nrpages * 2,
> -		.range_start = jinode->i_dirty_start,
> -		.range_end = jinode->i_dirty_end,
> -	};
> -
> -	return filemap_fdatawrite_wbc(mapping, &wbc);
> +	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> +			jinode->i_dirty_start, jinode->i_dirty_end);
>  }
>  
>  int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

