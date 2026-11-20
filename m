Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F0D3606A888
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=o0JCPABw
Received: by kanga.kvack.org (Postfix)
	id B9D0E6B05B6; Fri, 20 Nov 2026 13:23:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73CF6B05BB; Fri, 20 Nov 2026 13:23:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A889E6B05C1; Fri, 20 Nov 2026 13:23:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C86B6B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:23:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F057B4015F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:23:06 +0000 (UTC)
X-FDA: 85456319172.21.9FA1E75
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 173DDC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:23:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o0JCPABw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795198985;
	b=5I8Ug/8AmNJY12/gKcQpsiJFkZm3su+muRTeyrnHhNBqE/fEK4aBZwyzbLIoJsR/Om3BME
	c73SYu3YV1iIRvswkfZdnZYTV5W2IRtz8Xwa0Bz+k4JCzAXg+tlinH3UztaQKS9RRRc8a/
	yoYaW41t75x2mTwokpSlf1fasc/tGS0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UDyo3xyyUOxSVEsUrWJHRlmDLfHtKTeayv/6ZJdHI2s=;
	b=7iSLq3gHM/PtreBu5fhS45uHffB577GbX8wM9kp/IPUf0JOlO415PeHt/vnsEn9eVicwql
	ZMyML4ViHtV/DsnEN/WM+daM4NcO16qSbBHMZBgLbC3dV+hUEfKqP9+TGhuImoCAEIFGAv
	iv2vc+dEEpsF3k/DgyAi4kIsYvR+wmU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=o0JCPABw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of mohamedalibouhaouala@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mohamedalibouhaouala@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e3b22e971so679099f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795198983; x=1795803783; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UDyo3xyyUOxSVEsUrWJHRlmDLfHtKTeayv/6ZJdHI2s=;
        b=o0JCPABwimF/ku0Yx9bWjGFnU+hqM3lptgdn30aSX0AONytiI03qjDOFp+yaactT72
         GnAjyLdtTLICU7MOEi8qjM2xgLuFCqMAw13lKeYsPUuN/c0SzpUIAcI9YQ6VPx0MXOww
         NiTe97a6HYeJKNL+HmYmG9mRLyib9efA7sD+FoJ0lk7tQ+Xdw5EPFCskuJ11DFopTjdh
         B990ITG7bFHhQ89dDQ/DIhGt/1aqVaENj+3tQDr7tZu4+64RAHqXNTNhlsq8sli5p0gb
         RoVWoii/GXG0CU3HDD1BKgEEamwGjrZcBycLCtQWuyODbPWTJtMbhC0L4F76dqzrA07m
         HnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795198983; x=1795803783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UDyo3xyyUOxSVEsUrWJHRlmDLfHtKTeayv/6ZJdHI2s=;
        b=Z5GowhX2u6F1Ae8eSrfhnMyjxVAPdOk7jzXH8qDyvYvq/0EZAH4FDQd5JMlW0PaTtR
         z0wNb06e961NqNYxBi0JuWeF4p2jB/LVGfgwLUgMHyDLYfRMXeLhPstDUuEvYZk0CQ++
         gR83qUWfN9kTH34AIlrtQey087EBwqUzdN7K2UydC9t43nU592pbKOOnAoymRc2fUtV/
         ZNM3G/NcMhs4gu68veLcdzkC1I++EqsJiIyZIHNHbSigeeN16jNwBSVb7F600HTfiBcu
         0z4z7NrfnJnBF5ep9N4ivG58y3CHd1CyGYat5UaezSOee7XeOxnl/29kDzYUS0YYnyW7
         YSKw==
X-Forwarded-Encrypted: i=1; AL+hErHGUEdyfR2nf5zoyv5RjxiheFWY0/fzLrBHQ9nGFbFpPXJh8x7qjsEg/Xzq4Lvu9QRBU0pySExmtA==@kvack.org
X-Gm-Message-State: APuU4Z+E4Vtc5kyLZl619a17wWgFEGubkIMfDM5TxXVYLx21I6j714j1
	/fDLmMXfHC0//0QGvEHhc1Ylp0hzBcpZv3IZyOGtBKmycOTSu230xFwy
X-Gm-Gg: AZFdTZdO8iyGhttibhB+Srxj/XwDrgLo+/U1/F9C2IILmxCxoJUrLHu3i7oUyHU/4VV
	DgUI4rnGw6W+zXmyE4OR4gjXITjjP8IQfgN+hjgqIi8YCRAqU3gVV/OXJRbIBDuUgilWDkFekh9
	tg92i4fNvwr0SXTGOhPIkpF08hKWLMAqL9EqDlAPP1ez6GKTZ9XxM1gKBLcZ1kS/9I5NlYICnfb
	K5TxGbhSrZ4ixlZKjq2O4HK6qRi32uhrr9hc8AOwy7X4DmiqW06izl6zWjtEhTnx7dgogmyGnqJ
	4Rb3GlWaLrBHhV/rTfKts7ta6GcVsLzJSAZmTpg0M7JSVPwXQ7ioxtLDjIep8sBpQL29ONhh9ic
	p62igrmuMnm4DzIoxInqV4a4TWb6A//mHnXUYt+xKuIghruok66H8OguzG3MafkgUGaToFOwKJ8
	uJtXb2p6pqgLDuEw11LcjltLHwywDtN5w5JRSjvwQ13v8Mj6sVP6XpreJnjIr7RxVL1ftM7i7zb
	juzsiWQYD3yns3JDxNTScBq4wr6ZsQ9wtlpTplEn002VzWRGgStYxGmHvyfk7GM9QMGk/Syec3C
	YtvzTSgJnvJ3B69NqxQDgTOoOor7g/1VWf4LmNCCay2HzHsROKVopaEM
X-Received: by 2002:a05:6000:188a:b0:4a9:dcdb:2e23 with SMTP id ffacd0b85a97d-4abb4f59b64mr7910721f8f.56.1795198983193;
        Fri, 20 Nov 2026 10:23:03 -0800 (PST)
Received: from localhost.localdomain ([102.105.35.154])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6b10b5f6sm6469495f8f.34.2026.11.20.10.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 10:23:02 -0800 (PST)
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
Subject: [PATCH] docs: filesystems: update filesystem type, superblock and inode documentation
Date: Fri, 20 Nov 2026 19:22:06 +0100
Message-ID: <20261120182207.97249-1-mohamedalibouhaouala@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 173DDC000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bxjkojzgj3muiiw5pobee619s4x4rzsx
X-HE-Tag: 1795198984-704877
X-HE-Meta: U2FsdGVkX1+NpzcDRYSg++jTJBWBpnOtfDx99er43nyX04DG72LPcOJf+Xqzt8HF5fvK0Vn1XG7wO1I3f6ODFQ0VO7WdH1N5XPUDYUXXZ8y9I2o+w+3ADeF1otdz71LaOCjkpsm4sTaUR+jUK2SM858shX02xmPDRzv4EmA5qsJMlTE0xdVT38pyyhtc+n8EGMLdTY8OgBT4sKS0CvATS1/blq9WY++wV+GuqdbXAONfjbAfniQVfSGG+mOj0DnOqb8wyDMHBteCidHJRnSqXlbxz6P3H1JhDDQAE5dFWBqTstsscwq8vVqU/5I15b5eXQt8RzAYdIAZLXou8lbq4SE7dmxvJ0dolO1Oe7AvNzjbAKnNID7sqCSBBGyWAU8wa3+1TzKIqFR66glJkJzDiVcVogG8Xuf8KaIG6M0JMeBeWD9NoC3/gMbfb4l8fR1M6M2NmMOXgC4kaiPC0D1v1DxBho5JgkFYdO0+xtwREq54XFVG2bgGE41nBG47CY6BB1sr6/TFu1K4/3l4vWC4r77M64XacC7IsIoGgkKmCcGQLzxdiwpF/eUjt/TxEyuJtSHnLNStq/cKmNP+rjUIexdGIxvyla23Ghb4dviHdKUY7bjgZH6u7aYNTTcGnponuT4OLsvjccCX7RAsoN+Gqi51PjOZ674YXCA5/iDYhb0g/fvTanOXPdTBUL/JtrPqhZpPM/Et+XT0AqdrLFlYQLiHKgXxW4fko6iKI6zzceWn4BH8KXvpDSc5Lx4MkuOLnO9WRITRgN4r/eEibR4Oehxg0Y0NAUs2SwYVKFB/cMHdAIV8bR8OoGdpvSxsOa8PbyquzZvpkgEsqOM4C6KDTjeVCDcqkhQBrACY4Tl8Tqj3FdieMTuJ/1uECaqqbWFeb2ggp1R5nvwWWRZFY4jEv5xH8GncbHtJhqNpCMSom8Gsbg/ICkWjXkcD+bdGCmi8e2k3kNuUgBkiOZjK0dw
 04ViVVnl
 GDA1DBX/BZ4Rqq71dUnkzB1wXy17PzWCQwWFIV829pImQLKjsIhnUc7ZcgSUBSjr8AaLNx0yVFfzxL3k4Aawgfz2HeM28lDLaZBqzrB3zjGef9hib17zN1RZHiSj0aP+mgeqkf6DUvEa0TOK8bfwgH9WAkaEg3+w9VECpxGLMB70PipI+/KyJbyxhIMVe7sQHDP7yXGcfXeakDkQ8Zj59tvRQ275gbZcfVstN/DK3K8tfFfEoUn8GvuZTuGoogRykihx/Wf6eU2yHuRGlLRHiWbe2GOawqSEQI/GJijNGICzfRO4TpR/ZoqvAuaPVzBpre8+JwqgL6Kw29ow5z9BpkDhzCDWOhGOyWiHwGv/fIrnrexsFgktkxscldh7DT0oLKo9Lbgk+z/iaS20/y/4wCsK0LSol+afa3245fnnEk6OkZ2nzDEDJCr3HEHQdw+myo7bIMR2iHK0Yw4qqeHMLkdrIhinU/sZ20L0LL6mrjA6IVfQqjym01LFgMFwXmALZADYIv3ZA/GEbkpaq5M0FhnxXoHN4j7RvBlhxwQkB8SMqqVqPYqnryiy3s5M31aF2EjtTv5ViLfYB1kzs2BDkqPGl+aQnh7NQdoKAVHzfQSKs0QWJH3AIfWcyFUDYqAeIQYohnpOfPwG6VWes6bq3u4ZfWFZzOoVyaUl3sJba4uBhhDBi3qVsTKO5YA==
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
---
 Documentation/filesystems/vfs.rst | 178 +++++++++++++++++++++---------
 1 file changed, 128 insertions(+), 50 deletions(-)

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index 1824462a4371..54ce835757b1 100644
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
+	called by the VFS to report the physical or logical extent
+	layout of a file via the FIEMAP ioctl.
+	More info in Documentation/filesystems/fiemap.rst.
+
 ``update_time``
 	called by the VFS to update a specific time or the i_version of
 	an inode.  If this is not defined the VFS will update the inode
-- 
2.43.0


