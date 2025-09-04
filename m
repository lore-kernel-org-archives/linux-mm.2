Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAE35CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 09:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320C48E000A; Thu,  4 Sep 2025 05:39:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F84E8E0002; Thu,  4 Sep 2025 05:39:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2353B8E000A; Thu,  4 Sep 2025 05:39:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13AE88E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:39:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 922901A0AA6
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:39:19 +0000 (UTC)
X-FDA: 83851069638.04.F44FEF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C7ED120007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:39:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hq8dWolf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756978757; a=rsa-sha256;
	cv=none;
	b=ukN0+xb9W8nVV/TPVws95hV05tpGeELbP4GbyHM8/POuGM1tsSm/2zPVi97nHkE1uLSQQ/
	gXsiYcAoPGR0KRMjOQ/76t3Y8YmDUDlu225dAi46TLQ1IPQAbD8uq4c/h+J15UZ2v9FfTI
	T7y6gJibdNtJVqXO0UbRPttdUKi0tYA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hq8dWolf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756978757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqwtBP0K+7f0j3IdSu9ZNLeR1MixCwE8h3oP16EJpvM=;
	b=4kBtzBxJhA0Gkz/Gsx0TLHJt+BRkBP33myjtYd17dvwdd4t7TDS74pFzkrhKamqp0AY+wm
	N6OPEzk7R1SeUX4yiT8YBscVngYt6v3ODmBDre/9U+n/NqFt0pj2Qv13fjC3kkl5v+x3De
	F+hGmCfQpPNO53kEak73FF/PQcM9G9c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 252E744AF5
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B7BC4CEFC
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 09:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756978756;
	bh=b7BACgAwQUb+uyXmCf5NXBvllTt2WyPGKAHbjgfVB+U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Hq8dWolf0lAYzF8jShP680EJaAzvGQim5Lr2AfrQ+ynHO4bA1yUoLufGdEjFWxoDt
	 WueJWqG1gjLENcYyHwFD5cR5wiD1q96ufPzHkiUEZgiq/iJ+N/Fh/WFzgbupuusSXV
	 J+Uxdr6+jY/CQ13BmQhYpvw7+3tqOG7fHtUC03nC5V5Wtrs1mvWDn1HVoFdWQSxg4W
	 /GEItyCPqtMKGEHnHChwaXCQdULZQDHHXAsgppVPbyaYGyRqpYzHK9MRXPU2FRZvvx
	 MNrqF5Tep+j54821ldD8OUoF8un94CzR2u0VZbVY7vhVxzWpxthQhZVLZWSHgJbiP1
	 0q7SVgtv4I0Bw==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55f6abcd26bso2334208e87.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 02:39:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXA61ay0B/cFtv32c7bR/S0YQUmxwYTHpDqH/6oCr8ek+dKY27m+YqVwfV3ffoAdtwzWJPAALENmg==@kvack.org
X-Gm-Message-State: AOJu0YyO8yRUCuGhHauVtlRUCPxgbhQzNVKjcWbPQk3igjUd4WpqOo2F
	6Y/LFh8UUz1qxh7OBGEVoqVF3YNdkrUvOuyx42/lQLtIMUa78LS3bxelI9ciBD1rxQJ4hsS3QSl
	6+c+jHAptKbRcgrY3sO1tPRAqjooj4r8=
X-Google-Smtp-Source: AGHT+IE+sZix8HxDMFoQ4qCVA3ERgwP0vsD+zEJb2XElfW+EN65uuxN8+XQS8HhSU1B4zUIkMiL6fynWNcS2PalYMqE=
X-Received: by 2002:a05:6512:63d9:b0:560:83e2:1db7 with SMTP id
 2adb3069b0e04-56083e220c3mr2265147e87.6.1756978754251; Thu, 04 Sep 2025
 02:39:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755721529.git.epetron@amazon.de> <b34da9fd50c89644cd4204136cfa6f5533445c56.1755721529.git.epetron@amazon.de>
 <CAMj1kXFQwOHyQg2LtabMA3qxiBn_AVV_JNfki2WPSg8u_XbBcg@mail.gmail.com>
 <CAMj1kXFzKzpoqczq7Rk-u+kKLFO057XEXMD+KM=iRMMsoUZbJA@mail.gmail.com> <20250904093455.73184-1-epetron@amazon.de>
In-Reply-To: <20250904093455.73184-1-epetron@amazon.de>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 4 Sep 2025 11:39:02 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHTJxBMFX6J-QwcPRojLGMQsTNOH5Bz9kHk7CFdt1JApw@mail.gmail.com>
X-Gm-Features: Ac12FXwC151u6vsYrsntF6Gl_qF6tE-aW0TPl91D1Up2Kpmz5zWqn28--0rAVOE
Message-ID: <CAMj1kXHTJxBMFX6J-QwcPRojLGMQsTNOH5Bz9kHk7CFdt1JApw@mail.gmail.com>
Subject: Re: Re: [PATCH v3 2/2] efi: Support booting with kexec handover (KHO)
To: Evangelos Petrongonas <epetron@amazon.de>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, 
	bhe@redhat.com, changyuanl@google.com, graf@amazon.com, 
	kexec@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nh-open-source@amazon.com, 
	rppt@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C7ED120007
X-Stat-Signature: xrqfm5ojq8nhy1dg64u7jsxk1kgxr5jm
X-HE-Tag: 1756978757-490220
X-HE-Meta: U2FsdGVkX1/tGa325vYTq81P9c2IKIT5/TsffB5LHVPi2mOYaw6ceEWYrNPYIjzQ0PI0Cntq+PU0XJg0i5TYdAI3lW1Ko95jyHf3sQ+vqf3yktM9cqgGaGKrXl1iB2rGC6qSOLYkNWEzmC0KcEXsz6VM8C6omfYfjQvgzdEDzOIYLqgBwSDA75BY1qxVPiWXGa9hcUYugMr0BTcTz+4s1FwLK69YhYL3NSiCvqtNIeNm4sjjahwqPgtOjyN91oRiCQ4AOCicAi058G4nboUo628QQBarkA9Xxh5CvV1XDiJ6FFtLkTGUAPaWUwo8Ejbafx7VoDxuTg+HA1K8N0hPJ94lZxKxs6jSEBg0F/LuJWXzfuwM1rxXAUdnnwqlnrucc2+SsQoiS9UBO/EAC2ZfvRCF2HKRR1v+RrHiYvStH3NkHlP1aDrzqRGjv6UjopsWi2YFOGv9vYieOIGgfwh15pgLJ7ghZOQHDnuH0uP1dHnSVHUhG7dp4PVBVs85W55q/KUOyyqsx2TQiAYzXm0NpKRRLWpAk/oDYBSZP15aUNaB9rcFTXOo06lBcFW2zqviYR2NFA1TphMhxDHN3WaVn9uBxKvHG8++EEp6PKneeVCg4pl1QFv4/doKAK2vFEqvmuBSMcTay7mT9Naht6fqxQE1552/ShjwYJsTcReX5b15h/bYwvUCf/pT27b7V+jC+b1vmXXTQ1QtbxIkCC3DU6jke+DTGAH51JzC2TacZW1Z4w1WiO80bLQMrdjoaqu1LSKJT1IfaYkB/QZSdR2nEomXLaaAgA4uJ/NM1gCwU4WNCurrYRDyzPlAmnVqBAIzwUrl+lR9KxH2SnB3QxfcCQpNqOYirOlS0b5/RDCykumJ7/TyTx/gwcjdOgsE2ryoiPLel44DYKg2pOA/yCtq8RmawFi716fI00rodgEPE7PprnUXyabv83TkP83FVFfc4OHgNjc4FF7jOdann7z
 YpXH7bBq
 17nTp78qDxWjXuAK3w3Wr2X5XSPIAnbx2y/6lNkq2CQOUZr3WQDwXt2YsUuikrUObbXP8tQfFm9cyEj0VsQW34b96NQmxHKelXfjs1vZ0naUc7p2Q0A8YqqOgTx5opkelu96IKiRzDHjVKIpoED1jcDOsebAdvqujbT2RxHcX9SoL8ZM/3wmlRBZSPgs7+UP/ET1CbLJcS0kdbGVXdbZ21VFjEuevw3V0jOmgG7dqjdpZADcj9fE9QAMvefGusRXVEx4aiRFPpp1P0gyCYuUKYRfYqMPIS+pXq60mx/OXa5MFTvje11vKo7pcuUfLpv2++/zI1e8mIpk/J/gJ2C1JjqXd+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sept 2025 at 11:36, Evangelos Petrongonas <epetron@amazon.de> wrote:
>
> On Thu, 4 Sep 2025 09:19:21 +0200, Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Sat, 23 Aug 2025 at 23:47, Ard Biesheuvel <ardb@kernel.org> wrote:
> > >
> > > (cc Ilias)
> > >
> > > Note to akpm: please drop this series for now.
> > >
> > > On Fri, 22 Aug 2025 at 04:00, Evangelos Petrongonas <epetron@amazon.de> wrote:
> > > >
> > > > When KHO (Kexec HandOver) is enabled, it sets up scratch memory regions
> > > > early during device tree scanning. After kexec, the new kernel
> > > > exclusively uses this region for memory allocations during boot up to
> > > > the initialization of the page allocator
> > > >
> > > > However, when booting with EFI, EFI's reserve_regions() uses
> > > > memblock_remove(0, PHYS_ADDR_MAX) to clear all memory regions before
> > > > rebuilding them from EFI data. This destroys KHO scratch regions and
> > > > their flags, thus causing a kernel panic, as there are no scratch
> > > > memory regions.
> > > >
> > > > Instead of wholesale removal, iterate through memory regions and only
> > > > remove non-KHO ones. This preserves KHO scratch regions, which are
> > > > good known memory, while still allowing EFI to rebuild its memory map.
> > > >
> > > > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > > > Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
> > > > ---
> > > > Changes in v3:
> > > >         - Improve the code comments, by stating that the scratch regions are
> > > >         good known memory
> > > >
> > > > Changes in v2:
> > > >         - Replace the for loop with for_each_mem_region
> > > >         - Fix comment indentation
> > > >         - Amend commit message to specify that scratch regions
> > > >         are known good regions
> > > >
> > > >  drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
> > > >  1 file changed, 25 insertions(+), 4 deletions(-)
> > > >
> > >
> > > I'd rather drop the memblock_remove() entirely if possible. Could we
> > > get some insight into whether memblocks are generally already
> > > populated at this point during the boot?
> > >
> > >
> >
> > Ping?
>
> Hey Ard I was AFK travelling. I am back now and will get to it.
> PS: Keen to meet you later today in the KVM Forum.
>

Yes, let's catch up!

