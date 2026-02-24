Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB266F4BB6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575186B008A; Tue, 24 Feb 2026 12:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549066B008C; Tue, 24 Feb 2026 12:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458B26B0092; Tue, 24 Feb 2026 12:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33D4F6B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8B9C1402AD
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:15 +0000 (UTC)
X-FDA: 84480109350.01.A173905
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 48E3F20018
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ukFQhFxrxPUhm0/kqybetU4D05psEC5cYeTcR7gOLQ4=;
	b=UqPl4wSi+6XKCLBosWR7MV0/s+j832oyY20cNTG+iYmy3Z/utQIEB7AAcXQJBgI7nvV0/G
	yC9m+nMJ+9cWeNcvemx8Ank7/v8CHJJTp1cgW1gmqL9j4UI/0IWJTkt/3Lpa5qAq0TAuDb
	+BxMPgkCT7cPpuiwtCin/0pKmjA+pDA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955894; a=rsa-sha256;
	cv=none;
	b=v2rtjNYYqxS8vcmx/Pd2GXmKhMwPHbAHkAS2PxKGBvMa7o1SQ1xWjbnLOzn8ZbBYZDcCVt
	JBohRHbLOsBDNMv3hnTc5jaPFfeAewHrCb6qxjKpaA1UDUsh/SHQMWtZ0qUF9eI6C5Yx17
	SqITINjBoHAi1dtj705I6mBoCmEym14=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0F6F6012B;
	Tue, 24 Feb 2026 17:58:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38832C19425;
	Tue, 24 Feb 2026 17:58:10 +0000 (UTC)
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
Subject: [PATCH 2/5] arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
Date: Tue, 24 Feb 2026 17:57:54 +0000
Message-ID: <20260224175800.2500729-3-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 48E3F20018
X-Stat-Signature: huw7abf7d9jwsz7if6mzu3uzpktbj67d
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771955894-661312
X-HE-Meta: U2FsdGVkX19YFX0ybfEwhQG/q5UbwZ/c9TAn33u+HQk1bT1yR3jLAVKCek1EEHeWEipRmTdtHMvxCyxwiMoa9jIcE3rg/xXDo+VeH7bnvjRhCJLyVI0mQJsoSn1CV4gLO120njeYiKgZ+oLOeEhzO+XGzeJ1KaPcrNaNbRuoy1fTmw5gXBzv6K64aQra/UzVqH02L3Wgel9+zu9l06TAuaRztNzaHYFULBC9WAjdsO64G9sb4QNVDKNbDBMLYYvvYADtL7GqQQbo6VA5JhZdWDxf6h1dHZXz/34ZRZAFnvEZBhoGcDG2lJACus+7lCaDUBbThGugcGwhwjNB6aiqiyGDdtUZr4RAwIDM+qDMWvLGxDZ9LAEREUF2taSFiEKCvM2BmxaqeZqFNTwSL81fnSVee5pEY+nPdxvkZrfuhgunr6jTNsJQeT4hNfvvtwjufjPGjV6K2uHQUYL+aTfybp6eqPp1MzHRNrIbi10ndI+uhnf5pAVRUmQEaBTw+TT2+7ZpO/Z0McgjMi1EcGljm4pgsp1rd/TrLduZEPl3LAGCi1Bv5rXdmxLrLkc7Td71WqR00ZA1vi8O/z44F99wuiTEUjAm/eWb5Wk9ZychMtiwg5qGCnXySS+IRxrl+TgQ8buebyO5zAnezjkluphHK7/FN3gxT1680NuSh8q3O4wRnlAn5dlGpEsmWMSX522zjWyp4WOj5rLvEk7Vr2vXuUE6uPMneWO3gTW89oAOLAvA5+RUZOlig7dlG137qMpwKBDhHD7VoEtwxgjyTnOu8mqjGukwM/IocEqfglIthGVOcYhiNMuA4zGp03VMrswKHTMB5BBHcfXaRQ6ryXr35c0BwYPLch7PDf6hgjoiOIOImqn5XEk1wgy+kRUqRiNZAnm4xGm6ID7tnnkBVmI2HiOTZ7EN0gUB7rfXMsgGd8bQ6j7nY0HsK9HnohiJmpoHQ25rdGQfucPJgTDRSl3
 HPn063b6
 5Q9QDrCtrn3JyFVADIO1p5vZ7p2CR9VSSC8YKw5JdtM8oZx4JSkGX7u7yXE4UwhS2rxwwGQvHI9Sld/UBZ64kXILlNV3KtOyRxyFb4qibqZBTggNBPiF2Eg2fCJAibqDuOx3mbDnApg0oLQKui3dxRtDeRnmTNkHt3p4c3X/9yf1mXJmy8Y214vqqE4dWEC+Xf3cy+lT0M1ilEf/pszBgoR77HYc4fLZ7Ou8h2rKCoezyFawMuZ54b1/9jt3AeKyqoankGV4bCbJsSUkZrOQZkVs05swle3Bh3xSKkwTi0OofFPLLiKXOUO0HHZkOCU5vvPofkZpYk1RZWI/YeHTCwNQ9Jpd20232i05XoJ14JMPMAPHd7JsUQxx88i/spQhrz/mT300PxouSslCsPVqdYU98Stioq0PYD96OAdlUQZ9SvBeiv5+SWD6Mfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the arm64 map_shadow_stack() content with a call to
vm_mmap_shadow_stack().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
---
 arch/arm64/mm/gcs.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/arm64/mm/gcs.c b/arch/arm64/mm/gcs.c
index 04a23a497f20..680749611a9a 100644
--- a/arch/arm64/mm/gcs.c
+++ b/arch/arm64/mm/gcs.c
@@ -12,19 +12,7 @@
 
 static unsigned long alloc_gcs(unsigned long addr, unsigned long size)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE;
-	struct mm_struct *mm = current->mm;
-	unsigned long mapped_addr, unused;
-
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	mapped_addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-			      VM_SHADOW_STACK | VM_WRITE, 0, &unused, NULL);
-	mmap_write_unlock(mm);
-
-	return mapped_addr;
+	return vm_mmap_shadow_stack(addr, size, 0);
 }
 
 static unsigned long gcs_size(unsigned long size)

