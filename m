Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22FCBC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22D56B00CC; Mon,  6 Jul 2026 09:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3D06B00CD; Mon,  6 Jul 2026 09:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2446B00CE; Mon,  6 Jul 2026 09:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3E806B00CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:49:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13ED6120431
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:49:29 +0000 (UTC)
X-FDA: 84958484058.01.6552437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 574CD40009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:49:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0h5ujtI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2XIM2CQ/NysWLV70KA17o1xrRADPboha/A2J5wScPA=;
	b=unJr1DgDtLRBLfkPeBA7ZsuZQAFJcDLbECg441d5qNv9uoyMIByqphubhzs1t1Cl6LV043
	Q13el8lQejqq08eD++uJq7X1+Nx6gFxD4889lw1KP1xlt39mT4RYDcKh0qVzp9C6D+B9AD
	hbFySAf6bhbiBnrA9ABEY+WwQW0Oano=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0h5ujtI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345767;
	b=WqHbTvX1ylCWGOyYQ5G4VdyNvmDrJboVvuftFm+WmROGaYrekZcVQ6IBjxOI7NMnQQr8h3
	dAATPU+6sYWGlbidEryYm8Nf8bVwHrPFoWEgnMNDHeY6szQRTg9hbTtv0Kh8XcDR+bfiqz
	k1Ceuy+Frai2C5EDm68kyMgJ2DsvatE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D6BD8600C3;
	Mon,  6 Jul 2026 13:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D786C1F00A3A;
	Mon,  6 Jul 2026 13:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783345766;
	bh=n2XIM2CQ/NysWLV70KA17o1xrRADPboha/A2J5wScPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i0h5ujtIHJf8JcmNUZYbVaz2XCJNa+558wUqGLmQJ6IUGVggW/DloLPLWuhO1R2J4
	 CIOvWervclMAC+t4YHzYZNeUGQs8n5RQhD5+pX7FGLeY/rM5aE9jpEapugictLRSjy
	 U6beDhWeB8OPkhoDVSPRejb9WdNMKzAExXxlUyKhgS+dMwIADqpoFT/nQ2cCpoW9eC
	 K73pyNMp9AVnJTvgF51xaXwNZ1O5AGEmdncXHGxK1cdbGJD4OTUcEagkrNS0kpfl92
	 eL06YmfDi9opIB9rvfLfMV/X8yRpROG+gLsnpOyp/R1Z2OC3JwzKq8tEhICv5cqzGn
	 dck7DrRmZHnng==
Date: Mon, 6 Jul 2026 15:49:24 +0200
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
Message-ID: <akuvyu1Pq0ZVMZV0@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eye62g5djwewlpln"
Content-Disposition: inline
In-Reply-To: <akftuw9NyRy36fXA@willie-the-truck>
X-Stat-Signature: qcuqeuhhyuyud7bqmz93q3tk9ws6xuse
X-Rspamd-Queue-Id: 574CD40009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783345767-741064
X-HE-Meta: U2FsdGVkX18SmGw4aH42oyCwxtxOsiAUHmmngVS3qkT9a94on7OOj3ezV4f/Gy/Jk9y/QG4SsV3MjGgchPb6vp85m1HgZUyv1946sQ1z6GoBKpEYvlfZfpZFKRtm78cX1NYLK/I4UV3yuLBjVq3kGcfKCGxjl4f5AIimMjHKO03lElQZQ6lachjT7xPqSMu4HTqOgmr89Sh+WocmnCDjQk/Mt4rEAfDAVkqYMkCgf75VTt9vbl1WrkQ8MU+oX4uBPj8t+VObAG5pL6mDg83kI54htl79e1YJEuJ2E27PBMe3SawkSqQ8y09+rj7i1kMZW+bH3VpgSCjnBNpxtRlrIPBbDLhiEUBOxJYMTo8Ewr8dkKuJPPryjCy/PMWFSVwVmFhm7dhqeNAqIGLlS6KcEDrwzrDt449VsbGikW7+s9wwhzhki6t3THOAgGOUEpLB5oWchk5AyFK3+KUHxWlXq/W0U5+hBCW3yX2Rbdopmw4NcqsIt0afbQPRz+I163UoXfJo/VJe60OtszhJUWT8i5QTtrqGMmxHAbeehs8n8+/4IXjGV3aQ5TPdRIltH0hoYyxuXcGmaBfvAtUr+gWJJqmms1tmcv0903fPayPskdT3TAxuHB4yyE0LssWTX+o26sBGS/Zs59HGOaykABu6G3hQgd1p8zzKRxHeHnHhY7UE6/cIQYcGrsDXwXTPjrrPbJ2uvB+uYVk+zC+qn2c31bqrGmz6kC0ZcvO1N55F329rDbChUVC4oQ6lurfaUdWThgl2PnPTsZ9wqE/eA4qfZ8BeSBY/Ig4oiHmEGRKebhRKUsl0nn+25DHia14oK8c2/Y4+FFIJcQo+LRO+tTdDVXUAdNmQGmirjvJXgf2DAz5X2sd2Hknlp74qUYktJcaS718lIGmx6WRZY2EIk1hm6NKEkiRohE2CG0mp7KAL/iLN/sAo0wx95bNbCio9hsMfJm+Odql3gLymCMjgnIe
 nc2GxCqH
 WLEeAilMos5evdx86mY8Zw7PyzgNPWAUaV64Cv+elJB6ymmBkD9JInOeNRicGyOy5jiA1yQm277na9P5bdEapCqdzkkBofr+1FH2irelz0ZiXAYJxlyEBpLHARH2ogMforuMpVTX11aqBxjB9u02KrYgmwfvMXqszYJASG6LZ8nwkedqSQ6EOhU3ZhMCRgq8QAsNiElTBeYjsIfIJihhSytNSFo/6VVYR95l+Qg/i6LtBTbIRycYmMdNASd5bxVwer24LYBfEW4D5AbiZSDVJMuMUuZ2hc/yW2hbXTcr13BFC/T1c6moR+3TK6HORxjUMBUj/kB5AaiFRbbNaAGuxRUmrUXtbgHO5dZWLBc7gq373FyiDjRvVI4+0zVHlVF4RROaoA+o50CeK0OYxkAFIp0lorVgppuKTesft3+szRWO8xhgXFzIDGOtS29trh4eoQUnPrBJIyWWJSoEHUK67NjxNnTlSN7FGAJedxfsHHW8C6qWOs8+P/RJqgXnauc/dtGmi0AEL8Nc8hiFmYUWHq5WZ4V33qw1oPudj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--eye62g5djwewlpln
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0

On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > > From: Chun Ng <chunn@nvidia.com>
> > > > >=20
> > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection=
 bits
> > > > > on a kernel-linear-map range.
> > > >=20
> > > > That sounds like a really terrible idea. Why is this necessary and =
how
> > > > does it interact with things like load_unaligned_zeropad()?
> > >=20
> > > This is necessary because once the memory controller has walled off t=
he
> > > new memory region the CPU must not access it under any circumstances =
or
> > > it'll cause the CPU to lock up (I think technically it'll hit an SErr=
or
> > > but in practice that just means it'll freeze, as far as I can tell).
> > >=20
> > > Probably doesn't interact well at all with load_unaligned_zeropad().
> > >=20
> > > > I think you should unmap the memory from the linear map and memrema=
p()
> > > > it instead.
> > >=20
> > > Given that the memory can never be accessed by the CPU after the memo=
ry
> > > controller locks it down, I don't think we'll even need memremap(). T=
he
> > > only thing we really need is the sg_table we hand out via the DMA BUFs
> > > so that they can be used by device drivers to program their DMA engin=
es
> > > internally.
> > >=20
> > > Looking through some of the architecture code around this, shouldn't =
we
> > > simply be using set_memory_encrypted() and set_memory_decrypted() for
> > > this? While they might've been created for slightly other use-cases,
> > > they seem to be doing exactly what we want (i.e. remove the page range
> > > from the linear mapping and flushing it, or restoring the valid bit a=
nd
> > > standard permissions, respectively).
> >=20
> > Ah... I guess we can't do it because we're not in a realm world and so
> > the early checks in __set_memory_enc_dec() would return early and turn
> > it into a no-op.
> >=20
> > How about if I extract a common helper and provide set_memory_p() and
> > set_memory_np() in terms of those. Those are available on x86 and
> > PowerPC as well, so fairly standard. I suppose at that point we're
> > closer to set_memory_valid().
>=20
> Why not just call set_direct_map_invalid_noflush() +
> flush_tlb_kernel_range() for each page? We already have APIs for this.

Having a "standard" helper with a fixed and documented purposed seemed
like a preferable approach for this particular case. We also may want to
make the driver that uses this buildable as a module, in which case we'd
need to export these rather low-level APIs. And then there's also the
fact that we typically call this on a rather large region of memory
(usually something like 512 MiB), so doing it page-by-page is rather
suboptimal.

> The big challenge I see with any linear map manipulation, however, is
> that it will rely on can_set_direct_map() which likely means you need to
> give up some performance and/or security to make this work. Does memory
> become inaccesible dynamically at runtime? If not, the best bet would
> be to describe it as a carveout in the DT and mark it as "no-map" so
> we avoid mapping it in the first place.

VPR exists in two modes: static and resizable. For static VPR we do
exactly that: describe it as carveout in DT with no-map and deal with it
accordingly in the driver. Resizable VPR is for device that have small
amounts of RAM. Content-protected video playback will in the worst case
consume around 1.8 GiB of RAM, so we want to be able to reuse for other
purposes when VPR is unused on those devices. In that case, the memory
is also described as a reserved-memory region in DT, but it is marked as
reusable so that it can be managed by CMA.

The resize operation is fairly slow to begin with because we need to
stall the GPU and put it into reset before the operation, then take it
out of reset and resume it afterwards.

What kind of performance impact do you expect?

Thierry

--eye62g5djwewlpln
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpLsl8ACgkQ3SOs138+
s6HxxA//d5TQAy9G9NF/ZbA14NpOegwi6/NUjnNgWvezWXjMqGI55A0c3bbPyVKd
tYgSNk/b86yED38u0/P4s6EilDp/WwgoM1xy7ibzv5tNhejc/YT343EeL6HiJWj1
qcNFmynHfWiDPj5sp0ZomDHIcYv6BB+Xvq2/xZqHiuID7m8rOKp9YSzvi+HJYvIf
gguy2ZdLlDr9S1NbQ+grzLpoFNE2QIhZn7Hch0JUwecNP7Yta44xzRKNhlFW+2m7
ZtOzsDQ7QKHbGy3tJ+e63Zn5NjOkbRZW5xYH2rkDFt5+RqxESCS3NMXuiQ3RoCIU
qRj7uZvZSTblbK4YNNf2ptTeEA8U0FBtJlTVZeaLp0QeIGVdgGbzC/hEySihrUCK
R7KUsnlh8WXP0vCIj892V+PJnT8EgOq8lzk2nq8Ymp6VxXwehgJeMd6z5pea5zS7
cZNrRSyCJFzPjmFKM5DOqo9brqwud8tYMRhaTWiNvPfvNqZtzP//TEA9OE+4Yizm
2Ol5NP4Y7puaiFApHu958LfbnVGus2qdGkbvu/w4f2nQxIbspoGfIOwOh1MQl0Vj
JOkcl65qwJhLAndx1wepYqOCa8NtBlSaeTagY/xxZ6/OePEgaPCKeMltWVNRFTb9
tuWdL+sDbBfd9LRNtKNu5v/4KPGqF7swq76dY5tmpLSfQ6qAWKc=
=gHEV
-----END PGP SIGNATURE-----

--eye62g5djwewlpln--

