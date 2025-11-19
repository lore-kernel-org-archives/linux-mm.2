Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0ABACF58C8
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 18:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B3F6B0030; Wed, 19 Nov 2025 13:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B576B00C5; Wed, 19 Nov 2025 13:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A5C6B00C8; Wed, 19 Nov 2025 13:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE9F6B0030
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:44:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64FDC140652
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:44:53 +0000 (UTC)
X-FDA: 84128233266.05.1CCAA02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BE13C4000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:44:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqvxYHbN;
	spf=pass (imf17.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763577891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ea1ayXHXALsT/3s7AXIiWnLbMSgCqeVe2mKRrK06CQ0=;
	b=xZoetgE/LgP23n0gPKSMM5GSj+AYVRZy+3NqeL2KCoRCZbN3kKuQ8/8sWL0NwzFld+jruR
	Yz/LzLmVvca2x+UUTYkxAUzYzyP2GJFuiVfg4uA7sIDtoHqSXxYLEuDiT7NFBksrcHHQ9W
	CXyQyuCjS7Ac8uESK6N6oJLscz/jDq0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763577891; a=rsa-sha256;
	cv=none;
	b=eg6S+kAH1vhf5js0B/slRv9lm/n4R8vLMfcs8Ueq2LzX+ATbzek5SQ8UqnqscbFWg5zNKu
	kFxP0JExiRv2i1S4YO9oi5Vzf1B8WLRg3ds4ICwepA/hI5VW5JUHVXhl5Zir3RQE4vwMMG
	KdmDvt2VTSYHqOXfw+1cWnIdVscx7BQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mqvxYHbN;
	spf=pass (imf17.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E87C60017;
	Wed, 19 Nov 2025 18:44:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81AF1C4CEF5;
	Wed, 19 Nov 2025 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763577890;
	bh=7AAXhdIN9XNuNFY637AtV3mAm4gPrrFNTZMcjXFYErg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mqvxYHbNym+xIqsVHSgdrQgyJOtvsXCayhPPiB6N/Xvv3p98UprOivIkAKOfo7tum
	 BjgCE9oANwa6vv9VBMkqKLdltF1qmWLo9ANzFpvr659h2LaYez6F3jA9FJz70tdeQJ
	 XBH/PBDaWttnGc0Z5GDo84/lH1A7gxjmFM6zL/jN3j/YzHtRzfSZWRomHTb7EvThz0
	 oyztU6NI7SNHvsvSFM1hoYk9u8MMmDnEjbIYoHsw3A6qAgfmxpMXoa/ELrr4/OO+CP
	 SOIt1uLy5+gHJzMJe41RZolswZO8i4mvTuFvAPolcdrlFh8/EX8RKHNQloElWsG/2L
	 gmQ3LNTVyCgLg==
Date: Wed, 19 Nov 2025 18:44:43 +0000
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
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
Message-ID: <20251119-charging-gallon-bea196c3a547@spud>
References: <20251117104800.2041329-1-Jonathan.Cameron@huawei.com>
 <20251117104800.2041329-4-Jonathan.Cameron@huawei.com>
 <3bf1793a-2ffd-4017-b4bf-dc63f3a2a7c8@infradead.org>
 <20251117-definite-uncounted-7cc07a377a71@spud>
 <20251118093041.00000c9e@huawei.com>
 <2241d985-0e35-41e5-93b1-1e8d4e7a84bf@infradead.org>
 <20251119094255.00000020@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8uMCJ8lN+XFmaZ3P"
Content-Disposition: inline
In-Reply-To: <20251119094255.00000020@huawei.com>
X-Stat-Signature: iwgcu8fcrpjbhfix9tx6b91w46ccxdrw
X-Rspam-User: 
X-Rspamd-Queue-Id: BE13C4000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763577891-818395
X-HE-Meta: U2FsdGVkX19ij5PaFrv7h94vrevFIZHy2nvxq3UaykIKQUIPPflHy7s2SXsIV0xGprXmbWbtSQPsoMB/e8skxQUWcRHOATTl3d0RqXB9wECtBLyEMHiP/qD0xOLA8A+xYdvesFPpsX0ZBM1pGF+0ol6EZ40DDweG0Iw6LgsBWpf02Bn1Qhq9Ih1LguqpbT8BjDrJMhobti2puQZ3wdXzClAb0w0/rMTfQGX9cd5bsUIBWQIyxsprvjQqMHOjdsoKIRVgf9sZ1QHCelTH9TEDofw+RgK6r9z0GL7bfr7F6Bf5oJQXgbNL+p7fFpprxJDRkkcPQOZe1TBWq8YTgXNJz6sfGk6bJJCmB+f3dmxZuv4fNUY7fwFzZyC7+3CXwkhfucl8sCk2w0F7PAYgtYqW2UODC36ay9R/eLAWYTKs1Zpuj85Nv5sHWlSU2L49ZUdlXCE2E524p0wm+GEdd2/SfvujCUyzUckP4YY/D05qbN+EOvrJEFqYHWWzKg0xvB3cTMM0Gz+4LKxvmD5FZSvAyvYVNd/mRoV783IRnbUHi/9paYdIuSvjtasYC4//7hmkIZbqUVltWDo8SPjeGoT/KXRQqB8EINGi6sW79lzIv9vSHUqLomvKFmSisrHZHqS1uegRoJPLTshoXjDOmRyFSyG3+grYOpIXl5AS5HUPlH3Cfj7fqyhj1Ym6ISRM4mHAF+eo6L9mL15i8tlFfFEPYXUL1Fq6MNICpAbwdfr5xin8a/+w2ZlopyQCtk1ROspsTMBaqH/fdwgi3olPtEdcLr1ce8Un57Ba6BZR9bI7FUY7zZjlr5QoePT/9nmYWYipyjUdV0LOp/VaOCm7FayYx5eG5K7uCxUU/FcWKmnBYzxN76MDAEe0RnnGxTNCGbjCmJ1z+A0wlnLR2ObIuxpBJbcDfdSon65nasoxkTXTXRaNWDaOsTd1Zq0baHhYMQAeesu7xHzn20PhM14OuqV
 UqWLCE57
 vmL9Sttpa9bSrzXtDvckPLTURMMm2qrNwqsqsG++dYaikGUnCuFRfcYRIfeCC9cMEQAzGmJfN6O2riRJJbJ7LrLcZqI96lItDlGj1zwXk7f3aBwYQBvbJGz/+ZjWgmdsjBRH1mqonsg3jBjppr+E17rjoTIbQ4Zy/6rjQLFM0GbhwAVqHBf1IH5t8GysI1ytMwzx75W0qwqAMQkzvDEsr+v23C3X1UjRP7gBYOc3kMzV+sihEaFRkfyh4CQfYup8/qvjgaxrxmFOKGgSDJMREQB/wjhscdFoalHtI+6T/i8gDQI2xJqZzpcKpgN/BHxddmcF1u4UvZgkfAh5uVUGXb7u1AZ32QkqNO/Gy0cx688t0prDN48jcE10mR5SLXTczXipcmZzdGxSMHifp+h8BIQebvDTEb5qnSLG0gR+GQ5fy6C0oAmP2bPPzAT4J3V/aYXDkMvKQKtJDHYM7dIKRjVNeWNPh9GOwRf69n5upA1j3nb0uYvnN/8d4zA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--8uMCJ8lN+XFmaZ3P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 09:42:55AM +0000, Jonathan Cameron wrote:
> On Tue, 18 Nov 2025 17:18:31 -0800
> Randy Dunlap <rdunlap@infradead.org> wrote:
>=20
> > On 11/18/25 1:30 AM, Jonathan Cameron wrote:
> > > On Tue, 18 Nov 2025 00:13:07 +0000
> > > Conor Dooley <conor@kernel.org> wrote:
> > >  =20
> > >> On Mon, Nov 17, 2025 at 10:51:11AM -0800, Randy Dunlap wrote: =20
> > >>> Hi,
> > >>>
> > >>> On 11/17/25 2:47 AM, Jonathan Cameron wrote:   =20
> > >>>> diff --git a/lib/Kconfig b/lib/Kconfig
> > >>>> index e629449dd2a3..e11136d188ae 100644
> > >>>> --- a/lib/Kconfig
> > >>>> +++ b/lib/Kconfig
> > >>>> @@ -542,6 +542,10 @@ config MEMREGION
> > >>>>  config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >>>>  	bool
> > >>>> =20
> > >>>> +config GENERIC_CPU_CACHE_MAINTENANCE
> > >>>> +	bool
> > >>>> +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >>>> +
> > >>>>  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> > >>>>  	bool   =20
> > >>>
> > >>> Architectures and/or platforms select ARCH_HAS_*.
> > >>>
> > >>> With this change above, it becomes the only entry in
> > >>> lib/Kconfig that does "select ARCH_HAS_anytning".
> > >>>
> > >>> so I think this is wrong, back*wards.   =20
> > >>
> > >> Maybe it is backwards, but I feel like this way is more logical. ARM=
64
> > >> has memregion invalidation only because this generic approach is
> > >> enabled, so the arch selects what it needs to get the support. =20
> > >=20
> > > Exactly this. Catalin requested this form in response to an earlier
> > > version where arm64 Kconfig just had both selects for pretty much that
> > > reason. This is expected to be used on a subset of architectures.
> > > It is similar to things like GENERIC_ARCH_NUMA in this respect (thoug=
h the
> > > arch_numa_init() etc in there are called only from other arch code
> > > so no ARCH_HAS_ symbols are associated with them).
> > >  =20
> > >> Alternatively, something like =20
> > >=20
> > > I'm fine with this solution if Randy prefers it. =20
> >=20
> > I do much prefer this alternative.
> >=20
> > > Thanks for your help with this. =20
> >=20
> > Thanks for listening.
>=20
> Conor,
>=20
> Given it is your proposed solution, I'm guessing you'll either spin a pat=
ch
> on top or squash it into original.  If you spin a patch for this.
>=20
> Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>

New patch I think, since you say Catalin specifically asked for the
current setup.

>=20
> Thanks again!
>=20
> Jonathan
>=20
> >=20
> >=20
> > >> | diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > >> | index 5f7f63d24931..75b2507f7eb2 100644
> > >> | --- a/arch/arm64/Kconfig
> > >> | +++ b/arch/arm64/Kconfig
> > >> | @@ -21,6 +21,7 @@ config ARM64
> > >> |  	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
> > >> |  	select ARCH_HAS_CACHE_LINE_SIZE
> > >> |  	select ARCH_HAS_CC_PLATFORM
> > >> | +	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >> |  	select ARCH_HAS_CURRENT_STACK_POINTER
> > >> |  	select ARCH_HAS_DEBUG_VIRTUAL
> > >> |  	select ARCH_HAS_DEBUG_VM_PGTABLE
> > >> | @@ -146,7 +147,6 @@ config ARM64
> > >> |  	select GENERIC_ARCH_TOPOLOGY
> > >> |  	select GENERIC_CLOCKEVENTS_BROADCAST
> > >> |  	select GENERIC_CPU_AUTOPROBE
> > >> | -	select GENERIC_CPU_CACHE_MAINTENANCE
> > >> |  	select GENERIC_CPU_DEVICES
> > >> |  	select GENERIC_CPU_VULNERABILITIES
> > >> |  	select GENERIC_EARLY_IOREMAP
> > >> | diff --git a/lib/Kconfig b/lib/Kconfig
> > >> | index 09aec4a1e13f..ac223e627bc5 100644
> > >> | --- a/lib/Kconfig
> > >> | +++ b/lib/Kconfig
> > >> | @@ -544,8 +544,9 @@ config ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >> |  	bool
> > >> | =20
> > >> |  config GENERIC_CPU_CACHE_MAINTENANCE
> > >> | -	bool
> > >> | -	select ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >> | +	def_bool y
> > >> | +	depends on ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
> > >> | +	depends on ARM64
> > >> | =20
> > >> |  config ARCH_HAS_MEMREMAP_COMPAT_ALIGN
> > >> |  	bool
> > >> implies (to me at least) that arm64 has memregion invalidation as an
> > >> architectural feature and that the GENERIC_CPU_CACHE_MAINTENANCE opt=
ion
> > >> is a just common cross-arch code, like generic entry etc, rather than
> > >> being the option gating the drivers that provide the feature in the
> > >> first place.
> > >>
> > >> I didn't really care which way it went, and was gonna post something=
 to
> > >> squash and avoid another revision, but I found the resultant Kconfig
> > >> setup to be make less sense to me than what came before. If the swit=
ched
> > >> around version is less likely to be problematic etc, then sure, but I
> > >> amn't convinced by switching it at a first glance. =20
> >=20
> >=20
>=20

--8uMCJ8lN+XFmaZ3P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaR4QGwAKCRB4tDGHoIJi
0jzVAP485em5r734PUQARl/Redcopl3WHKhio24hv69dhS+NiwEA4Tf9EI8upkHE
ZhRrHxrcKvSCFgpopKmIEp+fHS2OBwU=
=DQ0+
-----END PGP SIGNATURE-----

--8uMCJ8lN+XFmaZ3P--

