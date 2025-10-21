Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A37CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00448E0018; Tue, 21 Oct 2025 07:31:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF638E0002; Tue, 21 Oct 2025 07:31:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77AE8E0018; Tue, 21 Oct 2025 07:31:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0F968E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50041140435
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:00 +0000 (UTC)
X-FDA: 84021904680.16.4BB5AD7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E238160014
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:30:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AHmyR08t;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xMfMp7a9BwF7Stc2RJdmOPMZ0hShGpUaNAxINdY9zGs=;
	b=Y4XtZiXCHMTukl7VelHUmOL1IQ0hX9I4M6GZE6UFYvwPbNgvd44JwQOXAqcMSLvAMWjlu4
	VBKmSMJDUsWoV2jPsMa6xVvRtEFP8pVV7Uy7xUW8q3wzlfqKg2niH9l0XzzMygPsHcSO60
	qfOTTjlmP2XuGi62MYNyj35hIrGfy4o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AHmyR08t;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046259; a=rsa-sha256;
	cv=none;
	b=YNOvmndFmbfOL7yWozIJbuQmn0wxn3k9+1malzy4XXsJCiPAJqTndEEYodnUATVhcVFzWO
	x10KdcviLXus+juO61zMVzxRVhTC3V8CASryH/95xl/KAm+8DccrRhWtd81w6Qk9qAKgon
	1mZwZS5r6MrEGSnUJ4j3gaf3O/YKSeQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046255;
	bh=W6xHmv8+Mi9P5OoxStkwLLPt5j3jLHnOTcNSO0Jg0pk=;
	h=From:To:Cc:Subject:Date:From;
	b=AHmyR08tB2G3J/sn9dARyHQC5PN8/CsdOZ20Jo/YPza0VhWIPPyoWKc+yVrqD0N8l
	 BxY7maAFsPGS6VRcibQAnfcxxNvgZu6b6AiPknxVpk/zS7mivA07AguIdtXrGCjgle
	 dqbCoeV73L+buesw0pdbB76vLyaMBFkpfT7mQRlIGLcR9oezn+EAxBfYyZqDS1Aa2G
	 /1kYwhsxmvIlq9TkEzuT4gPItOG2orS8CN1GaASyyfhcckiBeam5t/05A038C4iMe2
	 4Tc/ZiLOcYSHzC1WZpnFDdMqkfCXorqFe02TzPjEE416F+YNjAtFtmmy3FY41ZQksO
	 XQLx4I4TPvoVQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B547A17E129E;
	Tue, 21 Oct 2025 13:30:54 +0200 (CEST)
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
Subject: [PATCH v5 00/12] drm: Reduce page tables overhead with THP
Date: Tue, 21 Oct 2025 13:30:37 +0200
Message-ID: <20251021113049.17242-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E238160014
X-Stat-Signature: qnhawm9mdqenqk8bygeg7bymjw7ze7ca
X-Rspam-User: 
X-HE-Tag: 1761046258-291866
X-HE-Meta: U2FsdGVkX1/1h+64Hn9qG0ujDegVHRJIqn1f96Ffb4hSPdjXfXeOZzBg6xiZjJGl0b+0ZhvVKfKt77X1VdoqGIrG03OLZZbbsLlZBZGS0/huGn5mRJ4gBJH5drbfO0ZdKtra0HpZcgEzm/yCG0qYp2oFt5X4ESY9U+ZfoydNrtSqHyAtnR0K2N67eV8bOnq71uh0/XHhUVWFPgwqvChbH4jggxLbOjEmaa1RFD1n5mDuMlAJ99wAtKjVC9SQvDdznaYlJwYapHIzxAhE0hXrHyRM+riyaDgBZEqqPi6TButp/cB5oIBd52Pgg77JZZZGfRRnSPwdrRKU/9S6oOVXl3jukmi/hMSBzFfegEEQ/zko7o33O9o9UFkA5x5SsovhHMoRqNYmSD1FLZBy4Zv2lZ5cgKopbOuW+SBB0kQblsRYe3x5FWHbwrwoxAiJVK1jQONr7Qi0RgcRcJKhG2hyeX5fsVnAoIUXUistUxjLuzPtEVgdcAVb190fTL+Cpdl2HBAslhfIt9Z3xuxn52mnOnWfbfS8C5nxvsPVt3+NcSQOjxzflBoogC+71/MFhc4U2nu6O4zyrxTQ+11sWZyBiYgViHaCpD7acvN+TXQqX9UtLn7Z8/e0yoS3P+ZM80h/U6ZFRKMdu2+oP77BYSfMIBxKm17LjR0KctHnLsYOD+0SlmSZy6qv7Rm/sAond6N8/hB3vinHjIYgvtA/OTsEEtmcbTmRsyqXkM7l3QueKvQlS8S8okNVFZ5hZsNK0ZjvnPU4+tveIT8KJGVrp4/sQCMkbhfywpv5MUAAh2acnwIA7r6pKGN2a10zLdnbncXQ+u3he04KIzJ9ffnExCETbMofC5oCA7XzVEimvQyFz/e1VDYwF2Ma4Y39K9oFbeAke4FGiHL37PU2w5Fd8jG6BnvOpVeCzMwQbeduduuy0m4E9sCIQB+OTQ==
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

Note that some architectures like arm64 with the contiguous page hint
(contptes) would very likely benefit from a vmf_insert_pfns() function
based on set_ptes() to insert a range of contiguous ptes.

Loïc Molinari (12):
  drm/shmem-helper: Simplify page offset calculation in fault handler
  drm/shmem-helper: Implement map_pages fault-around handler
  drm/shmem-helper: Map huge pages in fault handlers
  drm/gem: Introduce drm_gem_get_unmapped_area() fop
  drm/gem: Add huge tmpfs mountpoint helpers
  drm/i915: Use huge tmpfs mountpoint helpers
  drm/v3d: Use huge tmpfs mountpoint helpers
  drm/gem: Get rid of *_with_mnt helpers
  drm/panthor: Introduce huge tmpfs mountpoint option
  drm/panthor: Improve IOMMU map/unmap debugging logs
  drm/panfrost: Introduce huge tmpfs mountpoint option
  Documentation/gpu/drm-mm: Add THP paragraph to GEM mapping section

 Documentation/gpu/drm-mm.rst                  |  25 ++-
 drivers/gpu/drm/drm_gem.c                     | 184 +++++++++++++-----
 drivers/gpu/drm/drm_gem_shmem_helper.c        | 142 ++++++++++----
 drivers/gpu/drm/i915/Makefile                 |   3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  47 +++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  69 -------
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
 drivers/gpu/drm/v3d/v3d_gemfs.c               |  60 ------
 include/drm/drm_device.h                      |  15 ++
 include/drm/drm_gem.h                         |  59 +++++-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 mm/shmem.c                                    |   1 +
 30 files changed, 491 insertions(+), 292 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


