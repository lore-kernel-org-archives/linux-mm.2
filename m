Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F63CCCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2C58E003F; Wed,  8 Oct 2025 21:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7715A8E0002; Wed,  8 Oct 2025 21:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639D08E003F; Wed,  8 Oct 2025 21:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7B48E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DA75460E8
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:55 +0000 (UTC)
X-FDA: 83976917430.28.852453E
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3409D140007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=lU4PWr9h;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf09.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQzFW213rLwxUVwSIOmReg2LsoZscZFNSwvkZCWkhKs=;
	b=k2vBoSfV9S6NBVizvgz52pZBlwlyVc9EhlsOKmbzc5hAfmmzYNNoO8D7wF2/wEIw7FaDHG
	HBrFCRZ7Z/Yu88/LuJf4LFnWwMGHR8IltBeiqUZw5eRiZr/SQOLbWe/xvI4NiLVRdm8Vbv
	rSABCIJsPDygjYKzWRwjTwVZ57cOafY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=lU4PWr9h;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf09.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975133; a=rsa-sha256;
	cv=none;
	b=KqrMcdfgidZ1wl9Z3W0NYzD3EX3szweLZd6C7N95XtS4GurcEm+TbrNa61z+humQdqrinb
	DaUndZgLoNza84CJTY5vsannkItI9UEpk8hLXuy7smR02hi1Y0YmXszNrKLlfs9G2p/gDG
	G87EFKWG7W573+kKX38UkBPRPgIwPqA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2697899a202so11015255ad.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975132; x=1760579932; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RQzFW213rLwxUVwSIOmReg2LsoZscZFNSwvkZCWkhKs=;
        b=lU4PWr9hX9nfo+bygcdlTj4Uu3OR4SBO0Ru1D1hc1bcnDDtYFBY5cuB12yD8AjDno6
         2+PD3d0axmHYf64EjBHn2DqZT5CCwi0buNF87bcouhx6fZVay+E7X1GsacsDgVRnxQ66
         aN/8DGI/7ga0bYJbLkTNYsrtB4HEkqOgUgFeKU08L1miHQx01ZAMTF0+fQ8VBeucmity
         iWR7xw3fQDRqnTbVz3/x2reQNC6nmccgABMndlju+hfEDV1XhuuDy+E2ZV6rcnplKuhl
         oU5Mfjz1gE7qUiaqfFjprKOWeobn4EpsdJyW+/zP+eonDXU5hVv/X/mZyXhPs+Z4zD/5
         Viqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975132; x=1760579932;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RQzFW213rLwxUVwSIOmReg2LsoZscZFNSwvkZCWkhKs=;
        b=X0s+fQ/nxc8mMRIXOlV8cI40C61QNW1pC/5Vd8Whv7bCyoTd+qmQAC0ajNsrHvwynE
         T/K+BvlLpHovHv1eAmrFrGX/4ENnoiK+9FDa5GVwSTz9qItNlT9q0cX7J4fGf5Q/DM/x
         X4G1vce4X2KVN8bNW3+PWjgDflXfKykjaUj1XJK+U46BlKVQE5cWmgSCvoL9iXc1bKak
         9Z5G8Qb8szFzBKZ8Z2OTuYrvmJOieG9yeDFzljkhd0DpUFyMai6zauhJ2i2uZNEZtKQW
         gYDbYDjit200HWn0gf5HtJdSPqdqwcTUbHfZpOa4HHz5N1a0ojQZF0HoAOYiJKCyvs3R
         MkQw==
X-Forwarded-Encrypted: i=1; AJvYcCVOx0QD2M0JuPoGMsLRYxuj9TM6QLM5N3QOKR4On8ZJQYyox/1kqMKFzG2abrEyEuxIOKqCgp0mTQ==@kvack.org
X-Gm-Message-State: AOJu0Yxrql4nRpU4vNBPSiJJgBVHT90ieALvrTKaISQDI6tMdlTMuCPt
	2C+sC9pFl47W5bUX3ZMhgWag90BoCK9s5mhI6dBInGZz9xPubFZO9TMFG6ebjKueayQ=
X-Gm-Gg: ASbGncu/nvPd/IioMq1Qg3R3CyvoxeSMpDT4/nAZIwMdadsFku5nQDTjEnLryDbQmG4
	LsmAhyq6mPK/d0TBLQfy9gCpe/s29h7mMhQYQt+hwX7LzMxZHTlUv254J/A6zVJYMPLoFlTkHDk
	pNPxmjWBbnMgwKmzXbZ/mp1KLB7I3fh7BcT/4uaMcxOzBcCzWO6ysWaHB9mzm97ufOoIUUFzI9K
	jBeOnhKq+O8KzEHC68yFHwU4KLeztH+3TJEssJvqVSnR2AgYlmGtm8g5QNYTW453O87v3Dmh84q
	vczc7hTFS0ktDKYZDne+bsC1zHQONKTCr1cgC+Kx72bVy5l0i7VuHjSFtqCpi9ibRH5NTOaVM03
	i7cH6xfATUOIWJO+fFpUkCA8TgSi0DXxlVMxbo4LG6tI5c9ZW6LoZ84/gR7isc5S5CYxv
X-Google-Smtp-Source: AGHT+IFM9Uy17P2+rIA5+/u+UBcAfOioBDn47CFCZ3Wn+HT4qk9AYA0AUJYNGbTh1SkHtKAVK04UZA==
X-Received: by 2002:a17:902:f788:b0:274:506d:7fcc with SMTP id d9443c01a7336-28ec9c0c7e1mr134257655ad.6.1759975132141;
        Wed, 08 Oct 2025 18:58:52 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:51 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2 09/18] riscv: mm: Deduplicate _PAGE_CHG_MASK definition
Date: Wed,  8 Oct 2025 18:57:45 -0700
Message-ID: <20251009015839.3460231-10-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3409D140007
X-Rspamd-Server: rspam03
X-Stat-Signature: 44dticcag76abs6wzfcuzj78cn695rdu
X-HE-Tag: 1759975133-209268
X-HE-Meta: U2FsdGVkX1+oPjyjJFGEX0O/o4QMmDwZ4hE06fHmYWTlN1BQfpB1nMAU1uIHOAvGkN9dhZClaZtroifHUC1XnUwUAKgNt/MgnlaTuk30upjJKKdqYuXUvP6Qxz0x4vIPazC+t6GY/v/hVGs/VvycvjdaMwmeiKUuqqG4IZ0bmSsYVUlEJ0m+R5U41NMastOblxDW/FWIxdLKlcwj232i2SlWk0sbpcLIkhXVuU+zTZIqf/cgw/sHlvrleCTVy5COjTXcU7Gi+XLHaoFmlBc8TgjzLsdI2bOv2hr8miMDRDVFfyO+UebJIS0DsKW6eKOQr3u/z02HJrKqbfYr1oSAIKLtRdJeUxleOwqRUKBBxMRCpfxTgLDyH3+xU1MTH1k2uYhsE5Obu2KjDw/ylcF0XFJWIY+fPJYoI/avF/dGaXtSY/EN75/c8IexfLJU7kO144X2pLLwy2F1gJ1SfDXZR0sKnIWfJtVKJqqBnc6Ap1hfdZimrt1nZ7QpmsYAsdAVpBg5pfw4+gJv6sgzWG0wtZppwCnVO93/wNR07TVXlGrHbqdQUOlsWEAb3FLareXjF+RMlQou/LdwQ6I4RkMFudlOEwFVUEOiJi1wUNVkFdB734K3tNazZHn9a08jxDerem52L5eq6orWWoZnnFM8PP5+ZI7RlnMTHq185UgOZHPxBokGexK1NjdrAIC1SkhHOdDeWeN6/DPalgN1CgtAjB5CPm7UIDu1ZadMKFHOoykb6sJpcf8p5dn+dHNIevkeyV74B5PYMtvB1yy64MleIRs8xsge9Qzer8wqGy5je/KUSW7DcF8D+G7TSRdK3Z1dHFq6tT/WhpGnkv83Q1772nBa05YuKsHf2Wj4WyaxOtr0P4hxLl1Upb0hgUuFmpyzABRUjKQ+eXaym3nqaTX9bocy1b3z4t9TWoWnjYdBSpwzIZR8wFWyQbMlg0XXbT9yVj55PQNt3X1ZSt+ytEc
 +99i1se6
 vgJWk5oiN/MFumxnd1g2Q2QA3igIPt1t2PFrRFDKDyA6eBmOpJO/ICAiXISBOxXFXXG+ZJvENMgZ2mhfD0VWKxk7lfZHuB0CrMrShmyWmHN1rwccW8A0XU5TW6mkxdX3UEnNk137jbVRyKqKLBAXbjJgByl+BJPToMSVzQ03GmT/H0e2H6FLkAM0cWw/yBEGHZIWoZ8WavHsnLxhwRnvXCQ1D9Y+t7MtLhFHxHzob9/D6Ooe2GleTykvzXXnE7QCv0GJ4UmAqUDxIsyZfe8EPG2+kdWYPeui74PTUPiJO0mFGMPAp9MAjko7lCC++Q+ghYs7kDWyiSdPHs4llxb1fl/9fdW9R/lis0af/G5FHQrpLq2sjjTmLguw3kWDONaOiyBUVHVHPDz51Jw1AHlo+WscFcUIF8qxab5yqFrUt/EmZxKS19y3FHcGKVaXDUVpmqLPSUQPQhsXfW5F60NzTHWuV5HdwRZVvgCmmln65CIwesgDv/078qjDDLi4BVCmiaPcQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two existing definitions are equivalent because _PAGE_MTMASK is
defined as 0 on riscv32.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/include/asm/pgtable-32.h | 5 -----
 arch/riscv/include/asm/pgtable-64.h | 7 -------
 arch/riscv/include/asm/pgtable.h    | 6 ++++++
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-32.h b/arch/riscv/include/asm/pgtable-32.h
index 00f3369570a83..fa6c87015c480 100644
--- a/arch/riscv/include/asm/pgtable-32.h
+++ b/arch/riscv/include/asm/pgtable-32.h
@@ -28,11 +28,6 @@
 #define _PAGE_IO		0
 #define _PAGE_MTMASK		0
 
-/* Set of bits to preserve across pte_modify() */
-#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
-					  _PAGE_WRITE | _PAGE_EXEC |	\
-					  _PAGE_USER | _PAGE_GLOBAL))
-
 static const __maybe_unused int pgtable_l4_enabled;
 static const __maybe_unused int pgtable_l5_enabled;
 
diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 7eb23c24310f9..d17382c0fbe59 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -66,7 +66,6 @@ typedef struct {
 
 #define pmd_val(x)      ((x).pmd)
 #define __pmd(x)        ((pmd_t) { (x) })
-
 #define PTRS_PER_PMD    (PAGE_SIZE / sizeof(pmd_t))
 
 /*
@@ -166,12 +165,6 @@ static inline u64 riscv_page_io(void)
 #define _PAGE_IO		riscv_page_io()
 #define _PAGE_MTMASK		riscv_page_mtmask()
 
-/* Set of bits to preserve across pte_modify() */
-#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
-					  _PAGE_WRITE | _PAGE_EXEC |	\
-					  _PAGE_USER | _PAGE_GLOBAL |	\
-					  _PAGE_MTMASK))
-
 static inline int pud_present(pud_t pud)
 {
 	return (pud_val(pud) & _PAGE_PRESENT);
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2bc89e36406da..61de71a8ba978 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -206,6 +206,12 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define _PAGE_IOREMAP	((_PAGE_KERNEL & ~_PAGE_MTMASK) | _PAGE_IO)
 #define PAGE_KERNEL_IO		__pgprot(_PAGE_IOREMAP)
 
+/* Set of bits to preserve across pte_modify() */
+#define _PAGE_CHG_MASK  (~(unsigned long)(_PAGE_PRESENT | _PAGE_READ |	\
+					  _PAGE_WRITE | _PAGE_EXEC |	\
+					  _PAGE_USER | _PAGE_GLOBAL |	\
+					  _PAGE_MTMASK))
+
 extern pgd_t swapper_pg_dir[];
 extern pgd_t trampoline_pg_dir[];
 extern pgd_t early_pg_dir[];
-- 
2.47.2


