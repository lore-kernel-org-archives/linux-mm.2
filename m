Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB270CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FF98E0012; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFF18E0011; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDFEC8E0011; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA1E98E0012
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84B8D1A039A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
X-FDA: 83927089386.05.0392C6A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2180C4000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dp3nSR/c3vIZ8dpdZ2Ukm17/X9JRYjO0VJQDiVeT0f8=;
	b=5+ZiufZNwt0xWm0Vlgd18B57R8qKzNbFapWr++mwrV8KSj0INJDBwg6UPLLwVmcq9DWVHd
	ZDNktsZBtGayQpsZwwoo5kiXopRfp2HY+VyWfPVXHpYOWjf87Wi8k+Vftd5FExfLYl2z/v
	3CQw1mQHlvKEpezRCe2ovwGDI+YLuzs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788751; a=rsa-sha256;
	cv=none;
	b=tpI/x9gMCEcjRKN5i1AeJQNdqpco+ne7Bd0jwaUpMGuYp30OyQMp86UO5V8XEqCPumZjnD
	v9rx1uBeIXsZ3slgQ2CKav9IR2g2uhm8GDD1qK6tcNM8zHKT+wCSpZUgcpLcwZTngfSdfC
	IZjXB5en82pRTd/pyH2Z6H8WOfLBlrg=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcM5f1CzYQvYx
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B90521A0194
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S8;
	Thu, 25 Sep 2025 16:25:48 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: tj@kernel.org,
	ming.lei@redhat.com,
	nilay@linux.ibm.com,
	hch@lst.de,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	akpm@linux-foundation.org,
	vgoyal@redhat.com
Cc: cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH 04/10] blk-cgroup: don't nest queue_lock under blkcg->lock in blkcg_destroy_blkgs()
Date: Thu, 25 Sep 2025 16:15:19 +0800
Message-Id: <20250925081525.700639-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S8
X-Coremail-Antispam: 1UD129KBjvJXoWxGw48ZryUJFyUtr4fKF4Uurg_yoW5GFW8pF
	sxWw4ayrW8KryI9wsIgF9rX3yS9a18Kr15J3yxWw4fGr4jqrnxWF1UC3ykZFWfJFWxJrs0
	vrWUtr95Cr4UAwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjTRNdb1DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 2180C4000A
X-Rspamd-Server: rspam05
X-Stat-Signature: stjxrygbhupk958ykhs6s9ss85egs7qz
X-Rspam-User: 
X-HE-Tag: 1758788750-983567
X-HE-Meta: U2FsdGVkX1+WyfRQgfK5XJhcs62GHYxSFmgf8XUiuB4JRpYkATVff/gcLEV7VJcL0ZPIYLC3K3GDGLrpU2FBgWhW2ZnNTmIvmtW1ILnWe7ra5Or18yzjUUeipD1/dAK62YsUdD8wFls55ODy49GC1+DReoccUQGjx6fPy7fsVRWII2baLcz56k39uyiGaTzWHzylu2ADGs0koINHLUuvm7VoaXxUrjTqhhYm+SM7WuMYbI/Dth6keQSnXuWBswuLxI/5mONwU8nvc1Lkpl/deHJz7dB3P72GLN4Yt1PVK5Thhr9rux+qHgIaspTlynCuyejdre3dtF++76b/1nq+uIixwylbVgSvNkDVhEgrSX9BtDgkkxXNCb9kFHLnEazajbTZAAcxbZXUf+8LeLgt0vSKK52ljHUIUOg32LNlHcOxoCtMi8gdN52Lah0QNfYazg9OyybN0VtyACVrFdOxStE7t7cGqzo3KA2MGhwN7qdPHxBNfCsqvwaQddhxyhGa0TPm2/RZ+M/Ss6cdbGy6O70ieKW1t0cR+NwU1/j6O792j1WAMdmzBTauprOkgqF5SDVMVAxtImB3V8iHvwVHbj7pgvRCXrufzKzhf++HOs7YBx4kYJgPaykn/BuO4gCrPakMgcfDKDv9p+QCB7pHhrWJBjotUfy6wcb9yb/zg0Osll/5We0yeL3ZW8BbGTiq2th0AILNAEuzh0PJxa43PsuLU1YRH8WOCl5pjdEq4ko13D2JNRdJPXH+8k8XqM4MfW/tBvHJ3ZcgTr3E5M5yQYOpxTMAICMpQwCrKrwV/EifAmNwoCadhtsBQdChKIKVj/Z1g1dBBBaByuKcNAkFl+J6EjGubyGIosUNsgNTtq5FHvr43NIfPd1Ol0mFPH2XldSutF/B06IX/Sz3+qhdwqarK3TdbRJDdKFVX+VP1ZmIwcDlATs7VZEHEyNEEpSTO8vAsE9f9xMK5HSjIlD
 SWlJD+Y1
 +ovDgQ7ovLXFbY4c9fl9mU4sI/c3j1DBpkwl7Pis6Z5lo6YAeQg25hogNh8BRb28AKcZryNaVvSFQsvxpLkeh9Y7AryzcpKyb8IiwatGkezaNKjtxGc6U6sV6FxEsfu0Svd9umsW5e4urvA0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

The correct lock order is q->queue_lock before blkcg->lock, and in order
to prevent deadlock from blkcg_destroy_blkgs(), trylock is used for
q->queue_lock while blkcg->lock is already held, this is hacky.

Hence refactor blkcg_destroy_blkgs(), by holding blkcg->lock to get the
first blkg and release it, then hold q->queue_lock and blkcg->lock in
the correct order to destroy blkg. This is super cold path, it's fine to
grab and release locks.

Also prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 53a64bfe4a24..795efb5ccb5e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1283,6 +1283,21 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  *    This finally frees the blkcg.
  */
 
+static struct blkcg_gq *blkcg_get_first_blkg(struct blkcg *blkcg)
+{
+	struct blkcg_gq *blkg = NULL;
+
+	spin_lock_irq(&blkcg->lock);
+	if (!hlist_empty(&blkcg->blkg_list)) {
+		blkg = hlist_entry(blkcg->blkg_list.first, struct blkcg_gq,
+				   blkcg_node);
+		blkg_get(blkg);
+	}
+	spin_unlock_irq(&blkcg->lock);
+
+	return blkg;
+}
+
 /**
  * blkcg_destroy_blkgs - responsible for shooting down blkgs
  * @blkcg: blkcg of interest
@@ -1296,32 +1311,24 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  */
 static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
-	might_sleep();
+	struct blkcg_gq *blkg;
 
-	spin_lock_irq(&blkcg->lock);
+	might_sleep();
 
-	while (!hlist_empty(&blkcg->blkg_list)) {
-		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
-						struct blkcg_gq, blkcg_node);
+	while ((blkg = blkcg_get_first_blkg(blkcg))) {
 		struct request_queue *q = blkg->q;
 
-		if (need_resched() || !spin_trylock(&q->queue_lock)) {
-			/*
-			 * Given that the system can accumulate a huge number
-			 * of blkgs in pathological cases, check to see if we
-			 * need to rescheduling to avoid softlockup.
-			 */
-			spin_unlock_irq(&blkcg->lock);
-			cond_resched();
-			spin_lock_irq(&blkcg->lock);
-			continue;
-		}
+		spin_lock_irq(&q->queue_lock);
+		spin_lock(&blkcg->lock);
 
 		blkg_destroy(blkg);
-		spin_unlock(&q->queue_lock);
-	}
 
-	spin_unlock_irq(&blkcg->lock);
+		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&q->queue_lock);
+
+		blkg_put(blkg);
+		cond_resched();
+	}
 }
 
 /**
-- 
2.39.2


