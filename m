Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F5EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7806B042E; Thu, 13 Aug 2026 05:01:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7ECC6B042F; Thu, 13 Aug 2026 05:01:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC5D6B0430; Thu, 13 Aug 2026 05:01:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768896B042E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:01:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1014980537
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:59 +0000 (UTC)
X-FDA: 85095653958.11.95D0BBF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6D57B100003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:01:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpl58WiJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786611717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbqAHeBmTdNz5nx7DbozdY5ynkW62XANFKaegUYp63U=;
	b=p4zrweglvzgf3e85BK7b6H3aLzB7I9Uf3ad7Yg1NtLVnAPaV06ND+iI5srYz+u7Y4n3/IX
	mcrjLTlGsem4RSqpGxeOgNwlZ6zMNqXbV28rPjfveMx97diqto07fuqaVxrUgulFgGQvVT
	OI7gHocNSD7j+Huc4w4pLhi27B2nrNs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786611717;
	b=gzaFiZGtq2n6fYbs8ajRMfUr5FA4+1dE1fI6QtPKX6dJxFoEv8dPCUEl9mzzEAoKRRqqzZ
	vmHSyMOyhGqFajCXly5D4PnO34pUPtsP0k3AJokexfxSo2ffA1xYTxX4tBB8LlT/nzEpGG
	Stncv6nePy1RhzefuvdfUEI5yR4uvAM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fpl58WiJ;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02B4F600AF;
	Thu, 13 Aug 2026 09:01:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337AD1F00A3A;
	Thu, 13 Aug 2026 09:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786611716;
	bh=QbqAHeBmTdNz5nx7DbozdY5ynkW62XANFKaegUYp63U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fpl58WiJQbCPqzesROD3VU1p5FQ723FiIYReD8pXtJgCqw0JSoITh9dAMypwqb/lD
	 3l7vR+MjHy6ki83qrUVjTdoYWSt3ylKYcOZXU/vB56miSBcq0kh9twp2J4UwphiM0N
	 ON7qNylifK3/bx6E4gCUQCVx0lcL6XBXSPh/OcJolZjvX0Z626PIaGEe+GigZnCIA3
	 gJUvZMuuuk14KNU0trmRx1BkKlpwsGEmt5boJ+VmnB0UDXD2rGHU2gDiDK1DCgzo55
	 stgpR546uhuIoSEsbC5m3b1h0drzy+VhB8AAri1nBM5LgJLiUcsKAMyX9TzmVE/xAb
	 G8H9lBJc7qXFA==
From: Mike Rapoport <rppt@kernel.org>
Date: Thu, 13 Aug 2026 12:01:25 +0300
Subject: [PATCH v2 2/5] x86/mm/pat: acquire init_mm read lock on attribute
 change to avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-cpa-fixes-v2-2-39b4ff90f91d@kernel.org>
References: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
In-Reply-To: <20260813-cpa-fixes-v2-0-39b4ff90f91d@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Jiri Slaby <jirislaby@kernel.org>, Juergen Gross <jgross@suse.com>, 
 Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Lu Baolu <baolu.lu@linux.intel.com>, Mike Rapoport <rppt@kernel.org>, 
 Nikunj A Dadhania <nikunj@amd.com>, Pedro Falcato <pfalcato@suse.de>, 
 "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Steffen Dirkwinkel <lists@steffen.cc>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, syzbot@syzkaller.appspotmail.com, x86@kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: tx1wfyskk6ep3b9eri4pr8pkmb3j9u6s
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D57B100003
X-HE-Tag: 1786611717-112719
X-HE-Meta: U2FsdGVkX1+uqDfzPNyF9io06FoDhFP/wcDbvpXV8qHUkLakYao2tcFnSCyeIyhzlxU3Lw7B4tnB9tff+Ed48mptpsuzjGXuLDpO7MOzy5ABWFiILHsauFO9kqq+ig/8W21a/6yzlVZdBBWx6rkxgFbmaBNWA4s9ZjZQy1T6O8utWdDlQvNqzSufn/knwzpSuGnZf55EqRsO3RVI3qt3kCc2mqpq/RL3uYYeOgm+3mliWrqfBtHqxX+cMJIKbi64ZreNEQfdIQyZWd9dkeNNik6vW2P3TxBfN9wr4wQ2ayWJqE+peTdzZRGKSBtVrJB6E0QBbLUYV3jk+MuNi0eqSvSlqNeSGCVftBjfDF7niKmorE5jtEn3hLyYGsiEIoNttLVFGTFw/7EV1ccwQD13bOlRbzckJuY1/Hl/Pazw7mnLXVl/rfsCg/C6D5wDa0XT+qVn8B3WThHgi2kb6HSIgOzxqhBVm7Rj13XIqTVtE4zVtso4DGD1kwhw9i7GZptCuPs1vw7JrAgu6/RLEeoxLWjbW7b2Bfl8tJH0+OzL/weSHDUy6yb8bjpHKZnzWKMrar/Bx36KXHAHXkgZIzHAt80n1aiNhDWLv0XghgiXGajwZ/fZOJZrIQCXOmmN8WM09sMWgp7QhsTQ3Inx+9ng4q8irgKi58u6cB/tzcHeOgagh9KXxIMzItZZbpq6QX17eV4+cCqpnlyyJkNeg7kLkkbE9Cc0S5WWp/QtU+NyUdVuJzK1ctS4MWToiNmRvFjMC+N72ptT+khGzAsCqxkbr4xSYOKxXrFRNKP34h8WLWBwSyglsgtF5FxdZxsl46j1k39YYJMqD3rYPc8xHFHJUxuh4QIL77vtjLCVjHo0C4UpLaBMSYANcd5EJ5tgt5lnj/o1K6rAXYXitu8ESGoPNHBUy4ged63SuoKEAX+zY7Qno/4+JFURkevidWt26AFu15QOsss4Kw3I5GTr/lH
 qJmYIF1E
 B2ZT0FObrsZ+PeGHMO/oTb/bsVhxhg9oNAPnw7UMNw/962Crl0AuqEhFft3WGPUQYd9Lwg/oeuNY1cb13r24wGaNIy6HXX8K15STtJl74nEjAmnqeK0wKttI544LSo+WP1p5MtvsCkJcV8kLU2Qc8JP6sHIY5y7LDbt3OwzR4V9NGT9oZQeBek9TMzc+zNzrwEON/LXFWIAhGQALLiUSOSoR+tWQFWy+3nv3l9RkQqPeKvMKF2Y1vwDysRoORl/3v1OVAthPzq0bNVQ87q2Wf/CVjukdVKJHitIznZ4e6HT2C8e4P3aiehC3wGKaoTS2lceWg5iT7cBeEVad1xUQET62UyXKrH2bZIT+miQ2l2CUuGzKCnCtOGi03j91R/v5C2FdEGNBC10PY4W4tZa7Zpmjb1kmcdxqesKIUSV/vffTy/4M=
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
 arch/x86/mm/pat/set_memory.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index c18b887ee4c2..2d04a4bf34aa 100644
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
 
@@ -1240,7 +1241,11 @@ static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
 	struct ptdesc *ptdesc;
 
 	spin_unlock(&cpa_lock);
+	if (cpa->init_mm_read_locked)
+		mmap_read_unlock(&init_mm);
 	ptdesc = pagetable_alloc(GFP_KERNEL, 0);
+	if (cpa->init_mm_read_locked)
+		mmap_read_lock(&init_mm);
 	spin_lock(&cpa_lock);
 	if (!ptdesc)
 		return -ENOMEM;
@@ -2134,7 +2139,11 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
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


