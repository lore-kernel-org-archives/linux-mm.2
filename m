Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57030FF885C
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01546B0092; Sun, 26 Apr 2026 08:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB32E6B0093; Sun, 26 Apr 2026 08:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A386B0095; Sun, 26 Apr 2026 08:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98CDD6B0092
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 34C46120178
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:50 +0000 (UTC)
X-FDA: 84700709100.12.CCC05C4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1771EC0008
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xpHiMIVL/n8XlCby+SL6/v4wf5J9N4x6EFwGCFeoXUo=;
	b=ylzjPpv8g4/ylITNgU3rWgu9fbx83/P7lkZ+riYdG5lI8gCcRadYz5EA8jIqmE1vBxty++
	buhuCypmu15t6Z31CgAarumNKQr6qiAGXEY23g7LE0C5okmOCd7gIKkaeaycGg1vLJfqkd
	NVBL6wwOornHVUOhPulZ4adO1hGmdhM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208268; a=rsa-sha256;
	cv=none;
	b=uyqRdHxXijLIi0IezO0pbTflvtTHvR8iFNrAaeAM0HUzlA8bxLS9vFbJJWxUmYExzzm+Cj
	sBOZT3IRJ1Rq7hk+6coOt1ScVKDXmWSRsHF9rRGZ8eFcY6gzD3lnN5FtzdmFXu0bs+iBqF
	QnzeMXLeMNX9Y8nmkHmVhuv4GyKR820=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 279C05BCF7;
	Sun, 26 Apr 2026 12:57:40 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5288593B1;
	Sun, 26 Apr 2026 12:57:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aEETKsML7mmtRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:39 +0000
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
Subject: [RFC PATCH v2 1/7] mm: Add softleaf_from_pud
Date: Sun, 26 Apr 2026 14:57:13 +0200
Message-ID: <20260426125719.24698-2-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260426125719.24698-1-osalvador@suse.de>
References: <20260426125719.24698-1-osalvador@suse.de>
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
X-Rspamd-Queue-Id: 1771EC0008
X-Rspamd-Server: rspam06
X-Stat-Signature: osmzm49hw1tqkdizsmk8rbd96kx6xxg6
X-HE-Tag: 1777208267-865934
X-HE-Meta: U2FsdGVkX19FIKOzOMV774fvWWbzDODyz95o3KS+fhavAglF4V+fBYH+Xb71+ojuqwIznevLOqYT7a2ptW5iZWyxGedZbIQWMpZCE/T9wfYVg/3Vi3Q22A/byCroOg66LBnqVTIRaHC29ynoGSvfyPziLYhJGmyGQ6WcX2RwRJjR0sWF/i6RpmmES26RTMnkGDMprWhE8Ip5jqnT16THTSSpP3NDEPZOmaOGXkbKNf74385m/5rO2VUHtpxmThHMo2YLOykDfpLFRgjKK3IoXciv94+/6TH2xxpG0clHMtUMS+7F6xv8VJAIAzS5fb1xfYY/QfUgR6Zrs5gE3+9JxdpsXD28OaBUsnddb+yKdmDMso+KA95T/9l56nOzgHrtSCebJM++NfWRoTR6IuK62iq87I+KAWZcZnv61cNysZvJ1iHB+xr+lQqNd91GYa3uXPPSPgD6LShnZyA9KucNwl61kdnPIhxgHEavoWBCMnSHfgvc4ABQK+5sxvd7GhfeTuEBzUZf7XDEnskuhHiBE3ESIWXJ0JW7Fdwr4fecFKQVn69L+bEu5vXy02DYIokzYA8WK3UzWQTcxgNljK+XoUW/5QF+znCmJh63kI+6/GZUX9KhMBsE1QjejCYU/EubFQfuU74aXIDJHpqlaEwy9m/elTBRkIfPpQtQl3UcaS6Ci9NL3QHEX3km8huEX/SaGoa2fqlWpGvzf6tNjkOvbcGub2M/fHLOyWGB3QKAZeiuM+gLVQ1fA/bj0E4pocclt2vj8qDCTYJ4cP0pSNYJ7NdRi+ZwJUk9nRuwWQ/VSrQuh4VzcX7BA18mDh+bRShPo5TCMKkNmGkWwsDYg42/6HOzZrTzF4Z2skukbEHC4vuRNPbjJ/dmj+TU9ZmL41dq+u+bwxqZKsrNah8Xu/t617pwPOyNpGmUSQcj64ft0hDdiaaQJZ7BQg6pgMICvfk5oV5nm6Y6kIGYON0xUU1
 Ls4po5nx
 wkVvmazcgPoE5h1xCLYGCFE3xyF3CCz8J9mqk4Lu+t8gffmql17rtoQigoLt+plVI1s/yXHO5XYdD7dZ0dn2OB+EVq6OrQFOSuXgq0aGKvXt/VWf5CxukgNNH/E6kYQBsjavlldmmRX53tgs57PmnLaDNQiCddVW63grgp/LtnIREmq4=
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
index b3e58735c49b..e42ad56a86d4 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -596,6 +596,13 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_mkyoung(pmd)	pte_pmd(pte_mkyoung(pmd_pte(pmd)))
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
@@ -1528,6 +1535,11 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
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
index c33b3bcb733e..eba6d20f007f 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -335,6 +335,7 @@ static inline pte_t mk_swap_pte(unsigned long type, unsigned long offset)
 #define __swp_entry_to_pmd(x)	__pmd((x).val | _PAGE_HUGE)
 #define __pte_to_swp_entry(pte) ((swp_entry_t) { pte_val(pte) })
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
+#define __pud_to_swp_entry(pud) ((swp_entry_t) { pud_val(pud) })
 
 static inline bool pte_swp_exclusive(pte_t pte)
 {
diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index 1a91762b455d..476781c59d5f 100644
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
index 1c3c3be93be9..0d1d571215c4 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -901,11 +901,31 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
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
@@ -1901,6 +1921,24 @@ static inline unsigned long __swp_offset_rste(swp_entry_t entry)
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
index 1662c5a8f445..a68ff339cd56 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -656,6 +656,23 @@ static inline pud_t pud_mkwrite(pud_t pud)
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
@@ -1557,6 +1574,22 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
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
@@ -1589,6 +1622,21 @@ static inline pmd_t pmd_swp_clear_uffd_wp(pmd_t pmd)
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
index f06e5d6a2747..0cf02ddd3d4b 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -236,8 +236,10 @@ static inline void native_pgd_clear(pgd_t *pgd)
 
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
index a9ff94b744f2..122ac50aeb09 100644
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
index a50df42a893f..1abd9c52a4f2 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1761,6 +1761,22 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
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
@@ -1821,6 +1837,21 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
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
@@ -2369,4 +2400,10 @@ pgprot_t vm_get_page_prot(vm_flags_t vm_flags)				\
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
2.35.3


