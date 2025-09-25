Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F77CAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1B38E001A; Thu, 25 Sep 2025 04:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B968E0019; Thu, 25 Sep 2025 04:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54828E001A; Thu, 25 Sep 2025 04:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6C038E0019
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9ADE486B13
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:56 +0000 (UTC)
X-FDA: 83927089512.02.938F6FA
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3691B4000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H8uVneCt4NHzCxbr+QTiIQvEihqiTz4+4rx6wCrITX0=;
	b=AJx/QMkQWwZzKqlTasbHhxvFNvyeUffcIagwJylBepWArjhv1mFX/33r8nxg+GZi7PpL3j
	NXbzd6GiRIuLiB6l6i3AOJ+LqUbvuYRLHLZ2QXLlixVmFPemT+SXbm4Z79zaOn5R3tnVwm
	pooLmmWZbasdXiyJtemA4E7mxMTtYQE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788754; a=rsa-sha256;
	cv=none;
	b=UPff6AcFal6M1DqqNN1oXnadkP6AZLuqqTId3kNtBnJxj4C85mBpoAPYV18/UIgMWRvLMo
	p5YUrvIEkuST7X7Rph05Ljd5z9XQvgcJoidm6WQKsc7Sh6OCN3lYQX2vycfusKMVKy1dy0
	1nrUVhuuIiqfKiIwhTyXiYx7ZYTDVVY=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcR3KdnzKHN4T
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 530DD1A1068
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:51 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S12;
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
Subject: [PATCH 08/10] blk-cgroup: remove radix_tree_preload()
Date: Thu, 25 Sep 2025 16:15:23 +0800
Message-Id: <20250925081525.700639-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S12
X-Coremail-Antispam: 1UD129KBjvJXoW7WFy8Gry3AryrXr1UCry5XFb_yoW8uw1UpF
	W3trZxG348KwnxZa45Xw17Ww10qa18X3yrGrZ3Gw1S9FW2vr1IgF10vr1kCayxAFZFvrs8
	tr90qFyFyFyUCw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Stat-Signature: c3663mehu93o17gxc1bxmwtu47stpgus
X-Rspam-User: 
X-Rspamd-Queue-Id: 3691B4000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1758788753-481149
X-HE-Meta: U2FsdGVkX1/p5dKmyVyuMcxqJ9FoNh2o5/tzW8xA1i+He6eAqvaylbg0tupvd8qqoRJ8kcdMU76FnW+Eiq2IT5pBNpTW+ItGVcYn8FvBlImEdccj1bwBq5SWzGCk1w3FO+JhP/MXVDgJAOD8FS3H6X6eITdKA6X2mry6mSuAgoF83mO/Nyw1imoCYm2VPfaYMKnjJmGv5sVH2qFJs2Mv6s7JixU5AdHWBc38E9jaDSPS0ujLUXUboEUDU9WqqPJtBTGP4VbBxVbSdFh7kEiv5u7G7v5pEa27R6i/GrmDUCR9Om0LxhpV4O/E9/dQOuZjAIqviMpAwOQJAJo/3ssmRMlriNSdARgO9Ol3UEAU+Cm3tRxFc2LIavEjuMZQnxYZcM+ISp7hWb/wugUhaV/2NwuufETdm9DbV4kjwOH32v6dE6YEzSQurdnFWEJLgHXFkwFnnNfYXd0O4TPH93b0xWAVBhCx93K5gwRwFD11uAyQsncO3Ba3xFpDcf4Eok3fMhgKBHg7IV/ergaMuF19o7xQD6Btx8slAkO6+P6wV7pMx1kYrl5T6fu+QOniN7Da6e+t715tEugdHcX3LmI3QZLa1svYx2HkHyDzc58dGJADYPb2iCR+jkBRM6X//Voag7gDFyG+cHOIzEhQprvh8J0JGJLMdvo5DVT24MzwhVHGIRBBtOWnsnuSwgpFEZJRb+pfSMRk6QYw9I8/ok3/GrlILoVGESUWkn+L3BZCPHyQIphmemGnNJOcAcImMTmPuthOfG0vzjzja/7FDocUfsMb+o7Zu8BxtuBozmuUNRKgqb3/TDTTGWXrTiFLNHqVWVej1J51koodJzJbLk3zD9cBy+ZCFv2NcVwNnAEJIskZCZ2B4QlEHYnc+szVK/FiMgDLgNSMikS+LSZW/6s3Manv6xp1BBFYimnUB+0yZE/F7oPggw1zidQkdUwG2K2hcmBkGEXeiapGZDG9Bn8
 rRkldurp
 FQ8pFA3Y7dyxAxGhVo/A3I5iNK5qvUsFfOFEsc71fA2GPtU00BmETsIm3RlbbOXeuMMjvVaNPgAVnaALWVWGfTVOluCDyIEzuTM36NMMuKCYGIZr5GUIoCheHI1mn07xXug4MJyIMAKhHUJ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

Now that blkcg_mutex is used to protect blkgs, memory allocation no
longer need to be non-blocking, this is not needed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 280f29a713b6..bfc74cfebd3e 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -893,16 +893,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail_unlock;
 		}
 
-		if (radix_tree_preload(GFP_KERNEL)) {
-			blkg_free(new_blkg);
-			ret = -ENOMEM;
-			goto fail_unlock;
-		}
-
 		if (!blkcg_policy_enabled(q, pol)) {
 			blkg_free(new_blkg);
 			ret = -EOPNOTSUPP;
-			goto fail_preloaded;
+			goto fail_unlock;
 		}
 
 		blkg = blkg_lookup(pos, q);
@@ -912,12 +906,10 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			blkg = blkg_create(pos, disk, new_blkg);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
-				goto fail_preloaded;
+				goto fail_unlock;
 			}
 		}
 
-		radix_tree_preload_end();
-
 		if (pos == blkcg)
 			goto success;
 	}
@@ -925,8 +917,6 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->blkg = blkg;
 	return 0;
 
-fail_preloaded:
-	radix_tree_preload_end();
 fail_unlock:
 	mutex_unlock(&q->blkcg_mutex);
 	/*
@@ -1479,14 +1469,12 @@ int blkcg_init_disk(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *new_blkg, *blkg;
-	bool preloaded;
 
 	new_blkg = blkg_alloc(&blkcg_root, disk, GFP_KERNEL);
 	if (!new_blkg)
 		return -ENOMEM;
 
 	mutex_lock(&q->blkcg_mutex);
-	preloaded = !radix_tree_preload(GFP_NOIO);
 
 	/* Make sure the root blkg exists. */
 	blkg = blkg_create(&blkcg_root, disk, new_blkg);
@@ -1494,16 +1482,12 @@ int blkcg_init_disk(struct gendisk *disk)
 		goto err_unlock;
 	q->root_blkg = blkg;
 
-	if (preloaded)
-		radix_tree_preload_end();
 	mutex_unlock(&q->blkcg_mutex);
 
 	return 0;
 
 err_unlock:
 	mutex_unlock(&q->blkcg_mutex);
-	if (preloaded)
-		radix_tree_preload_end();
 	return PTR_ERR(blkg);
 }
 
-- 
2.39.2


