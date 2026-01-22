Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E03D3EE8B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27D966B0273; Thu, 22 Jan 2026 11:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244266B0282; Thu, 22 Jan 2026 11:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185E76B0285; Thu, 22 Jan 2026 11:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0592C6B0273
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B42661403BF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:18 +0000 (UTC)
X-FDA: 84360086916.06.C5411D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10DAEA0020
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxw0zSYC;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u10j6GV0P/m65kgOHElTqjDhK+nT/v6T7o/RCiR/9Uo=;
	b=oyMsCUHNQppWtZOV50N4jkYw1jmObgl7Ph4ZbrWF99u8W/1lTeh+AC5x8HTQ+jFZbzgxxt
	WGfHiFRlD6/ssUblEDVlqgEBb9kvSvUs8qlfCPsOgXiBSsLtFzfCCfWLfYJPur/DXqTTvo
	FtWbnxcZJZHQ9Q+r7mWi5800femU3lU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gxw0zSYC;
	spf=pass (imf25.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098217; a=rsa-sha256;
	cv=none;
	b=vpeZGuY5Vn/RQ0rxEbC6S/FTn7xBVFJYslOnqod5F9lQx+XxKDuN/i+UlJVUtBft7ou9PH
	Vaxa0M7isZ+JrPv+gAjoOcVNVy2dBpROLgJ0P3uyxOU0ZKYINfiq9aPLo7dtJJ7grh5Wfr
	foPiLbM2Loj/ZtgwxP3K8yJFlTeUYmE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AF6B600C4;
	Thu, 22 Jan 2026 16:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95341C116C6;
	Thu, 22 Jan 2026 16:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098216;
	bh=ha3JA4N/2sbTZoLLt9Hk+/O5tkj/IAzHDfElKjAoOuU=;
	h=From:To:Cc:Subject:Date:From;
	b=gxw0zSYCXNJ4FcqwQQa7I3h3D2XukR/5aI8fAthL9DSmSmnm5KNPPfNGJ1op1BP4Y
	 MQ8cVwzVPjLYouTp/7uYsWSzL1ur0vhAi8L6FpMUXjN04ub6UPMiSU3ZiH+XtPFwfk
	 VDdZWO7EoWXGrXVNri26ANlTn29LcOna1OgwmoqrgPHF2Z+DlEJR1wAkHWsZ6kesJv
	 qbLK+3OIqfHgL9efAc72qE3r7O1STboGXJlBPqou0qcXN6QKZkFhWF6pvcrQDPFrx/
	 MqiNydzq8TzcExsRUkFNe+MEx6i7Rghos0E8UwfsefR6oollk4PXYz9/GzaS+tOntT
	 OxAMHTZ4pQ6Hg==
From: Thierry Reding <thierry.reding@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH v2 00/10] dma-bug: heaps: Add Tegra VPR support
Date: Thu, 22 Jan 2026 17:09:59 +0100
Message-ID: <20260122161009.3865888-1-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6qxudzwr84wcctycdbtcehn6p1u5gnn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10DAEA0020
X-HE-Tag: 1769098216-445117
X-HE-Meta: U2FsdGVkX1/cyM3/h6xp6vwvUNwtYHrn537bn1VokRZNzQBotbgcEQO4YU0dYPtTkpgjIJqW8p2+pK1i1+ipS4G/6sXUGuVow6y2nvkQxnNYYH8KE4vcekEZG5VNdUsDRBxsLqf8NrGKmYdoM5IkQUwR7yG9jN8ZNlyE0ui93GbO4go3t7GroUuK0VvAKtyuBTyydj+itrzKER95AdhXlChFHn5Uu7B0R8V9T43nv/o6M1GxyuY2wHLmn9Ib9MacQRGis6n8dxlwINVQdf/xYM2YRAQ0SHHJoSvnOsL7EEojSnM0MreOGLACgpIKRVgz+usrtjcsLAkoA5PKmwdo0Hj+yc2n4FylKeEOyLhcZQ1zdPz5dQO2nD8BtfEnMnDw4oHYLcy+wnIen2DOduAj5BmoXcgN044jBb4jpDcTAQ3zvaX2BuQd5+pCqVzxp8nehSmRB72mdv5Jhf5R3J36SisVwALMzKfb4o5jHPYYTAqvoJjxRF/cdgfAGO3MQs50oJMhn4SuMRMRpqONm38o328G5OzZt1Y3lnt4s+ONp2KCckcAg88pz48RzujSkMB1BJtGnSVerAyog2C9e55OPeRDRdpZeVAg5P6xYfnQBFuxGy6xkcBwxGkBzRKNdqXKCJWcFObUMqp8HPOcPx94TEdX59jxxnhRVdZ/vuH/03EfKC/kdzwNtDL42dNNjphJQ8OI9VnCCRV0VRRpBZxRIYHIDMAyxUXFamH8zZpSXdLOFfhI4GchWmaNdWZ4CsoFDGXJDINjn3eUbXSJtcdpSIt7uQF5LSquvG3G0hKtQ+VDUhevMyovunDvv+YtLNXQsXWjex16ISbS9Iw8RX323o2NxCC0CpPi77ZSvuVEIWypAxUXSSQJmBD7Id97vH5jF7olQiawauMiBI0vwmrc950+2zV62/NXk9L4qxE9z5hufq1QD9RCcZktlAQuCU7y9bJjw2Ai7wu8T+LbEVh
 b4nJbWPt
 ORN6w9o16/TzmQ8yvzWNp5xDZmIyvqkd3v1tR3d6tkZ/6q449+90Aq4eb4lAn0fJsSG/rM/DC7M9RtRpOOdV1+ywWD9MB9RjcFHuTxbT32r9odz0YlUCjmeMfYlsg3qcgvu3GXO8S2CbroLQf4SbnUpQTW2Z6tjfaHq2v+LVpKEPaZlVj6EHZWLaPcfXU8lpcGBe03OtAy/uZlxdyATMBuQRwlfUYsCs69PK0P31qAeCpDZFFZO294ok+YSvJEmHPfhL9uXhiyY4aLImHIvNeaSTB7Nh5LoJIWQ5EWMBOohMvkNAyrLDgwcbxoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Hi,

This series adds support for the video protection region (VPR) used on
Tegra SoC devices. It's a special region of memory that is protected
from accesses by the CPU and used to store DRM protected content (both
decrypted stream data as well as decoded video frames).

Patches 1 and 2 add DT binding documentation for the VPR and add the VPR
to the list of memory-region items for display and host1x.

Patch 3 adds bitmap_allocate(), which is like bitmap_allocate_region()
but works on sizes that are not a power of two.

Patch 4 introduces new APIs needed by the Tegra VPR implementation that
allow CMA areas to be dynamically created at runtime rather than using
the fixed, system-wide list. This is used in this driver specifically
because it can use an arbitrary number of these areas (though they are
currently limited to 4).

Patch 5 adds some infrastructure for DMA heap implementations to provide
information through debugfs.

The Tegra VPR implementation is added in patch 6. See its commit message
for more details about the specifics of this implementation.

Finally, patches 7-10 add the VPR placeholder node on Tegra234 and hook
it up to the host1x and GPU nodes so that they can make use of this
region.

Changes in v2:
- Tegra VPR implementation is now more optimized to reduce the number of
  (very slow) resize operations, and allows cross-chunk allocations
- dynamic CMA areas are now trackd separately from static ones, but the
  global number of CMA pages accounts for all areas

Thierry

Thierry Reding (10):
  dt-bindings: reserved-memory: Document Tegra VPR
  dt-bindings: display: tegra: Document memory regions
  bitmap: Add bitmap_allocate() function
  mm/cma: Allow dynamically creating CMA areas
  dma-buf: heaps: Add debugfs support
  dma-buf: heaps: Add support for Tegra VPR
  arm64: tegra: Add VPR placeholder node on Tegra234
  arm64: tegra: Add GPU node on Tegra234
  arm64: tegra: Hook up VPR to host1x
  arm64: tegra: Hook up VPR to the GPU

 .../display/tegra/nvidia,tegra186-dc.yaml     |   10 +
 .../display/tegra/nvidia,tegra20-dc.yaml      |   10 +-
 .../display/tegra/nvidia,tegra20-host1x.yaml  |    7 +
 .../nvidia,tegra-video-protection-region.yaml |   55 +
 arch/arm/mm/dma-mapping.c                     |    2 +-
 arch/arm64/boot/dts/nvidia/tegra234.dtsi      |   60 +
 arch/s390/mm/init.c                           |    2 +-
 drivers/dma-buf/dma-heap.c                    |   56 +
 drivers/dma-buf/heaps/Kconfig                 |    7 +
 drivers/dma-buf/heaps/Makefile                |    1 +
 drivers/dma-buf/heaps/cma_heap.c              |    2 +-
 drivers/dma-buf/heaps/tegra-vpr.c             | 1265 +++++++++++++++++
 include/linux/bitmap.h                        |   25 +-
 include/linux/cma.h                           |    7 +-
 include/linux/dma-heap.h                      |    2 +
 include/trace/events/tegra_vpr.h              |   57 +
 mm/cma.c                                      |  187 ++-
 mm/cma.h                                      |    5 +-
 18 files changed, 1713 insertions(+), 47 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
 create mode 100644 drivers/dma-buf/heaps/tegra-vpr.c
 create mode 100644 include/trace/events/tegra_vpr.h

-- 
2.52.0


