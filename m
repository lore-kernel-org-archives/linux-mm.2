Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488B2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4886B0141; Thu,  2 Jul 2026 21:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D796B016E; Thu,  2 Jul 2026 21:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BE96B016F; Thu,  2 Jul 2026 21:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1CC16B0141
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37F521A01D3
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:41:28 +0000 (UTC)
X-FDA: 84944402256.09.712949D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95111C0009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 16:41:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbIxVhIT;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783010486;
	b=kIoO9LzyO9mmqwKo3BaWQn6zx1cdKuvIFGTm3+Siiwhd/7yNw4cvFE0emBv0q6GfR8FOPp
	ZAJt113CMHm9M6GYtmeVp9X1ykliroDCKuKLJDo/YgELEdenK9X0oa2JeXHIuUH1RFUMaV
	bbu9mcXvKMBQw/VW9QhSiG5G6I4P5Gw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783010486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4TcPpM0BZaoJj/LKE0Ry2kWPQZbK+NaW1FTfGXp6Qn4=;
	b=7f/6mHTc/gd123D6bC5QqaOA04P92Ow2X17LwnzZMFwvZ0bWqfKhF509+BgJhfyrwPNgeM
	fS5ymUUHSSeV7i1rOHnFTpYkjy4doF7c4USaT4iUvRai3ZEecu/Gm/+HZbm64YFhut7jKN
	EnI5NHAanT52PgVZaP3RFl7gibX2ELc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UbIxVhIT;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2583060204;
	Thu,  2 Jul 2026 16:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3321D1F00ACF;
	Thu,  2 Jul 2026 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010485;
	bh=4TcPpM0BZaoJj/LKE0Ry2kWPQZbK+NaW1FTfGXp6Qn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UbIxVhIT3k+L2Rvex870aYp4emZYvycrMzgT/l80VxrbTxWvxI9JRKpnaUNMEjG3G
	 ZoVLWczTG/g9HyZAgZ70twW/ylV0EE7XLdG/sgXmKLnHisy8AsEYlfbd5niKzqz1lY
	 ws98cZTWJqeFnp3vSJLG17/qF3Ge/moCJxFQuACsKCwbcRvPFAWF7LSujuvl0ZguAd
	 0Ey5CbVzfmKHTGGtoQsv7zUESob5GM+jQi/nn4i0YwCIBp/b1yxTiqFNMy4jhvtD5D
	 q7w26HLWMKTd+xN5EbSr27iexWuWelP+dlG+S+pGinCthmp6iUYPrtV/RBEn+6x6na
	 +pBQI4mIXDTaw==
Date: Thu, 2 Jul 2026 18:41:23 +0200
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
	Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <akaSJ5D98w2cHqb6@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="a4brqgkdrivfh2ns"
Content-Disposition: inline
In-Reply-To: <akZkuwktaXFTrASP@orome>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95111C0009
X-Stat-Signature: dg5cxin4cxas17w69mae5aphmeuagmzk
X-Rspam-User: 
X-HE-Tag: 1783010486-625866
X-HE-Meta: U2FsdGVkX1+0hb/BrbZnTZq1eFBNHJmgH87KWBYuDJQau4Lj4d5C0LqCidOcBZbJNyJenTZTOfGWnl3GzMiL2cMjFjf+XRAj7g6/8di/FAbgv1ibd7RA3vaQDY2VKzR4PTqyEjTD0sF9aKOGFJIqTbp90XmDS5TuFT6/eIXw8ZISOseyPKEG0Vn/yuxgCKKOGCGcs5BO1tBlj56DYgJgRH4Oj6gyyyvnVBAVHtp09Trv86NCGAEzeUuCBtHl6E5WBVBGtAqYSnwyIxVBQLD1nYScCWUyL6YIiuEUpLUo3QMpmvK8ouVRn87Dhg50ygEoTMbF0kAqfvjecZfgHiLMUkwcIjGKKkh1ARyVh4C8TZoBVgfgJvg50zmTy+O1Mu1yxC3zHBqa9RgVERYjDuMhqnFsLHjT2fN7VuuTYT0IJyaD8Y0nCBQFSgUA2M1S/EvsdoyGHcoXOYPaxAR7/HtyHpsWlNSief36ilxWUZ6cnrG7f1oghyBUh0pqe72WBRZiOdMP2MXnR0Hduy/SZm/wZYaT2LrmkNq/VVygyKyycfjCm1bez0eb365UZ0mf4lBWbKaNu7j+OfaYfja0Z5NkKqTCglvyFsb47ZaBRGocAsqrQa1tmX68XpgoroSHxtcNGus2/BhuRqbJ36kF9tzwx0hbgZWOCVLEjNuxnc3cjJHroVixcyyxahnUDSk0HEjuiZk3xsLNYJt4bYY/Ufvijl/hmQ3NlRtE8POY+AlvPxv8NALoniP3xdJ17j7BQd/6WBMO73HerAbBSqycJnJamMFPw/OmD2JfbejJFQPzP/XnTMbuEr4Z9mo1SWls9YZv4rASgv/n19AmW5e2OMBDhhxCSaE1nt6xUK/F+6TfLeqfEKHDlgUCulscN9OI37aXwfJIhKbrw6pJz5os4bVQTO/kFTy2vkeA4XeqlbCgnqasjpzrigHJBiPxCbJ+3EQYyIA4NHM/NZYdOaI8kT2
 NDYpr65y
 S6siMCqbz+R10xjnAL7b/AdW1sSZyKjfEiUV4Vk0kqwD6qi+roELIYcUon52iED8cDpbqzZBWaakv22jTu97IP/kAL1S3j3mazDXRhe4GJ4AQwx6218dxYy3lbB9DkcCy5zQ/NDDBR9GYB+SYMMMrZyxpWFBw6NmLNAb1M2sUtp7bJ/JGGhJVgZviF6pW/CWICktuw+5ba6pan+4PFYe/BTAKP+Bom7CMXkU8/OqMplrHTuOBGGYz8aFLNBaN98gBvSRsPKWsfQRwhDRAw6a+jvijg2w1HovwWuxrX7o5tWz7gulLgkV2Se0vNGK9AN8uGnuRl+yKkDFDZoPPosmz3NwAD95eP/e455b2F3+pgNd3q2Uu0wH5hyPCGuzCZ82Yuv4GpETS/82+hIf9yoRnZtbW9x56kB60+HtJuC4B5OXOjerFnr/yiY05rR/6+UKPQ5RvA5A5g+6s5HLK2B/9auxZDm8CM/z16MVlUcS9Lx1JeLubK+wIKCnRllUP+WgnpADmAIL8UpWzyF560U6Qjz7MSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--a4brqgkdrivfh2ns
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0

On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > From: Chun Ng <chunn@nvidia.com>
> > >=20
> > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
> > > on a kernel-linear-map range.
> >=20
> > That sounds like a really terrible idea. Why is this necessary and how
> > does it interact with things like load_unaligned_zeropad()?
>=20
> This is necessary because once the memory controller has walled off the
> new memory region the CPU must not access it under any circumstances or
> it'll cause the CPU to lock up (I think technically it'll hit an SError
> but in practice that just means it'll freeze, as far as I can tell).
>=20
> Probably doesn't interact well at all with load_unaligned_zeropad().
>=20
> > I think you should unmap the memory from the linear map and memremap()
> > it instead.
>=20
> Given that the memory can never be accessed by the CPU after the memory
> controller locks it down, I don't think we'll even need memremap(). The
> only thing we really need is the sg_table we hand out via the DMA BUFs
> so that they can be used by device drivers to program their DMA engines
> internally.
>=20
> Looking through some of the architecture code around this, shouldn't we
> simply be using set_memory_encrypted() and set_memory_decrypted() for
> this? While they might've been created for slightly other use-cases,
> they seem to be doing exactly what we want (i.e. remove the page range
> from the linear mapping and flushing it, or restoring the valid bit and
> standard permissions, respectively).

Ah... I guess we can't do it because we're not in a realm world and so
the early checks in __set_memory_enc_dec() would return early and turn
it into a no-op.

How about if I extract a common helper and provide set_memory_p() and
set_memory_np() in terms of those. Those are available on x86 and
PowerPC as well, so fairly standard. I suppose at that point we're
closer to set_memory_valid().

Thierry

--a4brqgkdrivfh2ns
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpGlK8ACgkQ3SOs138+
s6HETA//VE10mlKmDkMPw7oOS2GPLTn9mVHksFDOn28PMBlC2qgyv4CyznGj3Rfw
WHIYoNb0rxntAbxQkh6SV5FCCi76fm/uTR3z2an8FI8W7KwiVfDiaIv3cmlG6TVd
XcCj42QUsUHU7iFHzfSVkW33626MSfyeD+w00yxmT14U2Utl4X/+V+EQF6tRStJZ
eLJUAyxrArCx98MI79QW13QB5MilfaFjtY6IxwXr+0hW2qnXGbNWJ5x1Z5kbC6wD
6yOAfi8QY0nqau5GKgo/+dkYUq1zAc65a7QdRu5KW383NDcLhRbtrwBoA6TYFriL
c2GJiV1ch4N8Dsr694Lmn4jNHUUqPLcPY8it6qMkUNVrc5XjK24C0intns2AFR4i
7ca82YvaTCuql87GjgBkz9NptVtmqVdZxnrtVYAH9mbvfczVpAEEsacYrMwtqBPM
crTqcMLjkLxVZdnsvwT3Je73FolwTnxNsBlTaA24I64kQCW9QUIRy6WltcFdimPM
2K40ULhVg3dNDSaGsQaIvDv8kpgBJiX4sf3kIjK71Dgo9/HKS4IBZx3kfKUxxURj
RD51dxPOiDXPwIzDZxbERJ2rZx4NxSTj2FjLET7Vs6nbKwvC+K/XiLOtEIXbfwdD
w9Hih0fRPiPrhG+uab8J6u+Jsaj9KI/DnuqDrIZL+ciFm4MVaNc=
=9S6h
-----END PGP SIGNATURE-----

--a4brqgkdrivfh2ns--

