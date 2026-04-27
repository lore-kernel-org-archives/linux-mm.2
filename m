Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D567FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABA046B008C; Mon, 27 Apr 2026 11:41:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A996B0093; Mon, 27 Apr 2026 11:41:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959656B0096; Mon, 27 Apr 2026 11:41:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 824E96B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:41:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F0E1415AE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:51 +0000 (UTC)
X-FDA: 84704736102.07.1B2DC50
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A90C100019
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kQfiCSrV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3U4LvaQgKCGwKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3U4LvaQgKCGwKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxYPOVRWmcj1klY6tkKd45C/dDkcyiHdqjwOkqhsN/0=;
	b=dSEdR9/fydMam/IMcd6L35imFTR3B7Pz8BWuF79ft7k+wtlqQ4rdS8XVEa3JhqnITF7j1A
	ND7ec0kiT9oDDmRTb1KkoZUt1Ks0BRgu49Gq1atEhESNKpTFXZ7Nt5B9uubGOX+CTCcGR4
	jF/d/aJLrP8bqi+ISZEM/LOnmYlMkCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304149; a=rsa-sha256;
	cv=none;
	b=IvsjMidDXp+tabOFJeaRluSZjxbFbL5ifIXhvs4UyU8tR6KG+5D9BSrc0EShhtQI/ePp8n
	dRRalPazFycSUiSj8lEqEoh0mS+9RS/hN0w0QX2e7wkNK/CTiCKjSaoLLd/pHf46te4zdS
	6PcPZCMbqcf2sQD0virp3IY4nuHhr2A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kQfiCSrV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3U4LvaQgKCGwKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3U4LvaQgKCGwKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43efc93e4f6so8292645f8f.3
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304147; x=1777908947; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UxYPOVRWmcj1klY6tkKd45C/dDkcyiHdqjwOkqhsN/0=;
        b=kQfiCSrVNFA1ZoLnIKI6VcbTgcTt9AsmsjVF5B2tM6c9vJPpkQ4b8u7n6pR3RyITub
         7NYITyZF+dgQ0537aish4RFgqOl0bqVCnwWZb40XBAG/pj/1muOHi5pjbm/BYvHU+ViW
         FHyl26S7zicmg4BJf36nxdnXw37ZShwk4tg7u8UQrkxIrKgTHJ5zICd7Uv/zlE8y2c4k
         u5rNGOGB8XK+lSy1ZJCzjwOaKDP8UnB/xDD+hcwjyWf70B9/gbYR5sbaUznB7vukD+gC
         SbLO2e9Jv6J7QdcE3uzOgm4cIvwRhTWE7OhGzcUUQ+ZDqH2r3ncgY6bLU4NDhZ56dWM3
         LJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304147; x=1777908947;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UxYPOVRWmcj1klY6tkKd45C/dDkcyiHdqjwOkqhsN/0=;
        b=JsEsMmK6J1ICmWoU0a0vFRW2Cf6cPvt/sdF8QWLEOq8bBK4nikSdw3JodwKc2CIGUY
         SunkHYaNIUoEoMlq1l5OhwdFXC9o0oI0vifywK+8hDK/fJINyWXX3dKMcheH+t2KMFZj
         ojXtlL8nvSLRmi4+Oog2X9suHXdj9brjJ1F6YDbYPYg2nbUmWg+LkPVUqGVXaDMLWgvl
         nkYAWsUZOtBOVuESTcD8ZX5y8k3Y62UPAkj3/iIlzO11Rmcj1VwMFCV5Gp7KyDD9mj8r
         0j4FP8NcfSl+NZeRgTchOa4tgRbcGbwBnCKr0s/ioL2Rd58uqqaTiqdQO9PaMwZ3LI7W
         ZFSw==
X-Forwarded-Encrypted: i=1; AFNElJ8PIFc/gu5Fm4kaMefk+OwFt3BQnIhV6bqDzgNJtaofsM8X8f6EpCLYPyr2m2rSgakEBe1dO3HnHg==@kvack.org
X-Gm-Message-State: AOJu0Yw8wHjhCOIbUFmsVkrDL+KKdZdAX4MAxt1p6+iAWcLEJvpX9sUJ
	BFrDOp63irQ3P5V53rh/PHT30GP4gtAWWp9sNWLncsRsxaTtNdqfK+kgIxV7IV0+zzdDx1L/Jw=
	=
X-Received: from wrsm7.prod.google.com ([2002:adf:fe47:0:b0:43f:e932:b48d])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d88:0:b0:43d:6e0:9458
 with SMTP id ffacd0b85a97d-43fe3e0c779mr67106901f8f.39.1777304147061; Mon, 27
 Apr 2026 08:35:47 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:29 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=3111; i=ardb@kernel.org;
 h=from:subject; bh=vnOPgzR9gwGy7RU3jbNwlQgfBXncMvaaP3oMs7gg07Y=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E7fhjbPcgs4XVKfeTnOd6X5d81L1wd6JdtmfgucZt
 Dn6GzB2lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIlM/Mfwz1hYf8184+dKqf8u
 huwKYeCbfkN1Q8PZ5+f9Qlm8AtrWXmX4Z3804IBu667aItk0A8Wfbn81/Y/98HK+tuNd4pHLyrc 5WQA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-29-ardb+git@google.com>
Subject: [PATCH v4 12/15] arm64: mm: Map the kernel data/bss read-only in the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1A90C100019
X-Stat-Signature: 8p7q5gxo3f9g59oqik4pg5bhhummmtso
X-Rspam-User: 
X-HE-Tag: 1777304148-627324
X-HE-Meta: U2FsdGVkX1//9tyx3ytVrduDbSpx1WhgIl2oNpyr73+1kv8VB6v7EKdUOXnvNPkBdOuz7vs+p7rhqvpveOVBfbT4Ori7xdwjqiFu3ovIEIyzneRXDMuQEM9eOsnYEPpSCGmaormDZUTzgNgHC992+cKxbgejZMfnR29vqs/Bi7yWsUOobSbxsHDDescre3gKyLsa8MWfYl8jOK9iaTxcXjfeUx4xxP93UrzlZ7XbMTdbU5k1mEimV+YcVTIDLskpJv+HqtYS+RM4bKYfABb/lza6WVZ/8WiSplJ1xrmPdcBmoaN6DjM6MVSkqbSReZRC6r8IIRevjiYeHbqyJzgYppPRAGS7OS8Np+iy5KmqMuwadl7bsZuS+97HUCUwES5M98Ffzq1re6abll2MhcQX0wIfQM4hZFaXJ9QrSkzQ9iLcXAZJKWBJo8eeB8HrOuWQtDk5dSJbEydStPLuwZiRlSJVbSsxwC01sx7zq/P/u5LS611x40C1K97TrTUSdVo3+JNp1IK+SeubItOCnwQ4TNDyGAZN7PvOggJ9YZ/C1KSBy0e4QnvolVUXAkp9StfATlh36fAlNRIEsW7fEAi3nPrczHVBBGE8z0BFmTc7FOyQG/kkb2UlfCIRKi5RpAV9xRdTf5tfOB2mWyK/nH6vAhnRKFDPdSFFZOqbCxoPGJAaGYZq4oooxLn1q+m0mR5zG/cev3LoqYgAoIhwYVKbIaUet+hcMbMlpsY5hetPlokKvZ8iCc7t86of0NPhwhasFeo+vNbHHKTJV1YyCeKw8p3CGLs9OQ5v8IjpFMkdx7Kdjbr/9rCMix5PzkllmN0wJvxngVndjtoRzEbiwZiNKI6NUpQSBBVaH6E6Fjt/K9RS3Cm7ThXwgONrIRjXH9MAFHUw7GlGPMdWNWmc+n7yaijBvxBrxIu0bzFQ04OnDk+34e6J36BV3ddKJvz6WLmyws6f3nE01o9ehin61dO
 6yK/CH6x
 wyi0Tnl/Bbs/ooqX0zD5SF7MT5/jHBsj2wLhwEKdIowHwzLMYNUNI6RdMEdLNyIVM/tk6Q/YyqjnAAgccql5WYQjcrXuB0HYaFuNiNOv8opU7HczHlscX+QpfXE6gBY7DhTkK4aC36TM2hee3MJB+WU10vmSawoUTOWbGyel/6M8N1Y1NL0eTfHSRwIR2g0wK85Ojui6bh7o3ufoxVkm1i2G5GMaomfZWjV59L/Dx22ki5HeXwoi3YuqNf0hjdnITRl9wpcRlCepaVMAhPltKg4GbJ+kAdIUyXdJBgMde6CQpWicG7fK+utdg60exWAR1aisdtnBPfViM9YiRaCvfBbmVWQPjZX1n27gL7mpB7ZmFHszwZFAgomI5BQGS6lY/YubGIpqet3vUyp5md8jNoRsub5CD4lAVZzSWoSdwBtFP9HEdJNJBv8IEliJLm96VMT1zMEdpdKQ2KKcIzHYiuvXGrDawYWV4vNYosVqS4bwD0IbzGa2PxdwAX7lvY1RBy6vqFtgiIwwzJRGGv1F6p/NKAJeGYvjtxb/1gBcy3lAyAjYh6S4sH9lIQOhdbMrwLpIE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

On systems where the bootloader adheres to the original arm64 boot
protocol, the placement of the kernel in the physical address space is
highly predictable, and this makes the placement of its linear alias in
the kernel virtual address space equally predictable, given the lack of
randomization of the linear map.

The linear aliases of the kernel text and rodata regions are already
mapped read-only, but the kernel data and bss are mapped read-write in
this region. This is not needed, so map them read-only as well.

Note that the statically allocated kernel page tables do need to be
modifiable via the linear map, so leave these mapped read-write.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/include/asm/sections.h |  1 +
 arch/arm64/mm/mmu.c               | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 51b0d594239e..32ec21af0823 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
 extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
 extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
+extern char __fixmap_pgdir_start[];
 
 static inline size_t entry_tramp_text_size(void)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 1a4b4337d29a..9361b7efb848 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1122,7 +1122,9 @@ static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
-	phys_addr_t kernel_end = __pa_symbol(__init_begin);
+	phys_addr_t init_begin = __pa_symbol(__init_begin);
+	phys_addr_t init_end = __pa_symbol(__init_end);
+	phys_addr_t kernel_end = __pa_symbol(__fixmap_pgdir_start);
 	phys_addr_t start, end;
 	int flags = NO_EXEC_MAPPINGS;
 	u64 i;
@@ -1155,7 +1157,11 @@ static void __init map_mem(void)
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
 	 */
-	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+	__map_memblock(kernel_start, init_begin, pgprot_tagged(PAGE_KERNEL),
+		       flags);
+
+	/* Map the kernel data/bss so it can be remapped later */
+	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL),
 		       flags);
 
 	/* map all the memory banks */
@@ -1168,6 +1174,12 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
+
+	/* Map the kernel data/bss read-only in the linear map */
+	__map_memblock(init_end, kernel_end, pgprot_tagged(PAGE_KERNEL_RO),
+		       flags);
+	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
+			       (unsigned long)lm_alias(__fixmap_pgdir_start));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


