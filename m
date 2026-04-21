Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A54EF5A8D1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 02:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5EC6B0088; Mon, 20 Apr 2026 22:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9870B6B0089; Mon, 20 Apr 2026 22:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C286B008A; Mon, 20 Apr 2026 22:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 758506B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 22:11:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F318D160C21
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:11:37 +0000 (UTC)
X-FDA: 84680936634.19.CA61B06
Received: from mailgw2.hygon.cn (unknown [101.204.27.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6F9A2C000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:11:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776737496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GD6D6UP2JUVrIr8EF3zQGbO4YkzrUi9QUe7IsXPZTSY=;
	b=Nr97ZYZeqqt8+9cQZeDi7cU0blGgKmKyhmxSLk5Atj2y1E30jvSy/98PSB+tn8nP6BVYCI
	Il1lFU6ML6Gj9V+LMxI4xn8yc3hSHXlUT3AumvC0Zy2cj6GZfXsQ9LFWd6oyefB6a3LVCJ
	2tKsqb+1wGtlfsRAiu4/IyQIoQYxOjA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of liuyibin@hygon.cn designates 101.204.27.37 as permitted sender) smtp.mailfrom=liuyibin@hygon.cn;
	dmarc=pass (policy=none) header.from=hygon.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776737496; a=rsa-sha256;
	cv=none;
	b=TAxw7vxpAXTHFZC6iZIdrtlWcdzMAoUeMlkXtk+hk66wVGUY7PGCyfUIGdnpStpQcc9/z2
	12ygcfUJXtnQP8Oyzo/P/rPfHtFwMM5nJCyPdSGqy/e0bq2oGpAywzu5sDyRx45GCwHlep
	gYFTWpRSdYqu5JCWY2M8JCApCvUEBw8=
Received: from maildlp1.hygon.cn (unknown [127.0.0.1])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g05SY10zgz1YQpmD;
	Tue, 21 Apr 2026 10:11:25 +0800 (CST)
Received: from maildlp1.hygon.cn (unknown [172.23.18.60])
	by mailgw2.hygon.cn (Postfix) with ESMTP id 4g05SV5qYMz1YQpmD;
	Tue, 21 Apr 2026 10:11:22 +0800 (CST)
Received: from cncheex04.Hygon.cn (unknown [172.23.18.114])
	by maildlp1.hygon.cn (Postfix) with ESMTPS id 02B014B4C;
	Tue, 21 Apr 2026 10:11:18 +0800 (CST)
Received: from jianyong.hygon.cn (172.19.20.52) by cncheex04.Hygon.cn
 (172.23.18.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Tue, 21 Apr
 2026 10:11:13 +0800
From: Yibin Liu <liuyibin@hygon.cn>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <Liam.Howlett@oracle.com>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <mjguzik@gmail.com>,
	<wujianyong@hygon.cn>, <huangsj@hygon.cn>, <zhongyuan@hygon.cn>
Subject: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap sharing
Date: Tue, 21 Apr 2026 10:09:32 +0800
Message-ID: <20260421020932.3212532-1-liuyibin@hygon.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.20.52]
X-ClientProxiedBy: cncheex06.Hygon.cn (172.23.18.116) To cncheex04.Hygon.cn
 (172.23.18.114)
X-Stat-Signature: bpae81fnzysnmjuh8m8src1amydad5ex
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F9A2C000E
X-HE-Tag: 1776737493-843570
X-HE-Meta: U2FsdGVkX19bNqs117w/qdJfMoYN5I8/DPuhogKVIhG3a4ldvKO37EBSE6JnJxdzfghKDVmJo2Dpfbpaz7sgT8l4Iybbeaz4dV0n1phE/fO/KJYHGIL2ZxcztbVuztqSw7gZsnMBzw8kGmEpuBSfKRdzmgNKIXTzuYTk8bNEeydCOhTBTsxjEJYGSJExcKeKQZIDKyHI8mR/fTH3G51gSGr+mRrmmtoM+dKSQS4XOMHQk4zMZO1R8dt0qOMkD2gUJomvHmuyl9CPH08VNMmsSddQdJB882b0PeK/3SdBNSu6c5gQ8HM4wszShTfp5fifF+ZoxRbn1Wb2kM87HYAd/MruldxRN3jVObDYafNyMtML/wO2xBToqLDTCQMQk4LDMWQsgmXY9KDpcMpAdSkLlfm2fsNduKrb5m8oTgRf73Qt6kLFEm5c1pgNuZxuO6RFTd9mKYlmS72roX16PLN7IGn00NwlZZ7hoWdXLVGPLFLhaSjD4iL3O7bsQKUEfledStOny77orr7vtdRmTxuIonLJkr2W0cswvbpXQHG1EjzacmMaIcj2fTwwE7EgGtrvbHsu3Q7thAkfPLbfi59RwGiJREHoW9KywIaTACM28wUqtQ3M8Cw4PhZgraikjU/v+fUhLlemKwsK9D8Nl+eXrTjQlD49XkWXvH3RWRTr4aBHz6nRBKYHKT28naLmAVD0yHdd6PZaM88T3aqiFUM/o8hBJKKqJ/uCbbde55bpdpDhFVQ0D5dZgcxHDNVMWuYbk/83a5iDejR8c4DOD/E7muabOhCouBV4Vls7MW6jc5FtJTTfc+iUsZw9OWECBKVWszcKkXXempLht/dLbm14VaL+MDctT8XBSRfz3WP1avxPoIxYdUZYxSzwl8Lx8l3eLQy37gvYw7CxMq+xhUYQaKLtmnWbxhhFSdEa+ApWXfHD+ZKP/GOm5YHxLF1jU+bI1F5dmSQVNxJ3oBGJ4mX
 eVWWWhvY
 wXZeixOe+whKVplk8jhb7QDlxharfIGO8R0GFE68pdgt9zvsdLOmXkoG2T8o87jb3Z26BNJdjaW/ewENkrxcVHx5UDoIUvuzVdsNIdpj94ZRnA8JuN8o7RoxJWzoFQdOJw6hgRqzjYZYknonad2xU5gFM6b1P1NfLqOdwPcv/n628kxfkmj+tFBgsp3Y4GAEC6o0UBCA8uzTcFFxVp4qByCvccV85ZIZfWkvu7EWBll3ivdWjThj4Gpl9MPHFyT4oVrPvqNkeCHjZw8dG50N/vesIQsiYbI+8kfA8BRd3SRWc0kmO4bCsjVa09REGLz2PtYVwTfRgp3Ad+dRqb5t6qT8gjBhZ+NXOYVvSgMF1t9vRvqkuS+Za2YgxaGBNLRbptsRoqB+9DqSDppbOogpvbUCWFPr9GKiMEyVeoUBAtHAANESbzFyZ0KYth5O2t3560bq5D4lF3NDXBRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UnixBench execl/shellscript (dynamically linked binaries) at 64+ cores are
bottlenecked on the i_mmap_rwsem semaphore due to heavy vma insert/remove
operations on the i_mmap tree, where libc.so.6 is the most frequent,
followed by ld-linux-x86-64.so.2 and the test executable itself.

This patch marks such files to skip rmap operations, avoiding frequent
interval tree insert/remove that cause i_mmap_rwsem lock contention.
The downside is these files can no longer be reclaimed (along with compact
and ksm), but since they are small and resident anyway, it's acceptable.
When all mapping processes exit, files can still be reclaimed normally.

Performance testing shows ~80% improvement in UnixBench execl/shellscript
scores on Hygon 7490, AMD zen4 9754 and Intel emerald rapids platform.

Signed-off-by: Yibin Liu <liuyibin@hygon.cn>
---
 fs/fcntl.c                 | 1 +
 fs/open.c                  | 6 ++++++
 include/linux/fs.h         | 3 +++
 include/uapi/linux/fcntl.h | 1 +
 mm/mmap.c                  | 3 ++-
 mm/vma.c                   | 8 +++++---
 6 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index beab8080badf..9b7cc1544735 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -349,6 +349,7 @@ static bool rw_hint_valid(u64 hint)
 	case RWH_WRITE_LIFE_MEDIUM:
 	case RWH_WRITE_LIFE_LONG:
 	case RWH_WRITE_LIFE_EXTREME:
+	case RWH_RMAP_EXCLUDE:
 		return true;
 	default:
 		return false;
diff --git a/fs/open.c b/fs/open.c
index 681d405bc61e..643ab7c6b461 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -46,6 +46,10 @@ int do_truncate(struct mnt_idmap *idmap, struct dentry *dentry,
 	if (length < 0)
 		return -EINVAL;
 
+	/* Prevent truncate on files marked as RMAP_EXCLUDE (e.g., libc, ld.so) */
+	if (filp && (filp->f_mode & FMODE_RMAP_EXCLUDE))
+		return -EPERM;
+
 	newattrs.ia_size = length;
 	newattrs.ia_valid = ATTR_SIZE | time_attrs;
 	if (filp) {
@@ -892,6 +896,8 @@ static int do_dentry_open(struct file *f,
 	path_get(&f->f_path);
 	f->f_inode = inode;
 	f->f_mapping = inode->i_mapping;
+	if (inode->i_write_hint == RWH_RMAP_EXCLUDE)
+		f->f_mode |= FMODE_RMAP_EXCLUDE;
 	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
 	f->f_sb_err = file_sample_sb_err(f);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..d5c9e5a4c2b9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -189,6 +189,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT		((__force fmode_t)(1 << 29))
 
+/* File should exclude vma from rmap interval tree */
+#define FMODE_RMAP_EXCLUDE	((__force fmode_t)(1 << 30))
+
 /*
  * The two FMODE_NONOTIFY* define which fsnotify events should not be generated
  * for an open file. These are the possible values of
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index aadfbf6e0cb3..4969b4762071 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -72,6 +72,7 @@
 #define RWH_WRITE_LIFE_MEDIUM	3
 #define RWH_WRITE_LIFE_LONG	4
 #define RWH_WRITE_LIFE_EXTREME	5
+#define RWH_RMAP_EXCLUDE	6
 
 /*
  * The originally introduced spelling is remained from the first
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..3eb00997e86a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1830,7 +1830,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
-			vma_interval_tree_insert_after(tmp, mpnt,
+			if (!(file->f_mode & FMODE_RMAP_EXCLUDE))
+				vma_interval_tree_insert_after(tmp, mpnt,
 					&mapping->i_mmap);
 			flush_dcache_mmap_unlock(mapping);
 			i_mmap_unlock_write(mapping);
diff --git a/mm/vma.c b/mm/vma.c
index 377321b48734..f1e36e6a8702 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -234,7 +234,8 @@ static void __vma_link_file(struct vm_area_struct *vma,
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
-	vma_interval_tree_insert(vma, &mapping->i_mmap);
+	if (!(vma->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
+		vma_interval_tree_insert(vma, &mapping->i_mmap);
 	flush_dcache_mmap_unlock(mapping);
 }
 
@@ -339,10 +340,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
 			 struct mm_struct *mm)
 {
 	if (vp->file) {
-		if (vp->adj_next)
+		if (vp->adj_next && !(vp->adj_next->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
 			vma_interval_tree_insert(vp->adj_next,
 						 &vp->mapping->i_mmap);
-		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
+		if (!(vp->vma->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
+			vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
 		flush_dcache_mmap_unlock(vp->mapping);
 	}
 
-- 
2.34.1



