Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838EB606A880
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WQ4M66Ff
Received: by kanga.kvack.org (Postfix)
	id 27F926B05CE; Thu, 12 Nov 2026 06:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 207F76B05CF; Thu, 12 Nov 2026 06:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF5E6B05D1; Thu, 12 Nov 2026 06:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7F266B05CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59B29A0554
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:03 +0000 (UTC)
X-FDA: 85426237806.17.C82D267
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B99FE4000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:26:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQ4M66Ff;
	spf=pass (imf27.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ahb900BtN45H4B5q25OIDwOBOyq++YAh9gkOLMihQg=;
	b=yVMOqiuFTbrFntuAqPYftfsVLzcRPEXWrxqYFQULKkQ9iPQCP5ndMzxBMxKjyCsyFQ6aYH
	AFeAtjKy/g779RHsOYjYIKJ3ZgO69+omBe9SM9V2vVYB786pwW+J0YZocG2Yttzg5bHb/g
	zxRAGLMe5uT3tPfCxVyrBeNRw7CQ224=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482761;
	b=OMNEsL9TXb5lhudjWr/tzNQmKazfckcvtF5LV+4azARJwDXMtwlzxZdciVeybVIH3Le1qv
	XB3XALSRK0+44iT3gELRUPy+eaWPdiQxOpy2Xp5QzV7VxVxxTd60sdUrG17w/c8NZz6yPg
	uAyfB3gBJtWUIYCLaHe1eHdv7N0A9Iw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WQ4M66Ff;
	spf=pass (imf27.hostedemail.com: domain of arnd@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=arnd@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5742561D19;
	Thu, 12 Nov 2026 11:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EEE1F00A07;
	Thu, 12 Nov 2026 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482761;
	bh=1ahb900BtN45H4B5q25OIDwOBOyq++YAh9gkOLMihQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WQ4M66FfhknQRiwDgcQNx9UTF6dw9I471yvpzzFpUSuIaGtUEIDttLJmvxsZHmCLQ
	 hJX0F1qlMlGDXUOYxTWf7SdVpL7CvzelD5QV/7wcBolWvM85ghWaA+9JhhRWKEqC3r
	 WniKL7pGR1/h0wZfwpTPxeY9yrq0JtLKm6qJS9CAq4M5AQAbwbQPtcvfMNTke5zy86
	 CxstBYAp1AKAptvpHqOlsDaeMJlRSIBRt4KAg8Z1cmGVPcjrm8Oq8RHrUiuj0GsC7p
	 YMtbiBe7/bYpGf43nhfrv078hWGpRSWJwn/m5859ygg8Z1pOoCtVRFawuoaJgLIDPa
	 xmpvfL3jz+yuQ==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	x86@kernel.org
Subject: [PATCH v2 4/6] mm: drop HIGHPTE support altogether
Date: Thu, 12 Nov 2026 12:25:26 +0100
Message-ID: <20261112112528.1116405-5-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112112528.1116405-1-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 7eqsrp5ozcj84azu75xuaq6bpffusaah
X-Rspamd-Queue-Id: B99FE4000B
X-Rspam-User: 
X-HE-Tag: 1794482761-264001
X-HE-Meta: U2FsdGVkX19FOj4J8OaYJ1Js5cHo8Ao6PnHtEv0eA7xlDAj9vSYX/W1LhwSmfsFNJIp0pb0FC1Pg4H/O7xJtsjVaj9rEsZbKESDEOuau1KEgni9q+C/Izuqv3pAZGCmEG0TOjPn+undAV5DHKMlFFC7Uhf3jJIYfCdCpi6dSKHFBGtqK+V+bnJ/Xejef43drZKi3HB7iVdKbfeevjfwnFG2axIn9U3KFnNogzT17QS8o634JYUCBPYWDBKWJzHZG5sJH3AgijTc3CFK4wblnKmCfd6cQ/FtAYLqJp35VuJFSXu7RjE9amoeDjC+VisKehqTkf3zFieKPdEcopjesCXc7rcDM30VmJthP5CER3sIq8akuyJYUpqJmL5Q1rZ/HIPJc/vgriUtmHRVAq3h5q7nU/W/A+1RYleomk3AZgg2IVV2B7q3EqPlUk02m8FkbxGCS7uajSMX3uX3Py/6gu6ikOjYu6TG9gFJ19n6jHNYCvXpMc3uoM8mWJckR7LRZqlFhMHe/J7ixpJcJHfLXSgzqk4+x9zwqO0CoB8de3EsOPPwFeh84Y7vKZim3fg8WVOs2vpczR21X7ciNn8JVvC2T2uufSchtpOTo1LztjK4B69nJcl1EmepbJ7dV1q9mIurHpORmwEDkIc8RXoO7Vx86nB78dgJRIHMcYxJ4POsxnaE5Z4UF9YLbPJ4AH/vwEtxmuOGwoOgw1jr2OHeVR0gPdE7ReggsOctjsBbvFUFJ4WVYWR9tpRwvpF/5mJYN4TcYyMy589seFt4mGnPPro9MFaexGdZNhvd6E9j/V54WdSWkMEqhZdMc5PhmK8ldUfjYHLydcEmjYtZklCWeXP2ab5OaKkHSGNoEYAxFFt8I4YaaPvqwajoMVhUu6CJMJDE9LSV1RAStwsBwKBwJIL/L87lxH4lU81GsJiwbGJUtJImemWwmz/Sdj40fo4/e61WuDtSdunF3yCO9kqU
 2Omd1RK4
 YMgjQ3h3VIFDdwew1kNYhMDiumB1sFJMwqoLwugeLaGM7DoXA7uYsVRLgXXGScf4xCGeiVo48klYbze3fFiB96IbwiNV1w7Ehr0GmjgvXxvd6WaUmRYSNxma7H05CsHv8hvQPiSLkr0AOoUpQHOqRlDkPVtwJD1zEogSexSPOPejxffjuCUvpPNgZU+OErK8bFhwwOjrM32P+Vmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arnd Bergmann <arnd@arndb.de>

With both x86 and arm having dropped CONFIG_HIGHPTE support, no
architecture is left using it, so remove the remnants in common code.

It is likely that further cleanups are possible in the page table
code but those are not obvious from the config options.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/hugetlb.h | 5 +----
 include/linux/mm.h      | 1 -
 include/linux/pgtable.h | 9 ---------
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 58f755e70e96..7c6d191fdf50 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -178,7 +178,6 @@ void hugetlb_bootmem_set_nodes(void);
 
 /* arch callbacks */
 
-#ifndef CONFIG_HIGHPTE
 /*
  * pte_offset_huge() and pte_alloc_huge() are helpers for those architectures
  * which may go down to the lowest PTE level in their huge_pte_offset() and
@@ -193,7 +192,6 @@ static inline pte_t *pte_alloc_huge(struct mm_struct *mm, pmd_t *pmd,
 {
 	return pte_alloc(mm, pmd) ? NULL : pte_offset_huge(pmd, address);
 }
-#endif
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long addr, unsigned long sz);
@@ -1047,9 +1045,8 @@ static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 	 */
 	if (size >= PUD_SIZE)
 		return pud_lockptr(mm, (pud_t *) pte);
-	else if (size >= PMD_SIZE || IS_ENABLED(CONFIG_HIGHPTE))
+	else if (size >= PMD_SIZE)
 		return pmd_lockptr(mm, (pmd_t *) pte);
-	/* pte_alloc_huge() only applies with !CONFIG_HIGHPTE */
 	return ptep_lockptr(mm, pte);
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1a..019de55bd796 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4025,7 +4025,6 @@ static inline spinlock_t *pte_lockptr(struct mm_struct *mm, pmd_t *pmd)
 
 static inline spinlock_t *ptep_lockptr(struct mm_struct *mm, pte_t *pte)
 {
-	BUILD_BUG_ON(IS_ENABLED(CONFIG_HIGHPTE));
 	BUILD_BUG_ON(MAX_PTRS_PER_PTE * sizeof(pte_t) > PAGE_SIZE);
 	return ptlock_ptr(virt_to_ptdesc(pte));
 }
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..1352b4cee7ae 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -100,14 +100,6 @@ static inline pte_t *pte_offset_kernel(pmd_t *pmd, unsigned long address)
 #define pte_offset_kernel pte_offset_kernel
 #endif
 
-#ifdef CONFIG_HIGHPTE
-#define __pte_map(pmd, address) \
-	((pte_t *)kmap_local_page(pmd_page(*(pmd))) + pte_index((address)))
-#define pte_unmap(pte)	do {	\
-	kunmap_local((pte));	\
-	rcu_read_unlock();	\
-} while (0)
-#else
 static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
 {
 	return pte_offset_kernel(pmd, address);
@@ -116,7 +108,6 @@ static inline void pte_unmap(pte_t *pte)
 {
 	rcu_read_unlock();
 }
-#endif
 
 void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
 
-- 
2.53.0


