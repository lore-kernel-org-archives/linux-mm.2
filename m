Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D4B7C9831E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 01:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3E86B008C; Thu, 24 Sep 2026 21:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654A76B0092; Thu, 24 Sep 2026 21:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A566B0093; Thu, 24 Sep 2026 21:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CFA6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:18:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C16191A04EE
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:17:59 +0000 (UTC)
X-FDA: 85250523078.07.0F3C968
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD1C710000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:17:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InC5clUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790299077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qzl2iBr4Tj15bSdJUmjfa1MoXknfSugmmEugQM9ke00=;
	b=Rmzuob5/Rvnm5ZSxQzVYnsOt0DzRFYEQN7Ix9NdxoAKAAgX4i/FEzZYpoJJYyDW/IR3vkF
	MjHDNm9XeCJlUZqsS1UiibCNS03XBpvXRUOufrcTjJ2KMiEhYjV2VIL0U92gRfRtBITwIT
	uZJXJdx8NggYp3IPp3hv9qzf7itzbsM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InC5clUn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790299078;
	b=TrpXn/kjdM+9y8RxEX9E5EfsWx7SZxRCVcAJBWjBEjdLqEJV1CFGMdLgTwDT3CyhgPFk5Y
	xfHB4DqLtydRfoDPh0CsQ5XbeDSLnO+cWF4Ojer0Sub9DaXh1xXvdDaB3ah3JGCL1iLyN7
	G2ldWqMN2rIlgBZzjmBykf1K3ViiA2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1FBF44796
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5061F008BE
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790299076;
	bh=Qzl2iBr4Tj15bSdJUmjfa1MoXknfSugmmEugQM9ke00=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=InC5clUn7OGfPux7wuIu5zfCWb0FPfhELihWg9rLnTJruPYkE4SewjY/4Ep5ZpsVl
	 JJcbf6Ii/vC771FdXhntsG82Zgfdz0mp3BbEmNTBlWPSaQ/1lYKnJmU5odnG+K9nS/
	 uHHPWQH9uk6brE3Mex7jhw+rGLNHPelRogD+pW+ze/5hEoIqJf+HccFkaEZBg9gsb1
	 CjkEttImXmU5C34dyCVKEUgZvM5FQJJzOiENh2iy5XTA5CFOtD4QpildU/wp4iahCm
	 PCyo6/vLXf5prijbOrCCyHGf9vRVX9K8AaUXiiHvVyy6bWjhEEmH1/ncr6HT4tDS1e
	 /70ZoeD/sWMDg==
Received: by mail-yx2-f40.google.com with SMTP id 956f58d0204a3-674138cbe59so11785d50.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 18:17:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzIBHUEAREfQS01t9kA1qfQ65Prt6HnPrVvj6z8cyPtaP4+4k0tUpCA2x/gT/KSiJ3DnAhUTeyReA==@kvack.org
X-Gm-Message-State: AFuF++nougB7pKo4uml0nMeSi8q+zorMWk3AgNxaJANv/IcMd2KT975D
	Gp6ya8hPX7XW4q6CQ9hJNvtW0W8eR4RiyOISSJhfzhHpSqkiy2JFjDfWQr5Pu6tvjFiAKrHeGf7
	tsopX7OvDxMKaThzx2bcbZjHc339rLpfGsB099xc8ug==
X-Received: by 2002:a05:690e:1207:b0:672:a068:8e43 with SMTP id
 956f58d0204a3-672ed9cdf42mr2261456d50.100.1790299075721; Thu, 24 Sep 2026
 18:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com> <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
In-Reply-To: <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 24 Sep 2026 15:17:44 -1000
X-Gmail-Original-Message-ID: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
X-Gm-Features: AclHuK8BpPAFHsVgO1T4L8qwA8U0X0PC1mEcUr8J1TqFhwVtyy2ssRkAaIFOQOI
Message-ID: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Rik van Riel <riel@surriel.com>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
	baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: w1qpfs5x4ktfry45cox65zqsm74p6jjb
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD1C710000B
X-HE-Tag: 1790299077-190410
X-HE-Meta: U2FsdGVkX1+bUujmD6jo7NNgE3kG+4u1gwQFCmE4DI9fKfZcotgXHXZEbDzuYzT933zZ2VMJjCcJeCOKlqhrEmaRKb3isw18KTK/rbbTg7eXhZZ/FM+QvKjhXp4n1fhCxNtkFvmYk2R5A40JL179PNZ4Jqe7VskJ9HamOGRDWqbgX0ophIBsbNXu5YYeUE+coN4Fh5a9by05smXMWiXnrznkPlZQMdFe76Lj1Mt65b5kmpiyZfuRpCJYUpT6OrSqkjdTEJF5vmlEcJ+V2MlKlfON0zIJsG/EJMjZZhjsnXHFC9zNUgM2cXhtcgpGwpGFrFX1SJWAjo+npPxVJDh1gGQvstrFKm0vIbWs2/cQSLppgz6/b7Kvjh8JJcMdgbtc4T7lSSLw3t26uf8OvzVUiULRFO4qwAzwgQZ8Vkd3ShIP6CHMuOQzEZ/8xUKZHAWPcxFgN89i7sPOmp/+5O3ovj1e0BKs1Sdd0od+iEgwZDsqJIgYvRpWrRxpXUCbErdNh9ghO1pRXW6WWkj3YF6D9t1j84Gy7/U3J8V62pve+SNDvAbxVIudcDE9m6e1r3n0ri9fUnBe82oLMa2uxpvIbdWvvgvMqlXKaF3eVpu5zLrpS1Arkce6TywsI9O+lHl9igpBjf1/J2XzGVtP/yVaNXS77CKgbEg+40qG2qfVBJwboaODarjxV2aEv3W1/88oTkMo32/J5SxmZQEz0NNBaEp/CThDYky0TEFGLY3jbnf1OBA4Ykje94FUuGO8EFIpBVvdgWNl2vdeV0jAZ8rBYDoNMlkQmgi1IMWblCtKZide7Fv2libay0zXUKl4+awiSXJbbBdNTcTlgpB7oC0LQcbes6krNVJgqe3OZ0XrdxPDekYUibomOjPHURK7gBdFxpPvm+6P7vJCI0jDMA8vlHMj89G2TJCxIuFhyTc0KEZ3ttSH7mkW2WcMS6BEGqJJcd2zyno4bwcHEpK0YXk
 Kc7s0LuA
 /5zPRaEnNZdCxizDqGLQqlMqaNH408lLSYwvz2fP69MiR2ugSkImHyTG9/08S7gGe3tB+lnFIBdbLxbzNqwZLP1x1ZK23DEbFaM28DsPXpYsUH56JxeYJdmeD7Uxeht8F+elTdp1c85g4MchVderzjW182BM68e82BpUmyi//SXS5QAbedyDdnPJDE3b4Y7OiBvhopQpmKS2Gp+FsQnnTV8YhBXqwNPZUhC9dSUEQVnVrpUXJtkWDpgXn5ot9zua2ilpE4rZSh6CvMRBiUz89H5UFSyIYALZwGI6uTlx54deJxYdIOgoWzeOHaVIe5M+tUhXDVtGQohnmboK0no6upCkGvcA9sWDZj3QyVJCteaJYa+1+D+/BICm/oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> > On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > >
> > > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx *ctx,
> > > struct folio *folio)
> > >         if (zswap_load(folio) !=3D -ENOENT)
> > >                 goto finish;
> > >
> > > +       if (unlikely(swap_is_vswap(sis))) {
> >
> > There are too many swap_is_vswap() in this series. It fragments the
> > code path, making things harder to reason about. Esepcially around
> > locks. I count 22 in this patch alone.
> >
> > I consider this the biggest drawback of this series. This
> > fragmentation of the code path.
>
> Could we avoid that by simply always having everything
> go through the vswap abstraction layer?

Yes, but it will pay the price for going through the unnecessary
redirection layer always. It incurs performance and meta data
overhead. That was one of my previous objections to the earlier vswap
version. Sorry I enjoy micro optimization too much, that is both my
strength and weakness.

>
> When everything in vswap, we don't need to test for it.
>
I've been there and done that, the result was pretty bad in those
earlier series.

> Handling the details of what's behind the vswap would
> be handled one layer down.
>
> Chris, do you think that would be cleaner?

If it can wrap below the swap_ops, it is just priviate inernal dedail
of implementing its own indirections. That would be much cleaner. That
is what I am trying to pitch to Nhat in prevoius email but does not
have following actions.

Chris

>
> What am I missing?
>
> --
> All Rights Reversed.

