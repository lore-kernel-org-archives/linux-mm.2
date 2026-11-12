Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C618D606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oFJiTkr5
Received: by kanga.kvack.org (Postfix)
	id EF48B6B00EF; Thu, 12 Nov 2026 08:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC166B05B1; Thu, 12 Nov 2026 08:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB876B05B3; Thu, 12 Nov 2026 08:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C14366B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:02:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49D871205BF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:02:29 +0000 (UTC)
X-FDA: 85426480818.21.38AEDF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E1C01C001B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:02:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFJiTkr5;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDb3YBsZt3PeUijZoHvx7wyb02CrjviLOfxg4rIAk+M=;
	b=AL7U7wV7twMdL+ouU0dVDMFXp2A3KDmkSQIBVoEyfTxYJacbWadP+I0auEfY1LZCQ+UC+L
	EdcIp32n4JOqbKYEnTrQ/nG7BPYPT0mWYCw0L1IJMMAMcXwHQ50oIRR5o5jGDeqEe7l5Mr
	ifLOD3ZMWXkJPq7cgo9UNmGi7/98tMo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488547;
	b=W0qeDcTptfMIjKW/u2kpbr4iqBcz/61nfTIvGAKCQz3oPkaom/Zo/ELaGUTWUhcQ0XDmgE
	J5H9qKLK1Up7LoCOZb6Mk9bHRHCRrQ4BiO+20tlnfE/Td3khQemZRs5BMgdwBd+rJQnc4p
	3JX6vwKfAd3WZwDgBm7DFS3+i2mWYTQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFJiTkr5;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9F1E406D9;
	Thu, 12 Nov 2026 13:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B481F00A05;
	Thu, 12 Nov 2026 13:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794488546;
	bh=sDb3YBsZt3PeUijZoHvx7wyb02CrjviLOfxg4rIAk+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oFJiTkr5drh1BtvY5o2xG9SbtFrLSayp52k7g32cCv+YRR0CLSNTOytMe5y6YJZnD
	 A3Ec3SnjYHkRM/LfaaukZbYC7tXR29Arwqny4tsBwitscyYNqHj6soAludR/zpNRif
	 DTiz3inDd+WROyNFUdmA5E/uaYVc7VwJDdOuLDXmIQ3H7eDF1lgEJrN96CaOYBGel9
	 EYjdlzRxDQUVciApvre1figz9FCSbNB8aMk3jNw/oilISn8V4z0fPwZwbhNFzYVovW
	 GME7WFgessJHRG2CJVDzRzDQ0wA4ZPHRpyzgBPxy5p72SUEQMcte6E2VW0TR3s7QLu
	 Lo3ciWbsVJivw==
Date: Thu, 12 Nov 2026 13:02:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-hardening@vger.kernel.org,
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
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
Message-ID: <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
 <avNH_AdvK9AqvfF7@e129823.arm.com>
 <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SwoWk60SP+6OH4EA"
Content-Disposition: inline
In-Reply-To: <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
X-Cookie: Baby On Board.
X-Stat-Signature: yf1pwb7huhujj1mexdhr1ykxbhgfp8pp
X-Rspamd-Queue-Id: 8E1C01C001B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794488547-255276
X-HE-Meta: U2FsdGVkX1/X4qq7oW6YKlR1vgIAzYrvvsKgMpWsiUiJ39aT5XVGccz8T4NOSiqgtfRoOtucRJhH4IcsUhoaD5wj4JLIlwaRQoQiqkU4efnDcgknGN9KiZdPeIO7bY5lVfRF3NibQSze4yRnDxvlts9aUaENyJkBKIiOMYZdIThtwDdcfrwnh04LwTPB2mbsboFxDOSYpAA7RmiIJKA+dA5W0t3pgx7XcHBNucH12+cLr8O1WtdaOk2t0mUXn1BO7lq6qx/zXWYwDFNzZHezr2nEMgdd65UT54vPDEajNnsnq2cXTeK6chM+OJ1fmJ7Uru2Dm/Y/gEfzHy28yuHwDNqEqguMG9nUkJl95+6l6/t9/BsEn2y/MrlI44IeZTB3/6s+YP8Ipk5wFxnS1q1tHQXfkzVZ1xDO2aZH7hRPF5b5CHW3wV/E5VfQONqhblblR/OMmTEsyq9ZhFkFxXIOwLMR74LpHmeMH1zwnuCq0mBmd6kwZgbBHlhFFbBsaKJMEz94DOMa8qNVJEfij+F6Qko+p6t8YaVzBhXe+UNr7IcvK4/1cBggYkdP8kVXf8McVuN2QMxrBLrxf6PHvRq8pgxZNKs0L1eORthooFl0v9Zx/rQ7zL8a1fbD0XL8KZRJd51+LbuGJiN6SpK1mzp2lJnLt2e0RjXuSdfIgXst1/xZDEM8NUMkoZYP7iREVBxXxyQruZMcKHn+G+ad4J6GKc8Xsf+86gSr5r26w50sf7/o2UT+lQqLet/SlPE7ta88aBiGOPE2rfq68FOm1IRhstUvkuwO4xQHJdewab+C/bG2JJa5xETv+wXaqbUg1KR+6Sh8rsOTQmTBo10eeDJpyAL+BnyRV+7YmKhIJ/5Wzmw8zfIorqYvNug6EA4HIfzMkOF/qfal0QXHyvFDJKSqzwqBvPkTPmvU7kbCz/9BDQaN92846TocfogRk2GscZG+0O8gJ27PmQnIwCPiQFu
 cMlb6pKf
 m9b+pGOLuqBpvo6UdkbblYW/oEWBaeXIsHEhRox8OfSUrpGk+hnbgrE9jaJJfOY7nPX9LCip+FGo0u26zDfkCccIbMeTG2hDheGrHq8YbRsHcQEBlQt0IxbzhHChpjyHzINTlFH71RRW6zOowYgwItX/tDSp2E4XvP+7Zep0KBMKEUfVWOv7adHisOHPMR0dmPjOAflSERsTuhiN9ZGkYs8eT+my7g81THWaMi5h4jbsHeruHcsui4ldD6mwo4VZq6j2IQniRsBOkAddHwo+FUjbPPMIluG67M0la09//nYOMOO7DeqkxSxPnlmuq+eDJ99ej2AEh+lHDacJbZPT73KYbpRRdXKVirzcNdhnwluPZmoMqjZKsaa/O8ZKP27+dGi0nGPH0T8D7/dRz90UAZcHSbUZrBL6gMaVrcwg0WUvbjzqA2L+uaB4euKaWtiYKlkHwdq+WWgTN42IrWY7Ti/UPMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--SwoWk60SP+6OH4EA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2026 at 01:38:13PM +0100, Kevin Brodsky wrote:
> On 10/11/2026 17:36, Yeoreum Yun wrote:

> > Thanks. seems required to isb() after initialising SYS_POR_EL1.

> Agreed (as Sashiko reported as well). Presumably that means we also need
> an ISB after writing to POR_EL1 in cpu_enable_poe(), as that's basically
> the same situation.

Possibly just have one before writing TCR2_EL1 rather than for each of
the indvididual features, that's harder to mess up?

--SwoWk60SP+6OH4EA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr1uNgACgkQJNaLcl1U
h9CFagf/dbYYRxn1/SN8z0WGZlRKk0wplm+k3WdNb1XSdkf94D/1Qwvea+KXPDBW
GBfJo6UQx6bw0YLzuPp5KpPUHoNAS+NeabpCnFuiRKzWyRx26u7UtnSL5YTrQTXm
vcLPYfriMKpV2LSRfnOUqXjGkqN6ZmYDMiKn7oiklsMj4ajpPzU8/UJwjLd9DCTn
T6Wjdg7dHsxFLQ1CD5JY1aR6yFcEAwaSmbHWfAvqPAVAt0xPZPz4Jik4lFDjIkPD
vWG8oBS/TsJX7GhichxRZvfHllePuI7Q/4Ys/hf72gAofgR8K5Poy/9URdY/ctF5
2pyEuJxKkykegWsIvwnCxKgzSjEJAA==
=PoHK
-----END PGP SIGNATURE-----

--SwoWk60SP+6OH4EA--

