Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F93CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 08:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CC38E0014; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9772E8E0018; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B34C8E0016; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDA88E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 04:25:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E8C3158B04
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:53 +0000 (UTC)
X-FDA: 83927089386.24.055E094
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id D1F8940003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:25:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758788752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zl/S3SkZidcl3Ov/vAIUAU60/z5JybRm0bxGUAZrrvs=;
	b=ITC6PQCgkzmWlktIRMFPGKAohcd8Zo1FZZdqpPKTtFIhaMGsNOvGWfjE/MmTTq3TWRYoKE
	ZK2HEPU+VAi0MxxNQk4ROWrBazQsXQAjTTXcda7HthCtnEPOv3tiTaUf9Wy0nVPvWEdPsj
	mT9U2suAC0zrfW4HDHNjlPKh0h4k5P8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758788752; a=rsa-sha256;
	cv=none;
	b=MljUGhtc2G2ukQiG+/zPPBVMVeFa1oBtAxijcTx+vq1UyYdEvEdRMV0hs+v8BdsS+irXOG
	JuMh5W8e9wu+tVaMAe8IKy+MlkLL2bDSS9yHadyXAGI18pyAmN4cdjlHE4WznUUzdBBFmH
	rM71+iEVXRqC/U06Qne/NI8hzm6zzIM=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXRcN3C4tzYQvZ9
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 668A71A0C6D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:25:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCna2OH_NRodTcIAw--.12615S9;
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
Subject: [PATCH 05/10] mm/page_io: don't nest queue_lock under rcu in bio_associate_blkg_from_page()
Date: Thu, 25 Sep 2025 16:15:20 +0800
Message-Id: <20250925081525.700639-6-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250925081525.700639-1-yukuai1@huaweicloud.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCna2OH_NRodTcIAw--.12615S9
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyDXw45uFWxGFWruF1kuFg_yoW3Kwb_Za
	929rnIgr1FyFyft345Ca15XFW8t3yv9ryjgF1j9a4akFWUZF1kKFWDtws8Ar45ua48Za1U
	Cr4DWrW3Cr12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7sRiHUDtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: D1F8940003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rqahqpa6ph577kasyh576by8braakf7c
X-HE-Tag: 1758788751-845048
X-HE-Meta: U2FsdGVkX18BDAzcLVGPmgCxxqZuR3C30ogW4poIFw3cRvZEVPJNf3ucL2dZ+BF0DPER0W7jSeTxyqAcn0RbZNag25tCBugnU1G/wP5qT2vyoq0HtnY3I334BjMn5oGdFIg1pF3dUqH4JmrcnkXS/GHYhL3b5S7DUGI+Z2+RcJQ9SIbx6DzbPLCkOsPob3ot1/rYgWEJcUplDoOgrJxTSns6iZpYEFqr9HjRBLdhdaCzFAGBJaHTerTm9B5ts1d4G3OBU9HNYgHyf1l/vFLZuNAo1DbcjjEIx+pxfDPVEURybP76rBPvLA8Ge20Ufo7gh/USl7Qw0alUqm3xC5lJjA73UoelOXadOW0jaacTUmsuMVR5gX8PPuk6d5pBaXoTAAUrNJ44uR07hK5C+6wXvr86Y+In7xjtA1HlmTK4gOQOVQEIpr/K/xqKsdBgsDU0LN3IhEFt4wEKFYRq51MgB/qv0ifBwxqYWVS6mr0p+1datEbXaRUFOCbBXTvcb52fzCaq15cHRmfwc0aNyN1jZsJOZWeN1srn/yB6VPHWovPdTZB0FebA/IJ5crfjg6KNcEPvNFe/01SoVf49IhxCV9OaRRP/LY3FnGVgv9uSMMLmHu6IG3sakrc59/O2bxcHInms8IVgUBtYqaDndJjAXtecVTrFIjEMAXytYWLp4SxiPXtDswd/IZqNgPUmfFhVB0nUbs5Isex0CanlfYjUKh2Acw5Zl+9lcfeeTP63gGydZmFULuYUB58y1LhQTumSZnFDVr6kogb2Mx5pa+ikfvNhdsW215qb5k8AH5M+FVmGjIVYqxyUN9XZ2sK14KVUjTcsFgu/ryZMqxTKy1JctOsiqM5HZ7nkTwqb+/3cC3rf9LSuWGlG4b5TPQOJUT8rsm7tVigYFV54wRdcncbFa0zwOEqpLmkoSmwObS6UOVI5KbNhtVHcL30hQ2jZhAMycIgtow8YmnmIOT4b7dE
 +YoQURRl
 OmFvMhkg9XGvEaFaVWqTkOCJwugN733DCK3ApWAUDLHHj6COPHKBsfFwzLHjnbavnqOBd7RE4hRFPB1l5dgIiVVOwD4DEzIkWlLsQYbNID097Bb9CeSRM/9thL0bq+tlUspKzb3ZKieRSVnwVG6OYQ18CHPMxsmjnIoU1hXcS2zWGT4+w+ydSiTGImg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai3@huawei.com>

Prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 mm/page_io.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index a2056a5ecb13..4f4cc9370573 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -313,8 +313,13 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 
 	rcu_read_lock();
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	bio_associate_blkg_from_css(bio, css);
+	if (!css || !css_tryget_online(css))
+		css = NULL;
 	rcu_read_unlock();
+
+	bio_associate_blkg_from_css(bio, css);
+	if (css)
+		css_put(css);
 }
 #else
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
-- 
2.39.2


