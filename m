Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6B8CCF9E3
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373348E012E; Fri, 24 Oct 2025 23:30:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323158E0130; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49E28E012C; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9489A8E012B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E66B89636
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:16 +0000 (UTC)
X-FDA: 84035208432.23.2A090B2
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id ED84316000F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jO+/Jf5G6vyv+qkTjOBhJdCQFuqZwRDug48JRmXr7zc=;
	b=iaYIV3ghVr0sPmHwX53o5E3USyRIr/umF4ox70Bj2DPitCCV81LCXG62ofqOZhCJu3xkQC
	fOPcf/Uqc2v2v3hzf2RLBSb6ziUAcdkGk2UBRHGsHffrzoqSuLzBi2b2Bz2Jir7TNRgc1H
	ZkBwxeOXZcEg8J1qQnFSEXgH7BPB8kg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363014; a=rsa-sha256;
	cv=none;
	b=o+IrVPdxutAarVHyVOVK1YzbZgfQBleJjjtVdds+vg4rEBKnXmH4M9mmA+utwexZoDVAzF
	OukVq8W6vSv4IU+m4pwwrjm+TTy2vfZy5F8Dl+oRIEYCWzJhxo8m7wNQa2scwIeyv4Jpbq
	X9IssL5ycbuqsnjY9DR/LzfdcFpAa5k=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL09XPzYQtpl
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id A55EE1A0EBD
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S21;
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
Subject: [PATCH 17/25] ext4: support large block size in ext4_block_write_begin()
Date: Sat, 25 Oct 2025 11:22:13 +0800
Message-Id: <20251025032221.2905818-18-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S21
X-Coremail-Antispam: 1UD129KBjvJXoW7ur4rJw4kWr43Jw1DCrW5Awb_yoW8Xryrpr
	y3KrZ7Gr4S9r4j93W7WF13Xr18Ka4DWF4UCFW3Zry3Xa48twnagr4kt3s5XF4jqayxZFyk
	ZFyrtryxW3W7ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	x2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x02
	67AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdsqAUUUUU=
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQAMBWj7UbRJHgAEst
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ED84316000F
X-Stat-Signature: r6zaqichxdkkkm9iw3f9h7ezq84oymnu
X-Rspam-User: 
X-HE-Tag: 1761363013-930719
X-HE-Meta: U2FsdGVkX19V6jWA4UBXNOutH3zMsHl0QzChPI0FZ97F1vcFpzn1tZOhxFw3+7sSD1Tf/zwDx8mN9OGNTW4LKcoMOrT71bAFjTzKwtreI0ftFz1/GHBSGjoiSyTyteL1+kgGDGvlYA8TL+cPZ17kklzrhajq0say9fF1tfZxFbPkVwPjvyLRNtcxg3FjmX1d12hnECH4O6gAx8KAHNH5TKMVlte8gkSfyj5zzA0+9MGtU+xi340bIqQ6agbym7TWpyDw3SIuqJFOdAdS08OXz1llsnmYQ3UCEhPnspd6zcDwobZeZ6w2ZUZPzmsvIGCuonyof1beVxesk4KtudGYVWjfcZ4M/K9atcgpER1V6WtZYGZrfT8SsHDcz5ozk6kzoO3AKlyLh8MP2hONNz3BrJdC8+gzvQgP1bvUAh5TNeazJFkymIJeBZvMjgMYeammMM084JAIFrMrhCT/0sLPmPF36huff3qBLe3V9pW1jvPg+zSAzQt7AyAvxMk2zQ9vAUeIm8jEUhIylN0bwCW4ZUjkWLucljSzD4k6Br9Yiq4sCoEfBwi1BeMup6Al/cXZjre3SC8Fb/TFI8LuvhrwijJSabaXxhpBU99rLv7AzMjcg2D6Xmqnb8RvSfp7mvo6UOsPc1kyGR8YxL6l2anf2dkzxCiBa20lBsyKp97eKZbNe3K8zI2pv0GTlExdZz6EDH4OQbvk5N6xKsqZFyyf5vTJRfrEGkiQk6yAYhC7gW/nIyofr97pdETbPacDYUxkyAxc5A8nmgid6YA0aLmEiFFqmQGJd8Bc9uuU/ymgJTfvQdET8h4nXLEQ0Qu3vvnUp1kl5FLDSn5+uZzyPF9dAmX3yZkdnL7DK0D0n6+U+4vEbqaEVG5cvxd6ypo6nCAl2KIWczWlnd8Uc711IxiVrNJlrlPhdPAGfoyF9+A+eTeP7r9iGg8EV9k5ErAlg/9b1WrNWTS1jV5unupDY0J
 caT4l6hL
 mdbggqA2eOxJCWCVBHnCavE0B04ea+iIW1HUAxS1RPiRwHFolGOW9fjKvvR0fNU0CDWWM/B2827Emu9kACwrjN2dLL7Hj0T0bQjSVOEiPxep+dM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Use the EXT4_P_TO_LBLK() macro to convert folio indexes to blocks to avoid
negative left shifts after supporting blocksize greater than PAGE_SIZE.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 73c1da90b604..d97ce88d6e0a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1162,8 +1162,7 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 	unsigned block_start, block_end;
 	sector_t block;
 	int err = 0;
-	unsigned blocksize = inode->i_sb->s_blocksize;
-	unsigned bbits;
+	unsigned int blocksize = i_blocksize(inode);
 	struct buffer_head *bh, *head, *wait[2];
 	int nr_wait = 0;
 	int i;
@@ -1172,12 +1171,12 @@ int ext4_block_write_begin(handle_t *handle, struct folio *folio,
 	BUG_ON(!folio_test_locked(folio));
 	BUG_ON(to > folio_size(folio));
 	BUG_ON(from > to);
+	WARN_ON_ONCE(blocksize > folio_size(folio));
 
 	head = folio_buffers(folio);
 	if (!head)
 		head = create_empty_buffers(folio, blocksize, 0);
-	bbits = ilog2(blocksize);
-	block = (sector_t)folio->index << (PAGE_SHIFT - bbits);
+	block = EXT4_P_TO_LBLK(inode, folio->index);
 
 	for (bh = head, block_start = 0; bh != head || !block_start;
 	    block++, block_start = block_end, bh = bh->b_this_page) {
-- 
2.46.1


