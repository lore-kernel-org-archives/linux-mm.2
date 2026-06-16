Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE177CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FCF86B00E1; Tue, 16 Jun 2026 17:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8AC6B00E6; Tue, 16 Jun 2026 17:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695686B00ED; Tue, 16 Jun 2026 17:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C646B00E1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB4CC16556C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:42 +0000 (UTC)
X-FDA: 84887100564.21.933C53C
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1AFAE140006
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=WjnH4X4b;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjDE7wKN3rUmIZIqeyfahm1B1o9cqGnY+Db4wh52/Bw=;
	b=fO7CfXLdM5iSCACc8pj8s1jkojmsGOW1IKaMHqxow9fyz4Ax23tUMFNCaLy6Ax1Ei1L45r
	BSunojoOhLOfqDkn0fIEezm7vkSY9d7DfklbGd3rgitZSyAOR95pWMyIM4DZ5A3BQ9MIKM
	GMKf5emz+qIzRz29BWaldsZpzWjkgVU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=WjnH4X4b;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646161;
	b=2N3sUMkE4LX24bQH/swmd9hibNWLkv/PVZN077mCTTUp2D+3MOqDVm5aYPwie4VvJ0Slys
	mPeThxnZzQPI7CyNsYQu7ez+jTwt+K13fCVrneImKJsxm49oP2VtEEuD1x8M+POyOCXCZ1
	c51zqxoIboyUCpXUbS0+c08w14RK5fs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=DjDE7wKN3rUmIZIqeyfahm1B1o9cqGnY+Db4wh52/Bw=; b=WjnH4X4boIaoBJMZdUKpm/czgi
	NdqdncMtB88Ww31D+EtWTTXRkVJ5/dWz0Otdu66yetupfgZpCFXIn8SSLdb0yr/X1tpnRVWPUlSG4
	gthnRjzZh19EI99mbhokNzYwDYT2SxxGTqTldW6alArbjMLBHJ3wSCe+BFqJsBQzFR151OBsuVEYI
	gTarx3ziZnYlv7/k4uXn4RIJIUqCcGmX4zciwcu5RY/t7lDmPih4my/1/4b7LlHipZjL9+M/osrzP
	ceogbzPn1HUMOK+zB2lm5nMSxDtsTYpKIKG/Q/HuClWXlSOtP4Iblkqjf3hf743zi2ACrMkEs3Adl
	ZVlnrolg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wZZ4S-000000005GL-1Fcw;
	Tue, 16 Jun 2026 15:03:36 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@surriel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>
Subject: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the per-VMA lock
Date: Tue, 16 Jun 2026 15:02:59 -0400
Message-ID: <20260616190300.1509639-3-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616190300.1509639-1-riel@surriel.com>
References: <20260616190300.1509639-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: p9j18ticeaz91xirahexr3p8m7ryptoh
X-Rspamd-Queue-Id: 1AFAE140006
X-HE-Tag: 1781646160-149428
X-HE-Meta: U2FsdGVkX19H3HDLjDP/2QCE66JqTKo0sJ0tYYRWXkyrK7B/4E0szzRu5CppGwNlCxBHmTi2eimsng14N1kg9xkb2rAuzRGhwHJngSWNMX5W0jXtcSGSckOf+ZZnb74mvxnVue7HNCidhrdGniAY6yGvBi5nM5E+GUP9I056G9XOcTH/5T03xFFx9HksSjF0nL3PDqk/qX8sSD0c4A6OERv/wPdomiLljxoY4THEc781eITMNbxsuFp+zywok+JJ8G5ov2p/F2tVIxZFfcFxg/g/nQqtyjATl3oEixvAbo54M27gvTsqDGsEOXvjli5ADaD6ntULCTyJGZf3QKD91oivE9i7nubXQho6wfwGnpNNayrBPwSXUfcyfZ2yEan7CusAh8mLCGHu7NOb1sjxhXa1ZrAe/i2qs+j7wS1RrLxXB9AwuQrOLj1wUP/WnwEdyl8Cn7rBGcMs+E+JtuUlW00ZXH3syL+PQ79WlPU7ecmn02JfTfqCym8A8L4PpnFx0HL5HOaVu6DAsMdtp6KEtoCHt4iyGNZ08aprQUSBuvL71GWPhLFmt8rnL2B41VOVL6aCYium41FWpHpDZeIMZ9rSkdaIhiP/tx3gGaUy8af9ra8LAsY/Dpgo20Gs+sp6G1FOm0mvN9awFzj3e2SIT8Fy1NGPhyjGg6qMeVROeOkEyZUfYFc6agws8QnItOHBoN8oiGHDJ4S45Omph6qYrRuz5Oh7NdQMAEaOXawaol6uJXTfgk6pFuRPXLMVNwvlFnG9UgarinLLn8m5DAv/xv80KlI5tV9tkkNOuGlKOLqBY1BtVkYCvG206vwbbYloT+4+9fHQdTQTy3WaLae7BMtWCExJ+aZnNy9+ndt7c/Lz8I4S48FLcCLAg8CDmghwdk50Gwa1cc1AsPH2vDLkLLSE0OwLc0sB4LCcGMg+Oina+Bd8XLe2PmgyphjRt+8iIRiBk5Xjg5u9YNZu8u3
 RRJCT3FV
 X2EjHLJtvIMEd4AzeatZzikFAb/evDhEaNTxa1Vg2DjINg7YhxNl+fiv/LncVNWhhpud2QQU6VeHLG3B4ECRfgDrBtyPSjaX6qKpWlH3dxLWQIvTCi0RBN0XU/CXU8ZFXj2+Stm2bpztOk4X4kbTJ4fV8KMyR0iF9wwRfFMapZ3GUmprCKJBLWy24bgddVVkRrQvQpDgeC8MMmkJiJgBmKXxtiXccNajXw4qO/Km2wO4m3IMh2SFuWwXJhpQQUBlZWFzG5Umdowc+H57SZEeXV2d8Cph8zBUCCFMEz2D8XQQKUjJ6dECSLWImqtR0xvyl1HQq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_walk_start() asserts that the mmap lock is held.  For callers that
only need to read a single, already-present page, the mmap lock is a
heavy and often badly contended hammer: the VMA can instead be
stabilized with the per-VMA lock, and the page table pages that are
walked are kept alive by RCU page-table freeing
(CONFIG_MMU_GATHER_RCU_TABLE_FREE).

Add an FW_VMA_LOCKED flag.  When passed, folio_walk_start() asserts the
per-VMA lock instead of the mmap lock, requires RCU-freed page tables,
and refuses hugetlb VMAs (PMD sharing cannot be walked safely this way).
Everything else folio_walk_start() relies on -- the page table locks,
pmdp_get_lockless() and pte_offset_map_lock() -- is already safe without
the mmap lock, mirroring the per-VMA lock page fault path.

No existing caller passes FW_VMA_LOCKED, so behaviour is unchanged.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/linux/pagewalk.h |  5 +++++
 mm/pagewalk.c            | 18 ++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01b..84dd0d68f747 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -150,6 +150,11 @@ typedef int __bitwise folio_walk_flags_t;
 
 /* Walk shared zeropages (small + huge) as well. */
 #define FW_ZEROPAGE			((__force folio_walk_flags_t)BIT(0))
+/*
+ * The caller holds the per-VMA lock instead of the mmap lock. Only valid with
+ * RCU-freed page tables (CONFIG_MMU_GATHER_RCU_TABLE_FREE) and not for hugetlb.
+ */
+#define FW_VMA_LOCKED			((__force folio_walk_flags_t)BIT(1))
 
 enum folio_walk_level {
 	FW_LEVEL_PTE,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..c85364b73e12 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -890,7 +890,9 @@ int walk_page_mapping(struct address_space *mapping, pgoff_t first_index,
  * huge_ptep_set_*, ...). Note that the page table entry stored in @fw might
  * not correspond to the first physical entry of a logical hugetlb entry.
  *
- * The mmap lock must be held in read mode.
+ * The mmap lock must be held in read mode. Alternatively, if @FW_VMA_LOCKED is
+ * passed, the VMA's per-VMA lock must be held (only supported with RCU-freed
+ * page tables, i.e. CONFIG_MMU_GATHER_RCU_TABLE_FREE, and not for hugetlb).
  *
  * Return: folio pointer on success, otherwise NULL.
  */
@@ -908,7 +910,19 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 
-	mmap_assert_locked(vma->vm_mm);
+	if (flags & FW_VMA_LOCKED) {
+		/*
+		 * Lockless walk: the per-VMA lock keeps the VMA stable, and
+		 * RCU-freed page tables keep the walked page table pages alive
+		 * across the lockless upper-level walk and pte_offset_map_lock().
+		 * Hugetlb (PMD sharing) is not supported on this path.
+		 */
+		VM_WARN_ON_ONCE(!IS_ENABLED(CONFIG_MMU_GATHER_RCU_TABLE_FREE));
+		VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
+		vma_assert_locked(vma);
+	} else {
+		mmap_assert_locked(vma->vm_mm);
+	}
 	vma_pgtable_walk_begin(vma);
 
 	if (WARN_ON_ONCE(addr < vma->vm_start || addr >= vma->vm_end))
-- 
2.53.0-Meta


