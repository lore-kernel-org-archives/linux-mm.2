Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 200F1CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 09:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A02B6B0088; Wed,  7 Oct 2026 05:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12AAC6B008C; Wed,  7 Oct 2026 05:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F349B6B0092; Wed,  7 Oct 2026 05:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C17B16B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:47:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4070780160
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:47:27 +0000 (UTC)
X-FDA: 85295352534.22.ED61B82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88A7E1C000A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:47:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fai2JdxQ;
	spf=pass (imf18.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791366445;
	b=najlu0BAs+M53OdY8EDiANxT8nDG+JtAVYak12KghTudUMUCDRhHa/PBRXnHsxpIeNGmlL
	+RdDMyLLlkLB3vWAlWuu8yx+TtYsCSw42JGfSifsKIWkO3ZOwxYyv2vrUYDpze0y9h0U/Q
	izfTeGQsJK3sH1zNhpSr/C4I45P+neI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fai2JdxQ;
	spf=pass (imf18.hostedemail.com: domain of cem@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cem@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791366445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKfTrq8VHIA+znChlNb3NuZ60B46dqCeKbF4f81115I=;
	b=gHQhUwps4D/uW8aWHLE9ERk0w4APJnfGxn/uUHjn1HyCcuBEivWDzIFCQT1ot4pSJJMptN
	jiZ83+c5iTK1shOl3XxsEydU7ZSghCC0AQfbA6dj/0F3k5QOWQS8SrHVjpTP8fIvaNuf9W
	6qLtMH3nnb2n4US4hLE6Z6h4wL0+6hg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 748EC414F6;
	Wed,  7 Oct 2026 09:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB331F0089B;
	Wed,  7 Oct 2026 09:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791366444;
	bh=WKfTrq8VHIA+znChlNb3NuZ60B46dqCeKbF4f81115I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fai2JdxQg2GTZDr/VvQZVCO9hLiWsjmsp3kCspc8fuKK4Idhvb8afxieuvkYwQyYm
	 EROdJ2PNOewRKi2TlzftYwYAKyOzWDZOqcN/uIKMcnbgV4RmoSWKvkrrjXqOH103u4
	 pkW/zLZZoKah5esAFQs3D/dVu6u2y5mvWBDTVdUYX8sUlAMw/6TGZqWNoZl9+0sMb5
	 XRIYEsb8pFZMI07mxgwGXu32WJ+4ExSOAeE3Q6diCbSoyE+fYRs6OFJ8RwEG+2QP6M
	 t5VGgOEOdwhnOdt+AfIzlhYUJpGyLhxBjp3rfpsYz8tJfVVrUI3imhuR0jMSWv7pUP
	 MBSrx6oIQcWWw==
Date: Wed, 7 Oct 2026 11:47:09 +0200
From: Carlos Maiolino <cem@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Kees Cook <kees@kernel.org>, 
	Joel Granados <joel.granados@kernel.org>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Breno Leitao <leitao@debian.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Jan Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-um@lists.infradead.org, codalist@coda.cs.cmu.edu, 
	coda@cs.cmu.edu, linux-mm@kvack.org, ntfs@lists.linux.dev, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across
 d_alloc_parallel() in d_add_ci()
Message-ID: <asYVApB1jdBYj9tN@cronus.toxiclabs.cc>
References: <20260929034158.1455429-1-neilb@ownmail.net>
 <20260929034158.1455429-2-neilb@ownmail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929034158.1455429-2-neilb@ownmail.net>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88A7E1C000A
X-Stat-Signature: sagjzxikw43gh6emtcyo6kjayji1tnk8
X-HE-Tag: 1791366445-901197
X-HE-Meta: U2FsdGVkX1+Rifr9xUy1v6q8gMu+Nxm+VcnNdNcjyF9RbgMUtqRgsa5HvgZB8Ik9PQHN5k+/uoxpf3jzlW95iy+DDg4tmx9LAj6r7AVJmtC6Q/T+aj2yMuDQM67tZgTDCUqMf9UhnAmtlwuOGmMqILkDP0hILbi8uSS9r5x4Jw01hN/z3SVhXr0azxP+RBs3ALlQ6kZ5OYa93yRTZTl1BAFo0uzoJcC5DFHmaWhwsCsxRlRNPVnnJOtktqvKCPAk9uWrrlswNolGEWbZ+UWjl4IiAPSjbWYZLXejZSPUoqKG3AZ9JgXW+G7vf7YQe2/xbZYrMtndxyQU/WGLPlCKikepxtkntyFiD16FF/rnS4ukJhuR7mdPwRRnrpkKRlL/Xr/q1doDSU3FyP1WJvoqDAUlMk1iCP/0X20o7NbVsHbcLrZM1ujK9/r5/Eg3b6nMqtKrxB+paA12x3Bz/swIEZrpcspPmLHcUTgZAMEUK7XbjYApQJL5y8Gkm8+v8kGHp6EkCCOxLLpE5k9PlhAcPSl4NpANNifq91zFLC0JflTOTG9vc29eUAUd9pOGbW7dHQAmE7NdXevzslLh1aYxxQT+YwknRj8n1j24xDPDGX+f9mGgGOrq8ZqW+wAyMK9aCIF21efWTj/NeEKaOVhKcbQgDCr1WPdY9iPhrEM/TRj9qB+E3Rv0Q5xGl0WPg85GtxJyIoPpXx0U9ZVv2rQAeS4YtQ5D4GMmdzqB9CI+4tb+zIIHQGwFpYut8iTBd3w+ymXAYC8h+4Sht18ybtf5//3E58t7PnYnBtBMU+BNrbJ/GA+dLp29WVWeq5q2Iz8Yuzv0S9Q7BsPeD8afJohetc4mfqB8qHbUFGL4Fe1pJNtA1QDVvUG1100zP7KBt9nlJ1n+RwtYJIRLcvyDZpgKNc4Zfo1sGnJYs24m50gSmzKLZWFaGUyECUU7Bfp+DPTMNh/mif99Jr0PgxXh3by
 2bRjmbPO
 2bShXwYjYUXPug6G+VOiAVkajZMr4qiI0Si5NDeDSRbk5Pj5kI/gTrOsL5GbvU+PpDdrvJU14HYsEK7dZPDdBqTJUjTQq9X2+WqfzBdUOAU24HH6T7QUkmJIkuSLOD11TF2GzIsl3wisXCsGYwXn0Pw5R2N3a+i84PlA+gYwC1G6qoE3hAhGmQN/nXTvneSkZzTOrpUY2aq/uZi3TaY47+igbcZnOPsPxI0P4iAGGVfb1z4kWxgrhSxY0t/3QNzhwVgxDahwKtq1tx3qhJFyGoER3BV3C2wjSkCI60duSGMTwpkAhrKBNGtYdqEEiYFxhl48reZZJ3ig1+iIodf3ojr6UtUIKFBkQIZ/E655jGo93klqRXUNwsbuOvxUkJHOYDzuA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 01:36:01PM +1000, NeilBrown wrote:
> From: NeilBrown <neil@brown.name>
> 
> A proposed change will invert the lock ordering between
> d_alloc_parallel() and inode_lock() on the parent.
> When that happens it will not be safe to call d_alloc_parallel() while
> holding the parent lock - even shared.
> 
> We don't need to keep the parent lock held when d_add_ci() is run - the
> VFS doesn't need it as dentry is exclusively held due to
> DCACHE_PAR_LOOKUP and the filesystem has finished its work.
> 
> So drop and reclaim the lock (shared or exclusive as determined by
> LOOKUP_SHARED) to avoid future deadlock.
> 
> Signed-off-by: NeilBrown <neil@brown.name>
> ---

XFS bits are really small, but anyway, if needed, feel free to add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  Documentation/filesystems/porting.rst |  7 ++++++
>  fs/dcache.c                           | 32 +++++++++++++++++++++++----
>  fs/ntfs/namei.c                       |  2 +-
>  fs/xfs/xfs_iops.c                     |  2 +-
>  include/linux/dcache.h                |  3 ++-
>  5 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 4e015f1bf1f8..f6a38bd9c68e 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1409,3 +1409,10 @@ use only if you have no alternative.
>  The .create inode_operation no longer receives the 'excl' arg.  It must
>  always assume the file does not already exist.  If the filesystem needs
>  to be involved in non-exclusive create, it should provide atomic_open.
> +
> +---
> +
> +**mandatory**
> +
> +d_add_ci() must now be passed the flags arguemnt that was given to ->lookup
> +
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 83790c7a4dee..61e0896dc077 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2383,6 +2383,7 @@ EXPORT_SYMBOL(d_obtain_root);
>   * @dentry: the negative dentry that was passed to the parent's lookup func
>   * @inode:  the inode case-insensitive lookup has found
>   * @name:   the case-exact name to be associated with the returned dentry
> + * @lookup_flags: flags passed to ->lookup
>   *
>   * This is to avoid filling the dcache with case-insensitive names to the
>   * same inode, only the actual correct case is stored in the dcache for
> @@ -2395,9 +2396,10 @@ EXPORT_SYMBOL(d_obtain_root);
>   * the exact case, and return the spliced entry.
>   */
>  struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
> -			struct qstr *name)
> +			struct qstr *name, unsigned int lookup_flags)
>  {
>  	struct dentry *found, *res;
> +	bool must_unlock = false;
>  
>  	/*
>  	 * First check if a dentry matching the name already exists,
> @@ -2409,24 +2411,46 @@ struct dentry *d_add_ci(struct dentry *dentry, struct inode *inode,
>  		return found;
>  	}
>  	if (d_in_lookup(dentry)) {
> +		/*
> +		 * We are holding parent lock and so don't want to wait
> +		 * for a d_in_lookup() dentry.  We can safely drop the
> +		 * parent lock and reclaim it as we have exclusive
> +		 * access to dentry as it is d_in_lookup() (so
> +		 * ->d_parent is stable) and we are near the end
> +		 * ->lookup() and will shortly drop the lock anyway.
> +		 * We cannot retake the lock while the new dentry is in-lookup
> +		 */
> +		if (lookup_flags & LOOKUP_SHARED)
> +			inode_unlock_shared(d_inode(dentry->d_parent));
> +		else
> +			inode_unlock(d_inode(dentry->d_parent));
> +		must_unlock = true;
>  		found = d_alloc_parallel(dentry->d_parent, name);
>  		if (IS_ERR(found) || !d_in_lookup(found)) {
>  			iput(inode);
> -			return found;
> +			goto out_unlock;
>  		}
>  	} else {
>  		found = d_alloc(dentry->d_parent, name);
>  		if (!found) {
>  			iput(inode);
>  			return ERR_PTR(-ENOMEM);
> -		} 
> +		}
>  	}
>  	res = d_splice_alias(inode, found);
>  	if (res) {
>  		d_lookup_done(found);
>  		dput(found);
> -		return res;
> +		found = res;
>  	}
> +	if (!must_unlock)
> +		return found;
> +out_unlock:
> +	d_lookup_done(dentry);
> +	if (lookup_flags & LOOKUP_SHARED)
> +		inode_lock_shared(d_inode(dentry->d_parent));
> +	else
> +		inode_lock_nested(d_inode(dentry->d_parent), I_MUTEX_PARENT);
>  	return found;
>  }
>  EXPORT_SYMBOL(d_add_ci);
> diff --git a/fs/ntfs/namei.c b/fs/ntfs/namei.c
> index 7091b2496fac..61cfa4e16586 100644
> --- a/fs/ntfs/namei.c
> +++ b/fs/ntfs/namei.c
> @@ -309,7 +309,7 @@ static struct dentry *ntfs_lookup(struct inode *dir_ino, struct dentry *dent,
>  		}
>  		nls_name.hash = full_name_hash(dent, nls_name.name, nls_name.len);
>  
> -		dent = d_add_ci(dent, dent_inode, &nls_name);
> +		dent = d_add_ci(dent, dent_inode, &nls_name, flags);
>  		kfree(nls_name.name);
>  		return dent;
>  
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 4a3299abf774..fd480c0e4147 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -368,7 +368,7 @@ xfs_vn_ci_lookup(
>  	/* else case-insensitive match... */
>  	dname.name = ci_name.name;
>  	dname.len = ci_name.len;
> -	dentry = d_add_ci(dentry, VFS_I(ip), &dname);
> +	dentry = d_add_ci(dentry, VFS_I(ip), &dname, flags);
>  	kfree(ci_name.name);
>  	return dentry;
>  }
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index adf239f8205f..97d11f5e6a7b 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -267,7 +267,8 @@ struct dentry *d_duplicate(struct dentry *dentry);
>  /* weird procfs mess; *NOT* exported */
>  extern struct dentry * d_splice_alias_ops(struct inode *, struct dentry *,
>  					  const struct dentry_operations *);
> -extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
> +extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *,
> +				unsigned int);
>  extern bool d_same_name(const struct dentry *dentry, const struct dentry *parent,
>  			const struct qstr *name);
>  extern struct dentry *d_find_any_alias(struct inode *inode);
> 
> base-commit: 3879f51857325da9bf3cfb073280257cd16ae067
> -- 
> 2.50.0.107.gf914562f5916.dirty
> 

