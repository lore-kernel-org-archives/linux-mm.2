Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BCACC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E746B0096; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27996B0098; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8026B0099; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90B866B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B15612033A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:40 +0000 (UTC)
X-FDA: 85023276240.26.465CF00
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1C03E4000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XRde9Es;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nWFZqGyr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XRde9Es;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nWFZqGyr;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888438;
	b=L6oFjHOyaqcfHvWuV2p2QjIXxQeB59cIAYEkB8m5bvV3PMnkpHEOpwLsrPqnWoKu+2OTik
	zfOFa1TD4ZvwCmGKbYuuxiA4BOa8M2RLAwr8TeH5FsWA++Bv7wZ8b27qAzAmK3fc7j+D0E
	9k1ToqxE+oGXx9xCCri7wYNyIxmgBgk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XRde9Es;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nWFZqGyr;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=2XRde9Es;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nWFZqGyr;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfE/8+iwZ8S6lsJKsovOA297WtRq/6z3EhWYSO8IBSA=;
	b=euD6k1/07HsNt2OTOHxMlHPIwIqgJJuhmp62SliW+gsQlcCjWoM3EmRll3dIxzVPCfGISC
	XWk9XYzLQltQ82tOzKwVjnd03Gh+8WMCcyTHIXgnWJO1dCRFsoE9NRezbtsgAnDFwMhgPh
	Xjl549mqdbeJnHQWyq8N9zhuWeAW7CY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 87BAA3EBC;
	Fri, 24 Jul 2026 10:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfE/8+iwZ8S6lsJKsovOA297WtRq/6z3EhWYSO8IBSA=;
	b=2XRde9Es1Obd3JUQsYR9MjkLTwhjIiyHNuFAdEOJ9RBq9XN18bsHlLEQ3J0p03kAsBAYnA
	6UTwuwaRQzOagFacHFgrT2QAlgi2weAN4Xf3iJES29YoD5BLH0WG78W6M8cBeU6td7O2qi
	bzaeqHcA+Akxn4qZlZd6+oDTe7ydgSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888434;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfE/8+iwZ8S6lsJKsovOA297WtRq/6z3EhWYSO8IBSA=;
	b=nWFZqGyrL7G2Rkn0DahcLSwiyr5XvmDdgAt6JLfipfgUhf8tu7CUZHpTxJ0N3OtXBaYDWK
	PH8FsXMzNkjgDuCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888434; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfE/8+iwZ8S6lsJKsovOA297WtRq/6z3EhWYSO8IBSA=;
	b=2XRde9Es1Obd3JUQsYR9MjkLTwhjIiyHNuFAdEOJ9RBq9XN18bsHlLEQ3J0p03kAsBAYnA
	6UTwuwaRQzOagFacHFgrT2QAlgi2weAN4Xf3iJES29YoD5BLH0WG78W6M8cBeU6td7O2qi
	bzaeqHcA+Akxn4qZlZd6+oDTe7ydgSw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888434;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfE/8+iwZ8S6lsJKsovOA297WtRq/6z3EhWYSO8IBSA=;
	b=nWFZqGyrL7G2Rkn0DahcLSwiyr5XvmDdgAt6JLfipfgUhf8tu7CUZHpTxJ0N3OtXBaYDWK
	PH8FsXMzNkjgDuCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 06311779BA;
	Fri, 24 Jul 2026 10:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gJGlOW88Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:31 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] mm: constify the pte_offset_map_ro_nolock() return value
Date: Fri, 24 Jul 2026 11:20:17 +0100
Message-ID: <20260724102017.141532-6-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260724102017.141532-1-pfalcato@suse.de>
References: <20260724102017.141532-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 47cuzkspwwdsdi76z7y8j3bciz8hcrzz
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C03E4000B
X-Rspam-User: 
X-HE-Tag: 1784888437-870148
X-HE-Meta: U2FsdGVkX18f5z7ecXhwqBpgi6v2OqCsBguyFZzI7w5Le8Xly5Tm4G7p9SZIK9gD1cDBOPhz5Glbmp7YiUFXnsmiAcRY25j2bxW4DsM7ZuDM0nUNwUBCgAyAxkQJflxJLekI+RRmGZSJuUBO6OWIjREiFW80gk0ZAZEy8sHiOQDPeQ8geEYuj7i8jzdSLUuz34dTijNcvf8bRNjQ/zZf1otmlBDQlc/y9zWosq9auZnzMrQac3bq88YcgEn319b69cbmCnmO1BCYxdVnk/c6TkqZtfbdFeqT4POxhZpQepTqQFRglAsAvyV0mecNfx011Qn02mKmAsHcjKbingXYuHtKQKB2EHPQ0zl/GeCakX5/EnAzux9+Zt2diMEd/kZY9HsmRTdWtHhwMKhDqjsU/GCdSQXJmDIe79uWzXAi0/5cFzsF5R4fcw719jja5Bnnm4Vey94Qe/r3JVWZd4bv6qHLWZ1qd3RNrwMI7KXN+9Du/Qn4OY0ZKKGJnPvjLn+5C6DETskMYO1SMHwTjFBUjO1L59mCOxfN0PW2Cvn7VnNt06X9WBeHXgJLHs6635+OJQdSo4jS7Q879kftTzrYqc7e8ceLJtYCKz6yzuNJcmXuqHqKBubJMB2fvsETCzGi3hVROgIbmqJLUOddf0wcVUnR4vDDFFOnzMsdzx9N1udWleyY7jkk32hPJ1w30uhHKijv5BHY/9Q3GzgqADXr+d2vKo2EzLcPwOvChT5Dni5JNlzxVM+STQg3fi1fGerQ1BpMIX5u4YZCAZFlGRq0yMAdFUF9qTbeMNbu/hXa2g2pHCAoeUitFW3QPN6PlipNRoeDAkZLY2RSssLxqo0qKpfwEEqhZmQT3iWye0r3wJ1xi69zsbGe8359ZidQjIbWDMMtXWQLUkHWPdNlJpF6gWT7+QF73XtRw2ZBFxEAE2xlJe1/svCEivSn0YPnfCSSElrIS9VhVfVJaqx+SEd
 pIaZR9iJ
 1fkrg86RVz+znZuIllurnPUBNXR6/NhbFsLTMY7tQijvGKBPr9OH3LcdPeonhQy+wFRcCURsPtmjJruFGsfltYCyJWflmtWvT75WMQ0/90Nj07i60rr7p23m/lO13cXiXAC5Q72PKcDipq0z+IcTahsTTgCiaZCSNZELeQ5/E97laebxUy5FvMn2Yp5xybct/WOrVkpm/uyhtY75iWnYDaQF1Ot283RHp7MkyY+4ydMMbWQ6g+w06+bc84RFF72LnQYLEEL4k/Kqb4PkblSFsYt6lUxsm1kF4mEzGbibww7E6shSbBArJkJkfXWf5Fk+LLbip9SmB1UFuxBzHldxst9eW7Ga3jgbJSRJuZKBYmctBROFYxLc+xw5q6edvJLOJccs3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Constify the pte_t * retval from pte_offset_map_ro_nolock(), for which it is
already pledged that accesses must be read-only. With it, convert the three
treewide users to use const pte_t *.

khugepaged passes the result right down to fault code (do_swap_page()). This
leads to a complicated set of conditions that, in order to be correct, must
not install anything into *vmf->pte. This is not trivial to work around in
fault code, and as such just trivially cast to non-const pte_t* in the
meantime.

The other users are far more trivial and the conversion is equally
trivially simple.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/powerpc/mm/pgtable.c | 2 +-
 include/linux/mm.h        | 4 ++--
 include/linux/pgtable.h   | 2 +-
 mm/filemap.c              | 2 +-
 mm/khugepaged.c           | 2 +-
 mm/pgtable-generic.c      | 4 ++--
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
index a9be337be3e4..e29db41b6043 100644
--- a/arch/powerpc/mm/pgtable.c
+++ b/arch/powerpc/mm/pgtable.c
@@ -390,7 +390,7 @@ void assert_pte_locked(struct mm_struct *mm, unsigned long addr)
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	pte_t *pte;
+	const pte_t *pte;
 	spinlock_t *ptl;
 
 	if (mm == &init_mm)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 87feaa5a2b78..4b768639d31d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3887,8 +3887,8 @@ static inline pte_t *pte_offset_map(pmd_t *pmd, unsigned long addr)
 pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
 			   unsigned long addr, spinlock_t **ptlp);
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long addr, spinlock_t **ptlp);
+const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				      unsigned long addr, spinlock_t **ptlp);
 pte_t *pte_offset_map_rw_nolock(struct mm_struct *mm, pmd_t *pmd,
 				unsigned long addr, pmd_t *pmdvalp,
 				spinlock_t **ptlp);
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dc418553e57a..dd51e722c535 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -112,7 +112,7 @@ static inline pte_t *__pte_map(pmd_t *pmd, unsigned long address)
 {
 	return pte_offset_kernel(pmd, address);
 }
-static inline void pte_unmap(pte_t *pte)
+static inline void pte_unmap(const pte_t *pte)
 {
 	rcu_read_unlock();
 }
diff --git a/mm/filemap.c b/mm/filemap.c
index 1dbb4c6f824e..4f0575f13b3a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3484,7 +3484,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
-	pte_t *ptep;
+	const pte_t *ptep;
 
 	/*
 	 * We might have COW'ed a pagecache folio and might now have an mlocked
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80..b87e23ad094f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1169,7 +1169,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 			 * Here the ptl is only used to check pte_same() in
 			 * do_swap_page(), so readonly version is enough.
 			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
+			pte = (pte_t *) pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
 			if (!pte) {
 				mmap_read_unlock(mm);
 				result = SCAN_NO_PTE_TABLE;
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index b91b1a98029c..2cfc6e608ef4 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -308,8 +308,8 @@ pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 	return NULL;
 }
 
-pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
-				unsigned long addr, spinlock_t **ptlp)
+const pte_t *pte_offset_map_ro_nolock(struct mm_struct *mm, pmd_t *pmd,
+				      unsigned long addr, spinlock_t **ptlp)
 {
 	pmd_t pmdval;
 	pte_t *pte;
-- 
2.55.0


