Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37794C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26FEA6B00B9; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9BD6B00BA; Wed, 16 Sep 2026 05:32:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023C36B00BC; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C78E96B00BD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:32:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E9151604BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:54 +0000 (UTC)
X-FDA: 85219111068.09.A39AD1F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9704740007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:32:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551172;
	b=4jnHijT1+Wfuvcv78jjv3Pm2LwWEPOQjYOmhHmhRtgpkDMgHHML3wAvpIMy39+iDlucq5Y
	NZNIwVbZk0CrSeSTMm+TXzph0foniM7qiTYu/H8nHt6Kxy8+R05oa2l0G7jdhfM3twYnRm
	1Bq+YhfvxLC0kGMLABiCjYAWQw5aaew=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dGlGDtCHy95VdVX+bUtDIDKvD3QcVdYFL2Zh4eANnLg=;
	b=CXKp0EuvXrVnT0e0ZiM11gwA2CNKc3ttGlAgq7rOdOmZcTVB/Lxh/k48sGeXvBKKrc40U6
	wSY8kaxRubBU81wV+IcYCAr2ecrqzW5Z7npMKwLOmA2kPkFrbFTvgNwnlmF/+OyNCvkk/u
	i0Zl/hKaMyLo20Vq0ChcSsPn990Z4uk=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hlDFD52LbzKHMZG
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D8D8F4058C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 17:32:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgCHVikvYqpq8i0GAg--.65015S7;
	Wed, 16 Sep 2026 17:32:46 +0800 (CST)
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
Subject: [PATCH v3 3/3] mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Wed, 16 Sep 2026 17:24:50 +0800
Message-ID: <20260916092450.654408-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
References: <20260916092450.654408-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHVikvYqpq8i0GAg--.65015S7
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW3CF4xuryfAry3XF15CFg_yoW8Kr43pa
	y7G3sxJ395Wa1Ikw1xuF48Zw4YyFZagrWUAFWxG3s7CFn8Zw4UKr1Ut3WUtw4fJr1kZ340
	qF1jyFW3W3WUJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1V
	AY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAI
	cVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnI
	WIevJa73UjIFyTuYvjTRM6wCDUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9704740007
X-Stat-Signature: z7a4gb5u8ethm3o1gqyjhkgikt7q99uw
X-HE-Tag: 1789551170-531042
X-HE-Meta: U2FsdGVkX1+OsqRhW7RDdSKY8YBNYtWiWtagJwj1i9EGm1sNbC7HFshVxnVU5wscgdtykXwQYOOWF5PsknGkpdUFO3iCQyjp4Xo4C7dYV+BCP6sHTqJ/qoHfzxkpOE7n6rqSpv0YICX6/b2cyqAcl+vw8KkrX6a7HKbqo4DQUHr8QC9g4AH+b7BzcxFA4gtDhSb2pDKyakoYG7854ByCAs1MVdKgyCFIi3nkNT6xTBn1Ng+HZEoPRgzOaLU1+HDw2erPpsdtJ0cyP3Jb2V24Ff8fvIyia1EOmE0bPq+1r/YPrjKcdz86XEcXmsHf6F2Q6zDkTBDZJ6xufvakeGBvg6/VGCa+0XegblD9N/IEOZIQ2MjMcWDkFuYSBgDhGQQJBiHPrysEN5TQZU5Q2KVxVHm1/UJ3+G9WZGpShjfFDcfcQcxrYtYTnP+AWxqENhZfOIe4UaCIdG7NCs4q5MWwTBjnbCD+dSe9M8AXcLu+vp5ffnzUYpFrGKrKJFTknjI47O5PiBJwzNNN01JsgOPNiQK8KqQcdM/CAjdXmDls4PxaCtFR490zODDeHUkw+/402dUTFtR0UAnb5pW1WlWH5B5l6cvQpOfu4BjyJBU2HcH3Kc8BDIn4k1YHsgEdIa+lO23RoI9X2Z5f0F5X1gsclfF+zaiE21CEmr3bPUsaqBDmj7NvLOiFa6uLBdriY47li7ZITuozsmgNnyKkiZpmH5xxGNgEEJmPhxwjaSLSBznyEVop44EPcRQGL7lPI84iRpC0/shamUmNOObkK9VxdD4jdE9l4YHG8zY8FOb/QVwhygOdveStGGM1+ZINupnupJkPJYnhj4gia8vlLxB9QVSPXclhIsnwiJQRcwPjZivrVbC9j9HSmeGLxrSzO0SNFGy1TSwqqvuuiaQ/l/RGB88DPAc72+L48Nf+vhCmW7pQu1UFpOyTgcmqJR/BEXUi3nw1YrcHNGJq9/sHTP0
 Dpsnyr0Q
 mj/yqUOeWgalzn22YfGii6ru5YRhOx6VzlDW7e6uST6tjZr/QubxHj/ylDaiH9Jn9ZfQWH5SNvMP0IYTxsN0CJQeAWJwXi/rP1nwQvWkrSsRiJbqj2W1mQRIhCHRWNuZMcLysF5GWZcE7he4=
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

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 mm/truncate.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 5ab7a40b1e25..23c90f00b530 100644
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
@@ -261,7 +260,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
 	if (folio_needs_release(folio))
 		folio_invalidate(folio, offset, length);
 	if (!folio_test_large(folio))
-		return true;
+		return false;
 
 	min_order = mapping_min_folio_order(folio->mapping);
 	min_nrbytes = mapping_min_folio_nrbytes(folio->mapping);
@@ -331,10 +330,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
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


