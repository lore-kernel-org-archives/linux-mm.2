Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4D92C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA72C6B00D2; Tue, 14 Jul 2026 10:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EB26B00D3; Tue, 14 Jul 2026 10:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994686B00D4; Tue, 14 Jul 2026 10:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7033F6B00D2
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFC7DC03BE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:31 +0000 (UTC)
X-FDA: 84987559902.23.6832175
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E3C41C0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LM6l4iVa;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=865cl54nJQTbOF3eykkMxymd6hEBxnf3a3hksIMsfuE=;
	b=FHDF3vrZTZ+G2KeXUH62jVdRLnAB1zB6mi3HHUU0KKXCQrz9j1M6q7x+mR0k3PFpTihFdw
	cfeXhIqKTtqe3gMmGoH2E6ybxZyorDZH3zlqqNeLGWjpRmvpmCLlWSRx+zhq6q/E5kQORJ
	msQ2zoBA6ORUxxNPL5k5xzN+NKD7uvk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LM6l4iVa;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038050;
	b=ja9UBgmwWceo3LKHSVfmjpfazbjpRzhp3xDZUC7Lt2+B95KqsnsJMnjiaerK/rh5WFX+Tf
	o8aalUY31kYDgNCQkPaid+JZ/D8sd2r56fB1c0CsNXeNRQ5Xza4rSLui4ehpNFZtYozgvU
	4tHM6niVkIiEYbMh5qMXFxl4D27YY28=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0350F1C25;
	Tue, 14 Jul 2026 07:07:25 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2ACB3F7B4;
	Tue, 14 Jul 2026 07:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038049; bh=VE9T6pQuQsM82lM79rZVxS9mOIiIj6SKheB2t7eP+e8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LM6l4iVarrFVDA4j9SWJAplc2WkKEHlGEtdlAtv7pOYj1y3dATl0KnbkElc5xhenP
	 ErHq3OM3B9mOaLihBDgBjY6YaXcTg/I+07sfZRGvHPhPtHlUZIL/cU1EpblJJAXbkJ
	 UH/xAtOtw9tn/FqSE+wrtOg61lpQnXFpNRh+nTaw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:07 +0100
Subject: [PATCH 18/22] arm64: mm: drop explicit mm_is_efi() check in
 contpte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-18-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2365;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=VE9T6pQuQsM82lM79rZVxS9mOIiIj6SKheB2t7eP+e8=;
 b=IJb3I/i6HXAVQpbcZffARFaIRNRmoRCmPcfDA+y7q25vE/t36H63xBNhz/u8eBXK9/0ECckK8
 YJz0OELUjVVA+CXShhe5YzEf7ewVjSRMYhD9KGxFsYnbUmRuESOa0pX
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E3C41C0002
X-Stat-Signature: uhqb94s5yupa7gtpcf6r13og8cnuw4hx
X-HE-Tag: 1784038049-314346
X-HE-Meta: U2FsdGVkX18tbTwJm7xKI9hOyeoViegECcmi596zhxHkIwty/Br08Lzq9u8eu/3faYOP5tWUlGgjGR3gwijpMM3xDVMHQUoiUB1Y9tTw7ovDKO5t/PtuVd4tq5zYm11R2d9YWAmlOXsIIx9yG0rqpa4HzPRGoBmjo10pMIjRRXfUlYD5l/6UKG0X1Gq79B2uT/rFHplTknDqx9ria2kbti+Wsbw7UWgk9fbVQFDHrmKf5DMDWXxSc05MIE47H0dS0DI3zInG6ylz4fZ6A2t5bbOA3szGWDlcTZpDPVzKfsmefb8PI74lsJ4DGCwQV13vxyk7yFcEgwTTlWli3G3TBsQwiqN4+bCYlMRYmQkHo5cY1KGr775+Rg6JjIRdfyQVjyxKBJaFt8GUNevtZLwe6JvVJWdPlGdlhDvSiJodUZhVUO92i3CfGEtOyC0vPz5FgjpZFncuHGXmX+rwuNRd6yG0/ptMBgMReQqs6GSz4cmG4rtKnO0YBszCx+HH82ltbIVXLqqwSQ9hBbUT8lNE1IopZESdfHXzlBURadBhKf4uzqvlg6SV+F4FqdtOdIFNpvRd32amgo5Oh2hxRM1o0VbktFeenPoAm6DuKgB0vqJDWCw9MXBEO9sp2wUTCmqq7RjCxlImzOLLj2VaDTP9zW1ud6knSXVFpTTO03cReJogViZ04c4mavRVE5PYetPmGOR/uleKsrl+prYtvsJs/BRjcUG8mQQP4BHmWPhwOGhG++4jtz1CX3raYwGpdRcdCYnWAmINjpTH1MDWw3nY8rNu0trSV/cZqZML4WUWsvP4Ol2fhzJ7RBumBiPqeqgmJi4pU35OY6+rx1BsffimNK3kel8t5V5keE1cH1HAZ0SGsXP5a/IrHWEO/tIpnR4mVQnzXK+02pzluy3kPfFL1GqbwZC/O0F0dXRo0j6h3alZJs7GSroULOMVpTmowYyHY80HfEz1rweYjQzGkHn
 dxu237oE
 3eDYy+BTb+qodhCpAiIMtCtPFI6w9Dcvu8T0X4AFXpWyOahvcAF28/A0u+TghtkH2sD5olzJ+V1IvhsXoSeNQ6Sjv/AaCVDIxQVsH4CLs8WYAdmqOwbRKB5w16bwaXTwtyTTRMZ19uZ6ekDVLCLLZVi3gPqJQpmY5Uqlb0lbkBWUYrF3fSSUSqYb4EpL684Tlcv48TLMI/44IMwadK/ryvg9LQv+Kl8hBhj4yytQTF4DL7NEXmQuL8gGmUJS/aDf/x2HYdp0HR1LboEvVsLUEUtIKMCRhEsdRewi3e3r3ct1XAF3NKHb+8QokE7E1NHHKEcXSBdQWkRSzoMaTrBGUnaI/zzBT6KIxLoliQ6ssn2CQAKNg2QEVsmKt7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

efi_mm is now marked as a kernel mm, like init_mm. mm_is_kernel()
therefore gives the right answer for efi_mm and mm_is_user() is now
equivalent to !mm_is_kernel().

Remove mm_is_user() and directly use mm_is_kernel() instead.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/contpte.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index ad5c04cf66ff..e21e279101ca 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -4,23 +4,9 @@
  */
 
 #include <linux/mm.h>
-#include <linux/efi.h>
 #include <linux/export.h>
 #include <asm/tlbflush.h>
 
-static inline bool mm_is_user(struct mm_struct *mm)
-{
-	/*
-	 * Don't attempt to apply the contig bit to kernel mappings, because
-	 * dynamically adding/removing the contig bit can cause page faults.
-	 * These racing faults are ok for user space, since they get serialized
-	 * on the PTL. But kernel mappings can't tolerate faults.
-	 */
-	if (unlikely(mm_is_efi(mm)))
-		return false;
-	return !mm_is_kernel(mm);
-}
-
 static inline pte_t *contpte_align_down(pte_t *ptep)
 {
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
@@ -263,7 +249,13 @@ void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 
 	int i;
 
-	if (!mm_is_user(mm))
+	/*
+	 * Don't attempt to apply the contig bit to kernel mappings, because
+	 * dynamically adding/removing the contig bit can cause page faults.
+	 * These racing faults are ok for user space, since they get serialized
+	 * on the PTL. But kernel mappings can't tolerate faults.
+	 */
+	if (mm_is_kernel(mm))
 		return;
 
 	page = pte_page(pte);
@@ -302,7 +294,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 	 * We have already checked that the ptes are contiguous in
 	 * contpte_try_unfold(), so just check that the mm is user space.
 	 */
-	if (!mm_is_user(mm))
+	if (mm_is_kernel(mm))
 		return;
 
 	pte = pte_mknoncont(pte);
@@ -465,7 +457,7 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 	 */
 	VM_WARN_ON(nr == 1);
 
-	if (!mm_is_user(mm))
+	if (mm_is_kernel(mm))
 		return __set_ptes(mm, addr, ptep, pte, nr);
 
 	end = addr + (nr << PAGE_SHIFT);

-- 
2.51.2


