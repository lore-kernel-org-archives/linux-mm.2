Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B36A7FEFB54
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF636B0005; Fri, 27 Feb 2026 10:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66876B0088; Fri, 27 Feb 2026 10:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D727D6B0089; Fri, 27 Feb 2026 10:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF4F76B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:00:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38F361B7450
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:00:47 +0000 (UTC)
X-FDA: 84490548534.09.D5B0879
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id BC375140021
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:00:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DOLJEFuP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Zg0hZbS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7ZJMDi6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kiq1gZkH;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772204445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YNa9VbblGOYweoA7bNUqLw4ueQtOdJWihgMEEJuMI4=;
	b=mRqPyYWFOEDi6JvMHzJhQuaajqNrEmFxOrH0d4nH2HFI4HbJCbebOMOMBkziOYEkXgQkxZ
	d7VuiHkbhueWJZgGVCdz3TgokH1jRa0BowejDWpdZtRVEe0+YhTDWdF3KWsUsGq3G6zhNu
	wyQQsqdSbGfzfyrw4n1aJB6e2xFUPY8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DOLJEFuP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=6Zg0hZbS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V7ZJMDi6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Kiq1gZkH;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772204445; a=rsa-sha256;
	cv=none;
	b=IgkvNjHF1g+bUOuwgasYzyJrcjjwDsgz9KJdHl9rUNqs8YyXmp9u9qnOeXjbfMHgNq2As6
	Yeh6C+cEQX57IvjXkgPSKl7I0WWbXHNif+wrdcWd7pNk2Gn3itRT4QuCde411hML/I+VJH
	afoikZjOEusx/2S9q39557a/CYLcTf8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E6D05D050;
	Fri, 27 Feb 2026 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772204443; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9YNa9VbblGOYweoA7bNUqLw4ueQtOdJWihgMEEJuMI4=;
	b=DOLJEFuPIC16vEbxIGuupy9DHG/corFZNPnenZy1j1j7NMqvoT1/9mQda8uvzQW/Y2DgfQ
	zZQCJ1ILFmbFIDp0aobj0ahw3XUUhD/JjCz4zYvpvdFPvD6wctwoKZc2vxbiO+gfGBE2DH
	p2ekwPYeWNniPQgbDy53qTREqMuZxmY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772204443;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9YNa9VbblGOYweoA7bNUqLw4ueQtOdJWihgMEEJuMI4=;
	b=6Zg0hZbSlxLC5ASoVl7eTX8pOspi90GHPRBxl19nFvuN4HlSeZZjgI0h/0wEZBCt+uS+Lg
	pHjTQi4vuPxQBnAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772204438; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9YNa9VbblGOYweoA7bNUqLw4ueQtOdJWihgMEEJuMI4=;
	b=V7ZJMDi69Q/Hdeq9tLefvDyOTmVqEiO6CtG6hmBZ52L5njImrJmF2h9dtGBmIvmTsxyjya
	Lht22QeznVsztUP4mDzyBuCQ6ePHP4CxFukiTIXVaQAsJTr00Rup16ndeW3e9RIiK2T29Q
	TG41S1GO4PnJ8CJ7Q0cvMmLAuCLhunc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772204438;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9YNa9VbblGOYweoA7bNUqLw4ueQtOdJWihgMEEJuMI4=;
	b=Kiq1gZkH2Da8WdXkaXCk74+yBeGcw+ypIhnhB3xLf/ciO/9QH9aU/VxAhLN/qOYUQzCsII
	EfGxjUsn5UTZ4UDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2EBCB3EA69;
	Fri, 27 Feb 2026 15:00:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QPJiC5axoWkaDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:00:38 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id DEADDA06D4; Fri, 27 Feb 2026 16:00:37 +0100 (CET)
Date: Fri, 27 Feb 2026 16:00:37 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/14] kernfs: adapt to rhashtable-based simple_xattrs
 with lazy allocation
Message-ID: <3cnmtqmakpbb2uwhenrj7kdqu3uefykiykjllgfbtpkiwhaa4s@sghkevv7jned>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-4-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-4-c2efa4f74cb7@kernel.org>
X-Stat-Signature: 8n1u5f3przsi8634ypaz6uhzrzm7icd8
X-Rspam-User: 
X-Rspamd-Queue-Id: BC375140021
X-Rspamd-Server: rspam04
X-HE-Tag: 1772204444-271237
X-HE-Meta: U2FsdGVkX18MH23mWoOGnIxX5LNr9KpveuCWfjjNEyAWM5Dfw1VaY6Nx1qkC9hLS3+ObCYP9L0vnu/23k86Emr6k+JVzVXt9qKbSkTLi0NX1I0LvTLQLY8encY7GrVFf6Yp2r8yiUKaNR0AOMM2KHpVbk+aNTBCpgDpI1StzkcyTOMeq/qrY7eX5vL0NaA5tX4OkqXGGt2qcNvohnjUiOkcbsaqt6hIaIlmacXfr/z6P1R1mmKDrxYAhOYngXQda8tZnS6071jUFDd1vrHCaZ+yjyerxlYlxVMxKMpSV/bf9pSil71hDalEp1n0kQ1CNNmyxOJQcqyTfNiLPP8WC5XSZPfRQnTKP4zmqNkTi9leihG5dIJCnneo6CALmJTkl64IEfxSO7rqyQGqmncFwitsCIrImvhr7EVkQRQuMT8LW+4l6BxXfy1hQVTArRQv0Az881ZqzsM14j6lvgXalrMEe6JgedzUtpiDokNWzQl/cVN4AI+X6Ivp6K0gW+bMFCBfmORlZyRaBt3hnYQHWTY3vL1bc+uyboBFpllKQ9MnUthK+oqQGCS+Q0yScEcMC4E9xnV45TXZ11KYC3l5Fne9C7T0XcVR1Ixi9CFn6uZlJPU+fWlbTDEceYY8VZ/qZSZf/zFnH/nnbztMlrfbokhWTTkIYCpT5u1KP73ZH70rgg7uBWnOHkGAKdEuj0uCp8/xYFNr4JNHxlUrdvMY3cPGve0vpx6vBP0jh6DUl6XSGRPZwMlkgVAoSZAM3ydxWy2qDmHU4Zl6nC5TUnyJvvO++I/hdV95KR4Va4BmNC409ybi0ZNzrUakmns5n5/IgW9e31fHTPeuoVw1P4fqahyi9JyB7YOtlRBOpouBLxyCnVG9iUuEdBFIZV/HQRXIEpI1CtF5CIPXa6XdgbIgSpYtUzrPRR3g/z1BPt5mKbkFc+NVMTfdt49LuVy0YNICEE483Mt+Dn+8Hq7fHNOF
 1we6cgqO
 ZmEB7UIHqhu59uy1ByjbV/Iur/trj9tecz/LztR9U++sGzCqhiQrX8ZrR2bRRMa7tnAwbWZLUJQ0i44AtB/UqTIBy2HlYkDQ+q+eEVWUXyjiEq1BFPfT2mlo9AYM/4oqtElEa/R9nbUS5hNOgM1JQ19MqgwbvCHoktrCcmAqlvgIRggzzSrkLI6g/3YFljJHK1ECsUHLsHz/qETZfCqpDf8E+yhyquxIDOQqRJH+V0vgSvPgLyVPyAL7F2h7472z5/huCBizfoA/oBjwse9kr6ukY0nbVXt1y74i5EckTLXD/puT8UbbTee7uIXM2w5LhxdazKM6bb2d1GUCRi5wlQMNel3S3KYt0xos8LLoa4Pxtb0bN+Nb9ij5Igghg0dYVSbBHYc2c8oG9PzqC2mgILPBgXuVrd8kiwRCV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:00, Christian Brauner wrote:
> Adapt kernfs to use the rhashtable-based xattr path and switch from an
> embedded struct to pointer-based lazy allocation.
> 
> Change kernfs_iattrs.xattrs from embedded 'struct simple_xattrs' to a
> pointer 'struct simple_xattrs *', initialized to NULL (zeroed by
> kmem_cache_zalloc). Since kernfs_iattrs is already lazily allocated
> itself, this adds a second level of lazy allocation specifically for
> the xattr store.
> 
> The xattr store is allocated on first setxattr. Read paths
> check for NULL and return -ENODATA or empty list.
> 
> Replaced xattr entries are freed via simple_xattr_free_rcu() to allow
> concurrent RCU readers to finish.
> 
> The cleanup paths in kernfs_free_rcu() and __kernfs_new_node() error
> handling conditionally free the xattr store only when allocated.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

...

> @@ -584,6 +582,12 @@ void kernfs_put(struct kernfs_node *kn)
>  	if (kernfs_type(kn) == KERNFS_LINK)
>  		kernfs_put(kn->symlink.target_kn);
>  
> +	if (kn->iattr && kn->iattr->xattrs) {
> +		simple_xattrs_free(kn->iattr->xattrs, NULL);
> +		kfree(kn->iattr->xattrs);
> +		kn->iattr->xattrs = NULL;
> +	}
> +
>  	spin_lock(&root->kernfs_idr_lock);
>  	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
>  	spin_unlock(&root->kernfs_idr_lock);

This is a slight change in the lifetime rules because previously kernfs
xattrs could be safely accessed only under RCU but after this change you
have to hold inode reference *and* RCU to safely access them. I don't think
anybody would be accessing xattrs without holding inode reference so this
should be safe but it would be good to mention this in the changelog.
Otherwise feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> @@ -682,7 +686,10 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
>  
>   err_out4:
>  	if (kn->iattr) {
> -		simple_xattrs_free(&kn->iattr->xattrs, NULL);
> +		if (kn->iattr->xattrs) {
> +			simple_xattrs_free(kn->iattr->xattrs, NULL);
> +			kfree(kn->iattr->xattrs);
> +		}
>  		kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
>  	}
>   err_out3:
> diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
> index a36aaee98dce..dfc3315b5afc 100644
> --- a/fs/kernfs/inode.c
> +++ b/fs/kernfs/inode.c
> @@ -45,7 +45,6 @@ static struct kernfs_iattrs *__kernfs_iattrs(struct kernfs_node *kn, bool alloc)
>  	ret->ia_mtime = ret->ia_atime;
>  	ret->ia_ctime = ret->ia_atime;
>  
> -	simple_xattrs_init(&ret->xattrs);
>  	atomic_set(&ret->nr_user_xattrs, 0);
>  	atomic_set(&ret->user_xattr_size, 0);
>  
> @@ -146,7 +145,8 @@ ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size)
>  	if (!attrs)
>  		return -ENOMEM;
>  
> -	return simple_xattr_list(d_inode(dentry), &attrs->xattrs, buf, size);
> +	return simple_xattr_list(d_inode(dentry), READ_ONCE(attrs->xattrs),
> +				 buf, size);
>  }
>  
>  static inline void set_default_inode_attr(struct inode *inode, umode_t mode)
> @@ -298,27 +298,38 @@ int kernfs_xattr_get(struct kernfs_node *kn, const char *name,
>  		     void *value, size_t size)
>  {
>  	struct kernfs_iattrs *attrs = kernfs_iattrs_noalloc(kn);
> +	struct simple_xattrs *xattrs;
> +
>  	if (!attrs)
>  		return -ENODATA;
>  
> -	return simple_xattr_get(&attrs->xattrs, name, value, size);
> +	xattrs = READ_ONCE(attrs->xattrs);
> +	if (!xattrs)
> +		return -ENODATA;
> +
> +	return simple_xattr_get(xattrs, name, value, size);
>  }
>  
>  int kernfs_xattr_set(struct kernfs_node *kn, const char *name,
>  		     const void *value, size_t size, int flags)
>  {
>  	struct simple_xattr *old_xattr;
> +	struct simple_xattrs *xattrs;
>  	struct kernfs_iattrs *attrs;
>  
>  	attrs = kernfs_iattrs(kn);
>  	if (!attrs)
>  		return -ENOMEM;
>  
> -	old_xattr = simple_xattr_set(&attrs->xattrs, name, value, size, flags);
> +	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
> +	if (IS_ERR_OR_NULL(xattrs))
> +		return PTR_ERR(xattrs);
> +
> +	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
>  	if (IS_ERR(old_xattr))
>  		return PTR_ERR(old_xattr);
>  
> -	simple_xattr_free(old_xattr);
> +	simple_xattr_free_rcu(old_xattr);
>  	return 0;
>  }
>  
> @@ -376,7 +387,7 @@ static int kernfs_vfs_user_xattr_add(struct kernfs_node *kn,
>  
>  	ret = 0;
>  	size = old_xattr->size;
> -	simple_xattr_free(old_xattr);
> +	simple_xattr_free_rcu(old_xattr);
>  dec_size_out:
>  	atomic_sub(size, sz);
>  dec_count_out:
> @@ -403,7 +414,7 @@ static int kernfs_vfs_user_xattr_rm(struct kernfs_node *kn,
>  
>  	atomic_sub(old_xattr->size, sz);
>  	atomic_dec(nr);
> -	simple_xattr_free(old_xattr);
> +	simple_xattr_free_rcu(old_xattr);
>  	return 0;
>  }
>  
> @@ -415,6 +426,7 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
>  {
>  	const char *full_name = xattr_full_name(handler, suffix);
>  	struct kernfs_node *kn = inode->i_private;
> +	struct simple_xattrs *xattrs;
>  	struct kernfs_iattrs *attrs;
>  
>  	if (!(kernfs_root(kn)->flags & KERNFS_ROOT_SUPPORT_USER_XATTR))
> @@ -424,11 +436,15 @@ static int kernfs_vfs_user_xattr_set(const struct xattr_handler *handler,
>  	if (!attrs)
>  		return -ENOMEM;
>  
> +	xattrs = simple_xattrs_lazy_alloc(&attrs->xattrs, value, flags);
> +	if (IS_ERR_OR_NULL(xattrs))
> +		return PTR_ERR(xattrs);
> +
>  	if (value)
> -		return kernfs_vfs_user_xattr_add(kn, full_name, &attrs->xattrs,
> +		return kernfs_vfs_user_xattr_add(kn, full_name, xattrs,
>  						 value, size, flags);
>  	else
> -		return kernfs_vfs_user_xattr_rm(kn, full_name, &attrs->xattrs,
> +		return kernfs_vfs_user_xattr_rm(kn, full_name, xattrs,
>  						value, size, flags);
>  
>  }
> diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
> index 6061b6f70d2a..1324ed8c0661 100644
> --- a/fs/kernfs/kernfs-internal.h
> +++ b/fs/kernfs/kernfs-internal.h
> @@ -26,7 +26,7 @@ struct kernfs_iattrs {
>  	struct timespec64	ia_mtime;
>  	struct timespec64	ia_ctime;
>  
> -	struct simple_xattrs	xattrs;
> +	struct simple_xattrs	*xattrs;
>  	atomic_t		nr_user_xattrs;
>  	atomic_t		user_xattr_size;
>  };
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

