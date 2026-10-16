Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66227CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 12:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59CC46B00A4; Fri, 16 Oct 2026 08:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575BC6B00A5; Fri, 16 Oct 2026 08:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463286B00A6; Fri, 16 Oct 2026 08:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 135566B00A4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 08:17:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9902C1A03D8
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:14 +0000 (UTC)
X-FDA: 85328389188.14.28052D3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id C600A120005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:17:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WAgaUL+g;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792153032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROmo/VbuKtcX0poOX7UbrOJdgEcyV6UWD4h0M1KsHMY=;
	b=cntxX04J3Z/hH4JhNVQtANXoZM3vm7fs5gcWc6xY92Zymwg12HWkUGdM5R9h5EXZGUFnsh
	jwo035b7B/2peGHOd9seu29uHwrLmmOtwulT0zAwmN9r6QZ2FPypimBUababRBnRm5xydS
	OJ0zJO2wOR0mhfVfFaNHGECsVXzD4QM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=WAgaUL+g;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792153032;
	b=IVCGRfcr3eIemVRqRj4eMrwwnU3Srtf2EuSkezJ9r7peO4wpUM3XnDJqmC2WwBUoWUb5Yk
	SdIyMt9zGhkf/zDGV1zAep4gC21AcEuCIIjAHwbW8Wrm8lcRkZ0CmW4mEkSfKxVEbi0hSW
	8lAGOmkIZPBe33lxzTUQqywIGd281SA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ROmo/VbuKtcX0poOX7UbrOJdgEcyV6UWD4h0M1KsHMY=; b=WAgaUL+grMEMT1FcLzjc197iQO
	HoDsSJltoVCJBeo1Ik4GbA0vgHQhdZu4pmHBOSmnbEt/NOduNTa4BeP8SJUrvwvpxuo+h2IdiTcxU
	KTesb5f8u7Oa3CFOLFq/MrBj5MsKn2O1qS6iPkAqQJmli2jOoQS8WXJ9YP+Cn5X9IA98tHCM1V+8q
	b7a0P5onSnBYTfuN43gPO7fTanUXllAYO7YKyRwcuT2g/mepu7ih5IM9A3Dy5SGwDqA3zYdgrHw04
	bl/U11WdtD0uog/w1Qz9C2TP07ar74x5CSqKgMC9+39c8umLtz3covUM28HgmClBHv2Ls0kMpJbe/
	6KOJXsmg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xHgrj-005xUr-1W;
	Fri, 16 Oct 2026 12:16:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 16 Oct 2026 05:15:47 -0700
Subject: [PATCH v6 7/7] mm/memory-failure: efi: record hardware-poisoned
 frames into the poisoned-memory table
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-hwpoison-kho-v6-7-f304255147da@debian.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
In-Reply-To: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
 kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 shakeel.butt@linux.dev
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, 
 Breno Leitao <leitao@debian.org>, harry@kernel.org, kernel-team@meta.com
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=11890; i=leitao@debian.org;
 h=from:subject:message-id; bh=SBhhKTkaRHyX1GAyy8PMkoGcpH3NzvKmmkEdQFwHE8s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBq0hV0tzL5+ezl9xhLzUMq3OAEA0tEafBgnFPDw
 FdZN1Pwoa2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCatIVdAAKCRA1o5Of/Hh3
 bQdUEACA8Y5MRXLL76J6ikzWB06LLym/d6Sp/ikm9MYeKBLAF5+R3EjkkeBMe/vkD9xmK0bsyx1
 I2q+OKhauwGst628sANSviBUe4vlMSrGZt+pg4sDJLSRTBW2Ia4jmvQgap3ObO0uhjaauzdPoLd
 gbxOvcuFHFK2TX+8rZKTvzjhzN/MHLfC3EzzFEE5U79Cy1Xh9tMDKBVN5KsHCdEtnfj6jy1JfGz
 HaFn35nDfiSf9Xthwwz/ychaOzIKnxjd0Ge3FWOifdK1Emt1Mt756aSl7Yn/IORTwnbDwiwedyu
 K6ujSdgEqLZQphEWIsYgTSIjrQ5ML8+gT8Ge7LsX9upac0UIrDnMBDUwBgO52krW99mFQYtGv0z
 mdFlzjkE63f8AOO5F0IN9A7p5ze2f057llFvNwJjjlsjZeDa/UPUS7zUM1H3qeJNm9uXV1EIe4U
 hwlFQshDfusCAFV4Fon2Xk/YHyu8uDfk2A5fPhxOPPKjwvDMCGjxp+xqMsxQpgGl02meVqst9Rw
 36tcqCDyFv3+0gVrDFVRvpduKPFrH6pYJsx1NNRamSD4b+ZAHlLGcIdOX4LwPJe1V61YwN+E55u
 jGvquIXgFR37DW3YdP8W/vaUD5l7gXtny2tpS+AoKg6Q1tdwKfF3cH+82qWzu9oRfPK3Hzq3osY
 lEYVFJgq/ZLtDZg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C600A120005
X-Stat-Signature: efbdkdzabnkmi48rouh4db3qx43bfyxq
X-HE-Tag: 1792153032-589128
X-HE-Meta: U2FsdGVkX18qu6STXJ5N8rBDFW/9Kf8zXrOoM5znQCCUYRK9GdHKMMypX976D4hp+Lp1qO2J1JrNxStbNcx//ufGiozniM6vj6lvqegfcPf84+KjmHo3pdV6uSZLLHDpApuof2xRING2WSCCnrAr/i44E2uGLAtXiV3h9FxJumTlACTtjn7ozAgKmREvspb2ru0upHsBPfcuZ1YkbU2p6Tx2+XFk1zVwHPSenHF+1I4Op4oJjYDel5/rq/0ps1DnVCdAoS9hsGOxkvRLvsD5FtOtlc/9ubHNyTAAopRDXvS0h4tC+CGKgPmbQb6tpNUf8ER9YDZnbz4n3Oy+r4QWFoY3UnLsZmLum3ASTl37V7muL93X57o+OihsNNY5i3Gfho7juF3H7E8SWc6mgDmKywvqSWjP4UNO0kNGtF1zsuiiN/ztd9JBPZgJENn3M+YauHnkHc6Agodkpa6MG2pMInFdWJkp+Wa30wHZ/EoNNvrFqBdqljlkBBBCtynK7iAPHQW+vhnduol7IMO6btiWFgO2RsnkXU3rR7cDDhVlGrTD7J5MES/CqMmdX48TS3U7dxGVdcTnepcFse2Aa2S450kUNVxtNoht/GNluyo7amS2C/e2xWRyTfeVwDUM0zcLlVGuIGv7DUtKLaz+hYPZnaH+1qnivcjbkfi2bfe0lgI7coY3kVCke8N3feNeLmALlSpxebyQCL7xl9wX671OcTPbjSsat/OlWrTP6ApwAIKikQAQRMcXHAVm38/Q1an5t/suDY+z8qUKi27hiDRdmBNmjEVYls84KHgIdwJfEcPf9Fj49CZmTvHlaCM8wHzqlovsuDImi1C55HzBUzFMUtqVF5fAXzFaeCyyHoKKPJi3fPI1F2ZSK7QT2BFICHDA9ylprrMoRwib5QVTnlbeXcCBRUqhalxcbS8nrlzWUdIc+URoRPKd+VfOIZERR7NjQZNWjR7Vogkeiyfd4eX
 YxT6a5yT
 q2Aw3RMtxWH/xGQS6U0G+FMNFFTP9hcan036+Fxjn3xCCCUaNnlefIl9uDdyUf2WNSUSXZEimvWiSAd6LIAgxgtrBgYkjrWiheHI3UaeKAaxaRJtFMZHEICUYkcvdNDZQOEjWjAvTM+SjPbJvgsiquzl5izJMNsg6qk3A4bJ4v508HGSsF21wMnYEXbsPOUgN1HwcUJr9lbIT9eGZLvc3nUdVhgYy770B3MgrvQUx2dpbG04pC9J9CyKGKJqsWuWMbhUwaCXolGy3AJg3OkF5R2Gfo3eupom8UlcK5t6qI3S6JDId2Bg9q9VvaH0xx9vc2DPRtXcWcDHG/aH5bsDE1Xk7U6C3hJDC1900SjwkcB9Seko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory_failure() reports the outcome of a hard offline, set the
frame's bit in the LINUX_EFI_POISONED_MEMORY bitmap, so that the next
kernel reserves its unit.

Hook action_result() ahead of the statistics guard. A hard error on a
frame that was soft-offlined earlier comes in as MF_MSG_ALREADY_POISONED,
which skips the statistics, but it is a real failure and has to be
recorded. MF_MSG_PFN_MAP is left out, as it is not System RAM.

A bit is only ever set, never cleared (for now). Several frames share
a bit, and an unpoison cannot tell whether the unit as a whole is good
again. That is a known limitation.

The table is mapped with memremap() from an early_initcall rather than
through the direct map. On arm64, mem= and the usable memory range of a
crash kernel trim memblock, which drops the table's pages from the direct
map, and the first recorded error then faults.

Recording is skipped on a host with SME active. The stub writes the table
in the clear, so reading it back there needs a decrypted mapping. That is
left for a follow up.

memory_failure() has already taken the frame out of this kernel's
allocator, so only the cross-kexec record happens here.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/firmware/efi/poison.c | 69 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h           |  2 ++
 mm/memory-failure.c           | 53 ++++++++++++++++++---------------
 3 files changed, 101 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efi/poison.c b/drivers/firmware/efi/poison.c
index fa84df55aeb469..4bb56865551224 100644
--- a/drivers/firmware/efi/poison.c
+++ b/drivers/firmware/efi/poison.c
@@ -11,12 +11,14 @@
 #define pr_fmt(fmt) "efi: " fmt
 
 #include <linux/bitmap.h>
+#include <linux/cc_platform.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/mm.h>
 #include <linux/overflow.h>
+#include <linux/uaccess.h>
 
 static bool __init
 efi_poison_geometry_valid(const struct linux_efi_poisoned_memory *pm)
@@ -172,3 +174,70 @@ void __init efi_poisoned_memory_reserve_units(void)
 
 	efi_poison_reserve_units(efi.poisoned_memory, &efi_poison_hdr);
 }
+
+static struct linux_efi_poisoned_memory *efi_poison_table __ro_after_init;
+
+static bool __init efi_poison_mapped(const void *map, size_t len)
+{
+	const void *end = map + len;
+	const void *p;
+	u64 val;
+
+	for (p = map; p < end; p = PTR_ALIGN_DOWN(p, PAGE_SIZE) + PAGE_SIZE)
+		if (copy_from_kernel_nofault(&val, p, sizeof(val)))
+			return false;
+
+	return true;
+}
+
+static int __init efi_poisoned_memory_map(void)
+{
+	struct linux_efi_poisoned_memory *hdr, *table = NULL;
+	size_t len = 0;
+
+	if (efi.poisoned_memory == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	/*
+	 * The stub writes the table in the clear, so an SME host needs a
+	 * decrypted mapping. Skip such hosts for now.
+	 */
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT)) {
+		pr_warn("SME is active, poisoned frames are not recorded\n");
+		return 0;
+	}
+
+	hdr = memremap(efi.poisoned_memory, sizeof(*hdr), MEMREMAP_WB);
+	if (hdr) {
+		if (efi_poison_mapped(hdr, sizeof(*hdr)))
+			len = sizeof(*hdr) + hdr->size;
+		memunmap(hdr);
+		if (len)
+			table = memremap(efi.poisoned_memory, len, MEMREMAP_WB);
+	}
+	if (table && !efi_poison_mapped(table, len)) {
+		memunmap(table);
+		table = NULL;
+	}
+	if (!table)
+		pr_warn("Could not map poisoned-memory table, poisoned frames are not recorded\n");
+	efi_poison_table = table;
+
+	return 0;
+}
+early_initcall(efi_poisoned_memory_map);
+
+void efi_hwpoison_record_pfn(unsigned long pfn)
+{
+	struct linux_efi_poisoned_memory *pm = efi_poison_table;
+	phys_addr_t addr = PFN_PHYS(pfn);
+	u64 unit;
+
+	if (!pm || addr < pm->phys_base)
+		return;
+
+	/* unit is the bit we are going to set in the bitmap */
+	unit = (addr - pm->phys_base) / pm->unit_size;
+	if (unit < pm->size * BITS_PER_BYTE)
+		set_bit(unit, pm->bitmap);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 396e0d61112205..259e64467ed1ba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1289,9 +1289,11 @@ struct linux_efi_poisoned_memory {
 #ifdef CONFIG_EFI_POISONED_MEMORY
 void __init efi_poisoned_memory_reserve(void);
 void __init efi_poisoned_memory_reserve_units(void);
+void efi_hwpoison_record_pfn(unsigned long pfn);
 #else
 static inline void efi_poisoned_memory_reserve(void) { }
 static inline void efi_poisoned_memory_reserve_units(void) { }
+static inline void efi_hwpoison_record_pfn(unsigned long pfn) { }
 #endif
 
 void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d0d6b184ee469f..c95b0be04a0cf8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -43,6 +43,7 @@
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
 #include <linux/dax.h>
+#include <linux/efi.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
@@ -1327,10 +1328,16 @@ static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
  */
 static int action_result(unsigned long pfn, enum mf_action_page_type type,
-			 enum mf_result result)
+			 enum mf_result result, int flags)
 {
 	trace_memory_failure_event(pfn, type, result);
 
+	/*
+	 * An error injected by software is not a hardware fault, leave it out.
+	 */
+	if (type != MF_MSG_PFN_MAP && !(flags & MF_SW_SIMULATED))
+		efi_hwpoison_record_pfn(pfn);
+
 	if (type != MF_MSG_ALREADY_POISONED && type != MF_MSG_PFN_MAP) {
 		num_poisoned_pages_inc(pfn);
 		update_per_node_mf_stats(pfn, result);
@@ -1346,7 +1353,7 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 }
 
 static int page_action(struct page_state *ps, struct page *p,
-			unsigned long pfn)
+			unsigned long pfn, int flags)
 {
 	int result;
 
@@ -1358,7 +1365,7 @@ static int page_action(struct page_state *ps, struct page *p,
 	 * Could adjust zone counters here to correct for the missing page.
 	 */
 
-	return action_result(pfn, ps->type, result);
+	return action_result(pfn, ps->type, result, flags);
 }
 
 static inline bool PageHWPoisonTakenOff(struct page *page)
@@ -1731,7 +1738,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 }
 
 static int identify_page_state(unsigned long pfn, struct page *p,
-				unsigned long page_flags)
+				unsigned long page_flags, int flags)
 {
 	struct page_state *ps;
 
@@ -1750,7 +1757,7 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 		for (ps = error_states;; ps++)
 			if ((page_flags & ps->mask) == ps->res)
 				break;
-	return page_action(ps, p, pfn);
+	return page_action(ps, p, pfn, flags);
 }
 
 /*
@@ -2144,16 +2151,16 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 			flags |= MF_NO_RETRY;
 			goto retry;
 		}
-		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED, flags);
 	case MF_HUGETLB_FOLIO_PRE_POISONED:
 	case MF_HUGETLB_PAGE_PRE_POISONED:
 		rv = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			rv = kill_accessing_process(current, pfn, flags);
 		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED, flags);
 		else
-			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
+			action_result(pfn, MF_MSG_HUGE, MF_FAILED, flags);
 		return rv;
 	default:
 		WARN_ON((res != MF_HUGETLB_FREED) && (res != MF_HUGETLB_IN_USED));
@@ -2185,17 +2192,17 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 		} else {
 			res = MF_FAILED;
 		}
-		return action_result(pfn, MF_MSG_FREE_HUGE, res);
+		return action_result(pfn, MF_MSG_FREE_HUGE, res, flags);
 	}
 
 	page_flags = folio->flags.f;
 
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
 		folio_unlock(folio);
-		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
+		return action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED, flags);
 	}
 
-	return identify_page_state(pfn, p, page_flags);
+	return identify_page_state(pfn, p, page_flags, flags);
 }
 
 #else
@@ -2247,7 +2254,7 @@ static int memory_failure_dev_pagemap(unsigned long pfn, int flags,
 	/* drop pgmap ref acquired in caller */
 	put_dev_pagemap(pgmap);
 	if (rc != -EOPNOTSUPP)
-		action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED);
+		action_result(pfn, MF_MSG_DAX, rc ? MF_FAILED : MF_RECOVERED, flags);
 	return rc;
 }
 
@@ -2390,7 +2397,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 		}
 
 		if (!mf_handled)
-			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED);
+			return action_result(pfn, MF_MSG_PFN_MAP, MF_IGNORED, flags);
 	}
 
 	/*
@@ -2403,7 +2410,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 
 	kill_procs(&tokill, true, pfn, flags);
 
-	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED);
+	return action_result(pfn, MF_MSG_PFN_MAP, MF_RECOVERED, flags);
 }
 
 /**
@@ -2490,7 +2497,7 @@ int memory_failure(unsigned long pfn, int flags)
 			res = kill_accessing_process(current, pfn, flags);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(p);
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED, flags);
 		goto unlock_mutex;
 	}
 
@@ -2521,9 +2528,9 @@ int memory_failure(unsigned long pfn, int flags)
 				}
 				res = MF_FAILED;
 			}
-			res = action_result(pfn, MF_MSG_BUDDY, res);
+			res = action_result(pfn, MF_MSG_BUDDY, res, flags);
 		} else {
-			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED, flags);
 		}
 		goto unlock_mutex;
 	case 1:
@@ -2535,11 +2542,11 @@ int memory_failure(unsigned long pfn, int flags)
 		 * slab, page tables, large-kmalloc).
 		 * No recovery possible.
 		 */
-		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED, flags);
 		goto unlock_mutex;
 	default:
 		/* Transient lifecycle race with the page allocator. */
-		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED, flags);
 		goto unlock_mutex;
 	}
 
@@ -2587,7 +2594,7 @@ int memory_failure(unsigned long pfn, int flags)
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
+			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED, flags);
 			goto unlock_mutex;
 		}
 		VM_BUG_ON_PAGE(!page_count(p), p);
@@ -2641,7 +2648,7 @@ int memory_failure(unsigned long pfn, int flags)
 	 * Abort on fail: __filemap_remove_folio() assumes unmapped page.
 	 */
 	if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
-		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED);
+		res = action_result(pfn, MF_MSG_UNMAP_FAILED, MF_FAILED, flags);
 		goto unlock_page;
 	}
 
@@ -2650,12 +2657,12 @@ int memory_failure(unsigned long pfn, int flags)
 	 */
 	if (folio_test_lru(folio) && !folio_test_swapcache(folio) &&
 	    folio->mapping == NULL) {
-		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED);
+		res = action_result(pfn, MF_MSG_TRUNCATED_LRU, MF_IGNORED, flags);
 		goto unlock_page;
 	}
 
 identify_page_state:
-	res = identify_page_state(pfn, p, page_flags);
+	res = identify_page_state(pfn, p, page_flags, flags);
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:

-- 
2.53.0-Meta


