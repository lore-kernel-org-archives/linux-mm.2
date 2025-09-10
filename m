Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 809FCCAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D50378E0019; Tue,  9 Sep 2025 22:45:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D00498E0016; Tue,  9 Sep 2025 22:45:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1508E0019; Tue,  9 Sep 2025 22:45:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED938E0016
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64FCE140724
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:28 +0000 (UTC)
X-FDA: 83871799536.12.C5A9977
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7226680004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QKRptPsp;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHBVvY3x6e21mIrkyJqNXh0k7BoUcob+yy1n12vnZEU=;
	b=SixGOxL5oGg0+qUdBSudFFSv3xigNbFQQbGgYtpmUgGAIuPs5NGqi2dZJYGp+n2Qmr4zHs
	x+Jtxp3nBt/BqiVTOi9yF1FPivRg5ftIjJL92Wgg2J3D+uoSTxB45QKUL+68QfeyH3bj8s
	6AyNIZc4Pm0KwTWACXzDMZLHTGkbuzM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QKRptPsp;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472326; a=rsa-sha256;
	cv=none;
	b=eIK+X5qonVal3do6wXgJq1c4M/YzF0pCYCq8nSpih3Fn+cvyeA6bcFMRuJAbVDJPNeM4fR
	cfRoxdfMMSweC15i/STzTJrtdX9pJBf3vvHOkQgvmicVP4+sSBLYxdevG4KFsVOO2DVjRP
	zHMGpkVEC95mm0lJSZGGb1CSKVvplrA=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-32b5d3e1762so5049945a91.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472325; x=1758077125; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHBVvY3x6e21mIrkyJqNXh0k7BoUcob+yy1n12vnZEU=;
        b=QKRptPspsPpopa+tSuqg3ALb26IdoQUC/V39Iv3W17j75HGEJfuPOfQZ/2pEUDuSC0
         oZPOd0YtAlMY4f6vE6y3PC8vE9TkC0hevWFuMZMJDGL3Vw11qm1fp/ZoIuB57jT+3sh4
         ibXNsTVRgF/hHwXkHhJ3IuREl2dHKwrsF8bR1Zu1DycbrKmikBWxZpbIyhOQHes8ML+A
         FkJ4i4sV6nECV7AFMCYrHQdRBVHYo8x5gbfC2EmQg2GRhYEQ9ktPcL+ftwglMTPDobdf
         yM2Pv5WSuUYEPmOJ41QPIPoZEqEvGS0ZiweESE3FV4ZAmenGgGALmVn++6eZu3f0gxAb
         U/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472325; x=1758077125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lHBVvY3x6e21mIrkyJqNXh0k7BoUcob+yy1n12vnZEU=;
        b=k99TzGvSqD8a3Y06lWaejW8Va4IH3idxxFRfgvXHWXifJrkVnfoloU+1ei7fxLLYeN
         0YuBKisaTznZVnAsPpVdwPG2LF2mrsQPFewVS2mY9BiCYZB/6qNwjXYcI/xXuZ31KF03
         kY3EO6IuhbGyDfwLABi+RxitU8moMrrLQQ7G5ggUYKTyhTQ1BTlNtmSTf8MXN0GttA36
         6ryJ8ueOhiwiQyTdH1dGjEUQVpGjBHLEDs7Ey1xwHVPl862B6LabgGRL65gVmxnld/iq
         xk5MhGy3sYWPxoB55OyVJEVZoPAdWTY24clcdvDwOMSwCEX5kLgVGSHKLnBe/nHQ4riH
         PIPQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4fH8wrVlA4H+FIbuMYZwA2o8hGT1E2SYOeGCyuzLp451zJD+sbxbOuCni/fcUTNMTpzGTIZxihw==@kvack.org
X-Gm-Message-State: AOJu0Ywhe/VbRXXUf2g/mbw8w5ATqaTvGABY75my3VDSZ2r4fComkGlE
	Qvwgop/Tp4a9cWt/vDLJErtDSsWdcAMAeazpVMJbjcGv9InZi8N3XFC9
X-Gm-Gg: ASbGncu4KbH0pvhTwZD2D2eHVpzBotZkbxn3rmBMGA3Sl1FqZycs3gAsJ16rYb/dCzi
	oAKe8gebP1PjUlioONDBcElV0/zWZsVelWfF3pviYqZ4sFbophO0ilhMHV0FcjMo+VyegAJRAky
	80pzYTYo46SUl6ZbujpjI9Zhyghj8t08GO1iHx7PVus+g2SK7DjOubEV9NKxyuDEfB65X3DrZmp
	6/OpGMdtLW58WKlnEqSa0yioHrfSQvZEPh86fDPjD1HKy2TBagWzrbkavF5Br4+yoJND8xZP8ju
	K++RHbjNW0aMFyBILyB2rp0LdtkT/Y2oCkQgfGJhcsx+xpKZzb6LvOVgyaVBOw9x8L3g+Y8KCt4
	zXTSU5AUZKPGIRoujmG0OCxrHg3gXqfo9I0PttNJg6JP7P322UYIsXn/Lev7MlSRuZYLCO517ac
	qoMa7qtj1Krd1TGg==
X-Google-Smtp-Source: AGHT+IE89MbDZsiF2EM0+8r+zHCzXP/nYgqEenaQV9tVgYO62q4iIad10FdDLTg1m3xXXaOsQhx59A==
X-Received: by 2002:a17:90b:4c12:b0:329:f110:fe9e with SMTP id 98e67ed59e1d1-32d43f5bc76mr18858970a91.17.1757472325096;
        Tue, 09 Sep 2025 19:45:25 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.45.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:24 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP order selection
Date: Wed, 10 Sep 2025 10:44:39 +0800
Message-Id: <20250910024447.64788-3-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250910024447.64788-1-laoar.shao@gmail.com>
References: <20250910024447.64788-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7226680004
X-Stat-Signature: znh18mkkz9wouyqdc5fpweibx4zjhxdp
X-HE-Tag: 1757472326-632132
X-HE-Meta: U2FsdGVkX1/0PI1BxpbqWq2Q7dt9EmVvVr4l1WxamD0j0GRYkFSLXTkLa7YdbXyGtE5sVBEbJIGErFX51oioY7L7Is0VhJsyL+5Vsg22nDQG1UOjmdffZF9ihpkMgJQA/awO8tXMLBC4dCCFN6P1ZnOb4ufzw73RjqCYYDP2nAz9n4I6R/nGNvGckgRIKBWC1P4w4DPE9aan8ZddXuS05MNf8aHbpqdsBpl7+hUBod2nSP9UIOK8ivzW3bZf4gG/osHrsGAAgDFpqOmxfqu5xHCuuFqbRZfLHESgJ+fBqM+O2XtwdzACJO5liGIWR1GcvbI7EC2goeEe/vRk1ZYaLuXy4OdQHV5acwGL5CXkvkEHJYMRGDHiz02XfKaB8X/kHKYnnlTUJ4peJNqW4JW+lGxZzg1WwNlZUDvF6gNwf0SdJYzO61R5Bxaj+Iv/ZK4LWGn+3mh6JJ52BJQHJlMR8JXkBfSPZLpVEyDP7aN/f87UjcwjZp0X+y8MfgS9jDFdlXI7Po6gw+LlxG4uszGXLmKypnU4ei2iEk1vV/nusCuWjQSGHo7o2I61pFuZDZcPesAuyO+ZPkLNfp76lES3KiQG0y185TbS9ZZqPelXVdkBCSbGiFE+yw9rdYV1OoduVGpLJqOThT8mmTFXFOPHuV+SmvRZVyRjbuUW6JfyeMxncMm2neChJPQwcw4klQbF3QVCvftCZmPbUG1oIHXa77phfW0JEw/2jN+zK86xmdYlcxFrVLpAG2CiTVj00IZTw8bCyxkRxtTNu61O6X/dNNNrZDCCaqlxm7xaHYQE2pWP+R+sk2duCYACZbzWmkxKnXaVsJSoA3y5Jn8CX53aYec9/k5y2M5bMKbnR1RC6MSaM+62KTPFKU16ZFlQ3cTyEOc3MH5pofyAtMsv65fHO4vOL0CSXWe6sucfz+wn4i8WHbCTFAK7v09u0tJ/4VAj7d9JEpuRebFUY7KSma2
 L92p4GeF
 oxhv4Jb6qSRz+cNQ3VGibZMSe8Pluend+80nTHPyQal0f0IxYBu+pWol6SrVqJgQOJVva5BAwz6ZOO8J+kj9xXlHTlzabtNf28MBWisaSILPK1tlqSv0VOYCA789CzmV3znJdsNdLkV+RDpDrEtPUpSOfbFH0DBQiZVkFJHFy1zz9lhsuAcb3EixNx/sGh5kRKbkKOWHi6rLGBcNO6BQb+IHUzzGIk5ifFyDPqa83vWVuLB54oSSINRMw5oLbX87QDcB/gHE2WwoCJvcCoBMvJbZsniiMDR8YMB/Vv6C9NnDR5gtvYXem8R+PK8LrJisRFc5vJBZP74xsPAFgGKQ7kkuyVRDudH1CotxS7yKpleHCCmBD4MrlcFdAla1DV/wR659yp+z7pvd+p9LWZeQ4C3tG8xJW4juV1sacso8SB6tL74RPuSDNKM7Mm85oKTTQXFg+BcT7jNltEHqnv83yumJo3fhvymYrR+qAT86l90BPED720H+QBDJueCwS8Ycsrsj/isywWuqYZlVEB5l5VGOCsY7m4MtPvvdm8LJrzE8jsH8nk9A/GAcbwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
programs to influence THP order selection based on factors such as:
- Workload identity
  For example, workloads running in specific containers or cgroups.
- Allocation context
  Whether the allocation occurs during a page fault, khugepaged, swap or
  other paths.
- VMA's memory advice settings
  MADV_HUGEPAGE or MADV_NOHUGEPAGE
- Memory pressure
  PSI system data or associated cgroup PSI metrics

The kernel API of this new BPF hook is as follows,

/**
 * @thp_order_fn_t: Get the suggested THP orders from a BPF program for allocation
 * @vma: vm_area_struct associated with the THP allocation
 * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
 *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE if
 *            neither is set.
 * @tva_type: TVA type for current @vma
 * @orders: Bitmask of requested THP orders for this allocation
 *          - PMD-mapped allocation if PMD_ORDER is set
 *          - mTHP allocation otherwise
 *
 * Return: The suggested THP order from the BPF program for allocation. It will
 *         not exceed the highest requested order in @orders. Return -1 to
 *         indicate that the original requested @orders should remain unchanged.
 */
typedef int thp_order_fn_t(struct vm_area_struct *vma,
			   enum bpf_thp_vma_type vma_type,
			   enum tva_type tva_type,
			   unsigned long orders);

Only a single BPF program can be attached at any given time, though it can
be dynamically updated to adjust the policy. The implementation supports
anonymous THP, shmem THP, and mTHP, with future extensions planned for
file-backed THP.

This functionality is only active when system-wide THP is configured to
madvise or always mode. It remains disabled in never mode. Additionally,
if THP is explicitly disabled for a specific task via prctl(), this BPF
functionality will also be unavailable for that task.

This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to be
enabled. Note that this capability is currently unstable and may undergo
significant changes—including potential removal—in future kernel versions.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS             |   1 +
 include/linux/huge_mm.h |  26 ++++-
 mm/Kconfig              |  12 ++
 mm/Makefile             |   1 +
 mm/huge_memory_bpf.c    | 243 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 280 insertions(+), 3 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fef05bc2224..d055a3c95300 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16252,6 +16252,7 @@ F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
+F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
 F:	tools/testing/selftests/mm/khugepaged.c
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 23f124493c47..f72a5fd04e4f 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
 };
 
 struct kobject;
@@ -270,6 +271,19 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 enum tva_type type,
 					 unsigned long orders);
 
+#ifdef CONFIG_BPF_GET_THP_ORDER
+unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_flags,
+			enum tva_type type, unsigned long orders);
+#else
+static inline unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma_flags,
+			enum tva_type tva_flags, unsigned long orders)
+{
+	return orders;
+}
+#endif
+
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
@@ -291,6 +305,12 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 				       enum tva_type type,
 				       unsigned long orders)
 {
+	unsigned long bpf_orders;
+
+	bpf_orders = bpf_hook_thp_get_orders(vma, vm_flags, type, orders);
+	if (!bpf_orders)
+		return 0;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
@@ -304,12 +324,12 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 		    ((vm_flags & VM_HUGEPAGE) && hugepage_global_enabled()))
 			mask |= READ_ONCE(huge_anon_orders_inherit);
 
-		orders &= mask;
-		if (!orders)
+		bpf_orders &= mask;
+		if (!bpf_orders)
 			return 0;
 	}
 
-	return __thp_vma_allowable_orders(vma, vm_flags, type, orders);
+	return __thp_vma_allowable_orders(vma, vm_flags, type, bpf_orders);
 }
 
 struct thpsize {
diff --git a/mm/Kconfig b/mm/Kconfig
index d1ed839ca710..4d89d2158f10 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -896,6 +896,18 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config BPF_GET_THP_ORDER
+	bool "BPF-based THP order selection (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
+
+	help
+	  Enable dynamic THP order selection using BPF programs. This
+	  experimental feature allows custom BPF logic to determine optimal
+	  transparent hugepage allocation sizes at runtime.
+
+	  WARNING: This feature is unstable and may change in future kernel
+	  versions.
+
 endif # TRANSPARENT_HUGEPAGE
 
 # simple helper to make the code a bit easier to read
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..f180332f2ad0 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_BPF_GET_THP_ORDER) += huge_memory_bpf.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
new file mode 100644
index 000000000000..525ee22ab598
--- /dev/null
+++ b/mm/huge_memory_bpf.c
@@ -0,0 +1,243 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF-based THP policy management
+ *
+ * Author: Yafang Shao <laoar.shao@gmail.com>
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/huge_mm.h>
+#include <linux/khugepaged.h>
+
+enum bpf_thp_vma_type {
+	BPF_THP_VM_NONE = 0,
+	BPF_THP_VM_HUGEPAGE,	/* VM_HUGEPAGE */
+	BPF_THP_VM_NOHUGEPAGE,	/* VM_NOHUGEPAGE */
+};
+
+/**
+ * @thp_order_fn_t: Get the suggested THP orders from a BPF program for allocation
+ * @vma: vm_area_struct associated with the THP allocation
+ * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
+ *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE if
+ *            neither is set.
+ * @tva_type: TVA type for current @vma
+ * @orders: Bitmask of requested THP orders for this allocation
+ *          - PMD-mapped allocation if PMD_ORDER is set
+ *          - mTHP allocation otherwise
+ *
+ * Return: The suggested THP order from the BPF program for allocation. It will
+ *         not exceed the highest requested order in @orders. Return -1 to
+ *         indicate that the original requested @orders should remain unchanged.
+ */
+typedef int thp_order_fn_t(struct vm_area_struct *vma,
+			   enum bpf_thp_vma_type vma_type,
+			   enum tva_type tva_type,
+			   unsigned long orders);
+
+struct bpf_thp_ops {
+	thp_order_fn_t __rcu *thp_get_order;
+};
+
+static struct bpf_thp_ops bpf_thp;
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+/*
+ * Returns the original @orders if no BPF program is attached or if the
+ * suggested order is invalid.
+ */
+unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
+				      vm_flags_t vma_flags,
+				      enum tva_type tva_type,
+				      unsigned long orders)
+{
+	thp_order_fn_t *bpf_hook_thp_get_order;
+	unsigned long thp_orders = orders;
+	enum bpf_thp_vma_type vma_type;
+	int thp_order;
+
+	/* No BPF program is attached */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		      &transparent_hugepage_flags))
+		return orders;
+
+	if (vma_flags & VM_HUGEPAGE)
+		vma_type = BPF_THP_VM_HUGEPAGE;
+	else if (vma_flags & VM_NOHUGEPAGE)
+		vma_type = BPF_THP_VM_NOHUGEPAGE;
+	else
+		vma_type = BPF_THP_VM_NONE;
+
+	rcu_read_lock();
+	bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
+	if (!bpf_hook_thp_get_order)
+		goto out;
+
+	thp_order = bpf_hook_thp_get_order(vma, vma_type, tva_type, orders);
+	if (thp_order < 0)
+		goto out;
+	/*
+	 * The maximum requested order is determined by the callsite. E.g.:
+	 * - PMD-mapped THP uses PMD_ORDER
+	 * - mTHP uses (PMD_ORDER - 1)
+	 *
+	 * We must respect this upper bound to avoid undefined behavior. So the
+	 * highest suggested order can't exceed the highest requested order.
+	 */
+	if (thp_order <= highest_order(orders))
+		thp_orders = BIT(thp_order);
+
+out:
+	rcu_read_unlock();
+	return thp_orders;
+}
+
+static bool bpf_thp_ops_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_func_proto *
+bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
+	.get_func_proto = bpf_thp_get_func_proto,
+	.is_valid_access = bpf_thp_ops_is_valid_access,
+};
+
+static int bpf_thp_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_thp_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	/* The call site operates under RCU protection. */
+	if (prog->sleepable)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_thp_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	return 0;
+}
+
+static int bpf_thp_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	spin_lock(&thp_ops_lock);
+	if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+			     &transparent_hugepage_flags)) {
+		spin_unlock(&thp_ops_lock);
+		return -EBUSY;
+	}
+	WARN_ON_ONCE(rcu_access_pointer(bpf_thp.thp_get_order));
+	rcu_assign_pointer(bpf_thp.thp_get_order, ops->thp_get_order);
+	spin_unlock(&thp_ops_lock);
+	return 0;
+}
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	thp_order_fn_t *old_fn;
+
+	spin_lock(&thp_ops_lock);
+	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
+	old_fn = rcu_replace_pointer(bpf_thp.thp_get_order, NULL,
+				     lockdep_is_held(&thp_ops_lock));
+	WARN_ON_ONCE(!old_fn);
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
+static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	thp_order_fn_t *old_fn, *new_fn;
+	struct bpf_thp_ops *old = old_kdata;
+	struct bpf_thp_ops *ops = kdata;
+	int ret = 0;
+
+	if (!ops || !old)
+		return -EINVAL;
+
+	spin_lock(&thp_ops_lock);
+	/* The prog has aleady been removed. */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		      &transparent_hugepage_flags)) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	new_fn = rcu_dereference(ops->thp_get_order);
+	old_fn = rcu_replace_pointer(bpf_thp.thp_get_order, new_fn,
+				     lockdep_is_held(&thp_ops_lock));
+	WARN_ON_ONCE(!old_fn || !new_fn);
+
+out:
+	spin_unlock(&thp_ops_lock);
+	if (!ret)
+		synchronize_rcu();
+	return ret;
+}
+
+static int bpf_thp_validate(void *kdata)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	if (!ops->thp_get_order) {
+		pr_err("bpf_thp: required ops isn't implemented\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int bpf_thp_get_order(struct vm_area_struct *vma,
+			     enum bpf_thp_vma_type vma_type,
+			     enum tva_type tva_type,
+			     unsigned long orders)
+{
+	return -1;
+}
+
+static struct bpf_thp_ops __bpf_thp_ops = {
+	.thp_get_order = (thp_order_fn_t __rcu *)bpf_thp_get_order,
+};
+
+static struct bpf_struct_ops bpf_bpf_thp_ops = {
+	.verifier_ops = &thp_bpf_verifier_ops,
+	.init = bpf_thp_init,
+	.check_member = bpf_thp_check_member,
+	.init_member = bpf_thp_init_member,
+	.reg = bpf_thp_reg,
+	.unreg = bpf_thp_unreg,
+	.update = bpf_thp_update,
+	.validate = bpf_thp_validate,
+	.cfi_stubs = &__bpf_thp_ops,
+	.owner = THIS_MODULE,
+	.name = "bpf_thp_ops",
+};
+
+static int __init bpf_thp_ops_init(void)
+{
+	int err;
+
+	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+	if (err)
+		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_thp_ops_init);
-- 
2.47.3


