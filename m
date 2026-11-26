Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E83606A685
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4KjeMfo
Received: by kanga.kvack.org (Postfix)
	id C04C16B061B; Thu, 26 Nov 2026 06:23:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5F76B061C; Thu, 26 Nov 2026 06:23:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBC56B061D; Thu, 26 Nov 2026 06:23:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6836B061B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:23:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 041D1120EA6
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:23:09 +0000 (UTC)
X-FDA: 85477033740.01.9470245
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 530021C0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:23:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4KjeMfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692188;
	b=BaUuInAR3eOMiTQT8nn22o6GPA2f4oaIFB4+sw1wMJpI77ghF0jX5rHzwXKF6ziNkArEYn
	RK6OO8Lu90vwg25gheF96joODROYLciyW6rq1f5tE5tUh2DdZeB7FssX63DM7Jx+nJC/a9
	9KSFZcJQxTWZHBEA3ARDmQ+LQ8Lpbcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38wWX1LyIKznTPHkYokKRmEmCsvcuuigVsBb/B7K/pw=;
	b=Fmcwks2bGXD28z2J6Lepj944zZd1oasRKUKdZR5e6En0otADFGpMvf6K5FHWBu5npyEhlE
	9t2fbnOehNW0abeCR/+6PFusOEsoGzY0fh8NS+rH1/QimU0PW6evKMZdzTxrxziWzNwY3I
	QFENRrvG72Mc0ahTTxu8oxFLWPI6T+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4KjeMfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF9A8633DF;
	Thu, 26 Nov 2026 11:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09751F000C0;
	Thu, 26 Nov 2026 11:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692187;
	bh=38wWX1LyIKznTPHkYokKRmEmCsvcuuigVsBb/B7K/pw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=A4KjeMfoFY32iUGl7djJYsYhg+4oGEfOWaNVWfXQNOGKm+R1SPziMoo0T9FUVkVaW
	 fFPfLoak3gHxi7lTuPxjivNEphPTx7KKaNtLd/glp6KWXq9U7U4qORKSWyTbc301zU
	 QPG+YUnZEwXXdBShtqAnt187iKv9LR1F1fduwTYjEWQoiA+2+8szyjKHTBeNdXXICj
	 9qyzELenHf2+tAdoGIGFgFVnzYUb4UVoGsIi62b51EavLCULalPcIj7jrDHDG+x43Q
	 gkYuip9wepznQuxkzTfW2ST+wos48VEZjTRE7/DisSCsxr/tUvQ+SUb8aqIinLqY07
	 wTEdBi2jVHpOQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:15:07 +0200
Subject: [PATCH RFC v2 54/54] mm/pageattr: document CPA core and the
 architecture hooks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-54-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: jrddbb6joy8mczt8womrsru6bix4rs66
X-Rspamd-Queue-Id: 530021C0009
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795692188-880571
X-HE-Meta: U2FsdGVkX19Bc1zy58uslOQkRDFKcC2qQxiDq1mIUgyt8aR0XRpKIBkwK3ogarpdsuIXh0bkBcGB9EYDfA16WodkTL0HWcYyn2GHCefxtXohaXA4jqKJBg8zErqdJuvNCLcxFq6FKVUL3AX7zLEZGULe31cz9QZP/EgnHsWy3VJysype6LsB+z0HV+JRAeNfJgEqg8MucFykAN9YpYff6t8N/0Ip5hFahgC1kXdtkQkMG6oFgfbOTC9v0+hbpNyVAn0IPsgDNIoPdZpYZ8CSE/kPYp4jX64Up4S8KNciJHkAFIm7t35g72mCLg87/088uVXEw1QnOIW/n2ZI4NL1/AkVAUu8T1UZktl6JwdHiaNSRtynUfUBnj4+aHFFpUehEnskaK78ldg43Hc9/Mv6/eNqzFNmz4rvNDmo72mN8nhZTwU/2Ra/vSXF+D/BF1UhLz1sCksz2a+24Bxsb47il0xBoIc8nLLCMlhwPH6yvjTZ3nIMB77KZQ4Qq/8ZXvDkPdxOY37tA5Jwps8oVZRomXNIOzTNFnmH9MvE9uw2v0mjPUgBvnpaSHn3eZmde/b9oSIhBxs9drqZVWwrKb6c/G0A/gcCfvpqCdsNwXUT3VfRCMyfbx+Ywz0+1iukeD5RsFdaisa5UXaKv8Rvmc7wWmIzNspe3tP+X1uGFqayKo4vY5o6gjyDK5IrvtrzkGKf3SpKCdaK+swp+x97qimN+R/++7XeE+8AwF9oyEUnE0bY4tEgu9v/UvxPTMHeWTVV6KKrYSpCIFn4KDzZM2u0ixRZBrA/Ao9Epu4oHaMAhBC3TgLomnwDSIbMFtIgUIMXWwOWaNaa07EI8ap0YY8AiCaXTIa+Zzxjxumxr1h3hVU4OCj4YT+YSYZE4WhYK9Km/sPJC4iTOB+IKyXgzBS7CKNu9tzTYEYKJ0SiMBVAQ9ykQVmyM4pnIfP/huqtOp3IpN5llQc8iyzInYmwdW4
 vXDYgxE2
 qTS07EvM55r/wNLPFIpRh1m8BadbciFSpTm3rIVvUpT3LvtmD3WkiOW+AiTyQ9a0VtSlaa7+q1L85pUlE2DYqWFxB92mrWO4xVgF0PIbrT+UKVLlFTb2z8Lcrz4rV6I2MLpwsKpHDoQqPex0tjJf56GTgDqZtKibESAh2EYkrdNRlIefT40PxfA2u56D03z1Jao7LESPR4p5ZwHspFeT+ETINOQbqi/WpTBRDlVupRvkKXydW8BesXzX6izGPiDNzHfEZj3xcs207pJQfCyYzgDBk7fZLPLYL3eUN3NQgeYrcSBatBAzR3RtWpJaG1e6xocKIWLW8kI4z1Hhmy+B0ZS+t+betYjW3U7yQmpPbwX1544jLXxcNgU4bRYhGs6804fzK+QTAPs7kQ+sX6FNuLMq53qwuC27okRmBNuPqEQFQwXyQkx5YkEqoDLWduyKZMJ66S3mI3Z8VGbQ/lZJoNSw0vDTZG7wP306e0l9x98yw44GQaOop6cKsSEdOf2RtiTckqDQM4RLp1iwlpFQqPzyFT0lCiSG9v0L61wco8cRTUds=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add kernel-doc for the API and the hooks in include/linux/pageattr.h.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/pageattr.h | 277 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 275 insertions(+), 2 deletions(-)

diff --git a/include/linux/pageattr.h b/include/linux/pageattr.h
index a2a7235a633e..855c65295f6e 100644
--- a/include/linux/pageattr.h
+++ b/include/linux/pageattr.h
@@ -5,10 +5,69 @@
 #include <linux/mm.h>
 #include <linux/pgtable.h>
 
+/**
+ * DOC: Kernel Page Table Protection Modifications
+ *
+ * There are two families of APIs that allow modifying the protection of the
+ * kernel mappings:
+ *
+ * set_memory_*() change the protection of an arbitrary kernel mapping.
+ *
+ * set_direct_map_*() change the protection of the direct/identity/linear
+ * mapping.
+ *
+ * change_page_attr() and change_page_attr_noflush(), or CPA for short,
+ * implement the generic part of these APIs and leave the page table
+ * specifics to the architecture.
+ *
+ * CPA walks the kernel page tables, determines at what level the
+ * protection change must be done, splits large mappings if necessary and
+ * updates the protection of the requested range.
+ *
+ * CPA keeps the mappings as large as it can. A large page stays intact
+ * when a request changes all of it the same way, and is split only when a
+ * request changes a part of it.
+ *
+ * The same holds for a contiguous block of entries that the TLB may cache as
+ * one translation, like, for example, the contiguous bit of arm64.
+ *
+ * CPA keeps the alias mappings of the memory consistent: when the protection
+ * of a page changes, its other mappings, like the direct map, change with it
+ * according to architecture requirements.
+ *
+ * Every step of a request looks up and changes the page tables under
+ * cpa_lock. It keeps concurrent requests from splitting or changing the same
+ * large mapping at the same time, and a collapse, which holds it as well,
+ * from freeing page tables under a CPA lookup. A step drops cpa_lock to
+ * allocate a page table for a split and repeats the lookup after retaking the
+ * lock.
+ *
+ * Page table walkers that don't take cpa_lock, like ptdump and text poking,
+ * rely on the init_mm mmap lock instead. A collapse frees page tables, so it
+ * holds that lock for writing.
+ *
+ * The architecture describes its page tables with the hooks below: the format
+ * of a page table entry, how a large page is split and whether it can be split
+ * at all, which mappings are aliases and how the TLB is flushed.
+ *
+ * The hooks that have a default are optional.
+ */
+
 struct seq_file;
 
-/*
- * The current flushing context - we pass it instead of 5 arguments:
+/**
+ * struct cpa_data - a request to change the protection of kernel mappings
+ * @addr: the virtual address of the first page
+ * @pgd: the page tables to change, NULL for init_mm
+ * @mask_set: the protection bits to set, in the architecture's PTE format
+ * @mask_clr: the protection bits to clear, in the architecture's PTE format
+ * @numpages: the number of pages; while the walk runs, the number of pages
+ *	of the current step
+ * @curpage: the index of the first page of the current step
+ * @pfn: the pfn of the first page of the current step; for an architecture
+ *	that populates holes, the caller sets it to the first pfn to map
+ * @flags: CPA_REQ_* request flags set by the caller
+ * @state: CPA_ST_* state flags set by change_page_attr()
  */
 struct cpa_data {
 	unsigned long	addr;
@@ -22,6 +81,18 @@ struct cpa_data {
 	unsigned int	state;
 };
 
+/**
+ * struct cpa_leaf - a mapping found by the lookup
+ * @kpte: the page table entry corresponding to @addr or the first entry in a
+ *	contiguous block
+ * @level: the level at which the lookup found the mapping
+ * @addr: the first virtual address of the mapping
+ * @size: the size of the mapping: the size of @level, or of the contiguous
+ *	block
+ * @pfn: the first pfn of the mapping
+ * @prot: the protection of the mapping in the architecture's PTE format, as
+ *	decoded by arch_cpa_decode_leaf()
+ */
 struct cpa_leaf {
 	pte_t			*kpte;
 	enum pgtable_level	level;
@@ -63,14 +134,46 @@ static inline unsigned long cpa_addr(struct cpa_data *cpa, unsigned long idx)
 	return cpa->addr + idx * PAGE_SIZE;
 }
 
+/* Helpers for the hooks */
 int cpa_process_fault(struct cpa_data *cpa);
 int cpa_change_alias(struct cpa_data *cpa, struct cpa_data *alias);
 void cpa_flush_tlb_kernel_range(struct cpa_data *cpa);
 
+/**
+ * change_page_attr() - change the protection of kernel mappings and flush the
+ *	TLB
+ * @cpa: the request
+ *
+ * Unmaps the unused kmap and the lazily freed vmap aliases first, as they
+ * may map the pages with the old protection. With CPA_REQ_COLLAPSE, also
+ * collapses large pages after the flush.
+ *
+ * On failure, the pages processed before it keep their new protection, and
+ * arch_cpa_flush() is called with CPA_ST_FLUSH_ALL if any of them changed.
+ *
+ * Context: May sleep.
+ * Return: 0 on success, -errno on failure.
+ */
 int change_page_attr(struct cpa_data *cpa);
 
+/**
+ * change_page_attr_noflush() - change the protection of kernel mappings
+ * @cpa: the request
+ *
+ * Unlike change_page_attr(), it doesn't unmap the kmap and vmap aliases of
+ * the pages, and the caller is responsible for flushing the TLB.
+ *
+ * Context: May sleep to allocate a page table for a split.
+ * Return: 0 on success, -errno on failure.
+ */
 int change_page_attr_noflush(struct cpa_data *cpa);
 
+/*
+ * The direct map counters behind the DirectMap lines of /proc/meminfo.
+ * change_page_attr() counts the large pages of the direct map it splits,
+ * and the architecture counts every other change of its direct map. The
+ * architecture prints the counters with cpa_report_meminfo().
+ */
 #ifdef CONFIG_PROC_FS
 void direct_map_count_update(enum pgtable_level level, long pages);
 void direct_map_count_split(enum pgtable_level level);
@@ -83,12 +186,60 @@ static inline void direct_map_count_split(enum pgtable_level level) { }
 static inline void direct_map_count_collapse(enum pgtable_level level) { }
 #endif
 
+/**
+ * arch_cpa_decode_leaf() - decode a page table entry
+ * @leaf: the mapping to decode
+ *
+ * Fill @leaf->pfn and @leaf->prot from the entry @leaf->kpte at @leaf->level.
+ * If the entry is a part of a contiguous block, extend @leaf to the block.
+ *
+ * @leaf->prot has the same format at every level: the PTE format, without
+ * the pfn and without the bits that tell a large entry from a small one.
+ * arch_cpa_modify_leaf() converts it back. The entry may be not present,
+ * but it is never empty.
+ *
+ * Context: cpa_lock held, must not sleep.
+ */
 void arch_cpa_decode_leaf(struct cpa_leaf *leaf);
 
+/**
+ * arch_cpa_modify_leaf() - change the protection of a mapping
+ * @leaf: the mapping to change
+ * @prot: the new protection
+ *
+ * Store the entry of @leaf, or every entry of its contiguous block, with
+ * @prot. The TLB is flushed after the walk, by arch_cpa_flush() or by the
+ * caller of change_page_attr_noflush().
+ * An architecture whose TLB may cache an entry that is not valid handles an
+ * entry that becomes valid here.
+ *
+ * Context: cpa_lock held, must not sleep.
+ */
 void arch_cpa_modify_leaf(struct cpa_leaf *leaf, pgprot_t prot);
 
+/**
+ * arch_cpa_flush() - flush the TLB for the pages of a request
+ * @cpa: the request
+ *
+ * CPA_ST_FLUSH_ALL in @cpa->state means an alias of the pages changed as
+ * well, or the request failed.
+ * An architecture without aliases, one that flushes the aliases in
+ * arch_cpa_process_alias(), or one whose page table updates flush the TLB by
+ * themselves may ignore it.
+ */
 void arch_cpa_flush(struct cpa_data *cpa);
 
+/**
+ * arch_cpa_new_prot() - adjust the protections calculated in cpa_req_prot()
+ * with architecture constraints
+ * @cpa: the request
+ * @leaf: the mapping to change
+ *
+ * A large page is split when the result differs from cpa_req_prot().
+ *
+ * Context: cpa_lock held, must not sleep.
+ * Return: the new protection of @leaf.
+ */
 #ifndef arch_cpa_new_prot
 static inline pgprot_t arch_cpa_new_prot(struct cpa_data *cpa,
 					 struct cpa_leaf *leaf)
@@ -98,12 +249,42 @@ static inline pgprot_t arch_cpa_new_prot(struct cpa_data *cpa,
 #endif
 
 #ifndef arch_cpa_can_split
+/**
+ * arch_cpa_can_split() - check if a large page can be split
+ * @cpa: the request
+ * @leaf: the large page
+ *
+ * Refuse a split before a page table is allocated for it. A request that
+ * needs a split the architecture cannot do fails with a warning and
+ * -EINVAL. The default refuses every split.
+ *
+ * An architecture must override both arch_cpa_can_split() and
+ * arch_cpa_split_leaf() or none.
+ *
+ * Context: cpa_lock held, must not sleep.
+ * Return: true if arch_cpa_split_leaf() can split @leaf.
+ */
 static inline bool arch_cpa_can_split(struct cpa_data *cpa,
 				      struct cpa_leaf *leaf)
 {
 	return false;
 }
 
+/**
+ * arch_cpa_split_leaf() - split a large page
+ * @cpa: the request
+ * @leaf: the large page
+ * @table: the page table page from arch_cpa_alloc_pgtable(), NULL for a
+ *	contiguous block
+ *
+ * Replace @leaf with @table, filled with entries that map the same memory
+ * with the same protection. A contiguous block is split by making each of
+ * its entries a mapping of its own.
+ * In both cases, do the TLB maintenance the CPU requires for the change.
+ *
+ * Context: cpa_lock held, must not sleep.
+ * Return: 0 on success, -errno on failure.
+ */
 static inline int arch_cpa_split_leaf(struct cpa_data *cpa,
 				      struct cpa_leaf *leaf, void *table)
 {
@@ -112,11 +293,35 @@ static inline int arch_cpa_split_leaf(struct cpa_data *cpa,
 #endif
 
 #ifndef arch_cpa_alloc_pgtable
+/**
+ * arch_cpa_alloc_pgtable() - allocate the page table for a split
+ * @leaf: the large page to split
+ *
+ * An architecture must override both arch_cpa_alloc_pgtable() and
+ * arch_cpa_free_pgtable() or none.
+ *
+ * Context: May sleep.
+ * Return: the page table, NULL on failure.
+ */
 void *arch_cpa_alloc_pgtable(struct cpa_leaf *leaf);
 
+/**
+ * arch_cpa_free_pgtable() - free a page table from arch_cpa_alloc_pgtable()
+ * @leaf: the large page the table was allocated for
+ * @table: the page table
+ *
+ * Context: cpa_lock held, must not sleep.
+ */
 void arch_cpa_free_pgtable(struct cpa_leaf *leaf, void *table);
 #endif
 
+/**
+ * cpa_is_direct_map() - check if an address is in the direct map
+ * @addr: the virtual address
+ *
+ * Return: true if @addr is in the range of the direct map, which may have
+ * holes.
+ */
 #ifndef cpa_is_direct_map
 static inline bool cpa_is_direct_map(unsigned long addr)
 {
@@ -124,6 +329,22 @@ static inline bool cpa_is_direct_map(unsigned long addr)
 }
 #endif
 
+/**
+ * arch_cpa_process_fault() - handle a page without a mapping
+ * @cpa: the request, its current page has no mapping
+ *
+ * On entry @cpa->numpages is the number of pages left in the request, and
+ * @cpa->pfn is the pfn of the previous step, or the one the caller set. To
+ * skip pages, set @cpa->numpages to their number and return 0. Without
+ * CPA_ST_ALIAS in @cpa->state, also set @cpa->pfn to the pfn of the first
+ * skipped page, which arch_cpa_process_alias() uses next.
+ *
+ * The default skips a page of an alias and a page in a hole of the direct
+ * map, and fails with a warning for any other address.
+ *
+ * Context: cpa_lock held, must not sleep.
+ * Return: 0 to continue the walk, -errno to fail the request.
+ */
 #ifndef arch_cpa_process_fault
 static inline int arch_cpa_process_fault(struct cpa_data *cpa)
 {
@@ -131,6 +352,19 @@ static inline int arch_cpa_process_fault(struct cpa_data *cpa)
 }
 #endif
 
+/**
+ * arch_cpa_process_alias() - change the aliases of the current pages
+ * @cpa: the request
+ *
+ * Change the aliases of the @cpa->numpages pages at @cpa->pfn that the
+ * current step of the walk processed. Each alias is changed with
+ * cpa_change_alias() on a copy of @cpa with the address and the masks of
+ * the alias. cpa_change_alias() sets CPA_ST_FLUSH_ALL in @cpa when the
+ * alias changed; an architecture may flush the alias here instead.
+ *
+ * Context: May sleep to split the large pages of an alias.
+ * Return: 0 on success, -errno on failure.
+ */
 #ifndef arch_cpa_process_alias
 static inline int arch_cpa_process_alias(struct cpa_data *cpa)
 {
@@ -138,12 +372,23 @@ static inline int arch_cpa_process_alias(struct cpa_data *cpa)
 }
 #endif
 
+/**
+ * arch_cpa_collapse() - collapse the large pages of a request
+ * @cpa: the request
+ *
+ * Replace the page tables of the range of a CPA_REQ_COLLAPSE request with
+ * large pages where all their entries map contiguous memory with the same
+ * protection. The TLB is already flushed for the request.
+ *
+ * Context: init_mm write locked, cpa_lock held, must not sleep.
+ */
 #ifndef arch_cpa_collapse
 static inline void arch_cpa_collapse(struct cpa_data *cpa)
 {
 }
 #endif
 
+/* The operations of set_memory_*() and set_direct_map_*_noflush() */
 enum cpa_op {
 	CPA_OP_RO,
 	CPA_OP_RW,
@@ -155,6 +400,12 @@ enum cpa_op {
 	CPA_OP_NR
 };
 
+/**
+ * struct cpa_op_prot - the masks and flags of an operation
+ * @set: the protection bits to set, in the architecture's PTE format
+ * @clr: the protection bits to clear, in the architecture's PTE format
+ * @req: CPA_REQ_* flags of the request
+ */
 struct cpa_op_prot {
 	pgprot_t	set;
 	pgprot_t	clr;
@@ -169,15 +420,37 @@ static inline void cpa_init_op(struct cpa_data *cpa,
 	cpa->flags |= prot->req;
 }
 
+/**
+ * arch_cpa_prepare() - prepare the request of an operation
+ * @cpa: the request with the address and the number of pages
+ * @op: the operation
+ *
+ * Fill the masks and the flags of @cpa for @op, usually with cpa_init_op()
+ * from a table of the operations. A request with empty masks succeeds
+ * without changing anything.
+ *
+ * Return: 0 on success, -errno to refuse the request.
+ */
 int arch_cpa_prepare(struct cpa_data *cpa, enum cpa_op op);
 
 #ifndef arch_cpa_enter
+/**
+ * arch_cpa_enter() - start the request of an operation
+ *
+ * Together with arch_cpa_leave() it brackets the request of set_memory_*() and
+ * set_direct_map_*_noflush(), so that an architecture can batch the page table
+ * updates of the request, for example in lazy MMU mode. The request may sleep.
+ * A direct call of change_page_attr() is not bracketed.
+ */
 static inline void arch_cpa_enter(void)
 {
 }
 #endif
 
 #ifndef arch_cpa_leave
+/**
+ * arch_cpa_leave() - end the request of an operation
+ */
 static inline void arch_cpa_leave(void)
 {
 }

-- 
2.53.0


