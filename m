Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85496CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00B48E0014; Fri, 10 Oct 2025 04:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8268E0002; Fri, 10 Oct 2025 04:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC72F8E0014; Fri, 10 Oct 2025 04:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6EB38E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:19:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 697BA1A020D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:19:52 +0000 (UTC)
X-FDA: 83981506224.23.51E9CBB
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 89E1A4000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:19:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gyvPKevx;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760084390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cq5sJ7aSsShFxc17IH78w46REgBf/R4daQQ88MHxHWQ=;
	b=51ifmwUHRUnEwWi1uwPQr9udmMugBCvBZ9alWkmdiP2j/4dInsW2QV5KNqsEKyFqILwl8q
	Phlajn5qPqKUDvZPIBbs2l8Wtb0uI8bjEy6K1INQIpaFAVS9kwZ9qbULVFUjZbtrl76dO4
	aBSj5m+Zt9AXfAQwI0OK8ntVPVJucbk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760084390; a=rsa-sha256;
	cv=none;
	b=DGeQs2M7ERUbm3NpYtsUFLHxm+eFUI1pJ4bjxTWUhxuu0poQo5B/Yi0Dt9ZgVAp4pDqiXi
	1YIz+wbqF+Gxa72fB1vdwl+zwPKabWo5IlbNFqnSkSFl4IHB5mAiNN3RvL83ILEoTrCh3W
	5ChdteSDZpGrwbWwppTBnalIT5xGWio=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gyvPKevx;
	spf=pass (imf12.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2697051902fso2815025ad.1
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760084389; x=1760689189; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cq5sJ7aSsShFxc17IH78w46REgBf/R4daQQ88MHxHWQ=;
        b=gyvPKevx+Sqw6opq+h2+TvY+k4w45rIfiCBS7jq5EbYuABCQBGadbWISaLV0CF3bP3
         w2KjfWD231nPD8oGXUzIJVmGzJp58hTs4VT92OxGxDeVKosvtFu1Bv55y/nzWTKAjX+p
         Oq+M3yM6djJd+n86IIwcoq1xNhJcBKZkrCC4wZjM+1VmhAA8wO/Desi+y4R/OpWgTqr0
         PpuCWb/FM09QAvCK0xrtuLL6Dlm4KT+bMbumNwH5Fsvh60Ugk3HtKF4fpwGOVPJIt+Sw
         pEvc2k+SQnljqjFvNH4XZq0LbI73ssylD1g/atziSkUcvYH2QtPqLA0a42ZxebjXeVKD
         ofJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760084389; x=1760689189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cq5sJ7aSsShFxc17IH78w46REgBf/R4daQQ88MHxHWQ=;
        b=pihcq0VU5EnaAfjQGv3OfhlNKYDv7jo/m1cja7V3rSdQ60owXC42gkPmMBF2Hor+sB
         w5hvSMWx/+UZE/iAVL6oXZDaJlZ6EfSx6jq+lBAG/4ezCxY/oydaayqOGmc4luOwUoo5
         OKkLlbb4svhnsMlgd01FYlH0orA9eCEAqhCjdFh1ufOrxpIxtq57YMd82XmpvBMx4E12
         nDG+ipZy4wA2JYtYO2gGtY+vq2sL03pa6WlDR55zFLtQwI2VLkjJAg55Sfbr/lCQni0u
         YEz1YBi4VM7+c1joTYX7eAZc/GUNLkuEFf8/UQiI6BFPNwHhcc4CSnioP9nuUAM/Z/Kb
         BkRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXDEoIyr+kgaKYDAZl5Sp5EPUaQOiBN/81OkOkH0gALEFX4LZpKXtcH9uuZkgOiMu5yyNr5auiqQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5s9Puz9OdotaXK4yaGDvDXqPJ1EflVi3OelKS6XFhI4hsMq92
	byTG52CuHONSpNDAkBDDHUdy+8XO/8AAijmNEnHXQv7sMhd4EVG/q9krB9uVoqm4+CtFTVrji5X
	X5b5aEIO0r0SBWNImc/Ei26zuwXJZ6Rtwjz3u
X-Gm-Gg: ASbGncsVloxYCED00yqyRLC/PWVsjaRKKGpdnPyy7Nfm9Z2UiRyp0Ly/h5ST9TwFZoC
	lnA64mLlcSJAut8L/NoRU4Q7mFqxiaCokP58sgOyRFZNkNLk9a1kIgpFVqIa4VXVqaXNbZmnNvn
	wwM22jdkgdUMAlDo9okeAzq6r9/Q73PMYi/tD/tpLvqjqKSxbR/Bc9sD9yXY5TJTgucvtwubOkA
	dR09SayX2CEM0lMDDeNMI/GNfPnPKFDkPgahhgv514YH3lWN9Geo2U1dMM3N3X00a9KYwW81iSF
	TYCp3alMxId4Dy1MRSxx7zNXwjTPSTBKf7tRnL5WGPfB
X-Google-Smtp-Source: AGHT+IHsGqk0VxZVnRC6qblIgP8WmMkDMtg7G1rQix4D/f/fNxV3LDfDLnO6Fj2/zAlwLN0dYCpWL+UWmTlPxiqHxts=
X-Received: by 2002:a17:903:18c:b0:27a:186f:53ec with SMTP id
 d9443c01a7336-290273040acmr83793555ad.9.1760084389280; Fri, 10 Oct 2025
 01:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <202510100127.yuqhg8uo-lkp@intel.com> <20251009110555.29a67af19f5cc4d40e66713c@linux-foundation.org>
 <CANiq72kKSz=UK+O4tnV0Kmw_HmJhJJ+KNZnUBWtOWqanrG+7Vg@mail.gmail.com>
 <20251010060618.GA80465@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com>
 <CANiq72kndiqwEm-OZLd6JumAaBy7KrzYf_rDjwhtw5Uh4vdTCg@mail.gmail.com>
 <20251010074458.GA91144@dev-dsk-acsjakub-1b-6f9934e2.eu-west-1.amazon.com> <CANiq72mzrJNTe6aw5zJ_vyhXO1jDR96hmvQEXPkqFj=dnwSnSA@mail.gmail.com>
In-Reply-To: <CANiq72mzrJNTe6aw5zJ_vyhXO1jDR96hmvQEXPkqFj=dnwSnSA@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 10 Oct 2025 10:19:37 +0200
X-Gm-Features: AS18NWCOn0jUQlOTDgY6ZmGAYLoWjP7H_Q3V1N2lr7McmrZCKjd0e-TiKap1ODw
Message-ID: <CANiq72nkvd0UApjCYUcYu19nv+Ow2irz8WEPahiAf=6N5RZiyg@mail.gmail.com>
Subject: Re: [akpm-mm:mm-new 36/102] error[E0425]: cannot find value `VM_READ`
 in crate `bindings`
To: Jakub Acs <acsjakub@amazon.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: sa9upc4kst3gqh3mhfdjngyxshtzwa6a
X-Rspam-User: 
X-Rspamd-Queue-Id: 89E1A4000A
X-HE-Tag: 1760084390-213099
X-HE-Meta: U2FsdGVkX194cfsJBgwZgMWRAua46cCnaP8aUAxsPN0kPwf+Jm/R8D1Y7hrEzwfkjjGEZWxOLY900NmXfkqKvRNVd7v3yrLZ51MVwUL7iVBm1MKUqBsY1ZsysE+p560nEkb2FDEX5ONhukrale54qE0d5xO2fdTwM5eUiPjaBfU44w9aHdNIE5ICKiU7izDypvWcrhZE8FX9r7561RdnqR65CEvq4b1pj98xiGzCBHLdPCmMym0QXWZj3WpjMntSMpJRrrBpym5/maEtIv1W5by/jEYNZkD1FvDmZFl4x5nZA4R2tH1PF/0cnPvQ3hmSl8H2BRhdZ77M/anIKFwMuIuflUlzuNR0NIzeuXfMQ5XIin2s475c0D6Cw8ug351Vt04fGMaHZhqj1ayDd9RdVxMvMRhuGjgs3o5iMUjnNt35HVTSRYjDtYX+DDgAw9ncvtjzf4HZxeIt4CFYVtu2STOd4FiZS6raa4dehK5zT2P6fAaZN0BV1Q47G+M2oqIBsf76ZTNszNIrLmx/xs2WtCFeofuTTIw02Af5lURByaH8zXIrSj/aTVA1xbyKCSXIQcqA8ANcjTZZt6pv+YVUdY7VQ0M3kw1ZHUVt5KDW2X35b+5V5/w5mkfz5wgtPubEYHSV2CuC/NTjg3l5JcoXacfN/64XDbChFShsE/JTCAeUaPB6bz53SyV389RhP9qg4wTY65MM2yBpwqTgx5jM9QUHOmyzasolDkrpGtFdSObPKd11ejRiTxU840LP5vb97rkquuFQOpI49i7Wh3mq3ch+tuYjpISooDupjcx+ZoMbzH+joQpcwUbTBOPtvRmKcybtrzCijn+xCaPJ2XwmNYgaCKxHZsHc3hUaiHEKqb/qcnkhcOexUnYTkP5OLnVbPpPItmbxJMPKnpOzfazxid5cSdslmohvKzcpdPJYJcyL4Dvh8YpZFn6gNQrXsKmhF6gV5ZR+I4uURGQrddB
 Bz5sGhFv
 LUnkNQF/nV8yBVxdRd3cYeIhjC0gTkMrQBMTCIfo6eCXoqgBhNutZFovbAbw8C4aDwjjs5/m6Y3XlBmzrtZn399c1HIb+btoTkcou7LOGIyR38/bX05lcODHAzb7PO2tXo/CPn2ijh31SJrXwRqtIvJeQ0yf8c3RUnYP7R9ViPdRqc81/36oxLq3UjB114L1qGTKbwDLckt8OLHsQPqtMBsbJmCypFQG9N+33daMj9hS6Ykp7X/Vp4PTB/9uddHlVVPOIZ+P/m3DRReo1j6Re0W/NJWBdLwaqVQbeaUkd231UxdXsRfUUiVlbBDSJprRTSP5X+4/AOxYqfsQUdo7v8KG6GCUYkgRhJtw08UtkSKAFKQTmuOTL1j2n+WrMeA78Sn4AyYrMdMcwTlNrpUvNWZWfc3r7iQq7WBAKEEkT2ZaSsjBRHSuCuZ3tiOYUjKyJIDT6Qhpe1MTh9gw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 10:13=E2=80=AFAM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> Otherwise, for the moment we can go with [1]. It is just a single `#ifdef=
`.

And if this becomes a bigger deal before we can start applying
`bindgen`'s feature for this, we can always look into imitating
`bindgen` to fetch the values on our own, i.e. with an extra step in
the build or similar. It wouldn't be the first time we do things like
that...

Cheers,
Miguel

