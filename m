Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D10606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nv82ikRn
Received: by kanga.kvack.org (Postfix)
	id 1738B6B05C8; Tue, 17 Nov 2026 18:14:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A0D6B05C9; Tue, 17 Nov 2026 18:14:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F062B6B05CA; Tue, 17 Nov 2026 18:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4A176B05C8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FA69405F7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:48 +0000 (UTC)
X-FDA: 85446167856.29.DA99B29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7651120008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nv82ikRn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6n34UB4IGYmqbxIeyu3C92WUyY/otUHn2KouidPimtk=;
	b=gj6svqguTKwmA5w6PyUSCDYIjOSXXlCcrSj3c0ZrrYYLAIoiU6KXZael3IE6xT9JN/pKdv
	/+ZvO2S3TsiU8AnZZ7Xocy+o4Q5J8cpd/JsBsjG6FfgpYyZpO3G9gs4Hp7FazmaIgOpqda
	p6CZ2jZ7R9wkMQ09Wfunk3HfVx4n6aI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nv82ikRn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957286;
	b=R7SwHAlRNCHARfsArcCx6O29AKarn4Eha5U7/R0POcFrKGHH49z7NyllNaipZGq977mBNQ
	LI6fZ2xqfGxOgkUvBaKN7FLWUCqQyVPSgbD4u5kTs/X4lCR2sNR1Wrv/JZn1MDS18kXv91
	wl/o0LsXKwZK35Zzzwz0NDe/dmLiy80=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id BC78A41720;
	Tue, 17 Nov 2026 23:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE2621F00923;
	Tue, 17 Nov 2026 23:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957285;
	bh=6n34UB4IGYmqbxIeyu3C92WUyY/otUHn2KouidPimtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nv82ikRni3pWvdz/v3Vdo+m1Anuew84FJcPoalRIkbDhe6E5zey3rFphBih5HmEi1
	 Jdj85W4jMNmUEEYeQvn10vCL9w84rrIIQWOvHio86WhASVJSe7JhRk/BhZoA2caOMn
	 BcQCQ1kOtz3EfRvr5RBUjeT8YZUorLG1SwZ24dQylM7CUrkAohYxDY1kC6mLaVAIpE
	 njZnDZ9/qWUlt4Ax/p64lqw9yFXGnqjVuiOMmxjXfoqa8EuMKYBfUAzEHntS7aYcqC
	 3KEhBzC1vPDiFvp4mnnuTvw6gT7uuc39cnywJh8Ozpp8k+cLCTOr5c8ebROGPJKW67
	 NkI6qRuasf7jA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 09/13] fs: Support installing rootns mount trees via move_mount()
Date: Wed, 18 Nov 2026 01:13:48 +0200
Message-ID: <20261117231352.3816603-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7651120008
X-Stat-Signature: wc7zbigbodctbw7w45go5466hots9nxx
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794957286-122796
X-HE-Meta: U2FsdGVkX19wFot+nclsMio6riU5rCbUOSkMUZ5dQBUVE2RrcpG4iu2f1SZhQt0l+GQoLTogtnQdululn4gaSzRFiG4yGHF7BrlGKwcmt4eC6shJ/sJefbWGDFuShAn5WEJQvSQbZubmy7MIUUH91FFW/3aHkXBO/DudaAkqmVRPFUKqBeqXZtpzT2CnIqzClWUfua/ryNShO7tqJhgwgY0BrS+wt2j387kRC23mkUouwBfxHJ1JhHxIrZ0umtT7oQ7znh/R96V5XR9FwB0j3hl2yH4ALEyuCrfeMjz9V9q9Mz//QZVVDM5jRgNoRqmO0piJzWnErKjFUx9GGEOp/ogfQeBnFkvgC9rZVjBItGKY4Rp8s2/qENRVky2DKZRB5NvInoeHOLQxEPqNbzvZhkSPgfcadpOoe+HpqrzJspF2VqtyG9CsZZUFtGeCPO49qdNQRueevflcwMDRtxiRVaiJVoA2CulVZBFCs4ECwR4Z8xciW7UjskTkNVtGICLkqIxtAbPj9QuNJ5xnacPPiEhOBFyDZK9m5QfE+And58Nqf4asvFYzdBoS8rVKCIuf2uj8/7InCvhH7Cg7G9sTHKeIQ5ujperlGQ6KjUtxTUr2n0tRpKEJR60a+XMRBQAKPO87UH3twZR0YKd1ecGwFyCpGcwz9tNxZkQmDkYUoFZrpuwSwNS7Tap8RviHJmX+oKttZUGzw9ojw5L/rl9QH5NSZNGtCbcp1tRgvtrnAHuxdBUJWxl6CAXzIYtdHCoWM+Btde99eMV+iy1aXkjZG9Ixno9pQAIZH4OCM4VV4dsRrciZHolCdD/KDKgR1QAFCwehkk6QDH2K5YZRhVZ0fJLn0AaAMpZ5PlBmyBH3AyljILrz1JDlzHAx7gAHDTqv2xH6r9RP5/K0Vn9cr86c+qew8cg/WZ+xUQpjSgN4DhgmmlDkECp2w0I5MS9R+Pu/j75kkV9vxU8i7O2Amc1
 9bVE6bPm
 zIp7P6lGJHDV8KtgLM0mDm5MRsIaITFHAu9JS4Mis01bjuJrNwxz6ha0G6PjNMjRf/83aL4Ch7C761JCPsxQCXbXHOiypGePp7TDTH0zwKH2icDMkoiVoz+rEe1UwXo/Z5PoAyyWRXdTaUqTPJbXl/zkhvV8FxbDh7458XR5N1R8jkT96WksUl56+ZTYyiVWpGIPzJclDsguqq+HexZofoonfwLj/AOrj0oEIuyFlJaQpYH54rtX44pOaD51hmLDE6FPm+yFGGhNOwAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A newly created rootns starts with an empty nullfs-rooted mount
namespace, and move_mount() only resolves target paths against the
caller's own filesystem view.

Add MOVE_MOUNT_T_ROOTNS_ROOT to populate a rootns mount tree through its
file descriptor before or after entry. Installing "/" attaches a
detached anonymous mount tree onto the nullfs root of the rootns mount
namespace once and transitions the rootns to ROOTNS_READY; relative
target paths attach anonymous mounts underneath the installed rootns
root while verifying the destination mount namespace.

Allocate fsmount() anonymous namespaces in fc->user_ns, check target
user namespace CAP_SYS_ADMIN for MOVE_MOUNT_T_ROOTNS_ROOT instead of
caller may_mount(), and lock moved mount trees when crossing user
namespace boundaries.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 178 ++++++++++++++++++++++++++++++++-----
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 157 insertions(+), 24 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index aecd05ac0170..f8c96e4d13ee 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -34,6 +34,7 @@
 #include <linux/mnt_idmapping.h>
 #include <linux/pidfs.h>
 #include <linux/nstree.h>
+#include <linux/rootns.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -2564,6 +2565,8 @@ int count_mounts(struct mnt_namespace *ns, struct mount *mnt)
 enum mnt_tree_flags_t {
 	MNT_TREE_BENEATH = BIT(0),
 	MNT_TREE_PROPAGATION = BIT(1),
+	MNT_TREE_ROOTNS = BIT(2),
+	MNT_TREE_ROOTNS_INIT = BIT(3),
 };
 
 /**
@@ -3781,6 +3784,7 @@ static int do_move_mount(const struct path *old_path,
 	struct mount *old = real_mount(old_path->mnt);
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
+	bool lock_tree;
 
 	if (!path_mounted(old_path))
 		return -EINVAL;
@@ -3792,7 +3796,13 @@ static int do_move_mount(const struct path *old_path,
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
-	if (check_mnt(old)) {
+	if (flags & MNT_TREE_ROOTNS) {
+		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns)
+			return -EINVAL;
+		if ((flags & MNT_TREE_ROOTNS_INIT) &&
+		    mp.parent != real_mount(new_path->mnt))
+			return -EBUSY;
+	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
 		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
@@ -3845,7 +3855,16 @@ static int do_move_mount(const struct path *old_path,
 	if (mount_is_ancestor(old, mp.parent))
 		return -ELOOP;
 
-	return attach_recursive_mnt(old, &mp);
+	lock_tree = (flags & MNT_TREE_ROOTNS) &&
+		    old->mnt_ns->user_ns != mp.parent->mnt_ns->user_ns;
+	err = attach_recursive_mnt(old, &mp);
+	if (!err && lock_tree) {
+		scoped_guard(mount_writer) {
+			lock_mnt_tree(old);
+			old->mnt.mnt_flags |= MNT_LOCKED;
+		}
+	}
+	return err;
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -4699,7 +4718,7 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(fc->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
 	mnt = real_mount(new_path.mnt);
@@ -4739,6 +4758,129 @@ static inline int vfs_move_mount(const struct path *from_path,
 	return do_move_mount(from_path, to_path, mflags);
 }
 
+static int lookup_move_mount_from(int from_dfd,
+				  const char __user *from_pathname,
+				  unsigned int flags, struct path *from_path)
+{
+	unsigned int uflags = 0;
+	unsigned int lflags = 0;
+
+	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
+		uflags = AT_EMPTY_PATH;
+
+	CLASS(filename_maybe_null, from_name)(from_pathname, uflags);
+	if (!from_name && from_dfd >= 0) {
+		CLASS(fd_raw, f_from)(from_dfd);
+		if (fd_empty(f_from))
+			return -EBADF;
+
+		*from_path = fd_file(f_from)->f_path;
+		path_get(from_path);
+		return 0;
+	}
+
+	if (flags & MOVE_MOUNT_F_SYMLINKS)
+		lflags |= LOOKUP_FOLLOW;
+	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)
+		lflags |= LOOKUP_AUTOMOUNT;
+	return filename_lookup(from_dfd, from_name, lflags, from_path, NULL);
+}
+
+/**
+ * DOC: MOVE_MOUNT_T_ROOTNS_ROOT
+ *
+ * ``MOVE_MOUNT_T_ROOTNS_ROOT`` installs detached anonymous mount trees into a
+ * target ``rootns`` control fd supplied as ``to_dfd``:
+ *
+ * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
+ *    ``nullfs`` root of the ``rootns`` mount namespace at most once and
+ *    transitions the ``rootns`` to ``ROOTNS_READY``.
+ *
+ * 2. Relative ``to_pathname`` values resolve beneath the installed ``rootns``
+ *    root inside the ``rootns`` mount namespace.
+ *
+ * Capability is checked against ``CAP_SYS_ADMIN`` in the target ``rootns``
+ * user namespace, and source trees crossing user namespace boundaries are
+ * locked with ``MNT_LOCKED`` and locked mount flags.
+ */
+static int move_mount_rootns(int from_dfd, const char __user *from_pathname,
+			     int to_dfd, const char __user *to_pathname,
+			     unsigned int flags, enum mnt_tree_flags_t mflags)
+{
+	struct path from_path __free(path_put) = {};
+	struct path to_path __free(path_put) = {};
+	struct mnt_namespace *rootns_mnt_ns;
+	unsigned int lflags;
+	struct rootns *rootns;
+	bool is_root;
+	int ret;
+
+	CLASS(filename_maybe_null, to_name)(to_pathname, AT_EMPTY_PATH);
+	if (IS_ERR(to_name))
+		return PTR_ERR(to_name);
+	if (!to_name)
+		return -EINVAL;
+
+	CLASS(fd, f_rootns)(to_dfd);
+	if (fd_empty(f_rootns))
+		return -EBADF;
+	if (!is_rootns_file(fd_file(f_rootns)))
+		return -EINVAL;
+
+	rootns = fd_file(f_rootns)->private_data;
+	if (!ns_capable(rootns->cred->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	rootns_mnt_ns = rootns->ns->mnt_ns;
+	is_root = to_name->name[0] == '/' && to_name->name[1] == '\0';
+	if (is_root) {
+		if (flags & MOVE_MOUNT_BENEATH)
+			return -EINVAL;
+		if (READ_ONCE(rootns->state) != ROOTNS_EMPTY)
+			return -EBUSY;
+
+		to_path.mnt = mntget(&rootns_mnt_ns->root->mnt);
+		to_path.dentry = dget(rootns_mnt_ns->root->mnt.mnt_root);
+		mflags |= MNT_TREE_ROOTNS_INIT;
+	} else {
+		if (to_name->name[0] == '/')
+			return -EINVAL;
+
+		scoped_guard(spinlock, &rootns->lock) {
+			if (rootns->state == ROOTNS_EMPTY)
+				return -ENOENT;
+		}
+
+		lflags = 0;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
+		ret = filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
+				      &rootns->root);
+		if (ret)
+			return ret;
+		if (real_mount(to_path.mnt)->mnt_ns != rootns_mnt_ns)
+			return -EINVAL;
+	}
+
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
+	if (ret)
+		return ret;
+
+	ret = vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_ROOTNS);
+	if (!ret && is_root) {
+		scoped_guard(spinlock, &rootns->lock) {
+			path_get(&from_path);
+			rootns->root = from_path;
+			WRITE_ONCE(rootns->state, ROOTNS_READY);
+		}
+	}
+
+	return ret;
+}
+
 /*
  * Move a mount from one place to another.  In combination with
  * fsopen()/fsmount() this is used to install a new mount and in combination
@@ -4758,7 +4900,7 @@ SYSCALL_DEFINE5(move_mount,
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
 
-	if (!may_mount())
+	if (!(flags & MOVE_MOUNT_T_ROOTNS_ROOT) && !may_mount())
 		return -EPERM;
 
 	if (flags & ~MOVE_MOUNT__MASK)
@@ -4771,6 +4913,13 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
 
+	if (unlikely(flags & MOVE_MOUNT_T_ROOTNS_ROOT)) {
+		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
+			return -EINVAL;
+		return move_mount_rootns(from_dfd, from_pathname,
+					 to_dfd, to_pathname, flags, mflags);
+	}
+
 	uflags = 0;
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
@@ -4794,25 +4943,8 @@ SYSCALL_DEFINE5(move_mount,
 			return ret;
 	}
 
-	uflags = 0;
-	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
-		uflags = AT_EMPTY_PATH;
-
-	CLASS(filename_maybe_null,from_name)(from_pathname, uflags);
-	if (!from_name && from_dfd >= 0) {
-		CLASS(fd_raw, f_from)(from_dfd);
-		if (fd_empty(f_from))
-			return -EBADF;
-
-		return vfs_move_mount(&fd_file(f_from)->f_path, &to_path, mflags);
-	}
-
-	lflags = 0;
-	if (flags & MOVE_MOUNT_F_SYMLINKS)
-		lflags |= LOOKUP_FOLLOW;
-	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)
-		lflags |= LOOKUP_AUTOMOUNT;
-	ret = filename_lookup(from_dfd, from_name, lflags, &from_path, NULL);
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
 	if (ret)
 		return ret;
 
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index cb55cfcfc92e..7224a43af51d 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -75,9 +75,10 @@
 #define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
 #define MOVE_MOUNT_T_AUTOMOUNTS		0x00000020 /* Follow automounts on to path */
 #define MOVE_MOUNT_T_EMPTY_PATH		0x00000040 /* Empty to path permitted */
+#define MOVE_MOUNT_T_ROOTNS_ROOT	0x00000080 /* Set as rootns root */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x00000377
+#define MOVE_MOUNT__MASK		0x000003f7
 
 /*
  * fsopen() flags.
-- 
2.47.3


