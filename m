Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EDC9C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 14:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C537D8E0092; Thu, 24 Jul 2025 10:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03048E007C; Thu, 24 Jul 2025 10:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC008E0092; Thu, 24 Jul 2025 10:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 979758E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 10:53:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62AF91DA83E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:04 +0000 (UTC)
X-FDA: 83699450688.08.CE9DE09
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 733184000D
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:53:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OjM9O4lu;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753368782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5W6GQLMfYZFiEJ+Qoi5McfZK35xrop1Qe9F9Xdkh50=;
	b=Ot65HNhGm+T77gCN9uR9ATql/743oWuq9t7I77QyXrBkD2sDg+tQ70oBx+i8GHkiwvdD3e
	NDtO+OHO/65VQqUERCLfYUrXAeaJuktdE4+llUjZAPEqeeJ3T4TSj7d3kw3EuyvwGlKNK8
	AEHUgVrXECQVwTSOk2He5htdAhpmVEY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753368782; a=rsa-sha256;
	cv=none;
	b=tr/LaJjRVY2ZsyPfm4mplf2QWuqDH5bJlMt2+pditXbOYxglBjLfhZQ5Ch/BTEFbu9Br/A
	MrZLwEDVf8HuRd/3f7rxoSz3+QHAEeXf/6/NHkRMOhNibqngKceiMBruQx4rakWcfNkrEK
	9b2mYWN5+3DBgMsRlnS98eep+WwOgHo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OjM9O4lu;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-60b86fc4b47so9347a12.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753368781; x=1753973581; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S5W6GQLMfYZFiEJ+Qoi5McfZK35xrop1Qe9F9Xdkh50=;
        b=OjM9O4lud+vdwByyI9IiGGwG1BP6QWPmrsmPEBamGdm51PmTIuDzPduMYFGUZQhhn7
         qytFcnqB9zf2vMC3F/4tnsRQUqPw78GdVbigeLxWNDE9G6VhdrCp+OQV37OgiuMIZqQ+
         he6lMIHI1AEWU7jX1ssR0ZyEQIMvYG49Drb/Yq48W8003FxwTXeCk6P56CatjiPoTeKS
         Qn/wMG6JdImqGt/xtsf+iYu59Gw9T1FeOVOwjZg+Ad5P3P+VwvXJtofNwK0Jd8Cow6tW
         uMjK1KqoU7u2Zy5E61ix8OAI+zCJUZWb7P+rjvpSbIw3WE3jiNLplZ6/Uk6TniZpagrH
         UWYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753368781; x=1753973581;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S5W6GQLMfYZFiEJ+Qoi5McfZK35xrop1Qe9F9Xdkh50=;
        b=d+0SO/xd2wn+l8LRDHdif/50+gXYNZDrs60Cuy0uDzJeYLFUygVMN5bQwulLO0RJL9
         Hemro7ZPWIXqqqkuvzgZpRmiR/2y0lPFY0PJvG6tvTTYJPaA04HzO2sENUosI/sOXWW/
         yTtPk0wnxHEcPAPuDPTdjRAlgBtUnrqW9uipSVZZTtPXArUdvGAXZm2Nq0v2CC1hwjKC
         qutDmnnjM2hC0/C9JB+yZLMS4oTPIe4yZvfVfCYtQ5ofNtz3BpmZykPk13whY3mx3vF4
         1AI8aTs+DeRDZUz1nox2TSxDaa3Gaih5D4KSrLKVWUJdV4R1MR0SB9MJ2wlV2dwYnaai
         JHKg==
X-Forwarded-Encrypted: i=1; AJvYcCXIlXLHOx8FUfmBWPOe38iHfB3Iluur6llH1jfel+jTKyiRXDWUye1o43h3RNukVxNpOYioKBoxMg==@kvack.org
X-Gm-Message-State: AOJu0Yy2kuobgHTrRrjra249cTbiQHSWR5DAHbbbkCYLWzc+lEm2m5Zp
	2AW7CMnXIFgjwlojD14ODj9UdEe1DMm9DyA8L2nEGRvBOuka321/pjyafe+abNqXjL/NIXbq0U5
	v4TkDZdo/ToDiMkQq4ZMk9kgxBpvHI6X+1i6JS+wT4HjK9ufxnM+9AIhS
X-Gm-Gg: ASbGncvzbPXyxVHHTm7agG8cL39FkXWm+WmjjvCOdZZWIFM8a4s3pUpWTrqu/N+xUkr
	X0714EelseW7rlKb8Rd2yjPSwCmzGWhYsep8EwQhtW45quakBCoUansLXeTCCf36/Cr8OCjOEVy
	YNcRvJaYIdZSOarEciSXEX/kixpOmpzr6Nk+jE9hvBdulBfpYX1Btxipmsg0f2U6B0jjc/beTbQ
	kzU3UlAwUT9gS6vsQ+ojrgIW7jc/yjYLrk=
X-Google-Smtp-Source: AGHT+IG8ssWzr4F1L4YOk9MwdHJTG8gIMT6wpGrMN8VvukpOQy347mf79eESvOL6r0KZ4TeqeaeflthxQsKBM7CQsWU=
X-Received: by 2002:a50:c311:0:b0:612:e537:f075 with SMTP id
 4fb4d7f45d1cf-614cce4724emr83262a12.7.1753368780520; Thu, 24 Jul 2025
 07:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <CAJuCfpEcjH+W83At8WSkgzO=JvZmapg6dPaXmuSRS4ufhSha4w@mail.gmail.com>
 <CAJuCfpHk_k5eVhAZTK=jJvES9311Hyo_YXxY-S56EAYSBuRVRQ@mail.gmail.com>
 <702ab3bb-db4c-49cb-bb77-4e864cae610e@suse.cz> <dbc20783-0ff5-4902-bd73-e9282bfd87ba@lucifer.local>
 <CAJuCfpEVrpHACx2G2=Gq7YadxkA-DnFpFmbUij=Xr1=w7yrLbg@mail.gmail.com> <3be82198-a992-4917-b5ac-b93bb0474ad1@suse.cz>
In-Reply-To: <3be82198-a992-4917-b5ac-b93bb0474ad1@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 24 Jul 2025 14:52:47 +0000
X-Gm-Features: Ac12FXwFNgc4NqgCdpxxbB8pJw-RXOG2gFoiHeXshUqdIsHwIesk51LXD1BpTvo
Message-ID: <CAJuCfpHQ501HBBQjm2Qvc7dgr93uH-=bgukXHJzpkJRk4_x7SA@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 733184000D
X-Stat-Signature: jrb6rxh7ske3ibgjkmbis411ek8rxum5
X-Rspam-User: 
X-HE-Tag: 1753368782-218245
X-HE-Meta: U2FsdGVkX1/fA19vntLmUkHb3czXmbUbKzE22pulMSKx93civcHgwvFzJenJA7cs+eT7+kXUaJvoKfPiQOveT3R17QNcPpztO5l+e9tkjQLAEZP3sn3f8j+PuGZ14awYGYrpJ4enqPGg5IGmzF4jrNInmtsRjUCl1aF5aO16RPqeV2ZQ6nIen94Gm1Wkkm3vbi3E7SBNHMCTPAAtFPjN6ANqv70fMNytDtkNmMVqRxIScAnBvbW4BPnaXLXHHeSjnORUIhOHNaUOp+9hniHWTVYvouFMKd7FWYJFTW9G0FlEBwniZNO/bx5KenmpUrQtRgBpWgR47oRfak1//9rS8+batSfYblyAzaxF0WiADlOp4ArLKplbC2eYwaKFCCprO+v7Xh9vrh58qAZUkEJvlTzRc6HynfncMmdbCJ3D2Xpok8qlPOi0RNN4Mfl1FQ6UQsU9s0Ea5lu+OHUqwd7qlRbEl+J4GC6xkeGpXiuatLx4Nk+Ody+Bb3IBUCerm1+MSjR9yG0jRnJIWAaQcFYHjKqXlBTv4cp9joesjK8WsP2L5/Kl+l36HJc8OMUVhopux5wJ35ZEl83M2L8Mrma/zeWUN8PivyWx2GNSXfgEV/x8nJmn/XTWFetSoxJR3iUHc++5ISpnNq7mN5meuZsJ8mbPd/kh7SSVIlwKMwomtDjFREBLtJaFp6u/SGrPxpfA1gmlD5rCmpT/wMpqPv1fP6/WrCzuHJxKnXbO0IxeeB4ALGo0Qbty5guk/DQuIBFPognU66KSDzywAEwxtbvfAbUa1V6PHDceXh+v4W4OFamtzDSs5EjnjQ1ADvHbJaoaZobd7Q4YThwasDU3KxqDUiWdbNoJEL0giH6T40XiRyeG6yL7vdR6qWh9dlRoHN0u65cn95GWPeHkeUPHCuXRhOCHrjjAG0e9viaqbcmFjCfTP9VSacksjU8xaXkWwbLF7rBb7FWMdyPpewGryLw
 FSz9dmeN
 04LgMCDao05oFJc3/fSmAnULmwM/l2EXJcgLqBDUXKQyoYwdWH3yVwD6AQvjCDUqtl4p9ssHaGq73sE3h32xuEigCwn5Zod111LZkA+XAJ7CHmzhCE7rLnWY6UpnHFfGgoVmqvkKJhMtBnMo8lYL2HwoNIz6GH6/IYtA+wTM5lS4C3ukgItXZK6z6ZohHf4KSnRwYyqX08J6zeOS4dBXHq6nBo71qS/fjv+x4DNUj55LSN4BUHsPqy+IceT1vtyz69zhTabHS9xmHh/LMtpemYJoms79w4v2brTgBQK3GXTJOSok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 2:45=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 7/24/25 16:29, Suren Baghdasaryan wrote:
> > On Thu, Jul 24, 2025 at 3:53=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> >>
> >> On Thu, Jul 24, 2025 at 10:38:06AM +0200, Vlastimil Babka wrote:
> >> > On 7/24/25 04:30, Suren Baghdasaryan wrote:
> >> > > So, I think vma_refcount_put() can mmgrab(vma->mm) before calling
> >> > > __refcount_dec_and_test(), to stabilize that mm and then mmdrop()
> >> > > after it calls rcuwait_wake_up(). What do you think about this
> >> > > approach, folks?
> >> >
> >> > Yeah except it would be wasteful to do for all vma_refcount_put(). S=
hould be
> >> > enough to have this version (as Jann suggested) for inval_end_read: =
part of
> >> > lock_vma_under_rcu.
> >
> > Yes, definitely.
> >
> >> > I think we need it also for the vma_refcount_put() done
> >> > in vma_start_read() when we fail the seqcount check? I think in that=
 case
> >> > the same thing can be happening too, just with different race window=
s?
> >
> > Yes.
> >
> >> >
> >> > Also as Jann suggested, maybe it's not great (or even safe) to perfo=
rm
> >> > __mmdrop() under rcu? And maybe some vma_start_read() users are even=
 more
> >> > restricted? Maybe then we'd need to make __mmdrop_delayed() not RT-o=
nly, and
> >> > use that.
> >>
> >> Agreed that doing this under RCU seems unwise.
> >>
> >> I know PTL relies on this as well as zap PTE page table reclaim, likel=
y these
> >> wouldn't interact with an mm going away (you'd hope!) but it seems unw=
ise to
> >> play around with assumptions here.
> >
> > __mmdrop_delayed() is a viable option but I would hate adding
> > mm->delayed_drop for !CONFIG_PREEMPT_RT just for this one case.
> > Alternatively, we don't need to be in the rcu read section when we
> > call vma_end_read() inside lock_vma_under_rcu(). We refcounted the
> > vma, so it's locked and stable, no need for RCU at that point. We can
> > move rcu_read_unlock() before vma_end_read(). However that's not the
>
> Seems correct.
>
> > case with the vma_refcount_put() inside vma_start_read(). We could
> > change vma_start_read() semantics so that it drops rcu_read_lock
> > before it returns.
>
> Looks like there's no other users of vma_start_read() than
> lock_vma_under_rcu() itself that we need to care about, so seems fine.
>
> > That way we could do vma_refcount_put() after
> > rcu_read_unlock() in both places.  The retry case in
> > lock_vma_under_rcu() would have to reacquire rcu_read_lock() but that
> > retry is not the usual path, so should not affect overall locking
> > performance. What do you think about this alternative?
>
> Sounds feasible.
>
> I guess at that point it would be cleaner to combine vma_start_read() wit=
h
> mas_walk() into a new function that does both and starts with
> rcu_read_lock() itself so we don't have the ugly scheme of entering under
> rcu lock and returning without it?

Yes, I was thinking along the same lines and maybe we can also move
the vma->mm !=3D mm checks there too, as Jann suggested. I'll see which
way looks better and if I get to a satisfactory state, will post a
patch.
Thanks!

>

