Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59730106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FC76B011B; Thu, 26 Mar 2026 05:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07886B011D; Thu, 26 Mar 2026 05:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BE46B011C; Thu, 26 Mar 2026 05:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC4986B0117
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76F031B92FA
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:51 +0000 (UTC)
X-FDA: 84587760222.15.E9E766D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3615A40009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzizY0qG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzPDswGv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzizY0qG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzPDswGv;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519009; a=rsa-sha256;
	cv=none;
	b=ZMxQfjOCXtDJ6203AO2qhW8yRh7CzLIzH1jvejzw4FY+56PbH0QUry4bt21/g/W4akEmKQ
	n9O1s8i8DlXHZWX9JBudauatkDZ8/C2+Ky8wQAJtvIfzJWptCi+6kim4tTmtnKFByxfKvF
	n8ctSbfxXdNwlZwSRBHwC3TWkEbOjA0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzizY0qG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzPDswGv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xzizY0qG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UzPDswGv;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=011ZlSFc5c6wvPtcX2TpEWsPDUBHWaXn06xdclfQwu2pB3xghyrwFe4/xoSZSycQ8T5Op+
	tqMA00OBwV0cmtLImtOy6mn+7WJRf/sriob26s73jZp5HL4eIvTwniwbRR2zjW423K6uwA
	IcJBWDIo2kR5ppHGRg21l/tt12jyvHw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FEBD5BDC3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=xzizY0qGA2xxKwN/TTLRR8OgCKBqK+Hp8GoaoQcBFeaiMnndw7xrgGdyFcP1KoAMmIqKOx
	r7IFZPvnpN2bnctp0k1VY0mFbEWntnKdmcryA9H2/fUjzXAAru2KQDcOcO7/exuBAz4YAN
	afitD1Mb+apNMLK4m3AdMt3kG4pMk1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=UzPDswGv2QfHuXmQrwaIInfQoACYdtIzrOOFcS/Zll+eMuKWiFKcLgEJx9JDHlQUij+gBS
	dIMyE9fXpcWoYHDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=xzizY0qGA2xxKwN/TTLRR8OgCKBqK+Hp8GoaoQcBFeaiMnndw7xrgGdyFcP1KoAMmIqKOx
	r7IFZPvnpN2bnctp0k1VY0mFbEWntnKdmcryA9H2/fUjzXAAru2KQDcOcO7/exuBAz4YAN
	afitD1Mb+apNMLK4m3AdMt3kG4pMk1I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLPTrR9MZYnpyjuzpcjQOozcpRc1zXM2n3PzFPlVoj4=;
	b=UzPDswGv2QfHuXmQrwaIInfQoACYdtIzrOOFcS/Zll+eMuKWiFKcLgEJx9JDHlQUij+gBS
	dIMyE9fXpcWoYHDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95EC44A0A3;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jwWZJHUCxWn/YAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BD29FA0C7B; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 36/42] bfs: Track metadata bhs in fs-private inode part
Date: Thu, 26 Mar 2026 10:54:30 +0100
Message-ID: <20260326095354.16340-78-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3085; i=jack@suse.cz; h=from:subject; bh=mPftk52N1tg292K+pLT6SWPCyjD9IykdNuzqZIbq9lo=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJRqNkHhgR7SXPvvfjYuN1uPILl7w2KvOz5A a9V2nOJOwCJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCUQAKCRCcnaoHP2RA 2ZhsB/9Ha9Xe4849znz4uZzqx+mAXqZLSVcVROsaSUM4SXsJX1uua3AmlshbsIRJILX75Lp1tCA 4hMK0sKdBawvmqpADO7cUNnkZwSAYzRuZ7DjqZOcePaAAsJh5/qqXaoIuL72quw9cv4QhXOzzHC XSxPTnrWFcSEMZxIIgpOjb6mSWXqCNyjPWTcQJqZ2AxU+P++baZaIe8+aqBkSSrHhY/yk6y1Hhm V9I1hEQE4K20ljtEUQOgM5E8hd/qSS4pgGIlmmaprD6MAh99NG3l8ka7RbizkWrlAP9l18TRjVL QqXNoNo8uWPZtO3iakLMWxKCnQR68mdwC7mrl56FS0Y/AdW4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Stat-Signature: obn6zdkse8u65dc71fa4thfp94s3z19r
X-Rspamd-Queue-Id: 3615A40009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774519008-955711
X-HE-Meta: U2FsdGVkX1+r2boaqwsXPNz+eaXgIeM6FbHhwlOWmcXDBvwciO1PDzpDdJZbWIVgUtarpRYfo6eGqRR52gAMURy86P3uz4GDIHFaGRFW0PQdQIQt4CfSzqBrQu2CgmbXNfrIpKvBkbdq/rvs6Ri87aid/NSPo2iEKA3GCniAGyg2B9CI7wi6CeeIPR1sbA+kpKPVH1Vs9noAnEqXQXMGCQfQ0tV5e7/fUxrSrZbURAQ4BjD8idLBleIejjX4qfMlQm3wu179DOMFmszZmqsx+NDRvkLrBObZfgFVn8dq8F2D+y24IAU1a0Huql5bpV/Bj8bvc7gfZ7hF9KBdBSn5Th0udRkM4DrssWiLFmCb3AVum3ub5ik/77tc65BMDw5nlaIRIOr/7HeBDsotiTlaHORaCcIFQnVJCXG+RRRS5qVpYVImTGROVsNy//bHlmC58MVskrDfLqCUZgbbFdw/GltdKWextPqreFsNEin9D+kkmXzvbgqd8ZKg2oqe8IGwo1RTCpB911fAfevqT2GQrt5OVpNavfVMCHeoshRvHvtUKdo9NgwZhulR5Yr/PwNIpZfLeZ/iK0Enerfe12cCRD6EQMBnfWBWxUuNJ+BuTzwbKX++LLFEC7xWi0eKm+EZqvNOE35U1j2DIXGrgt4ZEZyt0v7fbqoJ4OM9Ra9nmtjVLFIpbJ1gqB/G9QaEvX3w1joNsbAbMRr83UdFO1b41cWn+eUZp3WV7ZqU/9hr0xnfMSh7wp3Xgk/23WwHrYGHUSh+b6BsLMsGCKlDPLrQy/+c9jaZbbpYsRyFJEIXH44t7djZzJSwOUzjqpkVkXql3UW9vLQk4XsMHUbd8GBiqKsovix7RFrOHQ6orDWxV56pZn6DVe3imd3P/F72lQi7FSlKdBncnqaSG3om04qif9/kAObl9GXE29IyXGT4BPVshY0xf30kLOLnfOlovN6KbmKlRBXZX42N5m/wPP1
 cCRlHpAt
 seppMx1muuwycR4bRerGjVR8xYh4Fwa40yBq+fdRJndHBfabJ3v7fu6HYjS1OZEiSf4MROAUDRpfAXqZgb29UiE0vGcBfLLqIhc+03B/Da3Lhkn+4CdqObJ+NcYS/mpDfrH1GP0FZ2o57BV4V1mwQ24EEgMnW+c+tDLvkHr9okv56Ogp7A1eKA3kmORh13flV1s8z6N0lzE+4sem5bTehWZR68GN96Y6xVTWwkjs3qO6AigJOnq/zAMKaYBcFPZU2KU5QpGkpvRIBFjOgXOrpWOTNU7GivmBMlnUyV11IhVGtPWoB/rCgY9Usuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/bfs.h   |  1 +
 fs/bfs/dir.c   | 16 ++++++++++++----
 fs/bfs/inode.c |  6 ++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 606f9378b2f0..b08afe733e63 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -35,6 +35,7 @@ struct bfs_inode_info {
 	unsigned long i_dsk_ino; /* inode number from the disk, can be 0 */
 	unsigned long i_sblock;
 	unsigned long i_eblock;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 1b140981dbf3..2848401e2bf1 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -68,10 +68,17 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	return 0;
 }
 
+static int bfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return mmb_fsync(file,
+			&BFS_I(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= bfs_fsync,
 	.llseek		= generic_file_llseek,
 };
 
@@ -186,7 +193,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		set_nlink(inode, 1);
 	}
 	de->ino = 0;
-	mark_buffer_dirty_inode(bh, dir);
+	mmb_mark_buffer_dirty(bh, &BFS_I(dir)->i_metadata_bhs);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	mark_inode_dirty(dir);
 	inode_set_ctime_to_ts(inode, inode_get_ctime(dir));
@@ -246,7 +253,7 @@ static int bfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		inode_set_ctime_current(new_inode);
 		inode_dec_link_count(new_inode);
 	}
-	mark_buffer_dirty_inode(old_bh, old_dir);
+	mmb_mark_buffer_dirty(old_bh, &BFS_I(old_dir)->i_metadata_bhs);
 	error = 0;
 
 end_rename:
@@ -296,7 +303,8 @@ static int bfs_add_entry(struct inode *dir, const struct qstr *child, int ino)
 				for (i = 0; i < BFS_NAMELEN; i++)
 					de->name[i] =
 						(i < namelen) ? name[i] : 0;
-				mark_buffer_dirty_inode(bh, dir);
+				mmb_mark_buffer_dirty(bh,
+						&BFS_I(dir)->i_metadata_bhs);
 				brelse(bh);
 				return 0;
 			}
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e0e50a9dbe9c..19e49c8cf750 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -188,8 +188,8 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_nlink)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync(&BFS_I(inode)->i_metadata_bhs);
+	mmb_invalidate(&BFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	if (inode->i_nlink)
@@ -259,6 +259,8 @@ static struct inode *bfs_alloc_inode(struct super_block *sb)
 	bi = alloc_inode_sb(sb, bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
+	mmb_init(&bi->i_metadata_bhs, &bi->vfs_inode.i_data);
+
 	return &bi->vfs_inode;
 }
 
-- 
2.51.0


