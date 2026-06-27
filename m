Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356ACC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 07:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247856B00B8; Sat, 27 Jun 2026 03:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F276B00B9; Sat, 27 Jun 2026 03:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136736B00BA; Sat, 27 Jun 2026 03:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D342C6B00B8
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 03:29:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EB641206B8
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:29:07 +0000 (UTC)
X-FDA: 84924866334.01.007BB11
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id A4F791C0002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 07:29:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XSUE3L4y;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782545345;
	b=L5pxgeMRdSo6NADTssJNXQfAsQ6wGBRy0Hlrau4dbbWeFm5o02UNZhXuukLLg81ykeoZFB
	qNbIXe6fJf849nfJKyca17TpUdDMmf70Keru+ta+K4jUqnWhcqqmuyMmSorImYMgVXW5fc
	uHTrVIVOr69nW9wWqwDz1fhtplrtWsY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782545345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRuLJLBuH6j6zdjrokpjXZlXNw46jtgxgv9wbeaPyw0=;
	b=R/7yuFenIYYK21AkEx5cy5JsQQJ3BYb/ZLOht3OnlykpsLEywWPNYIcKfvD49B81H/GYZv
	aupo3/aodR9rYjX81kKQ6MN1K6sMVcivpQuQvRPC0MKuZmygE6JMn4NwBsmjD2cs20yG6q
	Io1et3GmhxX115kK6NeOPPFvQPp/5G0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XSUE3L4y;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782545343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oRuLJLBuH6j6zdjrokpjXZlXNw46jtgxgv9wbeaPyw0=;
	b=XSUE3L4ygidj2LuzqJHduoBljIjkFqnbPv9xeQQetCa/JRNqmUg1qx9TZqEU4PTu/50WPV
	aSovBpO2t/jHcqexD4YbNNrWHC9jeAR44BVYAi/MA7NKoXF2OJ/cimITZjko+qhOTPZ4Ty
	7tSYgeX98/uyJz0LfzvC1LM5KRe4eEY=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	peterx@redhat.com,
	usama.arif@linux.dev,
	willy@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [RFC PATCH 8/8] mm: add MADV_RESERVED_THP range policy
Date: Sat, 27 Jun 2026 15:26:44 +0800
Message-ID: <080d04d5e5dc8e517091ddeddb641beb6e0f1b97.1782538002.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1782538002.git.zhengqi.arch@bytedance.com>
References: <cover.1782538002.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: cfx4r9x1zu6x8pcnyf3bwuz1pqpya5k5
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A4F791C0002
X-HE-Tag: 1782545345-25246
X-HE-Meta: U2FsdGVkX19sEen1PwnYVWcpI318oKuWrQkr8sWoIwS2g5ibOSkYMAWlXdJuZelaiL6MSNpsl8rfsWESaFJcUSE8YgJLkeJswf5ZqMWzsvDc5hR0DU4AjyMkPtt01Tk41g/nLlcovZr4cp0/r7NUf8iOxMHzys/flTQBNrK3CplhuYD76uWP7ZRvWGG/h4ZSMyJCVPS/XvSkEBOwDrbl2VfwQ36NIVs07sz25yrlc821GmH3+lUXrxXi9GuV3fpuUIA63VKBRJKVb3gShJ6AhuMXk4kgIU6yeS1SophEcEMySikfw2i3O3lyigr9yIWqYaldcu8EkgJ0AYxNJBgvRDje1qqi0joKZLwErTavuRxnYxWuw7bX4CxdcKeHXo/6zBFyxyub+cOIIQePByeIjG89BFrgjtTRu/S+E4GBDcv/FUgJ8WSE+B37Vv6kfQ1998yuPOWSFhuU3tkN+rX1xhMqhFWGumMoflkd5Fw81Cpr/Wy4tqUkOQQlRKjvNKi2sdR2UlXPYhh2kG/OQD2nQKWn51rSvajO9gIzhdL1DcB6YWLUQoY6zOcJBXoX2i8T8JVkble/QxpeHvVjIJJ3fbTj6Xab/uDbBMkHdETb+eAiBzPHNf9fAlp9U2MHJeYcS3i4XY5/C71toW435RytZ6aqSbZAHeKRdqOsCLelwO3B/w1n4eESTyTt1G5aNndbsIb5w4R7HiVud3680L4H61unLi7Ad0pcL6+TBWl4poqemKgQjP22N+vmADIOT9LH52LaPr1b6ezw8kljYAhvIIKiIxwCSQEyP6oC1gEPm1HARh+poBhozHV71UvtLQjR2hYYAl+Bon0Vt6jUzIagFewm8tsRQM+A91T8MUUznAlzL4r7eKQzhqjRyuVRBp3riO9PErRvFIx9Tt/m8CIu6y2Ti9x9ub02b1gFzq7kkfuydULLLqd92s1y7jU242QDrqsG2PizXyLvB0wgPSK
 rzo8q8yh
 mZnc3dIeeZEB463eCpO0I5ntOU5oqK9ggHW21IaDgaH/fusFd9WucONlF5/Yp0TVwS66sVEuvj0rqnf0iQPZst+zFvpo3Rrh7mA8H2Y44jSk1lC7nBOxdFcnY+xiDc9KkKyunA3LbxotAUh1HvJyziEsTCPeqhxaOuXYAuSEKVKVRjBtkT4lYKFjWUTE83a58rH4dV9XFZZnUunYyffYQX4eoIBaW/H3E0x7Kbbi08qFitY8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Introduce MADV_RESERVED_THP as a new madvise() policy to enable PMD-sized
reserved THP allocations for anonymous VMAs.

The policy enforces the following rules:
- Limited to private anonymous VMAs with PMD-aligned ranges.
- Mutually exclusive with other hugepage VMA flags (handled via
  hugepage_madvise()).
- Charges the reserved THP quota upon success, and rolls back the charge
  if madvise_update_vma() fails.
- Rejects partial madvise operations that could split PMD THPs.
- Rejects MADV_COLLAPSE, as khugepaged cannot currently allocate from
  the reserved capacity.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 arch/alpha/include/uapi/asm/mman.h     |  2 +
 arch/mips/include/uapi/asm/mman.h      |  2 +
 arch/parisc/include/uapi/asm/mman.h    |  2 +
 arch/xtensa/include/uapi/asm/mman.h    |  2 +
 include/uapi/asm-generic/mman-common.h |  2 +
 mm/khugepaged.c                        |  8 +++
 mm/madvise.c                           | 83 +++++++++++++++++++++++++-
 7 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/include/uapi/asm/mman.h b/arch/alpha/include/uapi/asm/mman.h
index 1e700468a6858..672a2fc343861 100644
--- a/arch/alpha/include/uapi/asm/mman.h
+++ b/arch/alpha/include/uapi/asm/mman.h
@@ -78,6 +78,8 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_RESERVED_THP 26		/* Use reserved transparent hugepages */
+
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
 
diff --git a/arch/mips/include/uapi/asm/mman.h b/arch/mips/include/uapi/asm/mman.h
index b700dae28c482..a94bf74dee21c 100644
--- a/arch/mips/include/uapi/asm/mman.h
+++ b/arch/mips/include/uapi/asm/mman.h
@@ -105,6 +105,8 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_RESERVED_THP 26		/* Use reserved transparent hugepages */
+
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
 
diff --git a/arch/parisc/include/uapi/asm/mman.h b/arch/parisc/include/uapi/asm/mman.h
index b6a709506987e..fe2fddefb6c5d 100644
--- a/arch/parisc/include/uapi/asm/mman.h
+++ b/arch/parisc/include/uapi/asm/mman.h
@@ -72,6 +72,8 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_RESERVED_THP 26		/* Use reserved transparent hugepages */
+
 #define MADV_HWPOISON     100		/* poison a page for testing */
 #define MADV_SOFT_OFFLINE 101		/* soft offline page for testing */
 
diff --git a/arch/xtensa/include/uapi/asm/mman.h b/arch/xtensa/include/uapi/asm/mman.h
index 99d4ccee7f6e8..bb603530ba799 100644
--- a/arch/xtensa/include/uapi/asm/mman.h
+++ b/arch/xtensa/include/uapi/asm/mman.h
@@ -113,6 +113,8 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_RESERVED_THP 26		/* Use reserved transparent hugepages */
+
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
 
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index ef1c27fa3c570..b3d1448935ead 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -79,6 +79,8 @@
 
 #define MADV_COLLAPSE	25		/* Synchronous hugepage collapse */
 
+#define MADV_RESERVED_THP 26		/* Use reserved transparent hugepages */
+
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49b..80293e8c1e4e7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -451,6 +451,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 	switch (advice) {
 	case MADV_HUGEPAGE:
 		*vm_flags &= ~VM_NOHUGEPAGE;
+		*vm_flags &= ~VM_RESERVED_THP;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
 		 * If the vma become good for khugepaged to scan,
@@ -461,6 +462,7 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
+		*vm_flags &= ~VM_RESERVED_THP;
 		*vm_flags |= VM_NOHUGEPAGE;
 		/*
 		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
@@ -468,6 +470,12 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 * it got registered before VM_NOHUGEPAGE was set.
 		 */
 		break;
+	case MADV_RESERVED_THP:
+		*vm_flags &= ~(VM_HUGEPAGE | VM_NOHUGEPAGE);
+		*vm_flags |= VM_RESERVED_THP;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072cc..dd91105db68c7 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -13,6 +13,7 @@
 #include <linux/page-isolation.h>
 #include <linux/page_idle.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
 #include <linux/falloc.h>
 #include <linux/fadvise.h>
@@ -1331,6 +1332,65 @@ static bool can_madvise_modify(struct madvise_behavior *madv_behavior)
 }
 #endif
 
+static bool reserved_thp_madvise_aligned(struct vm_area_struct *vma,
+					 struct madvise_behavior_range *range)
+{
+	if (!(vma->vm_flags & VM_RESERVED_THP))
+		return true;
+
+	return IS_ALIGNED(range->start, HPAGE_PMD_SIZE) &&
+	       IS_ALIGNED(range->end, HPAGE_PMD_SIZE);
+}
+
+static int madvise_hugepage_policy(struct madvise_behavior *madv_behavior,
+				   vm_flags_t *new_flags,
+				   unsigned long *reserved_hpages,
+				   bool *charge_reserved_thp,
+				   bool *uncharge_reserved_thp)
+{
+	struct vm_area_struct *vma = madv_behavior->vma;
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	unsigned long hpages;
+	int behavior = madv_behavior->behavior;
+	int error;
+
+	switch (behavior) {
+	case MADV_HUGEPAGE:
+	case MADV_NOHUGEPAGE:
+		error = hugepage_madvise(vma, new_flags, behavior);
+		if (error)
+			return error;
+		*uncharge_reserved_thp = (vma->vm_flags & VM_RESERVED_THP) &&
+					 !(*new_flags & VM_RESERVED_THP);
+		return 0;
+	case MADV_RESERVED_THP:
+		if (!IS_ENABLED(CONFIG_64BIT))
+			return -EINVAL;
+		if (!vma_is_anonymous(vma) || (*new_flags & VM_SHARED) ||
+		    (*new_flags & VM_SPECIAL))
+			return -EINVAL;
+		if (!IS_ALIGNED(range->start, HPAGE_PMD_SIZE) ||
+		    !IS_ALIGNED(range->end, HPAGE_PMD_SIZE))
+			return -EINVAL;
+
+		error = hugepage_madvise(vma, new_flags, behavior);
+		if (error)
+			return error;
+
+		if (!(vma->vm_flags & VM_RESERVED_THP)) {
+			hpages = reserved_thp_hpage_nr(range->start, range->end);
+			error = reserved_thp_charge(hpages);
+			if (error)
+				return error;
+			*reserved_hpages = hpages;
+			*charge_reserved_thp = true;
+		}
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 /*
  * Apply an madvise behavior to a region of a vma.  madvise_update_vma
  * will handle splitting a vm area into separate areas, each area with its own
@@ -1342,6 +1402,9 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	struct vm_area_struct *vma = madv_behavior->vma;
 	vm_flags_t new_flags = vma->vm_flags;
 	struct madvise_behavior_range *range = &madv_behavior->range;
+	unsigned long reserved_hpages = 0;
+	bool charge_reserved_thp = false;
+	bool uncharge_reserved_thp = false;
 	int error;
 
 	if (unlikely(!can_madvise_modify(madv_behavior)))
@@ -1353,14 +1416,22 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	case MADV_WILLNEED:
 		return madvise_willneed(madv_behavior);
 	case MADV_COLD:
+		if (!reserved_thp_madvise_aligned(vma, range))
+			return -EINVAL;
 		return madvise_cold(madv_behavior);
 	case MADV_PAGEOUT:
+		if (!reserved_thp_madvise_aligned(vma, range))
+			return -EINVAL;
 		return madvise_pageout(madv_behavior);
 	case MADV_FREE:
 	case MADV_DONTNEED:
 	case MADV_DONTNEED_LOCKED:
+		if (!reserved_thp_madvise_aligned(vma, range))
+			return -EINVAL;
 		return madvise_dontneed_free(madv_behavior);
 	case MADV_COLLAPSE:
+		if (vma->vm_flags & VM_RESERVED_THP)
+			return -EINVAL;
 		return madvise_collapse(vma, range->start, range->end,
 			&madv_behavior->lock_dropped);
 	case MADV_GUARD_INSTALL:
@@ -1416,7 +1487,11 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(vma, &new_flags, behavior);
+	case MADV_RESERVED_THP:
+		error = madvise_hugepage_policy(madv_behavior, &new_flags,
+						&reserved_hpages,
+						&charge_reserved_thp,
+						&uncharge_reserved_thp);
 		if (error)
 			goto out;
 		break;
@@ -1431,6 +1506,11 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 	VM_WARN_ON_ONCE(madv_behavior->lock_mode != MADVISE_MMAP_WRITE_LOCK);
 
 	error = madvise_update_vma(new_flags, madv_behavior);
+	if (error && charge_reserved_thp)
+		reserved_thp_uncharge(reserved_hpages);
+	else if (!error && uncharge_reserved_thp)
+		reserved_thp_uncharge(reserved_thp_hpage_nr(range->start,
+							    range->end));
 out:
 	/*
 	 * madvise() returns EAGAIN if kernel resources, such as
@@ -1541,6 +1621,7 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 	case MADV_COLLAPSE:
+	case MADV_RESERVED_THP:
 #endif
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
-- 
2.54.0


