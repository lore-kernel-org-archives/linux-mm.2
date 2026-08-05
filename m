Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1A2C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 05:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA3B6B007B; Wed,  5 Aug 2026 01:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77A3F6B0088; Wed,  5 Aug 2026 01:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690996B008A; Wed,  5 Aug 2026 01:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39C1D6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 01:56:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCF41A1B2C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:56:07 +0000 (UTC)
X-FDA: 85066155174.19.8581AC8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE78640005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:56:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SSwlYu5u;
	spf=pass (imf01.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785909366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=myGrw8fGktwNQsvE5uYfJTAVudnST/W8PUvvhsvRQII=;
	b=4HjE9B+AYjIFDJEX629I/0Mq5pPup2zdvCYa8BAq5amkbhCTSDqod5YH52xs4HIy6zVXuZ
	ciJ/j1WVx8YVMDZ8+4qTenRDMaZSpgrwIxqLgYEAWDauyHVbBjMEzrKBPu088VgmJPYxa9
	RWcNsUHsovQbZsy5qr12OUw1LoyIRcg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785909366;
	b=LuvtcB8h1WkeUk7z+IFOQlfQRGFG2Vcb517szlbpK2MVFbnqqi3+jcu86aN3zEQxfe9KvW
	P8X5jSQjSmhfS0PmzBftl9IgiKh+K4QeEtWomFwDyNT5m7lqemmyZ9s6PzUNCYSkGIZ2Lg
	vLhGku4wEUNxz929YPg+z8Cq647musw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SSwlYu5u;
	spf=pass (imf01.hostedemail.com: domain of clg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=clg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785909365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=myGrw8fGktwNQsvE5uYfJTAVudnST/W8PUvvhsvRQII=;
	b=SSwlYu5urv+rgwzp7zzFV97xs3HnBXvDy0eNNqCeefCI9usCOA0Js2a6yyqCc3FqZ9dtk1
	th4uj/cG4iELKXkKc8qbTu6tU5fgqh6/XxKfjBnepuE08FLf9gAHNq+VGmGSiZPlhUFUjc
	phGcMBA9EbsPVWaO8JxhqAinpH5Vlfw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-52WWm8eOPpWFxk_xvF0GUw-1; Wed,
 05 Aug 2026 01:55:56 -0400
X-MC-Unique: 52WWm8eOPpWFxk_xvF0GUw-1
X-Mimecast-MFC-AGG-ID: 52WWm8eOPpWFxk_xvF0GUw_1785909355
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51D9219560AE;
	Wed,  5 Aug 2026 05:55:54 +0000 (UTC)
Received: from corto.redhat.com (unknown [10.44.32.25])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5EAC41800348;
	Wed,  5 Aug 2026 05:55:50 +0000 (UTC)
From: =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Cedric Le Goater <clg@redhat.com>
Subject: [PATCH] mm/huge_memory: let special huge VMAs bypass the THP policy check
Date: Wed,  5 Aug 2026 07:55:40 +0200
Message-ID: <20260805055544.1568534-1-clg@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: -_pfWP9Z4c6U0BUs-MvORvORLmFbDOxzTsrEtW0WMPQ_1785909355
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE78640005
X-Stat-Signature: zrc7gyxdcda4kh3j56ruyou64e8onohh
X-HE-Tag: 1785909365-709367
X-HE-Meta: U2FsdGVkX1+PiI9bx6H5V7Gg2oz19xYFMSQY3hMDynVAA14PBLr5JY3m1Oxve2mypOEZFTMj6cKcd5eNah0tM751xszgUWbCGfkV7Fy9PKfjQyRSMkZ7DBQ0kAvXV14OuBHsGqrpxMM6duaPVP08NCegZcdClyiuBhKj5baV0ab9m+SZPaa/qpbAthglNB7BLXsf833Io+LrTwyiMS1YhrsOGMz4U00hqvgb/OpCyQFhKx4ORvVf7cnbNoJMD/eaaolL2zG/y645ZuwlBirBk2AhM+Y6oHgXo7Yyt0CKq0ek25ZM3OciJN770c6EsllOrRnEyknKXyOzmY5HIRanGIldcSnyK7Q080KYpVjfFA6zFandYwcIaZLKEuIf0Kgpfc7H4eZPrR13e4FX4LiRnA7X66IHcucediiISAbKrCQ2KGS8UvPyCv9APo6FGjZj1oflfjIZVAHEGTsOe6g3dLbJLdyPxsdyoNtEwUAYwPYAUThKt8X7S/Ik83oghv0AsKxaepqEQ2nqExg7z5fjTIWQUFK9krqMkEAiMT17ZvYNCGA1FJ250elrYRWpGGDrSJ1ElVmUusdr+mRQdBWJk8iVLeF/MxsNoWZGOVd2RLYFgFlKiWLafbz79/m8XpGf0Gl65LGsptF2wuc+x+Ikun45I8nv2m2PFgICY3vBheuQ/er6J8A2B1e08C3/LpQwsiBz2gYagVPyB/Q7pIBzx7bT+RGjbHaEUyxmPgCrpw44HSUCvI81P5e9g7ckAfun8+aKFUb7kOUK74CW+gyq16FH+R5mKCTJAddFth0joPoeMUuLa77iLJZ2Ex1o3VCtBehH9rv+Vq2ZtWYeTVRUvhi1P5nHGWbbODvoVtJBxaaElw66FDmk4qloajX22YYSkTj2bc12kg27dXPj2L41cuz71/Gwpg1UVTOZMAzjpkNpwLnM8/1AFOHtTuSlUrcu+93gx1TC2eA59++2rfm
 mr9Wc4ko
 4stP2iFxArM+VCqzhspM/hZoQw/pwXNrTPnec+loS/UdgdEYHpszmI/76ziaxQj0n47dW2id6+zhH3uxP0UcsF8qVYk97XNboWOv9UIC30sdYfzWl11N06YrvsWKynPfZSI2kdNN+qzW9IOUXsk6gnl5G21R/7YfJ+IRJoT96HvcDgJRmV4NhdP+zec3gAnEpAi5p1syOLpxjN3EGzs6yfaGzNaicCyQuMDdmHUOyvn5IQkMgmccHsTMYB8QP+GreqkSrwVvXcr02oQFx9nDztzLDbS1xHwNZcN5SvClrpeWYnIQEyEbkQp0+07d2rvXnyk9GZoUutNYFgYq43MZ45/GT5L42wwuiSMJDF1QQO7Q9ZmTJ+71I3wGW7pKptc6HAWdET8V7jRHn8mLiDgLCr4xHMkgIjXieUKNhQ8Hlf3QxNI/RXEkNGqC/VKktP2NkDEYgKBPQH/GSRItKMABkVK6swmqsT2s0Q5OhWHmz1ObthmazNXqO8nkgOkOw1oq/to1rLMEVArHg8zDMABzvw8ZOyrNUSYRiusnf7D+6BZoFgS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cedric Le Goater <clg@redhat.com>

The global THP sysfs policy (transparent_hugepage=never/madvise/always)
gates the huge fault dispatch path in __thp_vma_allowable_orders() for
all non-anonymous VMAs, including PFN-mapped device BARs (VM_PFNMAP).

DAX VMAs already bypass this check via an early return:

	if (vma_is_dax(vma))
		return in_pf ? orders : 0;

But "special huge" VMAs -- identified by vma_is_special_huge() -- do not
get this early return, even though they share the same fundamental
property: they map physical addresses directly into page tables and
involve no memory allocation, no compaction, no splitting, and no
reclaim. The THP policy has no meaningful effect on them.

This matters for VFIO PCI passthrough of large-BAR devices such as
NVIDIA H200 NVL GPUs (256 GB BAR each). The VFIO driver registers a
.huge_fault handler (vfio_pci_mmap_huge_fault) that dispatches to
vmf_insert_pfn_pmd/pud, and QEMU's vfio_region_mmap() aligns the BAR
mappings for huge page table entries. Both prerequisites are met, but
with THP=never or THP=madvise, __thp_vma_allowable_orders() returns 0
before reaching the "trust huge_fault handlers" code.

The result: each 256 GB BAR is mapped at 4 KiB granularity -- 67 million
page faults per GPU instead of a few thousand PMD/PUD faults. On hosts
with 8 GPUs (2 TB of BAR space), this causes VM boot times to degrade
severely, with 99.98% of CPU time spent in the VFIO BAR mapping path.

Configurations that trigger this:
  - transparent_hugepage=never on the kernel command line
  - The tuned cpu-partitioning profile (inherits network-latency, which
    sets transparent_hugepages=never via sysfs)
  - transparent_hugepage=madvise (the RHEL default), since VFIO VMAs
    lack VM_HUGEPAGE and QEMU does not call madvise(MADV_HUGEPAGE) on
    BAR mmap regions

Extend the existing DAX early return to also cover vma_is_special_huge()
VMAs. This is consistent with how vma_is_special_huge() is already
treated for supported_orders (grouped with DAX). The mm/Kconfig TODO
comment "Allow to be enabled without THP" also acknowledges this
coupling is wrong.

Cc: Peter Xu <peterx@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Fixes: 5dd40721f147 ("mm: allow THP orders for PFNMAPs")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cedric Le Goater <clg@redhat.com>
---
 mm/huge_memory.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 58cabe6af33d031e48250e21db51506bc46c97b2..6dfef5500a054f09f9ece6df8bf7a0194624350f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -139,8 +139,12 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
-	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
-	if (vma_is_dax(vma))
+	/*
+	 * khugepaged doesn't collapse DAX or special huge VMAs, but page
+	 * fault is fine. These map physical addresses directly — the THP
+	 * policy is irrelevant for them.
+	 */
+	if (vma_is_dax(vma) || vma_is_special_huge(vma))
 		return in_pf ? orders : 0;
 
 	/*
-- 
2.55.0


