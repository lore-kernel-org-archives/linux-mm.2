Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1D5C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 04:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4A36B0096; Wed,  9 Sep 2026 00:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47E526B0098; Wed,  9 Sep 2026 00:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB8C6B0099; Wed,  9 Sep 2026 00:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F41F46B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:00:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51A7D40854
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:20 +0000 (UTC)
X-FDA: 85192871400.12.F234C16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98E95140006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 04:00:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ug+EtDLP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788926418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EnBk09dXkcIcLsLMll4dE1qy96qjlCl4Bw9XNV8GeNc=;
	b=xv47be/eGHcaKJwmorxuwrE53tFesjsRuldTcrgV7hTdeK+7G6Aw8lvFtkC9tr0MLvBrg9
	hOTSR6QlSspkxbPdSMyEgjH3H6TLMOKKe3bO11Mzzx01rRB6bv4fhdhDNp43xRXTWw+SpW
	k5eA3N/s9+Oyu+e5uyFrVdRRbCC7yeM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788926418;
	b=I2Ck5ObSQnL6IJAez15ulIYs6usdRq6lXPsc52VzxmkKvFFVhoY8V+eN5g82Vemfx5t2C2
	/QmOF+yKyLzD6EQ7aBJq/MvJYlQ8y+vYdgYcKeNy5my4o9ZKHfojiE4KKVjnWjKM+gK1bv
	cHZZ8WfL8QVf1g7OqDdMc4/7we5T/+Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ug+EtDLP;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EC1D1477;
	Tue,  8 Sep 2026 21:00:14 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0382A3F528;
	Tue,  8 Sep 2026 21:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788926417; bh=U8t03BH95uIReM5gGaLf+aJqwm/RpI+Qj5wFNcim6XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ug+EtDLPJOfYjPOWsAmFFj9LTsUzGcUTlKj5w2+XZfk95JRIYfU2PaZcCUb8/j/cp
	 FTk88wBGOJpq/uW/ersOaw782hG69BZfGZCvQppHf/hhjgkTTQazRsn4wTM6CwCf5P
	 VTxYPV2buK/Cg+Tgtkge2y4SP+GHXDKVMk5c0y6g=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 2/2] arm64/mm: Standardize printing for pgtable entries
Date: Wed,  9 Sep 2026 09:30:05 +0530
Message-ID: <20260909040005.4148136-3-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260909040005.4148136-1-anshuman.khandual@arm.com>
References: <20260909040005.4148136-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 98E95140006
X-Stat-Signature: j93117o7gh5nbdtnswcdgtij6y7szmfe
X-HE-Tag: 1788926418-333053
X-HE-Meta: U2FsdGVkX1/6XUEzNaDR/IpUQr1PPZWrwaxbVnbLs4N9Gi6hWzZkTbUGYqh3F/sjXglrtLxKNmSyr1KI1f+q9Td6dsTzakC1le5Uyn4aC6YAYX6pU60qEjvxrP6/B4HiIIKT/3+tyT42Xz2ZoA0tVKWqoTpj5eedssU+1A8LieRaVw+4O2xaVRDwVbkrhiP1LYxkbOKsBRpXKSJ4WclkWcIkQX4jJ2O7Hu4T9a/GCq+krRDf7f1yNn9ushLuasNtMd8EMjkzwrxbNvQysEt18SlqfIbOWmjkhh0ItMXoApisv/NpeDu6TaFmF7o4dugwMdFHkg2Xo76HBmQcYDKgIpqv4qv6GPNf2ARucRbNY254tS0VTl7GgW12HlAo/6lCijxEzMDq0Z6hWBZrYOvsYquP5uEbLgGNz3LpCLrwVcN5dhU1hnllRMA1bOKhj/XnI8M8E+7kefQOgsrMjJykIsSPSATrelY3la4AdFfiipgtzi7JIu/yHeIPkofWS6L2NV86PwKnzHZ5bYaJEz2fSqTZLspRZNuFfbikUcyUUYsjA6sA161qWlXWEtK3aLLzcVNJUEdYav25kLcsyEyOj3XN/Qvyj/ynstXwzTzGOmoa4MnynP31/kSQj0B+EfiMS1rqyvhHiRox+zYgn9Lt48GQrTBruf6B0LDe6qCCoHnKXTPKFPYl8H7MuSoJRJA+FHd1GF0GUPBLOiKCLjyz+/SUEjU1T80lbKudzrzHPiW4UOwgxDQ9g1Z1ExtS8SikxQfU955xRrIzTGYI2zOa1mdLqtNpOo7dT4Lxo9aOmh4D1KSgVWlV3RQrdjkT3eGJZM1jPbgc05f03olagCgMDY8BWg24kkNrmPRKBbQ7HRevBOnnv/mKUDKkizkqckqXsTwJe10pwKuAljIeAK0cIpKLPd4TTYeuJVz+iGh+4ykXt7N63Ud21Yqx0FAK3RCSlYRYmjBxI3KAwCeSa+2
 k0jlwIqe
 rkAgwCJH5cGegLFmu3CPEl8FG1mJU6RMVolOJL7Ho3N8t2k8c56iSWoo4UuA/HK7UxueB1fIQopt8XGzBUeiYqeuINCtMbAq17THxoHRvVTSeHieKiCBcDzNNycCIrmduIB5y11WyJimkjTSi073VX33iliiE1hHBFomod51y9IE/e+HG+ivonnJ3+Mpv6laUnZClBDfOmUsHuYChJlos0tYtwA+SZpyYbJ8Bdn9MntO7f0dC2ozpQnaJ4bFuEHrbp0gR23Ds4MNWtxz6jIRpxquqpnqrQCoz4QNoxgttWdnMASPEyD0cWf7RwhiF5V3BSod4yaawCsTBZSfou799Bc1NTUtfcGAXshZsVVcbTm42Jdkh2Pe883cEhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Standardize printing for pgtable entries using recently introduced generic
helper ptval_bytes_to_hex_str() in core MM which automatically enables 128
bits entries when added later.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V2:

- Replaced pgtable level specific strings with pxd_str[] in show_pte()

 arch/arm64/mm/fault.c | 16 +++++++++++-----
 arch/arm64/mm/mmu.c   | 16 ++++++++++------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 75c3e463df2e..2cecf6ba6df7 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -131,6 +131,7 @@ static inline unsigned long mm_to_pgd_phys(struct mm_struct *mm)
  */
 static void show_pte(unsigned long addr)
 {
+	char pxd_str[PTVAL_STR_MAX];
 	struct mm_struct *mm;
 	pgd_t *pgdp;
 	pgd_t pgd;
@@ -160,7 +161,8 @@ static void show_pte(unsigned long addr)
 
 	pgdp = pgd_offset(mm, addr);
 	pgd = READ_ONCE(*pgdp);
-	pr_alert("[%016lx] pgd=%016llx", addr, pgd_val(pgd));
+	ptval_to_str(pxd_str, pgd_val(pgd));
+	pr_alert("[%016lx] pgd=%s", addr, pxd_str);
 
 	do {
 		p4d_t *p4dp, p4d;
@@ -173,19 +175,22 @@ static void show_pte(unsigned long addr)
 
 		p4dp = p4d_offset_lockless(pgdp, pgd, addr);
 		p4d = READ_ONCE(*p4dp);
-		pr_cont(", p4d=%016llx", p4d_val(p4d));
+		ptval_to_str(pxd_str, p4d_val(p4d));
+		pr_cont(", p4d=%s", pxd_str);
 		if (p4d_none(p4d) || p4d_bad(p4d))
 			break;
 
 		pudp = pud_offset_lockless(p4dp, p4d, addr);
 		pud = READ_ONCE(*pudp);
-		pr_cont(", pud=%016llx", pud_val(pud));
+		ptval_to_str(pxd_str, pud_val(pud));
+		pr_cont(", pud=%s", pxd_str);
 		if (pud_none(pud) || pud_bad(pud))
 			break;
 
 		pmdp = pmd_offset_lockless(pudp, pud, addr);
 		pmd = READ_ONCE(*pmdp);
-		pr_cont(", pmd=%016llx", pmd_val(pmd));
+		ptval_to_str(pxd_str, pmd_val(pmd));
+		pr_cont(", pmd=%s", pxd_str);
 		if (pmd_none(pmd) || pmd_bad(pmd))
 			break;
 
@@ -194,7 +199,8 @@ static void show_pte(unsigned long addr)
 			break;
 
 		pte = __ptep_get(ptep);
-		pr_cont(", pte=%016llx", pte_val(pte));
+		ptval_to_str(pxd_str, pte_val(pte));
+		pr_cont(", pte=%s", pxd_str);
 		pte_unmap(ptep);
 	} while(0);
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0b2d190d62c3..26f4cf7b753e 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2411,6 +2411,8 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 #ifdef CONFIG_DEBUG_VM
 void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 {
+	char pte_str_old[PTVAL_STR_MAX];
+	char pte_str[PTVAL_STR_MAX];
 	pte_t old_pte;
 
 	old_pte = __ptep_get(ptep);
@@ -2425,15 +2427,17 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 	 * (__ptep_set_access_flags safely changes valid ptes without going
 	 * through an invalid entry).
 	 */
+	ptval_to_str(pte_str, pte_val(pte));
+	ptval_to_str(pte_str_old, pte_val(old_pte));
 	VM_WARN_ONCE(!pte_young(pte),
-		     "%s: racy access flag clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy access flag clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(pte_write(old_pte) && !pte_dirty(pte),
-		     "%s: racy dirty state clearing: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: racy dirty state clearing: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 	VM_WARN_ONCE(!pgattr_change_is_safe(pte_val(old_pte), pte_val(pte)),
-		     "%s: unsafe attribute change: 0x%016llx -> 0x%016llx",
-		     __func__, pte_val(old_pte), pte_val(pte));
+		     "%s: unsafe attribute change: %s -> %s",
+		     __func__, pte_str_old, pte_str);
 }
 #endif
 #endif
-- 
2.43.0


