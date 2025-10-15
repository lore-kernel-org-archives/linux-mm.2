Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91701CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 14:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB568E003A; Wed, 15 Oct 2025 10:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C350A8E000A; Wed, 15 Oct 2025 10:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE258E003A; Wed, 15 Oct 2025 10:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4578E000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:18:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23B48138DF2
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:18:00 +0000 (UTC)
X-FDA: 84000552720.16.59B7539
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAAD6180006
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:17:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OAp5p7VJ;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760537878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7qP30YuscvXl/NsExNoZv6tgYV2hHaM3n9ZCz1kVmk=;
	b=lqhBiQDJE8V97qq2P8+yIFmJV9nhMlTpbugQK+5WgAJF80ZPjkKPKgcIrYHPhgVhfZcDQU
	u9e/1s6f4rpUOD/10lPDmnfm/PEULq8t9otIFYviKQoZati6GepCHdA6AD7jw2EbOezOv5
	4KN+ZFp45cbQJxe/h8hV+Hp2P/vP44Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OAp5p7VJ;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760537878; a=rsa-sha256;
	cv=none;
	b=FORC8atkOyjROZGdsMI1ALV4hiwzDoFNxtLTpHCXIw+XR2Yvk+XOQbrseeO6dzfwhKyT/H
	EBZt9WuL5FKebZQp7r7aV0TIgS/SZyTNpuo5S769US8zI2FEjiN88QnPllKx1oBTLlgjOP
	sz1HF99Tfz4+vp8mqCwAlkH4CY23HTs=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-269af38418aso76306785ad.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760537876; x=1761142676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7qP30YuscvXl/NsExNoZv6tgYV2hHaM3n9ZCz1kVmk=;
        b=OAp5p7VJeSRRwvvVl0AMeDc4R88V8H1I9Ma7pYxBYcHIa8dLDSF/nYbJ/oU5LLQ2ln
         4jVd66Y0sRPt8MpIeKtYKRF2MUhcC6toE+8fkkhgBg5gdYCo8Sk194gayakVAO/X+H2p
         tybAM/LF3558MiuZBOmwBACSgmRaodvCVqROpbPHFlObFBgKiLB4DR97KoPze1+LEODP
         6XUvtx/eI0YI6/QT6dp36+23VoTwwhWtn0xGqje56BtVf05Rw3PP0OeADzADR+7i0rnZ
         UHgsH8cIr7/hCN0xDuLLJf3Dm+KyRPxUjMUCcCf48WQkdZ32EaO0eZKm8FTY9P6mWiBg
         wEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760537876; x=1761142676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7qP30YuscvXl/NsExNoZv6tgYV2hHaM3n9ZCz1kVmk=;
        b=kzbnXSQbDFK5+A+6DQZEoeHVSar+sTPC3ClHrqxDLfSJUPjAWe38KlmUvBP18dMjiT
         CuKyvLAqH0JPd1YGs4Yv3jP9cFo5rLnRlrmgEJLgy8aAgKyvvYuczVWN3Z3e70drq4XV
         bxfodRJvEE7USaVxSizeD0cCRCzRdXxY85VmQ9jD26v60sPyh+fVmu5Hrl/FGOPDfn37
         +BBAm2DUmZ8rtUpgvz3ScxLmjqbOlkEAZPr4bOG4KPi8+uoTbZN136CzL2UY7ZhIa8fV
         sTa2dX02VWEj535nD7E5LAUmQeWV+jbqooNtvHQIIOxM2lMoLvPSVYhYz14Yl6f8tRoK
         QH9A==
X-Forwarded-Encrypted: i=1; AJvYcCXqjqZKzjO0ifVS5V0vP3KhKMtqONWoEc/nb6ouGlA4cphxiQH+aHTzqCvEGIJjX37iUmPVcNdcrA==@kvack.org
X-Gm-Message-State: AOJu0YzcKCcOGfw4VcupJPMM0JTRlPMpkeO1PILR3BlVcDJ8iSdKY4QC
	BFS46N9ozD2KxVmRs9STYzpA2AFnBhatsMZPRi2eHy6pJGa3TE0Ge2We
X-Gm-Gg: ASbGncv+SV9aIP30nGv04wBsuWh/tgMZqJ5LSML/RQkfW1CdFTkKddwHcEgs+QIC7NK
	P3f/6RHq+L2Xk4Ov/GqbbfBfHT5SLk/OlyQeVI2cTfvdeNY9DphhhG4JbCMvptibEPZgIHVsLNO
	Yku3F4vckgYHeDlxZnhEeL1Mwi8C3FmtieBRybIU1pvNANoML69GerGQeKBQvHJzIpk5e23YutK
	TPtXvxksjUGl3/9rgusrMouhXJGPcXk7MgwnrFdcIkKrQK8+xGVtKayTpX18qNH2IiwUdBCfVts
	+4ibSkDcvKHIanuQ0Mw9APVCsjzJy2zM+190HpmE++YPu5QxcSlAwxmmkO+yLJ1/KscByFWSRNo
	0FkdwzG26dekG4Dp3bF+i0i3kMPRwqslWKAKnwHdXGRbsEFczTupJWIXwobD9eTauuLlu3KkJKH
	M/rgPzjKxRJFEoGdGcCbj1zylshng=
X-Google-Smtp-Source: AGHT+IEZicTnAISK8MJWpWR+oAxwLSGeKmpYRt6FsHplpjvtISrx8Sv7/ANXu99FGY43F4YolcV5hw==
X-Received: by 2002:a17:903:2405:b0:267:8049:7c7f with SMTP id d9443c01a7336-29027356377mr399915235ad.7.1760537876046;
        Wed, 15 Oct 2025 07:17:56 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1b80:80c6:cd21:3ff9:2bca:36d1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f32d6fsm199561445ad.96.2025.10.15.07.17.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Oct 2025 07:17:55 -0700 (PDT)
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
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v10 mm-new 3/9] mm: thp: add support for BPF based THP order selection
Date: Wed, 15 Oct 2025 22:17:10 +0800
Message-Id: <20251015141716.887-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251015141716.887-1-laoar.shao@gmail.com>
References: <20251015141716.887-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EAAD6180006
X-Stat-Signature: 3q859pwrhnuzzudjr33y74ptu1ic4k37
X-Rspam-User: 
X-HE-Tag: 1760537877-924554
X-HE-Meta: U2FsdGVkX19e3mFmrgJyUlmpCv4kPJBqYWn9HJrO7QXw1T54EhehqYbnQxdkKA4LoBPh/f1XkhS+XwpKnz54W1SKasX3xCIVW6lWTKsgFLVSDcJ0/lHI6YkOjmQXUeoLIw1XD6nuG5SI+zP7rLTWGST7MeB9O/LySYu+N9CNqcS1yT3HHk/CULtfGS6ZIMHVz237UjqeyRR/BcTnC1b9QU/fbiwYrrgJb0PaWzUL5qQdLfiqzwhRy98N+e1CNDocfeGlPtWDwEc+DwS7tfN/EEnRwsIQ611ntbgJhWx9xeQAXAOnoofQsdfNiYUMeUXrZcEjMElH6UKQGvIEMQmxLbE0DMWzxEPjS88R/02CfxbioejSB1eAFty/8OJIxFakLJTob4JKu4OWc8imYH01NXdVc3Q9LIzzEFfLl+nJPSWwYGgSdfou+Enh75VpwI3Pkk8g9QcpxYm3dgcWecbg5fnI8r0vVttbdTKTbjcj8+7WnGejiel4uDo5FsJ/vUSEPCbJkqG+o2f91KP1z5WvV5pkBdkHbHzQHUrul+j+AGlXtjyZyEstZhqG7hfzoq4eN9mTypeYolvoZX+V/hOkzyBvEvhdLtX34P/71rVBP1a1iFo95OMzEaqGi3NTr2UjifmFUcD9MNvkFBAr8aV8HVTcMz7xd31brw6g6nvj+a0rl80u7ocEXb9lva2htcIPGkK7Th8e/b5rACBx2oPH0RnT3/OaJ5tA+GiPK5Zzoeh9Eu6N4k23TXdnshmr5ugfWFzXKlBtZEdY0gQUN34AZuh5nW14vRjwEBsSM1tKSKf+y77jhbahCQXPUlMKXR6euo//TjEOyCkC++oFAb/eXWI1sEZYP3EnePOuX5skZHRBddEWhAyoz/ewYqOd+dzBS18eW1rWQ5CjlZBay4bDLRLtt/WPJSNxAqrjb4RfXAMH/AwmXi5bo5w9y00a3GpBnBhv+mGkEvIQqhyj+kV
 cE89Mafp
 pemScdhNMB4xLXtHMGzYiCnBclhE1pI2MOQanFmYvitRdWAzhs3dRDhxPB37yWIdKW6IfT/O6AilEE7GWGmTWk4ZM2R2wZQ5zsVE4MY2QjCVDB03Et5BF6L2xg46oqtnRGlnlaeYAcYeACM9Xn5/yjyy/6HS7AhLApb5ljIsmqbggjBp8dIMd0+Ed7vzcgPMxDo8tOtMCL8J2TL5bwIMdb6TQDf5EYO8LNe6re8Y+RvsJ21adnCASxXrOQPBtI1HBLvliXIVcPDXCBK5CFYySA4KU2Ap+G/OpBSK64BXI+IHL6sI+a+yeG+alJMe9IjlD7nodhY6nS9Xr7puL0siC3I93SRJZqQUhpOYVykeD40vxkad4a7CRadp8Ezfb+o0FnOkQcW8vbRkzMtxez4OZ0P0Iun02VsWM0dOTn6lmPmdMqC1PvpO+1e0NO6pU0aOK1PXfHGkdjUwWwugjZGkw5lU4gWi15boy50mQ/MKebcmaEWt73xHkL8zf4sjwBh4XWwvaZdyG7r9kvzLhwQVdY4Coc4cTvMa1dsj0oWKlmdbyeVgC1K1sF0I/mxgiV/v3voIqblokaNHg454kmNMVEcuezA==
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

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS              |   1 +
 fs/exec.c                |   1 +
 include/linux/huge_mm.h  |  40 +++++
 include/linux/mm_types.h |  18 +++
 kernel/fork.c            |   1 +
 mm/Kconfig               |  22 +++
 mm/Makefile              |   1 +
 mm/huge_memory_bpf.c     | 306 +++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                |   1 +
 9 files changed, 391 insertions(+)
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
diff --git a/fs/exec.c b/fs/exec.c
index dbac0e84cc3e..9500aafb7eb5 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -890,6 +890,7 @@ static int exec_mmap(struct mm_struct *mm)
 	activate_mm(active_mm, mm);
 	if (IS_ENABLED(CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM))
 		local_irq_enable();
+	bpf_thp_retain_mm(mm, old_mm);
 	lru_gen_add_mm(mm);
 	task_unlock(tsk);
 	lru_gen_use_mm(mm);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a635dcbb2b99..5ecc95f35453 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -269,6 +269,41 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 enum tva_type type,
 					 unsigned long orders);
 
+#ifdef CONFIG_BPF_THP
+
+unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders);
+
+void bpf_thp_exit_mm(struct mm_struct *mm);
+void bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm);
+void bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm);
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
+static inline void bpf_thp_ops_exit(struct mm_struct *mm)
+{
+}
+
+static inline void
+bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+}
+
+static inline void
+bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+}
+
+#endif
+
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
@@ -290,6 +325,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
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
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 394d50fd3c65..835fbfdf7657 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -33,6 +33,7 @@
 struct address_space;
 struct futex_private_hash;
 struct mem_cgroup;
+struct bpf_mm_ops;
 
 typedef struct {
 	unsigned long f;
@@ -976,6 +977,19 @@ struct mm_cid {
 };
 #endif
 
+#ifdef CONFIG_BPF_THP
+struct bpf_thp_ops;
+#endif
+
+#ifdef CONFIG_BPF_MM
+struct bpf_mm_ops {
+#ifdef CONFIG_BPF_THP
+	struct bpf_thp_ops __rcu *bpf_thp;
+	struct list_head bpf_thp_list;
+#endif
+};
+#endif
+
 /*
  * Opaque type representing current mm_struct flag state. Must be accessed via
  * mm_flags_xxx() helper functions.
@@ -1268,6 +1282,10 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
 		mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+
+#ifdef CONFIG_BPF_MM
+		struct bpf_mm_ops bpf_mm;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 157612fd669a..6b7d56ecb19a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1130,6 +1130,7 @@ static inline void __mmput(struct mm_struct *mm)
 	exit_aio(mm);
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
+	bpf_thp_exit_mm(mm);
 	exit_mmap(mm);
 	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
diff --git a/mm/Kconfig b/mm/Kconfig
index bde9f842a4a8..18a83c0cbb51 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1371,6 +1371,28 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+menuconfig BPF_MM
+	bool "BPF-based Memory Management (EXPERIMENTAL)"
+	depends on BPF_SYSCALL
+
+	help
+	  Enable BPF-based Memory Management Policy. This feature is currently
+	  experimental.
+
+	  WARNING: This feature is unstable and may change in future kernel
+
+if BPF_MM
+config BPF_THP
+	bool "BPF-based THP Policy (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_MM
+
+	help
+	  Enable dynamic THP policy adjustment using BPF programs. This feature
+	  is currently experimental.
+
+	  WARNING: This feature is unstable and may change in future kernel
+endif # BPF_MM
+
 source "mm/damon/Kconfig"
 
 endmenu
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
index 000000000000..24ab432cbbaa
--- /dev/null
+++ b/mm/huge_memory_bpf.c
@@ -0,0 +1,306 @@
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
+struct bpf_thp_mm_list {
+	struct list_head list;
+};
+
+struct bpf_thp_ops {
+	pid_t pid; /* The pid to attach */
+	thp_order_fn_t *thp_get_order;
+
+	/* private*/
+	/* The list of mm_struct this ops is operated on */
+	struct bpf_thp_mm_list mm_list;
+};
+
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+void bpf_thp_exit_mm(struct mm_struct *mm)
+{
+	if (!rcu_access_pointer(mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	if (!rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+	list_del(&mm->bpf_mm.bpf_thp_list);
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, NULL);
+	spin_unlock(&thp_ops_lock);
+
+}
+
+void bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+	struct bpf_thp_ops *bpf_thp;
+
+	if (!old_mm || !rcu_access_pointer(old_mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	bpf_thp = rcu_dereference_protected(old_mm->bpf_mm.bpf_thp,
+					    lockdep_is_held(&thp_ops_lock));
+	if (!bpf_thp) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+
+	/* The new mm is still under initilization */
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	/* The old mm is destroying */
+	RCU_INIT_POINTER(old_mm->bpf_mm.bpf_thp, NULL);
+	list_replace(&old_mm->bpf_mm.bpf_thp_list, &mm->bpf_mm.bpf_thp_list);
+	spin_unlock(&thp_ops_lock);
+}
+
+void bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+	struct bpf_thp_mm_list *mm_list;
+	struct bpf_thp_ops *bpf_thp;
+
+	if (!rcu_access_pointer(old_mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	bpf_thp = rcu_dereference_protected(old_mm->bpf_mm.bpf_thp,
+					    lockdep_is_held(&thp_ops_lock));
+	if (!bpf_thp) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+
+	/* The new mm is still under initilization */
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	mm_list = &bpf_thp->mm_list;
+	list_add_tail(&mm->bpf_mm.bpf_thp_list, &mm_list->list);
+	spin_unlock(&thp_ops_lock);
+}
+
+unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
+				      enum tva_type type,
+				      unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct bpf_thp_ops *bpf_thp;
+	int bpf_order;
+
+	if (!mm)
+		return orders;
+
+	rcu_read_lock();
+	bpf_thp = rcu_dereference(mm->bpf_mm.bpf_thp);
+	if (!bpf_thp || !bpf_thp->thp_get_order)
+		goto out;
+
+	bpf_order = bpf_thp->thp_get_order(vma, type, orders);
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
+	const struct bpf_thp_ops *ubpf_thp;
+	struct bpf_thp_ops *kbpf_thp;
+	u32 moff;
+
+	ubpf_thp = (const struct bpf_thp_ops *)udata;
+	kbpf_thp = (struct bpf_thp_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+	switch (moff) {
+	case offsetof(struct bpf_thp_ops, pid):
+		kbpf_thp->pid = ubpf_thp->pid;
+		return 1;
+	}
+	return 0;
+}
+
+static int bpf_thp_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_thp_mm_list *mm_list;
+	struct task_struct *p;
+	struct mm_struct *mm;
+	int err = -EINVAL;
+	pid_t pid;
+
+	pid = bpf_thp->pid;
+	p = find_get_task_by_vpid(pid);
+	if (!p || p->flags & PF_EXITING)
+		return -EINVAL;
+
+	mm = get_task_mm(p);
+	put_task_struct(p);
+	if (!mm)
+		goto out;
+
+	err = -EBUSY;
+	spin_lock(&thp_ops_lock);
+	if (rcu_access_pointer(mm->bpf_mm.bpf_thp))
+		goto out_lock;
+	err = 0;
+	rcu_assign_pointer(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	mm_list = &bpf_thp->mm_list;
+	INIT_LIST_HEAD(&mm_list->list);
+	list_add_tail(&mm->bpf_mm.bpf_thp_list, &mm_list->list);
+out_lock:
+	spin_unlock(&thp_ops_lock);
+out:
+	mmput(mm);
+	return err;
+}
+
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_mm_ops *bpf_mm;
+	struct list_head *pos, *n;
+
+	spin_lock(&thp_ops_lock);
+	list_for_each_safe(pos, n, &bpf_thp->mm_list.list) {
+		bpf_mm = list_entry(pos, struct bpf_mm_ops, bpf_thp_list);
+		WARN_ON_ONCE(!bpf_mm);
+		rcu_replace_pointer(bpf_mm->bpf_thp, NULL, lockdep_is_held(&thp_ops_lock));
+		list_del(pos);
+	}
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
+static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *old_bpf_thp = old_kdata;
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_mm_ops *bpf_mm;
+	struct list_head *pos, *n;
+
+	INIT_LIST_HEAD(&bpf_thp->mm_list.list);
+
+	spin_lock(&thp_ops_lock);
+	list_for_each_safe(pos, n, &old_bpf_thp->mm_list.list) {
+		bpf_mm = list_entry(pos, struct bpf_mm_ops, bpf_thp_list);
+		WARN_ON_ONCE(!bpf_mm);
+		rcu_replace_pointer(bpf_mm->bpf_thp, bpf_thp, lockdep_is_held(&thp_ops_lock));
+		list_del(pos);
+		list_add_tail(&bpf_mm->bpf_thp_list, &bpf_thp->mm_list.list);
+	}
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+	return 0;
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
diff --git a/mm/mmap.c b/mm/mmap.c
index 5fd3b80fda1d..8ac7d3046a33 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1844,6 +1844,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	vma_iter_free(&vmi);
 	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
+		bpf_thp_fork(mm, oldmm);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
-- 
2.47.3


