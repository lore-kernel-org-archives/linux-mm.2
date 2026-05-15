Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157BECD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E7866B008A; Fri, 15 May 2026 05:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798366B008C; Fri, 15 May 2026 05:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6872F6B0092; Fri, 15 May 2026 05:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50C7B6B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:44:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1541E4087D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:44:25 +0000 (UTC)
X-FDA: 84769168890.08.BEAD5C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 11F5D40003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:44:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXl9C2lc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838263;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+DuK9MjriBzM5pG6EFUl+McR0t3ufhver7II2yAtW8k=;
	b=49qogb6L3xsd0ohVC0RWwXYe36rGgmaFwx3x6iWA9DcBSt8RVwmFXGKIrSoVn5kv7B1yiy
	rY14cs0SgBOeigCPuO9jjt69qnhr3MOP7KJPS/5+2+GHd+VveyVUJ/NtraUMMrIxVL/Pzn
	NK5uHUVR+if7O22qrFT29x+kFvle/Vs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838263; a=rsa-sha256;
	cv=none;
	b=iqits7E7GobqSq7m7cqGIgYIIJjK3oeCljk0iTD/yDUJQTLy51nGsPfHyiOHNeB75axFOa
	FfgMsMDTHpXV2dHVt/yhNVFgRMXq+k4A1CKham7I71IZXMRxb2hpBBRzaujDXTC/3O6Ap4
	jImn2/hdsS3heFEgvrbjuy2m05XjNag=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXl9C2lc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDF984384E;
	Fri, 15 May 2026 09:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA886C2BCB0;
	Fri, 15 May 2026 09:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838261;
	bh=4vpRI0ksYx8Fe4qrFFVDDKAbHqdZsiUnzSSOgQAgz+Q=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=qXl9C2lcnue5JTwgglqLBGhdoDNeF+BMtXq9ukCz/TfesxIcHzWyjBJ59sYNDyoDl
	 FScB7RPZMjLaJf50XL/CQiva7Xgtqo18G1cUnxL85cmtQzLZM5nk5ui5wh0HVtQZcR
	 zKFny1t/oIKnjdBxfEWas7Z+/1hpY5E8IWFIvVcvcOlnv8uLNikR5zr/WwgVPrZz27
	 3PAxF158JQFaVZlm1iIzKw/fuclWsIPl5lqeQW2Zg5OCIHgd1Dz+HkCf2fsqagV8PR
	 nFhAAL7ZWcjIQXAO6vfNva+5ga4RkDsL9WN+Ibklg0GV5TEruOHcAQnSxtApOr6sOM
	 dO+rQbw2MjRug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B95AECD4F25;
	Fri, 15 May 2026 09:44:21 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:44:14 +0800
Subject: [PATCH v2] mm, swap: avoid leaving unused extend table after alloc
 race
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-extend-table-fix-v2-1-833d72ad53e5@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3WNQQ6CMBBFr0Jm7RimiBBX3sOwKO0gNdqStiKGc
 HcLxqXLN3nz3wyBveEAp2wGz6MJxtkEYpeB6qW9MhqdGEQujnlJAsNLDshTZKsxyvbO2JkJWVe
 aukNZa6kg/Q6e03nbvTRfDs/2xiquY6vRmxCdf2/hkVbv1yj+NEZCQlmRZlmX1LXFOQmKbdwr9
 4BmWZYPC+rFss4AAAA=
X-Change-ID: 20260512-swap-extend-table-fix-ed7d1f458dac
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Breno Leitao <leitao@debian.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838260; l=4942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=mUn/F24LeFaL4ar295oTulNdGtYoq7Q5z5xlo3vUeq4=;
 b=CdQ3G7hU4bfxcF3FIPcmvuP87EoXrhYvS5xnJ7aSYPDNKeyw4SWXXKReRkKm6lI4/XXg/6aKX
 KdWSWu4CFY5AdqaB6JZkx6Uz4a63h2RJ2JjdtfV1/aPuUtGlPYB3gQO
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11F5D40003
X-Stat-Signature: gzxu7zuzhuobjy5tdozwejm8z9xdqkt5
X-Rspam-User: 
X-HE-Tag: 1778838262-532440
X-HE-Meta: U2FsdGVkX1+b8BTZ+muibbVDli9lytW+/cD0WNjSxYXQfli3SboFGBs/jX5R/82wvLcXTx31youtqICDjPcT1aOg9bQanwyu8/zxNKgkfTf/20CkqiVpEdElNVwzlkT7ECCyfPo3KfCrQRQCpuGSBSeV5L6w/K8W7syj0XL6I+ZF+rpB3B9kyGlDCyfba4rUfbbHu+CSXrMCegnlOF/e3jWosqnB6mhsaQB+5v5wlrn6+04neWetqJWqowXpeG8EZ+mZoTSsx+7kSy+3LIcsGPTYzhsxFEiBaBm7s8LqB0xgvKy1/jAv3J6DaNm7CKGDhJxC0sgWbdO8cpyBnkLsmoZWfgMU4Y5lvOm6OMqReboOz/OSiXt+hToiXrKLN3otbWUeOm21JKUjq07+JOGXPJH+htZ7xXx2o/Kvs0Qi8xf3/oDK93/GohLNVBKPt5pLnPHhNHNTg7jd6jABVgzuavWvBhpQ8uEFeBM5mnqR24/7mgqLYe+tVf/FDYcCit74/xbFulHAs41ZClzmOpin/6k24mDNP0g5rDM5Uv8/mEgKdeJbSxDbiyga16gkEOwdA/hZ4rkiPy0rDDpgnTFYrmXxUnpt1zXLR2znCM/sK/vJm66Q4ypNBCxHT95DIYfq+sj1O5UzfbVOfP58y31r7z8oho5XPr4E6K1U2CP/CvoKUwPNdIV4upuwleun8oMJIinVFTy+wfSuorXMPo6o3qLDdMpXR9rG0Uq121qrZaElQeboe/l0Qj8UbRSxCugaPvns52HzbQOIrp8j9o26A2JoAMjTYJXzZaqBkjteOU4vPnQxOT/OMzLjkZ/NmtRd6JXFeIgO5MzBcB3rfQJDjGtXw3+lXT0YxbPBrZe+waPk28PXz92uv5Wn0NZxiTbcGf4gMbZiUGcqYiI1XzABmAXXQ1svAHffBbZYRNd8dgT6q1dfWoNbG4AevoSaN/sfqUqcjQgLUhm1NJdIUAI
 7HvzZECo
 pINbSxkK51mCy9yHautZd0XIXZuc5pvnM0Dg3OshqkH8ZgvdvTG45KPuWxMQ7mWG7iKIe1gJDMFRv+Gcz61Mc0Cj3xsiVeFsgM6giwq9HuJsHCIuK9H+jnnuQyr32/Eyv2XKsCalgezoHjVshHCJ2izN5DeygXNe8o0jn3+pKwrDJVsjfAPZ9liPT2MvnB/2zc3dEopUqebownvUuyUjph+1RTVeA8pLNeEieoY1Oobjzsr5zKIQVfTPIgOBaabww9XSgKFrWzO1q4nwbT4aNYkgBWH4EXpvRZcy6VrdhHLmIltZiNgtXfiwuPmYFJX2f6jZiwbSzwu93AGLAMFSujVUepYAVTIK9PURwPRT/QZyTvGoWQuzR7E0nkr8MqH+B1pTF8kssYy2byAKpsPHBYQIjCS5zPo5SheyJRp1wy5Hz1tBKWQWQEYDbKE7ZLG9Z43X+NHtrUxMf/tzkN9R71XauHv7bvHWULv6NR47G/5X/OmVZb9Sjhrnt9K+/OjDUv4O3jn2gdaNx5LIh32COvYqeMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Allocating an extend table requires dropping the ci lock first.
While the lock is dropped, a concurrent put can decrease the slot's
swap count to a value that is no longer maxed out, so the extend
table is no longer required. The current allocation path still
attach the new extend table to the cluster anyway, leaving it unused.

The next maxed out count on the same cluster may still reuse the
table, and frees it properly. But swapoff could leak it indeed.

To eliminate the waste, re-check under the ci lock that the extend
table is still needed before publishing it, and free the local allocation
otherwise.

Also close the check window by ensuring every count decrement that brings
a slot below SWP_TB_COUNT_MAX - 1 runs swap_extend_table_try_free(),
not just the MAX to MAX - 1 transition. With this, a freshly published
extend table that becomes redundant due to a racing put is freed on
the very next decrement, restoring the invariant that an empty cluster
never has a non-NULL ci->extend_table.

The added overhead is ignorable.

Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
Reported-by: Breno Leitao <leitao@debian.org>
Closes: https://lore.kernel.org/linux-mm/agG6Dp0umhs6O1SY@gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Fix another race found by sashiko:
  https://lore.kernel.org/linux-mm/CAMgjq7CQM+vzjQ-dgnAjvE8+czs1FmrK7Cv+EJ6jCGysa8OSqQ@mail.gmail.com/
- The change is minor, stress tests are looking good, so I kept the old tags.
- Update commit message, swapoff could indeed leak the extend table.
- Link to v1: https://patch.msgid.link/20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com
---
 mm/swapfile.c | 42 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 08309c1dafa3..46caad0013b9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1443,8 +1443,10 @@ static bool swap_sync_discard(void)
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,
-				   struct swap_cluster_info *ci, gfp_t gfp)
+				   struct swap_cluster_info *ci,
+				   unsigned int ci_off, gfp_t gfp)
 {
+	int count;
 	void *table;
 
 	table = kzalloc(sizeof(ci->extend_table[0]) * SWAPFILE_CLUSTER, gfp);
@@ -1452,12 +1454,28 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
 		return -ENOMEM;
 
 	spin_lock(&ci->lock);
-	if (!ci->extend_table)
-		ci->extend_table = table;
-	else
-		kfree(table);
+	/*
+	 * Extend table allocation requires releasing ci lock first so it's
+	 * possible that the slot has been freed, no longer overflowed, or
+	 * a concurrent extend table allocation has already succeeded, so
+	 * the allocation is no longer needed.
+	 */
+	if (!cluster_table_is_alloced(ci))
+		goto out_free;
+	count = swp_tb_get_count(__swap_table_get(ci, ci_off));
+	if (count < (SWP_TB_COUNT_MAX - 1))
+		goto out_free;
+	if (ci->extend_table)
+		goto out_free;
+
+	ci->extend_table = table;
 	spin_unlock(&ci->lock);
 	return 0;
+
+out_free:
+	spin_unlock(&ci->lock);
+	kfree(table);
+	return 0;
 }
 
 int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
@@ -1472,7 +1490,7 @@ int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 		return 0;
 
 	ci = __swap_offset_to_cluster(si, offset);
-	ret = swap_extend_table_alloc(si, ci, gfp);
+	ret = swap_extend_table_alloc(si, ci, swp_cluster_offset(entry), gfp);
 
 	put_swap_device(si);
 	return ret;
@@ -1519,13 +1537,21 @@ static void __swap_cluster_put_entry(struct swap_cluster_info *ci,
 		if (count == (SWP_TB_COUNT_MAX - 1)) {
 			ci->extend_table[ci_off] = 0;
 			__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, count));
-			swap_extend_table_try_free(ci);
 		} else {
 			ci->extend_table[ci_off] = count;
 		}
 	} else {
 		__swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb, --count));
 	}
+
+	/*
+	 * `SWP_TB_COUNT_MAX - 1` triggers extend table allocation. If the
+	 * count was above that, then the extend table is no longer needed,
+	 * so free it. And if we just put the count value from MAX - 1, it's
+	 * also possible that a pending dup just attached an extend table.
+	 */
+	if (unlikely(count == SWP_TB_COUNT_MAX - 2 || count == SWP_TB_COUNT_MAX - 1))
+		swap_extend_table_try_free(ci);
 }
 
 /**
@@ -1665,7 +1691,7 @@ static int swap_dup_entries_cluster(struct swap_info_struct *si,
 		if (unlikely(err)) {
 			if (err == -ENOMEM) {
 				spin_unlock(&ci->lock);
-				err = swap_extend_table_alloc(si, ci, GFP_ATOMIC);
+				err = swap_extend_table_alloc(si, ci, ci_off, GFP_ATOMIC);
 				spin_lock(&ci->lock);
 				if (!err)
 					goto restart;

---
base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
change-id: 20260512-swap-extend-table-fix-ed7d1f458dac

Best regards,
--  
Kairui Song <kasong@tencent.com>



