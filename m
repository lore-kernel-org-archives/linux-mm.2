Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C07ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BBE8E000D; Mon, 10 Nov 2025 17:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13538E0002; Mon, 10 Nov 2025 17:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E502F8E000D; Mon, 10 Nov 2025 17:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D78258E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:06:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FD5C1602C4
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:06:16 +0000 (UTC)
X-FDA: 84096081552.04.9EE1EBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E414A180017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:06:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHwNLLb9;
	spf=pass (imf16.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762812374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KXeH3/uTHfjs7py72mbLcfnFF0AsZpw/ev0frVNIdb8=;
	b=stbnMDuyxKQDa6TEHSvQzih0QHDPjQPUfmxcmDrrxyRfbI3jO18ZAAektsW9TbHMGZL6Zb
	Ks0fJ1DFk5TVk0jCG/Z7LWORI7K2mRYCuTrUa7O0TaSeXe9B9LpTgpb9mc/jSQ7oAHf+oJ
	oKUMYe9U1r3aMQKbqQnlOYzGhtH155Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762812375; a=rsa-sha256;
	cv=none;
	b=Qo8mVJBK+fIEgdMrUMD3UhqJw4rKFdw28FWdHFdu7PId1KceaV1cNPD7ZQarvluIJK2Gi8
	f0/wXg4HiOX2spHDN4Efw0cC7P8CBvoqedT8FxRjQcsLiH08Aw96pDPkeHCV+T3jH+vYl+
	onuVM5k+TPQPqobWG3a+cHjlr526M0c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YHwNLLb9;
	spf=pass (imf16.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 398E660145;
	Mon, 10 Nov 2025 22:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B1DC19424;
	Mon, 10 Nov 2025 22:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762812373;
	bh=ANbHoAoxXFqFOwqzSzLfvjdSSMJWajzcDa95+kDS2s4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YHwNLLb9zWuTURbZGIRD48rB/Di+bP62dlO9Tg4mblA7Cbrptfo5W832oIEwE2aqV
	 BQp2jZtEpMKH+cOnCAZRPKnI4PG9Rg9H1KQ4U0xpMVUtja3fRru5m+VQAHUbTSVvOj
	 qt45nJ0KxrsNpFIPUSJ1J/vERRVZ5INczOA7vaMMWEWARr1lHrpd+mPldP3U95b+Ql
	 vojHRk0K9uFFeli/VQ/KOkQsmkeD+mbdbpYdQPB+/h/LrAIbxB/I8jfbbX4st4lQ50
	 8clcY5KfY1AxZOfPXuHbp/B6UYSspc941HtKxg5p2uxIE3PO3cc5JjC+Jy4lBQQjuq
	 Vawpzf2lSDAcA==
Date: Mon, 10 Nov 2025 23:06:08 +0100
From: Alejandro Colomar <alx@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Marco Elver <elver@google.com>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michal Hocko <mhocko@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
Message-ID: <6vzrgu2gei2g2445cuwod37gmxz3zejnhegrqseymb6gofydum@agw3bgic3v52>
References: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
 <202511110100.9uPtQqN1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="spgz4wpgupnke5j7"
Content-Disposition: inline
In-Reply-To: <202511110100.9uPtQqN1-lkp@intel.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E414A180017
X-Stat-Signature: hjm8gx3mwwkcuun5fqhbiji5e6bixqpj
X-HE-Tag: 1762812374-331145
X-HE-Meta: U2FsdGVkX18GXeahhtjwOEU3WgWHVKa2KiTa7d2MR3jXKDD3uNRXamLY+k7TqTVsJlxrAoOWJ5R8kNjHHxXF5H+6IOCYySQbCfTMa2eqE2OhF8TL1L9JoQ63AO3PHGHlQBekZoPfjzg0EuUnhxgtImebCCUEemRbtWdVZzamv5eL934g8/Fg+VUJIc0RQFcZ5HiWyNia5DFV1ySTgiHl3aYqsflikBHADeUlxsk5u7PQPtWBdX6ocVrX1hiZPFcvQg9I2kexYrnT5bdQ95uX+aH0D+bAdWxhevdqoJXIj6chZBnztgYh8qo5iTGQcYsYNrRIE7OMogpVr0Ji5rHvW2ibVwEIffutLIV5HPaS8fgIy6VKtec8/B8ccMHyKyZhzBliORL0obZ/W6DRcSQ6h8W8XPPRdHLxFwl0xxR0QT7pKJSafJoC0pmBHy/L4vH3Z2jI950HGt8YcvlVdYrHlrrF1WyiFeL4OZstyJPboHkISrzniBnpPPtComw0DFgnXYVqiqM7k1SYtESLLT627+IbFoWvaR15685/PY+ogZFljB7cADRvZiU3jU3yyo2VoclyQ5k0PCFiUidlCCaT7siEBNt+SDQlbqw5MTw7YBEtEckFlxDMaqfdZ/YOpbGiiHx7PsBDO2kNhdCGlf6Lb9jSvhBQXwXZXZ00BovXO3gyyMBklau5uF1Uv9Hd9XFlEwHxXuO+MJfQpFf6JrsztRpU325D1QlnqmiGUEjvcy8smFzOzGDxEn1GlqwgI/5RNGlgkicgnIba/MXNgeKtxuopOPXBa3OjBMCRyNOQFkVKjDGEYhjWQAyvN+fNyU9svnjdgsjVxmHhVSboYm1yG/yhIkK6g8MbUGVDOvFWF3TuRxu/StykDiV14b+yceVU+GMZH1+uACepiDINcufLmOF3999GaE3IqeWVXeMNdnqoWK1zn5Ot8nhDAKMU6g77eOd+bZfBEIaagArQ23w
 DgzFtSiR
 AZxZvPqB7BOBSQHIsOCRxk6hy74ob+hlzI0HknWyyWhZEuiNya78I/6uAJbUrzBBfiCiFJoHCot0SkHtXFTQ5uYIXHSp4U1CnPbRZh4gxlttCw6PBTkLtGmvPLM6a1Z/pxJkj/v14SgUjHFQEhVuB4nmZXBl1lrlU4xm8Rw9M6n5/+qJzacEUH/UP0B1W89ief4GB/MRRTY2aovOPj9z03wjQzJEgZmq6PbuIsvNfFKK1/9T48AtlgvBeCS+0nbBZScMUiYuZ/GsHXqzpJZN9SxRy9BlXClg+dgc6ObBN21Zd2A2SQgavWs87zWqS5oku51AIEzPFc1jYxrpjltD/xUJjfuXvi5eI7klgpyHnd/EOYI/ufr8w3KP7euG63T5eb3Q6aTG+op3S5nBHyEoDKeIRPlFkfXTVExZ08ufo0jphkGv0+kI/N0nmeniGpizPyudP6MXygQMyx8o8XYc+qswkCgMuC/hEc+Xe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--spgz4wpgupnke5j7
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, Marco Elver <elver@google.com>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michal Hocko <mhocko@suse.com>, 
	Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v1 2/3] mm: Fix benign off-by-one bugs
Message-ID: <6vzrgu2gei2g2445cuwod37gmxz3zejnhegrqseymb6gofydum@agw3bgic3v52>
References: <87445e701574058b142e036c3b8a0f505086ab64.1758806023.git.alx@kernel.org>
 <202511110100.9uPtQqN1-lkp@intel.com>
MIME-Version: 1.0
In-Reply-To: <202511110100.9uPtQqN1-lkp@intel.com>

Hi,

On Tue, Nov 11, 2025 at 01:47:19AM +0800, kernel test robot wrote:
> kernel test robot noticed the following build errors:

[...]

> >> mm/kfence/kfence_test.c:113:8: error: call to undeclared function 'END=
OF'; ISO C99 and later do not support implicit function declarations [-Wimp=
licit-function-declaration]
>      113 |         end =3D ENDOF(expect[0]);
>          |               ^
> >> mm/kfence/kfence_test.c:113:6: error: incompatible integer to pointer =
conversion assigning to 'const char *' from 'int' [-Wint-conversion]
>      113 |         end =3D ENDOF(expect[0]);
>          |             ^ ~~~~~~~~~~~~~~~~
>    mm/kfence/kfence_test.c:143:6: error: incompatible integer to pointer =
conversion assigning to 'const char *' from 'int' [-Wint-conversion]
>      143 |         end =3D ENDOF(expect[1]);
>          |             ^ ~~~~~~~~~~~~~~~~
>    3 errors generated.

I'm pretty sure I tested this some months ago.  I'll test again...


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>
Use port 80 (that is, <...:80/>).

--spgz4wpgupnke5j7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkSYckACgkQ64mZXMKQ
wqmJCQ/+JJ2uBd3GqMbPFAmeC+dhFJE0AjE6nWO7TvCPfIJRmNhY6MfqRWqVH4Lv
fM5+eLBctHCg42qsiN4tbMPfnQzL3KmXomqza7VW79aUDtTrHPTSd16HH43jlOiX
5PzfxVGkVEO3bK9ABpHu6LQpcNJY9C7hsAcX5QSA8evg2YCRO51XgoG5Y8OpYBAX
s7hm2VSassXxPTpcPcJ1SXeXfq6oC0CkF+ZCr/a+PfpyWTHtJEBkcxDiqCSB9Aur
1HIBIzggzAS1OgeDY3L5iNIPYW3js+2P3ROSL3OffA/cgZ/cqR8iWmRs/VBqVyXn
knPLFrT6qrznvPQdbSm0IO5njxAJAkO6C2KwnvIlZd4KX0qbhlb1vR8OgGhJXdVH
r7C5+1OWGAvb/62+Bl3Tea7kFxr1jzN2MKW2Jwt/ao1e2rvCnnanHhvtsfE2x7Mu
JTb048s4EmnqenWqK8l+KfQdmw+SMQBIGMpBI0e0AnZ+yGeceWZ7nZdIvI2neDKa
bM30oIXekTNxuMRxGqoQSb7E0PCpK+/ozxuOkM7xnU2RYsv9+v5dXetWmKaXMxAd
Av35yX6RRaSca2tKpWj4DkaLqvrOCtDuyscryk9fY/qxwP/ELG0Yw6ebctmDPPFT
kXrvRSuvWv6AvE9JlWSG+MH490uxGWkqBYHrrIJKSKVHZy68HJk=
=5BWZ
-----END PGP SIGNATURE-----

--spgz4wpgupnke5j7--

