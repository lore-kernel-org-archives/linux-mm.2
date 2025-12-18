Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3D7D6D226
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9996B0088; Thu, 18 Dec 2025 09:25:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDAB66B0089; Thu, 18 Dec 2025 09:25:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03E56B008A; Thu, 18 Dec 2025 09:25:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADCF16B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:25:30 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AEFAB6D4A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:25:30 +0000 (UTC)
X-FDA: 84232814820.07.C0BE089
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A04F640011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:25:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMtqRmyw;
	spf=pass (imf17.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766067928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA53bZzoBNPtoKj5BQ4cXhbeyzNwlqm1dYFoqu40M40=;
	b=Bm1UiXDDPxWjkZ8KVxTVBVIVoJXWuhNBq58WDWiGz27qOM8ZElmAw2a4f/N0Q8bwQGOqA2
	kXD/V7PQCyWFCKMexAqeq3miJatSsO1Y9GfKwlODfqwysjkfmvVYv3z1DVh/ezQuYobM5k
	2cNy2RGdn+u4SdxLEc/gxuNYqMNurMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CMtqRmyw;
	spf=pass (imf17.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766067928; a=rsa-sha256;
	cv=none;
	b=NsEmaY7gZOEqTSP27tgprRg12zY724QpDSBqWs/wc3xWS+SwgAX1Z+EySf4OEMkfsX66x4
	sryHCjs4GDnmbU/PwU/HVataseajku0koXCxa1Z6ErkGuAw159qopPD/xvOSs51Hhc6mTX
	pItAOm/R8a5I9sfloa8JC9OJcu9ZTv0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E028D6012A;
	Thu, 18 Dec 2025 14:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C393C116B1;
	Thu, 18 Dec 2025 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766067927;
	bh=r0E2VNvXCIpCx/++TKgBDonkZ7YJUx+FvKeMkOV/3Jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMtqRmywxWmOknyn1jm2k0YQDZSr1Oh+XyzEpnUWWcwyXCVf8gfOI4FcMWWEsluy/
	 EEI5Od9UiaWP7cyRj5F2T3Jx3lZ6QVOKOrAn9BIwAIYOwN3EIvW9JPPLEc9SCOz0KD
	 /cAWpiIlfTiI7aWlYBBb7L//03IZ8bxboBepSEpOc8zOzQuhtiwySjTAgAYQmOtg3m
	 j1C+tkDhrZildjmqO2bExvAD1fWqfeiKSf7EE4C6cw9MJ2+yxn3vKC7BKOov3rcKnA
	 KZ6OGu/PILpJuy5K6WakdBeSCEGhbNpMbfDvnz4l5i7xiA4qez/8+IoEGqgTzkAGIN
	 qBqzNm+4l1dyA==
Date: Thu, 18 Dec 2025 14:25:22 +0000
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
Message-ID: <682f64d0-353c-47bb-808b-eacc2d4d6c00@sirena.org.uk>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
 <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b1+frtrHPzRKmdHc"
Content-Disposition: inline
In-Reply-To: <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
X-Cookie: Close cover before striking.
X-Rspamd-Server: rspam02
X-Stat-Signature: oaf5irpwa4s93dbsk8zqebwoytxzx1mm
X-Rspam-User: 
X-Rspamd-Queue-Id: A04F640011
X-HE-Tag: 1766067928-321335
X-HE-Meta: U2FsdGVkX1+T/ZKgQP/P9OHS5U9kdoRCWVf56i0w353MDI5csLDQ+pNjyI+oINfy1ixrdOByBJNEfuoNeVmQBBKYkpliTv70SXB/NIy3FpuvfesLDpERIDqCiYPGqpZpHkjOinZ8HPXVOqbuS7bOPMXh6QCvYvFi6twX9N0nFBOuatcP/fyct36kEPQdNIBgJHCwhhTGW6v3UA6qLNr5etITaRiGeSDrpEwslb3BQARQvImySUA0GYSFjw3P4js8moT+P4hYS13QhWWBFsPvgTWQS5+CiAUleHHxpYyNFhKzxqGcrvakQdHcxU1EzmmGqOa1QV5kwe1cJrlIH0rnSSyO5KJDqCctdEPl7GVHKzvqWCirrD94pM1kLH3pBtKpoeBb0xpB65cYTsUDtZZ7OTqJy1VIV9mLPv8z7dIZfO7/YYMquI7foCgO2G6gga1AmUsHUbh3tR9K+yKD4yXM63dMTh1i1yfZiyxi1dQVaFbHnu2BeEHzea1MuxzEKCrwcNsShb4EZYLSA9140MhMoSqaq2LOJ+bo8HvmDXgXK+grHGJipPdY+e5oDz35c/rviuBW+8rZPQqWRLXGlO4lSpG+hEgkxIwn9LS4sUFFQl3eYC6ynV2h/qodMblNsEu7UfU3uFc8CIlCWmOFzqzdM4jr9wgIWEGCu+m881VQTeUTDqesGny6Jhoy+jziRtr+rhkBAwbX+VzR9Nl+o/tonnF2Av0q84ltWWyUnDE94PhRJuNfe4157eG5KtutcsfpieY2b1kkjFFjdpsHzY8gORGoqrOX2iTubDw9/m8lWzDyL/cD+iOMpmMER7OStDYyQjTi94KQYAStTfO9JZbvVhBSPSKn6Tb8hyIBlDycLS3Ss9Im5rFgjWXYRwoUw2A1EwYtEuyQ90Etu4hbWkhM2bfVbu73sgQsKXzKp+jWWULkM5YV0s6sc309y3ndiIvOdIRY+xZuRGmQlenKG2I
 iXoX3Qtz
 0bMT9I/wlqkVMtM842xAvZfPHhMQMuDh7I8eLRck5ubiNDu8C3BGsH8t8vJQOCTfhAjgDKWgUgibvRx09fFGuzfJR3ovpLJYCQRo8Tg5Xw9GQo9E+9HAHO3xUhuNZgzZ5WKCwjtL5kt10PfuRrsgHVdN8geQb7BsFSjkrklaUwzPj57Lsd9ZYoNd5dkBa4r3A4GPTn2DP/4QuMcUNXgcbl93KBo06wWLQMGuVF42Z7sM+szLF0bzta4GR7a88CTVYpeZSp7xIxxScNgn5ztPtZRhuhykC5cuSMzsFDZyWGy3y8NZZK7PP9GuBXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--b1+frtrHPzRKmdHc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 18, 2025 at 02:24:10PM +0100, Kevin Brodsky wrote:
> On 17/12/2025 11:04, Mark Brown wrote:

> > More generally building selftests with random older kernel versions
> > isn't really something that's expected to be robust:

> I suppose that Documentation/dev-tools/kselftest.rst talks about
> *running* against older kernels, not *building* against them. That said,

Yeah, running is fairly normal but huge swathes of the selftests won't
build without current kernel headers and it's not an especially useful
use of time to support that.

> we are dealing with an out-of-tree kernel module here, so the two are
> essentially the same... Yunsheng suggested an updated check that I think
> is reasonable, maybe it is a reasonable compromise?

Well, there's also the selection of KDIR which for some reason defaults
to the installed kernel so we get:

  $ make -C tools/testing/selftests LLVM=1 ARCH=arm64 TARGETS=mm

  Warning: missing page_frag_cache.h, please use a newer kernel. page_frag test will be skipped.

Your changelog says it'll work for an in tree build but I can't figure
out how to do that (using the top level Makefile to recurse doesn't seem
to DTRT either).  Having looked at this more I think the problem here is
that the selection of KDIR is wrong, not the check.

--b1+frtrHPzRKmdHc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlEDtEACgkQJNaLcl1U
h9DTXwf+NKcXoL0qH47tIhKzxB1aWsfOAem/OloigbCC3HAdbAnebqErn4V3PyLU
3PUVn9u9QB5XEIPobLqzig0dqOAgPsDtxbz5WhKUo69GKcxGl8h114OjCgQryQ1h
mMFUAhB610D+X83WWgy71GdWQNcZL+UC6jpe4wMZojsjUYL0R3Z6YCyFrU8xL7g6
o8r7e9dYhrNWbsUG60Y7L+293dN56TtyWRcG1iBYHGDgc3MKOFOaNO5GTQCuE6HC
5x2excDax3yLwV9meWrl7h6yH9RJvIeSoBCTHNITSPkbbhKSKIZECwgwzZHYsFGO
KMtV45ue9RSG0bp3BprtIV6bCsb32A==
=dMYV
-----END PGP SIGNATURE-----

--b1+frtrHPzRKmdHc--

