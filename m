Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B27F0EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BB06B0132; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16346B012F; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF766B0133; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3BC6B0132
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:36:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BB81140153
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:06 +0000 (UTC)
X-FDA: 84504396732.15.5DCE66F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1547880009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:36:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YSt/X5liSImJSJCqb4XCZ7/WgUhvOLPhV0VtVOwYW4E=;
	b=Ma6gbJX9uYrzPL/izwyrjeAwpvulU6XxLelercWdAF03PyuoxuLldo5SVmBdQLu88eyq0V
	99ABqvVsrMDOALbk0rDt1f0RmdLuAfzLOoxGXDbD0hMo43HcDXYXPPMt1r3mnKqQe8g/K7
	FKTEBdaWcFD2ldPhgPQlsnckhZppre8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534164; a=rsa-sha256;
	cv=none;
	b=MJZqeiHyVUYyjl5ozsUIuyaXL2GRU0DpOT00KnWt0V0HKdI89uuuG7mhxvTh6Y8Z8gXZZQ
	XEEOguNygl/bWKG8uBT1cNxJSUvjsFqo0+EwwRW8XkEtSGarSCTNFh+rfCDzv9d9cUT4t4
	9YumeT6Io+lZUEU9+mVa1gYS6DRA8W8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5DDFB3F8EA;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 516C53EA6C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id noLoE0W5pmmUFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1F1A2A0B7A; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 25/32] bfs: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:14 +0100
Message-ID: <20260303103406.4355-57-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2544; i=jack@suse.cz; h=from:subject; bh=9mjhfCWoeJv6I1ItfFebb5usm5NcNzQ2umKz8lNEm4E=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkzm+CXPHG9qbKxLBWqWfD9bfsr1e7/r+Z0e 3i6Z9c2uGeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5MwAKCRCcnaoHP2RA 2U37CADBuxAkezEybmQ0+5cu0HE2PB14rqomXTSB64cI4hA4RYjEtXYMq6ndBH7EUmG/Typj0mb Z+WqgD1gdRE03UGv21Xr+V9XaKUCmZ1hItLRnX5SJL5Gz1FmWkRbc1ON5e00Ua9lI4KfwaWjLgq wcJocR12a0aQuW7rn3OXkZ+GLDTO0+MU3QXQleblPeAR0/U9Q4Zj7r66v2vf9KL98RlA/rrf8cb /b5AcHHZK0G9fsiDIdW+V39fgNxI3zkNeHtwENm+KTHC8LLeZ5uzEKdOgDnRvFZhajvwiEpelUK S2R4MKTBLxLRbKF//3ybdddGqVpwdMi46ZjPt7CTgfL0wxDI
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
X-Rspamd-Queue-Id: 1547880009
X-Stat-Signature: dij8fgmkqjr4wyqb6nbgpmh18roqwdmt
X-HE-Tag: 1772534163-582068
X-HE-Meta: U2FsdGVkX1+q3JNPZ7za/4ze4VHnGUVQKh4mX7HskkeRqkn5qIRMu2FMxG8ZWW+DD0AgQRIj4lYZTGy+EJ4GNK9VWH2W4KCaFH6LtG4Vu3oyfi576F54h6WtOtKF1SwF6QWsZKAI+tjRNDAwiL4uo8WHGhrVoz+dKetxSxyhKB4VufCv5mjFM/a5Ocau0pq3QMS8nHoeB7ebdjAy23UZTqM45dZh4xHg5OjkoZ0Q1OiD7/y0gSIfxxH6GdeERrfpkfpnlXF2oMHfBp9D6FbyDipXyh1txSEnwgzp+yPT6UVgFZkZBRTkOi1QXG8VP71sf4iYtVhs42VBEYiU8d7OzJZqCeZ95KEbcZzp3/8GcE2n6HWwgEQke1YVjxamEmS53PfOGSeLGWDvbNBMiaIQ4jmQSPEjD6WcDzaL2OHVww4a/1C3HaeepVPhpkUO2v0UsJUks3qZPny7sLIzt2lj3S7LsJaE8S1MDi+7S6u8fudKdwucw+UFjIwN6IwBCKkfkjOL5/vaxLokpg/FXIWLohhW9Kj5ASjXdWsnn6sm12EA/LIq9/h0ZEAX/aB9vPbnlDP46PQJQghJrGRcF3C7sa456UTwQBPRUeRtMMwkCeyeQ33d9GYM7LHBF5/ujzP2fwLjYPfeutoUJhu364L8a6u6hCyrxioIOosjsKzPGsjpnA0TaDsECk4ws+hdH1gr5HDkUTfe58vJUm1Rbg6EPuEGF0QeDjjrbvp7Z6RzWPyY//WKNA1/9UBZM7Ddre9h/s2m+kGI7ZZrSCDqat+TIGdgNegK2yhe5o4akgJN72Xn5J8rm0kwnt8uY3mvMgQh+kj2sLBFHrpGDsfInv6i8mGRTuL3s9KiWvaRW/PdOJrTPjk5VfWvWEabupCF8RFjgvFGu3bpaP/r5JatrRV8pnAbsUyKAkaPpCpgYsFk6Hra82CVVQmBturQRNWipkO3u5Vx8cf8ZUtNm+IKXjQ
 aw1NzgK3
 p2jK30g8Zn96wT83fs9bmTKr4vGdzUMQTX4sPKDgxmwYOAT8z49BusCgB6mMX5JIHT3xv0Ku2D5tCO9BfiY4RuXXp1zX9O5PNeNXvFr1a2dQ42JtXKqiysU6bX+ZdxeWehxVV68+FIGSNY1PJlBBi9gFA3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/bfs.h   | 2 ++
 fs/bfs/dir.c   | 1 +
 fs/bfs/file.c  | 4 +++-
 fs/bfs/inode.c | 7 +++++++
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 606f9378b2f0..5fadb6e860f1 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -35,6 +35,7 @@ struct bfs_inode_info {
 	unsigned long i_dsk_ino; /* inode number from the disk, can be 0 */
 	unsigned long i_sblock;
 	unsigned long i_eblock;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
@@ -55,6 +56,7 @@ static inline struct bfs_inode_info *BFS_I(struct inode *inode)
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
 extern void bfs_dump_imap(const char *, struct super_block *);
+struct mapping_metadata_bhs *bfs_get_metadata_bhs(struct inode *inode);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index c375e22c4c0c..30529f476582 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -262,6 +262,7 @@ const struct inode_operations bfs_dir_inops = {
 	.link			= bfs_link,
 	.unlink			= bfs_unlink,
 	.rename			= bfs_rename,
+	.get_metadata_bhs	= bfs_get_metadata_bhs,
 };
 
 static int bfs_add_entry(struct inode *dir, const struct qstr *child, int ino)
diff --git a/fs/bfs/file.c b/fs/bfs/file.c
index d33d6bde992b..335ab07e37fe 100644
--- a/fs/bfs/file.c
+++ b/fs/bfs/file.c
@@ -200,4 +200,6 @@ const struct address_space_operations bfs_aops = {
 	.bmap		= bfs_bmap,
 };
 
-const struct inode_operations bfs_file_inops;
+const struct inode_operations bfs_file_inops = {
+	.get_metadata_bhs = bfs_get_metadata_bhs,
+};
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e0e50a9dbe9c..f1a392394a23 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -259,6 +259,8 @@ static struct inode *bfs_alloc_inode(struct super_block *sb)
 	bi = alloc_inode_sb(sb, bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
+	mmb_init(&bi->i_metadata_bhs);
+
 	return &bi->vfs_inode;
 }
 
@@ -296,6 +298,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(bfs_inode_cachep);
 }
 
+struct mapping_metadata_bhs *bfs_get_metadata_bhs(struct inode *inode)
+{
+	return &BFS_I(inode)->i_metadata_bhs;
+}
+
 static const struct super_operations bfs_sops = {
 	.alloc_inode	= bfs_alloc_inode,
 	.free_inode	= bfs_free_inode,
-- 
2.51.0


