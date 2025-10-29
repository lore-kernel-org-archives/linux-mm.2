Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 944B2CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 15:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F000F8E0088; Wed, 29 Oct 2025 11:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0B98E0045; Wed, 29 Oct 2025 11:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDEA8E0088; Wed, 29 Oct 2025 11:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD50D8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 11:24:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70D8E5A0E5
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:24:52 +0000 (UTC)
X-FDA: 84051524424.10.2A3C23B
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 800A9180006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:24:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IUA9VMgi;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761751490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2iJ+gYl0WvAKtN7IryWto0AZlGcZPV36GKYmbq25K0=;
	b=nBXA/pTsFvBurp9aWKmykmCufSYBeU0R+y2sKYcthNdxh/+w2xFOxpkiQqBOzgbiMkFUrS
	e/pQYyV9MvGi53/tPXgx4IxbXDQQGzS5njfU1tp8x0/qh1T3UTNWFg4Bm5jPmxd7gjMCF2
	0DAepHyk4IYjeCo5jvmL8opj3yVzzgk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IUA9VMgi;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761751490; a=rsa-sha256;
	cv=none;
	b=HcoGYjOOM4LawwcIA0UOso/JqWdOmT7RT2fJOc1vlf0tfgY3Cs6E5EW9UeK+e7gC0FvuVP
	ZBewLWT2e0WugFsK2REceT6F6cbP+MWGUz8MZQXqlArHnR9LknXzXowuyl5xoDPurdgPXY
	6HdNTKtBFRB08pEwNGHz4n9Ar5eAdnI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c44ea68f6so12826a12.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761751489; x=1762356289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L2iJ+gYl0WvAKtN7IryWto0AZlGcZPV36GKYmbq25K0=;
        b=IUA9VMgieSpj9TicV5TTgX5RXiip80leMyPT3gHXcrAJCKEX3shz93Y1K9pE+eFquD
         TV9dVIpS4JW8Vred74gOt+BiiytRW2Q2aOq3I4ahczhF4mYJbnppWNfuDlNJVFZ3cWyS
         iZ1gVedxnxK3dRkJ7qGTQoNDE9qYX4h7btHG/1mijhbe0ynNA9/Br9n6/dJ2LHX55xAI
         4t+yf4Az7hv6Xk44J7Y/ur4ZMgOmL274la6N9oKTk2omSzIYHAIBVwkSRxbboko2lVQT
         pnYVUTFFQ7iNrMsZy6+YhSJIIU1Ily7hR4WYihnjsHX2zsKfbrXCsQGspRF0IPEFvGBg
         o7jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761751489; x=1762356289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L2iJ+gYl0WvAKtN7IryWto0AZlGcZPV36GKYmbq25K0=;
        b=uVSIgZYJQpb7C8qwRgIg/8YV59oYv/spRLMhHZ4EYNlZkQr+gLac35XDYHeuSoZiXw
         14JmdtjDe7+L9OLg5L260ToxKjAaBhyP/2X6qqIz1F6xw9FMQS2chqyzDrLJedXOFbaX
         vhzuU4zIUSUsJSZjns2r6ROPk/M+zQEWJU9KTgyYCEa2R5D5Br5luZi2OlTBli+5INE7
         kvPNfbmONs97saoHuXfwXvOe1eXLCp8Un/TOG9YAGq+quwT/fBFlWGmfpYysGc8LNEM7
         zlH8aBC+sRM/YVAxajB63LLoFYI2AJS2CJBM1eRp8Hao/D2Q5/zAyJL5OuPc4TMOif5D
         gEkA==
X-Forwarded-Encrypted: i=1; AJvYcCWuU6JSVC6u8HotNaANIq/X0t74zdug9ZlNC6Inu/iSKIDXeSQGcqSpPsasm+ZZ4gwjUGRFtnbVNA==@kvack.org
X-Gm-Message-State: AOJu0YwpHoE6L48D9QmUCwVodT4Q8fR06gKYe/wZmSxGx56HA5s46eCd
	YIkKhYYuhMqn7jHKg6jbruKFBpehgXkBnYm3bPQIzAq7v4p7F+FYs3WySgyfomtyfzX2s3TBzBX
	Pcd2O5DcSZMTF5iDs4g+3q4J3P8fmZWinHvdI0Tbp
X-Gm-Gg: ASbGncv6j92ggCxnYs0wD1uLe/xNKjr5dGLEZH9y8ku7WAyfKK2cO4vR0nOYDIXeuQS
	IdOu0OipjCk6QCL8hIU9TtngTZKloipBTZimTdrxw4Tz1anqazcwSinBKf4jEOojiqNACH+/+cG
	WNA8VnqNHA3WTsiotdIjFPsXD01CLESviKHpVRC7MumwYNMP/w3QUv0cWKLv/YL4ZOiAOsrGeu3
	Lujqzb69mE9EmvcIaVHHWa2EkU6peXjncsGYnI9n+oJjQUnKe8mq4HnlY5/mCpmgPgLBVYwW6z+
	3OXrhrNZNgrr0/mFsFdMTHPTzw==
X-Google-Smtp-Source: AGHT+IGU+esMxf3ccvuz4aU0iKC9IRrUhCYYRzaNs+SjfV5pALSJtfH3UmgORTtgzOclQeamunCFAq3K9fIJ6y1muIQ=
X-Received: by 2002:a05:6402:24c9:b0:634:90ba:2361 with SMTP id
 4fb4d7f45d1cf-640452b67b6mr123042a12.7.1761751488647; Wed, 29 Oct 2025
 08:24:48 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-4-harry.yoo@oracle.com>
 <CAJuCfpE9PRvd1Tsm6gAvxKvPFgVt640q3vSbt0wAWOa3G4tnfA@mail.gmail.com> <aQHVB_8NVMZ2cuvh@hyeyoo>
In-Reply-To: <aQHVB_8NVMZ2cuvh@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 08:24:35 -0700
X-Gm-Features: AWmQ_blnOhRrDyAN8bKG9PnCSCcBONfyThj1KPKRqtofem1VL-BK-gJoV4GKMAw
Message-ID: <CAJuCfpGFPuoUceB7SvAJPtVvzOOCzqS50yCcjbuMxV2a0e0KWA@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/7] mm/slab: abstract slabobj_ext access via new
 slab_obj_ext() helper
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 800A9180006
X-Stat-Signature: bqytrnuagp9pw633mjj36w4rjjzidnt8
X-Rspam-User: 
X-HE-Tag: 1761751490-710735
X-HE-Meta: U2FsdGVkX181IAOZV7De5JCbczTlZFVYJNXVvg7UGBKB30iy++jcITxht9lYN/epCm4ItHkBxxllTTzZmHK3fHB7ZQl28gG1MTsUZA0n8gH2pOk4OM+V2UiAsHvLFt2ScaAAr5xX90BX3n8QRlQ76G6LztGuEhZXOPeTTvyTZMticl1vA0wB1oc9i9uTbd88P09D5o5v1DaaWvLIICYs/kh+Y6qzS2FjSUK+Jf/3lh0eNtBkoAQs0U6LARcGdAlqrSjadKOS7N966tgjuXCn63t8jN3q/ngk7B34F7RbWqY1Se8sheqhuImzrkCSyhLlDk5IcNmohuB2Enz/3tk1J9tfhn1hAO/zJkwD/mlR5ZETfSgCojs5hpTS/EZASi7C6nbgRDTzAbp4lXyFqUbUaiFkGN6GE8k6y5iwfR5x3b67DPNJn11QKog6FerZXa8kXz2lBdXC+zJ5Od0zCXKApybJSwxSIwqBpm/NnK/8/FFoN6r3UmrbluZTclAQ8LRvTmbuONWe6QHJrOOMifqdPYht4vFmpBBpPPcS7axWeI5dwIHL/aMv6TQhiYf044bTCacRpOkM03hwLKBDgSmWzvA6owzFVHv/RidI4uEa8OmX/FasNaAOJ84tFQbuWlUKOmHurUwYysUOSt4nZZxOCDAWpoVHIYlb8/1mCWuM70RkIc0Qyqv58hOniI8wB4CMGG1pXFQNRbm95mJGmu/z/HSALWIPO50pqSE9TJ+dMR0+s/Tw9O2x4GTZGtDiq+l3cb/oG9Tvu0/5zT1K33GG56m1POOAXGPIaUmBIt4Z+X+i4Hk4cN59u16YHpn8qm2WFz+bzl8WNpTV1HbGhWl3bbuTa0EgWWv3I1hGtCh7sE+I5mLnyOJLes30exNFGKvpSg2oSDKoUURKfmcX0jmQcze98n1P0CRflB7irkGqCNOco+F4GD1eduuji/4OwnFUsribPSrdvpwn6BAbUx+
 xXPNAaOV
 ORDOMef76CdA37QbclLT6HOUtstY1l6rIA+xKRZhSz+1E1u2lpZ6F6b+G8hDjNVHgS23mgZ6m1jaK9guP4AgO5j/26moROufDH0HJH5F1Ro5Ax+Y+SDxgxKmhbWLPe8uMv54+SzUB1AmCIvw0Y7Gl3q+YyobPKJ62TwNSuR1y+pirQL/HDOg1zWytwlJebVmXGDwnWgQUberf/mLVkJLxdPhvISwn6zS9/DBrAeHo1miwbLy1aqhEsoXt3TZkBh3yzeJblcU4QpJYcpN3mf/rXNbI25skD9BkdKckwwuAHMHllj6E0IX0BTRlerJZVNfNq8tVBJl51HocqrvWzfQ+N9bBXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 1:49=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Tue, Oct 28, 2025 at 10:55:39AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > Currently, the slab allocator assumes that slab->obj_exts is a pointe=
r
> > > to an array of struct slabobj_ext objects. However, to support storag=
e
> > > methods where struct slabobj_ext is embedded within objects, the slab
> > > allocator should not make this assumption. Instead of directly
> > > dereferencing the slabobj_exts array, abstract access to
> > > struct slabobj_ext via helper functions.
> > >
> > > Introduce a new API slabobj_ext metadata access:
> > >
> > >   slab_obj_ext(slab, obj_exts, index) - returns the pointer to
> > >   struct slabobj_ext element at the given index.
> > >
> > > Directly dereferencing the return value of slab_obj_exts() is no long=
er
> > > allowed. Instead, slab_obj_ext() must always be used to access
> > > individual struct slabobj_ext objects.
> >
> > If direct access to the vector is not allowed, it would be better to
> > eliminate slab_obj_exts() function completely and use the new
> > slab_obj_ext() instead. I think that's possible. We might need an
> > additional `bool is_slab_obj_exts()` helper for an early check before
> > we calculate the object index but that's quite easy.
>
> Good point, but that way we cannot avoid reading slab->obj_exts
> multiple times when we access slabobj_ext of multiple objects
> as it's accessed via READ_ONCE().

True. I think we use slab->obj_exts to loop over its elements only in
two places: __memcg_slab_post_alloc_hook() and
__memcg_slab_free_hook(). I guess we could implement some kind of
slab_objext_foreach() construct to loop over all elements of
slab->obj_exts?

>
> --
> Cheers,
> Harry / Hyeonggon

