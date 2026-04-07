Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52E3FEEF29
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35ADC6B0093; Tue,  7 Apr 2026 08:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332386B0099; Tue,  7 Apr 2026 08:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F406B0095; Tue,  7 Apr 2026 08:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17CD56B00A5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:32:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5C711407E8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:32:05 +0000 (UTC)
X-FDA: 84631697010.22.DEE5ECB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 37E501C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:32:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbCml44R;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775565124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tt15GGoXp/TGSIxh5bRlz7i0yNHqkJhNq6grYas05/M=;
	b=neMMi1vloECPbMFmv1IJvFUBakQQmzOSYMgX6pdq1ChKaJLqzziqtUeHANOpGu9cp/6f0R
	w13/Y8+ve/T7IsQNnufRANy0f2fcsUojkeX4d/Yk6ViLB1tLEehsM0Q+vdK0eDMjGwp7jU
	mozZNoLv7jYsVEvKWb4JW0bPc4+UJSY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FbCml44R;
	spf=pass (imf18.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775565124; a=rsa-sha256;
	cv=none;
	b=6Xb5UU8cED9EkTgtByL18yEThfNwvwC1oyECVmXbSc+dqhbMeHbdTw9Cq7GPRC6DHTwjK7
	FokdM41WiJywytMLsq0RhTvue6A8XnZY7kgUUIHvNA5LkRBDEoZQETaDRIVNQT6KEh+ajB
	aZatTUTeg1w3ioRaetcamb5g3hZ+JlU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96FD8600CB;
	Tue,  7 Apr 2026 12:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAC2C116C6;
	Tue,  7 Apr 2026 12:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775565123;
	bh=E3V/mC4oz9GJDgxzY0OoQ1w+qOnILhdk7/LORFd17jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FbCml44R5kyvcb1qhy4ev90hWUk4djZ8TUrfXthivSW3tQzehmMzHzHMQtR6z0XEy
	 R8r9ACjTb2QtMFeiEC3+1KNPkhd9NLm724l1ahX1EkjD23c3Vm5AsnvcDQuVlzFcVf
	 lo8KLwiaWkBr0ddMS9b6lCwvCT4y3jsruVqC4TyyV4iSahUQ6rYERdlFhMonSK0FCV
	 DJTFhrCnIE2/U0qamATWOQIrr0MNifGt+XxwxA7aCdwMU5Qb77G7RN5toDXM6hMGjF
	 qk6tpRUoojYAczUUq4ri9mikcZOcxZWxSeiROcu8ynfrQ32g92J5c+xT4ZoyyjrjFT
	 HGmUkhjpeBSng==
Date: Tue, 7 Apr 2026 13:31:56 +0100
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
Subject: Re: [PATCH 17/53] selftests/mm: uffd-stress: use kselftest framework
Message-ID: <013a8bc7-722a-4d50-8a7f-d6e48a70792d@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-18-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xv739QkPGomL9e4F"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-18-rppt@kernel.org>
X-Cookie: Now, let's SEND OUT for QUICHE!!
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 37E501C0007
X-Stat-Signature: am4fo7g5c719tdbrysq4p8h6dyo3kfih
X-Rspam-User: 
X-HE-Tag: 1775565124-621088
X-HE-Meta: U2FsdGVkX1+/m7JddgxFOVffqYlD6WnUL2KntBuJ3cvFnS710xfN2iyyoGSJAutHf5nEDpe6v/GwQbPM+3C+hHx7nosAyBOjJQr1JILMrm9icgnPe8LiMnINYcpkOJlK79x8FZBS2PWNuk/8srqrFkQi11bpD6yRop0ruiIUQpjuR2NG27dI/FVmJVHtD0FhF3/uySkfyFO+Dpth6Or3/RCi0cR/ohxjUmtPsKvXAHBYCJL7oE8aDK2MaS/QC/EZg/8ui6QOHunuYgaDdSONiRF85xsbW9gqvSIc81VwYtBWgfJD53MkHM40NoASYp01cMqBXSVXSGzoRcZJJJHEA5zhdMaH6AGt0kMCbZRv+7CZPB3g2MsaPWAj2ICixu3M4OlXncif47ia+CLrEzsnOFW6u+hACXQufHem+UtbA37by1wvuhuCUweHiL0URi0j2udw3pnG9g4QRfxJgKuVTRArB85htopNaZD/yCpNUKiSvTwQAiq/fIqIeF4HK0o7hD5zKpDmgQZWdnImOdI/rkwl4H1hrTBrpQbrysRXC0rMMUdhcR16yWtO/enTmOqKuPwq5Tml1Hh5gQh7zvVmI1I3mTxw+58vB//iLZ0yE9Hc9CazHHWKF3rOt2Pyu3ySEq9tJMk8q11VLmo0FS7W7DExL1HJjd0RbZYnOlQ9wawFTMjI3O+TH3OGAkmhtN3l4k85+oi88GhEhIFsdpdBkr9IV0SKMmsIVn9u3yJxzM5stQvj5/S8K1HY0uuIAL2LagnNCxtwFd/BXGlBRF3TOn5ySXn9qip3o6qbUhq7Cj/oQMTJmQXwsC+/IRebEWWLft8NSuHCm5uRKXbETlpcKMlNhrEKBpw3v1+wYUnIQ3KjfaNawETEAVcov9hIUWMTeLCZfvZjiI6bFEN9NP+DjR5eEy4phocjgigA7HXlPG8Im2C3cNXxCaChOobxWdZ7AM2J5fLK472PIvDnAxr
 Q5FrO0uN
 my4vba12c339G7vTOCn5ssSpy5/D3SfrNXoSOMP+1BiSvQibA8qKEoXnkF87L6/9/XSfxdWp2iw2vsGDnkCet/54FBALSAMZVi7Lf62ALisQc8TsrdF5T20GofEGNcu1KwyOXzgNpq63ZXfkDTw2SaUWIi9di8cQlcxY3HX2YU/gnfDehlaFJwxEX23++5WUolAuh8JZGC84qrhmBCriNBM2QN2nzPrq1jXadoI7rxDU/CEzXOOTyTUN+d++OWHSA0tJxMwACXS+gINLXGr5pr2PsWFkses8ZQtnCPQGU5XeWZeJQyvhsx8mz+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xv739QkPGomL9e4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:16:59PM +0300, Mike Rapoport wrote:

> -		printf("bounces: %d, mode:", bounces);
> -		if (bounces & BOUNCE_RANDOM)
> -			printf(" rnd");
> -		if (bounces & BOUNCE_RACINGFAULTS)
> -			printf(" racing");
> -		if (bounces & BOUNCE_VERIFY)
> -			printf(" ver");
> -		if (bounces & BOUNCE_POLL)
> -			printf(" poll");
> -		else
> -			printf(" read");
> -		printf(", ");
> -		fflush(stdout);
> +		ksft_print_msg("bounces: %d, mode:%s%s%s%s, ",
> +			       bounces,
> +			       bounces & BOUNCE_RANDOM ? " rnd" : "",
> +			       bounces & BOUNCE_RACINGFAULTS ? " racing" : "",
> +			       bounces & BOUNCE_VERIFY ? " ver" : "",
> +			       bounces & BOUNCE_POLL ? " poll" : " read");

This is going to result in the output of a nested line start "# " at
every print, is that desirable?  I think it might work out OK given that
there's a stats report each line which will print a newline but the
whole thing is kind of hard to follow.  Some comments might help.

--xv739QkPGomL9e4F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnU+TsACgkQJNaLcl1U
h9CZXwf+J2YrNrVT4p52lqejfuS/3b6Zy++BrtXR8nKcyiouVov9y48jsqwl/dfy
sv09vtmbtb00shlFbawnMzLZZ47c18p9sxXZcIZBiXtgOItUehI5LdAV1wpC9K2K
4AF59vBgfbLOXT3MvNvv5v320WRZExc7fOuT0SId+hCYs7FNb9nOzW9DDDjn5Hke
wtMW2lKe+Zw1eZiFVlb3b5SdsCAvA35P8GF7yewHZBSdw6RG7oh2EH65QsySz4BP
HFuR0pTneH0H81YU0MVDjd52KrLojI7OUfkvy8tlzMhhP8YDXJ65KySbK14pklrW
jodMVXPx/2C0319Go+dXY4hw7Nks1g==
=nkoY
-----END PGP SIGNATURE-----

--xv739QkPGomL9e4F--

