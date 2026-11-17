Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6A9606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BWmdOeBx
Received: by kanga.kvack.org (Postfix)
	id 03FDC6B05C3; Tue, 17 Nov 2026 00:09:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0173C6B05C4; Tue, 17 Nov 2026 00:09:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21486B05C5; Tue, 17 Nov 2026 00:09:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0F0D6B05C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBD3516033B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:23 +0000 (UTC)
X-FDA: 85443432606.07.72BAD99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4477F40003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWmdOeBx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iu+uxrfotj0rxH3AuEVj7wlPdAFspDk2RjLn23cBba4=;
	b=pfrvXfbZDznD7/grfswyTjhK/lNXFhSJ0t3+J6iWemtuxUtQ0cGgOWDMkTdqardurMMX2a
	ruHVM5n3hc9d9NyyskdsITWZRPoRF69Tcepdk1IVEGXcLo5midmkK1wCv7Nldn9NDdvnKV
	r+IWBLTyKomkr1SMnI/u3xe8x1eyoLk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892161;
	b=2vaAZYYgl1OYw9cE6BcbH093eiuErD0cnRH9P/jgubjrynjKydHfndGhcSbSaN034mfq+C
	WZkwy9dfyIVwvPH6foB607NkiP10XRt7sygLH0lJOCp6OZWRgWQYhvMTYRsMBUyLadlz8Z
	r4pp/Yp2XO1kpW7RuVujZjk7AyAboLw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWmdOeBx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id C77E361CFF;
	Tue, 17 Nov 2026 05:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DED041F00926;
	Tue, 17 Nov 2026 05:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892160;
	bh=iu+uxrfotj0rxH3AuEVj7wlPdAFspDk2RjLn23cBba4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWmdOeBxRHtsQTn3yh/Lk+S1imLxjjdPJA6A+zflyXOlhZGRWTHvdWXaQ/tmvvI8E
	 v9umuSX4tyamF7WhrA9t4x6SP6xViDLF/9xNVyzf0g8TrQCXwiThrPsREEuULgVTeS
	 pO5HQYcjCuZeAtmdWUeCEg3mMs5Q/ngWCdr8YRVs3gayyH8dofvw2z5gL9dN5N5tWX
	 JQ6zpEcD4X+sQ/dH/Cyi/FlQ4d20BVwuVNZRB0h/ASoEaABqsC7GhJOCri9eM8a9A1
	 NkO5MijmF7iHhNGHYVmBuqY81NYnNy1M5g/udkANaaHpbHAiB2fxRAWefIHrz+VrA1
	 jU1tzVfs2hTxA==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 08/13] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Tue, 17 Nov 2026 07:08:36 +0200
Message-ID: <20261117050841.3289652-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4477F40003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p9bf3puq1mrksc4n7tbrspiy8mpxkq4c
X-Rspam-User: 
X-HE-Tag: 1794892161-20160
X-HE-Meta: U2FsdGVkX1+DHRWV2dyJ80nkX1OoCecrfUM4pBYLwCDdOjQSFJnSx2oMEC8kGBLYZXd6Uom78rd/Z5PjAf6h8WsbZ37oXRePp3TYCIDffpDmOZXFJF8Q+AtyQWbyoHyVjCFeYL5UWx4QRoV1qyHbcK+rwwq42cncp4/5MqsIDpetGhzTudvBADQDUKhOE6O78hhcONIHhe8X7CUCEvNH0Ok+qIB99x9jdUDxA/NLJVppWwpyDWrszQA9YOfXq87km95nZSwabBFw4UXrerQhlb4bFJw9U1KYDXARduqUNqjHfpu2SNUCW57B8bQs15BBcSo0sw5ZXMz+V1OvDLtPs46JzyknqYyJFspXdIiurxdKZXnrv3x7Omc/uIgxqjKXgc8cz1pwtarNLGiC+PvfzvkZalknTlza4yTOFILen4xYNonAhIDwu1abJvVchX8K+OPURiv6BhVEXdRlkqDZYsSVXmM+J/empD3Sv4YrpRqYMdg+sQ3YEMrZhX3zCD7ytq3yKCYnOfDNrw8Wp9/bPjAxAKpwbqxJIAqTUtb8BtfLINQdSBzfMGj13c7/holgiwGdFv1nZ8vVPFbmDk3XVZFlI7jAQsn3WlhJZTjWt2iuFnWA7H1p1LToCOjSW2b6ZwtqCv7KHI4MdPWRLgy6OiWvVSUPtMoiriyS+5jVLikxgGJuTHhN5Y0HdPnEWy6/1Uz4OGBA5Bw/bSjcxu+XU4EfLuaL2C5NERFKM1CgvozJq+FcJK/zTp7mNi33/dDi6Q2MZzpgI1qtxoQW43vPRGp0lKumkMa/wWTUAkNswmjO/LaGOZ2cWCSGaXLnE4MMwpMj/hbpl+HaT4nbFkHr+jnpLfGNTNdpa1CkD8SmU1k1ic6BgS9bg0kRwt9yNUNKQzTEsoe21XHBjnv8MEnp/WMuiL4iPwxk63U8CS7PSZu/GNt/4e0/+wmuxUw89dncCCLi/OvA07jvHXo2i+t
 lkM2u5GF
 Y1J6kQEjBKwqfAgIfghF7uObQrrwCJPFZjk7U+9VtdN02zBMX2p7rRoUczhhBNcLeGs9/br1WXIUB/oWskwATQW2WuNyzRJsDD0sY8i7QyTYKlkcPKxOgH/5Ua5KK3/mpcLrEL4CNG1hOt16KZDTBsbFD9cO0+xlW1JxOjEEAN7T90JdDCwuN+zjtMqmOa6IlU0hHFl7r6ffmNFO+RfuyXQKGhMyvqNHprgUvlPglt+32M6k6Az5yscCldSTOIF3eF7NTm7WyVA+jRAc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fsopen() initializes a filesystem context from current's user, network,
PID, and IPC namespaces, preventing an external manager from creating
proc, mqueue, or userns-owned superblocks bound to an unentered root
namespace.

Add FSCONFIG_SET_ROOTNS so callers holding CAP_SYS_ADMIN in the target
rootns user namespace can bind a newly opened fs_context to that rootns
once before offering parameters. Update fc->net_ns, switch fc->user_ns
for non-global FS_USERNS_MOUNT or FS_USERNS_DELEGATABLE filesystems
whose mounter fsuid/fsgid map into the rootns user namespace, and pass
the rootns to ->set_rootns() for proc and mqueue.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/fsopen.c                | 74 +++++++++++++++++++++++++++++++++++---
 fs/proc/root.c             | 13 +++++++
 include/linux/fs_context.h |  3 ++
 include/uapi/linux/mount.h |  1 +
 ipc/mqueue.c               | 12 +++++++
 5 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..98d407fd249b 100644
--- a/fs/fsopen.c
+++ b/fs/fsopen.c
@@ -13,9 +13,14 @@
 #include <linux/security.h>
 #include <linux/anon_inodes.h>
 #include <linux/namei.h>
+#include <linux/capability.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
+#include <linux/user_namespace.h>
 #include <linux/file.h>
 #include <uapi/linux/mount.h>
 #include <linux/audit.h>
+#include <net/net_namespace.h>
 #include "internal.h"
 #include "mount.h"
 
@@ -41,6 +46,48 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
 	return p;
 }
 
+/**
+ * DOC: FSCONFIG_SET_ROOTNS
+ *
+ * ``fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, rootnsfd)`` binds a newly
+ * opened filesystem context to @rootnsfd once before any parameters are
+ * supplied (subsequent calls fail with ``-EBUSY``).
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` in the target ``rootns`` user
+ * namespace. ``fc->net_ns`` is switched to the ``rootns`` network namespace,
+ * ``fc->user_ns`` is delegated for non-global ``FS_USERNS_MOUNT`` or
+ * ``FS_USERNS_DELEGATABLE`` filesystems when the mounter ``fsuid``/``fsgid``
+ * map into the target user namespace, and ``proc`` and ``mqueue`` contexts
+ * bind to the target ``rootns`` PID and IPC namespaces.
+ */
+static int fsconfig_set_rootns(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct user_namespace *user_ns;
+	struct rootns *c;
+
+	if (!is_rootns_file(param->file))
+		return -EINVAL;
+
+	c = param->file->private_data;
+	user_ns = c->cred->user_ns;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	put_net(fc->net_ns);
+	fc->net_ns = get_net(c->ns->net_ns);
+	if (!fc->global &&
+	    (fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE)) &&
+	    kuid_has_mapping(user_ns, fc->cred->fsuid) &&
+	    kgid_has_mapping(user_ns, fc->cred->fsgid)) {
+		put_user_ns(fc->user_ns);
+		fc->user_ns = get_user_ns(user_ns);
+	}
+	if (fc->ops->set_rootns)
+		fc->ops->set_rootns(fc, c);
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return 0;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
  * Only one message is returned for each read(2) call.
@@ -147,7 +194,7 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = FS_CONTEXT_CREATE_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +269,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -298,9 +346,16 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 		return vfs_cmd_create(fc, true);
 	case FSCONFIG_CMD_RECONFIGURE:
 		return vfs_cmd_reconfigure(fc);
+	case FSCONFIG_SET_ROOTNS:
+		if (fc->phase != FS_CONTEXT_CREATE_NS)
+			return -EBUSY;
+		return fsconfig_set_rootns(fc, param);
+
 	default:
-		if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
-		    fc->phase != FS_CONTEXT_RECONF_PARAMS)
+		if (fc->phase == FS_CONTEXT_CREATE_NS)
+			fc->phase = FS_CONTEXT_CREATE_PARAMS;
+		else if (fc->phase != FS_CONTEXT_CREATE_PARAMS &&
+			 fc->phase != FS_CONTEXT_RECONF_PARAMS)
 			return -EBUSY;
 
 		return vfs_parse_fs_param(fc, param);
@@ -390,6 +445,10 @@ SYSCALL_DEFINE5(fsconfig,
 		if (!_key || _value || aux < 0)
 			return -EINVAL;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		if (_key || _value || aux < 0)
+			return -EINVAL;
+		break;
 	case FSCONFIG_CMD_CREATE:
 	case FSCONFIG_CMD_CREATE_EXCL:
 	case FSCONFIG_CMD_RECONFIGURE:
@@ -457,6 +516,12 @@ SYSCALL_DEFINE5(fsconfig,
 			goto out_key;
 		param.dirfd = aux;
 		break;
+	case FSCONFIG_SET_ROOTNS:
+		ret = -EBADF;
+		param.file = fget(aux);
+		if (!param.file)
+			goto out_key;
+		break;
 	default:
 		break;
 	}
@@ -482,6 +547,7 @@ SYSCALL_DEFINE5(fsconfig,
 			putname(param.name);
 		break;
 	case FSCONFIG_SET_FD:
+	case FSCONFIG_SET_ROOTNS:
 		if (param.file)
 			fput(param.file);
 		break;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..5976029ad3f8 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -15,6 +15,8 @@
 #include <linux/sched/stat.h>
 #include <linux/module.h>
 #include <linux/bitops.h>
+#include <linux/nsproxy.h>
+#include <linux/rootns.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_context.h>
 #include <linux/mount.h>
@@ -323,6 +325,16 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static void proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(rootns->ns->pid_ns_for_children);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +346,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..cb978273c8bc 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -21,6 +21,7 @@ struct file_system_type;
 struct mnt_namespace;
 struct net;
 struct pid_namespace;
+struct rootns;
 struct super_block;
 struct user_namespace;
 struct vfsmount;
@@ -36,6 +37,7 @@ enum fs_context_purpose {
  * Userspace usage phase for fsopen/fspick.
  */
 enum fs_context_phase {
+	FS_CONTEXT_CREATE_NS,		/* Set namespaces for sb creation */
 	FS_CONTEXT_CREATE_PARAMS,	/* Loading params for sb creation */
 	FS_CONTEXT_CREATING,		/* A superblock is being created */
 	FS_CONTEXT_AWAITING_MOUNT,	/* Superblock created, awaiting fsmount() */
@@ -117,6 +119,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	void (*set_rootns)(struct fs_context *fc, struct rootns *rootns);
 	int (*get_tree)(struct fs_context *fc);
 	int (*reconfigure)(struct fs_context *fc);
 };
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index ac865edac517..cb55cfcfc92e 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -105,6 +105,7 @@ enum fsconfig_command {
 	FSCONFIG_CMD_CREATE	= 6,	/* Create new or reuse existing superblock */
 	FSCONFIG_CMD_RECONFIGURE = 7,	/* Invoke superblock reconfiguration */
 	FSCONFIG_CMD_CREATE_EXCL = 8,	/* Create new superblock, fail if reusing existing superblock */
+	FSCONFIG_SET_ROOTNS	= 9,	/* Set a rootns, supplied by fd */
 };
 
 /*
diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c44..a85ca188d370 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -32,6 +32,7 @@
 #include <linux/mutex.h>
 #include <linux/nsproxy.h>
 #include <linux/pid.h>
+#include <linux/rootns.h>
 #include <linux/ipc_namespace.h>
 #include <linux/user_namespace.h>
 #include <linux/slab.h>
@@ -400,6 +401,16 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static void mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1624,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3


