Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A5ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AB98E0021; Tue, 21 Oct 2025 12:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B2D8E0002; Tue, 21 Oct 2025 12:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9C78E0021; Tue, 21 Oct 2025 12:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC6D58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:05:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BD58BA68C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:05:28 +0000 (UTC)
X-FDA: 84022596336.06.42CFE40
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id 55634180012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:05:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LXIX0xZV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761062726; a=rsa-sha256;
	cv=none;
	b=AjmADIfFC9xxpSGJJQvVTVbL9P5SjdV0bnulHaHAx/HhwtdlvwB38O7B/hsJ5lnwiw6vI7
	XjPxftLeIDcVSexaWhrCvAnhAL5m31gJYkMYPOb+ZRSuHIkaafo6qEKH6eTZPBgc/QYaR2
	RlXHajhq2LWRinpxrg9h6kwB5d6gXdA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=LXIX0xZV;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761062726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2rsp273D+5b2xXwhTqrhSGacsVEuhyzYQN7tg2ibaE=;
	b=7GRlTnzl4ebURV/T1EJnbi4c/ssukwggrm02QFHjA3o/0EMQSHwA//Z9Jhsj4J2FTJBwYO
	1Z6wuCxfD/30v2TgYANSV8u76aDmqi9wg/cVtTvzMje4dqzdoWFyIjNGvg56mReuLr8+iP
	6PiX9FM6hIDVeJBOW15jnuNI5bxugTY=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63c556b4e0cso7083401a12.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761062724; x=1761667524; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2rsp273D+5b2xXwhTqrhSGacsVEuhyzYQN7tg2ibaE=;
        b=LXIX0xZVX2IUFJOC6P6fvYt0JJhmCWtM+FuyWZtfpIWmFdMzf34WgebgMayLOnSaPw
         kUXOPvULxa0Wi7UuMiD8OT9+b5YAnloGvI2EKCJ2UWhpbF+tuv6WFrcjMjBCyyteELCg
         F6LNlgyQdMtkogEe2QpG2TkD0nAxMfUrwuhNFs86OLz68qR8Ol8leFzdxs7Ywe3Caolp
         DBN47ig8azvQYIy60hfcseM+9BUWceiQD8YrvcvyH6OlvcZBHDpUPfMYw2xREPl2RovG
         NgArGBYmKAH159LOx6T5Ff5UhK3t3lmcPYHeK3K6RB9bvK3Uvk1fjqMA59l2q51GGBKp
         cVmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062724; x=1761667524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h2rsp273D+5b2xXwhTqrhSGacsVEuhyzYQN7tg2ibaE=;
        b=qy7yf51R/MWIIcY/a0GbiwbXkRdo6S5l1Y+AizoIEdQDVK+410pBilXQ0rx5CjILIW
         oIOG0+zxXHwZqviORRpBv9bmnVF85IYWjIwQPuRSy86IEH9OjuouJ76JjxnjQbKDd210
         xoFkxk9eSqZjD5cKHLHvZ6gdMQWWSc830S+o4H08SooO6JcmcUmzan6d39HtoynaGdeV
         GgjMdCtBi8CdgyoHv0edWtjZcPfdxJiHx5yBr3YY7pU20cBX0USOnw5pxppdiFri3fuA
         CusJQ1IWnftBYt+06MnoDhxnBHIJtIk4YQ1OlGk9ZPrbDY/kpnAmTbaWJ0X4HEOSi/jG
         0Mww==
X-Forwarded-Encrypted: i=1; AJvYcCWvcWk/54awYAdx55k0pGSbBFUjgiaroeTHqv+J3j3rHr4V3P5NsSOp1eQOzqMV8zh9oOKxyww/wA==@kvack.org
X-Gm-Message-State: AOJu0Yx2LXuclUZU73VuVauJYuuzVa3BeDqoxcYc7uiBC8aVHTw6Hvvb
	gtF152rohT/NV/44LzLHTSE0GCqI6pUL2/LjZa8+JgSautSN/Nd7r868UKZ1RbfWOuaWAkBiD2X
	pEog+/QBkuW/9UzTp5dY/gZkiWoggUnPolWAcl2LsLA==
X-Gm-Gg: ASbGnctfvXPhQShSN1G4422gKNMy9Sv+gf15hMuQO3bxte/kycKseDxgdSieCgPOURc
	e4EISKSuC4BOv9yADXTp5lDwNwzBzHGXHgOWcBLtmSoUjy6eXHfneOcA1Iat3H7OwbxUT4EqR64
	2upXsZTYy9mS/WcqKoagPQSCR1kB8VqhVO5NunJdNzmPnO9pm6RRjJrIBfNQaPT4z1gDs7G4cIv
	1bofxm7gA9b8xH4GnxOyVpXfBX0+4O6NOuRsY9HLYOFHfP04xuUSt5Qqg==
X-Google-Smtp-Source: AGHT+IEeLKgKPa2ao1C+DHLxoNObY+PUJkOnP4atEfZz4NGBJudxoOmpcHAQfeKUlWWXs9tatq7N0kg5qlHh96IaXc4=
X-Received: by 2002:a05:6402:4316:b0:637:ee0d:383d with SMTP id
 4fb4d7f45d1cf-63c1f62cad5mr17942304a12.3.1761062724284; Tue, 21 Oct 2025
 09:05:24 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com> <aPchmxfh4ACM0vY2@kernel.org>
In-Reply-To: <aPchmxfh4ACM0vY2@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 21 Oct 2025 12:04:47 -0400
X-Gm-Features: AS18NWCWk4RBaudjWOtzT3Lj31f5xnWLUFz70tsgIQAGYSdCdW8mVv8zsn8kkEQ
Message-ID: <CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55634180012
X-Stat-Signature: i4buxrgurmad9mhgcdhqw69dfmz6pqc8
X-HE-Tag: 1761062726-21960
X-HE-Meta: U2FsdGVkX19ki6lCBwoV/2DItjsxi+7as0F67M/BOimoOD6K4vav5cOwEP8o/6XU/gHqIBIdp2xUiTSvQ/+CPAucvpv5fU7D8UWUV5GD1pewxyXAVPYOMal8g6EZ7WM1StpDB3zgyifEWDhBy2GVXOVs8iG4OGur3Cvtu/89vAAb7IVgvZ7HbLMuVvGoqCydJY1k5NY/Umqp9T0pRCnJZtHHkpOUdU+I9C6K1beSqOYrjxT9I5/Jbeqk1FFgR0WjcC6If2rDTHDz8sdjUxcxvJJWb3Ti45w/FZZztJdHRVV9B/n76gRhBLM8JDNpobNn/nZtU0ftZwqmvMGVjm2GbaWTbhHHH6VO9mQQm161AXEdPiW5I7Vc0cPFOit5/tFlYwh+vK7lrIRZ+qKw4siS+bmx3e3wX9RBiTN8iF81vwKCbgiFuhNhgfzfk1AZbforUvKsxUPlvPVgfncSHVQidcT3mI1oNMIyiISjFaK2m0ENjyH6MZMw27VXFKZMXYfIFBy/lTON0sg+34v0gajGzPNtrNq9igRXO1d0SbCRZPCX5k74J4wW0qwkrELr/XE2aFeFR3YS4ebQuPAtmqiIB5Z+iRx+ylwZiI2xPUnKKNEIauTx4IK3BYSQFGRSSU3X4G6wRpa4RhyhCz+kX3fjI++eKJFWw/2OuPpKXgwjVsa8PmUsv5HlHbrKq39p+FJgLvo4UxHmE6i0FHXgtMnkRUx94WR0adVVmJNbPyl0Seq4WEU+AMOWYu6IftNq2BpmNhkmoWKKBhPd2/GvhiSGr6ePmh03Hy92vp6xfiZnC4C0sKVnjarirWt76rlDb5De5lEh9SJVcF9fo/GTNnZ9henpTGWJpii7+BJtWoYiX07mKgygvEf3ZBWnIhfUjJXSH36UnrJRleK4NEsaHXmuHNJ7wSj+2QpS1pTEgueNO+GAUZvdH0fmDpKpUHc6qIlRPoU2sS+6qf8F+D2JDjz
 wheba9Je
 WjKSmissd2jUX5wsENJ31vz7wEFjW44sRG7euonpy/Tzth/JkwAzQY9SRDrkdaHf5ESUYY9y8IZ03vx8k3RuJ75SveFfOm89t3UA567ltvsA6j2wFd9XFWMxxlTuviIpBL7vjLJJoFh2PoSInTOWPAFVZyAYAbmhHT8rWBcO7luDV8VdymkqMXQK88S7khO7lhs1RoG33W+ogRhAaOmYJIUgjbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 2:01=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Oct 20, 2025 at 08:08:49PM -0400, Pasha Tatashin wrote:
> > This series fixes a memory corruption bug in KHO that occurs when KFENC=
E
> > is enabled.
> >
> > The root cause is that KHO metadata, allocated via kzalloc(), can be
> > randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
> > early memblock allocator is restricted to a "scratch area". This forces
> > the KFENCE pool to be allocated within this scratch area, creating a
> > conflict. If KHO metadata is subsequently placed in this pool, it gets
> > corrupted during the next kexec operation.
> >
> > Patch 1/3 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
> > that adds checks to detect and fail any operation that attempts to plac=
e
> > KHO metadata or preserved memory within the scratch area. This serves a=
s
> > a validation and diagnostic tool to confirm the problem without
> > affecting production builds.
> >
> > Patch 2/3 Increases bitmap to PAGE_SIZE, so buddy allocator can be used=
.
> >
> > Patch 3/3 Provides the fix by modifying KHO to allocate its metadata
> > directly from the buddy allocator instead of slab. This bypasses the
> > KFENCE interception entirely.
> >
> > Pasha Tatashin (3):
> >   liveupdate: kho: warn and fail on metadata or preserved memory in
> >     scratch area
> >   liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
> >   liveupdate: kho: allocate metadata directly from the buddy allocator
>
> With liveupdate: dropped from the subjects

I noticed "liveupdate: " subject prefix left over only after sending
these patches. Andrew, would you like me to resend them, or could you
remove the prefix from these patches?

> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>
> >  include/linux/gfp.h              |  3 ++
> >  kernel/Kconfig.kexec             |  9 ++++
> >  kernel/Makefile                  |  1 +
> >  kernel/kexec_handover.c          | 72 ++++++++++++++++++++------------
> >  kernel/kexec_handover_debug.c    | 25 +++++++++++
> >  kernel/kexec_handover_internal.h | 16 +++++++
> >  6 files changed, 100 insertions(+), 26 deletions(-)
> >  create mode 100644 kernel/kexec_handover_debug.c
> >  create mode 100644 kernel/kexec_handover_internal.h
> >
> >
> > base-commit: 6548d364a3e850326831799d7e3ea2d7bb97ba08
> > --
> > 2.51.0.869.ge66316f041-goog
> >
>
> --
> Sincerely yours,
> Mike.

