Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA29C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FC226B008A; Wed, 29 Jul 2026 12:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2942E6B008C; Wed, 29 Jul 2026 12:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183396B0093; Wed, 29 Jul 2026 12:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1F216B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:31:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 488E3A0754
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:31:07 +0000 (UTC)
X-FDA: 85042353774.16.09B9924
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id E8DC6160014
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:31:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ty0EPwJ7;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785342664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Agx6gglrE7HK2NAFLPhWCB/RYb4kEft2KttpOxW9oio=;
	b=iWOB5V0RVQMnWTkCmJtQC7KY0G+LzxRyoOFuWH0cIth0Bmd4mlUxa1uBxBgGEGVUeNOcvl
	Xn92VoAS0c31ZiNHpoxRRUm5Ph+789PjQmzk82jVhaNb1MFVGwVO3YgxwbXDoV0M+zFowc
	fcixdLyGusKjT1fNrCO3mjzrnfQfjQw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ty0EPwJ7;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785342664;
	b=qOAbu7hb4cChThmc2fmYkkxng+SIagsDMHCfhtD2jiB4IawBdWRIGNEy5YOB7J8w+C6a34
	VXKjH82dDlQ4weh4n4CY17Fkcx6tYZkARfmyxylXogmXUSxJ63twYA2GDPuAkGuWfiaG7X
	hQcqe9HehSj8sutY9fMseQQD+8GW4EA=
Message-ID: <26f6af3b-5967-4501-b1e6-cf6969b8bb39@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785342661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Agx6gglrE7HK2NAFLPhWCB/RYb4kEft2KttpOxW9oio=;
	b=Ty0EPwJ7Ug0HWEPbMkFaiOrGFlwbxEq2zrVPJiV/g8ZVduaHP2W6KQw7sY1cGO9kWcg6Xq
	ZsPRDCywfbZfyyhiznU616E1LwJ4Ax5owS08QelcZkdJd2XEstBuU6D3nS3c+cc5L45zcu
	SfeiGxZt4yEWfX9+78ECPxi0NpcyF5A=
Date: Wed, 29 Jul 2026 17:30:49 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 10/11] mm: install PMD swap entries on swap-out
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr,
 kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>, ryan.roberts@arm.com,
 Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com,
 yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-11-usama.arif@linux.dev>
 <amJoe_iRHEaMdo9i@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amJoe_iRHEaMdo9i@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E8DC6160014
X-Stat-Signature: sxha9r63xx9xk8swggczeh6yj8j7xzwa
X-HE-Tag: 1785342663-280028
X-HE-Meta: U2FsdGVkX1+BGKhYXhyxxycojGVfMZzdlQO7XuTJLQ4kP/ldKK1VpzOZo88TureHpLuO32kSN6vEaQbKWM5O0SxcdaY+5Hbtq/UqsAJZhHaeikry4kbYudURa3mVYPZGE8ALn0LP31/HlMoc8S5qOYoWecNp3WAKFtGcga5kFNhtKtDvEfofSqoedFgKnvU65DbELaH0DcgSdaC/EhX5aFQcj7uyZXdxiR+N77ttB/vewfNUWmZZ8pza8Dylrfh8ydjswZfLuS47asOldJ8deRLr0JR8q4/E1uabtG8WwmSDG7rI2kuYC2A3CSwTDFoFhCkwuNf6KWkTbKCF/9dAX8LD6vweTQmH99k6eSJ6hRNUTFSKuPQpUlEoBNyA53y2MJZebxFcQuiJ3sWxdlAvgoIsWrtpqfG/b6Hmf1ZjVEXW8IFSZ2VELkxDQOy0V8NESY5hG7ZO0HpE5RuZPfIe4X67eDD0EFHKOdklaBLSCBHTUTOnrU7PFp578nGbJ2HZtFVUZhvJR+DiuHWtmSR4YpGH+GOlftC1RnHbyhttgn5IKpwt426Gs1ScXGgyqxB1ef/f5HUYVzB0Aedo3HBB4mHuMDJFKX84S0gIo9CicP6h31mSsWStXZGfeM4d/9hC74KnX1wHvhv6WktHdZ9mOnQ7d6wweiPLxFo0+Bf6CN225XHnC0xhAnaHvBUwGn691uyrBEZLANzt5s8VaZUna7XuVkrMbHJcc8X4Zw9qXsJG4UwOt1Cm/0eOeiguhC61Uif2G2G4Qt0Id66QvNS8pZkEpMNXjiRz0SM3RhnwHpAG4V/pLnb59TZdl0KGrOqRAsxiHGAqQxVww1X0jLnJbUtQSjvAALx4afwi9vUvLQ9pUNRTq7BLqWVYY/V6Ow/9Xa801a8USCekpMFJVsr+8QDIZgWNHtEOJlgXdj6VGO3UMD/fKo9TddVL+z4C2XPFkpuQZida8qMQeeA+Kpf
 /PchnPsZ
 XUT9lmEa/00LrKazde8PkOqnBVA0Cq3QgBbYPVfwjpuOHWOO3cPjpnB3CmWCDaImEwWvVOSJRVpzI2qXGTrmyjE6C2slO3fIFg7EvDiFQMExy/8nsR0KvSOuZlP1ZZCgQrJNa817u8ZzufJUKuwbaDB6ox2xvF9HR0l/rCseMDhutU55447s5RP2zcmvq7Hkm1qV5vFawPRim0OMhPY/s/cUehw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/2026 20:16, Matthew Wilcox wrote:
> On Wed, Jul 22, 2026 at 08:19:41AM -0700, Usama Arif wrote:
>> +++ b/mm/rmap.c
>> @@ -2282,6 +2282,25 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>  				goto walk_abort;
>>  			}
>>  
>> +#ifdef CONFIG_THP_SWAP
>> +			/*
>> +			 * If the folio is in the swap cache and we're not
>> +			 * asked to split, install a PMD-level swap entry.
>> +			 */
>> +			if (!(flags & TTU_SPLIT_HUGE_PMD) &&
>> +			    folio_test_anon(folio) &&
>> +			    folio_test_swapcache(folio)) {
>> +				if (set_pmd_swap_entry(&pvmw, folio))
>> +					goto walk_abort;
>> +
>> +				add_mm_counter(mm, MM_ANONPAGES,
>> +					       -HPAGE_PMD_NR);
>> +				add_mm_counter(mm, MM_SWAPENTS,
>> +					       HPAGE_PMD_NR);
>> +				goto walk_done;
>> +			}
>> +#endif
>> +
>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>  				/*
>>  				 * We temporarily have to drop the PTL and
> 
> This makes me sad.  It feels like we're bolting more complexity onto
> try_to_unmap() instead of removing TTU_SPLIT_HUGE_PMD entirely.
> 
> Ideally we'd just cope with folios of whatever size (including
> PMD and PUD mapped folios) and only handle hugetlb weirdness when we
> absolutely have to.  Similarly, we could split PUDs to PMDs and
> PMDs to PTEs when we need to, without the caller specifying
> TTU_SPLIT_anything.
> 
> Is there a reason we can't do that?

Hi Matthew,

So I have been looking into this over the past few days, and I can't
come up with a way to do this without having another rmap walk, which
is expensive.

I tried to prototype this (code at the end of the series).
Removing the flag required an additional rmap walk (split_folio_pmd_mappings below),
MMU notifier handling and different fallback behavior on architectures without
PMD softleaf support (see #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES below).
It makes the code more complicated and expensive.

It also changes the behavior of every try_to_unmap() and try_to_migrate()
caller, while this series only needs reclaim to preserve a PMD when it can
install a PMD swap entry. I would therefore prefer to keep this series scoped
to PMD swap entries and handle removal of TTU_SPLIT_HUGE_PMD independently
with the broader rmap, migration, architecture, and THP-splitting review
and testing it requires.



Untested prototype below:


diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index a174758f7777..0e0172c0c852 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -93,7 +93,6 @@ struct anon_vma_chain {
 
 enum ttu_flags {
 	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */
-	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
 	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
 	TTU_HWPOISON		= 0x20,	/* do convert pte to hwpoison entry */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6f7acae5a5fd..1012cb625452 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3905,6 +3905,38 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 		split_huge_pmd_if_needed(next, end);
 }
 
+static bool split_folio_pmd_mapping(struct folio *folio,
+				    struct vm_area_struct *vma,
+				    unsigned long address, void *arg)
+{
+	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, PVMW_SYNC);
+	struct mmu_notifier_range range;
+
+	range.end = vma_address_end(&pvmw);
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				address, range.end);
+	mmu_notifier_invalidate_range_start(&range);
+
+	while (page_vma_mapped_walk(&pvmw)) {
+		if (pvmw.pte)
+			continue;
+		split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, false);
+		page_vma_mapped_walk_restart(&pvmw);
+	}
+
+	mmu_notifier_invalidate_range_end(&range);
+	return true;
+}
+
+static void split_folio_pmd_mappings(struct folio *folio)
+{
+	struct rmap_walk_control rwc = {
+		.rmap_one = split_folio_pmd_mapping,
+	};
+
+	rmap_walk_locked(folio, &rwc);
+}
+
 static void unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
@@ -3912,18 +3944,23 @@ static void unmap_folio(struct folio *folio)
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio_test_pmd_mappable(folio))
-		ttu_flags |= TTU_SPLIT_HUGE_PMD;
-
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
 	 * If that is ever changed (perhaps for mlock), update remap_page().
 	 */
-	if (folio_test_anon(folio))
+	if (folio_test_anon(folio)) {
+		if (folio_test_pmd_mappable(folio))
+			split_folio_pmd_mappings(folio);
 		try_to_migrate(folio, ttu_flags);
-	else
+	} else {
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
+	}
 
 	try_to_unmap_flush();
 }
diff --git a/mm/rmap.c b/mm/rmap.c
index b7ead3e9f064..f77f380eb03c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2282,17 +2282,13 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				goto walk_abort;
 			}
 
-			if (flags & TTU_SPLIT_HUGE_PMD) {
-				/*
-				 * We temporarily have to drop the PTL and
-				 * restart so we can process the PTE-mapped THP.
-				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, false);
-				flags &= ~TTU_SPLIT_HUGE_PMD;
-				page_vma_mapped_walk_restart(&pvmw);
-				continue;
-			}
+			/*
+			 * No PMD-level unmap operation handled this mapping, so
+			 * split it and retry at PTE granularity.
+			 */
+			split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, false);
+			page_vma_mapped_walk_restart(&pvmw);
+			continue;
 		}
 
 		/* Unexpected PMD-mapped THP? */
@@ -2459,8 +2455,6 @@ void try_to_unmap(struct folio *folio, enum ttu_flags flags)
 /*
  * @arg: enum ttu_flags will be passed to this argument.
  *
- * If TTU_SPLIT_HUGE_PMD is specified any PMD mappings will be split into PTEs
- * containing migration entries.
  */
 static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 		     unsigned long address, void *arg)
@@ -2509,24 +2503,11 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
-		/* PMD-mapped THP migration entry */
+		/* PMD-mapped THP */
 		if (!pvmw.pte) {
 			__maybe_unused unsigned long pfn;
 			__maybe_unused pmd_t pmdval;
 
-			if (flags & TTU_SPLIT_HUGE_PMD) {
-				/*
-				 * split_huge_pmd_locked() might leave the
-				 * folio mapped through PTEs. Retry the walk
-				 * so we can detect this scenario and properly
-				 * abort the walk.
-				 */
-				split_huge_pmd_locked(vma, pvmw.address,
-						      pvmw.pmd, true);
-				flags &= ~TTU_SPLIT_HUGE_PMD;
-				page_vma_mapped_walk_restart(&pvmw);
-				continue;
-			}
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 			pmdval = pmdp_get(pvmw.pmd);
 			if (likely(pmd_present(pmdval)))
@@ -2545,6 +2526,11 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 				break;
 			}
 			continue;
+#else
+			/* Fall back to PTE migration entries on this architecture. */
+			split_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, true);
+			page_vma_mapped_walk_restart(&pvmw);
+			continue;
 #endif
 		}
 
@@ -2799,11 +2785,11 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 	};
 
 	/*
-	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
-	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
+	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED,
+	 * TTU_SYNC, and TTU_BATCH_FLUSH flags.
 	 */
-	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-					TTU_SYNC | TTU_BATCH_FLUSH)))
+	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SYNC |
+					TTU_BATCH_FLUSH)))
 		return;
 
 	if (folio_is_zone_device(folio) &&
diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..12e1fea5cf50 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -182,7 +182,6 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
 {
 	enum ttu_flags ttu_flags =
 		TTU_SYNC |
-		TTU_SPLIT_HUGE_PMD |
 		TTU_IGNORE_MLOCK;
 	int ret;
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9b8ee902f972..90751b384a5d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1333,8 +1333,6 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = folio_test_swapbacked(folio);
 
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
 			/*
 			 * Without TTU_SYNC, try_to_unmap will only begin to
 			 * hold PTL from the first present PTE within a large
-- 
2.53.0-Meta





