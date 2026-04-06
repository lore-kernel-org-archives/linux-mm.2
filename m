Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FDDAF46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 15:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965526B0106; Mon,  6 Apr 2026 11:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 916806B0107; Mon,  6 Apr 2026 11:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C216B0108; Mon,  6 Apr 2026 11:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 707C56B0106
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 11:06:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37F3659000
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:06:11 +0000 (UTC)
X-FDA: 84628456542.09.822EF48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9366310000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:06:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2ot1zL4;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775487969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t42c+RqBRpyaInTeeA+to+5PYImxlWv6emwwnUORnx8=;
	b=x2DIjxpcYhds6a+HmwvtLkhtU0CBmhmdbapfN3zRAmT8KvluMg3B0fmJs+LGhPyk3IDyit
	3u2zZNI9Dp6JWvD1cmdgUiEn7BEy3Gvx9U8Vbnzsp0WqxIGcP/W44kemRePxk6VSNQJePN
	gJWIdBu8m4sxYAs59S8ZIR7B9ZjPxII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775487969; a=rsa-sha256;
	cv=none;
	b=v/kPJ8XZ7LdcFSt0i+aWuP1VGKJuJ0OXOjsWmrNvqPtCI/COAjjhb3ejSx0XxkEuMnCIYm
	W2bH2BHkHpktgWzfnDZNQ7DFw/tzngP4haURKmlcJKNzdQrYsADIqgUuhhmABA97ZGGX03
	ksdmGHW9eiCGYsQ0shS9HPuTbLG6RQE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U2ot1zL4;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 95B7C402EC;
	Mon,  6 Apr 2026 15:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59580C2BCAF;
	Mon,  6 Apr 2026 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775487968;
	bh=t42c+RqBRpyaInTeeA+to+5PYImxlWv6emwwnUORnx8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U2ot1zL4QVHwK6FBuamuF8/bGasFnCjqOeOfYa+xuNtF96uAfBzVgKydOk8g7kMHX
	 eIdu9j/r2VtKeQNapMwO1XkyfVsXswouPHGFUAdnSOd5Y0bQ5BkKufLQ9wl0PpyUr8
	 /3Bm/ebzpt8S+a0EohyZqkwiJ+NDImcqGBH60G7nvQdOwhYUvDrB1pnmje/fStiQfg
	 C4oZJMLROghBi0RQS4bXkxavQe52Z/0WVU3asy7pEd8IQd74PO9LuWvco9Az6Qfnyd
	 JZleqF7UpcUAXmPm6ArVJPH0KGHH0Fk0CNNmQ9m+qvF03pV5CRAT6j5SyF/BCBWaVx
	 mHC5XF1gvVlDQ==
Date: Mon, 6 Apr 2026 16:06:01 +0100
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
Subject: Re: [PATCH 10/53] selftests/mm: hugetlb_madv_vs_map: use kselftest
 framework
Message-ID: <7feb751e-bf2e-49d9-b8a2-c5d3966426bc@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-11-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+GcDbzDnrxvyAWYm"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-11-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspamd-Queue-Id: 9366310000C
X-Stat-Signature: icn8s1wxxk5hkcxak1it6f8wgb96ism5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775487969-885616
X-HE-Meta: U2FsdGVkX196B7dY+rmkXbVS2CQTrdv8uFYy6u1VpF/CaH2pxSkR/aCbrCr1nNdP1K6eB/dZnEZpeL9Gjr4d+uo8j5m1mY61LZ9eoE2gJ+m2CUn34Shi4EMYcEvEgdclYq8fWmz88IX6u9IZh86GJ4U5lN3WJZ7ID6gPNWnW8OkZ7OldAfXEfEcq1oIOeeoYTyLGbNl/DD/PQq72Av7kk+1ieGttbUuqPNIgQV93bX+lJ/CmE/FvMdeuU9VHcfFhJpWNbY9fB1HcHoh+OwfDP5kfzY2EvtsfhTMO5ufSPO0g3jWBsqVIgmrL6rb2Sp5mFuAfF63Lh1z5v3quYMV68o1K9uqsHY2mLPba0jtpa544rGAIgOjngLVd0vsJFxjthMn5IScxx3NJSrNRXvg/5CC1ZfyEcIkWATVGjIJKjc2VPRQuGPuC6iKoszZOVLHy3aRCDbjcMWrTkMBS0sbock8XLtJKW+7Go6a99Z9RaaR9xPSQd7ILAWnPRjQ2BRev5YQskeywPWxwl559KItRwKpHrHYM+ea9HIk0DMS9swe2vPH2ckZGjZq4qNAH55WeZT3egt31I5Eg7xSPFvklfxaGC0ZLMpOzpxVO9Pf4fUtxiw0bTtusX3/U+y0WhsQvkaX9bd9I1oxqOo/OVigF0bve4uzcOnyhSiiMWZNt4OHJQ8oFvtzbA6V8X8onCsCpzCGPU0zrM15vxiK8WkjSGOKuzeBUqJ/ZqVk7MknzPEJNN7ptmiyHrmD42whCR3pcpboSU/mj3uzhvlf3Iwmia4vG8lhwaasYPuwhJqB+wpAk+UaiCRwIwVGoMI+tx9zc0LqLbT27OcnUhWgzTsgMg13hd0IQ33A/1cPfg+xf3ZIlk2pC2mA++Q3uc9Ao29vjkSb2GKgQNS2HXpxxvu3T730lpQXeyxEi5ACyT44+H6WK4e0pdVylS7gjYpTCS5KIF/6ZJoJw5yTZpKrmZsx
 1u/qCjd3
 eJud3MVa5FW8RdygO5Fd2k9BUdJ6w9pElZT7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--+GcDbzDnrxvyAWYm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 06, 2026 at 05:16:52PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert hugetlb_madv_vs_map test to use kselftest framework for
> reporting and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--+GcDbzDnrxvyAWYm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnTy9gACgkQJNaLcl1U
h9B6Hwf/TtciNqmmdW23+J3jS55anwwkpx7DorOTejFXA4CO/2cM+8JECjQLsDGM
rs6BBYo2feVBtrhVI800l0AdTKRuqMeyCmFpRA9p7fx3SM3ILhxx3RqNp6Blt2hI
E9iDZ6EsPi65lPSgy1aZNanJxdSypJyUINBUQFWFWxU2/0J3gp5VzzRp7+SGySIx
YfUmOitZHkhfUeNo+gvKjCyKNmdXqZE3nVUbhMtcFbUgB1koQSVv1sUfemnqTumo
171F+EQL29nieTz6kBa4N77ljHR9RlZcSZsUZ6kdx/rwJAobIYwcftFMbtGDmq/I
nCn+lhrSGcUVN7xPm34rn+5hW1uE5Q==
=FC6O
-----END PGP SIGNATURE-----

--+GcDbzDnrxvyAWYm--

