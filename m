Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03CE1098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12756B00BC; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A49556B00C3; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739DB6B00BC; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42B4C6B00BF
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 13342139B5E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:40 +0000 (UTC)
X-FDA: 84566556480.19.25B5F14
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id DCE7A140007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PIk+3PM+jG2PiQ44UnRCyz0Pc5nehV9CBwg+OwnTyLw=;
	b=mM5IfHkIBuDpUkBnfA/8Nz6kDzGhXOoGXGwaFXh1+Jj+KfFbJGACNCsbIFUYJAZ73hy/Ug
	PNfHAUTgYOhQbwqKJLJUvKZyYk9pRT+0PVHkpHyUKgpqEcTFSx9mBYNY3SwbYgcfLwiv83
	Axnhz+qD1w7YQQPc7wpNsmO5L0zE26E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014158; a=rsa-sha256;
	cv=none;
	b=jlaeOAvvS84i1gi4JdAWxY1bqVrCRlG22MgLaQu5hu2SOjx8xOOQIaFat/FujUIAQtniPn
	EyQJlXpfTTPbbx61EuVPvcoFI+Yx0YZ9s/uBKYpFGm1qpt+1UHcPddcVOFS8IgBQ9XtD6C
	ZczM6Pi6s4Nx0aDXTZR4ywVxDUAJOQo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5C70B4D294;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5069B4281B;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PZagE5lOvWlyCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E1DD0A0B57; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 18/41] bfs: Sync and invalidate metadata buffers from bfs_evict_inode()
Date: Fri, 20 Mar 2026 14:41:13 +0100
Message-ID: <20260320134100.20731-59-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=801; i=jack@suse.cz; h=from:subject; bh=K9wrCKmeO7BfHLYf4wsyZtDcyuSx9fmOTys9wQHOC9M=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU57ZOEr4SoMR6litD6xJZ9vyOu7Qv8MRlaIP MceIDomSlWJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OewAKCRCcnaoHP2RA 2c3sB/9m9TZqiM8eDGPMcq+rKM3PXafvjHga/QNDB8hTrqSEQ/3iD+JOV9tZLe42768TP3T60aL 2pZcZwDnO0mBm+nwL5UJjVRAYp0202vqciT738fNOr2J0/GmCW2vPnvXsr8GsKQQKHCOGbKH8jZ FdoX4qubiKQqfCSpctN1L2bhSthGpjttQX9HiQmhVvqhymLnTXV+IL9Bv34LSce19IyFVpB5Qul i/i6BtWdCZZy/lbeMeC87I7PZ0imM/vCTKmYlBVBQeR4tEVIZMwPbKyqUzAdUDx9Pz7gXOVGNAX I3uIuyIPKMrTNXEaRaPgWMBM6X3jaW0TEa9x9zVTFaqYTIzK
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
X-Rspamd-Queue-Id: DCE7A140007
X-Stat-Signature: w8we1q77bgaqcat59pu96sesshsici4h
X-Rspam-User: 
X-HE-Tag: 1774014157-359766
X-HE-Meta: U2FsdGVkX18JbVEIXMryQK9BKNkaZ0SbS1vsjnhvR4trP4cphovYdON/njyaSwkrdSxyN+7Zx9dZzsDG2i6+1X62DpmjHjdMMjnJDEevunE2zGYEGewUwnXz6+BoYAQsnFGYEY2zVsIzWvSynukF+Cjcd+DPRbH6GUFNLWViM+Thwf1nlyx8Y7jTlEF/MQZ5es5CS/Q3WJXhyeUzVVvjOgGo0UjV7eqgfjkfibVVr0IBkbby1T5lrHIP/+ipXh4fghdd/2soOFbJ0ITl7Ot9jdoCkrcjOwPxuQhqSvo+d35GgqpwVhrk5wTelzwXLnpqwuOIFJDPkVixPP8qNtHqRF7BBT2Fk72GDH3UVsHvUAlbAtmbhDB7Gr3IWoA7CkOfu2N3jMjtfzUDunW53UULm77bCIYXC6sf/wO919MxQLyPNiDu13EFn8NJxUQ8hThs0JwEfSnuQsnPtR9CTbjhZgXOXw/4iAovNHqJ0mhcSfFuW0sUS4pNMcChJg84OmVNKxpwvw1dccZgpoyzcGc0IAkz4diYJR7/GeELWJJlJ3JEsVa3cF11aI11EuALB3ZQHeYcCI4q6l1pwtNeFBuLU9BEgqDjXy66aT4jVNdzVAsoTyvGwy1tTMSOJpR8to4yDEx9i4uNqlYclBG3MK70Ef9Eqi/MhDSb8AxDoEh7OdhOHa4YK26mpmbvI+NySSzYbLRKLV3GhVKCVpSZjweifAai82GFOwg5ixTo2gZ6TO+0IQ8Hm8lId2GVRLt42zvJu5FdQK1Rw0tac9XI0acr61kCubagugI58BxHn+x4Of8Z4zaaCzOp/MrxQlR49TFnfeAole1+VRKQ8rwWxiICc+EAQsdclDraPjgNhRurGJO5aO1UL/CVMyG9ejSqoIMNd5R533WRjNt6yUt/WBK7PMzU/LA1QsnY9XZGLPEJ59Aqp5iKg2x6ImAJNK2YCkrrgzncgvxU6c9IBABw3+5
 bBKgk1kb
 4NNieGJyENpSY1lSYeQMvZzSu5TlrMsih+WtUDe1hKW/L77hGhLnl7xKCYDr0F48H/+UuxCAUUA/codZqS1rGlVpI9b2zaJtgcOcJCWYGVv02dIOcbtVBcGO0OyBdWZkSgaIkQfFGTbfQJjUYfBoKBh/9cX4RoxZjbjr98VBxCysz6zlbvrZPOg0mKJ7Lp0CR6QEx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are only very few filesystems using generic metadata buffer head
tracking and everybody is paying the overhead. When we remove this
tracking for inode reclaim code .evict will start to see inodes with
metadata buffers attached so write them out and prune them.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 9da02f5cb6cd..e0e50a9dbe9c 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -187,6 +187,8 @@ static void bfs_evict_inode(struct inode *inode)
 	dprintf("ino=%08lx\n", ino);
 
 	truncate_inode_pages_final(&inode->i_data);
+	if (inode->i_nlink)
+		sync_mapping_buffers(&inode->i_data);
 	invalidate_inode_buffers(inode);
 	clear_inode(inode);
 
-- 
2.51.0


