Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4E4CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A928E001C; Thu, 25 Sep 2025 04:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4778E0019; Thu, 25 Sep 2025 04:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C3E8E001C; Thu, 25 Sep 2025 04:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9858E0019
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E27C9119BF7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:56 +0000 (UTC)
X-FDA: 83927089512.23.B1F186C
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8035940009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788755; a=rsa-sha256;
	cv=none;
	b=Mjo9nhEfRLYz+oHk3+Of7TBnogyIgbdRiR1YxOlVZ6s04kp8YrrkIa5wU6aLJOvdSg43Oo
	c51gjHAMWMfACB9LmYn6VxQZQdBHBgna3Nj094WR7OxIbeK+9s8owaJ2W8AnRlHwVXx02X
	eNhsgDwvg1sNIzpKRPtY8SLmFhJemP4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XPNdgK63GiCN3tFQRMQuOqSBS8p61bKQG+4ZdGhemgQ=;
	b=bYfazrTRigUhL2JhbnEuqCNvcg4mQ+7ZC5v2EAOG09kdyJltX86MKcLZHH5wd1tAyrYkA/
	iwnKyYd4Mq2WWyBq+wEI+bUDtQaDD1asLsZWp6sZKfWgQ8ylfuPsaBg48VPNdfwz3DqhW/
	pp4d8nztbVxievigQxHFVepOjIr1jXs=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcS0xX9zKHN8Y
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 007101A0CF4
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S13;
	Thu, 25 Sep 2025 16:25:51 +0800 (CST)
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
Subject: [PATCH 09/10] blk-cgroup: remove preallocate blkg for blkg_create()
Date: Thu, 25 Sep 2025 16:15:24 +0800
Message-Id: <20250925081525.700639-10-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S13
X-Coremail-Antispam: 1UD129KBjvJXoWxGr48KF4xCFW8Ww48Jr1kXwb_yoW7Jry7pF
	43trsIy3y8Krnruas8Xr17Z34Sqw10q34rGFZ7Ga4rKF42vr1SqF1j9rWkCFWxAFWDWr13
	Xr4UtF1jkr4xCwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8035940009
X-Stat-Signature: x358rffowijorr9qfpu43fpkrzcthdwn
X-Rspam-User: 
X-HE-Tag: 1758788754-842953
X-HE-Meta: U2FsdGVkX1/V9u88kZQBlaogdLuoFw+OZJQcgCfTqPPAT07GK3iORr5xLBDkEdURw024VhToAFkRcAxKlT95FbWVuC84hdm07uNv1jX0PilfC2rMpYKYaY1dHFA6U1aBaUZwQWKoBz6UEf4Hf70VNEkGiQMlHBNIOeaHnOlSnI5GKwVv+g/FjIIl7RvyGd79MaXwhsap8UG1HlsVTz1yAqBdJpqo4hX/VOo3hA+6Y2ObtHB11/ujnIVkbBqYfxV7BY6CjWCHol6vU8tvopWD9evkrUuVkPnvSaiNTpo25kmkOwEj9shHr9ymcOVuoIq9iUrxeSADR0yXv/KPyBiQxNbsgSXKqm0x4MAtasf618h3Vw6S8EgWevl8EUe8CUMIxjKcdBojItwbShej5sKJJX2N3/y4jW+BV6yCW++L7cafAcSGhbQFrNYHstLWkA9PwUhPTS45idJaJ+YJUvRn79HYQik47xPkJGjaP6f+ktsKvSsrqJta4WDNlzmgdWsnOYaBQyL38/De8NF9xofzElAHN/AGKWuuPn1A1PEqwtCqkXIdJYDqY+1WQrOvTdcDrPAuLkScW7q1sUy3653gBRAqCesGbxk2TfMeRURX6yJ9fkgHGs3SM9gdCvbejKp6sToM5YmeQpAEfrdAJu11dtk+0WRqqqKqI6m5Pu/KZYJoy6iXsyX53NxRdmeJk/TIdG+xwMCFKVeBoUroxaNwABf8livszux5bj83VpgGAud2/gu/c6YsmAVkgTgeBVXdhuHMnU4eIx29VwhtoAcFwF6MhaQymTW8eaDQZlHCmqhGpvfUAOFljYPiN1wCNZYk0P3KVLrWdj3HQg8L1cx8+UDhDfKlXPUaBpCc2zOSjeGGWA3ouc78PeWx3ANyYeiLHu/AxI1sJrcObfUhR9Yxiwn/s21fsWIGWBAbYptCVTIR/7B41BVSFsrzaQehzqS2baJ7perium0FvdxFgXR
 cAwSErPU
 xvlBYDryvDg7HeDIpn5XGNnA1sKFiOqLU16SUQPHRdhPWJoMfIxi2r4KblDJEYU6nZ2/yKmPQASeOSoQJASzedU5b/iBLZsnJfwObn+bmZeZdHSlQGCl8dKaj14nfGP+VCeDs5oPGqkqVsuUhYjn/rR0R8dLrhoFq1ah+kUgQyUbNEXPBBjOn5HmRPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

Now that blkg_create is protected with blkcg_mutex, there is no need to
preallocate blkg, remove related code.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 91 +++++++++++++++++-----------------------------
 1 file changed, 33 insertions(+), 58 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index bfc74cfebd3e..60b8c742f876 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -364,10 +364,9 @@ static struct blkcg_gq *blkg_alloc(struct blkcg *blkcg, struct gendisk *disk,
  * If @new_blkg is %NULL, this function tries to allocate a new one as
  * necessary using %GFP_NOWAIT.  @new_blkg is always consumed on return.
  */
-static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
-				    struct blkcg_gq *new_blkg)
+static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk)
 {
-	struct blkcg_gq *blkg;
+	struct blkcg_gq *blkg = NULL;
 	int i, ret;
 
 	lockdep_assert_held(&disk->queue->blkcg_mutex);
@@ -384,15 +383,11 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 		goto err_free_blkg;
 	}
 
-	/* allocate */
-	if (!new_blkg) {
-		new_blkg = blkg_alloc(blkcg, disk, GFP_NOWAIT);
-		if (unlikely(!new_blkg)) {
-			ret = -ENOMEM;
-			goto err_put_css;
-		}
+	blkg = blkg_alloc(blkcg, disk, GFP_NOIO);
+	if (unlikely(!blkg)) {
+		ret = -ENOMEM;
+		goto err_put_css;
 	}
-	blkg = new_blkg;
 
 	/* link parent */
 	if (blkcg_parent(blkcg)) {
@@ -415,35 +410,34 @@ static struct blkcg_gq *blkg_create(struct blkcg *blkcg, struct gendisk *disk,
 	/* insert */
 	spin_lock(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, disk->queue->id, blkg);
-	if (likely(!ret)) {
-		hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
-		list_add(&blkg->q_node, &disk->queue->blkg_list);
+	if (unlikely(ret)) {
+		spin_unlock(&blkcg->lock);
+		blkg_put(blkg);
+		return ERR_PTR(ret);
+	}
 
-		for (i = 0; i < BLKCG_MAX_POLS; i++) {
-			struct blkcg_policy *pol = blkcg_policy[i];
+	hlist_add_head_rcu(&blkg->blkcg_node, &blkcg->blkg_list);
+	list_add(&blkg->q_node, &disk->queue->blkg_list);
 
-			if (blkg->pd[i]) {
-				if (pol->pd_online_fn)
-					pol->pd_online_fn(blkg->pd[i]);
-				blkg->pd[i]->online = true;
-			}
+	for (i = 0; i < BLKCG_MAX_POLS; i++) {
+		struct blkcg_policy *pol = blkcg_policy[i];
+
+		if (blkg->pd[i]) {
+			if (pol->pd_online_fn)
+				pol->pd_online_fn(blkg->pd[i]);
+			blkg->pd[i]->online = true;
 		}
 	}
+
 	blkg->online = true;
 	spin_unlock(&blkcg->lock);
-
-	if (!ret)
-		return blkg;
-
-	/* @blkg failed fully initialized, use the usual release path */
-	blkg_put(blkg);
-	return ERR_PTR(ret);
+	return blkg;
 
 err_put_css:
 	css_put(&blkcg->css);
 err_free_blkg:
-	if (new_blkg)
-		blkg_free(new_blkg);
+	if (blkg)
+		blkg_free(blkg);
 	return ERR_PTR(ret);
 }
 
@@ -498,7 +492,7 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			parent = blkcg_parent(parent);
 		}
 
-		blkg = blkg_create(pos, disk, NULL);
+		blkg = blkg_create(pos, disk);
 		if (IS_ERR(blkg)) {
 			blkg = ret_blkg;
 			break;
@@ -879,7 +873,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	while (true) {
 		struct blkcg *pos = blkcg;
 		struct blkcg *parent;
-		struct blkcg_gq *new_blkg;
 
 		parent = blkcg_parent(blkcg);
 		while (parent && !blkg_lookup(parent, q)) {
@@ -887,23 +880,14 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			parent = blkcg_parent(parent);
 		}
 
-		new_blkg = blkg_alloc(pos, disk, GFP_NOIO);
-		if (unlikely(!new_blkg)) {
-			ret = -ENOMEM;
-			goto fail_unlock;
-		}
-
 		if (!blkcg_policy_enabled(q, pol)) {
-			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
 			goto fail_unlock;
 		}
 
 		blkg = blkg_lookup(pos, q);
-		if (blkg) {
-			blkg_free(new_blkg);
-		} else {
-			blkg = blkg_create(pos, disk, new_blkg);
+		if (!blkg) {
+			blkg = blkg_create(pos, disk);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
 				goto fail_unlock;
@@ -1468,27 +1452,18 @@ void blkg_init_queue(struct request_queue *q)
 int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
-	struct blkcg_gq *new_blkg, *blkg;
-
-	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
-	if (!new_blkg)
-		return -ENOMEM;
+	struct blkcg_gq *blkg;
 
+	/* Make sure the root blkg exists. */
 	mutex_lock(&q->blkcg_mutex);
+	blkg = blkg_create(&blkcg_root, disk);
+	mutex_unlock(&q->blkcg_mutex);
 
-	/* Make sure the root blkg exists. */
-	blkg = blkg_create(&blkcg_root, disk, new_blkg);
 	if (IS_ERR(blkg))
-		goto err_unlock;
-	q->root_blkg = blkg;
-
-	mutex_unlock(&q->blkcg_mutex);
+		return PTR_ERR(blkg);
 
+	q->root_blkg = blkg;
 	return 0;
-
-err_unlock:
-	mutex_unlock(&q->blkcg_mutex);
-	return PTR_ERR(blkg);
 }
 
 void blkcg_exit_disk(struct gendisk *disk)
-- 
2.39.2


