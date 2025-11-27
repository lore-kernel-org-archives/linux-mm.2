Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D30CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF0F6B007B; Thu, 27 Nov 2025 18:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FF16B0088; Thu, 27 Nov 2025 18:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000616B0089; Thu, 27 Nov 2025 18:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD5D36B007B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:37:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DB26889BC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:10 +0000 (UTC)
X-FDA: 84158000220.09.5947F38
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 964DE80005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=shy6esmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yAyK82Jg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=shy6esmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yAyK82Jg;
	spf=pass (imf02.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXN77uvZaUEzKpDFHr5D8RJvGuDYGsfduCNQSgDBJBM=;
	b=KBgE+6NcL2OKumiyQhTipIzL3YkZukV8EoEGH0oIKjnkv3aaTy9nfn5lasgCyE6i898fXe
	oAAZ+cN8XmzZ0kMJcJkSmjPOfHzMiSfzNzZaMPW9ogdUCwwNmIUb4iuY/acd6pbJbg+wIN
	g+RVmxB78VYZNuyt8cGREDR0ZEI8Ghc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286628; a=rsa-sha256;
	cv=none;
	b=3n2Lsux+AtqE+jSDYCdbnbuz1KI1GBDsWy8tf5UUnP+LWaab4boeUUF6NSWUsr6uIdtIka
	qjnJrsJV8TtoIaGLuAiuUOOoatp5gskaofsanhs94W15WiR1pmqgBxBUPKWPTUmyXRB7Ve
	3fW+GKztR4ETyzSDvZCrYoVaWY4uEl8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=shy6esmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yAyK82Jg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=shy6esmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yAyK82Jg;
	spf=pass (imf02.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 920BD5BD0D;
	Thu, 27 Nov 2025 23:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXN77uvZaUEzKpDFHr5D8RJvGuDYGsfduCNQSgDBJBM=;
	b=shy6esmjWDwV1Q5h4BPZmal58rRAd/KUi1HdBHgwxwrWaQYhCsclNBw6iS00ZR82wYJTKF
	9LTXhtLSfIUtWDQKy11UkoSKYLEvyzIjyvmuthZQYLaiCLFoAZAvEmJ93T+Aa+fi6HTIyc
	RLy58zmqHpdpiBPwI7jaHHPoPVdyw14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXN77uvZaUEzKpDFHr5D8RJvGuDYGsfduCNQSgDBJBM=;
	b=yAyK82Jgo+FHSngW/yAhnG1uWQvgdDMtxLUPg5fpqwMJgP4CS5gpJLwroubvrhd8cMmp1l
	qMUTpXoABkTRolAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286620; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXN77uvZaUEzKpDFHr5D8RJvGuDYGsfduCNQSgDBJBM=;
	b=shy6esmjWDwV1Q5h4BPZmal58rRAd/KUi1HdBHgwxwrWaQYhCsclNBw6iS00ZR82wYJTKF
	9LTXhtLSfIUtWDQKy11UkoSKYLEvyzIjyvmuthZQYLaiCLFoAZAvEmJ93T+Aa+fi6HTIyc
	RLy58zmqHpdpiBPwI7jaHHPoPVdyw14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286620;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GXN77uvZaUEzKpDFHr5D8RJvGuDYGsfduCNQSgDBJBM=;
	b=yAyK82Jgo+FHSngW/yAhnG1uWQvgdDMtxLUPg5fpqwMJgP4CS5gpJLwroubvrhd8cMmp1l
	qMUTpXoABkTRolAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 54D883EA63;
	Thu, 27 Nov 2025 23:37:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id N2MbDpzgKGlOGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 27 Nov 2025 23:37:00 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-mm@kvack.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	Mateusz Guzik <mjguzik@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 4/4] mm: Split a slow path for updating mm counters
Date: Thu, 27 Nov 2025 18:36:31 -0500
Message-ID: <20251127233635.4170047-5-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127233635.4170047-1-krisman@suse.de>
References: <20251127233635.4170047-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 964DE80005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 1dq4tcjhpsoyqdz9h16mi57rmfcysdke
X-HE-Tag: 1764286628-478142
X-HE-Meta: U2FsdGVkX18Cjf5vFWJZ4s+hXe4q45rVNX34NDphCw9G/v5dBK7Ykoqr3Vm+wnacybiXUC7D+MJRX5WmZvBjPdey45+6rwGnzoM0L1KwEVJCJBcw2bWRm7runGffWevlrNX9iwOQuKeiYEkRDZ7YN4N3LZ/5T6mnNl5NgnMW+GxgrYz2pUdmTkpl1h4ZSHBc59q7SrqMSyiM5Sen9Y4vsV9F6J8aeoJUqS+xWtdpTewTHXbGzyBXP0mgpdUhDtMzjTfzoSoOOC1U+n2Ur5FcDb2XUD4cJc9IaXNgWTgrEBbuQK6dqHy2ZyTQ4nI5McJScaOSHYTB9A9zIgSDyLzAqSmjGmnCk//Z/96aWdC0DMN7uzb8i43m6EZkYSyWpEaED/ac4Kfd9gaPLbyQShrdaJJZv+zbZnv5+05Jyhxhv9Xpp19y8wlHR0K3jd6khonIFPqngokeSewpMx+ZUJcQ3u2uVTDjh7TA/SYt2We14fiESiHACogFfrVtHw7IvVLk/I92XEJJUaAIQJoDBg2s9uE/yAlEZSXYAhYKyK5XV2MxqV6ev6YYovsd4+fA9h3Xk/83XyW7gxPDNhGQcwe9oCaoPe4Kc5VODXXecg+W6haLcp0JwNsNW5XleCCaCRpMMVkhz/Z97DOf1dBVemU5s4VA9doYiBOxzJ8vYAPkCv1VJpU2gKA2RAOicpf+5Z5jY6BDiTO26Gv4OJ4OJIeu9PUbXWeWTrZilI9P4EZQqob1vpdmuf52Vcc+E1Pb2h8++A2TNQ4qHe/rCpNQ6aBFs1IQJWmVllvP4PlHuYVf/tcD51MsRbFoQCAwe772vF4rLPEgc9xyEWTXtzAihJnwDkOTfnZ5ZwagWceuc4uE0CeUy6XtjiGM3W+Yc9J3pDbra99cjURrYVOvu5jq9Ts/yaWibL5HXWPam+RVrLGuRjrEZKPSG1PKpa5UMqNLjnM8CsigVZMOjMdyLv9rOIi
 dglzEugM
 HXXaxi/FQ1HaynnWBkC7E4RCwPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For cases where we know we are not coming from local context, there is
no point in touching current when incrementing/decrementing the
counters.  Split this path into another helper to avoid this cost.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 arch/s390/mm/gmap_helpers.c |  4 ++--
 arch/s390/mm/pgtable.c      |  4 ++--
 fs/exec.c                   |  2 +-
 include/linux/mm.h          | 14 +++++++++++---
 kernel/events/uprobes.c     |  2 +-
 mm/filemap.c                |  2 +-
 mm/huge_memory.c            | 22 +++++++++++-----------
 mm/khugepaged.c             |  6 +++---
 mm/ksm.c                    |  2 +-
 mm/madvise.c                |  2 +-
 mm/memory.c                 | 20 ++++++++++----------
 mm/migrate.c                |  2 +-
 mm/migrate_device.c         |  2 +-
 mm/rmap.c                   | 16 ++++++++--------
 mm/swapfile.c               |  6 +++---
 mm/userfaultfd.c            |  2 +-
 16 files changed, 58 insertions(+), 50 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index d4c3c36855e2..6d8498c56d08 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -29,9 +29,9 @@
 static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
 {
 	if (!non_swap_entry(entry))
-		dec_mm_counter(mm, MM_SWAPENTS);
+		dec_mm_counter_other(mm, MM_SWAPENTS);
 	else if (is_migration_entry(entry))
-		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
+		dec_mm_counter_other(mm, mm_counter(pfn_swap_entry_folio(entry)));
 	free_swap_and_cache(entry);
 }
 
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 0fde20bbc50b..021a04f958e5 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -686,11 +686,11 @@ void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep)
 static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
 {
 	if (!non_swap_entry(entry))
-		dec_mm_counter(mm, MM_SWAPENTS);
+		dec_mm_counter_other(mm, MM_SWAPENTS);
 	else if (is_migration_entry(entry)) {
 		struct folio *folio = pfn_swap_entry_folio(entry);
 
-		dec_mm_counter(mm, mm_counter(folio));
+		dec_mm_counter_other(mm, mm_counter(folio));
 	}
 	free_swap_and_cache(entry);
 }
diff --git a/fs/exec.c b/fs/exec.c
index 4298e7e08d5d..33d0eb00d315 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -137,7 +137,7 @@ static void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
 		return;
 
 	bprm->vma_pages = pages;
-	add_mm_counter(mm, MM_ANONPAGES, diff);
+	add_mm_counter_local(mm, MM_ANONPAGES, diff);
 }
 
 static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 29de4c60ac6c..2db12280e938 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2689,7 +2689,7 @@ static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
 
-static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
+static inline void add_mm_counter_local(struct mm_struct *mm, int member, long value)
 {
 	if (READ_ONCE(current->mm) == mm)
 		lazy_percpu_counter_add_fast(&mm->rss_stat[member], value);
@@ -2698,9 +2698,17 @@ static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
 
 	mm_trace_rss_stat(mm, member);
 }
+static inline void add_mm_counter_other(struct mm_struct *mm, int member, long value)
+{
+	lazy_percpu_counter_add_atomic(&mm->rss_stat[member], value);
+
+	mm_trace_rss_stat(mm, member);
+}
 
-#define inc_mm_counter(mm, member) add_mm_counter(mm, member, 1)
-#define dec_mm_counter(mm, member) add_mm_counter(mm, member, -1)
+#define inc_mm_counter_local(mm, member) add_mm_counter_local(mm, member, 1)
+#define dec_mm_counter_local(mm, member) add_mm_counter_local(mm, member, -1)
+#define inc_mm_counter_other(mm, member) add_mm_counter_other(mm, member, 1)
+#define dec_mm_counter_other(mm, member) add_mm_counter_other(mm, member, -1)
 
 /* Optimized variant when folio is already known not to be anon */
 static inline int mm_counter_file(struct folio *folio)
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 8709c69118b5..9c0e73dd2948 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -447,7 +447,7 @@ static int __uprobe_write(struct vm_area_struct *vma,
 	if (!orig_page_is_identical(vma, vaddr, fw->page, &pmd_mappable))
 		goto remap;
 
-	dec_mm_counter(vma->vm_mm, MM_ANONPAGES);
+	dec_mm_counter_other(vma->vm_mm, MM_ANONPAGES);
 	folio_remove_rmap_pte(folio, fw->page, vma);
 	if (!folio_mapped(folio) && folio_test_swapcache(folio) &&
 	     folio_trylock(folio)) {
diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..5d1656e63602 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3854,7 +3854,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
 
 		folio_unlock(folio);
 	} while ((folio = next_uptodate_folio(&xas, mapping, end_pgoff)) != NULL);
-	add_mm_counter(vma->vm_mm, folio_type, rss);
+	add_mm_counter_other(vma->vm_mm, folio_type, rss);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	trace_mm_filemap_map_pages(mapping, start_pgoff, end_pgoff);
 out:
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..614b0a8e168b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1228,7 +1228,7 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
 	folio_add_lru_vma(folio, vma);
 	set_pmd_at(vma->vm_mm, haddr, pmd, entry);
 	update_mmu_cache_pmd(vma, haddr, pmd);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_mm_counter_local(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	count_vm_event(THP_FAULT_ALLOC);
 	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
 	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
@@ -1444,7 +1444,7 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 		} else {
 			folio_get(fop.folio);
 			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
-			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
+			add_mm_counter_local(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
 		}
 	} else {
 		entry = pmd_mkhuge(pfn_pmd(fop.pfn, prot));
@@ -1563,7 +1563,7 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 
 		folio_get(fop.folio);
 		folio_add_file_rmap_pud(fop.folio, &fop.folio->page, vma);
-		add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
+		add_mm_counter_local(mm, mm_counter_file(fop.folio), HPAGE_PUD_NR);
 	} else {
 		entry = pud_mkhuge(pfn_pud(fop.pfn, prot));
 		entry = pud_mkspecial(entry);
@@ -1714,7 +1714,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 				pmd = pmd_swp_mkuffd_wp(pmd);
 			set_pmd_at(src_mm, addr, src_pmd, pmd);
 		}
-		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+		add_mm_counter_local(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 		mm_inc_nr_ptes(dst_mm);
 		pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
 		if (!userfaultfd_wp(dst_vma))
@@ -1758,7 +1758,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		__split_huge_pmd(src_vma, src_pmd, addr, false);
 		return -EAGAIN;
 	}
-	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
+	add_mm_counter_local(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 out_zero_page:
 	mm_inc_nr_ptes(dst_mm);
 	pgtable_trans_huge_deposit(dst_mm, dst_pmd, pgtable);
@@ -2223,11 +2223,11 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		if (folio_test_anon(folio)) {
 			zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+			add_mm_counter_other(tlb->mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 		} else {
 			if (arch_needs_pgtable_deposit())
 				zap_deposited_table(tlb->mm, pmd);
-			add_mm_counter(tlb->mm, mm_counter_file(folio),
+			add_mm_counter_other(tlb->mm, mm_counter_file(folio),
 				       -HPAGE_PMD_NR);
 
 			/*
@@ -2719,7 +2719,7 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		page = pud_page(orig_pud);
 		folio = page_folio(page);
 		folio_remove_rmap_pud(folio, page, vma);
-		add_mm_counter(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
+		add_mm_counter_other(tlb->mm, mm_counter_file(folio), -HPAGE_PUD_NR);
 
 		spin_unlock(ptl);
 		tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE);
@@ -2755,7 +2755,7 @@ static void __split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
 		folio_set_referenced(folio);
 	folio_remove_rmap_pud(folio, page, vma);
 	folio_put(folio);
-	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
+	add_mm_counter_local(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
 }
 
@@ -2874,7 +2874,7 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
 			folio_remove_rmap_pmd(folio, page, vma);
 			folio_put(folio);
 		}
-		add_mm_counter(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
+		add_mm_counter_local(mm, mm_counter_file(folio), -HPAGE_PMD_NR);
 		return;
 	}
 
@@ -3188,7 +3188,7 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
-	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
+	add_mm_counter_local(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
 	if (vma->vm_flags & VM_LOCKED)
 		mlock_drain_local();
 	folio_put(folio);
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..a6634ca0667d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -691,7 +691,7 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
 		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
+			add_mm_counter_other(vma->vm_mm, MM_ANONPAGES, 1);
 			if (is_zero_pfn(pte_pfn(pteval))) {
 				/*
 				 * ptl mostly unnecessary.
@@ -1664,7 +1664,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	/* step 3: set proper refcount and mm_counters. */
 	if (nr_mapped_ptes) {
 		folio_ref_sub(folio, nr_mapped_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
+		add_mm_counter_other(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 
 	/* step 4: remove empty page table */
@@ -1700,7 +1700,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	if (nr_mapped_ptes) {
 		flush_tlb_mm(mm);
 		folio_ref_sub(folio, nr_mapped_ptes);
-		add_mm_counter(mm, mm_counter_file(folio), -nr_mapped_ptes);
+		add_mm_counter_other(mm, mm_counter_file(folio), -nr_mapped_ptes);
 	}
 unlock:
 	if (start_pte)
diff --git a/mm/ksm.c b/mm/ksm.c
index 7bc726b50b2f..7434cf1f4925 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1410,7 +1410,7 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		 * will get wrong values in /proc, and a BUG message in dmesg
 		 * when tearing down the mm.
 		 */
-		dec_mm_counter(mm, MM_ANONPAGES);
+		dec_mm_counter_other(mm, MM_ANONPAGES);
 	}
 
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..ba7ea134f5ad 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -776,7 +776,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	}
 
 	if (nr_swap)
-		add_mm_counter(mm, MM_SWAPENTS, nr_swap);
+		add_mm_counter_local(mm, MM_SWAPENTS, nr_swap);
 	if (start_pte) {
 		arch_leave_lazy_mmu_mode();
 		pte_unmap_unlock(start_pte, ptl);
diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..9a18ac25955c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -488,7 +488,7 @@ static inline void add_mm_rss_vec(struct mm_struct *mm, int *rss)
 
 	for (i = 0; i < NR_MM_COUNTERS; i++)
 		if (rss[i])
-			add_mm_counter(mm, i, rss[i]);
+			add_mm_counter_other(mm, i, rss[i]);
 }
 
 static bool is_bad_page_map_ratelimited(void)
@@ -2306,7 +2306,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
 			pteval = pte_mkyoung(pteval);
 			pteval = maybe_mkwrite(pte_mkdirty(pteval), vma);
 		}
-		inc_mm_counter(vma->vm_mm, mm_counter_file(folio));
+		inc_mm_counter_local(vma->vm_mm, mm_counter_file(folio));
 		folio_add_file_rmap_pte(folio, page, vma);
 	}
 	set_pte_at(vma->vm_mm, addr, pte, pteval);
@@ -3716,12 +3716,12 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
 		if (old_folio) {
 			if (!folio_test_anon(old_folio)) {
-				dec_mm_counter(mm, mm_counter_file(old_folio));
-				inc_mm_counter(mm, MM_ANONPAGES);
+				dec_mm_counter_other(mm, mm_counter_file(old_folio));
+				inc_mm_counter_other(mm, MM_ANONPAGES);
 			}
 		} else {
 			ksm_might_unmap_zero_page(mm, vmf->orig_pte);
-			inc_mm_counter(mm, MM_ANONPAGES);
+			inc_mm_counter_other(mm, MM_ANONPAGES);
 		}
 		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
 		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
@@ -4916,8 +4916,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	if (should_try_to_free_swap(folio, vma, vmf->flags))
 		folio_free_swap(folio);
 
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
-	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
+	add_mm_counter_other(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	add_mm_counter_other(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
 	if (pte_swp_soft_dirty(vmf->orig_pte))
 		pte = pte_mksoft_dirty(pte);
@@ -5223,7 +5223,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 	}
 
 	folio_ref_add(folio, nr_pages - 1);
-	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
+	add_mm_counter_other(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	count_mthp_stat(folio_order(folio), MTHP_STAT_ANON_FAULT_ALLOC);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 	folio_add_lru_vma(folio, vma);
@@ -5375,7 +5375,7 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	if (write)
 		entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
 
-	add_mm_counter(vma->vm_mm, mm_counter_file(folio), HPAGE_PMD_NR);
+	add_mm_counter_other(vma->vm_mm, mm_counter_file(folio), HPAGE_PMD_NR);
 	folio_add_file_rmap_pmd(folio, page, vma);
 
 	/*
@@ -5561,7 +5561,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 	folio_ref_add(folio, nr_pages - 1);
 	set_pte_range(vmf, folio, page, nr_pages, addr);
 	type = is_cow ? MM_ANONPAGES : mm_counter_file(folio);
-	add_mm_counter(vma->vm_mm, type, nr_pages);
+	add_mm_counter_other(vma->vm_mm, type, nr_pages);
 	ret = 0;
 
 unlock:
diff --git a/mm/migrate.c b/mm/migrate.c
index e3065c9edb55..dd8c6e6224f9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -329,7 +329,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 
 	set_pte_at(pvmw->vma->vm_mm, pvmw->address, pvmw->pte, newpte);
 
-	dec_mm_counter(pvmw->vma->vm_mm, mm_counter(folio));
+	dec_mm_counter_other(pvmw->vma->vm_mm, mm_counter(folio));
 	return true;
 }
 
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index abd9f6850db6..7f3e5d7b3109 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -676,7 +676,7 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	inc_mm_counter(mm, MM_ANONPAGES);
+	inc_mm_counter_other(mm, MM_ANONPAGES);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
 	if (!folio_is_zone_device(folio))
 		folio_add_lru_vma(folio, vma);
diff --git a/mm/rmap.c b/mm/rmap.c
index ac4f783d6ec2..0f6023ffb65d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2085,7 +2085,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
 						hsz);
 			} else {
-				dec_mm_counter(mm, mm_counter(folio));
+				dec_mm_counter_other(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2100,7 +2100,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 * migration) will not expect userfaults on already
 			 * copied pages.
 			 */
-			dec_mm_counter(mm, mm_counter(folio));
+			dec_mm_counter_other(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
 			swp_entry_t entry = page_swap_entry(subpage);
 			pte_t swp_pte;
@@ -2155,7 +2155,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
+				add_mm_counter_other(mm, MM_ANONPAGES, -nr_pages);
 				goto discard;
 			}
 
@@ -2188,8 +2188,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 					list_add(&mm->mmlist, &init_mm.mmlist);
 				spin_unlock(&mmlist_lock);
 			}
-			dec_mm_counter(mm, MM_ANONPAGES);
-			inc_mm_counter(mm, MM_SWAPENTS);
+			dec_mm_counter_other(mm, MM_ANONPAGES);
+			inc_mm_counter_other(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
 			if (anon_exclusive)
 				swp_pte = pte_swp_mkexclusive(swp_pte);
@@ -2217,7 +2217,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(folio));
+			dec_mm_counter_other(mm, mm_counter_file(folio));
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio))) {
@@ -2476,7 +2476,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				set_huge_pte_at(mm, address, pvmw.pte, pteval,
 						hsz);
 			} else {
-				dec_mm_counter(mm, mm_counter(folio));
+				dec_mm_counter_other(mm, mm_counter(folio));
 				set_pte_at(mm, address, pvmw.pte, pteval);
 			}
 		} else if (likely(pte_present(pteval)) && pte_unused(pteval) &&
@@ -2491,7 +2491,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			 * migration) will not expect userfaults on already
 			 * copied pages.
 			 */
-			dec_mm_counter(mm, mm_counter(folio));
+			dec_mm_counter_other(mm, mm_counter(folio));
 		} else {
 			swp_entry_t entry;
 			pte_t swp_pte;
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 10760240a3a2..70f7d31c0854 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2163,7 +2163,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	if (unlikely(hwpoisoned || !folio_test_uptodate(folio))) {
 		swp_entry_t swp_entry;
 
-		dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
+		dec_mm_counter_other(vma->vm_mm, MM_SWAPENTS);
 		if (hwpoisoned) {
 			swp_entry = make_hwpoison_entry(page);
 		} else {
@@ -2181,8 +2181,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
-	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
+	dec_mm_counter_other(vma->vm_mm, MM_SWAPENTS);
+	inc_mm_counter_other(vma->vm_mm, MM_ANONPAGES);
 	folio_get(folio);
 	if (folio == swapcache) {
 		rmap_t rmap_flags = RMAP_NONE;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index af61b95c89e4..34e760c37b7b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -221,7 +221,7 @@ int mfill_atomic_install_pte(pmd_t *dst_pmd,
 	 * Must happen after rmap, as mm_counter() checks mapping (via
 	 * PageAnon()), which is set by __page_set_anon_rmap().
 	 */
-	inc_mm_counter(dst_mm, mm_counter(folio));
+	inc_mm_counter_other(dst_mm, mm_counter(folio));
 
 	set_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte);
 
-- 
2.51.0


