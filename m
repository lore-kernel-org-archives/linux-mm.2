Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 250DBCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 17:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35DD6B0005; Wed, 10 Jun 2026 13:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6756B0088; Wed, 10 Jun 2026 13:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD52F6B008C; Wed, 10 Jun 2026 13:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8F206B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:22:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EC391C0CFB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:22:47 +0000 (UTC)
X-FDA: 84864672774.17.F89C686
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35489A000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:22:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b=WGzE17zL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781112165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQP4ydNn8mcSRgfuE7UM+2i3I7RwByF2VRfClw8B7tA=;
	b=KhUgwTc+t7cNMsALoXaZgC7m59aE2DmTKXA51YZVkRxnP9FEuvmiUjToTNDTIZPYtkR+m+
	e0L9UuY+5w5A62dvphLmSd8zYZxfSzq+A4xfgO6TB3H9RP80aQMjInfshmrpK24O0rN1C+
	tO7568D8a2DaNeecjEy5uujhGyStv/g=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=trailofbits.com header.s=google header.b=WGzE17zL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of sam.moelius@trailofbits.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=sam.moelius@trailofbits.com;
	dmarc=pass (policy=reject) header.from=trailofbits.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781112165;
	b=oZskB2LzaLV7Mo1N/WpvI09TnVndG7pGW7+4dtSddVjyLMbhuDBTlnXvg1+xF4j7bpdUho
	Pv8bmFuF9rxBAcubdaORpgcDkvSGQ8VC8UWQtHU4dXcBsO8g+oBHwLrzxrf4N1yYpwacvi
	cobkYMVDvioqRjNUUJdQ95I7zpI4/ho=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5aa68d9dc18so7238260e87.2
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:22:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781112163; cv=none;
        d=google.com; s=arc-20240605;
        b=PJ5wh8A30MqEwDI8Ur6h/Gd0Y5VzaYkfdwY4N4lP0Hv4+6o/FEbOhMs/C8gsBAArXq
         oiyUN0qj1qk73yOi5sKPOJoNwK9ZLQ1z/aroy9qnw5RmTvpnkhNQqjD/yrKllhufWWfZ
         EhJCQl5qPjiO/QXIzrPYhpsdAgeYf3fVPnIB71z5TeBl0YjUo6y99drx56p9cElhaNj0
         nSE9TCCkeAbL1ET8fi9yZVZM4T1AeNpc5EZHE+wHu4Mu8tz/lurPB09jnow6FMQeoyyq
         5h+gTIU4rYjptOM8i3bjLMHkLD/fdAzgvd5GUt2j9tflmqWXNKYSvD1qvDBSBsUe+Hjy
         jvFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AQP4ydNn8mcSRgfuE7UM+2i3I7RwByF2VRfClw8B7tA=;
        fh=NOSeFDVSUCcr+AV+rSq1zcyNzzCcogNBMkDFBKyDp+g=;
        b=BNHsuNymFASxqDcG4uOu0QZGsf+a6AVCY0MOO4zxRmic0ZbQrx8X8ClliI8WGE0a6u
         vQyqpVJ7v1thESfrBJ+357Cr7fitslIvo+3KQ6JSEPXJKvgZ4Hhev+mcyHVmsoeOUgaP
         oAz00BCDB6v3JhQ3ia/SQCFKTMaYXROKVD/52L4SQN+E+73w8dpVB1rCpmvFR237tF6J
         fDCMgPce9g0w59Ylo30SkI/D9zRKrYxb2IIfXiVT/tXHRfEXrqox/dSYZ1T726RyTqcZ
         Pn3EbnxmGlNym2Z+scgVlmh6JGxTG/JJyI/Z5Tj5rh5reGo3pJVL3B5kuKR9JrQDYJpk
         2ohQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1781112163; x=1781716963; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AQP4ydNn8mcSRgfuE7UM+2i3I7RwByF2VRfClw8B7tA=;
        b=WGzE17zLPMcfALI7+WPfti8RAPHUeSKNu1zTcFDLeQ+qwgKmh/nVqa7AKo91OGsd8X
         QDwZn7u2M6t8TxzHXmeBuZg4F+0z3TvoMiwM855Zimtq5LqMwKfvPm2iw6izMmV1dA7u
         l8hIRcBP5S1Lyy3bYu4vW86iihW8AwzTSAB4d+1vW69+UbREBWxDSmmxOaBc0pM/fxOQ
         vZzLXpyhaWdd7gFSXs+S4XwJg1Kgqn78PcIhep+hij3H1bkXiqovg3+mmU4QKLX7RwRG
         VA0W74j5DSll1QzlNmjbL/Iige838Yg8Fst/13bRC2vUwNFfpCwOl1HbYxz9f7na89sn
         p3dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781112163; x=1781716963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AQP4ydNn8mcSRgfuE7UM+2i3I7RwByF2VRfClw8B7tA=;
        b=Wm50EREBs3sqIg/LFE67Kcx845EJcdfkPCebowFOJuhmWdeFSfAZm1fNN+CljyzvqO
         gLzmynJwSy3w21ummj1aut1dWm2njRXRJiJ/gQQHntlTvxsi0DSmbgDYcoTDaWGrBSW0
         QbKV6t3w9lXi0b0OEUP9T62Av3MTA3+S4/xOn1pqTFzIuoD5484JD165fdNWxyuAgXtV
         RBhRzqkloVV6JPHdYvFBFaZzSpOkfAOA1qfwGBhgI9hL/yD0Igv64uAJk0IxZOvyZkak
         m+ryxcjHg3U7qjDUHRSXoUikLb9AD3UOIsSUio7Qg9dMguibF9k4R+1Fow3VzkzhyQwK
         EzXg==
X-Forwarded-Encrypted: i=1; AFNElJ+U9pHcKeF84OUHbzGCzRZPPNCf1+YjyMD0EfoBinhudvB4r+8voEjOgMUczdzclfwQxltiN/Lxyg==@kvack.org
X-Gm-Message-State: AOJu0Yxy6JnCbxe4q4OhiMPUQ3khhTQ6fgI2uCXNfK5ZxVYy3JYF4CVS
	1tzdJSoS23d7hWerQZ7RGaeon3wTSbdNPSr+YFPuOjFP/i+JKgM1Ruz0VDHZMHlxfDyWldO2ui9
	z7P1AE1ay3geVRJ+Sli4zllPABU+6Lw79MQ9JV1mDlg==
X-Gm-Gg: Acq92OF61l2f8DJIC5YLpR3/kXpw99G2oA/7LovNGhKRv2kbzKqGgWY79UpRqO/qfZf
	fPF1LrpxL+m2gSUV8qyNKkJI2BXcA3Od9Vp1px6vKquiESAy/SzZ3KZe+Vg6qPIVK25FDVjuG8s
	zDEhwGUxV+As88VvvkzJTD5lgG0s7tFAft/4ShvS7CnwzkJnTFh5QWr6rFnzsbSFsH4ozVcB/KB
	QZE40PBmom2JsbGRJM4mGtc9FkBGKM4OBLr3WSn+kCb/3JTNVLyY7gJfdB9XhVEDec8m7JBWp2k
	+PehoHzAlzvIHwqV
X-Received: by 2002:a05:6512:3ca7:b0:5ad:abf:1d35 with SMTP id
 2adb3069b0e04-5ad0abf1fbfmr2096278e87.32.1781112163270; Wed, 10 Jun 2026
 10:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
 <20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
In-Reply-To: <20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
From: Samuel Moelius <sam.moelius@trailofbits.com>
Date: Wed, 10 Jun 2026 13:22:32 -0400
X-Gm-Features: AVVi8Ccl1n62_SATde1PSfwJYYkyV6A1vR5zk2jBboWmoHUQBMvas5WuWQhS1to
Message-ID: <CAE+C+DZWRsKF8m5d-N-vkyp6rEw_T=ccWpUdqZVVYZ=oNfCvnA@mail.gmail.com>
Subject: Re: [PATCH] mm/gup_test: reject wrapped user ranges
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, 
	"open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35489A000B
X-Stat-Signature: ncthmgkynzfqffd5tujdyo97ohug5e6d
X-Rspam-User: 
X-HE-Tag: 1781112164-837519
X-HE-Meta: U2FsdGVkX1/b4DL7+X95O1KLneHNoJtqJ3HkLAo3hoy/hUZWqi2QNRyly+E+mvvvA+S33e/7dtK8ntWEFiOe17Au9pgAIEJxboXHo4EPbuP2snM/uLW+D6bJBP1QMocJ2Au6sfqJvl30mL7RRYm32lV92m5Z/KW9s3okuNsEIfyc4JT5Pvhcv9Oxx/tPQ4XCGc4U/W6GMxZWKEvAaNMZLmyv7QU8Kv1iJVCI+xR/p6tSxjAPJML1gbsn379v+RtP/oasCo0mGzUlPDDu9AttMP2fovtnsPj5sBHP0hw7JzhVXw0AWTaEVnaw2s9mslnHR3KmHI8/rMt/p+VOdq/7mtwZkszdBQh4/L78rORS3gpHHPKvGsYrwgswmAY2LxDKlI0nwSthNzjaNIq5kp1DshywWh/ztRPSZsqqWtlt3HR3H3rTjuIsDIO8J61kWjnfhcgkA1mckJYJcaceivrOElAUBVw5x1IkHPTmE4gJEMhkYxBHgNHxORxNHIQhMXvEBmC0yuBqVPeXhRBOFgl8AN4creIofNlOOM+Wf4uXCfE/pCOV596s4s3TZVSxwAwjBD5C6yXOf+7Pmt63n3pfTVRleJsoETNtkTjh832+FOeXwFmFd2XA6z0DS7fCeG1qUSvZGtaZYK/wNCwCl/9yeiieTwvqGCeMjcDJFJyRBSTkiLfKm4v8YDMP/206njp7udVKmjSL7wQgAy9doDLLEQtJtp9vE8m/TlPj75Kyil4FRnZqUt13+fZ5Kn5YSJ74wq1FPv9xsa6RTYTwQrDxs1Do2OG3BQ6ZAIesacEejDh2Ga/fQv+GYw0huqAeUQcMohogQQW7I6o+BPV88VcN0hY14MH8CZ75MPTk4cVax47Kc6BBXGcsemqjHrGsZrx/GcuZ/WLv9vfNYWJg6SlRnCcsCncKcQgQlPTl7no/3U977nMUyPq3FQsYgUBP4CHLbxdJKyPvFA/etLwZmo6
 Y3V3Ybf/
 BHx8pH610casPHDwO8+UbmhZBOLlckIZ6exQjxb2ZWayjv5vtkVoW32YmwUkRwms2XM2KMSQ+L/HDr3+YlmGN5ggB9vhiqvhWrOpDKVAAdlirZ0fUuy/u5jgVF9A+V+DHBEBQ66AUQGL4PViHK/rEUbOq5rEXhW6PJJ8KXOcdBc4PFvae6XeqQHGv6d62sZ/hl9cYcuU2NZDnUEdaotfAJYwpXehqh1xjRGE/s9AgyaZfygfsvBhyHelumI4LYLPxmmrvGLml/4DF31DeZTxWnoeWkomutLbqTEzvViiU/GKG88DixAnz1uD6pEf4mtdoYCoDtlqFrKS55i8RnVSAaJxAyuqxHJtrWnS2+pwqKZwvaC1Xtiy/h4wb/anwnqvyudZny5xLGjBbzGJkJaJAZPeMBqs+f9S7MOnIks8Ejjgn3iljTwJYqltz76mjVODvsgOFdk70EuTrvWVaOFhsCaeoKOEI6JYYCgHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 9:27=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Tue,  9 Jun 2026 00:48:15 +0000 Samuel Moelius <sam.moelius@trailofbit=
s.com> wrote:
>
> > gup_test accepts an address and size from the debugfs ioctl and
> > repeatedly compares against addr + size. If that addition wraps, the
> > loop can be skipped and the ioctl returns success with size rewritten t=
o
> > zero.
> >
> > Compute the end address once with overflow checking and use that checke=
d
> > end for the loop bounds.
> >
>
> Looks sane, thanks.
>
> > --- a/mm/gup_test.c
> > +++ b/mm/gup_test.c
> > @@ -105,11 +105,15 @@ static int __gup_test_ioctl(unsigned int cmd,
> >       unsigned long i, nr_pages, addr, next;
> >       long nr;
> >       struct page **pages;
> > +     unsigned long end;
> >       int ret =3D 0;
> >       bool needs_mmap_lock =3D
> >               cmd !=3D GUP_FAST_BENCHMARK && cmd !=3D PIN_FAST_BENCHMAR=
K;
> >
> > -     if (gup->size > ULONG_MAX)
> > +     if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
> > +             return -EINVAL;
> > +     if (check_add_overflow((unsigned long)gup->addr,
> > +                            (unsigned long)gup->size, &end))
>
> I wonder why those fields were made __u64 instead of ulong.
>
> >               return -EINVAL;
> >
> >       nr_pages =3D gup->size / PAGE_SIZE;
> > @@ -125,13 +129,13 @@ static int __gup_test_ioctl(unsigned int cmd,
> >       i =3D 0;
> >       nr =3D gup->nr_pages_per_call;
> >       start_time =3D ktime_get();
> > -     for (addr =3D gup->addr; addr < gup->addr + gup->size; addr =3D n=
ext) {
> > +     for (addr =3D gup->addr; addr < end; addr =3D next) {
> >               if (nr !=3D gup->nr_pages_per_call)
> >                       break;
> >
> >               next =3D addr + nr * PAGE_SIZE;
>
> Sashiko AI review identified a pre-existing possible overflow here on
> 32-bit machines.
>
> https://sashiko.dev/#/patchset/20260609004814.1240586.6294d614ac80.gup-te=
st-range-end-wrap@trailofbits.com

Does the __u64 or Sashiko AI point require action from me?

