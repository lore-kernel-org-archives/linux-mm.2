Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 163DED35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69F676B0005; Wed,  1 Apr 2026 07:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6501D6B0088; Wed,  1 Apr 2026 07:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565C36B0089; Wed,  1 Apr 2026 07:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49E0C6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:17:39 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED8691B8A5B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:17:38 +0000 (UTC)
X-FDA: 84609736596.28.B5C032F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3083940013
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:17:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtkyqXx0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775042257; a=rsa-sha256;
	cv=none;
	b=fGmuAH+voNXPL3fgoBaCfvvNbj0hlLN7vDWbECYEiZLIfqZ4oH54sRj3b2J3J5/4cS7Zna
	KRqpMXWrJHDwVW92L4A8yu13OGMRo9XY5GQahu8JLQSSMGzh4QbttE4ujZFO/PM7eAJh7l
	gP4YUKgujDcPpq+0igsKPthz3BAmTLQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtkyqXx0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775042257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HwOCAyG3TTWEIt2f0AUGMNbjfpqujqWRqR+DRuh3U/U=;
	b=oG/VAvuaSkY/Km0iVlmIKb+1KVOsHfaoA5cNMhLZk6oCEt8GuTx4oCtrMvfEuRGI/SLbHu
	TPVYTA6K9fpCZMtWyUXBOfcJt+e/E9WeFaWdxlmBS/goOzeQ2dwe8I3AW2ZQfIxLf9dFmH
	oI7HKFGFwSZusg3hciLcqbwTaxMdMhc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 216704089F;
	Wed,  1 Apr 2026 11:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0268DC4CEF7;
	Wed,  1 Apr 2026 11:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775042256;
	bh=N1Lg/uuMEG2XclojkpbMXk7nlKJI478QJMLpw9zok0Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TtkyqXx0O7OeO7sZ0xDozi/d6eOhTtvwWBptDQHmVQaL4CKzCN9kCUoZBOpvrZKeE
	 Pp5UnmUUAFa95UoVI2lwUNtcTYvqACblxFId+EBTFK3q6sJSDeutW3aSA+s7ONlSv3
	 rG3M+xaK8nhjtsuL7b7mTVMFc7kEU1xGfJ53dsGjtPpveDkSpfUsf5rO+n1uu8CBLh
	 8bbc5nXSPsSWYr/a1/eBBQBVUNL5H2f+tFemz2mxJuovPcTcCbEGiXiDOmWtp0JyXI
	 QG6BpI3HY34L0gIlPJ4oem2aNcFY1S0Qyi1hOXmwYKyC9FmjGsMFcNibqcG3gqaL9H
	 LfmfYU4KvL2/g==
Date: Wed, 1 Apr 2026 12:17:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
	Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <d20a7a98-2bc7-48fc-b467-21eba8df89a4@sirena.org.uk>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <20260310155821.17869-2-anthony.yznaga@oracle.com>
 <52bec9ea-5627-4ea2-8f27-f1729957fa47@sirena.org.uk>
 <20260331141714.b2f4e41b494060e55610a5f3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JxsWWm5ZucbJodln"
Content-Disposition: inline
In-Reply-To: <20260331141714.b2f4e41b494060e55610a5f3@linux-foundation.org>
X-Cookie: "Yo baby yo baby yo."
X-Rspamd-Queue-Id: 3083940013
X-Stat-Signature: doubduxko547nfugk9f4ugzqe8kjmxe7
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775042256-691560
X-HE-Meta: U2FsdGVkX1+bDqM1j4yu+mR2W+qfLjN7v8lu0ME+TA4lACve5908iaTphCgEMmKSi4Oe3V73DSUTnlkok4n4HKwgJkpj3yR1DXXmbfWlZL59RCl72gU3sBGKDqgDJGUhqfaM1DuspQn5hXpWNg/f070A3Bn2ogdrz3/r2CMXvL1V74rjZ/Rshfpz0h07gJZ4QvyWJiOvfw8swymeAXOeDKXL41uElgbPeoBcyk2orF88BeAThhhikltCqkR9MAHYvHP3uVJlsAHQekt4g1x9imTC/u49fQRowLVR2qNVnYhv4Z7IjfG9Kp6cpifHTowVPLEfOahZLEk4VrgpQ5aJAiq0BmLkD7sXxMmyVmROcDalw84NVRc5cvKkWErpWMZd7ksVp09lzzcC9FNK9E0CuKeCc6xEiPL5sZBtE2vkIXenkQwsduDKkGk856u9L32xtgLNEVv96z7HreAnwtJs6dmB5AwccvdA6THVq80ME17vEgAECanHQrS3AJiEcVZtjawifJn4wKrciLe44d2wISeUflP7YtzMMx1PCEt1pp1hbud7/31kBzuoauBYSHHgZ+QbqFjadPKgCVrf+K8QVIWsLhygchBHhYjlvTJt3HHt1blNKMOInauHzGa+jpj9C1ZV2ltUO6p5WFeRYgJDOiW/ojwBsWkD6tKlwlGXpB2ErvMMmZOGxwzE2Ub7Fu6XUQOBsNY778n8JQIG/G+JMb0vYQPO2N36lODtaG71lH+jWqYtXqYVj4Tpnep5/YUK6ZyfiZ0Al7qr0NqRfxwLustUyqUgjo4C2Q5XuPSI58is3Av46zTCv2klcpUSiVE9zc2zTgY7cFWxCkqR1sB1R6cfbbdPtX00y5fbnoDdvFy1Urdq/806v+Izcrl8pGDUXgThRNc4QnIYGAXwJOsDXrOtG3dNOuQFyU01lVaL7hLZrfb7bitH8NkzsX17k74XGLUmjdNSzaYlR6XHpyW
 dFtuEnB0
 SFdcWtYcL2bgbmcaLLAb7cz8KNDEM0vMTCi0niE/CNrMSaPPAtlZ6UWSnuckaDXTlqgDGDjzWlZ76lhqkkRBNH+vrtj2dVxV4QstTMtYORpiEwOAflVb/vCLm0HE2RJZbAdJ2nwSO94Q2CGwXiHccBqUMlcNs6S3DZVflTg59XWXgQHDpOplISYGuzbajZegCqCF2enZ9TDqUJX1GEBarQ7RlTRRqM4nopApWAbDZOzuK/IYm8qEwRR64Qfxxc18wN1MsC5BLveQWblDim7fO4iti0Ly8OjuKpNgOM+jRZZhJVHbgkfQkRXzeHCKaso4dblgxQQVkzQrBIsUgZJ68NQEOlDyLbp/1mHOkKrnTLkTUKEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--JxsWWm5ZucbJodln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 31, 2026 at 02:17:14PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 14:17:50 +0100 Mark Brown <broonie@kernel.org> wrote:

> > All these failures which cause the entire test program to immediately
> > die seem exceessively strong...

> Well, is the test code incorrect, or is the patch which it's testing
> incorrect?  That's 5435ba164b0d ("mm: prevent droppable mappings from
> being locked")?

I've done no investigation on the actual failure, sorry - the comment
above is a stylistic/usability one about the test program.

--JxsWWm5ZucbJodln
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnM/skACgkQJNaLcl1U
h9CnEAf8D+qC45AiMzqQRSdGPBaX2a40RNgSp2rCACIzsmXr1xk7NNZ1k+XlQc2I
BMlDKY7emJ7ZDKoEdOFE4ghdlkNyLSpx3fY/p9Iu+tiN7cE4G14FJzmuqg9QY0DR
vNPFvJGsKVeCIAz5Rf4DsB2NwFCR3iD1iJNXe2LpjqNb9xDxL2823/F5jLXGeR9e
K0PN6ABceEV2fFUeXLg9O3iNp/0A7tbSfGirAlu0pebo+8Po+wISeXk5G/qNRn1w
IxqJ+HGTGiwAPcCmDs8LeOf816+NMN1XQ8vU3XkVXanViBgfjfYPcF0HRTey7M6j
w2yh4lWvUy1Gsn/uAr9LbLdR6jNhdg==
=T9t+
-----END PGP SIGNATURE-----

--JxsWWm5ZucbJodln--

