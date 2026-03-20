Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85851098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCB06B00FD; Fri, 20 Mar 2026 09:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4786B00FE; Fri, 20 Mar 2026 09:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B476B00FF; Fri, 20 Mar 2026 09:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3A86B00FD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E23C4C0E8B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:44 +0000 (UTC)
X-FDA: 84566559168.12.31A18A1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id AD6E81A0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wrr2fgYKYuOCMVdHZf/n2LnosWSe5tGUuMc+CaVBBz8=;
	b=x/KCbgDVqnUxlN5CSncN0zNEmJbPp7IZ+NyXA0o5MfpYdvlOY5YrtL9arlpZA5dGGFuTqF
	aw+Qi9ORZNxANLw2W86vgkue0dGXViCyGkwxRnS0OhnuBD5J6YY80wlQoNR2SGiidRlqbs
	ujHYfKzpJfiCFTocdJjpTiXs7h0QOGo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014223; a=rsa-sha256;
	cv=none;
	b=OXqOeJ1W0rDqx/9rSJnfEIuIsfxwhwDq+Owoaicd3G02WzxqpWRnTcaG54myBbsoyqI000
	XA01K2DQ6dxDy0UdkOYX46XjAkWrLIwk3aXuE3MseZvCtXWBm2hGpxh2WXgBPWL2mcCsjn
	1dEMEefYMw/AeX90go8EfjSLaD6CbRU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E8E205BEED;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D36694281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9OaM5lOvWmdCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A2264A0B4E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 39/41] fs: Drop mapping_metadata_bhs from address space
Date: Fri, 20 Mar 2026 14:41:34 +0100
Message-ID: <20260320134100.20731-80-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4303; i=jack@suse.cz; h=from:subject; bh=beWcTFMo3xvmeZcELnyVzz5p7d17vMDEbuj+XGoJTGQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6N3nyo6jZfnTL8nbHGxRtbREYDoVsN0vFRJ hx52+5XCqOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjQAKCRCcnaoHP2RA 2dCRCADFC4KBTHW3tpd5qhQrVvE35UqOKOGz3dm5r9QSRXNIO2N9IYPLesVt6q5TcVyISeuPfds Gu85B8TMPuDiSWdWC6NhUU7ru3Jk31sLgIh7gT0PIUGLklwN6QSdIMUo95ZFHf+jD6Y7ggzgZw6 /t/jFK3Sy+spg0XTb/qERl+GbjjA6keBO4OUdoRMWqJLScJ+pU5LD1txYrHAovRm/Q0ey+Le8dG vjp7TBVAGCpLZQAZyAvZdbXLbQX0Pyu9km1OvcVBg80rekgaBC1VQEdm+e2SqlBj+dQw3d81Y1c /kH5tL5QbBRZXj29Ryy1oMZakHOKqCo/mLEOTvUkj28FqKU1
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AD6E81A0005
X-Stat-Signature: ofbeej9ck7zyfebaw1m318jtqempeq6h
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014222-29801
X-HE-Meta: U2FsdGVkX1+DHkOZOl4oYBDaObSymJCrA04sJN5o/ZcEwkgY5wgIgZSR0LtMmjrtoWNB7epmfR/SLV8EqkuoGGkW1/umYQ236uaprewrHACckrMza93H4EXScg93IwWYkM5Tk/Ln8SMnM4Dktqqjltmp07V79PgMT3IVtloWOAYpFamMROE3Ih5kCwk391pgNhf+EwRAPwlB6UO0wjxCjb5P+Yf63tBWu40ypd1m+pQyM41h5SxmiCcnmYq+mm/A8T/3ZlBrATjux+VIv9uloUxOY5AK7wAPWv+hheb0k0+XTto/WE0BEjYYNoSR+i67JNmlYUUfdUvtLBmXBjB/UVfVSamH658CZcCrYsljMAnHOGa1t3zZFF2OtRBouC+EGCjRurGIDhjV91r15Vlu6CUBdzPZVVDGhXvXHvQFnb6C5bUJdMOMboTLG9rDNB7SUmQBnyTqEKeKyKlsglsKK/ll+kdFU9JZTJUp7toph7ixzti02M0FPzLNgZ6tAQBClUzgL/v0ZBE/2hdgZikpBZRHDOwgzLzmGIG5NIRqDMqGwaLuhbZmPR1D8HrSB/2cPQywXhiF0qtw0oA4mTjBC6bdeMhfIRvW7LznjxjHNrhxRJiSRICFWdoZinNvRzLZ1Pz2pD0M87NCFKdPiLsRsT1GJNZ37SyVWx9he3ER2HR5DL0fc/QE6ZY2wb7F2wVe+VX5ovhpt6q9m/f1+eIR2yMYyMglW8gfoVP1Ca55q2XNnLZX7ILb1nN873BOn8S/Za0m9BIm3T93ewlYCJBDF9G1RH7spEmZ//Tj3q4iQxRgWbYxC85YPFaoPFjSUuf+Qme3lzmfO3D4OjsrJVZFvVBIbq4RN3VLGwoi4V6ahAntV8icnE7ZOvAcxeva8/KXkP/AbYO2w6ZsR/s0efmFbR9FQ+cr2otRAI413btHjOu82KcPmy/aMg7Rd2nFXdmIm1WsB/av3AYthY6LVRP
 lLNM8zuM
 3V6iyxwJUQG4VHaQReeHGBnFegrYqQSa/RV9BlAZp4VmPGd56rVIs0vBSrCdnhasbv8QMMsEJaoSt8nF195yg9j70quqGMbeyGAU6zmCDsFnmwafLeDoSX1Ug408imdbMi3FUqP0nrfy+rztLexyls2lIKUplGLH5hKnZgaaVVKhwdFq3s5rI+GCrVaCisabxLfcLPKxDYdt0jbRMYVHiI2PMhUZT4C2p+ocMNo99WBPD4HM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses mapping_metadata_bhs in struct address_space anymore. Just
remove it and with it all helper functions using it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                  |  3 ---
 include/linux/buffer_head.h | 28 ----------------------------
 include/linux/fs.h          |  1 -
 3 files changed, 32 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3874b933abdb..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -276,7 +276,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
-	mapping->i_metadata_bhs.mapping = mapping;
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
@@ -484,8 +483,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	spin_lock_init(&mapping->i_metadata_bhs.lock);
-	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 399277c679eb..74fcc9a03c32 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,29 +207,11 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
-					   struct inode *inode)
-{
-	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
-}
 int generic_mmb_fsync_noflush(struct file *file,
 			      struct mapping_metadata_bhs *mmb,
 			      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync_noflush(struct file *file,
-						loff_t start, loff_t end,
-						bool datasync)
-{
-	return generic_mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
-					 start, end, datasync);
-}
 int generic_mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
 		      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync(struct file *file,
-					loff_t start, loff_t end, bool datasync)
-{
-	return generic_mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
-				 start, end, datasync);
-}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -538,14 +520,6 @@ void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate_buffers(struct mapping_metadata_bhs *mmb);
 int mmb_sync_buffers(struct mapping_metadata_bhs *mmb);
-static inline void invalidate_inode_buffers(struct inode *inode)
-{
-	mmb_invalidate_buffers(&inode->i_data.i_metadata_bhs);
-}
-static inline int sync_mapping_buffers(struct address_space *mapping)
-{
-	return mmb_sync_buffers(&mapping->i_metadata_bhs);
-}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -556,8 +530,6 @@ extern int buffer_heads_over_limit;
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync_buffers(struct mapping_metadata_bhs *mmb) { return 0; }
-static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
 static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c4ab53ec36ab..d2122e1c9a3f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -491,7 +491,6 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
-	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


