Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA873F53D90
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC946B0369; Mon, 16 Mar 2026 15:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A696B036A; Mon, 16 Mar 2026 15:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95ED6B036B; Mon, 16 Mar 2026 15:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C84DD6B0369
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:25:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E5D31B805F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:25:00 +0000 (UTC)
X-FDA: 84552903960.28.48CD9DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 59AEA40006
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:24:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLJOfiBO;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773689098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g++N8M2fKR7nvN8TadTf8Fg31CCK0FG79VR6zeYvxt8=;
	b=UGADkdqMtnlmCyxLaJWEJROXxR8JfGkG0wZqVX3wdFVpjg9Ued5dvaz2nEKHbC1puYA8Kb
	n9HKKvy4D6Ru9glKkVYFyABMLQ2LgMsKKcTHwjf1Jv77MCmDSGeESXBckV7QAnlDOKefw/
	lUh6vSmKzvoTvZGKDaWuMI2vuFlHcR0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pLJOfiBO;
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773689098; a=rsa-sha256;
	cv=none;
	b=UG0Ai+pE+FEm1CkFGXT6Q5zBHaKpxkLvXaRwozCsqv35Qb/kKXPPBobQwdTYsW5n1vzijw
	LyjMiQC+PwADrCJzOkRRJMuxmMXHhCu3xb+VMOnjk4JbYwA/Vxqncx9xzRl/AVarr7tFXa
	t/Ru298spvJAbXtVcDcDKQyP7SqnMug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B90541A03
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:24:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C38EC2BC87
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773689097;
	bh=g++N8M2fKR7nvN8TadTf8Fg31CCK0FG79VR6zeYvxt8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pLJOfiBO1Gr8Ez1diupVDBwTMi+bOZvkyhlmWsAGvy0IUpLBH96P8A4I6utGnwDi0
	 NDzgbB5JTtEA6kiFqkStRZnXZDvLJtFiJGBsNjHcqjWrHXXryzmZT9eYacXNcV+/53
	 19/omGP0tyHMQEYYBm4fc6zwGjD6/84bpxmk3IWXoAlKZGeHW87Q/3ki78BlHAscBM
	 FUjzHs11uGohIB0NX3EDZcjQu0pvB9ZqxrZzJ1NF1sXYrQPKOrYtZtrV35ehGF9znK
	 1MQKtllwlOAkC2tbParlS7cerLZB0i7vbCSEBvxkkjfRqlVPHNhikekttIvW6r9jrf
	 Ua1OaXT0HopmA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b9789425fc5so6074266b.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:24:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVb2Zo3kd6u+NIovtDI3Fv8J3KdxTt9b0RCfoX8nOhj2AMCFN2JLla6BDg3Bi6HURY2SrCQ2OK5eA==@kvack.org
X-Gm-Message-State: AOJu0YxN8qxuaQ7Bj8wkAeQcjUi7N3FmH0KTkKJ8SDUk/PLZ1SB2eiZQ
	UR6pkJ+gFFDV/z0YDKllLPa4HzcAkjMKS79VyAuYFyJxlYuShfH+E3+k1wFOARWBTw3kBWN0Nhn
	hDNbAIfLp4tIp9938Gtx0YvzAw3IjEvw=
X-Received: by 2002:a17:907:1caa:b0:b96:f02b:3d5a with SMTP id
 a640c23a62f3a-b97d6d9a016mr54022266b.16.1773689095874; Mon, 16 Mar 2026
 12:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <CACpmpoeo0LhxkoA5Wx6q+9=2scn_az0u=3bar-JgBvTA-ZBkZg@mail.gmail.com>
 <CAO9r8zPR+Sbo9erKEn_qFG4GXBbSd4EJCmtBYRfV8Qvuh5262Q@mail.gmail.com> <CACpmpodvy8wrSNQcSPn_koA=O+MM30U=T4p6Yr6Dkr8R8WsnQw@mail.gmail.com>
In-Reply-To: <CACpmpodvy8wrSNQcSPn_koA=O+MM30U=T4p6Yr6Dkr8R8WsnQw@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 16 Mar 2026 12:24:43 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNGKR4R+Y2gZrevtyan5G-9Dc96aYTUHrgv8b=3V_RKMA@mail.gmail.com>
X-Gm-Features: AaiRm50l0d1o0rxxsTHTWFy_4sMj5HV6Y-8LcE4q-rax4XyDjyE_gcL_FSRA-yc
Message-ID: <CAO9r8zNGKR4R+Y2gZrevtyan5G-9Dc96aYTUHrgv8b=3V_RKMA@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 59AEA40006
X-Stat-Signature: 6juy4jdzc3sfsfr7cnzywyi1qoegwmxn
X-Rspam-User: 
X-HE-Tag: 1773689098-421288
X-HE-Meta: U2FsdGVkX1+dNmQa6LNccj8zp62Ph9OQuC4GC/0i5jm2KPsztCJICb34cs6timkluP2NudgVyQQ0PPpZXG9O/801olINLxW3El11covco0c4MPQ3+T0gU8IduZWrC7JHe45JeXA8OYQwvRhHssEB/C8cJNF+uBfVUcCej/ynGBxaj1UIhaAf/llmHa/b9Mo0XktVVDGc0vnWNz835leMfClZM6F9DReVH9Sx/UkMbDGkUU3qc5bpAk3L0xVYcbt2JSi/bIJa8AUy3YlxBeKja7v72+IlULmCdNfWDS0HdVlwG7Gieyj7Hnv/XHT8aeFJrSIFq6ZiSMakXV2QlJ5hUII0HuUN+i8SHLG3URv6T/nrPs+olh0qSNIPwyPlhaHM2m4oiquBMXP4RkZz2m1VzG6y7kT1/pMXptZDnFI47B6Y77NZS3LqG5E7IQ9etKSSwgolAL7OLwPQ9Bw+DwOc2Ml/SOcGj4X9Pu948aGDKsuSBx1wJaHnb4EH5uxYpC01uEF8js8e3Id2hY5DT3bESne2izSSFPPVDVJ42eOTmkuHB+sCT5qFJAnC+o2ZIO2wNiyC1ccgtJilzQpk7Nz4P8mH/kEJBmYJ4IRJup82KFtLjjKzBIluHDmGqQ4c7omu8eWHMBctb9h6/PD7kU03etraxs+DcAjpRU4WTyK5qx4IMwD51vxpsZd5G+7gb/KyWuojCsOB/hyfyJ69husEN/cHyROMOlpuq74K0nTSziWRgTOlIIrc4agXzlHgmRRulBJZz3J/celaoWjeut3+LQKVqEOglksBDp9C67B8nlzK4jmaoEpuVBqwbNwXr4vTHWqHk8/HSX9TZKvdqnmLXSUaj2t34dHAaHPmUL8Lay8vBxz3JpZsTKZuQ+KR2Xe/rVxwpH7UGz9xekxe2svRKSyRy+kunUfuE1BzpFbc28a6rncvP7rHI1OKUFj9S0XvcQQo2fdbNBnd+uyU/N1
 PRD086nv
 Wt9m5AfeLGhGSGxcOmXgMyZCtIujG/GhFVmO20N/l4crSriSs9QUL7c5zVwLsJOWusIUyNJAqbW+6l21fgSfkTm9Jq+Y3B/tFONV7+bbVK2jIWJxed9xA5QrOW8Ur/O+6fyRpJ1ZOGl2yVNHtb5s3z/dXofNHZnGquXjIaC5qBznqHGmOYIYbCfgFZy0ai/MnDzINymFkFZT+RCKr6bNiutkZWFwgnesvxasgVD1G9saqZiIuu0mEWFDd+iKMLH96l6Dw7KcJgw/Qzlbg9+aAhpt0il8oo/Ia947zFPiXhXquT50jg5T6xprMn9PPXRxFYN30HhrVWOOjba5jphJqf9HfEeBUIeNq2Q7zrKsvndxTBhZq9TYguiG80Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 12:21=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Mon, Mar 16, 2026 at 11:30=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> w=
rote:
> >
> > > > > If the maintainers think future-proofing is beneficial, I would n=
eed
> > > > > to handle the PTR_ERR(NULL) which would send a false success stat=
us.
> > > > > If we don't think we need to handle a future NULL return from
> > > > > crypto_alloc_acomp_node(), then I don't think this change is need=
ed.
> > > > > We could leave it as IS_ERR(acomp_ctx->acomp). I would like to ge=
t the
> > > > > maintainers' inputs on how to proceed.
> > > > >
> > > > > > > acomp_ctx->req =3D acomp_request_alloc(acomp_ctx->acomp);
> > > > > > > - if (!acomp_ctx->req) {
> > > > > > > + if (IS_ERR_OR_NULL(acomp_ctx->req)) {
> > > > > > Is this change necessary for acomp_request_alloc()?
> > > > > > This function strictly returns NULL on allocation failure, not =
an error
> > > > > > pointer. Changing this to IS_ERR_OR_NULL() obscures the actual =
API contract
> > > > > > without providing a functional benefit.
> > > > >
> > > > > As of now, acomp_request_alloc() returns a valid "req" or NULL in=
 case
> > > > > of an error. Same question as above. The only benefit would be ma=
king
> > > > > the code more robust to handle changes in the acomp API in future=
.
> > > >
> > > > For this one, do we need to do IS_ERR_OR_NULL() in acomp_ctx_deallo=
c()
> > > > to begin with? If acomp_request_alloc() only returns NULL, maybe th=
at
> > > > should also be a NULL check?
> > >
> > > This one is debatable, since acomp_ctx_dealloc() is intended to
> > > replace zswap_cpu_comp_dead(), which has the IS_ERR_OR_NULL(). I thin=
k
> > > replacing this with IS_NULL(req) makes sense, but would like to
> > > confirm with you if changing existing behavior is Ok.
> >
> > I think it's fine as long as acomp_request_alloc() never returns an
> > error. Maybe do it in a separate patch first, change IS_ERR_OR_NULL()
> > to a NULL check in zswap_cpu_comp_dead(), with the reasoning explained
> > in the changelog, to avoid hiding that change within the bigger patch.
>
> Sounds good.
>
> >
> > Actually looking at zswap_cpu_comp_dead(), is the IS_ERR_OR_NULL()
> > check on acomp_ctx also misleading? Should that also just be a NULL
> > check?
>
> Even a NULL check would be redundant in this case, per my
> understanding, because if the alloc_percpu() call in
> zswap_pool_create() had failed, pool creation would have failed.
>
> I think a NULL check on the acomp_ctx would still be a good idea, just
> in case, since this is all part of CPU hotplug. I agree, we don't need
> an IS_ERR() check on acomp_ctx.

So I think we do one patch to convert both IS_ERR_OR_NULL() to NULL
checks, and then the current patch 1, right?

