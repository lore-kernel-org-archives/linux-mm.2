Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9BBFEFB5F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1B5A6B0005; Fri, 27 Feb 2026 10:25:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF33C6B0088; Fri, 27 Feb 2026 10:25:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD52C6B0089; Fri, 27 Feb 2026 10:25:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98A846B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:25:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63CAD160141
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:25:23 +0000 (UTC)
X-FDA: 84490610526.03.8D7D481
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 03F1D140010
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:25:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dINi8une;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HSTI1aHB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dINi8une;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HSTI1aHB;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9Lj+MCFwQ65SeHnvmQaDCdaKKYNg9T/G8p+sWH2qz8=;
	b=ijrKjrl602MTLcjix6WRhbJYwhKzzk9w69KMvw2ropwP7z+pkPN9bi9xLHwuRZq4+7GMob
	OOHbGXaRyO/S1H7ak2MSIxtdWufHCrXtG1440eFREHiip7toK6+y+OdjR9HObKZAH4TAA/
	/mOikRpCCnQB5QagKduERtbLL81DEww=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dINi8une;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HSTI1aHB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dINi8une;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HSTI1aHB;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205921; a=rsa-sha256;
	cv=none;
	b=RW+eKk/LwXgBCa01dvoUCARsM3aleVRZkoEwM7VxEaoppL/wYeduza0Ij21gxPPnYlLG2e
	jvcQWWoSBH+XgVCKrQyhcbvHmqFmWO1vAj5mMdhVYMDbBB5/5nlVRBLD819rRFxV4QVKNg
	2L1cReXXmWW4vHWEMvObS+A+2VRIPeo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5B1275BE3C;
	Fri, 27 Feb 2026 15:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Lj+MCFwQ65SeHnvmQaDCdaKKYNg9T/G8p+sWH2qz8=;
	b=dINi8uneytLlfwiLDZTKCU0VnXhcm0QxVjxx3aQqVR9fRNI5Ys4CVeOeecY0KVOpnXBj7h
	wJnqsPM+OCq7uRiL4ESlyzFzMOCZ5id9+v07SLlDfdWU36PShgpuLyYZ5KqW7VU7H2ZudX
	ufkyCxFpSBcZ/yti4B2QsF9nOLN/nT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Lj+MCFwQ65SeHnvmQaDCdaKKYNg9T/G8p+sWH2qz8=;
	b=HSTI1aHByYN8VeVIe6kfQqDDdzzJQeaTr6tBk9A7sh2zMqb6qXaC3/+A2/l7XDARcvCR6D
	dpoYpEhZ5rvMGgAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772205919; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Lj+MCFwQ65SeHnvmQaDCdaKKYNg9T/G8p+sWH2qz8=;
	b=dINi8uneytLlfwiLDZTKCU0VnXhcm0QxVjxx3aQqVR9fRNI5Ys4CVeOeecY0KVOpnXBj7h
	wJnqsPM+OCq7uRiL4ESlyzFzMOCZ5id9+v07SLlDfdWU36PShgpuLyYZ5KqW7VU7H2ZudX
	ufkyCxFpSBcZ/yti4B2QsF9nOLN/nT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772205919;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g9Lj+MCFwQ65SeHnvmQaDCdaKKYNg9T/G8p+sWH2qz8=;
	b=HSTI1aHByYN8VeVIe6kfQqDDdzzJQeaTr6tBk9A7sh2zMqb6qXaC3/+A2/l7XDARcvCR6D
	dpoYpEhZ5rvMGgAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 47D283EA6A;
	Fri, 27 Feb 2026 15:25:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NTGIEV+3oWnKJQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:25:19 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 077C4A06D4; Fri, 27 Feb 2026 16:25:14 +0100 (CET)
Date: Fri, 27 Feb 2026 16:25:14 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 10/14] xattr,net: support limited amount of extended
 attributes on sockfs sockets
Message-ID: <nvbbdg5v2o5tzyzhzfpj2cyldsstgxsnwr7qfr36vwsyks7qjv@ey4qw2ut6q7z>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-10-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-10-c2efa4f74cb7@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03F1D140010
X-Stat-Signature: 4fdxdhks8e6d83rbnszipiipk3yu9idy
X-HE-Tag: 1772205920-343680
X-HE-Meta: U2FsdGVkX1/vkc6EydYKzB1oA21SgwmoRT1OnUKPNEGHCbi/+J/1ee1UAbc6uMDCApPNIYxT0Fn1mZBLIuV1BxYDjpfbrLsWhex4G+rxMA8vtk8sjaUm++YU/YUNH11fVBA9hVfT2flS6gBl6FNZ/F1koxAOHuTfXojNMaebWilNbFmN2hDlNJtX/D3gSpllDvkzpzHVXwf73AcCmA+UWWsyEeRHlOwUgaUMbgwGHpbsCLElmYxEx9d+nDUpkrK+uPIRGt4083GK9Ner0FfjhvaGS9+VKbt16CheS+RfEER/FN9gF6gYb4mbY9OfmnfVr1/PFcTQGp+2lzD6Qz//lfhF0VJTccpmeGx2PJjCe1TVEOmE977L246AFZiu6l7Pnih9mXLru0Zitv6V+lZgbYsjK28cpsU7v1L2RJHTV2WZZsgSsCItm1/5/uY0emRhfBaQ/182KlZENqYwWSw68UuE/H5gkU4G7AOOQFHZqCeNzAxC32pWXm7ERqVqj63ln6nnEM8Sxvuyfln9eQk6Pn4vFWyJaIq/aMwe3VQT2Ta6n+FnShNWsKE3aG/qmVmgs/UuX1JeyOcrS3IMZXJa575J6Ew69+nTdyuoGisPo2RX2xCJ+Dwg4DzFn4JaDhEMOLLmSOd2hUb6OW8Efn/kq2yest9tIA49Km2cJAZo73bKQylX3hHislckaOmdIeo50ZXurkpRSn/j8BcsZASE22iHINnSfvCJpLXaFEEZ4AeMypwXohUXWHBy4z88F7rIWltQNmEC1Ec0Nko8GrU1AsyT7JHcyM4QcCGtptt9ZdrqLxz2302lGeFPeqmOHKrs8rbhHzmKXmUPhHGaQJiyTwWe8t6IARpTqyRSTZYMNP3SN4t8srtgvb+4SW7Ukvl1gS2N1oGW9k6uTU/Jw7dSvVAWN+zl5GonACnPcgNcLHXKFqBFicYo+p9bcllcM8Fuccl4HfBTQHWxhopK4Dv
 KIeqkXlU
 j5YrPCGLvAVtwHNv1wIM6TzDtCoJ1t8BtQPWfC709S5ggQoVwVW9Ntbvuu4Oao8LOocZAZkrLPZkelfr3zvmTT8MJ7D323L0LCsDcsdj1AMV18nzzvHGeexV5iLjfsvqNllNi/5BEuvsdcdpl5bsmFGAU/kJQB15ZiJNxvgD3hx5n30DWTfp19c7ZGp452K/9fnhlXWiCbRtKzW3nJY6heZH72v1AiyNxzbVk33PTMmOLSzpJhM5/MpizrwM44uXV4+8uN9247NW9O2KY9IY3OHXPTh3f14RpnueTUxDX0DWiJyA6S2A6szNwIyGjq0cZFYorsanS3lGmgBSAJwFyU/YDRxFB3/1v66f7m2S9XF3qdyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:06, Christian Brauner wrote:
> Now that we've generalized the infrastructure for user.* xattrs make it
> possible to set up to 128 user.* extended attributes on a sockfs inode
> or up to 128kib. kernfs (cgroupfs) has the same limits and it has proven
> to be quite sufficient for nearly all use-cases.
> 
> This will allow containers to label sockets and will e.g., be used by
> systemd and Gnome to find various sockets in containers where
> high-privilege or more complicated solutions aren't available.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  net/socket.c | 119 +++++++++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 92 insertions(+), 27 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 136b98c54fb3..7aa94fce7a8b 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -315,45 +315,70 @@ static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
>  
>  static struct kmem_cache *sock_inode_cachep __ro_after_init;
>  
> +struct sockfs_inode {
> +	struct simple_xattrs *xattrs;
> +	struct simple_xattr_limits xattr_limits;
> +	struct socket_alloc;
> +};
> +
> +static struct sockfs_inode *SOCKFS_I(struct inode *inode)
> +{
> +	return container_of(inode, struct sockfs_inode, vfs_inode);
> +}
> +
>  static struct inode *sock_alloc_inode(struct super_block *sb)
>  {
> -	struct socket_alloc *ei;
> +	struct sockfs_inode *si;
>  
> -	ei = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
> -	if (!ei)
> +	si = alloc_inode_sb(sb, sock_inode_cachep, GFP_KERNEL);
> +	if (!si)
>  		return NULL;
> -	init_waitqueue_head(&ei->socket.wq.wait);
> -	ei->socket.wq.fasync_list = NULL;
> -	ei->socket.wq.flags = 0;
> +	si->xattrs = NULL;
> +	simple_xattr_limits_init(&si->xattr_limits);
> +
> +	init_waitqueue_head(&si->socket.wq.wait);
> +	si->socket.wq.fasync_list = NULL;
> +	si->socket.wq.flags = 0;
> +
> +	si->socket.state = SS_UNCONNECTED;
> +	si->socket.flags = 0;
> +	si->socket.ops = NULL;
> +	si->socket.sk = NULL;
> +	si->socket.file = NULL;
>  
> -	ei->socket.state = SS_UNCONNECTED;
> -	ei->socket.flags = 0;
> -	ei->socket.ops = NULL;
> -	ei->socket.sk = NULL;
> -	ei->socket.file = NULL;
> +	return &si->vfs_inode;
> +}
> +
> +static void sock_evict_inode(struct inode *inode)
> +{
> +	struct sockfs_inode *si = SOCKFS_I(inode);
> +	struct simple_xattrs *xattrs = si->xattrs;
>  
> -	return &ei->vfs_inode;
> +	if (xattrs) {
> +		simple_xattrs_free(xattrs, NULL);
> +		kfree(xattrs);
> +	}
> +	clear_inode(inode);
>  }
>  
>  static void sock_free_inode(struct inode *inode)
>  {
> -	struct socket_alloc *ei;
> +	struct sockfs_inode *si = SOCKFS_I(inode);
>  
> -	ei = container_of(inode, struct socket_alloc, vfs_inode);
> -	kmem_cache_free(sock_inode_cachep, ei);
> +	kmem_cache_free(sock_inode_cachep, si);
>  }
>  
>  static void init_once(void *foo)
>  {
> -	struct socket_alloc *ei = (struct socket_alloc *)foo;
> +	struct sockfs_inode *si = (struct sockfs_inode *)foo;
>  
> -	inode_init_once(&ei->vfs_inode);
> +	inode_init_once(&si->vfs_inode);
>  }
>  
>  static void init_inodecache(void)
>  {
>  	sock_inode_cachep = kmem_cache_create("sock_inode_cache",
> -					      sizeof(struct socket_alloc),
> +					      sizeof(struct sockfs_inode),
>  					      0,
>  					      (SLAB_HWCACHE_ALIGN |
>  					       SLAB_RECLAIM_ACCOUNT |
> @@ -365,6 +390,7 @@ static void init_inodecache(void)
>  static const struct super_operations sockfs_ops = {
>  	.alloc_inode	= sock_alloc_inode,
>  	.free_inode	= sock_free_inode,
> +	.evict_inode	= sock_evict_inode,
>  	.statfs		= simple_statfs,
>  };
>  
> @@ -417,9 +443,48 @@ static const struct xattr_handler sockfs_security_xattr_handler = {
>  	.set = sockfs_security_xattr_set,
>  };
>  
> +static int sockfs_user_xattr_get(const struct xattr_handler *handler,
> +				 struct dentry *dentry, struct inode *inode,
> +				 const char *suffix, void *value, size_t size)
> +{
> +	const char *name = xattr_full_name(handler, suffix);
> +	struct simple_xattrs *xattrs;
> +
> +	xattrs = READ_ONCE(SOCKFS_I(inode)->xattrs);
> +	if (!xattrs)
> +		return -ENODATA;
> +
> +	return simple_xattr_get(xattrs, name, value, size);
> +}
> +
> +static int sockfs_user_xattr_set(const struct xattr_handler *handler,
> +				 struct mnt_idmap *idmap,
> +				 struct dentry *dentry, struct inode *inode,
> +				 const char *suffix, const void *value,
> +				 size_t size, int flags)
> +{
> +	const char *name = xattr_full_name(handler, suffix);
> +	struct sockfs_inode *si = SOCKFS_I(inode);
> +	struct simple_xattrs *xattrs;
> +
> +	xattrs = simple_xattrs_lazy_alloc(&si->xattrs, value, flags);
> +	if (IS_ERR_OR_NULL(xattrs))
> +		return PTR_ERR(xattrs);
> +
> +	return simple_xattr_set_limited(xattrs, &si->xattr_limits,
> +					name, value, size, flags);
> +}
> +
> +static const struct xattr_handler sockfs_user_xattr_handler = {
> +	.prefix = XATTR_USER_PREFIX,
> +	.get = sockfs_user_xattr_get,
> +	.set = sockfs_user_xattr_set,
> +};
> +
>  static const struct xattr_handler * const sockfs_xattr_handlers[] = {
>  	&sockfs_xattr_handler,
>  	&sockfs_security_xattr_handler,
> +	&sockfs_user_xattr_handler,
>  	NULL
>  };
>  
> @@ -572,26 +637,26 @@ EXPORT_SYMBOL(sockfd_lookup);
>  static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
>  				size_t size)
>  {
> -	ssize_t len;
> -	ssize_t used = 0;
> +	struct sockfs_inode *si = SOCKFS_I(d_inode(dentry));
> +	ssize_t len, used;
>  
> -	len = security_inode_listsecurity(d_inode(dentry), buffer, size);
> +	len = simple_xattr_list(d_inode(dentry), READ_ONCE(si->xattrs),
> +				buffer, size);
>  	if (len < 0)
>  		return len;
> -	used += len;
> +
> +	used = len;
>  	if (buffer) {
> -		if (size < used)
> -			return -ERANGE;
>  		buffer += len;
> +		size -= len;
>  	}
>  
> -	len = (XATTR_NAME_SOCKPROTONAME_LEN + 1);
> +	len = XATTR_NAME_SOCKPROTONAME_LEN + 1;
>  	used += len;
>  	if (buffer) {
> -		if (size < used)
> +		if (size < len)
>  			return -ERANGE;
>  		memcpy(buffer, XATTR_NAME_SOCKPROTONAME, len);
> -		buffer += len;
>  	}
>  
>  	return used;
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

