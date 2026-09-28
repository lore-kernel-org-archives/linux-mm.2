Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8231ACA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8176B009D; Mon, 28 Sep 2026 08:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0CA6B009E; Mon, 28 Sep 2026 08:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B6596B009F; Mon, 28 Sep 2026 08:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C01F6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:17:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E975B401C4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:09 +0000 (UTC)
X-FDA: 85263070578.25.961F582
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1190C4000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:17:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77mvL24hic8w6gcQxBBttNffJewF0cZsD/VEHNvzWOI=;
	b=vUa6pqYjMZVjuiYcQP/KUKUr9KQUX2v9fURA4l/d4X0RcxoNtqxeJUpZ1V53pg1UwT+h6i
	pgmhUerFcwB6HlIH2MSn2r3FBcFaX0Z3ZDOUlskPHKfuoLMkTRx8hBBpPC4CpgvpR7xJJD
	AxL1Ewk38VNf+nTBTh0HPWNs70fZsEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597826;
	b=4VftCTgiqDJmLvTNK0JqNi9Vr9ts82skDnzn9fKWCjAxLLoCpQ/LDbIHP0NV5pZjZ9alII
	HnKmFrVsJO2e6M1/F3Izl4BmnASu1bOXE2uU57KOT9xzhVir44Ac0GKAYTvPaf/IrtkLYF
	bQGUUmEsMKvB7l6xXZ5vcKpSWVRnwUw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4htgJz1MSwzYQtvC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:16:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A43824085E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:17:00 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVim1WrpqTZH9Bw--.4739S8;
	Mon, 28 Sep 2026 20:17:00 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	bfoster@redhat.com,
	joannelkoong@gmail.com,
	djwong@kernel.org,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	yizhang089@gmail.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	wangkefeng.wang@huawei.com,
	yukuai@fnnas.com
Subject: [PATCH v5 4/4] mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Mon, 28 Sep 2026 20:08:33 +0800
Message-ID: <20260928120833.3440834-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
References: <20260928120833.3440834-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVim1WrpqTZH9Bw--.4739S8
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW3CF4xuryfAry3XF15CFg_yoW5JFW5pa
	y3G3sxJ3ykWw4Ikw18uF4kZw4Yya9agFWUZFWxG3s7C3Z0qw4UKr1Ut3WUtw4rtr1kZ348
	tF1jyFW3W3W5JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmq14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIY
	CTnIWIevJa73UjIFyTuYvjTRNdb1DUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1190C4000B
X-Stat-Signature: qne7bbgamb9gphb9kgsyhb1ctdyyq7yw
X-HE-Tag: 1790597825-553939
X-HE-Meta: U2FsdGVkX1+c6S17+7obt92OMsNHNm3KlwG5hdNYbdA5SbcGoHnZZMjJ7KWjOUE0h6WZJHLKHYLjM4q1R1z0sDNrQy7e0QOcL/bYFJzGX0Mx3YEObhOzvL+cmR2R+7GoCASWbD6bUCSM+RoB7GMQPJ8FQH/2K2oFOLPm77W+2ADl15LxDQeaE8W8+HJkCWnb5if7Vkmtsc1Tww+tmrI133esKnyFYrx+YPM8P/B0TGjIWcBQ26ZzNbMB4kw4c9WE7Ly/XvNvn966W/qUd1NicXnkSiX6BOqkoHdqL3bKvUokwQt7Osd98XE1UbJlAe5oV7CYm2F/CjsiL+CnmE+FNKNYXeoZhOzNJ2WH4/CknHbZXTNg1HNk9V89PhJJR8pL4AZWLYUei5TpEurTaXVbblDLciAqpi2fzmu97hIbbQsvg3tCnd4fZeH0BMlwbKhfVvgtPszCG3ObNVUDXvmWj+j8Wu1IOCoeBHuJBfgeiUc9r5Q9QDzFwvhHtzrAnVKY+IeVUupm2ftm0njsniCa+RS4l3q/AB1oI47dxSxOR3AYfuoLCl5PQm3aj/fY+GeaAB78pDoYaQ4bvSKRzCRjOgVvODc764WES/cbJYkMlVN5/Hd5XKyOkQXklGYi5b8+lg6/HEC+bsGOv4ISR6ipwQXwTXUvChKEVFjha2WqkMRIIPacek7eNtjctTVZmrK9cwUUzzIw6kNzxjuSB3Y4KdPI6lcJyp0Y8sLoTc4CxNfUBDd9ElSxJUcAkT9QUrEuO+MC4qJajuYczlzsEoZwz45Rw8op+0TcEgm9D+UuePDX99TfvBTx4VK4MuaRwVNmZCr74FrJMzuuVFo0tpASomP19PEr6mhuvwwkOFa86RYZxiJ5vHuUSRMCJjbLlNISZViYeeCDHVgtCTQN9THohRiBFQ6kPR4TxRQwD2at2I+WdzB4rLKjJOMS8dSjH9DEszf6AtHvZS+1N7f3K8X
 +cNguC79
 aBEj7kqABq8/R/thJVHs9ZOR5ylEFhsufcTQKsBqFlBzQT7pRRgqa79hOPvIB+cxanqHyaYxUuyl43vcG8Owuej6pY7zurp4EN/QpY1CK4oJFb+BTVpLtsvZFz8FQvVzIo6s2lNlyVPpbkF1pmxjY5C/bvf5AsE9OkicX+gIAAhfUR1YcnxzmhrnCNmLtcx9Qsb3x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Yi <yi.zhang@huawei.com>

With the earlier rework the callers no longer rely on the return value
of truncate_inode_partial_folio() to decide whether to adjust the
truncation range. The pstart/pend out-parameters carry that information
instead. The callers now only use the return value as a flag indicating
whether the loop should be reset to pick up newly split sub-folios on
the shmem path.

Return true if at least one split succeeded, and false otherwise.
This clarifies the existing confusing return value semantics.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 9eb108769149..5b1b13cf8ff0 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -216,8 +216,7 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
  * aligned inwards to min_order, i.e. the range of folios wholly within
  * [lstart, lend] and so safe to discard.
  *
- * Returns false if splitting failed so the caller can avoid
- * discarding the entire folio which is stubbornly unsplit.
+ * Return %true if at least one split succeeded, %false otherwise.
  */
 bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 				  loff_t lend, pgoff_t *pstart, pgoff_t *pend)
@@ -247,7 +246,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	folio_wait_writeback(folio);
 	if (length == size) {
 		truncate_inode_folio(folio->mapping, folio);
-		return true;
+		return false;
 	}
 
 	/*
@@ -264,7 +263,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
 	if (folio_order(folio) == min_order)
-		return true;
+		return false;
 
 	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
 	if (!folio_split_or_unmap(folio, split_at, min_order)) {
@@ -327,10 +326,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 			*pend = end;
 		return true;
 	}
-	if (folio_test_dirty(folio))
-		return false;
-	truncate_inode_folio(folio->mapping, folio);
-	return true;
+	if (!folio_test_dirty(folio))
+		truncate_inode_folio(folio->mapping, folio);
+	return false;
 }
 
 /*
-- 
2.52.0


