Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1CFD3B7E5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B856B0010; Sat,  6 Dec 2025 18:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CC126B0011; Sat,  6 Dec 2025 18:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB5D6B0012; Sat,  6 Dec 2025 18:03:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2234B6B0010
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:03:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9891B966B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:43 +0000 (UTC)
X-FDA: 84190575126.11.1D9283C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 15E5340010
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:03:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onRjUf4S;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765062222; a=rsa-sha256;
	cv=none;
	b=gPoWTeBskg2wKKfom+ocamIKhhhRiVmYyz9Evwv1Fc53LIkBKKkGY4nCiy36Yjc2IAg0xm
	sp9lUY2Uj0WdtKU7mFULuSEDWhjHwHFI8E+F4U4K5RDRVYLkgOi+DIVjyLMCujR3+AqmUz
	55/G1TBzsvwHvdyjG2CwH7wWfhox9PY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765062222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIEXiWIZmPCWkeOZ/5Z4AQAsFZvFVPzGTa+khDHoR1k=;
	b=y67bYjs9gKgGla1O1UG69zYsk+naDu4nIr6HusIXLCKHD+Ube7O8McbsDnGa6i7c3MVD+2
	WQVrT/higMD/5zTuJmwmEu/QRdn4TkFioQpZiOJkLbV2RIeJT64jUEMlbic+Wp8yct49Tu
	Np05PTcwMvWgdlwDwjbuY9tGpNvRM5w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onRjUf4S;
	spf=pass (imf11.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3872E443FA;
	Sat,  6 Dec 2025 23:03:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 120C8C4CEF5;
	Sat,  6 Dec 2025 23:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765062221;
	bh=WHJfnX03Qhe5MAHXckJ6+iBYj5iKhcYCByHpge4YFyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onRjUf4SEmz0B3nt48kd8t3Vqy52/EYfETxZQFdsGM3bA3ifU00K0VYA++NOLhNB/
	 05znO/xTpxZEQnzCjrodNKx8hfBGf9kS1wHIUHIrknBvweyHAQdkPUATgPPf00oHqc
	 DA1wtxA6qD8BxNb2+FYy6BNr3eBcIITovaOWqnN6n4/kxA/LBzgYZtpv7EFNlbUGBv
	 xsL6hqBZrPBl2Vl4woWJXSFTKZsgz6mqoa7HRRCwXKXvqWA7PbwnidQCA4i3dtQTXw
	 qnNXHt42cbKem1jy7IH0GiyHsLFL5O2zqH8yDMlsUDPKw5eAyL131d3bRZ/vrZhCY9
	 y83T4yMMJslFw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Vipin Sharma <vipinsh@google.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [RFC PATCH 06/10] liveupdate: hugetlb subsystem FLB state preservation
Date: Sun,  7 Dec 2025 00:02:16 +0100
Message-ID: <20251206230222.853493-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251206230222.853493-1-pratyush@kernel.org>
References: <20251206230222.853493-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 15E5340010
X-Stat-Signature: 1kkuasjos5ax7khxfqubjj87ta5bs43d
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765062221-513246
X-HE-Meta: U2FsdGVkX19sSqa5kS7Xk1ihK/Ad9dJuRilxlLdmTdt2YZNJIl9RmnnFMZ0th5MD5eFvUyrsk7xmwK2nlFLd/KjAMy9jN+Zhu3sr19Ctq5nyPZ+/AC+AkwL2XYAu4Tgqf4QVlMEYUaHnPflPTTKeG/2p0RAF9Wz2ANKL0mga50xj8mWd/RnuHFI4ppEMzZ0B6DKB1jr9zoesIcs+v3GCZoySpA5DU/9T4bAwAiOdzVA3Io/pe5ZgStSqWtBAgaxk2mLKWrSnOF5fOTeeBdBBc5CVwHFs7Y5UXPTZMge0MQ1+Gs+8cxOx/nYau0ywdluUM3f8Pc0m7EVY1tldZKZrsDI7KFJ+o2KQj+GirAUZ2gjBwBYYxV3IaLIJomfDPCiiUOo0srJzoOKKJ5OstmECMZIXOM53HzrZW2yBM6h5gP7/4ilRl5IOkFCFZAzPIGIwUi7+EJTB0SrJBC2/QIWXty2vd4DVPB/IbEbMq/bKXL4V/CEo8oStSH2LfzwQrPeCdNBVqaHPQkIBAtQ9OYdvui7fA7fcH+YkLas0jbxGq8hkCKH0NBDh0eeXjodlnaEH23wX5uAhhtyy9ZBiRKNkJICcA0PNRgYukqZ1SOBq7p4XSUYRyzyH/8nq4HzCqUfrMOJYudPda8NmWrT+WzQebQFjEgWBOjsbbuKR3EZ9pVc5CnajiOMWWBKaFKsaBqHo72sDE4u8ofXHjNxBM5peAhUqFkZC4ypCNKt6L04lBlyvwYpb6A3geyQv9Y70wEPER811GDgi1ilYWyy+KpBygxKEJTYW7Js6Vzqb11dk7vVfQfDwVHr2yWLCPK0W+wy2aRQR6s03yCs+0yTkYCBhTU0YUobhc0AItpRvRovF70CI+33BtcHwKgsJWjSH+XrXREvIJzTpioGS1jA/3sKxItdkloHLvnSTl+5GlmR718zCXOguTl6P5JKBKIaQkLY2GeOhBHuS6cBdWH8FOzK
 dz9p0yv8
 61P+Bx2vfQdLspaDkUvrn+5irTfqZ66KQ+oh+n8UnXPRSxVY6DXP3n4XnYiolZ6IG6rBlvEwDObvFTwX+KaMFN/BFG5xQmf56doYtia4aRv/utjvNB6FeTbzpNozWJotUvkjKUOkmG7jti0WQfNp3rkfbTEVDZh8+62m6mtVEsdxKTZpWlYe1YVaOtWeMcvpnU3K//EanICp0MK5+ncR7Ttnsf4h+zcx4SysyoZb/qD8owEYhU7pomwcPj1qZOn//1xGH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB manages its own pages. It allocates them on boot and uses those
to fulfill hugepage requests.

To support live update for a hugetlb-backed memfd, it is necessary to
track how many pages of each hstate are coming from live update. This is
needed to ensure the boot time allocations don't over-allocate huge
pages, causing the rest of the system unexpected memory pressure.

For example, say the system has 100G memory and it uses 90 1G huge
pages, with 10G put aside for other processes. Now say 5 of those pages
are preserved via KHO for live updating a huge memfd.

But during boot, the system will still see that it needs 90 huge pages,
so it will attempt to allocate those. When the file is later retrieved,
those 5 pages also get added to the huge page pool, resulting in 95
total huge pages. This exceeds the original expectation of 90 pages, and
ends up wasting memory.

LUO has file-lifecycle-bound (FLB) data to keep track of global state of
a subsystem. Use it to track how many huge pages are used up for each
hstate. When a file is preserved, it will increment to the counter, and
when it is unpreserved, it will decrement it. During boot time
allocations, this data can be used to calculate how many hugepages
actually need to be allocated.

Design note: another way of doing this would be to preserve the entire
set of hugepages using the FLB, skip boot time allocation, and restore
them all on FLB retrieve. The pain problem with that approach is that it
would need to freeze all hstates after serializing them. This will need
a lot more invasive changes in hugetlb since there are many ways folios
can be added to or removed from a hstate. Doing it this way is simpler
and less invasive.

Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 Documentation/mm/memfd_preservation.rst |   9 ++
 MAINTAINERS                             |   1 +
 include/linux/kho/abi/hugetlb.h         |  66 +++++++++
 kernel/liveupdate/Kconfig               |  12 ++
 mm/Makefile                             |   1 +
 mm/hugetlb.c                            |   1 +
 mm/hugetlb_internal.h                   |  15 ++
 mm/hugetlb_luo.c                        | 179 ++++++++++++++++++++++++
 8 files changed, 284 insertions(+)
 create mode 100644 include/linux/kho/abi/hugetlb.h
 create mode 100644 mm/hugetlb_luo.c

diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
index 66e0fb6d5ef0..6068dd55f4fb 100644
--- a/Documentation/mm/memfd_preservation.rst
+++ b/Documentation/mm/memfd_preservation.rst
@@ -16,6 +16,15 @@ Memfd Preservation ABI
 .. kernel-doc:: include/linux/kho/abi/memfd.h
    :internal:
 
+HugeTLB-backed memfd Preservation ABI
+=====================================
+
+.. kernel-doc:: include/linux/kho/abi/hugetlb.h
+   :doc: hugetlb-backed memfd live update ABI
+
+.. kernel-doc:: include/linux/kho/abi/hugetlb.h
+   :internal:
+
 See Also
 ========
 
diff --git a/MAINTAINERS b/MAINTAINERS
index fc23a0381e19..55ef24e80ae5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14481,6 +14481,7 @@ F:	include/linux/liveupdate/
 F:	include/uapi/linux/liveupdate.h
 F:	kernel/liveupdate/
 F:	lib/tests/liveupdate.c
+F:	mm/hugetlb_luo.c
 F:	mm/memfd_luo.c
 F:	tools/testing/selftests/liveupdate/
 
diff --git a/include/linux/kho/abi/hugetlb.h b/include/linux/kho/abi/hugetlb.h
new file mode 100644
index 000000000000..55e833569c48
--- /dev/null
+++ b/include/linux/kho/abi/hugetlb.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/*
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Pratyush Yadav <pratyush@kernel.org>
+ */
+
+#ifndef _LINUX_KHO_ABI_HUGETLB_H
+#define _LINUX_KHO_ABI_HUGETLB_H
+
+#include <linux/hugetlb.h>
+
+/**
+ * DOC: hugetlb-backed memfd live update ABI
+ *
+ * This header defines the ABI for preserving the state of the hugetlb subsystem
+ * and a hugetlb-backed memfd across a kexec reboot using LUO.
+ *
+ * This interface is a contract. Any modification to the structure layout
+ * constitutes a breaking change. Such changes require incrementing the version
+ * number in the HUGETLB_FLB_COMPATIBLE or HUGE_MEMFD_COMPATIBLE strings for
+ * hugetlb FLB or hugetlb-backed memfd, respectively.
+ */
+
+/*
+ * Keep the serialized max hstates separate from the kernel's HUGE_MAX_HSTATE to
+ * keep the value stable.
+ *
+ * Currently x86 and arm64 are supported. x86 has HUGE_MAX_HSTATE as 2 and arm64
+ * has 4. Pick 4 as the number to start with.
+ */
+#define HUGETLB_SER_MAX_HSTATES		4
+
+static_assert(HUGETLB_SER_MAX_HSTATES >= HUGE_MAX_HSTATE);
+
+/**
+ * struct hugetlb_hstate_ser: Serialized state of a hstate.
+ * @nr_pages:     Number of preserved pages in the hstate.
+ * @order:        Order of the hstate this struct describes.
+ *
+ * The only state needed for hstates is the number of pages that are preserved
+ * from this hstate. The preserved pages are added to the hstate when the file
+ * is retrieved. This information gets used in early boot to calculate the
+ * remaining pages that must be allocated by the normal path.
+ */
+struct hugetlb_hstate_ser {
+	/* Number of _preserved_ pages in the hstate. */
+	u64 nr_pages;
+	u8 order;
+} __packed;
+
+/**
+ * struct hugetlb_ser - The main serialization structure for HugeTLB FLB.
+ * @hstates:      Array of serialized hstates.
+ * @nr_hstates:   Number of serialized hstates in the array.
+ */
+struct hugetlb_ser {
+	struct hugetlb_hstate_ser hstates[HUGETLB_SER_MAX_HSTATES];
+	u8 nr_hstates;
+} __packed;
+
+static_assert(sizeof(struct hugetlb_ser) <= PAGE_SIZE);
+
+#define HUGETLB_FLB_COMPATIBLE "hugetlb-v1"
+
+#endif /* _LINUX_KHO_ABI_HUGETLB_H */
diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 9b2515f31afb..86e76aed8a93 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -72,4 +72,16 @@ config LIVEUPDATE
 
 	  If unsure, say N.
 
+config LIVEUPDATE_HUGETLB
+	bool "Live update support for HugeTLB"
+	depends on LIVEUPDATE && HUGETLBFS
+	help
+
+	  Enable live update support for the HugeTLB subsystem. This allows live
+	  updating memfd backed by huge pages. This can be used by hypervisors that
+	  use hugetlb memfd to back VM memory, or for other user workloads needing
+	  to live update huge pages.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 7738ec416f00..753bc1e3f3fd 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
+obj-$(CONFIG_LIVEUPDATE_HUGETLB) += hugetlb_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
 ifdef CONFIG_SWAP
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f818086bf4f..ff90ceacf62c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4702,6 +4702,7 @@ static int __init hugetlb_init(void)
 	hugetlb_sysfs_init();
 	hugetlb_cgroup_file_init();
 	hugetlb_sysctl_init();
+	hugetlb_luo_init();
 
 #ifdef CONFIG_SMP
 	num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus());
diff --git a/mm/hugetlb_internal.h b/mm/hugetlb_internal.h
index edfb4eb75828..b7b149c56567 100644
--- a/mm/hugetlb_internal.h
+++ b/mm/hugetlb_internal.h
@@ -9,6 +9,7 @@
 #include <linux/hugetlb.h>
 #include <linux/hugetlb_cgroup.h>
 #include <linux/list.h>
+#include <linux/liveupdate.h>
 
 void init_new_hugetlb_folio(struct folio *folio);
 void account_new_hugetlb_folio(struct hstate *h, struct folio *folio);
@@ -32,4 +33,18 @@ static inline struct resv_map *inode_resv_map(struct inode *inode)
 	return (struct resv_map *)(&inode->i_data)->i_private_data;
 }
 
+#ifdef CONFIG_LIVEUPDATE_HUGETLB
+void hugetlb_luo_init(void);
+unsigned long hstate_liveupdate_pages(struct hstate *h);
+#else
+static inline void hugetlb_luo_init(void)
+{
+}
+
+static inline unsigned long hstate_liveupdate_pages(struct hstate *h)
+{
+	return 0;
+}
+#endif /* CONFIG_LIVEUPDATE_HUGETLB */
+
 #endif /* __HUGETLB_INTERNAL_H */
diff --git a/mm/hugetlb_luo.c b/mm/hugetlb_luo.c
new file mode 100644
index 000000000000..80e3e015eca5
--- /dev/null
+++ b/mm/hugetlb_luo.c
@@ -0,0 +1,179 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2025 Amazon.com Inc. or its affiliates.
+ * Copyright (C) 2025 Pratyush Yadav <pratyush@kernel.org>
+ */
+
+/* The documentation for this is in mm/memfd_luo.c */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/liveupdate.h>
+#include <linux/kexec_handover.h>
+#include <linux/hugetlb.h>
+#include <linux/kho/abi/hugetlb.h>
+#include <linux/spinlock.h>
+
+#include "hugetlb_internal.h"
+
+struct hugetlb_flb_obj {
+	/* Serializes access to ser and its hstates. */
+	spinlock_t lock;
+	struct hugetlb_ser *ser;
+};
+
+static int hugetlb_flb_preserve(struct liveupdate_flb_op_args *args)
+{
+	struct hugetlb_ser *hugetlb_ser;
+	struct hugetlb_flb_obj *obj;
+	u8 nr_hstates = 0;
+	struct hstate *h;
+
+	obj = kmalloc(sizeof(*obj), GFP_KERNEL);
+	if (!obj)
+		return -ENOMEM;
+
+	hugetlb_ser = kho_alloc_preserve(sizeof(*hugetlb_ser));
+	if (!hugetlb_ser) {
+		kfree(obj);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&obj->lock);
+	obj->ser = hugetlb_ser;
+
+	for_each_hstate(h) {
+		struct hugetlb_hstate_ser *hser = &hugetlb_ser->hstates[nr_hstates];
+
+		hser->nr_pages = 0;
+		hser->order = h->order;
+		nr_hstates++;
+	}
+
+	hugetlb_ser->nr_hstates = nr_hstates;
+
+	args->obj = obj;
+	args->data = virt_to_phys(hugetlb_ser);
+
+	return 0;
+}
+
+static void hugetlb_flb_unpreserve(struct liveupdate_flb_op_args *args)
+{
+	kho_unpreserve_free(phys_to_virt(args->data));
+	kfree(args->obj);
+}
+
+static void hugetlb_flb_finish(struct liveupdate_flb_op_args *args)
+{
+	/* No live state on the retrieve side. */
+}
+
+static int hugetlb_flb_retrieve(struct liveupdate_flb_op_args *args)
+{
+	/*
+	 * The FLB is only needed for boot-time calculation of how many
+	 * hugepages are needed. This is done by early boot handlers already.
+	 * Free the serialized state now.
+	 */
+	kho_restore_free(phys_to_virt(args->data));
+
+	/*
+	 * HACK: But since LUO FLB still needs an obj, use ZERO_SIZE_PTR to
+	 * satisfy it.
+	 */
+	args->obj = ZERO_SIZE_PTR;
+	return 0;
+}
+
+static struct liveupdate_flb_ops hugetlb_luo_flb_ops = {
+	.preserve = hugetlb_flb_preserve,
+	.unpreserve = hugetlb_flb_unpreserve,
+	.finish = hugetlb_flb_finish,
+	.retrieve = hugetlb_flb_retrieve,
+};
+
+static struct liveupdate_flb hugetlb_luo_flb = {
+	.ops = &hugetlb_luo_flb_ops,
+	.compatible = HUGETLB_FLB_COMPATIBLE,
+};
+
+static struct hugetlb_hstate_ser
+*hugetlb_flb_get_hser(struct hugetlb_ser *hugetlb_ser, unsigned int order)
+{
+	for (u8 i = 0; i < hugetlb_ser->nr_hstates; i++) {
+		if (hugetlb_ser->hstates[i].order == order)
+			return &hugetlb_ser->hstates[i];
+	}
+
+	return NULL;
+}
+
+static int hugetlb_flb_add_folio(struct hstate *h)
+{
+	struct hugetlb_ser *hugetlb_ser;
+	struct hugetlb_hstate_ser *hser;
+	struct hugetlb_flb_obj *obj;
+	int err;
+
+	err = liveupdate_flb_get_outgoing(&hugetlb_luo_flb, (void **)&obj);
+	if (err)
+		return err;
+
+	hugetlb_ser = obj->ser;
+
+	guard(spinlock)(&obj->lock);
+	hser = hugetlb_flb_get_hser(hugetlb_ser, h->order);
+	if (!hser)
+		return -ENOENT;
+
+	hser->nr_pages++;
+	return 0;
+}
+
+static int hugetlb_flb_del_folio(struct hstate *h)
+{
+	struct hugetlb_ser *hugetlb_ser;
+	struct hugetlb_hstate_ser *hser;
+	struct hugetlb_flb_obj *obj;
+	int err;
+
+	err = liveupdate_flb_get_outgoing(&hugetlb_luo_flb, (void **)&obj);
+	if (err)
+		return err;
+
+	hugetlb_ser = obj->ser;
+
+	guard(spinlock)(&obj->lock);
+	hser = hugetlb_flb_get_hser(hugetlb_ser, h->order);
+	if (!hser)
+		return -ENOENT;
+
+	hser->nr_pages--;
+	return 0;
+}
+
+unsigned long __init hstate_liveupdate_pages(struct hstate *h)
+{
+	struct hugetlb_hstate_ser *hser;
+	struct hugetlb_ser *hugetlb_ser;
+	u64 data;
+	int err;
+
+	err = liveupdate_flb_incoming_early(&hugetlb_luo_flb, &data);
+	if (err)
+		/* If FLB can't be fetched, assume no pages from liveupdate. */
+		return 0;
+
+	hugetlb_ser = phys_to_virt(data);
+
+	/* NOTE: No need for locking since this is read-only on incoming side. */
+	hser = hugetlb_flb_get_hser(hugetlb_ser, h->order);
+	return hser ? hser->nr_pages : 0;
+}
+
+void __init hugetlb_luo_init(void)
+{
+	if (!liveupdate_enabled())
+		return;
+}
-- 
2.43.0


