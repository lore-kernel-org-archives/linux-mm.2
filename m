Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DF1EF48EE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 09:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904526B0005; Fri, 13 Feb 2026 04:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887E16B0089; Fri, 13 Feb 2026 04:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769766B008A; Fri, 13 Feb 2026 04:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63DFB6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 04:03:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8C4B13A8EF
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:03:03 +0000 (UTC)
X-FDA: 84438843846.27.C143E51
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id E3BA4180004
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:03:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OeDodqPb;
	spf=pass (imf24.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770973381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKBMPANl0zC8AGiCOQJvZ+fUUtPvF2idCFAEvWrwChs=;
	b=BtvPyOeLZE4ua9ZA5ENcK8E+nS12lfwfH7W4XHvsgugAdp51wDrHoPidgEgA/i97AND6YH
	M7vg16CX3Qtj8YGWgAt+ymWjqUnL0rRxuMLkh9ijppLEn+6G7l/H2lJuoVNlo8XpvgDck2
	sjA8bUTEpwE/yPXjgcxuAyLwjo7DWQU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OeDodqPb;
	spf=pass (imf24.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770973381; a=rsa-sha256;
	cv=pass;
	b=JKfWEvu4GGLcDkbx6UOodybnCpu2Z3gpCn6cAzxU0UEgM8P60eAXUeB+RQU8i0lS/FoX/P
	z3gbHeKfp8nY+0Sb1BZSZ8TMfR28Yt2DFrr/A4co5uLS28k9kBYgndPMGJQ/c4bxRzCJEc
	KfVuysbdpd9UcdzkRaXHunkckQCteiA=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-64937edbc9eso612870d50.2
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:03:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770973381; cv=none;
        d=google.com; s=arc-20240605;
        b=NSzdM2PEltQyywhiyi5Q/4D8YcXWXvR7O6fJQ5Q+wI0E7wj5QMadXMOJKuRyVVIDxG
         KEf9OZKRYwtf5pQwE8TMk6m7wqBNFDKYIFGZ5daypqQaHS1J59l1I8RemcproLKpXFHq
         LzDJtdo9EGSset+h4Ps7MueNuqAGO2mTv57OOScjUNBf9mOSsggSDhQ3hoIkiEzNwEQA
         7EYRrlgGOs+O4xfFTWontMszYFlVcyfB2pYy2yhLX4jU0qcU2sGnBnkENarYLT5ckcJc
         CPqCb/zfD1/ZsFiLhNxf0ELASu5P9LiQAO2BhAb1AF9Q9fqpknNCnK46BZlusqsqd73g
         NHiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aKBMPANl0zC8AGiCOQJvZ+fUUtPvF2idCFAEvWrwChs=;
        fh=6apEyvi/HYnIgGnLz+OOGGzYCYvVjZtvDbGZ3rfJBD8=;
        b=EVQTq9vl465dBGxn0HlB6AJxAmNBJ/3xjVAONCKeG8OS8nXUlZVENORu8gWRNZ6I59
         KeUYhLsCeee2NeL74DJJ8NjZV2hlMC9D0JIhhTLZPDRNuCfUPyHnrK66cW03iEc2gwYD
         MOXDDd/JSKFAqqHN+R3lxuJmi5ogbqc9Ih3yEVxJ4T+ilqBqdndbeXWECeL7xgLd4qZl
         EiYjhygoPF4ud9WD2qNx9dZTG7ILyE6eFM5vRUvJr8N93RkMNldVcCH3skR8OZB5WQhh
         dyb2x0wxboCvMjA5WwpZJHy3Pw9S9S8gJhlUsp2DRKxXGCN+QzJBinXBekEkqIlyYn8g
         0/wQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770973381; x=1771578181; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aKBMPANl0zC8AGiCOQJvZ+fUUtPvF2idCFAEvWrwChs=;
        b=OeDodqPb+44T4Yn3AFCbxUGrhV6J9h68GZXa52ZNws340y/cdOrcevX/lllLflzw8k
         dEa6HjgKpT/qCx1dyiI5UUI2wTT6V+6jmMBePaMcbIrSfma1MlbImjykmnv9FNrwRf0z
         8H/qvgf7ZhHvKzKQJfJeZI2amLyZd3z46Qj7wGwW0Yl9nMdutTWBcACqwCvfY503+AcJ
         9MELMl/CEtYwVKkWTVc0gI9ccPLiefxWj+sW/KHuIhXO2IYGeraEcSKVQKtbBLe/w8+q
         vuPN2TGHabd9vRwIdDa4UmPRifKcvhaxin3rGQkoYVy+10AJtJERPyYs5OINOygikGhZ
         58zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770973381; x=1771578181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aKBMPANl0zC8AGiCOQJvZ+fUUtPvF2idCFAEvWrwChs=;
        b=mnyvh1fs2aXNqb6F4zWxB/GvFyRH/6DthAnpphxh9VS8bR9DCvsHl85boKyagUI7P4
         H43EEbZh8+cywWluwF3DI0rG9wuOFaUdzZyhSzRR5ZHOLZts1GhuQ6p3/NLrYu5M6H7W
         nM7DyzKKcBxEO34VUx4KnRjyg3VVyREfU/64RuPtCmQgnn5JA76WNyV2eX1ye/6+6q2z
         X+NiT8cs7Ad+r7UjQo+ZUdyXsFmWOkewS4Z/xnqK+i4ir/60pWNyppc5AXjOfSMiKP4f
         6HJQfMeAjQI+BWaoVgvTjTAhVi4X2bejwCWsJpyKKL24uCr8dve+x+uzNzgbeMrRIPHf
         YlOg==
X-Forwarded-Encrypted: i=1; AJvYcCXSqj79pstA5xiVACAYl1ZWvA9XF/Vo308mgtMt+qrJH2U2XwR3DeItu12k+YtsJyTENqx3uIy7rQ==@kvack.org
X-Gm-Message-State: AOJu0YyguEHuv3RrC+0Jm6YtCt4dQQKRznDfDyIRk1CCWUQR4w4bxoET
	PubIbdICItNN0McmMKZkfzFQYsSoqNw9jJBOW3de+FujGKqArKUiJPpGEqmdWN+pH3/oJ0Za13I
	o2W0uO3gvgwWeBGs2Zpk979yyS/u7lT8=
X-Gm-Gg: AZuq6aKegTGaEyXc4m/0h0TCh5yNTfYLyL0+7NDlYdjYZjmOLT5ptF5aBXswphyfZxm
	OpZqNGDaNwiyUmex8P4Lc+/DbwM/25V2n0JsQRcWooqX5PKU9TEaUIIRo9pFagkX324yqh7fXqT
	HCXS2TWlE1mFcJtrTr8UWHmnPWAmEFLzpHHVCetKi7lOGu2EmV8Gmz2FlFjEd0zwVKRWmhy02bh
	/MtJwWaqQClZls1fo4+3TnT9Udrhf8BFbSmJT0xGBOodQg8QGWs9p/GVBAZ2FAX6Uz1y5qPOcyI
	ZJfspmDH
X-Received: by 2002:a05:690e:d48:b0:64a:f0cd:d41 with SMTP id
 956f58d0204a3-64c19b7dd38mr544534d50.87.1770973380743; Fri, 13 Feb 2026
 01:03:00 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org> <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <201fcbb4-c43c-406c-ad54-f2c9301c12b0@kernel.org> <CAOptpSN1_4N=e=_e6bVPWjEN2RUXG5=xJouhCaYjjqjLTCi=Rw@mail.gmail.com>
 <c48511be-047c-4ab1-bd49-f2c4899e3cf5@kernel.org>
In-Reply-To: <c48511be-047c-4ab1-bd49-f2c4899e3cf5@kernel.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Fri, 13 Feb 2026 17:02:49 +0800
X-Gm-Features: AZwV_QjmPqmh9315TuUo2mAOGUPeyMxgesQgByTwQp9e01nHNjs-eVDlLfycsp0
Message-ID: <CAOptpSPx8-APDtkrobTWrf10L36dRLdDTeZOwob6t6twmdbQ0g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3BA4180004
X-Stat-Signature: y1mwuc5fk9uwwkre3awcp1q4gtdop8a7
X-Rspam-User: 
X-HE-Tag: 1770973381-257927
X-HE-Meta: U2FsdGVkX1+GmLuN7nOnbvznkT+SIkc50LibiwuyEi74PNfSH8aSJgUcRpxeXn2r8kk1wC3sGFCNGo6Lnbv6Yth89Q2AbkluX0BntCr7TBsa0hXSdEvwOwSH/OYLU9/Ygv/v2hXbKMD4qqMgOqfAMAJLCTYebscaZ19G20W/JzdUIxDWEJR1jyXOaIPu/dL5nn5g1o1U5+YcUgohLci4oO7FpD324nngJVQA5dL7293bwCU8GW9TMXqhhhqyN+xwNcElVFgSEI0K6mxbzjtX99rKRfnRntY8lv04OcPDNGhcNaEtuIwQ91mYuNbZZjAu7v0MiloOx1+emeeRArPzdB0u0BA8dwMDbAhtXrLyogOtUp+Z5/C2OxsMy7MPCC/nyIvMV3dYIMocTN1OI6j7/1dj1fvULC0Lw30f+lvGkU7ArqHdkjOiJoqYWcDrlg44YU1EEUT2gc2kKilsLTK3XjiSZ7PLFN+RwLv41ddDZaciLg5LN42JBARvwpa3Euvh7i8zwXq9C85KdmpnSNaaTNWOR+fyFZU3vJJhXxcLRfis1vbTdUBOu4fdbt3hy3y9lleBlRnfdOC+9fkTy81TQlpCYcJwOaEkgn5AvQJhK3AmMApHIuOvUjfqSCsR9af9GiX4ScceS9B91BR9PVJov/G40wSprEBcIdwZFN0BYJpMSSglQ31nDH71aZyaZ3fSikqcIIWEbfLrb5ck/2abmHfAvjHr3l3K1/6uJIdwhOQxEWevsvtNU+k6oxYFXL3E5lzbrrX6LjxmPd/K4PCZxeamCkjX+wt4IbDwCAItfUnxT4pNH/aqxiB+v/24/6GiZg3CakTUc6HTmzPXjaIsCwtQhRHj0uJ2WJGiKf0jyG+ur5pf1YtcECppQCuw2ZeZfBUi6qwAA5oPV+PkMMbcw8OE6n3qP8medUklLGNq/1q5X3+/ZsYMEQ8d5vasvh8f8j87JiXMQlbq6HUrPTB
 7UqFCA0c
 BjVnu7XgejUWgG0rdT4iEB2QsrVgQLQJ3qWznYs+pmxRwC7gsuLtgk21SGQW+hDIi+47wAZU9SsKT3QMKQ3d+0yqpD0Yye8q0XnXgG/A5d+cr/oL5Eqxm4Ch766f2D4tJDJcLdGadRh172ut4lUu3L/UTN1FoyrjKAoKvl0wNQ37lZDTPPSKGQkDPZdaYTvosJlfM9MRt/+/6T9vRclYZlpXmJ/6PrChKDzzJtA7OY76ll2AQ4Bas3LcA6Ix6lZ79nmTCKmuxa1wefwUzFlTpeYf6O0fcTg84Cpkwqrj16A9O/3fhgrM5KpDiSUyqO/3R6oIVjQLC3P49vRiu/FI3GBW6CLy4woGgSD3L2PdF+f+4CXwPOx1/1EwsOHyZTsoHyKIi4BRlTVijDbJ18x6Ap8GZo1uv88Z37q1zHPsS1dquGOpLsm844Xl58MKQb9cYmyyNu3rkE25CDZFLVbnK/gzPmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 4:54=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/12/26 02:57, Wenchao Hao wrote:
> > On Wed, Feb 11, 2026 at 5:05=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 2/11/26 01:49, Wenchao Hao wrote:
> >>> On Tue, Feb 10, 2026 at 5:07=E2=80=AFPM David Hildenbrand (Arm)
> >>> <david@kernel.org> wrote:
> >>>
> >>> We have enabled 64KB large folios on Android devices, which may intro=
duce
> >>> some memory waste. I want to figure out the proportion of memory wast=
e
> >>> caused by large folios. Reading the "Referenced" field from /proc/pid=
/smaps
> >>> is a relatively low-cost method.
> >>
> >> Right. And that imprecision is to be expected when you opt-in into
> >> something that manages memory in other granularity and only has a sing=
le
> >> a/d bit: a large folio.
> >>
> >> Sure, individual PTEs *might* have independent a/d bits, but the
> >> underlying thing (folio) has only a single one. And optimizations that
> >> build on top (pte coalescing) reuse that principle that having a singl=
e
> >> logical a/d bit is fine.
> >>
> >>>
> >>> Additionally, considering future hot/cold page identification, we aim=
 to
> >>> detect 64KB large folios where some pages are actually unaccessed and=
 split
> >>> them into normal pages to avoid memory waste.
> >>>
> >>> However, the current large folio implementation sets the access bit f=
or all
> >>> page table entries (PTEs) of the large folio in the do_anonymous_page
> >>> function, making it hard to distinguish whether pre-allocated pages w=
ere
> >>> truly accessed.
> >>
> >> The deferred shrinker uses a much simpler mechanism: if the page conte=
nt
> >> is zero, likely it was over-allocated and never used later.
> >>
> >> It's not completely lightweight (scan pages for 0 content), but is
> >> reliable, independent of the mapping type (PMD, cont-pte, whatever) an=
d
> >> independent of any access/dirty bits, leaving performance unharmed.
> >>
> >> When you say "I want to figure out the proportion of memory waste", ar=
e
> >> we talking about a debug feature?
> >>
> >
> > Thanks for your explanation. I now understand the design logic.
> >
> > What I=E2=80=99m proposing is mainly for debugging. After enabling 64K =
large folio
> > on Android, we observed increased application memory footprint, especia=
lly
> > for anonymous pages.
> >
> > Since Android app memory usage depends on runtime scenarios, we cannot
> > confirm if the growth is directly caused by large folio. We want to
> > analyze memory
> > usage via the `Referenced` field in `/proc/[pid]/smaps`.
>
> Scanning for zero-filled pages will be much easier and more reliable.
> For a debug feature good enough.
>
> I'm wondering what the best interface for something like that could be:
> we don't want to make "/proc/[pid]/smaps" slower for all users.
>
> Maybe we could for debug kernels.
>
> For example, adding with CONFIG_DEBUG_KERNEL a new entry
>
>         Anon_Zero:
>
> counter that just tests whether the page content of an anonymous page is
> all zeroes could be doable.
>

Apologies for the delayed reply =E2=80=93 I was just writing a demo to veri=
fy the
approach you mentioned.

Using the CONFIG_DEBUG_KERNEL compile-time macro to isolate this feature
is indeed an excellent idea.

However, in engineering practice, it requires recompiling and
replacing the kernel,
which can be cumbersome. Could we instead use a dynamic switch to control
whether scan for zero-filled pages when reading /proc/[pid]/smaps?

> --
> Cheers,
>
> David

