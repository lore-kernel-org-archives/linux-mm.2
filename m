Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D09F0C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516F66B0092; Tue, 11 Aug 2026 09:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDC86B0093; Tue, 11 Aug 2026 09:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406556B0095; Tue, 11 Aug 2026 09:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD876B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:22:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 950051A0407
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:19 +0000 (UTC)
X-FDA: 85089052398.20.F472960
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9C33920005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:22:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786454538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=85M9vtfQGnwt3VvMScDiQGiivtLgVMqslBPynvyYrzo=;
	b=0s5NPYHo7vg3885uX3IWdgvbRAW8aWJrRvKwWhm7vub/pFG0yucpFwu1wcgIkR5tUqugcO
	WqdCHsNFKuO0KuTKMrWIx3dYJuhyrjZ4TytAomh1k0V7+pVo8eEj6bWxzDN6KUzTwONHwc
	4s+Yd5oksAr7YE64JgAJSCNn84Mq3WM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786454538;
	b=mprvYh+g9bsWy6r5bndXmwKeM0yx6pJvGBlr/z6Yxg5ye+ErVa+NfG3QrdGapD0ax118qF
	qD484r2GIdYYvXPxkK/kKQU6lzo+TBlyeq2aNhFbvfS78714WgZA8gINhKkXgRmruLK7WC
	Mt2dBcL4AqmXTBGEQ91Usg8fntFaAmw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 11 Aug 2026 22:22:14 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Jianyue Wu <wujianyue000@gmail.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v3 4/4] mm, swap: drop the swap cache guard and reclaim in swap_free_hibernation_slot()
Date: Tue, 11 Aug 2026 22:22:09 +0900
Message-Id: <20260811132209.2862708-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260811132209.2862708-1-youngjun.park@lge.com>
References: <20260811132209.2862708-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9C33920005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: dihebqucdscitihhoidnxpq4axsf1y8h
X-HE-Tag: 1786454536-50845
X-HE-Meta: U2FsdGVkX1/oYBnWxnB/zc12QpjGyLFdYbERN2oreYA8YMhDbt1iuVx7pw6ZADsHg7rZAhXwRORltTQR6caRnHnDQk/BVeAm0V8ilQo8gd26O3048mD5L+qitcAdvnJOLBhBTLW2eBdrjKXS2xhSQ+djdyhwrd/HgYn6E+e4m7pWv1Lg0wsbFvC2qQldOxCk+QVKbLgKg8Q7VUQWeXjsJohq2FFf2AiZvX9MS8RkWvWxFJUNzDet3rC6sF929wM3PnrW/UBXmBBux3f7hbIF0HWpBNsrKpMPVtu3qFjyenm6nCRI1HvSaEd4TCUyk3g6C2cd5O/svchXS/c6UZqS7CWvjOjLbbKITD5d0O5S2NJUEhUTeQ9zyHJbBszkHAzvMjG1oPZOddeFqkb9GtVYS7/yh7TqlfuGTzAnGGGgo1L/l619mozQ+KIFrWz7WmLcE17U/r6DkOpJ9gVNc8JZckCwcvLN+mJetV36cbKYfxDoanGs8bLwo+0S0dGedSC0f0dqnWs6yor/trAzlXVhdZXMqtICKBQHKLRjrTevIkNWehH8fs0wLLgCJidz4c6K/0cfX+SJRW1XI0uh884t2fNEHzfoouv0lbd/JlSgfnlNQSwjtoYMpYfDYY0ljrtbTjABewIMLueEK0IP6gPBsoTFcTn2D2QA+MLw4ViGQdfHCpNo+YUpM5GqcNVLgItmMG0MlcGFH2Trj4okLOPUvkunHyMysIbd2zcpNTpMziQM370GbJi1iug7TphO/mV4NiwqXvTE/05wtQW7yE8hDAFqdLJYPqIUGagtoDmVbuWxj1kAG3gYj1uAhsIRMADa8cJwl7Hs6Eo9TQTu1hsbb/lTP/CoPQZIb4VNb9YTfUamfgu6td2ARU6z0z0gmvoLBr8B7DTUK6TRiyg8ZM7iKNI+/PW5FFxiTZ27RWwfnhSIg+PysAOEg3PomiSlvz1vxRbfLiafoydjy+eUg1L
 gCvc5ly2
 gnuzL78tyFA5OH85HNnjNgwndJ/udMy13D/kFDrGEXuNkv74dD6rwTW5czdHHWIHojBm25FrCTNt9cMWT2arMhjxW8ydmSnKpwmyCvLXRTXkX0I1DUSmLV+yprZ/V0/7uwVVy0i2m37xknfxv0PcGpCM/dQoZqqGvS/Q8cJoK7lDcMNqhXBLdq7wg4a8FTLEKgh0ASUB1rMyY5Eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both are there for a folio that readahead might have put on the slot.  A
hibernation entry is not a shadow and has no swap count, so the swap cache
turns it away and no such folio can exist.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index a337387f7431..4fba1770ce61 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2203,18 +2203,8 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 	pgoff_t offset = swp_offset(entry);
 
 	ci = swap_cluster_lock(si, offset);
-	/*
-	 * A slot with a folio in the swap cache is freed when the folio
-	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
-	 * Readahead can put a folio here, and freeing the slot now would
-	 * leave that folio with no entry behind it.
-	 */
-	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
-		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
-
-	/* In theory readahead might add it to the swap cache by accident */
-	__try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
 }
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
-- 
2.48.1


