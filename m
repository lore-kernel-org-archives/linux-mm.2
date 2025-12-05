Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3E10D374B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 23:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A9B6B0319; Fri,  5 Dec 2025 18:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19C866B031B; Fri,  5 Dec 2025 18:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8DC6B031C; Fri,  5 Dec 2025 18:18:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E43486B0319
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:18:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BC9558830
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:07 +0000 (UTC)
X-FDA: 84186982614.08.03E620F
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22F3F8000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 23:18:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="C7VM/kX4";
	spf=pass (imf30.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764976686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncR7zo6O4wM7dieNg4YaVMgDB/FRmYb+PM5XOoEML4w=;
	b=klXlXG8kBPjW6gHFqY3TfjOcVGNgXdFkDAf1ZV+RuJfngCqclbPluT43F9GVEhYCiC6nVr
	9zDznHpEC/fw+aLREwSplkhV0TH29DFmjFWbOA6ZYTpfl3YBcozz2tm0J8TOPioicFtqbR
	cAo4i7G2RnkxSY7LAgXOwDCi2+a7Z2k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="C7VM/kX4";
	spf=pass (imf30.hostedemail.com: domain of mfo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mfo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764976686; a=rsa-sha256;
	cv=none;
	b=lYclmkYm2ew7eHUhhZg6FRwIh2rXoLbJZ1JHpYCv9lx++GgIqyAYk2mIGGPDa0IVrirk4/
	8lMjRtNTAcdGXX+TDhJq1zvgnUArflIkBbjTEo4OFpm//D8cbP5ep8DORi5n/SKhmUeMgZ
	h7xKgHl3c0lPHBYTPcoBmWieCXy7LnQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ncR7zo6O4wM7dieNg4YaVMgDB/FRmYb+PM5XOoEML4w=; b=C7VM/kX4Z1GDZPeEFpANwu8M7s
	YGUKDqTs/z6yCu3N5z4MRfogDhl3scwtJSlSPWfviS8bVmnjERPsQMBe1G2lEV8H9n8HhJXxUWBy7
	fwAoEbsDb07dZUDlPNJEtxSgJVhLPVowpa2xRfpAGplGdr3fIvX5NldwkEsSpfHhOmWlJ02BfC6gQ
	/JRkhF9hO+6oDKApbSy9/3ssvwOb1XNgKZeoToaaJGhctUM7DehUKPnJTQPMygkXkeqm1trMiPjgD
	QCug1kQ9Aqc4NE3qc1fA645nAW5Ef1Bys4mObsqoxpwehNu7eBnFRWEvF81lVF2Gd6rdkPTx8Bmd7
	HjD5Z8Ww==;
Received: from 186-249-144-101.shared.desktop.com.br ([186.249.144.101] helo=t470)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1vRf3n-009H1j-5d; Sat, 06 Dec 2025 00:17:59 +0100
From: Mauricio Faria de Oliveira <mfo@igalia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Oscar Salvador <osalvador@suse.de>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: [PATCH RFC 8/9] mm: call arch-specific swap hooks from generic swap hooks
Date: Fri,  5 Dec 2025 20:17:20 -0300
Message-ID: <20251205231721.104505-9-mfo@igalia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205231721.104505-1-mfo@igalia.com>
References: <20251205231721.104505-1-mfo@igalia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5dgydtxx7q3q33ajhkj6yk9jk91mx5x
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 22F3F8000C
X-HE-Tag: 1764976685-486137
X-HE-Meta: U2FsdGVkX18xY73XBtML0y1hVLvKuL0WdQD5n+CE+L5Onf2bnOTlQIPNtjCJpy1rdCXUMuqio9u5FUItf5Z4KL17yDTmLf652BWpkw2+zvx6dm2YuMEpo898lLaedcqJaM/yUpnmU9Y1bf8tgblW9mCtmLndIlJSQtfPCWK/QmOweITb0T/vUJWSuORt7YJNhM1G+3xeHfvsdZ6I0Eb7W4G3MR0T1RRu0W4PQwYeaSTEFDUfmwjj2tzrwtUoAVVzP2UKpPPpvlY8+9pHcnDutGCAXHkFgVA5UzHxxpnYfqhwGaNb01NfJAj2InkYwNmmSyaY+CFdxO0Aq9dzio+7nTeV06wp/YvoHGmiJ0s1eIRQe/WkbbWjJTEP8pcUmOKl/fAX3ruLeobwJOMbMO/YQECMUpIlXQt3c0CCEvy6rQF2gB+Vq9oIr2E0QyB6E63rNxinLnBidO2KTBiX1pMzyTtnSS5pm8zPeV9rUlm2WB4yz0O5w+CKtcN/Dlt7YinNwywZgq3TCPBiy5jcMw4rd3ngoayk5ff1eUKgY3p6EzNBcx0Y5g+V7bBzzUzmwZEFvJl1KTnHzu3XH6If9b7w3vT8q8Cup5jLG0iK6PxOSSEKMe0Tt5MISqmr3hDIlduByd9tXcgoO9LIjE6zuBUhyr+dICpNI4tIBc+I2cIpGAqFcgEjO+ARaLawgJIGT1Cym109TZVH+Cj6kcyQ01ptA/rqNfPcpmMb+D6IkH/wtJOL0YysecYIZd600XS7BTifrv93XEJATcF0rlf2UEVHsbN8J+420I9zdICGs/X6IkVLWhtwupv5QiU+nbUkkeJKhi2D0UC4WAWukc7m8mx14gtwtahucStTRnBDsYVzTvcGXAsPbtRRt/TtO+fqxOvLCU0L8JbFZni5BNAAJQbVRftLZAWP1uJP2P8rSbVmOAejzxHNxO34nzNq5+ouTV+WU6zy70XJhY8hdBQpDlm
 p/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add generic swap hooks that just call the arch-specific ones (e.g., arm64).

Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
---
 include/linux/pgtable.h | 20 ++++++++++++++++++++
 mm/memory.c             |  2 +-
 mm/page_io.c            |  2 +-
 mm/shmem.c              |  2 +-
 mm/swapfile.c           |  6 +++---
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 652f287c1ef6..23d30afe439e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1220,6 +1220,26 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 }
 #endif
 
+static inline int hook_prepare_to_swap(struct folio *folio)
+{
+	return arch_prepare_to_swap(folio);
+}
+
+static inline void hook_swap_invalidate_page(int type, pgoff_t offset)
+{
+	arch_swap_invalidate_page(type, offset);
+}
+
+static inline void hook_swap_invalidate_area(int type)
+{
+	arch_swap_invalidate_area(type);
+}
+
+static inline void hook_swap_restore(swp_entry_t entry, struct folio *folio)
+{
+	arch_swap_restore(entry, folio);
+}
+
 #ifndef __HAVE_ARCH_MOVE_PTE
 #define move_pte(pte, old_addr, new_addr)	(pte)
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 2a55edc48a65..6a5a5bd3eeed 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4945,7 +4945,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * when reading from swap. This metadata may be indexed by swap entry
 	 * so this must be called before swap_free().
 	 */
-	arch_swap_restore(folio_swap(entry, folio), folio);
+	hook_swap_restore(folio_swap(entry, folio), folio);
 
 	/*
 	 * Remove the swap entry and conditionally try to free up the swapcache.
diff --git a/mm/page_io.c b/mm/page_io.c
index 3c342db77ce3..b62c53a86a59 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -248,7 +248,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	 * Arch code may have to preserve more data than just the page
 	 * contents, e.g. memory tags.
 	 */
-	ret = arch_prepare_to_swap(folio);
+	ret = hook_prepare_to_swap(folio);
 	if (ret) {
 		folio_mark_dirty(folio);
 		goto out_unlock;
diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..ef53c14156fb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2395,7 +2395,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	 * Some architectures may have to restore extra metadata to the
 	 * folio after reading from swap.
 	 */
-	arch_swap_restore(folio_swap(swap, folio), folio);
+	hook_swap_restore(folio_swap(swap, folio), folio);
 
 	if (shmem_should_replace_folio(folio, gfp)) {
 		error = shmem_replace_folio(&folio, gfp, info, index, vma);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..e156f5cb6e9f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1270,7 +1270,7 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	else
 		swap_slot_free_notify = NULL;
 	while (offset <= end) {
-		arch_swap_invalidate_page(si->type, offset);
+		hook_swap_invalidate_page(si->type, offset);
 		if (swap_slot_free_notify)
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
@@ -2196,7 +2196,7 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 	 * when reading from swap. This metadata may be indexed by swap entry
 	 * so this must be called before swap_free().
 	 */
-	arch_swap_restore(folio_swap(entry, folio), folio);
+	hook_swap_restore(folio_swap(entry, folio), folio);
 
 	dec_mm_counter(vma->vm_mm, MM_SWAPENTS);
 	inc_mm_counter(vma->vm_mm, MM_ANONPAGES);
@@ -2931,7 +2931,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->cluster_info = NULL;
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
-	arch_swap_invalidate_area(p->type);
+	hook_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
 	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
-- 
2.51.0


