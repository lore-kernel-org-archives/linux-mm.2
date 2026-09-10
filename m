Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4EC6C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 10:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC6596B0092; Thu, 10 Sep 2026 06:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D502B6B0093; Thu, 10 Sep 2026 06:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23706B0095; Thu, 10 Sep 2026 06:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 967616B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:52:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0CCBA04DD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:52:08 +0000 (UTC)
X-FDA: 85197537936.19.0855D4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CA3CC0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:52:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkBWkbqs;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789037527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7tjoMh0VJ0JjF10mqJOPD7b1ih9SO6rgWyfI3+RTmM=;
	b=jQcdbvQLLWexJRMnaWW7XUJwPO63HK+buoM4eoZzICVbTaAlSyieiST0wcbYp72TT4mrUW
	YTlg9KV6GdI5QdPXfBDAShjhLmpowW1sA3UtVH2uVPDBD8m4Tlf2vUhnvp2z5s1d6ysoqd
	scwy4ew672M2Dz6+Puus1BRO18ZFSVo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jkBWkbqs;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789037527;
	b=yhlo9saif9T6HBBZzOb46IuZKGn1pqcm9CifwrztutP6vXz15ResEjEfmFUSMHfFiDIpwx
	VBHgCPnofcT754N0fVwoyFiufZdWk6S6opZbQtLK7CxHlINDCWxSlMzOa/8NxkGhICk0hw
	8mNjqLsvVeDaFZmMCnftovSZubZa4y0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCE87600CB;
	Thu, 10 Sep 2026 10:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB61D1F000FF;
	Thu, 10 Sep 2026 10:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789037526;
	bh=N7tjoMh0VJ0JjF10mqJOPD7b1ih9SO6rgWyfI3+RTmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jkBWkbqsUtrXGjvzs9ejgfK4XpAo0fpqaDkZEwyYUh3nsky2zY+18Vn27mS7241TL
	 MvCu5S/EUOKRuRIWcemqgqVR0X7r6k4w/oYOXZqhYTVtmn5cDR0ZWuVJ+EoGIOf31K
	 si2Vs3AQL0JW0JfVnduAaNtpDg+K6Gjxl/jEwtzpEcPUiZ4rezgSm0nh5PAkQQUFO1
	 GwPIbbmKXcJaxgmpF9ohj/yHw0Jk801NrDXApGybMo/hVriULWRHefHhXwmI/BEyuR
	 x75hp2NlH3/kPyBXNr+tNycCgJ1d5N0BstAe2eFHBEpUaMX8cbJ1kv4UK65a/OEoEn
	 o+nS3JzDYdGyw==
Date: Thu, 10 Sep 2026 12:52:03 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Jonathan Hunter <jonathanh@nvidia.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Sowjanya Komatineni <skomatineni@nvidia.com>, 
	Luca Ceresoli <luca.ceresoli@bootlin.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Russell King <linux@armlinux.org.uk>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>, 
	Mark Rutland <mark.rutland@arm.com>, Saravana Kannan <saravanak@kernel.org>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 06/12] of: Export of_node_to_nid()
Message-ID: <aqKLkeg0iRBqa3bo@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-6-79042cfa8de5@nvidia.com>
 <20260908145929.GB3123582-robh@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pochtu3uujjsdg7m"
Content-Disposition: inline
In-Reply-To: <20260908145929.GB3123582-robh@kernel.org>
X-Rspam-User: 
X-Stat-Signature: nzqrrhcwh1xntz8k8moa8xgwrrqrzajx
X-Rspamd-Queue-Id: 4CA3CC0003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789037527-799484
X-HE-Meta: U2FsdGVkX1+gU87tp/N/nYrfEgvt6sgpfKE/pxgTThlVr1nC3jECT6ao0XoiYfVOeWGXUCt7ZJboUyk7vtJUC35VSH3EILUVjB5fX4gBTmWsFfSHlkLO5Tq6p7hTExovupyRu/mZMY5L1bY19DE9B44+wvhB0lzTdJm7jmX0h70sl7vXTj7wnekFYzRtXuUj+A+cCNGjuyDGAy8G8FcTaEALDwHd8xDt2+a7ha8/y5lT9P3EpAnAv45Vk1UTF+/9FV5P3GLlZ9ILo6kaTdkMu8OQynWjZhHqb1jWzUYe6SBPCqtYU3bEV9jbTrC1mHPpTzjdA3mpzWSQu0GTmdg8DGvDCkwgscYUOx9iOOeZ5zmZ2TINvLEFwa1kIMC7CdhH9RCFH9OcjufPEwpIcyOufrDcLDqQqnVEJ7SuFK9lLVLATiaBT1/YpHu03GlkToa9BQ2pU+OnvnKvQ2m7yROP0/sg/LNMaqQ8b61lfYoIoO0ah9oMlOeAau1GiYvBxiB/JS4wgFhJrhK6M9BM28K0u/bUhGwN449DFZloxoIzP8eWPqWHg4D0h22Lw7s9kG7+sRyah8mvKR6PTvq20VHR8hW56fV4Go3OvT2fF8ah/flRFtFTO8uONaOeJdDPtGS9wjzaTd1po/WLEOG9ZQr6t2mbJLPdz2wagd0RsO8ZfRuvrtQp6DQPzX59TG1NkIk8aSosj8zIhbwjpn4pEat3OOJFbuTqCkTlAeeAQKYuz//gxiAwPpqPs3cPI6c0e0ksH8L30P003P9/nH/HN9mG5dth1t1GNF/NPSg67ty6u0FugUITmZimWYWdt35harH+rMUs2CQFfvHJJxA0WjDsNUodd3fL15/LSRCOLv2x9VpTP1lGL9ZzbgUIdK0ANGUTyP5pi9Hrolxh7DpXbwMlPsQ3DZHYvv+d1gD29nd0BDqxqOr0ZiDYVFd1VHoIMn4iCZpsYshK7F8IT9WqQLM
 lCI8R5IC
 k+COKj+izwuYKg7z4/DbK2NdUE1y/dZngNjQv8UIvWsXNKEBWhlcMSNRMmeiVdurxC5TAUx72c7raAj8kDfDdAFBZcbylvQfTmjL2vWDTegNEzfkeC0ae/3qZsFtM9cwH6oYpu4y79il/GL+J8FozPnbkiAwXSp8YLFImrmrTIRM4JBdTvLK5pu0kciDeve8O/zh/rwbojClcQIf0rWh7OkSv0HMIpJw6pbJ7elrCszmqreOq5ydjXtZFim4XtPhn71KJDybHneHrBq7pHiKTeR+8PGYW5FH/F6H2jIM+QM2VYSncfUFh5COW1NQZeq2rUwo2R1kvEvUSi5zz2SExJPxlsR72LR8GMuJ+3uI4WN43sFaZfI0dBuRvkUXZEFm3dp5m2rDOLIAYvGDePqr2gmY3f63+NgKoOXV9QC3WiaX9dSqxWrMitZy7KtmyB5e/DpA9QNpBWZ1dWaWEAcKn0h+ED34iSZ6L2vcuaXrnJWcrLrcu4FFZQbB0j/D1gUfLAmHDV8CUoDv+Z6K6jibweXUrpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pochtu3uujjsdg7m
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 06/12] of: Export of_node_to_nid()
MIME-Version: 1.0

On Tue, Sep 08, 2026 at 09:59:29AM -0500, Rob Herring wrote:
> On Fri, Sep 04, 2026 at 12:44:57PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > Drivers buildable as a module may want to use this, so export it.
>=20
> We need a specific reason/driver. Otherwise, that's every API function.=
=20
>=20
> It doesn't look to me like the VPR driver ever actually uses the NID.

You're right, we currently don't need this. The plan is to use this to
differentiate between VPR instances on NUMA systems, but we don't have
any such system yet. I'll drop this patch for now.

Thierry

--pochtu3uujjsdg7m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqii9MACgkQ3SOs138+
s6G+LA/7BGayHietSWcjHsnMEamaB/I04lj2qpSvcwlZK/2E94CCzDouik55LAg2
7yFNbMU0VYi2oxec0RMMlAfo/OEN8iG+3X3tcTwQ6Hv7fPxlsffyKDIAb0SxAalQ
3gXrYnaeeUS8oWlfyapzTnArDHz1wkolZluRr9R3cj73ED8jdi0XuHkTjlbGKVko
KaZTIYUo9uB5G1wLUs0TOP3pAfJJa97LpAtMPIdytlgwy8wLXa5ti4A79opsZzIa
5kTsTXx5D9Xg+/kJuuvpr/5lanW+hYPWVbL8w37xwjKV5EoQW5kSdUnXXuZiE5p6
zM5tKM16OssvhPhZkYaYwdR4QwrJz2wpGE1R8NV9W0IMpW4HtsIRJPbTQhQOqn0L
DdKwKKwPYYEAshOJ/vel7xA5/rnfbFAtxOI8CvPpjM6mv0y8AFM8fApzzcfjlJvW
D+mJVr7IHD3+E4MZeA44MUvJpuK9a6tZg80Z0ixPnnbtl7th8/3nrj6vpW2ANmjk
aeh2Rud7YKP1TJThucNGvzzl9zmePpUiapF47cWCkR13ooM8opgzSHkeGBkU4Oaa
HsXVrm8Ie+po6BAMLKsduZrB2KFkFyJ68bMGbHwuwqmVSux9BnT+Mc65Yc7fWEF7
9+pu4BoTZZ32aJXzpyx8RcxV9jADGugXNEA88fHQpAxDbtyg5lc=
=XC4p
-----END PGP SIGNATURE-----

--pochtu3uujjsdg7m--

