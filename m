Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF347C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE566B0096; Wed, 23 Sep 2026 18:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7566B0098; Wed, 23 Sep 2026 18:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467456B0099; Wed, 23 Sep 2026 18:44:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07B756B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:44:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6768E80184
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:35 +0000 (UTC)
X-FDA: 85246507710.28.BF65ED8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D28D2140007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fP2ibDoP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790203473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ppyzkpiHfzcRPB9/8pM+Rg0xhLEz5xnxGptHULBj05Q=;
	b=Sn2wk1vQ98bI47ODiMPcTCA7OnUXK829AUdukFyKqCx19qCK1Pe044cHrRUQuFJn8cgDod
	bMdSBbJscq3STFjJqIpWovQhKR5ut63EICr822tACSF7eUSUO9GB5dXUGuj7Qcim/Z9U2P
	6hFwNQuHtqC5sXjYaC4qFuMV5Bq1HoE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fP2ibDoP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790203473;
	b=k5CxBQRGL6H/MVy7kUxkI0cAEHDbYUdDyHASKnvIavnv7NGfppfIQMIc4ThMEM+tV5SgTV
	hqWSTw+Aqz8IuK+/t2DICBJL2v2K6QndWC1JTLxllFUHfKgFtx2ZGIwxNrQAEYUsDfvC/5
	7Iy0oovbVwH3taIsF8NLof3e7sjYC8U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 688706020C;
	Wed, 23 Sep 2026 22:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC0F21F00898;
	Wed, 23 Sep 2026 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790203473;
	bh=ppyzkpiHfzcRPB9/8pM+Rg0xhLEz5xnxGptHULBj05Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fP2ibDoPZ4EXQS+PSvLtiwA3SOjO2JC8tuNRaL2UUfZxIX+HeouMuBP/+Y71TSpa5
	 CmvlFyGFpn/eyAgKl0Yw71IT65dJKaRFXeJDVwFi7tGEzV3GFq08QO9IQR4x2uGWAg
	 aQaxngQ5F1vtH6RZWMMhRBARZHnVDGZGlBQJSJ7oJjUvFJs8cdfMAgEu9/eE9OL967
	 E/32rcLdGy9tqPe8rrP9zizmXV2V1884jVR4S8DW/ILwEMkDvB2Aog4KhFn4hRv+tc
	 i63l844SnbMNZ6sWJ6SRfQXkJsBdn66kSiEaYBsmyaUrRwj3GQS6O7gBryB0A90PTM
	 dlyZdVkf089BQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Matlack <dmatlack@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/6] mm/memfd_luo: allow preserving a tmpfs file
Date: Thu, 24 Sep 2026 00:44:04 +0200
Message-ID: <20260923224408.3745689-6-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
In-Reply-To: <20260923224408.3745689-1-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D28D2140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tt5jponh8mzhsjur4spwkk1ean4zwq6z
X-HE-Tag: 1790203473-355549
X-HE-Meta: U2FsdGVkX189KcbmbgN1Je0q6KVXHAw3uAsbPw7Si9xeohwW6/LbT+FMItD5efuEM4EuV4CikH7zRqDXmPJlwJDWKIuu4+ek1mhWgIENrh98RoafrWvpZVXNQ2xn1ZUbSpp3ZjhfS+ALdvDSbYgcjgaEIPzyoUsREMyCJppAqKOPwlaVOfauO2jULi3QNtGnYNMI8P+R4yVQnxPhfU/sS3PQJVYXVSQSJTnxNoE6JDjN5nGPKtNw+xncznqWtNBHZNJlbAjBJCrFnMbaXFzrOfgmoAGuc6Z7Z4FFqj0k2Z5exOLsKIPyLWF2olHO2P5sSR7Kf/Zq71MqOty3Az3IkLPy1vVulGHd8CY29XLNx9JWarABv97QSeAOlwhWQX9TlCbUIZlftAbNXAviMPXZBaLOA+Y87ptGtXD85ZW5x+nYhVCKUrxZopaFsPscbMRWWFfCf+lilopg0gUUi5x1c1gpb0JN/tyrN4vkmT0zsQ22dZC6PmXuGPIEz64zCp9v7IkqmM1VqeweBxqxRFO4wDXcpL0LmYe9P2CymROrlBHzJoSLAxHQRX5tNx7/mTl8ZEEWBTqmOBNSoq3w4K36W+vDm69QtP10e9K3L0dF37fWT5CdriNMPGKXqMfCI3DNzSKVS+hOcPgA7tkvIhiKKAyzRfQEgEm88DiHPnxOaz8OC+rb100dsKrpPuAD6qM8iTQwRDBiYgS2TlCGWrUomZcxtV1ieFKvgecpyVaJjJobsavayCLEtA3hDx4Nk9ef77gmKW5A4HwpDkKcf+ghy1gU5tpK8dHacBvs/p4ezt/MZp3nFh5q1G7q5uweCIxEYIHmQW789R0Qw3INjTr1kTTuh7Mam4/a5uEQdHf6fkg8xrXgr419MMhkJTFmX/USG7pCfvHCWWgbPOS2qdzGfrESYZXhwaX/Fof4iJWPJP1TwfjqwxSc38kFRYSh0TBVm+Z1mQuDHjEoWIujUMK
 ylysZN0d
 1kg8bnba7auXYzN9jTwO1yQCsd/GzuDCuKFQpa2o65qNwG5Z+fyiah1qvdMj7xGf5t79RiI1KnjWhCHINXDIlZ1E4C9hxkq9bj14Am9eXYOnepP16RfPFoIEqmlk2qlA+vTYSIAskYOsKGVm5aVs0Y8QhstQNvQNQ5NYypTfqqYy8+Kxn83SVi/tkih9aD2bFt3U7/ytUw5NbMY7KXAAiq54TYQEu9ZdUR39qQCNxKRb+jRvlCc35VmHZlaMr0SGzQQ9MwtKl0Fmzi9oITIRfeyJxcC/3Q6o/iKDy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A memfd can be preserved across a live update, but it has no name, so
anything that needs a filesystem path cannot use one.

The main use case is to fetch VMM binaries that need to be kept on the
host memory during a live update to avoid the latency of fetching them
from network. The host does not have any attached local storage to store
the binaries.

Allow preserving files in a tmpfs mount. Only regular files in the mount
root are supported to keep things simple. Files in subdirectories will
be rejected. The mount must be preserved before the files because the
file takes a dependency on the mount. Restoration can be done in any
order.

Files are allowed to be renamed after preservation, but they can not be
unlinked. Unlinked files will cause the freeze() callback to fail and
result in a failed live update.

Re-use the memfd preservation logic and ABI since it already knows how
to preserve a shmem file. The same restrictions around file resizing
apply.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---

The usage of liveupdate_get_file_incoming() makes lockdep scream. The
locking itself is fine, but two locks of the same class are taken.
Likely need some annotation in liveupdate_get_file_incoming(). That is
separate work and not done by this series.
---
 include/linux/kho/abi/tmpfs.h |  35 ++++
 mm/memfd_luo.c                | 342 ++++++++++++++++++++++++++++++++--
 2 files changed, 366 insertions(+), 11 deletions(-)

diff --git a/include/linux/kho/abi/tmpfs.h b/include/linux/kho/abi/tmpfs.h
index bed41048a19b..cd47e2eb5041 100644
--- a/include/linux/kho/abi/tmpfs.h
+++ b/include/linux/kho/abi/tmpfs.h
@@ -19,6 +19,11 @@
  * tmpfs uses the ABI defined below for preserving a mount and the regular
  * files in it across a kexec reboot using the LUO.
  *
+ * Regular files in the root of such a mount are preserved individually into
+ * `struct tmpfs_luo_file_ser` and reference their mount by its LUO token. Only
+ * the folios holding the file contents are true handover payload; they use the
+ * memfd ABI (`struct memfd_luo_folio_ser`) unchanged.
+ *
  * The mount metadata is preserved via `tmpfs_luo_mnt_ser`.
  *
  * This interface is a contract. Any modification to the structure layout
@@ -42,7 +47,37 @@ struct tmpfs_luo_mnt_ser {
 	u32 flags;
 } __packed;
 
+/**
+ * struct tmpfs_luo_file_ser - Serialized state of a preserved tmpfs file.
+ * @mnt_token: The LUO token of the tmpfs mount this file lives in.
+ * @pos:       The file's current position (f_pos).
+ * @size:      The total size of the file in bytes (i_size).
+ * @mode:      The permission bits of the file (i_mode). The file type is
+ *             always S_IFREG.
+ * @flags:     Flags for the file. Unused flag bits must be set to 0.
+ * @nr_folios: Number of folios in the folios array.
+ * @folios:    KHO vmalloc descriptor pointing to the array of
+ *             struct memfd_luo_folio_ser.
+ * @name:      The NUL-terminated name of the file in the root of the mount,
+ *             This is a single path component: it never contains '/', is never
+ *             "." or "..", and all bytes after the terminator must be 0.
+ */
+struct tmpfs_luo_file_ser {
+	u64 mnt_token;
+	u64 pos;
+	u64 size;
+	u32 mode;
+	u32 flags;
+	u64 nr_folios;
+	struct kho_vmalloc folios;
+	/* NAME_MAX is uAPI. */
+	char name[NAME_MAX + 1];
+} __packed;
+
 /* The compatibility string for the tmpfs mount file handler */
 #define TMPFS_LUO_MNT_FH_COMPATIBLE	"tmpfs-mnt-v1"
 
+/* The compatibility string for the tmpfs file handler */
+#define TMPFS_LUO_FILE_FH_COMPATIBLE	"tmpfs-file-v1"
+
 #endif /* _LINUX_KHO_ABI_TMPFS_H */
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index f29571666364..aacae90218cc 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -619,8 +619,8 @@ static struct liveupdate_file_handler memfd_luo_handler = {
  * Overview
  * ========
  *
- * tmpfs mounts can be preserved via LUO. This allows userspace to preserve an
- * in-memory filesystem across kexec.
+ * tmpfs mounts and the files contained can be preserved via LUO. This allows
+ * userspace to preserve in-memory files with a filesystem path across kexec.
  *
  * Preservation is not transparent. Only the properties listed below survive;
  * everything else comes back at its default.
@@ -632,10 +632,16 @@ static struct liveupdate_file_handler memfd_luo_handler = {
  * descriptor is rejected, so one obtained from fsmount(2) has to be reopened
  * first with ``openat(fsmount_fd, ".", O_RDONLY | O_DIRECTORY)``.
  *
- * Mounts with memory policies, id mappings, quotas, and casefolding are not
- * supported.
+ * Each file is then preserved through its own FD. A file depends on its mount,
+ * so the mount must already be preserved in the same session; otherwise
+ * preserving the file fails with ``-ENOENT``.
  *
- * Attaching a memory policy after preserve will fail the freeze.
+ * Only regular files linked at the root are supported. Files in subdirectories
+ * are not supported. Mounts with memory policies, id mappings, quotas, and
+ * casefolding are also not supported.
+ *
+ * Unlinking a file or attaching a memory policy after preserve will fail the
+ * freeze.
  *
  * Restoring
  * =========
@@ -645,8 +651,12 @@ static struct liveupdate_file_handler memfd_luo_handler = {
  *
  *	move_mount(fd, "", AT_FDCWD, "/some/path", MOVE_MOUNT_F_EMPTY_PATH);
  *
- * Closing the mount descriptor without ever attaching it tears the mount down,
- * and everything in it goes too.
+ * Until then the restored files are reachable only through the descriptors LUO
+ * hands back. Closing the mount descriptor without ever attaching it tears the
+ * mount down, and everything in it goes too.
+ *
+ * Unlike preservation, files may be retrieved before their mount. If the mount
+ * cannot be retrieved, every file in it fails with the same error.
  *
  * Like fsmount(2)'s, the restored mount descriptor is an ``O_PATH`` one, so
  * preserving the same mount again for a second live update means reopening its
@@ -655,12 +665,30 @@ static struct liveupdate_file_handler memfd_luo_handler = {
  * Preserved Properties
  * ====================
  *
+ * Of the mount:
+ *
  * ``nr_blocks=``:
  *   The block limit. Restoring file contents is charged against it.
  *
  * Root directory mode
  *   Including the sticky and setgid bits.
  *
+ * Of each file:
+ *
+ * Contents and size
+ *   Holes are filled by allocating pages for them during preservation, as with
+ *   memfd.
+ *
+ * Name
+ *   A single component in the root of the mount.
+ *
+ * Permission bits
+ *   Not including the setuid and setgid bits; see below.
+ *
+ * File position
+ *   So that the returned descriptor can be read from or written to where the
+ *   old one left off.
+ *
  * Not Preserved
  * =============
  *
@@ -670,12 +698,11 @@ static struct liveupdate_file_handler memfd_luo_handler = {
  *
  * Ownership
  *   Everything comes back owned by whoever retrieves it. If different ownership
- *   is needed, userspace must do that after retrieving the mount.
+ *   is needed, userspace must do that after retrieving the files.
  *
  * Timestamps, inode numbers, extended attributes and ACLs
- *   A restored mount root is a new inode with fresh timestamps and a new
- *   number. utimensat(2) can set the timestamps again once the mount is
- *   attached.
+ *   A restored file is a new inode with fresh timestamps and a new number.
+ *   utimensat(2) can set the timestamps again once the mount is attached.
  */
 
 static unsigned long tmpfs_luo_mnt_id(struct super_block *sb)
@@ -821,6 +848,289 @@ static struct liveupdate_file_handler tmpfs_luo_mnt_handler = {
 	.compatible = TMPFS_LUO_MNT_FH_COMPATIBLE,
 };
 
+static bool tmpfs_luo_file_can_preserve(struct liveupdate_file_handler *fh,
+					struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct dentry *dentry = file->f_path.dentry;
+	struct super_block *sb = inode->i_sb;
+
+	if (!shmem_file(file) || (sb->s_flags & SB_NOUSER))
+		return false;
+
+	/* Only linked regular files allowed. */
+	if (!S_ISREG(inode->i_mode) || d_unlinked(dentry))
+		return false;
+
+	/* Only files in the root of the mount are supported for now. */
+	if (dentry->d_parent != sb->s_root)
+		return false;
+
+	return true;
+}
+
+static unsigned long tmpfs_luo_file_get_id(struct file *file)
+{
+	return (unsigned long)file_inode(file);
+}
+
+static int tmpfs_luo_file_preserve(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+	struct memfd_luo_folio_ser *folios_ser;
+	u64 nr_folios, inode_size, mnt_token;
+	struct tmpfs_luo_file_ser *ser;
+	int err;
+
+	/* Find the token of the mount. It is identified by its superblock. */
+	err = liveupdate_get_token_outgoing(args->session, tmpfs_luo_mnt_id(inode->i_sb),
+					    &mnt_token);
+	if (err)
+		return err;
+
+	ser = kho_alloc_preserve(sizeof(*ser));
+	if (IS_ERR(ser))
+		return PTR_ERR(ser);
+
+	inode_lock(inode);
+	shmem_freeze(inode, true);
+
+	inode_size = i_size_read(inode);
+
+	/*
+	 * memfd_pin_folios() caps at UINT_MAX folios; refuse larger files to
+	 * avoid silently preserving only a prefix.
+	 */
+	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
+		err = -EFBIG;
+		goto err_free_ser;
+	}
+
+	ser->mnt_token = mnt_token;
+
+	/*
+	 * Preserve only folios now. Name, mode, etc. can change later and are
+	 * cheap to preserve. They will be preserved on freeze().
+	 */
+	err = memfd_luo_preserve_folios(args->file, &ser->folios, &folios_ser,
+					&nr_folios);
+	if (err)
+		goto err_free_ser;
+
+	ser->nr_folios = nr_folios;
+	inode_unlock(inode);
+
+	args->private_data = folios_ser;
+	args->serialized_data = virt_to_phys(ser);
+
+	return 0;
+
+err_free_ser:
+	kho_unpreserve_free(ser);
+	shmem_freeze(inode, false);
+	inode_unlock(inode);
+	return err;
+}
+
+static int tmpfs_luo_file_freeze(struct liveupdate_file_op_args *args)
+{
+	struct dentry *dentry = args->file->f_path.dentry;
+	struct inode *inode = file_inode(args->file);
+	struct dentry *root = inode->i_sb->s_root;
+	struct tmpfs_luo_file_ser *ser;
+	int err;
+
+	/*
+	 * Lock the mount root to block renames and unlinks, then the inode
+	 * itself to stabilize its mode and size.
+	 */
+	inode_lock_shared_nested(d_inode(root), I_MUTEX_PARENT);
+	inode_lock_shared(inode);
+
+	/* Renamed into a subdirectory. */
+	if (dentry->d_parent != root) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
+	/* Unlinked after preserve. */
+	if (d_unlinked(dentry)) {
+		err = -ENOENT;
+		goto unlock;
+	}
+
+	ser = phys_to_virt(args->serialized_data);
+
+	/*
+	 * Zero-pads the tail, which the ABI requires. Cannot fail, the dentry
+	 * name is bounded by NAME_MAX, but check anyway.
+	 */
+	if (strscpy_pad(ser->name, dentry->d_name.name) < 0) {
+		err = -ENAMETOOLONG;
+		goto unlock;
+	}
+
+	ser->mode = inode->i_mode & 0777;
+	ser->size = i_size_read(inode);
+	ser->pos = args->file->f_pos;
+
+	err = 0;
+
+unlock:
+	inode_unlock_shared(inode);
+	inode_unlock_shared(d_inode(root));
+	return err;
+}
+
+static void tmpfs_luo_file_unpreserve(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+	struct tmpfs_luo_file_ser *ser;
+
+	inode_lock(inode);
+	shmem_freeze(inode, false);
+
+	ser = phys_to_virt(args->serialized_data);
+	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
+				    ser->nr_folios);
+
+	kho_unpreserve_free(ser);
+	inode_unlock(inode);
+}
+
+/*
+ * A name from the previous kernel is untrusted input. There is no separate
+ * length, so the NUL terminator is the only bound.
+ */
+static bool tmpfs_luo_name_valid(const char *name, size_t size)
+{
+	size_t len = strnlen(name, size);
+
+	/* Non-empty, NUL terminated, and a single component. */
+	if (!len || len == size || memchr(name, '/', len))
+		return false;
+
+	return strcmp(name, ".") && strcmp(name, "..");
+}
+
+static int tmpfs_luo_file_retrieve(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_folio_ser *folios_ser;
+	struct file *mnt_file, *file;
+	struct tmpfs_luo_file_ser *ser;
+	struct inode *inode;
+	int err;
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	if ((ser->mode & ~0777) || ser->flags ||
+	    !tmpfs_luo_name_valid(ser->name, sizeof(ser->name))) {
+		err = -EINVAL;
+		goto free_ser;
+	}
+
+	err = liveupdate_get_file_incoming(args->session, ser->mnt_token,
+					   &mnt_file);
+	if (err) {
+		pr_err("failed to retrieve tmpfs mount: %pe\n", ERR_PTR(err));
+		goto free_ser;
+	}
+
+	/*
+	 * TODO: This is racy. This will link the file in the mount so after
+	 * this call userspace can already open the file and write to it.
+	 * Ideally we should first create the inode and set it up, and only
+	 * then link it to the root.
+	 */
+	file = file_open_root(&mnt_file->f_path, ser->name,
+			      O_RDWR | O_CREAT | O_EXCL | O_LARGEFILE,
+			      ser->mode);
+	fput(mnt_file);
+	if (IS_ERR(file)) {
+		pr_err("failed to create '%s': %pe\n", ser->name, file);
+		err = PTR_ERR(file);
+		goto free_ser;
+	}
+
+	inode = file_inode(file);
+
+	inode_lock(inode);
+	i_size_write(inode, ser->size);
+	inode_unlock(inode);
+
+	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (!folios_ser) {
+			err = -EINVAL;
+			goto put_file;
+		}
+
+		err = memfd_luo_retrieve_folios(file, folios_ser,
+						ser->nr_folios);
+		vfree(folios_ser);
+		if (err)
+			goto put_file;
+	}
+
+	args->file = file;
+	kho_restore_free(ser);
+
+	return 0;
+
+put_file:
+	fput(file);
+free_ser:
+	kho_restore_free(ser);
+	return err;
+}
+
+static void tmpfs_luo_file_finish(struct liveupdate_file_op_args *args)
+{
+	struct memfd_luo_folio_ser *folios_ser;
+	struct tmpfs_luo_file_ser *ser;
+
+	/*
+	 * A successful retrieve() already consumed the preserved memory, and a
+	 * failed one cleaned up what it could. Only a file that was never
+	 * retrieved is left to discard here.
+	 */
+	if (args->retrieve_status || !args->serialized_data)
+		return;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	if (ser->nr_folios) {
+		folios_ser = kho_restore_vmalloc(&ser->folios);
+		if (folios_ser) {
+			memfd_luo_discard_folios(folios_ser, ser->nr_folios);
+			vfree(folios_ser);
+		}
+	}
+
+	kho_restore_free(ser);
+}
+
+static const struct liveupdate_file_ops tmpfs_luo_file_ops = {
+	.freeze = tmpfs_luo_file_freeze,
+	.finish = tmpfs_luo_file_finish,
+	.retrieve = tmpfs_luo_file_retrieve,
+	.preserve = tmpfs_luo_file_preserve,
+	.unpreserve = tmpfs_luo_file_unpreserve,
+	.can_preserve = tmpfs_luo_file_can_preserve,
+	.get_id = tmpfs_luo_file_get_id,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler tmpfs_luo_file_handler = {
+	.ops = &tmpfs_luo_file_ops,
+	.compatible = TMPFS_LUO_FILE_FH_COMPATIBLE,
+};
+
 static int __init memfd_luo_init(void)
 {
 	int err;
@@ -844,8 +1154,18 @@ static int __init memfd_luo_init(void)
 		goto err_unregister_memfd;
 	}
 
+	err = liveupdate_register_file_handler(&tmpfs_luo_file_handler);
+	if (err) {
+		pr_err("Could not register luo tmpfs file handler: %pe\n",
+		       ERR_PTR(err));
+
+		goto err_unregister_tmpfs_mnt;
+	}
+
 	return 0;
 
+err_unregister_tmpfs_mnt:
+	liveupdate_unregister_file_handler(&tmpfs_luo_mnt_handler);
 err_unregister_memfd:
 	liveupdate_unregister_file_handler(&memfd_luo_handler);
 
-- 
2.56.0.rc1.310.g51773c2048-goog


