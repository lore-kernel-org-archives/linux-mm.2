Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BADE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C68A6B0005; Sun, 21 Dec 2025 07:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574786B0089; Sun, 21 Dec 2025 07:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456286B008A; Sun, 21 Dec 2025 07:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 315986B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:56:45 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCDA516086B
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:56:44 +0000 (UTC)
X-FDA: 84243477528.21.A14982D
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02D6318001A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:56:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LDEXtzk8;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766321803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0Ivv8/3ACbIKOnDf+l354pCkgSIU4HYGFindxr8g4Hs=;
	b=KabIVw98NiG/W/90bqW8VKv6W6HvuIbl5G6mYY3On7FGilmi0JV/xdDrL5nz5uD4UZXqaQ
	micgFa9icMFyQ8oWloNW4wERbLF7mHC/6otwxNzeLtrGzfYTnL2U6Cg3Igc2Si8slmJPRx
	Cf0PHq6xHdMFxbpqJqlO0H8WlxPlE2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766321803; a=rsa-sha256;
	cv=none;
	b=5xI0rxxYOGmTN1vgVESCt/R6/4bo0hp4tzp3wAQ+NuZaXxVDilTRgqVbZU6sHCxYU/Cihj
	2e9r5k8zvdxlrKp/j0i4UDU9R9fCUwO9Zt6wfLAqUPn/EnkBWyRfBx9P8l5mXGM+qrGy+x
	ACYPqJCCRereuEM+vMj9hY671uhCwsA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LDEXtzk8;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8c0d16bb24dso128887385a.0
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766321802; x=1766926602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Ivv8/3ACbIKOnDf+l354pCkgSIU4HYGFindxr8g4Hs=;
        b=LDEXtzk8w/j8VMeahedemnufwbGiKg/VXeznQkV802J+X1x2WtibvoS2mF8xS9301w
         6REK8KP5nysdJ7ek+3tzES2RONj+DxnGb3gNLrEZDOfpvDAKlZB0j8N2L9odArjMYJqo
         JM1hJsFFpihnh3q4KUyWmIvvqnNO24sfMY3yACGhD8cDTcxfRr8UzmGBie6IcCYgpXxF
         Tk2q30k6SQhab077sr2aQeNsPkubCqBTinVvKYyqDuTtyTsfv1FOGzyXWKmCIBf7djzD
         NvPUFrJ1HjBx5VeJR6ucJ1sUQB+vCueI4edeaywrpSve++ATGujhBPiowH7R/ctgXHdc
         wraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766321802; x=1766926602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Ivv8/3ACbIKOnDf+l354pCkgSIU4HYGFindxr8g4Hs=;
        b=R+mUIrA7EFur8fLXwgUGZwdiRz4LQdh8g58tavMRSiev9tXhg9wpaE6k3V1SaU2qXn
         mDSlS2nOG/adnmVpveUijtQ1fx11c2N//ASFc6cjT9790ZpyD+j08XS7sQAjbq/FpJcR
         ZJoT3OzRPOuoLttl1KDw5ZvsI7mafKOGvUXioPRoPaukZgU8hL7hCDd0GXY6H+/Tfwao
         gFfhm5XTx7/9OCFywdKM+mTiIaUvVs6X2Y+ARCKpmQEGML/UWLGY2u9tEelxoSrovh52
         BcRwB2bv7o/RtdmoDP+3UKb9Ehi/DOC+CkOykVqFYyl7DDrmTGbnzRWFp4GA+iGnzmEX
         30GQ==
X-Gm-Message-State: AOJu0YxVq4+A8L07wwMwj2+cQ8db19trtVSW1dGeFTem8nWeHDzbuXLw
	3Rk90MEtfKbWeQZTeH/g1vaT23ZKt7bGX3/tHtD8V6rD0gnh+Ln2cFJs6otwDPmDfKNRZOGJoH+
	WRP7vNlQ=
X-Gm-Gg: AY/fxX4EOXstpuMXS4URTSiuMMLOk2NyiK9B/C8P4Ay4FkRbUmFSvI8ZE0Y6eih9zvr
	j/WDB1rPITDwuLTVh6I8wp5GvkQbo7RMwdCCgLVpOYJdvYCYI0IEUlW/gBDlkTkHDUMAq2WRx13
	oQb6U8mTrSlbwsYfJZt296s/YBXwZRw96/ADqePc/wjkKlvjD537ejtIgOYkEBU7TZxuAoFiOuc
	kDW9Gp6KZpP5i6ZYCL4tg3UyXCZiY44qGftIqD0xxv3R+86+Di8tQxoqarndJT0Plemw8fcGazd
	1OgH57KMoKT8BER9dUP/M6wCA6MtFFKSsRwEtjeIhvMitHN7d5w7wXm8nP5B94d0Dgv8fwDpVHm
	Nxikj79JJet/QLksTIx7pWFg06xGSw/tLZ3R+E9SaWLJYfQhXD8Yu6Q+hyBPUI5F0+ndVB5wCjJ
	dhYCkA3Du+eP0nW+ky7D3Wdf5kMZhD0TZGxrCR9j2vTU3hs6vJmZTpCQkXC6mHHpQrAoeZmnAXt
	oltJwoFlCMVbA==
X-Google-Smtp-Source: AGHT+IE0BrkfD+Cy9oYJoP0dF/V6XgbZIAfAJdoj4kHZiMOQbZ89Gxxq8Q27csX/VrtUN9ShpMHINQ==
X-Received: by 2002:a05:620a:190a:b0:8b2:eea5:32f8 with SMTP id af79cd13be357-8c08f6763bamr1307185985a.34.1766321801715;
        Sun, 21 Dec 2025 04:56:41 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c0968935b5sm619955385a.19.2025.12.21.04.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 04:56:41 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	hannes@cmpxchg.org,
	gourry@gourry.net,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH v5] mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Sun, 21 Dec 2025 07:56:03 -0500
Message-ID: <20251221125603.2364174-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6me9hjhfx1yfe6myn6co596au43ge7mk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02D6318001A
X-Rspam-User: 
X-HE-Tag: 1766321802-515242
X-HE-Meta: U2FsdGVkX18ASkv0tX0IcpeZijMSfpk3Wt0/nvK/6MentFeDWRKHN4fb0RiTpUXnY9wKlRDSnfrTmu0cuhjPdQp5mmGltqHrLmkI2SEWLCg71qhmJ6VdKozPNVp6t6Uh3/mWneX8WYPJ5BQOghIaiR0U3aRBDNa7sjgbyWqKFeTdTZXWAMBjI6rm+sRxLngcY35b9g3ABmUqwh3+svdOdddrscuHA02b4aJkARVbQgYe1ELIrgYTirieXlsaqui6Z+IYXee93E6B00J5lzzAVvHvJkmX4L7Huw87wKeS2eYCi115EAindmH29kQcEk4uP3bvFBYjbVx3n5UuY3ey7OfwYZnTzN4Bs6sYVoiQw9Ze2hf4XTzrnq/2JwaGyMJXS93SPe3CBDw82w5KtenDnfJPdgn0+P+jBv4d2HSZuhWDuCNUsjOxo2qg1zXf3EO5uh4R5UNBiL7bU8Nl2+DagFxDG6fPhRRoAqvG/+v3UlnDSwKpgl/1nbQ7odMmw+d2J12vnVJDuFEMETh0nDDLlHqYR2SbQ2YDEz0NsfSBVfnrqkTPzBqFgjrDWsuw7cXUBjjh/syQboTbNxyqCTwe8jIn2R4RLY9UYCJOPlZyUuqxNRoRoGEA5Dca+qWA7sR41Lrtk3sRriGRUpnBZYMhI7WEuwbabQ7ObG4RbfirG5N3IXd1Depr2GVbb2t8QF4zb2BFfWRHGmh/ZwyMaISUcDKQJyiU8LHB1qbCbinSXcgL3zFqZEZB4nEdunLIzty4j1j93M1jd7Pwvid8bKismSoYp2rJbk/XJput7XK8KgGNO0vI2/rPlYfpNhP0GsumhDfbBthuKyqou8LhicVsWVVekXD5HKyLoy2JBOBwu6smlGr3eM4D26Eo0dyVUNNbhYQ0iNClFJ8Wjm5hrVTVJ7SwtT1g8i/yu8VhSU0s/W3Cr2XXUfotQ5KRq860DU0BBAM+6lGQHgbdXQ0ossW
 /+M42Y8K
 6lp8Qj6CaBes/oRjm9haSl8i030tPYN7aWVWiHCd+yiXWwig1C7y/n7cBi3NXRXN5XADcageyIAGzPISOSYim7IOuaLtLpIQCh710qKkNBtkvLfayC8kmbqTXqq8HNhxZl1t1bZX8JrY1VJWlRjTUNdJFHOqANu30p4VrBtmZiewh85qIt3M3L5svjjLiRTD3rCV2NZYwLJpiMqgP/KeMf7x2k35o0jiYkAvNh4gFe65BfLGJUq7vbm2PqTnBUPPD2NixsDPuMgEuaD1o8GxeOyLG/wPNJjL8Bxq0A6CKXuv1eKrabHxACcKzDdA2+r6CIftj+cDhQKuGRNvJn7hh2SEJ6scTpYWoxa/S8Tjhp1Ql38n3WuPMZmkDX0x1zaqvDrzY0wACoS1ZdyEMK5IBp++taG4HQKOd/yHjtL4XknGZ3UoHihfF8JqrjHtbSrvnPKGNkb7Sb38Fb6ozJemnupmNaXp8Z3OUJpHFgIlteN+BlXWjpftq0VYPhdZvTlLzdB3/nNA8scFFz3zPJTr60N8BNgvqavJUWibXzD2CzahJfA5BJXva5+nu71KXox7hCt6GEWvHjaySAxQiNkkm0U+9vJGO0E5bnyiMpQcbv+2wvmjxgfY8E5yA/+llzv+1rhFH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reintroduces a concept removed by:
commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")

This sysctl provides flexibility between ZONE_MOVABLE use cases:
1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable

When ZONE_MOVABLE is used to make huge page allocation more reliable,
disallowing gigantic pages memory in this region is pointless.  If
hotplug is not a requirement, we can loosen the restrictions to allow
1GB gigantic pages in ZONE_MOVABLE.

Since 1GB can be difficult to migrate / has impacts on compaction /
defragmentation, we don't enable this by default. Notably, 1GB pages
can only be migrated if another 1GB page is available - so hot-unplug
will fail if such a page cannot be found.

However, since there are scenarios where gigantic pages are migratable,
we should allow use of these on movable regions.

When not valid 1GB is available for migration, hot-unplug will retry
indefinitely (or until interrupted).  For example:

  echo 0 > node0/hugepages/..-1GB/nr_hugepages  # clear node0 1GB pages
  echo 1 > node1/hugepages/..-1GB/nr_hugepages  # reserve node1 1GB page
  ./alloc_huge_node1 &    # Allocate a 1GB page on node1
  ./node1_offline  &      # attempt to offline all node1 memory
  echo 1 > node0/hugepages/..-1GB/nr_hugepages  # reserve node0 1GB page

In this example, node1_offline will block indefinitely until the final
step, when a node0 1GB page is made available.

Note: Boot-time CMA is not possible for driver-managed hotplug memory,
as CMA requires the memory to be registered as SystemRAM at boot time.
Additionally, 1GB huge pages are not supported by THP.

Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
---
v5: build fixes, clean allconfig build with intel/klp.
    Sorry about the careless churn Andrew, should be clean now.

 .../admin-guide/mm/memory-hotplug.rst         | 14 ++++++++--
 Documentation/admin-guide/sysctl/vm.rst       | 28 +++++++++++++++++++
 include/linux/hugetlb.h                       |  3 +-
 mm/hugetlb_sysctl.c                           | 11 ++++++++
 4 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 33c886f3d198..6581558fd0d7 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -612,8 +612,9 @@ ZONE_MOVABLE, especially when fine-tuning zone ratios:
   allocations and silently create a zone imbalance, usually triggered by
   inflation requests from the hypervisor.
 
-- Gigantic pages are unmovable, resulting in user space consuming a
-  lot of unmovable memory.
+- Gigantic pages are unmovable when an architecture does not support
+  huge page migration and/or the ``movable_gigantic_pages`` sysctl is false.
+  See Documentation/admin-guide/sysctl/vm.rst for more info on this sysctl.
 
 - Huge pages are unmovable when an architectures does not support huge
   page migration, resulting in a similar issue as with gigantic pages.
@@ -672,6 +673,15 @@ block might fail:
 - Concurrent activity that operates on the same physical memory area, such as
   allocating gigantic pages, can result in temporary offlining failures.
 
+- When an admin sets the ``movable_gigantic_pages`` sysctl to true, gigantic
+  pages are allowed in ZONE_MOVABLE.  This only allows migratable gigantic
+  pages to be allocated; however, if there are no eligible destination gigantic
+  pages at offline, the offlining operation will fail.
+
+  Users leveraging ``movable_gigantic_pages`` should weigh the value of
+  ZONE_MOVABLE for increasing the reliability of gigantic page allocation
+  against the potential loss of hot-unplug reliability.
+
 - Out of memory when dissolving huge pages, especially when HugeTLB Vmemmap
   Optimization (HVO) is enabled.
 
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..d2e13413e16e 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -54,6 +54,7 @@ Currently, these files are in /proc/sys/vm:
 - mmap_min_addr
 - mmap_rnd_bits
 - mmap_rnd_compat_bits
+- movable_gigantic_pages
 - nr_hugepages
 - nr_hugepages_mempolicy
 - nr_overcommit_hugepages
@@ -624,6 +625,33 @@ This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_compat_bits tunable
 
 
+movable_gigantic_pages
+======================
+
+This parameter controls whether gigantic pages may be allocated from
+ZONE_MOVABLE. If set to non-zero, gigantic pages can be allocated
+from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
+boot parameter `kernelcore` or via memory hotplug as discussed in
+Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture.
+
+Note that using ZONE_MOVABLE gigantic pages make memory hotremove unreliable.
+
+Memory hot-remove operations will block indefinitely until the admin reserves
+sufficient gigantic pages to service migration requests associated with the
+memory offlining process.  As HugeTLB gigantic page reservation is a manual
+process (via `nodeN/hugepages/.../nr_hugepages` interfaces) this may not be
+obvious when just attempting to offline a block of memory.
+
+Additionally, as multiple gigantic pages may be reserved on a single block,
+it may appear that gigantic pages are available for migration when in reality
+they are in the process of being removed. For example if `memoryN` contains
+two gigantic pages, one reserved and one allocated, and an admin attempts to
+offline that block, this operations may hang indefinitely unless another
+reserved gigantic page is available on another block `memoryM`.
+
+
 nr_hugepages
 ============
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4..5c190b22108e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -171,6 +171,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
+extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
@@ -924,7 +925,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
 	if (!hugepage_migration_supported(h))
 		return false;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !movable_gigantic_pages)
 		return false;
 	return true;
 }
diff --git a/mm/hugetlb_sysctl.c b/mm/hugetlb_sysctl.c
index bd3077150542..e74cf18ad431 100644
--- a/mm/hugetlb_sysctl.c
+++ b/mm/hugetlb_sysctl.c
@@ -8,6 +8,8 @@
 
 #include "hugetlb_internal.h"
 
+int movable_gigantic_pages;
+
 #ifdef CONFIG_SYSCTL
 static int proc_hugetlb_doulongvec_minmax(const struct ctl_table *table, int write,
 					  void *buffer, size_t *length,
@@ -125,6 +127,15 @@ static const struct ctl_table hugetlb_table[] = {
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
 	},
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	{
+		.procname	= "movable_gigantic_pages",
+		.data		= &movable_gigantic_pages,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 };
 
 void __init hugetlb_sysctl_init(void)
-- 
2.52.0


