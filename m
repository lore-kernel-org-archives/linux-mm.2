Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D61C606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eqWuCZXJ
Received: by kanga.kvack.org (Postfix)
	id 7973C6B05BE; Tue, 10 Nov 2026 15:37:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DD46B05C0; Tue, 10 Nov 2026 15:37:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DD46B05C2; Tue, 10 Nov 2026 15:37:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A26B6B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:37:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B173DA8534
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:37:46 +0000 (UTC)
X-FDA: 85420370532.11.10A98C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id EC5DB180008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:37:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqWuCZXJ;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794343065;
	b=fNQmU7YJGHIkQiAzf7nu5oGOmJ3LPppQFeVBzta3Cn2FmUgJeMmWB1F6xKcekCYMpRAEiq
	Gr75Qg3geMpAX8ibdhcS/klqM2ROqg4Ihx4HYRyRxPrfuCsZMuKLW0eoirPM+1hKxNHnNZ
	sERvw9k1I0E7CN3eTLmrwONIocKRajM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eqWuCZXJ;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794343065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrSJEhIQdsnATG/TZUF9OCJMIcBwpL3C7sc2OmMxaig=;
	b=Icj1eByLRCvVfE5fqFQoGt/r/Zo9+zb8l9mh3C1LCf7koYmXAGxR+9cgubHTzZ37l4kGHm
	z2d86PyNdPDC2f+4rvVfYqxlwhCk89ihiha0Pd4rhosvk2C2/zS92Kbz4AzH3fe7VirLSw
	6N6PIPm9bAGgOLSEN8+tBc6GY+JLysY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7069E612FC;
	Tue, 10 Nov 2026 20:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF381F008A2;
	Tue, 10 Nov 2026 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794343064;
	bh=wrSJEhIQdsnATG/TZUF9OCJMIcBwpL3C7sc2OmMxaig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eqWuCZXJtOsZOej4Wnl3pn804Je0QoNGmJXam1b8c07SE5FueZ2WUt3/dBp8vqNky
	 0EYLnUASK32t0OJFcSDdyBROAYBEh+zOCCsr5mViX+9vYXqdfhlIbx58E9Tqjrb1MA
	 iDBSMjKZZGGT8BQ0HtIHj7QUJn3ICZ1siqlGeeqabHGn+/NHoFgwoSwkXLDBDRUf0u
	 hG2ChowSyeANPo6aomnttKJ2p8gnJaeyFVzAovb3NwQ3t/3uv4TDd8pCn/R6pCQY+v
	 3buU0UC6lwkjAUCS1WCtkW98WZiLxiofDrGsIS6hqy5AQdbZh4jO4WpgjIrGQ9kDCI
	 go4yn+eVGZJYA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 10 Nov 2026 21:35:43 +0100
Subject: [PATCH v3 3/9] mm/mmu_gather: flush pending references early
 before the folio limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-refcount_overflow_stable-v3-3-318625d63a98@kernel.org>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4480; i=david@kernel.org;
 h=from:subject:message-id; bh=4dJ/m1FVSvgW3CYjdpbAHjLF5sx3MyByqT1mM21gZhc=;
 b=owGbwMvMwCF2QOXvyb15Z08znlZLYsj63BDOdU52ZZZNSNXSk3m3zzPeZO3/vmzD8q3qWffb7
 bdlfVU51lHKwiDGwSArpshybV1OavCaVseyKEM3mDmsTCBDGLg4BWAisrsY/led5pFhDz4ldDDv
 gcl275B5gj66HusyZh2aPdcwdYe4KDfD/2SFsu6JXro3HCT/8UxmLF/+rv6QXMPiQ80zzzhWV1h
 +ZQAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: m1jt9dx1y1gcdhdueons4piuo8csxn3w
X-Rspamd-Queue-Id: EC5DB180008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794343064-917532
X-HE-Meta: U2FsdGVkX18LSie6NZ9RliIIxD3PgBGa3cYuUo0qsMeifybAnF5BFsub9i7fd/k6DHoTf6wfKAAIgt25Biaa0/FS3XT6k5qe/vbJawk7xNBPu37I63RszGCvpsyPe22apNyeV1sQBnyFw13ByyxeQgFv9uiSNCwk3tRdiKRPUUarjKan6B77TzGWg1hy4Acl5WBmdEGynSBsbQTvcq4cdICDassCcqwWtBMVRwGAvIwTzw99nfIdK1Qucg+1/BAcXhx1MeFsiUgy8326AlAxmQwUCeCs57igEqi9sg2h5kPLFlhkHuHrab7Kc1WORElacPdpaBWhSvpdAtH7LJnWQ9XxsATpTCu+FIVOT+Dmr4p7iDOMnO9UESF/PxllbeVEVR/Gw7YC5qnbcdCkdXfYuilNztkcFWEc4ADaYD6+dm7bZRmx1M3ykDpFS9fcgdFexpJdrLTgzx4ymxs1l4AvX46h9iil5ii1Uu84AHPIZodw6uEuYMHoxgY6zQiAORKP0GhFQdLsfcBV1PlVmCClxlRAPAlIXSE5VfRzyegkk9qs9P62ntqt1olqlan3o7C3AK2Gzk60H/1Q6w1kMcaYYi41RsIWqFv+S1E+wejijuAO8xy16256OFVz0FcsvkzB1//dt2XOkpCloWgkpVs3zb1ffkdoYYGxKb9wJclc07Ij1sJiFXpywX2oeWnP8pa7kdG7CIXQRA3IossRKAw84nyrm89dvyYjn4eDcTkBv7+InpVyTD2uG9yqRO0IH0zXCzhtZ53vf2IXrbboYDFJEP0Byac7JnrRr99EtuqEnodj6HgMwCnLBRRm8ZEoT6eoSEr4wqlp5xyN2JIds/58++4r9xnZUasrDq/upkiQZjOIVPqRNzCcqXSzXRojOzbKOO6Idebx592hVs3jrdfU7zslyzOkz4pPuWBhq3aeyDhCIBcdO2Nb865VZ0wFXozGhExxfV0FltOXICwpH25
 frufmhW7
 KS3+2ZaINAmFbAdcA+uyR5LllAWU1aYdwYe5YiMbf2yeRAJbqG8zpylGOW+qAfnwm4yWicuqqMq3/yAYfgfpWfFkvBhtEco5bGdoHguMw1vrB7PtQmbYQXKwk4n8r+RGn1ZPzdhf7QOrsGZ3Y/kIlpJDP6gcvrHNdd16Cg+pCbCqu8cC/wd0MYF5NyHXDzPyKx5vPCPY3d9m5YHnSrgW8LJxxQibACi9J/9meVD+S0LP0UNDNu34WMkV/BnzhxlkeP6srPDAMgaVDq/Xf9P342AkCft1s6ob5jul1T8Yfxays+eQiRrvQ/PKq4wfjVfpRd1R/ftuLiDR75Mn8zEIVZH+sZUEKKjTZKFZGF+AyjN85Ryj1Gw9cvECs/Fmr1mssMDjyJK8HxosryDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a task zaps mappings (e.g., MADV_DONTNEED), it can drop the PT lock
and defer dropping the folio references. In the meantime, page faults
can refault pagecache folios, creating more references for the same
folios. These deferred references can build up over multiple VMAs.

Let's just request a flush after enqueueing a pagecache folio whose
refcount reached a certain threshold. Start flushing well before new
references are refused, regardless of the caller's privileges.

When returning "true" from __tlb_remove_folio_pages_size(), PTE zapping
will flush the TLB before dropping the PT lock, but drop the references
afterwards. Refaults can still race with that, but flushing early reduces
the risk of letting others hit the limit.

This is a temporary measure until we have something better.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
Cc: stable@vger.kernel.org
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h |  4 ++--
 include/linux/mm.h        |  1 +
 mm/memory.c               |  4 ++--
 mm/mmu_gather.c           | 10 ++++++----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 3f4a180b48f3c..4bba02fd5d543 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -75,8 +75,8 @@
  *  - __tlb_remove_folio_pages_size()
  *
  *    __tlb_remove_folio_pages_size() is the basic primitive that queues pages
- *    for freeing. It will return a boolean indicating if the queue is (now)
- *    full and a call to tlb_flush_mmu() is required.
+ *    for freeing. It returns true when a call to tlb_flush_mmu() is required,
+ *    either because the queue is full or a folio is near its refcount limit.
  *
  *    tlb_remove_page() and tlb_remove_page_size() imply the call to
  *    tlb_flush_mmu() when required and has no return value.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 33bc57342590c..a36ff83589c61 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2232,6 +2232,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 /* Leave separate reserves for administrators and concurrent reference gains. */
 #define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
 #define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+#define FOLIO_REF_COUNT_FLUSH_LIMIT	(INT_MAX - (1U << 27))
 
 bool __folio_ref_count_over_limit(unsigned int ref_count);
 
diff --git a/mm/memory.c b/mm/memory.c
index 977e037388963..a1a9ba2430f83 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2072,8 +2072,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 	pte_unmap_unlock(start_pte, ptl);
 
 	/*
-	 * If we forced a TLB flush (either due to running out of
-	 * batch buffers or because we needed to flush dirty TLB
+	 * If we forced a TLB flush (either to release batched
+	 * references or because we needed to flush dirty TLB
 	 * entries before releasing the ptl), free the batched
 	 * memory too. Come back again if we didn't do everything.
 	 */
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 9f353f0e2ef4d..e98397ac577c4 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -179,10 +179,7 @@ static bool __tlb_remove_folio_pages_size(struct mmu_gather *tlb,
 #endif
 
 	batch = tlb->active;
-	/*
-	 * Add the page and check if we are full. If so
-	 * force a flush.
-	 */
+	/* Add the pages before deciding whether we need to flush. */
 	if (likely(nr_pages == 1)) {
 		batch->encoded_pages[batch->nr++] = encode_page(page, flags);
 	} else {
@@ -190,6 +187,11 @@ static bool __tlb_remove_folio_pages_size(struct mmu_gather *tlb,
 		batch->encoded_pages[batch->nr++] = encode_page(page, flags);
 		batch->encoded_pages[batch->nr++] = encode_nr_pages(nr_pages);
 	}
+	/* Flush pending references well before new references are refused. */
+	if (unlikely((unsigned int)folio_ref_count(page_folio(page)) >=
+		     FOLIO_REF_COUNT_FLUSH_LIMIT))
+		return true;
+
 	/*
 	 * Make sure that we can always add another "page" + "nr_pages",
 	 * requiring two entries instead of only a single one.

-- 
2.56.0


