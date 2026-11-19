Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848F7606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VfdNMvOa
Received: by kanga.kvack.org (Postfix)
	id 05C266B070B; Thu, 19 Nov 2026 17:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00EBB6B070C; Thu, 19 Nov 2026 17:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEF16B070D; Thu, 19 Nov 2026 17:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABD916B070B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:44:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AF3D8029B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:06 +0000 (UTC)
X-FDA: 85453348092.08.0CF3508
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9092EC000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfdNMvOa;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128244;
	b=KKwqKiODpolg/PzS1kPgPvfGPsCy4C7n9lrjY17CNqTSlP1CPzV4qbw7RFK2CHfiva+8Te
	71pg7A3loQdu3ywFv/tk2P7GC6EArhSgRkd9dNxnxXeeUZlqqKySFNTC/UdBVN9I7SrDUO
	QJcE0Z3Bvk337wbqNY+TGl3JyJtpOmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALfY5MHYQxJsuRxCIxmQ0aAUA536BeMwQJsBxlK90gc=;
	b=gmrbnFEDbga84SEzzV5f0gELac3jDRUuXZJ9xopl9EQycClQlopfuCeV4zLI5rUve640hd
	cJb4CM0EriKrvivVGOybzcul0GeYiDjLQXSokpjHTOOU3iXhZfqjNoMJf8NaQ7pO8dhLwp
	TZEubk6KcgSd1xJXWjlyi3bcyc+TXSU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfdNMvOa;
	spf=pass (imf22.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id DEB524372C;
	Thu, 19 Nov 2026 22:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 11EA31F000C6;
	Thu, 19 Nov 2026 22:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128243;
	bh=ALfY5MHYQxJsuRxCIxmQ0aAUA536BeMwQJsBxlK90gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfdNMvOaKx/5UILFhqJXgd+P3RBvluwHgJTXAu+cVyfiufLVsOSv6QzyI8UviIl6Z
	 fLvMD0D3nRog2uPe+lAitSsM/vUuH/2qkI29/X0VZCzpEyNECljRinoQBPKa2iVPqJ
	 vJvWluP/24qUEotNj4YAxzlFuDYLfdDfHb5FdF5pZeB9Y4hBtwnHojeA+rPuqPFero
	 wmPZ34Br2bdKvKTSh7vAumrN9KyJDHl72B6zWrLb8bnyOs1Md0YO3m0DftTxtY4Wto
	 1BIrr4qnJbAXDEIpcm6awNub/QAViZkvqNrPRvSdDf+h6mwVsCuIRub0z/H0ts06e6
	 KAFZaxU+ZApHA==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Andy Lutomirski <luto@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Chris Zankel <chris@zankel.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	"Hallgrimur H. Gunnarsson" <halg@google.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Matt Turner <mattst88@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Michal Simek <monstr@monstr.eu>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Moore <paul@paul-moore.com>,
	Paul Walmsley <pjw@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Rich Felker <dalias@libc.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Serge Hallyn <sergeh@kernel.org>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v4 08/14] fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
Date: Fri, 20 Nov 2026 00:43:06 +0200
Message-ID: <20261119224312.1037966-9-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9092EC000A
X-Rspam-User:
X-Stat-Signature: a4uxtd8t7q438tkg7eypoxrg5hdpc4pa
X-HE-Tag: 1795128244-865373
X-HE-Meta: U2FsdGVkX18+TINpYz8aYPHbGAx/XLlaYwAppirH4el3b3Vhkco5HsyYuUQF5XvLumsZZXdYIgQv5OIGfgMbKFvmS4mNGyQj2sWG6D/QZxTyp6VOJL2u063tRf+6QK2Rtvap6uZbg0fk90MmZ2mHetGCkUoT7oGmPQK6uw3YSXgTtAJrZh2M8ObhxGqab9YxfEdyzRnDiaMYL67Ibrpk2ItVmsR+Tl9PmzWXlPiG+zfs4scq8TMsGCGns8tdzNWCUjNR9HnMv0ZXL3h9G7taMlQyQ0DynpfZbcQON6es/6UFdjkV9Eu2dbTiE2EOFeef3KVzHg+Crb4A9bhqhomHS3WFYHQuTjEq3Y/TkV1piIe3YU6lZjXuI+8FMTKCsBuUvL50h9FJMoTyPabQBTU7YdUeNMRzxFe9KuQuwBljpsToDtFvKTKyVqlAJQmANiYtUYfPm6nc1wpcZrrCjbJ9Xh32KYH5xh+n6/IjUi/o2bu28RdrmZL4L2OU21YhZZb+FQRszlnb6TjywySohjK1Z3XuIAzEgvF2uoxDxNcAM6DsODxGW8TsYeR6X9Ctqdnw7iQ14r9+K2u9U1ZaTOn85fZpeXFAEN2WNjY40/no1Pv5fmopQqS3Xl9nPacT5+ZtbasJBsmu8B4ogUeMMre65on45rGJICm2Hb68Mp+RsVAay82B+dZGjvvfNE8C/3+efVyC6UACiMENU4r+3SeqCtQhxaqEPWWDfGbtr4Q6X+eNwNOb9ynn2zEXd5as0zD0HtbM4xk7a5JLJOeYWnfNMvlLiOjRRq3+3hOf/8tp5wNB2/PoFLGD/4DoEz/p0fRGtYN0Z54Gh14fQQpob1AuOzMsvr6uaPdM7oUFFGNn8d3QVzLBhsPt29vqHyUqGcoGbpaD0Of9leNvRSPeLnvVPGT9DrL1vKS9Lms+r7y1X1cysMf/wIzywdMN8yfZsOKoLVJZ5fQ5p0O6BCsK1L1
 hf6o50FW
 0xvWKde0rubkSFHsvlmC4m5Muf5xKDKpwou6fbG92bp97qlRnOVTfzVHjoGmYlbpDUF5IJDrEmLgxxKCer52kTEEcq2Rx4abCcQl1tFBt4mheX2vVtA6VT9DKBR278GENd9RTc1ASxmhwFP60qhx/okdxWOYHcLZ8tODn+0Cl1vZZBuieTLVJEeeGSPUOptSmEpND8OFoIUTygFSanwoQT9CqJojzI6weVKO/LktjTf6VoMwfKPECFkrfc4TsDh6cuH09I5WFr3a11Ux+PqyXppjIoW7d/NZFZ/ECEDsOOJyrKGIKji0HtlvHYnnxtt2k5oY4JSHhrKw0mWMzDnCsZlJqSr1vThcGvh0uPfDyhfYn+Smlmp1rd7n78hdUVCUEdybZpnFttYaoIQQs0S2h+da33oWGt42P+dGuxYMOrr1vvRl1tz7j9GklBLN0EiDBjPQJocZ/CI75uAcAPsT8kLxCVTQyabgLWohcn3OyRUMxIivz9cCJI/bUpohi7XrQH5IQSTBHUm6/U7ATYRjf4srCbscWfTlnVpRzjXA9+/BKqRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fsopen() and fsmount() gate on CAP_SYS_ADMIN in the caller's current
mount namespace and initialize filesystem contexts from current's user,
network, PID, and IPC namespaces, preventing an unprivileged external
manager from creating superblocks and detached mounts for an unentered
root namespace.

Add FSCONFIG_SET_ROOTNS so callers holding CAP_SYS_ADMIN in the target
rootns user namespace can bind a newly opened fs_context to that rootns
once before offering parameters. Allow unprivileged callers to open
FS_USERNS_MOUNT contexts in FS_CONTEXT_AWAITING_NS without module
autoloading until FSCONFIG_SET_ROOTNS authorizes and initializes the
context, keep devpts pty_reserve restricted to host mounts, enforce
mount_too_revealing() for unprivileged callers in init_mnt_ns, and wire
->set_rootns() for proc and mqueue.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/devpts/inode.c          |   2 +
 fs/filesystems.c           |  15 ++++
 fs/fs_context.c            |  21 ++++--
 fs/fsopen.c                | 139 ++++++++++++++++++++++++++++++++++---
 fs/internal.h              |   6 ++
 fs/namespace.c             |  38 ++++++++--
 fs/proc/root.c             |  18 +++++
 include/linux/fs_context.h |   6 ++
 include/uapi/linux/mount.h |   1 +
 ipc/mqueue.c               |  13 ++++
 10 files changed, 241 insertions(+), 18 deletions(-)

diff --git a/fs/devpts/inode.c b/fs/devpts/inode.c
index bd1e8eb26edb..db5a5c7a07db 100644
--- a/fs/devpts/inode.c
+++ b/fs/devpts/inode.c
@@ -434,6 +434,8 @@ static int devpts_init_fs_context(struct fs_context *fc)
 	fsi->mount_opts.max     = NR_UNIX98_PTY_MAX;
 
 	if (fc->purpose == FS_CONTEXT_FOR_MOUNT &&
+	    !fc->rootns_bound &&
+	    fc->user_ns == &init_user_ns &&
 	    current->nsproxy->mnt_ns == init_task.nsproxy->mnt_ns)
 		fsi->mount_opts.reserve = true;
 
diff --git a/fs/filesystems.c b/fs/filesystems.c
index 3083d904df9b..9429844bf6bf 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <linux/fs_parser.h>
 #include <linux/rculist.h>
+#include "internal.h"
 
 /*
  * Read-mostly filesystem drivers list.
@@ -390,6 +391,20 @@ static struct file_system_type *__get_fs_type(const char *name, int len)
 	return fs;
 }
 
+struct file_system_type *get_fs_type_noload(const char *name)
+{
+	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	int len = dot ? dot - name : strlen(name);
+
+	fs = __get_fs_type(name, len);
+	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
+		put_filesystem(fs);
+		fs = NULL;
+	}
+	return fs;
+}
+
 struct file_system_type *get_fs_type(const char *name)
 {
 	struct file_system_type *fs;
diff --git a/fs/fs_context.c b/fs/fs_context.c
index a50584df97be..cd004750b99c 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -249,6 +249,7 @@ EXPORT_SYMBOL(generic_parse_monolithic);
  * @sb_flags: Filesystem/superblock flags (SB_*)
  * @sb_flags_mask: Applicable members of @sb_flags
  * @purpose: The purpose that this configuration shall be used for.
+ * @init: Whether to initialise the filesystem context immediately.
  *
  * Open a filesystem and create a mount context.  The mount context is
  * initialised with the supplied flags and, if a submount/automount from
@@ -259,7 +260,8 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 				      struct dentry *reference,
 				      unsigned int sb_flags,
 				      unsigned int sb_flags_mask,
-				      enum fs_context_purpose purpose)
+				      enum fs_context_purpose purpose,
+				      bool init)
 {
 	struct fs_context *fc;
 	int ret = -ENOMEM;
@@ -292,6 +294,9 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 		break;
 	}
 
+	if (!init)
+		return fc;
+
 	ret = fc->fs_type->init_fs_context(fc);
 	if (ret < 0)
 		goto err_fc;
@@ -307,10 +312,16 @@ struct fs_context *fs_context_for_mount(struct file_system_type *fs_type,
 					unsigned int sb_flags)
 {
 	return alloc_fs_context(fs_type, NULL, sb_flags, 0,
-					FS_CONTEXT_FOR_MOUNT);
+				FS_CONTEXT_FOR_MOUNT, true);
 }
 EXPORT_SYMBOL(fs_context_for_mount);
 
+struct fs_context *fs_context_for_unpriv_mount(struct file_system_type *fs_type)
+{
+	return alloc_fs_context(fs_type, NULL, 0, 0,
+				FS_CONTEXT_FOR_MOUNT, false);
+}
+
 struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 					unsigned int sb_flags,
 					unsigned int sb_flags_mask)
@@ -320,7 +331,8 @@ struct fs_context *fs_context_for_reconfigure(struct dentry *dentry,
 		return ERR_PTR(-EINVAL);
 
 	return alloc_fs_context(dentry->d_sb->s_type, dentry, sb_flags,
-				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE);
+				sb_flags_mask, FS_CONTEXT_FOR_RECONFIGURE,
+				true);
 }
 
 /**
@@ -337,7 +349,8 @@ struct fs_context *fs_context_for_submount(struct file_system_type *type,
 	struct fs_context *fc;
 	int ret;
 
-	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT);
+	fc = alloc_fs_context(type, reference, 0, 0, FS_CONTEXT_FOR_SUBMOUNT,
+			      true);
 	if (IS_ERR(fc))
 		return fc;
 
diff --git a/fs/fsopen.c b/fs/fsopen.c
index 70024870fefa..85b31af68a4d 100644
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
 
@@ -41,6 +46,94 @@ static inline const char *fetch_message_locked(struct fc_log *log, size_t len,
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
+ * namespace, allowing unprivileged callers to configure ``FS_USERNS_MOUNT``
+ * filesystems without entering the user namespace first.
+ *
+ * The context is initialized against the ``rootns`` network namespace,
+ * ``fc->user_ns`` is delegated to the ``rootns`` user namespace for
+ * ``FS_USERNS_MOUNT`` and ``FS_USERNS_DELEGATABLE`` filesystems when the
+ * mounter ``fsuid``/``fsgid`` map into it or the caller lacks
+ * ``CAP_SYS_ADMIN`` in its own user namespace, and ``proc`` and ``mqueue``
+ * contexts bind to the target ``rootns`` PID and IPC namespaces.
+ */
+static int fsconfig_set_rootns(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct user_namespace *user_ns;
+	struct rootns *c;
+	int ret;
+
+	if (!is_rootns_file(param->file))
+		return -EINVAL;
+
+	c = param->file->private_data;
+	user_ns = c->user_ns;
+	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (fc->need_free && fc->ops && fc->ops->free)
+		fc->ops->free(fc);
+	fc->need_free = false;
+	fc->fs_private = NULL;
+	fc->s_fs_info = NULL;
+	fc->ops = NULL;
+	fc->sb_flags = 0;
+	fc->global = false;
+	security_free_mnt_opts(&fc->security);
+
+	if (fc->log.prefix && strcmp(fc->fs_type->name, fc->log.prefix)) {
+		struct file_system_type *orig;
+
+		orig = get_fs_type_noload(fc->log.prefix);
+		if (!orig) {
+			fc->phase = FS_CONTEXT_FAILED;
+			return -ENODEV;
+		}
+		put_filesystem(fc->fs_type);
+		fc->fs_type = orig;
+	}
+
+	put_net(fc->net_ns);
+	fc->net_ns = get_net(c->ns->net_ns);
+	put_user_ns(fc->user_ns);
+	if ((fc->fs_type->fs_flags & (FS_USERNS_MOUNT | FS_USERNS_DELEGATABLE)) &&
+	    ((kuid_has_mapping(user_ns, fc->cred->fsuid) &&
+	      kgid_has_mapping(user_ns, fc->cred->fsgid)) ||
+	     !ns_capable(fc->cred->user_ns, CAP_SYS_ADMIN)))
+		fc->user_ns = get_user_ns(user_ns);
+	else
+		fc->user_ns = get_user_ns(fc->cred->user_ns);
+
+	fc->rootns_bound = true;
+	fc->rootns_mnt_id = c->ns->mnt_ns->ns.ns_id;
+
+	ret = fc->fs_type->init_fs_context(fc);
+	if (ret < 0) {
+		fc->rootns_bound = false;
+		fc->phase = FS_CONTEXT_FAILED;
+		return ret;
+	}
+	fc->need_free = true;
+
+	if (fc->ops->set_rootns) {
+		ret = fc->ops->set_rootns(fc, c);
+		if (ret < 0) {
+			fc->rootns_bound = false;
+			fc->phase = FS_CONTEXT_FAILED;
+			return ret;
+		}
+	}
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return 0;
+}
+
 /*
  * Allow the user to read back any error, warning or informational messages.
  * Only one message is returned for each read(2) call.
@@ -123,9 +216,11 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 	struct file_system_type *fs_type;
 	struct fs_context *fc;
 	const char *fs_name;
+	bool priv;
 	int ret;
 
-	if (!may_mount())
+	priv = may_mount();
+	if (!priv && !IS_ENABLED(CONFIG_ROOTNS))
 		return -EPERM;
 
 	if (flags & ~FSOPEN_CLOEXEC)
@@ -137,17 +232,23 @@ SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
 
 	audit_log_fsopen(fs_name);
 
-	fs_type = get_fs_type(fs_name);
+	fs_type = priv ? get_fs_type(fs_name) : get_fs_type_noload(fs_name);
 	kfree(fs_name);
 	if (!fs_type)
-		return -ENODEV;
+		return priv ? -ENODEV : -EPERM;
 
-	fc = fs_context_for_mount(fs_type, 0);
+	if (!priv && !(fs_type->fs_flags & FS_USERNS_MOUNT)) {
+		put_filesystem(fs_type);
+		return -EPERM;
+	}
+
+	fc = priv ? fs_context_for_mount(fs_type, 0) :
+		    fs_context_for_unpriv_mount(fs_type);
 	put_filesystem(fs_type);
 	if (IS_ERR(fc))
 		return PTR_ERR(fc);
 
-	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	fc->phase = priv ? FS_CONTEXT_CREATE_NS : FS_CONTEXT_AWAITING_NS;
 
 	ret = fscontext_alloc_log(fc);
 	if (ret < 0)
@@ -222,7 +323,8 @@ static int vfs_cmd_create(struct fs_context *fc, bool exclusive)
 	struct super_block *sb;
 	int ret;
 
-	if (fc->phase != FS_CONTEXT_CREATE_PARAMS)
+	if (fc->phase != FS_CONTEXT_CREATE_NS &&
+	    fc->phase != FS_CONTEXT_CREATE_PARAMS)
 		return -EBUSY;
 
 	if (!mount_capable(fc))
@@ -291,6 +393,8 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 	ret = finish_clean_context(fc);
 	if (ret)
 		return ret;
+	if (fc->phase == FS_CONTEXT_AWAITING_NS && cmd != FSCONFIG_SET_ROOTNS)
+		return -EPERM;
 	switch (cmd) {
 	case FSCONFIG_CMD_CREATE:
 		return vfs_cmd_create(fc, false);
@@ -298,9 +402,17 @@ static int vfs_fsconfig_locked(struct fs_context *fc, int cmd,
 		return vfs_cmd_create(fc, true);
 	case FSCONFIG_CMD_RECONFIGURE:
 		return vfs_cmd_reconfigure(fc);
+	case FSCONFIG_SET_ROOTNS:
+		if (fc->phase != FS_CONTEXT_AWAITING_NS &&
+		    fc->phase != FS_CONTEXT_CREATE_NS)
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
@@ -390,6 +502,10 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -457,6 +573,12 @@ SYSCALL_DEFINE5(fsconfig,
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
@@ -482,6 +604,7 @@ SYSCALL_DEFINE5(fsconfig,
 			putname(param.name);
 		break;
 	case FSCONFIG_SET_FD:
+	case FSCONFIG_SET_ROOTNS:
 		if (param.file)
 			fput(param.file);
 		break;
diff --git a/fs/internal.h b/fs/internal.h
index 3f2fbac40f8e..d6815bf6ea9b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -40,12 +40,18 @@ int __block_write_begin_int(struct folio *folio, loff_t pos, unsigned len,
  */
 extern void __init chrdev_init(void);
 
+/*
+ * filesystems.c
+ */
+struct file_system_type *get_fs_type_noload(const char *name);
+
 /*
  * fs_context.c
  */
 extern int parse_monolithic_mount_data(struct fs_context *, void *);
 extern void vfs_clean_context(struct fs_context *fc);
 extern int finish_clean_context(struct fs_context *fc);
+struct fs_context *fs_context_for_unpriv_mount(struct file_system_type *fs_type);
 
 /*
  * namei.c
diff --git a/fs/namespace.c b/fs/namespace.c
index 781380945d78..dfe0ee9ecdcd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4614,16 +4614,19 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	struct vfsmount *new_mnt;
 	struct mount *mnt;
 	unsigned int mnt_flags = 0;
+	bool priv;
 	long ret;
 
 	if ((flags & ~(FSMOUNT_CLOEXEC | FSMOUNT_NAMESPACE)) != 0)
 		return -EINVAL;
 
+	priv = may_mount();
 	if ((flags & FSMOUNT_NAMESPACE) &&
 	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!(flags & FSMOUNT_NAMESPACE) && !may_mount())
+	if (!(flags & FSMOUNT_NAMESPACE) && !IS_ENABLED(CONFIG_ROOTNS) &&
+	    !priv)
 		return -EPERM;
 
 	if (attr_flags & ~FSMOUNT_VALID_FLAGS)
@@ -4658,6 +4661,15 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 	if (ret)
 		return ret;
 
+	if (fc->rootns_bound) {
+		if (flags & FSMOUNT_NAMESPACE)
+			return -EINVAL;
+		if (!ns_capable(fc->user_ns, CAP_SYS_ADMIN))
+			return -EPERM;
+	} else if (!(flags & FSMOUNT_NAMESPACE) && !priv) {
+		return -EPERM;
+	}
+
 	/* There must be a valid superblock or we can't mount it */
 	ret = -EINVAL;
 	if (!fc->root)
@@ -4699,9 +4711,12 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 		return FD_ADD((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0,
 			      open_new_namespace(&new_path, MOUNT_COPY_NEW));
 
-	ns = alloc_mnt_ns(current->nsproxy->mnt_ns->user_ns, true);
+	ns = alloc_mnt_ns(priv ? current->nsproxy->mnt_ns->user_ns :
+			  fc->user_ns, true);
 	if (IS_ERR(ns))
 		return PTR_ERR(ns);
+	if (!priv)
+		ns->seq_origin = fc->rootns_mnt_id;
 	mnt = real_mount(new_path.mnt);
 	ns->root = mnt;
 	ns->nr_mounts = 1;
@@ -6582,6 +6597,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 				const struct super_block *sb,
 				int *new_mnt_flags)
 {
+	bool foreign_ns = !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN);
 	int new_flags = *new_mnt_flags;
 	struct mount *mnt;
 
@@ -6611,6 +6627,11 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		/* Don't miss readonly hidden in the superblock flags */
 		if (sb_rdonly(mnt->mnt.mnt_sb))
 			mnt_flags |= MNT_LOCK_READONLY;
+		if (foreign_ns) {
+			if (mnt_flags & MNT_READONLY)
+				mnt_flags |= MNT_LOCK_READONLY;
+			mnt_flags |= MNT_LOCK_ATIME;
+		}
 
 		/* Verify the mount flags are equal to or more permissive
 		 * than the proposed new mount.
@@ -6629,7 +6650,7 @@ static bool mnt_already_visible(struct mnt_namespace *ns,
 		list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
 			struct inode *inode = child->mnt_mountpoint->d_inode;
 			/* Only worry about locked mounts */
-			if (!(child->mnt.mnt_flags & MNT_LOCKED))
+			if (!foreign_ns && !(child->mnt.mnt_flags & MNT_LOCKED))
 				continue;
 			/* Is the directory permanently empty? */
 			if (!is_empty_dir_inode(inode))
@@ -6650,13 +6671,18 @@ static bool mount_too_revealing(const struct super_block *sb, int *new_mnt_flags
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	unsigned long s_iflags;
 
-	if (ns->user_ns == &init_user_ns)
-		return false;
-
 	/* Can this filesystem be too revealing? */
 	if (!(sb->s_type->fs_flags & FS_USERNS_MOUNT_RESTRICTED))
 		return false;
 
+	if (ns->user_ns == &init_user_ns &&
+	    ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+		return false;
+
+	if (!ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN) &&
+	    current_chrooted())
+		return true;
+
 	s_iflags = sb->s_iflags;
 	if ((s_iflags & required_iflags) != required_iflags) {
 		WARN_ONCE(1, "Expected s_iflags to contain 0x%lx\n",
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 7fbbe92bf73a..323296b03089 100644
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
@@ -323,6 +325,21 @@ static int proc_get_tree(struct fs_context *fc)
 	return get_tree_nodev(fc, proc_fill_super);
 }
 
+static int proc_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct pid_namespace *target = rootns->ns->pid_ns_for_children;
+
+	if (!pidns_is_ancestor(target, task_active_pid_ns(current)))
+		return invalfc(fc, "cannot set pidns to non-descendant pidns");
+
+	put_pid_ns(ctx->pid_ns);
+	ctx->pid_ns = get_pid_ns(target);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->pid_ns->user_ns);
+	return 0;
+}
+
 static void proc_fs_context_free(struct fs_context *fc)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -334,6 +351,7 @@ static void proc_fs_context_free(struct fs_context *fc)
 static const struct fs_context_operations proc_fs_context_ops = {
 	.free		= proc_fs_context_free,
 	.parse_param	= proc_parse_param,
+	.set_rootns	= proc_set_rootns,
 	.get_tree	= proc_get_tree,
 	.reconfigure	= proc_reconfigure,
 };
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index d1727dffecc5..42648bec5cfa 100644
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
@@ -36,6 +37,8 @@ enum fs_context_purpose {
  * Userspace usage phase for fsopen/fspick.
  */
 enum fs_context_phase {
+	FS_CONTEXT_AWAITING_NS,		/* Unprivileged context awaiting target ns */
+	FS_CONTEXT_CREATE_NS,		/* Set namespaces for sb creation */
 	FS_CONTEXT_CREATE_PARAMS,	/* Loading params for sb creation */
 	FS_CONTEXT_CREATING,		/* A superblock is being created */
 	FS_CONTEXT_AWAITING_MOUNT,	/* Superblock created, awaiting fsmount() */
@@ -101,6 +104,7 @@ struct fs_context {
 	const char		*source;	/* The source name (eg. dev path) */
 	void			*security;	/* LSM options */
 	void			*s_fs_info;	/* Proposed s_fs_info */
+	u64			rootns_mnt_id;	/* Target rootns mnt_ns ID */
 	unsigned int		sb_flags;	/* Proposed superblock flags (SB_*) */
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		s_iflags;	/* OR'd with sb->s_iflags */
@@ -110,6 +114,7 @@ struct fs_context {
 	bool			global:1;	/* Goes into &init_user_ns */
 	bool			oldapi:1;	/* Coming from mount(2) */
 	bool			exclusive:1;    /* create new superblock, reject existing one */
+	bool			rootns_bound:1;	/* Bound via FSCONFIG_SET_ROOTNS */
 };
 
 struct fs_context_operations {
@@ -117,6 +122,7 @@ struct fs_context_operations {
 	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
 	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
 	int (*parse_monolithic)(struct fs_context *fc, void *data);
+	int (*set_rootns)(struct fs_context *fc, struct rootns *rootns);
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
index 322c3dd98c44..f94e9b566bd0 100644
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
@@ -400,6 +401,17 @@ static struct inode *mqueue_get_inode(struct super_block *sb,
 	return ERR_PTR(ret);
 }
 
+static int mqueue_set_rootns(struct fs_context *fc, struct rootns *rootns)
+{
+	struct mqueue_fs_context *ctx = fc->fs_private;
+
+	put_ipc_ns(ctx->ipc_ns);
+	ctx->ipc_ns = get_ipc_ns(rootns->ns->ipc_ns);
+	put_user_ns(fc->user_ns);
+	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
+	return 0;
+}
+
 static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 {
 	struct inode *inode;
@@ -1613,6 +1625,7 @@ static const struct super_operations mqueue_super_ops = {
 
 static const struct fs_context_operations mqueue_fs_context_ops = {
 	.free		= mqueue_fs_context_free,
+	.set_rootns	= mqueue_set_rootns,
 	.get_tree	= mqueue_get_tree,
 };
 
-- 
2.47.3


