Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFAB0606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I0J6J6QI
Received: by kanga.kvack.org (Postfix)
	id 05DC46B05BB; Thu, 12 Nov 2026 11:21:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0357A6B05BC; Thu, 12 Nov 2026 11:21:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67096B05BD; Thu, 12 Nov 2026 11:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55796B05BB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:53 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4AD05A8283
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:21:53 +0000 (UTC)
X-FDA: 85426983306.26.BE5CA11
Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A55A4000B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:21:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=I0J6J6QI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
	b=EPQl6TNZgWCHs1RFZE/l1pzs0KTjvSNwGdQ6FMXfBxarJibpUE8yadDw82H94p1kLgZylU
	tGDTBtGpiEevVpLnW4ceE/Ji9FYT2LiGqs+8LlZUxORF6f4q9p3yYBbKIm5weu6bJPBbmK
	N7nwF5EpdcuHnp4U9Qjbuem48k4fdmc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=I0J6J6QI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 74.125.225.139 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500511;
	b=tgnw3cJT+XDlc7R2Usko+yQo2jETvKYgx1KdOsHQeusPkFSTLanZ8bipK+Kp/FNqNaMl8a
	ZW6xd2Dnym+wpCtsCHFbrF/gAzdBL9siyWJHO3azUdMQIGyH2kK/pz1CYXFN84r3sFvyUr
	c2Y5FbBa/zDbtMiNPceb+TlJIfev8vQ=
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49814d35686so2143995e9.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794500510; x=1795105310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
        b=I0J6J6QI/5CsR/4cs9h+oWQ05PYgHNixx7RtcAnkykck/pu9ZA75awj3rOqVvLLdVH
         SR6rsYAjkMHp0xtullujhpS1raGFb3FLI3i+HFGfDIo0DbxI24+ac5+GaewlImKFD5qW
         QgXlg48sdE5ycTpfpuOnBjImIKeOw9YlGAQluO+qz7QQNzlanp5uAs83UZC7DETnN0kX
         ysp9DKQ0GYMpUWFbagp2UhI8QdQ1vMnitVhJjB71TLBz1j1p1/4o8GfsXaXG8elFtznD
         EvcaRATVJZcuBnq/hO4eTbb4kdl8+AYFvZjI/+ul1kfbiXkBmidcVymlLYOvnywPWehJ
         LrIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500510; x=1795105310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvGNkEQXxpCGRnxugPg2OroUq4ixAzACPllCORFjj2w=;
        b=jMYKYIgEvl+MjfFCXiBsm3WpY/3jCoJvhSLPg02xRAs3P+6r26dhRoOGH7pAgO27eQ
         FwRHr8juu5eYN1WoyiCXjjoTDXdqKqld1eRPA0Q+Es34C9UQ9yCFF8+cHXezlwZXVDDm
         TvMB7Gs2XnaB9k4OQ4+ljbaV0+szPTVtbDyEh+xgKDOWY38oYvaba/hHvV39beforZ2n
         2k8kmYgShk1/dC1Z4zJqbqnvPoizqhzYs7yOuzn91g9eEDUdHNjLIIijIrlhzcmrtKpk
         q15Xxx7DzhJ+awnJ2FuCxip0xxcW9q04Vjg5GmuEOA0G58QrNnDe65FNk3g9Kpy5npMU
         hcdg==
X-Forwarded-Encrypted: i=1; AL+hErGJlJGBCKPPh1wD5k9Hjl0wkVMS7E5CU+656ntImkeUOZKAmg4IqZ/te6N/0TOCgwEhxtP8Pyp9Vg==@kvack.org
X-Gm-Message-State: APuU4Z9jH1DOvLx6gIV0V/qDqJWGtDOT2zpCp0rn/npbSwnsA1JLE8pp
	5lIlw70hWEKfIRO7gOjs3s5ZF/OrCoOWl87IHZYkgog+9ACNpzJf6BFQ
X-Gm-Gg: AYBFou30D7MvqA/Tyk+a1oR7o+Xj0Ml5GoZPUBEIcmQyN9b3uwJvfE1KOXlaV8LRp9b
	oQMWSPYsOp6CxeW7zoHTpY4DtttjuM6ClpmIOGreqp/dLSSHf7bbr/xnVlTKkv64UXTLJrBcbZx
	WBDRtrZSgvc+mCVRoXRCXXqDYZ2SVO11DV41GM05UvJSXOaDTTum5ngHCGmOQKs+/N83eSEmeLE
	IWKb7Ufl0GL8rEoUoucIK5lP0/nhpt/KDCa3cziUJVWJLvB9hD75CEqohB4pwcQPvVhO+noajGx
	gd7NsbDSnGsN27IAxvlsy0krbp8lYODJ+jR3j9nKBCrYePB2KnpOyRz3qZP9dm61q7uAmxtXEwt
	JL1+Lh1Crnadti5n2Y7BUxR0/ygNZ9bHNJWA6OH+hzBDzb5KIujp8Q0qmfAFe/GwiJbzTmFR6MX
	kZrPXWeaq023eGEzmrOEgby1gpcScujHD55b0beTJrXz5EwooXz+/1owl1kKRRciMZVKUfUGTCS
	tIWDqRIVgvYICcYUGmwGFPRIeSOXfCyAML2wQhWhSMGDZR8mN9KFMNsuDAj5n1Q+tdZGucfY4tA
	dCnGg9JUj2O9p3TaCRJOV8yfuW3uDoJnOnWJTqJ/YXbM7fzCiwN/KuJfLf6NY72EF3A5XpBGOpA
	2Pw==
X-Received: by 2002:a05:600c:37c8:b0:4a1:88df:8a2a with SMTP id 5b1f17b1804b1-4bb4e28d48emr67944075e9.13.1794500509593;
        Thu, 12 Nov 2026 08:21:49 -0800 (PST)
Received: from localhost.localdomain ([196.178.27.147])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e28c882sm83116425e9.6.2026.11.12.08.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:21:49 -0800 (PST)
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
Subject: [PATCH v2] docs: filesystems: update VFS locking documentation
Date: Thu, 12 Nov 2026 17:21:29 +0100
Message-ID: <20261112162129.77610-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261111160516.30458-1-mohamedalibouhaouala@gmail.com>
References: <20261111160516.30458-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A55A4000B
X-Stat-Signature: 4cfp7ssxoo1i4t9ex8qthq393xute1ug
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794500511-528650
X-HE-Meta: U2FsdGVkX18LL9Jm+oVPjwwjhOImDF2+nRK+f3ciXkJQ8OVxaNXQFyv1A2qxv20NoI3JplvB/51Sw7hnbYvOwLntqZRIxMnbTLirYkfP0iQ/IoTJQoQuehXdwC/BvKvxOQoombsCvYTrPz3a7evJTTwV31GCXnc7cS4mUmTmnzcSWLsufQ0m5hpy75IfoKCl1ywvF5aB0J70Co9ZkTRVded9UEpM7SP1R6TznKrXP2Q+4ilkehwTcA1VOilKbdZ7/02XD8ke8SrSB7LlIVT89SnFl1teHCkMBqfypyl+TifLNxmhcz1GEiXTb+4GTA1Sjqnvy2XN3WWNRpXcnq6ZuN4HPTc+Q+t3ba5LX+GdBU74qP0p/NHIbnThXneC1tQT+C3RCWZSwribICdPfyykwQdi38i4BgeZBctefHFSF+IbDIEkAh7P4F/rN1gTvjdwkD2PpOC3LsbfCysfcX5DOKkVmxiJBx+PeZjadM/WFhDmfjbWiWqEan59PbZJXVnS9Jp6HxXtV2rxNC1ojdzlaRy/SCfRmrk66x3VxW/AXTLsD+ppNwz0YnCXpEiVqEhgRNLmt3gYvtJi+1h6u9Z3g049Twe/0enMela8IafZsfqUXtDZeI1c9Efc5sfttSN+Z8/5ZlWhPCSP1XElj33tk4aEl82xHZgf0vanw1KhGst1zlUB6xY40IfvkUR/ri02LeYnrNNEUK6RUx/kefHKE+z2S6YKOEhfJOEM3LyX2WqY+eg674ASkTCYXeYFzQy0vtMgHReN12cBpYd7t+YXARQw1iinXQ2qdpD9/ccgqotAUQnkzV9bL0bxUtm62sc4Y1kWdsht9vHj2uDFvQFXIlvWG5rdVc6kRXqqW79oCi9RlgED1YLHc8bp2YL4goXAZoqrWqBD/v/evlM5EyKwiqBagkHdO0Su0uJMuffg69+hyFWPKOHTdo9paiJQoRUzNc8RwgLWVDBEv+UQbRt
 sFhnRUai
 lFcEebdyfzeAa6luENTyQU3N8nZ6KDi2fdka51P5BDTQvFF6dPQO/FedVRfEnXPM1qy5fJzxSGcLK5fT0d61OQI+zzhYtAfwfq/HBiMXQs4MFLNfPUPyh7fd/PatC2r1e/EsUHKkX51n20P8wX55NkxqqSihMSkWbCniZjQvkrjt6VylxifpMQ1iD9nHum37YsZBwpFgzURgBy5esPFjWyZpZUy6nOuazWQQ7sc1QTC4+/Vjag5yRDeITNGqIGp+5pirKDLqIp3xLpStreurb5qBTN9tqm5WCGlEuhejmHPmjnUeAbpb0OUHZmPI1WoHcdDfrbH4xz6lrflsJd52Qr0GDZ/a0Ndx81bVw6tB1oHyrIMM6Ci1Nxo6qXjO5kvmWgAZr7twyEcaDHZspWjIIboWEfw==
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

Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
---
v2:
- Use the contributor's full name in the author and sign-off fields.
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


