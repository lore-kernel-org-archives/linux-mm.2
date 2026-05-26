Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 448E9CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BAF6B00CE; Tue, 26 May 2026 10:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFD276B00D1; Tue, 26 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ECBE6B00D3; Tue, 26 May 2026 10:56:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AADA6B00CE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:56:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 514B61C02C7
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:21 +0000 (UTC)
X-FDA: 84809871762.09.3D86208
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E41A160007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:56:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cWP2C5F2;
	spf=pass (imf08.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779807379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMIWaZV32Daasf+za8/Pnxre+NVOPFzoBSPfz4En8HQ=;
	b=l6St39Y+tkEoq0vmP3qFKbTw1bYLfjlBI8L697dDV5s2TntODJ3JQvsfzVYp6tRKGoRoc8
	3lRVAMc1zjdurZ8pb0eWt6hkvJPsQjeDwEjCtWT6oDaXH14OEXtELGlFM7AcaH2pHHelHO
	/WElITSJRuz1zVAZA1k5m1EmzE0eeJ4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cWP2C5F2;
	spf=pass (imf08.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779807379; a=rsa-sha256;
	cv=none;
	b=a0wPnjrMtyqB0ZkBETprjDaw3KECH+Lwj1Ssip7MEi3PG5nlhAABzrTa3BpLzTdBydz8SK
	MFLgR+6cmeUELTk1AQ/CbCTa2tp/0LEUH/oukoYrc47C/2AdhQkSWl7iqQHERhpGmQoX2s
	FPY9UkLz5c19KM2MMH6ABrQEJnRjmL0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wMIWaZV32Daasf+za8/Pnxre+NVOPFzoBSPfz4En8HQ=;
	b=cWP2C5F2TBvhzg8T7RVE9LoZ2ByIKu0sClV+EAFEDCH0sYrngJWuk2R/h0BScXfHjlZ39EcF0
	sm2W80NqlJG1l2DcbQ+f7BpC0XXWfXbT14ddcMTDZ61mK12koV6hAqFEZ0BpvXmYoJ1dR3dQgM8
	I5JteHexY65OZ5Vz5woxwvk=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gPwcN06v8zpT17;
	Tue, 26 May 2026 22:48:52 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B5BD740561;
	Tue, 26 May 2026 22:56:16 +0800 (CST)
Received: from huawei.com (10.50.87.63) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 May
 2026 22:56:15 +0800
From: Yin Tirui <yintirui@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<ljs@kernel.org>, Juergen Gross <jgross@suse.com>, Jonathan Cameron
	<jic23@kernel.org>, Will Deacon <will@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>, Peter Xu <peterx@redhat.com>,
	Luiz Capitulino <luizcap@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy
 Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Rohan McLure <rmclure@linux.ibm.com>, Kevin
 Brodsky <kevin.brodsky@arm.com>, Alistair Popple <apopple@nvidia.com>, Andrew
 Donnellan <andrew+kernel@donnellan.id.au>, Pasha Tatashin
	<pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth
	<thuth@redhat.com>, Coiby Xu <coxu@redhat.com>, Dan Williams
	<djbw@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu
	<baolu.lu@linux.intel.com>, Conor Dooley <conor.dooley@microchip.com>, Rik
 van Riel <riel@surriel.com>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>, <yintirui@huawei.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linuxppc-dev@lists.ozlabs.org>,
	<linux-pm@vger.kernel.org>
Subject: [PATCH mm-unstable RFC v4 5/7] mm/huge_memory: refactor __split_huge_pmd_locked()
Date: Tue, 26 May 2026 22:50:01 +0800
Message-ID: <20260526145003.88445-6-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.63]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E41A160007
X-Stat-Signature: 7exixx98h1e399dmpt9xjcwepagi64qi
X-HE-Tag: 1779807378-554155
X-HE-Meta: U2FsdGVkX1/oWfTM+Ngq6mA4GorzlcJps2ofcRcJdaH+Sa3X1S+V3lWt6I9tglst/8rumJ/pgX6kCVLoEJypkkLAKeaV1xqbDCevbZurkmVFAr9rDrQCR9k4XK1+brTFghfGuCRzf08cdGTqYfqzlBFH84j4qlnJ+qJjIfBsuT11aJ4ONrfWakTs9tOcb8i58D3+DSUiKmNTXp1Bqgr3AkjfcnTbl6vqOawTfuOLZ41lxIlqBF2xIl/SPa3LQxoKJUUSEZ5E2ctOXQ3Qmt1ReY+iLmSGPgDGNtokcY4XQ4z+vgnyQbAiq3OuYcFgCgQ+5MnuX0GQNk+h5iJTtKnI9CjagGHkkO+lRkP0TyoB/qGk6oW6rKn1Kxs1ivEgTEMDjvfhdfOJgPXkajoHcaazDcyNn88wNCkhdZzuUqvVaKjt7iAk6nE7WonU+xlb0E7YwCd9749tnVh/tN+1zGynYbpFR2sajt08lf6U3l7sshKo/AhmKaNRKi/DVM55rZxSpfXnOvWndm38Xgfi2fFbc2LZqEdAVgXj+cZ+NuMQkFJ+60aoRVQ1FxOmdvrA7+0D08OSa6Yh6Dw+8GT0srICk+wRb94IjU/Edo6co9f3+ZqvRsZwIaa0rzuuJXCQWlWFcilmFQQYqhtV8SNAGpUnUfcNgmM/deyCuEq4BKKyjjVR2jLYQqTBH7nrKFPGgjIbIxYU7FgRyVqrR08jze8I5k71jaDbIQC7SgcFTMzSbto6uPnYGAOkVO06jmDTsOYKJpuACrHeTuyEPZhzmVBS0GJ7dVPn9hn/T2urptZwJLgRTck1k4OS+dO0qxVA5q0m0RmX20SxMr6EG26GR4Vso7/hkFArags6LVxs0VGwrx9yPlg25B8dAK3M+Pmms+uZEr3lGc9mgqVvTPYL8ijKu+eEAL8tfvlyoSr0g7W7L0GK+52socv7J4EyOqgih5pLlCkNpqeSTbjExUlUyy7
 rim38Zt8
 onETcibqDL/ojdJE4BQ32MzePBrUKKgLmzg9+C2odp4k5jcHrdBneqFqGiieJwwJwJwCmT4FY5NRgWXaq1jGipWS8oCmg8/pw0wexPqqaDuoqn8fswvwdd9TY1E7HnFaBSNT9fGFL1T9XKC/Zi2ntWA/nwBmY42B5rQWMWd+OgRImNXFJCFlvact0uHj1ouKd1iFzRx9uMfYv57zan2pHVhSQr0ojyy05GLYI0mF4KsmK0rRMz5fxO913qY2d6FxR6tlQFx3jFqlQWbCLAT7vmGuA4UYyjJBXx+MfH+ms586/qL3EzpfAIUacyDpdo1fl9F7AgH2smoNHZNoVK/cgzv7ZmY7fakwYJW+UbdW5Uv3FDXzSDZL/XasNntfvaLzcNU67
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rework __split_huge_pmd_locked() to classify huge PMDs by the PMD entry
itself instead of starting from vma_is_anonymous().

Present PMDs are classified with vm_normal_folio_pmd(): file/shmem THPs
are dropped and refaulted later, anonymous THPs are split into PTEs, and
PMDs without a normal folio are handled as huge zero or special PMDs.

Non-present PMDs are classified with pmd_to_softleaf_folio(): file/shmem
migration entries are dropped, while anonymous migration/device-private
entries are split into PTEs.

This also makes the anonymous decision folio-based.  A private file
mapping that has CoW'ed to an anonymous THP now follows the anonymous
path even though the VMA is file-backed.

No intended behavioural change.

Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/huge_memory.c | 197 +++++++++++++++++++++++++++--------------------
 1 file changed, 114 insertions(+), 83 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3964258ff91d..8cd77389d52f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3136,25 +3136,38 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 
 	count_vm_event(THP_SPLIT_PMD);
 
-	if (!vma_is_anonymous(vma)) {
-		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
-		/*
-		 * We are going to unmap this huge page. So
-		 * just go ahead and zap it
-		 */
-		if (arch_needs_pgtable_deposit())
-			zap_deposited_table(mm, pmd);
-		if (vma_is_special_huge(vma))
-			return;
-		if (unlikely(pmd_is_migration_entry(old_pmd))) {
-			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
+	if (pmd_present(*pmd)) {
+		folio = vm_normal_folio_pmd(vma, haddr, *pmd);
+
+		if (unlikely(!folio)) {
+			if (is_huge_zero_pmd(*pmd)) {
+				/*
+				 * FIXME: Do we want to invalidate secondary mmu by calling
+				 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
+				 * inside __split_huge_pmd() ?
+				 *
+				 * We are going from a zero huge page write protected to zero
+				 * small page also write protected so it does not seems useful
+				 * to invalidate secondary mmu at this time.
+				 */
+				return __split_huge_zero_page_pmd(vma, haddr, pmd);
+			}
 
-			folio = softleaf_to_folio(old_entry);
-		} else if (is_huge_zero_pmd(old_pmd)) {
+			/* Present but not a normal folio: drop the PMD. */
+			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
 			return;
-		} else {
+		}
+
+		if (unlikely(!folio_test_anon(folio))) {
+			old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
+			if (vma_is_special_huge(vma))
+				return;
+
 			page = pmd_page(old_pmd);
-			folio = page_folio(page);
 			if (!folio_test_dirty(folio) && pmd_dirty(old_pmd))
 				folio_mark_dirty(folio);
 			if (!folio_test_referenced(folio) && pmd_young(old_pmd))
@@ -3164,72 +3177,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_put(folio);
 			return;
 		}
-		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
-		return;
-	}
-
-	if (is_huge_zero_pmd(*pmd)) {
-		/*
-		 * FIXME: Do we want to invalidate secondary mmu by calling
-		 * mmu_notifier_arch_invalidate_secondary_tlbs() see comments below
-		 * inside __split_huge_pmd() ?
-		 *
-		 * We are going from a zero huge page write protected to zero
-		 * small page also write protected so it does not seems useful
-		 * to invalidate secondary mmu at this time.
-		 */
-		return __split_huge_zero_page_pmd(vma, haddr, pmd);
-	}
-
-	if (pmd_is_migration_entry(*pmd)) {
-		softleaf_t entry;
-
-		old_pmd = *pmd;
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
-		folio = page_folio(page);
-
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
-
-		write = softleaf_is_migration_write(entry);
-		if (PageAnon(page))
-			anon_exclusive = softleaf_is_migration_read_exclusive(entry);
-		young = softleaf_is_migration_young(entry);
-		dirty = softleaf_is_migration_dirty(entry);
-	} else if (pmd_is_device_private_entry(*pmd)) {
-		softleaf_t entry;
-
-		old_pmd = *pmd;
-		entry = softleaf_from_pmd(old_pmd);
-		page = softleaf_to_page(entry);
-		folio = page_folio(page);
-
-		soft_dirty = pmd_swp_soft_dirty(old_pmd);
-		uffd_wp = pmd_swp_uffd_wp(old_pmd);
-
-		write = softleaf_is_device_private_write(entry);
-		anon_exclusive = PageAnonExclusive(page);
-
-		/*
-		 * Device private THP should be treated the same as regular
-		 * folios w.r.t anon exclusive handling. See the comments for
-		 * folio handling and anon_exclusive below.
-		 */
-		if (freeze && anon_exclusive &&
-		    folio_try_share_anon_rmap_pmd(folio, page))
-			freeze = false;
-		if (!freeze) {
-			rmap_t rmap_flags = RMAP_NONE;
-
-			folio_ref_add(folio, HPAGE_PMD_NR - 1);
-			if (anon_exclusive)
-				rmap_flags |= RMAP_EXCLUSIVE;
 
-			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
-						 vma, haddr, rmap_flags);
-		}
-	} else {
 		/*
 		 * Up to this point the pmd is present and huge and userland has
 		 * the whole access to the hugepage during the split (which
@@ -3255,7 +3203,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		 */
 		old_pmd = pmdp_invalidate(vma, haddr, pmd);
 		page = pmd_page(old_pmd);
-		folio = page_folio(page);
 		if (pmd_dirty(old_pmd)) {
 			dirty = true;
 			folio_set_dirty(folio);
@@ -3266,7 +3213,6 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 		uffd_wp = pmd_uffd_wp(old_pmd);
 
 		VM_WARN_ON_FOLIO(!folio_ref_count(folio), folio);
-		VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
 		/*
 		 * Without "freeze", we'll simply split the PMD, propagating the
@@ -3296,6 +3242,85 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
 						 vma, haddr, rmap_flags);
 		}
+	} else {
+		/*
+		 * Non-present PMD: a softleaf-encoded migration or
+		 * device-private entry. pmd_to_softleaf_folio() warns and
+		 * returns NULL for any other encoding.
+		 */
+		folio = pmd_to_softleaf_folio(*pmd);
+		if (unlikely(!folio))
+			return;
+
+		if (unlikely(!folio_test_anon(folio))) {
+			/*
+			 * File/shmem migration entry: drop the PMD without
+			 * splitting. Unlike the present case the entry holds
+			 * neither a folio reference nor an rmap to release,
+			 * so just adjust the RSS counter.
+			 */
+			pmdp_huge_clear_flush(vma, haddr, pmd);
+			if (arch_needs_pgtable_deposit())
+				zap_deposited_table(mm, pmd);
+			if (unlikely(vma_is_special_huge(vma))) {
+				VM_WARN_ONCE(1,
+					     "unexpected special huge PMD migration entry\n");
+				return;
+			}
+			add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+			return;
+		}
+
+		if (pmd_is_migration_entry(*pmd)) {
+			softleaf_t entry;
+
+			old_pmd = *pmd;
+			entry = softleaf_from_pmd(old_pmd);
+			page = softleaf_to_page(entry);
+
+			soft_dirty = pmd_swp_soft_dirty(old_pmd);
+			uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+			write = softleaf_is_migration_write(entry);
+			if (PageAnon(page))
+				anon_exclusive = softleaf_is_migration_read_exclusive(entry);
+			young = softleaf_is_migration_young(entry);
+			dirty = softleaf_is_migration_dirty(entry);
+		} else if (pmd_is_device_private_entry(*pmd)) {
+			softleaf_t entry;
+
+			old_pmd = *pmd;
+			entry = softleaf_from_pmd(old_pmd);
+			page = softleaf_to_page(entry);
+
+			soft_dirty = pmd_swp_soft_dirty(old_pmd);
+			uffd_wp = pmd_swp_uffd_wp(old_pmd);
+
+			write = softleaf_is_device_private_write(entry);
+			anon_exclusive = PageAnonExclusive(page);
+
+			/*
+			 * Device-private THP should be treated the same as
+			 * regular folios w.r.t. anon-exclusive handling. See
+			 * the matching code for present anon folios above.
+			 */
+			if (freeze && anon_exclusive &&
+			    folio_try_share_anon_rmap_pmd(folio, page))
+				freeze = false;
+			if (!freeze) {
+				rmap_t rmap_flags = RMAP_NONE;
+
+				folio_ref_add(folio, HPAGE_PMD_NR - 1);
+				if (anon_exclusive)
+					rmap_flags |= RMAP_EXCLUSIVE;
+
+				folio_add_anon_rmap_ptes(folio, page, HPAGE_PMD_NR,
+							 vma, haddr, rmap_flags);
+			}
+		} else {
+			VM_WARN_ON_ONCE(1);
+			return;
+		}
 	}
 
 	/*
-- 
2.43.0


