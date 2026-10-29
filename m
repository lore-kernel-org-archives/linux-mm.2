Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31EF606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Fr8gr2lE;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Fr8gr2lE
Received: by kanga.kvack.org (Postfix)
	id D97A46B05C7; Thu, 29 Oct 2026 10:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E916B05C8; Thu, 29 Oct 2026 10:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9346B05C9; Thu, 29 Oct 2026 10:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92C376B05C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AAA81203C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:47 +0000 (UTC)
X-FDA: 85375935414.03.941C623
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id E648D40011
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:44:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fr8gr2lE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fr8gr2lE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1a8/3J5EcLl5tWmgNvnCtDWgSoQs/LFJclaf6H2KQps=;
	b=HiIvwOcW/GQBUzrUReHgvETweuv7emwZNy2sxdRsFTmAQwc2ySyBclLZiDDg0aCwjAB4sf
	f9/XS6Zm3r/SnvXl3SX+ccVwYrh0bYc+mB0fT+YC+9894VWoINcQCZGeDajKwwmkxuURiC
	WmltxX8siIuo6aZAJX5DkyjavhHzLb8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fr8gr2lE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=sVPlBFkX;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Fr8gr2lE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285085;
	b=bbX8ZDNoxRVA+BNNbGnX17wP9U8XgIICSv4R+7jLDrxBGoa4OnIrDR5/hewH9JVd8/2AWh
	OmPtiibrpLlC0aE2pVwFwTPtctWg+1e8S+3R1VqwLMlGTy2snfZkD+67Pb1TumeFQQ5TD0
	p9TjPv90moUyD8C4oZ4/iYv42arXABw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DBE4C22101;
	Thu, 29 Oct 2026 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a8/3J5EcLl5tWmgNvnCtDWgSoQs/LFJclaf6H2KQps=;
	b=sVPlBFkXmfRtWTOIWulqhqFMBNfA74K7dPLUsieXrjh5gE1OK37eFJrkehhyUerVIB7DSX
	jbD4nUkR1J3bEFlh0TObLESH5SVno9SGZglr6mp7yJTJO//ZrTVuuc/eV1m4ZBDFOHgr4a
	Hjev4aXqBOJVwxyN6pSg/kXhUjh5olQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a8/3J5EcLl5tWmgNvnCtDWgSoQs/LFJclaf6H2KQps=;
	b=Fr8gr2lEW0N8NZ/ST2LUCem+tNGQbJAxCttJl2zYboPp9Oy6bN0PvuTpS2V0VAYScHRRvV
	+iXRI3Bpfiz9NkCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793285083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a8/3J5EcLl5tWmgNvnCtDWgSoQs/LFJclaf6H2KQps=;
	b=sVPlBFkXmfRtWTOIWulqhqFMBNfA74K7dPLUsieXrjh5gE1OK37eFJrkehhyUerVIB7DSX
	jbD4nUkR1J3bEFlh0TObLESH5SVno9SGZglr6mp7yJTJO//ZrTVuuc/eV1m4ZBDFOHgr4a
	Hjev4aXqBOJVwxyN6pSg/kXhUjh5olQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793285083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a8/3J5EcLl5tWmgNvnCtDWgSoQs/LFJclaf6H2KQps=;
	b=Fr8gr2lEW0N8NZ/ST2LUCem+tNGQbJAxCttJl2zYboPp9Oy6bN0PvuTpS2V0VAYScHRRvV
	+iXRI3Bpfiz9NkCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A23E11339F;
	Thu, 29 Oct 2026 14:44:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id iNqFENhb42qRUwAAD6G6ig:T3
	(envelope-from <clopez@suse.de>); Thu, 29 Oct 2026 14:44:42 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org,
	imbrenda@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH 2/4] mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE
Date: Thu, 29 Oct 2026 15:33:35 +0100
Message-ID: <20261029143336.390231-5-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261029143336.390231-3-clopez@suse.de>
References: <20261029143336.390231-3-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -16.30
X-Spam-Level: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E648D40011
X-Stat-Signature: p6fnubanz8rs47y91mgbxf167ie7yib4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793285084-445210
X-HE-Meta: U2FsdGVkX1+lSh8lc58s7ix18n5eJSy1YanvlBOhs0VG9KPevHoc6UM9h/lnjFCE/Wqd1HSm3RTLFq8STdPMm6y84tSEspDm8+LuzT3TB1AZx/9u/3uGQm3Z0aMpg1fjlTDI6SzYNuMz2YDdr0o1e8QbMTNdioFx6Zok5SnWAsJL5gn9zpG/C4a+HVVJE22tH+csqz9752m4IMXeqEW1Yx5BBRTis1XH9OG8gJOR/A6UGNB1x7bqFcr3bR15F0syvGSKnU6Fd9NOBG1H6VCa9jRe2ewIiZZSuBCepADJyOU3Xqp6+Uhh6yN125oRFnKtevhDqZAkY7JzAjIiLbiK5+AEWmIgzXj6WVgRMnJ/CjrG1QWGIwCcltdWsorAlqrD/dntV/xBPb24EVksBSTyC4XxP4ucla6eYQNdrJdgZOJjfMecW1ThqJ0X3N9b30P+N8xUQ/qiKP5dHy4IjhpB9Q4WRnJUjFZzcIMcKUJiMi084Go8fgPcgdLhFJ4wc7W6vEOxcIROVdJ6Bx+KrKED/euyQJEWQe/1aYpvM2Lfyi0wi1LEknU68CTvDCHOsYKPeln085rv+7Q/eq92GVR0o0XFSXnCeFYdfOZivKe4DFLNMKvi0xoN2lByOvSesOs5SVASsapu9KoNsdWxJkLsZv7lxfvW4gJ5V6Ql34O8AkHZ3WaKEPRXQuPXsBMVHec0rfeD8b/W/5Ywl4tbwZxnuQj0GCttDLAjKjv/Gee2PpvYFTpXQ1DM4OM8GyDK+0i+Zy+VD4dicJvQ7w4QBITEh817iwVikXvyOeaINu/NpgSa7sAEhKznrV4x2S/AhHXUgo6mo95uYvhb2k/yMozl8e+FZdKttNeM6lt1buQn//TlyaXyQi922eg/EA+EPryn0FHnWhuO774synCkaSZRuiJKLa8DF/biA/1MYu9CmxYl/eh6YpvPi2/mU5/Ft0Cdx53XUzmJsDVeEqlDXIA
 dX8plpDK
 CHy+sTiOrWRJX99N4ryCkHuJ4gwdzNJN6OsuqxLZNeP6hD29DHCgaGdK7UiSENHcQMksUihn86zYXQzEEGpwrnzLTcvoxmCQmPF8WXxZ1MhNeA8VhptayiFcOyPDFDlcIUncGRBhY/VErqzkMErrZLN3u8RGPOJaw4B/Q3nwBM4qRSGKpbyfpTzTLCqRJUfmFNqPgpLakh4kSLEM22HzCt6hWSU3pu9Lhb9/Mrs6kDxjTo/rz7E40OnFdDzrnbc5W7VmXGsDWaGaX1rr5VK3uRrTF/GUZjUx3x6jcgDtLvX2yaCzJKnOJzqMOXjAs/EpShakOWrXb6uOLSaTMFoKHA7/tKIodPJ3M32nGYzBN9P3vLZs3rYbRuC0aYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a range flag marking an invalidation that only upgrades permissions
(that is, no PFN change and no revoked access). change_protection() sets
it for MM_CP_PERM_UPGRADE and for the userfaultfd permission resolves,
which unprotect a page and thus only restore access.

A secondary MMU can use the flag to keep its mappings rather than zap
them. Consumers that ignore it are unaffected.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mm.h           | 6 ++++++
 include/linux/mmu_notifier.h | 5 +++++
 mm/hugetlb.c                 | 6 +++++-
 mm/mprotect.c                | 7 ++++++-
 4 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f406ce9d1032..c4fc3876a4b7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3418,6 +3418,12 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 /* Whether this change only upgrades/adds permissions */
 #define  MM_CP_PERM_UPGRADE                (1UL << 6)
 
+static inline bool mm_cp_is_perm_upgrade(unsigned long cp_flags)
+{
+	return cp_flags & (MM_CP_PERM_UPGRADE | MM_CP_UFFD_WP_RESOLVE |
+			   MM_CP_UFFD_RWP_RESOLVE);
+}
+
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
 extern long change_protection(struct mmu_gather *tlb,
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef521..112be28cdf6b 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -60,6 +60,11 @@ enum mmu_notifier_event {
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
+/*
+ * Set on an invalidation that only expands permissions without
+ * revoking any existing access, nor freeing/moving the underlying page.
+ */
+#define MMU_NOTIFIER_RANGE_PERM_UPGRADE (1 << 1)
 
 struct mmu_notifier_ops {
 	/*
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b017ae1dfd6f..68d44044fdd2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6548,19 +6548,23 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	long pages = 0, psize = huge_page_size(h);
 	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
+	unsigned int mn_flags = 0;
 	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
 	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
 	bool uffd_rwp = cp_flags & MM_CP_UFFD_RWP;
 	bool uffd_rwp_resolve = cp_flags & MM_CP_UFFD_RWP_RESOLVE;
 	struct mmu_gather tlb;
 
+	if (mm_cp_is_perm_upgrade(cp_flags))
+		mn_flags |= MMU_NOTIFIER_RANGE_PERM_UPGRADE;
+
 	/*
 	 * In the case of shared PMDs, the area to flush could be beyond
 	 * start/end.  Set range.start/range.end to cover the maximum possible
 	 * range if PMD sharing is possible.
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
-				0, mm, start, end);
+				mn_flags, mm, start, end);
 	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 
 	BUG_ON(address >= end);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e9b636809c42..b48d2fd3b7b5 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -597,8 +597,13 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			continue;
 
 		if (!range.start) {
+			unsigned int mn_flags = 0;
+
+			if (mm_cp_is_perm_upgrade(cp_flags))
+				mn_flags |= MMU_NOTIFIER_RANGE_PERM_UPGRADE;
+
 			mmu_notifier_range_init(&range,
-						MMU_NOTIFY_PROTECTION_VMA, 0,
+						MMU_NOTIFY_PROTECTION_VMA, mn_flags,
 						vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-- 
2.51.0


