Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D22ECD343B
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6306B00E3; Tue,  5 May 2026 12:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95D06B00E4; Tue,  5 May 2026 12:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84A46B00E5; Tue,  5 May 2026 12:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0EB76B00E3
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:08:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EE2116055F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:32 +0000 (UTC)
X-FDA: 84733848864.07.42A8A37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7B5A6C000B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:08:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cwz5o39n;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8pvlGeIz4wnhgCGR7um1VoK2EQsgLLVLhUgC1XznHtg=;
	b=LluaVxrKscoQ5r/12KVeA6SP0yDwPvVfENEh/PYNVUkTZqBf+xP2v6F4gBzMOp6+gVEieq
	NtxF9UPWD1afgUiyeN+aNbDIIBlE9hhGI+zYDTzvPSbEMH8l4bKJJN55mAih44oCYLmMiL
	AdCyQInTyRuEB2hsHCY/hIyo4/4sXpI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cwz5o39n;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997310; a=rsa-sha256;
	cv=none;
	b=V+UFpFvdFZRptRlXFD/DgR+TplfFCwm8moDCyPYuvzwG8U8wssISbtjaXKxcFppNjaDk2p
	OuG4I4MPDUAurn3IPc4QMbHfTX/mBScrTFVS1ZU5E8PNE6Hk1kpFHyUVh+9cpQ/HHkGZJ7
	6FvW/IMYndwrqHbmMFazRfIIKFOHaN8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28DB02681;
	Tue,  5 May 2026 09:08:24 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6231B3F905;
	Tue,  5 May 2026 09:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997309; bh=qhiAk4es+a9hrujAuX98hvQ0rPx9R/Rfcb8FmcZAQcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cwz5o39njUMufkFV/E0d9BSYsSXSRyEQfsh89MROrUiaAJ3fKPzBPCLmV2jNcMgkV
	 TKtMDmvPWNszl76CME8z6Oxk9MxGe8zGwM2FZR5elYgo/eU/0yUnM+4Fp+oigj7s+2
	 MsKdMBhxpuw9E21Th13mvhGN5KyDk4faXlOjRrik=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:06:08 +0100
Subject: [PATCH RFC v7 19/24] arm64: kpkeys: Protect early page tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-19-20c0bdd97197@arm.com>
References: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
In-Reply-To: <20260505-kpkeys-v7-0-20c0bdd97197@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>, 
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=1150;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=qhiAk4es+a9hrujAuX98hvQ0rPx9R/Rfcb8FmcZAQcU=;
 b=ceZ8Tc3q1QQobD2wPmnrxyVPJRe6Vy2svFEKe6fDbmwCJ4eSrjWNuIiq0QYIrPVjTZSfk81sU
 W02DQ8PfNnJAMPnkA0VoACZYdH+p6i2wuTjpUcrNQtYJXla/WnL1wEL
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7B5A6C000B
X-Stat-Signature: r1s7u3t5ngiude191efzybgdqq1bpxeo
X-HE-Tag: 1777997310-17651
X-HE-Meta: U2FsdGVkX18QBrI+KPxfUXiwKuqUMjZ4Q7/+MGb9fFQmWNsKigkPyuDhsSLStoP6Avsa9LkkVvaao7L7kSjNa95Hz363otGqD5qEYya3hOUnDTNYxc7FBLnqqaTyZpoqTHriqcwlL0ABW08kbmJZcXR0X84z5nz9Fgqm8U9PA6+M54Ga72uJwds24jkulQ6pMJqDvkYz+RpPtHm1v7SFsF6PXQdLBDJEXN1gXV1zP06y7WyFX4H1GopueeJk01UzAgHKUkfCtlpF9MFXEfcOyKu4rBClVloaNmpko0OFYcZms0K2hBHpLdBNIaQic1rJoJdp3zvABoTVz6MS6lJN8ZkFH1FwCkXBg/MISLcNqdu73gnYRydGimYKoRr0QFRH/4zoV0oDC98PFnS0Bvt80Hracy3+lzim4Zru3kYvmTAzn6kYVNuxuexI+EC8T++AwISuL3h565+RbY1Qg3e5kE4JD75Zwuw6uHVv4HZIvTQqdujOTHT4ohNsuIzlZG2RB2N+EHnRaLFGlB3mBW/ZlOA3E6Z09+zvzhx1mXH3rMVXWBYpfPZhGf7N+ymM9ZPRW9zATnNTWNSc0dEGMS/BE2NXCnpZrVgpFsrgz56/o/cd/h8BnrzoXbVvoeGScvKaLP9dchINGFUjbQZTwqvhGQCxOD06jAni952M86JCfzm6FpNLi6eFRY2/fvCaFCoELejKCK2OX9FU6Huq9sW8yg3eLyLrdibIM+KcKlKPudppC+CWqIXETz7eFO7vZQCnV60nBRc7P83jUMOpwCLLA+Np8xBKLsWb+kyeX2qmfc5jUReGHOgT/OHoI4SMRzXDzlKbZxCThan+Ird1Yrr+fgEhHOLzTrQ9AeQtobuaM7PZ9sGyzZd0Qaz/vGHLmI0XSQ5OBMilx+iANNVxPLbenM0l4m6BCJN/40dV4idIBgqZceYsTodkcysgqjz6tOwf+jIoQx+j2557rbLOFqA
 B423FgWM
 ifRSFtdQAxwGxMljqiMVqoT4HOcesMLf3IjtLHVd1CJ3xaB+PEWIJeJcRn4S9GCnDXJWZnzAQQWQjucqT6iIwCEEyxxqU0OzDk673y6SRGh2LgaQLBYTUget4y7ijQ3a1BUZYIvp07kglXh9OjPq/Ij5AYcNQ7tNwExUuZQV+Rxmjh0DA/0s0tXTSBODLcCqx2j2vCQ/xBksRkRDgUf2W5/cp8ZnsVDqXwQXuIvUHg/pwtpJGuPlsMK/HUv8MV2hRprIC
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
index f79e82c0674a..4b9218483dd2 100644
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


