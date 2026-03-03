Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E91EC1426
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272106B0106; Tue,  3 Mar 2026 05:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247C46B010B; Tue,  3 Mar 2026 05:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4A86B010D; Tue,  3 Mar 2026 05:35:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC6696B0106
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4D9C1B7D07
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:22 +0000 (UTC)
X-FDA: 84504394884.23.31934CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 684D4C000F
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M7DXaxKW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+K0D+oFG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M7DXaxKW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+K0D+oFG;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=0gaj+5TLYhTjPWj9NGDujSKqBwFPEXHvmhnj1XQZjFgG5F2Ko0zS5tpMEJfAbOtvzqQCkc
	zbu5ftoj3LEFak/ncPtJf5rB7TR/QnF1ARem0OT78AiTdDuH/wZ0Hy4ccEVCD3s89eYTrI
	nlAH+kYwjsmTaaqc0A9KcNIZI6r5/ug=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534120; a=rsa-sha256;
	cv=none;
	b=30z9VHfG9ZeLnQfek4N6vQE4nTfMqS/O0Mb9kiWi+6yQDiy7ffygpqj6caPtc3C8nsNV7Y
	N79IoaynAeCRjmsgsf7aP/bLI2WhVesh+oqtApK6qX9nD42VNhqdT+Kb709wya9SQF2gYM
	L5FCcW2y3OUt5ziylTZpVsz5D5u8s+s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M7DXaxKW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+K0D+oFG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M7DXaxKW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+K0D+oFG;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0AF845BE0C;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=M7DXaxKWtMRyhYr4MXQXP6J3y/jaodo/RheHYfA9UHSGBscRpU2T6OFDkfXtPOyUvefgOO
	y+Ix/lBY2xPeEip8z8yCGhYlfG7fAzWQ+QGzK/GK8j8jXpvWjLvL5d9Chr6PpH0PKDTYUT
	5tASa3cjE12uvVtXdGmB2eVWl21HXJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=+K0D+oFGYJj9IebSkPj92AyGF7Sa266jNkXcYqZh4jtDIc+G5TeW9Zfhm83n4LkSEpz5Fw
	Ka1HufVb7leimkAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772534085; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=M7DXaxKWtMRyhYr4MXQXP6J3y/jaodo/RheHYfA9UHSGBscRpU2T6OFDkfXtPOyUvefgOO
	y+Ix/lBY2xPeEip8z8yCGhYlfG7fAzWQ+QGzK/GK8j8jXpvWjLvL5d9Chr6PpH0PKDTYUT
	5tASa3cjE12uvVtXdGmB2eVWl21HXJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772534085;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CT96S4tH9al06cTh68ySZsyxIYDQSszZc+Xp6SlwUwA=;
	b=+K0D+oFGYJj9IebSkPj92AyGF7Sa266jNkXcYqZh4jtDIc+G5TeW9Zfhm83n4LkSEpz5Fw
	Ka1HufVb7leimkAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E6CB93EA6E;
	Tue,  3 Mar 2026 10:34:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tOBXOES5pmlpFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 90541A0B3E; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 09/32] fs: Ignore inode metadata buffers in inode_lru_isolate()
Date: Tue,  3 Mar 2026 11:33:58 +0100
Message-ID: <20260303103406.4355-41-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4530; i=jack@suse.cz; h=from:subject; bh=1NKDncz6Z7546ej0732+hXSWl17G06Ctb725RLacGIs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprklnMMCriSqYDkQ+rIxKnPPuxayrxzgjDtg5 Npw+AarQEuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5JQAKCRCcnaoHP2RA 2a3/CACPcN2MGI8XOdNvj6lYNDpYzIauPZkNrq3/RzSFXGzTPqgxcnHr8X34xE8anKLvRxDYgAG 5LUHHGutowHrO5P9h6RAn14sQhLuiJzxtPXOPD5lAdeblGtEuj4UyuBpTWMzJjI95nrkck7by0j DLk75DjlyAL2z8O1ejUazo1fzJzOe4hr6icYFpKeen+EpjxOYfEtTEBt4IlmwmsV9SZvrSxh3yK /BIxxSzQESb/o8dlFAbOGyejp0bZIFGBu7dudmhFrXiEMSZ1F1j3MA8lIHtpYoa6HNhhMO2BKc2 HRYgo9twZh6ov2fh07w+a3GI3PDO+Uz2QTgR7+sOZdkIc3mT
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 684D4C000F
X-Stat-Signature: 7hge4rf4nzn4o3joho5hyzn8yg5zu9e9
X-Rspam-User: 
X-HE-Tag: 1772534120-454120
X-HE-Meta: U2FsdGVkX1/FkmWVPuxIhkIS1A97QBzX9G6RnOBvIpkyuSelP0iY9y88/QwmuUvEkyJJieDaAddG4HxP6Qhm3I4thu+pQU867fuMZ5tmz4AIvICQvRrkpB9s/d4kYULTXG8Djp6hIx1zhcVXGNk8YIKjcpzlTlDy8k7hBO1lx9L+ha+5fqTXIRBYtfUiFA+PUrw4A4hhP8EIO3wBT6qc5Uzd3LMcFf2/KqFMDozwXm57Tn3yh4v9DwmIBAZa6LcR6YJ5xzjBD5np/93+t0n4A+CroKtuEX90C6sBeB6DxNHCgUV9Mqqdh8Au/AJoxeKR7O2n7iFKWsrH0txeDi3BsjKyzwmqRspfgq8/ZxmqV05krhzGceXQW6OM910uP4YDMwFnK5Bu+XJFMj+H6tUXky85UQYGEPo8/FShAdX3Kdy0fjRynZ9zsMSYcuAxVOuPr3AsX/muHGEFjM/LdiH02ECtzPV3M1m1quHDskvk0JWISrKwfMf6yYAP+mztEVmR3LuDHB5oQu0ZkQUejquEu843bwBbJ1Hu8QIfwk47sZCrVZQNp34uZRC4FPYyooL/vcOuZsFcfwnhK1AX9zOuIbmiquMDDn7j/aZXsMPAe4C8u1mSKnd1Ij/sIfQ1Vv7vDt3kdZMqYhtfel1RcuuSls2nYfqzX76Xf5A/nfile4q8hnDmoluc9O5CFwIxwaL5PRooQDdKNM2rngIquHmfW8yGzgYSvq4wOlHYdaoG6EQ1O3UfDSLy8a1IouXKqxiup6ISbJU5ZeYLL5+IDtJW5G5CZP5dtF4Imib93kDzcbuWJ+aCpUeYB7lrgabk54fUpC/k2e3Q205uxqwRfqlPR6pZXY+ba4+0bI6+xlmZ0QdXVCaJvia3vHm4GRKGtboTWu2CwfeyuhObk1Yl2LTMOxKVugMi1BLQ/NPQViR2AM3GAfWOa0JvyU3hm8TQ2dzhFi9/n33Jwi6XMQcAM6L
 0Jun086s
 JsoQiAGnv32AN4W73C2NKH/QUIfH+P7ZWQE8CbQ7lMwa4G90qb3LXjLKdfJjqkG7CTVI08qUjwZSoQi9WjXxpiZmKg/3TXMdENZ/NRXdn8j8H2+NchoJBNJABPnd6xD9nHIzuRhskbkT+lMxgRGYCq5djk8aeDYLi9qCPwIsC8Ox4v1eYzHC58JSONPXXCozIPGFIUNFvGHibTmgPQC4aF1N6LXIsmL7nX9ynWwqU2+g4vsKhxtYlw/qchnfULpr4PCJeHvDLvFfWwmIdT5XC+LlhfcYUdgE5VcM+2Y93c/UDAt/VpsJxt3T8+PBLQO13hvgT7qPJCdMMbgmtkGn1uNJfLqSliw+udN9gvAcPIELoX2P3prGje8U9UwurMFXE9tVYrnzrWK5WTCM=
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


