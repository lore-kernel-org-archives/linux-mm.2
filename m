Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92B61CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087476B00AE; Tue,  5 May 2026 12:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037A66B00AF; Tue,  5 May 2026 12:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68C26B00B0; Tue,  5 May 2026 12:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D170F6B00AE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C08E40557
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:21 +0000 (UTC)
X-FDA: 84733845882.16.F0ED4CB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4D514A000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PCXPyW7B;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5klpagqi/AtdxFgTvAMW8Q6IYyRMO4Tmo+CYL0bSxhY=;
	b=OS7rwyJ/aS7Shgaj15zfqNiVrCtDpBHz/qWjqCnl8ugGQM4cd8yYpU/KCsWhodeHc9NVj0
	wOCxddJYQ5Hl0xY9/CRkdisNGoBmqtQ/UZ7S3wppuelCwgXsJoZ4IT5rMyTCVE8MPnNIY7
	dcWHkcmcYItqYgbynMGnerlIzhu4tME=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PCXPyW7B;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997239; a=rsa-sha256;
	cv=none;
	b=DNLZwdRx2KXiOiHZHdlPWKYrAONp1zW4eQZZAQeu99nZJGC4iznNgR0xKSkDxGFCbM7i1m
	XjgMJ2rSkc7CNmRGTSmB9EePlky2X2l3hWmi1X4atXZVrhRCIMgUKWKSa9R+UVGieIQid1
	bgeAMnF67UQWsUNnWIyGUerjlAjpFkE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0243414BF;
	Tue,  5 May 2026 09:07:13 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A08C3F763;
	Tue,  5 May 2026 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997238; bh=W4ZGYmp7xRQECwjuAIEephdR1A9zylk4/NfRIX17upU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PCXPyW7BQt7IxeHUaNS4IOedBO4CW2MXHvbeRudKU0cak4DjWjrQGP0FgrNljIrn+
	 soT3WdOKLBIIDlRQAl5dpoYVnNHHNwWjeZLz2VtzjTj8sAXktAJeU4BlybVR08kCpW
	 A17YD8kCA4197Smvta/csKoX/O7TA6GPon/Pvt5I=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:52 +0100
Subject: [PATCH RFC v7 03/24] arm64: mm: Enable overlays for all EL1
 indirect permissions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-3-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=2109;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=W4ZGYmp7xRQECwjuAIEephdR1A9zylk4/NfRIX17upU=;
 b=G3mR2pcbMid86MiAwgADgWjfYvrNM2B/ey7mzcSdJXErH9Y+OJLaEoKqNwejhVxufMcDWC6go
 H7/lB288AKEBQY4jHQGcrOePLfPrmTPLeKhccNEGlFOZd1HWCcjccvo
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4D514A000D
X-Stat-Signature: fwta4gc9p9xyeyuxqqeb3u4yesti73gy
X-HE-Tag: 1777997239-752148
X-HE-Meta: U2FsdGVkX19xtJ9wgcMhsD804pgbNWxPo17OOBYPXfRWjf9PENWfO752KJEQPKZMOiSjMzmh5tpcs1gY/m0wyf9fJWFOrUOCsi8gAw7dzebB3Sb08EGpnPYVLmt+NMC3psx9P4tTjoFpBFhi4kXqe+pDbNgRMcYsiO0YonnDiKBTG28EVizWBDsHY04Kvb4dOUZu/5B2lstO0jdzMG/6jFWf+OfHZyvT+GpJcMZoBaj9MaXc8/zTWTLfXaGrozNb071+OMH76psi8X7B2QxmnsU7CHNtlANQdIsX4Dhi4+JlJnSEmRodPiZK8O9qOnO4FXv02kcNM5028AjqLjFU/xV1GLPG+6LeHG0Ip/Lr+FfKeJjezH6fBIF9pXu6yPpbfOyvNNJ2aV4MjydCakEtUHv6X6SAlwkLPoNOSs7s7ZsN1bb/K4RIWKN+FoF3vN2Dl/cHN4yz7VCn5hn0s00K4VhvwC2PntzfvUNLkOU206iN7l8Cc0gXx3Gk7sfLEwVr3tHIpxGiJh8L7ko5C/taJUAtjwuWg4zXEYls5kYX6hneNP+vR4MB9ZhqLTJ2Phdad7XVrkd+Fu1WO7Zq0RqpP87WbAG26zAJf5YQDnXE2ZBwgqf7Evwj9H6c8nOF2Ozdv0E+o04KvD9EhyKBph7H4PZW7SkRZvDY3BWzDdUsLwxQ5GKN8O+smraF8ZQW8OClbm6xsEfmJXo8frVhFnCF892+4rOUfgGiiVYwMFljZnTwRBL8xcBL/c+J7gnPZH+C3/WYU8ryUvPkewUs1otMUzzAh7P5vWoW30wsb0kqQD8J0l6ZZX7/lJoar4hrS8kW+ttVw+DgF5fAfluAFOnv9zelakP1Djdtrp7fRIothbzqqPJQXQcirGSIJUGdoJ1Q1mOJua9rnfJ5humHM7LZtsDBBfcSR4EychsC89seuDUSxfPCRIzlDDADEGW9GPjyjizUnq4+8VbIUFMUBCp
 4G9TaprW
 4LKbzMwS3zeN148SaoblRk+eCO37G9EOemOyha2xqnkphyduwmwbO0EUckfSaWvg+ard4qoBtETKnubsS5P+OwgKEWQBkR0Kjj90u/ZZB02xTd09ZtRiTsbdG+k5lQvVaROHOK6LE6o7eV4bj9oAmP3k0VfxYrRyT/5ke+5eQqkH2R1PjPV+qGXuiqH5zI0XswRua9E8QFJP3b8d8Q+a7M/JVb3oIAgeyLVbhNB0KQ4x6Cx8vBWsFgX7ToVzj/Zk0Le5q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation of using POE inside the kernel, enable "Overlay
applied" for all stage 1 base permissions in PIR_EL1. This ensures
that the permissions set in POR_EL1 affect all kernel mappings.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgtable-prot.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index 212ce1b02e15..3a05a80e7959 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -179,13 +179,13 @@ static inline bool __pure lpa2_is_enabled(void)
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_GCS),           PIE_NONE_O) | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_GCS_RO),        PIE_NONE_O) | \
 	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_EXECONLY),      PIE_NONE_O) | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY_EXEC), PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
-	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY_EXEC), PIE_R_O)      | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW_O)     | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R_O)      | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW_O)     | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)     | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)    | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)      | \
+	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
 
 #endif /* __ASM_PGTABLE_PROT_H */

-- 
2.51.2


