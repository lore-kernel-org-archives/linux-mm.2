Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3958BC5B56C
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 356606B008A; Mon, 10 Aug 2026 10:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307916B008C; Mon, 10 Aug 2026 10:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6226B0095; Mon, 10 Aug 2026 10:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24F76B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:14:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C0578019C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:14:20 +0000 (UTC)
X-FDA: 85085554680.29.6CC20DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D019816000F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:14:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mX+kc7VL;
	spf=pass (imf08.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iehNUi3egKfQHvYDNGbbdbgLVRR5Q5cJOqpp5C8Holw=;
	b=sG4W1sFhTD+OQ+GpMY0nIHSMhv3/Yy7nQtU39JPVTzwUc4i/ggiSxZ8IM5nHoktvzbeS26
	eJKmq46RVvQZYVrV0vXSoFnDt1MltUs4GoaO+lOqEKH2E4kgv0p47FzE9QdzcoQn0E6Ggr
	4St72X2VFZhMvFPnCr5XAlBkWtgBVsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371258;
	b=CMmJz4AhWm5D3cVKSYr/RB0nu2yk1rpcGeXOCHF19viDoP9NkZofdaWyE8dD96lhY3WlZ+
	r0p8US4C81JqMc1MPKm0KB4SutxJbp39W4Bbii3pHw6PLLb4D/pxkW0xytrmkr8D1+03uy
	ba1d1Vx2cO3XW20P6SpQNgryGya2lkY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mX+kc7VL;
	spf=pass (imf08.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A26060120;
	Mon, 10 Aug 2026 14:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8787D1F000E9;
	Mon, 10 Aug 2026 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786371257;
	bh=iehNUi3egKfQHvYDNGbbdbgLVRR5Q5cJOqpp5C8Holw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mX+kc7VLJtEYOvp9eGzSbishYvLpCPkZLR4wXwvjM+wgYETFgrk9xkyfZ1a24vtri
	 65ciAVNY1eJFvAX2bAMV2BZRvoU1yHEY3Y5nwK/h/z/S1K9fmc0HFeLTnzJNwxwnvh
	 MXmQ+Y4/Bgx5CaRyf2mpgo3ANRET883pr2yUAom2B3bjyyNBj49w7EFFmeZL3mS8BP
	 m4IThuwjn0FbSzKS4XQf+8c0tVREC4KvHbtmEs74Xg4d0IuRzNhYY1qCKMiEZe4k3A
	 jB3YgCtck/dVYN0wDiM5ADDw6SKS0cdM8N9+keC869RIEF1LTOnz8KBopzUo7OUunB
	 bdNexLqovZBcQ==
Date: Mon, 10 Aug 2026 16:14:14 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Sowjanya Komatineni <skomatineni@nvidia.com>, Luca Ceresoli <luca.ceresoli@bootlin.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, Russell King <linux@armlinux.org.uk>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>, 
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v4 05/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <annbzvLojXK33Sav@orome>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-5-5510d16af89e@nvidia.com>
 <3b458c02-e836-4b24-a712-57fa8dd59e45@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="i7x3s4iklpcr3dcx"
Content-Disposition: inline
In-Reply-To: <3b458c02-e836-4b24-a712-57fa8dd59e45@kernel.org>
X-Rspamd-Queue-Id: D019816000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: rxfti37kntnn9xxixpu6tquy6grrd3y6
X-HE-Tag: 1786371258-615010
X-HE-Meta: U2FsdGVkX1/ozneOwmr3ma4ojSxppe3eOztrh9Sg97yntChBPHCJcRHfVtZnbHf8ZoVbDiqKrottEjTLyJpiSJ7t/Gitp30KJ0KqNMUB1mwXiimXV57GjC6P1k6L5qpmVF04XzI/SL1y0TWLlOqzYSHmOnllW44rWCTdyd0z2rrtSoGkSUQ0C+SuINwCGjcxVeWdz3UePSEbg2GlIk2DkBjNyNeCq26QqwUB+vZL79y4cxknpRCJ892kivqORZ6Y2NEOBi6TwJBAturBYDUYaHtfj0weMhAmcEiwuoQLW0b852EGtOMiTReA6OCCVG+YmXDTT2shjp18/kR7cJPu9V0kayuQyBJDoO1VGeqjZVS1vLWuKrLgvZzxMljWnP9sIFslVPAcXVTz+4ZhJC8Xlcp4s4H52NBBTG9TLxtwdLiEuTCjbGtsXFDaf/MTUN9OPnGIeziZZwLhAWQ7ZZqmbVE5XKg5FLXLEEjVSMzF4oswpqlu/YSM8b4jc12BoKv6bJ3vOu7Aq2q3iT+Qs9AFJ3awDaXaSYhZRrhLn80Q1NYXCDOYRvRjj6Cjv5nriB0fZ4KW6bxQG/+cYX8H3DAMPjdohJ2Amyl33RyY0qWfBVgtWFBvk9+0HoGScET0X5jbw25fmk/JQi2lDaLQHWwCF4/gpiNzuRA4r5WeMYeCL+Bhhf3efDjuKgai0jJLubCisDBQQsjPildMYV8P1d35fpu6hLHC3X8m+ARVhhJz1UWJ0AJW9kOZoDizBZyvOoRUzcwb0mUvu5rPCEtas9MYBu1GrOt2tBc46FRFJvk7MQztXb50VO5vHFttnv90y5FuNyveb+xFNje8aJ+Z8Fx3Lg67NLdoWGIbVlBh2Lcs8B5SiTZS25MbEJrrfXBRuXgY5qsgxDiLoBSiEUz78paP4IRZHbmh5umg1JO8o53+XDV42EYBal2jg45fKilTVmXzE0DnHP3pt9q+Eqk1qwa
 c36TFcS4
 PvN2o5hIg9EhCUHHnQNO8pxQOiDXGvJCwZh8Yd5V55w2bfiz2DmYsNsmEC/qZH61X4ijwoaLRDXjY9Ommr/mVXPKSdF8K5KT+S+phrdScp7kVdOdQAY/Qmc8NtcGEI0VBxnjjGNznBIQPoXbElnboHan+KqKr5yg2nGXaJzki6d6sOye4P2IhxaPxRyvKrwBpxpWfuCXabSDwHtQpTK90QAZQNwfOHh/mBqSoXggrqFjKRLctK0k208cGhaZruZzXbSUbWoCjEUhJigcIKKsaZelE/8uz8blBWcqPx61IFMOkT9yvHDtxlvfQor1ImmluNApVEy4qOblA6EI+mVI8/DhWx4ZBj9lGaFn+H37l4m3GNsUQ5Pwr/JxcWwFYFZWl1KUCKrDy/jZzD0EqCrIn0brihaXXFPzy0QpaREJ8eDLBjKy6N6F5Uf7YUte1H4zFplD1vvafu5wVQUnc8Ff91RgyggMVxVSF6Etx8b1VdVJlrmU5Ipj0BV54PS1w69p9HAwo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--i7x3s4iklpcr3dcx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v4 05/10] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Fri, Aug 07, 2026 at 06:16:06PM +0200, David Hildenbrand (Arm) wrote:
> On 8/7/26 17:54, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > There is no technical reason why there should be a limited number of CMA
> > regions, so extract some code into helpers and use them to create extra
> > functions (cma_create() and cma_free()) that allow creating and freeing,
> > respectively, CMA regions dynamically at runtime.
> >=20
> > The static array of CMA areas cannot be replaced by dynamically created
> > areas because for many of them, allocation must not fail and some cases
> > may need to initialize them before the slab allocator is even available.
> > To account for this, keep these "early" areas in a separate list and
> > track the dynamic areas in a separate list.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
>=20
> Sorry that I didn't get to reply earlier to
>=20
> 	https://lore.kernel.org/all/anS0nxAwCXGWZRl9@orome/
>=20
> But I am still not convinced why we shouldn't just have a single array th=
at
> grows dynamically.
>=20
> "
> After replying to T.J. I think this static array is actually a nice
> feature in a way. It allows us to more easily make a distinction between
> the regular CMA regions created from reserved-memory regions that
> represent classic carveouts, and the more versatile CMA areas that could
> be used for any purpose.
>=20
> Telling the two types apart could obviously also be solved using some
> kind of flag stored with the CMA area, but at this point I don't really
> see a reason why the two lists would need to be unified.
> "
>=20
> Really, cma_for_each_early_area() + cma_for_each_area() is just nasty.
>=20
> I'd strongly vote to unify unless there is a very good reason to do it
> separately.

Marek had an interesting suggestion to extend CMA with fixed address or
range allocations, in which case we would only need a single CMA area.
If that works and is acceptable, there's not much need any longer for
cma_create()/cma_free().

Thierry

--i7x3s4iklpcr3dcx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmp53LYACgkQ3SOs138+
s6F2pA//agw5g+ad2JaahbYD22vSCRqW3CiqP6DioCJAxsagk9tg5EhZHpBTyXgx
NeLeY+2kE3x6TL2VgqHJ4y8hoBb9s8kMQ/Y1mzKbX42KBaSncC7KOHxHC4oAYZ/Y
GIzavTlTlWZlGrD9qC/3YmmWdG7aHRr/UXALcH8VhYqn65ABqGIkmVmAcFBkZCC6
QAsB0WWbU1GVW7adArp/XjeywXwzYbuDjrhYMccXmfBexX5iA7dqyEBLybPiAhiw
/dN0PzpxaKReMS62gTC8Vl7nRW9mMC5NJpnDfMXzQtz5LBxYQkgUM07SFF4Z1cpH
ndEI0GkQyLkesWA8HJWysBbKHuO053/jjcE1+3JW61POx8TSmHPIW0Y52kE5O7h+
639yzEAlbLtPXsq9zQz6xpstENU5reyLz+IBhH3XC+f0RawuNb2YOnP29ayByUkS
o5Eg0kYjFGZP82xhBRlmveTPfBrTe/Un1wfJjnPMNttHrJaK7n3nlOrI6O7YAFau
Ou3/c15vyAOs1JrqdxCnPk4GOQFfYCwiK9cogcw/k2q6tgoSTjxuZsxqmmzOTAZx
Xj0mKBiV6RR5VCygyH+6tbdoPERl3Y8LHEP/cc642K9ldPi2Xjdqiylwt/4v7hkV
VM2qHuSnW8bwLF8N3ee2tCKpCmsx+rjwPK2tyQgPc8ts1VvqSyI=
=OEKA
-----END PGP SIGNATURE-----

--i7x3s4iklpcr3dcx--

