Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B6DCAC5AA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4458E0013; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BD58E0001; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D432B8E0013; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B9B448E0011
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 335EB85C3C
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
X-FDA: 83927089386.14.122FDFD
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF675A0008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rjzcB4R64r/S18TDBqMiPomw/IvIP8jafBQs8gYBKdM=;
	b=Y+Purfeg4XW0o3hi+lv+gvARqoSDcWwcA7boYPYTqyVkrCDnrbu2hxWxl0qtVEOE7gezJM
	9cUDi7YEBpqpEhhhnAYP4bR8ZQw4xHpAmEWckKjscmZWvCdE2USI+uze//3gy0YZHfOeFQ
	CN21zFJ5ZDNTKNsrEsQaQmwOgxUPWrM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788751; a=rsa-sha256;
	cv=none;
	b=W+eHtiI6Z9g2UsyZySK7E97sDk38d6OhoFqUDaltZYC7AFNQJ/n2t7pb3/WfvaWpdCLFY+
	raTdU4OjXujPVqnbkIHE27sf3RKHPW0o43XtwbeST87aaMhnyuoaR+uq2xsm6kDpqql4ri
	y3Kp3KlBfAw4Z43Lb3iGkA2AdZbfNKE=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcK1YDTzYQvXR
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2B48C1A0B31
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:46 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S4;
	Thu, 25 Sep 2025 16:25:45 +0800 (CST)
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
Subject: [PATCH 00/10] blk-cgroup: don't use queue_lock for protection and fix deadlock
Date: Thu, 25 Sep 2025 16:15:15 +0800
Message-Id: <20250925081525.700639-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww45GF4UXr4UCw47Gr4kZwb_yoW8Gr1kpF
	9Iqr1agw12vFn7Zr1ag3W2gF1rG3yxGrWDJwnIqr4rCF17Zry8ZF18Zw4kuFWSqF92yan8
	tr18AryIkF1j9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
	kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
	67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
	CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1x
	MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
	VFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: CF675A0008
X-Rspamd-Server: rspam05
X-Stat-Signature: yq31365441kkdfssbge3hiunaa48i1ue
X-Rspam-User: 
X-HE-Tag: 1758788749-819600
X-HE-Meta: U2FsdGVkX19kWcTIujlaciYcUY/hW8ehg6oui3Z4/hQpLyQXqQpEVTsmchUUx9UqVSBqQ1TzNiT6YIYR4ciciI4nQacj6p+lO2gvpAoQx7qaBkD/b+HvLplhjtYC6uZTm879y7ut8ZHoTHPd9A6wMecm+5EsbKRRiz0N39S2lxZzMdHXAuZWMT/zI+ozviuPKCbgetK0vPnwviSPZ9SncciwKHviWJ0m6Dfeb+GRTqrFIWG15K5j8PJezsoZrh3OSMW2SPAOJqnsGHarq+2G9aJsJZuv8AXeLliprg3pm7sJjt9nn2HY9+eQflk51+w37n+iVX0016tIvXjPk9A1Naj63IjFlRGQSNodqFgt6/Tw5APpvTwEtdC3j+iFeg2FgiKu9lu1xhvaTfAj/GVqyZ/lImd43HD4mT0s6hlQwSK3aczOdO/ERTbz4gjYSVzbn60i1V9EU1wLi+wMaE6rzmhP/Xz/+9kXLiQr8xtK7vIYQiMsNJOMxWFFNsTzdb2qtDl25IbpbR5Nzkpqqr/JmnHgUCFtBGvFYpiL4teeJ+Q2Bk/XBoMLEEcJl5wWQ9IfifmmYrQ2Kqbdu47OQ4Y2vvYLd/INOOHipBnVT/yqgPyXLh4EmuDf9B3f++mVQ8/pu9F0RLGUlVHo9SXNCIg76c87guzzOfEk6SRFIaVKDiQe/jVwbXUp88yxPJoLiYJgL/77NREkm+NOjVUAQozGWj6Uz4MYrBhWEmy6S0R+dRQKUgeDZq4EQ2hfJTu/9QPoXD6td1Ry2zYKUl/Vr3Eb6MYTAka0HdiTLByzJlBV4SO7Vj66B7LEkzRUJKCYSalcQmsgBx9f1PvGTmmORt/x/JLupaAo1eNWEsjrLz08ulTlM6A7BxlDw4ckqFlf1i0ebYMMdHZb86p2NHhwsvR6L7ALbHMYhywRCcyBQmuIhg45BtURoiROozNHqN+RMcXhmoyMbmezzEIaDBu5OPB
 1KAnuIEP
 DYLkDfhDKgJBkRh5H2eA8YT7XG2/OXHayKkvOY9ZPULmwQkrRZNBqnH/MAXv7Na45kufo1tM88sfJkIE6LrCybYkSfvlhs2NzsgTlt5ivh7HLpQGMYElz3FH6KuVzWNhGeo8JodgiLER7mV0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

patch 1-6 is prep patches to make sure queue_lock is not nested under
rcu and other spinlocks in blk-cgroup;
patch 7 convert blk-cgroup to use blkcg_mutex to protect blkgs;
patch 8-9 are follow cleanups;
patch 10 fix deadlock in blk-throttle;

BTW, with this set, we can unify blkg_conf_prep() and other related
helpers.

Yu Kuai (10):
  blk-cgroup: use cgroup lock and rcu to protect iterating blkcg blkgs
  blk-cgroup: don't nest queue_lock under rcu in blkg_lookup_create()
  blk-cgroup: don't nest queu_lock under rcu in bio_associate_blkg()
  blk-cgroup: don't nest queue_lock under blkcg->lock in
    blkcg_destroy_blkgs()
  mm/page_io: don't nest queue_lock under rcu in
    bio_associate_blkg_from_page()
  block, bfq: don't grab queue_lock to initialize bfq
  blk-cgroup: convert to protect blkgs with blkcg_mutex
  blk-cgroup: remove radix_tree_preload()
  blk-cgroup: remove preallocate blkg for blkg_create()
  blk-throttle: fix possible deadlock due to queue_lock in timer

 block/bfq-cgroup.c        |   6 +-
 block/bfq-iosched.c       |  13 +-
 block/blk-cgroup-rwstat.c |   2 -
 block/blk-cgroup.c        | 329 ++++++++++++++++----------------------
 block/blk-cgroup.h        |   6 +-
 block/blk-throttle.c      |  31 ++--
 mm/page_io.c              |   7 +-
 7 files changed, 163 insertions(+), 231 deletions(-)

-- 
2.39.2


