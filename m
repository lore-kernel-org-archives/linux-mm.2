Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C42606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=UUCl9VrX
Received: by kanga.kvack.org (Postfix)
	id 5CDC56B05BB; Sun, 15 Nov 2026 09:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E5B6B05BC; Sun, 15 Nov 2026 09:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494F16B05BD; Sun, 15 Nov 2026 09:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DA856B05BB
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:39:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0C1C4077D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:55 +0000 (UTC)
X-FDA: 85437612750.25.80A0EDC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id BADB910000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UUCl9VrX;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=grK4LsBpOAkv1qWzWxfxiPWhEJ+EzJao8DJTbNNpt+k=;
	b=nuADqHafwmvw424yKsUfdf8PwnQv3vBSvUaczftHLSsbl+g6bBnFFIZoqagDyHlPeobwBZ
	66kuFYdhiv6fwm3NdvJlFcMzztSxlYQRTr7bTVqUpz9CljHuGzqDA8m+5FMRMX2KuV4Xhy
	TjCzpHHv5kfXHF6WUt00VusicqWqxME=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UUCl9VrX;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753594;
	b=KQffCyzSxUnnD40pI5JVXmAXJHymk93LJLL6O+xyXMi4/iHh3BKWIHKG2YoLQfjUmUCWEt
	LseoIGWruUKOqq+ArmLTvJsjxLpmr3ja1ybo1hwJPbHUktO56yPwgyQ1rj1ep5VVMRAfOg
	2bv+0jwKDKbU5ZOQ3NxNCFDTzPif7jY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E57FF1516;
	Sun, 15 Nov 2026 06:39:49 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1D29D3F85F;
	Sun, 15 Nov 2026 06:39:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753592; bh=VUhc9pkYOrY2WKIFmAXqR2xKENpkrWiHDZ6moy3jlKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UUCl9VrXF/3pSiQcdOiLwRcj2glPTciruxq0WAPAQq820l5y7LsY1IGsnlL7bIXrL
	 nLjmrGgzs0iIo0wvtTBTuXjcOi9IbHXIEqFBtWoYi4U1UHjA6LcFRrjex7wTMR0JVd
	 UX0x3sXOqQRtmQ4b5NIgPqmoey+ELvB7Wfs/CyPU=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 4/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Sun, 15 Nov 2026 14:38:59 +0000
Message-ID: <20261115143905.3045084-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdkbbf71fuwb6wuy7q3croshmce6t4q9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BADB910000A
X-HE-Tag: 1794753593-182406
X-HE-Meta: U2FsdGVkX185sZ9jjzaQBWoa7vDomCv+8I+ugBo0TnXY4TLOTbL6ACoC92THKLvhM7zcPPc7exH0dnYye7Au9aG88gbyr3YYjeFZaKAVkad8QoDWSdWoaW1zl8tdqgbhDgZhehsP9bjrZC9oGPw5bqbJBQi0H3torTWu/3wqZMjMaBCL4Qc6BhvrwdmySTX2MFJxmMNJ5drHEW7SuZk3Y5EKhtSfWpokPBvBa3gvCEmcXRkUV7jL5e0ry+I5TXeQvN9gQSQI4z9lVAei6IfcRFVFXDBqMScPehFmYfzeAhHX5jBPiIeCp4G4S8xM7FPApVUlQd7HMZTl8YCL/BZK+JgrO3HvtVfCOFjYxLY2lczBxWkmXW8qd8jwnni5yGHtIJmamLrSB9lIZYHsExHTR2uqStISrP9Cw/9oA25V7HMXk5Yyv8UXaqLgU3zX+7JxuH2PCQW5HC/sDW7be6IOseZxpsOZF8aim4JKYS04B1izXu+CNCNa4oy+dAuxOUt5vMgAl74HzeKVYKK86s9qwKCfZU3Cq6nHCc9Wnz7unyEv2aqswuHpY6ZNyjZjd1lB4rjKT//mwV/vkYHpZO5vJsHYboc1HAVPlcwiuCdIDzTYonBmAfz4X9GnJBQYqHyY4Ih4g4a2TENAWNMbap/DlU5hoMMpuBjgJuOluLSQV8St2ztn7zSkD9FuFe/1xE1/0q/bUOYdsEjQZ7Md0Mgk/TKfNJoFik8KwnTE+BeKcy3bhK7lsj3Sn1Scw271B+JHWiM/ykX5AddjDxV9sQFCeT7aMkU25ens+H8Oo+PwIVtN3aij4nLCIHEEJ0o3uceOBAKagpCG9kRDl3coQMPKv2gHNnA+o23q8Qj53/WSLeVVs/LM7gm3Dx0OQsyl3esAq3k84YLHM3q2FihQX3upHI+28wlW5vIXeLceXvhO6OW38JuazocKwA2iMenKMVQsQqbiaYIMYqYuJSBkzPa
 b6lpIhhA
 TozNTeGfLXOSXLsb2uKkTqwmWDlVsrJhXdeQHloPXXqqWNgG28msm4xch2PfE2pIiCppH8q+pAb9NiHo1C5CuekIcMAvMIMGc6of0agBayw7lEfxVSuPaFWUvNXkYVlvrS2WKiA7jdiGQJDlzvOJDqWs4OORG9udz4e5PKqFfPcGynkDwpIV0KzG9RnLXwxiNDT2OmkZnIM+d/gh2B8ZJKL0EIzSl+zwWpiI8kQVzih4ZrpwbV0EvIQ1OfSExZTDTwfvA7ewddhHH+uwELUTCu5ASfvAovMCAU7YOpOpv2+Hl9eoumIeXUUi/y7LqWR2nSiUn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
batch of nr_pages. Refactor the function such that the clearing of the bit
can be done at one place without duplication.

Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
from the PMD path, but currently we only clear the bit on the head page.
Retain this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Add two WARN's: check that the batch is entirely exclusive (for PMD
callers, need to check only head page), and that there are only
PTE/PMD paths converging into __folio_try_share_anon_rmap.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 58 +++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 43d6bbecd2fab..f4ffbc60b3859 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -724,17 +724,25 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = !folio_is_device_private(folio);
+	bool exclusive __maybe_unused;
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
+
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	VM_WARN_ON_ONCE(level != PGTABLE_LEVEL_PTE && level != PGTABLE_LEVEL_PMD);
+
+	/* We only clear anon-exclusive from head page of PMD folio. */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
+	VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page,
+					       &exclusive) != nr_pages, folio);
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -778,29 +786,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	 * so we use explicit ones here.
 	 */
 
-	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_mb();
+	if (likely(pinnable)) {
+		/* Paired with the memory barrier in try_grab_folio(). */
+		if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+			smp_mb();
 
-	if (unlikely(folio_maybe_dma_pinned(folio)))
-		return -EBUSY;
-	ClearPageAnonExclusive(page);
+		if (unlikely(folio_maybe_dma_pinned(folio)))
+			return -EBUSY;
+	}
+
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		page++;
+	}
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+	if (likely(pinnable) && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -816,10 +833,17 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages,
+					   PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.43.0


