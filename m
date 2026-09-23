Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC44C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26B856B0093; Wed, 23 Sep 2026 18:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE336B0095; Wed, 23 Sep 2026 18:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BDCD6B0096; Wed, 23 Sep 2026 18:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF7AC6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:44:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A72B120178
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:30 +0000 (UTC)
X-FDA: 85246507500.12.83AFBC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 797CEC0002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:44:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pa/cjCtO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790203468;
	b=Cpsw5+1S46T5/vx8OMMX62IBcBK/Ru7ILsuNNLBBWAWUJOzKCiKAauhjD40QtZw+sd1f56
	7o0Xrhr1rURRAkc7OnOUtvOWMxRjXf3soDLLijf1YqiUTZL5Ld+ZDAM9UEa+DakcgbD+Sa
	IygYJoGuv7KK7cpp2ZCtjy9oTgq161A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pa/cjCtO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790203468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qvuMFxeBj+B+G3C9EN8sSVcZBEZuVQAHrFO4Xty0ZA=;
	b=CP9HQechMwnrena7SPJNsoK5RTHDJLviLj1IMf8yIn1QL05eDg9Ga8I4GSfuu1B5JUyRKE
	nrL/cyh6JdstiTVelZK7Zu6XYzpHHFZepUi4Vxori81haL+gD2Jx1J3ONdz9rnasqMRo23
	P72fTYGwTeHlikQWdGQ3mJRRyIog1JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AE1D60209;
	Wed, 23 Sep 2026 22:44:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5BB1F00893;
	Wed, 23 Sep 2026 22:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790203467;
	bh=7qvuMFxeBj+B+G3C9EN8sSVcZBEZuVQAHrFO4Xty0ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pa/cjCtODH8tQvSaIgT1T1D3gbx8C2FVjR5J83eGcAOvlSe2xloUgJBbPpAsjxZ7U
	 Ad5qy5KJDhE5OQLNeMDHo41xi0JyCwQ0AeUqJ+KkpKTkme/G4wt58b4+AOzFI0TTZ6
	 EIf1UQkvhx+MgN9o5eo+YOxdtusXX0Sc4xrCDYkHvKjnE+AJ1hd4UX8QoptrbXJcYF
	 QgAdlDAHeP6/PD8OmoJdxomH7kvsTd24Dmmxcz0Eku56bSPwHwK6VvraMiBeMOnavh
	 wge2I68bX0Nis0ZFQJl9JC1FpuPxVxJDheQkHVuwwVH/6N6WdEX8CKdF0ce+RCcK60
	 E1F0cm+jUc67A==
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
Subject: [RFC PATCH 3/6] fs/namespace: Add vfs_open_detached_mount()
Date: Thu, 24 Sep 2026 00:44:02 +0200
Message-ID: <20260923224408.3745689-4-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.0.rc1.310.g51773c2048-goog
In-Reply-To: <20260923224408.3745689-1-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: d1dyxeqjx3mnkn9n738utkesdw3yzjsa
X-Rspam-User: 
X-Rspamd-Queue-Id: 797CEC0002
X-HE-Tag: 1790203468-909272
X-HE-Meta: U2FsdGVkX1+IiJVwg0OArlN3K744dJVUlVwJWmUCzoaRBdqKLT6BOHvahPWKuIR5+iKQVsTmk4kTS1LHC5jTQOy6J2ybeIZl6UGJVT8zEpi+fpXmkQsyVevD3FJlzFWirYlWolbsrwokIpB4ZsnT9GcxisyP8h3BzsWS8rlTJTM0dTUH8Aqp74plRj85+je1Ma2W5Qvi9FFUslfAjECDhzbU7ASK4TLTH9P9IW6iuppZRFDenmkiYzCyuu5+19oAakkpXSmw8Xu/wBamG1JSiB7G7f71L6MsvVdz7Nd5MvmMJcUAUbeTs0ieA9G4Wvje+qkbUOojK4Kb7B+XJ9EVA+KXUpr3C2YbSZqHCP39ajhJD2rKRumsLwRG+P1Pd9w0WkHJ69b8jDfRcWKGFCNWfSJAkfYZtnT1G3D4X9TUkilhabkx3n6YxOE1v5JJ59VIu92+qMVqIFLPuOz5xjTsZsyfFb08MZusoo7nrTJYd61Itqu+ItcTgcpssUxk1aijRGEUZ6JVnIsMSGIjy4sIAV5BFIPC4ruwf0AH7/D06/OiuVk3VvGnvDc9nDwmwSsNLWQCn14RimBfH+C/LEIAvVRMCp+fEsQrd8WsymhdcCrRfkrZNgh+zdPN582fKQBc+aVe4yeBr3PC574puUq+lYmBmUznS1wTp+Vpc0gR6ataZtHKmj3xDLW/LWaukggsIzHNs3xAaUocNfXUGnHYZZ+1TvCaNgjvTG/vTf4PRjI3vj0STckEfikKsJj9fXEUbnyKU4eCQ8ghRNljjDMGqB05sf5se695AwTNUd8zgKK0evRgzZJdIFjE/CMlqOE4xu6ZAau8s9gsn9wZ7w9aMwUy18islWOts5Vp88aLU99g4/riyr9krDcDJhDsO60S5kqcC7WABH1a/q1nJKmBjpADJhiyVFYcB3zmWVcsTSq2JtViL1pvTFnyvaousTIqnCxEG1jPLRQlhOGc+t0
 Vf8Kh8PL
 KRzzcOXgPUx6VB3aY4qce5bzAQNeCO8eoVf7xsqdw5UqDkeJLdyPwSyskqg4qSlkdFvx9sWu8IAK0WT9lPMp+F0gjI3UdwHftEqAWcKrTeKenRMGwFuh7DSBs81bgKpitcA8mD2n9MxKofGlPW4zjVqf6dWhjbgvWLZJicv+INHOuK7iApt4nyw+p1ngcpggd6X7yHlh0Q6mcUNLVDlHYPv+XBlZFcXRU1c6I6l3y61bjkE9yVlCto7Ux+nt6N/o3VnFJoC66lKuyqxigQeAJsRF4mXQLAAaHKNiL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

A mount created in the kernel by fc_mount() and friends has mnt_ns ==
NULL, and userspace cannot attach such a mount anywhere.

The missing step is the tail of fsmount(2): allocate an anonymous mount
namespace, insert the mount as its root, open an O_PATH file on it and
mark the file FMODE_NEED_UNMOUNT so the mount is torn down on the final
fput() if it is never attached. The anonymous namespace is what gives
the detached mount an owning user namespace for permission checks, a
place for child mounts, and a lifetime tied to the file.

None of the pieces are reachable from outside fs/namespace.c:
alloc_mnt_ns() and mnt_add_to_ns() are static, and the sequence is
already open-coded twice, in fsmount(2) and in open_detached_copy().

Factor it out so an in-kernel creator of a mount can hand it to
userspace. The Live Update Orchestrator needs this to return a tmpfs it
re-created from state preserved across a kexec; userspace attaches the
resulting fd with move_mount(), exactly as it would an fsmount(2) fd.

Only add the helper. Converting fsmount() and open_detached_copy() to it
is an obvious follow-up but is left out to keep this small. It is not
exported, as the only caller is built in.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

---

This patch is entirely LLM generated. It works, but I am not competent
enough with VFS APIs to even guess if it is sensible. So please don't
take it too seriously. It makes the RFC testable, but for a proper
series I will do a lot more homework to make sure this doesn't
completely abuse VFS APIs.
---
 fs/namespace.c        | 59 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |  1 +
 2 files changed, 60 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1ecd96c918b3..5e7ba2b61dd9 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4435,6 +4435,65 @@ static unsigned int attr_flags_to_mnt_flags(u64 attr_flags)
 	return mnt_flags;
 }
 
+/**
+ * vfs_open_detached_mount - Publish a new mount as a detached mount file.
+ * @mnt: The mount to publish. Must not be attached to a mount namespace. The
+ *       caller's reference is consumed on success.
+ *
+ * Places @mnt into a new anonymous mount namespace and opens an O_PATH file on
+ * its root, marked FMODE_NEED_UNMOUNT. This is what fsmount(2) hands back, and
+ * the resulting file behaves the same way: it can be attached to the
+ * filesystem hierarchy with
+ *
+ *	move_mount(fd, "", dfd, path, MOVE_MOUNT_F_EMPTY_PATH)
+ *
+ * and the mount is torn down on the final fput() if it never was.
+ *
+ * A mount that is not the root of an anonymous mount namespace cannot be
+ * attached by userspace at all, so a mount freshly made by fc_mount() and
+ * friends has to go through here before it can be given away.
+ *
+ * Return: the new file, or an ERR_PTR. On failure the caller's reference to
+ *         @mnt is dropped, as the mount cannot be published.
+ */
+struct file *vfs_open_detached_mount(struct vfsmount *mnt)
+{
+	struct path path __free(path_put) = {};
+	struct mnt_namespace *ns;
+	struct file *file;
+
+	if (WARN_ON_ONCE(real_mount(mnt)->mnt_ns))
+		return ERR_PTR(-EINVAL);
+
+	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	if (IS_ERR(ns)) {
+		mntput(mnt);
+		return ERR_CAST(ns);
+	}
+
+	/* The caller's reference becomes the namespace's reference. */
+	ns->root = real_mount(mnt);
+	ns->nr_mounts = 1;
+	mnt_add_to_ns(ns, real_mount(mnt));
+
+	path.mnt = mntget(mnt);
+	path.dentry = dget(mnt->mnt_root);
+
+	file = dentry_open(&path, O_PATH, current_cred());
+	if (IS_ERR(file)) {
+		dissolve_on_fput(mnt);
+		return file;
+	}
+
+	/*
+	 * An apparent O_PATH fd, with a note that the mount needs to be
+	 * unmounted on the final fput() rather than simply put.
+	 */
+	file->f_mode |= FMODE_NEED_UNMOUNT;
+
+	return file;
+}
+
 /*
  * Create a kernel mount representation for a new, prepared superblock
  * (specified by fs_fd) and attach to an open_tree-like file descriptor.
diff --git a/include/linux/mount.h b/include/linux/mount.h
index acfe7ef86a1b..44c1141bc574 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -89,6 +89,7 @@ extern struct vfsmount *vfs_create_mount(struct fs_context *fc);
 extern struct vfsmount *vfs_kern_mount(struct file_system_type *type,
 				      int flags, const char *name,
 				      void *data);
+struct file *vfs_open_detached_mount(struct vfsmount *mnt);
 
 extern void mnt_set_expiry(struct vfsmount *mnt, struct list_head *expiry_list);
 extern void mark_mounts_for_expiry(struct list_head *mounts);
-- 
2.56.0.rc1.310.g51773c2048-goog


