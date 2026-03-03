Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7051EC1427
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0EE6B0124; Tue,  3 Mar 2026 05:35:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038296B0125; Tue,  3 Mar 2026 05:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D89826B0128; Tue,  3 Mar 2026 05:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A207D6B0124
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:52 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B9B658D95
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:52 +0000 (UTC)
X-FDA: 84504396144.13.6A02961
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 32D091C0014
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3tSRFN5Th9x6tCsvoZDTdjVz727sJH7hYB3Eki/KAGo=;
	b=eVRR2Z3eZvzyywMVty3y9V+AYumR0f+9ocPLeHGAzfvKIH/jgSve2qn1f5MvBkB9eXlivq
	hClIXa9uVdRVs+jyBwIC+YuTP4Ej2Z7Yn1AGyOEWQXCzyU58YN44y32JqRc8gJN3iUt2Jj
	+/KYAtXHBCzdFVOHt5joXhvxWrtYlPY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534150; a=rsa-sha256;
	cv=none;
	b=FRZM5pB1pVO4iJFTCP6lyEZrRaChOL687ecSa8PXafsjlychQ3JP561VpaRVPgSbxn8NmF
	0pBpVUPsrPtCikjzps9REUyaeFKnANoLzgcfkYrQKjiZFCOhALLj9+7nEJFrNEY28U+Gni
	+8wUl48MSrL6DApJ8ccOJLqSO5KoxXs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4281F3F935;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 261373EA6F;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id F9RKCUW5pmmAFQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D8E20A0B60; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 18/32] fs: Provide operation for fetching mapping_metadata_bhs
Date: Tue,  3 Mar 2026 11:34:07 +0100
Message-ID: <20260303103406.4355-50-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4099; i=jack@suse.cz; h=from:subject; bh=B8ZzDQ9fbRZLJZF8E2c6y+7UuxwL5O2XEv5hv9QeeYs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkt8oRjrNW6Mstokzx9e88TZxMQExL4YrLsU 0p7NbpL1lKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5LQAKCRCcnaoHP2RA 2fpiCAC/Cyr1/g1WcjrqVOY1eyJVU9N21shLEK5PL6oHJcDd4EbB2dbTyICrINur7AQIJbVbhKL 6uvymE/zjF+cDiCNrx2rRy7zz+TnSWSfzTvo+430/I+nkN/5UsRKGRflBFEPItTcE9188XUlC3U fv9qefNBvocLUJJz4Dq+DR/UESRjZLCg1dT2QSmiQLhwvW86xwMPw27YDk4t/TIxve2l7z5DT57 f2LVhAbHvrsuPIfToabtCEJH6AbZI4ArlLrrr8ZZ82Ed5bDOPBgZhvhikL89CkVcdkiW8RlfQxu JCh0fP1EjfPvT0hO66Z/NArYeRSbtxuJyD3ZVSj6A57R+ZP0
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 32D091C0014
X-Rspamd-Server: rspam07
X-Stat-Signature: iweu6t9bawsmc7kbgn1381r3wpr81pep
X-Rspam-User: 
X-HE-Tag: 1772534149-315468
X-HE-Meta: U2FsdGVkX18Hnh6map3WNZqIUo9lAeTfWSkdau8cU2lyYgUFHHPHQuNaweUuh+HNpfudAW4E88iMsMk3nm3RfVopExKscbBUHC0PQJpmIGs1dxRfy2dl8YJ4v4VGBJYJl7M1+fZWLtWwxmHTg//7pEfLT/vSyFhcVvMUF5JiqMELUCpdXjUlRfLj0d/FP2md2Q1FBkMjRjMSRNuW9ZVZhQLikVO3Oa82o2h30IY5stu4maJa4N8xqSq4uG645eMd6kD9UQAqURxaYqFodwVpZdRUejI+OORECI19CgPJWZZGWqCU9bAzoSE5fGuwv31rbOQglWPyTdsbtfhRwZguKBSp/KHp/1rLwdxyPIBrJ8I13Rjldu5NR52KIAffV/a3vvqqe97phczx9a7lfgEbmhsliRWwJ616cIC7wGG4TWbP3OEayqsFfy/QT+krvWrI79kmr2queEnZWSClHf8Rf79gYyXqYBui2cZApJn4lmO/X1B5VWUXRf7NthudKPGSyDKssbFIG0dZ3VsIHfkPqqMOjqcpLR5NEVOUe7s+/OmYpwOSXOL8vIari9bNdFYvqr7W6VSC+PdWr7yBtlhGyunx1Ju1/MuwNT8XHSVZcJPnFqtQwjpVowOVMf5kXEiGy35JdW7kS5o4cY6rSTWRVwgDbeObROULtDg4Aa8oSzQP6talMePoer+Xy85ZGLD0mON+qRiHXvFM+niXXGmhY2suZyh1odmTyLXBR6HBfMqCk8Z+WBjC8usQCXuGYxnH1SGZcPB25CLfNkq0mg7bKLfHQAl2ipqQ14ibAr5SMak/zMjInQ9/bEbOYZQmridqd3Zib7FLyfeW5EHDXbXRlVJQoKxibkuC1sdg+8cZ92xOqgNeBM+EYd+VrVjgAelFhTROsxlPgTdXFEV1UkcnY+e24U0aUbyH5vc654S9+JvCIpT2AqsjGCKZD/YumNL+sUk2HVFmFGhmbY1mAP2
 IES916x2
 fsYpVGT9xCTczzcLqMqNKcL4quRmQwXwBNcRe72qzc+uO1Wn5dKpiTDXP/FE0sOzv4EYTJVPSkJcrQGQaur9mV+NQz5nBvXdjRNOSdeEvSr6deD/ELi8ea603PNejr6BptkJefPaHqmR1S2utToZUGZN6eHvPkLZOglBJegqCUg0Dr/9rgjhxlVNSLsTuZ0ANB2Xmr9KT0SWzTArth3hGLo/5u5RFAniWIO7mXY7X6hsvgek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we move mapping_metadata_bhs to fs-private part of an inode the
generic code will need a way to get to this struct from general struct
inode. Add inode operation for this similarly to operation for grabbing
offset_ctx.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c                 | 35 +++++++++++++++++++++++++----------
 include/linux/buffer_head.h |  1 +
 include/linux/fs.h          |  1 +
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index d39ae6581c26..d7a1d72302da 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -492,6 +492,20 @@ EXPORT_SYMBOL(mark_buffer_async_write);
  * b_inode back.
  */
 
+void mmb_init(struct mapping_metadata_bhs *mmb)
+{
+	spin_lock_init(&mmb->lock);
+	INIT_LIST_HEAD(&mmb->list);
+}
+EXPORT_SYMBOL(mmb_init);
+
+static struct mapping_metadata_bhs *inode_get_metadata_bhs(struct inode *inode)
+{
+	if (inode->i_op->get_metadata_bhs)
+		return inode->i_op->get_metadata_bhs(inode);
+	return &inode->i_mapping->i_metadata_bhs;
+}
+
 static void __remove_assoc_queue(struct mapping_metadata_bhs *mmb,
 			         struct buffer_head *bh)
 {
@@ -518,7 +532,7 @@ static void remove_assoc_queue(struct buffer_head *bh)
 		rcu_read_lock();
 		mapping = READ_ONCE(bh->b_assoc_map);
 		if (mapping) {
-			mmb = &mapping->i_metadata_bhs;
+			mmb = inode_get_metadata_bhs(mapping->host);
 			spin_lock(&mmb->lock);
 			if (bh->b_assoc_map == mapping)
 				__remove_assoc_queue(mmb, bh);
@@ -557,7 +571,8 @@ EXPORT_SYMBOL_GPL(inode_has_buffers);
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct mapping_metadata_bhs *mmb = &mapping->i_metadata_bhs;
+	struct mapping_metadata_bhs *mmb =
+					inode_get_metadata_bhs(mapping->host);
 	struct buffer_head *bh;
 	int err = 0;
 	struct blk_plug plug;
@@ -721,15 +736,15 @@ void write_boundary_block(struct block_device *bdev,
 
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 {
-	struct address_space *mapping = inode->i_mapping;
-
 	mark_buffer_dirty(bh);
 	if (!bh->b_assoc_map) {
-		spin_lock(&mapping->i_metadata_bhs.lock);
-		list_move_tail(&bh->b_assoc_buffers,
-				&mapping->i_metadata_bhs.list);
-		bh->b_assoc_map = mapping;
-		spin_unlock(&mapping->i_metadata_bhs.lock);
+		struct mapping_metadata_bhs *mmb;
+
+		mmb = inode_get_metadata_bhs(inode);
+		spin_lock(&mmb->lock);
+		list_move_tail(&bh->b_assoc_buffers, &mmb->list);
+		bh->b_assoc_map = inode->i_mapping;
+		spin_unlock(&mmb->lock);
 	}
 }
 EXPORT_SYMBOL(mark_buffer_dirty_inode);
@@ -806,7 +821,7 @@ EXPORT_SYMBOL(block_dirty_folio);
 void invalidate_inode_buffers(struct inode *inode)
 {
 	if (inode_has_buffers(inode)) {
-		struct mapping_metadata_bhs *mmb = &inode->i_data.i_metadata_bhs;
+		struct mapping_metadata_bhs *mmb = inode_get_metadata_bhs(inode);
 
 		spin_lock(&mmb->lock);
 		while (!list_empty(&mmb->list))
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 631bf971efc0..623ee66d41a8 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -515,6 +515,7 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 void buffer_init(void);
 bool try_to_free_buffers(struct folio *folio);
+void mmb_init(struct mapping_metadata_bhs *mmb);
 int inode_has_buffers(struct inode *inode);
 void invalidate_inode_buffers(struct inode *inode);
 int sync_mapping_buffers(struct address_space *mapping);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 64771a55adc5..b4d9be1fefa4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2046,6 +2046,7 @@ struct inode_operations {
 			    struct dentry *dentry, struct file_kattr *fa);
 	int (*fileattr_get)(struct dentry *dentry, struct file_kattr *fa);
 	struct offset_ctx *(*get_offset_ctx)(struct inode *inode);
+	struct mapping_metadata_bhs *(*get_metadata_bhs)(struct inode *inode);
 } ____cacheline_aligned;
 
 /* Did the driver provide valid mmap hook configuration? */
-- 
2.51.0


