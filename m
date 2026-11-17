Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99ACC606A8B4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LlbF1Z8k
Received: by kanga.kvack.org (Postfix)
	id B0F006B05C6; Tue, 17 Nov 2026 18:14:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6476B05C7; Tue, 17 Nov 2026 18:14:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DB556B05C8; Tue, 17 Nov 2026 18:14:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D44D6B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E9711604C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:44 +0000 (UTC)
X-FDA: 85446167688.16.28A1CBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD52B80005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlbF1Z8k;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YM03tj0qhFqGxTChBGNPgoRuD3foZkehP4IPWon9Cak=;
	b=H4tqqzZBX/AMrXalIkcHoSKhUBDd3x+46IEjNkdMweGLIVzLYsS4TDxFP9tZl8097XowQc
	4SW+bteUrnNBAbVV72hxXECrC1O4RP1SSlCj2NCbi6ir5tK8OZG2c01mLK9KB3LdgCuwid
	IrIYr9j4a4ftPBmuIms9EsFxduJbn+k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957283;
	b=zVdf/tQbmE8fdngqima7JjklIJgrnWQypXUNtywETERULF6F/HC22YKtGx7yobkYOWW1ox
	3Ek3wq6NlMoeDN6OnECSDDSbwdb9/LfZH8GW1k7VDJgjjNn0EQ6PGEBuQRPF6nj/zTWxVO
	gKGLbaMBYWE0FFzOpO5CWH/nbOy6G44=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlbF1Z8k;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id E3239439BB;
	Tue, 17 Nov 2026 23:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 13F081F000C7;
	Tue, 17 Nov 2026 23:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957281;
	bh=YM03tj0qhFqGxTChBGNPgoRuD3foZkehP4IPWon9Cak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlbF1Z8kYcrI81oTdyGlWvMBJelrKdR1O0TNUGnwdcSbm1rm5rYP2lq8EA8WLEmHu
	 Ae2hPOt8GGUUFMavRV3OHSY2o5KUQXiJIoLwa/y8zyDkzVkamtybC8Bqh+hqdS4LLk
	 +n/Wtcnkw0q4/KieF+4OlYnFr2sSuK2UrrDWe1RUoFeCTJcJqMJOfTlMICwwtRLx+7
	 QDVKs5lSJNCG4sKcWPGwgJEx/vl9Mrquhfwun8eDx61f8Yb+k1+64IhUd777R/9iqR
	 AIIeEgZ522tGsQYlh1hrVh79oByO1TQKw7qE4XHN1QAvasmPI2yRO+T4hqt/2sfk3p
	 hpX3JBhXZeTDA==
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
Subject: [RFC PATCH v2 08/13] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Wed, 18 Nov 2026 01:13:47 +0200
Message-ID: <20261117231352.3816603-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CD52B80005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cm9q3neiu66x6dxyguozcwqfxhfpn3gb
X-HE-Tag: 1794957282-998986
X-HE-Meta: U2FsdGVkX19Xr04w2vS88/aKfkj72mIvMhYo6W2F72RBO3iGaSenHg4FnzsmBnhQ/6zcGMQ3R+jizWF5We6XM+CNSF8eOu7GyJAEhIibcF6I/enVNs/VOnIs/uKOEdUNDs3Z04Ah1pvowTUttosyqezmhR+4Ch0CkrjrmKucw4om4FlRXPROeC3WPvr80SWELX7r4ia8QJdVIEisjiHdI7FMOITkloWoNI5GM9EJuM7ScasvNR4miyLOFtAsHF5K3EeuawTeISUXX8hWyn4oRPNcx0Vu0ujc11dxT+gDu6J4nWNHmAraTemxJ14ERHW7iVqmBHK5odb3lWd/aFoeKZ6dZpP06+QVMBRRKTZwjQBe4qarMud2OiA3iqapYhVwi7EnJmUoN0Cjms7XWR59/AS8k4KSfx1LvgzW/2fkGWYbTwN4K0DXaYZuZeCC5m/tRogcKAwCA+MuIUT1Eb0U3cTJMXRiggxW+otApvPb2hpFtUkd3mXoce+nh5tjq6CmjOYnWtvwxU44NyDegqwIyg1LGuwB1/AG1eW5XOpsPYpo7l1ZMlMm4ACh6etAaUsMwEblkMl0f5H/jGL7l2kwnTgxcOcBNOm9Xu07omds3a6uR97qZUiRsEFjIja0pXk5ZtZLC3YqvSabbk2iFRaU63INSpKAuP8aKwVryUEEwiIaLNFUEVyMtLqSDOPeEtkIxW+8CDeiR1zVicKiwLGMKtnJWMA6Zo6/Ro4oXOvxcFNdSZCAEximD5EUmXLujKCQv5sDPYEOA2mW9reINOi3mILbEMKmzAZwQoBHiz65zSwarDWJIcu6Z+m57TziUQf+NJTNsfF9M2TkESi0+az8srU3nxtUTMfHDlic9w1roRbdtupUqt6FrFJ77Ckvb5k5ipZmvFd7iDDmMxH0r6IKpA9XNYZjWX1OdOO6RoQTdqP0JjIwQo+RQfTN0uUheFOTLMEx+95dZwqs4/XOaYq
 b01wFiNJ
 REq1MPrjXpfG46kC0BA7Cssl3esn2/JnVCPd5qFJjflIWT/0I9fYKFSYRg3PillxpaSrFLNGKvyahcU7KNgQ8JzEWcHHYjTncEeLF5x5WfO8zTE81cAtdTL3Cb6DuI//E3fkrM65i3TKJluK08zoZMCdxBD/0L8DgHzvd9QBwahgeOxNON1DrD1zbH2Kxg9oOIYsSdDjQktNK5TUPo77x7+xGCQgw5W6la3yBVXiDXP2ddaQCTsWce2Yj/FvAlXCORAV+ss/wOn1fvCY=
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
 fs/fsopen.c                | 76 ++++++++++++++++++++++++++++++++++++--
 fs/proc/root.c             | 13 +++++++
 include/linux/fs_context.h |  3 ++
 include/uapi/linux/mount.h |  1 +
 ipc/mqueue.c               | 12 ++++++
 5 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..ca3234c8c4e4 100644
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
 
@@ -41,6 +46,50 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
 	return p;
 }
 
+/**
+ * DOC: FSCONFIG_SET_ROOTNS
+ *
+ * ``fsconfig(fsfd, FSCONFIG_SET_ROOTNS, NULL, NULL, rootnsfd)`` binds a newly
+ * opened filesystem context to ``rootnsfd`` once before any parameters are
+ * supplied (subsequent calls fail with ``-EBUSY``).
+ *
+ * The caller must hold ``CAP_SYS_ADMIN`` in the target ``rootns`` user
+ * namespace.
+ *
+ * ``fc->net_ns`` is switched to the ``rootns`` network namespace,
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
@@ -147,7 +196,7 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = FS_CONTEXT_CREATE_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +271,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -298,9 +348,16 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
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
@@ -390,6 +447,10 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -457,6 +518,12 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -482,6 +549,7 @@ SYSCALL_DEFINE5(fsconfig,
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


