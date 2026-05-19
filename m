Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91005CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D26B6B008C; Tue, 19 May 2026 11:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B8F6B0096; Tue, 19 May 2026 11:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5786B0098; Tue, 19 May 2026 11:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA3E6B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB957402A2
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:19 +0000 (UTC)
X-FDA: 84784525518.17.531FE66
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 02FBD4000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gFddu/XP";
	spf=pass (imf07.hostedemail.com: domain of 3OH8MaggKCL8fwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OH8MaggKCL8fwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=psqo5lxuXKrUhh3uDGGTtGkdaLsuRg1me0VLpzKluKY=;
	b=bw2qi1oDbRZUqb82a79C3jrJ/BQk5qWwQ2iFZIHEYhmfXQ1o21pySiM4u2TRLpp9kGvXdd
	+cV1cq0zr2w6Jh52pfYZ5yz4Pac85l7a4wGIzsoxO1kul0x3kw4evcyqwwDLR0H9fkQNE+
	QCadSBbzpnnGIHdP1pRIvSgU9erKRLo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gFddu/XP";
	spf=pass (imf07.hostedemail.com: domain of 3OH8MaggKCL8fwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3OH8MaggKCL8fwig+lnylttlqj.htrqnsz2-rrp0fhp.twl@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203898; a=rsa-sha256;
	cv=none;
	b=f3MEbugYO1S/m7iFUopAix8b9CBa1vWJSi6BAdAzvIicAHfB9fa//ZxNy8+lyw0MqZO/gB
	UUIn9eNKPrKLejc/ZERGxMtuVn01BYZoiPfne4GKCsHyMiRNAuZLeGA6HIWzpAqbQnoW7x
	Ds7RjVOlRUZCsDjGBG8FZeGA+SFXh70=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44cc3c9b2feso3751883f8f.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203896; x=1779808696; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=psqo5lxuXKrUhh3uDGGTtGkdaLsuRg1me0VLpzKluKY=;
        b=gFddu/XPmhtooOtIgxgX2SaZsU6ntkA+zgQyAZ/br/Nz8aa4hZS7WvC69V42AE92CR
         YB03GdDY8mtTerRL8sd21YU705Od+8W2sVM3OaaZ2nQ5Jl+yLEh90YG+bk8b3O7cvedV
         DmPpYe0lYzDrIF/ueEq6YxcSviGVqeRsvglRaVlI17hHJL5Z8ZOVEYuEf4AMj0APVB75
         qvurgjfuNQB/5LVktQKZXJ+opqptnJwMwXDTPPOptGuOZCjCaf3mxJ/U4rDo61gxoQk9
         4IJ1y3z35F2+m+xirU8A1jj3JCbzJkcVBQbh2AlfOH7tMVwDfUsZC2pIjjj3aAwv+a/5
         qyag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203896; x=1779808696;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psqo5lxuXKrUhh3uDGGTtGkdaLsuRg1me0VLpzKluKY=;
        b=lRD7RoJcQsIshpQObCuilYtGa7dL7iWBOFT2Um9djh9AhfLXdiS4VSL56xicH/SrFb
         tSOmh+5eqENUPl1KGpE+mr8S9idWWBnnYLSvo4jl/SYzwAJNzmUzEAqvUZT1IfvcilKy
         MIqWUbbWD92ErjZqH8ZRy3W2BXNn0ulJTsaGQr4G2GdyEjB62ZUB+EHs4CidGbk5qgS5
         ZeRpKOWvneMOutG73cslnFTvkk0Ph21OhokpxNG0uzPF661LxcO0r0D6+N9dM7j8d3HW
         MSjSnbCfD7aKeTYSXxjGuVosrD1NfzylOIucb5u5ZRwnGLJH4R3G/+fXO+EQQmx4oMMa
         iH/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+pTrSA84v66C50hbdw978IHWLUP/PF2a4QMMLDBQihCnMGiEimKHPaK0lfTUI5j16KKPpQbyXupA==@kvack.org
X-Gm-Message-State: AOJu0YxmCM+DYxnKuCv8KAvGhVpg/5ERWU0MHwzwPaVv35LH4P394PXU
	uh21rVfNXynVQg5y0P4WntWtdxGpJHHVUnoHR+ohrsVwWES4u3EFZcP5ExTDsGPFnZdayhV4CA=
	=
X-Received: from wmrc10.prod.google.com ([2002:a05:600c:aca:b0:488:7b85:acf0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e46:b0:488:bc6a:528d
 with SMTP id 5b1f17b1804b1-48fe632243cmr328900025e9.22.1779203896424; Tue, 19
 May 2026 08:18:16 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:18 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=911; i=ardb@kernel.org;
 h=from:subject; bh=uYqf26ha3K7mBUMG5pQkMvA1333YXFAF+bz49QK3I9c=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7nCKotCqPVHbJlU/P5+WPXNtRp6U1LQXbxdfmBE1Y
 0raotU9HaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiOm8YGdZPT5zjozhLrdzq
 W9rh4yk/1SbP27vU5sihNukc80LNiGCGf9ocz6d5P87N5VjR8+WxStrSZ0/T/5+7djo9/dI6ySM 2HzkB
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-16-ardb+git@google.com>
Subject: [PATCH v5 01/13] arm64: mm: Map the linear alias of text/rodata as tagged
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02FBD4000B
X-Stat-Signature: o3uxgdsfiibjmypt5f9i5wi31fdumh1o
X-HE-Tag: 1779203897-55452
X-HE-Meta: U2FsdGVkX1+fZFb05SrSoprumikpr3u1Fq5RjAr3A7kdu357q+KmVuf/7/jsszcjqH+9shfXvUCdlfxCfz4ttyUXuoZV0DAacoUO8WZvpar1FNgq4NL1cEqW+O0DonaOtgEBTr8GynAl8JWggkrMfzQfPdTIQSYde+XgjysjNLlVPVuVF1S8pQR7lJpIBXVP4QZeh7Du92EukSihd54a6+TsqggApwSVxcaLSI8j3dCmH7Txc34hkurxa6Cvm+3X6RDh+nFpOW3pf/Dcr+/NhLL4WvzB/gHrJJIrTo9OUxm/8CYlvg6ao1lKSa1ddqdDmyztas2N0aSS06u8S2hlTOjnwWAXa3t/+C0mkZIfcLG/YfFeTLxQ7QnFz5v1uoNscQx8TvBzV2/dvZ+VM5TMG7cqEAZgPeYl7mwh2oEqFzlZ+ckzS5slpXVD5SIXe3GouvXimU31FkjLGvfiqpAHUwGKaqC+LxQHXTAqRGq3nxpmfZY0yWxeiLo+sm0B76mAUsPx3tc71vbfeId7Shxymp778LGAhduEqIgF3M+VxqJTvPyIRv1I8DV+UDGdGhWq8vnr+x59p+lTWOAkGfhHXDt41YzBJi6t+ahH9qvPpt6BcYtIlNGmZVMCYZus1PQ7JrntGTeKPoFN97lhWEHk1rv9aSWiFWDjaM2ql+5xXLaq7XaTnjJDCXsZEAYXro95vSrggoqfsdwMImyRvDI6mgsFsBARw/ZNF92KrwSpTZ0sX8YjZphQx2zV04QT4fr+9EMvzjObw24lmzqbgklayrpq4okGdtpeqQ4CPLY9IF1KzvY9j/DfI7y9ze3w3Gr3SWvUFjnIKJ361UWt3sZJ559J8GGXFJZmbShurMo+AFYfnb1j0dd3t0nuAF9iyBfYwImlSiRb8dq1CKY56PX9Qqx+E1KIVsWrId+eCaqno2IqRkdmIixtP31kWlCmOXm6Q+loEht9X8l3fyGNxFr
 ljW2Hqjo
 viA7TsVKXImPLUhL4DPHa3t4EHzgrhq0j/UfzeSSwN3A26QqPPx8BWv8bozGk4Q/csC27EmsJoaSuahIO9ThDNT43rbvi/yhd1YKLe5GiRqduqMbn9Ew0SDhpAvi+34/YyRbuBRm8zz5oNV2qQ8kZdJ6PyOJb9ciSjBTgW+A48QFdSFjJ3bpk9L76O9HvDEtK2ZHyuD1PvgU6S1rWqWYy3gJKEy1kBuPGGwQuBhhjVeoP6/OdOPGkZgIgJUNW44wifzNJcxEy846Tzre0zMNNJZIHvHpWSU7tdevomNyYVyyi9YWR2wV9ka1ulIvh9RnLJjV0R+ayBcHTBvYZgzRBV0LaWFXY+pVKpAbxi2pv3mAzwNSl0quxVUoxGbHn+LqhzmfdaAGLRE3e+HE5i4l60geuorT2rH3J71imJs4+Wv6xVGndnHGixBSW93cQIo/b8mBFFx8q8vstRbby9XTAhXWMOnNJ0yxf4rCKFnNOVSvGJLXMUv3AtaguosOYdNDmZ29satlULFJSXCbiSRdIv5ZwHSv9qKuJnEHMEhajR0aGfAwkWDnmXA5ZvYigE5RyQ5kdR2yAmxVR2p3GlEVmXF0aWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Before moving the empty_zero_page into the .rodata section, make
sure its linear alias has the memory-tagged type. This is needed to
ensure that cpu_enable_mte() will be able to initialize the tags
correctly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..0c3d97f120e1 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1195,7 +1195,7 @@ static void __init map_mem(pgd_t *pgdp)
 	 * so we should avoid them here.
 	 */
 	__map_memblock(pgdp, kernel_start, kernel_end,
-		       PAGE_KERNEL, NO_CONT_MAPPINGS);
+		       pgprot_tagged(PAGE_KERNEL), NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 	arm64_kfence_map_pool(early_kfence_pool, pgdp);
 }
-- 
2.54.0.563.g4f69b47b94-goog


