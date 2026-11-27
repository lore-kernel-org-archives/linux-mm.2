Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B42D606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 00:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6BfDTzs
Received: by kanga.kvack.org (Postfix)
	id 3BB6D6B05B1; Thu, 26 Nov 2026 19:38:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344686B05B2; Thu, 26 Nov 2026 19:38:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 233B86B05B3; Thu, 26 Nov 2026 19:38:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E17486B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:38:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CCB3A0198
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:38:19 +0000 (UTC)
X-FDA: 85479037518.10.7AF2388
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8532DC0003
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 00:38:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n6BfDTzs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795739897;
	b=Et5DjHGaIJnyxBEHMtW/DZ22ovN0pwoegCx0vqZaoCWnZANCYIFZ+zx49/RGzu7Qap6Vtj
	QUreeWqQvlrazE9ifX76eIqjjhNxZ04yhSl1nGOK0nc0D2ke59pSrQyPBn1u1lHLvw8jAc
	xNGmR5whZY0qYtplNfytB9/rfF9bc9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795739897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQlv7s7MQZyUZyhC7qochRPM3hW5uEIxO4smyUjfENM=;
	b=l/c5KjbdEOt0EcKK5eVNY11araAB+q+wwzwj2J3OGgf1Lr+OrDrmvvocWTg1BHH7ohBsfb
	F1nb7le0jgcJra/8PTWOlmK1YhmwOgV4mbNHpaDZ8NoJJtT47hoMonhl0O9fZAJKLSjumG
	EDY8XJP5hVoAwlfcZVJzhdfTLgx2wlg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=n6BfDTzs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4bba5e17cbeso22351235e9.1
        for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:38:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795739896; x=1796344696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQlv7s7MQZyUZyhC7qochRPM3hW5uEIxO4smyUjfENM=;
        b=n6BfDTzs/R10yENWKI+cqfDi3k1CXRwuSwAYEIdJWo+bM/YuiwslSWsbkDrOkzf0qM
         qAil/IGYybdnEClY/h3aI3xMlQl/9PI5hYdwn/RBFnPEzVZGzxnDLd6H+IUV4KjkDdH7
         q8nAO1RQPyMCA8+oLfNcTPFQPlLW71XqxEgvdizhMYthtl9SEoESQp90ix/Tib4rIVK0
         1VuX1V7U1AVR/uiRCLaXLN8kBeGok3zJ3cpcI7f6tdg1jzQGF3TkRyzEIcYUPhofKRfB
         11+xpo+GI6zqNUX+DnwtnLRaNqpiJ2dk3fQ35RwcnJ8cXNiPMhIEqrIzFAsDTQKv8T3v
         P2kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795739896; x=1796344696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQlv7s7MQZyUZyhC7qochRPM3hW5uEIxO4smyUjfENM=;
        b=vjAFxLRgm7iVGeTW44eRW04lEU21XLKjxR7YQUEj8rwmxrhyMn+IVy8tNBR/9jfcdS
         hXWfrHxP9zFbwmNnQBrZIzdDQ//OQ8HZpXSnkkzMWNQiKzLtdetsMBre+AoJdNgqX1n4
         0p7kTYtzG3bo+eV4keDT+FuhG+/aXLgxGPjKMKHBBHqhyiUumionf85m5V0qpFGVxerK
         gDRNRnnbEaYuXoAvqeGioa7PUgbBuSnDNdDtH5Zcxrm6wiX1/d9gsuQ8wsA/c/mjquIG
         yZVFOHmqQJfqYTlTyy/gocBccTxQg1CRVD7nh5Jiry5xOgoQLiqnZUN+EbhmzjY3eF9m
         vG5g==
X-Forwarded-Encrypted: i=1; AL+hErEsv8VA9QD2r98+j3AKjra1tGphkwcgWOMzYzcClZ4Dw77bMwn59RipgawWahx8Go9lXosTVy88vA==@kvack.org
X-Gm-Message-State: APuU4Z/+X/Tu0F+1mQdV5TsjMlC0L07A1ngHC7dj96bAJFRJP3vqHH2Q
	a2aP637f26QfSIXveLtD0DCmaL7127xpPy71RB52hd/BsetzWWoOQ06E
X-Gm-Gg: AZFdTZe8m9eSnVyj02OW7oG4J/G+/RJHYMrmb/KZnpTNPyBd/qk6NyBIIFp4LlYGu9H
	c0Ilk52k+YxkqR+WQZDAi13weqYgsS3SowPdf+mndf6cOnh6dypzLCyPlQyvdNaCI2kXDRKoztf
	EHfX1OzG1pVBvcGecLLEZbDm1sKhfArk5z0yg1CbOrmFrVzb/WW+N9rZDp9kxtz9dte07yfhHGX
	nwp0EmakpYXG+A4ahbrGgGGyyiwqbhdV+Bgo54UlQOuixpcLVqY3Fiha1gsLHbScDVmYXWvQSmd
	h3YnLWX1wPOYz4ElnopS2VyKONnEJvpVptJMnakz+mk3hG3+rEKFvGNFWUjYlvb6TOZKpIc1OjI
	SG6AuB5zIasa9j8N/Vn38c3D/N4F8HvbkjV5v25GEFSLjO257hwgGA3cRpE6T62II6kI0IQnFNS
	V4IzQSK4t5aBXGu2AKrXEH+DqRBpEv9FfLXsbY8E3jIzschA1LylBzfV4xZbV8ruruTEbZxD2xj
	UKHi0dj0poHHW81CZCuNR6per44hC/R2kNHK18cMO8ZLB28Y2v55pmoM62X4PNfOdXm4GvU8JiO
	w/oypi6VsD8six6+WEi+zkCjMAKr/d0M6f5Cw6wfNa5GKCYA9EmwcieCBWcG5SCW3U9x74YpN/U
	iAM05pCKgqA==
X-Received: by 2002:a05:600c:c173:b0:4a1:813f:2a60 with SMTP id 5b1f17b1804b1-4bb88800134mr434979265e9.11.1795739895727;
        Thu, 26 Nov 2026 16:38:15 -0800 (PST)
Received: from mohamedali-HP-EliteBook-840-G8-Notebook-PC.. ([197.21.14.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2c8csm44693592f8f.2.2026.11.26.16.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 16:38:15 -0800 (PST)
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
Subject: [PATCH v3 1/1] docs: filesystems: update filesystem type, superblock and inode documentation
Date: Fri, 27 Nov 2026 01:32:36 +0100
Message-ID: <20261127003236.20196-2-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127003236.20196-1-mohamedalibouhaouala@gmail.com>
References: <sashiko-outbox-234265@kernel.org>
 <20261127003236.20196-1-mohamedalibouhaouala@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rck67oeuxbwuf4dinqko6gx7cyuw6b7u
X-Rspamd-Queue-Id: 8532DC0003
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795739897-210809
X-HE-Meta: U2FsdGVkX19VX2XNdaEtFI1aiVzmvmSMHx6XEIRYJHZp+8L8jPr1qwDGiTW/dkiNWDtPReKQjwHSLukcrBYP/TCpq3WuXGQsdRFSWc82TqUZxKpQt+h7nkP18vAwsp1m0w8ALBQikJ/UpbwPy92PRk7aeMusqTv8O4CIQaDVM3E/Nd8G18zUIcWzIIRr2eHIKbdh3RwEfZLUCGA20xwhJZq9q7DRvfMMok/xdjfRdzH9Ram+uVIfd3kSkaQagtvmtyrfXBzENAnIb4LD7N5bQSwnofaUAEMB2a2dx4J+sTqflC5wrkZwB+qqXCk8VfbiB9hU+fEIHLyC7igKGM/O55FAjeDbfW8Ch47piTqTGQhbqLagi+oNu1L1YL/iVKcjQEx5VcWxJgEW2DfFdwM2Qw7FK8FPqtPnyiXjIjJRWJeWMzm6BGOIQ0TxAzuf92qb5yaA4hYQLIVC8OMUCMdA3PUrt3Dy/NVCOlJzQjg9/W8/XkWwv6tDPbVRNeQKPVO3PhMY3DYPtIOQPLcMPQ9uv93v/G1n1DZf45dT/DlEPymmQFai3jqM1pMSCrPV+gBGUuUn9NWG6wU5VAXEmfQslSD24ZwMYFG8dP7pL6FJf4RUB8b5ml0xNv1BvlHbAcWZhvkyGbpRg7uUVbY+0Ks9iqIdsJaJtneu/WDN7jwa1lmewReE8Vf0Y/4l3VxJFc1LQA+DV8SCk65vLn4/2reafm0sUMFMgUpHTGrSa0dLjHwKmxzVM4fPYOw02Ury0ESjvK7p/0G8YEAcXR08npINNJTXvpVwdeJJ98B8zOP3mcTM3R2DG4Z0ac8JyHotTeN6uAv9Woxq3foreAPxSGruSUeFA8g2LixPaKcZSaiAUmHMXmc0N8Ef3lsVIjqrFhaL5X4UdvjgllAY1J1RwARddbOhazhQU/7z+iER9OIOxh0eXvlsD+YPGSS9JlTvSVr2ggORGXl/xYOMwzSgsfw
 G8qlKKa8
 EFgAzQ4KH7CYv5HR5H+cDNxSD3tO2MgnCoO20UfJfyUju4jBhP6Um59RT4poYgctfYLDeU1OtgspjVuQq9rFFCUNVVwGL3tsQN7PPYkXtXRr9Qca6tsWNh2xNRvQHF1N+xUlTfNPunzOdgdUnCTQxKR15xmLR1A3f9EgO7r3GMUHbHYmon0TykamQ7Vm3MhE4dXlEEm3zW4dRUQDVocH/XKyFdej+xij9PSF+dPSTcXPt0LX+gjF7x6WmZ3i8YTRaoayrMsbhbCUYEJzjdVSC4qr3+Qh+Q+WoxOXXWEAp9IrJlqzj9c9k3Vyy3fZ0LuSAyckbSCC6h1DvONAnJxvT9w0A3ReWBeh6Wh1Py+AtgUw3gOud36K4vs45n0Ikx91MZlC20aFuFfl9hiCeuAsMfP2NhRRL6ukoFPLP1fha0u+xqRhJHmEq+Ggq7la/Hyu4GwZR5ZTY3wSelmI0WZeTYcKjwTlkyI0v6i3sjDovYTCYeSelRUEQ5Esq6gG+t7xVjQDrEQetcZFkp2lH8T15OgjwsXyl0gNN7EkhkHYocLNCtrTniSdGvcV/st78IyN3g9nJ6Ax2LbczU3luE2uVM+B/69I1WXyydJ9zX/2lwVS/MO/NuW4ZZwePC0mxveZfwVms42GbprbKvwh/EHt0lTcbHB/RZaTvY9qD3/6s4DN/JRf1GFtexEBvnA==
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
members from documented structs such as sync_inode_metadata(),
remove_bdev(), shutdown(), report_error(), and fiemap().

Clarify inode allocation and destruction semantics, RCU requirements,
inode eviction behavior, filesystem freezing, and block device
removal handling.

Also fix outdated terminology, callback descriptions, and
documentation references.

Signed-off-by: Mohamed Ali Bouhaouala <mohamedalibouhaouala@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 Documentation/filesystems/vfs.rst | 181 +++++++++++++++++++++---------
 1 file changed, 130 insertions(+), 51 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a4371..b44fefa2d826 100644
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
@@ -156,14 +158,15 @@ members are defined:
 	for internal VFS use: you should initialize this to THIS_MODULE
 	in most cases.
 
-``next``
-	for internal VFS use: you should initialize this to NULL
+``list``
+	for internal VFS use: this should be zero-initialized,
+	with ``next`` and ``pprev`` set to NULL.
 
 ``fs_supers``
 	for internal VFS use: hlist of filesystem instances (superblocks)
 
   s_lock_key, s_umount_key, s_vfs_rename_key, s_writers_key,
-  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key: lockdep-specific
+  i_lock_key, i_mutex_key, invalidate_lock_key, i_mutex_dir_key, d_lookup_key: lockdep-specific
 
 The Superblock Object
 =====================
@@ -186,15 +189,16 @@ filesystem.  The following members are defined:
 
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
@@ -206,12 +210,15 @@ filesystem.  The following members are defined:
 
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
@@ -219,23 +226,46 @@ noted.  This means that most methods can block safely.  All methods are
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
@@ -251,18 +281,30 @@ or bottom half).
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
@@ -281,11 +323,13 @@ or bottom half).
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
@@ -332,6 +376,7 @@ or bottom half).
 
 ``get_dquots``
 	called by quota to get 'struct dquot' array for a particular inode.
+	Managed under RCU rules. More info in Documentation/RCU/whatisRCU.rst.
 	Optional.
 
 ``nr_cached_objects``
@@ -339,16 +384,17 @@ or bottom half).
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
@@ -357,8 +403,32 @@ or bottom half).
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
 
 
@@ -410,7 +480,7 @@ struct inode_operations
 -----------------------
 
 This describes how the VFS can manipulate an inode in your filesystem.
-As of kernel 2.6.22, the following members are defined:
+The following members are defined:
 
 .. code-block:: c
 
@@ -433,8 +503,9 @@ As of kernel 2.6.22, the following members are defined:
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
@@ -460,16 +531,18 @@ otherwise noted.
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
@@ -487,28 +560,29 @@ otherwise noted.
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
@@ -587,6 +661,11 @@ otherwise noted.
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


