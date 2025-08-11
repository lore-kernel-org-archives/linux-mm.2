Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D8BBC87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF7368E0040; Mon, 11 Aug 2025 07:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8166B0163; Mon, 11 Aug 2025 07:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD658E0040; Mon, 11 Aug 2025 07:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B61D66B0162
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:26:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 761EC55D2F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:52 +0000 (UTC)
X-FDA: 83764249464.19.3B94CF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 72D2B80004
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:26:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUirt2cn;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754911610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNeO4mnK34t1j+RunD3+GtheXBl5F9uGzS1IAgGiaS8=;
	b=GVhhmDnBQMyw1cCEZg+VItDVxrzkRsM6aFTtZnSSKEE9ohXca/GLP6fXD0ZO0rortIq89G
	4XPkr+wWINwrV+F2mq2C1LiKRqEO0xiKqm2UPokxoNeJsaOt7c6MBHSWrv3fCkTWvd5Jww
	DF22qeLqbt3Lnynm9AXEQ6i/m+6f+Gc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EUirt2cn;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754911610; a=rsa-sha256;
	cv=none;
	b=JImnwnZfURXZQ968YtaemlYmvr1MPd37hbAQI8RZpEthqxgg1rKX5m34JiAxCdc+dnxGjM
	M6iQFG6JzNpvW0YETBJa1V6NM7TN+AbUB7yJedcCLRo1e3GFxBl9rk4v+cPojjXOQ0nCCU
	t9LMwXE0UKedSJsIXLIk5wfKPBCLz3k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754911609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DNeO4mnK34t1j+RunD3+GtheXBl5F9uGzS1IAgGiaS8=;
	b=EUirt2cnGsd3GncXXFwTue7LbvCqjLItstkOGbfSRPhNcVcKGphViRXUJHK3bmYQXRbvdr
	QZSmreySxgyOOqOjoh0EBzhFk62+iX/X7NbfShdTzDaAr4I7183Utf/yjW6MTUw7OTwKs/
	vEu6cMPa55m/3fAATlrns0Uf+Zyl1X4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-zFrN7-vUOCKdj3vn9rBOhg-1; Mon, 11 Aug 2025 07:26:48 -0400
X-MC-Unique: zFrN7-vUOCKdj3vn9rBOhg-1
X-Mimecast-MFC-AGG-ID: zFrN7-vUOCKdj3vn9rBOhg_1754911607
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45359bfe631so21791955e9.0
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:26:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754911607; x=1755516407;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DNeO4mnK34t1j+RunD3+GtheXBl5F9uGzS1IAgGiaS8=;
        b=rji/LzhCKSxcbZZWZnqkXOc8/OhQ75aXdqFrfvY3NnYayJRLu0qByYw6jMySbaLhR+
         TyMxqetQerM2YDIkLhrb8/QAPCWNk2saVdKYZMwSuRQ/n+/prjJ35KdUf8I1bkx+Ymcz
         F6A7MR67bovnO0KqVAL95G71U5yGGvMLqFCwpExkWbrzQAICZY55XxXFND+GlPXrcX5u
         J9lnqYbnZijRlIgxx+qWibURWdXanUuxlH+Ol19j2xmJ2RsDbST0GSub8ELb6G4e4heo
         jOINAG1SjjVuojf1FJyPEJmWpAVNCZB94np8sAV/GDZzMz/2YU62pppaWZiclUpYdHdS
         0H2g==
X-Gm-Message-State: AOJu0Yz+a0XMcfqvF+BqRjkgZrFXiEyvJouxZKEvuwtXRYRkxxPK8dOW
	4L0UHJkbwKALq7hm0+xbbTdCru0TUk8HonuK9T7HLWIrC3CIMJlEwaxARfx6du8JK/VeHZYwFUo
	ylWEhbYJKtwLume6EflrSAEweflRAZrgaLVoOWVAWgPfT1jVuMM7E
X-Gm-Gg: ASbGncvukHQ+0laJW7RcuQeAMg59jd48L6NdgGeXvQwqwzW1GN2x0gqhYL0xk/dS4e1
	G4CQ0Zj4zPIhnlp4PzqlEwdP/tkUyFqATrLmcAlzWbMAv8enj7Y3ensdbMXra0t4u1VTVBUswAQ
	/RveqN+rNl4b91FND3MKTDcurtpcPfyfmOpt6zAlufq8HQqUaoVgVyzZzT/9pbonqXaRw60XtRv
	lGyBI29SDGWsfrsWBf8h0SfX+rQTgyavGc/3hWYMjMAuIx18KM/ccKpisy82C1BXyWwfKUh1f6G
	n/Iohy+txe8nKJoJo/a7+GtkG8qNwchwEeHFEpSeTxbm0GI5TAjhCt0tiMd432V+mMRT+Ar3TVc
	l13ClS9GQSFuXYO/h0j9GVsFV
X-Received: by 2002:a05:600c:4746:b0:453:23fe:ca86 with SMTP id 5b1f17b1804b1-459f4ea0f2dmr115559685e9.4.1754911607441;
        Mon, 11 Aug 2025 04:26:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+SYBbVCDa86Al3Rw//iuzbWoSgvjLT8uLZDTY5p6isO9HqDz+nOTt8CKLJXWJJ2UJD3ft4A==
X-Received: by 2002:a05:600c:4746:b0:453:23fe:ca86 with SMTP id 5b1f17b1804b1-459f4ea0f2dmr115559215e9.4.1754911607000;
        Mon, 11 Aug 2025 04:26:47 -0700 (PDT)
Received: from localhost (p200300d82f06a600a397de1d2f8bb66f.dip0.t-ipconnect.de. [2003:d8:2f06:a600:a397:de1d:2f8b:b66f])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-459e6214640sm259832575e9.1.2025.08.11.04.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 04:26:46 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	xen-devel@lists.xenproject.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 05/11] mm/huge_memory: mark PMD mappings of the huge zero folio special
Date: Mon, 11 Aug 2025 13:26:25 +0200
Message-ID: <20250811112631.759341-6-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250811112631.759341-1-david@redhat.com>
References: <20250811112631.759341-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G5kFLhna6OWjaJKnpfVNMbhdTvYaxiharRiqOK0LM4w_1754911607
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 72D2B80004
X-Rspamd-Server: rspam06
X-Stat-Signature: 9zrkk7ko5apeghm8esthrtq1q3bwobcn
X-HE-Tag: 1754911610-240731
X-HE-Meta: U2FsdGVkX1/0eaGhuR11upH5YYbyXGX1/E5LHjHnyHuu+3450SaktIiy4NB3gU7lE/IRm8eSbx+OerQAJcOzMBXJYLj1K66eqqWf4O3ZtSccgRzfyuheKlmKu90Lj/ff4yvZlWUjrNS7wARU8HEqIWxGas8Q84hoLg3044/SXf790B4R9VhBhNvFLGHzeum9YbaNIRtYvwv9dgjVxEMDl30c9QQYFMhc4I58AIyezQkZczlCx6BxRdWfUD4hm2Pi0+ovMw54eNSMx3yJ4thzcQp35R8k8ptgjUiDDnQad0aK40p3+UT2+03nbZUD9mDGspmVaSvf0TphVUVC1TRq8ksBCUHMMuRddu3FFYVjb0h+AynAM4SpywI6D0R8VbyA1K9Z9FRDlj8SX08fOdEHK3AuOP/MovYBTm0bd/JSJmb7Jl8G7DOeyDnl/yaMWfXhuOc0Iq7beMsPX7guVnWtRz+NpMhj9NjZPGMjXhloyoTsQfDtBck4GBKqLoV95F0pYGwwGQizPuMkV/21RwyKsrSNlqZyc4MGRv0r9KWyfnY1Hp01Ic1k3C+L1Y6CzpOd8F+V6uWsqXXzQ0A483bWcE2Na9b+UZ8LrzI1AeH1Kqg0FjSQuQcK6rbSV8LBQBU6NrXUUkc+87J1foFQeyc38Nvpo/l7EEv/1ozqSUOmWjUzYyfyS+CDWk8ThQT5HYV6ltTw+KmsvmPxXSF/Kr3NxFEcHn7JCGrlOpcn26XiVOFWYLbR1CVnqHdkXauE/4fo+2Eu8FTGRBKUCbKa9Eo2h+2In/Xdz/KMIy+0MvvDylz244u3e3w44MQyVLtOgFyKIEF1GgTmUxTgJorramXk9LsM5wt71h95C+88ZU74+bx8iuLCDpq5mydRAg8BIeH66kVvGTyDQW2pSKybSnkuC49GK5wcNMLrdf/uvXIAQKgQmr0SiokEGg7m0NIBc/gA88OCZ0CAaROkDP7oDHL
 I2qD/Au7
 TNLYRxRoFe8rGj/5BXPwYOzQE+8eVJeHAKYHLHhLdFMkvLYicQegNvhp2gLcRKlSkmeBBX0+XmaBTSYSwtacFO/LAFrHju0l79n1KUNg/EIRpHJYglRAiZX6Pa3be/Nsd8VmDSiZpTxahHPEgkhJuHj4qlKJmhDcAjCUWIJLsUhEwktGA476I3qOLHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The huge zero folio is refcounted (+mapcounted -- is that a word?)
differently than "normal" folios, similarly (but different) to the ordinary
shared zeropage.

For this reason, we special-case these pages in
vm_normal_page*/vm_normal_folio*, and only allow selected callers to
still use them (e.g., GUP can still take a reference on them).

vm_normal_page_pmd() already filters out the huge zero folio, to
indicate it a special (return NULL). However, so far we are not making
use of pmd_special() on architectures that support it
(CONFIG_ARCH_HAS_PTE_SPECIAL), like we would with the ordinary shared
zeropage.

Let's mark PMD mappings of the huge zero folio similarly as special, so we
can avoid the manual check for the huge zero folio with
CONFIG_ARCH_HAS_PTE_SPECIAL next, and only perform the check on
!CONFIG_ARCH_HAS_PTE_SPECIAL.

In copy_huge_pmd(), where we have a manual pmd_special() check to handle
PFNMAP, we have to manually rule out the huge zero folio. That code
needs a serious cleanup, but that's something for another day.

While at it, update the doc regarding the shared zero folios.

No functional change intended: vm_normal_page_pmd() still returns NULL
when it encounters the huge zero folio.

Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/huge_memory.c |  8 ++++++--
 mm/memory.c      | 15 ++++++++++-----
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ec89e0607424e..58bac83e7fa31 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1309,6 +1309,7 @@ static void set_huge_zero_folio(pgtable_t pgtable, struct mm_struct *mm,
 {
 	pmd_t entry;
 	entry = folio_mk_pmd(zero_folio, vma->vm_page_prot);
+	entry = pmd_mkspecial(entry);
 	pgtable_trans_huge_deposit(mm, pmd, pgtable);
 	set_pmd_at(mm, haddr, pmd, entry);
 	mm_inc_nr_ptes(mm);
@@ -1418,7 +1419,9 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	if (fop.is_folio) {
 		entry = folio_mk_pmd(fop.folio, vma->vm_page_prot);
 
-		if (!is_huge_zero_folio(fop.folio)) {
+		if (is_huge_zero_folio(fop.folio)) {
+			entry = pmd_mkspecial(entry);
+		} else {
 			folio_get(fop.folio);
 			folio_add_file_rmap_pmd(fop.folio, &fop.folio->page, vma);
 			add_mm_counter(mm, mm_counter_file(fop.folio), HPAGE_PMD_NR);
@@ -1643,7 +1646,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	int ret = -ENOMEM;
 
 	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_present(pmd) && pmd_special(pmd))) {
+	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
+		     !is_huge_zero_pmd(pmd))) {
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
diff --git a/mm/memory.c b/mm/memory.c
index 0ba4f6b718471..626caedce35e0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -555,7 +555,14 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  *
  * "Special" mappings do not wish to be associated with a "struct page" (either
  * it doesn't exist, or it exists but they don't want to touch it). In this
- * case, NULL is returned here. "Normal" mappings do have a struct page.
+ * case, NULL is returned here. "Normal" mappings do have a struct page and
+ * are ordinarily refcounted.
+ *
+ * Page mappings of the shared zero folios are always considered "special", as
+ * they are not ordinarily refcounted: neither the refcount nor the mapcount
+ * of these folios is adjusted when mapping them into user page tables.
+ * Selected page table walkers (such as GUP) can still identify mappings of the
+ * shared zero folios and work with the underlying "struct page".
  *
  * There are 2 broad cases. Firstly, an architecture may define a pte_special()
  * pte bit, in which case this function is trivial. Secondly, an architecture
@@ -585,9 +592,8 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  *
  * VM_MIXEDMAP mappings can likewise contain memory with or without "struct
  * page" backing, however the difference is that _all_ pages with a struct
- * page (that is, those where pfn_valid is true) are refcounted and considered
- * normal pages by the VM. The only exception are zeropages, which are
- * *never* refcounted.
+ * page (that is, those where pfn_valid is true, except the shared zero
+ * folios) are refcounted and considered normal pages by the VM.
  *
  * The disadvantage is that pages are refcounted (which can be slower and
  * simply not an option for some PFNMAP users). The advantage is that we
@@ -667,7 +673,6 @@ struct page *vm_normal_page_pmd(struct vm_area_struct *vma, unsigned long addr,
 {
 	unsigned long pfn = pmd_pfn(pmd);
 
-	/* Currently it's only used for huge pfnmaps */
 	if (unlikely(pmd_special(pmd)))
 		return NULL;
 
-- 
2.50.1


