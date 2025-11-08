Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D0B0CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 20:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772668E000A; Sat,  8 Nov 2025 15:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74A528E0003; Sat,  8 Nov 2025 15:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6874F8E000A; Sat,  8 Nov 2025 15:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D63A8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 15:03:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4EB2BB89C
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 20:03:03 +0000 (UTC)
X-FDA: 84088513446.11.4D237BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2265040008
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 20:03:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNKbxfnK;
	spf=pass (imf17.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762632182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1mUJqgslv16M+tfXM8XyUEotZBdEAoMyYYZaLsYGsc=;
	b=LahDGgL1VaPqiaRAZGOLc9vAGN18WMTVyDQuj8EavDKLvoG7b4pMpGkfedw955Dpt0xATQ
	0cxTZ2U+LzQCWZ8clEYq/SysjxzYNDwotxObZIMg0r3QL/3UXnAvqCXmyn9Zi4X8sU6thZ
	Lg4HJuyAcmu4wGm2/HiOPyjyWVqKfRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762632182; a=rsa-sha256;
	cv=none;
	b=Gjs90vnILLR+D0RA2rAEa+VLISusDRSu3O5SIXn538+Nt0tlGc4ePoiyRZCPfyCmcIDNvj
	BB8ZrqcXjpRXxJto04g1bmLY4Uc1hnjE2Uns21uYg9D8mCbqP3rDv2BNPoiZ57Dsd+mYEE
	mjzSm+gOsOaoWersvl5YfIVQCZfV6L8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lNKbxfnK;
	spf=pass (imf17.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F52543C09;
	Sat,  8 Nov 2025 20:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DD7C19422;
	Sat,  8 Nov 2025 20:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762632180;
	bh=mZx3reTRacDiFfpeRs79kIi23F+uPMRdn0mb7yCb4lA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lNKbxfnKqppFyjDbgVviqAKjzuqyrl142Vll5JtXbXhMZx9ScsfOQGWSjhVrVnTF/
	 W46Amq2iHTbMWiCV73eSF5dNnu4nOzVILXSQ0LwZNmPAfs5De8lf7RP8n0+ocYLUNm
	 Y0VB9/W4SBQYKN1XLrr7dsoUZ4XsZynyKqAhxqqge6RicKHf/c+V+JYIipWSV0NVV8
	 Lheh82/DHzO8neWxDIm+NArCVP+u2Y2PHaLtEcwgjDMqVCKMgomUWZB9H7QUMJRnik
	 NCFaIIMPr9Rrq/TqyVfDXSRrfIjwbI19FqZ5vVSIzcx/P5X6qOHcwJMWBACW0al3Fw
	 9iOlOfua0KiDQ==
Date: Sat, 8 Nov 2025 20:02:52 +0000
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, arnd@arndb.de
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>, Drew Fustini <fustini@kernel.org>,
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
Message-ID: <20251108-spearmint-contend-aa3dd8a0220e@spud>
References: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BnXojPaReIke2Qi9"
Content-Disposition: inline
In-Reply-To: <20251031111709.1783347-1-Jonathan.Cameron@huawei.com>
X-Stat-Signature: q3q9gc9qw9usckocqk31zxtr4wtejbmi
X-Rspam-User: 
X-Rspamd-Queue-Id: 2265040008
X-Rspamd-Server: rspam01
X-HE-Tag: 1762632181-150597
X-HE-Meta: U2FsdGVkX1/wy4JqVCBf9dBOnrhRNkFv1GqOugxxA2O9X0Cv8KIDKO+74q19vmu5zzd2tfMsqEsCQtWKNtLQNHP1YJ1bYZuwKzqnCrnsZLK/NPCpYw+DXnMaVB95UStHB1ex3CkE72V+YlVAGqOxtOZk0B+IOzHE5sJivtPvHnVbYYLlOcpBWj+bCz+tqDwkpEEIaKYLnRDyQV+NMt/kkFRuc2jScuTXfAx1f1XVnHueeZuyfCodZFeyY+7WDmB0ekCf9ikAduj4Q/816Wm8UN1DNh6bIr84HkKOMmMHNTLyYoJMOxRZNJieU8Jerd+pRIQdqNuQct2aYD9cC0iDDWYHhRLilV04gVhzB+NF6OtJkP1RuaEzSiDZ/qeXWU+qW93/x+KuiiFe6/unenU7rHElIUaL1H9okBZNVLTqbdl4wAgZ31LYsIM8EFPONfA3xjxYVFCpZxOLIeq9XXqc5YX4nJCbzwULDoZWrVtbQ9hgRh+xLSsoICChwjDxYGqtR8hJZUCVeLmxHMdygb97RA0U/aLR20qJl8ct6iPRY8xlDHRKOrnTNRaTIaLSC93FcKKopGNYV6Z2x+KvojJwlK2LVW3r2t+/ZlHR+rL9b3fcV9578tux9ygooAMjV+Yh5A6xNvZcsNPulUtVxW3TnEzlXewehGuCLWDZVcV8j0Oskg5L4E4jtWYUCDArW4Gn2YkQo/JVfSK1ngr8XUM7XWsLLvbvmUwfR2BoD1sxnbaGrQfrG7KOqemO6Kc1Pey/ONSuqxs7K22H5T1WVrwHAAFVZYdV1kkqalmxTQk+KWngI+aDCx3yc0ED2P4KV3YCLIJwCwCjhVDaz0n2fTh/4Jvdm96gLQykOGwkAFp9wjMQpoC+vr+sODzTuUynrPcl4oByYzy5V8lURwWxff13xdSOf/TeR+ir3+BcyJHHvM5gXstDVEPOAiwJf/AsDOoER+xMuKRVV8uoMIRSeqT
 DCTZ7FGL
 hxEZfh9rM9MBNc3WXHL5f4tMxJNd0jXppm3YNa/UcPeHyda4v2hAwtdaPdGrhEYDvSk2V1zrAqCaJN0im/AtBmVv6NM6kg/+TLxefLXnxYoxFDu6okCr7R1g3rnbV7cJNXarqXpEpZFcTZ7jwsssu1m1CoiDw7Jhi9Hrc+y5Hv5np4wL9PdW290bGFc8bJtTGTaFQo4vr4BtnWu7WcG8It5/+ceBagFheNhwihnNI6q3kuvRwDHnoinzdxfHRntca2ZmEuyduiP4ZMFGdnJmTto+tQPW1Gnasb4JMKeEudMZywtxmdVikLel6iIcvI7K67IpKKHSIvzxZtDn6anm77PZgl+4fqfNzvORE849fVJ7Tx5T11TyUNdTiXNWsh0JDIpH0DFZRuadRs2SHab/id6KY89/9/y+EicsEjFUbgnJeZplXq4cJNq8QiCDapcLRkwXZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--BnXojPaReIke2Qi9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Arnd,

On Fri, Oct 31, 2025 at 11:17:03AM +0000, Jonathan Cameron wrote:
> Support system level interfaces for cache maintenance as found on some
> ARM64 systems. It is expected that systems using other CPU architectures
> (such as RiscV) that support CXL memory and allow for native OS flows
> will also use this. This is needed for correct functionality during
> various forms of memory hotplug (e.g. CXL). Typical hardware has MMIO
> interface found via ACPI DSDT. A system will often contain multiple
> hardware instances.
>=20
> Includes parameter changes to cpu_cache_invalidate_memregion() but no
> functional changes for architectures that already support this call.
>=20
> How to merge?
> - Current suggestion would be via Conor's drivers/cache tree which routes
>   through the SoC tree.

I was gonna put this in linux-next, but I'm not really sure that Arnd
was satisfied with the discussion on the previous version about
suitability of the directory: https://lore.kernel.org/all/20251028114348.00=
0006ed@huawei.com/

Arnd, did that response satisfy you, or nah?

Cheers,
Conor.

>   *  Andrew Morton has expressed he is fine with the MM related changes
>      going via another appropriate tree.
>   *  CXL maintainers expressed that they don't consider it appropriate
>      to go through theit tree.
>   *  The tiny touching of Arm specific code has an ack from Catalin.

--BnXojPaReIke2Qi9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaQ+h7AAKCRB4tDGHoIJi
0mbmAPoDNoN5c++N+FdbOde62VPsuE/nQLuJqXMbpVYRgssj5gD9HgGSIr/5NCGC
GU4C//DABkFlJ0fo45ADpizmnDu8JQ8=
=3UFm
-----END PGP SIGNATURE-----

--BnXojPaReIke2Qi9--

