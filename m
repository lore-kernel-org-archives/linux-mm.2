Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D0D5F46C4E
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34356B010A; Mon,  6 Apr 2026 13:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4A16B011B; Mon,  6 Apr 2026 13:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4486B011C; Mon,  6 Apr 2026 13:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC1D86B010A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:02:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C1391B8139
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:02:47 +0000 (UTC)
X-FDA: 84628750374.10.112FDB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9FCCD40013
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:02:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRekFqRb;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775494965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcWv0zlQTkxSPeEjdB8IZqD1kW/Ug1ZekjOkMT+T9kE=;
	b=WFb3DYulTQ8hulr3BvVn8Z65PFcGK7e8iQmcH+uYbzDaW6bgmcGE068zpflPx3dib8tWaW
	d3u/6vvRqdB+8riEjyGS5AAo2dUOuI6V+IyHwDMJ8+qIY/EYd3QyuWgn+pF9IMMV+G7tub
	uoPVh5eN/N1gQhwJrJ2lTOrLI5xbBdI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775494965; a=rsa-sha256;
	cv=none;
	b=NVXWEZ75wjrCB5zA9uNfhi1SNL6isfZFx49/B7Gm7zfY/Qi/4rd7upfZDkoaVv/8ISnzfq
	G6wJDuAZOkkJ2sMyIzW6TYYGdTWDoCUnInw1X+gBEL7gXF3AE4Yb0l0erVc9lJLOkzTajt
	M3ndyDwMmuGshyHOY8obmxz3b5AkKtE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sRekFqRb;
	spf=pass (imf07.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90B7040910;
	Mon,  6 Apr 2026 17:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BBEC4CEF7;
	Mon,  6 Apr 2026 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775494964;
	bh=1OHRxbzs5ZLFp5EmvSXkhp4DU8ALMByenOOrQqA0Nak=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sRekFqRbPP6f7L+v4sJvXmNEf4oA2o5i5iBPaKOPHYUJiSOna11t65QKJpSbdkqQX
	 QPoAnKM1ILbSaVIooKb+Q12e8gd1Of1/lILNYlkYtzBftWYp4GRvGw0cZ1J5hD0ILj
	 wRP4ZRTW3fiQ55yll0GdPtwpTkzr/dsyoQNWP3lZ+JIwDbJ+t2edmQFfg+4N4Hyx/3
	 u1JqOysGAANkjzYWwPQ07JjypMFuiHc+OV4jnvBAWuMjNbV83RwYwEgNFSfP5gtu5x
	 gaP5nh4YT1vQTZZ8UwCZ0EtGUjLaAwDCxXCmpLuUabpJYXVVySl7m5PCX9G0wcW0+s
	 H8SxkIYAt7XOg==
Date: Mon, 6 Apr 2026 18:02:37 +0100
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
Subject: Re: [PATCH 16/53] selftests/mm: protection_keys: use kselftest
 framework
Message-ID: <8c36ea8d-946e-4c1f-b8c4-f2def693b419@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-17-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="guarDYyngoZXCIIc"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-17-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspamd-Server: rspam12
X-Stat-Signature: 17e16z84qwwboub5s5nzz33ttdma5ozt
X-Rspamd-Queue-Id: 9FCCD40013
X-Rspam-User: 
X-HE-Tag: 1775494965-505401
X-HE-Meta: U2FsdGVkX1/xSfvN97zleq3rOhwkiaY0eqMVtC4LubLMkW9+5BH/RXaWjIJLKdCc9yJhGhti6wqaHNCcCIQyE42T27zDr5y08XK8hd7KdzLjq9knA+eayV2x8GVwbfbuogWarcB56zqOqdbi/yWiJ2EIfBzzW7kagGxYx5uYbg47IX6v1FJLAnwOKbPNTQg7HDP5YfeBi0pkKtNe3Y/upQmFD2189lJuXPnJFWYpOvFrv8EQKfsL7/Wedk0JXkKntDWeisF6fHRMpDh7Q/94sqzvwitiqii5A54weyL53n9JglztE2+qbA0e3N5H5hoR7YS/FhbU3dTHPKObmj/QBzHWoW2rNv555vREImOy/7DBXpD/4IjojMEmW+uIlgc6co0kIeC1ErYgKFjSB2hWEGEj6S4FWujTiD7GwjR52lMoZeChieM0FyIL5dqTbyRUGt1ybHHp2gwxjp3p5vxuMeYY0NOwpaVnxdURLZjOGA5OIGgrK1ZDhu9To7krj8PjoGD4O0RVE8lxdS69IK8pWe1N72qp50dvk6BE+DHSVSenwKNzOhHs9Fw81l4dFgUEX1GXZjIvbcqxfaT4HgUtBaMnHgQDRwIRkCcOlwzihkld82rChAbIN0bYkIqWMH4smEs1E0PAhOiHLeD5157OWMlJAFCxbQS+z/oLMe7n/qKvD1Ens2U7UVclomJxai2VH0haIs7o28dIf67fnwimt0up4UmFJjdy50Qi4u1j06Mm1cK/1l97FOielDeL47SnP/3iQJqNBXHk1TEpLbqk4VDJ5dh7qAOnLWynbn5jcpl97TZrsgOQneN2KQuYkWcOJav1cd1KYc9klWR841ote0kVSb7cZxiAlqAssxblrUP8UagRGmwrzUTJXsLtBKPbKrZsqQo0YjbrB63hgX4sqkDAWGdReFtXBlqud/GL2r/8oBiJeIh7MuGg/uhmAfvloqzEbI+NjfRnxUvxIOA
 xyK4tj2s
 /4bo4igIRZdPBOibB+aCOngAL4uzsxzPfFAI33smcrubKqlvl++aMoY1HLANQD9jpnqV0fjBYrt+i+gQ5imFp3lHe4JMLZFNYZqd9aG+VK5ZZlGpWjWVo0Nyu5/SeO8aZsxP1huqYRpTrzpPh+3CSdDbeSMZBTRtNtXfTtW9DP1UJ0KOZFcq3VzxLjkmjUdGw/ctKLbGPc58524K4AWwIvo8wwgD+WENKw/qbzqN3untd2l6zMtyal6/s3kYlnGAimRCZHVKZzS9dgxBxG9VdChnBCgAsvyRcqVcydC6mSbQKbpSbOgKzLT6bvFVjzivp1UroV8nOTTNg76iYaZmFlpe1+l8az3bZRWWKEofuR0rlREw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--guarDYyngoZXCIIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:16:58PM +0300, Mike Rapoport wrote:

> Adjust dprintf0() printouts to use "#" in the beginning of the line for
> TAP compatibility and add fflush(stdout) in the end of the test to
> ensure all the ksft_print_*() messages are really output.

We should probably add those flushes to the kselftest helpers (eg, the
one at the end of the program should be in ksft_finished()) if they're
needed.  It ought to be redundant though, we do set stdout to be line
buffered in ksft_print_header() which means that either ksft_finished()
will print a line and flush or for abort_hooks() it's immediately before
we call exit() which should do the right thing anyway.  If exit() isn't
flushing I'd not be optimistic that fflush() is going to work.

--guarDYyngoZXCIIc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnT5ywACgkQJNaLcl1U
h9D5Nwf+MMYxIQWa4F6gozvVcNV6+ePvHrr6/prRVcCkxODrFSS3spHDUaCWC7Bw
Exj8uoNR58d84g9XdfXgrowyWDgwSr48/RbUNIlB0mn732lkugeTjpJCa8MFIMgG
rMLTgZzFVkwIge43kxq1CWct1RZqwBDGBZ7MnBXnpzTwABu3vrROZ1Hh2sUiVx2f
oAbDIr/1M6z5r8goejyhaTS9csE2I36eE/KdRxblWzBZYFXmXQFgLpMSbsnL2OcW
Z0RQDsDPT44kt/UTG4gaF/k2+awJkDDRmk/3X6H5H/Ieqcyi7Jw5IHZAaw/RGDgw
eaPqUDkSj/y4Rc6SQgbwELKCP7JXjA==
=vqHQ
-----END PGP SIGNATURE-----

--guarDYyngoZXCIIc--

