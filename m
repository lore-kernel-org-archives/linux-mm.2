Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A808C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338C86B00D6; Tue, 14 Jul 2026 15:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1A96B00D8; Tue, 14 Jul 2026 15:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13B556B00DE; Tue, 14 Jul 2026 15:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2D0D6B00D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38ACD1C01AE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:35 +0000 (UTC)
X-FDA: 84988444590.26.E70D6AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 82241120006
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdgwrRnk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWHjtmmb8/iWn0wg9Mu1aYl/DdA9yh9vudxm5c+q7Ho=;
	b=nPd1AHGg3sm53YN8vM4DhOjys7+vXvuRARf/b4uDfVxC/LhSiNGWLws/+WrKIj0gxo3J4p
	XyrK2UBzkRj5us2tYiFoiBG25IIw7qGtTsCX9j71MjvmmEhpGNjHV6RLUfaUl/gW05mFJg
	hG/y5Vd9e1FKIGjnjgRhgMPXJD/1V1c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KdgwrRnk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059113;
	b=p7DSV6VXMmkRZqVMdp1A5PYYoM6QQfhk894yKlmyUj2KPL+mmm9bLkt5hBjIMKVx39OUP1
	9qIIdJKoFypzzXzLVC8CeZiwW25V5u9CpM0S3tHZzQHjCrJgu5e5ic/vTp3UwtRwpmNol+
	HMfvLj/m+nf5ajmmrJTtjc7/Xi3yRLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12E5360103;
	Tue, 14 Jul 2026 19:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89D81F00A3A;
	Tue, 14 Jul 2026 19:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059112;
	bh=KWHjtmmb8/iWn0wg9Mu1aYl/DdA9yh9vudxm5c+q7Ho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KdgwrRnkzf7BXZEv8pBoMQ5BZrlFXcDResViUYjgBi/z8aaociV8T/FP92FuwZoXn
	 b5UMhACy4erEFbOSXrq0ejKV14X4vKA35G4jX9nExX4D7hoQKAvWZz1iGvPD8qEDCV
	 R4iRHO28P2MqYL7ab5pdnGoL0euwK5EyeTcRdk9WVK/oGJCntbeMzQYRs3Y6uwtOjN
	 rBW5cerT+/DKDdI9j/D1TyorP+FuVUzreJEjFvXtwVIANI3eTW9YrTKzKYCCPhww1o
	 iPTZytYY3Spa/+vmfN8gMnDfz07IP3znd+g8GXVSsL4SwFcwYuxU06AmWIaHkRUlRh
	 r3FxlWq/DLSAA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:09 +0200
Subject: [PATCH v2 4/9] binfmt_misc: wire up bpf-backed 'B' entries
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-4-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, bpf@vger.kernel.org, jannh@google.com, 
 mail@johnericson.me, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=17680; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lmNxBp7+78uX0ovxiKY9N+5MSXzS6HQ8EmRyBMhDS3g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbl8Mm1T7qJrf6a9r9RisZTtfLtyl0PXqeU/Ypm2l
 Oy6nzbvdUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEbmQz/He4NX2VwtKXn885
 bkyN2LGf+7qMCOfCfMf/ZdK6i9+fXKfL8D/1U8T1zTv5HS3ebo2SURPSaN0YmDtlZsDG8I8TtwS
 /FWUCAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 82241120006
X-Stat-Signature: ftfky65jxsdo6gcfuz69t15wnkdr5ksz
X-HE-Tag: 1784059113-130651
X-HE-Meta: U2FsdGVkX18COlGrI5Ad1a/3NvNzxI8/g0A7hScVoG/eTdv+Fj3dvNM7oLtKrfdsKpFU2hR1TXbpKZHjnSENqjcHD9nGsMRDIW9tNZcEpML//33QHbU8X3kd1eZx2RF71zaZeUVx1qD/i2fCx03HeGMaVfJES/qDZiqohefUwG9DyXraltxtMZTzTb6s1Msm8i2hAQGJY1DIJKYNkkdToR488hlAvzAic6cq2edQSO11tkmAdRlBNpNNmQ7FeROzJUrkFAUefoJCvmyA0+L/84pHxdc1+8yQtug61V65YD9XcxqHJt+30v+FGc9hK/iWTieJhGE0GRDSO6IO7d7mS+6zC8/cBPqhOL6TJEU0THV0UV2KfOeIYId8Jv4uQodauHhWBZuqln1VQehPRAxcnu91AnP9KNpxIAy2ohdMnmWY756oSVXL0bT8obK8EOpMgHJH3RjmieTLOYA79pIP78zhq9hX7TzggLfIfWS2Lax0X80LrBMcCrt0z/FuPZgPynuUs3V8kXsi2wvB7U3An4FJBJ/Oo5O4viBuJDuH/Ek3tQEJYSV//9ZgNyHI599GYj5oFybx0uvZ/66YVUleo4cFQt8IuqBFChnxVuecKQV2gvX327acpHnfBB+ckQKpJMpYt4Cnh+YRM9Oj7032cHB5TxLg59AVxiGliiiNCPciS68o2JdZbgzN3ZPF+dkcNwacr8ihqAGLj/NvwQwA/smjMQpO/TyLSZeVJ+Jgn2WDk2+g2FCfcvsseU6vplp0zSneZicZjkNfXNB8orVPUasionvTDxo//YIvkCF5uTj07iDcLOJkAX7FEQZy2yW+nqLbZAhb6NYWBaByfGVftIGaK+lqJ6jqemY/sAN3DZ7DODEJGzuQOFTbmb97Nu7m0/dEnFxRkuoC+TtvcnU6+A8KBtU8iJ4TmsVT/lEqfZOfsFrewulJOxZp2HoBofoKG785aLKwutpNOXAsC18
 pf/8fIna
 VsqsCBNi5fH9mdqrpwV9fHk8aHewytkNtw0U8UAnMKRqxgwFpiHXR7K5xgexlsN3/ptSLp9jLDrtV4X/oyudD6SNgEUR7yeJllSU8/glhKImPmRbUSay4nVLQSp0lG9IF1gtRASuBqKLqgwDGg5tX+lSkUi/YJJTlpPdSunA/Nx2oMkjsafGhxU5KBX2cECallxwPf5I55Y41eeuhyUWs3mzuiqUdX1p5Hwwww9IWU6y/MUfxfsncR0kr+1YTGO9lZd8CQLEbF1nyN5dWz+ITMX4h7++j8dufjOxLCDjzWxEFfQuUYLspfTOLC1bflURhYiYboHq158JQS0YHYQTgMdXWahRxJ9jMsnKA3mevf/7JyOtCdSzlpcZtM+Z5xbRE2sgUF+luKcTKKBap3bcVBRCxUPmixgmaLRz3h4JOnpTn+cQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Activate a registered binfmt_misc_ops handler through the existing text
interface with the new 'B' entry type:

        echo ':name:B::::<handler-name>:' > <binfmt_misc>/register

The offset, magic, and mask fields must be empty since the program does
the matching; the interpreter field carries the handler name since the
program supplies the interpreter. Reusing the register file keeps the
existing permission model intact: activating a handler requires the
same write access to a binfmt_misc instance as any other registration,
and the per user namespace instance semantics apply unchanged. A 'B'
entry in a container's own instance shadows the host's handlers just
like any other entry, and the privilege needed to shadow e.g. all ELF
binaries is the same as for a static 'M' entry matching \x7fELF today;
the only novelty is that matching becomes programmable.

The entry takes its own reference on the ops for its whole lifetime.
It is dropped from the SRCU callback that frees the entry rather than
synchronously on the final put: a walker may be asleep inside the
handler's match program while the entry's last reference goes away, so
the ops must stay callable until every walker has left the read
section - the same deferral the entry's own memory already gets. The
registration failure path, where the users refcount is not live yet,
drops it explicitly.

The match program runs from the lookup walk like magic and extension
matching and under the same rules: strict registration order, first
match wins. The walk became an SRCU read-side section in the previous
patch, so the program can sleep: it decides on the actual file
content - program headers beyond the prefetched bprm->buf, say - not
just on whatever happens to be resident in the page cache. A match
commits the exec to the handler. The sleepable load program then
selects the interpreter from load_misc_binary() by calling
bpf_binprm_set_interp() and returning zero; a failure fails the exec
instead of falling through to later entries. The walk is never left
and re-entered, so 'B' entries need no special semantics against
concurrent registration and removal whatsoever. -ENOEXEC keeps its
usual meaning and moves on to the remaining binary formats - a handler
whose load program discovers that it cannot serve the binary after all
hands it back to them - and so does returning zero without having
selected an interpreter; other program-supplied errors are clamped to
the errno range.

The 'F' flag is rejected for 'B' entries: it exists to pre-open a fixed
interpreter at registration time in the registrar's context, and a 'B'
entry has no fixed interpreter to pre-open.

'C' is accepted and behaves exactly as it does for a static entry. It
honors the suid bits of the matched binary while executing the
interpreter, which makes 'B' handlers usable for the setuid case, e.g.
a per-binary loader. This does not let the program's registrant widen
access: bprm_fill_uid() gates the credential transition on
vfsuid_has_mapping() in the caller's user namespace, so the interpreter
can only ever run as a uid that is mapped there, identical to a static
'C' entry. The computed path is opened with open_exec() under the
caller's credentials with the usual LSM and noexec checks, and the
programs run before the transition with the caller's credentials,
never elevated.

Link: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  47 +++++++++-
 fs/binfmt_misc.c                          | 148 +++++++++++++++++++++++++++---
 2 files changed, 180 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 306ef48f5de6..45541604d528 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -26,7 +26,8 @@ Here is what the fields mean:
    name below ``/proc/sys/fs/binfmt_misc``; cannot contain slashes ``/`` for
    obvious reasons.
 - ``type``
-   is the type of recognition. Give ``M`` for magic and ``E`` for extension.
+   is the type of recognition. Give ``M`` for magic, ``E`` for extension and
+   ``B`` for a bpf-backed handler (see below).
 - ``offset``
    is the offset of the magic/mask in the file, counted in bytes. This
    defaults to 0 if you omit it (i.e. you write ``:name:type::magic...``).
@@ -48,7 +49,8 @@ Here is what the fields mean:
    filename extension matching.
 - ``interpreter``
    is the program that should be invoked with the binary as first
-   argument (specify the full path)
+   argument (specify the full path). For ``B`` entries this field
+   carries the name of the bpf handler instead (see below).
 - ``flags``
    is an optional field that controls several aspects of the invocation
    of the interpreter. It is a string of capital letters, each controls a
@@ -97,6 +99,47 @@ There are some restrictions:
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
 
+
+bpf-backed handlers
+-------------------
+
+With ``CONFIG_BINFMT_MISC_BPF`` both the matching and the interpreter
+selection can be delegated to bpf programs. A handler is an instance of the
+``binfmt_misc_ops`` struct_ops with a ``match`` and a ``load`` program and a
+``name``. Once the struct_ops map is registered the handler can be activated
+with a ``B`` entry that references it by name in the ``interpreter`` field
+and carries neither offset, magic, nor mask::
+
+    echo ':qemu:B::::my_handler:' > register
+
+Both programs receive the ``linux_binprm`` of the binary and both can
+sleep. The ``match`` program decides whether the handler applies: it is
+consulted during the entry walk exactly like magic and extension matching,
+in the same registration order with the same first-match-wins semantics.
+Unlike static matching it is not limited to the prefetched first bytes of
+the file in ``bprm->buf``: it can read the file, e.g. to parse ELF program
+headers whose data sits at arbitrary offsets. It only decides, though: the
+selection kfuncs below are rejected in it. The ``load`` program of the
+matched handler then selects the interpreter: it can equally read the file
+and derive the interpreter from the binary's location. It selects the
+interpreter by calling the ``bpf_binprm_set_interp()`` kfunc with an
+absolute path and returning ``0``. A match is committed: a failing
+``load`` fails the exec with its error instead of falling through to later
+entries; ``-ENOEXEC`` lets the remaining binary formats have a go. The
+interpreter is opened with the credentials of the task doing the exec,
+exactly as a statically registered interpreter would be.
+
+Handlers are looked up in the user namespace the struct_ops map was
+registered in, falling back to ancestor namespaces, mirroring how
+binfmt_misc instances themselves are looked up. The entry keeps the handler
+alive; deleting the struct_ops map only prevents new activations.
+
+The ``F`` flag cannot be combined with ``B`` entries: it pre-opens a fixed
+interpreter at registration time and a ``B`` entry has none. The ``C`` flag
+works as it does for a static entry: the interpreter runs with the matched
+binary's credentials, bounded to user namespaces that map the binary's owner
+just like any other setuid exec.
+
 To use binfmt_misc you have to mount it first. You can mount it with
 ``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
 a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index f7264b13645d..a8f641c4ec2b 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/binfmt_misc.h>
 #include <linux/binfmts.h>
 #include <linux/bitops.h>
 #include <linux/bits.h>
@@ -39,6 +40,7 @@
 enum binfmt_misc_entry_bits {
 	MISC_FMT_ENABLED_BIT	= 0,
 	MISC_FMT_MAGIC_BIT	= 1,
+	MISC_FMT_BPF_BIT	= 2,
 };
 
 /* Entry behavior flags, fixed at registration time. */
@@ -60,6 +62,8 @@ struct binfmt_misc_entry {
 	char *name;
 	struct dentry *dentry;
 	struct file *interp_file;
+	const struct binfmt_misc_ops *bpf_ops;	/* bpf-backed handler ('B') */
+	const char *bpf_ops_name;
 	refcount_t users;		/* sync removal with load_misc_binary() */
 	struct rcu_head rcu;
 	char buf[];			/* register string, fields point in here */
@@ -115,9 +119,11 @@ static bool entry_matches_extension(const struct binfmt_misc_entry *e,
  * @bprm: binary for which we are looking for a handler
  *
  * Search for a binary type handler for @bprm in the list of registered binary
- * type handlers. The matched entry is returned with a reference taken while
- * the walk still held it; a dying entry - unlinked with its last reference
- * gone - cannot be matched and the walk moves on.
+ * type handlers. A 'B' entry's match program decides whether the handler
+ * applies; it may sleep to read the binary. The matched entry is returned
+ * with a reference taken while the walk still held it; a dying entry -
+ * unlinked with its last reference gone - cannot be matched and the walk
+ * moves on.
  *
  * The caller must hold the bm_entries_srcu read lock, which allows an
  * entry's evaluation to sleep.
@@ -138,7 +144,10 @@ search_binfmt_handler(struct binfmt_misc *misc, struct linux_binprm *bprm)
 		if (!test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
 			continue;
 
-		if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
+		if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+			if (!e->bpf_ops->match(bprm))
+				continue;
+		} else if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 			if (!entry_matches_magic(e, bprm))
 				continue;
 		} else {
@@ -174,7 +183,12 @@ static struct binfmt_misc_entry *get_binfmt_handler(struct binfmt_misc *misc,
 
 static void bm_entry_free_rcu(struct rcu_head *rcu)
 {
-	kfree(container_of(rcu, struct binfmt_misc_entry, rcu));
+	struct binfmt_misc_entry *e = container_of(rcu, struct binfmt_misc_entry, rcu);
+
+	/* No walker that could sleep in the handler's programs is left. */
+	if (e->bpf_ops)
+		binfmt_misc_put_ops(e->bpf_ops);
+	kfree(e);
 }
 
 /**
@@ -226,12 +240,51 @@ static struct binfmt_misc *current_binfmt_misc(void)
 	return &init_binfmt_misc;
 }
 
+/**
+ * entry_select_interpreter - get the interpreter for the matched @e
+ * @e: matched binary type handler
+ * @bprm: binary that is being executed
+ *
+ * A static entry carries its interpreter path, for a 'B' entry the
+ * handler's load program selects it. The match is committed, so a failing
+ * program fails the exec.
+ *
+ * Return: the interpreter on success, an ERR_PTR on failure
+ */
+static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
+					    struct linux_binprm *bprm)
+{
+	int retval;
+
+	if (!test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		return e->interpreter;
+
+	/* Drop any interpreter a previous chain level staged. */
+	kfree(bprm->bpf_interp);
+	bprm->bpf_interp = NULL;
+
+	retval = e->bpf_ops->load(bprm);
+	if (retval) {
+		/* Keep a program-supplied error within errno range. */
+		if (retval > 0 || retval < -MAX_ERRNO)
+			retval = -ENOEXEC;
+		return ERR_PTR(retval);
+	}
+
+	/* Selecting an interpreter is part of the contract. */
+	if (!bprm->bpf_interp)
+		return ERR_PTR(-ENOEXEC);
+
+	return bprm->bpf_interp;
+}
+
 /*
  * the loader itself
  */
 static int load_misc_binary(struct linux_binprm *bprm)
 {
 	struct binfmt_misc_entry *fmt __free(put_binfmt_handler) = NULL;
+	const char *interpreter;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
 	int retval;
@@ -248,6 +301,10 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
 		return -ENOENT;
 
+	interpreter = entry_select_interpreter(fmt, bprm);
+	if (IS_ERR(interpreter))
+		return PTR_ERR(interpreter);
+
 	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
@@ -266,13 +323,13 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	bprm->argc++;
 
 	/* add the interp as argv[0] */
-	retval = copy_string_kernel(fmt->interpreter, bprm);
+	retval = copy_string_kernel(interpreter, bprm);
 	if (retval < 0)
 		return retval;
 	bprm->argc++;
 
 	/* Update interp in case binfmt_script needs it. */
-	retval = bprm_change_interp(fmt->interpreter, bprm);
+	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		return retval;
 
@@ -287,7 +344,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 			}
 		}
 	} else {
-		interp_file = open_exec(fmt->interpreter);
+		interp_file = open_exec(interpreter);
 	}
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
@@ -438,6 +495,27 @@ static char *parse_extension_fields(struct binfmt_misc_entry *e, char *p,
 	return p;
 }
 
+/*
+ * Parse the fields of a 'B' entry: the 'offset', 'magic' and 'mask' fields
+ * must be empty. The handler name is carried in the 'interpreter' field.
+ */
+static char *parse_bpf_fields(struct binfmt_misc_entry *e, char *p, char del)
+{
+	/* The 'offset' field must be empty. */
+	if (*p++ != del)
+		return NULL;
+
+	/* The 'magic' field must be empty. */
+	if (*p++ != del)
+		return NULL;
+
+	/* The 'mask' field must be empty. */
+	if (*p++ != del)
+		return NULL;
+
+	return p;
+}
+
 /*
  * This registers a new binary format, it recognises the syntax
  * ':name:type:offset:magic:mask:interpreter:flags'
@@ -502,13 +580,21 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		pr_debug("register: type: M (magic)\n");
 		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_MAGIC_BIT);
 		break;
+	case 'B':
+		pr_debug("register: type: B (bpf)\n");
+		if (!IS_ENABLED(CONFIG_BINFMT_MISC_BPF))
+			return ERR_PTR(-EINVAL);
+		e->flags = BIT(MISC_FMT_ENABLED_BIT) | BIT(MISC_FMT_BPF_BIT);
+		break;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 	if (*p++ != del)
 		return ERR_PTR(-EINVAL);
 
-	if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags))
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		p = parse_bpf_fields(e, p, del);
+	else if (test_bit(MISC_FMT_MAGIC_BIT, &e->flags))
 		p = parse_magic_fields(e, p, del);
 	else
 		p = parse_extension_fields(e, p, del);
@@ -521,9 +607,18 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (!p)
 		return ERR_PTR(-EINVAL);
 	*p++ = '\0';
-	if (!e->interpreter[0])
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		/* The 'interpreter' field carries the handler name. */
+		e->bpf_ops_name = e->interpreter;
+		e->interpreter = NULL;
+		if (!e->bpf_ops_name[0])
+			return ERR_PTR(-EINVAL);
+		pr_debug("register: bpf handler: {%s}\n", e->bpf_ops_name);
+	} else if (!e->interpreter[0]) {
 		return ERR_PTR(-EINVAL);
-	pr_debug("register: interpreter: {%s}\n", e->interpreter);
+	} else {
+		pr_debug("register: interpreter: {%s}\n", e->interpreter);
+	}
 
 	/* Parse the 'flags' field. */
 	p = check_special_flags(p, e);
@@ -532,6 +627,17 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (p != buf + count)
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * 'F' pre-opens a fixed interpreter at registration time which is
+	 * meaningless for a per-exec computed path. 'C' is fine: it honors the
+	 * suid bits of the matched binary exactly like a static entry, gated by
+	 * the same vfsuid_has_mapping() check in bprm_fill_uid() that keeps the
+	 * transition to uids mapped in the caller's user namespace.
+	 */
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
+	    (e->flags & MISC_FMT_OPEN_FILE))
+		return ERR_PTR(-EINVAL);
+
 	return no_free_ptr(e);
 }
 
@@ -585,7 +691,10 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 	else
 		seq_puts(m, "disabled\n");
 
-	seq_printf(m, "interpreter %s\n", e->interpreter);
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags))
+		seq_printf(m, "bpf %s\n", e->bpf_ops->name);
+	else
+		seq_printf(m, "interpreter %s\n", e->interpreter);
 
 	/* print the special flags */
 	seq_puts(m, "flags: ");
@@ -599,7 +708,9 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 		seq_putc(m, 'F');
 	seq_putc(m, '\n');
 
-	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		/* The program does the matching. */
+	} else if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
 		seq_printf(m, "extension .%s\n", e->magic);
 	} else {
 		seq_printf(m, "offset %i\nmagic ", e->offset);
@@ -850,6 +961,15 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 	if (IS_ERR(e))
 		return PTR_ERR(e);
 
+	if (test_bit(MISC_FMT_BPF_BIT, &e->flags)) {
+		e->bpf_ops = binfmt_misc_get_ops(sb->s_user_ns, e->bpf_ops_name);
+		if (!e->bpf_ops) {
+			pr_notice("register: no bpf handler named %s\n",
+				  e->bpf_ops_name);
+			return -ENOENT;
+		}
+	}
+
 	if (e->flags & MISC_FMT_OPEN_FILE) {
 		/*
 		 * Now that we support unprivileged binfmt_misc mounts make
@@ -874,6 +994,8 @@ static ssize_t bm_register_write(struct file *file, const char __user *buffer,
 			exe_file_allow_write_access(f);
 			filp_close(f, NULL);
 		}
+		if (e->bpf_ops)
+			binfmt_misc_put_ops(e->bpf_ops);
 		return err;
 	}
 

-- 
2.53.0


