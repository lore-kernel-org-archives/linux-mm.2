Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF44E9B342
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 10:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9FC6B0005; Mon,  2 Mar 2026 05:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CB86B0089; Mon,  2 Mar 2026 05:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BD66B008A; Mon,  2 Mar 2026 05:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B74FC6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 05:07:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FBE11B90D9
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:07:02 +0000 (UTC)
X-FDA: 84500694684.12.AE60474
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC0191C0003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:07:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HodwTgYJ;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772446020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+nErJpy/VyK0KcK69oybl4UKerIYZZqR6fXTYmDKhJs=;
	b=rTdBaor3/3TvnD1QA5eTqYdlAhLreAyeSqO4O8XG5zdCb9kLkktmLTyp7YAkbEL83EccIi
	hf4e20/kLW4HNYp9WAhLxR2YvaXsShVW170kju2inOozb8wtX4v3Y9Pe5KqKEVDIDb9nVx
	UmX8uoxky/6SJB9Ivvk5dS8yzvsp824=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772446020; a=rsa-sha256;
	cv=none;
	b=2PG7irrQW8kC6ho1pRKlFAvd4ou507lLJj4ZzHcQNKmtiRy7rS3dMTnTqwIngi8q7tmvMT
	IimiI9hKDNBj6UMeiGOl4EEmE65/nwXVFIzqwoyf/miMbmiqe3UUS+ueqUW7x9OKMdFS8L
	+Tj4l0LJvsdjbrWfPcIBPD2sGpsUZuo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HodwTgYJ;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D19B2433C1;
	Mon,  2 Mar 2026 10:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9137CC19425;
	Mon,  2 Mar 2026 10:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772446019;
	bh=g3floAcObkvaeafCOJ6rhcIBNt3NL60xTBljK0LwcnM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HodwTgYJRXawuioz6fWJbfhRDuJN9ptuur5qsUNjgkqN0KmODfHpQRQJWspSniAjF
	 nVtktb3KfiT7easFF+PRVx8w7mBAOpd5sCjcthpTJ3rarmA49p/diJ+WKo9u34xOHI
	 +4LbxYX7+gfPmg2CerBaEUWWDTI8Q7YkEwTvFnc7LXMvrTRT5xuFHe2VxdL+g2zejF
	 FBhUl2mXFNvFK0jRBjJP9o0K+HCO/fHK1HLTjuHwUWkcA6gcguQtkJeeIKNpxW6XI3
	 uTzyGPL3Qqs2GuL+HH1BfT7mBnEZA4ml1+oVXaxlNsY01vGXZW0eoWfRuy58lxNrYu
	 DKAwDOS8XRyIA==
Date: Mon, 2 Mar 2026 11:06:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Jeff Layton <jlayton@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Jann Horn <jannh@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 04/14] kernfs: adapt to rhashtable-based simple_xattrs
 with lazy allocation
Message-ID: <20260302-wahnsinn-bettdecken-2107be02c746@brauner>
References: <20260216-work-xattr-socket-v1-0-c2efa4f74cb7@kernel.org>
 <20260216-work-xattr-socket-v1-4-c2efa4f74cb7@kernel.org>
 <3cnmtqmakpbb2uwhenrj7kdqu3uefykiykjllgfbtpkiwhaa4s@sghkevv7jned>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3cnmtqmakpbb2uwhenrj7kdqu3uefykiykjllgfbtpkiwhaa4s@sghkevv7jned>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CC0191C0003
X-Stat-Signature: gcwww5ghuu8kw4xr4exboszund13zqd7
X-Rspam-User: 
X-HE-Tag: 1772446020-959902
X-HE-Meta: U2FsdGVkX19H/aIwV2i02BXm2rmdhncqMZKCOEM51+v/YuTA8F58/WGBIUuxUrnJwFWJBBVu8I2h5CdLuoC0WKi18eQEv51kCN+J5vjYAwYIJZb8wgW1UlsdMfG4sNXOjcWhARA79o3ACg9yrvh5sgEAf9Vy9atO+hibs84daRLUOUDZvLf9VBc0X2UXSU90rRv2fms8FjMay5HrlZXYIJzuVEpyoVf9PoYfIwAatnLBb7QcCGnmPySk/Bx7w1rUaiaZ/J07kClVpIBrMwLFaEoCKQbw1OJ12F4vHRFX9fb134bxNA+ru3Um/7OJdWYgVhgW90+c79pLC22OhdEHozZZELHXV/lt1ezgvTkRz0jbvIkDsIRVr34rfitSGWRKlwSKXvK18HPjg2Hkj6GfsTiZVJuEsovCcR2dk6xR1tmMxOfKxKhohTNGXdY9l8FBGd5Qgz/nJsX4AlPHlF2Gs00SQb54PKskGAASSnTz35b3ECBseYVgYjQ3RKDTAnDP2StOR/V4IqiS9X9dd7nrZM2vv5+6AKTzXpD+wh2BOEfGNNE87YN+pTQyh9xrzGW61OmA32Yoy1v2PRSimVMkmC+CH/FlqpAS/4DF1Z4nEOqGNe0D3gTwiucUxK7QEjnBhmIOuPsZj/suqtibLMCnmrPHegWNhkyCFb8hjwyF1KmsLvE1O9herBQwG+o+qAmMtWpSs4SwlfOGCHyIKUUGCcQENo0ikX43k7/tHTwjqQCx8vL4lMfgtm5ogBVdEJoGPYbQfIprU8lvs0mYF4vFWqTKZDYTDCoRvOmmNoji6SCiqDNEJE6TKyajFyIRZ7bv/fK5htxfllEEdAt0eFIbhiNHvj05Qi8aKnT3g+aDqBPurCbN1MBXJt978/Wygj2/VJ9r1Zj+FgxRIwXEwIm10fv1gjsQ67HEeYZy3skvWpaDi+tlmz6pVpmQyf9ZrmaVfgB8aOwdTYthFFrDCeO
 YyFUwiEl
 RreXNtGeh2pEDg+7gLaP8vCJHa2YS8WLG0gCzyhXyrcBjQRYrM7NC89HIjWFXj/224ZWb5fuzRwSzOLHJth3gjO55MHF7EF1ZczJIq55QTuHpNE/lZrPXVkv1boqJ+MqlRKQRgQwue87VBBvZu0vnZwm6mj1hLaV+8uAnLfEqVVS96pCqDN1z2jf3n19cUii2E+Pb81ZadjhOFqmWKczeK+C6tfj5WU7jxy0fZbL1r1t2HZXS+sNfR6kI21XNBDmkdlMuX64cn4LUzo5s6c4TBxzZAMN7A8iwJk32wYkkd9vuQCwNKdJuVRBG6MPWRmqcnqecD3TdcQTEn2hEhn8c/ZnwFdAAdcbQWjRTX8adjPVVVU1MF5BtGjlCsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 04:00:37PM +0100, Jan Kara wrote:
> On Mon 16-02-26 14:32:00, Christian Brauner wrote:
> > Adapt kernfs to use the rhashtable-based xattr path and switch from an
> > embedded struct to pointer-based lazy allocation.
> > 
> > Change kernfs_iattrs.xattrs from embedded 'struct simple_xattrs' to a
> > pointer 'struct simple_xattrs *', initialized to NULL (zeroed by
> > kmem_cache_zalloc). Since kernfs_iattrs is already lazily allocated
> > itself, this adds a second level of lazy allocation specifically for
> > the xattr store.
> > 
> > The xattr store is allocated on first setxattr. Read paths
> > check for NULL and return -ENODATA or empty list.
> > 
> > Replaced xattr entries are freed via simple_xattr_free_rcu() to allow
> > concurrent RCU readers to finish.
> > 
> > The cleanup paths in kernfs_free_rcu() and __kernfs_new_node() error
> > handling conditionally free the xattr store only when allocated.
> > 
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> ...
> 
> > @@ -584,6 +582,12 @@ void kernfs_put(struct kernfs_node *kn)
> >  	if (kernfs_type(kn) == KERNFS_LINK)
> >  		kernfs_put(kn->symlink.target_kn);
> >  
> > +	if (kn->iattr && kn->iattr->xattrs) {
> > +		simple_xattrs_free(kn->iattr->xattrs, NULL);
> > +		kfree(kn->iattr->xattrs);
> > +		kn->iattr->xattrs = NULL;
> > +	}
> > +
> >  	spin_lock(&root->kernfs_idr_lock);
> >  	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
> >  	spin_unlock(&root->kernfs_idr_lock);
> 
> This is a slight change in the lifetime rules because previously kernfs
> xattrs could be safely accessed only under RCU but after this change you
> have to hold inode reference *and* RCU to safely access them. I don't think
> anybody would be accessing xattrs without holding inode reference so this
> should be safe but it would be good to mention this in the changelog.

Done.

