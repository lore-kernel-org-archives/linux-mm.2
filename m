Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07101CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1734E6B0088; Mon, 25 May 2026 12:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143AC6B0093; Mon, 25 May 2026 12:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB12F6B008A; Mon, 25 May 2026 12:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDF6B6B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:55:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 857A91C007D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:48 +0000 (UTC)
X-FDA: 84806543976.08.53B4449
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 978E812000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:55:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779728146; a=rsa-sha256;
	cv=none;
	b=4EJjduZDD1HlEyvUfjQZhNpC6XEtOXfaxzM2hIuKQnAxdKR3HFA4VG4F5vXGJckmOHrW5w
	CSZXjHG/XbnInMt+8Z9+hlG0y5sr0HfNmw3+SA2Cvee5mIZHOF0NRlKKpFc9uIqDAsSblL
	rXBKBxCiwqo8IiDjCTgDvN4PBZVHm04=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779728146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rrX2Vzu2h/keaYYnkeUYmjj4fiMJARP9DAjM3pCmBgI=;
	b=eWMHX9OcWPAlYDJJyGnJlvRanswvXq7RznTJek7diYRKp07Ir5XkPctD4MyHYF74Vfg150
	5SKPojaUjzuOx8WpP1HS3AgEg5e0EDA1drIl/ExPKg3E5qbNaNI7T24lwqTWSEq3IKqJw9
	UjXk11jLXc/MOIHrXQ6c9pugJOhR8GQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C5B0758DB;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14F9D59D4D;
	Mon, 25 May 2026 16:55:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YCzkAhF/FGrlRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 25 May 2026 16:55:45 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
Date: Mon, 25 May 2026 18:55:21 +0200
Message-ID: <20260525165528.184397-2-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525165528.184397-1-osalvador@suse.de>
References: <20260525165528.184397-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 978E812000D
X-Rspamd-Server: rspam03
X-Stat-Signature: zotcm4xiyy8s8y4xay75zowwxa47y8z3
X-HE-Tag: 1779728146-139727
X-HE-Meta: U2FsdGVkX1+sieqBF88lDTvm+8isChQTZZJAHLXI3oHjvozJQ14CEsdnw81c8OJjnQMU5OIQSd0bAbHUL6DHfUtHXzCMlBfxx8TPQEBEqXCJ41C8glDig1vhbaRWtnLk2MG80aeS+cp2OES7rEOPqfOvmuKF18aWZzCCrOc/kNM1dNIH92A6iKbSLWgkr9kKfu84XFsN9S6CLOa/VF51BhkbTIEeqXmoDZ+z2vVorOSi2noFxxZTNYl1ORrYQ+Rzex4uwSCKfjw99WARi8BjF8Mehb1w9nwyPQ9sKjr0MfR5XHMTsyMEYoogq/dvvKLY+2lA/TN9PUjKpxT22/ezoUOtemJZtRSoQN9Ez3f9MWXg5f54lTzu44oARuh8gl+YK8bVdY+cL8sK5nyr2UTXmEYL8AUOanv8JZw6D7EEgGDlN0CtNgT04HK39jlgAc3+QaFr60Qu3+pp14tUNRA+IQaiN57rGLjDCiJz4gumsBXm1QoUeWw5WDrP2G3iU/xeGK82MAIJj9jVLWc09/CV7hu9LO3BMq2Pm4Qky893uykfiQ8//lpD7jk51aat0yAZPN+217JwCm2lu4zUBKyMjsHvZTPTiULHs7kES6kCEsK/KfudbmoMLQbJDXINCiB6q8iStACDXwqiYUgs3nJHrnwTObLY3GMxdjcJuSvhPAmbuvKcb32SLX2nxH4o3XPHSItyL5WjQdlZyyoDP3MJitKQFsXmgA2JM4JvI57zjZzG8ffyDXuVyE31wYWawuBCriHl8tos9zw+LuODrJoVkluEjEyoPJaXOm/OSRZh5kDvtX/1zhk53qVy8fKLi4s2DXu1UqbRs8M35x438uLvaljEyUK2oDodG42pcmxTcJUfv6MdpKtKs3ufxlkjKvTuXWcj1Ue7JnqpabJ80FkwQkIfhTKBKHR738cRvOpwfvgwrsp/sv+QFkP5VxP5KNMMABq3HFhYggpE8glLbYN
 00GM3Pim
 IbBTZzgyxbacGqFt8vBdpvdo7e7W+GodpY/zmsOOgqgsk6EI/av07A7HxXJGq/rSXbkCo06Er/fj/mqpepIYn/sVj76xKAV05okDP11tLneqNoGDIDgKGo1sDr4oJ+14o6qivQt6phvqxWBjJs9XsIF6GnPhBUJDAQuvTgD8bmDXGcL8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to be able to operate on HugeTLB pages as we do with normal
pages, which means stop pretending everyting is a pte in HugeTLB world
and be able to operate on the right entry level.

Since we can have HugeTLB as PUD entries, we need the infrastructure that
allows us to operate on them, so add softleaf_from_pud(), and the
infrastructure that comes with it.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/arm64/include/asm/pgtable.h             | 12 +++++
 arch/loongarch/include/asm/pgtable.h         |  1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++
 arch/s390/include/asm/pgtable.h              | 38 ++++++++++++++++
 arch/x86/include/asm/pgtable.h               | 48 ++++++++++++++++++++
 arch/x86/include/asm/pgtable_64.h            |  2 +
 include/asm-generic/pgtable_uffd.h           | 15 ++++++
 include/linux/leafops.h                      | 33 ++++++++++++++
 include/linux/pgtable.h                      | 37 +++++++++++++++
 9 files changed, 193 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4dfa42b7d053..ca0f1fcae7e8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -593,6 +593,13 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_mkvalid_k(pmd)	pte_pmd(pte_mkvalid_k(pmd_pte(pmd)))
 #define pmd_mkinvalid(pmd)	pte_pmd(pte_mkinvalid(pmd_pte(pmd)))
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+#define pud_uffd_wp(pud)	pte_uffd_wp(pud_pte(pud))
+#define pud_mkuffd_wp(pud)	pte_pud(pte_mkuffd_wp(pud_pte(pud)))
+#define pud_clear_uffd_wp(pud)	pte_pud(pte_clear_uffd_wp(pud_pte(pud)))
+#define pud_swp_uffd_wp(pud)	pte_swp_uffd_wp(pud_pte(pud))
+#define pud_swp_mkuffd_wp(pud)	pte_pud(pte_swp_mkuffd_wp(pud_pte(pud)))
+#define pud_swp_clear_uffd_wp(pud) \
+				pte_pud(pte_swp_clear_uffd_wp(pud_pte(pud)))
 #define pmd_uffd_wp(pmd)	pte_uffd_wp(pmd_pte(pmd))
 #define pmd_mkuffd_wp(pmd)	pte_pmd(pte_mkuffd_wp(pmd_pte(pmd)))
 #define pmd_clear_uffd_wp(pmd)	pte_pmd(pte_clear_uffd_wp(pmd_pte(pmd)))
@@ -1539,6 +1546,11 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 #define __swp_entry_to_pmd(swp)		__pmd((swp).val)
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
+#ifdef CONFIG_HUGETLB_PAGE
+#define __pud_to_swp_entry(pud)         ((swp_entry_t) { pud_val(pud) })
+#define __swp_entry_to_pud(swp)         __pud((swp).val)
+#endif
+
 /*
  * Ensure that there are not more swap files than can be encoded in the kernel
  * PTEs.
diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 2a0b63ae421f..dc6d841ea269 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -339,6 +339,7 @@ static inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 #define __swp_entry_to_pmd(x)	__pmd((x).val | _PAGE_HUGE)
 #define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
+#define __pud_to_swp_entry(pud) ((swp_entry_t) { pud_val(pud) })
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index e67e64ac6e8c..fb43e7cc09b6 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1065,6 +1065,13 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #define pmd_swp_soft_dirty(pmd)		pte_swp_soft_dirty(pmd_pte(pmd))
 #define pmd_swp_clear_soft_dirty(pmd)	pte_pmd(pte_swp_clear_soft_dirty(pmd_pte(pmd)))
 #endif
+
+#ifdef CONFIG_HUGETLB_PAGE
+#define pud_swp_mksoft_dirty(pud)	pte_pud(pte_swp_mksoft_dirty(pud_pte(pud)))
+#define pud_swp_soft_dirty(pud)		pte_swp_soft_dirty(pud_pte(pud))
+#define pud_swp_clear_soft_dirty(pud)	pte_pud(pte_swp_clear_soft_dirty(pud_pte(pud)))
+#endif
+
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2c6cee8241e0..c0ebf827fdb0 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -903,11 +903,31 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 	return clear_pmd_bit(pmd, __pgprot(_SEGMENT_ENTRY_SOFT_DIRTY));
 }
 
+static inline int pud_soft_dirty(pud_t pud)
+{
+	return pud_val(pud) & _REGION3_ENTRY_SOFT_DIRTY;
+}
+
+static inline pud_t pud_mksoft_dirty(pud_t pud)
+{
+	return set_pud_bit(pud, __pgprot(_REGION3_ENTRY_SOFT_DIRTY));
+}
+
+static inline pud_t pud_clear_soft_dirty(pud_t pud)
+{
+	return clear_pud_bit(pud, __pgprot(_REGION3_ENTRY_SOFT_DIRTY));
+}
+
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
 #endif
+#ifdef CONFIG_HUGETLB_PAGE
+#define pud_swp_soft_dirty(pud)		pud_soft_dirty(pud)
+#define pud_swp_mksoft_dirty(pud)	pud_mksoft_dirty(pud)
+#define pud_swp_clear_soft_dirty(pud)	pud_clear_soft_dirty(pud)
+#endif
 
 /*
  * query functions pte_write/pte_dirty/pte_young only work if
@@ -1947,6 +1967,24 @@ static inline unsigned long __swp_offset_rste(swp_entry_t entry)
  * requires conversion of the swap type and offset, and not all the possible
  * PTE bits.
  */
+static inline swp_entry_t __pud_to_swp_entry(pud_t pud)
+{
+	swp_entry_t arch_entry;
+	pte_t pte;
+
+	arch_entry = __rste_to_swp_entry(pud_val(pud));
+	pte = mk_swap_pte(__swp_type_rste(arch_entry), __swp_offset_rste(arch_entry));
+	return __pte_to_swp_entry(pte);
+}
+
+static inline pud_t __swp_entry_to_pud(swp_entry_t arch_entry)
+{
+	pud_t pud;
+
+	pud = __pud(mk_swap_rste(__swp_type(arch_entry), __swp_offset(arch_entry)));
+	return pud;
+}
+
 static inline swp_entry_t __pmd_to_swp_entry(pmd_t pmd)
 {
 	swp_entry_t arch_entry;
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2187e9cfcefa..a3cf289948a0 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -648,6 +648,23 @@ static inline pud_t pud_mkwrite(pud_t pud)
 	return pud_clear_saveddirty(pud);
 }
 
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
+static inline int pud_uffd_wp(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_UFFD_WP;
+}
+
+static inline pud_t pud_mkuffd_wp(pud_t pud)
+{
+	return pud_wrprotect(pud_set_flags(pud, _PAGE_UFFD_WP));
+}
+
+static inline pud_t pud_clear_uffd_wp(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_UFFD_WP);
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline int pte_soft_dirty(pte_t pte)
 {
@@ -1549,6 +1566,22 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 	return pmd_clear_flags(pmd, _PAGE_SWP_SOFT_DIRTY);
 }
 #endif
+#ifdef CONFIG_HUGETLB_PAGE
+static inline pud_t pud_swp_mksoft_dirty(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_SWP_SOFT_DIRTY);
+}
+
+static inline int pud_swp_soft_dirty(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_SWP_SOFT_DIRTY;
+}
+
+static inline pud_t pud_swp_clear_soft_dirty(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_SWP_SOFT_DIRTY);
+}
+#endif
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_WP
@@ -1581,6 +1614,21 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 {
 	return pmd_clear_flags(pmd, _PAGE_SWP_UFFD_WP);
 }
+
+static inline pud_t pud_swp_mkuffd_wp(pud_t pud)
+{
+	return pud_set_flags(pud, _PAGE_SWP_UFFD_WP);
+}
+
+static inline int pud_swp_uffd_wp(pud_t pud)
+{
+	return pud_flags(pud) & _PAGE_SWP_UFFD_WP;
+}
+
+static inline pud_t pud_swp_clear_uffd_wp(pud_t pud)
+{
+	return pud_clear_flags(pud, _PAGE_SWP_UFFD_WP);
+}
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 static inline u16 pte_flags_pkey(unsigned long pte_flags)
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index ce45882ccd07..0709dee52813 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -234,8 +234,10 @@ static inline void native_pgd_clear(pgd_t *pgd)
 
 #define __pte_to_swp_entry(pte)		((swp_entry_t) { pte_val((pte)) })
 #define __pmd_to_swp_entry(pmd)		((swp_entry_t) { pmd_val((pmd)) })
+#define __pud_to_swp_entry(pud)		((swp_entry_t) { pud_val((pud)) })
 #define __swp_entry_to_pte(x)		(__pte((x).val))
 #define __swp_entry_to_pmd(x)		(__pmd((x).val))
+#define __swp_entry_to_pud(x)		(__pud((x).val))
 
 extern void cleanup_highmap(void);
 
diff --git a/include/asm-generic/pgtable_uffd.h b/include/asm-generic/pgtable_uffd.h
index 0d85791efdf7..59c9d6762ec8 100644
--- a/include/asm-generic/pgtable_uffd.h
+++ b/include/asm-generic/pgtable_uffd.h
@@ -78,6 +78,21 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
 {
 	return pmd;
 }
+
+static inline pud_t pud_swp_mkuffd_wp(pud_t pud)
+{
+	return pud;
+}
+
+static inline int pud_swp_uffd_wp(pud_t pud)
+{
+	return 0;
+}
+
+static inline pud_t pud_swp_clear_uffd_wp(pud_t pud)
+{
+	return pud;
+}
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
 #endif /* _ASM_GENERIC_PGTABLE_UFFD_H */
diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 992cd8bd8ed0..08646398b0fe 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -117,6 +117,39 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 
 #endif
 
+#ifdef CONFIG_HUGETLB_PAGE
+/**
+ * softleaf_from_pud() - Obtain a leaf entry from a PUD entry.
+ * @pud: PUD entry.
+ *
+ * If @pud is present (therefore not a leaf entry) the function returns an empty
+ * leaf entry. Otherwise, it returns a leaf entry.
+ *
+ * Returns: Leaf entry.
+ */
+static inline softleaf_t softleaf_from_pud(pud_t pud)
+{
+	softleaf_t arch_entry;
+
+	if (pud_present(pud) || pud_none(pud))
+		return softleaf_mk_none();
+
+	if (pud_swp_soft_dirty(pud))
+		pud = pud_swp_clear_soft_dirty(pud);
+	if (pud_swp_uffd_wp(pud))
+		pud = pud_swp_clear_uffd_wp(pud);
+	arch_entry = __pud_to_swp_entry(pud);
+
+	/* Temporary until swp_entry_t eliminated. */
+	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
+}
+#else
+static inline softleaf_t softleaf_from_pud(pud_t pud)
+{
+	return softleaf_mk_none();
+}
+#endif
+
 /**
  * softleaf_is_none() - Is the leaf entry empty?
  * @entry: Leaf entry.
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..70aae957be5b 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1797,6 +1797,22 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 	return pmd;
 }
 #endif
+#ifndef CONFIG_HUGETLB_PAGE
+static inline pud_t pud_swp_mksoft_dirty(pud_t pud)
+{
+	return pud;
+}
+
+static inline int pud_swp_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
+static inline pud_t pud_swp_clear_soft_dirty(pud_t pud)
+{
+	return pud;
+}
+#endif
 #else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
 static inline int pte_soft_dirty(pte_t pte)
 {
@@ -1857,6 +1873,21 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 {
 	return pmd;
 }
+
+static inline pud_t pud_swp_mksoft_dirty(pud_t pud)
+{
+	return pud;
+}
+
+static inline int pud_swp_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
+static inline pud_t pud_swp_clear_soft_dirty(pud_t pud)
+{
+	return pud;
+}
 #endif
 
 #ifndef __HAVE_PFNMAP_TRACKING
@@ -2420,4 +2451,10 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)				\
 }									\
 EXPORT_SYMBOL(vm_get_page_prot);
 
+#ifdef CONFIG_HUGETLB_PAGE
+#ifndef __pud_to_swp_entry
+#define __pud_to_swp_entry(pud) ((swp_entry_t) { pud_val(pud) })
+#endif
+#endif
+
 #endif /* _LINUX_PGTABLE_H */
-- 
2.53.0


