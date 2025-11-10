Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336F0CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EFF8E000F; Mon, 10 Nov 2025 09:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906718E0002; Mon, 10 Nov 2025 09:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C068E000F; Mon, 10 Nov 2025 09:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E87D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:27:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 089A112A9AE
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:56 +0000 (UTC)
X-FDA: 84094926552.25.8EEE563
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3D98B1C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Cg+ZW5Um;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784874; a=rsa-sha256;
	cv=none;
	b=K2mIqsLaV7PyLhCYjfaW8GX1P2ltWfu4HSSF98OIBylaoiRTArJYZtb5hkmgo/SVJUlDJu
	aSzUVnWuy7fd7aKPiRLc0T0bt/CIIYafuhtW1ot3TA4hvoxivzplCh7ajztmS0jXxyxzj6
	fVOi3pcR/2WDFRHiXcOVb0FiJF93DUg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Cg+ZW5Um;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eNU5xeVUnDnpXMG3QSLmhpQEP8LkTfh0peCvQ/AGvPQ=;
	b=05VJJQ8u8B9JudDeUqE0ZN4/+9bOmmqdMO6A0+nnDIfRxBYC+D8MI6igt0n0NkSY3AHfQ1
	k1nHxwJb/gaGXR238HCbkaDACHlmcMsQsrcouP9XzhWyCcKoPqns96MUrmXKIbY+Yz49bj
	dEF39NYrP3LZUsXYujdOk/pWQszPkUg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784871;
	bh=I3hDlgnUiFEeHYO7l/Z1ZTVOyh5tZR91I5wEgfYLxhA=;
	h=From:To:Cc:Subject:Date:From;
	b=Cg+ZW5UmcV+OPWWiVEIBEa71YhgKHcLsSHBua7s+xkI6A6fo9dVDIF0jxdDR9/4wv
	 MjA1rjz8N0cDT6mEz+IEMwv3O+R84lHlS+D/t5vLSb0p88yV8ct1kCcqxhlXR292s5
	 n9Um2Vwfx9ZpZBL8HAEmAVSyhGDdJfur9x2h+3L9zpKghOdQBRumTmSI/i5AZuTiqt
	 Sbs1UnPBOMo5g3+xvmhQ+KDbkoNeTRQpOdQ9u7k+3JNGxgcLxf/IX2EWQB6Sm7j7BS
	 YVprWLa9yJWr0bZWJGAIx5IKQNEviK/rAqlW/sLKIUoJF+rFkUUAxJcx4RKj+l7NNO
	 klylxUGZLn0Qg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5A6DF17E1313;
	Mon, 10 Nov 2025 15:27:50 +0100 (CET)
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
Subject: [PATCH v6 00/11] drm: Reduce page tables overhead with THP
Date: Mon, 10 Nov 2025 15:27:35 +0100
Message-ID: <20251110142746.3490-1-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3D98B1C0004
X-Stat-Signature: r99utnst1q711xhob8bytgdfg4yz6xc3
X-HE-Tag: 1762784874-949416
X-HE-Meta: U2FsdGVkX18r1A1F8TYEH7KAuxALxHqRTFvXabuFW+KvKKjt4So9DyAVYPnPmrpcFS7MRQviOCBAAHwSo8c4MedQ9dMnwMzM1wyk2X5ZjhTlH7crcBhQyWvG7vSyKh5gOZ9esRRyG0OOTzauxzU94a0i+LnZ4e++BmqiNOWXpt84ZzQWSjBj36jhZ5twN/KufOcHepnky8bNi71X1amr2JQZjNBBJ15EpgQnID2FoWBnsFNKk3h1fTuew/CuZBCrX1PnwOIamq6okMm/c3SqbTqhRHnKmyV9X79MAfkkKG391dtTPJgeviPPv+NdowXISeyZGmNU0G2Ttav/SMGroRKLAK6uSf73Ye4DwcN/yaN8MeDSJbrRk5r3LPEW+y/WFNQ8eE1Ha4HKP70dBllLOAWdNRkwwOBQ71A7nJPqJ68aMD3aBtKPHjiE4OR1PkjXeNHPChBSDNtwmxk6n23s6EMXmWs0eq4IJ9q0vTEwBhgADwWG8gucJ2vzxkL8d8vTP+pujm3jx4oEbcJnbzpGaamNpj75T6o0aaV4cXp0UwNbUsUNZwtO1tk8JLivMrld1XRHynkm652AErFO00ngmsqJrKfOZzHMzvZTryPbW6k31JPZwSswVlY7dhJB3L4UbqAzuX+wsE+uijl+iWKhQeELT9H08II9Xc11y+cuUYeyOr0iMjtOmMFgk+ofQDS0bACsS1QJ/eagfIGz9d5CjJIvtMnKQKTM2HbNrYhiNXD3ldOLvYZpD3soCmYYu1RPVD8AbYCgwp+8sA0yzZBaIVGLTk+ykEZ69hyS+WOLRs+AbTSFa5BbL7XhdMbLdbMr/2qn+xJbSwGSjV01cGYR94LLcharcJtCg+h2O08CUxGVTcCcO29L4hpL9XutzvoYIZiwr+iwWOhbmawbqwlAcG/C2B2Cy0PCxnh9W8w1INXKTn3VK05maFpFRO6i9TMw6RaBkhYV5Dx6B7e1ndz
 5yl0DKj0
 /isp7L4bIaLiug3wQVcMRaF6p/SK4Nr8Suc6SA8iN61KC+LhJ8e3RyxeHXYyEz+97Uxdu2c3pphPWX+EBqNKlRHAmGXImgpiYmId6MG72wCDqbx0B/i+IUh50keP0v7YY5EoPh5r93l87Q7TPP7lQNRVzpM6kspdlch4HWOkeXJOAZywqpY/COxUYuCvASLmfk/3Lmc5ue7UuFy7bF1HwipoAYQX0WvgJwNdL89R08Dk0TMP7c8FU2LI6OrfQTjGsqCh5YW1oPjAOezaQn+Hz5T2EXOTjMouBSlvkexfruNx1Dvwwn033shpG0AKU7MMxFhyCHkCKTDx7Dns=
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
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |  47 ++--
 drivers/gpu/drm/i915/gem/i915_gemfs.c         |  69 ------
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
 include/drm/drm_gem.h                         |  37 +++-
 include/drm/drm_gem_shmem_helper.h            |   3 -
 29 files changed, 439 insertions(+), 292 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

-- 
2.47.3


