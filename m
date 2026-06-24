Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9046CCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 08:58:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F0306B0088; Wed, 24 Jun 2026 04:58:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A25C6B008A; Wed, 24 Jun 2026 04:58:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A2C6B008C; Wed, 24 Jun 2026 04:58:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01BA36B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:58:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69F3F1202B2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:58:29 +0000 (UTC)
X-FDA: 84914205138.07.4E94C0C
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8CF1F18000E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 08:58:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DqzeXJwN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782291507;
	b=7OAoAIaqlm1oNRtrvudrSLs8/b7Q6JaUeuGDYmXoAtwroI/1Gh2f1X5/w4e/xPRdUZdmp0
	KG/XLFj+9G3kF7k/2YJFjbXq/dMBaFxTZMuQYjX+GBt6r13ywc33QAz1zxye+zhY1lWRbd
	YrS7ydDCYSQ4USz/6wQEG6Pp91nhbj4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782291507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXPW+YBNntz9f0Lp8avROen0rFA3jB4hGj6rmd8rypo=;
	b=PWxvQNtey5mIwk+mwzKDt5g4kYGN6yCdYZHopfHP1MHlIBUggDhqmbxK9ZPY+VxJn4iOao
	LINhOBmzwbfll92l+ixF1B9RooDURAT7oPiarnkEWNPdNeuUYidKSS3iUeUqZunGgMXBF1
	ZamXpPzoEdZNjURUr28FVYpcnNdFaO4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DqzeXJwN;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782291505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXPW+YBNntz9f0Lp8avROen0rFA3jB4hGj6rmd8rypo=;
	b=DqzeXJwNf5gDBGu1OcL4/hrbV9Hi1AXOHwTCheCL8GbteM8Cem4O7iA9uT/jeE696Ozhmn
	Cm1ez+SF+AitEURBxgb1tUSkQcp5Fw9X5eQrpr1OJ6rdTzeyNFIv+JRBpsjgpbZFvsfJ+G
	/aZo7pU8DQ1WTrzMM0taz0iO8CxoXJs=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	ziy@nvidia.com,
	sj@kernel.org,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	lance.yang@linux.dev
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private PMD handling
Date: Wed, 24 Jun 2026 16:57:56 +0800
Message-Id: <20260624085756.6598-1-lance.yang@linux.dev>
In-Reply-To: <20260624065353.1622-1-richard.weiyang@gmail.com>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CF1F18000E
X-Rspam-User: 
X-Stat-Signature: jmmd5gpd9frmrbtdgjqbkpmbc841xin7
X-HE-Tag: 1782291507-298930
X-HE-Meta: U2FsdGVkX18tU1RDIrCFL1e2mRcBsp9d8QMhSSxPN0cK8ubuYghtcUIdY4A/ZHGIKRmwhrlHJE+GAkoXDvEh9FnZBQdOu4SZ2KcZdTgdtwSZAB88uVWb6Fp5hv+YOWvulUk9LZECiwzBWGo4dw7aZxmIJAew90r8vI+hAZsZSrfWcJO/6AuFnJjlhQvUMv59RYfFiYtoNVaBfocpc6XkUnwZ4GH8gP9Ek85WQr+exPFurZgyJZc/v5dWfxBnKTAw2xaqicILx8H61l87WBhu/9qSwK/RnqC2XGXaNQ5ck9CbM5f1SMnbGf9elXa2mSAzw664oVjy3zSjCDFogNq3W4IV/6QlvHQnQ3TAc0zRdSgGqs7CeaR0SsuTsoAcgA6XWCGWTozoCMxCScVvnqdH4n6e+bOMG2+2SCOKTDSK1IxKw5q8P14ydvQiTxrn17EEueozkA8sxJ74zCNc19gwTrq2hDmvtCWdE0P1kfLjAUgz8wDT8avriBXLTXFTXr6XjAw0oP2EiIWr04IAiRnUghEAYOwtcJOLxM6j1WjUtml9twjHrgC8F2MXjuSNlFH85FAcF2v1heQNg4M6VcRX4qJSYE2gwsHutTHttaV/XM+oPy0uRWXrr5oymzwQOLfnKV+7ulBlg9ari5ndDGjUS4wBc9p73uxFenQhC85E1pxyfjbmt0cAD+MRX51VAfb4EBjmZxh7dmdlqOmw+TVcdprSCM+P7Um0ZbNNavRh7n7aAJUVZDlqqcL/lh/fXxtK31bWJMvUQMkguHWqlSxDTPS8P5N9rHS7lD1WTMxea0tnMFSAzrElrfOlcqaxfCN6CrguORGbL3/YbItqUmVEruskF1KYzug0aWIpgdFjjraHZ2Xb99fUtYof3tYkaeacaMaWkUIJ91SQTbQVdRTRLg8AV6X6MBrP8tC5giZ6hNY2LiS2blkfkSCd1++PP0HOxy81FnHEmR22oWWGpZQ
 naQ5A51R
 ZhklKrsIbJ1hncc8sL97Wv+6Yk5QFC6K6JIiLa7twRj3iyNTW1jfiRIbawEASen7Y+NS1VLLmPp/htvC34eqgyCiaRWmBI2yLtxP/mpzGPVj0tRf5ogM0POuyeNoBXRv/gkmgQcZI+er5adS3G0hWM+h9BObOBXM50VEkks6qla9VqIStriHD7SUDxUufOhqZ7juOE+7MGc3QaRGIzrjqjjJNi+7XCM3EorHtIifuyWD6PR195N2McVRnf1zrcaqHWSDcTm0G9eKrt1b8VIl9bOUoXzhGmJo7nNIpnag5diD9TaFZVJOmBcq85z4wqVBOEguz1PCFngA7C4NqaftJlgoMSbPYXKHRdEvaTPlyTLEsuRTfht6v6YLYRvL8mocwSjPix3cYGHI2qTsPVm2N7m6mew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 24, 2026 at 06:53:53AM +0000, Wei Yang wrote:
>Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
>device-private entries") introduced the concept of device-private
>PMD entries, but did not correctly update the rmap walk code to
>account for them.
>
>As a result, when page_vma_mapped_walk() encounters device-private
>PMD entries, it takes no action other than to acquire the PMD lock
>and exit.
>
>However this is highly problematic for two reasons - firstly,
>device private entries possess a PFN so check_pmd() needs to be
>called to ensure an overlapping PFN range.
>
>Secondly, and more importantly, if PVMW_MIGRATION is set the
>caller assumes the returned entry is a migration entry, resulting
>in memory corruption when the caller tries to interpret the device
>private entry as such.
>
>In addition, commit 146287290023 ("mm/huge_memory: implement
>device-private THP splitting") allowed device private PMDs to be
>split like THP mappings, but again did not update this code path.
>
>As a result, we might race a PMD split prior to acquiring the PMD
>lock.
>
>This patch addresses all of these issues by invoking check_pmd(),
>ensuring PMVW_MIGRATION is not set and checks whether a split raced
>us we do for PMD THP and migration entries.
>
>Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Suggested-by: David Hildenbrand <david@kernel.org>

Shouldn't we add

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>

as well?

v4 mostly follows Lorenzo's comments, code bits included. Feels only fair.

>Cc: David Hildenbrand <david@kernel.org>
>Cc: Balbir Singh <balbirs@nvidia.com>
>Cc: SeongJae Park <sj@kernel.org>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: Lorenzo Stoakes <ljs@kernel.org>
>Cc: Lance Yang <lance.yang@linux.dev>
>
>---
>v4:
>  * refine subject and commit log based on Lorenzo's suggestion
>  * put pmd device-private entry handling in its own if branch,
>    suggested by Lorenzo
>
>v3:
>  * remove cleanup part, only fix the issue for device-private entry
>  * refine user effect description based on Lorenzo's suggestion
>
>v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
>  * specify the possible error case of current code and user visible effect
>  * besides fix, cleanup the pmd entry handling based on David's suggestion
>
>v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
>---
> mm/page_vma_mapped.c | 20 +++++++++++++++-----
> 1 file changed, 15 insertions(+), 5 deletions(-)
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index 2ccbabfb2cc1..17dff8aab9f9 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -269,14 +269,24 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)


Hmm ... looks like there may still be a race here ...

Current code picks the branch from the lockless PMD value:

		pmde = pmdp_get_lockless(pvmw->pmd);

		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
			pmde = *pvmw->pmd;
			if (!pmd_present(pmde)) {
				softleaf_t entry;

				if (!thp_migration_supported() ||
				    !(pvmw->flags & PVMW_MIGRATION))
					return not_found(pvmw);
				entry = softleaf_from_pmd(pmde);

				if (!softleaf_is_migration(entry) ||
				    !check_pmd(softleaf_to_pfn(entry), pvmw))
					return not_found(pvmw);
				return true;
			}
		}

But after taking PTL, the PMD may already be a different non-present PMD
type:

CPU0: pmde = pmdp_get_lockless();   // sees PMD migration entry

CPU1: remove_migration_ptes(src, dst /* device-private */)
        ... via rmap_walk(dst) ...
        page_vma_mapped_walk(&pvmw /* src, PVMW_MIGRATION */)
          returns with PTL held for the PMD migration entry
        remove_migration_pmd(new = dst page)
          installs a device-private PMD
        next page_vma_mapped_walk()
          drops PTL via not_found()

CPU0: takes PTL
      pmde = *pvmw->pmd;            // now device-private PMD

So when PVMW_MIGRATION is not set, current code can return not_found()
before we even decode the locked PMD as a device-private entry.

Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
device-private entries") made the

device-private PMD <-> PMD migration

transition possible.

set_pmd_migration_entry() can replace a device-private PMD with a PMD
migration entry, and remove_migration_pmd() can restore a PMD migration
entry back to a device-private PMD when the new folio is device-private.

Maybe decode the locked softleaf entry first, before the migration-only
checks? Something like this on top:

---8<---
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index 17dff8aab9f9..97babd408dba 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -249,10 +249,18 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			if (!pmd_present(pmde)) {
 				softleaf_t entry;

+				entry = softleaf_from_pmd(pmde);
+				if (softleaf_is_device_private(entry)) {
+					if (pvmw->flags & PVMW_MIGRATION)
+						return not_found(pvmw);
+					if (!check_pmd(softleaf_to_pfn(entry), pvmw))
+						return not_found(pvmw);
+					return true;
+				}
+
 				if (!thp_migration_supported() ||
 				    !(pvmw->flags & PVMW_MIGRATION))
 					return not_found(pvmw);
-				entry = softleaf_from_pmd(pmde);

 				if (!softleaf_is_migration(entry) ||
 				    !check_pmd(softleaf_to_pfn(entry), pvmw))
@@ -266,7 +274,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 					return not_found(pvmw);
 				return true;
 			}
-			/* THP pmd was split under us: handle on pte level */
+			/*
+			 * THP pmd was split under us, or device-private PMD
+			 * changed under us: handle on pte level.
+			 */
 			spin_unlock(pvmw->ptl);
 			pvmw->ptl = NULL;
 		} else if (pmd_is_device_private_entry(pmde)) {
--

Anyway, that stuff is getting kinda messy now. Feels like it really needs
a cleanup on top before it bites us again :)

Cheers, Lance

> 			/* THP pmd was split under us: handle on pte level */
> 			spin_unlock(pvmw->ptl);
> 			pvmw->ptl = NULL;
>-		} else if (!pmd_present(pmde)) {
>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>+		} else if (pmd_is_device_private_entry(pmde)) {
>+			softleaf_t entry;
>+
>+			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+			pmde = *pvmw->pmd;
>+			entry = softleaf_from_pmd(pmde);
> 
>-			if (softleaf_is_device_private(entry)) {
>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+			if (likely(softleaf_is_device_private(entry))) {
>+				if (pvmw->flags & PVMW_MIGRATION)
>+					return not_found(pvmw);
>+				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+					return not_found(pvmw);
> 				return true;
> 			}
>-
>+			/* device-private pmd was split under us: handle on pte level */
>+			spin_unlock(pvmw->ptl);
>+			pvmw->ptl = NULL;
>+		} else if (!pmd_present(pmde)) {
> 			if ((pvmw->flags & PVMW_SYNC) &&
> 			    thp_vma_suitable_order(vma, pvmw->address,
> 						   PMD_ORDER) &&
>-- 
>2.34.1
>
>

