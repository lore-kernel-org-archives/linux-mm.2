Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95E871098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F04556B00C4; Fri, 20 Mar 2026 09:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9796B00C5; Fri, 20 Mar 2026 09:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2FC6B00C6; Fri, 20 Mar 2026 09:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D4176B00C4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B9BBB6FC1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:45 +0000 (UTC)
X-FDA: 84566556690.04.A81465C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 51A964000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZfpWi8mDNyBOMa2tfuFTBqwvX2eA5Kp1+U3DtplQ7SI=;
	b=R3hxhv1qlSBnlP0ORftcqWbZnvSXYoA98o6riUqC9O5X5Re0Ju1EX7FFFKHtCZo3g+IVzJ
	naOAkK+hxocHlFyYQ0PHZG3Ip+H2YXMdqP1LKBKiMfoR3TLxwtakyjJ80nzdbgFVbW04Vf
	cI/+iw7wWOeavkzZS0wAACkMSBpNBrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014163; a=rsa-sha256;
	cv=none;
	b=wX0tgRA2ncLpUtAIVuxbtormA/jK1tzoVuvRopy35FUf+ibGBjwBj4lDBUPJuIR5oksnPA
	su/rkbfvG9T1GR5ve00uImvItP6RGSih77xeDLHQMpJeBHtLoMxRSCSDiaYghUWL/OfM3x
	VISRQVSAfx7Q9X6R+EeZTd8KuLpXQVw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 64DBA5BEDB;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 59A414281A;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j13hFZlOvWl2CQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 07438A0B4A; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 21/41] fs: Stop using i_private_data for metadata bh tracking
Date: Fri, 20 Mar 2026 14:41:16 +0100
Message-ID: <20260320134100.20731-62-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1862; i=jack@suse.cz; h=from:subject; bh=21rbptBohvHLbIzoeM8IfhTkwdubfon9k5dpdTlpgfs=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5+RXfvEFOavnw88KSkCELSYzUGb6FJxDza0 lFuc/BYWXOJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OfgAKCRCcnaoHP2RA 2cVdCADcHKi3nENibDjh07t9tbXyUjkh5c1Polgi3FSaCQm47zS25K8aFptUxE2/oY8ejx7lyWp A+8xQcd21feMFPNOSI5mebAUxEmRB8Lgx1x6CHLQd0D6LlajkimXDuNt96nf+oklVRD/H8BcwDK HRgqbSaj0IJAwDNPgEPIn1y9JtSheML/XPlQP9uLuqfTP7I8JnfxyBS/9FxWrPTG+BbNyXNBQjV FHoiSlj/Uz9ZJlTG+NsU2p2A2akXMddVm3za2fBHhQLK5HWuK+eIeL7LD3J/FOxBNTBu6jRl9bA H+LgpsYFNtKQC0n8Q7/8/hIR9zPmkIaTfAtDesjgnuGLH1Mr
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: n67qwga33rwn8qnf7ggfz1e8jhqekmwc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 51A964000F
X-HE-Tag: 1774014163-739944
X-HE-Meta: U2FsdGVkX18bcbi4iQBQFSQc1hAxn1K9kZPwkn602jvM/Pxd5C8TbSo67dtjDUqtUAzM1hP8cBr6Bl4nU4GxyhF2SPcxralZIX11YginT3MAt9/L/sI0FfhgAkUx4QjERZj/sRw4B0YmXpLK+MHHYCT/ttOZw2RLUHk8E+zfQxJaiGv83mqIlHD7xpg9TqxdeKKz9+qFM1S+GtwbJ9abNs0b+b9kJhv/vwl4FPu4Q+hDinpK9rixmlvn4T8HlbBJctB/yM8LeOpV8wNIDsW0+cJkJS/JHvhFTNwV7YF8L/3aKCDcA2kVrQk0ZbT3NYihhxFSGRswqYUD6OatPblX4ubSKmY/2rnyraDYNpl+zTYmJnZ0rNepNrHncIVtGVhnsB0ss8M3t74fW+gnavRaybmuJlAkE3p2bNn433FpO4GCNqubqdU1hAmQnrWftRp3T3SdtW4VmvsgvPhqbZ2govKRguKIpM+bLONZ36pxPuX7MHd1RZwqPWhb9wqX3qCkS+Zz68gW4w6hijI9KT3vx8b8gjZkD5ojvHiN2OYCBuQCio9L9Y6c7UK/u2T6wJmirZZ6nrWQxyaHat9Pm/akdNP0ByMFi0B18yPfm+k9cLorg3XfkdqAZzIgkt1egb6jXkjuC6lWYclO/j7Ptae+Bc66McxdtiAw+OaxnxgJDSc0ouwIIIY+nT2gowNLaHxy94U2WzrFWs0S9cvv1l7+QeYHojQ2SwG5kX3appN+DbrvDEzAFWGpEZvWHzi/pvii4OPbG2FU65XI2Vq6lK12HeZYk3jcrPhqF3+Z5WrsiES++Z99DHy59xauVB7dJkbtHeXlvCTdrYRBDwkKJzWEQ4lfj84vsN+vUo2mzDTFhV/ssUfW7SP+cnydIDZv/TJ45yShYDvSvSs5A3oFgIjG+u9tcyHAL72Nj6pSw+cT23o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All filesystem using generic metadata bh tracking are using bdev mapping
as a backing for these bhs. Stop using i_private_data for it and get to
bdev mapping directly.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index bd48644e1bf8..c85ccfb1a4ec 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -574,9 +574,10 @@ static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
  */
 int sync_mapping_buffers(struct address_space *mapping)
 {
-	struct address_space *buffer_mapping = mapping->i_private_data;
+	struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
-	if (buffer_mapping == NULL || list_empty(&mapping->i_private_list))
+	if (list_empty(&mapping->i_private_list))
 		return 0;
 
 	return fsync_buffers_list(&buffer_mapping->i_private_lock,
@@ -679,11 +680,6 @@ void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode)
 	struct address_space *buffer_mapping = bh->b_folio->mapping;
 
 	mark_buffer_dirty(bh);
-	if (!mapping->i_private_data) {
-		mapping->i_private_data = buffer_mapping;
-	} else {
-		BUG_ON(mapping->i_private_data != buffer_mapping);
-	}
 	if (!bh->b_assoc_map) {
 		spin_lock(&buffer_mapping->i_private_lock);
 		list_move_tail(&bh->b_assoc_buffers,
@@ -868,7 +864,8 @@ void invalidate_inode_buffers(struct inode *inode)
 	if (inode_has_buffers(inode)) {
 		struct address_space *mapping = &inode->i_data;
 		struct list_head *list = &mapping->i_private_list;
-		struct address_space *buffer_mapping = mapping->i_private_data;
+		struct address_space *buffer_mapping =
+				mapping->host->i_sb->s_bdev->bd_mapping;
 
 		spin_lock(&buffer_mapping->i_private_lock);
 		while (!list_empty(list))
-- 
2.51.0


