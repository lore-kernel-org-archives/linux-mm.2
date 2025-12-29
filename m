Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E9ED3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:54:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F6A6B0089; Mon, 29 Dec 2025 09:54:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E496B6B008A; Mon, 29 Dec 2025 09:54:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D387E6B008C; Mon, 29 Dec 2025 09:54:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C1DD56B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:54:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 819AD5F953
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:54:58 +0000 (UTC)
X-FDA: 84272805876.12.22469E5
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id D5911180016
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:54:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767020096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
	b=MMTi6N87XSMEosNhP0gJKTEayPBgjQMJssWOmgOgIM0LvfiBfP0kbY4NRXpsabpRdpW7Ww
	SdqtEEZgrGu05hhwOxvY+WWamPDABUGbP+BoCayNPwvfOeKqkOnMZmJLUwJbMQZhyBL4tf
	w9KqcB4Vl37ozTkS0OV4qgTKkoe7Hvs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767020096; a=rsa-sha256;
	cv=none;
	b=8JGSk7N4jbUV2H7lI2JgGf7xHFL1u36d3hfwDYmnC1O1sHIs87EbsGOkEqcAIpn73UmCY8
	3P1b/H6EWUp45m5/+jiJml0DFPrnPTFUipnbbQussMAWQdYIXUtBA4dq7Zq4q+5mp5aq5+
	uVn+qTgAXtnunIe07UiJiOT4xWOxksM=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b80fed1505so9198943b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:54:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767020096; x=1767624896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
        b=uwk8Vs4qEHGy/ATw74JKjdoK1YC+2itePVcElW/DaBu4TB5WHXXaxDRYImWQyNJTjO
         KnyNDMfdH0tCZutf9Tkl7YSA12rSoT2kzzIfdpLpgZcpyvExnvMgDKai21H8uewhE0Vn
         4BQ/VFkReEyYFVur/M0h4FCka74PsqJJcJGfTvB71QUmzOl5juIEHRl8CwEam4Mb6J2h
         Tn9kSbZdm45bPrhDxc2tT0cqZ8SGPTLWh1H+c+1MR+vpQ4EKSJKM3JzaMGXYH1UEaFxu
         Cw79rDcIFpFkmomvjRzHkYUtUVCZJ6tEtxxz0PIJKBtKLWOoTLHoaPPyUbdtBeGRprGl
         8prA==
X-Forwarded-Encrypted: i=1; AJvYcCVC/IXxEI2Jm8uhdFWJYsRf4aULbqIsEEmN3zs1EP0SooqFBHgVhSGCmK0Td/uzaMDnOUWhZq+jVg==@kvack.org
X-Gm-Message-State: AOJu0Ywt77GzzmH0o993ElZUoPnPHMtzjGSz5Fi7BXjpXHclQtPfbK8P
	Xcu+Py5NVWoagFVoAlIjncNwPiZIBp9Ud9kXrZ897yKndfgoasMx4DRX
X-Gm-Gg: AY/fxX5bwcZp/4bNFRUVrxzdhj/1hlXDWue//5jc+doKupS+bQ15uHX7ggcxhuFlbMe
	q9wAokozn9sPfGyGoAktyaWuvmOyEq/UoAT+gghV4XuvRT6nThxJAHxeRtmCNTFD8U20pAbT6X7
	fT+v2I+/Hfqeq3BlMUckAwfjae/eRDdkmCyTgW4XFziqpS2Ofdxg5eFrpbQopSBYltTdwNpDtTH
	2LgEiUChROp84znXxVvI9yhSXgRQM6vvW/fkirB4UtD87Z9ajJX23nDJzIC6htPKbwoK6nMfUkj
	UryyAwBOi+2BNSd/b9+3Zwy64o/VeB709Q4GMHBfP6hibYpbt/njoDpmU+G/MElGmPCnGCzPg6x
	1+gsFw3HQsPEFq+3wJOIkXw/jB1O0Zxng7fXx1ajYS/pOr0VfBIo4oSvGaviYQ3yB+2hlJBYrsh
	Bla9kNgPXIvmTKLzy13Gz3
X-Google-Smtp-Source: AGHT+IEgAkno5Gh1oJSDww9XUzjPOXWz4twHLH5pNZW8aq25hrJps84zND6cTLDC5XmLsL+UKP9xOw==
X-Received: by 2002:a05:6a20:2588:b0:366:14af:9bbf with SMTP id adf61e73a8af0-376ab2e77c7mr30792916637.73.1767020095708;
        Mon, 29 Dec 2025 06:54:55 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70dbcb6esm31557603a91.9.2025.12.29.06.54.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:54:55 -0800 (PST)
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
Subject: [PATCH v2 2/3] x86/mm: implement redundant IPI elimination for page table operations
Date: Mon, 29 Dec 2025 22:52:44 +0800
Message-ID: <20251229145245.85452-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229145245.85452-1-lance.yang@linux.dev>
References: <20251229145245.85452-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5911180016
X-Stat-Signature: hfgqrinhdega9bn8in3mbrs5bwsjfmy8
X-Rspam-User: 
X-HE-Tag: 1767020096-903222
X-HE-Meta: U2FsdGVkX1/DrHzXkW+Tlkczo40U68osXo9v9tqsbJTDuIgAfPFE+5fP3dOD1Keg1vY4/AXobCI6OXJyVrEsSnWpWeJKGXz/YwnWJnyQ2a2ntjt2MN03JvK9xxKhew7R3FO9FLIYfVHbof/A9IIVCWlElOzan+/zIezNKrYatfb6F9zeKRdpOmZg4mwbGGh/NQAIFHOa2KuqP6BIHXd5y2ckYZXrVO4NmGKz0JGZx4iZ38qh6rVFV1YK2Drd7qePolb8lfOCyN8I+qyACx54eZDs8pdUYxqxx03iOK1kx07YlUf6TgOQ4s2UO6KeLF+Q3/l+8EywPGKwEAkLyFfX7dhPua0b5hLQihhCzuvuru/4VeWH51EEgv8kVBiq1ETuYiyMLzw7doAYLqYdqaJdzgzaABN7ZMjZdjnYoCxPjuYff2npnFdLDWCKG0bWUcNsCS+pLggN9YzrQe92pftzghN8sJ5tRrdIgOAM7ARn8Zzb7U1mhtxqaRYhuTMcebhj/RouoUnCXja01iTdEHUznd4ZGY0Dnm4xLD0h2AQambl4Rj2sqodl08L+TOwV66EuiMiKXC/tJOG+RwD0ZymG4pRiUJAbV4eFCtLMbH7QNu5umYBc5gnXRsWay5vARbAqqhDmbCiunQGGzrj8D3C3fDccIsqWsY/2nUmLrdSDmZE1khcXq3Hxr5B/A4hRKsFkWYyT/KTQa5L7eQRM+qZwVja7IEliKikVNFwEpdZLCsGPP4UAA6RehDss99d3/KdUGXpNrZG4k4ZkS4wT8n0rd5XQhIn+uM4rIld2YR7ZFXDDKRNNeNEMBQZ2j7SMUH2tBpjlb1EFlXQkQRE7v3/TzcFdIRkvJLD0AyzcslIjHsT1Xgn8C4TZfwn4vjXaY9Y8/+nnwc6mO78Bp87QtM2zugpzXivpaqD6FBAuT2mvxPvkMLIeyvW6JVyGMZOmvDx3Wu+pijQD9YASpTr00De
 TmFr8RNZ
 FgkOw1xoZlYr4N/jaV8AP/hBdDZ/OjIvd17mDtHWw11ACnf7g2bmPdRpVeMovzbR/ysW1xgMewZzWI800C/2q3kyVmTCgXbAiPx0uhvhBV+OQlTVbXpXeLBUuHI/WVvVeFhCuvPgT7xszOcby6aqUb1NM5nabWtrvSr391abtuguKOKRTUN63E46MxA==
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


