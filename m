Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054FF1098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FBB6B00B8; Fri, 20 Mar 2026 09:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1941A6B00AB; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E16D36B00B1; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C44A86B00AB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 855301B702D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:27 +0000 (UTC)
X-FDA: 84566555934.06.3BF9F95
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 501D920004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xVDg+F2e6CtK7j6uBwAUoX9A/+ujgxFslk6X0y4sj2w=;
	b=PjGgkM8z/VyAjccgM5V9SastX6W6D4EaVgCYF6QSWM9aprRgGSvWkfJE3yEQ4gO75pgZhc
	Ta7HunuufcFP2SMGIllwfMZmAeNinH9CALGkik0aQlSG9pN/CoUiII/FdCMUUPiHj1gaFt
	kedWXtVSZPm66njSAu8ecfDHwlOTYTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014145; a=rsa-sha256;
	cv=none;
	b=k6QwxNAW7bZ9CA+ZM1+M7z+vge/IjKFIeTf8rd3hpSuq8dBwQJen+vAp7i5Rm6zU3sUZbM
	amdrDH5Qs5QYM6mTJy6oE5h5a/6gP6BDDDD61qVXGGLDQ/hDC8+uvK2PvAvDPulH559I1k
	lF//wv4CeLKz+lR9oT8B/GJJqlrC8/E=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5048B4D285;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 452CB42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EyniEJlOvWlsCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D935CA0B56; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 17/41] ext4: Sync and invalidate metadata buffers from ext4_evict_inode()
Date: Fri, 20 Mar 2026 14:41:12 +0100
Message-ID: <20260320134100.20731-58-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1456; i=jack@suse.cz; h=from:subject; bh=owc5m+YmFPFX9G7b4L5yVqAn4sHTNVwb7RYuqrd3Kag=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU56/m40sh9r+/VqeE/EOztc8+Vm8Hwnlm9ew gLKiBy9a+aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OegAKCRCcnaoHP2RA 2cWCB/9G3dVfiVkIYgi+VExtwyXQQHTeJyM3wYtTmwcKRC9Fw+jtltLqpMltzU5aN6lGYQY6oWJ Nvfqt318qgAKwQHvwqgssFBmm9YMyPUZri8Y21D9V8DftJabV6FTL7wBHMnIbkfHitEm09irp5a tS6TX42aH0xsov2PY8RzkQAfVCPHzlMV+F8hrhqr36s2rvmfvQ+CEqNCZTUy/+98k6EeIV+msAq duXZ0ndGU0dhBtmY19D5E8dYlHvbcVxvAGZeqZJgXzgTTI17ipPPQD0BUf3+FOjcLuYX2nXyQZG OntlKK/d1++/q46iCWtvNlBJ7YTib8NrQwWghea/nMMTaURJ
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 501D920004
X-Stat-Signature: zh4hd7x8971tkz8aigrtjxfjou1mac88
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014145-642778
X-HE-Meta: U2FsdGVkX18EnB6SPKKhE0DiIaL07K9yysO+B/YNzUTBaRB2wmT/jw1CZezA9v/+2uyEWoIxej8h8ZL5F/SqXQu6Gv0g5Clq/RXHrijidHCSyiUg2cWWewK7Hueajday09ToWuO/KSqyTT1qOu9j1pV4SjY6cNt6/yS4LJskCiuPe2eavoPffre9sGUdnNvDESR7uVmuu7lhR/HDhmJpyqKYToLBYjSQ/DuJQcpy84cOXcFtoP+EGT9Y/hE+OJMxwreUZo8n0GitxXOI0yjQbhn3xja8F3yE7/qGjltGUKSINRbBF0xzkdJOxiey2xGErULUTHhhFJjoTvqz0rrywoeuKNw6B65fCZTOL/zJahvbqKoW+8zfkZ+6e/fnRtwQqGLno+uiK2E/HjqJov9UfHs4hsyCMn3FRWayOUKnpzRKSlHHCEDPPboBLSk6x5VKdPJFh4R+WRQ95V/oG1E9soHglfXWI79QDrKZs9zyQEjpeWxX+icEJ9YldHDdFYHqYS5SoIJHDDdLMt/P0yHk59BnwZB7UQ5YniOyU5QiII9fsRkiM9Txtb2DvtgqDF1e+wwZuqSC27pe78SM+9cEYfBHmLlnig4MuYMOMsGVbRO+2QBI7qwVTxK4DM47LT19hp++kNjgIBt8cP+s5i0qxyp2uyoYAwfqjRPjV5ei9vWyVYi2iCCv79EJbfoN2bcU5DgBy6N5yAj2sCZzrghJVz/ioihJhb4ul1066WZ+sxYrplda4QziPf2arHLlwaFK0mRtx8AEAlK1BgK83W8MdzXcnrVll8NiQlpFrDZ+Jfe8F0Clums0E2n18VFhNJJNzdn5FKT45b9/VOVtdqypUP7OPXie28EFW37Ebi5f0hfKd/bvev/SkVFXvOb4T1sSjh6ygb2/k8VQIDTk9GzzFRZw9MmGnxqOCb2wwnaHe96a3Q2Bu3hdSLP40+DyuqA3qomEU+7p/Skc2O92kla
 soZr4k+N
 xXo/O85ZFy7PtnHGAOR+c3WAB9R5lPgC/berMaWPTC6v4OefX+LehTUXl4zvUtRYLwNkJ93E+VlgCS7B0SC5XM36J8v6HOFRqgB7Rlh4vXyR12Rs2A8H6t1v98/VcusIv3f2UQvdD4OZJ8G6CS2x7lFgDgz4QYGBhjGQPGRdHtUf7UAQMKqZMeRUg6QPdKkG7faiW
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

Acked-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 4 +++-
 fs/ext4/super.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d18d94acddcc..6f892abef003 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -185,7 +185,9 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		truncate_inode_pages_final(&inode->i_data);
-
+		/* Avoid mballoc special inode which has no proper iops */
+		if (!EXT4_SB(inode->i_sb)->s_journal)
+			sync_mapping_buffers(&inode->i_data);
 		goto no_delete;
 	}
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 43f680c750ae..ea827b0ecc8d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1524,7 +1524,8 @@ static void destroy_inodecache(void)
 void ext4_clear_inode(struct inode *inode)
 {
 	ext4_fc_del(inode);
-	invalidate_inode_buffers(inode);
+	if (!EXT4_SB(inode->i_sb)->s_journal)
+		invalidate_inode_buffers(inode);
 	clear_inode(inode);
 	ext4_discard_preallocations(inode);
 	ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
-- 
2.51.0


