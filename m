Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24132CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94DEB8E0016; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FDC88E0019; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E148E0016; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 572F88E0019
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20D3BB920D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:55 +0000 (UTC)
X-FDA: 83927089470.03.93CA563
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id F044640008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fi0zRlKegJN8pSX3GZ0HHXefJg0rR6HAPXORLyWearA=;
	b=5jtdPMWN6fZMHAno0RhCVUImkG84SDzXEaWZbZPKR+CFrza1eODTKV34RP1kCJWx3/MuHy
	hVp33MMXknTn+pgmpm/AGDamy+lLHBlOj7o079z+dbvikSoTecSAjReX+2V5urdmbszVTO
	aOd9CpCJUzK2qXXbJD7GEwgQvIwm/oM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788753; a=rsa-sha256;
	cv=none;
	b=OHmumoYzQZwB0hedA/jN6aLuQ82FVdLihuWk3XmLTEo0HOTG26aY2NP7TTLoyWKPCSjO+N
	ZYY/MmcUGL9XQoFIXMoyrabgs/Q4RolEKqgG8wlMj271al6fl4R7p9vELpBQ+O5sc/oPXp
	BkWHIZnacxa9cBHChhevXm/pL+fpUeo=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcQ1Gj6zKHN7S
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0C93D1A1B68
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S10;
	Thu, 25 Sep 2025 16:25:49 +0800 (CST)
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
Subject: [PATCH 06/10] block, bfq: don't grab queue_lock to initialize bfq
Date: Thu, 25 Sep 2025 16:15:21 +0800
Message-Id: <20250925081525.700639-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S10
X-Coremail-Antispam: 1UD129KBjvJXoW7KF4DWr1rWr4ftFW5Cw4rKrg_yoW8GrWDpF
	Z5Wa1Y9w10gr4DZryDJFnrXwnrGa929rWxtrWxtr45Kry2qrn3W3W8Aa4xXF4Sqrs7Aan5
	ur45K392yr17t37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Queue-Id: F044640008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9yqcuitq1d33rjwus4r7agz9f6adh7qt
X-HE-Tag: 1758788752-46892
X-HE-Meta: U2FsdGVkX1/KcCWbIM1a61SbMSJ/w/MLxIqtS6QZsvoapEjIVJJSc66nXxNQeJ4Vk9kDgwROUiMzjq9mJetVUeSgL5ikOMO2APAmuTfauSjZtfdhAIPNeEmTGBta+BqnW8YyBShKMCbTMioyPgnq05jx53edBQ5vKF/pFTkL7p13uIhMeSPmE38T3tARTyisx9mKeTD9bqTzibp+zbWVRVgNUcJv0UeH13ABYURGRwdKam3rw0BOCIh24b33Qjh2fWupDtG2Uc9M76vOgcn9SriEIEESnll8PxluH6vhEvQ67csL7UedLL873RETZVc0qhP5jGfDb/ZwSeMCBsZrI0evT+9ZDOnxTO9vZ4g9+l8Lb/zGKPWONh0rDi5inj0xuOjFB2RZ/iPNDIJxvFz+/Wcr91s+vS3VdiFtwx3mHybNefI0aGPda48DikQPni4c5zwxJT3YrWuR/FE8bz0M8S/XzLc13C1H8nO4RQlxxDcFt610AjF55rQpB2Dp2mjA18BBIAKmTBgYlAnFGf3Q3sbvA1Q+Y+4dHYUFrKZmcTc9TasreZGoQPo7hGdC3ruQzjJGlTxoGkl/4+l17RgNDrLi/7C+4QkRP4ayY6q/mm8tCKbLhe5anSh6+bCVBAMZZQIENlBXc69K5DMJmRG3bZdplBDWMXE54PMsl+xU1huX53qRU1yVDs+Tm/zf07jpki9TyExwflkbuL0B6JXVGYfJA8+P08X0MZpBRab/2Zce13H3jepOWCkchfDMsETHnV2xbu/KmGQ99A/9fQluPU73/kbD0M15ywAtsB9p+fpzJnQPNo7vJCBoVYP7DA3YGCpzMWz0ZGqrt80hb6y1WQicXGuXOFnmC3uFDFfwxu0cxy5DyaWYCAeo9kCxA/4hGmpjuMP9/luuOwoCLZ6HDbHO/4Dlk1MFM7/SEHyYKYxgtEmQH0rs1Nz7o+tci/2AFDRJtFXSCHZY8ndNMot
 /0ODMyp/
 aGJbHh8D/bOjZnAql5ynQjJhsSBiq/X+EM6FrBiQpo7woahMyN4L9MJ1DKJG0yQhSMyNGC2+9MhujVTKwzhgJvURp0adTY0tgdZsO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

Request_queue is freezed and quiesced during elevator init_sched()
method, there is no point to hold queue_lock for protection.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/bfq-iosched.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/block/bfq-iosched.c b/block/bfq-iosched.c
index 4a8d3d96bfe4..a77b98187370 100644
--- a/block/bfq-iosched.c
+++ b/block/bfq-iosched.c
@@ -7213,10 +7213,7 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 		return -ENOMEM;
 
 	eq->elevator_data = bfqd;
-
-	spin_lock_irq(&q->queue_lock);
 	q->elevator = eq;
-	spin_unlock_irq(&q->queue_lock);
 
 	/*
 	 * Our fallback bfqq if bfq_find_alloc_queue() runs into OOM issues.
@@ -7249,7 +7246,6 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 	 * If the disk supports multiple actuators, copy independent
 	 * access ranges from the request queue structure.
 	 */
-	spin_lock_irq(&q->queue_lock);
 	if (ia_ranges) {
 		/*
 		 * Check if the disk ia_ranges size exceeds the current bfq
@@ -7275,7 +7271,6 @@ static int bfq_init_queue(struct request_queue *q, struct elevator_queue *eq)
 		bfqd->sector[0] = 0;
 		bfqd->nr_sectors[0] = get_capacity(q->disk);
 	}
-	spin_unlock_irq(&q->queue_lock);
 
 	INIT_LIST_HEAD(&bfqd->dispatch);
 
-- 
2.39.2


