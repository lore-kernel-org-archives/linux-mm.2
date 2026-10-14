Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B86F0CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B73A6B00A4; Wed, 14 Oct 2026 14:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 690006B00A5; Wed, 14 Oct 2026 14:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556996B00A6; Wed, 14 Oct 2026 14:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297CB6B00A4
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:30:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26CD8804BC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:44 +0000 (UTC)
X-FDA: 85322072808.16.9860FEC
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49707A000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:30:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ce6ioD/v";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792002642;
	b=FJPyN3DFoHzWTfSNC5PZzV1aYmbjy6Q1krVrWRJIWq2lFdrNqSjOARRlmJljenZoCoj3O/
	bQywYnlF2cdp1c9KNZOcRCzwEiPjyeAZ8b/0Hq4OIXn3OoGVBCCL8f1yNF8qVCSMIJI+r3
	gImLzxYZIz8nfQa9v2H8i4285APGQ+0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="ce6ioD/v";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792002642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ge1qlR5ZIuijZyTa8DlHKLyf7oJA6xVZ0symgBKYKis=;
	b=HpPdB4YLRyjnTRj769YYthptzUCF1LVppwEonxr+coxkQN0drr3wxeRy0QKGLDpqEIg90B
	hwRt4cxylSDdTnW16I+/PBYJgSvklS4vuu9tLDQBvLygEBr9fD/cf6tltjQ6ZUK4Ym7iHD
	gm1zdk3rt1EfL0zI+Fxrb9Auf+WqTGI=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-930c0f9c1b1so467427985a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792002641; x=1792607441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ge1qlR5ZIuijZyTa8DlHKLyf7oJA6xVZ0symgBKYKis=;
        b=ce6ioD/vBLF4Tw+ovBRG5xZjmlu2rcGJ5af/7C66pgkUatwlVn/XaMsstIzZk7foxe
         V244VRpHStupRxXC0V7+N1Ij5oTD+Mpgz+35JexUvaA+FfVSZNX/Cx9lD+7EX1eMRh7P
         dEiqfpRnTBKL9MSJXP12L1aLSry9hkdh2MjBsdLjPcohM0QKN5JlwV/zUASp91UurZjP
         2LIxbfP0Ldx3MVwbEUCQk7LyfJvdaG6lGIXMdRqHNEJpMA5dDMjFYWIOi77b8ygH8Qd+
         qB1DW5wfBsnLL7SD4QUDVNNLx9sVu3753GLcA3FIcSackfN8eGXk+xbMXGudQtR9sUDT
         z2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792002641; x=1792607441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ge1qlR5ZIuijZyTa8DlHKLyf7oJA6xVZ0symgBKYKis=;
        b=04Rx4h2H/80ALW2/v6kTLX/fJnGVSb/puCy1lxk5mfTa6AuD2MxrOQEiwWwnHUtrd4
         ng4AI9ixgi0oP44t0coUKBu3NSQ0WijXdKNf0NHAUpVV06xFKzom8oMWNQr0V0181rg+
         An6dtr0yzmUnbe7z7CWLlIkavG0Uw78Q+nSq42xdwZdoev4vzUUKhMGAnK1yonjpQWGU
         ZDYnACJXOZueyULrAqnx2MpHM8CA2NOIvnRDK923AQArXLu1+jGQlGjW6o9hJ4vjDrO9
         EERIBbflEV73lo6kkLaV6IF6O1LoUyaQoMlrJSkM1HwwZiEqzUHvOHnHFpeRTF/nJEA7
         KDpg==
X-Gm-Message-State: AFq9FYI3n60qyTuZN0lHgoE/S8Rn/Gxkik/gl6wvKbT+/dWKE5oDzgIA
	tf/D4gM7viZly11vok6eq7iBA/FbmAkkkulXQl8Kt5Iy4aPTFY75R7vj1JQzult6FZUDZaSU/1r
	/rVGmEEk=
X-Gm-Gg: AYBFou1J7mluenmGMn8oe+HGA12VCddIcv1k5SghZMXlnu+PnD6GJ0SQF5uLZlOR5/Z
	QLqOTBk4Y9YYdg9PFfloyo2EObo0nzSg8sLEvP4xiWhNezbGWJBtB4V+SDffjQQTFt1gliRIVku
	eleoRG+V2KMl+PrLRqHkYQZKdER7VQlQcbA633CEN0nJOwYSLscq4Q5EoMr2F9MBl3N7NykkdWG
	QHKpGJRBgHsx4ulGj9zMFdL6Tnha36RNrNMGWz5YAhnLLaKyMz0XO8BdA0ryKROEU2nPrtbS2JZ
	FXhHY5sJN9czB8p9KfOeFy92asVlPgmeZKobTlJsU4hmZWMCfNfOAfgPhHxcHZFinTHLlEeWKKT
	FunYJKBhF3qEPb5+cq7O6hWhbToUTUjoxQPykvlhZbVdcRbboHzBpcvBJn/zFpmOok/s/3qzWmT
	9Zs718n0x4gzWP1AxBVsAZL6uQ2poqKd+vyOGVzycgTdJiEdxylUTPUe1+ODivyVhPmYcMjwoEX
	Ief1t9eRp9So+CgceEdjkpR5Mz3gJLo1h1neJGM3cYfDYpGtzlr+n+EcTyX
X-Received: by 2002:a05:620a:3942:b0:93e:e531:b78d with SMTP id af79cd13be357-93ee531ba1cmr1506123785a.7.1792002641364;
        Wed, 14 Oct 2026 11:30:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef508811esm556593085a.36.2026.10.14.11.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:30:40 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com
Subject: [PATCH v2 08/10] mm/madvise: separate the PTL-held PTE scan
Date: Wed, 14 Oct 2026 14:30:22 -0400
Message-ID: <20261014183024.2075709-9-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014183024.2075709-1-gourry@gourry.net>
References: <20261014183024.2075709-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49707A000C
X-Rspam-User: 
X-Stat-Signature: emfoj8ejmwkzbkfaejofca416yyj5az8
X-HE-Tag: 1792002642-724294
X-HE-Meta: U2FsdGVkX19//c6VaSHne3qQasZvW0bdha2AWX39nhhPGurtQMvCLc6jeWDIwcvz7KiPbV44xRocHL8HYhxd70b4vr+fK8S+H34vVpX/0mG7PwT7yyBnLo1TqgnOSA9xqws4q+HjXu125zFPOgS9X3pOegRMAXGs5NHs47po7H84vveEVGFElluheDSHY09K9Peu3S3C5KXtmYVM8Fke5MhJkdzyFAlhWfvkI1c+vaQtAbhVIkBa0nOLLzj0d+esziUFQCpK2Yn8QJj9LJax88V2ixbMeN5RvYNXa8x2LWLHcE9Q6yX7oAO6d7D6sN1OSfgszchVYTj2nelWa3hqdJ31FP3/Hd4X86TZNNqYpdUGpYna4ZAmcUeZi7kX8O4bgg3ukSh4FwIr2K98jPp1kFY14kHqjqEB4GzXpLDxdbQL+58KelcSi/qkScr/0eFwPTa7nW2M56gmk8J7vyThvYEJ6pnlsJ8TdLrmmM9qhKLqHJXh3NZX6dmw4k36Micitf8+/GMCpTrFn01raP3b2D2gNboq4kbikKreeOwCF3Vuu1mxiCUlSn/Hmld+w/6knKpo5PfFjdxq5JLzo15VTG1LBqZn71BR7kPCnhHrGE2pSKTA9+H++u2EzOWz86BQl4/fOrDng0L5ivwbWFKpXr33+hAq3WJBiPeJaQo/x3z8rsfZsoPDURdsLGjb8KWE+Lb0CM6SiiRnpRBqd2tXuFBUZ0SznHCUz00Y9tEZdbR3vuhXu0Offi+LL7k5UvtFVWFScOo9F0LsQVLhtswGAG7X0IgyOwR8ju3s1eSwGYsG7XRKKdmrJu4ay/NSt4gitkEjL6OwOit1pt0vAd/F/zYXMhw+FsNdVRJjFrRqKkk9xdJ9xOOC5ZAmROMHRzxLHAcAlsT284LBoeyx+zUUVEoW4y83jPdGs0v4WgQjUtpOtMylJ0ikgjkfXWukawCmliymqLslZ99O+DMnyZ3
 E15j9NO9
 Rsmwmk+k6x86l5AuslL4aWTBwNF2Uh8Y/0IOKQS01JXgNPfVPdsHYVqY04XNChhLluF0XpVrIP6vB42QKpy++kDoXhyoMXtny4mPtC++FyCLdtiyV6TXwnzX1OpT+s8rILX/764ze/oy3a8oPD/XH3FgCQB9iXn6Cz5z/8UaOTfyQKzb2QqjTDFS8Vab5kvF6INkCEX42LbkiadGzwpmCPYerFFpn9WPczE+DZnGFpmM9oGZGBpL+L5yvsoalkx1aAO2wbav25rzhD9jsqiHFk1ubs3Fy0Srs1nPcTawVjj0juyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PTE loop's scan is broken up by the two places that drop the
PTE lock: the periodic reschedule and the large-folio split.

Move the scan into madvise_lru_pte_range_locked(), which runs
entirely under the lock and stops either at a folio to split or
at the reschedule point.

Both lock drops now happen in madvise_lru_pmd_entry(), which restarts
the scan where the helper stopped, or past the folio's PTE batch if
splitting it failed.

No functional change intended.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 67 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 0c0a840102eb..3ebc14d30e0b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -565,6 +565,33 @@ static bool madvise_lru_huge_pmd(pmd_t *pmd, unsigned long addr,
 }
 #endif
 
+/*
+ * Scan PTEs under the PTE lock until a folio needs splitting, and return it
+ * locked and referenced. Return NULL at the end of the range, or earlier
+ * when the caller should reschedule. *addr is left at the PTE where the
+ * scan stopped.
+ */
+static struct folio *madvise_lru_pte_range_locked(pte_t *pte,
+		unsigned long *addr, unsigned long end, struct mm_walk *walk,
+		struct list_head *folio_list, bool pageout_anon_only, int *nr,
+		unsigned int *batch_count)
+{
+	struct folio *folio;
+
+	for (; *addr < end; pte += *nr, *addr += *nr * PAGE_SIZE) {
+		if (++(*batch_count) == SWAP_CLUSTER_MAX) {
+			*batch_count = 0;
+			if (need_resched())
+				return NULL;
+		}
+		folio = madvise_lru_pte_batch_locked(pte, *addr, end, walk,
+				folio_list, pageout_anon_only, nr);
+		if (folio)
+			return folio;
+	}
+	return NULL;
+}
+
 static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long end, struct mm_walk *walk)
 {
@@ -596,34 +623,24 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 		goto out;
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
-	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
-		if (++batch_count == SWAP_CLUSTER_MAX) {
-			batch_count = 0;
-			if (need_resched()) {
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(start_pte, ptl);
-				cond_resched();
-				goto restart;
-			}
-		}
-
-		folio = madvise_lru_pte_batch_locked(pte, addr, end, walk,
-				&folio_list, pageout_anon_only, &nr);
-		if (!folio)
-			continue;
-
+	folio = madvise_lru_pte_range_locked(pte, &addr, end, walk,
+			&folio_list, pageout_anon_only, &nr, &batch_count);
+	if (!folio && addr < end) {
 		lazy_mmu_mode_disable();
 		pte_unmap_unlock(start_pte, ptl);
-		start_pte = NULL;
-		if (!madvise_lru_split_folio(folio))
-			nr = 0;
-		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-		if (!start_pte)
-			break;
-		pte = start_pte;
-		flush_tlb_batched_pending(mm);
-		lazy_mmu_mode_enable();
+		cond_resched();
+		goto restart;
 	}
+	if (!folio)
+		goto out;
+
+	lazy_mmu_mode_disable();
+	pte_unmap_unlock(start_pte, ptl);
+	start_pte = NULL;
+	if (!madvise_lru_split_folio(folio))
+		nr = 0;
+	addr += nr * PAGE_SIZE;
+	goto restart;
 
 out:
 	if (start_pte) {
-- 
2.56.0


