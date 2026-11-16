Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA181606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 12:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J1iRwSzP
Received: by kanga.kvack.org (Postfix)
	id E95C96B05B6; Mon, 16 Nov 2026 07:49:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20406B05B7; Mon, 16 Nov 2026 07:49:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5CD76B05B8; Mon, 16 Nov 2026 07:49:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A83226B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:49:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B092C096D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:08 +0000 (UTC)
X-FDA: 85440962376.23.F2337E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7153C180004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:49:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1iRwSzP;
	spf=pass (imf06.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794833346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+kkEjnaw2ySVd4lLiujiWW53ZRBsmmAWW3cy3wlJjw=;
	b=Rk8yOOx9OlRXRiLO3jCOcrFVC5VNYjKU5E3VfL/Bn5YCjanokpibv/ZWRsuWHBxRCB1qts
	pE+tJmNj1sWobEN6VsXHO9V5DjwfO0jmv3rfcduMH2m07q9zZrga3R6WGFVMdVF/q+EJfH
	QzDMxyk8ynIn7n7pV1anNn/aFDGkNeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794833346;
	b=MACTNPFMLns169NwZSJfUNYRP4/zt4c1Yxubbu6HdKYgSbWd3E+EoNZ1ZTpfvxcUZvjSRL
	Z4CBMoU9Ul94bRjW1lm0mkRcfBxCMBwEhiZIXox5r6/4wRTIwNMJaC+14/aZsXQe4HCJiE
	xveNsIMVry76nrApThIL+cZxVge651U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J1iRwSzP;
	spf=pass (imf06.hostedemail.com: domain of arnd@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C9E7F43421;
	Mon, 16 Nov 2026 12:49:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29FCF1F000C4;
	Mon, 16 Nov 2026 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794833345;
	bh=T+kkEjnaw2ySVd4lLiujiWW53ZRBsmmAWW3cy3wlJjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1iRwSzPkXkJExltWHVg0O8oGOL+tawW+ZmYEGgM1jmGAKgXx8sy7HnmkDQVv80Ss
	 yg4kn+EGjPt1JGKZYyWmr96BKjuswmbOXfgaSRJVySsDYEtOeJ/ovVXA3/PGYaEEQg
	 e3V7fokGmh+Jawesd3SW+NFvr+/7WMp05FEXbQ8wK0id5O9GLzTl/BNPOe8HMP9wyx
	 SXMkzQFD+Nl7UMGApCdcv5Ze+xW2cYq4ISMrZw9YTpwVIzOyl4tI/WGNsQAg4Yn1Op
	 xm4CxP/9WVSS9d5AIaFwkOz7gzndFMorMFu1XaBI6AixyyII7UmWDW9Dxmurqq67j6
	 wYW15Z/uOQhDA==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linusw@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Lucas Stach <l.stach@pengutronix.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Nishanth Menon <nm@ti.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v3 04/10] powerpc: kvm: allow flexible PAGE_OFFSET
Date: Mon, 16 Nov 2026 13:48:26 +0100
Message-ID: <20261116124832.662455-5-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261116124832.662455-1-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7sjdsda4865k93w8hseqm7if311mrd7n
X-Rspamd-Queue-Id: 7153C180004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794833346-243770
X-HE-Meta: U2FsdGVkX18loCGN/YNvFNZmmoVTTP5I1wR2NjoUjQxwt8Zbw1t6IlXn9v1RoU+miDiu60PNwg2ED40LOXcHjNVxjN9hKxB6hWUcDh4Ee8fRbx2iPfH2OcdtAgsHn7+sS2QFblu2mDTvGbthdpzFmMvWOayA8EngLPH2urrYaAR/mHyweA8Lrd83cvK4ALwgTUaFIq+GJqH0ylKc8c5afMl8AlQsmXhxiA+I2Mc8uFyTFnWE9pOB5iu2RVC8cpRGkoBGDC5jnuCu/U5OUZ/cgwnzroW2Vc8//pC2my+xyUT2N4qIviyUhqxShvNiRYApQpteH28tsGc1wrTZ+3pTVPnjPoPzy3YaDdJSDdyxwboDMWXDUEqU2gWydriTa0N/6nZu2G/PlnzYku0/LbKm9vBQblyDvaLFnrkVN/EPvHoluEHt74HL9Ks6VsdWfkfqgFhxIQKH/giGu+0Jtkd/I9cj7bGzOp7xjMzy1958Bh+dnOrfCwFJ/qYgUCO+dOdng00mSw71XnbcwKgB349IhdRsTkAX9SEPsdQZPOqe4FXzgdP/xPHuWO50OkvhS6qiy++yvsaVJgSdjuju1Zmzqgx+mxgCzM0b8wuv/Mhs4Bna5qUu1belYJyPWeHNyZ/n6HLvDl3QEV6sG/rADQ3hLDhfTNGtjyrY65lmTnhqbv+YahjfkjMbwzTTxOJXlwCVVAUkJpSm8U9pjDeHg4yil99MDrR0hYxy5HMkMu+VSlgajTAsWD2uCRgtIZvnho4r4SmPpjMxeTdSt6abreZb6ZtgnLwqItCoeStXHz4zESRg9N2e0v2qa2UyMzlAz2Q9Eqe5zSZTMfsr2wRq5r2d/uPzFOJpgWNB5rjsrvY98fSRJf2lma7AadnXu9QKsgGdfS5V0zQ/i7oSEdjPuYOVVOmaOVLFz8XHCsYcj99UzYpas5Ov/7IYolULPrBD59T0O3wNpG/yZC1jf6Fyl1I
 inEtsBDK
 CJyKaEsV/WdiYCb8e9bgoPtTnIHP1xKd63aDeINUawi8LrVIep9UeweHWFxS10JM546KJkmYlUZo4Zng9BuczxYZ66hn4OGBE/78/Si5nrGXGTPdZGqUsSNMHPMtXf2cLCIRwUYEKxvrE3C0pGcCRPIhmwbY0T+W8mKExyxUSHVFny1HuE468WPO2oyyE1qyKAF4+pRpFgXIpI8xJDzrHmeWVQhqb604qkDL0txyXMjur+PE1jwM0tHB+T+0DWDY3Qd67
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

As described by the Sashiko bot, the KVM code on powerpc has multiple
hardcoded PAGE_OFFSET values. In order to change the default, make these
compute the correct register values from configuration symbols.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/powerpc/kvm/book3s_32_sr.S     | 4 ++--
 arch/powerpc/kvm/booke_interrupts.S | 4 ++--
 arch/powerpc/kvm/e500_mmu_host.c    | 3 ++-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32_sr.S
index 6cfcd20d4668..0d8a7857f2bd 100644
--- a/arch/powerpc/kvm/book3s_32_sr.S
+++ b/arch/powerpc/kvm/book3s_32_sr.S
@@ -113,8 +113,8 @@
 
         li      r0, 4
         mtctr   r0
-	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
-        lis     r4, 0xc000
+	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * (PAGE_OFFSET >> 28)))
+        lis     r4, (PAGE_OFFSET >> 16)
 3:      mtsrin  r3, r4
         addi    r3, r3, 0x111     /* increment VSID */
         addis   r4, r4, 0x1000    /* address of next segment */
diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
index 205545d820a1..ede394f3f63f 100644
--- a/arch/powerpc/kvm/booke_interrupts.S
+++ b/arch/powerpc/kvm/booke_interrupts.S
@@ -230,8 +230,8 @@ _GLOBAL(kvmppc_resume_host)
 #endif
 
 	/* Restore host IVPR before re-enabling interrupts. We cheat and know
-	 * that Linux IVPR is always 0xc0000000. */
-	lis	r3, 0xc000
+	 * that Linux IVPR is always PAGE_OFFSET. */
+	lis	r3, PAGE_OFFSET >> 16
 	mtspr	SPRN_IVPR, r3
 
 	/* Switch to kernel stack and jump to handler. */
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index fa6128119874..9edad9bed589 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -115,7 +115,8 @@ static u32 get_host_mas0(unsigned long eaddr)
 	mtspr(SPRN_MAS6, 0);
 	mas4 = mfspr(SPRN_MAS4);
 	mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
-	asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
+	asm volatile("tlbsx 0, %0" :
+		: "b" (eaddr & (rounddown_pow_of_two(PAGE_OFFSET)-1)));
 	mas0 = mfspr(SPRN_MAS0);
 	mtspr(SPRN_MAS4, mas4);
 	local_irq_restore(flags);
-- 
2.53.0


