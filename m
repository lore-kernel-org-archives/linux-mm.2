Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83DD5CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 13:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBE36B0088; Sun, 18 Oct 2026 09:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2FC6B008C; Sun, 18 Oct 2026 09:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410956B0092; Sun, 18 Oct 2026 09:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 176136B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:09:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B915A6D82
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:09:33 +0000 (UTC)
X-FDA: 85335778626.23.9CF9606
Received: from outpost1.zedat.fu-berlin.de (outpost1.zedat.fu-berlin.de [130.133.4.66])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4BFC8120005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 13:09:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=kigMjTXk;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf29.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792328971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ad+KRCeiTeq89I8EAoLhJ8IoqMcKydtjkjF0jccydEg=;
	b=qEH/rpwubRRI4T5kwa/Cb+dcUjfKFfad7Zqxrr54l8K0eilK43fDQwCrsf51jeuJ7rK3UN
	sgSCeg04CGJob7znB0WlkvTC1qeBFHCfuQDGpgfbCtdT77kOMOro/h8gNXGRkse0K7Lddb
	IEUCC64Mq4Xppo9Z7snrpWcKFR6RuX4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=fu-berlin.de header.s=fub01 header.b=kigMjTXk;
	dmarc=pass (policy=none) header.from=fu-berlin.de;
	spf=pass (imf29.hostedemail.com: domain of glaubitz@zedat.fu-berlin.de designates 130.133.4.66 as permitted sender) smtp.mailfrom=glaubitz@zedat.fu-berlin.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792328971;
	b=KwXYLxhGahhwWW3khPsV986ZcJmIQeocJapGacVmyctfoVzRUYlneDj1IlWcW+5EDuLhCZ
	mGqxyfttGqjBgg519HHmyJMiHpBSZVcn789+ckaJAiFmfTD+wqemn0CsF+YLtYJozZs9Zc
	CPb2vMxn/3P9du6HYUmXPpVlq31/E34=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fu-berlin.de; s=fub01; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
	Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=Ad+KRCeiTeq89I8EAoLhJ8IoqMcKydtjkjF0jccydEg=; t=1792328971;
	x=1792933771; b=kigMjTXkUwSp+SrcwtX2xz96or7lgbM65MstGbLtdfjB70lSJwcdldny0d73e
	FZR8WopBvH+uYXXcy0bPHX/N5RhbcnNeBTUOWTTJz32EAWWN5C2IQo94I1T4Xgq6+6hAdvAjRzNZf
	KbA+mBYv3ARhVLrv2GvuHSR6hFaMGsvebQYtk3XNmfmh1JEUKgIBf1rLduwqbGLxU71Vp0uVkhu1R
	yZQ0c7JJc2HLoiEbVA02sCsHIhj3UNw5+aSH2/WPH1fkbt/QWZaEE94XPq48wkEzsE4v2qnufF2/u
	Da3sr3VA/vUji/RFbSY1gbZdR6COJtwEfRaM0+ZkfIsS7IZ6eg==;
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.100)
          with esmtps (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1xIQdh-00000001xYw-3xcj; Sun, 18 Oct 2026 15:09:25 +0200
Received: from [45.156.240.96] (helo=[10.13.52.99])
          by inpost2.zedat.fu-berlin.de (Exim 4.100)
          with esmtpsa (TLS1.3)
          tls TLS_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1xIQdh-00000002g1r-18WS; Sun, 18 Oct 2026 15:09:25 +0200
Message-ID: <e3068b5c97884032e7cbd12c78f6b5534d75e30c.camel@physik.fu-berlin.de>
Subject: Re: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
From: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
To: Stian Halseth <stian@itx.no>, Andreas Larsson <andreas@gaisler.com>, 
 "David S . Miller"
	 <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, Michel Lespinasse <michel@lespinasse.org>, 
 Jan Engelhardt
	 <jengelh@inai.de>, sparclinux@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 15:09:22 +0200
In-Reply-To: <20261018122734.2594904-1-stian@itx.no>
References: <20261018122734.2594904-1-stian@itx.no>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 45.156.240.96
X-ZEDAT-Hint: PO
X-Rspamd-Queue-Id: 4BFC8120005
X-Stat-Signature: kzjt9156zzucwr76h36iyunsm1qd8rhh
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792328971-287861
X-HE-Meta: U2FsdGVkX18oN4rg4+EmR5nP1isFMvyjsApAv3oqz3qOqNIWgtUxs/FJsdz0clpGYBXKv19lk9PVHJfxgfpLf5NnvFy47aejak+Qd1XrfpG3+PAgSOmeVdqNjo3QrJz1Sk86kCpkWCEJPxiUCcsDEDf5DpAGFqB7YS2OJ3kaHojx+HOjmxxUm6/Xs6yvGJ/AjCVa7+X4lxAkeZh/DjuL/a0ymf4/Q4tuQc6gu0ibdsTg2pcJ2OpBzRJOwv9orXwDkVPb/Eu9TA1odwWhBK9totWfsPCguJ4FkXS8qhQj+JiY9jb/ncMg83/capdosTxkTEpMIPGWomWj/6+gTJod5Q6k5sDtLcLBpazL10AsLPM/scUpuVKpTUfP0GEMGFrt+0lI6nxBpzICGGg+yfRxLZcFMzboDtyQVEyo+yFbUx5hEYwdnf6nqlRCXVWmkHArM6EJztxY9B0JeZXDX2yxwpG8bnzHvLxOIoZVDsrIYFrexPe/a6WOs84yWLWXr6Dtoo2qZ0GndgxQcalG0KqqKGkewvnoec9J+83t/6qacrMmJlGfw5oFPNhMp+Ei9W0Rdq4Ii2IID4UdhLfledBakZ7/ymD4XzHSsKMMZhR7fe84uBE96Mx+voKO+Kbo/xu0rJDaOq1zwN13A6UCEHZguXn+kp/P+ANdYeIU/YU/tFhrIvYGZ+hNdeFKiwFNozifQZxQ7qIcKLUxwxKQ0DNzE1lnokytVhgGH7wovAV1CEPeG9DI1TfK+Z4S9kHtfij97xQd4HDrnF/WLqVzATMKpoWLG04mCNhCXC+llWRmzpbIo/4FuMUi4s61qaXWCvuku8KyNzsT0c3t4EL0fyqmx6OQ/9rAIF9JarV10PSG0TsfWyLP6mWArmq7yM12b8wiozPz1AOYHiI0z3sL0vFHlCzswzMPmOzHG6L2T+nXxtomQLfkmn9H/uqSCYwXKWvniloueot+XQ/D2ZsU3lZ
 FRuSzrBJ
 6KEUPWCWawo/rvPrLoHma+gWx9kjZkXdt8KPgkh/PorWZWnkNuZBfH3fEXwVW/5T2pmuurbCwwSa3um+aV2E4gs3huWctsxYfrsouJCFjeALr55Wg4G0+xOApsJoKlsFOq45/nwuHmObxAjoB1G2EETasCv1PuydnW3AJOM1nsKNC88ME45Pa/oV8/fWzIk2GSK+TeL2+Dvrv4WZ5lc1Jz0K0MsCuKewk2QwTgrpSE1n7J+z1gqsWy6Hya054UwDpuhAZ4x00hhiPb9/lQM5A1xK7lQhKE4KMAREmBrlt0MgQ+dzpIV/V7pFoPON/LT7ckcZNFRml0iIWCB6BOlmSbK1BXz5guLAAMuA6OPqpi0O6XTWk8Mg6cKZdxqUnRYK+UYNRbkaHnlpg5nqFcGMHrzTcTc1X8Mlc+tTQPkoI+kafvBttf1zSSwvcXYFtwHUrd2QPOfA5BVqfTp0FRbKp2T/hriwbAGp57u+32HRLrNCJtUolfirI+O+zokl/aCneUIfI0mm5Vrs/kHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Stian,

On Sun, 2026-10-18 at 14:27 +0200, Stian Halseth wrote:
> On sparc64 a 64-bit process gets little address space randomization:
> the stack moves, but shared libraries, anonymous mappings, PIE
> executables and the brk heap land at the same address on every run.
>=20
> Patch 1 makes arch_get_unmapped_area() start at the randomized
> mm->mmap_base again, which it has ignored since v3.8. Patch 2 moves the
> 32-bit PIE base out of the legacy mmap area, so that patch 3 can select
> ARCH_HAS_ELF_RANDOMIZE and randomize PIE executables and brk as on
> other architectures.
>=20
> Found while adding PIE support to the sparc64 Go port:
> https://github.com/sparclinux/issues/issues/119
>=20
> Tested on a T4-1 and a T7-1 (sun4v) and a V240 (sun4u), with 64-bit and
> 32-bit userland. With the series the program image, brk, shared
> libraries and mmap base move between runs, and with
> randomize_va_space=3D0 or setarch -R the layout is the same as before.
> The exec and mm selftests, glibc's elf and nptl tests, the Python test
> suite and a kernel build give the same results with and without the
> series.

What about sparc32? Does it use address base randomization at all?

Adrian

--=20
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer
`. `'   Physicist
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

