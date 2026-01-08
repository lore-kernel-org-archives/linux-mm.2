Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B3A9D185C6
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 11:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6DD6B0092; Thu,  8 Jan 2026 06:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A226B0093; Thu,  8 Jan 2026 06:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8563A6B0095; Thu,  8 Jan 2026 06:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7607D6B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:31:58 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 065DFC26DB
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:31:58 +0000 (UTC)
X-FDA: 84308582316.15.70E6779
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6969F10000E
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:31:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0LcxD2F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767871916; a=rsa-sha256;
	cv=none;
	b=XUoOfzo3mcZvrfrkds7Is8/wNt0+H4yi8ABN89L77JOiw8p6F9zBabx1F1Wd5iU3ghli1i
	/14enERP0BBCPx1bZBcX0O+GMqzeL5Zw3GVBBHD8xM2ZNNTjNsG1/F0Z2poBDCoJuecADb
	E4FWrKvvJUiEkdlVaOryb8y1vDn9nFU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E0LcxD2F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767871916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrXNFXLMVkEvuyjBXRmf3vAuCoPHKHapcE99UYwQNC0=;
	b=agDU6VvXV+pybYU1trcqa7spzWBvSaqYedXnD9Y5OYT19POIirPyJiry31QidbVdK8e00v
	Z85j2VmM4KkUFVOO00BMWhVcjBtkwmWNg4WMQdixXB/zIRUcwWFMPrcRORjgDFzJP4qy6j
	5OjKO9gJ6gWYhj3ZNLuPAS1NZ5HruXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C608760130;
	Thu,  8 Jan 2026 11:31:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE633C116C6;
	Thu,  8 Jan 2026 11:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767871915;
	bh=GrXNFXLMVkEvuyjBXRmf3vAuCoPHKHapcE99UYwQNC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E0LcxD2FmBfBt5A2gB+q1KZ449IeQzU4gEsfHILvYt6lX/bEUz2tBjHnBQDV2ZScT
	 4EsUEFCiSej8EgqA98dJL2GvmzZpfjA+gGQpMlsQZukLRCNhs+mVsEksIOfONUYVF0
	 9XUOraxxDDNhYUEsv+EM2Qw0JJYe3ziQBRAIcHpRy8TRP1B9qX0jIi/TjLz44IRgoc
	 Quv+bL5uhS4bMGpLHafEC4k5om3sMmc9NYGOGmLiGhHWfeXC8wnyVsZFKiTNNcLKcL
	 YReXCQx+YCkeLN4VtxyoSK7xHbfnqj2SdM19DhhSfazXPd4YJ+YjzFLttqDgj7Wy5H
	 faomWJ+DHzrbQ==
Date: Thu, 8 Jan 2026 11:31:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrei Vagin <avagin@google.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	criu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>, Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH 1/3] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
Message-ID: <79af0c28-9423-40ac-840f-ccf0ca676bf1@sirena.org.uk>
References: <20260108050748.520792-1-avagin@google.com>
 <20260108050748.520792-2-avagin@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YYxvTW0iZ6aVz70k"
Content-Disposition: inline
In-Reply-To: <20260108050748.520792-2-avagin@google.com>
X-Cookie: If you suspect a man, don't employ him.
X-Rspamd-Queue-Id: 6969F10000E
X-Rspamd-Server: rspam03
X-Stat-Signature: wnd94sgh936zfee469h6icj96cnsz8st
X-Rspam-User: 
X-HE-Tag: 1767871916-996189
X-HE-Meta: U2FsdGVkX18H4vvEJiA64Ez3xC+FVa98YM+brTVH8g4b4ALyv1ZERoDD/OR2HQRYe9/zUdQN6MK9rKM3z+QrpiDWIro5oQZlfRuNW/ZItkhmTlSuxJt3RIIchais7F5s5NEK9uhdY/+W+JMoT/z7qY557IaIzNaeVc1vi20ubQSIuBM3iOdlGdBmoFzEARlX98/3B5jNYkGHYie0M/i9So9saX0fwlqz80B2HjW552Dk90dVWWul3gtNZKVwM5dfwhq2sbqL5HbaY2Oz7RKwr3msGHts1XNGjMmFfz0l4jPG3F/s7Q57duQRALn3zRtmbjIXBV6r5djL8c7cf9AGSivJwGGvNHqYL6+wczrxFojLgiOhQMIMhfC82P4HShH1YdcrDN8G5LPTspEExXbdS5RozxRQc05GQN+aDAf8HHWA0gZhpLyoImzeYJbXYSjBDwPbieiwfjKMzhPFErPmKpEQcYNN6BXrHVv7n3Bf09cGtf0GQIoDQoVU2iqmPQwiIuFCBLa8L7VgWZkWJ25Opoj3iHuW6oFeXHsgV/WRi3iraZ96+ylVZDkjbLleqrwvRCNoH1gB6GQiMnC52mLDa+nXLgT6Ld6L+6nybCR2nPfCybI1QfZWAjFMAf1bo2poHby9GLSN92KZ2fzjzuOjUzj61GeBU+bIeq5OplbTUtGLrUed6kTcOcxXfm7ca9RhatBXF77EG/M7Akogl68FxdnD6DM1Hi4rjDW7LuTiBhtzrvJ2X543omTKPAG1avqd28GPXCb9bD21ga45mv++0jzZZVz/GREAGq4IV9rV3TSJCFlxvi0IlVlqsdKLw8BaYnI1WdHh0hS4jGllW3sK5FE/houb1I6g+UhZxs6EHho1zBJjDuia+/60wyiTJOP+L5xkzKq/4Vs6A1cLQqyHrdRNtt/osY7Ep3jh/6mFuDAPS5gyazI6j9NvzLKofJO+ybVMrWnjLJsgHcbneo2
 ioiS7HO7
 K+r+/E7KU6UTzyv6IoXZRV1spnPgZKB2nHyyZuSm7jCRVe9+D2Hs2/WRfU3v3QhqBqwr3E00QIGot4YhcnKCLiOjBrLaye/f7fHrQAeottX3thDMCX8Vg9f5WaI1ebs51uQgQ2ZjeynTNBRdUSdn6mtraHr+G4Zzhcz2uwIVr18YcHJDBTTpmf/y1+B8WnCu9nLS486CCqEiWGqqNmm66HtjkfqoLlTk/yKBhD50V4bzrgoUx8ecLJ3O8YJ0I8GjrKisf1nAT1t45MRfdvHkb9M1dilP8ljpZYLgqxN1i8ebe8Sfleg0tWUfSONh8ZXvnfuG7ah6K58HGAyeqmgyjSCPpmKnVcJHjKaEWKoG5WC1FaI5C9kF++6Zp0PHMDxF4pOJI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--YYxvTW0iZ6aVz70k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 08, 2026 at 05:07:46AM +0000, Andrei Vagin wrote:
> Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
> support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
> vector size calculation in create_elf_fdpic_tables() and
> AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.
>=20
> Similar to the fix for ELF_HWCAP2 in commit c6a09e342f8e
> ("binfmt_elf_fdpic: fix AUXV size calculation when ELF_HWCAP2 is defined"=
),
> this omission leads to a mismatch between the reserved space and the
> actual number of AUX entries, eventually triggering a kernel BUG_ON(csp !=
=3D sp).

Sorry, missed fdpic here:

Reviewed-by: Mark Brown <broonie@kernel.org>

--YYxvTW0iZ6aVz70k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlflaIACgkQJNaLcl1U
h9BNQQf/SWKoyWBsmRtRijLDQFwuIjFlknk89+D+ZwI7hTFR2GRem2nPrMjLveB2
SP+8ABx9/CPZxt3iYxRGP6ljFYeT6e6sHGPloqEG/nSyp9sAgSc5a3jM8CtjhbQB
5658MuH0gZgd7Sckj8WduZPof98zKrMkGftfJ2Q7uT/jhM7ZHIy8q+1GodpMLZ98
jMT6IkBHsjrfNgJr3KHrTxNa2os+W+371N9L5RlTanphMm4sQOdCJvAqyLVlvpjW
IGrFyVgOcjwFqsBjXYs874Zo2+82EKN7QER2auVrJx5oIUn+uxf/KmBxkLN6DrcY
aF+eT03o52RmgcRqCa6h1rIN1bDr6Q==
=96VI
-----END PGP SIGNATURE-----

--YYxvTW0iZ6aVz70k--

