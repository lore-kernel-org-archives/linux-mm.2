Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7B5C88E45
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02436B0093; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD90E6B0095; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC8676B0096; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 896476B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B33C21C222C
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:40 +0000 (UTC)
X-FDA: 85203728400.23.9DC8BF4
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id EE95140002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dqGs4UsF;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dqGs4UsF;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789184919;
	b=j29PISUtP6an2qHhtUs1hpdLPBz0B4vaLRW0AuIO0x/oommGm15XUFsgkX2jvFtT74PpX6
	CSGhyDS88Vo9b5oLADRntnjKNqIxK5x99r0emSKcwQNjM7cLnDt1tuts2zhps48slKLIO6
	AGQ/4Y2uicNlWsa6Ook84OcFbmVcTpk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789184919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SE/qOas+/SI2EvNxtEJVx4SSxOPMNxV+dkdmLC2H+E=;
	b=EDKK9OkDMobJhEh1BaiaHJefqTt7OWb5/nyL70gtkoMb35BmGmHCBzN1jm/kxrmwG287zs
	y52uIlHM3S+WwLsIXHHGEW1U4ZXg3JbKiXf0YUzIQW21cFpmkQXFMpzAEDYPyLiUlodiKr
	Ta+i1KyhpA8FhslDt49ZrpeKcqUGibw=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-9106f4c3a4dso18066386d6.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789184918; x=1789789718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SE/qOas+/SI2EvNxtEJVx4SSxOPMNxV+dkdmLC2H+E=;
        b=dqGs4UsFm//QfCub/FMzOs1mZhmrz1R4BXoNpdZZM2rj+YicsE0j1u/57mfpRNdz1z
         DzgALTrkNO98bjSqwKlnKKEHbmGRcDKkTXkBtOmS5/woaq7vd9i9Sx1ryegeDOoHU1Ym
         8gmnP/AMRvKfltR832ASjrByARiri648F/jz1hYzpkom2xcQLU2BY/Fe2x6H7vQJic+R
         eFob5u5yCNhO+vLTPU6KhuSV/r7tk/aTJRVfZwhPCnrCDBoom2zQcHCqM63qN3st71YB
         Cp9yr3xyq+nSxpgMuE+UbnkxCd/e9xrOckp44A2WhQIhCvZEEEZHQ4sZ9SOETo/adwsz
         F+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789184918; x=1789789718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5SE/qOas+/SI2EvNxtEJVx4SSxOPMNxV+dkdmLC2H+E=;
        b=R5K88+k2b2QBW7Zy0uu/myy4feyNPhtnY+l6/z9Ar3HzmnlsbcovgRWZNGFvA6kO0w
         XiDWwBILueUTdhsA3PElnYuHUrCKOLG8jY4s1UNVFxUbfT0gjw7S81lLFKe5mBNP5VLA
         TP1OhIRlb9lmW+QqovJD27w6IaaKY2VSCRnNn/j6RIuO2KEFR6UdeFKVdlLX1giYy+DK
         Ub0Mq7PwSeqwVteX4HpvbI1Gg1D6ysVhT5YPwnsKKEHkEbjLgqkpNnEcrhP/R+ZRtPya
         JM4cSaE7vDBXbxdxTIalxWAkCkFDCS6I8YQTdPS6TFzXQjB/ezRBkN+CUibpHGBLZFWh
         s9ew==
X-Gm-Message-State: AFuF++n49vM/azOVpEeVIcFkLoTmLm/ShNMAwR9q5pHw4ezsQ8qF/0ch
	iKLANb6SA4mTkPfB6mXusn7j0hsURnPUTzZLPZQENvBw1ahdvcDv42spqS+exaIWhX7FgU16jVp
	np+iS
X-Gm-Gg: AYBFou2hO+6LZrt89iQmv3q4IFxSlRypqvjmECpEB2ID+QNhvmEmSA/8I4VbdA7Ddn8
	hLjDGmIR/Hdj+nCoMVqx0x4YFH2rGf60trQn1v6c4M8FYv0XTwP+6aNQN6td3AvYOmIduRK5vfJ
	K7iJsq/r4cQGFYvr4OcyFt4s37mL360gpxJQ2BQNwHQVCoM7U6yu/CeujCIJf3gxwdSvZ2LjLL7
	omyZGhLEZKmNhCBjCMi3gMlIl2zjuUV8tqBvSL+qgTjGflshTpkqIp9dCWmMoM6s+f23byQ/uLz
	dOHAgmfcSFGovQZ67KoPvqEU1a84OPrhrHqMR7KAvcqEs2P3DmBuxxRuMeV7DiV2GUxgibgRdx/
	5Jdf368PqjkbAh/mhkZJWnknHbobDUqdsoKDymEtIT1xo+Ca2Qfgi+2C4N+SVoj9Y/mPmL9JPjt
	9CoS8rQRJn93K+JfXqkVUcku2nSVz7dfyZjTZRXbhW0baassqkWp/lhf3WC2+j1Xb1wcx0vovjX
	LNK5YnzGh823/UksT4diBlzNp0hqJDRI9o37rDlYhLc5iX9KSIphQezDfJR
X-Received: by 2002:a05:6214:29ef:b0:912:289:647f with SMTP id 6a1803df08f44-912121145f1mr108338996d6.33.1789184918116;
        Fri, 11 Sep 2026 20:48:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f494620sm36252476d6.28.2026.09.11.20.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:48:37 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
Date: Fri, 11 Sep 2026 23:48:32 -0400
Message-ID: <20260912034833.2952750-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912034833.2952750-1-gourry@gourry.net>
References: <20260912034833.2952750-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE95140002
X-Stat-Signature: geg83x64tf85a6ifgg1hagyzok9rom3n
X-Rspamd-Server: rspam01
X-HE-Tag: 1789184918-842816
X-HE-Meta: U2FsdGVkX18wj4EYzZreQksJeDTarE6zrgcDYO6S6JqgDElO5LU/Bb/6D1Hf1ROTeB56rIbU2C9aqdEHothRoJuxwDOS6tkTZg4n1XQu8M/K1MkwFQUettHs9X7Z2q0TfIhh4dbxAiEQoP69wmfxPYQdahjknmru7sOSDrMb78NV6incrDGFL9Oyh97xAagmsGUjzxKqDFK63Ctuiqg0orl/Q7CuNNr1lMHKjNSHc8+hbSPkOMi7igEE/5c3sOUBfZe72CAh5kFdBJnrHmxITLaRWJ5Lgn622FGVV0LXHbTh8A5GciiEGY/uOW7Ns7zFrh1QUfs+8U0jqaHIBOTJgNwSgOmnkzr9Zep1rf1QMyIeAQQqJHtnD5Sum8Pedovn65aCzykeONNgclzWhhzgHlGJnMBL7Yzo3JV2+myRoeRs/6b2ZNP+Ax2/yaIUPI2lMPcXptwKnpyZ09aJTBBIzDG4S0JmsJLAXN0fkn4P7HSL3GU0OljvmtP6rHyczt91P29/y86L2SEu0w5KdgUVgjRHh0mE9roVU91PUtlaGdSI/DHiCMSuBMYDUB55wW7beVSgnd0Ee1d67LpZZ5N3X5LgLTZvhmyYUVfmEG7ozDILRDi3a2jUwQL8puF3qBCY+EjAQ2hypiipVU3J+tR5AcWaLWzgBxASwsRjGiGhuK7q7A8OFgeMmFRxhEI5DemXe5WEGBHL9s/Mg9W8Z12A3Ao/j/2NBX1dKqZ9+p1G3Ws2vEN65rhjqwJjPPZN7jeM6WCsgz7a0nHmM60y+MaDr+QeXvtXKunFPbGJjS7VKyVBeDf5s0pH/JiluyP5CZxYIN7BGTXUAc0GbV6BYvdjGXhExpHVJh151v7LaC7MGAekS/mKcqo6LIbqJPvZ62PNj+dgq2GWQtsFe9Od92AcG3rAHtB/2Dy0/a3No0ZpwA1+mihbbngqWdDrY52qsqsG/tqdkjT+E3BF/CjY7Da
 /V8ArdRZ
 sb9h9awz/8vY6CTPuk2Yrzj5RvjxXn39ZZLzTb03LCQTbXCmETju5JskkQoa7FleRNbIcYyFBZbXtoGbVGpWGcvJ8t8c4trG5pMc7JP5nTFJJ/ij4gW4+9Il+kwdk2u/O12NhEgUuszefPfg4hDYMTdMZYtsQC/41XPK2A0KVIfDicWUs6dbwj1Mjf5XyHY4LK6UyMx8ITvaIxJCeiYuPVr0AyW+El9bbSFAQFKrgSEAh1+7gxw9yGSfSaE59eQ1LpNp9/jasy9UxnQSzxczt7rFxQFuCsJ5ayXVyIlxDwge4oburI//0NWZyBv/8YDaNq4qCr6YAz7Puv88y5XqMiElH+w0EXWLeJNzQ+5jHL4HSW/B5dWC3H4Np+E8r8nnZ0PXK14HsjnhEzXcaaaHYxz/W7iV81MplHD6FkmTImKDbBMiWrwauyPfqu6nU+7TYSRbQwHay4vrhKPCGyLmBw6jna68kj3kBdN3QDAE5naXytyanOng1sBkYwlw1pfkjXbvm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then

	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);

With a stand-in module for the driver:

  BUG: unable to handle page fault for address: fffff96dc0000008
  RIP: 0010:queue_folios_pte_range+0xaf/0x440
   walk_pgd_range+0x52b/0xaf0
   __walk_page_range+0x6a/0x1d0
   walk_page_range_mm_unsafe+0x193/0x230
   queue_pages_range+0x64/0xa0
   do_mbind+0x25e/0x640

queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pfn
is raw MMIO with no memmap entry, so the folio lands in unpopulated
vmemmap.  Neither guard stops the walk:

  walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
                           supplies ->test_walk, so it never runs
  queue_pages_test_walk()  honours vma_migratable(), but only while
                           MPOL_MF_STRICT is clear

A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
mapping.

Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
queue_folios_pte_range() already does with vm_normal_folio().  On the NULL
path, retain ACTION_CONTINUE handling for the huge zero PMD.

mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
rather than -EIO.  The PTE loop already returned 0 there.

Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mempolicy.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2ad0a5f18280..8fc8a975657e 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -667,7 +667,8 @@ static inline bool queue_folio_required(struct folio *folio,
 	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
 }
 
-static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
+static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
+			     struct mm_walk *walk)
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
@@ -678,13 +679,14 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
 			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(pmdval);
-	if (folio_is_zone_device(folio))
-		return;
-	if (is_huge_zero_folio(folio)) {
-		walk->action = ACTION_CONTINUE;
+	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
+	if (!folio) {
+		if (is_huge_zero_pmd(pmdval))
+			walk->action = ACTION_CONTINUE;
 		return;
 	}
+	if (folio_is_zone_device(folio))
+		return;
 	if (!queue_folio_required(folio, qp))
 		return;
 	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
@@ -717,7 +719,7 @@ static int queue_folios_pte_range(pmd_t *pmd, unsigned long addr,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		queue_folios_pmd(pmd, walk);
+		queue_folios_pmd(pmd, addr, walk);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.55.0


