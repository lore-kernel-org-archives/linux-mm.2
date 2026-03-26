Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDF1106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BC486B00D1; Thu, 26 Mar 2026 05:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B266B00D3; Thu, 26 Mar 2026 05:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E436B00D5; Thu, 26 Mar 2026 05:56:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0936B00D3
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:56:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBCAD1A0C77
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:08 +0000 (UTC)
X-FDA: 84587758416.11.43B97E9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6608A16000A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:56:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PchJBn/u";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aIlNik5a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PchJBn/u";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aIlNik5a;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=vvR+3c9L1tLFyNVy3SmAQ4yfN7HVG6YqZMfbvoCF+nfTnloqrqqldwXATrtApqOBlIMAYs
	OiYKtdWDXT0MmsEeXRNhrLqerR3eD/XM8zE4qcY1A4cAZyBeXQOGsVq1paCrtpkbG5lVVw
	u4DkA9+3wFdrxYPr8qNgGVyx2uqn/D0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518966; a=rsa-sha256;
	cv=none;
	b=ap+svHYywsCCxtCY/w8Is+Q3yiGP4r8enMsMoo/0vTlS1dyk02OTppNNFtX/vVtbemxiHL
	6FGsAVnKdZBuTZLileaE8GvHdsP3L5zBcQgDGmEKbLxSvkLFJ2I+Ng4EOge5f66hg7GZ0C
	oggETRSOjTuO9YkzPb0fWwDLcHnRSqc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PchJBn/u";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aIlNik5a;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="PchJBn/u";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aIlNik5a;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6DB974D28C;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=PchJBn/uiTvq9JPs5YdpwIpkGADAGywcq/XzSfN5A7bIcADmY5EWFUSCRI+46yQ97gsr2Q
	ihOXWFEHPrMiKIy2YR375+wv2hN84FzbSR4sC4OAW5GSkSkOu2RPjJkdQPD+hjAQWg/dq2
	TVp38BnsaShR2F8A10l6IIcE4DdG3NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=aIlNik5at9LkIhV28LQPBrMgymP0PX67T/TWqbRKdECkYcZR1k/97LdqV+W8M8E6hzEylR
	dJnaNV8NL2QKYmCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=PchJBn/uiTvq9JPs5YdpwIpkGADAGywcq/XzSfN5A7bIcADmY5EWFUSCRI+46yQ97gsr2Q
	ihOXWFEHPrMiKIy2YR375+wv2hN84FzbSR4sC4OAW5GSkSkOu2RPjJkdQPD+hjAQWg/dq2
	TVp38BnsaShR2F8A10l6IIcE4DdG3NQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ooassw/QDamRSv4eFDzDiWF2BAMQ/AyZZpBBDh5GTkk=;
	b=aIlNik5at9LkIhV28LQPBrMgymP0PX67T/TWqbRKdECkYcZR1k/97LdqV+W8M8E6hzEylR
	dJnaNV8NL2QKYmCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 57F924A0AA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BRF/FXUCxWndYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 38E91A0C69; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 22/42] fs: Ignore inode metadata buffers in inode_lru_isolate()
Date: Thu, 26 Mar 2026 10:54:16 +0100
Message-ID: <20260326095354.16340-64-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5025; i=jack@suse.cz; h=from:subject; bh=1Pb/adcwW6xrIXddFLxPoaBb/An4k4KZgPxdu6Dhu5I=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJFtk+WjKSBCWGAdpRK2Za/U9zFgKL/kcR2N V0iH9fht2mJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCRQAKCRCcnaoHP2RA 2SnUCACuln/mI/PxPsTv31M30XutA1/xSOjmZ6AQO5K2A1ahrTHIc0T70YSIapvlrknLfBNNsEM pUmqJhBfFrBLrRIr2GxeChP5WbLAx33I8aSZ6pP1F5Xu1Ph8NDy1nHWGd2WDJXV1Ro51K4Fqipo Z7wUaHwo+fMOL4UlMdl1dUh14YMPFGWUbwFNac9YgfNoyE/zRXTE3UHHluxIKPba9kxbTgsq7a8 IlPCMFbgoV7W7WTFtBbFS4/lhyAnK9nZ6ZKLkTAgSmWZi5R05jR+o0yn4eSCa4LVI1haR/vKgfw eTFQcSXs+/djg9oah1jPy1yABt2NMFqxn5ZtEkTR5mgUS4w4
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6608A16000A
X-Stat-Signature: zi1h79e3sb65gigubjhjk3bwzpumobxs
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774518966-48359
X-HE-Meta: U2FsdGVkX1+U7ytDF1PRDHRVmQ3Ulamlf4+e6mTaYIJce4RKr3ZFI86t7sj0PPvm2JdkM94knj7wNvUAxhzzQ1bQt2wzsBvRrdYOPYb8koW02EXk2nf2S3KH+rrMt/m2XgJTCEt7jzsPuvfxU5iCBC2mq9LqxbT1FAnMklz8na/nBsQBM4++cSgw12/wct6hMkzdI09nZFxPTCBfm5Zpsv10IEo4KouM6E5SjUCDmK85549BKjhdxTdK+hmxMFL985cBQcY0t84TA5ogPhSxAs2HDicCF6QyNisu9u80iUXRDf2jTyWUdaQyCkDpPk33EQrTMkmL6x6D4/cg++sTvs8Ors1HE9QjO7XkAK9LIzPG2qZQgCEM5T2HSrkoYhE/peRFLuFtPJXV3BwLfacaSlXwPJRCQh/nDlGdgPFyipP1CaRydcfH+hoha+jqxqYD+WvmJwPHuxz+dxcVEqeDSXP3AA6OkSjOUMphXuOaDvNcFNKJu0AIXrUBxkdNqp34NbELi7+f3jJmHDk2BBTasYBNCn1qx9Ra9xZM6EFoEJuU16r42zuRM0jDc0SxOSlS98Xnzv9dtOv+Jmxzi9dpGqWVirhNxqUpHkVVMOCv12qXxi46jWS2QyrfP+ifI+c1DtdT0R+IrUWVVJlGQsc4PlVSxxUnWxCe0MumfsEu067+UcBXjxLIDB59qkkGGmBCOEfo3pqt6GN+bvo6G5QHx2l6i5gLghhKvXbD3dzHVNFdF1DrZWZ5oMmw4VRV0E/GVuqwZO8F6lxValqz3WoTxbEH6Gp+xfOBaGLdP0hF7n1sevv1i2XERXOVu8Zw+QvvImU/kzb5qKija+KJKvcvgUsRIJPQLxrEDahUtivHFjH9K5NHdSi+sg1GNtricHKjFsCchLNiFAUdC0LKPba/Ydt6Anz4BdQ+/Mt0BHlHacSdVYY2LLm2ld44RpSvpY48E7+TanusmsGTgoTy0vV
 oaiHxFxJ
 HR4D8bP1KCFXwPL7TD4Vjf3/3MISflhphKA19Uy2Qa1X+J2CQor+TnJsNI8BUEZ7Z/YLqqls/FeniJRJYuO+9Ep7xVV4nGDImHUnmXk2alZuv7F2cZLyNDsZh8ctQvpuXQeSyqMK1sZV8jAPjhYKmS6vurXygcz9dAJcEvE2CRgxXeOtw7m/5geabHDDdKqKVMOvT5TbINZFCDlMtzJ3yhOuWeNoacOjkARLDuTFSPUNxvOyCrM1eC/hy9FefXG16Pb4hF0bkHo4iMgB/B3sOZNbsKkvvmH16pgmrM/z+UnMIK3BtkOpXVmAET/pZ13rS0y5DEqniMAKt/DNX3j/LrD1e1BDpBf+y6+eT55DC/2uHrzPs6SIuabHZm82ShS2Ey17VAAii/j0CwpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such the logic to reclaim tracked metadata
buffer heads in inode_lru_isolate() doesn't bring a benefit big enough
to justify intertwining of inode reclaim and metadata buffer head
tracking. Just treat tracked metadata buffer heads as any other metadata
filesystem has to properly clean up on inode eviction and stop handling
it in inode_lru_isolate(). As a result filesystems using generic
tracking of metadata buffer heads may now see dirty metadata buffers in
their .evict methods more often which can slow down inode reclaim but
given these filesystems aren't used in performance demanding setups we
should be fine.

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


