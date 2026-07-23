Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4660C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCC336B00AD; Thu, 23 Jul 2026 11:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3BD6B00AE; Thu, 23 Jul 2026 11:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9546B00AF; Thu, 23 Jul 2026 11:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A40D26B00AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:17:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 374AF1604EE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:28 +0000 (UTC)
X-FDA: 85020395376.19.E59763D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5939940003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:17:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NotWd1pq;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784819846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp2mZdK6fJ1/si4CysQ56zitoOpwB+w35kScbOb2foM=;
	b=17qGkULhNyvXfC0HHXZ2BDDyYPeh3K0BsuG9WpyiJLknCPT3a/iF53wq99sVsSZON35hTz
	59uXgjYHoY5+c44m7HnO/vpUlwD5Lrz3+uk3jp4XmkS0LkG4h8UD9x9Ersu9IPhdumXXzm
	ZxqvnFIMMTEgaat4hPD94j7aSI2Ty0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784819846;
	b=HlIzLw3GLNA58D6ycQFrrQzo2udZ8dng4p3/Wkwbq6VlnjE5fnk8JqoK9nsdm/9J+4WFde
	A6LSZunV61S/FXBpvWv6CF3STJCyZ+nPS9IQCcDd53jbIfvSn1KR8uiPmOc413/7TmqS1B
	T/olJnrHwtGUYOpgB2eqYmo0DDUJ7qs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NotWd1pq;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8639440AB8;
	Thu, 23 Jul 2026 15:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B531F00A3A;
	Thu, 23 Jul 2026 15:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784819845;
	bh=Cp2mZdK6fJ1/si4CysQ56zitoOpwB+w35kScbOb2foM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NotWd1pqW5cSI0cTR7v9yu46zVCF47GX5WwS13EO559ek9XdS1VKv+VhM7bYjlSjk
	 wfnuNCgkjM3KADUhnUfjJfLN5ae+8XXCPt/u4afIW7HDlXbUJUOxjEYlQhu/hscZz8
	 x6v3t7J0Vpu2pc/e1Nmwx1p91nv2Ag7knaRRoq976gNfbXqe5eCupHWjc8TYkYPty2
	 lCBrXMHaDy0HoqayKPYfKfgY5QBb6qCpX2nBPGuyCCKN90/Gpt/blL2mfVIqg1zUEx
	 kDLCmK6XBlKYIfgtLBeKg42eXyRgwoKoscq5AxIdb8J2oYzOB5/geYfhDBpmtTYuPQ
	 2U0mqevzggA2Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 23 Jul 2026 16:16:33 +0100
Subject: [PATCH mm-hotfixes v6 3/5] x86/mm/pat: acquire init_mm read lock
 on attribute change to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-series-vmap-race-fix-v6-3-8cc77dcc0018@kernel.org>
References: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
In-Reply-To: <20260723-series-vmap-race-fix-v6-0-8cc77dcc0018@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, "Denis V. Lunev" <den@virtuozzo.com>, 
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4639; i=ljs@kernel.org;
 h=from:subject:message-id; bh=akxrj13lq/jN4z92xXrWGgQjWx+k4pmtig1tmCI1Rgs=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKSDGJZv/xpV/pzpMI449Xn74qeNttef6kPX1t9YNmRP
 xOnsp3O6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEOGcyMqyt+rVf2Dh9loKt
 YdgqI4aJmooduV+fbbvNsUvG5kDfyqWMDNPaH/qzLrXY/599euTFu+mnXu/jTlStY9GPubdItt5
 jHi8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5939940003
X-Stat-Signature: 7qz87ebmd3nhsjs7q4uzkr9irwr4um46
X-HE-Tag: 1784819846-775117
X-HE-Meta: U2FsdGVkX1/epfIoXXSvKYkx4Qdg+7V+uAQbrdpWmNTTMHQIMky/caXCb+RX6z/czaw/Gva5s0XbM6AFdyvRWyHCsx1J4Sx0GLkgPvvF8vU3em4VUmPecITvvPq7bUN5MHnA0oAVEyHjFh97XAHcnt573edJFwTIC5q3fW3idiTWGvF8geod83Cm7QEWLfNcM9z3ZWnQYyYErRyKLHJ31MLyRoOZYNx7zETmzRMMKboy+ya5SV37OIog3+pUUW/yl7n0ImwOZRQENt75Q251OJXPSjni7hHb33W0QyRu+lZOSZflKJreRu9KjVsJ6TnMgyGdBi1SIdWuYwgx3zuIvyI+Qdac//q17Y2bDTJcGJ2f8UbLwSZzGD3Aw3j/nFHrqrbn05Se+ZtsSycqygIzq6+Oh1dAPcaETW8D/xxfTmaNVV4buANmuYAEpTpk18G8Hv5x8Fle6P16DCO7r6Um1vXgKz4B0q3iWU19qolvWy9bLR/BtaO+u6ZbKIDw7+hh3KwCZxNKBTkccO5zFR85JS6uFg/ZYfJow5nl5xP7ttigPL/EuUN5t6BxCQIaS53Jhqm/b8FbGCyrAvjTh47bpqrkiloInNJgiSmuo6JXM2e6wHjFImoZMm+BqMmfvJyVOgs7U1kwI/pzj4lD30fOMvY+a69Q3XRWC1WxL0VVNcg72vIvibDku0ZBbvchRKgGO4vhhyklgU9Lgh2RilVvo5qVDvbjfhwuJm89hTVax0xVeIv3ySs/BJhdT+cjZIpJOHpFX4tZsZo6m24SY/R6K5NI4uGmS7xou7JYGTmBLzRSoHktPlC2dJoHGAsiayxYSmzUVpPxEZRFybYRz02h2NKBskqyJJJ7pzw8uu4nkAAkc5bkvWnGPHv7GB9AdeU5uUECiZ55I/HjS9jpF6/glpKcgPYxBEMbCqhzk3MJiW9LZrrl/JHu+u3CarPZdUtTvQ86EUokLHrddKxfTQV
 eOWlTNxU
 Iq2ZHZZV5j+bYcbyIJIjVqms6zvcaeSj4WrPazWRsS7Rd8NTQbPcqrxmdw27cBYgX1+yr6poLG7zpypbMrU/lMuk+6GqJjd3MxIoIcdtKPITTBSXsN/mDYwhcq80255pNH1yOrhCZFvdcBNNvimnpwW2jzo2TLfenqFaGW3uTeXSw7bB5VhTTTpF2ygyoPiVp6guO1rFbAE1B7Hy9GRJ7CBjfw4+fnzCE9dmVwXRoULJsxLpQpDaAd0tAv9E/fUtx/ASqEwrUc/H10pBjJkKmR90nlqlNehtJTe+ZQC6zyC5q6U/tQiFmNsYSPytJYk+l7adWv/i3ns0X/NdewLK8GJUHb3yBOWWpPs1DykAI9zwXQAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
---
 arch/x86/mm/pat/set_memory.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d1e63f7d267f..618f72096480 100644
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
 
@@ -1250,7 +1251,11 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 
 	if (!debug_pagealloc_enabled())
 		spin_unlock(&cpa_lock);
+	if (cpa->init_mm_read_locked)
+		mmap_read_unlock(&init_mm);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (cpa->init_mm_read_locked)
+		mmap_read_lock(&init_mm);
 	if (!debug_pagealloc_enabled())
 		spin_lock(&cpa_lock);
 	if (!ptdesc)
@@ -2122,7 +2127,11 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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
2.55.0


