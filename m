Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C15FC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F426B00D5; Mon, 17 Aug 2026 09:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047876B00D9; Mon, 17 Aug 2026 09:43:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC90C6B00DB; Mon, 17 Aug 2026 09:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9FF46B00D5
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:43:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C6074079C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:43:52 +0000 (UTC)
X-FDA: 85110879504.25.97471AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA23020008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:43:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fv/2ZQO2";
	spf=pass (imf13.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786974230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8j64C5Yyragyhv7d/QskN0ZuZnf5SRudffh4XmLXgPA=;
	b=m5nCRDePFIDx9zX7pWB9xBv4flgeWqyyZKro9S2QEP6m6DDjBz3sXi0Kqb2cT/X9ClhCS8
	D1qfr4d7SzXzTaSLtVnfDKWokhuebFlMU2qPXO7HSZK6MfSpiTyiBV5nhHfVWvTcNCd1b+
	QpZlS/Nmu4hBp33+RIIeynXVYbso8Ac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786974230;
	b=psUe7eYHYQhoK/00k5MjqTRFfQAuwxEvuQjZY71LtYwjknskRxbPffM9knkCppP+BFFP9N
	71AizrFw+FsLd2o+in8hobRe8CCyD0rmYf+kWDfz69f+vAJmbbTCpUW6bhE4S96Irzp7dB
	GW5yBlEGe+evS/SW0T9mJaOcQ/W0Q70=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fv/2ZQO2";
	spf=pass (imf13.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 31AA3601FB;
	Mon, 17 Aug 2026 13:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568C61F000E9;
	Mon, 17 Aug 2026 13:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786974229;
	bh=8j64C5Yyragyhv7d/QskN0ZuZnf5SRudffh4XmLXgPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fv/2ZQO2uXpJGu70iBIjlFrOEwNQBIvY+cN3aEc2JQJrKV+/ppXEhMMg6yjqAuhiS
	 yYOURAkApSFpXkHNaJPfPRucCDWpND2puzfYvkMli9JkAzB4cOWaQWQRJqYw1NUFJq
	 6XhLHmI8oqZpN/A5IvpDkvd0dr6Ly/iH+rA0wWWDuPINNd3OEzxRjxbo1rBpd5GoNn
	 wLz0lZzAXZS0K2JUJ8/hcxSBD9MrgYiooRSwQPMLJXYY+rDSfU+g5959fVycDBNGSw
	 AvQmUh+g1ljr5NiMmQYqxQqPm7CkBqOQdmH+moxMHAuZXb7gl0uEos1Xg4mOXA9uSh
	 x4hqihPivcngA==
Date: Mon, 17 Aug 2026 15:43:44 +0200
From: Joel Granados <joel.granados@kernel.org>
To: Bradley Morgan <include@grrlz.net>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, shijianlin11@foxmail.com, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com
Subject: Re: [PATCH v2 3/4] sysctl: Disallow partial updates for erroneous
 sysctl vectors
Message-ID: <cwfpl5h47km6f35m5k7wa2pj3elciaax6i3nmetxcgws66qewq@fzygztolxed4>
References: <20260814-lklm-partial_ctlvec-v2-3-9df50d26e477@kernel.org>
 <3A4FCA2B-2F42-4E8F-A328-5C1BD658B2A8@grrlz.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xrhvwbqqqbh27ci5"
Content-Disposition: inline
In-Reply-To: <3A4FCA2B-2F42-4E8F-A328-5C1BD658B2A8@grrlz.net>
X-Rspam-User: 
X-Stat-Signature: egrucdkmmc65hgizoen8teg7uzd181y7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA23020008
X-HE-Tag: 1786974230-704931
X-HE-Meta: U2FsdGVkX1+9vDo0pBHSmodJFJDAePKZfcJgbC7R4wfvY74gZlQQVjJDgr+n5Z3QqOcNYCmJvLWb1i3+Sm4B05Q4ptwrThs5Ax+y6ZsynqqXimor1fz4SHqOg/kQ8hwqsxaVl32zs256CbeoPqW2nY8nu5o6/+jP/lGirG8dsbf5/SWALtJX8Efbz3Jvl2ac9ZglYoHIh2VJR8hOst7kd0Sje5DBJnqn8IRigAGU4DLzDNScGvyc4lahcezhQV960Dj4PxmhAEfgyn74PzivgL3nL4FYU0i5R2CJYx/vo80t6Z0mzdjnwgnVefeU6hTFTUJq4wxlxG27UZlaiCrGZQenC0cvJfudKtlvijHLKnB6/U5JcmiHaT+6F2ikeSaaxD8qBN9SwjgAw9KI8WxXcsGuRFYC/mtbD/dnK3VSsAhu9eDAXY4I4vTcfrob3kGdvV7ILOZLI3vYZTE9oNTgGoUVs0Q+ukwYNmHSIpdq4EpQON/T1ypzcYakgY3+gRMltLlZ35sYRyP4gbCfLQ17L5ERK4fjaH8prgmjfLpssNgAxbHozoGuzvLp9VKhwJ8z9B4jsOr+t1XugBNT+r0uRvTA3PmcA6qkKWgUFEcZ6I6zFpo5MRQbhE18e/cY4OushLqzkZTUy/wXiD2iLSksLLyOOrsHBGMFqRB/ykZ8Elh9JW+Wm3WwY4wzUbFukIyPRB7uUjMZJD6DfSnlPK56KY0XkBmtoTl8pHgADjt8jrd4b5ocP7EQB4ZUq6LgXSXM4fnniot9bJpLaVpc4cq67aWHj4kxIzdNtwB9tdkV363vN0y6zBbjhOhSj8T5YeMxNKeebe8T403Af3s1xVKUTCjunLQ7X+6fcttKzpEG04OXVVL0BToGGFj1zfDp4UX2yB/lCpE99C++Jhp6mw6tqVT/NieMQmz1ZaQ5NE9BBfoBsAq15BEzPEY0Tyzr0moO6aavuTEupbpQ7L/xVv1
 yv50JEiK
 A/Mfzc7Z4MEyk5z3+c4tDMALCSrGEhU0vsHLaD5lmqN+m+zdV39HvhP8viLbN65RC6+SiubgviRc/ngbYyqPcAK6HL5yH51s6Tg6bX9u4wr2vKbYammCn/P6PZA2cJeMS2uVt3usVlIovpeH+OSmdzxaD/9O4Y/vCEiNRcn54/6s62kYbkt+nByt2WRmSnA8/8Hvniiq244a93qMqnH1Nw+zkBP3Utz4dsrQy4cMDGyTqpQOUGLrU9F/sDtX/rwafJHhYZOotJUsk1XtT8y1ASMAbhANEYJu9Hk2cwzRsKTMkLWO6vtya+YRe3G5q2Ly3QN+CeavsRk9EcVUVisJ6ha04plUiJu8ra6SpMg8yhhZqZyg/q2exT5ON6cbX4IEQhIEH+JREna6K+ZCDC0PyB1oLV23/DHzeC8tT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xrhvwbqqqbh27ci5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15, 2026 at 05:05:26PM +0100, Bradley Morgan wrote:
> commit_conv_vec() writes the elements one by one, so a reader can
> still see a mix of old and new values while the loop runs. Same as
> before this series, so no regression, but the changelog could say
> this doesn't make the write atomic either. Otherwise someone later
> will expect the vector to change all at once.

Seems reasonable: here is what I added to the commit message:


"
=2E.. This (The staging vector) does **not** make the write atomic as a rea=
der
can still see a partially updated vector.

=2E..
"

Best

Joel

>=20
> The copy is limited by table->maxlen and only vectors pay for it.
>=20
> Fine by me.
>=20
> Reviewed-by: Bradley Morgan <include@grrlz.net>
> Thanks!

--xrhvwbqqqbh27ci5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmqDEA8ACgkQupfNUreW
QU9zgQv/bnQ92wPIe9bSeDUP0FWKwpDTbtxn/2wHV3tzqIJArmIZzkr02Cy6qsxj
/De7twF6hou7L9+YQyf777GU45woG89gvPpGLs/uJ52Jlv/sqEObSzxXJNbeWWWs
Wozys0TZZsOAkBLwwvcBky4nw6EqSodJE+c1tFfAJFkr/8JeOk8kG0mPaWRP5KeK
+DlxLVpQTySKxVB1i/cZhNmeecG6FioVeMChDtLSKUvE96NSI/D1fngEd4I1aFTJ
8W4Ha6oeALfo2iZvSA0/cM8gMVW7M+dhY5RtIMzF8ejMNSOs2BGUXUh8rxP5cRbr
XXrDhO5SJbJsOnfj0HpAj/gQGJQMh+jmUSaCFp54251TyMaIpNH1WqxgZNmA68pA
s+qOTeRjPSVTHluyR2aArr24sKaO46j2NXGO2uS3qiNAslPE1nQHfAUX5pQQBAPV
dvsCclzMGntqE4wT8YWRI1wd37XdjtQVLHi55avd28i/lOSPjwfkmxpZBgmY9hTH
bD+zj0To
=AzpY
-----END PGP SIGNATURE-----

--xrhvwbqqqbh27ci5--

