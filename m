Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79FC2CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BE58E003C; Wed, 20 Aug 2025 18:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CCD8E0031; Wed, 20 Aug 2025 18:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058638E003C; Wed, 20 Aug 2025 18:56:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E92308E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:56:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98A6C1A01A5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:56:55 +0000 (UTC)
X-FDA: 83798647590.17.75E4570
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id E754F100005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:56:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BrqXoA/W";
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqijktqL5QSVl4d9uRAFgyOKB/qUtj5ueyBzLO6jfXw=;
	b=eG2jUVJo8tUa/JC2TaQjY04MgKUAOibyRCJUXdUwc3a+tH9sWWNTjtUHhZ3hOcjK9CL8Rm
	cGDXceZuNuPWX68lYSul1syuMiXT6+O+vx+6z4lpeFr5sp/2Xtq5NvOEQzkykFHe+It2ta
	4TEU+4TgprfW3OeTAMryudOl9aiD+Wg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BrqXoA/W";
	spf=pass (imf14.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730614; a=rsa-sha256;
	cv=none;
	b=ONIOG/yqY/k/UZVuKaCJ5rlTpl/8iMxcQTRVnKRJmr4vUaFLeb5RGoyz1jvCBr0Xfj3rKR
	TlTwmhOtLRWfqcqsInkxSWQaEmBG1FIqVlk1teaEIdEP1hSoU4GEP0hntP6POZ6ZilLq8w
	NOyvk4b1FtZ25CuMfvNl+Ylp3SxoKZQ=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e584a51a3fso1805175ab.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755730613; x=1756335413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SqijktqL5QSVl4d9uRAFgyOKB/qUtj5ueyBzLO6jfXw=;
        b=BrqXoA/W+C4WZTjkJNIdxKE70FJVyp4sssUBbGtgjVynklcmJtZxy7dKKr4E8F1qVS
         YuOjR4lsYkQjsLGh6blkvFiRSNdYTnTgF+6PrQnubRAKw1LQ/W/hluGmPoypr+83FWM+
         pYczu72vaOFxbfxh6JO00L40MrdzUMoJ6/n3UFtZ1bjmz6n6SM+migvOf4Ovc3AxgxLQ
         8PVEPa4ygJeqGhCNzG7yCePp6qqkNsUjJh/T76Ty+nWbKI+TO46um+LxZgdEDh6J5CzT
         dNgFGSaYC7JKfPSK53pVWF+js49l8+pEWWxTjtFzDPhjLTeUfDAek9oYqeBdlqS2gHm8
         6gyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755730613; x=1756335413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SqijktqL5QSVl4d9uRAFgyOKB/qUtj5ueyBzLO6jfXw=;
        b=fVqOwTi+K7XstkWqxy7j67hcuJfogELRnI1JoRTS1PHgFS35eAiu0yj75VxREeBHmo
         Yk9trzqezkXcTs9MndjsU6GIGRgkmbiQwf+Evg1xkxs01y2bjN9Mt9mwtXC1lhIWabmI
         RiKMEVCzp7Rud4iNjEIHQ3Mk6ERzzdyNxhC16Yn8s2uf4aLjgoD2tQbMW+OQ4b55eVU8
         z7mLQhUGng9+IjnTEmisjLgAY0y6dwmX5hA3mQ6euu+2cEHc2ha+1KvSjE8F/pEY4u2V
         O4nLb6ve3yJprkSOMz/nyub2qHZP9Y/6KUMGgItmxNdKKJZHKwId5g1RNBZl6O4S0BTT
         a+hw==
X-Forwarded-Encrypted: i=1; AJvYcCWRjWfSzpOFfQ2FX/RC0HxhmPi/YCIYgeP2dgY6INn+HgYUm4jTbEKH53i78nuwnDUDBYV/ViQhWQ==@kvack.org
X-Gm-Message-State: AOJu0YzLU6x5XOwPmwn2iYgK5BA2+lWUbx9t5HrSNDLSHZEmyGlM+Cxr
	CUFkL9MIMbtqbR/efXBeVpy2JYQuRzT8GWFWzBJye5OZLL2Czg5GHL5ZGUR5KBhAIEC3E/FctaK
	lnNaolZc9f2Oum/cpdeNBgKGgyjPqKvQ=
X-Gm-Gg: ASbGnctSLJ3qwyAympid+dYp1QHALhqqW9+6i1lsMXlrUmkAP9+9CBFDSdftpDE1ose
	P5++7RTTGlGLZgBEv6xhaxXidYGQ2P+Ig/nB8i6Gyr5xKYoMCGaKEm5/nb/RZUn/UHOAYUN5NPd
	Rhb2mLlQ3WVk22MrypoPPWNVsMDSN0cNX29b/AsBxlb0zXJssOchw2Jb8JHuZiWg2F9JFlpewQB
	GI4eI17r4l7dY3I8LcoIHI=
X-Google-Smtp-Source: AGHT+IHqhFqF0ldEvreg/zhfn5bJC9zhoDj5P0JECW0SBkkVMdAh6s8W9uc7MbYxkPrmre9Wg9hXsJZ9FhvxeMhipnQ=
X-Received: by 2002:a05:6e02:1609:b0:3e6:65d5:2278 with SMTP id
 e9e14a558f8ab-3e6d3b83b12mr5701655ab.5.1755730612828; Wed, 20 Aug 2025
 15:56:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250820181547.3794167-1-nphamcs@gmail.com> <20250820224659.88528-1-sj@kernel.org>
In-Reply-To: <20250820224659.88528-1-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 20 Aug 2025 15:56:41 -0700
X-Gm-Features: Ac12FXxvh5FV2ONZgUx83BQVRwVMK28b4ENt2qAqzERkh1Pfrd5_5j4HG2TtHZo
Message-ID: <CAKEwX=NLvQyZTqv15kACZP2wErO9hyv9W+0j-BWrgOh5ZX1LJA@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: reduce the size of the compression buffer to a
 single page
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry.ahmed@linux.dev, 
	chengming.zhou@linux.dev, herbert@gondor.apana.org.au, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E754F100005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ws5trohzrihpjrjafa565n155hbijq5n
X-HE-Tag: 1755730613-737887
X-HE-Meta: U2FsdGVkX18trMSRN+fjY/JPm7ig30aXf2lW6/r6uBfgmJFWBX1xcVbD4csVGgfLxLyMtUG4XbESkvTsX0iKxThrkDWrA0ruf0uxaH/YxGSDlK/tf6ztzyDasBZcloZHJn1udlbl7EneycUOcHc7NtNM+A/UrydKhqdqkduDocjlwc5kBQorZiji2I+S+y33d+Joq3wBFcinpk/LzgF+QZOJc6B/9ieQ2+PGKBJkGZ8wTk8eyTOaRJoG89fqEClIfxgOwuUcg5SZrqCP1YHwVGNFMlo5Rgol+QCSPDVSFcK395Cg8Nkr716jt0cEKLDeSIHOCmH1n73GpAdex5DztdNI9EuJze9Jk8HfzPc9i+2viK6E+KgYg9W6k+bWrRaWwE07zXYa2UiMnwNBuTFxwO9svJfNmOomiewtonmL8owY97oV90TAXCaAy5ocWJ7oDhcuWbCYJVp17oqna26LrAXOC7bSA4OdF6TCduxaBQf93AGOJWaukwr6yN63GO96Ec+zBnWw/MhGUeXgLvxQ7Fg/FutvO7y16TgWyKRtnWhyXt4kO4BOQdDTwBP/bFmTqRFKvLYE9mS9qwiihEqPLhz26eBY4Mr5A+F2/p8OIm/4viZunhGkMzDaOVQ1/5OgqFoRcK9c9C5rNulf0Muwj0ni5/afmaX2koKkDexj4TAmlalU8HKBIS7/ZaMTqvU+f0EpQa9COwWsNuFT+qkbFK3J5XSkViBDAs2fQQO8JBVc9I789Snaax3Xagq1X3oqyWJTSmmOdpV3sNrPUD0/oRFZF2Oy+agWiKuumgzPfQzUTLb+YsrPD11dmvGmPJiXsbPT0f2MXrV/23uclDPpxuMniXgFq3xLb/x+BtTeoLO3q7zFDRGV/GYbn1kuQzQYufLwX6swFxAOsfLZ6IggQtNlc40+gVbbWz2Wgak944wZV//kxXn08WpqVaV06aZyqTpc0/K95qMY0y71/yR
 y5EguxxM
 QlKaRLHjAU76yQt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 3:47=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 20 Aug 2025 11:15:47 -0700 Nhat Pham <nphamcs@gmail.com> wrote:
>
> > Reduce the compression buffer size from 2 * PAGE_SIZE to only one page,
> > as the compression output (in the success case) should not exceed the
> > length of the input.
> >
> > In the past, Chengming tried to reduce the compression buffer size, but

Yeah, this should include the reference below. My bad. So it should be:

In the past, Chengming tried to reduce the compression buffer size
(see [1]), but

Andrew, would it be OK if you fix it for me when you put this patch in
your tree :) Or I can also send a new version if that's better. Thank
you!

> > ran into issues with the LZO algorithm (see [2]). Herbert Xu reported
> > that the issue has been fixed (see [3]). Now we should have the
> > guarantee that compressors' output should not exceed one page in the
> > success case, and the algorithm will just report failure otherwise.
> >
> > With this patch, we save one page per cpu (per compression algorithm).
> >
> > [1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b0=
59dd89@bytedance.com/
>
> This is not mentioned anywhere.  Probably you added this as a reference f=
or the
> past work from Chengming?

Thanks for taking a look, SJ!

>
> > [2]: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.c=
om/
> > [3]: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org=
.au/
> >
> > Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
> > Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>
> Acked-by: SeongJae Park <sj@kernel.org>

