Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBDC0CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093BF8E0112; Fri, 24 Oct 2025 23:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B5E8E0128; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D33E88E0127; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7A008E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51A91161080
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.17.B87C4F6
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2D191A000A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c0ilK0plMrCpdmg66HDjLBDWh0ln1mw6fpv+A79gE34=;
	b=KPMZPkHmZ6onHsvwTIanll9jaud9Oy1rIvL3lyPMtwtAxeT5CYqg2dGK7gi1oaMJmy+qvM
	jkGrrf1cuINYw/vB49jezMHnMGbCmd/Gq4PN1bQLGiQfc5Mvgk0etZAGViAAeEZvplVbT4
	51M90UUmY2tyleG/Qa65JBpjihuZk9o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=4Hq5eVhxBKj5MfdYvbmeq2r7jV58zjbzpHy6fuPtfRBetuPnzKWOFakC2V386GbJYR8SbV
	/vUlhjv7Mf1MRI8lPEbZ+d02rU6bi9Xa62cckb0vQfCjLVZ/gIiG87A2jq5e0X6iqHPZY2
	F1yq4K69jna+7lCn9BZoD7pAPyC7YGE=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcK2jFdzYQtml
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 077131A101B
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S12;
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
Subject: [PATCH 08/25] ext4: support large block size in ext4_readdir()
Date: Sat, 25 Oct 2025 11:22:04 +0800
Message-Id: <20251025032221.2905818-9-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S12
X-Coremail-Antispam: 1UD129KBjvJXoW7KF15KF1fWw1rZry8CrWktFb_yoW8Gr17pF
	Zaga18Kry09r40939rtFy7ZryY9a97GFWUWrW5A345W3s3X34Skr9xtF1jvF1UWw4xAa4r
	ZF12kFy3GF1UJrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I6gAGsC
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F2D191A000A
X-Stat-Signature: y6omatmn43ay1y88nz5zqk1gp66ct1so
X-Rspam-User: 
X-HE-Tag: 1761363007-419502
X-HE-Meta: U2FsdGVkX19Nq6G0wFi+ZH65pChfhr8hB0/jsPT6VpyctSCuSEmV5dY6R5m2g2wC6DKxRX+sDE99AyzEvTjs+d7/7TyM3swwFijPs4s0vtzMK5Nr0t4BwU0AAwX3qYp04MmCABqqdhUw8Mf6WkPtghXpRcTRnrfpXwX5hpumZI1oGlGvh7ZPYTP5eZw6BP5Qe4kZARKW32fvSCt9alQIM9cF5nSAOcs3hZS70QKYA9XZVWVdVNo/goYpdmLQBACHk/mxjp6gW6o3FYWv4XXWMo732mx6jc1HDBOgr/TnoYwkwzt2huiWWG6/kawJW6Am3WEy2fxX3U4pSrLs5jQ2ejRdeMkcHF06Ebwa3clbuxOZW9/8q022SvH+9f8lIZGBrdYwbObZJt/utUTbYYzUgOEwTvG21H4aHgJygW1FlNWobP9Fo2wL+R8uvxnLXiR3SqKheM4rrUaNZNMBTe9pd5OyKRCno8XFrVchJorxFu5Md87htOzrkSAj2bMMIqQCQwmDjkV28BeE1x39nRHBmjQtHwY6ubxql9zYcl9uRhLsPQRDbVlmxDhg/Rxg7zuS7jYzBIxoeTyg6beSb2P1K9eUSYtMjR/wOUsetijomCB1dVIh6bfx6nu+b6QxsOUmC35pIXfjwERMpd9KnAJZEF5S9eJjB2QLDNoNurmTSHXz4BvkjsCIEUS4pmuRXn0SvzOyUChIeQCcXhfGe8rQuJkFUVh4BykPmSX3d8dtmru9+R9rA+tAZ8IeciuyoSU87tuswywT43RzdIG5RrC+HdmFnU9Ru1ZGz9rR4aKaJlTb7Gana3ZWVRpe7zjdFIV2UqE8waH+59bcQKHGudjP/VY8QSET8WqzTd/BYskGEs6DdGbhQk1BmCdAgaZuN91AWjhaDVQysCCUD4lxmQlzcQ2jXESwfSaaLU0PLit0KLtoXf5ZDg5c3zdNKL8OPYt7HS7yLWGXGMy7pphVfgE
 vb8XmFNu
 4e18RsDVDlYp39XN/SvR4dprYTPN/JnQ/IenMfWkUJsh1GSHPyUSpqCcAhrvJyel58vsvMnyRC++CTXzwcT2gWfA4CxahtZCuGUI6iCisEjS1LhLXeEaDr3S98zO1UWg0NE8ReZTTCPZcRZ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

In ext4_readdir(), page_cache_sync_readahead() is used to readahead mapped
physical blocks. With LBS support, this can lead to a negative right shift.

To fix this, the page index is now calculated by first converting the
physical block number (pblk) to a file position (pos) before converting
it to a page index. Also, the correct number of pages to readahead is now
passed.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/dir.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index d4164c507a90..256fe2c1d4c1 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -192,13 +192,13 @@ static int ext4_readdir(struct file *file, struct dir_context *ctx)
 			continue;
 		}
 		if (err > 0) {
-			pgoff_t index = map.m_pblk >>
-					(PAGE_SHIFT - inode->i_blkbits);
+			pgoff_t index = map.m_pblk << inode->i_blkbits >>
+					PAGE_SHIFT;
 			if (!ra_has_index(&file->f_ra, index))
 				page_cache_sync_readahead(
 					sb->s_bdev->bd_mapping,
-					&file->f_ra, file,
-					index, 1);
+					&file->f_ra, file, index,
+					1 << EXT4_SB(sb)->s_min_folio_order);
 			file->f_ra.prev_pos = (loff_t)index << PAGE_SHIFT;
 			bh = ext4_bread(NULL, inode, map.m_lblk, 0);
 			if (IS_ERR(bh)) {
-- 
2.46.1


