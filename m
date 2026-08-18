Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D213CC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 913406B08BA; Mon, 17 Aug 2026 22:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C2EC6B08BB; Mon, 17 Aug 2026 22:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8BC6B08BE; Mon, 17 Aug 2026 22:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55D476B08BA
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:47:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41861140A68
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:47:45 +0000 (UTC)
X-FDA: 85112854890.11.4212079
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26E62C000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:47:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WQ+Cj8mw;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787021262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=o8HXjTmtSGyMNj4VnIyLtTJCTZHouZ2WYIC15u5uiAg=;
	b=aprpi4G3R/FEtmufuRKjGkPO9x0KKE3/SDI2WpAdB1MWljT+lRN6bvMvQM4JMwCbfjEjZI
	yqA9tWJ8Vm/wsRfVUFS30atWqE4KptwHNvbS+T3BRczcq4MRcZTrqYUpvzpSMhQKOXyM4d
	71OR4sbKd72hfgSELmM7SPSE1TSEcPk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WQ+Cj8mw;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787021262;
	b=szvW7wZpnbGU74l6ae2NhSyN7ZUQf5Zsgjl1vu0cevBTU3pQzLy8WM9f6mzQnRtFjkop3T
	H5QzkOt34RRb4ZQu5Vhad9YNAw4mnlJHyUo0oP1a8L4erc3OUgQ79Y5kxk4iVajhW8D3Ww
	tpEpPd/IKnfZyyomXiguv3wbFAiuxvI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787021258; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=o8HXjTmtSGyMNj4VnIyLtTJCTZHouZ2WYIC15u5uiAg=;
	b=WQ+Cj8mwZmaBFLekZcDMQlJNnUAv2TNgEIw/11vHEfNWqL9dn3KwvaXeBg+F84z/K8RxVXY3Equ8/FBqsT5+z54Wdz9mmKLpAxBuqcYKKsr2IGqxns7UW7TH6Klgkkl6qvftCNK5jzhKvTwgDNr+rkQ5ekAvQQrAAcVB1n/C60k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X9Blfsr_1787021256;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9Blfsr_1787021256 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Aug 2026 10:47:37 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: vbabka@kernel.org,
	annh@google.com,
	ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Tue, 18 Aug 2026 10:47:26 +0800
Message-ID: <7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 26E62C000C
X-Stat-Signature: eafk9mnenq7ab9u8foor7zwb3ik65x6q
X-Rspam-User: 
X-HE-Tag: 1787021260-98800
X-HE-Meta: U2FsdGVkX18GNcwtD5sgrULsPz1UcRHA2OG/A7XEZNPUDMlQa45IWbRQG/gdXjnfzvYDxVtXvqH4m3EKpWgZ6RtddA1lFKcnw+jVqjbslVkgSuMH2E8yvrpJOrnvb/LZdQiDed4yPZ55GEaD6kTfAtSyzqC+M0XsZOVM4yye5LXlGSS+98ogBEL8hd2OKemb9U9XwMkPJBVM86iOSredTtdU0SDXR8iCsLOtwHASn5K/jvBVhm9OCrLS5vbL1gm8BGXv4hBa4YGft0IsNbgs2ZOjOgTnZo2a2Bx0wTg0qiD/lQdhsw5v1p52y4KRtvs1weuT2/TD5Tth+xQkGFZe4tkmLLyj6gpqDX3/tJ4S/2MRJKqjvhP32h4ELhl/PXKWChTQbCCRVYXZDru+r+aiTpoQ5kaoyji/c8T1K80B762+0YWFM9wtOqW1Q8J9oUcVNOR/O6CQI62ReX+E5zlvGDKDqPBYurULqH5PJBTBViFCkEc42YiM1KJyVcdB2UaGwfm1M+JpCj/1CRTlqcE6yp1bWb6yK8I1z610pSgwv706EJuB63bASZMga2DnFbT/QacSZwKIZIVHjeCjsLZT773akBF18Q2Sign+ejRGHGZd6l52Yp5dNOi8buebwI1wbJFlG8Pxtm4hEVNy5r5F8fCRaNZz34OoRWNknI14neulrjFDiKxN4g9OmfWOnOYDNoOdzzSmMwebo8TKR9Qlzg153MAaIUIY9jU72bAVYXQrrL9P2+Ar0IpbwHBCdJSxyuZjxKhuseddob86dT4mGgdbwhuTzdY9vcWlyDq/qhhlpOI33g03fYhPaOJFCVP5kY+oLngk6mYC+sm1kBNgq4NaPDVPca133fw2ruGOHBAAf1Tc0hq32qtpLFt/2nuwkmaqzlhBSEFwV67wwcX5PpSJ9KFBSrhzLzq2DuRtPUR4QFChRJ3pOvbbZWytsQie7fCdJn0mt6WdHN1Fv+f
 Z+DY6PBb
 82bw8ma2l4kXcGKZhMuw5XYgOTqO6ZvJms4apuubAvca5TPLDQAlotHgclTgq7DCtX/+rY0ou2a7F4Z5D6sGv5Z/TVp8Vt/7WLDKYsTRpPK91rRhCDjcD8T0CCwWkt7Di3MPyD6Ts1D+RXy5hKuunrSv1MpGXgA4EkET9fWzbX9/4at0PBOdVIFFInvU21AXZXF7DJof4lJmES6eejG7Hv6sYVUJq5CQI3LPeO5kGrCWhVX0ftT5TVxirDz184vMQL6992z1YMQ9ZAoO0n+pAstFhV+bTKqqqQv43MdEMsB+IkrVWnEgnkS8S3dicdlx7rhWY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lance reported that when nothing else causes the mm to be considered for
khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not trigger
scanning.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
vma->flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for collapse.
As a result, khugepaged does not collapse the tmpfs file into PMD order in time.

Fix this by calling khugepaged_enter_vma() with the new VMA flags in
madvise_update_vma(). Meanwhile we can remove the khugepaged_enter_vma()
in hugepage_madvise().

Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Cc: stable@vger.kernel.org
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from v1:
v1: https://lore.kernel.org/all/ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com/
 - Update the commit message (per Lorenzo).
 - Call khugepaged_enter_vma() in madvise_update_vma() (per Lorenzo).
---
 mm/khugepaged.c | 6 ------
 mm/madvise.c    | 8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5a06e3942e88..79effd3f3da4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -454,12 +454,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
 	case MADV_HUGEPAGE:
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
diff --git a/mm/madvise.c b/mm/madvise.c
index c179938097bf..cb93cf82d8df 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -178,6 +178,14 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vma->flags = new_vma_flags;
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
+		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
+
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 
-- 
2.47.3


