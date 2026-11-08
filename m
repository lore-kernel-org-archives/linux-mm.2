Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84E80606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 08:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KkGdeozW
Received: by kanga.kvack.org (Postfix)
	id AC2B36B05B3; Sun,  8 Nov 2026 03:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D016B05B4; Sun,  8 Nov 2026 03:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EEB46B05B6; Sun,  8 Nov 2026 03:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 635306B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:40:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0055616041E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:40:46 +0000 (UTC)
X-FDA: 85411306092.09.CEC17CC
Received: from mta1.migadu.com (out-238.mta1.migadu.com [95.215.58.238])
	by imf12.hostedemail.com (Postfix) with ESMTP id CC68E40002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 08:40:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KkGdeozW;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794127245;
	b=x10rZPeUZ46MGqHHiVeelT9QYusLIiyl3si6kgXymRCXMx59lvbzRySjNFhmuhXQWaNNfp
	5poMgn25YOMSpwY2IvewPYKp0Gz6Iyr7QQtxr9oEvPmnoTjyFo+xK8CoH3Eyc4vhpycLEp
	V3s138j9817Ya9A2rnEhMRyPw4O2CkY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KkGdeozW;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.238 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794127245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYoUmexxPLJigYcrWiTOVyZolQmaaSPk22SDsY8yV2M=;
	b=eEqVxZYCi8CuI+Wsme3+5lmjpb4MnKl9K+fpaJqf+k+X5yVaozAnjRA2rebAIQ9CR/LODu
	FZZocsVEzVTLdIP3ac/TmDHDXLJ3jPjJXqxWajakT/JIl3iJ0cRUto/nIG9F3v/HKttVn1
	7NFx1TWvKoLqeqDSCB3Oal5It9p0GaI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BYyngODmPBf6+ONXmDqmz1GGGko3fLEGOZKdoUTwChM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794127241; v=1; x=1794732041;
 b=KkGdeozWw6GzIN8/N1hxwiHvUcHndwbzmWMXS7USNunUJ+FeltMBIA61FH1QyV1noHYwTZaL
 lqQnkwuDy9gYU9aZHZ0BwPRLdCkrMG8Ryi4wOesGVzbn7U+RHJ+Ci/bcrIJGcab1pufAWsnLlyi
 gr5PHUZgMheMxtfRnWLaiPRI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8756b258539f3c21;
	Sun, 08 Nov 2026 08:40:41 +0000
X-Mizu-Trace-ID: 8756b258539f3c21
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	qi.zheng@linux.dev,
	tz2294@columbia.edu,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mprotect: don't skip uffd marker install when racing with PTE table reclaim
Date: Sun,  8 Nov 2026 16:40:35 +0800
Message-ID: <20261108084035.85404-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
References: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: imcq37auhs3use3bz3aqeaj91k9symdw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC68E40002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794127244-315177
X-HE-Meta: U2FsdGVkX1+XlN7HE2pjsCcHyfPvONJiDg/LwarYiijrF04kYuc3za8TjHvKWoTE/JS/aQEmn4wgNLxjgDkV+TYcS5+ZQuZgQ2JzeNIC3w/vfuxYIbqGHEVWIho8eq27E6rqVLlKEO3q/ef6an1nRB9yJAhSDbp807UEPSgIS+F6KLiqeWRBlcmwqmP0U7Di5HgxS58E7elUlfgdaMnV7JU39yAy6eNAsscr+RgZcW3y0ADsakMCyP8p5kVS+rzZp4vIYPdBTSepcnsKO1STRl3XBmY8o+8EjskGoDpdwwG6Za2n0ATdGI4jDn0aCvSxNOropXmGvudOR6T9dlVH1xaLNv8o0j7h1lR/Qe61qK3dnSj/1XDsi6zAn8YWTW2NK9K5PgICeP4GygExp3GQyatkrHzqFsQYnum4tWHCoWpCPHe/rXolz5B5/Pg4IJ1WphUgPmdQ+Sg3RTpKviYiSQJOThbWLe1Qqtw4M0W8aNRFs7KTYJNlqsY2qZss8m1Kzbs5ufeTLGjvAIyFlcTPn+b+KktRTu4LNtF3hUkmHWcXrX81addGl+EsHxM48PVCk9QYWDK8yOe957/CYf2tqWyPePmsgIrQgsQKZVKnl6r+l9NdMEQduNS39J8grKc7dBJbnt4KuI5xYEjgWJv7sGZw3BiWvqPhHLOP0WUQ6mwlNp5TLlDz3vpl53Vp6I+mvBcDTakZn2odfJaAT/zsl0egmIuRZ0lNg0g+Vwp2td8ZHrWGx3cDcSRhtosrDxgBQzlOpeRhwUADbxF9MT6c1luUEVjm3kCYEQZAJPXjZaK8eobW4fpcwUqhmw06Xgfjz2OpLZrX0nJCsAz4K2WeSi+9y5uSftbppREzy80XnzbQZ0xGhLAb86vgG+vGcUQOatFjY79DsgJbJRm9UkjjaHf6yixfA5d3uyRv7n6pU9adIC/h/0X+jU7w2D1XlBctKwUuIEfEnKdUA6/1qmn
 H3KOy5J9
 oW7uGuh2wxYsmHy9r3bq2E4veP23Jt1eJT/OW8jorRlMyb0b8VhjVyzl0jpNneao6DCiLAEBJoHRGH7enRlfblWvRP+Xshz4ruJ9V7FeQ6Vi74jaxY3sF6QmkKlGrwT8xsxlViQf/d+rahdCfF4F3vtBuuFC/HfbW3sYfMIIsVwvlAvfvWIj8wtbaCW0AXrnHLvNQyXdvcLMiVISgthASbGum5UBaqK2n9cC0sMzNbZK+gKJax89IONcGZgivIaiHZ1LW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Nov 07, 2026 at 12:28:55AM +0100, David Hildenbrand (Arm) wrote:
>change_pmd_range() populates PTE tables before installing uffd-wp
>markers. An empty PTE table can be removed after change_pmd_prepare()
>returns but before the pmd_none() check.
>
>That check then skips the range, allowing UFFDIO_WRITEPROTECT to report
>success without installing the required markers. Subsequent writes by
>userspace to these areas will not trigger uffd events.
>
>PTE table reclaim during MADV_DONTNEED and page table retraction during
>khugepaged can trigger this.
>
>Retry page-table allocation in that case. Simplify the code, getting
>rid of change_pmd_prepare() by routing all code through the "again" label.

Cool, nice work1

>It's a small race though, so likely this is not very urgent.
>
>Fixes: fe2567eb5521 ("mm/shmem: allow uffd wr-protect none pte for file-backed mem")
>Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
>Cc: stable@vger.kernel.org
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>I expect Andrew to pick this up.
>---
> mm/mprotect.c | 48 +++++++++++-------------------------------------
> 1 file changed, 11 insertions(+), 37 deletions(-)
>
>diff --git a/mm/mprotect.c b/mm/mprotect.c
>index e18d4e12fc341..ef4e7188e24da 100644
>--- a/mm/mprotect.c
>+++ b/mm/mprotect.c
>@@ -470,25 +470,8 @@ pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
> }
> 
> /*
>- * Populate the pgtable underneath for whatever reason if requested.
>- * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
>- * allocation failures during page faults by kicking OOM and returning
>- * error.
>- */
>-#define  change_pmd_prepare(vma, pmd, cp_flags)				\
>-	({								\
>-		long err = 0;						\
>-		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
>-			if (pte_alloc(vma->vm_mm, pmd))			\
>-				err = -ENOMEM;				\
>-		}							\
>-		err;							\
>-	})
>-
>-/*
>- * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
>- * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
>- * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
>+ * Populate the lower-level page table if marker installation requires it.
>+ * Return -ENOMEM on allocation failure.
>  */
> #define  change_prepare(vma, high, low, addr, cp_flags)			\
> 	  ({								\
>@@ -517,30 +500,21 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
> again:
> 		next = pmd_addr_end(addr, end);
> 
>-		ret = change_pmd_prepare(vma, pmd, cp_flags);
>-		if (ret) {
>-			pages = ret;
>-			break;
>-		}
>-
>-		if (pmd_none(*pmd))
>+		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {
>+			if (pte_alloc(vma->vm_mm, pmd)) {
>+				pages = -ENOMEM;
>+				break;
>+			}
>+		} else if (pmd_none(*pmd)) {
> 			goto next;
>+		}

Previously, reclaim could clear the PMD after allocation and we'd just
skip the range without installing the markers ...

Now it's change_pte_range() -> -EAGAIN -> goto again (retry the same range)

And yeah, that should do the trick ;)

> 
> 		_pmd = pmdp_get_lockless(pmd);
> 		if (pmd_is_huge(_pmd)) {
> 			if ((next - addr != HPAGE_PMD_SIZE) ||
> 			    pgtable_split_needed(vma, cp_flags)) {
> 				__split_huge_pmd(vma, pmd, addr, false);
>-				/*
>-				 * For file-backed, the pmd could have been
>-				 * cleared; make sure pmd populated if
>-				 * necessary, then fall-through to pte level.
>-				 */
>-				ret = change_pmd_prepare(vma, pmd, cp_flags);
>-				if (ret) {
>-					pages = ret;
>-					break;
>-				}
>+				goto again;

And, after the split, we just go back to again -> allocate a PTE table
if needed -> recheck the PMD.

So, no need for that second change_pmd_prepare() ANYMORE :D

LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers, Lance

