Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C93C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8816B00AD; Mon, 14 Sep 2026 08:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E430E6B00AE; Mon, 14 Sep 2026 08:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80266B00AF; Mon, 14 Sep 2026 08:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B47C86B00AD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 478B91403E8
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:42 +0000 (UTC)
X-FDA: 85212304044.04.8D29F0A
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6627080002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3QkhiwX;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389100;
	b=n/uKpDNa8w1v9AQTUTZzFaxfXyY9TKLU4UxSjSfEKRRtvcOMUgEQb6wLihCUdpTUnkMO9d
	C9c5MPN2njshYkGU5ihStfa1s/8dN+gf7LJhCbIBNygVYp6JqEqWclwPB51LeQNQspZ41D
	8dYT0XaKUc/JrtduMzeiUGDRJQZ9ORs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h3QkhiwX;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b3bHPjnijjHdyNtHymNgOZFA449OJW0IvFSgvmBh8vI=;
	b=y/QfRKt30bE6AyZEO8Y69V9NtAf4cuxEQSlyfjeTOgtQOLtCHm0DdhimsJkG3OxGKnNvmq
	DIGo+pLgBteBzZZSduf/IBRewQI4QQIe81tKSaSr8y7Hr5poYpQupSnLKPdoseVp+TK59K
	OUfPeInv4462/EYiiGBL2mXE6RmPwqg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ENO5TWLGQORFi4I6GbjA3CLf4xd6bsmKP3WV+1rfFXs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389099; v=1; x=1789993899;
 b=h3QkhiwXYcTZIuHPfBY/OApK3oAnJPSf4MiaDXPLEk9gGD9P6GFCYLAoIXZBL/jB3dUBs7VG
 FtFp5iyFFU+RiwZ8UliwaICS2TK2uZ70h4jBqnHRXIdK82c5JEM0SWi/byRUAi8R5q1edN5041a
 nF94ai5PgXcbzkDYzG9wWh48=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id da37515ffb07b15a;
	Mon, 14 Sep 2026 12:31:39 +0000
X-Mizu-Trace-ID: da37515ffb07b15a
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 15/29] fs/proc: account PMD swap entries in smaps
Date: Mon, 14 Sep 2026 05:28:05 -0700
Message-ID: <20260914122950.3283997-16-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6627080002
X-Stat-Signature: yf7nyxgsift45g3kf75jt3xqtjw8bxej
X-Rspam-User: 
X-HE-Tag: 1789389100-332573
X-HE-Meta: U2FsdGVkX18BA/VKXhP15rKAEElRuYNlgFboaO/XUlzUgg+Sf+JVWttt7suU5GoAzprsEHwvEoyAHAK+HA+hUeno96wfAvk01nyVntAxn5KCo7qGj9C3/lrr8tK4rJcLZ1I7CFqjt+KB1mKM+pgFlQnbxkbR5HydOebta2u9dJd9Oqutwz7IkvnyhMIky+uxAPxX4xQiB0OAZOUH9VaZE8vcGdPltzx8k9NwGERAwV6Fd80tePMumuNMekrAyJI1d9rKJUZNJIwac/+6zWP/w1x0kcPJbuFQgOo4jpeL1kg213ITQYKWEs3v7ZDkibiuMP7rru77DlSSq5MJWp1xhdaMA6CU5YklrXwl8Y5QK90GisBfKG4cU50y1p+S8db6RCiWAWWuxz7qqd+rYnOWeGK88GkQJHEqc1Ppdg2LbSJM3zt0jZ8bMbP6DxcmwPea6UGF5vRVfIVCqH3+Ggbiwvv930PDId3EatUpD1CNu0ruuxDNw2GSKDQ12raynZpIMEM/kOmNiXDCynP0AzAcLncSfThvnFjbmlgiOgfBIZuBdP3uSjVcOiBgsKACimRGDxs1PqBeLESlLhSX2miuBrecLCz+0z5jDn0QGfv17hxwwqOZLnplyVhXXxYBv4T3j5zSAbN6RuIJn0ubrxaqWTycvfkCUPqSMBzmhwU+EP0izk3R4IJMmoK+VxkxLC4taI1dFqCnguyvkp+Y/9RLUPmEU4PsiYU5ECCH7SXE1GfQHBhtyBlcIGu3Kitb+e5uMFVdnmbB91kSlDFuZc48S0XqjeMcen9SZtlVatbI0LvzuElMdgjX4yw0j4Qpwyxzyjk5Y3IBns6xrWIIltTaqC79yt13l8IKoIaDZewGbLdChEWbBOJVEAhW00AT1DlQa4PAQTcv+usABQP94bRMUZQxN0x5SQvd8fFxxYeo2ZuLiI8MlE8j69MbZZenis9i3jI80Q35JT6yXTp2Xxs
 rttsvtx0
 zBDjmxblRme8/UVcIlHVnr5abiqEFNiQc7st0apx4OlAPW77Mds3SKJc7CaY2+sJhMDiV826oN7iJHDFGcImLQDy4YTvj8ZIpv0MyGl0eIZJax3xMUTsp34RwaBfAbttHBuMPE4evaRym9i/y3b/5uMk9o+bTCMy8zpCBw7ZhfOEVHpClbws3uMkU6y4munEY1b3avXqrxr1oglA7ggsuIopwIIbwhg5TnCdl6uxZ82iOAaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

smaps_pmd_entry() derives a page from a non-present PMD and gives up if it
cannot. A PMD swap entry carries no PFN, so a swapped-out THP is accounted
nowhere: its bytes show up in neither Swap nor SwapPss, and VmSwap silently
loses them.

The slots of a PMD swap entry can have different swap reference counts, so
SwapPss has to be computed one slot at a time rather than divided once.
Factor that loop out of smaps_pte_entry() and call it from both levels,
then return early: a swapped-out THP is not resident and must not be added
to AnonHugePages or Rss.

pagemap needs no equivalent change - it already emits PM_SWAP and
type | offset+idx for a PFN-less softleaf entry - but its
thp_migration_supported() gate answers a different question than the decode
requires, so use pmd_is_valid_softleaf() there instead.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/proc/task_mmu.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 24425e2308951..aa3f4d54a8580 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -957,6 +957,27 @@ static void smaps_pte_hole_lookup(unsigned long addr, struct mm_walk *walk)
 #endif
 }
 
+static void smaps_account_swap(struct mem_size_stats *mss,
+			       softleaf_t entry, unsigned long size)
+{
+	unsigned long nr_pages = size >> PAGE_SHIFT;
+
+	mss->swap += size;
+	do {
+		int mapcount = swp_swapcount(entry);
+
+		if (mapcount >= 2) {
+			u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
+
+			do_div(pss_delta, mapcount);
+			mss->swap_pss += pss_delta;
+		} else {
+			mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
+		}
+		entry.val++;
+	} while (--nr_pages);
+}
+
 static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		struct mm_walk *walk)
 {
@@ -978,18 +999,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
 		const softleaf_t entry = softleaf_from_pte(ptent);
 
 		if (softleaf_is_swap(entry)) {
-			int mapcount;
-
-			mss->swap += PAGE_SIZE;
-			mapcount = swp_swapcount(entry);
-			if (mapcount >= 2) {
-				u64 pss_delta = (u64)PAGE_SIZE << PSS_SHIFT;
-
-				do_div(pss_delta, mapcount);
-				mss->swap_pss += pss_delta;
-			} else {
-				mss->swap_pss += (u64)PAGE_SIZE << PSS_SHIFT;
-			}
+			smaps_account_swap(mss, entry, PAGE_SIZE);
 		} else if (softleaf_has_pfn(entry)) {
 			if (softleaf_is_device_private(entry))
 				present = true;
@@ -1019,9 +1029,13 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pmd_present(*pmd)) {
 		page = vm_normal_page_pmd(vma, addr, *pmd);
 		present = true;
-	} else if (unlikely(thp_migration_supported())) {
+	} else {
 		const softleaf_t entry = softleaf_from_pmd(*pmd);
 
+		if (softleaf_is_swap(entry)) {
+			smaps_account_swap(mss, entry, HPAGE_PMD_SIZE);
+			return;
+		}
 		if (softleaf_has_pfn(entry))
 			page = softleaf_to_page(entry);
 	}
@@ -2000,7 +2014,7 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_UFFD_WP;
 		if (pm->show_pfn)
 			frame = pmd_pfn(pmd) + idx;
-	} else if (thp_migration_supported()) {
+	} else if (pmd_is_valid_softleaf(pmd)) {
 		const softleaf_t entry = softleaf_from_pmd(pmd);
 		unsigned long offset;
 
-- 
2.53.0-Meta


