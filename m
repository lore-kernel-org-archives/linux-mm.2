Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75612D6552C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 10:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D944D6B0092; Wed, 17 Dec 2025 05:04:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C136B0096; Wed, 17 Dec 2025 05:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA2B36B0098; Wed, 17 Dec 2025 05:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9B446B0092
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:04:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5FBA48B733
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:04:56 +0000 (UTC)
X-FDA: 84228529392.02.8BC38B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE0C0180007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:04:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5oLTjIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765965894; a=rsa-sha256;
	cv=none;
	b=iEaKWHUM9vPF6sBknx7H0LGUx5U6llkOqTPiYMLKwOfAJEO0pUMRIFt/YPMP82ldiDVFNH
	PqixYHj9QFmU6zo+vwr8aSwJlB+Tda6leCxgPh0VUp3ypSUlzY487x3j11kyv+okybl6Kx
	UR6PJfcYUwZfFW2PIwKOoFn+OvnwDtw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5oLTjIW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765965894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tA+l5ZvTNSZEoLf3HNvvydxy6XUSRTEcyheH1Q9bNsQ=;
	b=Y+gml28HgTQuCckToE0P5fRZ6z6a4nYqAjQXUl8JViqHrhOSIjA8sTazBKP05H8ydlxsCG
	MGDy9gkBzLwcReMVFqCbew65JS4nS+pIk/tFoEh+/fTxAqu1Lm9+euNe/WpiuaHxusWYyH
	4F/c/xntJQ0ervr4tZV+xDBPwPItKYk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E50D601A7;
	Wed, 17 Dec 2025 10:04:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1D3C4CEF5;
	Wed, 17 Dec 2025 10:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765965893;
	bh=tA+l5ZvTNSZEoLf3HNvvydxy6XUSRTEcyheH1Q9bNsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5oLTjIW/KPuHmkT+AHgfTV2N7jXScGL6NQg+whZ+vEqIhGoujrZ/gV/Iun1BhbeI
	 4okqWYyOcR3kifBbbiapTMdXdNgpHWB7NK4wbj9nHLHns8i8DeiLi1EenvyzCa00gC
	 Rpx92w6IdxyTPci1H8+YSBwRmbfDyTeAsR+KFVBZcbS95zCtb7TuuBtlddXWEhW/ay
	 sCC1mK/2qMcmVW+ZJ2UBuDBWJvqIkLzXjXrS9dN9Ysmh55nPcIkNullxZKR9ZUkNyM
	 VRIFetSbMC+Ry/4m8cWmhgyLW80+1Q24vUjBBWrPf+1S6cFapVi27BrIEceWyVO9hi
	 +2+QCwrNPr55Q==
Date: Wed, 17 Dec 2025 10:04:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
Message-ID: <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ujw+qSJhd0QmRzk5"
Content-Disposition: inline
In-Reply-To: <20251216142633.2401447-2-kevin.brodsky@arm.com>
X-Cookie: To err is human, to moo bovine.
X-Rspam-User: 
X-Rspamd-Queue-Id: DE0C0180007
X-Rspamd-Server: rspam10
X-Stat-Signature: m53xd4hz84bcfcynu19mopgnzcx94d7n
X-HE-Tag: 1765965894-923853
X-HE-Meta: U2FsdGVkX199GFLlpkKOCAkUlP6bCI5Hz5+zhgJdXJCmwfvgYC756VpsqN1K7DttCXiERwqzksGTLEgiax50tP0Axs5QFRpwnWk5iWrlbdPAEr+5bRMfmQHScNNZd/IugNHkyp7WEJNUQv2wnrBNCbxGx8FTiBJkU91Gu4H4azJ7v3r1ETU1LthsxMsYTEuhj00O/vQTeP+hmpiQdHSiJO4N7Xb4x0b5ohY8QpNQigcS28gfU08se6zagvNZzlOhAluP+x+Gb75uOdVdhUctvM2OD8NfzdNktP7+0ghmdF2JOPAjag9H85QGlexVJ72EGEDI9SM9oo+iEup4JjtNU8G3EuRtkMDVzI4VYYGESw+Xj4VhA3DsE7lIPOz9d6chwu0Lp8e/y78VLMmxu5AMdyfsSpK0PTbIbGv2m9ns9VaLzBaSifCv6rmvOIHcx0A7nBTZDU4utflKGAV3pTzP/E4Q3vNcwCY/snNsqFXyooEneWbD/4cKldtP9a6FinYudH8DfrBCR0/GhTPXhX8pJ9MBmkRMz2Y/hp9tkOXiUAgJldrcrhs5/lygbWEVB5/WEbZfptBJ4Z0jVadq1SWbjCS/ZqHGES/EY6qbGyoGixQpZyJWsDsjDjDodj5QkHGOPTXyTNxTj5xU7RvEYcID/urR3JCsCA3OnNr3jY6LyHCo4qvA8G0ElgWGxkkLGBLJLZFMyyUJ+PoslCQzXYiJ/49/O8w/Fo7WW+gELPMfVgxQ0FsXiP4AipFnD/WMWnHLzyGx8Ihcegp8t259h11htNU238zl5y+Bsu7jTxflnfG06K79PeDz5Cc61usT23XA+JuYp6/wOMthnfH1FNaGmr5eM34Iihlu8DtEDiXHvLYngXhDmiHG4uzoxPILJX1HjtjNeqRWXAC2mE4e04mAnlLVtQ6bS5k/xM0uJoCiKlN5dqfj58BN4UCBjezwMnBGDgh1RqgutyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ujw+qSJhd0QmRzk5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 02:26:30PM +0000, Kevin Brodsky wrote:
> Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
> is not compiled") introduced a check to avoid attempting to build
> the page_frag module if <linux/page_frag_cache.h> is missing.
>=20
> Unfortunately this check only works if KDIR points to
> /lib/modules/... or an in-tree kernel build. It always fails if KDIR
> points to an out-of-tree build (i.e. when the kernel was built with
> O=3D$KDIR make) because only generated headers are present under
> $KDIR/include/ in that case.
>=20
> <linux/page_frag_cache.h> was added more than a year ago (v6.13) so
> we can probably live without that check.

More generally building selftests with random older kernel versions
isn't really something that's expected to be robust:

Reviewed-by: Mark Brown <broonie@kernel.org>

--ujw+qSJhd0QmRzk5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlCgD4ACgkQJNaLcl1U
h9A3sAf/aeiWVqvFAVMGUs8KbXmHp6QAZpFsA51N/Ga9olp7RBTZYAaZzoNKWK3L
uTgwaiDSVDODV8AO8B5zYuaAaf36Oe7OL88CAWU5Z7RqQlFdfnnf42gkeI3TjuqZ
OyDA3n640Kpsk08sZzuzTHtwD9x3rVMtoJZs52QNYel8v09Dn8I3rWrU/6H59wBH
B0Ca5jJDLhsAghMC6ZQ27Ryv4jRWSsKIODiLioPPPBdsHrfA2h+PbyIHVFHtnYsg
rykbRI8jXUGRHpBKeSNH+GiD/o2w8gUaLHCyY5LwvMgxBz1+CnGOjGEzXyPv9B5e
rcT6rYEPIp6jodvF8vnl6mXvGsgTxg==
=3Vbm
-----END PGP SIGNATURE-----

--ujw+qSJhd0QmRzk5--

