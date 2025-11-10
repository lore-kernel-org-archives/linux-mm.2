Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16235CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A758E0021; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E1A88E0006; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E918E0021; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10C788E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB4981DF3C7
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:11 +0000 (UTC)
X-FDA: 84095133822.15.90D267B
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id D760F10000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kVBeK96T;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789810; a=rsa-sha256;
	cv=none;
	b=dlAEVbL9DaW782I3uWLDz7RFRbtLHF96xxhV2oFvK2MkjHMssOg0t7250mzxXbo5Ww/F85
	10Bk932tUy4tUcT1EkG8EPxTskgQxPMBcznWUHhB1xLloshERbE2TG2TFgsKNm6zTsSX7r
	5xtD70P9saXQSSW8g6Cl6QMS0KTBbhM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kVBeK96T;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WwmlBb4634bVW4zQE34j/oRCHmySpj3mCtYgJ6wCm7A=;
	b=d9V0eIuTPTGVyPNosd5jLqa8sjjIfCNsh/XSTok2igZ/+bf3jgukZ5GYLw4KIZ5MycnNYp
	ZOCEta2DXx7FJpTYTTRXpowq0DOp2Qc7W7l2WSzijNR/ORk7YGTApAI+rnc4AE9o71RcPi
	IVudByvKhjZUtb7WKmAWAYtpaUuo+2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789806;
	bh=p9SPlBZbb3hx77u0jsPbAy3OBjtm4qTHZI5QsOsS5bA=;
	h=From:To:Cc:Subject:Date:From;
	b=kVBeK96TLCe4OlS9VXlxGINkfLW8tU/oB5kw9/AbkQHxF73BkOfwfxQLi+26ZXDMb
	 WInTDEH0EMCseRiBqOTjCLSl1K3lqr/Yb/snuB6GzH1UEmc/L3w6JzyRCo3hEwLbm/
	 eT3V6sEySoSXmfdUDitLjBu5NDzCxolhrvLFco/LretkDrmxAyLwriOEtsnNFVvqSe
	 hP6AHszaNWp2O3aemirJ8fJfNLWWueZ+0M+wmKMT/3257BIYNXlarAvPrXsGYeZIwY
	 7cW9TLLGOycPOegO3iNIqcnnknyxcSkF0Irh+BC9XsaknN2HG3mNU/gSElbUPVIS4n
	 yyz7QV1R2pkOA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0961117E0610;
	Mon, 10 Nov 2025 16:50:06 +0100 (CET)
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
Subject: [PATCH v7 00/11] drm: Reduce page tables overhead with THP
Date: Mon, 10 Nov 2025 16:49:48 +0100
Message-ID: <20251110155000.2936-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D760F10000B
X-Stat-Signature: i779qd3wtey6owhd7zy9csr5z5dwyye7
X-Rspam-User: 
X-HE-Tag: 1762789809-668228
X-HE-Meta: U2FsdGVkX19sc5wBKsDfg1sBV1GgAiv9OP+v9/UFLNTo6EbSqRYN8ND4UVezQ9VLx70NnouoIpi/4ohbCTAMvLQUXZFOfB2YX5851Wv2uVrTjNb0v/vikh6ZN9qvAlLOtO9db9f0kxYtaxjtgCJLao6rJr5IrKG/zCGKVf8tlilHcjoBT2nN1YdqOlIdPH3/ZOLJT+zEuuz/sE1VmBUFoEPcitBPD6bfzU0c7x3GoLHU149zVSeZRSsomFY0C5PlcOHakUbZK7BF0xMGck3sdbJlZq/ZLu2gDu4yqN94TCi4QGm9D8K51XlpfJtgH/3eE8nXgTBpbSt5QgBI2qaT4rSH0anb+PMkD0HRAr0iY0D4dDCYZO7v2HtO2f7TqT8ZzorUkKiV6YO86kPeGG4hfRs1QxYCStUFbnctJzD64emhGoXs8k9Ao0ZMMm5FNuUlXG9KR1W23Qi0cvCu7NMDSZ4Hws3C4J5QQLEKMWnWpPgdbIbUDpnHQ7KKealQwrcI8JKAli+SRV/6gxB5Z4Bm9kBHVQ+wwRlqnp/An4pJDSSbFPLzIW3z7P8ngj7Pa+OH9nRkdKbLlmXQeVwzEKIajbBZCPTdXWl4Z1uYTu/lFP99l+hN2u7l57shU/AYXTc7PB7TXv9ny1rQX7kImrGzOFUaIqT5UvzlTvh6tZbY1iyMg00ljuY3uek5pX0Pr4Z5ZD0CYtRhecv5rCwzNdPCggIqHAE0069YN0xaykanZ56hnabrUz9S/WG2klOuEBJGirzDCBBg4gAvVdJ92ODvmxQj/ss+3V4rvqS3cVyTvul/jFgisWItvYQlYxDDC7SvdD7aWquxqm1sp+prLmw/+YYTNh1eq44HEym1aOy0llLJvsspAbOZZk3fjhbAMa3+QhgRA/II2SNU3dPgi3zYG9kMSQcDoQ+6fulsnnN+3IK3mbDR9U0JLGZPtw4PM3ObHL7FuYbZx1WWSrybDzN
 Fs5+XlFh
 9BuZg2uKPYQ3ic+LTZpKpjXhOU1QmG7NAw5BV4x8X4jaB2Ut3LyyC2ZomugdCyUJwbUHF99j5M19SFgzW7Xn9zDmoTgzE1iSRqZ2ERLObtmnf2vaqMzgUt5vyIEUt6oxpqoqyiUdMKkCdTYP0yE1PzU8Y5+gZYRm0fERD4Q7KgIPkn9iJRX3Yi24Yq2reamY9kqvO81LE/9mT3XcsaOWoP1VkYYzdhxzqZwMj/ToRU5FVSW5NrSl42O2aGh2tzjAE1A4qt8nTIfgOAJRVISBc7/TqG8x7+YrqyfnKuJaNw/dmOsWjxzD0jHW5HTqOeCMIbpaauWJZIHr6BebBJwU9L4rAQR5XO8bGnZP1ejnbMdV0RGm8w4hth9T3M2G52LEcBQl/48YURDreWzjl8IH51jFty0lAN5rThhGYsfyplYA/oqUKxRp6nGWVVW3WwYpSBNr/
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
 drivers/gpu/drm/drm_gem.c                     | 203 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        |  97 +++++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  48 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  71 ------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         |  14 --
 .../gpu/drm/i915/gem/selftests/huge_pages.c   |  11 +-
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
 29 files changed, 443 insertions(+), 296 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


