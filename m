Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B061FC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941A56B009D; Tue, 28 Jul 2026 09:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F10A6B009E; Tue, 28 Jul 2026 09:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9586B009F; Tue, 28 Jul 2026 09:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 525BD6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BBC2A0362
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:38 +0000 (UTC)
X-FDA: 85038214716.16.F2469C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id B428C180012
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rcf96RD4;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OVz5lEll53DTcaxQJ/8cP8R7ptIKPY9VyGl2nqHKE0=;
	b=2nyU6Ya/LFHlQOA1gx+ebzNEgaZYocdR/Gg4q0d5StrFpPCkqDBpxjO154/R6ZbQkuvIY2
	zrr4Sa6tsgAPEHLSsKohkIJOglKbmtEZuOFdbMwi1kVSgq7hKTChVfMcIEtoSiIPcbntyJ
	9t7MeoGGLURIU9hpFxEz/lR7SG8LjKs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rcf96RD4;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244116;
	b=0fqDyKxvSa7iQOYhhJxBCb9qqkcDnNgCgNsu3yg2Js2I7adu3RfDIqeUI4LRvrYo2dculk
	7q1WITDd2KCpQemFu5OZJVVUVTfLgOC77UpUT5QeCSItb0Qoi6nTFUSoBnedEWELQfHomz
	bWT1v8aIpHku8kPmrBMsVv+SbojFCd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57E6260A9D;
	Tue, 28 Jul 2026 13:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB191F00A3A;
	Tue, 28 Jul 2026 13:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244116;
	bh=+OVz5lEll53DTcaxQJ/8cP8R7ptIKPY9VyGl2nqHKE0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rcf96RD4MNngx3FEnHTrZFFNkhXcxj9plMy2uiXREEcgAQ2xwXJ3JBPGHPvU3Imkl
	 OTkhHluoDWK42UmBQX1qNzZkwGvf6H/HS7QobF54TSAo73LGqtpd9AkkeizpMq8Un8
	 RVlrO6cRWoe0QCsw5hblKl+0QpzCoJippKn3/UuW/mYgM0MH/HwN9jEpAc5YnClb67
	 78oD4mXa2Az79fAI6xni4AfO2E/IdKTEtOK5vN4eiY8gtYdKYeRgulByQCyXib1eze
	 dZC/vGnzeCCHCFdnk4XuazAsfMauJk4xzAZYqfd3WxAlc93H9Mx1FIj8hPD1L+2/H9
	 5E4QAICDKo4XQ==
From: Mike Rapoport <rppt@kernel.org>
Date: Tue, 28 Jul 2026 16:07:47 +0300
Subject: [PATCH 4/5] x86/mm/pat: allocate split page tables as kernel page
 tables
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-cpa-fixes-v1-4-2ed2352300b3@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B428C180012
X-Stat-Signature: uffpqizgmpjghrhirrqengshzn1g4oai
X-HE-Tag: 1785244116-921769
X-HE-Meta: U2FsdGVkX1+tYmvQSZnG/QKGusPH5uMucd2VH0owGcAC6FbM6xDPKzu1LZpGAgNWlw8KOitMj/Wie2axS6JKYtow2sJ10wDo7KcJ77zjRjv35st9gsDfXhtfRAguoVCNoBxOVNn/zcp+3XwnUnGYianJLETSb7fsm9h19Q8BIcfJZlw2//SPdF8QPNIB69ir7LQsb8xVUSLRIZDck6tixCy/y4LnZObLGyPz0inNfuQMmTc8+fuqofmAp5+4VQPGs4EInl9H6CJnD2VDgNmJjO6BxlQJXKF0QoRlMfqCB8jDF/X3bIHxmkrpbw8X5cd+uRdn5TIr95FW5w0FV+tAe6EwyEUVgHNqalEavqORQs73IHFmnDhHj3A8SZj0PY4Can0SfcL9x+lkvYKZxhvdkLmMdPTC4xIyalNL6131WKr8QMaUGrsaDM0iphMXVVM8evKSlcnzjzsWvYlj2JK14L2Pol6Y6c9BgaJ2FXOemhxIzF2u+yMTu5xy0WiP3B6XFfCB5+FZ6byNsbZ49dv7So9Zao/ilQDY4fTXHUz5AFG5rWSjp3D2URGZe5EhM0xp2VqZ+ZFpw/IWj23zViHXk78vwSqzxUgTQcnvokcE2FjY+PNNoa0ytwcIXAfK420PxCHj1BKlkbskEB4YxbRLRG5hP0hTOZr+bZx4qNxOvWjrKhKkE8DlO5e6f7Mq4UgeFBz+Oi77WJ2chVYBYDPnEAqkaKHyOtRxU4HAzsibAjS9zpVEhqlrZuC3kKzqg4c1eQaPF2hH8a+BwMdmuh0vOYbOUrl3r6fOHtSgwftvmDWK6oVIXhYF9KgyNmUb0flogEuIhE19hGdKldMKggoarSpxHqobxSLMmtyvRAYAy+dP6ONxTaD6JVGz0+XqozlzOjQyhbmIEjTTEJVxzMKV1WpaHXE7uXD2lp5IRWAYLFQ3Z+DGnmFhrttQE7SUdLT+AcoRsZx4Gorxy24uSH6
 VWQ20IQ4
 d7rT21xrD5lBTlxL9ba19Dq6tw7QhMCOMlGRfTTMHGnhzvoojTF/S/EPiit6t3HB3NkSfqToO+1laBBiKKMhoBdJbDkm9XXokQ4vAr21gkApHFLIn2IsRE1pn1r0Ed7CAMStF3UmGQsOlKJ0KDWBSAjgR3jZ7Q6owwnCAlctU7B9a7aBM2UZvo12TG20OandaWlcVNvsEvf499D0z4uG3rVdNqtHEh89+NArjkMcsGi+vu7HEJ9iaYUB5G2W3fDapJww23xKj7wZgsOzF0iopiX1PyqnI5HVqr0goLe6aKALZtpynnGzjR2kVSrx/dCYsINkzpyDf+NeyUXY7czn7biXe8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

When splitting a large page in CPA in __split_large_page() we allocate a
PTE directly without going through the standard page table allocation
routines such as pte_alloc_one_kernel().

This means the page table constructor is never called nor is the page table
marked as a kernel page table.

The former results in the folio associated with the page table not being
marked as a page table (__pagetable_ctor() is never called thus neither is
__folio_set_pgtable()) nor are statistics updated to reflect
it (lruvec_stat_add_folio() is never called).

The latter issue of failing to mark the page table as a kernel page
table (ptdesc_set_kernel() is never called) is far more problematic.

Since commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
tables") kernel page table freeing has been batched and since the
subsequent commit e37d5a2d60a3 ("iommu/sva: invalidate stale IOTLB entries
for kernel address space") IOTLB cache entries for kernel page tables have
been invalidated upon being freed.

Since split page tables are freed without this invalidation, the IOTLB can
contain stale entries for them.

Resolve the issue by using the ordinary PTE allocation API at split time.

This results in these kernel page tables invoking a page table constructor,
and thus requires a page table destructor.

Since we cannot assume one is always present (early allocated direct map
page tables are not marked as such), we conditionally call
pagetable_dtor_free() if the PG_table folio flag for the ptdesc is set,
otherwise we free the page table via pagetable_free().

Regardless of which path is taken page tables marked as kernel page tables,
which now includes split page tables, take the correct route through
pagetable_free_kernel().

There is a user-visible side effect in that split page tables will appear
in nr_page_table_pages in /proc/vmstat (as do other kernel page tables
allocated after early boot), however this is a positive change.

This issue started being markedly problematic after commit
5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables") so
choose this as the Fixes target.

Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Vishal Moola <vishal.moola@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 26131ecc0e1c..1b63d4caba20 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -456,7 +456,15 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
 		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+		/*
+		 * Only early alloc'd direct map should not be flagged PG_table
+		 * here and those shouldn't be collapsed. However be abundantly
+		 * cautious and handle the !PG_table case too.
+		 */
+		if (PageTable((ptdesc_page(ptdesc))))
+			pagetable_dtor_free(ptdesc);
+		else
+			pagetable_free(ptdesc);
 	}
 }
 
@@ -1154,11 +1162,10 @@ static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 
 static int
 __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
-		   struct ptdesc *ptdesc)
+		   pte_t *pbase)
 {
 	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
-	struct page *base = ptdesc_page(ptdesc);
-	pte_t *pbase = (pte_t *)page_address(base);
+	struct page *base = virt_to_page(pbase);
 	unsigned int i, level;
 	pgprot_t ref_prot;
 	bool nx, rw;
@@ -1262,21 +1269,21 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 			    unsigned long address)
 {
-	struct ptdesc *ptdesc;
+	pte_t *pte;
 
 	cpa_unlock();
 	if (cpa->init_mm_read_locked)
 		mmap_read_unlock(&init_mm);
-	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	pte = pte_alloc_one_kernel(&init_mm);
 	if (cpa->init_mm_read_locked)
 		mmap_read_lock(&init_mm);
 	cpa_lock();
 
-	if (!ptdesc)
+	if (!pte)
 		return -ENOMEM;
 
-	if (__split_large_page(cpa, kpte, address, ptdesc))
-		pagetable_free(ptdesc);
+	if (__split_large_page(cpa, kpte, address, pte))
+		pte_free_kernel(&init_mm, pte);
 
 	return 0;
 }

-- 
2.53.0


