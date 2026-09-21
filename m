Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D018CC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE526B00D7; Mon, 21 Sep 2026 06:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC5A06B00FB; Mon, 21 Sep 2026 06:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBF06B00FC; Mon, 21 Sep 2026 06:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB8906B00D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 167D8C0122
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:25 +0000 (UTC)
X-FDA: 85237470570.13.57B0997
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 35B5114000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YL9DNg9T;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UI0DyYFBDaK0P9q8waY/uJmo2LsXGZ4CaPLuB4Y4DQ=;
	b=o8FCn+nq2G1lanpXdLhk72CU4JTtQmB/UMWi6T75GenEVzL5/netc1LcA/f4F1ZKqtqP3k
	9PZLqNwHp6XM1DD984mz+ZYcgaH8AKENHm0q6rjKjs/DBZ0yYOmsfWGJpezy73aEPoi4qY
	zjH6EVZzR2eMGcMvkSH0ZSLcL/OrNQk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YL9DNg9T;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988303;
	b=ZnooKVDbX6eGU140PG6B+Yd7HVyecboMQQPDN6mBR9MWeNOmenHw4SR6RUMQaajBXQbzZy
	XrdNxQCWd1reymjkvX7qDRND5xlWBHtHy7BiQBc4CX/l5du2RW4POzcVBEMXFbLyEMUxpd
	nOd44bN8sfuC9lWG+Z/SqtTEYIv6sNc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E11331CE0;
	Mon, 21 Sep 2026 03:58:18 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1D95E3F86C;
	Mon, 21 Sep 2026 03:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988302; bh=utmINuOW9x2oHy5QTeHH6EJ3UzwqSRAUlGRF/Q9Zr9w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=YL9DNg9TygaMLA+6ABmNi8Caz/etNmqKeQ4S1Php9cUgauo5VZuZq2oyMxzC1UnA3
	 sQjA6XjNfxb5Sfavvr4J5cPJV1ub4QtNsoXtsN7AYSIp8NmW+u+JOVu2sMIYjwVp23
	 5qp/anN+IE4UyqZMUn8TfJLXHPK8y+iHCUjHuDqo=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:37 +0100
Subject: [PATCH 15/21] x86: mm: carve out the generic compile-time folded
 pgtable case in effective_prot()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-15-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4850; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=utmINuOW9x2oHy5QTeHH6EJ3UzwqSRAUlGRF/Q9Zr9w=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1S1hUmFwKYutGjknVs3EfJa02hkOz1+sVrz
 Nt7e2HHFbCJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUgAKCRBt1cPRWsUx
 M4ztDACstHhQGkp2lzf026PXElKRVH5pN2UHEBDoHpCfhCT0PGU9NnuZhZ4adtSi0gmb5yJECZ+
 GJwBPGy8ePxuxh87ECWLBX0FJ3HavCpZueK6xmBzdPeUtKfsJ+49BCX8+mZUijeksVmy9e4lDGX
 xYw9+oFa7r13sh5Ve1eySb5C1oLRmI0rxEWdGkluXK8YtAgV6KVVpodhZxZ4Y3LV10HExieovQA
 F1WyaWAf37wnCFSeOSYHSbdY5kQZdJbO7ODSG2U50AzNysgh7GBxfnFg+bEp5gzwDHxgQvvi49Q
 hNNx9zmXTq8lHsglrmKuYgeGrc27jkQ8iUowCFifM36aAC2VHLbJSa47WoQYELvVOGSpPuprEWM
 K+dyIkb+rkTaK7e38jUgeDVeyWxsz/Lj47nH49SY+no5kMkhgzP6Xg0V91KzOtE9E6SjkOBKrQR
 UJkaJf7EfpBVXQb//klJUcVH3CXodhSHG82mUtLSBs2nPuDnzGtHIUFOZDCkY2Al/QA/4=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35B5114000E
X-Stat-Signature: kqggfmuxqjt4inxancdwa4yzs4w1it6z
X-Rspam-User: 
X-HE-Tag: 1789988303-312834
X-HE-Meta: U2FsdGVkX1+i4tevXxVUqTV8Rfo++VhUDlmQnWw8VcSIwMEUT3FxCR+k+oBqjHB7O7+rFUbCTcUPfC7YUWqVWIULMC2VIHRCLrzCFff4PyFv3ETN171Y1bLGRPBDaqjPITuoOx+wUNHS0kZebsbtKJG5vP3/Bd5FauQMRb6BpE4IVX9lvXrBBe/HhfNfHi5VL866VLbaRwpyizCBb2OvWDH/5kKeHWlHOd6HFWSnbGDnp6q5wWRii0kv1jRmAZf+ss3PiUN0/D2xkvMizjaCmDhZDLmu6SaUfAFDvoK4xg0JmtyVuG6i/1iBrFTmUEUCYgYIZIYzELZSsUf7p8RaLHYWlt+c4UviJWl3BKcWtcvtKWruxL6kZ7Fdoc9xslF8ARXTWJccEVkC38LoK5Om/1NHsvcT0elaHkgLpAxV0RT24ADJ7Pr+gVXzouOq0CNec6beImIOnUbSVEc0tdO36dgqrYGrzOyG962HaqKFOJk6ld8MYPRFsfm0f80VR7EubGe33TMwX60TeJ66ovvf1ezzKA7VEBk5bWJxFLY+W9OcJddaUZqNjomnp8QMASxcgVwkJdl4yQM7Ryt4E/ARP3qouP+K/AU7ccB5hGwrnc8dvjTo89RQklb9GS58C10QmF8YRA61amUjFcbwNLm75oSg1TEaD6FTyskZrak2ZGSx1sbBvnajEBjiJ/pITrT+/6pA/LNjpcqNLnioCiylzTtJtwxgi071wxanFx3i5nMoghleBA/GhpBI7oBzmUXlHVGrh6hrCWpADbf151F08IpzLbsA6OHVBUr0n2u/KoGhFXNjtEGZICVXUKb9JI7LxyqsuFWljDRtPf0Z09Fv6+s6TyOK6fo1BPLm8/qzuW0lZo8oWsVu49ju6kCb6SOXFILNt8kcSRBSu3BU0tK0ahzoK6fGcS5ByK/lQcpnR0zI7GEZiVd+5NvvHFTss+sV3khWWnHMjms07yS30Fw
 eoVzg71U
 unldOrZ0lmRdS7N/d99e5i3vI9uUIBEJJuJELT23/KH0sJzX64eR0CQTsnftg3HH77ZsnLDds2H/j1I/uZfaAP9jMbwDSHzWCP+MrdPTp5GVxdGAvodlTvyQE0ZgFtRUYHjaRt5/QGYuKwWg0lwzwEDEWQtDtTlsRGfDDMZZgohG4EzRDGiEbI5VPjVw/myLNRgyBslPQhlGkstcNGSDgfMpRYJXEYB4Q83ma3+Cch8hPTXZITBhSXrm6kG4rFP2mGzxGdlAGZI3fd6PtAti4yMPFfCjPF9o2haWyU5BC9pqS1bUuTlEUAQHfLjrIj11sZvnGSCYoz04fP+ldYnRA2crPRULhekUjLDWl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXdp_get() will change with generic compile-time folded
page tables. To prepare for that, rework effective_prot() to ignore any
folded page tables entries, as it will unconditionally get called by
ptdump core with pXd_val(pXdp_get()), and the value for folded entries
really should be ignored.

For this, introduce mm_first_pgtable_level() to identify the first real
page-table level, move mm_pXd_folded() in !__ASSEMBLER__ and
update effective_prot with higher_prot only when the current entry is not
folded nor the first level.

There should be no functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/dump_pagetables.c |  6 +++--
 include/linux/pgtable.h       | 61 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index a18a61e732c3d..2acbe41eb58f2 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -38,6 +38,7 @@ struct pg_state {
 	bool check_wx;
 	unsigned long wx_pages;
 	struct seq_file *seq;
+	struct mm_struct *mm;
 };
 
 struct addr_marker {
@@ -254,7 +255,7 @@ static void effective_prot(struct ptdump_state *pt_st, enum pgtable_level level,
 	pgprotval_t prot = val & PTE_FLAGS_MASK;
 	pgprotval_t effective;
 
-	if (level > PGTABLE_LEVEL_PGD) {
+	if (level > mm_first_pgtable_level(st->mm)) {
 		pgprotval_t higher_prot = st->prot_levels[level - 1];
 
 		effective = (higher_prot & prot & (_PAGE_USER | _PAGE_RW)) |
@@ -452,7 +453,8 @@ bool ptdump_walk_pgd_level_core(struct seq_file *m,
 		.level = -1,
 		.to_dmesg	= dmesg,
 		.check_wx	= checkwx,
-		.seq		= m
+		.seq		= m,
+		.mm		= mm,
 	};
 
 	ptdump_walk_pgd(&st.ptdump, mm, pgd);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 3186096a6e130..ed7101a13ce9c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -392,6 +392,22 @@ static inline void lazy_mmu_mode_pause(void) {}
 static inline void lazy_mmu_mode_resume(void) {}
 #endif
 
+/*
+ * On some architectures it depends on the mm if the p4d/pud or pmd
+ * layer of the page table hierarchy is folded or not.
+ */
+#ifndef mm_p4d_folded
+#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
+#endif
+
+#ifndef mm_pud_folded
+#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
+#endif
+
+#ifndef mm_pmd_folded
+#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
+#endif
+
 #ifndef pte_batch_hint
 /**
  * pte_batch_hint - Number of pages that can be added to batch without scanning.
@@ -2313,6 +2329,36 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
 	}
 }
 
+#ifdef CONFIG_MMU
+/**
+ * mm_first_pgtable_level - return the first non-folded page-table level
+ * @mm: The mm structure.
+ *
+ * With runtime- or compile-time folded page tables, page-table walkers
+ * effectively skip the folded top-level page tables, treating them as
+ * always-present entries pointing to the next lower-level page table.
+ *
+ * Return the first page-table level in @mm that is not folded.
+ *
+ * Return: the first non-folded page-table level.
+ */
+static inline enum pgtable_level mm_first_pgtable_level(struct mm_struct *mm)
+{
+	/*
+	 * "PMD folded" actually means "PMD is folded into PUD", and
+	 * pud_present() etc. are hard-coded to look like present page table
+	 * levels, whereby pmd_present() etc. contain real logic.
+	 */
+	if (mm_pmd_folded(mm))
+		return PGTABLE_LEVEL_PMD;
+	if (mm_pud_folded(mm))
+		return PGTABLE_LEVEL_PUD;
+	if (mm_p4d_folded(mm))
+		return PGTABLE_LEVEL_P4D;
+	return PGTABLE_LEVEL_PGD;
+}
+#endif /* CONFIG_MMU */
+
 void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size);
 
 #define ptval_to_str(buf, val)								\
@@ -2349,21 +2395,6 @@ void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_
 #ifndef has_transparent_pud_hugepage
 #define has_transparent_pud_hugepage() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
 #endif
-/*
- * On some architectures it depends on the mm if the p4d/pud or pmd
- * layer of the page table hierarchy is folded or not.
- */
-#ifndef mm_p4d_folded
-#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
-#endif
-
-#ifndef mm_pud_folded
-#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
-#endif
-
-#ifndef mm_pmd_folded
-#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
-#endif
 
 #ifndef p4d_offset_lockless
 #define p4d_offset_lockless(pgdp, pgd, address) p4d_offset(&(pgd), address)

-- 
2.43.0


