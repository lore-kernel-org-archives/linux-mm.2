Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A42606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lryRfQ1c
Received: by kanga.kvack.org (Postfix)
	id A975E6B00EF; Mon,  2 Nov 2026 20:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A482B6B05B1; Mon,  2 Nov 2026 20:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939266B05B4; Mon,  2 Nov 2026 20:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6564F6B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:48:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB59EA030C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:48:17 +0000 (UTC)
X-FDA: 85392122634.11.2DF7C4C
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf23.hostedemail.com (Postfix) with ESMTP id DCDEC140003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:48:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lryRfQ1c;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793670496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iOXPBKbXiJC+x5z9pBqWv33thiXEJKmUeXcLOFcLwdE=;
	b=oLd7tCdFQdExv2Ek/iB7lGpBdM8o/xJq43LWi59lpaAA8yfjETBrPxzXISPdtO2gRWLcGP
	fWvUYLyeMg75SLeiukPsGxNLA3XQHli2pZn7epN78wMPUIjI0lJ3HNty8Sv63Hq076C2lv
	7LWy7o/FsRT4hNaj+t3OaC5XcfH52Ac=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793670496;
	b=rqXUrSILLO7OozCYEkxn08TYUl2FAEanmFnUoA3+t88juRfGxbCYPJ0Iy3Iltdli47smR2
	yhjr//01ho92wggjmldplWwJWJItSRcR0GxUZNodbqihawh16kE2O6HSL1VX5ethllF4sx
	xS3i5ESHjIXJN4phTxYIhXmGra3aVUE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lryRfQ1c;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l+yyyXjUClB/Ds8IkW5xPsPcElS/TSAndXh2JoRAUFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793670494; v=1; x=1794275294;
 b=lryRfQ1cZniTi2IU2YTeuq9gtwbw0Abxvq2msWE7Te+GNv5TjZF0qB/2K4JvM+d7N836iuS6
 3fO4KrLo0ZsKPsYjiDnQRI5IrR3g+3kKiekR4gHjpKTEfTi1Jnql25uwJ0dkPAbiQ8jST0N0o6T
 Iw2HNEJr0GW11tHRvoX5OHG4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 00fc5a5f33a423e9;
	Tue, 03 Nov 2026 01:48:14 +0000
X-Mizu-Trace-ID: 00fc5a5f33a423e9
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read in do_fault_around()
Date: Tue,  3 Nov 2026 09:47:49 +0800
Message-ID: <20261103014749.96764-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: obqi948fr38fy7h4aum3wxrwqfnh5i6x
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DCDEC140003
X-Rspam-User: 
X-HE-Tag: 1793670495-957754
X-HE-Meta: U2FsdGVkX1+7Du7fnu3Jgx7ZOEbkZdpK2E9tpzwf77r1s2MVEIgbTIFWhWNsSgNyJ/Llp85eanxbgpiU0eMxgYEkn22JTXhnwdTKA/+elTLoD4BxbpxUgD28OP+vFWH03qh8loE3NcNsyRmfhj0iEIr2yn57qismvdOYUEuBU8dDFr6G8BGw4hFZVt6ASW6V4PqoQJn1WzIAnThNOGk0zHJiKTDm3Siu/wAM6BxSBTmnyreIdOzM7bDXK9Le2hHnVF38fNexT6f8BYo82LiVe7PEmGJpYNkL/y7rXTVFpKlReeyt9tGZBRKsVVUwLcsi1HQOL1FqrrzOCNX29vFHbDhE0MNSFAxU9ASwadWZJqtrya8N6Pz63yaWlo85TjFLDKHChiNYGuLuwpqvDP6bA6fEoSWLrlOLdJldrk8CqObPVys3CafAZAwQyDfdkVbmhtbS3sB3dtC//Pjt1g8C1WeGeGURtcPQ59E1aA2oAE19UVOn2FRoS3hADIzZYmHdhNtbKnmm0h70DvMYyV71CkfLtXg6/+ho0wdotQL+j9+tv2UtOL+6xOznHiDUmSOnwSfq7KEZ/oUH/PBJOrechbI+1QU5bybFLuitD3FA41g2mZ8qQTpWSkJqTcgaEMuSsVv/HamdcFA/alyMkCYgsShJb5iRm1TAih+G9dnX+A7bQ8b4/3bxJoJi9i0BBHtwoM05XYFJv0TsDFjbPS+LHV+vgdDaGRTnRQvHJ5h7kmu8Fz+p3N9PMjjC6KFKDMsM1bJiXq526O/exLpcyL4De8nsx2MosiGqn0SGS6RJXbhrS/C2zuy4oO+Gja5rRESs1C6onMxWWYFoGH+bZuv2bqfgtr1gghz8nz4/o0LM8/Ct4BrHhUW7iCtwN2g+N+Wuco7vezcDi08j5mn89N0vByXvVaPorN9wJ6WmVoluc/a6Apjaj3ZcUc0qATjGkLpK6RIaUnX6z0dBg9Gg/yC
 gJ+w+drF
 7lySbymQyqN1JG08rLR9BLmP7l+Irmhu+DRwGOvnMyWx06X2U+BsFwn6izxKGiGl3+z5xl0rUp4KmDE6lPGpQzEJiDEDBEqSGS4joPB/RzvcbhbPKaZkOq/ZxqIx5ehcWOnUAnAdFJJH/7uDogPzIfnPX8uPtEXQlqkU89QY9Frc9ix2GCgsFXF9N4S8wsVzZ+ybCGg6EXpR7Fanm0/z2gtuPZEcVPU7UXsxn9vFEeFIL1BVVGuUbwitGeoiP7b5iLRz7/T3ySfbk4FTbBwxaUi35XA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data-race in do_read_fault / pmd_install; the same code
is in mainline:

  write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
   native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
   pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
   pmd_install+0xe0/0x120 mm/memory.c:444
   finish_fault+0x5bc/0xb00 mm/memory.c:5204
   do_cow_fault mm/memory.c:5432 [inline]
   do_fault+0x5d0/0x6e0 mm/memory.c:5526
   handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
   __mm_populate+0x144/0x270 mm/gup.c:2207
   __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764

  read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
   do_fault_around mm/memory.c:5341 [inline]
   do_read_fault+0x162/0x670 mm/memory.c:5381
   do_fault+0x31a/0x6e0 mm/memory.c:5524
   handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
   faultin_page_range+0x227/0x530 mm/gup.c:2156
   __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479

  value changed: 0x0000000000000000 -> 0x000000001386c067

Both paths only hold mmap_lock for read, so do_fault_around() tests
vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
frees again, and a pmd seen as populated only makes ->map_pages() find no
PTE and do_read_fault() fall back to __do_fault().

The load still has to be lockless-safe.  pmdp_get() is a plain READ_ONCE()
and can tear where pmd_t is wider than a word, as on i386-PAE where
pmd_install() publishes two words with a single cmpxchg8b.  Use
pmdp_get_lockless(), the accessor for pmd reads without the pmd lock and
what __pte_offset_map() already uses on this very pmd a few instructions
later.  It is pmdp_get() everywhere else, so the report is silenced the
same way.

No functional change on architectures that can load a pmd in one go.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v3:
Shorten the comment to one line (David Hildenbrand).
v2:
Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).

 mm/memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd63..f25c2ce0ef153 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
 	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
 		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
 
-	if (pmd_none(*vmf->pmd)) {
+	/* pmd_install() rechecks pmd_none() under the pmd lock. */
+	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-- 
2.43.0


