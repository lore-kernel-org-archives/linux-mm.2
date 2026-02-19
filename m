Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E00D2C531EB
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244FE6B00A6; Thu, 19 Feb 2026 18:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DAF76B00A7; Thu, 19 Feb 2026 18:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8316B00A8; Thu, 19 Feb 2026 18:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E7F496B00A6
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:50:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C3711C8E1
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:50:04 +0000 (UTC)
X-FDA: 84462851928.05.DAC8819
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 778FD4000B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:50:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=crl8C4zW;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771545002; a=rsa-sha256;
	cv=none;
	b=cZIE5c8u6yrsW40tsBNnVduO4Y7+CSdOuQmyAi0Ddez71wjNBTwkabrSmVpm1DFcBIod+x
	0WX91NcxKoePK9UbDUokMk0Xrv07R/ZinkczmPE12sKaQbP8GaZoAAjO80OThwx3RDupLa
	NHmKVbKIvJsSMV0x36qBsabVWjcVKGw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=crl8C4zW;
	spf=pass (imf01.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771545002;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6lihIQui6KQE1i3s2NgpQLW4qsEHpOLmDMqL9w6Rok=;
	b=cQVZgkJ2upDCcXRSrlmu0nKcI1JG1TscDldlvLT9JyQ+PUuf3jcyIiIgQAePh11VOjHoiK
	q4sNijxmBVmc5XqvnpABs/MySMT6a2C8XEwL4eWsXfH7Xz8atn2C7v8gzdyyKIlruh4w3e
	kYkMAcXVb9/PLsz4VJPknCU+IvOggEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E93544540;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0CCDBC2BCB2;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544528;
	bh=SVkjz87H+v7qEvTRagEPaFIS/kko6XF9kiNxmbSXkpQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=crl8C4zWRKZwRLaByTmREkcM4IQWEXl33WnmqGuSEWKF00sOUTp2eCuGZ6HoK5YLL
	 lBfdSZFAdLR1JLfFLM9UZ7I/p6Aui7ZLzvRv3jIe+deFP7DGQ8ksmmJxOP13Jte0zP
	 MLB9ojJ0d4E9jBhKTKOK1OovK9I7vKOjjgSRa0PGTQJheSTQJ+okRwVYuvU1MKGXyi
	 W2paG5sr3Jb9EXXrt0nHhgR0DJflFDx5xnAunvXQePHA2DcJn3j3EFtWpeuKnKQthn
	 M9rXU9RyPxeZoCMz1QsUJOwOQ5t2+fDwRUd1GqAXSAtnTt4zOoxiL5LR3uyYqVb7Nq
	 rF3dvGMth+mpw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03203C531EA;
	Thu, 19 Feb 2026 23:42:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 20 Feb 2026 07:42:12 +0800
Subject: [PATCH RFC 11/15] mm/swap, memcg: remove swap cgroup array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-swap-table-p4-v1-11-104795d19815@tencent.com>
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
In-Reply-To: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771544524; l=15582;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ab1DMIR8yqVLL69CexiaEYLTLIUHukDgwvK/gc3LcsM=;
 b=W5W0v6jgjF0XBwiRd/XQqgsIQe0I03NglUh7sJSKbsTpBIHlTYOWBv8Bup+fBAi5446LgGVyV
 eqfznMFyEv+Cy0zY0FiaHNTajlorvDD1ujYZO7cjxI/YmbNz9mMM5g5
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 778FD4000B
X-Stat-Signature: ouboup3xee3ni3jq1gnbxfmjn3j4aziz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771545002-338651
X-HE-Meta: U2FsdGVkX19st+xnu1c0It1aESieQRyEr5YnAzeggWGmW/glwQwCLHe0ygfJwmBGQKxi41HNYYolV+ymwBsqXxwNkqtgzJM86E6dFLzzJFGyRrb8J7WJuD1HYv8z0umoEgOCfE/c8DMMphCUVcA47FX3jYwGhtBlh+jxlj5w0sVOUl+bn/IF6XzXqubC37rsILrQXAjUVt0Kfc12rDLYCI2Cu6NMRky3sKE+nX3iJX1T+0PWghEgdwPAf83AnebkJri8pW5mQRlPCetSER88dRabwCRRud4QLd0JCtBQcA0ATUbeVdu0vnM11bk7fqnrxdTawGn5UWfyyPP1bTHT3aurj4AYHutwxjeFg4J29VAGySCTrAWN1Zm1Z1aW+bsL73g9PxfDVlnKJC17AyjLeV/Vw65fSCpvnzCk2cXwx4MgZhKKhNVAkajx+q5pJeRSD6cc6VlALQ+QpnwKbYsj63b/kBiobxKPSvyPMlo3eAJzW1rflkxQ+hdaKaN8ninQsdjY0jeb0pRbPUsa2AtS9ECAgvjrqxE3p2XlwKG3to3fK9es1A/WqQ6/qM/Vt3bZj5QNdbO3Z0YyaPsnVA3ddceGD33p+MaQge2y/C+uvT5Ev4ICEY3OUPGVaVXWXMANbaGycFlFoCfG8rYMgfbFHM8Iw44sL47BokH0JjTTqoY301togyDJssGeSemttDS5CUAEZbMzMReUCIVAI3YTPMwfjEcg8A1UZq6dTaWlxqA6pBH3kfnBAKbOQRy9oOy58KcRdU9O+Ga/6PwyNux+0xeVoopVGUQv1WGAg/F/FN0gqrYMRoJhKbjwlZ1LuqsAwAXhbDIkLn6nBxj2Co/v3VYT8phuDfa+XumCuF+gEUWYXU2FLM54mlXdfHu/2JQluqOZuo3qDsUvn5Lw0gQ2rPs7Spy5d5YgGs4gqW1pgbEAfXjvoS6PLCitRSemNewSCVWMD6vGcm5WEghKJo3
 +nMonDtb
 wmbJRbYy8ED0RU3RQ+cToVVkvNappRg5Aa198Ze0VN01UI/Xv9IiHSCFNuCIVDg8U1NLhogsjRT+TxSyRckjsVrlU7L7nYoqmZNwSY4BrUpUV1uuSslFwNPb1Hsagck1hRVhLSf3RCZXU5jouj9hPXwxtCdG5ysJP5NyA/oEQprPHYzJO0eEuWSfzBN1QpUeGfGCR6kJwjbJNqq6uXgNiAvFx/2jh94JtsIRnavln3nHAfBQ5EyNLHFJwMjrqDAeX9K1Nm2QRf+8CxGUVCbKd5BLz8ICKRp0FlycmQMQ46uLHXBdkeDqblhq1wJbU9XtH8+5zFN8DTutIF5WOKjd5sisG5RGOsRfiDDeVVc4FUw2iHHnEjIiGDhT30Za0aUAugiL9C3k7m54q8KXYjbOUE4Z0ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now swap table contains the swap cgropu info all the time, the swap
cgroup array can be dropped.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 MAINTAINERS                 |   1 -
 include/linux/memcontrol.h  |   6 +-
 include/linux/swap_cgroup.h |  47 ------------
 mm/Makefile                 |   3 -
 mm/internal.h               |   1 -
 mm/memcontrol-v1.c          |   1 -
 mm/memcontrol.c             |  19 ++---
 mm/swap_cgroup.c            | 171 --------------------------------------------
 mm/swap_state.c             |   3 +-
 mm/swapfile.c               |  23 +-----
 10 files changed, 11 insertions(+), 264 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index aa1734a12887..05e633611e0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6571,7 +6571,6 @@ F:	mm/memcontrol.c
 F:	mm/memcontrol-v1.c
 F:	mm/memcontrol-v1.h
 F:	mm/page_counter.c
-F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
 F:	tools/testing/selftests/cgroup/test_hugetlb_memcg.c
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 8fc794baf736..4bfe905bffb0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -667,8 +667,7 @@ static inline int mem_cgroup_charge(struct folio *folio, struct mm_struct *mm,
 int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp);
 
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				   gfp_t gfp, swp_entry_t entry,
-				   unsigned short id);
+				   gfp_t gfp, unsigned short id);
 
 void __mem_cgroup_uncharge(struct folio *folio);
 
@@ -1146,8 +1145,7 @@ static inline int mem_cgroup_charge_hugetlb(struct folio* folio, gfp_t gfp)
 }
 
 static inline int mem_cgroup_swapin_charge_folio(struct folio *folio,
-			struct mm_struct *mm, gfp_t gfp, swp_entry_t entry,
-			unsigned short id)
+			struct mm_struct *mm, gfp_t gfp, unsigned short id)
 {
 	return 0;
 }
diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
deleted file mode 100644
index 91cdf12190a0..000000000000
--- a/include/linux/swap_cgroup.h
+++ /dev/null
@@ -1,47 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __LINUX_SWAP_CGROUP_H
-#define __LINUX_SWAP_CGROUP_H
-
-#include <linux/swap.h>
-
-#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
-
-extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
-extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
-extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
-
-#else
-
-static inline
-void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent)
-{
-}
-
-static inline
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	return 0;
-}
-
-static inline
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	return 0;
-}
-
-static inline int
-swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	return 0;
-}
-
-static inline void swap_cgroup_swapoff(int type)
-{
-	return;
-}
-
-#endif
-
-#endif /* __LINUX_SWAP_CGROUP_H */
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..eff9f9e7e061 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE_MEMFD) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-ifdef CONFIG_SWAP
-obj-$(CONFIG_MEMCG) += swap_cgroup.o
-endif
 ifdef CONFIG_BPF_SYSCALL
 obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
 endif
diff --git a/mm/internal.h b/mm/internal.h
index 416d3401aa17..26691885d75f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -16,7 +16,6 @@
 #include <linux/rmap.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include <linux/tracepoint-defs.h>
 
 /* Internal core VMA manipulation functions. */
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 038e630dc7e1..eff18eda0707 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -5,7 +5,6 @@
 #include <linux/mm_inline.h>
 #include <linux/pagewalk.h>
 #include <linux/backing-dev.h>
-#include <linux/swap_cgroup.h>
 #include <linux/eventfd.h>
 #include <linux/poll.h>
 #include <linux/sort.h>
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d0f50019d733..8d0c9f3a011e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -54,7 +54,6 @@
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
 #include <linux/mm_inline.h>
-#include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
 #include <linux/lockdep.h>
@@ -4793,7 +4792,6 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
  * @folio: folio to charge.
  * @mm: mm context of the victim
  * @gfp: reclaim mode
- * @entry: swap entry for which the folio is allocated
  * @id: the mem cgroup id
  *
  * This function charges a folio allocated for swapin. Please call this before
@@ -4802,21 +4800,17 @@ int mem_cgroup_charge_hugetlb(struct folio *folio, gfp_t gfp)
  * Returns 0 on success. Otherwise, an error code is returned.
  */
 int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
-				   gfp_t gfp, swp_entry_t entry, unsigned short id)
+				   gfp_t gfp, unsigned short id)
 {
 	struct mem_cgroup *memcg, *swap_memcg;
-	unsigned short memcg_id;
 	unsigned int nr_pages;
 	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
 
-	memcg_id = lookup_swap_cgroup_id(entry);
 	nr_pages = folio_nr_pages(folio);
 
-	WARN_ON_ONCE(id != memcg_id);
-
 	rcu_read_lock();
 	swap_memcg = mem_cgroup_from_private_id(id);
 	if (!swap_memcg) {
@@ -4836,10 +4830,11 @@ int mem_cgroup_swapin_charge_folio(struct folio *folio, struct mm_struct *mm,
 
 	/*
 	 * On successful charge, the folio itself now belongs to the memcg,
-	 * so is folio->swap. So we can release the swap cgroup table's
-	 * pinning of the private id.
+	 * so is folio->swap. And the folio takes place of the shadow in
+	 * the swap table so we can release the shadow's pinning of the
+	 * private id.
 	 */
-	swap_cgroup_clear(folio->swap, nr_pages);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 	mem_cgroup_private_id_put(swap_memcg, nr_pages);
 
 	/*
@@ -5324,8 +5319,6 @@ struct mem_cgroup *__mem_cgroup_swap_free_folio(struct folio *folio,
 {
 	unsigned int nr_pages = folio_nr_pages(folio);
 	struct mem_cgroup *memcg, *swap_memcg;
-	swp_entry_t entry = folio->swap;
-	unsigned short id;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_memcg_charged(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
@@ -5337,8 +5330,6 @@ struct mem_cgroup *__mem_cgroup_swap_free_folio(struct folio *folio,
 	 */
 	memcg = folio_memcg(folio);
 	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	id = mem_cgroup_private_id(swap_memcg);
-	swap_cgroup_record(folio, id, entry);
 
 	if (reclaim && do_memsw_account()) {
 		memcg1_swapout(folio, swap_memcg);
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
deleted file mode 100644
index b5a7f21c3afe..000000000000
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,171 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/swap_cgroup.h>
-#include <linux/vmalloc.h>
-#include <linux/mm.h>
-
-#include <linux/swapops.h> /* depends on mm.h include */
-
-static DEFINE_MUTEX(swap_cgroup_mutex);
-
-/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_t) */
-#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
-#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
-#define ID_MASK (BIT(ID_SHIFT) - 1)
-struct swap_cgroup {
-	atomic_t ids;
-};
-
-struct swap_cgroup_ctrl {
-	struct swap_cgroup *map;
-};
-
-static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
-
-static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
-					      pgoff_t offset)
-{
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int old_ids = atomic_read(&map[offset / ID_PER_SC].ids);
-
-	BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
-	BUILD_BUG_ON(sizeof(struct swap_cgroup) != sizeof(atomic_t));
-
-	return (old_ids >> shift) & ID_MASK;
-}
-
-static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
-					    pgoff_t offset,
-					    unsigned short new_id)
-{
-	unsigned short old_id;
-	struct swap_cgroup *sc = &map[offset / ID_PER_SC];
-	unsigned int shift = (offset % ID_PER_SC) * ID_SHIFT;
-	unsigned int new_ids, old_ids = atomic_read(&sc->ids);
-
-	do {
-		old_id = (old_ids >> shift) & ID_MASK;
-		new_ids = (old_ids & ~(ID_MASK << shift));
-		new_ids |= ((unsigned int)new_id) << shift;
-	} while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
-
-	return old_id;
-}
-
-/**
- * swap_cgroup_record - record mem_cgroup for a set of swap entries.
- * These entries must belong to one single folio, and that folio
- * must be being charged for swap space (swap out).
- *
- * @folio: the folio that the swap entry belongs to
- * @id: mem_cgroup ID to be recorded
- * @ent: the first swap entry to be recorded
- */
-void swap_cgroup_record(struct folio *folio, unsigned short id,
-			swp_entry_t ent)
-{
-	unsigned int nr_ents = folio_nr_pages(folio);
-	struct swap_cgroup *map;
-	pgoff_t offset, end;
-	unsigned short old;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_WARN_ON_ONCE(old);
-	} while (++offset != end);
-}
-
-/**
- * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
- * These entries must be being uncharged from swap. They either
- * belongs to one single folio in the swap cache (swap in for
- * cgroup v1), or no longer have any users (slot freeing).
- *
- * @ent: the first swap entry to be recorded into
- * @nr_ents: number of swap entries to be recorded
- *
- * Returns the existing old value.
- */
-unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
-{
-	pgoff_t offset, end;
-	struct swap_cgroup *map;
-	unsigned short old, iter = 0;
-
-	offset = swp_offset(ent);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_type(ent)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, 0);
-		if (!iter)
-			iter = old;
-		VM_BUG_ON(iter != old);
-	} while (++offset != end);
-
-	return old;
-}
-
-/**
- * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
- * @ent: swap entry to be looked up.
- *
- * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
- */
-unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
-{
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ctrl = &swap_cgroup_ctrl[swp_type(ent)];
-	return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
-}
-
-int swap_cgroup_swapon(int type, unsigned long max_pages)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=
-		     sizeof(struct swap_cgroup));
-	map = vzalloc(DIV_ROUND_UP(max_pages, ID_PER_SC) *
-		      sizeof(struct swap_cgroup));
-	if (!map)
-		goto nomem;
-
-	ctrl = &swap_cgroup_ctrl[type];
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl->map = map;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	return 0;
-nomem:
-	pr_info("couldn't allocate enough memory for swap_cgroup\n");
-	pr_info("swap_cgroup can be disabled by swapaccount=0 boot option\n");
-	return -ENOMEM;
-}
-
-void swap_cgroup_swapoff(int type)
-{
-	struct swap_cgroup *map;
-	struct swap_cgroup_ctrl *ctrl;
-
-	if (mem_cgroup_disabled())
-		return;
-
-	mutex_lock(&swap_cgroup_mutex);
-	ctrl = &swap_cgroup_ctrl[type];
-	map = ctrl->map;
-	ctrl->map = NULL;
-	mutex_unlock(&swap_cgroup_mutex);
-
-	vfree(map);
-}
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5ab3a41fe42c..c6ba15de4094 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -163,7 +163,6 @@ static int __swap_cache_check_batch(struct swap_cluster_info *ci,
 	*shadowp = swp_tb_to_shadow(old_tb);
 	memcgid = shadow_to_memcgid(*shadowp);
 
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !memcgid);
 	do {
 		old_tb = __swap_table_get(ci, ci_off);
 		if (unlikely(swp_tb_is_folio(old_tb)) ||
@@ -255,7 +254,7 @@ static struct folio *__swap_cache_alloc(struct swap_cluster_info *ci,
 	WARN_ON(!shadow);
 
 	if (mem_cgroup_swapin_charge_folio(folio, vmf ? vmf->vma->vm_mm : NULL,
-					   gfp, entry, shadow_to_memcgid(shadow))) {
+					   gfp, shadow_to_memcgid(shadow))) {
 		spin_lock(&ci->lock);
 		__swap_cache_del_folio(ci, folio, shadow, false, false);
 		spin_unlock(&ci->lock);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cd2d3b2ca6f0..de34f1990209 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -45,7 +45,6 @@
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
-#include <linux/swap_cgroup.h>
 #include "swap_table.h"
 #include "internal.h"
 #include "swap_table.h"
@@ -1885,8 +1884,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 {
 	void *shadow;
 	unsigned long old_tb;
-	unsigned int type = si->type;
-	unsigned int id = 0, id_iter, id_check;
+	unsigned int id = 0, id_iter;
 	unsigned int ci_off = ci_start, ci_end = ci_start + nr_pages;
 	unsigned long offset = cluster_offset(si, ci);
 	unsigned int ci_batch = ci_off;
@@ -1903,23 +1901,15 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 		shadow = swp_tb_to_shadow(old_tb);
 		id_iter = shadow_to_memcgid(shadow);
 		if (id != id_iter) {
-			if (id) {
-				id_check = swap_cgroup_clear(swp_entry(type, offset + ci_batch),
-							     ci_off - ci_batch);
-				WARN_ON(id != id_check);
+			if (id)
 				mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
-			}
 			id = id_iter;
 			ci_batch = ci_off;
 		}
 	} while (++ci_off < ci_end);
 
-	if (id) {
-		id_check = swap_cgroup_clear(swp_entry(type, offset + ci_batch),
-					     ci_off - ci_batch);
-		WARN_ON(id != id_check);
+	if (id)
 		mem_cgroup_uncharge_swap(id, ci_off - ci_batch);
-	}
 
 	swap_range_free(si, offset + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
@@ -3034,8 +3024,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	p->global_cluster = NULL;
 	kvfree(zeromap);
 	free_swap_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3567,10 +3555,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (error)
 		goto bad_swap_unlock_inode;
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	/*
 	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
 	 * be above MAX_PAGE_ORDER incase of a large swap file.
@@ -3681,7 +3665,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si, swap_file);
-	swap_cgroup_swapoff(si->type);
 	free_swap_cluster_info(si->cluster_info, si->max);
 	si->cluster_info = NULL;
 	kvfree(si->zeromap);

-- 
2.53.0



