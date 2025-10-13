Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA155CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 439E48E001E; Mon, 13 Oct 2025 07:33:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411918E0007; Mon, 13 Oct 2025 07:33:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3282E8E001E; Mon, 13 Oct 2025 07:33:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 227DE8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:33:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE1CC13ABEF
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:33:05 +0000 (UTC)
X-FDA: 83992879530.14.9132D0F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8704540008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:33:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeF8rY9Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IpA0k+fj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeF8rY9Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IpA0k+fj;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760355183; a=rsa-sha256;
	cv=none;
	b=6G/IUKLlGOnCcmul7ueElp4rRy3ujtVI1Tr8bc4f0+hIGXvNzW1H8icp0a3F46x3v9rVlQ
	MZv5M1KCX64rhSACmCX5fZEOeK86E54+HcKLk6OcEQXH6byg2W+AHLuIR6eUT56eXE/8dV
	tXEWrx8DCjfLXMdO7ZY7/5xyo51y1zw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeF8rY9Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IpA0k+fj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeF8rY9Q;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IpA0k+fj;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760355183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjA3pivDdgLh9qrZtx0E12mcR60zwdtloy+2zU3PjFA=;
	b=12nqTjawLDj9p4YXvPZekHW0KEEw+lg/haKfRFSDHRmQ0FG7eu0j1FZbKUvajgE0NVeuSf
	Dfr91aIHakC8iWs9c/mtkK9BuixkMKp2guLD3qfQTFEYzq2Vmo3ASbq5lQULrCqBhmDUgP
	WGo784NL80N0efWJuYbs5+iNScJ7bvs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B3DC61F385;
	Mon, 13 Oct 2025 11:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FjA3pivDdgLh9qrZtx0E12mcR60zwdtloy+2zU3PjFA=;
	b=oeF8rY9Q/Uvu8apVgpQdJlOswy7dt6UocwzUR/f+RTfPqKYiFHdKQrp+6FmfQF9c6U3/0B
	pICPq7nBPvsZNxODAgH7yZi++Fj49s8yj4UnoeOpx6L4YdqIaIjf5Mhphg7fVPhaDBej8p
	guZHc4SNPIId/TkGmVg3FZLrGrLcVAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FjA3pivDdgLh9qrZtx0E12mcR60zwdtloy+2zU3PjFA=;
	b=IpA0k+fj4k/tvd6VNkefE1txs1XtfoHuTIEMXxBUf7MHAXbZy0tcwybjvJrMId+YC1NFQP
	t3pkXSodL9ywF8DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760355181; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FjA3pivDdgLh9qrZtx0E12mcR60zwdtloy+2zU3PjFA=;
	b=oeF8rY9Q/Uvu8apVgpQdJlOswy7dt6UocwzUR/f+RTfPqKYiFHdKQrp+6FmfQF9c6U3/0B
	pICPq7nBPvsZNxODAgH7yZi++Fj49s8yj4UnoeOpx6L4YdqIaIjf5Mhphg7fVPhaDBej8p
	guZHc4SNPIId/TkGmVg3FZLrGrLcVAQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760355181;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FjA3pivDdgLh9qrZtx0E12mcR60zwdtloy+2zU3PjFA=;
	b=IpA0k+fj4k/tvd6VNkefE1txs1XtfoHuTIEMXxBUf7MHAXbZy0tcwybjvJrMId+YC1NFQP
	t3pkXSodL9ywF8DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A546C1374A;
	Mon, 13 Oct 2025 11:33:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yvhYKG3j7GjRZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:33:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5C0D0A0A58; Mon, 13 Oct 2025 13:33:01 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:33:01 +0200
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
Subject: Re: [PATCH 02/10] 9p: don't opencode filemap_fdatawrite_range in
 v9fs_mmap_vm_close
Message-ID: <5k34nbj3dej7ffoh3ihcqzaaamb43lfef3dyptwlhflzcu6nwq@pnkdrqdiwyx6>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-3-hch@lst.de>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8704540008
X-Stat-Signature: yhxcous5fn1z4xce5zesdqbfwo4dzqmt
X-HE-Tag: 1760355183-676704
X-HE-Meta: U2FsdGVkX1+1StjyDgCE/nvom0hIozz3bUfdGvmmwY4Ux10Al+RewK2VtK2NyB6dsKw4p1yZ+7HUCXI0MQjgPeBj+h/oXktTFkFDoPX5yp35PD3zGBUu7btIr9wnc2J2gUSq0vI/IDzYDao4tO6UTvxxDWAXxALndEBhxu0J7sxoMhHlKKVqu81mLbukFw1vppgllnbrEo79L2Babqy+0566Q2g6v7oZGuDyL3daOTIZeECQ9iMPVxnRSVl23AfFtvC6u7WUg1HA1UTW1vSb+q7XEUGsUHa1Wwtr+smM87BQCjbjRHV94RZhXCY9ZEPHDe+AKczA1DmTdxmIG6usqQEw9q/B+NF5z4RzYipb/vm9wV2ovHNrH6NMTcisFSXxXFMZ097HKmpZLekNmY1MB4JZFXAc5YlabfZZA/H6FNldc/QWItNy87m/cF+a2ElkEG1qozP4wOC8NFBLut2f7M1SrrhAR/pfKEiF03qyAPEwCZ7rRQcnYv4vFjzs/0yWNgS6tA2Co4eL2lbtPWuMtmJhY75A00E62xWyOLqCvvxiLGimcNJ6D/FJOvu7vlKgFQslmAsQ+qj21xM0nQ1JDQ1dE6cI8F8wqUVCJ22mHKSjq6p1NlvqHxBiudR0BaWRfG7L/ogunVZAUxyZQaAQgjZ6pvgRYFhQWrn29W8gdDa+2ty6tgA5V0tm4/xYO+fdb/KxiYr5/zXnZ3vo21y0JhqJTPWz+WD0+Oirslo5cZ2MWD5bxT8brGX8SX+2dplp3N1ri15ZVNZtNCuEcpalFEwfKfPCbJuykCdfQ51rSjoGUHlPdaFQYatYHcSaGKbZ6ccIscbWafUVqYhil5nWjkMMx1eWL+CBVeiY2KxLNe2Sx6zsULuA9UQ7vMOiF5bR71vRAt3O0Y4bwUdJdOYG3340A0AbpVQ7vU/8cr+UOOjQqq57M0MZP6msmA3P8X9v/GfxHHSSAIK/+iYp8yg
 1hdD6sm+
 rU3nLM9M2uDD3CELncDzlWScnItvzCOCI1JJm2O9z0UWKT6j0jrc9lXBQpawSofWnjUkkTUS63o9bm4VRcDxDjGQcEXIdG1J3d4rXOlQq2tFXjBtuv2EbKl5m6QRCjl6pHXcD92dASMrCVHaIDSNBEKHmVqbENDcdtsICx4NrHlfOQVU9HGXIFTgGx9sla5CDZTJeLpgqbpZaOFzeaS4LSnKyoxXUxGxho5GmaPFH2wl+qU8pbwvDgdlShAS58i94ef3JxA36QwUmZpN9fpQ45AAbEFpLzFmh3SQAT3G1sr8ruciz+6ziyolaYY+zJXgkE9XbecpPZHvi07jJMhLsaSZFI3+yMI3aH1bHAcWQhpJtuDLfkAKV6RFA7RBJPJkntz6gzYSJXSfbUV4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:57:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/9p/vfs_file.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
> index eb0b083da269..612a230bc012 100644
> --- a/fs/9p/vfs_file.c
> +++ b/fs/9p/vfs_file.c
> @@ -483,24 +483,15 @@ v9fs_vm_page_mkwrite(struct vm_fault *vmf)
>  
>  static void v9fs_mmap_vm_close(struct vm_area_struct *vma)
>  {
> -	struct inode *inode;
> -
> -	struct writeback_control wbc = {
> -		.nr_to_write = LONG_MAX,
> -		.sync_mode = WB_SYNC_ALL,
> -		.range_start = (loff_t)vma->vm_pgoff * PAGE_SIZE,
> -		 /* absolute end, byte at end included */
> -		.range_end = (loff_t)vma->vm_pgoff * PAGE_SIZE +
> -			(vma->vm_end - vma->vm_start - 1),
> -	};
> -
>  	if (!(vma->vm_flags & VM_SHARED))
>  		return;
>  
>  	p9_debug(P9_DEBUG_VFS, "9p VMA close, %p, flushing", vma);
>  
> -	inode = file_inode(vma->vm_file);
> -	filemap_fdatawrite_wbc(inode->i_mapping, &wbc);
> +	filemap_fdatawrite_range(file_inode(vma->vm_file)->i_mapping,
> +			(loff_t)vma->vm_pgoff * PAGE_SIZE,
> +			(loff_t)vma->vm_pgoff * PAGE_SIZE +
> +				(vma->vm_end - vma->vm_start - 1));
>  }
>  
>  static const struct vm_operations_struct v9fs_mmap_file_vm_ops = {
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

