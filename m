Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B404CD35171
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159966B0005; Wed,  1 Apr 2026 07:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B396B0088; Wed,  1 Apr 2026 07:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C7A6B0089; Wed,  1 Apr 2026 07:03:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE7786B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:03:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A4DF8C40D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:03:19 +0000 (UTC)
X-FDA: 84609700518.14.BF134C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AAFB84000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:03:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aL0b4Yew;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775041397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG6gQ6hK/FU5RPpY0YrGT9hhOChh46naoft2NCoqvAw=;
	b=WP+mi2wUWIDWG0uKWADXIJvtUvDmNWhdPtAUQ8IDo2xlQIU6N6FJw1cQpL5Os0FHN65ahU
	TLWQEuOdaUAg6ctCx69HSllgtAUvyl/dA9GNAnW9t6fjnV7g9j09XhptTrQFPy2g0Tds+U
	UB6jCdOltlqObxL6UWdZprJMeYp6VJM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aL0b4Yew;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775041397; a=rsa-sha256;
	cv=none;
	b=SuaegIPEC+fuCaeBQaxjU40Pm5RUfa3mcfZJtn3KIICop4VLtWA5yhfXD9nuPxxVRIwXvx
	L/v1ESNhKgsF23vCYf7qKM0dbbJVFqR/8C8eMOfXmNF/v6VojCWgZh7qMrIay9yw+GRMfp
	StdukV06AB/YwB2VgE55c6TEvNP4cYA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7A7840888;
	Wed,  1 Apr 2026 11:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503AEC2BC9E;
	Wed,  1 Apr 2026 11:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775041396;
	bh=RH/XYoy0u1GXxuioMWBp+5tj4HkPtd9OVS7rZ8jnj3o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aL0b4YewS9hzxKIWWcxGghBZ3HN/cCZSjanrVtgvlJnUT97WpPDMbDKAHUq+C0NXs
	 g+ZioF+/oNv5M4DuW4ATayCcgkynj3WLHv8UBeNdhzBxM7x4F7Ie/0avlygPhWhPfZ
	 IYIowM15pgSBEFAjHjp37HOhMGdpPuOWEdvALeM4QGttnedLuBvMbF6om9+6RIAaWp
	 aZ4BsckZdUURf/oE1Tqg57dEFEczBoA6wUwVvJa30XjAzXhojNz+2MHORCYlSpXlFw
	 oAwTrTNGRq14AEuKy4I3DbhJd5Gbo59PwXm2+UJsRgooPh9jkTMyhHlteRdLbzPPyo
	 oLdnFyv6xgRmA==
Date: Wed, 1 Apr 2026 12:03:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH v7 4/7] selftests: ksft_exit_fail_perror: support printf
 style arguments
Message-ID: <efbad6c5-8d5e-4774-8d0a-d455e6e2c182@sirena.org.uk>
References: <20260330151503.670415-1-chuhu@redhat.com>
 <20260330151503.670415-5-chuhu@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xo4ND846i3VDr5Tk"
Content-Disposition: inline
In-Reply-To: <20260330151503.670415-5-chuhu@redhat.com>
X-Cookie: You will be divorced within a year.
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAFB84000F
X-Stat-Signature: ewfwbuzfbcy3z63iwfphheqpgkzspemj
X-Rspam-User: 
X-HE-Tag: 1775041397-803475
X-HE-Meta: U2FsdGVkX19ra4ZnTo26xpaUEScfY8rQBqcDbcdeKacp4B+XtRr2uEemleIV8L7qSNm0a4cjnR8G4WwaxrTOrkhGFjopp6glsdGK9Pw6Ze5ePpffuosK75pbypmXEJ3Jg3BxNoYDSRyW2UWedKvsyXQ1ccVqvFQWH1pnt7k7HExeMGkLZRiSNeIYMTDt57zwXlg9nkdu1cfx2iGfpK0bTNyIoipai7e7fpLnzQrYAT5hH191df4TFekdGipUVeMX4uROOpUh0hsj450O9os7NSOi6w+IfgagvHXafNx7puW76NngRxoqr4SMgqvvKC9bfKb5OSnIm+Eyc000voq6xUPFgpHCTGHR3UKUe6C51pTFqaefWbVUW5fPUIlFnV2LsaSWk7LI1BIyX4fLdNms838r4Clb8cFxKj6ixAxH4YhggfiRr0fEEaXizNiZa1Kbyly8vX/4lmIuPnGGmjzZMQ1N7KMyUgO8q/m+CP2e25TaKCL22SNXrLaKjMTx3HhxTGGRBIK913tMUaQBq/rKaOl3MpBFiIS1EchR0/cmZDF6EgZpwSEQcLR53DTYzYIqHpbb3mgYOttkOPm+8Rq2Z+oaHO2XZ2gUoz/p5foP6WDpHjl6lCLjQJG9OSaGXFxZr5eOlOulaNVJ5YSuJRZ7GfgIwQJsqNXTg60d+uMFDAZr2Mes0IOPxynQ9x+39HCzfFbg8J4FhEEu0E186sSssJz3W+OCmNpLdRZK3yFCc0fEzsKPLoJFwHAZ4mqVBo1cOrQS+z+mAtHpluCOS84ccWtLBJ35MyYhflEQHZ7p/zrNfTMUGEqt0gkBRG5vKfL6RypjBJANAVF+PvbDcAAr0HUXFuHN87YQ6eYvlXLrm4Z+uvR0ECP5IgPElWQNLkcLvpEUccf6EI1qTCFJGyJm1oaxmzHV7Q/ozc7WenWJoxkcHEJGwqLi2ud7rxHrKiS0Xvu4+TRkLp+t3q2F5Gk
 7kX8M+sU
 zu/eklhomu44gYiEGkzL5QnAQEpWGUiT/OB6JQ3Kw/RG1qjwfd3T0jloHBe9kZ5u6C+WRJDAAU+iJMMMzwJ4f4dMTFQJ36b+fYL5VH5kEi8S/C5G4NUIC8y/F400A+M1sf7egdhfL4Ef3Lx1RMySiAEfva48Ay7rzwOKpxsFmEPRL0onuNQ6kf8f5Bkk6Ytq2lypNxvnwByfjHTUzxARUchUihXl4m7zw4d+KNeIZMUlgjWH1R19+BvBq1mFE01gAqf25kR5bk1UzzJrbTaZ5Wr+NcrDBthlrJ32NRlhMBZ4v/teR1iR338g0l85XYYeSgnl5SSTQMajeaXw3FNYGwg2157KsMr8kYdOXDEsqXDvMG6g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xo4ND846i3VDr5Tk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 30, 2026 at 11:15:00PM +0800, Chunyu Hu wrote:

> The ksft_exit_fail_perror function previously only accepted a single stri=
ng
> argument, which limited its flexibility for providing specific context to
> failure messages.

> This change updates ksft_exit_fail_perror to support variable arguments,
> similar to ksft_exit_fail_msg.  Adding the __printf(1, 2) attribute enabl=
es
> compile-time checking for format string correctness.

This is causing build regressions on the arm64 selftests:

/arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fo=
rk
In file included from za-fork.c:12:
=2E./../kselftest.h: In function =E2=80=98ksft_exit_fail_perror=E2=80=99:
=2E./../kselftest.h:427:13: error: implicit declaration of function =E2=80=
=98vasprintf=E2=80=99; d
id you mean =E2=80=98vsprintf=E2=80=99? [-Wimplicit-function-declaration]
  427 |         if (vasprintf(&buf, msg, args) =3D=3D -1) {
      |             ^~~~~~~~~
      |             vsprintf

This is because za-fork uses nolibc which does not implement
vasprintf().

I need to look at why this managed to pass the build testing I do in
-next...

--xo4ND846i3VDr5Tk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnM+2wACgkQJNaLcl1U
h9DE3gf8CyPPY0cS+fjVRrHslaPRCSHlXcW6VZnznjdKtRRFlBifghOePoiIZseN
By2f9+ZvZfElAWGMr2QgC+2AUkCgAzFJDJsjQNgxqy8yScuJ4zrp+qa49YUFVwiP
cgd8uDlzCskr9Uaqoo7dRegP7st74Kr2ZPVtGi+yaOh/aDZ9CD9L7pHG3cU2Olcd
lmRbjWNYIa7k471RVQTxC8FPWj2X0kY6X8DCB44BeqkWKnw1XgFZF8Y7HlboK5VM
RIS+ggqHuTJ3zOJiGmAalwCcNL9Pdj83axrLHW2EX2x1EEaVxV9spK1cdVDA8J6x
P2wbQfL9yT2Awy/9KJDfVxAfeQTuIA==
=Z1lx
-----END PGP SIGNATURE-----

--xo4ND846i3VDr5Tk--

