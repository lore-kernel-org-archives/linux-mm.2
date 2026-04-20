Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C3F4F5A8A9
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 17:58:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CB766B0088; Mon, 20 Apr 2026 13:58:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3106B0089; Mon, 20 Apr 2026 13:58:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9316B008A; Mon, 20 Apr 2026 13:58:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A3296B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:58:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9DB68CBC6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:58:04 +0000 (UTC)
X-FDA: 84679692888.05.24C3B61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 00972A000F
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:58:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bMm7+giC;
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776707883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLIOzET/D58na+rPPFjcGkdlBaa/HxOhjKJa3Rd8tjY=;
	b=d88VJ4osbA4ybocaTxGT5TjV6H6NAQ7NZGYByW0aXwAfWSgqTdmsRLGLA5SMF562IyCLZY
	PAzqIrJKZ/5rCJOdYXBHH8u/5aMnoagVXF7rXFuvG1xAOZF1G2dd3TnHTTYDHpnwwYn0T+
	WWFynj9/UV4taMTD7dnuWx0YxvYn4ek=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776707883; a=rsa-sha256;
	cv=none;
	b=RZjIFTv6gGALBTsDNtysvVC6A+iIpTcFWHimVHMy3TsZB+UsUUF172R2ugAjSn9xuUtsF9
	SH0IiRt2cKwHNyKaqp8b3wESzvWfchrN53VmhprMW21GarzlLqNt+hORj4YuGHo5+4JWpg
	ThL3+DrvT8g1TCrjNojFWD4g0A/uJzU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bMm7+giC;
	spf=pass (imf25.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4394760018;
	Mon, 20 Apr 2026 17:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33D9C19425;
	Mon, 20 Apr 2026 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776707882;
	bh=kLIOzET/D58na+rPPFjcGkdlBaa/HxOhjKJa3Rd8tjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bMm7+giCluWHF0RzVtWdhyDN0IPTzco5n6XFZT7fqadS+fwgoBgvLACkCCJD7voEH
	 ddoEMf39hTWByXrvoYC8LNKIdCMSlwQsYIEHsZp9f8r5pzncJKFn67Dxy2UXYuPJ23
	 /YyULIThFY68K4dsjdKl6QwNabyq9vRaztn8K/YODjza9JjauLu/F0xKol+N9zMqFV
	 QNiC0yVdDhRcEjLRO40ON4t1KQjuQT0ljp4haWePcL39EVIWNss8OSj3MlvFJZbUL+
	 VXlwlvUiNox+Nr8RPG94Ei04/2QoIyP1cjr/sCXrt9bZalCkRBSNIeNPwPvJh4zH1f
	 IOgDEtW75zeVw==
Date: Mon, 20 Apr 2026 18:57:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 17/53] selftests/mm: uffd-stress: use kselftest
 framework
Message-ID: <d27c7e98-df80-4fde-a86d-5344b30e6cf2@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-18-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="C53RmCkSuzJ78xCF"
Content-Disposition: inline
In-Reply-To: <20260418105539.1261536-18-rppt@kernel.org>
X-Cookie: Sales tax applies.
X-Stat-Signature: i1k49uiq796j64r5hheygzemu35jhttk
X-Rspam-User: 
X-Rspamd-Queue-Id: 00972A000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776707882-786270
X-HE-Meta: U2FsdGVkX18lJfJmB0nXwShepWV9LWgWLh7jjfXquukZe3PirrwEpHaWh4yi4OdlqQPWzCjBLyDDYCQ3iPTgqHdwGSlkImQfwrptoeNSvw5R4RrGceDlI9TYsBHi2k8dfnC15/C1H/ezPMWUixZfoF8gDCwTtp+//bP4a67J1l9kKBGA5uPepK+/VYW6lN7ARkLA5Gc1vZyjxJQLIwESJJBJqoOkiEmWYzhS2T05qXSyUstn28fxI4GAEew+3y51QZm672rO/cnHnYB0Dy6oiT71GurDcNX7D5bF3g6YtW+jhP9QzXn/tPEKtGkfX0Lb6mZZgb2mIoImi8qTRpdBK1BhRmCRG0I/RbbuarSPdiegXB0SBNOWNkTnpESCnwGScteAlDq+bE7Alhkjd5mLQNKOnXWUaUelkOjTRsgBtkM+nM/5TeQ7XHsPMRr8l3r1YxMDbiov09aR9YxcVF+KdcQe/FrB/m424NpEZCa4vyQlRwRNWjjWdSzAaYQcjDOfcHx2eA8fDQtHsqvAK1ATK+4ENXnyt0Qod/rFctxxgIJCWTG0AfzQgqqsQV0ddU2/g13mBcOghAhcnSjZpN5ANNgsEdx3MzWo/IRK3GdADYVqaHHyecIpJcniBzGzXpNdmoZolWtBKMdYKmDtluhP8hiz0z8pwEIIwgSE8wMyayWNy7uaJJOAIloMlMnn2sRemxnrChAQA0SMj9y0UvU+Y0ogIDiRhm7089Bw7u4EbMYWRCcFYIM2vziZskXf61AQ2mFq4P8NCFzzNBVRdOkyPW5HwvkrxmV2r5KnqDqqiFkmRya7wpuiGrqyykpew9/BtcrGZ3ndFJpRSAOYZD9SaQYTEFp3s6+CBuZ3a/qqgHwdVu4aIt1G4WTR/IdbeZnk8rLPRPQvYusX5k+p6w+5bru5Sd4V+aOgRMUwY+8Fz5/8uHqjfxZJEp9Txg2c3j/mOYk6+RzW/57CKiuaO0c
 mWVv/1uS
 8lVoHSAjCpoTb2PNPaEys23GR4rLlhzRhaHDI/Sr1STzfvosvsNMhIJC+9cOZh2N+8aoAHy0ovU6RdcFvfJWohE9F7cTMzK14lhhzfaCJb0rQJuUm0w88/tguAw+tzB9tD6PWg09dV6rQG0+rZussP4gWzcyZxxwp5n1Bskt6y0Np0mWJFVLRO440+V+8EfYfeZr8BJtl/aHFKQJHj8NqhJ81O5oBt/Lt9hxWLGad+u6pFWdp9cUHy8l1yM8V13R7NIkkc5WF/z5niJ8iz5DvAK19HYetEGHjClcy8whh/XBQwqLexnNnpGrJD+2B7XMpkVr6wZ22GdTefM7RFd4hOwHRiSgM/lIAZvzVO5M5GV6+PbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--C53RmCkSuzJ78xCF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 01:55:02PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert uffd-stress test to use kselftest framework for reporting and
> tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--C53RmCkSuzJ78xCF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnmaSEACgkQJNaLcl1U
h9AbZAf+M0NjB3aaF0QjVePHnBgGW1gUeY6+7l7UnDBmp/GJJhqNO4H6oBtG49YS
seD8JPsYmYIVl9j936Nd8oxedlExJjLc4qvGJq32WRC36ZO7kk99HQ8cRRxho/f0
zhWSSoUeFgkc51g15AmkVXHymhUJKF1WUHNH+WjDNwI2OlOQ5tMUnaTx+fKtAnhR
kQ58YBWlOvfT+57XPjKwMZpJHO2p/YgnKinv/eGr0EuLBgC+HirH114B4EA2VKCY
kU/up+4l5qvS22OrxUm7pF18q3REXExtnI6pYrStdWW1iLewSTOB4a4R+lyeIVo/
xwQpgYvN+EFAkVPtJfyOXf9TN8N4jw==
=UFx+
-----END PGP SIGNATURE-----

--C53RmCkSuzJ78xCF--

