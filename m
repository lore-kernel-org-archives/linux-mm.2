Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03903CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4E66B0005; Wed, 20 May 2026 07:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EBD6B0092; Wed, 20 May 2026 07:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F78F6B0095; Wed, 20 May 2026 07:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8D56B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:58:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9BD71C01C9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:58:40 +0000 (UTC)
X-FDA: 84787651200.13.D15C831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id EBDA0180004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:58:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdhFk2F5;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nvdt2XBzMkZ+30asNAQ3e3GOOKzUVXPt5E+OSJEk6nU=;
	b=ia06aQgz0ryf7Sy5ddUQz5CCY3WDysv96tmLkNQAAmgXp/tjGkWauWt/r5SfELDx+Y83hi
	as9mHBjYF90tiiFF+6UmRVLNLS2WxAu3Wvpxuk6Q9casPzHr7811yngPH03PjYVxS7ERpK
	EQv0csxJB6HkYb7XB7qYeYVusaWN+hQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZdhFk2F5;
	spf=pass (imf06.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278319; a=rsa-sha256;
	cv=none;
	b=seZfrBkTm1GSt3xl1lH0G6tHSxIGZ0YlEDs5RDlMV0+NEFqAXk2N4OBjIf3KMt7yMuXhzt
	774E4zY89y14AVXNFjUXbZAMUUz7d/x02nz9UzAcSPFY4lmlY07MFL1MYzURK5Qm3IoxBc
	geQ+vyIoIerQAWT4N2aaBS48OymjhlQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E13C409A9;
	Wed, 20 May 2026 11:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C6D1F000E9;
	Wed, 20 May 2026 11:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779278317;
	bh=Nvdt2XBzMkZ+30asNAQ3e3GOOKzUVXPt5E+OSJEk6nU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZdhFk2F5966kLepjIdaky6WJcw6IIG6qenuVxN3ZBN7E4N/ulH63cJrkdUGr1pTCm
	 SYU4odwJZ/aYtrOoa4k8BZJ+v5/H4GTNUhKl5SqIvH3MAFS34X9aur3RYvklwDYGwk
	 K7Pw4bsh3RG+VLOPM4jycGPRBsHmly1frrtwa+3GVw437KzFlPcAwyFYxo4EuWBThv
	 kWDAV78wXt2X2SptbtLwOxedKOhBb0Jth2eOsGHvIJByUMCb6PdepA4ntPc8FKvY80
	 LzjXt/L3HmqTmp2lhOSEA5rtlGCaRKJms1pdI0IteSlCLMZ5oQ3fiX00pNcwlQUMOu
	 O195huIjS/mdQ==
Date: Wed, 20 May 2026 12:58:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
Message-ID: <67e9ecff-e532-4659-b4de-7019474af608@sirena.org.uk>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
 <ag13GbKcLMIoHOHj@kernel.org>
 <9382431f-3746-4477-bbef-87abb58bf180@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Y95J1WJC+suJuyFP"
Content-Disposition: inline
In-Reply-To: <9382431f-3746-4477-bbef-87abb58bf180@arm.com>
X-Cookie: Natural laws have no pity.
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBDA0180004
X-Rspam-User: 
X-Stat-Signature: rdiesgszuzymxgar4pmfx73rte9j76pk
X-HE-Tag: 1779278318-871909
X-HE-Meta: U2FsdGVkX1/MXfOTumz1SeuZ9ifBPJSpwLcQmJWKThgl8RTQM+n21LtNQrculKdGqfsdPb0oPm94ePE3mnxX8zv/qtLj+bVIiherAXK4HiYeX5HEyUjyQWYW728DlmViRzuTcKlOi6dyo3nZ8ffCMM7ajpBkP50F7S0byUKpHBtioXyDzglDn9AgmIPdnWAWP0XmiOmhePX/uQh0IkCLtZyAqkVDJqP77J0a/sF/DeTP683SzA4OiJHaQVUnVn1+xx9uY0Pdb94VWRMyrdT8upy+V5sed/PPkZE398UT/Zi6ZwGVHbPuYQKXfg5X12+Zv+WZbYUwGErcSqtVazdF7Fjys82wZNyVfxby7VQotMzGEjQZXTR0TYb3vywUPV/QeZLhwKSxbMFtxS6GSuWTg1PRNHwTqItnqt62MVVQUXat8d+7z91sb1ON372sU0+HikPO6ex1UQHpdI2HDJx/8pZwUecu2pMp84/7KzCx9GfEpHzQwfq33oDcIveQrVtyLF8/HjM7xXjJsEGHrlS4iwVGFjVrB2NCxffrRt3C2i+G9A13c3MXFHwHL6v6G4UO6fBjYpwo7Cibh69b5kgYN6teWbssgK7NHnqU6Gs4sTleJykqGTEuqmnh1JHpt0Vgtz2aPXhSSdjGTJhnuLQ5bm5yfo9IHvc/W7qGhl8QODATHq36SlnYcqVClewRCqtz8MAbqpZ0qF7xwNpqKdmmeTfqywBHe8fpksV0zrOHU9QeI6l+/6jbSTYpxGJY/Ne34ZB2ZSJyYbll0HnrWxnWCo0Bc6Fh4zfiO1P8xLSGm9OO7GAlm81jgV5uQoaTv93uAi3rqWoOxF4TValwD4QSObw30ZhEfRoF5TQ+yRlgP2lhzcB9Uxta7SozqVT3Ec4Wb2TaJWMr0JVdSK2cx4NNm3Pha6juB0nXcfxJcfbNm13+yfvMvW8+11d6OybCme9G5NT53jZAoENPkNC0Mji
 G2bsB+mH
 aTsNCsPNp5zqUEc06rjttoQd9G+MjwEnVxNmShTNnFeOlFNkXgY3Kdle0EIkNnzC2sieZ5ABdZgrAzQrCNwL1piM+jMZXxEcMGAI0qGtnjCvRkM41ReS7n2Lj6zgIDntcFjLG6P5IrRKWHC27q5O9dfnc+Xk8viCiLXagyb3v2H8gPJWBOeMYBrCrDJSHqFsJQ64Y4WiumpCYpYsoulSadE5/LdHALL9eBsyBK7qo7yNB4XwLoqq+kRVJkY8F8lwcnRFs1EC4mrEYVwMJ31tb4uiogoZl43ezxxtqA8Uh060IMUWnwp9F+S46Jz7w7jffL9pdeN+84XltW9pgFDvbNb82ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Y95J1WJC+suJuyFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 20, 2026 at 03:45:53PM +0530, Sarthak Sharma wrote:
> On 5/20/26 2:25 PM, Mike Rapoport wrote:

> > It seems that we need to better share the common code in
> > tools/testing/selftest.

> > And adding another copy of the hugetlb detection and setup code does not
> > seem like a great idea.

> Agreed, but that was the least disruptive approach I could think of.

> I am thinking of doing this now: should I move the
> hugepage_settings.[ch] to tools/lib/ and move the read_num(),
> write_num(), read_file() and write_file() helpers to a separate file in
> tools/lib/ itself without any ksft dependency? Then both
> tools/testing/selftests/* and tools/mm/ could share the same code.

Using tools/lib sounds sensible to me - as well as the sharing it makes
it clear that it's a library used by multiple things so avoids the
issues we sometimes have with selftest directories referencing each
other.

--Y95J1WJC+suJuyFP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoNoecACgkQJNaLcl1U
h9Bl5AgAgt7Ok9vKRoNdgZt9TjhnvZ1xKFdzccZFLZzdrU0guIFV4m32I5KLw9PB
6+fSYh9BahFlRTraKPMKUVmk++cX8pLP5U/OQ+5/F7uYzDwXhALqzH8uWsuV9cBL
zQH1yPDS/Svb1BNviCRN4RJkBgIARQslzPOnapN1aBFTBhAZiNrRrCEoZV8aZeNI
xi3oIEyRbHrb+/hVVc1R6JWiVjtHS6dWmguqFT3uSNpu/4uNO4k+8kIHWkCztKJM
IvL2UUhIJsDaS4ictHYzDFcSfyS0B2aknQk29HPkxxtgWRLHTCmYktWr8ExgQMw9
ABGVA0g/7QpFx9SPMdYJUCpfB8/YaA==
=JG5s
-----END PGP SIGNATURE-----

--Y95J1WJC+suJuyFP--

