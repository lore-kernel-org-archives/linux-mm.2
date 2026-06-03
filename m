Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDDFCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 579656B008C; Wed,  3 Jun 2026 05:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529C66B0092; Wed,  3 Jun 2026 05:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418D86B0093; Wed,  3 Jun 2026 05:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0A56B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:03:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8F04C1376
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:03:44 +0000 (UTC)
X-FDA: 84838013568.20.3BACDAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 327041C000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:03:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g8GgVRap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780477423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUKca28tY5r9Pjv+OZyhBaclYMiI+FRqL0Q+/g1yqmc=;
	b=cHdxQVZC5H8KyuhpSISgk5fG5SDobCt7/S2lRJM9P1WrmKQjulk/vXtj+AqODCJgYcIZ75
	63+U1R9kFpuh6GYRABSiWGhCGcOi09V9vWIlVAl89ZL4Iec/hle04l/z6B25W4TXw8Cd3k
	LwEdC9fymNh0o+sMEqcV3qpLzJm/4i8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g8GgVRap;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780477423;
	b=IsNWbnpClPyUkpY3NfjxZfdUcTDmyHg3Gc/pRnAiFthEvHYNmm9zM0VeUwrRAiaAXeva1H
	mi3wKQ9zmlQ0556Y5JuqYJteeim0mHUx4yUfD14mYlUQiRHbW7UfErjfvAbbEb47Nuigdu
	HqePmPXVH2KcmfbAAa2JYDiCgGFxXvc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A8B1C6021C;
	Wed,  3 Jun 2026 09:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2560D1F00898;
	Wed,  3 Jun 2026 09:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780477422;
	bh=sUKca28tY5r9Pjv+OZyhBaclYMiI+FRqL0Q+/g1yqmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g8GgVRapuMCITalcXmqWQf6uCaZotbFBzjpOAi90tMjmaZrrfblVUhUQk8jtmUFTk
	 1Yygt0DA0bgFKEOejaTWdI+5hPnxNHGmHwIRxkOxy9JSUJz71O5SRhPzEPZXyauuPr
	 kPcDstH+wQYl11W0kPQessg8T7EKTMmxYr3FtDy2LC0sGt87XqUL/FSgi0ZBN+0Stk
	 T2ZesO87IDKkgZLOT9xeJrD430sd6r1z78uYCkpR4+yD3tR1j4FBGAGL12zFEtnpYG
	 Ac0dK9HwYyb3hH1Xp2N7fDcdiuMrNnwUXQ5E1vWLAlNvUqAZT3qdp1nurd5xDwWc47
	 VBdb7/RrpKQ2w==
Date: Wed, 3 Jun 2026 10:03:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liam@infradead.org, mhocko@suse.com, vbabka@suse.cz,
	willy@infradead.org
Subject: Re: Process (was Re: [PATCH mm-hotfixes-unstable v18 00/14]
 khugepaged: add mTHP) collapse support
Message-ID: <ecf71d71-5d20-49c2-8b19-e76ec9353585@sirena.org.uk>
References: <fa9095cc-69a1-468d-a1fe-718386398b10@kernel.org>
 <b45f9b55-5143-4387-aa98-e077390d542a@kernel.org>
 <ah2ndruO3RQGtePP@lucifer>
 <506fed6b-8954-40fa-8b5e-c8bd8c0d004b@kernel.org>
 <ah2uDhs3a0bFcRNG@lucifer>
 <ca37b7ce-76b0-4825-b238-b504dd499d3d@kernel.org>
 <b5b1a7bf-de6a-488a-a011-673c37bd24d1@kernel.org>
 <07334dc3-79ba-407e-96be-21ceb2eec00a@kernel.org>
 <ah8Tflgn50DTMvwl@kernel.org>
 <ah_ML-Wm3B92ZniC@lucifer>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0OGXtbWLCXeWuo8U"
Content-Disposition: inline
In-Reply-To: <ah_ML-Wm3B92ZniC@lucifer>
X-Cookie: You are false data.
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: z3iopigdd6bj34wwwff6oigzizqr6uzy
X-Rspamd-Queue-Id: 327041C000A
X-HE-Tag: 1780477423-733716
X-HE-Meta: U2FsdGVkX1+05Lg9dg/z1uCVYvt/sqSYa3ds4uYc0BGLVzpv0zqX+05sji+4X8UMoGfcc1Vkr3x+qbaEVXbLi1bdaYMzfR62GLRxemPg2iBo1LhC+5iyn+lC8oWlI17H5NOfnZZbf2g0e3KZs3K7wQ04DuVV5iUXoH4DdaY7Ky1gInabJKV2SPBdDE+cxXB5aBbdOFPxjjE43bUGyglh30+frKweBw69QPblgVKPZryirR8P0XVJRM3JU2ILsrSKD2obDk0iQ+xggQG3lx5wD+ILf1AaYFduwjWeopyWzjDyG/XCoUQjx7fe44fiXqdWOZCoRKF7itojcR9VMH8QRe2HhF1cR7pQE2Fu+axWrwoq1ZxXd9Mp4514pANfdpXC/jISC7g1odF8l7lnWGC08Tb2sKeSoUTPxEEKYMj8njKbrPAuGTxvt2Q5mwVB178MeT9XgAk+Vh8GwoXBM3NEXCL8EqROsw6S/qwTJrw1wANqvGzG/UKueCXmej40yrI3XUHEpF9LOFOvrzFzXEft46IBmq4xDqIwX+nyGzsbCBF1GmrSh6FC80hsxYJcRzQGIsbd1GfenOQAEw3G4HYcDLbdlhKHIdm8YM43oadydHveP+rQNKy6X8/JOVoveG40w3WLhIocd96TVBo8bN75zzhORznuPjUY4y/qwrzQqd/1d1cewKjlO53LowCRbAOQY79fKtOHGUJEhP83UQ4JF320o27dVv1Kl/wK4FE4JmCdRoWq2Rr9bZyIM4c5/Mc9QuJEhQjqt54OAltIUA/JZWzxTaZ4O8kvyxWYj8oMEeBLNAKrXzBXxnqjNK05FqLvpIUoCiAJT8uhLVEgyFJU/YLY7TvvBmxi71e9ffAr7FPntzXErdHpfeUYYko+AIXm+Mrgp6GMwIFoFYLegiX4kzO/kEDTvRO3leW8C+jIs8dyoy0y8G3QW71U+X6YFehvIpuRdFWtTgYjjupRXIt
 WggVVLRJ
 vsUunvA5yeqSsNWf7x6j42nH/3A7pK8R0QYN5bPn7OLz5Evk6koH5/b3S4xxfh2N8qj0EPDkpMEtd0Udf9dayZxVSM/NgncXyZJVQEnaywL0DKy80vl4XHgJTQc9RKaAc3Sg+53XOyC6Y0otqYd9v7VKnF9eeM3U2h4qSkyS3HDYwLx9C3GqJsSCd2vPgRkfCiZlq+N2le8pHCSCmuJPtUzsPTnxv+5/5a30fBAluidND83ki58UAAuVyE+fnAMoN33WFgIwSNESOGTgdu1pQ3gMt75V0wNg1BLJGWcWUQw6QpJ2ZNQlJn+Wt6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--0OGXtbWLCXeWuo8U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 03, 2026 at 07:48:46AM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 08:31:42PM +0300, Mike Rapoport wrote:
> > * Supposing we keep the model of early merging for testing [Lorenzo, don't
> > yell at me ;-)] I think it's reasonable enough to drop everything that's
> > not going upstream at, say, rc6 and ask contributors to rinse and repeat
> > after rc1.

> I won't yell :) but I really don't want us to do this, and to improve our
> testing locally. Because:

> - We've become a bit notorious for breaking linux-next

TBH I can't say I've registered that with either of my running linux-next
or my testing hats on.  Considering the scope of what ends up in the mm
tree it's not particularly concerning, and it's very rare for there to be
anything so catastrophically bad at runtime that it causes unreasonable
disruption.  Importantly when there are issues they tend to get addressed
promptly with either a fix or dropping the offending code as far as I can
see, that's key for -next.

If you're looking at -next you're looking to provide early testing so
breakage is expected, there's a balance with making an effort to ensure
that you don't make too much noise for people doing testing and especially
avoiding causing too much breakage which means things don't run at all.

Of course having written the above there's a -mm build failure today.

> - It makes it more difficult for us to yank things

FWIW I can easily add extra trees to -next, and there's the option of
doing something like the fs-current and fs-next branches in -next ATM
where I do submerges consisting of only the various filesystem trees
which are published separately so they can be used for filesystem
specific testing.  There's several areas where integration trees require
their subtrees to be in -next directly for a bit before they get merged
into the integration tree.

--0OGXtbWLCXeWuo8U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmof7egACgkQJNaLcl1U
h9DK0Qf+JTX9vbXQMAwz/tqWSOU7O501QMsM+iFLVCuQAew4Go7x/enLfWFe3j2h
bZBCWi5ZJrvTWwgw971oNY7KwFqURkFwH/wQ2kQx3yhrl0sIHT+f3Pv0B5bu+SJN
E7bkhPv6UAYA+AyFeNVfPFz4zdAUoufMZDMma4uqUiNuWk0IdVOD9cigC3WOZM63
4LdAWUhVIfTLzLPwoHjcYHmcSeXoA1I5ojW+Lpv5nzzgYJsq74NXOdw3SXIxUS6y
IidJACn9oWpkJJamYt1xSLuC5kuQxI0G5Kh6A2KTM5qPmPRAGsdSxL0aOVFFv5F5
AnOqJz8nZ1U1Wlru5gWYlN2xV6x7Bg==
=2BvF
-----END PGP SIGNATURE-----

--0OGXtbWLCXeWuo8U--

