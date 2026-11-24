Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E466606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S0qmPOP0
Received: by kanga.kvack.org (Postfix)
	id 38FA06B0874; Tue, 24 Nov 2026 17:39:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367176B0875; Tue, 24 Nov 2026 17:39:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CCD6B0876; Tue, 24 Nov 2026 17:39:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFD196B0874
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:39:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBA271609E6
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:39:06 +0000 (UTC)
X-FDA: 85471479492.06.00F49DE
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf25.hostedemail.com (Postfix) with ESMTP id 030E8A000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:39:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S0qmPOP0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795559945;
	b=hU33em1pQAuMf8R70a0H6QrI9zKSxpOLz8Bpv6YcJUMpwzXiUWs4djAMYberOpUvI7pWTp
	Cc2aitkxziHqdlEKSGmBgcISRFdQFSIPn4dYlWyaxTEMR91GJWYWcSnnaycYozbQKp40Cd
	h4Whk3UxL/eSrqqDi2q57BlGJT2TEX8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795559945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxisPRU76epkJqBWYTOk/RRq8HtvboTSfe3gDitjQJo=;
	b=h/BcX0fRfpTLzvu430R/yGmNrXkzuTsFxDbTnAWBsDmfVZze0GPMqiQyk4tDKk/q2zJtbx
	YpULCtG5P5qyIt8wJHM3q+T5/tNAV+cnpZlC06WVGLXk2zQNaYn9NKOKRukDpkvAmA4zxn
	bQ4vCW8Kldy1aP/7F18KHrOZDWSrsbs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=S0qmPOP0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb6c7b6dbdso47428995e9.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:39:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795559943; x=1796164743; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xxisPRU76epkJqBWYTOk/RRq8HtvboTSfe3gDitjQJo=;
        b=S0qmPOP0VZGl5MKAmdZILGiOaVH1+08soctsqARcV2cM/s6jp6hg0ERr1ljUoQJzLG
         dpU7GDKdi7Ut4gTls0wM/tDh96/F5KC7DMwf67Lo7ht/3AFFgdoI9aVhSWqhKSGisslN
         UD/9kdGDJam1Dn2oc09Dx4TDJ/z6kOuaARxAd+dOQL5TvCNcrAp4/LXbR/FqIebrz3MK
         veD7gkRdNMj4C9k7nwzgkLS9AAX4LnuLKJEiyur2Q7U9THiLnqqGWvpXDc2lDLXQMp9L
         LIc9+giX8fm3hpBAmtuixggGi42xnAhQHyAhn24aO1MeLmGHOeDxiotqMCgVTWmBaZgn
         GclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795559943; x=1796164743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xxisPRU76epkJqBWYTOk/RRq8HtvboTSfe3gDitjQJo=;
        b=oVbGPdj5zsf2CexQuwRp7H5gFYFmhFn+FRCIU1zz4u/vNjyzr8fT2JR1sz5UM+t9nq
         P0xR6/ixGOoSnPkkf13x3+4mx6Z5QtNE5L/Nd1qaekFHPL6rUS0Y6KMrNV0Q4N5Uoeqb
         fNrE4Ib2gUI29pO5N/KA7ZlW+uXly3MdXNtYmonIgQ8wKq0IVovHV1zDG9sz0R6CtEZo
         7PgA3Fcdz/cVTO0MTaJ3S+MoEpEz/Z2+BPVAwM7CK0DICUazqlUBH2+rb7w5hD2mg2qb
         51zpKyHn5vFWBmgbWyhRb5ObK0qptTBjsPGrVKqY++uEF0iRDGExjtj9UuJ5X+YziwJ1
         pPMw==
X-Forwarded-Encrypted: i=1; AL+hErF550ss0Fvx7D+xX/fg67Wi+yVRtbDJI6ozAzOqy+UqJjg29bThM12bvoc0XzQUhs/so8oqLBsekQ==@kvack.org
X-Gm-Message-State: APuU4Z8OBKXH3WymUhig0q6m6S9ixLiVusejDX6mHUou33rwNW9yi21J
	voTB9tE/0In8u7ivs3wN4cxMM8RLz3R99oQCpAS6KMSWPIcoK/3ojhGU
X-Gm-Gg: AZFdTZfDu0oMuCcUnE1XBI1N3ALuk+qudfcISCXD1cVPOIZX+Sld9MkXLiM+qQyQYfq
	+LnTSejQqYUT6fr8q8waru5uCjusWoUeAbFp/yyzMbbRzOfTNTqwroh8i+9aB75m8fRyk9L0lOC
	90g7OPhYxQoG45P1qUDdBfIT89L7CNOfb6qXJPt4CgFIhNoeZ2l3nmY8HIjPQtyfJw6mJ+IXGwF
	fOmxmr6Wf8ouLTDOEcua3Ufnyog4D32ZfoYoEpc8ERvh0VnKp0PEJ6i7lcKYNNysx6+0nyOG0X+
	FLnD2cA5w95ODdFJSeCCwHW6p++n08st2uTnK8Z/zrJ/T/BU0MfIamRiSgeCW/Qx8UeZxTrrT6l
	DLhT4tLO5WSx/Ras554ofdOFHT8eoA/2EzuCanbZrBXjcpvb4zAs3lHmUd/9cAb5tDOQKtp3WWq
	QfM8vKLbJseVpmArF+XVJj6Byq00eNIZN4WF+o2By2UJQxR+k9YTMd8e7cp2FTyJOHPjoft/cmy
	5i1BD5PysRJePR3CVbtYKVUoLGcDyJmHf9MuLBxS4Lyr0aginK2tsqaumGbjceWL5P3MqbBcI8S
	nuNX+smT59jZ8e4Ur3tzhW9O7RMO8mQVzAeoBzxhpAZ/hBTKNqpd+lp0Ct/C1IjP+h40tzvInKE
	hv9wpucBsow==
X-Received: by 2002:a05:600c:64c9:b0:4bb:8701:bb14 with SMTP id 5b1f17b1804b1-4bb88804d1cmr356715265e9.5.1795559943054;
        Tue, 24 Nov 2026 14:39:03 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.21.41.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab5ffcad11sm29362193f8f.0.2026.11.24.14.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 14:39:02 -0800 (PST)
From: mohamedalibouhaouala@gmail.com
To: jack@suse.cz
Cc: corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	mohamedalibouhaouala@gmail.com,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	willy@infradead.org
Subject: [PATCH v2] docs: filesystems: update filesystem type, superblock and inode documentation
Date: Tue, 24 Nov 2026 23:38:41 +0100
Message-ID: <20261124223841.45091-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <47rkrhjkulqvgfkp3ssvgrrmsfmeof6adtjrght2fcmq6ykbn3@dis6c75io7ri>
References: <47rkrhjkulqvgfkp3ssvgrrmsfmeof6adtjrght2fcmq6ykbn3@dis6c75io7ri>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 030E8A000B
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: f9k94sdousabcrydwfuzkobgzth65pph
X-HE-Tag: 1795559944-872779
X-HE-Meta: U2FsdGVkX1+vnZ7v4zqmo4xS0H/xMT7CP9p2p9NzfoWuvOtLIaaQml8Wc0f8CMYNdrlNHtZDV9UaEXZHcOFUgD1/Li4RlTnDoq/cpaOIpT6ru9e1+TVAfneHriXNkktBHXyAsapRJVAt23CSFsW5GNnFI/vVmaEYNhCoQlOTa7xA0Vs+NHwlKQJ8e52dIc7nc9SW3y4M1i/cloyf6JAIKWUknI1oL9ig84ut8ns2baHNqmo7mbyv+PQJo/tbvTF6ormnbZGyCsIvFG8jVT66S4g8nyNHWag3CrTQZHnzVUjS6ipX7nbNdl5x8cah9jyTPHd/2Mxj+/e8253op6v1/g++A3WEEKB3wD5XN4yg4+9HgTgvZ1o22tz1CIqwMDxfjqzgz4jTZF66cgufmwXz5dvx09fpH8vopzbcxKQFdDDrPxMN9gTckDBPGVePU9k8M3zqrZM7qN0LxwL3I5IHwGMNs1LsKptkuz3cSJ+tQmJ2uSAOOZb0gzgghyb5CMsavF2KY1A/iovuyRnr+6mu8k3SrhkcpW9WTk63ySTmVK39tBbvFx5M/+GkQT6bOV4jqAemRkQ0cZQekC5p1R1k2dhVpdDYxS/lYZDp5f1r2qLFcVJCADxeBb+WPiHrCRpqfaIC9RUGBZMnnDwOe9pl7VJRsyYYBjdpSPnKU877Aj/T6ExMdh9RD++CPwJktU8Zp+15OkWImfsbn2ed131+vWmfnEhfon2FfvrCM7bhHSmKkhwQoAgKuXGN1h/cnmQfJ5WJtVdugNWvkZHHCksWMpdlVY9nAOtWLRfiogaGebCX090X4w2O6I4AR6PJHLsjv+t4bnZmuH+U7lfyuH8HqgV5/1i7+KZniYdyU4WJZSGTXesSw3cV2BEz4FIHEd4EmGbDGSGxF1VgJE0QF9xdQHOTihDft8dYxz3nnHEZz2p6hFk2lzwerV3a84fqi5LZ71QZ4PeDbETTywPmmMo
 W5hGRVjK
 HJEHMORVP3p1fi5WK+TfcbF8ewH3C08sSVg67iAlGP2vyjjvAgczjkk0ayRYgN7BRhwJBse8VzuhklRS3q0rdxepTtiJ2sHvIT5pBy7RNGLuDIceX1BZoJquzzINwv26si57+AVKpPvEJwwYIOhrLkLbuXCePxKBh5/v58Z+jrfpShszfiHCVFt76BmTRfS8qI5gDAczWZVW+q4UHeTAigEr0b3sCKey2qIY4QlPKI6+uGK7Vwp5ftNJSNh1sdGf9e3Eh9qoUNTkaF3XAiL3qpnxq8UbV5Ntt2BP+OZfkRUUSWuWqgCr28wXs2Pka9tAJBDESMY8xJEDOVCug5g4DyjvBYMcjmIcgUvNWQqqGfeY0xwvImbWB8Cmgf2V+6vRimqTHlBfDazjHgdzg/yrbs2hXceYNHteg1v+d7TMIXR10Yw9qnnWI4f7a8WtaFloGTvkca9aFEFXIgfvEpaWzO5sAfGFz6ZdtXb6yaESuXrFJPEAo+o7REq+E4OgzJojPdi/7JIol83Yoa+nxW32PBU78tRu2CbLaS8b/rAM2lnwyp2JCYpJBKK7VqTR4dTbpax/Jus91OgsMKLbTOPQ/W0iZ54uES/9ifUEuAqDnsekTCXbm9eekumzZWqe11l0uEdw5+aHOOerkBx/taSgPisqSg46Jj8oo4qSitXUTER/MQRdJPP8y/PFeyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>

Update the VFS documentation to reflect changes in
file_system_type, super_operations, inode_operations structs.

Refresh the documented structure members and callback signatures
for super_operations and inode_operations, including missing
members from documented structs  such as sync_inode_metadata(),
remove_bdev(), shutdown(), report_error(), and fiemap().

Clarify inode allocation and destruction semantics, RCU requirements,
inode eviction behavior, filesystem freezing, and block device
removal handling.

Also fix outdated terminology, callback descriptions, and
documentation references.

Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/vfs.rst | 178 +++++++++++++++++++++---------
 1 file changed, 128 insertions(+), 50 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a4371..da4aefb1cc90 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -129,6 +129,8 @@ members are defined:
 		struct lock_class_key i_mutex_key;
 		struct lock_class_key invalidate_lock_key;
 		struct lock_class_key i_mutex_dir_key;
+
+		struct lock_class_key d_lookup_key;
 	};
 
 ``name``
@@ -156,14 +158,14 @@ members are defined:
 	for internal VFS use: you should initialize this to THIS_MODULE
 	in most cases.
 
-``next``
+``list``
 	for internal VFS use: you should initialize this to NULL
 
 ``fs_supers``
 	for internal VFS use: hlist of filesystem instances (superblocks)
 
   s_lock_key, s_umount_key, s_vfs_rename_key, s_writers_key,
-  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key: lockdep-specific
+  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key, d_lookup_key: lockdep-specific
 
 The Superblock Object
 =====================
@@ -186,15 +188,16 @@ filesystem.  The following members are defined:
 
 		void (*dirty_inode) (struct inode *, int flags);
 		int (*write_inode) (struct inode *, struct writeback_control *wbc);
+		int (*sync_inode_metadata)(struct inode *inode, struct writeback_control *wbc);
 		int (*drop_inode) (struct inode *);
 		void (*evict_inode) (struct inode *);
 		void (*put_super) (struct super_block *);
 		int (*sync_fs)(struct super_block *sb, int wait);
-		int (*freeze_super) (struct super_block *sb,
-					enum freeze_holder who);
+		int (*freeze_super)(struct super_block *sb, enum freeze_holder who,
+			    const void *owner);
 		int (*freeze_fs) (struct super_block *);
-		int (*thaw_super) (struct super_block *sb,
-					enum freeze_wholder who);
+		int (*thaw_super)(struct super_block *sb, enum freeze_holder who,
+			const void *owner);
 		int (*unfreeze_fs) (struct super_block *);
 		int (*statfs) (struct dentry *, struct kstatfs *);
 		void (*umount_begin) (struct super_block *);
@@ -206,12 +209,15 @@ filesystem.  The following members are defined:
 
 		ssize_t (*quota_read)(struct super_block *, int, char *, size_t, loff_t);
 		ssize_t (*quota_write)(struct super_block *, int, const char *, size_t, loff_t);
-		struct dquot **(*get_dquots)(struct inode *);
+		struct dquot __rcu **(*get_dquots)(struct inode *);
 
 		long (*nr_cached_objects)(struct super_block *,
 					struct shrink_control *);
 		long (*free_cached_objects)(struct super_block *,
 					struct shrink_control *);
+		int (*remove_bdev)(struct super_block *, struct block_device *);
+		void (*shutdown)(struct super_block *);
+		void (*report_error)(const struct fserror_event *);
 	};
 
 All methods are called without any locks being held, unless otherwise
@@ -219,23 +225,46 @@ noted.  This means that most methods can block safely.  All methods are
 only called from a process context (i.e. not from an interrupt handler
 or bottom half).
 
+Exceptions:
+
+* ``->free_inode`` is called from an RCU callback and must not block.
+* ``->drop_inode`` is called with ``inode->i_lock`` held and must not block.
+
 ``alloc_inode``
 	this method is called by alloc_inode() to allocate memory for
 	struct inode and initialize it.  If this function is not
 	defined, a simple 'struct inode' is allocated.  Normally
 	alloc_inode will be used to allocate a larger structure which
 	contains a 'struct inode' embedded within it.
+	A filesystem that defines ->alloc_inode must also define
+	->free_inode or ->destroy_inode (see below), because the VFS
+	default would free the inode into its own cache.
 
 ``destroy_inode``
-	this method is called by destroy_inode() to release resources
-	allocated for struct inode.  It is only required if
-	->alloc_inode was defined and simply undoes anything done by
-	->alloc_inode.
+   This method is called by :c:func:`destroy_inode` to release resources
+   allocated for ``struct inode``. It is called synchronously, before
+   the inode memory is freed.
+
+   The VFS handles inode memory as follows:
+
+   * If ``->free_inode`` is defined, the VFS frees the inode through an
+     RCU callback that invokes ``->free_inode``. In this case,
+     ``->destroy_inode``, if defined, must release only other resources
+     and must not free the inode itself.
+
+   * If ``->destroy_inode`` is defined without ``->free_inode``, it is
+     responsible for freeing the inode memory, including deferring
+     reclamation until it is safe to do so.
+
+   * If neither is defined, the VFS frees the inode to its own cache.
+     This is only correct when ``->alloc_inode`` is also not defined.
 
 ``free_inode``
-	this method is called from RCU callback. If you use call_rcu()
-	in ->destroy_inode to free 'struct inode' memory, then it's
-	better to release memory in this method.
+	this method is called from RCU callback, after
+	``->destroy_inode`` (if any), and must free the memory of the inode.
+	It must not block.  Prefer it over calling  :c:func:`call_rcu` from
+	``->destroy_inode``: if ``->free_inode`` is defined, the VFS does the
+	:c:func:`call_rcu` for you.
 
 ``dirty_inode``
 	this method is called by the VFS when an inode is marked dirty.
@@ -251,18 +280,30 @@ or bottom half).
 	disc.  The second parameter indicates whether the write should
 	be synchronous or not, not all filesystems check this flag.
 
+``sync_inode_metadata``
+	called by the writeback code to synchronize inode metadata
+	that was previously written asynchronously.
+	The writeback_control argument describes the writeback mode.
+
+	Optional.
+
 ``drop_inode``
 	called when the last access to the inode is dropped, with the
-	inode->i_lock spinlock held.
+	``inode->i_lock`` spinlock held; it must not block.
 
 	This method should be either NULL (normal UNIX filesystem
-	semantics) or "inode_just_drop" (for filesystems that do
-	not want to cache inodes - causing "delete_inode" to always be
-	called regardless of the value of i_nlink)
+	semantics) or ``inode_just_drop`` (for filesystems that do
+	not want to cache inodes).
+
+	A non-zero return value makes the VFS evict the inode immediately,
+	regardless of the value of i_nlink:
+	``->evict_inode`` is called if the filesystem provides it,
+	otherwise the VFS truncates the page cache and clears the inode
+	itself.
 
-	The "inode_just_drop()" behavior is equivalent to the old
-	practice of using "force_delete" in the put_inode() case, but
-	does not have the races that the "force_delete()" approach had.
+	The :c:func:`inode_just_drop` behavior is equivalent to the old
+	practice of using :c:func:`force_delete` in the :c:func:`put_inode` case, but
+	does not have the races that the :c:func:`force_delete` approach had.
 
 ``evict_inode``
 	called when the VFS wants to evict an inode. Caller does
@@ -281,11 +322,13 @@ or bottom half).
 	should wait until the write out has been completed.  Optional.
 
 ``freeze_super``
-	Called instead of ->freeze_fs callback if provided.
-	Main difference is that ->freeze_super is called without taking
-	down_write(&sb->s_umount). If filesystem implements it and wants
-	->freeze_fs to be called too, then it has to call ->freeze_fs
-	explicitly from this callback. Optional.
+	Called instead of ``->freeze_fs`` callback if provided.
+	Main difference is that ``->freeze_super`` is called without taking
+	down_write(``&sb->s_umount``).  The second parameter identifies the
+	freeze holder, and the third identifies the owner of the freeze.
+	If filesystem implements it and wants ``->freeze_fs`` to be called too,
+	then it has to call ``->freeze_fs`` explicitly from this callback.
+	Optional.
 
 ``freeze_fs``
 	called when VFS is locking a filesystem and forcing it into a
@@ -332,6 +375,7 @@ or bottom half).
 
 ``get_dquots``
 	called by quota to get 'struct dquot' array for a particular inode.
+	Managed under RCU rules. More info in Documentation/RCU/whatisRCU.rst.
 	Optional.
 
 ``nr_cached_objects``
@@ -339,16 +383,17 @@ or bottom half).
 	return the number of freeable cached objects it contains.
 	Optional.
 
-``free_cache_objects``
+``free_cached_objects``
 	called by the sb cache shrinking function for the filesystem to
 	scan the number of objects indicated to try to free them.
 	Optional, but any filesystem implementing this method needs to
-	also implement ->nr_cached_objects for it to be called
+	also implement ``->nr_cached_objects`` for it to be called
 	correctly.
 
-	We can't do anything with any errors that the filesystem might
-	encountered, hence the void return type.  This will never be
-	called if the VM is trying to reclaim under GFP_NOFS conditions,
+	The VFS cannot do anything with errors the filesystem might
+	encounter, so no error code is returned: the return value is the
+	number of objects freed.  This will never be called if the VM
+	is trying to reclaim under GFP_NOFS conditions,
 	hence this method does not need to handle that situation itself.
 
 	Implementations must include conditional reschedule calls inside
@@ -357,8 +402,32 @@ or bottom half).
 	about whether implementations will cause holdoff problems due to
 	large scan batch sizes.
 
-Whoever sets up the inode is responsible for filling in the "i_op"
-field.  This is a pointer to a "struct inode_operations" which describes
+``remove_bdev``
+	Called when a block device backing the filesystem is being
+	removed. Filesystems that support graceful removal of a
+	device and can continue read-write operations should
+	implement this callback.
+
+	Return 0 if the filesystem can continue read-write
+	operations. A non-zero return value, or the absence of
+	this callback, causes the filesystem to be shut down as usual.
+
+	Optional.
+
+``shutdown``
+	Called when the filesystem needs to be shut down following
+	block device removal.
+
+	Optional.
+
+``report_error``
+	Called to report a filesystem error. The callback receives
+	a pointer to an error event describing the error.
+
+	Optional.
+
+Whoever sets up the inode is responsible for filling in the ``i_op``
+field.  This is a pointer to a ``struct inode_operations`` which describes
 the methods that can be performed on individual inodes.
 
 
@@ -410,7 +479,7 @@ struct inode_operations
 -----------------------
 
 This describes how the VFS can manipulate an inode in your filesystem.
-As of kernel 2.6.22, the following members are defined:
+The following members are defined:
 
 .. code-block:: c
 
@@ -433,8 +502,9 @@ As of kernel 2.6.22, the following members are defined:
 		int (*setattr) (const struct mnt_idmap *, struct dentry *, struct iattr *);
 		int (*getattr) (const struct mnt_idmap *, const struct path *, struct kstat *, u32, unsigned int);
 		ssize_t (*listxattr) (struct dentry *, char *, size_t);
-		void (*update_time)(struct inode *inode, enum fs_update_time type,
-				    int flags);
+		int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
+		int (*update_time)(struct inode *inode, enum fs_update_time type,
+			unsigned int flags);
 		void (*sync_lazytime)(struct inode *inode);
 		int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 				   unsigned open_flag, umode_t create_mode);
@@ -460,16 +530,18 @@ otherwise noted.
 ``lookup``
 	called when the VFS needs to look up an inode in a parent
 	directory.  The name to look for is found in the dentry.  This
-	method must call d_add() to insert the found inode into the
-	dentry.  The "i_count" field in the inode structure should be
+	method returns ``d_splice_alias(inode, dentry)``;
+	(or :c:func:`d_add` plus return NULL for non-directories,
+	and for negative dentries).
+	The ``i_count`` field in the inode structure should be
 	incremented.  If the named inode does not exist a NULL inode
 	should be inserted into the dentry (this is called a negative
 	dentry).  Returning an error code from this routine must only be
 	done on a real error, otherwise creating inodes with system
-	calls like create(2), mknod(2), mkdir(2) and so on will fail.
+	calls like ``create(2)``, ``mknod(2)``, ``mkdir(2)`` and so on will fail.
 	If you wish to overload the dentry methods then you should
-	initialise the "d_dop" field in the dentry; this is a pointer to
-	a struct "dentry_operations".  This method is called with the
+	initialise the ``d_dop`` field in the dentry; this is a pointer to
+	a struct ``dentry_operations``.  This method is called with the
 	directory inode semaphore held
 
 ``link``
@@ -487,28 +559,29 @@ otherwise noted.
 	d_instantiate() just as you would in the create() method
 
 ``mkdir``
-	called by the mkdir(2) system call.  Only required if you want
+	called by the ``mkdir(2)`` system call.  Only required if you want
 	to support creating subdirectories.  You will probably need to
-	call d_instantiate_new() just as you would in the create() method.
+	call :c:func:`d_instantiate` just as you would in the :c:func:`create` method
+	but preferably :c:func:`d_instantiate_new`.
 
-	If d_instantiate_new() is not used and if the fh_to_dentry()
+	If :c:func:`d_instantiate_new` is not used and if the :c:func:`fh_to_dentry`
 	export operation is provided, or if the storage might be
 	accessible by another path (e.g. with a network filesystem)
-	then more care may be needed.  Importantly d_instantate()
-	should not be used with an inode that is no longer I_NEW if there
+	then more care may be needed.  Importantly :c:func:`d_instantiate`
+	should not be used with an inode that is no longer ``I_NEW`` if there
 	any chance that the inode could already be attached to a dentry.
 	This is because of a hard rule in the VFS that a directory must
 	only ever have one dentry.
 
 	For example, if an NFS filesystem is mounted twice the new directory
 	could be visible on the other mount before it is on the original
-	mount, and a pair of name_to_handle_at(), open_by_handle_at()
-	calls could instantiate the directory inode with an IS_ROOT()
+	mount, and a pair of :c:func:`name_to_handle_at`, :c:func:`open_by_handle_at`
+	calls could instantiate the directory inode with an :c:func:`IS_ROOT`
 	dentry before the first mkdir returns.
 
 	If there is any chance this could happen, then the new inode
-	should be attached with d_splice_alias().  The returned
-	dentry (if any) should be returned by ->mkdir().
+	should be attached with :c:func:`d_splice_alias`.  The returned
+	dentry (if any) should be returned by ``->mkdir()``.
 
 ``rmdir``
 	called by the rmdir(2) system call.  Only required if you want
@@ -587,6 +660,11 @@ otherwise noted.
 	called by the VFS to list all extended attributes for a given
 	file.  This method is called by the listxattr(2) system call.
 
+``fiemap``
+	called by the VFS to report the extent layout of a file
+	via the FIEMAP ioctl.
+	More info in Documentation/filesystems/fiemap.rst.
+
 ``update_time``
 	called by the VFS to update a specific time or the i_version of
 	an inode.  If this is not defined the VFS will update the inode
-- 
2.43.0


