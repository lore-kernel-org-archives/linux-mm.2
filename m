Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB5251098785
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A466B00DC; Fri, 20 Mar 2026 09:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762046B00DF; Fri, 20 Mar 2026 09:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630346B00E0; Fri, 20 Mar 2026 09:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF2B6B00DF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 149FF1A01AB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:13 +0000 (UTC)
X-FDA: 84566557866.08.42A568D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id C11BF2000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kJ44H9LMT3ZivYXZKVdv7mDydiQUgrzVMei5uY3rH04=;
	b=dPpg8z/CD0u8Ah1Tfw3ykgSwXvs25vlNbHSeAHpA4eDS94dcwa6kwHnPF1iv3VIGA/cWM4
	R3hjUvvVQTrGg+ag331yAjRDewUj7B3Yo49Do2hMoMMuE7p0Kf3v/rOdEFxUfKKK4mPN9g
	awchqphMaCli1nhrcYCu6eCML5/nUxs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014191; a=rsa-sha256;
	cv=none;
	b=GrG7mPSOMzGLZzz6RBUPTkj8Jyl+P3TCjdYQv2SnlbMqf/3lKHeydn9zXIAc6BO3oV4vEx
	HMg/P4O4WUOxdZ8XX/i8/tlJgAcUYizbpCZVdW479ReRImGtILwiXkt7HIY+mq9HDTWxjy
	EdUMZMmrayiGZNPBfDmISLumZy3oY3A=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7CA1D5BEE1;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 720F34281C;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bprXG5lOvWmCCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3446EA0A9E; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 26/41] fs: Drop osync_buffers_list()
Date: Fri, 20 Mar 2026 14:41:21 +0100
Message-ID: <20260320134100.20731-67-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2464; i=jack@suse.cz; h=from:subject; bh=2/a9eqgQlz/3Mb1WXg09pHnceFw4nNkq4pR2iqKrJoM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6C3a5/P0oUM3bDlZR3EzEk1N3kzljC9F9eH VlmIijoJKmJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OggAKCRCcnaoHP2RA 2atiCADHbFrgbVpWv9NVZTcZXfG2z55SjOTpG8Q5RJZHnVhy7IxVgM9VuhxzUg/FR3cTgaxSFIc GjI16zjLWZpfTYBPto1eKQPvUMmOpUpqyFd7fwA6B3J0AuJMkh7F5xS+eZ5MvUtcs05rhzO3lGR FpTt0wrNPsJz7Jg6q5WbQZTltnamlkF4ZG9fGrnf0F2hAf/bDG3BSid4Sb/sReh6JkPvbOUJczP TjSH1Bt0SRJMnsL3xGw/Dj+8hFzdvz2S15972F3M/ON3C0gcDxqUj1m07ir1YosmCZ52AgON3oA zn1RhDf0YG8GG7PDaRqQrlCwd/CLTqBKdJJBBGGFmKMGodhY
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
X-Rspamd-Queue-Id: C11BF2000C
X-Stat-Signature: 7a83die1fkuksck9tgfobt6rpdw94fkf
X-Rspam-User: 
X-HE-Tag: 1774014190-686250
X-HE-Meta: U2FsdGVkX183y56fEKTGIAaVvvs486N8saaYeVwM/XG/6/KPYS16g3Y5tgWgtDM76qCAQ6P2ZuvGMMQJklj8TpqQ+hYxriCORHDmplVOTsPSb/J2te+jP7wnppootLDJk5u32HQPrshqv4RCxiJrg07ImbSuqVlJsysLUoPqFHbTfvCWTXVaRaEomfuiDrtBb/qRKVe+AZD4ySYLDn7luUcxyimKdfQFYvhCMoTxUHrKtET5LEcr1AEs47I9NC/ON9Txtya1urvcxyA7UK1XKDOUP2J++ETuHzLyguk8C93Y+J8vU9DiWgE1gT/veD7K4YTKMJ5kG5jp4+e7HsMputL7gIZrhqVTYdOHV2PIBPKs8HMjFInBOumQOCEWbMAnBfebFHCj+klA2UvQzilbc43Fz8Dwoj+7niaUPknksfGcEW+5idz/3MPAPNSUdfJl2rM6hkvxx7xBPEmHq1OQ50fH1ezuJd1tQ3LS2sUIb6EDfRV/Hl8TctawzhDdQOHMiw6ypYV7JYdCJ7fmjLfh3wu95kd1XN+ur/2wioKjQk7yvYxYC6N9kc6euoDPzHkH39AOxXO1xiDzgtkI0I8dxlyGcXyKWrkFPOSekqqIB3iSY8Prm+sFw+3to+mrsdOcQoeqIG5xFOCztVwRVGdNANmDoc5rLBLzwhCAuD0+XxxEbFK8jvVbxHcpdfIV5HDMQp2SqkyWikKK/zqufcLnlfuliI5ggt7Tk79qHpc9NxCLazkypseISm70ndcJdhCoyfPhGlzrSENGyZLj4Pc2f9AA6p0L8Vxjah76ljlQk1E58+oSR14AWb13gHIm/rHvEl0iNB25Y8QDW45RANsfkWU5SILW/ugGZQzYNSiTF3DMSJSsbqCz+ROjcVdWaWFC8rkp1WP79XH93thQ4ztTcoJXC3L8+S8fNkUL1oFJCjut4qcTcZn8jKeWiLd/+F3mS/ymenwNO+3azUHLADQ
 2lzvqiJF
 dq5cXoGHgJdcUZbjPa0/PXcZP7DG7GmyGFfAYa7BPuavGYvX+uOgdVQeLbZT9NYxhRdtRJ5q2HnB+bzySzaAxS22zDjEGI9bfXBfiVKTVh2o3CtmD7y2u1jmwvgTMdWdg40HTcXyQ3Z1jjddlUd4aAQj3DPv/bOM/mE/P7s9MVtNY2rLiPz/6ec8gMJ6c5zBxaEHm
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


