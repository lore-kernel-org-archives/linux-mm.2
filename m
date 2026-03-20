Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC821098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC376B00A0; Fri, 20 Mar 2026 09:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738676B009E; Fri, 20 Mar 2026 09:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B2656B009E; Fri, 20 Mar 2026 09:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 398786B009E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50F8557270
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:08 +0000 (UTC)
X-FDA: 84566555136.20.34F0C0A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3894180006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQjYWpmlv+mrYq33bT5muxtF1MpY60GigZl8eb0xVu8=;
	b=Uca+Rotiu8/zGkqtiqWQpVD7MlRgMOly6VeT90k0Q7F/lLdW9mVT39C5UX9UJuu91cosTH
	N1QRpdBqODFBLjDNe5XTYiv2Xu6sDPLiE2xLOmB2ptG27RP7l01ivwU7c7lfXY60jbB5yQ
	8uxzGmAO86jCqx3touk5ALWsZWqZh8E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014126; a=rsa-sha256;
	cv=none;
	b=zM3ggtTFDWA5ntXN5Q+peEXJ911xKdbOl4WaKDgeperWbDrdc11Kjre+W3ME/eqeB90YSC
	njYQRnbw6JoaXXVcNCnNW1YWFth3/B8MVt//qs+ilFRZVWEGRDbAF5famdfk/L1qXOz6cn
	F7A57GiifhXkHqgEgIdGsHjKgfDabjY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 19A774D283;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B88F42819;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RYWjAplOvWlhCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9A466A0B51; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
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
Subject: [PATCH 09/41] minix: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:04 +0100
Message-ID: <20260320134100.20731-50-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1129; i=jack@suse.cz; h=from:subject; bh=beao/EQDuzv4ZgO4qf+fvb6RxeVSXsvs/lpSC/KX04E=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5zll2aMdMKGEBu1la1q7D7+GVZBmHAWorp8 HB/ahbbPdyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcwAKCRCcnaoHP2RA 2XBGCADcx8JSeA6kqqWEFGGtLfqPM0lpVz6MmX3FbSnDoUQJiTcPh4Y87rHfPcIcNIigHR0W1fE jyLCEvhn3zZHc9M7T6O+QgdML6ZGvs29IPZ5UOUFS2nJPsngwQ7zSeLOaKv9kzpY76S9/a+yQs4 p3qpHASif3rGi3+vtrde4I/wuLJeCAgwjcF0RyLSqY933/kAbv3vDk1fhQRDRaFFJIr7sfm5IFD I5jIBFxwhCKoGGgFezAG9Rq0cGslIPKwJhrOF+W6AKv8H/W2HRWPYa6rqKARx7S+ALvdcLs44OF VcmIctWNMAIuu9VoERJPcgd6GNIKzpQDc/bXed2HqRlESb9B
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E3894180006
X-Stat-Signature: cz9tp94nkmjozw53szg6jdujwzrkyke7
X-Rspam-User: 
X-HE-Tag: 1774014125-276855
X-HE-Meta: U2FsdGVkX194qgyyOVS0xtgG6DPfZ3MGagQKx6c7sAkuLlYoUDkP3hWETyEqBy1xOHQAflVFfdM3l5VewbkjJemSOxsiGw1esMRfSIo0iz+nlORA0nfsbAL5yZCY+VVj8exokqBPcY5oplgaGR2ew9JeWKJlTlOml7X/uMyN5I9mZILLczljcAwWL2s5CY5Oyz//4lqJi640MEIjGXs2YW0Tfov0a3ImNjBNRxYYe1hLLn55JPQuuKFa2sFVDiTdSz7ZjhzGitRxsFZ0KVlEa19kRELzPjAsa13jkfmDU5hoZZizFzmzMTaiPp65dnaF+HqTAiIX7GSHHuEYTq6EQBrdZ89QBWFMiH/hXu3KAhJiqmFXpsNvjcWRjtSSIXHw5VjXRUaYvxk3X8N1lgkwKzKpULiZG0/3ohEqnGra3hZOGYvSgsOkQyC92Yg6agYhVQbgVNnkKL8SmgnjJ7zcY/qr3wHyZ7MyPy+2r0XQaqlwNgk0tVS7WNDSxiJl2VIqdCR764yneaPioKM8VIMj0DFAO11yi20g66sJCGRwR15w2kpy6WMerwUcUdZbzOsJZLUGM9nMJDsFjLRybFszysOg5HMIo45myH+5VyYAQ14YVud6gTEL1D/roftbdxw9qdqm/a+0FoIiyRZkCB5xOCEbAF4Ttk2LxKpZGT3yLgJCM+LOA83dWHQJCehjzxmzJ4q9hkgweGTSwUgY5EUa/qtHhiewgor3S8X0a1nUHUAaEoSj0uEiigOfFBaDDQ26LPgDHZiRKpATwWw8CkgkS31P5cEbd+qm2qbxrrlvjbLTp1WSFVW3DPQCyXpC2tq/G+767/r3Z6X7XiIty+mDu7MGSr1dehDc9V21ImALwXQx7YmqZYLThpMYLIKtc43kMclHJnu0LxG+aen1KGG7dibNkN6Qo+2XkuT0vWagzgoz2JF9qkcg4riDueha3KqUDm74GvVl5/hTWLw0f6C
 7jQkKd7T
 PiRNW3w1kbUpA/ar2hq2KgIqOnbW54Y6YtPvVfitGRPuL+ANnBhLT0oB9rrS2AirNZIOUy9CyxtqsQ5zXieurCQok0NFCFKHpBWioLODjgytcxU2irpQlGHnRjDecxrhb1kJEIUlzAdF3ijWSiRUuYLorElTTkPNp+is0BJO5wKdnr5WHZqNf9tXK6/0qzoLXzJPu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Minix uses list of metadata bhs attached to an inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/minix/dir.c  | 2 +-
 fs/minix/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index 19052fc47e9e..a74d000327fa 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -23,7 +23,7 @@ const struct file_operations minix_dir_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= generic_read_dir,
 	.iterate_shared	= minix_readdir,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 };
 
 /*
diff --git a/fs/minix/file.c b/fs/minix/file.c
index dca7ac71f049..282b3cd1fea3 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -18,7 +18,7 @@ const struct file_operations minix_file_operations = {
 	.read_iter	= generic_file_read_iter,
 	.write_iter	= generic_file_write_iter,
 	.mmap_prepare	= generic_file_mmap_prepare,
-	.fsync		= generic_file_fsync,
+	.fsync		= generic_buffers_fsync,
 	.splice_read	= filemap_splice_read,
 };
 
-- 
2.51.0


