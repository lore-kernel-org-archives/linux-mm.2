Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 109EBC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF2C6B00A6; Wed,  1 Jul 2026 12:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081236B00A8; Wed,  1 Jul 2026 12:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89CC6B00A9; Wed,  1 Jul 2026 12:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C55786B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:08:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ED4112042B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:44 +0000 (UTC)
X-FDA: 84940690968.08.23364F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A9F5100012
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGttkpt2;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922122;
	b=AB7uQsRAlr7eaiN78GWMJePyFr0+VRuEbaZmAEwNUN6VKNnSYPVWYBaX4QVr/eiJ3HRs+Z
	IyWZ5h9NP8AdTWUTuxAqMNGzXOs1fOc5r3RfaFIZ3qOL0DSlsTJFL/t4IrIYOmKV7kUzxU
	/rKn4/Clk7DGHhoQHOFJQkLNGKAKEuw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yhKbdhzWpnCFtUyKxv59KV9t7EFGFM4f9xMCP7qFEVc=;
	b=x0U6pgazqqTpOnMxmAbIKUSRxTqkdi1ipodgRa+lkG1A/OtxMVcS9R2/nWFUgynLYuMcS0
	BGaGXrOtZpN49Gss9++uYSA1FeTloNbldyJo8N6gieLXgfo4MkrtO0J63uiO7kCbUH0PAj
	NVi07MRM/H7cVUiYvluoDd7U1zSdVeQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DGttkpt2;
	spf=pass (imf05.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 80C1843975;
	Wed,  1 Jul 2026 16:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4031F000E9;
	Wed,  1 Jul 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922121;
	bh=yhKbdhzWpnCFtUyKxv59KV9t7EFGFM4f9xMCP7qFEVc=;
	h=From:Subject:Date:To:Cc;
	b=DGttkpt2Q8nKCRV6vNcCihSl2s2P3sXQXJneb2lgwIMp0raQkYNBn0B1iX9JZDkVQ
	 k4dG+eTP0xET6M0xHtUZMmPygZeNasR7NNqEs8Ao4tGxxBHVQT0dN0j35xqWlq9F3D
	 7TsLhvMtgoml/volx9enNoXRvNhfnq/UzStbhMITnm9bZ/xCkB/ptpFu6MST6Do92a
	 Bo7rV46eIb+rv+nHPcgdEpykB73R3FFnK2I3Ad0Q6npJcf291MYux1yByzq3FPIUbv
	 xnwNoo5N03lozMT4svu7Zev3XAoIVv3pMjNXbAUDMNWq26FygDt4YyuolIWjGdjhAx
	 3kDaMQyK3Hasw==
From: Thierry Reding <thierry.reding@kernel.org>
Subject: [PATCH v3 00/11] dma-buf: heaps: Add support for Tegra VPR
Date: Wed, 01 Jul 2026 18:08:11 +0200
Message-Id: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WNQQ6CMBBFr2K6ts20lFpceQ/jAstYRgXMFInGc
 HepxpXLl7z//kskZMIktquXYJwo0dAvUKxXIrR1H1FSs7AwYByUsJEjRq7ldGMZGnsMpoQq2CA
 W/8Z4osentT98Od2PZwxjDmSjpTQO/PycTTp7ubsUwOjSugKUhcJU3kotx5aQ+akYG+rjLnY1X
 VUYOpHTk/mNHWhjtNMAlSq8K733/+MLco9XNXAUh3me32psPPb1AAAA
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
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>, 
 Chun Ng <chunn@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4551; i=treding@nvidia.com;
 h=from:subject:message-id; bh=mcbAkcbsEVWURkcAPa5vFsKErSyQeSmcgEUMd7efj+4=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuFxsKTwjOCtR5nhntJn2yLMnMlfh6zt+LAH
 7ky+Ynu4rmJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hQAKCRDdI6zXfz6z
 oQwoD/0TQ8Z6/cD6v/Zn3dSTI8WYQWxtO0vPJo49co9ceBSk7rvwa7sDWVnkq/aSR1DWCnjdTxy
 MLbFDy8d42e7a8WASPwcb+qxk6A2DE+rORTT8tNXAHjZazxr1zUSNcD7bWpsgKSCx5aPWC1mqKr
 Qd/jKd8UnMS98mbljjkzPqeLPL+YhkPEpJJP8DVT1i9YQMwxmEaGSZCLxuhhgKgyc30NbeIG/3q
 RvqF9uzJW+aC+WeXK7CXK/zLuEYuBQWl2Q/o0khZFV5ky9mLOsc/5WLPo1OnbyRnV/MRyFgKLu0
 9bgqlw4SvKJ8pCjuf23uADlEoQG7f/dJiiftMDDtoEU8bv0k0MY18tWKYDhHo25E4op4WnnWmTY
 dT8fZaVl4l76093yChzqBXvDxzh2Z1ScWIvcKyJ7rXameRAxhIOBNUH1fKZSvMHxnwLiu6sz6L+
 jMDvSC6DYoDG3PkaCo5EHIRC4VLIEaDzOx4W9++lDj28rsNMbaxrT7E4/eaxGxaTxs+GSyK9OuH
 75g4ungRoFK/zaOhqHYK6clVpUjduhNhuGaqldgN40zWkEDO5NdGEghVx/3uGHLT0L8XOaUpm1c
 jYi+cqYAfuQpQnJQ8c3JrVv3P4AeO1rlBm5cvphmRxQRD23EP0kUoWFgxy+eVF+WUSDoRjnyb4X
 wTi/+K/io8cd7EQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 6A9F5100012
X-Stat-Signature: byu1kuuumdx44iz3bf3xh74i8gq4c6q8
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782922122-247512
X-HE-Meta: U2FsdGVkX18F5uZJJIJtgcnJm104p4dOFBL606LwJKrN0RGIvNYuZIomEMZTK+uLA7/gcaZ17ADDOS8KPOCTbqh4J+lKIz10ZAUcYIZBAts0Dfk3coy464Buo8oFWACjSLqWg3vRbW99Lkbz9ArXOpDfgQdS5jfA1GBtnba4uff1ADEOYJHPD98MQtRZ0TSly/HrQI8fwSzjga1Reh/TbRS4OEmRvoJ5ALKmdtVtTpU471iMXppQsqY8pD2ij2TZjZ3R3q+OOWTy+7dwoI/Da2KY4IERb7DFMpUPkAgZLYasUhG28DecrdLZJWpjy1ZSYHDoA2f11455kr8g+WM4b194aRoDarjzHV4AZoiB3d7R9DFbpvnwI6H+vmK5uCoIEwJYjVZDX3/yuuj0G0fGNgTX4N+rSBei72bVV5pcq2a4eQmXOsCBavjOSYZpbP3NnKW2UkreShOW6BO1wd/xapoLJcopI+oIWmE82vGumTxxVOpKQh3bD2ynfwNaWVzFwJy6Xy2DUqeUy2F27Wjdwq2qa7CNZN0HzzNPgWPRwCbQi4AG0pujiTy1rBNkJlbEKvYWi+FP/V4HLxy25QATGjQ6dJwm1VDHS62nm0H9f7KnHplXH2085IszxpohCzk+BD2OsLbpEEXnfEmjBjx0Xp157MrFLHviwwuAaWNUVCXA6pGo4h7MK3d9q6NGlICwVBYGOXpHAQTzRk4PwJelmA1REgdKeVD1p3J9/56x3bGq1Y4wIfhixoo/0tmQGDM0jDXefAIK4f2gu4pJMYN2HNp2dHQxEiiiiAq6NGpX5HccUoEDKsSsmJN5Lui0mRcAlIgPaYXy0tdUHLbxPaIt6fvzermyQdqC/YPIRFfr+x5xPP8wZlKTZk0YKjtIeOaZRxwEhL8WR2chBZigzQ2NNRJib5OGqIF4E04vyxYqjGbTSnwwtcMzpqoxt6TXS9vZf2BHmCtbckv2io6X+YW
 tbcoHK+l
 K19n+XOiP5wIS5baT7apgrXuWgCQ3DWSgUT9Bwz2qlqlW1DF707PS353shULJk8NaxpRcRW6kAXJhsqCsnD9DD+XjQjt/pEc2B/OoaZiOdDRqY6wCUnGQ9k7lKyj//mYuQ55Vo8G2NvXlk+2Ul3ehxMPgnZFqrPaeVHMLjbecNEqjgLQYECfGkF2Mh/U84oUSlXQ3tYcvwOVq+9lpW2Gb/TYsVvS4KgIzWMERdnHsni0o70An3nK9skpP7TFzHEoV/QHx9sustgZfDQ1Wl1ilaeRu3PwL3ErdlbSpSLfsm0HM2vNzYfgPMpSqdnw6SpuPwcXCMxYBEFOQB/+uG7ipRmjPw2H5v4u/NTs5U7jHFvLtLMbaCc35wObXo5XDBBCBG8LWrWb8iAYVJ7aY62Di9aFlFdpFWeUHlHSX2zOXD8YLWcg1Vv0KR4AoUZoixvSPXSDq
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

New set_memory_device() and set_memory_normal() helpers are defined in
patch 4 and will subsequently be used to set the memory type of the VPR
to make sure it won't be accessed by the CPU once it's made part of the
protected region.

Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
but works on sizes that are not a power of two.

Patch 6 introduces new APIs needed by the Tegra VPR implementation that
allow CMA areas to be dynamically created at runtime rather than using
the fixed, system-wide list. This is used in this driver specifically
because it can use an arbitrary number of these areas (though they are
currently limited to 4).

Patch 7 adds some infrastructure for DMA heap implementations to provide
information through debugfs.

The Tegra VPR implementation is added in patch 8. See its commit message
for more details about the specifics of this implementation.

Finally, patches 9-11 add the VPR placeholder node on Tegra234 and
Tegra264 and hook it up to the host1x node so that it can make use of
this region.

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
Chun Ng (1):
      arm64/mm: Add set_memory_device() and set_memory_normal()

Thierry Reding (10):
      dt-bindings: reserved-memory: Document Tegra VPR
      dt-bindings: display: tegra: Document memory regions
      dt-bindings: gpu: host1x: Document memory-regions for NVDEC
      bitmap: Add bitmap_allocate() function
      mm/cma: Allow dynamically creating CMA areas
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
 .../nvidia,tegra-video-protection-region.yaml      |   76 ++
 arch/arm/mm/dma-mapping.c                          |    2 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   45 +
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |   33 +
 arch/arm64/include/asm/set_memory.h                |    2 +
 arch/arm64/mm/pageattr.c                           |   16 +
 arch/s390/mm/init.c                                |    2 +-
 drivers/dma-buf/dma-heap.c                         |   56 +
 drivers/dma-buf/heaps/Kconfig                      |    7 +
 drivers/dma-buf/heaps/Makefile                     |    1 +
 drivers/dma-buf/heaps/tegra-vpr.c                  | 1242 ++++++++++++++++++++
 include/linux/bitmap.h                             |   25 +-
 include/linux/cma.h                                |    8 +-
 include/linux/dma-heap.h                           |    2 +
 include/linux/set_memory.h                         |   11 +
 include/trace/events/tegra_vpr.h                   |   57 +
 kernel/dma/contiguous.c                            |    2 +-
 mm/cma.c                                           |  187 ++-
 mm/cma.h                                           |    5 +-
 24 files changed, 1775 insertions(+), 47 deletions(-)
---
base-commit: 703daa6d046136affd69f2a2e08f36ac4a7d5b2c
change-id: 20260507-tegra-vpr-cd4bc2509c4c

Best regards,
--  
Thierry Reding <treding@nvidia.com>


