Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA0EEC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 06:53:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A173E6B008C; Tue, 29 Sep 2026 02:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8B06B0092; Tue, 29 Sep 2026 02:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7696B0093; Tue, 29 Sep 2026 02:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612E36B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:53:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDCFC140427
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:53:27 +0000 (UTC)
X-FDA: 85265883654.14.860B0A3
Received: from mail-vs2-f43.google.com (mail-vs2-f43.google.com [74.125.227.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id D8A124000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:53:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrGOeNHM;
	spf=pass (imf17.hostedemail.com: domain of morbo@google.com designates 74.125.227.43 as permitted sender) smtp.mailfrom=morbo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790664805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXZNNhcaPyXqA+zSRw2siBSAi+AcqonBzV+S3T5CpzY=;
	b=ny1VHo91c3+dQA4n++ErB8x9+uxU6TgXXPlkuuCIwWrS5VYOaHNtLRz0g06AIOCM8UB+UG
	1d74wX+b6rOZR3XlNzvc2+7R+AYxmgL42LKVZVfc1mHAdOdzvPirMcTdX0H1/pP5mUcGLG
	titKbCcP21g9L3Y0LwODgzbaCgzdvHU=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VrGOeNHM;
	spf=pass (imf17.hostedemail.com: domain of morbo@google.com designates 74.125.227.43 as permitted sender) smtp.mailfrom=morbo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790664805;
	b=bnxqNGKnk2fKo0QvnP3q5+3KZyvFquJt/e5a3ItL7dts5y4igbiJRucLPbpEtEyf0/v0XI
	EYNrX2npQeHqIGPmaZFYpUWt+bEvOCZCWvZtbH+FcbSVjqvkGYnfHwhffxsDAQB767roQQ
	04RjKj8NyR2lYUtYUUG82xYjjtk6cUg=
Received: by mail-vs2-f43.google.com with SMTP id 71dfb90a1353d-5d3de1dda8dso16958e0c.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 23:53:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790664805; cv=none;
        d=google.com; s=arc-20260327;
        b=bJXz8LLfSUcldKI4Gu6ZMrkEmRbxWdHZrbMZIX5zvyRgbZCmkGeF914VE0WskVCJ1J
         5d79Ic3tsjBraj+TwhgpKAHV1JWx5CG5x1nh7uzbjl+hc22WXvKKo521QotmKNnXGyVC
         SNKSgAHAxbFj8rIVddQym09wMvZ9wnGbJg9cF/krRiRkC1i5cIHMRvh9MDLamQJuFlGL
         WruTnkQ9VR+Q+t8vp8GwlXkHOK9bY8fs3t5KlSvUI2r3Nn9E4uZgvX+gNDx4JtzlR6uF
         JuxMMwXi4yZcaExtTZeyFmiqj16XsA+6JoE3Sh5kUTi+IwXXIh8ZEhFgJt6ieHphht4b
         otxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dXZNNhcaPyXqA+zSRw2siBSAi+AcqonBzV+S3T5CpzY=;
        fh=7xqz7zKKxRBSmnShQ3XpX2nNb8gG0R8czIz1/xiygWs=;
        b=OxKL7XsdRImyWbVowK1XhUC4i9Iw7oZaVqJ6wnYLqvZQL4TDjeFyNcuEfLUAXXLDya
         wRDY2JG/WNepnmdJVe0mhAc3ABAykLo/FerPTN3wu7vVCt5pc82WD31ZsWIuGrTbtZjg
         h5uaa7sHnvZtrlRi2tedZT0ZIMr+JTPD4R9xkN3+Cr69ZNQwmNVChdhp2kphWIegpHY9
         /ZZslq8XXxjPj7mtWZxv3QNBPqpjP85ENAB9jOIesWsgOIcOuHOgGLN0AIu+uaDDtbGU
         nktcSo5AhibSisds4OYIDLVlNJOn7BKI6tzwmXenqcASRkKgOBrBwYO0EHHpl0vO9KLG
         HIPw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790664805; x=1791269605; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dXZNNhcaPyXqA+zSRw2siBSAi+AcqonBzV+S3T5CpzY=;
        b=VrGOeNHMWQk+UyNM+x/V388SVpObI7/MTEKtvp0yXmJNdTFD7f41eisaflLy8VPDbn
         Qzp5f16AepnojFSPEwk05ApANw/6PfYM3B93VkMPGhLEOC1oS0QKIg0BpRYXGg4CSUcO
         beQ4UWKwU0R18lfBmYxiLnOCj4Hai9NS4XV68i1oOs/RYibjZPj/RkmDGXnOfvCuE4+j
         w0XuFaSCYQsW1HYr8zENeQxNvlOOe1cMgvmKX4KNUGBsM6K+hHbN4mUOXS6ib1/8iVA3
         uioHI6Jw+FZKIyDeIZ2iuF35LhpuCQ5aentN76gn55sMA1AHs80Nf6wUY/5heJK9XpCS
         cQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790664805; x=1791269605;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dXZNNhcaPyXqA+zSRw2siBSAi+AcqonBzV+S3T5CpzY=;
        b=NJDRdkxs4bJAQ6NSmXcb9j5hbK9bEfyt/9WpdYid3muc6i6I1gTJlDyIfcdfsYLwH+
         4a+mCEzlItMRmjsK6n3iMQ7y9OfeUCCTTUFgEAtctHj12rEG1/tyhdNeVapW9PvULfrS
         HTdvwO+K4YHIWuNbGsMw1zpI3xwWTV8uLoHRW/dcvPYoyO+RzJsO9Tsw7KvSSg7gi60K
         x1cxR4+NC8PxnfPy3ZRlQDmAF7qpwTAVpFlpiiP8FCCnRyXtSKXrvNFUm1BuMUnFfbkb
         jhBiPRSGVzYczki7gz6aAV78RlIXwHSo0tzVTq5N7Qux5ArIKiSqUx/10b1RzFrd2xbB
         stOg==
X-Forwarded-Encrypted: i=1; AKwUvBxo8SVW1hAuMZJAe/eHN6r9/GVdR2fKwvFLFzE+tjFwR0X4553hPEcJTa8uqETjquOOHWk3PLdSbA==@kvack.org
X-Gm-Message-State: AFq9FYICMXImKavCdjT6hkXtJuaVbmxu88VwT09SV6ftqy0Vm0alKVxY
	wy5mRNKrLUhjv2j3XrbQFK1awfSRRyJtMoT8pV8pvGkhvS5Qv6DlDI5y1YUxXhYDlXPPykmj3Ik
	arjxQ4mPWwlesd93PZycHImUvb/9+drdzfVqEBN4=
X-Gm-Gg: AYBFou0pfvoBQCdaCbAwFkTPC7MBdEMbbASJFp2Npu9/Ty7fsum/YwoKmfe8POcN488
	B6riA5vzY42Ri/WKDf4fwyEcv3eY4OJ4w9kXG8F3n1h2Ctjh++f4bghDIxaoaTJE6NtmVP24Y31
	JozrZYSAtnhYd1a5U61Kno0/75DVHpal+1/u92G7qQ8pMM8Yz9vq0RDHrK4JVYrYWGxUd/yR64b
	GxDpB3IAekXUZEru5swHvukm+LihOJ9tjHje8HAKTixFYMptomRzrtuT7lTr20ntXD5cDc51Dn1
	zjfTor3nMMyFlJSCcSMXCdvXkf+kCN23JLv5eiEDMHcbmlJZAxKVqETyoVUmVGavdOj/8MDwOY3
	gqWMl4V3d9FGp53p6Rmpv
X-Received: by 2002:a05:6102:5346:b0:79b:f57e:ea17 with SMTP id
 ada2fe7eead31-7af1c6921f0mr6195643137.3.1790664804262; Mon, 28 Sep 2026
 23:53:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260928231737.2092716-1-morbo@google.com> <20260929010031.2186255-1-morbo@google.com>
 <20260929074930-f1e4add2-f8ca-43db-85fd-83be0e40c676@linutronix.de>
In-Reply-To: <20260929074930-f1e4add2-f8ca-43db-85fd-83be0e40c676@linutronix.de>
From: Bill Wendling <morbo@google.com>
Date: Mon, 28 Sep 2026 23:53:08 -0700
X-Gm-Features: AclHuK95_Ji_ujgZlHwbCN-2G8mT4XgLFj2k80q5CXF5eM05CshEFI-U1oGuQxM
Message-ID: <CAGG=3QXAb954ib3eGqci5NNs7pE3VEFgUBocRObqRSa4Z8sn_A@mail.gmail.com>
Subject: Re: [PATCH] fortify: add KUnit tests for __counted_by and __counted_by_ptr
To: =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8A124000B
X-Rspam-User: 
X-Stat-Signature: c6ni3mtmsm3kqm5s1m63qjgs6z73wmdb
X-HE-Tag: 1790664805-352730
X-HE-Meta: U2FsdGVkX19X+LmOCLRvchF+C4J09lQ2rf9s5Q5SgL4jON/GyEc2K2TgjkiLifX1Sv9fMmkxM/8Mu+soQwTWj+7C1iBhl8VT9XDuWD3Ay9NuRKgmMhjz76OU/WCK1KqE4gb8yM+O4YWbpnFeyPQ+GFh0NLGYJ5CUihWXcaR/hAqePPrtbry83wHDkXFavVdWE/gQKYTiUS07aY156RZz5i6eURn4oCwQRAB2Z4nV3i9NmHJwsVjcPoA6KfoInoUpMQvyNDwBjXkCrjSS1dXDhPf/Jmp9i7Sn1qfnSn6WS19v34GMN6/WLsl0uJ98/KxMloyRI+U/Xk1ce5q+LPJLuWXwu0XghK3cShuLguI7BU3vdAh0mtBzJMMx2fbmr+SJvdXNl/1Mmsrbriepg42WKoHgaOudTtK079vHMS0xZuCVp9wdkvK5VPoZCs0xr41RS1QiuVCecRUOgc0+KEQl7yXn4tiFgZ1zLTk/iCI3LCSKwrRim5Xm8TsOARljNLcByrltyfZAzvJM0EAx2vFVBbVtTe7SRpE1NMi0avseN1j08XArqPTHdYeYDgqP+uxoHpddBW78ExjmMTLK0Ym4k9Cv7L7/d88H2Wx7cQPp9NyTbgTdKbsQf1iPg8TKiqvJ/VZzCjzGb9TgxKTZ46KeodVG3xr+X2snpPkawwru1RxfAa/NC/W9/+7LXLw6ZtEr9vbky5OI1eVg80GQI+NNbGolqI9bbjgQ+mm8Dv7eXTw1gGVBDFUc1xNH2x2S0eIVdsQWHwGmf/17IM3muP4CLe/UPKHdAMjBxjlqn1BC0MQV1kaqwqrscy8tX+ZI9jUqjBGTdPz0cjlCbPD0ZbUoOO1X0X2ZQSwhnCyr+6IOnV2KBF3R6cafB6IdxSmUSjaGaOp21voQsMAw2TYPuePOsGz9aVSKSRPO9Snorg2fpT0PvyVdbPlQfU1Er4cwm2lSPJLMKckNp31bHIkbTGl
 PIQg1t/2
 cK3/CLbxn9TS5ZPuVWe06w4j4MfC65aJM1sJtvVvcfVN6+siVFBrMMlmx25L8JuJ23bbRustW9RNrj28Ig//TzoWhkTIF8+yditq4VCzN3W+DmuybtEWNrTg/oIdzULADJJzPu/Y8Rg0vSRpru0vl/4twaqY3NETZdpZM+dsI25TQV+rNkfOTNh3VqdtA0Qy5L+wCpqSN0GnjdcUZqfCVCLcZXDQL7bDsvsKABYIIedGwKFfTosF1Bo5QaiAsuBgtVbx/6zFMVQTwvQsqqiXNp33raBFupWSHlcA38LMZ/qbIrUqnnRb27LidNLi5bWHXofvlRm23ysq3SKaoYhd1vOzLaQI6n0EJhJBcWKipAD6I5WsvrAMn8jLhUgzi4vCkvaRd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

On Mon, Sep 28, 2026 at 11:23=E2=80=AFPM Thomas Wei=C3=9Fschuh
<thomas.weissschuh@linutronix.de> wrote:
>
> Hi Bill,
>
> this looks much better. Thanks for the rework.
>
> On Tue, Sep 29, 2026 at 01:00:31AM +0000, Bill Wendling wrote:
> > The '__counted_by' and '__counted_by_ptr' attributes associate a
> > flexible array member or pointer member with a struct field that holds
> > its element count. Supporting compilers use these annotations to
> > compute dynamic object sizes via '__builtin_dynamic_object_size()' for
> > runtime bounds checking with CONFIG_FORTIFY_SOURCE.
> >
> > Add KUnit tests ('fortify_test_counted_by_flex' and
> > 'fortify_test_counted_by_ptr', guarded by CONFIG_CC_HAS_COUNTED_BY and
> > CONFIG_CC_HAS_COUNTED_BY_PTR respectively) to verify that:
> >
> >  - '__builtin_dynamic_object_size()' (both types 0 and 1) returns the
> >    expected logical byte size for annotated flexible array and pointer
> >    members.
> >  - Fortified operations ('memset()' and 'memchr()') succeed within the
> >    logical bounds and detect out-of-bounds read and write accesses
> >    beyond the annotated count.
> >
> > Allocate the test buffers with extra physical capacity (2 * size) in
> > 'noinline' helpers and hide the returned pointers with
> > OPTIMIZER_HIDE_VAR() so allocation-size attributes, physical slab
> > bounds, and compiler optimizations do not mask the '__counted_by' and
> > '__counted_by_ptr' checks.
> >
> > Signed-off-by: Bill Wendling <morbo@google.com>
> > ---
> > v2: Move tests to the 'fortify' KUnit tests. It uses UBSAN, which is
> >     what gets triggered by 'counted_by'.
>
> v2 is missing in subject.
>
Doh!

> > ---
> >  lib/tests/fortify_kunit.c | 119 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 119 insertions(+)
> >
> > diff --git a/lib/tests/fortify_kunit.c b/lib/tests/fortify_kunit.c
> > index 413cdbf3dc0d..2335171f84d8 100644
> > --- a/lib/tests/fortify_kunit.c
> > +++ b/lib/tests/fortify_kunit.c
> > @@ -1011,6 +1011,119 @@ static void fortify_test_kmemdup(struct kunit *=
test)
> >       kfree(copy);
> >  }
> >
> > +#ifdef CONFIG_CC_HAS_COUNTED_BY
>
> The ugly ifdeffery can be replaced by IS_ENABLED():
>
> if (!IS_ENABLED(CONFIG_FOO))
>         kunit_skip(test, "Not built with CONFIG_FOO=3Dy");
>
> It makes the code cleaner and gives some useful feedback at runtime.
>
Ah yes! This is much nicer. It'll also fix up the #ifdef stuff at the
end as well.

> > +struct counted_by_flex_struct {
> > +     size_t size;
> > +     int array[] __counted_by(size);
> > +};
> > +
> > +/*
> > + * Allocate the struct out-of-line with extra physical capacity so tha=
t
> > + * __alloc_size() and physical slab bounds do not mask the __counted_b=
y()
> > + * logical bounds check.
> > + */
> > +static noinline struct counted_by_flex_struct *
> > +alloc_counted_by_flex_struct(struct kunit *test, size_t size)
> > +{
> > +     struct counted_by_flex_struct *s;
> > +
> > +     s =3D kzalloc(sizeof(*s) + 2 * size * sizeof(s->array[0]), GFP_KE=
RNEL);
>
> kunit_kzalloc() to automatically free the allocation again.
> struct_size() for the size calculation.
>
Oh cool! done.

> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
> > +
> > +     s->size =3D size;
> > +     return s;
> > +}
> > +
> > +static void fortify_test_counted_by_flex(struct kunit *test)
> > +{
> > +     size_t size =3D 128;
> > +     struct counted_by_flex_struct *s;
> > +     size_t elem_bytes =3D size * sizeof(s->array[0]);
> > +
> > +     s =3D alloc_counted_by_flex_struct(test, size);
> > +
> > +     OPTIMIZER_HIDE_VAR(s);
> > +     OPTIMIZER_HIDE_VAR(elem_bytes);
> > +
> > +     /* __builtin_dynamic_object_size() should return the logical leng=
th. */
> > +     KUNIT_EXPECT_EQ(test, elem_bytes,
> > +                     __builtin_dynamic_object_size(s->array, 0));
> > +     KUNIT_EXPECT_EQ(test, elem_bytes,
> > +                     __builtin_dynamic_object_size(s->array, 1));
> > +
> > +     /* Within-bounds write and read succeed. */
> > +     memset(s->array, 0x42, elem_bytes);
> > +     KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
> > +     KUNIT_EXPECT_NOT_NULL(test, memchr(s->array, 0x42, elem_bytes));
> > +     KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
> > +
> > +     /* Out-of-bounds write and read past logical size are caught. */
> > +     memset(s->array, 0x42, elem_bytes + 1);
> > +     KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
> > +     KUNIT_EXPECT_NULL(test, memchr(s->array, 0x42, elem_bytes + 1));
> > +     KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
> > +
> > +     kfree(s);
> > +}
> > +
> > +#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
> > +struct counted_by_ptr_struct {
> > +     char *ptr __counted_by_ptr(size);
> > +     size_t size;
> > +};
>
> In the other structure the arguments where swapped, intentional?
>
Yes. It's a minor test to make sure that the attribute can refer to a
field that's defined after the pointer.

> > +
> > +/*
> > + * Allocate the struct out-of-line with extra physical capacity so tha=
t
> > + * __alloc_size() and physical slab bounds do not mask the __counted_b=
y_ptr()
> > + * logical bounds check.
> > + */
> > +static noinline struct counted_by_ptr_struct *
> > +alloc_counted_by_ptr_struct(struct kunit *test, size_t size)
> > +{
> > +     struct counted_by_ptr_struct *s;
> > +
> > +     s =3D kmalloc_obj(struct counted_by_ptr_struct);
>
> We should probably also get kunit_kmalloc_obj() at some point.
>
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s);
> > +
> > +     s->size =3D size;
> > +     s->ptr =3D kzalloc(2 * size, GFP_KERNEL);
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, s->ptr);
> > +
> > +     return s;
> > +}
> > +
> > +static void fortify_test_counted_by_ptr(struct kunit *test)
> > +{
> > +     size_t size =3D 128;
> > +     struct counted_by_ptr_struct *s;
> > +
> > +     s =3D alloc_counted_by_ptr_struct(test, size);
> > +
> > +     OPTIMIZER_HIDE_VAR(s);
> > +     OPTIMIZER_HIDE_VAR(size);
> > +
> > +     /* __builtin_dynamic_object_size() should return the logical leng=
th. */
> > +     KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr,=
 0));
> > +     KUNIT_EXPECT_EQ(test, size, __builtin_dynamic_object_size(s->ptr,=
 1));
>
> Is this builtin guaranteed to be available?
> We have a wrapper KUNIT_EXPECT_BDOS() above.
>
I suppose not. I'll use the macros instead.

> > +
> > +     /* Within-bounds write and read succeed. */
> > +     memset(s->ptr, 0x42, size);
> > +     KUNIT_EXPECT_EQ(test, fortify_write_overflows, 0);
> > +     KUNIT_EXPECT_NOT_NULL(test, memchr(s->ptr, 0x42, size));
> > +     KUNIT_EXPECT_EQ(test, fortify_read_overflows, 0);
> > +
> > +     /* Out-of-bounds write and read past logical size are caught. */
> > +     memset(s->ptr, 0x42, size + 1);
> > +     KUNIT_EXPECT_EQ(test, fortify_write_overflows, 1);
> > +     KUNIT_EXPECT_NULL(test, memchr(s->ptr, 0x42, size + 1));
> > +     KUNIT_EXPECT_EQ(test, fortify_read_overflows, 1);
> > +
> > +     kfree(s->ptr);
> > +     kfree(s);
> > +}
> > +#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
> > +#endif /* CONFIG_CC_HAS_COUNTED_BY */
> > +
> >  static int fortify_test_init(struct kunit *test)
> >  {
> >       if (!IS_ENABLED(CONFIG_FORTIFY_SOURCE))
> > @@ -1054,6 +1167,12 @@ static struct kunit_case fortify_test_cases[] =
=3D {
> >       KUNIT_CASE(fortify_test_memchr_inv),
> >       KUNIT_CASE(fortify_test_memcmp),
> >       KUNIT_CASE(fortify_test_kmemdup),
> > +#ifdef CONFIG_CC_HAS_COUNTED_BY
> > +     KUNIT_CASE(fortify_test_counted_by_flex),
> > +#ifdef CONFIG_CC_HAS_COUNTED_BY_PTR
>
> The nesting of these conditionals looks unnecessary.
>

-bw

> > +     KUNIT_CASE(fortify_test_counted_by_ptr),
> > +#endif /* CONFIG_CC_HAS_COUNTED_BY_PTR */
> > +#endif /* CONFIG_CC_HAS_COUNTED_BY */
> >       {}
> >  };
> >
> > --
> > 2.56.0.rc1.315.gc6ed9934b7-goog
> >

