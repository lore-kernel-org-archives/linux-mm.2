Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2B3FD116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FC66B0031; Fri, 28 Nov 2025 13:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7B06B007B; Fri, 28 Nov 2025 13:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE906B0088; Fri, 28 Nov 2025 13:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEC806B0031
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:52:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 981535A89A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:52:59 +0000 (UTC)
X-FDA: 84160912878.20.45B1DD6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id D9AEA1C0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:52:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=TwiCC++P;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y46db6HyPpRxHMZEYchyxRz+XCmMaUApZgWh/sqX3VE=;
	b=zq1AIzFZZooxOJVJKOr5up7Pk1y0Z0Q9ADKbhfMCcB1yN5FOWeq8rONUIP2i+ApXH3jgP5
	BFOiaoMhDzmC6E5GAv6L9hkKUL4mf68iqXCbO0n+eyf80eH97v2E27wwuvfUo5hGhWy8bC
	4pCmxpO9YPzKfL/5qimCJ3lrDDFwb88=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355978; a=rsa-sha256;
	cv=none;
	b=DXHYcSvtBSnQUcjsw+7frbj1AqvKvDw/vpA5crxJokTo1Skv/wykDG3dZNz8Pm44yJ6XPO
	YBhaUTR9fY7KDCWvM5Xfr9cCeIGyA3251eUnT6sBPKaT3YfRlPoyWbfgZRkN3zTffR1LrO
	ti8SJfYtUocVsOCpBDzDAfl9/LY58BY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=TwiCC++P;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355975;
	bh=WD36yCxm800Ndq23SY+nTSX2Y6Dfp74xDdJZVIewpxU=;
	h=From:To:Cc:Subject:Date:From;
	b=TwiCC++Pni7IhbdyhG9ZbpFYU3WqbcUKlKSjjADby2QBkkmwJoHO2oNAZnXJXYSzv
	 q2Tkefz/pJabozGQNqIq6j4DFtTLAvMXzIKfsDYJnPTBwJCZIj7aiGT9TQHunG77GR
	 tjjQA+JDtkzmmZ9m2LWuuxJ6w5ebrsmFQThZbeLbwypAUj6U9tpnhtoPMGJkbdcxNF
	 nqcjMiXymVn2oqMAnLmrWuHsmmlxAovjuZUhAqEkqRFmVchIdM2Rq8JkGQK0Id94Nj
	 SGtdHk+Yas5llMVc4hFz2ULam/906T3mbJ3xvsJbwBido/Z38TS8KLU3ZRS4BqGyW/
	 QQw630VZ/tDmw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DA56C17E10F3;
	Fri, 28 Nov 2025 19:52:54 +0100 (CET)
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
Subject: [PATCH v10 00/10] drm: Reduce page tables overhead with THP
Date: Fri, 28 Nov 2025 19:52:42 +0100
Message-ID: <20251128185252.3092-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9AEA1C0006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: am51gaym4xdxx1ioffui56esoxnerohd
X-HE-Tag: 1764355977-397667
X-HE-Meta: U2FsdGVkX1/rcMsZBNjKkWHwu4GXtiy1E0bins2586lp/Z+d/Noqvn+Lb/X0kfJFdtMBJHdp2MokK8Q6r1P/Go36soMpSan2VQ7ifDBknYD0BWTbJEpb3Hgz9lcF4KtPmwqNEwClIc5ds5ptuvf09ew0yVEnA3ISZY4LEPzpifdyU0P6Mcxo5Gd91eM92/c0D75rVS25/Gw0bmijMWw/iJgazGHxDZGGzyLxxIMj3oKGY55dLac9R1J5UD6ePr89PCZwimWJqHFsiqogsVRdPHt7/TyQ43bE7A1vaSNoheDi5tdvIrLclRxcpvOiUjdibmgtSbTeBAWN6vWK/afuz94B0CPFFVMBozsNMfns+7fzpps1PeqAGKxx3Cp+eoeTRGcLA4CAl2XO1xREvX5YV+mC+4na5QOHR1LZN+xKBwk5T2aLk4r2jv10Pk4XmXe8lboVPKNnQbUhB1ov4ID/ZI4uFHVsROAlUg1/C12+ASSXBPNEWrXIeFFSnzvt3SxE55dDPQlk4WCd5ZQsO1t7ypGAcdxdoG3wN9BZzxOveQwVX/IO0iOd04/t8WihQvK75UKb4BiKm5EHJzO2hTfjuEaQPQCEnFzbNmW4WZqjM4TYI7eAHoKB2dmtB2fq4Wwh7mkAReeU79MgJ8HZQBMIx/oWvbxSdhEq5/igTqjOdIM69Bj8P06524tPfRS3LqQwPbuvfL32/MCNxqesjUvnOKFwVi3k6lmjP9sNN1nKrzI7CofgApu8BQv2Diy1pCLmmTly3hmFZAC6WfJ3prQHfgkkn29Lbj/6yew2Vh7TAl71UhLyRNcSD+k7r0xPRTJ3JYOyhV7r8mKwk/+XwYDWS6ZXZHYl5kU7q/9TZkbro6obp5SSq0G1EMEjqUnh/KrHc6W9qSbJZq2DVu370HUCFA9ZoQeXXjPBulRN0nE4Ox0g2V2OuQ3/iEFceGG5iVN/NCKZDiD/1KZPt29GLWV
 vg2VY3zF
 ASOMDcG+V5TisyNWamtmUwQ1d9Q9RPwW3RMg7XSEYQROBhVh/s4rgNJrS8RHK0oen7wVQ1lFnp+c79b2AjzfmGB3TJ7ked3o0w51KaI1QEOEGI8UChcsl1TrWYtz4qs1uKhi4C5U7894u2wtCVQkRXinV74mRT1JFvDev2DSb8s3AbU28rGQVQHKtxHfSyAWUY7CYMflEprU6E56gWTn6gve1HoLw/t53vq5mivrQWwoj61+QBfk0Qhv4SiWSuH593lWJn+MjibkFhOJ3PQWdAzqKIFpMn8EMdLtTAm1YObCSSk1sxfs6QkkezhdTv8nN49bNnpO5FvBULU4=
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

Loïc Molinari (10):
  drm/shmem-helper: Simplify page offset calculation in fault handler
  drm/shmem-helper: Map huge pages in fault handler
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/gem: Add huge tmpfs mountpoint helpers
  drm/i915: Use huge tmpfs mountpoint helpers
  drm/v3d: Use huge tmpfs mountpoint helpers
  drm/gem: Get rid of *_with_mnt helpers
  drm/panthor: Introduce huge tmpfs mountpoint option
  drm/panfrost: Introduce huge tmpfs mountpoint option
  Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

 Documentation/gpu/drm-mm.rst                  |  22 +-
 drivers/gpu/drm/drm_gem.c                     | 202 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  97 +++++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  48 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  71 ------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  16 +-
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
 drivers/gpu/drm/v3d/Makefile                  |   3 +-
 drivers/gpu/drm/v3d/v3d_bo.c                  |   6 +-
 drivers/gpu/drm/v3d/v3d_drv.c                 |   2 +-
 drivers/gpu/drm/v3d/v3d_drv.h                 |  11 +-
 drivers/gpu/drm/v3d/v3d_gem.c                 |  27 ++-
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  62 ------
 include/drm/drm_device.h                      |  15 ++
 include/drm/drm_gem.h                         |  40 +++-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 28 files changed, 432 insertions(+), 292 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


