Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E19C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 15:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5726B00D1; Mon,  6 Jul 2026 11:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8096B00D2; Mon,  6 Jul 2026 11:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABEFF6B00D5; Mon,  6 Jul 2026 11:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73AF36B00D1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:44:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E85D4140135
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:55 +0000 (UTC)
X-FDA: 84958774950.19.9F0E719
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 017B2140004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 15:44:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ImYjkp+X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783352694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuuBIdIeisRjmlr2FFD7LVa5vjdcMT2dmalgoXzIXs0=;
	b=OkeMOAqZueuyAUXs3/PXE+rM4f5T0aviK8BlOMLVJdJCKGNcV5Iah6Uoj8HG+I4P2kib5S
	CRFhwJccHGbS1cLan6QJ96PpFAuPV6o9tvUzVg379Nh/6ZNh8ZfC+V5CchXLtIhSie79yh
	lDK4Gd+kiGRmjjEBw6Bc1eRLCidnqeM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ImYjkp+X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783352694;
	b=8EuEhTzRJ256UVyugtR4i0zGyDcdZW56o7ORQT/lwet8fHyszjtkqjPdkT/i3ZNOa6judX
	m2Xlq4d4ybHSaz5ZAquZLnC/UJMV5WRqu0fonlTBOgF3cI7MilEzro9u/kgPsCigzAqyAB
	ga+ZgkBw/D3INtdpqEzoDmDKtC2bqEo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783352693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuuBIdIeisRjmlr2FFD7LVa5vjdcMT2dmalgoXzIXs0=;
	b=ImYjkp+XZTpTRVInoDLcAuyw48bcYhxcJlUk4AHbKkm2Hr732PKAoQ09E8H+Q49lD8H4tQ
	TnV2JJfqADn3PWTWzDMUrg1ejMXkprXR2CayLnfNxD6TyyJe2KRaMGAZ8Gt1L+0XI6raPX
	5lrhfYqr71O/2t+2Icly598z3ir+d6U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-RqYnpzjwPraF3_-W_NKuoA-1; Mon,
 06 Jul 2026 11:44:51 -0400
X-MC-Unique: RqYnpzjwPraF3_-W_NKuoA-1
X-Mimecast-MFC-AGG-ID: RqYnpzjwPraF3_-W_NKuoA_1783352688
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 109601955F18;
	Mon,  6 Jul 2026 15:44:48 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.58.4])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A66ED195604B;
	Mon,  6 Jul 2026 15:44:39 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Nico Pache <npache@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4/8] mm/khugepaged: fix outdated comments
Date: Mon,  6 Jul 2026 09:44:51 -0600
Message-ID: <20260706154500.39178-5-npache@redhat.com>
In-Reply-To: <20260706154500.39178-1-npache@redhat.com>
References: <20260706154500.39178-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: mQWb-vkEHiqLSTB7VaMEzjbVSLuiOxC-MUoBg4ROVdA_1783352688
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: wzd631g5h9ja4ww6unad1sskagd55q9j
X-Rspamd-Queue-Id: 017B2140004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783352693-757287
X-HE-Meta: U2FsdGVkX1+wqxSDS1Ns6huyMUq5b+qRRWX4d/2UolOUzMOyz5BOH6bdxOBDWM8Or56AiDEaqpwBSAZnUdfWPfAPpv1MNR0Y9KwVA4wcL4IXVImJFPSzZTWBU3XkE932CYr9Jf0VCsr/bf9eq0lVZn1+xmhd2KHQSTo2JjU8TnOWMpYtX53rpL2vjcHAtFWMu3KY60vzxjxBdEf8hZo0sKXtcumhEgR3JV4jcQtuwQ4gYgzIpRp3yoIzb77O5Z/Fx/wEXdSoPuOsWviw6hIkjTf3W2N4Jou1Qi19NjJFrs14v9t48rTNgV6ziNtVUGPJwJTyssLDxfXRbiNsDo07AzqMIhEiID61gm/0GWTMoBVQOEhYfnqT8NzEsiYvAouZXtgzEhOxT6p3WscXXYz/iNUACNAdoydFgezTdxf4996xhxjuqptVbdYM169dgc8Hsj2Kn+tmWg9UxZymhUYknV118fDkplNmAmIXcaIqaE3blbUG1McwbshKHuE6Y8SOqcU9K3MzxnJg1sbg7wzZZSIyjMeySuJe+tZ9lxuD9lC0ne7mpcxZxLdOUn2SKq84GU/Br2LvyiTLcgg+apG7YwI+4LtCfPAoR64Pnx2cWO8RGoBUDs+Mdt8QSb61Zi0NqaW0dJhZaYc/RGiUsnRkmXy/7LVzMrYBk7WxMg74S6N7Kf8OOCMMdLAmb6vpQvOW9Mbz95JyLfLVH3y34EJo+tUtxw0OvcLiDFe4f7SF6Duuv3kXqIKUN7RTteziU9EA8JHrYMvo2nA350nQ9aPdVE8TEJozPulry+DQOE+EZEkXZOGuNAwgzf7VDrpMBziPxZaBOkkZcAv0YfIOY+qFIXw4ztagFKzIuyc8viiAKAFKb+Yr1kS7RtruGNI5y6Ap12bfqgYVks7m9C5nDezdxmhr8IYo3Kuy50wfMm7Qe0yDr35zFf1KW+dURHLCZIXeZen10OkWHJJW7PVon7s
 MMaAFAo/
 TWc8LXE5eeUot6d5yIq6Bc/dkaIc7OF3VXcJK1wd4RCoppb71lfd4KJwKo3yt6Qb0gGT3TEm8jttduw7UeemG+ZJn9A85rJ84Z6hX84OWQCN++UeMMdMWTr30lIs4YDuFGB+U/nYWhM8xpgH3Zdg6mz0LCN1xuDkh+psejvBH16/7y4YRMmQVkP9x3d6NeFJYkWgJEpnBFbBOsPQvIsgxClLY7VvQ48pSUgjV6Lhp+0bCJz88uOnaRChksMhA3vy5Eh9gfnknivhmTVPgyJg/FYFgC+U7gUMqMJXlhCIu5+Za4+lbSnA26kP0wrakjWeqraZTkim6v4i4VpqRtWA1Y5xEWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix comment in collapse_scan_pmd() that still described the old
folio_mapcount() > folio_ref_count() check and a "512" false-positive
scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
which doesn't suffer from the same limitation.

Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
when the code actually uses pmdp_collapse_flush.

Fix comment in __collapse_huge_page_swapin() that referenced the old
function name khugepaged_scan_pmd, now collapse_scan_pmd.

Also clean up some simple typos and stale terminology (mmap_sem ->
mmap_lock, PG_lock -> folio lock, page -> folio, grammar).

Assisted-by: Cursor(claude-sonnet-4):4.6
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7047253a6fb6..676f75773a6c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -619,7 +619,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 		/*
 		 * This is required to serialize against
 		 * collapse_test_exit() (which is guaranteed to run
-		 * under mmap sem read mode). Stop here (after we return all
+		 * under mmap_lock read mode). Stop here (after we return all
 		 * pagetables will be destroyed) until khugepaged has finished
 		 * working on the pagetables under the mmap_lock.
 		 */
@@ -792,7 +792,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 
 		/*
 		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: PG_lock
+		 * folio can't be freed from under us. NOTE: folio lock
 		 * is needed to serialize against split_huge_page
 		 * when invoked from the VM.
 		 */
@@ -819,7 +819,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		}
 
 		/*
-		 * Isolate the page to avoid collapsing an hugepage
+		 * Isolate the folio to avoid collapsing a hugepage
 		 * currently in use by the VM.
 		 */
 		if (!folio_isolate_lru(folio)) {
@@ -1104,7 +1104,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		return SCAN_VMA_CHECK;
 	/*
 	 * Anon VMA expected, the address may be unmapped then
-	 * remapped to file after khugepaged reaquired the mmap_lock.
+	 * remapped to file after khugepaged reacquired the mmap_lock.
 	 *
 	 * thp_vma_allowable_orders may return true for qualified file
 	 * vmas.
@@ -1162,7 +1162,7 @@ static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
 
 /*
  * Bring missing pages in from swap, to complete THP collapse.
- * Only done if khugepaged_scan_pmd believes it is worthwhile.
+ * Only done if collapse_scan_pmd believes it is worthwhile.
  *
  * For mTHP orders the function bails on the first swap entry, because
  * faulting pages back in during collapse could re-populate PTEs that
@@ -1354,8 +1354,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	mmap_read_unlock(mm);
 	/*
 	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later handled by the ptep_clear_flush and the VM
-	 * handled by the anon_vma lock + PG_lock.
+	 * gup_fast later handled by the pmdp_collapse_flush and the VM
+	 * handled by the anon_vma lock + folio lock.
 	 *
 	 * UFFDIO_MOVE is prevented to race as well thanks to the
 	 * mmap_lock.
@@ -1767,12 +1767,9 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		/*
 		 * Check if the page has any GUP (or other external) pins.
 		 *
-		 * Here the check may be racy:
-		 * it may see folio_mapcount() > folio_ref_count().
-		 * But such case is ephemeral we could always retry collapse
-		 * later.  However it may report false positive if the page
-		 * has excessive GUP pins (i.e. 512).  Anyway the same check
-		 * will be done again later the risk seems low.
+		 * Here the check is racy, but such case is ephemeral and
+		 * we could always retry collapse later. Anyway the same
+		 * check will be done again later the risk seems low.
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
-- 
2.54.0


