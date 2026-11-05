Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6337560A261D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oMZXE9vq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=oMZXE9vq
Received: by kanga.kvack.org (Postfix)
	id 168E06B05B1; Thu,  5 Nov 2026 12:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143C86B05C4; Thu,  5 Nov 2026 12:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057276B05C5; Thu,  5 Nov 2026 12:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF6876B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61068C0A20
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:03 +0000 (UTC)
X-FDA: 85401680406.07.2A86BEA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FFAC16001A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oMZXE9vq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oMZXE9vq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XrOlVJc59oYib62BfT/3ENAYDoWhZ0QgBTfWP6Dr3iE=;
	b=eu3zpWXqlS/AIZVMJSS2nqN4K2r81ziuvbaYfPCCP2APYgzuG5B/GDhlqprrG4j1DFHxBH
	dL0ow/5nhSaQ2VbkPQ4BheNzUCVZwBmHJkQv0GmcNvWlyZbH746KN6z7tI+EXyrmvS993n
	0owgFhJdBV7VV4E42ol1ocIxlEn45WA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oMZXE9vq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bwfKcNNH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oMZXE9vq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898061;
	b=AL6+ixg2gYVmjRck4WY9eatvJ3bQoP5vUnFFNwlK0lpYAMkE/SbTH9EELvsG629ysMph+d
	EKQSCNuv1siVz4ODfZ9hlKoOcQr06QxKclPAuBCfvnL34kVCp5TY1pk4vs/+0C4P6bRyDI
	RK0zVOJI37TP+eHHQu/8LP1UXGp7PiQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A519322969;
	Thu,  5 Nov 2026 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrOlVJc59oYib62BfT/3ENAYDoWhZ0QgBTfWP6Dr3iE=;
	b=bwfKcNNHotvZiPIGKoYNHRVjzFCLekuO/biuK0+R+N+v7R6/3iDScSBzvXibnkScKr7HPW
	p7TKbxrVczEqGFHY7vl7yTBH41pYxALVihvTZ66tK+K52QJRjiPIFLxLuYUVcg+aX9jwdN
	F+59SFQc+NVuOP9tXnEajUkBtdwGsp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrOlVJc59oYib62BfT/3ENAYDoWhZ0QgBTfWP6Dr3iE=;
	b=oMZXE9vqv/q9klCqGpvzovKwu+02C8g691XsaiMX52BN3O/iSypUm5MDyh5oxy++gkk9Xo
	nB8GkVyOX4c5wmCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrOlVJc59oYib62BfT/3ENAYDoWhZ0QgBTfWP6Dr3iE=;
	b=bwfKcNNHotvZiPIGKoYNHRVjzFCLekuO/biuK0+R+N+v7R6/3iDScSBzvXibnkScKr7HPW
	p7TKbxrVczEqGFHY7vl7yTBH41pYxALVihvTZ66tK+K52QJRjiPIFLxLuYUVcg+aX9jwdN
	F+59SFQc+NVuOP9tXnEajUkBtdwGsp4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898059;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XrOlVJc59oYib62BfT/3ENAYDoWhZ0QgBTfWP6Dr3iE=;
	b=oMZXE9vqv/q9klCqGpvzovKwu+02C8g691XsaiMX52BN3O/iSypUm5MDyh5oxy++gkk9Xo
	nB8GkVyOX4c5wmCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E1386133F6;
	Thu,  5 Nov 2026 17:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T6
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:57 +0000
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
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v2 5/9] mm/mprotect: keep writable entries writable on permission upgrades
Date: Thu,  5 Nov 2026 17:50:02 +0100
Message-ID: <20261105165004.2663799-9-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0FFAC16001A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 8dacizfmr5pyf4hig1b8euei4h73aj4o
X-HE-Tag: 1793898060-619460
X-HE-Meta: U2FsdGVkX1+k7aOMxmBpDXbcaK/NAPSmb54LCfug6MUBc1huI5ZDt/jRru665NIunZc7+xS2KfAkqHjxO3LlAVgfVa5gl/15ZqBtE3wzuo5DAIE+mUIcGmmJG9hEsrFUEsQSJ6dOS6NmeT2NU50jvcvT7RVhqfqIcXVagjuqlfK6jVjMDEXpf+uQ92MHqoxQko6wiNjbLCugpcTUBn1mKDA2cnFXbHOEUzVfiiWjypEWcO1q9xdp74FmqO2KHYQIghuCYCVaUW6Nq6K2kQG9tpaGsAyun7ZcATjKjQ+rubGXAnQxIN+XWmuTCjJ1KAHctfea+y0wIjnt19Tbi1Yb0/sCmdMzPGXt6ZzoRC86bA50VxeBUUTPgyvQalcTNY69c8+bnDjcpu4LdfZTOu6B0zYOGWV3jgYV5xTooNpaw/SkpA7HMwV8WhLaK3N8Kg8hHQN8YyGzMKArt5yaFJ+DR1NrF/VHkDn8o6iFTo+7XnMei4UJC6T9kIbnyB8cDXp0j5LG7ysw9zQ7bSJaOtFJX3kg1b+WNN1CtblD3brlC8LTtFKQz5GqUCIkpWbILwc3kWsZAb5PPef9MTK2Mq8YJqP9PxAgoHx4+JfYKmu+2Mb2meVl89mgH36jy7ARizkxOJAQBqrSh45aD/k656zYnNSWDbmho7knRRPen2mt0lfABKIOP1aymm+uyWcYdEVBPJYEDqhn9NjdJ+H6+QznXDewZgL8ZT+xM4a07VRgQiB4miwLusWhTh/TBfRW/hag6V5bNtaWU5t1InUOl/OqsU9uApmp0V2Mz5zY5yoWndGYxlZVeW1tM/oo+jKhUDZroDe/BX7+CfLUEIP5EKwWZ/6QLEbQtcDf/od8lqYVMi7NkYWZPqGpLMfPkPxdzYe4XqD+mjBChvly1tBuGeVDW1FRAlqlHyOWLALjaqTCRwzHbRLl0dA8rdomrBHPnPdyEHGXQ8pQ37vj9dv1V1w
 FYDBRbL6
 0yhIlIXQLSc8DOT9o00QtCiN6fYhhxZ9UEg8ZgWCKRdVZ7PXCum9QATvU+T6W9tnHI9eXhuCMUlBU6TeIFhvPkfGkdNREAoY0D67cSw+NdkWnI7Z/jpNGAToVbq6LynxyNnHhcnH1wS1v1eZmKUcSy+CdVg52Mw8gdaJuGSAYCxq8hED8rvJQlpi79t3vHlWEJ4fs2TdDolLfCyBoibHjwDjUm2MQMq48ZAMk6/1poIW9p0EeyFQmYO6fAlNxV3nbpG/sL5pM/nhdpCW/WrNDdH1Zr+92P+enkuZX0n85OQo7xJy/Wv0A8m9FXPtwndsD2LC2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_protection() applies vma->vm_page_prot, which lacks the write bit
for CoW and write-notified mappings, so it write-protects every entry
in them. When an entry would simply be made writable on fault without
further checks (e.g. dirty PTEs in shared mappings, exclusive anonymous
pages), MM_CP_TRY_CHANGE_WRITABLE makes the entry writable again to
avoid the future fault.

However, writable entries in shared mappings that are not dirty still
become read-only. For example, a uffd-wp unprotect makes clean shmem
PTEs read-only even if they were never write-protected, e.g. when they
were mapped by a read fault before uffd-wp was registered. The next
write to each of them causes a fault that only restores the write bit.

Now that MM_CP_PERM_UPGRADE indicates whether mprotect() only adds
permissions, change_protection() can tell, together with the
userfaultfd unprotect flags, when a change revokes no access. Keep
writable entries writable in these cases, at the PTE, PMD and PUD
levels. This is consistent with the write fault handler, as an entry
that is already writable needs no write fault.

Signed-off-by: Carlos López <clopez@suse.de>
---
 mm/huge_memory.c | 7 +++++++
 mm/internal.h    | 7 +++++++
 mm/mprotect.c    | 4 ++++
 3 files changed, 18 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 506e1e61c0fd..6e23d0e4ae66 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2809,6 +2809,10 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (userfaultfd_rwp(vma) && pmd_uffd(entry))
 		entry = pmd_modify(entry, PAGE_NONE);
 
+	/* See change_present_ptes(). */
+	if (mm_cp_is_perm_upgrade(cp_flags) && pmd_write(oldpmd))
+		entry = pmd_mkwrite(entry, vma);
+
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pmd_write(entry) &&
 	    can_change_pmd_writable(vma, addr, entry))
@@ -2885,6 +2889,9 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	oldpud = pudp_invalidate(vma, addr, pudp);
 	entry = pud_modify(oldpud, newprot);
+	/* See change_present_ptes(). */
+	if (mm_cp_is_perm_upgrade(cp_flags) && pud_write(oldpud))
+		entry = pud_mkwrite(entry);
 	/* See change_pte_range(). */
 	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pud_write(entry) &&
 	    can_change_pud_writable(vma, addr, entry))
diff --git a/mm/internal.h b/mm/internal.h
index 566cbd2dce48..a1a66f3b4b9c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1423,6 +1423,13 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 	return vma_soft_dirty_enabled(vma) && !pte_soft_dirty(pte);
 }
 
+/* Whether a change_protection() only adds permissions. */
+static inline bool mm_cp_is_perm_upgrade(unsigned long cp_flags)
+{
+	return cp_flags & (MM_CP_PERM_UPGRADE | MM_CP_UFFD_WP_RESOLVE |
+			   MM_CP_UFFD_RWP_RESOLVE);
+}
+
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			  int priority);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 683131c9c4a0..16b8aef755ab 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -306,6 +306,10 @@ static __always_inline void change_present_ptes(struct mmu_gather *tlb,
 	if (userfaultfd_rwp(vma) && pte_uffd(ptent))
 		ptent = pte_modify(ptent, PAGE_NONE);
 
+	/* A permission upgrade keeps writable entries writable. */
+	if (mm_cp_is_perm_upgrade(cp_flags) && pte_write(oldpte))
+		ptent = pte_mkwrite(ptent, vma);
+
 	/*
 	 * In some writable, shared mappings, we might want
 	 * to catch actual write access -- see
-- 
2.51.0


