Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1814ACCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A4C8E0026; Wed, 15 Oct 2025 11:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340F48E0005; Wed, 15 Oct 2025 11:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27D8B8E0026; Wed, 15 Oct 2025 11:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1553C8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5C571601DD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:28 +0000 (UTC)
X-FDA: 84000735336.28.B8E32A3
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91908A0016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UGlk5dxE;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=K7+zg63KL+yDYgPDeyAhKo9HCBsW9uaHU0H8G9F5zWI=;
	b=MhFn4MkDbFuVUhRFAQpUYaYeJoSLW5JJcQbFXlExpHuvgQs1DKUy12iJt3gLGKz3agXn/j
	Q1PsLyMc6C/OBnWIWpjPfv213mY/9Qm9ahGgFFCAKxNUKZJualj1U5PJMJEEURPs1p8e3M
	Z69/SKs968GqO9Q+KU0qRzgo6bWRRo4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UGlk5dxE;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542227; a=rsa-sha256;
	cv=none;
	b=i2sjtfi4Uredz9zM/y4rz87/Sh9eoWefkWuttb1rS1uaDWfn3rYUbsGk6Vp4oFO3XR6+SG
	LEEYJTKvvFsEh4Py2YJEdHV5ApwKHV4+VjD2xKCtK5xjRs/OudtnqL/HIs4oiXJcG3bIcn
	KXm639G3iitfqvGR71dN6plsp7inLlg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542223;
	bh=iAfD1supnmTcutAfLpNBfRXCPSsq6a/c6jvRpYWxSK8=;
	h=From:To:Cc:Subject:Date:From;
	b=UGlk5dxEuSjLSbtT9NmUo94HkIqMWhZRQe/oeGpEimv/hJEBjdk3BcyV5kSqV1qFa
	 H/9zyuU8p3Z7piOmEN9VOOJ30qinzDf1k2O9I6nZMNV5XyqcpGh2EQMpjNZzGItgBk
	 29piFiyIr/XMCDqs3LYAjvVw8RsnBB3LCJfkcf3o1E2kOJWzDUkt5l41LpSccu7HL+
	 Qzs5CSAVpTtmJhJN50tT3kW2nPJb+Sdhf/90KFqUBCoqeKVrMzBU9Wy3bR3BiXg43I
	 lFIuS309BpebbEmyj2TCMc0M31FWcyEuCry6RfknT2s1FTCasFcYFaZs8kPxQhtHzO
	 KLs9wihkZOyWA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 00C5417E1060;
	Wed, 15 Oct 2025 17:30:22 +0200 (CEST)
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
Subject: [PATCH v4 00/13] drm: Reduce page tables overhead with THP
Date: Wed, 15 Oct 2025 17:30:04 +0200
Message-ID: <20251015153018.43735-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91908A0016
X-Stat-Signature: sc6i7qqpidic6nynsjieimm1eiqik8fh
X-Rspam-User: 
X-HE-Tag: 1760542226-27935
X-HE-Meta: U2FsdGVkX1+0aY/fU/PNHRBNBwlLx7yBTwFbqGhuDDIUwSfb1kxhViollPpQLbqNBBA6jd5f7irUW8HrJ6L5ydoOc5kUZ+V7Fyj+I3xmIVyQJ6B7PIaqO4kDQ8zTgiU+pZkkmR+dJR0xYEfgYt/C9SfEi6LphWcPkfK1nPQxxeqTmxX5M7702NpBOKP0o+Roz4DmCOUv3Wc9fajKj5VOBMveuV71QXiW6bAMUZ5136njCwuEu4INXtqta42A4BF27K9tb38piW2H29swNJuK1fxEXRi+mGz+kJeP7Rl2NCsMiIb5oBdtUpf3Zg1499EcRN42uYdbG9BqmHMFaHqKPIVIZUM/zmZ5zObnAx/4ijW9Pe+kcu0H2m5xy7ZRSqkIBgaLbKcmxwCz7NDZf2wdU3MXqA0rbOJGbAZu7Rpp8ZD+zSANJrKKlVnJe2lt7STB3tyEIBBkPh6NOKLKW6vFFI3m4nJ2978oM3rB22y8K+wRboCV45SFrSf8nNt1o0qrgU+5NpbQUG2nVu3DMMMx8Ka/h7VfXzWrTf4lxFjwCzQQr0BVSaHpfIBCV0G0auPe66PqMRC2h97tm94MS63IQpGD+vSe0RgW+LUpUtgGwK7Inzy1h5zQ1IGbWhQCovqYJGfibGrkDbVklgZOmdN9jD0Mw/DhJ2GJZ2MVuGN2cI/nZw4K+YvNSdCYpyLog9XzpVzD2eizDnQ1sFfuqK9ijJ7u/tDD+YgRmSNxAzWOvvfNirdnzmGGLT+T7n1q6u3BKzmwqXXwsDBE8yJUSejjXsohSGpwS/ndycjwdIMSCP9aSONJ7bqdIV21bb4axuUtq/CeSGpQ0tsyiqMmu3xTNfOAsvC6IcpSLqxrAZbyVPCZBXIdQcuAN8+veZaQ72U4Pp5RNnDbOVaQcsOk4YTAkPmy/bRv4GxMhRQlTmnBtKK7QVrY0aQKyEXSWNmkZLr/GdLreOtubwkrfSzoo4E
 9fWcrhI+
 cJ62ww1Q/IUIsmPOLSlYvY0ZQvo4twgbanFRL/hNEqa5dLGvskyspGcE/ObwRbrxJmyyrOvyYwo/u8O2/pMEWmM1rtfpiuvgFgk6jJ1uzMltX1kapT7/rpyhKM14LcPexl9Cuev8odgo4xriueDpPcLYZO46Kq8Jq6SrGMOCHxVi8iczP5KlQi8KB1F4Eq2y9fKsfhKPmo8mj1BKRI+FdJwjzT03FoAbIOaSTPi65224E71plXGVfio6fxY5bBatGXyG8Ta2jDDxWcnjPGD/Avb1WXgAMH0ImIxUaR71y3e+0SDBa/bmLyFqePnpwuepZihp9Nj1GvyeFfB8=
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

It starts by implementing a map_pages handler for GEM objects to map
pages around a faulty address in a single batch. It also checks in
both the fault and fault-around handlers whether a faulty address is
part of a huge page in order to attempt a PMD sized PFN insertion into
the VMA. It then introduces a dedicated get_unmapped_area file
operation on the DRM file descriptor for GEM objects to get the best
virtual address alignment for the underlying shmem buffers.

The remaining commits propose shmem helpers to create and release huge
tmpfs mount points and adapt the i915 and V3D drivers. The helpers are
then used to optionally enable Transparent Hugepage for Panfrost and
Panthor.

For Panthor on a Rock 5B, this series makes the first memcpy() to an
entire BO object mapped in userspace about twice as fast with
Transparent Hugepage enabled.

Loïc Molinari (13):
  drm/shmem-helper: Simplify page offset calculation in fault handler
  drm/shmem-helper: Implement map_pages fault-around handler
  drm/shmem-helper: Map huge pages in fault handlers
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/gem: Add huge tmpfs mount point helper
  drm/i915: Use huge tmpfs mount point helper
  drm/v3d: Use huge tmpfs mount point helper
  drm/v3d: Fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
  drm/gem: Get rid of *_with_mnt helpers
  drm/panthor: Introduce huge tmpfs mount point option
  drm/panthor: Improve IOMMU map/unmap debugging logs
  drm/panfrost: Introduce huge tmpfs mount point option
  Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

 Documentation/gpu/drm-mm.rst                  |  25 ++-
 drivers/gpu/drm/drm_gem.c                     | 199 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        | 138 ++++++++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  47 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  69 ------
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
 drivers/gpu/drm/v3d/v3d_drv.h                 |  13 +-
 drivers/gpu/drm/v3d/v3d_gem.c                 |  29 ++-
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  60 ------
 include/drm/drm_device.h                      |  11 +
 include/drm/drm_gem.h                         |   8 +-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 mm/shmem.c                                    |   1 +
 30 files changed, 456 insertions(+), 292 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


