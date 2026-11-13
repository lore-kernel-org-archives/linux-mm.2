Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C474606A888
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HKvL3rwa
Received: by kanga.kvack.org (Postfix)
	id 387316B0632; Fri, 13 Nov 2026 07:00:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312286B0635; Fri, 13 Nov 2026 07:00:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FF866B0637; Fri, 13 Nov 2026 07:00:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC1BD6B0632
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4CB22C0114
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:17 +0000 (UTC)
X-FDA: 85429952874.12.09E0EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 807D04000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKvL3rwa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571215;
	b=jE9d0QQCGk858ZOd18i15oWm7Y+55XRRfSrqrVbndX1IFTjvbKtM5NAXz0tSP4fOpZfcsj
	jCDHWwlcuBmcWsPEuE85luOr33unykNq2RRvQw1BCN7OU8FQ7XmJpIPWd9t1flDooJ0zvW
	cjxThJ+1B844dy7hZ+s1LK7DhYZHLlE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4p0sOEMxtmNsp3R1xDDsbPPEb7o4F3JVoC+2Af2rtpo=;
	b=Rm+Xrp0DtwCBHKi67HgY4xi52SjjI9ce0tbof8JpOa6DbAe5B4S/quchSDUywHim6o02Dv
	oThf1PlCjaBOjAg3pN6Zp9OgKNs2nrp6FN8YMvxW+9uEuBZpLud2nLBa9IwXDCtmV6fm7v
	8f/rMsUo12CfRENPrZgodJYCsOn+kio=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HKvL3rwa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19A67620BC;
	Fri, 13 Nov 2026 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92A21F000C5;
	Fri, 13 Nov 2026 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571214;
	bh=4p0sOEMxtmNsp3R1xDDsbPPEb7o4F3JVoC+2Af2rtpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HKvL3rwazdcQCO3oa5t3kvt9qtirfGajlNUScRhrOlPzVrVS+WLbWgKCk5k9Gzjyg
	 J5rQjeEiCJ/5FZ+6mbJmOCsAP05MmskuKkJ5CnFSbXeuMGW+kicSyT0/o+Px28bfb4
	 khjvrmVjPr0pqO2GDZZAJIpgg27+hp74fJ9lfUxJVqm2lYB1I6fk24cjd0SnyH7iSX
	 wQ0mpHU0hFKNOQ2YfMiz7PU23jiCz8rltBdahrbyQBukM5DNNLscVp9GRZFLJ3UHKV
	 OBmOKLWNGoYsLZLWfX355kTpX1HMnF6bayA9fcMtBpCodubvnBDhluyjo7qZiY03Yg
	 OtLD/DSdy3vyQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:57 +0100
Subject: [PATCH v3 01/33] jfs: free uncommitted anonymous tlocks when
 evicting an inode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-1-0be92bb73709@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5941; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fGd3mqwHefcvtPwiRiUST+AMp4oJuL6AE505Gk4ephw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z0r5fC6jrkPt0nVv3xdfdXsx357tc/O5/b2fr/B2
 7nYuqWJo6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi/4oY/krrCiydOuVYYlvK
 u6LLol/2xTKYX65Z+/T9rzNfJ0uqrmhlZNiUbs59sr8j4UVNOvvdYyWFyiWtlz6YvDgze9n8rot
 ayUwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 807D04000F
X-Rspamd-Server: rspam12
X-Stat-Signature: oub9mr7crj54t5rn5w4xi4a96xikyhf3
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794571215-927088
X-HE-Meta: U2FsdGVkX1/mNvFFW7V8he8pqDAYly80jQHuRyTsg19IFzIURqW4cgoxjUxnbFwhZ3bHVHAo6uLzXcWc8UQtiTkaCPSB8jDttRBinfjoBxhagR37emXxJzZt84cThoSwnZzPnc4upYdYOdEeLQ/DDz4/dC6//XUW8nqqeAMcXyEefBwqZnu5NJwufWKT6NBE3wV2fEtaGwO6l+Cu06exDh+ZcOHAkwSbMbLIDalXlCe2kJmyV1xe5/34MKFKGi0gEkYnL3mCXtSQIKGuK+KWHoWKlIS17q81X3ncnn/gnF6d7YTHEvMI91xVcatbyg7y//E3hXcgCD/mzf/HUhiLbUEI63NplQkyAzPIjuYAiO8ez7UUjtK1y/YOKr4oJu363B/YZkmiWxx2EmP/zd5gaY8bwhSMQk2T/CfsvfGkbVpAVIYfy1oKybmSvis1xoMomlpE0S5hMO4uOmWfUrpioQ4vOGIiPzfFMyLrHZx+OonQ9w1dvHi43hMHqf5A3zMmPi0EnVGK7KAoAi/pQf3RcGVVD4FPWktlgT31Stp9Y4cTXOjDOe247RWw5PS2zQiYJhWn9ng17IXY9hcr4CC8wb/+7MaSdlPCrQXg+oqQs0sOuVhwKZaz/VE4O9gPvdqqwv8nXBH2peDfNSeG3eM+QrpOm6kQKGdsS0FoL6nT9PnWnYgpV6bBp2gdUnDH7qGs14/jcs8YA491RRDF6EE8GpMNRFT61Fx3XR8NQjYiA+K7T7clrQw74eNdX8QaLeusuT/pKqauuMHyqb4A0yeJyraWMIYinB8JCL79YkL9tPKQ8qf4b/5cqtGuHp3n5aKULk2e2vXXzWGvO64qrxT/EnCkaUlFOAZOTlePzVrUSO1gHsn0vcrGrQXT7NOmt/CKY9P4ssyD1WwCYwoVVWF1uV+/M6ck3YdJBCaLiBJwjhg16+WIMCwR7gA+rkbJHtGx1PQtui8dYH75k+dmfnG
 srHL21PR
 UVasdISvm4PA6nnmb43KNd/9/jfRwzXcLksEbDv8etVx/WXjnRDavrlj0LV/TNJ+9BbM64Vv9a1n499CigU3g4TsQEtmg8cOu1FrQ0kQ11dgcipFukdzXT3OtITgPPvA3uJTAodYvwaSPcKJHuGBYvnYepQ3WLolvGkAwego4t0GhZbe2wJArWWwIw27tXszO9CFrzEA3MgpufdzGuHLc1dCs+rn3eMT/i2yHMtUVYJfVKT5k5C4tjmAf88tkJKynDuEWJkO4ZAN5aN8k6Tihi2wTtHqVBtRrdEYa/wmG1RfToPEh9sKiaGnmcsFQtR/cXtqf6p/+XdmEd3NA1lLOpTxIjNCSQm0+6ADafs8Gs1OCiFff6pVSlDmtZvrAaQGqbIMafYlxBBPOrqID15qmKUxwY54UtHiKj9t7ZA6L80oqiSbShR3gawg5+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

jfs doesn't log block allocations made through ->write_begin() and
->writepages() right away. extAlloc() records them in anonymous
transaction locks that hang off the inode and puts the inode on the
global anonymous list. They only get committed when a later transaction
includes the inode, usually writeback calling ->write_inode() which ends
up in jfs_commit_inode(). jfs_evict_inode() relies on that and BUG()s
when the inode is still on the anonymous list.

But nothing guarantees that writeback ran before eviction. With
errors=remount-ro, the default, an error sets SB_RDONLY and
sync_filesystem() skips read-only superblocks. So unmounting the
filesystem after an error evicts every inode that allocated blocks since
it was last written back without committing anything and the BUG_ON()
fires. Writing a file and hitting an error before the flusher got to the
inode is enough:

  kernel BUG at fs/jfs/inode.c:175!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:jfs_evict_inode+0x33c/0x440
  Call Trace:
   <TASK>
   evict+0x336/0x8b0
   evict_inodes+0x421/0x850
   generic_shutdown_super+0xaf/0x530
   kill_block_super+0x36/0xa0
   deactivate_locked_super+0x97/0xf0
   cleanup_mnt+0x9a/0x130
   task_work_run+0x135/0x230
   exit_to_user_mode_loop+0x171/0x560
   do_syscall_64+0x410/0x5e0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>

Just taking the inode off the anonymous list isn't enough. The tlocks
come from TxLock which is shared by all jfs mounts, txLock() pointed
mp->lid at them and pinned the metapages with metapage_nohomeok(). Leak
them and every other jfs filesystem eventually blocks in txBeginAnon()
waiting for tlocks that never come back.

So free them the way txUnlock() frees the tlocks of a committed
transaction: drop the metapage_nohomeok() pin, reset mp->lid and free
the linelocks and the tlock itself. txAbort() isn't a good model here as
it only drops the pin for pages that are on the logsync list and leaves
the linelocks alone. A metapage that carries nothing but the uncommitted
change isn't written home. The superblock is marked dirty after an error
so fsck has to look at the filesystem anyway.

Note that jfs_sync() takes an inode it can't grab off the anonymous list
without freeing anything so check jfs_ip->atlhead instead of the list.

Fixes: 8a9cd6d67672 ("JFS: Fix race in txLock")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/jfs/inode.c      |  9 +++++++
 fs/jfs/jfs_txnmgr.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/jfs/jfs_txnmgr.h |  1 +
 3 files changed, 78 insertions(+)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index c7914dbc91ed9..6390d915c7f11 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -172,6 +172,15 @@ void jfs_evict_inode(struct inode *inode)
 	clear_inode(inode);
 	dquot_drop(inode);
 
+	/*
+	 * Writeback commits the anonymous transactions of allocations. If the
+	 * filesystem went read-only without a sync, e.g. after an error,
+	 * nothing did.
+	 */
+	if (ji->atlhead) {
+		WARN_ON_ONCE(!sb_rdonly(inode->i_sb));
+		txAbortAnon(inode);
+	}
 	BUG_ON(!list_empty(&ji->anon_inode_list));
 
 	spin_lock_irq(&ji->ag_lock);
diff --git a/fs/jfs/jfs_txnmgr.c b/fs/jfs/jfs_txnmgr.c
index 083dbbb0c3268..85192dd4461a4 100644
--- a/fs/jfs/jfs_txnmgr.c
+++ b/fs/jfs/jfs_txnmgr.c
@@ -2581,6 +2581,74 @@ void txFreelock(struct inode *ip)
 	TXN_UNLOCK();
 }
 
+/*
+ *	txAbortAnon()
+ *
+ * function:	free the anonymous tlocks of an inode that is evicted
+ *		before writeback committed them, e.g. because an error made
+ *		the filesystem read-only.
+ *
+ * A page that carries nothing but uncommitted changes isn't written home.
+ * A page that is also waiting to go home with committed changes (mp->lsn)
+ * goes home with both, after an error the superblock is marked dirty.
+ */
+void txAbortAnon(struct inode *ip)
+{
+	struct jfs_inode_info *jfs_ip = JFS_IP(ip);
+	struct linelock *linelock;
+	struct metapage *mp;
+	struct tlock *tlck;
+	lid_t lid, next, llid, k;
+
+	/* txQuiesce() and jfs_sync() commit under the commit_mutex */
+	mutex_lock(&jfs_ip->commit_mutex);
+
+	TXN_LOCK();
+	lid = jfs_ip->atlhead;
+	jfs_ip->atlhead = jfs_ip->atltail = 0;
+	list_del_init(&jfs_ip->anon_inode_list);
+	TXN_UNLOCK();
+
+	for (; lid; lid = next) {
+		tlck = lid_to_tlock(lid);
+		next = tlck->next;
+		mp = tlck->mp;
+
+		if (mp && (tlck->flag & tlckPAGELOCK)) {
+			/* undo txLock()'s metapage_nohomeok() */
+			hold_metapage(mp);
+			if (!mp->lsn)
+				clear_bit(META_dirty, &mp->flag);
+			TXN_LOCK();
+			mp->lid = 0;
+			TXN_UNLOCK();
+			_metapage_homeok(mp);
+			put_metapage(mp);
+		} else if (mp) {
+			/* the xtree root in the inode, it isn't written anymore */
+			TXN_LOCK();
+			if (jfs_ip->xtlid == lid)
+				jfs_ip->xtlid = 0;
+			else
+				mp->lid = 0;
+			TXN_UNLOCK();
+		}
+
+		TXN_LOCK();
+		llid = ((struct linelock *) &tlck->lock)->next;
+		while (llid) {
+			linelock = (struct linelock *) lid_to_tlock(llid);
+			k = linelock->next;
+			txLockFree(llid);
+			llid = k;
+		}
+		txLockFree(lid);
+		TXN_UNLOCK();
+	}
+
+	mutex_unlock(&jfs_ip->commit_mutex);
+}
+
 /*
  *	txAbort()
  *
diff --git a/fs/jfs/jfs_txnmgr.h b/fs/jfs/jfs_txnmgr.h
index ba71eb5ced567..e9a7547afd3f6 100644
--- a/fs/jfs/jfs_txnmgr.h
+++ b/fs/jfs/jfs_txnmgr.h
@@ -288,6 +288,7 @@ extern struct linelock *txLinelock(struct linelock *);
 extern void txFreeMap(struct inode *, struct maplock *, struct tblock *, int);
 extern void txEA(tid_t, struct inode *, dxd_t *, dxd_t *);
 extern void txFreelock(struct inode *);
+extern void txAbortAnon(struct inode *);
 extern int lmLog(struct jfs_log *, struct tblock *, struct lrd *,
 		 struct tlock *);
 extern void txQuiesce(struct super_block *);

-- 
2.53.0


