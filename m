Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03C4F46C44
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:40:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A1B6B0104; Mon,  6 Apr 2026 10:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB006B0105; Mon,  6 Apr 2026 10:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E846B0106; Mon,  6 Apr 2026 10:40:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C63386B0104
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:40:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B3961404AA
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:40:22 +0000 (UTC)
X-FDA: 84628391484.03.F5C5A4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8030840007
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:40:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOoOPAma;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775486420; a=rsa-sha256;
	cv=none;
	b=8Uitt+b2aE+6jirUqVSPh0BAvELR+9HdEtZvhme6yWeFnN2nSzOXYkNTEx+V8WkpnHVsqK
	xV2gawDhyYICn9/63P2i15coLBQoPWwfwXj6MBkUFUeIAme9cCxpV+cZGw86ZoxjW+9dqa
	pQiYnhZ+wsODrr922Hhb6+q98VTO6b8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775486420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HscdZE1jDaO1VYvJpYRdXQ9Wi5iKVDR3QAVSOFgAsBo=;
	b=GOcr9AIvbpF7mupu6aa74IC3S4BA/L09o6NcyWFqj0Y7qKTM5w4SUbYIWZW+PDx+z2cbz3
	g8yOKVkJbYGDgHYnBRH4tCuUQCttGL5jFywjvyKzwj2DffV0Si7HFRvGjT9uMU3Ms1kM0b
	XS130zwjH08r3F12ijTjvAu1HrecJEs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OOoOPAma;
	spf=pass (imf12.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F405C60123;
	Mon,  6 Apr 2026 14:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3768C4CEF7;
	Mon,  6 Apr 2026 14:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775486419;
	bh=HscdZE1jDaO1VYvJpYRdXQ9Wi5iKVDR3QAVSOFgAsBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OOoOPAmaH1Y8DegRrnnfMlzu+H6uGHOagyI2JNc7CoxCD+c9DD0ZB2C6W/3ouIbV6
	 suOx8cQJWFQtD6FMADAyAy4txgJvztbqUwP2hIuFfcfClvMMw8J3QH4WrwGAHpgb1Q
	 cP5XgMjU1dU6/iLu5OU5AQDbCVpHKspw+uTE3YZoDg0P05NHOxSmiIw413uKfsWblx
	 0pARqVMuF8LW1WL4RibikVC5q8i4Hi3qkMn9kGzKbP1QSktqExaw4UtJiDGgbyBN/l
	 0kmIZ0V9IclCQj7+ngUtlHI1VYj2dqU30LhHhrW5jOf35b3Aqbs2T5GuwFdL37Aejq
	 IA5IKGqKdVRpA==
Date: Mon, 6 Apr 2026 15:40:12 +0100
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
Subject: Re: [PATCH 08/53] selftests/mm: hugetlb-vmemmap: use kselftest
 framework
Message-ID: <4bab29d7-7c19-4c82-872e-18b88f07d7c0@sirena.org.uk>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-9-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fpQPRiuMKCXEzmVa"
Content-Disposition: inline
In-Reply-To: <20260406141735.2179309-9-rppt@kernel.org>
X-Cookie: Does not include installation.
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8030840007
X-Stat-Signature: rpt8k8fwumqwsbkqejomyi7kkyp5zuss
X-HE-Tag: 1775486420-933899
X-HE-Meta: U2FsdGVkX1+KD3rLGPATRh7jrqsbxwFqt6PfOgj5V5/RkevTDnL5ycUjcgspQon5pEC8XLGVknjkWfOiBBhvkJn4C9YWDkRpzi8yRR4huEhT/LQ7M7OSLF+aEdrd/p9zMEaY6w4SRwx7vO7cW3Z9XXmQxrjCLt9r6Jjy0bfGvFE+diCDChhJiwQGyJdWjj6plazSBXb51TJF11m32A+QIixoJ7umq0eNyaTgeHBZUEHtW7ekZ7M7o4NeiT1smWoRzgGkkbHe36VwBJjicpnG6+uswan3Dj65typh1fV7a2GMLXATQGt9nlYsYxiQQU/I6QtTN2Bem6lXc+OCLMCCHyMMG/Asouseywbq1BRZl75/lZPxqzr/0bSRlkQc5bKtYE0tF91eMKEG7A/e9xkPpWjyZgEa9DrrrqFwGibkticrs324rqpXn2RQaenilSmbmIpZIw3Z6BAR3gfzYuz31ZBHcDzJLZL+BmUOlYkpLtYOYu8nuh/0ljBHVnUH0DK8lEQ3YZ713L+gb+VbayYRIS0aC/9MhNKFBbhT24nuc8p0Fdb0lWqKhcmF8d/Wp/ipS1sTnxlKQDbswfSLXnZr3nWj0H8Q2MYT8c+oA84jn7GDz2ANA13wH7uYlSwn3LNCHHcIpXjV/DiGpdAPeTW8U9CbtiooL0nnh+1GE9yrDvlmG97lpkfNipml3HPL0I+/90kg3BvdU2vTc3p+BbPnXOBHkJbUzpi+IO1bSnptOwkqkXbCBljxXF17JNeJgufaNoe6JfQzImNVCl2gtLmLs32ZB1wI1u6D19HQ2N2ilgM3J7bjnRuGDPVvID5IfDjjqBe7vl4CR0vdZKo1qYpLhVPLsBfswItNlMUcY7nrh6L4923PWE/JknpmS6XEdz0ieHHoSLMlGiOv+UmmcB9BW5I9z8hJcbaBkW0SfnmU9RoQ94JCtwjT1O2b34yj6yDlNyL5Ry+W67gBGFgvYil
 018kbwWc
 E+xa55rHXl8r2Qno6FtXF25ACUoI2PKlqjMnVOr0DfIvHcwwj5ZgrFkhWWKD3y6LcysIB3eBUt0kG0edNU6eRGbME+mAhPUcDCTCMWo45OLjWoJYt+PnHf4SzrF4w4/Ig8z+HIJs8Tg+VWddtMeXgb0oBsA1EyEMq4G0+BnNRBDVCHS1/G/3urdmL+zqk7EPOKPKUZ1aK4GChaYRHr9uM/19fLUH9vBCfbaJS76OV8yxCqoCJILDDPXmUjSZ1IU6Gk+swgzd0cifwmTrbPgaakaRUWMQEXztoANT/ciWXQS3MBw3YQp4+ADMImCmWtrK+lroS1yyK9PWiRcbBYPZuZEhtLIyMrC10I9SNUTU2VCuYPMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fpQPRiuMKCXEzmVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 06, 2026 at 05:16:50PM +0300, Mike Rapoport wrote:

> Convert hugetlb-vmemmap test to use kselftest framework for reporting
> and tracking successful and failing runs.

Reviewed-by: Mark Brown <broonie@kernel.org>

--fpQPRiuMKCXEzmVa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnTxcwACgkQJNaLcl1U
h9B5CAf/XdUXfquEQHZ5DM2V/kApM++qoDQKaMD7fdZ5l8Xp5RNeZiYWwDSdnV4y
BzN2kujxbiutqc0bxY7+zKjitcMX+CRVtTNtW1XgThNQ+OfohcV6dL/A1ssDQ3Sz
wfdtlbNpr3HuSeVJE6qhhAWcRqYwcbOPByaAx6jCWgFJiw1Na8vcv5HUV2ZjPJaA
u5q4yUUu5v+/5NyctEg1l+PVkX7jrv2X+nPreiUmrUYHHpdNLqd70zX3tMysRo48
hLIJFUlk+70HNYaez6k3ErRUXXcbQhjPplmIgZ79hEYlJDt0p3Xdf+3s7ZWRguZc
KtvvAihTywn7/0j7iXx50d7PalSG3g==
=gqnL
-----END PGP SIGNATURE-----

--fpQPRiuMKCXEzmVa--

