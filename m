Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7043EC1423
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DED466B00B2; Tue,  3 Mar 2026 05:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E976B010B; Tue,  3 Mar 2026 05:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8C3A6B0106; Tue,  3 Mar 2026 05:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A00846B0109
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:35:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F7FC13AA03
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:21 +0000 (UTC)
X-FDA: 84504394842.03.B529CA2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 23423180009
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:35:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772534119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ44H9LMT3ZivYXZKVdv7mDydiQUgrzVMei5uY3rH04=;
	b=OjIpz7EHlNa9pPYrvimOnU4UvSOK/N9Ob2stbTQ12WKbpOorCH2G61i9JmbCF5bR+BtVwB
	D+QEd+gnlerdWfs4BYzybIPQjwmLtnIlvhZB/S+AAjiTZSRB1R/che1ha12qbbBtthQgja
	GYAJfveC4a5bPRrRJtBDmWK4VAra+18=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772534119; a=rsa-sha256;
	cv=none;
	b=rg8g5oek/aHtD95QsiDqTGWGAG1I8cyXlWFa3reHLGdAirHOSg37uQ9A++WnKw26rV8bQ/
	MzISA+sjY3oTF7y20GYx5f8C7Fu1Eb9MP/lnI3NNHknvk0ZMfPyc51XhrewZhtPOjFoMRq
	HZjp2nprrzdb6/EB4vqj+khZKX1OOg0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2E4983F924;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 243B83EA6E;
	Tue,  3 Mar 2026 10:34:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EyzXCEW5pml/FQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 03 Mar 2026 10:34:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id C00ADA0ADA; Tue,  3 Mar 2026 11:34:40 +0100 (CET)
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
Subject: [PATCH 15/32] fs: Drop osync_buffers_list()
Date: Tue,  3 Mar 2026 11:34:04 +0100
Message-ID: <20260303103406.4355-47-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260303101717.27224-1-jack@suse.cz>
References: <20260303101717.27224-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2464; i=jack@suse.cz; h=from:subject; bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpprkq3a5/P0oUM3bDlZR3EzEk1N3kzljC9F9eH VlmIijoJKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCaaa5KgAKCRCcnaoHP2RA 2YEWCADXaZjDgnEzRya8WwzOnAHZ4qj1cJhsps4vNe6LN2OzqXU9hRA0KCwyN1q3267mhf/Gtn8 cQRRvJrD7nTw1RB+acUok2EmA3WYOJGhPuSPpbrTyUgR+Z9yVqPuzZGop3fq7MfcFurZB3iLUx5 YTSQW0lx6H+QxRAeT1WU7SG9nAQn5ZNJpUFSpu49/+AaVQ4AQdrOmYLSY/z/z8uk+dbKs90w7JO 2Q67MYypYmHj19Hq5sjvXf30jcBQ+l4AlZSUrv4jJpk6eoN/Sq/dyC+CJT0RmslIUQc5Vg5w9vS U3/whdj22wIw13yayC2IA5mBBn6ZOi3aVH65TNsw32MyfLGR
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
X-Rspamd-Queue-Id: 23423180009
X-Rspamd-Server: rspam08
X-Stat-Signature: ixm4iqyq9yt9n3qnj1wbbn5pudubr7bn
X-HE-Tag: 1772534118-5032
X-HE-Meta: U2FsdGVkX1/ccrTWnyOW/v8am1CTZ7P9IdKoNscgWSdZAfnyXZwqB5kZKPJAtPcXwSCtIOmTUtyA9omqSjMSwKi09rq7uaKy7VD/5rshKNhv0mnnmz4w7HoE5KWy0pRn2v00BHgLGi7N8xFQtds2CZSk6J3yEZJTUSgns0jdI9BXXMBB0yaWgcg/abeiYznnQ65WMH2wnTeMqVctYEWsePj9B6G/9TWU7FkWLJ7kso+9NK6RpGLF8ZxMjkqqyCVr4Cb1hyDC9bSG/MSMOGthqDBd9Jq+9M174+2akfVPYD+G5xd65tQLh/P3qwteUaL/X+ciVyqrwGrhmdxW8HdcB/Mve4eF4wjycq/ZAnJSzxdEkoE5sXktUTimq6rcEktdL9lszpEjfxyfHdNeex0Zv3f0Wij2tq1mTmEZcEj1+8Yg5N8/VOLidaxR2Ki1DWOEoDdIcPonJcCdHcGqi+wi2w1/W9XgILUiwbbDjjM0tfuWYVHb5bZ8Fm4S0n9O0trQCGekRyYwec4TW6lLRRZQVRP431qb0TiDXeG+aYrPjHe0lqrBOGFPuVx1l4mezRHhYgtK9VQfX3T4oH890d/1c2NUuwfY6fVHeY+YFowCm2eYSmXmlKkgdjZ1veHuiuCeOclHxeCVUuDsEmgEX3kcMUYLJxHPsg+o9s2pjXnn1qimqn1uQ78mG58VrnzKYL5eZjcKSuROLVE44e7AMKpWuENJbOS9o9lN/4MaZQmONRvu1+8GqoV7SLZmwReAmGqndvNDz60PvgI7lCHSuWvxjGO06iRFKMAimH/NrMTfyyzGDVt4QQK7APOszgIsXqzmiRO0jA2k/p9zyHcFXvEKmz401wzxlRlsY5xU3Qe36XpuyCNke2o9t7r6Y5UpT3I70nYvEbm/TiqqqoRPFx4Qzj00hGo1TYzIs6Kxqjl7fyrkK49zBxdKny2VWQXyzB2OjsPWihnK6wpBKEi0iPR
 aqM1NZ2P
 fNx1OlMP35ZM77/vRKEWqEnDT6hxdzqgiyUuWWZJs1OjqWSF4gIhag89OM2cTRrx34vTPCyA+gMtw8JUHcigMSWQKkIRvCNrffMqEuHtTX53/ww53SPKOJ7vJMI+z8ba/YAvXWpDOTpQd/eCkDA6RJdaRceRQ4mPtG7U/dxf7Pool8uksU5ptljyH/4cD/gguq5Fh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function only waits for already locked buffers in the list of
metadata bhs. fsync_buffers_list() has just waited for all outstanding
IO on buffers so this isn't adding anything useful. Comment in front of
fsync_buffers_list() mentions concerns about buffers being moved out
from tmp list back to mappings i_private_list but these days
mark_buffer_dirty_inode() doesn't touch inodes with b_assoc_map set so
that cannot happen. Just delete the stale code.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/buffer.c | 43 ++-----------------------------------------
 1 file changed, 2 insertions(+), 41 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c85ccfb1a4ec..1c0e7c81a38b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -526,41 +526,6 @@ int inode_has_buffers(struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_has_buffers);
 
-/*
- * osync is designed to support O_SYNC io.  It waits synchronously for
- * all already-submitted IO to complete, but does not queue any new
- * writes to the disk.
- *
- * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
- * as you dirty the buffers, and then use osync_inode_buffers to wait for
- * completion.  Any other dirty buffers which are not yet queued for
- * write will not be flushed to disk by the osync.
- */
-static int osync_buffers_list(spinlock_t *lock, struct list_head *list)
-{
-	struct buffer_head *bh;
-	struct list_head *p;
-	int err = 0;
-
-	spin_lock(lock);
-repeat:
-	list_for_each_prev(p, list) {
-		bh = BH_ENTRY(p);
-		if (buffer_locked(bh)) {
-			get_bh(bh);
-			spin_unlock(lock);
-			wait_on_buffer(bh);
-			if (!buffer_uptodate(bh))
-				err = -EIO;
-			brelse(bh);
-			spin_lock(lock);
-			goto repeat;
-		}
-	}
-	spin_unlock(lock);
-	return err;
-}
-
 /**
  * sync_mapping_buffers - write out & wait upon a mapping's "associated" buffers
  * @mapping: the mapping which wants those buffers written
@@ -777,7 +742,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 {
 	struct buffer_head *bh;
 	struct address_space *mapping;
-	int err = 0, err2;
+	int err = 0;
 	struct blk_plug plug;
 	LIST_HEAD(tmp);
 
@@ -844,11 +809,7 @@ static int fsync_buffers_list(spinlock_t *lock, struct list_head *list)
 	}
 	
 	spin_unlock(lock);
-	err2 = osync_buffers_list(lock, list);
-	if (err)
-		return err;
-	else
-		return err2;
+	return err;
 }
 
 /*
-- 
2.51.0


