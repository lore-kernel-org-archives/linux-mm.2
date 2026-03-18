Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43051088E48
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80BB26B0360; Wed, 18 Mar 2026 18:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798146B0362; Wed, 18 Mar 2026 18:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE456B0363; Wed, 18 Mar 2026 18:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3746B6B0360
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0AED81A01B4
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:18 +0000 (UTC)
X-FDA: 84560628516.29.2F75BCB
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D06920005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m8oMUPg5;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/r4lbyJWNRb4OPU+FwoTkjRVnxoVbk6U7PxvuQ43o+8=;
	b=ngpAHGNeggGM0GTm1GZnzDSNWD+iqz3oPQfWh3eXpwOZO1ahTT1i1BreyJlC5OuBszBkuO
	qDjfPn/s6zyNRlBw8C/ORrE6HpagUwzZpmufmubtkN6d5VKPfTDEQ4s9+I7PnkS8OMsrTJ
	JVRbVt1Jm7SSETjGKyxtymkJcSJZm+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873016; a=rsa-sha256;
	cv=none;
	b=BU5DQSTmDyreoDQeyoYbfxGbCgSImFHBGPfq+2iRIHx/qs7ULIzFKdYGzb12b6yI2TzMe4
	o9yDcTUvUzpT55OIcALmcCVRhQKoKDe/BA0aaQHsq/BukHLDcGZi5NMnPItFDp2yNeWSUj
	UWDSCGMwrSz69uHPvj0AX9pbTubDddo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=m8oMUPg5;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-467161c4a1cso33266b6e.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873015; x=1774477815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/r4lbyJWNRb4OPU+FwoTkjRVnxoVbk6U7PxvuQ43o+8=;
        b=m8oMUPg5AAaGIzT49f3Scace2CUkqYahVpW9IFcbesciqRTxDcPNYCIeynd6X2LlQS
         LiwNLx1/BQbVV6c7GRtEWfRlMTqA7QQOt+wIhEx1MtYAycphwq9vNSYGIS0ZzTUQ+5BN
         6V+lfSyRtukGNX6GuopQEJi17+hUUQm9NtYQ9UTDWnvn0RXkAUVtKsEGvOlSIRDMy5ae
         xywEYghZyIHndUOpnUa3GMEcp2F2C6B4VnZFRdU10LgOk32iCB2zGwPYdQYkY6JmUmJ8
         e1vJin2gtYLXs2ykd5aRbKn3tV4HGdOqcJHSKiDtT20vvbLv4/ayr3L5fgb0JZUzHrN4
         iiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873015; x=1774477815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/r4lbyJWNRb4OPU+FwoTkjRVnxoVbk6U7PxvuQ43o+8=;
        b=hFmDDaORm1opVnPn7K7tlOgDGATTfg7KdJAzc6/5vvwdez7e/MrEgKsrGb1qEc6I5N
         aY7Qjh4mCWvagBPIbm1gGnlNLHV9ufTRepSH1kXmSeidw19Sf4vyA1eyRB139ZUH1B5i
         dCDVtzWfowndRTSC2+q7CtemOlBB2kKv7hK0CgNi8Fani4fnjohHzEc6JEZVN9MhX/7F
         Dw3e1pTPSWYU2a6i/DBGUqUx5xHBfvzBXWhrtoAYZPux6o9nsXE+3CtMOGt7+ol5nsjT
         4pjpum9FlOl1dSWiAQ+ZznsR0M6rQwm3UeBw13I4gvxOzU2+JIv446DwOgKkNsZYEAwh
         +YLg==
X-Forwarded-Encrypted: i=1; AJvYcCUnmH7uhdIY6Akxrm+XaFGx9UXO0S5wvNRvGp/HVEK+ZFs+/86m+GezEH9gePrI7EUTLX0KnL8CJA==@kvack.org
X-Gm-Message-State: AOJu0YxCr1k5OyT6SBeXaeCRcAypQ1+Ai31SJ89/ZMxKbLbNhPEUXARf
	ToaWSGpriJwSl13Ls5ftOtnp8FoQqAOVgKcqFo/gCsK0pgBMSyYsc8QJ
X-Gm-Gg: ATEYQzyoKoWUibJOwTYspx+WNrDh5qGk3ktSC+LRCq7lGsX1DoJ3shGvpAl7eLUy7//
	65qABpodKVXH/C56uz+SDbYvOmuINcOkje3ppMsvDYCatkutKP2udNESP8QByShgrObnbHaR3Z4
	GTl+XV44d1N6q7Ox/0fHxJ67VNmz53wC1TTwxoJE/1psle6uNwfITZ6GeuioGgisEKvj9eZEO4u
	3GsFIXOaanHzZ4dvSA45l1LDo6JKmPnZvsFpC5a3qqGj7wwdWbcP1Y0c2Wby49ePlOaIoDL7hin
	bXBdPywY1XMm1VWyV0aLYnTJWbInpwjkb6j2ZyjqR3VrSd9/cUvRda9GXFsIp2ESHPb+pyMwAuh
	fT82Q9GZlfiEaWxkfd7K5snZg4g6/wCCnX9rYliwjdiJbWWT7gHyt2aZmwciMboDKzNfek3g80X
	qKlotY5xjSxHV86J8BaYXLqkYuLp1VCBapaOQwk0TeHIK7cg==
X-Received: by 2002:a05:6808:16a7:b0:467:db5:8b21 with SMTP id 5614622812f47-467b9f4cf4bmr3062816b6e.0.1773873014996;
        Wed, 18 Mar 2026 15:30:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-41bd2c2d51esm4194088fac.11.2026.03.18.15.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:14 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com
Subject: [PATCH v4 12/21] swap: implement the swap_cgroup API using virtual swap
Date: Wed, 18 Mar 2026 15:29:43 -0700
Message-ID: <20260318222953.441758-13-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: orej7m83qsnf858m7uese78w1cd6ho8s
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D06920005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773873016-507206
X-HE-Meta: U2FsdGVkX199ksnzaxC6TqcOVDGE0ZWeGFPFKPYgrXh7Y9/BkVy0V6zNgoh+FA8wuaS2qckhl8DxIucqMzxuJzBW94P2x4jqyn+oNB4wUXE7mvVISpExHp/kDHQNf6DXGFX4hiSyUShrD0YyDI5XWCoKZ5tA776MC/ROjyPLBYcAaU8y/MhUXI1L5yTBM0LqPv7W+bYgl/cxMsdroyYnzF3W5y3dqVFn+WO7BkymzdmT4RlWMr4/eGnjMoTxAX3kUsesNEzxtxqV89CHH/OPsbqO11lQeTmkStOOEnytWKaolf12mOi07be7CK1UHIn27qLVdG4CsuY/2dYxwmwy6uGJBaYze9sizrhE0uFzN/x2Plaqxt4MOxdUKqnNb807qwl+qLr4zCgEMcbsjpTvNZmjT5BEo44LXdkWv+Ajz5d1Y+sdA6O/wRLHdIXIsYNe/cow6oPCcFtIj7ZzXWjIPlzlue+34P5cOB9No1iYHuvTUQ1IJNK0xZj8M5mL2hB8yedI4gtvmOeS2DxIKR5HBQZIMHDXzsNZKOyczToifEJBKLE2HRvgPZ860rM4ecKHFZxbglCeDnwr7+7vtOD3UPEJ/lEC0GU2pnOvZ6mZgepelrAUOnwgsNReBMuCIzU/+1cSEZxRQw1pTa/1Q1eBdIHtw8gcf92uY9ScdmA58tdZq4bIpC1HIdnkYDbFnW6muttvbVNddNZDfT5qDJb7BnDAGXU0sNczHwBQqcSsZriXogaSk4itwffg+enBpXnA6Ek0cMnYeMLwDua5943g72fn3/qWPLxtUsG8RhhPLqOWKvq1We9W8pv3QeRu36+ciQONYtx9y2vVli+i7n2eIuLqR0RtajfUkj+II6YcOPsPIuZKSJ3yobJHRXlfSDBO0rOtIZ8X79qs1rPiVxIwvjZPxf/MaxiqGS0l9xLHFItIlFp4m2qsHtq9qaR5hItlKtlk+JOovKbEAhccFHM
 LaMadbG+
 g2SM3pLvRbXBb3F1qgYdHJBoXGO62hT7+Ha8g0zZoJB5nMyk9v3WoT9tnH4RDtYOWNy0Ajdwz0vKvVmDMgIHvuImYQ1jNqkVdtXjrfMoch42Gk0gMm4jg1hOmyUkPCn4tRx2ldHzJ1LC980oyqNKBpfiLRFgM12gumnMRptuK79z0wmGoPdmkGv2chvT4bfgUjBgfwoR34sopirtJGCg6hOO1AGx7gaYjTl0dDGqgMfqoGFuLVPgbEafC5hb2zJU8cojH364F41TUJCmq27RqZq8uMtuBcVSldGtPsl4Q/MP0+C2KfaLUTgl2jMZRkWjpDdR4byr6eXJfo3KG5gPGtiIDjWULWDdUwSVkb9UxFLg8kycnblypjl2mud3TFyD/EEORN8Zh8ZDU4o2Y7MxbdgIuQFiaSaL1OVGHmI50r2wS2q5t9cUyKLdkoJLO28aDWHCgGh+EVOvZivD8HxniO/2PLPqPRSV+LA/SrK2tPLXc9N/upLIEukMx8rYw6qS1lk6/UwdhKfEXHg0axzPKbY5YEku8HhHf4GXdhPO7QmX3cfh+dgYmBj52VQvanxie9S1CfFhkxCz0oCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once we decouple a swap entry from its backing store via the virtual
swap, we can no longer statically allocate an array to store the swap
entries' cgroup information. Move it to the swap descriptor.

Note that the memory overhead for swap cgroup information is now on
demand, i.e dynamically incurred when the virtual swap cluster is
allocated. This help reduces the memory overhead in a huge but
sparsely used swap space.

For instance, a 2 TB swapfile consists of 2147483648 swap slots, each
incurring 2 bytes of overhead for swap cgroup, for a total of 1 GB. If
we only utilize 10% of the swapfile, we will save 900 MB.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap_cgroup.h |  13 ---
 mm/Makefile                 |   3 -
 mm/swap_cgroup.c            | 174 ------------------------------------
 mm/swapfile.c               |   7 --
 mm/vswap.c                  |  95 ++++++++++++++++++++
 5 files changed, 95 insertions(+), 197 deletions(-)
 delete mode 100644 mm/swap_cgroup.c

diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
index 91cdf12190a03..a2abb4d6fa085 100644
--- a/include/linux/swap_cgroup.h
+++ b/include/linux/swap_cgroup.h
@@ -9,8 +9,6 @@
 extern void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entry_t ent);
 extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents);
 extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
-extern int swap_cgroup_swapon(int type, unsigned long max_pages);
-extern void swap_cgroup_swapoff(int type);
 
 #else
 
@@ -31,17 +29,6 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 	return 0;
 }
 
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
 #endif
 
 #endif /* __LINUX_SWAP_CGROUP_H */
diff --git a/mm/Makefile b/mm/Makefile
index 67fa4586e7e18..a7538784191bf 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_LIVEUPDATE) += memfd_luo.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
-ifdef CONFIG_SWAP
-obj-$(CONFIG_MEMCG) += swap_cgroup.o
-endif
 obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
 obj-$(CONFIG_GUP_TEST) += gup_test.o
 obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
deleted file mode 100644
index 77ce1d66c318d..0000000000000
--- a/mm/swap_cgroup.c
+++ /dev/null
@@ -1,174 +0,0 @@
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
- * must be being charged for swap space (swap out), and these
- * entries must not have been charged
- *
- * @folio: the folio that the swap entry belongs to
- * @id: mem_cgroup ID to be recorded
- * @ent: the first swap entry to be recorded
- */
-void swap_cgroup_record(struct folio *folio, unsigned short id,
-			swp_entry_t ent)
-{
-	unsigned int nr_ents = folio_nr_pages(folio);
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-	struct swap_cgroup *map;
-	pgoff_t offset, end;
-	unsigned short old;
-
-	offset = swp_slot_offset(slot);
-	end = offset + nr_ents;
-	map = swap_cgroup_ctrl[swp_slot_type(slot)].map;
-
-	do {
-		old = __swap_cgroup_id_xchg(map, offset, id);
-		VM_BUG_ON(old);
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
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-	pgoff_t offset = swp_slot_offset(slot);
-	pgoff_t end = offset + nr_ents;
-	struct swap_cgroup *map;
-	unsigned short old, iter = 0;
-
-	map = swap_cgroup_ctrl[swp_slot_type(slot)].map;
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
-	swp_slot_t slot = swp_entry_to_swp_slot(ent);
-
-	if (mem_cgroup_disabled())
-		return 0;
-
-	ctrl = &swap_cgroup_ctrl[swp_slot_type(slot)];
-	return __swap_cgroup_id_lookup(ctrl->map, swp_slot_offset(slot));
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
diff --git a/mm/swapfile.c b/mm/swapfile.c
index a47e024f2152c..adfcce286258f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2934,8 +2934,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	vfree(swap_map);
 	kvfree(zeromap);
 	free_cluster_info(cluster_info, maxpages);
-	/* Destroy swap account information */
-	swap_cgroup_swapoff(p->type);
 
 	inode = mapping->host;
 
@@ -3500,10 +3498,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto bad_swap_unlock_inode;
 	}
 
-	error = swap_cgroup_swapon(si->type, maxpages);
-	if (error)
-		goto bad_swap_unlock_inode;
-
 	error = setup_swap_map(si, swap_header, swap_map, maxpages);
 	if (error)
 		goto bad_swap_unlock_inode;
@@ -3608,7 +3602,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->global_cluster = NULL;
 	inode = NULL;
 	destroy_swap_extents(si);
-	swap_cgroup_swapoff(si->type);
 	spin_lock(&swap_lock);
 	si->swap_file = NULL;
 	si->flags = 0;
diff --git a/mm/vswap.c b/mm/vswap.c
index f2ebd79854572..95d683cf4505e 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -41,6 +41,7 @@
  * @zswap_entry: The zswap entry associated with this swap slot.
  * @swap_cache: The folio in swap cache.
  * @shadow: The shadow entry.
+ * @memcgid: The memcg id of the owning memcg, if any.
  */
 struct swp_desc {
 	swp_slot_t slot;
@@ -49,6 +50,9 @@ struct swp_desc {
 		struct folio *swap_cache;
 		void *shadow;
 	};
+#ifdef CONFIG_MEMCG
+	unsigned short memcgid;
+#endif
 };
 
 #define VSWAP_CLUSTER_SHIFT HPAGE_PMD_ORDER
@@ -242,6 +246,9 @@ static void __vswap_alloc_from_cluster(struct vswap_cluster *cluster, int start)
 		desc = &cluster->descriptors[start + i];
 		desc->slot.val = 0;
 		desc->zswap_entry = NULL;
+#ifdef CONFIG_MEMCG
+		desc->memcgid = 0;
+#endif
 	}
 	cluster->count += nr;
 }
@@ -1109,6 +1116,94 @@ bool zswap_empty(swp_entry_t swpentry)
 }
 #endif /* CONFIG_ZSWAP */
 
+#ifdef CONFIG_MEMCG
+static unsigned short vswap_cgroup_record(swp_entry_t entry,
+				unsigned short memcgid, unsigned int nr_ents)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short oldid, iter = 0;
+	int i;
+
+	rcu_read_lock();
+	for (i = 0; i < nr_ents; i++) {
+		desc = vswap_iter(&cluster, entry.val + i);
+		VM_WARN_ON(!desc);
+		oldid = desc->memcgid;
+		desc->memcgid = memcgid;
+		if (!iter)
+			iter = oldid;
+		VM_WARN_ON(iter != oldid);
+	}
+	spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+
+	return oldid;
+}
+
+/**
+ * swap_cgroup_record - record mem_cgroup for a set of swap entries.
+ * These entries must belong to one single folio, and that folio
+ * must be being charged for swap space (swap out), and these
+ * entries must not have been charged
+ *
+ * @folio: the folio that the swap entry belongs to
+ * @memcgid: mem_cgroup ID to be recorded
+ * @entry: the first swap entry to be recorded
+ */
+void swap_cgroup_record(struct folio *folio, unsigned short memcgid,
+			swp_entry_t entry)
+{
+	unsigned short oldid =
+		vswap_cgroup_record(entry, memcgid, folio_nr_pages(folio));
+
+	VM_WARN_ON(oldid);
+}
+
+/**
+ * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
+ * These entries must be being uncharged from swap. They either
+ * belongs to one single folio in the swap cache (swap in for
+ * cgroup v1), or no longer have any users (slot freeing).
+ *
+ * @entry: the first swap entry to be recorded into
+ * @nr_ents: number of swap entries to be recorded
+ *
+ * Returns the existing old value.
+ */
+unsigned short swap_cgroup_clear(swp_entry_t entry, unsigned int nr_ents)
+{
+	return vswap_cgroup_record(entry, 0, nr_ents);
+}
+
+/**
+ * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
+ * @entry: swap entry to be looked up.
+ *
+ * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
+ */
+unsigned short lookup_swap_cgroup_id(swp_entry_t entry)
+{
+	struct vswap_cluster *cluster = NULL;
+	struct swp_desc *desc;
+	unsigned short ret;
+
+	/*
+	 * Note that the virtual swap slot can be freed under us, for instance in
+	 * the invocation of mem_cgroup_swapin_charge_folio. We need to wrap the
+	 * entire lookup in RCU read-side critical section, and double check the
+	 * existence of the swap descriptor.
+	 */
+	rcu_read_lock();
+	desc = vswap_iter(&cluster, entry.val);
+	ret = desc ? desc->memcgid : 0;
+	if (cluster)
+		spin_unlock(&cluster->lock);
+	rcu_read_unlock();
+	return ret;
+}
+#endif /* CONFIG_MEMCG */
+
 int vswap_init(void)
 {
 	int i;
-- 
2.52.0


