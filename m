Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E87BCCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5AE8E0124; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20FC18E0121; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A778E0127; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8F488E0121
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4794816107F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.23.ADA91FE
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0502010000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0vMwavuoVfuWFbN263bzf9ZlTRLN5G46LALqIXwR4g4=;
	b=44fXarKIsUneQX35dVzbl60vzAbxDYkPvyWlEjhPF+5mstz6pxWvNRqeSwPEsEgfalP/Jd
	Fx782nUavbYVG5GF5z+Q+PfkyPdbhNNulSywJat0Ju+cXEtAapG7sT8XnElmeMwA4eCjlo
	R6LCuoElm6Oqms9Uk8xtSrQHGTtqCB4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=g2teMBBKBtQbZB7Q3HT2yJIQPnG60+J4X/OlUW4uxCXtRICHNKwjvY5qZ602bDOWweYYhv
	ZGfMOQz/HiVznqaRZsh5YdvuE5QW61v05YDUu2AJUdqfrYJvS36bAV4lHp/BHfDmbvpGuU
	Meuhq7ar7rR9JAa8gw4xpoI3szOsXOA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcJ5pFYzYQtlQ
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 741791A1444
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S5;
	Sat, 25 Oct 2025 11:30:03 +0800 (CST)
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
Subject: [PATCH 01/25] ext4: remove page offset calculation in ext4_block_zero_page_range()
Date: Sat, 25 Oct 2025 11:21:57 +0800
Message-Id: <20251025032221.2905818-2-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S5
X-Coremail-Antispam: 1UD129KBjvdXoWrZFW5uw1fAr1rZr1UZF1UJrb_yoWkJFc_A3
	yv9w48Ww1rJrnak3W5A3yYqFyvk3W8Crn8uFn8tryrXFWrZFs5X3WkKryY9rs8WF47urs8
	A34kXF45KrnF9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbP8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGwA2048vs2IY02
	0Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0x
	kIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC2
	0s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI
	0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE
	14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20x
	vaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8
	JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjIztUUUUUU==
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6AABsH
X-Rspamd-Server: rspam01
X-Stat-Signature: nberq7c1utehby9b1erk1pgmrieut3nh
X-Rspam-User: 
X-Rspamd-Queue-Id: 0502010000A
X-HE-Tag: 1761363007-40051
X-HE-Meta: U2FsdGVkX19h9KoFoQCZvGR9N6fSpRKO8Di04B1zHiBS5JhAYDz/6RIVW7fXJ3vRguTwHZBbEp9Am2xgkAExeyuAUlnDubXEv8vR+TmA2TJUJ+vsT2bfDQhXcEiS+AltgA38K/eseqrmoCVHw7JHPayynfR3R0/hYUxQj8IJ/JCD2dLCHfYaAavXrLh65lzYS0Z8kdHgtUzzSwJWe3gFXW1XGnshx8VKdamLzy86VQZ2rDKY6e87QOLLASNHS8InK0iBHDoMuMlxDGcLOPPxFBY6N0dRjzcevWfFcpnT093x0C8u2tOiUI4E/hK4VRxQ6ZJG19Y3ZD2skI4go4rMR6+5dM+j/CwtbLhd2Bzz+I8MKw2zQR4NQtT66e4nxazMU4daK80PYvqqJBQc3n/STL/wNafkMdNPfpKRLJVFp1mh5PmW8mudhJDl995pmLnofIm99YMDU+X2J7CtoydnydJ0j16T9hNA9Vqz7BbCGf0S2j4XETkje1bPtAsk1lrPNQF0AC9YPBpUFaLkrtvEXPN/PVdNxMtwQGKNZzMc9JswGRZ2jqeNMBb8fIfpcr7QlKV36zYcO4DVUWajuQEjFfHk2iBCB6IRE5tnMei3jr3IGwBynOzJU1Ny9sFNsf96gHX2OwUZt/opEYtJEZh9aA1tokh+VkTqeWHmbJ2dHZlfeVNRcooyKdQLfGOfVOsa2BHaN21b3Fl1j3/EBh8JHoAlkDkV3cnnwZdtHhZS5bwwul+gkCWSXRSqC/rzl2a+Ny3VH7K+tpjO7RSgo2JhSWEMqzn8zFIoQ1gmDNykKK6mzHkjVZhlmkJLq4vLnFHOvfkTFimXtfwFPlEFsXjuH5ZviciRXP7EaVkfAsJOXUSNhyvmPX+u4Wf+3NRedGOnOFR53E8eWNrHwhtJ1ZWmFUsBF3apkPeT1IzyUeKVOy1P+4bcOKejXpyvsj2rvWenhPeVNcmjbgGpISeGMhM
 Ls2jDWI6
 fxkgUGsFeHxPdQSDl/GbJNzQmxpozD5Uoarh55MEeeG7SKpfxXrs+fF4HCJQeU0i0Vd29XVuo8mpW5HS5dC6+pNEzFenERdj+sVd1FkNW68DaE/MQlWrbEJVtYxvWwvt4WlkS5sV1ze3zo1bxhPUY4FkOrJ67bS1CPIlFMqXcVcwKzLYG2e05uThYrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhihao Cheng <chengzhihao1@huawei.com>

For bs <= ps scenarios, calculating the offset within the block is
sufficient. For bs > ps, an initial page offset calculation can lead to
incorrect behavior. Thus this redundant calculation has been removed.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e99306a8f47c..0742039c53a7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4157,9 +4157,8 @@ static int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length)
 {
 	struct inode *inode = mapping->host;
-	unsigned offset = from & (PAGE_SIZE-1);
 	unsigned blocksize = inode->i_sb->s_blocksize;
-	unsigned max = blocksize - (offset & (blocksize - 1));
+	unsigned int max = blocksize - (from & (blocksize - 1));
 
 	/*
 	 * correct length if it does not fall between
-- 
2.46.1


