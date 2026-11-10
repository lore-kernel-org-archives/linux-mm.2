Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C921D60A2605
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TSJs0Dw0
Received: by kanga.kvack.org (Postfix)
	id F33DC6B05C6; Tue, 10 Nov 2026 10:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B736B05C7; Tue, 10 Nov 2026 10:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48B46B05C9; Tue, 10 Nov 2026 10:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C28426B05C6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:29:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC6821205EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:29:22 +0000 (UTC)
X-FDA: 85419593364.24.D31F678
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2D43D80009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:29:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSJs0Dw0;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794324561;
	b=msIdm4Widtk4h5aK8AhmgQGt70vvbQP/eg7ObZX7o6Lt+KXPl11dTDa4qnFnu8jzK6lyF3
	aNH09NaK4UIn8c5XRSHoIwCEbS2vAW1jS9f6q5oTGQ9mB04LsGM0gsIeow4aCbwhXSGV8v
	CU7W+OKONDpzOLTzN5PzlO0uMMxjO+s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TSJs0Dw0;
	spf=pass (imf02.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794324561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt4p16M4Hn7px1KF+H5JB36BxwFxJbfBsjU1XaPYy7I=;
	b=hwXZLiNPuIFStx7BzXZbIwDfbbT9Ut7w6779InBh6vgq5Hd9Avk/NlBHcimKefeujIAs2J
	inaXwfvmLy81Bo3PPRu/HSNvJMsi9xtEDtzpdXsRHk3H5PNdXQ+N9vpes2GSbZUZ2tRLKK
	/hDweOJnIFPzuzIeXvmGlngUxak53TM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6013443BD7;
	Tue, 10 Nov 2026 15:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F8D1F00900;
	Tue, 10 Nov 2026 15:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794324560;
	bh=Bt4p16M4Hn7px1KF+H5JB36BxwFxJbfBsjU1XaPYy7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TSJs0Dw0xyOaRnZl088l0F3yIjGw4rU/H2At2c8xdDHdp8SerI4hF6PCuWS3HEruj
	 fQCx/eJIQmjee38K0kl88oaP09m8oPFuWfb0SN2hdJzERKh8HBENPPbNq39MNh2UPZ
	 6LUEoOgWA4i1YTnY9oJO82udks6VcVjN25+VrrtAMglfx6zUadZkKlzvwnivvOYNaB
	 65uMmDKxwsnbXEjB0BONIyAxG3GTaI7iSmzK/z4wlqJSwCXkSd0psBWDyBjr1GYhQD
	 0+xb/kDbfockIG1X6kXknznczMF7Drsf/dASORnmaQY6SbL3ZRlz28lUCakAsVrTFc
	 ordjZse33Ca5g==
Date: Tue, 10 Nov 2026 15:29:10 +0000
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
Subject: Re: [PATCH RFC v10 06/22] arm64: Disable EL2 trapping of POR_EL1
Message-ID: <3500936b-4177-4ba0-a9df-7eb9d9d75b0a@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-6-aa6c4d9603bc@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nrZdJCOCfevRaauL"
Content-Disposition: inline
In-Reply-To: <20261109-kpkeys-v10-6-aa6c4d9603bc@arm.com>
X-Cookie: You can't take damsel here now.
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2D43D80009
X-Stat-Signature: bzfp49dg11brp9ag6ziyjnk9yj7jt58x
X-Rspam-User: 
X-HE-Tag: 1794324561-160102
X-HE-Meta: U2FsdGVkX19uZWaEuNTxTsVPkrYGAdvwOWhGFGbQj/xnd7bXMoe4fVI19Snu0B1shAEDmRYcPX0QD7MKFgyVORlHmVf/QPzK5U5BLQRYxmDwPukvYpxfUkxmBL+Z9uOD2tUsxHmzFIYsTZA2p5fBy7oxBz1yN6u2Zb5ppeAvff1NT/UwizYJJ++6rrAuZ/3mer8h6hZrplYKAQQyDUQau7f7tFb1hCe1uYwT3jkwEmD4mB0o0f+E9UL0i1iorAPG7hI6pjyzVa659jkEV9SUCiCREmXWAaULoiDvfx0e3kZjw2PJJFWePfCDdckkhE1IWdClSQ6U8iP0X1+7Wt1n6yjPkGhPEbaoLxIKBRhi1pCXd804lGt5QKLEqFwnDh58KukZp+zRgUXltKhzgnMXCsarQE71aFg8BvOgi+G35942b2/Z84H0gDhkNzJ/vREp+zZjvgZBQQnJK8sgBRfUvfTu4TB6OXLxv2Y0wX72DhHMev79lzDwdQGpy9QozPDA89VKWdMo3rt4kP7uurPkjpbMh+6ExKksg9NvHSgFyQnfSRH16Wivn91gDpWh81vLHOvM/l5EnBBOtaozUja5t2tREGzv8gtGLcFVZ9VCG/7h4UQAqe36+2zsTAkFKcYD9vaTteZpIc1a36GG9geragRtKWil5ouDhTQth9a7+rjKt/3ueatU5Eyb7N7MZpxQmPn8bGIy+J5KnpkVCXomik8w/uMrOD6sZPnA/UGTNNqgN8oCvJNeOD2mH7IpFAjrt9pvhtad3Tw/aY5JfMwoxDYpwcOwZCXBJv+QAthqwbx99y3D9LmfmJfZ8EIVZXWuE7VrJ+R2wIHo9n9QCiVxCxFf4zHg753aqYFtHCKysth1B6Gtj3gBQecHzK2GqAYpxSJOKwRKYiyXD+26GSAnv1SMfkvtamhp+xp91Y0897m0NZHcQDZzZFfw2ejnK9/H8wEQ5sy8+rvOgGa/h7T
 8enjgxaK
 nSWhzd5AhNXNpp9ldo5AcwweW0Uj7KL0/VRV10gIHYf8GybxRTOc29nAZJxUD/j5zjuRKJ0m4RT17BZkMVxUS1MC3IjNSTLbqCLR4nG/KkC/FZYmIWv3zJ12oXiVbrsg0sKJLod5B1oEFO1Da6Czj68L65nMmMr4Vq8/3sZPiVWRDUj0SYtQRRx3Tai4T5WAgx6Vtus5zJDgjOVjdtzGF1Bs7jcQNeYg7kRcWdby5h5uH4jl8KiPp3CczZTPdwe2vvcLWKSfrJklv3mHuY47jKSB1w0sa0LIJ2UMlJH5Gtuk3jbTt05vyy4l+FxC+wpYjgG49G+kRFNM8pPohDobpzIaiOdhPgTfqFCAPldooImrjyvzAZ1rZ7JFwMmUpNM9rDdMEMinVWeyJjUdS6BXUTEy/w+hmNEatbwOxvI5ZXLj+AvoMTlZB7VP3VJcMNeE7+UdQv//+DPxt7NsPNXhNeiVUeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--nrZdJCOCfevRaauL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 09, 2026 at 03:58:31PM +0000, Kevin Brodsky wrote:

> Make sure EL2 doesn't trap kernel accesses to POR_EL1 by setting the
> nPOR_EL1 bit in HFGRT{R,W}_EL2.

This wants a matching update in booting.rst as well for when the kernel
is booted at EL1.

--nrZdJCOCfevRaauL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrzOEUACgkQJNaLcl1U
h9Ag0gf/f9f5XP+mPu/qkq9MsiAddVfTPO5cBvZan8qUxzXzuilhA54mF0WCZWl8
+Fmzl+Q0J4gwxCKcr+yCLoOyMvLGiUCFQVnPcJT7wMBqrZ5DA5f/OW6YWx6uMZyT
ExUsefodnzmOczU+s41SARPFGFuRuJsT756diQQYF/IlO8wq0GJ8mWoBGKf6H3OR
BKFwnc4Cda3sUrlQ5UU1Y5DRXoHpQJe2+dz013uXt14vDmtxE8P0840PIRU+Y/F2
zhXRtj08uReTLuyfCpkD2RuiPx2DKigEDjHND7yPRfuiA/qskHTAtBBtxtRcXoNc
7EjgnbeiJeosuSBYcCi5CS+h/Sh4Jw==
=osnL
-----END PGP SIGNATURE-----

--nrZdJCOCfevRaauL--

