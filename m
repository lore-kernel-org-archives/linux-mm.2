Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C6660703A5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB536B05BA; Thu, 12 Nov 2026 09:25:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E176B05BB; Thu, 12 Nov 2026 09:25:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774006B05BC; Thu, 12 Nov 2026 09:25:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3EDFD6B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADAE31402FC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:42 +0000 (UTC)
X-FDA: 85426690524.17.0EE1145
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id A9FDC1C0008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493540;
	b=XooVtKltz1UP0xARGhtlB+U44hAHdm8MtBNyoGjOof6x9aPlJbngIwt2e4S1bnu9N+ZZn7
	5XyE12NlGY4Np+08gvxJtIevhs0Xjzxamvm3Yu3WMA/KSun7+aWQgJC9xfRzz54d7diF0t
	LikdkZnGV7zOzzRV3FwoVM8T24m59JY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcG4jQDK10PWiWbm7mNfeb+DWsCeA1RxCscXblM2xnQ=;
	b=FeFdXdr3tpZscIDQRznNo80Ulo6xPChi3MLvoG/2PBtlq/+v0noGWXrnayLyRcp+0goNBP
	yhzmuL/oib8eRyeHGKdMF5axyER2j7H3zfoLXmarfzHfwilFzL+G/199g09MkS2jMXw0us
	mpZ4y2/bstHejL/4GunWUGbtLI86C2s=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B0A701F7A3;
	Thu, 12 Nov 2026 14:25:39 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5BE6013432;
	Thu, 12 Nov 2026 14:25:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T7
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:38 +0000
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
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 6/9] mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE
Date: Thu, 12 Nov 2026 15:20:35 +0100
Message-ID: <20261112142039.907090-8-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spam-Score: -4.00
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9FDC1C0008
X-Stat-Signature: qeq6ujsoorq6consbuo1s33htxozk97s
X-Rspam-User: 
X-HE-Tag: 1794493540-949585
X-HE-Meta: U2FsdGVkX18righoSt9kYXP9F23a2/t21YzfdNdStFQJNM9M4ukCSz5qBx/KgaRYJvA0YSu50Ubypo/9vbnj6HC7DwNTtyVMY7GPQRhYK/qW8Z8VofKYnVV2u31zTAC1RBfANEDRGhEzXVqlIaSyqGF0rZTYwMEwDnJejE/YTUlXkEuj8DNgBtI5bNJokWAuk779Uc2WiOkoPnOlByHPAiijrk69CygmIe7p6nce646FZEhfrKD/ATJ5awuHRAoThJfwKMljSqCirRY39YG9BFcaiv5MyoCgakgafGMDXD/bi8lMeac1MzyzTixVw0VXqVZccafFBGSdmXpXqrHoBHaV9AuP+Zh8bkwoYEOzuvOv4DsN9+hghbzMCmFEGa772LO+A3IQmjBxSPVW2Cktc4Gv4X10o8esuTRTo+G4bT+SnZHQkMCw5io90XgwY0/boRxJoO9L7KYlgrW08UrHOK5uW96SGvL89lkCb/Ib7zQcfJ2YNaTx0K45lWoP6r9MQODFAuVAGX2GXf6dT5tagyUzo8s2cN/hSZnRx42DxjKXJKVQiMNSVEXQNGvocG+/aBxhQoZX8xnA6LbztBpVYjvxRR7+u/EXB/MvqpS2q+SeBqqTFV2rc/WBWML6bmC6NXLsKzAwIH06OW4gjieUYRhbIsUdfOeNNouvyuI8FE65ajvJEyK/rjytasYin1auwHzHQeyJsMjdXq2U9DyN+fOsezH1GzePw1QqYwjMUYkmX9I98fLpTIq4UYn6noyfn5Ol8bNaQTmOn+2B64Pn/Wy0TdrBOYooGSX7Newb/NuIIirPxwtGDdzPlpDf/AzgZTlNU+OEp2PAPSlGTXyxmUnuBTxLn9Sqn6BNDMJpIVDnNMqC+zHGZNx6dIgK8uNP026Po2aQA2dsJ+hYZC8CK/4AC8MEOtVZk5s15r28PXxNv84TMz5X0BJ4KvXdEadOnGMxeL3fBVW8lE3Csfn
 b0R3g2ys
 ZgL8fKf0A23sJvIXzzrEdSia09N9b2hgYdHFiDbo6fzO/nk4Hz5l6pC9UmciqGmkDQ0EWsnFlwY5Rxd8YINtqBLmQrCsbDYKHMyHHAipa8u2NTY2zPBbiUrMQuVgTg6AXUYr12oH9KrbJvzp+Ab298oP6Z9Ox9/mFEdznvcdE3WkgS8FvydaBHqF78B9Eu7g07/DqB9O1LRahGgpJ2ffNjOIgbehYoPvjdsIBwblero7vacs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a range flag for invalidations that only upgrade permissions, so
that secondary MMUs can keep their mappings rather than zap them.
change_protection() sets it for MM_CP_PERM_UPGRADE and for the
userfaultfd resolves, which only restore access.

Now that change_protection() keeps writable entries writable on these
changes, no present entry loses access. Writable migration and
device-private entries are still made read-only, which does not affect
secondary MMUs. Migration entries are only installed after secondary
MMUs are invalidated, and device-private pages are migrated back, with
an invalidation, before the CPU can access them.

hugetlb_change_protection() never sets the flag, as hugetlb does not
restore the write bit and may unshare page tables.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mmu_notifier.h | 5 +++++
 mm/hugetlb.c                 | 4 ++++
 mm/internal.h                | 7 +++++++
 mm/mprotect.c                | 5 +++--
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 5db78e5761c5..b2f186ebacf9 100644
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
index ce9c8e57b8e5..06fd31b8fbc4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -6632,6 +6632,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 	 * In the case of shared PMDs, the area to flush could be beyond
 	 * start/end.  Set range.start/range.end to cover the maximum possible
 	 * range if PMD sharing is possible.
+	 *
+	 * MMU_NOTIFIER_RANGE_PERM_UPGRADE is never set here. hugetlb does not
+	 * restore the write bit, and huge_pmd_unshare() may drop the mapping,
+	 * so this is not a strict permission upgrade.
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
 				0, mm, start, end);
diff --git a/mm/internal.h b/mm/internal.h
index e3f92883bf23..b74ea18c6103 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1453,6 +1453,13 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
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
index 8c0fcd10f5a3..b7accf60c3d4 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -608,8 +608,9 @@ static inline long change_pud_range(struct mmu_gather *tlb,
 			continue;
 
 		if (!range.start) {
-			mmu_notifier_range_init(&range,
-						MMU_NOTIFY_PROTECTION_VMA, 0,
+			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA,
+						mm_cp_is_perm_upgrade(cp_flags) ?
+						MMU_NOTIFIER_RANGE_PERM_UPGRADE : 0,
 						vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-- 
2.51.0


