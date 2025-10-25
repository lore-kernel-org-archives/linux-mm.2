Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41617CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC37F8E0134; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9D18E0137; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1468E0134; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1252F8E0134
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E244E12A66A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:17 +0000 (UTC)
X-FDA: 84035208474.16.769927A
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C8801C0007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77/GIJ8gz89rvwRniZIdgmFqN8QOcgercw80UQjHhRc=;
	b=fhAUf35r7R1u169JXYy8KNmPcVG7TdDky2+UIoOmbIlZAbkfq+uVZMPjtHA+LceeEwCpsJ
	ULttFlC+4lwpe4Cz67EHsq+zlJmv9wE5vPUwG+JGKrSlAk84+3qDQHAOqLtfbnqLE2qms9
	oqnMTgVzTeDO6ykSNo3uCiZfuMOW9No=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363016; a=rsa-sha256;
	cv=none;
	b=GDtctFec+swKwAdxo4k0Yn0pkYS3d6P1i+TdkE3KNs/GbW4gBAAHxfkPsc/rPWCmy3glR0
	CCmmWGdDvRmZ+LDbwKSqeAhLrfTp2Z8YYt23PUr2rnQyN+Y3jp3pvNBdW2mTBQWH0N22Ko
	CA5FuOhj1NdpoT6g7VhIWyUxapx5/+A=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL2l2jzYQtqP
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 0A7011A123B
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S26;
	Sat, 25 Oct 2025 11:30:04 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 22/25] fs/buffer: prevent WARN_ON in __alloc_pages_slowpath() when BS > PS
Date: Sat, 25 Oct 2025 11:22:18 +0800
Message-Id: <20251025032221.2905818-23-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S26
X-Coremail-Antispam: 1UD129KBjvJXoWxJrykCF4kCr4rKry7uryUZFb_yoW8uF15pF
	4rKanxtrWkKF429Fy3AanxtFy3Kas5JayUCFWxW3s3Z3WDGF9I9rnrC3WUZF1rtFyxAFy0
	qF45ArWUuF17trUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQa14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_
	Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8c
	xan2IY04v7M4kE6xkIj40Ew7xC0wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJIgAAsV
X-Stat-Signature: akmjp4byyxuf79o3zsir77uyk8tcst7g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8C8801C0007
X-HE-Tag: 1761363015-250577
X-HE-Meta: U2FsdGVkX1+6KSkg+wnnApmct7mHgW1tewNI4R26nbzwOeA2gOuJU/pRKwoF2euV8WqXRad2HkStCzdYDpeKX9xi2+VUGHAxUu5JuSdMx2lyo7lDKwRkAsL+wcSinn+ueMiHStEnAeds4WHES2k62TysLXaPTZqrnH0i1xsoLxOF9aiWkmM+IsHFnNdTXamIBte3v7otJZswn6oBfuzODbV0FBPTzWTc52dYI29ASjTbONrO46cETfbZidP36flV/dOprG5uoyWkTG6V6iyCsx7jxFvZg04MwUda4voZqqxiw2X1UoSVTUxVSoWNSl577evk1tay0dMwdGK50PLrOkwkVXdov8m3530LdMiSAmQdgWeBihRQm6qHYQGXaHhdAK6X7kFP6VfcC4k5F7tdlbzih46GQD5OMDnyQxlgIiABaIFddz41/jYlD8eSUkB4Nqm0+vBZbxxz8xMekkUiv5ILuS4hinfj00MP0jy0JdcZC3F86n4EImg+wwS+r0mGKwv+Ayqpd8UimHFuv/xGKdZflAoRJppcMBDTZSUq9ITZgbglCPzYkKWcW2u0rCdIK+fsE0napcvDkeBkOpErNnGb32ch0LU4O8koCJyh5IOmI58Q8ANU5pKvng0BmD0YlqtKukxD2qeNRAUVVufy+AkJcm/wJ5EkToEyAvL1fyX1q6tDSsgxCe1BFFszEQuJGX5Ez0XUqigvNMghjPhzyPmIASUbJjVNiF61yTelK5SLTEtBeIS2VQ255SvFoMca2g/pX4W6NlwY5F2LsUjDvK2dJ2Z2f9otXQKgdOwT9lCe7kvqBESUaFoI/40ktibxrFTFJ1ZObhosBqF+jDE+AnypoqgVoQneCmRtMsIp8wVJReE3MJrm/6SIjXzAiPlyrQYgJICokzxyiYdUHImgY0nvmDea1LJ9hkyOdOUNFt/vzHBWXtrTIft4Br4KigO0skQLK6hTw7zEeVDbcP4
 vkz9lOHX
 1xBO0eiIS2y4bvmSrthgZ4Jc5pB9kf3ASSrs8lxOGCpkdffrQnyNMgmPxrfatckAk1yy/zkP6oVyzKeBVs/4YhLtEmM+2xtqMaj4qHfd4JCE4beAAPTTZYa713AiYeDljrInT2SzbsVA6rD4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

In __alloc_pages_slowpath(), allocating page units greater than order-1
with the __GFP_NOFAIL flag may trigger an unexpected WARN_ON. To avoid
this, handle the case separately in grow_dev_folio(). This ensures that
buffer_head-based filesystems will not encounter the warning when using
__GFP_NOFAIL to read metadata after BS > PS support is enabled.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/buffer.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbed..2f5a7dd199b2 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1031,6 +1031,35 @@ static sector_t folio_init_buffers(struct folio *folio,
 	return end_block;
 }
 
+static struct folio *blkdev_get_folio(struct address_space *mapping,
+				      pgoff_t index, fgf_t fgp_flags, gfp_t gfp)
+{
+	struct folio *folio;
+	unsigned int min_order = mapping_min_folio_order(mapping);
+
+	/*
+	 * Allocating page units greater than order-1 with __GFP_NOFAIL in
+	 * __alloc_pages_slowpath() can trigger an unexpected WARN_ON.
+	 * Handle this case separately to suppress the warning.
+	 */
+	if (min_order <= 1)
+		return __filemap_get_folio(mapping, index, fgp_flags, gfp);
+
+	while (1) {
+		folio = __filemap_get_folio(mapping, index, fgp_flags,
+					    gfp & ~__GFP_NOFAIL);
+		if (!IS_ERR(folio) || !(gfp & __GFP_NOFAIL))
+			return folio;
+
+		if (PTR_ERR(folio) != -ENOMEM && PTR_ERR(folio) != -EAGAIN)
+			return folio;
+
+		memalloc_retry_wait(gfp);
+	}
+
+	return folio;
+}
+
 /*
  * Create the page-cache folio that contains the requested block.
  *
@@ -1047,8 +1076,8 @@ static bool grow_dev_folio(struct block_device *bdev, sector_t block,
 	struct buffer_head *bh;
 	sector_t end_block = 0;
 
-	folio = __filemap_get_folio(mapping, index,
-			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
+	folio = blkdev_get_folio(mapping, index,
+				 FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	if (IS_ERR(folio))
 		return false;
 
-- 
2.46.1


