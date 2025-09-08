Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479CCCAC585
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:41:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F2D8E0012; Mon,  8 Sep 2025 03:41:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFD58E0001; Mon,  8 Sep 2025 03:41:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DF2D8E0012; Mon,  8 Sep 2025 03:41:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79FEB8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:41:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37F2C1A09F2
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:41:01 +0000 (UTC)
X-FDA: 83865286722.25.23EEE27
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEABBC0004
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:40:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+f+JjSQabQVRrk0v6HkmsQltPdfUI2+IF2z6TEnhe4A=;
	b=LaimDh3+LNyUSpPWwFc6ch8o1I1XlEDRahNFFXCyVolV3SbR/QQgaRb++QytPuKqOqiX2I
	2pb7U+JFQ1yK9eo8uoou24eLQbtT1eQZmTfCg8INQhyxpcqnbDGHV7B4SjVV1TBbFYLDVp
	adG14IUnPh9dDLwifjhO4svDlRPBaIM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317259; a=rsa-sha256;
	cv=none;
	b=gymPJ7y7g3VcVeXYFHYMn/KnxZBh0fYGVAbfugEzULadXPTOLsjPvnZx0DYLyefoAUPYS4
	4WM1qjeId7cXl6puz4T6T0QVKUbQfnqV6GkSPyzH4mPA+y08IvLq3eMiCZbBjiKg0Q9MCs
	SEttnC4xPjKC+cF0dxonu7V6DKlcAlc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE1BA2A2A;
	Mon,  8 Sep 2025 00:40:50 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 538FB3F63F;
	Mon,  8 Sep 2025 00:40:54 -0700 (PDT)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	xen-devel@lists.xenproject.org
Subject: [PATCH v2 5/7] powerpc/mm: support nested lazy_mmu sections
Date: Mon,  8 Sep 2025 08:39:29 +0100
Message-ID: <20250908073931.4159362-6-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250908073931.4159362-1-kevin.brodsky@arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEABBC0004
X-Stat-Signature: nfkmc9gj5z6bbdscj7m7dg5cxgixr9s1
X-Rspam-User: 
X-HE-Tag: 1757317259-159614
X-HE-Meta: U2FsdGVkX1+blmWX0OylJF1E1Fxbh2PQvPorlNCgy50ed68CJPtI8icYrza7L9+x+m+KOL3U/qZHVWl82Q6AScbFRqFOH/PAOwDcnTp2jtIxIiCazkE63jEnaWNLzQhKPETsEWoJSO1akMPaGOYiTg3v9rvUBYbKKPdUVB2VwWE8WbgHV9PCFZ4t5VqOKIwTmEB8rgytTvPGVigX+FI2e96pHMN/7lSoiCqk2gyUjccPXXZ9GNM1d8c6r4iIoa9Hhbk7beUwf1u5jHm72bKeCIDVdECpchcSkAj0GiHXdMJpce78FbqbfSyKCpClZ7TcPax4KrEnSkKyoXvXUF3TTHYusZ/USmSs6qluEdbMIz/jPy7d9k2CHneQWMBsspmPoHA8Q3XnXDaOcR0ChQ338TAHHKd6L5Z7SKvNumSKzvesmado2rXgWUBD72hvSNInG0rQn6zz+3+Tw2UcgB0/m+B2A+uVWKGjiscFYpXolGM4facR8C/UK09tgChZbXxDt5xOMZBqVzu38KaiFowHFqH+4Yn1FqW6KXTE2S1swT6bPTRA6PEoIbtddr5Qa7AtNPyBnOc73fomIGBLpBPd5R3bmbUjRit5awkGzOVCVi9cV+K3kAEQ36RJxqjGAAVKiqWVuOphTy7owF6HBINFXlJRN8zLRSiLvOhKpK2m/rluNugrge7PppfcNR44XJOM+WP3aGNJVWfrz/ALkyJdBvDktWGz3+ogoKygVGE+cdu+AOBo8hYZhcqXGUl3bd2KiX9VPrm5LF8YrQdXAIyffh+zxQIwNaRZcNq1WS31pZ3JkjK6b1PR79I2p4Ht+ctlNUBpWPM30kLFkVVNQZwrHuapY9whCSPe2E3oIlLzPOKfw3jKaSN6EMWeAnhfRiHnW2CCEOGTyyE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lazy_mmu API now allows nested sections to be handled by arch
code: enter() can return a flag if called inside another lazy_mmu
section, so that the matching call to leave() leaves any
optimisation enabled.

This patch implements that new logic for powerpc: if there is an
active batch, then enter() returns LAZY_MMU_NESTED and the matching
leave() leaves batch->active set. The preempt_{enable,disable} calls
are left untouched as they already handle nesting themselves.

TLB flushing is still done in leave() regardless of the nesting
level, as the caller may rely on it whether nesting is occurring or
not.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/powerpc/include/asm/book3s/64/tlbflush-hash.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
index c9f1e819e567..e92bce2efca6 100644
--- a/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
+++ b/arch/powerpc/include/asm/book3s/64/tlbflush-hash.h
@@ -39,9 +39,13 @@ static inline lazy_mmu_state_t arch_enter_lazy_mmu_mode(void)
 	 */
 	preempt_disable();
 	batch = this_cpu_ptr(&ppc64_tlb_batch);
-	batch->active = 1;
 
-	return LAZY_MMU_DEFAULT;
+	if (!batch->active) {
+		batch->active = 1;
+		return LAZY_MMU_DEFAULT;
+	} else {
+		return LAZY_MMU_NESTED;
+	}
 }
 
 static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
@@ -54,7 +58,10 @@ static inline void arch_leave_lazy_mmu_mode(lazy_mmu_state_t state)
 
 	if (batch->index)
 		__flush_tlb_pending(batch);
-	batch->active = 0;
+
+	if (state != LAZY_MMU_NESTED)
+		batch->active = 0;
+
 	preempt_enable();
 }
 
-- 
2.47.0


