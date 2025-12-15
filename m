Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B85DD41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 11:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 855916B0006; Mon, 15 Dec 2025 06:58:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8A96B0007; Mon, 15 Dec 2025 06:58:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680E06B0008; Mon, 15 Dec 2025 06:58:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 577056B0006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 06:58:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F17BF1DF6F9
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:58:24 +0000 (UTC)
X-FDA: 84221557728.28.ED35131
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6B6F6A000C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 11:58:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcjMJ031;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765799903; a=rsa-sha256;
	cv=none;
	b=jlRLBsN36Fgd12eoVOvOWg3Yqz/S+ZOMRieFaAAUjPbp+RWc2veSBkcAMQUpkGKviQkApy
	nKtQrz/M9BUzrtJSxGs5cbG4RMJ/VrC0nUXMK4qoEIjTbeLYlx5V6wuaNuPsGvf9enDtxh
	K3Jkt9mJF8BmsZHtBfpeRNjKP0vHOHw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KcjMJ031;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765799903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8HbwyI9XPtNxFT+T9j0IMNr/nH32rW37TKcIEPu9mcU=;
	b=WhugrYNVh1nC/zdznAHYGKoXWFImsXBLky8RriWW8xw6AYeydpIuJIP9qPGgPAtQlLL8pY
	mOq1bZe135yPJOiOPaktsgfUX40uipI0e+9pAQHwxhKFXAw3sSBljeBUMGUR1MFCnHvz2D
	tR6JephOqwfa6uatgXum9XqYYRy4bUI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4A5E60155;
	Mon, 15 Dec 2025 11:58:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C288C4CEF5;
	Mon, 15 Dec 2025 11:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765799902;
	bh=p3ib7IxATEEQKs6tLDHHrhEZu0aHnPihiAgww66H4cQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KcjMJ031jvj8WbTNzax5HHRcg5ddvgbwkfIjEdJiKCj5AO9fB/6pDavbpha3Eh9Re
	 69g2/ys0cw/30gkkLda5wgsOEG0YlOvhlHVi8pbg2F6TQyey50Qj86YAgbPZjEeL0y
	 FiXvIzdA2XRU97NAahkk5YQVyUKU64nPnkKPPQu/2W/XpbtyIfvZ+ULo0SM8G6gtns
	 QQcOf+Amu5/D4vFoimmq/PWFQWsUM7fDRmb5KZvC0T7jgDgmdm8LUBaR/HDLFHnha/
	 tNgqhvaMkdBSy9Z8hw8yRCxIAufG77TMkjr9cGgiL13g4iNVvUqqo4jcxCNaJPdchj
	 vFor6C4D0hRJA==
Date: Mon, 15 Dec 2025 12:58:17 +0100
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Chuck Lever <chuck.lever@oracle.com>
Subject: Re: [RFC][PATCH 2/2] shmem: fix recovery on rename failures
Message-ID: <20251215-mythologisch-losung-f99a7be1c735@brauner>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV>
 <20251214033049.GB460900@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251214033049.GB460900@ZenIV>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B6F6A000C
X-Stat-Signature: m6mm1rt9goizeii44h77rd5tek7qt8ti
X-Rspam-User: 
X-HE-Tag: 1765799903-185209
X-HE-Meta: U2FsdGVkX1/kyxVDfDx01snGK+A0++dMC7y7PgMjifQppuXxPnWfzI6UvDB+snabAW4fl6lE28ilOvu56GKvM7krtGPFlcipAF9qMPlKcPRmOCHQSw247nnZA1uWPuSJxVL1F+ju3z4JOM4FKeqPrQSdwiVrxre/WRumPNg5gQO73T+piu+dmttRE8ukZHPzuQaByqz7GWbig4GeMXGxTqcu4IkWat+763kOXB8wHsrl/+SO1+um0k3Qc+S2+AX09LHzW+gcJbB+psrKFfeQHZWfpqd2OGMkD5HwxieBWB+DnkNaMObpCu3zJ7ywztiVibmn6O3VhbKAT7XRBsauRUqC+Z/0TWHkuuhHXwYc0QqtWgkfnQNEoziyK/NEfX4c2facNB6tHdpFd0l/Jp8rJGqthkEfh69ie3qK7yzzbhg45FMZI6I2xkzx8dWtfo9ZDhUt7glB7rf0WuXdUQDvIu86J12GK8904eyXMCZsxonjxGqMZUL1+244AI0HK0TKfswy5PrDFLYh6YUhDAX/u+YgpzDFWuo3XKCew1HB1B80P7XUH7MaW+ibfEANbMzvVHWOxdz9F6JF2fXBiq2BEDT/+hhGzbTSo9g3ON98D6FUNDCqHMXMcBbQtcOUog5X+GFTHbQw051fJpNhB/G/QanT8zTOeuaGHDLyFLubaKwj8MSeTLzhqBKcbSlzpiy4gEKpPRkyVvzCRGPfsLZNUUP0HtVO4xeZoDxUKftcca1YeXf6YVTNJy5nv3t40mpBoe1a8w4QP7OjJRGX01xluatcxPOVVLFdNBow3uTU4n6Y6DSq8VdHQV2C2WOk6nW5b/XzhswwmriQnLSWAQJQq60QwIXIddq23HxgBe5OerTTDe4YRqi869XK28H8yocLVCHozJfu2KOZWAQGWE8bXjwmn7VmpKfFRFVjLbCOHWxVGLssO3Tyex3ALMiXsR+KLmdOV4/cuHZcXPChyKm
 7upst39F
 L9xWTcDGCpFg09ylynkn4qwkLRvWgFbw/XFYzv0LITEW90/MToA0zQJ78LmZ4Zf7MmuY8rhlxfRfZUo7Jpgj6prZfoUJyRrYtoYyl91yXNLMrrHT8J4JwBKLSo0JNxbYuX/modGNKjVYxhNPKYqIxejg24R9waHyQM5ysMggv8pQ1cZ2HnwooeIhLxd7ZStA3RxI4CeR9TijMO3Q+Sv3qrdhLNDOE6GF+35p0ffqRc1kFJP7ot6iIUdncT2c2dDI++MZEsi3edDxUna8XASKp7+YybGv/i5uyTOghyZd6MeHiqQcaxcn4pqv4FVcAAkX3wM0TAUK2fh3dmfwg2QlCo982t3lNpgDXlGafME2jTfs1gPU4Iascr0FBMedR46t28BQi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 03:30:49AM +0000, Al Viro wrote:
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
> ---

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

