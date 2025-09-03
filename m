Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E0F3CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F47C8E000E; Wed,  3 Sep 2025 12:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5198E0001; Wed,  3 Sep 2025 12:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693108E000E; Wed,  3 Sep 2025 12:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 527F78E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:12:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC5165AE9D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:12:26 +0000 (UTC)
X-FDA: 83848431492.02.31560D1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id F36FD40019
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:12:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E5/nbBvO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756915945; a=rsa-sha256;
	cv=none;
	b=iEF/qouJWu8F8N0K/DbhRmr/XKcSZ7n5fLv0M5d0dlwQZJUSGzzDu2r6eJcOH3cKoF4iMX
	jSWRzg8tQdjtY60ISyimez91CIFKDI7PBATXNAiM1XS5Q/WBNKc2b5wWm0igM49ftRNk2D
	dqlIb6EiIwEqIKaUTe00Ioax2KbXo8A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E5/nbBvO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756915945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSH3Zacp/f+cickpwsilQ+TYRotewL36J8+/+EeU+iA=;
	b=Z3g5aKR+JTo8lU/BMGwUdc71TEk1YgC7QaMRxYS8dNfEQ3AHRf6AtanGBTR+DTr+qYPHTH
	BmgaLBR6G5RWVpPl3k0znO++SJRFTc9CpATEqz0iKzHIsX6ZhU/33f7rzfI658iquQUR3d
	290EXnsHrCYQbELBTePSwYf8t38jRTU=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so68461f8f.3
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 09:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756915943; x=1757520743; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mSH3Zacp/f+cickpwsilQ+TYRotewL36J8+/+EeU+iA=;
        b=E5/nbBvOQG+hsBxNjWGFMRq2MRFuz92M91cmwRzsyKQdyHlVaCWURQEtfw4ZLarUT1
         i6M1CY+Pg1mUnCD1uXWuV4GcWpHm26bd7CEKDph9zmF9buvZc+ZbGuju2s8RVvw7hdii
         JFUNRqrMO1+xdmTAdSmkwwZuDkIZx+3a1P5ymcN4Xvvxn/rduGLPMP9DCf1Gm1jKK33l
         JLZRwQcCf0kyMWC+yFdj7mjRpICYAvlK8AY0HgRaIRKxkt1D/awrn6YHdbgaxwsikEKl
         Fiqm4Uu97Lg8VeEK/cY3SignuKb9yg9QGAewGHGXTI+cTxtvq2LhbnDXZmyITVkQr5bP
         lidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756915943; x=1757520743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSH3Zacp/f+cickpwsilQ+TYRotewL36J8+/+EeU+iA=;
        b=h7ye/oB/0aZOeyUMYj/rouQJWF7Sb36j1tBbfGHWptGWJsyg0TRcCs38bAS1MF7tOn
         ueQEVqeMJ92DChMxekr5QlKTaz4hGUvXm+sDezuLNtBDrT47ie/qon1xXUwuWcI9LUUb
         ZA18v7mqVUZg9tQlRVt2Y256ViNaoY3aK1U5zv6hqBK8WXjDmnH5SJQMF2qkMJPNufHQ
         n6/DigGJW4D+r2fgGU+JBxsW+zOci7c/t4HEkLxQ2r5p8AiaL6CRj4HDqfii4R84Ynev
         4N+bewUmOXio3nyLxC9DxtT60Umay/bO7G7ouGn0QO2UVu44CvJf8G4sFwBp6PAVfl/a
         Iczw==
X-Forwarded-Encrypted: i=1; AJvYcCXYfCOlNT+ueW5jTaduBnK4pdJQwWJ9LT2BrPimnI0VvQfvSEWN865VcaCnvzqYQ1KYEKl6cGABOg==@kvack.org
X-Gm-Message-State: AOJu0YzPcDohYUOV3kj9MK4o2eB443gZfp+wxr+lCDHAKn7q94RjXQQ3
	xgzLQjUOTXurh0hJMJl4DuHKRTynX7I9UUfIFOVpWYCrv7V4tOjnJsok
X-Gm-Gg: ASbGncuX3nc78rmJ4kw+PvXACN5jOQ6Ryr63qtVVZWxeZXXg35eL0E0yK4PcaL+cyBK
	5vQWihMa4pmSBXmIpKx0YK9Ac8kjjwNQxXa6dx5yeQDphjfst9qIqq34eY2oRK09Ssabdj/bhPA
	zD/HDql7IzVpnPXvrNsf/wzHxZ3+KubbJ4RP7AJxXhbMRvP73DM7DweZzqGkHchko7rC1vrBh5U
	X7uW2SBp3H75nbP7iq3RDYVVfuv6eBECtzUQn95Tbb8fJwNLBIcI9VCE+QgKziZmlZ1xdzA/ZoQ
	jN5vvRs3MqD1Ih0YGiaGvaP/FQT4+HT2CkTYiufby1EXItFd7ejM6lTw5hViHN4LxYGyACgFvyq
	eQ2Of1tGQIrZFCPss4ntuEJFYN347awB3MB32bqM/jEdlQKAZA9iafohXazdaaJev+i7+1X2Ccb
	dTAn1/I89ts9mOrrnsDJE=
X-Google-Smtp-Source: AGHT+IHY1b3uufepgZb7f9ysqZmKK+/Hd8xA7Sv2qwFfaxBcYfbZY2Np9JxcRK+tnTw30ZuHhEZrcA==
X-Received: by 2002:a05:6000:2410:b0:3d8:e1de:7e4f with SMTP id ffacd0b85a97d-3d8e1edc849mr6275167f8f.21.1756915943185;
        Wed, 03 Sep 2025 09:12:23 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34494776sm23960790f8f.61.2025.09.03.09.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 09:12:22 -0700 (PDT)
Date: Wed, 3 Sep 2025 18:12:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Frank van der Linden <fvdl@google.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
Message-ID: <g34tb2ontlnazift3sik5dqs75a7k2bhzo74kknkxoegv4q5vb@jsqo7v6awovf>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-4-thierry.reding@gmail.com>
 <CAPTztWa7kcx8bBEJEKvnjcD4v1-eDLVxMd9C10XiBQi4CDLfHg@mail.gmail.com>
 <e513c127-d4f4-4e93-8d4b-23d1e4fdceb5@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nfbiwxgfuwekt25w"
Content-Disposition: inline
In-Reply-To: <e513c127-d4f4-4e93-8d4b-23d1e4fdceb5@redhat.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: F36FD40019
X-Stat-Signature: wkjfgek4y6ohmqj1bz77beeo3i6nb8c7
X-HE-Tag: 1756915944-134284
X-HE-Meta: U2FsdGVkX19CTBDki+RZI0R0gpxEQBU2mmXIC7MN1PQ9ChHnyunSqwVBG93jNO1A0ULdg16tLTTq2dkjwKhOmn9+DRAczTtmYjcaG3ROtjaWjSTieU+Dvb80E47dEKoe16NDGDjau3JojCNY3AaWscGe7nYFHAUfZAjvvIKuBOqcSqHB7ExMVYjMb6O7DGheFmolpOKmp0hTNZ+n0DmfnZpnWPjFT0JccAAfYbTM7B4jigTNHbi/adO1lo2/hTjWXq0j/GEGYaDFKtDcGVasJn6ptFDv7zecgL4TqRYtG/TAt47/K/6YCOZmABJ8rli1ecE1OkjgGMP/6z+fRL1tnjZkWO7iL7T5UqDxALOwQi4R07U13qlMmhfDknPrcEvp503E54LBgzf+up640SMHbfH7WG/3SV7Ar0YeewNeJ18aPS7zVJVpv89hdpyjSZnKASejeKmEPwxNqon7QzebX3RsZ2qo8l/HbFOQ0Ao+ZBLhnZk4gt+hhTdbJ46gUr7d3cmLncCUDlPJ6XgQ8rGgPZQEo69KtEvTQgPSeXZRGQk2iT67KINfoVSOpF6vUY0MBRmCmT8mz/XiztnusQq4wP+OpxNGWKNh8voHUJJ+xZJHdOJD7dXQy0Pxfn35vfhhR3B8yMjNERmsHY/NGPfTRtdZheE6m3Mzp+JfeRDubtKSJ/6VC8ccEffr1UWIYrw3kFBnHAhn/xhjjLDXr1c0isKzBVEUDoFCHn+8cMQ506hdv0Q5Z8LhiGKC2ryJqpqzeDBmRA98q4tfSFIfFvSeJIVpfQ86uKBlr3q47x5F9rCJLf+hfpSaoOjap8QmYfxzb5vGy/nvoCCBDwa15zDP0Rni+SY8uFMPeZYUXNVRCz3Fx4USTzylFVrDX1F+zDt/g9DSLm1k13LVuxxYVIguOU3IAwV61+37+JNy5ucEd41Wb5XPIeUf2CtS24mcQiWIIJHqcUJl3gBT6SyfyJ7
 IQ+oAxrN
 JnYNenH8YVAZExt2liXAmnAcHQ+1ssFLbw5TxVNrwUd5FvDdKA/Out/1OaAOJe4qyhRKI1Sszum7iR1oTnrZeu1v+I25GsPubLHSiqXxISSL9X1sngJu5N8RDdNTkcbiokhUad9h8a24b3bz40haLvlfA4ySxR4wlZplWSGx+m4a85WtOEp255BgTs2U8z9mk/LRcMNwi84vcGXnmRjk15jQHI5JFgcd/4to6BtBU6jsDBJGu4VETDlJIpumV8d0hZulAGW7QsAsml50orNmi6JY+2E609jcmronQfuXLFxDe22xBBgYSNCfWEwemAluOYwzNG4qq29pX9QDv9M9OwI4hKnaQpCRv75QfXKEJ5/2HVJHKKLrkr421ul3Z0d/9dHEQf7AgeAvGr5fegx/12dYeHruTsvBKMphL9R9GKDilKfcCVSctv/3B0omhJSJ4TAWBX6wgcYonOushkYGqwrQ6uIn7XGWRYwkbJAHe5VXyZejU3D6p79XjWVuk8CpPQFVgrfAcMqDwbFfATc7IvLCFkLa8YSjiChBPpTfhUZzZ2ZlGJh+EhBxpybb6JzBhaMg2zB9QrVLo1f8RusB1MwOuKXC1zrzJeYo3f8Tsj05xK84bbNDEQKRPSnVm71Q/s8fIoAxqHwNW9fgzZ+q7q0OWjHE2l7fcNMPmmYnaVFoTRc0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nfbiwxgfuwekt25w
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 3/9] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Tue, Sep 02, 2025 at 09:04:24PM +0200, David Hildenbrand wrote:
>=20
> > > +>> +struct cma *__init cma_create(phys_addr_t base, phys_addr_t size,
> > > +                             unsigned int order_per_bit, const char =
*name)
> > > +{
> > > +       struct cma *cma;
> > > +       int ret;
> > > +
> > > +       ret =3D cma_check_memory(base, size);
> > > +       if (ret < 0)
> > > +               return ERR_PTR(ret);
> > > +
> > > +       cma =3D kzalloc(sizeof(*cma), GFP_KERNEL);
> > > +       if (!cma)
> > > +               return ERR_PTR(-ENOMEM);
> > > +
> > > +       cma_init_area(cma, name, size, order_per_bit);
> > > +       cma->ranges[0].base_pfn =3D PFN_DOWN(base);
> > > +       cma->ranges[0].early_pfn =3D PFN_DOWN(base);
> > > +       cma->ranges[0].count =3D cma->count;
> > > +       cma->nranges =3D 1;
> > > +
> > > +       cma_activate_area(cma);
> > > +
> > > +       return cma;
> > > +}
> > > +
> > > +void cma_free(struct cma *cma)
> > > +{
> > > +       kfree(cma);
> > > +}
> > > --
> > > 2.50.0
> >=20
> >=20
> > I agree that supporting dynamic CMA areas would be good. However, by
> > doing it like this, these CMA areas are invisible to the rest of the
> > system. E.g. cma_for_each_area() does not know about them. It seems a
> > bit inconsistent that there will now be some areas that are globally
> > known, and some that are not.
>=20
> Yeah, I'm not a fan of that.
>=20
> What is the big problem we are trying to solve here? Why do they have to =
be
> dynamic, why do they even have to support freeing?

Freeing isn't necessarily something that I've needed. It just seemed
like there wasn't really a good reason not to support it. The current
implementation here is not sufficient, though, because we'd need to
properly undo everything that cma_activate_area() does. I think the
cleanup: block in cma_activate_area() is probably sufficient.

The problem that I'm trying to solve is that currently, depending on the
use-case the kernel configuration needs to be changed and the kernel
rebuilt in order to support it. However there doesn't seem to be a good
technical reason for that limitation. The only reason it is this way
seems to be that, well, it's always been this way.

Thierry

--nfbiwxgfuwekt25w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi4aOMACgkQ3SOs138+
s6EWag//TG8GKL8D+KtYbrfxxwO/AEt7PxS9tKNaQ4uX/W4JVPtJSVqumPpLlATz
kSWcKAk8uyNWVRifoC26e2FU+eTup+VsLHQK/3g6/EEv0rt/jn5mJWu91ckJuH+N
nWHOeXCqeuGYN01d2wYby1PZ6Mtvbe6PlBifyLpvoAsUpN1n4HvE1CWu45gZIR5d
2WqzOWqLtDf4dyhpPKzu3xwXMgms8SyLEY64ulTMjg02QvIFPhJ/EN3VMs20tuX7
1UBiq4yw7ylaSoKAUdFEB9sOq4tpnoi9YY9fgoMhnCvwP5wZFwKbqYIhfGqzEGWo
Yad3Oba0P1qxdCFeOabbitgjRtZQO8pJNfGuJImpP4fE8Bz547KcSbcORfZvu16h
lJENGR4OXALHeSbgAELkUWTBnxAEHs356KGRoIxOarNda5xvFHp9joOODPz5s/j8
kIeQjrt23Vl4uqqlzr2n8ZwIQY6Whc2OuPnY/1/sKenSXKrqnfTudaRnsPMFQXPQ
ae+Iq9kecL40EJmZx03IkKwsxZ1dqfr4h0K9cQRa+mj5Xg+1TXfTXfcsaDLiqZeg
a1sQbf3ZbKYz88yJmRp2UrbJMGkqjnuwvvD2MkLtxqTS2pIl/sUGx/ltZDu592uU
dfOddTVrqV/MBj0YtLFpU4cFY/4pdIkqP01sN61Bbn+jvYFcceA=
=8yPm
-----END PGP SIGNATURE-----

--nfbiwxgfuwekt25w--

