Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3011ACAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7595F8E0001; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475738E0014; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCD98E0016; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFDB88E0012
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC0171DEFBF
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
X-FDA: 83927089386.01.C681FF0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5478D18000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaGAnb0jQxIUu9FI+O1KH7UMEAXTwVdyVgZ3u+pnfH0=;
	b=bTaHxqDTNn1nC1k204R73UxmtI2Yzazr6QedS7sOB0G4gN+vyV2FF5UBiowBv9LRUMS/ht
	cNIN7ja4BW2nfioNgVVPY9g5DD2+kVey1Vw1V8Out2POcPXHEeB/iNhG1a3VC/TjR6+LTC
	S9PjUWwUvicwt6Z3C+1OXNzr0abvAKU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788752; a=rsa-sha256;
	cv=none;
	b=YFnzdbSofqUnhcEXPiMxZ5FUhfOdwwHL3/tGKi3MWZt7VXVaaL7fx1fbD02m2rzaP9ZS7i
	GS2uYGnPwBCcknZHCmSUeMoeyAPhG3yf+a6KSSsiF6zDZnOo1wLrIHFNtDwpo7ttgFPJwJ
	TBZbNoyo0nioWuLp4Pk05891G2dKUHI=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcL3fMbzYQvXb
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 71E071A10CA
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:47 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S6;
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
Subject: [PATCH 02/10] blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
Date: Thu, 25 Sep 2025 16:15:17 +0800
Message-Id: <20250925081525.700639-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S6
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4UKF4UuFyrKF15JFykuFg_yoW5ArWDpF
	W3Xa9xC3y0qrW7uw43XFyqqw1S9a10qr15JFWxGw4fKF40qr1fXF13ur95ZF4S9FWxCr45
	XF4Uta1DCr42kwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 5478D18000D
X-Stat-Signature: q1ynhujxc1hs81sigk5oyifxg8hojzo6
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758788750-229539
X-HE-Meta: U2FsdGVkX18xc9+Si20tSPnzCXw84tYG76YKnCaG21csCj0t9uV44X2Gkuq9/prsyhOkSSwt2020UDJrgiYHK6WmS75ksG/ghoPpFMlEUg3F/6bzIOLCoaobHMVvy4CR+zh/jhVluQ0uB36cAuGlygtUcGIQ4rzwt3z4Lv+AVLfolWMeWfFRsSHBzG3K1tMobXdGiKKC2eqkrKecF4I4EQHAUr5cyjukBAmCngOrXGrCNrkBh0rnwQUEXyknRbSxZkI3dkYgBPFYEpULc+XMblSl52Hb/SO8mubbu0T9l6to9/iIH7JmIYmPxmP8FuA/t84k0SykYKR1+y80AaTRvg5K0SY4BWv7O28y1UXAxQfSV4L9L8KEB/uG1ve/+bkbQTgzSKMfntp0v3sO2zg3iZ2Ec9fJubIoYxUVNNzQNkxPmvx9cMVPRCLajjR7nJNXM/xU/8GWmKxaianwxeQVpkz9Whny9MDzSJgoHyh0zUfcB1Vo6r1rImw4Nlnrl6BWvH4s5a6WMfK7qB6/WJxgg/5z6JnjFI8tMyLF7Vp6Cg7nUr8/dRmLjuMbPQIopjmsnZL35Ft2fjGGlB6xQG1mbhaNJ9oH62+gt4FvplK7Gxoc74EJWIueDDYv3mHcKJwbctTgSQ6/H+/yG2amnHp53/RPInqqJ7AzaKyloSGF0S+Ihz5yASPYQZPfOpgaj5hJpAyYvHVGsYip1B7Wd1Ga0wWrkaiSoioua57QCsuItgRBm+NuvJM6yhPOxVTAV+yoea77SbGCQQNIXpiODKEN3fbbBZUkhj/9+T4wv+pGiaxz+e+JjA24+yFYoV3pEvd7Fg3oX7JfD0PEM+IKSN+N70+hQf7KMkwU0XwqQ3Exk+g8XK3Wd7M3MFEhDKrPNLkf9PtIiQzsFH4FSuuXBAzDAsg2C0XSAG7RFqavbhEOL+GmPggYmKoG5YYtbHwgwKp88i3RUqB+v4llhdHo1qx
 k+4TMcIO
 2Xh1Qkrt6pFqbbpSgzuf1Ul9RRVIYsPC5qmnS9A7/tpr9uxxGzJtrsXfUEPhGAAIxgyMrrxsBWMnLeuhpM+lHG+tirLeJ5WgDRwS6ecuxCWD4wzUO7bSNCxZNw36p1qrhwsMdETuyxu+n7MM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

Changes to two step:

1) hold rcu lock and do blkg_lookup() from fast path;
2) hold queue_lock directly from slow path, and don't nest it under rcu
   lock;

Prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup.c | 57 +++++++++++++++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 21 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 2d767ae61d2f..9ffc3195f7e4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -467,22 +467,17 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 {
 	struct request_queue *q = disk->queue;
 	struct blkcg_gq *blkg;
-	unsigned long flags;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
 
-	blkg = blkg_lookup(blkcg, q);
-	if (blkg)
-		return blkg;
-
-	spin_lock_irqsave(&q->queue_lock, flags);
+	rcu_read_lock();
 	blkg = blkg_lookup(blkcg, q);
 	if (blkg) {
 		if (blkcg != &blkcg_root &&
 		    blkg != rcu_dereference(blkcg->blkg_hint))
 			rcu_assign_pointer(blkcg->blkg_hint, blkg);
-		goto found;
+		rcu_read_unlock();
+		return blkg;
 	}
+	rcu_read_unlock();
 
 	/*
 	 * Create blkgs walking down from blkcg_root to @blkcg, so that all
@@ -514,8 +509,6 @@ static struct blkcg_gq *blkg_lookup_create(struct blkcg *blkcg,
 			break;
 	}
 
-found:
-	spin_unlock_irqrestore(&q->queue_lock, flags);
 	return blkg;
 }
 
@@ -2077,6 +2070,18 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 	atomic64_add(delta, &blkg->delay_nsec);
 }
 
+static inline struct blkcg_gq *blkg_lookup_tryget(struct blkcg_gq *blkg)
+{
+retry:
+	if (blkg_tryget(blkg))
+		return blkg;
+
+	blkg = blkg->parent;
+	if (blkg)
+		goto retry;
+
+	return NULL;
+}
 /**
  * blkg_tryget_closest - try and get a blkg ref on the closet blkg
  * @bio: target bio
@@ -2089,20 +2094,30 @@ void blkcg_add_delay(struct blkcg_gq *blkg, u64 now, u64 delta)
 static inline struct blkcg_gq *blkg_tryget_closest(struct bio *bio,
 		struct cgroup_subsys_state *css)
 {
-	struct blkcg_gq *blkg, *ret_blkg = NULL;
+	struct request_queue *q = bio->bi_bdev->bd_queue;
+	struct blkcg *blkcg = css_to_blkcg(css);
+	struct blkcg_gq *blkg;
 
 	rcu_read_lock();
-	blkg = blkg_lookup_create(css_to_blkcg(css), bio->bi_bdev->bd_disk);
-	while (blkg) {
-		if (blkg_tryget(blkg)) {
-			ret_blkg = blkg;
-			break;
-		}
-		blkg = blkg->parent;
-	}
+	blkg = blkg_lookup(blkcg, q);
+	if (likely(blkg))
+		blkg = blkg_lookup_tryget(blkg);
 	rcu_read_unlock();
 
-	return ret_blkg;
+	if (blkg)
+		return blkg;
+
+	/*
+	 * Fast path failed, we're probably issuing IO in this cgroup the first
+	 * time, hold lock to create new blkg.
+	 */
+	spin_lock_irq(&q->queue_lock);
+	blkg = blkg_lookup_create(blkcg, bio->bi_bdev->bd_disk);
+	if (blkg)
+		blkg = blkg_lookup_tryget(blkg);
+	spin_unlock_irq(&q->queue_lock);
+
+	return blkg;
 }
 
 /**
-- 
2.39.2


