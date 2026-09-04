Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCE0C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B58B06B008C; Fri,  4 Sep 2026 06:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B09886B0092; Fri,  4 Sep 2026 06:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7496B0095; Fri,  4 Sep 2026 06:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 737016B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1BB580829
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:21 +0000 (UTC)
X-FDA: 85175748042.14.F9AEDC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1C048C0002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BALLR90L;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518720;
	b=g5cKCD/J1fAT0DxUwMnYrYif7dYEWoQlok+Zp60T9p8Xatl1eI9IAyNop1Y8gVdxBKLgfB
	C5xICtRlyk5IzyKw8AinFMpSMiU2QL9zfdIlVEfriB3mT2RVkFj3N/JK+rklQyVPYd8/4n
	DwExxRhSNLymKKP07CrqAWWONvrxPdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cqzmU3ki12NU7A9MsQeD++1Ge35jyyBd0fg3ah73vk4=;
	b=1Jy8UhkVL63EA4Zb5iv2PguxcinDJNgkmeHyVSEgsCJrXsplN0xL77SJ7v7t1EK2qQ6Vyb
	lvi1P37YJWmEDjVtWWrC4oS4kJ0ZGjg/o9gt2hMBh/6wSktqsjzu89Ekp55aIdUB6ooB3F
	UcRdlFVE3/wrDhhIKLuHD5tnWHPlELA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BALLR90L;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86B3641947;
	Fri,  4 Sep 2026 10:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5731F00A3D;
	Fri,  4 Sep 2026 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518718;
	bh=cqzmU3ki12NU7A9MsQeD++1Ge35jyyBd0fg3ah73vk4=;
	h=From:Subject:Date:To:Cc;
	b=BALLR90LQiklf7wRvUntz6hV9ibA9IU37ldiy/b2lr0DHgnfxUshPFPfKoIZpUQac
	 2NIYe949sQbBzLmLQAddAeBccv8aF/vnXwhWrEiU1+v4AkkHf0f1WikP6WTmUAdeu8
	 cMDCIhn9y7YswrVcgVXNKynOHhJHsvFODSSi/LTrxX3U2KKqBKKySNkkzjvyYXcQLx
	 YxTbvhz7STECbXG3TKRHFpnHAAoWRKVg510AXmK2Ywpl19wqrxucjlN/gte+8FpRPG
	 XpNhfZVnbwUYhnWkAv9x0EWl1x6Q9XJhLhK8FMa2YjtTn+49W3lgpAtC8qTRw5Vnpl
	 faSQQCCnrvMmw==
From: Thierry Reding <thierry.reding@kernel.org>
Subject: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Date: Fri, 04 Sep 2026 12:44:51 +0200
Message-Id: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2XQ0W6DIBQG4FdpuB7mHATEXfU9ll0IHJWt1QYdW
 dP47sM2iza9/JP/+0/gxiaKgSb2frixSClMYRxy0G8H5vpm6IgHnzMTIDQoqPhMXWx4ukTuvLR
 OKKiddCz3L5Ha8Hvf+vh85OnHfpGb14G10YdpHuP1fizh2lt38wIIVFKXUEgoRW0kRz73gWK8F
 pF8GLpjd27CqXDjma3TSfxjDSgEagSoi9JoZYx5xd8UBzoVY+weutx0Bbh7Uio5cG+grayp0Fp
 5HFLwodkOy42ap99IMlOlEDzqpjU1vVC1oyj3VGVaoSmFVR6E1E90WZY/tLGVgaYBAAA=
X-Change-ID: 20260507-tegra-vpr-cd4bc2509c4c
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=5267; i=treding@nvidia.com;
 h=from:subject:message-id; bh=56VMz5vHAxhz+LRAnNs/TniTeXBpTxsK81BlkdKdQFQ=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE1V2RBeSbaiERM5hkiP3BUdWdEmk8oeAwvr
 DB4qXKfIXyJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhNQAKCRDdI6zXfz6z
 oUAnEACicMN7Orn8rhXBkLGkym+SdqsGrfqanUEAABndk3P8jAL4jPW9sZd8oMfdN7WwRfDGeSS
 2yH8tjJn9mDIBQtCvu9eZqErBbBJXluj+9kDosqusPTGZfNj2bCGTAHWEAlZlHA61YROjnlwl0c
 yi++/TuAmiSx++NIWF9QEnA0GU3ScxjLiDdiT7Vo3Z0iVf3nPwQt6h8y6jDwbq25MQ/vLwldQd3
 YliwIYC8jA/QftAgEZVrjJgPEkJTqdB3TYbRx73m3rQgBfmY9N3DmGlmcWgBhlFdXO2opW8FKwU
 OKWVFabqWMlENHMjpmzJCOFVPyE9TbVGjbawfumEyMl6mTbAUDMefOv3oFDJsG3+AIHz4GXNnJ9
 R4P7DrNg3TaN1JlLAjxz+apP5yQc+Ap05MHlg8HizQLNyJyrAhx5+oY9GIx9UHrVhjA1h3vzes5
 9UVqDKYanfSmRY+dCMCcKLVII5VRVCUD6Vr1T3EslJXmWLjamUlaBa3QdpHIfdTyDt7Sj3IyRjq
 pIEDqUXMhr05l6zFoQugXJ/GrDn8H8CHauucpvvQHekWiNQdj4JPqT7ak+H8XAfOU8fsZxgVLUa
 S3VXZNY7/0ifbaxeLlLVsPPB8dhNB/2MQk9SC5AxQcmuBT04wlrOsl2vmvk9lDT+Qzl0gUMaerq
 s2MsaOD+Z20vWEg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C048C0002
X-Stat-Signature: wem1xwept9uq31tkxydhoednnfm3bqnu
X-HE-Tag: 1788518719-173549
X-HE-Meta: U2FsdGVkX1/DSewZZaeUYh2D3T4SooDbsyKkuIB7Hw4+8zZoReKbfzsXA+t13e2eeBHsnKG9pGqWxiRLP+Qw2i7JY9YZFRueGdjOPu9Zd/8t0UhcwhNbSefOQP809Y7wO/u/bkBRoAwplPAOfR7HF6UiLEQIGDluxk5M5sQqAPgoqqZ0l3lG3E6Xf1KT1AFTn56QmSF3GgWZ2L+9C++7RKOf+D95LbWEIjTfGjxOKkQtlPMqSo7EuId3YPteaV+Kua/kxQoqGQQMrjb8HtAlWNqeduM6GOXVbPhKo5v6GovcCXFEJLoZqyY1aOjYU67Z/n/yhuO/kOeazeQ61X1k+k2EyXlOJKXlcU3NBFUxjjZWGQ4zh5Efrxzgh2RwVtNSOea70TOrkvT1gH489dVm37nrqOGi6sdetKrfmjJ2RmNIwmjtwZzaFF6qoU63OF0n2VGfkRs9DkJ5bSI1j0SbazCsZvPr/sMmsG9OqYIq9cHl+I0ll+J1SNwwPQauSAdqR0iK3IyVE+vS7ogzgwza9ju1XVyPxEm/jE3RPglIri+ia+DkhYg4sjTnapzBFvXKOU6l/fZFT3++gKiyRIg1eK/YirTaQEDLjCwb6v1rJlCD4vpBdGn8h0WBZL0IrILq16N6ETmXo4Sdhai9sS7gfHMDcrCx2MkFnuNUH04nrjaULiWNnCB/BjQZ4hpNwVj4wqmjtongh7n+AD8nqawbMHhFZNR7Ss4BDSno2q6bEG00ONeHHisFUvQzrW4Wb8aWd1bOrlWQ0VL+s7pwsraYCgsDczZupphrwo/Zh8GldpWbSyEd1YZqS8Bce1ODxmLHa/6w7CI1V/3TaSufkiQcU395j1t8JlKpSImQI19bQr0AMKvQjmdC93j0Bxi3GVQuAgWRFEhiJdXQyFglPyqWB0gcgiIKp8lrfX8/Fa26ZeaYygBoQxodg1Uiy7ETpeEE6rfHNyS80eJQLVi6qvL
 in0NhHKj
 11C6wJ3aO9/gt+gr6rMxsqNz7czFKjGLEbgLpXGiJ/g5QHHWhtIGv7PL7R0GnYkimqtv9RtyZZsU7L95SG1XBKjaeg+1mH5pRhv0WwGMZaV8LuUX824Pkr3OnKPivsARTbXrnMhVaW/uUIj45PQWXAwDGcVy5GXz0Cq/GmKjqdMpKnvfUW+ZRc1WT8vIHrRqnBs3igzG9y21CxSPXBVD4Bce914W6qZ4siY6zLk6O8/JBXZ8KTLMfbhWcQc+XExlwhamZ6qa9iidqy/LfHFDUP0J3IaRZPykkc6t2EnmvtdgzGqd/N5ijf3HPeeHkW51VkGOZcwEs5EhLRRk4mGmJqj9pkwxzxD234AZNX7icJlhGndJIlyfJ142aPNt965PPML+xP3Hb/gLkL4CjDdt0wJH7RmW4Oxns9qoY4zV1GOoBtO8lQNwDgVLlpaIWBcIEa96F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series adds support for the video protection region (VPR) used on
Tegra SoC devices. It's a special region of memory that is protected
from accesses by the CPU and used to store DRM protected content (both
decrypted stream data as well as decoded video frames).

Patches 1 through 3 add DT binding documentation for the VPR and add the
VPR to the list of memory-region items for display, host1x and NVDEC.

The set_direct_map_*_noflush() functions that will be used later in this
series are exported in patch 4 so that the drivers that use them can be
built as a module.

Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
but works on sizes that are not a power of two.

The of_node_to_nid() function is exported in patch 6 because it is used
in a later patch adding a driver that can be built as a module.

Patch 7 introduces new APIs needed by the Tegra VPR implementation that
allow memory to be allocated at a fixed offset within a CMA area. Tegra
VPR needs this in order to implement its own allocator on top of CMA to
meet the strict hardware requirements. This replaces the dynamic CMA
area creation patch from earlier versions.

Patch 8 adds some infrastructure for DMA heap implementations to provide
information through debugfs.

The Tegra VPR implementation is added in patch 9. See its commit message
for more details about the specifics of this implementation.

Finally, patches 10-12 add the VPR placeholder node on Tegra234 and
Tegra264 and hook it up to the host1x node so that it can make use of
this region.

Changes in v6:
- refactor cma_alloc_at() to maximize code reuse
- allow building Tegra VPR support as a module
- requires two new patches to export symbols
- Link to v5: https://patch.msgid.link/20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com

Changes in v5:
- use a single CMA area in combination with the new cma_alloc_at() API
- drop dynamic CMA area allocation patch
- various cleanups
- Link to v4: https://patch.msgid.link/20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com

Changes in v4:
- Link to v3: https://patch.msgid.link/20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com
- fully remove from linear map while chunks are active
- address checkpatch.pl and Sashiko comments
- improve error handling
- remove freezer support

Changes in v3:
- Link to v2: https://patch.msgid.link/20260122161009.3865888-1-thierry.reding@kernel.org
- introduce set_memory_device() and set_memory_normal()
- rename VPR nodes to "protected"
- add Tegra264 placeholder nodes

Changes in v2:
- Link to v1: https://patch.msgid.link/20250902154630.4032984-1-thierry.reding@gmail.com
- Tegra VPR implementation is now more optimized to reduce the number of
  (very slow) resize operations, and allows cross-chunk allocations
- dynamic CMA areas are now trackd separately from static ones, but the
  global number of CMA pages accounts for all areas

Thierry

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Thierry Reding (12):
      dt-bindings: reserved-memory: Document Tegra VPR
      dt-bindings: display: tegra: Document memory regions
      dt-bindings: gpu: host1x: Document memory-regions for NVDEC
      arm64/mm: Export set_direct_map_*_noflush() APIs
      bitmap: Add bitmap_allocate() function
      of: Export of_node_to_nid()
      mm/cma: Introduce cma_alloc_at() API
      dma-buf: heaps: Add debugfs support
      dma-buf: heaps: Add support for Tegra VPR
      arm64: tegra: Add VPR placeholder node on Tegra234
      arm64: tegra: Hook up VPR to host1x
      arm64: tegra: Add VPR placeholder node on Tegra264

 .../display/tegra/nvidia,tegra124-vic.yaml         |    8 +
 .../bindings/display/tegra/nvidia,tegra186-dc.yaml |   10 +
 .../bindings/display/tegra/nvidia,tegra20-dc.yaml  |   10 +-
 .../display/tegra/nvidia,tegra20-host1x.yaml       |    7 +
 .../bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml |    8 +
 .../nvidia,tegra-video-protection-region.yaml      |   75 ++
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   45 +
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |   33 +
 arch/arm64/mm/pageattr.c                           |    2 +
 drivers/dma-buf/dma-heap.c                         |   52 +
 drivers/dma-buf/heaps/Kconfig                      |   12 +
 drivers/dma-buf/heaps/Makefile                     |   10 +
 drivers/dma-buf/heaps/tegra-vpr-init.c             |  133 +++
 drivers/dma-buf/heaps/tegra-vpr.c                  | 1210 ++++++++++++++++++++
 drivers/dma-buf/heaps/tegra-vpr.h                  |   73 ++
 drivers/of/of_numa.c                               |    1 +
 include/linux/bitmap.h                             |   25 +-
 include/linux/cma.h                                |    4 +
 include/linux/dma-heap.h                           |    2 +
 include/trace/events/cma.h                         |   77 +-
 include/trace/events/tegra_vpr.h                   |   57 +
 mm/cma.c                                           |   88 +-
 22 files changed, 1913 insertions(+), 29 deletions(-)
---
base-commit: 850de4c714df026eb4c869fdb01dd722003e1ae3
change-id: 20260507-tegra-vpr-cd4bc2509c4c

Best regards,
--  
Thierry Reding <treding@nvidia.com>


