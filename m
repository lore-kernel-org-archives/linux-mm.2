Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31A96D2F7C8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3986E6B012F; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347186B0130; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236996B0131; Fri,  5 Dec 2025 04:12:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F08CB6B012F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F0FE132CF8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:11 +0000 (UTC)
X-FDA: 84184850862.17.23F27B7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8E58814000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Rf+LDaf+;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ul+RjVqTlsty4OS9oph2p81BfaTCZdR30Oh+aCN0TP8=;
	b=xVfxM4tFZ59zZL+/Cj0FUxxps1hGCMOs2HsCdjsrKbbcOb4nk9VHDQkoiFyIE7eV/IhJ3n
	eG3gD4Su5vCEcl+JvfJ6QDZXen6h6PQe8YnKZWBrMlOD1WD5ZNBhSe4KWUfVzvoHR/zMhw
	AEXq4nEZWADuDCyGvFrUo+1d9WBYSkU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925929; a=rsa-sha256;
	cv=none;
	b=zkIIZqPPp9kE3NuEBmpYuCgGDnb2KKwrk6Vw5LSmxOlX3AWYObx1cVjkOVHEuKc0/YEqvg
	aaBkvQt7LCuBFiZapPOD0749yRembFpwI50WHLXchJfFwDoao375cmxKGONkbHy5L3GDzN
	o+kTWHEc9JwW7c7D+V8KDy0Z2Euevuc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Rf+LDaf+;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925926;
	bh=kdHLrkRzJLri/Zem9ZEPjcDruJpnM9kiLoeD+kH2zfc=;
	h=From:To:Cc:Subject:Date:From;
	b=Rf+LDaf+fT2RPzU4aetg8P8WdjqWe/+MPLearGF8gLiua5FT7PiGr/p1zETKRTEzN
	 zQWoNwrumDnBIVfEU1+vjaToLSrtfrDhOaAsvsZyh07uyhcCqBizp9sz9eUJ5uoNSa
	 fs57rXhzqIy9SJWLcsZhaCMAQ2H0M1QRQvArSFtYGwTFJE1KZyGWup8WvuOBnZZr7x
	 cE3rnqQ8m8a/PWHZzEQB0bdmWAD05x0taB2UDxlEf0QceKz2kwdFNeALxvh6LWD1X/
	 Fr4wJw2WrG2RNZoUUrpYKWkeRwKItGpcBNOkr66AYF7bAEfr2RmT2sx2ejDF/XpXiC
	 tWRiMrrxyA3ig==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C967417E0483;
	Fri,  5 Dec 2025 10:12:05 +0100 (CET)
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
Subject: [PATCH v11 00/10] drm: Reduce page tables overhead with THP
Date: Fri,  5 Dec 2025 10:11:53 +0100
Message-ID: <20251205091203.150895-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8E58814000D
X-Stat-Signature: 6nsno393aki3hh3itt3csdjojbm4djqi
X-Rspam-User: 
X-HE-Tag: 1764925929-798118
X-HE-Meta: U2FsdGVkX1+O0He1e/B0edgNyVs5GfjLQCBIzTbHAw0ZCPX1WFRpYf4tatkf30wnDz2GpdKR4yTb1XKivLcxpdRvI9zwrgaQDQkQfcO5lJ9pzwSnsUAtINkeK+goKoPJX3oVxF3nvdXMJiN0KyCp1xRrpUEjFkbWx5FZ47UXTs30BIK/OFPQfIRGzcV9iTgUNF3V3sRO6kY5Ls2Pk9qRXkt+uABbKUry06P9Zv7RV6C3ir5co/8jjw6zoDbxAbsLakdnVeB4n8SNlmsCgYs1A4BttTHadUYxJvTJR8RmSBR3q2GdLgw01fakoT9BwwhtUtIevAeIs1I6kXD4vG59NyRW3YgQsOGvmnoTmqeuCHM9pcC+smEej9/MsfVVBGmBWKtmoPDB6VARP9LAZD5bn3mnpOagAVUh4ZPYrSQaAxFAkSXnRbS4LBQb52vfVKJn7MzVWqYPo6HhVz4AyDP4AXJXbaxHJgJIYIiZSO1d+iIkniMumiXV+RXMl28DhrtvNlS1aKqyITeNQ2hEsSalqiwnslk2EkM2r/GjYuaddIaXxCsKUcimzfvlhg6eZzUdcltHqreTj5Ma/yktoNy692F9NWhs5dgDhlOqMKDEg/E74JFy5V+Ft3VoC2RamFiz7B2bpRFGMRE8hUfPWVJYdtHLfDULe85QO+uM8RXH+D/qGTwGU04/EMiixjQVtXDWvzamoujUuaO0RmueFhhqcvR1nsBgTL5vlkTWcQpUEJmfHtwMWjVVIF2W9G0fa1EFX8EmRausKefInLwl5ulK+8c5NqvihcVGajH4NrpcrG1UEvUqKssvNkMCNojM3q2osgKtsCre2Bq085TjZvOkwTeao+mKNxgFt0rinYUxqC4YFasmtYWYqyvo3e9uGaDP6O5u9951u+VBYLDa4O/5uBRWpUXIjjUi2NhouCUdtMZKZAZv00wBGeJXL1SwkKIpmRW7f0q/0y0yb3SCLcu
 R+MkElau
 +1J6taecE9ySAT3ttxluWYxND9t46DBC2ys4rRaYWZhbsBCVyYfuzvdj7mzxfY9e56JT+kIYXxFoOrWfBbMbofN1u2/V2uoap6icGQEMY1DM7ja6/aAihQ7q98sZhkUcpOH40gOUdyncp7XsxvGs4cETSKYoVwWrOph2e/wzz2dPURdBvubhZz1EslckFA8V+EGn6VbOOXZWdMjLspgYcAtLlT8vxXYQoWgx1AvT6GW6IM9+ss0KDW1hcqvAB0tUlb5u+oHt3GjiqbDn4t2gKYlsz8YhdrKLeR0/rGtUBCRBcwJTZv9pQTg/we/4javZ+p6aCcmWxI1pUv7w=
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

 Documentation/gpu/drm-mm.rst                  |  29 ++-
 drivers/gpu/drm/drm_gem.c                     | 202 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  79 +++----
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
 drivers/gpu/drm/v3d/v3d_gem.c                 |  21 +-
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  62 ------
 include/drm/drm_device.h                      |  15 ++
 include/drm/drm_gem.h                         |  40 +++-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 28 files changed, 418 insertions(+), 289 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


