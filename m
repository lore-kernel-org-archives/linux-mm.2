Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D6FAEC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7916B0121; Tue,  3 Mar 2026 05:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218796B0124; Tue,  3 Mar 2026 05:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A0C6B0121; Tue,  3 Mar 2026 05:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DECCE6B011E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5C9656128
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:47 +0000 (UTC)
X-FDA: 84504395934.21.431EF38
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 645BD1C0008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u0Y+D/ZL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V96DDmGf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u0Y+D/ZL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V96DDmGf;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cs1A0J2AL1T/IRKBpTjU944a9ZIMa3+5mBAmaRi4STY=;
	b=MFC7WEwlf1BYKs6JGkfVeeh7nmwwSOvizky+ov1wpT2lKyVurhVYqXCFqEwQdzWN4Jcr5S
	VGNDwjFeVQWxUchoPLZJL4z+u1ufC7yhsVR127hWxqWZSXJY9z15aQCjiJB6X+2PSi//qR
	0ziu3x1+kb1QmiFGU0Pq3UnxjV/W6ck=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u0Y+D/ZL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V96DDmGf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="u0Y+D/ZL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V96DDmGf;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534145; a=rsa-sha256;
	cv=none;
	b=bp+XUpE9dTPc60PcoApJWxR/xSW3tFWh5GP8sUV0Zmmej+/Cio1Y65c8n7U1BdEO0Ih55e
	xc2Cskd7picOhh7cVF0cgA+kd+CoTkcjRetlrtaEMmLEJvgD8Atd545zseBDMvLkfz7a8G
	An80yO7uHpWeYwQImOD/mOYtJkU3MME=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 546605BE2C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cs1A0J2AL1T/IRKBpTjU944a9ZIMa3+5mBAmaRi4STY=;
	b=u0Y+D/ZLQjwNHn/rJbBqYq/oVB+Zu+ul3X2eXycKEhrl4KbA/onpHPVFS+U4lD9TeZWl0w
	IQYDOUDtTgZljTqDswasRT+WkS0tCgXgtfg1SxW10enGLwGXxtyMcavW4hpOlE7Wj5Q0we
	BGjEigMR5vVxqSWn9LffANSKwqQSBcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cs1A0J2AL1T/IRKBpTjU944a9ZIMa3+5mBAmaRi4STY=;
	b=V96DDmGfvVXm8bYh0kF0rVvHsKTkKq2C7/BZbgPcuYbNJEJgFGMjbw+BgEKMBsPONLOKOl
	MLYjzMhXwGAm/4AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cs1A0J2AL1T/IRKBpTjU944a9ZIMa3+5mBAmaRi4STY=;
	b=u0Y+D/ZLQjwNHn/rJbBqYq/oVB+Zu+ul3X2eXycKEhrl4KbA/onpHPVFS+U4lD9TeZWl0w
	IQYDOUDtTgZljTqDswasRT+WkS0tCgXgtfg1SxW10enGLwGXxtyMcavW4hpOlE7Wj5Q0we
	BGjEigMR5vVxqSWn9LffANSKwqQSBcU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cs1A0J2AL1T/IRKBpTjU944a9ZIMa3+5mBAmaRi4STY=;
	b=V96DDmGfvVXm8bYh0kF0rVvHsKTkKq2C7/BZbgPcuYbNJEJgFGMjbw+BgEKMBsPONLOKOl
	MLYjzMhXwGAm/4AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 489E53EA6D;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aSi7EUW5pmmQFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 162C6A0B79; Tue,  3 Mar 2026 11:34:41 +0100 (CET)
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
Subject: [PATCH 24/32] affs: Track metadata bhs in fs-private inode part
Date: Tue,  3 Mar 2026 11:34:13 +0100
Message-ID: <20260303103406.4355-56-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3003; i=jack@suse.cz; h=from:subject; bh=pZUzO0hnYx3VPJNnxZXYMMaUnllZ7MJ4fz1iv846qsk=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkyNW9q1c7xYSgZn5R/jEDels33OBe2mcj/w GfHrPofXM2JATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5MgAKCRCcnaoHP2RA 2QoGCAC1AqDmWxxwwJdmiEx1bMe1FArDA6tiehKcVHlgsDBx3Fz41skGykdLU5YmWoSsd/pHj3y 7ZRLFv21HDZlEidUx6K9vttxWDGYtNDxXYXqy+DycdDCIqJo+Zov6G+KaNPYnIU8UN44gbENKI8 03QsRQ0hylu9yaElKwqK05RduYivxRfFvtANJ/LMsf5ZyFWrrqnsjxrYsrig0qhXK/LdE6PV4TR zxKWLbRAEhCWOoobEPQf6zWouv511Q1vOCzCFAuWvAQ0vAAtLTYP7hsne8WP0s6gZQMfLvEuZ3s XSEJrSo6ld0J/TDNkpjKdRLSwTwHMc13U8BzGNFWTDV7rGbQ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 645BD1C0008
X-Rspamd-Server: rspam07
X-Stat-Signature: tqih6ci8xrjon3asxmqyjjghdczmb9cp
X-Rspam-User: 
X-HE-Tag: 1772534145-678179
X-HE-Meta: U2FsdGVkX19qWbaG0weSETehXGH6apsRXgsqAZ3PHLFzhL/cE3l6JhWEc+LcXjCmugRQNlEi5za3mWAAZT4KZr8D3gt2hoOovHCmfUTKjISGGoT8eKyIuih7phjjojCIjqsBLgqISWTPrafKpXAbcsA3e8sx4vha+cpIPL3rKPlNqzi7Uoc82BU5m3qXtysuVysbsH3UWSMp2l08qgmXkDvOPkFcGSkswUb4E3+mNwtCo2OxF2Qb8Qtmt3alxEUjPAYZvs6dL9LFbGpB4guftxohA+Wfrjpgh1nKPz90AID8uucZjR9LQZAohnUJomc6wmlo9ao758kjBhWknvLX7c8kTZq0WtZajQFl3zT+7eYEax9YGLo5iEYqFBSrVv33SZ3UwOibyTpI8sNVjFrCrZD9wTHmfL52+PL6Fs5md4THYfeXPIMsum79Li95m1ioHfpVFoNohyUrKj5EYWVXUoDdJm8sZjf5cf0BSQoX1d7ZyImk/f5O/IJSPeJmW1Qq65sUNBwh4TRVRgkidd78BOnIZAzUVNmCpfBLziSKiykfch60nJi55e1tKlRIrQS15GylH4kNfuaHpnHNtmy8ISULDBivmk7Ws3GKFhfRXD2bXFKlU7sGtVI7RmA9Ta2sSt3awCuqidjopzbFF+ab2kfl2a7rEy1GIBYNgLyWwwnZ9Y2x2jileaCk0x40PjNobA7Sv4O23WQSn/8IKd2TBps6rughFx6ovZ7milxVM7eiH3U63nRzxBs914v9vzB2KJnsuVxdPAIVplt3UnU2uSyuxOawL/ipfIRZbQkHjOpzHQKDU7mQrknpKg2DvXcuwOcgZiennrZ5bfiWnn6YkP6xQ0r07kSYmD3xBVdidH2i+GYei6FPJkPuEiraQsjRBZSH5zWc1tKqLRJDxeG0zu/EyzZ8UP3kwTb8Rn/EkZOWXqgjQtR3dGV4hLfHG7ioHH4XvBJqi8BXpHqG70z
 jPnY6exe
 70dgoAEXeruSddiH64Zo6DprWV1VKr3AsIyw4mDEs5vSTK7UlpSaCrnTMOrg2EavCXI7oG4fyN6I9IUFUFNUDoPRW4PiUTHF/bdm7Xz8X/61HxZILgdD9lY+cKD9Gv9mczF3+XsDamt2nx5azGK4fGSfY/hePck7srLpdyXdcfMnVeoT5E58osz/IwounmdWTI+TnILqhba/q0N5K3EU6PnmIPZV+/Ca/lSdSrbdR/+QVnu8qkUYpXiUYbxJP5X/zUUX2sg2JFlnaNPB3xlAOrv7ndDGcFZw9WU8qsQg3cbJJH2+hDJe7nJMHvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/affs/affs.h    | 2 ++
 fs/affs/dir.c     | 1 +
 fs/affs/file.c    | 1 +
 fs/affs/super.c   | 6 ++++++
 fs/affs/symlink.c | 1 +
 5 files changed, 11 insertions(+)

diff --git a/fs/affs/affs.h b/fs/affs/affs.h
index ac4e9a02910b..a1eb400e1018 100644
--- a/fs/affs/affs.h
+++ b/fs/affs/affs.h
@@ -44,6 +44,7 @@ struct affs_inode_info {
 	struct mutex i_link_lock;		/* Protects internal inode access. */
 	struct mutex i_ext_lock;		/* Protects internal inode access. */
 #define i_hash_lock i_ext_lock
+	struct mapping_metadata_bhs i_metadata_bhs;
 	u32	 i_blkcnt;			/* block count */
 	u32	 i_extcnt;			/* extended block count */
 	u32	*i_lc;				/* linear cache of extended blocks */
@@ -151,6 +152,7 @@ extern bool	affs_nofilenametruncate(const struct dentry *dentry);
 extern int	affs_check_name(const unsigned char *name, int len,
 				bool notruncate);
 extern int	affs_copy_name(unsigned char *bstr, struct dentry *dentry);
+struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode);
 
 /* bitmap. c */
 
diff --git a/fs/affs/dir.c b/fs/affs/dir.c
index 5c8d83387a39..6b0314c84972 100644
--- a/fs/affs/dir.c
+++ b/fs/affs/dir.c
@@ -72,6 +72,7 @@ const struct inode_operations affs_dir_inode_operations = {
 	.rmdir		= affs_rmdir,
 	.rename		= affs_rename2,
 	.setattr	= affs_notify_change,
+	.get_metadata_bhs = affs_get_metadata_bhs,
 };
 
 static int
diff --git a/fs/affs/file.c b/fs/affs/file.c
index 6c9258359ddb..4dbd9351eea0 100644
--- a/fs/affs/file.c
+++ b/fs/affs/file.c
@@ -1014,4 +1014,5 @@ const struct file_operations affs_file_operations = {
 
 const struct inode_operations affs_file_inode_operations = {
 	.setattr	= affs_notify_change,
+	.get_metadata_bhs = affs_get_metadata_bhs,
 };
diff --git a/fs/affs/super.c b/fs/affs/super.c
index 8451647f3fea..dff272df0636 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -108,6 +108,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
 	i->i_lc = NULL;
 	i->i_ext_bh = NULL;
 	i->i_pa_cnt = 0;
+	mmb_init(&i->i_metadata_bhs);
 
 	return &i->vfs_inode;
 }
@@ -147,6 +148,11 @@ static void destroy_inodecache(void)
 	kmem_cache_destroy(affs_inode_cachep);
 }
 
+struct mapping_metadata_bhs *affs_get_metadata_bhs(struct inode *inode)
+{
+	return &AFFS_I(inode)->i_metadata_bhs;
+}
+
 static const struct super_operations affs_sops = {
 	.alloc_inode	= affs_alloc_inode,
 	.free_inode	= affs_free_inode,
diff --git a/fs/affs/symlink.c b/fs/affs/symlink.c
index 094aec8d17b8..68fa091bd377 100644
--- a/fs/affs/symlink.c
+++ b/fs/affs/symlink.c
@@ -72,4 +72,5 @@ const struct address_space_operations affs_symlink_aops = {
 const struct inode_operations affs_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.setattr	= affs_notify_change,
+	.get_metadata_bhs = affs_get_metadata_bhs,
 };
-- 
2.51.0


