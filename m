Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B79EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A7E6B0159; Tue,  3 Mar 2026 05:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F6A6B015A; Tue,  3 Mar 2026 05:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00FFF6B015C; Tue,  3 Mar 2026 05:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DFA616B0159
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A768E8B691
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:32 +0000 (UTC)
X-FDA: 84504397824.21.9BB8A5E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5305340005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SP9xJlYjnRJ8AzSOyepLZqgjxJGPPZHxaWOdXFRbB3s=;
	b=cCPN29AVzjtP/l9vQhGCcmQh/C+lSXNDI494Hm8IXCDtfFH7360hNn0xWugl0p83ehU7xd
	L7nrOVz7cz4b9I2gscuZ+iIMoFBK8baC1dQNIo8i2L7DqhWPPgylC6Jl2UcJg0ATKVTDUa
	zuhA6mEo1bLZ/KupPBWafFNiKQNuKaU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534190; a=rsa-sha256;
	cv=none;
	b=GA87AYNh+oi6yAwZ5JDKavDiqNHCNPYPpgUXAGyQ++MIVHmokm0L8p7EhQQcnyGzdTZYA2
	y/w2tFiuH4kBo9nsjjTwe6XHg/RCSeuwUY3dJeDqipx17fpt9hY8GvHQa7n9upEXwGYhg+
	oKYCDLl2RM4wxGk5bP16gq5/fjRyu/c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7CFE03F8F3;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67C213EA69;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wgBcGUW5pmmdFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3E25DA0B7E; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
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
Subject: [PATCH 29/32] ext4: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:18 +0100
Message-ID: <20260303103406.4355-61-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4816; i=jack@suse.cz; h=from:subject; bh=glK5IwI5bzBvc6wGANg8E++2uCF5SfKIYMDofG/EJec=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprk2eXk3gBLtLKTK6vnw0UxDVHoLdffj9Gncu VMs27zm3eaJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5NgAKCRCcnaoHP2RA 2eMXCACdnE5C1+/lCrGBS99f+cu5Lf4A/gsWSmltB4nZv30ejF4l0epIRPudvmCG0shOIBrkbop +Agkd5u6WzuU/wwY9G/tkZ1vHkxjclfBkREyGftqS6GlfgCwB/PyG+2We/pB1jI0jLriALb3I+w PiKUunQNDYy0QCSziRKPT1DMJSZZcC50ZNQ2e5Kyu9+5AN+kc2WyzJN8T8E6YHunCupUbJ6xgI6 2SvnkBVq2TB6QhV8RybU+648wxdMqHNHcEblqWitBWiXlJGiUX6TwmVNFws9q/avHoDE/zOyKCq 3aRO0APtNPg5S0P2XTORKdcfJTlGHrcnT92ouNVEFoHOJhxr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5305340005
X-Stat-Signature: uiet6sb4g53cjitwrdxjm3kr1xncahoa
X-HE-Tag: 1772534190-472637
X-HE-Meta: U2FsdGVkX198Eqa1X85bcz6wiuh2SnuCL3T/HXdHqWTDqQl+EusDtUZgLYI+RxL1n+s0V+9KwBsTpF4EE8I1AYV4Hbiq7rYYdM9jQx29TwWi7ouxzk7fLxTy8hB2N2L421oayNCNi/UJZFnIAKmkM/FI6KRB7gh2qg/gY2tTgaF5oKfBXFE0I6C8CEpJX31tP/qCQotj/Y0bcwa+TIxetS7KP1zfqDpnuh8tCOWWJ7O8HaJA4IPWAcBIrwR0d7fWvnM9J6R7Pc4qjzfA8xYnUwsKzV/WyVbfWk0sFF7K+SCHnlhtyBHAGCTaErlzjf3x/rMsnTMVkEpzYwOm4fJWLjq8p1y/hnTvyD4CoTX4XvZIIfmCzcXNc8yhaqw7ZKWvMmNKz8j5p1fyvr4RkTxC7sTEcDtQdndTfNCje4ujbVmCWLg3/VzcxqGBwtQG4nY6HGV/MSfrW5tcCITBHhsN6zPCEfnfjjfWnMoEcgsKiGiChdqSxacfHZqCYfC/62yS7mc3u2bvogkY+NqNfelOMsYpWTzzX+bC5+bFyEx0eamclcrX18Dglri47mXaRfp/skW7gjG0UJ16DB9E+a8TiQ+2nHthfeXH5+iqZzLunbt7BKmYF//6T3hhYKDjFA9S7ghoUWxP4hbCSzmwR45McBxzJ/QMrBAyt6DJCFJu6cUuqvchcBZH8oUZ9DzSEUomfg1CSmx8Hc9LxAZpLyyyl+fVwq6iUqZAqXPsue3fLdhfeGO5zgElRIm8wmGuc9ZOym7tb5y7voLWj6h7vjU1Yzh1fAeNBDZbMng1dj5kgDOguvyKUWnl2zdFGWSRCaMtUF0zozMtHgxcEDn8Aqv6Iks2PAuZgGWgBnm4LdcjF63J8TLsjR0NYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode. We need
the tracking only for nojournal mode so this is somewhat wasteful. We
can relatively easily make the mapping_metadata_bhs struct dynamically
allocated similarly to how we treat jbd2_inode but let's leave that for
ext4 specific series once the dust settles a bit.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    | 4 +++-
 fs/ext4/file.c    | 1 +
 fs/ext4/inode.c   | 2 +-
 fs/ext4/namei.c   | 2 ++
 fs/ext4/super.c   | 6 ++++++
 fs/ext4/symlink.c | 3 +++
 6 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..a829e5da67af 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1121,6 +1121,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
+	struct mapping_metadata_bhs i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
@@ -3203,8 +3204,9 @@ extern void ext4_mark_group_bitmap_corrupted(struct super_block *sb,
 					     unsigned int flags);
 extern unsigned int ext4_num_base_meta_blocks(struct super_block *sb,
 					      ext4_group_t block_group);
-extern void print_daily_error_info(struct timer_list *t);
+struct mapping_metadata_bhs *ext4_get_metadata_bhs(struct inode *inode);
 
+extern void print_daily_error_info(struct timer_list *t);
 extern __printf(7, 8)
 void __ext4_error(struct super_block *, const char *, unsigned int, bool,
 		  int, __u64, const char *, ...);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index f1dc5ce791a7..3d433f50524b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -987,5 +987,6 @@ const struct inode_operations ext4_file_inode_operations = {
 	.fiemap		= ext4_fiemap,
 	.fileattr_get	= ext4_fileattr_get,
 	.fileattr_set	= ext4_fileattr_set,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 011cb2eb16a2..eead6c5c2366 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
+	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c4b5e252af0e..4d2cae140b71 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -4228,6 +4228,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.fiemap         = ext4_fiemap,
 	.fileattr_get	= ext4_fileattr_get,
 	.fileattr_set	= ext4_fileattr_set,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
 
 const struct inode_operations ext4_special_inode_operations = {
@@ -4236,4 +4237,5 @@ const struct inode_operations ext4_special_inode_operations = {
 	.listxattr	= ext4_listxattr,
 	.get_inode_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea827b0ecc8d..4b9eb86b03e2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,6 +1428,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
+	mmb_init(&ei->i_metadata_bhs);
 	return &ei->vfs_inode;
 }
 
@@ -1521,6 +1522,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(ext4_inode_cachep);
 }
 
+struct mapping_metadata_bhs *ext4_get_metadata_bhs(struct inode *inode)
+{
+	return &EXT4_I(inode)->i_metadata_bhs;
+}
+
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 645240cc0229..53ec8daf4cae 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -119,6 +119,7 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_encrypted_symlink_getattr,
 	.listxattr	= ext4_listxattr,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
 
 const struct inode_operations ext4_symlink_inode_operations = {
@@ -126,6 +127,7 @@ const struct inode_operations ext4_symlink_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
 
 const struct inode_operations ext4_fast_symlink_inode_operations = {
@@ -133,4 +135,5 @@ const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
 	.listxattr	= ext4_listxattr,
+	.get_metadata_bhs = ext4_get_metadata_bhs,
 };
-- 
2.51.0


