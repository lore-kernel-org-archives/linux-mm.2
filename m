Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56030CAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 19:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B369B8E0005; Thu, 25 Sep 2025 15:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE70D8E0001; Thu, 25 Sep 2025 15:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23FD8E0005; Thu, 25 Sep 2025 15:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 915A88E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:21:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4BDE411A2BE
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:21:39 +0000 (UTC)
X-FDA: 83928741918.03.E3260C8
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67D99C000C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 19:21:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uydwcB/o";
	spf=pass (imf22.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758828097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4KSInYs4mXvvEQV2faa9PQRc3LDjipVLXOYd/Cf2adE=;
	b=asgKoPCMH74c+TP5rDkqCyxfD4Pi9/jHMUvNMLY47nYUAPxiMVIw9aD0nBzQlqz02BndYo
	Cf66zdafm55lxRyOXvgso954fFG7YvnLUsUxnOqPkfw5al6u4MjorlLYTNo539Na571VXA
	vqFSEgux6c0SgDN4s4SUYrU6yOyRFqc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uydwcB/o";
	spf=pass (imf22.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758828097; a=rsa-sha256;
	cv=none;
	b=48l59Se3AqJFtZfDzrZ4RjyusY9WqAUlte28ORb65UuKZLQa+JRyLdtaUB+a5T2+68Q46Z
	ivejzoRwQhPxOD7owiU2uIU/IbqXpBZ9zrRZXhogkqLYbzsQSKdVjU5mDfpAndrX4glvU8
	QP4obgL7zmjBwqBDzHfcsg7C9QN5YLw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-27d67abd215so47975ad.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758828096; x=1759432896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4KSInYs4mXvvEQV2faa9PQRc3LDjipVLXOYd/Cf2adE=;
        b=uydwcB/owjtb6YaNy8gvzJafd27KRWuCRlmWJ6hgp7Cy0NNdMFo8ePR0EPAl8B5JEe
         wV7NWg/p1R2e7m75h6RgVHUGPdh0Pd3+iwtg+9rf+4TeIMULc3gpAAUDJGfSHPa6Ard8
         goATdMyaLo84zhEx9IFJe/XW6B6lLmktugnmgGrCLs51LpoR7S6zrQ4rmUbakz6GAqZC
         0HdxRiokleFBhksk6F/IQTd+gqP5OzXLNigwfTo/r1Qa0/ZU2OHzz4c+KLN69IPobTOa
         BpjhgbhgXWhUcAyTpzKCvIQ/76+MkdNoaTD3KZY2ZsKzu5261tfilETIonvnQb1ZIxI8
         vQHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758828096; x=1759432896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KSInYs4mXvvEQV2faa9PQRc3LDjipVLXOYd/Cf2adE=;
        b=nkL1Vn/tdEqzkHLXTNqBSbmMQ/ZYN1ws0NLCJ+r71ea2GdveyS6josvoQQ1goNBraG
         Oz+zcdqgnXmbHvhS07WKqz4UwUIbSbDzMWegD/wDO0+OaiGF91eCjVv8oWuhWuvBOPf0
         AJE8jM0pXpY9SezMv1DbKz6ddICmOSXDgFhZmoLPaypxzWk5Zvz9lFqyhGFnC5lWifHG
         lFOaW0XPRMBw6adkXHAdgNKcDrZrTGIDGlBxlXRJvEoVlHmkaEcHCIat3cSRtCkbVeCd
         Ahd/Y1iTaK0l6aYcx0L81/BcI3/nHB3AAhhx7VAfPehgqd8II6wbxSC5x/ULbmcrv2Em
         noRg==
X-Forwarded-Encrypted: i=1; AJvYcCXd5fqbYRPV77oeaiFpxtBJgINg5sTTVTsoXHyM+eq+iKaau64Ah+vbCTo0LWiedYoTGnEIQul/fA==@kvack.org
X-Gm-Message-State: AOJu0Yz5DBUJhpuGn7Z6x+F0KhdhYw99n0jM4jEvrtz8mNp+ilg2375Q
	4WI+ppfAy9xsN+wxErc4UKyS7hxQG2fjD7Jlj+Ms7dmzBF3vZF577nowtVb2Gum+W2VrnoyeDW0
	LP4QLewxPfga0lkZ3/IvD1xdITxV5K7YsrKtvtVuf
X-Gm-Gg: ASbGncvaRkdAK+dZKqNxQbtaDGdASIr9JL/SYmcIQ9i5XOcbdDNFPNX7Jhf9d9K0bOD
	dIEPdGcxXUX8v3CXS+XN0CkDN+Vi/vVwEeFdTfSSDqJjDRGxj/dQAdqNl29nQAQYd75Rd9I96HQ
	V7+jauHnjcKvOQIP9t1hhb5wXFNn0PbWJMFWRLTAWaVx8+WjnUzbWfQi9VVsJGrpv/vMr+UcJpT
	9HvbA9If1wr65Y=
X-Google-Smtp-Source: AGHT+IEHyCC5l5zRXUnglrcMD2BVXY2uit6gN5gY7fOxE5kSTzIT1h6Y1BWZWqAv3vrOknBKerOjea2dxQ5tvnhQUj4=
X-Received: by 2002:a17:902:d4c8:b0:268:cc5:5e44 with SMTP id
 d9443c01a7336-27eecdd7ca5mr781105ad.6.1758828095779; Thu, 25 Sep 2025
 12:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com>
 <1758052343.971831541@apps.rackspace.com> <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
 <1758306560.96630670@apps.rackspace.com>
In-Reply-To: <1758306560.96630670@apps.rackspace.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Thu, 25 Sep 2025 12:20:58 -0700
X-Gm-Features: AS18NWCXXIiBV8iJKBo3UDc5xHKLLzmPbV4WwSUzqQ7fFb7oBmO0qyDgstYUI5c
Message-ID: <CAJHvVcj_gd=48k-dgbLeEoqn_f+QD-ifscu_DPvpAmPd1Kg=GA@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 67D99C000C
X-Stat-Signature: otcztyap5gwsfsijsun1wj8jjsz5yrsd
X-HE-Tag: 1758828097-277372
X-HE-Meta: U2FsdGVkX18ZNF+DfOBJ1av59jUNVZ+GM9RoIqtfCJQDmoWtNHiMi5N0m9Dl4nfa1NUX2nT4UzGeKa+m4C2zbAiL/FYKRJws/zIAV/FugSCkLshPgGywd4CyOeew7sKPL3mxG2e1nYWeTg0cfRiQkM4r51kU0ZDR2jPvJludYjpddJC5zRsagh2vFV7FpACY2EfDcwKoEFWyBka9MqqyjniKH7VEcwywTQ71uqumPcwAzkwpSEHkapcYJJy2EZsSdGHAl27DBiMWxf6r09ETV5ZsmI55+ff8XfS4RwZTZ4W3F+hfowCw2OuB48RiVQbI7APpFvv7H/7lOQpm2rRJ4Qg4SKERjpxYoSO7xy/HT06FOCZxa8DBfOO/qY4o1+48gE0UuchQsu1tre36+FWueKqYreQ7/aIZ38cX8NE0GsGoa+47h/Sqa560A4nRVeqBL+Z18Y6O9PWP52Ph3n08BBFtETLX94sgUmcO0rcMgw9CYsAtEjWPKCOGCnvbzp7/CW9AObvaje+/aDW6YolMLhISb60HZcBWoz3VyTKEV6lG5alx+qCOI1A2pnD45AVp59o+p2sFHTddz6xhULKzsuobBCOW5T6r+jt8vUZu3HAtJwDq4LXILmx5+J62ceYCKg7zG4zAPHdal6tMcjmxb66JWiezyWHsb2p+HzFpUniaf5KhbgpvzlTTbUSch52Zh9zmIBMH0yf4sdwbyu4wk8kAWSRzqOFyYdcTY/O4Lz267q6/9McLrcQ6ITHXbLYquYx+eO2Bx+tWzgEEvqkz94WtBTHinWPJWLWJAi2RU2AAcU/I820oLwdkEG6g4VMhbujgmX/iJ7CV6RE1arlrYlr+Ur0OaKroY9iyZG24XLiRMXvIF0jwbXSM/oZNU9gVfcMJK9VYTwdQrAf92CI21dUrIaFboM+6PenHFMq/G615hNAvNx1dOp6tmQ0O8ITbWbcQP3OaG4Ti6TcQaUu
 LrW9StfF
 fD7//gSyY+29Ucmco/b7K41ECqe8oUDjhuL59GYSJVFl3Sit5dp0f3bdPy4Qg54RibItwKLiDIsLs7S/cbMS6pm9k3uWVdex4/FWxgF/uZQZA9KF81DxX4wXZrMhpdGKeeX6LFqGNNV/zPNmyu4CYfHGcd93QpWVpIcTsXWxGrkgxgnkKHoMaKMe5RuuyyEe1ZdEMNoZR2CNoZOxuw2L8sGNJf57Pn60J9wT2whObUEN23FWlaoc5/mM2L+U/UczldXQrJ3uW7CRePe9Z/SUUQuEf9zPbAJSr6p/mKfcRSYbbwYv6TxeTHfMZr/oiLOziQ1+G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 11:29=E2=80=AFAM David P. Reed <dpreed@deepplum.com=
> wrote:
>
>
>
> On Wednesday, September 17, 2025 12:13, "Axel Rasmussen" <axelrasmussen@g=
oogle.com> said:
>
> > On Tue, Sep 16, 2025 at 12:52=E2=80=AFPM David P. Reed <dpreed@deepplum=
.com> wrote:
> >>
> >>
> >>
> >> On Tuesday, September 16, 2025 14:35, "Axel Rasmussen" <axelrasmussen@=
google.com>
> >> said:
> >>
> >> > On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepp=
lum.com>
> >> wrote:
> >> >
> >> >> Than -
> >> >>
> >> >> Just to clarify -
> >> >> Looking at the man page for UFFDIO_API, there are two "feature bits=
" that
> >> >> indicate cases where "minor" handling is now supported, and can be =
enabled.
> >> >> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
> >> >> In my reading of the documents, these seem to imply that before the=
y were
> >> >> added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were
> >> >> supported, and that the "new" additions to the MINOR mode were just=
 for
> >> >> HUGETLBFS and MAP_SHARED cases.
> >> >>
> >> >
> >> > Actually minor fault support didn't exist at all before those two fe=
atures
> >> > were added. :)
> >>
> >> Thanks for commenting. I'm not sure that's exactly true. Why is SNMEM
> >> (MAP_SHARED) supported, but not ordinary pages? I wasn't party to the =
evolution
> >> here, but so far no one has explained why there's a special difference=
 between
> >> SHMEM and ordinary VMAs.
> >
> > I promise it's true, I wrote the UFFD minor fault handling feature. :)
> OK, but I am still confused as to SHMEM VMAs are supported and non-SHMEM =
are not, in the case of an anonymous mapped range.
>
> >
> > As for why... Like I said above, UFFD calls it a "minor" fault if the
> > PTE doesn't exist, but the page already exists in the page cache. If
> > the PTE does exist, you won't get either a minor *or* a missing fault.
> > If the page does not already existing the page cache, you'll get a
> > missing fault, not a minor fault.
> I'm assuming that you understand there is a profound difference between t=
he "page cache" and the "swap cache" in Linux. I am referring to what happe=
ns when a page is in the swap cache, (which is primarily about anaonymous p=
ages, but a weird corner case is that "tmpfs" is backed by the swap cache a=
nd the swap system, not by the page cache).
>
> The "historical reasons" for the swap cache not being the page cache weir=
dly difficult to decode - I've spent a chunk of months trying to do histori=
cal reasearch on how this came about, but more importantly, why. No luck on=
 the why. (And the main reason seems to be that, if I were to guess, that t=
he folks who built it wanted to avoid using "inodes", which are required by=
 the whole page cache meechanism, perhaps because they thought inodes were =
"expensive").
>
> Anyway, I'm now understanding that UFFD's chosen a variant meaning of "mi=
nor page fault" that seems tied to pages that are file backed or SHMEM.
>
> A "swapped" page is anonymous by definition of what "swap" means in Linux=
. In Unix and other systems, swapping was a generic term that included file=
-backed paging as well as non-file-backed pages.
>
> Anyway, I'm quite puzzled why I can't seem to monitor MAP_PRIVATE|MAP_ANO=
NYMOUS page faults with userfaultfd.  The reason I focus on CoW is that CoW=
 and fork() behavior is basically the only user visible difference between =
MAP_PRIVATE and MAP_SHARED. And if you read random examples of how to use m=
map(), quite often MAP_PRIVATE is suggested as if it were the "normal" usag=
e (despite what happens on fork()).

You can monitor MAP_PRIVATE|MAP_ANONYMOUS faults with userfaultfd,
it's just that they're missing faults, not minor in userfaultfd
terminology, because resolving them requires a new page to be
allocated (UFFDIO_COPY, not UFFDIO_CONTINUE). The only exception I can
think of is swap faults, I could see anon swap faults (perhaps
specifically when the page is in the swap cache?) being considered
UFFD minor faults, but I would be curious to know what the use case is
for that / why you would want to do that. The original use case for
UFFD minor fault support was demand paging for VMs, where you have
some kind of shared memory (shmem or hugetlb) where one side of the
mapping is given to the VM, and the other side of the shared mapping
is used by the hypervisor to populate guest memory on-demand in
response to userfaultfd events.

To me it's not intended userfaultfd minor events are generated for
writeprotect faults, to me that's the domain of userfaultfd-wp, not
minor faults. James might be right that these unintentionally trigger
minor faults today, I would need to do some more reading of the code
to be certain though.

>
> >
> > So "ordinary" VMAs are not supported because I don't think there is
> > any way to create that condition with them? If you just
> > mmap(MAP_ANON|MAP_PRIVATE), those pages will never be in the page
> > cache, right? How would you go about doing so? You don't have an fd,
> > you can't fallocate it. If you specified MAP_POPULATE, the PTEs would
> > also be installed, so you just wouldn't get userfaults at all. If you
> > create the mapping, then fork, then write to it in the child, I think
> > the pages just get CoWed, I don't think userfaults are generated for
> > that, because the PTE was already there (albeit, with RO permissions).
> >
> > I guess maybe a way to make progress here is, can you list out what
> > sequence of steps you believe should result in a UFFD minor fault?
> > Like (for example):
> >
> > fd =3D memfd_create()
> > fallocate(fd, 0, 0, size)
> > mmap(fd, MAP_PRIVATE)
> > /* register mapping for UFFD minor faults */
> > /* read or write to mapping */
> >
> > Now we get a minor fault.
> >
> >
> >
> >>
> >> >
> >> > You are right that userfaultfd's use of "minor fault" is (unfortunat=
ely)
> >> > slightly different from the meaning in other contexts. I think the m=
ore
> >> > normal meaning is, faults which do not incur I/O (i.e., swap faults =
and
> >> > file faults [i.e., faults on non-swap-backed pages] are major, other=
 faults
> >> > are minor).
> >> >
> >> > For userfaultfd, a minor fault is a fault where the page already exi=
sts in
> >> > the page cache, but the page table entry wasn't setup. I don't think=
 that
> >> > scenario can ever happen for anonymous, private mappings, so it does=
n't
> >> > really make sense to be able to register such mappings in this mode.=
 If you
> >> > create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then access it =
(read
> >> > or write), that fault requires allocation of a new page, so userfaul=
tfd
> >> > does not consider that a "minor fault". My recollection though is if=
 you
> >> > make a file on tmpfs or hugetlbfs, fallocate() it or whatever, and y=
ou
> >> > MAP_PRIVATE that file, *that* registration will work.
> >> >
> >> >
> >> >>
> >> >> It seems odd that anonymous page faults and COW would not be handle=
d,
> >> >> given that context.
> >> >>
> >> >> Anyway, that's unclear in any of the documentation. This just adds =
to my
> >> >> last response where I explain my use case.
> >> >>
> >> >>
> >> >>
> >> >
> >>
> >>
> >
>
>

