Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3C5C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 19:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FAF96B00E4; Mon, 29 Jun 2026 15:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0C46B00E3; Mon, 29 Jun 2026 15:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44BDF6B00E3; Mon, 29 Jun 2026 15:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2C9A6B00E6
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:25:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 590981C1B74
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 19:25:59 +0000 (UTC)
X-FDA: 84933930438.16.179A583
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 27402C0007;
	Mon, 29 Jun 2026 19:25:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOjc9JyG;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782761157;
	b=1HxrwHcN4WaCOkitQo+h+jkVXG7sFgt0O+0Jja4r2Jz6DmAGw0K5r7LOUYJWaDyZRFLy3g
	yOV0tZyC2LV405hXapCl00TkabiMSpeQYehhXxz9eTJ2ODaJKsEnBCGcPrk+VWSnJuTeBa
	lzbfRf1ByfdF1wbOBTMcaAfVcqeK1kY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782761157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uYIw6aQ9I+77XwEcGZ5sLAkEEwuPzF6gubx9MILGtr0=;
	b=TsCEWBbR0kRrHbLGx9CM3yVgiFFb2SOJ+C6CWV9az1fgnS04BoncNwvv1Bt8+8IWxHiH5q
	uxUGAL62VQR7Jf6TBsSUtpCRGy/+7LsUqrLeBocVgfTo8LFjYaUDsB3OBuZEzYBuIro3/r
	POH190EfnNUygP0aSX57vF5si+Zzi+k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WOjc9JyG;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 723DC60008;
	Mon, 29 Jun 2026 19:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F6D1F000E9;
	Mon, 29 Jun 2026 19:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782761156;
	bh=uYIw6aQ9I+77XwEcGZ5sLAkEEwuPzF6gubx9MILGtr0=;
	h=From:To:Cc:Subject:Date;
	b=WOjc9JyG02UBcXhhgV9ic0phr0uZCFD5k0ILdv6ONhCv8Z1XYDxBYiwvpukl7K1Fg
	 a8aIrsAXippHTg2Wibb6tHWkzlE4E0fWXgBDrHzByOJL4F8jISF06sHckyYY+PF7tK
	 OiAiSmS9jz9wRn1oMBm18e5Uavo00IhgOxFuVQdHvJLDYYtq4uXlvS/eQXpk6KaIDD
	 GN3rVLuuxb69YleGJzixCH/hWeHWpFDPzoCr2KQROO1CK5H8VnjBM1FKT5hXUj42/o
	 WOenPbgoWzQyVU21Y69V/YrWJ0M+K8b+G7Zlo5u3zMESofU5MsPpKfLAYEn9kt+uGS
	 wlAF5pba2Dehg==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Lucas Stach <l.stach@pengutronix.de>,
	Inki Dae <inki.dae@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sandy Huang <hjc@rock-chips.com>,
	=?UTF-8?q?Heiko=20St=C3=BCbner?= <heiko@sntech.de>,
	Andy Yan <andy.yan@rock-chips.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
	Helge Deller <deller@gmx.de>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kees Cook <kees@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux-mips@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	dri-devel@lists.freedesktop.org,
	etnaviv@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-rockchip@lists.infradead.org,
	linux-tegra@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	xen-devel@lists.xenproject.org,
	linux-fbdev@vger.kernel.org,
	linux-aio@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sound@vger.kernel.org
Subject: [PATCH 00/13] convert more vm_flags_t users to vma_flags_t
Date: Mon, 29 Jun 2026 20:25:23 +0100
Message-ID: <cover.1782760670.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ke1wqyxffkoiqr6urff1ude13kja9kbw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 27402C0007
X-HE-Tag: 1782761156-732682
X-HE-Meta: U2FsdGVkX1+ieO7B02bMsoWUeLwgPyMwyolLgu8wAK+cb3SxGgNMeuPeO19RTibBywgKShCeiA7ghg49sBTgwBqp9Q9VQXsyM6kStULJigi55NAqlvtz3mcvdJ7OCjvnC0XI3SQ6BvoUOielSd7pxC2g/c79zhlFPKFA630TgBXv8fG7Aa9T0ec0DJlHU0cY7nCLEmVK0AH38xWNxPyH9DoyKa15WQBwm5pxYpu91IRJJb3RNSXIHwLHV3Uej/o0Gy50y75ZhuSGmPuUVFrQ5H86whzO30pRXMJhxjzIh50+scx6Asp3wYSCGVHR7kSG4fH9jb+YtZY3yZXSHZcru3zJ6SqGzyqLj6tm9s4qneJsyMwExSQw8DyNAodWEsEwTEVS/1La6YTZUmCR298zEFoTAS+YZcWfJQWD6N2Iu63MB3BLq1izKaqVCX7heXyp7PSeWltCmw+ssaTq/DNMdAZVUzAo5wXgWKDhjq4SBVFrA+StWjGyyUEs0GIspzVeO9PGPNS6ph66DhhE1MAAsabKoCR3BtW0cJLD3Bko7soGnHoG2jzIR8JGGrqnI6w1nh6+29hDFakCRRGCngX+ZVf3Hl3xp3w7+/ZxzaVJ4NBIH9RZi3uHs7lakP99GTOCN3YgK+xbPzY6z8cXXAfZYgonjOGylc80bTGbaUUaX+GKoqmkGVFE60rBChZlQKERTrmJmDAQ4LV4rRbgoR/ZrCI27/7ezeu/Tre9K13A7/JAVui9S4ZcjBO9SX1KXUAy6kcELkYx0NErMqnG0t7Elo5D5ju9Qfr4VjZiAWSDcE4T7dmWBK5XZmwWrBA4ISyHPoIY0kfwehregqvXpC/5ILQwQ099x7b3T8fYDTRD/hlWf0dhFhU5YaCkcdH++qLO4dKQIw7MThGzhx0w5o3pDgR0FKApXd8Iyli+RDv1fZ4OgHjQ+lwvw8s2PsedwP9cPtRKlrHL9JfJJrUOMZP
 5TY3oHnV
 cDhlYvbl4t0Wa/ZSkjK1AWmYlO6h3V/sA15ackOOZtZjWqvsysxK9JOcV7yxszPJRFaKbB/teDE5shnB79/XB/uzNd7lioYRL4CqiVwfcKd+yUzHMFSt8IwOM7E6xdy0oQfeq5LeS5zDOGUtt5eUMfo7m0SyVfxLo0GHgMH07UrAvh3JgSLB+s8FUBhLjdki7btVNnA5PqBo+mZW7jLLzVC5334+lBgY/d8ymbKQ5arffR9ENDz1o6G/DISZWDrB70mrTBtqRoNESkQ4ZvbFoMYZOoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series makes further progress in converting usage of the deprecated
vm_flags_t type to its replacement, vma_flags_t.

It focuses on mm, though updates some users of mm APIs also.

It updates:

* The core do_mmap() code path for VMA mapping.
* Unmapped area logic.
* The usage of mm->def_vma_flags.
* VMA page protection bit logic.
* General usage of VMA flags in core mm code, mlock, mprotect, mremap.


REVIEWER/MERGER NOTE: This is dependent on [0], which must be merged before
this.

[0]:https://lore.kernel.org/linux-mm/cover.1782735110.git.ljs@kernel.org/

Lorenzo Stoakes (13):
  mm: introduce vma_flags_can_grow() and vma_can_grow()
  mm/vma: update do_mmap() to use vma_flags_t
  mm: convert __get_unmapped_area() to use vma_flags_t
  mm: update generic_get_unmapped_area[_topdown]() to use vma_flags_t
  mm: prefer mm->def_vma_flags in mm logic
  mm/vma: convert vm_pgprot_modify() to use vma_flags_t and rename
  mm/vma: rename vma_get_page_prot to vma_flags_to_page_prot
  mm: introduce vma_get_page_prot() and use it
  mm/vma: update create_init_stack_vma() to use vma_flags_t
  mm/vma: convert miscellaneous uses of VMA flags in core mm
  mm/mlock: convert mlock code to use vma_flags_t
  mm/mprotect: convert mprotect code to use vma_flags_t
  mm/mremap: convert mremap code to use vma_flags_t

 arch/mips/kernel/vdso.c                     |   4 +-
 arch/powerpc/mm/book3s64/slice.c            |   6 +-
 drivers/gpu/drm/drm_gem.c                   |   2 +-
 drivers/gpu/drm/drm_gem_dma_helper.c        |   2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c      |   2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c       |   2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c     |   6 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c    |  12 +-
 drivers/gpu/drm/msm/msm_gem.c               |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c       |   2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c        |   2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c          |   6 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c |   2 +-
 drivers/gpu/drm/tegra/gem.c                 |   2 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |   2 +-
 drivers/gpu/drm/xe/xe_device.c              |   2 +-
 drivers/gpu/drm/xe/xe_mmio_gem.c            |   2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c     |   2 +-
 drivers/video/fbdev/core/fb_io_fops.c       |   2 +-
 fs/aio.c                                    |   2 +-
 fs/hugetlbfs/inode.c                        |   3 +-
 include/linux/huge_mm.h                     |  10 +-
 include/linux/memfd.h                       |   6 +-
 include/linux/mm.h                          |  51 ++++--
 include/linux/sched/mm.h                    |  16 +-
 ipc/shm.c                                   |   3 +-
 mm/debug.c                                  |   2 +-
 mm/huge_memory.c                            |  21 +--
 mm/memfd.c                                  |  15 +-
 mm/mlock.c                                  |  97 ++++++------
 mm/mmap.c                                   | 164 +++++++++++---------
 mm/mprotect.c                               |  16 +-
 mm/mremap.c                                 |  38 ++---
 mm/nommu.c                                  |   3 +-
 mm/util.c                                   |  10 +-
 mm/vma.c                                    |  27 ++--
 mm/vma.h                                    |   8 +-
 mm/vma_exec.c                               |  20 ++-
 sound/core/memalloc.c                       |   2 +-
 tools/testing/vma/include/dup.h             |  22 ++-
 41 files changed, 339 insertions(+), 261 deletions(-)

--
2.54.0

