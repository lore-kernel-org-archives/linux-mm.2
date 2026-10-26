Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 448A7606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=eOS7lClG
Received: by kanga.kvack.org (Postfix)
	id 661716B05B0; Mon, 26 Oct 2026 09:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6115A6B05B3; Mon, 26 Oct 2026 09:01:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9AE6B05B5; Mon, 26 Oct 2026 09:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231146B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:01:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A08D91A074B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:01:09 +0000 (UTC)
X-FDA: 85364787858.10.C58C639
Received: from mta1.migadu.com (out-228.mta1.migadu.com [95.215.58.228])
	by imf19.hostedemail.com (Postfix) with ESMTP id 964DD1A0011
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:01:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOS7lClG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793019668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mXgMFETLS+maZru+AaxXX7HtH++GszgJXY1ChWAfpak=;
	b=I8rto4rBn9SktpKsRegAxqeIjbVMMun4rYJ1/H6jl3yyfExUiMdhw9zKzSv1Lv01ERumL6
	DWyg6sHcEgp7S7FdbPDDtrWSNl566u/6KPSucfR+hwTOQvkY55sKibXR+ekXPKybg5Sez4
	yg4MFuNDR4JgnvcyDhPv8IQKcv2B3Og=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eOS7lClG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.228 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793019668;
	b=Ka2z+qTTvuujTEik+VUuMoEnGsFOqpkR/IZrrpO8vJSCOE9AsC7O2ax3x16s18xNjFYXrN
	AsHUDiaCySyP4pT7vc94rhkHE/8fjM44SaDODM97EynkoeZHDY9C9eJvVXAOsBTqSP9Pa9
	W0woWPiDu0QYaF1eCvS493JbbcCwXzk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B6SFPPfTE9xynzH7YlPHvBs9zmRqMXuyeuvm0EVIU4Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793019666; v=1; x=1793624466;
 b=eOS7lClGi/NgQp0DtV9ezX0Fjrcv+6UoB7uzRiTJeRH14SUuo4u4a9RC5pVgPSjcbTtW8SC6
 yUNkIsOLnD7KBu6erCpsdvH9d1JLKpJTHFkt+SHnavlqYfecG2mlwCMZj659jXq4LPBi6bYD1UF
 b3aveIxdgeuLmwvWytaWVTW0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f415b154d1059a70;
	Mon, 26 Oct 2026 13:01:06 +0000
X-Mizu-Trace-ID: f415b154d1059a70
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jglisse@redhat.com,
	aarcange@redhat.com,
	peterx@redhat.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bobbypowers@gmail.com,
	bgeffon@google.com,
	dplotnikov@virtuozzo.com,
	dgilbert@redhat.com,
	hughd@google.com,
	hannes@cmpxchg.org,
	kirill@shutemov.name,
	cracauer@cons.org,
	mcfadden8@llnl.gov,
	gokhale2@llnl.gov,
	mgorman@suse.de,
	mike.kravetz@oracle.com,
	rppt@linux.vnet.ibm.com,
	xemul@openvz.org,
	riel@redhat.com,
	shli@fb.com,
	jthoughton@google.com,
	corbet@lwn.net,
	pbonzini@redhat.com,
	seanjc@google.com,
	sj@kernel.org,
	ziy@nvidia.com,
	stable@vger.kernel.org,
	samarth.colleges@gmail.com,
	med08elkadiri@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] mm/ksm: fix userfaultfd protection during merge and unmerge
Date: Mon, 26 Oct 2026 21:00:54 +0800
Message-ID: <20261026130054.91461-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 964DD1A0011
X-Rspam-User: 
X-Stat-Signature: hjzfwx11cnesuctkyu7phg56qbwho67p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793019667-38278
X-HE-Meta: U2FsdGVkX18vlEJIC5cQtFESB2n6vvqSGhHBUl54NW9/oR8IyyXQKvz6+ulsqchLK7QDOdHQE8JcZL2y8uUB3RVVEtp13qugkI2Z40BhNMXrkrIVXmIFAJX4/6P4s99WMJpbsOKl1ldENDd/sbdjf/FZzCZPvdqPqVIgL08CrPD3xnOd2w+JRbhBuZxRqN566QXovkB/sZoI7vSyVskjJLqVk5sVmx5IV29A+ub163i9jWNg+kIverpYkgJeuu7vdU6Dib1f7ugIk+N3A56r1TipNtzZOYd3WFOaCmD/nZ7ij5DLjhYFVo5drawYxbqIsRD6e/hFEYBZhw3iP0vhMmd38cKNKLz2o/rcgmB+yJVBQY88V9lBCZm4KBVL/LT1podwbSH8f/tQgSYi/boEwyvB9CndTaBkA+EbiIGCdghB9Tc/R9RplLPM8LqhrqGsW5rZamO9p76ijC7oR6+Zy7MQe4WvEXQ5/I1vFgfCwImrGkrMlgn+f/WOynluNItz3G4I98039QtFVlH98GQnpzyz3EOq/eYJAnNysmTGKdiMkrSedzcBKLIOgpe8BbcGyr2jD/qUYIwgyh5ZiUxlUxg0ujZ6a55nwEkR5UkpzEZSzou3B+sDsLG3uXr1wZ4MQ4+wNMGGDWF2ONX2KCmNN+VEq+DDjS3waKh4u4zTdnmi2ZAqqri1n9T4i2ExlARs1vPPhPppr4CB8tWTX2px4twwvbNFRagXrrAry+bEroyxPNyy5aYj07hKAocP1JQYqc6CCdV1GsxaIymfBoRkoZKkbXZ26lL3PYyfbJJ6KorFAXfDzbbvxtEWa7YZuuZHhns9nTDNqyCH1wP99GbFccLS4ofNKgg3FceezFWs6EuPu8n3sA2De6DI14Y8v7dbA+4nGIC7KTplcZJMgADxPCCaXPC7xXphAR/CFG5Q5g003H+sMkzvPhOutdomGYnK22HBl9og/yeLjomfriN
 raSMkdqU
 6/NWqFtsmS7SqMH91Rn9McuBVJ73eqlthQUGTKj2x0yPtaxMtm5RAf4XdN5yZsc3kSuyBKrEr0cW1UUpKLILoJVfXKt13vAIKOjKQk5MxyAstcPGPN/nzDGCi+Ex8sNSK6ZFD9PJ9fGXlClhqzYEqbIxAGW0nV6j9T9v72mGiSzipEjFshwkLGfOrtAh96JDnOlEe4EYe9K4MRpeMSo9j/WheAME1acoRUimdgf+iLf9e3Q43KpBizim4a8C224IlPG9R0jn7dgsRsoTvRUVceluOGlBsMPpOmv+5Gouo9b10OmHrUZYG9Nj4flqZCl4mwflvSvovK06AjD6fEwoY5J9Hfl2U0rEsMm9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KSM loses userfaultfd protection when replace_page() builds a new PTE
from vma->vm_page_prot. Dropping its uffd bit lets a subsequent write go
through ordinary COW instead of userfaultfd write protection handling. For
RWP, a merged page also becomes readable without faulting.

Keeping the uffd bit and restoring PAGE_NONE fixes merging, but we also
have to handle unmerging. An existing KSM page can be protected with RWP
before MADV_UNMERGEABLE, so unmerging already needs fixing independently
of preserving RWP during merging.

Unsharing replaces a shared page with a private one and should leave
userfaultfd protection in place, as do_wp_page() already does for write
protection. Currently, an unshare fault reaches do_uffd_rwp() before it
can proceed to do_wp_page().

- With synchronous RWP, handle_userfault() returns VM_FAULT_SIGBUS.
  break_ksm() then reports success with a KSM page still merged.

- With asynchronous RWP, protection is cleared before unsharing.

Preserve the uffd bit when merging, and restore PAGE_NONE for RWP. Let
FAULT_FLAG_UNSHARE skip RWP fault handling and keep PAGE_NONE on each
private copy as well. Unsharing can then complete with RWP still armed
for a subsequent access.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")
Link: https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/
Link: https://lore.kernel.org/all/20261020055518.36087-1-lance.yang@linux.dev/
Cc: stable@vger.kernel.org
Co-developed-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Samarth Narang <samarth.colleges@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/ksm.c    |  8 +++++++-
 mm/memory.c | 14 ++++++++++----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 910a1307ac9f..d6f736a1aa2f 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -34,6 +34,7 @@
 #include <linux/memory.h>
 #include <linux/mmu_notifier.h>
 #include <linux/swap.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/ksm.h>
 #include <linux/hashtable.h>
 #include <linux/freezer.h>
@@ -1463,9 +1464,14 @@ static int replace_page(struct vm_area_struct *vma, struct page *page,
 		dec_mm_counter(mm, MM_ANONPAGES);
 	}
 
-	/* Preserve soft-dirty when replacing the page. */
+	/* Preserve soft-dirty and uffd protection when replacing the page. */
 	if (pte_soft_dirty(orig_pte))
 		newpte = pte_mksoft_dirty(newpte);
+	if (pte_uffd(orig_pte)) {
+		newpte = pte_mkuffd(newpte);
+		if (userfaultfd_rwp(vma))
+			newpte = pte_modify(newpte, PAGE_NONE);
+	}
 
 	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
 	/*
diff --git a/mm/memory.c b/mm/memory.c
index 6a93b7fa48b2..99439a7afa63 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4122,8 +4122,11 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		if (unlikely(unshare)) {
 			if (pte_soft_dirty(vmf->orig_pte))
 				entry = pte_mksoft_dirty(entry);
-			if (pte_uffd(vmf->orig_pte))
+			if (pte_uffd(vmf->orig_pte)) {
 				entry = pte_mkuffd(entry);
+				if (userfaultfd_rwp(vma))
+					entry = pte_modify(entry, PAGE_NONE);
+			}
 		} else {
 			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 		}
@@ -6659,9 +6662,12 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
 		 * VM_UFFD_RWP VMA, a protnone PTE without the uffd bit is
 		 * NUMA hinting and must still fall through to do_numa_page().
 		 */
-		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
-			return do_uffd_rwp(vmf);
-		return do_numa_page(vmf);
+		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte)) {
+			if (!(vmf->flags & FAULT_FLAG_UNSHARE))
+				return do_uffd_rwp(vmf);
+		} else {
+			return do_numa_page(vmf);
+		}
 	}
 
 	spin_lock(vmf->ptl);
-- 
2.49.0


