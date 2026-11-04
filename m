Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56627606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vgNYTUhN
Received: by kanga.kvack.org (Postfix)
	id 627C26B05B4; Wed,  4 Nov 2026 06:06:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D99A6B05B5; Wed,  4 Nov 2026 06:06:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9356B05B6; Wed,  4 Nov 2026 06:06:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4896B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:06:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACB928067B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:25 +0000 (UTC)
X-FDA: 85397157930.01.DDE823A
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id C5F5D40003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:06:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vgNYTUhN;
	spf=pass (imf12.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bX+HuofyV7edkMCVGlmcJHHKOGvBqTskGwpRW1QG8GA=;
	b=HWovphpNo0/0m983yq+aQ7Odea+JebmuMiRKxCMXtsPLM2cKlfHWhvAnZIcY8hR9P5iCDb
	APl9JFvLNjmK40Y8EU13wJITZvUD7OgjmCUtWfRkW3mgCTs1OM0sQHhbDmg2FYPuxPXWAE
	/1XqqFspjFBbfbcYhikmEdM/QmQESq0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790383;
	b=oZWm6XZoYn4hO+qsftFvAKL1ZFQfhzCwJjIqe0GEGv2AInTfYApGCvIZVW5S52nl8p+HXJ
	BZBMP2LrQSuh7Uazmnn+5pc4pzgMd52tJyjNBCXPahzIhgK+H8emjKnbwLk6perdLV4Z6I
	V01aUR94Rj7sURpFYCbRoOMWhHLMBnc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vgNYTUhN;
	spf=pass (imf12.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so4777995e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 03:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793790382; x=1794395182; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bX+HuofyV7edkMCVGlmcJHHKOGvBqTskGwpRW1QG8GA=;
        b=vgNYTUhN3gxIqQVzk6FVy4+t8wU/+d6fPscAMy+0/rbFaGTh9jzCTCkpN7/hbsVG8j
         1LNqdNizMNr2Q5iphS73rnPSNFuqIO+vghboNMpKxmNm/Rd3YtZZaUK2gm1lXnSwKzUS
         NwvSb31Z6UCKTon6jFPlZWZKn45Ukb15RvJwfkaFu1qREPwbl5cBsA8PuO2gmsS3Yzhc
         b796389pRCTmpbWx3tMPshiQiJohkhyQrbLC49/6INpUFDb+xxWw0C5JgSlSGPmmJMk3
         x/QMWki9hB9JfXGgiOKeeUz3H4yHfWr73OTtdwg1PWm/Y/+Uu7HzPCko6XerFJWgffme
         fBww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793790382; x=1794395182;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bX+HuofyV7edkMCVGlmcJHHKOGvBqTskGwpRW1QG8GA=;
        b=sa7HG/ZoMoKBv8MDW2XwcJ9jr9XrfFs71vD65Za4O3xSDxBWelYu3efPfx0AuXaZZh
         prDlOP2GwzNHyGcXep+gbsrJwSRCMNYLfX1VuTGdl5sr11U+944VfSXW9ORlEefr+r04
         L+k5PARshoHKfnz5y2CufTICqYgTuxr7ZOpkt1rQcw1QTD0p6sGkwLXgPsX2LcKZRGom
         vLoR10zdUbu7JlQtZWtnxkqOy4o1OKvPAy9qBnacNO3XLk+AL+yDzHNxo3xvdeMvl0kk
         JfUzGUKzk5IMJBYAFKq6BAeGAHCewYoaNJZrZXgkhQOZe5Rw3QhgY3wxxlHn1NRevnWq
         Dzjw==
X-Forwarded-Encrypted: i=1; AKwUvBxdSGaz+eISxAuIdiNq10v60zLPDL2uboRGKA0PKGAjS82oDqr7vshtTUM7y7FQGcVfmvh3qsNYNQ==@kvack.org
X-Gm-Message-State: APuU4Z+04IMlOl13ljvM3hwYRAyWbv438Fcl49LiYmEHm90MPUmzy1MK
	mKWsjWtepSgldlopfTUr975bXfAdrVJy8udGHbK4e+IlriuE+WkEvcx1
X-Gm-Gg: AYBFou3gkQjNG9y/W5hv9nz255e5heI16/p3HsWfElyB0hPZGq6rsNhH3lH6OQS2+ik
	x94SKGFI4+MNZXPofk1MFoPR48hyPADH3pA4ZGVBVy9fz9xXfTGhwub0hv5AMiszFT+i0qBKVQl
	QsZgDqG9RPo47SVf0mBrridwTDiUd3+lTjOFuJ7ltysK1+s2LyTsH3rRvbjg3Lz5vOO/BAQMSmV
	JiMibTJSmsTxVQ/fjHcpwFPTekoA7xMhy0iw+bnFi82dhWM/jEDx7OjOtPJfTDYdt7zGUtzFpBr
	SZ2v/6W/ogQDulnJq+kTL0caji/aHYIDBSiTlL03wf46SlJ5eCVcjJZS8IxkNpqCeUR0n7fK8IB
	JaYuyDVUFQeXBTu43j90/7jI5u/56iw8zVS9KzpwOcw6A7RltTPXR3KLh5IMpO2maPdyleI4ujq
	0VReVkcKhS7Xdvv5Q/N8R1dEDRJ8n66ODy1vAwPnHKwrY6zNDqnKtvnaWVll1j91tDkd/myNcjr
	sFPLGa7WPrvTVdKJ+zt5l0TS16rHCCidbJ7L2hFdFDIUkcmmZUx5kiwJqQvWASphbEdlacWpMQi
	AMQDAPXb7yl59WsWiF49cRcWaTliTRBsXk9VWRZ1vPbxVkw2jwZb1tsTb/LpHcr2IVDmVKQkgP8
	/vM8PuScqe0VFdCO8MvvzZqnp
X-Received: by 2002:a05:600c:1385:b0:4a3:5991:718 with SMTP id 5b1f17b1804b1-4ac182dc0a1mr386721525e9.16.1793790382506;
        Wed, 04 Nov 2026 03:06:22 -0800 (PST)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed92a753sm3704835f8f.45.2026.11.04.03.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 03:06:22 -0800 (PST)
From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven29@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
Subject: [RFC PATCH v2 3/3] io_uring: set times inline when the filesystem cannot sleep
Date: Wed,  4 Nov 2026 12:06:04 +0100
Message-ID: <20261104110604.126717-4-meven29@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104110604.126717-1-meven29@gmail.com>
References: <20261104110604.126717-1-meven29@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: h96u5zgy4g3qyn17qn9531ipzhbsecws
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C5F5D40003
X-Rspam-User: 
X-HE-Tag: 1793790383-237256
X-HE-Meta: U2FsdGVkX1/C8W7/JZ4LNInd0OWTcNk4pggTq+J7tYV9CC0nghw6f/ceUH5gLrU/Z80ZvXp/JJhQvgGBfymLGyzyghVxj0129uKEv883cjJByaU4etgBjt3lCwbWOvk6l6AWcjOm3OOHTo2hGljbDytqdR6URUPxzqglJgDl1KbZd4TgJWPMakWHdE15IcTVRFbKESeCTDvaijPo6QNnbKCVcZHmQji7oVQW0sBL6xSCBo3VDDOIMi4fYo2F+ozH4wFc7qGc48XjYdxLlAmqnK27MvlRMdLD3ZelxfWEkRaUfjauOX5qfzD5CxmAVPlbyfB3Tn0ll9ltlzktGai6WDcC7Rw4o2DRrnkCiHz4l12Z47VqTeJraVTu4xoq2RLUUqOilJ/40ITGmPA4sGZZu4yBvnoJ6XTXb1dhxolKF1dRncgfsRs+NX7hC6StM/iJQV7ZkAgEZUkMLJ5jb3A9t9U1Vewr3RtDXY2X1fT0QQ1q9+n1Fgj7q9sPWCTDBBEg8KB+ru24zPqhpRAmAMD2sCnbTl7qt5YfYRamxpr71l0tytAMHX4UdAlG/1WIMoM8Hg8jnXksh1j5wVJHAnVS67J6Uqdi4I7m6TKp9o8PBN4raCtjzdDKSzQpFCYhFBFdYWBwLgGZ3/rNdtHlWcPbv/UMxOYnng7nym9sbpeJmmvE8IG/75jQW1407apbGvYHEInxRT5fXch1ext16m/K3x2LtqiFDYmyW1bWTW89p8ZiwPc66mzm213f8G4znaTlIN1FJoJ2MHx9sRoZaTT5lCr8ElZX5z4jkHONyD3p50RUej/fS+1jliHfrHpokpkwHvmOl36jK63f8TdpKo563jWCNdqHzLbEVufY5g9oN46316urWwM0LyCJBCyR2zUmftlTmwCELXIa7Qkmep6SXLqiIYRk7b4IFPS9FX2oKVOkQ3J9/aTV137aj03PHT4lVWG4hMouqUePbFa9VmB
 flLTYgoU
 fUZIYOOHNzOVdj/MfVyjwmT1L58JP+HawTF71mueblXpN9CXBBcKvXAqpfFoxMpUMsBXoMO4NNogXIDHkvTPqU2gQMPLF2LF6m3IzUQgJjEBCzw096at7DEBml654s6/GocxSv1GLCom6GFf65XxwE659dEgDetWqJXMqYnk+JDNcIBe1oWOU2l/IGDJi3P0hPJX6Oj8y22zRH6/NbUhoyWiUjQ1oS58Nt6C0rZ4jnTCiBzif8OYaWf538orLo4D0g3S8xNHuLdttHwzQobi3NzQUons536cY9K/b39NZeRBnW1M6A2L8fYa/ssGTFQkYyD6qI0bJKqz42L8bN6xhEwtJwldJAKoC9zqqwCu5ddU+XIgACM6lZsbIpKOMdWx514t4AE0nS1LzAs9l159wn07dmysDvU9rbAZ7GkNbty7/euy71QkP0uyzcksPw/JBYxxsRc3jXqVFR4KuPjQL9w+mG8SKhKFilXdsUgT2vvzras6HXRJywheO0D9DM/UcPMAeI6yYIq3h737SlYgnr8fiyEoDqLem6ADLxlDRGsRkVTkAdV9sSNXD3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Méven Car <meven@kde.org>

IORING_OP_UTIMENSAT always went to io-wq. On tmpfs the setattr only
changes the inode in memory, so the handoff to a worker cost more than
the work: 2000 files took 7 ms with utimensat(2) and 20 ms through the
ring.

Try the request inline first. The lookup uses LOOKUP_CACHED, and the
freeze protection and the inode lock are only tried, the former with
the new mnt_want_write_trylock(). A filesystem whose ->setattr() never
sleeps for a change of times alone says so with
FS_SETATTR_TIMES_NOWAIT, which tmpfs sets. Any other filesystem, an
uncached path, a contended lock or a delegation returns -EAGAIN, and
io_uring sends the request to io-wq as before.

Signed-off-by: Méven Car <meven@kde.org>
---
 fs/internal.h      |  5 ++++-
 fs/namespace.c     | 20 ++++++++++++++++++++
 fs/utimes.c        | 45 +++++++++++++++++++++++++++++++++++----------
 include/linux/fs.h |  1 +
 io_uring/fs.c      | 22 ++++++++++++++--------
 mm/shmem.c         |  3 ++-
 6 files changed, 76 insertions(+), 20 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 985b2bc5895e..2370faec54f5 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -64,7 +64,9 @@ int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
 int filename_utimensat(int dfd, struct filename *name,
-		       struct timespec64 *times, int flags);
+		       struct timespec64 *times, int flags, bool nowait);
+int __vfs_utimes(const struct path *path, struct timespec64 *times,
+		 bool nowait);
 int vfs_tmpfile(struct mnt_idmap *idmap,
 		const struct path *parentpath,
 		struct file *file, umode_t mode);
@@ -86,6 +88,7 @@ extern int sb_prepare_remount_readonly(struct super_block *);
 extern void __init mnt_init(void);
 
 int mnt_get_write_access_file(struct file *file);
+int mnt_want_write_trylock(struct vfsmount *m);
 void mnt_put_write_access_file(struct file *file);
 
 extern void dissolve_on_fput(struct vfsmount *);
diff --git a/fs/namespace.c b/fs/namespace.c
index ae5dc64f8b45..f4aadd4e1958 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -499,6 +499,26 @@ int mnt_want_write(struct vfsmount *m)
 }
 EXPORT_SYMBOL_GPL(mnt_want_write);
 
+/**
+ * mnt_want_write_trylock - get write access to a mount without waiting
+ * @m: the mount on which to take a write
+ *
+ * Like mnt_want_write(), but returns -EAGAIN instead of waiting when the
+ * filesystem is frozen.  When the write operation is finished,
+ * mnt_drop_write() must be called.
+ */
+int mnt_want_write_trylock(struct vfsmount *m)
+{
+	int ret;
+
+	if (!sb_start_write_trylock(m->mnt_sb))
+		return -EAGAIN;
+	ret = mnt_get_write_access(m);
+	if (ret)
+		sb_end_write(m->mnt_sb);
+	return ret;
+}
+
 /**
  * mnt_get_write_access_file - get write access to a file's mount
  * @file: the file who's mount on which to take a write
diff --git a/fs/utimes.c b/fs/utimes.c
index 8072f05ac8dc..a0d67b8e96a1 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -18,7 +18,9 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-int vfs_utimes(const struct path *path, struct timespec64 *times)
+/* With @nowait, returns -EAGAIN instead of sleeping */
+int __vfs_utimes(const struct path *path, struct timespec64 *times,
+		 bool nowait)
 {
 	int error;
 	struct iattr newattrs;
@@ -34,9 +36,17 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 			times = NULL;
 	}
 
-	error = mnt_want_write(path->mnt);
-	if (error)
-		goto out;
+	if (nowait) {
+		if (!(inode->i_sb->s_type->fs_flags & FS_SETATTR_TIMES_NOWAIT))
+			return -EAGAIN;
+		error = mnt_want_write_trylock(path->mnt);
+		if (error)
+			goto out;
+	} else {
+		error = mnt_want_write(path->mnt);
+		if (error)
+			goto out;
+	}
 
 	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
 	if (times) {
@@ -63,24 +73,35 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
 		newattrs.ia_valid |= ATTR_TOUCH;
 	}
 retry_deleg:
-	inode_lock(inode);
+	if (!nowait) {
+		inode_lock(inode);
+	} else if (!inode_trylock(inode)) {
+		error = -EAGAIN;
+		goto drop;
+	}
+	/* Without a delegated_inode, a delegation gives -EWOULDBLOCK */
 	error = notify_change(mnt_idmap(path->mnt), path->dentry, &newattrs,
-			      &delegated_inode);
+			      nowait ? NULL : &delegated_inode);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
 		error = break_deleg_wait(&delegated_inode);
 		if (!error)
 			goto retry_deleg;
 	}
-
+drop:
 	mnt_drop_write(path->mnt);
 out:
 	return error;
 }
+
+int vfs_utimes(const struct path *path, struct timespec64 *times)
+{
+	return __vfs_utimes(path, times, false);
+}
 EXPORT_SYMBOL_GPL(vfs_utimes);
 
 int filename_utimensat(int dfd, struct filename *name,
-		       struct timespec64 *times, int flags)
+		       struct timespec64 *times, int flags, bool nowait)
 {
 	struct path path;
 	int lookup_flags = 0, error;
@@ -90,13 +111,17 @@ int filename_utimensat(int dfd, struct filename *name,
 
 	if (!(flags & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (nowait)
+		lookup_flags |= LOOKUP_CACHED;
 
 retry:
 	error = filename_lookup(dfd, name, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = vfs_utimes(&path, times);
+	error = __vfs_utimes(&path, times, nowait);
 	path_put(&path);
+	if (nowait && error == -ESTALE)
+		return -EAGAIN;
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
 		goto retry;
@@ -108,7 +133,7 @@ static int do_utimes_path(int dfd, const char __user *filename,
 		struct timespec64 *times, int flags)
 {
 	CLASS(filename_uflags, name)(filename, flags);
-	return filename_utimensat(dfd, name, times, flags);
+	return filename_utimensat(dfd, name, times, flags, false);
 }
 
 static int do_utimes_fd(int fd, struct timespec64 *times, int flags)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..d1800fba15d8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2296,6 +2296,7 @@ struct file_system_type {
 #define FS_POWER_FREEZE		256	/* Always freeze on suspend/hibernate */
 #define FS_USERNS_MOUNT_RESTRICTED 512	/* Restrict mount in userns if not already visible */
 #define FS_USERNS_DELEGATABLE	1024	/* Can be mounted inside userns from outside */
+#define FS_SETATTR_TIMES_NOWAIT	2048	/* ->setattr() of times alone never sleeps */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	int (*init_fs_context)(struct fs_context *);
 	const struct fs_parameter_spec *parameters;
diff --git a/io_uring/fs.c b/io_uring/fs.c
index 71164bddd958..664ea918ae3b 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -358,34 +358,40 @@ int io_utimensat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (ut->flags)
 			return -EINVAL;
 		ut->flags |= IO_UTIMENSAT_NO_PATH;
-		goto out;
+		return 0;
 	}
 	err = delayed_getname_uflags(&ut->filename, fname, ut->flags);
 	if (unlikely(err))
 		return err;
 	req->flags |= REQ_F_NEED_CLEANUP;
-out:
-	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
 
 int io_utimensat(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_utimensat *ut = io_kiocb_to_cmd(req, struct io_utimensat);
+	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	int ret = 0;
 
-	WARN_ON_ONCE((issue_flags & IO_URING_F_NONBLOCK) &&
-		     !(ut->flags & IO_UTIMENSAT_NOOP));
-
 	if (ut->flags & IO_UTIMENSAT_NO_PATH) {
 		CLASS(fd, f)(ut->dfd);
 
 		ret = -EBADF;
 		if (!fd_empty(f))
-			ret = vfs_utimes(&fd_file(f)->f_path, ut->times);
+			ret = __vfs_utimes(&fd_file(f)->f_path, ut->times,
+					   force_nonblock);
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
 	} else if (!(ut->flags & IO_UTIMENSAT_NOOP)) {
 		CLASS(filename_complete_delayed, name)(&ut->filename);
-		ret = filename_utimensat(ut->dfd, name, ut->times, ut->flags);
+		ret = filename_utimensat(ut->dfd, name, ut->times, ut->flags,
+					 force_nonblock);
+		if (ret == -EAGAIN && force_nonblock) {
+			ret = putname_to_delayed(&ut->filename,
+						 no_free_ptr(name));
+			if (likely(!ret))
+				return -EAGAIN;
+		}
 	}
 
 	req->flags &= ~REQ_F_NEED_CLEANUP;
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..405b39fc5d0e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5310,7 +5310,8 @@ static struct file_system_type shmem_fs_type = {
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_anon_super,
-	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME,
+	.fs_flags	= FS_USERNS_MOUNT | FS_ALLOW_IDMAP | FS_MGTIME |
+			  FS_SETATTR_TIMES_NOWAIT,
 };
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_TMPFS)
-- 
2.56.0


