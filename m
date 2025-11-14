Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30BB4CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DE808E001B; Fri, 14 Nov 2025 12:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88EA48E0005; Fri, 14 Nov 2025 12:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DAD8E001B; Fri, 14 Nov 2025 12:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64BAA8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 380D013B09B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:12 +0000 (UTC)
X-FDA: 84109833024.27.9A25668
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 598B3A000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=WpNvbsQu;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139790; a=rsa-sha256;
	cv=none;
	b=Sb3UxME1s+tAmgiYf/XwuhDdLZcvVy4x1QfFvpTPm1EMOOh3c96a8Qpdg/ZMT2RHCctNjj
	fLrLSnT1BomanZPfTSDFEbFaqA6BgtRwKNUYvqNN33hWebAEDJQ8+/k32qF+iEmA/qJxks
	8D3ZNb+c4A+QT/9vcJ46CyuxPL12TLY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=WpNvbsQu;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/SEVpY94OdgGG2/dAaATLhsQFCx45qU4GdqPwQTVVXA=;
	b=f1be0Wajh++OqwGsW4mKMpqFkjRtjsvphyydN053IStxxxs6DLoBhjPZEsPD67Cji0j5VU
	JLi6Sd4DU1s8X9LxFw8kwNydod9jchs2PXLKTkqN2o3MeJnRN+8tE29MntjJu4jOAteW9+
	WJeemG2q8xClClL8Rli8Bow5tfCYulM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139787;
	bh=xmTuO99WLZNe6DADt1m20DsqMVzO7dXn0+8ex7jo2IQ=;
	h=From:To:Cc:Subject:Date:From;
	b=WpNvbsQus7eDIt7VMzy2MfISk+rMdVp7HDWVNyalUw9h5HHOd1LBs6RnLp3O9paRI
	 M3ZrWEw4pUNc2bhCaUoWLa5UO2ff6IjWVVLnfbqKyqgDIXwQJ3tmkz5TZv/mwCS9cB
	 lxD/E8VDmG3UNFoke/qw7eV16MzUx9R3wSLGPQEZXSdDrkxqSo76Z2mfWG4eHYKx6L
	 gyZtZMwSvKpSU0p13EUoZWeRYqrPB8EJN9bqVS/Dy1V6inwu3Ux5LzkdtOT1U0rX49
	 nLjA3dvcVA+pp4T8HMSDN7HqNeo9GWsxRVjt1tWqeG0v6mF18srxoXD2oESJuOMzDm
	 k2mpYkxq/Pjsw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 77D1D17E0927;
	Fri, 14 Nov 2025 18:03:06 +0100 (CET)
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
Subject: [PATCH v9 00/11] drm: Reduce page tables overhead with THP
Date: Fri, 14 Nov 2025 18:02:51 +0100
Message-ID: <20251114170303.2800-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 598B3A000E
X-Rspamd-Server: rspam07
X-Stat-Signature: m1sdunsxe437c3mgua7t3nrukojxdnsi
X-Rspam-User: 
X-HE-Tag: 1763139790-565790
X-HE-Meta: U2FsdGVkX193ceX7kfyYA1JyfgLcUbhDOnQqLfct8LaEME1r6eM9/YYR5dJ2cb3zZh63xYobx+Qmnyrat8fD5QFoncHNKIlgCijSAnHVeiFGh0EqTitfP9xAUBMLMVODIQWAaLwc1/TrR7uOpprFdEGGwknSstPD7z5y4b1FhJ8lQGjb3WXKTbXwfV+kZHF6O1rKHbCMhQUO1ifp8yicMSe7Xq9/ycaJhCad/kTFJHY0GCXNCEVIPTw7nqdqsZ5bkkugPsk7Tr6+bo3DjAYljntuKkHBD17qJJq77t07n4yAGcvAR5QEigIyGi6aCK+WsMD+P2NunMVy65vn7Fs1LdETirNU4TNOtfmIMLdjxOBi3Acymmh2GV2QxP7gyqUOYpi0JXw2l4zy3RIwIeyNDEdgKNJITvBURZoWdIaqf5DgS85iJL9Nc7XDmK2ppkg4vbMyurPmT84q/rl7dsuwNOPJJq3afw0tsDEdU57FvUftPKMldt4dW+6oX+kuQJCJvnBwpzrrJBhAb58uwCetI+SAaT7JsvvNLsMdFluGZ4jc2/6cYYIDUlFvwHoLOPgPeN5DvZ79BH5Q0FX4gAaJeFif5r6z8UGlkqohnchryRLClwtOpxYKzDS9e3MfUYEj5AbIEx2UkAx6OeQvmLAba5Dp3Fh5DnJvjvmhvH2hBZWCRruegqj2x2rEGXXwPq7SCVuAA6Y1w61Ql2sE9yxshShGw/eJ3qP0H4KThtXVibfcwrtO5h2Yn7j6YxDU1I6HCA7w8AkjLi2BtpXrLjeFkLOarWnJYj2NseFM2ypKQzpbMFJLH/Ml5dH+Bnnnmu2tZVfFbuXdMPF6hZB7tGIkTi4lMPQbPQQS0qNpfiC1Y2+VH70jSCWoy5qLsZR1OambDa0nP+W2zQjHIQ+C5HEcr9WNX/Lz02upbCz/yRKfI7yGcXHDCmWiqFXJA4YDRZvqeO/rFwCz1csu+zaC6+a
 KQvqvQDB
 yobx1OYScuwSV+/+YYBw5TB9btpNXJZ74Rj10F0bWV5B9ZXc3IpicRuLtREbAK+KMu/OC64jjDxIdyaE8grY6YVZxUL5d71fe7G1D50AqBDFkN6PfDEfqYfwJmVa86azNF7L/GJEZiHQJZyjwyKYUs56xMAGZ1e7TYggoBIv+mb5CVHMrQx+V5kOplmAKJGEvfTcflBP7O3roYrd8FJMolA5Oa1GWLNpPABIzj6NmuffoEG2OIq0YQ39ilJZ4XPA9I4vNhFS3ve+rwjREEW/rQnwTBqAd1jqxW7gbCXQ2D4K8hJRh83RjJYaZ+iREvpWcfvJy8qeNA4b8FS+eBl0PCIZZlU4J7zD/YkcFULkdiLAtTxCiaCB8ggkFoNLb5KVhJ7xD4IubohxXxWk49IbpPeqQIkCVBLYodZOA7I6kiFvDF93T8DylLzM84milb4QRERbv
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
 29 files changed, 446 insertions(+), 297 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


