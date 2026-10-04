Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57595CA5FEF
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 03:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6236B008A; Sat,  3 Oct 2026 23:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F386B008C; Sat,  3 Oct 2026 23:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27F96B0092; Sat,  3 Oct 2026 23:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 922606B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 23:03:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9CBC140A12
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:03:28 +0000 (UTC)
X-FDA: 85283448096.06.E5B2F2F
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf13.hostedemail.com (Postfix) with ESMTP id B393820006
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 03:03:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vdNXYr5A;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791083007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2WDT44AOb6s0N0y44rOPUOS+zK+qYwT3HmjwCSf8nXs=;
	b=3DxqD1I5LyU0sbS0HEGWwWQI83fvs/C8RAoG+Tzm1/j3H+x9aSQO5y3i62TTk8Pe3z8TyJ
	fX3L5Uq48kkRhe1hcte15Ssh2lWetbcW/98XtWDw/pXjkfWCUZ+DXmHZspP+pIe+LM5OYZ
	WrLJLXeM4mpOkBde578oAuNQ0CZg/aQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vdNXYr5A;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791083007;
	b=n980DvY0yVjlCxmEsPgO5+WTDDvJT1w/vVxcCGpbkFPN8SGJUbtmC3XJzhgrBeD6DPhZba
	Nvc7zbYC7wSwGO4FI7j3L9W4knnhUr5tAiVlW0OnmbqapuKkAbseUzxwLwS+OSLtM/armU
	wyEH+4CNteDBNJba0vMXCzm5/SAu/jg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Jwr5K51ukqdtnHr4Uin+bWG/FzAyJskE0K5YWYJSjM8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791083005; v=1; x=1791687805;
 b=vdNXYr5ADhcPxbo/4GaKwR8GdMTjigve5cSeDv7JQsyhDaeqHE+hwio0Liq3GSL3yRMD5r/x
 fUmRrh2fRuRNjdZJhHPMlatXDQM/A0o1hNOBkiJue3cKAedtv2FHfYAs6nj9U/L6yIaYx7D55ix
 eK6pwCUxJnCGckt9ThHC62ag=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f5c2ae1123ce7d6d;
	Sun, 04 Oct 2026 03:03:24 +0000
X-Mizu-Trace-ID: f5c2ae1123ce7d6d
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu
Cc: alex@ghiti.fr,
	akpm@linux-foundation.org,
	zhangchunyan@iscas.ac.cn,
	rppt@kernel.org,
	kas@kernel.org,
	david@kernel.org,
	andrew+kernel@donnellan.id.au,
	rmclure@linux.ibm.com,
	debug@rivosinc.com,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	wangruikang@iscas.ac.cn,
	namcao@linutronix.de,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	alexghiti@rivosinc.com,
	viro@zeniv.linux.org.uk,
	ajones@ventanamicro.com,
	arnd@arndb.de,
	axelrasmussen@google.com,
	brauner@kernel.org,
	conor.dooley@microchip.com,
	conor@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	ljs@kernel.org,
	mhocko@suse.com,
	paul.walmsley@sifive.com,
	peterx@redhat.com,
	robh@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	yuanchu@google.com,
	stable@vger.kernel.org,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	me@ziyao.cc,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] riscv/mm: fix soft-dirty migration PMDs being treated as present
Date: Sun,  4 Oct 2026 11:03:12 +0800
Message-ID: <20261004030312.90163-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B393820006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5rbkdp9y686fczy5m6asjow8kfg9gprm
X-HE-Tag: 1791083006-772485
X-HE-Meta: U2FsdGVkX18iDeV89aBqOl3JBHAvAvQhOLpsBb5YiKpdiRgYf7shEHIF5gAgLXYV4nB+95NR/BRR8l/d6AXQxxiG9l+/Z9ZJFBMkCuwsiIcI+UIW4MKnnEn5SLTX2qE02r+dPsidOiWUmEcDvGyJTTMv8eaJv9XMJUDGLS4jwq5w3i0wtKo8bhZIT7UIRQJEcGI2xTna2/B2HlYCQCsQNOgpvWHOt75+NPLmfwTXDjUxY+2rgNKX/25Yiqeu/HO9TXipuub0uPyDPJAstGE56PNFr3U24fFsSygyczNZRo5Vem3cVl0dcBvAM5ZipUkc+ileZwcNP4HYBMIq4JHU1XmoCTbTTy2HPuMrBfXnNhjM1+JI5Nuw18RyGUtZ2U6EfJrBuWjSHFl57Q23+WWWvvDO42X6wPG7519r630mrHjmfUAUPbQbV1rEmZMENEkXH38quNzogPMB28CX/71bO23M6cEP/bF04pXe5DqEE+niPjDL+K9wzsWDbE/Ue/grIKhBPU36uM8a14MdA6RRScWEoNFU9O0kddJUclDcdtlVG3u9W48nAIywsSH9Y3PSIEnDmom+jmEgw0RgMwv5u93rhBHz8zvmQ83Abkp9nERY+eLyEiBoyfbZFCFquxiFKyB6WQNDa0Cw8SgJJZ4ZJqRsUb/NdwFazfLR3WkSz7FBrzhYIbMrL8Tah7rKmeLpnXTmQt5rLBTcgUzFFo14YzqwLqHOekXcCa4r5nK7UFZzj0QSofQVBc397tjCs7aPb3V0t1X3/qEnwfJAq93MDBAOM+FcAAInEqw8mgBP1ZzIBxkaVT7ekxT9wc3VFNRh1XGLMI9hazosMRYlEz42Gp9n2sFIxwb7EaJ6thZZN62cA4aSWVxw/e8Qtmq84yZUU+u1ACr3iLG6EFYQzkfAHRDmjYCRmCMq/zE32/kt3URZjntwQ+O5SVsAUQZHu/ET7aT4+zRPHotsbhL+8TB
 yhmP+TXj
 ZwaL9cQZfsrVwF0oW2TBXpKSy6z9R5aygN5C++LrxuUDYkAuc37YP05OX6B5gApqAOmdQRcaNHLaOEwdxeu9jNKOieEbYOBblDF0BvZPBR4tZcCgWc0PlB7SKR8ngAG9ouOnQ8eBDZxVbVfm9rBcsBejZDZ6fZvhchBOMGJzRP2z1UpVnUqkMenHoUGHWIQYnqyxj+H/XHiQuDJo95uUmv2kJBTiSoCVca1AoUHLseZOHbh294Lf0xh8xwTKMxkXwsxBRVtLWUBabE8Z9XDVp918kPTodHxosR7Siev4ZsC890LLuhF+1AkY1uIyTFDIWrtu4H5fCTPgoWApXY8JXlHbTRw7LkumLNnh6rUT5/C0q/B4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V uses _PAGE_EXEC for swap soft-dirty tracking when
CONFIG_MEM_SOFT_DIRTY is enabled and Svrsw60t59b is available. That's
a problem for PMD migration entries, since pmd_present() also checks
_PAGE_LEAF (R/W/X) to recognize THPs with _PAGE_PRESENT temporarily
cleared during splitting.

When a soft-dirty THP is migrated, set_pmd_migration_entry() preserves
soft-dirty with pmd_swp_mksoft_dirty(), setting the X bit in the
migration PMD. Even with _PAGE_PRESENT clear, we end up treating a
migration PMD as a present THP! The fault handler skips
pmd_migration_entry_wait(), and a write fault can end up in
do_huge_pmd_wp_page(), where pmd_page() decodes the migration entry
as a mapped PFN.

Move the swap soft-dirty bit to bit 12 and start the swap offset at
bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled. This keeps R/W/X clear
in migration PMDs and lets us keep the existing pmd_present() check
for invalidated THPs. Leave the offset at bit 12 when soft-dirty
tracking is disabled.

Fixes: 2a3ebad4db63 ("riscv: mm: add soft-dirty page tracking support")
Cc: stable@vger.kernel.org
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
I found this while reviewing Usama's PMD-level swap entries series [1]
and comparing the swap flag bits with the PMD presence checks across
architectures.

[1] https://lore.kernel.org/all/20261002095503.3585565-1-usama.arif@linux.dev/

 arch/riscv/include/asm/pgtable-bits.h |  6 +++---
 arch/riscv/include/asm/pgtable.h      | 10 ++++++----
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-bits.h b/arch/riscv/include/asm/pgtable-bits.h
index d5a86b4df3ce6..d84b459e010c1 100644
--- a/arch/riscv/include/asm/pgtable-bits.h
+++ b/arch/riscv/include/asm/pgtable-bits.h
@@ -27,12 +27,12 @@
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
 	 (1UL << 59) : 0)
 /*
- * Bit 3 is always zero for swap entry computation, so we
- * can borrow it for swap page soft-dirty tracking.
+ * Bit 12 is reserved for swap soft-dirty tracking. The swap offset
+ * starts at bit 13 when CONFIG_MEM_SOFT_DIRTY is enabled.
  */
 #define _PAGE_SWP_SOFT_DIRTY						\
 	((riscv_has_extension_unlikely(RISCV_ISA_EXT_SVRSW60T59B)) ?	\
-	 _PAGE_EXEC : 0)
+	 (1UL << 12) : 0)
 #else
 #define _PAGE_SOFT_DIRTY	0
 #define _PAGE_SWP_SOFT_DIRTY	0
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index b644db16bda94..acaf6d3b54d04 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1178,18 +1178,20 @@ static inline pud_t pud_modify(pud_t pud, pgprot_t newprot)
  *
  * Format of swap PTE:
  *	bit            0:	_PAGE_PRESENT (zero)
- *	bit       1 to 2:	(zero)
- *	bit            3:	_PAGE_SWP_SOFT_DIRTY
+ *	bit       1 to 3:	_PAGE_LEAF (zero)
  *	bit            4:	_PAGE_SWP_UFFD
  *	bit            5:	_PAGE_PROT_NONE (zero)
  *	bit            6:	exclusive marker
  *	bits      7 to 11:	swap type
- *	bits 12 to XLEN-1:	swap offset
+ *	bit           12:	_PAGE_SWP_SOFT_DIRTY (CONFIG_MEM_SOFT_DIRTY)
+ *	bits 12/13 to XLEN-1:	swap offset (without/with CONFIG_MEM_SOFT_DIRTY)
  */
 #define __SWP_TYPE_SHIFT	7
 #define __SWP_TYPE_BITS		5
 #define __SWP_TYPE_MASK		((1UL << __SWP_TYPE_BITS) - 1)
-#define __SWP_OFFSET_SHIFT	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT)
+#define __SWP_OFFSET_SHIFT \
+	(__SWP_TYPE_BITS + __SWP_TYPE_SHIFT + \
+	 IS_ENABLED(CONFIG_MEM_SOFT_DIRTY))
 
 #define MAX_SWAPFILES_CHECK()	\
 	BUILD_BUG_ON(MAX_SWAPFILES_SHIFT > __SWP_TYPE_BITS)
-- 
2.49.0


