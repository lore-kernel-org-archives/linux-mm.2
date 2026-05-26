Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD956CD5BD5
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10ED96B009D; Tue, 26 May 2026 13:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EECFA6B009E; Tue, 26 May 2026 13:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA67B6B009F; Tue, 26 May 2026 13:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2D8F6B009D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 440224038B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:34 +0000 (UTC)
X-FDA: 84810333468.16.6BFEF50
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 62A5C40011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kk30Z5+D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3gt8VaggKCO8RiUS+XZkXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3gt8VaggKCO8RiUS+XZkXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QGcTo9f84jQQ3RURqBOJp1vLQa/oONqz3vOx7niDYc=;
	b=nJwcqJxtSuykR+3neKr9Xlg8QWHcKiBSHo6KaFPZTnUM/qbcNIiMyIe6pfvHri4roO6c2h
	SNDyfRcc5ECVQSgrTT2M48JOPb5PlTv1SWUxnXqdDU60xN/QmZZiDPHPnzTSClYrILm4S/
	HvQgDQ5sPcpNK5r/qoRyumleBI5ms1o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Kk30Z5+D;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3gt8VaggKCO8RiUS+XZkXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ardb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3gt8VaggKCO8RiUS+XZkXffXcV.TfdcZelo-ddbmRTb.fiX@flex--ardb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818372; a=rsa-sha256;
	cv=none;
	b=e8FlNjP8ceFl4WsDSN0+QG1qINnH/7gxxrS79tCyyhKPtgwmgMHc+3ORu48msmq6+SaGpU
	wWqKqPrK08fLuwuHNsXLYfuKynKLQSDSCzMOWqVWQMtj/IhSUrAVLFUL7NPaZZo3oje3Lm
	XRbV7eYFSVpkE3OZKI28NZ/fifDak8A=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-bd86cab520cso788121266b.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818371; x=1780423171; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8QGcTo9f84jQQ3RURqBOJp1vLQa/oONqz3vOx7niDYc=;
        b=Kk30Z5+DjGi/u4SgvAOaGZMCfbcpO+OM16XLy/EYXglnaBtH5x97uadRZlG5Roqh/4
         SLkPlqaIqtnoC8f9B8/eePsqbRBxZaupVUM9tba5k+44dTAcucXkh9CNaUg4WRhcy+kJ
         duMUI1dxCR3b1RD3JukJUzfOBpv41RBcV6SoY+auIt20rHz2asktRiGD4DE/9GqfZVWb
         4HNTIUF62Br25bywPQN8lEn0dU1+S1hdrmUYKseMVnu1XC7X3r59p9aOHUUWl+MDgiO2
         g1CcmIh41kzpqzJHzQGT4W0D9phvTfEyqKP08m/sJFIJQi4m0EDHJ78Lhb7dFmqvyrEI
         VIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818371; x=1780423171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QGcTo9f84jQQ3RURqBOJp1vLQa/oONqz3vOx7niDYc=;
        b=NAhMXVI/3Ogq6hGjf6C4JdA5m15eH7quoZMR8WOBiF/WsbYURlOSxkPvSsKPFHVp2F
         AWfAflOXovO6RGwHTvbNqn5ZGEu47f31OSIxLMRS1R8YzyL7+UQsJGhVIf9NVaSv8Vim
         dvDR95NuUrwEGZ5lQpSdnxk8/6Ybhg3+Ey3lG5ZYffOzKD4T2PkC2rSAIJAZ1MVFv/4R
         t8Bc/ubPh7c1hASnxiHv4boLd+xhXRZP60RGOpCQjYaoxc0/TspZLqBlEjus+dDvFX9w
         4aHQ03r6dozusrmvCWSaXUEBQTBbBxmYHGLY2lKrONWMGOciTVNLo4bJT/VzMgpM/28I
         KGGg==
X-Forwarded-Encrypted: i=1; AFNElJ+d5jC3Wzgq6PSRc9fsv9U3waV8c4855XtDC/hO3u298puyHFoIBrDDV3NLkJ9KCail5thPh3OZFA==@kvack.org
X-Gm-Message-State: AOJu0YzQmvzD2QwzNkmf8Nhq5J4gfX+ExhPv+AkT/izkXVig3e//rbGA
	TiliZc622ZJ9S49QZmORfgee4OGMkFw9GtzO3570RaToi7ukw9dT7ribvXlgFnZRAbs6yWD9RQ=
	=
X-Received: from edyn13.prod.google.com ([2002:a05:6402:6cd:b0:687:e30e:62a9])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:ca84:b0:bd2:e940:db25
 with SMTP id a640c23a62f3a-bdd22e30cc2mr1206557666b.13.1779818370675; Tue, 26
 May 2026 10:59:30 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:55 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2937; i=ardb@kernel.org;
 h=from:subject; bh=xB9oKBi8uLt+1POTvwyFN4ig92BBqhDsXz5+cc7USWw=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fhKj4MmKF6L9vM+ex9Rs9b0+/d9Nq+XeXuXTJwrky
 3esF1nfUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACby6AzD/9Dd3yeIi89KKpkZ
 tS7DjyPAYY6GxZyveRIHIpY9rS1/zc3wV6BhbVqFXb6I0JNF9ifsanP6XEOzznS/b/x27JQXe9l 0VgA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-25-ardb+git@google.com>
Subject: [PATCH v6 08/15] arm64: mm: Permit contiguous attribute for
 preliminary mappings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 62A5C40011
X-Stat-Signature: pyfao98mxqzd5yijezmh93qatmqqx76s
X-Rspam-User: 
X-HE-Tag: 1779818372-889784
X-HE-Meta: U2FsdGVkX18z6i8Ggr4WYsOzIog5wDayyZ/xbE/CjQLYxB8NsmlDtH3AA4k2w8OBIl7AL/FH51COdG2cUKL/Jlyv45o77mjIsMOJjN0iv6x1ijyrb0xZ2q+2Td0Us/GFMnnG9zL3Bq4gSXrBgpgK640gmIdaTbM9qDxh67AHnwJR+uzijTHnBOaGLRoTXri+FO7klqoL6uN5cbFcrhEMu3ZgFL+Tp46A9r02pQL0/uW4eOF1IOLm1YnuvC84G/XYTjXDX4E3Xw3cdPkpdSQk5HBAfuH3XCrOdaLHJJZL/50VLlvMADHTE655sGSkhTFwigFHCg8wNKNmzumR46kmv+uXOfx0MCXAV4pAUqkEWLhz/R9HltTRkhKyRp6KelniMrqJBsoLySDbEkRjfjwPpcfjuOfUx/GpmE4CUkbhck4R62mhcdTqc/aLNspwIlrb1VWWil6v0pTAs0nYORUkMjYYFH8sxI8TRBefiPjwipMgO0byRGxtrjxLPcaw3JE7vjOvpiEXAo9FO/8aPYljaqFfk2ibiVnXrV+red1aeqHF1UnRP4eB04u+FHhPq1iop+eDkgNzggzz8Fnr2EfLNA/OWUsJfwArvkuL4onozuIciqNhqxP87UdG+C/KZhYOFoj85p2xH/X3c6ztfgW4olzI222owhu58bb94qmbfVohND4rFq2ME2aCQyTIoKElOZDaksuD24OqfPnHbWxMitB7Z5s2f4RcjODtJYN6Soxqs3N2zlRQG7NJp+rJ1vdlGbntpExGvQhXSrt+2X2vtKxqhenet1S8IFanL1XHXG2W+snX4bg3mFkRLI/DDE/wL7Zg4BUsQ8opdIlgAcG+0Tovy1GmmtzEO/13ZeSWL0XqO1A6vvwpSWIsHT2zjlzvT6TYBzUP+vs1vDVM1DPLWDZDrpq5ypRfyNsM+PV37SLt9cn4TtfL48GnJ6CwQmkeAn0J2vM4DB15sKTbkjW
 5MI6/eFC
 kIs6bGD6bbMMRENo4/2Aqg3TRbXYNPRam+95Z3UeoADAzcupnM7Y79CFGEoxgocbHxKFZSxNhWZakGX12YZk7YXPo1iK1VwGkBAYiv6/4ct2lVRIuVUduWYZx3UrxtqINiIgBlsMJ2nak7MorBjQZ1tqrjxTxxd2YUSfsDxHrbe/yDzPB/L470Xj18WwOQwe0TaMe/EtLJPq5C06CZSabS/Pw1D7Cn2sq3uHT5nthaDL6SVdpn5bSfL+a/+VWbRSrvumt/qsCrmbw6KSuV0UBsoxxBhSmi9km568BswgizrLK43Mfoz6ZwhzuDHKU31V3EJ8nJGpJjXFSF4uDMPbXflZY5VI7CBoGSwwbFBTJ/GBQpvb42DNS+2148iyNXntqwPgS2stawEWBW1iawNmqdLr+aXG8izTLaQJNIxxPzjJiXz3KhlBDqikUm2OO+fx5JYM66GUFXd03F+AOH1tQ34/e86qoC0WEncLOfVIexdgHgPquUld4vgRw2nB7cmBkvV13r+8bZkhlwCzi45DlvqEeNZ4kT1H8sCMfwToR75rj6NovhgJpn+QVuth4y3XX5SVy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

There are a few cases where we omit the contiguous hint for mappings
that start out as read-write and are remapped read-only later, on the
basis that manipulating live descriptors with the PTE_CONT attribute set
is unsafe. When support for the contiguous hint was added to the code,
the ARM ARM was ambiguous about this, and so we erred on the side of
caution.

In the meantime, this has been clarified [0], and regions that will be
remapped in their entirety, retaining the contiguous bit on all entries,
can use the contiguous hint both in the initial mapping as well as the
one that replaces it. Note that this requires that the logic that may be
called to remap overlapping regions respects existing valid descriptors
that have the contiguous bit cleared.

So omit the NO_CONT_MAPPINGS flag in places where it is unneeded.

Thanks to Ryan for the reference.

[0] RJQQTC

For a TLB lookup in a contiguous region mapped by translation table entries that
have consistent values for the Contiguous bit, but have the OA, attributes, or
permissions misprogrammed, that TLB lookup is permitted to produce an OA, access
permissions, and memory attributes that are consistent with any one of the
programmed translation table values.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 55bb40348a47..04cc579c7a15 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1016,8 +1016,7 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -1044,8 +1043,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -1191,10 +1189,8 @@ static void __init map_mem(void)
 	 * alternative patching has completed). This makes the contents
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
-	 * Note that contiguous mappings cannot be remapped in this way,
-	 * so we should avoid them here.
 	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
-- 
2.54.0.794.g4f17f83d09-goog


