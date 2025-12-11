Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D53CD41C08
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 08:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560AB6B000D; Thu, 11 Dec 2025 03:17:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA416B000E; Thu, 11 Dec 2025 03:17:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428196B0010; Thu, 11 Dec 2025 03:17:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB876B000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 03:17:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB9401407C1
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:21 +0000 (UTC)
X-FDA: 84206485482.10.A0CFD90
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf16.hostedemail.com (Postfix) with ESMTP id 536AF18000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:17:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gJo4993S;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765441040; a=rsa-sha256;
	cv=none;
	b=2LTEMhiYIfs9t9TRfgYCTJofEwotAyl7gYlNFETsYrtQJxzN1JT32gYIrPMEgq6Ny5oZfV
	IsiUBuvEWBVTQsN2g6sbeCa0eDzi4eR1MXC5jfgVgVY6h5S6lHPDxr/U70fXPk1L/S/xvZ
	NFiDbhNuMd5CXRVm7z6S87+FWYvb5yk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gJo4993S;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765441040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTUtfG6uYByUGiREez0T2P/sllJfoIOg91OqMSv2QCo=;
	b=GdQlVGZmKhcefyX1mcs1uweIEb2A3rEVJG506zRZDzE7Vk6TSH3RXYfLUe0hyrEOblt3I3
	fuD0iET1VSaqvSL7hBX7g8orfBrgWq9p0R92h83t87XJIJniT9FXd59GfghmLsixQqbaCf
	MiZPdo4PgAcjfxzDYVZxXIOv4Cj2/iM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765441035; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=GTUtfG6uYByUGiREez0T2P/sllJfoIOg91OqMSv2QCo=;
	b=gJo4993SZkNx01mWQ6MeC3Fw+IYxByVyhZDRR9vJ6k1L9JJzXVA5emuoqZiUBlPCSn3gJfEj+C2dWyT+gJ8tpjboG+vt9A3XfbnMjOdShZYU891+Ib5M9FMIJkqwO4Gs7mupJBRGkPRy/xacdXNsuS4Ul8WvftrsBFKoUEN/w18=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuZjI5S_1765441033 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Dec 2025 16:17:14 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large folios
Date: Thu, 11 Dec 2025 16:16:56 +0800
Message-ID: <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87876mx3o7bkrcmam9opjrdf43go1shb
X-Rspam-User: 
X-Rspamd-Queue-Id: 536AF18000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1765441038-22295
X-HE-Meta: U2FsdGVkX19VFhBOkfuwXAcrqSEfwDDeDlIuMpvTxRRJQYdYq1i9aEmwm+oc6Hv1qX8sIS3BLiNGbPLpcQWSnwd66r5/pJC/G9k/JvmHMPRlMCo43TlpvryH2HxcENCBCCClwzejh1gYhNrO5n5BV4qcMoxJiStOv6j12/gt1lWACBIJwjMKOBvIzNsemxsBj3mH4itUDqrZ/kUGc8jYGP5THmypBRpR23SE6sxDjlzEuf71IOPfAxb4GEjN/KM+hzi+terq3iaB/lJyxe5zwPFC21BVeqZnHYFRhxchbnW6sy/Lz5GU7YCORutHiAFzLHp4FjQKqgAcV3se9feUvfQsn8UlzK6REHWEEzPtRXy3I3/UR7y5isd89qkBgI49G7qhwDmFjdqH1RbSuDe+Ja7wNPl8jW77R1/2RCYNGzNvc79frYCP6LIs7ZfSS2fgIV60uILSuesfwKmeTtieGAy0+DBtM6MmpEoVJtV1/dAcU9ijeD/oc1hPA2JqkrtxX/1ia/3dMtM+ow3f/Xvvf9n/TeTdwsK2761bND4F2fE2oZmLMmCdGupMN+zOz53x568ZPw2/uMEMMe+A3KbG2HNHLLPRJsKMkKdDC7gTbWR/ZpUKyAGOtz2pUraN1GfLQjUcCIAwyRT0RllHpe9lkh1q0vUbLtxO3TfLD+XlwzTMBBhEwAITtzXcSA7yQZ6U7awmqAeJh5s9UWaAddDgFRQhW195D4uCjohKzV6I4OOajvk72PT/BgYadbjddtSuATISkUbmXohxGIhI/Rw1f1Ce8mow+zASmhMgB+RW4keQLYzfkjatNy6U2gySuNo4/f2VWmrP3GfKWu4xWUl0VjfrevQfeVXLNdP7ESd0YOaddASrjhgOpxMK6bAKpS+AeofcA1ym5G47d1D6sojKMmskzA3OXQbfgNwGsZkljfSP2ocxnnTrU5CPtp11iOMfOQjGPxWTf6vdmVU6Zha
 7LhdmIXy
 4hLKNtFCESn9fRu7UdeP0GmAXgrI0lHiG4DlUNySadZThlfz/VXl4GYQaegRLemBUFvrsdFypwaqPAXEn3u/ya3xjsMq/0QJC1oxUVWeGoeBd0n/9PTEZyrHOAq3ZMVX1OMaVWySZDHIazmGiGJ8Mk6lNWehq9uU7oZ0SDVT61QMWoRtWJP8asHXbCtsU1kGnrMwde0gKHbk4JQgg2jKSZjkNgK2R1HGbMApOEWC8o91g+51Q+mm0ykihSS3AAou0ofdn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to folio_referenced_one(), we can apply batched unmapping for file
large folios to optimize the performance of file folios reclamation.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
75% performance improvement on my Arm64 32-core server.

W/o patch:
real    0m1.018s
user    0m0.000s
sys     0m1.018s

W/ patch:
real	0m0.249s
user	0m0.000s
sys	0m0.249s

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index ec232165c47d..4c9d5777c8da 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree batching for now ... */
-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+	/* We only support lazyfree or file folios batching for now ... */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+
 	if (pte_unused(pte))
 		return 1;
 
@@ -2223,7 +2224,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(folio));
+			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio))) {
-- 
2.47.3


