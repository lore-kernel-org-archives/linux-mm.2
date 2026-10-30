Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26F5C606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=T3ljNVxt
Received: by kanga.kvack.org (Postfix)
	id 4C6796B05B7; Fri, 30 Oct 2026 08:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4007D6B05B8; Fri, 30 Oct 2026 08:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299C46B05B9; Fri, 30 Oct 2026 08:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09F286B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:40:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3C6616067E
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:59 +0000 (UTC)
X-FDA: 85379249718.03.9A60EF8
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1EDCB80012
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:39:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T3ljNVxt;
	spf=pass (imf30.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793363998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ed13n90ye5Czp3pxuz2kTfn9JK5IM878W6MtBdLVE2U=;
	b=L+Y8YUnt+iCovPmtrbzsi173AhHvR97bS/Bwg7PEHX+1vTsJv47kYFFwGhpe0vgXiVaJPZ
	i5Njgvi73y4zgzy1MUv+rSlKgW6250cj1RPrBNnB6uzXuc84ik0qjyHDrpy8UjHRP3zJhQ
	5tOO4tjbqMCPLO0nePUN3YsydMr3B1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793363998;
	b=15FcvXlnJo4kqQbegXiE8eO1GkmIXLLrVGwmXHcjICjnHhlyp44+cGz6HdkZiDRQRjSZbY
	aGsVeM/YV1A9ZBGSTMkxlneFA7pdfHZKowWIoB0/0iCR2btuebnrSOnGzU5woknuBCUBWn
	ez+n0eTyAEC+DxL7ZxsuIIW4oM+KlKw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=T3ljNVxt;
	spf=pass (imf30.hostedemail.com: domain of meven29@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=meven29@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5036bbac7so3713305e9.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793363997; x=1793968797; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ed13n90ye5Czp3pxuz2kTfn9JK5IM878W6MtBdLVE2U=;
        b=T3ljNVxtrTlyj/0WrQOWwQPuNkrcWGCsWY2j/nd/Mjn9UWRNbvnzzMJ2rpoODl/O7u
         csROVxTUgVoIiAH+Fll/qqwobC7cffGbPFGHhd2vCA5+0Oou9Lwu8UJcccMkQW7ZbnSl
         mx67DiEUHiMT+x3MeV29dLc8JZX9gHU0ee+kqbv+T3rpTJcVbeRStc8RoaoQ4JbQrfmk
         nDRz6fL3Z9wBYu/xlYR8ee6XIE4TODMKRvXhkrUKeK8nTiQyU74enDiKXREEpTdiCgIy
         +YdTrPifzZ2w5vcnNg+Vj0/+cwx2bYjMHSaq9u10CdnEStxtBmS2h4n8Gm7yuX27IF0u
         xssA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793363997; x=1793968797;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ed13n90ye5Czp3pxuz2kTfn9JK5IM878W6MtBdLVE2U=;
        b=ZLkKI8cZfqe/qhkHMtpYbRBpWmxfEeu/9aF6W9vCbQVQp+HxhcHMUSc3ykhFrFArG+
         hSDQQAi6YQe0NhXW/ZfXRA1Ds0lUg0GumbNDK9vcpGxemFKuRPGVYWInzejAeiLRP95v
         Dt0BVwG/9iH1+Fc+cK1OPlFsF687OC3C7Rjtpu8zgst+GTw8Ku+7BkpLhsWfqk0+rK+O
         9qqmeOeX+Sh2f8IaKT67Q/40RHbOlcRsMQWhUF7UbvWutC+2frZfRQNWFeLwSfCVpj21
         TgnBEnfHlv2Jc0mIoeXGdCWRix0vN5SaoHmyfhwy4FiGwfN7LDE+KwiVLTgJjPjVEz05
         VKAg==
X-Forwarded-Encrypted: i=1; AKwUvBxxjqi8EUCdoAvXll6tTP1uKihBHpohGTeLaHNdLxD6EslNKaHrS4pmcBztcJYJsAu4gb+e0v8Lzw==@kvack.org
X-Gm-Message-State: AFq9FYL2zs09HbOgCjGm3mXTIkh62DdQLVHCZVhv8rmqmqpTgSogVMOB
	aidJ+lYRRQex4920T1BBK4r+j7xVXwKSGrgamTnNnSkXPsAVbTTXXk32
X-Gm-Gg: AYBFou0jXLuoXqKmDRGeLlMA4JcZ9uo+td11ZlbFzFaSSu3vR8pIfHg8I2WsuWXptAe
	1DfSFBHL5heHpp95uwqS2+T5/qtxHvImK11gFz91r2cMdag3tg4Ms4Q+PRgIqmQI6u/KoRZB+VL
	YeWAVmvBSO9YCU5xlZbbkWUEv3eXENkYttRQdyzjj+XLjDf/TvVRpBF3WiSu7EObbOr6gaseZlq
	Tpw0/3T2438BA5CcC8FENMJIalkWHqRDD5i/eaixqRQDm60fCCNsps8JO0lGklYX08H2hZNxoTY
	bELWxHgLcA3rTnSbBy8vNBari/Ej2sJmUNWrBxV5ak1IRCX8vHOEou+ZhZeTA2ulyhBNWRriKeC
	fes3X0pGsmcpEg0U+NORw9s873UURExaqxkKkLE9TYh8r0PWa+ZaHNoG+Vj7ZIr0Bdsqzup174/
	Z8v3+7c5Oz/9mgbQ1DAr3fmeYooLKnZLzn7Wp0mIrpV3qbyGXxuarRc+oL9xg9jIrqwkFcQO3HV
	aGeDdmtTbQkIUWH5RuJWGB0TC4N/J6JMpfNH9sdWfQ3mGer+SHCFgljjCmM0VuaqEF6u10Ba06q
	Iqu2Ygkp0kbHP+31E/OVtMPiV/3yW8yFxh2oV60KEvAuWdtZBwbEMRsGTxum6Pwz9vwcktuampd
	BCgzn50CZdVMUEPIofu0=
X-Received: by 2002:adf:e307:0:b0:48d:bafc:a409 with SMTP id ffacd0b85a97d-48e6e4fde69mr4213621f8f.26.1793363996784;
        Fri, 30 Oct 2026 05:39:56 -0700 (PDT)
Received: from meven-thinkpad.home (2a01cb088745e00090de407b41070a01.ipv6.abo.wanadoo.fr. [2a01:cb08:8745:e000:90de:407b:4107:a01])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a4csm3088971f8f.23.2026.10.30.05.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:39:56 -0700 (PDT)
From: "=?UTF-8?q?M=C3=A9ven=20Car?=" <meven29@gmail.com>
X-Google-Original-From: =?UTF-8?q?M=C3=A9ven=20Car?= <meven@kde.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	io-uring@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 3/3] io_uring: set times inline when the filesystem cannot sleep
Date: Fri, 30 Oct 2026 13:39:45 +0100
Message-ID: <20261030123945.1704118-4-meven@kde.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261030123945.1704118-1-meven@kde.org>
References: <20261030123945.1704118-1-meven@kde.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1EDCB80012
X-Stat-Signature: zafmom476xae3w5ptp6cyenjak1wt5xx
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793363997-623326
X-HE-Meta: U2FsdGVkX1/2WGpQFVPr+4d1MzbxL2CfvFqvyRWZvsaTiwTLSy+npRgK8uphnUh198JXUza3d3V0dyNDzXuClLSb7IRS39+Yz/cv0nDPINZBukruTVGYXlbSGgySoH8yqrl8jwQ05ARKL7gXoKzDEyG6qhLel3716VRUq5vB0N61wjSFyrb/h/Ex/BB43Mlju/j1W3xMhIq1NhKS9gsc/6X/6LnmZLEW0zu9kLjO8KO6WLbphNvyukssnuCYXGNmIu+5INyWBHBSVTg9r6smpQI9bBw1i4mb0R5loWhozhAw1n43dQLCk0uZMT2q+XWeR75ZZO7aIoZNFDRlvTmRGCRx2LRXg7Ll02EEBLRL5BmD0TG3HYwd6XGLB7g3MU4HSdx0fsqJj7u+BE45w7McsYlyi39Q6yDUmHZeWZN76+hU0qj2BnVL/NMDvOSwcr/8leVyLCY1vSmaMUNJbq7prx/QhnQ25p5caIgbJrqeelu0Cfs5ijCwgyJLs8AqAVnEeaSYAks6XkMboHkfHaYd7bp7fibamySXOlJUIJYy6gnkkHszOqQFtR0LXY2ciAWXyScfiTzyvKme06XsYH0bpdNTobGeskLVzXoXikt6g9bxpIyo1QFpyn+j6rYOctnWUuq/BXv4ADaKamqLGksiGTjxuDXfhUsSjc7K3H27UJGUF653JApACf8CUuUdoSWbcbKd07duECA3jkzK3CvxWYTLK8qTIV0jYSVGQrWVuQBIb4aMu0uchy+CddukC/TX5jYBbo3ZyxEDS5qasYnWpkvn1Sjn0W5g7Zgeyjxj2kMNt5JuwWLx2mwOq75kq4r4Zk+2Hqc2SJEmgz8AkEHWvkwAQonz2YTyO1svFN3KUKOqAhNe4Wv+m6dtvnhhlA+EiiKZxDb7+F0bmD0iVpc0nAEsVxB1ovzdeFHZyCKDKQS16Ud5s60MBnIxXqx4BQBSpKa5USmL9UfELIbeoup
 OWYCmUar
 ZlGF4HdxGqUb2Lbgj2AmvOw8JonxqdGQv70zf7iNApY5e/xL6pRdm2Yqx+nMAIIEDbFV/BUNHkH47eUk1MwSQSxpmrWoZIMPD0smm6iWJBQzo95euBcZ3cqlFjCJjJkUbygwlvCUdQvwk+Dptf+AJD8mMOxgUYPsiK4sylb2uOgFMT+QBrXhSEjW76CMHuHzdvo4z0uU9dsQrrxqudhrD7de8ZajXOvVw85WmMA1hag5h2YwyF7cXyB30/ZTUR/plf4p4rEnWLLl9wbominVEdsJ73ta6KaBwvcYBk1McCQaLcPRuzpZ3fb1F6hiGKLEgrsHmcLRCDl/D4rVSoYXZrZKiTtxN+UQjgUg763P/64XsfxAVUixfK2E07/pxrNAP9y3OsscYbCMgwxxKLgWyI57RcRb5EPKAy5BuDRyuPuHPlBtVy5sDtOHTX2PnBVN0aVvXeans9mSfKnF+LBkm8zjkjll8MMGWgQ63HdF57sZuaIQ2ie/0DDOnq1qw98pK3No+zQcJhhcxO2Fp9K4ZFNJ4gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 fs/internal.h      |  3 ++-
 fs/namespace.c     | 20 +++++++++++++++++++
 fs/utimes.c        | 48 +++++++++++++++++++++++++++++++++++++---------
 include/linux/fs.h |  1 +
 io_uring/fs.c      | 26 +++++++++++++++----------
 mm/shmem.c         |  3 ++-
 6 files changed, 80 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 985b2bc5895e..e991b63bb714 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -64,7 +64,7 @@ int filename_symlinkat(struct filename *from, int newdfd, struct filename *to);
 int filename_linkat(int olddfd, struct filename *old, int newdfd,
 			struct filename *new, int flags);
 int filename_utimensat(int dfd, struct filename *name,
-		       struct timespec64 *times, int flags);
+		       struct timespec64 *times, int flags, bool nowait);
 int vfs_tmpfile(struct mnt_idmap *idmap,
 		const struct path *parentpath,
 		struct file *file, umode_t mode);
@@ -86,6 +86,7 @@ extern int sb_prepare_remount_readonly(struct super_block *);
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
index 8072f05ac8dc..f70ad9003fa9 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -18,7 +18,9 @@ static bool nsec_valid(long nsec)
 	return nsec >= 0 && nsec <= 999999999;
 }
 
-int vfs_utimes(const struct path *path, struct timespec64 *times)
+/* With @nowait, returns -EAGAIN instead of sleeping */
+static int __vfs_utimes(const struct path *path, struct timespec64 *times,
+			bool nowait)
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
@@ -63,24 +73,40 @@ int vfs_utimes(const struct path *path, struct timespec64 *times)
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
 	error = notify_change(mnt_idmap(path->mnt), path->dentry, &newattrs,
 			      &delegated_inode);
 	inode_unlock(inode);
 	if (is_delegated(&delegated_inode)) {
+		if (nowait) {
+			iput(delegated_inode.di_inode);
+			delegated_inode.di_inode = NULL;
+			error = -EAGAIN;
+			goto drop;
+		}
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
@@ -90,13 +116,17 @@ int filename_utimensat(int dfd, struct filename *name,
 
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
@@ -108,7 +138,7 @@ static int do_utimes_path(int dfd, const char __user *filename,
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
index 85e0a1cb6b47..79f6f39ce267 100644
--- a/io_uring/fs.c
+++ b/io_uring/fs.c
@@ -356,38 +356,44 @@ int io_utimensat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (ut->dfd == AT_FDCWD)
 			return -EFAULT;
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
 
-static int __io_utimensat(struct io_utimensat *ut, struct filename *name)
+static int __io_utimensat(struct io_utimensat *ut, struct filename *name,
+			  bool force_nonblock)
 {
 	int flags = ut->flags & (AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH);
 
-	return filename_utimensat(ut->dfd, name, ut->times, flags);
+	return filename_utimensat(ut->dfd, name, ut->times, flags,
+				  force_nonblock);
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
 		CLASS(filename_kernel, name)("");
-		ret = __io_utimensat(ut, name);
+		ret = __io_utimensat(ut, name, force_nonblock);
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
 	} else if (!(ut->flags & IO_UTIMENSAT_NOOP)) {
 		CLASS(filename_complete_delayed, name)(&ut->filename);
-		ret = __io_utimensat(ut, name);
+		ret = __io_utimensat(ut, name, force_nonblock);
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


