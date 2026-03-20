Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A651098785
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7654D6B00ED; Fri, 20 Mar 2026 09:43:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 677E96B00EB; Fri, 20 Mar 2026 09:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406926B00ED; Fri, 20 Mar 2026 09:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2381D6B00E9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA30888DDE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:23 +0000 (UTC)
X-FDA: 84566558286.13.A78553C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7B954000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gsi6VMjy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9R/ObUyv";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gsi6VMjy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9R/ObUyv";
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVhGsrukfbRf2CAex+Tv7ykv3zYa6yuMffmemT+GbaI=;
	b=HjBywdljhzGHotM2Tdmx/FL0MDEeuzBqe1akH+fSns4qtSBSXMoIyHgEJk4CtmFZpvFJpB
	yf1U83ZgwgKxJLrtrcG4WLTI67NbMmTqgrlg4cTxCCtNhiL4dw/VqFlJ3XxBqGzSYMbtci
	u6OJ90fp16QibZFcaCywM51i+kWkC8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014202; a=rsa-sha256;
	cv=none;
	b=uC0TGCsjkOPRorFHydpVUNC3MmoGK2xk0b6AP28uscU/RuFzECyD6+xhfkdyO9/lPDf8nF
	AZt5CKyZMFzOzddPo+SAF12P2UHBG9yQCj6CHSm4yUjcnW6oECPTZWQebTxyVruwiJ/mL4
	PpoKwE0NLSM5oiVUZljYqk7Dejm7BnQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gsi6VMjy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9R/ObUyv";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Gsi6VMjy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="9R/ObUyv";
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9650D4D424;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVhGsrukfbRf2CAex+Tv7ykv3zYa6yuMffmemT+GbaI=;
	b=Gsi6VMjyUprBYkIKML8Mbg5hT5Ow7ksGTzNFd2Ik66cJe5ZGPbD4Ev8cmRFgdDubEmU9+y
	g32c1gotQ/QOu6HT4yWUJS2S2MkyX5NZMS9sn6gVQudY8hfYWdc06/0iOfj89fYDc/plrx
	/s71guX8e35FdfZyeyxFEG38v8H5iEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVhGsrukfbRf2CAex+Tv7ykv3zYa6yuMffmemT+GbaI=;
	b=9R/ObUyvs7GYvNn95nL0yQ9MEXR5C22c9JCeYjLCtVQZt0vY5zS5pY7dBH6SxjxFER+DhT
	Gb0/Ltx22ls1L0CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVhGsrukfbRf2CAex+Tv7ykv3zYa6yuMffmemT+GbaI=;
	b=Gsi6VMjyUprBYkIKML8Mbg5hT5Ow7ksGTzNFd2Ik66cJe5ZGPbD4Ev8cmRFgdDubEmU9+y
	g32c1gotQ/QOu6HT4yWUJS2S2MkyX5NZMS9sn6gVQudY8hfYWdc06/0iOfj89fYDc/plrx
	/s71guX8e35FdfZyeyxFEG38v8H5iEE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BVhGsrukfbRf2CAex+Tv7ykv3zYa6yuMffmemT+GbaI=;
	b=9R/ObUyvs7GYvNn95nL0yQ9MEXR5C22c9JCeYjLCtVQZt0vY5zS5pY7dBH6SxjxFER+DhT
	Gb0/Ltx22ls1L0CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 88FE54281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rj1wIZlOvWmHCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 510C7A0B39; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 29/41] fs: Make bhs point to mapping_metadata_bhs
Date: Fri, 20 Mar 2026 14:41:24 +0100
Message-ID: <20260320134100.20731-70-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5923; i=jack@suse.cz; h=from:subject; bh=Ow+0LtCsQTKqqSguAdQ+WVupOCKaNyGhbPBURHHVr3Y=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6FrKTYpVkhalodCaSFgZ8NSjVZCL3va97Zm dLkzr//x2GJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhQAKCRCcnaoHP2RA 2aQkCACYS7kEYg3k1MxZWtZdagH5iaJJAmJv7WzI2RT5UYEZF0EgTfNvWILTxefi3KH2v04ozVa v66obXb0BMV11JeCUY9Y4vIceeZCRZg2oGhSY6IYy4Z5fC4JCDpD98LOGiIiuWhz3NvQisfC1yG jtxkTdfsCvaf5ogC85bwBqyk7Hw+0YhA6gbgLCFAm+j0FeZPVYddAPWCRMoYmhb/bGu5f75nTcC Huwz5LYHOsoD2acs5TJVXdKO2XJwSteiqyNWk9crG9kPTXpArEmog2DOr9Hra7+8ejDk/Flqtk6 v/2RauXQXiBSBBfuJnVFSRk8hciyLqELa+i43Auyy5U9yhcg
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7B954000E
X-Stat-Signature: sq4c4a9yxdqcsf7ejcr15rn9cd18pbnz
X-HE-Tag: 1774014201-76418
X-HE-Meta: U2FsdGVkX19PylOSI+tNowYG1PX23umjwlgHwxJgzqR2Tx5z3OrpAuyI9fc2pRnxwVrssv2jAHl4jeJS31HQu5lHGv98hi9L+rivNM+S5p+oF0AzJEasW9zGin+ce/67T4WOdCLQfB2lWSZnyVNLlI50n2DOldp6rbrIe03tw/Pbkzcaz54G6OGEGVH3V4t7KYLxgCTGso7rMINoVqZ6ZBFtgDLxsGsS57ZuKx7FZ8e1IlrU18qnqeqOoTusScqlq+vrGY42A7HEetYDQCsD2LozWKTkLnJGQSt159qUC1jH5pQO5pYrHZz0VigRBM7DoKOiofOrPeXfEO8iEOCMOCft4fWk0AepscsVaKxI27u7abD8RfZDWM1i84D6MiTXAcmtyb2xzZKGZcPbdTPBidOG2RxZqKo0vTQ3MK24dN/Fr7VbCV3xG4JzQXLXBD1vTMaBKOBgJ+DsRb+t6joo6Ypc6Dm8o91I9QSFlekbGY83BDOqn9X8x1tJgkwEwAvTFRite67/iT8kr1D0bis7hATgUBmZ0RNjzi42fZ3kyRQXbCdSM5/7nE4Ee9b5BmLVgSuIdMOFCRMtgtfsfyQpk8vUziSOeM9mFETe9Z1w+NU1x1yytemMyEeaNy5TGEoOj87dAgfzWwwainC6xdB5r+cqwQ5MDXmli5XSwPmy19RS0Olm8qWFbcVEacN01pphSNup7jjU7IEBDqX3r5ZZf890/URmjmu74ycreXK716Ooq04YueaR4Bctcm/487qZ5845ari7dBy43hvQ5xPECKxLNH1MC6asmF4FM6fimDac4+iqUvjBzWHDAQV8BhxHHOtqUB5t5QVvJF4NhP/duoKORj/VGwOvZ7iQWYtUZiXCmsFo3Xe3kRBuLFgkQq0QjlQcAjKRLz8640VArcFLwXhIwJTpt31wIzlFLVXkaMJM6Q60D5aCoyQaC2ldEUnaReT2GTmKNYt434U9LuG
 Pa/6ay5A
 LKVsU+Zrx4m4F4PtSe/HmSzLSOcBeTXJmB6b2gNCWJ1hoiCQXOeT79XphcMJX9u3eE4VU2Uns5jOhuHDVqjKePZV53JGRWwxVWp03xxszunLjN+7gmwmUxOqSCXQIsLFYKBsaCuINRoaT1xVC2/Hbwm99CWJ3zoPVSOuvcvsvuWyaUJsqa5u6CUbucf9UZuzovyY4xTysqmwxDrODglTSAvocE5FOznMNHoa6R3HpM4rIABmVgoI794j4e5e61u4uFLKceYcAnZsNX81yk580VkDV3c4JgKsER7pk/qrmBT9xysBh2Szg1iA4nQxEnVf8OGkN+inUuSx61lXXuLr0r/IZR3H1TlYWwCOBhTNRO8JT5AM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make buffer heads point to mapping_metadata_bhs instead of struct
address_space. This makes the code more self contained. For the (only)
case of IO error handling where we really need to reach struct
address_space add a pointer to the mapping from mapping_metadata_bhs.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 34 ++++++++++++++++------------------
 fs/inode.c                  |  1 +
 include/linux/buffer_head.h |  4 ++--
 include/linux/fs.h          |  1 +
 4 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index d39ae6581c26..e0e522b0cdad 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -497,13 +497,12 @@ static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
 {
 	lockdep_assert_held(&mmb->lock);
 	list_del_init(&bh->b_assoc_buffers);
-	WARN_ON(!bh->b_assoc_map);
-	bh->b_assoc_map = NULL;
+	WARN_ON(!bh->b_mmb);
+	bh->b_mmb = NULL;
 }
 
 static void remove_assoc_queue(struct buffer_head *bh)
 {
-	struct address_space *mapping;
 	struct mapping_metadata_bhs *mmb;
 
 	/*
@@ -514,13 +513,12 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	 * opportunistically acquire the lock and then recheck the bh
 	 * didn't move under us.
 	 */
-	while (bh->b_assoc_map) {
+	while (bh->b_mmb) {
 		rcu_read_lock();
-		mapping = READ_ONCE(bh->b_assoc_map);
-		if (mapping) {
-			mmb = &mapping->i_metadata_bhs;
+		mmb = READ_ONCE(bh->b_mmb);
+		if (mmb) {
 			spin_lock(&mmb->lock);
-			if (bh->b_assoc_map == mapping)
+			if (bh->b_mmb == mmb)
 				__remove_assoc_queue(mmb, bh);
 			spin_unlock(&mmb->lock);
 		}
@@ -551,9 +549,9 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  * Do this in two main stages: first we copy dirty buffers to a
  * temporary inode list, queueing the writes as we go. Then we clean
  * up, waiting for those writes to complete. mark_buffer_dirty_inode()
- * doesn't touch b_assoc_buffers list if b_assoc_map is not NULL so we
- * are sure the buffer stays on our list until IO completes (at which point
- * it can be reaped).
+ * doesn't touch b_assoc_buffers list if b_mmb is not NULL so we are sure the
+ * buffer stays on our list until IO completes (at which point it can be
+ * reaped).
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
@@ -571,14 +569,14 @@ int sync_mapping_buffers(struct address_space *mapping)
 	spin_lock(&mmb->lock);
 	while (!list_empty(&mmb->list)) {
 		bh = BH_ENTRY(mmb->list.next);
-		WARN_ON_ONCE(bh->b_assoc_map != mapping);
+		WARN_ON_ONCE(bh->b_mmb != mmb);
 		__remove_assoc_queue(mmb, bh);
 		/* Avoid race with mark_buffer_dirty_inode() which does
 		 * a lockless check and we rely on seeing the dirty bit */
 		smp_mb();
 		if (buffer_dirty(bh) || buffer_locked(bh)) {
 			list_add(&bh->b_assoc_buffers, &tmp);
-			bh->b_assoc_map = mapping;
+			bh->b_mmb = mmb;
 			if (buffer_dirty(bh)) {
 				get_bh(bh);
 				spin_unlock(&mmb->lock);
@@ -616,7 +614,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 		smp_mb();
 		if (buffer_dirty(bh)) {
 			list_add(&bh->b_assoc_buffers, &mmb->list);
-			bh->b_assoc_map = mapping;
+			bh->b_mmb = mmb;
 		}
 		spin_unlock(&mmb->lock);
 		wait_on_buffer(bh);
@@ -724,11 +722,11 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *mapping = inode->i_mapping;
 
 	mark_buffer_dirty(bh);
-	if (!bh->b_assoc_map) {
+	if (!bh->b_mmb) {
 		spin_lock(&mapping->i_metadata_bhs.lock);
 		list_move_tail(&bh->b_assoc_buffers,
 				&mapping->i_metadata_bhs.list);
-		bh->b_assoc_map = mapping;
+		bh->b_mmb = &mapping->i_metadata_bhs;
 		spin_unlock(&mapping->i_metadata_bhs.lock);
 	}
 }
@@ -1124,8 +1122,8 @@ void mark_buffer_write_io_error(struct buffer_head *bh)
 	/* FIXME: do we need to set this in both places? */
 	if (bh->b_folio && bh->b_folio->mapping)
 		mapping_set_error(bh->b_folio->mapping, -EIO);
-	if (bh->b_assoc_map)
-		mapping_set_error(bh->b_assoc_map, -EIO);
+	if (bh->b_mmb)
+		mapping_set_error(bh->b_mmb->mapping, -EIO);
 }
 EXPORT_SYMBOL(mark_buffer_write_io_error);
 
diff --git a/fs/inode.c b/fs/inode.c
index 393f586d050a..3874b933abdb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -276,6 +276,7 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
+	mapping->i_metadata_bhs.mapping = mapping;
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 631bf971efc0..20636599d858 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -73,8 +73,8 @@ struct buffer_head {
 	bh_end_io_t *b_end_io;		/* I/O completion */
  	void *b_private;		/* reserved for b_end_io */
 	struct list_head b_assoc_buffers; /* associated with another mapping */
-	struct address_space *b_assoc_map;	/* mapping this buffer is
-						   associated with */
+	struct mapping_metadata_bhs *b_mmb; /* head of the list of metadata bhs
+					     * this buffer is associated with */
 	atomic_t b_count;		/* users using this buffer_head */
 	spinlock_t b_uptodate_lock;	/* Used by the first bh in a page, to
 					 * serialise IO completion of other
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 64771a55adc5..c4ab53ec36ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -447,6 +447,7 @@ extern const struct address_space_operations empty_aops;
 
 /* Structure for tracking metadata buffer heads associated with the mapping */
 struct mapping_metadata_bhs {
+	struct address_space *mapping;	/* Mapping bhs are associated with */
 	spinlock_t lock;	/* Lock protecting bh list */
 	struct list_head list;	/* The list of bhs (b_assoc_buffers) */
 };
-- 
2.51.0


