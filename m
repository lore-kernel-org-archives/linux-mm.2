Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E5FFD0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39E96B0092; Wed,  7 Jan 2026 11:59:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD4F6B0095; Wed,  7 Jan 2026 11:59:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0696B0096; Wed,  7 Jan 2026 11:59:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C87F46B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:59:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C17516047F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:59:37 +0000 (UTC)
X-FDA: 84305779194.01.F86A4D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A0FB120003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:59:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLtdKPjD;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767805175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwEX46v431f+sbGo5EqxgnUwfzroRLeV1erewYphpFo=;
	b=N7U79Hmb/pxYW9QGb50Ul3Zqw8EsZxffgW5EreSOQToE4prG2UtBSEkdkwRWfitLH9istU
	N0GqaLc75s1kT0lNSWG8VvIcQnSzdRLoeRxq86bLXWywEQk8Bw/NwXMwZvpFUfoBnMAXia
	9AldFh8Fn9GLr2/MtCdJATyWAUWW7iA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767805175; a=rsa-sha256;
	cv=none;
	b=pJVbDC4SWBXVuJ+J9zPGtawLXFNQjcYJBvMqXUvv4gZJnu6yaTDSKGb9ZgJnRr2QefGNhK
	ACGVV7zAIzcifF3sBjRFeyF37WTROkdwtJkgWI5dzr2Zqg6gwbJTDrAjuYFvECMhAVhFNP
	66Rvj8OaEUE83/F9UxThcGcrZwRwDoI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SLtdKPjD;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 893A360018;
	Wed,  7 Jan 2026 16:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FABC19422;
	Wed,  7 Jan 2026 16:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767805174;
	bh=HwEX46v431f+sbGo5EqxgnUwfzroRLeV1erewYphpFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SLtdKPjDsjq3CIydu0nCMpF4xRX3a55iYS+c9WgEvIR/u6j3EKWGkGLeLWRiajwpS
	 H6u1dCYqeZPV1/Ux2QI8IdGPfJuejyK9Mt0fTfD/JeNjo7JHyp3pzzLFeNN4ks5XZ5
	 7vWfdHNcpXdGvYSU9u65pPhUzx1omRJREpdghlBG+Q25jcki5mYF0ytTjZrPFnEXtT
	 FNW+qmTeHDbLxEgNbxQ6J/z53F1JwlmkXotfuFM2Wm1oTLUffAm4FwXJMd/QQYf5J8
	 MLQYMW3L7Et0Rjy3GA2p/FA8V315OhSzmnnSFop+/ETv3A0XHAt8hIHXTGGO9EUGQk
	 zCntVNjC0MKaA==
Date: Wed, 7 Jan 2026 16:59:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH v2 3/8] selftests/mm: pass down full CC and CFLAGS to
 check_config.sh
Message-ID: <b7458982-ec26-4057-bd4c-0609d177ae32@sirena.org.uk>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-4-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rXNMserVLWCKQhmh"
Content-Disposition: inline
In-Reply-To: <20260107164842.3289559-4-kevin.brodsky@arm.com>
X-Cookie: Truth is free, but information costs.
X-Stat-Signature: somyyihc7n9g1zk1mbigmar6m5cmdw1t
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0FB120003
X-Rspam-User: 
X-HE-Tag: 1767805175-578211
X-HE-Meta: U2FsdGVkX1/BSAdezH0WYyRvDGGmpAroXekK7/+bdC7JS/kZWsDO2lDMnCyYLpJ47PFOJS+jHrAxPfhUvDMmRTz+fixOs2pleCEsQnKZRG4UU4ZCQ+jWWM9bqFmFQNJeur9nrCJDe+3nOTkofELGmmpSmGT3RyuZcBV0QJdGGknosvJJYm1dFpaG0g0M1Tn0IYfVxBq8pC+v3sEih9E0LgtQJLim7DeIeHuvmqg2zO4d7RyZ+jn6pQiZ/pHVfAeaRyFmw4rcQtGQ2aBMp/XGpb8J/aKkkQoyDer0bcDo+48dhqe8TNq/N6aOjDVTLDsNjnQKUtgb+MFPlIqkZyM9Ji0HURZlBkq5ncRmaTbmb/ZwJi+04i7hGHkp2IoLJJRw1GMgz8Hz90L10LNj0ys9KAvz9+QpUnruGzgD7okFD92dF3lcU1LHFNhPxigjSgflpSTArFlaZ3drL0T7UYc3oNzVPkoUYKKLsuWMS+KYp2kgUu3JW+p6yT+oCvmyXRC+/7gM3ThkxLwDT2YVVM3UzVOuDnoSQcBPzqwLgYp3cp5sSZtdRlaiP13W9RI2OT8sWhh9ZkYegBxFzJspPAA8pa3XztF2Cw32kxmG8tVddcBoOCpW5jbDvuAvKmgzc4v9ZpgM0U0PL2H1l6ih5P+NYp532ih4Saw+YgBGI2LcFg67tatIMa1fsZ4ExSkYUBwpvNLPTlHQYqeyHUFegK09dTOCRL+b/z1LIPuWYGXIWUf0ve0A5x5qNBKgdi2HgVkEoT8KxpYpaJn2W31UVIlLTGSKTJ1N6Ulaq+sMdwYL4FmCLwczOPVsCEYZDZ0wB+EBsNzETVMR/saof9QEbMqJ9IHE8Wzm9IjBc5R4N91Tuunr/wccdb7/owIHuOV2QB3JwWfPlojPodecVkDDTRauzfYURpfO2s06wy3ueSVV+A/44gmSGrOzEOt8omLgZKkZtfiE+0m3qzn1y2wdNVM
 RLuWvuKU
 Yk+5j9zim3jyshBjFI/t1Nk3QPxJE0MbApGlcKeCfbOhNUUObmZ32Bq3MvGS0EvPNCwUpzpFs+FoAN42F/XwEt2JpRwNFKbA8CRpD16Q3g0ct08IiW4mVbuqwAaFe9yRk6yKCr7bwSYthOrGtYT052JwifSfgf+JY23VRQhvwGVpEt7PRr0MpGacuf06xwGHP4WFbWn5U+TYVHmc8DgmwSvF1Vl02OaqmJf2eVELS49sOLjGT6FjC3i6F9fGNHb/+Vjho6H/t3qFhY4JLCtobZRpG4FpeUBvgOdypJk/hirsm/fBdljMImHysVdJajmpFBdpQAnA9NRhc1PX6XMff7xBezvKnEH2tsNMShh6ui++bAYBfR+mD2bFMPv19CYiuVY/zaEqHX+RTB9R4h0H4XAcZcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rXNMserVLWCKQhmh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2026 at 04:48:37PM +0000, Kevin Brodsky wrote:

> Remove these assumptions by passing down CC and CFLAGS as-is from
> the Makefile, so that the same command line is used as when actually
> building the tests.

Reviewed-by: Mark Brown <broonie@kernel.org>

--rXNMserVLWCKQhmh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlekPAACgkQJNaLcl1U
h9BHWwf+J+x1LLkKhs/euNG82nQXegO3caN5yRTlLIM1Nc8Kq0ZrA0Y6sBNrwZc5
SlSYRizBioqJS1iLS47DopU7DG3+woAKh3opxwBfAk23aixyD2dLEqXFmgy0z0Un
BwEVHQerLkh8Ogi2GAxr+sqPedN0WEr1GbSY3VfTG1qYiNW3SG5+0AJ6qtSiToIi
830xiMgDyxn0GD+jS+sY3U+wgMfUF6T9Kwu3X/24LQTRKGUCjBMKxDK1j+5j4QuM
I+23PU1qoMHlTDxAphGaXijY0owBT8rJZEy6pF+B81W+Ww0mFD7butnAUrubBePh
JOG0zO8+G59kVsPNgqaeDi7Zt7UXRw==
=PiEC
-----END PGP SIGNATURE-----

--rXNMserVLWCKQhmh--

