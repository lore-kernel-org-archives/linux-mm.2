Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 328D1CCF9E0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1A68E0137; Fri, 24 Oct 2025 23:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D768E0135; Fri, 24 Oct 2025 23:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8049D8E0137; Fri, 24 Oct 2025 23:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 624068E0135
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3287714103A
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:21 +0000 (UTC)
X-FDA: 84035208642.20.CF4B8A0
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id C346040009
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KoOjg8RqNYuABOOIbBhtgDk7PcGyTXzNz+o4krkNRsU=;
	b=nCBsETZjpxpoii/Ynh70sE5vEmqkdwDHNsmJ1xEciE+mbey8QBAq2i0zCdvSi4KhcAI5x6
	iOKcwqDoe3Mo5kmYFynhzZ/RciqgZIAgEE0l8N8Gm8C9joI6kol2hPLCQkliyaqpUFUSnl
	AYgC6OpGdz84Ha2tirTUlyRVJWhjGZo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363019; a=rsa-sha256;
	cv=none;
	b=M8MJblo84GoTpErZ25QcdxrMtubc+uCjHFSQrcuZkyPjcjANELhOhXtZN98xGaWZhF6MPr
	fW/2llh+218MAhv6poGIlnZ/7aLd1mWUua0wAFQs7aN+FxyevIQW1jsBM6WMn+sAmAYu+G
	bcGZs+xaq75k1AUl8tQerO9BCzkLmaA=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcL4sq0zYQtqG
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 52EA81A0FF3
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S29;
	Sat, 25 Oct 2025 11:30:05 +0800 (CST)
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
Subject: [PATCH 25/25] ext4: enable block size larger than page size
Date: Sat, 25 Oct 2025 11:22:21 +0800
Message-Id: <20251025032221.2905818-26-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20251025032221.2905818-1-libaokun@huaweicloud.com>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S29
X-Coremail-Antispam: 1UD129KBjvJXoW7uFyxArW7Gr1DJF18Cr1UGFg_yoW8tw45pF
	WrCFy8Gr15W34v9an2ga1DZF18K3y0kFWUXa4Fgw1xZrZrJ340grn7tF15XFyjqrZ3ZryF
	qF18Ary7XwnxCFJanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I8QAAsf
X-Rspam-User: 
X-Rspamd-Queue-Id: C346040009
X-Rspamd-Server: rspam03
X-Stat-Signature: wp7635maseigixcuu5zb6jx19u7yxf5p
X-HE-Tag: 1761363018-987577
X-HE-Meta: U2FsdGVkX1+v7XS2SHCc/wD441GFNuNNUzwR3uUjl73S+5D/Bm8cHwVUKpQgJWq0cJGGbr/CnSkanqcnCO9mxEfuzwIczAbdE0TnMrd9RpyTFZcUQx7VG35mncNxYCcdfXxelZy5MHZHwTMlhowe8jExvydW0Qg+J54XpATI/Ppln0tN+IMOn7Nsf06wn8oP6sBZ+kE687J0OsTFQGH3XwJJRbNAF9Mm7ogvVP4kXsErbOuJIcMe0cds0yeSIARq89qYHCjaR56OLNP9PLaCLyoAg+rhYG684VakifaZpXffoLaP/lCiXhihkQV9JDDHx0f6lbPszNv3ANtqcCltKGyguWLtgWry7zAOpZbeKZe//nt+HyFGxQIztL2M4RbKut71MB5/CXH8GDQFZq9hP5qNETvzfz55MIW5x4qZ3KS9ujMy/jHZVJGGsYOPiDlWR4g7l4wF0gJ4G55F9qIMMf+hjpDmCHizrFJqb6NYP1lomKYjQOlvr50hlm4YBATHRcySQa07+DGgtWsKrqUeItrUVOZ+NdvMhIkkv2phCmOZiweLbXsjReaJ2Px9TzPeiQ31KBaRYHfqzSk2P6fjyyZF2MFBy9EWQG/zLlzLmQy/HGzfWH+48OMP3j2mV73JwqzLtGnfKfU8Gz3IpFbw74UhxfVUBktLdZc0bSucuFYdFof9t3UvPs2USjIsyIAzsI8IMWtb8ITowo/Kt2ziN3YU+G0WaKi9QwhoGHfVnlWztq5NBGZqkAV2Af6NCscmvJUsgVcb2+XFK3xJ8fB8oIs7D3YaiKof9MqhthFDCJ7s92k3021MBkOi9pGXtlgA9lGMF09HtxxaumDl/HK4Ppw8Je8yrr4ON5QZC/50MjVT4zOttpT5fw1Ca9j18dTgGHUGUPlu0arhf6LeJDQrvoJN3lUNOR04rs1JL03/dcZpug5x2dPzQacMoGdcLQgcb6HO5o89n4NXx3NoSqn
 t3Q3pQY6
 J/FnwTbICBKrf8Ezeu7PDbIZF6MeozHIJlXmb1wVkT2lyJsLnRFdjME5IzFom0gp17X2Fmx4Bcj1CbbnK6J0ao/6CnQT9a1aPAZxk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Since block device (See commit 3c20917120ce ("block/bdev: enable large
folio support for large logical block sizes")) and page cache (See commit
ab95d23bab220ef8 ("filemap: allocate mapping_min_order folios in the page
cache")) has the ability to have a minimum order when allocating folio,
and ext4 has supported large folio in commit 7ac67301e82f ("ext4: enable
large folio for regular file"), now add support for block_size > PAGE_SIZE
in ext4.

set_blocksize() -> bdev_validate_blocksize() already validates the block
size, so ext4_load_super() does not need to perform additional checks.

Here we only need to enable large folio by default when s_min_folio_order
is greater than 0 and add the FS_LBS bit to fs_flags.

In addition, mark this feature as experimental.

Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
---
 fs/ext4/inode.c | 3 +++
 fs/ext4/super.c | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 04f9380d4211..ba6cf05860ae 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5146,6 +5146,9 @@ static bool ext4_should_enable_large_folio(struct inode *inode)
 	if (!ext4_test_mount_flag(sb, EXT4_MF_LARGE_FOLIO))
 		return false;
 
+	if (EXT4_SB(sb)->s_min_folio_order)
+		return true;
+
 	if (!S_ISREG(inode->i_mode))
 		return false;
 	if (ext4_test_inode_flag(inode, EXT4_INODE_JOURNAL_DATA))
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index fdc006a973aa..4c0bd79bdf68 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5053,6 +5053,9 @@ static int ext4_check_large_folio(struct super_block *sb)
 		return -EINVAL;
 	}
 
+	if (sb->s_blocksize > PAGE_SIZE)
+		ext4_msg(sb, KERN_NOTICE, "EXPERIMENTAL bs(%lu) > ps(%lu) enabled.",
+			 sb->s_blocksize, PAGE_SIZE);
 	return 0;
 }
 
@@ -7432,7 +7435,8 @@ static struct file_system_type ext4_fs_type = {
 	.init_fs_context	= ext4_init_fs_context,
 	.parameters		= ext4_param_specs,
 	.kill_sb		= ext4_kill_sb,
-	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME,
+	.fs_flags		= FS_REQUIRES_DEV | FS_ALLOW_IDMAP | FS_MGTIME |
+				  FS_LBS,
 };
 MODULE_ALIAS_FS("ext4");
 
-- 
2.46.1


