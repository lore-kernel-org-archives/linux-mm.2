Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04409FED3F5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:36:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570C16B008C; Fri, 24 Apr 2026 13:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521846B0092; Fri, 24 Apr 2026 13:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410066B0093; Fri, 24 Apr 2026 13:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB276B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:36:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5F508A6B2
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:36:19 +0000 (UTC)
X-FDA: 84694153278.13.1B70358
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2923C180004
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:36:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdqPztEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777052178; a=rsa-sha256;
	cv=none;
	b=hbpTP8//IdI6KesiKw8wDIjGcF0sMgeEQClsdkt1yjk9w3qlL4jB0rLuTAtOUfuZocW8jV
	I6O3SooF9iCs7REtwYJnN1JLoCK+DlZTPq7Wmk7EIgQTYl4+aESYICJqnMGcxPsqYMZYM9
	GGZ4Qjjnn4FGVoxSXQu0AKJ8EQuRptc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdqPztEq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777052178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvFg3Z1+JoqXe8ZQP1MYiJwMHDWxc12tJpLI6syHcZI=;
	b=vtiG4nTAIudgIwOuZxTN44iZF/WJpJwdwNc28r7MUWgNYWfJgBKjuaYvIJJuo4rt8pkZQX
	MI9duKLgXrdFU6hWxp/uFq4F7yM8IrCInv/e3BI8ppM3fiXAnyINencd5nS7xsIDKa80bz
	BFfxmu1tyvWUXTXJdrCt18rRGSQ8cog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 773DA60128;
	Fri, 24 Apr 2026 17:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C63C19425;
	Fri, 24 Apr 2026 17:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777052177;
	bh=CHDOwNRYG2bj/v4igJm1ULxAjW/zxl269FB69HbK180=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HdqPztEq6GgG+lx4rIeXweQ+HFDlgQy45R2pauOCrgB2ju68+qqXeOaw4z0DNTYP+
	 s2+zRDeyp6eFktSfGoIbm4sIrEYdYhcwxjZAbOhuarg7LCeF8hcAiUJjw1X/dphSSP
	 7OnbVkx7eges0WkthglliKS2zqUGoKdUU9kSVF/tgi/s/BBatOYu8oWig71H1Wsm8N
	 iPmYRAIN4tSWKd38BApz2P/AqWf94Q9Sy50lkzFKw1o/kmGNtLLBbTXHYBFwz7GQZU
	 JvTQa3qr3iVAWe3Y8IgSOrnRh/jy7mafFtZOexfhtKlFwEw8+GehGvKyE6A3jz64Qc
	 oFRqlBPFo4oyQ==
Date: Fri, 24 Apr 2026 18:36:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
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
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 06/53] selftests/mm: rename hugepage-* tests to
 hugetlb-*
Message-ID: <30bb8071-06df-4953-b189-ab6a0520739d@sirena.org.uk>
References: <20260418105539.1261536-1-rppt@kernel.org>
 <20260418105539.1261536-7-rppt@kernel.org>
 <4d2fb0ec-91e4-4902-9d7f-68d782ee98c7@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fMCaExAVrSqimxm0"
Content-Disposition: inline
In-Reply-To: <4d2fb0ec-91e4-4902-9d7f-68d782ee98c7@redhat.com>
X-Cookie: 1 bulls, 3 cows.
X-Rspamd-Queue-Id: 2923C180004
X-Rspamd-Server: rspam12
X-Stat-Signature: 6ig8i5dn5o63dwf981ubyr96thmr4sry
X-Rspam-User: 
X-HE-Tag: 1777052177-556293
X-HE-Meta: U2FsdGVkX1+Ra41+XaFfHUTEGOBseQT/8wYha+cbwlj/osVzEPbST35eRfZmjxiIVrB7g+JQ2k9dNy8ojx/CZG4S4zoRwj90PVeTc/zS2H+uP5lVqh59rULmGLQhz0kjgnwHaHAZCm6jmun5MH1lekrepxNsxL8PiUI286tBFwK2AIJHiMb90YpuzhdDXi3VfJVpQ7K7nNHOJIkgMTEb7L8Hz/aYaIsYkOF/ONR2PGt+I/6f9346GN30jrjS7F4ZryIu6V5oQJ1B7C9UVM16VZYlbX7v5sdwPgoZBK0oZbv12uAKTBdI2UiZEfhKs6yS3qavL7nvAI53fQwIbeB2E+Nxd6iPNTQ4wrURXfLiHsjYX0VBzyrOZHvMe3hgbo4OkKbS9PuGoAZbOTvBwD7e+8qTDTbaS4stpeZjAxtQhy05VvMP9MHI7AvI3XWL3QFY94FAOhc+UdLjn+12N6bJ2/9XJjXcknEE1I2bvOlIHNT+Kvb0f2uHurdGLPv7Yj7m9ejFb2kiu/m898tY4ceCXHoGEC/2g3wrsRc68ufQ1EJsfAUb140XWbAuArpF8CXbAIDMx5QK5SE2K4nPQWkIaKI8LOr23XVAO1ADqT4ZoV08qXTKjWeJNs5jJo0thh7hynGCj4W7tCFVmB7n+yxgvQoKJjiJrn+Q+aOAEJ+SRbr1MHxhbu8/yOvVvle4PeKDDJYd2lANpPu/sq1UwhNEW/0Yie9JL6Hoc4sRkXX1IZsPie9hk8nWrgUNXpAKHxbriRM0rcHZWZyLgMIu9bIY+crdm81Isy+5yp+LR3jsdW+mgFfGnjZlB0z1b2Z4NzKIJ2N+Ipg/SRafkJo4wC/rETRa86NIP1OuskbZAKdMgCFxmD3Z9p4cT62kJ7Qy8J+H8q/EfVlq1n27QvHrN5WLzzHrMxKcJeksBqo8pYfiE+CgNt965gJI2GAJi+uCiznogJYFOd3jH7LtcSF07s+
 keL/myW+
 IaS4vQMBQO09u35KbHmHlKdzaOZeaK3c6i1mEnA3i/7JQNy5WPK8Wz6RpyXhmduXCLTnmVqKXuBuM/Tw7lKY/Vj6EhKOJouGk5YB7Jo35kUjLHSTSw6v7Dp3t9shdJiQxN4FjSMyfBpXtnEwRlVx4KrRn/rL2tDj77lfeHNXM/yY9kZNu2YIZAGXm0hpFwk66Q5DeNuVzEWsUnkL0bh6c7d8Ss3bgZbp4IGkZBw54QXRH82+Q102yGLA+zYwtntLPmWklPpR7lXKAIul6uoF7KLJo2QNnLr3nTU09ZRkPvBPCE0P/tVwHj5Vuqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fMCaExAVrSqimxm0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 24, 2026 at 01:20:02PM -0400, Luiz Capitulino wrote:
> On 2026-04-18 06:54, Mike Rapoport wrote:

> > --- a/tools/testing/selftests/mm/.gitignore
> > +++ b/tools/testing/selftests/mm/.gitignore
> > @@ -4,6 +4,10 @@ hugepage-mmap
> >   hugepage-mremap
> >   hugepage-shm
> >   hugepage-vmemmap

> Shouldn't we remove these? Also, there's a reference to hugepage-mmap in
> Documentation/admin-guide/mm/hugetlbpage.rst.

Linus complained at some point about removing things from .gitignore
causing issues with old binaries left around in the working directory.

--fMCaExAVrSqimxm0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnrqggACgkQJNaLcl1U
h9BgyQf9GE7Gxqd6ZWhu6oYwgnH6MS5KcKZDxeEzEVo7XnAa6yCx54tOLV55nHUy
KLvJ74V0fzhAkFZqXXwe3pP+ZwjE8WX8/osZdpYk1Hzw9J7MH47lmL9LnW9MGeNz
SXF4HGRzP9WjlGs9wDmR1xQW2wx2wTCvWBjaSdWHkp0vkty8bkjxiJ8sJcI1JKDV
Mdi9tTjg3bDelR9IJ9V5rcO2KDQ1W/58f0AUnisFmLKOR6tt+F6CI1PZtVewAHQn
LdFHWUgwBFRBFPjqnhDuGBHGyd2jL9lJHAJgMurBBQ5AUdtGW13Pw/5HJth3Xbav
MnwVIHp2xlYA8EGQWL1Z1uPDBD5ykQ==
=hz+5
-----END PGP SIGNATURE-----

--fMCaExAVrSqimxm0--

