Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D5ECAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F49C8E003B; Wed, 17 Sep 2025 12:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A59B8E0002; Wed, 17 Sep 2025 12:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D1B8E003B; Wed, 17 Sep 2025 12:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 215A08E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:13:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AE66C0592
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:13:58 +0000 (UTC)
X-FDA: 83899238556.20.1F44183
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 840E512000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:13:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sHm9pwBj;
	spf=pass (imf29.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758125636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uvJ6bulO45Bcv1bp+4eQlx1OfzhKYrOi/BMPhK5PNY8=;
	b=3GrroqWfa3PnGY7Nv+I4PUMKBGFxM3pKyw70EFF2lcdXJoRFVV3gW5hM7SRNin14admXub
	oqV0uU1O+AV8sqrMs5iRbQTTw2+Ki3eJcMtEMqqP2b2rhn3TCTnhV9r29esQaEEktJ1H71
	d/g3V0j1viuxTnHdbFMrxS94RRx9H/E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sHm9pwBj;
	spf=pass (imf29.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758125636; a=rsa-sha256;
	cv=none;
	b=MCnKme31cvorBVwyfURaHfXjNEArHug3bL09rnv1VM6+T7qtn17zC1Neop7OkXQUAc2L/g
	fr3KMM+EP0j2VvNN+8FTag2/jgnNJiaJ6LsPsH2ZdzHtLivEpcSpG/jKolvHxBeTsslKy1
	bRJAVDGrOoXPhFX4WzqLvl15nG1Dsts=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5694f0e29a1so8349e87.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758125634; x=1758730434; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvJ6bulO45Bcv1bp+4eQlx1OfzhKYrOi/BMPhK5PNY8=;
        b=sHm9pwBjkAviheq7x6gumHPXV4M0ohmczC4Gsr5Pi3NNrL7ZMUxpGSQ/kXckiDlRHB
         1IK9ai/O+TuQR9/+vu88C67epzfF0b1N9AeebJ/bnHDfXZM8p/IMF4ee3M5BDyefx+0V
         M+uJllY4Lzj7/aNy8fiqiZ2+uiv+lMMqUuA+D7YWfTsPvQ0sRsDYpWZimzQLV8REHBQd
         VX9FRWQtY3g3yeAlqCMl3c8Kac8JZmoD30EGNBTRih559y58ikezIXKRzof0CP0mYxi/
         sqyy8s98TOGw3xh8IYBG1ae+dWBcmL/PH5NSWSDH2IdGw9YVE7ozej2yBxFp9bPnvPo3
         8zDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758125634; x=1758730434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvJ6bulO45Bcv1bp+4eQlx1OfzhKYrOi/BMPhK5PNY8=;
        b=FWutPjcScLCn3QXna4ssjxJjUmHkPOqA4njo3KrQ5yFSPTYVSc07LRdrSDk9+tLwwa
         crC4OIqFmj2w/U5lcHXscdKxjBJDFYsmMtgxvPj6ghIVA0UXHa9ipK3kvzAIb4lUN0jN
         1c+k7npdeFz933rHH4jNjUxeWWdX4MfRd9lU+8cLozILJm+KOKm1aqLwNMSQp0wIyDtr
         f3YI0yjbQfKd/gcp00WXoiKMEYWiHMupvSsZ6wiAKIG3o6VTOuL9cJxQCszeK5rlbzsf
         2g5r4CuncibcDxKx/66BXeSweA6mIz1RmTM1eC9tekcuym38ChBv5l4dBrpQWFpHoj3x
         zlJA==
X-Forwarded-Encrypted: i=1; AJvYcCWuhl77eNerWSO7A6NsKN8OO6BG3diTw/HAq96+LieGwYlLr84elnPFnPFm5StBe0RwYT5VmjVTNA==@kvack.org
X-Gm-Message-State: AOJu0YyxRipwo4XcbW5JR/OM0uAOIoblDHoY5RicfVrYcGy7thGyHG6T
	40wFFR2A68XVauv6tX40Q3Eb0k7YYpf2xUrnQ+uGBpOh4Qb2qTurz/kAWH9Qkzy1zROSM4uNctr
	xSAyFh8PZtgKzloo48L6o1L7F9lh6sALn4eGDGPRe
X-Gm-Gg: ASbGncs3e+WlIGlYOEzc3MCD2mE7ESxfL0Te+gY+GIM0+qsRXpz3C1yqV2xuqDKuzab
	8gYLXl5hF1tXQ0/cWk18QgP/jurE/QfJ5Vf/8eR+TdIX0Xfgr03H6/Eihgh7KeqL7UB37ozu/mH
	L/9Gu97AlJe7kwvUDtbopgrwkp9px5JQNUdM06gs7s7rpU8uz2pyS+4ztjuz3nuzGp3nFU3FZN8
	mO0HRA4YLDQegDrtk6/mUs=
X-Google-Smtp-Source: AGHT+IEJmlzcZBbZRSOGR180JkXbCfSM+P+quz0IPfNt0JaR6MyxGAR6/PJRtZEtmV3b2qXq9Haz2tuwMDYlTIKdITU=
X-Received: by 2002:ac2:4e89:0:b0:55b:528c:6616 with SMTP id
 2adb3069b0e04-57753052181mr293289e87.6.1758125634224; Wed, 17 Sep 2025
 09:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <1757967196.153116687@apps.rackspace.com> <CADrL8HWGcj1oANGY=qAzpYi_-E-Xbi=L28Bmyyf8H7auVix=QQ@mail.gmail.com>
 <1757977128.137610687@apps.rackspace.com> <CADrL8HX78-oh0k2qAgqPvNVAhi4ESYvjRsScPGR2P2Dts13Bfw@mail.gmail.com>
 <aMl4qLyNovWHhty9@x1.local> <1758037938.96199037@apps.rackspace.com>
 <aMmMnfU-Koopc9mL@x1.local> <1758043654.112619688@apps.rackspace.com>
 <CAJHvVciL-6OLMPDGQjZ=VGDwvwKJznq0BL49uSj+DSq63LOUYQ@mail.gmail.com> <1758052343.971831541@apps.rackspace.com>
In-Reply-To: <1758052343.971831541@apps.rackspace.com>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Wed, 17 Sep 2025 09:13:14 -0700
X-Gm-Features: AS18NWCZXzSGtx27SCE2ko6lZk_QVSXJw1pvQMijSAg904iIs0KoucMUcWR3lhg
Message-ID: <CAJHvVchHKxiVKFjUz4ir4PVDvUihLhiSRMBWqpMEZfwLdereuA@mail.gmail.com>
Subject: Re: PROBLEM: userfaultfd REGISTER minor mode on MAP_PRIVATE range fails
To: "David P. Reed" <dpreed@deepplum.com>
Cc: Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 840E512000F
X-Stat-Signature: toq6bdwyt6trbr6bps1zcdt79tigatxh
X-HE-Tag: 1758125636-381500
X-HE-Meta: U2FsdGVkX1/a6q15qBf43OjPCY/ZRKBgWp8ZJL5+vLr9iOtnxFExlVKc1mWE03Rz/8DhoST7yoPQCTR6NzLM1eV81WC/7Elr//JpMC8F8az5wfiKYz3+cr+LdB3Xcjt4+3fbMiB2xHTeauTfDwaX44X9ChU0DOuLHbDAz9ClzwuCQb1HYiuv60wr2K7lpoEAqTmpAGN7QZVFZLI/A7wD4m1Dh+4ld9ZmRfmBRs5V852qIWsaFpCxdrvoUJQnTKmirgAVDnRkCGfQeSrgeVeA1zXNxNnIJaRnFMU2Zmpp5yi87SsJ+z/H7j0C8M+KybASxqX4oOx91/2ApzypN0rFOu99erBIvfVcikjXIvR9VlNS9UGcmOzWEewumBl5ME8qL8CDzHhNKDu4zhx4DZEyBROuGYg/Sz9bxDClYxhLIWc0Co7+FCY5XQkMPqibs3sig2plyTi3QDD9lN2AftOeZJkEJBwbcUiRDfwwmLEIlNSvCrb4qMOoPGJKPL6f34Kol5YxG+00uUw1J4KeW8uTbpirvILVOWQEPJL41gbHjXZvDOXAi0hEO5btMS/zhDeb0uo4rJBedeEGTn8gs7QonsYw7GW5bWYz6qClJZoZQeJ3AhCqwlBHdk67TNc0bQoIDDe8t34ZgPsmWeGoehVac0CLkhEF4DyuH1QkwRLDpm2/UsBq8M94Y3azrMJzSKgnhfRjuma3foKksXLSghzGjsTGZLK+7nBapLMYqargyUQ7AggxUnKGy/DnaMxmXfXeBAsX4tACtVkHKSDxMkjuCMVQF05FqoEzITkbdOvydNjvZCy4tHFz1EllNzgW/QlB+2E/hjmCq0nzlgc0gL0MyWKDVww+jzWFSLQd//QCFDpq3v+Kjaz4bBxBFhknDhAN1uVxCjsTtj/hIYzHK25TrQQWjZUAm9M3k4/Dh9JEFYm8uAmX3nXMxn2M3FYyyLePezIltZYYgQq+ECyjs3S
 shFXklkL
 OeGLi3bd24KvUOfZ+VbNYkG4anzASrQVELpPFnxXiT984ohY5w8CgVnqXSwl+tFT+EtZ6WvwKQt3KKc5fOHOEEWkALL1lRdy4T+aGU7Ed10A+J6zhAEolHNXWWr7NhvfGVmqHFSO7UwwIBtYPfk/P4VIgwKWfHRV7ZLKRehqNf4aSKiCcMUc65EW4hgm+0CTXE+8UupFh4oPEt5weOu5TkM1Uv5zHN/NplgFHOi+SgcG5j0q22CkdIi+dE4MilmCc7VODoUHwwRAq57og30VvphQ2f5EA6EtJ29UFEzllNa6iBZqrId1k592yudy8Z8KJ+rFr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 12:52=E2=80=AFPM David P. Reed <dpreed@deepplum.com=
> wrote:
>
>
>
> On Tuesday, September 16, 2025 14:35, "Axel Rasmussen" <axelrasmussen@goo=
gle.com> said:
>
> > On Tue, Sep 16, 2025 at 10:27=E2=80=AFAM David P. Reed <dpreed@deepplum=
.com> wrote:
> >
> >> Than -
> >>
> >> Just to clarify -
> >> Looking at the man page for UFFDIO_API, there are two "feature bits" t=
hat
> >> indicate cases where "minor" handling is now supported, and can be ena=
bled.
> >> UFFD_FEATURE_MINOR_HUGETLBFS and UFFD_FEATURE_MINOR_SHMEM
> >> In my reading of the documents, these seem to imply that before they w=
ere
> >> added as new features, that MAP_PRIVATE|MAP_ANONYMOUS mappings were
> >> supported, and that the "new" additions to the MINOR mode were just fo=
r
> >> HUGETLBFS and MAP_SHARED cases.
> >>
> >
> > Actually minor fault support didn't exist at all before those two featu=
res
> > were added. :)
>
> Thanks for commenting. I'm not sure that's exactly true. Why is SNMEM (MA=
P_SHARED) supported, but not ordinary pages? I wasn't party to the evolutio=
n here, but so far no one has explained why there's a special difference be=
tween SHMEM and ordinary VMAs.

I promise it's true, I wrote the UFFD minor fault handling feature. :)

As for why... Like I said above, UFFD calls it a "minor" fault if the
PTE doesn't exist, but the page already exists in the page cache. If
the PTE does exist, you won't get either a minor *or* a missing fault.
If the page does not already existing the page cache, you'll get a
missing fault, not a minor fault.

So "ordinary" VMAs are not supported because I don't think there is
any way to create that condition with them? If you just
mmap(MAP_ANON|MAP_PRIVATE), those pages will never be in the page
cache, right? How would you go about doing so? You don't have an fd,
you can't fallocate it. If you specified MAP_POPULATE, the PTEs would
also be installed, so you just wouldn't get userfaults at all. If you
create the mapping, then fork, then write to it in the child, I think
the pages just get CoWed, I don't think userfaults are generated for
that, because the PTE was already there (albeit, with RO permissions).

I guess maybe a way to make progress here is, can you list out what
sequence of steps you believe should result in a UFFD minor fault?
Like (for example):

fd =3D memfd_create()
fallocate(fd, 0, 0, size)
mmap(fd, MAP_PRIVATE)
/* register mapping for UFFD minor faults */
/* read or write to mapping */

Now we get a minor fault.



>
> >
> > You are right that userfaultfd's use of "minor fault" is (unfortunately=
)
> > slightly different from the meaning in other contexts. I think the more
> > normal meaning is, faults which do not incur I/O (i.e., swap faults and
> > file faults [i.e., faults on non-swap-backed pages] are major, other fa=
ults
> > are minor).
> >
> > For userfaultfd, a minor fault is a fault where the page already exists=
 in
> > the page cache, but the page table entry wasn't setup. I don't think th=
at
> > scenario can ever happen for anonymous, private mappings, so it doesn't
> > really make sense to be able to register such mappings in this mode. If=
 you
> > create a mapping with mmap(MAP_ANON|MAP_PRIVATE) and then access it (re=
ad
> > or write), that fault requires allocation of a new page, so userfaultfd
> > does not consider that a "minor fault". My recollection though is if yo=
u
> > make a file on tmpfs or hugetlbfs, fallocate() it or whatever, and you
> > MAP_PRIVATE that file, *that* registration will work.
> >
> >
> >>
> >> It seems odd that anonymous page faults and COW would not be handled,
> >> given that context.
> >>
> >> Anyway, that's unclear in any of the documentation. This just adds to =
my
> >> last response where I explain my use case.
> >>
> >>
> >>
> >
>
>

