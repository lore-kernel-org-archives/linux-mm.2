Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B2DDCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24906B0005; Wed, 10 Jun 2026 03:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC5A6B0088; Wed, 10 Jun 2026 03:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A127D6B008A; Wed, 10 Jun 2026 03:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 919616B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:49:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F7F1C32D3
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:49:06 +0000 (UTC)
X-FDA: 84863227092.21.1419085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D23238000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:49:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mg0NQs5J;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781077744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YPMsWdDpGC9/as3qFdfQkWrGikBrIlt5dD0ZVJjgJm4=;
	b=bP7bB7Y4CQjTjGo1N4en8JejP+drHfiMGXDOmUHF4ByDMzv9Ye7Hje+a/runX7Y+4xG5pm
	CT6YQ1syLhurBHJWMT/cDIvDhH0spv1fRCMLyqNw6MeSbop0+QKV/jgC4cji0kVGSd/yyN
	XiDYG3hVTpyuU/Ndm7LAN4bT0J/mPXA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781077744;
	b=dLk4IgTg2v1EvjMdiEg5c9DpwNWaHtKOGEKbgAraUWTm6HVjTPgIEupbxAfufEWzZKcru2
	IcKMForUdQ+6i1XLOflkJCRMAx0LRNy8f1MVUfxelA9eTgRmF3Yox5v2RmCSyUHickQroB
	SwLhbwfR1I31uH/bo0wucF2imn6WjFA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mg0NQs5J;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4248260052;
	Wed, 10 Jun 2026 07:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97601F00893;
	Wed, 10 Jun 2026 07:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781077744;
	bh=YPMsWdDpGC9/as3qFdfQkWrGikBrIlt5dD0ZVJjgJm4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mg0NQs5JeKC5R4JfPuJKebZGfBCTVrDsVLytLl/xnLtWv5QTjmFJLcULWSwvr0W7B
	 c14IXsj1rV0gc2N8LYcQtXrvdh6RZFu/dM+mHVCu00HBwRL0uKe+d0Xm/bcymnBmQd
	 aaLEAlpY5HX+Ov+vjoGGWwXiDs6A50G+BqDVoQei9s6TH1UUXfn8P5LQqFwIhEOmX0
	 H128zncSkyvQ2MV9TAMuzK8vouJ0y7ilpNG5dJ4KU7suGDyrYAxhXnvAenw1QIGKuX
	 Yffxk/5a6lhJuoJO/WL2rxzPUHR2rrC72mCQkNsSqtfQbZl8Z10Dx0oXyu5j/5XMOD
	 G4SMvampvsmHA==
Date: Wed, 10 Jun 2026 09:48:59 +0200
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] simple xattr improvements
Message-ID: <20260610-mahlen-kolossal-burganlage-477125e4bcf2@brauner>
References: <20260601162454.2116375-1-mszeredi@redhat.com>
 <20260603-fehlschlag-teamleistung-korpulent-5e0b7fa7f12c@brauner>
 <CAJfpegvuY_EcQz8fgyWk22=agPq1sboiribP780DjR4i+eqUUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegvuY_EcQz8fgyWk22=agPq1sboiribP780DjR4i+eqUUg@mail.gmail.com>
X-Rspamd-Queue-Id: D23238000A
X-Rspam-User: 
X-Stat-Signature: c8dq9kg4fo4hdgkc5jwopmouh3hrx39y
X-Rspamd-Server: rspam08
X-HE-Tag: 1781077744-699578
X-HE-Meta: U2FsdGVkX1/H8gciKz0KiL/jsDlDvqGtGhuoIGwQCJwGuVRTe4XK3FgSc9wIzPExZ6/lliHVH8wIXUMtI6Xy0U8a/UZlxE3q7JKmUvXWIWMFVb7uQNlYj36tNN0ouFz/vA9d5DpQjaur+4t2304rua9DWts7HkYgForXSXkDvlx8AZbp4sR70JUiBZDo1zsyP5Y7/VP20oJbwWZNbnn2hh0FuFSCXNfweckXrbOn42VQacMKOHONeQjWNaaBgFSx7w6ACm7NABHntjPxAvNx4aa44yj1FzPZ0zrnIgfXp+9qdzKUagTno1jNEMSE8MEL+lgpK9V6sXPFfewbGvUAqbXw7hH16ySg29I6a3WVzWzZpRGbqHrjuL3GhaWnrd1lLEBGF3lXd0V33H2ccyOynDJ7LBxicJkSH2rMTNO8Ku317clF9LBOKGna8w0pBnaOYZVWA4xz2AuvLyck2KIKfeuzn0j5eBlrhq7+1BF4yRgN49EdhPXQABYUvwB9Zy+9kVYXdsiX2mvnQrDKyMc190bQGEivZZpDdWWT1E2aZBxeliuMU9bdywaFR+wkTUzxJcOo+uIkx0AT6BIc6p13NtgTKFOmS60L3p18oiRudl5Z8sDSOooEBrbdAu7ANoGvmjup8oekVDSrZmPqwwrpws9+jAPeY/AiTOGPi77rO2V07mJmCwIChOj+BUZa5hp5pCzw12pRCLp87uy7P/DwaCBJI1AexEscqWf8wTXGOzLfBH1MIkrp6F+wB5464yw01eQrtDfEs8VFMwCNivzqC0UXL94YMOatEPaZ9NUfLtdtl3B0AYs4znBcI/tPkti4SCeUiFyJE6TN7vcmfSdOhHJM625teRCvM6lXPj0KmdAVRwGpH6kgBlFKKJ/YBRf0DixlzMuNaE0lEixfXeL2+CYk4b6DOloOQdCGnr2U3XcEkJdNiw9q+WPDQgMId9Ljrry7Sp8NoRdN+ofLhkV
 lYzGulDp
 hZWanl6FLGGLMzH6vWSvtbqTszbOE33lyCIwkLs5aJe/4dtihKbt/TS4kAs6hS23E359hNQWAUOBb1w9MvrheJ01qDYXAj/otHibYAZunw6k7xNtfe/TtFykpRSuSyZ9rC8tZB2hXogC1X4zajDorzKH5QfTWjBd57taKcrrfTiTI2K/JZRTLlTdQsiY1yXJuOcBJV5eSbS2KEwrYUGFYC/QUHgZcMTRN7Hit6tTRUyRNd0cmqOnlMfJ3c9qiVpL1ZYRQrsUL3kPtQcxyQYjarJ3Wic9PyTKo9lGpUsl1L9ujmCTjHK7cj4LXMGntghLvn+kx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 02:37:53PM +0200, Miklos Szeredi wrote:
> On Wed, 3 Jun 2026 at 09:31, Christian Brauner <brauner@kernel.org> wrote:
> 
> > I've fixed a bunch of that before already but thanks for sending it
> > again. Fwiw, we now also carry support for bpf xattr in the
> > vfs-7.2.xattr branch. I'm still applying my kernfs fix on top.
> 
> And sashiko keeps finding bugs, so I keep resending the patchset.
> 
> One of them was a pre-existing bug with kernfs, where inode locking
> isn't sufficient due to kernfs nodes being shared across super blocks.

It's fine. I'm used to it...

