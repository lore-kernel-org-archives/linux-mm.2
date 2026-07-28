Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04507C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26786B009B; Tue, 28 Jul 2026 09:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD73B6B009D; Tue, 28 Jul 2026 09:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F0A6B009E; Tue, 28 Jul 2026 09:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74CB46B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE3E74033F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:31 +0000 (UTC)
X-FDA: 85038214422.20.C54E750
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45D9BC0010
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOfKoJAH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LsA8arRtHhtoIfoxT2QqMXdENn8OvCqaWSTb0wqbAxo=;
	b=wFJjh6YyIS80oFIYxwnDSYKhq9PAdpkqGcXH9/1maeOt3IqrCehqeTCCrBTEX+m4rCxfg+
	y3Dn98gsoRF/R3OhqwtRDKWYueJyGmVC3gDQ6Rm8kjKhaVVCwh7+MwXJECfh6jwsG3pgiZ
	7wJABMC8aHZ9umA1wUbgY6AAsaDHBzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244110;
	b=DWXxkAMymBz80Xl34DACgy77apqRh7L7jYYHfJy39k1FrIOOOo0WiMxrxLjDaAuEXxxjOj
	Oxf+Kt6565D83xnxBzJMSJmqp2J/hNd+fKlHVulZWCrNM405NVDh0Lirkn/wmUWyjZmDra
	Nn7pvbv2WBKCOZTQYwmXqEM2NswC6Xk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DOfKoJAH;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEAF7600FC;
	Tue, 28 Jul 2026 13:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825741F000E9;
	Tue, 28 Jul 2026 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244109;
	bh=LsA8arRtHhtoIfoxT2QqMXdENn8OvCqaWSTb0wqbAxo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DOfKoJAHbylHDIbFreZC+aYFGdNBgempcgIHcCIAPazGeaMMd15230ceAAP2T5ibk
	 cVuDWWaygEajGxSVp5omHB0PmKjECO8ejLnicPRUzBTWBz/CEg9x5u/uwUsEsvatso
	 u8vhR/aqo9L3cj81ZomnaBgl4h1hrYGQz8/oTCMkBWtO07B+SfrgZedgQEnjoh1u4x
	 3w8YL0dzLgCG7nOsdsqnD6trmyhUxJRVJgRS5lmZXBRtI64CIh6kJ7h2YYcm0cJzA4
	 zK3UUpFDQ3OxxdgKIeXfiGGd8gzFl2MJDdjQ7Z8v8H1+vnVTQ/0jQ30qWO4KIBUkj2
	 jklNSLN8qQ0vQ==
From: Mike Rapoport <rppt@kernel.org>
Date: Tue, 28 Jul 2026 16:07:46 +0300
Subject: [PATCH 3/5] x86/mm/pat: acquire init_mm read lock on attribute
 change to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-cpa-fixes-v1-3-2ed2352300b3@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 45D9BC0010
X-Stat-Signature: 1ueunzupp4juaqrs69pnfuit3yffamps
X-Rspam-User: 
X-HE-Tag: 1785244110-327348
X-HE-Meta: U2FsdGVkX1+T6fSKucQsVsA7JspiUG38Q8ndqDAKkV7KFpFV6gemokRoeThXK1eQg6AZUXZWKqKDXYEHoeo2Tfj2p7sA2XFCuqBKuvNX0wfR4kO+iU2h/eu/VyHC3pQwZusDIhwHSq82WFkl+w3Qj761H/uD7H0BojJj/w5Gaz7G6/yp2cdx00ZO7Hxm5QOBEFxOZgkZ8ExNKwijZd3hubxrfY4y4gLKwjp3GWlN8We1QycjI5QV/ZkOMzhSUF7HBcnjwLr8dWIvtm/iUmOwkP2mUSzn/hmq2qAx+WSGOQIzr4mUFQ8pH3LUYLo/QgMsvda0Kr3rh/kDcIo8q1ALbqyQ6As2EeUf/KEYCQuFqAzNeGqzN+HdfQFvciXXopBh6T+8/okLdeB6Znwj8vovp7Ih+f86FbpedHZQLI0TWUjKcHHboJD6ZHDrxwHnEyQ+fBoTuIg+z+vPq+9Q6spDdLzB44sYE9ANe2KKtzbZ8Xxa8HdcQWntHjm6c267L57exLyAPtNNn+zJGf1vSIP0+mZ9jcd2U3c9gwo3AsgiPsKR9HeBT00ma3fUu/u7INKR0G9qz0akf9ok+x0Tzgbi9GktzCumA9PXixSeefz8bfTjjgOborWcy+Cq5Qx7FZCpgL6SaxJNVFf30UoDAn640OwpE9nCW3AjYyB9odMV8o7kZhWTyVe0VM6ps39DS7Mk5VzZqTZkkdZFzifXRKFwSIUe57mGRciigjILo9SY9/p8L/4LRcwtHu4rGl1iu+v4u9GLZg8WpbkLL7OXxE6eAKK9gqHlWrFTb6q1u11TdPX3tTrLfZYxCxsXSrwd+jgn/OSvz6Na625+y0BvRzM+Zidm8QaDMZWaRlB1nR+MOVzwABb3DehQG1sR6QktGsFLxs8LwjCktytQBIDc2t6jCmjqWoxFqmhCt3KaYadDFPBi5zYO0wpRsXRhr1tpU2UHkDFQWX5K14YdQ/nYf4m
 +/w7krU/
 AaBUAYHCmU4Wmb3jLARaVoBuTMpQD1lvl+8/FiNM8J2DddMW757cUmzCwSOEccLfkk9C9YlBKug9EG6gXrlrjBCHlHvb+h+WlAimOdlI5O7hwEEhYtZ4+GVxWJnSt25kisX+kdqDnWTmuWAPBDL5wd+6QiTEH+8V0dWdNHPKe79ksd7uaSz7FiaZ1gwdr35PR5XmpaChLsY4Iz2wtnUQmduX3eeZLk+kITHAhuxsXuTKEGGQfc0UQzN0cCvq/47dkUVF3rn3DBbng6LtZeLZd/lUeERqhH2m7X54PizjKSjTa2C1yl6zeNYczwZA64ug8eVH8nTSkRLwwTXCrKPTe5o6nlkpCFIpfffDjodCZ0jfijHAMQilYGwBTRBZWDUKglyuSdh+015rbvG6QjI+vlhppUMUU+hfTP0EB9wWBoBzs9g4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

A previous commit protected us against races between ptdump and CPA
collapse, however one still exists between attribute changes and collapse
as reported by Denis V. Lunev (linked).

When an attribute change arises, a lockless page table walker obtains a PTE
entry, which is later written to via set_pte_atomic():

...
-> change_page_attr_set_clr()
-> __change_page_attr_set_clr()
-> __change_page_attr()
	-> _lookup_address_cpa()
	-> lookup_address_in_pgd_attr()
	-> [ lockless page table walker ]
-> set_pte_atomic()

There is nothing preventing a concurrent CPA collapse which can free the
PTE that was retrieved here, resulting in a use-after-free.

With the mmap write lock taken on init_mm over CPA collapse, we can now
resolve this race by acquiring an mmap read lock on init_mm over
__change_page_attr_set_clr().

This locks across the whole operation over which the walk and the PTE entry
write occurs, solving the race.

It is safe to do this here, as no spinlocks are held upon entry to
__change_page_attr_set_clr().

However, the lock must not be held over an allocation, as allocation can
trigger reclaim and shrinkers may call into CPA recursively, making
deadlocks possible (init_mm -> ... -> fs_reclaim -> init_mm).

A page table is allocated when a huge page needs to be split:

-> change_page_attr_set_clr()
-> __change_page_attr_set_clr()
-> __change_page_attr()
-> split_large_page()
[ pagetable_alloc() ]
-> __split_large_page()

Avoid deadlocks by dropping the mmap lock across pagetable_alloc() in
split_large_page() and track whether this is needed by adding a new
'init_mm_read_locked' flag to struct cpa_data.

This is safe as __split_large_page() (called with locks re-established)
revalidates that the page table entry is the same as it was prior to the
locks being dropped and __change_page_attr() repeats the entire page table
walk whenever a split occurs, so concurrent split and collapse are
accounted for.

Concurrent ptdump is also safe as the lock is only dropped over page table
allocation during which time the page table has not yet been modified.

The CPA_COLLAPSE flag is only set by set_memory_rox(), which exclusively
operates upon vmalloc ranges, and on x86 only within the module mapping
space.

This is important, because some callers directly invoke
__change_page_attr_set_clr(), bypassing this lock. However, none of these
operate within the module mapping space.

* cpa_process_alias() - a recursive helper called by
  __change_page_attr_set_clr().
* __set_memory_enc_pgtable() - operates on the direct mapping and (via
  __vmbus_establish_gpadl()) the vmalloc mapping space.
* __set_pages_[n]p() - called by set_direct_map_[invalid, default,
  valid]_noflush(), __kernel_map_pages() - operates on the direct map.
* kernel_[un]map_pages_in_pgd() - operates on EFI ranges.

This work is based upon Denis V. Lunev's excellent analysis of the bug with
gratitude.

Link: https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org/
Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 4ba16d72a535..26131ecc0e1c 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -50,7 +50,8 @@ struct cpa_data {
 	unsigned int	flags;
 	unsigned int	force_split		: 1,
 			force_static_prot	: 1,
-			force_flush_all		: 1;
+			force_flush_all		: 1,
+			init_mm_read_locked	: 1;
 	struct page	**pages;
 };
 
@@ -435,8 +436,6 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 	int collapsed = 0;
 	int i;
 
-	cpa_lock();
-
 	if (cpa->flags & (CPA_PAGES_ARRAY | CPA_ARRAY)) {
 		for (i = 0; i < cpa->numpages; i++)
 			collapsed += collapse_large_pages(__cpa_addr(cpa, i),
@@ -450,10 +449,8 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 			collapsed += collapse_large_pages(addr, &pgtables);
 	}
 
-	if (!collapsed) {
-		cpa_unlock();
+	if (!collapsed)
 		return;
-	}
 
 	flush_tlb_all();
 
@@ -461,8 +458,6 @@ static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 		list_del(&ptdesc->pt_list);
 		pagetable_free(ptdesc);
 	}
-
-	cpa_unlock();
 }
 
 static void cpa_collapse_large_pages(struct cpa_data *cpa)
@@ -1270,8 +1265,13 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	struct ptdesc *ptdesc;
 
 	cpa_unlock();
+	if (cpa->init_mm_read_locked)
+		mmap_read_unlock(&init_mm);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (cpa->init_mm_read_locked)
+		mmap_read_lock(&init_mm);
 	cpa_lock();
+
 	if (!ptdesc)
 		return -ENOMEM;
 
@@ -2139,7 +2139,11 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	ret = __change_page_attr_set_clr(&cpa, 1);
+	/* Avoid race with concurrent CPA collapse. */
+	cpa.init_mm_read_locked = true;
+	scoped_guard(mmap_read_lock, &init_mm)
+		ret = __change_page_attr_set_clr(&cpa, 1);
+	cpa.init_mm_read_locked = false;
 
 	/*
 	 * Check whether we really changed something:

-- 
2.53.0


