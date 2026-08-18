Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2788FC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94856B07BD; Tue, 18 Aug 2026 10:11:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38326B07BE; Tue, 18 Aug 2026 10:11:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DEF6B07BF; Tue, 18 Aug 2026 10:11:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B69566B07BD
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2558240254
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:40 +0000 (UTC)
X-FDA: 85114578360.15.BE067DD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0B3C18000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cxBe9I9S;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJFC9vgSZaX8DqmIHEcJMmx9HAQhsUWWPFopYMYj5No=;
	b=vg/IXOZBUPVeygx7RAQfB2TKXAjrZvFY8EakQWF8Ry14ymksTCZxE+yC3He5Y5PIYWYdgF
	MqNpMIw+Z4rqs4kla/KZuBLiIobTo0O7/GQ+1Yf25LtVSSjKeT5/bF6n6P3wKNkIutC1A4
	Yy5GESBeO6VpoC5yJ740SBB49xLZY1c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cxBe9I9S;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062298;
	b=whoG69qLvPnBamMhux2hm5eLO3vfE2tJ22i84bmI4QI9sFVmbrz9F5paFoG7s58rB01V9R
	ImX5dT8p7DclpOf0UfQ/3ztwpKofgTfT4ZD4ODBFVly3K02o12qIQZOVa8ZXixuSXCpbG8
	xLY33IwBkYpuyzMbOYx8uXubhIXo3Wc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 251AF152B;
	Tue, 18 Aug 2026 07:11:33 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 631183F85F;
	Tue, 18 Aug 2026 07:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062297; bh=hooPjsjsIbvprFGYibv5X1kiKmrNJ+rh2pNBQPPeZ1w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cxBe9I9ScYcoAOTS/OFjHAGQiqZgGNlGGBWkUdwU7WCHV6tU2ODTDMbfiWkk/zJFI
	 kI5nzvHbO/BVLyhnpfk9SA1Xj1V45aKX8S1JDqUUcX5GE+w8D8NjfpXk1Y2rapTd3E
	 59k1tQjNecNSisDKU9/6nRV7i2uhAv1WRogEzlMg=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:45 +0100
Subject: [PATCH RFC v9 03/25] arm64: mm: Enable overlays for all EL1
 indirect permissions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=1750;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=hooPjsjsIbvprFGYibv5X1kiKmrNJ+rh2pNBQPPeZ1w=;
 b=1dT1lR/GFlfvxoQ9U/r/5UWCPTPdNEIhZdGjKNljEItSAW0YGtPRacwISla75cwiUf8iE8VnY
 QXH2wDdZX6KAU8CDYSFW9KbkZLtQomPDKoRA8uGZOla8+9H532eoAgG
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Stat-Signature: g3budkj5exhhand5twnj6wo7b6fp81zf
X-Rspamd-Queue-Id: D0B3C18000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787062297-655432
X-HE-Meta: U2FsdGVkX188tzgyqsfOzuvfzJPQ2lV7b6Do1CkXKQ86KKIMVUQF48Bt4VdrpfiwiJy4UTougexmKQesIgl/mrNjeKocv5bP3MxaKHnO0G3zdUCcmx5N+/iH83V4C6+kFJDj+bBpwdVsZ+qSS5MLS4FtOwBb1K8p4bAoEE/g0fo6lgirWNx7J9di1KbMNEvVy2Hr5/ihbGBU4hBmwwMiWfIc2qoVTYdUJ2sUfWklNCDv7uwObG3jhFxfTPAsl971tAeP7qZ8mVrBgGPuHUUcsQPQ+dkwIXdm8ZUOy1y7TetaU292QaJtKSH91BqjtVTepX8KjSyaLjRuffuc9Wr++l5Sa1nlR5McCxMMAdE7h5wAir1aEHie/jkJ7WC5yvVISavyNr0tl6fxenPm2N/8IdfzN9rUofFD+BbBTnt/GdZv+5x9FQ3FTLVMKHECiTd6sktSCSA7Ui7G8dbTGyNKeGiEIeoIuMxylMOHbSsHsJfbg5Qy2hZQhp9rEtqPicIiu7pPLj+I/1oJ03BEHbtbK8/Mqtwdv3grYUTiuzFlkVk8ZxqdHReFFmNYXcKVa0BfFxJP0eVmDMUECdLxVEmZWF7sUed1L5OW13AmO++zgkh+ox8ku9UrS7KHbQrSaSiw4lnBk17pET3R7ncBeensTzxr0Vht9znCI150op13DxSnFr9aHztHbbFSJPPgSDdMzRp6ctVNSTgTuL7qXFvnWsd7KCKe5BtqfbSdM5eA1PUOuvTe4lxiWHhN5pdGNZ1bAGx/WyrJOpqhQHpMbSQi17Quqd01yanU7Lsyl7vjvUJ0t5+gDKND5X7i+7/CyIjvxmY8c9SUzEwYdn4jqWTkguoVbtDgRuiWB1toDS5FQYZIu3MRs0FqMMWNA+QDjylDJ0xjThlU67lHqoM5GpG761QPIw+EY/WJ4pHRo6sceL6t9eObb5kH+nBvA00QX7yt5yN2EBAwYVlmU+QShSe
 FdPWX4ra
 v/X1v5XkllDbBBcKQUoS3W7ouhbgYSIXQzObSOTHalGVmhfYmjdGrcchdWxs/wEvWaGGlmVK0xdPFsE2tFgwp7hrKwke3jK0z3d2QZgS1X99xKCdVI9pC888Nu1NQvS78ZMZjZEwdJ1UEtr6GIZYU7Sv53oLg0omA7Wg9yML3NflGQBi9+PKvTIsRMf1k9N7yxCKVnm9+zLY6ZgmphWeyeWZSoomV5jjYdmdUVqdC+/wALGUH/LMylBcM//qBkRiX1zHoQf1phySc2qzFJujdcISTDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation of using POE inside the kernel, enable "Overlay
applied" for kernel memory types in PIR_EL1. This ensures that the
permissions set in POR_EL1 affect all kernel mappings.

User memory types must be left untouched (overlays not applied)
because any privileged access to user memory (e.g. futex atomic
without FEAT_LSUI) would then be mistakenly checked against POR_EL1.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..d4d45ab86a5a 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
 
 #endif /* __ASM_PGTABLE_PROT_H */

-- 
2.51.2


