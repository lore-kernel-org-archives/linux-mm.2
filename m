Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC6BD72377
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 11:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02E96B04AF; Fri, 23 Jan 2026 06:21:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0446B04B0; Fri, 23 Jan 2026 06:21:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE6B16B04B1; Fri, 23 Jan 2026 06:21:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A57FE6B04AF
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:21:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5493D160143
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:21:48 +0000 (UTC)
X-FDA: 84362988696.27.F3284B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9D9171C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 11:21:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/NH2iN5";
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769167306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykkvVthn/z5csss04yMomQpjAZelNNs6HYvfETKHdac=;
	b=5evpjCrBq+EYmbVmIAp0/YfVgUZTmDJ+cIF/MSC0Lw/pvsyZv/kUFgUbCjEA9utQ7w7Xj7
	K8v463pxtRYTmqlJLvtCxyGpEh1wGq5Cp02Hj22y2BIX2MaOuTxfRQMFc8cNTTJKlYX624
	3jaAFyydlSbua5jPHOOGv1Raac5eTkk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="r/NH2iN5";
	spf=pass (imf21.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769167306; a=rsa-sha256;
	cv=none;
	b=1rVN341MIUNkcUKBfl2rgtdnmNJV+/jOUjZrEAmS/Va5NU0X5ISbUP8xhdPLMkoZD6OMVf
	AuPCUV/ViNiWkpbCBAML4ebUSQEHU85r1LxP8waA8NaLgyCUBTenZyDnNKkxu8d5TQkWp9
	39JYGwnVeTPZLDGEb+6o11OJWQrfxHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E34A43886;
	Fri, 23 Jan 2026 11:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43F8C4CEF1;
	Fri, 23 Jan 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769167305;
	bh=MolMDS3zogBJvk53nL2gW86E9ZEJYFZYnB8cGLMNcxE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r/NH2iN5Lsx9y851wRiX7HOCBrZi6o2gu2QUS+grGKNWcZmdj0GR9XlUDzR5n1/om
	 eVXKTlT59WHm8pSfm1ScfEzezoyQRN5S5+X1lS/oISu8bVj8M1VQwUfDOdxcWSVWfQ
	 HTqhzifMPI2h9kFJco5OhtIc+E/RkT9WKmROf9TniXWCmsGTjru0U58126ZnVdyxvB
	 qUALaIW+3sHtjv83HoTg9DF/llMmjxas4ALmLWIKPOIB3IsnDGBWaGAZ++xgtYWtBo
	 auUCnTo/yQjwOaDc1KbYERTGo9B0WmXMUb7DyxCWklCGycpPRfiZPI1ik2MQryR0lK
	 rdvj9xtc5Dxeg==
Date: Fri, 23 Jan 2026 11:21:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Have the harness run each test category
 separately
Message-ID: <99b95c45-7bd5-4fc8-892a-cf9c69335706@sirena.org.uk>
References: <20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org>
 <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FMMmPfkX7SbHC6IX"
Content-Disposition: inline
In-Reply-To: <897e1bf9-d29d-45da-926f-0c28558f8990@lucifer.local>
X-Cookie: HAIR TONICS, please!!
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D9171C0004
X-Stat-Signature: oxx9jf37n8kk8xzaffrwhdy16xyun38k
X-Rspam-User: 
X-HE-Tag: 1769167306-710159
X-HE-Meta: U2FsdGVkX1+HQLpdMxDQNjp7v7PogVNIIMLAPiS3nSw2H9tGxtMSRfzh++XRJy9LjOTmZHIciC+HFRl6h2ZB7UwRf+oZdtXgFGky5OsE5ycIPFPRSaRckgoNSxGOxAto6DA/ZUlA4I56wHcAsQCa+yteScNWlCYNqDxV7Juy/GqJeyXgLzHsoSka2KP+NG1xSEnt2SuyYxY4Q4vOgA1tR7jL5lc2ZWfXKHqVwuR2MPckqX07H48a+bzEennRKpj83yORKG4OW2irtcp135t70q0Lf6qWk6HQHsLR4uCHbUNV5C9Ta5GIqIbiZU5KJgZGeQVStsKY9gc4XN7n1uhqy4tZfQLiIFnM7JWZWkeUykYU6MJiA73RX2u852S0h7U5MwQ+f36RfKRLADVo5q2P+N0rtWP3XrddU+ZR0WQR54aeL5uduG/9j3Td0XZkO7WCj0jXLvXYwNzak6IqvweJIuXBKYjjsfJ+dwlIFnOl+D7TuXYqKVGJDMZgCZB+XXvs10Tl6ZduKLE75vZmt02Y7HKsuUmibKAVDsl0tG9QIeh28vce88oltigguvebbD1gc6Ekl+6EVEZWoFHq36jsgeB8lY2Ml+vVQMtodm1x70EHV1JezIv5t3fhiT2mvbb59VQizHIsQt7UAB3wbJt+mqdfJ2x6ePXNAYsQVOy+c/EbpUQo00yCOmLvFrJpMH3hlUIAyNO/5pVIJ58VfHAJ8KMgyz+BhS3xUz8xMRIXPqfUw9ZLDA5hO8OofbMnHwGDhHYust36+m9dQot2e8eIgcNv52isWQdD7JSSqg16NYoER06Nr1yCkL8NOA1qs37RxBcZFL+qON5CllLARNh1TphiBFLQoijJYWg2e/NJHEdkOzVBz1SQt3BMw1JC/+m1ySk90pxaiETmDGVq8trmSwTKS/mj6nj//i17n530YaAuVUtAceVvEOglVBAxSCEY7iZiZ/yaWE6Elek3lyF
 PYLey853
 UaxSx+a4pjEQcN9qyMIAxFREMA0kNfabOGaG3VtJdMgo2j2RSb3cAG7Urx4EMHqbyUdtUqxpLk/Wr/uCaav+sNR0m/aeex2J8urX4zdZg1rUxh56P0PReX554Sz40kdF9WCPpqm7EDkORB/i27z8jrJhYlFJX8gBHdxsE9HKAm+9J5ErROPvWQiSMfZiuS3QHSJuxbyf3Q9Rvy+lfmAlNiaeI4VEUoEe3Yngr7WWlyaI4dblNDCay02AvcFJ6a2HmM+16dmTzUx+GWuCSprSAB6mKQiuOP5qZ/fUxRFEE5SKp3nItv8Dk70Aslg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--FMMmPfkX7SbHC6IX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 22, 2026 at 07:13:06PM +0000, Lorenzo Stoakes wrote:

> People have to edit this file to add a new test anyway so should see
> it. Something like:

> # IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
> # script so kunit knows to run it, and add it to the list below.
> # If you do not YOUR TESTS WILL NOT RUN IN THE CI.

Is the Makefile the place for that or run_vmtests.sh?  You don't need to
edit the Makefile to add a category.

> > +TEST_PROGS += ksft_vmalloc.sh

> Is this something that only kunit will interpret, or will it impact the
> build in any other way?

KUnit isn't involved here?  This is just how you specify which programs
are run by kselftest, this is a Makefile in the kselftest framework.

--FMMmPfkX7SbHC6IX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlzWcMACgkQJNaLcl1U
h9BQLQf/UnpU2CHz/WPyt0EJuVIOeS4gb0aK+zd0zg2lyECwEDrVeeqF2sz1Zhtl
6/o4k0nubqIj/CovsRmmFWR/vcXItDO4aSVo1znB92s4yI+xSl/u75deJ2tIqldn
iRhAOyRnCV8ZtyXp/Zj3+vSB8DCq6gogxo6uGCmcj4L3ly41vcZOTwJCyYQQ7JF6
CtDdc4zMV4Zek3lEBWfWYnL9SZ4ec2sbsM3PzpR6M28Z5QS/dLh++5wfdbZlhWfB
JlyTaTDcF6m/s7DW1gtrgW30vb4BZnJ8AB/2wffALuSpm8NSlMqsO6xG0ZKjiaj9
6n1zNLNx9q4f/ieDvW9BN7ZPIw/YUw==
=qKKG
-----END PGP SIGNATURE-----

--FMMmPfkX7SbHC6IX--

