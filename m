Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEFAFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 09:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E2856B0088; Mon, 27 Apr 2026 05:45:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393286B008A; Mon, 27 Apr 2026 05:45:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D06C6B008C; Mon, 27 Apr 2026 05:45:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F11A6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:45:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8766C27D0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:45:58 +0000 (UTC)
X-FDA: 84703854396.06.06201FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 358C01A000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:45:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BD99g3MZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777283157; a=rsa-sha256;
	cv=none;
	b=24LS1ueiWGlCU4uoEYejlHib3NCvE3N3agK4Fc62nricqccL3ZjRG9TvbXTbxyUWiBd/4u
	lgnbAcxS91F9WG4uNTRjbFC+VBbAXSwamsd6XhYzooReGKavTWt3b0GbXtz4ZMDLYjex3A
	eHcaWwCEJL92DDNWgPQrCWmRf45ZFSw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BD99g3MZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777283157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isjUBm9ZnfeVq00beWsqNNEypGwAPQWGomwp/CzhDoY=;
	b=UMXWhMjKNbkioJmoeaOhhoFm9PSqw5kR9+7bo6BjoxK3IICiD+bEX1Szx8iscgk4uNoglV
	s30yh47aBNy5K7lkH5p50RYGH3GkHmmVJiWGQ7zm3ZvSko+Q6nAT+TsAJMSBFvLmn0bXi4
	JsfUjgZGe2NMlusLCuU0ISF0YZ58NL8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DF286014C;
	Mon, 27 Apr 2026 09:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E387EC19425;
	Mon, 27 Apr 2026 09:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777283156;
	bh=isjUBm9ZnfeVq00beWsqNNEypGwAPQWGomwp/CzhDoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BD99g3MZltYvFYIuAtPBr1bwuBD6/DRlleri4FEj/6kcy8u9Pf3/4xq/mP4sFVhzg
	 adrtCIie4RyXwYvAnV0XJkvP/DzKsT0BYkRjmCYF0P4LFNscYjV1QecA1hA0+8LbPJ
	 N1WtprZ2Wd5KybcAzmPjZ0vlBGiq5JLsO/oSbwEO1U0COPTy5k7y+AP4X686H+3ZJO
	 u4FHOGz/euk4/rCcpx3ZFTGu6bX96Xdsqfh/2b9LIt5nbt0wtXrjTAFLJRJgEsLiFH
	 LhgL96Fi8l2DFhQlqd49cUhyNozBbE6GxB/fQPjCYv7Q0la4LkxKVTkcyeg/kbPict
	 sDThFTXQG2JSA==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 597991AC583B; Mon, 27 Apr 2026 10:45:53 +0100 (BST)
Date: Mon, 27 Apr 2026 18:45:53 +0900
From: Mark Brown <broonie@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 10/53] selftests/mm: hugetlb_madv_vs_map: use
 kselftest framework
Message-ID: <ae8wUSJusD1u_grJ@sirena.co.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-11-rppt@kernel.org>
 <4d25a566-1e37-4e31-b304-8fa6ce7e3ec4@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iLNEbpoW8iVFtLSb"
Content-Disposition: inline
In-Reply-To: <4d25a566-1e37-4e31-b304-8fa6ce7e3ec4@arm.com>
X-Cookie: Victory uber allies!
X-Stat-Signature: h41f9qpua39b4348a1nrrob8xgc343tg
X-Rspam-User: 
X-Rspamd-Queue-Id: 358C01A000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1777283157-672670
X-HE-Meta: U2FsdGVkX18kpv87P/H80+iE7xnTI9S8UzNjAqMsotwdIAfEoxOWX5z+qfpucCM+wcWSwCvnNaabKXR0ri5m5pEkTpccBZqRgJ0ERrk69B6VVYM241ZyHEWJ8c2vxS8uLecx4eFDlq6QerXQx9Yg/47lVBJICMD+cKgf0RtUoxP8OaLb9Bmhnb2aoDFOIO7WE4gR0gyrWj2rvXX98S1aDyuP7C5InMTb5w5iZjSmGX6PApefnKXkZJcHnO3vdnO+QL5Z6DW/+GaNTWbuvSKf3IPGu5X/VajwEepHyFvI8tTd022KArbE79Mjd9LR07rCDGn3f2e7U53OsbyXVJ8rdq+kW5f7Ri52IuMg1ALbhUEINQFeYpcEF8vX0qpjD0cTb5nn9NPVRg6FsJ6mWEZwKXFVE5KUNk89f2jX3RAUJiZrsYNOhdCYtQi0zVnAoT9L7P+MZb5Q5Hr+9Ju9Hze52hNOOPtNGIxyUb3asuY7/CzzKptudrpaZNckUp75PJFSNDvgeUBAqhI8Q1oMI18rmJOIuHbxit0D0Zs5XzAEY1qMtoMdxieifQmesRF8InMcoBJG8Mk81mtawd3+RHGqpxXQEkwAV4fppQellGdwH5UPoRXz1U1J2L755Y6zaKe286xztUeGJ8djmRidMwfEuSgfBY0gfrfamEdxYS9R/0gZpbJn+I616IiRWLvoU91KiNm61KbwVODE8OGycEM0KfnBMnql7m+e8XZnzI0ugmuosmbkAfOXbrkHFF37vnG9q+9KTFN0aMi+Q4oJgCVI1pNosSpz6QpdOm6SYYlAMEnU46Nm597qVaGo9OQXB/DLC0h+xggsfCQNVKHAvXguz6vKKqAZLgyp1oGwsqeUroqgrppa0SqGw/nExZlq6jUSxyQ5815oGYQor4t8GXYdETiVqPyUWiX3M9tTyiu29g8/mjeSrJFj9TQkizlHUoNyy3E7t6ZzSMyaVRIYtJG
 eZ2++HIW
 C7AYEVYaWWTBzNtrwSOKBrBzu4Kxaw+xzZkss9yPazwzRJBUTAQmU2laFkmUXDK8xRLmm7NFCktZBD26DSQiiHe7+RRjx6M7tgzSFqQAT2zePnTGzFQ/Gdex/SuJfnB1R2udVSkGDRTUJOYrpglxygEvu+eV2F3Jec9vzP+qTCyVH07xhfUjkIjIYAMKCUYBUzbwNpqpLeMAbHkSbarbtOEBR8TQzzOQBQPAOvUEr/y0Q7sKooBphjxvsD1BISCsw6tsUQc7JyFcY37cO9+ZzU3IIH4iYulWdfhuQAvSZL9qOkdRWJ66Y5xpZoWV/WovtYNPmN7dzYvqDgj2Q7eUNbqSUS29J1HNb3IRFiQmYRgQAezg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--iLNEbpoW8iVFtLSb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 27, 2026 at 02:19:25PM +0530, Sarthak Sharma wrote:

> Seems like there is something wrong in ksft_exit_skip(). Should we
> change this ksft_exit_skip() to ksft_test_result_skip() followed by
> ksft_finished()?

If it's causing issues we should probably just fix ksft_exit_skip()
rather than open coding a fix - I think nobody bothered because it's
mostly used during setup before having planned anything properly.

--iLNEbpoW8iVFtLSb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnvMFAACgkQJNaLcl1U
h9CX3wf9Fu2krEJ+4z8cXiWjKnTbj4KknBX1P0yHSPUmkgJc8rdAqgrLt337LbKE
YkaadqkiEWoI8HHlpARfFxAdlTw8XgmACpe0obuj5wUnNKYg5Ksg6E9kvMjEF3lB
RrKI2v0LOq8FXvWXSwsMakAp63VXyPiob5/0fKD0D7qOZnQhy394KMAOuRASpHKG
z3OBxXhvrZp6kF/XUNtV1QeWPrgzb5RBA8OQeI91cstutpVmeMSvV4ROFJiEeq1b
l7p192srFB4288+DOD4pakxNVoNnz4QzTwHMNk3ZcN9ehja++g3S2vbpjBuz3EE2
l3cRfr1D6RoxuVoSukaAO5QdCSBZ3g==
=5Yit
-----END PGP SIGNATURE-----

--iLNEbpoW8iVFtLSb--

