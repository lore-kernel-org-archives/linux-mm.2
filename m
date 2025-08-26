Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EAA8CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 07:20:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA4E8E00AC; Tue, 26 Aug 2025 03:20:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882098E00A8; Tue, 26 Aug 2025 03:20:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798288E00AC; Tue, 26 Aug 2025 03:20:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6435D8E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 03:20:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC193C0689
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:20 +0000 (UTC)
X-FDA: 83818060200.08.983E8C1
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id E75FDC0007
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 07:20:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GSYMzh6Q;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756192819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpQSoQdIe/yWdOf5WfFsJgS9um9rAP6j3UxgsUi8cX0=;
	b=GWibbrVw2hpykYTE2QMJzk0rJ4drFp/YXlYwvvR5Y5me44lS1u3HBtOEao6/TjhNXUU94T
	ksEoFXhX1hNR8U7VTBmC1ogFf8yrcj+VSYjhDyoa800sXYXCtDOPCOyVbj0Fbq6DR0Lgv3
	iX54tjquIQRy7QcMtHLO/e0eZO4r54Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GSYMzh6Q;
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756192819; a=rsa-sha256;
	cv=none;
	b=A14fB2i0eLP5XusKMskD4N48zpdtj53YUMsdUin8fCIJaeJUnJ22omLqEoMkOnSTQopizK
	TUaU7z4DsfJZtnN/ZXOrGVR1xNDjQmTzb3EobaGdFuFKWNUQRkCqAl8F1fVIzLF/0tqON+
	dWB2o9qncIGwvR1l9QX/Y86FF+i8Kbg=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-771ed4a8124so1367821b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756192818; x=1756797618; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpQSoQdIe/yWdOf5WfFsJgS9um9rAP6j3UxgsUi8cX0=;
        b=GSYMzh6QZ0nt2icecvfhiVlt6fnyZlkBy35wye/AWwFNZAUFC6lESd5rt1B9teMCHi
         jQcYljLfztSedgd9lek6+iZp8jDohHw1H/63T05Z36Ru1loNiLz0H1jyGw0SYg/zhxp5
         2jnoNGlhg79n5toOxW+hQB08sZsDI5cFyrQz7Cj8Evm8z7NF6tOl71ysLPE0h8+m25fh
         HG3ehCokz9aveKc+MzpJ2ED9xvc/AJCTLoOCAHtDadKUfcrjJwvpuMyXVZpACXyN3c92
         bEGpCfxGiD9JL+NdESyteLyY17jkhDJJC0KrCQM1MSmSbmMZTrJFpayY65kTNXguoMJs
         9pUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756192818; x=1756797618;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zpQSoQdIe/yWdOf5WfFsJgS9um9rAP6j3UxgsUi8cX0=;
        b=BebMdH6LiGOm5MegUg1P/3ck4hJNAB/ycWvbnutBOmwG52imuTKbOgCQQmIO1gNz5p
         W/MP5Uz/HsBOh/BXjXsNqrXEEzXk+l3BwKlIG6lb/6FBUVCOEgg6v3r628QZzaqRDqjr
         nrecBBDfVR+PfBtirQnCgTSGgk2GivFgBnGfD0cCuVDPEO65ZOeijZjnom4vo7fWV8yy
         iSP5CGII006wvhO//eXLyMYc4aKI1D6ppmaEb/HnE1Noss6FofpPm0oJbQYw9c6h5hQ1
         WWiWVgZaqAECXqi/QxbkLs+q1Ddzzfn1MAGO77YSnDcFjVC1yKzMgB5hh5VEHzKaujYM
         1aVg==
X-Forwarded-Encrypted: i=1; AJvYcCVmAyE52qMzfVEtx8NOIbz1o8ItS8i1JeP8rhbMWCElPnSO7cYqbPHfh24UCxXo01UfF3xnNn0yeg==@kvack.org
X-Gm-Message-State: AOJu0YwWhz1BH+vOw27CSy5l8oEYA6zyqLfNZboMb10eV4iShDQ6m5AS
	BXP871j3jBdWLD9/7GU3dBe8ToFy8QmpWWCYQqCPErXxAkzyD27x2fGH
X-Gm-Gg: ASbGnctFGwAlUpMzUlAVZ35MPVdQA8cBkaqfIWK0wc6WLlNa8ORkAWfJ4OSF1xLv9TA
	69FvjIU83sQ4kQM9ylYFoaIySNuXzZ9EIAYzDqM9v7RGHe4kex4hBq94gy6oIt5Tvox3vSkjefj
	z9A+ozUglAlVrhk1NjO89OkTpbWx5z9JahXMYXmNGwXj+UR4GhsGh4BbXRUz5WzRSh16xJbKc7c
	b+SA/vsHbJKEzzavNlhnN8SjdAhKcc5YiyOh9PMVPi4MjXeWlnoLEJTqnRERk6rzu6DhlX2M5W1
	fGp52Qa+RLXgwCoywcr8OyV91cYHZfoe38FssKFAQcJPJv8fbAcBx4ez0q30sVby51npHkjTW0X
	xkKkaR/5h6U4yoIAyVZMRhNH3/en6+VkemA9MF4Xr6Vd/za5jSvLDfLVSxeIZe+sO6RbiBcaUoX
	LYzeEU3ZOPfH/HM2325mHkDeiS
X-Google-Smtp-Source: AGHT+IFtT+zB18Fbg0YLtqEmYsDYqJltf4OttWmh3LVmawD0D1cjtQGkFXGG1wygIKGcmHMVcBzNpg==
X-Received: by 2002:a05:6a20:7f87:b0:240:104c:8e14 with SMTP id adf61e73a8af0-24340e1b2e4mr21142045637.38.1756192817670;
        Tue, 26 Aug 2025 00:20:17 -0700 (PDT)
Received: from localhost.localdomain ([101.82.213.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401ecc51sm9686052b3a.75.2025.08.26.00.20.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 Aug 2025 00:20:17 -0700 (PDT)
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
	corbet@lwn.net
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v6 mm-new 01/10] mm: thp: add support for BPF based THP order selection
Date: Tue, 26 Aug 2025 15:19:39 +0800
Message-Id: <20250826071948.2618-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20250826071948.2618-1-laoar.shao@gmail.com>
References: <20250826071948.2618-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E75FDC0007
X-Stat-Signature: idrwifr5wtoedqpan7hhxr34tdrsi5yn
X-Rspam-User: 
X-HE-Tag: 1756192818-325277
X-HE-Meta: U2FsdGVkX1932T2Jja5NV13K4GfY3cN3Zk27P2aVwVseYMX0TsbIEiC7SXd+u+NWv1LcddVw8a4vtkf9dotcEycUjtIGLVdYFzdyPoQcMm21/SJHmmMaBqgqjXz5Nckb0Lu1O2QFyYqkOZKO1G3IrIi3aO5++Xp1TB7lqueUipDiu2M2csdvE94urSv084HnAk5b0onS7IuZ0AZI5N23mwwxvk1wGoInM3g6g1untJ7hO3Ef8MWChXLZHZS4xCtxcBp/aOvQ8N1J0VqRqwMPSDsQihvKSnFAdBguJTQ8uAd0qz8kn3qwWV6wgj0T00p9i0xpVwM2Of34dtZWZNs29JeY4w9Ife4XRu29h02gsKYpJjHUdHn6jO2mP1CowpfjveVAEVlLsRxXgeEoHvAnwp/Z95p6wDuYEffq2yTyRgssUK8+CBLSNlKKorAo8yiaE5KTJwmKpNQdD+VqSqAwb4lO1lMZ+LGaGUQu3yieCj0UduDOt3zVQfeg2HGxhpbz2p/r+4zPeZ6oWtwoA3HEBucpJuDmUm1RjMGPFDCCp6RTKinraXFy3PVo1T+2FL9bMXGfMAXhYhyPKSwhCAwizJt5plwBmn25QRwU3rGbm4JhDaSwgBysIhuTowm2ybqb21Y/4v8ByIkHuM/WzcCYYcvR2zzMKFSRNoiPCytiuOHa41XgSMLpYVMKYIaQQvGAwGAHeFkofuJjeYdWg4NIi/YzAq1wA7vZOS6SXSfFENn9dIr+Uuf0ulkifhxNIpiUEKM+CYeo07e8Acw0yhG2eQ0j2n/eCiiVDTTP+mPx22QMsJB1HwAomsj5qReYs/WqL77Jb7p5iDzI/iqL2+ar8BBc/XijnTSvmpLepw7aUgEncwmCcVR2fcVuS+wS5sRQXLtTcEKsjxPJ+PMH/acgsnBc1XxhQgt0duUUvUh58VRr7BooqceqR58if95d9vUwJOprWvgesPjKPbdtjp9
 Aack+1gS
 2uDoPfgdR7Ap03R5fadN2j3TBeXsK3EBSXsKRxU6teH4vD+2lWS/Vmkb/b1C70IwcRqrdRniUeQP9WEYVNBvq6Pu4nD/1k0xD81hFEviNvjjG4D7DEFCjNxb4oMBJnoPvm06jJCDNy7VIewLqemAd2SblkZxQR9zFSwn7ilIaBSBSUvlHdG3tOIbn6hS7HO/M9A+77t2a0eYuzBzcKw+0gkE2iV/WRrG7SNcFIuRTCX0fsKeiEOKMAKC9vTRy1hhRSyE8SKHM+Yriy+MwsJV7Vjkk4vyLlJka8faOOniuVs6Bz8Ywe5t21FOGAKnXSYQKcdysOmCa0ooRhBaQfpMKibg8vhnDwnnhtdfXhLPHkyINq3zkP0ROQSt2ms6zlhJMVpqFa6lo4/g1zmMuyOmdl1hCg/AhVSds/ap4x9YEr8ixTe+oI0SKxt8tW4Z5hskJws1YpwiHt0PiLY1D79zd25fS8Eo+kM6aR+E2fSmlVJWyQu8/r9xoub6bDYppvptd32N3dvSFGBLLx6/sx6LLftsQr/4tIDoJcDDJjUOsD7TwPXJ18dzIQySnNmJ9qgYESq6yP9E4HBKPeC4AvzWXaaQi/de9/rh+K22wOvNCTmvXLg6CHzAiyv0xQ6SAU3tXlyd+PMPiYetyojhVtRiUej2fQw==
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
index 000000000000..fbff3b1bb988
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
+			     &transparent_hugepage_flags)) {
+		spin_unlock(&thp_ops_lock);
+		return -EBUSY;
+	}
+	WARN_ON_ONCE(rcu_access_pointer(bpf_thp.get_suggested_order));
+	rcu_assign_pointer(bpf_thp.get_suggested_order, ops->get_suggested_order);
+	spin_unlock(&thp_ops_lock);
+	return 0;
+}
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	spin_lock(&thp_ops_lock);
+	clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
+	WARN_ON_ONCE(!rcu_access_pointer(bpf_thp.get_suggested_order));
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
+	WARN_ON_ONCE(!rcu_access_pointer(bpf_thp.get_suggested_order));
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


