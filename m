Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44154C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84886B0096; Thu,  3 Sep 2026 08:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D623E6B0099; Thu,  3 Sep 2026 08:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73546B009B; Thu,  3 Sep 2026 08:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 942986B0096
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:21:47 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D3FEC0522
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:47 +0000 (UTC)
X-FDA: 85172362254.22.5198DC9
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0737C0007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jhM4MEn6;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438105;
	b=JrMLtOgdqEm2jupg9GtuXYPyH7L9a4Eg1KpCzsXJYq6+m+cnkeU3wD0aCuhO/KrAk3Cp4O
	HmNN2nfOtg76Z6vCrX76if//RHASEOT6c3I/FY4wjpCaV28dSK5+vgH3em1ZxIY1pthUke
	qFLJcVr5yGznjV7oJDZ9CZFOeLOZtYs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=jhM4MEn6;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eoj/Cdya14SPLIE+VKDTIKpgRBY75qMbCQGmPe9FWn8=;
	b=pPzW21t7FpoTBb6l74s1TFQ/lK3tw6YuaDmrb9PD5xlZIhc4mhWu53rqwf26qn5qWogeu0
	/LKP6I8rYbfFL9e/YArZshBI2MEZ/dLBjqVWylfapFcsWBnZ2zCXYQJ9WgTPz3GuTmwaR1
	qS6xFJLVHEMku2Niqi257kjH7q2Mld0=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8541875f596so1041424b3a.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438103; x=1789042903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eoj/Cdya14SPLIE+VKDTIKpgRBY75qMbCQGmPe9FWn8=;
        b=jhM4MEn6/mOMhFRa0e54rtu3+Y2xsGdz/v8R2xyUabZn/zEnQFjuCzzZM7b2GuyBaQ
         FWJrphiSoGGSwShsHllIWBEGETNC28yuLFnSRLLzFanGMslMCDAOkDcEMKE34uQ5OfAu
         2oJDGPneEXfLmwDKIx/XezVPKSqq9SSd2bhqhZCGwvkdch5JnXkS9gS9Pi6ScIjlTvSq
         JXxM2nFzV1XDbcGKbgKc4OXRxIPJILjnUMtKMk8z0MkBGpw1Z2tJVlVnKIT/UO2RJSjm
         QhL/sNqh78prVl+6AwtRPGAcI7gymQJ92wHOeQef6yso9Q5jyyOL7QIvX9vd4OSwHqWS
         lB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438103; x=1789042903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eoj/Cdya14SPLIE+VKDTIKpgRBY75qMbCQGmPe9FWn8=;
        b=KC3/fVk4irPLUg3CmunLvIwkpWL/2FoJp+sEHeaWyHzbdVdrGL6Ee8M1mgR/4RSVTY
         Z7BQyys6c3/CQMVpMVMQnC29TYQvBdedPmJmVFOJs6vuJT6N6Yvheq+wJ68XMdnjmQpl
         XcBD5WD0IXGeKC1tFJWSTaUJr9ChLHKybl7FwzDRondkbz7xZLkFJZEmFZLWqc9MQACe
         FmLvkLmLT28xIUQ57LO7Uq+5JfS9m/JQxJ80Pt2Q2W+Yb+p80uS0xjYIXuEpzuWQhDmK
         e1wAMiJ2HGaKOH8Kl6zqJxZu4c7XUNX2l+RWBJCe48vqzZzlLwPJzii2Tuzfsx2oe0HT
         FWkg==
X-Gm-Message-State: AFuF++nwSsyOo/m+4Flpw+uFf6pwsTnukQ8Rp6OhXJDBy8B+lQci6Kuj
	T1KEQ6XOrvGyNAo4nWRz4/YeTvspDA3HSUZUWNrUi7cJrZMzZamZ8dKr+vgKAk9aIxw=
X-Gm-Gg: AYBFou0OiYCZskoO1OnwgTxEJfKJV1JfKR1scUURiX6lSSPI8FkTf7hAl5bcYtKPWRS
	BaW/p0TDWB5APfZhC90SV52Js9EKHfbloveim0itpbrVJusueuJZrGUVDTwvTUfPbjH8Qzz6nCx
	Jrf3tVU8Q8SO4TISS1YWkPdwjrnAuryGLAiO/7dhGKdPeohGLtQAInFfFl82CB46iwhfJTrF0oS
	rtk1O90lXRvyWSROT5yQ6ttth2NbYOqnrqyVZ4IttSQJG+Pw1FyfExeR1UlgheNna4/n33WbMHA
	RlJQgizXyES/GRVK/ATBk9RONqARVhYJK1olwBBSuAAF314e1u801kJOpPYe+ejY3vwZZfG4dqo
	AyLIam2qmRN1NqYlTyngKAQcd7ljBkd7dQusysL0z/DxyKf8LCJ/YoRuMBPqQ6Xgk5TAHB7u2Sg
	gk0eK2kA3AQcr+pLZcRZMxrVZhQZnxh6OaSlbA/GNeMpqkjdu4P2tklYkxVywyPslk4F/fk1CZw
	eWVgd5nown1Oep2tfmz2OmBZg==
X-Received: by 2002:a05:6a00:c4c6:b0:85f:b00b:8760 with SMTP id d2e1a72fcca58-85fb00b8844mr9445221b3a.5.1788438103076;
        Thu, 03 Sep 2026 05:21:43 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:42 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 0/4] mm: Reduce struct page overhead for FS-DAX pmem
Date: Thu,  3 Sep 2026 20:21:23 +0800
Message-ID: <20260903122128.12264-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0737C0007
X-Stat-Signature: no3pyu7crxxqm1m8ajoi7kg1uqbqk51f
X-HE-Tag: 1788438104-409834
X-HE-Meta: U2FsdGVkX19ydhPXZQ3Yq/qPFRGnbiN/pfbBfzI0hznYjzXQz4GRz2d56k/+by9uPH6IWTzwi5+F3EcHK0VS9HOHZimOjGlbtt+19Ro7XDlec392xuJj3TphwEbbQGnfk+Z+kyR0j0NRuryUaQrDgr/WLmt+b+EStQ8btNlQ3m/R3YsAo+ad5Hd+6/QmSrjzAzxH5LDAjqYpTdMD2cK/R4mf3/N5Ep0vN/xb5EvEAxVtfmqCK+FzqNpfRoOFQkWbYiolJJdVuN3v29rFe2vvwHAJPBFWUaJxgEb0lnxvnCn06e8L8YogEuCFbinZecdKxUpVivYrxPqDfcJXX8wwSSP21kjuoN7IjERahAJci0+2LmT+XohhGUvRXeTa0fVHyPXiMmi/1dncueBfFgMnG642luSHsLlc3qJhyCGCEMTOFtnM1ik2NDksw7pK3MTsmWz6uktLDeo0y0tgooZpJXs6HA6n8LPoVIQZDpyAhCmk0KxXwWvYBRBvmK4GzbTqeMfM/q33fTvNaueRPNoKaixnsfLo2WDTTrOfxz1pgIoxlExy1+1HmLipPbeKT2gqC50xvcuK+ti2WCnpbNDb3ija/qfXXlpHKIKX6VY8jnauJOMILjuu3vFAdajAkSep98Oo9N+W53mZyNExwlFGmSvsKfZabpqodLecdVRpKvbNg776eflp0A1eEyJUgXF64SXZGD7Ec3inKreSVvl4sRciBZ0YUiLC7xI+1wkxN3W8Q3FChJ+DzA1X0Ib+5I1K6jiDVQmWcyw8FRa9Ik2/obpNtLykdoV4NlAoa7XKY+jra4ife4Ub+hBZLoLML+3xJiuAtadwZM8Fv2IOKZQyhxfQFp/dMgjtkJ1yeXizMUfkse/ihjy961Z5HH69HcCEvJZesKdrtLr3xTzYbw9b2BAD8r4EpTmltAq4HwTAobUErXEv3sjZjkQstEE2jctrRCbikVO4P8lOKdMqDZJ
 2U+X/q3r
 zKsfid9ddUNTdl+7/I+3+LwPC/88Pmwhal+hN0l36gHkTGSGgD8uU0yIkv4pS+Ye0utcPO6TTsJvL//lamHG5bwRiuF0uGjKU4AWWdbPBNOCUO2jjNXYfEH3AxBrO0xzSJpJWvwJbIWBJi2G5WKJ4Kz35lybOY+La0LPPBz19M1VddEPUMy1cRFyJYJTRqhiJJ/yTZ9UJMDcReSMm7Q0fDuHPQ+WSU/7/rxWUqPoYyVBvU4B1GlVhxV/Ibe3sAu4pXZH0Dg9rJHWkygaorGDc6oGZwyV+drYzJVdU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AI and code-execution services increasingly run user workloads in
short-lived sandbox VMs. These VMs are usually small, densely packed, and
backed by sparse disk images, so both memory footprint and VM startup time
matter directly for consolidation density.

Using virtio-pmem with FS-DAX for the guest filesystem is one way to
reduce that footprint. It avoids keeping a second copy of file data in the
guest page cache, and turns that cache into host-side file cache that can
be accounted and reclaimed with the host's global memory view. Host-side
page-cache reclaim is also more direct than asking the guest to drop its
page cache, waiting for the freed pages to be reported back, and then
reclaiming the memory from the host side. This makes higher overcommit
more practical for dense sandbox deployments.

The remaining problem is that virtio-pmem with FS-DAX still pays the
guest-side ZONE_DEVICE metadata cost up front. The guest registers the
whole pmem aperture and allocates and initializes struct page metadata for
every advertised PFN. The vmemmap overhead is about 1.56% of the pmem
device size, and initializing all of those struct pages can noticeably
slow down startup for lightweight VMs.

Much of that private metadata is unnecessary in common sandbox setups.
Holes in a sparse rootfs image have no host storage allocated, but the
guest still allocates struct page metadata for the corresponding pmem PFNs.
Also, many filesystem workloads access files through read(2) and write(2)
rather than mmap(2); those DAX blocks are copied through the kernel and do
not need to be inserted into userspace page tables, so they do not need
private per-PFN struct page state either.

The key observation is that when sizeof(struct page) is a power of two,
each PAGE_SIZE vmemmap page contains a naturally aligned, repeatable group
of struct page slots. For an FS-DAX pmem range at device registration time,
those slots only need the same ZONE_DEVICE and dev_pagemap state before a
PFN is exposed to userspace. The kernel mainly needs the vmemmap to resolve
the PFN back to a valid device page and its dev_pagemap. It does not need
independent writable per-PFN state for ranges that are only accessed
through the DAX direct-access path, or for ranges that are never accessed
at all.

This series takes advantage of that split by separating vmemmap population
from private metadata allocation. Device registration still gives every
advertised PFN a valid struct page representation, but the vmemmap mappings
initially point at a shared read-only vmemmap page containing the common
ZONE_DEVICE state. This avoids allocating and initializing private metadata
for PFNs that may never need it.

Private writable metadata is materialized only when it becomes necessary:
before a DAX fault inserts the PFN into a userspace mapping. At that point
the PFN can participate in the normal page-based MM paths, so the shared
vmemmap page is replaced with a private writable copy. PTE faults
materialize the corresponding vmemmap page, and PMD faults materialize the
whole PMD-sized metadata range. PFNs that are never faulted continue to use
the shared vmemmap page, avoiding both the memory cost and the struct page
initialization work.

A natural follow-up is to make this optimization reversible. Once a DAX
entry is removed from the address_space, and after all mappings, references
and pins that require private metadata are gone, the corresponding vmemmap
page could be remapped back to the shared read-only vmemmap page and the
private metadata page could be freed. With that, the guest-side struct page
overhead would track the live DAX working set rather than the full advertised
pmem device size.

Patch 1 renames the architecture opt-in for runtime vmemmap remapping so
it describes the generic capability instead of the HugeTLB user.

Patch 2 avoids touching PG_hwpoison state for clean pmem pages. This keeps
the normal clean-I/O path compatible with read-only shared metadata.

Patch 3 adds the shared read-only FS-DAX vmemmap infrastructure and the
helper that materializes a private metadata page on demand.

Patch 4 opts pmem FS-DAX mappings into the new mode and materializes the
metadata before DAX inserts a PFN into a userspace mapping.

This does not change FS-DAX data path semantics. It only changes when
private struct page metadata is allocated for pmem FS-DAX PFNs.

Muchun Song (4):
  mm: generalize vmemmap remap architecture support
  nvdimm/pmem: avoid HWPoison flag updates for clean pages
  mm: add shared read-only vmemmap support for FS-DAX
  fsdax: materialize pmem vmemmap metadata on faults

 arch/loongarch/Kconfig   |  2 +-
 arch/riscv/Kconfig       |  2 +-
 arch/x86/Kconfig         |  2 +-
 drivers/nvdimm/pmem.c    |  3 +-
 fs/Kconfig               |  2 +-
 fs/dax.c                 |  5 ++++
 include/linux/memremap.h | 11 ++++++-
 mm/Kconfig               |  6 ++--
 mm/memremap.c            | 38 ++++++++++++++++++++++--
 mm/mm_init.c             | 11 +++++++
 mm/sparse-vmemmap.c      | 64 +++++++++++++++++++++++++++++++++++++---
 11 files changed, 131 insertions(+), 15 deletions(-)


base-commit: 32b6ef9a5d0eca44f9cd91f52f4faa89f145a0de
-- 
2.54.0


