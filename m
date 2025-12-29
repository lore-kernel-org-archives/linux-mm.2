Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E409E8FDBE
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67586B008A; Mon, 29 Dec 2025 09:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48626B008C; Mon, 29 Dec 2025 09:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AE06B0092; Mon, 29 Dec 2025 09:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A15AC6B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:38:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51C0BCDC08
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:12 +0000 (UTC)
X-FDA: 84272763624.07.E2C0727
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BE2E1C000B
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:38:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767019090; a=rsa-sha256;
	cv=none;
	b=hjmFyvKWfdq62kXb/N8uGMqmtBQV0YRpeQOWpdrnSutCU3xGq4DnmjxYpkXEj2DX3fgG82
	e0fKh01cyu82d/e2oKY8Jdj0AkJ3zl41S1Xwzg5vwVGH8HEPq/1cmYAXPXQt6H2RO2++6v
	qbqVbqRXA4AHbBvG8n9hELtxZtV2v2w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf21.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767019090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
	b=XxrMYbGengMtCBRZzkunLkaIYQ44kMm/9UDouEP3pybS/mEyg8kCxj5VWGkMXpoIYBsKvJ
	TMZJSVPZkIodYq1DjJXoLhIAev0CLN2N07TLsh2l2xmvSi8Ki+/6OblzR4a3rSpdUlFJ6R
	kTMNExy8n2OsgnV9vBLmfhIgIPfkP+U=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a102494058so49646935ad.0
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:38:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767019089; x=1767623889;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
        b=gd4GtkMg0kG8mDqjSfsNZ8OT26H2+bSwHXgNZLrzPBrA5M5Fn+2VyIJMOscTAyR4bT
         DkP0dn0YajEhIZe2t7Ffop5r9nX2rXfIxDIZZKDyRD50TN9NLIFwkT8iYBeTxcIh/EvF
         FuZ2lykIdaromyW+DzK3huobf+9/XN8b44CAIsOXc0/ZFBSWr07UsAU65vWn6LlqRSto
         rJYSA+qPGHa8fX8p5B4C3gCzJ/FRIPuy8Hf0dw6kWckMy6cLBALlNsC6ga67u4J8Vdn1
         ge8MqhJGRt0BXx+3hEUXS5zckF9V8aCf3u3sBdiJ5WFPYjJqalN+M5Y0+Cz2xsbfKzx4
         kvTw==
X-Forwarded-Encrypted: i=1; AJvYcCW6PL7J1L4F38odznqCTdlcXv49R3IrzqL0XAyjlUaXvzSiWo5sOozx0LSwAPlRtCKIbP6fMHubUQ==@kvack.org
X-Gm-Message-State: AOJu0Yzsni+gbGrcXLVYJtJtwNJJw5SACEzFfWW4vdossvsHpl0X8/6b
	gqw9zC6BuFWvR3PxO/ywn0FwD+0p7H9DXalgpuHSDn095xl4UUaqRriN
X-Gm-Gg: AY/fxX6xrqrKGqocmgx0L3G10BjxCIcbdBkIJQZ9abz5n2m+N0InTYKWGBbgx9ULnwY
	Q/JzbuRt++mMvUob9unWyG0zKmB9MLuwGLdcbJGgcPlbt6n4hn23rpeOasZFe2Uqn6eKSvlbMBF
	xaPs8/30dwyDj8pTTZJHiTflVATlorzWlJ1t2fXmtwRFZz40HDIdtvrL6ppBr7DyRkMaY1zYh3x
	N43Bhdt4KG8xT8U26WR9OKCfbF8JfiLxYlIbwQlqjG+l10NjamVllal4VzHHg/uF82C6FDwDerB
	/jh6lCUh7On59Cu6KGNHHu8t6nmNBOfth6vonVkhqffJyUanWA2axPbuYGIsUyzL0OWfbHPfSEb
	+DZm4QD1hvaEcUed4WQSuW3wBDN3Dbn83chM0MMesydJxLqNf9V6m0Ay22TzKZvvUZS9ZiAqzaj
	ghuGT2uTurnsc0oqW9UFxr
X-Google-Smtp-Source: AGHT+IGbzQsFnxYP9S+gBanduwTJYp5i/avcPenp0gxUy3BJDakAIqFIQWIEeOZwEbX1DJzlvouniA==
X-Received: by 2002:a17:902:cf0d:b0:298:45e5:54a4 with SMTP id d9443c01a7336-2a2f0caa6fdmr287168855ad.1.1767019089301;
        Mon, 29 Dec 2025 06:38:09 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([45.8.220.167])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3d7736fsm279669625ad.92.2025.12.29.06.38.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:38:08 -0800 (PST)
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
Date: Mon, 29 Dec 2025 22:36:56 +0800
Message-ID: <20251229143657.76968-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229143657.76968-1-lance.yang@linux.dev>
References: <20251229143657.76968-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7BE2E1C000B
X-Stat-Signature: jbf14apdjrj1ypk17d6nuguimf9mjobp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767019090-445595
X-HE-Meta: U2FsdGVkX1+6IgM4J/yvmtn2BpHgAZ975xZJVVreB3KUDbJ9kZOwNZlN0vZLPDJDxQom1a8GIYS9rOQ5mK9AZougAh/5QKlgz3LpwT16hCePu+vQb2tyBcz3WyGbUbE9vVoqjqeBcjR3qd92GwqbcjxH34LNrsE+vMU7HcK3gg2palokebm31Tv0TVCty8P1p6WxfQWV5k8QChatecNSlS7zEkUYDA9p7leTTtqZXAXhk39IJVp3mo5JOW8X7Bnxkl4Nz7qmIueJ74KWCWlmwMGd/XdQNb1IxjIwRkfgxsGM072UdlGzxNlwRA8CCigTZZqSiaC/SM8tZjUNsV6fDclxAH89szGmtmqYfL2lz9V/HdhpgszysO9VA1oLNFJWLxXrgjwROorCvIWIv2vSrZFe/y7Skj+oJXXs/TfE5369Xi60VvNNCuChyurdsI1X4JWXcHR+nYQcjFnrO3XCabwwhOmPNG0qUvLK7jPdBjOQtXy2yo6uoTJ0QTMIeVj9ajAdV/LS0uzz7faXSN2IgHU3QG+kcbtqvutzf+o1jfHlV3feEsa5Iu6u5uYkPsva/JNUG7nM/zBGHmv86EN/QCdtQh44PhhbtBrhzwN70ejdr6Uk1zPa/s3c1dR/x7RxUtkdvxbU8uXJ6TW8IuB/Ryi94VPFug6a84M5ZKGGOQy+4LaCnBvIU/R6mnb8SzGF0y4P9HMMjNFLfMaJ3gkSdajnJbkLUBn6mZKSSXDKHrx3KA3axqD0lChfhSn+51U7mXOhmDSwGmbzS0iJ6jGwm7AoRJ3ichlY7BuobfVDzy5lx87pPpcfMDRc1ZG3YRK6Wg19nCpUmk6PalTAn+IELucnFzO7oFdlWI2r7gLk4QJ3o1lfJUzgpcbEqBoe7sAGWPE3onwQ92zNm2jiG0J8QFYuWJrTDPH1XBCG1kdbRqtrDwEsJ5g+e/opGvDHZHZK29cHvpXa5BisHxWyGWI
 v2UdG5SV
 2flISUysjsDbSZ8GsvLcyYygsgCh2EM5kep0M+670CT3po7S8dC7Lyv3id6jKQgsLqN6DB6QzpTacOFEJieKj7vLU0LdUm46zdkt/yQTGd9Nirty8wiPhmCLtRwpkq+IWVWC1IC/51Jv37M4xlXB5rO/lAcCrGQA4HYbZ7iWDeti0th/vLUJm0dar/s9/GB4sDqPpZJWRRNfoS9HtGUT4SX1xwtvEFa50wB06rff2vKtYpQQhJaO1Tbc4wT3nqH9fIflH7CK6fk97Q3lzNQ+uhLC3/NgTga7PCROSB/HaI8tVJfjwI1+IPOI2BwyPgPkbiiNaF6tdZg1QTgVCwvOeU4dgm23O7Cpi/ictuX4zcKNPVEN2V8XRiHEEE8jcwXgHN4surnr3RTy264xUaHk91oyNlWkUS41xk+Bk1LGRXteQMzhQabDWCElhaoaEwSc1Eqi/7XmvGmng3tW15qpdVvgqdg==
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


