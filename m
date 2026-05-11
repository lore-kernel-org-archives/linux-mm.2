Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA26CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 10:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 385746B00B9; Mon, 11 May 2026 06:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336806B00BA; Mon, 11 May 2026 06:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 273286B00BB; Mon, 11 May 2026 06:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13E7B6B00B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 06:48:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B090A1A069D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:48:13 +0000 (UTC)
X-FDA: 84754814466.27.97906B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C515160006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:48:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=scI0iS31;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778496492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOFhEqinhXlHZ/I7A4xlXTt6SBG7OzSsLT/UUMgkCe0=;
	b=Qc3tzxubEHxemDTq1wz6tspWRYScr4bQpmlzuXxXGj35GXVVJMkCmeohVAQQTIEUJO7OC2
	HEg1Z7Rj43xXxkcp3tQfLhy5+PvvFsy31rPAqFhVGxgI+RNLzPLyXVm5/UGfRSJaMN/lT0
	inT7h01GRm0KfuUAq+Uj3/ckA+uUpxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778496492; a=rsa-sha256;
	cv=none;
	b=P2Dd1QnjQRLQ8IBnRM8ZmbOyXXgX6uuASCO+Rhvdfrr15Le5kdti1raD4Y86OkBCZ+y1YU
	qjcSnpDS/CuM3X7QtlO+VMbbJ2aILBqxK00JchQtmVJPZgAIIA4KSbHgbnrqZS/YKoAWMS
	bVcyfHstJGMLOMS/4L6r56YBuExQea8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=scI0iS31;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86371600CB;
	Mon, 11 May 2026 10:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD9AC2BCB0;
	Mon, 11 May 2026 10:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778496491;
	bh=/qkVo7GYeYmwoOBDSYzWQvb+QW8ccM5/OKJJemlcIGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=scI0iS31p3r/2zgmu76sbJ2EW57b76Bwi6195T8GsKljBBOukLTZDp9ZQdyhBkGCc
	 nIGSGLldvglCrMJe28eD7d3PnxziysU11HQE18UiSKP4SUys3FZOtNDPrujfHzaK9k
	 BOkVNig+v+YnL/zGYheFNs/vMmqgX/C8uWI5xh0s3qwERargkFEU/BNLlMz6IF8Ml5
	 yu+xl1rL4Iom0LgXbgYwHgkJegIxFADYBZ0yQXma7qUC6I0fj4jDJMJhZmE4LjdxLw
	 r91WLG3CSLavRllAQNe27gMq8NbhTDyD7cbrMZo7BuPbD18dafhJCaqNru/agGxb7O
	 GIOnAPCtWAM7w==
Date: Mon, 11 May 2026 13:48:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Peter Xu <peterx@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] userfaultfd: ensure mremap_userfaultfd_fail()
 releases mmap_changing
Message-ID: <agGz5J6EKskMk26F@kernel.org>
References: <20260501145433.156211-1-rppt@kernel.org>
 <20260501145433.156211-2-rppt@kernel.org>
 <3a04ae6a-049f-4d3d-b5c9-e60e86be8e5a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a04ae6a-049f-4d3d-b5c9-e60e86be8e5a@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C515160006
X-Stat-Signature: wn1dtpqhmyeh4ppy9ismfmqicgiwon8q
X-Rspam-User: 
X-HE-Tag: 1778496492-867560
X-HE-Meta: U2FsdGVkX183RPnp3NhxEhFRvNV2qfsNdt9mBb1s2shFOQr6nsTGWnFONH/tIFoz/5ihc8BVMZKnV7ifwLbUD+ivBAnKpkiuPkgoLw2NFpeAYHX05rqZiyJZ6DMHXVyTdYg87oUxZUx4esExV1dpgRAYHEEF0FyXY6HwYR1U8R7x0CwmFu9QQOEOU3300hRaRAQ3HD+QjHrI4PUq9YPcfItXRJRANVIjcl4/gmSeMDequ0aSZAu46Qce9s+iIAbUrlbOdyXV4KPCDnXxvsWcFTKRtl7ZND0C8/WmomhZxn4VVcLQLDwNft5wlfGXWOsBlF91hs1477nJvH7n4CQE89x/LELuOEG8yVRW0PrCznIUWsAISrb7RphMeacNVoKmdCCcUr7OaJtzYHokfFHcwFAQkgrKJXZK2AG8dxweBidNJFuxw3+Axz2GX5BTUecxU+ddZO02onWm1yRnuoWiPbgtri7Hdv3gVOWlnDeTu8rj4avDbAFtckLgzDVtfOwyjYa+C3mgxE7k2S9tzl5tRfj/x1RyLZ+fQgjeN4TQUMEo6RSSxp0aEQsoWcEWJ91vDv6qrT1kE9UXT/8T1gtoNlpGHQd71ATuhoF46f57cD0WF7cQjXZl9KCeLI8PgN4b+LSDY2/pqpFWdWefrSHFTyD/p+x7d7wTuCnSikuJ8oT6mWBjBKw5zLIpddyv+O6WU/pTtZdBI3cwuqUI4AoYJG82NzssZNFQe36FLooTbU8MoGo5S6XbxfL0wUw/3vaiCCavg3feJ9rYDjl0HtoFFh2kM5RQIIvCn7OLk6i+szVzhAeAiOApzBA17MuZ75hbVdz4xfK4aRg/HHjeXyXLiIAKeHKKo6vsO9pTCjh2Uz2mVSrFV6rIl1t7NvfnziHkQ9nzN9RVrWhQbX7lKWzmPydx3G9oCzYSsIEUgPcG2rYzIFzv2hs4gJLwzB2C8hAyO6ro8vDsCkrzumLT5xo
 aEiFsdAg
 /ZQGfxremEeyt9FLOpYuUoRpbW89SPU9J+awHj26FMOk41mDF6Ic0hC4kO9ekbIzfm5cSyOdg3T3+GCaS1rUfhbUG5uj5MoT50azuk8n/1GOwupL8ki8IgKnnLSX5QlLV1HpL4fOuJvP758xvWYDLStw9pnkW3jOJhTRqkO1aW8Bf/schdvHrGhc04QrPIvlWjCumcNBMw7lgicurWuYseukpKb0uXPRpgjEUsNVqakWqAy+U6sjUBIAhgmQO4e0Dlar+cT54PF247DPf1qOsr23xLn342Ro9bw1wjJYE3KomSWgmag7zChgdWyCW4+7janXBaT8c9g7eJHPPR98CMjhTQeoAqggcu9MtTJ6XvZo11PjGEIAp8N1gvH0Hn2eplcJQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:15:34AM +0200, David Hildenbrand (Arm) wrote:
> On 5/1/26 16:54, Mike Rapoport wrote:
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> > 
> > Sashiko says:
> > 
> >   mremap_userfaultfd_prep() increments ctx->mmap_changing to stall
> >   concurrent operations, but mremap_userfaultfd_fail() does not
> >   decrement it before dropping the context reference.
> > 
> > If an mremap operation fails, ctx->mmap_changing remains elevated. This
> > will causes subsequent userfaultfd operations like a UFFDIO_COPY to fail
> > with -EAGAIN.
> > 
> 
> Sounds like we should CC stable?

Yes.
 
> > Decrement ctx->mmap_changing in mremap_userfaultfd_fail().
> > 
> > Link: https://sashiko.dev/#/patchset/20260430113512.115938-1-rppt@kernel.org
> > Fixes: df2cc96e7701 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  fs/userfaultfd.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > index 4b53dc4a3266..ef963a58f1a1 100644
> > --- a/fs/userfaultfd.c
> > +++ b/fs/userfaultfd.c
> > @@ -786,6 +786,7 @@ void mremap_userfaultfd_fail(struct vm_userfaultfd_ctx *vm_ctx)
> >  	if (!ctx)
> >  		return;
> >  
> > +	atomic_dec(&ctx->mmap_changing);
> 
> I'll note that other users have a
> 
> 	VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
> 
> In there. Likely we should do the same?

Yeah, we could.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

