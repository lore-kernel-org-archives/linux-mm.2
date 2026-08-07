Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33268C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2026B008A; Fri,  7 Aug 2026 11:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192D76B0092; Fri,  7 Aug 2026 11:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05AE56B0093; Fri,  7 Aug 2026 11:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C02426B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:54:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 365ADA2007
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:53 +0000 (UTC)
X-FDA: 85074921666.01.455DE79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CF5580008
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFetetgo;
	spf=pass (imf30.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118091;
	b=7W0wFTOnBqLZz/WYI/CqPCyLBO5J/H7+5OpaeKhRBe3g52lWIaLWKVSAnxMwkzogyjyJ85
	a1m1mpxbqxYBdqlSGekZY71eDHJvNktMLYtg3/cyAtzxbv/BcprTfCGoutdK0w1K1pRHBb
	fzTQJWGtPv+qcyvfqh+yH0SpThQ9s4k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFetetgo;
	spf=pass (imf30.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xDlurFDxUaKm0+DeKwG11I5Asqll1HaQOs3bWTM7T2A=;
	b=UygMuR/b05CBOn1Hr+d8b7m2ZlmDWN1Fhl89Vw55WIjRPhmYBcupZuYpukcKsndWOVFEWb
	JFJQX/cDWd1uwXgMNMh2V3qIGjeMDXymI5fBRhq2XcbZ/zSVdkoTPZ9+JY8N6XpFOfz83V
	tlGCgqOGQiSyrjQaCgXOwPLVOftQiAE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BA4742000;
	Fri,  7 Aug 2026 15:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E8D1F000E9;
	Fri,  7 Aug 2026 15:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118090;
	bh=xDlurFDxUaKm0+DeKwG11I5Asqll1HaQOs3bWTM7T2A=;
	h=From:Subject:Date:To:Cc;
	b=RFetetgo7jgxk2hRoVBNP2thvqE1EPEabTG4g4lH092YzQbD/Odq965rNejDzleVE
	 J3ckOBjT8nkXZ3wNy9Nx4RPTK6m+askAC7z4QSWoQpfG4MxebffJpKPmv69UDX+6OL
	 iEVDLsrFQqAMjC3zb8GatM7NAYAeBLlhnRtZ8Mcce5gdM7SrXJqHkgyYk7Or7MAkVf
	 1v73+4+H/NMIykEPIocARawL6LBt2xLJEDW2wFY+w7Ljr85NJJJx0OjEEz4tm8uqs7
	 VRYlNv+S0gcff4TM8qKclQrd/ETGd8YPtZJh6hMl1H2rsh9+vs6QAXsneltbsqhXC2
	 1o0k2EvBe+C8g==
From: Thierry Reding <thierry.reding@kernel.org>
Subject: [PATCH v4 00/10] dma-buf: heaps: Add support for Tegra VPR
Date: Fri, 07 Aug 2026 17:54:20 +0200
Message-Id: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/2WPwWrDMBBEfyXoXImVLNtyTvmP0oMtb+RtEzmsX
 NEQ/O+1YkoLPQ7Me8M8REImTOJ4eAjGTInmuAX7chB+6mNASeOWhQHTQA2tXDBwL/ONpR/t4E0
 NnbdebP0b45m+nq7Xtz2nz+Ed/VIEpTFRWma+P8eyLr3i3QxgdG2bCpSFynTOSi2XiZD5rhhHi
 uEUrj1dlJ+voqiz+YEb0MboRgN0qnJN7Zz7D38gR7yomcNOV790C/rPpVxJkKODczu4Vg+DPcV
 MI/X78Lqu36G64F8wAQAA
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
 Chun Ng <chunn@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4495; i=treding@nvidia.com;
 h=from:subject:message-id; bh=cNpFkM+ZcxbrYyXoZiVbDg/M+vrbqp/SW9+T2kNjvg8=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/COeJXZyRFVSTKd7+3r7oFtNF7xrGETRn4j
 DEXKT18h/KJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/wgAKCRDdI6zXfz6z
 oX86EACf3u52ZHWbNE0gzPHk1VCKvHipIKLbzawEbY/eyFL+F3hj0f1oRk5u22tUVgR+XqqdgdU
 gwYJjdIxng+xk3RWveQ2oBaMIzwMJwiykwHMNXFjTMWO7RYuWiz8hLNjGRNX/h6RZRGUa7rSqpc
 ODAcuSqcvfgjqo//n+HcYlrTTme0RgMivbMPVwq/G7KLmDX/7m9mryCILkoR90jXSg0Ha1q8HLM
 DxVa1dmvxpWECDYJU/uizu1XpnO9zKnxwMgHpyNwRTaajqkRB0AOGV1CbZ9mYSFbu1bp5IKwk7e
 SwqEJxq9caikk5y6VUtj3udpbhhJkLqmgyQ1iRROgJ4Jdb0YGfmaMfcI7gpMADo9riMISSZ7BPb
 KBLw3THjD8cjbJl9FeEgiiSWvZce1TCAZEfduXqjJNI9lLl1gpIz2Zz7JyN9gcDPYyjetrj3bFP
 gOOJKTnB7mY4la1dVjl1x5RLq36hdfJhFvabG6qYclCsmQFgU17Oh/nbgiQtV/5S1wQgX5h4KJa
 TiAbSxXHoiN+eL+PJL+Rx5bz5TEcblTUMPK+ub7afb3I9XHkM65Yaj/dE8ZVfmeviLNuhQktuAf
 WXcrW3LRRxZH1TZWTSGjJwaUEcgrGaBx3zUoiECwB7n/9GpOfYfGp4P0FwZ4bqQ9EiWbyjmX1dC
 fksdo8Ciavc0KLw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 6CF5580008
X-Stat-Signature: bnxqzqepfju3kpz4q9heg8x4ayf98j3q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786118091-55637
X-HE-Meta: U2FsdGVkX195XlWi97n5vso+rez43ACQRvKYrxqDC7OXZHDW0fk5MDH/weGm2trJj6dWmCxLiR0NM3+lbnHaIDupEtEiJPyM7GaViLE3fDplK8kCuC4KQZIaskOpJW06bT5SmxQ2JeQZYzeoXNVi5lCAKEHJWK6YmHixc5dt//RV6/3xdDGQFIAhBZfO1J5fsKFQ5rqeO2gQ6vqJDCGB3lihCS5wuhIHg51fGOiIf1ku8q4ooVZgOgGzSBjsElptsJRFvnlxsoYpIMDAXFMEHUm33igGLkdxl7GCa62PioI4G1Bc0XfHg4Ee4/Nj1j3iIHT9oR7MsFzdCg3HlaqqX9+Ic985ASPuZBinaGsSBkVLTDv8yBpYMn/Fewsv44Fdqw/WdSq6qne/8D0jekcrfuC/lN+BZHnwLpyfmJUyOUckQPTskhfWpvjHShXgSa8rsJYq/bL56T7z0kavRloJPb0GDdgf28smVrFs9JJgz6F+vH7mx6k3p/sybrQ+Ok5rV5+eg5gf0or6QNJnbLAwCJz+seSE1eWUEwMXl7qimJr/tn/g8bcpbjdfUPzvuDR3pbmiwbhOAia5hzKprexK8ubdA4RIKR83UcqqMCow2NezoPKLApciF/TwI0zvxwqMoQQtT/8+Trx/gTi4mE3C/j1uIG7740ed5WdEVJupFr3x7Exbx9ZSaM1tQGWYIIgWb3TpYX3EMzCcd+FceXVpTn8e4lWU66OdQk1AiwYg3e6sea7c3RPzyZYgNPTGMpIu70BxiubkvfhU+RRsttWsQISn19cJIVmRPFuSu5IAR1Wr3CAqWsikLD9Ob7It/r4vjTVztHuBcvAZhkn/zsayTtTQPLJ5XYF5gb+fwsIWEEyjONHLb6CT81bzaa4mZWjym8vjac14/taEdaZPPzLa+zYMQ95DQUBGfOzsDNk2kTN3AZK/T022E6n6xr4960h4gyft/LobSClAIAshdyM
 7llpe7Zu
 /xKm8MCteOBSU9huqkp38f6SN7mJRsQOlA0Pp3s3xhpPdSh2q0a28cx0XLHhAsKQhpUZ9gSFFpCh3Xqio11rpasnaRh2JW/8BK99QTnZjrBPANXHhr8aqRmdAK7sZkx1WC9Bvr0lUCKOrZCTCTKFGtS5uX6ZJrd2JM/XOFGXBDfWNAPRE4hM9LWc4zheemm2xDH8Y/6DHnLz9+3wc2nMVU2EXC8KdtUgPdEZ3Oy0PCsxKFf3+1HtBkzPCfqVJpsO7d3qTNe2UBIeA4qgDm5aYe51Rqgz3/9FMscbQpAhDPfm0/tzhUmCGATscr9/TD3Bqi9+YiVd6vrPzWEDVUS6feMIYhIJQ7U9mLsdrqYCmKJezXSyVpkHv6CXgOz8oGRSzpgriMmzk7ZQDnVo7lY+OCXQ0EBJU2R4ZKvdJcVSyF3UqB+ZqBxpQqeaexYQcabyjrWJz
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

Patch 4 adds bitmap_allocate(), which is like bitmap_allocate_region()
but works on sizes that are not a power of two.

Patch 5 introduces new APIs needed by the Tegra VPR implementation that
allow CMA areas to be dynamically created at runtime rather than using
the fixed, system-wide list. This is used in this driver specifically
because it can use an arbitrary number of these areas (though they are
currently limited to 4).

Patch 6 adds some infrastructure for DMA heap implementations to provide
information through debugfs.

The Tegra VPR implementation is added in patch 7. See its commit message
for more details about the specifics of this implementation.

Finally, patches 8-10 add the VPR placeholder node on Tegra234 and
Tegra264 and hook it up to the host1x node so that it can make use of
this region.

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
 .../nvidia,tegra-video-protection-region.yaml      |   75 ++
 arch/arm/mm/dma-mapping.c                          |    2 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi           |   45 +
 arch/arm64/boot/dts/nvidia/tegra264.dtsi           |   33 +
 arch/s390/mm/init.c                                |    2 +-
 drivers/dma-buf/dma-heap.c                         |   56 +
 drivers/dma-buf/heaps/Kconfig                      |   12 +
 drivers/dma-buf/heaps/Makefile                     |    1 +
 drivers/dma-buf/heaps/tegra-vpr.c                  | 1368 ++++++++++++++++++++
 include/linux/bitmap.h                             |   25 +-
 include/linux/cma.h                                |    8 +-
 include/linux/dma-heap.h                           |    2 +
 include/trace/events/tegra_vpr.h                   |   57 +
 kernel/dma/contiguous.c                            |    2 +-
 mm/cma.c                                           |  221 +++-
 mm/cma.h                                           |    5 +-
 mm/cma_debug.c                                     |    6 +-
 mm/cma_sysfs.c                                     |    6 +-
 mm/mm_init.c                                       |    4 +-
 24 files changed, 1912 insertions(+), 61 deletions(-)
---
base-commit: a6cebf4799ccfd3ea08e45abe5360414fd3822e1
change-id: 20260507-tegra-vpr-cd4bc2509c4c

Best regards,
--  
Thierry Reding <treding@nvidia.com>


