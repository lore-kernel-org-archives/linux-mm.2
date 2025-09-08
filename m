Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D46CCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C483A8E0021; Mon,  8 Sep 2025 11:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20298E0001; Mon,  8 Sep 2025 11:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36438E0021; Mon,  8 Sep 2025 11:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A57358E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:28:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74B86C019D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:28:42 +0000 (UTC)
X-FDA: 83866465284.27.ED109C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D6B75120003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:28:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PsNHM3XM;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPIEyPKg6yE9CiWVc3UyQrHWiGAGsO4BawT7nG0zg1U=;
	b=XZOw1Jke7TksJJwJfQP1LLwjYnmV/YsEkjvBtz4vI6uzOy2BARNXhXePJjSghflv8HhgJm
	oB3fWS2UcBWFNQ3MSSlxx+MruStZJsQljrkL3yHWq3PmnLggU5NMlFFL60htFm8Aqt+bG7
	zhEpfhj/JwTYxGKBNErrDTf+XIzEUz4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345320; a=rsa-sha256;
	cv=none;
	b=CNdCGANU6BDm3GSXAGOCS+K3eNPrrjuILzzTlrvrFbVRX9LpxeBgREy2I0pOI1vAC4Yz2b
	/anOQMYD9UAidW8rBAqzGW2YCZNNnjSrW4XNi2KXLcIlhx7yJb8dHCV0k5yzYDWGBQw3NF
	QSQ9SNnYEbiy+F6xw1VmeWVeDdnQ5oM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PsNHM3XM;
	spf=pass (imf29.hostedemail.com: domain of broonie@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=broonie@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E59360054;
	Mon,  8 Sep 2025 15:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A6FC4CEF1;
	Mon,  8 Sep 2025 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757345319;
	bh=Do6afPicQEb4NL8JqQTOF9ldvaOz/50hXlHx8t3d/Vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PsNHM3XMtszyc0MR1l+7nz70Pbv2C2OaoFSsE5TqVi1L0TWseb3dm8FxU4bOhGA4x
	 K4Pbr34ZZu4GjLSy0wcBOLtbTfSDZ2sZXwcW4q/GMOmsbSZpLzPh3VE05cQHN1bvx6
	 51Gz7lPPEfDUpWjzsa4c4LUlGmtD5Yh+xRUZwAvoz2gdSvkS4s3poGD4jvdFCM3JbR
	 k937DQwE3qDKhikqJJbGzJuWzvxXLe1oyvTjXmvEVG3yc5Fy+l/qJEMutidM5xegfs
	 8U0ArRBNo11ISeeVjRQuNSccclJrtzFk1VDZN9ty2Mo1sIkDvMoHTI/K2PNGM65fEw
	 HzowuB88dAXMA==
Date: Mon, 8 Sep 2025 16:28:28 +0100
From: Mark Brown <broonie@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <e8428944-e2ef-4785-b0c2-d4896b291cb1@sirena.org.uk>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <f5032553-9ec0-494c-8689-0e3a6a73853c@sirena.org.uk>
 <83d3ef61-abc7-458d-b6ea-20094eeff6cd@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DHpSdvAG938A2yDi"
Content-Disposition: inline
In-Reply-To: <83d3ef61-abc7-458d-b6ea-20094eeff6cd@redhat.com>
X-Cookie: Air is water with holes in it.
X-Stat-Signature: 3y3d9qddqctu694apm1n7d5qu4t4wi3k
X-Rspam-User: 
X-Rspamd-Queue-Id: D6B75120003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757345320-119786
X-HE-Meta: U2FsdGVkX1/pcH7paULJi0fU9DpJ23xEz+//ttcgFEeNwVDPQJM0rnBuUceSlhDgjW6wdz2v3rN2cDFdBM/XHXzw8tUVMtpHAZxSHNVcqcC7/+dcv08EUD9dAo0cDwKMqO0XYeRtwu79ZuS1xR/YEGpc9TkhxOkl+rHuRODFS29RputRzzZ2uHp/MYf8mSny5bP76mlRXJkr8dx4EfgDO6oyhVLCcI6CTWd8QWf+CHnpYmYS/8j5m626GhGVarxH7V41hkNZS8FABqqCl08RRLrVFN1qpdbsXOVnpWUZ44PUZrwEXA2PYNTKUMatKfxQGal06P/RUHGYQF7xxRoD/wQtwQbQMZRvT40QqXwbaGthDhnJSN6sEBxNwvJF50DQreO1pkIyy8fLb7Z6cMMRZoRSGmX/wJTDvx57jUfJeUvfnoqLAzguwzDHQR+PPho2xl1yeU03Je8OQcirq72hSC38I7mqRSY4J13zViBBRjt8+lcT47Zfrv2mfyt12PFcXuvZD9Pq8oz3R7wcVfihsfC2rIApINWm3bVtb4BTyERhesL16FpZJ9zK1XijmQM0YvNH4AxB/+O7kfvx7JTs/XJ9kEN+AQ+byYgSQss5YcwCBxr2OeZOe7A2mfXXXG6kuebv/ADI3vvM47SnnZklJrZjlIx9t0r4r4blwSXr4cE4sUcaYqPqr+7/lPqAUB0YRnUP7Ep0QUlxPkyfU0erJyw2H0BpFhqCdv8Mm6gO/IxMYPZCRD3NB2JvnRRJkdoU4k3M9Et/oqWW3QNqos29+4DCQ0KhDer4Qgobf4uAywFG8yGxNH32gkQlLfPn5AURerNAL+d/wlXmDDudM8wGNH6JURWaHUGfAC3nA8tT1m68Uvi6KjEJkYNT0qRCEELsHlT4hZZU/L9vjKqh9RfCYRXgQ1keY4kZtmSHMe6ULg4sky0nfBgJnEVdtG+nMiULVEu5AZwjIfNJrm4cunk
 X1dC7NYb
 h4qxTG5YVCUYo68YwMbzWyeuAA6tQ24k+xA1RfCpGySfv/O6YzUASVRTPmHTkL8MbyBSLmK4bGjQ00QvfVeruhf7AM2yyCZF/iJSy7NmkqCCfe/sNSP7z8j7hGB9G5PCKbiZTD51NUZovdonA+f5FgzQdUwbKcVKc9xuF3/et1kEiE8vq493L2rPs1bD2zmKzVIX5xbOsXcjHcL6R+yi5reYtf7PnUPgv//xCHn+dzIEewtOZJBqFHGaNw/ucKUb5CvWjbrqvMYq+C5GhyP0i57xhHSsLQTMOr0nQBaU23YuUlr5y+19aXS92PGoM0c34JI6EIt8x4iZc6tvE4x0VcnE4d5nARoZQuFAPR2cj3ouaqkY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--DHpSdvAG938A2yDi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 08, 2025 at 05:22:24PM +0200, David Hildenbrand wrote:
> On 08.09.25 17:16, Mark Brown wrote:

> > I'm seeing failures in kselftest-mm in -next on at least Raspberry Pi 4
> > and Orion O6 which bisect to this patch.  I'm seeing a NULL pointer

> On which -next label are you on? next-20250908 should no longer have that
> commit.

Ah, sorry - it was Friday's -next but I only saw the report this
morning.  Sorry for the noise.

--DHpSdvAG938A2yDi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmi+9hwACgkQJNaLcl1U
h9Dbtgf+Lll52kCjsemPK6UaH7DQkWfZmHDqtHqLwe5SzgAfSeqnhQgasjG5jMSv
Nx5981jPRrpwjz/cI58x/+7VGV4mHF331CfuGkvW9jVYKznATgc/3x877cxjQPYg
I0fxXcE59j2a4VQrjcWqpuF0unCRYckVgvCsxK0iBkltPEMKR6iqf1xBECY8ofae
HYKT9ows31m6zoR1t0ed+9WHQqIH9nlo9gPcNJm6Vw2vMSwDBa5BuQv3MIIyOFq3
9MutZOCRam8c+vwt91HNCNUP85vbnHqG+eZCecu4Y2rVwHaENgW7ayTBrmb1OQ4G
cd9uBVEvCzE0tE1Rm7r+1srw8xc6vg==
=z4uX
-----END PGP SIGNATURE-----

--DHpSdvAG938A2yDi--

