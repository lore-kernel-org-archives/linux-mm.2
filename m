Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C3E606A336
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 15:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eIVLEBCK
Received: by kanga.kvack.org (Postfix)
	id 16B476B05B2; Mon, 16 Nov 2026 10:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 143106B05B3; Mon, 16 Nov 2026 10:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 058916B05B4; Mon, 16 Nov 2026 10:07:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD7016B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:07:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AA40180138
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:27 +0000 (UTC)
X-FDA: 85441310934.10.5144FCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB702C0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIVLEBCK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794841645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24dnBicOCQ6PU4ccpK1L/KabNcmlceCnSlc0y8c9XPY=;
	b=mDUgN0p2rV6nQUJ/Gk2FgfwJhqTntlIF3o52xjMGX9eRpPcpljAfATYSLfs13QyPmAMtxa
	SoWoJ38v8DlsYT/RhKi2AElpsA07nSrC4lfisdD1FVIajethYU4HEn+lzezOfHtewfj/5h
	JcyMS0dqV815dJqM520TUSkH00UMtU4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIVLEBCK;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794841645;
	b=AVyT90wj3ZkE07CIoqAsxQZgMF42i0MLfw17QMs7a+khUG33nt6U6i1NmBJzxBVIFuwfF2
	rH1r/WegovPMAKqPTWGIm9gHK7cASwzk/DiUOYqM1upXbJZU+oJziARtbtACG39YYR68ED
	54RQmSF562LcbE2A3G0fFH00Vr60Sl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4339D62D75;
	Mon, 16 Nov 2026 15:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E9C1F000CB;
	Mon, 16 Nov 2026 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794841645;
	bh=24dnBicOCQ6PU4ccpK1L/KabNcmlceCnSlc0y8c9XPY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eIVLEBCKZaXYk+6Gsa+Dnak6kXQnbgYrTF2ZOVKnJTK53Oy5209FcWLTc09Kb8Qq9
	 VrCy4aXVquNsuZFGecpln6bZSgAgpZLDGJvN/rszeTNwXMiG4Z8byZIVr2PvD5px1W
	 h9vlnLauKsj+3EZ3K6rBZ0I2R/XedySwoUxfSGExtIK2Se6P8tiTVzJn6s6crreGDB
	 HglGs7UkGQbb1ywJVbmgEbLNPdLt5ipJn68r0zisZrR/+RiXFcVBsiZOixCrnSODVU
	 SuZveU0Jv7x/bQ82Tut0yaft/sgeHCyZZ+CaN/TRkOG2ckB9/yURGwSWJN7661nDnR
	 Ce3JKoEoBSdnA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 16:06:58 +0100
Subject: [PATCH v2 1/2] mm/mmu_gather: delay rmap removal on UP as well
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-dirty_file_pmd-v2-1-571883053174@kernel.org>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
In-Reply-To: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
To: Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>, 
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
 Ross Zwisler <zwisler@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3184; i=david@kernel.org;
 h=from:subject:message-id; bh=9KD+JeN6DdWJ9WBFO59zy3LWV7p62xtB70jlMZmuFgI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+y0jbTp8sf80hWcz5l4dA9MH2Ux+7MudN2tLzw4PnU
 li+2SWejlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACYSk87wm60veS1X7Deu/9VM
 hVWfX3xpXjeJI0RoRhO3dPij8kPbUhn+J8Yfz1954tB7HZeA5o1bA7pZ7+fFd4eIzdI0kC77Nm8
 dCwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CB702C0003
X-Rspam-User: 
X-Stat-Signature: i85ukwgbarwynck9zictaydw7ggmyck8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794841645-485828
X-HE-Meta: U2FsdGVkX1+VZCKwxrBTSXwsYPJnXPc4FuN9/KkjQz8FwMoLaaHJywFVqLRnBH66f1mhY+nR8QvGq+Ga4WyJyLkORnzrV0M9CiHcOVKckRtSg4f+qYUZe9K1XPUf/7xuqdqbuzyXf8KluJoDfAuE47fLSHhVKe3tHmgfp0F9nB6O1vcvUrHBn9pCOnusf0WJ99rHfliP7RjhqlhQS9GX4brnvEjP3XDXfzUKSDRPfTttTW3VtSs5SGo+2Ei+KOgZTQnyS67TpmPIkzRKG99wgLAJV37u/EYZjKMTXxlVNszFofMXfDn9jbToT5ax67li/yk14RQ+lzGZ9BMUy6PbZJiW//PRhBnEr0Pyg8+6kwAUQmWgJw8qRQQulRZOGFnAKw/fVMy3f5bgVVU0CPuCJszoBt5v/YCs7HdiTx8ixemJ5rMHWI7FtOq6F89bM5MsHJL3jnZpI53SgGJuxwzJ0TlrRH9DIAZiYKnaUjV1Rp4UKCDWn80MNaroNAytyTKn4m2wiy52jl7h3YhZBC2wLrgU9fWjr78d3HdpyZba8GGi/WPOLmC2p/o0ml+SaS/aMbhmqeHBREMhxitC/ny1Ev1bYcK3mUQ4BGwpdF3EA88+tgDit47t1r6H0/ZvoGKI1GgE76A95KEkzviZx8R03HuC7YF428lrBqKrVt0uvJRtLLM8dAN6Cwz5uRLDBCDF7gxPPBp9UpWiQVY9/zG42NRR7sCzrt2ovV1hxi8F9PovYbnrWS6GQ17Xxhw1qg4fltsWLL3jPyx5IICbvAkRvBe38tdnqC22MsJ1pkbL/cuWeTrPTNVvVCJ+Y/RtEt/sMjiellk65NMrMrsjOTsDuxC82vqpsRdygNJDLjcwTVwI1pVJgKODmvxtohMyQ56KWP6J3Djk9HdqCpp0KL8wgMFqbOWxRsfnsB0fIO9NYjup8Q77EBYmmEF11/L7/F4l/ngWfQcZ8ujrogRfQLH
 EysywlqK
 eTzmmuXdFnw3FQd9gtWJowMYoYLIa9LE4uga6JlBVZwv3K4KmGqp4XD1VZq74jp5wnZ6h80SzhsHkyp6wMrzhuvf9UFVgrueTJPizTfEZOdHahCbtyBY1ddZCHvFHV+QGq/0IHnS6HtnNrYTQL+npPQypFVu4HxgCQVhAog2q25MmDPuFBkN40N3zZYnw4xzd2hHruYEddXyWcb/CqDOJk18pjY6pZAkYHcmbbJa4tHRyYcXH9r8vZiccSRE/hq9E44tk0QA8PFP5ieWZcmcFti4swc/Y+tjlQKze
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB
has been flushed") introduced delayed rmap removal of dirty pages until
after the TLB flush, so writeback cannot clean a page that is still
writable through a stale TLB entry.

It skips this on UP, because on UP there are no remote TLBs (single CPU)
and because the PTL prevents preemption.

The PTL prevents preemption while removing the rmap, but the local TLB
flush is usually only performed after dropping the PTL.

Consequently, after dropping the PTL we could reschedule to another
thread of the same mm, which does not flush the TLB. A kworker could
then run into the original race with writeback: it cleans the folio,
but the other thread can still modify it through the stale TLB entries,
and these writes get lost.

Fix it by simply not special-casing UP. Now, only architectures that
select MMU_GATHER_NO_GATHER (s390) will skip delay_rmap handling.

Fixes: 5df397dec7c4 ("mm: delay page_remove_rmap() until after the TLB has been flushed")
Cc: stable@vger.kernel.org
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Link: https://lore.kernel.org/r/avrxOt_GyXLXNqtR@gremlin
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/asm-generic/tlb.h | 6 +-----
 mm/mmu_gather.c           | 2 --
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 4bba02fd5d543..cb087315b4e72 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -249,23 +249,19 @@ extern bool __tlb_remove_page_size(struct mmu_gather *tlb, struct page *page, in
 bool __tlb_remove_folio_pages(struct mmu_gather *tlb, struct page *page,
 		unsigned int nr_pages, bool delay_rmap);
 
-#ifdef CONFIG_SMP
 /*
  * This both sets 'delayed_rmap', and returns true. It would be an inline
  * function, except we define it before the 'struct mmu_gather'.
  */
 #define tlb_delay_rmap(tlb) (((tlb)->delayed_rmap = 1), true)
 extern void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma);
-#endif
 
 #endif
 
 /*
  * We have a no-op version of the rmap removal that doesn't
  * delay anything. That is used on S390, which flushes remote
- * TLBs synchronously, and on UP, which doesn't have any
- * remote TLBs to flush and is not preemptible due to this
- * all happening under the page table lock.
+ * TLBs synchronously.
  */
 #ifndef tlb_delay_rmap
 #define tlb_delay_rmap(tlb) (false)
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index e98397ac577c4..c022aeb7c84d0 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -49,7 +49,6 @@ static bool tlb_next_batch(struct mmu_gather *tlb)
 	return true;
 }
 
-#ifdef CONFIG_SMP
 static void tlb_flush_rmap_batch(struct mmu_gather_batch *batch, struct vm_area_struct *vma)
 {
 	struct encoded_page **pages = batch->encoded_pages;
@@ -91,7 +90,6 @@ void tlb_flush_rmaps(struct mmu_gather *tlb, struct vm_area_struct *vma)
 		tlb_flush_rmap_batch(tlb->active, vma);
 	tlb->delayed_rmap = 0;
 }
-#endif
 
 /*
  * We might end up freeing a lot of pages. Reschedule on a regular

-- 
2.56.1


