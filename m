Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68031C98328
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB8A6B0088; Sat, 26 Sep 2026 22:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5CAC6B008A; Sat, 26 Sep 2026 22:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D255C6B008C; Sat, 26 Sep 2026 22:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC5176B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:54:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BE3814099F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:54:53 +0000 (UTC)
X-FDA: 85258024866.19.3CBF96C
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3A46440004
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:54:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QCIYH7Tz;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YdCenWsLNM4fgmWyqHdVLEa8fbYRLFc5Vlv8cacB468=;
	b=ts0tJB4YCL9h1+MtCpvd/gkJLbr5x7w3+HFAxoTidqAaM9VNIQt8W/N0r3AL6S8a+88oDT
	B8fQ3U6NXXO9TMIUM3Z/ZLeD3q0wLvNyUn1+V1hnwRtaUXI6GZCcIqMO/jyNhO1muOAjfx
	E0KU8s1wCu+6Of6a7OexUhjm2/hJ5Wg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QCIYH7Tz;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477691;
	b=dATLsROHlIQOSKntQQ6QO8vnPTb9pj3Nd4N9vy470f0XEaAaAZMCmvHj6+RLLapo0Ur3wP
	CyT+xErkM44JausGz8wNPbKPq5CFvrUhxFtK8q49REiK6MUZR0WAB5rrXCKJnQdmjwiG9k
	heXbjLyPDSSMYv9vu2zynKAfkA/rEF0=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so1070846a91.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477690; x=1791082490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YdCenWsLNM4fgmWyqHdVLEa8fbYRLFc5Vlv8cacB468=;
        b=QCIYH7TzX7F8nBSk7FOvT8NOG7zRRG9sdp8nHXmTaMOaHSJJlMt+YAmRqdnOeIVv6T
         x3835ofOGx+Fav5fqXCeUTleUcx18xIuejJ3QaGzz/vyUTy05eWRBja5euVYN06rnJQs
         PHfwcuLArnfVFnqDpocH9uFWU3pnK5yR8NVbJUx1Oa9SbPaaE8VJoa/J93IU7Q0LppDA
         lJjaQ5oMLYIECKuJ5qOR6Iu3nFrmKTPMu5s3o2Z6vqe2VG3+hS6jHqUgajHMjyQJKM/6
         DuOaaNmY2118e62yRK8tGcom25erC+mLsiD8fEpwTWiMOMgfUzooORoS+Bg+2bI7Oxmj
         BZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477690; x=1791082490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YdCenWsLNM4fgmWyqHdVLEa8fbYRLFc5Vlv8cacB468=;
        b=oP7jMr5K9lXjs8LU7ttzeD9yfG5oUQDCW7/LwPjGjYTYh6TgaQeB9Y/jVjJVV+5tix
         2SyN3zWL9iRXQdKcN74D3c8W7S27NLU9e5tdF+nY2qwffWW9HXaOX9Req6/T7PnfHXF8
         2DTKwxpWG3hIish4OwP47jhnC61Go/LdyiM2YW6rFyt5UPbM8DBjUNCW5CfLSpobleE2
         Fe7WLntV7rinSb+sutY62FYek+2FZw+F5HJOMCqmyvlkTaCV81vBhBr9NLoaYJRiXGCc
         pLnfZMDJrbsirBUGqK8QL8gLLh1vhchj7F6ty760JYI0cvbtAbbt/KMIwZhubf7QweN4
         tfBw==
X-Gm-Message-State: AFq9FYIEwtuvZ2gCY63nABWqBYHrhZ2OOm9Zu1Z5kZvJ8v0eHjJDqybD
	VZLSpdMlw/h5ejSTDwacJwr3K0GmfxI430QNcBRd24KkbZvMkRP/8NnqjRgyeuCqtLo=
X-Gm-Gg: AYBFou3/rYnuvjIPyym5SGEvU1A6X7ojhcXfjF04bpXy3ozkWw+H9eQlbe1MHyAV3Py
	eEHKLRR0Ngcus8U8MHkJb94/pTg3T54c16C4bAm5+zIWooKmCldCCQpPOF2kV7WfawhgcrHkXx+
	fl+gUdRFDAn8i+0Sh7AbUNYpshLdjh08N+/VZrYAkqXedfjT8B0CkzEJTW74VQuJWxIcfHCwYSl
	M3Yf0XCgLoIErLWQ5v+TFwIiDl00sxe57sU4RkD5ps0lrkNcu3mBPvtfP4sG41jsGC/4f8QQoo4
	yEvK0P+6BF8OUYQKWC1e3MrBb+Mk9Wh/O6HwgRZZWP6TbTPjXsf2bCzJ7Umu/1M75ve3uhUCisr
	LmWsc3Gm3heXFMg4BYnQPdEOtWKeVsrb0Zu+kqVoASxR5U71Oc8i22u+0QfD7QTbl7uY7YG3X92
	r49j376sDTgUNRRO/KERxY5PCSxb3r5plGXBevFzOpc3/kTLYaA5YreBFir/vEic7YIqT9YfMXx
	YLV/q/OW2pmzqKmp1am
X-Received: by 2002:a17:90b:1652:b0:3a0:9640:8043 with SMTP id 98e67ed59e1d1-3a098ccdd41mr8412652a91.15.1790477689681;
        Sat, 26 Sep 2026 19:54:49 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:54:48 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 00/12] mm: Switch device DAX to section-based vmemmap optimization
Date: Sun, 27 Sep 2026 10:54:29 +0800
Message-ID: <20260927025441.741633-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aecuypamfs39rpu54jmubebzzyrg91u3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3A46440004
X-HE-Tag: 1790477691-571716
X-HE-Meta: U2FsdGVkX18Hzfp8M5SZnwWxV8tkJakc0vtkEwnX9SgjaRHxBcGROki8aYBuw4DSfHO8QSMm8mzQbgRmnvcK3prsf8qH7VQTu7nr812Zwgqax4lzvhaGnsIta+TX34tGVaNHGqtu4FL1aGoAikTfuJlGfGM2QPqDlQI5FCzbrZZq8mUfCw4YlpQrK8b/ix7NNbA6cpEN0Zqhpb0fKSSn5mn9fmzBxmTRwQcHNG797/sTxUdySASik1wQsrywa49pmWHMGky7zddlYbzvWUgwiNGCXfDZiBgs3xyLCezvvGuLw/q6dmju9OhhOYZXTuDjHKRP8s6sliDltv19/ML/A0sq6EGFGnXEgqyIRXjaEpOss/z72bwoDTi03ZyFpV/9N+PS6fPE8CHi/puffrji4DP3Ivpx5peGA4oY/JaBEW0yspkW/L72YQBguqesrBzPI2eLtQPMosV4j43kibf/VAIWcdZ6uiYFP9bW3ZSiYa3VHS1l7tvbkj4EGrRKxITsa0fmWPZ6k6AnrC32e4Mj0fn57ylcz0+7IIGs9BYS8SYF1EOYQ01Rc4rleLF9ef+I1pQWYcYIS2Bm7/2/WqeH1xdDqV3HzQn7dtrjIoN8OBRLzcZSjcadmkVBkF1GSt1Nu9iiI+ZkCLpCQAoQ1ZdXYXGb2aO6w/Wr75OGxoD5RhijFv6B7Q7rm7RGNvURG3lZUTkutoB0vO0rf8zUCaSIemkd8xfAPsDVhKfjdb+1FwrdnKbIwseYphzWkAqvFWm1mCuIl7P5IQo6pp4AQDNo6U9dISgj0hypGsp6/ajuZF08BpU/T0l7aiaW9KM74vgwQHG4/4f82UHbg2f8z6V+KRDJhAaG4JasO+dDhsdeZB4T6VF+24I7RPcqzYO9MNVLt5GS5EameJ1vEEKObXUMJLyezdINnXnVcUsd13O/AOHSNHjnlbAZBcVZA8JGPf4z2qdpv1rDfhgPHz4H8fw
 fTYvvYA0
 J7nSfssxEGpUOjsOS9MiCiftovx7FiaRt245FOQcS1hekenXIhr4pw4PtoSDG94BIqvfoal+0ytUc5WtU5qggWrs4eSXTKhefigARM1k4EslqL02JQ1f/wpe3Jmkbujq9fhHbka5AWeU2DbJwtFgY6lf9C05tyQG85UFq3vxV+XKxMEyNp3mvC8obf/jswQQpxtQ7gaWtT7w2uuCxXqv2jeeY4euCDgmT7w3ACLIcrkD3XnKGsxdisMume4ENn6lYJcPh9Kk5fqq9IwYU+GXB2YY0lEG6N71t4Zv3eRt3WLhd4ptCai43K+c2+LWrIRuzz8pZIbOA88GJszU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: switching device DAX to the section-based
sparse-vmemmap optimization infrastructure introduced for HugeTLB.

After the HugeTLB conversion, optimized vmemmap state is described by
the memory section and the sparse-vmemmap population path can allocate or
reuse shared tail vmemmap pages based on that metadata. Device DAX still
uses the older DAX-specific population model, including a separate tail
vmemmap page reservation and architecture-specific logic to locate or
populate reusable tail pages.

This series makes device DAX use the same section-based model. Device DAX
records the compound page order from pgmap->vmemmap_shift in section
metadata before vmemmap population, uses the common per-zone shared tail
vmemmap page, and drops the extra reserved tail page. The powerpc radix
path is updated to use the same shared tail-page helper, so the generic
and powerpc DAX paths follow the same reservation model.

The first patches prepare the shared infrastructure by factoring out
shared tail-page allocation, allocating the per-zone shared tail-page
array dynamically, and introducing a generic
CONFIG_VMEMMAP_OPTIMIZATION symbol.

The middle patches move device DAX onto that infrastructure by recording
the device DAX compound page order in memory-section metadata, using that
metadata to back generic device DAX mappings with the common per-zone
shared tail page, exposing the shared helpers so the powerpc radix path
can use the same model, and dropping the extra DAX-only tail page
reservation and the now-unused section accounting arguments.

The final patch updates the documentation for the new DAX layout.

This is intended to be the third smaller step toward the broader HVO
generalization. The wider HVO consolidation between HugeTLB and device
DAX is left for follow-up series.

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

v5:
- Move the shared tail-page factoring before introducing
  CONFIG_VMEMMAP_OPTIMIZATION
- Add a new patch to allocate the per-zone shared tail-page array
  dynamically and fix the RISC-V build failure reported by the kernel
  test robot
- Select VMEMMAP_OPTIMIZATION from ZONE_DEVICE instead of DEV_DAX so
  MSHV_VTL cannot set vmemmap_shift while leaving the optimization
  disabled (reported by Sashiko)
- Move the vmemmap optimization macros and MAX_FOLIO_VMEMMAP_ALIGN from
  mmzone.h to vmemmap-optimization.h

v4: https://lore.kernel.org/all/20260916064341.1825793-1-songmuchun@bytedance.com/
- Rename CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION to
  CONFIG_VMEMMAP_OPTIMIZATION (suggested by Mike Rapoport)
- Collect Acked-by tags from Mike Rapoport

v3: https://lore.kernel.org/all/20260911050228.58884-1-songmuchun@bytedance.com/
- Use EOPNOTSUPP for partial additions to sections that already use
  optimized vmemmap mappings
- Move device_zone() after NODE_DATA() to fix non-NUMA builds
- Collect Acked-by tags from David Hildenbrand and Qi Zheng
- Rebase onto mm/mm-new

v2: https://lore.kernel.org/all/20260908030335.96549-1-songmuchun@bytedance.com/
- Add a missing SPARSEMEM_VMEMMAP dependency (suggested by Qi Zheng,
  reported by Sashiko)
- Add an explicit ZONE_DEVICE dependency for DEV_DAX
- Add missing dependencies to the new public header
- Explain why optimized and ordinary layouts cannot share a section
  (suggested by Qi Zheng)
- Explain why sharing tail vmemmap pages is safe for DEV-DAX (suggested
  by Qi Zheng)
- Clarify the removal of duplicated 4K PUD calculations from the docs
  (reported by Sashiko)
- Collect Acked-by tags from Qi Zheng

v1: https://lore.kernel.org/all/20260831075342.57563-1-songmuchun@bytedance.com/

Muchun Song (12):
  mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
  mm/sparse-vmemmap: allocate shared tail page array dynamically
  mm/sparse-vmemmap: introduce CONFIG_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: open-code init_compound_tail()
  mm/sparse-vmemmap: prepare DAX vmemmap population for compound page
    orders
  mm/sparse-vmemmap: set compound page order for device DAX
  mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: move vmemmap optimization helpers to a public
    header
  powerpc/mm: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: drop the extra tail page from device DAX
    reservation
  mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
  Documentation/mm: update DAX vmemmap deduplication docs

 Documentation/arch/powerpc/vmemmap_dedup.rst  |  90 ++------
 Documentation/mm/vmemmap_dedup.rst            |  32 +--
 MAINTAINERS                                   |   1 +
 arch/loongarch/include/asm/pgtable.h          |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 124 +----------
 arch/riscv/mm/init.c                          |   1 +
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +-
 fs/Kconfig                                    |   1 +
 include/linux/mm.h                            |   7 +-
 include/linux/mmzone.h                        |  38 ++--
 include/linux/page-flags.h                    |   5 +-
 include/linux/vmemmap-optimization.h          | 115 ++++++++++
 mm/Kconfig                                    |   5 +
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_vmemmap.c                          |  31 +--
 mm/internal.h                                 |   9 -
 mm/memory_hotplug.c                           |   6 +-
 mm/mm_init.c                                  |  17 +-
 mm/sparse-vmemmap.c                           | 209 +++++++++---------
 mm/sparse.c                                   |   3 +-
 mm/sparse.h                                   |  81 +------
 21 files changed, 299 insertions(+), 481 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h


base-commit: 92068d3f6a4274d952441ba8f46221c3c03787dd
-- 
2.54.0


