Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B286CAC5A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 12:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A348E0002; Sat, 20 Sep 2025 08:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41B28E0001; Sat, 20 Sep 2025 08:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956DC8E0002; Sat, 20 Sep 2025 08:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84F9C8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:08:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 199311D62FE
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:08:43 +0000 (UTC)
X-FDA: 83909506926.30.0E2C2C3
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 44592180018
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 12:08:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q2PM6zTP;
	spf=pass (imf24.hostedemail.com: domain of glider@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758370121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rg0aAAaEFwb8WUGfzZYLj8KGkf4Q3J2CuRbPLZDHdFI=;
	b=6nc9ggBHzVxd4DUT6gVhMxBbYe+uqYL1yvCoIbNgsKNafZaTjmW2NdJSG0+IEgL7YqZL+q
	T9Q8Xc6ISG1D/6TkWhyg3aAGu5jwpteq6lFDNPwrr4067yahFXtDD+g5REe8c8oXCDmQ8Q
	4tgL8rKPo+xxa7cVtiEf9hr7ZycYd0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758370121; a=rsa-sha256;
	cv=none;
	b=QmiJf7OU6kybzDVeyA5XrGDa5GRLJr19OjTi00/8BC6Is/XP8ozFFkPCQ4UOm5h9mh8Teq
	gJ7mOOplaxJmReoNtiOk8ne7Jx94iLSR68Gr16UYmN9oFKjg71ryj3RCLFc2pfb1X+ch6F
	M8uYKcAdfx2tHl802QbXH35/JwJXxes=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q2PM6zTP;
	spf=pass (imf24.hostedemail.com: domain of glider@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-796fe71deecso22341066d6.1
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758370120; x=1758974920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rg0aAAaEFwb8WUGfzZYLj8KGkf4Q3J2CuRbPLZDHdFI=;
        b=Q2PM6zTPK9BB+3c2kGKHTBKHQvHQjiRGicqCfgi28PIHFQ+8cYbNyU74M0M9tV8obS
         CaHAuiHCyLcPIL/ismIQ4BAeYkkviIJbAvATrxAwws/++ULQXNi7HS1xUSJ1i8/5gZRU
         t8od58hoh+DojGhSLz2ijKUVppnroS5K/jwQ1YvINUsGNf1+mDtWSxXQVblTKEzohXg6
         wog0FD2oPE67AWlf/L7x9cOELW2VS+0O1bzkxptBdZ7M0HhBXJZfNlHhnOfGxX8QhVOo
         ++JiNbnzwYXPHhzPHlBypFUoImVv5WENfdpVVO3jaeLfT22dIqpWHdTqKQC+52N2Sfs/
         Y/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758370120; x=1758974920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rg0aAAaEFwb8WUGfzZYLj8KGkf4Q3J2CuRbPLZDHdFI=;
        b=TLJhfxrNKfpqWwrG/2fKwx1Xjm2Zs4rmfgqHRelW0kzHMpS3YmTTE3dIWnkXpLVRYc
         ChgfrtBYYsZwv/d+dKFe7F4xfKh0o3SI9GE4hLJ8RdkQLibHJpFOot9As85s9VUr4QP+
         ycqvToTlDdzIGnAOMXrd+ALQRxsk0/h4Chd5V/iJCk2pIfMB3pWDZW+CZZ6+ml41sg05
         GEAbky5qmhXI4qeLezUZrqcFsBgydMNWz60vQlKqhw2PEtRIoboUkshmZUJJLWc/5Cba
         yOXqqxYT9aHDyGe7dyJzu8IUXNi8lm7R2+uSkx6X8CpM9VnC5UjixKcu3EdHuRFdArzX
         /vxg==
X-Forwarded-Encrypted: i=1; AJvYcCVkSp2aLNbndfec2ypEx3pDnK09XGRWCsFpxZbtaBr72lUpqK2rbNuh2E9GyHeIxAYrNsu51RKIOQ==@kvack.org
X-Gm-Message-State: AOJu0YyyZF52DDfBQvHZ9mqdIaF8bVawSLP968doVUGUov/aFL4T65it
	8fUqHt2+sGzggG7I16Xr+tHFxUvSdSjLUwxzkE91OIGrAOrXFEThV6mG053c++7Mc/nlRkSyeon
	vh3G7x8sTWJVseH8nYMyLzAP1tpkETVGFsxiq6+EP
X-Gm-Gg: ASbGncuEhMXdQ8MjKUh6C049IGdPI6HYC1weIYmbcCUXUxex8ekOuVgBzBKNuycDIRE
	ufIfuztiXc1aCaWbGHRDuppIjQdTijiJqeMNhxUPp78e9nyPsGzkTer7782VyR25JA9xxlO74By
	CYm8sLN7x94H8s53aJcNq2v/0dF6AlptkT9vFEKdHbvRDVc2BqqguWNwCZ3Inlr9y98yUlWMEdE
	0x5hSfq2w2Lrk3Fq4Z97KDNixILFKP/g3BWHA==
X-Google-Smtp-Source: AGHT+IGrLhGnLin4JPn3IEJL16TDaAaIyPUzt4DPnDcGALtByT5b0deWvFSW43f3QYgleVc8ho2F2zEcC/AGvOdoPJI=
X-Received: by 2002:a05:6214:5712:b0:7b0:d5a0:c60d with SMTP id
 6a1803df08f44-7b0d5a0c6c5mr11507116d6.10.1758370120098; Sat, 20 Sep 2025
 05:08:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <20250919145750.3448393-9-ethan.w.s.graham@gmail.com> <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
In-Reply-To: <CAHp75VdyZudJkskL0E9DEzYXgFeUwCBEwXEVUMuKSx0R9NUxmQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Sat, 20 Sep 2025 14:08:01 +0200
X-Gm-Features: AS18NWBVqpbu6_S8igqrpC6d_4rlaGzIrca9Y3paJY9H7AfaiH53k8LL1oZq4JA
Message-ID: <CAG_fn=XTcPrsgxg+MpFqnj9t2OoYa=SF1ts8odHFaMqD+YpZ_w@mail.gmail.com>
Subject: Re: [PATCH v2 08/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz, 
	jannh@google.com, johannes@sipsolutions.net, kasan-dev@googlegroups.com, 
	kees@kernel.org, kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44592180018
X-Stat-Signature: ts5mh6sgsi79x6otcxrhmoyx3h8jpqc1
X-Rspam-User: 
X-HE-Tag: 1758370121-154234
X-HE-Meta: U2FsdGVkX19syGkaBxRpNIdjJpcYLC0Rdy3HjPTwT+nVXLQuPon1iutoKUICclO/HrrCTyJJ2Rs1s7rsRv5HGOr/cbKFmpBvsYH8RwxXTImgHw0wYRypRSST6gDvthXqVLAQjP+6G0c6o3b7hp1V4yhwf9smTOHM6oQkODxgV+P/GTv1mlhXLIqseJtTCbmeV/7etRbM6mKcJUK8H6D/wKx4O8+8u+6Hk/qwJdQt29u3Z5g0Kd6Bn8+0x1ukBT8n+7JpsBceizvJLIuKjEUx3ngKLC+NaJoNdvEsMk4w9e5sqAcGYvSoNYD79LK2TfEx9P6D/lgnZT2dZzAYq/it/dzi1ngDxai0nk2RetkHCnBbjifUUO1SLSJfchXWbfgQoXqo+hJM4WWC4jKODnub3Ph6dY5Y0/37hyTzgG1h5xAWEjANgI9lQ3jKoQopV0+47cetXg7Jqlf8K3LJhr/hhERaHhvdR9wcJYRQOS+5jaNzvigkTaZUdgROGgduqBFsxoiAzx88vIdN1V5N1tgYgQ6LgVOJsG5AgApcRf7cVap6d3V2r9qZpm1BOZ1GjJHSw7JzKyrKNkC5thdBgEj27sfnPSDLh31JCp9PDpPSA5AZxawknyXgpBHWUFCOYIt/bmLaXnMwL8UeKP6WBUWZwD2x0kSAkAi8qtKm8CPG/2Z2d0dmlyr5ZKDWND8zpA3lNJdmj51o0cpRcvkgNl+UBGSOvLPreQSNqdMCrmACr+zHSPwrB2PcH1MXtvAMa1jM1JrJGMdxRWtdSokdoPNbK1KXlKEeGqlCJq2eHs5FC5dx9g4TPEqQaCSQJDVfUni+NWtoODAyMS32KeId3w9vTCcOU+OmVNMZpP/rU6arl9tv27c+SzY0NSbF/EjeTBsNUSlhCbypxoX8oUFpZMMJlJWGdlrQ3QP3aP0850p5E/O8gd5vc2e8uR6WcSdvNu5hWxwoHor1Hk0XF19Lpqe
 FEvpcrd1
 56l5vZyylfI++aZs9qFLbK+IujgdcCwgSjs8aWRQr0+IUEVfvuuc5hWMG36nAO8qcq2p/PLKkzLCMjKLGWxvQhvLIj95Wwq2/YNOxqF2KF6DItZ4II1iTyROum4F5VNbjIP+afbi7jMgs9/lngxaEqFZyv0sF0m+ORSgT5H4682pPpRDp6fksuWZlVFv4nVjEkiH3ziZ8YyOjKJmH+F5aklMpbxptRaMlO5zNUCGsJTkhc76XWG0lusY9MCkC46dxLdhx3BP3P58XGx/ajh2D+hTtihwM5qgZgaYV+Xq9gystMFio+xMYc3zcEbv/XDrUMjPr++kbYfrr7ngh2yJPsiIhFV02lNB55eIAwFezGgHP7aY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 12:54=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
>
> On Fri, Sep 19, 2025 at 5:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gm=
ail.com> wrote:
> >
> > From: Ethan Graham <ethangraham@google.com>
> >
> > Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> > file under /drivers/auxdisplay/tests.
> >
> > To validate the correctness and effectiveness of this KFuzzTest target,
> > a bug was injected into parse_xy() like so:
> >
> > drivers/auxdisplay/charlcd.c:179
> > - s =3D p;
> > + s =3D p + 1;
> >
> > Although a simple off-by-one bug, it requires a specific input sequence
> > in order to trigger it, thus demonstrating the power of pairing
> > KFuzzTest with a coverage-guided fuzzer like syzkaller.
>
> ...
>
> > --- a/drivers/auxdisplay/charlcd.c
> > +++ b/drivers/auxdisplay/charlcd.c
> > @@ -682,3 +682,11 @@ EXPORT_SYMBOL_GPL(charlcd_unregister);
> >
> >  MODULE_DESCRIPTION("Character LCD core support");
> >  MODULE_LICENSE("GPL");
> > +
> > +/*
> > + * When CONFIG_KFUZZTEST is enabled, we include this _kfuzz.c file to =
ensure
> > + * that KFuzzTest targets are built.
> > + */
> > +#ifdef CONFIG_KFUZZTEST
> > +#include "tests/charlcd_kfuzz.c"
> > +#endif /* CONFIG_KFUZZTEST */
>
> No, NAK. We don't want to see these in each and every module. Please,
> make sure that nothing, except maybe Kconfig, is modified in this
> folder (yet, you may add a _separate_ test module, as you already have
> done in this patch).

This is one of the cases in which we can't go without changing the
original code, because parse_xy() is a static function.
Including the test into the source is not the only option, we could as
well make the function visible unconditionally, or introduce a macro
similar to VISIBLE_IF_KUNIT.
Do you prefer any of those?

