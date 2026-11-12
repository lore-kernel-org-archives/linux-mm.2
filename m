Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D772A606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Xer+SKnf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ABAXOl/I;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n2Uq6tBL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/IYPJ4AW
Received: by kanga.kvack.org (Postfix)
	id D452A6B05B0; Thu, 12 Nov 2026 13:41:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5306B05B2; Thu, 12 Nov 2026 13:41:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE39A6B05B4; Thu, 12 Nov 2026 13:41:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C406B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:41:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE3B5A83F6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:41:07 +0000 (UTC)
X-FDA: 85427334174.20.C2B9934
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id ABC7C40005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:41:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xer+SKnf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ABAXOl/I";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n2Uq6tBL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/IYPJ4AW";
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794508866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znMZ7NR6/YszQuPkJzBKuINXsXo8b7XNMf7NgTqswQM=;
	b=dgWTJ7EyMltzazLnPYSjD0x4GlFfSxSe78f9RQY/N1TK0rh32eK+wMLvNpV74V5Py9yMok
	2Afo1G0ZTwxlYXMR5yqarR8dUWLJOqNfsGWrV1YYDfb9YHHhGwSJutrw2gR5R3qkseehVe
	jVjtnx7zhgq3jawGVFONEY7baKst5Ow=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794508866;
	b=riW47id5hufJOD6NnRauo5bUWKneSkWmsykhuDN0K1QhsQk7IudMXHeL0HFaSvDa3UGzT2
	jbfPSBPNpjD9zodqBo2FH63H2NmZ9Lvjp8WoMyoBsyyfKvqWe/Ynq+ltjjh2uq8KKk0nzT
	JbwbLNr4VLw2VsWu0yaEv48iEOacjPA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Xer+SKnf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="ABAXOl/I";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n2Uq6tBL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/IYPJ4AW";
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 16EE321F6F;
	Thu, 12 Nov 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794508864; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=znMZ7NR6/YszQuPkJzBKuINXsXo8b7XNMf7NgTqswQM=;
	b=Xer+SKnfXtKA0r2HBJMEwYrkKmiTMQlvHLYwnj7DWg7E639+BPuNRUj6xja+KuuiDKEtiQ
	iRVToRsEy0XZ1+nbrIGT/DkfxtRvAZXEGferZBlSCjI/kAtbHwYICgjvD6d8+NrHogs8T7
	6To5ZO3HSUP7ONT/pGVd0g5Sm02LDQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794508864;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=znMZ7NR6/YszQuPkJzBKuINXsXo8b7XNMf7NgTqswQM=;
	b=ABAXOl/IBFMv8A6QcWIqId6viw0hK4qpYIOTYUS8OFeUKJw694QzNLqBGaoYfv1zHWK2Zh
	hFYccdVV/wxWFGDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794508862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=znMZ7NR6/YszQuPkJzBKuINXsXo8b7XNMf7NgTqswQM=;
	b=n2Uq6tBLVztNF4B/wsNj0QDn8VmW/gpUgKe56S+ix8oOenI3lvIfQtsgN7pALFLOUOGfUY
	DXFG+rvwCr/1DbtiLNl/USvtb/oIfi/M+5pCZNRa+QLiWGs3hk509kr6dYTzW6RvG7S4Ml
	L0bW0y6ViRwxSQtJbHYZaGZcnKoFahw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794508862;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=znMZ7NR6/YszQuPkJzBKuINXsXo8b7XNMf7NgTqswQM=;
	b=/IYPJ4AWbcndQSjG1CUMvpOXlmc0P4EgiEOWcieSTerKH3MlaTda6rEmL9pQk3RDY/Pmyv
	Zhq4z3ZWPft5GWAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CD25413432;
	Thu, 12 Nov 2026 18:41:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7Ub7KT0I9mrURwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 12 Nov 2026 18:41:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3ABCE22B88; Thu, 12 Nov 2026 19:40:53 +0100 (CET)
Date: Thu, 12 Nov 2026 19:40:53 +0100
From: Jan Kara <jack@suse.cz>
To: mohamedalibouhaouala@gmail.com
Cc: willy@infradead.org, jack@suse.cz, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] docs: filesystems: update VFS locking documentation
Message-ID: <3aaboixwh6lpo4s67dv7lssqj2vwlp4qp5cq2ysimqi36r3bm2@fb5lmoo33ktf>
References: <20261111160516.30458-1-mohamedalibouhaouala@gmail.com>
 <20261112162129.77610-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112162129.77610-1-mohamedalibouhaouala@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Stat-Signature: b5nfgkjceizhdhqsxbmopsbh3n1op4bz
X-Rspamd-Queue-Id: ABC7C40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794508865-200636
X-HE-Meta: U2FsdGVkX1+BqctyIkpxLVmmUjTTgLpBAp/g/3IiwkewQyVCysnwKEPER4BUS6Z2zuRm0cQ/Tlq6B37OzevshjFDpqtxFTSLLbWmB5vCnGL8ScESKx4K1uk7X6K7LgEn0j40aM3PY/qLhL6FAOgRH3w47lgAPIecI6Rtq6kQqSyFgLNFD+ZAJu2K2ibnNDczTrdR1wX8uUTHW/teNBclN/hJxaYbHY+DelZJEp2DfyCGPtQYM6KAKbrmM2SKCoFWhPd9DNpdIpFb1IyjDYlY5AvUMPwCyXjGFb+txb2kQF603W8adSZ2tkPkk1Yry59aG1f1ukDXTQPAVj38RR6NMPcxrQbPOdZO8Dgspajl55QW6PIlh8HQmA/gG63F3XDGrX69aFvC1+oXXmr474w51WXdD094/czglyqCQOO+6YBaNRVJz9zgFrLNVycUctHj6774TSOT3OnGQVSbm0WT/RbYKS+5VG5M6lrGhqoN8fo63WFVfQYiFXePL1FFvUDGyazihEMfxXwfWy5+spPJ3sRmWhF974oxLXUyqD0uamdzCqTcxi4T2yBXYPN5hId+NXplMTjI/8289VDJ3Pz0QWHqOrP8kwWjdAxtQtAr98vILXFn5cAsY/KuBHvAG1sOfPkQbjvd1q+8OrnquYy91s+YuvAe3GLlFm763es6Wwd8WnocYbm/aU5oiTh9/CuQaC/lu9Fv+2NlP6a8OIZqey+8BFJEi39jTBJ7nrVe6WxDiS4vi6yMvC+/ECLO1ZgB5isXuVml+eCS6aSAwoJHR695qYBouwKprigL2wysL9wjDq50/hL/f78XF9TzrfyI4JHzOUp7eLRyvs9mgix7f4uzYUnbSp7WCAJNjAGLddj2QdWO98xVWBWaVPao+BzQVxR5Q6QPv+GLK71nfZj+e8c4nq21rbOkLb/MCWH7X2eZ0qpW2/wfScbXrTwpS+vtYRZg3y6w3J//S0Uiwik
 dDxBL5qd
 S9jB2B1m1NqXxNs8+SkS+d+2hcrVGvVinA65e7+9SI+bbthsHb3FtwoBhFkiiTYqguSh/t9fMPlax8mqOVM+Upgfge8EAZn2vTVpbmx5XgW5cNco/jexstjtOnYlBQARpAMP1N4obW51M1/aokX3q3P9F1o22NRwJAdhO3WMq7BFCLaP3J5AtCXmlzxMYTbpXSE2/VuwstkShVLKJt4bwjuX9du0KPO/5L8DmLOANjbGImScxn1C5QYehF4m78QbPfOL45wBeaZ9TpdNLb68lFhotzeVH7nD44jiqxANN/2hR/0FIdtrZ3vzNyt/u+WB13kjRelklm8km2WsBQOng4aulIyErCC7+gIu/mp5ZOH8ySN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu 12-11-26 17:21:29, mohamedalibouhaouala@gmail.com wrote:
> From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
> 
> Update outdated VFS operation prototypes in locking.rst to
> match their current definitions.
> 
> Add the missing d_prune and sync_inode_metadata callbacks,
> and correct the signatures of existing operations.
> 
> Update the locking table to include sync_inode_metadata.
> 
> Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v2:
> - Use the contributor's full name in the author and sign-off fields.
>  Documentation/filesystems/locking.rst | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index f7363ad770c7..a6a011858ada 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -26,6 +26,7 @@ prototypes::
>  	int (*d_delete)(struct dentry *);
>  	int (*d_init)(struct dentry *);
>  	void (*d_release)(struct dentry *);
> +	void (*d_prune)(struct dentry *);
>  	void (*d_iput)(struct dentry *, struct inode *);
>  	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
>  	struct vfsmount *(*d_automount)(struct path *path);
> @@ -80,8 +81,8 @@ prototypes::
>  	int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  	ssize_t (*listxattr) (struct dentry *, char *, size_t);
>  	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
> -	void (*update_time)(struct inode *inode, enum fs_update_time type,
> -			    int flags);
> +	int (*update_time)(struct inode *inode, enum fs_update_time type,
> +			    unsigned int flags);
>  	void (*sync_lazytime)(struct inode *inode);
>  	int (*atomic_open)(struct inode *, struct dentry *,
>  				struct file *, unsigned open_flag,
> @@ -173,6 +174,7 @@ prototypes::
>  	void (*destroy_inode)(struct inode *);
>  	void (*dirty_inode) (struct inode *, int flags);
>  	int (*write_inode) (struct inode *, struct writeback_control *wbc);
> +	int (*sync_inode_metadata)(struct inode *inode, struct writeback_control *wbc);
>  	int (*drop_inode) (struct inode *);
>  	void (*evict_inode) (struct inode *);
>  	void (*put_super) (struct super_block *);
> @@ -196,6 +198,7 @@ free_inode:				called from RCU callback
>  destroy_inode:
>  dirty_inode:
>  write_inode:
> +sync_inode_metadata:
>  drop_inode:				!!!inode->i_lock!!!
>  evict_inode:
>  put_super:		write
> @@ -255,7 +258,7 @@ prototypes::
>  				loff_t pos, unsigned len, unsigned copied,
>  				struct folio *folio, void *fsdata);
>  	sector_t (*bmap)(struct address_space *, sector_t);
> -	void (*invalidate_folio) (struct folio *, size_t start, size_t len);
> +	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>  	bool (*release_folio)(struct folio *, gfp_t);
>  	void (*free_folio)(struct folio *);
>  	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
> @@ -265,7 +268,7 @@ prototypes::
>  	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
>  	int (*error_remove_folio)(struct address_space *, struct folio *);
>  	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
> -	int (*swap_deactivate)(struct file *);
> +	void (*swap_deactivate)(struct file *);
>  
>  locking rules:
>  	All except dirty_folio and free_folio may block
> @@ -455,14 +458,15 @@ prototypes::
>  	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
>  	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
>  	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
> -	int (*iopoll) (struct kiocb *kiocb, bool spin);
> +	int (*iopoll)(struct kiocb *kiocb, struct io_comp_batch *,
> +			unsigned int flags);
>  	int (*iterate_shared) (struct file *, struct dir_context *);
>  	__poll_t (*poll) (struct file *, struct poll_table_struct *);
>  	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>  	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>  	int (*mmap) (struct file *, struct vm_area_struct *);
>  	int (*open) (struct inode *, struct file *);
> -	int (*flush) (struct file *);
> +	int (*flush) (struct file *, fl_owner_t id);
>  	int (*release) (struct inode *, struct file *);
>  	int (*fsync) (struct file *, loff_t start, loff_t end, int datasync);
>  	int (*fasync) (int, struct file *, int);
> @@ -475,7 +479,7 @@ prototypes::
>  			size_t, unsigned int);
>  	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *,
>  			size_t, unsigned int);
> -	int (*setlease)(struct file *, long, struct file_lock **, void **);
> +	int (*setlease)(struct file *, int, struct file_lease **, void **);
>  	long (*fallocate)(struct file *, int, loff_t, loff_t);
>  	void (*show_fdinfo)(struct seq_file *m, struct file *f);
>  	unsigned (*mmap_capabilities)(struct file *);
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

