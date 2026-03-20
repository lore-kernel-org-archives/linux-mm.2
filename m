Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7AE108B913
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 12:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E586B0005; Fri, 20 Mar 2026 08:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06296B0088; Fri, 20 Mar 2026 08:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43236B0089; Fri, 20 Mar 2026 08:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C68BE6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 08:39:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5DD56B6880
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:39:58 +0000 (UTC)
X-FDA: 84566398476.03.149AE65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A44614000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:39:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFLSYUpD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774010396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oj7sXbeo0DQ6fVekpJ4aIEkL3Ivz9VMDUrNZ5gZpa04=;
	b=i9SCgj9vpLW3JGvbDvM4z7VrmIswKNRnltQT1eyOW9lYf0kHTDLRjcZxWbJ83wke+5auna
	YCQDXzvcQ5w9P7U/hT1gqX7IYxZB1IjlZONIM4cm6h8HOXjGFs00UIO2N99ekhcEES+HdV
	HjsBs3MewonH/WvV+20LnbpvHaWbs+4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LFLSYUpD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of broonie@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774010396; a=rsa-sha256;
	cv=none;
	b=eBELR8prSBZWzjg6qSYQewCoxdos6YcADNOlkOsuKHNbHm2fLjF6pDdlahq/90U6TuqRjP
	5moQa1dYeSO/RbiuYLuXQMUlmdsM0OZer7sIKERmHGz8YUAbiVzAkl2ERhr3LCtvrc7xh7
	Wvkc4yDR28nWfEAAQr37rCF/mNEe3dc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6055A43692;
	Fri, 20 Mar 2026 12:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099E2C4CEF7;
	Fri, 20 Mar 2026 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774010395;
	bh=kLImuZo+G1Y0fhj06VkAqwT+qra4RFbNidP3jdkzDrQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LFLSYUpDXlejstxSbDCKoVAHNj39NDPR/4TI/tqBisgNRHI9nzqOAfrKMS0iAXnPe
	 BFZRH4lHQativ8RX9p29O6K2mmoKKfSHCNl5Ege5p4ppd/CX2AOCUpZzdJbSDuzYZc
	 uIWMltQZn2xw//WgJ9r6oWfRrgBTPwtEAYvQHyvzAArJWhzEzs0pcRy2Bwzqg0APJQ
	 xP5F9uQq8ewqBeW2dMqhZUe7t93vDM9iSyjIiynvuHCXb25Xd08PafH9iwLbwhoXVf
	 u4bgv8yIeFkEmcIwRNiOnvTp499YpTUbbSgfJAoYqhjRvLoBojGVxanQHJSheDk1sO
	 jhTUci9yIVngA==
Date: Fri, 20 Mar 2026 12:39:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Vlastimil Babka <vbabka@suse.com>
Cc: Lance Yang <lance.yang@linux.dev>,
	syzbot <syzbot+8961cb270ae74b4129fb@syzkaller.appspotmail.com>,
	david@kernel.org, ljs@kernel.org, willy@infradead.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	linux-mm@kvack.org, baohua@kernel.org, ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com, dev.jain@arm.com, ziy@nvidia.com,
	linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org
Subject: Re: [syzbot] [mm?] kernel BUG in collapse_scan_file
Message-ID: <4f1e1560-eb13-471d-a051-cd62c7d169ba@sirena.org.uk>
References: <69bba3c0.050a0220.227207.002b.GAE@google.com>
 <e92ca212-9ada-4cd0-8d54-2f433d6d47a1@linux.dev>
 <5eaa234e-76e5-45ec-833d-64d76903d1bf@suse.com>
 <44cb1295-c2d4-4b94-a9d7-9ad369d0f2f2@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vzcA7YqmIVwbJPjD"
Content-Disposition: inline
In-Reply-To: <44cb1295-c2d4-4b94-a9d7-9ad369d0f2f2@sirena.org.uk>
X-Cookie: Who's on first?
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A44614000C
X-Stat-Signature: ejdf7nikxw7ts76e7crs41npeuz41don
X-Rspam-User: 
X-HE-Tag: 1774010396-633067
X-HE-Meta: U2FsdGVkX18J5akOiBTsAoGAahrmwLurDbtiVdiqZT+5ZdsPvf5MdEtDrn7s/VP8UV8tXsNlCWzhKDyZX90xp6h017lrBx9VrqfmKXhfUWSKgbVnW2dlNogFUnP+CACgW6ZItfihbzV1Eno7zfAtAwn8hwGU//29c+P2Cn0g3i2W/SsIFVLWcXtW4YgLfuF4aVAPjJ/VraiOit5BpDGI/kPD5pTckX1hsKQdsazbcXbfnvKFIJEdxdwenWPD/BeLdHbpH5IrZENfhIPEn12B0qyR4OglNTqPxatFg5H2kUjuW49rD5Oa1fWR/M+ZeI9Zu7gXryikyU6KbtyUUWr4qyu0vvvuMUQbkUQLOYexvz+/nP5SsmpgMHwO1DpUG4Xq26n7CiYddproh2JnWe9vwMLqpYclo8PibJKYzLWFZajiglo61LDPJeiIJy7ibwHPqoQ05JC9a6fJ8T8nP9lCuO+ntqXXoVrIcjKusZ07nVC7Cm7WNKOeXrHnaDbfCEgPG2BjIT7fL80dS7KiXNBUS6/2rVmiC4yKSfImdY1OKLzp3qKBtmiZZM33X/2yo8sctTZO22BrCCtVn6dak8FYAuN7sIa+FCcKO9lYFjn+TTf157F8LnK1d7FSr0d8FVeeo9bXLTMvlu3+h+B/GvK58dUmM3NbqRt1phGrGI9f0g55Cr5Wb6h233oivrXHaXZg8dVgVkosOBcAvHYEP093HPrvIk/znsSVxBOWu1siJ0wvzzXIwd5354T8/6l+jq3pCDQssbc7XZ0tMcJ7h+gr//l58rnE9wz6te71SDMub5gbQfjFQbmZMc9hjF71IKHau7/p49jQHsWSMzOZKWyM7ntVwXQiZ8Sgt6mQUar99fhzmTOC43SbIZmvKjmFpQzn4g61wFatZaS/l1t5sBUg+r5flFk4wWHG8ufQj8mId8KzmL4NBcwWaL3LgKPhFMPPU/sMnCDKS1+HtT0flDQ
 gQaz8z4B
 x5GS5Wf0+AUyd/TAbr3P8zg919KrqvySZoTcWQvUo160fsNi3Ad/xKg+/y9C7nQFBEt9WCrlpweY5Qbjl66Zqr3bgyXWJgGb9JwQMy7JnVPLReNCzy7u+QxtA1H6sil7vwgzfMnu4c8MhcrULwFZElKcvKdmDK6pxMV+ZEDd4eTXM5GGsst5DTPUeep2+ybNSSpdheuftft9u9zH0I/zQm2ff1oZu3mqJARTFWYDgzh2wDwk0zDa83LF0CXw9/DZwGxTaOnZsOTvpAECg+N0ZzMMf25hXLrZdP2o6reTSvYJBPsFd0aWWgQRAn33qbwEoYlRjYw+kY5aRw9POnRwQX0gQzi3RZ61f0uu9SsYiTCZ1bmDcR3aPSOG1qxC7mKe4nAmWzuKHRvTQpOcXowEK7eyBYANFpiHzYcsBYAeS0JwoR0QNQBZSmXt7dv2BzD8y7tTGidTD/JHbjS4rBuzG1rzuOuTgfcPjR/xjwI9h2yNosdyByvuc7wCM3YI87OmJ76FaAtIgJtS2h7Rb3ClJbwHRjz0hwWvNrPMFyCicIWmmBSsfH3O4Qaf9EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vzcA7YqmIVwbJPjD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 19, 2026 at 12:17:12PM +0000, Mark Brown wrote:
> On Thu, Mar 19, 2026 at 11:56:21AM +0100, Vlastimil Babka wrote:

> > Mark, please drop https://git.infradead.org/users/willy/xarray.git from
> > linux-next until it stops breaking linux-next. Thanks.

> I just saw this mail, I already started running the merge beforehand and
> don't 100% trust the scripts not to fall over if I make a change at this
> point - I can drop from tomorrow if things aren't sorted by then.  I see
> the xarray tree hasn't been updated since before Christmas.

OK, I've dropped it today.  Willy, let me know if you want me to add the
tree again.

--vzcA7YqmIVwbJPjD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmm9QBQACgkQJNaLcl1U
h9CXUwf/d3ZMK02PmFBuznuTf53ciCc48176LPVgCO1keeiRfuu0PbYEfuMTfTmh
M/J1dfseUYK+fi1VSijjZSvg+AIEU49kwSy/hIdSCPJpcxhTexGvQoo6i2ofZGnr
knaJrYZQm8H8SyJvjdKX4RGAZBqu9jO2yv+BeY8CpFz80d6P+0FzMe5UTAa6G4zR
iQ2T01g5hZJXCSVwcS4owsPn30yPZDW61+VOmzmZItQ4pOmQ1p+Bve6ERiAXXtcU
pRmmogLqLatc1Nw+9Q7wlVPM30f07Fds/hKb6v6Umk+amn4h0MTq8zblNd3alrmh
n8aLZoWKdzeP6+q8FJoELdPDmtNKbg==
=ehzM
-----END PGP SIGNATURE-----

--vzcA7YqmIVwbJPjD--

