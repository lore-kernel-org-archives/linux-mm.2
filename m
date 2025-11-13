Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0691CCD8C9D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669318E0011; Thu, 13 Nov 2025 12:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A188E0002; Thu, 13 Nov 2025 12:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556FF8E0011; Thu, 13 Nov 2025 12:00:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45A5B8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E35B5C0AC7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:14 +0000 (UTC)
X-FDA: 84106196748.12.47970F5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2159B40009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=b5XUcaiU;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rjTIGg/oYVs9g9qfZypsDKb2niBZEdrRiYtUnVlCfLc=;
	b=YQAQmmAdFEG3ty6+JA2q/HjeJPeL4ehqD29FtqMjvNb+1FEXpImU66L9fLKkfKjYiFpRTp
	4FrshMQxM4Za5dHK82KnHtLkYJ262xms+OQsyjqzAVePbxfZIR5Ysi0JhRdbUpCz6yAbwY
	4HGoDk9UAbGxp/W2ekzpwp7vDMyQ+54=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=b5XUcaiU;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053213; a=rsa-sha256;
	cv=none;
	b=dNd5QnuTCcbY8G0dC8SV+lDtzls7Dywg7gl4cFsa0I0hfPtEllDHPB5Hoe+tQF1L4pBme0
	5u6YH6+J7tAmIjNjE8uPTcvc6GwsGnzxN4KaBG2kr9tMqivVb+STlYEsvZ3TuQ4kEx7d7H
	1GerDEv704moI6oToBJOQCSoFi5aKJI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053210;
	bh=wAWxUKehyoOSa5G7CZaC6M8sHVmNdvpdgkHlsv1J4NY=;
	h=From:To:Cc:Subject:Date:From;
	b=b5XUcaiU6Ci5XccBPU968ve8pP6Zxzj6YhRYnx6GmARRnPdFX9fX++w7CvVxpJqi0
	 fLExxJ0l3Y6AON0qgSYTAdS3UAo6d1rni2UgZuiwmJbSNOc2Jx94UmIj+3sDJRuYDt
	 XzgeiiEYFqIH/hlKE26bDuOF5/tXVh7Ttm3xzuvDdqWTz7yzEr0TlEfzqJKsO4DyTl
	 eYaLbnMMh815MYGaiCCQhRboaiLwo5m2kqeCf55dxjhZmXTrKxS2QP5RulU85EgXqE
	 4gBhYzYgEmPoK7Yu49ZqgfO2d8MMx6xIvxxKBswF8R2gvWTUk8Rt/zW9mm6un2Qj6p
	 qXBqUvvZ9R8QQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 04B8F17E00B0;
	Thu, 13 Nov 2025 18:00:09 +0100 (CET)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v8 00/11] drm: Reduce page tables overhead with THP
Date: Thu, 13 Nov 2025 17:59:56 +0100
Message-ID: <20251113170008.79587-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2159B40009
X-Stat-Signature: uokhhzyhp1azm68pi43ujazycrqsppse
X-Rspam-User: 
X-HE-Tag: 1763053212-64842
X-HE-Meta: U2FsdGVkX199zu8++6V9aLqyteu8ylWZa9ChfPv2Fs4L3u5F9reX8J1cVp+SpmbexLK0QwtsaEWd3SpvUdIf5pchZ+Mt9c3EH4lUAiLFCuddGogjNgjDF41JT3fl4ldlat+9pMaA/EW+kwJ6LHix4lKt02G5eQeSwZmgvc9k+hDfvmznAOuoID83w6GZ0PMJyzSTdLjxQbwMIa01cgWZPbtdnxHQ8uNKyTELegK83kgqCFj0XshwHVJ5M3bZ2CKDPH5ANyaDhwoiOpUEkhx1VEsEI1hn2+0EZkDyk3mNyZTghJ8zdRiJWWveSXwnceKL/zrCERUhyj8N7mroHsS8bIsFZGfwP864lL0rfOHEFQDUydF3E+y3dN+R4RT/RCPSHuE3znHmv7A3w4mcEsfWjCXuCrIURsnByfLlfiZQnCmYm82cLw8jP4mgKGy8Poju6iwH6NV2M3jhjuYszS3xD7qXbBWvpe32R7XblVG6H1K1EKVRkqc2HDSXRp8FerR8PCR5gxc5zZMdQ/9r+szOs/Cq3YjvkxaonASTWKR4Y7+D+q0Sb/64ENZdKFlGH4FPhnibOiSJgqWrVwXncLEE5j0zAunfTxCQ9CUh/qGxUsWAh1Ok7H1g4VZ5vIMWVIVIXEHYf0EnHvxvGzJOEtBUQKnb9g2PfQeN/OC7mE9KG/wv4m+vK1VPy4EMy34zEEMI7Xx3t31oRKzlQ3MmxMAP1F1Ti02WIpf5bOYKpfeE8NuNjvad7fNxkigaG7qndX9+4Ikt70q+mbggiSmD3hWWEJCGfcftL2n3UJSYRNg8y2Z0csD/OkPIpIMxhIN5PFU0v/CCodQeFzisOjoQGPSK3SiWOOpwqGlTDGnzDdd+3Z7sUVcKLMVGimfz6Y35Up09xoGSCIcLBUxRowiF3ocAeWAJiGTTehvLMnPCZg/0soTXOADdGJcv4rRVKOmUM3gPbEi3e6BCKoBS2ZYdSqS
 tdACvZ0W
 7jv7R5/M6istxwY7/WE5AIGEu9rJVlEtEWCy/N0BjDb35cxljcNRBFoqiath1+0C3AoWF3MycQevsNlc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series aims to reduce the page tables overhead of DRM drivers for
builds with CONFIG_TRANSPARENT_HUGEPAGE enabled and either the sysfs
knob '/sys/kernel/mm/transparent_hugepage/shmem_enabled' appropriately
set or drivers using a dedicated huge tmpfs mount point.

It starts by checking whether a faulty address in the page fault
handler is part of a huge page in order to attempt a PMD sized PFN
insertion into the VMA. It then introduces a dedicated
get_unmapped_area file operation on the DRM file descriptor for GEM
objects to get the best virtual address alignment for the underlying
shmem buffers.

The remaining commits propose shmem helpers to create and release huge
tmpfs mount points and adapt the i915 and V3D drivers. The helpers are
then used to optionally enable Transparent Hugepage for Panfrost and
Panthor.

For Panthor on a Rock 5B, this series makes the first memcpy() to an
entire BO object mapped in userspace about twice as fast with
Transparent Hugepage enabled.

Implementing a fault-around handler using the arm64 contiguous page
hint (contptes) could also greatly help reduce page tables overhead
for small pages by mapping several contiguous pages around a faulty
address at once. This will be proposed in another patch series.

Loïc Molinari (11):
  drm/shmem-helper: Simplify page offset calculation in fault handler
  drm/shmem-helper: Map huge pages in fault handler
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/gem: Add huge tmpfs mountpoint helpers
  drm/i915: Use huge tmpfs mountpoint helpers
  drm/v3d: Use huge tmpfs mountpoint helpers
  drm/gem: Get rid of *_with_mnt helpers
  drm/panthor: Introduce huge tmpfs mountpoint option
  drm/panthor: Improve IOMMU map/unmap debugging logs
  drm/panfrost: Introduce huge tmpfs mountpoint option
  Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

 Documentation/gpu/drm-mm.rst                  |  22 +-
 drivers/gpu/drm/drm_gem.c                     | 203 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  97 +++++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  51 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  71 ------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  17 +-
 drivers/gpu/drm/i915/i915_drv.h               |   5 -
 drivers/gpu/drm/panfrost/panfrost_device.c    |   3 +
 drivers/gpu/drm/panfrost/panfrost_drv.c       |   6 +
 drivers/gpu/drm/panfrost/panfrost_drv.h       |   9 +
 drivers/gpu/drm/panfrost/panfrost_gem.c       |  18 ++
 drivers/gpu/drm/panfrost/panfrost_gem.h       |   2 +
 drivers/gpu/drm/panthor/panthor_device.c      |   3 +
 drivers/gpu/drm/panthor/panthor_drv.c         |   7 +
 drivers/gpu/drm/panthor/panthor_drv.h         |   9 +
 drivers/gpu/drm/panthor/panthor_gem.c         |  18 ++
 drivers/gpu/drm/panthor/panthor_gem.h         |   2 +
 drivers/gpu/drm/panthor/panthor_mmu.c         |  19 +-
 drivers/gpu/drm/v3d/Makefile                  |   3 +-
 drivers/gpu/drm/v3d/v3d_bo.c                  |   6 +-
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.h                 |  11 +-
 drivers/gpu/drm/v3d/v3d_gem.c                 |  27 ++-
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  62 ------
 include/drm/drm_device.h                      |  15 ++
 include/drm/drm_gem.h                         |  40 +++-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 29 files changed, 452 insertions(+), 296 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


