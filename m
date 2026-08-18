Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA8FC5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3256B07BE; Tue, 18 Aug 2026 10:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA3C6B07BF; Tue, 18 Aug 2026 10:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9606B07C1; Tue, 18 Aug 2026 10:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4A5716B07BE
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC9931C0BF6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:44 +0000 (UTC)
X-FDA: 85114578528.15.CAC7236
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id E8B8940008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="WXekD//F";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooj4RdTct5lgHaX1GvqaQ3GTFEQHRRvtsBE0okBw5Bs=;
	b=odr0BqF/nDFtcw3mrJl5yAbg8bnXGlmS2Ln/UQ7NzFM8nrDsz3VdRMhWoKpUDLbjrSSlM3
	vYYNiiZ003foGlT6G6nkIZV7uEHVxOajkmQ6Vl898onK5fbWovuFFysoE09Z2d1qKHVB7r
	lc3eY1enFJaIu+JfM+NKMwsL7tT35g8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="WXekD//F";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062303;
	b=yyHyBqLV/5PKRkDtjfhgb6o/1eEhMYFz9YTeUrzdT1cct2ImfYCgdEe8j+sdswJKYQLv0n
	ZQuhZelQzIXVCrrqF2QrfY5rSWJTl21afp7J41oumZCXVmbtTt2pFvNq/0WAbGEAq3jH7p
	SuiWPV0OY5W3DQFS+jwMAR0e3dvdiPY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D35219F6;
	Tue, 18 Aug 2026 07:11:38 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D6083F85F;
	Tue, 18 Aug 2026 07:11:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062302; bh=BkjNRdlehpq/qqZwQhBLzY19lD555G+nB+rRbzspEEE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WXekD//Fmvb8C1WyhB1190zPRpkkuswNYtmwwoMeNS+olFxji+e80KDeIztBkSSqE
	 1N8MXkQ+SkSeSh4MWEyuEkArYRfTujxs6s7NTROKtDpdvnWDviu8lnOK7SFAEZjvZa
	 +iqm+CakJdybHTz5fi65HVUhf1uIj56pfWjDYRoA=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:46 +0100
Subject: [PATCH RFC v9 04/25] arm64: Introduce por_elx_set_pkey_perms()
 helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-4-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=2582;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=BkjNRdlehpq/qqZwQhBLzY19lD555G+nB+rRbzspEEE=;
 b=4ZTyW5TcfHxhyckVVjluqnadzTDAbx78zgNQa3gNuWY+CA+irOo4uc0URWKL6zTzAj8ERPxz5
 gARLFho9C3ZB33hSphiUVjYeAThs20KMb6VCEKJUc25+Dwhztu0cOIg
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Queue-Id: E8B8940008
X-Rspamd-Server: rspam07
X-Stat-Signature: co7p56owg39d97dckzot4jsim11db7dx
X-HE-Tag: 1787062302-704590
X-HE-Meta: U2FsdGVkX1/1gFIJhZ7BEUIKgxb+ZOslsEma/RD4IVNDli5QSDbHsZF9rbC6ykBh6xQcdiKPLFc/rbLRpupbYPig86qtBA707/3bjlsEHrCbIpVamq6l/KqppcbzMtn+3iExv7NLii4fldoKw1uRopiyFFrAvqlaoYD08N5te35yje71QEnnJDgLdFWU6DhZ4LgO5OtWoGQoU/WOcOAL+B13uAfoT74rUW7SPaZVRlZ+fZMWxZUiiagJK2QBozU1yVJtADLU7u9ez2Zf72jjgcEXF2o5DiddfIDQSQaXmCWyQDMica96sMkXDxXQPLyvEaVAEkkS9eh4dk7RyzMVtcEPAlbRDaegzt/RIw2lmMpbfMOJPt5YrLhlgku+40cuD47jEYoQwo+MA2jRx7GnPrz2dY3FrgpDd/QRVe8XYRIgipm5bSP8D+M5QNZkIpBED4jBhIhIxwLt1pq+qXpglWgXfa8kP2k49wIP5o5e98ZYwOm9Cg/aC5i+B0Af/JT/jl3+aDU06cAJAjNI7plFXApKfQF7hIr3ANN7LqUD7edvGawdqLlJ3BT/HqI9iOEtMcqQRGIW0mxq6h4qeM5o1dgeZgm6VQV3yvL6fX4q6ZDio3Pi8S8hAqndLybTn5cSBhroMFdrTj4B2VS6b5Kz3ZN9C8+gmmxEMbKC22oKoXQrcyCDYnZZ0+ZahfVhcOuuWG1bXBCyFnC5XW6DKGkN0xIqWORIZ4P21nDZMfxGEN4jakyVw9hyRpg1jQWpOEURNn1hKAKvaVQf5AkgcPnTl0nr6ex3g2Nw7rh2v9eFziSuRu/8Bxwp8RCWdj4jFKdid+XQfA+BSoTL75Nz2qtuUX2B4JQaAODddfvKUcCZsnMXhnNyxaMhxxVd9OCpljBZ7AiAAMh3WRqgtZMVXUU/+OIZY9Lq7njvfeBVogNOMrkKyJxXOM3CGK5TOKN6hXZfdloFjO8Ai6HNC9D2hKk
 FrO1oGBZ
 y/I44TWNN6K8h2HpRwrsmhaAGPCsakH1DJQBfxzMZ9WLYdX8q5p6nbHC4Gjqh40u/OvaAJClyDwgmgcdiPhUA4KLIUr46mEXXd0MQQq1b5LmXR7IG1N3pO7z9N/XHM00SOvQYF/0u14cMv9InRrFzJ6SdXLfayKisr8tzgTk+XbOlWuv+lCohkTeUADlwXcCO/6eUo71sB0XLtUOFri3YDCZo+JZLl+o1cDDGBSZ107wwetrXuIjLFcjBdAFHUfnv7MvMhDNjoqWNtXtEvEhknfIaHQtaAK9fDfPqmSKTXPYMOtaGTKYdhD1PkdtMmzIHJ2jbMmjAMsZNyBPOtF97tgKXzEalDek8+2S1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper that sets the permissions of a given pkey
(POIndex) in the POR_ELx format, and make use of it in
arch_set_user_pkey_access().

new_por now represents the permissions of a single pkey, so rename
it to new_perms and change its type accordingly.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/por.h |  7 +++++++
 arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
 2 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
index d913d5b529e4..19b3dd1d43a0 100644
--- a/arch/arm64/include/asm/por.h
+++ b/arch/arm64/include/asm/por.h
@@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
 	return perm & POE_X;
 }
 
+static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u8 perms)
+{
+	u64 shift = POR_ELx_PERM_SHIFT(pkey);
+
+	return (por & ~(POE_MASK << shift)) | ((u64)perms << shift);
+}
+
 #endif /* _ASM_ARM64_POR_H */
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d4de88770ecf..767478d9e84b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2305,8 +2305,8 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 #ifdef CONFIG_ARCH_HAS_PKEYS
 int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
-	u64 new_por;
-	u64 old_por;
+	u8 new_perms;
+	u64 por;
 
 	if (!system_supports_poe())
 		return -ENOSPC;
@@ -2320,25 +2320,19 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
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


