Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DD70C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:37:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A463E6B00A0; Tue,  7 Jul 2026 15:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E9B6B00A1; Tue,  7 Jul 2026 15:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934A56B00A2; Tue,  7 Jul 2026 15:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAA86B00A0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ABA5E40578
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:19 +0000 (UTC)
X-FDA: 84962989398.24.16C539A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C6C231C000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgX2XPMd;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7H+nuLsu/xLrsPGwGk2H34dZOFArN4uMoNlNdacm5v8=;
	b=YDU19qkxrlpDBv76y1KpkMX++XHgDQXNZj2cR1xotlB9q2ud8Oq+sr2Q13kG7UAn7Kdpat
	i+8Y81SX3lBOCxgxudXjak4yFFMGTWc8zZeWioppULXzFKbV754xz40kmew4ABnDAQdLn/
	vPxU/BBr6Nh4Sv+rC4wp7k7Dwgy9x4s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NgX2XPMd;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453037;
	b=jt6At38KSZlIm6+SetQBy9Y+mQbBnOIbrIMZQ0rgAP7x01ol6ykkTyFxqpb3Yl+aRsnBfW
	wDXTfG7ikQ3JhGiZAxeyb2BsxiLIGLyL0xJjdx/B+zqyRd7BXG3h9x5lHXB1G28j1f7JrR
	hIL5+FCnF8bEsJH+97tR0lPbuijOr2U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 108E743F60;
	Tue,  7 Jul 2026 19:37:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2604B1F00A3A;
	Tue,  7 Jul 2026 19:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453036;
	bh=7H+nuLsu/xLrsPGwGk2H34dZOFArN4uMoNlNdacm5v8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NgX2XPMdQkoWHrASfo053PJ9DQD2Lx4hfIYNacOsyE+8QheFrJrZrS0xitm7c6bYx
	 fq/HF1WVMEVWIfZLanNQWuBqeOvyY9yPP2qcdmxPKjfkGLROE1YRzezAvLJiknxuBz
	 ChGxm7SFRVZv9qyg0/EIrgsuzmwzPN0o9qRh2sL29n3loFffUYqpTwY3pmmqc2mU75
	 3ae8iaMLjjh2q9Uv28pELa0lpNokXSefnJ1pnQDGeRqNHLprnXIG+yTOp9ZdgGMlX8
	 dtLEEnQYIHMI+9ef8eUVQBn2kFb9ATx53MLCD1UXIQy8zH4YRK/lTZ7dCVVUu5WpOY
	 rG+O/WmVWTvEA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 07 Jul 2026 21:36:47 +0200
Subject: [PATCH RFC POC 3/4] binfmt_misc: wire up bpf-backed 'B' entries
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-work-bpf-binfmt_misc-v1-3-74b995c84ec1@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=15992; i=brauner@kernel.org;
 h=from:subject:message-id; bh=c2bxGFoxQxDhi2AAos8sEU+11LFeMkVJChF5CpobtPQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hib4XYszVViuuXGC39NdOg5SYoWL79n/CpiRV7fJS
 3Lj+vQbHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPJmsPIsPOO++WM6qUveNRl
 XyRLJzruyWI8djko65F/Atf5QkH/ZYwMy25v1H23O3HpvB8h11tniqckiJglubCW/GvV41qbG8j
 KAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C6C231C000B
X-Stat-Signature: mun9zmi888ocwzszdpkq4j61n8iyy3x9
X-HE-Tag: 1783453037-921235
X-HE-Meta: U2FsdGVkX19AyLE9tJ7k4tXHsOUCJVAp81cnpo0ciKverK6B8xVvucPHArELwxD9eTTum81zPow0t3jejPGn3ntmQ73TJvkqdBQB90Xr9kyPaWVbrAa5ZmaavRc7Atkhs/REohGQAaPq7TokZL01IPffpAapfAvIl5qbt8l7CvzwXaG7hx4EOwMPCHFxH8Cqzx0kBDn/2VmTKgYKajQvVJ2DdCZbk2iNuoBqkVb+8R6ujHJTWtaCt5mEI192jt3MZo5lQZDMnKvwZqg96iPEOvLVs54LJ3HDAOOE4SM/jYqUWTSNe7+e2kZv/dS8fyiulL5Y8dlM2qTMK9oHnanZq32wlrk5EppqT21+3UYsxaXrTL2zF5RQyg2uWdeLpFKinRpAwtR7pu+QX+aTSA71Yd68aUcg2M3tBsVZ1qUywdwCkIuxyLWqZ7pk24bqBhYO++4cIG++3aiH4veqhAAxymEPq+2YwCrwM60clvbR0J9kDPJYfcMKFzTsbpizkmTg+RmKA0c5bYqlP1CKREXDM4pV3Br651JZ6kP84b5XOshoMzrdWK74KjvTkAkmWqennzR1MrNzjGiSXglCzL9Tr5UNgbma/R3RGh4Pn9ZN/8dq9MAx9ZAQZcEXwvIZGFCj4FQGirlwXhhjr1vZfGU6FyzBXjQgIl8LpsrkNWy3X4PVfwUUIZQoFnllD0IgTisr1CssvCIQe2k6Ehx5zapDUbET+QApwXjqlbQ2OfOq7+mZmQee2m0b88spiLite5MmSNWWzyZuWKN+G8D1a65qc1gughHLHQ75OOLA+lWxyqKyCRw2DUb6SYeGxtK9I0PTNYYU5bolP+J22ARduUGXioJJ8PquvPzcrhNtyOSCdHuK/hgpUnK4TehDhNkz5VLXy8pEuzZg585fsRGrdbEPA3Rium36CkuaVcUrJSgDSYYAJylR7ZqhvvZRHP6UKd2IygHnHNL53t9UiiiuN0j
 MrtJbWdy
 qsnMal4Lx6SIr7tiGehM/2yQu/UV6ttALzIqKGpRzbdEjhIVc89UojrTSlS30yS/Xi0bJB7oJtA7nBCG3tsWuS5rVQt1ebGkma+TkGyxFZKlH8T0HYioxtB41AjE5eAzX0P2+BEC+qYyhcntcJHL4NmiIvCMQQA1yG391X27cpNMn2T1VGuBLnTpVBmJzGYraBNyxpu6uWwqcUT7zt+VZRCn2JO8a129y6L2urDtaiqKZIHPMztpov+3wmHBz/QDQ6L0Q3tWAESf4imWjYApj/VUTLfyP+mG2INxTKMeEHz3mxBTrCxx7JI2EWviveUK4Qu32BhaMvXAY5TorzMZ8Tygk5w49rU7UPWv+KFMO8g/DOGuQzyusHGlW4ab1zcjpYK1qbd5GDOclTpjNfEQ+KOHs/2lwfrvlKG21
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Activate a registered binfmt_misc_ops handler through the existing text
interface with the new 'B' entry type:

	echo ':name:B:<handler-name>::::' > <binfmt_misc>/register

The offset field carries the handler name; magic, mask, and interpreter
must be empty since the program supplies both the matching and the
interpreter. Reusing the register file keeps the existing permission
model intact: activating a handler requires the same write access to a
binfmt_misc instance as any other registration, and the per user
namespace instance semantics apply unchanged. A 'B' entry in a
container's own instance shadows the host's handlers just like any
other entry, and the privilege needed to shadow e.g. all ELF binaries
is the same as for a static 'M' entry matching \x7fELF today; the only
novelty is that matching becomes programmable.

The entry takes its own reference on the ops for its whole lifetime.
It is dropped in put_binfmt_handler() next to the MISC_FMT_OPEN_FILE
interp_file cleanup, which the existing users refcount already defers
past any concurrent load_misc_binary(), and explicitly on the
registration failure path where the users refcount is not live yet.

The program runs from load_misc_binary(), never from the matching walk
under entries_lock: the read_lock disables preemption while the load
program must be able to sleep to read file content. search_binfmt_handler()
therefore only nominates the next enabled 'B' entry and the program
decides outside the lock. A declining program (returning 0) falls
through to handlers registered after it via a skip cursor and a rescan;
entries registered or removed between rescans can shift the cursor, so
a program may be consulted twice in that window, which is harmless
since matching must be free of side effects. Returning a positive value
without having selected an interpreter terminates the binfmt_misc scan
with -ENOEXEC so the remaining binary formats still get a shot.

The 'C' and 'F' flags are rejected for 'B' entries. 'F' exists to
pre-open a fixed interpreter at registration time in the registrar's
context which is meaningless for a per-exec computed path. 'C' honors
the suid bits of the matched binary while executing the interpreter;
combined with a program-chosen interpreter that would let a user
namespace root pick what runs with a setuid binary's credentials. The
computed path itself cannot widen access: it is opened with open_exec()
under the caller's credentials with the usual LSM and noexec checks,
identical to a statically registered interpreter.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  40 ++++++++-
 fs/binfmt_misc.c                          | 143 +++++++++++++++++++++++++++---
 2 files changed, 168 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index c0a34fbf8022..c0efb0773628 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -26,11 +26,13 @@ Here is what the fields mean:
    name below ``/proc/sys/fs/binfmt_misc``; cannot contain slashes ``/`` for
    obvious reasons.
 - ``type``
-   is the type of recognition. Give ``M`` for magic and ``E`` for extension.
+   is the type of recognition. Give ``M`` for magic, ``E`` for extension and
+   ``B`` for a bpf-backed handler (see below).
 - ``offset``
    is the offset of the magic/mask in the file, counted in bytes. This
    defaults to 0 if you omit it (i.e. you write ``:name:type::magic...``).
-   Ignored when using filename extension matching.
+   Ignored when using filename extension matching. For ``B`` entries this
+   field carries the name of the bpf handler instead.
 - ``magic``
    is the byte sequence binfmt_misc is matching for. The magic string
    may contain hex-encoded characters like ``\x0a`` or ``\xA4``. Note that you
@@ -97,6 +99,40 @@ There are some restrictions:
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
 
+
+bpf-backed handlers
+-------------------
+
+With ``CONFIG_BINFMT_MISC_BPF`` both the matching and the interpreter
+selection can be delegated to a bpf program. A handler is an instance of the
+``binfmt_misc_ops`` struct_ops with a sleepable ``load`` program and a
+``name``. Once the struct_ops map is registered the handler can be activated
+with a ``B`` entry that references it by name and carries neither magic,
+mask, nor interpreter::
+
+    echo ':qemu:B:my_handler::::' > register
+
+At exec time the ``load`` program receives the ``linux_binprm`` of the
+binary. It can match on the header in ``bprm->buf``, read the file itself,
+e.g. to parse ELF program headers, and derive the interpreter from the
+binary's location. It selects the interpreter by calling the
+``bpf_binprm_set_interp()`` kfunc with an absolute path and returning a
+positive value. Returning ``0`` falls through to the handlers registered
+after this one, a negative errno fails the exec with that error;
+``-ENOEXEC`` ends the binfmt_misc search but lets the remaining binary
+formats have a go. The interpreter is opened with the credentials of the
+task doing the exec, exactly as a statically registered interpreter would
+be.
+
+Handlers are looked up in the user namespace the struct_ops map was
+registered in, falling back to ancestor namespaces, mirroring how
+binfmt_misc instances themselves are looked up. The entry keeps the handler
+alive; deleting the struct_ops map only prevents new registrations.
+
+The ``C`` and ``F`` flags cannot be combined with ``B`` entries: there is no
+fixed interpreter to pre-open and a program-selected interpreter must never
+inherit the credentials of a setuid binary.
+
 To use binfmt_misc you have to mount it first. You can mount it with
 ``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
 a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 84349fcb93f1..b80e219ba587 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -17,6 +17,7 @@
 #include <linux/sched/mm.h>
 #include <linux/magic.h>
 #include <linux/binfmts.h>
+#include <linux/binfmt_misc.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
 #include <linux/string_helpers.h>
@@ -41,7 +42,7 @@ enum {
 	VERBOSE_STATUS = 1 /* make it zero to save 400 bytes kernel memory */
 };
 
-enum {Enabled, Magic};
+enum {Enabled, Magic, Bpf};
 #define MISC_FMT_PRESERVE_ARGV0 (1UL << 31)
 #define MISC_FMT_OPEN_BINARY (1UL << 30)
 #define MISC_FMT_CREDENTIALS (1UL << 29)
@@ -58,6 +59,8 @@ typedef struct {
 	char *name;
 	struct dentry *dentry;
 	struct file *interp_file;
+	const struct binfmt_misc_ops *bpf_ops;	/* bpf-backed handler ('B') */
+	const char *bpf_ops_name;
 	refcount_t users;		/* sync removal with load_misc_binary() */
 } Node;
 
@@ -82,14 +85,19 @@ static struct file_system_type bm_fs_type;
  * search_binfmt_handler - search for a binary handler for @bprm
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
+ * @bpf_skip: number of bpf-backed handlers to skip over
  *
  * Search for a binary type handler for @bprm in the list of registered binary
- * type handlers.
+ * type handlers. A bpf-backed handler cannot be matched here as its program
+ * must run in sleepable context; it is returned as a candidate and the
+ * program decides in load_misc_binary(). @bpf_skip allows the caller to
+ * resume the search after the first @bpf_skip candidates declined.
  *
  * Return: binary type list entry on success, NULL on failure
  */
 static Node *search_binfmt_handler(struct binfmt_misc *misc,
-				   struct linux_binprm *bprm)
+				   struct linux_binprm *bprm,
+				   unsigned int bpf_skip)
 {
 	char *p = strrchr(bprm->interp, '.');
 	Node *e;
@@ -103,6 +111,15 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
 		if (!test_bit(Enabled, &e->flags))
 			continue;
 
+		/* The program decides in load_misc_binary(). */
+		if (test_bit(Bpf, &e->flags)) {
+			if (bpf_skip) {
+				bpf_skip--;
+				continue;
+			}
+			return e;
+		}
+
 		/* Do matching based on extension if applicable. */
 		if (!test_bit(Magic, &e->flags)) {
 			if (p && !strcmp(e->magic, p + 1))
@@ -132,6 +149,7 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
  * get_binfmt_handler - try to find a binary type handler
  * @misc: handle to binfmt_misc instance
  * @bprm: binary for which we are looking for a handler
+ * @bpf_skip: number of bpf-backed handlers to skip over
  *
  * Try to find a binfmt handler for the binary type. If one is found take a
  * reference to protect against removal via bm_{entry,status}_write().
@@ -139,12 +157,13 @@ static Node *search_binfmt_handler(struct binfmt_misc *misc,
  * Return: binary type list entry on success, NULL on failure
  */
 static Node *get_binfmt_handler(struct binfmt_misc *misc,
-				struct linux_binprm *bprm)
+				struct linux_binprm *bprm,
+				unsigned int bpf_skip)
 {
 	Node *e;
 
 	read_lock(&misc->entries_lock);
-	e = search_binfmt_handler(misc, bprm);
+	e = search_binfmt_handler(misc, bprm, bpf_skip);
 	if (e)
 		refcount_inc(&e->users);
 	read_unlock(&misc->entries_lock);
@@ -164,6 +183,8 @@ static void put_binfmt_handler(Node *e)
 	if (refcount_dec_and_test(&e->users)) {
 		if (e->flags & MISC_FMT_OPEN_FILE)
 			filp_close(e->interp_file, NULL);
+		if (e->bpf_ops)
+			binfmt_misc_put_ops(e->bpf_ops);
 		kfree(e);
 	}
 }
@@ -206,12 +227,15 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	struct file *interp_file = NULL;
 	int retval = -ENOEXEC;
 	struct binfmt_misc *misc;
+	const char *interpreter;
+	unsigned int bpf_skip = 0;
 
 	misc = load_binfmt_misc();
 	if (!misc->enabled)
 		return retval;
 
-	fmt = get_binfmt_handler(misc, bprm);
+retry:
+	fmt = get_binfmt_handler(misc, bprm, bpf_skip);
 	if (!fmt)
 		return retval;
 
@@ -220,6 +244,32 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
 		goto ret;
 
+	if (test_bit(Bpf, &fmt->flags)) {
+		retval = fmt->bpf_ops->load(bprm);
+		if (retval < 0) {
+			/* Keep a program-supplied error within errno range. */
+			if (retval < -MAX_ERRNO)
+				retval = -ENOEXEC;
+			goto ret;
+		}
+		if (!retval) {
+			/* Declined, move on to later handlers. */
+			kfree(bprm->bpf_interp);
+			bprm->bpf_interp = NULL;
+			put_binfmt_handler(fmt);
+			bpf_skip++;
+			retval = -ENOEXEC;
+			goto retry;
+		}
+		/* Selecting an interpreter is part of the contract. */
+		retval = -ENOEXEC;
+		if (!bprm->bpf_interp)
+			goto ret;
+		interpreter = bprm->bpf_interp;
+	} else {
+		interpreter = fmt->interpreter;
+	}
+
 	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
@@ -238,13 +288,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_string_kernel(fmt->interpreter, bprm);
+	retval = copy_string_kernel(interpreter, bprm);
 	if (retval < 0)
 		goto ret;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(fmt->interpreter, bprm);
+	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		goto ret;
 
@@ -253,7 +303,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		if (!IS_ERR(interp_file))
 			deny_write_access(interp_file);
 	} else {
-		interp_file = open_exec(fmt->interpreter);
+		interp_file = open_exec(interpreter);
 	}
 	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
@@ -265,6 +315,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
 
 	retval = 0;
 ret:
+	/* A program-selected interpreter is consumed by this exec attempt. */
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = NULL;
 
 	/*
 	 * If we actually put the node here all concurrent calls to
@@ -404,13 +457,47 @@ static Node *create_entry(const char __user *buffer, size_t count)
 		pr_debug("register: type: M (magic)\n");
 		e->flags = (1 << Enabled) | (1 << Magic);
 		break;
+	case 'B':
+		if (!IS_ENABLED(CONFIG_BINFMT_MISC_BPF))
+			goto einval;
+		pr_debug("register: type: B (bpf)\n");
+		e->flags = (1 << Enabled) | (1 << Bpf);
+		break;
 	default:
 		goto einval;
 	}
 	if (*p++ != del)
 		goto einval;
 
-	if (test_bit(Magic, &e->flags)) {
+	if (test_bit(Bpf, &e->flags)) {
+		char *s;
+
+		/* The 'offset' field carries the handler name. */
+		s = strchr(p, del);
+		if (!s)
+			goto einval;
+		*s++ = '\0';
+		e->bpf_ops_name = p;
+		if (!e->bpf_ops_name[0] ||
+		    strlen(e->bpf_ops_name) >= BINFMT_MISC_OPS_NAME_MAX)
+			goto einval;
+		p = s;
+		pr_debug("register: bpf handler: {%s}\n", e->bpf_ops_name);
+
+		/* The 'magic' field must be empty. */
+		s = strchr(p, del);
+		if (!s || s != p)
+			goto einval;
+		*s++ = '\0';
+		p = s;
+
+		/* The 'mask' field must be empty. */
+		s = strchr(p, del);
+		if (!s || s != p)
+			goto einval;
+		*s++ = '\0';
+		p = s;
+	} else if (test_bit(Magic, &e->flags)) {
 		/* Handle the 'M' (magic) format. */
 		char *s;
 
@@ -524,8 +611,13 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	if (!p)
 		goto einval;
 	*p++ = '\0';
-	if (!e->interpreter[0])
+	if (test_bit(Bpf, &e->flags)) {
+		/* The program selects the interpreter at exec time. */
+		if (e->interpreter[0])
+			goto einval;
+	} else if (!e->interpreter[0]) {
 		goto einval;
+	}
 	pr_debug("register: interpreter: {%s}\n", e->interpreter);
 
 	/* Parse the 'flags' field. */
@@ -535,6 +627,14 @@ static Node *create_entry(const char __user *buffer, size_t count)
 	if (p != buf + count)
 		goto einval;
 
+	/*
+	 * A program-selected interpreter cannot be pre-opened and must not
+	 * inherit the credentials of a setuid binary it was chosen for.
+	 */
+	if (test_bit(Bpf, &e->flags) &&
+	    (e->flags & (MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_FILE)))
+		goto einval;
+
 	return e;
 
 out:
@@ -588,7 +688,10 @@ static void entry_status(Node *e, char *page)
 		return;
 	}
 
-	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
+	if (test_bit(Bpf, &e->flags))
+		dp += sprintf(dp, "%s\nbpf %s\n", status, e->bpf_ops_name);
+	else
+		dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
 
 	/* print the special flags */
 	dp += sprintf(dp, "flags: ");
@@ -602,7 +705,9 @@ static void entry_status(Node *e, char *page)
 		*dp++ = 'F';
 	*dp++ = '\n';
 
-	if (!test_bit(Magic, &e->flags)) {
+	if (test_bit(Bpf, &e->flags)) {
+		*dp = '\0';
+	} else if (!test_bit(Magic, &e->flags)) {
 		sprintf(dp, "extension .%s\n", e->magic);
 	} else {
 		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
@@ -809,6 +914,16 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
+	if (test_bit(Bpf, &e->flags)) {
+		e->bpf_ops = binfmt_misc_get_ops(sb->s_user_ns, e->bpf_ops_name);
+		if (!e->bpf_ops) {
+			pr_notice("register: no bpf handler named %s\n",
+				  e->bpf_ops_name);
+			kfree(e);
+			return -ENOENT;
+		}
+	}
+
 	if (e->flags & MISC_FMT_OPEN_FILE) {
 		/*
 		 * Now that we support unprivileged binfmt_misc mounts make
@@ -834,6 +949,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
 		}
+		if (e->bpf_ops)
+			binfmt_misc_put_ops(e->bpf_ops);
 		kfree(e);
 		return err;
 	}

-- 
2.53.0


