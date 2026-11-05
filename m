Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51BCE6083607
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MnULQVB2;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MnULQVB2
Received: by kanga.kvack.org (Postfix)
	id 957CA6B05C2; Thu,  5 Nov 2026 12:01:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92FBD6B05C3; Thu,  5 Nov 2026 12:01:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E846B05C4; Thu,  5 Nov 2026 12:01:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66AB76B05C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDE34160B63
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:59 +0000 (UTC)
X-FDA: 85401680238.07.D4BFE35
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id A63C520020
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnULQVB2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnULQVB2;
	spf=pass (imf31.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898057;
	b=NtBtA79USQ7iU/fQgt9VcslaCNFv/Ho3oekoR0lI4pf8H3UktM3ePadCSsqNAIpeazm4IJ
	3MNa6uG2Bw5n9MNr1nbvo6wbUsrwkuEADmay8ibsf8YFZQxkFOiRebdx25DJvipNpwpELs
	4gyT53lMSW1F8bwGQmWY+cvNI3utSJQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnULQVB2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bHtRIRuo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MnULQVB2;
	spf=pass (imf31.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZNgGJWG7rTKkwW3ylpil8PEuUBqj8yefdS7O9KEe1jw=;
	b=JKtk3mxZpV/2KB6lPZbWT8RFuPS+BEg56ammOEIHUHIjNeqbFEjBe4xMFZdiVSBwr43WPM
	xP0ZGbH6GrbFu9jfZtbR9WIn3SM/g4/2Zfp181a0zUiG1CfnaZKIDdp2tHUFdzAVXwmvH1
	NvSg6scM/c7QfmDUgszgtj2T7ZSyQuI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F1461FE10;
	Thu,  5 Nov 2026 17:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNgGJWG7rTKkwW3ylpil8PEuUBqj8yefdS7O9KEe1jw=;
	b=bHtRIRuonQJOyPSuvBrRcvmluyZbQFXKnkednZ74NurqqE7mD0rORk4DdY37kO9ARtje2H
	Tfb9aw/KT25PXgNShyd0rTI+HsIdalnYzh8Y/ji+5cnsma12HMP+8MbamiIX+zd6qZM6vV
	kk7tYABFjLG5ohPPbtspouCeIZP/sa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNgGJWG7rTKkwW3ylpil8PEuUBqj8yefdS7O9KEe1jw=;
	b=MnULQVB2MyVRCdT8JcNvwCGhlbVrVTp9YHB8rfRO5thDdE4wCUgLw0RCFoFw+vV3I8Hzux
	IFSTFPsVg63BKPBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNgGJWG7rTKkwW3ylpil8PEuUBqj8yefdS7O9KEe1jw=;
	b=bHtRIRuonQJOyPSuvBrRcvmluyZbQFXKnkednZ74NurqqE7mD0rORk4DdY37kO9ARtje2H
	Tfb9aw/KT25PXgNShyd0rTI+HsIdalnYzh8Y/ji+5cnsma12HMP+8MbamiIX+zd6qZM6vV
	kk7tYABFjLG5ohPPbtspouCeIZP/sa0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898056;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZNgGJWG7rTKkwW3ylpil8PEuUBqj8yefdS7O9KEe1jw=;
	b=MnULQVB2MyVRCdT8JcNvwCGhlbVrVTp9YHB8rfRO5thDdE4wCUgLw0RCFoFw+vV3I8Hzux
	IFSTFPsVg63BKPBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7EB46133F6;
	Thu,  5 Nov 2026 17:00:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T4
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:54 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH v2 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE in change_huge_pud()
Date: Thu,  5 Nov 2026 17:50:00 +0100
Message-ID: <20261105165004.2663799-7-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Spam-Level: 
X-Stat-Signature: ocretry6mzo14e9qxdsmp5hicmjfwyhr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A63C520020
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793898058-109532
X-HE-Meta: U2FsdGVkX19hoXscO2f/HmlVDesgH7zuVFc8BfKibVlWU2ZmYo5Z5/l5dfP9VnwzoxPmEbzqUhXiVQI0K4o8VE4XUGRLI8KFSExUV0PW5EsRAzC4cHFVp+oYog7cJ3NFsLJz+ikzUd4UXmepWHDv/m3Yz9N7qFWeu3atEHmuwE+/b6uCTb+Ml2fnTFYxnAd4Hm+PuFgbIcxQLfy1dUVYq7cwC2+jBOdsHX8RzAzYd5QIfeD3S3eE5kuWgQ/bSvSGm6yh4gzTnWaN/oPnPQ7W4+rG4k8NDVk5FjaH279iLqir5KQseCSif58UFuw5AlHqi/LgWwGbjy4dIwlJPrY/Qoj2YWTR267MKJjdo5eF1Ks4Bid2hWodHssWxR22aWum4GlyvCA+9Mp+wc4j/aPqRSdwx21XifwFtBzv94on36iONFK/0NdpUszEgewQsZgboJ0/nA7Z7fQGYaVbx7ApDNr7LmHeheTYWSWuuKT5KT2FwmTezFndZYvQtKWF6nNtVpM3M5DIPVv5xyRNydwIgQP/stw4QmZgVglmMN5NJ691TRO/1gYR4loEnuhoLh2hTFwEDn7bgmi6VibmoU0HDCN3BpY2hvpgCKIkh0VjEEBbZ+hEeNi+5Tu5Ryw2jHtvMOE08nX0eWM2pRvufiFsJeiphzSWIe54wQHtUeBkzDvRZZ1idsOGH+ZJDI5bUU3LSYe2sHF3MmgHko+aZ8xVRgkQBmUlYXzs0lz4Q55/8Y49eatK8kusUQPyE/1ZcPul4ZGpLMTq1v6o3ruufn8yfJV/Wjvz6TA+Alaw0xr6fsaiOvWu5q6hjzXC5lXPACQYu1KcvOLB8N/chcEYDVGy79qdidWhaDV1InefTSKutJ9fP1mLdWAtM8Bcj//Kc/smTlKpSDFnc0/FSxPjr12LpHXr/4UdyQFARBBNARU0JBkEkHSVWtlbte3YznisZyu/MqffoWfxfR+031i/yIt
 p0tZ9Gnk
 krWSCmPnz1ijlxBohMxl5IRX3hSklv0saB0A4zvYEalbhtUSe+xi7+slg2AoUv+Q78rqbY7CUZWsBwibId5FEFKI6/IoMLPlG8XrbHcgfRvh8AGGWanM0ClkFd+eheRm50HRbv3p1VrWQRHSb5ojpWtJnSrcuDMEpMQi3vu1emzM4ATRxMF4TSOndlGWOzul5wEFkHFjbBo2XuirHIG05PdWah4EkEdkMvI3RacGFzNsYAEqz/fIauJtXD/OiFYUJMwXGnb6ftyfPUpmWYAq1hC4xk9Cw03S8SM20+G+/uhigwyBScgL2oO6t9lNlGtCH6b/3LRhx86Cnjw0/N5naj8cf35HEpw4eovgRd+XHn9XbZFjUHYgxKjZ7UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When change_protection() is called on a range whose vma->vm_page_prot
does not contain the write bit (MAP_PRIVATE mappings, which need CoW
handling, or MAP_SHARED mappings that want write tracking), the new
entries are created without the write bit, letting the fault handler
re-introduce it. In such cases, MM_CP_TRY_CHANGE_WRITABLE is set to
eagerly restore the W bit in the page table entries when stripping the
write protection was not needed.

However, change_huge_pud() does not currently respect the flag. The only
user of huge PUDs, device DAX, is never CoW and does not need write
notifications for dirty tracking, but it does get them once soft-dirty
tracking is armed through /proc/pid/clear_refs. vm_page_prot then lacks
the write bit, and a protection change leaves dirty PUDs read-only, so
the next write takes a fault only to set the write bit again.

Align change_huge_pud() with change_pte_range() and change_huge_pmd() by
making it respect MM_CP_TRY_CHANGE_WRITABLE. Besides avoiding those
faults, this keeps huge PUDs consistent with the other levels if PUDs
that need CoW, such as anonymous ones, are ever introduced. They would
otherwise lose the write bit on every protection change, even where the
write fault handler would restore it without further checks.

Do this by introducing can_change_pud_writable(), which mimics
can_change_pmd_writable(). Omit the NUMA and uffd-wp checks, which
change_huge_pud() already rejects.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/pgtable.h |  5 +++++
 mm/huge_memory.c        | 28 +++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..943d7e95f426 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1866,6 +1866,11 @@ static inline int pmd_soft_dirty(pmd_t pmd)
 	return 0;
 }
 
+static inline int pud_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
 static inline pte_t pte_mksoft_dirty(pte_t pte)
 {
 	return pte;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..506e1e61c0fd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2824,6 +2824,29 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline bool can_change_pud_writable(struct vm_area_struct *vma,
+					   unsigned long addr, pud_t pud)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+		return false;
+
+	/* Do we need write faults for softdirty tracking? */
+	if (vma_soft_dirty_enabled(vma) && !pud_soft_dirty(pud))
+		return false;
+
+	if (!(vma->vm_flags & VM_SHARED)) {
+		/* See can_change_pte_writable(). */
+		page = vm_normal_page_pud(vma, addr, pud);
+		return page && PageAnon(page) && PageAnonExclusive(page);
+	}
+
+	/* See can_change_pte_writable(). */
+	return pud_dirty(pud);
+}
+
 /*
  * Returns:
  *
@@ -2831,7 +2854,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
  * - 1: if pud can be skipped
  * - HPAGE_PUD_NR: if pud was successfully processed
  */
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
 		    unsigned long cp_flags)
@@ -2863,6 +2885,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	oldpud = pudp_invalidate(vma, addr, pudp);
 	entry = pud_modify(oldpud, newprot);
+	/* See change_pte_range(). */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pud_write(entry) &&
+	    can_change_pud_writable(vma, addr, entry))
+		entry = pud_mkwrite(entry);
 	set_pud_at(mm, addr, pudp, entry);
 	tlb_flush_pud_range(tlb, addr, HPAGE_PUD_SIZE);
 
-- 
2.51.0


