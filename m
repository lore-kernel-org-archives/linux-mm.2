Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D69E5CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479266B00C7; Fri, 29 May 2026 11:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DC876B00C9; Fri, 29 May 2026 11:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E15C6B00CA; Fri, 29 May 2026 11:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC0F16B00C7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6070C0A9A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:32 +0000 (UTC)
X-FDA: 84820773744.11.5BC5CBC
Received: from mail-lj1-f202.google.com (mail-lj1-f202.google.com [209.85.208.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id 80EBF40017
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D4zryxbr;
	spf=pass (imf01.hostedemail.com: domain of 3hKoZaggKCJc1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.208.202 as permitted sender) smtp.mailfrom=3hKoZaggKCJc1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs8UZJaaGpDG2dm36q3rutkvNlrSNXe/Bj9mb4oSyno=;
	b=HlNMu7WCa3j5UFCfIfaEKVkP++xJ4tD9+h/TPqjni/XzoyYn8eEPPBne+/uDM4pe0GR7pS
	QFZzY916Djy44Ed7TKv4A6aabfW2f2LnZUnEdrIvQps8lLrMsq7dq0KQbfA/cW7rD8Kq1a
	vuQuAyPpwpxGmwelBEpLwve2QZ7pAsE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D4zryxbr;
	spf=pass (imf01.hostedemail.com: domain of 3hKoZaggKCJc1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.208.202 as permitted sender) smtp.mailfrom=3hKoZaggKCJc1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066950; a=rsa-sha256;
	cv=none;
	b=CeWI6vUovHtgaNQdaOVjHpdUSFFPkNGp11nKR5E+7ncI+kD7czymlAeTs8GQffnHixnG40
	aOK+DfExPUny+/AubdYTZwUFoiZvs3IaGEDb7XbDMsiG4nLUrO0P4Pc4Kje1HOFmWbVBfp
	jedrgYhvQuas0AwDHpJo8XJfxz2i+kE=
Received: by mail-lj1-f202.google.com with SMTP id 38308e7fff4ca-396623d338fso775741fa.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066948; x=1780671748; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xs8UZJaaGpDG2dm36q3rutkvNlrSNXe/Bj9mb4oSyno=;
        b=D4zryxbrUbsomVJKByUWXs5v1w6YhUGeJ20R89h52X7J15pL9wPdKioCybJTBkFW2j
         K543qJsdS9sR3xGMMXOGO/YpGZaIwvuAFpJwnImB3308qR774nBYdEHB4s/ywb4HT21O
         k7AKvkuyQb6KK5SDlVz5iQ0DnMpvLfjQci4hMzTHJ8ID4V0qUHpLRx+WmNTAW5czL3gi
         jBUgGTF7EbnIfdkcBaJf57F/yfB0MxqXu44RaFjU2Bt/+L+MMv86l3WmPnn/npBvzlWy
         K+b65lBGz0d240IkF3u98XH+4DjiDri9FBtlbfIAQ5OfJjnD1+9xwlHljxPpr6M+Bv7n
         CxfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066948; x=1780671748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xs8UZJaaGpDG2dm36q3rutkvNlrSNXe/Bj9mb4oSyno=;
        b=jw5d6BcOevlIwsnCAq8s3vIz8Ml2obsIiZ8aS1hRI0QgUPYiy6hcSxszFnkqzOzF85
         wjvcpNYKMgdpSbIYJ/zZcCZ0DiPd6RwIb2TI6uYf1eqQZWIZZxJGfZIZtslgrIs4KDSZ
         +v/OrXbibCNlAZD38itcaiz7M87j7Wu9C3BfQ04HYvmi0vm97qTl0DGAbpqfA11iR/Qo
         xVvmXSI+XSzgxr+Cxr19JCcbw0eCKdzweZxu6qa+segsLU9lAGLrZBX4mnkLN9xSMmPj
         DJ4OPYpPg2kRh5xL62TAyuNVZ3C/kNqRtKM444LbuOfTin744w7OZN/FPPvS6+C3GYL8
         C6xw==
X-Forwarded-Encrypted: i=1; AFNElJ9Q0ubYJ8AQWeWrAQtzgPRQmueRdaC/mL+SR+7zT/CGWfjuwl9smHTvtTbbji+/47uAyLwnzJ3kGQ==@kvack.org
X-Gm-Message-State: AOJu0YzGLbvgz/Pnea8spQO1kXCHmQ3OraMdedDjI766qbOh+7uC3x2e
	6Zk4c8ruaV9Fs0Yhen/o1pbm4EPtbpXz29ZBB9EJ+stAbhmplZC3yxVrZoBesP9a7jWhr9Hf8w=
	=
X-Received: from wrjb2.prod.google.com ([2002:adf:e302:0:b0:45e:f542:3761])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a2e:990d:0:b0:395:ae3b:3375
 with SMTP id 38308e7fff4ca-39664e981c0mr41301fa.2.1780066948187; Fri, 29 May
 2026 08:02:28 -0700 (PDT)
Date: Fri, 29 May 2026 17:02:00 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3242; i=ardb@kernel.org;
 h=from:subject; bh=QwDzTM46GdUE+NivIT38dC1HutxUWa2GWKTenTtP7nY=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVWb2gvjDypnblG6ZO3Wv1Bft/jrhexd79oV7t577u
 RU+EnfqKGVhEONikBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABNZI8zw36neUKL4j/F/nsar
 u7+2BlcevsMd8uPEywc1ppJzt9RzHGb4K8J9S++osuTMJf0rlUt33Z06V/Xzwox9+yqmH1l/Qee ZAysA
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-26-ardb+git@google.com>
Subject: [PATCH v7 09/15] arm64: Move fixmap and kasan page tables to end of
 kernel image
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: fsdxejh1teabxrg9dx1e7kt47u7wof8c
X-Rspam-User: 
X-Rspamd-Queue-Id: 80EBF40017
X-HE-Tag: 1780066950-338843
X-HE-Meta: U2FsdGVkX19hecbZ2gzllLGqKu64XWH0i3ILKitlUGUbLKkHI67ggln6fLTa/6qdTOg8BM0RjSOygRVlWjHicbHfA4wnEUebpcQLKWsgDqHpwGF4oVyH7yctFj6VNgmAwGYVPQkGUbNes5ll2a93SMjeNvZlaKKXdKQxmsLEseCIIuCajkz5t2GXgnF8Dm+BApxw8wsRT+ZpiobMSos2S0P0C2dY7NCDV5T6r6z8JpW34eHvUH+RMt6R+FHg7YHH7Go+lO8OQCY5LqRIqLKTAGCCTVKwlGRR14arYM0xXBbYABq8ujPlnYkJMMPZYk1fFXWfsYiJrrdgbURw/N/YX6Scz7dQsg/jYomKV1bSd76tjhA7VRD37b4MoPKiGbyhhtJBqwUgo9ce5p4rv2Fn6gnWjAJA3UKA18ULXxNm50PYW80GE9wSm2M1cVQ/aRkQ7kAHyV/pFT7spetYuGM2Uyt22eOLmvGHaJtCkDgZZU8FUNpUnoQXVeORLeFc9XpG0cm/6WLCz3iSnMfPIQuiVZiIWfHB1jmttIHhwEzN3vtZ9qELwQP1k3xDv/QveqxE1SgBk324dd+QGyzP8wWbY1gq4zu5Di6Cx0x2G1yjNXdiIaWLklGjgdyr1LITzMmI3BKT2sppB+JC/moYCUs+wb5Ja1QC++y6YOKYnP5lJESxbYinl6Wl5rgeIYL9PtnzW95vfMeJpXQvn5SCTiuKFlPEll90L1ulCCJ4D2GFKr+A0qjHlizeTRdzjNP6e+Cs5ZaLGlobQoeKlLp5q8RnyslfgrDOXW9nXSnnMqlZlZpAq+NkKyNd1JQfO6qOmoq9qFpltiFa+K0G/+5Tp8iaBzQsXeyhbcCEUrkDfIC5bDd2zUSplJKxl9/w1nuGEdQqn2/+vvxw4lP5fQP+/8McIgzOHQ4ZEaEe2QX482v8xPbadr1wl8XVBBd3KqZM1+dI/pVIOJcQ5fqzKuo+8zt
 XVMkPkSI
 Q3OFMxfB4RlBRSI1BZSctb1tEStr6Q7hYTAwVbeMH68ECl71olUuWP/AkZWo53BTOPQCyovUAAwOtvoqTPV90tQEEg/ob55hBXZuIaP3jcDZ6v+6IVxur/oFtzzDD4NudoRFxG1a5iLldPx6CLl/6qqLyx4wb7y3f1BUTu+eh7ZNmYmUsDa7aYWy7DN3ocX5cbgTetDLMIP3J99qUzBxxsm8jh8J3WTMljjEi6SIs4E1p90GWhIMzo9hl0tAVrITJFPtMhhFNqJvwkpx5YSEDXC+vmLCGoJFVLGvqTzN0fIv9FtRPE24oPpS5b2T24fgx6q6mtp8Qm25WoyRYslJEwaPavZzsRnv0QlCKdJwH5gq3S+QYhMH8HQ7rksSt7KC/yThw7ysYJ1n3hD5AhZCtN9Fvb5hiQlBrVOFJbxbgIezit0NY1lglW7MKC+bx3Rd3mrc8uBNzDbBz55kZjwkofaYJ1ED0kF0r3nAF5qqAxDis0t5wlpb9HKke3YLfIjFOKcmjvDG62wIthNizqnFmxWgRf9Ga7PQ0tqa3Q43k2p8fEhk0LpP7FtZakp4U1H4YtHTIqkLpOFFkDvG3w2MAbSyBvqn22meAkyEy/f2qwoLh1GMt3IsRUwbYf/p5Ilwp9liRyKxCqJ/soTIY63yM+O1o7YRP9J/jpYxrSqe8ST8JZTc=
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
2.54.0.823.g6e5bcc1fc9-goog


