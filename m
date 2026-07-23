Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 439AFC44524
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCC36B00B5; Thu, 23 Jul 2026 03:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3AD6B00B6; Thu, 23 Jul 2026 03:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1886B00B7; Thu, 23 Jul 2026 03:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2FF6B00B5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:10:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37D05A0DA9
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:14 +0000 (UTC)
X-FDA: 85019167548.02.B739B16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 87A1B40007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:10:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iFRumHWB;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784790612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=25nEWisjUTcQkUaSYvYfGm9koDVQTUYdn854a1OAZUY=;
	b=ua9tXqm0AITFZq0jmxeItwkCFqdMLCIQO5qGjNqj4EZ9rIJMv4X+s01sZlfvZHosc8BWTL
	IwAFzGfLtgWOQwtjwrrMlePnoW77BipnErVNgcinbB4DMk+D065r0U3hsvTzkco/XiPfS/
	oh2G2VhiR2MUydYbf+SLSsHarMPxWMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784790612;
	b=5T+LN7YUmwlbKs+KdBdkCwdgIWzaQ9J1VxF2G0hYL/YpAlHFbYTHCKSbQRW+nFyMG9Xukd
	+p8iGdLAaeYq2InUedt14k7V1lzC4Uro63DmhWZb1gc2ijtvl3SEDLMPZ6NLPDdQwncohm
	apB2TaFcoYSzL0hNdutD8jIXP2hNXqo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iFRumHWB;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 69DDF1A2D;
	Thu, 23 Jul 2026 00:10:07 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AEA743F66F;
	Thu, 23 Jul 2026 00:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784790611; bh=B0Ateg28ZulVYTvLgCnS5RzZ0jyHIGM6ERhGQEjXq6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFRumHWB5p0fFec+k2QbiSGOLO8WXPV4fh5pFjnkU0ZowQ544zEoCYX4jVUygKkCK
	 cUCxM60AIbb+qISG2r03haAvJPteCnFY5HKieL8paJoD4twRbEWh3aMh6OsMRal2Fg
	 CvMRllLQzVbwpMAXyeh8OcoqF1WwtR3PLAeCfR+0=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 7/8] mm: move anon-exclusive batch helper to internal.h
Date: Thu, 23 Jul 2026 07:09:03 +0000
Message-ID: <20260723070905.3422276-8-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723070905.3422276-1-dev.jain@arm.com>
References: <20260723070905.3422276-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d9hryrh5z854bfqwpoo7mspi7kpeif9w
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87A1B40007
X-HE-Tag: 1784790612-664752
X-HE-Meta: U2FsdGVkX19ycXWnfokiWFR2pqK31ISjUTbn0DoEWB1etHpJDhTXawoSGb3NJy21Bd77BRKTTkDqmlzue4Ku0d88td9Bzbia3dnaqmS7y8PBPOss6CCkZi/tBbq2o+9q4vGHZA9oST4FLCaG8Hp7VabCZyoRhLkPyEmLGKjgj1Vjbp7PUE07bxcNzBDFoHWOOa76D9EVrO61yS843wvVVu3dRWBtXU5msV2fNgX08U9B57NR3D3VdE5Pi9z7aoDXnbsylSJESNO+4gYP8otXJej9Svd+KH4JYN4tXEwfRWWNpU/c9dPso4e/BPtRubG3SzDjKgcxbG+cIoA+5/ftM3XnoblSWn4k0U5uvT3V+8WER/GwrCcCK4XsBQQliYaE2ryI4SesPbWSllhwtARYBMCD8T5ABGr4Pt0ApN1LCOeyBIyym5jige8gMdBYphzb8Rk8I2Q1XIXuydCKNUmstvJZCqZXAfHe+urMQqC2XU8FGOCKYmNvuv5tJA91pW4XYYaEkFpmv5ZsHVyTrmsPPdajegzPl1f8ZIygmXcI/rpPptkc3PEfKrEx+SkdyWpkMx+NI+/FTWALmMve7BWhdvZB6zr7KB/LY9Iw8LP6vJ6KT6FOPcLXHUvOKdYAVSjQRBEAx+BO0be73WoorBNSMHjM953xFMAi0JJ7jtkVvcm90pbaLH+tpxFuxI9ED7/DlwrEqsdM1bxe+o6+QxKa+C8ZKtf1t+5q81UDmYW0Y55qD1/XcKRJkII9kpzv5do9INcyyp+TgNJecxRSCsnWvly93R25RXbf4ZBTjLnydlEG+7PYxWloLCaVKQcftrXIwCrSfoPET8R+UykQd0p1/MhmGIQYHdMoxEmql0GljjSlsJjj1GnjIWx+gvhE/hw52AhnlrSFpZDP2GixvTxLa0PI8rz2s5GlG6MOEjlWVz+Ioh1y76gfoqGCQcB4/iFNBJDwHadAf0u6S14eNGu
 LxQr3ziD
 FR+2SR2M0clG3sDLHU42rrBLaXFQzLT0uj6jPhgXiGv7HqUA9DfWL3tXhqATBdRvjBAoThSIx6FwhnfLdoIU1UI+Ii5SPP0Q6FiT15KQbnkZ5yBLVjNDBL9CkgIuOfPw/6rG8It6+QQaZv87TyD1r8yTVztGN3y8yPKsF1qbkNTV6KN1Eu3IjlRjMUFZ0YmkkYEKL7F0zomw1GHMsyvRlC1IFey3tJDgd98/hHV0sxukiarofXa9/SyMQug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for optimizing large folio unmapping, we need to reuse
the page_anon_exclusive_batch helper in rmap.c. Therefore, move it from
mprotect.c to internal.h.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/internal.h | 17 +++++++++++++++++
 mm/mprotect.c | 17 -----------------
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 3fc1c1c776ca3..df799d0c24e0b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -474,6 +474,23 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
 		unsigned int max_nr);
 
+/*
+ * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
+ * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
+ * that the PTEs point to consecutive pages of the same anon large folio.
+ */
+static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
+		struct page *first_page, bool expected_anon_exclusive)
+{
+	int idx;
+
+	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
+		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
+			break;
+	}
+	return idx - start_idx;
+}
+
 /**
  * pte_move_softleaf_offset - Move the softleaf entry offset field of a
  * softleaf pte forward or backward by delta
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d872..75c2b1a00eb36 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -138,23 +138,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
-		struct page *first_page, bool expected_anon_exclusive)
-{
-	int idx;
-
-	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
-		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
-			break;
-	}
-	return idx - start_idx;
-}
-
 /*
  * This function is a result of trying our very best to retain the
  * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
-- 
2.43.0


