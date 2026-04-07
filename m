Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4790FEEF50
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD216B008C; Tue,  7 Apr 2026 10:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AED66B0092; Tue,  7 Apr 2026 10:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB936B0093; Tue,  7 Apr 2026 10:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6416B008C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:34:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC8491B89CB
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:34:54 +0000 (UTC)
X-FDA: 84632006508.23.7E675C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41D7E140008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:34:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1bqf43h;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95Tb6ER0NYWtj2/kY2TeHG2KltRg0/R6azITtcytnZs=;
	b=ovo6vZeDfEoxWN0CjyD+Hry2HIyNtoBDTEHnaBwICvU/L7YPfkQ4wI2k2dkKf79XZdYwLz
	wuka/QfsYZuAIxmJyl1vHETUMd0tSp8F9QX+jPYTK2vQL6TJ5YBTstjC4UtWq3K/Pyv8yf
	LOSdE8ImuLUrIlh1IQRB+VWYfQFkNFI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775572493; a=rsa-sha256;
	cv=none;
	b=hKM7fZGxPtfsfJeaDVu4DGoTReab7ulBjT6z90xxSmkYLek1iO6aRaLl3Ty0L0IO9Gv1+I
	Nsu+Aqof/jSFsbbEQ5U36Su8Umw5xVdV7goXFIztGtETpMmfmDGca6CV2DASPVKymN7b2/
	eOocvtiCp5moZuXRqE4DJ8e34lyc9l4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1bqf43h;
	spf=pass (imf09.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9F2C60123;
	Tue,  7 Apr 2026 14:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251C4C116C6;
	Tue,  7 Apr 2026 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572492;
	bh=RCmKhdjPi8Jskr47gc+moRDVhuEspqo0T/BYmwAP0vE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l1bqf43hK9lhDea23rRAGPHaGVpNN+dsaboOjP0v99SbjVKrncfAnmGzS5RwBtNWO
	 Io1/sFyKC07KeA5jlKXxakwJhEUtbIzY/h7HN96mNVHmcSiGULsCMHulOfafFZRrsP
	 7Kb9CaJOYQ9qj/qx0lp/bXygrfX+HnHrN+GryuJpK4DYIffadZUt9vXV7RbE0Ea+1i
	 lehS/gPRNB/Nix/zpp+1iagwCoiNyEutG8xvaLDKrww7/dhjoGA2tY3JHPtyKkhtaX
	 WTyJf3Zt+GylUYYpywmCXpUSwZj94sV9oeCfZjedHGcbjgF1BmYWdO0einjgDT+GzH
	 bi9kGKRzjaJGg==
Date: Tue, 7 Apr 2026 15:34:45 +0100
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
Subject: Re: [PATCH 19/53] selftests/mm: va_high_addr_switch: use kselftest
 framework
Message-ID: <1857da58-925e-4e3d-b684-8a76eabc51f9@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-20-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="b2yQFTIeWGRWvWGc"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-20-rppt@kernel.org>
X-Cookie: Now, let's SEND OUT for QUICHE!!
X-Rspamd-Server: rspam12
X-Stat-Signature: mszduj6bnmh6j5zgy3kwwajmm1mskt69
X-Rspamd-Queue-Id: 41D7E140008
X-Rspam-User: 
X-HE-Tag: 1775572493-703688
X-HE-Meta: U2FsdGVkX1+WPr6lV8lQtC1qdCMeItcZisxaQeDMTA5lI6QiZGpMGyMmbCpuKfRhZbe5jiknUyogXpFR3Z0e/2rH1+MFTg31n6IjcGEd+Z96KSYpO4MXyjazfCpgGmd0tI4KC4jjpUnD/+iaUjsepkrh6c2tGN9b1nx+O2UOkwxCI5fdQvt20ljgw/Y/dk6pWI/nh/JkyS/z0CxLT/jtZbcVFgyeONbrpIrKH9ZVjg+SZWdeYa+EInCJx+/Kk5D/Us97cZis4LF0q5ruTF2miMUHAcDlsLCJOQdhPkJ8Cm7YU7k+FzjD++H5kTrMgXNiL3UdtTySFxOTXjBhdbjqmuJKnVmM6cv5yi8BFa3KvqhOv4LYDJkMMM/fegQMv+1dRkjCRHI7ECSfxmo0g1/JWzAGYSgl9sJ9gaqljHInjfPRNXrBFC1vwAkbTuvGetWm4TPf1kk3ks1Xf7WCIyKnGA402umii8Ay0b3tnkGHT8w8zT50r58cgnnmbtsnmHvRUW4aOYn4yjhWsX4FMZOtuZiaQu3mGwqlUQflY72BXW1gGFdEAvuhN4Rhh1GgE1JCaCyfRy8CG9NHiB+Qgaayfw2pTa1Lcplvdo1H/+1DhE2I7IC3sJ1ecaisEYeQA4CKGBG9r36EcAN3zHprlkcA5jO+vSKLlRbrGBPZ0pTE5dCal5hqfxel+4TsPn16ld9c1KYeiXRuPDKBfH/KNlUYnmR60hNoli57zqSmQu20AWwi3RcPI1MEjPfKzFYSCfQPcqK9UmI8QW14U0IyYiEAYdpTpXgdPNlKOD8VPPZ9qJ2x3TQA8BQh6YZBek0bF4cYIkg12riue0/FSrDy3Lo8lpAa0KEMuvJO0F/gP7N5buDSVuL0t8MmXylO6O5CqTTaTJumorRd6MbzZ0+fxvr90Ox5BTvdqOKN2NgWcjtnQlvy88dQyL0zkfUAlAoBAnFDghVrKi+smVt7AHI/AdF
 XC1PZRc7
 Qpz1csNEe1qzEqEngO/hhoACfg7G45yJoqlnJckUFL3vJJAaEobVbVqhJLsVwXIz/wk/+C3rqqFbLUTCzZgmvvMWQ7rsNEm0kNlx98UdOTwRu2NozrFqLPATODhF80uuU3T15Rc/mFwWSZg7g5JCYtx76phI5qP3/47IzxaSoWENRFHW2MIr1RHNcJ0h/XSSuJBkjfcritrD4g7Du3qh4IGsvzPkbvnaCbWxP6aA6dv3gjTGuzhLH1GDJtOHFSAENUZmSiwylf1y4chPpXkvJfXnBEWVWPByxAUtnGoqAvaiYl1Fh9X+mnn5BZG63Sdm7Zkc49T+FVCe7zGGN1mpM8lp8/y404EKDNPgjDVcGq1YWMvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--b2yQFTIeWGRWvWGc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:17:01PM +0300, Mike Rapoport wrote:

>  		if (p == MAP_FAILED) {
> -			printf("FAILED\n");
> -			ret = KSFT_FAIL;
> +			ksft_test_result_fail("%s: MAP_FAILED\n", t->msg);

ksft_test_result_*() should use a consistent name for the test,
otherwise tooling won't be able to correlate passes and fails from
different runs (or different fails if the fails print different errors).
The entire string supplied is taken as the test name.  Log the error
separately.

--b2yQFTIeWGRWvWGc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnVFgQACgkQJNaLcl1U
h9CLzgf/Z7enUVELGg09YPk+CGx5ueR+92ySPouJPQGYBbRto0TTfc2bvyL7Pe4q
hslkud5LA/NyHwJBRJh8cmSxbuYQd6BPYuwCUXG6c/e3QgSmMXPKNSZjucha0mYr
p9D9CNO7oNF3th34Tg+N3Kda7F3Q+xd/n9TXQBeRIo22zUn0ZGX4PXo/oKKjYnle
R9xShmfN8z/eqpRf03Ek/tY1W2Q3idhqRrQgNniSOar2j4E+1eeREXNEGm4sv13s
N1SSnSFJN+ADSEPJSYaRmxEbioktWuKkeEmzEupvyR/29LHsUNjQE+pL4Ljji0c5
kLpJjGqqHqB9K73AzqzDeHMnNMBCWQ==
=Q7yh
-----END PGP SIGNATURE-----

--b2yQFTIeWGRWvWGc--

