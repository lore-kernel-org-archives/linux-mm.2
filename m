Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB6BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DEF56B0194; Thu,  2 Jul 2026 21:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 896386B0197; Thu,  2 Jul 2026 21:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3CB6B0197; Thu,  2 Jul 2026 21:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 548FF6B0186
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:14:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B4E2140156
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:57:45 +0000 (UTC)
X-FDA: 84944443290.07.145BEC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CFDC18000F
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:57:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcxGVgwL;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783011463;
	b=GzemrC+FAa2fYCGDyoPF5VwB+m/GeJ/xCnLLJ+H/UNIWVk/fL1o5Bye2VIojg1e6+Iirxw
	wDjHC8L6E9EpFiegFKoRPr+byDU9WWXm+GO1M42pppuk7sFfqmf1ON1SiT5o6/A0FMMDUJ
	8Lx7a86S6kN9gkDMdGQHLIWzFrZHri0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783011463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRV3IU/nJOOBkdz3JOeGF2J+55dN/Yx6rEks1dsWHl8=;
	b=2DJ7LbcKaHs/9O6YVOU+19db1RjVhgrJzrfFjTRBQHae1FoDFlRGuKItdyfHeD2/qLcS2d
	2jCwXQqIZTWU1NrawnEqCq9FjTRbZwpgiZ09fQUGen53ImRED9YS5GTSFW5J77MlPwR/l9
	xA2BzaT9j4T/WSeHxXVa94l+0v4wqnU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcxGVgwL;
	spf=pass (imf16.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 919F342DD5;
	Thu,  2 Jul 2026 16:57:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A740A1F00A3A;
	Thu,  2 Jul 2026 16:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783011462;
	bh=MRV3IU/nJOOBkdz3JOeGF2J+55dN/Yx6rEks1dsWHl8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcxGVgwLd92cC+zOlOC1vchZEg06y2/jvTQO8oUV3p9CYMzONWU0PZ4ykv9QMouuY
	 3pRfK1LQzx8Q0x9XvfkCYWFUnFFonq8IMovlVTrqZ/ucC3i1wbasxil060rkivpJIQ
	 FB+YarFXyMQJSfkrfE0mDqU39Yw0RSw3AIloL7wH6+d0AjyxipeosixGtk83ejWFiU
	 5hHoIklBc0jHJGYDn/y3qfpKJfqQMQTAcCKTHaq+rhdBpB1IkZ3E/FLaEBYSLBxUdE
	 kIQ5BzkaKvWnUACPUwzndydliKCyaf+DdKNyyI/XsF5D1HNUI8hMdmufsPuKS6XCVm
	 PMY58zwiv7O4g==
Date: Thu, 2 Jul 2026 17:57:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>, david@kernel.org,
	chrisl@kernel.org, kasong@tencent.com, ziy@nvidia.com,
	linux-mm@kvack.org, ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
	shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
	npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev, linux-kernel@vger.kernel.org,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Message-ID: <b110c415-c9bd-4e70-ba49-107e355477f6@sirena.org.uk>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
 <20260630125024.6c079ea708630d99708e26f6@linux-foundation.org>
 <akTJsCTKZ5hMBf5V@lucifer>
 <20260701164613.008aa13cb6187ec9597bf652@linux-foundation.org>
 <akY_L-yuaCXBOXb3@lucifer>
 <akZis7j6xSjl8K_D@kernel.org>
 <akaXQyFlZi82SePE@lucifer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TZddaqxKsX+xRI4T"
Content-Disposition: inline
In-Reply-To: <akaXQyFlZi82SePE@lucifer>
X-Cookie: Reactor error - core dumped!
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: ixe3ypk66k9esub5o5dhzxycb8y6g94h
X-Rspamd-Queue-Id: 5CFDC18000F
X-HE-Tag: 1783011463-694070
X-HE-Meta: U2FsdGVkX1+NGmWOh76fTHzAi7vPgYa165bGjpC1cqtioJuJLTA3VsTkUdoRICLNpeWwsDiEl2Fy1xgP9JqeMktLUZ/uk1L61ezgr4qk60K0lWXRv0y7U6TU6VTBTXqp+cvh/nQGFFX74od9232DvqbO/+ICQUILVnc63WcHHys68uqCD7unTGvU60BDyBkNtTDcEBL3Q2xnOwfc95j7xo6gu4Lhqw0MHrYyqvdffLaA594+vSRHs/Y7/vj7ETthahxGiZWfu3+v35Liw62MaejeCE5sY3CdQDCPQGL50wjI7akDfceI2NhK24uB3KyMz6/J+SrfOuL5J5Zs7+y1gDVokr6Ezv1R1VCb7G2DrIAQ1IVv/2ghzukP0ybp399kEqAEmGgAuKLl87QMCFxHPw1poc9k4OqzcmBcG3VtgJXB2qID+88YeDTSyLXnri0u0PUi8HTkUZG4g45q5oirVnfvXhUuDa0RGUp/MYAIIMmvA+hFvVi5BeMP5eLozq2LTNiLwb+BsdGx4l2mAxlKuPNaLHJhdamrvLhZWqByY/nL2kQxVu0TbRIM6HicZ7UuZvlrNLegJgIXSCU9/Jv284CInOCmEtcQh8bJ/yDoumjVTVw0DCoWnYZiEUqocVi6prBUVlsq8Fs+tnApxVIx+DTC4+AEKCLHT8qgcrlhfrX4M1QVb/xUqfjIh5m+wUj7YDGOnSL8Mv6Do0MBkwr/qqy//mmUltzPKMP5XEqFvP4nfGIQogLatJl/V+2giv/RIlmF4Gd68WHYSE/lyRNU+zBi9lhrK4fYSuxAZMUdIiuk3XCst+icaSeBcakIyKP6tvbzwRvu+NGzvhU2mHAKeAYcLEp4m0Az12I0/gRYQpl8HylT4OJwc8PpG5rmBlOeIiDXFcswrRxYR9XxZb+nuDQwSmem/EHvfdmIOft0AwtxjleqKd9pjXi7BxkHbkniBgnQRYtO0sB9gyKFDj/
 6cGtprUG
 7Aunree/WRigpiExPk8OERWToRRxbkGfgg0xlCBSBSS2rD6B9X+DmIR9LJLhOLo4VfyRz4u2M+lyM77gVC+Q+8hM1QUcNDwwdgu4dcqpvd1ekOXG+/Hm8ukN4LOCWuIOej2YDo1Fp7bGGZKl/EVfaJF7aX9rR4hlxtN6mFHLRXZp2S72bpkkNpk8mqp8Navhnsz762J+polHyR8JDQzK7bK4MLsZk4paMOakxU+gq+eznCCBmKobWxcZGMjvBlz2bAtODSnaOlZ8CF0sf8PuCeRvefk9YjehvYeF7rorU2WQQKUF7UfX7ehYg/LyyocEP7iQR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--TZddaqxKsX+xRI4T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 02, 2026 at 05:53:48PM +0100, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 04:08:03PM +0300, Mike Rapoport wrote:

> > I can't say that CI I run has a great coverage. I don't know what coverage
> > mm-new has though

> Well we're very grateful for what coverage it has :) and that's nice to have it
> work with email like that also, makes life simpler.

> Mark - are you running tests based on mm-new? I'm not sure where things stand on
> that?

I currently test -next, mainline and stable plus my own stuff.

--TZddaqxKsX+xRI4T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpGmH0ACgkQJNaLcl1U
h9C0nAf/UQoNzDM3eHeEBeMJ1UfQVPlMdjB3hzDkfokZ758Y46eIVE6re7tsso9N
YrL3lfUBLUf8ps4G+Nc4U6Avgs/DnPfsU3HLyM44zbDKrGa4XwgxVguvGqyiBSUq
ERRY8lW96ma5hj0Xe5dtqvZQTOK7rgp2REhidIUcN1pHbT6UBzM9bhmO5EK2rqqX
UMnChe0BFx1JgsVqZADDJ8uIckyOH67vijTkRlD03Aheb6GLksiDk7FTfi3oBkFu
lYI81UK6TdIQLb/O8rKzQofD5j6u/iBvCiKQbvfSfMX1gKP6XFK6RFdm2Cg96849
BanW0cpuNWmwxxm8x3dBOuPaHtSnoQ==
=UPx2
-----END PGP SIGNATURE-----

--TZddaqxKsX+xRI4T--

