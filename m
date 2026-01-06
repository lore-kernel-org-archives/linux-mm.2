Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75529CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 17:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D184B6B008A; Tue,  6 Jan 2026 12:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0006B0092; Tue,  6 Jan 2026 12:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C19AB6B0093; Tue,  6 Jan 2026 12:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B40676B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 12:29:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61F5013B72E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:29:59 +0000 (UTC)
X-FDA: 84302226918.06.98B5959
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E4BF0100009
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 17:29:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G4/ASQjj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767720597; a=rsa-sha256;
	cv=none;
	b=r608gRlnnpHUjGo1i+c/OQSo9SgBFozs5XqLjOWSjOatXRozlfyFYpzQHvymA9VJPZljAf
	SypaoyZbqckhpiyIVBX7BoTQdZovsUgbeeSW0TFfNhFiWrBsbTvFC/NfxaH2pTRNl608QH
	hE/lepYE8Xy4UsQlYeJldgAdFvZIpgM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G4/ASQjj";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767720597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bvk4mAWm+CguhJ+cTMPXOAcLF+P2foSMTEwLoiimpkk=;
	b=VlyIGO7Vq1B1+qiQ65Tt26IUHmXtSowA8rqPZKLN3y6v2eLgdsGRUH7c5hxgZUj0hs/gi9
	OHBYAd2uPUCJLnQGiaCN/S02IIqRnoAaVvCx/GEv3P8oUNUQgT6Lg0rVnGw0J/pn7oo3wB
	L3KMzypF4fx+9/ZdQPLBpq8oRM3vD1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BA9A6011E;
	Tue,  6 Jan 2026 17:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4802BC116C6;
	Tue,  6 Jan 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767720597;
	bh=S59AIhszH1mltc6DfCoGlRJ+0/sPO1hMLyo8OSVvGME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G4/ASQjj9n5SEFj3Y3lei8PxO5TbigT6vEzGbkddPw5ppErLKA4dVT6q7harmTpUL
	 SnDZvChCe4x+vEqiPm7N0qxANu2dxvIkT9otgrgBQKbOevxt7t+KWEr0UUUArr3vYx
	 N30dZ6i3I3VEuIX1DaZ1xWvsbBDOxU9qCp/blaPJfLr6Ld5+9kPjM6CaDz14LRqLa9
	 CWtIzL4h0gWCmdN9q3OV51jaVYxojvxYEnUQs2w8a7FyLRVi5q9EaYTFP6iSUinniD
	 9gLrx/BKcecZwSHVQTa34oBOGj7h5TRy+NN1op7XH2HQRvYaPVwcdnciObu8xufofg
	 /OWnL1pjedxFA==
Date: Tue, 6 Jan 2026 17:29:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/selftests: fix gup_longterm for unknown fs
Message-ID: <56b7d3e2-fcfa-42c2-988f-907086f031d1@sirena.org.uk>
References: <20260106154547.214907-1-lorenzo.stoakes@oracle.com>
 <20260106092836.d6a4fa77b755bd989d1521b9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1m3/mpdwsBsKXyRx"
Content-Disposition: inline
In-Reply-To: <20260106092836.d6a4fa77b755bd989d1521b9@linux-foundation.org>
X-Cookie: People respond to people who respond.
X-Rspamd-Queue-Id: E4BF0100009
X-Stat-Signature: 5c44k3bopx5c4hhgqteanzewhpxhrt6u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767720597-973649
X-HE-Meta: U2FsdGVkX1/Bg1bUbqHbjwwlwkkeUF+CaE2Ik2HErxvpAuRxE88gBRNVHoXZxgC5nlmanlj7F01+tJpCQcFznCpp6Y5Z8pcaX/tF5dLJ66zYJqQ+gZBEyIjL7L8NE7CMhjiKob6f2/M7f7u2xMpU3T6qhSdDlhGZB0JwlVb/2BzJtzJUEk2odMWMkRCHyNyZAOFjqAOpXOnyc/MH3+YVC+NHpwU4hUVOKt7mD78EOhMAiclqoJdiO8IKQVNnMXfbeXRJ/kxRxZwQqHOTkvBk1LblpiG17QjOMEcHCtOj4iGN8aXddgl07L0X/qP3NOi5BbwsLRrjG99i3uQP1Y57EUDoUFHx1Ss8akd/KMDvf9AUxMGoQ9rY6r9hZRYrQBa3NXqnELUYkoQai3JalxSfz/bhbGrZoPGyn5ZFbXWrefYHTAJN/W9hNUsu6D6ffmuH+YRQCiuQr1r/s+Qy+gbWRRaYQ+CvV4shIuU6uTJeWFTM69slOdWa/i7JHuk+P/k8Itk2PonoxwxqOzVdu20XLwKDV2Ujnp31h1u1tTpfyX8JZyMX63DbK9OyLq3KurfnPAxwCwEyI5T1sB8o3wtKQC0qH2Tug5XkBgpSP7x37kqmDvjxyHGHP/uDNYEEHjJ3DQBeZlVjHf+r15CflBslkPturCQi251Cx8+/8kQ0seuYzgMb9ZiyZz5mXS2843tqseAq74uYERSKh7B4QkZpLHoMB1PZwY3M/kXlR4Xw+yVJ6nbEPfWKH+50yWj4tFESF4XBk9VmRiakKOT3VzQ4QV8o4bkKMlfqPB+jezhzUvOBi+lS/FEohkZwGGUwe7G1GdV+7TmYrGveycn7I8fsVyoSKgLKG9GuGPzTihY7LZbe6uEzWgLOlRGaIYMXf1O0UCHxVumDK2+f5Zj9Vlm3ypmTu5Tqon9yCc5WolRCRga4lotGgW3PGi5/+SzX+TJs8gy+xMw+wQR11ms/8Qv
 Y9t+Crhr
 8c+SNUuNyNV7pms37kZFnyeHRKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--1m3/mpdwsBsKXyRx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2026 at 09:28:36AM -0800, Andrew Morton wrote:
> On Tue,  6 Jan 2026 15:45:47 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > Commit 66bce7afbaca ("selftests/mm: fix test result reporting in
> > gup_longterm") introduced a small bug causing unknown filesystems to always
> > result in a test failure.

> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Fixes: 66bce7afbaca ("selftests/mm: fix test result reporting in gup_longterm")

> -stable users might want this?

I think so.

--1m3/mpdwsBsKXyRx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmldRo4ACgkQJNaLcl1U
h9CM0Qf/S33dckv3loTsZRKZjDP/+2/a4BY6PGpohLKe0w51tgiuLCxd1X/2jk6N
ky7lf8dsYp0n3gH8X5qNqZkV6ORRUPjNFbnwjb4+uz/qboNv/tb71GeHU+hGKDDJ
8gFFUMBBhgwP5sXymPeIx0x3zY6c9/exaja3RQJxAgu9aLw8MYID1LXhT4zfsh8z
S0X+ifWgfr4qcUzuVwE0uOoBWP6OqM5cINm2oLf1Gj6QawsGJVn+J8bJU/masvJL
uEfk+6nZyT9qFiquPddDzZokuSYPYOxyOPXYwuUTaedmgJ74xSNUhb2t5t0suwgb
q3sLVMMrHap0GNb3DCnb794Bycr5gA==
=gYNf
-----END PGP SIGNATURE-----

--1m3/mpdwsBsKXyRx--

