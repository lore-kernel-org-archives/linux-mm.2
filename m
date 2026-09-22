Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9BC2C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 11:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCAB6B009D; Tue, 22 Sep 2026 07:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D2C6B009E; Tue, 22 Sep 2026 07:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E018B6B00A0; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEEA76B009F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:15:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D8EDA61AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:15:25 +0000 (UTC)
X-FDA: 85241142210.27.DB7F4EF
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id 74CCC1C0009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:15:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790075723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xSkAkxiQZI5ylHLAfnV+Q5N5yzlqXWCnFbgfZtDuUSA=;
	b=cdk32A6nVqBzPgtgDu1C/BOryawiRfQk0jIcII5a66fcVPpw9U/v8OFtPfmItpZBqK4GTG
	zsrCBSOxsvwnKqJXQuYd6NQVFRmYHAvLpPB6XEYOWQEGERePvuCq7fLup6swj0rvvrzqwj
	etEUTYf9QFH+td3nNj7/NVfot998Zq0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790075723;
	b=Oq/1B18riRgRw1kWmHt/bWWVoZZbOi83RR90LTcTLDYm3dJw/hfHL4+UXiLxgFHjNZFz8z
	7x7tfodaMjGkCxvX8SQ+EBhxcvMguZvawQmsO3Ley6BHcQ92DK4nRQTyMQA1CjG5upRcbZ
	OA/NlnQpAe7Q1d93VtlEyVNPFS3i5aA=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hpyDk04lLzYQvh2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:15:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 205BD40ACE
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:15:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.85.155])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xik4Y7JqtosFBQ--.39851S8;
	Tue, 22 Sep 2026 19:15:16 +0800 (CST)
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
Subject: [PATCH v4 4/4] mm/truncate: clarify return value of truncate_inode_partial_folio()
Date: Tue, 22 Sep 2026 19:07:03 +0800
Message-ID: <20260922110703.468389-5-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3xik4Y7JqtosFBQ--.39851S8
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFW3CF4xuryfAry3XF15CFg_yoW8Kr43pa
	y3K3sxJ395Wa1Ikw1xuF4kZw4YyF9agrWUAFWxG3s7C3Z8Xa1UKr1Ut3WUtw4fJr1kZ340
	qF1jyFW3W3WUJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 74CCC1C0009
X-Rspam-User: 
X-Stat-Signature: zjzcq77z7ewmey3znen77n7magkaxqhr
X-HE-Tag: 1790075721-853642
X-HE-Meta: U2FsdGVkX1/FllvzpbZ9iLPXIX2AL78maAzS7zPHU65OMSucsI0PWnL+a2rfyrWy+XfSRotDdfFIUsU8RpKw26z38gwASXdm+FqaLPwCqrQzJRnV5rMhFxBZDh1Cvk3NT3vqxzMg4Lt1IZMfrG8FoxQFRVqxjU2sZhFPjT2Ow5duHwxV0RZCMFUEzhH8TZHVS2H2zzzF3oOYxKXZ3SBdYa0jjNe5KLkhTLri9IhC3u8ZtyuC9LcCr8HG+4fMa9drD4lWW27v5i3jsBey2A5LgyPjn++MrFlsKOsA7sZJqDcKqScpzNk5s+/56GxKSRsOgeaacHjPwT9qIBDfB2WgMk8Js3bIX5KXQUlt7zrqxD9bblAR64PLiw/agy3xpeQNFi7djte9BFqT/7PPMrUf5UwHZq4gsjZ1JRxZezk72w5KcvshIXQ4RnBSLHkMB6yyetDSfzWY6lFlYwxC08WRbhLoJITHwOKgRTk+LtXndi9V8DWXux8xbF0Dz3BIYEX2RxtZ2wyuVs4yaPBD9wWTbby+7XEBy3amNvwsU8adfUNcSVYAiA90w5tEIN+u6i5LpsZ2VjcODS+Ty/rOtHOMfFHJ1sPWp7mHzstRfgVUt4rP6zk0vUk0NAY1hORJSYdTiPb0HW/0787PbXbt3rWxuqU+e3VIoyiZKNoirpbpMYZ8VuGbHa+TpJx9Iujpj7do5LGcJk/uAp24aKA1TU/9iORrNfQTZ5hGjufghmHegOdAAAz62Cq56OS3hHGWsaAWNQSqigRDyPRXtYKahvTrQ3ISqej2In0XelBWH+nezmwQckyPndNJX9lD7i8Nczt5pJqynS3qtWOTwtlejt8rRj2vt814TDGFmQxxd9IGaSMdf8jMagm4+X6r40s1SerfWBK5cnTViLkMPbnX/QOMMYsYKQ86uj8z49cjyyqcCPdReyU+BDPHKROWRC5X9Cjf//aH0Zav5kx93vO/IxR
 kFndQMzZ
 EuyoyWehmEErhvMo9T+ahhAMsTwIokiTJPl8ntgRK5w4USZDVWAHPbcz7USiCyKVSNV8rzJZ/0k3VXVg5yF6S8JZek22t/Zjj8xPJCB5OJGKb2KOWuBmPY9dwkAI+MRcLRefwRKP5RZbdnCc=
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
index 81fb4de6226b..317cb4ae3625 100644
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
@@ -326,10 +325,9 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
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


