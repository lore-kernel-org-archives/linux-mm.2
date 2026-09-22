Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0376C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44ADC6B0096; Tue, 22 Sep 2026 19:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423166B0098; Tue, 22 Sep 2026 19:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C5D6B0099; Tue, 22 Sep 2026 19:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F39A76B0096
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 81BA61A05FB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:45 +0000 (UTC)
X-FDA: 85243065810.10.D53D6A2
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA9ADC0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UrhlVVWW;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5oF3nurCQ+QFDROgbfsMr6dUR727+FSjg6LodV8bBM=;
	b=BGDihXGrMuKNvY0lKCq65/StYZudypGiO4fHCwGE5wBXiVlLqWaKcj2To1cPAwz3duw7MD
	e1LlskxG3BU8DG/mHNbx47jz95VZT9w9pb4JObuL62z8te3J4HCgLi2no/nFyfOGdwJf6B
	pA3h8wYJOnghq6GnUsOT4s2bjE90nLU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UrhlVVWW;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121523;
	b=cuFk7ee/EjnReYjm52bx8ZDxLDWTEudeARpVyx1BiTL8bpq2b1/FNJsdmAEqT7gVmD8/s1
	/IdevtPoGSdTNQVJoBVr6aAzWrpyS5FY6RgOuYDuPdW4ojycpalNKi/ujzz6Roieg7guZo
	xUCXyhoaGO+lFu7u2xzkDOkpFDpwr7c=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530d8a00bcdso3171811cf.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121523; x=1790726323; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c5oF3nurCQ+QFDROgbfsMr6dUR727+FSjg6LodV8bBM=;
        b=UrhlVVWWnE26eQedOzPD5EyIPA0H034oW5gWcrK1Ke5BiM/IFodO+YZQbJ5Lyv/Qy+
         /qH39hKkXRYCgbt90Peh3mzCk7DG5Giyl3aXrq/Pvi32y+/uvNRnoAYu6YExcLvPFv3s
         n/dWZM4pe9a2dsJrDnCOX1ybUUe5yvGDFdH0hrjjVk71fAnsFt8x7LMoN5ZLUyWuqI0S
         hEPs7SI6w70aRToizqQoz4luKMS+CcgYKiuJIfs0HTr8INp/JLlb3lg56p4Eq96j27fY
         UH1rKTTHmK64z+MrgOVTWfn0kaXlPAIssCnG+7zUpGS5XNA+AQ/zIUbeKTcltZN7ezaB
         aUPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121523; x=1790726323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c5oF3nurCQ+QFDROgbfsMr6dUR727+FSjg6LodV8bBM=;
        b=F7S6mYbqbFSmTYL34XkF7UBaOnmT63gWeFuppBHOiZYx+B1mtLK1VitCU+USkIfBjW
         ybBxZ4O1q4EyS9hmLGFnEE6CV6+PMAhHKBVZ4Cw5e6BC5kZj4xi+P9AJibuTMWuDRL4K
         kDsOLyWBbWXf/eaxvupSojvcrCnxYulME7DFd5glSHwSMKkEht1ibKjkoIJRu7cgd2De
         GzNW+p3GiEV400WP+QIS54WVmCnAx6/TQ46JoCPfup/XWfaETzP+CE+cvB65b/gydTcg
         uhGGkXmj+ztp1rwyE9O+EVCl+T8rRX1YyEGHPj5ZHv6GWw3WARnY4TJy9gg/i5sRcDem
         zwkA==
X-Gm-Message-State: AFuF++nwS31JaNaYg29jYX4Wa6HvhYz3k0KvT/G2+avQYyKumrKQLfjS
	UFqYnV1yCadn2xxJR5ZMyJRw59VUx2QZuBlC4urWS7QttTXblM81u9wy6Rfxuej7XE8x3o4/A/e
	N/0xkrYQ=
X-Gm-Gg: AYBFou3/8EXfy918udHLlLHZHQIad4YiBUr5R+iSfIzHcr9k0BZkXlzsyBedcSEpW21
	Dlpe4bvHByWsDkgX4flxcN1jbNYSbkluROX9ueDgOYCMbEUAazmRnb8N6UM3puea+OZUkkYWpFv
	0v5pPHw8Dey4xVSdzWJ82YFORI5Ntf+8ZYYk9FL4cpd6z+Go3H0w6Xaoh9JEGm4nC0jGjDcdScH
	iWKjpbnfXrhs+shfiPsE0ZNutvRf6ISwVzL4UU301qsNxdjEl5ZlUh8h3TR+sKebw+LgA0GHxBG
	+qyUfyCHH70tB1yXFGH9m6srotgefy2ipD0OcFlIpwIJzHNgy7sDWgPtoPrk72uEMqrLikaQSen
	AzEoip7VDwRIwe88Qkns7L4Zv/pqwFrC5v9mlVJE0eLJ4APxedcMK1xxtB4eQQJjiCJatN144Pa
	09nYi+jFOYQIrewym3qvEi3IW5Z0Io2g/kJPDL5T0K9MH8THG4vM7FqSM8xP9OdD/RS6nVDlDsV
	FUXdTVLeYyJ3IQafHLSdi9uCDCyVQGJuEDdl8QBur2LEqdpnxToys0pKMaedAe5wpzRDy+mzdI9
	Kyk64g==
X-Received: by 2002:ac8:7fc1:0:b0:51c:555:7dea with SMTP id d75a77b69052e-532eac6984emr21152101cf.30.1790121523008;
        Tue, 22 Sep 2026 16:58:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:42 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 05/10] mm/madvise: factor huge-PMD folio processing
Date: Tue, 22 Sep 2026 19:58:25 -0400
Message-ID: <20260922235830.2350770-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a8p1ak69fnnk4cfux95xb9tzpadatit5
X-Rspamd-Queue-Id: CA9ADC0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790121523-363059
X-HE-Meta: U2FsdGVkX19BM9NuBPi4PhCQkWKWO4+X5H7+3mfC1zzUkag2ly2UptH0sj175bRKW4z4FlcKIF2x9PbG4N9i/+xjqO5fCnxJTjcEZ4Ey6Oa+mPeSNjJoiPO2VMo/OoGPwmeq1Oydhx9d5/l5UbH08eVOFz47MCLJqJ6spefYGEzJV9jwZJfqby6uYn4Yj9OhYekPkn04Y2s/pcmkHyVccGy0xeuYeGCcjHjgprdAOaKkV4EJNjyZYckX0PyKkpuoT9Nx3HfqBKnHdCgmcplNXV/4cBU0q4lEARIRTXsI7QRxfviBfNNssBHPnEs0/59aL+zPKztkapJAUyUypAgW2RQE0OPaeVkcydhE3B9ImPvTZ0sl+C+5TSgIgcjMCn5Svvi1Y0ueIzej08X9axd2ohTTcKUN4XApBkcBTAu4CN7qXwrXpZ0qprL0xAXXJ/2CqMYdC1ontFYwlWJyv02MahE+APg8UbaGF7oFw2lXLXPUY8fd4hCnpc4tCKyz3YBbL3TfXlycXcYelYDwLHfrFtV3b6k36qy9QQhwLViIuaHkgg33a7HTTUff7aof3h6DdwKpBq1C4c4PuR6P7B3Dj6fqMSK2eppOPVdSQqF6xB2RVgjmPBy0gFs4EuNh/0Rb5z31f7s6jkzWyBgNI1Hl3g/GOREs+/Zf/Lw8AycCmmwBC2vnHVIzyrjsJMBTgkzhWK+kmUAiOrrvuT7urPAL7rlAe97IoRCTMDAmY0ymeehwnCQpABmixuXDqJdOjzvAldlSM6zww0x5EReFQ5Xxq46FQSBwQM+XRsPAtRB4VhgI+85SoNIBjacotcSBj9sso9QnQhX1VCsjoURcFBpDM2oLMGcEivT5j+sKUi2k7eSfRWcnsoVkPvbpesq7wpSSYrZfwYT/N5oQU3iufE/to+Y4X4WBUzJMMRJBa8JF+fdgg06vYqAgFPV/0qdrFcA63tCuRq3rH1OwR6+lKYz
 pw0YbLjW
 AoqiXyyIiQmeUXcIhPWzaLNOzB1hUrTxleRoyzrhlIkBxXQyXz9hT7T22HnnPwN7PjNaq+kZZinXQfgN5cmVcT1ZEQMHFU5vFjFK0UYMRyJYzFyOk+BVJ5VcNHBRVklJbGEn60znVoojx6JA3iNg/s1Li36BJ2OKnu77w+2nvkrwKPQaXiZZADnGysoobsXjcKvsN2BCi2KLTX44fnhhN270yjEHF11gQrUVn1xW+IZgo+LWOomHm7+A0NzdlGDjivJXtr7oOl5cFieCl/vyWTSIX5IZTUH5JCeMcQCpJWs8EwbM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge-PMD branch combines PMD validation and lock ownership with folio
filtering, splitting, aging and isolation.

Move the folio-specific work into a helper called with the PMD lock held.
Return a locked and referenced folio only when the caller must drop the PMD
lock and split it.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 70 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index b31b877c2c130..6b518f7f73651 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -394,6 +394,49 @@ static bool madvise_lru_folio_is_filtered(struct folio *folio,
 	       (pageout_anon_only && !folio_test_anon(folio));
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void madvise_cold_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		pmd_t *pmd, unsigned long addr, pmd_t orig_pmd)
+{
+	if (!pmd_young(orig_pmd))
+		return;
+
+	pmdp_invalidate(vma, addr, pmd);
+	orig_pmd = pmd_mkold(orig_pmd);
+	set_pmd_at(tlb->mm, addr, pmd, orig_pmd);
+	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
+}
+
+/* Return a locked, referenced folio only when it must be split. */
+static struct folio *
+madvise_lru_huge_pmd_locked(pmd_t *pmd, pmd_t orig_pmd,
+		unsigned long addr, unsigned long next, struct mm_walk *walk,
+		struct list_head *folio_list, bool pageout_anon_only)
+{
+	const struct madvise_walk_private *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct folio *folio;
+
+	folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
+	if (!folio || folio_is_zone_device(folio))
+		return NULL;
+	if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
+		return NULL;
+
+	if (next - addr != HPAGE_PMD_SIZE) {
+		if (!folio_trylock(folio))
+			return NULL;
+		folio_get(folio);
+		return folio;
+	}
+
+	if (!private->pageout)
+		madvise_cold_pmd(private->tlb, vma, pmd, addr, orig_pmd);
+	madvise_lru_folio(folio, private->pageout, folio_list);
+	return NULL;
+}
+#endif
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -431,22 +474,11 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_unlock;
 		}
 
-		folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
-		if (!folio)
-			goto huge_unlock;
-
-		if (folio_is_zone_device(folio))
-			goto huge_unlock;
-
-		if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
-			goto huge_unlock;
-
-		if (next - addr != HPAGE_PMD_SIZE) {
+		folio = madvise_lru_huge_pmd_locked(pmd, orig_pmd, addr, next,
+				walk, &folio_list, pageout_anon_only);
+		if (folio) {
 			int err;
 
-			if (!folio_trylock(folio))
-				goto huge_unlock;
-			folio_get(folio);
 			spin_unlock(ptl);
 			err = split_folio(folio);
 			folio_unlock(folio);
@@ -455,16 +487,6 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 				goto regular_folio;
 			return 0;
 		}
-
-		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
-			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
-		}
-
-		madvise_lru_folio(folio, pageout, &folio_list);
 huge_unlock:
 		spin_unlock(ptl);
 		if (pageout)
-- 
2.53.0-Meta


