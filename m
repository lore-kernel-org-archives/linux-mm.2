Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCE4E1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282CD6B00FE; Fri, 20 Mar 2026 09:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230186B0103; Fri, 20 Mar 2026 09:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05E016B00FE; Fri, 20 Mar 2026 09:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1C1F6B0105
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC4D21B6E1D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:48 +0000 (UTC)
X-FDA: 84566559336.12.B0D399B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6D0CBA0009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B3H+34OR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8NMPmkdz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B3H+34OR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8NMPmkdz;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9N+7lwH2O29FCtDOcIXWRdMiWLy2V1231o6QfK0KGUE=;
	b=OWE++DFoMUqHK2OKlKe71acTHNQcIQq7/dUkj1Q0oN5qbD0Pu4vRDNSTPqYLqaHpJPy76U
	1oZ2mYDWupENrTD0ph/Y/6tI5smVWAcozDj81Fv+DFn5ZvbLDZI5SSYojRsUpL4VcU/zuL
	0VMCkB8H+uAf9BypmMUc0rB55iolDnI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B3H+34OR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8NMPmkdz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B3H+34OR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8NMPmkdz;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014226; a=rsa-sha256;
	cv=none;
	b=SNoK69P2tGfQenB+0uQQN7RVcJR1NartHYJVtJzi6boCm4OVMTlUsVAV0PMBXQImnvGkzW
	g1NE7ninZHU+KxovpgvGYWWy1rM1gysDjskV2WnHWLhwNChK/4AextpSuTTQJSNxHCwoLU
	agRfhbRmUxLnuDqJjSMJ2jsEKHtKTrs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD0994D42F;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9N+7lwH2O29FCtDOcIXWRdMiWLy2V1231o6QfK0KGUE=;
	b=B3H+34ORny/VVsDdq8Hr62tOD3TnB05ou7dq3kq7LNbLASIjTFCdRxBQNcu2Pa8RHshM+q
	TyvQP5xnk4t0aptuHnqnTCcO9no0olVm366n8MnzI6lGP+jJVAGfTzd+p09bjSCwKI3/5k
	m+N050d5p527ntCrlprIYFtsh9cjyTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9N+7lwH2O29FCtDOcIXWRdMiWLy2V1231o6QfK0KGUE=;
	b=8NMPmkdz0WLinFHfZNQJiWxpyJdx2WXgfJRzXVkTTx+49ftxttZwgSP+bPWH1gUYtaJIvE
	NrueAE3gP6yUVtDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9N+7lwH2O29FCtDOcIXWRdMiWLy2V1231o6QfK0KGUE=;
	b=B3H+34ORny/VVsDdq8Hr62tOD3TnB05ou7dq3kq7LNbLASIjTFCdRxBQNcu2Pa8RHshM+q
	TyvQP5xnk4t0aptuHnqnTCcO9no0olVm366n8MnzI6lGP+jJVAGfTzd+p09bjSCwKI3/5k
	m+N050d5p527ntCrlprIYFtsh9cjyTg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9N+7lwH2O29FCtDOcIXWRdMiWLy2V1231o6QfK0KGUE=;
	b=8NMPmkdz0WLinFHfZNQJiWxpyJdx2WXgfJRzXVkTTx+49ftxttZwgSP+bPWH1gUYtaJIvE
	NrueAE3gP6yUVtDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6E884281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q2iOMJlOvWmYCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 93760A0B4A; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 37/41] minix: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:32 +0100
Message-ID: <20260320134100.20731-78-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4755; i=jack@suse.cz; h=from:subject; bh=+gI0d7ZrtcYpFe/TC2/HuBnlqIdH/Oa/KzrJSvIm3yQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6MP3cCFiT/aLD5vOor13PcWVO8kCRuMRMaX zt7IMI92lWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjAAKCRCcnaoHP2RA 2QR8CAClXg3d+N3/bqNiRRpe2IrNUXfjQdOVc7lGcDotv64qqab3rTiKZdlmdv8Bd2KcoRnaomQ Myg7leYfa2Nvnic5ekMzWTGqL9RLKhGSRJzI49lITxoSrnS9lrifmtbZe9pvWIOa70EvsU9vh+W fEhXM65Ol7LLcCo4roNxXflza9tT6vBfa91zvXlYSTjT7kmttW7Dzd5UIJY25KGOqydR1MLP9Xn EAvZ0wvTq/gvje2MjjL70nwEfNY51q+eNMkHYnvT3vdFHvLD3677QT8X8U4w0TO6XwxIhNBW4D1 YbqRl1TQno6ZT9HAR5QEqXW3ZDMOeiK1jjpgUQ0o/UsnAkoy
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1rsf6mnwx6441d5jd1fy6kqnm634dkf5
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D0CBA0009
X-HE-Tag: 1774014226-928020
X-HE-Meta: U2FsdGVkX1+kDJ+wxCZJ7mcrwjcecyfhv357yhCrcFXeKwFmvmxscIudmd/KU8GB8Q0N5tLspod36kzl13UarwfHhiTZqQypcXpGwNILdmd2xf/GADMoCrgSu0ocS9YqCBhesu8H0LTmjoTQrg7AuXtDDWwMdsMc3yq3TvQv/j53psyGGB+TDV33zV9kuCthKO2u58Sip6LYa5AgSxKwsD3Nl4dC23pBuFE9LJ5+GC2l/rv4sFRgVr6oeBvCOHfDANfKd3CEdBwFiPX6KZpYGigdZYOHshb6zsykUrubT4fLKm+QtOHsoJyN8+bTBxrPX7f5/czOVnpSxHgFpQaBDgfA5fxqJ8Egb/ZdMV17GBORM2EZIRv5ysgge1PpHONHdouyGaJbu64IPHjbXDAKYzbPUHR3EImP+YpwCCvxsQzTN/k6I1U5koZUV5Pm8Nw89/afcKgccxSBrJlJQY449J45lTkfaqJWx3SmKFffP1semeOQMQpRQ8w1/IMqt7vhUoeBDqyzY2wwcJhFLJKxJHiX7qfI829h941+rc/5Rmp6IixiVYm/VS8BzgtoEDyF3yTgnNT9fuQgSzILQz/CVeZfIzZjZ0d5usVQP/vA28GVWeKCOejukKQp57VY8CoYX4UZdPPZBECoiJDvWmNThEa3obh42mlQOZ6DS9xIWTyOLfZD3f1WoUgp7Oc+b223Jgk4plFi7gLb8MmCQTwbO6KLIKIYwMZF0klCfHaE5NFiIRfacpjyy8piPDPs4O9HoAjHm6QrRP8VMb7m/5x87lIhpPGReMddnKJmjKpQkm9WWV83WZFDBLiKR2pEQPrjPW+sXf4kcWuYnO9QuaENZo2f+eNOGjBkvTizkL63RdIMHQcLyqy7kaNXq8mtNJIC6mdZUlJlFNSAPgEx3Uig9vK3+eDKGUzCmFdqb3HoXpIxGTJDkS37wlNKvyJcVSYoDeAfEhOX+zZLNZnvUKg
 X39p6Lpc
 /cgOZnpI/9yx7OQJLl94wZDB9ogNrAWcvry7mMR0J2bCZOyRWs2NxUTwM8JTwZNros23Q3IZUqkCx+rk7ENf/LMah0QiMd0h0OuQ5olrRcYXWqWSsIF/xMgv/C20lePeOPAYGkAHzgEGqo7V9hKqa7ewkXnmt6n6NZ646EBCLlx9L7Uv6llq/8NaythZVa0vtQ0yY7IIA8JDIqk1GSKlRd+b3mq2NuXY2f0gZ3aqGKwJncW02AeAErICFkAw/VcYB8IWq+iImk8ScDTr/A+5a1JVkMcQ0yEbhWH7xCENpmlIO5PfykvDBjotSOy5soxpDtxMf4l6VHpvG/vPgW1R6f+90Sn7NIUS+BOzV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c          |  2 +-
 fs/minix/file.c         | 10 +++++++++-
 fs/minix/inode.c        |  6 ++++--
 fs/minix/itree_common.c | 11 +++++++----
 fs/minix/minix.h        |  3 +++
 5 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index a74d000327fa..361d26d87d2e 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= minix_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index 282b3cd1fea3..bc0be789343a 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -7,8 +7,16 @@
  *  minix regular file handling primitives
  */
 
+#include <linux/buffer_head.h>
 #include "minix.h"
 
+int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return generic_mmb_fsync(file,
+			&minix_i(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 /*
  * We have mostly NULLs here: the current defaults are OK for
  * the minix filesystem.
@@ -18,7 +26,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= minix_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index ab7c06efb139..adba14628d1b 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -49,9 +49,9 @@ static void minix_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		minix_truncate(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync_buffers(&minix_i(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate_buffers(&minix_i(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	if (!inode->i_nlink)
 		minix_free_inode(inode);
@@ -85,6 +85,8 @@ static struct inode *minix_alloc_inode(struct super_block *sb)
 	ei = alloc_inode_sb(sb, minix_inode_cachep, GFP_KERNEL);
 	if (!ei)
 		return NULL;
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
+
 	return &ei->vfs_inode;
 }
 
diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index dad131e30c05..c3cd2c75af9c 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -98,7 +98,7 @@ static int alloc_branch(struct inode *inode,
 		*branch[n].p = branch[n].key;
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
-		mark_buffer_dirty_inode(bh, inode);
+		mmb_mark_buffer_dirty(bh, &minix_i(inode)->i_metadata_bhs);
 		parent = nr;
 	}
 	if (n == num)
@@ -135,7 +135,8 @@ static inline int splice_branch(struct inode *inode,
 
 	/* had we spliced it onto indirect block? */
 	if (where->bh)
-		mark_buffer_dirty_inode(where->bh, inode);
+		mmb_mark_buffer_dirty(where->bh,
+				      &minix_i(inode)->i_metadata_bhs);
 
 	mark_inode_dirty(inode);
 	return 0;
@@ -328,14 +329,16 @@ static inline void truncate (struct inode * inode)
 		if (partial == chain)
 			mark_inode_dirty(inode);
 		else
-			mark_buffer_dirty_inode(partial->bh, inode);
+			mmb_mark_buffer_dirty(partial->bh,
+					      &minix_i(inode)->i_metadata_bhs);
 		free_branches(inode, &nr, &nr+1, (chain+n-1) - partial);
 	}
 	/* Clear the ends of indirect blocks on the shared branch */
 	while (partial > chain) {
 		free_branches(inode, partial->p + 1, block_end(partial->bh),
 				(chain+n-1) - partial);
-		mark_buffer_dirty_inode(partial->bh, inode);
+		mmb_mark_buffer_dirty(partial->bh,
+				      &minix_i(inode)->i_metadata_bhs);
 		brelse (partial->bh);
 		partial--;
 	}
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 7e1f652f16d3..f2025c9b5825 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -19,6 +19,7 @@ struct minix_inode_info {
 		__u16 i1_data[16];
 		__u32 i2_data[16];
 	} u;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -57,6 +58,8 @@ unsigned long minix_count_free_blocks(struct super_block *sb);
 int minix_getattr(struct mnt_idmap *, const struct path *,
 		struct kstat *, u32, unsigned int);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
+struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
+int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync);
 
 extern void V1_minix_truncate(struct inode *);
 extern void V2_minix_truncate(struct inode *);
-- 
2.51.0


