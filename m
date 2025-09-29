Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357A1CCA468
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D7E8E0012; Mon, 29 Sep 2025 16:04:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DE68E0002; Mon, 29 Sep 2025 16:04:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4439D8E0012; Mon, 29 Sep 2025 16:04:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3DF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B73AFC04B2
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:38 +0000 (UTC)
X-FDA: 83943365436.08.29BF5EE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id E44F01C001F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gGJrNrzT;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rwlqUkWOGyvrGcZjeeXRZCe/CWuywK7+ufPNZBz2vfo=;
	b=VGNHDsExerA/TUayhbvsV2Mp7yO5mam4WI7RtjW6uVU/AnEX0r/t/0CAy5qPxm8iHaaxU9
	C6RRfMV2cv9TmikbN8LRsmP292CAypp148e4lqrsZhun1am6T6RItcaVmGYRc94DK+c8NL
	A8cHJha5X6KFBuKjqyEO2UDlBdf892E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176277; a=rsa-sha256;
	cv=none;
	b=a5RRfzxepS4RwqUg/85FniUDOAPNsHLhfBDtlnxN81+O9QGPEBYJfxsbXDNjZK/v0cBWZ6
	/9BBuTJnGQ4Bp/FcIUcVVX0VnI0W0digsKBws9sETASX/+fPV/C0q08Xh6r9ruzD5w8gAo
	HITksVSyCYFziyZw+HWDdVssZV7PTDk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gGJrNrzT;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176273;
	bh=dkRa3F/RjStNkVbhPhsN2OogBfmvPdqSm8pHIAsLQp0=;
	h=From:To:Cc:Subject:Date:From;
	b=gGJrNrzTY+T1Wttfb8CmxmIiieYIux/itfykNvflKdkUTIcVB10rmRZgGY2Qw05nq
	 NGDOSc72CmM0spkV7cd6m+N92f78X2O6YhZbwF6hM3yUv4hTFCoRBlRaz0dDw1kDzn
	 K92fiaZ1tpMRXItTKoz3OymbRP5sY279W7qXvm8qjaH0ECUkzB4st9jI7q8y/gMDCB
	 ichJsFNPG9o/79jtFHngcZZgomJgt4a7WIIPnUCa4niC1Yha1HDXNIEyXdsTVyvtQy
	 /TJKMrNZ+y8j7cARsRpldzxsPmC3rcc3n0God8I8i0s/ey4V7ZQcZcNHVe1YIGkHo6
	 7y3VmIOZOkr1w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 32FF017E00EC;
	Mon, 29 Sep 2025 22:04:33 +0200 (CEST)
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
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH 0/8] drm: Optimize page tables overhead with THP
Date: Mon, 29 Sep 2025 22:03:08 +0200
Message-ID: <20250929200316.18417-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E44F01C001F
X-Stat-Signature: csa78xy3rnok84eh1wmr6c16qgg7qwxd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759176276-579154
X-HE-Meta: U2FsdGVkX1/0Ungwe5o45MRhyk0ex9fEmRDt6firUA2oqnC2YB1BJOMBn/nTSDJHbMIIakALaybd6gsalAtTViaxg5402Uhrkv7mvjyWsuPM2417/5oRm+X8NKVq9m757E+OIR1/dSM2xwfK05kAVuduLUJG7R+91MTNdexoU9rTfhIqOty/05guU4WDeaa4kASHMExK4a8TW/HQWEvA34PK4R7K4tJ0GNudVLZBdXH0jnUJOrswF0F5ZggWP3sbfLEqLmWVfnRSSGd1VHV3o0tZIluuhm/fnJJ6ofD6uti1DdYJpl0negL/yVpj7CgwveQfPu4dQFhIDTcrE5dbEvvUTc2umq2MBv77oK009yNTzSkjVIr6kJPI9VI+G+/2brEjtHJXkeMmvhxE0lF535W+yQufS9cX3eb8xbMi11qsXXYAr8f5pmtveecGdhGPH3QirjTcKFD0lsdG23147wHVfrxCODIh2Lxq3j4C+X38NVm2MecCfB4DC6rlbDAV1+DFpBV6GXJe0XCIdPx3JZqISMAQ1G5jxxekSD8hsM0ZRObbzGdZ5iCKujjBi0lhaE4f/+GoKSWemfiPl/lbJ8QX/LLPY2NpZ3Sg4yj1Mqs86jkVjpsHVWNXttLzH2hjgdxcnuCeJj8ji1uAjvYfNU6TDDlk1/2g2HjvVbNq1Z7Xffy6gnthPxrgcY+szz2QrJkYFIIm+wyxnOSI+Vb4frqOsPwKL+k6LhBgtWNffhziZKyeNCMkBugPGAWszRGyySYSRwr10d4XDG0ANSHNjmswpnzBzn4hypC/dOaO0rvkKEN4KAfaD+i0gLDnlXjGg6mie3arjWNgsOroSHiwSMEkzIAxQ79Dww10z65VMryVvzL+KXTGcP0sRJyVZ2iZ+csQEYp6RlaHEYS6ZPsEyR2XJ9RmcEp+G3/GVLe5ceanJgZGLV8pLdS+ooqBsZwjNa/bqR1+VwoCbLMHEkI
 RT4CS+5d
 IPB1jS7RELuPz2KUTSomNLK4wXu1tY2s8BDkBt9Ivj5MDaNS8yc3vnTdCkXdMMN7FseyEwTT58bZh/yNA9L0uu7QbSOD5ODmzZjHwf0ByZGUEpzrr47Eql4bKYLT5+zwaGA1/TjCd/Ygd3k1MCoENJIhALP5VLXCtrJJ/F7cuo1TiM9R3uz8GCWhRYMtEXyQcyAXwmYacosJyFl+rcoaWVGI7kWQiQuXxeSvruwjKRVYHADxBvgM/V7swafKpqbDXHoOAxwN0Stk57RAAoIMfdZ2sCbL5Rxpjc6QVrRdLOp0NstwcTVv8ggdIknSk97uyOUyZfTLnSgsSsN8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series aims to reduce the page tables overhead of DRM drivers for
builds with CONFIG_TRANSPARENT_HUGEPAGE enabled and either the sysfs
config '/sys/kernel/mm/transparent_hugepage/shmem_enabled'
appropriately set or drivers using a dedicated huge tmpfs mount point.

It starts by adding a huge page fault handler for GEM objects to
insert PMD or PUD mappings whenever the shmem backing store manages to
create huge folios. It then introduces a dedicated get_unmapped_area
file operation on the DRM file descriptor for GEM objects to get the
best virtual address alignment for the underlying shmem buffers.

The remaining commits propose shmem helpers to create and release huge
tmpfs mount points and adapt the i915 and V3D drivers. The helpers are
then used to optionally enable Transparent Hugepage for Panfrost and
Panthor.

Loïc Molinari (8):
  drm/shmem-helper: Add huge page fault handler
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/shmem-helper: Add huge tmpfs mount point helpers
  drm/i915: Use huge tmpfs mount point helpers
  drm/v3d: Use huge tmpfs mount point helpers
  drm/panthor: Introduce huge tmpfs mount point option
  drm/panthor: Improve IOMMU map/unmap debugging logs
  drm/panfrost: Introduce huge tmpfs mount point option

 drivers/gpu/drm/drm_gem.c                  | 110 ++++++++++++++++----
 drivers/gpu/drm/drm_gem_shmem_helper.c     | 112 ++++++++++++++++++++-
 drivers/gpu/drm/i915/gem/i915_gemfs.c      |  33 +-----
 drivers/gpu/drm/panfrost/panfrost_device.c |   4 +
 drivers/gpu/drm/panfrost/panfrost_device.h |   2 +
 drivers/gpu/drm/panfrost/panfrost_drv.c    |   6 ++
 drivers/gpu/drm/panfrost/panfrost_drv.h    |  11 ++
 drivers/gpu/drm/panfrost/panfrost_gem.c    |  29 +++++-
 drivers/gpu/drm/panfrost/panfrost_gem.h    |   3 +
 drivers/gpu/drm/panthor/panthor_device.c   |   4 +
 drivers/gpu/drm/panthor/panthor_device.h   |   3 +
 drivers/gpu/drm/panthor/panthor_drv.c      |   7 ++
 drivers/gpu/drm/panthor/panthor_drv.h      |  11 ++
 drivers/gpu/drm/panthor/panthor_gem.c      |  30 +++++-
 drivers/gpu/drm/panthor/panthor_gem.h      |   3 +
 drivers/gpu/drm/panthor/panthor_mmu.c      |  19 +++-
 drivers/gpu/drm/v3d/v3d_gemfs.c            |  31 +-----
 include/drm/drm_gem.h                      |   4 +
 include/drm/drm_gem_shmem_helper.h         |  14 +++
 mm/shmem.c                                 |   1 +
 20 files changed, 346 insertions(+), 91 deletions(-)
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h

-- 
2.47.3


