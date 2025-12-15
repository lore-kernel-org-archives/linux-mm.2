Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64535D5B854
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 16:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A31D6B0005; Mon, 15 Dec 2025 11:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353F86B0006; Mon, 15 Dec 2025 11:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E226B0007; Mon, 15 Dec 2025 11:53:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0CDE46B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:53:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3FEDC02D5
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:53:57 +0000 (UTC)
X-FDA: 84222302514.12.A47DE97
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A3BD1A001A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:53:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=kRr4X6wk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765817636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjBYN1Tci3ZVIWi/TSuAzsf7+GxGQ6HoqfFTZ1yJ4AE=;
	b=qxCvKjB08UmfpE1/fhGlgAngJ0z2Z7VCoEFrJ6h5IUPa2hNkf1NXgz313PwrG3Jmc2TCqD
	DCh3szclav7RHqQH3bQ5KhMAx4ZvfL6BGNLwebRvYHDuXuZ0EfMMo6DUQVB4GCv1pSRClF
	SsHPyn9yrE4dFn1L5L56MuigbjAYT0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765817636; a=rsa-sha256;
	cv=none;
	b=Ov7YVh4Y2yp/2fzwjiWC6Mg1+oKlSb0TaUQQDXt/Rpx5bAdiadjmPkJDVOio/4fKbtE0Lu
	d74aTUXGMDMpgERC4b4PJr/ScIVCvS80S7tpY2ki6E1lLwqMKMsYz42aKvgqYCso/iG5lI
	4JYstwqmtRla5SFjJ5JZ+zuKhjHw0Do=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=kRr4X6wk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qjBYN1Tci3ZVIWi/TSuAzsf7+GxGQ6HoqfFTZ1yJ4AE=; b=kRr4X6wkVTpgA3bNsnEpKsbvR2
	BGAB8jd9/WOcUlmuq8vLROADAmmqM2hbvaqmdLjwzmcuK61sY/KBBJAHuBf0Dcu8MYkTbUf4XvtXD
	eNXEYP3OK7sx5eeZK4diekmW3VVwkDiSZjbvbnKr9rhlMB5QaeMDMqbL0fJIlsATy1pw/mVUKJ9iS
	8HkSx+imaei/CJArvpu5k7kzmIDOaKEAFIXIyx83Hq11zndXafj1HP2T7EgAAJ68/lmtbV6pL3DXj
	nq03gA63vKlMpyO0PD5r9FZ7fUUtD43LN11HvTCvsH5Q3xkoHYDzuJCDTWXpPy+eTp5FCoQDw8HcQ
	JiRpcDLA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vVBq1-00000007bu6-2Dvr;
	Mon, 15 Dec 2025 16:54:21 +0000
Date: Mon, 15 Dec 2025 16:54:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] shmem: fix recovery on rename failures
Message-ID: <20251215165421.GN1712166@ZenIV>
References: <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV>
 <20251214033049.GB460900@ZenIV>
 <02e4f1d6-f16e-4c0f-89d3-c75eea93b96f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e4f1d6-f16e-4c0f-89d3-c75eea93b96f@oracle.com>
X-Stat-Signature: zibfpf7edxsy73npuqytpd7dmmsp5zoh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A3BD1A001A
X-Rspam-User: 
X-HE-Tag: 1765817635-370076
X-HE-Meta: U2FsdGVkX1/ylPnaz7HBwOmb6RcqdCSjq8ZMxJQdG4vFtmLYRjp9C4ovnJ+cyRPEdHD4xftMzCZiFMQsRKGivVP55kkbt1Bu+IfiHVhSRtZmWu3ipKm9HaIT7mhjWK3M10hhXvau3yGeGqr+0addiuTLIAycQGL2VVpremDSLNrSChTFavBW/0zSQlz+4GUfOEU9Yr8QuWKtscc7LzuQTq+MKUBQqYRh4AQD0h8JxoooC3kORfJKxCXWO9s/OHFiVht0+gFpc/JjzLyfJdFaNhxMAN21qmh6772PJ7XDouYoUBo+RpNf8cPOlkMwmGzWVGVSUFlhdT+5A8Vz3FRFgL1P0+5UoJFmPAknIwQKtJ7tMm2ke+xuVvdW9wRisrQRm9lzmFMNy2lP6YPkrzflXeebmQe6cH6wV3KcCWflzldp7hs7/wp0xl2qz72+d9IPSzKCImowRhBpYcNxIAZoZIrgvZTgTKd2PWwyQj5UNAOZxZ8piUNTw3Dt+XEqp/zawEE/9klp9CXkMmiC3fLhlY3RrYJQo8rP+sNyV8AKll07mwoIerEu7hq2eYxzSwQ1ii0tbbFmQ9rY1vx5YvdJ1N+fby00xbT9M7jduQDgbsLcBBW9eTDPWpbEqh9p70k6xqNYTam89tHonmmZCex26YLOcGASiRVqHyn5L05cVLTUrjTWbELm7WMxoWgPbcYMY2TwGKE2PVvBrCBkek2GW0ZHbfT6Cx186yib8584QY07LEvL1BHmviVV6TFZXmzFTZ5w5eJR5FQWeA8O1qMZZR5nSGT5ow7Zri+1rbGSh8EUyrTrB/ALhd3OM6CnEuRtuhO2JJuq8TIzCG8K1D0rURlogq2TE5TkFP/Qr03X1X3/At8SUIWySmD/HxYk7+op7PnjlZNlkwbFWyVIsOews4E5WbvHWEFlawPU/eFiVh4AI9cLNvboDPS1LvUzQ2Iur6F9VgfBPo2ZuoOV3IH
 o4yfAojE
 +oAemNd+7k930rcY60w1buBBJn/DJoS0yQcPIY52P1CEj5kvhl2lUT/X+kLMuU0RDAgjGo7VaVXhle1vryYzjrM1yyKjIm1SE7vnqGCc5T/ISUOm0GTHXv06XuQWPQ69rtOcRs9pa9D4fEen0RFG6YxMzPJ8B2g3nsMuS2/EiVeMnFcEVZhblY+1nlyyjnA9zVwOpvBV3FerYYbvcRdhJLhjmzO34n7tX9yTqZgXy5cvLP1wsxasAU+Yr976uQQZRhYRkBWV34geoH5ykKKGUUarbFFhJyVT4/ZPB0158V8784wMS/K1le9AaiQu3T/043SeNWjeuy6r7MSpaDUEYhdByY0G9XJ0wsBSj9Cf/rdWZmp4+IB3oi6fpYMr1m9vCgnL5sa1HFG5/LkB6Lgw+oZFugBSd0D1U8fCJHAT/HqE5hsvOTz6USgXep3QE77k4bTeO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 11:03:58AM -0500, Chuck Lever wrote:
> > @@ -388,31 +388,23 @@ int simple_offset_rename_exchange(struct inode *old_dir,
> >  	long new_index = dentry2offset(new_dentry);
> >  	int ret;
> >  
> > -	simple_offset_remove(old_ctx, old_dentry);
> > -	simple_offset_remove(new_ctx, new_dentry);
> > +	if (WARN_ON(!old_index || !new_index))
> > +		return -EINVAL;
> >  
> > -	ret = simple_offset_replace(new_ctx, old_dentry, new_index);
> > -	if (ret)
> > -		goto out_restore;
> > +	ret = mtree_store(&new_ctx->mt, new_index, old_dentry, GFP_KERNEL);
> > +	if (WARN_ON(ret))
> > +		return ret;
> >  
> > -	ret = simple_offset_replace(old_ctx, new_dentry, old_index);
> > -	if (ret) {
> > -		simple_offset_remove(new_ctx, old_dentry);
> > -		goto out_restore;
> > +	ret = mtree_store(&old_ctx->mt, old_index, new_dentry, GFP_KERNEL);
> > +	if (WARN_ON(ret)) {
> > +		mtree_store(&new_ctx->mt, new_index, new_dentry, GFP_KERNEL);
> 
> Under extreme memory pressure, this mtree_store() might also fail?

Neither should, really; adding after entry removal, as the mainline
does, might need allocations.  But mtree_store() when entry exists
and isn't a part of a range should not allocate anything.

What happens is that mas_wr_store_type() will return wr_exact_fit to
mas_wr_preallocate(), which will shove it into ->store_type before
calling mas_prealloc_calc(), getting ->node_request set to 0 by the
latter, seeing that and buggering off without allocating anything.

So these WARN_ON() are of the "if it triggers, something's really wrong -
either lib/maple_tree.c had an odd change of behaviour, or we have
our tree in unexpected state" variety, not "warn that operation's
failing due to OOM" one.

