Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9209CC61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718C36B00A5; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608996B00A7; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6EB6B00A9; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 235256B00A3
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC9A41A0109
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
X-FDA: 85147572930.26.3FD719C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id A79CA4000B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CFxplSWM;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847883;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MKq7Nh2gcYohgYrYR5axiDJ4p1s9We/3CeTSchjvn7A=;
	b=4/wsGJY2MhD7GUgLty7TwOZkmDnRv1vV64yLS0jQCeZvAn7U530XWL2il11nyzflvNk8rk
	nST1gq7AhHxDBIWfFK6EZezI1hViibamwRdfo41L6WwWSZ3c7j3zAS/ReP5f10wwS9iy4D
	RdSKqGv4JwgXpxNMd9ImC9uE8Z7xZ4k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CFxplSWM;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847883;
	b=Bh3Nr7otwyAHLIdk50+wNbM9y2qq3WDe2k4wKGLWN2XScGAXPXsEVlD7VHNE+W9teS9JsL
	Rkbqjsw0GGc9H6UD+M2jLbTgb9bJxxpOfoTqk1WK9FPojTxIu2ixyE9WL8FGp/XWxl1JLu
	9j4jjrIm2ZCMSp8wglQwxrqNb1YtoeY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=MKq7Nh2gcYohgYrYR5axiDJ4p1s9We/3CeTSchjvn7A=;
	b=CFxplSWMhRpP8AAbiY91FEFGTrBwzp0iMlr33Qf/OYA54NMunuxvtLsKNFYazG/V7FN0tYbCW
	qVnSK4U881PmSGi5eEBaNy7Ih6oUsQdS4opo6Pbu87KJhzl/SLUUsws+oXRpCITmnkyZjeHgHeG
	yehCK3Lv097Ecr7CG8SvsTI=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hW6KX0GPXzJ46Yq;
	Fri, 28 Aug 2026 00:24:16 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 92A1F40570;
	Fri, 28 Aug 2026 00:24:37 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 27 Aug 2026 19:24:37 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <catalin.marinas@arm.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <vbabka@kernel.org>, <cl@gentwo.org>,
	<linux@armlinux.org.uk>, <will@kernel.org>, <mark.rutland@arm.com>,
	<liam@infradead.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<artem.kuzin@huawei.com>, <panov.nikita@huawei.com>
Subject: [RFC PATCH 12/18] arm64: make power management aware about kernel replication
Date: Fri, 28 Aug 2026 00:11:52 +0800
Message-ID: <20260827161158.3618409-13-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827161158.3618409-1-panov.nikita@huawei.com>
References: <20260827161158.3618409-1-panov.nikita@huawei.com>
Reply-To: <artem.kuzin@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Stat-Signature: h6mzpgq1b1hftwh9e93gre39ewzadbda
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A79CA4000B
X-Rspam-User: 
X-HE-Tag: 1787847883-297199
X-HE-Meta: U2FsdGVkX1+MrWR0qbY0CuGEuInr4mdgzoY5niWIpjSPyTpCtC8Vr5/u5gjW9Vy+00DhLlqCqkK6dAJsbJZLkSKxLIx5ACj+cbLzRCl8gVQ/8uNFoK+Y4MNwt9fODHQU1aHmWw9qhDvwRRrb6CbFMUDRzdMHwCXw+w1K7D9hpzbeCctQ3ioAEbzbSOWf0fNp6wi5lc3P67WoW4rr/+cCsS12irb8wlVrBkdVi+Yjknoddd+Bc/XHP91QxlKNsFFUMLExxk3GkmPpv2GFZ6bZgpNdCbqaeQVoty7hR3tfNpJbf5b3HczGqMGWHB3qqXt0YNf8ie/aGpVURkKB6WALLJX5etsJtDqwjJD310chgKkxWQof89VosnqJpOfNLIRAbXO2MyPDy08kR1HZH5a/X6iOFb3lVQdG/1jjm5ai86LJJzb6m7Q4qH2pDvoEINKL2HmHQJYO5IE8w4qMXTVfdfNqfRK6PJhXGIpSAkyZHHQQbSi/0DfT6h5XqXyy4+aRG8+23kkYu1qJM9UWtoDcjgsXwh7wmIhcADe3M4dz/219aMxDb4VobhCbPY/i9lF+2AgV+EtV4EPoc4jSIJutZzfxEn3CBoCrZ5Z3qH1hgmATYSgRiO4REJTkyt3ZhKh2GDCN1FwWly2keuCrHsXAG9EXfJCuwQquDfNm2ZFv/k71XVw4pofe7cMsGf3L0ck1xwJuVY5SND71+GTTh+09ZEb2L3rbE520Dl8aJBR2OzzlXsU7Um5yympb+yv306vbZ1eB5qBDXNWfbHFf+jRbYogK2z9IjjD1lnU9x8wg7bUw1jfTy2LnlvrYv8NZ+sIPgpf+x8bHnzBQ+0gTz2Y4yVAjDBD6v7MPpz8dzvt/1uvmTzeqCrpgeqtgySvOlGx7t7Ku6HKhA0LvC9swVIxgt4rWFIHL9pqRWvt0qeCGGOqApdxos3oc73nI+alOLo3W4XddaMNd1ldlEMD8vjo
 rWUrbBrj
 4cXZSyd+/5NjqEWwWg0OCQz5cFWHVTr/C8gFdzrWyTDGDou8qu0/U98ySBkYTj/oN6vAFzRpm+0T1Zj2YQcQS1ZWYgluwV1zQbHHCwtf3dEcBw5jGqGfoa79nCy0CY8uMXRRzK272tiSRh9iQdpkB0WnZ3OScxBM5xDibORFZ12BG+ZVCmkaKnAUfi/ZS6vvwfv4t9/WVNARC7Wkiw+SdH2CAvTlZSgTz5nUKRrzDT8qconY9iwINr0aqSg8j8L8t2XAgAqrBb/Wx+JIXiRudMD8YPjbGGX30HAWuu5neriO1RFBI/DKOAMYpQGTIVJ01jyjDEIWDyrzgz213V1uxfu5mjsr+A+ad2UhCRGdGOLSG8QO109iouCz/0YxEtlDXDB2SV0SEXCu6eCPcrkF+vYS3bsLE+pg9KFcoCitZALgeKsFGfHQKNNOQcuITA+hqMnmb0EWD7kCk0AHZDi7R4v1HAnH/AuTFqsWn7pc/xID4eShfmno0B+qJQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Artem Kuzin <artem.kuzin@huawei.com>
Acked-by: Alexander Grubnikov <alexander.grubnikov@huawei.com>
Acked-by: Ilya Hanov <ilya.hanov@huawei-partners.com>
Acked-by: Denis Darvish <darvish.denis@huawei.com>
Signed-off-by: Nikita Panov <panov.nikita@huawei.com>
---
 arch/arm64/include/asm/mmu_context.h | 4 ++++
 arch/arm64/kernel/hibernate.c        | 5 +++++
 arch/arm64/kernel/sleep.S            | 8 ++++++++
 mm/numa_kernel_replication.c         | 5 +++++
 4 files changed, 22 insertions(+)

diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 803b68758152..f364281d3442 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -136,10 +136,14 @@ static inline void cpu_install_ttbr0(phys_addr_t ttbr0, unsigned long t0sz)
 
 void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp);
 
+#ifndef CONFIG_KERNEL_REPLICATION
 static inline void cpu_enable_swapper_cnp(void)
 {
 	__cpu_replace_ttbr1(lm_alias(swapper_pg_dir), true);
 }
+#else
+void cpu_enable_swapper_cnp(void);
+#endif
 
 static inline void cpu_replace_ttbr1(pgd_t *pgdp)
 {
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 7bf117427777..e9f5ddf37c4a 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -16,6 +16,7 @@
 #include <linux/sched.h>
 #include <linux/suspend.h>
 #include <linux/utsname.h>
+#include <linux/numa_kernel_replication.h>
 
 #include <asm/barrier.h>
 #include <asm/cacheflush.h>
@@ -113,7 +114,11 @@ int arch_hibernation_header_save(void *addr, unsigned int max_size)
 		return -EOVERFLOW;
 
 	arch_hdr_invariants(&hdr->invariants);
+#ifdef CONFIG_KERNEL_REPLICATION
+	hdr->ttbr1_el1		= virt_to_phys(this_node_pgd(&init_mm));
+#else
 	hdr->ttbr1_el1		= __pa_symbol(swapper_pg_dir);
+#endif /* CONFIG_KERNEL_REPLICATION */
 	hdr->reenter_kernel	= _cpu_resume;
 
 	/* We can't use __hyp_get_vectors() because kvm may still be loaded */
diff --git a/arch/arm64/kernel/sleep.S b/arch/arm64/kernel/sleep.S
index f093cdf71be1..8ad66ed70122 100644
--- a/arch/arm64/kernel/sleep.S
+++ b/arch/arm64/kernel/sleep.S
@@ -5,6 +5,10 @@
 #include <asm/assembler.h>
 #include <asm/smp.h>
 
+#ifdef CONFIG_KERNEL_REPLICATION
+.extern numa_setup_pgd
+#endif
+
 	.text
 /*
  * Implementation of MPIDR_EL1 hash algorithm through shifting
@@ -144,6 +148,10 @@ SYM_FUNC_START(_cpu_resume)
 	bl	kasan_unpoison_task_stack_below
 #endif
 
+#ifdef CONFIG_KERNEL_REPLICATION
+	bl 	numa_setup_pgd
+#endif
+
 	ldp	x19, x20, [x29, #16]
 	ldp	x21, x22, [x29, #32]
 	ldp	x23, x24, [x29, #48]
diff --git a/mm/numa_kernel_replication.c b/mm/numa_kernel_replication.c
index 082aabc6b8bc..b1c5cd2a1fa1 100644
--- a/mm/numa_kernel_replication.c
+++ b/mm/numa_kernel_replication.c
@@ -67,6 +67,11 @@ static int node_to_memory_node[MAX_NUMNODES];
 static bool pgtables_extra;
 static DEFINE_SPINLOCK(debugfs_lock);
 
+void cpu_enable_swapper_cnp(void)
+{
+	__cpu_replace_ttbr1(this_node_pgd(&init_mm), true);
+}
+
 bool is_text_replicated(void)
 {
 	return text_replicated;
-- 
2.34.1


