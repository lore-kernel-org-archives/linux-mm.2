Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D791CE7B06
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 12:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A6D8E000C; Fri, 14 Nov 2025 07:52:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01908E0002; Fri, 14 Nov 2025 07:52:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E8D8E000C; Fri, 14 Nov 2025 07:52:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84EF48E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:52:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B1828879A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:52:53 +0000 (UTC)
X-FDA: 84109202226.03.4245752
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 790CDC0009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:52:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIDx9yAS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763124771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJlsB4J2zx7QXsXQmzFa/boQF6nqSXqjf+sMH02hV3M=;
	b=kLX58UYcD3f6IUskOc3jrhqHXoWP37Qw7HGI5tQ++ym/g3Zjl30YjefZYd7OHoE/++boGc
	tp7j/T296zfPFzy1hYNPp10+EiylSWkBVwNA1l5R6W54xOweG853F35CAB04rzOp62sbQ8
	PAqzN4U0mb8iM8uv2npKYt62zRF53hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763124771; a=rsa-sha256;
	cv=none;
	b=SXLIgdFjOO5+wGOEs9Lwp+CEdRuAfe7w1DLIfls8n/KViqa51pLO/8sDnHUfAu25cWQvlW
	eKjV5o+xwUy6e1s1L6LXM1dD6OVcqGror9XQKdJyHl2lmyR+yo6KpkWWiEiHFR1/V6N0Wx
	VKBW4zoK6ot8XR0PsXdekGgRWL35YxA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QIDx9yAS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28E67438B4;
	Fri, 14 Nov 2025 12:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14DAC4CEFB;
	Fri, 14 Nov 2025 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763124770;
	bh=6VphuKq2Z604/Y/bm30jdFUeDgNsvqjJPARDxw7M1cQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QIDx9yASFfZiqhuxTYbuMYVdvwU6dUNnk/MSujK+ASdclnRPOUZbNTQuCis2Ilc1P
	 hrXneM9cQ8B4FIDoDxqrePxMR2KL+KI5xN9nKFyK/5DfnH3SbitdhzIZx1jqQyqSSQ
	 7q/APRxayxN0XdeHDdi5MxaJzyk1DmFr+EGTv39iIikknUvi1fu0TTW3yeOotU1fRU
	 /fAvtaId9qE2Avp/ifpfgmcISSPp7lm7aOGeXjR7MHTz3y5on6lVYGFmPBs1LpNijB
	 yuJXap7kcbkF97Raabtgb+KCs6nVrnt+Uund+fDtKIgdLu7WA1qJDJ+pjxrxdv95pc
	 t0QKHjPHozJ1Q==
Date: Fri, 14 Nov 2025 12:52:42 +0000
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: arnd@arndb.de, Catalin Marinas <catalin.marinas@arm.com>,
	linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Drew Fustini <fustini@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Krzysztof Kozlowski <krzk@kernel.org>, james.morse@arm.com,
	Will Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	linuxarm@huawei.com, Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v5 0/6]  Cache coherency management subsystem
Message-ID: <20251114-juror-stiffness-046b47b8d9f7@spud>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
 <20251108-spearmint-contend-aa3dd8a0220e@spud>
 <20251114124958.00006a85@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yeJqfqlYgNstOKbS"
Content-Disposition: inline
In-Reply-To: <20251114124958.00006a85@huawei.com>
X-Stat-Signature: i7jkxz6wk8m7e4a4yxs5qiebbm448aef
X-Rspam-User: 
X-Rspamd-Queue-Id: 790CDC0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763124771-47642
X-HE-Meta: U2FsdGVkX1/2mTxgrtHp8vB3dQWoPTKQVKlNLaxXK5YAE0I6j5Mh0xFFiEolOh4YscfbOE8PVz75MxqQcp/xz4VQfnvwGrKhOSylCsYSD5bCZkSl+1yGahlunJLjZjpE0+BFwTqkwYUdtP0qlZeDVSxRlyVTDnWGJeuVhAfKnlvr1wIc6wbDhXqLLdgbybPDKTjamEy+li4Y/2Q/iCAcgMgVKI0qrWTKHj3Svh4L68/dalg5uVuZJHQ9D0QzBE1ksEKKIa6FsBJ339r07cQOhWGjl51Sb0OH6zJfB4SO8XVj6ml2RhKZzDYq88HgM4vlVl+WXr1pmtSVSp6hTUhMB+becXjTC4NFmEjsZB7YxLQqH5qdoAolh67ShTziBkWqGdphnsBC+YqlXUCAulh19/6xEt29/ne9/qmPUwdxpHzBzQF9+Nio5d7mZXKhY/JKQ1tWXCBBYx06Luo++z8tqyjaztEJXaIBPwn60oV0wg22qHwapvwviwKcqh493wgsbpAOaeqqed004Ih/DJpC0Hdh77boZOQDsTI7Dro4bda1JQD7uO8LI6njOpc4lalMyGol0hRw8ZWXUkjdt8yMZNEmvE0wk+MMCYd7JDlt1tbNVRld7jq5nZoyXHeWu5S23ZdKo5B38awVQ1j+swpd1Fig0cmCP5FTaixwsRDdnYwr6DRpuUdxlHZtPOb7tDdwaG1+e+0e6nGXQcauIAxMCV1BulpWSzHbi/CMNfrmIWs03Nu3lxcLiibaCqxTbL+rNOf7Jwv0EPBCK0dzEdfWZm4Kd4jtQWlPWTqIFWFnbwdhcVJHc46oniBqa0MxlymoZZQ0H6aWInMvJKLqhrfdUxPmtkA4qQLrhe+oSQV8kNhOghzGhldXvfk2sPwCLoZ8X172aEJ3h88v7XtzHExZ3jbcoDdpzzwsr+FCENK4vudJfbxjJkf6cUYq1Mc/LiTg9HtCPVfP27Ec3jXFdaJ
 LxvHl2ew
 9aFmCoO9SM3aqfIYhK1ZsK5drY91DPYPnBKag2EHXcU5HbacbMXUWyVWeTW6aHdwVZDaPLjYrNWSpzC3DcrlbTAAryom4wNJJXM3pSS0EiW7wHvlK9pdeA4nYLir4NdaqRHabrp5J9ufuHkOqbcRKMT2q2aptguAhAx1hSlNBVMXmpYqHKYpXHD81/MOTE87TzJexdWd4ZRhLMjE46YxWWaI9csNzsY9cOwh0nZqiGoxZ+kxSdA+YpxgwnseKCZuBNPx9WeFITAsHEQ3X2/31FxgwBRSTAHTkx8Z/ITG7SODIuExhfQKpyOmJ7Ac86Z5SKUPOODef+D9/zOxY701BRYLhd/07uF/XyUEI5pJ3HnLd82u5ppy8inI4hnT3a2u4mPNpAU9+c8eTX78VdqnO5y5pSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yeJqfqlYgNstOKbS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2025 at 12:49:58PM +0000, Jonathan Cameron wrote:
> On Sat, 8 Nov 2025 20:02:52 +0000
> Conor Dooley <conor@kernel.org> wrote:
>=20
> > Arnd,
> >=20
> > On Fri, Oct 31, 2025 at 11:17:03AM +0000, Jonathan Cameron wrote:
> > > Support system level interfaces for cache maintenance as found on some
> > > ARM64 systems. It is expected that systems using other CPU architectu=
res
> > > (such as RiscV) that support CXL memory and allow for native OS flows
> > > will also use this. This is needed for correct functionality during
> > > various forms of memory hotplug (e.g. CXL). Typical hardware has MMIO
> > > interface found via ACPI DSDT. A system will often contain multiple
> > > hardware instances.
> > >=20
> > > Includes parameter changes to cpu_cache_invalidate_memregion() but no
> > > functional changes for architectures that already support this call.
> > >=20
> > > How to merge?
> > > - Current suggestion would be via Conor's drivers/cache tree which ro=
utes
> > >   through the SoC tree. =20
> >=20
> > I was gonna put this in linux-next, but I'm not really sure that Arnd
> > was satisfied with the discussion on the previous version about
> > suitability of the directory: https://lore.kernel.org/all/2025102811434=
8.000006ed@huawei.com/
> >=20
> > Arnd, did that response satisfy you, or nah?
>=20
> Seems Arnd is busy.  Conor, if you are happy doing so, maybe push it to a=
 tree
> linux-next picks up, but hold off on the pull request until Arnd has had =
a chance
> to reply?

Yeah, I did step one of that last night and will put it in linux-next
=66rom Monday. Ultimately the PR goes to Arnd, so he can judge it there
anyway.

--yeJqfqlYgNstOKbS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaRcmGgAKCRB4tDGHoIJi
0onVAQD2iKKx0IizfAkg+H6zlKCEwvYhA65Pv6UxxL4osqTj/wD/fpvXj1YHfiHx
eyDCpQIW29m6pDBP18HBv4dusvusNww=
=yFYx
-----END PGP SIGNATURE-----

--yeJqfqlYgNstOKbS--

