Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9381FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 05:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A506B00CC; Mon, 18 Aug 2025 01:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D43C6B00CD; Mon, 18 Aug 2025 01:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175386B00CE; Mon, 18 Aug 2025 01:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED3F26B00CC
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:55:34 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C49D160758
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:34 +0000 (UTC)
X-FDA: 83788816188.21.85ED223
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9EF5718000C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:55:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRII6b5f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755496532; a=rsa-sha256;
	cv=none;
	b=VcDlxUuZWiJ3e9prMsjo8ypziuTvUMEqjIKQcxV8WXh66QoBsQYEHNTnsMYOrXNJJOOP6/
	gXgT3tcUx3KxEcmiJFbBRngwKI3+qgsaRvBjVXzwk7UhDW0hgznbqcBUH/RpDw3WcXjrbc
	C9xgGhPhr5UwlX9bAIf6nXMg2eOBg5U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hRII6b5f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755496532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOcckyjft6kcyiorJn0OA5hNslItkT565Z5aC2n6m9M=;
	b=Xts4jdeuz5o3SeKhtsa6/0VNyOdCSU4OH4BaQuOBXyTE1OVeYCKhoKYK09gNSzvT15DzsT
	03GuaxO+MLx5hbSCAhtLhhdgpjnW4IbVybcPFksWuNZMdZ3zqf+7rojUIvZEAPma14x0za
	e7zFAQ7EW1eVdCOgi18laAFv/gDha1g=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b47475cf8ecso327129a12.0
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755496531; x=1756101331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IOcckyjft6kcyiorJn0OA5hNslItkT565Z5aC2n6m9M=;
        b=hRII6b5fXJck+Tv1LCQtZwvzr+CjpbglPOPa3omPgfPqBytFxB9z4qQhl4RuvXNjdh
         29C8dlMuanY1B+qPYgvoB1o39d/7l8Kyda1edgrAJmxm3r7Cupcty5jCeAymQ1zRM3mi
         Fa/+ct49kpjd25AzJPFVbbgBwbpn5/+N1I+tynvHFjbu2tTaUwEPSzJ23rw0pYiIqfJv
         w2xHx4YHXp7WeKZrUWhxtd5eBxeIoZsSkBJHp/8BFWNERnhIXSeH9sUhPPx1NhMUGoH3
         lgdJU6hhvDih7eV7F3U1/I2PHPZFylSo3qCm2rn16HAZSnU/MDt8lGsoB8eWh5/W+vgr
         o/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755496531; x=1756101331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IOcckyjft6kcyiorJn0OA5hNslItkT565Z5aC2n6m9M=;
        b=GGN/HlWrq1y//j2sLSP6StwDtqNTuFnhGUqbT8JY714Iy8oQc9LegHyy3S8ZI+Etyu
         mOLA7eN6ewawN6iTYeepJMrr3pwv6B+f4rE2cLM18r8okdxvSgOsTFIsPhnKqUafM1Jf
         1H3fmotDBFGXCJdmGO/KYjSIkHvGj1rGRrcWS/KmHj9I7r7oTgfea8vxCNnB0JkbK72q
         cnFrsd9YdFsb7bRAJmOjt+TVrMdU74YM7DKgpbK9uARR6fS2HbwNKoHslbKIsCCJZxvl
         8dUucsUVZ9wsprUD72UeiIJVxzaZVMOSya5f+iXj5FpUmtCZ8dm7pjnPE1PC5ktHlAm3
         +wcA==
X-Forwarded-Encrypted: i=1; AJvYcCWJNxwbTNYyxo3p7R/5LBpLjZJ/nhz3kSVDeidX0hZACZ+ncrRSaeCKNGutc5QFP27WzCzltCqCUA==@kvack.org
X-Gm-Message-State: AOJu0YxWAQvLY50bIE2S7zWD0QRslNXB4FQ4+I2A91cSIq8HgZkc0Cec
	2C2GPhXsCYPieM+60vpJfNMVltMdCC9j+SOTep1EbMuuAiF4MIekec0D
X-Gm-Gg: ASbGncsiVlmaODTWrWIbH/Bn9PXKg6XnfK0mExEw33Bh2meLE+zcDUNHx12W3iVAZW6
	kB0HDYraQaxoC+sFSAgM78XYuAU3yVTGq+aLVM++3Mvs3/3TNCTpmSAAcniJnIY2p1R/DAqH/NO
	fnBi5Myy5XfAWCc8LIJNj30fUiix8u8cebbkpHRiBxLdopYFFOIcJl5QtoDcNr8H2RFWxpyuald
	al8gVxjls8+w925CWHpneyXqCyoxedFaumrlfFy0n1zpZZwkvgN2xGtdg3CjpdxVdYDkofDcybK
	S1t/dlHwaK+4hrbx4Ddn6MMWQGwLRPNq/TubB4MdnW8RHEiube/YCQY5keWm6t1oHejn1N7fI4L
	85/CTUh322lAQbsbpUJdlOqQ69LgEaX8r4hQWheklaWaehTi2PEeMdzlQ
X-Google-Smtp-Source: AGHT+IEgZ+x0wXqSlVJS2uDBWkQCUOb23gz+OLYMrMNHpL0x50CfVP7RhUm90K6SdotFUymKrDtYZw==
X-Received: by 2002:a17:902:e5d2:b0:235:779:edfa with SMTP id d9443c01a7336-2446d8811dfmr183438035ad.32.1755496531286;
        Sun, 17 Aug 2025 22:55:31 -0700 (PDT)
Received: from localhost.localdomain ([39.144.105.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-323439961c9sm7003413a91.13.2025.08.17.22.55.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 Aug 2025 22:55:30 -0700 (PDT)
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
	rientjes@google.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v5 mm-new 1/5] mm: thp: add support for BPF based THP order selection
Date: Mon, 18 Aug 2025 13:55:06 +0800
Message-Id: <20250818055510.968-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250818055510.968-1-laoar.shao@gmail.com>
References: <20250818055510.968-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EF5718000C
X-Stat-Signature: 9i6163gk64195mhr491xc6nnzkkzus1e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755496532-129974
X-HE-Meta: U2FsdGVkX18xtb/xsngLI7k5u7Z4rpEuM88uODesosRvN0L/ez9z1clX+8vCsxfECINsmQOKhyuoV/RTz0kuDsUx7Uk3x9sa2SKnyFEqMmzMeSNSvPcY5tz/v43EnuCfStaKkF3R7+1WwQDAt/UNjQgxMBjlS2D0I81ZRCjVSoKt1Ebw+ofEJxN663fQHf2T1fLNttupgelwQ6klmasiu36QUHOrXOdpljOz+fftgiOZYCx1Vb0oGHAU822zB9ERRievlSUmG3ZBciNSBd8TXGx7HK1G6G5LTj1rD2b5BRmsFyswNAPM9h7+NZawBeEhAxjkDu938hZRKJ8oueH9WfV0W6/0TNq3CmJX+koj+JrQxNOfjUgj/AaLwIItQEl9bKJPe0094vp0KRaBbzRrnRi/dvr13c7ZVQRzDUUEn2UgPtD6sPAEEMD40JI2cWezGQ+CZEG3mguSJLPvrfdVcZDCyLm8lXEt1ikHu9McZSa66VuIolx3KnJdjGlr4H3I4glEu0ike0XzshMOUJXrHvJo5XQ6kqIQ8o9nubvzTIll12UQkyOJZg3MFw5R84vaJ5HySsX+DT+hjw5AyEIxd+OFpCJEQp9NM7JxtHxy73OL8STuTTL/8Qr67DzmHlU9JPr3hNIhr/WE1jLsjpldJ6LcxNTPNIAOqKoMusEwbRtXTsWFP32/kyINbtzpEyLd6dwXg5Ts1Xovgn6dLiYZ1pfMsImvc/57MGlyLbIRPGNi7v3lBGaB7GOlikXWXrX61NBxgV7qbTQLwWc+1efApI0GQsnaU3CROQkiRqOV0UG+hksrqaENopSHYNZRzM+Vg7LK54wi+NLSUu871CGSHdmz6vwg0X7TtgGESf/s1hucPSVtS/jbXR5ZX8eKPCnvpdxSM9qT1EJGoXwTQ2u87JVZONchwHc4Uzugs1OjV3Ykq1YWs31rfPK55+/xZkAm/VP+x0HZ9m3VUu8AH7t
 959DtyrF
 nUqIRPdCCVwhwCQV4rPxZnCkrrBSAYu+BLTGx4i17Metf6PF2s0R7bUYOP/eQWe/FTvwpC3dCoxl2/MioDsjYI+G9UOVchWUV67kaUvdebALCPLmTS5x/hsO1KmC93jeMMB5FhBG9S3AqZ3Ii6TurmaTATCzUE2/VFzL/KGhfHMcqkXAGTzBA5no5YryQVCoQlPuJMFAKIYMoR9ubGtxgXvEIrJrhuzKEkmaYOrp73BcLECAGSk37DGKhWvgf+g5iZTSjUIHcwLkytI65T7NbPFd2W+NrLBdhg1YNKtkasCz6lWDHgHploozaj/4U7Rho5WFmvKd5J77G7yPjhHzCQdjo8FMwGSUCw87MS9h/Pijxkq85bb30m7e3Fn9YakahsTtkOjlwqsZn5nyBiwtvPBTXMtLqlmLbyh4IamKFTtLXF4fQcUce/Bcn5ONPf18CKfcejw2CERw43lN80rClvrq70nEpY+MtXiMsODOkalIj6J2zF7/rX7CBIGEvoUq+H9EQtzc0Eey7sHsOie+1eGtSUHT+/MmhGtfPwR39XxPzM/VP2SbaurhgPfvfff3YPXil+VzsmlBdqW4a1jWc8VwNnsb9mHicSLyEV66+XKeQuboMcZmJc6xsiZTe5jemBFLrEiGhitK3VjD9kCXs04+u/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
THP tuning. It includes a hook get_suggested_order() [0], allowing BPF
programs to influence THP order selection based on factors such as:
- Workload identity
  For example, workloads running in specific containers or cgroups.
- Allocation context
  Whether the allocation occurs during a page fault, khugepaged, or other
  paths.
- System memory pressure
  (May require new BPF helpers to accurately assess memory pressure.)

Key Details:
- Only one BPF program can be attached at a time, but it can be updated
  dynamically to adjust the policy.
- Supports automatic mTHP order selection and per-workload THP policies.
- Only functional when THP is set to madise or always.

It requires CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION to enable. [1]
This feature is unstable and may evolve in future kernel versions.

Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redhat.com/ [0]
Link: https://lwn.net/ml/all/dda67ea5-2943-497c-a8e5-d81f0733047d@lucifer.local/ [1]

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/huge_mm.h    |  15 +++
 include/linux/khugepaged.h |  12 ++-
 mm/Kconfig                 |  12 +++
 mm/Makefile                |   1 +
 mm/bpf_thp.c               | 186 +++++++++++++++++++++++++++++++++++++
 mm/huge_memory.c           |  10 ++
 mm/khugepaged.c            |  26 +++++-
 mm/memory.c                |  18 +++-
 8 files changed, 273 insertions(+), 7 deletions(-)
 create mode 100644 mm/bpf_thp.c

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 1ac0d06fb3c1..f0c91d7bd267 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -6,6 +6,8 @@
 
 #include <linux/fs.h> /* only for vma_is_dax() */
 #include <linux/kobject.h>
+#include <linux/pgtable.h>
+#include <linux/mm.h>
 
 vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
 int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
@@ -56,6 +58,7 @@ enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
 	TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
 	TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
+	TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached */
 };
 
 struct kobject;
@@ -195,6 +198,18 @@ static inline bool hugepage_global_always(void)
 			(1<<TRANSPARENT_HUGEPAGE_FLAG);
 }
 
+#ifdef CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION
+int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+			u64 vma_flags, enum tva_type tva_flags, int orders);
+#else
+static inline int
+get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+		    u64 vma_flags, enum tva_type tva_flags, int orders)
+{
+	return orders;
+}
+#endif
+
 static inline int highest_order(unsigned long orders)
 {
 	return fls_long(orders) - 1;
diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
index eb1946a70cff..d81c1228a21f 100644
--- a/include/linux/khugepaged.h
+++ b/include/linux/khugepaged.h
@@ -4,6 +4,8 @@
 
 #include <linux/mm.h>
 
+#include <linux/huge_mm.h>
+
 extern unsigned int khugepaged_max_ptes_none __read_mostly;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern struct attribute_group khugepaged_attr_group;
@@ -22,7 +24,15 @@ extern int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 
 static inline void khugepaged_fork(struct mm_struct *mm, struct mm_struct *oldmm)
 {
-	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
+	/*
+	 * THP allocation policy can be dynamically modified via BPF. Even if a
+	 * task was allowed to allocate THPs, BPF can decide whether its forked
+	 * child can allocate THPs.
+	 *
+	 * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
+	 */
+	if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm) &&
+		get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER)))
 		__khugepaged_enter(mm);
 }
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd96784..d10089e3f181 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -924,6 +924,18 @@ config NO_PAGE_MAPCOUNT
 
 	  EXPERIMENTAL because the impact of some changes is still unclear.
 
+config EXPERIMENTAL_BPF_ORDER_SELECTION
+	bool "BPF-based THP order selection (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
+
+	help
+	  Enable dynamic THP order selection using BPF programs. This
+	  experimental feature allows custom BPF logic to determine optimal
+	  transparent hugepage allocation sizes at runtime.
+
+	  Warning: This feature is unstable and may change in future kernel
+	  versions.
+
 endif # TRANSPARENT_HUGEPAGE
 
 # simple helper to make the code a bit easier to read
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..cb55d1509be1 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) += bpf_thp.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
new file mode 100644
index 000000000000..2b03539452d1
--- /dev/null
+++ b/mm/bpf_thp.c
@@ -0,0 +1,186 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/huge_mm.h>
+#include <linux/khugepaged.h>
+
+struct bpf_thp_ops {
+	/**
+	 * @get_suggested_order: Get the suggested THP orders for allocation
+	 * @mm: mm_struct associated with the THP allocation
+	 * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
+	 *                 When NULL, the decision should be based on @mm (i.e., when
+	 *                 triggered from an mm-scope hook rather than a VMA-specific
+	 *                 context).
+	 *                 Must belong to @mm (guaranteed by the caller).
+	 * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
+	 * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
+	 * @orders: Bitmask of requested THP orders for this allocation
+	 *          - PMD-mapped allocation if PMD_ORDER is set
+	 *          - mTHP allocation otherwise
+	 *
+	 * Rerurn: Bitmask of suggested THP orders for allocation. The highest
+	 *         suggested order will not exceed the highest requested order
+	 *         in @orders.
+	 */
+	int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+				   u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;
+};
+
+static struct bpf_thp_ops bpf_thp;
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+			u64 vma_flags, enum tva_type tva_flags, int orders)
+{
+	int (*bpf_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+				   u64 vma_flags, enum tva_type tva_flags, int orders);
+	int suggested_orders = orders;
+
+	/* No BPF program is attached */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
+		      &transparent_hugepage_flags))
+		return suggested_orders;
+
+	rcu_read_lock();
+	bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
+	if (!bpf_suggested_order)
+		goto out;
+
+	suggested_orders = bpf_suggested_order(mm, vma__nullable, vma_flags, tva_flags, orders);
+	if (highest_order(suggested_orders) > highest_order(orders))
+		suggested_orders = orders;
+
+out:
+	rcu_read_unlock();
+	return suggested_orders;
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
+		&transparent_hugepage_flags)) {
+		spin_unlock(&thp_ops_lock);
+		return -EBUSY;
+	}
+	WARN_ON_ONCE(bpf_thp.get_suggested_order);
+	WRITE_ONCE(bpf_thp.get_suggested_order, ops->get_suggested_order);
+	spin_unlock(&thp_ops_lock);
+	return 0;
+}
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	spin_lock(&thp_ops_lock);
+	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
+	WARN_ON_ONCE(!bpf_thp.get_suggested_order);
+	rcu_replace_pointer(bpf_thp.get_suggested_order, NULL, lockdep_is_held(&thp_ops_lock));
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
+static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *ops = kdata;
+	struct bpf_thp_ops *old = old_kdata;
+	int ret = 0;
+
+	if (!ops || !old)
+		return -EINVAL;
+
+	spin_lock(&thp_ops_lock);
+	/* The prog has aleady been removed. */
+	if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags)) {
+		ret = -ENOENT;
+		goto out;
+	}
+	WARN_ON_ONCE(!bpf_thp.get_suggested_order);
+	rcu_replace_pointer(bpf_thp.get_suggested_order, ops->get_suggested_order,
+			    lockdep_is_held(&thp_ops_lock));
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
+	if (!ops->get_suggested_order) {
+		pr_err("bpf_thp: required ops isn't implemented\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
+			   u64 vma_flags, enum tva_type vm_flags, int orders)
+{
+	return orders;
+}
+
+static struct bpf_thp_ops __bpf_thp_ops = {
+	.get_suggested_order = suggested_order,
+};
+
+static struct bpf_struct_ops bpf_bpf_thp_ops = {
+	.verifier_ops = &thp_bpf_verifier_ops,
+	.init = bpf_thp_init,
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
+	int err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+
+	if (err)
+		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_thp_ops_init);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d89992b65acc..bd8f8f34ab3c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1349,6 +1349,16 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		return ret;
 	khugepaged_enter_vma(vma, vma->vm_flags);
 
+	/*
+	 * This check must occur after khugepaged_enter_vma() because:
+	 * 1. We may permit THP allocation via khugepaged
+	 * 2. While simultaneously disallowing THP allocation
+	 *    during page fault handling
+	 */
+	if (get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_PAGEFAULT, BIT(PMD_ORDER)) !=
+				BIT(PMD_ORDER))
+		return VM_FAULT_FALLBACK;
+
 	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
 			!mm_forbids_zeropage(vma->vm_mm) &&
 			transparent_hugepage_use_zero_page()) {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d3d4f116e14b..935583626db6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -474,7 +474,9 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER) &&
+		    get_suggested_order(vma->vm_mm, vma, vm_flags, TVA_KHUGEPAGED,
+					BIT(PMD_ORDER)))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -934,6 +936,8 @@ static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		return SCAN_ADDRESS_RANGE;
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER))
 		return SCAN_VMA_CHECK;
+	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, type, BIT(PMD_ORDER)))
+		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
 	 * remapped to file after khugepaged reaquired the mmap_lock.
@@ -1465,6 +1469,11 @@ static void collect_mm_slot(struct khugepaged_mm_slot *mm_slot)
 		/* khugepaged_mm_lock actually not necessary for the below */
 		mm_slot_free(mm_slot_cache, mm_slot);
 		mmdrop(mm);
+	} else if (!get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER))) {
+		hash_del(&slot->hash);
+		list_del(&slot->mm_node);
+		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
+		mm_slot_free(mm_slot_cache, mm_slot);
 	}
 }
 
@@ -1538,6 +1547,9 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return SCAN_VMA_CHECK;
 
+	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_FORCED_COLLAPSE,
+				 BIT(PMD_ORDER)))
+		return SCAN_VMA_CHECK;
 	/* Keep pmd pgtable for uffd-wp; see comment in retract_page_tables() */
 	if (userfaultfd_wp(vma))
 		return SCAN_PTE_UFFD_WP;
@@ -2416,6 +2428,10 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * the next mm on the list.
 	 */
 	vma = NULL;
+
+	/* If this mm is not suitable for the scan list, we should remove it. */
+	if (!get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER)))
+		goto breakouterloop_mmap_lock;
 	if (unlikely(!mmap_read_trylock(mm)))
 		goto breakouterloop_mmap_lock;
 
@@ -2432,7 +2448,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER) ||
+		    !get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_KHUGEPAGED,
+					 BIT(PMD_ORDER))) {
 skip:
 			progress++;
 			continue;
@@ -2769,6 +2787,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
 		return -EINVAL;
 
+	if (!get_suggested_order(vma->vm_mm, vma, vma->vm_flags, TVA_FORCED_COLLAPSE,
+				 BIT(PMD_ORDER)))
+		return -EINVAL;
+
 	cc = kmalloc(sizeof(*cc), GFP_KERNEL);
 	if (!cc)
 		return -ENOMEM;
diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..0178857aa058 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4486,6 +4486,7 @@ static inline unsigned long thp_swap_suitable_orders(pgoff_t swp_offset,
 static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	int order, suggested_orders;
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
@@ -4493,7 +4494,6 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	spinlock_t *ptl;
 	pte_t *pte;
 	gfp_t gfp;
-	int order;
 
 	/*
 	 * If uffd is active for the vma we need per-page fault fidelity to
@@ -4510,13 +4510,18 @@ static struct folio *alloc_swap_folio(struct vm_fault *vmf)
 	if (!zswap_never_enabled())
 		goto fallback;
 
+	suggested_orders = get_suggested_order(vma->vm_mm, vma, vma->vm_flags,
+					       TVA_PAGEFAULT,
+					       BIT(PMD_ORDER) - 1);
+	if (!suggested_orders)
+		goto fallback;
 	entry = pte_to_swp_entry(vmf->orig_pte);
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * and suitable for swapping THP.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
-					  BIT(PMD_ORDER) - 1);
+					  suggested_orders);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 	orders = thp_swap_suitable_orders(swp_offset(entry),
 					  vmf->address, orders);
@@ -5044,12 +5049,12 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int order, suggested_orders;
 	unsigned long orders;
 	struct folio *folio;
 	unsigned long addr;
 	pte_t *pte;
 	gfp_t gfp;
-	int order;
 
 	/*
 	 * If uffd is active for the vma we need per-page fault fidelity to
@@ -5058,13 +5063,18 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
 	if (unlikely(userfaultfd_armed(vma)))
 		goto fallback;
 
+	suggested_orders = get_suggested_order(vma->vm_mm, vma, vma->vm_flags,
+					       TVA_PAGEFAULT,
+					       BIT(PMD_ORDER) - 1);
+	if (!suggested_orders)
+		goto fallback;
 	/*
 	 * Get a list of all the (large) orders below PMD_ORDER that are enabled
 	 * for this vma. Then filter out the orders that can't be allocated over
 	 * the faulting address and still be fully contained in the vma.
 	 */
 	orders = thp_vma_allowable_orders(vma, vma->vm_flags, TVA_PAGEFAULT,
-					  BIT(PMD_ORDER) - 1);
+					  suggested_orders);
 	orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 
 	if (!orders)
-- 
2.47.3


