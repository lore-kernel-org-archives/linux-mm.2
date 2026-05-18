Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD8FCD4F50
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 054236B0005; Mon, 18 May 2026 14:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006186B0088; Mon, 18 May 2026 14:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E373F6B008C; Mon, 18 May 2026 14:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF5AB6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:38:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 782BB14093E
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:38:49 +0000 (UTC)
X-FDA: 84781401978.03.5097500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id 904F21C0010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:38:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=flxIdtIC;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779129527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOt/t70tyLkQtU4DfTJKh7Bvg0l44HHd46RsE6w5vr0=;
	b=ExgXAtB6q7LvNdOiOsC57wckaFLSv+4li+8gj5HfZwys7aBTKqZTGaV6sJFsOJWzEjL0f/
	nxesr/UixdV+ZDWpx+TgvNmG+X9WiZnC9UCp9mDbXli+McxE7LawM8MEEKt2Ad6KzcqjRh
	5CQVS964eE0tzZUhX2zP0Vz4obN5ptQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=flxIdtIC;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779129527; a=rsa-sha256;
	cv=none;
	b=cd/nWtOsgibSSZ4Eo4AiOFSSGCOf8ReU1VOYGiKm9da5VOnggCkU4FRJfJ4jgNLYu9iDKs
	PeAXChuEOr1poSWKNIK97Qzz2Z6e9nUCXkOJWR9Q3I72vdXNiOeoulH/4zpTBZsGiO0l73
	9PAeE/weYWNY+p8RGwt+pIgzKIbEut8=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-45d96d21e82so1556418f8f.0
        for <linux-mm@kvack.org>; Mon, 18 May 2026 11:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779129526; x=1779734326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MOt/t70tyLkQtU4DfTJKh7Bvg0l44HHd46RsE6w5vr0=;
        b=flxIdtICzCG1igGuLzljy6iQkhz6R6FTQpeD5gt/7aIgm1uJf13L7ztKaR5zHWH/Ce
         310rJngKRxjCewbSv/fcD1TFYWAeOCPz/vOqC6KpHs90hsLr45KSwKM3NGpHJ2KheU/Y
         xSu0/fu9nsW1tqcj5RcvRF08eUyglOnD5naIf0ey9dW8StOy7cvZju5TiuggjGUsuBJ/
         gov+ken7yLg3WmQQnsUravyc9EET5u6ZbXxCvnszwe+EOJsWZK4nX7XOCiJj32wQmjYS
         0l0GUVPONycW1+i9x97i5XQ4NQEgsizlOdKcavXGdwDsvFhd2ZqLT6bZKUaHWAXC05bJ
         MrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779129526; x=1779734326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MOt/t70tyLkQtU4DfTJKh7Bvg0l44HHd46RsE6w5vr0=;
        b=XcDkpe8/3E43TvtW/tRZsywfTwxwHplExXJN2s2eGvb1Z2yIT0HkwDIxKgp2FkO7XW
         50NSIRDRj7yl44HZKuTPHiqeuT5pjoWUN00fB5f2loSOxhOmdieCek1UHOudNltCSC9W
         ssSaRyUBMXRZ9ba+TnKE2qMeE2Kmgs88X6PCvZzg8c2AWVqK4Mb4dqty32HSc3v44rsM
         ZyD5PQhhqBfNdQ8Y5iNQ2sOCzAayo2bEdhRHvUBgL+w6+ga4s+GtYwxC1u6usYVfeEZA
         whpWK0hDbff6iYf5a+689qq6Bsh73+7J+oBE9dBc8Kl30wPzvplOBbuNAJw8MkE3WTE0
         tWEg==
X-Forwarded-Encrypted: i=1; AFNElJ9RG2tuN1k+DIAp8fpq/np1rOeSwTXagk1X3CltjFCVAK+OoKIANsQ9oQ9KRVrp1pMnFyy0KZNPnw==@kvack.org
X-Gm-Message-State: AOJu0YyydViJ7G0gisCUKMYqRlFnmU/dA40MXpDXH0WRmDMfz31qxMns
	M8gGsr54qZj/qFevFBPvcNmNrIiPrbjwf1ZLkoHCIzK5kauTNLnQ2IQ/
X-Gm-Gg: Acq92OEJ1iMFyPJ41QH0AJFxUqw2QxiZut5H9fl5advzGfb8zTEPbgiF9fOd1+1yO4b
	Avx0nNJcDMNZtnNnhk5NKDbGinoCecZJyJ5m9wk4+yyvggr6Ib73NT3DsB1oziI3k0tiKrB5fZV
	aBj0NSZ2DEySZo6Ni3nD1vj2FCyMPwZesu9Rdas7aZ9d3DXq9E0OGXUsaXZmWm4AxEg52PdZfx2
	pP6pK5cKqFN3Ch7lqRHTM6cFeXfKxS/9CuxrQhw0xMAIxYJxB7m5J+hYmeB8seCRieXigd3/ZFS
	aqy65UlM12u58CBopbObdVValO5Bxpf9VnqYo34+ES+ouCpC4BIUgPOriLhUrB1diLCvSJ+MVGR
	SbtKQZSG/modL026ZoygHUS1CpNX78FH+jiCFG8czmVSYUkzWiC2eY9PmtxZLjl6XYFHOg0rEoA
	uZBvOmhzi5xNZu2pmjdwVOFrz4YZBE/dheTKn1BNzgRgT7BnlDr16Dn3WarVw4glQM
X-Received: by 2002:a05:6000:2305:b0:44f:d9f8:c0e7 with SMTP id ffacd0b85a97d-45e5c58fe85mr27071250f8f.5.1779129525728;
        Mon, 18 May 2026 11:38:45 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e768072sm38782922f8f.5.2026.05.18.11.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 11:38:45 -0700 (PDT)
Date: Mon, 18 May 2026 19:38:43 +0100
From: David Laight <david.laight.linux@gmail.com>
To: =?UTF-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>,
 Steven Rostedt <rostedt@goodmis.org>, Christian Brauner
 <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Shuah Khan
 <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com,
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com,
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>,
 linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org,
 linux-api@vger.kernel.org
Subject: Re: [PATCH 3/6] string: Introduce strtostr() for safe and
 performance string copies
Message-ID: <20260518193843.7bde8d53@pumpkin>
In-Reply-To: <d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
	<20260517-tonyk-long_name-v1-3-3c282eaa91e2@igalia.com>
	<20260517223419.3262de7c@pumpkin>
	<d4d6cf61-568e-478e-88d6-01b769d7eded@igalia.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3pwhpkd1fc77gt34ixrt45iygtkfakk1
X-Rspamd-Queue-Id: 904F21C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779129527-887264
X-HE-Meta: U2FsdGVkX1+pRBfi0JGh5NC0/GlaVEx3ueR+gn0yowlyiP9NbPf8sZHh6m2rvUOb67HNpxYdgfnilQf8x+0O9JZo8Oeg7j3zBGbul/knlKkqk2koFE049Fs+9CfrRtOvjq/yLtUDbS/JYEZonqiQIgmLkeai9tA+vv+ClaePhdq60aaAbCl3vWt7by35lH4K5rQ4uwWd2DW+hvOumd+ll8+rtvoDc4ocTuEW1lBHrKYXZifLIvqtufbW9pgNB5Xd4Adi6AGOdHlA6M6mJw4xxniKSacOlgyHLpLTPdV+yKXwfDPcadr9wxMSpY5DCoJus4FIM/yHclqT7sgkwfkUhvoHqQkkuIROL4EVyOsqtqDqPIF4VKbXsXAmxo+Cnr9i3gI4gXNIYAa6ZfHem/04s2JIBFhTE2+Yhu5ia6IUtb4irF8zYgd+OIUZnW/e31mjclKM0iTndox/ETjbeTH3F35gohsQ6K9Xymy2aLdrn1ZgxJUOnpkFVyapQtPDfLdXeRqdjGidQEs8nxN0NMriJKP4iL0uZmiZBWkGA/3Ch9uHJHZvLuuE6V4QRTUIswYrybO5HIbvQ5whtagz2/RaJCnct9k04wvNFqnTTNhm7ThX86IPwG2abwUL83/0rrBAAX21XCXHBWTZCuaPiEw9MUrlYwarOiHvs9RTcy+4RXSCrmUfeL2Gd3pQ04Km7ggKJpP7/7MRt+xjsFUDJwyh1LNgWBIPg859Mh9HxvpU/LFxbvH2XyuZ4BQRRwTMsQfj61OxPz4N0oEkAgXpqrRyW/qCIpmUnYwu2EQBzf0IXk9wCyJlCdOdNkL6w70jbjARo5wbDnPwM+E5PRIJWrfASDY1oHg0JRJhufeBwamZDc9DjJiG06FKepdvk3klHLW+HUqiS7F2rWWPDCMRdzC5uX7rCfxxgD3Cc0I2/BcxZLxfgmfagu98nOJ88ILBLB+nizilLd5NiIt3r6UX7CM
 weVqf5hJ
 L0BIKDHISweD9G4Ag+N+1llWA1ej0C5vsrRYTQQZhYG7Iy55cKV21LhnH3+JhT8s234QrbyEi5huabTzG3CchB9VOsLIolYiHaDFiJDJsyfqEFsOnWAyBfAXbeGQM2W2AXU0rp2VFjjKV4vdXNODetsZu7zdxyG7xq5Ja8JCja4YyvyeryOFcsbZ/m6K3NFX+wH0LBj/42DIcpAW+/MJ8QPlqP8tFE5Tq4QeSUB01HP4tVAjCDyBigCoMeEmOje9MIS/qxjAIVLCaFIEWlo/zE4+/Xi48QQfAktoSGj9zDTzU4+yaNF/8LeHMe10iOxXZFED0+j+ALWB5I0jh1+IQqiSZzDqxQX15+GvRnvyVOveyKxbcK1LcuvQUY4lQ+jcVYdH1ObzVZMof0P5PR7ZeYCq26de8+JOAF9ePEubErY3iixUjPc6ZnLXLQK89RnddC7rzOHmWGSY0aB7X+j279/kCT+ErA720SIrKrZhu2s6NE+QuVUhCC/xc+G0uvfWkGnTQJJ3eSTj97ljU8Cv33n+Uf7eqXJv3QVv+IVlq2xEcRNdzVa9ipC0KwfETRj+metReIVYvvb6cCsKUsSqA2nuMwOEYPMX8Xp7IE4+Frn4kjvfGp7ziDn2k2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 11:36:49 -0300
Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:

> Hi David, thanks for the feedback!
>=20
> Em 17/05/2026 18:34, David Laight escreveu:
> > On Sun, 17 May 2026 15:36:13 -0300
> > Andr=C3=A9 Almeida <andrealmeid@igalia.com> wrote:
> >  =20
> >> Some parts of the kernel uses memcpy() instead of strscpy() because th=
ey
> >> are performance sensitive and doesn't care about the return value of
> >> strscpy(). One such common case is to copy current->comm to a different
> >> buffer.
> >>
> >> As the command name is guaranteed to be NUL-terminated in the range of
> >> TASK_COMM_LEN, this is safe enough and doesn't create unterminated
> >> strings. However, in order to expand the size of current->comm, this
> >> expectation will be broken and those memcpy() could create such strings
> >> without trailing NUL byte.
> >>
> >> In order to support a fast and safe string copy, create strtostr(), to=
 copy
> >> a NUL-terminated string to a new string buffer. If the destination buf=
fer
> >> is bigger than the source, no pad is applied, but the string is
> >> NUL-terminated. If the destination buffer is smaller, the string is
> >> truncated. The last byte of the destination is always set to NUL for s=
afety.
> >>
> >> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> >> ---
> [...]>> +/**
> >> + * strtostr - Copy NUL-terminanted string to NUL-terminate string
> >> + *
> >> + * @dest: Pointer of destination string
> >> + * @src: Pointer to NUL-terminates string
> >> + *
> >> + * This is a replacement for strcpy() where the caller doesn't care a=
bout the
> >> + * return value and if the string is going to be truncated, albeit it=
 needs
> >> + * to mark sure that it will be NUL-terminated. Intended for performa=
nce
> >> + * sensitive cases, such as tracing. =20
> >=20
> > If you care about performance, and the destination isn't smaller (espec=
ially
> > if the sizes are the same) then just use memcpy().
> >    =20
>=20
> The problem is that as I'm expanding current->comm, the source buffer=20
> might be bigger than destination, and when we truncate the string, it=20
> won't have the termination NUL byte. So we need an extra dest[len-1] =3D=
=20
> \0 after the memcpy.

It depends on other access to the destination.
If it might be being concurrently read it is vital that it is always
terminated.
So you can't even temporarily have a non-zero byte at the end.

>=20
> >> + *
> >> + * If the destination is bigger than the source, no padding happens. =
It it's
> >> + * smaller the strings gets truncated.
> >> + *
> >> + * Both arguments needs to be arrays with lengths discoverable by the=
 compiler.
> >> + */
> >> +#define strtostr(dest, src)	do {					\
> >> +	const size_t _dest_len =3D __must_be_cstr(dest) +			\
> >> +				 ARRAY_SIZE(dest);			\
> >> +	const size_t _src_len =3D __must_be_cstr(src) +			\
> >> +				__builtin_object_size(src, 1);		\
> >> +									\
> >> +	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||		\
> >> +		     _dest_len =3D=3D (size_t)-1);				\
> >> +	memcpy(dest, src, strnlen(src, min(_src_len, _dest_len)));	\
> >> +	dest[_dest_len - 1] =3D '\0';						\
> >> +} while (0) =20
> >=20
> > That doesn't work (for all sorts of reasons).
> > _dest_len can be the size of a pointer - no array check.
> > You need to use __is_array() and sizeof () for both dest and src.
> > You might have meant to check that _src_len is constant, not _dest_len.
> > You must not leave the destination unterminated.
> >=20
> > __builtin_object_size(x->y,1) is also entirely useless!
> > If you have a pointer to a structure that ends in an array then the
> > object size of that array is SIZE_MAX (as if the array continues past
> > the end of the structure).
> > See https://godbolt.org/z/csenjfvxe (which I happened to prepare earlie=
r today).
> >=20
> > __builtin_object_size(x->y,0) also seems to always return SIZE_MAX.
> > You do get a sane answer for (x->y,3) on recent clang - but nowhere els=
e.
> >  =20
>=20
> Oops, you are right, thanks for pointing that out. This is how it would=20
> look like checking that both args are arrays and using sizeof to get=20
> their length, if it sounds good I can apply for the v2:
>=20
> #define strtostr(dest, src)	do {				\
> 	const size_t _dest_len =3D __must_be_array(dest) +	\
> 				 sizeof(dest);			\
> 	const size_t _src_len =3D __must_be_array(src) +		\
> 				sizeof(src);			\
> 								\
> 	BUILD_BUG_ON(!__builtin_constant_p(_dest_len) ||	\
> 		     _dest_len =3D=3D (size_t)-1);			\

That test can never fail.

> 	memcpy(dest, src, min(_src_len, _dest_len)));		\
> 	dest[_dest_len - 1] =3D '\0';				\

You are expending 'dest' twice.
Where it (p++)->array then the two values would be different and the final
value of 'p' incorrect.
Much better to assign both pointers to local variables.
Here you can use their required types to get type checking (I wouldn't both=
er
about the extra checks that _must_be_cstr() does).

I'd also create function that is explicitly for copying process names.
(Or replace the one that is already there - saves a lot of churn.)
then you know (and can check) the sizes are the expected ones.

It might even be worth making the #define (needed to get the array sizes)
call out to different functions for the different cases.

Thinks more...
On 64bit the 16 byte copy can be 'load; store; load; mask; store' provided
the buffer is aligned (copying u64 on 32bit will work the same).
But that requires that all the buffers be aligned.
So you'd need to check _Alignof(dest) >=3D _Alignof(u64) as well.
(Probably with a fallback to get things to compile.)

Whether that is best for the longer 64 byte copy is anybodies guess.

I also suspect it would be best to zero fill when copying a 16 byte
name into a 64 byte buffer.
(If you zero fill first then you can just copy 16 bytes over.)

-- David

> } while (0)
>=20
>=20
> > -- David
> >=20
> >  =20
>=20


