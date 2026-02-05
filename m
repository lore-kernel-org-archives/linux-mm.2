Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D05EC1EA1
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:28:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10C66B0089; Thu,  5 Feb 2026 06:28:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE0D6B0092; Thu,  5 Feb 2026 06:28:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4576B0096; Thu,  5 Feb 2026 06:28:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF2A6B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:28:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A86F1A048B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:28:51 +0000 (UTC)
X-FDA: 84410180862.02.BA93987
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9BDA74000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:28:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ae/tFLNI";
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770290929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ir3rF+We/v/jeDeCoAQnTP2mNTyALL/4ipRHcYZSqOo=;
	b=MCFO4YKVhOhrxC9kBAiB7eCINytfmRB/geHhBykzg09JwjXXhSYklFlkSM3vIYERmWsUz3
	qJuQetqu4qJJMt8llTsVFrtoBWIYn+uxA7IulOetj1fqIuK21738vr3k7WAXdo3t68f9u9
	YqxN10Pg9TSlTfVYKK/MkXqVqgaNSj8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Ae/tFLNI";
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770290929; a=rsa-sha256;
	cv=none;
	b=k2Nokyz53k8zWrlde2uMUz1O5Sw2pBjTu/zIP9TZt+mGbitMfLCQNyaHgPQLIi2RVGbwRd
	WSidnla82aLEygTCuLU2tc8lfrKnxL0BnJECB+qeBysC4+pM2eo+OKDEsyc3/9aFBwyg9o
	e/l/+TTPQr0H3wrwpdSKmTxHW/jyBo8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 070FB60128;
	Thu,  5 Feb 2026 11:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064C0C4CEF7;
	Thu,  5 Feb 2026 11:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770290928;
	bh=Ir3rF+We/v/jeDeCoAQnTP2mNTyALL/4ipRHcYZSqOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ae/tFLNIlQiLcQz3w8qXISrY1vDad4PIFtdLksZwSB7zFP9q80c3+9IXI+0VB8hgr
	 rE0cvyT0qRDjhbRXKQOiKN4doIAm9GDkH8VF5ZfLLYnACC4ZAPRejDlDNxMMSVdeih
	 E0Pl2GXqay2Q/+j/PE92lgsCniVqfMUhqfT1PQxJ8yRFyB3JEzJe+W13+luQpKBN+p
	 wHjitr44gt44OO+2F5CI/YfTlZ3fXhw8BFnDO3X2uDi+Pz24er9rOOqXaFG5n/JUSk
	 f8tu25tEQVfOFn2DPZcN8gmCJ3o77GdmlggG4kuJd4ShLnPBBcEZP1DfOdXm/6JAaY
	 PwtHNcCi24CWA==
Date: Thu, 5 Feb 2026 11:28:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: akpm@linux-foundation.org, shuah@kernel.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	nao.horiguchi@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/3] selftests/mm: add memory failure anonymous page
 test
Message-ID: <73756615-b779-44b1-8ff5-b4b2d5e3c7cf@sirena.org.uk>
References: <20260204073331.899406-1-linmiaohe@huawei.com>
 <20260204073331.899406-2-linmiaohe@huawei.com>
 <2028f5e1-e032-4909-8240-15fe0b3c82a5@sirena.org.uk>
 <0a84104a-32e3-8518-ebc0-703814e233d4@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qmBBxdvcuvo1k9qE"
Content-Disposition: inline
In-Reply-To: <0a84104a-32e3-8518-ebc0-703814e233d4@huawei.com>
X-Cookie: Non-sequiturs make me eat lampshades.
X-Rspamd-Server: rspam12
X-Stat-Signature: 57tgq31fp8td5he93unoq5rzgbq7fuow
X-Rspamd-Queue-Id: 9BDA74000C
X-Rspam-User: 
X-HE-Tag: 1770290929-598552
X-HE-Meta: U2FsdGVkX18VopTom6E9KSM/yAwc+tQz1hFEXo5D46mFGXii9PTsSD7MgM+a4h8YbE93tTYQPg3O+pXQNcxUEHcuOS8SKyvILdSZqtr54fvOW6aNjacLEEw866cpmUMn5TXXHUaVq9u59ETotyCB2GOEriFnaOeyQP8UWicDkaf+GFO/ik+tyZa5MzuH8sZ+gB79CTw0xYPJ4We+qkgpw+Nz2qGNEFB3qyKpfByF0Y0Ah4GqL+lqNkjiSLqrzhb+bt8+5veIABkJ4GXQcC1JjHaLmGHdrlBrd+d2g/YIUOS47Ld8mW+Jg8jJGU3hPrz46mjQKjzGCNZgoF7PJ/kwq0ntsNZrzhdiV9XyHyKSu9b69pHvB0pboTtcplHoAAQYL42pfxT1V1MNveUS7R7nfDj1dJfUcJAH5VmonPRyEaJfhVlFMuNX7FK2FNJVPrs1gkanzFOsmocpQGV947YBPjRTnGahgq/FbytGDhaRbaa8MWdOQKgYgMklsV4FZrfVbkduFadGTn1/+tm6k+Kn7RTyZHu8wpgGSEuW8dLIiT+SRxscsvFMHKn1Jfb8da5sDIM/xKQDxhVAybSolng0hJjQHz3wU6uEynaCWOw/0rOd44Z++0srEaJm2kYQXo9QUxPXlk1OnvTKKbcpSD4dUjmfT3fm+dtUcWAcPrSUj8ifwZjj7yMyb2Pc8qgW1PrbKIZmp+6BNc6VqiVCK25Y+wTjAvmJxzScTmHAHxIU0nyQLKKIVvAla+b0JL85uJjftbTtgEimJM1qs7NT96uqZKkSfeuGaouQUQVNiuvqbu3k/Sj+xD2MOE34pOLMa5yNSSvdRwzRp8+hLwJQMn27Xr9J4lFCpMKcjaUuqK7HNRrQp2qg8h8yZcWIAwBcG+YRq+3MIUEXC7SRQoXcWak8T2eoX3U2AW0luQZRML/uihOmdaMK03BgJ2OMOP8pI2Xs/cTnAc54O00KWY5WxkS
 ruzjatCy
 yI1Mqr08damM+nchZKWEQvhOM8mFtdQV6lj2qzNG9jlUPJZYogsm7P/kCQtKn+bf1Zt+IbrTHyqvlNjYgKWhYtOBOupSwdVHcmYC2O25FBcXgApMHf0dgUO0qclkkA9awbCYz1ZzHIJiLrNcE+qN8CRJdhmwSf9Ry3Ta+tEyyky/foGQAxta90VguZz1hxvJwunEmLK/7J616ho6+lWS1VaEob0V0YUvOIdzYL3hC7pye7dZMeCFn1QK3EjT+QBBiSzXpJ7csb9kOL4diJQm1bekFnavAU/7G0jP1VYmuNDEy/W5IJTOCC3HnkOMK5KHbj9a80elB0MHdz9oYdCONJu6jYH35xWLbge82Y5jhEXKJsMXxMC/kqgupFvnEbtUAZU+0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qmBBxdvcuvo1k9qE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 05, 2026 at 02:58:50PM +0800, Miaohe Lin wrote:
> On 2026/2/4 19:26, Mark Brown wrote:

> > In -next I added a hack with wrapper scripts per category to improve the
> > integration of the mm selftests with the kselftest framework, could you
> > please wire things up into that, see:

> Sorry, I missed that. Do you mean adding something like below to run memory-failure test separately?

Yes, pretty much - I'd keep the list of TEST_PROGS sorted but otherwise
that's it.

--qmBBxdvcuvo1k9qE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmEfuoACgkQJNaLcl1U
h9CBBQf+PU/CcNHjF6foxK8v9Dc0VdDIgPTuJgv98j4HpNS1sFKDSmYY8E99jo1a
ri3Cfy+MwxIeD9KHMnk/wJPhFQh6NzhKLl80lR87yS9PUFTTwAg83Q7M+UDu3DUz
mL1vyDbo4yqmLiXDLcXvgRbTy3iVaUBXRO9iC8M8RbR6L31p08SuJKlIV+SbN8js
h3vptu7nIBLkJzWCMQM9hko9m150v/7I8uVif8SNKTO+AB/HFtUIs1413jOYEQ98
n4Tc9vP9beAxASPS1mbxmUXFMx7Dxea/9CMwIJliH5pprLXa2g1mBHdrZcVzZd6j
q74R/rofwXu0N928mS2XhwwX3PONOQ==
=FBpU
-----END PGP SIGNATURE-----

--qmBBxdvcuvo1k9qE--

