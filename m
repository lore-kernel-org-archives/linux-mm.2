Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E115A1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FC46B00E3; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9896B00E7; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF8D6B00E8; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA6DE6B00E3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B43889AEB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:18 +0000 (UTC)
X-FDA: 84566558076.08.C172231
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4825F120002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hE1fD/8jGKWQ7AweSA104Vdo7hvZy1J2ThJmDciyv1k=;
	b=rgRVUF1/eLGpmpVSgm0hAsll+eW3vBmyl8jAJe3ZcKQbVmz8ytY3Jbm7T8JlK8POnwTLjf
	yzvlD2lNbvLUy9wmJmaTQIOniFw0r8dPUbIhwb7bw6p1TjAiw21+77QAJuU/TlCI+kzEGq
	LJnADgwoFcn0hRS9baFGETSdr1aaruA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014196; a=rsa-sha256;
	cv=none;
	b=08Z8as+zwzaQNE9NUa8dU3WexDQN6xc7SoSrljLCG+9E5oFyUILoOC+qcj95JDOFixFtG6
	2XTR+b0ucpPDiwekhP6w6FBZv2fUTMQ/KUCkvlwu6yExyjwpAiTnkeHpz1R7jQYChdBsoy
	oNR+hx7I+Xh36TF2lBCWLi8MiMBfQ3o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 970CC5BEE3;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E5B54281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id z0bAIplOvWmJCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5922DA0B52; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 30/41] fs: Switch inode_has_buffers() to take mapping_metadata_bhs
Date: Fri, 20 Mar 2026 14:41:25 +0100
Message-ID: <20260320134100.20731-71-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3235; i=jack@suse.cz; h=from:subject; bh=69wm8J/iuVA/C0LqpgrhH0eFrbxBGnvY/zfsyT0LKqA=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6Gj+Z5RYeNReOqGeEBWkWaNnGaNEZjZ540x qgyJNuRGqGJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OhgAKCRCcnaoHP2RA 2SILCADvtRbpL9sQeXk2ATLaaUGVCxb3x1O9HrScoxpgHaIxGtqufzRqZMVfXTDHrjaP6C2qP/K EDPQwR1f4w1pohkgKuuasspNKQTMuNSMb+Zo+uVUnmimmYVtBxlnuuJ6Al1d7EpZCPde11zhrvV K4qw4Tf1WeR6Ta8jpIFUDcFI6vFFLnOp3OWqrOTfTiS5kVsvQAkoMdn2R2J8RuU4Gfiych3FfZY PdMiy7jMdI7eB2nFwjAnhwaVvPvhJhEADjMwrdcQsn/7EvrZZBZyW+j4B4kBW93m8GBPgeId5GE C1tGJwnc810Y0ttPRyfvV/Lszn16jgnG4Zl+iA3OGWcM07DB
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4825F120002
X-Stat-Signature: 8ee5xqdubyf4of18nuzypem6pgo6o9oj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774014196-243354
X-HE-Meta: U2FsdGVkX19kWUqS9DuuTG3dPYjPO2QxanolVKw+hZq2qMo8QEk78PyVVhAQbqeIwLkg10nMmlp5aMGBBGZdD2gmLsoOYGuosKeOTsP1imLTWxsf5tE/jwVN2OvTgVSVhpHpjH4B+A3PzIyL47ALyPCO37ziQZtlfYM2CmBG1BGKJhXnkZJUCQU3F6Ugc7bsQUc8WOxgxTNnsivQLWI56S5nby6rseM/SvQX1nwYCbvLIVuJ0SanYx80PTb9l2dUi+8K6fYxPFR7OL8uwLNOkBTv2XoHu3lFCxgrJPx+nC1ps4ipHQ/S26ec4Me5gtBCHypy/61bV4t68pDMm4v9z8o3QcsVmwC8AdBltg5juSHuVrKUnnMX5JwCQyytWZQpSUgpRVReLTeHDovdveRF5DV1wk4kIEkM8srqZ91L25ORMbUc2Th6rntj32D1nVg+b9QJSI5CB1BdKW/dWolcuXynebrZKQPlUO8+3AMHRk6Kyd4217C/dqQbiEZNChYNC2S3FWtxo+Ept9AWCTU7xnMjBjslowMwpZ+MRoZePAhcx9YIt6FDVR8PNX1+c/YqdhRwl9h6n2smSyQVvse4kf1p6YKImV8kRdNUwWz18xnt8YDCeOnRJIYzToYKZZcCNgyZH8rsGevMT5x/AnNKvV6RHePsNln/mYHZ0I4UzXkBL3rApkaizMV5VfqfBzXFjQX13+zl1gNvmrwcZ6I+4kX7EYa2jdjLJUk6ohr2PRNxSATj66UnqbgkNGHZ2GxPuyVdS7xtYr3gquAMsqc7Ee+4tqxjcJOdU/A+nYv41+4nAHZomS3mqxt1zCE9jUp0F+WQR+bnzeGDOkNPaLcN/b06rSBRGR8x0U/XRvoYbzlewpbJfJ7v+o841EhWrYBZtD54z4SEpitkIENJJr+ODUdzxVW0g2su/sJ9OHWagj0kNWy43/ZJq4lQ9kJav1rcVn+GYR/rwWEqiSSHsAo
 aEXX7o6c
 bOU7TjIY3pWGqvBfzkREGqHryg9QR4vZNboTqJ997+Hakts6Avgb/F0yC82nQX+35wMNYE3kH+Kdz+1vefhg3LVAqB1tqSZLTSbhlJtYcqE5bik6AJq5boXsp/WggAOLErf3dtTkdx0gi7xggCjvYTcDsTLj3lX9Rqtj3ixC785caCzgCZRxT5PnhhpsA2hUmFUIz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of a move towards placing mapping_metadata_bhs in fs-private
inode part, switch inode_has_buffers() to take mapping_metadata_bhs
and rename the function to mmb_has_buffers().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 14 +++++++-------
 fs/ext4/inode.c             |  2 +-
 include/linux/buffer_head.h |  2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index e0e522b0cdad..c70f8027bdd1 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -468,7 +468,7 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * written back and waited upon before fsync() returns.
  *
  * The functions mark_buffer_dirty_inode(), fsync_inode_buffers(),
- * inode_has_buffers() and invalidate_inode_buffers() are provided for the
+ * mmb_has_buffers() and invalidate_inode_buffers() are provided for the
  * management of a list of dependent buffers in mapping_metadata_bhs struct.
  *
  * The locking is a little subtle: The list of buffer heads is protected by
@@ -526,11 +526,11 @@ static void remove_assoc_queue(struct buffer_head *bh)
 	}
 }
 
-int inode_has_buffers(struct inode *inode)
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb)
 {
-	return !list_empty(&inode->i_data.i_metadata_bhs.list);
+	return !list_empty(&mmb->list);
 }
-EXPORT_SYMBOL_GPL(inode_has_buffers);
+EXPORT_SYMBOL_GPL(mmb_has_buffers);
 
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
@@ -561,7 +561,7 @@ int sync_mapping_buffers(struct address_space *mapping)
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
-	if (list_empty(&mmb->list))
+	if (!mmb_has_buffers(mmb))
 		return 0;
 
 	blk_start_plug(&plug);
@@ -803,9 +803,9 @@ EXPORT_SYMBOL(block_dirty_folio);
  */
 void invalidate_inode_buffers(struct inode *inode)
 {
-	if (inode_has_buffers(inode)) {
-		struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
+	struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
 
+	if (mmb_has_buffers(mmb)) {
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
 			__remove_assoc_queue(mmb, BH_ENTRY(mmb->list.next));
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6f892abef003..011cb2eb16a2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3436,7 +3436,7 @@ static bool ext4_inode_datasync_dirty(struct inode *inode)
 	}
 
 	/* Any metadata buffers to write? */
-	if (inode_has_buffers(inode))
+	if (mmb_has_buffers(&inode->i_mapping->i_metadata_bhs))
 		return true;
 	return inode_state_read_once(inode) & I_DIRTY_DATASYNC;
 }
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 20636599d858..44094fd476f5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -515,7 +515,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
-int inode_has_buffers(struct inode *inode);
+bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void invalidate_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
 void invalidate_bh_lrus(void);
-- 
2.51.0


