Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227ABCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A476B009E; Tue, 26 May 2026 13:59:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48E8B6B009F; Tue, 26 May 2026 13:59:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356896B00A1; Tue, 26 May 2026 13:59:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 142DD6B009E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFA7C8EC8C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:35 +0000 (UTC)
X-FDA: 84810333510.30.49CEC7E
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBBD01C000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kkxwf02D;
	spf=pass (imf21.hostedemail.com: domain of 3hN8VaggKCPETkWU+ZbmZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3hN8VaggKCPETkWU+ZbmZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJx2KhHmtgY53AkMvOyg5uK/J3luFDMcMijObo9+4vo=;
	b=M0i5QoZ+5WVx+iT8wJiCv8eEUE4b33BEkidqhu3dRkDb5V5zzU+ilnmkGEjAoUArdQIoIQ
	JItwzJjgos2WRCOOacX1N9EJIHhyrib5lHmr4H13s33UL6Av8Zr5/IRIgaVlyXf+z37zym
	qlNMD49EaNKYtfsZNNlmAlTpykhLTGg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kkxwf02D;
	spf=pass (imf21.hostedemail.com: domain of 3hN8VaggKCPETkWU+ZbmZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3hN8VaggKCPETkWU+ZbmZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818373; a=rsa-sha256;
	cv=none;
	b=QpK22UhOw/U32GwVqnO9bKv/VOg9J3kiYBd7Yvw65VCqmBlin0bEW6QwmSzfvrXckrOqiF
	adidTQyAQMme9aRqpMrJLyXnZJaUlMOcbttWiP0jRLrr/y3YoCmSIZJ5n0XtdFXpQk4qhD
	3aGR83djT2kJklqBUKfIA9tS5WUjY5I=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44d9ace59efso6444880f8f.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818372; x=1780423172; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJx2KhHmtgY53AkMvOyg5uK/J3luFDMcMijObo9+4vo=;
        b=Kkxwf02DO4I9VGa+KZmJE4Fd9ET5XC4846U/2yx48Dm7Q4MmviCLtK8WxmUr90qbvS
         o6W4NT0Z8cdhbEdaYYCg8IWvBRWiV0pqOqUONqMpnzIMWcylfUy0ugHwZWER2c4t35uM
         D2eAYqL27Bs7EG8Lp9oVcHyinXNFRJ9AwiWXkoKYo1aplgZNo3pERXKCiSAIs0I03xMX
         Ed5E+g0mLDruzM9wv5TYzZpEuetE5+4rSDNR+AJlbzt05F3qX8Hd5PHZc13Zv9GMDQ1y
         aAiSkX2HoukAkjnSDNh0Ujw4GKYtsMWUVt54mF8nGtLYAJZoAwvSrBuFKcWqA9F9hCxV
         E0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818372; x=1780423172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJx2KhHmtgY53AkMvOyg5uK/J3luFDMcMijObo9+4vo=;
        b=hhzn0WI9miqmiNMJr5iIawRDR9J2Ap6QgJrjP7Qt8zxi/La+fA9Ly/1INLwNilGg/j
         Qh1f66VHkODJXvwsDEG2Cv6Gu3v/9VleSULYCPxSaWjVbB3sQVMFzfHkvbcxZeECxKMS
         wLxbCoQPvrcPKzZybkLAe7plhY8berj5txeqZYHaOqj0+ZHP3vu25jMoEBeAv4REY9Yf
         8HYeaMqQzS0kE88RtgaRohLR4LK4bkA+B9KmLSxPjGA2e+K9L93PINrY9scl8PNNp/Vf
         rJv5YyxaShz4qw57+oKyafDCZYnvnCZBGHdmO50yc7o6qmRbeSz0awPcrq0nyKdo+hqL
         +AJw==
X-Forwarded-Encrypted: i=1; AFNElJ92mEggvFUT2fiQtULS2WIaOxKNH0XjQ8zkF8xX/oWUevFNK1fZutVgW2V1wbWiKXdGC/FojetcFw==@kvack.org
X-Gm-Message-State: AOJu0YyVhpKrpm7SpUpmQbT/4TzNwEswngftfkpbD/l9//VCndax8Id4
	yO/MtgOSXjQ+Cw5pqqIhS+mhLV0kNxXxh/FAXqs8QEt2MygbBQDtFxJJaABvYYLnwk8AoVEBWA=
	=
X-Received: from wrjn10.prod.google.com ([2002:adf:e34a:0:b0:43d:6f5f:8c52])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:35c8:b0:490:44eb:c1e7
 with SMTP id 5b1f17b1804b1-49044ebc2d5mr360486815e9.30.1779818372100; Tue, 26
 May 2026 10:59:32 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:56 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3242; i=ardb@kernel.org;
 h=from:subject; bh=Qta0PMsGcvlQhpXqhjldDBt900x2YBq541ys84w8Z6A=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0frL6+VN/jnUf5F5tPjtywfpJk9QUy2MKCjk0NTccj
 r7PUqfVUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACayl53hf8n7L8U7Dq/XtJM8
 aaNT5xu9zmX9+a6ICfks3cp+rZ7mixj+Z6226zYNmPCvKn7q8tmXSzeumHZtU+IR1bAruyazqkp WMAIA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-26-ardb+git@google.com>
Subject: [PATCH v6 09/15] arm64: Move fixmap and kasan page tables to end of
 kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 54xuz3hkmg4b7wnhqpsjipu3c5ueisbs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CBBD01C000D
X-HE-Tag: 1779818373-315650
X-HE-Meta: U2FsdGVkX19JpysM4utr6XLB4GeWskKpLos4Fd3XcPwtTSemLUfeR0TIpz2w9jeKaGmMZbfWPRuJjdDX3xlfTdd5Ypa2p2O6G1lstDj318kGhbbA956wxjHKs5vutK88uIacV5FhguVu/UYB4ZVOjZnrngGK+GpV7jcJaDL/hnC5Pp14YBlyJKLITHwQWTMpTujjHlmGp8FXOdq5ZB2cP5iUUF116tN9MxSEUbjp/diLjHUJRtnj9ZvJbb/5NZC4CWA7KSQ+9oN0DcY/pv1+5ZrWyA/w1dHA/16FTdTTRZ1XNzgojsWyVtZM4kBvRxq0cb499RqPArEFlSd+dbRWDJJHJHBYb0q/8D6ghA+QdJy4ZNqY4BMx0n8rUnyvZQVF8Tzi9mbOOIbRV5GHmzJo/VRzf2U7orxUwDlUkN8WdMegE+gIGSgcuw/VERPaCfwN2hhwV878mqSIUrQnjFliKCf+ilMrY1AhHi1jP5gGnjBYFA3RXjxwgaor9nV5IipzczYzUwL8Gd6htTAhOq/kMxo+wfuz8kIppRERxmt1i8ob2XwuqXFnfu8z4MP0eZc1hPuIiq4iyu1cgAGuMRmc3KY/JdtGmC1yrAOoMF4OpvN7mWfne1qL7o5Sza0Cr8BdjpVZ4ixJSbtJRcFbecRCoQmQ16gFKBIlmKDii9LZe6mgMFjwbqhsXsMAzOe1z5a3UzQ613zTl3bfxwkjLs1WRmp4g3kTmY1syUVZJ6eHCbx2pXFJqctxbjGq/avl5Medw1dT9/AojzsY3xMP3WNR9289rfbJNZ8LAd+//SkZE+LgaZB9TD4ai02YXIZ0HDjk4SHiT6Po2P54wd6SVUetz3A8LJrdr0mMdWJR7/Zcu+PJKta9lyZZ/MomEmVNZG0+9Cq8Wg4oALyJXslY2G96XsFrwSQrfusnlahANNTC4YX7T3kagmwaq1FYLIkOa+l6S6OkDhZysPlY2BR7w3V
 IhyCnXzg
 2GRkMqF796tpukmV4dfhLyOj+/f37XNJFQsEvrveXQuyhD5mnHj0YjZ1Bq1BzUBmFga6nj2P78znYDncKlbvha8E/btRJLc+8zGZauK0EzCDsY4HoLBxNhXnfg/KI9cYOgnuSTTaeG221xz3DQxTFFN7dIPU0OQdBea3sr1SeW1MDEuxaFmzRw+RkVEnh6GxCf+mK2IgOOPOtyKQMDDxkfLcxzwIKXJmYUR9tQY7t58DiUZq13yLxkTDm1Z7UaLa9z/fOrBX9BlCmZs4ddDbtPx8EmJCTF8SutKkgLQvEmqa2aFIpS9PXZPJaz/UewdEmsfmxB0vGoPxxBWXMPw4TCApEL9JX1kGQ9QKrsp43mjQdN63ca6T4PsyK9UAFFPQ2K+zHSbn8M0AWOUyvLxzMsVmYvv0K6YXVSHz0PgqFT/gKoTW4TvkGhbMfkNaRHnnBlU61zeYEKzprBR+h/YlfBnle+BkTTGtPPTLX9udWVMUngWllvYw4iF7rDYnMJhZSIthKVVxmPi8S01hWa4VSt0Kx5W0EAjhdCRyrQ3mXwA6eEAxGxqk838jpWlRJ53GotmBrizvl82a+vBD6B+22BPN9blEBmecZbAI+GIaIDIe2SkV4xVbwsIeKTPRGWAL50A5n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Move the fixmap and kasan page tables out of the BSS section, and place
them at the end of the image, right before the init_pg_dir section where
some of the other statically allocated page tables live.

These page tables are currently the only data objects in vmlinux that
are meant to be accessed via the kernel image's linear alias, and so
placing them together allows the remainder of the data/bss section to be
remapped read-only or unmapped entirely.

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/mmu.h    | 2 ++
 arch/arm64/kernel/vmlinux.lds.S | 8 +++++++-
 arch/arm64/mm/fixmap.c          | 6 +++---
 arch/arm64/mm/kasan_init.c      | 2 +-
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index 5e1211c540ab..fb95754f2876 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -13,6 +13,8 @@
 
 #ifndef __ASSEMBLER__
 
+#define __pgtbl_bss __section(".pgdir.bss") __aligned(PAGE_SIZE)
+
 #include <linux/refcount.h>
 #include <asm/cpufeature.h>
 
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index e1ac876200a3..2b0ebfb30c63 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -349,9 +349,15 @@ SECTIONS
 	_edata = .;
 
 	/* start of zero-init region */
-	BSS_SECTION(SBSS_ALIGN, 0, 0)
+	BSS_SECTION(SBSS_ALIGN, 0, PAGE_SIZE)
 	__pi___bss_start = __bss_start;
 
+	/* fixmap BSS starts here - preceding data/BSS is omitted from the linear map */
+	.pgdir.bss (NOLOAD) : ALIGN(PAGE_SIZE) {
+		*(.pgdir.bss)
+	}
+	ASSERT(ADDR(.pgdir.bss) == __bss_stop, ".pgdir.bss must follow BSS")
+
 	. = ALIGN(PAGE_SIZE);
 	__pi_init_pg_dir = .;
 	. += INIT_DIR_SIZE;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index c5c5425791da..1a3bbd67dd76 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -31,9 +31,9 @@ static_assert(NR_BM_PMD_TABLES == 1);
 
 #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
 
-static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __page_aligned_bss;
-static pmd_t bm_pmd[PTRS_PER_PMD] __page_aligned_bss __maybe_unused;
-static pud_t bm_pud[PTRS_PER_PUD] __page_aligned_bss __maybe_unused;
+static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __pgtbl_bss;
+static pmd_t bm_pmd[PTRS_PER_PMD] __pgtbl_bss __maybe_unused;
+static pud_t bm_pud[PTRS_PER_PUD] __pgtbl_bss __maybe_unused;
 
 static inline pte_t *fixmap_pte(unsigned long addr)
 {
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index abeb81bf6ebd..dbf22cae82ee 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -214,7 +214,7 @@ asmlinkage void __init kasan_early_init(void)
 		 * shadow pud_t[]/p4d_t[], which could end up getting corrupted
 		 * when the linear region is mapped.
 		 */
-		static pte_t tbl[PTRS_PER_PTE] __page_aligned_bss;
+		static pte_t tbl[PTRS_PER_PTE] __pgtbl_bss;
 		pgd_t *pgdp = pgd_offset_k(KASAN_SHADOW_START);
 
 		set_pgd(pgdp, __pgd(__pa_symbol(tbl) | PGD_TYPE_TABLE));
-- 
2.54.0.794.g4f17f83d09-goog


