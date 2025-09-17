Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FC62CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 10:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC798E0008; Wed, 17 Sep 2025 06:26:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D628E0001; Wed, 17 Sep 2025 06:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A588E0008; Wed, 17 Sep 2025 06:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 119208E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 06:26:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9F7A71A04D7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:26:36 +0000 (UTC)
X-FDA: 83898363192.05.25847A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1137D1C000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:26:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBLt2+9R;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758104795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V4DKJ6+aNeIjDwa55ioesXzJM5FQb9CpaU1SdBWiBbk=;
	b=5iQyQEUceBZMzjrkOKH9k1dYT2Vf+XioAbPSRFifHUimPxE6COp4ar0c89HR364XiFxkJt
	c/ZwWURn/V+OJYckYbcuT3nR5OsYDvsYJOncmk8uTBVJQQtWI6mkLii+VPPzXmvfC8nwmM
	y8PGyToeNduqPsAGy4p9viYh1TuqHDw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LBLt2+9R;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758104795; a=rsa-sha256;
	cv=none;
	b=pOovw9jA11eHao/tEGqUYU3hlRG19fZCQVYvprMdnaUFzi89W82Ogcd72/bfNOy75Suk36
	6rau0CWn+xn87fezsp/Vm+EJ/Sg4hvvrXW5/FF7z8qQKGidAVbP628O/iJ4VGX0/oH26Ri
	ZswcPgEesq8XKBxydzBi8CYJUm2XmjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C9B4601B5;
	Wed, 17 Sep 2025 10:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FE9C4CEF0;
	Wed, 17 Sep 2025 10:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758104793;
	bh=T3ISxIPvcZvhmhbtWB1fP3pff0PITh55eSJO6Jdh7AI=;
	h=Date:From:To:Cc:Subject:From;
	b=LBLt2+9R5ViUWWr6NoMg5QzzzaTg+h7deFeMsyejRjy0HEFvBSh0xe2ujbShleWoj
	 NKVkjQWlZt1JhZs77BLsRGveU2MyoLfV22Rf8icd0HghaH6Q78ZS5pIF31jkWBDkwS
	 rFlSvfdimzAEtFPRP3O/06M5R4A5R3ZuiWQ0DQyKNMQAD8JFnxXuSAXbOQc/pr1c85
	 Pq/W+3ZFZzAI93AnBaBbQHCcqr0nfb41HbGWXhscn+Tni72zxhnweSnMlo9NTqWrk6
	 RsYdeoWvJdeEmBktqQfqe6nYE5j7+DZp1z7gHJvvaBDmv6STpyIAPNu3bwY00DR2Jh
	 SMhIbUNTuiWvA==
Date: Wed, 17 Sep 2025 11:26:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-mm@kvack.org
Subject: Missing signoffs in the slab tree
Message-ID: <6cc0566d-ba5b-4676-9b90-bf3d1fea4c7e@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OQN2g4LYmcg72YgM"
Content-Disposition: inline
X-Cookie: Limited delivery area.
X-Stat-Signature: eaqc5mdjyytsa6bsrxnn31yg49f1s453
X-Rspam-User: 
X-Rspamd-Queue-Id: 1137D1C000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758104794-367447
X-HE-Meta: U2FsdGVkX1+M32sKunfYd8r73+Lr3OPFoqoVScPxWxxcnamxCez0Y79FyJrDroidmLzB5tc/l8eB1855bmezIzuBkeiMFSf3C+zP+4XG/kdgNsvygTXJy3X9EOEB7Iolg+cMLy13dfKntgzLdVtbQZlCSOeUerQLRkplicTJmHsy7xW1A47xBKQshJXqdktr8yBuq3yJwKUNJpBse5P21xbODsfktoGtdh75tFWAQ6leFZhEyXFmERGaG17Yuhz0dijuWX3uyoh8v5tRc4ZtFAhTKmHgQ7a+z2O4ilKLhhcA3GjBpLee5UhOcpk2imdSUDLB0KUsp/tYwme5ycNI1alWcixY/t4ymwht8RFxAWE5TYzV9kyg5OWjqvtyvAYVcBW6if2BxhcFJzo2CP2Jsfys/me3//UKoAJzgFsOz7zMNZY2fLFR63zyGL8nlJ0AMuzFZHenPQgbdJXFBp6zE8ayvRQMvZZGOWN56BQiHJz7fAYjIICUyvGi3COv536WhfTcOKql6JKnCkfW03/cIBaPwt0fwY5x1eglfB/gsY/tdmyoT3eO6mlglzBodvvvKXB4tocYwwOqns5cwqpBP7q0/thyNQHMLf69rIuVWfkeuvmuf6kenZRnC27TQ1JGBbghsECslTTrfvx9qBlLc+zh/Mlmg0zK985TVSAVJKnvN2EYcWeqMnMH/petUtMJuqcTKmm1ZQLBJ1VND2032kEoFZOtAah3Tcc07TndqUF9g7S4r4fUCHhDcXuEo4qjFRbrUQ3WrkMWeOhQzZKso5JPfNBr5Pk0befnlUsoIgyq2MFyuCbQScklvr3oHhW9gyRROKN/q93LSRDoP6wND7mUpnHMAP1JvXgxaAq82+59U3eFTPyTajsJgEGNUSypzx2fb4wedZXbGyJUBSkJ86IWlD6ZRs0X0uzULY4fuPLk1HGNC0N1sU4zB2Zey5eQIapVjr/ifGsw8R85xVI
 ykxpE/dK
 eI58u2eN3e4TXM0hJuBcSm3p6XoMOgepTIRulp89lMntt5LhC/zIv8Tc9KoxAjiapjiDxqHTE7Yv4mjtUkbnTI6LSOs0cyfipElN3N8Tp8aiVy8UzaEmQhnE91MM2FaBgEm6BN14VRBy0Zz4LTb4FkDvBv8vjrEpt0WyY09/dWc5dYAlj5xIYpasKsWU5W80jwA77pBU6SMTZ64YfWB4LU1rYE8rKottkAhPRGxZZQtXY1+zynDJJe8tz00/R8FRrSlrECcDgQu+pGCgCx4pdG8hJcUfFCg11cwNF/IW+pABP+/LKs6UDMjiwew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--OQN2g4LYmcg72YgM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commits

  cbcc3da4e7bfc ("slab: Disallow kprobes in ___slab_alloc()")
  dfc415682b11d ("slab: Clarify comments regarding pfmemalloc and NUMA preferences")

are missing a Signed-off-by from their committers.


--OQN2g4LYmcg72YgM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjKjNMACgkQJNaLcl1U
h9AL5wf/cY4oAMRm0Hgklab3zCrDkwSOD7gJ6mgTuhs7J9knLFt6wYUUmxBtY5Rn
mhjUAIdnicH7hqqOsLRsNi4fdcHoYRkPH/aG5c+S1T8/N/8iXJkJ16YYbezR6Rve
7UV8USLM1tigK+YdcmzEJ8bSnSJVW3O8hk/kb+jzJrPVrLdBX/JlVaiU4h1RkA1a
h1LHf3Vm2Yoy85qi15HA8fiCRRj5aOssFa+VXVR0NdJ0QghCZX5b3xpGu9XEc2ZN
NJzeqyR8/9DPFsAqPUgE8YxOwlCDH56d26BZWg6oJFoomNFC7J0YIlhqmUr5ED8g
Y/RxvlOl5bxMT51e5/YF7EuAQWHfcA==
=uYmg
-----END PGP SIGNATURE-----

--OQN2g4LYmcg72YgM--

