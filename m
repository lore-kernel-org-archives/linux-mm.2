Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AEF7D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 957786B00AE; Thu, 18 Dec 2025 10:12:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAC46B00AF; Thu, 18 Dec 2025 10:12:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0036B00B0; Thu, 18 Dec 2025 10:12:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 664E66B00AE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:12:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D0A612C94
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:12:53 +0000 (UTC)
X-FDA: 84232934226.12.4A056A0
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf10.hostedemail.com (Postfix) with ESMTP id 300FAC0004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:12:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CSjNfJT+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070771; a=rsa-sha256;
	cv=none;
	b=qY1MAdCF9354LCEgAZHE9KoQ3thKF6IiyO/296sDEG1t+tKoWs6uJY+Kjv3STGtWkBPt0i
	0KuMrOTvmcT4okh+X7FS2SlfVdssnx23paWDO7H4KuZmEaFC2P8UWyLjnx/QOTNqspqjEN
	0smXmvVCIphB+klU0jcP6VOsxEsRZag=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=CSjNfJT+;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.196 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TLCkWcJ72BOOvYYIVNRu59Wv5wRsTr7T9AgAEW6gOVw=;
	b=goEbKB4e6feDZClkjozlTC6JHYl8PjR6xcnZBSyY80gbE+etRGYRNoNVE7VYVm2afUkdRl
	G1s1wf19RjrsVCK8uzmJuoaZVl0U5ZlimHxdyzuDZMy3NYxaN5BQAmt83Fs61ENYIxtrHT
	nAyDJdPQ68uxd8rKRW2i8tQhXG8MYi8=
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8b2ec756de0so77866685a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1766070770; x=1766675570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TLCkWcJ72BOOvYYIVNRu59Wv5wRsTr7T9AgAEW6gOVw=;
        b=CSjNfJT+wAxNyw54aSECfPuHengSSoBlN4VKC0GChdPU3DI7ne8IeKwK8ILXh3TfJS
         /V8NwKP+8aVFqXthr8lbUbleqLFJK53+t9bMl0bknBz2PgqWHM55sC6aZWGyTU4gkPze
         jJACrJFvDqg2KQXTXIu5kPu0NRYXdd9/P/0Hxvct9u3fcRzjab0qoegHfgL/zB3SjZQr
         YxSjQSnd3iMq4BEH+ekWQ5js9k39YINKF0J/SACEfROFtBdqPVO1VoDMoo+1Ql0db9O2
         W9oG6ZCtjOhWX8Fnx1CX+L3XHG9V1u588dmrel3iBRqR8esc0npGGx882KHqBR9YFIcj
         1VHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766070770; x=1766675570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLCkWcJ72BOOvYYIVNRu59Wv5wRsTr7T9AgAEW6gOVw=;
        b=l74zclu7hYcJKBqT5mMjqlS88COyD9qNt4VfriTcIOqDpFG8mY821ELtUt/qsHFAs6
         oi1nYTQo0cWebWpcMcHJzyas8MZQjNBZpNhz3PYchTV4JEaC+TvmXnMslTbVDap3d88+
         qJ7wNKsWvvpmUBKijJ0k0ZPkpK0B0L0ZkKgHKHiHpofacPphFxVDvCJc6xcfx6Kiu/37
         WDPsLcUHYjrMAMOziH9E0MN6YsRNz8lqU+uhv3pNxg0rVzqzeHJyQ5feC37yGomvxutl
         FcRGtzpg5ZK+yjOZyDljJt3TE3vF1AQSC66GV1k7Qzuq1qSbRdViOO3qS4o7FJLG6IqY
         dBag==
X-Gm-Message-State: AOJu0YzzwkUN43poL/x9UY93w0zi1GaRKEQTPuyUFw5CfsGwybHWiNIK
	Y6Vn4kS8gzSqS8yiTDmQdZ47WPjmUZv86G9nSNsOC1ezkxXZukKh+zn5vxSzSTRX4wHCJyiJmGc
	7zfY4UDs=
X-Gm-Gg: AY/fxX5PIMF4X0sLREokgHN7bi/rN5QjzxM+7vvNFRYJe0Zq+SXGoKrMV5HSH9rixN3
	G6oizODUA/GcUulvDtDYc///AJ5ihL8F+XqSNbxM49lpZgpNRZG7QQxFQUzVrVwqnSlqLOb/r73
	9nasq3BROKrPW/pVXd51DGSjGk/AhHpm8ehZvCsXtQujU7JwkkPafIoWlURfKL7Ijol0JTNKhJ1
	1eIZASDoeTKZ6ki764lFx/H4d1mfrNafd458zxtMoF4WvwcexQtfl7PI3YNM6yEfz+jwMzupJNz
	IqalZmI++WN0bqbZbIl7ExVSwapGruhc8ZzJ2nzL+N9h0sp7uzi04viMHsr5jYPdTQurnj8887J
	gsRKcsi0VCOlbIPzoIiG5yN0XM25JaSCk/IP0NZNI1qE7AEEr1efENXFkRMB5HQczjSyU9p13XF
	DdVZ9A/Hqb2KWVdKu0Cpxm6SiDOcE768KN5NE0M83ludrLDKY7PnMcax1+GDXUCfIt2fVjZoLks
	GQ=
X-Google-Smtp-Source: AGHT+IF8QOjxn198ZMWdMy5FbBZV7CcXkJ/i3SNag1nGec5ERyqxySnQHrvGD+ibIfbBL8iHi7Z+2Q==
X-Received: by 2002:a05:620a:4706:b0:8b2:bf20:f0ef with SMTP id af79cd13be357-8bb3a36becemr3007188885a.54.1766070769870;
        Thu, 18 Dec 2025 07:12:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeba394cfsm181923385a.42.2025.12.18.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 07:12:49 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
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
	laoar.shao@gmail.com,
	brauner@kernel.org,
	jack@suse.cz,
	hannes@cmpxchg.org,
	gourry@gourry.net,
	mclapinski@google.com,
	joel.granados@kernel.org,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH v4] mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Thu, 18 Dec 2025 10:12:11 -0500
Message-ID: <20251218151211.1237411-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 300FAC0004
X-Rspamd-Server: rspam10
X-Stat-Signature: 4i8on4r4s5jmf9jyr7kc1rwnx8uerxto
X-HE-Tag: 1766070771-530844
X-HE-Meta: U2FsdGVkX1+UZQAsRmuJUO/zA9x3LMoUvAnruMyNrHvuhIjoFyH1HUoMwtZvo1nzT5ZdORWR+Mf8fNbSN3oU8jWwFDSsb2JGEWkuoWIxYjfi5yQvj/s6ybTJJVRDng1bBCES1njHYFup5r1pO1fqB/dpBHT5Y2Quv6/vr6oeNHcG6b33Fxlqb0UbvfFVKeaTlKM0X3Xk3cVWkoJl11A1xTVyP3f2uY1ywKF7r4jWVC7T25GuVlEKJgWPY/AY+2FuD6RvUujIDnUQPLE8L4Bv+/xnyVYw7IhALmMg/XHeK8rAnjXkyXGPR1Fuo3lrChkfolkx83+wFdP9vgcdrOC7+1gw4iSWwImy/V1PBPPnPB6kE7FBHMcuIf3GS3kQqSylXmuu6RdHxb/+zaModZeSQVeo2NoKu2twLww79lkPHwdVEtiUo0VdOz4qU1S1iqCnm/gW2W45D7Y8P6U4xYPbcFLqft3aS33b+4Mil548lnFFZ/nHgqAmAVIcyC+4tUUS8duCtbHVCsp38kLy16BJTCjQz3lNCgLHQcQW/OJx/9r1lhTFCst+Aix6+TzlcWsl5gGs0nqd1f+dWRijgTZtmddl3pBjKQ7d1lz+P+1l2hWhCtysVzmgMrqwXX8BBYLt3SP3nK1zJveclyVNNm0SL0Wvvj1tgbDsuyQ3AXM4URlLcmm+21KyK7R4xDHMqVbo+GxxIypN3og9QzTlS3sCMGSjZ/crf1uJnanqDfXg4LyvfcO5fv7ZxOxerc3shYNu+0Xgl9WSfkjaEFuludaGQpXLgp/ryemZ6z6qEPVO2iQgF87J5zI6/hm7b6zhwNjBi6k/rbyCX5RFsNPJzgWJS5EHoG3DkSC1DUsYho64BnVCQ9Ri6XNRospWfvatsEQ1XsYO8fgfCXKn7kGBaDeidkC4PB4yhSLhiyfn1efFINm8IBhS5ixfChjRiaA+t9QAzE+fpNFT865ps/vu1hA
 /KtpT6Ft
 fajFOSISFdQ4iCKu4raquVLBLTzesC+XC+wbV6+LRWzIC1F3M3hurs7U3LNu1tnypcuVvA5NM+mpcybYJVwr+PSIQFYld00AkkPfTMPL0fbUlGmae3W140nubYLCKypI7k3/G+2ORn9a8stKTOl1m+2dEEFtpHTT9v6Bp8g1ZJ9JsSgVidNb4ZamKJcdxUL/T75jap8Inaaykn+XMmluu7S+N/1sOp+d18REIhFFoTRkxPei9h3WQtwVeZ6st/UGQ/k110VvIT+WR2BxZ7OSDa7bjpu65BhS6Rucmn2FIjg9sWUIiTJahMqzDgqocN2NwH8i5M/2DOqv6GBEjQs+G5ak7oF0PD0A2UmMi7ouJOwHR983QJVF1jjcqNCcypIyw0t515wwantd6zx90Xdhe1BpuNrmnzpWc5dqKKsSRb0o9KF8Q+3E9KGL1upQV18OZS0TiMmb3RzlYUjaXSX59fc19BBTHGeYR42yUGwMoGs7MeKDusS2gsk91xgm/dKnivHejkCgB9vCp5zMjSN/wgjslL42D8hD3kuoQ6+pa5O92LucqMpfk4nqe3qTxecK6O3msmo7DJIWAqKH0cuQ8fYPqdN8AUa2wD63OP1KPZbTUUSQ=
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
v4: additional hotplug documentation requested by David

 .../admin-guide/mm/memory-hotplug.rst         | 14 ++++++++--
 Documentation/admin-guide/sysctl/vm.rst       | 28 +++++++++++++++++++
 include/linux/hugetlb.h                       |  3 +-
 mm/hugetlb.c                                  |  1 -
 mm/hugetlb_sysctl.c                           |  9 ++++++
 5 files changed, 51 insertions(+), 4 deletions(-)

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
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9e7815b4f058..084d45d5311d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -49,7 +49,6 @@
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
-#include "hugetlb_internal.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
diff --git a/mm/hugetlb_sysctl.c b/mm/hugetlb_sysctl.c
index bd3077150542..22a9e15e534f 100644
--- a/mm/hugetlb_sysctl.c
+++ b/mm/hugetlb_sysctl.c
@@ -125,6 +125,15 @@ static const struct ctl_table hugetlb_table[] = {
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


