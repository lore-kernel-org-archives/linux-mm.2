Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01BC3F46119
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 13:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C696B0005; Mon, 23 Mar 2026 09:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2160C6B0088; Mon, 23 Mar 2026 09:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE006B0089; Mon, 23 Mar 2026 09:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAA476B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:54:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9616F8C219
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:32 +0000 (UTC)
X-FDA: 84577472784.04.9FB7AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E2E7E80013
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2j0DwAz;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774274071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wgz5UIsacYchyYn/NXziBlVur5a/20XBkzVTOVRSbZI=;
	b=Ypauq3nTGjypB53gEaSEUEyDrVSN8oMMxT6ugjkR1GDAMOutLgAvOQryZDxHYbhv/eYDnk
	dG/FJTYbxjz8TIv7bcfj5D7J0Cg2BgipJjrahC/sEhEzkPo3dYfz+Xy+XA28/xrok3E/7Q
	ioCx2t3FKoHrASileQYs4MpHZhMsg44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774274071; a=rsa-sha256;
	cv=none;
	b=Q8Q6A3rbqDDs0Y2n1nCuGGVSbGCwcqZqJBnOdJ1B3051ZL7zdqmZGRhvZrVsKgB+oyE1fL
	FhV5OQ1nMQeJWfP0ztJVxQVzcP7zQ1OBwVn3ZNy7GfVsjw4yATa1RaEBpKg0n2KvbRq3C6
	nDk8XqUYnWBX9J4OrGTZKr9+joIu9WA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2j0DwAz;
	spf=pass (imf30.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE47B44075;
	Mon, 23 Mar 2026 13:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5646BC2BC9E;
	Mon, 23 Mar 2026 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774274069;
	bh=2/XBTB87GrlUNJZddLpCGE+4XhXu902RPGnPRLytH2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m2j0DwAzlmvBKd4e/6HcTL2rh8800PVIc21bjtqQIikh3rCuEvv73eyHeOmtX4S+F
	 lfpQxfvR0/mQ+1I77YFM7NDAuaibxX/qHgPKB2NKhlgYJkzrO7EHvOCUcDT05WijVo
	 zUWWhC2v8glwgs2zvu4m2dJCDmg0AASkGfpkpNuOCZ3GvyzIFEJcK3D2/fgsdcgl15
	 my2EWqLPtptTIxO+td1+qfdyU9vfXS+dfjZBZa6Ts9Ro53GaqHtezbbuw/zJNUui8y
	 1ml+/hXsulQF09cSECMU3vTl0ML3XAYbEo7BN5hZCC61iDDz5Xm2NewrzMcHDcH3j6
	 gisCLKTDVfAVQ==
Date: Mon, 23 Mar 2026 13:54:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
	a.hindborg@kernel.org, acourbot@nvidia.com,
	akpm@linux-foundation.org, aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net,
	gary@garyguo.net, johannes@sipsolutions.net, justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, llvm@lists.linux.dev, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <4fba0163-547e-4099-8b37-5d8429bda6da@sirena.org.uk>
Mail-Followup-To: Miguel Ojeda <ojeda@kernel.org>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
	a.hindborg@kernel.org, acourbot@nvidia.com,
	akpm@linux-foundation.org, aliceryhl@google.com,
	anton.ivanov@cambridgegreys.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, dakr@kernel.org, david@davidgow.net,
	gary@garyguo.net, johannes@sipsolutions.net, justinstitt@google.com,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, llvm@lists.linux.dev, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260322193830.89324-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="01f7rP5tz95f7re7"
Content-Disposition: inline
In-Reply-To: <20260322193830.89324-1-ojeda@kernel.org>
X-Cookie: Avoid gunfire in the bathroom tonight.
X-Stat-Signature: kzi6cp19nk7d3x35x566wn49faxh3hoq
X-Rspam-User: 
X-Rspamd-Queue-Id: E2E7E80013
X-Rspamd-Server: rspam12
X-HE-Tag: 1774274070-916427
X-HE-Meta: U2FsdGVkX1+zs4yRPwXEw/Rwmx0/fzVL8XsjoWKDvstNnG10s9gQEHZkqRvIjvwTDMbshkY4cZbIz/pH7ae4KdgmxlWXy3IZHPKNIWF68oW2kjiuF+cABEaxi511qo9hCwNzGpft9b9Kkd4eNQ+Dciy8itS/wQSXlW4BbOJX3iihS1tCLjeT5k/C8pkxDxEB+/yqknijH3zUA1k3mZwv1RJHP6HbJZOqVtn6kKVZVVD5vuAPqyzyzMgLRKUnX2X0EcgUzPfxqx9nJJymkf0hey2K7OymKyUoCh1Tpd2dvH0mz+49hHQ726h83FAE3zWOQL3SZTjfF1COWEFIZK5rEGBPT0eoUmJiuyY6XvyO9ac/BvYrULoS+F4sRPeQO7PY3vDOuDEkEXD2KFHRLbTUKlaFJnBtRbpc6eCgFmasRXI78bk9icB3OuapKpJOA2H6fypFnrV4pQ163hMDedTp32ePk9mpoRt4eyuBMWXDk3Xe6k9I/qOrvntTMyMly9DWnPrsyIHlBfq9GJXgGepxbZs5jt2Fs3jyQYG3j1/1avZ/2Di8DBhCNAPAfDOCMrlrDB41vRKstIW4zjVbkdXwev1dVSwUvBPrG5wqvMhTM48iH4JpZ2VXiUQ03Lg61osrYZ7afeWeJSm6Y+NPCpF64woTMxysBI8VjN6kQSNSZZDS7155iA8brrthpumlZ8/FkVWpoSaI2RDNWWWqlqt9a+co0gGc8kUcw4il6UkXx1ffcMX694CjG8ffJ9n+r6PSZuzZPL++4D6CB6Pr5p+yVYCtxz+aqNzVJgBqFAEGMXRFK+WhJfP4IZWwMY3CqZEmlZI5/OtGvp/Gm1SLwGieZW08cLHZoqA4EDDE/uAG/aF6LE647D99JoTewf3ncSLH3ORdqDt0pqyCsi7vc2V3s7aGOiG6F+lCZJ+ra/H10YstQF404LEYBUij9MGerTfg8gNffKo8CvlBI6g7OsO
 gX2C7rzW
 gNl5A+xTaJmPd/2shEraJ89s2y1otSK46n8BXNPfQlXNzss1M+VL8BpnIsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--01f7rP5tz95f7re7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 22, 2026 at 08:38:30PM +0100, Miguel Ojeda wrote:

>   - The docs on `regulator_get()` don't say it may return `NULL`. It
>     originally that case, but commit be1a50d4eba4 ("regulator: Let
>     drivers know when they use the stub API") changed that without
>     changing the docs.

Callers should never treat NULL any differently to any other non-error
pointer, this is not a value intended for inspection by users.

>     The original sentence (which still is there) says that nothing
>     should look at the value, but then it goes onto say that drivers may
>     actually look at the value.

Having specific handling for NULLs is very much not a preferred
interface, and most things shouldn't.  The caller should probably have
it's own !CONFIG_REGULATOR checks rather than using the return value.

--01f7rP5tz95f7re7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnBRgsACgkQJNaLcl1U
h9C71gf9GpM/jjG7XngTH0kbbP53phsB1+ihdqiu8gRSA2NkhE0CDNEtrjeo8HK+
YFX9N3jSxdG8Xb07O5JUW+IXTMGCeLvz1uSBXZdXIabxC9f1LMtKTabWh0ZHf713
HWaiw2tyL04gxzoGRUMOxAdjtJO/AHPk+s6yJ/mQq30LL2Ct3q4SD2EtDeCiBi24
uVumpIb9BMTfIXF2ygQqJYC2bsstGVbR9LCepYNRWzl6pJ+8qpCwRMNb90/Fc54c
L2PQmhNC1Q8X3ghZTF3R48f7nMOug5EndZ2txdR3Z3qvY7xacpJH5R55yoodXcVg
aFFTXPyWGRpSqwmfdF6DFkUEV7QZAQ==
=T4pk
-----END PGP SIGNATURE-----

--01f7rP5tz95f7re7--

