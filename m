Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 181EB606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFQUvwiN
Received: by kanga.kvack.org (Postfix)
	id 1440D6B05C0; Sat,  7 Nov 2026 17:24:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11E9A6B05C1; Sat,  7 Nov 2026 17:24:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 033016B05C2; Sat,  7 Nov 2026 17:24:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C99586B05C0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:24:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5E28D1603E0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:24:53 +0000 (UTC)
X-FDA: 85409754066.05.6F549AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A821120006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:24:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFQUvwiN;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090291;
	b=squITkCJCWk7V0i5aPYdHhUsI16MMkMIHZebKhPP3W0+lo7SS7glXYEMOOoANkTrX37061
	COnLMWbAua3WxCzZGUa/71DhpE5g73Ldz06eXBmh85xzXmt4HRvaZYn007nuEegV127Wn5
	17GnxUbGEnSRYRSSNStuTuvN8Cs1DEM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LFQUvwiN;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChvObgSZX6lMK1ywqfm1FQ5rv1y59f2IxOWr6KIoUS4=;
	b=mBrDZ/ni2AbxYUsgCxbVSTxSUOgCT9E0rd4AdB+2Enj+WFp7YHXvdccaT1rERvHnOzejN3
	DFAhG+F0B6C5hRlsXgY0POCDonwHV81FUfSouI5BJQu2nQfbLXkfKLD+F4C2hj+G8C55gG
	Ih+IaolqC1+bHdAG1zZsY979tzZ0tus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC09141859;
	Sat,  7 Nov 2026 22:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3094D1F0089F;
	Sat,  7 Nov 2026 22:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090290;
	bh=ChvObgSZX6lMK1ywqfm1FQ5rv1y59f2IxOWr6KIoUS4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LFQUvwiNVZThez5BKvs/byytzWVHXpnvr0clZaSgp1BqAnxupVKMLUiycv61rAKVm
	 lbcSq4er0/uk5Pfif+U2AcvisqFkzFQ7SgLul5sLMs0dtyoABMC81AdGNzCGW8JN/p
	 pnLIR76cCb+vixay5h8poDRl4LrZiHNTa6GrttQ7JFZdoWe9X1sbIE/3eSDcA0vmGJ
	 4dcOiJG5ajAjqIUd9zGV+dFzrCw+1Y5gWQSMGajKcOLPJGfk+6IG14iaC08Ru/6H5X
	 ioENDzOC8ITq/9CrEh3ZlP+uJwu2ymSEd5zbp9FA8PtRm8tNhnKI3fzTeq4p15wSyj
	 e21YtIkbbW8LQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 23:23:39 +0100
Subject: [PATCH v2 3/5] mm/mmu_gather: flush pending references early
 before the folio limit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-refcount_overflow_stable-v2-3-c38f6809b106@kernel.org>
References: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
In-Reply-To: <20261107-refcount_overflow_stable-v2-0-c38f6809b106@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4480; i=david@kernel.org;
 h=from:subject:message-id; bh=Px/ifTGXsbGg/iI1MfuuKHy2AVf2TiWnW0EXsKLITkw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeL2U8mqRsHfh8ab7s1QOx3otnzN6nFbb0XmnwRz7HE
 nuJvAkaHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkcQjDPzuZ6BBlx+9+Otwu
 lW/Tf9yZUlwjpWS+7Jvpt6S2sh2/4xn+B/f/2WlwJP5d9o7WmKdWzHeTitZ/2iuQujyskP3KpVt
 +nAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: jnf1ac5qagoj3q9aa3mxi7fu9r7njk8i
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7A821120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794090291-135718
X-HE-Meta: U2FsdGVkX1/rd9kgVIOiGw5zrZY3gtIEmM0cM3vQoA6IXnoifhkdgqe9jBGg50ZkEq+k2n0EdxhZYwMbzpFCZMQ94GTDsApvDbx7SLZ3ID3imlwx+vWuvfSXaPxWNOAnZdknHQ6Cqro832N+RuzP7UtEeOePow2Pw7h9HoLxhjsepFVpx4s+0NTCvKetAzvCYP9SG2dL/KMdVUkzrewBOhqxZg/FzGJEP76b8QuVq1oZ3JLlaAHnEeIAHv0OvKwDV0sWc9yOKiQnkRtCFXp6iHmmcTyRsUi9eo32lJlz90vFwlFdpoIKeVdKsZ+rbptV8H8tAxf8S7rQdIHHxsdZmsHrynI57ohsshsuRrUrOFRIcrg61RQGEV+m1UABeFGrKQXajX/UPdOinC2dfHGprKZT/eHub141z2NaeIO3zZIscaBFJPzBf3fVAQUqpKZAO7LduTf3WzhFJTpo7g1sW5QkFKUDYwBtWD8BL3KVn3P344N2OE3GFr4RMQyZFOnrB87uWynXbI50OlVpi+be2F3E1I6ULlJeSI/Y+zAI2r8HthpIcn2N5y6ybUTOpd7VBXlND20aTLWenAwTHY0XTtjd6u32IOdTGYIJH9zEiqjmjwk951iDJvUcyGK63R6tQvh09R8GNM7hfq2bdQWPG5hh/c9d4EB8gTPeJEh01ZFnysUEogIypL8u/wWSzr2w7y0x8BIq2dYgc/R0pw3qFMLQMsEke5oiWuFkJAMagSjLYz4qcRgUTN8CveaiMj9dNNas6p/Ymy33eHqpEhygRB46zucsfmulGM7ICejAszUKgLlJkT3bGtKRuoRCwK/m8TDKymSBaIbAXzzeV1SaiFqCLSdUuli6VvQEuCN81lyXUliOj+375Pa3cu7vswE8a3kwNFNip15kG3uw3sVgjHpfGfS4oCFs1oRwKvz7QNuviReFTjU2f/SmlgDgnRkN4l3UW6xN5chp5TAF5Ey
 r2OihYyt
 1BsWiH0CG+X6EtLhN7b+lOZPR1qwdeF8s3GDtrrsdESMpDLvHnhnr8FtbYc4VqPXol1kxDI3nIIk7ak9DJloSpOZ8VuXCDZ0mXvujrykClTnLdJp1YG13jcMNn7R97YoZXwYcRM7Yl8Uj445Lu46UbyKl2IAXMy7aFM0g2iu37aGmZy3EAxvCfETUsYopR5wj73Dpu3nGO/Qwk3iEO2UNnC1D4sCunRFE3hrvpg4zI3WwlUhmt9KbxSo8+zGWM5cY6qlTwZcT7ZLpQkh/g+1d6NLp/IP4Y9j1vY49AHqtfGUr1WOzC84VfYJhd47RFES0MPpqBPv/FmUxQkn3h/b8ccIaOY0AV4muhI7NsBj+00xNlz56Lx5ep23FJhVyKJ3QZtAt9jtIUDfHHM0=
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
index dd50262a70758..244bf5d441a64 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2235,6 +2235,7 @@ vm_fault_t finish_fault(struct vm_fault *vmf);
 /* Leave separate reserves for administrators and concurrent reference gains. */
 #define FOLIO_REF_COUNT_LIMIT		(INT_MAX - (1U << 26))
 #define FOLIO_REF_COUNT_ADMIN_LIMIT	(INT_MAX - (1U << 25))
+#define FOLIO_REF_COUNT_FLUSH_LIMIT	(INT_MAX - (1U << 27))
 
 bool __folio_ref_count_over_limit(unsigned int ref_count);
 
diff --git a/mm/memory.c b/mm/memory.c
index 7e1cdaa80b75f..9d474c16fccd6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2074,8 +2074,8 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
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


