Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F1B606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GsBDW7jk
Received: by kanga.kvack.org (Postfix)
	id 953F86B05B9; Thu, 12 Nov 2026 09:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92AF46B05BA; Thu, 12 Nov 2026 09:09:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868B46B05BB; Thu, 12 Nov 2026 09:09:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62A866B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:09:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2FE9160583
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:24 +0000 (UTC)
X-FDA: 85426649448.06.7B584DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 426554000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:09:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GsBDW7jk;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794492563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bav+dbiKMPv2EGpsaUAhorWs7PAXLzQQGUUajdSwRU8=;
	b=pe3p2Yj/YIF4U2IB44ZSUuZvrrowUHp+ybswbCCcYi1sG8q29XlLEgJWHZPsXXbQaebOvD
	s3rLmjJrQ+TlMLyEk/DjpIH0c9o8uKH/EdZFFbFAfbNznLW05lFAHnokrfEGCnSfnGfWTY
	l23bxiPsrb7IEFsGz3NAUP4twMeuyv0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794492563;
	b=DGo0tHLHxt5BFaNxLcgl2V4HTmG1nnEQA1IrDmR4VIrYdAt6/56g5C3cM9X5czwvgL30Q6
	r5UhKCXW0aIFhZefreOxeyi+PA4ZwzcrV2gBBqa0FSHJLse6TVpofMFRL9rE+vl/OrAlj6
	Gd6vYb7CEGgIQzstpcN8BVSnVS4nw1Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GsBDW7jk;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B5C6362D1D;
	Thu, 12 Nov 2026 14:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193031F00A06;
	Thu, 12 Nov 2026 14:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794492562;
	bh=Bav+dbiKMPv2EGpsaUAhorWs7PAXLzQQGUUajdSwRU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GsBDW7jkZwGolei5OwviUP8YfwzZAxvq7dLne75yiI+QNaAhKCVLTXjTeGCmLawTS
	 A4BuUY4qYFLZc2UIeSe8ZibVZ3raDK3EiWH0ycSOieOQTKZd30GUVthpaI/jPpKmXE
	 Wgdc472S+8VsrgWtji6ZeAe/RPaxWsIfJC1/82UEevEwPBEUaYMPTiEiW5p8w08tj2
	 diQPmi5mPkydDsKrDYWdqNWZDO7b/pxth0rRA8iVyDuFGcZrrKai3IajCA/yKybHQE
	 h7ADR80unMaw3b73T/FJVgDl0hFOgO/3OgxibHF0Y6GLz2r/F3ctMavaZesf2EYRqR
	 mKlHk5hT9HB9w==
Date: Thu, 12 Nov 2026 14:09:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org,
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
Message-ID: <0d12b173-ba74-4d5d-b1d9-bd441033ba6d@sirena.org.uk>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
 <avNH_AdvK9AqvfF7@e129823.arm.com>
 <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
 <6808f3a6-1c12-4cb2-a109-30704d812490@sirena.org.uk>
 <avW7mVh-s90SdUYN@e129823.arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ORVk8nI4MBGvkiv/"
Content-Disposition: inline
In-Reply-To: <avW7mVh-s90SdUYN@e129823.arm.com>
X-Cookie: Baby On Board.
X-Stat-Signature: sms4opy9tmh8q6ehb7nu59iz7tp8kncb
X-Rspamd-Queue-Id: 426554000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794492563-575579
X-HE-Meta: U2FsdGVkX1+LKvkcDMQlqRw1IpGNxkzOw/L7GIxUfzXMZSH556n5BDA+4N8/IuA6gyjKiw2DslQM0bFBF7bjYj1HwyhLJMYohFd9P8RC0M22ZV2VhuOKiaKkyQ02JlDv4Tan3TCqCbwumF7JV5FSjBa6XIkZT/89RKmULrYlxvwgb0MTzIsO30CaBZuc3swQPq57r1iehZlx+vfbF0kiM51krkjIupgCk3tBUHtZvYBiAeJe6VhBb25XIWrCiQ+CtCAgXf1eEovil5RHlgW/puQu0WG7X78Iis9EChO8QsMtfbhblf9YJpDnQIBhe2okwjkxlwPbTuKSwS7TbIaOeBTfMY/CIse4y4zfMUhUBcu6TflW01CdtZFLeD1Cab4S8z+TpBaRizWjnPBisjotNY2dUwwYoCvBQBG6ONjHUDzTfxp704I3w1RAqiplgoayD2mI/veSLnb8dI7dY+4PlAoj9BEcMjPZTIZ9+0z2pw3retjnd0RG8egMHePo0J9p6ZXHE+eZ4UePSXi4fwzoB/gLNqrHZr65eOHs7LrNQCMo406v66BTYq0XVf0zusRBHN4pFRLgkmiC53rVFWdwl1p9zjhBV8zR9JdEggtwiz7pt1zgAMOhaCM7LRbUjmwXMO66zG+AtETcauUeNxutft0Atox8ytbJiv/MQpRnpFqORlb1zhHx43rkU99bjsbctkZmMpmdVrO0hwElRfZAYmfspjG7HDDW0HPyk7qC2q/n+5HJOtKcVJsl3ynEMyvMF8GQpVJX/WmL11FrwrqmaY4dH4/mG2HQhbSJVvimQ88NY3EJdMuozoIBt7Iyl/mdM/nCHOd9stGrM5jyUm28AKxy1cG1TGuREdg9Lzx/yoV8hQVHawls7c6y62NiCpl7feoE/FeDHkBRE7Dg2+MSx+FyEIS479FSKXCnPBDKsq798fynxeDrQ7OCL3MfX0h2tneitbPTnLuRGW6hEEt
 584sqlw/
 cKT9uqDNxSQqqMtOK8b0zxRpEXhU55jWjVCxv+LmdQwfVpcoaIjwXyiCGtm5MGsnaS6yIhYLPlxwN5QOAvgMZ+H+LOO39yNPGkEEfx+xOBTuMjKaAxd7C1TTh50r0LGacvOc1ajlrKqO3iZ3QuDmTODHI989p85QRatAFejmmBFycravHErzrGms7Gd8sen9rzweFoC/CbI06vQHqpz9BMRmBv4GQoa2NqW53+khtJCerP3L8L5WdIty55U0IYW2mz3laR6EmnpKImqisE8ncktWceMY/EJd4XFaQJ8BEE9cOcoGMhb25hPUO56NJyG8AnW2xYOaV2g+tKDwYlt7b2HkiKby18wy9Xj74f38UXeAOstWuNyF09fw6F+ZxVQpl/jZGKx+/INCS2j6zG/WbPDM36wGPNvZhWIRfNjJ9cHxIwsjx7F7lvaOI9eqnozY+ZG59QOeU/UBuMQfphXutbINEvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--ORVk8nI4MBGvkiv/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 12, 2026 at 01:14:01PM +0000, Yeoreum Yun wrote:
> On Thu, Nov 12, 2026 at 01:02:16PM +0000, Mark Brown wrote:

> > Possibly just have one before writing TCR2_EL1 rather than for each of
> > the indvididual features, that's harder to mess up?

> I'm not sure that's necessarily better, as we'd end up executing an isb()
> even when POE or other features aren't enabled.
> Wouldn't it be better to execute an isb() only when needed?

OTOH it seemed like we'd repeatedly omitted them where we needed them,
and we'd end up issuing multiple barriers this way.  But Kevin pointed
out that the second one needs to be where it is anyway so it doesn't
matter.

--ORVk8nI4MBGvkiv/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmr1yIgACgkQJNaLcl1U
h9AwXwf+NHY6AAbg8csFjXrZMuDQdUMboaJkVfC+Hn1q5Gsm/gt8SqmjIwUM0/R3
MBiR8arflazFuvWDuOyqikdvaaggIetDiefUXzhSqBmVdUZSP5znX/cGchB3ATHU
r9jz5IaIKvtxnWr+m3uCzKwQgjqCSsq5uDNirluS7voueb/fqJG9Ff99KsgujR99
ush3ACE4LSyOZc7fOAr2h73OsMxJE9HG2pT4Qn45Bngd3yW4+kKaB4q8oWwin8nj
Pc2uX+vfLnh8hRLAbDxc1EOt5vLd+ws+QGxlneaX8NBf56pZWPWra4vvfJIVIqID
Fv8s1/jFofx3Fe/o4LjSia4hffneCg==
=1AlE
-----END PGP SIGNATURE-----

--ORVk8nI4MBGvkiv/--

