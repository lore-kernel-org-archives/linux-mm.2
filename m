Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AEC0D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 10:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FE26B0089; Wed, 17 Dec 2025 05:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6C36B008A; Wed, 17 Dec 2025 05:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7101A6B0092; Wed, 17 Dec 2025 05:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9156B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:08:52 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE6B66048F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:08:51 +0000 (UTC)
X-FDA: 84228539262.15.344B2C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E744180008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:08:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxaavKtF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765966130; a=rsa-sha256;
	cv=none;
	b=R1eeq5CwZNTZsHBjQjJeGbKMs9nPy2D3dqspxwumfZn522WvULaY38GN3E8H7CiNIYWPPU
	BvjDHDELWUT/zLyitSa8LMX2KPEiaMuHzhxpgsso+IRem60b4tT/UYgUgoiQg2dAM360Sv
	HdlFC6urX57+RWhUW5ZkABl1zrZh8BE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxaavKtF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765966130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMLprEfUUGCVk4XSwnWAvcLkbEiN7vzHKrHVkwiStdk=;
	b=Dh6hEgS6SBEUdXNNnnfuQcZYuV6j4PJvyNdWSWuAqcveYVcphsEIDI1swStrf0axhR89LY
	M/SfjlJn47WrPkW/HYsMRxUq4HmF0Q8aYaCsfrkLWm9BXX9xAkMZEQRGCe0mRGubjZitug
	nOGy/wkoBqkqFDw0fCX24O0zQuydARs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CAAF436E9;
	Wed, 17 Dec 2025 10:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD105C116B1;
	Wed, 17 Dec 2025 10:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765966129;
	bh=X8MKDeUVfw3OZB5ABjVJIvLfdbW93JOXK+rfZHGoMJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bxaavKtFFcBhvYnzUKNDaDYeYryHGC/WzcqZ79C4+IcZBzCcExa5KinVQzCFGxbxM
	 gU8EJc6W3luQ6eYl1+TIft06Qr2FLagp96N8FIDE8lHKoMKkfe8KwqcBnAmanA9Dsg
	 ZlYqcL0SGWifCHB9376NHx3x4FVpvpYqURlZbE/9vZSRFkGTV11Y56axnHy4gSIwpv
	 nUnHMfI3hLuFHFqfkkrX7jxWZwxWydSyDdIM1EPp4Xmhm0Kf0oOuhA/lVog/dAz8rl
	 8CnXIdHSbZK8WaJjEJUymbn/Vsm6h9Wt+sOW6waaxLQ2qEomXqkr46ilgMZef3ZgQi
	 zxjmBKcerudxQ==
Date: Wed, 17 Dec 2025 10:08:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: Re: [PATCH 4/4] selftests/mm: fix exit code in pagemap_ioctl
Message-ID: <67e61dd6-2a44-42f5-980e-e9196d672540@sirena.org.uk>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-5-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="t/5ZkYiwUFTRW9SY"
Content-Disposition: inline
In-Reply-To: <20251216142633.2401447-5-kevin.brodsky@arm.com>
X-Cookie: To err is human, to moo bovine.
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E744180008
X-Stat-Signature: 9jbfmxdabsy9ouar33nd8gjt3bn4wnw9
X-HE-Tag: 1765966130-685143
X-HE-Meta: U2FsdGVkX1/8KyXASNwfiOtRJEPWLUdyRMBW1J5T/o03ymbDdWnn9+vJui76MMOE7yrCuxquTVSgMiGQSoXh51WuzBGFuAxD6NFei071jVZTpabfmpsypSDwCuEfnIoEetFtieZIHvcXxwn3qcKFCypK1A5ixqT5xYBq02WpdA0OVWv5qfe4YU6L5rIyq6VhUsm/itUUTtndmcSHECzuVxsIIXtPWc45s9GscnQdO9C39yJz3ejXbcaYw6fG60hT/JDCnwicSKpO0iZ+K4oJCXB0G3/KnsYUKZqJHbx4RAG5pKbz8zNgZOSx8mGiP9SjvMginpkucSBdcRrgmE0olPH/RQxPIJDoD0tP95XBHmSk1ed869FJMKPC+59wtiINQ/9YifpGgZuowGOZ2KsFfo0hF758Og+c0F1ZD01DlTSv1Pyplly2fwURro8dOkAO4ob/ZtB4OIZtClwpznGZRhlCYf32Hahrjqi5snG76azXOobTs5aPdO2OrbLfiWs4s0M1N0syQImOA4LLmVN9PTiAgOIIeQJMlNhAjbGddIWFE1ZsPduj63g6FIVzhFEbgX6QkTZbXE8O4P1VHPIpBZJoEAAAUSyW41hyX0MM5eqeGT4NEMjTjXI1n8nT7+u95vOP/ccTi/DGP+LPcdQb42mllw8d47mHH67kOhKBeX+xVpT+p5ard6nyV7nnzQ/5BDb/Gcl/4Eu6SDICEsB6/Amqf3ltbwhGgbQ4AnvDeVP1lYAKiylYWTq6rFZZfqWvDj2+X0cf3K4IGP56uW5cfxdYWU7pUJifPNbf0LdIwdsdC2gl3aE7nU4p5s2mJMPddTLmydJiv7Pmvo6Lu6gCX1cj8B47YAwWusLapu3Dgsi36F/blE9EHDXs10BOdomwV6Iy0NBfYPjjUZU+8cw3Vk29lf+7pEVLRACgcVz8AI9+ky8bmJwPXpdzflN59dyZRuN5aZVe6NS+acAS/mQ
 br4YrOrR
 VzYEonp8G85J2njU0M8vvPuRK7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--t/5ZkYiwUFTRW9SY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 16, 2025 at 02:26:33PM +0000, Kevin Brodsky wrote:
> pagemap_ioctl always reports success, whether the tests succeeded or
> not. Call ksft_finished() to report the right status.

> While at it also fix the exit code in unexpected situations:

This is a general sign that you should have muliple patches...

> - Report FAIL if we failed to open /proc/self/pagemap (returning
>   -EINVAL from main() is meaningless)

If you do a new version it's probably worth noting that this is a
non-optional feature introduced a long time ago so the open should never
fail.

Reviewed-by: Mark Brown <broonie@kernel.org>

--t/5ZkYiwUFTRW9SY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlCgSkACgkQJNaLcl1U
h9BIZAf8CjLi+jiPeYVUBYqds8b9OmmeB8XkCEyL0M5hPBsqY2/kDzeZimziH9XO
Qw/OC4nY9wuPBpB3oIXS9DepB+1FKfu52OCaMJvlTyyLoJ+cmCghU+SGM2/c8xAi
ATmIz1z4W1zOeh9BAordLtgA29AmuWbGZw7zUKVtTzKWxkh2ppHinT9KlnKuiQjO
PhwOMWhv0hQYjn8qE/xfZIyOljbebU8uPJ1/ic01NYZpfV02153XV5QlTiCTIBE+
4mBn13VFWVqA92WHd0OczoiRsLy/tgB/L8sGBmDV+0m5BvFU3mg6GfAsMUvQDcu4
S2+duB9Czrzwn4vcHQPd+xrCaaMFSw==
=g9QH
-----END PGP SIGNATURE-----

--t/5ZkYiwUFTRW9SY--

