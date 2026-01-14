Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD04D39008
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 19:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9185C6B008C; Wed, 14 Jan 2026 14:21:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C77F6B0092; Wed, 14 Jan 2026 14:21:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC316B0093; Wed, 14 Jan 2026 14:21:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6C0BD6B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:21:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C23313A8E6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:46 +0000 (UTC)
X-FDA: 84331539012.23.34E19DD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7EB5A20015
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:21:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QtGTz8OZ;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768418504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vqzM2gqCcXkSyAl3o9QoHaz/KNUBsZJKsEmE8yUdCPk=;
	b=NgBznQziWLhMbVZvtY+FTMzwrgAitveNjaZVv0t3PWyuG+uQG9UM9ZwXdfEHDvJTHcxtYS
	4qq/HnIpa35SGMho9XKNLIuxcrKJXQZ+yx953J0ve/pURqWhcn7JrqMtNYRgKaD4iDLj1z
	GGTpB9Ch13H6juqXnp8lIIsuF97lggQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=QtGTz8OZ;
	spf=pass (imf03.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768418504; a=rsa-sha256;
	cv=none;
	b=hylsPKL5QlHofdv43qQGvrUep1rQlMUWUKB8gmcPz7YcL7k0YAocp51NqO86WPpACH2m5y
	UpsGS/7hhFtdHI8XqGxBCPu8pH29Cl1zeF43KQ3IfrlgrxHKaHgyBl75AmEfrELWa/MQrU
	PVdKxmFvSRdCvO1fsLgj+R1xM5fS3To=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768418503; x=1799954503;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0Xr44qIt4aDZeFOuXJUWqKFpNwHw/ty79qHlHFXr8ng=;
  b=QtGTz8OZ6KSH7syQ7Mq9Ii/azxIVFUt9UPTF/PWNZ8K5RhKXqUb30fgc
   8oGCdcvM3DVH7Nojo/skBlYUhMzHSSF0P8xIVyRAK4BFbjE99v8M/MzEt
   AQzdMhkt3bDF7Fh2R+hRjYkH2hpwzxl61pe1NSPhMWAy3eH58n9dXtLyG
   ZkJC1PL3ubkcelKCLs3pQOaojslg50k9kTTQHMgScSjhiV2GN9qXoRUEG
   EEsg6EYV7iEuP1vHCQ/H52rb8OJYELvWEYFYb1UHr2oeG10UFJZcD3mB3
   ROik/NFzeAa1LC8hPkqsF+ZUgcOoQ3IrZ3baWwzwQNLvy/EdLl4lt1JB5
   A==;
X-CSE-ConnectionGUID: Q0zhwTcmQ6W7Ip5sNP32tw==
X-CSE-MsgGUID: raVm62NVQLi0wqCQD/7RdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="87305659"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="87305659"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:41 -0800
X-CSE-ConnectionGUID: 36cRy4BqT3ukGV7yMf/R4Q==
X-CSE-MsgGUID: oSiZugMJQPWWWoPWHLMztA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="236006778"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.85])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 11:21:33 -0800
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
Subject: [PATCH v5 0/5] Enable THP support in drm_pagemap
Date: Wed, 14 Jan 2026 20:19:51 +0100
Message-ID: <20260114192111.1267147-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1wg9texy19j5h1x9hx9iswkp7yn1in7u
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EB5A20015
X-Rspamd-Server: rspam08
X-HE-Tag: 1768418503-667323
X-HE-Meta: U2FsdGVkX1+5NwoCo/Inf/gmgUU3WeVhOEkXGvvH90UgptYNaNk4DoXLsjTv2IfOd7ker5/YlL9PYzB89GDe4D6VivjDR1E1XPDBr1cUTWIRBTpoLtqYEmteQHyfr9pFLXlVxhn206vhHX6WsbpyyjI/EGxqhxesM07BgNh+7GSy9ySvKbQFvdGxcNVVc8o8HBDMceHzdiJ3D/aJ0gDG1hVBl1nbU+2RfXixbkfNDHCbIm3zez9sz0krWA0FrR+325U/dzCHsJPNy3Cgmz0prwXjJa5JcHS+Qch0ThDbVDdWqk7obfmNjTRhzw4Cp6GOk1KjeWBSvS+SSPRjXqOVvWOB2HH0AY+8SDDvRMIMqNh7zEUA237L3DXYLZIiAO5A7uQx7ZgBqVhPYSONLcNYiw6HMzCJWqORNud+6U04yFL0O815XcbA6l+jsCzY/99Y9oGmdQR6SAFHATqXRyEW3+3xqJNC3ffpDo/EAIyduXu9gRyqVh/8NounAlrZlTYY0lcqg2irl7FKIX6EyuctIPBfLMf7TuhemuH+jDja6uc1/MQYiBNat1PqKuJ4b0L72CyTMoqLZ9/jqxDloQGlU8m5nIc6McDRFUvMv1mTK+qQr3hcOSkrY4izt30iezjZ1B/1i4qR9qqVHGAHnKUGYGnoNUhvlTFdyjIUfBgnVVLYbzL6DXscJQuVjJ0YNms3L7Qmk1k3cqkjoGVzkWA/OXfaWaynlqR/ZsNzvLyOi+an11Fn7nX9Cr3gfdD3Wtd+oY+hxZvA5O4r8BRsf9sr/x96p1R2uXqIgMYFIWmXnMQY6UIGHgFTMt5IdYXOZ6LVIMCx/BwYNpt/3ybShE+Hhc8FSXQlSvyUNDBZqAUvfMp7gOW3u/BvrsOFlR4hFaBErITh64FNtEQy+hMwRXRprIiqfNL7s2xFTGWky4roqcZ11NGQXKSyG9FbUuit35spFDK3Rdn7uCyCP2eelmW
 cKZFKpVK
 oZSF/jrCGG8B8iqv1vZ5PBANhQ4RApjXV+joD3nhymu4qFxEX4uUt4ntUsuQRmRQJIW8xSNba8hEpmINWJpMZxgY5ur/lyVBVsXnjNI+/6IcjIVPJwzOozsWwi0ayDj+QJYoGpYgipwri64YM0Y7mgeMjAMvgD6Q9gElRXUeqW4U4rU0Oyzy5odUXwkcEr4wQgKguPe3yfdLbkxnVDc0Y7u5IAk9us0QLDE9QpeFQuwSe6QiBQ0VcmEfGrPP2SXhD8DZXBWRDoe7Jl73GhHfJt+21JYwlj1SrSdRN36tWo8pfv/8rC4bMQ8zuIZ192g3yId6Pr//6VjkckEY4/fWvp/7NJDHIQ438SDkgoSFd7QhZP22QgbVE1HVCRNurrX6ek5IPRO9ZZ4Sx6QHGHTV2oYy0O/KEd4yKfMeZw2OVDPFa/NIOHWfdC5jpLJefo8nJ8HDivmZxwUtkxSKEZeExsrvIOe3JtmlhSUhkqurbmkbA4pd9nCzIFj8iqinihB0zPC9DKBx+0EYeT3WPfTeramZ7WuAzyFC4tf5ly85dPv9R0qvLvJuos+nyUxQSQdp1pX7WnR/VB47JFjNK9RxJG4LwrHl6eXIBjAkUY2s6c1OEZGqDZuB5wmJszbmqW60FEQE4csB5lEUtqsMAeRKqjBp24xBxlvKb7BNXjmZ7IED7BbCyMxVOwfZDpfpbiYltPfmTSPd1iNwbtjJQehxeIuko81k6kFjCNb/1xkrrP6s0Ls9wuenjNSaHqz5cIkxwTlY+LQhDQjeOg+p0wn1vZcveYao2wZzLGoFIgkVcKlwj0dF/f+o3e0PjvvhiXqCjtq/oMuMPsMCYG/aFgsWvItc6tpffz4mw5+nzkEH2pXRNCk6iXk6fZn0cgE9JU9+dhGmS1p8dO15YijdEfCCIJZNyr7TTgKNGrMHDusxYoYy9GhVcEtbGpwnuvWg2GjgGb4TPho9/3ldsP4lIGe7jkzwICBI3
 gRgIZOFK
 P2LJNc/2X6eEqOkG2cuJPLPCd4K/eqglErl0Dx0q81c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Balbir Singh's series for device-private THP support [1] and previous
preparation work in drm_pagemap [2] to add 2MB/THP support in xe. This leads
to significant performance improvements when using SVM with 2MB pages.

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

v5:
- update zone_device_page_init() in patch #1 to reinitialize large
  zone device private folios

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

Matthew Brost (2):
  mm/zone_device: Reinitialize large zone device private folios
  drm/pagemap: Correct cpages calculation for migrate_vma_setup

 arch/powerpc/kvm/book3s_hv_uvmem.c       |   2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |   2 +-
 drivers/gpu/drm/drm_gpusvm.c             |   7 +-
 drivers/gpu/drm/drm_pagemap.c            | 158 ++++++++++++++++++-----
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |   2 +-
 include/drm/drm_pagemap.h                |  15 +++
 include/linux/memremap.h                 |   9 +-
 lib/test_hmm.c                           |   4 +-
 mm/memremap.c                            |  20 ++-
 9 files changed, 180 insertions(+), 39 deletions(-)

-- 
2.43.0


