Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F451606A338
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=EW5Ileb3;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b9picHqy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OFN2D1gz;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=7KQUoylu
Received: by kanga.kvack.org (Postfix)
	id 2816B6B05B5; Mon, 23 Nov 2026 04:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2599B6B05B6; Mon, 23 Nov 2026 04:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16EC96B05B7; Mon, 23 Nov 2026 04:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E40A66B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:42:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C46E40851
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:42:35 +0000 (UTC)
X-FDA: 85465893870.24.4CB80A8
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1C3540003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:42:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EW5Ileb3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9picHqy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OFN2D1gz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7KQUoylu;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426953;
	b=eMIIH/JbwLbNazZk/S05SKo4XVQ0ZwsBVlj88kqvyxJkTcBtBtWh3dADcG3p6/drJMsOCL
	iAi/A0N8K3RtW24LqCRKwBFftGl9ACCGEjTVEAbPKCyxJMzwpW0m2QVXVyAGoEDuQPLLzf
	0N4Q4hge28GTwEqQBQEFC0J+pPSUVJ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvCWU9Iv8odu+Rs1CgOY6M/umivWHTgBDs3E16pGEqQ=;
	b=6kz6I/i/Q5CBaPxLcymLbAhKjoR0wQQVjSagv4fhasrSaBVpAkGZh+Ztm0grYktHffbuyw
	Y4sgBlBpvo+H1zTN2BVSE7L2DiKK83j7TazJ5hw+PYcJmxemxpSkV+li12hiCs7enyTc8G
	+9cgzhp4ygE0LtQiy5QxXLxo7AuJoT4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EW5Ileb3;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9picHqy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OFN2D1gz;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=7KQUoylu;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D356B2207E;
	Mon, 23 Nov 2026 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795426950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YvCWU9Iv8odu+Rs1CgOY6M/umivWHTgBDs3E16pGEqQ=;
	b=EW5Ileb3N48lEmOuXkBkQe+62OpRGoDNXehAalygn5wUGdWRIu48+KI3W62bBwUeQHzYBr
	UBUSzmtTrMUTVwdd1VtFMF2ZK8rFcOM2mF7/jFYpqLHOzJsweGUVlVkhJBhRJII9pgOb/K
	dp1Ems1L8QrVP+O9K0HXyR6QP6pt4is=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795426950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YvCWU9Iv8odu+Rs1CgOY6M/umivWHTgBDs3E16pGEqQ=;
	b=b9picHqy/1rFyJmomYPI4g0NvBr/UFuZKh4Kd/gRUI4nxvRiFLnw9Kv7qn8L6RYKcxScHx
	b/C0BGbHPrbQZdCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795426949; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YvCWU9Iv8odu+Rs1CgOY6M/umivWHTgBDs3E16pGEqQ=;
	b=OFN2D1gzboolUyPkbDOGmwVPURrJliSGoQF+RfyAr7Hql8zv2eiN6+RjQsZUJ1BHXo6FMB
	v9Z/IzUreY6L0tautkHHE27/rt1X0QtXWQ+vGn53a3Iw5EPqypXsybdKsFKJV7oVJCE+2M
	VJ9YikQMw1opi+NQSh1/IJWc5ljdJzo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795426949;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YvCWU9Iv8odu+Rs1CgOY6M/umivWHTgBDs3E16pGEqQ=;
	b=7KQUoyluYmiflR+QYzyDSwJccd45gjYeKY+l59Nx9gSHvKYcMlWoxao7f1P2fpQt/cHpXO
	wfMfBElL9KQNpXBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6EEE1352B;
	Mon, 23 Nov 2026 09:42:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IQ4WIIUKBGu/MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 23 Nov 2026 09:42:29 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 3506D2762B; Mon, 23 Nov 2026 10:42:29 +0100 (CET)
Date: Mon, 23 Nov 2026 10:42:29 +0100
From: Jan Kara <jack@suse.cz>
To: mohamedalibouhaouala@gmail.com
Cc: willy@infradead.org, jack@suse.cz, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] docs: filesystems: update filesystem type, superblock
 and inode documentation
Message-ID: <p7wf376fhejkqtke2l6jxwzytlhiiaidjdaeapw36jxukbk2qx@kyk2wc5mhurn>
References: <20261120182207.97249-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120182207.97249-1-mohamedalibouhaouala@gmail.com>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Queue-Id: F1C3540003
X-Stat-Signature: ygrcw3e8gmcjpepgjrgxfpk8bg4s9gu1
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795426952-872499
X-HE-Meta: U2FsdGVkX18Qy3Ye4ikmhtJC/07HYeYR1s0E0JuJy5osXl1avYYJcV+2YouZdQt+zGK+orrC+319Sjs6DbdtZbmco2JXznq2blDsbpmMKhEOY58zqLmJrKPsl8G9f18wIbLYaltWcpoJvg801YQqdM8xRcDKKVOgQZM4NmJeJJGNQYlolylSAXaRZCkfd2unKAVF1XHaWHdLhgJDWnDwXLCz+bJnLRL4ZAjFAGQwyFHjI1sPQafZ1uMph7pJNY0F9Jl/a2zrHwe613BXYps0gPJQ+wxWQRJpI+/o6pOt3j1KAlPmIlFAluk5u29cGHvLn9moeG/Q8ZB9CD+J++uQGI+q9blIuQspBGxpVKS/SRXPvDzxEako1ibqiGOx5hoYIikwx/snbzCu8BIVqtw0rgtBGnK4VoYYYcrEOaZ/wmULQbvvY3+qy9lkG7oASsoc/vBsc8d645YciNY2/W2OjucZst6it7MlWHWgIVzByq8gXV9tOH9VGeqxWUCjKL6DUQ42/qsrWLx8CIVnNeekRALrYM26ZptV8yEjPRdGPQn3ziTZeKUtNb35WARMROjKp14KQbi25OSZ0gFgYWzkz3fjz9DVuvDjDhEWiMba/ikeE/USj3zEd3nR44iezHpI8jzR3RXuXwQscN2+DEODCpUlBgSVnCCVj+JdkZZc9ufzF2HIgDJ9tsB+SKDKw5OGdtI6ZROW+0D2OssHio8BxbOyfpKluuLN/kBtn4M4dQ9QlEk71m/Ul4Cr+f6MmN0EHaEh2d9xhz8Nm2Dbd/rOixiiHYTkXx7ip0XkWgjbw6EFToVriaaLdf1XCNwlEPIyPQoysfwDcA3sVXLNoc/SeAiiF59hVsRMK2Nhby/x+zB0Q/tTH9is7gSBPc7ehybtgDACDjLtRJ7ly4yxwcwRwKONMwUMdmATHoNAU7tpoi+RCk2V83DFIgiOsN3xOEGlkHVm0DYjXm7wu+egVuK
 1aKJfxOL
 Z7qCiXlaF7qW2vemVLl4T8czLKTe/g+XEa/zzizCRe3k1LFj+uikvV4a49FeQ6QHWBfFMTiBieZfrrGPCF1F5GAX/FYgCx49+aTRnDvENPP8Bq8DWSyb4be1XDNkyi2jj4VD/EgFIK0EDAACpKYtSBG/+a1x6o49K6kdCYB0eAjCzShf4JduzBBXyc1o2nCd8uItbNs5Njk6MIuUcvEINIQB4v+PBS2hcunQxYkd02tf1Lt61f592CvFFhovHNhE4W0ZXtCJmRIb6h/+njrUwaWIYrwm5aFBaKmBsf/DnIOFBmSir3NcLmt3FFW8ft12efbUegfxaU9j+mFSYajCzJYbVmmFvyB7ZGNu4vTSXJ+anaDHbEp4d+f8yHopgUqk9t2J2+gfkGZZbRPtUwo1iPMiA+PjaW88Xx0Py8U97gVBLVyOewVDZeQjEW6QvjEYPCpTKRTABbZHMm2Fki6zgGeEtMUoW3uo/mI9waGAuUy2ek0VnKl4RJiLE9hgaxpWRu944Ez+7PQ+1EEW1vJ4w8GiXjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 20-11-26 19:22:06, mohamedalibouhaouala@gmail.com wrote:
> From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
> 
> Update the VFS documentation to reflect changes in
> file_system_type, super_operations, inode_operations structs.
> 
> Refresh the documented structure members and callback signatures
> for super_operations and inode_operations, including missing
> members from documented structs  such as sync_inode_metadata(),
> remove_bdev(), shutdown(), report_error(), and fiemap().
> 
> Clarify inode allocation and destruction semantics, RCU requirements,
> inode eviction behavior, filesystem freezing, and block device
> removal handling.
> 
> Also fix outdated terminology, callback descriptions, and
> documentation references.
> 
> Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Does this cleanly apply on top of VFS git tree? I have a vague recollection
somebody was already updating (some of) these docs a few weeks ago.

								Honza

> ---
>  Documentation/filesystems/vfs.rst | 178 +++++++++++++++++++++---------
>  1 file changed, 128 insertions(+), 50 deletions(-)
> 
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 1824462a4371..54ce835757b1 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -129,6 +129,8 @@ members are defined:
>  		struct lock_class_key i_mutex_key;
>  		struct lock_class_key invalidate_lock_key;
>  		struct lock_class_key i_mutex_dir_key;
> +
> +		struct lock_class_key d_lookup_key;
>  	};
>  
>  ``name``
> @@ -156,14 +158,14 @@ members are defined:
>  	for internal VFS use: you should initialize this to THIS_MODULE
>  	in most cases.
>  
> -``next``
> +``list``
>  	for internal VFS use: you should initialize this to NULL
>  
>  ``fs_supers``
>  	for internal VFS use: hlist of filesystem instances (superblocks)
>  
>    s_lock_key, s_umount_key, s_vfs_rename_key, s_writers_key,
> -  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key: lockdep-specific
> +  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key, d_lookup_key: lockdep-specific
>  
>  The Superblock Object
>  =====================
> @@ -186,15 +188,16 @@ filesystem.  The following members are defined:
>  
>  		void (*dirty_inode) (struct inode *, int flags);
>  		int (*write_inode) (struct inode *, struct writeback_control *wbc);
> +		int (*sync_inode_metadata)(struct inode *inode, struct writeback_control *wbc);
>  		int (*drop_inode) (struct inode *);
>  		void (*evict_inode) (struct inode *);
>  		void (*put_super) (struct super_block *);
>  		int (*sync_fs)(struct super_block *sb, int wait);
> -		int (*freeze_super) (struct super_block *sb,
> -					enum freeze_holder who);
> +		int (*freeze_super)(struct super_block *sb, enum freeze_holder who,
> +			    const void *owner);
>  		int (*freeze_fs) (struct super_block *);
> -		int (*thaw_super) (struct super_block *sb,
> -					enum freeze_wholder who);
> +		int (*thaw_super)(struct super_block *sb, enum freeze_holder who,
> +			const void *owner);
>  		int (*unfreeze_fs) (struct super_block *);
>  		int (*statfs) (struct dentry *, struct kstatfs *);
>  		void (*umount_begin) (struct super_block *);
> @@ -206,12 +209,15 @@ filesystem.  The following members are defined:
>  
>  		ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
>  		ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
> -		struct dquot **(*get_dquots)(struct inode *);
> +		struct dquot __rcu **(*get_dquots)(struct inode *);
>  
>  		long (*nr_cached_objects)(struct super_block *,
>  					struct shrink_control *);
>  		long (*free_cached_objects)(struct super_block *,
>  					struct shrink_control *);
> +		int (*remove_bdev)(struct super_block *, struct block_device *);
> +		void (*shutdown)(struct super_block *);
> +		void (*report_error)(const struct fserror_event *);
>  	};
>  
>  All methods are called without any locks being held, unless otherwise
> @@ -219,23 +225,46 @@ noted.  This means that most methods can block safely.  All methods are
>  only called from a process context (i.e. not from an interrupt handler
>  or bottom half).
>  
> +Exceptions:
> +
> +* ``->free_inode`` is called from an RCU callback and must not block.
> +* ``->drop_inode`` is called with ``inode->i_lock`` held and must not block.
> +
>  ``alloc_inode``
>  	this method is called by alloc_inode() to allocate memory for
>  	struct inode and initialize it.  If this function is not
>  	defined, a simple 'struct inode' is allocated.  Normally
>  	alloc_inode will be used to allocate a larger structure which
>  	contains a 'struct inode' embedded within it.
> +	A filesystem that defines ->alloc_inode must also define
> +	->free_inode or ->destroy_inode (see below), because the VFS
> +	default would free the inode into its own cache.
>  
>  ``destroy_inode``
> -	this method is called by destroy_inode() to release resources
> -	allocated for struct inode.  It is only required if
> -	->alloc_inode was defined and simply undoes anything done by
> -	->alloc_inode.
> +   This method is called by :c:func:`destroy_inode` to release resources
> +   allocated for ``struct inode``. It is called synchronously, before
> +   the inode memory is freed.
> +
> +   The VFS handles inode memory as follows:
> +
> +   * If ``->free_inode`` is defined, the VFS frees the inode through an
> +     RCU callback that invokes ``->free_inode``. In this case,
> +     ``->destroy_inode``, if defined, must release only other resources
> +     and must not free the inode itself.
> +
> +   * If ``->destroy_inode`` is defined without ``->free_inode``, it is
> +     responsible for freeing the inode memory, including deferring
> +     reclamation until it is safe to do so.
> +
> +   * If neither is defined, the VFS frees the inode to its own cache.
> +     This is only correct when ``->alloc_inode`` is also not defined.
>  
>  ``free_inode``
> -	this method is called from RCU callback. If you use call_rcu()
> -	in ->destroy_inode to free 'struct inode' memory, then it's
> -	better to release memory in this method.
> +	this method is called from RCU callback, after
> +	``->destroy_inode`` (if any), and must free the memory of the inode.
> +	It must not block.  Prefer it over calling  :c:func:`call_rcu` from
> +	``->destroy_inode``: if ``->free_inode`` is defined, the VFS does the
> +	:c:func:`call_rcu` for you.
>  
>  ``dirty_inode``
>  	this method is called by the VFS when an inode is marked dirty.
> @@ -251,18 +280,30 @@ or bottom half).
>  	disc.  The second parameter indicates whether the write should
>  	be synchronous or not, not all filesystems check this flag.
>  
> +``sync_inode_metadata``
> +	called by the writeback code to synchronize inode metadata
> +	that was previously written asynchronously.
> +	The writeback_control argument describes the writeback mode.
> +
> +	Optional.
> +
>  ``drop_inode``
>  	called when the last access to the inode is dropped, with the
> -	inode->i_lock spinlock held.
> +	``inode->i_lock`` spinlock held; it must not block.
>  
>  	This method should be either NULL (normal UNIX filesystem
> -	semantics) or "inode_just_drop" (for filesystems that do
> -	not want to cache inodes - causing "delete_inode" to always be
> -	called regardless of the value of i_nlink)
> +	semantics) or ``inode_just_drop`` (for filesystems that do
> +	not want to cache inodes).
> +
> +	A non-zero return value makes the VFS evict the inode immediately,
> +	regardless of the value of i_nlink:
> +	``->evict_inode`` is called if the filesystem provides it,
> +	otherwise the VFS truncates the page cache and clears the inode
> +	itself.
>  
> -	The "inode_just_drop()" behavior is equivalent to the old
> -	practice of using "force_delete" in the put_inode() case, but
> -	does not have the races that the "force_delete()" approach had.
> +	The :c:func:`inode_just_drop` behavior is equivalent to the old
> +	practice of using :c:func:`force_delete` in the :c:func:`put_inode` case, but
> +	does not have the races that the :c:func:`force_delete` approach had.
>  
>  ``evict_inode``
>  	called when the VFS wants to evict an inode. Caller does
> @@ -281,11 +322,13 @@ or bottom half).
>  	should wait until the write out has been completed.  Optional.
>  
>  ``freeze_super``
> -	Called instead of ->freeze_fs callback if provided.
> -	Main difference is that ->freeze_super is called without taking
> -	down_write(&sb->s_umount). If filesystem implements it and wants
> -	->freeze_fs to be called too, then it has to call ->freeze_fs
> -	explicitly from this callback. Optional.
> +	Called instead of ``->freeze_fs`` callback if provided.
> +	Main difference is that ``->freeze_super`` is called without taking
> +	down_write(``&sb->s_umount``).  The second parameter identifies the
> +	freeze holder, and the third identifies the owner of the freeze.
> +	If filesystem implements it and wants ``->freeze_fs`` to be called too,
> +	then it has to call ``->freeze_fs`` explicitly from this callback.
> +	Optional.
>  
>  ``freeze_fs``
>  	called when VFS is locking a filesystem and forcing it into a
> @@ -332,6 +375,7 @@ or bottom half).
>  
>  ``get_dquots``
>  	called by quota to get 'struct dquot' array for a particular inode.
> +	Managed under RCU rules. More info in Documentation/RCU/whatisRCU.rst.
>  	Optional.
>  
>  ``nr_cached_objects``
> @@ -339,16 +383,17 @@ or bottom half).
>  	return the number of freeable cached objects it contains.
>  	Optional.
>  
> -``free_cache_objects``
> +``free_cached_objects``
>  	called by the sb cache shrinking function for the filesystem to
>  	scan the number of objects indicated to try to free them.
>  	Optional, but any filesystem implementing this method needs to
> -	also implement ->nr_cached_objects for it to be called
> +	also implement ``->nr_cached_objects`` for it to be called
>  	correctly.
>  
> -	We can't do anything with any errors that the filesystem might
> -	encountered, hence the void return type.  This will never be
> -	called if the VM is trying to reclaim under GFP_NOFS conditions,
> +	The VFS cannot do anything with errors the filesystem might
> +	encounter, so no error code is returned: the return value is the
> +	number of objects freed.  This will never be called if the VM
> +	is trying to reclaim under GFP_NOFS conditions,
>  	hence this method does not need to handle that situation itself.
>  
>  	Implementations must include conditional reschedule calls inside
> @@ -357,8 +402,32 @@ or bottom half).
>  	about whether implementations will cause holdoff problems due to
>  	large scan batch sizes.
>  
> -Whoever sets up the inode is responsible for filling in the "i_op"
> -field.  This is a pointer to a "struct inode_operations" which describes
> +``remove_bdev``
> +	Called when a block device backing the filesystem is being
> +	removed. Filesystems that support graceful removal of a
> +	device and can continue read-write operations should
> +	implement this callback.
> +
> +	Return 0 if the filesystem can continue read-write
> +	operations. A non-zero return value, or the absence of
> +	this callback, causes the filesystem to be shut down as usual.
> +
> +	Optional.
> +
> +``shutdown``
> +	Called when the filesystem needs to be shut down following
> +	block device removal.
> +
> +	Optional.
> +
> +``report_error``
> +	Called to report a filesystem error. The callback receives
> +	a pointer to an error event describing the error.
> +
> +	Optional.
> +
> +Whoever sets up the inode is responsible for filling in the ``i_op``
> +field.  This is a pointer to a ``struct inode_operations`` which describes
>  the methods that can be performed on individual inodes.
>  
>  
> @@ -410,7 +479,7 @@ struct inode_operations
>  -----------------------
>  
>  This describes how the VFS can manipulate an inode in your filesystem.
> -As of kernel 2.6.22, the following members are defined:
> +The following members are defined:
>  
>  .. code-block:: c
>  
> @@ -433,8 +502,9 @@ As of kernel 2.6.22, the following members are defined:
>  		int (*setattr) (const struct mnt_idmap *, struct dentry *, struct iattr *);
>  		int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
>  		ssize_t (*listxattr) (struct dentry *, char *, size_t);
> -		void (*update_time)(struct inode *inode, enum fs_update_time type,
> -				    int flags);
> +		int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
> +		int (*update_time)(struct inode *inode, enum fs_update_time type,
> +			unsigned int flags);
>  		void (*sync_lazytime)(struct inode *inode);
>  		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
>  				   unsigned open_flag, umode_t create_mode);
> @@ -460,16 +530,18 @@ otherwise noted.
>  ``lookup``
>  	called when the VFS needs to look up an inode in a parent
>  	directory.  The name to look for is found in the dentry.  This
> -	method must call d_add() to insert the found inode into the
> -	dentry.  The "i_count" field in the inode structure should be
> +	method returns ``d_splice_alias(inode, dentry)``;
> +	(or :c:func:`d_add` plus return NULL for non-directories,
> +	and for negative dentries).
> +	The ``i_count`` field in the inode structure should be
>  	incremented.  If the named inode does not exist a NULL inode
>  	should be inserted into the dentry (this is called a negative
>  	dentry).  Returning an error code from this routine must only be
>  	done on a real error, otherwise creating inodes with system
> -	calls like create(2), mknod(2), mkdir(2) and so on will fail.
> +	calls like ``create(2)``, ``mknod(2)``, ``mkdir(2)`` and so on will fail.
>  	If you wish to overload the dentry methods then you should
> -	initialise the "d_dop" field in the dentry; this is a pointer to
> -	a struct "dentry_operations".  This method is called with the
> +	initialise the ``d_dop`` field in the dentry; this is a pointer to
> +	a struct ``dentry_operations``.  This method is called with the
>  	directory inode semaphore held
>  
>  ``link``
> @@ -487,28 +559,29 @@ otherwise noted.
>  	d_instantiate() just as you would in the create() method
>  
>  ``mkdir``
> -	called by the mkdir(2) system call.  Only required if you want
> +	called by the ``mkdir(2)`` system call.  Only required if you want
>  	to support creating subdirectories.  You will probably need to
> -	call d_instantiate_new() just as you would in the create() method.
> +	call :c:func:`d_instantiate` just as you would in the :c:func:`create` method
> +	but preferably :c:func:`d_instantiate_new`.
>  
> -	If d_instantiate_new() is not used and if the fh_to_dentry()
> +	If :c:func:`d_instantiate_new` is not used and if the :c:func:`fh_to_dentry`
>  	export operation is provided, or if the storage might be
>  	accessible by another path (e.g. with a network filesystem)
> -	then more care may be needed.  Importantly d_instantate()
> -	should not be used with an inode that is no longer I_NEW if there
> +	then more care may be needed.  Importantly :c:func:`d_instantiate`
> +	should not be used with an inode that is no longer ``I_NEW`` if there
>  	any chance that the inode could already be attached to a dentry.
>  	This is because of a hard rule in the VFS that a directory must
>  	only ever have one dentry.
>  
>  	For example, if an NFS filesystem is mounted twice the new directory
>  	could be visible on the other mount before it is on the original
> -	mount, and a pair of name_to_handle_at(), open_by_handle_at()
> -	calls could instantiate the directory inode with an IS_ROOT()
> +	mount, and a pair of :c:func:`name_to_handle_at`, :c:func:`open_by_handle_at`
> +	calls could instantiate the directory inode with an :c:func:`IS_ROOT`
>  	dentry before the first mkdir returns.
>  
>  	If there is any chance this could happen, then the new inode
> -	should be attached with d_splice_alias().  The returned
> -	dentry (if any) should be returned by ->mkdir().
> +	should be attached with :c:func:`d_splice_alias`.  The returned
> +	dentry (if any) should be returned by ``->mkdir()``.
>  
>  ``rmdir``
>  	called by the rmdir(2) system call.  Only required if you want
> @@ -587,6 +660,11 @@ otherwise noted.
>  	called by the VFS to list all extended attributes for a given
>  	file.  This method is called by the listxattr(2) system call.
>  
> +``fiemap``
> +	called by the VFS to report the physical or logical extent
> +	layout of a file via the FIEMAP ioctl.
> +	More info in Documentation/filesystems/fiemap.rst.
> +
>  ``update_time``
>  	called by the VFS to update a specific time or the i_version of
>  	an inode.  If this is not defined the VFS will update the inode
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

