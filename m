Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3A2FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870F86B0088; Mon, 27 Apr 2026 11:42:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821BD6B0093; Mon, 27 Apr 2026 11:42:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711066B0096; Mon, 27 Apr 2026 11:42:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3896B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:42:03 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C00139FA62
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:47 +0000 (UTC)
X-FDA: 84704735976.28.9A4BB5A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id A9A6180006
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duGMHPd3;
	spf=pass (imf30.hostedemail.com: domain of 3T4LvaQgKCGgGXJH+MOZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T4LvaQgKCGgGXJH+MOZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BA/E6WicDwezK3gyiAo3eqUE5pDQu9c0JrSuIiaUTE=;
	b=2Pnt4q3FmzTsIMBtCxdch5kP//ey/zUfMOe0BLbz5a2EsX0A120yWCbQPu1Za7P9XAs3wg
	CLKtTamhEcVgVPyZsSqsFp/Nb6/VRWNFFqzSU/IXOonDuBwietpXVXc25XUcBvROx0HhXu
	jgXcwYdqmEYbczJNbOvFp142Ups/TiI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=duGMHPd3;
	spf=pass (imf30.hostedemail.com: domain of 3T4LvaQgKCGgGXJH+MOZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ardb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3T4LvaQgKCGgGXJH+MOZMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304145; a=rsa-sha256;
	cv=none;
	b=NWXTEWfwykR+trzNaVRvcFDtbzZNlY9or/nsAoI5uZYClQLNBD2C0dNvNzSfe8UpLDKctN
	mYx0ZPWz8eslWZNq4J/KK8Uwez95cB+xlw8g1zEn+n6LcE6rkpoKaOCgeXjpGSRArHKjEy
	zsPz7sWrjr1L3xhrWbWgWdtLIDwRjp0=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso112810305e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304144; x=1777908944; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1BA/E6WicDwezK3gyiAo3eqUE5pDQu9c0JrSuIiaUTE=;
        b=duGMHPd3YhRBtMr3tyi9p7gmL0qUPhkKjpPBPNigZPux+sU/odhxDXkDEJw7S63Bvb
         vwQdFpAgC9tU1CL6GvpqUV6WSwFJMbxm+rGPPwxIxNAJ+k436796wUmt6Oi7wOcPQpnq
         g4ru2rTXUT2R7LSSK/iupqsokvXhxhY+4NC1xB+QEh8WC1RYp3AI8llYl4rkCAS+FzsD
         d0vxDsdZi5bEKJLYr11ylpcV4PrhN7qwra2I1PEM6j5AxjaAG1zkmRxByyZo74Arc85h
         DyC+RQpGUygtpPtilWHYIWCC6ogSFdtiUehAOMBQUAF0P0PhOoQ09Hr6LQmILU8qXyyF
         6j8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304144; x=1777908944;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1BA/E6WicDwezK3gyiAo3eqUE5pDQu9c0JrSuIiaUTE=;
        b=H2Z0rtu/jXVT37vsuRetoGOMocJwg4IEF1BrbSb2eBq/Rrf/8fntBubXLTPy4L+sHW
         QmSQ5xRgnBoWhAAyMhnYqjN/VXe58UnU/zwOQuiZOGzGnEFAjoW3MmbQ4wgeOGVlDOgW
         +d0u3fblPACRG8FaqUI1o9P21hgZ7XoQGu2OIpfOUHumn+6U0nnp1LsJLrntHji4753T
         8bGOy1sntXTJPmq2fPTIlDe8oJ9tM/Uv4sHNLVA+ACXfL+yTaJUzPm6UeahXMm0lisiP
         /YGOKUCkKHA6BDsC31C/iwCCnGvSxKyP2RR+C9TwCwkzCj2o5QP/R5p51ct6CfSMhQbL
         6f6Q==
X-Forwarded-Encrypted: i=1; AFNElJ9R8ox3teNgRXTj/+c12Aa6hqsV23XmTLuW4JLmKqNOa1fEQ376XmD8Dh2ZVWuWu2SbV7+qRpSqkw==@kvack.org
X-Gm-Message-State: AOJu0YzfPFlC2dLmOBFyW0a1hijExXkOGtHfhSePw8k54FTZFJRRzDF2
	Msdm/wsSqE0oQTjHWDkqDInm3PrTegfdq2AlUhkM09D9z4lOIsgpGlcVjy2SMBty/7jypmGT2w=
	=
X-Received: from wmsl15.prod.google.com ([2002:a05:600c:1d0f:b0:488:7f4d:30f4])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8115:b0:488:8577:d9cc
 with SMTP id 5b1f17b1804b1-488fb77faacmr552964815e9.20.1777304143994; Mon, 27
 Apr 2026 08:35:43 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:26 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2895; i=ardb@kernel.org;
 h=from:subject; bh=KZuPOnzhvCTYIkGg+7u5wsbMT7w/fODSH3EL/0/zagg=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E5vLgafBpVHCxz1SUmelxP6Kd3qkdfpFsMXLg9sPF
 WoserK1o5SFQYyLQVZMkUVg9t93O09PlKp1niULM4eVCWQIAxenAEykTJOR4TUXe41Hw4vaRzxT
 mGLXWVx6se1hW1uOb3v81vdLAn5m5jP84ZJm0rae256UuMVmRe7sInHmbY93p/Jwyz966BT+h1O dCQA=
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-26-ardb+git@google.com>
Subject: [PATCH v4 09/15] arm64: mm: Permit contiguous attribute for
 preliminary mappings
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
X-Stat-Signature: t9nbdz7pbh7pg115n1emncuhbtim3fu5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9A6180006
X-Rspam-User: 
X-HE-Tag: 1777304145-259681
X-HE-Meta: U2FsdGVkX19C84MvULyETdJRFKS9fDuE3OZEE0jVoVxKMnEO7hF/eZrXrMBWeSyxjsblPqKdT9d2kefZhxmHxxr+Ed2plXWUL1OZYZjjeCSliyOseAFxQ07v8gUVPt0OmWdS+rsvGQTlkXIjetKTVpfV6Ug5z3/PI5V0y5kbljV11E96iSaWK7zR6ABMtQ9xiS0P9+JBnJg+ZLsjSQCt+PmBFFHl/8wwcoO1EXfywEEtY9xaUuSf0syUj0QTUC1PmVIIjwfaQgXhe2ZaeLT9guyx89TK9wOGp3ZdJ1aq8HDY2N9TlaQdUtC/JmrxozBn18h5fvoOFB8hsBveQHW/AQDXdpGjVtRN4CI4bokZ+yu9DCuBbFiQ/lQC0pVm4P3S3YNHL4vJuSuKgeV1E1WF8ADUF1+kms4A0AS88FjugEq6XQvq6ALkvZ20Lpva/VrFHvL89TB4jOXpnY9DWLDcbjxV04NpchPIQ77US5kgpBj5c7iwJl8MvP027Z2SFr5x9Dneg6Rj91phrSH2OiJhH7we/F9M5aSInsYsGtvugPcuzYv/y6wtmTz0tqD4no4RQEaN/H24LWeuSbpaWdRhVOyueaRXCKGJTOecBETxTn1gGNcVJ9B1MaXPWylhIx5hgVdRYLuvVMpiZeGB6DiLYTcZz+Y/f6IVKbQo1rBDwEaFVpUQChtafd1ejkXtwJaYfq3gkZoZzwQkIiraoZF29n8nhJfeH//PWz+ZHE/q0yC14wfZRzG6G7v6Hf2KPFfXUnNdIVaJQLzYpJhg3+FZYeNRGzn1swvVFXu7k5v/H0ecc5s3tAg41xX4qfrIobYDqwT0wugnc4utQ2J08dbxXSAP7Gq5zTj+V6qSjbATtaRIVev+1LrXO3njMLaOLq0Nnz7gpXsu+JNVfhfmJGFq/i12LG9luLso6d3C5oOaw89outImi3rrR2skg5G57uVNOCvx+VC7vtTvYXBl0zI
 3AWualf2
 77rESAdVXTw3OcDtsm5BKzFTeuLBbYzq//60k2F0dn2kOvbuPLGyP8i9G4elS9EqZyBG3HgWTarsLlCaLhfpGxxGNTr/5GgxZ8loxYGlBmvb/77rZ0zthXXvo6WahLOzpfvvKDJ/aN9AtbutpQM3NLwme7+1ic+XO/VD9mRI0sBjavsnhWJsqLCqCheht93HrpTn4FFU/OqorS0xFepcRtVI17uOw7954DmTH4nFrw17l/Ov0du4oVaq8zSxD/BDGHGgA0tlr6y/Qk6Ui47OiOJtOhGAIVXpmFbisWSXXcAZ0RjQEUbL9Vbi7yq3L/TvHLuoGKe4YjR4kFkknVC6jjBkpKYHEhM5JSa2I7FDq96CzRkJ9sMJlsrX6tCILiGun9FjCtI8YbWTxGLspGbIY12IzjfnrSfpV4sYkc3Q72pO3hlVdVmH0tDmnwtAaAdAHPRrzhSaAtlK9nhZCl/yBGALLQ3NNqTPWQ+RTAZOmSbPGUyl25m/ODp+Hz5LdaXhWX1RLqfKRSGmJu3T1QLGocX89VsrFBUz3/mUNtyI95JBp+PQYON8Na935BskilwmogzdinixRCmCdacH7nGo49T2HMYhsxEBDj11RHtnIiSFcnsx8/1KnsdCk0upQRxsI6z5lTdGpcljUL2pbOE7KCzr1Ig==
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
 arch/arm64/mm/mmu.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 4eab40f4aa6f..5e2348b15783 100644
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
@@ -1175,10 +1173,8 @@ static void __init map_mem(void)
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
2.54.0.rc2.544.gc7ae2d5bb8-goog


