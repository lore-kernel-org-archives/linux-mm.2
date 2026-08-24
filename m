Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6085CC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 05:59:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166446B008C; Mon, 24 Aug 2026 01:59:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117C86B0092; Mon, 24 Aug 2026 01:59:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007E66B0095; Mon, 24 Aug 2026 01:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4D106B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 01:59:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28044140369
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:59:54 +0000 (UTC)
X-FDA: 85135111908.18.883B777
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6E34EC0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:59:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pDV991ox;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787551192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w11pet1aD+xRnvhlpr87q+i2HekPQtfMLvtIw3f/i60=;
	b=iZh1pFhaaw3u99r71XM0KElFayJPsQV4jXuEbnjv2wucTABOIK65SLHcY/y9Mi60jwsI3z
	lr9oYaYvEVT2kqE+9bz+108LovKnKzelFe+Pq56FFdtGWpm/ra79kTjTufLAhLIkvgx6tG
	0eTtxwmzv2w0fxOTWCyc1aB30MG2c94=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pDV991ox;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787551192;
	b=Q9+1dgnsVlNS02pqpAEY/nDiyURZ+1Z7NYH27sUpPSpbnj/xx705yg+lSUPFuAV9zlWhiU
	cWdW9NlWBMx1Glc2SJQ+BAtNS6UEeX1Oc1EQ15yRkHHfflIV/oLe8JaTtuaIHEJK599IZQ
	G+yLGRXx874wpn8TrqJYaZ11hga6mHM=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so4707911a12.3
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 22:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787551191; x=1788155991; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w11pet1aD+xRnvhlpr87q+i2HekPQtfMLvtIw3f/i60=;
        b=pDV991oxLJ1Z+M6LKOozd4RukMTQnI+XG4jx5t1Y4S3UKzBbpsKZ10UtyDLGvPDtox
         4QDc/VxSMHdE4XMx0oPTvzlj4B6ISYt1ZM6oh2YBYRsfnuXkXfK8r1dD1Db8xAdRmDHj
         kzqwq50HjiTry7XXzPxvgla9glUg0ti5Znk10EWwHHgVtqBtz8HQye2N9EQGDkBwd/89
         3EsIjmHv6u0YM3WREIjMoirkHdWWFlPNpLnP8GLKds3u1kLhlpzsMTuTK7ldjaCj4ED3
         DEk8/OJtARQSD9pZhNFholh2CJxLNGqTAyxGY+7cqtgf6KAWRKFXNl1txGKFBr4tyqLB
         XVhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787551191; x=1788155991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w11pet1aD+xRnvhlpr87q+i2HekPQtfMLvtIw3f/i60=;
        b=GOOw1b66KGgnYQGlKQKx57OzN+R/TGsRzxmQfsMjzOJImzRSszmsOKq8iEMgcMYwUD
         oRnZKu3vJiNI+DiYSDH7fFiTp4RBSJxmIFgWlgwZ3/bGDCzbtVuAOJ7FCqY3MOvo6e1N
         9MAy9QrK70C3mfOZ/KMQOirN9GHhaC09K18AyjkIFtUwzQ8vGiDGnYnnce16J0mCvHXE
         KEo+XLIVu0XYF5uo7A7BYU40gVL2mIIV+3/iho4ctsqznuxfOGqtX6AnSi26ai2D3GWj
         UBri3L6f+5emzFvZY4Gu99HUNuUUyvSFrwFsN4UIb4WEnpSon2UOSzQGh/uKOSXCiSCW
         ce4Q==
X-Forwarded-Encrypted: i=1; AHgh+RpkyBJtgg4TqaWbIKkLueQlDk2f4O0T2t7xEbazRLKH2m+j4amnd82rqw5/054U3YtL/rilgiT6sw==@kvack.org
X-Gm-Message-State: AFuF++kW2xB4hRa7Qj3yjnxXTmIKs0ungaHRslkVrSc4BWqrO5dUm/8m
	7IoGj+xlTg+OIzxnXLIQnva68tPAcIHcJMl9U2yd1rAnZ+cQtLuqWtD8
X-Gm-Gg: AR+sD10AKSQBX2TUfA1IxXGU9Y+LrMl8UvAXo+LL8DNMh4mCuuw9apcUApXB5B5+ilt
	HbxYp785PpJXPf4bA7mDKME77VIEPNJVE87f/ng5kahcidCYMG9u7CEfG1z9vWhJw8BSKjbZj2f
	WsWa49BNbNZ27m/1qVKr9HxqVbhcNS2cQhbUHyBJ5CiaXgX2OAWUcSxD+e/YXUAYysgAk/wThtK
	MczLu//vKeXa6whfZ2IdJyQL6RqKqCEMb7L+FfHsEzHDwFolpDRvjOSwiRb4HzKsoUN1jJti90J
	tpdtm1v4Iq8KemADtrJMxOcxJEHUNt9aG2owIlsc8I+4bQe7n5y9TUO0J51icCyyr1+lEG7gG5D
	hz+VJM9PR8+/rqzuf9HvqCHehNUlBmRBDsBy9V8twhuh5khlboIxHdEohvW9Z+DNvAwe/9Fs3BT
	pZeIqC56ckhdMVpIbVnaYY/x+LUnSLPybwfzMMRUnL68ORT1QXFIplcT8KndZk18I5mvTXJMk8v
	y7Ucf6ZD+dv3IARLZZqSc6GOsEXyhZFyAYqiG97crysBuMG+tilSyEet9GpIN3PAO/MXdAEF4XC
	XEzh0TFjtiM2Po3qeSz7VBy0LP9gUk+ctLFPbDCVNgmBSKRtHlT5le5Es3RoD3mGWXhG
X-Received: by 2002:a05:6402:4546:b0:69e:2d56:690a with SMTP id 4fb4d7f45d1cf-6a42f133bb5mr22706126a12.8.1787551190634;
        Sun, 23 Aug 2026 22:59:50 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b297-8e01-ed33-c55f-13fa-4725.310.pool.telefonica.de. [2a02:3100:b297:8e01:ed33:c55f:13fa:4725])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a59e2da49bsm7951950a12.29.2026.08.23.22.59.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 23 Aug 2026 22:59:50 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Russell King <linux@armlinux.org.uk>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steve Capper <steve.capper@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] ARM: mm: LPAE: Change THP helpers to comply with generic MM semantics
Date: Mon, 24 Aug 2026 07:59:38 +0200
Message-Id: <20260824055938.27594-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3aymigpg1zh5jesxefb7zgz6tuxryr5o
X-Rspamd-Queue-Id: 6E34EC0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787551192-923135
X-HE-Meta: U2FsdGVkX19fZpKkY3dQvG/8/x/8v/5uJo/0qMR0cVyR/OZGWid9gTGJGSnGuwhTJCkzsUhUaY002XafpBo8j2eL+kGRSBzc62k6dRes18gX7Pd8yCzM//01exKlwZdJ3TQiH5XsmmyPIfVPYe77eftGUlSzV45GSCj9MbR460WOaoroeEOv9fEIiN4o5up4VzLlp6T66FDmCF5ySnGMejjqG55kjxgfNnKW7EDYFf9dGSCarnVEEZFN1WrQ73oKdPzQY6tNsbmeWI3i0F33eCOeIeTq/47CIeokB+namf0nyNHocC2KkcDyKdRfsqjMCr5DeuSIFvXIJbWj3r9ONrUPqly7CquSabQrrJV74lbQtI1U2POnLALrxoGfrTAv3wC+rwkSvfSarVvE2DOpPZR/ZQIqP04JBvcfZ8HT7MGnhZX6M4fEe1pL/idKXoxzV9FjEChFKtWegHbxCOLfR3oNc5xbU9PtC1xTNVWG3M9vYFGlcYi6oNOp3qxPu+B8Lc2I8AopW9PF6G9zUr4ICha3QijccvhtLDhBzKhaYccH3YL5zRHKNemyE1pZ6Kj5tUh7LSV8wdWuCLkuPNJwBXmxn/fbg63Rv+c2DGBTnjctEIQJ7cvDDGt/gzu4u5O6sryeIQD+N9dISF3kQCjlYVHsO4F9zqNUsDJJCIvvIlKtFHPFQAElUuWMAJnE6uTTVvlEoPEilB2l0Tw7C7PzYDx1TWNDwYfL92Rl7PR5cMHu/bjuJUtnlOiOA4qLVRs2nbpkL7JrhW2r9F2hOukA+H67pRmQQbDKdmC4/3phq5w4gZIY/Gwqopn7POCs4Ki6mIBZDMzttfUAqvd5qYt21SW26gHTYYNA4jUhs/IxYPq/332HJozUe2zJp4xJgf4hBlHy3KkPnyMi3KT0VcIAu3b9IwNo8LwIDtuPZgep7aGNhszMVGQ5NUbZ+wUaeoHdBYxMhcKht9NxCh6d5SS
 +Jtv5WTE
 KgnCmQQUkfz+zv5OA213Tfj5DygaHBqXZLUEXArm4YXl0XGZv2edCD1C4pKKwfCvbyQFdxvSmZq24LUWAPilQgTBM+jIsZrrDKjr3ZLgyKfuq/cT87bwpQ/7apOMbWR651RpDb20+2QOYMNuBPvH91FumWrU7KEpxLh1Q1U96Dm5JsSunjxrV+rCwF4bxvy3C4CshoQ358DqjuBPnoBvMxnRxtYa7Ps5I0v6oO2j2bLb92FF2E/rp/ZCa68h6kFhu0SRCUzy9kPpbrC+Uil83KMwQfk5RoOPzrvnTqCM1O7ZbyuObIrM6gxJwC4cBy9HTfZ7YpxyCRuNoah9k3UsbDjQUhSRM9s0bJQ+jx4uqTGKqGNl7o8aBCy3cZWV6Va9HxThbXe/OKo/2nyj/NRW2tRu+J59HPpoV2rz91c07gJzAeOcdrr1J5p3fas2h7sfUKHj1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmd_mkinvalid() clears L_PMD_SECT_VALID from a huge PMD. A PROT_NONE
huge mapping also lacks that bit. On LPAE, pmd_present() therefore
reports both entries as non-present even though they still describe a
huge page.

Generic THP teardown then takes the non-present path and decodes the PMD
as a softleaf entry. zap_huge_pmd() cannot find the folio and leaves the
huge page and its deposited page table behind. An unprivileged process
can leak 2 MiB on each mprotect(PROT_NONE) and munmap cycle.

Reserve an LPAE software bit for an invalidated-but-still-present
section, and make pmd_present() recognize it and L_PMD_SECT_NONE. An
invalidated PMD no longer contains PMD_TYPE_SECT, so make pmd_leaf() use
the resulting present state rather than the bare type bits.

Bit 56 is the only unused bit in LPAE's four-bit software field: the PMD
definitions already use bits 55, 57, and 58 for dirty, PROT_NONE, and
read-only state.

Since pmd_present() no longer indicates hardware accessibility, provide
pmd_access_permitted(), which checks the valid and user bits and the
read-only bit for writes. This keeps GUP-fast from accessing PROT_NONE
and invalidated huge PMDs. Do not retain the transition-only bit in
pmd_modify().

This mirrors arm64 commit b65399f6111b ("arm64/mm: Change THP helpers
to comply with generic MM semantics").

Fixes: 624531886987 ("ARM: 8578/1: mm: ensure pmd_present only checks the valid bit")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Testing: In an unpatched 1 GiB QEMU guest, 400 cycles reduced MemFree
from 981 MiB to 160 MiB. AnonHugePages remained at 819200 kB after exit,
and drop_caches recovered nothing. MADV_HUGEPAGE was unnecessary with
THP set to always.

The patch passed the 64-cycle reproducer and both CONFIG_GUP_TEST
fast-GUP checks on QEMU and Pi 400. It also passed DEBUG_VM_PGTABLE and
a four-vCPU CONFIG_PREEMPT=y test with 20,000 protection changes.

Full zImage builds passed for LPAE with and without THP and for non-LPAE.
LPAE+THP also built at v7.2-12555-g4352b8aee980.

 arch/arm/include/asm/pgtable-3level.h | 30 ++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 7b71a3d41..b2ca7408b 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -81,6 +81,7 @@
 
 #define L_PMD_SECT_VALID	(_AT(pmdval_t, 1) << 0)
 #define L_PMD_SECT_DIRTY	(_AT(pmdval_t, 1) << 55)
+#define L_PMD_SECT_PRESENT_INVALID	(_AT(pmdval_t, 1) << 56)
 #define L_PMD_SECT_NONE		(_AT(pmdval_t, 1) << 57)
 #define L_PMD_SECT_RDONLY	(_AT(pteval_t, 1) << 58)
 
@@ -116,9 +117,7 @@
 #define pud_present(pud)	(pud_val(pud))
 #define pmd_table(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
 						 PMD_TYPE_TABLE)
-#define pmd_sect(pmd)		((pmd_val(pmd) & PMD_TYPE_MASK) == \
-						 PMD_TYPE_SECT)
-#define pmd_leaf(pmd)		pmd_sect(pmd)
+#define pmd_leaf(pmd)		(pmd_present(pmd) && !pmd_table(pmd))
 
 #define pud_clear(pudp)			\
 	do {				\
@@ -177,7 +176,9 @@ static inline pmd_t *pud_pgtable(pud_t pud)
 						: !!(pmd_val(pmd) & (val)))
 #define pmd_isclear(pmd, val)	(!(pmd_val(pmd) & (val)))
 
-#define pmd_present(pmd)	(pmd_isset((pmd), L_PMD_SECT_VALID))
+#define pmd_present(pmd)	(pmd_isset((pmd), L_PMD_SECT_VALID |	\
+					   L_PMD_SECT_NONE |		\
+					   L_PMD_SECT_PRESENT_INVALID))
 #define pmd_young(pmd)		(pmd_isset((pmd), PMD_SECT_AF))
 #define pte_special(pte)	(pte_isset((pte), L_PTE_SPECIAL))
 static inline pte_t pte_mkspecial(pte_t pte)
@@ -189,6 +190,19 @@ static inline pte_t pte_mkspecial(pte_t pte)
 #define pmd_write(pmd)		(pmd_isclear((pmd), L_PMD_SECT_RDONLY))
 #define pmd_dirty(pmd)		(pmd_isset((pmd), L_PMD_SECT_DIRTY))
 
+static inline bool pmd_access_permitted(pmd_t pmd, bool write)
+{
+	pmdval_t mask = L_PMD_SECT_VALID | PMD_SECT_USER;
+	pmdval_t needed = mask;
+
+	if (write)
+		mask |= L_PMD_SECT_RDONLY;
+
+	return (pmd_val(pmd) & mask) == needed;
+}
+
+#define pmd_access_permitted pmd_access_permitted
+
 #define pmd_hugewillfault(pmd)	(!pmd_young(pmd) || !pmd_write(pmd))
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
@@ -213,16 +227,18 @@ PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
 /* No hardware dirty/accessed bits -- generic_pmdp_establish() fits */
 #define pmdp_establish generic_pmdp_establish
 
-/* represent a notpresent pmd by faulting entry, this is used by pmdp_invalidate */
+/* Create a faulting but software-present PMD for pmdp_invalidate(). */
 static inline pmd_t pmd_mkinvalid(pmd_t pmd)
 {
-	return __pmd(pmd_val(pmd) & ~L_PMD_SECT_VALID);
+	return __pmd((pmd_val(pmd) & ~L_PMD_SECT_VALID) |
+		     L_PMD_SECT_PRESENT_INVALID);
 }
 
 static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 {
 	const pmdval_t mask = PMD_SECT_USER | PMD_SECT_XN | L_PMD_SECT_RDONLY |
-				L_PMD_SECT_VALID | L_PMD_SECT_NONE;
+				L_PMD_SECT_VALID | L_PMD_SECT_NONE |
+				L_PMD_SECT_PRESENT_INVALID;
 	pmd_val(pmd) = (pmd_val(pmd) & ~mask) | (pgprot_val(newprot) & mask);
 	return pmd;
 }
-- 
2.39.5 (Apple Git-154)

