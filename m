Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F2BCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D2D900160; Thu, 14 Aug 2025 09:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7524900023; Thu, 14 Aug 2025 09:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6486900160; Thu, 14 Aug 2025 09:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C586F900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:09:09 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70FC91DD447
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:09 +0000 (UTC)
X-FDA: 83775393618.22.6FF6A59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A74B320007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:09:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kCaNwslg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755176947; a=rsa-sha256;
	cv=none;
	b=LwuyVmVIadulds9dr6TAS/ijO0IXoP0KGii0q3Um2kaoglrfimN4yr7XqJB95GxxipFGD7
	G6RrjrZZvFxdFDUcSTWNn9yvZfHyMK0HdW38xol+n2R1/awgLThoKr2iXmuptfkCAcMO/T
	RSAJ/p23ntCiv1fsd18fmMqwc6PoZsc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kCaNwslg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755176947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQJMM/YYrs2s4WRnjgpQQh4s4aE8GYsNElMfYbBZ9r4=;
	b=3oOzyqDJufaXOge6lXkrVDCqmtzBOoi1MnZOds/2kYqoN7wpc/CDSUFvZhu0o47WkS4Csb
	LG/fgn1ZGAQG0uJiAWoq2gfxuMRuxQNkylUC5ISotJYtmnOv/ODLudj8cWcVLJkXU5wwEg
	Aejm80j9EG27kmpfO58FyQ/JSsvbPP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EFFD440BB;
	Thu, 14 Aug 2025 13:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5B4C4CEEF;
	Thu, 14 Aug 2025 13:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755176946;
	bh=V0/mzt7rpQ7Ja/nnjC462dZYJStiYQcl4BcFdcuXGcQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kCaNwslgBWiblbN70JZHhnR5rMobNvr1yRsRWdmRLk8CfXmjfDOFKtMilcgwfucRX
	 VeMVXVBYLCiJ3I8uK9A5rhZbCBO5DyKMWzaR6iU74ujFIK1PF2tUlV0MZwZC4MFwfV
	 T9npTDmENz+NZ/nlqn5WLnVUPCxEN/pyzmuaDXZkcyckKJ4thf38213tTBFf8fw09Y
	 ZEqOBWi+nL8MyTv1WdLnph3/Lz7lSTYVo20jjsUne0fWuxO5yhhhQcILxgJZr0P2Sv
	 zHHZ0qGsMIWdb/pxVY+kyc5a2GYdPdKp0R91s+uUI3uq4UJBCBKP+tgDV04sTt5Xti
	 6u9VjIh0hhAbA==
Date: Thu, 14 Aug 2025 14:08:57 +0100
From: Mark Brown <broonie@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
	baohua@kernel.org, shakeel.butt@linux.dev, riel@surriel.com,
	ziy@nvidia.com, laoar.shao@gmail.com, dev.jain@arm.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, vbabka@suse.cz,
	jannh@google.com, Arnd Bergmann <arnd@arndb.de>, sj@kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
Message-ID: <620a586e-54a2-4ce0-9cf7-2ddf4b6ef59d@sirena.org.uk>
References: <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
 <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
 <5dce29cc-3fad-416f-844d-d40c9a089a5f@lucifer.local>
 <b433c998-0f7b-4ca4-a867-5d1235149843@sirena.org.uk>
 <eb90eff6-ded8-40a3-818f-fce3331df464@redhat.com>
 <47e98636-aace-4a42-b6a4-3c63880f394b@sirena.org.uk>
 <1387eeb8-fc61-4894-b12f-6cae3ad920bd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="glbdhY1Z3FbfdGG7"
Content-Disposition: inline
In-Reply-To: <1387eeb8-fc61-4894-b12f-6cae3ad920bd@redhat.com>
X-Cookie: This sentence no verb.
X-Rspamd-Queue-Id: A74B320007
X-Stat-Signature: cawuzwq7kfwqi1bsegdf7aa77oh37ecq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755176947-575681
X-HE-Meta: U2FsdGVkX1/4eg+pv9Ka5iRUTQjDpkDFfr3w+IpvcD2QQhYG6OPp2+6733lnjalS9rQ1dJ3hJjOmtgLMLioFUpOxh1TDLAMcZhMtIrOKLuRZtP/7/elyr3byz3QVkNNmK5nHmdfqjHx55F53Ni0rZxMLnOoA8SU1RqVeHpohzuD7H3Oq5Uv09loI1jQYqXLD/OPdx2Wbh6FAz8IhEe6S46UJrDPYM5CFUQ74pRDgzuPL20DjtaO+cl9BOPlbcVBeGFTfLf8gulRjKKbO5h692Pz509JZUleAdo7os/GWBKm0RZlUz9bZew7jRxFj6edl/JXWcYc01OCX0brEBOOgM+1tCyIELj6vj6yXeVH1RcLjD0DuaaKPovDUwnrLVn8oEmUYPOxjyTIGFeVAhCoYeIq1norbE38zQ6/6oTj9R8tDmpEiGGkGqZ7ZQKdy9fhPxrPFeZ9JjboRQim4r16scOpwZMfGKinbMkSKteI0e/U03OBi3x/OjyWQ54lnx7dEVQ4w9JRN2j/Y6lo613rcUBGeFIHvQlJOBow8gDIT95zLvU4O86+rs7+Wr3Hh70BHPkxYA/PTA2KFm2XMqt9tuQGKq7570ojnqfL0R3LZfL7V+7BV+rOMHPSBSw2dC1GyPq4laoIGodz8J2K3dZUbfHni4EDIWMiWMA1dWfAIO89Cqj8Se5buQDmm1ncH2BuVQWs4skGqTW/LzbmYgi9rJQViKUnvYs4E42my5NAAQjB31HQDK9Fd31hHZWK19rn5RkPzXNDKp6/GBc4M2hOzxsFIJG/mMiLjhcmmQg9iW3ukwvzS0+7NBNJjy3MuQgH7pLD510EyvFTt3QofoKQ/zhx6ow7t7kGbXMTrqLnqe8BjVEc0Hw3UR/4JGMoM/ucViPurEYr2n+f69XORSfoYhDes4JV7+X2Z5b6tuLHbYu4KLctlul8sDqlwAvFRZPlb0Bm6wQ0AnwE4pez5bxr
 O+Wt7//n
 ZRDl9PMvnQXTTQeXHCcpl54uZdTL58r9s5Gx2hyygeEMBIYVcGc88NkxMT6JRPil2u2+RWepYQKa5vXaFQrLrhYF1NFRxrBkIwFcdIK/BJr3A+7DSGTi3IxpOYssIRrkCyiYZ1PzwoxnnXK0f+D8xEGP6aQr2AxJY+edA/TYELHLDFbHzJPTn4/zB748J5XtixgfZjwQSC2d5Ux2+SBKRnD9BC9GDysa/HT6NcfehbzupTjeDhmApaAlABsO3Uz75uqUrCyN9UnDD+Pvd/Owz7ysNf1l09OPex4oT/SBtM6sTIIi+GFhWaRNBrCdioT5AXhzy9ZYAKAr8YNvtCnPvJw5T43TksGE4Me89oI8UoLOpuh3iZwzbdx/C6+EXB8CGSOJp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--glbdhY1Z3FbfdGG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2025 at 02:59:13PM +0200, David Hildenbrand wrote:
> On 14.08.25 14:09, Mark Brown wrote:

> > Perhaps this is something that needs considering in the ABI, so
> > userspace can reasonably figure out if it failed to configure whatever
> > is being configured due to a missing feature (in which case it should
> > fall back to not using that feature somehow) or due to it messing
> > something else up?  We might be happy with the tests being version
> > specific but general userspace should be able to be a bit more robust.

> Yeah, the whole prctl() ship has sailed, unfortunately :(

Perhaps a second call or sysfs file or something that returns the
supported mask?  You'd still have a boostrapping issue with existing
versions but at least at any newer stuff would be helped.

--glbdhY1Z3FbfdGG7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmid3+kACgkQJNaLcl1U
h9DBEAf/atqlzm4RBPppUe6r1XpYt+RajQsB5AiYLmN8lTjImryp/2Gh23hCHlZw
gm22HJ5HZ/zAJketjugdDOiovu1RPgg4kJNoXy/tDnG/Sq1bFd9eZzu1QLKutztl
Hr2SbJii1zQgWo7bcSXMKKoHOva+AbkhTItweml/3eD0ntEoAak2niwtuhKYzw25
3DhOe5GOhsDt3OUTx9Z5kakWLDGkbmTc0ITomwJCste4pcdUFFOtv4m5XSGkAQOT
8xyA9jEUMM5ZXsrhdkNa85XMDb3/CPhNEX0jHBr4tikptYvJDf/ZV5a9rCldNAvl
lYGN1sDmGdtMHATgR170R/sTrdE2vw==
=ASIV
-----END PGP SIGNATURE-----

--glbdhY1Z3FbfdGG7--

