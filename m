Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 154E4C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 03:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B0116B00AF; Mon,  7 Sep 2026 23:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4891D6B00B0; Mon,  7 Sep 2026 23:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39EA66B00B1; Mon,  7 Sep 2026 23:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12FE76B00AF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 23:04:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A55F640380
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:03 +0000 (UTC)
X-FDA: 85189100766.03.B040542
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6BA6740003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:04:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HrEmAiyO;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788836642;
	b=Ug/7/f3YgbsEfbDNJ0m/x8HYQYeyNAIcDl8xgNbFirMifl7yKsYuLqAO4X+vQXIqUsl1G6
	mbQRISbNFvJOOVomBNqsGE8dm7JsJRIWImYsOyomNK3UWIRNxrJK8bNMwX+21SNOh7loQD
	T2H/87pWQ1+6uzyl4jFMPRvOOii+qTI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HrEmAiyO;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4XfCysBDn5qT8WqcsoKK1dWXF2dmEIjBSMFOB3v2Scw=;
	b=NbEjXMWeY0tt/RI4z57CQfDSaIRPB+w1dIthOoSBQgwSDBdGbhxbaH6AAh+V+y1bLkN2Gy
	txpHzbWxm3hhAynQP/zzXQj5i+OR9yPzOtDNNjfjXAFncjerjUMZUhxUqKooURzKq9gyFs
	BnVkdIRfcx3V6cP3DxhSqY/HqPen4MM=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-863c229c3adso1978011b3a.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 20:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788836639; x=1789441439; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4XfCysBDn5qT8WqcsoKK1dWXF2dmEIjBSMFOB3v2Scw=;
        b=HrEmAiyOPqFHWUNJQfv/cFQgIuZ0tk+4FhOZj24vz0R/sExV1ni0ds2i01ChycxaqL
         eXyTRvDBhgTccEgDchVcIeH79WzrcIh8Bu4O91UX2lXwa7NWmLuL2K8oZ/Adugd51tM2
         ZCpV9B6ZXXInaZHUthARKuUfAd98aEMl87x3TZDVD6beQRJSs77V54X9HP09NNE6EcfO
         PKl6BAFnlAl4StZjPtBXn+FAs9C0FHKk32MyTjfvJVTXz3Amtmf1vBsP8cpNx31dwRyQ
         PULvwWWACKnIfrScbQ5WDE/SaBCD/DGEPnN8575bxsAd2ZDcJovtI35jagPm1+PguVqv
         TxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788836639; x=1789441439;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4XfCysBDn5qT8WqcsoKK1dWXF2dmEIjBSMFOB3v2Scw=;
        b=Is6qRQfTi18ULZbvntxpX1S0rBs51qdJ+OT0vyXlgvjCUu8JgYNOx95bABcRtFROhI
         vP/01DEflfqQXcnu0jB4cTZwZtd408Y3TJXWPo4GCKmLUPqWtk8KgpM00PxYxcoQZS1J
         OsCrnwvbLCewPeTtlkUbAto+DdS2rVHOMsXfApuerfooRNHoF8g5xfFSYPJ450eBIbNx
         GBb7ct9bh/uU8TtmCidF7iqGc5U0qb4LslReY1xbwj//1BMOKIF6duNEJDxMi0QwlAMP
         70dDIwywlrIlIU1o7sX//GnX9cCNd8BNKW4f/9tYm+YYxdCbvvqftRVUGnp02EeX9yM8
         7Eew==
X-Gm-Message-State: AFuF++nbQ8NA+NBEdcn1Ks/sP+5txtyiXxaEyfjWvj4ho/PUJjzG6CMS
	Jx+EkgLuWWChlDPQ2C3z0VWd//mq7XVtvh5DrwUPsh0rrKyRumCEkbPBSuVROnL06BE=
X-Gm-Gg: AYBFou1lqXoU/WbRyyzJY86PkLBoeZ4b/lYlr1jg31EtII/3K8S2Km5tDyrFB86JkgB
	6pC3/TLE8xBo17FAgx1FPDmw4vuI7h2nyk8A4qKRQf+W89P8S1/iB0nNUUUS8RlMMwtMnYGn1qp
	Z+4P6Oj/mVDv/BFhYSv04IUWRlT8CQJ1myZKtZn/HH9dOeFEtLMH9GkiQhjbfieAmjzfym+ZVfq
	bCt9rNnyL3hx5Rm1OCrsia8VIIzlQW4bu9P51bdo3QgCgGKiSPsuYjiEWXvQULn1bpsKFRIoEjd
	n6SMbyQiY6CEFAQv35EQHXOkmSKDeWnfUiZhjfvVpHwvBxjzlM6uutwnXF4K6R8tkv4hYM+i8vz
	zddRAawcNhSZdY/1Joocf8erZauJ7q8c58Bu05U4jNDO6XVzMzrlZliMYdUWqYPqP6ImkkWgqE2
	u+pP0tOrPuyGp7VGvMmGLogZW9sOXBkOPcWabtiny+wLtxI/z/HDhdNsqf8PJwSVplMJC9gfY+x
	eWnrmfAncAvcipaKPsvu2aj
X-Received: by 2002:a05:6a00:2d0c:b0:857:72ba:ff0d with SMTP id d2e1a72fcca58-8616af5cf97mr37061890b3a.21.1788836638765;
        Mon, 07 Sep 2026 20:03:58 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86152a358a2sm4868234b3a.29.2026.09.07.20.03.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 07 Sep 2026 20:03:58 -0700 (PDT)
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
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 00/11] mm: Switch device DAX to section-based vmemmap optimization
Date: Tue,  8 Sep 2026 11:03:24 +0800
Message-ID: <20260908030335.96549-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BA6740003
X-Stat-Signature: 5iyituew4jmmruojb381kdrkgx9ukbw5
X-HE-Tag: 1788836640-463785
X-HE-Meta: U2FsdGVkX19OMjhb64G+NHIo+lfAUfRbfbjhitSFojjfzrgU0M/zF6Kz9V6LVVuOJY/OJr+Rvh3zwAO2ge20JAaQhpZs5ucnvlCW/h+cu2K2RkTF7xHK0ejZP1CQXvdv5mxJG5FNXZzb2AcI5moKim3RFru6qDBEDYQ5RVFuqqiTRKcebIuYRrWf+QM/2m2YDG/Fax5/qzqShvkoFPZ8xQiz2nfNIqPtCR5NHbA3YkHgP61/9FbdQpUsjb8uRo6mHN1zwaDA7hsabGO/H7hLEinmOpvTDGVthMhpPpNLCnnuzgq7b0KOClTgDILB3zSUcWILsDjzs7OFsLatNy6jvdy1CimR6iA+51Tses3bBemv2bJJNuXwnHHFeKhleDpakJcjBY1WHpOTSbRf+m8j9MthhMB4+n7lrz0o3PxANwdWRRwhrT+XFBbQDwJ8+jCTN9sEfgU7I6HSgwF8xu+8DmnbzpjPNLqslNunlfjkOJ7syep+i3eS+KgQj/t79AdYb18yZ4Y0QTaBI3Kpx1hqs+H2oIIP68k3PctjIp/L9dFcIw4eMIQmISYqSsXVJCMPh5mnzm71ePvRFo5V68pee+v9pC4FrpN28xCZpQ4ApixpW0XBLQB2Qk5PBF5pdTJsciV/3CKYisZBvjU0SwVl8WfdCyDDBLygYe7gbya2xt7hejRVYYIEFZolDVNVjYCa1Z7RKX3jD3qvQZV0F1zDJ1hjqOajcF4oHbd/xSTnTW1ZNQSEQ96tJ3nCgmkpPoDf7hr9fxElYTt0mIVqegzqaPQf9Wi++5nRn3/Clbe1q1tTM5nBlRbTqfYPlNEg53FDhtE3vbPwVLTOA1O5gEq085C03pOW5aqDyyZ3imsD2rZzT0owNM7t4Q7+1c3iZIKRt4lQ7Q01FMPItnE7bsHE5YEYG7HiVuhnfNId5m0KvO2OiwPiF2XUe+lJRzHVzH/rOkGjTWhOwUjuBvc2G+g
 WBcrILEv
 zp/dSfEr2nnqgTjG1wqK2Oue90q2z2qriC7F0EclBdwd1XJde1up8FAi7J2zu/CeD6eamQLl4Pt+WdtIZ6if73NpP86OU0v4yuzMwMUJbTyaXA9mSWjul8PysHxWQPgXaTtjZZxJH7c7ZfUeg4gEE1tBPH32sUbAQB+JAQSECXzTf0BCYBKokYODxJtfXFKtoUrLUp75p1jzWQ1HAXFHURJcjcq1Mkw0NibA4lnDesalKeK+Rw1Nd7USQkLmEbQhKVdHO558jlaXnFfzO27m1rx/NgGhrC81fiJKFcv3vtlgv0nCvVz3yd0Kz6ThQNKAmh7PbxRmtXmqtzywQaEQKWed2LA==
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
sets the section order from pgmap->vmemmap_shift before vmemmap
population, uses the common per-zone shared tail vmemmap page, and drops
the extra reserved tail page. The powerpc radix path is updated to use
the same shared tail-page helper, so the generic and powerpc DAX paths
follow the same reservation model.

The first patches prepare the shared infrastructure by introducing a
generic CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION symbol, factoring out
shared tail-page allocation, and keeping the special shared-tail struct
page initialization local to sparse-vmemmap.

The middle patches move device DAX onto that infrastructure by recording
the device DAX compound page order in the memory section, using that
section metadata to back generic device DAX mappings with the common
per-zone shared tail page, exposing the shared helpers so the powerpc
radix path can use the same model, and dropping the extra DAX-only tail
page reservation and the now-unused section accounting arguments.

The final patch updates the documentation for the new DAX layout.

This is intended to be the third smaller step toward the broader HVO
generalization. The wider HVO consolidation between HugeTLB and device
DAX is left for follow-up series.

v2:
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

[1] https://lore.kernel.org/all/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (11):
  mm/sparse-vmemmap: introduce CONFIG_SPARSEMEM_VMEMMAP_OPTIMIZATION
  mm/sparse-vmemmap: factor out shared vmemmap tail page allocation
  mm/sparse-vmemmap: open-code init_compound_tail()
  mm/sparse-vmemmap: prepare DAX vmemmap population for section orders
  mm/sparse-vmemmap: set section order for device DAX
  mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: move HVO helpers to a public header
  powerpc/mm: switch device DAX to shared tail vmemmap pages
  mm/sparse-vmemmap: drop the extra tail page from device DAX
    reservation
  mm/sparse-vmemmap: drop unused section_nr_vmemmap_pages() arguments
  Documentation/mm: update DAX vmemmap deduplication docs

 Documentation/arch/powerpc/vmemmap_dedup.rst  |  90 ++-------
 Documentation/mm/vmemmap_dedup.rst            |  32 +--
 MAINTAINERS                                   |   1 +
 arch/powerpc/mm/book3s64/radix_pgtable.c      | 124 +-----------
 arch/x86/entry/vdso/vdso32/fake_32bit_build.h |   2 +-
 drivers/dax/Kconfig                           |   2 +
 fs/Kconfig                                    |   1 +
 include/linux/mm.h                            |   6 +-
 include/linux/mmzone.h                        |  23 ++-
 include/linux/page-flags.h                    |   5 +-
 include/linux/vmemmap-optimization.h          |  91 +++++++++
 mm/Kconfig                                    |   4 +
 mm/hugetlb.c                                  |   2 +-
 mm/hugetlb_vmemmap.c                          |  30 +--
 mm/internal.h                                 |   9 -
 mm/memory_hotplug.c                           |   6 +-
 mm/mm_init.c                                  |  17 +-
 mm/sparse-vmemmap.c                           | 184 ++++++++----------
 mm/sparse.c                                   |   3 +-
 mm/sparse.h                                   |  78 +-------
 20 files changed, 250 insertions(+), 460 deletions(-)
 create mode 100644 include/linux/vmemmap-optimization.h


base-commit: 9d3243fc689fef444f87e0a703b4c99653137e1b
-- 
2.54.0


