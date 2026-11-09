Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9A3A606A332
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 19:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IYUVVpaQ
Received: by kanga.kvack.org (Postfix)
	id C5A7D6B00EF; Mon,  9 Nov 2026 14:28:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0BAD6B05B0; Mon,  9 Nov 2026 14:28:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20986B05B1; Mon,  9 Nov 2026 14:28:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CD4A6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:28:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8026FA0752
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:28:40 +0000 (UTC)
X-FDA: 85416567600.19.E8C183E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C39E240003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:28:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYUVVpaQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794252518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvK1FBUlQu92e+3qOO46yvXvWJ6xY3Ch9e+qtHZ8ifM=;
	b=cJpGn/J2jHArgz33s4HepAv1imAQwNsIArdytleJqJiLNHBnMHhjd0azcTzhVhfRgDf8rC
	VTPf9gCSC79ZmR8nkPmZTW/1TD07I400qSjgilZxO2PLAz4uqsIyz16mggByq3sMvwF21z
	DyDtXe+7EXET9KVUoZTuswHtGzQ+XtI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IYUVVpaQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794252518;
	b=sAR8kr3rDrxWNVSxiQycfApn2cWWpDo25u+DrYHWMbd8JL2jb7Lkg6DURN5Ofg5jcqkZEG
	Ve3Ccxg61bwmMzssgWIP49TPB4/E68E45OaLK1MlDqvcp+3J/XtV2UwNO6WFQPdVkki5fX
	ur8kWAwKG0G0eNEAf5FNmKcGj5XHnMQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B79260F4A;
	Mon,  9 Nov 2026 19:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A741F008A2;
	Mon,  9 Nov 2026 19:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794252517;
	bh=PvK1FBUlQu92e+3qOO46yvXvWJ6xY3Ch9e+qtHZ8ifM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IYUVVpaQejpurCnmiYSSdzB7QEEI0r4B85C8K76h9yFnNJIPW8dxlBgo8Gf4RbywF
	 912hcLYLrkWoewMKDW5nvpzv1yqTIW7T1NnukrfgH/RGFu6tU7g49C/aBzA1eoOU2+
	 Xco6d23rGLqJTWskOkobA8dwadTfpbw96TxH97fHifLyMitYEsxHmuiVhiazCf2XGq
	 tvK1Tu9Yy3MzftA4rdouKVLkIgY13lIQdoTva7UujOM3xVVABeA1nHBEtYJelTnwZE
	 m2SKA95aBi7aBeiElZpEqK6RW3yOxjRmRh0thPi4BYk2+J0Xe+HNRJeyQXbyck8mT2
	 a6f6ciRegoZLg==
Received: by traversing.sirena.org.uk (Postfix, from userid 1000)
	id 54E2F2FC6B1B; Mon, 09 Nov 2026 19:28:14 +0000 (GMT)
Date: Mon, 9 Nov 2026 19:28:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ard Biesheuvel <ardb+git@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 22/22] mm: Add basic tests for
 kpkeys_hardened_pgtables
Message-ID: <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/fHNA9/ObvvJyqoU"
Content-Disposition: inline
In-Reply-To: <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
X-Cookie: Whoever dies with the most toys wins.
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C39E240003
X-Stat-Signature: 71cqa768bidwdo4kp1c1334zq1bauyna
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794252518-962198
X-HE-Meta: U2FsdGVkX1+dkN0IgF4AEnyzASkjc8HDqukUCDFvWrHw69hTzZeoVwec1/U2F+TI2NhivUCJx7nr7EJ0aFtOSVnX6Uobofa3YlL80snJyo7MAySwU30nhWIkGH8cOk3So4QlPXz89zwvt/FVNKhEXSGKl3WQujmzj4LP24He2cPstIUeIEzX3NeE+iwUKUPCeXm74v7873jZ2r/d5YYODGlPGEjCSZKAiI+etoWFlkQHT77lH8Wpydw31LYbkg0Is/68LRzyBiWZ93BaBnq8lERIJYWIFkCksUBWhbHHscHo+Tg6sYBX969t/TnM5fVu5+scCykUdiodWMxyUSH93/9qFHIcfWRMi+8owoPDnIa5+10x0g+GSs0zeMTTTwQt/bblAt7b7PU4ubn/O2Jlluxq7l6AkESpOdkUnCYxpmba9mpt2n+T2yD/b5JrdLn3DitCR7OAsOStqLunhEmmiv7Tq1k6YoWY9Dxj3znIvr4/R2Iwp+uCA9nroijTa/FUFCwicH/Er7BO6P2dSgOzd2DXGFwys7JcnGjr++A8uQcHq4L+HYOLRGR7kuNViiQF0kDZ7iuDBWxkIySU/Wb/gZPQ2Pa7jqyPOCi5JVjSxikbPvXTMwRrHC89lFK9feJzit/SjuYwkv+YeAngoxup/P72mXMVmV3nvmEhaesEZfp1rHpsJUHGcKaRK/4ABsZUVWxtjZnXMCXajiuE5Iq/P1BupdrePLOpNccQOFzYx9Rw79HYOiFsT3MvF4VF0JfBEytrpXQy7n8PztOI02VptHV4y6fxXXevJuLRxt2O4jKlT1tjwOtaa9EO9KknltomQc4DR1DKg3dTof/aEKFxwSqb0kGqyQtYyJS/0a1n9UrIoh+pd4n7P61FSL8WgbttRcRen9ovSVu2hLxfi0En1qDIV5KmD8fn6Sy+xxUplsHiY/pKdSmv7mXhrR33U8XngHqM+8nTodHfXU4Yjc1
 GV0T4+yy
 s69v9dlFyUqON7UFlUbd0cYgKhP5c+uGTpQBK2uF5SMwkex44QBGDoOmkBXeetOtN6T/CVJpGiBzEs/JYgx7DAYtRgBtDP1jP/8vlRvHiEsN2wFJk4jP20jlI9RbOFQCNsl5ydjqL3zYe5clDDyoFaZlkXV3/pzyOdbG6JejvLIuoolpcBL3Lsi4TcbZpNbpR/xZ5h84GshaYGtddX4Hq9ILBauU1fCx1Pdoe6G83yCXnActHkfgw+FSHoSUD6WqsLsP6OzNaBVr8cF1cTSLSM94gL+e1RryblqAVmgCaBDquNlUuGrQdRGbMBxiVcRiSc/u8x9N/Cm+Zer78wNvICklqnWK6LPHBIacHAF8j+8Cfz7EpxFxYH5a44Re7qVIs1f222epqmldISw7rjJjuAfFQU1rSRGydyTKvCWcwYJ8NezkdNkI1hs+EihwQ3hpsCt2N4xIeJA0CBNoTB13FgeNdU6+j+tW/z44zbUz1mSmwH84jm5G++S7s+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--/fHNA9/ObvvJyqoU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 09, 2026 at 03:58:47PM +0000, Kevin Brodsky wrote:

> ---
>  mm/Makefile                               |   1 +
>  mm/tests/kpkeys_hardened_pgtables_kunit.c | 200 ++++++++++++++++++++++++++++++
>  security/Kconfig.hardening                |  12 ++
>  3 files changed, 213 insertions(+)

> +config KPKEYS_HARDENED_PGTABLES_KUNIT_TEST
> +	bool "KUnit tests for kpkeys_hardened_pgtables" if !KUNIT_ALL_TESTS
> +	depends on KPKEYS_HARDENED_PGTABLES
> +	depends on KUNIT=y
> +	default KUNIT_ALL_TESTS

I'd also expect to see this added to one of the KUnit config fragments
somewhere so it gets run as standard, though that's a little awkward
given that KPKEYS_HARDENED_PGTABLES isn't universally available.

--/fHNA9/ObvvJyqoU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHQEABYKAB0WIQReagvpf3TrrA7BoYYv73Ows9A4iQUCavIezQAKCRAv73Ows9A4
ibK2AQCrJzPayeKs4GAc3zkVW3UwqtkA+D8a/edVfuY3OR/2bwD3XTl245dfPaNz
6bNpvbbPF3MhEBTENHBe9r4fl/a7Bw==
=iCAm
-----END PGP SIGNATURE-----

--/fHNA9/ObvvJyqoU--

