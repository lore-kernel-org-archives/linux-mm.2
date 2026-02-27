Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BADBFEFB70
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06936B008A; Fri, 27 Feb 2026 12:56:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86526B008C; Fri, 27 Feb 2026 12:56:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C891A6B0092; Fri, 27 Feb 2026 12:56:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2B056B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5255BC1A39
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:00 +0000 (UTC)
X-FDA: 84490990080.27.C5A6B16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F89F16000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:55:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kul8yE+Z7Nrif+eGD0VElMsfhB3iHb8yVZmqQmFFNE4=;
	b=qrgtQPAerzSien848xb2b4cXYRW+Fj/K4W9X82nxdzTo42LnrwgqFPpQHLTuX+9iSn2E9L
	b3XCPDjBcZORIcaPojhgH75cSiazGTQmKMpU7E2auHejoK1Gt64B/wNqP/mWz6gAlgHW2O
	GmfAZ8X5RdHAsohwYrxn7JSW47fgg3s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214958; a=rsa-sha256;
	cv=none;
	b=etsCrqvarBecUoT677SivTHDXQPqRU+vg4h3c8oLQ7IYENfCG/Vk4JfGXr7Kte89ax/Rd1
	+xqBDVomZ4T/YKpiP7YAu9objmPaze/dZRMFb7TpXrmdCdmIokHl0D67awbDQYaMFCUJOJ
	J+eXGAOa800QlE8zzbCDNsBLoBrwLEs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C48514BF;
	Fri, 27 Feb 2026 09:55:51 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 35BEA3F73B;
	Fri, 27 Feb 2026 09:55:53 -0800 (PST)
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
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 03/30] arm64: mm: Enable overlays for all EL1 indirect permissions
Date: Fri, 27 Feb 2026 17:54:51 +0000
Message-ID: <20260227175518.3728055-4-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F89F16000F
X-Stat-Signature: 3s3yi6wakaw1c4f8tjqomrebjoniu6ah
X-Rspam-User: 
X-HE-Tag: 1772214958-343419
X-HE-Meta: U2FsdGVkX18FbnytUXm6A0n2G72cWw/Jsg3i+QLIqDGP96pbGdFgM8fNEUese5H4fxEcfKAeNY/wB9RKMfVnRY6mlC/W4Zn2PL5W1NnJ6Z0LHg6fl1rtjSmFOjbIQlJtv1w3LO69BIjvESKRZ4XHyMPBhHFzMHIQBBJwW2kBMpe09aDV7XDG66RWtRXYrymCtMSTJoxcwbOMnUU5YGznw1tQIt43kuTO8bDtaI7WJG55ldYSeteS1p3a8a6ZrKuJXN6J5/JV04F3IOr0UhhA6Os7UsyGS6th5LTA0ls1gpthre9E/7IqywLurLe+/98f4NoaHtwhzqKfDsVdLkc7MXhbQ/AAgph9hp5B6b5Y8l/gCtKvVLiYaDMVnqdgezj72fkJLvHBst8TYT7VC4Gs3/IW/FoHXAkyD3/Am8HIC9cuIIIubhcoCGaxMJCl1RwRo/G6e5J81LVpcAdju8GI0pgiiAfHJNyyRFjbUCR/POqI4QU3uqv/AOn1E6M8CrG2XUlN3aLwGGv4g5r8bZKUtK6K7lHLSr5RqPjgZ4If2hhn2qCcBC7kwLHPrbSveBvC9u7X+5OZKnwMXZuFHsdQ32IGMsJdBef3XrFU/goAiahuTtvy+cjjfjz5ja9UlnW0dbrooXR2gTJQ6VpXNm0ZLzjmBNA3ui3g43VpNE+l7iyRLMqX8zAMDw36SNzJ5xnFIPCGb4vSNT801zXd8UEGPA5JFb5Z/hk6Y20RbdgeBb1BYfIueifu5Ktgj14qRM1YC2NaEwydp3ti3beWEOBpIjkwLVu6aznoYjb9TMHJE4C4w9irMWArGuMVFt2rabHsBNL2RDQFi9FLW8H6lJKFFYU9tQgpOLkh6rH54AdHbntl5g3pwdEumXDUimcwePIGxkFtOW+faYYTDtXSzuvGRjsLM250+vKh6oxSEKJqZf7yXTCa8b9xQamZujYFO3Rfdnt7wiXsN7YHpebgQYC
 65jtVuTx
 IlabLrgVUHmeXUIP0GAUboUzcuMX0oRQOik5nyzyVkgQoypDE8nOI90DsCywW/+yhlRdVB3wSSsfDDNBMYWCh9a2BmNCro1E/KZS9QCa9wl0K7S8wDgijJfuY3BiDr1J5ebawihUc2E/8C/apzkeay1vJAg==
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
index d27e8872fe3c..849fec1328ae 100644
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
2.51.2


