Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4D7F46C54
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 16:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C946B0089; Mon,  6 Apr 2026 12:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5026B009B; Mon,  6 Apr 2026 12:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232176B00A1; Mon,  6 Apr 2026 12:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 132576B0089
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:19:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 977BA1B8091
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:19:11 +0000 (UTC)
X-FDA: 84628640502.15.FE3FD3A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD26F1C0009
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 16:19:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oRonesBm;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775492350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdIBiyz71lXmkEGm0gWWfPw+6wnk6xgQa6Xm/MflakI=;
	b=SkAvziD26p/68g1TuhCL2tlBlmYqrkcv4zb2ECGptwVdYoPjPw2BKYII2+1kJOkRjIybjt
	JWNiD+6yvwbjGjX4U2rxteAMW1Zk1zgJf6LYdf2nEacj6JAY3F3XlvxjbfrGqv7Cu005Gw
	xwZ2dt0dxZ+o59SH3JWPKHRuvcAU/1s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oRonesBm;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775492350; a=rsa-sha256;
	cv=none;
	b=oDcqIc5aBkteV530sUEPiwmf+1bWeM/0+7OACQoVg5HUVEsZJG7UE2BLpm+E6/XzVDJqE1
	KarV8uiCrSmfdLUqjZ1FiNQmEZlrDrOBgHMwlGB0c9MNy0OGePghL2MkwHXhhupGJmTxAx
	b5R2qz0uAuvljXtxY7/wNednMkkUiC4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FA9D41AE1;
	Mon,  6 Apr 2026 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4D7C4CEF7;
	Mon,  6 Apr 2026 16:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775492348;
	bh=HdIBiyz71lXmkEGm0gWWfPw+6wnk6xgQa6Xm/MflakI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oRonesBmZ+vF6cVprCooMPQn8Ik/F4Zb6jcQa4i2DVQOhAA4SR6hsNx1PH+qt6rmS
	 f45xpus1EQ9xhJ3Niw5M22ipPT8YoIxEMW7qNdtntudtwSQp/LQmw0fem7nyVkIhFy
	 nmCln1JANZbv4RuzwG8DCE1kmCit6oGVg7svAjuzRIAaxK07SB26lzAPBniStgkVH/
	 ZEiDRQSte1/A0a2qHbuvLwbrw4Y6flq+IDUX1dbgKCh/dZUnDWTDWc3jwVqByC4Mr3
	 qRsWxKLMWwfeGXEhZKWWe4v+Gli9RbNHAoiLMzCHcCwpPX2de+2yHmhCo2akMmM3lv
	 aDsZ6ZPLE97pg==
Date: Mon, 6 Apr 2026 17:19:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 11/53] selftests/mm: hugetlb-read-hwpoison: use kselftest
 framework
Message-ID: <c0407e11-5e89-42ae-8bf0-8d36dff1fce5@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-12-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0GHkfvRsn+CDD4Oe"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-12-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD26F1C0009
X-Stat-Signature: qw7q1urf78s8u6npai4jru94eqa35kag
X-Rspam-User: 
X-HE-Tag: 1775492349-179988
X-HE-Meta: U2FsdGVkX1+SAPCOIXVTeuFqGl1XygzRCR3YftcxDS6PCQ7D43Wwy4sH8oDaqSMSRv0HGMQL5FRvHOOBXUK68Po98+7AWYXiixjnY+Uiw+aKQ0ktsiornRl7WSG3/95Yv7H++J7pPATRvM+yo/BtkDm6hZrb51+/j8nWl4z2bCV2FTptCxYQK3tfDk3YhsuFS8OOXB4Jvl/I1PJh2ZD74gRJGo9IEHYs09vi0QwBpIaJqBm8K7CPWGvITRhySwTiXVikAUPlwrHz4uOT9g/HpIOz5ote5x6lars6g/GeM7idZq04eBiLwa03HyOJQCbabRBf2v2oG9i0jnmEJVxqPLxM2c3s1G3+/jva46B8hMR+drmhY2DSo/ucFzYul2bc2fSQeyULd0M76t/2R3422KB/6cHx44GeyQz/jr5ASEOcf5d7qgVbTUa/KSTst9KisxRt/n+f1b5e5kzLaAqLGKmHdz2RkHGKI/QiVTBr0Ylf0k0SpDJIekvWh+DdC6ENxvwGLO/L+4b6Q1iJOD2qyny2VnQAkwtabtLi0ierSkY7DHPztyQB3lCnLPtU3Bi7Kz+1tdMgv1mWO1HCFa/xwRY7IlWuK/SnxUnpbZmdXBvOvLWqyQuMJQoNz7hbfPeiLtJs+vsjL4vJkMlYYn7Pcg0+GO+em/pyyqHNDcVTqMLtkl7QYyj+D+ND6i4GUxsbl19B8VvyLJhTpkCqmnsi+37Mz5kUxUFirYUdYrSh/vZ9nbUQmEzXyXdbQwJdMFwISrqg1DNOjy9b1NcHuVUuEcRfq5b5TZexE/9g1NDX4oF3KBF1ejhySrKkwDFDdu3Ke//UKhZd/lbjXnqk3ReRirZF3SEnUdQHm5Td2SN1TND0QSLLbTNQS62xMD0xrJOhLrOb/IcRenYXlFqXVpRK5iC9paiacfGYG5Pw9sLwRoarMY51paw3InPAnss/2IX7vX5OuMW6E1AAOyWY8xP
 Rxk5+ZQv
 4JFbclEbgjEtdOWbc9BUbWXaUF+mx4pb8HIhtR/zVCZR8EbUhl0nVYlOt4DHNBjxtaWcKF/R8Plgn40vqfqKwhvt25u7O7PphrY9v/8In0lkf1jfpYp/7Qf/E5fodHDY20TmiKbMu3mi3fywC0XyOXkWS92Np6RhhOsUeEqKx8ImSg7rbDk0/0nC5Fv50wXPiA8QVWLQkwsaAL564zqeCSh39bysfkq5cScbNnoIwuab65W0XLEhP9fqnfwFCW6q4uE+DE+1cn4b4tq+fuQ/QJZhZ8mVbG1mnpbg2i0ugG/4StEGe2UbssLb70ivxvch+4hwPOa9cXbbCiC23FT8nRe/4G7W7rQcpt2Cmzdt++xEPZsw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--0GHkfvRsn+CDD4Oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 06, 2026 at 05:16:53PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert hugetlb-read-hwpoison test to use kselftest framework for
> reporting and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--0GHkfvRsn+CDD4Oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnT3PQACgkQJNaLcl1U
h9AwIgf/V7Y2RmIqUM1Jd40HZGxkQeK7dhdkp7oqV1IYgkS8MTIayeFiAUpSAp93
CdlhlIE3Q2DB1ilnVoNTF90vynAf2p9Rpn2qOsGHzfY10qBsBSpitKCwKZplz8ib
IagSoK/2wvJYu9MnhqBxHTiVlPCwLUbDj1n/0KCic/1fXbWAkIwh2NabqqM3zxKL
LF0UqMMrLrppfXJgkOpAE2lwJTOV4vOSivp3nEejV58tZJH6iSQCQvta+e0phrz4
m5pYab4x6GYf5Tfq7y7VH8FTzayXFhzOC5MMmS7LCJCxblHTm+i1MLsxE94g/Yd0
Z5cBYEZHvn0SqRWlPsFQ3A5KtTuHnQ==
=8YFA
-----END PGP SIGNATURE-----

--0GHkfvRsn+CDD4Oe--

