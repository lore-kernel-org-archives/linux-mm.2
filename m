Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C060E10AB808
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 19:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F3D6B0005; Thu, 26 Mar 2026 15:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0526B0089; Thu, 26 Mar 2026 15:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5FB6B008A; Thu, 26 Mar 2026 15:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB606B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:18:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B19A113C18C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:18:00 +0000 (UTC)
X-FDA: 84589174320.16.83AFE89
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C5179180011
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:17:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GY3JXy0s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774552678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2fFFIOClRcBFpxa+ZhEGODvSXvSphmThtZt/NUmrw4=;
	b=Bq8H/SZAutoMPb/bTMgI4G3C8IBoMmbmK6F3UDI0lmj650wmqXdNqXha6X1j2OYST1TQR/
	M9W2sJYb1/PL+fs0KlfohK3TkpYh3kgLCfzq1704ce7jPJ9NO/wQFQ9T3qwHYpjm8+yEGz
	CNf73z9Nv3yKBgoarTd/uCY0mei+/k4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774552678; a=rsa-sha256;
	cv=none;
	b=FhG76yYofuDbJo1PyDaNdnFG3HXew7fPgMqg7Oj9gG2/p7PLMvEdQw6AMYsFtXdJDiWsG3
	dTpafetyCrbGfTXVta+EyUyCZYejBp0B3d1R4mRFmmV/r/FBTdI3TJaMzf65gV/YssdR/c
	8O8WFb3q+DPUJ/6COehEpkFFSxcRyAg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GY3JXy0s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 174E660054
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF96C19423
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774552677;
	bh=MIPDAAbAiXqMvXBIOxEoTP500rJ337ZU7Yo9oo0ehx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GY3JXy0sfIJdIm0SatxG0BC8n15a+5U7pKcDBxTkUZIG1jg9B5cr2KTikwQjAMblI
	 4aYOyGPGIzkfvg2frCTWc8URL/tqwTN8j0f4wvLeW4D+0y4ZOQcPuLii+ojoJt0wgo
	 /qU9F1CV31X67OmxQ7h/IemwDc2EfQMF11gfk0GX1I/+AAb8zWSf7HC4M6HV69ql2m
	 MFq+KskoO4rnYqaN7PNliHfzEC0afcCfM9Pr7pRBj3AJsqAulLBX1o507F6L7cYikZ
	 sILjk+ZJ4euEamphD7NNno0yAuNu34apLP/g1ykcPkdHqEHbWoyGoklTtMn93SXmnT
	 ZUS9lGeOMmUSQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6618bc129acso1999399a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:17:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVTobTsRFDBF6lbV9T43sNsFVGNO+Z99w6XJUITDR9El7cOdZEWsUVEc3mOFIg7OsG4LuTgPbSDAQ==@kvack.org
X-Gm-Message-State: AOJu0YxZm5aR/Qm9cAoOzY0LbAT3/WkTgf10JrnmYWj4H3xt3u7NX7Ki
	WTadsT2D4bKIkHgBbqstgVMprWJCUmw2TKO+rStR8VIRno2HfBWoxJ0mdYYudVPCK7Z12X/+661
	jGwJCnfCMiQbJPjJd4NDK2e2JhbeZnA==
X-Received: by 2002:a05:6402:51cf:b0:669:afeb:a6f3 with SMTP id
 4fb4d7f45d1cf-66a8270edbbmr5537445a12.27.1774552676256; Thu, 26 Mar 2026
 12:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20260325090029eucas1p1932917cc4839c3349932aeda37a7125d@eucas1p1.samsung.com>
 <20260325090023.3175348-1-m.szyprowski@samsung.com> <20260325141648.GA2685599-robh@kernel.org>
 <fe9359e0-1c9a-4113-82c3-0275c932a58a@samsung.com>
In-Reply-To: <fe9359e0-1c9a-4113-82c3-0275c932a58a@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 26 Mar 2026 14:17:44 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK9Gn4rZAzZ7HN88eeZWcbAvyNj1sCtn140XK83qDGuCA@mail.gmail.com>
X-Gm-Features: AQROBzC6LkjDlFn6WnwHsN-rfeYOnWBi9c0g8XrRpCGf7exOQ4jNH_gHGfxdWqA
Message-ID: <CAL_JsqK9Gn4rZAzZ7HN88eeZWcbAvyNj1sCtn140XK83qDGuCA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] Refactor reserved memory regions handling code
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, 
	Krzysztof Kozlowski <krzk@kernel.org>, Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C5179180011
X-Stat-Signature: 1aemm7yejutqfsrmbd4m3hpmk3poqgb8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774552678-755256
X-HE-Meta: U2FsdGVkX19tmaoV+h4wfptqrcy4uGRwqR65RaPZDUh0Xi3fxNoIWAF9dnA272D02NWDfgHWsNEf3VM4jl7SaNuYu0ucPdsvTl9AlD3yot520hJ+RRt6LSKs+5IbyIncqvNKhuUvjFLXDE0x6wpPY/Th+16y9+GN6A8WoTBetXPoTdnM+gKdr4rOkeQZAJ5N7ah+vv5a/8IzMkCf20T9Goivq1fVN2yWsWv1c3En2OeB4N0KKEITX8u9fP19xwVJF79W4KekHBU9usizifX40EMbPnuGU7mO8DwL5sQ223AZWmLq1SCRuOiZG32EFctT8kNX4igowHgyDO2c+A4KruUrvTVMUt3V1NTq4ly2V1FzAxPHX+OP+EvKo0XiHe0GjzjllJVA+ItDHPzSAI3gdpBUZAaAebBXPfNTpCb9VMFeoRx/Si69RWCrdeYq6OxqYW7ysKM+aTc9by+sntutZuGdQu4m0MRYDHe18sLXZ7ao7Nqbd8GRI7s3NvDPBwV6Qx0AB3231KQvilD223SuuK3QQxbUrpXNpSrodhEWS9DTUHrhvK+7SiJCzdUXuHxlSQeJmVoQQfjfgSbPLhQz6PWfqRvW3vfxYpwO+xhYOJxKBQ5ixbDSRnnQAjPUlpLl6wDRbsq5ZW4OI7kzn3NFcq8tqbSvHGPQuCpfcm8u7+f9v/WvAeQQcDivkDVdRUmhBJl+TvuSxnNLhyRBCOiN3sqhSuz8WvPL7XMqHWyL4fjkyv4VDU2BGy2i6P+rNGdHaw9pIT+UOJDd2L/FeO3XeFVJR0YBq+7hT2EJaIaHFjU5k1m1qyZWzkSlSqtyTDb8bHK4LY0Ig7rjW2gl15PDFInglVtAnao47C58MrNP5hJGpNMkjfAtGnLKwmgza8bM8WzzVsj0s7LP7xv74+ecwkz4fNJbmN4+Inzwsm+pXiOyeqbQT86htbGSDsXXqixbmwBvEOqBNJXKbd4vicW
 hLxg8M5U
 qEhzv/iHWqCuHyR8pOxfJ88fOiB/q8K7SBP/auXj7UGonk3gkbC8oWLKzeCr5mXG5tAYLeUw5VPb22jMfyWJWzR6stL9yvsz+JQX+ewxdRU+jwKdlO9gHPPaOMA3nNFChmsaP3z7Eg3TWbcDOxSem6pXSvauJU9skCFm9apZkreDHYJqeqkzhqL3AZjqEFTjzJRz/F+U28RE12G8i0Ed3zqdF92V6DtVBxYCGMYmPyeQ5hjidv8wq5loCWaOHjG6uZGljuz7vyP2WrJ5BBaDSpf80L48TyO0d0kWchcSmy9+g0zZjP1h7qg7Fvs/G5AWsnb/p2L1ncj4/gOdBFC/aZ8oXwRdgEf1wIWRfgAkhmDcVU4akFW5XWSTdcHTCjnIYrdYeJexkDdbLrQ0P8zM1xdfbaClMZ3vCOSBB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 4:58=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi Rob
>
> On 25.03.2026 15:16, Rob Herring wrote:
> > On Wed, Mar 25, 2026 at 10:00:16AM +0100, Marek Szyprowski wrote:
> >> The reserved memory regions handling code was reworked to handle
> >> unlimited so called "static" memory nodes in commit 00c9a452a235 ("of:
> >> reserved_mem: Add code to dynamically allocate reserved_mem array").
> >>
> >> The side effect of this rework was a set of bugs fixed later by commit=
s
> >> 0fd17e598333 ("of: reserved_mem: Allow reserved_mem framework detect
> >> "cma=3D" kernel param") and 2c223f7239f3 ("of: reserved_mem: Restructu=
re
> >> call site for dma_contiguous_early_fixup()"). As a result, the code in
> >> drivers/of/of_reserved_mem.c became a mix of generic code and CMA
> >> specific fixups.
> >>
> >> In this patchset I try to untangle this spaghetti and perform some cod=
e
> >> cleanup. I hope nothing breaks this time.
> >>
> >> Best regards
> >> Marek Szyprowski, PhD
> >> Samsung R&D Institute Poland
> >>
> >>
> >> Changelog:
> >>
> >> v3:
> >> - fixed more issues pointed by Sashiko in
> >>    https://protect2.fireeye.com/v1/url?k=3Dc0975fdb-a11c4aed-c096d494-=
74fe485cbff1-5d0a8d4ece172e7b&q=3D1&e=3Dabd3a151-11c5-430e-a6ac-b04cc3b34ab=
7&u=3Dhttps%3A%2F%2Fsashiko.dev%2F%23%2Fpatchset%2F20260323100901.4079171-1=
-m.szyprowski%40samsung.com
> >>    (restored use of _OF_DECLARE macro, extended some comments and comm=
it
> >>    descriptions, the remaining items I consider not relevant)
> >>
> >> v2: https://lore.kernel.org/all/20260323100901.4079171-1-m.szyprowski@=
samsung.com/
> >> - added missing ops assignment removal in tegra210-emc-table and swiot=
lb
> >>    drivers
> >> - fixed issues pointed by kernel test robot and Sashiko: removed typos=
,
> >>    improved comments
> >> - fixed incorrect node passed to fdt_validate_reserved_mem_node() in
> >>    fdt_scan_reserved_mem_reg_nodes()
> >>
> >> v1: https://lore.kernel.org/all/20260313150802.1121442-1-m.szyprowski@=
samsung.com/
> >> - initial version
> >>
> >>
> >> Patch summary:
> >>
> >> Marek Szyprowski (7):
> >>    of: reserved_mem: remove fdt node from the structure
> >>    of: reserved_mem: use -ENODEV instead of -ENOENT
> >>    of: reserved_mem: switch to ops based OF_DECLARE()
> >>    of: reserved_mem: replace CMA quirks by generic methods
> >>    of: reserved_mem: rearrange code a bit
> >>    of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
> >>    of: reserved_mem: rework fdt_init_reserved_mem_node()
> > I've applied the series, thanks!
>
> I forgot to mention this earlier. There are other pending changes
> tokernel/dma/contiguous.c like
> https://lore.kernel.org/all/20260303-dma-buf-heaps-as-modules-v3-0-243448=
12c707@kernel.org/
> which I would like to merge to -next. This conflicts with this patchset.
> Could You provide a stable branch with those changes to let me resolve
> conflicts in kernel/dma/contiguous.c on top of it?

Here you go:

The following changes since commit 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f=
:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/robh/linux.git
dt-reserved-mem-cleanups

for you to fetch changes up to 34e0e2a8ea9e9e4f4dceb33072103dffaa1366b3:

  of: reserved_mem: rework fdt_init_reserved_mem_node() (2026-03-26
14:12:02 -0500)

----------------------------------------------------------------
Marek Szyprowski (7):
      of: reserved_mem: remove fdt node from the structure
      of: reserved_mem: use -ENODEV instead of -ENOENT
      of: reserved_mem: switch to ops based OF_DECLARE()
      of: reserved_mem: replace CMA quirks by generic methods
      of: reserved_mem: rearrange code a bit
      of: reserved_mem: clarify fdt_scan_reserved_mem*() functions
      of: reserved_mem: rework fdt_init_reserved_mem_node()

 drivers/memory/tegra/tegra210-emc-table.c |  19 +++++-----
 drivers/of/fdt.c                          |   2 +-
 drivers/of/of_private.h                   |   2 +-
 drivers/of/of_reserved_mem.c              | 320
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++++++++++------------------------------------------------------=
---------------
 include/linux/cma.h                       |  10 ------
 include/linux/dma-map-ops.h               |   3 --
 include/linux/of_reserved_mem.h           |  16 +++++----
 kernel/dma/coherent.c                     |  19 +++++-----
 kernel/dma/contiguous.c                   |  86
+++++++++++++++++++++++++++++++--------------
 kernel/dma/swiotlb.c                      |  19 +++++-----
 10 files changed, 285 insertions(+), 211 deletions(-)

