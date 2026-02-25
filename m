Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4993FFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8296B00AE; Wed, 25 Feb 2026 11:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88546B00AF; Wed, 25 Feb 2026 11:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D63E6B00B0; Wed, 25 Feb 2026 11:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7736B00AE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39B651A0654
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:24 +0000 (UTC)
X-FDA: 84483476448.22.0807021
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97141A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036062; a=rsa-sha256;
	cv=none;
	b=SlBHNuAgxFkm7GYZEs2cW33uDDTnVAUR3A39sFEh27DdnIZi7l3g4ugZDC5vUc4ugxKf91
	TIMbqkP+LkhQT2g+o0iZu9SbRjOY8ntn1PTcBhUCgUfAR2CuuTvycIfWI3c7ljh1+wW+Eu
	KChnx1iLWMLBRak+45HpuciB6vukYz4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W8mtVNSf5jbuIUTS4uk4r5ba2RaZhsfy8seu5VQNWOI=;
	b=zc0WwWRFoIhiWwgBHOQuEwZQKwx2BVAl0E6pu+EKbE0jHFh3eTqtRecq/N3gPyseHgEeeG
	5C42FNg1+L+myoWQF2ZdA1LsJQdhRTbCHDrZtC10cCqoY1ypPByxlYTeLU3RDO9sSSAPab
	u3ED910jGYn++9ytpN/wk4DV83jo7mo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C91844425C;
	Wed, 25 Feb 2026 16:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA6BC19421;
	Wed, 25 Feb 2026 16:14:18 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/5] riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:14:00 +0000
Message-ID: <20260225161404.3157851-4-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66ecw1sam1hpgqhtdpoenutgigjy3oxm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 97141A000C
X-HE-Tag: 1772036062-429713
X-HE-Meta: U2FsdGVkX1/DqatkLdmGtgAI0eI9Rd+xEbWevbe78uZEcuNo0lojkicW4ogsj1KoPoFRiwdVw83Rc4PjLPSKCxXYvYgqPFpvQKraTUkDThkVPR3Xqt4RUjr4mkz7yTLDuSnj/TuBu5rkC92z2+/HH+FsWq5ru0mb7GRUMXMWNlehffd0QAvPvZu159ky08yjhk9mNjlx7JmTRD7tnKOxS/nQdKkqC2ORtU0drsUvnsEcXf+pYkadyZncYxtopQZY3ppvbkWr4k6hqmOm+wKsxVZgwkZiNbAiisqcASqfpibXq68cmV35DwocG2tWtbz07QIaXSkbbEB++TSFofqdFaioI6e+8q0mR7atlYDFUuPG4cwHfhwod/Rh8vJXc5Oz5VeM2mDrrnH308WBFLRjmMlOThzMtC9oHVTOBRaVsbBUET+NCsc7/IUPV+p6IFdoxIIis48xnFYyszQKSY6zBLmA43nfIUlDAjJ0v5hlrtbYO9m4xVnLj4/lY/Txu8edsoZZes4yu8Mv2a2aS+nbU3pFCw5MmGJMXtzCPAemlMqzLmrpGWmC24b4NwIm0qXt/snyN6Iblw6T06fuiMzkefFTolKSzE5PUWjWs5eWddygeec/43kplM7ZdWvhfSJ2VRGohXp79hx2Fxry0SWygrE3FRAXx7EGXILq2A3CLQRCsvLFC95qdAU4rURMu+OrQly1WqTCKRXPcrj7chKxYMFVPynmVQXMBeV06lfHV6xjj04KMepiq2PSVHTwOvcESDfG36CY9skODy3is72PlhY8449R98g0Y5fIcM2bfcz4sf1lb7azL2yta977GHJhEmy1tuAmAGbH7R1O6bj999g6TpVKbLdDOLmcupdtHPYdYvf14YG8KnStkuBUj54kC3EWANVSX2ZfQlAaSuZEMv6Ab3R6NeaL+ewIV2JXpEe9FzyAiA36h/2sBtA3LffWXMvg9YVQxxEEyANt9lm
 wGU4qfDH
 l6zMFwSUiYF65tQ8M3yHMQHNNdriopWrYuwqZrrHfq8Eaj1Y7Je5dx8D/CsTKj7dnEJjfaG2AlUr4MtwfkKTFVTq+1NPqoR1w151tkFWxLSEePWQuh2Qz4zY/qJCzICcdzM16jbeQFk9YwdSBb8rbN9h5P1zj8vPh1/FiDejiqo1GrKOqxzJ+yRKazb/hsqcpsLkrbiP4ExkZQGVKn4Q33yP++WIfheAZA6HKju2uPwBieOlTDsHT8OSE+q2toB3PmHOU3vNYMG/wm3dwyFMrdtVqBF5pIXOGPq8xJDoCZy7W6KUBK0Q5ZXBzZdY4csH1p29qXbHaT3+L+ThdrRE7yq9sJ/V3r+Uz/RDFip26t76K0pc9lgZQgROY7xekCPwoqmboVneaV/Qf0k3N7SkhJwLDs9PFMZ1XoGbEKR+jGyraGxGrTcLkij2ldCSR6vGx/XG/5sqXy8vkobfEq/bZZgoHlvMZZ5Uc0LvUuIJ3/rQULquP3d3t8QAjAcWEALzVEvW20sQi00A55K68X/8GjsHkGhLRf9AnhCP/SUQl4R6GKI8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace part of the allocate_shadow_stack() content with a call to
vm_mmap_shadow_stack(). There is no functional change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
---
 arch/riscv/kernel/usercfi.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 1adba746f164..7e57f54dc5b2 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -230,17 +230,7 @@ int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long populate;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-		       VM_SHADOW_STACK | VM_WRITE, 0, &populate, NULL);
-	mmap_write_unlock(mm);
+	addr = vm_mmap_shadow_stack(addr, size, 0);
 
 	if (!set_tok || IS_ERR_VALUE(addr))
 		goto out;

