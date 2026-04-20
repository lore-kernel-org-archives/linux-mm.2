Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB3EEF5A8A6
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 17:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E109D6B0088; Mon, 20 Apr 2026 13:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2366B0089; Mon, 20 Apr 2026 13:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7AC6B008A; Mon, 20 Apr 2026 13:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BECE86B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:51:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87EF48B4F6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:51:44 +0000 (UTC)
X-FDA: 84679676928.06.5814D43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B09A6A0017
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 17:51:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuIgrQaN;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776707502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mY3wXEdJYqtwFobZpfSvTxCXivXipe897zMwAWd+YOM=;
	b=RRkN1gO0n01Y9joG5w1/BC9OonPhDq4+dvB7QRmJcvOYpyv3b+BpFOCSGxQZpRtD7TEF0E
	uU6pA4395NhEBdmMOOo+KLNYdvUJ9UJxh78zamOHF84lLjyUNC9Sdaie/gqKxE59EW2VMM
	/qR7K4hjWiQQ2nSW/lV3jRPGroyv5i8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776707502; a=rsa-sha256;
	cv=none;
	b=g/y+20ps5xKZKTNOj0YESIU1mpgNHUxkq5OHvIhm+8eg+cdcnGtQIUIz25iDBP6Z14CQfe
	HKWm/USkLWSzdGG3wlGA5rb1c3a2n5SlcblixJ+aZLm/VIaf/GWe43AkSKen3xLl9V3oyU
	4jW2sNL0zi1ejVjMTsAxKUtBcp/vE6s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BuIgrQaN;
	spf=pass (imf15.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FA2C40798;
	Mon, 20 Apr 2026 17:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF285C2BCB0;
	Mon, 20 Apr 2026 17:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776707501;
	bh=mY3wXEdJYqtwFobZpfSvTxCXivXipe897zMwAWd+YOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuIgrQaNq4uoXEaCFD2DpUHqay50D6HKzat2ERmkvo22WJO8qePCU2ThNrGznmVh8
	 4Lv3wLdIuiqf66HqzGMpLojU/JfKR6rmdJdLrVsh55ngTYUHMU25FyfZHf51KM3NEG
	 7UGFdmb8oFRd/edkLE02HpgxWwhQ4OEX5IQlCmex1jTn0Pfo8KEbx5MIdXjgIiXRhF
	 XkQeaNkF5Qd5RAhoMxUEnqtD99gE5jLH6fzivX+5la61UZmaJlmGGnp3fPmrHJi2pR
	 8RthTZ1tJcWOI1GFe5GQhvxb+dl7zv7NuwW4ALVDVNLRRnjpq4mUR9Y9vx/EPU5tnq
	 FNkdnqjPuPTEg==
Date: Mon, 20 Apr 2026 18:51:34 +0100
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
Subject: Re: [PATCH v2 14/53] selftests/mm: ksm_tests: use kselftest framework
Message-ID: <16b3422b-0fbb-4710-a2ae-db708346ce92@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-15-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YrrUwhb8sA1+ksjl"
Content-Disposition: inline
In-Reply-To: <20260418105539.1261536-15-rppt@kernel.org>
X-Cookie: Sales tax applies.
X-Stat-Signature: ahadne53inmrssfbkd548ogjm1yfyn5w
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B09A6A0017
X-Rspam-User: 
X-HE-Tag: 1776707502-989089
X-HE-Meta: U2FsdGVkX18JJGSP31mZ+Nji7rlo4QX3XS9DwbWY2yDJ7f3wz1gWs5Q5G9KYbOZuA+f06Hz/n7+CUgKJuhw/HTty5AV9PhNc5idpCeudwe2ztgRH+rLaxM26DzkzI/wRA3mEJDIYVnr8KvM3yl7YQLgVAqtC9oXe792fQaCTN2ePR+Pxb2kP7mrj2anWUXDkPsbH2ZtMk5M+g5FKe4VeszxohtLEscLzyVzyNwjb8spflF6HpXX8fnmDNNpoXexu44LlgScQxwQBu+j0QdRfnvrxYhT7uNZEkCR+ujtH16uXMOy6rJepTNzZkWk8SrGki2hKBHsRq6AC/4+XzJxulJ7u8AotiKpz1VzugPO1IebEM1eStWE6w/erekknsbP4r6JcSKQJmYoYqBj7/4FyIEXibN+NEuxRuL4BQjbY7iqdIOIs5OFNoSedHxGovxslszz45y5HakVQn5k6tJgqZM+c3CxKB3asX2pWTsK8cdOx/ZAE/4BtSkuhXcbCLvj6LpB+Z4Q+0ZLxU4yUDwp6Qr/f3+3O4sZCSBf5/W3M9P1IxQFusDn+gav9nQEgjjf+LDndzOQOjvOU+MZihIT+Bwd7IVubeW/za6Ket63zWWiaJ1MQJEz6DMxcnGEeFxrLhuzuUMEZkniD++x3jKFuDerMP7C8raHCKdXMGsBRjHYnzwbAYeoBKs+mO76/A0tyw9JuqvcSkzBiK0QjwaLP7L5byB6V7Ft9ltstNwLVq0ZOQXrmIDjXdmukDERZZu3bQa8jaFuac86E5zxaSidlIclgov5oYAvPLUAsMYpuCcvDzLmOqi6/1qnkdvg+SxxVm9gWt/G8JXqjmK6mRmiAgjriGv7k7hupcbTuDHDjdaiSBWhkg3j7dwNCS1XscfsQ2pSIUDaiEras43k5Rlmhyi8wEllrwVeUdvXF8eSzwdQXKXKY4HhTM0I0m1C9Exi6opmkP6tt1POajI8rmOQ
 Lrgo/t+4
 SCZGptFecLlM+fxJXOawLmNgrucI6TsBCMKvnQyQV/BlZA7NdYOnkedq3AO1+MkR5MunoNu4NvHG3aEZ8VkXbBpXkKJ+/Etbj9sCGXLic4tWHKtBIa5LTM9E1+u24euGHxxS4vSJ0wIz6gKMbSzyt+V+4B/Ft2M2thoaPU7iUG8aH5eloHXnG3vGlX0K2eih5oDSOK8x+XclrbhFxUktEznOHsD7QR9wQC72gCM94tmkc8neHn6XIxmnG/NzfiHaULaa2JhQGrWHy5nQGEeMWzpJqlQ53o1FxhdDNpPLKqUexXyA5FhWaJ6SrV7ZuilCgtZ01JBjgV4tMLBFUtWa/KtO/0hhVLpxasSUD8i1eR5nQH8Wg+8SsTd/2tdRsVoaHzVDDbbmTX7EDi93nYzFFl+RyoBuXiuxG0Ml+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--YrrUwhb8sA1+ksjl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 01:54:59PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert ksm_tests to use kselftest framework for reporting and tracking
> successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--YrrUwhb8sA1+ksjl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnmZ6UACgkQJNaLcl1U
h9DS7Af+LE2J8Vug2BqjVkH/zXOkpj6UrkW7RN1F0jc/3ZuqQ0expDQl0KjOVFMB
0gbqY0roNAF5hs35blJEVYKNk50YSJUcgwPlPI8RYU4I6YR3Jo1qdsuorbhZrUT2
JHY5BBrOtyH5lowILhNNOFwa8RFMdgP7+NNiP54zO7Iv4FVYYMDZPGEYaMAx68JN
x5WIm9U9eKKtnZ5z9h9ALxS6zkCp2t9zecqAJkLh4bqhRtJUh7hsMtS+P2XyyDLN
FrXy1i2Lt9XmAiEDOzFQnKz0JPzKStgtx+p7Lr/6nLms3YICIZ5zPZKhOXWo/dpj
8gKv9vq6wWF4ecR88j1eRFClBeFhcA==
=ay45
-----END PGP SIGNATURE-----

--YrrUwhb8sA1+ksjl--

