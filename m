Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 080EF606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=db3StkjD
Received: by kanga.kvack.org (Postfix)
	id D542F6B0667; Thu, 19 Nov 2026 17:44:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2C106B06A6; Thu, 19 Nov 2026 17:44:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF3E16B06A9; Thu, 19 Nov 2026 17:44:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 935DE6B0667
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:44:10 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E719160700
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:10 +0000 (UTC)
X-FDA: 85453348260.02.DCFE526
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6F83B4000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:44:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=db3StkjD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795128248;
	b=CIMGqD/EzVvrZInd6Jn38w/CU0rKKoz9swtS8v4pCswUe8nlpTfNR2pX/BxLRjnrm1YvSJ
	s7itwUFErKMGHMcaboL6FlDQzNHWiAnoj9pNvMU6Ri6GmyV2yDFCwLwuLLx37lzZsraSnb
	cNum8vcm1QquBH8wDsMKPsRh6iI/gOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795128248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eEe2r2EBx2FnK3ZzLaNRPJmy07FKDKEoTlSvzlDsMA=;
	b=Dd3X021uXs8Cl5FOaGCaObkIiDNfidAZutqJ9cgeGXKYm0BkFTKiwLLSjoYqccjPnvNQOJ
	23V/91J9P/MKTjVaHOgzCDc5Cixtt+HTYZGIXKVHsvl297KITRFXAS/DbvDsQt25w7sDN6
	vhVpgTXmXxakFCc7RVh/eIRe4NCKXCY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=db3StkjD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id ADFF744D05;
	Thu, 19 Nov 2026 22:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DECFA1F000D0;
	Thu, 19 Nov 2026 22:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795128247;
	bh=0eEe2r2EBx2FnK3ZzLaNRPJmy07FKDKEoTlSvzlDsMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=db3StkjDLhRvHzsZ6va3WlmKUzfMU6/r2x3vb/zSxzgPFoWhzZKXiVin+Z6roSZ9x
	 gZkBmX2AnhJXekRAKXMd3dpRBFGuJHAKoeM96V8Ry4rtWBapdbACP36Iug+XLAUBhH
	 VhfyFqJrra5fnDL+v7zimjczw9juYVjZYmv03gVgYBek1DQcv/ytbOaJCXESl3mLEi
	 P+PKmH1Yz2cmx0jdBhRvBnRoQt7szKZJViim+To8oq6h8jcjcVk1DMWcXZyXCnoTdq
	 EUg2YbDubuRd6piqxV//D3wQiv0rqbkUFMLT4UZuyC2IiK1MStPUw97vmVspi2y9dy
	 SVsUNfCsTG8KA==
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
Subject: [RFC PATCH v4 09/14] fs: Support MOVE_MOUNT_T_MNTNS in move_mount()
Date: Fri, 20 Nov 2026 00:43:07 +0200
Message-ID: <20261119224312.1037966-10-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261119224312.1037966-1-jarkko@kernel.org>
References: <20261119224312.1037966-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6F83B4000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zjqhjfejixtke1tooyt4hehcryff4k8n
X-HE-Tag: 1795128248-500902
X-HE-Meta: U2FsdGVkX1+ZlxPEsgUArNdUyvwl6SjsF+sCPioTIFLP8m69tsWD4HqCFKAXhAHlwdyyTTlxzuWxHr4NPjAGJdiCY1GA91EAfkKVHtfS6uf1H/1cZSjed04Cc61Ie8OParVhaBS8K26mXUZV3OTP3xDyvAfqVVMrHbR8gvXha/U+/3eFfLmpLPHyTtLWvZZExrGpDjsg8Dq1CPCcjD56MH3Rt+poanae2fxQDyCx2zpWEAwW5HkoqSxEE3aYSGu4qQ10wxq1H1sCDdbbdEHvaBiIcRag4OvRvwytWET925lsh5bJDgRoWBlg5IJU5rJQKGktqOms7/qEh+T44NNv+4Qeukepcoew9mY1a0b7VtgrubkNSf0/aXldAu4vbYbONUayEyq4c1GGADtycorBmePXXzn+ps82aCiC2fSLxRAkwmeqyAUsxLu0kPOcdzD+MCwVbLkZhg6GEHhY9nzmH/cgsclZZa05q6mG2Sxq0y5tmAplNKHAHQXlBPxVXo0ReIwSqC+muDc9SrF2OkQ1Rmx5VHJ6CHbE1XYBx216HvL7CxR0xVI64X4LY7Bv8dNEgWPjVLv5yJ8J9BEL6Xu9/Q9flxSvEa6hxxvhtG+YX3mDgPNnXIlBaASYwI7ib1Z+cz3dCkM94S+PHkbZhBFGyHX81Br/+vHs88zpKbszOby8gCNz7MPVhXPrsMCSuR9aHNwooP/98cJCnoas3h/Ct6cbDhuX0YBCPFcJTb04z3/GkxlR/YU1RTcpFRJY+aXsRD1/9XjK8UXDbXprhd/Hg/MQdWtSkx4NiR3VLoDXSmuztN8wZJ25zh3FOLEFNyBAz2VyNaEMIvChuuUGEJz/A0WamlLuf1t0xzOeGKtYa4tUvi9FLBYfdtjQqR+Dmn2EW4PATTY2VJ5t4ksLW9m4nROcK34vZ8oLbhGZBju2GogmFcPZcTIineRZmPx/uN76hz0kbU1fyJXG5ThGbhT
 SC3a1FCV
 d/t5u9MmUBSCBlebw+HT0PbPTAurZy2U4EB0FbmpKLOH5Mkeh5TPpu/yuuCAOVapD8HEb7O1/0Fd/03/142DQqfK5QXuegWandaIPrbUMvbtrzwG/KdHgcuCQIHvUROvegIYTcWz0IyOXZ1V/psP9wDS1B51u3XsT0bREhuLl8dIzWtniha41aOKEORm8T6CwYdIV9MsvMPeLAK39/fUtmLsm2JZHs6VnVrcNbp10l6aIxzm8Z9aFqVqT5YMB6YeQsOG9wYtrPV+zuL/aLg6EgjkOTkcJ2r3qfk6dT8W7RW+QfG0PjtEmwDEXb93Tu+8YiBapO8wFK0DrTGIIa2WXzqlJT82R6NJTojkpdWcTxP5pqGqyundgS9YK8B/TEJlxYWz5mnQtz/kxZg295KxaT+V//O1xWEKMgJuEN5e0nfpyO593D/z1KwjbelFufKjnsiettP2KYBbikHuWCNj14nRFojXwsKcgXSReNcdqY/TT1tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_mount() currently resolves target paths only against the caller's
filesystem view or anonymous mount fds, preventing an external manager
from populating an empty mount namespace or hot-mounting into an
existing container's mount namespace without entering it first.

Add MOVE_MOUNT_T_MNTNS to attach detached anonymous mount trees into a
target mount namespace nsfs file descriptor. Installing "/" attaches the
initial root mount onto the nullfs root of an empty mount namespace at
most once, while relative target paths resolve with LOOKUP_IN_ROOT
beneath the live mount namespace root and reject root-mount aliases
under namespace_lock().

Check CAP_SYS_ADMIN in the target mount namespace's owning user
namespace instead of caller may_mount(), check nsfs mount loops against
the destination mount namespace, and lock moved mount trees inside
attach_recursive_mnt() when crossing user namespace boundaries.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 fs/namespace.c             | 218 +++++++++++++++++++++++++++++++------
 include/uapi/linux/mount.h |   3 +-
 2 files changed, 184 insertions(+), 37 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index dfe0ee9ecdcd..36ed48c3f646 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2202,7 +2202,8 @@ struct mnt_namespace *mnt_ns_from_dentry(struct dentry *dentry)
 	return to_mnt_ns(get_proc_ns(dentry->d_inode));
 }
 
-static bool mnt_ns_loop(struct dentry *dentry)
+static bool mnt_ns_loop_target(struct dentry *dentry,
+			       struct mnt_namespace *target_mnt_ns)
 {
 	/* Could bind mounting the mount namespace inode cause a
 	 * mount namespace loop?
@@ -2212,7 +2213,12 @@ static bool mnt_ns_loop(struct dentry *dentry)
 	if (!mnt_ns)
 		return false;
 
-	return current->nsproxy->mnt_ns->ns.ns_id >= mnt_ns->ns.ns_id;
+	return target_mnt_ns->ns.ns_id >= mnt_ns->ns.ns_id;
+}
+
+static bool mnt_ns_loop(struct dentry *dentry)
+{
+	return mnt_ns_loop_target(dentry, current->nsproxy->mnt_ns);
 }
 
 struct mount *copy_tree(struct mount *src_root, struct dentry *dentry,
@@ -2423,10 +2429,11 @@ static bool __has_children(struct mount *mnt, struct dentry *dentry)
  *
  * locks: mount_locked_reader || namespace_shared && pinned(subtree)
  */
-static bool check_for_nsfs_mounts(struct mount *subtree)
+static bool check_for_nsfs_mounts(struct mount *subtree,
+				  struct mnt_namespace *target_mnt_ns)
 {
 	for (struct mount *p = subtree; p; p = next_mnt(p, subtree))
-		if (mnt_ns_loop(p->mnt.mnt_root))
+		if (mnt_ns_loop_target(p->mnt.mnt_root, target_mnt_ns))
 			return false;
 	return true;
 }
@@ -2464,7 +2471,7 @@ struct vfsmount *clone_private_mount(const struct path *path)
 		if (!anon_ns_root(old_mnt))
 			return ERR_PTR(-EINVAL);
 
-		if (!check_for_nsfs_mounts(old_mnt))
+		if (!check_for_nsfs_mounts(old_mnt, current->nsproxy->mnt_ns))
 			return ERR_PTR(-EINVAL);
 	}
 
@@ -2564,12 +2571,15 @@ int count_mounts(struct mnt_namespace *ns, struct mount *mnt)
 enum mnt_tree_flags_t {
 	MNT_TREE_BENEATH = BIT(0),
 	MNT_TREE_PROPAGATION = BIT(1),
+	MNT_TREE_MNTNS = BIT(2),
+	MNT_TREE_MNTNS_INIT = BIT(3),
 };
 
 /**
  * attach_recursive_mnt - attach a source mount tree
  * @source_mnt: mount tree to be attached
  * @dest:	the context for mounting at the place where the tree should go
+ * @move_mntns:	whether @source_mnt is attached via MOVE_MOUNT_T_MNTNS
  *
  *  NOTE: in the table below explains the semantics when a source mount
  *  of a given type is attached to a destination mount of a given type.
@@ -2632,7 +2642,8 @@ enum mnt_tree_flags_t {
  *         Otherwise a negative error code is returned.
  */
 static int attach_recursive_mnt(struct mount *source_mnt,
-				const struct pinned_mountpoint *dest)
+				const struct pinned_mountpoint *dest,
+				bool move_mntns)
 {
 	struct mount *dest_mnt = dest->parent;
 	struct mountpoint *dest_mp = dest->mp;
@@ -2641,6 +2652,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	struct user_namespace *user_ns = ns->user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
+	struct mnt_namespace *src_ns;
 	struct mount *child, *p;
 	struct mount *top;
 	struct hlist_node *n;
@@ -2662,6 +2674,7 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 		user_ns = current->nsproxy->mnt_ns->user_ns;
 	else
 		user_ns = ns->user_ns;
+	src_ns = moving ? NULL : source_mnt->mnt_ns;
 
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
@@ -2694,6 +2707,12 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 	if (err)
 		goto out_cleanup_ids;
 
+	if (move_mntns && src_ns && src_ns->user_ns != user_ns) {
+		lock_mnt_tree(source_mnt);
+		if (list_empty(&source_mnt->mnt_expire))
+			source_mnt->mnt.mnt_flags |= MNT_LOCKED;
+	}
+
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
 			set_mnt_shared(p);
@@ -2937,7 +2956,7 @@ static int graft_tree(struct mount *mnt, const struct pinned_mountpoint *mp)
 	      d_is_dir(mnt->mnt.mnt_root))
 		return -ENOTDIR;
 
-	return attach_recursive_mnt(mnt, mp);
+	return attach_recursive_mnt(mnt, mp, false);
 }
 
 static int may_change_propagation(const struct mount *m)
@@ -3131,7 +3150,7 @@ static int do_loopback(const struct path *path, const char *old_name,
 		return PTR_ERR(mnt);
 
 	/* the copy may carry mount namespace files from below the source */
-	if (recurse && !check_for_nsfs_mounts(mnt))
+	if (recurse && !check_for_nsfs_mounts(mnt, current->nsproxy->mnt_ns))
 		err = -EINVAL;
 	else
 		err = graft_tree(mnt, &mp);
@@ -3776,9 +3795,11 @@ static inline bool may_use_mount(struct mount *mnt)
 
 static int do_move_mount(const struct path *old_path,
 			 const struct path *new_path,
-			 enum mnt_tree_flags_t flags)
+			 enum mnt_tree_flags_t flags,
+			 struct mnt_namespace *target_mnt_ns)
 {
 	struct mount *old = real_mount(old_path->mnt);
+	struct mnt_namespace *dest_mnt_ns;
 	int err;
 	bool beneath = flags & MNT_TREE_BENEATH;
 
@@ -3792,7 +3813,23 @@ static int do_move_mount(const struct path *old_path,
 	if (IS_ERR(mp.parent))
 		return PTR_ERR(mp.parent);
 
-	if (check_mnt(old)) {
+	if (flags & MNT_TREE_MNTNS) {
+		if (!anon_ns_root(old) || old->mnt_ns == mp.parent->mnt_ns ||
+		    mp.parent->mnt_ns != target_mnt_ns)
+			return -EINVAL;
+		if (flags & MNT_TREE_MNTNS_INIT) {
+			if (mp.parent != target_mnt_ns->root)
+				return -EBUSY;
+		} else if (mp.mp->m_dentry == mp.parent->mnt.mnt_root) {
+			const struct mount *m = mp.parent;
+
+			while (m != target_mnt_ns->root && mnt_has_parent(m) &&
+			       m->mnt_mountpoint == m->mnt_parent->mnt.mnt_root)
+				m = m->mnt_parent;
+			if (m == target_mnt_ns->root)
+				return beneath ? -EINVAL : -EBUSY;
+		}
+	} else if (check_mnt(old)) {
 		/* if the source is in our namespace... */
 		/* ... it should be detachable from parent */
 		if (!mnt_has_parent(old) || IS_MNT_LOCKED(old))
@@ -3840,12 +3877,14 @@ static int do_move_mount(const struct path *old_path,
 	 */
 	if (IS_MNT_SHARED(mp.parent) && tree_contains_unbindable(old))
 		return -EINVAL;
-	if (!check_for_nsfs_mounts(old))
+	dest_mnt_ns = is_anon_ns(mp.parent->mnt_ns) ?
+		      current->nsproxy->mnt_ns : mp.parent->mnt_ns;
+	if (!check_for_nsfs_mounts(old, dest_mnt_ns))
 		return -ELOOP;
 	if (mount_is_ancestor(old, mp.parent))
 		return -ELOOP;
 
-	return attach_recursive_mnt(old, &mp);
+	return attach_recursive_mnt(old, &mp, flags & MNT_TREE_MNTNS);
 }
 
 static int do_move_mount_old(const struct path *path, const char *old_name)
@@ -3860,7 +3899,7 @@ static int do_move_mount_old(const struct path *path, const char *old_name)
 	if (err)
 		return err;
 
-	return do_move_mount(&old_path, path, 0);
+	return do_move_mount(&old_path, path, 0, NULL);
 }
 
 /*
@@ -4740,7 +4779,8 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
 
 static inline int vfs_move_mount(const struct path *from_path,
 				 const struct path *to_path,
-				 enum mnt_tree_flags_t mflags)
+				 enum mnt_tree_flags_t mflags,
+				 struct mnt_namespace *target_mnt_ns)
 {
 	int ret;
 
@@ -4751,7 +4791,123 @@ static inline int vfs_move_mount(const struct path *from_path,
 	if (mflags & MNT_TREE_PROPAGATION)
 		return do_set_group(from_path, to_path);
 
-	return do_move_mount(from_path, to_path, mflags);
+	return do_move_mount(from_path, to_path, mflags, target_mnt_ns);
+}
+
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
+ * DOC: MOVE_MOUNT_T_MNTNS
+ *
+ * ``MOVE_MOUNT_T_MNTNS`` installs detached anonymous mount trees into a target
+ * mount namespace ``nsfs`` file descriptor supplied as ``to_dfd``:
+ *
+ * 1. ``to_pathname`` of ``"/"`` attaches the initial root mount onto the
+ *    ``nullfs`` root of an empty mount namespace at most once.
+ *
+ * 2. Relative ``to_pathname`` values resolve beneath the live root of the
+ *    target mount namespace.
+ *
+ * Capability is checked against ``CAP_SYS_ADMIN`` in the target mount
+ * namespace's owning user namespace, and source trees crossing user namespace
+ * boundaries are locked with ``MNT_LOCKED`` and locked mount flags.
+ */
+static int move_mount_mntns(int from_dfd, const char __user *from_pathname,
+			    int to_dfd, const char __user *to_pathname,
+			    unsigned int flags, enum mnt_tree_flags_t mflags)
+{
+	struct path from_path __free(path_put) = {};
+	struct path to_path __free(path_put) = {};
+	struct mnt_namespace *target_mnt_ns;
+	unsigned int lflags;
+	struct ns_common *ns;
+	bool is_root;
+	int ret;
+
+	CLASS(filename_maybe_null, to_name)(to_pathname, AT_EMPTY_PATH);
+	if (IS_ERR(to_name))
+		return PTR_ERR(to_name);
+	if (!to_name)
+		return -EINVAL;
+
+	CLASS(fd, f_mntns)(to_dfd);
+	if (fd_empty(f_mntns))
+		return -EBADF;
+	if (!proc_ns_file(fd_file(f_mntns)))
+		return -EINVAL;
+
+	ns = get_proc_ns(file_inode(fd_file(f_mntns)));
+	if (ns->ns_type != CLONE_NEWNS)
+		return -EINVAL;
+
+	target_mnt_ns = to_mnt_ns(ns);
+	if (is_anon_ns(target_mnt_ns))
+		return -EINVAL;
+	if (!ns_capable(target_mnt_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	is_root = to_name->name[0] == '/' && to_name->name[1] == '\0';
+	if (is_root) {
+		if (flags & MOVE_MOUNT_BENEATH)
+			return -EINVAL;
+
+		to_path.mnt = mntget(&target_mnt_ns->root->mnt);
+		to_path.dentry = dget(target_mnt_ns->root->mnt.mnt_root);
+		mflags |= MNT_TREE_MNTNS_INIT;
+	} else {
+		struct path mntns_root __free(path_put) = {};
+
+		if (to_name->name[0] == '/')
+			return -EINVAL;
+
+		ret = mnt_ns_get_root(target_mnt_ns, &mntns_root);
+		if (ret)
+			return ret;
+
+		lflags = LOOKUP_IN_ROOT;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
+		ret = filename_lookup(AT_FDCWD, to_name, lflags, &to_path,
+				      &mntns_root);
+		if (ret)
+			return ret;
+	}
+
+	ret = lookup_move_mount_from(from_dfd, from_pathname, flags,
+				     &from_path);
+	if (ret)
+		return ret;
+
+	return vfs_move_mount(&from_path, &to_path, mflags | MNT_TREE_MNTNS,
+			      target_mnt_ns);
 }
 
 /*
@@ -4773,7 +4929,7 @@ SYSCALL_DEFINE5(move_mount,
 	enum mnt_tree_flags_t mflags = 0;
 	int ret = 0;
 
-	if (!may_mount())
+	if (!(flags & MOVE_MOUNT_T_MNTNS) && !may_mount())
 		return -EPERM;
 
 	if (flags & ~MOVE_MOUNT__MASK)
@@ -4786,6 +4942,13 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
 
+	if (unlikely(flags & MOVE_MOUNT_T_MNTNS)) {
+		if (flags & (MOVE_MOUNT_T_EMPTY_PATH | MOVE_MOUNT_SET_GROUP))
+			return -EINVAL;
+		return move_mount_mntns(from_dfd, from_pathname,
+					to_dfd, to_pathname, flags, mflags);
+	}
+
 	uflags = 0;
 	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
 		uflags = AT_EMPTY_PATH;
@@ -4809,29 +4972,12 @@ SYSCALL_DEFINE5(move_mount,
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
 
-	return vfs_move_mount(&from_path, &to_path, mflags);
+	return vfs_move_mount(&from_path, &to_path, mflags, NULL);
 }
 
 /*
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
index cb55cfcfc92e..7fa93de08ceb 100644
--- a/include/uapi/linux/mount.h
+++ b/include/uapi/linux/mount.h
@@ -75,9 +75,10 @@
 #define MOVE_MOUNT_T_SYMLINKS		0x00000010 /* Follow symlinks on to path */
 #define MOVE_MOUNT_T_AUTOMOUNTS		0x00000020 /* Follow automounts on to path */
 #define MOVE_MOUNT_T_EMPTY_PATH		0x00000040 /* Empty to path permitted */
+#define MOVE_MOUNT_T_MNTNS		0x00000080 /* Resolve to_dfd as mntns fd */
 #define MOVE_MOUNT_SET_GROUP		0x00000100 /* Set sharing group instead */
 #define MOVE_MOUNT_BENEATH		0x00000200 /* Mount beneath top mount */
-#define MOVE_MOUNT__MASK		0x00000377
+#define MOVE_MOUNT__MASK		0x000003f7
 
 /*
  * fsopen() flags.
-- 
2.47.3


