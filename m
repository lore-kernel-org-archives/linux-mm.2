Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97FFA10F92E0
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 16:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2046B0098; Tue, 31 Mar 2026 12:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A196B0099; Tue, 31 Mar 2026 12:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1F66B009B; Tue, 31 Mar 2026 12:42:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD8C76B0098
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:42:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A617416032C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:42:35 +0000 (UTC)
X-FDA: 84606926670.08.7DE0EF1
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DDF0100008
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:42:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LTjnqWjO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774975353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWXcgZxwCe/i5vmEyRuiCEIOs8zFNjOOEmunu4K6OG0=;
	b=d26+PYpDzccBANgeZKL+9ldfqbfbj0+2zvPgVHJcUwYuq6iDQLHaBjsa1Hg/IU9+1DQAHR
	ZWCiZNLI+H3wSd6dcp8DLKQBKoiCZ3cSkZJKXR5po7yjiVzkYjgO3+yFDU7iANrbCVyDL/
	0ak8letaqSV7sCInoJOGDzseKPlZpws=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774975353; a=rsa-sha256;
	cv=pass;
	b=GhsH2CSEEqpc0qaz1oMVpDjTXW7GeTIUQnpdwsnHKr50ptbrN/DdmuZgDB9xghYso7dO3n
	jXsGisS79PHN84azMgFGrz+y1ywsKdni4wS5ZHKbXDbymtR8WJjgSPZt8cAcWN2kNHNgNB
	hJVwPETmo2TP1xm6E0h+0P899tMtpFo=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LTjnqWjO;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b980b35534eso9852466b.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774975352; cv=none;
        d=google.com; s=arc-20240605;
        b=U8x4KoApUrnyKUelo3R0GmxCFkJV7ZWu/YAHAX8NA812lUK42oRn5FWHEwcatgI9WU
         htTLwDyDAmPOjJAYZOI2kNJ5imT0CGl6lLOy5JGdNOrEq2EUZb0QX1X1a5Puf1fNm5iq
         eXLcVG824GRPHcWB+MlsENiXdIvUgztYmOvLs0BTrd10+y+nwKbk/qjFY4jGa8USbSSC
         Yzo/WA/JQiqLPCfTuSyrOzg+IgLsoV3mhG4JqZS3iPRfFHPHkm7pPgoSPzcuX8HDeLiK
         Jm1HNPeh1/jO3gW3wAgfznVGOdQCLlXUnvEyLnVBZgRE2GlFy3SEDlsM+S2o0pPgZr4A
         rWGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OWXcgZxwCe/i5vmEyRuiCEIOs8zFNjOOEmunu4K6OG0=;
        fh=aCJ3Yln5MLdjdHDtKpnhBCG9CtJFCxA90umqWbwNssM=;
        b=QBT4m2W+ZmvBgJU/keqPM5nvO6+TloGaxnTGP6o8IoDmiYfRhs15Kv09Apfz1MYtla
         ZXzFXar+Q0Ena8S4IXNWx58uKx1hSxuKpI+t69hfs7lpCaFWGr26XF0rEJuSQR2qGu3N
         yUk7jB5h36J1KQqgS/kZKTx7NB1HcsZAkZHPnaoL+mp0E9znMy3k2mOBpbZzZTZtdLY/
         /amdaA5S6m50zgJZtFkHEwrIFusINAYvkLh3vm0OQgopAAfRgqd23lslRTQD+UrUqcGM
         DxOR7sTnOJAnzj8dgcu7E3KOsTI2j77s9q/wO0BCgqZHoSFK9BVd5KkOT35rzZ2VctNL
         ufOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774975352; x=1775580152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWXcgZxwCe/i5vmEyRuiCEIOs8zFNjOOEmunu4K6OG0=;
        b=LTjnqWjOw5xHq/xHhiq9RTzntSB1YfKzxuLGT829lGQ26IE/9oeq0h+n2Jk3U9Z3GZ
         YW/isemiAVJiSKsXs6Ep9kSriuXRWPP014gB0v7QlAQ2lCbHxDpegPX2vyMaSleZQfkO
         xmMUFCqBuQ5JbrSuVduSe7IVYTEc8K3jhdANUOaQJSMAYhH8katoMoxeF9lZOQub0USv
         LqBeQ89DVdgscSZj6c+zHLXrAuAHkcAN/WdKH/ufVw7U4NM1sylH1xp6xqcXEngdJPin
         vWQcZEE58TFLmQzGYldsdViKHgUB44s1DkySqWmFXe8bv6MDlzBEn0B2PSGUCK4ohwen
         Ybsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774975352; x=1775580152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OWXcgZxwCe/i5vmEyRuiCEIOs8zFNjOOEmunu4K6OG0=;
        b=AQMGrjpcsdj4ufsKNaieH3IU+TkdXseJySjYrb0sVZM2d00C4iT2pAL4kJUnTX5/0c
         jcia/oMwhVKhrryyYDLSMDIE4yfblyQW0e9ing/KoRbj7/qDzD9avqmmAzSwPlrxj19D
         cLVZQNEQVpu4abJyUGnGb9d8RAA4VFvGKzCprcAlH7u+Id1Cho9Y6KZ6iPub7ssSOv+x
         eI6/WcT4WcaSkkDmsDxojtAdJnHSPQyOt92PJnd0CqDkQEStgg9CGKXB559/hWuX6Dfz
         L0sAi8IghATSXOm1n1oFifCs9yPJOoyhbofd9e4BwzB3P8RLE8JLGG98T9SG1ZYn8g9z
         gjcA==
X-Forwarded-Encrypted: i=1; AJvYcCVRgf/CM6z/GuayGk0/VI/b004NdM8h9NQhJ3VzqTnTQfhhisyu8GoGxHWWZhpvXTuBjz6Li/OpzQ==@kvack.org
X-Gm-Message-State: AOJu0YxwZF0CNpYQPjNn0StPAEwlnk1AzhDbMlVQp3drm4N7QEHvQYD8
	k7N3fp61vG+Yyd/iz2Msft09qL4iBRMAPCyTlB+C1pmhYo1ZjZk3K3BnQU34WEaBpZ22j9pjnmw
	ap4A3Oj5/tadqhyQZ1vQJZND7StrQJ8GEaTiiJV3dCg==
X-Gm-Gg: ATEYQzzSvgneIKnzmAlN/ef8y4KtyljK53vtKDZRLr5UqT9Wts9s9VR3T2QesPoGA0H
	PV/Y0KHR6p1bXjBX4XVaWXvKkOnT0DYMEnDB91BI1QAsjYBiG9yFBiVvMrADgn3EhA3eDmkE4pV
	EjNq1N64/djjE4d6ZS/3Yrh94R1ZhZ8agO5ePkgPpiAat6X2vnLv58pKc+PiRtcFzigaD2Zsk1e
	hlU5L+157XMKWkxpaJ7m0sKeH4h2Q2vwbLk7BgVkVcvS3TPzETk20+clbMW8lrxfOTk2Tiw7B6G
	DZtr6wXFj8XeYdLU24ZNz6fxDAxUbGkmxk7VaQ==
X-Received: by 2002:a17:907:74e:b0:b97:b149:4e72 with SMTP id
 a640c23a62f3a-b9be88c4be8mr199825866b.28.1774975351482; Tue, 31 Mar 2026
 09:42:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-3-pasha.tatashin@soleen.com> <2vxzecl0i8rv.fsf@kernel.org>
In-Reply-To: <2vxzecl0i8rv.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 12:41:54 -0400
X-Gm-Features: AQROBzDDXSrXnDAF2LHX_tDmG-n3BYfL4GNehGeRWniM10iq-caP3N77QfA66TE
Message-ID: <CA+CK2bDFidSZQ+UevEXPgfF2BWkN1AWkb2iRWGxUNV2iLpJGXA@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] liveupdate: Synchronize lazy initialization of
 FLB private state
To: Pratyush Yadav <pratyush@kernel.org>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8DDF0100008
X-Stat-Signature: xmd47sbqfodw9bijjgowyzrfck56jcd7
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774975353-658984
X-HE-Meta: U2FsdGVkX19fdb4vmqjiTZxb1PJFDtg99hM4s2RmTby9llQTLtoGgdI/Q+wPiw31HqhbvUQbsVKC8qhwdPc63WXx807BXiQ/Un3LFo/iWHRnqs7jBATxVUIHp5LCzh9Y6E7V6YfHSRnMOqCvGd81XnLUzCbXspRwNcLJHXbk/tZOqmXWcO5vqDAFXpPBQ97QodZSEvflGgG0UR0olzhWaPmMPpcWsM3THg/WipJMZtlFqS5NUyB4z0e5GH9zLD6aB9Bij8cEshQoYQ4cabZZqqsZF6I3GNFUgCkZNCQqPJTInYR+aSIb3fz+6uCuK3vqSBex3FfhvAwjINTPqFXWBR2RfVoik34WbWNzhiiIDchXg6Thq3F3OcfN8+rIXGd5yJVoH04pu3OM/DKcWIbZC2li25/eWaw1Qbq1xcwGuhF2VXTi7gZfL44S5rZcEnLm0BJos91+7kb2aQfxXZ0bkpNtfSd6t0tlqqoxAeLnUJCURUDj3ns0NKNshdKR2FlnRPSvIsK0aG2XAPvRAOwIk7SIYXHuzRvRJt3Msahyg2LWmq3Akmr5QazotOdWSBleSBwged2Kd1ldh0bzEGx33Z+oubtqPG24sDquBV7lSenPg16pOYax5jwgqeUyiTE/Ewdf/RRbDw7UfFzyE1a06LI/OtUAr6Pj7H+ukvkD7iZ/v/9WAreJGN0ZH34jfzYaUp25BhJY02BznZ4iNiPDPEeX9dHJh7c8Qzkf3UY4pm0NKZ4vhn/QHXwuitQM30S3FG39dg2DeDCpYxf9yXn68f+FWvgWzPMBz8dRBkJ/DHvu1+tGftdWizRK4zWiD9m+apVnDzmz/7CQTvrsNwhvnWednUQ9SxiVnR9IOHyT4Pb2Yr8HoHKWKTO1JWORrJxOj8FwjdEp2vtWBaktPpj/2Zt5X06qiSElzQngJYdbPDfwb54yCBC1bYLuRd27d9KNFe5xroEiDcaonf+Otq/
 Egl7ltcE
 iKjee3n9gk9p50lK5xPmb/51Mu78TtIlMXac/97BVPWM3vPYpLIFcYC/NusXbvHRRf3mXOGzlsJb0hXzMhjTfK88VvLdpEknb29dBBI1P+0yqZc18MNxKY/+6u5xvl9LZwkKBVZuT5wXSRYsbPTt6eVXq+nmsxkOs0LVXP0ZZIUVt14KvkbXpubTTIp/O5ZiKm45jFMWeKPsJfG4Okdj4ch1yoWTZQeSVUj77tuJBWYPJkTfsRZgf3D2aVtvR5rkso0jcXQpt60G6XudqCms6R0Ep1tuQUgqVWADXJ6rGuxwP25XBXbnuM2QTOhDnXEMk4jVc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 6:38=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Fri, Mar 27 2026, Pasha Tatashin wrote:
>
> > The luo_flb_get_private() function, which is responsible for lazily
> > initializing the private state of FLB objects, can be called
> > concurrently from multiple threads. This creates a data
> > race on the 'initialized' flag and can lead to multiple executions of
> > mutex_init() and INIT_LIST_HEAD() on the same memory.
> >
> > Introduce a static spinlock (luo_flb_init_lock) local to the function
> > to synchronize the initialization path. Use smp_load_acquire() and
> > smp_store_release() for memory ordering between the fast path and the
> > slow path.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you.

>
> But... wouldn't it be a whole lot simpler if we introduce a
> DEFINE_LUO_FLB() and get rid of luo_flb_get_private() entirely:

We are planning some updates to this code in the near future:

1. David Matlack will send a patch in the next version of VFIO LUO
preservation series to add liveupdate_flb_put_incoming() so that
caller can protect from race with release of the last FD release that
will also release FLB.
This change will increment FLB 'count' not only when FH uses it, but
also when the object is being accessed.

2. After I plan to convert 'count' to use kref, and also decouble init
and liveupdate_flb_get_incoming(), this will allow to access FLB
object with interrupts disabled, as requested by Sami for the IOMMU
work. I think, that while working on this 2nd change, we can also do
some clean-ups if necessary.

Pasha

>
> #define DEFINE_LUO_FLB(_name, _ops, _compatible)                        \
>         struct liveupdate_flb _name =3D {                                =
 \
>                 .ops =3D _ops,                                           =
 \
>                 .compatible =3D _compatible,                             =
 \
>                 .private =3D {                                           =
 \
>                         .list =3D LIST_HEAD_INIT(_name.private.list),    =
 \
>                         .list =3D LIST_HEAD_INIT(_name.private.list),    =
 \
>                         / ...
>                 },                                                      \
>         }
>
> I can't get sparse to work so not sure if I need some special syntax to
> initialize stuff in .private, but I reckon we can get something working.
>
> [...]
>
> --
> Regards,
> Pratyush Yadav
>

