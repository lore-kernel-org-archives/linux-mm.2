Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589F1E8FDD6
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 09:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2150C6B0005; Sat, 27 Dec 2025 04:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C05C6B0089; Sat, 27 Dec 2025 04:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC996B008A; Sat, 27 Dec 2025 04:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F04636B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 04:58:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 78640141027
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 09:58:55 +0000 (UTC)
X-FDA: 84264802230.20.142118F
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7826D100007
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 09:58:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cj4CEbiO;
	spf=pass (imf05.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766829533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NWEx39fk6NpezbdN1uFl/Pl0vtKNEtwV+K/UwJqzr2Q=;
	b=ZO3nBjNV6EhzjT5RIYS3UYjhB8Ux/jum0Ai7AhP0mWYEM3xtdcXVxtiG/EwHdh3HSjdQW9
	wIDLaa2lKngJ5mxp9lRT7MYF6tMkJly6RPjIvWjyps7OYjSEBhnodztSeDqsNFkJIXMW97
	rhmBQWIs0cNdGBqbyf5FmoVPcuJbuAc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cj4CEbiO;
	spf=pass (imf05.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766829533; a=rsa-sha256;
	cv=none;
	b=y1+TFQFejxpT2Q6kv8q6MeQ9nlWwQQtGWC3lkRxTB3uvOXRfbEBAZ9GRqJ87tOXBl7cXYX
	4wVJLF/nVjXLFpWFoGjX0IX7zB68C1drFWLl6ZH7Tfav8nEhRQ4HNTe57EA5uh8ueDGwiG
	3rGpIC2BgYl/8k5i3qSP2JZCHidmBmM=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b7633027cb2so1401459266b.1
        for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766829532; x=1767434332; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWEx39fk6NpezbdN1uFl/Pl0vtKNEtwV+K/UwJqzr2Q=;
        b=Cj4CEbiOplWNXcT5fC8IYGfeMKshywBBxJC2r3rChkWMrmpb5AUnqtTPVKdeLbF4nL
         8LooPCEzC/LH7WeS+0Y24pX4MK10rAirCGFxj7ugn1rqVi4Xsgdz7Uh+PEMdZ96DOX8l
         1dBsF1pDYpsZepcMy1XRf2eMMLHTE2UiOvT804103vie0BHeEPyHMK5kuA9mnnpnRpj4
         rCaqOKCGfU3ag288Szxe+luw2azbvO5rz02bXKqh5YN385hwx5Go8x9qXmpdAN/BG9QF
         i2Tg8x8MwyxF9Ii8yB64pmLiXEaTZ9YyYfocLm8/UU2qnDQBVQ1X9XRkXl8jil7dmrJq
         BSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766829532; x=1767434332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NWEx39fk6NpezbdN1uFl/Pl0vtKNEtwV+K/UwJqzr2Q=;
        b=e9eRx0R8oU9gX7Na3gzpPceHQ6b6PKfMWWIhJXsJlWvIvxOE51DC/KbM9k5W+/JELn
         xXldaTjYDtBnjtbpTJK2k2kHPTj3ClNhtRRK9H+CcuFd3QUKjUqUusFz1PyOPAR/LfEf
         d58NO10LV4k89ELNnAw3VoFwAvbfoZHD/9kY8145Au8nwuG2QhsRb69XLcAF0EyvSlLy
         5AfmG1G+SipRSL43gXrkMHTZc7uE5OPSvN4icwBVRUPYgmkFCQ+1WlUtkUcblB/gJadH
         Hjmy44+QpcxCl2C4pg2Px0/BkNFNjPydOTUh6EhUtqISW6gXLY9hLf2gVu7nrZZmWRwA
         sKFw==
X-Forwarded-Encrypted: i=1; AJvYcCW67Zk3bhsXDz46JpwmUe8mVhJpzRLzPyHNnPG7yvBjOxhs9Oi7wPZldMlUuDUnzpzMEExcoa4Axg==@kvack.org
X-Gm-Message-State: AOJu0YwDddd+YPZbGmNCy6ewwp1RjHSbQApBODEYTFngylmKn6X0keSw
	ijrdsGXIfaapI4l1goTcfn8fWV2s3QxhqGk+MNPx6qwEXtW9QvTqUQynqR6ZaQUFA42/JW+G7eO
	/BmIyj0ZX2wFd2qBqK+clu1ZRQj1TsXk=
X-Gm-Gg: AY/fxX4ACwUcOUGjfMP2AbK7KyrP3LbM3QL5FLMynGM7cPV6bySc+8QjEOkMHrp0zcs
	C+4XLx6EUs4S4X2tk+hyhOlD0JusjbwVOxk44jmjWCEO1NEl6RoTz9Ctg14E6VDd1J2LYSiG1Cd
	PKBlILtF+8Yp77dpONf+fR94ZKCuFI2dp5cQ/9VmRGU391Xlm4mVkn7rEQC4Vr2bvjEWqyweKCd
	NUPgOnkd5P5/TLb3gnoQYxcLbt92SFuDEHpVzPj69todxWkkv1lDWsm7T3Eq/gxizVlF2qL
X-Google-Smtp-Source: AGHT+IE+75sjqa/hKdqbX2hsQ60DeDtU35ejGPkY40oXBhOqkaqTSm3McoaehjCSv2SSVI+KVwkYe0m5RgbetxQuH/4=
X-Received: by 2002:a17:907:a4b:b0:b73:210a:44e with SMTP id
 a640c23a62f3a-b803717902bmr2791418866b.30.1766829531426; Sat, 27 Dec 2025
 01:58:51 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
 <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
 <CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com> <CAGsJ_4zg_DgQnQthTqWOnwUrhm-MygVB6mOwmgK=ey2dYogb+Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4zg_DgQnQthTqWOnwUrhm-MygVB6mOwmgK=ey2dYogb+Q@mail.gmail.com>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Sat, 27 Dec 2025 17:58:40 +0800
X-Gm-Features: AQt7F2rahho5OI5wAKjXgh2lzhCt_j-hnIG_G_u0Z-FBwDJwj4uMMlocEMiVCw0
Message-ID: <CAHrEdeuRtROkAN0zNdaYG_GBkSeW=-3kP3xBiQV1w51vGSc6Ew@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7826D100007
X-Stat-Signature: uyqkok67fmeya9btifx31ecreozqkuh4
X-HE-Tag: 1766829533-45643
X-HE-Meta: U2FsdGVkX19aYMkmOCyv1uGjovt0BO6tlpmA1JMfyUQgCDrx2FHaNHrM1Q6LfdgQXtjohC7CLm+oIG4AUBRHPvoo5FrFUaCFZgEwlmv/e9M7xHxS08TCjLIrt//MnIyoNoyEyaIBoeTBt72LU/QTEC5ZgNPI9Qf+RBfKFgp1tZhpt9C8yDTr/U2M1mNUNMba7Bxv66lQq7mspF5X6vnZPdDPALiOKaMuVIaJx8xa2XS23B6bbg+7OLiCUlbK4aApadVr5DfpKE59nslfOV7HVT8hgVm79Iwd5RrByFRFwHuyE+T+r9ULES6gVwqm45+n4fA1dRrvSam5kbJfMeuYxjBvVMCTkBBiHW+I3J/tyLWS/ZY1cyjT/bpF0WY3Gqjp/BZrRkLUq6p3SAtIYs+GBmdPuqpIdaWufCyzWf8UIwPeVZ+wuF2A47EMAM2/wKHG+p+isRX6aVhQYsDjAz5EToa5xv2/5KaLaWi0525srsGvd4fFDdTNIo8qji0Wb8BIpkx/K3B3EW7m4+nSHJPpJ7TUQGoQFCQ33kBiMPu4FQXMn5NusGuZx1j4WGf4XTf4VF8rIqijA4LF9DmxowpVcebGMsEYjzEBUNc2BDhaFtaLFxwZf7XlpTXMbSXxPrM1YRoDM+E0N3sDDmaCJ9W4mb8OKfEr0YhdzmWfwlA21gZZIpsMkCDlqbpcCXT0NSjF3oWVfCrycpz0ue9ixzAYaHXZ+hGz43Zp4i0ozld+IKjzykPJKoxxYy7/WNaZQOz/JMQ39dTBMrNbZNXDKF0uuB10Xu3WWJun4CJnKRPLB+krNXvvUMJuOHAD8jsr1hrAdOpUe5yNWVWL6/Pa6dWcS+uj4hpW13xRLreKhqMw/vaiyLmAbbzxyX74iBEUgmE0V0NiONoPQRkoLGhFFDVINzbBnmxhKxGdmyIEgVYXYttdkNgm7csT+9Z9U+sAm3KnUzXGugE8D6BURMDDrFC
 Oo/DGHdG
 CRdCAAYJhgxmPWEZ2CGZ9qRjyf0UcjOQ/qt2hEwFRZ8X6HN8w6Sz7LdXUAPmSiiamIZlLby4fy0scqz27y5ii8uItP6O5jhbEWHDtrVZYMnnE9RcRCpGZiyen4CGRYDHQRrLnCUp+ahECcmZSxScaaEo1ON8D80SdVzghtKY5XY/Zqfa7Gz+WfRZcRApd5ACxQu7lxrpHfQXLXcX/YQe9ghj5DqmIw3vBWPTuuCFlxsr99clju+iyeP09uhf9+2+iGl7hWr1CBC6PwrvOm0G4477IIdqLr6F2HNCdP0PCrZ0DBFsanOh6ZfjfedxJBeHtwgrIlR4I8ghwQVMPSNrixZKU7NyItzWe3JCZAiYYYp/wSxu5wHyxN26g1p0/XeFVqSwOFsYf2dBqiwC8cIgcUmZflx77HOCFtJz+PkkM1rJpfnj0diVZZImm5Wn5e8eb8JoIN3bCxc9ABEoZCK7GvzjDvXw9yrFXYDJU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 4:16=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sat, Dec 27, 2025 at 8:51=E2=80=AFPM wale zhang <wale.zhang.ftd@gmail.=
com> wrote:
> >
> > On Sat, Dec 27, 2025 at 2:43=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd@g=
mail.com> wrote:
> > > >
> > > > On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.c=
om> wrote:
> > > > >
> > > > > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.f=
td@gmail.com> wrote:
> > > > > >
> > > > > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migrat=
ion_entry=E2=80=99:
> > > > > > ../include/linux/swapops.h:346:1: error: no return statement in=
 function returning non-void [-Werror=3Dreturn-type]
> > > > > >   346 | }
> > > > > >       | ^
> > > > > > cc1: some warnings being treated as errors
> > > > > >
> > > > > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > > > >
> > > > > Sorry. NAK.
> > > > >
> > > > > This looks odd. We already have a BUILD_BUG(), so no fix is neede=
d.
> > > > >
> > > > > we should already have:
> > > > > ././include/linux/compiler_types.h:631:45: error: call to
> > > > > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribut=
e error: BUILD_BUG
> > > > > failed
> > > > >   631 |         _compiletime_assert(condition, msg,
> > > > > __compiletime_assert_, __COUNTER__)
> > > > >       |                                             ^
> > > > > ././include/linux/compiler_types.h:612:25: note: in definition of
> > > > > macro =E2=80=98__compiletime_assert=E2=80=99
> > > > >   612 |                         prefix ## suffix();
> > > > >          \
> > > > >       |                         ^~~~~~
> > > > >
> > > > > Do you actually see this being built? If so, please help identify=
 why it
> > > > > gets built.
> > > >
> > > > Hello Barry,
> > > >
> > > > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log w=
ill appear.
> > > > In file included from /home/wale/repo/linux/master/include/linux/le=
afops.h:11,
> > > >                  from
> > > > /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
> > > >                  from /home/wale/repo/linux/master/include/linux/mm=
_inline.h:10,
> > > >                  from /home/wale/repo/linux/master/mm/internal.h:13=
,
> > > >                  from /home/wale/repo/linux/master/mm/fadvise.c:24:
> > > > /home/wale/repo/linux/master/include/linux/swapops.h: In function
> > > > =E2=80=98set_pmd_migration_entry=E2=80=99:
> > > > /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: =
no
> > > > return statement in function returning non-void [-Werror=3Dreturn-t=
ype]
> > > >   346 | }
> > > >       | ^
> > > > cc1: some warnings being treated as errors
> > > > make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:2=
87:
> > > > mm/fadvise.o] Error 1
> > > > make[4]: *** Waiting for unfinished jobs....
> > > >
> > > > There is an example on my
> > > > github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
> > > > used -O0 to compile the 6.12 kernel. If you're interested, you can
> > > > check them out.
> > >
> > > This is not my question. The BUILD_BUG here means this code
> > > should never be built. If it is built, then that indicates a bug.
> > > So my question is: under what kernel configuration would this
> > > code actually get built?
> >
> > Hello Barry,
> >
> > I'm very sorry for misunderstanding your meaning.
>
> No. You still don=E2=80=99t understand my point. The BUILD_BUG means this
> code will never have a chance to be compiled under any possible
> kernel configuration. That makes it dead code. If there is any
> kernel .config in which it can be built, then we should fix it.
>
> This set_pmd_migration_entry() has no chance of ever being built.

Hello Barry,

set_pmd_migration_entry() is defined in include/linux/swapops.h.
For not defining CONFIG_ARCH_ENABLE_THP_MIGRATION, line 342~346 will
be built as long as *.c file includes swapops.h.
There are many .c files including the header file directly or
indirectly, such as fadvise.c, shm.c ...

include/linux/swapops.h
324 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
325 extern int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw,
326                 struct page *page);
341 #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
342 static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *=
pvmw,
343                 struct page *page)
344 {
345         BUILD_BUG();
346 }

>
> let me give you an example:
> #if 0
> aaa;
> #endif
>
> main()
> {
>
> }
>
> Imagine this set_pmd_migration_entry() as aaa.
>
> >
> > For -O0, __OPTIMIZE__ isn't defined, so line 615 is hit.
> >
> > 595 #ifdef __OPTIMIZE__
> > 602 # define __compiletime_assert(condition, msg, prefix, suffix)      =
     \
> > 612                         prefix ## suffix();
> > 614 #else
> > 615 # define __compiletime_assert(condition, msg, prefix, suffix)
> > ((void)(condition))
> > 616 #endif
> >
> > Finally, set_pmd_migration_entry is defined as follow:
> > static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *=
pvmw,
> >                 struct page *page)
> > {
> > -        BUILD_BUG();
> > +        ((void)(0));
> > }
> >
>
> Thanks
> Barry

--
Thanks
Wale

On Sat, Dec 27, 2025 at 4:16=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sat, Dec 27, 2025 at 8:51=E2=80=AFPM wale zhang <wale.zhang.ftd@gmail.=
com> wrote:
> >
> > On Sat, Dec 27, 2025 at 2:43=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd@g=
mail.com> wrote:
> > > >
> > > > On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.c=
om> wrote:
> > > > >
> > > > > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.f=
td@gmail.com> wrote:
> > > > > >
> > > > > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migrat=
ion_entry=E2=80=99:
> > > > > > ../include/linux/swapops.h:346:1: error: no return statement in=
 function returning non-void [-Werror=3Dreturn-type]
> > > > > >   346 | }
> > > > > >       | ^
> > > > > > cc1: some warnings being treated as errors
> > > > > >
> > > > > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > > > >
> > > > > Sorry. NAK.
> > > > >
> > > > > This looks odd. We already have a BUILD_BUG(), so no fix is neede=
d.
> > > > >
> > > > > we should already have:
> > > > > ././include/linux/compiler_types.h:631:45: error: call to
> > > > > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribut=
e error: BUILD_BUG
> > > > > failed
> > > > >   631 |         _compiletime_assert(condition, msg,
> > > > > __compiletime_assert_, __COUNTER__)
> > > > >       |                                             ^
> > > > > ././include/linux/compiler_types.h:612:25: note: in definition of
> > > > > macro =E2=80=98__compiletime_assert=E2=80=99
> > > > >   612 |                         prefix ## suffix();
> > > > >          \
> > > > >       |                         ^~~~~~
> > > > >
> > > > > Do you actually see this being built? If so, please help identify=
 why it
> > > > > gets built.
> > > >
> > > > Hello Barry,
> > > >
> > > > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log w=
ill appear.
> > > > In file included from /home/wale/repo/linux/master/include/linux/le=
afops.h:11,
> > > >                  from
> > > > /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
> > > >                  from /home/wale/repo/linux/master/include/linux/mm=
_inline.h:10,
> > > >                  from /home/wale/repo/linux/master/mm/internal.h:13=
,
> > > >                  from /home/wale/repo/linux/master/mm/fadvise.c:24:
> > > > /home/wale/repo/linux/master/include/linux/swapops.h: In function
> > > > =E2=80=98set_pmd_migration_entry=E2=80=99:
> > > > /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: =
no
> > > > return statement in function returning non-void [-Werror=3Dreturn-t=
ype]
> > > >   346 | }
> > > >       | ^
> > > > cc1: some warnings being treated as errors
> > > > make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:2=
87:
> > > > mm/fadvise.o] Error 1
> > > > make[4]: *** Waiting for unfinished jobs....
> > > >
> > > > There is an example on my
> > > > github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
> > > > used -O0 to compile the 6.12 kernel. If you're interested, you can
> > > > check them out.
> > >
> > > This is not my question. The BUILD_BUG here means this code
> > > should never be built. If it is built, then that indicates a bug.
> > > So my question is: under what kernel configuration would this
> > > code actually get built?
> >
> > Hello Barry,
> >
> > I'm very sorry for misunderstanding your meaning.
>
> No. You still don=E2=80=99t understand my point. The BUILD_BUG means this
> code will never have a chance to be compiled under any possible
> kernel configuration. That makes it dead code. If there is any
> kernel .config in which it can be built, then we should fix it.
>
> This set_pmd_migration_entry() has no chance of ever being built.
>
> let me give you an example:
> #if 0
> aaa;
> #endif
>
> main()
> {
>
> }
>
> Imagine this set_pmd_migration_entry() as aaa.
>
> >
> > For -O0, __OPTIMIZE__ isn't defined, so line 615 is hit.
> >
> > 595 #ifdef __OPTIMIZE__
> > 602 # define __compiletime_assert(condition, msg, prefix, suffix)      =
     \
> > 612                         prefix ## suffix();
> > 614 #else
> > 615 # define __compiletime_assert(condition, msg, prefix, suffix)
> > ((void)(condition))
> > 616 #endif
> >
> > Finally, set_pmd_migration_entry is defined as follow:
> > static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *=
pvmw,
> >                 struct page *page)
> > {
> > -        BUILD_BUG();
> > +        ((void)(0));
> > }
> >
>
> Thanks
> Barry

