Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A766C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C706B00A3; Tue, 21 Jul 2026 10:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF6D6B00A4; Tue, 21 Jul 2026 10:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4FC6B00A5; Tue, 21 Jul 2026 10:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A9E96B00A3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22F6BA02C3
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:01 +0000 (UTC)
X-FDA: 85012980402.21.7F201E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3297540010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR6OB0eJ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S85u9Vd8bwRPw9yrtEJnMsDDfBmi6Cn6GYO5y60rirM=;
	b=TXP5TgN+NiRApwZcHfgylsRiU3Of7q0gtq/JlVn+E350ru6sXastMmhNM2PCZDTtJdcH3I
	lXdwcWyaI1y2Ow0MPAdc7E0jieJk1ii3hdkJWhC64HR1wDtB4WcQ2Ys8SU9QUdOOZn5VXS
	Om0JlZFSMMpTBaBJlkGuaPuJyZ2O940=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jR6OB0eJ;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643299;
	b=T3PmzBk16OfEs10L6P9XeQgri5mIcepsLDbnIUHES6WAT7kij2mFW1TtPlRVPeAJInd6ht
	pPtRg5ETS/AqwM+Z+I/+LNJ1Wc+MNCn8bHrMjwRdfAkRPGxiWKa+TfVOAMZN4GudTlWHX9
	IfRYRMUSqyJ2SpGrpHmGc60TnhA7LFg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CACFD600D8;
	Tue, 21 Jul 2026 14:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D4F1F00A3E;
	Tue, 21 Jul 2026 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643298;
	bh=S85u9Vd8bwRPw9yrtEJnMsDDfBmi6Cn6GYO5y60rirM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jR6OB0eJepuUgW+8RX4cCYqijbPsezCmjsHq90yIEN/6kgju0pIpbCyHiE1GM9jme
	 fDWkxxfI6C7Tt7gN7+LeVOmppiea60KFBIME41ZDLGPu5aERAX9JGg8JFZt8Bcf2Xz
	 zqo9tvq0hmRqydJEqE5gep/4f2UZBtXu0d29v/zEDYTZi5fqyTgUSPTRwxZXJpsKBy
	 tT1tLfi6Xn754CPZN46nsxWB5Vr5z0+TxmM+yZZqGdUnTK7DxbuB/FfdS8FqnTjhkL
	 emTYVKdUJBakbDrpfcrmNdvXr63XsSAZ1GYzhQVbiB+g4+X3OUX1vbRfxO+hHp/81n
	 nYO0POQo1sW6Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:13:52 +0200
Subject: [PATCH v2 10/21] binfmt_misc: add transparent interpreter dispatch
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-10-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4238; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DSYNqcIM1+jrmVAVu+qrpBRkYhiyLa1vNJEMqRXR1aY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x1wO/crMUBx8t/50vx2Mey8vtPP+rDvvt78b3rXi
 yXcYm++d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExESp6R4ecxtagJQQUX1jzq
 P/9hC7dp4W25X399lS36+v6+WP/n2hZGhjfTbs9aHVG4cG7O+ml307dNWNM676j8HZvNE1IdN0W
 XtjEAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 3297540010
X-Rspam-User: 
X-Stat-Signature: j36rpufen3axtptg34ferypnxmmu9j34
X-Rspamd-Server: rspam04
X-HE-Tag: 1784643299-71956
X-HE-Meta: U2FsdGVkX18PuMP8cd9G6z020VXhpOP5wOwvlTFRwjXShMlXE5mbl4l0w47QjfftegvzAcbTj2mXfERyn/eWByjm2YGjnKhXTqoJQjuh5lVoUjO/axo2HuVAOm6K4LcB6oGqq46hy3JMC0uYWgIFAkJ42OHxEe8FcAGyWQIxvg8ZvyAKbOKc4nt3MPh2ONesx83Iu5VySR2bGVH3RYbspp7opMO9/0yMpLro0pS7/v3pCPJE2n05x8emNzG/iM538uD7EVBxpxafCH+yat8yXB0271RhB+6zI5kwM+5ozORgA1y0bZYDvv2tmKMeH2Dca0kUDk1H1Qldd4dk5xYyUa4vKW+nloucT/sZqyjWxUsunFA3YGGMxrdHN6AOIFjx5+2gGyIHqR1ggHzFAJmuE+r7OGmYtrh1kVojPlWkDkpQl56PyMRwAcDPDf3Ye1QsnSqZSWQfi7Zasc+orTDUuEAbShrX8jM/XYl/29j2igYb2PPW6zk5AgvSGpkc/aNXgMjau4e3cU91wEVEFXoVff+BiVFiHQizlxYRhpKYW71SH3P2xCVmWa8AwrwKZbTy/eslti2XNiTMb0z0LQIA0SMBdaYmh90K+/HXggfAO6rhmkUpCDFZAUPdETj+jpFHPHOYuEXSOmdxODO9fyFT686VpKiSutA6MM2Brsm9gARte+D+7V6k+dBRM0FQWUtUd87Tw6/endQOBXKk0zFU1Dh8pavmf57vm7019R2zBiCVDFqdprFSTElH8OcYha1gcomlVgayCm8Xd5EzM+2w8RTeI33AVuc2d/UISkOQtU2RW+LiYXC/6ZSdU7x+LPiPACCzky8bhPwS+uNftZts+hLe3mMLATM1fVkswz+oxPFHQChpr3hEax6dUqnNsR5L4XdAPkQm640ybBQl4Ea2DdGvaORmrVXT4ZN8AHWtZUVkhBTdhg7otBGN8eJQIn2lsfgpb2QXRl+ULlgM17r
 KVCWSJJ2
 DE34viGt7+pw+XPsWnbINqL0fPZzsYM51ItDOG9qHtxu6cb9giqW6TvxUHG7vzpIkrxudbNjn0I9cabBccL6HjpYChlQ5HpSPLexGfKut7nc3WN8x7SlNOsmYrz7CT+BQS1QXeonI0wYKhVGnBAANzGYmr+vM3UsIN0dgdQh+cDjTsIiO2JA0auEP0NPzBOskfmZyZz7OA/wf9Qp7vMMitUfJo57zVGRg4rsL9FuDSyZqpPBjIRHvqxmMhrS5mv2JtiqaOKBlGtBa018VuGsgmMhwVUkE91x2ekClE5MAjSsgXie+9XhMz0ivzCZxwtjALlSLp11ruRiBmhkIAMNWYvmRHh+hPnb1Dft2dxs+1iQ0jrkb2M6MxLxWo5nsXa6zAXoEK3xaU0BJTFN+Uj1OWwoWAUNgzbkbdq/j53OGhZzVJj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A binfmt_misc interpreter is visible to the binary it runs. argv[0]
becomes the interpreter path and the binary's path is appended as an
argument and /proc/pid/cmdline shows both. For wine or qemu-user that is
the point. For a per-binary loader the interpreter is an implementation
detail of running the binary that has no business in the argument
vector. And a binary handed to execveat() as an O_CLOEXEC fd without a
usable path cannot be run through binfmt_misc at all. The interpreter
would have no path to open the binary by.

Add the dispatch machinery for a transparent mode. The binary is handed
to the interpreter through AT_EXECFD. The argument vector and
bprm->interp are left exactly as the caller set them. argv[0] and
/proc/pid/cmdline look like a direct execution of the binary.

The interpreter loads the binary from AT_EXECFD for this. A relocatable
loader can and glibc's ld.so is gaining AT_EXECFD support [1]. A staged
interpreter argument is rejected: no argv slot is built for it to land
in.

The transparent branch raises BINPRM_FLAGS_TRANSPARENT_INTERP. A
dispatch through it labels mm->exe_file with the binary and raises
AT_FLAGS_TRANSPARENT_INTERP next to AT_EXECFD. The aux vector bit is the
loader's hint to retarget saved_auxv and the statistics markers to the
binary, which is only correct while the exe link names the binary too.

The inaccessible-path bail moves after handler selection and into the
path-building branch. A transparent interpreter takes the binary from
AT_EXECFD instead of a path, so the restriction does not apply to it
and the O_CLOEXEC execveat() case above can work. Nothing can take the
transparent branch yet.

Link: https://inbox.sourceware.org/libc-alpha/20260717-work-glibc-binfmt_misc-v3-0-45129bfb13fe@kernel.org [1]
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 304109a5091f..e5a17ca935ca 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -50,6 +50,7 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_OPEN_BINARY	= (1U << 30),
 	MISC_FMT_CREDENTIALS	= (1U << 29),
 	MISC_FMT_OPEN_FILE	= (1U << 28),
+	MISC_FMT_TRANSPARENT	= (1U << 27),
 };
 
 /**
@@ -400,6 +401,10 @@ static int build_interp_argv(struct linux_binprm *bprm, const char *interpreter,
 {
 	int retval;
 
+	/* The interpreter has to be able to load the binary by path. */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	/* The entry's own choice - not one accumulated from an earlier level. */
 	if (flags & MISC_FMT_PRESERVE_ARGV0) {
 		bprm->interp_flags |= BINPRM_FLAGS_PRESERVE_ARGV0;
@@ -458,21 +463,23 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (!fmt)
 		return -ENOEXEC;
 
-	/* Need to be able to load the file after exec */
-	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
-		return -ENOENT;
-
 	interpreter = entry_select_interpreter(fmt, bprm);
 	if (IS_ERR(interpreter))
 		return PTR_ERR(interpreter);
 
 	flags = entry_invocation_flags(fmt, bprm);
 
-	retval = build_interp_argv(bprm, interpreter, flags);
-	if (retval)
-		return retval;
+	/* No argv is built for a staged argument to land in. */
+	if ((flags & MISC_FMT_TRANSPARENT) && bprm->bpf_interp_arg)
+		return -EINVAL;
 
-	/* Update interp in case binfmt_script needs it. */
+	if (!(flags & MISC_FMT_TRANSPARENT)) {
+		retval = build_interp_argv(bprm, interpreter, flags);
+		if (retval)
+			return retval;
+	}
+
+	/* Update interp for the next round; sched_prepare_exec reports it. */
 	retval = bprm_change_interp(interpreter, bprm);
 	if (retval < 0)
 		return retval;
@@ -481,6 +488,10 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (IS_ERR(interp_file))
 		return PTR_ERR(interp_file);
 
+	/* Raise only past the last failure, or an -ENOEXEC decline leaks it. */
+	if (flags & MISC_FMT_TRANSPARENT)
+		bprm->interp_flags |= BINPRM_FLAGS_TRANSPARENT_INTERP;
+
 	bprm->interpreter = interp_file;
 	if (flags & MISC_FMT_OPEN_BINARY)
 		bprm->have_execfd = 1;

-- 
2.53.0


