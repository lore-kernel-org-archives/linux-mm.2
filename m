Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6E8E8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E096F6B0089; Mon, 29 Dec 2025 09:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3BD6B008A; Mon, 29 Dec 2025 09:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C622F6B008C; Mon, 29 Dec 2025 09:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3CEC6B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:31:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C73C1A1528
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:15 +0000 (UTC)
X-FDA: 84272746110.21.1B7D1A3
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63E66C001E
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:31:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767018673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
	b=JnB99+6QveIb4atVBovlqYrLypxXqEuPktf/k8WNOaQ9KwX5tRWBfS/GH0WhXeA0ZzTkA2
	VpMzyDXbA0uNfg17WPU/5S/Wdavgr6sjGI8+HEQdxEoJZdj5ujMBe1zoKt0sOAYd6OW+0s
	IxLmWs2TpfEsjBmY8sDMfkU8DyaPYHg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767018673; a=rsa-sha256;
	cv=none;
	b=ALL4ChOTAJIDMOq/bA/qWnMHdRF7tZjAozqbRxxgte+5Rj6ZTePwibwxA4/SL7kFrpfLpJ
	zG6WH232WBiWejpzieUyz2LpPVskOziAMJZ9hBPxKHQVJyFUA0P4JVeP8I9W/naQsZXpwD
	1tXxJhNDMtxb/Go+s0UcTTtq0omYLl8=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b9387df58cso14624362b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:31:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767018672; x=1767623472;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
        b=EesxHQ2ICpflQZ7bQn++xvU4mxKfPujMuCIkH3lxULmCKokO1meRtrdHFWXHb0WQSb
         2MdtNQv/8wajkrmgebUhQ1QYn2sFotPM3XE24l802dS/eeEjlMZubg28V9N8P5oxkXgv
         iUXz4ox0+yaqfYmLOfgQG2BmeZrhAt5+3nNStR6KL84tlDeG27RQYlDsDmbZW+7e7482
         09zzXUPnvDQE/UpMCq0zX58PhdjnTUnJgHkEn/giEusO6ZDUzJycqkyxVO1mgTu6GfjY
         TO6PzDFpjfn6jhqQbBAx1woMLFWkEOrwmnj/U9U/PvIjA0/T+xbWXLD89WEWrv6y33UV
         3agQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyAtxMZO1BFp6Ub4qFnWo0RnwoUAdSpdNkgLToWSxV/Wc6gFJAZRZ2FL1dr81AhRbm/v9PlBXPxw==@kvack.org
X-Gm-Message-State: AOJu0YyqnqoH6LfLdHnj7WJS9UKsgQmlEr3zVOH1s2VG+EdIRygWTTyK
	UG+o4JKVnT4kHxcfHAIAAtzzy13jB2g5duEzBmdSA0Ff0TwRszlJqYl6
X-Gm-Gg: AY/fxX5eIeyDzPQp3AFisT1YXPxd0S73ddeZRInw3haWaLlJ65DyBE6l4MzEaBhiR+T
	wwwI1mpgfe7a8myXLtLmHHZw4Nt7krlw3yQkBgRJOMwRUiOw9CsNnDpcaQoKUZahjrZS253N5dg
	z4e16Jrr49aU1Y3pv5QlHeFM1JPBW84ThmVEabRbjBo82QHaDIqyIyA/4ViUmoCrgNXyZ8uQBCh
	8FhzX3GSjjm14f+zQ1BxV2twPXgmeB/OKlsnWk8JxOqnP2i3S57vMIcqDedMp2sgdXucmar5IfY
	zoAbX5Fe7i+chKXon/rSN2mRsz3suK4BHKhDMXrIAhty0185uhp8RVEdfRLIPgO5KJndWYHd3FX
	wKyQ0yF2K0wcPTTds9GShA3fwlhCIBtwJrg/1kfI9+xV+rBwJ0rkKRXeD2C8iLZ1uMxFMczzkJP
	nJ8hgmWi5BZJkCE1jKRTAe
X-Google-Smtp-Source: AGHT+IFcZGgxztN2EeAun4quNpAXXOKNWX6LSnFOxrijtlTfhRDRGQK0tPKQ/9UZzDdFUSs+EvX5Jw==
X-Received: by 2002:aa7:9a85:0:b0:7f7:5d81:172b with SMTP id d2e1a72fcca58-7ff664807a0mr29842840b3a.42.1767018672206;
        Mon, 29 Dec 2025 06:31:12 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7dfac28fsm29705159b3a.32.2025.12.29.06.31.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:31:11 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH RESEND v1 2/3] x86/mm: implement redundant IPI elimination for page table operations
Date: Mon, 29 Dec 2025 22:30:32 +0800
Message-ID: <20251229143038.73315-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143038.73315-1-lance.yang@linux.dev>
References: <20251229143038.73315-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63E66C001E
X-Stat-Signature: jbf14apdjrj1ypk17d6nuguimf9mjobp
X-HE-Tag: 1767018673-995862
X-HE-Meta: U2FsdGVkX19zkEVhM+TFE4UoP6t/LbqBnr2daR/qOu5RCteH2Y+omb1YgbYzDOLOsLwCIvU+CfQjo1X9ryDPw5slLSLVvILxhBkQdixMhICQ6PDmm3GEDrypj1PSBwQWqz0KwxKqwnQ5NGVhzeLN1l0NF/M6RjG9+hRnMSu4Sh64s+lC2phNQiFJHoZriynT68qqnLXoCoKRPkIVBlMYc1ybFKIdf0raeeYKJra9jCzLm3l4qbtqcy+3Zs/9D0tQNvrkXmVXLHLBvRNn26WnU0yMcVEyJ2WGK/DOxLw+hCzrE0WH3QLeyXLv+t2LpfnkNcX2/huXtWv1ruExRZZoaCND+ChkBaRbvRdtvbnqprEaNylBfw5ctyfPmQCvMmaQDuXY7i5t+CChm2sygbHjpth/s3I+8CAmbwjUmZ5dBCpKaqFuECq0+fMUhbzsPywhXexa18KOBixefRMBfoVB8uc3Fm3bHCD+zxhjLSV531tCWY8ROEATf4tFgW5e1Six3VqT+EDv3O+g91OHlS55G+Ba2mvmU7W2/3VBbiLoWoj1tSjMd+XGp6aUDluMHjYfGMgFWyLzlJOVowiRx+F1QEr3rgAm4YrVhDaZrsV3RYIJg5A7coQSJKBjPXtPBoCNp5eEtGv84uw+2MnLJdgVuChJvJjPvwYaM0iTByDmNrgL5uzLxVXaZF5NmNh/mTfToHDV06jxQOOk4JXpEog9JYuuh0dz4XxMaWxEZq23UEAD7NJbHEIg6o/ZVVrT0HC3UgEa/h799Av5Q+ZiI0iEx2USCibhQdz5gI04Z1FP1awJD+ZjIyL6sdjIhQxSsmwyLzo/aCNUvoMCFqv+EQY/IIbNdj9X5B9YfkyUbxkRCUJZIGLXOYnW9z5+5H4XH3FmlmXQx+1yyepgd73NOnPOD2MKbnN7f6cbh/uoCoW963NIOhA6yt0v90mADjuHQ7mC/qV7TYXGKZUgaXD+nGb
 +u6G1uho
 Vyy122+/bdXSSRA22xLpEiHXhiMQiLWVXlUjlcPwHIiZunvGGwhbeEq/7/Z3fBfO77A2HthTaCKTg96hT53n/w/dMBHtwikr9TqJ9CO2FD+LnD5VHbULgiPm37qbUcQ2TJ2NVUUdaffIjgBKz2sgPD0Ne+U3WprSpcbuZU+zxKxdiAJLqvnIAAaXK8Mrhpy4G0YB0Lhm1QPPjutxKrW0JpsFI3Qh6q032NZLJKtG7ng+Lkps8fQ8ynchsCcHFSgRoJRmuAthuB4mXqTkgd3gCjic33pVRFeUobW6q+tnwmOuhpy8sq3cnpDthsmghRbz1s4xbNH83mp6JhptD3SyHnPiALLaBBqGazBgd7EnWvzt7JXYzI9uqkeJ+VZgNknoU4+cCMBsBsj48FpvGsjydrg+c8Qp9Gnw5BO7jm46E5o4LM5w1EI5wzkW2LFGckB5HVJMTbktBzog42NjJ8nUksq95vQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Add a callback function flush_tlb_multi_implies_ipi_broadcast to pv_mmu_ops
to explicitly track whether flush_tlb_multi IPIs provide sufficient
synchronization for GUP-fast when freeing or unsharing page tables.

Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
ensure lazy-TLB CPUs receive IPIs and flush their paging-structure caches:
	flush_tlb_mm_range(..., freed_tables || unshared_tables);

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 arch/x86/include/asm/paravirt_types.h |  6 ++++++
 arch/x86/include/asm/tlb.h            | 19 ++++++++++++++++++-
 arch/x86/kernel/paravirt.c            | 10 ++++++++++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..a5bd0983da1f 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -133,6 +133,12 @@ struct pv_mmu_ops {
 	void (*flush_tlb_multi)(const struct cpumask *cpus,
 				const struct flush_tlb_info *info);
 
+	/*
+	 * Indicates whether flush_tlb_multi IPIs provide sufficient
+	 * synchronization for GUP-fast when freeing or unsharing page tables.
+	 */
+	bool (*flush_tlb_multi_implies_ipi_broadcast)(void);
+
 	/* Hook for intercepting the destruction of an mm_struct. */
 	void (*exit_mmap)(struct mm_struct *mm);
 	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
index 866ea78ba156..3a7cdfdcea8e 100644
--- a/arch/x86/include/asm/tlb.h
+++ b/arch/x86/include/asm/tlb.h
@@ -5,10 +5,26 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
+#include <asm/paravirt.h>
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
+		return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast();
+
+	return false;
+#else
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+#endif
+}
 
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
@@ -20,7 +36,8 @@ static inline void tlb_flush(struct mmu_gather *tlb)
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..4eaa44800b39 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -60,6 +60,15 @@ void __init native_pv_lock_init(void)
 		static_branch_enable(&virt_spin_lock_key);
 }
 
+static bool native_flush_tlb_multi_implies_ipi_broadcast(void)
+{
+	/* Paravirt may use hypercalls that don't send real IPIs. */
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return false;
+
+	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
+}
+
 struct static_key paravirt_steal_enabled;
 struct static_key paravirt_steal_rq_enabled;
 
@@ -173,6 +182,7 @@ struct paravirt_patch_template pv_ops = {
 	.mmu.flush_tlb_kernel	= native_flush_tlb_global,
 	.mmu.flush_tlb_one_user	= native_flush_tlb_one_user,
 	.mmu.flush_tlb_multi	= native_flush_tlb_multi,
+	.mmu.flush_tlb_multi_implies_ipi_broadcast = native_flush_tlb_multi_implies_ipi_broadcast,
 
 	.mmu.exit_mmap		= paravirt_nop,
 	.mmu.notify_page_enc_status_changed	= paravirt_nop,
-- 
2.49.0


