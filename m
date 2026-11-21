Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E93606A6AF
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6gtAeG6
Received: by kanga.kvack.org (Postfix)
	id 9B2516B05B2; Fri, 20 Nov 2026 19:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963446B05B3; Fri, 20 Nov 2026 19:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AF56B05B4; Fri, 20 Nov 2026 19:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4714A6B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:07 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C69911C2139
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:06 +0000 (UTC)
X-FDA: 85457191092.21.CAB10DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 124DB140005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6gtAeG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219745;
	b=kOVsEtTwUY9jXtrnwgzraoyxg5NpibfsQ5a1chBD+rhHTMpwo2XJv2TROc5oLrqtgJIJGn
	s6bH03n8vllOiv3NPgNmSkHVKb9BmIbP29vqj8kkw/TwXD4rAFPw640GJdMW5D7fCKe4/O
	pQ+IFObzqs7Msoqh32g8DNJZWVdKAqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGpqNaZ3H6qXitMA1TvRDZ08bq/gePLIqZe3J1C9eFE=;
	b=UmZQibzHZ4awWU6SWF46L1ct83d1lgaJwq2It5KGpTC7doyy6fR1QKXu6L+EtBVx3lb8T7
	sWPA1BMfVE+nuQ2EJIOjA0XZjG7QQ6sPm176O2H5XVrii+OPVyjKSfV75ZZtmw1y3LtXCv
	C5r7uKshIn/TzTdoWj+E3KvQW00/Y8A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S6gtAeG6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 00F70464CD;
	Sat, 21 Nov 2026 00:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BCC81F008B2;
	Sat, 21 Nov 2026 00:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219743;
	bh=iGpqNaZ3H6qXitMA1TvRDZ08bq/gePLIqZe3J1C9eFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6gtAeG65Om+Jgt/HZT4xUbqosNJqtLu4py43C40e5z2W9y4ejDVKuR0y1F1XE4XC
	 TXtgY986Jmwb5xfRGLBIkrjqOEV0tv2NwcZYIcz8AF4hM+vCj2iQt+8TwkC2SBEWmr
	 sWvvEQggcEMtjc+zoW0prucq7bhmn3KgXpO+PA+VnJHHsdg93iErs+SsUNvRONCF6M
	 vd0BGzvRTZXnDLLv/HGBem79KddNmeGun089GiSwf30ht7nsWE77yCJ3oAzYmoIX/y
	 GuEbzU2229J9xpXTqLq8CUNJlp8b1c/MoG+4Ek+tvi35daW+oNwXVN+Qr+vhSgURNq
	 Y+FoJFZeTMyDw==
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
Subject: [RFC PATCH v5 02/25] userns: Add userns_set_idmap() system call
Date: Sat, 21 Nov 2026 02:08:21 +0200
Message-ID: <20261121000844.1863324-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h3djqm35ocsxbqtz6195w8ctpn6ftf6e
X-Rspamd-Queue-Id: 124DB140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795219744-587226
X-HE-Meta: U2FsdGVkX18weTbNpGv1hNvieN/xfTqi+IA/zPzFmSyzt7RCz5LCCzMYZ/W+2JhA/DhutBQ1Y8MDA21lsG8B+u2BIWb46tVCQboG6CtLU0DfYJIpQc6f1gnnd/7cKhvm3fyIOjZ+eavj2jO2Y5C7Bx9sxu1QFEwG9O8fTKv4pvfe6Lv9kZFtFiD0VVsDOEMUMHub/B+RbzysghBiWyCgjgPuWDSpr8+QrOUfQSF7T+6htNLdJHRdKKXwW8sPMvhsH4UmfqsijvIKLTrv3yapgcooVpAMceUc7QWKuEFWJ6yDKZFb62TTRgzzwdn4haaTp8n+tj9m3lchj0GupJO5MFFnArTire4n8ZpA6UmbUuJeD3QrNKGM+IV0q3UoS/hjNTHNt2nudncuH4jeGYDu6Sjn6coMa/BQtoeMpIWey4asv5hA1iCoYt5RA8qDkXajWGDvTooKbcX0TTwtzg+gU98b8jWUKfKeyu2ag9a46eX09IAy/OPtvlqdXC3SAunc+vAm9RlROU+Bt/P3oNZ3KfaP2S+eD2DVmZSJcBa5Y3NnoWWvqE3k90fhgFR7mBfpu8YzPFC+Ak6luqWpHwn/sUSc8CDBehIsijhSgmt3BtU1UVnCxq+Tn3YHoZacFeI0OTIsWIOrdqyKwr1uyj3yIdeHsUxSYGyeikKpQV6eZEm90Ze/kkn3b9zAAtUBa7UGPIMSxqko+Ewh01xYu29i1x0oyyG942QbYVIXI5sQLMLJOFDxct+S4UsxVD9skc8/bM+nWzxWdaHCv5Hpy8oH5QaVjBWCf4iRv3m6QkyS1P3kZ5KiOh/VQ16MIa3DehPhCqhEOqvN2rRvuzPncQ+e3EaUNvYGpy6deGEevbIDg9oWff/qQ37tJJtDlvw46ephmAgAPsH4N+IY2pyii0MEy7KovlXkYhWmGMzH/pVd3H7waxb4zoJaTxjq8RXkFiCH+bGxdXzrKyfYWYGOr5j
 ixVYZizv
 95Gf+IG+08IrtFRR7mD5fF7tX5j0l7Q71n9acEgSA/CXtOHTY0lOLxYcxq2Imq0qcT/zJmf+tE3OdIoqU02rPjMlhVky4VxZ0DdXYZjiOYIcsouwHY1t09oi0rdg7jMQXLZOrtQpF9KAQx1gmI52MSo+29pePQJfOgxFhtcIGaKisPrOXCsk57YkhSeUJhA8IbkjzNyu/dV+ZL/N4GebRkLowXQ75oEN6DI19oCoqF3+EE6DESzMsqiGtmy11opU2AcN8eDJ9K1KaJ2aWYs/Bar2WqGYNCNCUWmI947B2D7Qv8RwYhREVo8vCedcC7rl9Qp3uPAGuep8cb3DAYKx6kcGecjw5GnZtEB1yQYKHth0PxMA/30PZbgsq93jKAUgXHjqaFd4ugWzRrWH3wWfqrP4jP8oDLNMTCNGFzBfXQRaYlDCi6FDsx54cxVriY2vi2RAHdIT2TgSOfhW6tAIvBP+cKg==
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
descriptor. Require CAP_SYS_ADMIN over the target user namespace in
either the caller's or the file opener's credentials, and check parent
ID-range capabilities strictly against the caller's credentials.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 include/linux/syscalls.h  |   4 +
 include/uapi/linux/nsfs.h |  53 ++++++++
 kernel/sys_ni.c           |   1 +
 kernel/user_namespace.c   | 259 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 317 insertions(+)

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
diff --git a/include/uapi/linux/nsfs.h b/include/uapi/linux/nsfs.h
index e5909266ec3f..e773f15a76c8 100644
--- a/include/uapi/linux/nsfs.h
+++ b/include/uapi/linux/nsfs.h
@@ -44,6 +44,59 @@ struct mnt_ns_info {
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
+ * enum userns_idmap_flags - Flags for &struct userns_idmap
+ * @USERNS_IDMAP_UID: Install UID mappings from @uid_extents.
+ * @USERNS_IDMAP_GID: Install GID mappings from @gid_extents.
+ * @USERNS_IDMAP_PROJID: Install project ID mappings from @projid_extents.
+ * @USERNS_SETGROUPS_DENY: Permanently disable setgroups(2) in target userns.
+ * @USERNS_IDMAP_ALL_FLAGS: Bitmask of all valid flags.
+ */
+enum userns_idmap_flags {
+	USERNS_IDMAP_UID		= (1U << 0),
+	USERNS_IDMAP_GID		= (1U << 1),
+	USERNS_IDMAP_PROJID		= (1U << 2),
+	USERNS_SETGROUPS_DENY		= (1U << 3),
+	USERNS_IDMAP_ALL_FLAGS		= 0x0fU,
+};
+
+/**
+ * struct userns_idmap - Arguments for userns_set_idmap()
+ * @flags: Combination of &enum userns_idmap_flags values.
+ * @nr_uid_extents: Number of entries in @uid_extents.
+ * @uid_extents: User pointer to array of &struct userns_idmap_extent for UIDs.
+ * @nr_gid_extents: Number of entries in @gid_extents.
+ * @nr_projid_extents: Number of entries in @projid_extents.
+ * @gid_extents: User pointer to array of &struct userns_idmap_extent for GIDs.
+ * @projid_extents: User pointer to array of &struct userns_idmap_extent for
+ *                  project IDs.
+ */
+struct userns_idmap {
+	__u32 flags;
+	__u32 nr_uid_extents;
+	__aligned_u64 uid_extents;
+	__u32 nr_gid_extents;
+	__u32 nr_projid_extents;
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
index 6b9673dcdc67..d7f2cad388c8 100644
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
@@ -1150,6 +1154,261 @@ static ssize_t map_write(struct file *file, const char __user *buf,
 	return ret;
 }
 
+static bool idmap_maps_root(const struct uid_gid_map *new_map)
+{
+	unsigned int idx;
+
+	for (idx = 0; idx < new_map->nr_extents; idx++) {
+		const struct uid_gid_extent *e;
+
+		if (new_map->nr_extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
+			e = &new_map->extent[idx];
+		else
+			e = &new_map->forward[idx];
+		if (e->lower_first == 0)
+			return true;
+	}
+	return false;
+}
+
+static bool caller_idmap_permitted(struct user_namespace *ns, int cap_setid,
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
+	if (new_map->nr_extents == 1 && new_map->extent[0].count == 1 &&
+	    uid_eq(ns->owner, cred->euid)) {
+		u32 id = new_map->extent[0].lower_first;
+
+		if (cap_setid == CAP_SETUID) {
+			kuid_t uid = make_kuid(ns->parent, id);
+
+			if (uid_eq(uid, cred->euid))
+				return true;
+		} else if (cap_setid == CAP_SETGID) {
+			kgid_t gid = make_kgid(ns->parent, id);
+
+			if (!(ns->flags & USERNS_SETGROUPS_ALLOWED) &&
+			    gid_eq(gid, cred->egid))
+				return true;
+		}
+	}
+
+	if (!cap_valid(cap_setid))
+		return true;
+
+	return ns_capable(ns->parent, cap_setid);
+}
+
+static int prepare_caller_idmap(struct user_namespace *ns, int cap_setid,
+				struct uid_gid_map *new_map,
+				struct uid_gid_map *parent_map)
+{
+	if (!caller_idmap_permitted(ns, cap_setid, new_map))
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
+ * @size: Size of @map structure in bytes (>= %USERNS_IDMAP_SIZE_VER0)
+ * @flags: Reserved for future extensions; must be zero
+ *
+ * Atomically configure the ``setgroups(2)`` policy and UID, GID, and project
+ * ID mappings of the target user namespace without requiring a live process
+ * in ``/proc``.
+ *
+ * Modifying UID, GID, or ``setgroups(2)`` settings requires ``CAP_SYS_ADMIN``
+ * over the target user namespace either in the caller's credentials or in the
+ * file opener's credentials (allowing an unprivileged creator to delegate
+ * @fd over ``SCM_RIGHTS`` to a privileged ID-mapping helper). Parent ID-range
+ * authorization is checked against the caller's credentials.
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
+	unsigned long old_flags;
+	struct file *filp;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct userns_idmap) != USERNS_IDMAP_SIZE_VER0);
+
+	if (flags)
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
+
+	ret = copy_struct_from_user(&req, sizeof(req), map, size);
+	if (ret)
+		return ret;
+
+	if (!req.flags || (req.flags & ~USERNS_IDMAP_ALL_FLAGS))
+		return -EINVAL;
+	if (!(req.flags & USERNS_IDMAP_UID) &&
+	    (req.nr_uid_extents || req.uid_extents))
+		return -EINVAL;
+	if (!(req.flags & USERNS_IDMAP_GID) &&
+	    (req.nr_gid_extents || req.gid_extents))
+		return -EINVAL;
+	if (!(req.flags & USERNS_IDMAP_PROJID) &&
+	    (req.nr_projid_extents || req.projid_extents))
+		return -EINVAL;
+
+	if (!ns->parent)
+		return -EPERM;
+	if (current_user_ns() != ns && current_user_ns() != ns->parent)
+		return -EPERM;
+
+	if (req.flags & (USERNS_IDMAP_UID | USERNS_IDMAP_GID |
+			 USERNS_SETGROUPS_DENY)) {
+		bool file_ok = (filp->f_cred->user_ns == ns ||
+				filp->f_cred->user_ns == ns->parent) &&
+			       file_ns_capable(filp, ns, CAP_SYS_ADMIN);
+
+		if (!ns_capable(ns, CAP_SYS_ADMIN) && !file_ok)
+			return -EPERM;
+	}
+
+	if (req.flags & USERNS_IDMAP_UID) {
+		ret = parse_user_idmap_extents(req.uid_extents,
+					       req.nr_uid_extents, &new_uid);
+		if (ret < 0)
+			goto out_free;
+	}
+	if (req.flags & USERNS_IDMAP_GID) {
+		ret = parse_user_idmap_extents(req.gid_extents,
+					       req.nr_gid_extents, &new_gid);
+		if (ret < 0)
+			goto out_free;
+	}
+	if (req.flags & USERNS_IDMAP_PROJID) {
+		ret = parse_user_idmap_extents(req.projid_extents,
+					       req.nr_projid_extents,
+					       &new_projid);
+		if (ret < 0)
+			goto out_free;
+	}
+
+	mutex_lock(&userns_state_mutex);
+	old_flags = ns->flags;
+	ret = -EPERM;
+
+	if ((req.flags & USERNS_SETGROUPS_DENY) && ns->gid_map.nr_extents != 0)
+		goto out_unlock;
+	if ((req.flags & USERNS_IDMAP_UID) && ns->uid_map.nr_extents != 0)
+		goto out_unlock;
+	if ((req.flags & USERNS_IDMAP_GID) && ns->gid_map.nr_extents != 0)
+		goto out_unlock;
+	if ((req.flags & USERNS_IDMAP_PROJID) && ns->projid_map.nr_extents != 0)
+		goto out_unlock;
+
+	if (req.flags & USERNS_SETGROUPS_DENY)
+		ns->flags &= ~USERNS_SETGROUPS_ALLOWED;
+
+	if (req.flags & USERNS_IDMAP_UID) {
+		ret = prepare_caller_idmap(ns, CAP_SETUID, &new_uid,
+					   &ns->parent->uid_map);
+		if (ret < 0)
+			goto out_restore;
+	}
+	if (req.flags & USERNS_IDMAP_GID) {
+		ret = prepare_caller_idmap(ns, CAP_SETGID, &new_gid,
+					   &ns->parent->gid_map);
+		if (ret < 0)
+			goto out_restore;
+	}
+	if (req.flags & USERNS_IDMAP_PROJID) {
+		ret = prepare_caller_idmap(ns, -1, &new_projid,
+					   &ns->parent->projid_map);
+		if (ret < 0)
+			goto out_restore;
+	}
+
+	if (req.flags & USERNS_IDMAP_UID)
+		commit_new_idmap(&ns->uid_map, &new_uid);
+	if (req.flags & USERNS_IDMAP_GID)
+		commit_new_idmap(&ns->gid_map, &new_gid);
+	if (req.flags & USERNS_IDMAP_PROJID)
+		commit_new_idmap(&ns->projid_map, &new_projid);
+
+	mutex_unlock(&userns_state_mutex);
+	return 0;
+
+out_restore:
+	ns->flags = old_flags;
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


