Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84CE6CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF30C6B0030; Mon, 24 Nov 2025 09:47:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA3D6B0031; Mon, 24 Nov 2025 09:47:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFFA6B0032; Mon, 24 Nov 2025 09:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5FF16B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:47:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7683313AD81
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:47:24 +0000 (UTC)
X-FDA: 84145778808.09.48ECE23
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 742BB140014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:47:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KDL5jjzQ;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763995642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5v8r359QRDyWmPKXXZF8Y2SUxEvfPW1olqpozKKF9Y=;
	b=QtVu6l5aa4CTx9F6dioNV2EjkcLVUsfLHs1FjCwMlpaLmTT8alm/0hAXkm10bunzt1/XAu
	pql3VRLmdW8JKIo6GuqElCoXk8+eKzmPJMNxabOUhk4QD0mA5vOuJSTJxhkHi0Z58Tx+Uk
	QsPyc5hapsOQEcY/ZqHeandblVaYnRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763995642; a=rsa-sha256;
	cv=none;
	b=cFkqNkUUuUWroCIsJV8rqIdgJIZrJrqITZK1fXN5TJkcgQDILXGUfGZnjZ1GvXSrpvM8nn
	QVmoTDtTqCuxj4SeeiA4qkg5oXAA8o4FZwSpp6iXciOuYv5ESQ18/oFHYfxCZY9KJGOLII
	d/wSpWyX1kUUzbhCoCJdRBCyvMDVNIo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KDL5jjzQ;
	spf=pass (imf26.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso47633985e9.3
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763995641; x=1764600441; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m5v8r359QRDyWmPKXXZF8Y2SUxEvfPW1olqpozKKF9Y=;
        b=KDL5jjzQSfVt7THwwu0wVp/2iJ1LwOa/t1sMfOjJocmgqxfwGWA3p6wQmfKpjs+EsP
         4FEcAJZC9dCf48VZFPX3+5u9MuWWoPFIUlHWRwPCnt0o8LiGxhEBf/WoirqgsNqrOnUu
         irgbai78sgJ5OsasB5fi0FODzBn0va8cZ0Ms8NP2Cowo3mpaMJ98mH/sD9wG7mEGI8yq
         N+jBiygq8VG1ChZRM+JVpbsivKZy8R3dR+Ef3g3teaV1RTMDhMewNpFKMI1uMuAkB4Ch
         RPx5bqapeC508syVTmbstD89tkrcRNbwh8UNZK40XAZXAdZlWp6iovNR/Bz7lUhCCaJr
         ygPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763995641; x=1764600441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m5v8r359QRDyWmPKXXZF8Y2SUxEvfPW1olqpozKKF9Y=;
        b=OWAwSGd/z0K+OzMs9coAa9/H+Ozt2h5DgezOMb1TmrlhroD/36eMfmDj4W3W8Iw5m/
         ukZzG/f8TVo2Dwe4nMscSu2B/3qcyisL2n4QpKmHCXvLU4ihxYHoNAES79mmTai2YwFV
         upaXjXzSYG22bMT7utcSU5op8qHO2177qdMYZrUxfGQQs9Mqf1wB9w52uPoKc/LqIqk2
         6WKennPBxiEaigtw56OGZ7sQNSwyPcM+DH4j/+Vr8eCvN86z0F2kYoXEK+enRJwnL5nI
         fhtLVkgNwHeB/BsSp+5Hk6rAiJbP+jGgUXq4YXSeYjAzZJKpgMf4A007lortTZyWVjhW
         2TfA==
X-Forwarded-Encrypted: i=1; AJvYcCXs7gty9pbTyX8f8OXS2d0MTh1FuXLkXFRTYS3jCpP8lnp5hQ5gKerpuetrsyuMswFABHPc9orB0A==@kvack.org
X-Gm-Message-State: AOJu0YxezkDiNv9YTu0FqdY9z4pWSNuvHHJMznTDCDBj/3OMtosnwaHw
	73Xsqpm88d162SBc1Iczlk5G7gk2wWzUccRlF/gdfsTaEzT7sYVbVJo8roGSvNLl+ggP8rwV8O9
	CrVnpBc+ojnDPhBPLy7GBXMw0SgvRRZQ=
X-Gm-Gg: ASbGncseX+0uTbkm1xlDobfNPSPBcgyIiSdDfyqqgYfwTZ9DngbFLDslpBPwvXgjEHk
	Yolt7YxrAWqOu6kyH3BehRY1jX7pMykBwd1ZcLphsEgoln0f5oJmDY5MEn5pxWgQhjSQ8/vZI+R
	1RziPMevAbO1KGNnRPg/1+v80v3BGo95YcZtDxJpuWAuGeYrvdNBK8mfsRvI5DoovK0bxGUt3Qj
	oXaRtWPdLyRWiGq/tuHeQFTtNBzU12HlkBO25CDzDIsBqF+E9Gsh3ctWEqFtqo8slj3U9ySpG3/
	6sYa5w==
X-Google-Smtp-Source: AGHT+IHMNB8oFKl5ODH0B+syuOek9kjeTSYdf5fUxU6j3RsWceEJ8KYR7Wpk7xqjfValYPcMgjsoo2RtIHjEWkXarYg=
X-Received: by 2002:a05:600c:8b35:b0:475:d8b3:a9d5 with SMTP id
 5b1f17b1804b1-477c10d6fdamr123781255e9.10.1763995640453; Mon, 24 Nov 2025
 06:47:20 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAKEwX=PQM_4Mp75R4yeQ=WoqOxj7EJK=FpgcemNSYDS3fLXQLw@mail.gmail.com>
 <CACePvbUxCN_2fHz0Ds=u52mmOvdhonvRgm6mPdcJcs5qLZj55Q@mail.gmail.com>
In-Reply-To: <CACePvbUxCN_2fHz0Ds=u52mmOvdhonvRgm6mPdcJcs5qLZj55Q@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 24 Nov 2025 06:47:08 -0800
X-Gm-Features: AWmQ_bk04teBfrN1E0yDgPAZJygZe-jy8wDdznUBiVdZ6lbIRzp2aG_l5nsgh74
Message-ID: <CAKEwX=Ph6ynA8hRWchy2XeU2bB7ZSdcrZ-cu0X0KCgu8ZBfTVA@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e9g15uohuguz9hpy9duyigfmkmpsm979
X-Rspam-User: 
X-Rspamd-Queue-Id: 742BB140014
X-Rspamd-Server: rspam01
X-HE-Tag: 1763995642-825068
X-HE-Meta: U2FsdGVkX1+HeEi04LlXsJD0Tsu2F0kkDVxFyAEqhxNhD1WQdTbF4J6IVI40mqhPjSddhWeP4sIq9OtAC2JPGgqJPf6u2DPb4sDtdygiN+ysiHeULVHRN5PjPFzw496efJMhe1h1aPWiG8Xm29bbbqqZIhLef4XJ/ykpbyCFVpuwpB4vb9jsGnZ1Sy/lZj4UFFv99spyx+5JdIqjUbH/hNIREGGruePDQs4yyxsrPFPBlDyZuDZbj/6+H3GeR4Sf1VaME0tSDPQTGk0nuLYLTI/ablZEZtvu02TioJltNZ8lWBeV+qhbUARKPnhSLhqVJ5tIOhOZELqFtM9C207eDZ1J7+05F+UX2CL7i6TA+5+e1RmBinCNaoHr6bfzgB0xlz3Nlq5qnOJpMPiwsG2SdT2QlEOJUGQ8ahRq+5tFkP83Apjkr/HSCdymzTi4aS56d/m4T+/PLbVlY3fSY6q3cYWUb7B+XGqztCNBNR/IEvw7fkTgVZUh5XmmplDAOhH72wj0pV43ALiVLfGH/V1oOH2bwF5USHY77KMiBYWoVAnOwRtoFQ5oUN5CpIt4SSCLX1sPDDWTjV7p5NWBrixUEtt2FAZKLLik2m3t8l27hQN5GznGXOdUEX+FtTfEUzale6vY9HN82PxkCWXgN+tfzWf6U+v3l/hfPu+459dFulK0joWgKFS0utePN6XjG48vz0HQKEU3kFvAUYj6Tgh5i7/gClRz9GEdTcBOsRi/tsCyJpOpNMvOKmXdAwPqa8fqjM01XZJ511t5NAB7Lb7Nm01yFprFDMdFxHt57sXXbygzpxxZpvdcjjPjz8HCAW5puVqpToxxYKXKhwB8HkyzWI4hs/SBv4zEL9srIcttLYzDvZMi+eUn3nDHdXyNrqbMPZ/oYaF7OrSL3axX0xMdnQ+2PSWzBLNTpPjdq11ZyMjWlpzY4zS4jyPUisnXXWEHyW0HhYv6kgO1E4K/lx3
 ZbvqX5Ap
 GxxaVAdEEw+kevZFSrtkQsDj0OTex5cfjCeC84zeGSRn/SQwtE4CXuxHvLZIoxxMHL4frCEBlbwD4Ctu12upQic80DzNZXJGtH2dw0dCnjMriuXMycyAJbLO+Qg9dBEY8zNOGQmIGfx7Tecv2Uka6Kro0TnfAz+KT8b64kxcQv4470bHaCCA/PPGWjiLxATPNXLh/dGMoffBanlPlUY6qgPkS+9Fcisdyx56ERaSSR6jUoa/bafqwbBjxaagsCz1bV7Di/XoAin2QZfXSz49ssYNMlOCuRmP4b3WmhW8DTKwoDoo+FuXdo7pt5N5/RP9xwvOqN6LBCzTqCaAiKwDiEFKWY9imB3VM39+hi19y67YY49clvMZZYnu/PQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Nov 21, 2025 at 2:19=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Fri, Nov 21, 2025 at 9:32=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile head=
er
> > > for zswap. The swapfile header indicate the size of the swapfile. The=
re
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> >
> > Would this also affect the swap slot allocation algorithm?
> >
> > >
> > > The zswap write back has been disabled if all swapfiles in the system
> > > are ghost swap files.
> >
> > I don't like this design:
> >
> > 1. Statically sizing the compression tier will be an operational
> > nightmare, for users that have to support a variety (and increasingly
> > bigger sized) types of hosts. It's one of the primary motivations of
> > the virtual swap line of work. We need to move towards a more dynamic
> > architecture for zswap, not the other way around, in order to reduce
> > both (human's) operational overhead, AND actual space overhead (i.e
> > only allocate (z)swap metadata on-demand).
>
> Let's do it one step at a time.

I'm happy with landing these patches one step at a time. But from my
POV (and admittedly limited imagination), it's a bit of a deadend.

The only architecture, IMO, that satisfies:

1. Dynamic overhead of (z)swap metadata.

2. Decouple swap backends, i.e no pre-reservation of lower tiers space
(what zswap is doing right now).

3. Backend transfer without page table walks.

is swap virtualization.

If you want to present an alternative vision, you don't have to
implement it right away, but you have to at least explain to me how to
achieve all these 3.

>
> > 2. This digs us in the hole of supporting a special infrastructure for
> > non-writeback cases. Now every future change to zswap's architecture
> > has to take this into account. It's not easy to turn this design into
> > something that can support writeback - you're stuck with either having
> > to do an expensive page table walk to update the PTEs, or shoving the
> > virtual swap layer inside zswap. Ugly.
>
> What are you talking about? This patch does not have any page table
> work. You are opposing something in your imagination. Please show me
> the code in which I do expensive PTE walks.

Please read my response again. I did not say you did any PTE walk in this p=
atch.

What I meant was, if you want to make this the general architecture
for zswap and not some niche infrastructure for specialized use case,
you need to be able to support backend transfer, i.e zswap writeback
(zswap -> disk swap, and perhaps in the future the other direction).
This will be very expensive with this design.

>
> > 3. And what does this even buy us? Just create a fake in-memory-only
> > swapfile (heck, you can use zram), disable writeback (which you can do
> > both at a cgroup and host-level), and call it a day.
>
> Well this provides users a choice, if they don't care about write
> backs. They can do zswap with ghost swapfile now without actually
> wasting disk space.
>
> It also does not stop zswap using write back with normal SSD. If you
> want to write back, you can still use a non ghost swapfile as normal.
>
> It is a simple enough patch to provide value right now. It also fits
> into the swap.tiers long term roadmap to have a seperate tier for
> memory based swapfiles. I believe that is a cleaner picture than the
> current zswap as cache but also gets its hands so deep into the swap
> stack and slows down other swap tiers.
>
> > Nacked-by: Nhat Pham <nphamcs@gmail.com>
>
> I heard  you, if you don't don't want zswap to have anything to do
> with memory based swap tier in the swap.tiers design. I respect your
> choice.

Where does this even come from?

I can't speak for Johannes or Yosry, but personally I'm ambivalent
with respect to swap.tiers. My only objection in the past was there
was not any use case at a time, but there seems to be one now. I won't
stand in the way of swap.tiers landing, or zswap's integration into
it.

From my POV, swap.tiers solve a problem completely orthogonal to what
I'm trying to solve, namely, the three points listed above. It's about
definition of swap hierarchy, either at initial placement time, or
during offloading from one backend to another, where as I'm trying to
figure out the mechanistic side of it (how to transfer a page from one
backend to another without page table walking). These two are
independent, if not synergistic.

>
> Chris

