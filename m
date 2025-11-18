Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260C4CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 00:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FD18E0014; Mon, 17 Nov 2025 19:13:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800118E0002; Mon, 17 Nov 2025 19:13:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73DDC8E0014; Mon, 17 Nov 2025 19:13:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 643EA8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:13:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14EEAC02D8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:13:20 +0000 (UTC)
X-FDA: 84121803360.19.F2C3C62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 35F20C000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:13:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNjrX6GQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763424798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7w+/HNozL8sgeqNf9ymrdYieoYBwVVVObtJdPZdmXlw=;
	b=gz5Iz1cxrhjshdp4aau+wanZOdEC3oFxE404cBLoi9rC6ZKaKAi/dmm6SX8GRv8ABFuU/H
	36hdYGSOGUTaw55pUdMLKaUd6hkq85JnLkx/N2JyCJbEBnffq/9/l8gWjymn7elbsxB0QK
	B/HCX1+9WATUINKa58RtmDVYAuObYu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763424798; a=rsa-sha256;
	cv=none;
	b=5cENnSF++D8jN6HgZ5KvqMex/zenU4lbQ2Cl0qefx6GuNbd7xO6Bn6GoN8W4uEk6ozzaVI
	kvRlXCV3kJz55zlDMmbAcS2+kRee8MTVeX1m/HasJqVYI3VfvcaQ56MvpBbruBjc6fqH0A
	6+P5QUZL4YOn6hUQdHQKHAWuFb1fR+w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNjrX6GQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA08741972;
	Tue, 18 Nov 2025 00:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7D3C19423;
	Tue, 18 Nov 2025 00:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763424796;
	bh=FA/B9Ov2AMGG74Hew1VbR3PJqHVMWv8DmTnLRuNyv0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NNjrX6GQ+2j8/hvb2kxvzwqGZySojwDESUweIZ6sgye6A2Zs8p2VLCSnIY9CWNEge
	 l6jE1bXGcJlT6JVMl+clC6zD8DQcisfaVPJoALcYuLz//pHVm1DfLtH1js7bZeoH4K
	 wpqR8wUS/9tKTnGzCLxGS/6NgI3dOU86jdcDrGFJ1DVnaPFPXgAI9vaEnGOUuOLtOu
	 udFawlouxXWSbfDO4zfuGq9kecgERtnjuIuMMyOQDbKNSZC5mHBPOVGVCFNDbOlmyD
	 hFXfuHFNBaZIaoM2EWytAijxyehm7iVJP7mXxnnbZEg3uvj5zENTdALE6Wond1oGjZ
	 n7K3V+abTjNYw==
Date: Tue, 18 Nov 2025 00:13:07 +0000
From: Conor Dooley <conor@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>,
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
Subject: Re: [PATCH v6 3/7] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <20251117-definite-uncounted-7cc07a377a71@spud>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
 <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
 <3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BAm6i4nhj7rGKbyg"
Content-Disposition: inline
In-Reply-To: <3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
X-Stat-Signature: beb7g6pqc913n6dj6j8unzamku8qac1f
X-Rspam-User: 
X-Rspamd-Queue-Id: 35F20C000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763424797-351418
X-HE-Meta: U2FsdGVkX196j22ZKosspCfgpJKGlrCfgq0+dYR2KiiayBQBm7SFsLwXeYDn1XX+qXXA74WpbrsCxFBP/NFPgxZpQR7f8O/zqFV+W8Rs4/czv33Gx7k31GIICMUH4uyfFKq8QYlo5UK3gOszHcahNzLoK8ELAYVIL4uvqjP2Ep3oqcAqhktL8HNKY4CW2IV4MBxhVd+fTyRvcOoHcircZpkF61iGcChFGnwaxzo+SLxPPFWVpscO2rfCXfFYc0DeLOje6xs7eeIeT36ZVlUvynFyd+6DQbaIO2DDYnSpnIYImoCHDFkzPKReSUkSwmOSSeVauU6LSdFTFBhATCWXNB0+woCrJAU/1SkGSpCqamLWl1j31PFoH7+FTYjmM0M/8MzPd//zczFwD0Yo3L80vZXhfFSDjR/kUgatD75P48Dpemnj6g2ZSsWCLv4oqJ+av1F+FXmqhUXgAm1fAdBCWZh3+YNCwKXifVd8nxKY7gp/9ob66AAxopqFC8pdVdAy9/z6swF4SPoZI/WysOzK/n+lCZB35tNpXbjyG6hEIpQMb2fDQ77N8hGbaWclyFNt3VCKPg7v1+oPiwucM0NQUMmOkvOP4KFJXDluevnfELObJ5I6Gfz1TID5+bvCnf5JjbqkXJsiyNSty2CXYKkkxT7BNZUR94aTUP6TeD/mqebujRJbDINenpiFoC0wlzEwkxo64Wwp0ZG6zArzWOMOnDw/uyEbZhL+kljkIv1GKjcMI8agqnJBbUU8ar1ARtgxulGW7DBz0j1IUSdrVxNp8aOpnd0uONQXUs0y2t3fEhvtibHyMJ8G9RW/OQTguviT3r8ZhubFOSkoq/JGJOmFIKeJQJTzEKsOl03GSKIAQhUTRloK3u8PCi5zEQSDNuunl6F9Yw+BWKn9DVj6rJ4+R22YpYNGVzPwLoKJm1BPG1RsgWFZF4BNWKkDZdEoJ3bI3hBOa4r5BMjtpay3QvB
 AO/KvYve
 cz8lOSgCbTzIoBM0O9InabMcOn6SxD/E41WltfSwd4PEuHyWcIk9C9PlZNXd3kApRr8LwOzxBt+bNsfhcbGgdN3oCycBG7ia4GCXYH+08itA6F6JTy+x881PjOM3FuCG+AD65gU7jbRaUO6nIp7v7r8M0oeBHuURPjg2Q3VLSs3onxkMvorCTgUMQoMVU22RJqS+SpM8tWH4Q2hAVJtrq4I7XscX7uOeNtgcFLt+8NLquj5NTLgQO6G9LFhN4PJW/vqWD0CRulrzdml0CQJR1HXRKRZcMGPkSkb/+L6B5U4GFkg2Zh/d2UFFEdvn3DmtJD3B7GqkAO04WYWqMn4B3v6ceq6vWfLc93CJQ6wLBQfHZQpysA9B7m2EqOyylM/AWo7XgteNB26lt2QsQWvtNtIgc5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--BAm6i4nhj7rGKbyg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote:
> Hi,
>=20
> On 11/17/25 2:47 AM, Jonathan Cameron wrote:
> > diff --git a/lib/Kconfig b/lib/Kconfig
> > index e629449dd2a3..e11136d188ae 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -542,6 +542,10 @@ config MEMREGION
> >  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> >  	bool
> > =20
> > +config GENERIC_CPU_CACHE_MAINTENANCE
> > +	bool
> > +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > +
> >  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> >  	bool
>=20
> Architectures and/or platforms select ARCH_HAS_*.
>=20
> With this change above, it becomes the only entry in
> lib/Kconfig that does "select ARCH_HAS_anytning".
>=20
> so I think this is wrong, back*wards.

Maybe it is backwards, but I feel like this way is more logical. ARM64
has memregion invalidation only because this generic approach is
enabled, so the arch selects what it needs to get the support.
Alternatively, something like
| diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
| index 5f7f63d24931..75b2507f7eb2 100644
| --- a/arch/arm64/Kconfig
| +++ b/arch/arm64/Kconfig
| @@ -21,6 +21,7 @@ config ARM64
|  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
|  	select ARCH_HAS_CACHE_LINE_SIZE
|  	select ARCH_HAS_CC_PLATFORM
| +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
|  	select ARCH_HAS_CURRENT_STACK_POINTER
|  	select ARCH_HAS_DEBUG_VIRTUAL
|  	select ARCH_HAS_DEBUG_VM_PGTABLE
| @@ -146,7 +147,6 @@ config ARM64
|  	select GENERIC_ARCH_TOPOLOGY
|  	select GENERIC_CLOCKEVENTS_BROADCAST
|  	select GENERIC_CPU_AUTOPROBE
| -	select GENERIC_CPU_CACHE_MAINTENANCE
|  	select GENERIC_CPU_DEVICES
|  	select GENERIC_CPU_VULNERABILITIES
|  	select GENERIC_EARLY_IOREMAP
| diff --git a/lib/Kconfig b/lib/Kconfig
| index 09aec4a1e13f..ac223e627bc5 100644
| --- a/lib/Kconfig
| +++ b/lib/Kconfig
| @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
|  	bool
| =20
|  config GENERIC_CPU_CACHE_MAINTENANCE
| -	bool
| -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
| +	def_bool y
| +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
| +	depends on ARM64
| =20
|  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
|  	bool
implies (to me at least) that arm64 has memregion invalidation as an
architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE option
is a just common cross-arch code, like generic entry etc, rather than
being the option gating the drivers that provide the feature in the
first place.

I didn't really care which way it went, and was gonna post something to
squash and avoid another revision, but I found the resultant Kconfig
setup to be make less sense to me than what came before. If the switched
around version is less likely to be problematic etc, then sure, but I
amn't convinced by switching it at a first glance.

--BAm6i4nhj7rGKbyg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaRu6EgAKCRB4tDGHoIJi
0nZFAQDM8N23xRqxSRbXxCvV9U3SK6crnsbKb90b4UmJQ3Sp2AD+KZGuSHNYRHyF
VDJQehUnQg16E9RkkY+PqRspoEYItwc=
=ZlO7
-----END PGP SIGNATURE-----

--BAm6i4nhj7rGKbyg--

