Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653E9D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56FA76B0088; Wed,  7 Jan 2026 16:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53ABB6B0092; Wed,  7 Jan 2026 16:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BEB6B0093; Wed,  7 Jan 2026 16:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02FBE6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:50:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C85951A053D
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:50:31 +0000 (UTC)
X-FDA: 84306512262.03.1A7BAF0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id DCF79160003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:50:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QpBVtLt7;
	spf=pass (imf08.hostedemail.com: domain of maze@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767822629; a=rsa-sha256;
	cv=pass;
	b=NcuDHS9eYoCvdKGlaV73j6KgGlT4J3cPnbZLFU1Dd978ryfGz7Pn9BSGn5UU7h9RW7VRmq
	KpMnHViBgyxzleC7UhEd8bDyO4UFDOiZQ3WD8e+n3WsOQaJWgDey2P1qjUHCbRTKhdYLY8
	2O8u+bXt6y2zmSfpK+yH4N03Tx3XfuI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QpBVtLt7;
	spf=pass (imf08.hostedemail.com: domain of maze@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=maze@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767822629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaOpyLcin2kj/229gqDfEx7XdNW95lzHOQ0xc5uB8Nw=;
	b=yBE4105s5WQ+DGpF2MxhkBmaJqLnctkJyV6MEcPmHZyEPYSJwcDTeaYEfpVuzGz4SOc8Ea
	e/+6BpVLMvVuWlPdqozYBSItoHvRJUGgUDcf6C6AgA7yAVy0IPK7dqP/JDozca18Qnj1zV
	XXujR1bKJAtEzomf1Dnp7lCbA8GkByo=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ee243b98caso533351cf.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 13:50:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767822629; cv=none;
        d=google.com; s=arc-20240605;
        b=H/4VsWSKChKtFia2WqGZZ9HR6a2T5BdWUeCsVCvZL6NhRviFXAjylpJVuFEWREAjea
         nNrGZizXvrjYgFYnSBHQvZg6+Xl7+mV6AROwF/+3nig5Wo8p0hRaUX2+bj2wuL5kK/+e
         iUKkeyaNjjhbeKIJyfJtdpok9XiIk8ub5fGriJ/XKDHxJz/B7ATxyC+uPAkFlfcFPIPL
         Lnu5C2AMSVkksFMZYK9kI9f6FeefQFYiQ0ZMOLFtEuQCk5vfCMK+m4NoveWxwrg5kQew
         WbGnmIXbP8u4AG4ofIbQ8VdrTMiF1jzhYN3KH2shk2OPpzZxK10EmuQG4HT6wvYyr0du
         FApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xaOpyLcin2kj/229gqDfEx7XdNW95lzHOQ0xc5uB8Nw=;
        fh=EGP5r5ts8+zPR04EhxOKpKgYR+dVKzQAorrTrDSN8qw=;
        b=IVB5cocdjwUj1y6npMcPW10o8aQfi3N7hCYSxa4f30Bxwf8Q4wKjBw6Nlu079q22qu
         axgCoqw+AcRmc+Eood8yLaQC3CxRcFfT1BBggtJkw3g4SH4FW+pBTAmVRhERDxWvZdr3
         0V2WuKBmo+ioMkdn6OyORx+FqGxkKyeY8ewW2arMmDV6c+bKlsAHxUkk37A2uLOB1OXt
         oTUCkaveulThchws3ke7RI2kcWFr2QQMJ9EDURtLITPaK25zcEztRKK0XGvTjzKDRzQq
         eEePM2qxsgnDGsH4S7eR6S5tjQ8DGOKu7NB7tgjq2kBdyRst51SxM23nZBdBob68tpFH
         eTvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767822629; x=1768427429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xaOpyLcin2kj/229gqDfEx7XdNW95lzHOQ0xc5uB8Nw=;
        b=QpBVtLt777wjzM9citnvcr61jqENnkM8TUU7epZsbwqNvsTREXOvMS6l+hQ6CBwXgv
         feILy6iiLkYDNW10CdMcYZs2QEjuBAo0cH8V99NjJJ/+afbMJFnzKrBBVypKXLspwUEB
         ZXw7vgG7JBeNXsVS0/GajcuUMaz+ZIZhc4kP4gbV6uQjQmTVJRfpiwUNjcTMJeK2ZJ+d
         JHDl1nl3a80VxuzgvuU0qNx2HzU/Rm1mH/H6BazX1v9XM2LKUc5ncVl1pZxag5h7I8OZ
         39iYrD9i2uaFqG3PVX4d8aqp8VngliIuzXFrMF1WJL7G2hWej398jrN+EbgOvD4wVlN2
         xQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767822629; x=1768427429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xaOpyLcin2kj/229gqDfEx7XdNW95lzHOQ0xc5uB8Nw=;
        b=DLSZvFwj3T9Le7h0fRx71iBNTgRzxECzcYm6PWPOEhI9Dm2OF34uKwonjtFc+P+eiv
         HRjpXRYMDUiAPAoaL+r/L9EAauzqHYeB8iWHBKBZuMl3JmAQnC54qa63mFKQqD+vvqSn
         dbxE2Z1xFEfg9OY4H72J7en2L74RtOB/6uYDbmJzBS2t6W5WCSCnNFvZrWySm9drocU5
         rLpNuONC5T3KDhRfPHPg4wtEnIv0S8jAtid8K0fg8R0jff8MX4x1o3hz7O4x/u6BeN9I
         JHaPhgREd0ayiQkaOJYe/GPw4e27rnxhGe1jE8fObfetsyxWUHX95y47aODSLGxxaC+D
         euxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZj9ZiurJV7ptdpL8V4WSni3mJVXjIFbOm7VspR/fxKPBnJN5D2jJCmVPLGCiyjWbmtEBQ2ohDrg==@kvack.org
X-Gm-Message-State: AOJu0YwaWZxPBzMG2wOjjVv0e6Qop+nzgpl4w8dAlvuYRHn8TPH2V0Kr
	j25QmKO5Lk1cP0hrI2Y8OH473wp+0Icg+KBxvwFWOySs6Cjgzv/C4NirEgXXyFQBVbEM0GEqV4h
	/SMEaKyYrX9HMyMN8ArTzpKGFccQ9CKmvc23wG/ee
X-Gm-Gg: AY/fxX6bqZ1/SfLew3KynBISjZReMVeZkyGwEHXFNjw0dielelJFMull6v0XckP4Q2l
	UjfRyEVZwv62NCmdtTsbjXnI6qdcfZjzsZeR0MePvwBoN8+S4CtApIQQWYy2uDxuYsE9vifn8Fs
	F1PNsOOsJUE5+JRJmHARwogxQtKsC2U9tVRgb6aR2mPIbYwhjTLoeU6rflNpn8CXKX/kVTcATb8
	3mvbn38vElTslOc8lUZC1Dh7qjh5PzpvSgHiZTSU3VtwBZeb4cqdQbiiLS+xCcA4hVWzC6nAHAS
	sVbbjYTlSh5ZYpAdd+qH98Ucu39T
X-Received: by 2002:ac8:5f8c:0:b0:4f4:bb55:68d2 with SMTP id
 d75a77b69052e-4ffc09cea00mr544121cf.12.1767822628718; Wed, 07 Jan 2026
 13:50:28 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt>
 <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
In-Reply-To: <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Wed, 7 Jan 2026 22:50:16 +0100
X-Gm-Features: AQt7F2o8s_zvZFLLijkyWtvuzQewBbTHFYSzIOxPYFTVLuxut8PZ5Lz61l2sK0E
Message-ID: <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com>
Subject: Re: KASAN vs realloc
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, 
	Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, 
	syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, 
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, 
	Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DCF79160003
X-Rspamd-Server: rspam04
X-Stat-Signature: bfu85jbw7ts5bf58m8zdz8pi7yj6tnb8
X-HE-Tag: 1767822629-887451
X-HE-Meta: U2FsdGVkX18Exy6DgkFnfmIbvip3eeXWaFgli0V83Pq2ad7PnWFj3I0WcJS3NIZdkVhxQQB1I+15kYLQc5FpEtDlOcJZXtsk+2ZvPn/Q5SXuhzLqV7KdXIXKdbxfMRlp2ykBQEtL6KAM0Fm9ViXLb+Mnj6oK52cAbjWvrMoematdvO9gdD40lwoJsmV+XGRn3u86VoRGLWLialf13Fsdq19w3hx945RJrC+QW+OCYWU5T8WaWDXiArPuqf3fVpSFa96B572sg05guxCeoPoJreUqtNtYwE6lOM6Cfu3GPMkSBujDIiT7jWnLByPGyqsX5lLvfcZxdM844UvvaRqRuvOhtvDcTHwg8hOjl+NEybpEh75lpmZliHlnG1vR0ei44yZvk5cAvD/lMA/+herFVsYQ3Dsio2RCEj+tVjGp3TYRnrX2My48etdNBXS+izGhRaBCN6hsHBzPbejnnCQCrR21jNEruI4LPWVsjaCq9acY82r66HVsbkdd46+kui3qbMEUCYx8UVrFeYZMCr+Ky0GYO0eH2tdqv7+kH61Ac6SY6X48v8SlOgIvF3jrk/N/NWhvCTaluPWEtfL0h+krr/vYYoWDLWPe2Rsnn+v9okFnbRvYGYPICBUaI42nvsdq9bEQE7A8w0qVTURHlqvR8zu4aBLhEqwIXXf4e7iWRvh8Ftn4BxOvmo/xsjX3FGuF0mzakhL2beXddGL/GUv4+FmM4yf6iQkQ9KZRSyg6oM6c6HMl3+xui4h13wiFxXe9qHtL3NiVnFRQHfPjeN8cNay0vAsxu32ZW5dW3/bbMQdoO1qaPgd9kxItQRwy5H8xLV4zT+e5MYAf9MF3oInBJValgu69hAKjPcERAv+MxsfiuEsykbIZcX5yITJGUin/Ws3+g6QTBHiMx3H5V2JsTkeoiELTF3AjZpmBCW9bo/FU/eNnKrxUtRee2WpyCWTNfpsSXSGYOCweWIMP5xY
 fZVzmfYA
 D+3bbYd6cNImls9ZmMq/nkffUzmo38ldEqbzN9fjxymaeCgM1y1nJZowkbZvjFZE3Wkx/kmOgsZ7lpbo7DmJB73SH3msPUN1ZZDbVJOnNoEUDOQmujVS8d03OQ6+44ppEIUccPW8eTnu+WTmGDIOHOGwO05vTUbU01c5UQMbc8sIkvj57mtSfKdU7+jO8x1We1pi1DGo4FmIOzkEkHgRgh9VH5rdagfEb+sk1z3z7XPtnDg2WBdhFJ8I7fpfPEXTpE7xX3jmH6Ecb9TGCOIPmf06PZsfXY1d9piW14h9a2sK33G6Bao3bfJqZpwzlLiTWJwzTGSXsL3c48VKZiMoCPTHjGAL5tudpxsoeMlQ/Q2Y78J68BivXWN49t8l9nagMvRXwnI8E8OtlnjU5pUncZq3OBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 7, 2026 at 10:47=E2=80=AFPM Maciej =C5=BBenczykowski <maze@goog=
le.com> wrote:
>
> On Wed, Jan 7, 2026 at 9:47=E2=80=AFPM Maciej Wieczor-Retman
> <m.wieczorretman@pm.me> wrote:
> >
> > On 2026-01-07 at 12:28:27 -0800, Kees Cook wrote:
> > >On Tue, Jan 06, 2026 at 01:42:45PM +0100, Maciej =C5=BBenczykowski wro=
te:
> > >> We've got internal reports (b/467571011 - from CC'ed Samsung
> > >> developer) that kasan realloc is broken for sizes that are not a
> > >> multiple of the granule.  This appears to be triggered during Androi=
d
> > >> bootup by some ebpf program loading operations (a struct is 88 bytes
> > >> in size, which is a multiple of 8, but not 16, which is the granule
> > >> size).
> > >>
> > >> (this is on 6.18 with
> > >> https://lore.kernel.org/all/38dece0a4074c43e48150d1e242f8242c73bf1a5=
.1764874575.git.m.wieczorretman@pm.me/
> > >> already included)
> > >>
> > >> joonki.min@samsung-slsi.corp-partner.google.com summarized it as
> > >> "When newly requested size is not bigger than allocated size and old
> > >> size was not 16 byte aligned, it failed to unpoison extended area."
> > >>
> > >> and *very* rough comment:
> > >>
> > >> Right. "size - old_size" is not guaranteed 16-byte alignment in this=
 case.
> > >>
> > >> I think we may unpoison 16-byte alignment size, but it allowed more
> > >> than requested :(
> > >>
> > >> I'm not sure that's right approach.
> > >>
> > >> if (size <=3D alloced_size) {
> > >> - kasan_unpoison_vmalloc(p + old_size, size - old_size,
> > >> +               kasan_unpoison_vmalloc(p + old_size, round_up(size -
> > >> old_size, KASAN_GRANULE_SIZE),
> > >>       KASAN_VMALLOC_PROT_NORMAL |
> > >>       KASAN_VMALLOC_VM_ALLOC |
> > >>       KASAN_VMALLOC_KEEP_TAG);
> > >> /*
> > >> * No need to zero memory here, as unused memory will have
> > >> * already been zeroed at initial allocation time or during
> > >> * realloc shrink time.
> > >> */
> > >> - vm->requested_size =3D size;
> > >> +               vm->requested_size =3D round_up(size, KASAN_GRANULE_=
SIZE);
> > >>
> > >> my personal guess is that
> > >>
> > >> But just above the code you quoted in mm/vmalloc.c I see:
> > >>         if (size <=3D old_size) {
> > >> ...
> > >>                 kasan_poison_vmalloc(p + size, old_size - size);
>
> I assume p is presumably 16-byte aligned, but size (ie. new size) /
> old_size can presumably be odd.
>
> This means the first argument passed to kasan_poison_vmalloc() is
> potentially utterly unaligned.
>
> > >> is also likely wrong?? Considering:
> > >>
> > >> mm/kasan/shadow.c
> > >>
> > >> void __kasan_poison_vmalloc(const void *start, unsigned long size)
> > >> {
> > >>         if (!is_vmalloc_or_module_addr(start))
> > >>                 return;
> > >>
> > >>         size =3D round_up(size, KASAN_GRANULE_SIZE);
> > >>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> > >> }
> > >>
> > >> This doesn't look right - if start isn't a multiple of the granule.
> > >
> > >I don't think we can ever have the start not be a granule multiple, ca=
n
> > >we?
>
> See above for why I think we can...
> I fully admit though I have no idea how this works, KASAN is not
> something I really work with.
>
> > >I'm not sure how any of this is supposed to be handled by KASAN, thoug=
h.
> > >It does seem like a round_up() is missing, though?
>
> perhaps add a:
>  BUG_ON(start & 15)
>  BUG_ON(start & (GRANULE_SIZE-1))
>
> if you think it shouldn't trigger?
>
> and/or comments/documentation about the expected alignment of the
> pointers and sizes if it cannot be arbitrary?
>
> > I assume the error happens in hw-tags mode? And this used to work becau=
se
> > KASAN_VMALLOC_VM_ALLOC was missing and kasan_unpoison_vmalloc() used to=
 do an
> > early return, while now it's actually doing the unpoisoning here?
>
> I was under the impression this was triggering with software tags.
> However, reproduction on a pixel 6 done by another Google engineer did
> indeed fail.
> It is failing on some Samsung device, but not sure what that is using...
> Maybe a Pixel 8+ would use MTE???
> So perhaps it is only hw tags???  Sorry, no idea.
> I'm not sure, this is way way lower than I've wandered in the past
> years, lately I mostly write userspace & ebpf code...
>
> Would a stack trace help?
>
> [   22.280856][  T762]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   22.280866][  T762] BUG: KASAN: invalid-access in
> bpf_patch_insn_data+0x25c/0x378
> [   22.280880][  T762] Write of size 27896 at addr 43ffffc08baf14d0 by
> task netbpfload/762
> [   22.280888][  T762] Pointer tag: [43], memory tag: [54]
> [   22.280893][  T762]
> [   22.280900][  T762] CPU: 9 UID: 0 PID: 762 Comm: netbpfload
> Tainted: G           OE       6.18.0-android17-0-gef2f661f7812-4k #1
> PREEMPT  5f8baed9473d1315a96dec60171cddf4b0b35487
> [   22.280907][  T762] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> [   22.280909][  T762] Hardware name: Samsung xxxxxxxxx
> [   22.280912][  T762] Call trace:
> [   22.280914][  T762]  show_stack+0x18/0x28 (C)
> [   22.280922][  T762]  __dump_stack+0x28/0x3c
> [   22.280930][  T762]  dump_stack_lvl+0x7c/0xa8
> [   22.280934][  T762]  print_address_description+0x7c/0x20c
> [   22.280941][  T762]  print_report+0x70/0x8c
> [   22.280945][  T762]  kasan_report+0xb4/0x114
> [   22.280952][  T762]  kasan_check_range+0x94/0xa0
> [   22.280956][  T762]  __asan_memmove+0x54/0x88
> [   22.280960][  T762]  bpf_patch_insn_data+0x25c/0x378
> [   22.280965][  T762]  bpf_check+0x25a4/0x8ef0
> [   22.280971][  T762]  bpf_prog_load+0x8dc/0x990
> [   22.280976][  T762]  __sys_bpf+0x340/0x524
> [   22.280980][  T762]  __arm64_sys_bpf+0x48/0x64
> [   22.280984][  T762]  invoke_syscall+0x6c/0x13c
> [   22.280990][  T762]  el0_svc_common+0xf8/0x138
> [   22.280994][  T762]  do_el0_svc+0x30/0x40
> [   22.280999][  T762]  el0_svc+0x38/0x90
> [   22.281007][  T762]  el0t_64_sync_handler+0x68/0xdc
> [   22.281012][  T762]  el0t_64_sync+0x1b8/0x1bc
> [   22.281015][  T762]
> [   22.281063][  T762] The buggy address belongs to a 8-page vmalloc
> region starting at 0x43ffffc08baf1000 allocated at
> bpf_patch_insn_data+0xb0/0x378
> [   22.281088][  T762] The buggy address belongs to the physical page:
> [   22.281093][  T762] page: refcount:1 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0x8ce792
> [   22.281099][  T762] memcg:f0ffff88354e7e42
> [   22.281104][  T762] flags: 0x4300000000000000(zone=3D1|kasantag=3D0xc)
> [   22.281113][  T762] raw: 4300000000000000 0000000000000000
> dead000000000122 0000000000000000
> [   22.281119][  T762] raw: 0000000000000000 0000000000000000
> 00000001ffffffff f0ffff88354e7e42
> [   22.281125][  T762] page dumped because: kasan: bad access detected
> [   22.281129][  T762]
> [   22.281134][  T762] Memory state around the buggy address:
> [   22.281139][  T762]  ffffffc08baf7f00: 43 43 43 43 43 43 43 43 43
> 43 43 43 43 43 43 43
> [   22.281144][  T762]  ffffffc08baf8000: 43 43 43 43 43 43 43 43 43
> 43 43 43 43 43 43 43
> [   22.281150][  T762] >ffffffc08baf8100: 43 43 43 43 43 43 43 54 54
> 54 54 54 54 fe fe fe
> [   22.281155][  T762]                                         ^
> [   22.281160][  T762]  ffffffc08baf8200: fe fe fe fe fe fe fe fe fe
> fe fe fe fe fe fe fe
> [   22.281165][  T762]  ffffffc08baf8300: fe fe fe fe fe fe fe fe fe
> fe fe fe fe fe fe fe
> [   22.281170][  T762]
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [   22.281199][  T762] Kernel panic - not syncing: KASAN: panic_on_warn s=
et ...
>
> > If that's the case, I agree, the round up seems to be missing; I can ad=
d it and
> > send a patch later.

WARNING: Actually I'm not sure if this is the *right* stack trace.
This might be on a bare 6.18 without the latest extra 4 patches.
I'm not finding a more recent stack trace.

