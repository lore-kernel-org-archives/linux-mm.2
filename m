Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED3ABC44506
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56106B00A9; Sat, 11 Jul 2026 14:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE03D6B00A6; Sat, 11 Jul 2026 14:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80696B00A9; Sat, 11 Jul 2026 14:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B23A6B00A5
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:48:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18BD6140768
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:48:33 +0000 (UTC)
X-FDA: 84977381706.04.C0F05BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E390D14000C;
	Sat, 11 Jul 2026 18:48:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnYjakH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783795711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UEx0tri9WMXr89Y9RByToAehzQgA+sg4lm/OABcyvPE=;
	b=EHsjRAddovo/sX4IfABHQpSp7aAZayO4EC0e4uKk0OltqHh3GuD1CS/SkuvJlJjAoAZj6m
	uVe0yHeVMYBXpaOL2NcjrM3vvcV9ie2u/OPrV2UtwF22ysHrBWIPGXYzm8RRkcahjYwt+l
	U2CgYNXVi/piWSop0oVBJHMVF+sA50U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnYjakH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783795711;
	b=2KLKgIXIhl3AZ/jTOrgFLk/b8+CL0agZAd+z3LSbFn5Um3sQxSM1Rim0YRGB8JqWHz6x2P
	m54GqhLTR/E9cFr1zTFyyXzhNLMJOKysw1MXRbOX8ik+9daeD3GDVLncRkIfc5rd9CbwWC
	Sgoe7RJoHg7DbDcwoE5vD6PdYWvxI1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61C0F60052;
	Sat, 11 Jul 2026 18:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B621F000E9;
	Sat, 11 Jul 2026 18:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783795710;
	bh=UEx0tri9WMXr89Y9RByToAehzQgA+sg4lm/OABcyvPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dnYjakH2WVgloYsi+jUVcGCbG7rxAi1pU7tW8mJIdE6oGfNmgRxm2lkIJstr9dGEo
	 6yD5lskj/PN2+ryoD6/tOuGL1WoVvqTEa+DQVmAAvZqEHLCXGsLyJtTJxnjYp6B0jW
	 IikPIZ8C2ZhZCERTy9H5QIwhvGWNfcZweBb/3HZFkj7VpVTdh9ZXyXl3h0NJCB2UP6
	 VTOCtSLAT14FoCzGfIDvGLs0HNrc8xonL8yng0qw3GHGb3q0KQANrkQ97QPAj9qDm0
	 aeZGjHzcaeB9LVkTFMgUFwXpKrKBCZP9HwBxFCWMkNkn+771AZux5Cs12n8q83blNL
	 rDY+8EcDEdTQA==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sat, 11 Jul 2026 19:45:05 +0100
Subject: [PATCH v2 08/13] mm: introduce vma_get_page_prot() and use it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260711-b4-vma-flags-mm-v2-8-0fa2357d5431@kernel.org>
References: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
In-Reply-To: <20260711-b4-vma-flags-mm-v2-0-0fa2357d5431@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Benjamin LaHaise <bcrl@kvack.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Russell King <linux+etnaviv@armlinux.org.uk>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 Inki Dae <inki.dae@samsung.com>, Seung-Woo Kim <sw0312.kim@samsung.com>, 
 Kyungmin Park <kyungmin.park@samsung.com>, 
 Krzysztof Kozlowski <krzk@kernel.org>, 
 Peter Griffin <peter.griffin@linaro.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Jani Nikula <jani.nikula@linux.intel.com>, 
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, 
 Rodrigo Vivi <rodrigo.vivi@intel.com>, 
 Tvrtko Ursulin <tursulin@ursulin.net>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Sandy Huang <hjc@rock-chips.com>, 
 =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>, 
 Andy Yan <andy.yan@rock-chips.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, Gerd Hoffmann <kraxel@redhat.com>, 
 Dmitry Osipenko <dmitry.osipenko@collabora.com>, 
 Gurchetan Singh <gurchetansingh@chromium.org>, 
 Chia-I Wu <olvaffe@gmail.com>, Zack Rusin <zack.rusin@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>, 
 Helge Deller <deller@gmx.de>, Kees Cook <kees@kernel.org>, 
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
 Boris Brezillon <boris.brezillon@collabora.com>, 
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, dri-devel@lists.freedesktop.org, 
 etnaviv@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org, 
 linux-samsung-soc@vger.kernel.org, intel-gfx@lists.freedesktop.org, 
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rockchip@lists.infradead.org, 
 linux-tegra@vger.kernel.org, virtualization@lists.linux.dev, 
 intel-xe@lists.freedesktop.org, xen-devel@lists.xenproject.org, 
 linux-fbdev@vger.kernel.org, linux-sound@vger.kernel.org, 
 Jani Nikula <jani.nikula@intel.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=18476; i=ljs@kernel.org;
 h=from:subject:message-id; bh=lULewHs+VHoBISysZgqCk8k0yrnFoPvsXucHfYLh71o=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC+i05Zk3QOniRM/ZQ1U4x663nNk+b4BUnELFb7k3Lq
 eRdbCLfOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRTmZGhjen+ya1iteoHZRV
 U99Tyb+6X/P57WDnNXZakZWdij3CUgz/6+fsOFPx37vK80cX38rkc48X77AuLJotGHc7dFv3rwQ
 HRgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: E390D14000C
X-Stat-Signature: qqw57dwszkw35nqtpqmfb7jq1max85pa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783795710-527612
X-HE-Meta: U2FsdGVkX1/WfhPzzhFjz40/NZ5ags4E7gXa1GN1J93sosMEYWvVNUVArTRtfVtq3zUNi4PlqlGJOOSK+28TQ8Z1vm4biiIQorYuSmjATCtXZZbzZbzb9R2tU/0vBnnmP6OmUzpCy/5/dtK2OYzAPn6hsm1IFd3hdlacR1nvUAo2TBlIzIgpdCJAbQw6meolZ3tkJ7dkpfQvtahC/ybVWBKIY7Yypt1YJfHdv7C/6wAcIr9p1Z22w5RYp6XrRzcqdtPhDXpEqEcd+tRMfAQVz0dSKkqsjmHHrF8v64EKJD8sdQg8ftdJlpVCAjx0yvIkGp+59O7K5U2clyYkZHjpoe6oabeoe8NQ8Q3ApNP2BVPjZdMcoi8EAPi8ag7dx+aT0fjRdBYg5ELHK6FDB+F0tmgf34HoRZs1KjWcIG5CltEQ3LMxBt/9lJd897fXZOO5l4LHmK278+RSAqBSfy5YtYfnZn75vWsgv4Xd4KyM9HgvWm7QoyCiIaUtHZC6UJkrvOMNp4kPG3ZeeMV7/n/omzccS9fdjLZJRYgWwFWndKzYI5bMkitPi1v0mTqNTiGdziaqCkdSLyCz0umb8gkmNjPHbAVwrA98h5++QZWbq9jH23yMq0i6yeoqkIZ6+cmaZEPxoNxL7FSpSJIG9zQqpgaAE/y1T6q6C66/S4qb25Nx3T+6979lMNdGR44Mzm5eICxxaGTan4PkR/+ewiPlZdOTG5VEv+UW+il2/QeTs5T6kOhrHEp5odYlPKh/n2D1OHcG6FUymGut76Xzboq9iMNbqGtnB9rfEINy/QOHp4pwrI2ETYrwV0BSBo6vF5CuZVIkJk4H34p/GfTySCTRu+KxUX9j8qzt2jSkatMG0A1A9Sj8CkdR2zJSite7/VoS/Sbz+/PfVR3SHFGR+gLQNqFrj1dLlJvciLm8GZedd9ONNTEaCnrqU6yJMjxh7RmXO0T8DhWZn4F7cASBSMh
 KAFPhJ8j
 cGotO5SSspoB0Uc9F7dYA55FM6T/FQOCMU1OCALJ95pQ/D7P9jdXpMNWtX9/MBv2r5OUGwGZOA0hFFOfrDGaeCMK461AUuygc/SycJWGlYHQk1UamwUMj/ZYlf864LVpwjH6jdmujW0toGpS9VmQf4U/mN4Gs4t0BCD7qgFYAMqzhEjolm4VhaplTaBMDcCo5gDKQjBb3IlUE14aakIOg1YmbVbm6fowWLY/oB0FjajlFkspcaTghOwYrrEFqq+9x1tjcqUvzc+x1nSKclbTSyjkbrLTlCh21sGsSYDTTOe2kkyqxIvhKG3xb1GOEfOv5C0pI3IkTVhJNLKtwUZ0Z4Lg5NIb4dcGjuzuHXUD5zp2tE8haBJkdsznRolGr5O2h67sMxRlT/Gv/OcPWwbYDawS/vHIRaXg42AwRZZ0fekkaTLRgK5lprABUalLVkDbHSUs2HoMd8LeEIYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's a large number of vm_get_page_prot(vma->vm_flags) invocations. Make
life easier by introducing vma_get_page_prot() parameterised by the VMA.

This also makes converting vm_get_page_prot() to vma_flags_t easier.

Also update the userland VMA tests to reflect the change.

No functional change intended.

Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Jani Nikula <jani.nikula@intel.com> # for i915
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de> # for DRM
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 drivers/gpu/drm/drm_gem.c                   |  2 +-
 drivers/gpu/drm/drm_gem_dma_helper.c        |  2 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c      |  2 +-
 drivers/gpu/drm/etnaviv/etnaviv_gem.c       |  2 +-
 drivers/gpu/drm/exynos/exynos_drm_gem.c     |  6 +++---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c    | 12 ++++++------
 drivers/gpu/drm/msm/msm_gem.c               |  2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c       |  2 +-
 drivers/gpu/drm/omapdrm/omap_fbdev.c        |  2 +-
 drivers/gpu/drm/omapdrm/omap_gem.c          |  6 +++---
 drivers/gpu/drm/panthor/panthor_gem.c       |  2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c |  2 +-
 drivers/gpu/drm/tegra/gem.c                 |  2 +-
 drivers/gpu/drm/virtio/virtgpu_vram.c       |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c  |  2 +-
 drivers/gpu/drm/xe/xe_device.c              |  2 +-
 drivers/gpu/drm/xe/xe_mmio_gem.c            |  2 +-
 drivers/gpu/drm/xen/xen_drm_front_gem.c     |  2 +-
 drivers/video/fbdev/core/fb_io_fops.c       |  2 +-
 include/linux/mm.h                          | 11 ++++++++++-
 mm/vma.c                                    |  2 +-
 mm/vma_exec.c                               |  2 +-
 sound/core/memalloc.c                       |  2 +-
 tools/testing/vma/include/dup.h             |  5 +++++
 24 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index e3ed684ddcf2..32a05d889b9a 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1252,7 +1252,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 		}
 
 		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	}
 
diff --git a/drivers/gpu/drm/drm_gem_dma_helper.c b/drivers/gpu/drm/drm_gem_dma_helper.c
index 1c00a71ab3c9..7d9612075d31 100644
--- a/drivers/gpu/drm/drm_gem_dma_helper.c
+++ b/drivers/gpu/drm/drm_gem_dma_helper.c
@@ -540,7 +540,7 @@ int drm_gem_dma_mmap(struct drm_gem_dma_object *dma_obj, struct vm_area_struct *
 	vm_flags_mod(vma, VM_DONTDUMP | VM_DONTEXPAND, VM_PFNMAP);
 
 	if (dma_obj->map_noncoherent) {
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 
 		ret = dma_mmap_pages(drm_dev_dma_dev(dma_obj->base.dev),
 				     vma, vma->vm_end - vma->vm_start,
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c989459eb215..06d019d51d3e 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -764,7 +764,7 @@ int drm_gem_shmem_mmap(struct drm_gem_shmem_object *shmem, struct vm_area_struct
 		return ret;
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	if (shmem->map_wc)
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index 2e4d6d117ee2..f9c8b7b2bfc7 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -133,7 +133,7 @@ static int etnaviv_gem_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 
-	vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vm_page_prot = vma_get_page_prot(vma);
 
 	if (etnaviv_obj->flags & ETNA_BO_WC) {
 		vma->vm_page_prot = pgprot_writecombine(vm_page_prot);
diff --git a/drivers/gpu/drm/exynos/exynos_drm_gem.c b/drivers/gpu/drm/exynos/exynos_drm_gem.c
index 9a6270f3dca6..0208c9259572 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
@@ -377,13 +377,13 @@ static int exynos_drm_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct
 
 	/* non-cachable as default. */
 	if (exynos_gem->flags & EXYNOS_BO_CACHABLE)
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 	else if (exynos_gem->flags & EXYNOS_BO_WC)
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 	else
 		vma->vm_page_prot =
-			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+			pgprot_noncached(vma_get_page_prot(vma));
 
 	ret = exynos_drm_gem_mmap_buffer(exynos_gem, vma);
 	if (ret)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 0644f85c6c8e..9ca90c1bb5b4 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -112,7 +112,7 @@ i915_gem_mmap_ioctl(struct drm_device *dev, void *data,
 		vma = find_vma(mm, addr);
 		if (vma && __vma_matches(vma, obj->base.filp, addr, args->size))
 			vma->vm_page_prot =
-				pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+				pgprot_writecombine(vma_get_page_prot(vma));
 		else
 			addr = -ENOMEM;
 		mmap_write_unlock(mm);
@@ -1024,7 +1024,7 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
 	fput(anon);
 
 	if (obj->ops->mmap_ops) {
-		vma->vm_page_prot = pgprot_decrypted(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_decrypted(vma_get_page_prot(vma));
 		vma->vm_ops = obj->ops->mmap_ops;
 		vma->vm_private_data = obj->base.vma_node.driver_private;
 		return 0;
@@ -1035,7 +1035,7 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
 	switch (mmo->mmap_type) {
 	case I915_MMAP_TYPE_WC:
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
@@ -1043,19 +1043,19 @@ i915_gem_object_mmap(struct drm_i915_gem_object *obj,
 		GEM_WARN_ON(1);
 		fallthrough;
 	case I915_MMAP_TYPE_WB:
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
 	case I915_MMAP_TYPE_UC:
 		vma->vm_page_prot =
-			pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+			pgprot_noncached(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_cpu;
 		break;
 
 	case I915_MMAP_TYPE_GTT:
 		vma->vm_page_prot =
-			pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+			pgprot_writecombine(vma_get_page_prot(vma));
 		vma->vm_ops = &vm_ops_gtt;
 		break;
 	}
diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index cbf723a5d86f..6a78e242de7c 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1125,7 +1125,7 @@ static int msm_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struct
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = msm_gem_pgprot(msm_obj, vma_get_page_prot(vma));
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
index 20dba02d6175..9a6ee2e880c0 100644
--- a/drivers/gpu/drm/nouveau/nouveau_gem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
@@ -55,7 +55,7 @@ static vm_fault_t nouveau_ttm_fault(struct vm_fault *vmf)
 		goto error_unlock;
 
 	nouveau_bo_del_io_reserve_lru(bo);
-	prot = vm_get_page_prot(vma->vm_flags);
+	prot = vma_get_page_prot(vma);
 	ret = ttm_bo_vm_fault_reserved(vmf, prot, TTM_BO_VM_NUM_PREFAULT);
 	nouveau_bo_add_io_reserve_lru(bo);
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
diff --git a/drivers/gpu/drm/omapdrm/omap_fbdev.c b/drivers/gpu/drm/omapdrm/omap_fbdev.c
index ca3fb186bf19..4881777642d2 100644
--- a/drivers/gpu/drm/omapdrm/omap_fbdev.c
+++ b/drivers/gpu/drm/omapdrm/omap_fbdev.c
@@ -84,7 +84,7 @@ static int omap_fbdev_pan_display(struct fb_var_screeninfo *var, struct fb_info
 
 static int omap_fbdev_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 
 	return fb_deferred_io_mmap(info, vma);
 }
diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 00404fb6c29a..fb0e6f556b31 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -538,9 +538,9 @@ static int omap_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP | VM_IO | VM_MIXEDMAP);
 
 	if (omap_obj->flags & OMAP_BO_WC) {
-		vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 	} else if (omap_obj->flags & OMAP_BO_UNCACHED) {
-		vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+		vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
 	} else {
 		/*
 		 * We do have some private objects, at least for scanout buffers
@@ -558,7 +558,7 @@ static int omap_gem_object_mmap(struct drm_gem_object *obj, struct vm_area_struc
 		vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 		vma_set_file(vma, obj->filp);
 
-		vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+		vma->vm_page_prot = vma_get_page_prot(vma);
 	}
 
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index a1e2eb1ca7bb..770556353968 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -776,7 +776,7 @@ static int panthor_gem_mmap(struct drm_gem_object *obj, struct vm_area_struct *v
 	}
 
 	vm_flags_set(vma, VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	if (should_map_wc(bo))
 		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
 
diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
index b188539dca0b..9a1dc9f12072 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_gem.c
@@ -255,7 +255,7 @@ static int rockchip_drm_gem_object_mmap(struct drm_gem_object *obj,
 	 */
 	vm_flags_mod(vma, VM_IO | VM_DONTEXPAND | VM_DONTDUMP, VM_PFNMAP);
 
-	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_writecombine(vma_get_page_prot(vma));
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	if (rk_obj->pages)
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 1d8d27a5ea89..f76af733ea79 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -602,7 +602,7 @@ int __tegra_gem_mmap(struct drm_gem_object *gem, struct vm_area_struct *vma)
 
 		vma->vm_pgoff = vm_pgoff;
 	} else {
-		pgprot_t prot = vm_get_page_prot(vma->vm_flags);
+		pgprot_t prot = vma_get_page_prot(vma);
 
 		vm_flags_mod(vma, VM_MIXEDMAP, VM_PFNMAP);
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_vram.c b/drivers/gpu/drm/virtio/virtgpu_vram.c
index 4ae3cbc35dd3..544a6abddbc8 100644
--- a/drivers/gpu/drm/virtio/virtgpu_vram.c
+++ b/drivers/gpu/drm/virtio/virtgpu_vram.c
@@ -55,7 +55,7 @@ static int virtio_gpu_vram_mmap(struct drm_gem_object *obj,
 
 	vma->vm_pgoff -= drm_vma_node_start(&obj->vma_node);
 	vm_flags_set(vma, VM_MIXEDMAP | VM_DONTEXPAND);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	vma->vm_ops = &virtio_gpu_vram_vm_ops;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
index 45561bc1c9ef..a9fd4015a0ca 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -481,7 +481,7 @@ vm_fault_t vmw_bo_vm_fault(struct vm_fault *vmf)
 	if (vbo->dirty && vbo->dirty->method == VMW_BO_DIRTY_MKWRITE)
 		prot = vm_get_page_prot(vma->vm_flags & ~VM_SHARED);
 	else
-		prot = vm_get_page_prot(vma->vm_flags);
+		prot = vma_get_page_prot(vma);
 
 	ret = ttm_bo_vm_fault_reserved(vmf, prot, num_prefault);
 	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index abe25aedeead..838797cc65d7 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -281,7 +281,7 @@ static vm_fault_t barrier_fault(struct vm_fault *vmf)
 	pgprot_t prot;
 	int idx;
 
-	prot = vm_get_page_prot(vma->vm_flags);
+	prot = vma_get_page_prot(vma);
 
 	if (drm_dev_enter(dev, &idx)) {
 		unsigned long pfn;
diff --git a/drivers/gpu/drm/xe/xe_mmio_gem.c b/drivers/gpu/drm/xe/xe_mmio_gem.c
index 8c803ef233cc..3741ae60f532 100644
--- a/drivers/gpu/drm/xe/xe_mmio_gem.c
+++ b/drivers/gpu/drm/xe/xe_mmio_gem.c
@@ -149,7 +149,7 @@ static int xe_mmio_gem_mmap(struct drm_gem_object *base, struct vm_area_struct *
 
 	/* Set vm_pgoff (used as a fake buffer offset by DRM) to 0 */
 	vma->vm_pgoff = 0;
-	vma->vm_page_prot = pgprot_noncached(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_noncached(vma_get_page_prot(vma));
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 		     VM_DONTCOPY | VM_NORESERVE);
 
diff --git a/drivers/gpu/drm/xen/xen_drm_front_gem.c b/drivers/gpu/drm/xen/xen_drm_front_gem.c
index eec4c1da3f9e..dd158443f55f 100644
--- a/drivers/gpu/drm/xen/xen_drm_front_gem.c
+++ b/drivers/gpu/drm/xen/xen_drm_front_gem.c
@@ -80,7 +80,7 @@ static int xen_drm_front_gem_object_mmap(struct drm_gem_object *gem_obj,
 	 * which is mapped as Normal Inner Write-Back Outer Write-Back
 	 * Inner-Shareable.
 	 */
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	/*
 	 * vm_operations_struct.fault handler will be called if CPU access
diff --git a/drivers/video/fbdev/core/fb_io_fops.c b/drivers/video/fbdev/core/fb_io_fops.c
index 6ab60fcd0050..6d0a8c8e141a 100644
--- a/drivers/video/fbdev/core/fb_io_fops.c
+++ b/drivers/video/fbdev/core/fb_io_fops.c
@@ -161,7 +161,7 @@ int fb_io_mmap(struct fb_info *info, struct vm_area_struct *vma)
 		len = info->fix.mmio_len;
 	}
 
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 	vma->vm_page_prot = pgprot_framebuffer(vma->vm_page_prot, vma->vm_start,
 					       vma->vm_end, start);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b8fe40f89d87..1209db1a4b92 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4610,6 +4610,11 @@ static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 	return vm_get_page_prot(vm_flags);
 }
 
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return vma_flags_to_page_prot(vma->flags);
+}
+
 void vma_set_page_prot(struct vm_area_struct *vma);
 #else
 static inline pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
@@ -4620,9 +4625,13 @@ static inline pgprot_t vma_flags_to_page_prot(vma_flags_t vma_flags)
 {
 	return __pgprot(0);
 }
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return __pgprot(0);
+}
 static inline void vma_set_page_prot(struct vm_area_struct *vma)
 {
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 }
 #endif
 
diff --git a/mm/vma.c b/mm/vma.c
index 38481aca7321..e0ad895098a9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3430,7 +3430,7 @@ struct vm_area_struct *__install_special_mapping(
 	if (pgtable_supports_soft_dirty())
 		vm_flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	vma->vm_ops = ops;
 	vma->vm_private_data = priv;
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index ef1fa2b161f3..a3c6b05c65fe 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -146,7 +146,7 @@ int create_init_stack_vma(struct mm_struct *mm, struct vm_area_struct **vmap,
 	if (pgtable_supports_soft_dirty())
 		flags |= VM_SOFTDIRTY;
 	vm_flags_init(vma, flags);
-	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	vma->vm_page_prot = vma_get_page_prot(vma);
 
 	err = insert_vm_struct(mm, vma);
 	if (err)
diff --git a/sound/core/memalloc.c b/sound/core/memalloc.c
index 9320671dfcc8..5bc7e586b430 100644
--- a/sound/core/memalloc.c
+++ b/sound/core/memalloc.c
@@ -851,7 +851,7 @@ static void snd_dma_noncoherent_free(struct snd_dma_buffer *dmab)
 static int snd_dma_noncoherent_mmap(struct snd_dma_buffer *dmab,
 				    struct vm_area_struct *area)
 {
-	area->vm_page_prot = vm_get_page_prot(area->vm_flags);
+	area->vm_page_prot = vma_get_page_prot(area);
 	return dma_mmap_pages(dmab->dev.dev, area,
 			      area->vm_end - area->vm_start,
 			      virt_to_page(dmab->area));
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 8621a7ae8980..57c80924813d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1573,3 +1573,8 @@ static inline void vma_assert_can_modify(struct vm_area_struct *vma)
 	if (vma_is_attached(vma))
 		vma_assert_write_locked(vma);
 }
+
+static inline pgprot_t vma_get_page_prot(const struct vm_area_struct *vma)
+{
+	return vma_flags_to_page_prot(vma->flags);
+}

-- 
2.55.0


