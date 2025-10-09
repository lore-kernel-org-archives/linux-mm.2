Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A51C1CCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F61F8E0045; Wed,  8 Oct 2025 21:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5CF8E0002; Wed,  8 Oct 2025 21:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0703F8E0045; Wed,  8 Oct 2025 21:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1AB38E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A83711A0882
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:57 +0000 (UTC)
X-FDA: 83976917514.19.5B87C1C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id DC5F3100006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Y3khPZjN;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CenIuzXpxApsKzkUyACEQ0jjKpKilW6kJlIT8GgEJGc=;
	b=sHj1nuqmzRZh8rwzwCjjxORZTPPCxqOFG1Xsu/6XkEkqgcQyzLmYU7FA5oRA583sayuqov
	PAej0Hwf+hJiel/6Im/TIWAM2P3mp+GRAeUc1pLSTLlMXPloZIL7IWqmfklnWnF4grtjo2
	c+UC8hPtvMI/ZRLTJjVqwzQ9z0Y/k18=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Y3khPZjN;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975136; a=rsa-sha256;
	cv=none;
	b=UG7EJqJHlEloNQ/st8tYnq7tzTyM2wjiR2Dmfn1xI1unbNOFKLwzM65oGCYG9fkrMBDLyM
	PAkGGRvmCBF7qgo4F/76OBAHl7m9iJk0he7pCFQaq9oUKp0iexRAQ6Bx8hRuuMsVlZuQPg
	VnWC76F48splNToAuXl+BckgKdnic18=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-27d3540a43fso4217945ad.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975135; x=1760579935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CenIuzXpxApsKzkUyACEQ0jjKpKilW6kJlIT8GgEJGc=;
        b=Y3khPZjN+LctIZu01FqoJ8T5qZo/bWzl6VQ2iSWlDWQm39hrksfqJA2LJf2jqdWFCA
         fJZqzD/eGNZib4sMfyjCZ8lftJ8XdKamTbiB2lbMQgKr1s9a+qcqzNfvP1JsCgbGLriI
         MKbJLwNnnqgJg7OHh1RCVrmIql4GIcrL82T8Ut/4bfpkx/tu+cT04/BDeMqvkjm5v5va
         lnRzBF+dzEjr/bI7EqS7v0qYgAa2lWjV2xsGYXqp7iNIxIN4Or35GAPvsb0g4gzFc+/8
         qBxTu6ZBRepWkz6EeSoWzTF5zgBqkuFKBHSkxAd/ApOO+wX8iRqvxRMcSU6+zIQ4OqWL
         hLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975135; x=1760579935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CenIuzXpxApsKzkUyACEQ0jjKpKilW6kJlIT8GgEJGc=;
        b=Y1SKV8EGMwmpDcqTSL1XxYJ8TwyAwy/LWempPTp0lathfSKxZXsw7cDqbY+PdqzE22
         yjTksO9IkN+eCYPBO8g6svhYfVLRteN9YKEyBdyhH15V56cdChGQSllI92ohmW8giCbM
         aeQl5aJGyPoGj+Pukp184yc1QhVqELTRvIHRGswwcLMHojj0iMVZseDYYewfgGrasB7z
         Gto9Ki+VKN8aiBObGWAfLsShgRZbWdRtCyvmngRjgC0e08Zb1A8o3/caO89nrMpP+TBB
         svxki1JevuRp8e41zbV6LMD1sWgy3zqGhkrULe+uuxduFgxgALAJ6UXEP3i+sUrXTXEe
         qkXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgOJVZh4q4Po8cqIg/LAlCaHG+4YHX2tXK0aJl+vCcw3XXHYrA4DE5dYY0znKCFZuzKqVm9BN93A==@kvack.org
X-Gm-Message-State: AOJu0YxIqVd2Cp8ldfI0PWRtiepm2hA46A4wa9tPbHh2kPtiWd5gWYpe
	pIovzM9OZBuhJPpqrcHihm0XvimWFwGrFzXmmSm0+gidXXKvnbBtmOmt3zyMP6KZ84o=
X-Gm-Gg: ASbGncsusrNa5fBcrj19eGb99jQlX/EWCdJoZBMSM4BbepA509XVnFPbjximFqbvUnP
	AXsCy9tfMuGes1DIu9Az/QrqUDqCqabbuxA928DQY9u1f76DowIjftYXB9SlSqfSE5XHx/IqMQN
	Ve3iljmD4G6BZW0+0UsLOgNMAhu2gRD6Zcqj2BPpoVS7YzUeFm1DZST5WZYA8bSzxMMn+nZm0w3
	XBVjPGr3I/vZueizcqfZk9UkoQcDP7gW2mDhIndludKtZcdd3A0Pwzg/Pp0MpHZFNhC62Bw5u2W
	J89Xle4lA3gh/G9kZ7AbXtHuGhwRtimqpmENHT33jBC1SOviahrEXtH51amgXOIMV5S6zI1S5R1
	rjY8zJZlgXR9OMP9aoBbTYTc+89s1n1BzS1LTsJjdPnQcfZWI+8dtlCplPTI3yI6ErDY4
X-Google-Smtp-Source: AGHT+IE89szqaNtwL7rV4bj88ZY+SdoVTevQxbpQrOA8RfTnb5TmsiChXULlplUdtG27xkBnWYgvJg==
X-Received: by 2002:a17:903:1b4b:b0:26d:353c:75cd with SMTP id d9443c01a7336-290272409c7mr75848955ad.21.1759975134617;
        Wed, 08 Oct 2025 18:58:54 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:54 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 11/18] riscv: mm: Fix up memory types when writing page tables
Date: Wed,  8 Oct 2025 18:57:47 -0700
Message-ID: <20251009015839.3460231-12-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DC5F3100006
X-Stat-Signature: hr6cfq1fn8r7mt4c4hx5kppaxee7byrq
X-Rspam-User: 
X-HE-Tag: 1759975135-148104
X-HE-Meta: U2FsdGVkX19Pes/nYasz5SQgA3bURQRhmF8DpNOLyND5uN088OegKIPUZb0Q0BdN56Z8x5Gy1MfkkiCtfnpg2Txr5CMIAuKp6snuRAm4/vReQlb6CFKH2w66+thnsGzD6LpXHZpt3vYJAqXQ9C90W6I7pqvPwlzxNM0+fV2ETLAOrg8ECDEbihPGbQ6+XG+hXyOtM5645zcrk2KDDal5eYz23h0qmM3ur6fLlWRfl6NV176AgXy9LbHF27Qagq7/YADBIHrCAvjxNMs8uVB46mn3t3noUOLwl7Xh9deHaYx+Pdt62ovEF9oSlUcAqa8S9A7y1QPnDTbGpxb5KIXunT9y0//mYievAF6mOLTnyh5KPwVqP77Xc5OTE7KCNocpqghdTLfsRUzkmrtbje7K79gPWc3LqgCgLbPg0r4eStkVmrofQPe+ShwALIeJCVQ2+PmAfDM33qN5zgxMptHtCQ6kt3qYpEYoIdB/AZvw0iMQOyD4tqKbNUgfVrNvcd6iqjH3D0GNL0vzt25IYg3Ow/MWnHd393j4hlW2+7YF6KaWcBipxLsOJPQr9TihwzfgQRo9ZQA0IMAGfvuimRPLPUeFeoSTOPrHxWhQLRNgwaidYSFubDvtKwbraQTPA4v7K+/2gOym+X9vGqjJV+IwIRV7bbmhjdEM6kEJqaIRQdxqF9zl98sy5nVw9fSdRdyzn8GcgO6O4a9XL440rLgZx/qm3RW4Q+zRE85Gbg3aItm3813mHNbjrRYh0QF7jffRIFuhDlgTP1YEQPjBqyi4LM4asJh2pQ4rTK+PSmAhx10GHXlT0TiOyOL5nsa6w5CXxVaLzTtVVA1eP8dxUsCL8tHLF4pE7bjMypDnwspQOgy/Ix/jQRGXA92M1vbyeWQJqOest4jfJoq9/M6kI89ejOHHAd/KhLOtgIXgPFJ6EgE7ZJLIN+nRhaYDHSfiEeS7eVq3zv3UJFrCDpgCz9D
 zcWuK57F
 XJ9doJiHCyLv0wZuIFAGYU2TAyv50N367uY3KvrEOZBhmBK402BV8tC6CZF21z5lBjXra67u45SCd4RdHGIrR6Gb6ws24ORp/9fv+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, Linux on RISC-V has three ways to specify the cacheability
and ordering PMAs of a page:
 1) Do nothing; assume the system is entirely cache-coherent and rely on
    the hardware for any ordering requirements
 2) Use the page table bits specified by Svpbmt
 3) Use the page table bits specified by XTheadMae

To support all three methods, the kernel dynamically determines the
definitions of the _PAGE_NOCACHE and _PAGE_IO fields. However, this
alone is not sufficient, as XTheadMae uses a nonzero memory type value
for normal memory pages. So the kernel uses an additional alternative
sequence (ALT_THEAD_PMA) to insert the correct memory type when
generating page table entries.

Some RISC-V platforms use a fourth method to specify the cacheability of
a page of RAM: RAM is mapped to multiple physical address ranges, with
each alias having a different set of statically-determined PMAs.
Software selects the PMAs for a page by choosing the corresponding PFN
from one of the available physical address ranges. Like for XTheadMae,
this strategy also requires applying a transformation when writing page
table entries. Since these physical memory aliases should be invisible
to the rest of the kernel, the opposite transformation must be applied
when reading page table entries.

However, with this last method of specifying PMAs, there is no inherent
way to indicate the cacheability of a page in the pgprot_t value, since
the PFN itself determines cacheability. This implementation reuses the
PTE bits from Svpbmt, as Svpbmt is the standard RISC-V extension, and
thus ought to be the most common way to indicate per-page PMAs. Thus,
the Svpbmt variant of _PAGE_NOCACHE and _PAGE_IO is made available even
when the CPU does not support the extension.

It turns out that with some clever bit manipulation, it is just as
efficient to transform all three Svpbmt memory type values to the
corresponding XTheadMae values, as it is to check for and insert the
one XTheadMae memory type value for normal memory. Thus, we implement
XTheadMae as a variant on top of Svpbmt. This allows the _PAGE_NOCACHE
and _PAGE_IO definitions to be compile-time constants, and centralizes
all memory type handling to a single set of alternative macros.

However, there is a tradeoff for platforms relying on hardware for all
memory type handling: the memory type PTE bits must now be masked off
when writing page table entries, whereas previously no transformation
was needed.

As a side effect, since the inverse transformation is applied when
reading back page table entries, this change fixes the reporting of the
memory type bits from ptdump on platforms with XTheadMae.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - Keep Kconfig options for each PBMT variant separate/non-overlapping
 - Move fixup code sequences to set_pXX() and pXXp_get()
 - Only define ALT_UNFIX_MT in configurations that need it
 - Improve inline documentation of ALT_FIXUP_MT/ALT_UNFIX_MT

 arch/riscv/include/asm/errata_list.h |  45 -------
 arch/riscv/include/asm/pgtable-32.h  |   3 +
 arch/riscv/include/asm/pgtable-64.h  | 171 ++++++++++++++++++++++-----
 arch/riscv/include/asm/pgtable.h     |  47 ++++----
 arch/riscv/mm/pgtable.c              |  14 +--
 arch/riscv/mm/ptdump.c               |  12 +-
 6 files changed, 174 insertions(+), 118 deletions(-)

diff --git a/arch/riscv/include/asm/errata_list.h b/arch/riscv/include/asm/errata_list.h
index 6e426ed7919a4..56335eba899ea 100644
--- a/arch/riscv/include/asm/errata_list.h
+++ b/arch/riscv/include/asm/errata_list.h
@@ -59,51 +59,6 @@ asm(ALTERNATIVE("sfence.vma %0, %1", "sfence.vma", SIFIVE_VENDOR_ID,	\
 		ERRATA_SIFIVE_CIP_1200, CONFIG_ERRATA_SIFIVE_CIP_1200)	\
 		: : "r" (addr), "r" (asid) : "memory")
 
-/*
- * _val is marked as "will be overwritten", so need to set it to 0
- * in the default case.
- */
-#define ALT_SVPBMT_SHIFT 61
-#define ALT_THEAD_MAE_SHIFT 59
-#define ALT_SVPBMT(_val, prot)						\
-asm(ALTERNATIVE_2("li %0, 0\t\nnop",					\
-		  "li %0, %1\t\nslli %0,%0,%3", 0,			\
-			RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,	\
-		  "li %0, %2\t\nslli %0,%0,%4", THEAD_VENDOR_ID,	\
-			ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
-		: "=r"(_val)						\
-		: "I"(prot##_SVPBMT >> ALT_SVPBMT_SHIFT),		\
-		  "I"(prot##_THEAD >> ALT_THEAD_MAE_SHIFT),		\
-		  "I"(ALT_SVPBMT_SHIFT),				\
-		  "I"(ALT_THEAD_MAE_SHIFT))
-
-#ifdef CONFIG_ERRATA_THEAD_MAE
-/*
- * IO/NOCACHE memory types are handled together with svpbmt,
- * so on T-Head chips, check if no other memory type is set,
- * and set the non-0 PMA type if applicable.
- */
-#define ALT_THEAD_PMA(_val)						\
-asm volatile(ALTERNATIVE(						\
-	__nops(7),							\
-	"li      t3, %1\n\t"						\
-	"slli    t3, t3, %3\n\t"					\
-	"and     t3, %0, t3\n\t"					\
-	"bne     t3, zero, 2f\n\t"					\
-	"li      t3, %2\n\t"						\
-	"slli    t3, t3, %3\n\t"					\
-	"or      %0, %0, t3\n\t"					\
-	"2:",  THEAD_VENDOR_ID,						\
-		ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)		\
-	: "+r"(_val)							\
-	: "I"(_PAGE_MTMASK_THEAD >> ALT_THEAD_MAE_SHIFT),		\
-	  "I"(_PAGE_PMA_THEAD >> ALT_THEAD_MAE_SHIFT),			\
-	  "I"(ALT_THEAD_MAE_SHIFT)					\
-	: "t3")
-#else
-#define ALT_THEAD_PMA(_val)
-#endif
-
 #define ALT_CMO_OP(_op, _start, _size, _cachesize)			\
 asm volatile(ALTERNATIVE(						\
 	__nops(5),							\
diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index fa6c87015c480..90ef35a7c1a52 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -28,6 +28,9 @@
 #define _PAGE_IO		0
 #define _PAGE_MTMASK		0
 
+#define ALT_FIXUP_MT(_val)
+#define ALT_UNFIX_MT(_val)
+
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index d17382c0fbe59..5531752b608e4 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -8,7 +8,7 @@
 
 #include <linux/bits.h>
 #include <linux/const.h>
-#include <asm/errata_list.h>
+#include <asm/alternative-macros.h>
 
 extern bool pgtable_l4_enabled;
 extern bool pgtable_l5_enabled;
@@ -109,6 +109,8 @@ enum napot_cont_order {
 #define HUGE_MAX_HSTATE		2
 #endif
 
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+
 /*
  * [62:61] Svpbmt Memory Type definitions:
  *
@@ -117,53 +119,152 @@ enum napot_cont_order {
  *  10 - IO     Non-cacheable, non-idempotent, strongly-ordered I/O memory
  *  11 - Rsvd   Reserved for future standard use
  */
-#define _PAGE_NOCACHE_SVPBMT	(1UL << 61)
-#define _PAGE_IO_SVPBMT		(1UL << 62)
-#define _PAGE_MTMASK_SVPBMT	(_PAGE_NOCACHE_SVPBMT | _PAGE_IO_SVPBMT)
+#define _PAGE_NOCACHE		(1UL << 61)
+#define _PAGE_IO		(2UL << 61)
+#define _PAGE_MTMASK		(3UL << 61)
 
 /*
+ * ALT_FIXUP_MT
+ *
+ * On systems that do not support any form of page-based memory type
+ * configuration, this code sequence clears the memory type bits in the PTE.
+ *
+ * On systems that support Svpbmt, the memory type bits are left alone.
+ *
+ * On systems that support XTheadMae, a Svpbmt memory type is transformed
+ * into the corresponding XTheadMae memory type.
+ *
  * [63:59] T-Head Memory Type definitions:
  * bit[63] SO - Strong Order
  * bit[62] C - Cacheable
  * bit[61] B - Bufferable
  * bit[60] SH - Shareable
  * bit[59] Sec - Trustable
- * 00110 - NC   Weakly-ordered, Non-cacheable, Bufferable, Shareable, Non-trustable
  * 01110 - PMA  Weakly-ordered, Cacheable, Bufferable, Shareable, Non-trustable
+ * 00110 - NC   Weakly-ordered, Non-cacheable, Bufferable, Shareable, Non-trustable
  * 10010 - IO   Strongly-ordered, Non-cacheable, Non-bufferable, Shareable, Non-trustable
+ *
+ * Pseudocode operating on bits [63:60]:
+ *   t0 = mt << 1
+ *   if (t0 == 0)
+ *     t0 |= 2
+ *   t0 ^= 0x5
+ *   mt ^= t0
+ */
+
+#define ALT_FIXUP_MT(_val)								\
+	asm(ALTERNATIVE_2("addi	t0, zero, 0x3\n\t"					\
+			  "slli	t0, t0, 61\n\t"						\
+			  "not	t0, t0\n\t"						\
+			  "and	%0, %0, t0\n\t"						\
+			  "nop\n\t"							\
+			  "nop\n\t"							\
+			  "nop",							\
+			  __nops(7),							\
+			  0, RISCV_ISA_EXT_SVPBMT, CONFIG_RISCV_ISA_SVPBMT,		\
+			  "srli	t0, %0, 59\n\t"						\
+			  "seqz	t1, t0\n\t"						\
+			  "slli	t1, t1, 1\n\t"						\
+			  "or	t0, t0, t1\n\t"						\
+			  "xori	t0, t0, 0x5\n\t"					\
+			  "slli	t0, t0, 60\n\t"						\
+			  "xor	%0, %0, t0",						\
+			  THEAD_VENDOR_ID, ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
+			  : "+r" (_val) :: "t0", "t1")
+
+#else
+
+#define _PAGE_NOCACHE		0
+#define _PAGE_IO		0
+#define _PAGE_MTMASK		0
+
+#define ALT_FIXUP_MT(_val)
+
+#endif /* CONFIG_RISCV_ISA_SVPBMT || CONFIG_ERRATA_THEAD_MAE */
+
+#if defined(CONFIG_ERRATA_THEAD_MAE)
+
+/*
+ * ALT_UNFIX_MT
+ *
+ * On systems that support Svpbmt, or do not support any form of page-based
+ * memory type configuration, the memory type bits are left alone.
+ *
+ * On systems that support XTheadMae, the XTheadMae memory type (or zero) is
+ * transformed back into the corresponding Svpbmt memory type.
+ *
+ * Pseudocode operating on bits [63:60]:
+ *   t0 = mt & 0xd
+ *   t0 ^= t0 >> 1
+ *   mt ^= t0
  */
-#define _PAGE_PMA_THEAD		((1UL << 62) | (1UL << 61) | (1UL << 60))
-#define _PAGE_NOCACHE_THEAD	((1UL << 61) | (1UL << 60))
-#define _PAGE_IO_THEAD		((1UL << 63) | (1UL << 60))
-#define _PAGE_MTMASK_THEAD	(_PAGE_PMA_THEAD | _PAGE_IO_THEAD | (1UL << 59))
 
-static inline u64 riscv_page_mtmask(void)
+#define ALT_UNFIX_MT(_val)								\
+	asm(ALTERNATIVE(__nops(6),							\
+			  "srli	t0, %0, 60\n\t"						\
+			  "andi	t0, t0, 0xd\n\t"					\
+			  "srli	t1, t0, 1\n\t"						\
+			  "xor	t0, t0, t1\n\t"						\
+			  "slli	t0, t0, 60\n\t"						\
+			  "xor	%0, %0, t0",						\
+			  THEAD_VENDOR_ID, ERRATA_THEAD_MAE, CONFIG_ERRATA_THEAD_MAE)	\
+			  : "+r" (_val) :: "t0", "t1")
+
+#define ptep_get ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
 {
-	u64 val;
+	pte_t pte = READ_ONCE(*ptep);
 
-	ALT_SVPBMT(val, _PAGE_MTMASK);
-	return val;
+	ALT_UNFIX_MT(pte);
+
+	return pte;
 }
 
-static inline u64 riscv_page_nocache(void)
+#define pmdp_get pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
 {
-	u64 val;
+	pmd_t pmd = READ_ONCE(*pmdp);
+
+	ALT_UNFIX_MT(pmd);
 
-	ALT_SVPBMT(val, _PAGE_NOCACHE);
-	return val;
+	return pmd;
 }
 
-static inline u64 riscv_page_io(void)
+#define pudp_get pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
 {
-	u64 val;
+	pud_t pud = READ_ONCE(*pudp);
+
+	ALT_UNFIX_MT(pud);
 
-	ALT_SVPBMT(val, _PAGE_IO);
-	return val;
+	return pud;
 }
 
-#define _PAGE_NOCACHE		riscv_page_nocache()
-#define _PAGE_IO		riscv_page_io()
-#define _PAGE_MTMASK		riscv_page_mtmask()
+#define p4dp_get p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	p4d_t p4d = READ_ONCE(*p4dp);
+
+	ALT_UNFIX_MT(p4d);
+
+	return p4d;
+}
+
+#define pgdp_get pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	pgd_t pgd = READ_ONCE(*pgdp);
+
+	ALT_UNFIX_MT(pgd);
+
+	return pgd;
+}
+
+#else
+
+#define ALT_UNFIX_MT(_val)
+
+#endif /* CONFIG_ERRATA_THEAD_MAE */
 
 static inline int pud_present(pud_t pud)
 {
@@ -193,6 +294,7 @@ static inline int pud_user(pud_t pud)
 
 static inline void set_pud(pud_t *pudp, pud_t pud)
 {
+	ALT_FIXUP_MT(pud);
 	WRITE_ONCE(*pudp, pud);
 }
 
@@ -243,11 +345,7 @@ static inline bool mm_pud_folded(struct mm_struct *mm)
 
 static inline pmd_t pfn_pmd(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pmd((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pmd((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 static inline unsigned long _pmd_pfn(pmd_t pmd)
@@ -255,6 +353,9 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 	return __page_val_to_pfn(pmd_val(pmd));
 }
 
+#define pmd_offset_lockless(pudp, pud, address) \
+	(pud_pgtable(pud) + pmd_index(address))
+
 #define pmd_ERROR(e) \
 	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
 
@@ -266,6 +367,7 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
+	ALT_FIXUP_MT(p4d);
 	WRITE_ONCE(*p4dp, p4d);
 }
 
@@ -325,11 +427,15 @@ static inline struct page *p4d_page(p4d_t p4d)
 
 #define pud_index(addr) (((addr) >> PUD_SHIFT) & (PTRS_PER_PUD - 1))
 
+#define pud_offset_lockless(p4dp, p4d, address) \
+	(pgtable_l4_enabled ? p4d_pgtable(p4d) + pud_index(address) : (pud_t *)(p4dp))
+
 #define pud_offset pud_offset
-pud_t *pud_offset(p4d_t *p4d, unsigned long address);
+pud_t *pud_offset(p4d_t *p4dp, unsigned long address);
 
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
+	ALT_FIXUP_MT(pgd);
 	WRITE_ONCE(*pgdp, pgd);
 }
 
@@ -380,8 +486,11 @@ static inline struct page *pgd_page(pgd_t pgd)
 
 #define p4d_index(addr) (((addr) >> P4D_SHIFT) & (PTRS_PER_P4D - 1))
 
+#define p4d_offset_lockless(pgdp, pgd, address) \
+	(pgtable_l5_enabled ? pgd_pgtable(pgd) + p4d_index(address) : (p4d_t *)(pgdp))
+
 #define p4d_offset p4d_offset
-p4d_t *p4d_offset(pgd_t *pgd, unsigned long address);
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address);
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static inline pte_t pmd_pte(pmd_t pmd);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 61de71a8ba978..03b5623f9107c 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -252,6 +252,7 @@ static inline bool pmd_leaf(pmd_t pmd)
 
 static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 {
+	ALT_FIXUP_MT(pmd);
 	WRITE_ONCE(*pmdp, pmd);
 }
 
@@ -262,11 +263,7 @@ static inline void pmd_clear(pmd_t *pmdp)
 
 static inline pgd_t pfn_pgd(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pgd((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pgd((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 static inline unsigned long _pgd_pfn(pgd_t pgd)
@@ -342,11 +339,7 @@ static inline unsigned long pte_pfn(pte_t pte)
 /* Constructs a page table entry */
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 {
-	unsigned long prot_val = pgprot_val(prot);
-
-	ALT_THEAD_PMA(prot_val);
-
-	return __pte((pfn << _PAGE_PFN_SHIFT) | prot_val);
+	return __pte((pfn << _PAGE_PFN_SHIFT) | pgprot_val(prot));
 }
 
 #define pte_pgprot pte_pgprot
@@ -485,11 +478,7 @@ static inline int pmd_protnone(pmd_t pmd)
 /* Modify page protection bits */
 static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
 {
-	unsigned long newprot_val = pgprot_val(newprot);
-
-	ALT_THEAD_PMA(newprot_val);
-
-	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | newprot_val);
+	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | pgprot_val(newprot));
 }
 
 #define pgd_ERROR(e) \
@@ -546,9 +535,10 @@ static inline int pte_same(pte_t pte_a, pte_t pte_b)
  * a page table are directly modified.  Thus, the following hook is
  * made available.
  */
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void set_pte(pte_t *ptep, pte_t pte)
 {
-	WRITE_ONCE(*ptep, pteval);
+	ALT_FIXUP_MT(pte);
+	WRITE_ONCE(*ptep, pte);
 }
 
 void flush_icache_pte(struct mm_struct *mm, pte_t pte);
@@ -597,6 +587,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
+	ALT_UNFIX_MT(pte);
 	page_table_check_pte_clear(mm, pte);
 
 	return pte;
@@ -866,6 +857,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
+	ALT_UNFIX_MT(pmd);
 	page_table_check_pmd_clear(mm, pmd);
 
 	return pmd;
@@ -883,7 +875,11 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
 	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
-	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
+	ALT_FIXUP_MT(pmd);
+	pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
+	ALT_UNFIX_MT(pmd);
+
+	return pmd;
 }
 
 #define pmdp_collapse_flush pmdp_collapse_flush
@@ -952,14 +948,9 @@ static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
 static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address,  pud_t *pudp)
 {
-#ifdef CONFIG_SMP
-	pud_t pud = __pud(xchg(&pudp->pud, 0));
-#else
-	pud_t pud = pudp_get(pudp);
-
-	pud_clear(pudp);
-#endif
+	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
 
+	ALT_UNFIX_MT(pud);
 	page_table_check_pud_clear(mm, pud);
 
 	return pud;
@@ -982,7 +973,11 @@ static inline pud_t pudp_establish(struct vm_area_struct *vma,
 				   unsigned long address, pud_t *pudp, pud_t pud)
 {
 	page_table_check_pud_set(vma->vm_mm, pudp, pud);
-	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
+	ALT_FIXUP_MT(pud);
+	pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
+	ALT_UNFIX_MT(pud);
+
+	return pud;
 }
 
 static inline pud_t pud_mkinvalid(pud_t pud)
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index c4b85a828797e..604744d6924f5 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -42,20 +42,14 @@ int ptep_test_and_clear_young(struct vm_area_struct *vma,
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
 
 #ifdef CONFIG_64BIT
-pud_t *pud_offset(p4d_t *p4d, unsigned long address)
+pud_t *pud_offset(p4d_t *p4dp, unsigned long address)
 {
-	if (pgtable_l4_enabled)
-		return p4d_pgtable(p4dp_get(p4d)) + pud_index(address);
-
-	return (pud_t *)p4d;
+	return pud_offset_lockless(p4dp, p4dp_get(p4dp), address);
 }
 
-p4d_t *p4d_offset(pgd_t *pgd, unsigned long address)
+p4d_t *p4d_offset(pgd_t *pgdp, unsigned long address)
 {
-	if (pgtable_l5_enabled)
-		return pgd_pgtable(pgdp_get(pgd)) + p4d_index(address);
-
-	return (p4d_t *)pgd;
+	return p4d_offset_lockless(pgdp, pgdp_get(pgdp), address);
 }
 #endif
 
diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index 6608162459ae0..ed57926ecd585 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -140,8 +140,8 @@ static const struct prot_bits pte_bits[] = {
 		.clear = ".",
 	}, {
 #endif
-#ifdef CONFIG_RISCV_ISA_SVPBMT
-		.mask = _PAGE_MTMASK_SVPBMT,
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+		.mask = _PAGE_MTMASK,
 		.set = "MT(%s)",
 		.clear = "  ..  ",
 	}, {
@@ -216,11 +216,11 @@ static void dump_prot(struct pg_state *st)
 		if (val) {
 			if (pte_bits[i].mask == _PAGE_SOFT)
 				sprintf(s, pte_bits[i].set, val >> 8);
-#ifdef CONFIG_RISCV_ISA_SVPBMT
-			else if (pte_bits[i].mask == _PAGE_MTMASK_SVPBMT) {
-				if (val == _PAGE_NOCACHE_SVPBMT)
+#if defined(CONFIG_RISCV_ISA_SVPBMT) || defined(CONFIG_ERRATA_THEAD_MAE)
+			else if (pte_bits[i].mask == _PAGE_MTMASK) {
+				if (val == _PAGE_NOCACHE)
 					sprintf(s, pte_bits[i].set, "NC");
-				else if (val == _PAGE_IO_SVPBMT)
+				else if (val == _PAGE_IO)
 					sprintf(s, pte_bits[i].set, "IO");
 				else
 					sprintf(s, pte_bits[i].set, "??");
-- 
2.47.2


