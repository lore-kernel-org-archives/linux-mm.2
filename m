Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60747F4369D
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912AA6B0101; Fri, 17 Apr 2026 09:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C32D6B0103; Fri, 17 Apr 2026 09:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D92D6B0104; Fri, 17 Apr 2026 09:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0366B0101
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:10:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4E9A138E37
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:10:36 +0000 (UTC)
X-FDA: 84668082072.23.A96365D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2CBAD4000D
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:10:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V40DcYvM;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776431435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5WsutlrUDKMCjP/2sUb7I7ucWkl6mhUzjWV+l/nKpe8=;
	b=LziZYGqSdgfVnBIaYoGfY6aG1O5Gh4amPe/lR/EkGv88ybKRuGZQGbRNt20frbUmszX3HT
	rZlX5Wz1CsJuKie+4F3o17LDbTP5CUS6f81qwUF3388YocLqgavLeWQZ7DwLDmhdwuuX1y
	h5QI7Iixsk9186mZysYpE0nr2gKjfeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776431435; a=rsa-sha256;
	cv=none;
	b=xzQVZVk/z+dcvB40ysHjLp8M8prh9EXMOPmDh4G9nXhJc9D/poBPAecgwYtE5aKYXMckmW
	Wiqb7mEIDXVvQbLHbaPW8KN/QETZxLBIdrLouWhpp8mueZmFLNJF7LzOwt/DGbHF/px+5S
	+GoMmQ6Hui7wc9mOzkLIKYPAuoScgz0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V40DcYvM;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E64C60128;
	Fri, 17 Apr 2026 13:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B17C19425;
	Fri, 17 Apr 2026 13:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776431434;
	bh=S0nMWMkEdOz4BRrhSoV6itAbptEUCdThzYvRAvCodLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V40DcYvMWWtmCH+5BwCYDlitfg3hbz+z2m6mnpmXeiMX4St7/Uzh+8L/cXyBE9eN1
	 EsaiLoR99oEwbNkxqmYtmFFSa52g2MedoatY7WSvWBXTtzKgfFJw1oGveYVGAKLdcH
	 zf4X2c4Eoq55mVYoHAQv0gCO/TpWowi0lCXmVNuqv588RkD6rh9xbm0i7+Yh4AednP
	 A1KrsDHervl1QTVqTAgtWbdFg6if8GFbaA8KC9LyrqiMMzMkfieqOMS9PYbT8PcoRU
	 mFaIqeyZsGnx13821FpNj70UzJbUllTIgB3phEkzCwWg2o1lZwig23c4nxhvGcm9F3
	 l4RBYs8jgDHog==
Date: Fri, 17 Apr 2026 14:10:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Aishwarya TCV <aishwarya.tcv@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Specify requirement for
 PROC_MEM_ALWAYS_FORCE=y
Message-ID: <0fef4cd9-e897-4830-9d37-f52ae9a33aa1@sirena.org.uk>
References: <20260416-selftests-mm-proc-mem-always-force-v1-1-3f5865153c67@kernel.org>
 <17ea54b2-d43f-49a9-9dd4-d2330a8daa92@kernel.org>
 <5357ef55-15c0-4c66-867d-898fa7f51414@sirena.org.uk>
 <aeE4XSuXY8RfphVs@kernel.org>
 <aee4e68c-077f-4056-9d40-69bc849d1538@arm.com>
 <aeIqg0m3YL9OAyH5@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="edS2AhsUYP5/qUYR"
Content-Disposition: inline
In-Reply-To: <aeIqg0m3YL9OAyH5@kernel.org>
X-Cookie: Uh-oh!!  I'm having TOO MUCH FUN!!
X-Rspamd-Queue-Id: 2CBAD4000D
X-Rspamd-Server: rspam07
X-Stat-Signature: cy3ucec9it9gg5r44ps8q7ptd5sbizrg
X-Rspam-User: 
X-HE-Tag: 1776431435-431053
X-HE-Meta: U2FsdGVkX18XI9WwTQtG+8vLe8Ha3mA3/LGQj8/72YJ+hmrq7Swkg1zCqJnCC5LOXj3QO2FkHh2nFRV5A8CV4mQpzDR3i9bTS73lXsyRUy+X5gXv7s4XTJyJGO0jwpjbV6IV0QkeyseihXihKdHuZDFuEpoqfSdIaaFFsYVSAhPSF4oStTl0iQTYWE4lHgCEBffFKT6i676Z+w27aPR/kn8fCxht5L5h2fl9b5xhHHP/NE4u2GV6weiC/ALJ74GiQ12fTcCV79ZX8jBWxZuQ+v+lL7AFm8i9on7rN6WaDrSenpEtJdIoAxBQvGiGnpAqK58KVag8O/AkHGPfbnxsKJB6owhKBdEkRyQq8G+qq/vgbW2emBeHBGHw7kzqEJEZgI+MuVdFQcjfcAk4vOfujP6fDjctEMb9rUHXLBGkDFfgX2IUoq/xdrPn7Wpwmm15p7T75PTr2de2A22IuqZZJuctYBVtJUZ3Z2w8wgXjX1WL4CGjFXeMqvWOL6em8/u5NM+9lJKlo1VUSfbLJR820LMYz0QzRE2HwSBhXgB7kZB/UrOGPbRXXBu6uYI/rleh6Y5RkL0ZGR5ueAvvUqbdzSs+aQzKTcGMC0/GnphTw/QU2HoWD9DcS0dXqmDdrY3IbJrqY0/BSxq84QZbtgKyLpe/m8X5grsxs5sZV6b8TNXGYcItqdmV0wAPe92oordIiWbuwazsGf1GqxO8N0QkLxVgMngYy0I/xc46vdtArA28+ze7WMXEvpjej6mFkWMU/aR/QindZK4iwkMWLfzvdAB+N1N+o/vOFN++80joiXt/mpAO10YmWREakvrZrJMiQWpJfTATKWCqAvckBjd9yNzhdGl0yZpBmm7omma9+TnmMNWKdps+FmzZmFOC9cg6E0QkmKRsm+AtJcqhYfWaW7ZhSgSkyPzisSBLUYX392majVP/bSnl8tetbU9jwe281eJeBkx0ASO79wk326y
 dieOCzvL
 btxjwxRneHSrMq3cUCF1jiwuBTOGVelMCD5HR1YffG8BMNHdEYUUqQc0E1K4KkDgfpZBIpqzWJxCxRoP268jCeUjb/zXXs6ejtF7jdNd4uMgDNtikHFHF7SFxTjkPBhryJPpbowAqhgJy9uV2LW6zQ/A5d9A9HG08SkMhOstHiROKiwLV8W0MlWWBUjNtQ3gQwOwAPsprC5wKFT2NGYotIwPDngU7kwQnKjaTdeqwsS8mTZ0Ygw1gYKBchmH9OTp0WdBhx/nvYBUfFuXXylKjjpQZKiilUHzATHbi0PRBkfXBSieIDiluoTmYOeT9SgyQzqmEou2iPp7NCCTKHQIVbCnGG63KeaghQny3gU+aPM7FJr6a6AjZOjop1f1oyPSuSYo0kNPR5KmIWMhJJsgOSdXdjWkpiEce8z5k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--edS2AhsUYP5/qUYR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 17, 2026 at 03:41:39PM +0300, Mike Rapoport wrote:

> Yeah, the issue though is that open() succeeds regardless of PROC_MEM_
> setting in Kconfig. With restricted /proc/pid/mem the failure happens in
> write(), and there we don't know what actually went wrong.

> We can try checking errno, but it's fragile and it's better to fail the
> test if write() failed IMO.

Oh, that's unfortunate - you'd have hoped that opening for write would
fail if you can't write.  In that case you're probably right that we
can't do much better, possibly adding a log message about the potential
missing config but not sure that's worth it.

--edS2AhsUYP5/qUYR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmniMUQACgkQJNaLcl1U
h9B8QQf9GBdnFFlhg4G17leX5BmBV6GXASVwvG8Q+tTuwrKGl/PCE1vc7KQY8eCr
4kAO+GSsVwvxnqz56RE1O92/xU99iiUd6wFbIfpc+ATWTN4jxZk9NIt/FasNFc6b
8gd/NYDi1rfRGXGxNwmYJCNh4Cx4XM0xe6VZ5dwhyRIXqE6LG89aC9UWROse3Q7n
TR5nffGMskQ+FhIpjmEHm1UWcKaAj2yIQ9b3HPQBSBMN3nL1jQoH1Q6mjvaOpHOf
1lw3/0h0AfTPMOhiqRRTORBxnelE8WqAt4JwqwA7p4LgCg0JoNCnGtEQmwDznANJ
rgPYZ66U8O5kbvDJMzCWk2bdqPCZNg==
=v96S
-----END PGP SIGNATURE-----

--edS2AhsUYP5/qUYR--

