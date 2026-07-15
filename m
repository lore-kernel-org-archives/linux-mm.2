Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B5FC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C52D6B0099; Wed, 15 Jul 2026 12:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6752F6B009B; Wed, 15 Jul 2026 12:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D4B6B009D; Wed, 15 Jul 2026 12:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA786B0099
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:01:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A71961C015D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:01:37 +0000 (UTC)
X-FDA: 84991476234.04.B871128
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 57831C0027
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:01:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh+VI423;
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784131295;
	b=3fOv1nssqwvJhTz++MVzNo0nTnAlH8XkWE0zBXL5wfVwtHlR+1/e5tiSA5zhUNZbc9nFzb
	bp7dMXbvxz5QgiWcNB2W/E/bKvD7KJLnNxu/F59jN6JvrRQ/jvq/KrWooaPYykxz/d3sLC
	zq1+uKsm/NLS5+HpiJaploijaAIt5kc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jh+VI423;
	spf=pass (imf22.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xwAMLt7rpcE8P63yyzqTVOXxB1AEal3a0nfL4+SyquM=;
	b=FgmQDcXKXFByfAD5Fq1O2vz/tMJGjKqQwNsCZ0F4TAjSGGPQVEwpaymX/xZ6QmJbtBuWCs
	AbG4Lh07u3wGkGrTfuj+xB2i6f4YOD9kc5HKX0haIR6iXAmf/GmVl1lc/mAvS5oc1sWnIT
	r9VdKfuW5TDweXqjwozUxHaAU2uTZ9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DD2942AC2;
	Wed, 15 Jul 2026 16:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6F11F000E9;
	Wed, 15 Jul 2026 16:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784131294;
	bh=xwAMLt7rpcE8P63yyzqTVOXxB1AEal3a0nfL4+SyquM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jh+VI423rvA4pEB662vSG9nIdPacb3Hf4rr+qxFjQlFT2516JBKgnOQrQOb3QVvXb
	 ev2S5PMWLjQVETNU6ShzBjGduyOwtIokDYSYfY/6kvAxhyGuFyNwMZQdafK1argN6E
	 pU5azVYJ3QAVTUMUyakUa+abCdngPasAiLzco9AoNouJykJ8c/RJvW9GzGIe02Vzwa
	 hsUl54ctY/2tHS9kX9NTvUA5G82kBc0EbGH6wC17zifB2gfx9q/vXgh2zm5ICUGi+v
	 UPbrHHg5ciLkRC5pQ2KC9SK+xkZtNNBC6J6Hm6pTzs/VVQ/rcKICPZVcgzXg5qsPeA
	 M8JKoPlwQm5IQ==
Date: Wed, 15 Jul 2026 18:01:31 +0200
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
Message-ID: <alesre0ZfNV7vgco@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
 <akzikTrmhMsvkNVY@willie-the-truck>
 <ak_8Po3NxgAU7k0T@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nbqkpw722zqmsvzm"
Content-Disposition: inline
In-Reply-To: <ak_8Po3NxgAU7k0T@orome>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57831C0027
X-Stat-Signature: gcxixdh4j87cp9s4xe9bwg5r1zs9f95p
X-HE-Tag: 1784131295-476428
X-HE-Meta: U2FsdGVkX1/ff8d4EQSiMlixR0Vkz7aED8WEy2gvIPKpoPxIzTVMjT7j0U62dLGXrioj9di5VxJua7iy0OhUMqpUUhucrGj6AuMdb/9kcTIhXX9PK57OCl/LVsjK5iO+gDQAReQLudy2JNZ1elLBgEvEUcJ7ArCPI2wN2Z1Spp8nytdAzdcZuSjND5H7VqdzwsNyS1QQDQcuqL7GA/0Ee0O5LWJR0au979UrqREUcMVrWoaBNI7W5MSQE9uQLNSzPiwiGjo/5pcbWAccvg9ux6a/Oj9DRjw3Yt+GWJT8Nm6RFbJEr+sHRhFCX0bm0A84NSLk3BkU9MbKoozzkZ8cCYQl84gcP61bfnWVUiN2di3p8q5i/EatBHRy57Kq0cK3rb5XWU5TZe4nekkaljzZNbzr4rnIh2Tj7O4eKKYurEHIa1CbA0OXPgPmmTwJdVmZ9PYDKpXvvNY4DjVEGShvtckuJ8XNwSVtxQENYUOwVbvjlQ6hRsVBqdEWVklItdoq2CLaIeL+6Y57AKMzQ4rnoFL8hh2k0IvSkeHTSXE2Aq05yZpjxv5VO+nrJ/9bIMAYKxLbmg/G+nVoYmp+lbZPlH3NXybgeEM7S0WbM2XHXtARTV7wziqDsBihVZbYoIe8SkWjI0ueeBt04cVIFPm41/bZw9Yr2s3AhAb+Oy9qwuBn2573fKzYQ6j/MSXkbbeCAMVfR8DH1kXSN2LHduev6Tw2b3HF2d94AcLvlavoraPJpUOI9GPE7/QdtvgcoVm2E8/U2PXzJKuz8Fn3Zti3+pV3VtPqyyHk82jGev+yQ5OHbRprFBmf3rgub0jqsVDsL/W1J/1V8HMUvgC5zoNK5QGwF55MM2jf/rvhW/fj16plDmV3LLeiP/LT8V2osi/OM0oPhZSP7ueHJKWFadTmJeCY0jQRoOL5m3uKh7KjMTxtKqLO+iYXDCkj/qVPNowJxYEuLCGQNnhJPK3VgIA
 vmfF7oOg
 rx7e1JXrEnrVUQZbkuz379DmL7WmV3EgNlNhPaVuDD82LcFA3MAGIV8M4NYSe0xSEEG5pHsMFEtIoS8sliJEU+T3Zvu7VKFxy4InOi5TCG6ZRWs+hr96BnWHYcmxOvaKWQbqkRn/7fd2noEVO2+OTZP/cb4ADoVDwxB99SjzdI0V5jU6+QZqz5DdKv/D+Q+AjHBRsGpNaI2hRVoQGwlM9ZzsEE2m6IMV4jVCU/9IsDcxFsvDWGv2jEbcF6SlmCx7dIqdCdZ9ENezTZNr4NQNTv6DT/sk4UkTGigfaYb7DYH0RKz2/MK9jBOEk9QaxpPLI8iIXTKKfCApf7HQUDifjbcoRrKwQn5Bt+6OA6GActYdDMfXppc243CZVha31HoFFW4/QQzLTAvGIP0O7eA0PvsvvuT5G/KwfRXYtl9Sl4C3s9HkcmdvCAuh5MPAbAnAAL5lZrADZfDXLs4l2mdYsIlEmALy1R07Vpk4UCnVgr5YaZEMfnn7ndj/ykqPZ5mHoJcQ+o6K8ibihVF+2H/j+J004kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nbqkpw722zqmsvzm
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0

On Thu, Jul 09, 2026 at 09:58:01PM +0200, Thierry Reding wrote:
> On Tue, Jul 07, 2026 at 12:27:13PM +0100, Will Deacon wrote:
> > On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
> > > On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> > > > On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > > > > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > > > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrot=
e:
> > > > > > > > From: Chun Ng <chunn@nvidia.com>
> > > > > > > >=20
> > > > > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE prot=
ection bits
> > > > > > > > on a kernel-linear-map range.
> > > > > > >=20
> > > > > > > That sounds like a really terrible idea. Why is this necessar=
y and how
> > > > > > > does it interact with things like load_unaligned_zeropad()?
> > > > > >=20
> > > > > > This is necessary because once the memory controller has walled=
 off the
> > > > > > new memory region the CPU must not access it under any circumst=
ances or
> > > > > > it'll cause the CPU to lock up (I think technically it'll hit a=
n SError
> > > > > > but in practice that just means it'll freeze, as far as I can t=
ell).
> > > > > >=20
> > > > > > Probably doesn't interact well at all with load_unaligned_zerop=
ad().
> > > > > >=20
> > > > > > > I think you should unmap the memory from the linear map and m=
emremap()
> > > > > > > it instead.
> > > > > >=20
> > > > > > Given that the memory can never be accessed by the CPU after th=
e memory
> > > > > > controller locks it down, I don't think we'll even need memrema=
p(). The
> > > > > > only thing we really need is the sg_table we hand out via the D=
MA BUFs
> > > > > > so that they can be used by device drivers to program their DMA=
 engines
> > > > > > internally.
> > > > > >=20
> > > > > > Looking through some of the architecture code around this, shou=
ldn't we
> > > > > > simply be using set_memory_encrypted() and set_memory_decrypted=
() for
> > > > > > this? While they might've been created for slightly other use-c=
ases,
> > > > > > they seem to be doing exactly what we want (i.e. remove the pag=
e range
> > > > > > from the linear mapping and flushing it, or restoring the valid=
 bit and
> > > > > > standard permissions, respectively).
> > > > >=20
> > > > > Ah... I guess we can't do it because we're not in a realm world a=
nd so
> > > > > the early checks in __set_memory_enc_dec() would return early and=
 turn
> > > > > it into a no-op.
> > > > >=20
> > > > > How about if I extract a common helper and provide set_memory_p()=
 and
> > > > > set_memory_np() in terms of those. Those are available on x86 and
> > > > > PowerPC as well, so fairly standard. I suppose at that point we're
> > > > > closer to set_memory_valid().
> > > >=20
> > > > Why not just call set_direct_map_invalid_noflush() +
> > > > flush_tlb_kernel_range() for each page? We already have APIs for th=
is.
> > >=20
> > > Having a "standard" helper with a fixed and documented purposed seemed
> > > like a preferable approach for this particular case. We also may want=
 to
> > > make the driver that uses this buildable as a module, in which case w=
e'd
> > > need to export these rather low-level APIs. And then there's also the
> > > fact that we typically call this on a rather large region of memory
> > > (usually something like 512 MiB), so doing it page-by-page is rather
> > > suboptimal.
> > >=20
> > > > The big challenge I see with any linear map manipulation, however, =
is
> > > > that it will rely on can_set_direct_map() which likely means you ne=
ed to
> > > > give up some performance and/or security to make this work. Does me=
mory
> > > > become inaccesible dynamically at runtime? If not, the best bet wou=
ld
> > > > be to describe it as a carveout in the DT and mark it as "no-map" so
> > > > we avoid mapping it in the first place.
> > >=20
> > > VPR exists in two modes: static and resizable. For static VPR we do
> > > exactly that: describe it as carveout in DT with no-map and deal with=
 it
> > > accordingly in the driver. Resizable VPR is for device that have small
> > > amounts of RAM. Content-protected video playback will in the worst ca=
se
> > > consume around 1.8 GiB of RAM, so we want to be able to reuse for oth=
er
> > > purposes when VPR is unused on those devices. In that case, the memory
> > > is also described as a reserved-memory region in DT, but it is marked=
 as
> > > reusable so that it can be managed by CMA.
> > >=20
> > > The resize operation is fairly slow to begin with because we need to
> > > stall the GPU and put it into reset before the operation, then take it
> > > out of reset and resume it afterwards.
> > >=20
> > > What kind of performance impact do you expect?
> >=20
> > You'll need to measure it, but we've seen reports of double-digit
> > percentage regressions in performance and power. As I said, the problem
> > is that you need to split the linear map to 4k page at runtime to unmap
> > the dynamic carveout, but that isn't something that can be done on most
> > CPUs. Therefore you end up having to use page-granular mappings for the
> > entire thing, similarly to how 'rodata_full' drives can_set_direct_map()
> > and the perf/power hit affects everything.
>=20
> The VPR has fairly large alignment restrictions (1 MiB) and we do unmap
> in fairly large chunks (512 MiB currently, but we can change that if it
> is helpful) because we really want to avoid resizing operations, so the
> tradeoff is between frequency of resize vs. potential memory wasted.
>=20
> Does that change anything with regards to performance?

Turns out that the system we need this for is very likely going to end
up using 4 KiB pages anyway because it doesn't have a whole lot of RAM
(which is the whole reason we want the VPR to be resizable in the first
place). So it sounds like set_direct_map_*() is a good way forward.

Still, wouldn't it potentially be much faster to unmap entire 2 MiB
blocks at a time if we know the driver guarantees the alignment? Maybe
the changes to add num_pages as an argument to set_direct_map_*() that
Mike mentioned would already be an improvement because it avoids those
gratuitous calls to can_set_direct_map().

Thierry

--nbqkpw722zqmsvzm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpXrtgACgkQ3SOs138+
s6GDnRAAnq3U1zVlgJ4c+zt8KmTjZpRAfBuPML2LU9g5YIqK3pDsrt+qXaG6SRGG
svsBD63S7cpqMvuQsnlWdZ7jiTXeY72XEv12xXNALGKWXwlUkodB4zvNDPgwqmki
hh+Fg4/TmFGkLNEI1ot2FgQFbS61E+T4RPZtN+3pJID5m8vdpBIj++eDDvSoYPS4
ctd+RBvk9cSTXkEFLQ6QGJ0v91ZO82pEtkXwqpAtzO01vkSaTehQIxIaBa+T3pvj
eRM3YV5qc8L0MnKg2Exd+Q1IcnDCpYyJsnWp7UVlgxVTXm2kSDqxnd7Q+cRsgBN3
CqF7Q2DpeCMb+FCwtXICttjt2uGn10K6359IFPZUQ+tgC3Dlur+TUBKSdhEqVu78
mgq83v6eU4Z2NhAsM9j3FeOe7vm8ccCWNZsOr3+jxD8zS+xnuKojA37A4ZSykw0x
KWhCpLnOUt/SF7BoanBSvPz0kGR2M0M57haMXp7bbwwYOVdtE8y6LDfHHmZy8NgX
h06Kiu7I9kB4yAw1uzVlKQOI5fF+5AQJlg7OYGijHG3XCC4kW4WV9XI3Eiq04vYr
imNiSb1018jeBaGTtLCPtgGEYNcwO4N/6IQBCDhAAs9sqY//cKD0WArBqb+dgIDo
wQnLmnG3Y4YfZt3XuuKCr+/aTbO/rKspuVXslgkCOS81J4nhNdQ=
=/smH
-----END PGP SIGNATURE-----

--nbqkpw722zqmsvzm--

