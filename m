Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B00E3CD4F5E
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5B66B00A8; Tue, 19 May 2026 11:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090166B00AA; Tue, 19 May 2026 11:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFD76B00AB; Tue, 19 May 2026 11:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DAC4A6B00A8
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E3BE120139
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:39 +0000 (UTC)
X-FDA: 84784526358.09.E56FCFF
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 955DC1C0016
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsM3gJ8Q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3TH8MaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TH8MaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kwt+xg304itl9Q4y9dyVOqGujD4Vg308m/u0QoJNJxg=;
	b=2Aw/lnKgtWBUw+5O+hZ1s7JTdwGs+4kGxfUfRcc6gRRJqpdqPu5crA9iiABakvzTfbRC4A
	meswlt8XUoOhgpHH+pm8gVffhQYRjCwGVCQnsBef8BXXnXYSujrVWUEuq2nTtTNyvJ390S
	zlkb1OyedN4gBxZJ9bfeVNCjxGV1fsE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203917; a=rsa-sha256;
	cv=none;
	b=rneEreI2aLOIp4OMDVPZBgJvXz32+G4iC2RXVWKCsP2Iu1jMPlbD9UzfGSibTkMjj73JTB
	W4PKkIlwQB1VKLn8H9GroHBqPQkFc3k0RWvB7lVmLW5C4bH5x3mbk8fC4xoYsG7PiPPeOn
	216bPF3SryQMnAE9rxNbWSlqFeRCx48=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsM3gJ8Q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3TH8MaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TH8MaggKCNMzG20+57I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--ardb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d3eec9bcso27326915e9.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203916; x=1779808716; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwt+xg304itl9Q4y9dyVOqGujD4Vg308m/u0QoJNJxg=;
        b=YsM3gJ8Qr6uQOOSD4ZoW7FdYLDACkQkBqkaR/vQgs+oWtiryVJnZlCb3ouRJKW5mQ7
         XCNQng/P0WTn+w5rsioWKX9h21QSt7El0wVJR40fbgCrlB7ii2dFQcH2wgPytyTqwtx3
         L+HeSCP7K1rymC6EzI4X77365DZEefsIHWjBX0F+yqB+N+J+PqousL3ksVJCqxlTUP8V
         /bN1x8RT61Vc2St8X0ly6YPoN765wwydUz4p1p6THexVQdT0KdHtVeKDFxohWrLHppYY
         6AK4/mw3BAz5pX53PJJODIP/TiFJ6hm2cUllZm9dRju1fSLnPRhIRSUfSqKemXQe+NxR
         H1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203916; x=1779808716;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwt+xg304itl9Q4y9dyVOqGujD4Vg308m/u0QoJNJxg=;
        b=evfs2gY+B1wUaVjiy1y1F4h3HKv8FqS1p/PMD2yPz/Ks/f1Ck43ZUCEDd6LsKUbfei
         Z9vs97rN1yQssAJOhbOmyCIgDAit2JA6bLB/IV+uaXI5pxz0a/bLJyQQgM3F4SN11UOe
         kHcS5yv9yfC2lQtexy/HjY0jSppstXVp8mS7EfDS3Ym+s6AO080d9CvW01gMEf4bX+ln
         uMlnAiqukPFJXo2tcdbEdiwfxMc3qvPdk6JtJsLQxMpKQTDxYt1SAlkZJR/0ShNSE2jq
         w9fuxsdzRaXwC2/CXj5RZEbQLuYELmJHZiXR433eaAkN1ZslsXllawm18sEsIwmL3Zbm
         EmDg==
X-Forwarded-Encrypted: i=1; AFNElJ+OXf7o4GLsnZvFWooihwdE2S08HNcRDTPcSmY0GWseKs3MBtn1sgOIksZZgEFsNlzznIBm9Bcyzw==@kvack.org
X-Gm-Message-State: AOJu0YzfmMcDixqOJuaiq1h7c5792sCyX4S5eJFA5kzWkqSFarZ7Vm1u
	/HWygoRspL5jf24RBXgI+ZaFfIf9OxJzoTdcQ5ZsfJL0KkyOcpnx6wifdCerJ68cvIb7f7OFdg=
	=
X-Received: from wrnz14.prod.google.com ([2002:adf:ec8e:0:b0:44c:f516:cbb4])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:10:b0:48f:e230:2a1b
 with SMTP id 5b1f17b1804b1-48fe6630137mr253844655e9.30.1779203916085; Tue, 19
 May 2026 08:18:36 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:26 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2933; i=ardb@kernel.org;
 h=from:subject; bh=7JrpdyvPdL1s+/ehcMcKhbiYpfIb7J1bzPCRFLZDLcg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7ryfbU3x9e+3LC5ff7rx1wuN2GTFbXOe32Cu8cvPz
 vnOfNO8o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAExk+TyGf3p7cv4pVosZ/Xm/
 ZG+Uf4emX6NSUtiWg5fCHzPUTj/CqszIsCmn+ghHSolWRsbsiRLlU/nvMRWcb3cMSLc8eOJ2yY5 aPgA=
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-24-ardb+git@google.com>
Subject: [PATCH v5 09/13] arm64: mm: Permit contiguous attribute for
 preliminary mappings
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
X-Rspamd-Queue-Id: 955DC1C0016
X-Rspamd-Server: rspam04
X-Stat-Signature: ygb7zdijyo51d8tjpnj6wm5g7yg7ugh9
X-HE-Tag: 1779203917-139342
X-HE-Meta: U2FsdGVkX18mYm9R+AqrDtT1QfMGjmQZHPJiSXJmbIudRgMf6IexVP1V+QjG0YEz3w7nijQIvA9iQ8WD2yLK+MBhkD6Xy5wUt4DcbnTP23jtORt6xG+xchBCJXkSzy8oxXVIyGu2PQSigBfTrp/Kv72Ruh9xwnXH+hQ1dEKydMQaS3Ob9I3XZWU6ED0EyGg77u9S6rnJ1b3q3QxBs1eVQTNqcE8PE7qUxBqw81LUYRKTBfAMZtFZPg4/wCAfgBgJazLqgHLbFxxwgMwYSxiX1Dv9owmgdjDid1moMTdH/eJ/xZRfPD/I1pL6qVunTo8slfMDcqOybrdADG6KXDFXoQKoGIXKoMpJgWwEDT0VFdiYJorHEjjbLUclCOL5MFvh4zBLvqIMhBuvUL4YNOOXOWVA3oIDUaCzcr6mYLPDy/kri/xZekIefU3Zg6qlZ51QoGDqZZITmgHhRrrZfUY/hiQc5WaYmFs1iTzcQXe3Gs4mwNuL4S4KEVfHQrLaNxxJ5k48f8A14sZ67c4nkJcmo3LK6PRu8VTO+9iNm29XOjQ7kx911xcLSmO3oS6wFgKwY2z1PdNkwVLDr2C3BAQpnaWk2yJ7X8P3Pvakyy2FW4LoQ+NoJewkNXu/GCCp7cSN8uaCAQ9uZlQ8xMpOtS/uGMyQpSkwfWYmkVfFKbXAfejLmRS5OBn+Mv0q8rDSsMrCT1ppKVApck1oWneprIpOiayuVVWwbHLu/u52J+vJwMvEEUrGJGwASB0n6u299WA/6213wcoXf2NRGmlCSLhmRqeGCWaUqR017QjCKW6vi7XNRyhyfF2x8XRjBsSZLhXKKx3ybdpwOqXqL4T2BHd/LHlnkKSRR9Sn38Uf/z20ERTXN7V2YXM2Pn3o8HJGUqyMepHfWEnt+J40CLADbxP3VRjDRAowHuObgTHC9mdlMh2Lg2tWD2tVmr3/ve/2epSYiB0fOxuxHNy4S/h4711
 azKk2Pmr
 Khla+Vbm9folLczOPfQ5Ep+Uxl/ajIPKjS8ZF1fn+8/yi64PeiD2gJT8RV6o1SJvQCBZAbVoGdMEdxUaf62pGoE/MqM9pbz9MLsY/VFfAawHzwGvFUTPynpm7RI6TyiZWzHHPTDv2DaqMzHZz92/rZ+Rbtkjv54jPATz6sovEduq1tjHmc/h7IoicMVq5b13HES9cob+8qiwaLPcwGHtkErnq9gvI96erhxMUOlokRlpXu0564wHuTWV75BPhiU+VCIZKckYg1/xjq2fKZW4ct+fg51d7nMcPMSoQE3bBulGlvcplNg/9TLaHhqHk+TPSikcu3uwcv3qPMpjzxFvRZI/NaeSm4kiV7G4/2N37vJWAvavpcx7jFjR8qgkZE9JXh4ccV6/6u2oV5STLkAwwp5KL3jn1AkOTxtaIDpwdVtIj4g3WsITCgTB3eSOzyQ0lDQcHpoAOmNeRE7nxiw3qSWA1tJ756LsOYafYK7MsX7/ftooNXVzBjo+zJKav9FYBP61Sg5zD1ujH3ckKEME0pwCN2r5qVFJXH+Qgl2UAJRnowUzSO2aAFDKTi+60HYhFywlE
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
remapped in their entirety can use the contiguous hint both in the
initial mapping as well as the one that replaces it. Note that this
requires that the logic that may be called to remap overlapping regions
respects existing valid descriptors that have the contiguous bit
cleared.

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
 arch/arm64/mm/mmu.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 224fec6ce9d7..d4ad9e4766a6 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1000,8 +1000,7 @@ void __init create_mapping_noalloc(phys_addr_t phys, unsigned long virt,
 			&phys, virt);
 		return;
 	}
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 }
 
 void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
@@ -1028,8 +1027,7 @@ static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
 		return;
 	}
 
-	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL,
-				 NO_CONT_MAPPINGS);
+	early_create_pgd_mapping(init_mm.pgd, phys, virt, size, prot, NULL, 0);
 
 	/* flush the TLBs after updating live kernel mappings */
 	flush_tlb_kernel_range(virt, virt + size);
@@ -1175,11 +1173,8 @@ static void __init map_mem(void)
 	 * alternative patching has completed). This makes the contents
 	 * of the region accessible to subsystems such as hibernate,
 	 * but protects it from inadvertent modification or execution.
-	 * Note that contiguous mappings cannot be remapped in this way,
-	 * so we should avoid them here.
 	 */
-	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
-		       NO_CONT_MAPPINGS);
+	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL), 0);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
-- 
2.54.0.563.g4f69b47b94-goog


