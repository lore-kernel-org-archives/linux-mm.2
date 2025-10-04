Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 228EDCAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5E88E000A; Sat,  4 Oct 2025 05:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD068E0002; Sat,  4 Oct 2025 05:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2AC8E000A; Sat,  4 Oct 2025 05:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 592878E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F6CBAB1A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:03 +0000 (UTC)
X-FDA: 83959912806.03.D3CC905
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 14F4CA0008
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=B92Qmfz2;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rpi5lHhUj5ENS7PRhqBkdqlJryExH8uNjR/9diBnvCA=;
	b=oMC2mQiWEL2EzsdOjLw8rkU+V8+anoDeYjREoABIryzJKt7L1ayNSqjVv3p3NhTZbJ0Nq2
	CiIfZBQ46dTLevAo96hoJfrHNTw5j1qK/iNRYMKGLxi1SX4Wo9k01TXYxU24PleoJaTGK7
	ahD8VNAP+NqxnYQECCWN9P9l14s1J0Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=B92Qmfz2;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570262; a=rsa-sha256;
	cv=none;
	b=4NKk4ffBfnXGmO8VPs4B43erQ8stmoKfs3ZdIP5Qb0tY/sbqUUfh6AHyMOrIctRAWHwtGf
	mTjllTOuEtgUFKzMSMLYpvMxk9AJbI4VMQkxw/TR6S2utroVYQq1l1V5Rh4c5CsUBc6lsY
	80IFGWFNKbL9c5jEi54i4cY3oPVXhb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570259;
	bh=Zyw08bkZU/RFYvECKvHpLAFO6ylayKQuE2OJk52VPYk=;
	h=From:To:Cc:Subject:Date:From;
	b=B92Qmfz2VEGT/TPbfUoV4sbwP3GI/HZAc8B4wnjS04PfteyS3k6L7N6vVvHFFbo/y
	 fkiZJnat2/pOTLzkItB8GsGhoU/pJvHPHuLLF8/YOKbec9EZUgTvbRuKI8/VvgeTZ/
	 9BYFVDuBSCCcfLH1Mt6Iy0B/KiEHhXAXb9IA2WTCjFFHeGsZec/qn5HH8c1DVySQ9G
	 dCZh+0BkMUakVbOTww4H6rFfXBTbGZ+vmHmMrvT1HlEHTxskKXGlitl6fOQOeVr9Y4
	 2BmIATH6Z9FIHx0nJoX92FAMYp9/JHHic10icyUjk4yYnDG2CyUwcTw0nr0GKg87Fc
	 BBuTp6pGe3y0A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id AB0AC17E07EE;
	Sat,  4 Oct 2025 11:30:58 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 00/10] drm: Reduce page tables overhead with THP
Date: Sat,  4 Oct 2025 11:30:43 +0200
Message-ID: <20251004093054.21388-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14F4CA0008
X-Rspamd-Server: rspam05
X-Stat-Signature: psuc1xe4fic3zf7oe41edoiwsyr8zbfr
X-Rspam-User: 
X-HE-Tag: 1759570261-782938
X-HE-Meta: U2FsdGVkX1/qWFQ8fbhp9Lm+iLClgv6QYc/5OzKTX/Ny5KJaYuRN/Lm8WNPnjjJYn2G1DKxBvV144xLSSBEcovNw75DKowqoAyMJ5cDz2yAE7o14tV2UmGvs8NagiJmq4zFHZGWOASdzhCDM4r4v43f7J1LJQG2SOKH8u7iJ9BT4DlqlYt1Na3mgPoxuhCFHRGd79zli0W2E5UZtROGqNIe0gt0e/zML/M/zh3eBnaNqfc4zyj8uBmJ2qS1CJgNIhXM25XV3yGoR6JanuBHnvxerF24mikZZq2VO+beqsvWLcmJo3hxq8LyNqsAyDipbnBzGQrR2xCKD6c6QpisdXFdGq/DASEhCyT2EOPSKKJGIe/jH5pmndQpIsQCCX1O0itDznNgEp8FZaoN2WgIfA/OKuxZJEWq6XupD2Rn6C75h1a8due4K949f6nX6RhBsITCuGNPyy+KzXowDAP0wv/oMfCSykas8AFQ5DsqBVss1dsUNPgw/w7n0jaZVdBsoC6aUGAbAbNN41Dm8raBixHsdyxml0QC2yQ2hZfv7o7mzl2+HSvJ9O66JLgkicryj1id9kXEaQAeKoPR60UXsZr4l7Mozt5yIjevUX3teGQ8F7pPGuFL9FV0mEpF6myVh5PCP5zd3/ekeVo8dakdyaj7O32oq1/d621pFnlKWcufP4Akp7u31JjMqXTgN8uRs3mqVTt4FQwfRd5khd8x7yi9e0xIa5zokF11HZndX3GTyI5ERXu/sB6bSiPKq7poWakT0ZrgwRwPkPcWxBuSjCo/tzAG6yvrnS6a9apBxuiUCDDyRvf2+i/T0cUsjIw6y2WL8emBnx57/r77LNxuVGBm9ldCOxGyW6TP/eWUobgTjcvR6dXhaLYOYnLiJOk97Wb0xhcV4W1igUl0JGbkh50g9vKFChoaTfGU0V94J9pG9BO60fTScLAkyLHKLo+WdkICGsN+rBf4a965rWM7
 g1JZJsvT
 cy/1GlIzqPt2vI2G93h6+Ma43X3QRPP6UbuPy4GVD/HqIjpN5Nlw7p3LVCp5P7PVzb48DHAKj0GL6U/cfn/etUdXzbDctYbcz/zCojOt4qUnDhHQX5CNh7BJNRehebSPrhsteJ7RSsb5OBTuey0Hr2m6VcYQ/H6UCmJQFl8BGDrkJoOqNHbBRxLq1oSGqa+9qNbhRv+UuquSZYWzTYeTB7MFv7QjbQXx7pheqpJgvslA8IAEWnoJt5fVnyxhBywKibHvrsWIbJg6SZTkiL9QoKwbF4H7uKJEiwqjV+fq41aDJxO2X5OYQQVl/4cv1GfIVwIup0pvCqE4VYP0=
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

It starts by adding a huge page fault handler for GEM objects to
insert PMD or PUD mappings whenever the shmem backing store manages to
create huge folios. It then introduces a dedicated get_unmapped_area
file operation on the DRM file descriptor for GEM objects to get the
best virtual address alignment for the underlying shmem buffers.

The remaining commits propose shmem helpers to create and release huge
tmpfs mount points and adapt the i915 and V3D drivers. The helpers are
then used to optionally enable Transparent Hugepage for Panfrost and
Panthor.

For Panthor on a Rock 5B, this series makes the first memcpy() to an
entire BO object mapped in userspace about twice as fast with
Transparent Hugepage enabled.

Loïc Molinari (10):
  drm/shmem-helper: Add huge page fault handler
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/gem: Add huge tmpfs mount point helper
  drm/i915: Use huge tmpfs mount point helper
  drm/v3d: Use huge tmpfs mount point helper
  drm/gem: Get rid of *_with_mnt helpers
  drm/panthor: Introduce huge tmpfs mount point option
  drm/panthor: Improve IOMMU map/unmap debugging logs
  drm/panfrost: Introduce huge tmpfs mount point option
  Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

 Documentation/gpu/drm-mm.rst                  |  17 +-
 drivers/gpu/drm/drm_gem.c                     | 208 ++++++++++++++----
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  94 +++++---
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  52 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  74 -------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  10 +-
 drivers/gpu/drm/i915/i915_drv.h               |   5 -
 drivers/gpu/drm/panfrost/panfrost_device.c    |   3 +
 drivers/gpu/drm/panfrost/panfrost_drv.c       |   6 +
 drivers/gpu/drm/panfrost/panfrost_drv.h       |  11 +
 drivers/gpu/drm/panfrost/panfrost_gem.c       |  19 ++
 drivers/gpu/drm/panfrost/panfrost_gem.h       |   2 +
 drivers/gpu/drm/panthor/panthor_device.c      |   3 +
 drivers/gpu/drm/panthor/panthor_drv.c         |   7 +
 drivers/gpu/drm/panthor/panthor_drv.h         |  11 +
 drivers/gpu/drm/panthor/panthor_gem.c         |  19 ++
 drivers/gpu/drm/panthor/panthor_gem.h         |   2 +
 drivers/gpu/drm/panthor/panthor_mmu.c         |  19 +-
 drivers/gpu/drm/v3d/Makefile                  |   3 +-
 drivers/gpu/drm/v3d/v3d_bo.c                  |   6 +-
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.h                 |  11 +-
 drivers/gpu/drm/v3d/v3d_gem.c                 |  33 ++-
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  65 ------
 include/drm/drm_device.h                      |  11 +
 include/drm/drm_gem.h                         |   8 +-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 mm/shmem.c                                    |   1 +
 30 files changed, 431 insertions(+), 291 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


