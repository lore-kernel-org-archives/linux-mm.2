Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEB1606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 09:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bvpJK1r9
Received: by kanga.kvack.org (Postfix)
	id 4812C6B05B1; Mon,  2 Nov 2026 04:31:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B5F6B05B2; Mon,  2 Nov 2026 04:31:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ABB66B05B4; Mon,  2 Nov 2026 04:31:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4076B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 04:31:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93B13120C6F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:31:40 +0000 (UTC)
X-FDA: 85389661560.07.6F975C8
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C00012000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:31:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvpJK1r9;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793611899;
	b=cvAH0XVZI65fwzB2Mk8RDjuzPK/Hd7ao/RmHrljneUmhYX5xso+6KaYspSVtUowi1Vd8dc
	KHsDVjEBg0XakTfd+V8PsRMS7OaqQm+4BdFV6zmgMaW9f3skY4gfMK9Dfw8UDcSCUhuwKT
	NBcRvTd2p9xVuzblE6Iy49mfNlGFUYY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bvpJK1r9;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793611899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dGC7LEFGpEc2S3IQxReMLZO2J56SfyOh1sglqK/O04s=;
	b=Uj3Vd+5/gOID6PM/+7pLiafv+wKpMaRSmoKdYld9wbrOD0MF9wTAr4tH9ksoI0UNG9GE4v
	MuLH7eKddAL1kMAh4s+N4XBk1yFFmcOewRAAzVLrykzS+MhFWDc1S6XVp6fXVDYeyA8gc1
	YwjjXsjErgBqQdrZtaEYoKYuH7QbGUs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cNNx1gyu5XHbiuYT2LFKcpZRDps0KmZGZTeNkOGSr0Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793611896; v=1; x=1794216696;
 b=bvpJK1r9142iO+BPxC6LcvdUI1c5Hp2Wsn9W/mhA0mIkWaX4myyCdDicK08qtbN21NfI6wKI
 Y7DGpBJ43vpRUEVW8+M0NTtZEqkgT6X0qwfS5/72xZOxT0IJrnctyh5myE5ndUuB2/2qpYKxzxi
 3MT0hrMUIVek7DonGQjeAkBA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 8837f745f0425be8;
	Mon, 02 Nov 2026 09:31:36 +0000
X-Mizu-Trace-ID: 8837f745f0425be8
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
Subject: [PATCH v2] mm/memory: use pmdp_get_lockless() for the pmd read in do_fault_around()
Date: Mon,  2 Nov 2026 17:31:20 +0800
Message-ID: <20261102093120.92654-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C00012000A
X-Stat-Signature: 17bhuur9gndw63sgpwtjprpsmfk3r1gq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793611898-683763
X-HE-Meta: U2FsdGVkX1/h0Q8rYdHGbRNxg5mUqa3aIahuQKPNEjteXlTbRZxkrlWxvMiSCNaAoM7St4A7nXpw0jR/Fe6kxWo/xH9gyvvL12Z2OOyc0Mygr3hbIJ73PFOjPwmrNgiKf9yv6BKTGe3yBoZu9WkD6pq5J1AyR2ICrEiRqUTklAFXNv/KxPgtriPMbBE38em2qEOZJdpTCxYQhLEkaU8fh4p6fWsPwmG2qeFIubVfaogARjE2YDmoblhYsVCnWMf1mukdurTI1GjltrR8Lw/X6JFx8jRzCEGVsTaHpMSzEJaAyXX4LyJNxdQD8BAeKNbFLJT4ny6Fzs5JVuRXCJW9eNy8jyZcDKoD4caSaW6Ds2jhQA5soFwlTuLRncL3nZoR+W6I194vpTgiMVS9r0zw4FqSSEoCv1jt6y4YZLQjDWLmmH5WSdbicaIqREHrYe9aek8tlTVc9B3mzKr04ACcNqMrXm4ghkB+Dy/NChSwxUjNcJZf5hF3+9ECvcTfj6ezRnMosnE+uoGnd1GDAgCC2AOHMi0314zMiCHRMqgT5eiZv2/ipdTDvXNhlw9mwqD9v0u2lbDUR+dCtKNBVfQG08R0rUFZZl2FoAZku8SweyvGwqpyAjt8fBQ8uuXH6ubFFMOPLN/oP89F1/tfAoSrAoRCd0j2Eq3UFsTXQIbN/VJVFGzbfDdwt+etyAaYIdNNwsMA3iY9l2+0jLz0IwktTQBSvYZkQgwbDkTCMhJzvsXHlWtcMmYm/++AVTem4Fc4OdMvorORvBWdrlJg/ceQT8DdYQiKXrjtr2vlyJsQUCjfMkGvBlRqqCSf7H03lUpGi98Q0ezq3nWlY3zVabjyuyM1QjT1+wkyQ1hea9Qt/houaMGnDJpfizgEbcOgGgyVftTqpltWSzI5Clcjorc7SWFF3NhC/USKNFi/w4vxSr4EsgiULQjdL2FY2uz9RTw1+iJ3OTaoBVZkc+dfUlh
 9o2XnVyb
 WTPiXtFwS2lhMAJg+DLVJXW2HydvvHSmxAb8ofHyIuLeoW6BebxRu2NtuE4Gpx/zvtR28ZdhUNLAUIXQPVwcWo3W/eV83EUJa8gQBJZV5uxp+b+Q9cc51aaV/8YuXIjOlFPcQfOdlnPvIBqu2w5pVrBYo44Ays9OU2RjtZ2MLWQdkP0Z+p/X+KQmhFd46vogN5QgFQz8IKGaDqM+2EHGaf509ZaQjYwxUGOuws1ikLtm7izZELAeoN68XsGEq1xRDO9YIMZ9ymNOxbq/rO2P7T12sQg==
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
Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).

 mm/memory.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 0fb676dd2bd63..2c1e50b70faeb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6017,7 +6017,11 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
 	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
 		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
 
-	if (pmd_none(*vmf->pmd)) {
+	/*
+	 * Lockless: pmd_install() rechecks under the pmd lock, so a stale
+	 * pmd_none() here only wastes the prealloc_pte allocated below.
+	 */
+	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
 		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
 		if (!vmf->prealloc_pte)
 			return VM_FAULT_OOM;
-- 
2.43.0


