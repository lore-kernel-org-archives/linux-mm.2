Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D66DD3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 14:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07E76B008A; Mon, 29 Dec 2025 09:13:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1ED6B008C; Mon, 29 Dec 2025 09:13:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89816B0092; Mon, 29 Dec 2025 09:13:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C6CF66B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 09:13:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B8721A1470
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:26 +0000 (UTC)
X-FDA: 84272701212.29.8270DE1
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id AA5D21A001A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 14:13:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767017604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
	b=OHdIRRXKh/7m+buul7Mgdn/AjyF/RGfw/YcwTunlrMnSIvXCe7RU692/p1nxvg+IUQ14CA
	JxYh+4eS/ZaImuKoHvfFAstbaWetUyreCMHz91DA+JfnrhyaGzU96i1scPHSIVtwTv0Ct6
	GQ0POwDcY6bn9gk5V+pig+bAaBi2Tts=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767017604; a=rsa-sha256;
	cv=none;
	b=XIIHtekXBs2bjqni4hNa0qzmWGyIM1AiAHWPkk6KF3scc5s2UeGYSUwPuOOjEdOIL4HD22
	hTaAv96ZaygwBPS8NAi/oBNcJIYJS6qxi3OcYAKqCLUu7rxVZudzpL+4jBufjuH/gaWX8e
	b3trijNkcn0SOOI+yVCjbkR7IZtewCA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9387df58cso14604345b3a.3
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:13:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767017603; x=1767622403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZldRDJqtH1ig79a3NbAjYulmXt3x4GlRPqkLpWEwBdc=;
        b=PW3wJYopv77USIuJ2olh4zhaki0qg+UtXEl1ScAFwAzA4O9ygRhd3A3wMm//bJmKvr
         l6Ox3ioruKyStyE4E89EA5EreajrSLPcfyEpjN8Ul9FaPyssWOm1r/dbGNWHMQA92Hfk
         199tdjCFEVtxuYjvsXbHGyjutQd/iXQmJOmqIHO6I000Hre4vcEHSGBJUkd7nMiykWmt
         mSfdgMFo93It4S+KIccqX2vdJyCk2KHw7SUezWuwxihu1qjWSb26Zk6k5KGWLcsFjLkX
         2YJPOboXtfd0LFyLgdhQ2UFMwwGf6947f+51JEX8e/VHVy+hqFAbI1JZl5LnTZHz+kqz
         ytSw==
X-Forwarded-Encrypted: i=1; AJvYcCXceLxatdkod0rKH2YBawv1D1wQZLux28WY60DhsreIqngOOCt3k0NIFH0lz68ZVHBsXxp7fBMWGw==@kvack.org
X-Gm-Message-State: AOJu0Yzk1YDaDM69XeM7lKou9ytMu+NGGuLXgJ76+pWg8v+nniJ8Ld36
	Ji4/gQmySQNL3DBgvNIZZEQPpuUx14b8n8HLCJnJ6WycT9wbZiwUYhQk
X-Gm-Gg: AY/fxX7H6TFcZb7eDzuo0Gf0ESw2jsuRWHDxiLszJ8LTH15Q/z56EPiTniRQrQ9p0eL
	M4kdDo+XC/0Ogx0c0ckNdfkBXkvE4hDT95rIBSL8JsVYMNZASWFFfbzMu/eDDWbSAOWqIsgyhbo
	rI+8DTcj2k/TUJMrT/xITod+hQe072spOtP91XhHDHP7gIQoOOs4OtnGzYHd3BNRuLLl6WmAmye
	roc/x2NpqSGeDrJ2b7jgd1zR1yOoNamVXd8+VzaIxSBRrtIpmoUuPA8uza10SkxRXHrwTSIA9a+
	ADh/wgJaHn9COHk/+u34gfz/uRRr2W1iQkaT+5V4JVXmoFBvyz04b7fcIpxUx1WXP1+ynB5qxWJ
	sgkp/oPyy2IPT9ixg88o/wPgV7/LhPHJQ9wZhmLC31nkaZ1DWYJOvNCf1YEIz/YrHptkaWAC5z8
	dehCONtG1aX0sw6SsJbkG8
X-Google-Smtp-Source: AGHT+IH9QXaO3feBvaLzy/ByuIkfJ3Ao5dwL4ovexpjF/alBrOC14CnwS3t1wGYhjPm1oFgU/egDBQ==
X-Received: by 2002:a05:6a00:8014:b0:7aa:e5f2:617d with SMTP id d2e1a72fcca58-7ff651c3519mr29469977b3a.30.1767017603556;
        Mon, 29 Dec 2025 06:13:23 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([103.88.46.167])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7a93ab3csm29472636b3a.7.2025.12.29.06.13.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Dec 2025 06:13:23 -0800 (PST)
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
Subject: [PATCH v1 2/3] x86/mm: implement redundant IPI elimination for page table operations
Date: Mon, 29 Dec 2025 22:12:44 +0800
Message-ID: <20251229141246.63435-3-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251229141246.63435-1-lance.yang@linux.dev>
References: <20251229141246.63435-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA5D21A001A
X-Stat-Signature: p9mcfe99xtat951q3w9dokpz39xry157
X-Rspam-User: 
X-HE-Tag: 1767017604-997683
X-HE-Meta: U2FsdGVkX1/+5gW3njo39eTruIqTKOVBTWeCJGt3mU9ZBCNjw4UWbSgi+h7YhTSBSRvDVbZQOKOi4teqBDpM6SN4LkseH6zSmHjIiCVjl2GhTV4jCE1KVgpVf1zM0jz8R6BskWY3VX7p6/Pwmrpy//qQEWwhRSepsHyPKtRRl1Pvb7nT5MsRNnFOiSXys6MnUf/n7mXnC2PlqnfzN7cJtaZvhJYucXKtpgNEIgkWnup9l3Hob72ODdo3S5sz5nX43MiF/3Ub8NCFroYGS+7QQKYa6Pm7s/Rb4WtGbzK9RAjFvDwkN/U15w4EN8QN7ACuS96uRgbjbnlvNITTOY5nNTDP+7LpEkxZrCGcbx3b0HfnarWpDflVH2mIkVrSekB0fVeSYaHdqOA9rHmeJx1uLB7VVXOh/vIeUO84yZ8wG/SxYO/qvbAshOD6b1M7XUct2O0FaHCwptr1wMzRGhRHDvYIMa6N5xSVHXW9euwXrG2v6BngzB+lPUq5OANTeH4sXaD9g/IgvjblJyJO9zTLciUF9zT8bCFrUXYsbtdSIwRM58hxstVv/IkCj+R4dJQpd/HyyYK8hhzlL/EfYCs6/jPZyIvAOGmP7Ad+N4a2uT3hxe/BELmnY/nNaWhW8F8BeZ9wOZQubC9/zs4qyQplrQ+FAH6GBkOKQ1DiCLnnXbog3SODUfb1oaOXFd+DtIN5SO/GX0d2cR+XcGp21bfeEeuuS+Ef1jGMSI14gpIY5hrSNSkc2Ivq/t6oC1ZDqHTjzfQB/3a9SDJFf/aOaGdPIDL47hkTY5pYCpXITcMsfWhxqzPumIWbi+mVkQmjCkb0dry/ansXfKUfkhQ0kPIS8lZN0brl933LCC17J9HMkyvwzaxoglXWjbyVZVkKWm2gdAou/a5zeGsjn0MDxhRxZ134BEkcplICXS1WkulVkm6OJhG88T/3bI2Eft62tWy8tCrzjKmjN+IdI6y+fSV
 iRZXs+j5
 Qwo6rAegenKBDC384X4aSGcDFnRI8e4KWY7zzcYnxADnDSDV8TM4qWaDL6Uw8uBz6dqkqK8DYhZ2J6ggXwRdAn3aSlUyeq5qy9rUTALiyfHIpTEn2qcBiLg565DkPotYslulHs4ggJDgNp+vqU8A0MH/38LXJUrDEktJsrdb/L9BKqHJVirORwABBWVQun0s6/QzN41D7IICY4DTY35WbYnpi+l9u+IblkqDWrMVXUu12y7oPhg6EMPOMYJJLyr6FezmoXRwr5o4Bcxh8M3b6F7zvkC7pla+rtTzYJwdVM6JOuxbQ4zgU0EqP5PueVzEfFj8/2AM0Mx0bm1TQVq4ftOIPeOi47JlID2Hhn/2zRcXc/j84NiSZhEHlswobaD9YUtR0fSnHyrNSSwgE/9UMBZH+KQJfpH2pwm3iHphzarITFVmK3boGnzmVdCydCdJh4nSpqfVpPZjtefaRWbLGDXrAjQ==
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


