Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC76DC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61F876B00BC; Tue, 21 Jul 2026 10:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF996B00BE; Tue, 21 Jul 2026 10:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6A16B00BF; Tue, 21 Jul 2026 10:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 170FE6B00BC
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9213E1201C9
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:28 +0000 (UTC)
X-FDA: 85012981536.26.65565DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3710C0015
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSVL6ZGp;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643326;
	b=7QmjIfTQdNA8c+QGVQXdnaZqAvZ0eFddrIG69tHEDvmYRF0+RcKWLyJMhexLVDISxnBqxc
	6/6FHFR3MS0OpfG12oLE74QOQgRHQSi7ZWEOCuwvNhuaENke3Dg+Yd9lb0xjFKQy4SMlFD
	AOafhIcxwDjJHt8JQ2H66ERN5vm52O0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSVL6ZGp;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GW3jh5NfuUpeUxnNxdu7QM6ReO5XyrnCyqvrQ8HbVGU=;
	b=UN4boTpASUQPeDgePBNSfAsZADTY9a5HZfyoCn/kswrQhWnw4x7uR2rReLqZwP0rAlBrat
	A2gMq4aj0tOKsHTkH4G3WXFolhhTx/PsmiwaXol68JC4EOoehe6kgMJ4UMwZl4lx2pbYYN
	RGqmsIeeDN4/NYhYM+xiJLgnoU07AEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7ADA4600D8;
	Tue, 21 Jul 2026 14:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D651F00A3A;
	Tue, 21 Jul 2026 14:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643326;
	bh=GW3jh5NfuUpeUxnNxdu7QM6ReO5XyrnCyqvrQ8HbVGU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CSVL6ZGpGk/wNu/S4yldA/7PhWX7aNLYFm5B+YGSeL6bAYX0rMdjf55Me2DXSrJOh
	 xoIZABC4wjOsckACYO5Irq7KajuJ3aMIcPOfcMfwsQ8j0VAH2w99BZnMMnfh1xvsgH
	 Lop9GPvqZFseMWUhrSiqSI49Ikmra+wuricK51F21tHaaLWt2786+dGDyGtsbXZIG5
	 1FRmXkg8Ynz7G74GRCjRkpH5UAr06vMPRss9EAzhhIkOW43oUAm6ahknhAaAiKOdXg
	 tOhZncIhhdo5obOHKLFD1NEbx84LryDGIVI15EtsYN1VYV6jkGXWIh1C+kyzGMKH4I
	 kCIh7oxJQPUQQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:14:01 +0200
Subject: [PATCH v2 19/21] binfmt_misc: let a bpf handler request loader
 substitution
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-19-e57866e4ae0f@kernel.org>
References: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
In-Reply-To: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6192; i=brauner@kernel.org;
 h=from:subject:message-id; bh=JEHnQJKIYxMGNljTHKNxvVS9XbUmoHNBQb6UspZq9Sw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x0Iyp69LC692Tb8177VGUs2v5W/F367InWtzsVw+
 Yx/AlkJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPZfJfhn4mUucRs2eNKNeUL
 I5LWb1Syy3iefbbl0Cz1CTIFLnEL9jP8lWIu7FNx2zXh66HTfMe5JXTMnYInC9socc52z2qyjM/
 kBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: dnq71neeoikbztg1efsqh3eucszugo8m
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D3710C0015
X-Rspam-User: 
X-HE-Tag: 1784643326-669554
X-HE-Meta: U2FsdGVkX18/Uz5RKYuJfeP0Ha9ycrgJsIegpZhFyefMFKcrOIoXojpr3yVzVL3t8ZVrFiWqOw6OsKkPLwP3iLHrWwUxqgQj7Huq9hJs3ClihrRhFe9kFE67ZayM1g3HNfXlTA3cP0kcDYSdhNtK2sS7+zREMnj35T/V7ltG5+fvdig1RaCH0gfrv7wnHu02A400rpPSUsbG7KDfZhHYNjM8jnF+duoZwsWaowu37OMRauCJ19uE51swOAr7KgKkZeOVyJ5Fa3rnDRi7IYWSBpu96Ny9G2PDc0G72j797qXCiFgCuley+b4G+Tv0+yr5y2kvBL3WaahnP4VaEUGFt6sqgO3NNtkqISi05DDV1AXi3iwL6h2kiH4Q2tXIq0LqkW6mQv0bmMeRQ2MHPdm44wSUN4YbgmxX7CLY+vgOj8ps5fAozOFGMmp6q1BNQ4Uz4mMAeDohhh/Y/nfK1U8+6MXfheCTdf+rCefErWO3GRtXDljiRsCn0gDRC9DfVr7YXXFzLlo+S8RomuT9kMFEtnYgfe2ZXpV11JH7nT8x9zfW/Zpvpewl4hN8zhZlidv4klCYkD7D4J5NvXj0T1IjjXb4I/4GzaavwvNeqlgnqEVL3mnUtPJVUanfAdJxRQn5SN2ZomtyEp9NeN6GVjQqWsg54RBUymQWTbvDHox4A1ikJrhIQ8MCE3HtlIkUdOv8aDJv67Vl5m8BFJ3r1qlmIECdhNAnozlQggMOfatWC1U9ZvH59kHwVe6ZQeDgz0FgSR+gGS6UD/7iAN3lFClpwovsUd5eOgWuLqXN05AKbyhIG9N9jkRraieQRTOY6q62aUAxj7kDXWjkuw/CjopCiqNgUtcds9x55qBpATb/iMuaGHorDAavxTIXnT7GGlK9/jeqDGohbZchral/lFAZaawExp2Kc6qfpa6144IIJGEBE4vmn71mXl6T/Nr/HCbPJA24znkdQvtlnrvGwCQ
 bzc7eWbH
 gxADa+RUMW3F/u75fgV5uzGItiE64/Tc+AlDmeEAkIJktr26F9nwL7qOCOCRgouCQS4/2LIyU67+UP2Y6G3xTvrs6Ne5VRpY9zeNaVQYCPq+IP9lktcoW7cHk3GcwdZ/Q2HWHM0MuXUWcSUrursCAET5IyhxfRUabW+PKlHl2UvCWn69Vut0iR3keq+VPoAJFClWb5uaThKy/7aKYQ7dRJ1TGPPTbPmG893Srbzg946xyHZyT81oLswcwK+c3YbqJNJ61pq9hwlpDQYucm18IO6v2bqbwPtO73nA7s1GNgZcz/aJU4pLNvDMV/jOXbh/OPfRYFQBMxtMklbCSicikM6098HdaGaaHs7cPJKxTCB3vTqxLanldbz+zo974XMfv21y0ZTaAsQLcQtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Give bpf handlers the per-exec equivalent of the static 'L' flag. A
load program that sets BPF_BINPRM_LOADER has its selected interpreter
substituted for the binary's PT_INTERP instead of run with the binary
as payload. The binary otherwise executes as a fully native exec.

A single handler can now grade its dispatch per binary: native-arch ELF
with PT_INTERP gets loader substitution for full native identity.
Anything else, such as foreign arch, static, non-ELF can use transparent
or classic dispatch. The load program can read the binary's ELF header
from bprm->buf to make that call.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst |  9 ++++++---
 fs/binfmt_misc.c                          |  2 ++
 fs/binfmt_misc_bpf.c                      | 17 ++++++++++++-----
 include/linux/binfmt_misc.h               |  4 ++++
 4 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index a9f685077925..72b389d61f6f 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -197,9 +197,9 @@ interpreter line, e.g. for a handler that resolves ``$ORIGIN`` in a script's
 ``#!`` path and needs to preserve the argument that followed it.
 
 The invocation flags a static entry fixes at registration - ``P``, ``C``,
-``O`` and ``T`` - are per-exec choices for a bpf handler, made by the ``load``
-program with the ``bpf_binprm_set_flags()`` kfunc, so a single handler can
-decide them differently for each binary it handles:
+``O``, ``T`` and ``L`` - are per-exec choices for a bpf handler, made by the
+``load`` program with the ``bpf_binprm_set_flags()`` kfunc, so a single
+handler can decide them differently for each binary it handles:
 
 - ``BPF_BINPRM_PRESERVE_ARGV0`` keeps the caller's ``argv[0]`` (the ``P``
   flag).
@@ -220,6 +220,9 @@ decide them differently for each binary it handles:
   run a binary passed as an inaccessible ``O_CLOEXEC`` file descriptor to
   ``execveat()``, which a path-splicing dispatch cannot: the interpreter
   has no path by which to open it.
+- ``BPF_BINPRM_LOADER`` substitutes the interpreter for the binary's
+  ``PT_INTERP`` and runs the binary as a fully native exec (the ``L``
+  flag). It excludes the other flags and a staged interpreter argument.
 
 Because these are program choices, a ``B`` entry carries no flags in the
 register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index a60e69e4514f..a68f6c18c5cf 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -355,6 +355,8 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 		flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
 	if (bpf_flags & BPF_BINPRM_TRANSPARENT)
 		flags |= MISC_FMT_TRANSPARENT | MISC_FMT_OPEN_BINARY;
+	if (bpf_flags & BPF_BINPRM_LOADER)
+		flags |= MISC_FMT_LOADER;
 
 	return flags;
 }
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index c3d1b8c51f90..92003ea640d3 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -174,13 +174,15 @@ __bpf_kfunc int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
  * @flags: an OR of enum bpf_binprm_flags values
  *
  * To be called from the load program of a struct binfmt_misc_ops handler. It
- * decides per exec what a static entry fixes at registration with the P, C, O
- * and T flags: BPF_BINPRM_PRESERVE_ARGV0 keeps the caller's argv[0],
+ * decides per exec what a static entry fixes at registration with the P, C,
+ * O, T and L flags: BPF_BINPRM_PRESERVE_ARGV0 keeps the caller's argv[0],
  * BPF_BINPRM_CREDENTIALS computes credentials from the binary, and
  * BPF_BINPRM_EXECFD hands the binary to the interpreter through AT_EXECFD.
  * BPF_BINPRM_TRANSPARENT additionally leaves the argument vector untouched,
- * making the exec look like a direct execution of the binary. Calling it
- * again replaces the flags, passing zero clears them again.
+ * making the exec look like a direct execution of the binary.
+ * BPF_BINPRM_LOADER substitutes the interpreter for the binary's PT_INTERP
+ * and runs the binary as a native exec; it excludes every other flag.
+ * Calling it again replaces the flags, passing zero clears them again.
  *
  * Return: 0 on success, -EINVAL if @flags contains an unknown bit or an
  * invalid combination
@@ -189,7 +191,12 @@ __bpf_kfunc int bpf_binprm_set_flags(struct linux_binprm *bprm,
 				     enum bpf_binprm_flags flags)
 {
 	if (flags & ~(BPF_BINPRM_PRESERVE_ARGV0 | BPF_BINPRM_CREDENTIALS |
-		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT))
+		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT |
+		      BPF_BINPRM_LOADER))
+		return -EINVAL;
+
+	/* Loader substitution is a native exec: no splice, execfd or creds work. */
+	if ((flags & BPF_BINPRM_LOADER) && (flags & ~BPF_BINPRM_LOADER))
 		return -EINVAL;
 
 	/* Transparency preserves the whole argv, argv[0] included. */
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index 26da749391b4..4abdfd36b3fa 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -19,6 +19,9 @@ struct user_namespace;
  * @BPF_BINPRM_TRANSPARENT: leave argv untouched, the interpreter takes the
  *                          binary from AT_EXECFD (like the 'T' flag); implies
  *                          execfd, excludes preserve-argv0
+ * @BPF_BINPRM_LOADER: substitute the interpreter for the binary's PT_INTERP
+ *                     and run the binary as a native exec (like the 'L'
+ *                     flag); excludes every other flag
  *
  * Set from a load program with bpf_binprm_set_flags(). Unlike a static entry,
  * a bpf handler chooses these per exec rather than once at registration.
@@ -28,6 +31,7 @@ enum bpf_binprm_flags {
 	BPF_BINPRM_CREDENTIALS		= (1ULL << 1),
 	BPF_BINPRM_EXECFD		= (1ULL << 2),
 	BPF_BINPRM_TRANSPARENT		= (1ULL << 3),
+	BPF_BINPRM_LOADER		= (1ULL << 4),
 };
 
 /**

-- 
2.53.0


