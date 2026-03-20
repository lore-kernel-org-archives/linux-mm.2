Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F2A91098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21936B00CB; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2DE6B00CC; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE986B00CE; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 55CA66B00CB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25ECD1A0200
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:52 +0000 (UTC)
X-FDA: 84566556984.19.836AC4E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id C8B8880018
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=CLOzKuiOLAemdyCXRw/pGtb94FI7PSdZuRuLJlUrPvqYaWOL/os6w9vicqb5LfyvZa5bC1
	r64iDgAaXFXAfkjvEAHLVDY1oIi8BxdynJf/vidMVaTrCEL20ZFbmut61iO4XwnPqBzRKU
	AHYmxUqehIr2liLeMs/3vVw0fr4Nj58=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014170; a=rsa-sha256;
	cv=none;
	b=Tf1GJgxW1p3UBkrM8+F1JDK4AQf+RixXZDXVfZcgwtazoLCdd20Trci15XWcougRcZfEXO
	8vi+8wpKhHeDlRLr4hwQDetUamDHSGtHtAGSrj+6VAW/Hkg5elD9WC+A9ghJTMMlXKYOzw
	LTzt+yvqoEGZ97pygcNTrGbGH8E9Gx4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 698FE5BEDC;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 523B34281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5TYSFJlOvWlzCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F359EA0B3C; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 20/41] fs: Ignore inode metadata buffers in inode_lru_isolate()
Date: Fri, 20 Mar 2026 14:41:15 +0100
Message-ID: <20260320134100.20731-61-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4530; i=jack@suse.cz; h=from:subject; bh=1NKDncz6Z7546ej0732+hXSWl17G06Ctb725RLacGIs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU59nMMCriSqYDkQ+rIxKnPPuxayrxzgjDtg5 Npw+AarQEuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfQAKCRCcnaoHP2RA 2TL7B/9+3M09G8xKSiyYXHTJO/TNRoEGH/s/2BP9I+Z/jzcafAw0j66C0G8g+WjoY5ggjOKV5Ci oi6MpNhW+kmcj3j/qWfQpU7A09glQ43CB5XbDJ2jHzIMtILDN9oYKwVCEcS2ha7JRwNfStB/QAE TT4u78pgrWYuIRUO7aCIHYgT6Kjk+C70UUqfqNuh2XpipH+COC7YXq1NUxA9MfUmICcOLUsbF+0 bLBA2QGR7vv4ZD0bt3Ox1XSHqvyvVmjjM2q4g6LhJPD+AUcogOgEu5Ccewgfd75ddsMIuVttHdc yoB1nmkmk9obTCrzz/aAg4Rh7PqTbgRAG6VkcVuiqOov0rLD
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8B8880018
X-Stat-Signature: 6dmpd1dwsim51cd7w66m67nz6kx1zbmr
X-Rspam-User: 
X-HE-Tag: 1774014169-190392
X-HE-Meta: U2FsdGVkX18YVTNLJbO3UXd6rdSxm9Jw6w9uTzbcpjwbGSo6gCay0w0xVLHroQItit7QqjhANolrzY6JgPWMDszCkWxgKZAV+6DfurU2zyf1wkHxFvtDR+LOoDQR6wOyLfIDnOKvXxZJdzlRemWSLr88p/HEXZoNWVe6Ka1ggOSbpTVNwdcIMs+2ntWZZuZT53ON9UFja435i+QBSINB7IS6wElHsbxp80flbjQgldq5AKmeJ3YdDGhXl8L68e5svioYOr+0qSOsir5rAv9EAhME//XbTLfCrkOFWvMh8/SCapaJHxScUt6AAjWHkNHg4D3NPzwXT9hxFtm4GhRPKHixpUHVM4Xn3gwVtIXyWfQSHC2rJ/6sQ/gQ20pcnPAulYdJvWA6u8HabnUiUNiFjv2+f1N67oOHUttN4CiI4eqMFgXwScVhlIrq4LiOUq3Kg/nohB9vo6PhHb49AcwbKaE0FeSnQ6XawzyVRNYRTC02KpOD9rJloD87SRoUBY3qjoUtSewkv5XEmktnHugNHZod6HlsOrhc/nGzZ1hCaSVjnfFVC9zR5xqWoQF2vCOCd2ltgdNL80JM0UKY/dhVjd7fq7GQpMspBObqSM/x3yiZ2QnvVfj3RXz6Zapf3l+Uk6TzqDbuTy53e9oESpeC5XCXSdSZBWz8ZHJz/piUuYj6WmuD5bVNk8FSURbgKKhkco4QhwRcxPXEzZCWzxDcXWHFHCcy2DPJcKul0GjaJyScUZW1WmAmjeErV+Wg7mKd4HM0RQYSvFiCSjMuzzdvOyYAe2JHPRdkoTkMAwDcBKrxZEY1o3dKTcH6X7GTneNrS3VOqDE1UaxbmBWD3m2MVPBOwtuQ5km487E52XjXWn3QA0BAgQHDcjHBbFL6sJIObOkB5SrFdZuOWSUYZyTH+RQWWYFFMrPZjgzc7YVjqJnYN7nu37gwJozP3fkkT48jWkSkDji7cfizD7YrTxz
 Dw6acc+h
 4k78wiy/gF+s6dROcj46r9VYtm6fRJySXdkSDfy/VRcrP4Scg2YdvrhiL58YDihPkf5ZlDQT8+q7SHpPbtZxfsck5AeC6JNyh5DXCAqtOOGde3Zv0Sd5rZzFippp/ibYEkikHNTDhlHg/+ojuy6tgEcf/zl8GTZzAtOwK73gEEDSJSEFTPeAW5SvqIms6s853uyEupjWOVK3wUtWzxcmsHUu8TuCglsWSspsauqnnco7qtgM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such it is mostly pointless to verify such
attached buffer heads during inode reclaim. Drop the handling from
inode_lru_isolate().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 29 -----------------------------
 fs/inode.c                  | 21 +++++++++------------
 include/linux/buffer_head.h |  3 ---
 3 files changed, 9 insertions(+), 44 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 1bc0f22f3cc2..bd48644e1bf8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -878,35 +878,6 @@ void invalidate_inode_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL(invalidate_inode_buffers);
 
-/*
- * Remove any clean buffers from the inode's buffer list.  This is called
- * when we're trying to free the inode itself.  Those buffers can pin it.
- *
- * Returns true if all buffers were removed.
- */
-int remove_inode_buffers(struct inode *inode)
-{
-	int ret = 1;
-
-	if (inode_has_buffers(inode)) {
-		struct address_space *mapping = &inode->i_data;
-		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
-
-		spin_lock(&buffer_mapping->i_private_lock);
-		while (!list_empty(list)) {
-			struct buffer_head *bh = BH_ENTRY(list->next);
-			if (buffer_dirty(bh)) {
-				ret = 0;
-				break;
-			}
-			__remove_assoc_queue(bh);
-		}
-		spin_unlock(&buffer_mapping->i_private_lock);
-	}
-	return ret;
-}
-
 /*
  * Create the appropriate buffers when given a folio for data area and
  * the size of each buffer.. Use the bh->b_this_page linked list to
diff --git a/fs/inode.c b/fs/inode.c
index cc12b68e021b..4f98a5f04bbd 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -17,7 +17,6 @@
 #include <linux/fsverity.h>
 #include <linux/mount.h>
 #include <linux/posix_acl.h>
-#include <linux/buffer_head.h> /* for inode_has_buffers */
 #include <linux/ratelimit.h>
 #include <linux/list_lru.h>
 #include <linux/iversion.h>
@@ -367,7 +366,6 @@ struct inode *alloc_inode(struct super_block *sb)
 
 void __destroy_inode(struct inode *inode)
 {
-	BUG_ON(inode_has_buffers(inode));
 	inode_detach_wb(inode);
 	security_inode_free(inode);
 	fsnotify_inode_delete(inode);
@@ -994,19 +992,18 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
 	 * page cache in order to free up struct inodes: lowmem might
 	 * be under pressure before the cache inside the highmem zone.
 	 */
-	if (inode_has_buffers(inode) || !mapping_empty(&inode->i_data)) {
+	if (!mapping_empty(&inode->i_data)) {
+		unsigned long reap;
+
 		inode_pin_lru_isolating(inode);
 		spin_unlock(&inode->i_lock);
 		spin_unlock(&lru->lock);
-		if (remove_inode_buffers(inode)) {
-			unsigned long reap;
-			reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
-			if (current_is_kswapd())
-				__count_vm_events(KSWAPD_INODESTEAL, reap);
-			else
-				__count_vm_events(PGINODESTEAL, reap);
-			mm_account_reclaimed_pages(reap);
-		}
+		reap = invalidate_mapping_pages(&inode->i_data, 0, -1);
+		if (current_is_kswapd())
+			__count_vm_events(KSWAPD_INODESTEAL, reap);
+		else
+			__count_vm_events(PGINODESTEAL, reap);
+		mm_account_reclaimed_pages(reap);
 		inode_unpin_lru_isolating(inode);
 		return LRU_RETRY;
 	}
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index b16b88bfbc3e..631bf971efc0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -517,7 +517,6 @@ void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
 int inode_has_buffers(struct inode *inode);
 void invalidate_inode_buffers(struct inode *inode);
-int remove_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
@@ -528,9 +527,7 @@ extern int buffer_heads_over_limit;
 
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
-static inline int inode_has_buffers(struct inode *inode) { return 0; }
 static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int remove_inode_buffers(struct inode *inode) { return 1; }
 static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
-- 
2.51.0


