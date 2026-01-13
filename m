Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E746D29DF3
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 09:42:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D663C6B0005; Tue, 13 Jan 2026 04:42:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14366B0089; Tue, 13 Jan 2026 04:42:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13EB6B008A; Tue, 13 Jan 2026 04:42:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16D96B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 04:42:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 510ADB71F1
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:42:32 +0000 (UTC)
X-FDA: 84326450544.02.068ECBE
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 32B881C0013
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:42:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=amaCJM7Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768297350; a=rsa-sha256;
	cv=none;
	b=Y1hzwK7751BgOWkHsKusCHsanRmR+xCoGq0Z5N9XRmAd+PH412WQcKe78N65YRkrZR8Nt2
	3tVw/VUmXI7dUHXpC/imLG56S+4VECpvscIGfkW+5bwu0UiB+X1aCrnVcT6w61sdsCGAev
	kpVyuGqpmKWRMpsjPoGCdoQm9nF9G4U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=amaCJM7Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768297350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qWi0gxImcfe6sPFx7hTgeNf8sv4DbP5sxUz/myXx3jk=;
	b=0q7jwPoWyaWgFbaloy1XQsvO8Tr4SS4w0vocYBRjRK06FZHofhnj8K/EpMC+kw3EDgrT/3
	cORipsJc6nNVL6tvER2ET7DaT0TQ7d2gXyt1niDgpJLZq+h20Wh6bjrl8U6yNKVbzAHy3E
	9twKg+2Qbq1UaHfFMyQdLNQIQWn4emA=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42fb4eeb482so4201745f8f.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:42:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768297349; x=1768902149; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qWi0gxImcfe6sPFx7hTgeNf8sv4DbP5sxUz/myXx3jk=;
        b=amaCJM7Q0b3qNQ6pX/JafRFTHq001IpTLvjP7Bsbyf3MY01+b5QUjqEWprAOcQ0lp7
         sNn7APs1isUrSqfgEwLUyKB7GmKRzB1DKdpL2AgDc4f8S0lMFqQg2WYJyO39dUK+znc2
         abPgPMck4v6LwG9LsbBSaAHZDIyzlHxrg9PFVKxz1uJ+AU0BY70FOKjDVakGviwHw2Pc
         3+1Rnjq5dMd5dOWngcvv3wojc17Im/fp32MQwNRZMrqYZSgU8mvT0T3CJ8ebDI7si3mO
         MQHwrBEFpT/ZZsuYgAUN24uF8BYVcqZ/jHWzEbGZdK1gHUzzLdSOcyhm1EvxPmVaIyKd
         ILIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768297349; x=1768902149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qWi0gxImcfe6sPFx7hTgeNf8sv4DbP5sxUz/myXx3jk=;
        b=r3TmnsTDw7f4kWhK1OEDmltHFr50v24Bl3IUspPj0PPttDw15KUBVY3mHTtuXrgIi3
         faseDeSZXhwyKT8g8mF5HWohPKJpsZupVO2YuZ8EtQrm2/SBiXrdaQJPZCV4203GjAMd
         Mu4ulao1qAp11qw8brrdXxUN128baTs7Du+7+C0bBAAamQk9oRm0wwVB0YisWFY+hqkv
         Xymduj7OVk/GfH6RYgcqNNtHlUrzHP62opw+9+miVHWfxovFSn3XeI7wX9unHfYlWLRU
         zHsamQgU1h0TJ3mtfkV6S2SanactrCDzWEjplDC6TwAioQCpyWcFJfcHkCDekSoztStG
         mngg==
X-Forwarded-Encrypted: i=1; AJvYcCU9AkNjxdRgUsMK017WAxkn0lMLfGl/9TTGfC8fDfwg28KPa1dijLIypSh1iQRKPqEZjWPCKpr0AA==@kvack.org
X-Gm-Message-State: AOJu0YyMxSqbY982Bv1M20iMi70U7ZSvWf+ebUg4UzdcgsNsUVmWglrM
	C9Fao3Z2u0ztJwtoBY6Xq1CXSPLTgN3b7TNsXJfWu5F+hwCSi4pFUS3z
X-Gm-Gg: AY/fxX5W3pKIvHXJMKqVlYVNkCOuBeFXjq/frlYrN183GbZl2ZIR+wppUE0L4X6Bc3c
	WnskMjejheEWay48vXo4v9U98pzdCWqFdgOKMFELu8ZuKSwMJZZAp3JncssMUNlOF0rehuU+19Q
	Dz7OoqGwmKIFaj1m2yDnbm0D6KvWElPQK8k0dhYWxXBf3SB2lyoV/5HQ87kxmedEog+CElABV+q
	NR9j8Ol9GfntHW0JiCnsiPtf2YsK5WSj4cd9JSQbsBhZSzXunyM0wXL9ehwBVyxcgOV2S9evdYi
	c9sm4nGWLEpMq4wxQBFfQxQtzv0IzFFH3LwqC+rfsfc3IumOH4LWkSoU8ZrAF7GFyzlesW3jEuY
	4etT7yxE5BGJENGKmZQQpy/c423UPn1PRpmM3Y11y7uDuIql4gvvc7671uenWEuy/GSNDWP+LcB
	Jztkfd9VifYJVMPx9MpcJo1mRIzJApLZGxUrJLq1F/RCFAZr+Z3QDV
X-Google-Smtp-Source: AGHT+IGCluKpScy5UmgAEwir80+RNqkqkTWiXHqvvRnvopn9jhUBxHczRPNLOdlhz4XUibpj8zHkVw==
X-Received: by 2002:a05:6000:178a:b0:430:f449:5f18 with SMTP id ffacd0b85a97d-432c37644b4mr26662191f8f.46.1768297348421;
        Tue, 13 Jan 2026 01:42:28 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5dfa07sm43196646f8f.25.2026.01.13.01.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 01:42:28 -0800 (PST)
Date: Tue, 13 Jan 2026 09:42:26 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Brian Masney <bmasney@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro
 <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>,
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
 Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 30/44] fs: use min() or umin() instead of min_t()
Message-ID: <20260113094226.144973b2@pumpkin>
In-Reply-To: <aWVs2gVB418WiMVa@redhat.com>
References: <20251119224140.8616-1-david.laight.linux@gmail.com>
	<20251119224140.8616-31-david.laight.linux@gmail.com>
	<aWVs2gVB418WiMVa@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 32B881C0013
X-Rspamd-Server: rspam06
X-Stat-Signature: hkg9ob6ac4q9gkmipgbrit1rkjyb5x37
X-Rspam-User: 
X-HE-Tag: 1768297349-316951
X-HE-Meta: U2FsdGVkX18c91bqDyH6+hJeEWc9Vrg84iL47YOuE0J0IR3tltPwpZkVbXTXxQo27Zztjax/tOur31NjlMhpWz7Ss5+jP8mHNrGc9Ltq8hWhlQqPcHDqfhpX/ucvVzWKOo1LSEwHJWjl7VpiBtNQQMja5m+iy4PC2GFE/OdDLM1Dsq9Fbk2ntd70souNKJ+AQUIQOqvhmGdwkLIvBC9Y25OFD5v9n8W7NgZVra3BfJ5IRTiXxGst6L6wnvrIF/nnodbE6U1hiBU1hSKz4d1kNNSmzQgg2jB7EmdCUtMSWvjw3IGHlOien8eE2LIHV5Xmxs2n9HboutgTjGjOEcRRu7xHkQh7oO69+NKIwy2E1aXvJvs3qrYJy3+6kFo9RNLaIqXvlmUeHXtXRfHDFnbScW90FYhc1JVBvD+/ejc9pfoERw5qtnpXCt4NDbwvURGZt05qbS4k/JZbyMTP1Zpal+Yv7LGXrl9mGFS1DbIccziktnjTQ4yUeN94/yMFLZv2U6NH6pbK7oBzcI0whGH3BANH6Fnz2WT+1qLhrYiuuSVlWS97aJwI/757aDQsgGDP8KdLJiEyIauB9R1FaGG0izfsu/8y/QbdoVZc2IOYWmcLF1kS9gqQbi9Kk7WObJ2IbIceMD3j7T/ti5N/qHXe/DzBkfs2yy4zcu6zVoUKMRt/HJ5d+JfIe+vWfFYEA86aF0/FdVSg54rk1pvJPgwypBvgKg8ex/H1rwZEJt5oBLuGYiy7UeWcLv2rSxscYIp9cbWp0gRhIdFtiVYHbAT/ve/vPAhON7jPtLP2GhQhLPu6N79M9vuuTIWNMREtH+XH8Hxy/UWCJNpYSmrknZcWP87CUrkxLz5Ug7NPuZOn9ZmcO/4wCnKoga5eUhxNnTNzLdogE0bfp4xQyWGKpBsbTiKsmtLv5nabnLcZRQ2pt5/KlzLOMeg8fFSvmy8NlmpQ/SS0pQQFlRZPk73Xjvx
 Sue26yh5
 JPq8ZK9p5mk3zoW2XoYLE7XVzhKSVOP5chKdgq9tfK+zwOfYTOBj5VfVbEU9t+zDFQlkc2DUYpy654Khtcjg62Fy5hhFsStlrfdcncupq4MRNMw5rKetO/hhk0Clc1C9OI5Q9hM+biZZ4+Snlop8gBGaScgBJe6NyVWXRg9OVl9KPy8IGmRHofxVVDJoXM/1iCeyFlsk8J0M/4FAEZs3GsFrT4qEQ9WtOooJhQdupyclyg9q9Dp6FQ8ey8ydqRKXuMw7MI/lVuNgUStyTKBkeJ8FPbdRpH93O/NaS3sXJz5rYHuoXW64mdyMk12K0e4l52Bld5p5oJwtREiMpxHcYvQ2N2pt5uKF3OtEmOFJgalEFkPdJQboFKy5uf/y/gHVppIXiH9icgNl8a+Jx3KFOC8nylxTAWG7z3xwMFx0sWvSUCiksmzGMTAhlQoVpC1ZotN95upicJ18vRDxqZTW28/9ZE7EYWUETGRzvRaNdl7Ay9EiRHFSSVbtwt6a3jsvdH3at7v9Jhld485I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 16:51:22 -0500
Brian Masney <bmasney@redhat.com> wrote:

> Hi David,
>=20
> On Wed, Nov 19, 2025 at 10:41:26PM +0000, david.laight.linux@gmail.com wr=
ote:
> > From: David Laight <david.laight.linux@gmail.com>
> >=20
> > min_t(unsigned int, a, b) casts an 'unsigned long' to 'unsigned int'.
> > Use min(a, b) instead as it promotes any 'unsigned int' to 'unsigned lo=
ng'
> > and so cannot discard significant bits.
> >=20
> > A couple of places need umin() because of loops like:
> > 	nfolios =3D DIV_ROUND_UP(ret + start, PAGE_SIZE);
> >=20
> > 	for (i =3D 0; i < nfolios; i++) {
> > 		struct folio *folio =3D page_folio(pages[i]);
> > 		...
> > 		unsigned int len =3D umin(ret, PAGE_SIZE - start);
> > 		...
> > 		ret -=3D len;
> > 		...
> > 	}
> > where the compiler doesn't track things well enough to know that
> > 'ret' is never negative.
> >=20
> > The alternate loop:
> >         for (i =3D 0; ret > 0; i++) {
> >                 struct folio *folio =3D page_folio(pages[i]);
> >                 ...
> >                 unsigned int len =3D min(ret, PAGE_SIZE - start);
> >                 ...
> >                 ret -=3D len;
> >                 ...
> >         }
> > would be equivalent and doesn't need 'nfolios'.
> >=20
> > Most of the 'unsigned long' actually come from PAGE_SIZE.
> >=20
> > Detected by an extra check added to min_t().
> >=20
> > Signed-off-by: David Laight <david.laight.linux@gmail.com> =20
>=20
> When doing a mips cross compile from an arm64 host
> (via ARCH=3Dmips CROSS_COMPILE=3Dmips64-linux-gnu- make), the following
> build error occurs in linux-next and goes away when I revert this
> commit.

I've looked at this one before.
I think there is another patch lurking to fix it.

> In file included from <command-line>:                                    =
                                                          =20
> In function =E2=80=98fuse_wr_pages=E2=80=99,                             =
                                                                          =
=20
>     inlined from =E2=80=98fuse_perform_write=E2=80=99 at fs/fuse/file.c:1=
347:27:                                                                   =
=20
> ././include/linux/compiler_types.h:667:45: error: call to =E2=80=98__comp=
iletime_assert_405=E2=80=99 declared with attribute error: min(((pos + len=
=20
> - 1) >> 12) - (pos >> 12) + 1, max_pages) signedness error               =
                                                          =20
...
> fs/fuse/file.c:1326:16: note: in expansion of macro =E2=80=98min=E2=80=99
>  1326 |         return min(((pos + len - 1) >> PAGE_SHIFT) - (pos >> PAGE=
_SHIFT) + 1,
				max_pages);

'len' is 'unsigned long' and the expression is unsigned on 64bit.
But 'pos' is s64 so the expression is signed on 32bit.
IIRC the final version might have been (equivalent to):
	len +=3D pos & (PAGE_SIZE - 1);
	return min(DIV_ROUND_UP(len, PAGE_SIZE), max_pages);
which generates much better code as well (no 64bit maths).
I don't think len can overflow, read/write are limited to INT_MAX - PAGE_SI=
ZE
bytes in the syscall interface.

	David

>=20
> This is on a cento-stream-10 host running
> gcc version 14.3.1 20250617 (Red Hat 14.3.1-2) (GCC). I didn't look into
> this in detail, and I'm not entirely sure what the correct fix here
> should be.
>=20
> Brian
>=20


