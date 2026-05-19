Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6042DCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574966B00AE; Tue, 19 May 2026 11:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525076B00B0; Tue, 19 May 2026 11:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DCD6B00B1; Tue, 19 May 2026 11:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 113426B00AE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C972C1C1924
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:42 +0000 (UTC)
X-FDA: 84784526484.23.961BC37
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id D470210000F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jcXsy8KC;
	spf=pass (imf14.hostedemail.com: domain of 3T38MaggKCNY2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T38MaggKCNY2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEcGnBezuQEwMCEt3W5bYotUgDgNX6KXYvPMaE0362Y=;
	b=pc8kbDddEbuCM3fJqK22+2ORqpuWSNciHroSvrxbTobo6eRPwD17jiWHPTFs21ayUTt2Rs
	2F1EXunRLBL5COhtbhat+TxYK42gW8g0etNyFCHa5gaBZhvEIYeumSKL35HJ2g/efHYP3M
	STcsnSDqGwRQ3IBq2kZdlFc2ZcRlhaQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jcXsy8KC;
	spf=pass (imf14.hostedemail.com: domain of 3T38MaggKCNY2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T38MaggKCNY2J53+8AL8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203921; a=rsa-sha256;
	cv=none;
	b=Dxwimhml8PuJMn+LXshvPoZQKs8DZbxJ8lF5I4ncyheGqhiLSUCwHJPWexwaOop7nv3VPM
	OgL7jkwBDPktoGTIMVDYPeL4HdxfWAQeJQGSVXNVd0GyyB19jQchajRhCqSr5bLU1WxkPI
	4QSXR+3NYA+92rMkjyCN+tSqqP0U56w=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48feb029961so21881315e9.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203919; x=1779808719; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bEcGnBezuQEwMCEt3W5bYotUgDgNX6KXYvPMaE0362Y=;
        b=jcXsy8KC+WlIsq65YxBoXlLrapXOREjqUEIBJLMipJfhX1gPD5UAaqRkKb4tmVf735
         zbOsQf2PipNg6b7ZKs3l7+YHAZxzkD5ZHq5BXac4jcbcMSPjwnJj3jXWjTnwMbBlSe8n
         LU+LojU0itTRNYMSCmqdlMVE4kI/n7rPs2shbz3hl1xWPoLWHwFvE+PcdJYRWrT51N6z
         hQkDSa2hUBThyAkJNmgPxKu6Cm6UjDE3Tc7skhMuFIxAh3Nn8J7hUZcirYPk5glRqcD0
         cJXSXtv0alZSkjCBb0YpMzubLYq6rfnJxOIHsbWUoSC6fO9McheRFjDLOXf/F0n+/YBm
         XThQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203919; x=1779808719;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bEcGnBezuQEwMCEt3W5bYotUgDgNX6KXYvPMaE0362Y=;
        b=QSe9AcBZHHjIZRvgzODRMz00Ne48gYKXjArRyEL52lPIsJcbEylFkX+yOz8ctxPt9Q
         0l0j6lR6lWV0RJC+Mknj0h+9jrOBygYbrKQVWuyWYB2ePUTBs1nNa33buh8J0Bbrjfb2
         DVCxPfFJ4NPhs37zBC5IaQ93+vJKGDspakXd5LAdC74gzX/i2XDkUfhX0BkspwhSD0B9
         mxCbLgKcCJsIWwcjJNN9y+ypox7Tyfgux+t1rifafKtBMIBNBInMcUNomUaHhdkzvDpe
         Hn91RqnKOLV7gxYtI/K0S5HOwp6V3VLkcwmPWfXWyTGe7bvDTlGQz2k94+F6ppboxos7
         SAkg==
X-Forwarded-Encrypted: i=1; AFNElJ+im/Iu4uHNrEUOKAXDIKmOX+6lj5BciNBbm7FI8l/PLaLF5lRIL3H6vQls/qWCValvDfF5skS0fA==@kvack.org
X-Gm-Message-State: AOJu0YxrhxLUyMPHd931n/M2wMZ1gvNGXr6SKJCURPzWWd51YKKESkWJ
	HGqpTrhiGjHtlFxalS6fUxkYhrX3W2xYrt1FP2YgZsi9IsYg2dWvj6+e4SIOeO1pfmQx+Hnbsg=
	=
X-Received: from wmqu11.prod.google.com ([2002:a05:600c:19cb:b0:489:1a41:9f2])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:6592:b0:48a:557e:6b4f
 with SMTP id 5b1f17b1804b1-48fe62f8861mr324426035e9.23.1779203919263; Tue, 19
 May 2026 08:18:39 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:29 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2420; i=ardb@kernel.org;
 h=from:subject; bh=hpZj9tDbz4ule6SV7Pe9qCHUBgjdBV9xPIuiKyNVEQo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7rLlscTzvLYmAbbOjevCUpJ7xev0pTvrw3s0BZueZ
 ivtudxRysIgxsUgK6bIIjD777udpydK1TrPkoWZw8oEMoSBi1MAJnL/DyPDH21Z3q7FHTe+b2Y5
 kpVzasa36zIhHIduB3jOl9g38ZiCK8N/x3P33asf13pw90ttVIyeHyVzWv/N67UNyRmxq6ZfUXz LCgA=
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-27-ardb+git@google.com>
Subject: [PATCH v5 12/13] arm64: mm: Map the kernel data/bss read-only in the
 linear map
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: D470210000F
X-Rspamd-Server: rspam06
X-Stat-Signature: ejcjq9r7p7j6na8cbr61dr9gmi58ixb6
X-HE-Tag: 1779203920-921685
X-HE-Meta: U2FsdGVkX1+V+AWG3vNFfcwt/ufdsBG5h7KPIXylLGG70pJZwLkYy9BaY5SeZvzDZM46OYcr79tLroOycJDysJGSlFrs1tcAWqkvqDg287gfhuIFhybq+M/vDzASPHrfr3G714rmvPxYyDBBRyVqCTDZoqJC10KPGFIp8FUBjOCWTt+nDngoXsXmvE+/BVu7aQZE3iE/vQGksUxrljB0JybI/2bbQY72Pmsd8wGFX3TNil9nSDRSLiLuN6uLsO20eD9xG4rOs03FSHAnng848YLfKRA1D8FFv7AS68Pb4ME999+WNd9AQJtCyljk+aOrwXz/etId5zywraxDUERWlpgtzKgR9fnUUyq4iluj6CWt685Kp/QS/3DlUodm0aHjXOKcbewJh8URDWLlre1YRSs2nkEiGdOpdel8jIz3OFoe+rAQL4quDsQ4jmN2yMd5XyYA6QmU0Qf+/lj05oeC9N7OeoHAeVa5xUYLaXkXGwBhrh92Rp9czo+Oxc29pSzId7D+fZpO5Q0IheNVBwDsm5RgJ3IdC873gq1aQThvzdM/p305+0oHQyQEsNPChWEeo4+p5beRQpdTyLyo0yzRvpCE8BVRhDcVJZR53cHXxQWEIj+00KYCSQuchnoZErgi1tr6YC2Bl2LAC/VHhCoo3LyouxAlxOP0nw9S7CQQ+UIuunwF8baHSV1/Ha9VLPEvQiYsjvl3qkgwqACPIe7aZ21U2kdDZ+2nmSpfMdvEg/sOfN+MsyD2O3rspREX8npdQO6U0hDTnxGpwRvYp9nxluDyF98VVh8qmAEu7WJ2tXFJhHNJVafsNavxYHLcwgLFAlMQMMXNDtMm9IvUkSiegjvCdjjQIlIBGrSedgmgm0/Yks/BgxhtPOGCMmQkY1nmI+n5psi1amL976GoQn/m/OWgEeR23M8OQHATNKtMjjUmjZJwVGjd/7qfAqZHlngqZhp14looydsprR9QYcI
 eG8t7v19
 NCNL1XhMK5BOBZJvSs1YRn24N9VnGuTo0JxnFpJqIp2P/yC5xzV2ELyHE+/MbSH+j6q8WbrC7ZGaQ2cNBA/8xECAOSlGdztg1TaIhQipWLL6+z66LLGrEcC1XijyLmYh7CmWvE5mW8NG7Xd68QblsdvrO2ZD/sImbRzcMyzeLUGWx0bCK4F2K662fcd4XmmGgS/m1CB6P5qEn/yi3g8Pof08tCGQglgITaK/FxGquqIVnKRp3fHV9iu5jUBD68kf1628c8hUxlAAhGjcp5FaAC1H4D9oCNyR6Do7DFkmF1t0dFEss+NsOH4LSbO9M8VNFzNhLQ0kobrM6YSxqRo1xDZkl9PRy6DAqDpJCIkpwC9H79+mVwBnpNlroek5/6XARCm7smhPi47UkGlt2HcyRl4uV+ZZ/rzFt/SjExQhn+a88KGQO5Vqi8Zvix7BsIWrmDGvsVs/q4BjQLJU3DIheua+Cx7F+UqPbMJkZXZHMibns6Vo/4qtrcM9G1LdpAFJF7IVgt8JaCBYLGaUMREAqs0lrSmsynry0PtfarbOqixqc0lxVd0qk1YfJDOCJpFFOfxJT
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
 arch/arm64/mm/mmu.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dcff1a538f20..136cfe0f7375 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1122,7 +1122,9 @@ static void __init map_mem(void)
 {
 	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
 	phys_addr_t kernel_start = __pa_symbol(_text);
-	phys_addr_t kernel_end = __pa_symbol(__init_begin);
+	phys_addr_t init_begin = __pa_symbol(__init_begin);
+	phys_addr_t init_end = __pa_symbol(__init_end);
+	phys_addr_t kernel_end = __pa_symbol(__bss_stop);
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
@@ -1168,6 +1174,11 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
+
+	/* Map the kernel data/bss read-only in the linear map */
+	__map_memblock(init_end, kernel_end, PAGE_KERNEL_RO, flags);
+	flush_tlb_kernel_range((unsigned long)lm_alias(__init_end),
+			       (unsigned long)lm_alias(__bss_stop));
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.563.g4f69b47b94-goog


