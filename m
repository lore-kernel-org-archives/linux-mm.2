Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F38DCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2052900215; Fri, 15 Aug 2025 04:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAA018E0002; Fri, 15 Aug 2025 04:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7276900215; Fri, 15 Aug 2025 04:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A36248E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63AAE160870
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:43 +0000 (UTC)
X-FDA: 83778383766.28.B88A54C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id B548E40002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248141; a=rsa-sha256;
	cv=none;
	b=ZngSUelKNJ3P0DfDrqYjUx9EAF/5+YC+FYqgacU/U5Ye9vl5saDlcYYNySAiWlhVpRimWN
	/xF7zgTj8IKxQ9PEb/k3VEOlBdh4hr0jTrarjkKAoJikqvBhnx/j4GF5Qn1y2zeq+72PIA
	b+emyg6M5S5JnPMPJ/1jvexEU0QoFfk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40L0rT1TMmMu3khvygOHsnP91kI7tFfWaXjrpg8NnXY=;
	b=uUMLf8OrTZ1DCCd7RkcQyoLhMg1tNfCeUwvLB+WTFgxQdAu/ZI/0R6rbaOm8hWHFY+5MoE
	5f/l0MRpyCYstx2yJR2dPnuDaW5xMacPrdWD0hT4ertZPdf8XjY6NtH5xjF9v+JSJwimrv
	KUcup48F6+jOV/eUixTtZq9lxs10ki4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C86171E5E;
	Fri, 15 Aug 2025 01:55:32 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 703713F63F;
	Fri, 15 Aug 2025 01:55:36 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 03/18] arm64: mm: Enable overlays for all EL1 indirect permissions
Date: Fri, 15 Aug 2025 09:54:57 +0100
Message-ID: <20250815085512.2182322-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B548E40002
X-Stat-Signature: xaxmkmfpzqsgog9ptmhcq4gkkc1yy6hm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755248141-202310
X-HE-Meta: U2FsdGVkX18G1o0d8fuNs3oWAuzrmjwhHsRmJbW6QYxlEU+C3Wa7t+kLX76nNnWij0A5TsPyaNDqf+Eq9HGV9TnPMiYTiAGmn2WdA1HISTfD5dNkUocOZikggqVurCM0S41RluYA/eqNXfjk+77jVUGcw3XW5tB+DPCOgLCohFMcn+IrvXES/WnrqQS4PXL7uDK25qJOcB6o6LrhXtFn9fy6pcgp5S0tgkN6i8AQrqRI6ws4ZbsNjnbcGOU7lzLG3SgUTLKyvs2upauiBHuXiRkWBROsXi1rfc65vEbc9K/X3x8lg6YYO3t+SQNxHNSD9YkSuFchv5AMKEAQPF+P2hd4GWUJgyxod2wRYacKkJz10vALFCQF4GbvQwXo9E7lCJxcz7YlVJh1EgMsMCNUvDCdGNQgzMxfMxrYZbkmHgz5L8cHuv8ISr7KWLczdyg0ZZg4/qmtinx+MVlQ26tcCyhtXGIx/FFhckhpFsCud8bXT8hWCrBo21YtIsJ+nD1YtMxCsrDipJK1ISVQybjNiqo9z+sN232/HfEIvU1E7UNJEmmGsAexPeWfz9qP+d2SdEf+zmyHP2DuJi8FzHREHKXOLBTGT7CptiPoaWSVF05ap0Mm1MJL6DS2ZVQ/Avdo07sM8roaqPKFIM88sI9edz8vVs6qoVEywH0ruA3S5c2bf0ovFnN6R5gy4H4jIjpqbDN9BxMepSOQ03MMCsvNADqD67XFtIYuu5CPKo1iUQRVYMFmAYlBfmzXxalCc5Chpge+KeI2Pdc0gVyeXLUhZKnpRSU69TjKwj1fIwtsSBNtRAEaeYl+bYZOCDT8qOcD8vDUD8MY4gzr5ZgpYoT0r2Oxc11ufT9G7lXUnxrNs8bvUArtwqRpxoUQK52Gk6hzEhacjqvJcETaC0wpUiiSFF5YInIARXnbCK4pOq16gTyn34b/hkVgLMmNSBEziTB7znrtmS8UD8vuq5jm58X
 jzWqOQtf
 iAJ37sjsFen3PCvKeHdG+6sMFZWwmra4NpMUgaj6XwxioOLPBuQlQgGzaH0KLS/J4DjsKuWIoKRGI4p2Xg44xGnLdXoTKbdObo15pi022jNezfLtsz1TxygLU5G7fHtllK/W0Pv3k0pFqBj0gqPplL0fhWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 85dceb1c66f4..0ab4ac214b06 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -180,13 +180,13 @@ static inline bool __pure lpa2_is_enabled(void)
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
2.47.0


