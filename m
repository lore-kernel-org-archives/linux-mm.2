Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D38606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 08:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZPAQabU1
Received: by kanga.kvack.org (Postfix)
	id D5D906B05B6; Sun, 22 Nov 2026 03:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6F76B05B7; Sun, 22 Nov 2026 03:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAF8F6B05B8; Sun, 22 Nov 2026 03:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AAF76B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 03:30:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 471371C3FAF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:30:37 +0000 (UTC)
X-FDA: 85462083714.25.FAFD13D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98369140009
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:30:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPAQabU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795336235;
	b=Jt4YGd1yGM3Ew153uQd1v/zwX5urCCYX4zLGCbEdnu32UIBBD0bW5p542JdiG54/CZmnKy
	ssnEZo0jRsYvta9lUuw/v2j5mSM5dlCZ2ondxeh539FjfwappwNzt6dJzMgCzypNDSeJKS
	wIBzcruVyL5sutsm6FLLEpSRS4wpHYM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795336235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVMitbvzEEmSFg6nLCYHtR7hh58gjDs1Bk3LU+etKdY=;
	b=0wG09dL5PaRVk6yf1mbgpaBeC7x/iY0ChV57GyNeh4fPeq2OmnNJMZALneY5k97ptR6mGZ
	BLjqBpVV7Pps7rNbzNoSa9u1qnD00DVEvono9YmHIs9Ut8OuYnIQIgXxXICwyi1uXmlLe4
	CkMpJMpHDGmGWPTkrmL8JAX5Rz9lMD0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPAQabU1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D79A46020F;
	Sun, 22 Nov 2026 08:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C9B1F000CA;
	Sun, 22 Nov 2026 08:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795336234;
	bh=KVMitbvzEEmSFg6nLCYHtR7hh58gjDs1Bk3LU+etKdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZPAQabU1BePmrMq1hSvC/gXYeHpMv3hsNLTgYgFsbsZYBjvoU8F4SYPbgn8HM2+BK
	 tUMLsw4qdWSYeUp4pXwpk37kzBAbexTs1c1AB6VDDUfpvOU5J+Vfv0q3OmG8I4BBxw
	 +pNt684TZ0TN9fTBbI7KcvEdfr1XSn1ZymwRHSMPLggHzBGe/Us6OOJ/QydJc0S7V9
	 bijhgr2ro3phmAKTKfhcOC325q3RUyPpFNV+GYAVKhD+htss+SuaoPRf7Ji4xHs4mO
	 lgvkGxuaBcRLQklnKHzCb+KyLI2+KXtX2nH6eBNMigJIZJMDIsvgyQBLBQtIhDizBB
	 Jm55vrsim8/jg==
Date: Sun, 22 Nov 2026 10:30:28 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Baek Kyu, Kim" <pocj8ur4in@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/secretmem: Keep locked memory accounting until
 inode eviction
Message-ID: <awKoJJ6bxqBltonr@kernel.org>
References: <20261030152407.113568-1-pocj8ur4in@gmail.com>
 <20261121164020.1465498-1-pocj8ur4in@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121164020.1465498-1-pocj8ur4in@gmail.com>
X-Stat-Signature: 4cbrcnezxet8p7re8duenuokxdokikmc
X-Rspam-User:
X-Rspamd-Queue-Id: 98369140009
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795336235-801408
X-HE-Meta: U2FsdGVkX1+hvHMZMi+/Qf1eSAMzwTc8M4L1m8gNaglWHCGpMkqo3zGtMjz2PiiLNT1QGHlSUYrf+Cb2fEQdxFAZJRADTJknLz9qPqYLIKm2H+e0Lm7iFlz67A99MlRGSDyo9ch8bxEWcT0aC2PXP0gUzBtN2MSg8aFEiw5UK/W9RHM4kcEtYI7jFhu1COXGGbx0Pw5OGd2RTM1QX7wXePJa9TJUjTl6R245P7Y9u4hH1ivuTOsbMPAalAf8/diI1KLKP10fTaWpuf43mLBTT5Mj95dNSs9TZVvDfXzw5ONuXr0C3kDe1iMJg+Lpv9j2hP/rWR6QoLi+Cevy2oIDi+0aFN4NimpnmhiuOkCw2YsOQTsWbO6QeOTHBGLlUlXCQOEf4gTEoAmeIN2Dltv6AJH8AIvU51M9JbZ5YObR+PpUMkp/l0m29xYGErVuZL9Cw/lccwNyShq1LqooJul1NAapKIfXe0tKhboDM6uAe/a10fcSKy5HRZjjFJXOYFcvm6YmO/o7yjFC8b04aJTxcjMtA9dShyyqqLAdKHVLuaY5nJq+j95J6UY1q+6gnHZdQPfPT2dHYzow8+/Kd0MRv0e5UvQ3fvFvNd4MLysZqpHpYS8I5fSMjx5sMPJB2ZnMoi+egycikTl6gRk/MdSIjJGIckS2A0aAsSYzJ9gj/MnC+yyjpyDmv0+UpYtZwLS+sXKh+Gs2v+I5IYl1TB9Imfo/slZslQEbzNHE/WCCV8dI9FvJjSmnDAk0gDfRxA9Cdty7yOPLl5jmCVp6FkCSFUqMm0RMdpuxn6z9jk7SkhSjqM/Zds+0JSE7Tkv4+J/mTkhVtoehAy6CSjJznmzvQ4LHCep3aI1+CIuHLl5MIrLMntUru6uoeDjMFHOd1P9U1Ymb91N8NKMtROWI/PVDMe/ufbDvwdZo6EfMptwhs+TN09Xtc3llMSfBqmmol+CQ/nz8JECdRZbK5MTTej4
 x8KuWcW6
 wKBgE0GigbGkZsmFk2PnBL1tN91jb6LYIqi+Z8uz8Ec5RcfxYjCpOcDiHIggy0Rs8ADISDF5wJhxDQ7sT6aoouX+X9u4V4CnZ4W3kcUPNMga+IonjAO9q3tAh3Ku2rpnwFSBAoFXO8WwwSJdU1h/Fu2jo7T91WWjQcsAYdqxozEX+fA0Bx+nwaYcERPM/CJfyPY5z5Mi4pdX0QPWMiBTIy9H9OJT0Mc17lnR8RYbOYyZ34WcsGzed/S6bAyMTvDIVCY2O+KGuxr8YlMYKpGO6psfRHJk/XNq2aAgo9E5jZgLPPDsqJd7u/puYdevW08ud/+RHwkECYhGilUMO98rdjDlCs8M0CQsXzHYm4GhgsSb1aA10ix1nMNzYbVKcsIvvcMryhgDcvT/i++HCKjAi4tcOD2oQ8n7cVWaYBCfq+pRfV0nGk/fpToE2/0qdcKKwRp6ONSTYaogNSP9ZFl49yQmVQ5sQ2Zmopv08RBddhJXhwBKE9qlodaf2iVzX93x9wO9xNJsNvsKMG9ZqSFdAyhwOnFESzXr/124XDwiWIYvb2ZhA58KNgKw2mRHi6qDT4Ohjmo7i6XPJVpgwB0fediK30noMuWYw85cr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Please don't send vN+1 as a reply to vN next time please.

On Sun, Nov 22, 2026 at 01:40:20AM +0900, Baek Kyu, Kim wrote:
> A secretmem inode can outlive its original file. An O_PATH descriptor
> opened through /proc/self/fd keeps the inode and its unevictable folios
> alive after the mapping and original descriptor are closed. The file
> release path nevertheless drops the locked-memory charge, allowing the
> same user to reuse RLIMIT_MEMLOCK while those folios remain allocated.
> 
> Move private-state and locked-memory accounting cleanup to inode eviction,
> after truncating the page cache. Keep secretmem_users active over the same
> lifetime so that the hibernation guard covers retained secret pages.
> 
> Allocate private state before inode creation and release it if the
> secure-inode helper fails. Attach it immediately after creation so
> later failures can use iput() for cleanup. An LSM denial inside the
> helper can call iput() before i_private is set; skip private cleanup
> at eviction when i_private is NULL.
> 
> On arm64 QEMU with an 8 KiB RLIMIT_MEMLOCK, the original kernel allowed
> an additional 4 KiB secretmem fault while O_PATH retained two pages.
> v2 rejected that fault with SIGBUS and allowed it after O_PATH closed.
> Injected LSM denial and file-allocation failure completed without a
> crash; file-allocation cleanup returned secretmem_users to zero.
> KASAN, lockdep, hibernation and long-running concurrency were not
> tested in this v2 run.
> 
> Fixes: 97d34aa65c29 ("mm/secretmem: properly account locked pages")
> Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
> ---
> Changes in v2:
>   - Allocate state before inode creation, as Mike Rapoport suggested,
>     and free it if the secure-inode helper fails.
>   - Guard private-state cleanup in secretmem_evict_inode() because an
>     LSM denial can call iput() before i_private is set.
> 
> Link to v1: https://lists.openwall.net/linux-kernel/2026/10/30/1883
> 
>  mm/secretmem.c | 58 ++++++++++++++++++++++++++++------------------------------
>  1 file changed, 28 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index b3f79ad56790..5a7378b62bb2 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -189,14 +189,7 @@ static void secretmem_destroy_inode_priv(struct inode *inode)
>  	free_uid(state->user);
>  	kfree(state);
>  	inode->i_private = NULL;
> -}
> -
> -static int secretmem_release(struct inode *inode, struct file *file)
> -{
>  	atomic_dec(&secretmem_users);
> -	secretmem_destroy_inode_priv(inode);
> -
> -	return 0;
>  }
>  
>  static int secretmem_mmap_prepare(struct vm_area_desc *desc)
> @@ -216,7 +209,6 @@ bool vma_is_secretmem(struct vm_area_struct *vma)
>  }
>  
>  static const struct file_operations secretmem_fops = {
> -	.release	= secretmem_release,
>  	.mmap_prepare	= secretmem_mmap_prepare,
>  };
>  
> @@ -264,39 +256,34 @@ static const struct inode_operations secretmem_iops = {
>  
>  static struct vfsmount *secretmem_mnt;
>  
> -static int secretmem_init_inode_priv(struct inode *inode)
> -{
> -	struct secretmem_inode_state *state;
> -
> -	state = kzalloc_obj(*state);
> -	if (!state)
> -		return -ENOMEM;
> -
> -	state->user = get_uid(current_user());
> -	inode->i_private = state;
> -	return 0;
> -}
> -
>  static struct file *secretmem_file_create(unsigned long flags)
>  {
> +	struct secretmem_inode_state *state;
>  	struct file *file;
>  	struct inode *inode;
>  	const char *anon_name = "[secretmem]";
>  	int err;
>  
> +	state = kzalloc_obj(*state);
> +	if (!state)
> +		return ERR_PTR(-ENOMEM);
> +	state->user = get_uid(current_user());
> +
>  	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
> -	if (IS_ERR(inode))
> +	if (IS_ERR(inode)) {
> +		free_uid(state->user);
> +		kfree(state);

Please don't do cleanups inside if (err), use goto.

See https://docs.kernel.org/process/coding-style.html#centralized-exiting-of-functions

>  		return ERR_CAST(inode);
> +	}
>  
> -	err = secretmem_init_inode_priv(inode);
> -	if (err)
> -		goto err_free_inode;
> +	inode->i_private = state;
> +	atomic_inc(&secretmem_users);
>  
>  	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
>  				 O_RDWR | O_LARGEFILE, &secretmem_fops);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
> -		goto err_free_priv;
> +		goto err_free_inode;

I think here we lost free_uid().

>  	}
>  
>  	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
> @@ -309,11 +296,7 @@ static struct file *secretmem_file_create(unsigned long flags)
>  	inode->i_mode |= S_IFREG;
>  	inode->i_size = 0;
>  
> -	atomic_inc(&secretmem_users);
> -
>  	return file;
> -err_free_priv:
> -	secretmem_destroy_inode_priv(inode);

What prevents moving this between iput() and return err?

>  err_free_inode:
>  	iput(inode);
>  	return ERR_PTR(err);
> @@ -335,6 +318,20 @@ SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
>  	return FD_ADD(flags & O_CLOEXEC, secretmem_file_create(flags));
>  }
>  
> +static void secretmem_evict_inode(struct inode *inode)
> +{
> +	truncate_inode_pages_final(&inode->i_data);
> +	clear_inode(inode);
> +	/* The filesystem root and failed secure inodes have no private state. */
> +	if (inode->i_private)
> +		secretmem_destroy_inode_priv(inode);
> +}
> +
> +static const struct super_operations secretmem_super_ops = {
> +	.statfs		= simple_statfs,
> +	.evict_inode	= secretmem_evict_inode,
> +};
> +
>  static int secretmem_init_fs_context(struct fs_context *fc)
>  {
>  	struct pseudo_fs_context *ctx;
> @@ -342,6 +339,7 @@ static int secretmem_init_fs_context(struct fs_context *fc)
>  	ctx = init_pseudo(fc, SECRETMEM_MAGIC);
>  	if (!ctx)
>  		return -ENOMEM;
> +	ctx->ops = &secretmem_super_ops;
>  
>  	return 0;
>  }

-- 
Sincerely yours,
Mike.

