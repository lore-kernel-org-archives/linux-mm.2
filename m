Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48ACFEFB5D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:09:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05AC46B0005; Fri, 27 Feb 2026 10:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0088A6B0088; Fri, 27 Feb 2026 10:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F7D6B0089; Fri, 27 Feb 2026 10:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8B3D6B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:09:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 730D759ECE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:09:24 +0000 (UTC)
X-FDA: 84490570248.02.4866762
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C20F140017
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:09:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n4TpTiQo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="frjS/mKq";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n4TpTiQo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="frjS/mKq";
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772204962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgC4TAut0oAE46fR5Ae6UByQ/Iym7IYeieMNOTiDBXU=;
	b=3HDKF8WNaVKJDZDCKFnM81Ms0r3TZpiy6hUd3IxB/Z3K7ZwzZLri5Q5AnCEW2li8GviQcD
	lWjo1pwLtL5buSo6cMljKam4l/53ID00fxd3J+779qwFFRC99eI/1oY0aamjZmy67gNXbm
	EHZhWj/rxjLnX0M89GGU2+CiRMvywFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772204962; a=rsa-sha256;
	cv=none;
	b=JrEfllB29w5ReuNnyAIw95GkgJVqYjN9URUVl4NKvjw8NmoYwFgjx1boJL/0BihsiZEBCq
	GQtmq2SpM/rIhymam74qFsFksozc7ppoJ8Cc0P9+arY4vxLqq/c2++3C2iHHeXsjWQy51d
	8aUCjM+CCb2Z0AndR0FHoVJeWU57UU0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n4TpTiQo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="frjS/mKq";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n4TpTiQo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="frjS/mKq";
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 560223FA0D;
	Fri, 27 Feb 2026 15:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772204960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgC4TAut0oAE46fR5Ae6UByQ/Iym7IYeieMNOTiDBXU=;
	b=n4TpTiQo7AH/0uoo++HfsYLrlTXL8UK00zJUZSewWB+J9Xg/rbCYE6aWAksOV4N5aan7Fo
	kaSS8i+8J2EGIq9jijKgQgKPGK9Lm6G9CjT2msnz9SDkcvRWe04rmNHCF55M7si0ZnPElF
	Du4XWBE0zpoUUPa9Wd8ApwAtnDJs32M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772204960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgC4TAut0oAE46fR5Ae6UByQ/Iym7IYeieMNOTiDBXU=;
	b=frjS/mKqtQ041leJMmhBzqFTIWXixTqYMtKv1wh/jYW0R1WZiqPIdmGbbyC58w30PY6FeX
	mA2R3jREjsJnubBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772204960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgC4TAut0oAE46fR5Ae6UByQ/Iym7IYeieMNOTiDBXU=;
	b=n4TpTiQo7AH/0uoo++HfsYLrlTXL8UK00zJUZSewWB+J9Xg/rbCYE6aWAksOV4N5aan7Fo
	kaSS8i+8J2EGIq9jijKgQgKPGK9Lm6G9CjT2msnz9SDkcvRWe04rmNHCF55M7si0ZnPElF
	Du4XWBE0zpoUUPa9Wd8ApwAtnDJs32M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772204960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IgC4TAut0oAE46fR5Ae6UByQ/Iym7IYeieMNOTiDBXU=;
	b=frjS/mKqtQ041leJMmhBzqFTIWXixTqYMtKv1wh/jYW0R1WZiqPIdmGbbyC58w30PY6FeX
	mA2R3jREjsJnubBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4AA553EA69;
	Fri, 27 Feb 2026 15:09:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nLYzEqCzoWkAFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Feb 2026 15:09:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0818AA06D4; Fri, 27 Feb 2026 16:09:16 +0100 (CET)
Date: Fri, 27 Feb 2026 16:09:15 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
	linux-mm@kvack.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 05/14] pidfs: adapt to rhashtable-based simple_xattrs
Message-ID: <qxctwu77wp7gv4ua3hn6kg7r2vt57laomn3ebjisemzzaybagy@mvoo2wpvu2ux>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-5-c2efa4f74cb7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216-work-xattr-socket-v1-5-c2efa4f74cb7@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0C20F140017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mq5q1i9qhxu7o87ak61bprcdjb66pezh
X-HE-Tag: 1772204961-648160
X-HE-Meta: U2FsdGVkX1+8IK6fNCxjtqqyRPmOby4A1gyzGbOyraOWURBfU5ab5G7o9tOAhrY5EMOrD9eyUP7oNnT14SM3TzdeKpfRpktINLoTeiAElLhfUvK+joL3XkS/YQiTuJ/ndags08/2WAGbxeYnEm9fJfZa+5Sye4xP2dOIdd9cY9hAHnHafuGJZSddADLgCUTyZD2DJ42I8IOP7gavyCf8y1H6PmYB+pLngs+TlYOadiFp4QP39PTLUOdIOaJ0EPpXQUffhXAnKBBmxprSTcUHlXTE5jUIWivQrDSyZC1u/YlDJxQIosGa+7V3cIfG0E3NFQEfeZl+ycmEXHbbbFoi5lbHW71sKI2X3Xg+xrDmLYMcU5GXKK7VeQSlYQrUAU3Qwxj5Kls6P+VgpxPGhyPyErH07k22DekAJCH36NdQBpHknWZeXtEnOr5GmzT3bQ+PnsUEVNOZPuHRgur3e+lAsIeDtcriP2Don45QeEp3rijZ70q1kiuKsVeTyaCyncP66DL7329y2xYds5AmB4QeZ6oIr1FateWLu3thQ/KlHsoapBpI6T48fqT7PmKuXSvG48AbzCRzcK7CI1bjvOt72PU9EkkYgquboiBcV3KyA6tLShMZ1mZl2Zt1GNukNRdmj6QDptUNMy4P6LNdTiNai7cSnukeERNF4cIpQCP8fH2A3Czl7lPGs3xdQAJNN10h4RIemGmsf90ldw1h/+9mL0rpIyYCl8E6CkoWbTe4y73Cc8tM9j9jLTCfqVVL03CE1VYSf55S/tzgSVWhYod3ow1IvTNaQWsMZZ60mXuS/IG0pNB9rvFuDp6iGnNcA5KuszfVmGCunlqXbzu4ju2i7lfWFuzd8f7465zg6vEq6f6JaEGwuR77WSctW/KswvI5cDd6Y4CaaPfxT/9Zaq7zAlzY3caySZl5Oa3POH3PR9q/jsVGAiH70PFIHv3MkWPKgvh6lmNxO93n8VfMwh5
 zIOL9xbA
 +iCw/wRV6yYVR4jj8cbP5QdP18SNQIHs/ofpMrSLmcg/Qu+DNNh6hQWT9q8ejHespIa0LQiaGHc/6A7eBa3b4mvyECjjlyhE/bTVK7we9aZ31bXa5e6DHJZmWbS3Q5S3pEbtV9PzoYfVACXVsD6kwjeiC0wV2EQgOFSsYVqSrljes6HbOz5RxC1dXuusHkrB0e9Zi5yzVCnBxCVTTOyYdmvr+x/5GPQvWReeRQaD5Rlv+BqgAytcj4duElqW29lMfFpcgE0I9PGseA4nY6njt5uXubxaCj0fudsPg/7Tbwlry53uZll24ofFBlE0mSjirJtkN+ju4ziwYQjDVe4BLeE8nbDLBZFqb1ZKm71McSIZGaFlCzhu6t7fqO299ANT+rYHMcx80dasGooHVsh0V+KTXrCAg8EiTj/il
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 14:32:01, Christian Brauner wrote:
> Adapt pidfs to use the rhashtable-based xattr path by switching from a
> dedicated slab cache to simple_xattrs_alloc().
> 
> Previously pidfs used a custom kmem_cache (pidfs_xattr_cachep) that
> allocated a struct containing an embedded simple_xattrs plus
> simple_xattrs_init(). Replace this with simple_xattrs_alloc() which
> combines kzalloc + rhashtable_init, and drop the dedicated slab cache
> entirely.
> 
> Use simple_xattr_free_rcu() for replaced xattr entries to allow
> concurrent RCU readers to finish.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

One question below:

> +static LLIST_HEAD(pidfs_free_list);
> +
> +static void pidfs_free_attr_work(struct work_struct *work)
> +{
> +	struct pidfs_attr *attr, *next;
> +	struct llist_node *head;
> +
> +	head = llist_del_all(&pidfs_free_list);
> +	llist_for_each_entry_safe(attr, next, head, pidfs_llist) {
> +		struct simple_xattrs *xattrs = attr->xattrs;
> +
> +		if (xattrs) {
> +			simple_xattrs_free(xattrs, NULL);
> +			kfree(xattrs);
> +		}
> +		kfree(attr);
> +	}
> +}
> +
> +static DECLARE_WORK(pidfs_free_work, pidfs_free_attr_work);
> +

So you bother with postponing the freeing to a scheduled work because
put_pid() can be called from a context where acquiring rcu to iterate
rhashtable would not be possible? Frankly I have hard time imagining such
context (where previous rbtree code wouldn't have issues as well), in
particular because AFAIR rcu is safe to arbitrarily nest. What am I
missing?

								Honza


>  void pidfs_free_pid(struct pid *pid)
>  {
> -	struct pidfs_attr *attr __free(kfree) = no_free_ptr(pid->attr);
> -	struct simple_xattrs *xattrs __free(kfree) = NULL;
> +	struct pidfs_attr *attr = pid->attr;
>  
>  	/*
>  	 * Any dentry must've been wiped from the pid by now.
> @@ -169,9 +196,10 @@ void pidfs_free_pid(struct pid *pid)
>  	if (IS_ERR(attr))
>  		return;
>  
> -	xattrs = no_free_ptr(attr->xattrs);
> -	if (xattrs)
> -		simple_xattrs_free(xattrs, NULL);
> +	if (likely(!attr->xattrs))
> +		kfree(attr);
> +	else if (llist_add(&attr->pidfs_llist, &pidfs_free_list))
> +		schedule_work(&pidfs_free_work);
>  }
>  
>  #ifdef CONFIG_PROC_FS
> @@ -998,7 +1026,7 @@ static int pidfs_xattr_get(const struct xattr_handler *handler,
>  
>  	xattrs = READ_ONCE(attr->xattrs);
>  	if (!xattrs)
> -		return 0;
> +		return -ENODATA;
>  
>  	name = xattr_full_name(handler, suffix);
>  	return simple_xattr_get(xattrs, name, value, size);
> @@ -1018,22 +1046,16 @@ static int pidfs_xattr_set(const struct xattr_handler *handler,
>  	/* Ensure we're the only one to set @attr->xattrs. */
>  	WARN_ON_ONCE(!inode_is_locked(inode));
>  
> -	xattrs = READ_ONCE(attr->xattrs);
> -	if (!xattrs) {
> -		xattrs = kmem_cache_zalloc(pidfs_xattr_cachep, GFP_KERNEL);
> -		if (!xattrs)
> -			return -ENOMEM;
> -
> -		simple_xattrs_init(xattrs);
> -		smp_store_release(&pid->attr->xattrs, xattrs);
> -	}
> +	xattrs = simple_xattrs_lazy_alloc(&attr->xattrs, value, flags);
> +	if (IS_ERR_OR_NULL(xattrs))
> +		return PTR_ERR(xattrs);
>  
>  	name = xattr_full_name(handler, suffix);
>  	old_xattr = simple_xattr_set(xattrs, name, value, size, flags);
>  	if (IS_ERR(old_xattr))
>  		return PTR_ERR(old_xattr);
>  
> -	simple_xattr_free(old_xattr);
> +	simple_xattr_free_rcu(old_xattr);
>  	return 0;
>  }
>  
> @@ -1108,11 +1130,6 @@ void __init pidfs_init(void)
>  					 (SLAB_HWCACHE_ALIGN | SLAB_RECLAIM_ACCOUNT |
>  					  SLAB_ACCOUNT | SLAB_PANIC), NULL);
>  
> -	pidfs_xattr_cachep = kmem_cache_create("pidfs_xattr_cache",
> -					       sizeof(struct simple_xattrs), 0,
> -					       (SLAB_HWCACHE_ALIGN | SLAB_RECLAIM_ACCOUNT |
> -						SLAB_ACCOUNT | SLAB_PANIC), NULL);
> -
>  	pidfs_mnt = kern_mount(&pidfs_type);
>  	if (IS_ERR(pidfs_mnt))
>  		panic("Failed to mount pidfs pseudo filesystem");
> 
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

