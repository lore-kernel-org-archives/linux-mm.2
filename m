Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5D0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:37:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390BA6B009F; Tue,  7 Jul 2026 15:37:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367FD6B00A0; Tue,  7 Jul 2026 15:37:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2307D6B00A1; Tue,  7 Jul 2026 15:37:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8A4C6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4799140573
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:16 +0000 (UTC)
X-FDA: 84962989272.01.491F344
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90CE1120007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IypPmUbs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfZlSfQ3Fv3HmDxCHURVjrGU4Ov6As4pO2JoW8DP2To=;
	b=hf9949i3wS71GbC7800ALXQB4aS5lemkZPekNSk0aznJ4Gi/uM1uITzwzUGj/spGQujEfq
	bCU7Mc7Jw7RTLs3+h7+35Zv1a4DTDgudN3Zyomr4VyFD8iWfC505sSjZUZMZQklh9wZEvh
	8zZxsm1F4LzYAFM3NUHE1IyM0mh2If8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IypPmUbs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453034;
	b=EQsMhFK7lpnyU4dZdfEthdbmJ33uTQAYLGBC6SnipHuwD23X4L/V4p3KC1KwAbezhPNUgx
	5Ibte+XvpnXW+y3DN5VVQ/qeWuBGwCDs/ZDjMaBy5RQ2GAxkJj6/IgGLyToFwGNStbuT/O
	qdyFu68TFeHoeVyt3393eAvzZSFbKaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03D9061896;
	Tue,  7 Jul 2026 19:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02AE1F000E9;
	Tue,  7 Jul 2026 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453033;
	bh=WfZlSfQ3Fv3HmDxCHURVjrGU4Ov6As4pO2JoW8DP2To=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IypPmUbstyxEwzJFQCJ4McjGkHKODRpbgD1J+bedDh58ah+UVuwraZEpiGaXgh4j1
	 nnBCn3Zsy20XbS1nX3AsEiiuncCRvM9WE8xKcTzYjiPNezH5KhSecl4+BZAOxxsO7p
	 2XB+ViX5GEoyEsmbiqLID3+ARFd08FAx5ODxNwyr+s2ky4FyHwCR4Fe9J74MR3tBCP
	 ACYFiL/2CiZcMggKhrJBWBzSnwAdPUnQi/6x/I5/WsNCrPUe2w0ZcqxYrwVwSm5THW
	 fYhf1TJ64GQgOjaI+bAne+b2LutU8YrbKIg1yzYT0GG5wR5DX/gKZHWF8WebD3PPL8
	 +Fu3FYKrAYIhw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 07 Jul 2026 21:36:46 +0200
Subject: [PATCH RFC POC 2/4] binfmt_misc: add binfmt_misc_ops bpf
 struct_ops
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-work-bpf-binfmt_misc-v1-2-74b995c84ec1@kernel.org>
References: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
In-Reply-To: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 jannh@google.com, linux-mm@kvack.org, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=13800; i=brauner@kernel.org;
 h=from:subject:message-id; bh=a5r2YAYg3gONzXW7niZTSsCx4zOJtyZ/oaHrNqdiwtE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hiZcsX14xPzBueNrul6vsEq33lB6OZJd47W0cvidq
 ukuDBn2HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPxUGBk2K072Xq9w+J7ZZxb
 mz4zCDeZVTgmRnZciQ6757zIvSR4KsMv5kv1iXXVTWd0L3k2VF86zKd70a707Q1N+5PnO5fpBc1
 jAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90CE1120007
X-Stat-Signature: w8fshipeuqf737sfura15jk3zobaegzw
X-HE-Tag: 1783453034-323151
X-HE-Meta: U2FsdGVkX1/yH1T2iJOyITdPbBEuFZ7atOR4HEG1tkax5Q/Xx/5koeWFesTzrwxDYDAt8ZU2LicuWc93h3QTmgJVagKQcM5jzn3W/E2bbeK+UD0E5spE+rj7KpWrgq4tz0jVKDgCBnO6x10DVuTPsI6xgnKVuUCAUTa72zJzsrk/RwrKvcIMstT989Jljwx+Zrhv19eL3iPyfUZqxzchPGrRDuVA950W3nT5B2j7smMvTPlL8jfJlHKM0Mj1YrqzIcwjSold7uEWIIoN2nTO6EWifgqj+iR50mqD6OBGKaYSTZy42i7flDXtjM88LIVksBT+R5gIo5zlLvK+d4PzowqM1hTU+7VkRkygoqWdnmHH184Bu89xulvv8DMh1mvQcQomZE7ExFKcm9fbrLXa5CxD+u+HK/CzVn2+7bdtyWJzLSubeTmqAT7JNsDu1n7TBg57gFkeOnWe5yvbLS3rUVsB4d6wRkqDdRSasrdqL2dTs1uMQMknCv+3GZKuDAsXL4oSag5pdsoT9BObz7cWLdojJk9/DAmhnRbAN89ZDOxeGBO9PWzOtv+xF1nTYw6G3SFYsfhq17kE8SZM1hNUTX+5FY8+tQMyC8Dz4tNq4Hm4E8NszEPUrGegESbYAee7YbmqjhL00E59UIS0pS5Axb1+K/k5t0RAzrvxRB4kKgX2f6FhFFaENOPQwJJjsLPYMtf4AbizmpKSBsuBPo/AiNIFUNVQ5T6ws5Iu303bsVnK/tv8gae8+uleRePeuQ6cFEMdI5MYaTaaXOEnBd3PaLWqXdAoSlc5h4qbtwPZ91dvwSSMgvzK61GZ+rryIxoBfQhJbIcpzz580AlVUAIpW1Z2b3AzsF5NhLK8wNKwqJa7McQdViXMy0Aw6bwUvZnrpqM7u5JpDn3rG/VTBj6wIIzdrU1D/kpyfiOr88TwdXUtKkEaT+KcGcuaL+0tD5XnrqfVwfIdnlDgOR1OdIY
 xatm2Y9p
 Lrd7PXcJoQiNcRJOkN9kT1MxRS/ArRzY7R7YTyWeJ+stz2zpof+zgLokgb7HhzgNI3vHQe1zJY8jE9dEmd6elRxfUWj6+5CoNedKMNRffxOZ9HPUP4Fh44UymdvjUrRT/6oOGmcpRKhmBqryhZrgMm4c8QLxss7xSUtrYRBdsTye9XktUw5eG2LbuwKM4Ip8dhFIbx2QEN4OxzyeaPIjOfwRhU0+SzJAZbOAEENLsYWwgiPaYAtOdGVZoiDEfpFzEGX9Oh0Bu8efEBVIlUBA7wfHQSZu6JTDlPHc3SgcUGcOorzN5Hk8FRvRDQwz7vi6+Iqe0+w/08TizsN0EZoNNSSOOEhVEpNvI2lrn+D8GEK1pRIOrK3L+o+WDokMYvwa7yRXWjBi3xGj/9bk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the bpf plumbing for binary type handlers whose matching and
interpreter selection are implemented by a bpf program instead of a
fixed magic/extension and a fixed interpreter string recorded at
registration time. This serves relocatable binary formats where the
interpreter must be computed per binary, e.g. relative to the location
of the binary itself, as discussed for hermetic Nix-style executables.

A handler is an instance of the new binfmt_misc_ops struct_ops with a
single op:

	int (*load)(struct linux_binprm *bprm);

and a name that binfmt_misc entries reference it by. struct_ops is the
sanctioned mechanism for this kind of user-supplied policy callback:
program types, attach types, and the uapi helper list are frozen, and
every recently added subsystem hook (bpf qdisc, SMC handshake control,
io_uring loop ops, sched_ext) is a struct_ops user. The op receives the
bprm as a trusted BTF pointer, so a program can match on the header in
bprm->buf, read arbitrary file content via bpf_dynptr_from_file() to
parse e.g. ELF program headers, and inspect the binary's location. No
dedicated program type, ctx blob, or uapi helper is needed.

The load program is required to be sleepable. Reliable file reads at
exec time fault in the file's pages; a non-sleepable program would be
limited to whatever happens to be resident in the page cache and would
fail sporadically on cold caches. This also constrains the caller:
binfmt_misc must invoke the op from sleepable context, which a later
patch takes care of.

The interpreter is selected through the new kfunc:

	int bpf_binprm_set_interp(struct linux_binprm *bprm,
				  const char *path, size_t path__sz);

which enforces an absolute path shorter than PATH_MAX and stages a copy
in the bprm. The bprm is exclusively owned by the task doing the exec,
so no shared or per-CPU state is involved and nothing here can race.
The kfunc is registered for struct_ops programs with a filter limiting
it to binfmt_misc_ops programs.

Registering an ops instance (updating the struct_ops map or attaching
its link) publishes the handler under its name in a registry keyed by
the registering task's user namespace. Lookups walk the user namespace
hierarchy upwards, mirroring how binfmt_misc instances themselves are
resolved in load_binfmt_misc(). Consumers take a reference on the ops
via bpf_struct_ops_get() which pins the underlying map and programs, so
an activated handler keeps working even if the map is deleted or the
registering container goes away; deregistration only prevents new
activations, exactly like unregistering a tcp congestion ops with live
users.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/Kconfig.binfmt           |  14 +++
 fs/Makefile                 |   1 +
 fs/binfmt_misc_bpf.c        | 275 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/binfmt_misc.h |  49 ++++++++
 4 files changed, 339 insertions(+)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7741..daeac4889d03 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -168,6 +168,20 @@ config BINFMT_MISC
 	  you have use for it; the module is called binfmt_misc. If you
 	  don't know what to answer at this point, say Y.
 
+config BINFMT_MISC_BPF
+	bool "BPF-selected interpreters for misc binaries"
+	depends on BINFMT_MISC=y
+	depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF
+	help
+	  Allow binfmt_misc binary type handlers to be implemented as bpf
+	  struct_ops programs. Instead of matching a fixed magic and
+	  redirecting to a fixed interpreter recorded at registration time
+	  such handlers match binaries programmatically and compute the
+	  interpreter to use per binary, e.g. relative to the location of
+	  the binary itself.
+
+	  If you don't know what to answer at this point, say N.
+
 config COREDUMP
 	bool "Enable core dump support" if EXPERT
 	default y
diff --git a/fs/Makefile b/fs/Makefile
index 89a8a9d207d1..499c6670f0c1 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_FS_ENCRYPTION)	+= crypto/
 obj-$(CONFIG_FS_VERITY)		+= verity/
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
+obj-$(CONFIG_BINFMT_MISC_BPF)	+= binfmt_misc_bpf.o
 obj-$(CONFIG_BINFMT_SCRIPT)	+= binfmt_script.o
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
new file mode 100644
index 000000000000..72da0964d949
--- /dev/null
+++ b/fs/binfmt_misc_bpf.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * BPF-backed binary type handlers for binfmt_misc.
+ *
+ * A handler is a struct binfmt_misc_ops struct_ops map. Loading and
+ * registering it makes the handler available under its name in the user
+ * namespace it was registered in. A binfmt_misc 'B' entry activates it:
+ *
+ *   echo ':entry:B:<handler-name>::::' > <binfmt_misc>/register
+ */
+
+#include <linux/binfmt_misc.h>
+#include <linux/binfmts.h>
+#include <linux/bpf.h>
+#include <linux/bpf_verifier.h>
+#include <linux/btf.h>
+#include <linux/btf_ids.h>
+#include <linux/cred.h>
+#include <linux/init.h>
+#include <linux/limits.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/user_namespace.h>
+
+struct bm_bpf_ops_reg {
+	struct list_head list;
+	const struct binfmt_misc_ops *ops;
+	struct bpf_link *link;
+	struct user_namespace *user_ns;
+};
+
+static DEFINE_MUTEX(bm_bpf_ops_lock);
+static LIST_HEAD(bm_bpf_ops_list);
+
+static struct bpf_struct_ops bpf_binfmt_misc_ops;
+
+static struct bm_bpf_ops_reg *bm_bpf_ops_find(const struct user_namespace *user_ns,
+					      const char *name)
+{
+	struct bm_bpf_ops_reg *reg;
+
+	lockdep_assert_held(&bm_bpf_ops_lock);
+
+	list_for_each_entry(reg, &bm_bpf_ops_list, list) {
+		if (reg->user_ns == user_ns && !strcmp(reg->ops->name, name))
+			return reg;
+	}
+	return NULL;
+}
+
+/**
+ * binfmt_misc_get_ops - look up a bpf binary type handler by name
+ * @user_ns: user namespace of the binfmt_misc instance
+ * @name: name the handler was registered under
+ *
+ * Search @user_ns and its ancestors for a handler named @name, mirroring
+ * the instance lookup in load_binfmt_misc(). The returned handler stays
+ * callable until binfmt_misc_put_ops() even if the backing struct_ops map
+ * is detached or deleted in the meantime.
+ *
+ * Return: the handler on success, NULL on failure
+ */
+const struct binfmt_misc_ops *binfmt_misc_get_ops(struct user_namespace *user_ns,
+						  const char *name)
+{
+	const struct user_namespace *ns;
+	struct bm_bpf_ops_reg *reg;
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	for (ns = user_ns; ns; ns = ns->parent) {
+		reg = bm_bpf_ops_find(ns, name);
+		if (!reg)
+			continue;
+		if (!bpf_struct_ops_get(reg->ops))
+			return NULL;
+		return reg->ops;
+	}
+	return NULL;
+}
+
+void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops)
+{
+	bpf_struct_ops_put(ops);
+}
+
+bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog)
+{
+	return prog->type == BPF_PROG_TYPE_STRUCT_OPS &&
+	       prog->aux->st_ops == &bpf_binfmt_misc_ops;
+}
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_binprm_set_interp - select the interpreter for the current exec
+ * @bprm: binary that is being executed
+ * @path: absolute path to the interpreter
+ * @path__sz: size of the @path buffer, including the terminating NUL
+ *
+ * To be called from the load program of a struct binfmt_misc_ops handler
+ * before returning a positive value. The path is opened with the
+ * credentials of the task doing the exec after the program returns.
+ *
+ * Return: 0 on success, a negative errno on failure
+ */
+__bpf_kfunc int bpf_binprm_set_interp(struct linux_binprm *bprm,
+				      const char *path, size_t path__sz)
+{
+	size_t len;
+	char *interp;
+
+	if (!path__sz)
+		return -EINVAL;
+	len = strnlen(path, path__sz);
+	if (len == path__sz)
+		return -EINVAL;
+	if (path[0] != '/')
+		return -EINVAL;
+	if (len >= PATH_MAX)
+		return -ENAMETOOLONG;
+
+	interp = kmemdup_nul(path, len, GFP_KERNEL);
+	if (!interp)
+		return -ENOMEM;
+
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = interp;
+	return 0;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(bm_bpf_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_binprm_set_interp, KF_SLEEPABLE)
+BTF_KFUNCS_END(bm_bpf_kfunc_ids)
+
+static int bm_bpf_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_id)
+{
+	if (!btf_id_set8_contains(&bm_bpf_kfunc_ids, kfunc_id))
+		return 0;
+	if (bpf_prog_is_binfmt_misc_ops(prog))
+		return 0;
+	return -EACCES;
+}
+
+static const struct btf_kfunc_id_set bm_bpf_kfunc_set = {
+	.owner	= THIS_MODULE,
+	.set	= &bm_bpf_kfunc_ids,
+	.filter	= bm_bpf_kfunc_filter,
+};
+
+static int bm_bpf_ops__load(struct linux_binprm *bprm)
+{
+	return 0;
+}
+
+static struct binfmt_misc_ops bm_bpf_ops_stubs = {
+	.load = bm_bpf_ops__load,
+};
+
+static int bm_bpf_init(struct btf *btf)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					 &bm_bpf_kfunc_set);
+}
+
+static int bm_bpf_check_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       const struct bpf_prog *prog)
+{
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct binfmt_misc_ops, load):
+		/* Reliable file reads at exec time require sleeping. */
+		if (!prog->sleepable)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
+static int bm_bpf_init_member(const struct btf_type *t,
+			      const struct btf_member *member,
+			      void *kdata, const void *udata)
+{
+	const struct binfmt_misc_ops *uops = udata;
+	struct binfmt_misc_ops *ops = kdata;
+	u32 moff = __btf_member_bit_offset(t, member) / 8;
+
+	switch (moff) {
+	case offsetof(struct binfmt_misc_ops, name):
+		if (bpf_obj_name_cpy(ops->name, uops->name,
+				     sizeof(ops->name)) <= 0)
+			return -EINVAL;
+		return 1;
+	}
+	return 0;
+}
+
+static int bm_bpf_validate(void *kdata)
+{
+	struct binfmt_misc_ops *ops = kdata;
+
+	if (!ops->load)
+		return -EINVAL;
+	return 0;
+}
+
+static int bm_bpf_reg(void *kdata, struct bpf_link *link)
+{
+	struct binfmt_misc_ops *ops = kdata;
+	struct bm_bpf_ops_reg *reg;
+
+	reg = kzalloc_obj(*reg, GFP_KERNEL_ACCOUNT);
+	if (!reg)
+		return -ENOMEM;
+
+	reg->ops = ops;
+	reg->link = link;
+	reg->user_ns = get_user_ns(current_user_ns());
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	if (bm_bpf_ops_find(reg->user_ns, ops->name)) {
+		put_user_ns(reg->user_ns);
+		kfree(reg);
+		return -EEXIST;
+	}
+
+	list_add(&reg->list, &bm_bpf_ops_list);
+	return 0;
+}
+
+static void bm_bpf_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bm_bpf_ops_reg *reg;
+
+	guard(mutex)(&bm_bpf_ops_lock);
+
+	list_for_each_entry(reg, &bm_bpf_ops_list, list) {
+		if (reg->ops == kdata && reg->link == link) {
+			list_del(&reg->list);
+			put_user_ns(reg->user_ns);
+			kfree(reg);
+			return;
+		}
+	}
+}
+
+static const struct bpf_verifier_ops bm_bpf_verifier_ops = {
+	.get_func_proto		= bpf_base_func_proto,
+	.is_valid_access	= bpf_tracing_btf_ctx_access,
+};
+
+static struct bpf_struct_ops bpf_binfmt_misc_ops = {
+	.verifier_ops	= &bm_bpf_verifier_ops,
+	.init		= bm_bpf_init,
+	.check_member	= bm_bpf_check_member,
+	.init_member	= bm_bpf_init_member,
+	.validate	= bm_bpf_validate,
+	.reg		= bm_bpf_reg,
+	.unreg		= bm_bpf_unreg,
+	.cfi_stubs	= &bm_bpf_ops_stubs,
+	.name		= "binfmt_misc_ops",
+	.owner		= THIS_MODULE,
+};
+
+static int __init bm_bpf_struct_ops_init(void)
+{
+	return register_bpf_struct_ops(&bpf_binfmt_misc_ops, binfmt_misc_ops);
+}
+late_initcall(bm_bpf_struct_ops_init);
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
new file mode 100644
index 000000000000..e1d26c4301da
--- /dev/null
+++ b/include/linux/binfmt_misc.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BINFMT_MISC_H
+#define _LINUX_BINFMT_MISC_H
+
+#include <linux/types.h>
+
+struct bpf_prog;
+struct linux_binprm;
+struct user_namespace;
+
+#define BINFMT_MISC_OPS_NAME_MAX 16
+
+/**
+ * struct binfmt_misc_ops - bpf-backed binary type handler
+ * @load: match @bprm and select an interpreter via bpf_binprm_set_interp();
+ *        returns > 0 if the binary was handled, 0 to fall through to the
+ *        handlers registered after this one, a negative errno to fail the
+ *        exec; -ENOEXEC does not fail the exec but moves on to the
+ *        remaining binary formats
+ * @name: name that 'B' entries reference the handler by
+ */
+struct binfmt_misc_ops {
+	int (*load)(struct linux_binprm *bprm);
+	char name[BINFMT_MISC_OPS_NAME_MAX];
+};
+
+#ifdef CONFIG_BINFMT_MISC_BPF
+const struct binfmt_misc_ops *binfmt_misc_get_ops(struct user_namespace *user_ns,
+						  const char *name);
+void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops);
+bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog);
+#else
+static inline const struct binfmt_misc_ops *
+binfmt_misc_get_ops(struct user_namespace *user_ns, const char *name)
+{
+	return NULL;
+}
+
+static inline void binfmt_misc_put_ops(const struct binfmt_misc_ops *ops)
+{
+}
+
+static inline bool bpf_prog_is_binfmt_misc_ops(const struct bpf_prog *prog)
+{
+	return false;
+}
+#endif /* CONFIG_BINFMT_MISC_BPF */
+
+#endif /* _LINUX_BINFMT_MISC_H */

-- 
2.53.0


