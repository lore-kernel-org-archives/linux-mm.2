Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E112CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4AC8E0129; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6555F8E0126; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5926E8E0129; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0B98E0126
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17B9B161078
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.10.ECEB1AA
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id F2C99180007
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=klaEamwkpXOWnnwIXtexma71LN4lErYciZH9udsA21k=;
	b=t093f0+a512+OMgS5JHDavIOQbroMGfQQo4a23+dnmRVwlBvnTy0qmAFJKLAtT6wQbu6dJ
	aVdpKql4knSHzjmR07Pc8QCfd6+CHMJR2WYAXvmYxZ2nrfodw+i1VNmZ5+UkOJbOqCRU5K
	rTZrmc5a57V5DsRK2nExYGSxQidJHuE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=GrJO1BRAX5b7l2SJ2rPUuMFwf0chTW4X4JX3cMVIN5ZwLHhfgmpQjmUKLbrxY2oD1h1oG9
	dFd5aUROInnjekhuu84Hdjp3B8UhOSaMMU7UUWc2THx7ppBoVIwLrXC8XfWn4N2D8aXqK4
	dD92b5s+RLgbCdqtY8jEDNNXmkkG4cA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL1LpCzYQtpV
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id D14161A17F0
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S24;
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
Subject: [PATCH 20/25] ext4: support large block size in __ext4_block_zero_page_range()
Date: Sat, 25 Oct 2025 11:22:16 +0800
Message-Id: <20251025032221.2905818-21-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S24
X-Coremail-Antispam: 1UD129KBjvdXoW7XFWxtrW7Gw47Cw4fKF1kAFb_yoWfWFgEkF
	W8Xr4rJanaqFnaya95Aan0q3Z2k3WrCr13ury3Jry5uFyDXFZ5Gw1DtrWYkr4qgF47WrW5
	ArWkXFWYyF12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbmkFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lw4CEc2x0rVAKj4xxMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbG-e7UUUUU==
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJIAABsW
X-Rspam-User: 
X-Rspamd-Queue-Id: F2C99180007
X-Rspamd-Server: rspam02
X-Stat-Signature: gofgqkybnofa1s8bftz4uhff8sny7x6g
X-HE-Tag: 1761363013-82330
X-HE-Meta: U2FsdGVkX19Z4tyQHnh4QTzyrYbeOa77MJy4vNjMAfrjNLquCqKPnJ2Qw0dDElb/jwRJS5DxK3g80VuS5WS0KE8MpBXgEFSVw4zw6K3QcKdNVqOe7W4fgJ2TqkBnuwtzJ6WRyQE+LR3EUJLmg+LKGlo/EFG8ta3FhiJ4FgWta9upBK2VnXxsTcC1f/+LeCIlVC7HDJkajXbkMejlODnoMd6hneDUPYOqVdsk+gmAraG1hjGHxjm+kTanOJv8YyUqXPucL9IslN+waqxXHHfGn6b9IgjyTrQIMHosgl0aUIJ70auuBtHCwXtZfYyhOINN0bKyp5HSr0EpS5kPTGUgur/nZRow49Hx0nMzQHHI5pdTQNxK0s6+Q5fgfh0FFeXBm5bYi0YHOFmp0S4kSFU/vRqimVFOd1kXXlLvS7+5eVHYegmt5gatIOuQicsilkgyeTwKIiq0aRS6YuObTJ3Q0/XLpxwnr+8hJe7+k71buFQ4MbiMhibjqRRoWa2K27FBwzed5mQ5jr8BGN0JrLeegZHDwApln4HX+NEEEGURThjYHKVYbGcNYnJh64eRsl606BN5pekyVzQkUzViYDoRQCFk5icmX90wG87f4/XLEpdHWaTmCh1IR+ShK8j2Rr7GOIB765dg3o5Z/aTtx2eiblqgMY0a3xLDDlH2TU+Se8ZrZ9J6kCIdiYWHHoY1yKJyfUx51pLdl+cn4TN6gDKr+atu2f1/SHKImVLFrUq2/KAkAY0D0MQs0chEHtYewhWZJsA06+n0nxxJB1v+YqgnlbqyG2nNCwGkalt/NFzilwtN8osl9GxwWXtZpoWh1wrW1gpB+xZ/Y5fJIwHlnJFuixtfKKKRuGPzjLQdfqCbKgZYmmptSnbrY/DltwgDkayLlsvkzeO5SgyblmodAj9S6V6EHZLwkdDf+6Ic7BunG6J4Xesy21dC//2UnTE+zvjWRVqU2r9RfijFYe3odoE
 cDEs89jT
 aBDE5BlYEGUHx/7hCUek7OZuLCGYpCPfH/TCsh4GoIAjZ8UU919AZSpz6ssaa0+s7jJznyTFgdCnWwHSpgmPIEAHgHhjo1gAGbaBkiEPGa9N4++xoPj4uqf4NAIh8Rb8VlYhl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhihao Cheng <chengzhihao1@huawei.com>

Use the EXT4_P_TO_LBLK() macro to convert folio indexes to blocks to avoid
negative left shifts after supporting blocksize greater than PAGE_SIZE.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ce48cc6780a3..b3fa29923a1d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4066,7 +4066,7 @@ static int __ext4_block_zero_page_range(handle_t *handle,
 
 	blocksize = inode->i_sb->s_blocksize;
 
-	iblock = folio->index << (PAGE_SHIFT - inode->i_sb->s_blocksize_bits);
+	iblock = EXT4_P_TO_LBLK(inode, folio->index);
 
 	bh = folio_buffers(folio);
 	if (!bh)
-- 
2.46.1


