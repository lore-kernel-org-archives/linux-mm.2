Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0DA5CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 09:34:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0318F8E000E; Fri, 26 Sep 2025 05:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFD3F8E0001; Fri, 26 Sep 2025 05:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4B98E000E; Fri, 26 Sep 2025 05:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C088F8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 05:34:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CF731404A6
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:29 +0000 (UTC)
X-FDA: 83930891058.24.E4C75AF
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 871B24000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:34:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AH7hS6En;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758879267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jB3qqE2os1Bz2apgpHhR6iMBcRyPEQoOLursDIPNCnw=;
	b=gYcGUp/uhhh8hiFvWA4sVMR+TK9LGFkdJj9NK5TfUCTHSUn2pAv4Et0S1WayYJ7o9BSBpO
	n/WNkyfMhajyxqbsBD4qGAZr9MZTWMR+ffU6VcCOSDGsmIPcEtB/HG3tE1t/r5+KpShBgP
	e9PzM+Ii5zJ0FIIdKeWo4CCiTcX3Gkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758879267; a=rsa-sha256;
	cv=none;
	b=t4vNOKKoMBCHkrQ/pF7jXuI5a1kVBLldx9vdvVDOEDhR2xmP6nf75kC5W3rHzeDPeM8tZb
	mXHuWEZ/5Qw4ODQhyGmdNTeiY79K12yCbyyG7tdiR0gV0JQsfscA3JNnIS4FbBz9YU93MS
	KRCM9o+/2d0gxo2x3OUrlYTmw4s6JfA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AH7hS6En;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-26a0a694ea8so17928955ad.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 02:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758879266; x=1759484066; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jB3qqE2os1Bz2apgpHhR6iMBcRyPEQoOLursDIPNCnw=;
        b=AH7hS6EnL0iAJuCTN71WpQYMydwlhNFi7BbUUv+B9AxwA4lWayQm3qx8FjRqo14zMN
         x2MJ+f4D0tiNgs/5BpU7P/daQ4DYYimLlgK7PtCNJCN06xfg0CLi74ynB6ZebFNyf7mg
         ECGUkub4cOiS1qq5fXZkLZrRcsvnNb4YVayd9TmeOb+c/4GjvJaLDHY6NB1ZYB0uNv0J
         Yj+MrZNvzGZ119CmgCEZh5Qj3pBJ1i8mcD4R/RrKMJGU/JtHE6VZzCd3xbdBWWSmDnz0
         DNt4A/wDMP2b5npEVKzibqSOnFDqDup2GZtoIV71TNTPh4XB8gm/hdAz1soXJLyj6Fec
         qvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758879266; x=1759484066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jB3qqE2os1Bz2apgpHhR6iMBcRyPEQoOLursDIPNCnw=;
        b=aUVNWMGKGQvuJvpyPsU0w8HVOd6BAhKi7Coy6zqPLsp8SCFxn/AhOuqGD+au9wC2bw
         PjuAjLm5G+09kruo6we7WjYK/NX3hOr3Szso89FF4EHpd6RpZ4TJTBwIuhpb/NHpZS0D
         IiR6Rg5QUMfe3gAHri5qSRufasG7RP0gXESzghzYCg15ffoKecAuQR3KQd8ZrPW6s1X9
         CwzqTSZeRoIWbYbriQKZmCpc9cSbSfjyeVJqqwK+QY3airwihrTsuGCvGnyI4PEFFdM8
         GD32PLjnPdtwnzPCfSmuPGudJti5yGE5gG7JR5B2vagTj0Z8FRv87wmlBcBz1hmdgGFJ
         GTpg==
X-Forwarded-Encrypted: i=1; AJvYcCWLIiNGjrVSv/RLlRY+me2mnPmlLCuyF1ZAJYbZPg54vZ/1aXgXyKTnwe2UtRWHlHTa+YERxR9tOg==@kvack.org
X-Gm-Message-State: AOJu0YxOxi/U+jvBimasSkgqjUNMFlMS0l20ouhmB1aD8cLKPlGjZX5+
	q4bF9hVaWe5pBvfZP635Xs9+FLN1Re5YEZhuxGl/KTCeKNvPMXmbpe2/
X-Gm-Gg: ASbGncug+UjuQyJossUgigh0Hnx7hlzUti0RXp7ghK1NfcxldSe98vRxwHACZ2L4UmN
	Ank91lyQ/Jn7EFCVMgU9r+aJpvUksApN3c4PKwDb/Cvoa/JDULzj8IyKbMcoo2Bg+HDWTcz8MrJ
	Og9qWyIhltXPAn+SwY5es9IJl3xdzLqxtS8789bDCteAHhLJ64eU5Mg4N5wKa6D7zMU/Q99zfG4
	h9L8CyafCTdq6+2nbcFVv89wGycNQ7TG2V9+fXI5JyWMlAJcw42mvqmNUAVRJx2xpYZOm7pg7HV
	cEPEaNw0X8qF9p4yqe853aRq2CXh94/rBlPfpAYz/fBHdsP56DmF7Msz35ObNdNGkwW4/79Gi2V
	bLeQTPvfeOUQlu5YbZKlp71PhcamBoCWNgCikX2Ed69XBBvkG/QMVGffNZ9CADUW06LQedjvsmT
	ajDBHEvb8xqBeQgar6iCWdu8Q=
X-Google-Smtp-Source: AGHT+IGHvI1bbsOR3nSZZZLQ9842geVwDh30Zh6/XJrKPJQQbUmczO+WQSUozaPrlC9pjQUW3P6u0A==
X-Received: by 2002:a17:902:f785:b0:274:6d95:99d2 with SMTP id d9443c01a7336-27ed4a2d5d2mr76014615ad.39.1758879266182;
        Fri, 26 Sep 2025 02:34:26 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1c21:566:e1d1:c082:790c:7be6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66cda43sm49247475ad.25.2025.09.26.02.34.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 26 Sep 2025 02:34:25 -0700 (PDT)
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
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v8 mm-new 04/12] mm: thp: add support for BPF based THP order selection
Date: Fri, 26 Sep 2025 17:33:35 +0800
Message-Id: <20250926093343.1000-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250926093343.1000-1-laoar.shao@gmail.com>
References: <20250926093343.1000-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m5xr5pz1o3pgb59hq17qo6sgpsujfjt5
X-Rspamd-Queue-Id: 871B24000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758879267-875235
X-HE-Meta: U2FsdGVkX1/Iaxq99C7bBN10io1OK/VKB2ltg2PgZedI6uXUzzgtZw2qd1aZHqBoY5a85aM13+/RcQsDukVb/bnpP8ZEjcz8SKRCZSpgvucL8hUWxU7zv/8C8m5e/Q10qY9nq2nKShRweQX+QzZ6wkkIvFVQMuKIiBw6InC78ExyX2s1MI/6alxVhbepoEqkv2tP7prpmhPBUxLQNWD4a+l6sqYicD0+BE6Hq2z7I0ulW04zJ5wjIk3Ba4fMVceG1C+TnGsVAMJI15MaRw18KEMKMV1fT39z1l120n7iB3cCqzA7/P/6ckczwPaTnu9srs5tz8Aj3mSfi0o5UTwCEQAfAnm9n39grFnSgv6mmv/lbCfDKB0chb2pnhnCBhUgsSpO/2VgDJM1UaMRoBEV8H0GHbdcQPOtjHAjiuJAyFQ2KPS0HZ6NnLz6KW77knJrtyX1HsoFEVpz+dw4TQ5itoDyw9qEtjsjLaSlxzFIB9K3fI8hGSHRG8eF68muV4ypJTEHFg3UtZKkuh+wV9mjoT/akiMNMZLVNd5yf7KGrLFk3dw7QDOo4Q453c1/XDYGpg964KVQJWS/LubQ2acp5oz5W7FNA+hYq6+UUGKE7SO4AWotvYkgpkZHvXinsJrF7QSNkoMQ6WRZudVWhjC24/VjAbTqKaBQjOzE71kNtSq9hmPHDVk9U0fRbYP+TzDmnHepdPIcG1NXYInI8u2+/n3aMLQSg5t3IwpqE+A84cqrZTrwhoMdv+xh3Jsj45SWsoKp01Dp1gjMyMMF/R6mVzXd+QkhNYSw328+ONOpgfqBESj54X0RvPAKjKjnx6FUgcyg5zx/y+83TrVi32HIIm1zEBj7lnEjkZ7G4se/GMUBjgQW9qIz38nzvNteeuc3NxhgUGxiRJZ84LqggZYjsSlXQ5dK3h3WJmWVb0ldrAiaERKZ80YcW9dExbe2RpMR+3upHXWisB70xEYy6EZ
 jk/33ifO
 sqwZV75Dh+ZqKijpimjHlsttdguJOiwCuUmqbyZ73QjaiEh3iEe9s8QGRskxlbHpKs0oPMuwB7R5GH08NOaH1848XVF1EKNPbnYbFEX/YsWk/ABmtl/noOwc/gcnRu0/TUAqnt5cjZkmwX1j29GggwRfNVrPqNz3QiUJtqpn49zRdqajKbXEcD913xNVlnylolrV7K4CL4/SG6JhG6w6SE06Jk5itK0TP/+bT/ojOMR3WrAsNA8ni4mVvtQKb8DUkPPnlpsq4TycyKZFJPMU6ccRzW+cEpkfzQ01weXFWR3lGQvQ8okJA1QiuiQsB1KQRbIVnIekAA5ftWhKWGBoWuFSkbRI2JESU/CZPFIV1tH0RUuRHPzo23gZEG2exzia2Eo/TGR2fbpZtJ5GoezGGuhdLEs8one1W5qE4k/XhHqIjwLnJVHyMweZ6FEicNtzoR+ugJEZfp3sOjJftg21SNb+7LwR439jpL32427hNqws7Kk31JCHFY+n38GruEor1krzbjWwOGdObyFLOnEbZdlGWzrizqSh7JIPkjrF4Z/o3whLVnCN5PlXGX5Oyqr4qhmETI9aPwXt6YpO2SOSJfCUc/gzSBRwiZYjA6EUjoH+Rc8eL1Qms4KmwNQUcm7yIN9YlkiG9TEo+z+Y=
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
 * thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
 * @vma: vm_area_struct associated with the THP allocation
 * @type: TVA type for current @vma
 * @orders: Bitmask of available THP orders for this allocation
 *
 * Return: The suggested THP order for allocation from the BPF program. Must be
 *         a valid, available order.
 */
typedef int thp_order_fn_t(struct vm_area_struct *vma,
			   enum tva_type type,
			   unsigned long orders);

Only a single BPF program can be attached at any given time, though it can
be dynamically updated to adjust the policy. The implementation supports
anonymous THP, shmem THP, and mTHP, with future extensions planned for
file-backed THP.

This functionality is only active when system-wide THP is configured to
madvise or always mode. It remains disabled in never mode. Additionally,
if THP is explicitly disabled for a specific task via prctl(), this BPF
functionality will also be unavailable for that task.

This BPF hook enables the implementation of flexible THP allocation
policies at the system, per-cgroup, or per-task level.

This feature requires CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL to be
enabled. Note that this capability is currently unstable and may undergo
significant changes—including potential removal—in future kernel versions.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS             |   1 +
 include/linux/huge_mm.h |  23 +++++
 mm/Kconfig              |  12 +++
 mm/Makefile             |   1 +
 mm/huge_memory_bpf.c    | 204 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 241 insertions(+)
 create mode 100644 mm/huge_memory_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ca8e3d18eedd..7be34b2a64fd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16257,6 +16257,7 @@ F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
+F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
 F:	tools/testing/selftests/mm/khugepaged.c
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a635dcbb2b99..fea94c059bed 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
 };
 
 struct kobject;
@@ -269,6 +270,23 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 enum tva_type type,
 					 unsigned long orders);
 
+#ifdef CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL
+
+unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders);
+
+#else
+
+static inline unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders)
+{
+	return orders;
+}
+
+#endif
+
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
@@ -290,6 +308,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 
+	/* The BPF-specified order overrides which order is selected. */
+	orders &= bpf_hook_thp_get_orders(vma, type, orders);
+	if (!orders)
+		return 0;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
diff --git a/mm/Kconfig b/mm/Kconfig
index bde9f842a4a8..fd7459eecb2d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -895,6 +895,18 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config BPF_THP_GET_ORDER_EXPERIMENTAL
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
index 21abb3353550..62ebfa23635a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL) += huge_memory_bpf.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
new file mode 100644
index 000000000000..b59a65d70a93
--- /dev/null
+++ b/mm/huge_memory_bpf.c
@@ -0,0 +1,204 @@
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
+/**
+ * @thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
+ * @vma: vm_area_struct associated with the THP allocation
+ * @type: TVA type for current @vma
+ * @orders: Bitmask of available THP orders for this allocation
+ *
+ * Return: The suggested THP order for allocation from the BPF program. Must be
+ *         a valid, available order.
+ */
+typedef int thp_order_fn_t(struct vm_area_struct *vma,
+			   enum tva_type type,
+			   unsigned long orders);
+
+struct bpf_thp_ops {
+	thp_order_fn_t __rcu *thp_get_order;
+};
+
+static struct bpf_thp_ops bpf_thp;
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
+				      enum tva_type type,
+				      unsigned long orders)
+{
+	thp_order_fn_t *bpf_hook_thp_get_order;
+	int bpf_order;
+
+	/* No BPF program is attached */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		      &transparent_hugepage_flags))
+		return orders;
+
+	rcu_read_lock();
+	bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
+	if (!bpf_hook_thp_get_order)
+		goto out;
+
+	bpf_order = bpf_hook_thp_get_order(vma, type, orders);
+	orders &= BIT(bpf_order);
+
+out:
+	rcu_read_unlock();
+	return orders;
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
+			     enum tva_type type,
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


