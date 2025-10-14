Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F998CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECDE78E0100; Tue, 14 Oct 2025 08:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7E208E000D; Tue, 14 Oct 2025 08:11:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBB878E0100; Tue, 14 Oct 2025 08:11:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC55C8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:11:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A23E4BBE7B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:37 +0000 (UTC)
X-FDA: 83996605434.29.5223D7D
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18BF1140012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="J74RUQm/";
	spf=pass (imf23.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UgwlhGGtcRLvWvYU6JEi+YKutAgTxvOhKedb6kBv8k=;
	b=7la40XUJ42KpPYZ8iJc9PTBrqLWlmf6FYNjSbC5hunlCXyOCI5vEUKfVi8KV0M+rPwrU9z
	/aRLHu/u0uXCJYgwq+iZYuNYGZgcIYcO3Yg61iF+WA9gdMg4lXh7EY/IISes6+UErpgKsa
	LZr/BiimoOm1G1VFziXVVaf7SxetOFo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="J74RUQm/";
	spf=pass (imf23.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443895; a=rsa-sha256;
	cv=none;
	b=7aWtAJbJc9u8wt9Pc+kVlNh9oCFHLlbAPw7nCZgD4d2jnKRHvlQk5FNcOGcGFwVdTV6oDj
	1yyDJGiFmWJwGBFSphm6EazNRJf0QNQMcr/B04d0O+C7RK0dfZayvZpR89eUolSH6vrX/1
	kmrAu8CV2n4x61oxB4Ara9lOvyv7vSw=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251014121132epoutp019af93e124cd4c08694528daf963ec0de~uWmS4sIoZ1141711417epoutp01i
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:11:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251014121132epoutp019af93e124cd4c08694528daf963ec0de~uWmS4sIoZ1141711417epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443893;
	bh=0UgwlhGGtcRLvWvYU6JEi+YKutAgTxvOhKedb6kBv8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J74RUQm/+0gajJpvT9wdHpjxTNea007wFXgioeHyvKcAzalI8477xRXdhy9DrQp3N
	 KVmGwJM89Z6Y1lew8LW1B/ffXGlo05cKSLIVjO4UL48tklXtYCQUMEolfUF0T8rp/F
	 tWMlKsun1y/gV6dImsbWcHRczI09A4Ouu8mVEpqY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251014121132epcas5p3ea7317af9d533ca5d1036dabc2db7b84~uWmSZouOO1223112231epcas5p37;
	Tue, 14 Oct 2025 12:11:32 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cmCkC3dbxz3hhT4; Tue, 14 Oct
	2025 12:11:31 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20251014121130epcas5p3b76f1a7ab53a57403275e9ba5d3549a3~uWmRAVzc30753207532epcas5p3U;
	Tue, 14 Oct 2025 12:11:30 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014121126epsmtip16a3d513bf9db4889a24bd46fa8cec6f3~uWmNIg9Sd1309013090epsmtip1j;
	Tue, 14 Oct 2025 12:11:26 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 15/16] writeback: added support to change the number of
 writebacks using a sysfs attribute
Date: Tue, 14 Oct 2025 17:38:44 +0530
Message-Id: <20251014120845.2361-16-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014121130epcas5p3b76f1a7ab53a57403275e9ba5d3549a3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014121130epcas5p3b76f1a7ab53a57403275e9ba5d3549a3
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
	<CGME20251014121130epcas5p3b76f1a7ab53a57403275e9ba5d3549a3@epcas5p3.samsung.com>
X-Stat-Signature: gj557uz4nc7qextdfdjh4pspsfrqqqxq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18BF1140012
X-HE-Tag: 1760443894-697305
X-HE-Meta: U2FsdGVkX193m0XwEZZ/JwOciOJdT4Xq7NeoCrIWI7O5QnYIPQ276hdsQ++qUN4LTqMQCSXAEmdp7oySBHOBk9q2XVatMe5RwB8ekQ4PaDHGo9mwDbClEyYn64EExT6oQ3E+1HLGsrayPer/zDK5SOztctkKvauFZZsr4WQBp0vWuhvdC0xd1rP8mltVv9xI0FYxt1hBnXJ/BjToKe17rqV9a62oatSO+cXJCsiRu+V4waEabp1nmu3GhBsKR2FbJDjkZhmW7ydUULzRnhkXAJn6ddf9LfdqVTdFGzryh4cUWcsiT6SPRbK+PoSkHFvHSkwDTRUYxUIus2ZSh9kvhPRX58rChOmzJsmuzWLj/9JoqL3tI1u+6VtThprOcqXSmtvNH+8UKxe9/rstBygzIqTXlm2OexUh2ay9fnD7rjplVaSMZsDUczL4A3eQf00j2w0na3BFQDAF2j/2MJeAWuDLwY+LsIVE4Zb5Y82xudIFIDtFoor1Ffc9WVdRKTCUNaE0VwujnTbkf4ver1uZRnnhHOsBxPP1FRKFdMy25IbcIkM7cBkhSNwgKa3EmHYG0oaH48M4LrpxtlzvTJB8nLJYBdxc0Ri3J/aurApwEP6iFVXl91cxhhaJ98EPEpLgyA2VCdp64QKB1gSXu9VegH/AuxxIxv0cW3Hi0VxY4QHzxWq9SX4mHhhc68X1kP3w9o0WFgZp+7GdtFmTuOwBXvi5Pg54nLhEy9Nm0oIuDg4tq0GrNyGSIj0fdNi2PaT95r1EKShu/yWvbjvbBOGmA+s0aeCf4OlwJCiypAmi9V2/UvZTHU4X0aGGee1y4Yc7pzlf42fqPAW3gD5YF8a/DypqGS8x7gLgv/NqHNpJmyX4P1xhQkQVQEEsC/1mgSuFts8mY3uUxC/zNIH28AKetY1GmIm/9Skgj+QnuovTnRZ2n5PrJCzxCctz3yHeW8nvurAkg2uJJWHSIHuILLo
 kcOnoBbN
 XP9BMpN/C62enPAabBV3fz6y8ro7dGHzSIO0w83uWc5Z62UURIKAI5AiqZMQ8PnwNwv+xpTJdofg6RC2ykO1qg0gVW7IOA11ah+K56omEhgVwbJFaVdRVvS7zKkEZSYmlJShC+zK3MErcX7JAv05hlu68S5+ScW1LCbKNKTL6NqmNiGeTii5O6rZz4ikLuEou5Q7S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

User can change the number of writeback contexts with values 1 to num
cpus using the new sysfs attribute

echo <num_writbacks> > /sys/class/bdi/<maj>:<min>/nwritebacks

The sequence of operations when number of writebacks is changed :
  - fetch the superblock for a bdi
  - freezes the filesystem
  - iterate through inodes of the superblock and flush the pages
  - shutdown and free the writeback threads
  - allocate and register the wb threads
  - thaw the filesystem

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/super.c                  | 23 +++++++++
 include/linux/backing-dev.h |  1 +
 include/linux/fs.h          |  1 +
 mm/backing-dev.c            | 93 +++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |  8 ++++
 5 files changed, 126 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 7f876f32343a..19ae05880888 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2072,6 +2072,29 @@ static inline bool may_unfreeze(struct super_block *sb, enum freeze_holder who,
 	return false;
 }
 
+struct super_block *freeze_bdi_super(struct backing_dev_info *bdi)
+{
+	struct super_block *sb_iter;
+	struct super_block *sb = NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb_iter, &super_blocks, s_list) {
+		if (sb_iter->s_bdi == bdi) {
+			sb = sb_iter;
+			break;
+		}
+	}
+	spin_unlock(&sb_lock);
+
+	if (sb) {
+		atomic_inc(&sb->s_active);
+		freeze_super(sb, FREEZE_HOLDER_KERNEL, NULL);
+	}
+
+	return sb;
+}
+EXPORT_SYMBOL(freeze_bdi_super);
+
 /**
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index fb042e593c16..14f53183b8d1 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -144,6 +144,7 @@ int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ra
 int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes);
 int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
+int bdi_set_nwritebacks(struct backing_dev_info *bdi, unsigned int nwritebacks);
 
 /*
  * Flags in backing_dev_info::capability
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5199b0d49fa5..c7ed1c0b79f9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2770,6 +2770,7 @@ extern int unregister_filesystem(struct file_system_type *);
 extern int vfs_statfs(const struct path *, struct kstatfs *);
 extern int user_statfs(const char __user *, struct kstatfs *);
 extern int fd_statfs(int, struct kstatfs *);
+struct super_block *freeze_bdi_super(struct backing_dev_info *bdi);
 int freeze_super(struct super_block *super, enum freeze_holder who,
 		 const void *freeze_owner);
 int thaw_super(struct super_block *super, enum freeze_holder who,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 2a8f3b683b2d..5bfb9bf3ce52 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -35,6 +35,17 @@ LIST_HEAD(bdi_list);
 /* bdi_wq serves all asynchronous writeback tasks */
 struct workqueue_struct *bdi_wq;
 
+static int cgwb_bdi_init(struct backing_dev_info *bdi);
+static void cgwb_bdi_register(struct backing_dev_info *bdi,
+			      struct bdi_writeback_ctx *bdi_wb_ctx);
+static void cgwb_bdi_unregister(struct backing_dev_info *bdi,
+				struct bdi_writeback_ctx *bdi_wb_ctx);
+static void wb_shutdown(struct bdi_writeback *wb);
+static void wb_exit(struct bdi_writeback *wb);
+static struct bdi_writeback_ctx **wb_ctx_alloc(struct backing_dev_info *bdi,
+					       int num_ctxs);
+static void wb_ctx_free(struct backing_dev_info *bdi);
+
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -469,6 +480,87 @@ static ssize_t strict_limit_show(struct device *dev,
 }
 static DEVICE_ATTR_RW(strict_limit);
 
+static ssize_t nwritebacks_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int nwritebacks;
+	ssize_t ret;
+	struct super_block *sb = NULL;
+	struct bdi_writeback_ctx **wb_ctx;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+	struct inode *inode;
+
+	ret = kstrtouint(buf, 10, &nwritebacks);
+	if (ret < 0)
+		return ret;
+
+	if (nwritebacks < 1 || nwritebacks > num_online_cpus())
+		return -EINVAL;
+
+	if (nwritebacks == bdi->nr_wb_ctx)
+		return count;
+
+	wb_ctx = wb_ctx_alloc(bdi, nwritebacks);
+	if (!wb_ctx)
+		return -ENOMEM;
+
+	sb = freeze_bdi_super(bdi);
+	if (!sb)
+		return -EBUSY;
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		filemap_write_and_wait(inode->i_mapping);
+		truncate_inode_pages_final(inode->i_mapping);
+#ifdef CONFIG_CGROUP_WRITEBACK
+		if (inode->i_wb) {
+			WARN_ON_ONCE(!(inode->i_state & I_CLEAR));
+			wb_put(inode->i_wb);
+			inode->i_wb = NULL;
+		}
+#endif
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb_shutdown(&bdi_wb_ctx->wb);
+		cgwb_bdi_unregister(bdi, bdi_wb_ctx);
+	}
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		WARN_ON_ONCE(test_bit(WB_registered, &bdi_wb_ctx->wb.state));
+		wb_exit(&bdi_wb_ctx->wb);
+		kfree(bdi_wb_ctx);
+	}
+	kfree(bdi->wb_ctx);
+
+	ret = bdi_set_nwritebacks(bdi, nwritebacks);
+
+	bdi->wb_ctx = wb_ctx;
+
+	cgwb_bdi_init(bdi);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		cgwb_bdi_register(bdi, bdi_wb_ctx);
+		set_bit(WB_registered, &bdi_wb_ctx->wb.state);
+	}
+
+	thaw_super(sb, FREEZE_HOLDER_KERNEL, NULL);
+	deactivate_super(sb);
+
+	return ret;
+}
+
+static ssize_t nwritebacks_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", bdi->nr_wb_ctx);
+}
+static DEVICE_ATTR_RW(nwritebacks);
+
 static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
@@ -479,6 +571,7 @@ static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_max_bytes.attr,
 	&dev_attr_stable_pages_required.attr,
 	&dev_attr_strict_limit.attr,
+	&dev_attr_nwritebacks.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(bdi_dev);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 6f283a777da6..1a43022affdd 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -818,6 +818,14 @@ int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit
 	return 0;
 }
 
+int bdi_set_nwritebacks(struct backing_dev_info *bdi, unsigned int nwritebacks)
+{
+	spin_lock_bh(&bdi_lock);
+	bdi->nr_wb_ctx = nwritebacks;
+	spin_unlock_bh(&bdi_lock);
+	return 0;
+}
+
 static unsigned long dirty_freerun_ceiling(unsigned long thresh,
 					   unsigned long bg_thresh)
 {
-- 
2.25.1


