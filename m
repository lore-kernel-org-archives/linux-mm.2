Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DF92CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C944B8E001B; Tue, 30 Sep 2025 01:59:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C440C8E0002; Tue, 30 Sep 2025 01:59:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE48C8E001B; Tue, 30 Sep 2025 01:59:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94A0E8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:59:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 439BE13B518
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:17 +0000 (UTC)
X-FDA: 83944863954.27.464597A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E2858000E
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:59:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mcBMuvtA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211955; a=rsa-sha256;
	cv=none;
	b=mEyqcHY7QnZAFXws8NZxN9MJdx6SIPQ2W00Hy7agB4KrStMWVWOk00L27WLosgvB1CBvUB
	kgTGjwQp3IXfRSXU6e2tyDTb0sna6eCnTlHduKOFs4qTxJM5xjFEeoTqXT5hyyB1KBKYTY
	yREmPlGpxxBPPGmG5bhPJ2Qm3NNtW6I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mcBMuvtA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pU2SzCsYNRWOhFkPpxF5i6fX6DQXje7k2mX62DbPVIg=;
	b=Hp/BDveUwkttHSMwMXoj2ziUtSJiVYu6kOyX1Gs2CYOuTYpibdqYK5fKEU3GUfyCh+vA7y
	Nf+pTvX+xywrG1DXYaCCNY3dJxeJx4dxbtib1nARK9rkeR0epMds7mTn0pi4Sbu7KvpH+r
	6q7MyoanOT6zwCukTmJaayCfqcLqyYQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-27ee41e074dso51322655ad.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211954; x=1759816754; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pU2SzCsYNRWOhFkPpxF5i6fX6DQXje7k2mX62DbPVIg=;
        b=mcBMuvtAq8vOFaStTC8tJnsUBX5z5/2gihfKnFreyYVCj+iwRT/GJJO2r0lLPegDKK
         26s90NSDGAzvuOXVVuuUwNuuRP7A/H2CSPOyByVTomE4p6ViKPCgQT1LdqHvlGMcFXGt
         lrvC2T0zx182sLq0E53cDa3jAogaEA4+iWtYcoNoxvlNmQvLuR+7tgfKgtdB0hCVUCeM
         H6yTPA43NUhzcGTXPuuPeXlhRTD4DUoX9AQopBgzru7DGRcjmOY2a0XfvmONUj9DdHHP
         94COjKxpZ/V/r0b4BZPi3z5Ort3+QjmH9ZMisitxIsxBvyukalt7QC3Nre7a6B19axeL
         DMZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211954; x=1759816754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pU2SzCsYNRWOhFkPpxF5i6fX6DQXje7k2mX62DbPVIg=;
        b=pGB2wvtyGtbHAG2YieHAR0Br2dm5+y+iBUW3g797sTaG71d1Mb8Y/i9WXWaCFOm4cO
         3kROtjTw6Cpr/jgEs5EF+E1892W/QY5uWa9k8xNmj7nFJvm/QA6EpxrdJVA4j2G6H1LL
         KduXQY0cBfQIib6H3dKK6ji5uvGiF/BtDUq9ejpSFGHW7JohC3DE7tAj5K1ih2uamR3b
         LR3gc9zxZ0X5BeIM/0vSxyO7AXQ4Z0v9Z6FdIu2/l+staLKOdRD/MpHz7nlVdh/FMS4g
         eutDShgwkwjfwhos0eFv8b9Yq4KUCELA/Y1ejvljwLy8NGSqZHbqvs6KA8Z/6W1/HmSN
         qz0w==
X-Forwarded-Encrypted: i=1; AJvYcCX8vub/oQqAE8nBKixGF3J7bG1Er2lvCvWuis+fTsTxMke89319qoj6onxoJ8NegYV3TdO6rvcGGQ==@kvack.org
X-Gm-Message-State: AOJu0Yxj4ENs1pnufVKMU2+RYE8cG34a/Tca+hKxQOfU6bzCcmOJ3TEG
	qyAXhB9MZ5QPlhjQxkZeIRPUnUnb1p9CjW6FgaM1YoEl/h4+I+dsSfsX
X-Gm-Gg: ASbGncs3u/iRPDh8QSVpxAIcz3vdOFpAT6SKQLUj7tQLQq+jwMgMYYqhq9m+O0s+oZx
	p3lFZZMDjOK508oMiVBE1gh+fu260zrQWC8bjJpgkFrQT9UsPhtdQ8UGVrrXD36S4IBdpHA/Asx
	UuC1Lxvq694FpWuq1d1ZbR3NIhSB6kXlTQyne5RtAVrar9XYNDxS1xiGTaZLDq10kVwjOU0cNsm
	L4N6ROKO8V5Vt4V1kNs29FfOUpS6skppwZmciggUVEqZJ56uu/zX0RNFoMfsEKmhvnZ5DIDHmr3
	uu6Ik8VKnQ1zvtHi9JWif0Lc7zZNr7NnfmdjoFtLmlYNhc1+HO5YjFqlE2+QOn3W6V3OoKor7ri
	juaz4BJCTuLv7lGfWMsOPQMxvooCJA5L8o6fj1pmWF5sPRXmUBTAh3i3bPh4EBj1H2CPldlDNem
	sAN/CyAVFp1tz8HcF8gYO7YnNySmM=
X-Google-Smtp-Source: AGHT+IFpB1ELcmxl96OYKyLCQ93t55yCZz/ljq5ccARZ0IQJmhLOUbqZtdM1H5tzU1i/eB4FY2S1gw==
X-Received: by 2002:a17:903:3586:b0:268:cc5:5e4e with SMTP id d9443c01a7336-27ed4a06de2mr192026365ad.1.1759211953994;
        Mon, 29 Sep 2025 22:59:13 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.59.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:59:13 -0700 (PDT)
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
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP order selection
Date: Tue, 30 Sep 2025 13:58:18 +0800
Message-Id: <20250930055826.9810-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250930055826.9810-1-laoar.shao@gmail.com>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4E2858000E
X-Stat-Signature: i4f5nemtz5zuuocnqf7kogkexp1q15wb
X-Rspam-User: 
X-HE-Tag: 1759211955-355026
X-HE-Meta: U2FsdGVkX18y0DGmEW7sTUnADGo0TiIOBLZHOEYBU7XTaeZUubYbv1I9JvAmH+Aurt558Fn8qSFcuBuwOhwgdbFZlBsdeVmZl6qDbJ9Dnb7Kh+aIJgMjX+6pPWLduoqAYXuSvMiTeVNVMnpdWcr68f+So09SBM9d7l2rCqUGnKD3kukwk0WW/hnLVuNjvdooh/ThCbrJwToJFijOrsA0KQ60kTC/u9LtC1yNVrtRixVg9IKpirK9rVmMOJyBxb5UNRqL9+qDtTy9uAR7laCGYP4jVzmOz9SkA8Bh4B6j0yrA8723Ehatel/MkJFdDKzC4lfCcKSHmnwC+jrJ89VcadgUeK4IPi7/ctKP3tUtjsAApggNS5qn2k5AMJNHG8PMaePqayUmpgm7W9i8t0Z3YzbHMT9qTnrA9WpfWVREysUsCStCBUx//zmM1ZKcIooLMsDeaTMlvxCGGcu5QjSGmU+4A3BA2hNSpigX+p28EcIXLk6mjhR570aBtaym8bQijI+K5VpDzrEdjTMdR5LdwXIGXmQaS6hvBzKQrqfc2i4Kzd9HDlrjTlaulaVTtg1vXNJKW0X7dtiEHzQMZmjdk8D991HvoQ3ZeK62xWxRClyaC8zeoTbAb07HewMbLAgwXLd6cWD4bgePzaB56/qxDOVA7PJUqWjfuxeh7oRawaNvLKsXCSMg56CQs0JzVcm2eezUoCS74Zb+MvDeDojHDGchPfVwmC6sPNf3ypXROnAAOYMiu3LGP+2J4QDZYGj7JfR/S01NCO1UgVgl/+IWWSuhjvQKwR3jqle5Upq94y6l7Fg2voeTYbX1DtcMNxL5dB33lSvMmgQkEybJzJK0Lt7rGnyrnlFKTOpBBphQ/o8/igaR0VcQ0vrv2E76Re49ZDoYgRFIYFaHQ6s3yz4T5g6A3GsghUJ9KFmN6WCWY8rGjf8u6lwEoBWQosVtaGNwDvIqhcC3EDBhfYDLKw7
 l1SmEjlw
 Ky08uEX49mjmWggyfuvSc5cGHkKpJ/a3QIvNxyheaxmbd3BbBVvGZDzGB6Q1WHapYjng0QrVPLEGoNQJ5SUVms7VYkKqefgStHUZihSEpia24y3AXB2sWxW5pO1lhdofH+mSDsUnzRijQcRYExm39P9T22MWcw44noXWZ6/ClPJCGp9lkmZSdneT5H+OojFWUndcMVfslqyclSqPFYBi6GY2Fj+//hKi7clzr4zKsOrxcrJrEbO9qY975POJ1SLSCebfflxvBWQXawWdwpL9EEkwXN8DKGFGoqT9A2XbSA86VG8UQGUbz5o50enTFnNt96qSSuyClLzjEPZiaLTLrWNuYKKU9ZyjpXv5Hdb+/tabEd4OZBIxjurDu6t0BFG8klNG2jMaB94LqnjvsCF5PIHqxL2iH0kgZu1Zj8BL+jTvo2FDc2aGDqJhE8TCD5FtVMhTxysz7gNShkVuszih/8DvTJkCOCSvmK1kIIGGf/AhzcLKUNZfHAcXFJAgYJcf1jqkPv19P9FW7aw3ZeWYXYbgOVqOicQJC4WaQ2haOuwpOyoBCtHg7xK/tPcgSc06ZHMX9IsJRauuHkU27SX/Rft6htLpVTUAKb0AtybdyOdYndpo=
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

This feature requires CONFIG_BPF_THP (EXPERIMENTAL) to be enabled. Note
that this capability is currently unstable and may undergo significant
changes—including potential removal—in future kernel versions.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 MAINTAINERS             |   1 +
 include/linux/huge_mm.h |  23 +++++
 mm/Kconfig              |  11 +++
 mm/Makefile             |   1 +
 mm/huge_memory_bpf.c    | 204 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 240 insertions(+)
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
index a635dcbb2b99..02055cc93bfe 100644
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
 
+#ifdef CONFIG_BPF_THP
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
index bde9f842a4a8..ffbcc5febb10 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -895,6 +895,17 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config BPF_THP
+	bool "BPF-based THP Policy (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
+
+	help
+	  Enable dynamic THP policy adjustment using BPF programs. This feature
+	  is currently experimental.
+
+	  WARNING: This feature is unstable and may change in future kernel
+	  versions.
+
 endif # TRANSPARENT_HUGEPAGE
 
 # simple helper to make the code a bit easier to read
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..4efca1c8a919 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_BPF_THP) += huge_memory_bpf.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
new file mode 100644
index 000000000000..47c124d588b2
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
+	if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
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


