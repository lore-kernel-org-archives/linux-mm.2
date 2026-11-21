Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA9E606A6A3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GBIWfWUk
Received: by kanga.kvack.org (Postfix)
	id 1EB076B05BA; Fri, 20 Nov 2026 19:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8D56B05BC; Fri, 20 Nov 2026 19:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF866B05BA; Fri, 20 Nov 2026 19:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5D8F6B05BA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CA4B1A0262
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:28 +0000 (UTC)
X-FDA: 85457192016.17.B4D43D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 908D2180006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBIWfWUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219766;
	b=eMQhe7K2qDYNpIw5PXA7pCl5IDD4jv6VvOwkcp4vO1795OgICZ99kdPq7RoD1fcTN/9Ar/
	ZzspV7KjAmym8XyZLCOt1L9dk8R5c17drgR9BdIa9sXI5XcIy5k+bb/TUlNR5WwuAICGPI
	rDb+IZf2ZSTF1A2haZzB/SteeqSCxFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+f1eU7ac3P35v22m7Eb/vGvj0V/F0nbMpLFasj8SJb4=;
	b=n9fG0wqX3Rws4gg34gg+etPdwym4R11iQPOtFXZ2+85JkG/oBoYg0Xyw/uhuGnVoIgsgob
	xAuUVtvDlsLNMVhw6GxEzKybEQaom5fYeTL7sRp6JWs721hhqp5KRU20vTjxYZIgtzGsr9
	mYM1vmeAkdsZjsBP/XYauGNK8rlahNo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GBIWfWUk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 845C9442D1;
	Sat, 21 Nov 2026 00:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3BFAB1F000EF;
	Sat, 21 Nov 2026 00:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219764;
	bh=+f1eU7ac3P35v22m7Eb/vGvj0V/F0nbMpLFasj8SJb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBIWfWUkM4x2QWdqaZHh0KG+xlwuw31r3M2RMQCC1zF5lWkxilX1M+EdZ4AMV37l2
	 crd1fBHHEfPb0+oeX89AtDuK04a/mCGWlRRciJUQ6LrQhSD82XQBUXnmrEgIqHFBSX
	 wYBORTPFXfKS+DIKk3D88UHznulZsBKAyDwgY2DSkOHCHz906RXy9gsaccDllUPaNV
	 F4mEy7cUxfceopPhoOejcjXPNF89DBnySzI9Y0nTqRLqi/N2Tt1CMJf2ozZoKCOZkD
	 upQN+sTfti47xk0zHY+WPJ1krc0XI8YlGWj3luxO67eTQma3aVyvgTPfG3t77+iUrf
	 HTAETQ2E0VLkw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 07/25] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
Date: Sat, 21 Nov 2026 02:08:26 +0200
Message-ID: <20261121000844.1863324-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 908D2180006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: qnan63j6dh6pdyffbhzghx9qstobto9i
X-HE-Tag: 1795219766-798711
X-HE-Meta: U2FsdGVkX1+3gy8klK2z0J+vQLYmJU846LRy3QyRdYGjPCYwdnIw9u8ygE8fGYWBvvUCDRR3siW58TfIq5DjzW4F4vozYC+jY3aIn/jhjc7MfVV9spzevjjrV3bpWAsClTHDE/6G7N4H1hRNkfUZY/+jvSkqAocl0sqveWDqQTd4ir0jMkYNEdj2KOjtuC0lbut+39OvbAqURN8t6G39JwC4ZXHXegvbti22W2bMvFbbWn6rV0p1Pu6gimF7hXDo8F++0TymaBDpkUttOsL/MotVbNcwlhUkNi0ta1Gar3EnmtPSOE4qYsgEgflKCrYKRvPmDrqqub9IN1wRBXs6QtOXm8pFlIM2AF7U8QjNrXWRsfMpV3q6mohHTBI5c2jozkxAGMlkmd6gBrrqzCv0S2NUq5RrkT9DRiqamfsr1vFScY6U1EX8bei/YNZqUeTJzdCErM00DjZVjCglvGlo80y7NgbMh66xEIhtGcOvP/EZkhBfDcYun94/QXdJCNAra4l2CIaUTCZvcOZkU47VbdMk7D6HvoXrqq4DQ1AnHYDBTFBIR4AKAHyn1DnXTmH1EHtCECIdRhkNwr1vrD5qox22HE4zXmq8ER6I5ec07VKeMIkci18pxSxYu0W/LXPM2KdtSgwxJIgJGvgP80duhhHQpJPnMaziKETmHuiE5VFdfJW/lbgip/rnqXziR1YhFmdyuwk5mqvXZKFFCREK6wtgukwrEXO5HoVN5u3OQ15Mf0T7TlCtFQTcnga2WwyVwe/yQOePoZfKHKQRkHWoel6x0zg3dAIvprmIvJF2FT7SxhTAA/ORkvmN6HFsoJerec3UxL4U0thhdPQT59hmg02vHl/3vzbs8QWOX5rm6TZsrbueRvf++t19DCwxjcvA8BwyLRwGvZdS+DC85maSV9iBCmxSkn25DLb3Ol8kx/h49nmPMXdy4tvyBM67ecIosnLUgeRI7zWI3+IT+D2
 p3JARqEP
 bKuBaqq/leCoIV9hXbi2zy1FTZuEc1ywtFJM8YUJXuovtzjmReYVPtgX/mlb1FEgfzkOgyqWTJGBSFmRbD35vKQn8zIXTuN0+U3oMFiKV6uWuZqgzUFSoPJ1wNH/S9u2Oky4ho+H0mKgQPEWOWf3c026W1HiURBZ5dvC2csFSpETeN5BFsf6h0CgNPjwDXZHGVrrvcHS0EsSsTRNVJx1Aqn53jDACPouwXoo32njVryZlxh5pMa0u0exq0iayfjjxtOz76svnaYRv+g2d8JQrxywIHsXexH+lUPg4dlvzR3XTb3m+326TWO03SEfzCNEeYO73KGElibaXyTtlIMXVp+TjbLiLWc+0z09vWAEkQCV28dMF/ewEAjJ5rrznE/qi+mUJl59rgRAJyhEOgDG95DXbpwsZSU5+QVbt24BcTiXTtEcSzndxWlvSA6YYqCsPDY5mHbNotjWEy4Z92Pbs2rUv2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Unprivileged container managers cannot use open_tree(OPEN_TREE_CLONE) in
the host mount namespace because it requires may_mount() against the
caller's current mount namespace rather than the destination namespace.

Add MOVE_MOUNT_CLONE for use with MOVE_MOUNT_T_MNTNS so move_mount() can
recursively loopback-clone a path from the caller's mount namespace
directly into the target mount namespace file descriptor. Authorize the
operation against CAP_SYS_ADMIN in target_mnt_ns->user_ns, apply
CL_SLAVE | CL_COPY_UNBINDABLE when crossing user namespace boundaries,
and lock cross-user-namespace cloned subtrees with MNT_LOCKED inside
attach_recursive_mnt().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 106 +++++++++++++++++++++++++++----------
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 80 insertions(+), 29 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index b65f1fdd9281..1e7d776c0966 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2573,13 +2573,15 @@ enum mnt_tree_flags_t {
 	MNT_TREE_PROPAGATION = BIT(1),
 	MNT_TREE_MNTNS = BIT(2),
 	MNT_TREE_MNTNS_INIT = BIT(3),
+	MNT_TREE_CLONE = BIT(4),
 };
 
 /**
  * attach_recursive_mnt - attach a source mount tree
  * @source_mnt: mount tree to be attached
  * @dest:	the context for mounting at the place where the tree should go
- * @move_mntns:	whether @source_mnt is attached via MOVE_MOUNT_T_MNTNS
+ * @src_user_ns: owning user namespace of @source_mnt for MOVE_MOUNT_T_MNTNS,
+ *               or NULL
  *
  *  NOTE: in the table below explains the semantics when a source mount
  *  of a given type is attached to a destination mount of a given type.
@@ -2643,7 +2645,7 @@ enum mnt_tree_flags_t {
  */
 static int attach_recursive_mnt(struct mount *source_mnt,
 				const struct pinned_mountpoint *dest,
-				bool move_mntns)
+				struct user_namespace *src_user_ns)
 {
 	struct mount *dest_mnt = dest->parent;
 	struct mountpoint *dest_mp = dest->mp;
@@ -2652,7 +2654,6 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	struct user_namespace *user_ns = ns->user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
-	struct mnt_namespace *src_ns;
 	struct mount *child, *p;
 	struct mount *top;
 	struct hlist_node *n;
@@ -2670,13 +2671,12 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	 * the attaching task's mount namespace is authoritative, not
 	 * the creator of the detached tree.
 	 */
-	if (is_anon_ns(ns))
+	if (src_user_ns)
+		user_ns = src_user_ns;
+	else if (is_anon_ns(ns))
 		user_ns = current->nsproxy->mnt_ns->user_ns;
 	else
 		user_ns = ns->user_ns;
-	src_ns = moving ? NULL : source_mnt->mnt_ns;
-	if (move_mntns && src_ns)
-		user_ns = src_ns->user_ns;
 
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
@@ -2745,7 +2745,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		/* Notice when we are propagating across user namespaces */
 		if (child->mnt_parent->mnt_ns->user_ns != user_ns) {
 			lock_mnt_tree(child);
-			if ((move_mntns || is_anon_ns(ns)) &&
+			if ((src_user_ns || is_anon_ns(ns)) &&
 			    list_empty(&child->mnt_expire))
 				child->mnt.mnt_flags |= MNT_LOCKED;
 		}
@@ -2956,7 +2956,7 @@ static int graft_tree(struct mount *mnt, const struct pinned_mountpoint *mp)
 	      d_is_dir(mnt->mnt.mnt_root))
 		return -ENOTDIR;
 
-	return attach_recursive_mnt(mnt, mp, false);
+	return attach_recursive_mnt(mnt, mp, NULL);
 }
 
 static int may_change_propagation(const struct mount *m)
@@ -3799,29 +3799,27 @@ static int do_move_mount(const struct path *old_path,
 			 struct mnt_namespace *target_mnt_ns)
 {
 	struct mount *old = real_mount(old_path->mnt);
+	struct user_namespace *src_user_ns = NULL;
+	struct mount *cloned = NULL;
 	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
-	if (!path_mounted(old_path))
+	if (!(flags & MNT_TREE_CLONE) && !path_mounted(old_path))
 		return -EINVAL;
 
 	if (d_is_dir(new_path->dentry) != d_is_dir(old_path->dentry))
 		return -EINVAL;
 
+	if ((flags & MNT_TREE_CLONE) && mnt_ns_loop(old_path->dentry))
+		return -EINVAL;
+
 	LOCK_MOUNT_MAYBE_BENEATH(mp, new_path, beneath);
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
 	if (flags & MNT_TREE_MNTNS) {
-		u64 seq;
-
-		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns ||
-		    mp.parent->mnt_ns != target_mnt_ns)
-			return -EINVAL;
-		seq = old->mnt_ns->seq_origin;
-		if (seq && seq != target_mnt_ns->ns.ns_id &&
-		    seq != current->nsproxy->mnt_ns->ns.ns_id)
+		if (mp.parent->mnt_ns != target_mnt_ns)
 			return -EINVAL;
 		if (flags & MNT_TREE_MNTNS_INIT) {
 			if (mp.parent != target_mnt_ns->root)
@@ -3835,6 +3833,35 @@ static int do_move_mount(const struct path *old_path,
 			if (m == target_mnt_ns->root)
 				return beneath ? -EINVAL : -EBUSY;
 		}
+		if (flags & MNT_TREE_CLONE) {
+			unsigned int copy_flags;
+
+			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns)
+				return -EINVAL;
+			src_user_ns = old->mnt_ns->user_ns;
+			copy_flags = (target_mnt_ns->user_ns != src_user_ns) ?
+				     (CL_SLAVE | CL_COPY_UNBINDABLE) :
+				     CL_COPY_MNT_NS_FILE;
+			cloned = __do_loopback(old_path, true, copy_flags);
+			if (IS_ERR(cloned))
+				return PTR_ERR(cloned);
+			old = cloned;
+			if (d_is_symlink(old->mnt.mnt_root)) {
+				err = -EINVAL;
+				goto out_cloned;
+			}
+		} else {
+			u64 seq;
+
+			if (!anon_ns_root(old) ||
+			    old->mnt_ns == mp.parent->mnt_ns)
+				return -EINVAL;
+			seq = old->mnt_ns->seq_origin;
+			if (seq && seq != target_mnt_ns->ns.ns_id &&
+			    seq != current->nsproxy->mnt_ns->ns.ns_id)
+				return -EINVAL;
+			src_user_ns = old->mnt_ns->user_ns;
+		}
 	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
@@ -3874,23 +3901,36 @@ static int do_move_mount(const struct path *old_path,
 			over = mp.parent->overmount;
 		err = can_move_mount_beneath(old, over, &mp);
 		if (err)
-			return err;
+			goto out_cloned;
 	}
 
 	/*
 	 * Don't move a mount tree containing unbindable mounts to a destination
 	 * mount which is shared.
 	 */
-	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old))
-		return -EINVAL;
+	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old)) {
+		err = -EINVAL;
+		goto out_cloned;
+	}
 	dest_mnt_ns = is_anon_ns(mp.parent->mnt_ns) ?
 		      current->nsproxy->mnt_ns : mp.parent->mnt_ns;
-	if (!check_for_nsfs_mounts(old, dest_mnt_ns))
-		return -ELOOP;
-	if (mount_is_ancestor(old, mp.parent))
-		return -ELOOP;
+	if (!check_for_nsfs_mounts(old, dest_mnt_ns)) {
+		err = -ELOOP;
+		goto out_cloned;
+	}
+	if (mount_is_ancestor(old, mp.parent)) {
+		err = -ELOOP;
+		goto out_cloned;
+	}
 
-	return attach_recursive_mnt(old, &mp, flags & MNT_TREE_MNTNS);
+	err = attach_recursive_mnt(old, &mp, src_user_ns);
+out_cloned:
+	if (err && cloned) {
+		lock_mount_hash();
+		umount_tree(cloned, UMOUNT_SYNC);
+		unlock_mount_hash();
+	}
+	return err;
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -4816,8 +4856,8 @@ static int lookup_move_mount_from(int from_dfd,
 /**
  * DOC: MOVE_MOUNT_T_MNTNS
  *
- * ``MOVE_MOUNT_T_MNTNS`` installs detached anonymous mount trees into a target
- * mount namespace ``nsfs`` file descriptor supplied as ``to_dfd``:
+ * ``MOVE_MOUNT_T_MNTNS`` installs mount trees into a target mount namespace
+ * ``nsfs`` file descriptor supplied as ``to_dfd``:
  *
  * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
  *    ``nullfs`` root of an empty mount namespace at most once.
@@ -4825,6 +4865,11 @@ static int lookup_move_mount_from(int from_dfd,
  * 2. Relative ``to_pathname`` values resolve beneath the live root of the
  *    target mount namespace.
  *
+ * 3. Combining ``MOVE_MOUNT_CLONE`` with ``MOVE_MOUNT_T_MNTNS`` recursively
+ *    loopback-clones ``from_pathname`` from the caller's mount namespace into
+ *    ``to_dfd`` without requiring ``OPEN_TREE_CLONE`` or ``may_mount()`` in
+ *    the caller's own mount namespace.
+ *
  * Capability is checked against ``CAP_SYS_ADMIN`` in the target mount
  * namespace's owning user namespace, and source trees crossing user namespace
  * boundaries are locked with ``MNT_LOCKED`` and locked mount flags.
@@ -4926,12 +4971,17 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & ~MOVE_MOUNT__MASK)
 		return -EINVAL;
 
+	if ((flags & MOVE_MOUNT_CLONE) && !(flags & MOVE_MOUNT_T_MNTNS))
+		return -EINVAL;
+
 	if ((flags & (MOVE_MOUNT_BENEATH | MOVE_MOUNT_SET_GROUP)) ==
 	    (MOVE_MOUNT_BENEATH | MOVE_MOUNT_SET_GROUP))
 		return -EINVAL;
 
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
+	if (flags & MOVE_MOUNT_CLONE)
+		mflags |= MNT_TREE_CLONE;
 
 	if (unlikely(flags & MOVE_MOUNT_T_MNTNS)) {
 		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index 7d413418426a..cb4f7175db02 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -78,7 +78,8 @@
 #define MOVE_MOUNT_T_MNTNS		0x00000080 /* Resolve to_dfd as mntns fd */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x000003f7
+#define MOVE_MOUNT_CLONE		0x00000400 /* Recursively clone from path */
+#define MOVE_MOUNT__MASK		0x000007f7
 
 /*
  * fsopen() flags.
-- 
2.47.3


