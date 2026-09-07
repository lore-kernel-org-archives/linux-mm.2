Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52ED8C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:13:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6065A6B009D; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3036B00A5; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DB76B009D; Mon,  7 Sep 2026 14:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8B0E6B009E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:12:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BB2B1201F9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:21 +0000 (UTC)
X-FDA: 85187760882.19.685F371
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A441180007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:12:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrH6PCaS;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788804739;
	b=mT19+pAPyxlJCq6VsTAd280R+0ekQQWA7Qz8aNSQpfFhzjU9UWEbXW5KhjYGK7XfFTjgoo
	3ZxH2qKXyWPGaRD6HfV0VA7+lAYELQxrYtpVWNfETKXp24C+KrLAKWG0oiaGu/nkMD+Bov
	ONtlEYVQ0Tbg1PGz2ggMLnHX9rdXmWA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GrH6PCaS;
	spf=pass (imf06.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788804739;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EeGaD1+70Ygw7x1FjbUXm2cm81/QCXgvojQFi+5LzWo=;
	b=LfYyX0X/7anE1QBFScYEP8LO/lYRZ5ipcF6iD9vuxeEhJ5x/SW8KF3nf3FgM3zGbm4LPaV
	IypLdWh+8/BVNTQOwYJPoljpQn23RrCjnlHKQFTh65wP39gtOf4RN8qSGtyIpzaXA96XbE
	yCbXIjv/tarS7hPfAb2A+SKw4XsYtv4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B68CE44781;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97E80C2BCF4;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804736;
	bh=QzcJczxkbeS/pYSsNT+urBdCyxcTnTUrjYdSKS5ReGQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GrH6PCaSr7eVHHhyAc1BrCz4vC5zPKbA+SVWkejlnaxAQ4Pmefnt/eYadIGekki4Y
	 jTOmh4YK9Hb44wQGrgWC/QTAG6ssEpyieMDqb8unw0yOIZ0DmPNIDFeLiQdK6CX2vf
	 rMI9XOjrfQVC6WH6jo1oRFcduA301t0xyJFeV+enYj8wCQf2t4GtI7fj3RomDdR4l+
	 hJfYhcF8hT85J62sMStQVFcUyR5cD0nfpYy9PXbmQRGYLFOudVkEi4XRCGt4AsSm+V
	 Nudy5b5AGwnlEz4tkjmUAv5haxtUQmW3E79wiN/hwD7ej2r4q97iMSXH3SDzWQOeeX
	 d9RFdpDN62C3w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E7AC79FAA;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:14 +0800
Subject: [PATCH v4 10/17] mm/huge_memory: move the racy refcount check into
 unmap_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-10-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=3389;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=NMmN0XNDJPzBYycE2fNg4sNy5B1+ud2QzkGI09EF/lM=;
 b=fDzQ+/qHyyE6OEBlwE+wQ4At5JOIzVAH+4OeBbdSkKrh7F9ey4Pcr6VwmnzyOnG30XZ/YNtz1
 NBVuhaXTnJ/D43G85EoyuROTa9DltenBkGsdyrBvOcY5stu/a3ARKoC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A441180007
X-Stat-Signature: nktywugettnse8gdizejm5fcdgqq848g
X-Rspam-User: 
X-HE-Tag: 1788804739-411260
X-HE-Meta: U2FsdGVkX1+fe+I1mQBIuZiioI3ri25DxmUe6ck0rx4actqop1eYdK3R/LUENHQG2JeFMN7dwEG5we1aJJijBGG1lfs0XKgYnMLcadhBsLucH9hF9ycGla4zu7yK7DxGKq2TQZ4d6V6kDIwjb/gCDO0q6Y5djFXOhwWE84TYxz7dECnh+cgHt2itB6ymGtLFGp1G4FIDbLo+2dQXs35DaRYr1//IZSf43pZPTn7BHW9gi2GwrOwsUmr7TlrflOAlC0i9dAPifVVXfnemzBhH9u60dIi1dba3cHmtQg/WniR323Gi61b+HkUlCbKlC0bh88qOmYXmKk0rU9O2yhqKExYFu2a4c0n6BxKmXXIwlx3BphGL3ki6OafYEa23mbBqw85elSiA3Oe2TS3jt0+7czR69lgkwAIf7vdxwDu0ALfvPyZ3Mmfa12UWNJPeu2HAgv4Gt1q+mApa5ly2YITNrWSamU3UvaWghcRIYu8cnux1PjuI3r891jgqFs0mIr6vswkc59WhXWKw06V3ae62LXkRj5P9FkFQLOC8tkxPxht9EB+SDYLHKyW6unJSGBYCQeUNdORr9ZV44MoCPzD6SZzjAYADRxfhTJ+2be1R5W1t1SfPPSUf2IN4GAyg+WoAfhrESHQ1FHu9udrln5xnai5GFwWC7n6kfRpHSt6uPvEnQs0QvuJ53uCDaxNZSC4epZI5mMO/nq2M7b/4v5RPh0wYb6yf5qQ1oVB7eBmYR5RFoZcA5dXXMm76a44t4E0lIWnvnZx7kTLSRcQVuFSNOA3Z71dH4SoHRH40hTQScCpmqDun86oh7GP+hUiYVacMtHsvS2qQw0Qw4xOLQSqsWRGGuxR0he1h3ohlSS9Xo7+cqQHgLp2Rt9iJ4zcEB+gBXmZkkGdrSV/fuSReMHmnr+TW4FzUfYRn4joKbRLpzDpJAlwHhs9MBdXbFO6uL/FkZGThCvoreu15sGhoG5I
 YJQm8u1i
 2U+QutJ8e+Swb2Frpn6trRdzoVM3Q6G5fQasw6mkq9oD/SbNPxlDVyUnNnv4bX/D87+RIFuuwI/AXGLwkdIfSG9M1uLEq+98mKcN4NTynKuIhGGLLogNqqVx0cmBUqR3ODh+ACBHaPOwAOJjfrcSpbnkMXrqWiPhOOgdSnEV7d7nMlb1LcN3QVPpHKIfhCAjMhTTSHQvT2W+oxtgfl+f+RRp5RxJgUJIcmJn+aPEndK/hM3/GGg5nquhaHeaC7z7eSXNSIPh5S6dQtEvU3cjkDRb4BvwYoy7LKHm8UqTUB9rtBk8JeFGdyaKCm3XDUkk8kpXNnmyzJ/V8cCu00cxtOV9ygQpMFIOpTkPZQBunx8IqFMZNmPE+daxj5AZniGy4gIq1Ht908TOFopkMmw6Hbx2t6uPww00ycKDqp/DMh3mBNVZS2TWE4KvsXzWjhHTlqoxCJ1O352sL230=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The check only exists to avoid the expensive PMD-splitting unmap of a
folio that cannot be split anyway.  Move it from __folio_split() into
unmap_folio(), right before the PMD split, so both the anon and file
split helpers get the early check without repeating it.

unmap_folio() now returns -EAGAIN if the check fails and the split
helpers propagate the error.  folio_split_unmapped() drops its own
copy of the check: it works on already unmapped folios and the
definitive folio_ref_freeze() in __folio_freeze_split_anon() still
catches unexpected references.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5279c0d0e59..17bd2c053210 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3538,13 +3538,17 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 		split_huge_pmd_if_needed(next, end);
 }
 
-static void unmap_folio(struct folio *folio)
+static int unmap_folio(struct folio *folio)
 {
 	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
 		TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	/* Racy check if we can split the page, before we split PMDs */
+	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
+		return -EAGAIN;
+
 	if (folio_test_pmd_mappable(folio))
 		ttu_flags |= TTU_SPLIT_HUGE_PMD;
 
@@ -3559,6 +3563,8 @@ static void unmap_folio(struct folio *folio)
 		try_to_unmap(folio, ttu_flags | TTU_IGNORE_MLOCK);
 
 	try_to_unmap_flush();
+
+	return 0;
 }
 
 static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
@@ -4006,7 +4012,9 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 	if (folio_mapped(folio)) {
 		need_remap = true;
-		unmap_folio(folio);
+		ret = unmap_folio(folio);
+		if (ret)
+			return ret;
 	}
 
 	local_irq_disable();
@@ -4104,7 +4112,9 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	unmap_folio(folio);
+	ret = unmap_folio(folio);
+	if (ret)
+		return ret;
 
 	xas_lock_irq(xas);
 
@@ -4312,15 +4322,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 	}
 
-	/*
-	 * Racy check if we can split the page, before unmap_folio() will
-	 * split PMDs
-	 */
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1) {
-		ret = -EAGAIN;
-		goto out_unlock;
-	}
-
 	if (is_anon)
 		ret = __folio_freeze_split_anon(folio, new_order, split_at,
 						true, list, split_type);
@@ -4359,7 +4360,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		free_folio_and_swap_cache(new_folio);
 	}
 
-out_unlock:
 	if (anon_vma) {
 		anon_vma_unlock_write(anon_vma);
 		put_anon_vma(anon_vma);
@@ -4407,9 +4407,6 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
-		return -EAGAIN;
-
 	return __folio_freeze_split_anon(folio, new_order, &folio->page,
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }

-- 
2.55.0



