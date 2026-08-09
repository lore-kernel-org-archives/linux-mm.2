Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 824B8C5AD4E
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 14:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405096B0088; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4CA6B008C; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A4266B008A; Sun,  9 Aug 2026 10:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 011AE6B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 10:46:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11D22C052A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:35 +0000 (UTC)
X-FDA: 85082007150.30.59EEDE0
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5697218000E
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 14:46:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786286793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zb60uywR2AW4mq0V1yAZ78j7QI66v3ssUpPIw+k70ZY=;
	b=HQLLqRbK0V9cNCZs4pReFmxYUt7a53v/ncnsz6XpeG90MRyLHgLakeOHAKCVLsQhPQ9hFc
	uIXStS4B6ljvJZtm3fAVxCoITEYxN65vhZSiBBxrmBinvIYQeDt6VTLtccbd32W36Ll0ey
	SUU2MTg6rK+eAvJ+Hk+0SxPtwR+WiVg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786286793;
	b=TTlW5RveCXhRxfbTrlO0rpZCZUenw7CkPwfEJjR/VHcUUXdR6JeZToxDh7kNAnf/yEbXDK
	NX5vkQLx74N3B1CY7QrLaszyOJ2EUWg83XmnrA2tUP0V1O8rsEEkHaCaQRl90GfoD80ks5
	Yrd21cwD+4A+0E6f2NqfEVUxZV1KNTs=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 9 Aug 2026 23:46:28 +0900
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
	Youngjun Park <youngjun.park@lge.com>,
	her0gyugyu@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/4] mm, swap: don't free a hibernation slot that is in the swap cache
Date: Sun,  9 Aug 2026 23:45:56 +0900
Message-Id: <20260809144559.2104856-2-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260809144559.2104856-1-youngjun.park@lge.com>
References: <20260809144559.2104856-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5697218000E
X-Stat-Signature: bru8s4qtq6i7qcfh93et46nixx9rei6b
X-HE-Tag: 1786286791-272002
X-HE-Meta: U2FsdGVkX1+r2vBa+5L5E809KYSvMohKotmY2FyXqLBydbQYgDZ5WXcsLUFSYnEC4yHHXV7lXPbMW7ch+asZTFcGoh5tXvuRg7UBV8IDATSTjEVmZo904R8s0aAvxdlEVNuimZLi+1JwiQfE2HPqdz9QAtmjc7qf9b91Lt0xUk51o/e1fbJNDChkwXjla7Th98FLpioIxxNdm9kdmsOuWhUu+co7hJbxEYhVp+XjJ7fNmKd1k8FDpupn4CKFBFEiH/cqpPtJi8PPGBmG9e63mvLqHDtfABTe0cxnR/mNij8OOQL+AStla0QXvNFNhtqXOsJwZB6rQS4oPPQBG/HLT9ptCrf9XDpOmHqw5oSUIm0SuNwL9IPdzMZQnWpo34y+rWDKgJipqIKMXDCeIOHyMf7evs9OIyNX9F+Pm26/OeonXwtXOM1hUBlnB+Hdxa3QHOCB6kaHMMKULsGrHU1mZFgrIk4Z4RtsIyGGfW4yonCOvuUCZ73dxUN5/iBDBcF5xwuVH5x0jM0u1v2F0aX4964YnYy3a6nGbfgseT0JhCuMjqTqEseVg24zDvBP9qc03S4diMDCJVT6kDqwViSWBLNknI6Av5rEyvQvNTD56nuLwQm445lkpmijbtvxFf1UejkvFxkBPUQhLqOdV6egkM5QlJrAoZHvxRV1kL6xhkmG9FiMz9j271S69QrsbCqIBQz/blFbqep+sAQNK6SnDFgnMudab7wSeuBQ0dRrrbBX0eCY6iyMUtFsIlfBUkgLuwXFroz3MUl/E8rWqRKF8kkhZJ2mU0upaMTo0eW4kL6xp8LuwzvhKseO/XnoFxoWwIAind+aoe2A4DZyxmWOgEzJhiFsDsbBcZtxMfPLsWarLOHnod2f8IdpvlfYzd1yrcufbDxYrqGgTXcgymN4686jeIq5PI2g5d1dPxnm+M+tSRYvEUYd32Uq48O8XXYvqQ55I36PLEE/bopzapu
 aL7+wg/5
 OszfeRRtgPWzAdALea9F61SzBCMvq6HIHE4knj5Eu5W9P4WgD/+xgNrKAdH5hqyqr4EUYFLfHZ8KLyZaQsdyrTAVWGmUlDySf+3pkpR99jmj4y6TiewfrZgUiz8a4KlcESCBB7E/9cD5DhV4s7iYVwalqUZMWlqNkcgh6Mbn1TSrv2FMbDUAoEPW/n8ZKw/PkIU7QoaM8H1zuML4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A slot with a folio in the swap cache is freed when the folio leaves the
cache, not when its count drops.  swap_put_entries_cluster() follows that
rule.  swap_free_hibernation_slot() does not, it calls
__swap_cluster_free_entries() whether or not a folio sits on the slot.

Cluster readahead can put one there.  It walks a raw page_cluster sized
window of offsets around the faulting entry, and a hibernation slot passes
__swap_cache_add_check() because it is not a folio and its count is not
zero.  Freeing the slot then clears the entry under that folio.

The folio is now unreachable from the swap table, and the offset goes back
to the allocator.  The folio is still on the LRU though, so reclaim can
pick it up later.  It then takes the old offset out of folio->swap and
overwrites the table entry there, which by then may belong to someone else.

Check for a cached folio before freeing.  The slot is then left in the
ordinary state where only the swap cache holds it, and it is freed when the
folio leaves the cache, either through the reclaim below or through normal
reclaim later.

Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Cc: <stable@vger.kernel.org>
Acked-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index dea2d3b36e06..f5dfc7e59191 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2202,7 +2202,14 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 	ci = swap_cluster_lock(si, offset);
 	__swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
-	__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
+	/*
+	 * A slot with a folio in the swap cache is freed when the folio
+	 * leaves the cache, the same rule swap_put_entries_cluster() follows.
+	 * Readahead can put a folio here, and freeing the slot now would
+	 * leave that folio with no entry behind it.
+	 */
+	if (!swp_tb_is_folio(__swap_table_get(ci, offset % SWAPFILE_CLUSTER)))
+		__swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1);
 	swap_cluster_unlock(ci);
 
 	/* In theory readahead might add it to the swap cache by accident */
-- 
2.48.1


