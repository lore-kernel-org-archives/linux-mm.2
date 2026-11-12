Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75D07606A33B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 22:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cScRwwZn
Received: by kanga.kvack.org (Postfix)
	id 44FF56B060C; Thu, 12 Nov 2026 17:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427646B060E; Thu, 12 Nov 2026 17:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F256B060F; Thu, 12 Nov 2026 17:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09DDD6B060C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:54:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C6E6140D8E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:54:38 +0000 (UTC)
X-FDA: 85427973036.19.7ED17D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id AE97040006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:54:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cScRwwZn;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794524076;
	b=W2DwhHp3as980oS8tIlHxFSfXxjqIM/OaXjCtHdVcePl7rx5xtkQaUy7dXf0uNJMw0iWcU
	YH8RVtHRcVTkgiMIfTO1IvrDzjR68GAha2w7N72kXjmAVhzNI2n556LRfbzFiqjHfL8Gwx
	qnRrky2OcTgWM1hbaLX07J8LDP3oX2I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cScRwwZn;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794524076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1dZH1YvZhyh+cLEFUJEOBrlUWrIfda/lmT3nY2eVCc=;
	b=I6MvQuKvVpZLm6oatWqAo+rSkIdwFyBQD+Owj4enIv47I1jYV6pelIf47t57M2EMxyvHig
	iIKEfUn/gDDyXS2hTj3X+S41mNas9vmOjKLXt4792gVF8U/TjymoBy5yEu/8fCdcbbF0zO
	qeBjvVFUwA8K/emSF8SWkMU5SKUHygo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E3A2611DF;
	Thu, 12 Nov 2026 22:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8901F000C4;
	Thu, 12 Nov 2026 22:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794524076;
	bh=K1dZH1YvZhyh+cLEFUJEOBrlUWrIfda/lmT3nY2eVCc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cScRwwZnVKDY5k4lrXJBaqIB+uxLEnAOvxE85WolNlWGVAsRU9h8PW3BRF8n/DndM
	 9HA2xConM66zJWXUn9LzGQ/yvWkswzV8ZshsXzYDkT52bKq/w8vamAhe/si8Wr73Q6
	 zh63/N5jHEy/4VXmBqE7HBufCnJWZaAp5XtF3Rz/nOzIo3v/B2W0fVuIsff5EYm19Z
	 8KDxl4709Kgpu4wP0rUR8p2GV/N2rYxOslykEnED8R1B7rtgNxXIJVBQvmzdizikA0
	 B7rNwI/wmDwlKmP0d99vZ+Os11k4ujZNf5N/9+fdPhYQ6w+4ALN8vBGF/6HwqFTfiE
	 8Paz4LbPqFjFQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 12 Nov 2026 23:53:22 +0100
Subject: [PATCH v4 3/9] mm/mmu_gather: flush pending references early
 before the folio limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-refcount_overflow_stable-v4-3-ad3deef0bd23@kernel.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
In-Reply-To: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
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
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, netdev@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4551; i=david@kernel.org;
 h=from:subject:message-id; bh=M6ZE0TzsSadI7DldS4FZfDzB4hM5y3s4Zcai47p6Ir4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLK+OWduvClSHzC3evXB9Lxt78xCsy8tnX7iAfebyKv7o
 54JGJ3Y0FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEuL8z/C9Y+PRZek/930u8
 28Q3x/6aw+HzmDdG0HehxbomVkMPaz+G/znuRwKExbaphVsrmf5YcP5J553Tduz7/+Z7CF7LlWZ
 k5QMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: wp74kumddizq8qka9w6bktmdga33f1rb
X-Rspamd-Queue-Id: AE97040006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794524076-159007
X-HE-Meta: U2FsdGVkX19qQd0p9nfaffolLXh5IIB++E50o1pex7xGTmTCFfuBeUHR6W6MLHs62VWyOyp7CoKIb1KQWJqyyBB97O+fwmv8CSXGc6waFni5qK49m/7NYc31W1OcHVdAsqvXpJXRee7G4q8CB28b9CY6S8qqrOsE8dNXb8IJuHBd0y5PyJMyFr9ddR4EhwrvY1Yv1NrYxJ33wn9hNFDN49/1dQNIJJOSG4ZuGVP2MQoOEn8PIxxyMpCP+PAhLLl73tZ8oUJC1aK0o4TMxcBW9ZjHPbG9xPu6j+vGJ4EPX5+DV+mf7R4Zh9pUgwMER+JPQ+xglSj2gtEe4i0nn1ICBUpLt7AzjDadeH68WVZGEPe/wsZrT9OrwZDRnQEqlhW7oVXwNW4Y5ZfQZEaPiJeJHefTgvjubxXctE+aFWjhXw4IHtyIGzt1xklD2yJC/cfPAJJgOnFiLEA6qooP7aQOD73YdLmOR3Mf4Qw3hLCQjaJtoR46FcTNmrpZBObYpMh9LIyS5K+z3Pw5au5DD7HU0J2neHTFBXgiyBGBOMHrZTffxcgAYPGpVTTnTK2WdRkVtUAPXst4UnNSAvXN23f0aw8U3ABV+brU2eo8e9Vtqi2HDCpuxg6GcKfkdRn0ub0+irxcJ0b9a2PN2odyFnEhemU8rkwI0jcQGBCOgv4X/WaCPoGS/lbFM+G7xXK7QmS9Xqn/qZdqMJnmUnBGDxjM7unjf9FD/RRf79CCD6Ay4v0WgwixHEbhjz/fx2/8nsVAz6xGLStYF6BOkSPIPzbnzZLiL8gmk45i1NlQDh2CPJO5wWj5Bej+kBOePAk7L9y0oRIreF7b0g0y1rLZiJ7IaG2V4hODRbzcEo8PRVwjAKOTKKYMxybFYp5drSan5Kx2xLyLfCtP5WF6tkVenR0fhyJoZi5RpesTdgZnfXm/Ii4mES0o9h3xI8f6wJoFcrzfKPfbIe9TRDwKS50R4G1
 oyPfLwq6
 lvbQraYDDwE1ZghbuzWHKQE9xwF6oXyqNfafZG9sj6ENfSS2Zf3/5Lzj1eH1kgkWSHNz6XrXoHj2SNnR9+DlIiIA9nfb0gN5iwIrmCsANXoKnMMIi+i2Jbk92FESNnOwTWly2dKY9oTWJGocqd04K9hIKpz/StERRuDDiHSul08a46UUXgLKAvKcYefJfeRW5i9w4IPYcySQQT1zb+NqHmNcbLciepdF94G2k18LeC//iiSVXYqZsuGBtP8Q0Ceap434uZGBod9WqP4C9Ml8vo7fr5g36zzMLB+vki2zh2V/q+BtECVRPIKWkigYXg4JeUVuEywByusOX5pNSC4WTzqm2pryZxltO6Tltw5cgZqm6I/MOYSHej1y2c3AHTsTAAWZa83qOZXDdnT0=
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

Let's just request a flush after enqueueing folios whose refcount reached
a certain threshold. Start flushing well before new references are refused,
regardless of the caller's privileges.

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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
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
index 383a5c2271d6b..0d00fc1838a01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2232,6 +2232,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 /* Leave separate reserves for administrators and concurrent reference gains. */
 #define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
 #define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+#define FOLIO_REF_COUNT_FLUSH_LIMIT	(INT_MAX - (1U << 27))
 
 bool folio_ref_count_over_limit_slowpath(const struct folio *folio,
 		unsigned int ref_count);
diff --git a/mm/memory.c b/mm/memory.c
index f473df474f1b8..855d7d82ce9ce 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2076,8 +2076,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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


