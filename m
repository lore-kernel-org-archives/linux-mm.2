Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7123C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 507A56B0093; Tue,  8 Sep 2026 04:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6686B0095; Tue,  8 Sep 2026 04:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E9D6B0096; Tue,  8 Sep 2026 04:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 14E3E6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:39:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F75DC047E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:39:22 +0000 (UTC)
X-FDA: 85189945764.08.DE2D8E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DFD918000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:39:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f31djqHM;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788856761;
	b=KaOyIBHr+cvzBpWnPkni2HCoDDtDTxbQm6eULpaFa7MMfRxzLm0yuX4ODnTuVELyp5Sv4h
	TtzV2almcfvYYmmMnL4sCFrYvHEDLgp+5gXIVDuWYiv3LVrD7nBjf2B8CKhlkVfI2+cH3f
	viS5E5wfh/05bfLbgj5qiwwtJQTI03A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f31djqHM;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slUWdnwq0XGj7f4s3OzgJoorkVnZmUKvVcYJXpe/QEA=;
	b=ewqHbai/qUXml/q8lOHgdLyya4chhNEN6Hc9LFV1abHT8IbZRDjpaH4owclqaRYZM+xEUM
	e8KQhpz1e1xFUvrhV1A1bsfAYy9JgCEoMLuXD1q5SJZIF2wmcGBQzSFpekdRaxkD+mVWzP
	hykKeHqhQZ+deLTH4VoVRuqXR503q/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AC1A60A93;
	Tue,  8 Sep 2026 08:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C23A1F00A3A;
	Tue,  8 Sep 2026 08:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788856760;
	bh=slUWdnwq0XGj7f4s3OzgJoorkVnZmUKvVcYJXpe/QEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f31djqHMq1zm0NH10E6jABNFN/XEtBtVUywkW/jJEx2y3vkNmMXh/1kd/Sjj72P04
	 T6L92RsSr9CQrX66jc0wrPwHh6ZjVD5aSMaTpkb+Cxjgp9ZU6YrbkkYXhDrOYryDaO
	 ZTgU5gp6BdSkoU54QhSCWPpRXJjEqeQ7gFPhqonFR9QaQp7K9wC3t0y6YPinAZxwQV
	 h+w9nS9hTC4LwZO/38s9ryPJzCgNR+G1JO/Mul0cHse249ia1+soSZnoBYdeQ4kY0m
	 HeH3O938M7uXInW4K+dnzPNL73PzwIIfEEPV3T8JCftA19ij/TKmEUEYsg1ScglZFI
	 YJglKg/Ofvcpw==
Date: Tue, 8 Sep 2026 10:39:17 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Will Deacon <will@kernel.org>
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
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
	Saravana Kannan <saravanak@kernel.org>, Thierry Reding <thierry.reding@gmail.com>, 
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, vdonnefort@google.com
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <ap_HzwVp-6aOKEbJ@orome>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <apquUWgrD9C2jWQ0@willie-the-truck>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a5apqptzjdcu2eq7"
Content-Disposition: inline
In-Reply-To: <apquUWgrD9C2jWQ0@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DFD918000A
X-Stat-Signature: 8athknysus3d8y5hkiyx9mxbtkrnykct
X-HE-Tag: 1788856760-357777
X-HE-Meta: U2FsdGVkX1+FNWBO4jpfQk8LrKmqRQd30i0xGbWX4INEh5AB6GRE3rCnb39EchZsygmzAgwFLcoq7bkpS4Gq19h1qv6pnUUXqyNR2/9GLFZhfVFayLIkvZ8R6mpqr3cgKEEGYg7uAvbllEmMmRVJ1EB/O9yDZptwLEynrcL8zRIR7QpxWnSGiEWrwodAYO+tp33kLtcue/4JdohudJ81aWU3R196jeBCcrS8J4uIw9PudDjL+goRe/qZjkGOHubKJAYKkzbHET9WEYa9QP2tJVLMgjWuDUr+9W8Pz/BYf4WfuHHSNiQjaSVoklxOtaKxQCF/uORQ89BonFGQMheVpEq4WhGb0BMfU+zts78x/tD3D8vRGYAI+jPa3GMOQZovfl6KEkbgdAfo0/ayVSW53fLilLJcrJrzdUiPi10J1zTMbNu2SqAvZNHpjiGMoTFavUsRtPMHoNpvceDw6PZItug9hvtbkUUA/54ZFjvTsB1stgX1igjbB76dY5mm0u5EotQaqhfsr8aMDjyzJYQzralZGKFBqC9wamnwewBZ/4WuQwuCJB2eyYPDv436pACPchX1N4m+3sGQPQ2zsrLlMkgZJFDlDV+xMGAUrw6c0ToIWuzdKG1VRXoBF9yjdSb6OURCtYqi+0tSQQYKw7AjfQDl6ONUAoqLizv19TBQOqTqOAoNmsjKjoM+zPlLmS38VV1Kxp6UQCMDTCCcCMrU2dLiH+Ml5rBfJUH/SSUDb2+a85Pq5ZknWHGkRHkajtH3ZyUD/m8W2BdqSmQWZF9uNlesX2TDKA6nwo9P3hjNqb9ZufpsN7oKKsl7LsyV1cCBwh80zK3OZBbZ1paz9IWKvaiiV0A3bQjtPcjetsr5IGXpmkorGuSeOil0VtWO9ki8JPwpI9pbxUmQGyMdapjqVB9AivxU0h3BXKNAhEsgX45L6hNW0VFLFP0Dh/EHvT8+Yvs805LbyFZJi+cjfnx
 mcyrjvnO
 D7MO6esYmLYq56wU+dKHBT9ODTtfOMINq04kqIrExryz1Lkm4GgTRvBnN2Z+ssjcG5J+Vbg89mlL7DRF5SwHrUO4LUAQNwXeaaH483nR+Q0ir5h8dln/DrudN4KIBXjNa3FK0mJaSvgaE7S4BPME8p/xFBXInAZvoRc3La6AqAJfTCHU7/KouM0lyqqS5kSDnbQlnVzPxOSDoDajpzG3qbzjmnFLgW9BjulPrqnlucJyTQssA9F1Ziq0Qw6HmPTyPQ/zE50Y/N6/CiA3qxv7vySGcXVaSOWVxeD5rnBZKeuNWgbDqZPG37bcLxpjm6635FKgY/JxlrSnLsj32+eWCjruSJ4Y8L2jP6PLyDOBszslWbM+rP1PpU140rzDw53YjZG73l/ab/RRG0BPEjQp2DCidzE6rXdTGKIUj9ZuwgaZ7LNstPnHoi/uIXSlSE+/NR5susvBENfFv73Ryelg6N6dkbtzl7mz0SC+LQWAJl/83Yp5uYQp1fHxE63IIpsCR3rjv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--a5apqptzjdcu2eq7
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Fri, Sep 04, 2026 at 12:41:05PM +0100, Will Deacon wrote:
> Hi Thierry,
>=20
> On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> > This series adds support for the video protection region (VPR) used on
> > Tegra SoC devices. It's a special region of memory that is protected
> > from accesses by the CPU and used to store DRM protected content (both
> > decrypted stream data as well as decoded video frames).
> >=20
> > Patches 1 through 3 add DT binding documentation for the VPR and add the
> > VPR to the list of memory-region items for display, host1x and NVDEC.
> >=20
> > The set_direct_map_*_noflush() functions that will be used later in this
> > series are exported in patch 4 so that the drivers that use them can be
> > built as a module.
> >=20
> > Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
> > but works on sizes that are not a power of two.
> >=20
> > The of_node_to_nid() function is exported in patch 6 because it is used
> > in a later patch adding a driver that can be built as a module.
> >=20
> > Patch 7 introduces new APIs needed by the Tegra VPR implementation that
> > allow memory to be allocated at a fixed offset within a CMA area. Tegra
> > VPR needs this in order to implement its own allocator on top of CMA to
> > meet the strict hardware requirements. This replaces the dynamic CMA
> > area creation patch from earlier versions.
>=20
> Did you get a chance to see how this could work with Vincent's series:
>=20
> https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.com
>=20
> ? I think that should remove your reliance on can_set_direct_map() and
> mean that you can retain block mappings for most of the linear mapping.

I'm not sure if it would help all that much. Yes, if we mark the VPR
region as LLMAP (or PTE_MAP, whichever it ends up being), it should make
the checks for can_set_direct_map() redundant. However, from what I can
tell, Vincent's series still forces page-granularity on these regions,
so it won't retain block mappings at all for them.

The block mappings can be retained for the non-VPR memory, so that's
nice. It also reduces the amount of external prerequisites, but I had
kind of hoped that we could go one step further and keep block mappings
even for the VPR memory if the region happened to be a multiple of the
block size.

The recent addition of page count to the set_direct_map_*() functions
helps reduce the amount of checks that need to be run, so maybe there's
not too much to be gained from removing whole block mappings at once
=66rom the linear map.

Thierry

--a5apqptzjdcu2eq7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqfybIACgkQ3SOs138+
s6HeMBAAuLF8s85+tHae/nBOh6j4pUVcjE5KyexYHpAnHyj8HIuDuERbHercMMPe
CyLnvqYhkNgu1LmEjo9O0OVzGEe65BJoHkdgmXMTyFLQ/9NGtdvaaTCabe99iBCm
1BGL8d0KtegUlzTJLntnV+ubRKhLjZthpMxxjuThV2TJaFTQXtS4kcaldKUTw73o
k9bbvnuX2PsQCVZTL+aAKsRtvXHT011GzCwlfufuRnkX1kJ7vXidndwdsMOFoIJm
lThSDnPii6F/bJc74o9ztJlObQ8gjs/6hzMjrFu9FVFoMa0sucCfM6d+q6wOw/QF
nS7Gtk7mV9RgQ2PkT6o+Umw0l1Nnwd5R5XGKo+vuVb8hCy6hmTe1jPkIy0PyFyan
k54nErXH09l91YA06FpSI4HmeoCYUk4cUU/hKlKYVbE+7DrP7GLNBgEl//Xm5zfB
do1TCokmrQMoFu3UniXLhSmKJMZOuvW23cj5FVP81q3t3cJxvONGp7hvXMyAz5Yy
tx3HYQn+1z1GuPrmlI/PQ7bCz2ZHhepUHPcP6fx3qQoEcECZr23Ud1xVA1xrxNKS
AfvLgsWqAZnG0bTq0hOp2xW38FlPOEB/Gn0A3ux9viOHbMyVuOHqET3wahXk3XgN
OkCpZ+OS8PyANuhW2WySDdpC1HnKIgfn0ghFX2BlmOZ86qZ1LTg=
=5HqX
-----END PGP SIGNATURE-----

--a5apqptzjdcu2eq7--

