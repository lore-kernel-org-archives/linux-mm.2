Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39BEBF53D7E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798216B0343; Mon, 16 Mar 2026 14:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B526B0344; Mon, 16 Mar 2026 14:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651A76B0345; Mon, 16 Mar 2026 14:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5AD6B0343
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:30:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 04EC958B67
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:30:36 +0000 (UTC)
X-FDA: 84552766914.05.7566581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1427CC0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:30:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+nsGW9W;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PihGP08Cg+fzraKEVoQR8MYNTTxFBaUh27QQUfppitE=;
	b=IKW7entvrWR98Ti/ki2nYfr4HsF9zT3oq80vpD+lkocgMHLmx6KpVzxHrMsBQHM5NR+Abp
	MF8UZYEFIB9I+YxSm+iJreJDkZ+cjyYrfoZ5huCYVVfNZBFZf92lYVwJtzky6eh6NieGHV
	cM63YLhAl/fCUpHRq9fO7WMfge1BsGE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+nsGW9W;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773685835; a=rsa-sha256;
	cv=none;
	b=yF7pZU9lK7TSiwCkF5N5pcjbtxGXZbqI5SBDGb3NdiYlXgvvK/lCsSEJ7/cxhXAc6UzuM6
	8Aye7Es7T/paaWSaofUYCDxNLFDN/5L+SCXvEJFPH3xCKEkayWBkSglCMjW4QqGGkfaoN8
	8l7L6vHQQfrheH8LMie59qJr1AHucug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 200FE44301
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029C1C2BCB3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773685834;
	bh=PihGP08Cg+fzraKEVoQR8MYNTTxFBaUh27QQUfppitE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V+nsGW9WLYGktQOjPnS9ds122Ypwwwu5WCwy4dbgcLA36DALzYvrfSrl9TneCRCJS
	 67MeIb4I2anNr4PEeRC+hMK13arJUUnVFfPlMcVyPIogb8aHTZXu84zyAXYYimyt9U
	 sO4jPctmPTlhLnhWOyhIK4e9o5xoWBUhmA+ZPVBYw9pFwgljrnZhGhpIm4Ss/HtSq3
	 ph6qBAN1AOmSRhCQKxZfOCBC1y87QMUytn5qjcZLCfefKvb0N0QvWYM+80i1F11p4/
	 GHK3PR52tSlsEgK9jUkBkaJORIgthxM2tHrmDVRSzXXUyFDs/n0nhAPaW7jTWh74wu
	 XRY2dqUHyr33A==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-661d929219bso5795764a12.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:30:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVN+88pofLYDbVtA06tAeSiidGwXMMRV3ciR+EsN9VvRckAKUhoPRLx3OWGHZ0f4T4PYnZRj3Ijuw==@kvack.org
X-Gm-Message-State: AOJu0YxPOtpifQ5du8OR77EfOAs+jZbUlvXJjsTSl+wgyZbBqIKEhxIO
	DeH4fOzGnVV8/4GiWawz/W7bJKpQLdto6wZNMdoa/qgU2pLxt5D7sYwe3ZPetCxJPw4d/GOz8Z1
	yemKvnVdotXNavvEseLnsueRAthKGUcU=
X-Received: by 2002:a17:907:d1e:b0:b94:2d07:6c3f with SMTP id
 a640c23a62f3a-b976504c3cfmr910155366b.24.1773685832723; Mon, 16 Mar 2026
 11:30:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
In-Reply-To: <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 16 Mar 2026 11:30:21 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
X-Gm-Features: AaiRm52WGZPMHHMNcBIRf9nEoSSQE6Iw2dNQT3D3nFGiklVsCKziezsF0WkdiUM
Message-ID: <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 1427CC0002
X-Stat-Signature: b8q81u1g9cqf4ssr33s6b1dtf4dy47xd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773685834-79592
X-HE-Meta: U2FsdGVkX19i5k6F7ba701nk0J2TyK5zzMamETHLlt0//s5uB3n4dCRMRElgA/pqnYFU4vNqSIpyR2JNlvN2q5enAatSLciZk2hBsl5VqCA4ZSIbc2HYQUliankxSTb25PDBZs+gtFzyVmmvLNhFd5JZyNxxoTJeGpHLzQFmEHWjhC/qlESmqZyfi5HkdWePwAOMju/t56J1ZAdOYKGZJt1sbbkqnE+AjEUZDlEszoKCREw4gob9GV923Lgb2ZEFQtOprLC+rFfoTdN3K6ymk50qIUF38AqWPF3rRYkJJ4ltTf1yesJoDL+2JEXa0+0jiZGRCtlQyy/hySrmGaF2ve4K+xhJ00BqwIj2tsG4YWyig+YozLLpcoyKC4G/0B9YZ24NZx9qWn6/ZEOd4N73oIdELpd3pWngIXQqdUhy4P8TetmlwzWXR1N+KoUuSa65zVFNP6JejRJKsRuBz4pYyXuVexa38PuVL2dVROHUomRmRTnLX/eu/OQ7daH5t+jkUeKzXXKrhJ+vL5nyOBo3QT++FORmpaC+a6d8WlToUzpUYprlVtQgVObywedxB7A00qR5K6JMT7b5+wPXTJpuINPVP7MXGyzagnYTmSiK1bVqeoI4A+A3lhcPnc04bzcYC+ieSxb2oZI7teXwzMywbb2boB1gfBvYPmuFp3tuqVD34e+4cG1rNS3m8bXOZr6vluoPaBZzjI8FWKDPTsQEeV3jzBzsQdle5yphvHRzsGHKdv4VbOP71Z3bpahE53oSi+J497FfVA5FhmYLx5I9Kp9khTDY3CHdJLW67jzvaEub3tQ5vHEKdGY/26kB6C15JyT2UON/PPs2EkJqrTEzbndsKCm3ivBZOW5/VNSma+OieXR0OzqvMRFJGJAfMSoIda2PAvUIyG7UIiyT9muvkvInrA8c3J9riYWf1VSTASeYtp6XemcXBoxVZqDFYPWebODVCTDZF/oOZK5SIBu
 UP+rYQPC
 YCiizP6p/FnliKcjetc3N0eLhkvLrkGViE/UIP1+Jac+juQY+w9uT1cZ35Q/DFKVIK+xYIZDYzgCt45PyOF4+gk2CgIwT905pnneX1wk1WycQtjM6zk7yypTqu2WtHBRoKP/utImsQel4mKKCvShhv+DYszuhTjgUyw0hu+b8olwBh7rvx5LpfTIUdcnZcq9gYy/cg5HpAZnHyKuyKFbTuTX3UtY81bXjBVvFRGpjkULJd3fcnb09uMYHi83XKatdzmoilbUzF+uqwKwSQ0mkKydR4bPR+J2Ca4IFs93RSculxXX0aU12HdhglKtIxRY/OsCrqxb9AxD4okU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > If the maintainers think future-proofing is beneficial, I would need
> > > to handle the PTR_ERR(NULL) which would send a false success status.
> > > If we don't think we need to handle a future NULL return from
> > > crypto_alloc_acomp_node(), then I don't think this change is needed.
> > > We could leave it as IS_ERR(acomp_ctx->acomp). I would like to get the
> > > maintainers' inputs on how to proceed.
> > >
> > > > > acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> > > > > - if (!acomp_ctx->req) {
> > > > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > > > Is this change necessary for acomp_request_alloc()?
> > > > This function strictly returns NULL on allocation failure, not an error
> > > > pointer. Changing this to IS_ERR_OR_NULL() obscures the actual API contract
> > > > without providing a functional benefit.
> > >
> > > As of now, acomp_request_alloc() returns a valid "req" or NULL in case
> > > of an error. Same question as above. The only benefit would be making
> > > the code more robust to handle changes in the acomp API in future.
> >
> > For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_dealloc()
> > to begin with? If acomp_request_alloc() only returns NULL, maybe that
> > should also be a NULL check?
>
> This one is debatable, since acomp_ctx_dealloc() is intended to
> replace zswap_cpu_comp_dead(), which has the IS_ERR_OR_NULL(). I think
> replacing this with IS_NULL(req) makes sense, but would like to
> confirm with you if changing existing behavior is Ok.

I think it's fine as long as acomp_request_alloc() never returns an
error. Maybe do it in a separate patch first, change IS_ERR_OR_NULL()
to a NULL check in zswap_cpu_comp_dead(), with the reasoning explained
in the changelog, to avoid hiding that change within the bigger patch.

Actually looking at zswap_cpu_comp_dead(), is the IS_ERR_OR_NULL()
check on acomp_ctx also misleading? Should that also just be a NULL
check?

