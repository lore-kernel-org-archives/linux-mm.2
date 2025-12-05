Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCD3D339A2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F275A6B01AE; Fri,  5 Dec 2025 13:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6F26B01B1; Fri,  5 Dec 2025 13:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6496B01B3; Fri,  5 Dec 2025 13:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C60786B01AE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C78686D31
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:39 +0000 (UTC)
X-FDA: 84186238038.19.FE8E924
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id 87EE7140006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qSTzhueG;
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QZRMEoghRjJDFgGw2lmjm3MfAujLSaYIdC5aK4c4WBI=;
	b=gj9v50iQbvshsHG7ttBfaQnmAYyv+k7W/My3cUiPkI+yin4gNBst7RulDSWfI7jfBhyqZS
	L0uomQ4iJDLKqpbK8NtKbPG3lJzesSAsSuFZhJHKUlneekSWFbVx/4JKKDFpwiunmNGJQY
	wFaxT8BVHl+1qdmkCC1v0Wf1rSKgQ2I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qSTzhueG;
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958957; a=rsa-sha256;
	cv=none;
	b=3vl1thmsMqW9CDU8u92i1b+E/CAm96euoXDg0RkI0Pv6/5Yc8PbDWCI2AaHK7/vbc+GLvm
	xS97xCjb6FF5kxbnXQz0nE7DDYLXsiipJ6yHv8d/WlMNgXFGHkVDBGikymPtxuMc8LXmUG
	p7u++h0sQ16NsRDA1LAn8/cA/5RyHCI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958954;
	bh=Gv9dNnyumHXwQe7RA3oVLD70kmogEg5WcdKMw4U/tjs=;
	h=From:To:Cc:Subject:Date:From;
	b=qSTzhueGknUWsWaFOgaCS9LEHg4L/4758R4Y0IQMAKaucZlL+Ua/eGIFn5QFocZI6
	 EQN1UxVLaGTnrr2ip2jwhbgcstH4QkmE2GBsPG5sBjH7J8vtKCqfYQzn+kMacR+dA9
	 EdnsXHXM4LgyUVhRcgbGc+FNwMtw62SGTDbcE0vwypUYPESwZ4VI/oi4UgdcU0l412
	 Sdfp1SW41NwaTTRKngX+BP9aKaB5nVll0clwT9suP/CKuTtRUPN0FH/9quc6HMPVYg
	 1iq8S5UgxmDxx2eO5jWDdaYnVTa6aD65C/Ifpz/UDwU2zC5xrHQ5GvfhYNuU2FrQrg
	 1XagI7bD9u5Rg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0D3F217E0610;
	Fri,  5 Dec 2025 19:22:34 +0100 (CET)
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
Subject: [PATCH v13 00/10] drm: Reduce page tables overhead with THP
Date: Fri,  5 Dec 2025 19:22:21 +0100
Message-ID: <20251205182231.194072-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1s44y455fqxb7xkd1dbyqtwrzbbabzwf
X-Rspamd-Queue-Id: 87EE7140006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764958957-29709
X-HE-Meta: U2FsdGVkX18HzfaTsQ2zEDKgd43OpJ7Y6vTkMbwHqWgi5wCtevlhMGsjefO39vUvmHfTwMsoQdqxFbg3hRwXBHOsthX0UlHr4LDzP5w1oLxoSQGcUlhQ/C+Irg5ar1d2j1oVajMjmuOPaW+lV+twXJmLni0qtl+gA1xEXzw+PklqU9iiXwEqZT3ZQN+/HunDWIZuHrP4UL8X5+poHILG4nEmC2XpMAAfTew0w7/nP4HYlU8DNcxVxVG2kXg50kx7f3v5jNqM9G/ddygS7dMj804Y8TsIC64hZzBPOEr6fg5Hf2co8tLHU6l8h5kLgF8VGftJAeTaRuLwzOTBqy/2rSVJwp68KPnTzc2C+V2WnjCQoP4ChMAdvOtmYFUeo9ileQJzNYLFkg9mr6qxvCKbwGjMjCYnQhmGF4eGNPFaNj7u47vi+krkTYhxCEx/jr7HLDdYiYbVN5EobbPtpQ4Jg/XTsH1EPNOe5w60hNBoRqJo9NFrDEXePT75TVYseBdIyzuXjgwJ5S+6QLVc2uTWTlTiozzX5/Vj3DT0HEHrNhBOqzgx66yMu7CUPmjJWmxdysGaktFfi1pabKAddWNdBd68Dm195jStXQ6YG8kFofaQVlWcBeSbzHSnjvfpSMHwVjjJs7HqcvQtOiKNGvEt6rftxoK9KeDD+tRfX5+6/kXoPdKnocF/jSDORpFSslRUFJLPPdAszVdUiYQrGracwkge+RiOsrvs16li5RFZD4hmcWLKTwMRLcKUYhqwezktbkvbwwxxh/iQ3mcrTpU2QJX4sTudinuAQA8eDUd9AaoShGM4BgGSklp6ry/jL+rT4WcNxEL+KWzt2KelrFIkROt6NYTdZxvJsDXFcf+QrPNtBMMhr4FLa1M49jhKAuvRHassIAw+R2Ai5tFaCNC5v6HJFSDy2t45TTCYbOAyM+V4TyO8P0XOZyh9x/kWg+9lCSdXn5XmVBdnECCQ5bn
 Jo5KyTcd
 WrEIz9/LPP1HQDE4yM04KzV96y3mwFrCJsTWMFYd99q4gXtX+F6cY1D+l/KX+ynvOcCS1SMIHUwZcR2fPYYC/5+06vukVLEyAT7vWwoXGefOBEdRGCqWZtOM6/wgrSbYeqKlcQgs/3dHe5rLsI1OEduk93dk3AbnTFD7sPHOQ0y9ouPqNyw4CDp6FXyecHpmHQyDtYmsuCiDaJYzgF+hViZyBF/XVxNybCHbDfYk3SLtPMdI2gvN10gx7iqdPzGxGdFsns2pK0JZlMsZFRWPW+h1Gt0rk67TBM8qsTxqO1PUCcyLvGZhOEw9OFMJ6owwtppEyHlOLhwHj5c8HxhY2EmieZAAzzC6AGnfQe1zebR74k9EoXVYfUDC2/JOglQtmUuGtvauQ63eZLphp+PLnycyBmkNx/ENJslXJThdlG/2sp21zTfqDCU5aHdX+7w74zAOL
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
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  77 +++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 .../gpu/drm/i915/gem/i915_gem_object_types.h  |   9 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  58 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  71 ------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  15 +-
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
 29 files changed, 420 insertions(+), 303 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


