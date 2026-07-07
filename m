Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99DEDC44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677776B009E; Tue,  7 Jul 2026 07:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64FC46B009F; Tue,  7 Jul 2026 07:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567E06B00A0; Tue,  7 Jul 2026 07:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 277C36B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:27:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A8188168D44
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:28 +0000 (UTC)
X-FDA: 84961754976.09.C54649E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1D1F4A0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:27:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcnzsePl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783423647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYNExvVjE68Bssuz6Q0Uk1wNO8ENlyByAV7s1CeJs/c=;
	b=FQLVk4rZO3BzMLpFS3qTqn1q3fHhZJBCm4geV6Z50Mbvhh45WWHoA7FKQDpqSvwxnWPcrA
	LC5Zl/iCZ0nE5ohHA+BZLVrJmNFy1ThUKye79AqSJwfw9+K9BhPedzE4M1yf74OB1uX/sT
	jqVKLmdTe7TBn7Ipa5YEF3RitvOJ0Lo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GcnzsePl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783423647;
	b=42OI23uIKcp1wR8wxAI5wRcznsrjdtgKL8xSFGOL0kYb2b1TTLIccnrBbv4+BfSVHKvLgq
	d2Z0kk0xGkXSmcUyTDxMdMv+vB6tGZK0hMMWZmWfZ5SE2X2RGS44W3hNpnxiAooYKn2LVp
	5HYhArwmv6zPmbGUKjWOlMrNQxHIHfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86039618B0;
	Tue,  7 Jul 2026 11:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C559E1F00A3A;
	Tue,  7 Jul 2026 11:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783423646;
	bh=aYNExvVjE68Bssuz6Q0Uk1wNO8ENlyByAV7s1CeJs/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GcnzsePlke2sHPVKXFrpmfWgDPaoaXvAGDCsvjpqbfsyvtLlho3fWpXDj/uKbDk36
	 29MbpRdO6rfO94xIsXtWVBLVNSFu0PRpK+8Q3N5xgWJ0OkZvieybMvgBUqMhb2gQ4l
	 Ahv8XDpa/3PWbSrFZzHelbxOI04a8OSapHaj/zeLfsMzVDa3n5HsTdyC0YbOpI139d
	 fBoWckCalPRK9vcu5ifrE9IuraW6MqY6Q5ge3UN3DrPMz67mVJTxLFQXEVChjUNePg
	 j6GuAFSVjQX9tNj/p8+7XZT6WNDH+X3gTCGkYbSR/BFOoYlGChu7c6d+b+RUXalLPP
	 aFzzC3Jb5OcTA==
Date: Tue, 7 Jul 2026 12:27:13 +0100
From: Will Deacon <will@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, Chun Ng <chunn@nvidia.com>
Subject: Re: [PATCH v3 04/11] arm64/mm: Add set_memory_device() and
 set_memory_normal()
Message-ID: <akzikTrmhMsvkNVY@willie-the-truck>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-4-d80f7b871bb4@nvidia.com>
 <akYs91INHMXMTI-t@willie-the-truck>
 <akZkuwktaXFTrASP@orome>
 <akaSJ5D98w2cHqb6@orome>
 <akftuw9NyRy36fXA@willie-the-truck>
 <akuvyu1Pq0ZVMZV0@orome>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akuvyu1Pq0ZVMZV0@orome>
X-Rspamd-Queue-Id: 1D1F4A0003
X-Stat-Signature: 15rxpdugis3mwnzub61bakhm6aon5564
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783423646-967966
X-HE-Meta: U2FsdGVkX1/4jcN2rFuf5GFCIpzBtynM7NC6gihDm+CmcEq+H2AfJSfXt/+l0AsNCu6C3Ivh6oOfQ7K1T1nTG89FElUbbXMtgAXDYTzSooOdvC0+sns1A29QP16Qpy3/3PVI+eWakfkG7ODs0EtLhFirWXfp9q4pxW7AKsBgYaNd6QuvIfIRdruz+tBsTIe0vC4pWoqwT+vuJjtFBLLRZsRn7ZC/fka4PrCEMrgbmmznfPHNzJEzW+V+o56+c1aNPCTJxBRdMtRTJvuduDJykSWo1llwBZJ9W+k272NSJNZXu0bbzowNtfyqxpDhArKDMK3ElJ1b/k8Aeb/qsWfO6Qq6AdvibiRUU4xa1bOhLIjRH6zZds/yYmnleoHesiYj3QfonPTv/9WqGB7omYkRTISdTqtEZSQLPqyY+dBZYBrDj4CK6edBMps5RRyt1XdqkIF34n8bjAvue6/he8WJmLN+TuwMwNgpHYwWLVS0Rk36YDT78ritcIE0EISjdnywA+cOiiG49xD/+eVsdqTP+GYnYVMExZlAcowSXhfMqBlU0I0gdhjAjwh37QC9MWudF7RV6DyGEHyOEXjrLUYX5mc4NHlrH7qbR0D6Re2KsJWLMje9C9NzXiowJ/QaVZExygorDAufBewaD20gtMfPCJCbH/uACkeG+UwjqClmeKdmrhXFXLFByg35zFnuJ7pvfS7sRlsnH/Yxbir5SinQOw+95e01AqsXm58512TUWfn8AAspn1YOVDBEdwG9iT8LHVnPzSuPt0IobWs82rS6EjHGIq0q0IPPKwR5RsT9PAndCbS0zM4jSsaoQtNAlhF7MS/Fb7jRrgGGdut+y/dUs58vQH0pySZOu/tcd68x6IQLQxXHSItLVVEb3NZ6PiEPU2wpY5wB5svw1THX688I5l2ycjBot/PJ/QcNuklQpn9R4ucUvvuDI9H/luiRvmpySphE08OCPJRkh0yTrYr
 Nfr2mfEu
 4Ev4BFT/CMjhoO5jPi+yFsljNBfownAytUNSpUzhtlZPxSl6leKV1kPSuv/9si3Syc+3rb2FiAgHmwq/6Z27QrFJJ2DgewENXwgNYuNHXPnzvmAvO5FZypv5KkH+NHlpZqXju7zI+X+EPVZSryozOBI0WzvxjHGIOLhsW8NtQTLpCkwCASM0nMuukjqi6DjTi8AjlDZUfPTr1DRFqiyQnnw8J534NqSV+2l2tcBISGsM+O5ghgeIxVc+O4R6bDd/vCMywA/R1vp7VDYC5jbgWxkifoxf438e4EilpVEqbRnpzAtx7AhJ4jNmm/4bGJZZ4zbPAEUEz1uXkybLPEH9in8U725iUZEqZcuJY5nqj1vxXjRm6FDYGj7oTVFxknlXllC3XuOsmYL2igwPHVN6Wme6PBWygF1O2LtwwwmhROi16ICafGaUzMS2+OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 03:49:24PM +0200, Thierry Reding wrote:
> On Fri, Jul 03, 2026 at 06:13:31PM +0100, Will Deacon wrote:
> > On Thu, Jul 02, 2026 at 06:41:23PM +0200, Thierry Reding wrote:
> > > On Thu, Jul 02, 2026 at 03:46:44PM +0200, Thierry Reding wrote:
> > > > On Thu, Jul 02, 2026 at 10:18:47AM +0100, Will Deacon wrote:
> > > > > On Wed, Jul 01, 2026 at 06:08:15PM +0200, Thierry Reding wrote:
> > > > > > From: Chun Ng <chunn@nvidia.com>
> > > > > > 
> > > > > > Add helpers to swap PROT_NORMAL and PROT_DEVICE_nGnRnE protection bits
> > > > > > on a kernel-linear-map range.
> > > > > 
> > > > > That sounds like a really terrible idea. Why is this necessary and how
> > > > > does it interact with things like load_unaligned_zeropad()?
> > > > 
> > > > This is necessary because once the memory controller has walled off the
> > > > new memory region the CPU must not access it under any circumstances or
> > > > it'll cause the CPU to lock up (I think technically it'll hit an SError
> > > > but in practice that just means it'll freeze, as far as I can tell).
> > > > 
> > > > Probably doesn't interact well at all with load_unaligned_zeropad().
> > > > 
> > > > > I think you should unmap the memory from the linear map and memremap()
> > > > > it instead.
> > > > 
> > > > Given that the memory can never be accessed by the CPU after the memory
> > > > controller locks it down, I don't think we'll even need memremap(). The
> > > > only thing we really need is the sg_table we hand out via the DMA BUFs
> > > > so that they can be used by device drivers to program their DMA engines
> > > > internally.
> > > > 
> > > > Looking through some of the architecture code around this, shouldn't we
> > > > simply be using set_memory_encrypted() and set_memory_decrypted() for
> > > > this? While they might've been created for slightly other use-cases,
> > > > they seem to be doing exactly what we want (i.e. remove the page range
> > > > from the linear mapping and flushing it, or restoring the valid bit and
> > > > standard permissions, respectively).
> > > 
> > > Ah... I guess we can't do it because we're not in a realm world and so
> > > the early checks in __set_memory_enc_dec() would return early and turn
> > > it into a no-op.
> > > 
> > > How about if I extract a common helper and provide set_memory_p() and
> > > set_memory_np() in terms of those. Those are available on x86 and
> > > PowerPC as well, so fairly standard. I suppose at that point we're
> > > closer to set_memory_valid().
> > 
> > Why not just call set_direct_map_invalid_noflush() +
> > flush_tlb_kernel_range() for each page? We already have APIs for this.
> 
> Having a "standard" helper with a fixed and documented purposed seemed
> like a preferable approach for this particular case. We also may want to
> make the driver that uses this buildable as a module, in which case we'd
> need to export these rather low-level APIs. And then there's also the
> fact that we typically call this on a rather large region of memory
> (usually something like 512 MiB), so doing it page-by-page is rather
> suboptimal.
> 
> > The big challenge I see with any linear map manipulation, however, is
> > that it will rely on can_set_direct_map() which likely means you need to
> > give up some performance and/or security to make this work. Does memory
> > become inaccesible dynamically at runtime? If not, the best bet would
> > be to describe it as a carveout in the DT and mark it as "no-map" so
> > we avoid mapping it in the first place.
> 
> VPR exists in two modes: static and resizable. For static VPR we do
> exactly that: describe it as carveout in DT with no-map and deal with it
> accordingly in the driver. Resizable VPR is for device that have small
> amounts of RAM. Content-protected video playback will in the worst case
> consume around 1.8 GiB of RAM, so we want to be able to reuse for other
> purposes when VPR is unused on those devices. In that case, the memory
> is also described as a reserved-memory region in DT, but it is marked as
> reusable so that it can be managed by CMA.
> 
> The resize operation is fairly slow to begin with because we need to
> stall the GPU and put it into reset before the operation, then take it
> out of reset and resume it afterwards.
> 
> What kind of performance impact do you expect?

You'll need to measure it, but we've seen reports of double-digit
percentage regressions in performance and power. As I said, the problem
is that you need to split the linear map to 4k page at runtime to unmap
the dynamic carveout, but that isn't something that can be done on most
CPUs. Therefore you end up having to use page-granular mappings for the
entire thing, similarly to how 'rodata_full' drives can_set_direct_map()
and the perf/power hit affects everything.

It's hard to know what to suggest... I wonder if any of the memory
hotplug logic could help here?

Will

