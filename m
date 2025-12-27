Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5B5E8FDD3
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 08:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 716056B0005; Sat, 27 Dec 2025 03:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C3FA6B0089; Sat, 27 Dec 2025 03:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF1F6B008A; Sat, 27 Dec 2025 03:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A0A96B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 03:16:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E815161994
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 08:16:49 +0000 (UTC)
X-FDA: 84264544938.13.1DEBD30
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4BE0DA0009
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 08:16:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lleJVezX;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766823408; a=rsa-sha256;
	cv=none;
	b=aGyX0Snu26VJ3G0eWoTFV6sKGGxyj2E9EbEf/wPZpJyvj1mucQGoOmuIKwaxGKGyQfsrdi
	Gg4oyW5XBZCKyR3SRBdQtiNuP2QbfQz096G6DJqhLMEFUsltyjvOgm/uomDdqSrwd/R4Mb
	QdFvqvT5OxwXn0dmwgz0HRRNkgl5UOs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lleJVezX;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766823408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OK02JPWmF4Xcr1xz17f0O1VtdoiTJoYLRGTfGQPqmw0=;
	b=GMoXH1ueIY45SmLUDje6qQ3WYvhwcGaWIHKVUKSwJzq1/DbbjwEIicPxTBvVxX9NmUtWJR
	3cZ8jwbI+bXr0VCReOhVandIhxRSVHwtHvonbia1ljLi+ZEGfCSoTdkL4IifAJgUuP1ZSU
	L2MHrJ2j1qBe4nNOBZd88nm1Uck9YBo=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88fca7bce90so71895726d6.3
        for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766823407; x=1767428207; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OK02JPWmF4Xcr1xz17f0O1VtdoiTJoYLRGTfGQPqmw0=;
        b=lleJVezXZXLYFEB6wTx1uagjjA8kJrAT0QF2X93v70PiaR/jMh58xn0kXQffT06Loi
         77EqC0xIOqQDe+qIh7zOHnYim19+DpulXgr/gy89cR78ZY1ifnQii1qUu8nhmpLj7tgM
         eR05L6L8qP9WqI7dswyPwt8fVAWxw1Iq4zeesre0P73dhBpqyuDt4uQbJIiwwDEgCaR1
         FOaEqiPmUJgceGfSzEcUCsd23f6p7lxNVFYC/lKX/PzV7pbimfYC1qGkEaOipxtG1CQP
         x2SDpY4jhCh6C0vUgfh2cFNJ6an3sbf70yl7c6kKVViX33wyVP/ONGgEqdAAzMpbmhyg
         5heg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766823407; x=1767428207;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OK02JPWmF4Xcr1xz17f0O1VtdoiTJoYLRGTfGQPqmw0=;
        b=vTVZmV0+K4IpKcx0gKtg12DWQUYfLq6csZqmwwQQxgwCfVCVsVKzBq8Bjpr/ik/7OL
         1pLwe5wq5I2LuyLz1Uk5uTUfEv+H/fzmvqNkoI1IxEYszE4EUyt9pQnUYdMc/U6Bs6mM
         RxeUsbz7s1O2IwGrGlje76zsgfOpjE3GUnQ4wi6SXkFtfF1t9ITKlBHltaFqxMkzfihD
         R/AvXolJ3mFvHNoNUSK3fqeiSccCqJ99/um2i1/Qql0tYfIOJcGr70Jz3iWgx1U4+mYj
         29Ufvg8LlsHoGFwwCTn23AILjqN2Zrcm2Zr3o5R1dLWH7jV9Mz6V0vv3J4btlQr2KUWI
         Ydtw==
X-Forwarded-Encrypted: i=1; AJvYcCWOaCWZB1RqhP9/liFEEiwnFG2ArtJaHiljRbYIWLwc3NRCGnJt6vz9bjnw9jipi1/SzvsfJbgxVw==@kvack.org
X-Gm-Message-State: AOJu0Yyjm0H55EhNl/e0iXMcOwQowffU1Ob28/FnQCiUEEMgDylPJ4oS
	FH4ssXxvHWAeTn7U0zP5jskhFF80x733drMQ6DoHSyTW8cGJ5ujt0zq9Ja9YGwdVjjed8HvBcpN
	fVSMYseOysfZCcpbLyv6gsTSeJ2/rz6g=
X-Gm-Gg: AY/fxX6cpqjC4GJwE5v46iELB7I/AU8VqZw+gPYCRcs/5MHAxKMdMS8Oz5dJnwfgQ9T
	8gX/pOWA8hRDj1xJuVHjF+6if2332SYwqU6lxvfLoUapw+NJgF/IJXVPxC+8IACmKw2rH2DtgEO
	ZFvv6WRNwOQ0hcgIBFbeYZDdTtJ4kcARzJytrnVxk+7u6X45q+LrGcEfaGTf1JjtoAe1clHZ6/x
	HqBQzyNnKJIcI1aQvzFoboWrKougkyGhmYMouAvh5+/5fexkjAy8UYuCLICj+/Ez6+R5w==
X-Google-Smtp-Source: AGHT+IFSrgSym1rnglnte/lsAfmlIjwpwZZfLxsxVjIcjgIk5F5m1HV8VsU0cJQi1WFOHrrJxovcQ58dRTOjz3ub+f0=
X-Received: by 2002:a05:6214:4685:b0:87d:fde1:f88b with SMTP id
 6a1803df08f44-88d8203ebe8mr358062286d6.4.1766823407194; Sat, 27 Dec 2025
 00:16:47 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com>
 <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com> <CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com>
In-Reply-To: <CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 27 Dec 2025 21:16:35 +1300
X-Gm-Features: AQt7F2oSHiJRDPiLImFFk9g-R7wiLTLG5-i_kMBgLI-_jL3pTLw5rWPDYRjsC-c
Message-ID: <CAGsJ_4zg_DgQnQthTqWOnwUrhm-MygVB6mOwmgK=ey2dYogb+Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: wale zhang <wale.zhang.ftd@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4BE0DA0009
X-Rspamd-Server: rspam04
X-Stat-Signature: h8czuooujha3zt91njnbjiyow6f6rdma
X-HE-Tag: 1766823408-462320
X-HE-Meta: U2FsdGVkX1/XEtJyfrNer4yvnuGDG8hfV42dq6I+/8y42iGQgXZgSYR6SbXwjs/pJhSVg9LglfdxlktNLxW+uT+TWkFL/Lrm0+I1AhF97jRx2KSE9Wkj0AnW0ggb6wlouAGio2s/80jciMH2Fvpb6gVKq4LYN8HsN4GzXKRFfe5wuJ9Gomcov1Mka5rjc3VFzdrNUqxTixdFXQmFxt8nUryAQOVpHV9je44ZsyQRqB6TEvPLa5O+9DBbXNVNQS/s2Byh2I9hcs10wQtw8+9JVoqt93nUOXelcEbG63BZ7WEQjWGC9yzKRBIwcTv2PDSkKYDZg+Zv0oEHrsILnAfyif3LKoKAsCkwEnGbPwKOyKYu3N7BJd3MyWBrHXbew27+U2PhUvET0R4BkPHhBlmzS2R7BVLAc65XNAN12lcLRSJ7DtMWaOnerGYZP6SISb08a2qnXMokWCZSjJ49k+Nrtq3wYRHfTvODbhq+AWszJbK6uZOZ92+PGb6tRHIVjSrkxlPzRsyh8ieOoJZbQtwQq6TUfM2PJ7oKYwWgNrklEiM6GEqw55TFAINUrvAdFg94dHo+Hb88IUsjaQg706+uVKyM5/R8JAB0kYVGoe7P8hD+e90fIOJws7gaPbJBt+ANWCGROjvvGru+qWpA3lH8aP71j6qnTL5u7jj8JgazyvfL6g3MVu+8o7aPVJkzGFO4fYAtMrixWSaXg9lmFd+P9qXhrvGmIXaXJYpfaPKhmH/cXg/ftUI0Q01Ni25lVDwD9Gz24hM5xw+QMlUe25MYBsnIp5lqmtD0HYA48pW/BJB+omWBz5oZT+ucGtvLbhsFRP6cry7v7iK4bLroMp4yXyHtfmquqIBxlEaH94LMCnUGFBouRQybnPHSGu1o2IATV8cCIzI/k4cL2jR0aY4HS0BfOUcpfN09D8h5LQJOyQ0103lnMP+g9FfYonOpvz7nADGV5F5yLCQomVHk0Wh
 xKETGzBc
 TpS40GKr5czefqqn0ihEmXSA6k9z4E0uohygelwvig7Y9SqkJxvJht8im/FmlUrAGLDUzQHGW5XhbmIRV7QerIYfqYxI0DS6oZwEtjBQMSD2jqBBrzGO67WztHxdm2UsO4V87
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 8:51=E2=80=AFPM wale zhang <wale.zhang.ftd@gmail.co=
m> wrote:
>
> On Sat, Dec 27, 2025 at 2:43=E2=80=AFAM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd@gma=
il.com> wrote:
> > >
> > > On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.com=
> wrote:
> > > >
> > > > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.ftd=
@gmail.com> wrote:
> > > > >
> > > > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migratio=
n_entry=E2=80=99:
> > > > > ../include/linux/swapops.h:346:1: error: no return statement in f=
unction returning non-void [-Werror=3Dreturn-type]
> > > > >   346 | }
> > > > >       | ^
> > > > > cc1: some warnings being treated as errors
> > > > >
> > > > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > > >
> > > > Sorry. NAK.
> > > >
> > > > This looks odd. We already have a BUILD_BUG(), so no fix is needed.
> > > >
> > > > we should already have:
> > > > ././include/linux/compiler_types.h:631:45: error: call to
> > > > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribute =
error: BUILD_BUG
> > > > failed
> > > >   631 |         _compiletime_assert(condition, msg,
> > > > __compiletime_assert_, __COUNTER__)
> > > >       |                                             ^
> > > > ././include/linux/compiler_types.h:612:25: note: in definition of
> > > > macro =E2=80=98__compiletime_assert=E2=80=99
> > > >   612 |                         prefix ## suffix();
> > > >          \
> > > >       |                         ^~~~~~
> > > >
> > > > Do you actually see this being built? If so, please help identify w=
hy it
> > > > gets built.
> > >
> > > Hello Barry,
> > >
> > > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log wil=
l appear.
> > > In file included from /home/wale/repo/linux/master/include/linux/leaf=
ops.h:11,
> > >                  from
> > > /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
> > >                  from /home/wale/repo/linux/master/include/linux/mm_i=
nline.h:10,
> > >                  from /home/wale/repo/linux/master/mm/internal.h:13,
> > >                  from /home/wale/repo/linux/master/mm/fadvise.c:24:
> > > /home/wale/repo/linux/master/include/linux/swapops.h: In function
> > > =E2=80=98set_pmd_migration_entry=E2=80=99:
> > > /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: no
> > > return statement in function returning non-void [-Werror=3Dreturn-typ=
e]
> > >   346 | }
> > >       | ^
> > > cc1: some warnings being treated as errors
> > > make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:287=
:
> > > mm/fadvise.o] Error 1
> > > make[4]: *** Waiting for unfinished jobs....
> > >
> > > There is an example on my
> > > github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
> > > used -O0 to compile the 6.12 kernel. If you're interested, you can
> > > check them out.
> >
> > This is not my question. The BUILD_BUG here means this code
> > should never be built. If it is built, then that indicates a bug.
> > So my question is: under what kernel configuration would this
> > code actually get built?
>
> Hello Barry,
>
> I'm very sorry for misunderstanding your meaning.

No. You still don=E2=80=99t understand my point. The BUILD_BUG means this
code will never have a chance to be compiled under any possible
kernel configuration. That makes it dead code. If there is any
kernel .config in which it can be built, then we should fix it.

This set_pmd_migration_entry() has no chance of ever being built.

let me give you an example:
#if 0
aaa;
#endif

main()
{

}

Imagine this set_pmd_migration_entry() as aaa.

>
> For -O0, __OPTIMIZE__ isn't defined, so line 615 is hit.
>
> 595 #ifdef __OPTIMIZE__
> 602 # define __compiletime_assert(condition, msg, prefix, suffix)        =
   \
> 612                         prefix ## suffix();
> 614 #else
> 615 # define __compiletime_assert(condition, msg, prefix, suffix)
> ((void)(condition))
> 616 #endif
>
> Finally, set_pmd_migration_entry is defined as follow:
> static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pv=
mw,
>                 struct page *page)
> {
> -        BUILD_BUG();
> +        ((void)(0));
> }
>

Thanks
Barry

