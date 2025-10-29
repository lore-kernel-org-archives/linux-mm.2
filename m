Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DC8CCF9F5
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 891B38E0041; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 720A78E0045; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFBA8E0047; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3E68E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05817BB5C8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:08 +0000 (UTC)
X-FDA: 84050547336.26.9EE9790
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7E261C000B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZBLXFa6uBZrOJOz/lWKg5GO5329xohg8x3u1k8fsbno=;
	b=U0/C3+QRkDh9nezSUptdkWXcJiCKGH4TXiJI7RUpojv0Ql79LDVmdLY+c7n4QPmVsHN+t2
	MoXaYLjw05EiD56rYDt0TQC5UGVNJJU+jbVMA05mR7L9F//aig1/0p+fozuAEK53h6oe5i
	x6p54EJlW8KPew47emql6hhYYUd2L0A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf18.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728226; a=rsa-sha256;
	cv=none;
	b=bolMf0Wom87stCtg2YqKMHFZppojY0e5yPP+QvG9tAYXUZmIqXaQU17CqdBmzO/9611LgP
	y6kAwTlKR6iHkhdzA6zQ2+s8sqKm3w3sOiaa+l8XSbXI3JcQSeHRpIfSPacRGWX+DBUIWJ
	RUJzKWZFrLcATj7oBbfWY1aKkDVaDn4=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 5/5] mm: swap: remove scan_swap_map_slots() references from comments
Date: Wed, 29 Oct 2025 17:56:59 +0900
Message-Id: <20251029085659.2005942-6-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029085659.2005942-1-youngjun.park@lge.com>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E7E261C000B
X-Stat-Signature: syk1oe1s3343nysmgq38ege1ucow1f9j
X-Rspam-User: 
X-HE-Tag: 1761728225-829494
X-HE-Meta: U2FsdGVkX19BLCtbydBlkPLN7iezs+TV/w3ksucxuzCEUjtcFcK64JRYkYUu2ktB1blOPzmtF9roD3Ktcfphh7LemzQAAHlYG6vq+lBceJhZ4a7fyk/T534dv5M6GmGieEW01TLTSiC0Wv0AyE6PD0Dl7Vnlm6dvuYX1rm3YWeF5caa2I3u6yS/ZV6GhH4ck+vTeZWE/aB8zWc//CKHJJ/yP6ZH4ulL5IazUgrHq9pOdp5k2KbepS8odQbOWmIaXMVt0n04fSfEleFHit9G3bZ3ijPhi7+HAN5nyqCuG6m6N1UdjFDJKxa9HKEskMkBwF0zQq6983P8R5hdfEXBSVGUidi+03SGtJIObwNugZQ+uoiBGnMhIp2IJ5ZqpceKoX8YZ+gZpR3QWfvRvnuS3Ni0bCVh5KdoJx0dL7cY1a6pxtKULFo7eWo4iVw9X3TeAtkXSLdDhUhuZCfeiqieT2n0U8EJQSVq86F26xspZkfNYy7lGxUTsYueXqXcjgewjLkxfD0XlKluCPMZbA8klpUG0Ewnw7xD5qpH6hjVv0CRGh7xInACTONvdUDx+cgnZEMdGCiqHFoN/ICEuBGRpAiEYJC8eb0kqlN0wAD2YNuVrRdpUZecgQGutVmFme8Uh4g76PyC1lvlHGq3sTp3wiuF24TGHAq6rG08Ax/zhxfh9s27AFCyI7Uv1XF50z26em00xTC7aDXzps2cdxFT0PZKk9e96Lquv63oE8/O+rRnj1uN8w5lbEB3BXOzdfD3UXjyuRE/AkGciPLeHJkVULc6q5bJd5q0UjpnXYMknf7+tpPXXuLpEByp3/b2Tl0161ldXV6Oe6x5w87pRQWktvxq8Feuey/7/Ud9NxFE6d6aNpf2IjB5k46UIoixZSpZhDfPDCuyvRD+sZlo+V9N5cmyAaWtUIpjmRebmb/MjX53wcNA6GLVMfIThmO//1bK64IIqu1DxIZ1tsoTp98y
 YXWeKzsT
 wpWewBIt7yuBNt4shBnw45JUfLuNrIHlgj3XPVo3E0nijkD183+pzwOowFN4rS2W4qT4pMaaKKyxHbkQ0KNmbjcBWp+Lla1DoJ4DCrSt/pPLGRGK75KUSj8JXWHCc28nOfyqUykt55bXSHPuoip/PBUYkeEPPWcUt0R8sE2vsWhb9SPCYFGiklNyqY+BtjsEP6zRV+WGh59tVk/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scan_swap_map_slots() helper has been removed, but several comments
still referred to it in swap allocation and reclaim paths. This patch
cleans up those outdated references and reflows the affected comment
blocks to match kernel coding style.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 89eb57eee7f7..1dace4356bd1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -236,11 +236,10 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
 	ret = -nr_pages;
 
 	/*
-	 * When this function is called from scan_swap_map_slots() and it's
-	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
-	 * here. We have to use trylock for avoiding deadlock. This is a special
-	 * case and you should use folio_free_swap() with explicit folio_lock()
-	 * in usual operations.
+	 * We hold a folio lock here. We have to use trylock for
+	 * avoiding deadlock. This is a special case and you should
+	 * use folio_free_swap() with explicit folio_lock() in usual
+	 * operations.
 	 */
 	if (!folio_trylock(folio))
 		goto out;
@@ -1365,14 +1364,13 @@ static void swap_alloc_slow(swp_entry_t *entry,
 		spin_lock(&swap_avail_lock);
 		/*
 		 * if we got here, it's likely that si was almost full before,
-		 * and since scan_swap_map_slots() can drop the si->lock,
 		 * multiple callers probably all tried to get a page from the
 		 * same si and it filled up before we could get one; or, the si
-		 * filled up between us dropping swap_avail_lock and taking
-		 * si->lock. Since we dropped the swap_avail_lock, the
-		 * swap_avail_head list may have been modified; so if next is
-		 * still in the swap_avail_head list then try it, otherwise
-		 * start over if we have not gotten any slots.
+		 * filled up between us dropping swap_avail_lock.
+		 * Since we dropped the swap_avail_lock, the swap_avail_list
+		 * may have been modified; so if next is still in the
+		 * swap_avail_head list then try it, otherwise start over if we
+		 * have not gotten any slots.
 		 */
 		if (plist_node_empty(&si->avail_list))
 			goto start_over;
-- 
2.34.1


