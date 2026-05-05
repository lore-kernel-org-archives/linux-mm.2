Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C966EFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 16:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1D66B00B1; Tue,  5 May 2026 12:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AAE6B00B3; Tue,  5 May 2026 12:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122986B00B4; Tue,  5 May 2026 12:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EEF556B00B1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:07:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B576E12055B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:25 +0000 (UTC)
X-FDA: 84733846050.27.521C902
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B32A540014
	for <linux-mm@kvack.org>; Tue,  5 May 2026 16:07:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fPUSUhFG;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777997243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1xfeI5UbcpARDbBD8TDLZovNjPqioAZ09pYeuPOgdA=;
	b=DUyMEh/HAkgbWMV3iiV4o7FVVAFmotRCIpXP89s3rhqF4Ph/LdwcZ1axIoLwK2jI58L4lb
	pKN6roBOItRPkPKRxcstThuyFRzwrpTRWDUCA1e0ta7HBVy4OfaLdsrMTvB+qWj/xVvELw
	4rpH4sxTYjg0OV8s8dQ4zIDtPwY466s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fPUSUhFG;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777997243; a=rsa-sha256;
	cv=none;
	b=hbIH9Iznaz0T3qZktE41H0UiR4x/NctIV6usEntXYlVo1TTES91ALgna5a+uFTNtIhENbc
	/2M6SFZUdc7KvukImU7eTTi+fa6HNx2/5jfZKu7vplJNdnPdCnowk8UclilPuyku1kb84+
	j7O7Hqywb63T8rAVYyy81w5B6dM7lf8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6C3C71A9A;
	Tue,  5 May 2026 09:07:17 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A79873F763;
	Tue,  5 May 2026 09:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777997242; bh=UwGP8FTfDtcj8k/6otcjhFkm2uk3iMrLq2Ub63GdAmQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=fPUSUhFG9xMoZNvTzxCiKap9c369Fj03UMwYjUAwZadKlqvzHztRcbdEf5retEkJ+
	 G4MLTGHCNZIQGscu6VlrxumG4LdRNa+lwwQoHE3PAodK41Txy2XVyhX1xBvWyUKpOT
	 HV2Agmo5HTrW+zlMTxY7kY5ds0e1HgKBRjMuiXHU=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 05 May 2026 17:05:53 +0100
Subject: [PATCH RFC v7 04/24] arm64: Introduce por_elx_set_pkey_perms()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260505-kpkeys-v7-4-20c0bdd97197@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777997220; l=2402;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=UwGP8FTfDtcj8k/6otcjhFkm2uk3iMrLq2Ub63GdAmQ=;
 b=qrLCWuhFGAMdVVdM+nsjEEPr+OkOl5O7n85109CRGnj6WWFdPkNSMGwXOial/zTZI8G1kqXnr
 dFVzJaKzKeKDKKY2A7n5g8spoGW06Jg4suAbywI6wQ1f3+RazBfkkwQ
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B32A540014
X-Rspam-User: 
X-Stat-Signature: es8md5ej3y4t9aq7ggp6tuc4xbzoqygb
X-HE-Tag: 1777997243-709574
X-HE-Meta: U2FsdGVkX1/9Lx5OsUstJXi1aWcfAHs6elsUjOO2bgLjYpIK8Ydq14zhEhovueI99SuSYgbGbJnOgSmbjdRO9JKWCo2Gfgp9xGB/e6eOBDev6nZyLHQZXqDps9Sr0GqAEFK/bAar7cpG8Z29RBECTNcwayOzLADTk7MuwXGCZJkziT7Co8eldQrAy7A5FAV4Sg4urk9nC6lK3ma0YJlLMIqje70tpO0xgq6f1K2sAVneivTfvLaZMqOvlIRiWtUPD82WOu4csnSZP718MMaoPaj6pNzUubSNHBi2bVkSbSNdU2itdPs8xlFwVA0IIbZ+PdExkPs5ftb6zbIPP68zo2ynD2n31qK6hQ7ermRicqQWUKCzz8d6Ed75V1k75wNDko5KsGJM/vep80dFopKFDs+h4HT7bnKCF9DxIBI/EabY4KbGKMNw0Y7tIZim0ob/MC22l7iNGUUfT+GsjvEpRxtgpjU3v0sTrLOmwyyM1jQ5J8YC/U3cg4Zn9EaidvFGYxhAYa6ygYsdGZIRHpMVP2h0ydosy9Z0RdfjLi943NddzFMT2Vly9urWvY7ksm7ejICa8yNUDyvaRWSHeyLgZ3p2fu+QaOCov4pDuKNwlBI80kn8udgOBxsH4+7Q3QZdTgIm9qJ5feS05YlOqmFQdVgYscPSrF/aXEw8My+VQKmjUhl0V65gmoVxDgdJTZJ860sjwm3UNS5xkuD1ydwyUSMzZ6tYIaIYD98XeFMRCnFnbNQ3+sMnK2wnUCT+plttKSMCCWgubcWNGnf/QZWi1Jma0XefPB6mQKCWnxXtCuYAI36pvGo2RT1Sc/VADA+SSY44NDVg3+MWn10sfmm+muT1Pvy4Nfy9Sns12idDiGPFhaA5h2RiP7bvy+fP5JYEeR9eDE9UwLo1fdtHQBhobQhBrdcQ9YXumMebUkJzrS7FW+0HiRPpRIYneW8G72vPiznul9hLlE7oEp9Ey3R
 lkzvx9vC
 bpTTj31gGMGvuEDwNq82Ru+PYE4RLN192dawFLQedWdxidl5dPH7MsE4+cQV2klKELtAX/9fritee10rKOjKdVpEhxJdNcsXlsaWPJl2qC0xZdOFZS0WU8nMdLnZEVcIzjltXv7urCgZNg+8YNMnpMsA3YNHkFwPa8gz/OI1Y3BZ6DxgfAxZwGsWOKS3H0MifbrcCMIdDYZYIZBIB2ix0ncPKBFgMm4GS6N3N63v1NCEtUeLrFcJ9+HqQ9cPjZDl0Noy5RYJVZKeHQgS+FW+Y9WkhkZzGOMVNBkalN+JGtZVpCj+oSLX/HyyTvTGoe6sTwHCj7Ozt+ZvXr2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper that sets the permissions of a given pkey
(POIndex) in the POR_ELx format, and make use of it in
arch_set_user_pkey_access().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/por.h |  7 +++++++
 arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index d913d5b529e4..bffb4d2b1246 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
 	return perm & POE_X;
 }
 
+static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u64 perms)
+{
+	u64 shift = POR_ELx_PERM_SHIFT(pkey);
+
+	return (por & ~(POE_MASK << shift)) | (perms << shift);
+}
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..493310cf0486 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2339,8 +2339,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
-	u64 new_por;
-	u64 old_por;
+	u64 new_perms;
+	u64 por;
 
 	if (!system_supports_poe())
 		return -ENOSPC;
@@ -2354,25 +2354,19 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 		return -EINVAL;
 
 	/* Set the bits we need in POR:  */
-	new_por = POE_RWX;
+	new_perms = POE_RWX;
 	if (init_val & PKEY_DISABLE_WRITE)
-		new_por &= ~POE_W;
+		new_perms &= ~POE_W;
 	if (init_val & PKEY_DISABLE_ACCESS)
-		new_por &= ~POE_RW;
+		new_perms &= ~POE_RW;
 	if (init_val & PKEY_DISABLE_READ)
-		new_por &= ~POE_R;
+		new_perms &= ~POE_R;
 	if (init_val & PKEY_DISABLE_EXECUTE)
-		new_por &= ~POE_X;
+		new_perms &= ~POE_X;
 
-	/* Shift the bits in to the correct place in POR for pkey: */
-	new_por = POR_ELx_PERM_PREP(pkey, new_por);
-
-	/* Get old POR and mask off any old bits in place: */
-	old_por = read_sysreg_s(SYS_POR_EL0);
-	old_por &= ~(POE_MASK << POR_ELx_PERM_SHIFT(pkey));
-
-	/* Write old part along with new part: */
-	write_sysreg_s(old_por | new_por, SYS_POR_EL0);
+	por = read_sysreg_s(SYS_POR_EL0);
+	por = por_elx_set_pkey_perms(por, pkey, new_perms);
+	write_sysreg_s(por, SYS_POR_EL0);
 
 	return 0;
 }

-- 
2.51.2


