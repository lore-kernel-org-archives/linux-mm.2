Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649DEFF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAFAF6B008A; Tue, 28 Apr 2026 05:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60106B008C; Tue, 28 Apr 2026 05:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27EF6B0092; Tue, 28 Apr 2026 05:15:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 916326B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:15:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36C2C1C08B5
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:15:21 +0000 (UTC)
X-FDA: 84707406042.25.0992743
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40991C0013
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:15:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+yG36MV;
	spf=pass (imf10.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777367719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJFD+kGVAKfsClU+9sfZFCMjUnBJhZDjljGFmAegQcY=;
	b=kahZao+/naq8d3Fp7T/l4wq8y6wo0xGSTXfDwMaZDut5ROTcZ7HI3EXaR7+fgLzfiWAYHR
	yNU5WCuzaM5MWd9cZ+9vJY9FxpxIb3aCYxhTIaqH8o61Il6v16tLvs4E+fY3Cu10bs1Kkz
	7LyKkt5w8JKaLO8AKO78Mzv6QAYyUCY=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+yG36MV;
	spf=pass (imf10.hostedemail.com: domain of agarwal.vineet2006@gmail.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=agarwal.vineet2006@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777367719; a=rsa-sha256;
	cv=pass;
	b=OTyFVV1zmInCYKKOkldgl8RNKsonLUrpDH4CL9goKj1Z2nQebxdDcRWWnk3hGrflrI2a28
	fCK3T/QogWDzKfFBEY6R6XW/z/tKnty8GT0p7URLr6m+LK5rHFnthe0dWla7FtTYHYKYTc
	hu+MbyjeVHOvURyczm//zGXWfMp5XTw=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-56d95bc93e3so6112047e0c.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777367718; cv=none;
        d=google.com; s=arc-20240605;
        b=kSTJJIxXZwgBBSj2VPSb7LJlgvhDri+cC96PJxVstRCdAiH0RDvtyMvAh8XHW+CavR
         dUNY9i1gfAMw2HrDVsQib+Uh0RinD4eltSt8yf2hTG2V4vrPFHCTT1SX1FX6fJS+XyUQ
         739Ar9cBUOuQincyiJehRGsO/WrscscEnzQEen+eopD/7Ym1S1kkdzWEnohjTnw7zujA
         TJP8JYd120TQ471RSsE97XpLxthDICvH6cyi7g/U/II66HqyVwfjuWLXv0pq5AWzXOWx
         Qel59Z1dQ5IwR6/gRDjrfzK+kQIFfcX3rbN81lnggxMVsrbx5XVYYZWLVkWwD3PvmbRn
         L+wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=JJFD+kGVAKfsClU+9sfZFCMjUnBJhZDjljGFmAegQcY=;
        fh=DtXPD04R9VNk32bMw4mKFgc8XEcuMAIkX26fBo9VbwE=;
        b=cMRI9tWF9dObTZIj5jyiRBukYI0PzHvS/j+jjq8FTnZPPSNrClUmCVUBljRrKev0fl
         d9CuBrTfU2jFKkb/uFm2C0PQzgKBWlAS01ojbVIxMqNX1brnzF/f6crbxS4fubAabY6d
         HQ+GnZ02dFrH+VkHc0zPnRlpmPqOBfU/CLQgMHxHbIUkXfyx2f0RyTZW6OaR3zKbONh8
         queojcAR3aG3/2Jd865/eau2hGlpRAvS7ncNHtXDU+iEbwda9/52FUmBP60xtnxaBXv3
         NzoM8w9yaG3WlOCkCclxQbVL666S/Jkghg5spt+Bwgjl4fg04SX9XFGV/JTPVYQTDRwA
         +CiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777367718; x=1777972518; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JJFD+kGVAKfsClU+9sfZFCMjUnBJhZDjljGFmAegQcY=;
        b=d+yG36MViXKOpExF4tB9McV4diTZs48cUvMVVAn1yI5uiDT9horoyW0C8CjWkb6ALe
         YPnpGrl/J+4u0YZ5qA2xR4W2zm0tVECOtIvEJzx2yv/ciolEIUWT0S9BcLaIIzkghIMk
         LupAhlnWpS57iTnoQgCZxgQu38a43Q46OOor8O58cJi7+oEmLLdX8F8d4Zyv1z5LP8Le
         MnFvSIw+JABoNpT6uqgNRo9+OvFmqusOCCj/zbJWFl+GNoJnAImWhw4X95dFRN5CyGvF
         aYnnatm5uowcFa/h82OB7gFOWmUN8YlxP47FFYmBcjOFmfJl0pUEeubCazi83J5cbXk/
         gHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777367718; x=1777972518;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJFD+kGVAKfsClU+9sfZFCMjUnBJhZDjljGFmAegQcY=;
        b=ezXJPEd7ZKc3HvIVOXDoe+zBrF4a5GdlzzAZxRaCapzAAQlI2wD7wdesW1DBizV9Kt
         +yUJ4719AcpWcMmnd8lPI0dV+FhYPzMYDqmHu4SCcqwCkSdQ+evz4iDTOCK7/8hJHKdb
         73R+qOjRt24kC9Jjh8AZtTIrPD7HfXrleW9XSSCX0ziZniqPwz7qEnvRsFm7S6iP36W0
         /R9vukz4vLoW2S2PBg6I4fyhQkhCkMZOfbA2NCh5Vv0ps4amhvCUjMSPARppUogpCTaL
         Zu52UnQbbPWaKhLHFPErE486G4ufmu22XI5fHReGpl5abadSFYEy2Gs9U464OD/cOKg4
         PhaQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mLFKIbJvVB34Qbm5eTYhqVmjwFOx4BAEaNhcvWIOtVfY79Y3NhRerLv9YBwApWReZH4B2F4UQmw==@kvack.org
X-Gm-Message-State: AOJu0YzpJn3lUo5azXbz5AfCmu69ssboZmYl3+Xo1+MOoTt0YAVKcLum
	oZnGTnZ2pgsITHHPxLSj5fpKenYFKzDyQwMza32+l3iOi3/Cybnz7L3imO8Pt/jKTX8Fe/LAsvm
	nzXwyNmOb2fRRtVtMKOxm2DxjPFtoAgg=
X-Gm-Gg: AeBDiesEgksBr2GwOR6fxC4GOqfjQqYBoP6r9B8KJB7gvdd+eo4lygqOGFwXtH/NNmk
	L94WC20ehO49Rd6L9GtA/5eK20P2iIKFF1DE9kcTZOr/mGj0z+fQGCxGUb10tQwWl5uHdvapXi0
	MwMqflWQiDbBj0i1nwHcTjiULrqyI6kOWFE+NRBq+Ib/MTjLSxDltRLQTJY//COXFXpPZwfC28j
	P8ZJNeuHSeSymUbRlRNvq8qqwUxrf8hzy1mrhBlaS1zyuzoiX6OHmzyFhxvhWllt6/H7NswcHOU
	xEerpNCMX/Ob5KKJ6bn9lbxTynQ5y84o8sCyUPNKIo+Urr1fwsQQ
X-Received: by 2002:a05:6102:5989:b0:607:b901:5d74 with SMTP id
 ada2fe7eead31-628098825d1mr809126137.9.1777367718098; Tue, 28 Apr 2026
 02:15:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260428062322.20417-1-agarwal.vineet2006@gmail.com> <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
In-Reply-To: <3abf09d8-a98e-4f1b-b8d9-77879a8a2733@kernel.org>
From: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Date: Tue, 28 Apr 2026 14:45:06 +0530
X-Gm-Features: AVHnY4I3RYir7e9RspxaXTVrr_ckYIAghCeHwmP-75zrMJ-tpQMF5xsaB86Dfsc
Message-ID: <CA+rjy8cZ9jAivzoDjrGFQ9TYKYtT7Da27iH1CcEa3cP2N1fzWQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: khugepaged: handle partial write in file_setup_area()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000078fae6065081ab3b"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 40991C0013
X-Stat-Signature: 54bro71bhgubj9nbxc75q9fkjmctf631
X-HE-Tag: 1777367719-363340
X-HE-Meta: U2FsdGVkX1/ywryAUw4hfBix865fYEt9TNy6FtgV4AsQoiuC/nxDYM2wwQdWUrlZyMlpSEiaVaqRAAnRi/q+wi0SQ+OI39RAFbsTeo6gj+Qino/HDzr6MhVOfISFJ72LniSbllyC5heJC5NHIKo397S9PRPm1LwYPFWvvlxg/HMJXpyCiHsIzMOTmNz8fGvtVBUObSCmK/TDnK/UpHp+NXZoPPHcilhMtdRN2VRAWS++GtHGtf0ALK7oGhPNmbDGVlEkSv0veug7dWyYzfeqesraGDx2hS/efuC+E3NoaVJfEtldIH8t9Q4Z8atmd69mTuacsVORw29WWjDvyiRXx858pdxLrIqEzIRUYX44UzG5ENAmdj+RbN/5VG2bndFiWtW4bmE0LlYwZ4ZhybsCsbF7FgmzOXpJgsc0ynpqmnetxOAlqpUcH4KMolsuhBahuE1ENTIgUB4JOkLpcKHtDXH+2qTJ/QuZx+6xdcPE3+SWap/msAWqdBcuJylgtBGNfZEytDrxYS5OvCJkJlYZraP8h+7tKk3qL9VRKkRc08UP9cD6EA/MzKYBK0mpfFxoi9qFq9V/t+IHLf1u9nR8/RruEGU66xYvGZKgfg/Eu9MQtXymK4l9JUVe6KV1wC6xIHMKKpFy9RmAtgfh195QYCi+QbBuIpF7BTy3aah/lWDOrseFvmmQiqCAGpAeERvUaiK/Efq2pwtBm09GgPDZ0c+Adi7vr1koomwyqQ/j1al2GhtHFUW4rzWKEK58NOk1MNKBLwR4D6sU3hygj17DBdCoWIGAPgcPjWOvRM6j6AI1OQeqUvjOje8GfB8QB+W3f5z9mRkUBQ+wyCFwwRdZnP4YsU2IeQ/IyzsQfjlMb22zSXhOEI4aPmxydwUZQSQ/wGGpKeX4nfphhGpnewYIlVipe5BOJ/tQ38h5lgKizT06F0g80BAMLjkt+Fn/uRwM6jC30DdsUKaNPjhW1wv
 q5qrns53
 P4qF11OBLDrII9rkuFQ+gffXL/cWuzwNzdaINQIW45VIYtkvu1GJrpOujOH/AA98caC6U2c36mNoxVIlIxwCMAOKUrUWahKWWPhdmsFdUy5t4Aj3CxWxcol1mlyGaJ6nsYHNh86rc7b2mpWpE+1tpdICv3VMaJW7bYFevKXUM2oUFGbZCw+B4nD58Hfx8ryMq+5489TofcdsaYvgn5jGjAUKQdLRVwWN8AYUTrB+MOTH4j1OWT3RReb0RC/xDusFq9HeqdeOpHikwJjBQ4pwX3G0cLfmrRgA5FfYqRRGqQLbHw8XBHCQr1H8gxpzgVIZ1eSzwCNDLba057gYDoXwJzMluqN3bXtKmuqF6iJ4XN2HYAIR6ewhWoZedsfedCaO3N5OSQaCDHcMS0m98u/G2fLK+iOs81/J0DqTfupwZ+61SB/wkKaELkLTwKGrlyLETKYGQO00IL8i47ND4aeBzaRkiD9aJj+lAEUmY8Sag/F2Ddz8CkBLtvr81jxpcY7sLbopUfbG9xnd3JlsXZz8XBWyObwx66KmRctlsXfq1CUXRVBLaYxAi8rKzF3g6Y72R4w3smuSDLhER2jnC6N+IpOm6/xaDRBCI2G4wsdmsxGkuP0ELOKievIVNUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000078fae6065081ab3b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for pointing that out.

I=E2=80=99ll take a closer look at whether mapping the file descriptor dire=
ctly and
initializing the mapped area would be a cleaner approach here instead of
relying on write().

If mmap-based initialization works for this test setup, that would indeed
avoid the partial write handling entirely. I=E2=80=99ll investigate and sen=
d a v2
accordingly.

Thanks,
Vineet


On Tue, 28 Apr 2026 at 13:34, David Hildenbrand (Arm) <david@kernel.org>
wrote:

> On 4/28/26 08:23, Vineet Agarwal wrote:
> > file_setup_area() writes initialized test data into the backing
> > file used for collapse testing, but it ignores the return value
> > from write().
> >
> > If write() fails or completes only partially, the test continues
> > with incomplete file contents, which can lead to incorrect test
> > results and make failures harder to diagnose.
> >
> > Handle partial writes by retrying until all data is written and
> > abort the test if write() fails.
> >
> > Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> > ---
> >  tools/testing/selftests/mm/khugepaged.c | 18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/mm/khugepaged.c
> b/tools/testing/selftests/mm/khugepaged.c
> > index 3fe7ef04ac62..c13f06758750 100644
> > --- a/tools/testing/selftests/mm/khugepaged.c
> > +++ b/tools/testing/selftests/mm/khugepaged.c
> > @@ -369,7 +369,9 @@ static void *file_setup_area(int nr_hpages)
> >       int fd;
> >       void *p;
> >       unsigned long size;
> > -
> > +     size_t remaining;
> > +     ssize_t ret;
> > +     char *buf;
> >       unlink(finfo.path);  /* Cleanup from previous failed tests */
> >       printf("Creating %s for collapse%s...", finfo.path,
> >              finfo.type =3D=3D VMA_SHMEM ? " (tmpfs)" : "");
> > @@ -383,7 +385,19 @@ static void *file_setup_area(int nr_hpages)
> >       size =3D nr_hpages * hpage_pmd_size;
> >       p =3D alloc_mapping(nr_hpages);
> >       fill_memory(p, 0, size);
> > -     write(fd, p, size);
> > +     remaining =3D size;
> > +     buf =3D p;
> > +
> > +     while (remaining > 0) {
> > +             ret =3D write(fd, buf, remaining);
> > +             if (ret <=3D 0) {
> > +                     close(fd);
> > +                     munmap(p, size);
> > +                     ksft_exit_fail_msg("write() failed while preparin=
g
> test file\n");
> > +             }
> > +             buf +=3D ret;
> > +             remaining -=3D ret;
> > +     }
>
> Why are we even using write() instead of just mapping the fd and writing
> to that
> area?
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c
> b/tools/testing/selftests/mm/khugepaged.c
> index 3fe7ef04ac62..a77f753ccf38 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -381,9 +381,10 @@ static void *file_setup_area(int nr_hpages)
>         }
>
>         size =3D nr_hpages * hpage_pmd_size;
> -       p =3D alloc_mapping(nr_hpages);
> +       p =3D mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE, MAP_SHARED, f=
d,
> 0);
> +       if (p !=3D BASE_ADDR)
> +               ksft_exit_fail_msg("mmap() failed while preparing test
> file\n");
>         fill_memory(p, 0, size);
> -       write(fd, p, size);
>         close(fd);
>         munmap(p, size);
>         success("OK");
>
>
> --
> Cheers,
>
> David
>

--00000000000078fae6065081ab3b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><p class=3D"gmail-isSelectedEnd"><span>Th=
anks for pointing that out.</span></p><p class=3D"gmail-isSelectedEnd"><spa=
n>I=E2=80=99ll take a closer look at whether mapping the file descriptor di=
rectly and initializing the mapped area would be a cleaner approach here in=
stead of relying on write().</span></p><p class=3D"gmail-isSelectedEnd"><sp=
an>If mmap-based initialization works for this test setup, that would indee=
d avoid the partial write handling entirely. I=E2=80=99ll investigate and s=
end a v2 accordingly.</span></p><p><span>Thanks,</span><br><span>Vineet</sp=
an></p><br></div><br><div class=3D"gmail_quote gmail_quote_container"><div =
dir=3D"ltr" class=3D"gmail_attr">On Tue, 28 Apr 2026 at 13:34, David Hilden=
brand (Arm) &lt;<a href=3D"mailto:david@kernel.org">david@kernel.org</a>&gt=
; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px=
 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On 4/28=
/26 08:23, Vineet Agarwal wrote:<br>
&gt; file_setup_area() writes initialized test data into the backing<br>
&gt; file used for collapse testing, but it ignores the return value<br>
&gt; from write().<br>
&gt; <br>
&gt; If write() fails or completes only partially, the test continues<br>
&gt; with incomplete file contents, which can lead to incorrect test<br>
&gt; results and make failures harder to diagnose.<br>
&gt; <br>
&gt; Handle partial writes by retrying until all data is written and<br>
&gt; abort the test if write() fails.<br>
&gt; <br>
&gt; Signed-off-by: Vineet Agarwal &lt;<a href=3D"mailto:agarwal.vineet2006=
@gmail.com" target=3D"_blank">agarwal.vineet2006@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 tools/testing/selftests/mm/khugepaged.c | 18 ++++++++++++++++--<=
br>
&gt;=C2=A0 1 file changed, 16 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/s=
elftests/mm/khugepaged.c<br>
&gt; index 3fe7ef04ac62..c13f06758750 100644<br>
&gt; --- a/tools/testing/selftests/mm/khugepaged.c<br>
&gt; +++ b/tools/testing/selftests/mm/khugepaged.c<br>
&gt; @@ -369,7 +369,9 @@ static void *file_setup_area(int nr_hpages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int fd;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0void *p;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long size;<br>
&gt; -<br>
&gt; +=C2=A0 =C2=A0 =C2=A0size_t remaining;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0ssize_t ret;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0char *buf;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0unlink(finfo.path);=C2=A0 /* Cleanup from pr=
evious failed tests */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0printf(&quot;Creating %s for collapse%s...&q=
uot;, finfo.path,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 finfo.type =3D=3D VMA_=
SHMEM ? &quot; (tmpfs)&quot; : &quot;&quot;);<br>
&gt; @@ -383,7 +385,19 @@ static void *file_setup_area(int nr_hpages)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0size =3D nr_hpages * hpage_pmd_size;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D alloc_mapping(nr_hpages);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0fill_memory(p, 0, size);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0write(fd, p, size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0remaining =3D size;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0buf =3D p;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (remaining &gt; 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D write(fd, buf=
, remaining);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &lt;=3D 0) {<=
br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0close(fd);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0munmap(p, size);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ksft_exit_fail_msg(&quot;write() failed while preparing test file\n&=
quot;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0buf +=3D ret;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0remaining -=3D ret;<b=
r>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
<br>
Why are we even using write() instead of just mapping the fd and writing to=
 that<br>
area?<br>
<br>
diff --git a/tools/testing/selftests/mm/khugepaged.c<br>
b/tools/testing/selftests/mm/khugepaged.c<br>
index 3fe7ef04ac62..a77f753ccf38 100644<br>
--- a/tools/testing/selftests/mm/khugepaged.c<br>
+++ b/tools/testing/selftests/mm/khugepaged.c<br>
@@ -381,9 +381,10 @@ static void *file_setup_area(int nr_hpages)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 size =3D nr_hpages * hpage_pmd_size;<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D alloc_mapping(nr_hpages);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0p =3D mmap(BASE_ADDR, size, PROT_READ | PROT_WR=
ITE, MAP_SHARED, fd, 0);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (p !=3D BASE_ADDR)<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ksft_exit_fail_msg(=
&quot;mmap() failed while preparing test file\n&quot;);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 fill_memory(p, 0, size);<br>
-=C2=A0 =C2=A0 =C2=A0 =C2=A0write(fd, p, size);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 close(fd);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 munmap(p, size);<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 success(&quot;OK&quot;);<br>
<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div></div>

--00000000000078fae6065081ab3b--

