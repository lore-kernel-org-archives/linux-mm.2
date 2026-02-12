Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCFECEE3692
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178D76B0005; Thu, 12 Feb 2026 09:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126896B0089; Thu, 12 Feb 2026 09:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033226B008A; Thu, 12 Feb 2026 09:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E49CA6B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:50:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85818139064
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:50:15 +0000 (UTC)
X-FDA: 84436089990.16.D6A857A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BC60F120010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:50:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KeV6KmOo;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKllQeW/JBLJUKCdyBCm9Pj6xN0Nreo3qACceg5TfLs=;
	b=niN5GLgUPAv+oYAz0yG+bV4kddC24BmvhTmiyVES3AoHRB7SGzV6/ui1+JW/Eyq9PdpLIJ
	rllPmW8wgGx2+TApQ14q4QJ70timNPmTBl3HyTT7x+IKcqhcqAuTdbMo7TDVsEEAv4dh+r
	toG2e2lR79mf9gfLDl1GJ3wH+VhjF8U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KeV6KmOo;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907813; a=rsa-sha256;
	cv=none;
	b=wVDQwAxTZWy2U8l12SzFpB78md1d3RRTX9dC0yyP5J7UDwE+Io0q8QqKDzc13ZW2IN7OqY
	HqccK100eYZpkJY2xTp6wH/gckNVBFzKAUpwuJ1DTZKJfpylPSTkup3wVUKN+yt0lVeZAF
	z5J8CjZ22lhneRccYqgTZqE8g4PYySc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A46E40711;
	Thu, 12 Feb 2026 14:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71C9C4CEF7;
	Thu, 12 Feb 2026 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770907812;
	bh=LKllQeW/JBLJUKCdyBCm9Pj6xN0Nreo3qACceg5TfLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KeV6KmOocndM7Aq+b5F2pLDSXw8xke4lYbDn2+JLIU8XS48BPzyKnqpWDnkhapeuh
	 g8Tgl9Dfq1IG1Xii4QQd2prVdpEUyocZrrtqKLWWmvWSHXf4VvESem7Zbp01B+t8nn
	 tQSxqw7lzwaVotdXoO0dZUqpfI686t/pgyGzJQoMUmFnUToX8SSZsEch2mOG9LUczl
	 6C5kpBgWUjJ3fawWnebobcvXR5H+o0ijpF6GwiwyVFC7wdFCdLGxtjycnTBwpWD+WA
	 kBnHzXQ7vd4MPhoB+TsfGxNfsP9qkpIWGMwt/jLUgoQ4iNKBg7a3P/zYhHsR3tNBOB
	 L2CZeLjc0Dz4A==
Date: Thu, 12 Feb 2026 15:50:09 +0100
From: Thierry Reding <thierry.reding@kernel.org>
To: Maxime Ripard <mripard@redhat.com>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <aY3nov29aBGWw93Y@orome>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-7-thierry.reding@kernel.org>
 <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3j2ryzp4gzyowi5k"
Content-Disposition: inline
In-Reply-To: <20260123-meteoric-butterfly-of-imagination-fd691f@houat>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC60F120010
X-Stat-Signature: cr8yzd5mw5zote5q648g6ttnti771sut
X-Rspam-User: 
X-HE-Tag: 1770907813-283492
X-HE-Meta: U2FsdGVkX19XHKmS9EdjDAeuK27KHC6HgFYaK1XsPSuNuWB6cjHBR4SczwCViSARYabAR//gzLJ1uiEGvCbcc+3VWnTEEQeA+ZcS12DFyPZwHiA9sCEpBAuDJ3ukDf4suw2aUNE0nASn+C3UJjWHypuz0tczuowSBhaAYpSYD5NRTVntxxFJoUCI+CTrmVfYXZttLIisEx9BA5gc9UCCVnANuRP/ruMskjwAIxni/BxstqKuHxTUpTJSH5HgAq3U+GGDOC1bNN1Uzvk5kFVaczGf78l/WQAYBJcoNDJ31M65bxku0Znr673F1giAom09wBlAO+4islhzo+VRPx+l4COHue29mdPyI5Ad62u1uL/MryoGOBq5OtL7w4KFi9GB2bmEHHx9MZ/C9USLCkhFWJ+GD73qa4ZLq27Xsmrwd7gUVSBOn1sRFriWm6/V0cttbo/vMB+uqZEy2R44K3DpKoMSxgtBALpu1CmPjSLrtr34T6JS9JECjToiYjPlYasBg+u6O8Etld+SpdjRgfU6tOi6+ybQ/TqD3p8J72ZdsS2Z/cf+9KBFoRSQ+aulbRYRkJeafiQw/S0R80nhFyvswMt5buyfqxIiqUmy4LCcvZdkFWNrN9zR93iwm0btB+rPZ/YzUWUGJwltaB76RGyF3iwWdj6FOgAQ26j9GD534y2c26XddzwLdcn5Mf1Z/JxQadqM+6l3AeUBa7yZw6DfMp2m2yXzXDHj4xpYqtxQCETdOahtz+5qEV8Cu2COKNIpsdIsWOjx0m83V93trgAA3ab+HlwxTlcSTeDfwYcZ59+K+PiFlbv2+ClqUsG/5GmcychNVFbrlgm4nvSV1rXRBXeL9oPRJOFD6tvMhYpl3p8+9qdc0NxlBRpi0/09za8QBXmixXY5DDnDzdfHTNa5/eB2VzudQmGSn7UG2qro+n+eBfBNn5yfu5UivU6tDCGbc4XA3N3oo4ZTOxiYMHK
 4F5OI5I6
 ymibarjweH4LCjDmsd2oBn2rUA+aSG46ImEbd9kaKTNtnfakY0YRqYjGWhHP6ODlAEDtHIfSP7Ltnb+uMtWFpYhGgtuHqLWe31nyAJbvIANbIN8sgzEXBjYG5pn1XV+89ui4pMO5HHGaHXUwKwvCouQs0AFeHYb7XloR0t8UX+zhp9rvh1t2MzpzpoflAxX4PabA5BAPsW1QVblNtF+tiNwzq0o2SSHaobevrZZ+J2FU8YNWHEmv7b4rB8rswglZ1L6zmn+o7f2tHa4LkLAppp+/1rUyvurNnYTXVsjVi9sixgHaTW5H6QgKAucsPcKGyTbh6596yYTiB9GJQyO8FcdHOeAiJH7syAy8m8Cf6wKErx8BKKr1boD2pQum95DM89OFT5geU/jhGuduMNOFBq/6gu6exarGYPW78nnAtsDBlmADLxjB8i5HLjPjqe0V1UOwrDs9XRxmFSrM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3j2ryzp4gzyowi5k
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 06/10] dma-buf: heaps: Add support for Tegra VPR
MIME-Version: 1.0

On Fri, Jan 23, 2026 at 02:30:14PM +0100, Maxime Ripard wrote:
> Hi,
>=20
> On Thu, Jan 22, 2026 at 05:10:05PM +0100, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >=20
> > NVIDIA Tegra SoCs commonly define a Video-Protection-Region, which is a
> > region of memory dedicated to content-protected video decode and
> > playback. This memory cannot be accessed by the CPU and only certain
> > hardware devices have access to it.
> >=20
> > Expose the VPR as a DMA heap so that applications and drivers can
> > allocate buffers from this region for use-cases that require this kind
> > of protected memory.
> >=20
> > VPR has a few very critical peculiarities. First, it must be a single
> > contiguous region of memory (there is a single pair of registers that
> > set the base address and size of the region), which is configured by
> > calling back into the secure monitor. The memory region also needs to
> > quite large for some use-cases because it needs to fit multiple video
> > frames (8K video should be supported), so VPR sizes of ~2 GiB are
> > expected. However, some devices cannot afford to reserve this amount
> > of memory for a particular use-case, and therefore the VPR must be
> > resizable.
> >=20
> > Unfortunately, resizing the VPR is slightly tricky because the GPU found
> > on Tegra SoCs must be in reset during the VPR resize operation. This is
> > currently implemented by freezing all userspace processes and calling
> > invoking the GPU's freeze() implementation, resizing and the thawing the
> > GPU and userspace processes. This is quite heavy-handed, so eventually
> > it might be better to implement thawing/freezing in the GPU driver in
> > such a way that they block accesses to the GPU so that the VPR resize
> > operation can happen without suspending all userspace.
> >=20
> > In order to balance the memory usage versus the amount of resizing that
> > needs to happen, the VPR is divided into multiple chunks. Each chunk is
> > implemented as a CMA area that is completely allocated on first use to
> > guarantee the contiguity of the VPR. Once all buffers from a chunk have
> > been freed, the CMA area is deallocated and the memory returned to the
> > system.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> Aside from the discussion on CMA, it doesn't look like the heap defines
> anywhere the attributes of the allocated buffers this heap provides.

Attributes like what? Where would you expect the driver to define this?
I don't see anything in struct drm_heap_export_info that sounds like
what you expect, nor does the allocation ABI provide any means of
reporting attributes.

There's also not a whole lot to this, other than that the memory
allocated by this can't be accessed by anything other than a select set
of devices. You can't have any CPU access to these buffers (the hardware
will refuse to let the CPU read from this memory) either, which is
hinted at by the fact that no mmap() operations are allowed.

Can you elaborate what you're looking for?

Thierry

--3j2ryzp4gzyowi5k
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmmN6KEACgkQ3SOs138+
s6HM9Q/9EFa2oY/ilPk1Ll4m4WFXDXugzRxO/aNWF0pZafY2suw7rNNqt0ETCckw
e1pkto+gqyZVHuiokQZpAzuwMcywb6dlOoqNR8mzYj82GxKoaUVthJd5THFLYRvX
npidrB5C5MQPG0gJXzmPr1NPUgcMHLuB+9WsKlc80Wd7rfLNL7aq/X1rk3mP+IMr
zfYmnBpYahLeL2hh0dylkHVaFXf+5aFrVZPLaAXVzeGh/pldIQzSlYiQ7YVHcexI
v23kNGYYvMt1r1BT8wTJFKxu6zTGA+scYOIObBLPym5xEm7JwxFg8JmqZxLvyYIO
LqPxGkeTm2XgyO8ucQLfqVGdxiLGXKzzqPUSXxQeJEjFM9ZwH1s0wm5wyDhrq39T
rMbIXFmaiHCqZDntx0oXypuiD1a6US2C8RSwfr7AvfrNDAScA4RW8O/qda72UQRv
tXCWZMWaLKpL6FBy285ciQ6+p9l61JcV8wX1vLilYAvOUNqS4Ca8Pt6VawuDhYbm
oHl6eMx3mwFtx1rTyHUym2CYVuQJPclv09grD6EQG5xRa6bhRIc70sqHC4bJ9AF8
jAH/JWkfAIcqOtOFRZlYvbhdc7AyOqk8tmx7NzD3VbC8n8Peqobu/P/4a5fYaTxA
RmpWqclyn4U6X+m/cr+2SmgJ4AhkPluZQJ8NRyHb0+wDjaBGvMo=
=2ifN
-----END PGP SIGNATURE-----

--3j2ryzp4gzyowi5k--

