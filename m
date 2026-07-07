Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD3CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B746B00A4; Tue,  7 Jul 2026 08:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3806B00A5; Tue,  7 Jul 2026 08:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4095F6B00A6; Tue,  7 Jul 2026 08:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10B1B6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:12:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7C98F120429
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:12:01 +0000 (UTC)
X-FDA: 84961867242.08.0727F00
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id B15C1140006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cxSCJUmu;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p9qicV+5uUtAHdNku1aYdx4YyjVpuOGunjpB7A44hEU=;
	b=QTJ2P+yiASBbt2hgmf19Y53au2gWfDeU3SdMsLEYEhj8L4520K4jp76zDWobSwdNwSJpT2
	P9Gd4AZ6ZwPWM8105Jk+QW4MOImIuTIK0aMaAdmtMif5OG52DYLcTG+nKwAr5tmOtZ518l
	IvVXmzVHgarZez1PEhx8znlUye5+uHI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cxSCJUmu;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426319;
	b=Mwkre7VHIvJz598VWAOY/YP4S96tzCjrBiwSgBSGGUQAU/gxVMLDHH3xK1/Lt2pmp6kEw8
	wnynCKIwGFxG+SbEqQBRVo8jOqrTcqA7RfQiE9D02pp3QUSH9ckTdbQrEejeqsTM+/86i1
	FepMXF9xaSNdr6KsjGOW5QWKWQR00uU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76D671AC1;
	Tue,  7 Jul 2026 05:11:54 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F0EE3F7B4;
	Tue,  7 Jul 2026 05:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426318; bh=K8LiYhecaA/tHpgiP5LnsR7z3DY5B1QiY2CZ+4dl2Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxSCJUmuZoV8NgRmLITcisD40uhlc/lD5pPVKrYq8Y3hzdgFfhBvDEUXYzNrGnTaq
	 Mj5Mxf8xfr9PW6FT3JmTQK2qLPzN8VZsAaX80NwVqCPizct4gtUXS6ZI0tBX3e9UK9
	 y3mXjYuvDP4VznmtNpEKB+SMT5oodMKG5obVBJZw=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 3/5] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Tue,  7 Jul 2026 12:11:21 +0000
Message-ID: <20260707121128.373192-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707121128.373192-1-dev.jain@arm.com>
References: <20260707121128.373192-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B15C1140006
X-Stat-Signature: yjs6j1mik7aun4ug9uqjxdpcnk7zyozt
X-HE-Tag: 1783426319-771778
X-HE-Meta: U2FsdGVkX1+V+wRBIoc/oGCqwy6MgL/nImGN+SYnu6ybi51ZyOzJ2nrVvCqtkLv8qXBL9Wv2ZS912G9lmMj7ih6uQYrwAtu8Pg7GU1MVakgr5xzjNMi2Qz5KWLWQywrGV5zx8t06OzAIo4OkEQ566cIPE+cFy8i73Bm0YaS68ig9G4x23/hmeVznqDM0rtDwjcTWuFpV1WBRXyS6QZQQpP/r9o+ZjfGKh0JHsP4CfQwS9y/h1RzDgEy8MZpGgA1p2pWmXwBPPLvloJM0x5fE0K8AeqKuh6Hkvyxc6opFt7nXhbP3xnUJoFI3of2peJ/Xv+ha2DRxIYBZGGy68d0Go+ESARuwhP0nkGUZ+NkDbFFcQcLc+zlKG2bLao0f0mCQe8jx0mg3HosqZkX5qs3TxJluU6YPmZoHafMjZaROXYuNrwZnlFAE7hiiw2e8UEy0Vb6cS7JnSaPuJqJd5wR+H06HP6hk85J8JmxZUoZ1aH7DXhThJwpYeMRcXh62fFRRRMgKbeLl7VaFPKQghzpDBSf8WSfEIw7Y94z4/Fr++B2W/djUJI8p8MdDjoTf3SmeP46qQw8Oyr2p9+Ox2dJoP8f2T2gPAMD0TjTfnJOYrf7GA41pVl7C3v6paQ/NetGkROkewPT/ZMY7AQ5Kq2ZfH/4gSupD5wnImxhCwoVTVtiOXqWn2+NTUs07dMqTiN/csFQ5VkeCsgIQPwZcnPTcIGUvrZN3Z6oTF7m8eD3jLE+lnws2qTWcoQ7Ahq9Q58c5WM599EtYLUqlEetY2IZC4zxUOiDXl4O6NtCzoxzJ9RtCj77eD36aczFf/uPaqUkzvyoMg5Iwdn87uivoeBMtgjD3Y5fXZcmhLbN1LKmYmVyrlGBz1JW41pG8D8k5C4dGx2dyBxyVm1bVeh9KoTibL7DtoGQV4cs+mVFlWd8vhwnmC2EF+aCBBaHUbWW6Vt7gsWWimuO1lDHi4sBdB5Y
 iCz8q8me
 sGld1lDMG41JANcLLD5R37swC1EtnCyHpKRBvvKjTwpzZff51R7QHaKN7nB/FCca+5fML+cKygmbrcmcLaNjpmI3wH9YMajvx/JqXXX/e56SlVWwF7nMXsx6e5ORXrpUAEPO18h3iGDKtei+m7nWL2PiUos7ilqdkLBuUpTkmQLlNzvqDD+bUj1XHgw/dagcGcHQXmD766dxNbd0C8l2YemwKseMT5VG4r/JW+41/s2m3LzB+KszYdWLvzB1gKVz58E+jiYHi2eBz7ZGawcchyvmYyFcvTzUmwhjl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

No functional change intended.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 87 +++++++++++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 38 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 934773dfa2f2a..00b571c2a1bab 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2067,6 +2067,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static inline bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	if (ref_count != 1 + map_count) {
+		/*
+		 * Additional reference. Could be a GUP reference or any
+		 * speculative reference. GUP users must mark the folio
+		 * dirty if there was a modification. This folio cannot be
+		 * reclaimed right now either way, so act just like nothing
+		 * happened.
+		 * We'll come back here later and detect if the folio was
+		 * dirtied when the additional reference is gone.
+		 */
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2263,47 +2309,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_anon_lazyfree_folio(vma, folio)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
 				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2361,7 +2372,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-- 
2.43.0


