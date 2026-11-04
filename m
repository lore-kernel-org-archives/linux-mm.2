Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C0D606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hwR0yKeh
Received: by kanga.kvack.org (Postfix)
	id 6DB896B05B3; Wed,  4 Nov 2026 04:11:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C556B05B4; Wed,  4 Nov 2026 04:11:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA906B05B5; Wed,  4 Nov 2026 04:11:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 24B116B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:11:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD32DA0617
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:11:19 +0000 (UTC)
X-FDA: 85396867878.23.44E3555
Received: from mta1.migadu.com (out-22.mta1.migadu.com [95.215.58.22])
	by imf14.hostedemail.com (Postfix) with ESMTP id 07224100004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:11:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwR0yKeh;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793783478;
	b=4mgyOepkySfoloy8LRX94bTnHEwy86eEvlDydfadmii8EuO9v0O0Nc+NklwrjgWfvf28HT
	a1/2ncxF8zzPPcYmcpl1jnk5mjJZPyhqsfuHk0Do0JG4ekfRay08Cvjbj1fVEQx5y6ZQ1r
	ypS5w5/0H/LRztqyZAbu2Yh7q70PuUc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hwR0yKeh;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793783478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lym/yCSp9IOZ33mo2Zonha/3NwdJfu2J/obLEkGbH4w=;
	b=294yhC79cJ3ili7c0EEEaO2gZMsCNc3A9T3prWwmOz/ESzVF3KlVFP1lk10FtBs9j9zC29
	LefQIoyKlEFqCKp0hs91YUG1Tbmm9U46utBIzXKeXXkExllgiPURFS3PJI12LDUwCswsKl
	6bgtDaR0uQqOBB75WBMoHFtxwpGp2O4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RMrOy4ebmI9IZjOcYQefm4hAy/GI4zVqN7pxA9iZQdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793783473; v=1; x=1794388273;
 b=hwR0yKehZU9Hw34Jo5AZUuH5lenRNC1HVfHZx/oAUYWTufVnM2mjV2bPqZ6Jqm1Qpy/qQ+N3
 sNfXlGatBoPPXpYAdJR3kYlHurk5z4b1sVr4LEbfr+5GFMVpXxm2PSjUSEEc0zA1P68lIsDAq0e
 1Yfzfh4Ern1p95SqKbKuDVtI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6253b911e0e229c8;
	Wed, 04 Nov 2026 09:11:12 +0000
X-Mizu-Trace-ID: 6253b911e0e229c8
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
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable+noautosel@kernel.org
Subject: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read in do_fault_around()
Date: Wed,  4 Nov 2026 17:10:50 +0800
Message-ID: <20261104091050.117076-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4neu83cm38pqquxjyc5r1bckedn3zhk4
X-Rspamd-Queue-Id: 07224100004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793783475-896225
X-HE-Meta: U2FsdGVkX18U34xduuzOZMTk8BR2cyORDvY4MCiJMWOrOkihsrd3bLorppGPb5j4Cfdek5bU8hRrNVbOC1AJkucDRc75xHkKWMlQENgNi9D+r3v13zxwxAfDxhQHFLyqJ7TG9M9nWEviqsc1K0CYiBBZXkBHPd0edl7o2iF57eRsSxAvrFdzjwa0/7vDJ1tpvxZWYoNOed1rnamtQhdn4ukkuyQtEibXC3j8l90fP4Sz2bdTKreYgUAuU63SIdlnWeEr8rJiZ4YlV6Xbel4JR2DrdrjfI/TPzBgU+t3NbMWjX0ldTi8DAReqWXlFPHzvcAf3rrPSFa3HOmqg0FkhBCq6dexrmObqj3EBtisot8VvxTUyjNc6I4U4KJxk54/lKMs4QxAu/gAu+QE5LCPrmJZj6n3fk1Qzi6L0tC536ifuTbC8OOLmemhlXL8nAQUQ7KCl7Dz1BgZ/ErMpyaafU7tPggQlc7pnyHZX7LemohXjTYzWO3jrf9FRC9/Sg5o8PiU4VldAU2ayK4nbtAyzYbns6MUJWaM7lC4zX+hqdaQ+6tC7GaXa7CnqJQosiRwIgcfCyIVkbP3ndUx32Sn0wE40xe7juiYMZhkjEY2+XNRQ6G7TNe9G/xpohFEb6zDMlg2Qef/BzMn3bhTARzt0beaEbqYPzwP8Zpc8elcFwLt1XbIJaca5KgPXhVbfUj7XtxeYMcreYrYcS0bQqvRbAxYTvvdU5/uKOIsDXEyRiiIa9l54zoJRZSKF2yjIyIn/E3Csc+lyoUTYM2Q3us+w9FxNrUbHu4F8VzpOBWUDUyfPkHgCQxtvL/jufttvyE9TEVTjfRj50NwIzxTLMSOZcIQDSDtO4eWtLF6y7crVslOn3VWGN28n5dFoWIPyiwJjsP2g/JLC+NN/Uy1JmI46mivgMC2yNlaIaQ9eWNDxVCKD4UuMfDPysZbG0NLhnBAIq+NO0J1hBCF1yv5onue
 F/Pa26p0
 CbJ3u3xFkqh3yQjF1FY8qmMkXeDpxGob7iyhWzBARN7RaqisYTX5xU8otw4MW/ocIzHH38+266cyorUrgimonQbLPHWG+qbx1sXsRW9V7pyHVG0EKSw1s0uNarj4zUJGw6cAMXP/tMMkfpZfca7gff6w/WQcky5NtSRszxkua436A3LoXhWGuXtD8F3qGMkJnIsDt3+vjvtGrPFQUbUs/SxRzDwsqKMeEEm7HM/fKpxK7pqFIqTUc66zCJ9o41XKzmfO9Ma6mec8zEpsNkTWy7maYrKUX4epDLNDIZdz/H/zNZ7bs7bGzVwuEurmB+/fJiQI4qj5IewZWbRUJp/nXQ7DrPUBI6JQMB7QodfhxHQHDk4IPnRFmYuriLiW5zZ+9X3EYcGebEednB/hetKkRpoa1KUcn4ajmPWDj
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

The load still has to be lockless-safe.  The store side already is: on
i386-PAE, pmd_install() publishes both halves of the pmd with a single
cmpxchg8b.  The load side is not.  pmdp_get() is a plain READ_ONCE() over
a pmd_t that is wider than a word there, so it becomes two 32-bit loads
and can return the low half of one pmd together with the high half of
another.  Use pmdp_get_lockless(), the accessor for pmd reads that do not
hold the pmd lock: it re-reads until both halves come from the same pmd.
It is also what __pte_offset_map() already uses on this very pmd a few
instructions later.

Only X86_32+X86_PAE and SH+X2TLB compile the retry loop, these being the
GUP_GET_PXX_LOW_HIGH selectors that have more than two page table levels.
mips32 with 64-bit physical addresses selects GUP_GET_PXX_LOW_HIGH too,
but is 2-level and so falls back to pmdp_get().  On every other
configuration, x86-64 included, pmdp_get_lockless() is pmdp_get(): the
pmd is loaded in one go, the READ_ONCE() silences the report the same
way, and there is no functional change.

Fixes: 7267ec008b5c ("mm: postpone page table allocation until we have page to map")
Cc: stable+noautosel@kernel.org # KCSAN annotation only, no functional change
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
---
Changelog:
v4:
Commit message only, the diff is identical to v3.  Spell out the affected
arches and add the lore links for v1-v3 (Lorenzo Stoakes).  Reword the
cmpxchg8b sentence: the store is already atomic, it is the load that tears.
Add the Fixes: tag (David Hildenbrand).
v3:
https://lore.kernel.org/all/20261103014749.96764-1-hui.zhu@linux.dev/
Shorten the comment to one line (David Hildenbrand).
v2:
https://lore.kernel.org/all/20261102093120.92654-1-hui.zhu@linux.dev/
Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).
v1:
https://lore.kernel.org/all/20261102031308.66177-1-hui.zhu@linux.dev/

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


