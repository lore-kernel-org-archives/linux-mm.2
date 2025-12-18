Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AD1D6E2CA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8747E6B008C; Thu, 18 Dec 2025 12:48:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83ED66B0092; Thu, 18 Dec 2025 12:48:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A766B0093; Thu, 18 Dec 2025 12:48:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE796B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:48:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BE4D12F53
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:20 +0000 (UTC)
X-FDA: 84233325960.14.5844ADA
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0B8BEC0012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:48:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ip+KLEdU;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766080098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5DOlf1Cpz2TADNVefb8b2aJKEHSeiEbRpZG5EwaNhQ=;
	b=58Wqd966M4BkndBctfsyJYFQhaWmMTY8BiDpYX6L2jwjwVREifutOL/oOAY1QnzGMzB+Z7
	m7jjSIH+aIOsHxNoQQ9LML5S26jccsDpgMznQZamC6Ig7WubH7GCIz3ZKgEsH+DkstMDCf
	Uo44OsklsyaMInR9qIVcRKBpnCcnxTE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ip+KLEdU;
	spf=pass (imf10.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766080098; a=rsa-sha256;
	cv=none;
	b=zOTLaNNaEStQ6lIttn6+aPo87efxJtN14ApZEA+763rUvI/ddOQcoICbfnXmM1leEO+iVT
	4Hfo7ljQlmfs6xBeE+3dc54RQXeanpBTivo5shOkAwlsp+T6KlpPAyIxWtGWr0eC2/aA8W
	teP/r5tqIahZUy4V5vTgvlcH6IhTBsg=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so617765b3a.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766080097; x=1766684897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o5DOlf1Cpz2TADNVefb8b2aJKEHSeiEbRpZG5EwaNhQ=;
        b=Ip+KLEdUgcQ0FkoXOlJAJ6kjBUuBRFZ+9LbWfs5QD4WLJ80qD9wySTaTEzwkXHF/k9
         E/adCKOwcguWdOFXPlDRYsU9oLzPqrguPDJiqu/bLRaixGav0/Yy85T9jcPfA+wsS2Wy
         zqSPffTaOMZBfi6e9JPJMf94nRDq7b1uGDPXo/MuukNbUiR6rmAmQwzJobiqWPBmNcTW
         bX68LAQis0k86+2uL5Np2rTnoBdGGJBQr/p59zizCiDtRkVgAkV81rBrRJOiKK93V+i1
         iYg9kgyCQIeizfBusPXjNHozvdoU0JhQK2cWHPNriNpSJmNj/2VIlVhNshEPUTR59e7I
         EAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766080097; x=1766684897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o5DOlf1Cpz2TADNVefb8b2aJKEHSeiEbRpZG5EwaNhQ=;
        b=hGivNBzVNBVMhzOPCoBJSTvFedCzCKcoxrcVLwIGpFRngqrYBgTl7KTlzrcTMKICfB
         b2g/xZUCHuqfIAA9Bl3dpab9BVTP4uxkeWEQsmMjQr8HfHFWarPr7unsWQcRvZ8rXZJc
         vh0XDaQqExqcXJbsJZ+AuSctHfnT1zAyPYWees0FIm+TkxgSkt/EJOacBuNwaiywlTgb
         XglsayTR2ogLhGnXjEYsacP6T1BwioT91T68+mKKtcrD8ckZ0i+7qPXm8JZLlFF2seFJ
         bbLjGSLj8Slb21MezAJvnuXIjyk972Ix4mKokPUX3i4AKbuVttkRLPRGP4uxnFKEEk1r
         uaoQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrBu/mRQeuJKkP5FfdaMhYHxpitgURPpQjnbFSKhPObnI1sqFlmHjxUnrHM/4PqXyx55tfxII/aQ==@kvack.org
X-Gm-Message-State: AOJu0YxYhOu2dU2tMeICAr3SiQfMjKtxmDc8G1d3CEgvOSopsYPHGAXh
	/3dv25C9Mhk9TSLXEHDQ4IxgEWgqZowYG5Ggsl5gUs9fQjxoCtk7+3Tc
X-Gm-Gg: AY/fxX6AFyrnsiFt60yoCxJ7TH95qn2s2s+c/PaafHMOwfw5p1yV27rienImp7IGPnG
	5SR2oyBzgjhmy0lWKVflTrv3dhrZWG9GJXYUjWo2NN2sk7VF8oAdrnHvjQBqOUo1ZnyLHDsx16Y
	jW8mbfftkubYiOyppjTYDsq5TBTxtYx/F2B7XQXdz2XSy66+lzsQ/7RJtueRol1cN21LI7wOlf/
	dAsKe757WwJhRTs5tL0PZQX9V281EtNd3MGyNUsx0zaHOu3CU/rrs7FrlviaGa/lWMtiEG0Oza3
	UT5rLtdawxkk2B2BM8LHJgHpS35/T685W1rlGg7bQjI7V0xll072f3Mpd6sSLakJ0w04UTYWuHh
	lzb/kT8pxarLf+h28yrQy/ZSU9+TzuzjEq80dH2AnNSnoJoGLeVlN/b/N8dGe6rUO0mSm3GvGXW
	t3CWNaeujRwsTIT8pdHI78qwbS7Ox3I/71ZaYWnIIdK50=
X-Google-Smtp-Source: AGHT+IFxudTDy6PHM/19N5nVub112fNrYCxZ70+830+nWbKCk8yxVcY0v9o4EOCLfhGvU4EKSePVLw==
X-Received: by 2002:a05:6a20:7d9b:b0:355:1add:c291 with SMTP id adf61e73a8af0-376a75f5bb2mr315421637.10.1766080096505;
        Thu, 18 Dec 2025 09:48:16 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.152])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1d2fffa3e7sm2847400a12.24.2025.12.18.09.48.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 18 Dec 2025 09:48:16 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: davem@davemloft.net,
	andreas@gaisler.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: kevin.brodsky@arm.com,
	dave.hansen@linux.intel.com,
	ziy@nvidia.com,
	chengkaitao@kylinos.cn,
	willy@infradead.org,
	zhengqi.arch@bytedance.com,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] sparc: Remove unnecessary whitespace
Date: Fri, 19 Dec 2025 01:47:49 +0800
Message-ID: <20251218174749.45965-4-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251218174749.45965-1-pilgrimtao@gmail.com>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0B8BEC0012
X-Stat-Signature: 1gyyg5b4ohuqpnkzjw4pejyur7n99p3o
X-HE-Tag: 1766080097-313670
X-HE-Meta: U2FsdGVkX1/WDPv1OLKpNF330x9mu52fZm9TWfqwIS9Cix85NTx14UZjhARNze4lRRZzuNbxHsJX8l1i0JuW4j7okDrdSjozk48zgK2+OKU+j5EUOHiOOiZ2lUhLEIT68rwloaHhvVauI8oDzQxrbFMpHd8dHi7uMBcf/DSO5tsNzZQtIQ7oaHayFjZ6XAHMPjad8zfUPpK9U0x5nGVvcaXH7HinTBNYqKRBOIb4Cz9g8hYGKtMzg12DMe2c/nsHFNgGVM9N3lIpMEGGC8ytIwEVnVm/HQvZxXdiWFBGfMv908kTZVhPU82DX0uYUPAJP6zodG8vVCkYUy6T4YJNqZrEuokcws32g9BRWV3j9N0AdS1R0AtMFDdSshk5gmZhFA8XwjQLxO6eGt21/NUTyBU9NM17/3Pf938/yZ4y5FzYIMUOCOlm3lG6u0yzimK1Y4pMKrPnOLAIVwk0QnOjKXqEFmWllLl4AJ+37BUoe8+6aAeS2gKcEqCl4H0GJ8EUaXDpP79/ooAvVR2VfXzG0XxKJRItuiPQFadIfahUUr/lKs9mbDgMHRO2xKnnv5iPAt81Ro6Orcbq9ybfm34NgmcF7/jTnyfBb/h7OpR62Z36GX4AcL+UK0akCWIGhsLV3X385x9wMOjrYUKtwj8mthBOAccn+qM0/I/Ss01NaxKLyjRM5rnLxaZwOjX4nuUWF6/gKx9Wcq9hp4S/P8ab3BXJenhpM5jqr5xUj13snUce7d4TCxljtodU7whiPoAAza39JlsPOkGHoUR7vC73mL/AUWawhTpJnBoYP4FiiSkOTtbJciFEkcqxZrEeR/6S9nZQN/vfYsnJPy7oDRWSlQdieZMH8ABqEchNM8Q6PA6RohZUERfcEHxs3hdbLjrjxoeHNMTMd020ErHLNvllRRaRuGJuJiObsVfOtedAn5zBJRUWgLrpDylUR1ZXGhGVfWRnsZDcQ90q1isHhro
 EN5IjUDq
 zNc9VVgC8KY7L8+w04wQYoXIWA3y+TSBsJiBah3pzHqAivuxTT27uP95cPueHqPARVlRBcGNzuYBWYr9oiAUsNKyShUkmX9W+dB/yWUHPUVMsRe1yXL7uf4hH9nu+MX7GpO0t2/+p1lJhod6P1ZXFh7umtqNWgSdVlQHQ+VZ8PkScHqqHL7JWXFKNzxsWnVYHK0Ox/omno0xUcFwvzGd6yB2SAu3dX9J5v37nhRA4djv6IhJA+A7TJbI6MzyTCBktxVK4rHEv6hzjZisl0tt0G5xQgmlh14dLmxh1IWcpTZd2WyPYx4wrKW7bFRPU/p4r7udJUBHVnYkuIsIn/+p2e3WjHvcMUCcCePo2N6SCX4zl3Zw8bS1kt8/7ddWbFIF6FUU7XNYTxENkpcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chengkaitao <chengkaitao@kylinos.cn>

This is purely a code formatting change with no functional impact.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
---
 arch/sparc/mm/fault_64.c   |  4 ++--
 arch/sparc/mm/hypersparc.S |  4 ++--
 arch/sparc/mm/init_64.c    |  6 +++---
 arch/sparc/mm/io-unit.c    | 12 ++++++------
 arch/sparc/mm/iommu.c      |  2 +-
 arch/sparc/mm/swift.S      |  2 +-
 arch/sparc/mm/ultra.S      |  4 ++--
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
index e326caf708c6..963b2c4c87e2 100644
--- a/arch/sparc/mm/fault_64.c
+++ b/arch/sparc/mm/fault_64.c
@@ -201,7 +201,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 				      unsigned long address)
 {
 	unsigned char asi = ASI_P;
- 
+
 	if ((!insn) && (regs->tstate & TSTATE_PRIV))
 		goto cannot_handle;
 
@@ -229,7 +229,7 @@ static void __kprobes do_kernel_fault(struct pt_regs *regs, int si_code,
 			return;
 		}
 	}
-		
+
 	/* Is this in ex_table? */
 	if (regs->tstate & TSTATE_PRIV) {
 		const struct exception_table_entry *entry;
diff --git a/arch/sparc/mm/hypersparc.S b/arch/sparc/mm/hypersparc.S
index 6c2521e85a42..bac194982498 100644
--- a/arch/sparc/mm/hypersparc.S
+++ b/arch/sparc/mm/hypersparc.S
@@ -30,7 +30,7 @@ hypersparc_flush_cache_all:
 	ld	[%g4 + %lo(vac_cache_size)], %g5
 	sethi	%hi(vac_line_size), %g1
 	ld	[%g1 + %lo(vac_line_size)], %g2
-1:	
+1:
 	subcc	%g5, %g2, %g5			! hyper_flush_unconditional_combined
 	bne	1b
 	 sta	%g0, [%g5] ASI_M_FLUSH_CTX
@@ -325,7 +325,7 @@ hypersparc_flush_tlb_page_out:
 	 sta	%g5, [%g1] ASI_M_MMUREGS
 
 	__INIT
-	
+
 	/* High speed page clear/copy. */
 hypersparc_bzero_1page:
 /* NOTE: This routine has to be shorter than 40insns --jj */
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index f477ab1b4f08..1c36448b95eb 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 1996-1999 David S. Miller (davem@caip.rutgers.edu)
  *  Copyright (C) 1997-1999 Jakub Jelinek (jj@sunsite.mff.cuni.cz)
  */
- 
+
 #include <linux/extable.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -2397,11 +2397,11 @@ void __init paging_init(void)
 	 * work.
 	 */
 	init_mm.pgd += ((shift) / (sizeof(pgd_t)));
-	
+
 	memset(swapper_pg_dir, 0, sizeof(swapper_pg_dir));
 
 	inherit_prom_mappings();
-	
+
 	/* Ok, we can use our TLB miss and window trap handlers safely.  */
 	setup_tba();
 
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index d409cb450de4..15f83e6d21e2 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -4,7 +4,7 @@
  *
  * Copyright (C) 1997,1998 Jakub Jelinek    (jj@sunsite.mff.cuni.cz)
  */
- 
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -62,7 +62,7 @@ static void __init iounit_iommu_init(struct platform_device *op)
 		prom_printf("SUN4D: Cannot map External Page Table.");
 		prom_halt();
 	}
-	
+
 	op->dev.archdata.iommu = iounit;
 	iounit->page_table = xpt;
 	spin_lock_init(&iounit->lock);
@@ -109,9 +109,9 @@ static dma_addr_t iounit_get_area(struct iounit_struct *iounit,
 	case 2: i = 0x0132; break;
 	default: i = 0x0213; break;
 	}
-	
+
 	IOD(("%s(%pa,%d[%d])=", __func__, &phys, size, npages));
-	
+
 next:	j = (i & 15);
 	rotor = iounit->rotor[j - 1];
 	limit = iounit->limit[j];
@@ -150,7 +150,7 @@ static dma_addr_t iounit_map_phys(struct device *dev, phys_addr_t phys,
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
 	dma_addr_t ret;
-	
+
 	/* XXX So what is maxphys for us and how do drivers know it? */
 	if (!len || len > 256 * 1024)
 		return DMA_MAPPING_ERROR;
@@ -185,7 +185,7 @@ static void iounit_unmap_phys(struct device *dev, dma_addr_t vaddr, size_t len,
 {
 	struct iounit_struct *iounit = dev->archdata.iommu;
 	unsigned long flags;
-	
+
 	spin_lock_irqsave(&iounit->lock, flags);
 	len = ((vaddr & ~PAGE_MASK) + len + (PAGE_SIZE-1)) >> PAGE_SHIFT;
 	vaddr = (vaddr - IOUNIT_DMA_BASE) >> PAGE_SHIFT;
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index f48adf62724a..f43163a9a812 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -89,7 +89,7 @@ static void __init sbus_iommu_init(struct platform_device *op)
 	iommu->end = 0xffffffff;
 
 	/* Allocate IOMMU page table */
-	/* Stupid alignment constraints give me a headache. 
+	/* Stupid alignment constraints give me a headache.
 	   We need 256K or 512K or 1M or 2M area aligned to
            its size and current gfp will fortunately give
            it to us. */
diff --git a/arch/sparc/mm/swift.S b/arch/sparc/mm/swift.S
index f414bfd8d899..cfcc48b6c5c7 100644
--- a/arch/sparc/mm/swift.S
+++ b/arch/sparc/mm/swift.S
@@ -243,7 +243,7 @@ swift_flush_tlb_page:
 	 nop
 #if 1
 	mov	0x400, %o1
-	sta	%g0, [%o1] ASI_M_FLUSH_PROBE	
+	sta	%g0, [%o1] ASI_M_FLUSH_PROBE
 #else
 	lda	[%g1] ASI_M_MMUREGS, %g5
 	sta	%o3, [%g1] ASI_M_MMUREGS
diff --git a/arch/sparc/mm/ultra.S b/arch/sparc/mm/ultra.S
index 70e658d107e0..66cbfbb1d3cd 100644
--- a/arch/sparc/mm/ultra.S
+++ b/arch/sparc/mm/ultra.S
@@ -284,7 +284,7 @@ __cheetah_flush_tlb_page:	/* 22 insns */
 	be,pn		%icc, 1f
 	 andn		%o1, 1, %o3
 	stxa		%g0, [%o3] ASI_IMMU_DEMAP
-1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP	
+1:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
 	membar		#Sync
 	stxa		%g2, [%o4] ASI_DMMU
 	sethi		%hi(KERNBASE), %o4
@@ -312,7 +312,7 @@ __cheetah_flush_tlb_pending:	/* 27 insns */
 	be,pn		%icc, 2f
 	 andn		%o3, 1, %o3
 	stxa		%g0, [%o3] ASI_IMMU_DEMAP
-2:	stxa		%g0, [%o3] ASI_DMMU_DEMAP	
+2:	stxa		%g0, [%o3] ASI_DMMU_DEMAP
 	membar		#Sync
 	brnz,pt		%o1, 1b
 	 nop
-- 
2.50.1 (Apple Git-155)


