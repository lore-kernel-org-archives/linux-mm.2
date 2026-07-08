Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D24C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 12:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7BE6B0005; Wed,  8 Jul 2026 08:50:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169686B0088; Wed,  8 Jul 2026 08:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031456B008A; Wed,  8 Jul 2026 08:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CA0F06B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:50:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48330120136
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:50:10 +0000 (UTC)
X-FDA: 84965592180.21.571A50A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A62A61A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:50:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jitZrOHB;
	spf=pass (imf19.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783515008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbwF4pMHfyhwOslYT5YnzmrvzgTa5uH5GBgU1nK9uiI=;
	b=2nqKrFoyYFdAmmlnZZ33CVES/tCrvnj9Rc9F441sb1XGjk5lU60MS3bYFRszUVhoFRMLql
	cbWDmIHlLldyWb7s/RXXUM3dXEWHe/upvvSenocFtoA2oOFYQcHzEwUdjeh4KJlzUKrkLG
	Kvpr3QsL+R6Uv/mQU1CmP/thr8ftTUg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jitZrOHB;
	spf=pass (imf19.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783515008;
	b=wC1KTYUQX9fmbaHFgO68nuPUfd+igPO2L3vT9L2P8MwYd15l7t6Y13/55oR6eDrliS9bZL
	/6ZW8rhedl5cAGJtPByIBuB4zDRfeDoWBiFGkcSa25zgHH+w06XCu3lOk2Jah3L6WrSiHA
	xcH9I4051QBXuuseOjg4KPJt+AQxsqA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25C1560054;
	Wed,  8 Jul 2026 12:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2693F1F000E9;
	Wed,  8 Jul 2026 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515007;
	bh=IbwF4pMHfyhwOslYT5YnzmrvzgTa5uH5GBgU1nK9uiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jitZrOHBE9XNJumMdXFVv18tUngtPLdb9x2l4MXb1a4a3audPmwI5ES1+E/p39+fH
	 HMBtTttJu5WKPwMZpzl5XSMW8IWWsdWOQpWuuuOHUvCzW0Upi/fHIEHKy/XatkKhbs
	 YIrgECVYDaOyOlaeXFov/nDhiba0x7J/yL1Q67FUZOmQNsefjzpkn/aCjEu0dJ6ZK9
	 nlap2Fjp+x+P5ahqGT40ffudUAfNKdE4tL3hjqRQjY1+Q8v+zswk6N6KyX0QPm3fqz
	 Jak61XpK3z4GmnyZVFYWCCa1m5lbXTTe07OjSwKUXfEIRonD9IqEaS2TOTSr62FACC
	 l7BKByWi/ic2A==
Date: Wed, 8 Jul 2026 14:50:04 +0200
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
Message-ID: <ak5CXzGStC6ZmtwI@orome>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
 <akzikTrmhMsvkNVY@willie-the-truck>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gs6kcdn3aiethnov"
Content-Disposition: inline
In-Reply-To: <akzikTrmhMsvkNVY@willie-the-truck>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A62A61A0005
X-Stat-Signature: k9fete5c55mbqyq7akdqct47j4upcy73
X-HE-Tag: 1783515008-788840
X-HE-Meta: U2FsdGVkX1+QvLgQWJU03x+ND0dfaxUSa4u+sZRat3lS/lX6Dyo+jsT7m2exBpYQ03kBeyTEd7yAX1PpEEOqXrL14ZaIOVzFk1qdDCnldPFMocrUlL3tBgGtDGbcC6K7rRV6i24i01uZGN+mbTQ1hoUBbO5zBpIhf+HstdpJwVxjWKhgNo+GyHe/ltqg30lqenVrEw9vOopBv8i/aNU2YGeaHjo93gfa6n0ncNUjp9hGmVlwlw2bGo/S4cXcYztpHsg54PKpcbe/ELA8NQW9DQJxgo0dyvwZwDznZjeezTvY90MndS158yC6YOW48AD+DGcKE52d4CCMxWZL/kVnz/u9l9ApiehwaYHSt5qpXdYO52torqmCkruheQJqrAfkVxl9Uz8I7cceTLKY862KV/lp4VBtq6dd1L9xQLTUpJf803h6m8MtJib/JNGMeIfif6h61yRnThl+NyBTACNVRfGeInG9TksX1cGHZeu7ALseHwxYAQeKb+qv53mTTfL9ISmjwQCwu+9x0gYSIepUxSLxNSdSQOBKErNG3zTTkCT1s4ia3RTFmMPyAEFK9P+WtvI4W3MhpsfyyT4FNjUTdbV3tHG+Skz6wGLc+bukbtU6KvlYeejNjBdY4358bc1IWggn/ostmcJmk9xK64LwLWrtF83vq46V/+vuQ8kzBKKWfrSjgoH7IdVhIHHsKlrqBxD0yY5+EpONBmbPUjJfkl/06laMc4sTHeaspp6wf1t9jIi6YtXruH1VMgVxQR6/JSgh0f3mTB9vrDkIRdm+DEfmOpOgkwbuuGA47lmaEUZ/ndv0Tp3GzrZ7zNQvu+JZ+WFUzY/qcA5oAIPhUYQn/aTsItA/rCX4mn2lZR23wIWJlaodYU+PfpaMWwCzszTPgxHKSN7PDvqaPcrdTKUOAkDd4E4V2eOaiqRer8RqVXcCoVD1zi9cFMp24cpKk5Lx4sS+awnWgJ2bbPTIWio
 glBd6QjD
 Q+CvHuZlgOZr/+6TQ2LP4GMQqoQB4DFciy8jc30eNLpLzuaCVW7236IgwMvUsigzohuT0V/ummZhG/AKKVeSEvOeQxkCmI0FoEw36Q0I5A+GgV9Q9t3VmRLwN02zF4INQkVN5/4GNw4W1ZVqBqhCKQ7IUpOKi2cIOjv/6rHx9QhV9i14PehjBZkAmCLagPoV6J1qCbqKOuc2gTl+cTwuADsghFN5C4qMzqPVqe4MLlwtqGbVfRdonRJFtBF2iqF49fhxJGufqxRRs6NieP5BuMfVipduOuLW8/kjGm8u0cZB8IC2zSUnPLb4Y6SnHyHVUSoH643sKfZbJ/rGbpKlvKTxxzrle+3ylnJ0018JZjbZwhrhbxG/pBfr70KUW3Ftr4XAEHe9J+aMAoISzit8rR1fmr1X6D/kNhZiTC8Wz++47ysuXIvgpoZIEvUXeehwXWfT6DbJuwza/XoEgVI5isNNGqS7zUgtR25vin1+okBE6DTRagD1Q7kNq/psNmpswANGxk6mA1qXHPWUb2dvrT80kUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--gs6kcdn3aiethnov
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
MIME-Version: 1.0

On Tue, Jul 07, 2026 at 12:27:13PM +0100, Will Deacon wrote:
> On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
> > On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> > > On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > > > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > > > > From: Chun Ng <chunn@nvidia.com>
> > > > > > >=20
> > > > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protec=
tion bits
> > > > > > > on a kernel-linear-map range.
> > > > > >=20
> > > > > > That sounds like a really terrible idea. Why is this necessary =
and how
> > > > > > does it interact with things like load_unaligned_zeropad()?
> > > > >=20
> > > > > This is necessary because once the memory controller has walled o=
ff the
> > > > > new memory region the CPU must not access it under any circumstan=
ces or
> > > > > it'll cause the CPU to lock up (I think technically it'll hit an =
SError
> > > > > but in practice that just means it'll freeze, as far as I can tel=
l).
> > > > >=20
> > > > > Probably doesn't interact well at all with load_unaligned_zeropad=
().
> > > > >=20
> > > > > > I think you should unmap the memory from the linear map and mem=
remap()
> > > > > > it instead.
> > > > >=20
> > > > > Given that the memory can never be accessed by the CPU after the =
memory
> > > > > controller locks it down, I don't think we'll even need memremap(=
). The
> > > > > only thing we really need is the sg_table we hand out via the DMA=
 BUFs
> > > > > so that they can be used by device drivers to program their DMA e=
ngines
> > > > > internally.
> > > > >=20
> > > > > Looking through some of the architecture code around this, should=
n't we
> > > > > simply be using set_memory_encrypted() and set_memory_decrypted()=
 for
> > > > > this? While they might've been created for slightly other use-cas=
es,
> > > > > they seem to be doing exactly what we want (i.e. remove the page =
range
> > > > > from the linear mapping and flushing it, or restoring the valid b=
it and
> > > > > standard permissions, respectively).
> > > >=20
> > > > Ah... I guess we can't do it because we're not in a realm world and=
 so
> > > > the early checks in __set_memory_enc_dec() would return early and t=
urn
> > > > it into a no-op.
> > > >=20
> > > > How about if I extract a common helper and provide set_memory_p() a=
nd
> > > > set_memory_np() in terms of those. Those are available on x86 and
> > > > PowerPC as well, so fairly standard. I suppose at that point we're
> > > > closer to set_memory_valid().
> > >=20
> > > Why not just call set_direct_map_invalid_noflush() +
> > > flush_tlb_kernel_range() for each page? We already have APIs for this.
> >=20
> > Having a "standard" helper with a fixed and documented purposed seemed
> > like a preferable approach for this particular case. We also may want to
> > make the driver that uses this buildable as a module, in which case we'd
> > need to export these rather low-level APIs. And then there's also the
> > fact that we typically call this on a rather large region of memory
> > (usually something like 512 MiB), so doing it page-by-page is rather
> > suboptimal.
> >=20
> > > The big challenge I see with any linear map manipulation, however, is
> > > that it will rely on can_set_direct_map() which likely means you need=
 to
> > > give up some performance and/or security to make this work. Does memo=
ry
> > > become inaccesible dynamically at runtime? If not, the best bet would
> > > be to describe it as a carveout in the DT and mark it as "no-map" so
> > > we avoid mapping it in the first place.
> >=20
> > VPR exists in two modes: static and resizable. For static VPR we do
> > exactly that: describe it as carveout in DT with no-map and deal with it
> > accordingly in the driver. Resizable VPR is for device that have small
> > amounts of RAM. Content-protected video playback will in the worst case
> > consume around 1.8 GiB of RAM, so we want to be able to reuse for other
> > purposes when VPR is unused on those devices. In that case, the memory
> > is also described as a reserved-memory region in DT, but it is marked as
> > reusable so that it can be managed by CMA.
> >=20
> > The resize operation is fairly slow to begin with because we need to
> > stall the GPU and put it into reset before the operation, then take it
> > out of reset and resume it afterwards.
> >=20
> > What kind of performance impact do you expect?
>=20
> You'll need to measure it, but we've seen reports of double-digit
> percentage regressions in performance and power. As I said, the problem
> is that you need to split the linear map to 4k page at runtime to unmap
> the dynamic carveout, but that isn't something that can be done on most
> CPUs. Therefore you end up having to use page-granular mappings for the
> entire thing, similarly to how 'rodata_full' drives can_set_direct_map()
> and the perf/power hit affects everything.
>=20
> It's hard to know what to suggest... I wonder if any of the memory
> hotplug logic could help here?

I've read up on memory hotplug a bit and it sounds like it could fit
this really nicely. Given that we only use CMA (along with the extra
patches to it) to make sure that any buffers are reclaimed for VPR use,
we should be able to get rid of the CMA usage altogether and replace it
with online_pages() and offline_pages() instead. Rather than using a
fixed set of CMA areas like we currently do, each "chunk" in the VPR
driver could represent a memory block instead (which looks like it will
be 128 MiB for 4 KiB pages and 512 MiB for 64 KiB pages). We currently
use 512 MiB as the chunk size, so it should be relatively similar and
easy to adjust.

One issue that we would absolutely need this memory to be ZONE_MOVABLE
=66rom the start. Using no-map in DT and then online_pages() probably will
not work because there's no struct page for the memory. So we're left
with keeping the memory onlined by default, in which case we'd need some
way for DT to instruct the memory to be put into ZONE_MOVABLE always.

There's a "hotpluggable" property for "memory" nodes, maybe that can be
extended to apply to reserved-memory nodes as well?

Thierry

--gs6kcdn3aiethnov
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmpOR3kACgkQ3SOs138+
s6EbFg/9G04JpY5Cu3AX1K9vtQtrw3D5Gowsl1qT7PXe9AmN9PK2oggEDnsm6JPw
hyDVKxzpLbktBMB5vNKmr4KGYrIEeW4fs+thwrdNjf5GhX7cTQyL78oHaEVTZAn7
cpiFfepSy6xW4ZDIpHzj6bUVg06S8VZmLOwKHuDbA4N6PZ95evD1ff3/TQs6Y1E6
WJhgBPjZbTLh6jiIM1y2hRK3GAChy9nC2g2R1LOySIK9NBCgfKV0p2/hv+vQCLSk
e5ON2GcP06dR1XChOMnEPkUS4BzptxIzVkM7aRiGPJqxVREXJK4MvRTyjZ+W4FuX
R/QDhwkxdI8+4pwfVPWB10dEWH5vfIrxU5VwO4Uujp4p14P1/nKkWXTe8S69Qitj
GU8UxLk76btqwkVS43qOyHXH+yXuQBiaWBVTyo8vQx3zp5i8gq1h1xm04ryI0hWj
BGqXiOxzDr6lEmXUj6h3gUTP+14whWOW8lTqIL0QTKwC4HDv5KTgfgBME2KkYAwp
1adJdmJ09vhkKAOK1mKHCJHmhOggmoDpIfH8yYSbHeTe4mZZHq9qKtFjvzA8TtMw
82H0EfyjYM8eNPNZU1/SfsTnhKpTmnLpDCmmdz6Oe4hWGxZVO16z9VujL/EPa0fa
mY3dWpM8cSvKCP6jm8jguy5IhhLZkS4ljig1obSEvcH0/Tu1FJk=
=zFs3
-----END PGP SIGNATURE-----

--gs6kcdn3aiethnov--

