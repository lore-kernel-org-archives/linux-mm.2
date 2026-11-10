Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3596E606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSgH+nQG
Received: by kanga.kvack.org (Postfix)
	id 52F236B05B3; Tue, 10 Nov 2026 10:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0956B05B4; Tue, 10 Nov 2026 10:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37B386B05B9; Tue, 10 Nov 2026 10:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3406B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:53:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A733E120944
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:53:43 +0000 (UTC)
X-FDA: 85419654726.22.0562D2B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id F2D461C000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:53:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSgH+nQG;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4qaBcoJhuip85HNRKTiRsc6cXmbUnKal0wM/bMhZ1/4=;
	b=afXg8/C8IwDEcFlnZPpODEZwjIYBDamnrTM/7Vt6lNb7ISwU86VFk3tcXukDSlH8Se5iiG
	gDAX0pH7UFq2mfYYPtf3qYKw6J+mzxj9BDfUGIONEdAITyP1S6JtAII7WEElvkQSaQq0JY
	MDmoY+qhpMj979ExOsN/fyvSZsImJIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326022;
	b=l1ABcqcCx5hdKDmUm5/FFqNcnvS/nevU4VkC0GLWOKue3jHcaKGans0rl2BqR0KIm0EmX7
	LyUVzJmxNYPRhOlYZFjWT525goyhg37GiNrxB07Wqd+mxFLUHd0DAPdBbJ/TOqTk8htHN2
	2ic/HWnjVLBhZHWJjfq1Bi/jBzMIM1I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSgH+nQG;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8FFC8605D1;
	Tue, 10 Nov 2026 15:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B92A1F008A3;
	Tue, 10 Nov 2026 15:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326020;
	bh=4qaBcoJhuip85HNRKTiRsc6cXmbUnKal0wM/bMhZ1/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kSgH+nQGYPhpecDT9RjX6A/Px+LoAnOuAhiSotnuroSbtWAmzKYW4psaCtAgm3HTu
	 Ud6V+EHkVE3/ElaMQwFldGXubSt6xnnZ/H3lgzIXO1EM8FVi1btcbv6Q58NdTqn5kX
	 VSwm6LEMTkaplsK5V9TVhOGb77Pc7h/AvO0sKyFHmtojeCKTH7meWA2i2lB3xJQORv
	 LLCXQjH6SckaZOufXYpZi4+dMGxI7LRSKGENk099kRFe/hVqBoPU2XdsQ5DcgYensD
	 /N1jMWwlSmjxHjQj70tuBOg1mUKeFDv3uHaSqSd+3wj7rolN0iCh/5JK3PXXFiZxS4
	 +LKdNCB+uEhVw==
Date: Tue, 10 Nov 2026 15:53:30 +0000
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
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
Message-ID: <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y6i2pjiKjCxCKcN0"
Content-Disposition: inline
In-Reply-To: <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
X-Cookie: You can't take damsel here now.
X-Rspamd-Server: rspam06
X-Stat-Signature: ycuzwihj41uzqfe88zo4odozxr5d18rr
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F2D461C000A
X-Rspam-User: 
X-HE-Tag: 1794326021-650866
X-HE-Meta: U2FsdGVkX1+iDGoTx33xNr6dASf+FKJ22hGdIAm40AV9VcXnR0BKNlucaPKL632RiNLAbEhF3tT4+JdmYTNDckCc2rrNpUp4FyxIfX+w5eCVs27u+MFvruQUMGqL5P6B22p+4R0JjsU9MoHqD2yhja6gpnJlcZhhGWteCkoOdnwZtc4kEeGJG2y350JDe5k5PE+HK7yb9ODXmuDkmB4fBCKFjlIR0/D1BE4kJz816F+HoPUwvzFfJ4Kquw0xVWpWHcS+A7eiNEz5qhJPaqVvsKt+NNsU91G8Rc9kKMSAU42Ojnv9lUu9FajwC2hdIEj8HzY+FTKSUEx+0010SKuj03pnn+lyr50A4ip3ml/dOwjmqUdSFCxwDA3UZCsxzB1sRZRJqnGEBmyNzVTjvN3gcAZSfz/SKATAQb71j4s+iVunwyvNO0DIO1Z1n1BCGTZtuLFc8ARRDj9quQq2REkdCUTT1BwDMq/u0+lSbf1DggT7lM3NPbIllT5g/qZl9TtiN7xl6xuwp7w1aEUMi5vhLEuzzbfQ8t7MaiI9JU3ked482U7axEbC4zEhZZVGjLogImI7NPVwM4k8l0/bgYWQSHRTQV/j4Am+qIwId2Nqs8eFpHDBG7sP2sH7HB364b1iDhViNvA6kitJmo5ga8p95nneH396p90PcOvDepxtvxpUjbdVnFfGPdNaiCHbZBnLgRKr4od8jYZtpjAy9XJpT0Jqfw80Em6lEni+qeLqPS25F/D3Xy7YlRmEYQHxuYzUum2QzXrLHrMMJxZxkSv3/6S/Zq5Be5zWAOCUCutC/jTDwsE7VRpVs++a3FVLDemzoVz3SdUVoXocJkABWYROXKXzPSqMdt3gJibVHs5VmKyifZIhjzi7+Kv0dOhEnj5+0XAQztWXUam95m5PRsgXC+cKfgTP52/0aAkzPMtpcQmJk0FJZpBMwlPz70364dnM2HvobayKLe2tQVHnwRK
 C1ZqPTcW
 VoGTJtOLZnsfRHU58f3OOdRyEK0Ya8KkkbAsmbuWUckifoZ043nhkIeX9yVnblHwCSPGqNypnKeCQXpk3BY+9TAZEQv60dZoPvlt2WPVVLb/zBZJ1qXjn3gCwBQL66iqtTpaYpIgQIM0eQc6Q5h+5RSUdb3j/7xCH9K1KYfnebMps2BFZAw86eZsqGg8M0UuPIZoSBmeihl48/ul/j58EqppHRnbL7iWuUEGmvnEP2udhau5qRt9TKBP3QMdkxMHMAhMg3znynVYUGbW91Clk0gjj+q6NeA9BeAR3WE9Pgx9ApvLsc1fOXa4rM6yjoK9m/8mbU3uK9OfJTTULX5claBHlnxMKlGGz4D1Lxs5F7zCw00H86SFUovBClQiViJoZbjMV64DO65q+Mk7W4Z+kIQD0+Xzrs6W6IWi/32s6zqCCU5l5kDzkkr2yX0VpSamICgesTwUuhAS14mfEEtVj4KxZwf8yax49ln7BFTgEsj9TXUbF68f6S8KCk09NpaODK4NfapzOJPYkHmHRRiWLtQ2qnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--y6i2pjiKjCxCKcN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2026 at 03:58:32PM +0000, Kevin Brodsky wrote:
> From: Yeoreum Yun <yeoreum.yun@arm.com>
>=20
> The POR_EL1 register is reset to an unknown value after cpu_suspend().
> Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
> initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().

> +#ifdef CONFIG_ARM64_POE
> +alternative_if_not ARM64_HAS_S1POE
> +	b	.Lskip_por_set
> +alternative_else_nop_endif
> +	mov_q	x2, POR_EL1_INIT
> +	msr_s	SYS_POR_EL1, x2
> +	/* isb can be skipped since cpu_do_resume() will do it. */
> +.Lskip_por_set:
> +#endif /* CONFIG_ARM64_POE */

cpu_do_resume() will update TCR2_EL1 to enable POE again, a sufficiently
unhelpful implementation could potentially decide to do that before this
POR_EL1 value takes effect AFAICT given that there's no barriers.

--y6i2pjiKjCxCKcN0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmrzPfoACgkQJNaLcl1U
h9CfMQf+KE7tK9rhq506LXhS8qhdHDevtfZx2qtai6oaI8ROe6CSxZZ/PYZX/AxQ
RB6TsZs/ebSJ8cn//ARFNZTWaspOHI13wG87Laj48QjwPVZuyBAE0MV4dlqlxM8S
SUaN2cQ+xL/+x75htSgmDnA6NBZi/NXn8Ln2hpoiO8FO2oPSFY4l4xT9lMCvlol/
4g9degQsFMatI+eteIErPUBMjUrTr+jpSK6zC65gIHerzlhXvpQmwro7KV4njpMZ
zD2uA/+8YKidz8WAbiX8M9XETgaqWCGaTex5RrzWMqls1c0DvV4mFFlewowBTtEl
CC0tUcjeb2jQhyVBZSQ3m48X0DCWPw==
=ZUNG
-----END PGP SIGNATURE-----

--y6i2pjiKjCxCKcN0--

