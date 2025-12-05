Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CCE8D2F7CA
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCD06B0137; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7E56B013B; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97486B0139; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B520D6B0137
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 521BD8A3F0
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:26 +0000 (UTC)
X-FDA: 84184851492.30.2768C7D
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89457160018
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="kPsOZok/";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925944; a=rsa-sha256;
	cv=none;
	b=Qlqk89fGwL0gu6kEDKkVKaM6MK0UjW7rZiQUyuK1nfi0EPA4JS1sZYd9Rln03XucUY9NeY
	qIhUhO+LkAGToAmpXq2rGDC8DrLZwRtlVmDna+axtLMd0SgLuS7vgrdYw4PxdUd9VYKUzw
	4ttuFKfbMw3OiABlwehWykJkqGkKsQI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="kPsOZok/";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QZRMEoghRjJDFgGw2lmjm3MfAujLSaYIdC5aK4c4WBI=;
	b=HwSUsBmf0QgU1qlNaXJZuyjORDxx4oDkQl4zgj8AD4chQRsCCDEveAPAbewji3ai5+TJuJ
	LH9ORpEMxR6ttmUAM64J4LTwfmBZoBpCoS4mfriQRZUz1HK+oy4VJ4KnKBCGMTRGiM1iuL
	ZcJT58Q4xswscGBewbS30ukTpA8jHVs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925941;
	bh=Gv9dNnyumHXwQe7RA3oVLD70kmogEg5WcdKMw4U/tjs=;
	h=From:To:Cc:Subject:Date:From;
	b=kPsOZok/fDt+c79g51uUp4RnDBEGzJrsth1CQ3oAulXZcvwgmKOxLOZpGmZZy8g7T
	 VkkXJ9RdHYSv7fGXpgaA14l4SLtiqzRg0qobaCbqs2cm4Vb2IQdNJ5UupXvC2nEYHE
	 7pwmITVVXLZYsj7u//wVf8r4zwLlZOsEwuzz9Wk/yLKuuQINx1tOEojeR03YJQlO1M
	 vOZi1oHEBTSTSZoNh+0unnS2aBQUA/Qs5Z19TjofzJi9cWymBblHKXmLDpjMDL2Dah
	 prDOFjXbSN0infIMVZVwRF+cFYtsdObNGVtC4VVbSeHCKU+787rVN6O+EuAarJW3IC
	 sa3vWJi0X1Yvw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0697E17E1146;
	Fri,  5 Dec 2025 10:12:21 +0100 (CET)
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
Subject: [PATCH v12 00/10] drm: Reduce page tables overhead with THP
Date: Fri,  5 Dec 2025 10:12:06 +0100
Message-ID: <20251205091216.150968-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89457160018
X-Stat-Signature: ofbxbsunoou8hqot8w9ezt1o64gbsy11
X-Rspam-User: 
X-HE-Tag: 1764925944-842152
X-HE-Meta: U2FsdGVkX18HDjxStBqeZ7oscU6ztv5PjigVXDoarfetG5k0fPxMAiucT72u3z10K2BEwnff+MNrUzS+p4iUowJpvRCTrK6cMPBaoQyWOTb+Qn79ZscBuHdzINYav1idShr4I5ilUvApP+DCpvixPN0krbp/zplIQ7XHufI1raPeucfbmjMm/pkNWj0nxBLS+NtxCcKtKGvKTS4b0qxBbK6AIzoDsg0Fap0b3x0PyBrHVGETQy3dL0IRat05MP8yuJjyuWNIXld9UD3gKVcNxx1XbTpIu9u5+qbgevR3e2FxY1FbQ6TPoQdVN7u2LT6Ba+x9FEbuuKrdTzHrPzUT8HSX3ewIJ1cIoEp+H0QY0F+p4pZCfNDU16Ta2+7P5xc40XCxbkd1cLvrzHPSXaUvmsSCG04t3Fjv49eKBYIda0hGwZycfwdb4OtanaE/c5bnI9ZeNOULxcatPZg6xcgrYJFU96SjoYyr08S4M2PHp70QRdS8JVqZJxvT2LS4C0nq9PiuOdLTvLOI1TPtb23CAMW5s0BwQuK/oDxv7TLPUIJgQYqa5Msi5HE0GiVtfLfuV/dMXNUSyxDzwobM5bCXpfxAKcTAWqfwrXIEK/FS0bdcOXTJJ5K+7bmcu22QU0Il2wIwZvRLF455HS0VNKscX39Iv14St4JKhwP5JJdJdzsmgGXHIUMkpleyOE52qasWDr58vZ3rZXyl4m6LjHx2HmyLdz0pJXsmPsYNBXIkt6orNM4VG68a8gh4nHWtkzU/cX2jjCikNoKJVWxadvCcDzFacsGaHorfcaTjdKe8ob4mnJYzYWTIfdGRmv7+t0b/dqYWZOSkh1OL3e71cNQTsZPFPsSGerM2evqReWyzxG3rrLOK60c/GnFCgGKimrkHhcMb/OFUkKaHxMK49I36WN3qYF8oB+6LE7H/Cj8Vp7APNE4bTIv/HhqkdNjGZA61PWAOPOpEtNZ8QtOt8bb
 4751vgDP
 x/oEJZsVU9nua0M8u2HXM3LlbuUB4o9X3UxWnJaud4W2uGpmVaP72vFtETylSlJSxa2YgTmGVEMgZ0lBKCFydMQzmj6ogeIo2p+ezUGJRO1Eil3JZdfUly0RSEqJxm2mKwoLCiSG4A1XzqGfNbF1mWp9DmuYDWzgzALzUWD94xA8kzw+miLk3TDYz2dmxNsD2HzW78eeUCxABFSFuxPgQ+vC5ku9Wse5afb/xjMZeTFqge3EJUNYKBSYjc2jnZnmqotNJCwsACJlsUTuwRAXdXNae/s7PJIrUv70DKLRsZDIU4SaTZpYWCxGriCqOUkHL2lLvLpigj55wrTWe5db3QYvqQP+MMbjBzqb4oaoWFjFue08BVAEM5eW2aTK4C8fLfjZLTVu5Pzv7jUAXEH2bFzmYGgqtziHk92SGycwZMCbunJv6ylq9/Z48YORrTWvtJGqX
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


