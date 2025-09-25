Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B9BCAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46ABE8E0018; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C298E0016; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220428E0018; Thu, 25 Sep 2025 04:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2CD58E0016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C03EAB920D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:54 +0000 (UTC)
X-FDA: 83927089428.27.E95EAA5
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45D21100012
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oYLjlfkJpUIxBC4eRDyLLRP0NNwGIdQv/IY73/i08bk=;
	b=emiYAGUv34YKzSDqnbEixb9YyIOxQKy6kUWiDLtB4oAzjxP/qn4AsuaklP2ADaQgCm5+p1
	vPHxGEEHWPVBWLeGtMJuA4HQGcDoZuSgICFjNdz9qMnHgde4bU3VT3gfWeHqkIWOWlTc2w
	bWPsgQmzDBRw06ll0ufbHDrTucI25v8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788753; a=rsa-sha256;
	cv=none;
	b=GtQyUZ7+K3AErmcIu3S09AZ8rUfgw64c9T+gp7VsW5U19tBsvG0b/tmYFQOZpICMfNSe2U
	8lxWRiG36eKkfe3c2ibWAVQ/65o7rZq0bfPlqdG329gk4D5uZ49i/8Jo+gOtvkYDYB5/h/
	6Q70nqrEkD1/sjyBckhcMrZXnmhv3Lg=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcL6fY7zKHN4Q
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:38 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C4E911A0F41
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S5;
	Thu, 25 Sep 2025 16:25:46 +0800 (CST)
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
Subject: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect iterating blkcg blkgs
Date: Thu, 25 Sep 2025 16:15:16 +0800
Message-Id: <20250925081525.700639-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S5
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF47CF1xCr1rWrWfJr1DZFb_yoW8tr45pr
	sxKFW3J34v9F48ZF42g3Z0vrn5Wa1DKrW5J3ykXa1YkF17ZrnxZF1DAr9YqrWSvFWxAr4Y
	qrWUtryYyr4UCwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRMv31JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 45D21100012
X-Stat-Signature: qrewign77pw74nybhqfnfgs97j8ztf86
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758788751-36174
X-HE-Meta: U2FsdGVkX19yfaAUCMU78RG8TXmFtn1ecazfY2OylCsruhuBmJH9hVlJtMd8sKsrNth/DzMvuUdI5PDzRPiBkaX0MfujfVcMzOKZnhzA5fORmOWpsO0CHwCq+zJgHAsn/GR8DcjtqSOjNVoOADyKorDZmANOpHwCoa4GvafIdHuFUy/y/n0oUjdX4j6aP4uBsevULirDnz5R+wq9CLtV2gv8mEInlcvPUMQna3k4kDkgZiCgB4GHQPVn0UB7EBC3JMZA0WGhp452lKmeQ6klNxiIG9Je8XasWyT1Flx2j2gNB4YndgkaZT6aI7W39jhUb8LqtXnwpKrCeyBCuqCJiRxlnO7jDJ1fGCkLsKScE324f5lH2GT0Bs5H9mvvFvXmE5NBx0esZeabOZaXuXQ0CH0tTSCPflet0Ekivr/B/oMj8V8/egxqpIiCk1aGl2BPosKj7ERZDzyHBBqdOW1ir0PEvLQLZousWVDzOvmnwFz6EVaCGBRYRLTXeZpUHwfYtMEpu8x7SAsUHBWw2je8OzR38OrxmhHqbU/u+T6xCUaw8xhhRS6SDm+XkMQkGXmgeCjH1ppJgoMqytoVN3y3+CchLEGcFvE629I8L/VLQyTSE8RHzT0DezwnR3oxAVzsr0uux146HpvWQJGL2WrXVWX0czHw3SW8Z7t/aVWYaMtWu6Eva/q5ngHHKsooWurAw3CXbxrKyYr/cucEMfdaC0Hdgl/kcGn54pk9T1XNgdtO6smomSoW4NCVQV/yxJ8+fGDOCcpigxV2MzwWxA0h4yoU5amjujg2iZkVBr3wL5Hgxwq9YTy1bW7SWAIbPC4BC0CfM/lhrI/+7sCmd430filJn3cJ1FgzDzXwFDGuPDspYtHddNVNfH/5mRtvdB0EpYWA4YNxAc61lJGLEUy7UKYUVqs0CaZptBltLdBoveZ7Ptu0LAhoyMEpSyoMXw1YmJ+G9SLo8Z7v5oYHUAx
 GuoM69+n
 M8cgAlumzqcPVqUoCujZcuE0LJZMeh6R1Vi9je5vcL9srT2dT+C3i03aHWfjdlXzB6B9pD4xF+OVPXufwt8Ys6/8pjwsScz9Y1vir
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

It's safe to iterate blkgs with cgroup lock or rcu lock held, prevent
nested queue_lock under rcu lock, and prepare to convert protecting
blkcg with blkcg_mutex instead of queuelock.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-cgroup-rwstat.c |  2 --
 block/blk-cgroup.c        | 16 +++++-----------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/block/blk-cgroup-rwstat.c b/block/blk-cgroup-rwstat.c
index a55fb0c53558..d41ade993312 100644
--- a/block/blk-cgroup-rwstat.c
+++ b/block/blk-cgroup-rwstat.c
@@ -101,8 +101,6 @@ void blkg_rwstat_recursive_sum(struct blkcg_gq *blkg, struct blkcg_policy *pol,
 	struct cgroup_subsys_state *pos_css;
 	unsigned int i;
 
-	lockdep_assert_held(&blkg->q->queue_lock);
-
 	memset(sum, 0, sizeof(*sum));
 	rcu_read_lock();
 	blkg_for_each_descendant_pre(pos_blkg, pos_css, blkg) {
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f93de34fe87d..2d767ae61d2f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -712,12 +712,9 @@ void blkcg_print_blkgs(struct seq_file *sf, struct blkcg *blkcg,
 	u64 total = 0;
 
 	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
-		if (blkcg_policy_enabled(blkg->q, pol))
+	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node)
+		if (blkcg_policy_enabled(blkg->q, pol) && blkg->online)
 			total += prfill(sf, blkg->pd[pol->plid], data);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
 	rcu_read_unlock();
 
 	if (show_total)
@@ -1242,13 +1239,10 @@ static int blkcg_print_stat(struct seq_file *sf, void *v)
 	else
 		css_rstat_flush(&blkcg->css);
 
-	rcu_read_lock();
-	hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
-		spin_lock_irq(&blkg->q->queue_lock);
+	spin_lock_irq(&blkcg->lock);
+	hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node)
 		blkcg_print_one_stat(blkg, sf);
-		spin_unlock_irq(&blkg->q->queue_lock);
-	}
-	rcu_read_unlock();
+	spin_unlock_irq(&blkcg->lock);
 	return 0;
 }
 
-- 
2.39.2


