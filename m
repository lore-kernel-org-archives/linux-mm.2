Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F8ECA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 15:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B4BA8E0005; Wed,  3 Sep 2025 11:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C658E0001; Wed,  3 Sep 2025 11:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07B198E0005; Wed,  3 Sep 2025 11:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF188E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:38:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD5F613B7AF
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:38:13 +0000 (UTC)
X-FDA: 83848345266.07.3AB2502
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id B9556140006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 15:38:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlwZ0Up+;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756913891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VPbwCRLjCS0JlRjDhk1ZHzDpInRFzDVXs0glfOj9Nmk=;
	b=37OVd902IIU48UG3gfASHjY3HbfqxyXaeA7Tao7VTbAaIrW0L0vt1Sf+cMva5eWw53qS4U
	e3WwZ8hPz9Sz8JdeGDmHiMNsxbPlzEOCAexUBGKdZYTSfYCj3nYbSUeDxmtsGiBPCtr6Bm
	s5rew9a4kFcx6ZoYTL43BefM+Cy/Dsw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SlwZ0Up+;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756913891; a=rsa-sha256;
	cv=none;
	b=XrouKW6IsEM+PYvIj+iwGSb2yO0eRA9UzVOpl+gDWUxzvFmWd9ZNWSPoSQxHcX2+WaoiHw
	Y8YHkQh46Z5furrmqwtffFupzeryZCxKfy2rZA1kz/sbabD2f0SkjCYO8V9+I5IjNzcFHm
	sSLyEQUzd1XMuVUC6cskzMgSMyoQgLs=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45b7d497ab9so895685e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756913890; x=1757518690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VPbwCRLjCS0JlRjDhk1ZHzDpInRFzDVXs0glfOj9Nmk=;
        b=SlwZ0Up+1V92xzEt5xSVS2b8Gz0/BNtznsZIhdZQP8AGhW3u6hJWear9SSXXqjvXK+
         Wj2GCwU1AqY1pJ+F0GU9oax3aEv46JY1FiXt4Wz7O5Pvj8q+Y9az9qt6XzBtMEqGbgIM
         q5mJbdmsW6Yp6smn84kOMih6Of37XFR3YIqPhHyIQ4DJaYn6/+EHKi4+U+g/o2l+KGd8
         w4ySfQjVf/7PL14t/dFHIBzLTUUv5SBBqNJ+3B10W1bzLW3NirtsGbGRqQbM75AFF6rs
         H6SeCoatyt4zW78WVf9uNuLp1Z3GOemlGiErOPiXvhu0njMLDC4oJVfl9fvx9pg+dGyK
         cmwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756913890; x=1757518690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VPbwCRLjCS0JlRjDhk1ZHzDpInRFzDVXs0glfOj9Nmk=;
        b=Ry6FyhHU9+lkIu9mHpTOODBDQqtGIHQKd99zayn+REPL2ZUxeMOcwxYW3JVvtY1qM4
         K1bHWPugFeVeJLG0JVP7Zp6bNZ35cLmgthLk2/qeUt0S/HDuv74pXvvl+tISwHKZmc2s
         sIM8ikx0SMJ+42KWNZ3jKhsnrBsWVVFXAUn41cf/U4x0lOltzr7czIClPv0ProZpk3/Y
         dIv7sACsWPMVHQCzB/ShewsQ3tAyXby8X5Iq9aT0eIhkLJ6WnQWi+OvEjh4nJebpSHrj
         IOQA5cjm9WkEfbIxliyC+LvEQgIXEtsEFIdX7A7VmfjOCPGHs8YKk+yLmQ2aOiZnUGfD
         OtGg==
X-Forwarded-Encrypted: i=1; AJvYcCXUOy8f84eLP/Yyz6fe3+r45DUsekLFVY5+NpVpA059qJ/tM3cmm+DuwP4M/IMM+VVyEk+IkLkcyg==@kvack.org
X-Gm-Message-State: AOJu0YzRoX9tVai52ASzhbGqUeeYALVSFEqA1rfJloqyA+7Rh8k2VxHh
	2deyYJxi0TwbdX6aHn2dvANK7tLXE6gYSgOL8VxErlmRCQCn9trE8Qxj
X-Gm-Gg: ASbGncvewuFQR9FFvBr95MRIvH4lDo3i3QCuztJ1qyiP/ibL5aL5bfme+GGLEV+qKln
	MyKls9zdj8gxkdwxRwneTyM081UPom4Z3igjq8yJZOpNx2K+mBqEjptytAyeB1e1bQe97iLH1wV
	gFAxLA+ZcY1OvmXcS6F3edmjYsXOWYInaDk7L6byH3hPCzyQwduRIEd6fFH3cPrg2tLY6qk6Fmn
	uof+bAJ7hWDJRQHTMnfBGmc0X6/ljeIa8toMs7mYnnDa4/X3hXvpR9FF5vR7fq/p/NYBrBU7Ocq
	Nij6Bbg4DL3Q+ZYFO+S6tHiHqUMiWy2uI8tyrz9f+G8elkavFT14r8h7pzorJTUoL5DLTCNH9c6
	iw/DjMhlok5oV87QEKR7JcRjwKBhf5Ng6evQTuLMemX9jxf+KfpGIK04MGI5W5OHn0+WvVS5v6H
	sreJATDJ0i/LGjWC+CAc8=
X-Google-Smtp-Source: AGHT+IFJMszbSGSF1PbWonv1NoW4j1E7tepFW666Fw1sEE/F4ZJzmOwpg3R8c/5zqgWpxpRXy3A2Sg==
X-Received: by 2002:a05:600c:4ec9:b0:45b:7ffa:1bf8 with SMTP id 5b1f17b1804b1-45b934f6a56mr68840825e9.23.1756913889833;
        Wed, 03 Sep 2025 08:38:09 -0700 (PDT)
Received: from orome (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b9c234b24sm59432145e9.16.2025.09.03.08.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 08:38:08 -0700 (PDT)
Date: Wed, 3 Sep 2025 17:38:06 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: John Stultz <jstultz@google.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
Message-ID: <e6twhwxi55eesb7xirei7wezzb77qjiji2mccgqlziisjzl3q5@3ny5e6lbgebz>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-5-thierry.reding@gmail.com>
 <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sulytsn4e2thgtl4"
Content-Disposition: inline
In-Reply-To: <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9556140006
X-Stat-Signature: ayaowab6yw5xebof1ez4eo8713cog4ot
X-Rspam-User: 
X-HE-Tag: 1756913891-423855
X-HE-Meta: U2FsdGVkX18G5T2FgANZz9uc9ZC/PRHwPdZTCv1BwkCQ5lAn2KNmHkGXpu931FKO0KIs9Uhq/UuiSp07H/+m7OxD9a+F/1rnA8Z4EkWkiZJ6unfRrG+4nL5MU5gskOMb6Mn5AHHpVfgkFow/vZVxjb2tuwEf2TotUIZ216jJb/Lcxd0pEQl+CFpo4QTVt4e1lkfoDiXip9phsMxFrE0F+BMk+0vY6xr8Wm6j2TGESUdGQV9WAoYItfX368/4oGUO3WlQzIydaPJ4hmrYj+TJHeLHC2OpU904Rz+p3uFP32W1ywqmVCHVD6Mgmm1AswtC9YV0Q+1n0eiIl6jWGc9wLcbzfrjeE5rmUoADaD+KDjaNFMiDNzrvyu1aAf0RYBHMVTJjOS2Ut6emJE35TnPtYZdqYMBHxuzIqPV449qpc+rWrDwgxa2q2PaeR40fFVU/KynaOJfO2ocNyEvA9kl/AMnUDJF8ppJOqUm3zdTTE0Vwv04Kq4oDa1J/ZjOQIJsm/nDrlt85U77NWZ9UlcNUQDAGNNumcbag57vplJDX7w0PxTQAQbp1dF2pCHgJTajqaOcXGNZz7SYKBq6PQAp4+F13oIfXtRceYX9cTZQnJYDfNHwWjeHds5QFG8fm6TO6MlhbHE6rNu36+eDdWj7nhsJqD5+x86qbE0hRVMSvvMu/lmMMOQoDSCnMJkbC2NkU4VDEFPZIlIFj4SWUodqeVChRsNQto52syWxBezHf5ILEPw2kDPGo+1zWnVeT2pFaQXX4soJKAYXx/4dPUdi2UpTVvNL7qmz/yz2hVzTzopuyV/u9pX+0/No2de08InWRW81XLEOy12cBxmQQrWi6EZWoYGr5BFRsP/2a/Ivr3mkepnIxEgz9UExgTOaBvQaaSyzdHLqs4pQ4Tg3K02c6UH+gKUF9bSzt8o/MfBy83bmbZFRaoQ5h6jRnC1fSn+WeqTiQqfQFyczQOaaykIG
 ob61Q3m5
 Y/3MaLmTRKg5+cwD/iAlmvvbyaXIGW4FQTf5u5VJtHjZB+BSOEXX2DDzs/2U8mI8X6yBCBur1vNgX5//yulzZ7iplOs9UZI9trO3gnIEeSCPpNajYP7SIcfD4bizBe4Z17Y8cWRZ9Mu1gVJYiI/ldkYkrs0kPIvb8jkgHWGWdUh44iR8S/m07w6bGeHHoYZkCtmIUruKI6OcAFDTR5TS7+VAKX6OvQS5wPddZu0cx1O6CxBxpiRkguU7abBjpXCbbtu0C0dodFigiXwposUy0lbdqH1l6b6DEMtJMDKMz1ZXOyyYP6Pa6z+0BcdY2lS4B5d4YhdEJ6FXPWbm74Et1o64VCDy5jGfmNnVW3GNrfKECLe7w3KRSm2ALva1J7X4PEGZJKfIh8H8PDQjk6G0MPIabG5xr5kwb/ARPIRIKW01ubIRs6q/iqbrJPoioBn1eDBZLVxys8ihOMuWbwFdpUJbOoRMPeIBTHYX6OdNoIdQ2nPyfW49b63gANvA1le5XdVMSwX3DfKjPzMmT16m6Aka/lbz8dLeb1/8LFti8QbEzC+41bnADiuYXjZtOFXT0ijGljECtavdooi/KAePjsGwEjZL9eD+34s9vTd+EGg98N1gU2XybNZOahAMkL0aQCVgMLPk1NB2tFyTRZvJHFtCiQw+RAlsE/2uBlIYNFVBxC6fht8faZacdpgQV9Vr0uV8/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sulytsn4e2thgtl4
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0

On Tue, Sep 02, 2025 at 03:37:45PM -0700, John Stultz wrote:
> On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.reding@gma=
il.com> wrote:
> >
> > From: Thierry Reding <treding@nvidia.com>
> >
> > Add a callback to struct dma_heap_ops that heap providers can implement
> > to show information about the state of the heap in debugfs. A top-level
> > directory named "dma_heap" is created in debugfs and individual files
> > will be named after the heaps.
> >
>=20
> I know its debugfs, but this feels a little loosey-goosey as an uAPI.

Well, the whole point of debugfs is that it's not really an ABI. Nothing
should ever rely on the presence of these files.

> Is there any expected format for the show function?
>=20
> What would other dmabuf heaps ideally export via this interface?

I've thought about this a bit and I'm not sure it makes sense to
standardize on this. I think on one hand having a list of buffers
exported by the dma-buf heap is probably the lowest common denominator,
but then there might be a bunch of other things that are very heap-
specific that some heap might want to export.

> Is there some consistent dma_heap-ish concept for it to justify it
> being under a dma_heap directory, and not just an independent debugfs
> file for the driver implementing the dmabuf heap?

Well, I think just the fact that it's a dma-heap would qualify its
corresponding debugfs to be in a well-known location. We could of course
pick some arbitrary location, but that's just a recipe for chaos because
then everybody puts these whereever they want. There's really no
standard place for driver-specific debugfs files to go, so putting it
into some "subsystem"-specific directory seems like the better option.

Thierry

--sulytsn4e2thgtl4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmi4YNsACgkQ3SOs138+
s6FLbg//VYHy8TOrGMpDWro/ULEXXUAldaCb7nmtSEpNIXvKqfV5j9D/dcMLpLtY
LC53YPVnMm9g5c6mZ0w7DfUU5q+qAwCe2mvhA+Fm3UaRF2jMKhD/5LG4rk7ELWsL
Xb3raJAlnNFO9AHgE7oEwGYjF8q94yEiAZHNO62j1kxJ00CpZCxyG2rie7iaTAMh
VToay43MFoIv9ulrESaonZk84vL4HzYJZIZXeIgjs+mS0BmFH5fxvCPerNuiG4gf
Z4N4cCDGWfJ+EYFuMZ3p2pbLivKlTqI3QdihV8BO13OMaADW7vmSPMdDzYSgQ/R9
KdwIIctBlRpiGYOJCPb83kZFsFXwU4Cvnfc3HJDTjwLwlbIrAFTlPnyhL9eWEeZD
oD4Jdnf/tHXH9tFJUEZ+cPA8mCHjMrnL3mTItfYILkvaGuZGRRdacy5fyICO0fbv
xB0k9rSgPfwlafKgaHj3wQD02D1qmGZqATxAVYXu/RT682hMAYX8JJS5ar64fQ35
esRjjoSdlzaVisao/gog2ThKdoPsThxcMXcM4nHHMfkd+wURKomTszYl8lZGew3Y
dzUR7jKgI/rPUUUpBD7D+cPzNy5p2JzoQMPoBtKMPOOq6tQ1BXYJgXZtfW8DO1T6
QgUM6P7kdw0Dce+0PdZOD3TvkpPucxyqZlLA13ZLCYeW8xZKwsk=
=6VMq
-----END PGP SIGNATURE-----

--sulytsn4e2thgtl4--

