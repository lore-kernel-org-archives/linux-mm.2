Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758D31098782
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F596B00F8; Fri, 20 Mar 2026 09:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B88A6B00F7; Fri, 20 Mar 2026 09:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5A76B00FB; Fri, 20 Mar 2026 09:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 054AF6B00F7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:43:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5E50138835
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:38 +0000 (UTC)
X-FDA: 84566558916.20.BAF94B2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69CEE1C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:43:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ATv3OKAS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ta9pKvWw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ATv3OKAS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ta9pKvWw;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=OTmTBcmt6hff0LfwKLUKIObKZiNXiJlBacF3hGZkPRdb7TOg3dgAYW18bPBH06x5vuOOjc
	r+cXPC/jK9atfNu3mmS4Fcy9J2ikwede26Z3AO7R37tTs0aifPrtKiQhao10bq9kkyQgrQ
	PfJFKmqpJTME7hjbKQzPMZh2MstilPw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ATv3OKAS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ta9pKvWw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ATv3OKAS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ta9pKvWw;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014216; a=rsa-sha256;
	cv=none;
	b=oSy49qulPXB6HF5B97whpMqv782Vx2QXYHRyy5MsqFMXH0O5XT7lnpFAuvH9LqQ3y3CXxS
	BQWmfb/h1MmPPh0ntsHDWc6hsJpqQIicINcVlKb6VjGy2Qv9eYeVbGzMSmdk/TuBDUla9A
	YIYuT2Bbc5l+eYpArHcE2EvoNtGQe7E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BDFE05BEEB;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=ATv3OKASBdjf3U3vWdPgZTIqL3LcgfgQct9p6SRk3HXoNzeT/C5fdMGz+BPLRUS0tqn2z4
	qsJ9NU7iQ/KBGLBTN8mVSBHGu+9JE+mhaoCh3PK8bsAksvbZxbLqVbp+EmvGIeTO/wOEQ7
	Dnp4bI84IvnYtvx/phLsVdie6gaR/Lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=Ta9pKvWwDUyDVYWN1RAuw/0strxWRgpZVe8N9pwCIM3JD4M2RrkZmOeio74Bc9EdNizSNA
	nRrDMMFjPsPV51Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774014105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=ATv3OKASBdjf3U3vWdPgZTIqL3LcgfgQct9p6SRk3HXoNzeT/C5fdMGz+BPLRUS0tqn2z4
	qsJ9NU7iQ/KBGLBTN8mVSBHGu+9JE+mhaoCh3PK8bsAksvbZxbLqVbp+EmvGIeTO/wOEQ7
	Dnp4bI84IvnYtvx/phLsVdie6gaR/Lk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774014105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abL9xBa4aZB+6Lfi+vHDS/FUcCTLKDXx7t2msCZ3Hc0=;
	b=Ta9pKvWwDUyDVYWN1RAuw/0strxWRgpZVe8N9pwCIM3JD4M2RrkZmOeio74Bc9EdNizSNA
	nRrDMMFjPsPV51Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B468842817;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +zoJLJlOvWmSCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7AD97A0AFD; Fri, 20 Mar 2026 14:41:45 +0100 (CET)
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
Subject: [PATCH 34/41] bfs: Track metadata bhs in fs-private inode part
Date: Fri, 20 Mar 2026 14:41:29 +0100
Message-ID: <20260320134100.20731-75-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3109; i=jack@suse.cz; h=from:subject; bh=VGn/pIRcK5eqeKsls80+M3Fo5nsCbthSQy6MRfgwTJE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU6JkoTdFIeB5g6YyXAUMYBxuc0lm0vwR57wS 9b2iHYsY0uJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OiQAKCRCcnaoHP2RA 2XhVCAC+YJifHwYZzLl6Oueau4kUtprTKTXcIWWXJushrDVu/nuZDc/4AETd6K4Z0O18UbR7bk6 FsPN6YSkCxd2ivtBVfR9hajkKNv25qeR8JDLdgYyL+hv5p/iFQfjKpZCiopmbCjXMP8qewnqqN1 oZiQVUEfmztaP7RdRwsLOeF/sP46FCRMPdlDo58NkES0loHaVoBhrDemn3NreeUgiBLPFmkkzyU C68I5VkKhwq3V1D4tKOoASV/nqGFP3k6GXF9+HACH4ZaF4ibWuxpQoGOIVPPg+DnzdDirzQCm16 fABzxAx06tQ3kU1y/raCptDEpbnODHcVOgkyOKEqdWDPWHXH
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 69CEE1C0004
X-Stat-Signature: ewunmn1orr9j9dp6s6t7fzqo7k7pjrd7
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774014216-907057
X-HE-Meta: U2FsdGVkX18uo72J5djTgu3yGZlTqilZxycAJfshBtE00CSaGYYlU19jSO0Cmg4e+WFz6dfH0LG+ggD/mET+9BjWzDO9jJvDhG5SB02wDZnh49xRdAnFg0Jr4D/eu4GmQRu7PtJ8fBQR7gXZiYWf+RB7mK/74mruvpcrSjU0KBGraESVJMVRZp73Q8EzwKy0LdIz91MTedjGGUsjys6gvD7KqyId/xYJLRA56oIgGceyF3VhUNLceyhlVQXDtPBAxOL7A2iB+ebPtOr65hd+oz/de0eBV9uv+Eh1o8/rdOcy9ZaaIP5pKQefF9wwyi2Njl4igmCTWWZ2nY5i/HmCJj55/3BCAXf9OiUj44KGp+DitswbItiyLk7UYJBDCqNnOtg614SuKzSvh9bDUsDP4mHYjJDL2cUTeWFP74J3oATDr33KeF2DMI1QBOAI5yZroEbGKY5/VfSIzTG0PHIUqESvgMftPtLXqKq4DsNVr5/4xetMyzyx97WzwC9g8k8/OUIO3lJMdMXeyuKSetqKk7ZZvkfOwa2D188YT/acLdPE2/hcrFopaPsb5j50Rnz9Q/4o+PR90J5euuOTxUBfCLjMPFzcwWmXXhuvkGVaR0SHcQ5d+tQs0qT5CRBw7mEs/YM+3ycXvBTiAGxlYkOUkQcuv9OzwNMRQaNym3L0z07i4IT+v21O6U3fOTHXDkG9/aB2NsU1Z8DQO+Kc4OX8Ej2uUH/PF/CW08uUfOta4//Y6OLYdeogWtJGrdO4bLzBDaRihLHS1YvMzcNj8DIWEwwX5KBlQvhmmYo+DoRHLwNYmaqMzd7ktc61uYLHnVhAfu5xA9dN1To2jKtsNjDAjXJG15ni1Of7S1r/+tQYrfFyU1SbXJrn9s4E6/ZOXMxWqu6qxx/5hCQL3X0U5YYoc/UXIAvb3BXA2/XL87dddoOb+hEQ9R7Qht9aQ4PZDiaebF35on49bYx1dO/AdPh
 S+ywnwe+
 44nrBKUeo9Ce2zfI9nA63ROVgWEFrtE7RX9UOgo+1638YUxXci4YCkFNx3ZJrzyibo5le+lB+apk3CoktLU6+cSX97nmo4j7Qx9guwpqn6T9vDzXhdzZ8TI3ZjMQLUo9z6dYw1J0NPAyewxBWiiMQYQbjYpu1sgzdZEFDe/IcwWFcEihnrQxHrYgE5+fKwmE5fRH3vz/ahMKSiOqOvYtuWuhdiEPDZ9NCp4P07hg9oE1wMd2npwElMEx5cXA+BKDIXsHQkesP5qePaT8cV3OBBKqAio4z7h/wRcnDRINfYh8VMSR8GdbtDHxgWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track metadata bhs for an inode in fs-private part of the inode.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bfs/bfs.h   |  1 +
 fs/bfs/dir.c   | 16 ++++++++++++----
 fs/bfs/inode.c |  6 ++++--
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/bfs/bfs.h b/fs/bfs/bfs.h
index 606f9378b2f0..b08afe733e63 100644
--- a/fs/bfs/bfs.h
+++ b/fs/bfs/bfs.h
@@ -35,6 +35,7 @@ struct bfs_inode_info {
 	unsigned long i_dsk_ino; /* inode number from the disk, can be 0 */
 	unsigned long i_sblock;
 	unsigned long i_eblock;
+	struct mapping_metadata_bhs i_metadata_bhs;
 	struct inode vfs_inode;
 };
 
diff --git a/fs/bfs/dir.c b/fs/bfs/dir.c
index 1b140981dbf3..1dbce745d1ad 100644
--- a/fs/bfs/dir.c
+++ b/fs/bfs/dir.c
@@ -68,10 +68,17 @@ static int bfs_readdir(struct file *f, struct dir_context *ctx)
 	return 0;
 }
 
+static int bfs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return generic_mmb_fsync(file,
+			&BFS_I(file->f_mapping->host)->i_metadata_bhs,
+			start, end, datasync);
+}
+
 const struct file_operations bfs_dir_operations = {
 	.read		= generic_read_dir,
 	.iterate_shared	= bfs_readdir,
-	.fsync		= generic_buffers_fsync,
+	.fsync		= bfs_fsync,
 	.llseek		= generic_file_llseek,
 };
 
@@ -186,7 +193,7 @@ static int bfs_unlink(struct inode *dir, struct dentry *dentry)
 		set_nlink(inode, 1);
 	}
 	de->ino = 0;
-	mark_buffer_dirty_inode(bh, dir);
+	mmb_mark_buffer_dirty(bh, &BFS_I(dir)->i_metadata_bhs);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	mark_inode_dirty(dir);
 	inode_set_ctime_to_ts(inode, inode_get_ctime(dir));
@@ -246,7 +253,7 @@ static int bfs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 		inode_set_ctime_current(new_inode);
 		inode_dec_link_count(new_inode);
 	}
-	mark_buffer_dirty_inode(old_bh, old_dir);
+	mmb_mark_buffer_dirty(old_bh, &BFS_I(old_dir)->i_metadata_bhs);
 	error = 0;
 
 end_rename:
@@ -296,7 +303,8 @@ static int bfs_add_entry(struct inode *dir, const struct qstr *child, int ino)
 				for (i = 0; i < BFS_NAMELEN; i++)
 					de->name[i] =
 						(i < namelen) ? name[i] : 0;
-				mark_buffer_dirty_inode(bh, dir);
+				mmb_mark_buffer_dirty(bh,
+						&BFS_I(dir)->i_metadata_bhs);
 				brelse(bh);
 				return 0;
 			}
diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index e0e50a9dbe9c..89f3da14e8c6 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -188,8 +188,8 @@ static void bfs_evict_inode(struct inode *inode)
 
 	truncate_inode_pages_final(&inode->i_data);
 	if (inode->i_nlink)
-		sync_mapping_buffers(&inode->i_data);
-	invalidate_inode_buffers(inode);
+		mmb_sync_buffers(&BFS_I(inode)->i_metadata_bhs);
+	mmb_invalidate_buffers(&BFS_I(inode)->i_metadata_bhs);
 	clear_inode(inode);
 
 	if (inode->i_nlink)
@@ -259,6 +259,8 @@ static struct inode *bfs_alloc_inode(struct super_block *sb)
 	bi = alloc_inode_sb(sb, bfs_inode_cachep, GFP_KERNEL);
 	if (!bi)
 		return NULL;
+	mmb_init(&bi->i_metadata_bhs, &bi->vfs_inode.i_data);
+
 	return &bi->vfs_inode;
 }
 
-- 
2.51.0


