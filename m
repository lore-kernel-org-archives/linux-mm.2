Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71847606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZWIygTuW
Received: by kanga.kvack.org (Postfix)
	id 8DA416B05B4; Tue, 10 Nov 2026 06:24:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3366B05B5; Tue, 10 Nov 2026 06:24:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C75E6B05B6; Tue, 10 Nov 2026 06:24:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 589946B05B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:24:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9D0C140337
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:39 +0000 (UTC)
X-FDA: 85418976678.02.AFE8025
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 24FD440005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWIygTuW;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtytf2wOlGKlE0TlreFVP+6q1oQ0wXhrbpcwMFr2kqE=;
	b=Ls0jwoM2Sf1VqGY7GIxJ1xy4hnW+/oKL6/1ze5+wB5lZ42goBUhawDx0llNzKqOrfWyN/G
	HQvcxU1sAFaUOCZIlcaG09G25U0gzkx5z1KvU3nbf4+D8G0CGWpQHrD6QHahjBebrtpm/x
	b244hyCJ/Xfh+eb8n067WbqBkFgAT0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309878;
	b=61cU+0BeOaEgN+sImw3jAhG6IdF4o22QNg8cgvKHh8AZpvYD5hKPHdzWOOzkyqNOK7sbxp
	IlK5r1ao7Sbj9f+CukP2365vHE7Y5T2OjhJ0WIsEgksS4hpR9ewHVLPJgbClyMYfoQXMKx
	ol1YpluQ4IvXelYV1DthmVqYV4bLZwQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWIygTuW;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC78941B63;
	Tue, 10 Nov 2026 11:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADD91F008A3;
	Tue, 10 Nov 2026 11:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794309876;
	bh=gtytf2wOlGKlE0TlreFVP+6q1oQ0wXhrbpcwMFr2kqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZWIygTuWyMwrCCyWkgY7RsSrCDlQmRHjE9kDJJY9fgSKkW2X7Pzbdk/3g7E0JGGJj
	 mqde4QNo0dOhsy/Gn071pmagJMcFwkMHNEXlNvvPDwwp10eksS4IhEBAyNpcUUHNdg
	 03xRBW6p5vKfHW+VjaiwWf0yMYhOG5dztiwt7IvW67IkhnjAYpK1fJnR6QatxQkKpc
	 Z9tzO6sREiDZhnO+fEx9KNcU9tT1MGR+831DZvlJFymsBcBH7mSmiB/bkiRKz0KB+8
	 QOgrK4FV4ntU7mrjA9MLzJxXq9gTVW21ij/97aJSimoh+G1ihBNJeSIJ5pl1uTAFQi
	 BezOJm2/uzfMg==
Date: Tue, 10 Nov 2026 11:24:20 +0000
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
Message-ID: <717cccfe-81d6-4e09-a466-5361ae27776f@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-22-aa6c4d9603bc@arm.com>
 <2d13fbb7-b5b4-446e-8709-5b43349ff19a@sirena.org.uk>
 <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qb3IpGrfHJvhxTh/"
Content-Disposition: inline
In-Reply-To: <9e59fd71-97e7-422c-a7dd-bc23c6e6a852@arm.com>
X-Cookie: You can't take damsel here now.
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dise54hsfgtfkadzzkzmzcpzz4n8usr1
X-Rspamd-Queue-Id: 24FD440005
X-Rspam-User: 
X-HE-Tag: 1794309877-896498
X-HE-Meta: U2FsdGVkX19tFXHYy+SOe0XKSXcrDmmQppLnI5M2/2xPIW1z7pzpSikjcad1TGQDI5NSqDDt/UEDqlMi3JB0sAbiRW+Z3txoS6XRjjMlHrdksc/eBp8CGcJfolpPlvtoESGi2MOqY88PRHLSXbu3//T7Xlgm8MygzYaL6QFltGecXQzzwHUgGMErPcgUZcBXJ9lOC16Usnv24P5Yt2Pk22u1jHuFwN/BeV3ukTB/9RHg4BhrgKoT8fzuF+f6/2k0bpxe8yaJDFbbh3Rp+IVrqP4dHUKFljo7LtM6v3X7L8SV0vXRFwbT8kEJd7s6h7C/tmKqcACaLyVFRc7XhgTEiUK+mkRCtk4lq7I+ziP2hrNB4f9if6+chcX/wnwlj9IfIhFXZXvILY8NteslmcRDHaDhA0kIrS/Wik7gSIiJxK5ETvZum6B9TwDemO1GaMC0gDRUBbNTiEE+jEybVgoRb589XzYKTkx1UWZ6ibk4EU+4hz4dNKSRHjH9V3NNQIimnV+Ywi9/Mu95PxeDdIHIqg32J8djfTOmWQps+nFmcRy0URo5OsT8rfE/brn0SpDgsWSV8cn8/a2yLzz1/ZZW6kyafItkOIoLP5q2/x9T3+DIGwIFcwNNYoxmjLhX3Bly3GaBO4UvcAcke1Nq83zP7BQ/KstbP68GXokvca8iFOrkN6Kvtnm3ho6HcqqcHZI5We95yCkS8iYXaN/01d6pkpcbey+QgZCkZ7Kb3M0uFK8esC/Ej+tHZKEPnYyy6z7xoMjooROu5Wk0W9TN3zzeWGDRbD0ee8RFR0steSmh3g7grUDCprtHU8GRRecvIa3ccs0bBM3K+HSCrOgetoGWtXpc1dusT1ZULVHMHugaL+aCEsUxWE9Tc3Sn1Ui5ZtoNJLueiWx3bBXQLKVX9Bw1XCqG+Hp36rQxT/1CHIjD8pTBOZS0DqyfawscXXUylTtMOhjmUnv9QjxmLVFEvjO
 Rsi3TslJ
 A8Suqn//S0GxHMQJmYrc+DwqAinj95Q3oc/cqRPpS0Hy/BU/rhp8fx1jU47aL/2uNAYOjC6sm95rjnXH06x391ZLwuc+VLB/JWvB3vjrNNdxy83LxmiFwiFhKIggakXxLinXqSrl6Jj5ois3VtMRSqPZ8eo2+XvqmgqYNny55ZLEHHN4CSErTWkreO1629HsYhem6jPVOYcy+1PeG2VLq6paKQyWfWeiLtzO5q+4O3jdbhJMtyq8YD96CMOBHJGEdHNwPrD3W0RQTwj9IYEEX2tYyVEFUM9AXBxAXFKA1pRBwczVbQpCp+Mkf0KwrMWZX79avz1i5xvJKblxElnr4rD/TPyX7lgDItGIQfmsCz3obEBorKlHpPNqvnu9BWFQN2U2UXMLn5wg/6ButVeEPYGf7ZAoBYTYf0ynAngbEHB52wBTioncimRilDaASK4OP2/WCAWRQQAL18QqtDnfpA+G8qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--qb3IpGrfHJvhxTh/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 10, 2026 at 10:01:36AM +0100, Kevin Brodsky wrote:

> Do you mean adding the dependency KPKEYS_HARDENED_PGTABLES=y to
> tools/testing/kunit/configs/all_tests.config? Indeed that would only be
> meaningful on arm64 (for now). That said it wouldn't hurt other
> architectures, so happy to add it there if you think that's worth it.

Yes, or something like that - unfortunately KUnit checks to see if the
config options appear in the configuration so something that vanishes on
other architectures causes issues.  Perhaps the default for the config
option ought to depend on KUNIT_ALL_TESTS?

--qb3IpGrfHJvhxTh/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmry/tcACgkQJNaLcl1U
h9AxJgf9HO+bESqmb7Zyf8xVpU39o1ESgrk4qSe8omR1YVn15bXCLHubG4BA7k39
BBRjIUd0oKzcXxtFkuIyZLiQ194uaRe6MuOfoI+Ruzd2qjgzTlq18s/CUQYd23um
xjtw1Rb5Vj5ruXGAwkuBosPG2vqzM/kA0ruLkQQ1lknx0wrk4buAsFjcNPjsddup
ZjuRO6lSuXkDYGYG8l64ReC2hWfMTDKifeFbf0EMisifvHZ0dEmDf5Y+uJiG8l0v
fQU+vj+TzA5V1SPmj9DpyTfm2wWwqpbBgxyuE1eOOj5Cj7wZ4Pz+fHhnfcmklIiL
arkt18G1049QM3sfXwdWCKF3B89YVw==
=yf2T
-----END PGP SIGNATURE-----

--qb3IpGrfHJvhxTh/--

