Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E830606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VMX4GK9T
Received: by kanga.kvack.org (Postfix)
	id A90266B0703; Fri, 13 Nov 2026 07:02:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68FD6B0705; Fri, 13 Nov 2026 07:02:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4D56B0706; Fri, 13 Nov 2026 07:02:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 617AE6B0703
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:02:24 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C5804C028A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:23 +0000 (UTC)
X-FDA: 85429958166.08.889AEF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D65DE18000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:02:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMX4GK9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dE2hTtE0m5h9YxougRZ2lCucnmPTxya6Cnx70Y4r2Gc=;
	b=SzXTt488zYwDPnvjMWMu9BMmJx2GnlbtLYZchZDA+nzethN1G7HtpllGFO5TEVwAEvwW/g
	Xz+5Gij1nQfs+JPCDtbhQl+waoN1U482Nu4EfPL+cfCG1ODQfQQ77EkIauVrFdkw25PaDq
	Qfkm+n3RX/xrNEvCr79NXN0yCZohFSQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VMX4GK9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571341;
	b=VdPNc0L7GIfpl3LrzGQ3A7mqgvblxd8mDjKMOegpQMHdbtXcJzg9Wpik0tAHCs2eEUKdAJ
	Ld1Opaw3pWgP2vVHMZ5nH3TM3/zsU3sTZtJNUE6V/Yant6lpvjXGEKSg+4OSbyA1WGwToA
	Nr97psLVEZIqJJJDBmWj0ED0NISBtbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6408562635;
	Fri, 13 Nov 2026 12:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DAC1F000C5;
	Fri, 13 Nov 2026 12:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571341;
	bh=dE2hTtE0m5h9YxougRZ2lCucnmPTxya6Cnx70Y4r2Gc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VMX4GK9T1QqX0jMCjmZTcD9CnhCWfUfcSvJYi2XNjZ57FtxLU6EB/3/4q9r/+5hZu
	 eKvqp1es2XIFoSf4R3jDhozLWHtNpVwkujE+lD9Z+huJnixonHHqhHVQroZLVtOt5I
	 3qdcbbWx5fUS2EyzwyC3lkXgefEKshLt4CNmn2g9W2wycnWlHFlRvZYV5yoYN6pU3N
	 pZ/YMx6O3An++kxwnwYCvm+7XUq964M1mVe57TiN2/+fbKkBPR3W4K2RNpqlxAL6FX
	 /p59185g5oHecRDJJeSXCIdkab5vwDHfsHN5SbheeGZkKLodG7h1bQi5xc1ysk8PLh
	 1UYkIvei++mdw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:59:26 +0100
Subject: [PATCH v3 30/33] ubifs: don't set SB_RDONLY after errors
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-30-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=6710; i=brauner@kernel.org;
 h=from:subject:message-id; bh=R1ABsKCXnKiNmLZdfzr1ssLR6gmZNKgRga/FC/TrEs0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+7234/uajY4CWefNfoXJHNS2SF/00b6sc3dy07zuz
 gsK86Y2dZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE15vhf0r7UfMZH65/27Cp
 TGiro4OZtUV9uYeQjp4Je7wxxyPNbkaGVcoroh+qlHr+zzjeHG7U0r9v9bkps35IqngE2l3cFh7
 GDQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D65DE18000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b5shuamyyxud5dorudo8hwfxx1ei9za7
X-HE-Tag: 1794571341-219878
X-HE-Meta: U2FsdGVkX18qYTxNGM60WWMVenhYyp4/X9IF740mAN5p4NjXLivqSyu3LMUoKSuyU0iEauq7erOz1RnHTHHPTaP2ag/VINlVotRw7yN4RdFYUqaJCEYrj9dNb1SAYtRdr0nvEqJgVIhu5/bmTlQlmDIJcSEz0aHe3zSiIln80FyxqRppHDMMg/3fPK+MQfUUqEvWgKCR5zCGvKwaBjzL1Ms7hzs8nsX9JeoF59q6PNvD8EjeQgyVk4BKC2ewoadtTbNmWXIAZaaI67GA6Ij2l1YXicN+TxOqpgILRZQ9OPatDHZpE+qCF59IiBbPmDPjqeJSIw4DYDigklElmiuQwej0LZFmrYDxGZWEYI8X45EZcTiZ2UFXAzsPfx0rQnGLumBr5ltZQv9C+8Gz6GZjMc+DuozddUw2mFQvOFdr0kRSHMtL6EyxGaUYJMvGez4/kErBd6G1nVL/3YiuOVyv+Nx266MDvUgQfNHjVeAlDKFK13+V042tVIM7JhvdKB4Q3MAOPL+bkVkA89YHMy2V7EMBgtybsYQgEe2Y8UpO+2HnUernpiRVu4WF3Wqu+xgJzuMXXi3ZSdJcMIObeDJYYOC/0Fc3ofvodMARQoulJFy+VwzSqPrq0AKlLZmtT6S4JGpiKTn8r3N7J0GYCkxgprWBxxs8hyorLcxIDvHejV+lgRcKYZNHhkzikkY+YZcPxQUnCw3xD5BaaNMO3CGFhtY8YxfEPi3rfZMAi46q2BfNWckW8KNOLGg0NuCraz3F/yf1WuqER9xNyEfQzWVB8PHJ98eLMsZm9zOxff8fLZGzzO1grktYADSpiBIYNSnjN7BfZY6MbegoeLRqaAhMEBmbTVSjfu5DDjzc0eGGrmpRCsndRDeavvfCWF3KlPMJYypTPMPhn75ZSVATCDt/k8/2EvOsBtzP/NOCOOd3bWvPI5Ehjn79y52MhJCWeOkpFYe/O76BveSUPBxGcym
 k/QQGaoV
 wUSjBHHzpEAuYW9Kf5ZSrCvEk1WZtBvcfBEzy2HCQPxBdv4QowPQyTnIN/AypJ9heVdSslJWutg2Ml2a+nW9moZ4m398GMPWO9yD4hJHk5JKdCaj2mQsdh1Aeb3dGNP1sBHWrfI5WiUov/dyMsFCznaAdSQKKaQ+4taDkv1Re0UFPRwI6yTJ/FgzHfgJxVTA+xMpbDGr8qsKRD6rpzoMlI/upG9/yKjx7lt+4zvyuj8jiO15qCGrhEdTeEfB7W8G91+OhR3xrJNpDL3fQZQI2h4p8pzAfHdkKw/mnIhJQfudQSl284USOKycIzqzfD9j6u0drLzJ1IUN5eAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ubifs_ro_mode() sets c->ro_error and SB_RDONLY from whatever context hit
the error, e.g. a failing write, and without holding s_umount. UBIFS
can't be frozen but that still races with everyone else changing
sb->s_flags. And c->ro_error alone already makes every write fail with
EROFS.

So call sb_set_emergency_ro() instead. The background thread can hit
the error before SB_BORN but doesn't hold s_umount either. The xattr
setters check c->ro_error as well because ecryptfs calls them without
write access on the lower mount and they change the inode in memory
first.

So far a remount to read-only after an error was refused and a remount
to read-write went through and cleared SB_RDONLY again because
c->ro_mount was never set. Now going read-only works. Nothing is synced
for it in that state and ubifs_remount_ro() skips the write-buffer syncs
and the master node like ubifs_put_super() does and only cancels the
write-buffer timers. Going read-write after that is refused by the VFS.

The flusher still gets to the folios and inodes that were dirty before
the error, also after the remount which sets c->ro_mount and frees the
write reserve buffer. Every journal write fails with EROFS after an
error anyway. So do_writepage() and ubifs_write_inode() drop them
without going near the journal. Otherwise reserve_space() trips its
!c->ro_mount assert for every folio after the remount.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ubifs/file.c  | 12 ++++++++++++
 fs/ubifs/io.c    |  6 +++++-
 fs/ubifs/super.c | 40 ++++++++++++++++++++++++++--------------
 fs/ubifs/xattr.c |  6 ++++++
 4 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 99dd52715eee9..4eae6c2ae2eea 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -898,6 +898,13 @@ static int do_writepage(struct folio *folio, size_t len)
 
 	folio_start_writeback(folio);
 
+	/* Nothing gets written after an error, drop the folio. */
+	if (unlikely(c->ro_error)) {
+		err = -EROFS;
+		mapping_set_error(folio->mapping, err);
+		goto out;
+	}
+
 	block = folio->index << UBIFS_BLOCKS_PER_PAGE_SHIFT;
 	for (;;) {
 		blen = min_t(size_t, len, UBIFS_BLOCK_SIZE);
@@ -918,6 +925,7 @@ static int do_writepage(struct folio *folio, size_t len)
 		ubifs_ro_mode(c, err);
 	}
 
+out:
 	ubifs_assert(c, folio->private != NULL);
 	if (folio_test_checked(folio))
 		release_new_page_budget(c);
@@ -997,6 +1005,10 @@ static int ubifs_writepage(struct folio *folio, struct writeback_control *wbc)
 		goto out_unlock;
 	}
 
+	/* After an error do_writepage() drops the folio. */
+	if (unlikely(c->ro_error))
+		return do_writepage(folio, len);
+
 	spin_lock(&ui->ui_lock);
 	synced_i_size = ui->synced_i_size;
 	spin_unlock(&ui->ui_lock);
diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 6c6d682427793..931a88329b5f5 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -72,7 +72,11 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
 	if (!c->ro_error) {
 		c->ro_error = 1;
 		c->no_chk_data_crc = 0;
-		c->vfs_sb->s_flags |= SB_RDONLY;
+		/*
+		 * SB_RDONLY needs s_umount, see sb_set_emergency_ro(). The
+		 * background thread runs before SB_BORN already.
+		 */
+		sb_set_emergency_ro(c->vfs_sb);
 		ubifs_warn(c, "switched to read-only mode, error %d", err);
 		dump_stack();
 	}
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 38972786817e7..2d71274e89ad0 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -312,6 +312,12 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 		return 0;
 	}
 
+	/* Nothing gets written after an error, drop the change. */
+	if (unlikely(c->ro_error)) {
+		err = -EROFS;
+		goto out;
+	}
+
 	/*
 	 * As an optimization, do not write orphan inodes to the media just
 	 * because this is not needed.
@@ -327,6 +333,7 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			err = dbg_check_inode_size(c, inode, ui->ui_size);
 	}
 
+out:
 	ui->dirty = 0;
 	mutex_unlock(&ui->ui_mutex);
 	ubifs_release_dirty_inode_budget(c, ui);
@@ -1839,19 +1846,26 @@ static void ubifs_remount_ro(struct ubifs_info *c)
 
 	dbg_save_space_info(c);
 
-	for (i = 0; i < c->jhead_cnt; i++) {
-		err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
+	/* Like ubifs_put_super(), don't write anything after an error. */
+	if (!c->ro_error) {
+		for (i = 0; i < c->jhead_cnt; i++) {
+			err = ubifs_wbuf_sync(&c->jheads[i].wbuf);
+			if (err)
+				ubifs_ro_mode(c, err);
+		}
+
+		c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
+		c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
+		c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
+		err = ubifs_write_master(c);
 		if (err)
 			ubifs_ro_mode(c, err);
+	} else {
+		/* Syncing the write-buffers would have canceled them. */
+		for (i = 0; i < c->jhead_cnt; i++)
+			hrtimer_cancel(&c->jheads[i].wbuf.timer);
 	}
 
-	c->mst_node->flags &= ~cpu_to_le32(UBIFS_MST_DIRTY);
-	c->mst_node->flags |= cpu_to_le32(UBIFS_MST_NO_ORPHS);
-	c->mst_node->gc_lnum = cpu_to_le32(c->gc_lnum);
-	err = ubifs_write_master(c);
-	if (err)
-		ubifs_ro_mode(c, err);
-
 	vfree(c->orph_buf);
 	c->orph_buf = NULL;
 	kfree(c->write_reserve_buf);
@@ -1977,10 +1991,7 @@ static int ubifs_reconfigure(struct fs_context *fc)
 		if (err)
 			return err;
 	} else if (!c->ro_mount && (fc->sb_flags & SB_RDONLY)) {
-		if (c->ro_error) {
-			ubifs_msg(c, "cannot re-mount R/O due to prior errors");
-			return -EROFS;
-		}
+		/* After an error ubifs_remount_ro() can't write but still works. */
 		ubifs_remount_ro(c);
 	}
 
@@ -1994,7 +2005,8 @@ static int ubifs_reconfigure(struct fs_context *fc)
 		mutex_unlock(&c->bu_mutex);
 	}
 
-	if (!c->need_recovery)
+	/* Only valid without a media failure, see ubifs_put_super(). */
+	if (!c->need_recovery && !c->ro_error)
 		ubifs_assert(c, c->lst.taken_empty_lebs > 0);
 
 	return 0;
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index 3b0e8a270f594..572f6f3e52ad3 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -260,6 +260,9 @@ int ubifs_xattr_set(struct inode *host, const char *name, const void *value,
 	if (check_lock)
 		ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (size > UBIFS_MAX_INO_DATA)
 		return -ERANGE;
 
@@ -564,6 +567,9 @@ static int ubifs_xattr_remove(struct inode *host, const char *name)
 
 	ubifs_assert(c, inode_is_locked(host));
 
+	if (c->ro_error)
+		return -EROFS;
+
 	if (fname_len(&nm) > UBIFS_MAX_NLEN)
 		return -ENAMETOOLONG;
 

-- 
2.53.0


