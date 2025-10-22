Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4EB3CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 20:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143F08E0010; Wed, 22 Oct 2025 16:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F52F8E0002; Wed, 22 Oct 2025 16:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0318E8E0010; Wed, 22 Oct 2025 16:47:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E60908E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:47:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FEC616096D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:47:30 +0000 (UTC)
X-FDA: 84026935860.11.346F242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBFAE80002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 20:47:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMDWLrfV;
	spf=pass (imf02.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761166049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amyp0bQQLpeK8dKZTAb4WHpNFpX9yDj0u1UHnTXihyk=;
	b=8RNW44xF7Upibpl6Gs9eRnXrjkxMsNwKF3V9Jj8LDrSZY2YSH1FBi/jqBrZHrHGBBrXvtF
	gOGyCbF4V8zznXovvV+lLyJ4j2ejUTD4Kf+N883rrjsauTuo5rOT8eOTdmXDnPx6Mc9bB7
	zleiXs0EAi9r1vrHTBUA2eWz0jEZf2w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eMDWLrfV;
	spf=pass (imf02.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761166049; a=rsa-sha256;
	cv=none;
	b=PDdEFofNwdEBJfGLf/AFPxrj/K2bMrDveqMdrjpmU7BrEm4imlcJhid6K79fg23FVZbKIN
	xef87WXgyLE3kR1lX6ktx4eelaRMCfATuiaG1tkRke9ECehrwB09rBw5bUy6W9C9N80YTT
	J8StloD+JY7klUa9uPgXQpeeynBo184=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D513A4533F;
	Wed, 22 Oct 2025 20:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F71BC4CEE7;
	Wed, 22 Oct 2025 20:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761166047;
	bh=e4wpAeuwnWxwPsv6xR22bTAFdrGhHjpoATj1khsZ/3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eMDWLrfV+vZznUoPf7CPswB3dBThpbX2cO+2bWvkQ50o2TCrvoCdE1Cd8xXrUFRoi
	 4RQOPMKhr+0tnSOK+DiKcMtj1oDkCTxPA4mHmnI44BotWVAjb9ldTnLMyTQjyS1Glb
	 ijl24xdpzSdzrCZEKhn++IHDQPpZbUdTkCvlJsrAxJb/YRqToadM7K56X3TBjl4HEM
	 Kyj7DofAye5roHM4RI4hcbcHBS9HAWzaMufkLYbmgqUo5c4mw2HV49+ecHPYhV766I
	 BEuFIsEhcM7FbKPeKnO/YdST5KXQbtfPvLsfWmyESS1GnxaOKoG42xaOoXjHPKwp4J
	 2Yalv6aXeJwRQ==
Date: Wed, 22 Oct 2025 21:47:21 +0100
From: Conor Dooley <conor@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>, james.morse@arm.com,
	Will Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	linuxarm@huawei.com, Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v4 0/6] Cache coherency management subsystem
Message-ID: <20251022-harsh-juggling-2d4778b0649e@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
 <20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S6HWZzkHmuKfgcDz"
Content-Disposition: inline
In-Reply-To: <20251022122241.d2aa0d7864f67112aa7691bf@linux-foundation.org>
X-Rspamd-Queue-Id: DBFAE80002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ozapq69rxb5u79ydnfguxmmxjxwr8qdm
X-HE-Tag: 1761166048-211490
X-HE-Meta: U2FsdGVkX19xIMVMKFcayrgEdGAElIHXKnG55MP70Vl40tkx3jX1vmRrHe+sPpSWDCVOd/oW/hfVICwzZB1Oe7r2JaaYLT7GIsWSvY1kVCK8gydaly5YN5vKQQTj0056GFdxfo0t6cX7FCtuNMDNMcVj18fY9t8s/QuZSJ9kz2oNy+OyjZLRxTrEdiw+ih5OVoYIdrnwK2y3CQYMINInbjfv8Dp+YRrZLiykQYY/qgcmOpErQDFf6UhGLxOOKMp6v0s5tcFxwL1W9El85Vk/nrwRFUFx2DckRaaEkpAIAzO9nhPXIOpQYVI/Z0L/bFLnxibs5FTO4VP76FXL2ewb8PnUVKK9sTd3VcJbWokSWyvWcJFZPttvsuYKwlChLuzUCuXP5kRwGyb99XDEbODM3DG27+rTmxPKVA79HGa55Cp6Fx0EUFuui2gYHyQqC/j9bF18d0v+hpJx3QpEWQbnXA8+vSSigOxFWfjz9atdMetUJy20iPhAonykhPuyzkbzED7QgSKcoLkgCPBvR8GAGzybMSbg7emO37wyJ3G5QR/DvrsJBSM5of5b3Yr4BWXXppdBKbdErPTcADRE+dc9KVTCRaqlm+cF+0SmRrDCHbbPauGAA+i02p6vedphsKxQWnB72RH0QMfCUYkbT5Jr3c6Fg8Y7GRkRf5F2h25BLQrJjozQVITxdnezMecYDgMFi0P6n0bYc1rWFB7MAaX6i2hoo/ugesL15hnBe7LfK2/T5jD0AHzG0K9+T1mptT3BdgKMva8PDW6QJdmWhw4NcWasQIMjo8C5RgMCa9DGcBFEbf7ThfNQXbb9x2QYY41SwlII+a7Eu7N7g4D3XcWv0N46S96LmrTo4UZeYJCwP09Z4zk7RZkqd2Rlmon5L5yZ81vYVsOnfqyRP6mlG1rrlVEvGKQKWfLATJpUkRSnTilOcB2zKJqwOmDwUv0vF5joGD25X+VKP6JKKap/Bqz
 NluTBfBy
 8rpj+JQjRCZI4qRsF0P6sFmqYu+kcfnCt37lDpb8Dm/cRxZ0AZNJbyLqeMDrCL/soARjbyER+u66q6pAYqQa9TXF9h3ZF4B9nscOjFlmAXWctw/19cSaMZOQwDWLtXbwmry0KlZK71XAbMSJ8qO8peX+9QUh92EAkYDvPh5YA0485l2JItWcXCInmB5D3Z+OBlj5tC6v1adrEdeIeKCvEoWE+uL3CPavBhIFQ5TvuEF4w/gPeJ2ny/6jnWHS6rQ4jfZwdeE8cc94svKNfetjDLSqrfPt4fbbYtum2cB8L9KA4RMQEnHBDCjSaiA8btMdTxrxW3Q6bHkn8vFy/STwefb254Ut0iXPe+KEigpva7W8ueLz4WVScXjfvJRejg87h5GCU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--S6HWZzkHmuKfgcDz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 12:22:41PM -0700, Andrew Morton wrote:
> On Wed, 22 Oct 2025 12:33:43 +0100 Jonathan Cameron <Jonathan.Cameron@hua=
wei.com> wrote:
>=20
> > Support system level interfaces for cache maintenance as found on some
> > ARM64 systems. This is needed for correct functionality during various
> > forms of memory hotplug (e.g. CXL). Typical hardware has MMIO interface
> > found via ACPI DSDT.
> >=20
> > Includes parameter changes to cpu_cache_invalidate_memregion() but no
> > functional changes for architectures that already support this call.
>=20
> I see additions to lib/ so presumably there is an expectation that
> other architectures might use this.
>=20
> Please expand on this.  Any particular architectures in mind?  Any
> words of wisdom which maintainers of those architectures might benefit
> from?

It seems fairly probable that we're gonna end up with riscv systems
where drivers are being used for both this and the existing non-standard
cache ops stuff.

> > How to merge?  When this is ready to proceed (so subject to review
> > feedback on this version), I'm not sure what the best route into the
> > kernel is. Conor could take the lot via his tree for drivers/cache but
> > the generic changes perhaps suggest it might be better if Andrew
> > handles this?  Any merge conflicts in drivers/cache will be trivial
> > build file stuff. Or maybe even take it throug one of the affected
> > trees such as CXL.
>=20
> Let's not split the series up.  Either CXL or COnor's tree is fine my
> me.

CXL is fine by me, greater volume there probably by orders of magnitude.

--S6HWZzkHmuKfgcDz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPlC2QAKCRB4tDGHoIJi
0tdvAQDJHGwCvxYrXGJs6nPPk7w5pV6+UajlzpKhldIVtCgm2QD/XrQK+qDLbAJA
ymsJdZLdZoCSVVQ542yRJc4RjGzDnA8=
=4U3B
-----END PGP SIGNATURE-----

--S6HWZzkHmuKfgcDz--

