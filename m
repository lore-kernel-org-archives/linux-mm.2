Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5744E8FDC2
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 07:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D830E6B0005; Sat, 27 Dec 2025 02:51:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27016B0089; Sat, 27 Dec 2025 02:51:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12596B008A; Sat, 27 Dec 2025 02:51:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2B2E6B0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 02:51:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AEF8161039
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:51:19 +0000 (UTC)
X-FDA: 84264480678.10.73374EB
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 664C740009
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 07:51:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhcSfjwH;
	spf=pass (imf07.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766821877; a=rsa-sha256;
	cv=none;
	b=k261mQJ5Or8USa+hetID/wfUnAwRp86X7e57FRZSe9cJSDoy11fC8tY6S6oe5v7uwYT39P
	yLGQtWxm4b86hVOQ0Ekfc2EQZnkIG+b+3s1UiD6M7olY2NfgS+/5atmBAIWg2Q6c+Hf5Sm
	pm5AYrnDLcZBPNgtiUwYHGLpzOUq43o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nhcSfjwH;
	spf=pass (imf07.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766821877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYDj1XIu1EL2KFzKtBsB87Y5oK9ucq0vxjMNijLNu58=;
	b=uqmrlS5FM6VuOcv7Y73WwrBksClXu1IDImW64EBUI56CC0HJELvOPxrF2OFbV1qOH5uRZ0
	lNk95gMPqDPx6diGIop1RnU0eWAdTiO6G0dgPGdf57MIKGcHKaN9MoP0ZEQp93jJVBGVM/
	nlWCpwaGh+ubdGrlaA3eWenWxoMZbyk=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b73a9592fb8so1476513166b.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 23:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766821876; x=1767426676; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYDj1XIu1EL2KFzKtBsB87Y5oK9ucq0vxjMNijLNu58=;
        b=nhcSfjwHP/Ph2OnLcivlGs4H1zKC6EddViX0K2fD3lnf8RzNMGkA3YQMVIkuiqlLIi
         wkd4AkwgwgkwAHQSkHab6Im5RPpDFgXdy9TjWFtc4fBxKVgnTTG9mz0gU1IfVLfks6rA
         a2REZEgO7pHe0TEIj2iqZZbv674Zc3cLP7UkF+nMrr8oiqc8vcwWYs01OmdHPeD5E2qr
         vxxBa9B6aSIlrrME6a5DJp+1WTp/9OzIT44jULW42V/U9/EkLk6y5iv/5srhxUqMCHfE
         4rtNYih+kGIzMlkoRlIDWD3GZ+H5i16RJMJUooXZfaBH8MAemQARZa5qwrCoWeQba+hT
         hoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766821876; x=1767426676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eYDj1XIu1EL2KFzKtBsB87Y5oK9ucq0vxjMNijLNu58=;
        b=mkGgkIuicxedFd05qqT6rGQBPHqA/lOMDrQhs1ndErTYvMNSszwkj3UkY/R6BdVN1U
         i1qEzQxAqsDDPVBxY7rcEr7r8RnPedFzTHe962ebcXgR9GOu90Qibrj6H28jNanxeDtd
         k7sPyucIiZZaqbdLw7Dti76J8fdxbmOrdfFETb4wJSYpFMnOWKLO8oSqgaH4Pj9zkrpb
         Q9KP5cvb/Kf4pcBaHe/nBA6uWQP69RGNit18j44s+oP7BrnDujObpXmRkeG/YkR7HtgI
         I9ib6gIl0lKejxKsvmmE9XxqUclIxu/V+XZe9DIpwOCnQlvDwxzyJS9RxDCDdpAyIn05
         NuAw==
X-Forwarded-Encrypted: i=1; AJvYcCW4KC7JI4+Hq1R5bdCUQZCnS39kbZKsGdxWs28+PnMGk6sXi92sWlPWuhCYN2m8wJZU0p3cIEuiFA==@kvack.org
X-Gm-Message-State: AOJu0YywV9RVPoHhZjB51Xyg5V3UiBHw7nthcJcb0Upvdjo2BLQFSm1r
	E07GAvD5rTPPRay9HGfdc6kke8n9vR66ha15sdGfNo5+wSjDgUGy4tcTvsEaUB0G9FIRCdTAusl
	62Ifgulx24bjJGmjGpEtZZdpXCkNG6qc=
X-Gm-Gg: AY/fxX7/DeHrqk6CwWlQrAkSf7aZDacr7lH8s3W5RP8mFV03aDNgscKLV58Mnc5zR96
	wm4f72qsk1wUkcuYyhlfT2m9WuCGjoMfVyDV47O5+SAOwdWbPvagMsZyAD7bHMfa6g2Pj9bk+IE
	WNW9F3MmN1zpi0Kev3/LayC8YC1WWwwfqKLqr/a6cV8c4M1O4YTTH/tuqPDKb53oQbvWfVQiAAa
	L76gBGVMuMnHO02nw9HYdwRKvo/2mah99jYtAnPmonuZqOFe1bIytFBFyOw87dzMFRD5ytoUaMC
	Zp3SIRk=
X-Google-Smtp-Source: AGHT+IGJvFDwoT5+R84Us2wOdELzTN8S3c6PUgRf9hT/zKx8b5q1OgRk0RWErpdB/opQupyeLAt4VEcLjgEF6Byjcpg=
X-Received: by 2002:a17:907:985:b0:b83:3295:15d2 with SMTP id
 a640c23a62f3a-b8332956e52mr703338566b.30.1766821875590; Fri, 26 Dec 2025
 23:51:15 -0800 (PST)
MIME-Version: 1.0
References: <20251225094057.286954-1-wale.zhang.ftd@gmail.com>
 <CAGsJ_4yEAOxUmrPvca3Nzc-OB0+xXk5Y5gzszsY5TPqHCGvgcQ@mail.gmail.com>
 <CAHrEdetNrGJbogkhMKY-25fgtxupPxKKLkwFGuenV8p5EwzZVQ@mail.gmail.com> <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wcovpuNKPTfS0STBOHrNREjP-4wam8Oe4e7_ctKsbAcA@mail.gmail.com>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Sat, 27 Dec 2025 15:51:04 +0800
X-Gm-Features: AQt7F2rijk-P8LMsjT91azPRMPHyXbFD4DqPcrpAH0HjLoLruyYoTM-Bj-9sJ0w
Message-ID: <CAHrEdeuBk_MoPj1jWdtdLODK0JOWrb2orTZ77Cbp1vZ3PM3x9g@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, chrisl@kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 664C740009
X-Rspamd-Server: rspam04
X-Stat-Signature: 9khmupoaphocdc4efx7fkx6ikgy3fyx3
X-HE-Tag: 1766821877-291589
X-HE-Meta: U2FsdGVkX18cR+pLFi4A9d6EfFPPO72IXbD4OhOxqpziZBCuUFKvRsdA/ApMdDYVSQbk1p9toLIIgL1dW9QqkbHDxle971lNbOjBvmR/zkwgsPEVQwfROHmoE5wrSi94XJ9H1R4u1s0xXZ5hh32c024SHYGZGu1Ebx3Nir68FroQY+4PsJQaaSpPa2iS8CebTTmxihauuN3pBehvzZyKBLGNBu6OpScOePck+1qbLPZ44BRfmCfoXaB8wbrOCAznIMNF3hbx3NOdNnaG/z4QoAjHITrWVXcCWfpo9sL+4zjNV5WZT8dhlVDGue3YXa2uroqgftkapYS9cIc8lls/1lYiYHAi5hiNketvBElJux/dXumEz1e7Ege0qTWSCgxOHNCYrILUSbhXzRYweLd5gvUaptNkx3TeyFwZs8GFanqWCALlijpKi/G8JImWhDnQtQKmjgzYeQdrcgn1o92MefGEJmVvcegStcYiv8H1gEIJZq0qoFh0mfD5OzaUqIeLRGSAieaaUHW04D2x5RO3O+zLdIQ16oFoeGkJM4olipE81huyAJYoAEKD62ckU2Az/1X4+f9EGDqRVhdjAigd2q8qlDBa1w/bSHbqudm0INDFFsK5UXRKzn24yvwS1tPn9x0IGzmICF9nJO0Lh6uuffHMXzMRgFgTrEm46Nmjl2Cjytb5UOqddPFfo1sz7NberLBZiPP4X8WLM23Zu6oOlad0d6YA7XjPbDq+ge/HlCCANH70+kK8+E/p0VFiD76UZLhyNFDFYoKNqvSsQm0cNGq4N8BEnRd3UqE5sYBzgxu1Tnn5fQd5nL3S4vyqGDqE7NgT2CmlZpNxaHcy+/7WRPAI+LfxS/keO0pngBj0zQsKwtGpSaTzjgcxpzKsRKk1lhTlySWCiVo9TjyGR+ImUV5z1WZtGzYJ+hD+DBrhzB80P93vPR5zGWDl48dTbCfLfR+qsBap1HRYRafrOso
 rRcn0up7
 NRG1wIQz86gLcI6HNZgoaZECM5HtVl+WsYkLEGakW2ZKjaN2qeFD2Qp2sorrl0RpDiA6OFAuNxit/mr4z5Y8XY9LUQcXfMmV6DEFAE9darMDeEZo3ZAAdyX8tItYfq4ZfF7XBtWIBuR1257NEPe4qkrAtqQtDYIE+5LvDUTaRO+Q7KlS0PT5QJP4lHQrBKwMZ1ihnWBtU4jBzS3fT6Xba5VMT7wuQj9eUGF3zxxGM8rzeRNNZQ/CPrEmqwCFsaRGV/Es6LbPxtuXBgQX4b+qu0YG89rKH2zi8RuhUSZYePdTSkmwONAX1UbvEjFo5x8DqY0OnWvR/CNPE7/gD4JEALqVWzKE4KRa3uzTZFvaVDTn2YNFYaeYAeU9+1zcctYJ0f9+MQs3JkdbI75uYlJ2r6avrkFADbVM+YSw039+f1Xajg5awVmy+0oeB0ofGeTlHjylDRArtvLJ2BYBNbWBw1dhKcIkb59rgxC5I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 27, 2025 at 2:43=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sat, Dec 27, 2025 at 12:46=E2=80=AFAM wale zhang <wale.zhang.ftd@gmail=
.com> wrote:
> >
> > On Thu, Dec 25, 2025 at 6:22=E2=80=AFPM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Thu, Dec 25, 2025 at 10:41=E2=80=AFPM Wale Zhang <wale.zhang.ftd@g=
mail.com> wrote:
> > > >
> > > > ../include/linux/swapops.h: In function =E2=80=98set_pmd_migration_=
entry=E2=80=99:
> > > > ../include/linux/swapops.h:346:1: error: no return statement in fun=
ction returning non-void [-Werror=3Dreturn-type]
> > > >   346 | }
> > > >       | ^
> > > > cc1: some warnings being treated as errors
> > > >
> > > > Signed-off-by: Wale Zhang <wale.zhang.ftd@gmail.com>
> > >
> > > Sorry. NAK.
> > >
> > > This looks odd. We already have a BUILD_BUG(), so no fix is needed.
> > >
> > > we should already have:
> > > ././include/linux/compiler_types.h:631:45: error: call to
> > > =E2=80=98__compiletime_assert_907=E2=80=99 declared with attribute er=
ror: BUILD_BUG
> > > failed
> > >   631 |         _compiletime_assert(condition, msg,
> > > __compiletime_assert_, __COUNTER__)
> > >       |                                             ^
> > > ././include/linux/compiler_types.h:612:25: note: in definition of
> > > macro =E2=80=98__compiletime_assert=E2=80=99
> > >   612 |                         prefix ## suffix();
> > >          \
> > >       |                         ^~~~~~
> > >
> > > Do you actually see this being built? If so, please help identify why=
 it
> > > gets built.
> >
> > Hello Barry,
> >
> > I compile the 6.19-rc2 for arm64 with -O0, this kind of error log will =
appear.
> > In file included from /home/wale/repo/linux/master/include/linux/leafop=
s.h:11,
> >                  from
> > /home/wale/repo/linux/master/include/linux/userfaultfd_k.h:19,
> >                  from /home/wale/repo/linux/master/include/linux/mm_inl=
ine.h:10,
> >                  from /home/wale/repo/linux/master/mm/internal.h:13,
> >                  from /home/wale/repo/linux/master/mm/fadvise.c:24:
> > /home/wale/repo/linux/master/include/linux/swapops.h: In function
> > =E2=80=98set_pmd_migration_entry=E2=80=99:
> > /home/wale/repo/linux/master/include/linux/swapops.h:346:1: error: no
> > return statement in function returning non-void [-Werror=3Dreturn-type]
> >   346 | }
> >       | ^
> > cc1: some warnings being treated as errors
> > make[4]: *** [/home/wale/repo/linux/master/scripts/Makefile.build:287:
> > mm/fadvise.o] Error 1
> > make[4]: *** Waiting for unfinished jobs....
> >
> > There is an example on my
> > github(https://github.com/wale-ftd/linux/commits/linux-6.12/) that
> > used -O0 to compile the 6.12 kernel. If you're interested, you can
> > check them out.
>
> This is not my question. The BUILD_BUG here means this code
> should never be built. If it is built, then that indicates a bug.
> So my question is: under what kernel configuration would this
> code actually get built?

Hello Barry,

I'm very sorry for misunderstanding your meaning.

For -O0, __OPTIMIZE__ isn't defined, so line 615 is hit.

595 #ifdef __OPTIMIZE__
602 # define __compiletime_assert(condition, msg, prefix, suffix)          =
 \
612                         prefix ## suffix();
614 #else
615 # define __compiletime_assert(condition, msg, prefix, suffix)
((void)(condition))
616 #endif

Finally, set_pmd_migration_entry is defined as follow:
static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *pvmw=
,
                struct page *page)
{
-        BUILD_BUG();
+        ((void)(0));
}

> Thanks
> Barry

--
Thanks
Wale

