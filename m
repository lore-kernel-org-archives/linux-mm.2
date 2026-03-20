Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBEE61098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E16B6B00FC; Fri, 20 Mar 2026 09:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5B86B00FE; Fri, 20 Mar 2026 09:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9B96B00F7; Fri, 20 Mar 2026 09:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D30F6B00F7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0C911B6E1D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:42 +0000 (UTC)
X-FDA: 84566559084.27.133455D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id A4432A0002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BNfaLQVo6LhCBYQeLT5pep0Iah0vsxdNNiKM3K391lA=;
	b=s10a88bDUzdeVh9jrOIhImmn1POWbo2PW7ewQfhE9JtXM4T3mOyul9WdHTLmHknkILPRIX
	gaJlhyK4KxgLGfZiWXZC5zwn5Aui2GAH7KZeORQl4k0ayOZ9h93pJ/feqM2ePdTwmjjgQz
	5DDmE4tsAfJsuciOcD4avE/H2hkAU2I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014220; a=rsa-sha256;
	cv=none;
	b=T2e3YFlmOuiS/tj23SAc/qSAq871RrnWwMgBw+0G9Gyh7z0jORyQyJtwRgByugG5/Ev2Bl
	zgS6lfyFm2UjRAos4xs32n7vvLy3NaMPPSNZq8ZpSIIKgLaTHdbjOmRFF40MK2zV1GTQj5
	cAffyl3PPZYoQDgfKxlawgPJ6tvW9Ks=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8C2D4D42C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CF2074281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yUqPMplOvWmbCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9B113A0B39; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 38/41] ext4: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:33 +0100
Message-ID: <20260320134100.20731-79-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3959; i=jack@suse.cz; h=from:subject; bh=kco4mMHMCu2Pwd3rYZWTfCMsG7pi8zl424DiRirRcYE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Nre7P5GSgcR81h46uXaYRZ3y8iudX4lYbQ HtS2Pl3DaWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OjQAKCRCcnaoHP2RA 2apACADlaFBjlOXx5jrVVABkN1BRkBxU7ssZcdHQ1iKN6Ov0pNwjjPprzPqlG0G7e1JGZ3Dzkaa iO3GzHmneAuYbk4ADjXONW8UCdbYjzu1tLSZCuG5r2M39x/ls9Zt9h6O1Qv/2YqDKBcIZdstb7u zgzdqx8buKuOC3KpgkEONigG7bRMcHB2Im6hj283rg1pI2tocljGuAOCH5XtfsZIP4jXW5VRXBR /oHZQKFPIF6jZib9eMJ9PCVsl6XVk72s/qJd9rszpVDphy7eWUx98LvpBu3GA1kH6+zmv5gFDHi OIM7+KFlc0KlQdl1YN+OoHXLkPv7Eyvobd3Z6WAb4bIEs87O
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
X-Rspamd-Queue-Id: A4432A0002
X-Rspamd-Server: rspam08
X-Stat-Signature: od68yreqrg9xztfsjf7d7m4xaunda67h
X-HE-Tag: 1774014220-553158
X-HE-Meta: U2FsdGVkX18MJVoRQaHMf8CgO3zfcf5wEOFJQGDv1DcVAwzfMSyGMj4HUK+z2SOxxuxo46ky2MUqOsP808eXAgxGOfvzM3QZBc1/Sajs8EPaOGXsJIfrYLWYdrbRav5QCWv9hHTmYaUQzWfynLyLCTJ7mlBPxNg+qXZOGtXbcStsSRDkaLgzS51qhM4ig1HiIxw1sz9khqbkXcIxR/80WsEZJ/bXJB57njERjIfUwo5ERPDCXjVZwE6NeVfkZ1V7OS5LDFT8iUvB8Ya5qQNd0QPR5as1NV8J38QJCSGDzmEHf0BKhG141qYkT6QyA/R47UhOWSnevYeL7xNPQ7cgTsUujReXkqlZ+GEJ60ZDpuXFDnhEkIKtZ9HcJLSpbJSNgnpwwHC5udp/J5hHxu/NbMR2yOIs9KMd63kKIqvVWcSaU2unkaPn/BHuYSsQ8VtF9zucPrm23LDflpNmbxuzzgWbz5/kfMol51bFSkT+ry8oANO1Q0Tj5zA0wurFYgbB5nFI1p2HvSeSMGmTyuwUHcigtRGGmYNXLY3QaVwncWehhKNIyUbWJOUKREZkqA7ksN5WyOjaD4M7Ehcl5rK4bQM5fh/J2kggBLfPhgc/RpPuwFl2krpanlFfHL7uoFVrMBFtQxXAi5by4h557teNhx2CVdK+ipZyQkSGJb9/IrQILQHLJYMTOkZ3vC+7IQvkgP90V0PCqNoZbbmhwdSqnauN8TmQwH7tnrN7Lv0kgAk/pmRGxBxRSsOFYG74s8Qqm91fQYxDBplOEV4Od0HQIlNEvatXel4aoMwj02u3Fiherh9U8Zl2qBjBffQiD1NEGeZyCjNIjSFl4uMlVxc2zCQRu51M/kV2GUF6NkxiOosBFO8mqLJj3FSAwPdJRhitzqbCNnQbFsY3gL584HK7JuYtK4NlvKmlSO3zaMVkpSvtY04UAOcj7POgkCzji27eDEV+EC0eIT42Z4Sfp3d
 E+lu83Pn
 UexQ6mBgPj4uf2q+AoZRDiPBLM2ywb5tRtpB1rderaMW0lj55tPEauKHpHL3bw+hiiAlAcVcked0zfWZwEacAhEYNrgOPDqOCDH0Hu8OBxj53fV8=
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
 fs/ext4/ext4.h      | 1 +
 fs/ext4/ext4_jbd2.c | 3 ++-
 fs/ext4/fsync.c     | 5 +++--
 fs/ext4/inode.c     | 4 ++--
 fs/ext4/super.c     | 3 ++-
 5 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 293f698b7042..8df3617fd0e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1121,6 +1121,7 @@ struct ext4_inode_info {
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
 	struct jbd2_inode *jinode;
+	struct mapping_metadata_bhs i_metadata_bhs;
 
 	/*
 	 * File creation time. Its function is same as that of
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 05e5946ed9b3..9a8c225f2753 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -390,7 +390,8 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		}
 	} else {
 		if (inode)
-			mark_buffer_dirty_inode(bh, inode);
+			mmb_mark_buffer_dirty(bh,
+					      &EXT4_I(inode)->i_metadata_bhs);
 		else
 			mark_buffer_dirty(bh);
 		if (inode && inode_needs_sync(inode)) {
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e476c6de3074..709c403273aa 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -68,7 +68,7 @@ static int ext4_sync_parent(struct inode *inode)
 		 * through ext4_evict_inode()) and so we are safe to flush
 		 * metadata blocks and the inode.
 		 */
-		ret = sync_mapping_buffers(inode->i_mapping);
+		ret = mmb_sync_buffers(&EXT4_I(inode)->i_metadata_bhs);
 		if (ret)
 			break;
 		ret = sync_inode_metadata(inode, 1);
@@ -85,7 +85,8 @@ static int ext4_fsync_nojournal(struct file *file, loff_t start, loff_t end,
 	struct inode *inode = file->f_inode;
 	int ret;
 
-	ret = generic_buffers_fsync_noflush(file, start, end, datasync);
+	ret = generic_mmb_fsync_noflush(file, &EXT4_I(inode)->i_metadata_bhs,
+					start, end, datasync);
 	if (!ret)
 		ret = ext4_sync_parent(inode);
 	if (test_opt(inode->i_sb, BARRIER))
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 011cb2eb16a2..abc17ef0c9ee 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -187,7 +187,7 @@ void ext4_evict_inode(struct inode *inode)
 		truncate_inode_pages_final(&inode->i_data);
 		/* Avoid mballoc special inode which has no proper iops */
 		if (!EXT4_SB(inode->i_sb)->s_journal)
-			sync_mapping_buffers(&inode->i_data);
+			mmb_sync_buffers(&EXT4_I(inode)->i_metadata_bhs);
 		goto no_delete;
 	}
 
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
+	if (mmb_has_buffers(&EXT4_I(inode)->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ea827b0ecc8d..1b2b4ad62a10 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1428,6 +1428,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 	ext4_fc_init_inode(&ei->vfs_inode);
 	spin_lock_init(&ei->i_fc_lock);
+	mmb_init(&ei->i_metadata_bhs, &ei->vfs_inode.i_data);
 	return &ei->vfs_inode;
 }
 
@@ -1525,7 +1526,7 @@ void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
 	if (!EXT4_SB(inode->i_sb)->s_journal)
-		invalidate_inode_buffers(inode);
+		mmb_invalidate_buffers(&EXT4_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0


