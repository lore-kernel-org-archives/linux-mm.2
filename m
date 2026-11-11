Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44FF5606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=YKkvP8hW
Received: by kanga.kvack.org (Postfix)
	id 999636B05BC; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970646B05BD; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885E76B05BE; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6773D6B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:07:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 027DCA7AC8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:23 +0000 (UTC)
X-FDA: 85423015608.03.DED380B
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf30.hostedemail.com (Postfix) with ESMTP id C68468000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:07:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YKkvP8hW;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794406042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVZxSALvPLQtQckREU8FaHhYXclhVaj+hUxcL54vQWM=;
	b=BrzRN6whilNc/WG41BnLEnfAMPO3ZYH1HGccfLHFAqJIH4G2Vy/0dQQTavRg94dJgfI/OC
	IgO8czvLldoelFtG8UjfXcKMWCMDJxN82HUHas74NWUs90ChQIpzs8XURHlE+yX51Q7FAw
	Ti4av5Av7+e9bg/YY2Kq5os41vq72Go=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794406042;
	b=40XNIp7VSp1pRNBw5zemTygoFZ61Uca7FZKAgK2Bu2C9quCslEJYxqXCVifGzZql19HGow
	QB/8IFYpsKidzkZWrgjnvCNNupWwxF51wTkCIMGNeKqk20i4fl7lNefCMH5eI3+z1JPHNE
	0iQq6UkoFqwURfkalLyFqvyGvCdWPzo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=YKkvP8hW;
	spf=pass (imf30.hostedemail.com: domain of "prvs=768118434=farbere@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=768118434=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794406041; x=1825942041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lVZxSALvPLQtQckREU8FaHhYXclhVaj+hUxcL54vQWM=;
  b=YKkvP8hW51zAnDFH3IQhQOoqLRgfl7O3JDu0Uz+urb7aLM5V0oJySJ0W
   cEYI90WfAPKsVlRIjsdw/0EXXxUuVnAqcIwTyMnkI8GxWby4xpc44lmqB
   XbaUVBUH5lD9sIj3uPOsvkxbfB7sgxbbz/TcKvaKJiJdlQD9YO9/NFbCJ
   Ms1UoM9XYOoFu+bjUroOzzmPt8plW96xBVUCe5tkY7LLtTBYf8r5Qd23h
   zWrYBsdWlsOrOLZ2R+SBh5yS/GnLDfJ9za+KJCfwV9NJFZpCR5gIp8GM9
   aAdk/zzkM9m1YBcoiwNHAykBgktpz7xiWIHFs+3PgFjCmy8Dm9kiP68+z
   w==;
X-CSE-ConnectionGUID: NNXseI6hQE+s2IU6JgsNtg==
X-CSE-MsgGUID: f9zBXLSRSSC0WZyTNPcImA==
X-IronPort-AV: E=Sophos;i="6.27,207,1787011200"; 
   d="scan'208";a="33633315"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 14:07:21 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:24048]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id e6d02c34-35ef-4d4c-b7a9-eec495468fd7; Wed, 11 Nov 2026 14:07:21 +0000 (UTC)
X-Farcaster-Flow-ID: e6d02c34-35ef-4d4c-b7a9-eec495468fd7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 14:07:20 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56; Wed, 11 Nov 2026
 14:07:16 +0000
From: Eliav Farber <farbere@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, William Kucharski
	<william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, "Alex
 Williamson" <alex@shazbot.org>, Peter Xu <peterx@redhat.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Eliav Farber
	<farbere@amazon.com>
Subject: [PATCH 4/4] mm/huge_memory: use the large-page PAT encoding for huge pfn mappings
Date: Wed, 11 Nov 2026 14:06:55 +0000
Message-ID: <20261111140655.34281-5-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111140655.34281-1-farbere@amazon.com>
References: <20261111140655.34281-1-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: 8i6yh8besp1hrr5km3p68zqz7o3n1ky9
X-Rspamd-Queue-Id: C68468000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794406041-751947
X-HE-Meta: U2FsdGVkX18wge4xH+RtJGTEZV9cMFTeXj71bK5FwUM1lUMAfLTUKTnWHcg8Ka0yU8b9N9GSPPsLa1uikhHkbBPMlpWkkwIUZUH3IYhlY6k0cjcboATVoRSKdRewGdHS83KG5WINZQIZcxJ6HKcj/qnEaN1PaYyrZFpK/SZJCCgxVUE6dbv3ZgL87joBVqUuBmf/+W151NndQKsR2Qxg9LoSviivdn3UzEYo8mFjveoR5PByXS4UqUHoOMLYYqymjs9VQrX5fOmy0QJ2ahho26AVl9+MLFcDBhH8vouADcjEcoLoFs81PCswDURCy6m3+Q6M2TOd36dvmILiYGoKDSuRt8gD6JoRXglH/GGvUHRyPzv2va63rxupg6ghnkWKYg6MklERbukzgMGYms8PlMaxzl4A8ofoQXRdha2Nk+mjKmDajbW2xViC4xW/8eV3gCVYaFEudJaBpiDUAtQrK9eyFo2M3yaxs3zhOHkuTSBlCxd6x+HRvC/N6mZIGdlfWtnUgM/nTlAmRc82LnAfR5QH05a1wmeGoxcDFfVjGfCTLbgUqJLBRDPwRjOMJRDwH3W+zENwzEpj9INXNMkNB7tVKITicAKwXh9l6bNGhxfNHunyDWcJE73dVRawVx2Nt9RqBWTbg70QBLupcHqKAfF/4OZbtClP9OsYLYVoo2HQ0VzaahstxK0iBohXstjx4/o2NKy5wkQRt9cNw0yOYC4pi8bgIveElXfCpQN2afUMspmVObbEmsHSYugX3T2CeCaXDepcRIeifzOO6/Vnh6S6bgqWzIVWcU45nCnPFGpEwL/NciXNWfc8T4JJGQ38O7m4+wSyDSX14jgvlpfX++zbjp5jvrrGF7CLqHnQkuEn6V879Es1awnz2ARQWNDjPLHxSJJ8vntjxGwP/fqXfpHke70OiRQTpgJ1hlinDECLrVGL2vtpuQF9PSysdAZiWVYbGRUJ2sVAVCnk3an
 Q+HyEQYZ
 GIVHkLjmOpzK68zq7aBOAyyjyqC2J8aei2chpS/RdMEEdcn7SLEus9j9o+nGKeiE5AkrSuc050QirETgKtkc/HaahB7LV/Zm8z4uuJeBews3tBGii6lb00Zgs4hxU9bY2v+QFF+vbVdYCHp0CelSCRAp9wAOMnSRdQKSTAnISA6X1lEriyDmBjR7JGasMJ9NSpGjNYEdExVJJsk/Nuqq0CLdWwDSGkUCiVeY+Rmz1qmyShX8jrg0oW0QuOIRat//DL277ciL74uz6uZe/BNX8CbsWNT+KUs0enLbvFw62f2ZEK8crH5sVTEXJacpoDBS7HMu1JrSUFPoBXxsusX4fzTcWM+3QgHCIVbOyJBTLzRSe9viGHUJqKSHfeeF8gUAU5Hj8NlcaGbXytk18benAXSgZ6fgePfSAwiCnIlbcHw9jxPa00dPGdENM+kvrM/dGW/iorTm1/oE2vOHtE00TLyB3l0hOKtsNU2ZgcmG2Xg8NT3CO0CQXrlrzsQmWYqMKGtefKAsG7YuIMI+VcgMSlNSMxt25dr8z0OCspcbtbf3xFyJcATUfPiFIbE5aoW0NXSfydlUEbMcWgDMK2MMmLlvingiw7yA4rTgrRJNzQ4/luAUs6aCst99reBkO5pfs40PwXBhr0005LLFRTWNRC1N4cqCgUiVOQxYVGClFbUGwFcXJwLrlWxZOl1eCgrN7H1TpxcHgJMIhqHtgsFDaeLTK8cWSrIJDZxlqCW3us4tSRaf/Lpk00W3g++eAiOjBx9r5Nmr2VnWIv0C5kVzq1l/z/h6SaV+oIrBWY84+jYsT4BgftZFCRMzj4AZxsXoD0ShKXinwIZsTp9U=
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

A memtype that needs that bit, write-through or write-protected, loses
it: the cache mode index of the huge entry drops from 4-7 to 0-3, so a
write-through range is mapped write-back. The other x86 paths that build
a large entry from a PTE pgprot convert it first, see populate_pmd() and
populate_pud().

Convert in the two huge pfn paths. Add a generic pgprot_4k_2_large()
that returns its argument unchanged, so that only architectures which
encode the levels differently have to define it, and x86's existing
definition is picked up.

The folio paths keep using vma->vm_page_prot as is. They map
struct-page-backed memory, which x86 maps write-back.

Fixes: 6857be5fecae ("mm: introduce ARCH_SUPPORTS_HUGE_PFNMAP and special bits to pmd/pud")
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
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


