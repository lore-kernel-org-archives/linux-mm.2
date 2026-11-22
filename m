Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B873B606A684
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJ2IQo+F
Received: by kanga.kvack.org (Postfix)
	id 4C8426B05B8; Sat, 21 Nov 2026 20:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0246B05BA; Sat, 21 Nov 2026 20:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2526B05BB; Sat, 21 Nov 2026 20:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0459C6B05B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 779FD120631
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:49 +0000 (UTC)
X-FDA: 85460995578.02.9AFF9CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id BE23F140004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJ2IQo+F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310327;
	b=UQA9KfcPw1zQI5Lrd4zOHgq+S3HUVfzpbcRs2vfu9nGnT8Qw9iT5R40EKArVwG2Ao1lY2T
	QMsuFx6UqAQvsbNkkeDWWezSxfHxjEHu79qVrI5bIplLRkLbW65JAFhdyEDOhIGWKCko3w
	rJaUicdc+shGfenH5GxqKV2r7fY7prE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mm/aE/uZ/LZ5IsRqL1/fzIJ4sZW+7y9KuMcaDkHtn6s=;
	b=NvoI87Ab9FybyjGv42rRqerSkdhR4zVnWWwg7vvxMVkVGpxfeAzrN5FgYVv1iVBzL+iSZd
	Y29zh6pamuTz63QGhIUParU9lAapFKjEnYxqyldqIv6exhNtpAUBaboyyR4obwwryh+3+r
	FwyjBcC6NwdL8wCGIs/yY1jUH10Zcnw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJ2IQo+F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E0E03430D0;
	Sun, 22 Nov 2026 01:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 248D51F000C6;
	Sun, 22 Nov 2026 01:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310326;
	bh=Mm/aE/uZ/LZ5IsRqL1/fzIJ4sZW+7y9KuMcaDkHtn6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJ2IQo+FLk/KN7nUomepZzEekGrM+qWpWwiuS10TP7U+kio3WgFFa/vcj53OtaNxE
	 qQdz/1WFpDD+iA45IuwGsn00pCoBSlETxHq/jwHp7AJSAfmMatUJDV+sYEyCWCHnOV
	 rylvdRIl+mLHxYG2XpduRYf+0Ic8UwtIGTdBUVBauMBwpOHbmZQWUwslfYQRiAAVY+
	 LC5v7MQxx/A1wDUfWuGVh+ejaQ9rQ2B4fR5LVDSZ88XJNwzP18Tr082jk6rsAhpzHF
	 Y42A+5xUh99xkKBLVgts0kWweMgM+8A1O37ABVBPGDbCrafYIotBh8DlwVUPY019ni
	 x5CAGcaA9r1eg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 07/26] mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
Date: Sun, 22 Nov 2026 03:17:50 +0200
Message-ID: <20261122011809.2667684-8-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE23F140004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: xrx6deg7ixbazx6dwtamazqq6sxyzixg
X-HE-Tag: 1795310327-684555
X-HE-Meta: U2FsdGVkX18h37OEU9K40DRm5WXOko+A9z3x5xRkQDTaB/dBP5OlhtdENyxQq3RbqMpHFvbREu2TEkn0Gy+MTmwtjZQ6QefF9BgNq6xyoVUKSPEqHml5/hjKUSI8IkogZfE1ukzPxwidGWXKDG9gZjdxSGPh2QN975mrlQPD4OTHZkcn+tKhNOXI21kQaneYzuspHDzaUnzSu6GPPavbgUjCnLBAU8MIVqVF8VHBrs3evUviQTLF2YsUBJs7EKizJjIta2+N9jGuJJ6Gw0MQ6N85TEiyJ1SQwmyE2RyIybHtkPi+e8kRM4rdNSzRxMELoIVzNjl39uvqzJb5fqyY7ZQLkWEj4ftwoRBICI9iqx1rTLmMrRRzakRANYdL79kJUf1kO8Q4tTYb8aEqGYdc5eGICb63ImggdIqtX8ZdnZpvL2uY2yz9cnIqFw54YUjmtKhmZoT+KMm0K3/yBAphEKya3BHHa9+3x4H0D9LhkuDKPsskelN+MYWvVoWuDRaFXvAmqnZAQgiQXnzCgMUu7QqaaZFFKG/eBoSYQhMvWD0m/2e+4NnHT3WRFKhwledjimloOkf8r8jUH3bw4oWl5RlKLylzn/JW9LGM0SyPr+sfEt1NXMvEwZGVrvWsdlrolGxzptdRT/6a0oMjSOgaKQmbUNJxKl/teP1ahWznQnWagWr8r8Aksdgu5jJNUyRPcFJ9Bsf1ZNVO6piMYBXImP8bEYiwlrlKve0C32DB3wbkMpS8ALRjxsLJYxpLJbGxfDnQDUE0o94/WjtN0rYl9tBlc4aCwrHYj6WEJj88AbKqapNEGnpkM/VLAJUjOeCu4uW0IJTRYktjpCOKvMeIGa8mwjgOCjqYo6A+qGOnoTAfVf57zNLQE77Ft3CI5F49cqppjLBDpNgq0l8h3d2OxsHhomzQlpenZic9wbSW1qJNJKh2zM1xQSyOfiGb+CfzlyCIP61WCahuS7IRpN9
 VDX6supB
 yll6lOTz2ARapeRk44l/4cMLu81jTDT5ui9/k0vh3p+K2CEL4gawyRBdtH5sBVoySYp/Y4ZSpSUvCqtZJGcseL4EIII/eTEJYHbWGvtZaU/soGXz7eJzZ6AtdCD3WpQ9HEAVSRPkBmifO0p0ZXT0c/vWI11Dwk/zsYqwv6FehrlrScWXeIp2cuXImcQpFkMYfdni52PuHRfeUEImz2F9HNW9uPrDXwHncgQNwp8sGcoqD2zziJBfrWVu7/3lfEnJg8XzLm2s3m88+fB1OldHDcp0YHvyClBVkslsfqsLa8cFUq7m+D6rcEDyaxnSzLA14RnCtkwdTeA3dr4A/KJxVHiYlRQ3DOFEuEne7pZDWpoUWlhqz0Sk9bEZ8x1zN9QuydzoegVyp+ucogad0QAdOIeEhvJ0bjmjrT+d8ZcLWJBWnPQ8tv8IyPzQD+DDT8i5R+EoKgn+MYMIXHxc3U1a8s/pnhg==
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
 fs/namespace.c             | 91 +++++++++++++++++++++++++++++---------
 include/uapi/linux/mount.h |  3 +-
 2 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e21dd876dde3..57b4e8755fe9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2573,6 +2573,7 @@ enum mnt_tree_flags_t {
 	MNT_TREE_PROPAGATION = BIT(1),
 	MNT_TREE_MNTNS = BIT(2),
 	MNT_TREE_MNTNS_INIT = BIT(3),
+	MNT_TREE_CLONE = BIT(4),
 };
 
 /**
@@ -3803,31 +3804,28 @@ static int do_move_mount(const struct path *old_path,
 {
 	struct mount *old = real_mount(old_path->mnt);
 	struct user_namespace *src_user_ns = NULL;
+	struct mount *cloned = NULL;
 	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
-	if (!path_mounted(old_path))
+	if (!(flags & MNT_TREE_CLONE) && !path_mounted(old_path))
 		return -EINVAL;
 
 	if (d_is_dir(new_path->dentry) != d_is_dir(old_path->dentry))
 		return -EINVAL;
 
+	if ((flags & MNT_TREE_CLONE) &&
+	    mnt_ns_loop_target(old_path->dentry, target_mnt_ns))
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
-		src_user_ns = old->mnt_ns->user_ns;
 		if (flags & MNT_TREE_MNTNS_INIT) {
 			if (mp.parent != target_mnt_ns->root)
 				return -EBUSY;
@@ -3840,6 +3838,36 @@ static int do_move_mount(const struct path *old_path,
 			if (m == target_mnt_ns->root)
 				return beneath ? -EINVAL : -EBUSY;
 		}
+		if (flags & MNT_TREE_CLONE) {
+			unsigned int copy_flags;
+
+			if (!check_mnt(old) || old->mnt_ns == target_mnt_ns ||
+			    (old->mnt.mnt_sb->s_flags & SB_NOUSER))
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
@@ -3879,23 +3907,36 @@ static int do_move_mount(const struct path *old_path,
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
 
-	return attach_recursive_mnt(old, &mp, src_user_ns);
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
@@ -4821,8 +4862,8 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4830,6 +4871,11 @@ static int lookup_move_mount_from(int from_dfd,
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
@@ -4931,12 +4977,17 @@ SYSCALL_DEFINE5(move_mount,
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


