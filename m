Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4764CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5193E8E0011; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295A08E0018; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA288E0014; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B94DF8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F6F01603AB
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
X-FDA: 83927089386.12.22D9CCF
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BD8EC0004
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788751; a=rsa-sha256;
	cv=none;
	b=cNi8TP8j7DB0XgXk+E2FbFzqWWUj2y/BUAFRCSvcRCjuhbdaik2Oz7n89RyBXE9DVZY5xz
	rA1ZO0bM4llA3VJcSCjfmrCP4GG2AQLXRgdxm+k3xkYsxzwv7NEU9jGMychZ29x/Q28VfK
	PHPyj5fBIKs/JFt4Q178MhIS19RuEwE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kAQzNb78lo/I0F1yXjfnUQvl1j/GVijMVjlArmN9OYo=;
	b=o/fdaTun/D+SdBeaTe61dtBdm+cpy/ORqzD7iOaGa9wxvh3QyXhJU9LVLiF/7IPo6Ke/pj
	Iu4fyst6etiuwhAEakKzatRD6L9qEk6O28agROVBYHoJCh96zhh+2GJ1ac3mCxEOPsHckJ
	5ykLw7OOlOMwi/hqvYmYrcO4UI4Mw5I=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcM1CcYzYQvYG
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2022E1A10D2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S7;
	Thu, 25 Sep 2025 16:25:47 +0800 (CST)
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
Subject: [PATCH 03/10] blk-cgroup: don't nest queu_lock under rcu in bio_associate_blkg()
Date: Thu, 25 Sep 2025 16:15:18 +0800
Message-Id: <20250925081525.700639-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S7
X-Coremail-Antispam: 1UD129KBjvdXoWrKryrGry3KFWkur1rZF4kCrg_yoWkuFX_XF
	1ku3sYgwn5A3W3try5ZF1YvFW8C3yqqr1qga4Y9a43Cry5AFZFgr9Fyw45ArW5Z3Z7Cryj
	vrWDXr47Grn2gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbkkFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0pRl_MsUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9BD8EC0004
X-Stat-Signature: t3mhj5cfdta3wmk7w8s9td4w7nqfga7n
X-Rspam-User: 
X-HE-Tag: 1758788750-551934
X-HE-Meta: U2FsdGVkX18BVDLZPxcGZW4eTdu0WEzDVF9pT0Hb+k0LfRTOYUlpoF9tdDEEa8cDI0AQt20O58aB2/hicDu06gClKu67L8suiszAcnhZieTEjP7Rcf0KnKAg0w1+oIaD6AQtz6qTJIjMi5Tvpv9pSWgy0NlrVbjtKcKE87wpaAsbCnWpchWa+IEBYsB9aZMvS7/DOtUqxI8RKed5v09BzT8MN6KUqgzN5Z861HcQtMJSAAROfnc09+5mUn9ATqGBxqK9IwmJtZSbKkhjsZJvp5q37geNjh7MjSV9vvgfQN+JSkD8i7zN0AcSLlsGzQcuoBpCq10PzBZcCVGs+UqSnMixmBJfqv58XlTJpvqHcUnhYByJWcss3Ehvgm4wPOGEUUKdYfFCuyKiZtEqIVux1UECxML0FQcuAWPSZ0i8QvkysC1m1FqQXhly/OmvbD7UnerFodS3FLOP6qm/PvUQmdXCjmJEoi7tDT29o3qElV/WMUDxtMK2vYMtxnCKUho8JXO0nne7vspg7YMJV+m/7xonFrj6ik8FHNbPN7zXqtLQs+HutltxSNvyhfI04JDPypWUigmz5EbwqlM8pSb+Hh6qCQ5sIBuTu5dSl/KBAVkKMpMAfhhU2eRNO7fWh3/WbvP8qsfdrakYqVK7uEJtfhWGjDXocyGR00JgqOtrUSuopOuJX0eAnTkKSwx/VZtpnSNdyTBugyKxHY5kI9GPJNAPQt4FZ5iTW7h3Y+K1OVzQpuuOC7DhQt+KCWM23iA/7PCbJuQM8deAjos5njYTjkxvS/xibwu1kjtKDzr1AF//A9jNXTYovrdkuZuMjVnetaaeP5snZQopxmvmdkW+/dP4bQtxpJxWGfH3vAWcYQyiRT59gLfVkpW1Rp0YdsBtId5uDRkQZjpF6hQ0TFB59iCfdm8udVmhl9iWC7/0UgjXzbCliV3v1gsCHXWpNW6OlmtDpyjZJ15DI6rnMss
 2nDgdpVm
 AtuzWn+0NazygPwSJ3ijQ1Y/yFFcPd9qK/0MUAP7zwO0Y7kikJfS8RXq7HPDtDjNLqRjn6YZz9lY3ECLACLpgxYboP5C8GNEA/dFv0YH8lafjuklGib7VJ3+R2+ITFQH0RxgOXbmD/wSz+uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

If bio is already associated with blkg, blkcg is already pinned until
bio is done, no need for rcu protection; Otherwise protect blkcg_css()
with rcu independently. Prepare to convert protecting blkcg with
blkcg_mutex instead of queue_lock.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 9ffc3195f7e4..53a64bfe4a24 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2165,16 +2165,20 @@ void bio_associate_blkg(struct bio *bio)
 	if (blk_op_is_passthrough(bio->bi_opf))
 		return;
 
-	rcu_read_lock();
-
-	if (bio->bi_blkg)
+	if (bio->bi_blkg) {
 		css = bio_blkcg_css(bio);
-	else
+		bio_associate_blkg_from_css(bio, css);
+	} else {
+		rcu_read_lock();
 		css = blkcg_css();
+		if (!css_tryget_online(css))
+			css = NULL;
+		rcu_read_unlock();
 
-	bio_associate_blkg_from_css(bio, css);
-
-	rcu_read_unlock();
+		bio_associate_blkg_from_css(bio, css);
+		if (css)
+			css_put(css);
+	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
-- 
2.39.2


