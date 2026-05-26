Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06AEECD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002C56B00D1; Tue, 26 May 2026 10:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D1C6B00D3; Tue, 26 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B146B00D5; Tue, 26 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA6D36B00D3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 848E51C02B4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:21 +0000 (UTC)
X-FDA: 84809871762.03.F7264BD
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2628740011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kiqwDBz3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nT3Zd6oOPYEtjshdg1Bk0FOHwde3zTVY8ceQsnwsZdM=;
	b=bQAye1fdJbylSLstuk0Xa+DfOHhEtHAZOLpSxhy5d9g+1iy4hO1/h//kl6ktIebh4G6VPE
	iR5QyT/irTclTHL7T0gWEWmibw9MDG+Z2D7eut7V4girqFNiqXH2gt5ciQ5P3udRnOidTm
	eBJ9KqJtTJKkHXdHers3lZJ326c3Wrc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=kiqwDBz3;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807379; a=rsa-sha256;
	cv=none;
	b=IQMUUpLCcwwz4KTcUuWOQ4+NFAt678xk1AzX4jNyIptbqvW7BgqpnCq+m8w0iILQMG9oiW
	qEqYmmYJMzgQ5atCgnD7ceV+rm8aY8jOGzSg7as0+HJhMGup4OwvOZF2KCLmHB2X7rjTCy
	p5a3oZ+Sw9LoA3H79YNZn96+8OF+WOY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nT3Zd6oOPYEtjshdg1Bk0FOHwde3zTVY8ceQsnwsZdM=;
	b=kiqwDBz3UikJUKIHkaYsAJ3cG32hv5EY3xJjeU+J40+ELgW9Gb+SQrETtISNH2oxuiGlNE9zz
	zUXZE7m8QkjMeJKNROiCtDM8044dorM/6NK6IOzokAXdK6TMSsdxhi4dc1/jP9v0T4Rd/2wRjw7
	5+jNMqmxHKWukUuVyrcGCkQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gPwbb0n0Hz12LJv;
	Tue, 26 May 2026 22:48:11 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F95740571;
	Tue, 26 May 2026 22:56:11 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:09 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 1/7] x86/mm: use PTE-level pgprot for huge PFN helpers
Date: Tue, 26 May 2026 22:49:57 +0800
Message-ID: <20260526145003.88445-2-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2628740011
X-Stat-Signature: qn8c85ys3k3diy91ccpz15p8fnkgg5uq
X-Rspam-User: 
X-HE-Tag: 1779807378-434178
X-HE-Meta: U2FsdGVkX1/xSMpyzwer3Jsvj2PvBJBHBrAdAigwbB/a1Fw/n8i6I7jM6aFvlhr99RAUI5fyOiza94m8E921Gfe6GtXtFYSiN3NdPrvAy5xD9xsC7HmY7xWLP/ZWw5LoIMRDbio4Go5u6Md3vdQzcMg+Pi03lChAUoubaLoud3ErI4O1w7Fi2qE0e0h5HHSTOkgDtJSAmsRaneXKmQ8xyoydDSRtIa5qsx5jMYAQmop+yd7jlZjgjOZG1XMhh3YIxVn/CFgSyPWUnsja0Za7U2GjhU/YhIvEWYVwl6JJJ4gmpZkI0qqvUo73cWFh2aT4ik+Pi7AsFNE9lPLtTwwPsADF4VDuwIZRh1MGHedmtbU8LxLTFO6MsQuTSv84i+C/LaCYtb76pXF4F/MowzZANoPa9WlyMzCm2mqHyZxjtjdrYM17HxAXWR56V5oxKsNcJAj8rO9UGvB5GeK/GUrsjALipgL8q2Bl2Q2dFv5Uydn4Nmzj7GKirf3ZoMl8+PN31bld9qI5qItUz9VncrklOmhaOoU6mPaeXvUVQMoZ1XO/bFal3BDirQfbJXeGL/l7xdJ+vOdIUNj6m7flD7ATbZ6EgmILKbI3/xsss0P57POCDx//ECQlDMXM5h54SQEMVQIJKqY+WjvEpB8w7NWc4MsNpuJb/wrycpwa78edrQ3fr3oqRtv5HC7saLR0wgmps4E7UnZaqYP/TWirgBotnRPJFOSaELRrHFuti5UyMeMtgT5m6jWcQmpYjFQfxGYOeJlh9KyZKsozt8K+yJA+bM6VIlcQK3xng+Bg/n0GBbKdCpYuLj/pdTwl7JX+DLswppkKBmvl1lbvuTvfOsoCpWgAmNeUxcZo6AQ4PvgS2vsUcbS4ljImY87tKdYKj1elYjsusHPoJpOjZdBTf1LKaE+2ZULulBmrJ47CkONvW27AUlxxhmFWJw6gc9z4dU1jFnYAyUoON3CVaW+4IHV
 A0xOaNg8
 uQY+vR21GR38852WS4Pp92vOuVQ9tgXyc9eCBrTJmEAMeioThXUMUaVuto3WcExF5y4AS6Y3Xe9v/A3AYW0Xim321wErxQrjAM4MCPY8Fj04usMRLrJw+bzjDq0xZcsZAvBeXsxOodqn5ckezC+dEYQ4ggmFLk7qsfczxCka9qCx8wb+UlLGoTqZ7DRNhLAlxAB7EbyGutHKoYNXmvETQv3ndR/bXyCzczw68CziPe55L3vhBiFyzAoLKZl/oWPGmSbpLrZ0Ipcr3zg7xNvHkxIZIRrhySklUX5qgVgUgrwgYoeVj+6vjHtb3WfjJKUA39l4NASx+7LQoeSBmJ0wjMva52L9EFbj9rKRqib+Bu2rOm5va3RikMSjBaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make the x86 PMD/PUD PFN helpers use PTE-level pgprot_t as the basic
format.

pfn_pmd() and pfn_pud() now translate PTE-level attributes into
large-page entries, including the x86 PAT/PSE encoding. pmd_pgprot()
and pud_pgprot() translate large-page attributes back to PTE-level
pgprot_t, hiding _PAGE_PSE and converting large-page PAT encoding back
to the PTE PAT position.

Rework pmd_mkinvalid() and pud_mkinvalid() to use the same helpers:
extract a PTE-level pgprot_t with pmd_pgprot()/pud_pgprot(), clear
PRESENT/PROTNONE, and rebuild the PMD/PUD entry with
pfn_pmd()/pfn_pud().

The old explicit huge pgprot conversion helpers are no longer needed.
Remove pte_clrhuge(), pgprot_large_2_4k(), pgprot_4k_2_large(),
PAGE_KERNEL_LARGE and PAGE_KERNEL_LARGE_EXEC, and update x86 callers to
construct PMD/PUD entries through the normal PFN helpers.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 arch/x86/include/asm/pgtable.h       | 68 +++++++++++++++++++---------
 arch/x86/include/asm/pgtable_types.h | 12 +----
 arch/x86/mm/init_32.c                |  8 ++--
 arch/x86/mm/init_64.c                | 30 ++++--------
 arch/x86/mm/pat/set_memory.c         | 51 ++++++---------------
 arch/x86/mm/pgtable.c                |  8 +---
 arch/x86/power/hibernate_32.c        |  6 +--
 7 files changed, 77 insertions(+), 106 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2edd6c9d789c..fe63a2f6d183 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -475,11 +475,6 @@ static inline pte_t pte_mkhuge(pte_t pte)
 	return pte_set_flags(pte, _PAGE_PSE);
 }
 
-static inline pte_t pte_clrhuge(pte_t pte)
-{
-	return pte_clear_flags(pte, _PAGE_PSE);
-}
-
 static inline pte_t pte_mkglobal(pte_t pte)
 {
 	return pte_set_flags(pte, _PAGE_GLOBAL);
@@ -741,29 +736,31 @@ static inline pte_t pfn_pte(unsigned long page_nr, pgprot_t pgprot)
 static inline pmd_t pfn_pmd(unsigned long page_nr, pgprot_t pgprot)
 {
 	phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
-	pfn ^= protnone_mask(pgprot_val(pgprot));
+	pgprotval_t protval = protval_4k_2_large(pgprot_val(pgprot));
+
+	protval = check_pgprot(__pgprot(protval));
+	if (protval)
+		protval |= _PAGE_PSE;
+
+	pfn ^= protnone_mask(protval);
 	pfn &= PHYSICAL_PMD_PAGE_MASK;
-	return __pmd(pfn | check_pgprot(pgprot));
+
+	return __pmd(pfn | protval);
 }
 
 static inline pud_t pfn_pud(unsigned long page_nr, pgprot_t pgprot)
 {
 	phys_addr_t pfn = (phys_addr_t)page_nr << PAGE_SHIFT;
-	pfn ^= protnone_mask(pgprot_val(pgprot));
-	pfn &= PHYSICAL_PUD_PAGE_MASK;
-	return __pud(pfn | check_pgprot(pgprot));
-}
+	pgprotval_t protval = protval_4k_2_large(pgprot_val(pgprot));
 
-static inline pmd_t pmd_mkinvalid(pmd_t pmd)
-{
-	return pfn_pmd(pmd_pfn(pmd),
-		      __pgprot(pmd_flags(pmd) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
-}
+	protval = check_pgprot(__pgprot(protval));
+	if (protval)
+		protval |= _PAGE_PSE;
 
-static inline pud_t pud_mkinvalid(pud_t pud)
-{
-	return pfn_pud(pud_pfn(pud),
-		       __pgprot(pud_flags(pud) & ~(_PAGE_PRESENT|_PAGE_PROTNONE)));
+	pfn ^= protnone_mask(protval);
+	pfn &= PHYSICAL_PUD_PAGE_MASK;
+
+	return __pud(pfn | protval);
 }
 
 static inline u64 flip_protnone_guard(u64 oldval, u64 val, u64 mask);
@@ -860,10 +857,37 @@ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
 }
 
 #define pte_pgprot(x) __pgprot(pte_flags(x))
-#define pmd_pgprot(x) __pgprot(pmd_flags(x))
-#define pud_pgprot(x) __pgprot(pud_flags(x))
+static inline pgprot_t pmd_pgprot(pmd_t pmd)
+{
+	return __pgprot(protval_large_2_4k(pmd_flags(pmd)));
+}
+
+#define pmd_pgprot pmd_pgprot
+
+static inline pgprot_t pud_pgprot(pud_t pud)
+{
+	return __pgprot(protval_large_2_4k(pud_flags(pud)));
+}
+
+#define pud_pgprot pud_pgprot
 #define p4d_pgprot(x) __pgprot(p4d_flags(x))
 
+static inline pmd_t pmd_mkinvalid(pmd_t pmd)
+{
+	pgprot_t prot = pmd_pgprot(pmd);
+
+	pgprot_val(prot) &= ~(_PAGE_PRESENT | _PAGE_PROTNONE);
+	return pfn_pmd(pmd_pfn(pmd), prot);
+}
+
+static inline pud_t pud_mkinvalid(pud_t pud)
+{
+	pgprot_t prot = pud_pgprot(pud);
+
+	pgprot_val(prot) &= ~(_PAGE_PRESENT | _PAGE_PROTNONE);
+	return pfn_pud(pud_pfn(pud), prot);
+}
+
 #define canon_pgprot(p) __pgprot(massage_pgprot(p))
 
 static inline int is_new_memtype_allowed(u64 paddr, unsigned long size,
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 2ec250ba467e..135f6f1f826c 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -251,8 +251,6 @@ enum page_cache_mode {
 #define PAGE_KERNEL_EXEC_NOENC	__pgprot_mask(__PAGE_KERNEL_EXEC       |    0)
 #define PAGE_KERNEL_ROX		__pgprot_mask(__PAGE_KERNEL_ROX        | _ENC)
 #define PAGE_KERNEL_NOCACHE	__pgprot_mask(__PAGE_KERNEL_NOCACHE    | _ENC)
-#define PAGE_KERNEL_LARGE	__pgprot_mask(__PAGE_KERNEL_LARGE      | _ENC)
-#define PAGE_KERNEL_LARGE_EXEC	__pgprot_mask(__PAGE_KERNEL_LARGE_EXEC | _ENC)
 #define PAGE_KERNEL_VVAR	__pgprot_mask(__PAGE_KERNEL_VVAR       | _ENC)
 
 #define PAGE_KERNEL_IO		__pgprot_mask(__PAGE_KERNEL_IO)
@@ -497,21 +495,13 @@ static inline pgprotval_t protval_4k_2_large(pgprotval_t val)
 	return (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
 		((val & _PAGE_PAT) << (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
 }
-static inline pgprot_t pgprot_4k_2_large(pgprot_t pgprot)
-{
-	return __pgprot(protval_4k_2_large(pgprot_val(pgprot)));
-}
+
 static inline pgprotval_t protval_large_2_4k(pgprotval_t val)
 {
 	return (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
 		((val & _PAGE_PAT_LARGE) >>
 		 (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
 }
-static inline pgprot_t pgprot_large_2_4k(pgprot_t pgprot)
-{
-	return __pgprot(protval_large_2_4k(pgprot_val(pgprot)));
-}
-
 
 typedef struct page *pgtable_t;
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 0908c44d51e6..3c2c0af5a2d2 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -311,14 +311,12 @@ kernel_physical_mapping_init(unsigned long start,
 			 */
 			if (use_pse) {
 				unsigned int addr2;
-				pgprot_t prot = PAGE_KERNEL_LARGE;
+				pgprot_t prot = PAGE_KERNEL;
 				/*
 				 * first pass will use the same initial
 				 * identity mapping attribute + _PAGE_PSE.
 				 */
-				pgprot_t init_prot =
-					__pgprot(PTE_IDENT_ATTR |
-						 _PAGE_PSE);
+				pgprot_t init_prot = __pgprot(PTE_IDENT_ATTR);
 
 				pfn &= PMD_MASK >> PAGE_SHIFT;
 				addr2 = (pfn + PTRS_PER_PTE-1) * PAGE_SIZE +
@@ -326,7 +324,7 @@ kernel_physical_mapping_init(unsigned long start,
 
 				if (is_x86_32_kernel_text(addr) ||
 				    is_x86_32_kernel_text(addr2))
-					prot = PAGE_KERNEL_LARGE_EXEC;
+					prot = PAGE_KERNEL_EXEC;
 
 				pages_2m++;
 				if (mapping_iter == 1)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 77b889b71cf3..9e83fac8df4e 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -90,13 +90,6 @@ DEFINE_ENTRY(pud, pud, init)
 DEFINE_ENTRY(pmd, pmd, init)
 DEFINE_ENTRY(pte, pte, init)
 
-static inline pgprot_t prot_sethuge(pgprot_t prot)
-{
-	WARN_ON_ONCE(pgprot_val(prot) & _PAGE_PAT);
-
-	return __pgprot(pgprot_val(prot) | _PAGE_PSE);
-}
-
 /*
  * NOTE: pagetable_init alloc all the fixmap pagetables contiguous on the
  * physical space so we can cache the place of the first one and move
@@ -390,8 +383,7 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 	pmd_t *pmd;
 	pgprot_t prot;
 
-	pgprot_val(prot) = pgprot_val(PAGE_KERNEL_LARGE) |
-		protval_4k_2_large(cachemode2protval(cache));
+	pgprot_val(prot) = pgprot_val(PAGE_KERNEL) | cachemode2protval(cache);
 	BUG_ON((phys & ~PMD_MASK) || (size & ~PMD_MASK));
 	for (; size; phys += PMD_SIZE, size -= PMD_SIZE) {
 		pgd = pgd_offset_k((unsigned long)__va(phys));
@@ -414,7 +406,7 @@ static void __init __init_extra_mapping(unsigned long phys, unsigned long size,
 		}
 		pmd = pmd_offset(pud, phys);
 		BUG_ON(!pmd_none(*pmd));
-		set_pmd(pmd, __pmd(phys | pgprot_val(prot)));
+		set_pmd(pmd, pfn_pmd(phys >> PAGE_SHIFT, prot));
 	}
 }
 
@@ -572,15 +564,13 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long paddr, unsigned long paddr_end,
 				paddr_last = paddr_next;
 				continue;
 			}
-			new_prot = pte_pgprot(pte_clrhuge(*(pte_t *)pmd));
+			new_prot = pmd_pgprot(*pmd);
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_2M)) {
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
-			set_pmd_init(pmd,
-				     pfn_pmd(paddr >> PAGE_SHIFT, prot_sethuge(prot)),
-				     init);
+			set_pmd_init(pmd, pfn_pmd(paddr >> PAGE_SHIFT, prot), init);
 			spin_unlock(&init_mm.page_table_lock);
 			paddr_last = paddr_next;
 			continue;
@@ -658,15 +648,13 @@ phys_pud_init(pud_t *pud_page, unsigned long paddr, unsigned long paddr_end,
 				paddr_last = paddr_next;
 				continue;
 			}
-			prot = pte_pgprot(pte_clrhuge(*(pte_t *)pud));
+			prot = pud_pgprot(*pud);
 		}
 
 		if (page_size_mask & (1<<PG_LEVEL_1G)) {
 			pages++;
 			spin_lock(&init_mm.page_table_lock);
-			set_pud_init(pud,
-				     pfn_pud(paddr >> PAGE_SHIFT, prot_sethuge(prot)),
-				     init);
+			set_pud_init(pud, pfn_pud(paddr >> PAGE_SHIFT, prot), init);
 			spin_unlock(&init_mm.page_table_lock);
 			paddr_last = paddr_next;
 			continue;
@@ -1519,11 +1507,9 @@ static int __meminitdata node_start;
 void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 			       unsigned long addr, unsigned long next)
 {
-	pte_t entry;
+	pmd_t entry = pfn_pmd(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL);
 
-	entry = pfn_pte(__pa(p) >> PAGE_SHIFT,
-			PAGE_KERNEL_LARGE);
-	set_pmd(pmd, __pmd(pte_val(entry)));
+	set_pmd(pmd, entry);
 
 	/* check to see if we have contiguous blocks */
 	if (p_end != p || node_start != node) {
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..a26b2397c4cf 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -971,25 +971,16 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
-	 * Convert protection attributes to 4k-format, as cpa->mask* are set
-	 * up accordingly.
+	 * Note that old_prot is already in the ideal 4k-format, so we can
+	 * directly apply cpa->mask* to it.
 	 */
 
-	/* Clear PSE (aka _PAGE_PAT) and move PAT bit to correct position */
-	req_prot = pgprot_large_2_4k(old_prot);
+	req_prot = old_prot;
 
 	pgprot_val(req_prot) &= ~pgprot_val(cpa->mask_clr);
 	pgprot_val(req_prot) |= pgprot_val(cpa->mask_set);
 
-	/*
-	 * req_prot is in format of 4k pages. It must be converted to large
-	 * page format: the caching mode includes the PAT bit located at
-	 * different bit positions in the two formats.
-	 */
-	req_prot = pgprot_4k_2_large(req_prot);
 	req_prot = pgprot_clear_protnone_bits(req_prot);
-	if (pgprot_val(req_prot) & _PAGE_PRESENT)
-		pgprot_val(req_prot) |= _PAGE_PSE;
 
 	/*
 	 * old_pfn points to the large page base pfn. So we need to add the
@@ -1065,7 +1056,10 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 		return 1;
 
 	/* All checks passed. Update the large page mapping. */
-	new_pte = pfn_pte(old_pfn, new_prot);
+	if (level == PG_LEVEL_2M)
+		new_pte = __pte(pmd_val(pfn_pmd(old_pfn, new_prot)));
+	else
+		new_pte = __pte(pud_val(pfn_pud(old_pfn, new_prot)));
 	__set_pmd_pte(kpte, address, new_pte);
 	cpa->flags |= CPA_FLUSHTLB;
 	cpa_inc_lp_preserved(level);
@@ -1120,7 +1114,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 	else
 		pr_warn_once("CPA: Cannot fixup static protections for PUD split\n");
 set:
-	set_pte(pte, pfn_pte(pfn, ref_prot));
+	if (size == PMD_SIZE)
+		set_pmd((pmd_t *)pte, pfn_pmd(pfn, ref_prot));
+	else
+		set_pte(pte, pfn_pte(pfn, ref_prot));
 }
 
 static int
@@ -1151,11 +1148,6 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	switch (level) {
 	case PG_LEVEL_2M:
 		ref_prot = pmd_pgprot(*(pmd_t *)kpte);
-		/*
-		 * Clear PSE (aka _PAGE_PAT) and move
-		 * PAT bit to correct position.
-		 */
-		ref_prot = pgprot_large_2_4k(ref_prot);
 		ref_pfn = pmd_pfn(*(pmd_t *)kpte);
 		lpaddr = address & PMD_MASK;
 		lpinc = PAGE_SIZE;
@@ -1167,13 +1159,6 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 		pfninc = PMD_SIZE >> PAGE_SHIFT;
 		lpaddr = address & PUD_MASK;
 		lpinc = PMD_SIZE;
-		/*
-		 * Clear the PSE flags if the PRESENT flag is not set
-		 * otherwise pmd_present() will return true even on a non
-		 * present pmd.
-		 */
-		if (!(pgprot_val(ref_prot) & _PAGE_PRESENT))
-			pgprot_val(ref_prot) &= ~_PAGE_PSE;
 		break;
 
 	default:
@@ -1289,8 +1274,7 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	old_pmd = *pmd;
 
 	/* Success: set up a large page */
-	pgprot = pgprot_4k_2_large(pte_pgprot(first));
-	pgprot_val(pgprot) |= _PAGE_PSE;
+	pgprot = pte_pgprot(first);
 	_pmd = pfn_pmd(pfn, pgprot);
 	set_pmd(pmd, _pmd);
 
@@ -1593,7 +1577,6 @@ static long populate_pmd(struct cpa_data *cpa,
 {
 	long cur_pages = 0;
 	pmd_t *pmd;
-	pgprot_t pmd_pgprot;
 
 	/*
 	 * Not on a 2M boundary?
@@ -1625,8 +1608,6 @@ static long populate_pmd(struct cpa_data *cpa,
 	if (num_pages == cur_pages)
 		return cur_pages;
 
-	pmd_pgprot = pgprot_4k_2_large(pgprot);
-
 	while (end - start >= PMD_SIZE) {
 
 		/*
@@ -1638,8 +1619,7 @@ static long populate_pmd(struct cpa_data *cpa,
 
 		pmd = pmd_offset(pud, start);
 
-		set_pmd(pmd, pmd_mkhuge(pfn_pmd(cpa->pfn,
-					canon_pgprot(pmd_pgprot))));
+		set_pmd(pmd, pfn_pmd(cpa->pfn, canon_pgprot(pgprot)));
 
 		start	  += PMD_SIZE;
 		cpa->pfn  += PMD_SIZE >> PAGE_SHIFT;
@@ -1667,7 +1647,6 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 	pud_t *pud;
 	unsigned long end;
 	long cur_pages = 0;
-	pgprot_t pud_pgprot;
 
 	end = start + (cpa->numpages << PAGE_SHIFT);
 
@@ -1705,14 +1684,12 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, p4d_t *p4d,
 		return cur_pages;
 
 	pud = pud_offset(p4d, start);
-	pud_pgprot = pgprot_4k_2_large(pgprot);
 
 	/*
 	 * Map everything starting from the Gb boundary, possibly with 1G pages
 	 */
 	while (boot_cpu_has(X86_FEATURE_GBPAGES) && end - start >= PUD_SIZE) {
-		set_pud(pud, pud_mkhuge(pfn_pud(cpa->pfn,
-				   canon_pgprot(pud_pgprot))));
+		set_pud(pud, pfn_pud(cpa->pfn, canon_pgprot(pgprot)));
 
 		start	  += PUD_SIZE;
 		cpa->pfn  += PUD_SIZE >> PAGE_SHIFT;
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index da7f0a03cf90..cd9a62f4d437 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -644,9 +644,7 @@ int pud_set_huge(pud_t *pud, phys_addr_t addr, pgprot_t prot)
 	if (pud_present(*pud) && !pud_leaf(*pud))
 		return 0;
 
-	set_pte((pte_t *)pud, pfn_pte(
-		(u64)addr >> PAGE_SHIFT,
-		__pgprot(protval_4k_2_large(pgprot_val(prot)) | _PAGE_PSE)));
+	set_pud(pud, pfn_pud((u64)addr >> PAGE_SHIFT, prot));
 
 	return 1;
 }
@@ -676,9 +674,7 @@ int pmd_set_huge(pmd_t *pmd, phys_addr_t addr, pgprot_t prot)
 	if (pmd_present(*pmd) && !pmd_leaf(*pmd))
 		return 0;
 
-	set_pte((pte_t *)pmd, pfn_pte(
-		(u64)addr >> PAGE_SHIFT,
-		__pgprot(protval_4k_2_large(pgprot_val(prot)) | _PAGE_PSE)));
+	set_pmd(pmd, pfn_pmd((u64)addr >> PAGE_SHIFT, prot));
 
 	return 1;
 }
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 223d5bca29b8..2f18f8223376 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -107,7 +107,7 @@ static int resume_physical_mapping_init(pgd_t *pgd_base)
 			 * NOTE: We can mark everything as executable here
 			 */
 			if (boot_cpu_has(X86_FEATURE_PSE)) {
-				set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_LARGE_EXEC));
+				set_pmd(pmd, pfn_pmd(pfn, PAGE_KERNEL_EXEC));
 				pfn += PTRS_PER_PTE;
 			} else {
 				pte_t *max_pte;
@@ -156,13 +156,13 @@ static int set_up_temporary_text_mapping(pgd_t *pgd_base)
 
 	if (boot_cpu_has(X86_FEATURE_PSE)) {
 		set_pmd(pmd + pmd_index(restore_jump_address),
-		__pmd((jump_address_phys & PMD_MASK) | pgprot_val(PAGE_KERNEL_LARGE_EXEC)));
+			pfn_pmd(jump_address_phys >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
 	} else {
 		pte = resume_one_page_table_init(pmd);
 		if (!pte)
 			return -ENOMEM;
 		set_pte(pte + pte_index(restore_jump_address),
-		__pte((jump_address_phys & PAGE_MASK) | pgprot_val(PAGE_KERNEL_EXEC)));
+			pfn_pte(jump_address_phys >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
 	}
 
 	return 0;
-- 
2.43.0


