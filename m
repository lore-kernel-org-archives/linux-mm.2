Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E61D48984
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3106B0088; Fri, 16 Jan 2026 06:14:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6A66B0089; Fri, 16 Jan 2026 06:14:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48E856B008A; Fri, 16 Jan 2026 06:14:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32A8B6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:14:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C04AB8C198
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:14:02 +0000 (UTC)
X-FDA: 84337567524.15.21F8025
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1ABCE160008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:13:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HdmNP4qH;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PjutvA+lrQzQE0taSeiXilOIu9xKwU605NtKOX+sPEk=;
	b=4J7TEfan76APTxqTEfsdCfbZ1mNG6Sg5o9mLjf1pcixNJS426bmtSyxvTgv9twFljJR4R1
	VU58lxLyDGMixjo/z0h6uIye3KmbaWDN/M2St+iUb3wKqqRkL+Q1eXtkbzmpQvR7BKOa4x
	4XSo1nqJetegXSmxNU+aXjzNKDQmOuo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HdmNP4qH;
	spf=pass (imf08.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562041; a=rsa-sha256;
	cv=none;
	b=zRhXEbsXofU/xR50MCycoAv4UM7b3YlUVDLzPUEHqffRfLQ6/+yymDDD9IR0IpJJkM5Gfv
	zXDsTsvlsbaQr5Nwj/vLXNi1PecP5Nvs8uTmPo/XdBcRKDKszWHD0lzW29CK8lAl+6NeFS
	LXJnAJqTxxDEMsV3IGGzrfX/zbDTLyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562041; x=1800098041;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7m7TLs5ms8SsBuRtmgorzV61ohfwt2E3J/DzXKAkq0s=;
  b=HdmNP4qHCz3xgiSZ67nScl0+A+BKsCKLzHSPYfomiH8Ui46w+9G/7J2W
   LvfI7pVbeyegOpj8wumbKxmXVVYxZJ2svlKwTGmHYnda61oh/TnQJUTQp
   GF8Jp8EBzB9y0j0PW9UwaFvGXrP20jfpwiZyYM8lbewFmN1zySu1Lb6s8
   CmaWY5FNunY6b8XAg/AjJzfzI8g1F3OS8Y/5X3n2i6gWdANCnD0YJ0F5Z
   ifbg9gxLb5XrgG0zB1H8GSaceiU4AeWwiVAPcAKQ+BDSZagYIGXzrAqsB
   2G+d3o6ALMf8I1p/pptc+FlWfEiLM7KhEdaFq1Je5FsgQmerHw8hvco1e
   A==;
X-CSE-ConnectionGUID: nRoRrsrJTzeojzRLR3kziQ==
X-CSE-MsgGUID: 88oMBRfYQJ+I0MtsM2nqZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930626"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930626"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:13:59 -0800
X-CSE-ConnectionGUID: uIPeeNCuTXKTNMh3SaLJKw==
X-CSE-MsgGUID: 0lzYBIZ5TcqNem+zWWjj8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713339"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:13:48 -0800
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
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
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
Subject: [PATCH v6 0/5] Enable THP support in drm_pagemap
Date: Fri, 16 Jan 2026 12:10:15 +0100
Message-ID: <20260116111325.1736137-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zqj3i7ju7j44fr9n8bsaake8xrppzqmi
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ABCE160008
X-Rspamd-Server: rspam08
X-HE-Tag: 1768562039-184163
X-HE-Meta: U2FsdGVkX194Qbw4JnsehdH6ozOcb9WS//b6teMUhrccnxmgu2/PwQYTG+9O8T/a1ZzF1U5+Xdam7p6DiLKMSe7fJIdOqXjJTrM6E4ggfoWTew2dAP5PP90aZzHph1PW2Kbj3hyVjHdwqwTbPpRpe+QYBH4Tntd65CEfthZxrrNlnor+8ZxF9gcbGbKfdvpDKaxoPHa8aDqQTi3A76EH5pGVb+2Sjk/pE0a76IoBq3lKGlIZoepdZ/PgAMBscEioSODxrAdxrU2dsKAO3OH8qhj47F0mz6GHJYZh6kkK0CJGE/LDadX3uoS2iWpCyngU2g3Da73ICFEyWaQdcGZ4xU/7bNIENG9eXVPLGCHuzIWtgBZNS42s9tV4JubTr8m6O/ijSKw4DnbBexaqLBkOnqNnvISxS0j5H8uRQPPSJpIw+duRu54c8bNFGBO3ps13VitCFWGLTaeRmNNuHHyvKHqRa5T8VKwEHWhXVhaNHXH4kSGvGc7o2c99IrEkWsRV2wjgE+ZyOISlws97EB/itCine5D3e3TZCIVP8+Ds6G6XWyjgdEsXZJ39hs52uQofhJzOXd13oV/o4D9c/DU/1uYGl3e/7SSger6I89UF4YLQ6INeMwj0I96jG9+r4IIiSqaQVD5Tq1pJol532aeNr17ooIo/2qN6OrC4xneXcGoI2xNNn5M4+T0u60yp3zUDb2Gj12B7Bb8hiLTuBHeWyUVXsSwLuNL/9W53JxiaMveFtRSubq+0u2L4J8zfHCU61TOuFJiQkGCIaiUK5+MXcjcUn7to1vy4JyZ6gmq3H8HsJlTroXOKDgaO9A9IPzxz6elqHKkMLbzPO4l99MXBAROrCpm1crkgoB8Po6aZ/uGqHTj9p57chRA8dOLw1lFsvKZIOsqncXbkfLfj0H0lhCpVAG13fRadmk6tGKBh8sHZmPSEbze1TIdnORCXI+akAcymjrKxPoDwN4RUVxB
 NrRV81UX
 HfuKfeRQZNbdcyfkp6oWtUPpoTsv6+f1R6+c2Wpuaqm0w1ANcozqgJrvImWUWkHRgu2hEEDLMpGRLlCCg9PP4R7kYlJL5VVjg0ogPd2eWhze2RuGUDRm+kiucXAfauLxIMe5AHiGw8C4nUyV1BFDTHf1VYWZla0SVYMdK0kUqoKn1yDYkHceTVYUUFE1OPDWB9EebMiQ2TIqRtIDKtilxV85dX2gTk+LWuEtz53AWEIauFRDtEac/jv4uNF4LaBk1Bz3c7MznUt/aZ4Ag5CHA5QB8g9vNQoYjtwik8L5ja5YTSnheU9JTv2coHyYc20qijuetAiQgCdrVWg9lsGsrY3ApgSFQbH3s+FlIVJK1PGHFZh1AkN2RkbpqtrUiD2YgJfJ05zcV/YDkpJXxaQfhbXxb9PkbEgz+c7FTUoctEiYNdMpHfPUZD6xYAN029dopYJFhDa/Glue1Cfh/V9tJ9wsNnqycStYgeq/pw9vGdUeLKgZzmqf4tsMTlpmb7XSnSXukRIuH1gHX6Jzo1KG020915J4AlHrR0JmVhe5jMuCA19Sed7jje3zd4O740AW7UlJd8jUhXqWP0A/11ADQJPDj3tXBkUkyQLacNzM2XXqH6zFwDJtb4zJAQ8uDHBQMkKGkCuUicufkgoaHG+HB6rOvbTgtBAhuLFVJvzvSyad7/nnwH7RupcBLWhkVoAb/k0ZI8j2ZFx6jP/kmGQEt9LqUyFqbp6M9ZfW6pKxnXpfst5cyr2TSAVlPxIYju2XFXlEMa3dEMVX4ga5mcFwRri2stOPIOoDxDc+eFiJ1ynOmSZFtgdTL85Dr1fbOxJ27uWCKi3I8xwk2t5AG06ZAIErvTOLfjQ0TpzNfUknhzMyN7uKHv/xafvoQ7yEuy4lt/VNV39TSKCfWHPqy4h1dHf5cVvAoDCtSEwbOc+WKbjxw85K2HfF3VUYkd1TE8LdnWwlRAJEOqMmal9qa41/y93VyhJo+
 YTETRH4Y
 VWLjigqqSZSiux6M1asuUTRMrKq7DO6JrqjD5bkOd4Y=
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

v6:
- fix drm_pagemap change in patch #1 to allow applying to 6.19 and
  add some comments

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
Cc: Mika Penttilä <mpenttil@redhat.com>
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
 mm/memremap.c                            |  35 ++++-
 9 files changed, 195 insertions(+), 39 deletions(-)

-- 
2.43.0


