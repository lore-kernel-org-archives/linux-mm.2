Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8EC3F01804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCAC6B0005; Fri,  6 Mar 2026 03:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FFB6B0089; Fri,  6 Mar 2026 03:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BAC6B008A; Fri,  6 Mar 2026 03:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 878536B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:19:31 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C36891C51C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:19:30 +0000 (UTC)
X-FDA: 84514938900.12.1439766
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 28379180011
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:19:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHVNtRYW;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772785169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7FTQ9bLkL2DbvXMWxJ9Dl7btlecEv6iTwjahcnkyPis=;
	b=Ifs+BgRCy7hsWje8MLW1Bv3hPemPjTEJQoMXsxFnV0lbFglgWlGjoiqrdZPqxjFSDRvHN1
	LS6zRA1LC3g+80ZxMc2/mcyaat8px7mT6okx100IZTm3pi5yNB+wcbqhYHo+uTv1RX2Z3p
	JnD615IKU/CE5YHNpjbtUypKDj1CM0M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hHVNtRYW;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772785169; a=rsa-sha256;
	cv=none;
	b=Idk620pPON15WNbxHl/VbK3UN7QkutdRdaPAaEs9lO23//jfmwDaaF2ur7Vjk1hPh9PfuP
	lzmHlG31oH/gGO6Ue0WXYQhD0E4UDaEdyMQWNXmyNBzyXcG1Pe4EJsK3hJ9vnaQ+XvAy5M
	OZX0mW/G8O9GxIk5aGQJRYLnfZJgjyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 034DD440E2;
	Fri,  6 Mar 2026 08:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5247BC4CEF7;
	Fri,  6 Mar 2026 08:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772785167;
	bh=kMVOZgHqgskvS2CBGSkoHJyRYRfBjXLs2IdWaLMUf6Y=;
	h=From:To:Cc:Subject:Date:From;
	b=hHVNtRYWV1oR9UnWiXdQaPaj+2AlH0+JXBxnCseutgpZQQw6APuxnIlJXVnLmkij8
	 JdtHoRsDExTjVPf85DdHCvhAS81OtKDsWZHUJ2EFFxJBurMB7Oo1n/XkIRLijGXD9d
	 ZlS28EmLCVwiW7xQo2DkeYNjsFBnxEuG/1qYMoJWZukSkAwtz1zZw7spDYym0fhYjd
	 HvmscLDnnbYzXznX1tydTfBF+5G81l5k5dD+Dru5yO0MpR49lRRg9PqaeA7ajZ3/Sq
	 7TuzaB6ySbOeum4ZQgSvh1Bqxz62xmI8jz5dOf/nrdmF+Fhnqx95hXMh8g8pXxHv7Y
	 IoLZ7QL7yOQnQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2] docs: filesystems: clarify KernelPageSize vs. MMUPageSize in smaps
Date: Fri,  6 Mar 2026 09:19:16 +0100
Message-ID: <20260306081916.38872-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28379180011
X-Stat-Signature: oge4j7po74fy3nxjqtqa6n6njopsdb7k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772785168-836721
X-HE-Meta: U2FsdGVkX1+wyjLBSz/odSKrQ8Hx9TbRSpGpFItNI/wrKo3Wb3W0CAtQmitcZCaQgZbLi1dsMyhMqzQSvhCSOJusk57R4f5O9z1fErXb1XW/DqBTjw8qoxYrTSK52Ig+xaFXEKVykj59tmGSwmbat6x3vLGqDKfCqSZaZBFBfF2C7QWenalXd5Vq+WOVYmIeQMGZuNDDc8eelTtl2MmyIkTwQqDndtKLXn3Rg+cY7+fj8Sz2+jXLpyU6FlHQD7ekITn3lNbayKMT82X4MD/U7ES1oSf3yhDFW+bu2ry+ZV3/+c8GH6R4IihJGkIy6WBPRu22D8OC++0bTiknDRXcWI+/HOcvdUV3JtTIC0vLt7YrI58KxLMpedFDnF6RPwBxwHidnx7R9TWekfiGMaFojT1f1/eOFVAmGQvwxUookOIItcwyPrQwq4qRh4dteuh4j1ay+AZPXTY+tSabi/vF+pyPy9TBb77gjiHHTTn4NMwj0MZOI8qxcDEITrqHyXM1re0d/xKOg2NS4lLZxFxgXaxRUxukxiZoJuBYshA8lgJsLbygoMK54RcKcwd3i5emoCDsetTMa/otV22g0zLjCiyJeMYebo335EzTapC69kydLzRMmuGygiMHknxB3CMTlCjDe+xhZ3Hk2dsmyXI4bT9n64nNp1umZdOrYOVnN6GXj06OYIef2lQMF1KddGwzGLfEJYg8kddD6r+hfKRsY2EidN0/uJGn4v8G9GHWLLWcOzsEYORt7msclxu3WUtbyGjCM83b+22rW/534w3uqajqe9WhEj6wt8UY3DOrKyZMv0PpR1jd/6beqLTE19KtFR13XlZixCeP/6RDAt32ni0igu/ssDzW3RmxmGL0o17CQQIpq+qFhlDGBOJL3TBnKzkwBlJBwCpIs9dOlbUcgd6E0X+GTaRvC36j+67aA8OQ5kuZF5gBN92hYy01Ol2OdczVqsLr8rp3khSE+6f
 OMUqI6r/
 Hu8HztXpUP8/IIrxzuny6e35V4Uzwi+o1mD31N54nQ0MKZ07oNq/7da8YrPL+dDcuCOxieNK5yV4bOCTDdGs9EIrzfw23gR6zLzaOi/NBSNEbsD2RVJsQN2k40AXMNsvt6t5HGyG3mSjKdyH33GeyT6Qs/g83GWhVgZyfqJ7y/LNlkz+K2FVS2m3FzuFu4PdTehcxYF4LcOSqCNGlDdgi7XM8OUFn4KeAur2cK1CYii0pxaHx8S/5miDoIcqjpWal+/GwQPshwinFt0JLKt8GKnCCRIHmPwkoH5qaYURt5JXNPskZ1FpCzhqQNsxeQ5y/I8so8CnbWJdMoO/9rVKo+SaWwgoo2Finxw9naaUdi0xTKsZ25Y7lP/h/likyPH/rEbAMGJNxY+va++sbotNm2gPc4Vq5WLun/wFkdyvu6sTMEJGM4+9XjGo6l3FV5ClBaMo3Y/vd+T5gUuhmHjNpfbGHqR08QVrF48dwCUtNoiqyofSLAiuPzxnOgPsGBmcCYLLYI6vRIAe/7RKVhIblpgdmQu6eZkqRRjfNKoxBlPf2oWiD43aJCHcaHv3b3RLZUiuO9kRaZn6zdcf10CJzphj0u0WfTIoA1L7pT1Ac0nkaJpU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There was recently some confusion around THPs and the interaction with
KernelPageSize / MMUPageSize. Historically, these entries always
correspond to the smallest size we could encounter, not any current
usage of transparent huge pages or larger sizes used by the MMU.

Ever since we added THP support many, many years ago, these entries
would keep reporting the smallest (fallback) granularity in a VMA.

For this reason, they default to PAGE_SIZE for all VMAs except for
VMAs where we have the guarantee that the system and the MMU will
always use larger page sizes. hugetlb, for example, exposes a custom
vm_ops->pagesize callback to handle that. Similarly, dax/device
exposes a custom vm_ops->pagesize callback and provides similar
guarantees.

Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
regarding PMD entries.

While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
and "ShmemPmdMapped" entries really mean, and make it clear that there
are no other entries for other THP/folio sizes or mappings.

Also drop the duplicate "KernelPageSize" and "MMUPageSize" entries in
the example.

Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---

v1 -> v2:
* Some rewording and clarifications
* Drop duplicate entries in the example

---
 Documentation/filesystems/proc.rst | 40 +++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..e2d22a424dcd 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -464,26 +464,37 @@ Memory Area, or VMA) there is a series of lines such as the following::
     KSM:                   0 kB
     LazyFree:              0 kB
     AnonHugePages:         0 kB
+    FilePmdMapped:         0 kB
     ShmemPmdMapped:        0 kB
     Shared_Hugetlb:        0 kB
     Private_Hugetlb:       0 kB
     Swap:                  0 kB
     SwapPss:               0 kB
-    KernelPageSize:        4 kB
-    MMUPageSize:           4 kB
     Locked:                0 kB
     THPeligible:           0
     VmFlags: rd ex mr mw me dw
 
 The first of these lines shows the same information as is displayed for
 the mapping in /proc/PID/maps.  Following lines show the size of the
-mapping (size); the size of each page allocated when backing a VMA
-(KernelPageSize), which is usually the same as the size in the page table
-entries; the page size used by the MMU when backing a VMA (in most cases,
-the same as KernelPageSize); the amount of the mapping that is currently
-resident in RAM (RSS); the process's proportional share of this mapping
-(PSS); and the number of clean and dirty shared and private pages in the
-mapping.
+mapping (size); the smallest possible page size allocated when backing a
+VMA (KernelPageSize), which is the granularity in which VMA modifications
+can be performed; the smallest possible page size that could be used by the
+MMU (MMUPageSize) when backing a VMA; the amount of the mapping that is
+currently resident in RAM (RSS); the process's proportional share of this
+mapping (PSS); and the number of clean and dirty shared and private pages
+in the mapping.
+
+"KernelPageSize" always corresponds to "MMUPageSize", except when a larger
+kernel page size is emulated on a system with a smaller page size used by the
+MMU, which is the case for some PPC64 setups with hugetlb.  Furthermore,
+"KernelPageSize" and "MMUPageSize" always correspond to the smallest
+possible granularity (fallback) that can be encountered in a VMA throughout
+its lifetime.  These values are not affected by Transparent Huge Pages
+being in effect, or any usage of larger MMU page sizes (either through
+architectural huge-page mappings or other explicit/implicit coalescing of
+virtual ranges performed by the MMU).  "AnonHugePages", "ShmemPmdMapped" and
+"FilePmdMapped" provide insight into the usage of PMD-level architectural
+huge-page mappings.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
@@ -528,10 +539,15 @@ pressure if the memory is clean. Please note that the printed value might
 be lower than the real value due to optimizations used in the current
 implementation. If this is not desirable please file a bug report.
 
-"AnonHugePages" shows the amount of memory backed by transparent hugepage.
+"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
+memory backed by Transparent Huge Pages that are currently mapped by
+architectural huge-page mappings at the PMD level. "AnonHugePages"
+corresponds to memory that does not belong to a file, "ShmemPmdMapped" to
+shared memory (shmem/tmpfs) and "FilePmdMapped" to file-backed memory
+(excluding shmem/tmpfs).
 
-"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
-huge pages.
+There are no dedicated entries for Transparent Huge Pages (or similar concepts)
+that are not mapped by architectural huge-page mappings at the PMD level.
 
 "Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
 hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
-- 
2.43.0


