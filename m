Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A81F106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:57:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF856B012D; Thu, 26 Mar 2026 05:57:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C969C6B012F; Thu, 26 Mar 2026 05:57:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BACFC6B0130; Thu, 26 Mar 2026 05:57:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABF8E6B012D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:57:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 841DBC3960
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:23 +0000 (UTC)
X-FDA: 84587761566.17.607889C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2E5B414000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k2IXJsi0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Cu1Sqrs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k2IXJsi0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Cu1Sqrs;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519041; a=rsa-sha256;
	cv=none;
	b=RLQ1+v8z/jrLtxJHC7PtgRELv4Y/o5aTCBMwBceWZ9981rB8fE4mqMi2V9hROnOCJY8OMV
	gEpM9HoWwtZ1yP5l4lRwasKfIVaRvONYzeIyQGr+jLu3UGQVV/v/2nXZN0OUBjYmAT/RrJ
	Yb/5HPrw2Y6a36hbxrW6WIxTI0HSgP0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k2IXJsi0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Cu1Sqrs;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k2IXJsi0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+Cu1Sqrs;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=2m3JWUMljw2eqcmvbdq1QsjsHHvASyQQdVY0R7e/YMnU1vdMaTNmQLmGptt55rpUCaCfG6
	8D3pGuw+ulYUzEF1tyD4ii+bwKN9VIqDaEEgxptaIk6vpi90VREJpn29OobBVWWJUQ9FUV
	TqbOLnHRE5VKN/Bk7AzrRlQIDJLHVoc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BBDDF5BDD3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=k2IXJsi0SUU38wKdBvypl6ZnpttNNVynrB3dl8xeNInC4Con3yagBcilXHWfutQEEJbsMC
	L98tWf6D/jTdUcM9c1tX7bH8gbUF2eeuGhvAXeX7DsfeYoQqqN0sfiYM0AgAlxETMglZWg
	agE7qYC0vhveRgQOY7kAluMopfxQHDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=+Cu1Sqrs9JhQuPOKTkxkGxMDSyqfn0ulyrAC4vq9Q6SIu1uXxzDRpvXlp7Kp2pP2AaLPXE
	PHwbdO3200g7UqDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=k2IXJsi0SUU38wKdBvypl6ZnpttNNVynrB3dl8xeNInC4Con3yagBcilXHWfutQEEJbsMC
	L98tWf6D/jTdUcM9c1tX7bH8gbUF2eeuGhvAXeX7DsfeYoQqqN0sfiYM0AgAlxETMglZWg
	agE7qYC0vhveRgQOY7kAluMopfxQHDs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7q8Kx1FkVvzvC3Q+vN0M/TZAWD4PkwxVk8bUtCe8P+o=;
	b=+Cu1Sqrs9JhQuPOKTkxkGxMDSyqfn0ulyrAC4vq9Q6SIu1uXxzDRpvXlp7Kp2pP2AaLPXE
	PHwbdO3200g7UqDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A5F274A0AB;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9gGRKHUCxWkGYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D678FA0C7F; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 39/42] minix: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:33 +0100
Message-ID: <20260326095354.16340-81-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4731; i=jack@suse.cz; h=from:subject; bh=LB5f9ZM6VTG6f7M+4eM1ibxL/c9eLkxT6oy6CEVQ+ic=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJTqj+aOzlKcPkCimm7IqpQm2fU61zijKeKW 5HhKtDTckGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUwAKCRCcnaoHP2RA 2TCJB/490VA3we2/AivSVCUBWocvHEyG25ixMq2H4qxIqT2Kd/r8p/4yiXj8YEXR3cO4jiD0KX/ pofRf+wwtm3lsZyz4ScERTu11HFuTm40DjhGPiJ24IHIo90+iANsl7fNt777dCSU0VWbJliaWQJ D/QBlJhGbKvE6k1GJEmb1ifthzuddz473YVtw3fBo4dJ9Wfqj6CAiYTyK0iIGI/k48DYVe5ENlk eQ5ILiyrBw/Zz/i+kH2ELXLuvluJKGeLnjQOMG2LtuiSmuWa6N1YDiFL66rlbovT5eMI7EslIZz 67ugOsQXYmuIUBf9i1KIjiefsjCTwrw+vMGNu0WLpksqgJps
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: noh699bbncxpw93f18tc8hmes8onc5pi
X-Rspamd-Queue-Id: 2E5B414000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774519040-853077
X-HE-Meta: U2FsdGVkX18tBRobtJDUXbp1yl6P66eZOcvK4ab9VaN+G4f55U6BB+lSsgO/hAeQXh7mi7luXfVCQg1pVg3RzicYnDgrxAJhReWMgdULf0oxvwDuq2j5wI4goUpa33s/gTEKKBXcuUXyuY3hJdjkmlX7Iw5nUqTLd2JG69gfBqHwE8rxYVDFdK9IF5Nu7ngovmY0xOluSLwY2NCtjZxikDRkSAzPVBrSKXVqarsjdQ/ogJfrUzboIHihT9WGAKvorBM5O3bPYxKumrx0p7OL4uXPSP9vjgXKItlg/CD4nAQ+c+VRZtwHBB08haxscUGVLL/5dXMe3M8XyzBE9oluGlzR9O//bwV/HcPV6bVfiCyqT1geh7HsyhfU8GkTYXSXuPvgIbOoLLB4DGFeiMaGhaSZjQFj/ov1bApK6u2Sq4F52CU280vqGrBnNyHHUeF5gn1uEM1BkjSdU3pDvwGOaK0n7W//rNSHHhbTtVpwsyd1K5Bs3rGZJCvgPQ5dOxRwyK90a4asPuQtna3e138LzF/CiA+BU9wIwZeFJ7nCjXe0mkPrwECH6cMwxVJNYkEk84hiogRIW56V6WLxt32KReIfTxMGpvSUOR7rSQXFsxxJ8kNQZwNN1ttmvJWLAlNqjK7lj4RBWTCcBl6fmuUAYb7Vyqz6kdiDhOitKi6iwbdbVPYBSrT7AVoMvkHbCdTNalY9P3pnoGJ2T4CTU3drsgwmE8ZORRsgN9mzaEMp/L9U7a3lm2VgpafZrIY1AtrdOn3P9FYB9OXGtxsmSVyO69+2j7AZypUzz2GvoTGQzREWrLO+HkejXVo90nJgbC8p4Q7xRBHiphyV7df2Ysr28jfPmlXEK2ZeKjza290ssxfbu2v0kLmOTx9qfFF824NE7jwiSRm2FFsaKOLBC5k4kWxyMq8tNZQWvBTd/Rjirtvl1gbIXE9XY13BUXuANT262GIo//8eN0JHY1+1Xc6
 CQHo7ji7
 JgHhnY7F3v0eP+iIMgbFZpT6Nl5wZshyjoJ1bKN/jWBTjlxDKNwe5ENLqjpWgs/1u0I0uSKqbd+Iyu1TlMcql94Je2qlAwXMTVTOHoZFX8JIWP+iJeFAJ55p620mFD5EPX1finOJy/rP3qcee6SbjbHslLu1OYojgasV0fcmPkOFIW+4JxxYbpuQPy6p7gkyI5cpcl6nJR4pW78uIBdGIv+I7e5sE1ECJrNjso+rmkdio9DPOfrbmFAo77L86UZwr5u6mGxfUBs6bMFhnwGNs88ramXhdatq2i/iW7FMDGtE8bDe9Diu25/6FuA==
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
index 282b3cd1fea3..86e5943cd2ff 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -7,8 +7,16 @@
  *  minix regular file handling primitives
  */
 
+#include <linux/buffer_head.h>
 #include "minix.h"
 
+int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return mmb_fsync(file,
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
index ab7c06efb139..63f378f38d43 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -49,9 +49,9 @@ static void minix_evict_inode(struct inode *inode)
 		inode->i_size = 0;
 		minix_truncate(inode);
 	} else {
-		sync_mapping_buffers(&inode->i_data);
+		mmb_sync(&minix_i(inode)->i_metadata_bhs);
 	}
-	invalidate_inode_buffers(inode);
+	mmb_invalidate(&minix_i(inode)->i_metadata_bhs);
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


