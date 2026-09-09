Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA287C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09176B0095; Wed,  9 Sep 2026 13:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9666B0096; Wed,  9 Sep 2026 13:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA896B0098; Wed,  9 Sep 2026 13:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5F246B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5752D120265
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:34:51 +0000 (UTC)
X-FDA: 85194923982.22.40CE2C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC45012000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:34:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mvn54j8v;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788975289;
	b=RkLbXUh+LaZ05PbQ66WWG6/CStRmxHB7Hoz8FX+ibkmg+ICJny6ZUsSmd7gMjzk/y6I/84
	i25+P6nBdOnXSt6UH12fl1O2vTVggU/sQg8fWTDioYmquhfTu0WUY2pZ+NMcAHP8Vd4xOF
	XCqTp3wX7VzuplF82VNDZIlLRQPyw90=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mvn54j8v;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788975289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbP+LPyTIrLymnPyx3C1GnkLD9nptQPBrDixZ3LBabw=;
	b=KAbF7OGcEcZ3v3Lr7aqQ5pC3nx2616oS+A34/WGlNrNtkarfGv0/tXvcyNa+t16KqEa0yH
	LehSZ9V/+40LMkNgQkmOm9g6WeU0pAr6/IkESbjJneEf1Wu2ry+aM60zyIVu+wndKUanMp
	IZu8EfE8L3pr5n9Fzocsn5UXO6Pdx/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CEA36413FE;
	Wed,  9 Sep 2026 17:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC471F000FF;
	Wed,  9 Sep 2026 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788975288;
	bh=bbP+LPyTIrLymnPyx3C1GnkLD9nptQPBrDixZ3LBabw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Mvn54j8v2Vk5488SjbF3KsiKDQLuwtMXnO46zlphInEv8sn11l2eqbEMu4hGV61G+
	 cx+rU/PkBan/NnZqIXabA8qJDPBHOTUt039zgnfB9DB5cTmmHL63kqgkx1M+I4AVor
	 W5EA9xrYavVIkzMe1fnHc4vuYGU0spJrfYPeIh/Q4akx3XndXio1JJ+ba+xny17Uiu
	 hWrLtFldUpaAhx1FNLzW4iJFbOr4ftCV0dwi9WOGNLK3CmItekCctjwLeWKTMr5T0p
	 GjU0ESvBW/Uofqzu8k4MvE9a33DRHUGq1007291ruVV8ntHY22Pckl1EMBDi5SR69n
	 hdJb6e2ACj3eA==
Date: Wed, 9 Sep 2026 18:34:40 +0100
From: Mark Brown <broonie@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 6/6] selftests/mm: add a GUP selftest
Message-ID: <07dab220-8497-4eea-a4d2-b27a6e01eaf8@sirena.org.uk>
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
 <20260904123631.198697-7-sarthak.sharma@arm.com>
 <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
 <5e0b9365-cbac-4f2d-b915-85edf3093508@arm.com>
 <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KmRz5TkdMlywIsKu"
Content-Disposition: inline
In-Reply-To: <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
X-Cookie: Postage will be paid by addressee.
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC45012000A
X-Stat-Signature: a7rgggd37nmqk59z4i1ryw6ybrbskta4
X-HE-Tag: 1788975289-338427
X-HE-Meta: U2FsdGVkX1/F8hDSZLxe7Xoamo8BTlS0U59QkjMPKqAydT5E3hsmaYR1A3TWYfOAQOS5lHIcf8ismX7bnboDDENZSIF5iXNgvI/CS+cTr4y5yq7bcr781GFndaZtMchaQF6eYyk+/LbSwfwL/YEz0E80rjsYW+eGnQPpEBa4VkXnzUCTn4NPpR24UhbV8ITZuXdsgaHi+SKLvd3lE8Ot66ya3KSUjkz1Msf4bMLxXXA8P71ggqC5weiRZzrmyYAzT3m5etQtZkY9tiPwDKjfhi3uDDIoiZyIvxo7G7uA86mzgXhqofpa5GZqS5+BMvVeHmEPdfZi+Rq/gZCyW0qw9ZIqLDYzbhDmcCkQJzQKgsaHf1afsFeZU60jVJwhKBMfXXsGw9Er00nbyT8I8H7vGxTMGh6UZADATmHsmwcneLAvwPaat1lpazxGDN+lGWC1D17RcZujUSBKaSCaU6jx8m/h1dI0fAWsYkZy6bXdgxLAnl2dTgNP/1VCgpDr0cW132jz2PFVHkJm5GqheBMShEshy01VBPCFPY5Atx6QCEaD2C8RrOcBBWFFxjHktLS+81q2Oc1hYNdqs0qdfiENMPZ+FEYTugWh1gUsAF2sUguHKtsvvcqniffE17pQqsaLzPm3smUiNSMCIjfb5pN6qQZo3dzaBDpGMh9NKYtJYv/zqjy9MNODQhb4fMFTjgqYW106VZWJI2Hb76u9x1T2ZlsbXKBFlQdTBAia6Ra/oiIo84fwlmKWR87LmI0PbC2L0/n/FrwBShwzeEi0yPna9BS3KwglSo4pAsyjfCm295qK9EogZEoxNsRZToP1FUgnVJLmISI3Kqtuxeyqfvaoa61KxIgkxgrV3KryKoOtpK3QldbKBrlMUA0Ri7in6OaKoqbLS49jgZqqtXsTZCfS3++7KuSSuG9OJk9+xSTfpyeaC4H4CWsp7rAyMVJvT5ciT/DT9JX5zqsnTrTYPcl
 tOpKkDbu
 UNbgY8sA2/E2F9wbpqlkNT2PwRhwuZfaUgas2xZH8ozlf1O9vP/Elg7K1UBefV7v57xg569SIyYLwVs77knjPfM9/YN5c8ip1SICpPFLwNBB2Y9g/0R1vU2FIcY0+C5iqVQngT/oEQTQhmVKaTFUrLH38vJMRBZuW+JR+l/VOS5StyWwpzgQt/tgIZAT+6LL/e0gVgKbj2H01OJEkeRIttEl160Ro7wGXcXq5/Ho1Cvd4SOC6/CVZVUOWeZClLKiTCsKpGigW7YsXNTbqiWo0RQu0VzYLoWq8MFkfX8Uh61MmiMBsFV3JFNRtJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--KmRz5TkdMlywIsKu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 09, 2026 at 07:03:59PM +0200, David Hildenbrand (Arm) wrote:

> >> 2) Move it to tools/mm/modules or sth like that.

...

> > This is an interesting change. We can keep this open for discussion
> > here. If required, I can work on this in the future.

> Yes, we should in general try moving all test modules out of the core.

If you're working on this please make sure to take a look at how the
various automated testing systems cope with modules built under
selftests (personally I think everything I care about uses tuxmake
builds, but there's other stuff out there).  I think the answer for a
bunch of them right now is badly, but I didn't actually go check.

--KmRz5TkdMlywIsKu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmqhmLAACgkQJNaLcl1U
h9BPiQf8CxE4IrSgHLYMJ5iNReJ7dS+KVJWt7vcB5HxJrCVmeLsaDp9p6fQbIG3d
P14bK7/go0oX5sScOruE0zw+rPFYr7OiSZMDNlYwLTXLVLz5PWrn9r25tDHWeRFS
F3oy5EsiGyp2GxAzVqk7lqmr/AEQGc0M2aN6wcn7/EShuAb51IHocAegVLZe7EJG
1jGpOfndf3DfYhtwc+u4QxnCDlyx2JEG8zhR6cPKyBUu0CxxsWmEC2rhyIFk5ruO
r5qdgt/NJpq02ec5v+V7t1GD61kzGf3FkcnE74o1WeSQ3qOo388w0Z4lvpLZUZ1e
gCvwOoLhVYcOoMtO5UCnK/cxc0pQyQ==
=tKSS
-----END PGP SIGNATURE-----

--KmRz5TkdMlywIsKu--

