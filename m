Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73884606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FEw+TPoF
Received: by kanga.kvack.org (Postfix)
	id 8BFF36B05B3; Sun, 22 Nov 2026 14:36:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870B56B05B4; Sun, 22 Nov 2026 14:36:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75E7C6B05B5; Sun, 22 Nov 2026 14:36:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 397CB6B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:36:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AE529A0789
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:07 +0000 (UTC)
X-FDA: 85463760774.23.6FCB1FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1848DC0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:36:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEw+TPoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376166;
	b=yJr3u93w1tmG7W77hc1CFjxrq6temfcRKuae4uk0tcG3Z5+wVpFl3uk6KrUweXTxhnSxzo
	OEkP9rH7jPC093Y7HiQsvAEkhjAVQpghF1j2226PkrPHVuL+NHDGiWkTqy8KB1Um4zDSZo
	5bfbpZkFAumr+akOzE9d48z+1Jowy3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwYR0fybAzWaJ/ixuaYty0PvLt1G3qb2IvCSTFt/BhY=;
	b=5vCnPIaXukbYBcRQgi1JXrczlfNK3/KgGD8BmBPEqJR35T++bE7zzUE2L60Tt2xisw4weP
	HkdMrATHzG2T0zX//0JwwYJQ/J5bHUf5m6OCPWBLNrLDxvqZ6VDI2UcNnf73TAUrnhJXBk
	g0vwVByX0qTKqvxaw/UNP7hUiyHrUlg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FEw+TPoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 3A82F61D6A;
	Sun, 22 Nov 2026 19:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1032F1F00A3D;
	Sun, 22 Nov 2026 19:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376164;
	bh=bwYR0fybAzWaJ/ixuaYty0PvLt1G3qb2IvCSTFt/BhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FEw+TPoFZg72kU6HD8uTdPZhlBZWrNQof5Vz2hIUIyspTmWwA4eckU6xoFQQkUkz5
	 j5k/lqIBBdLDHpZLHsJOSjlIIQlj+ra1Q8Gq5MsYctOMl56038vXeYIg8ZUyv9Ktn6
	 LmM2fGeUPpuIzzuEdmeSVkPgk9c3oJCSD9YgAm2FRfxb93c1MzvVvI1Xj9v9FilaXq
	 saCFvGkwscsH4vLizA+s3i+flOB2Y6YMkuzGjXaxc6EFU4HiKfrk3xluz0dG0F2oLE
	 J71t5FQ5AWPRB61vS52N2QsruIRPKzgNN+ygiMNGCO0tblD9iA+veXmPtGLY3zZQEc
	 ggs6eGH4uYShA==
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
	Eric Biggers <ebiggers@kernel.org>,
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
Subject: [RFC PATCH v7 02/26] userns: Add userns_set_idmap() system call
Date: Sun, 22 Nov 2026 21:35:15 +0200
Message-ID: <20261122193539.3334213-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1848DC0007
X-Stat-Signature: tb3om3cro8hstyptzgtt4kwyu8aiogiq
X-HE-Tag: 1795376165-977189
X-HE-Meta: U2FsdGVkX190FXGicDiCcnOVfelbUHXv2geqqAoBf1r3Vea518lLEymzPt0t/gZAGMPLg2zL9srHYZZMWypelIJD5djvabPNvUuaMgVJfciWO7MMlRJASDl33MBROTdRv6HJTsQlqgF7VmebK6Ns5x7jXjmMnPGOdQI6F7MQxEaMOfxCRtIEcvLKtCiCif5uVkLR+mEH4kRANVoa/5XUUJTGt9mIfguHu5mGlNvF6uLq/P4Vf7CcvFWNwnJW4GorqqiBXp5Y9BDHcy3lDXbe/+xtag+k5Q+lg9M66RnvJHQ8e1KdEafyEOSwHAUSBxlzdS2/K6bNiNEAF99PsWNkIORcee6KI1WbYd8Yx6jNyryYezwZC69A9fbKCYrgjhnf7/dGmYPz04MfHADT5lg3qNd/aYdSx2Uegsh97NEDliR+rp8wVlasHJlgojlEN8O1D82Zs0o8PdB6ARKVLKZp12PnEkNABoX9ve0jhQxC1iich+EXvlGtS2X/lHdI01vYqtzxMXYV7c5+xj3bYxTLK5FYOhkOeO/u9H736xD0qHDFrdT9u/oEObEXTYnr+Vu8oTq1yULclmjtUWWQWtiwehFzfbMkQRTmU4FyT15rY7DFyvoti01PqBsnKLc+I9xNmEODk0xX825W8BK5cZtpXeqVj8PJ35gZ2pknb0P6YgGH0kdkWQCQm5ZDI+BLbDD2mnsMqTuIF/WImYBVFL3f5pa7ZUpKWhpTX8nPdY4XnmiIpb4KaxgzrhBFE26k2DcTHkuwlPUbpRNYwEtEFep/iKEnWGorSS4yhWUiWWLiyR9tBjsBFGFQEI//yQnUk+tPTjK3Zpl17uGSYNi7kT+jY9/eOjDSzMobZpGl/MjKvYJT7EzIQk83JLyacN1AWb19eav+s7D851ZLj0yPEKF6C307T4IlABApW5WheJD/o2KQ3zZm7H56fqE93jN+qTSQZkXnbSDb0DVbMOH2CRU
 L4wpi/o+
 6z7/pVoHidu52PtxiLtKP5q704wdovxhANSEXJIGcnEwUnRGtL8s8NNcIe20xYWxXGqLi63AC2QAcSpjYRZGPi0jovJnAAc4bjlJmF1rIXuXRZDzK8aGtW0zpHbwnSTXa2nHINUh9kGL9J+vBDuUh1GX9bG2VMr5h3AtlDDnj6TNa0brrEdmJRoq40HBQl0BBxGv7h+OV8W7IBs9vbLeJt+qJRM5/7STm43Zi6weJQiZo0M4YK9TrJy/cEXZDdtR/Ey63rsd0YNxWfjM5Ib8s0pEJSHASk+F5gWrt1E0lB+pho3Ac6//Ke8HhfSp7HdZoSZDQ8TTtUx9FttbKdXUtoZB8NEL/0+pkaacHMpellcA7rqQIsYDV2O3zSfeO87SqcGyP/PLgB1bys6DEVCQrD6Sq1GLpzk1w0sy8XkWe2nyqikTfv7QB42mUK9AR51T4EnPsQaOFm914GofI2OR45AA3sA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Configuring UID, GID, and project ID mappings currently requires writing
formatted text to /proc/<pid>/{uid_map,gid_map,projid_map,setgroups},
which depends on a live task in /proc and enforces write(2) file-opener
CAP_SETUID/CAP_SETGID checks that prevent passing an unprivileged userns
file descriptor over SCM_RIGHTS to a dedicated CAP_SETUID/CAP_SETGID
mapping helper.

Add userns_set_idmap() to atomically configure setgroups policy and UID,
GID, and project ID extents directly on a CLONE_NEWUSER nsfs file
descriptor. Expose USERNS_SETGROUPS_ALLOWED in uapi/linux/nsfs.h as the
flags bitmask when installing a GID mapping so setgroups(2) is disabled
by default unless explicitly preserved. Require CAP_SYS_ADMIN over the
target user namespace in either the caller's or the file opener's
credentials, and check parent ID-range capabilities strictly against the
caller's credentials.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h       |   4 +
 include/linux/user_namespace.h |   2 -
 include/uapi/linux/nsfs.h      |  46 +++++++
 kernel/sys_ni.c                |   1 +
 kernel/user_namespace.c        | 226 +++++++++++++++++++++++++++++++++
 5 files changed, 277 insertions(+), 2 deletions(-)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 552d9710a0d5..72308cc11908 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -77,6 +77,7 @@ struct cachestat;
 struct statmount;
 struct mnt_id_req;
 struct ns_id_req;
+struct userns_idmap;
 struct xattr_args;
 struct file_attr;
 
@@ -909,6 +910,9 @@ asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
 				struct old_timex32 __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
+asmlinkage long sys_userns_set_idmap(int fd,
+				     const struct userns_idmap __user *map,
+				     size_t size, unsigned int flags);
 asmlinkage long sys_pidfd_open(pid_t pid, unsigned int flags);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags);
diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 91232053775d..b4a50edfe003 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -35,8 +35,6 @@ struct uid_gid_map { /* 64 bytes -- 1 cache line */
 	};
 };
 
-#define USERNS_SETGROUPS_ALLOWED 1UL
-
 #define USERNS_INIT_FLAGS USERNS_SETGROUPS_ALLOWED
 
 struct ucounts;
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index e5909266ec3f..f919b19a2c74 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -44,6 +44,52 @@ struct mnt_ns_info {
 #define NS_GET_MNTNS_ID		_IOR(NSIO, 5,  __u64)
 #define NS_GET_ID		_IOR(NSIO, 13, __u64)
 
+/**
+ * struct userns_idmap_extent - Single ID mapping range for userns_set_idmap()
+ * @first: First ID inside the target user namespace.
+ * @lower_first: First ID inside the parent user namespace.
+ * @count: Number of consecutive IDs in the range.
+ * @reserved: Reserved for future use; must be zero.
+ */
+struct userns_idmap_extent {
+	__u32 first;
+	__u32 lower_first;
+	__u32 count;
+	__u32 reserved;
+};
+
+/**
+ * enum userns_flags - User namespace flags
+ * @USERNS_SETGROUPS_ALLOWED: Allow setgroups(2) inside the user namespace
+ *                            once its GID mapping is established.
+ */
+enum userns_flags {
+	USERNS_SETGROUPS_ALLOWED	= (1 << 0),
+};
+
+/**
+ * struct userns_idmap - Arguments for userns_set_idmap()
+ * @nr_uid_extents: Number of entries in @uid_extents.
+ * @nr_gid_extents: Number of entries in @gid_extents.
+ * @nr_projid_extents: Number of entries in @projid_extents.
+ * @reserved: Reserved for future use; must be zero.
+ * @uid_extents: User pointer to array of &struct userns_idmap_extent for UIDs.
+ * @gid_extents: User pointer to array of &struct userns_idmap_extent for GIDs.
+ * @projid_extents: User pointer to array of &struct userns_idmap_extent for
+ *                  project IDs.
+ */
+struct userns_idmap {
+	__u32 nr_uid_extents;
+	__u32 nr_gid_extents;
+	__u32 nr_projid_extents;
+	__u32 reserved;
+	__aligned_u64 uid_extents;
+	__aligned_u64 gid_extents;
+	__aligned_u64 projid_extents;
+};
+
+#define USERNS_IDMAP_SIZE_VER0 40 /* sizeof first published struct */
+
 enum init_ns_ino {
 	IPC_NS_INIT_INO		= 0xEFFFFFFFU,
 	UTS_NS_INIT_INO		= 0xEFFFFFFEU,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c8be0abaa407..e3202e7cc2a1 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -172,6 +172,7 @@ COND_SYSCALL_COMPAT(fadvise64_64);
 COND_SYSCALL(lsm_get_self_attr);
 COND_SYSCALL(lsm_set_self_attr);
 COND_SYSCALL(lsm_list_modules);
+COND_SYSCALL(userns_set_idmap);
 
 /* CONFIG_MMU only */
 COND_SYSCALL(swapon);
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index caba2ac33077..61dcf2fab6f0 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -22,7 +22,11 @@
 #include <linux/fs_struct.h>
 #include <linux/bsearch.h>
 #include <linux/sort.h>
+#include <linux/file.h>
 #include <linux/nstree.h>
+#include <linux/proc_fs.h>
+#include <linux/syscalls.h>
+#include <uapi/linux/nsfs.h>
 
 static struct kmem_cache *user_ns_cachep __ro_after_init;
 static DEFINE_MUTEX(userns_state_mutex);
@@ -1176,6 +1180,228 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	return ret;
 }
 
+static bool caller_idmap_permitted(struct user_namespace *ns, int cap_setid,
+				   unsigned long ns_flags,
+				   const struct uid_gid_map *new_map)
+{
+	const struct cred *cred = current_cred();
+
+	if (cap_setid == CAP_SETUID && idmap_maps_root(new_map)) {
+		if (cred->user_ns == ns) {
+			if (!ns->parent_could_setfcap)
+				return false;
+		} else {
+			if (!ns_capable(ns->parent, CAP_SETFCAP))
+				return false;
+		}
+	}
+
+	if (unpriv_idmap_permitted(ns, cred, cap_setid, ns_flags, new_map))
+		return true;
+
+	if (!cap_valid(cap_setid))
+		return ns_capable(ns, CAP_SYS_ADMIN) ||
+		       ns_capable(ns->parent, CAP_SETUID);
+
+	return ns_capable(ns->parent, cap_setid);
+}
+
+static int prepare_caller_idmap(struct user_namespace *ns, int cap_setid,
+				unsigned long ns_flags,
+				struct uid_gid_map *new_map,
+				struct uid_gid_map *parent_map)
+{
+	if (!caller_idmap_permitted(ns, cap_setid, ns_flags, new_map))
+		return -EPERM;
+
+	return resolve_new_idmap(new_map, parent_map);
+}
+
+static int parse_user_idmap_extents(__u64 uptr, __u32 nr_extents,
+				    struct uid_gid_map *new_map)
+{
+	const struct userns_idmap_extent __user *uext = u64_to_user_ptr(uptr);
+	unsigned int i;
+	int ret;
+
+	if (!nr_extents || nr_extents > UID_GID_MAP_MAX_EXTENTS || !uptr)
+		return -EINVAL;
+
+	for (i = 0; i < nr_extents; i++) {
+		struct userns_idmap_extent kext;
+		struct uid_gid_extent extent;
+
+		if (copy_from_user(&kext, &uext[i], sizeof(kext)))
+			return -EFAULT;
+		if (kext.reserved)
+			return -EINVAL;
+
+		extent.first = kext.first;
+		extent.lower_first = kext.lower_first;
+		extent.count = kext.count;
+
+		ret = validate_and_insert_extent(new_map, &extent);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+/**
+ * sys_userns_set_idmap - Configure ID mappings on a user namespace fd
+ * @fd: File descriptor referencing a %CLONE_NEWUSER ``nsfs`` namespace
+ * @map: User pointer to &struct userns_idmap configuration
+ * @size: Size of @map structure in bytes (%USERNS_IDMAP_SIZE_VER0..%PAGE_SIZE)
+ * @flags: Bitmask of &enum userns_flags values (%USERNS_SETGROUPS_ALLOWED)
+ *
+ * Atomically configure UID, GID, and project ID mappings (and, when
+ * @map->nr_gid_extents is non-zero, the %USERNS_SETGROUPS_ALLOWED policy) of
+ * @fd. Requires ``CAP_SYS_ADMIN`` over the target user namespace in the
+ * caller's or @fd opener's credentials, with parent ID ranges authorized
+ * against the caller's credentials.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+SYSCALL_DEFINE4(userns_set_idmap, int, fd,
+		const struct userns_idmap __user *, map,
+		size_t, size, unsigned int, flags)
+{
+	struct uid_gid_map new_uid = {}, new_gid = {}, new_projid = {};
+	struct userns_idmap req = {};
+	struct ns_common *ns_common;
+	struct user_namespace *ns;
+	unsigned long new_flags;
+	struct file *filp;
+	bool file_ok;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct userns_idmap) != USERNS_IDMAP_SIZE_VER0);
+
+	if (flags & ~USERNS_SETGROUPS_ALLOWED)
+		return -EINVAL;
+
+	CLASS(fd, f)(fd);
+	if (fd_empty(f))
+		return -EBADF;
+
+	filp = fd_file(f);
+	if (!proc_ns_file(filp))
+		return -EINVAL;
+
+	ns_common = get_proc_ns(file_inode(filp));
+	if (ns_common->ns_type != CLONE_NEWUSER)
+		return -EINVAL;
+	ns = to_user_ns(ns_common);
+
+	if (!map || size < USERNS_IDMAP_SIZE_VER0)
+		return -EINVAL;
+	if (unlikely(size > PAGE_SIZE))
+		return -E2BIG;
+	ret = copy_struct_from_user(&req, sizeof(req), map, size);
+	if (ret)
+		return ret;
+	if (req.reserved)
+		return -EINVAL;
+	if (!req.nr_uid_extents != !req.uid_extents ||
+	    !req.nr_gid_extents != !req.gid_extents ||
+	    !req.nr_projid_extents != !req.projid_extents)
+		return -EINVAL;
+	if (!req.nr_uid_extents && !req.nr_gid_extents &&
+	    !req.nr_projid_extents)
+		return -EINVAL;
+	if ((flags & USERNS_SETGROUPS_ALLOWED) && !req.nr_gid_extents)
+		return -EINVAL;
+
+	if (!ns->parent)
+		return -EPERM;
+	if (current_user_ns() != ns && current_user_ns() != ns->parent)
+		return -EPERM;
+
+	file_ok = (filp->f_cred->user_ns == ns ||
+		   filp->f_cred->user_ns == ns->parent) &&
+		  file_ns_capable(filp, ns, CAP_SYS_ADMIN);
+	if (!ns_capable(ns, CAP_SYS_ADMIN) && !file_ok)
+		return -EPERM;
+
+	if (req.nr_uid_extents) {
+		ret = parse_user_idmap_extents(req.uid_extents,
+					       req.nr_uid_extents, &new_uid);
+		if (ret < 0)
+			goto out_free;
+	}
+	if (req.nr_gid_extents) {
+		ret = parse_user_idmap_extents(req.gid_extents,
+					       req.nr_gid_extents, &new_gid);
+		if (ret < 0)
+			goto out_free;
+	}
+	if (req.nr_projid_extents) {
+		ret = parse_user_idmap_extents(req.projid_extents,
+					       req.nr_projid_extents,
+					       &new_projid);
+		if (ret < 0)
+			goto out_free;
+	}
+
+	mutex_lock(&userns_state_mutex);
+	new_flags = ns->flags;
+	ret = -EPERM;
+
+	if (req.nr_uid_extents && ns->uid_map.nr_extents != 0)
+		goto out_unlock;
+	if (req.nr_gid_extents && ns->gid_map.nr_extents != 0)
+		goto out_unlock;
+	if (req.nr_projid_extents && ns->projid_map.nr_extents != 0)
+		goto out_unlock;
+
+	if (req.nr_gid_extents) {
+		if ((flags & USERNS_SETGROUPS_ALLOWED) &&
+		    !(new_flags & USERNS_SETGROUPS_ALLOWED))
+			goto out_unlock;
+		if (!(flags & USERNS_SETGROUPS_ALLOWED))
+			new_flags &= ~USERNS_SETGROUPS_ALLOWED;
+	}
+
+	if (req.nr_uid_extents) {
+		ret = prepare_caller_idmap(ns, CAP_SETUID, new_flags, &new_uid,
+					   &ns->parent->uid_map);
+		if (ret < 0)
+			goto out_unlock;
+	}
+	if (req.nr_gid_extents) {
+		ret = prepare_caller_idmap(ns, CAP_SETGID, new_flags, &new_gid,
+					   &ns->parent->gid_map);
+		if (ret < 0)
+			goto out_unlock;
+	}
+	if (req.nr_projid_extents) {
+		ret = prepare_caller_idmap(ns, -1, new_flags, &new_projid,
+					   &ns->parent->projid_map);
+		if (ret < 0)
+			goto out_unlock;
+	}
+
+	if (new_flags != ns->flags)
+		WRITE_ONCE(ns->flags, new_flags);
+	if (req.nr_uid_extents)
+		commit_new_idmap(&ns->uid_map, &new_uid);
+	if (req.nr_gid_extents)
+		commit_new_idmap(&ns->gid_map, &new_gid);
+	if (req.nr_projid_extents)
+		commit_new_idmap(&ns->projid_map, &new_projid);
+
+	mutex_unlock(&userns_state_mutex);
+	return 0;
+
+out_unlock:
+	mutex_unlock(&userns_state_mutex);
+out_free:
+	free_new_idmap(&new_uid);
+	free_new_idmap(&new_gid);
+	free_new_idmap(&new_projid);
+	return ret;
+}
+
 ssize_t proc_uid_map_write(struct file *file, const char __user *buf,
 			   size_t size, loff_t *ppos)
 {
-- 
2.47.3


