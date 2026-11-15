Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC85606A327
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 00:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ruzCbV5h
Received: by kanga.kvack.org (Postfix)
	id E4B426B05B3; Sat, 14 Nov 2026 19:15:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAAE6B05B4; Sat, 14 Nov 2026 19:15:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38AD6B05B5; Sat, 14 Nov 2026 19:15:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EAA46B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:15:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 210271604BA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:15:34 +0000 (UTC)
X-FDA: 85435434588.16.8CD652D
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 475FE140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 00:15:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ruzCbV5h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794701732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqr6MyIodV9h4/OO0jWOPYjNv1F5SYtqgxsNyjc0I/0=;
	b=zIVVMr6ldD577t1sy0ItLa58AKmUBz/nTK5vKUm8gb6CRkxAhMA+o5ga3jzPEYycl71rmu
	UoUbogTkYE9KzSrqTjHBM0XXVCCSnN2urn0mut7ImitKg+zfigarNjYI9hF+H1MS62bb5j
	CcbWl9N92vHP7s8Z+xYX2+93H02eU9I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ruzCbV5h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794701732;
	b=ptoxsQdXuCYg+0QyokUODdfqzK26kR7qt28btOThnuc3yiA/jAVtwgtUZbxRF9qdRUrKR8
	69DbWWydsIQZ8bHRt1H4bjaLtBxf/vKOBSZLgCqI653oyD/sKdAhgp07gMzM833KmW+aPM
	Ff7affPkK0JiIhkPXMH86V/05UsXDcc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4bb6adaf0f1so681085e9.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 16:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794701731; x=1795306531; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xqr6MyIodV9h4/OO0jWOPYjNv1F5SYtqgxsNyjc0I/0=;
        b=ruzCbV5h/WnGHHzNrrpD5XmH1nFHZY7cE5f+h7SQG7cT24LaNxCC0mhO4a/jci+RxI
         SKGwpGcTuZKN1emJjlt0PzbE5i9cLqXQiFQN5STrCjPBW2XIefhUCZ/SG4XKguqE+OfC
         wqC/H2SN6TlO/bWYNDbAxWGAsfVy6+VHx04NV9er6TxDUON2DeS0TtNdyQq7O6YZB34I
         GAi7HmgChw9OeyuxlFiJyk5XzGQ9tcVRa92IBpQKjvIU1nCGDAcaTFZndQ0c6DrENa0k
         RfRrbrG1Vma+K61vkD8MoqjGN9XK4RzYtG6UpLFh8J4dSIfi3VmtWc5enPJDUPn5l3I9
         m/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794701731; x=1795306531;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xqr6MyIodV9h4/OO0jWOPYjNv1F5SYtqgxsNyjc0I/0=;
        b=Bh2JcZOAe+prdlmwzcZSz6hI5j+JnaO31rrSZvjm87ZymICC0OFKYlJ9Wxp0+OeXvU
         1jPZbbLsPqBTvzxboN/dCgDHoMAv1MeYbKJ9rSWv0kjWTX/EWf5uB3fNUZcHG7wAitDk
         eNuhb8u+Rmxa1bWY2ccLdPBnNF/uAhZlrG0ma8hZvbOhrDccT1WBxenWFkJkVJzRG/xR
         P9o4itZbCLu7I9SEB5OT5sksBwdiXbakX3sUx5wILt7dEITXEX4lGUPc9Eko3kmG0xPp
         Cafnbu/iTlILfYqJpbjvkyLDzg/KyWE4MijrTjTACEguQcfTok0soiiP27T/WVP4JsPI
         Aggw==
X-Forwarded-Encrypted: i=1; AL+hErF8a9CeGCQnK7eqEerNFLQtQZi2pWtvb4+iDlY/hgoB4VRiSyCnzkyNXfPkctXdK3FFxcbAU+ib7w==@kvack.org
X-Gm-Message-State: APuU4Z96r26C5bXzLf97nDGI9AE/c3mHDDpYfUxTDdlasSaPVrlxxkQV
	CtytviQd562ZrkTXEfZijspCwD4WUcuRYMIaHT133BG1ulGP2nY7z5UJ
X-Gm-Gg: AYBFou0/F5/n/dbvYS8gWE2+uKDjJRR4k5t8NL/6qHlwZYHQuyIU52HZQfxGbKGfqVu
	Z3fSXm/ZxlrCF1Ei/yHRTfzRVyL30IhyPbyBVOiP3LdqZ5CkvRzyBsW9s0IlImbohDrpCTREJHM
	i5m5KvTsvX49zCtf6X/MKTH3HLbje0FHZcA44E+0ZJ5xXy8NKHU4WXIBmTZL2s5xAInKeI6UhJm
	YZNn6j/AvA48Pbi0pr8Opf5R/kjV79aUTgSwtpPnrQvISWd8J2hjHCr/HaK4hiz1NRiysmMg3HU
	5ARXX0pORDh46HGcG2RolTJ0HyElsUzO15/RCQMqgvF2LD/itE7Aq/fa0TnshMfl+AUA1d8SuUO
	/U7q3Y3WLQJSoLaZOxrjT5eHcx8eCI1xysMoYs0HV22LiyTBnZmbjU2UTZBjskR6LnkIZnPt6Td
	9/Fvvf4ZUqajPn6VqzKUdFohpPGXFtMxrVsOJTr6nKuJyfqLpr6OL2vjljQkSmBtMht79hjDgGu
	FDYOyC9N0cLtz9A25FwsjhL2nDxDaoG1hoBDh2bBi8wE66QZ8F7mX+zzsRu151R3/8wIh3J+Tth
	IsHqTDjU6Oz3eF2ldwMpEp0LKJv8jNgj2ddpDpeIbOsfhje7vdGpvX0yhBT4vl3uRjD3+YdTQV3
	VY4kGYvD3u9Y=
X-Received: by 2002:a05:600c:c16d:b0:4ba:495c:2f5d with SMTP id 5b1f17b1804b1-4bb55a3e3f0mr132213105e9.9.1794701730929;
        Sat, 14 Nov 2026 16:15:30 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.18.115.238])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb55ae4414sm177925125e9.9.2026.11.14.16.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 16:15:29 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: willy@infradead.org,
	jack@suse.cz,
	corbet@lwn.net
Cc: skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Subject: [PATCH v3 1/1] docs: filesystems: update VFS locking documentation
Date: Sun, 15 Nov 2026 01:13:34 +0100
Message-ID: <20261115001334.23026-2-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115001334.23026-1-mohamedalibouhaouala@gmail.com>
References: <20261114235426.20408-1-mohamedalibouhaouala@gmail.com>
 <20261115001334.23026-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 475FE140007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xiotjkqnc5g53rmxmmijfmknhuzhn5o5
X-HE-Tag: 1794701732-140422
X-HE-Meta: U2FsdGVkX18u750OkoSZC/r+2ibjwsOx+F5Rv5iw2C9pbj6qB6KilHs0ZcW8mI1yZjYWgFP+ePzU9I4ZOWUMj2TesNEZbpRmBpgT/+sTaNuERD6GS4hRCxFv8qwSYBwW6vw32xdR7SouLNiZLR/vNBamGbCN/5RV1lK74gsJAr29xfLQCtDH4GAEibXnDjeVN7IsjzQ9ziQZU8zOGaonVHUC+6pkoungjRTzqb/ZW3UjHtWDiKew4Sq/K4Z+uGGjZriLFYajPpeZ4bTb1urQOG/ednG0HPU41pgezBUhVk/TY4aeG0l5Mqme0nPpGEin39RFOlvsEjXixFvIWUbG4/grVDVYAxpziUJWtFmouLWaP31KwS6iXqzZ7ijyK0swhMWKHwX8tlYgBVUzSCaR3FaZSjSnMGiQY82RIsRisVJck7NBRw3otLYNhaPVAZbxD3lcsYBwemsi0RtsgtElgVh9ivCqBfeA1FUCeFwDTMdm+lg2Gt4f8M5Kb/HwpsGIOfcWOxtdsNvfznluul9xiPwfZY0WrLNCF5r48lbxPB4tevLZI9hlBuR0lsuSDROUDjVesgBqu/ai+Pe5cc2i3a+4NR/f25VcQjjLXxShhSNybFFgJ1Fqv+vl0NiBqRKATiN04SK8oknb/e46kyR8L4RdcmZTi1JHrSm1IGs6+EBZ5JiNtfEeRtxgo/srA7v4cko/wUkN/4lVITyDKAZp5rQMgYkceDcwi6eI6hmNRUM0tqtI0z4qY2ZP54eurKHCZutEpBhSqKJynJB4vWox3+AwhcGSvdQHQHRO1v7d0lZTg2oiOd/Gccha6v6KLWMsdNTF0EssevU84gby9LL0F7+gn8ssdJqDlFLe63yNjEdsfH2nGJN4nMQUO8H0hc74Xeg4srG6usr25y7J4BnjkDpS3rR9HeHqTVTiHLnqDLs4sPPfVsJAVYqMhIWHF/Dw3ij1PhNx6G2kAKzSn5o
 At41fWn8
 HUExPS6wTyd0y4bJmWIhrTo3/wUMNHsW+v0cQvdJPK6uaY0jLvIZiD+pe1riLeJyhNbIe+R/GMDq52Jwj66eZTIszlOBD1l9qqTdIddTXlqlGShES427ecfc7cqCjqLgYcb1EeUHjlEPc7DRLWBcNGK6+MdkBkz/FcW1Mt1f1M1NxEaX0N59V7MbtVHY+1HcfvzdmE0a0wyP2iUkLipAYRugz6ggr+6vHFZCONUceiEYKbtW3Do1EA5OFxP3UFFrrUO7lSqTnG2TAY3uon1TS2DGK/JJ5tpW2KuD1MG/7bU71/iBjovkAAu+fZ9BWJiyttJB2uMV5sYrt84QlntfCJlcAL+dpVfFXgQCkZhDoUyjDB4J7BXsaGlYOOMq8KUlfBupA8nP5nTCuCm5Z83Puajc2SqKfioKdXi//
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Update outdated VFS operation prototypes in locking.rst to
match their current definitions.

Add the missing d_prune and sync_inode_metadata callbacks,
and correct the signatures of existing operations.

Update the locking table to include sync_inode_metadata.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
---
 Documentation/filesystems/locking.rst | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index f7363ad770c7..a6a011858ada 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -26,6 +26,7 @@ prototypes::
 	int (*d_delete)(struct dentry *);
 	int (*d_init)(struct dentry *);
 	void (*d_release)(struct dentry *);
+	void (*d_prune)(struct dentry *);
 	void (*d_iput)(struct dentry *, struct inode *);
 	char *(*d_dname)(struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
@@ -80,8 +81,8 @@ prototypes::
 	int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
-	void (*update_time)(struct inode *inode, enum fs_update_time type,
-			    int flags);
+	int (*update_time)(struct inode *inode, enum fs_update_time type,
+			    unsigned int flags);
 	void (*sync_lazytime)(struct inode *inode);
 	int (*atomic_open)(struct inode *, struct dentry *,
 				struct file *, unsigned open_flag,
@@ -173,6 +174,7 @@ prototypes::
 	void (*destroy_inode)(struct inode *);
 	void (*dirty_inode) (struct inode *, int flags);
 	int (*write_inode) (struct inode *, struct writeback_control *wbc);
+	int (*sync_inode_metadata)(struct inode *inode, struct writeback_control *wbc);
 	int (*drop_inode) (struct inode *);
 	void (*evict_inode) (struct inode *);
 	void (*put_super) (struct super_block *);
@@ -196,6 +198,7 @@ free_inode:				called from RCU callback
 destroy_inode:
 dirty_inode:
 write_inode:
+sync_inode_metadata:
 drop_inode:				!!!inode->i_lock!!!
 evict_inode:
 put_super:		write
@@ -255,7 +258,7 @@ prototypes::
 				loff_t pos, unsigned len, unsigned copied,
 				struct folio *folio, void *fsdata);
 	sector_t (*bmap)(struct address_space *, sector_t);
-	void (*invalidate_folio) (struct folio *, size_t start, size_t len);
+	void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
 	bool (*release_folio)(struct folio *, gfp_t);
 	void (*free_folio)(struct folio *);
 	int (*direct_IO)(struct kiocb *, struct iov_iter *iter);
@@ -265,7 +268,7 @@ prototypes::
 	bool (*is_partially_uptodate)(struct folio *, size_t from, size_t count);
 	int (*error_remove_folio)(struct address_space *, struct folio *);
 	int (*swap_activate)(struct swap_info_struct *sis, struct file *f, sector_t *span)
-	int (*swap_deactivate)(struct file *);
+	void (*swap_deactivate)(struct file *);
 
 locking rules:
 	All except dirty_folio and free_folio may block
@@ -455,14 +458,15 @@ prototypes::
 	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
 	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
-	int (*iopoll) (struct kiocb *kiocb, bool spin);
+	int (*iopoll)(struct kiocb *kiocb, struct io_comp_batch *,
+			unsigned int flags);
 	int (*iterate_shared) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
-	int (*flush) (struct file *);
+	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
 	int (*fsync) (struct file *, loff_t start, loff_t end, int datasync);
 	int (*fasync) (int, struct file *, int);
@@ -475,7 +479,7 @@ prototypes::
 			size_t, unsigned int);
 	ssize_t (*splice_read)(struct file *, loff_t *, struct pipe_inode_info *,
 			size_t, unsigned int);
-	int (*setlease)(struct file *, long, struct file_lock **, void **);
+	int (*setlease)(struct file *, int, struct file_lease **, void **);
 	long (*fallocate)(struct file *, int, loff_t, loff_t);
 	void (*show_fdinfo)(struct seq_file *m, struct file *f);
 	unsigned (*mmap_capabilities)(struct file *);
-- 
2.43.0


