Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C5ECD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC05C6B0095; Tue, 26 May 2026 07:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71756B0096; Tue, 26 May 2026 07:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939126B0098; Tue, 26 May 2026 07:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84DBE6B0095
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:17:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 557631C04E6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:21 +0000 (UTC)
X-FDA: 84809319882.30.DCD1FAE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 781FC40008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:17:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kYDum7JD;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1xfeI5UbcpARDbBD8TDLZovNjPqioAZ09pYeuPOgdA=;
	b=l8jEL/uq3waSvbAxHlWBnmss9EdvMu10F8ffaSaieectwmqNu2psvaom60rbdVoynFHjaY
	gczCFt/jD3+LVwCh7w2z8KZeEEH7yyBOX8GXwxalF/XE4Wi74LqLgUtlJkTtrbRTVhXd/4
	G4lZjEkh/f4EPu6giEFss3mGPkQmQn0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794239; a=rsa-sha256;
	cv=none;
	b=IwMcUCqkTwac1Pu/W+nz6XCJCBpaNSBgLUDedi0MEfGM1E5TCEQ697UrICVtag/O6J0sa6
	9c93zWxXVVp6b3OD3F1TjT/sHKkxjKMID1VriKS+2U+gTAgo4kcXDwBfrzBoCKYYNSyKvp
	DWbZnBfi8TnfheMSfdsiKMw5hm8hekQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kYDum7JD;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E98D1758;
	Tue, 26 May 2026 04:17:13 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88BBA3F7D8;
	Tue, 26 May 2026 04:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779794238; bh=UwGP8FTfDtcj8k/6otcjhFkm2uk3iMrLq2Ub63GdAmQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kYDum7JD8BN3F/bfeXiGQwXx9/bw+hWDCcf5LcKprddW3ywsAFLQcsCYoWyZavHVz
	 RiYMUKq6kQ7cBWaHcBwylnL5NcSnPczX97fXLS85/OfjyokkcLH18Kidpj2C+mZe1Y
	 nIjI5QIN7YvHBow691as3+q62zEyZwXFa9Xaq6WE=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 26 May 2026 12:15:53 +0100
Subject: [PATCH RFC v8 04/24] arm64: Introduce por_elx_set_pkey_perms()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-kpkeys-v8-4-eaaacdacc67c@arm.com>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
In-Reply-To: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779794212; l=2402;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=UwGP8FTfDtcj8k/6otcjhFkm2uk3iMrLq2Ub63GdAmQ=;
 b=iNDhKZ/+umpUiUNJPWK7f2x2rMi9D0xslG07vIaFgag3HFaD2j/WlP0ym9AnI7XdrVTqwYda9
 08E+w4HgatnA1jD6pQrU2nmM4y16457jqH6B51zJTPi328yTHNQhgsS
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: 781FC40008
X-Stat-Signature: z7k6eb7b1hoo467ur1rd6bmbenu855or
X-Rspamd-Server: rspam06
X-HE-Tag: 1779794239-31147
X-HE-Meta: U2FsdGVkX18+VeQOU3Cco9mqXAEIMCKlSSEgS5lYZtsS+UcCEerIyjfxeCCEzK8eYRJlSzI6Shr3M+Q31lYAi95+WQT0U/R+9z7GLuaperRjI3uuL4ibYRo/FDjXqM+paepi3MuMIAsZoV73NGExKkpzf9b95ZxRixpShMtrWwDvs1Du9deByjFzcdUBcgnHKxpMa8JOkBMfLcM7JwYJjWdFsK4Rx11Eqo4hBdElpNCL/m5GdFY6qCtSSFpZ8UYUHi+p31xeLQsgTUo6o2jnslfffAksAEfppbxMikRkbB1ORCuuODtSHa+ftSeSIOlu3mV/egH9ZX/rCX0/n6nc4Q8yujLFuHG4v6CxAMyRGtWQoTesWhEGY03maA/ogGSK/STfd/Arx6c7UWaR+SvvhwVHzc9vJuY6WARVFpBCHIHjruQ/Z3gc6SeM0KPSMqHmqyOCpcoE3QjOceOSz81P7hRa8Oej9063RqHDzerbQcxwSG9R7kZxuFPDU4znkdrmU7BUD+0vCoLwsMdiU5G0J/zJwSDk+mqn/1mhcbieK7t1cttKUJvRLw5qO4RjAEtwsFuUjZEu7604Ej7OIDrOMz2psplM7N3X+nkyvHIQcClnj/BZ5V9F8uuJdW1Sp23F3p478tXdzVAvrvduO0oAKzvW1p5A5IXrOCGVe06uxiIL8Cjsh3VBdTVEN0RLfKJHuvIP7XzCSmp7tcDMnfVJ0mYZP8ro7JCA7hWSMVaoyZ9/5wxx1DYZr4atFcYW9ALTk8BRuxQNtasDF/qHBbhmYlYRQBk3P84Uovtn2hmg+so77YdsjvFYgEGdE4MhxTkhJG3tjet4QNYY1JHN3uXv4q72Q4VDq+7gdd4wPCVqPjl7tcelNxt2k30v5nEdsA7+WDnbwl1Wox5h9sqKf3W+Zeg0K+b91Sb1i2WjJuC4AiGdrC3ydXSdrLnmnDDgcGMBcYxJU+5e0dt7iJLQZxM
 lGzWRbA3
 WA+dlf3gL//0UxY+RMBiziNTB7wqjWZL0GJYJSDfqqJYWrFykNLkGf+j7oqsWZ22+lfbQX4x4KXpHLZtBJ0FHWmJNxl7LmUEnrisdyLwXAR5K1pchStv+G5ZObI6E28l50wdOXwaFhuLJLtQdnb6BKet+bULPvdKm2EWzZxIyo1M4XVKqyRGFDQmh52CcVT6cBBQAgqPsEtAb0tXN0+9q7P30oDq8VeoHperSzRwmIVDLu1iLbobcZ376Srxxwxma4IQCGHr0HAgb5ZW3SiNAKfNNz2bLUz9ss3Wy9IvjV4ZH+TVzKRFwX4r9fy0qErDlEI/HfFaPfXTNEHo=
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


