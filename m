Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C03EEC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2456B011F; Tue,  3 Mar 2026 05:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D56B6B0119; Tue,  3 Mar 2026 05:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF936B011E; Tue,  3 Mar 2026 05:35:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFD726B0119
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:41 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93B088B8E3
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:41 +0000 (UTC)
X-FDA: 84504395682.06.FA11641
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E0784000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K3uKLL8z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=exZfjXTJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K3uKLL8z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=exZfjXTJ;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwONbQuYabmzMkw0cd9UbHOf/oS9F5yVQbeTnfT5C4E=;
	b=XnQknfe6QA8ynrOZVGTr6Rcfx7DbK7OZNB+6K2D37HilflodYOmvBM4ukssc9q+y2i0msZ
	+CIDhYQwQZm8HA5dpCSrjLunsVKHvxcIe7pB4NltHq77mRXRdsESgod1WxZuZZkaGfJTRU
	Btm8qMHm2pkZC4OpzX6nMrQaUW3tqes=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534139; a=rsa-sha256;
	cv=none;
	b=ffr/oG/8vSoHJ8RM6tePicKljshRh05JQVlxgci+2Zxw4WDBJHOoj2j1b/lJkFmJZ8rG2f
	A7vWMSXV+iOKUxW7sScnNTafn9Tcy9cH4SJdvfNmFe8Na+Cvye/V5PQa3PJflTqIS0et56
	h0arRQYknv+KwU0cPi7dr+Xwb1VqY1I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K3uKLL8z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=exZfjXTJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=K3uKLL8z;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=exZfjXTJ;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5171E5BE29;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DwONbQuYabmzMkw0cd9UbHOf/oS9F5yVQbeTnfT5C4E=;
	b=K3uKLL8z1VISPzpfs+FsumelIjhVeEpjLWyZAEMOw8WHCSxFNUI/GW+f8F8Woyw2KIn4ku
	Al3Uxq2gSFf8X8fOf93zKgl14HsGoS8fBDd1FayJZD2pVuAG4qATYKlcVF2q3teI9Sbl2O
	U4WExvLMAj8RjSyONfYlvl4+L0cLA+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DwONbQuYabmzMkw0cd9UbHOf/oS9F5yVQbeTnfT5C4E=;
	b=exZfjXTJy3my1djHhStLbKl9ZZrdwkZz3Wno2MndXxN1RvdPaiTN3zRhHsMCrxYYkSFZ+b
	+nbisNz9uDSLWiCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DwONbQuYabmzMkw0cd9UbHOf/oS9F5yVQbeTnfT5C4E=;
	b=K3uKLL8z1VISPzpfs+FsumelIjhVeEpjLWyZAEMOw8WHCSxFNUI/GW+f8F8Woyw2KIn4ku
	Al3Uxq2gSFf8X8fOf93zKgl14HsGoS8fBDd1FayJZD2pVuAG4qATYKlcVF2q3teI9Sbl2O
	U4WExvLMAj8RjSyONfYlvl4+L0cLA+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DwONbQuYabmzMkw0cd9UbHOf/oS9F5yVQbeTnfT5C4E=;
	b=exZfjXTJy3my1djHhStLbKl9ZZrdwkZz3Wno2MndXxN1RvdPaiTN3zRhHsMCrxYYkSFZ+b
	+nbisNz9uDSLWiCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4735A3EA69;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k9BhEUW5pmmNFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0FC8EA0B74; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 23/32] ext2: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:12 +0100
Message-ID: <20260303103406.4355-55-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3405; i=jack@suse.cz; h=from:subject; bh=UrmjGTMvHvZZjH02z1XUu785Sp5RrC55KME1GrjfSwI=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkxPTIrpOhxsJb9ZsjxKcs4IrTg4qj8j1Vyv zpv74Q/WN6JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5MQAKCRCcnaoHP2RA 2QVyB/9KEXW0GTRN0Ow40ppibeT21iam+b4Y5r/71K/luqeJNO+H9cf4SQ1qz10s2xadiQw9ZNw OsTk48Ll5MKrWuhQxKeRbJx2AqqownV2pBkWvI0tsoFscexzQlu3CDOotHIjaVNPEGY9TLgO6IL S4dcwnVSrvKRmsXV4ve19WLysXS4MwffK/EYT7eHOKTQjvO480pSSMa9tsrKXEx0bJt+itH0OAH lhy6/CvzsFb7Qd8IP2O07qZ6ekVgA1UJrboT5K6jOTk4JUVqbfOGibE//wK4JFv8K8sZTzTlA9A Axg+6m5JBTJJQF83OXHr+OA2wWHVojl9YHU63B1ST9u/vI07
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E0784000D
X-Stat-Signature: c1rzx3p9z5a8kmqo6mbwbq7fg15tfysq
X-HE-Tag: 1772534139-557481
X-HE-Meta: U2FsdGVkX1+KZHJ2SlTbF+fKI8yIpIxDJaafOGnDJF2gP+TITko6XVsVNG7p7Lr+nM3D3hR3GwPTQXuCz+WOBfMBI3X8WFpJISXK8VMNoYPbiN/1GH11WfWEoeYs7F2FNYA6sQsrgRmTBJSitCUnawnjvyXup3h5xJwwSRK9r6bRNvz8Rj3h14slwiAwlTHXjfKf9lZCJLIJWnmQBopw9w1XHKTQir7ltRoQHJfVJtZNaGE1mMCGlLi/Ttufi3HlMndL5vb+pwG7pGIRO9kSF3AfZXXZODUnC7fJucv0xv9UMD8IVbMGJ4xQjdszZ+7MpMlRVVjRO3xOmwCymNpPgmLQon5Cp5+tDwKe6TXHnECvYH87oibsLsZFJWciJIt4iYqcEt/9po1ZmTnRESz4bg/Z5idwBLVqsSvKLxJW6DxGn2spWzrJF4Nkoi32RRbdpFl3d9t0W/WhbDmpeg3faJPnF3jgRJnN8tlU7AKbFitfoDgjjDqIc26xAj9cptgsCvGLjjFHHMfJ/boiGkcI7tFo00JdiNNVAmiXsYWinGKMsb1EQF2sTdL1MG+aM5w7nj1SG/U3Smg2vaZnr8ureLFGHvJfrjhCncvKecyVYIU7he3DEq0AKL72UrG4CQPB11YC8bySkyKNe6M0Bgrtlhgme315TAcqsajdAeukaDzxG0E7UGohVkJIf/tecb1mAOUy8EeOp1U+6qzTi4IqaqqT6NfMzfEYIANYDPJMSC+avCgj++4SuYNWVR/MabhLr7HKZapfYV5tr4SSTv5JeWJadYRnYKoAURxUY4a33omZ2JrUVwaCvFp1/f6oWR3bO6O21+mOXUobYgQwNt/7Y71HAhNljcI35LyrlQWrs41Vyi1JOMtNeyeFnixkSzg8TxLrhL4o+6JWRgIVrbGyx7W4okSKE0EpMf+BBQnrRwFaCv16863W92P2DrBM5YLfaUuaDuXsKBpNlyDF63e
 h4+SopTl
 NWmo0W/TtVZCW6N7pnuoeRJT12cqF/nIJS8xau+ND14osJ5Y0L/1O8Pxv6PImJupzdloJbsM9fi7JbaO+MiY1ICm6VGOEd5M8LCeTVTFBPZW5hcr664/5KDy3Mvp721oNJGXmOWghtq+p/FfqUDsSlSgabCasAoLbTuVVrGlxK2vIlJD9XMWf5JuUCxF0ZpzGHj5O297bfR8MEsW7y0jPWnbGagfqXupWI5rQbfZCO/QZTb0bEsSON5E3sTfkLH77+EYir+kXgLRRA8DgE5OGgqlkWkDh6Yfgq97Q/BS/YoLkFkjmO28zx2bRbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/ext2.h    | 2 ++
 fs/ext2/file.c    | 1 +
 fs/ext2/namei.c   | 2 ++
 fs/ext2/super.c   | 6 ++++++
 fs/ext2/symlink.c | 2 ++
 5 files changed, 13 insertions(+)

diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index 5e0c6c5fcb6c..2b6593ba107f 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -676,6 +676,7 @@ struct ext2_inode_info {
 #ifdef CONFIG_QUOTA
 	struct dquot __rcu *i_dquot[MAXQUOTAS];
 #endif
+	struct mapping_metadata_bhs i_metadata_bhs;
 };
 
 /*
@@ -766,6 +767,7 @@ void ext2_msg(struct super_block *, const char *, const char *, ...);
 extern void ext2_update_dynamic_rev (struct super_block *sb);
 extern void ext2_sync_super(struct super_block *sb, struct ext2_super_block *es,
 			    int wait);
+struct mapping_metadata_bhs *ext2_get_metadata_bhs(struct inode *inode);
 
 /*
  * Inodes and files operations
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index ebe356a38b18..2dbf3e7c2e9c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -338,4 +338,5 @@ const struct inode_operations ext2_file_inode_operations = {
 	.fiemap		= ext2_fiemap,
 	.fileattr_get	= ext2_fileattr_get,
 	.fileattr_set	= ext2_fileattr_set,
+	.get_metadata_bhs = ext2_get_metadata_bhs,
 };
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index bde617a66cec..70c94adce837 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -422,6 +422,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.tmpfile	= ext2_tmpfile,
 	.fileattr_get	= ext2_fileattr_get,
 	.fileattr_set	= ext2_fileattr_set,
+	.get_metadata_bhs = ext2_get_metadata_bhs,
 };
 
 const struct inode_operations ext2_special_inode_operations = {
@@ -430,4 +431,5 @@ const struct inode_operations ext2_special_inode_operations = {
 	.setattr	= ext2_setattr,
 	.get_inode_acl	= ext2_get_acl,
 	.set_acl	= ext2_set_acl,
+	.get_metadata_bhs = ext2_get_metadata_bhs,
 };
diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 603f2641fe10..503c25cae27c 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -215,6 +215,7 @@ static struct inode *ext2_alloc_inode(struct super_block *sb)
 #ifdef CONFIG_QUOTA
 	memset(&ei->i_dquot, 0, sizeof(ei->i_dquot));
 #endif
+	mmb_init(&ei->i_metadata_bhs);
 
 	return &ei->vfs_inode;
 }
@@ -259,6 +260,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(ext2_inode_cachep);
 }
 
+struct mapping_metadata_bhs *ext2_get_metadata_bhs(struct inode *inode)
+{
+	return &EXT2_I(inode)->i_metadata_bhs;
+}
+
 static int ext2_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct super_block *sb = root->d_sb;
diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
index 948d3a441403..c82a15d28772 100644
--- a/fs/ext2/symlink.c
+++ b/fs/ext2/symlink.c
@@ -26,6 +26,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
 	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 	.listxattr	= ext2_listxattr,
+	.get_metadata_bhs = ext2_get_metadata_bhs,
 };
  
 const struct inode_operations ext2_fast_symlink_inode_operations = {
@@ -33,4 +34,5 @@ const struct inode_operations ext2_fast_symlink_inode_operations = {
 	.getattr	= ext2_getattr,
 	.setattr	= ext2_setattr,
 	.listxattr	= ext2_listxattr,
+	.get_metadata_bhs = ext2_get_metadata_bhs,
 };
-- 
2.51.0


