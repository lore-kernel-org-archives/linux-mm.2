Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F19606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=h7bTPZW/
Received: by kanga.kvack.org (Postfix)
	id 5DE9E6B05B9; Thu, 12 Nov 2026 00:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58FB56B05BA; Thu, 12 Nov 2026 00:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409736B05BB; Thu, 12 Nov 2026 00:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05E646B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:15:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDFE14048F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:09 +0000 (UTC)
X-FDA: 85425303138.19.700F494
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf20.hostedemail.com (Postfix) with ESMTP id C28EB1C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:15:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="h7bTPZW/";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794460508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhZg2aD8gryvvLCiESPcOzSWP2UR5KQYTO3P8Tzsy+I=;
	b=0bKeUJv6lF0sUtLw74xEpoYo7Pfo1iGsPvi21cdf7DGvMySomlocF2x7dcqBbQBpga0YGt
	lam1uLhk1aAP8vbXYywCOBwYZ65CHCkZ5x2493VWk45sL0cCYqDCU2OUd/SC9eOiQtkDm4
	iqP2phvQNfN+rooSGpL980KCpHr3qew=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="h7bTPZW/";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794460508;
	b=PY3NvrYznJl0pygP226tlQi7c+Po31YhwI5khbZzUUv3Ky2N8/S+m/yLo6NaV93N1sZkOk
	mfoUGtlY0QOjAmnRHp0lhW/iGxMfMm+e1cYZ40IIxd8rXjJboflY5hZBShANURrng4sgu+
	2VVChjlVPcaTRbgv4rBxLHMlJ8PdGdI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794460507; x=1825996507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jhZg2aD8gryvvLCiESPcOzSWP2UR5KQYTO3P8Tzsy+I=;
  b=h7bTPZW/oWZDWAaqhP4xayWzbPGRMBP5sYRKjfTzOjyGaz8mh39hMBCU
   thigIlSkotZiI9P/z7w2AbLjoO6rYx1huJZ2e8XDdY8tcZ9nkghZk97ll
   5n+c3Ad2gW/nBb3EUJMLlnguDdmvLhG3VWxc6Jo/pYM3GHNClvSdV2+YB
   Vg1Jp9Vhw8KrQgxmmRQdaB2YElGaQivOQslk0R6/4YZGJHkKxRtnL51i6
   /mv5E53RBRd4IgZz7BjdlGltl8l9Mzsvddx/ItU9yHZPAZAJ8+Ukmccvf
   RVoRB1ckdRbxFgBBMLU2BzNUnADK/wrW5Htlq/GFa33X9PO4t3IlvMAe8
   g==;
X-CSE-ConnectionGUID: u/5EmYrITY+5rEHpcvSW9A==
X-CSE-MsgGUID: el2/zWsiT1KgeBa9Juocew==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33650587"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 05:15:07 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:23490]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id d1a65dbb-a46b-46bc-bd0a-a5bc78964208; Thu, 12 Nov 2026 05:15:07 +0000 (UTC)
X-Farcaster-Flow-ID: d1a65dbb-a46b-46bc-bd0a-a5bc78964208
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 05:15:06 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Thu, 12 Nov 2026
 05:15:02 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>
CC: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>,
	"Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, Peter
 Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH v2 4/4] mm/huge_memory: use the large-page PAT encoding for huge pfn mappings
Date: Thu, 12 Nov 2026 05:14:40 +0000
Message-ID: <20261112051440.16140-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112051440.16140-1-farbere@amazon.com>
References: <20261112051440.16140-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC001.ant.amazon.com (10.13.139.241) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C28EB1C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: n4h41gbpjk3n3t3dbchb9yua7q6u4u1j
X-HE-Tag: 1794460507-378394
X-HE-Meta: U2FsdGVkX1+w4wUkHcAS1D+CNsGsmCt8SA+kTaUQp1RPPpPC+qI4sF1u/O8m6L8mB3bg9KHWbDB1Y5oAjUHy6hv7D3Dpo7v3vfWWkPkNeFvJwYXeUqRLm8CA6/ZCRaF4Mt6aB8uaoKpQ/xDgkCi9Hd3D7PPFCv04g2uEoqATOmiKuGV4C795V1VL8bP0tjulYXmEh9cG5GEAHxY44NjjITgSMzEzIBI7/wYXqWybykbrfTRpvFNIFjwKyBNyHWr5w+APBZJsT8vYSxFGtKXXMrVT6xr0Xshum6zWW6PKoam7hAFdFR4qb3meYgjL6SVdyw71/NoJMmeW5U4DyZiC13uYg5+FDbPg0S+BYIPzt/pNnjJU515YmYN6XTtOCYxQIa7JhTQ3W082Qsdza1ANoEHTJvO/ntDtAB4BJ+JQ4Nx8NAsXq+8CgcpwFVEpXwF8bq2nDO1fW24UJGBMXLanMZRqLretS3yFckYfbZ5zPvpnJPqsjy6atICfseI4kVPcor0HoFhhdGccsyMpoxbaALtXpU6XcfdvinOirQD0Yv+9RUDJIyebt59e9eRHQKJBOUWWjxAtlifcn+hf60kf7GdfSkE/vGwegJxprr4dsKgUpYsgk9DMAQwJYpbcfA8HtjVZzLTg2PrHF3IkuzXUJt6z4unnh1G49sDL93jCxhXwOgjtu9B3+DwakAK7x5YhNZATY1IK1mDvwntG1+KzFHxYPadKVzG9nvl3EgoSzKtj3kqxIkLbNVjgIqgxTgsLuDRgTTXx2R1/M0yOlcsG7f9mDEXyANpvdEj/rjGD6QXGjHsprN5nt1V5aOAftJZpl3zKMTT987aufe/yuzGsBeP/lvcqfJAfZ3foat7q1Tpl9YYXHpkJlTME/7d5D8z3gSs9JULxTLIyeVV2jDfgxT8SU7rCKdaq7qxRp0+Do973UJSUzvMOhlVNnT+B57p721FR4VgDh6u6f/8gm1k
 M1/Po2zQ
 DMA/jg98O0gDRYJ26CYnFf0Yj99HqtumcAZCAm4kO6jXABFkNxoDHlDqya3+thQWFEaKPQeJQqxVYR9S6S70NWujqfMUKAgQ/ksp6hLc8gpwqlumJWQZdMxmtuOOP1Yks2pjk8WL3ytUp4aeq0ccdjEIUfgP4pTw6JVG17XCnXv9gxRmyh8sb1K7+hKzMnYMcbKmKwUjOHtP77enJVdyQjbz5GdBHTUQ+Cb7MyIFXzuW9+Hvj2hbclpov6uGf67jAGUvWBWushZNSZZqTn5sxD1MhP731fXdHJCRqa0h51DI0LGOlngl2UZ4UwR85FPZAVL9j44E/kgaw6iv5WqIUNnentUYJAnZnQ/StGOzFOXu06IOR/DHTXCTCHt3JHtqJi5eHgesSWIhViLJf+lN2gKZ2A+JJA0j1UblhqT8516CCV35q69qAhLiJs7dEasTiOv3T0rFaS9hy8vD9QeDWDeMyCZhv/igQWi03dsGdy+5QrvCrxl/NOD1bCQDR1NopC1Nb8pvRI5cygk8x4zooV5eAcE+pgcPCfyn1zGCy7hztH2mK9sLUfbXfzSWw8OEVyM1MZ4CGlRW3LtND1kq7gTsgav9pkauvkpylrzw9RskYXuBMqcdLlr/fZP5bTfH/fWCx+6gTMcLf2C5ClfjimOtX7HiOuNeOdKc3rQeIDy5c/Jxg1abgXGrp1vYIJNfOLMkZx2vgdnwjNbD2M40XP/UIK09jkcXnGbME9i5sOOayA7whm4/l0Hbnh7ZVH6r5w23bLsTJUCV6zukSrSKnklfCENMHKOE/3lNS+vQNN1U9ZFbkZ6sgtTh9wCjXv5Wmy5Qj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_pmd() and insert_pud() build the entry from the pgprot that
vmf_insert_pfn_pmd()/_pud() took from vma->vm_page_prot and passed
through pfnmap_setup_cachemode_pfn(). That pgprot carries the PTE-level
cache mode encoding, but x86 keeps the high PAT bit at bit 7 for a PTE
(_PAGE_BIT_PAT) and at bit 12 for a PMD or PUD (_PAGE_BIT_PAT_LARGE),
where bit 7 is _PAGE_PSE.

A memtype that needs that bit, write-through or write-protect, loses it:
the cache mode index of the huge entry drops from 4-7 to 0-3. With the
PAT slots Linux programs, write-through (slot 7) becomes UC (slot 3),
and write-protect (slot 5) becomes write-combining (slot 1), which loses
the write protection. The other x86 paths that build a large entry from
a PTE pgprot convert it first, see populate_pmd() and populate_pud().

Convert in the two huge pfn paths. Add a generic pgprot_4k_2_large()
that returns its argument unchanged, so that only architectures which
encode the levels differently have to define it, and x86's existing
definition is picked up.

The folio paths keep using vma->vm_page_prot as is. They map
struct-page-backed memory, which x86 maps write-back.

Fixes: 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()")
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
v2: Corrected the second paragraph of the commit message. It said a
    write-through range ends up write-back; with the PAT slots Linux
    programs, write-through (slot 7) ends up UC (slot 3) and
    write-protect (slot 5) ends up write-combining (slot 1).
    Changed Fixes: from 6857be5fecae to 5cad465d7fa6 ("mm: add
    vmf_insert_pfn_pmd()"), which is the commit that introduced the
    unconverted pgprot. Both pointed out by Jose A. Perez de Azpillaga.
    No code change.

 arch/x86/include/asm/pgtable_types.h | 2 ++
 include/linux/pgtable.h              | 9 +++++++++
 mm/huge_memory.c                     | 4 ++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index b1a669e775f4..b1ffd72e47ef 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -497,6 +497,8 @@ static inline pgprotval_t protval_4k_2_large(pgprotval_t val)
 	return (val & ~(_PAGE_PAT | _PAGE_PAT_LARGE)) |
 		((val & _PAGE_PAT) << (_PAGE_BIT_PAT_LARGE - _PAGE_BIT_PAT));
 }
+
+#define pgprot_4k_2_large pgprot_4k_2_large
 static inline pgprot_t pgprot_4k_2_large(pgprot_t pgprot)
 {
 	return __pgprot(protval_4k_2_large(pgprot_val(pgprot)));
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..112814d31f0c 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1787,6 +1787,15 @@ void arch_sync_kernel_mappings(unsigned long start, unsigned long end);
 #define pgprot_mhp(prot)	(prot)
 #endif
 
+/*
+ * Convert a pgprot built for a PTE so that it can be used in a PMD or PUD
+ * entry. Only needed on architectures that encode attributes differently
+ * between the levels; elsewhere the pgprot is used as is.
+ */
+#ifndef pgprot_4k_2_large
+#define pgprot_4k_2_large(prot)	(prot)
+#endif
+
 #ifdef CONFIG_MMU
 #ifndef pgprot_modify
 #define pgprot_modify pgprot_modify
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 052c50dadc48..945d480c1512 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1675,7 +1675,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
 		}
 	} else {
-		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
+		entry = pmd_mkhuge(pfn_pmd(fop.pfn, pgprot_4k_2_large(prot)));
 		entry = pmd_mkspecial(entry);
 	}
 	if (write) {
@@ -1804,7 +1804,7 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
 		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
 	} else {
-		entry = pud_mkhuge(pfn_pud(fop.pfn, prot));
+		entry = pud_mkhuge(pfn_pud(fop.pfn, pgprot_4k_2_large(prot)));
 		entry = pud_mkspecial(entry);
 	}
 	if (write) {
-- 
2.47.3


