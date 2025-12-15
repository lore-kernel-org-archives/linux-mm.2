Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9B5D59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 07:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FEDB6B0008; Mon, 15 Dec 2025 02:38:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF486B000A; Mon, 15 Dec 2025 02:38:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DB36B000C; Mon, 15 Dec 2025 02:38:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05CEA6B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 02:38:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B382D13210
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:43 +0000 (UTC)
X-FDA: 84220903326.27.4BB5571
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id E11F61C000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 07:38:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z3pEIyZS;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765784321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIeKRKKKCnzupDfCwJqFB1013cUpwf+GNDgK+GELOro=;
	b=aZw1u7CAiI8oc8DBpQrgIhhmDag+wSJqHoUJmAq3G30Py+H0Q7CfCeV2v/TYpxJHitL9Hy
	uEOv8i2ZNs+S7W5l4ealyMqjFaOGh7d8QvyCxUvz/ed8hIyjGtP8G1wSjpEgcWqTFn3MO2
	xcCIywI0fTwQ1ZlB66kT/h1TVhtP+RE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Z3pEIyZS;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765784321; a=rsa-sha256;
	cv=none;
	b=kykRc1xy0TNjKaOmPAnc/uuLKRTS+zjKa39lWpM2x+MgaGJWm5TdPvwHGVxa2jAfXjZWxR
	7XSxOZJuTSAhZ7clH85PiBdHUduaL4duGQuf0RUDn234Y0Gb0EvlcCcZ+yzJPrzy/EBOkn
	wu3Lg0ckqYyaSQu1/gmp82ZoxoCV9Fg=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6446c2bbfe3so2807519d50.1
        for <linux-mm@kvack.org>; Sun, 14 Dec 2025 23:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765784321; x=1766389121; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iIeKRKKKCnzupDfCwJqFB1013cUpwf+GNDgK+GELOro=;
        b=Z3pEIyZSLrOfw5TwpI+wdfTviMVlTNGNcqaT+0JTBsiaKJwIeVGzwxHjq8mvd99UWK
         8IsGn102+GJEFUNcAaMGOfkFFjdKTOOW9AGtL4OYLTT7uADK1yZGw622iMZkXfDwEEFC
         Oql95sBzuOlTwffJ0qUGv4aePL9DfduzTR45gHrsMPLjk1yLBVbKag0V9ra2dfhmz9/c
         aSZrLlSt9r9MEmQcwXirrMxXdnrmCstnL4huI3oRnXKWikB9QdBgUyZ7vJTjToSS0cMb
         lhz/K61GlsLQ9B0DG5Lpyr5xemHd0aJ/FJWDLGQXRQVgdZs/p5C7j3XgrG4sF/AR4gJ1
         nTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765784321; x=1766389121;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iIeKRKKKCnzupDfCwJqFB1013cUpwf+GNDgK+GELOro=;
        b=o1BuswixVYw1yw4D0BAxZjLutM263nhLA/qYZ9nEUbKXpImtxH4+YRKt3FSoS13PTE
         lb2TQknrluofXaBE2RE+qzYnO67agP6oxpjbUJjasSpnZnsfGgwu/mFPeJojI5clciYb
         v/rJbOKDi1uQsvILLOU9kPa95ChWo3PJdrslyBP9/h/GJtaKdqCPoKnHA7w9GvqNt9pD
         7TJKaDlBga/QKipVAoOWVfYCD+eUhdbjzq4EJOfxwz8KMbYy0AzGT+LMsJwNHM36jFCr
         M6XjWM+tkmPWoPAFh4ErQEvhUotFCerGlMuVCrc2VKGfAFUyilY/lD0w6XX7Lf+oyIRR
         Z4dA==
X-Forwarded-Encrypted: i=1; AJvYcCXWjOyYrYxh41waOROO4o8plrqcv3JvEbfI8CfQFulOS9Q2+BIuS5dwEN+fzmMPO/SBSZ3GUs+s+Q==@kvack.org
X-Gm-Message-State: AOJu0YyuqkaaDjM03YSlfLFVNME/bd4b2FmGDsqKz73Z+DfQkLrFkkvO
	C48cc6S2b79Djx/8+MruOo3A9aLfdvl+f5uz9ATPH/kZwJ612EzT5H6joM51W3uUYg==
X-Gm-Gg: AY/fxX5J99PzNrZWH1pdnl1+lIeH10En5XEtbYZOZJ+OPEvt2w1VTiq+sDnYhI2TVoN
	+EeJPgu9Dau6d4tRvckKZVSi5JtXUKq2qh9VJ+5QNahZSBBBIQHwB+Q1pO8ouw+3rcIa2S/Zx+m
	RjOTpShHzLeaX56FA5y9akTSJmiI9uhvV2j1lnaO9bcjKpGK/+1tvX2VYcd+kK0W6WwQbtq03an
	Ymtq2E9jKzXsB4Tx5kArvSkY+ZDBU/yvKSL+myiiRvjPtQTK+JVflQ37DtGZ8e4YhX8z2llUFTf
	l9l9jbK/yqW6WE/PaAvb9Duo7k+nItuJSu3sc1aK2qw3xkbwe09KjmPn+ZuaJ03kRZoPTqGumHM
	sq7bQdMxJe0jf7uQRD0++QT14bLt1Xc56nUYMwW/xzOU6MxCq1FkRFMV3gHq1JwWb8M9KWiSF8H
	8OPX/hPcb5Z1dZbr8SAMKS507bVNE8mAFqp0HGdHNIv7g7aTkG9G151wndhivbOMffxDMiDhA=
X-Google-Smtp-Source: AGHT+IGWwU3CR/BLGGM37Mj6ED/FrmrwwoSCDyBwGpC4O4RY5GWa1NaXFkGRwTEcuL+iHjjMa3Jb3A==
X-Received: by 2002:a05:690e:d8d:b0:641:f5bc:68d3 with SMTP id 956f58d0204a3-645556680dbmr6576002d50.80.1765784320678;
        Sun, 14 Dec 2025 23:38:40 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64477dc673asm6105794d50.25.2025.12.14.23.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 23:38:39 -0800 (PST)
Date: Sun, 14 Dec 2025 23:38:28 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Hugh Dickins <hughd@google.com>, Miklos Szeredi <miklos@szeredi.hu>, 
    Christian Brauner <brauner@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [RFC][PATCH 2/2] shmem: fix recovery on rename failures
In-Reply-To: <20251214033049.GB460900@ZenIV>
Message-ID: <8a925e3f-bd27-ac32-841a-a79690d971d7@google.com>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com> <20251212050225.GD1712166@ZenIV> <20251212053452.GE1712166@ZenIV> <8ab63110-38b2-2188-91c5-909addfc9b23@google.com> <20251212063026.GF1712166@ZenIV> <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com> <20251213072241.GH1712166@ZenIV> <20251214032734.GL1712166@ZenIV> <20251214033049.GB460900@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: uozqhja9ga9mqpxtm1f9nfsm8iur1cwh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E11F61C000C
X-HE-Tag: 1765784321-43782
X-HE-Meta: U2FsdGVkX18T74uOM61cyGNkDeyPy9FyE/d80fI3MicBdNRAJfhGu8SKl0rVqdfYkn/dUIYOrmnzPwLzGxsbjwqrHayumSgTBmcfny/jNLLOdsfJjAxYfLkrDzTpyVd9DdE3PWc03HwcLzv0RLHBnF7WexbcSisezv1tYp3oYgKxrDhZPuiZU+0tqED1+AL62MwFcXkX1ufAxDPyuDjVg0qOtrSRtdT25nrfRjDhV//UynJuei3i5oG5ef83tlTCe4jI2LUZlhidoBjw2Nn7cVw1bv4xkq50X0LpGrfL7HrSa/xhQoxJLHvDWWXC8A2Amhn5LAhuI9Zr4B/DizLTKSbD7qnRzmHm9/Xx6NdN+5bFMLiquxwQp1TdwqKQ31dajizV9xZtO51Bk76UDgnu27qw3r8xHOPBR2P35nuoVyLZNh0Dqr0ueOv36gaR4BoTsxtCZIf3Dcnfb39Alq6rgGtrFIJx2ps3s73iUUyPvHCBnNNuV6Ine7pdfgffusf37P3f/r6L5VfNIGqOZSrwO+oggM5P8F0GFxMUU7S2P10Q9uxilhrt26XS91SbqZ4JrkwkPbBLy88VIgDCSV6l28SLAP7Kb8eIy6BJO1IxkscGd/x+UkEWDNrwhvOZtbngBmeDLfX1gY8TrtVwtf0qTOL7vWZBX02p+Cw+zJpTu6gd2mG/K8+tkYzVfIaZGuV+mD+2k65WVVQoVMAZj2qxbhskiMWYB/GtEeC8YR7e+1ZNHRm7YOYub4KSLNg6PuG4ZvvhrCqIXm9FV/7UE6jzeG4QYbaGGqs3YCG3ycA12ilvX2v90E1NfVlhOShEhOvl35eKU2JkVpM9Ca7B7rLbhf+qS4XRtnV150FCpKytaJXBXduvN+8JAXve3+PwkwPkLjPC2w7MvpD4Po6AVyMsqZjIBtE3fSBfpl1oWsE0zylDXBdM/nS4qV3V0yM8JsWJ3UcfJghoa7hxE0RrYRq
 aW9jNaZA
 AkAeeB7qj0zCWf+785SLHPmfXckDQwkxURX47P417hrvhfJNwSsAljAKp3Wt6EUTRtr0ZNulHJh3Wgmb7MHHVUX9/h1QbnOhMaprhxYSLLmJG3GvpHbH3fBS3Zh3qS+hD9hcC8FA+hx9GV7Ab9HkZ2UZOewBHWiccFYgAiXQ079o9a5CgPx9dKMMfcDvj76WdjOiuZd/Wj4XlC8evgGDn56Oaam9vZimgoKJO1kqVh1JlmZWitAc/HYsX0n/H+ba1abQAubGgzpI7n5oBYSDnmvrzMhujj7m9IhqOg8qYwMtvJzOOm6lwBQ9kMTGiSFhQ1X0YriSg+/0/3V4OS7X1Hsvs1I72rVXB8u/Ic0k4fZn6gbZ/KP7qzagcxdyD5GI9/GHibepet2x+iMUprzyPq0B0E8jdWIejFNqd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Dec 2025, Al Viro wrote:

> maple_tree insertions can fail if we are seriously short on memory;
> simple_offset_rename() does not recover well if it runs into that.
> The same goes for simple_offset_rename_exchange().
> 
> Moreover, shmem_whiteout() expects that if it succeeds, the caller will
> progress to d_move(), i.e. that shmem_rename2() won't fail past the
> successful call of shmem_whiteout().
> 
> Not hard to fix, fortunately - mtree_store() can't fail if the index we
> are trying to store into is already present in the tree as a singleton.
> 
> For simple_offset_rename_exchange() that's enough - we just need to be
> careful about the order of operations.
> 
> For simple_offset_rename() solution is to preinsert the target into the
> tree for new_dir; the rest can be done without any potentially failing
> operations.
> 
> That preinsertion has to be done in shmem_rename2() rather than in
> simple_offset_rename() itself - otherwise we'd need to deal with the
> possibility of failure after successful shmem_whiteout().
> 
> Fixes: a2e459555c5f ("shmem: stable directory offsets")
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Well, what you say above, and what you've done below, make sense to me;
and neither I nor xfstests noticed anything wrong (aside from one
trivium - I'd prefer "bool had_offset = false" to "int ...";
maybe placed one line up to look prettier).

But please don't expect proper engagement from me on this one,
it's above my head, and I'll trust you and Chuck on it.

Thanks,
Hugh

> ---
>  fs/libfs.c         | 50 +++++++++++++++++++---------------------------
>  include/linux/fs.h |  2 +-
>  mm/shmem.c         | 18 ++++++++++++-----
>  3 files changed, 35 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 9264523be85c..591eb649ebba 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -346,22 +346,22 @@ void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry)
>   * User space expects the directory offset value of the replaced
>   * (new) directory entry to be unchanged after a rename.
>   *
> - * Returns zero on success, a negative errno value on failure.
> + * Caller must have grabbed a slot for new_dentry in the maple_tree
> + * associated with new_dir, even if dentry is negative.
>   */
> -int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
> -			 struct inode *new_dir, struct dentry *new_dentry)
> +void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
> +			  struct inode *new_dir, struct dentry *new_dentry)
>  {
>  	struct offset_ctx *old_ctx = old_dir->i_op->get_offset_ctx(old_dir);
>  	struct offset_ctx *new_ctx = new_dir->i_op->get_offset_ctx(new_dir);
>  	long new_offset = dentry2offset(new_dentry);
>  
> -	simple_offset_remove(old_ctx, old_dentry);
> +	if (WARN_ON(!new_offset))
> +		return;
>  
> -	if (new_offset) {
> -		offset_set(new_dentry, 0);
> -		return simple_offset_replace(new_ctx, old_dentry, new_offset);
> -	}
> -	return simple_offset_add(new_ctx, old_dentry);
> +	simple_offset_remove(old_ctx, old_dentry);
> +	offset_set(new_dentry, 0);
> +	WARN_ON(simple_offset_replace(new_ctx, old_dentry, new_offset));
>  }
>  
>  /**
> @@ -388,31 +388,23 @@ int simple_offset_rename_exchange(struct inode *old_dir,
>  	long new_index = dentry2offset(new_dentry);
>  	int ret;
>  
> -	simple_offset_remove(old_ctx, old_dentry);
> -	simple_offset_remove(new_ctx, new_dentry);
> +	if (WARN_ON(!old_index || !new_index))
> +		return -EINVAL;
>  
> -	ret = simple_offset_replace(new_ctx, old_dentry, new_index);
> -	if (ret)
> -		goto out_restore;
> +	ret = mtree_store(&new_ctx->mt, new_index, old_dentry, GFP_KERNEL);
> +	if (WARN_ON(ret))
> +		return ret;
>  
> -	ret = simple_offset_replace(old_ctx, new_dentry, old_index);
> -	if (ret) {
> -		simple_offset_remove(new_ctx, old_dentry);
> -		goto out_restore;
> +	ret = mtree_store(&old_ctx->mt, old_index, new_dentry, GFP_KERNEL);
> +	if (WARN_ON(ret)) {
> +		mtree_store(&new_ctx->mt, new_index, new_dentry, GFP_KERNEL);
> +		return ret;
>  	}
>  
> -	ret = simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
> -	if (ret) {
> -		simple_offset_remove(new_ctx, old_dentry);
> -		simple_offset_remove(old_ctx, new_dentry);
> -		goto out_restore;
> -	}
> +	offset_set(old_dentry, new_index);
> +	offset_set(new_dentry, old_index);
> +	simple_rename_exchange(old_dir, old_dentry, new_dir, new_dentry);
>  	return 0;
> -
> -out_restore:
> -	(void)simple_offset_replace(old_ctx, old_dentry, old_index);
> -	(void)simple_offset_replace(new_ctx, new_dentry, new_index);
> -	return ret;
>  }
>  
>  /**
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 04ceeca12a0d..f5c9cf28c4dc 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3247,7 +3247,7 @@ struct offset_ctx {
>  void simple_offset_init(struct offset_ctx *octx);
>  int simple_offset_add(struct offset_ctx *octx, struct dentry *dentry);
>  void simple_offset_remove(struct offset_ctx *octx, struct dentry *dentry);
> -int simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
> +void simple_offset_rename(struct inode *old_dir, struct dentry *old_dentry,
>  			 struct inode *new_dir, struct dentry *new_dentry);
>  int simple_offset_rename_exchange(struct inode *old_dir,
>  				  struct dentry *old_dentry,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d3edc809e2e7..4232f8a39a43 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -4039,6 +4039,7 @@ static int shmem_rename2(struct mnt_idmap *idmap,
>  	struct inode *inode = d_inode(old_dentry);
>  	int they_are_dirs = S_ISDIR(inode->i_mode);
>  	int error;
> +	int had_offset = false;
>  
>  	if (flags & ~(RENAME_NOREPLACE | RENAME_EXCHANGE | RENAME_WHITEOUT))
>  		return -EINVAL;
> @@ -4050,16 +4051,23 @@ static int shmem_rename2(struct mnt_idmap *idmap,
>  	if (!simple_empty(new_dentry))
>  		return -ENOTEMPTY;
>  
> +	error = simple_offset_add(shmem_get_offset_ctx(new_dir), new_dentry);
> +	if (error == -EBUSY)
> +		had_offset = true;
> +	else if (unlikely(error))
> +		return error;
> +
>  	if (flags & RENAME_WHITEOUT) {
>  		error = shmem_whiteout(idmap, old_dir, old_dentry);
> -		if (error)
> +		if (error) {
> +			if (!had_offset)
> +				simple_offset_remove(shmem_get_offset_ctx(new_dir),
> +						     new_dentry);
>  			return error;
> +		}
>  	}
>  
> -	error = simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
> -	if (error)
> -		return error;
> -
> +	simple_offset_rename(old_dir, old_dentry, new_dir, new_dentry);
>  	if (d_really_is_positive(new_dentry)) {
>  		(void) shmem_unlink(new_dir, new_dentry);
>  		if (they_are_dirs) {
> -- 
> 2.47.3

