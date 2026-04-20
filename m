Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 790E5F5A8AA
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 18:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AA96B0089; Mon, 20 Apr 2026 14:09:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1D36B008A; Mon, 20 Apr 2026 14:09:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EE66B008C; Mon, 20 Apr 2026 14:09:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B59536B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:09:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6642A13C00A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:09:46 +0000 (UTC)
X-FDA: 84679722372.04.CFC3CED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92DAD40003
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 18:09:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbeS0smw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776708584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lqu7gVxDph9rA+RFSYbNtE6EvF6ZbWBXm7k2cxJnso=;
	b=CMyaGGyEBU1POOFJhYLNNOocx544bunk0jGxyeCJ0Ou6N/I7j3gUFOsOkckqn8H9ioDFQs
	FXtzBPvuxsOUw/MRcDqQrnJyA6IwIn3XxEBKVO8Owfr8bqISQIXEVf27TPfKksMBbHY4G5
	416xDMbleDsnkytmRlHEDNN8+LSYmyc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZbeS0smw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776708584; a=rsa-sha256;
	cv=none;
	b=ucmZCtwYjfhWThGAez8ZJSJNe7F8BJLYnvC7lRcOKaRPNjOuIS8IqEftjSxCHmu+jqdCvb
	3UaA8VDd3E+2Van4aTyXAHweVvxjOIRW4Bq74g8hcCT2FKXzmpOhmTYZUMs9cwQ9O/IRX2
	4VIpuHH8a9XJDwG3NOi4L8SAfK99eoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B62E44582;
	Mon, 20 Apr 2026 18:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC90AC2BCB8;
	Mon, 20 Apr 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776708583;
	bh=5lqu7gVxDph9rA+RFSYbNtE6EvF6ZbWBXm7k2cxJnso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZbeS0smw+nBW+utwOMzphiEHf9/5NOi7pPk40Sh5zyPTfRl7IzKoN8lk5ULyzEM2g
	 zTdxdFAJ40kTCu4Ub+30mR6f5raGwr7fM2oKq82KUbbm20nw0gCJT4syLQBv6yx+Dc
	 jsFSI5rbyzkkPyCKwCcebpegMUVCfHCpgpcK0aoLz97ntSJKYrMTyjwozSTtBD9WQs
	 KftuTZbiVKiM1bw0UTNskULvxbJg/eo/x8ba+xaM9E+yAblx0ug8+zJG4FNHgizDLG
	 9NUTU9yHEHSBGBoQLXvMI6J34ESlSZaezaUlB021ZObC3hug4tF8sdhhnbHpSqTnn/
	 OvrCF8uEaCxhw==
Date: Mon, 20 Apr 2026 19:09:36 +0100
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
Subject: Re: [PATCH v2 18/53] selftests/mm: uffd-unit-tests: use kselftest
 framework
Message-ID: <089df1ee-59ea-4333-af17-f4316a66833d@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-19-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9Yx+TiVjhCn0KM6v"
Content-Disposition: inline
In-Reply-To: <20260418105539.1261536-19-rppt@kernel.org>
X-Cookie: Sales tax applies.
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 92DAD40003
X-Stat-Signature: 3c886ye7haf7b45b6aen1mzj8nsb3rdx
X-HE-Tag: 1776708584-698166
X-HE-Meta: U2FsdGVkX18GdBRFOckucz8dt0DuaxdkHK99xZ0dkfpEVUmEFsou0WOW8Zt4MSU5D3MhhGg6mQiyREkQgxy3WZ8Kx1/Xx89QlMHDBP1FiMGl4sJBEZqJ92nUA0ZVttZlHmJgM/vwtTTAR3WSOfDRXK8QVkDmSMpatnz7LyUjHO/48jL8+iYl/5AwJy4s2u5jruspHwxHoafwy7wgspH07XrN2r3D2MFoZ1U7/RMB12KijwmMw92rT+nBuJVfq71VEHqh372YEx4+uckLfBCGlsp7Xw7wXeC1xew8pHIEI8gCZvOrbTrwmYV7KtPgIDwfpXJN0fU5BK/NYrJ7ZMQpLPwKeyoVM6fYbx/G89SRQ1sLC/u4M2udB+0cPLiWM69wHiZB1kUdYYXgpXpMHF2jBaTpJguZuacFNmSyl8TQekum8dw/KcxO1heWNfQy54xngDTzQWECU87roxIzKD++1LoM5t3dQtKEvq+rU6xhEZ0DmpdRXt9Tu+AlJJM9wdB5ZVaCrf9oUniTbO3InXXid72s0hU4n5NrWbbHNeX1b8/Vz/HdpRfsg7Mi9qEtCNy7Xz6BI/sPSiUIq6J13NXv2NF33CtyCC0ZX9/Twne93JCdfEDObN3FBRl36SzeFMesMqIyCObLS+rAlCuuAogDdGFF3qnlXiVMCRZnHw1l9MqccHnxwlezBB+x1/xIiyazngGXiMZp3zp5IdIgzZDDBUKn5Gse+hPsWPc8u/u8Y2nT4gJGq+8mEtAZsFE8oDLiFBSVpCt21gLoXi3EUdyE+NNn8IT9b+Ql1EoofB2ICV7/AOK53ZmjhkcWNcMRzBNuRuAhxsSvWSMVwUzMLGyrpyxwINGfFscciewyraArph8Xxza6/v/K6xt1YSE/A0iIN5m7GBklUfdyPmAPo6y0lHJbsOZHdX52B47H3wyw2izJd+Sdh/xIWPUgdEJE3OrqLw4FStEBkze+Hsu1wQC
 DdhoQnNp
 jxTbb6If8JpfVmHJWCaeKxCmDe4brNBxrCPpa+lOob703AeY7U+47FpCLoA41IQMkatGAsSRP8Fy/MhiQl6yaP0YtALaDzkdHu8fWami+B4G9+9JM9r6/VlOXZ3gbMgdB7aCiyLYgdMwhUvFeJYusvbDZKT+kt8t9xySyp/KCaBnJuL+E5E7crCmE8zYMnifrd6coStMlmCjt5a9PRAzHLPd1xV/o/hmTFXW68TWlIpcFTyz7BZBL3epkDmF0QtZHlj2q1SSRRFisyxbp+3gdLSzJGTaqdExfYuNjdQY87Uvr3aOGCwv2uJSrb6LkEGljJst8Ng5kwZG2rP4wNPoIk04ceODgB0cNOXcZqs/LXuX9D9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--9Yx+TiVjhCn0KM6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 18, 2026 at 01:55:03PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>=20
> Convert uffd-unit-tests to use kselftest framework for reporting and
> tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--9Yx+TiVjhCn0KM6v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnma98ACgkQJNaLcl1U
h9DBHwf/XblVSuDksuXGMxVxGmW9m0Ph9Bysu4Tp38cfVfnmD8sze3Bo0lG2K1IL
dkcpJSTVZXuuXVsgOL3xB71p9wTMsa8fbBUGT+g9HQTjp1QZ/ifqBG8roiCZ49HQ
l8ot8QLae3oxwK/CTnxdGqd0Uhy4MGyVPDr1Y2n+yGeYDpTLv0P72nlg7E4Sv609
nccgj3Jq7fBhwE2MzhX7xJIV2oPdssWCc6LpVZW/wSl8YARJuqFVzTBzcv/bAPpY
huTBAQ/wG4VqeAWIzVc+eu9ni5DwUP/c8c88SKTOMaISZd3whpEed2/otOV8eFwm
TCcPS2fYQyBNJs9KcX+39OD/eecmVg==
=WdXE
-----END PGP SIGNATURE-----

--9Yx+TiVjhCn0KM6v--

