Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB53C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 19:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905436B00C9; Tue, 14 Jul 2026 15:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E826B00E4; Tue, 14 Jul 2026 15:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E1416B00E5; Tue, 14 Jul 2026 15:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 246976B00C9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:58:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CD85403C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:47 +0000 (UTC)
X-FDA: 84988445094.07.41BA213
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EEB8680003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:58:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UcEV24/R";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r400Db0eFmVhpt4B7u39a7XVOL/Lj6Zbx5bElPgIePE=;
	b=00LiuFjf/E80E6ilhLWsdnOYSHEvkHF30mRdLKVUti2MVYFjj7mUMh541vcRv+zUlw663U
	04AZlW7Z2bwrnPhm/wMs1ap+SsDfrfa16FKuOH5QWOMolMFP/KgCCpjTVtpyZs2syFXv7t
	cgbuiVR2bJsWFkArdhFX/+PxYkn9T88=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UcEV24/R";
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059125;
	b=VG1zQc1r+t41/ABaRksRSrxWaQ5A4F//dNg4R1hcHizo5raOEMtvkspD/OmDE4wxV25onw
	Zjaf8FW6Zo5M0XZx4dSvnmUBPkAMjSDIFWjEBLMlF0L1thOKsZye5GBqE2NmIIXpgTlqDz
	VX/3QNFldi454f/WHfokhXfD+FywS0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BD8660103;
	Tue, 14 Jul 2026 19:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008E61F000E9;
	Tue, 14 Jul 2026 19:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784059125;
	bh=r400Db0eFmVhpt4B7u39a7XVOL/Lj6Zbx5bElPgIePE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UcEV24/RnzLJrgkozaVceI5HzSPF7HPJxpAZd2Epufb5AcCypWpgAMtEBgiaiDuxb
	 Apy7FsFx6acpJjFNAId3uPO3/ODS/ktIijehpRKlwgLCWcKtzcOlU0ICbwesT32cC4
	 840RqDfwKw30jlH+y9BnT8yvzy/oZmVQr8gr49Ll6nsafMsPssXzGBn2F5OmmKr8wN
	 YwDqE43UgYsXPFHDORkl3kbT8dxSDJqzXyVa6TCdzfbz25WaxTtqbVwkko9khNWPOr
	 G9b3T/WpeVOXcHMzo4d1nN0L8TxPWGxwFlOtO1M3iqXkbCbYC+LXWaXI2NH7YQWL1W
	 hpSzLEsor2CUQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 14 Jul 2026 21:58:12 +0200
Subject: [PATCH v2 7/9] binfmt_misc: let a bpf handler choose the
 invocation flags per exec
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-work-bpf-binfmt_misc-v2-7-57b7529c002c@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=7396; i=brauner@kernel.org;
 h=from:subject:message-id; bh=pRcOZeiAnSAEMiBNYaGd7SrGR13AOsRcfDnsOK+6ZbU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSFTbmsafKp4Wuak6lpetbzdOd1BRdr1v9umz7z456uV
 aKzavPCO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayVZGRob9R9Pe2iiOdn258
 7fbtLLgyt2HBjCi3I78vzbD6c+Op2DSG/7Xb7yhK7BFtzatiWXDVk6EmdF6I6+f4I7M9ZTYJKlV
 d4QIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEB8680003
X-Stat-Signature: cmgw89xobgtmoj5im4bbgrm7a6fpmme1
X-HE-Tag: 1784059125-904466
X-HE-Meta: U2FsdGVkX1/8bfFdQ+R2kjhOvVp+es0bBPgDmRjvMc2WFdLm4neUp43d6kuzF861nDk3LLeN6LVMq/fq/IkaokfopwJZ+9kwPK77PRsPyuC6+ChLrgqh1j5ZESWdsVLSEL52MPvqI4ENup/uRAc3IQdx9dEVTCeyXwtFDL5joAZBbg279qA9T3YUt8MRYPRqVXaeQP79PpNaOdTLTXj2Imw47WoHE3dVQZR1q0vyVCK6fg4Jss1vkR9w3/DjgUuqaTQ3NMIyltgmH+OZEBsmKeLV8HJwZKR4Lv0fwLH8TWpoXYsAFarCKWdgDBQBnoHQZ7N+NECK+wWDj/5H2qrTBICHcoSre8xhmOuPn9Bud75u7baASjD/PUGNEV6fxyTJ4Y+15hJKJJHHSkwF/AKRRRgEpheRLGD4j0e+6VP+5DkiZZYup3PaIQRyTqICLDIP83gynZ6Akr7lWSCuzhcDkbBblEfc2k2NE3nrtQ8K0tQVp/hd94vBlh9qdNUspyOO7a9/OM0Pi1y557s3xBkBXXIFPhLbZvGC2hs6e+ivOunZAUPzp2ReWVxUBqZPk+APL1DhcSt0UDGw37858ON6WTx8aaxC3ECRVQOiHRE16oQvSACfh3yCVmzHeBBVRirN2K28NhBbgTGRWYfXF/GLk+uswNc5UDX6rxYO59Oqc4GwZcpj+aWRxInOlX9ubd4w8hUnmEKNNXO9otYl2ne7ZOErEDs/B7Vu1fcWmYv8rnB8m1msjcN0GuLDw9jqxr0JTGuG0kaz2iSGzVz3DvSKM5m1pwpbgrEoX55cz1cNRBYC6hqC0FOFgqs+NguedHDPWWLCwV8AOUZn50bnqV/xqrHT1IOLERjPaPOoh4cZFmgCTpuR9hpOEIIfu8UuIaoUGJspjfD2uHZt4IBj9NuIr/fqoMoHZHfkrksqziCsYtnakHkX0uFONdEek+1DLqvVYNJocoB1h0pxYn5bsTB
 zMTFSjVb
 cqqJVOC3EHap/Ef9L/Zraaq4uWnqvx/37uNDuR3TaL2OMlT3/NdJHx29UwBoMLln0oNWTbmeSuWwCNrK8SGN0mleK/xXlri/5vx7ppkchESJpQGtDcFxiO3f9GPUIatDphXNWPpGh5BOru7VnIgxxw4IX18bPeioeRsXjjF1PO7abaxyfqmATPGYjyPx6ZGsvJw7sDXwDO1+yjTgDcHp0124tUXvLLpoG8hCFRWCbPXw8CY/hBR3btrfyhw8cRPJkVWGnGRmCGQc2VEfUhwSsLISf2HBZtLecauuf4mnXrYtQlYUwJEajusBBUd6OD5bWKpzlSVT2RzHy+tJppfh61PLeT+Q4LTahmINLwCRkNrrHe/HC9Uqva0OmMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'P', 'C' and 'O' flags of a binfmt_misc entry - preserve argv[0],
compute credentials from the binary, and pass the binary as an open file
descriptor - are fixed at registration and apply to every binary the entry
matches. A bpf handler matches, selects the interpreter and reads the
binary per exec, so the flags should be its per-exec decision too: one
handler may match both setuid and non-setuid binaries, argv[0]-sensitive
ones and not.

Honor the flags the load program stages in bprm->bpf_flags through the
bpf_binprm_set_flags() kfunc: BPF_BINPRM_PRESERVE_ARGV0,
BPF_BINPRM_CREDENTIALS and BPF_BINPRM_EXECFD map to 'P', 'C' and 'O' and
keep the semantics of their static counterparts, credentials implying the
open file descriptor included.

Flags staged by a load program that then fails are dropped on the way out
so they cannot leak into a later handler's exec, and the argv[0] decision
acts on the entry's own choice instead of testing the accumulated
bprm->interp_flags bit, which an earlier chain level may have left set and
binfmt_misc never clears.

Since a 'B' entry's flags come from the program, it carries none in the
register string: 'P', 'C' and 'O' are rejected there alongside 'F', which
was already meaningless for it. load_misc_binary() takes the flags from
the entry for a static handler and from bprm->bpf_flags for a bpf one.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 23 ++++++++++++----
 fs/binfmt_misc.c                          | 46 +++++++++++++++++++++++--------
 2 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index 6128057160e3..7f42abf9cfba 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -135,17 +135,28 @@ interpreter and the binary, exactly like the optional argument of a ``#!``
 interpreter line, e.g. for a handler that resolves ``$ORIGIN`` in a script's
 ``#!`` path and needs to preserve the argument that followed it.
 
+The invocation flags a static entry fixes at registration - ``P``, ``C``
+and ``O`` - are per-exec choices for a bpf handler, made by the ``load``
+program with the ``bpf_binprm_set_flags()`` kfunc, so a single handler can
+decide them differently for each binary it handles:
+
+- ``BPF_BINPRM_PRESERVE_ARGV0`` keeps the caller's ``argv[0]`` (the ``P``
+  flag).
+- ``BPF_BINPRM_CREDENTIALS`` computes credentials from the binary (the ``C``
+  flag), bounded to user namespaces that map the binary's owner just like
+  any other setuid exec.
+- ``BPF_BINPRM_EXECFD`` opens the binary on the interpreter's behalf and
+  passes it through the ``AT_EXECFD`` aux vector entry (the ``O`` flag), so
+  the interpreter can run binaries it could not open by path.
+
+Because these are program choices, a ``B`` entry carries no flags in the
+register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
+
 Handlers are looked up in the user namespace the struct_ops map was
 registered in, falling back to ancestor namespaces, mirroring how
 binfmt_misc instances themselves are looked up. The entry keeps the handler
 alive; deleting the struct_ops map only prevents new activations.
 
-The ``F`` flag cannot be combined with ``B`` entries: it pre-opens a fixed
-interpreter at registration time and a ``B`` entry has none. The ``C`` flag
-works as it does for a static entry: the interpreter runs with the matched
-binary's credentials, bounded to user namespaces that map the binary's owner
-just like any other setuid exec.
-
 To use binfmt_misc you have to mount it first. You can mount it with
 ``mount -t binfmt_misc none /proc/sys/fs/binfmt_misc`` command, or you can add
 a line ``none  /proc/sys/fs/binfmt_misc binfmt_misc defaults 0 0`` to your
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 3fbc51197c76..a3175521c8dd 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -283,6 +283,7 @@ static const char *entry_select_interpreter(const struct binfmt_misc_entry *e,
 	/* A failing load leaves nothing behind for later entries. */
 	kfree(bprm->bpf_interp_arg);
 	bprm->bpf_interp_arg = NULL;
+	bprm->bpf_flags = 0;
 	return ERR_PTR(retval);
 }
 
@@ -295,6 +296,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	const char *interpreter;
 	struct file *interp_file;
 	struct binfmt_misc *misc;
+	bool preserve_argv0;
 	int retval;
 
 	misc = current_binfmt_misc();
@@ -313,7 +315,32 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (IS_ERR(interpreter))
 		return PTR_ERR(interpreter);
 
-	if (fmt->flags & MISC_FMT_PRESERVE_ARGV0) {
+	/*
+	 * The invocation flags are fixed at registration for a static handler
+	 * and chosen per exec by the load program, via bpf_binprm_set_flags(),
+	 * for a bpf one.
+	 */
+	if (test_bit(MISC_FMT_BPF_BIT, &fmt->flags)) {
+		u64 f = bprm->bpf_flags;
+
+		/* Clear so it can't accumulate into a nested interpreter level. */
+		bprm->bpf_flags = 0;
+
+		preserve_argv0 = f & BPF_BINPRM_PRESERVE_ARGV0;
+		if (f & BPF_BINPRM_CREDENTIALS)
+			bprm->execfd_creds = 1;
+		if (f & (BPF_BINPRM_CREDENTIALS | BPF_BINPRM_EXECFD))
+			bprm->have_execfd = 1;
+	} else {
+		preserve_argv0 = fmt->flags & MISC_FMT_PRESERVE_ARGV0;
+		if (fmt->flags & MISC_FMT_CREDENTIALS)
+			bprm->execfd_creds = 1;
+		if (fmt->flags & MISC_FMT_OPEN_BINARY)
+			bprm->have_execfd = 1;
+	}
+
+	/* The entry's own choice - not one accumulated from an earlier level. */
+	if (preserve_argv0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
 	} else {
 		retval = remove_arg_zero(bprm);
@@ -321,9 +348,6 @@ static int load_misc_binary(struct linux_binprm *bprm)
 			return retval;
 	}
 
-	if (fmt->flags & MISC_FMT_OPEN_BINARY)
-		bprm->have_execfd = 1;
-
 	/* make the binary the last argument to the interpreter */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
@@ -372,8 +396,6 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		return PTR_ERR(interp_file);
 
 	bprm->interpreter = interp_file;
-	if (fmt->flags & MISC_FMT_CREDENTIALS)
-		bprm->execfd_creds = 1;
 	return 0;
 }
 
@@ -650,14 +672,14 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 		return ERR_PTR(-EINVAL);
 
 	/*
-	 * 'F' pre-opens a fixed interpreter at registration time which is
-	 * meaningless for a per-exec computed path. 'C' is fine: it honors the
-	 * suid bits of the matched binary exactly like a static entry, gated by
-	 * the same vfsuid_has_mapping() check in bprm_fill_uid() that keeps the
-	 * transition to uids mapped in the caller's user namespace.
+	 * A bpf handler decides the invocation flags per exec with
+	 * bpf_binprm_set_flags() rather than fixing them at registration, so a
+	 * 'B' entry carries no flags: 'P', 'C' and 'O' become per-exec choices
+	 * and 'F' (pre-open a fixed interpreter) is meaningless for it.
 	 */
 	if (test_bit(MISC_FMT_BPF_BIT, &e->flags) &&
-	    (e->flags & MISC_FMT_OPEN_FILE))
+	    (e->flags & (MISC_FMT_PRESERVE_ARGV0 | MISC_FMT_OPEN_BINARY |
+			 MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_FILE)))
 		return ERR_PTR(-EINVAL);
 
 	return no_free_ptr(e);

-- 
2.53.0


