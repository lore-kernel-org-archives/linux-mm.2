Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4500CD25036
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 20:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A474C6B0088; Sun, 11 Jan 2026 15:59:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA9A6B0089; Sun, 11 Jan 2026 15:59:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB8D6B008A; Sun, 11 Jan 2026 15:59:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74ACC6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:59:08 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38F051AE95F
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:08 +0000 (UTC)
X-FDA: 84320897976.07.5431BAB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 148F8140002
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 20:59:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KCr9Phyf;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768165146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZEv8icGYn2/NvIbauvVBK2h6w5hpiY+WnWQJBv0zutE=;
	b=FYDcVpnVjh6EqcnP/CDz/e+PN0Vg9ydmw0gyxemBTU2QclscZ9qWgIKiVcSaaC0ss/9q+D
	xU4/0qQ6UuZV+1JwUDL0rOIeSzwt/B/ixHouJqW0q/fqvU2dIPKzuweAFxPfMTxCCRX1z3
	GW1shJPs8xl36RU58FGOoHqhrPfDkxY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KCr9Phyf;
	spf=pass (imf26.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768165146; a=rsa-sha256;
	cv=none;
	b=iDp5OzzlUytRiC0ixeYRai3Mt2L6bligJ/sgNxnyDOEhyvg2tq+yXd3rTIV6XcmF8UwFFy
	Vx8IOqloK7+zpN9uYy1lJscNQRrRR+g3y1dD1aoM0ohsvKtWU+XPUXGQcqCjLhFfg9Ldde
	bJyS3myTSOdyB0tJ2p5suh/Pv8Rr6mQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768165146; x=1799701146;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JowSG+4tQQyTE47Rbtpcgaez8ldKvXlCh+DCDwat3uA=;
  b=KCr9PhyfERHVC0FFL5f0bUnE3VBF21GzZpnAjMAEHSHGUNj4X7Jm2EGl
   VFilqUcSVnIwPkpWjd7hqBrKVMahXaa9YJbdJILBKrGQLJmjnOpG2eOPw
   ikQgRZStF+jT3w5YWGcPtxb4T9hVTXL2Bd0T+HNhYp/+L1aQFbgJgrCiZ
   2ceIyJ/X907T9eoDxrv4WDdvTw1Vd+Oe7J6QNQ8b9//uMD9CRPWv6ty4L
   AmvClJoQCX74BlkxIVUB1P5fxuSriiV/lJThwnBbrmrm3qvdFdeekJwls
   8N1kYtUAvDP5IhtYmGWSTk177GpTV5OyWfR+2zmM/NRixi/nXE5ob2x+P
   A==;
X-CSE-ConnectionGUID: 2jK6HMX8T8C2dnLnWPsHPA==
X-CSE-MsgGUID: jG/8izoRQFmhGXIPqeRB6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="80904648"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="80904648"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:59:05 -0800
X-CSE-ConnectionGUID: D5xpyBpvRRC3zs7F9qTySg==
X-CSE-MsgGUID: /4GjZEskTMOj7ia6RpYfqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="208419944"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.11])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2026 12:58:55 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Francois Dugast <francois.dugast@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alistair Popple <apopple@nvidia.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 0/7] Enable THP support in drm_pagemap
Date: Sun, 11 Jan 2026 21:55:39 +0100
Message-ID: <20260111205820.830410-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mkd43xatozh7k8dfzy1kqgtu7ez6a6ed
X-Rspamd-Queue-Id: 148F8140002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768165145-554127
X-HE-Meta: U2FsdGVkX18AefiJCpYPT59+QywclDXMGQbc78icJD/ITk9+XHOkFbxB1PhuKg8GAXM3Tkf7QjnAAfErB5nEY1xt79NMTtuSEFM1cNrUK+32awXsPFFgxJVnzohBxH7kSkWVtw/Dv732HaXVA+vodTLUKKwOZGe8yrgzWcEUqoG/IbVmOEFfDDGCKLwbfuy2tSboHDVhW1/tD2afhK2YAQ3bkGuDjWSog+tmzJNCxdSKrFvGMPNAgZszYrVbQQ9lLPzAC+Wh43LqdE/KUE4CUVpwB+CKWXEP2y0B87rUye8tpw/94RMOYBT4lITD7q3q1Iq09LflSYvYhtacgPP8N2FNA+AQn9yH7AvYzC1eSaxr9iifB2mB7YTtbteWrlkIXiNf4gVgvzRHXT4KEWMwGmQk42K5eX4pL50QpAmM68tNiltv7pytxcDL5LhyzdSq/I/Rem1SSzWN9ufV7KtfmZq2fiOJLgueBTL8OWkOujRYnDMCqL/xBaI7FUH78X1ysU8qFynG0i8O/mCK0TUTGlFis6a93SeBm18vCqeNldfTNlonrtowOX2539wrctm3n9giRKodkEfd0EuC3t2GQ9t0QXSJDw1MQ7SNeTlzXFCYTs0qBUSn+R5BpBnoal5moYE+rNcdAnJG+Eq1aMBGeThoZqoMDey7yPLCoxwf3FV02Hy+mc5AUYsIQjrKKndld1AU7a7+xxT6jZArzrSfK54vJTyxcCV5ytZEZuZwK3UGOBBwZc3pdSOhK4reCoDvfDSvewhFzvtbd9uraFpRxsmb9pG+aNyH8awY4UWAf7hRGgHsN/jdX5XsWiDS+ifGHD9Owr/DcnnNN8u2xbLFT7GRcqb7qtvCpE+/foHKg0NSpO/aUgfXtfAN+4ryPb/7ipgxax52cbxkV9oPehiQhdeguyRpbM5bVRIwE62D1K4JNT8u6EhdbpmEvoYGzI/Qb/Is5okWdgQG4iMlYOJ
 GAaVmeFe
 9yrb6Ch4yNAy9Z9k5FKK36o+bYpDItK517s9XBPNyfq1Xo8ok01diL/rLzVBnOUchzGjv6Yx8eLpnqkwI+9vD9scy1WtKbLbHW3q4P9SGOKKtQFcRgMlVT29PB00Tc86tf1SH1mJaljdmgyGhOb55v9bnkh/AHKWdsE6SNNdqAGQSOKONrzko7a1bLvNOB8q6ma7kTDqp9GDzIpU+8JDXpH1BPjrYHQZfftIs8J9wPWNoOjrywBpm0FSKaiitMG9q6kDQt107z52zKrQG7UTFJvVaoPoQC9Gqhe0zvU/IEt3VmcjNJYwxwAYvmZNGKi3lRWGwnW9YZRhKkS+nc+gycwkb5+EsR/vmJ6rEegLU7U/zgLO6aOlumSzKVQ6xoe+ZkiI5A0wECa4aKqfiQZPo8CyRf7NvdG5ZCpPmnxKnwlNfhW1CKcLp/lHHhEXqWZtzWcNCK+dLszen1cWK8xUY0BA4QGUIHLfo5XrTgfpSVooxXSgQugMkfsYn/rF+08ODfdmynRwXZFNCTw087tcAd4V3gbSby5DUEEBBP3jdxGCYAKrCPtolxvYv30Hgk+re8t9qCOwR01+M/Q4+uLqU69LJ3/RRfyel6EmTeWBLMHDza09af9O1QD+SupgRje/SI2hDc7glPgZIhnodPvaOctLArdmGlTY+WDYiUL2dVulvMJLeho3UsRJYPaSt6LHyWj4V3xggaEEugD9LVIQ1UwXOc+3jNI9q7+7Pvg28yTwXdnMCaChOAqAeeJzWJmp2maAyrvRCWGTsroyCMPQgOY1pHdILsof3WPipQjik0pJ38BGr/iBfjgWK3W1vSL92PNDU73o6JzXm0takGxRNGrP9F9gGmsBBym56Ww1SpgX30OEUGQ8G7YHjni0HZtYByQZCrh6nN/neY43WODlaXHKgtCdMULu+mLc01LsyQ8iqpFslNk9M50TF3lwOuxWXa6TTD6RDDt8EBuDooPZeaue7u6B+
 u0VYloOD
 v8WwDRiZzLDo+IUMjUQFwVe9/sc4nWU/CEXLijC+bRk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Balbir Singh's series for device-private THP support [1] and
previous preparation work in drm_pagemap [2] to add 2MB/THP support
in xe. This leads to significant performance improvements when using
SVM with 2MB pages.

[1] https://lore.kernel.org/linux-mm/20251001065707.920170-1-balbirs@nvidia.com/
[2] https://patchwork.freedesktop.org/series/151754/

v2:
- rebase on top of multi-device SVM
- add drm_pagemap_cpages() with temporary patch
- address other feedback from Matt Brost on v1

v3:
The major change is to remove the dependency to the mm/huge_memory
helper migrate_device_split_page() that was called explicitely when
a 2M buddy allocation backed by a large folio would be later reused
for a smaller allocation (4K or 64K). Instead, the first 3 patches
provided by Matthew Brost ensure large folios are split at the time
of freeing.

v4:
- add order argument to folio_free callback
- send complete series to linux-mm and MM folks as requested (Zi Yan
  and Andrew Morton) and cover letter to anyone receiving at least
  one of the patches (Liam R. Howlett)

Cc: Zi Yan <ziy@nvidia.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Logan Gunthorpe <logang@deltatee.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-pci@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
Cc: linux-fsdevel@vger.kernel.org

Francois Dugast (3):
  drm/pagemap: Unlock and put folios when possible
  drm/pagemap: Add helper to access zone_device_data
  drm/pagemap: Enable THP support for GPU memory migration

Matthew Brost (4):
  mm/zone_device: Add order argument to folio_free callback
  mm/zone_device: Add free_zone_device_folio_prepare() helper
  fs/dax: Use free_zone_device_folio_prepare() helper
  drm/pagemap: Correct cpages calculation for migrate_vma_setup

 arch/powerpc/kvm/book3s_hv_uvmem.c       |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   2 +-
 drivers/gpu/drm/drm_gpusvm.c             |   7 +-
 drivers/gpu/drm/drm_pagemap.c            | 165 ++++++++++++++++++-----
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |   4 +-
 drivers/pci/p2pdma.c                     |   2 +-
 fs/dax.c                                 |  24 +---
 include/drm/drm_pagemap.h                |  15 +++
 include/linux/memremap.h                 |   8 +-
 lib/test_hmm.c                           |   4 +-
 mm/memremap.c                            |  60 ++++++++-
 11 files changed, 227 insertions(+), 66 deletions(-)

-- 
2.43.0


