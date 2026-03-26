Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD36106F315
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D346E6B012B; Thu, 26 Mar 2026 05:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BC66B012D; Thu, 26 Mar 2026 05:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD37C6B012F; Thu, 26 Mar 2026 05:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACBF06B012B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:57:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80795BD026
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:17 +0000 (UTC)
X-FDA: 84587761314.03.7D10376
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2EF2D1C0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:57:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FVyp+ez+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nsTHCMg7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FVyp+ez+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nsTHCMg7;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774519035; a=rsa-sha256;
	cv=none;
	b=TGMxQBNPRVovutWculnu2yvFuJFzYxnjvbn34aCh/L0jeOs6Iandx66z179sb79jVWJN/7
	K1MGhk6ZsYRHjCHCY1bbvfTj7MatOsIuMMyRDb2b23i71IXcpY/DEAg9USm0ae+OKwos3e
	JUMNj61BM1yLdv77uLrqjSk/yAxfSWs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FVyp+ez+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nsTHCMg7;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FVyp+ez+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nsTHCMg7;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774519035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=bUtYtU49tgM0ihf0i5gSeRsh1HHB5d0ZVuhxQk2Sg1cEylfSETO9gbmsJZcwahqQmSlNqd
	11BXIY/Q17pen51vgpcHbIp8s3gxdc8UC5QLFf7YNECgfoKgwohYbpL/fd26/myxHXXtro
	jH5gQmxKe8Hc4S5vyIFerwBEUtK710A=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B42865BDCF;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=FVyp+ez+pMXnzdK8+F8utbKsqM5bcKxnRZkMYp55wzeBBTWuW7YpiqAgz6Zx4A7cqe8N7P
	0uR1dGPHNKEr40u7REjNkC2j6+C4YUgCg0yvuDGj7mefYmIM0BME0USG4FZaD+EM7TND5T
	DLBl+VWWKfSpFSjysEuAGdmo9zW1sQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=nsTHCMg7rXVFSNZ2deRaR9Tm3u3K1LeEc43pVcZNaTSn3rfpRu5eYBzLvcyod+EC+57HtP
	LyMsIYAlPh0m43BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=FVyp+ez+pMXnzdK8+F8utbKsqM5bcKxnRZkMYp55wzeBBTWuW7YpiqAgz6Zx4A7cqe8N7P
	0uR1dGPHNKEr40u7REjNkC2j6+C4YUgCg0yvuDGj7mefYmIM0BME0USG4FZaD+EM7TND5T
	DLBl+VWWKfSpFSjysEuAGdmo9zW1sQg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AIODAvAbVGbN7KnQyYMdml5fqHvpJADDTZ0NvtyGN7Q=;
	b=nsTHCMg7rXVFSNZ2deRaR9Tm3u3K1LeEc43pVcZNaTSn3rfpRu5eYBzLvcyod+EC+57HtP
	LyMsIYAlPh0m43BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9D6BC4A0AA;
	Thu, 26 Mar 2026 09:55:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id seVuJnUCxWkDYQAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:55:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id EA686A0C81; Thu, 26 Mar 2026 10:54:49 +0100 (CET)
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
Subject: [PATCH 41/42] fs: Drop mapping_metadata_bhs from address space
Date: Thu, 26 Mar 2026 10:54:35 +0100
Message-ID: <20260326095354.16340-83-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4216; i=jack@suse.cz; h=from:subject; bh=kczFWBDrNXD3v3KL6CDNGVgTbHR96KS6ROCKzE1gdWE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQJV5o6IhQrEyprnjrzgx9i6umdkI04WMsthz y6BQtWQz9SJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCVQAKCRCcnaoHP2RA 2V46CADd713L2KLLzIfEKJGU0LzA/74iOc36KYxJhqKKYXzlsKKTXpOfQNuiar3EQvQN92933lL 91llF3raE4SWXiQ0ztwuLxNJO3aJkozBQgIk+8I/NS5h+LeR+8uGDktdnc7JrOwMUvKaaJCi3Jy s6oTPbILGYX/5lFLSLFt3b3wKgYqfNFLrJioDL9aj5A0lS4QRdQLNhchN4OhsqjPsemR7V5ulB2 2LqBZXulu/PJhWwP2HD8HK9yAOnj+vrMcgUAWi4O7Yh3kgkVD+DSHRGgB2wnBlNPkIT004ngu50 H3cBfVW+JZzvZ5uYnBPBFyfjRjFI3HoBQSf1iJc6KHVt916g
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 2EF2D1C0005
X-Stat-Signature: 5oggjsh17iffiburs49tyas81ng3qm9f
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774519034-658532
X-HE-Meta: U2FsdGVkX1/UtOc4dgDVEr+QEIaZETkekKECssci8hkly62kbCr5Q1aTAVsKudkCPqeQOvFyV4dHuRq4IyslfC0yq7CDMmxoImupoojF4CJppzQM9j/c/69venuGrhMMNM8DMBmqlwwiAwPcCiBPFG+eqMJzf72yptSWdD43MiBtB7ha1GTpHP1VrL9Z8qAFJJTBwtfOg5nqB7pqfNFC7T9j9py6/1b12QOjQF4K89+I9/bxqnT7TBbOExSVD2CzteNTC900DLFLcX6LZe3Gm3NXv0k25JBmOuF1Cl5KPUx2bZtjmL608+TzF7DF0ThwMYbt/oEpLme7GClaog5BehDn9Gejw6RVM9LvQkrdKLpaPWi8B9GGiR1ubYNC+grL8zGqi0nbs0FOzYmfwTSOHuJwg7FY3tFTmDUZNXyZwdNx6R5qPJsxQhGP+BzyvSVN3HJ2X6sopjIREgNe3j/vwKrcHF69jPMtT0DPW2FqwKhIn/8a6ow3Cr2ozLsFeGKStWqUHAIfQpVuMlmgWF1zjgZUlGaRLyvjEqUfkWu0kcDr2QvtktYs27g1jQoV8Pq84mtZVcWj9x78MEZQ98U2ki8euflhuN89DIPZPCw8KL476ULNgctk24GLQ5g6qSZh9Y3wkG8G5FPhtuz9ENurT5liEvP8U+zmFEHybNzglubFGoRwhzzeJeRTNNT5MjHNtsL+g5NslwRYg3gW0zj37CR7PeJD1p+yOIMCWquMSL/8pLDyK77BXKpfMQcUD9uPq6AX9ycbmradscQGqslfZIvDAYe1OzKNapaPUYcgiEsi1/UqhZmBwipFVI62EiPyPv6jvTXBbCaNshOxzDJ/NZgWrV7nu+9O3S/9Ldmm5lQZpM++04+s5DE9B8LVizPxdi6SXF3rLtq1ke36rAFbTWjqz4iwzZRgQwjAw0JzBxSAGWK0U5zgMIdz7lPg+aN2pTO2CxL03tSVxtLbL0h
 nma5wEAU
 gvV0VbhrvdqjyxMw8uuveo5mcN17tEAenq6tzxcyvBLbVx42+E1GIKVlXlmnAhLPT2WcRZylT9v1hxLMhEfA2peZ0h3qikf2uTrfjGs2cCfSlCbH0gZT7hD+8WN/Tyow/UuZyEMzjFKPeCPosAGok+ESqZvv3KgDoCB239jp9FHEpRjPDD7mxY7Gykk/sKoRHCNlCeH+DUFq551myKbCHUvqYhFwngRR3ebtyX/cNX0Pqe2mxqDfIO5BIpbEGpiCnKHWmVkZjUOFw9WdZjrAyDCylQO8Ix4m/KzBErBSBSapa76MiJEAYrtSog6iZUZVB0uFqsHRRbhjMBkscZtZNZQYSMkZ+EDtOCulXgVvdUBo+VqJ1OrCwNfkgzHxFhJSsioYSUmPRIBFw120=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody uses mapping_metadata_bhs in struct address_space anymore. Just
remove it and with it all helper functions using it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/inode.c                  |  3 ---
 include/linux/buffer_head.h | 28 ----------------------------
 include/linux/fs.h          |  1 -
 3 files changed, 32 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 3874b933abdb..d5774e627a9c 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -276,7 +276,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
-	mapping->i_metadata_bhs.mapping = mapping;
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
@@ -484,8 +483,6 @@ static void __address_space_init_once(struct address_space *mapping)
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
-	spin_lock_init(&mapping->i_metadata_bhs.lock);
-	INIT_LIST_HEAD(&mapping->i_metadata_bhs.list);
 	mapping->i_mmap = RB_ROOT_CACHED;
 }
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index e207dcca7a25..e4939e33b4b5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -207,28 +207,10 @@ void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 
 /* Things to do with metadata buffers list */
 void mmb_mark_buffer_dirty(struct buffer_head *bh, struct mapping_metadata_bhs *mmb);
-static inline void mark_buffer_dirty_inode(struct buffer_head *bh,
-					   struct inode *inode)
-{
-	mmb_mark_buffer_dirty(bh, &inode->i_data.i_metadata_bhs);
-}
 int mmb_fsync_noflush(struct file *file, struct mapping_metadata_bhs *mmb,
 		      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync_noflush(struct file *file,
-						loff_t start, loff_t end,
-						bool datasync)
-{
-	return mmb_fsync_noflush(file, &file->f_mapping->i_metadata_bhs,
-				 start, end, datasync);
-}
 int mmb_fsync(struct file *file, struct mapping_metadata_bhs *mmb,
 	      loff_t start, loff_t end, bool datasync);
-static inline int generic_buffers_fsync(struct file *file,
-					loff_t start, loff_t end, bool datasync)
-{
-	return mmb_fsync(file, &file->f_mapping->i_metadata_bhs,
-			 start, end, datasync);
-}
 void clean_bdev_aliases(struct block_device *bdev, sector_t block,
 			sector_t len);
 static inline void clean_bdev_bh_alias(struct buffer_head *bh)
@@ -537,14 +519,6 @@ void mmb_init(struct mapping_metadata_bhs *mmb, struct address_space *mapping);
 bool mmb_has_buffers(struct mapping_metadata_bhs *mmb);
 void mmb_invalidate(struct mapping_metadata_bhs *mmb);
 int mmb_sync(struct mapping_metadata_bhs *mmb);
-static inline void invalidate_inode_buffers(struct inode *inode)
-{
-	mmb_invalidate(&inode->i_data.i_metadata_bhs);
-}
-static inline int sync_mapping_buffers(struct address_space *mapping)
-{
-	return mmb_sync(&mapping->i_metadata_bhs);
-}
 void invalidate_bh_lrus(void);
 void invalidate_bh_lrus_cpu(void);
 bool has_bh_in_lru(int cpu, void *dummy);
@@ -555,8 +529,6 @@ extern int buffer_heads_over_limit;
 static inline void buffer_init(void) {}
 static inline bool try_to_free_buffers(struct folio *folio) { return true; }
 static inline int mmb_sync(struct mapping_metadata_bhs *mmb) { return 0; }
-static inline void invalidate_inode_buffers(struct inode *inode) {}
-static inline int sync_mapping_buffers(struct address_space *mapping) { return 0; }
 static inline void invalidate_bh_lrus(void) {}
 static inline void invalidate_bh_lrus_cpu(void) {}
 static inline bool has_bh_in_lru(int cpu, void *dummy) { return false; }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index fa2a812bd718..ccfa696253c8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -491,7 +491,6 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct list_head	i_private_list;
-	struct mapping_metadata_bhs i_metadata_bhs;
 	struct rw_semaphore	i_mmap_rwsem;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
-- 
2.51.0


