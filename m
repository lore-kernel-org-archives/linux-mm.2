Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04C8ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3B26B00B9; Tue, 26 May 2026 07:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B176B00BB; Tue, 26 May 2026 07:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591A86B00BC; Tue, 26 May 2026 07:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4854F6B00B9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:18:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 168AAC190A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:39 +0000 (UTC)
X-FDA: 84809323158.19.3BE1846
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4172940003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:18:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eXOLH7Md;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2aPhMnNwxFPZ7UsLO+fy52KmBehe9/q06FyWM2x5Bg=;
	b=PVG/P9k6BEYoAGl/Z4xrIAaP1fvO1YSV9oa5UMJ4n58qKgUBQqIBYuAnHrI5adwc0bgX0D
	CqwsY19FCgnndiwe9D/i+iva9XlPtbIhtzM7Y6FyfI7cQNa/FiC3OoaA+hS+zvuoA9kx+K
	G1zjEj5JtXWZd4qNhEXnD/CRrjcoAJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eXOLH7Md;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794317; a=rsa-sha256;
	cv=none;
	b=Uqlw8vFVzegSKoX1+7jSkuwNyzO+KwJwkEcakpH63hYafGeNbxATdpffuKoEfZMft7lU/L
	NGrmBAGnkk4fIv6o8+oXmFOivgQgP2l0l6fz0NVlDA+Jda4Haqvueqkhq1mq6IQ7tmJGIS
	24PWThrDQmkSdyqBgbv623RDdL82m2I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5820A169C;
	Tue, 26 May 2026 04:18:31 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CC293F7D8;
	Tue, 26 May 2026 04:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794316; bh=9wBueeoIAFIdpCFPeoLi/EZkGlpSFOkAKC8me35KoYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eXOLH7MdxJiOkZAP09iP5uw9iCgsxj2We3+sJWtQmd8d061E+2loD2GFwpxMovdHs
	 LkkJNWWWTbLMzrvvXKCOGN9snp9rVpHRftvn//W84DGsK8vZ3pfuDtOV20nXYNOXgx
	 KEnsow/YXuphRzS2h1zxu8OS9NOsZUePYgmR8K38=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:16:08 +0100
Subject: [PATCH RFC v8 19/24] arm64: kpkeys: Protect early page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-19-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linus Walleij <linusw@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>, 
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=1150;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=9wBueeoIAFIdpCFPeoLi/EZkGlpSFOkAKC8me35KoYQ=;
 b=hUZ4Yyz5aVs6xpjZ1bdjTDRJfpeVGlGiY3rWKsG5Z1xMA/LMf3Vg/P8KbC4MF9EHQU3Mnw9ah
 fidBllv5ILqAMkofFH+F/kdGsTqbbi3lJBwRm6AiQE+GRrMzYmyWRch
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: cwcw15f61k1ntpj4so4weeraji6n5nad
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4172940003
X-HE-Tag: 1779794317-840843
X-HE-Meta: U2FsdGVkX1+xMeykF7Fo5KduV2EgR2Ma3MzJXHnEMD8Id4S6tbetL1C4xllc3fhQYOeTQWf72u0LdyvhlVfO6LVA+f7YIPNpgzwos4InO9leAOlNJBe9wOKUD8JD2s0KmoSH+ylAA3AZwoWF+T9r1GqsXYIRNwqa6GeZtrWUJFTBIQLQ4RmZZd0FlU+VheKHZg4yQHnNti+mHjYrVig6Vny/OmGGw8wJlAEbLpKyLFyzE7Em0cNGCI3XT8ys24hCjKAOclJnFBL/knA4+28Bib1jI9bphzBdaPTdaPVeUpcQTPjt4jtVJp5xC7dzM+XiGQ+04MJ1Y1ymJrU57v/zkzvZ7+dCi0HndZCqGH/KtPd6eNOWu0Yk0YTkbCqo8eNjBZgoD12+LE8++tvj8iL+IFzlOVze/CkEnRvcUwlZa1BngC+lOz6cLEj9PPK+OKZvwXPgBOCj86Op/oX9sJZ0cJkET5/8tDQq61ZxMjS34VLvXBnAeeI5o44dSuiOVMMdF3IsHsnkkcvTcK2cJQjgph2FEAqysRO1DgLqAIs+tJyro15aDbyzWW65kjGIhVyDflXSwx1Hf9DX130heqZnbcOhI9ZjAP/IZjIAmhVPpE64Yq9eZVSrM+Jp2UnYzUknEHsfgUIVtlpWeQocFvA7i6O5EzHuAuZBlPXyRvWN/I1zV5hzUvIkbrl+GTDFR95YLEuNb3A3g/DuHPraa8AXd8m+pLFuJvuI5s9oku20IzO5ds52bV5hMs//gwLhfPqT/kmUL9LZvoj1czgbBzXvfg+LNrRMT1H2qVsnyP2NPGeuyOV2f7q2fRShTAFnzp/5Y2CM8tlUCzmWyDxGZ9BlCFMhaeMZCCnL0WRfqQ+dv3Wx17yuRi0KOwAu0dkcjqa1pg03safequFJA2EHhW6cRDx4bmVG1gFS468gk8pLKd4s/NwANIjS7WvqGEAEji/PpTr0TFe+SJTjqoI5hSq
 Ej5/8u0R
 Y61G0EcRKJMUJec1xtwWrkdjDBpb3zxp4TulMR5QpFam/Dy4nRoxD6VZMQGY1LxSLAEB0kHt0k7DrVEMj824z2wIGHP6T11mkGfVz4Vdr+ULCu1nI13FsTAVbHaNN6mQHdrKb5kCpk7gK33fzBlczQOAB5lQw9HXS2adZJCi3eozXsPuqBWKhc+f9zIPCBAVI9FLIuEGUCJblRvOSWDJFoo0TtaEwipLJDOq9Dv6zIrMRWfvygGt7wsMIOPg5gCwlWpM/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the dedicated kpkeys allocator for early page tables (used to create
the linear map) when the kpkeys_hardened_pgtables feature is enabled.

CPU features have not been detected at this stage so we use the
early_enabled() helper. This is not a concern as
kpkeys_physmem_pgtable_alloc() does not itself use POE or
set_memory_pkey().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c67b46592af6..a9cc189affd8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -109,8 +109,11 @@ static phys_addr_t __init early_pgtable_alloc(enum pgtable_level pgtable_level)
 {
 	phys_addr_t phys;
 
-	phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
-					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	if (kpkeys_hardened_pgtables_early_enabled())
+		phys = kpkeys_physmem_pgtable_alloc();
+	else
+		phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_NOLEAKTRACE);
 	if (!phys)
 		panic("Failed to allocate page table page\n");
 

-- 
2.51.2


