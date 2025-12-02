Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E2AD11707
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB3A6B0010; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FF56B0029; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BEB56B0010; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 410596B0022
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F857C05DC
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:28 +0000 (UTC)
X-FDA: 84174128976.24.7F6F6CF
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8247F1C000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZLAO+ZGj;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ul+RjVqTlsty4OS9oph2p81BfaTCZdR30Oh+aCN0TP8=;
	b=RQBlyOJAESif05K0/+6ObirLDegJIbzxMtmShGFEEbQnZoWfuJpe/VWyCj4xpUYjwTREIG
	AaAs4xMtqCMGU2WDGlgJV8Eg1ej/7PWPaoubGgs0TARU5gFFiqj26pHY73trlRElXOYlZu
	ZYP9S/E/twdiLDSIjng2cb7nIjxdQEk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZLAO+ZGj;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670646; a=rsa-sha256;
	cv=none;
	b=wlwpq+jToBWuYP4hEv/evoUi+dJPKIRrEmOwbSTU/GZBckWdHLl3a0DcxQEhdEKvsLo/CE
	NlGE+iCqLMRlkuhTCChekHXg1Lzs61rRM7JrOr4BkXGoKaAQDcRh1sZDsHXXro0D8fMO4n
	KWS1Rrd8vi9mt+JBLwKH5r2rHhCYsZk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670643;
	bh=kdHLrkRzJLri/Zem9ZEPjcDruJpnM9kiLoeD+kH2zfc=;
	h=From:To:Cc:Subject:Date:From;
	b=ZLAO+ZGjGoDtP84IJfsQblBdkOgnkYu6ns9BAXW+8OyG3W+DMo2O+3OEzkbOk3ja6
	 /BSkGHarnu4GJXAADRwc2QtGaixAipYtGAt/hwR0xLYkQu97y4Yl1IhDjhSkXZb8L1
	 NDJOPNagL+GqqlaQD7+trq3jxgp9BEgoCt1fXlR2ZZwmhncN3IbTKIKDz/LBXIX/wJ
	 CDd6SWRH2zBjKCDerhtPvnGA1OOBXW+Skc3vOHTDWt+Vgc7JJasP2RSm4hkEUSAVt1
	 /WXz18u6QqioKQgtP1cHQ4HJRD1zOVCZiuMqpOodLQD7ankM0RXEjh40ZhHa7AnxTO
	 b45y/ps4hNhVA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0D62A17E114C;
	Tue,  2 Dec 2025 11:17:23 +0100 (CET)
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
Date: Tue,  2 Dec 2025 11:17:10 +0100
Message-ID: <20251202101720.3129-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8247F1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: ur43msfnxkrio6919mp57ybcsjchy1nd
X-HE-Tag: 1764670646-79349
X-HE-Meta: U2FsdGVkX1+XzmemAPQ+g1oqUWL18FVh9dpqMIY4Z5Z3317CBRq8ZGco9+fwvmvPCJrTaxdODlLs8LAd0Jogc5wqy0T01LCSKh7+RzgO84DbD3T5DiADjQe/4d/kbCuISuFbjTnqr8mvjYgjxvTSzm6qWZMQRoKBOYosOkjsA85T87LmbWKaqruFRQ9BxkgfYNv4AYaxu/LM4MgmzjsEif8odzI+C+SiddSxB8eF7AFrYlou4VYg2J2xYC2At8gQ5vAsw56GW0ppNHBmhjI6HZm2ILi5t6o3wjPy4lKK8Fm7Y804zNtgij3SAmfDYWCPZxong4lgK/heSAGNYbjVwlndzgxrtWTL3cDvwqYE+YRFS12VU0eM1dBg3mDFxwp1yMBtD1FF2T8OYkYypDWHpMPz4Ub73LllheYxt6DozsO5MJYI4rnD8UcaoEGTPy9PxSLZZL2aq7bAz5XC5r8vpTy6t+sns7GrO6ULW6zP1BBJ5YqBmxBXF7Aa6PlV07CLdovudW+2vG03Ck5DufqzVu5MOYdrYoV/DsSdcxZuqa622V2zBpCwsqnA1mLJB56Jh5P8m8Vrb+Z/1NmESiyxP9ia5gGY+vi0U0LVy7muORiJ8wIis5J0xNmqhaxGJPY9kjT92U9okY4yQmlEXBpwbg72ZY0GLxVfTJmidbfY+rw1g0fZmUEDB3Ntsm9CIUZD6I0DB4aRZMIQa2z6Q39QvxkKcmLrHU/lEyBcWiB9B0X0TkWaL6XCOgrqc3Xe3Gp+EqPo5yAEXul650cI9QYWJ19IBxPQf4YpWFwoP4Fz4Sd5NX7Mx6slXArNZWzR2nBdFlX8fwFRtDThAsrHe2qjUoc56kNMNOdWeh0k0oGIIYaRZXtLCtu8jPDezQ5OAVftJPF7pPId7NY1kTt1ZPii22QqtWCz9FEEp0xYvvR9DuG3chQSLX21WGuifPFIvgzUfSoVzQkKpIAdF/JQYii
 +PgpR5cJ
 xiPlHbVsL6bb4DhficWg6SDOU31/PmHVqk/aZoed9iq5ojeddJ3LyLy6f9asj30ycCbF9VVLgZirJ5tci6QnQfgUn9npaP1jqIIotGynNWJDqF7bNTD7SenpoKVJOJRw01l8vZ2Ql5SezMJDgHvaMjLff8LACdAa7iMBgP9mNtIh6O9mdPjl1ahOiIMJkCy58nYFPg0m1AQshlSE/YD8ioPkrK7zWNIXMNK1aH9FYN+vDwL/FxwE6k/62g7rtfUbhk+8kJRi0MA6Pc90gAaCJD5Woh7ubf2atVggS/oVsfsfi/W3pzFmATPAEVceKjgUCwTUMwamL4nR0zio=
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


