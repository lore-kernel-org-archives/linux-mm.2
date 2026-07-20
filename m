Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20584C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4E0F6B00D5; Mon, 20 Jul 2026 05:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E257B6B00D7; Mon, 20 Jul 2026 05:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62586B00D8; Mon, 20 Jul 2026 05:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B216F6B00D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 364DBC0765
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:40 +0000 (UTC)
X-FDA: 85008645120.15.E4B7BC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 79F9AC0005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlHE95JD;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540078;
	b=zDkzkjeo8FjhBkhDpG1qWKQl5zv1qut4HU1NCJE68jsHT9aKpY3ZwScPTlq2diCZJyDp+A
	L+FHhdddPze6gb8TymSiLPBUwrLMTN1+X47aHIP857KoKdJdoLx7QwNtmoikklOYsFgX0R
	Fna084OJEjQciuqhgKf76YCEnLBTj0A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DlHE95JD;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DJlxoJb8mj+WdjBr8RFMm+t5S+/1moQSu0uwd7mnqw=;
	b=vRDKNEEAeQwvQVQZ/uog36ZkP/mOla3XotKhAQDtBOqyjtEKaEyS3jS3X3RjTeHHwJ0DS9
	AY3jFessO1+M0/7PRekk8jj1ZSheQve5nrWr6addtek50roGUS6q34CjpZRo8tS6Nb6D+Q
	RyeqUGL72UPhDCI/cZ9fNX9ee948vD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12AD260A7B;
	Mon, 20 Jul 2026 09:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F9F1F000E9;
	Mon, 20 Jul 2026 09:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540077;
	bh=+DJlxoJb8mj+WdjBr8RFMm+t5S+/1moQSu0uwd7mnqw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DlHE95JDp4x34D0xBiIKdo9k67NeH/iO/Pb1biaLSXfCioymivvQu0UU0wSueR7Dp
	 MuHfN3b9KFCwvmXNzl4F1WnjGtTIasEefrrfhbIlM2wYuEaa54m+8OPGE8n9yo3Tmt
	 uUrvRpGj9FqdctyBoTmGLxR89zZbb5chEFxu2MDNu4GXtfgAzDtRrwJTQNinjzv/FJ
	 7dFN4C91PiEorLS4q9Y1Dc5wlXZX7G70+Tv8vU7w7smbgOfPbZIHPsrs6ootzGL7HE
	 2+paASVXeMqPA0cDC4fT5m+kD/j+gsJxuuuIlgPu1cXoBKC25gRk0oHo1VsnRezXVc
	 oQ+7PuPZxJT/Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 20 Jul 2026 11:33:35 +0200
Subject: [PATCH 12/21] binfmt_misc: let a bpf handler run the interpreter
 transparently
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-12-ddb76c9a508e@kernel.org>
References: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
In-Reply-To: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5682; i=brauner@kernel.org;
 h=from:subject:message-id; bh=v5tPPCv52wsIeRY9DExjXFBdHey3BU0E6nUWdZfYbOc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm5yO6p+4HjCxn9ti9579mU83vAzd8e0zbt/y1mmq
 F85yMz5t6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiR1czMvS6uJ1evotRw+DF
 etNJB2aZeZg8cYs+l1yh1Xz5XorO8wOMDL/1nhwPXeE1YdLtU8oqr+u/G2+b5cm0LEpm3Z73D7Q
 e3OIFAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 79F9AC0005
X-Stat-Signature: e7j6bnw4s1styaxcehtkcamnp4d6eqiy
X-HE-Tag: 1784540078-813587
X-HE-Meta: U2FsdGVkX19aofxLqckvONdhoeJkxXAtCVIMfnZDQCWDUicON9hi412B+DcaCdflC67vbww+kVEsQDUDQpf2L3fZDqzVbP5sEFsripAeg1IqxcsXyalEvrr8u0l0Ms2/1IBMOSjAm9QTWQMto+WXhRpTbzBehaZwajwiXuAGiPQfXpOTuSGn5MCCl2VKm6kQE++62nUFATMlO9arBNM0Al/BiiGzvFdaEry7Jlq56nR5h6mIYGbtrSbZcv5yu3mTd8hSiyA28QJb1l1TKOKo6ECy0UKR+R4eL7veez9LXEcQl6wRk0v4ZDVkswO2SF6t9fzJ6DxuKFBET7MSL9l3hNO8XiNhhJayqauuQeYHxRQ0nQH7UivsP71Yqmkr3QSQqhHmrIM2ACZK9Xk6ASaYWNDP1aEePZsJJHK9OP0T0oE0C8UnQMfwElU2dd67XlwBtVUXypUGrfCJ2NL97xQqjDRKFtuwcEdJdCOpTJujRheKJHnJydR9YM4pWmWeRi412F4um3/YP+IsqJSL1yrazqe1O5k7t9wfBnq8Q6ozI4AiogBDIZzuM9rZHDVJCSu9KjSVRSxLZhuzFvuPxIwROwF1rajviCC7hThMm68fXJb/0xbnzRvvX9Ca80Pzf6QlpoYqKJ5lxlpTMT8VlLQxZlNLhZ++hTjsu9Ec6xiW4hsa9YGkI+iFigNbSUzx3BpCvbfCkLWEHcD0LzyUsfjzwaD3Gz+ag/L4KgAdBnQ6T2mOvGNOqM/DCVRkZyGuvgsF8PsEckUnxccDcFJJMqXLHEZhtr1m7jbc8SqzAwAkploFWT7oXDyBkaHqenpagM7PWCxRY9qVvcSTSl5pipYd1b17HbZEtdMxXWDjfMvA/vXyQ1qVG/FOc1aYXzS+t90JvVWeFmdaQ/0aTlpXML1xTuyvavcUFJwoFzs/jTI8VoIn4Ju9wdtK660Rlf235sm0g7cM908EPwY6sYPRAof
 yHe/ivfz
 QB6+PyGcavtoZ2haomFRWd9+b9kGMBodMa8pwx7n/asMIUIYoxLY7v3lpzaLsOG6BqQWQW7vVADePjARzm+F6oYFzD8xQ+IuO1cM83L+aVYBp4dXMwtAaZTS1SuC0tCT6wZz6fwfv2asPZ34wMLfaoEESdrkM7AI2yPaHlXFuXOwgnocLTy+EMcWwd+5Q/meJ8d9wF/4FaZY9NL1jU/i0/n/RPEzwsYsnEYNIFR2dGOnGBGb487V3rn310vODtD4+GbKTW9Q/rNsmbM0hBE1QiL5HZwo0+qpJh1xo8Pt9CL7o131reRFbvoK9V3V8XqeLEE0K4ySO/pvLbWJ9TdLfvQgYYGdyMFbUnm/xK2x+zph9LwLotAnHjL+e9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose transparent mode 'T' to the bpf handler via a new
BPF_BINPRM_TRANSPARENT flag. A bpf handler can decide per binary whether
the dispatch is transparent. This way users may choose a native-looking
loader for one binary and a visible wrapper invocation for the next.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 14 ++++++++++++--
 fs/binfmt_misc.c                          |  2 ++
 fs/binfmt_misc_bpf.c                      | 13 ++++++++++---
 include/linux/binfmt_misc.h               |  4 ++++
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index c370c72c7dbe..b27ad31847ab 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -185,8 +185,8 @@ interpreter and the binary, exactly like the optional argument of a ``#!``
 interpreter line, e.g. for a handler that resolves ``$ORIGIN`` in a script's
 ``#!`` path and needs to preserve the argument that followed it.
 
-The invocation flags a static entry fixes at registration - ``P``, ``C``
-and ``O`` - are per-exec choices for a bpf handler, made by the ``load``
+The invocation flags a static entry fixes at registration - ``P``, ``C``,
+``O`` and ``T`` - are per-exec choices for a bpf handler, made by the ``load``
 program with the ``bpf_binprm_set_flags()`` kfunc, so a single handler can
 decide them differently for each binary it handles:
 
@@ -198,6 +198,16 @@ decide them differently for each binary it handles:
 - ``BPF_BINPRM_EXECFD`` opens the binary on the interpreter's behalf and
   passes it through the ``AT_EXECFD`` aux vector entry (the ``O`` flag), so
   the interpreter can run binaries it could not open by path.
+- ``BPF_BINPRM_TRANSPARENT`` runs the interpreter transparently (the ``T``
+  flag): the binary is handed over through ``AT_EXECFD`` as
+  with ``BPF_BINPRM_EXECFD``, but the argument vector is also left as the
+  caller passed it. An interpreter that loads the binary from ``AT_EXECFD``
+  then appears in ``argv[0]`` and ``/proc/pid/cmdline`` as a direct
+  execution of the binary. ``BPF_BINPRM_PRESERVE_ARGV0`` is rejected in
+  combination with it, just as ``P`` is with ``T``. It also lets a handler
+  run a binary passed as an inaccessible ``O_CLOEXEC`` file descriptor to
+  ``execveat()``, which a path-splicing dispatch cannot: the interpreter
+  has no path by which to open it.
 
 Because these are program choices, a ``B`` entry carries no flags in the
 register string; ``F`` (pre-open a fixed interpreter) has no meaning for it.
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index ed5ffb330749..1cd30dec3fab 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -350,6 +350,8 @@ static unsigned long entry_invocation_flags(const struct binfmt_misc_entry *e,
 		flags |= MISC_FMT_OPEN_BINARY;
 	if (bpf_flags & BPF_BINPRM_CREDENTIALS)
 		flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
+	if (bpf_flags & BPF_BINPRM_TRANSPARENT)
+		flags |= MISC_FMT_TRANSPARENT | MISC_FMT_OPEN_BINARY;
 
 	return flags;
 }
diff --git a/fs/binfmt_misc_bpf.c b/fs/binfmt_misc_bpf.c
index 00c787e8bdcc..d06cacc5c8c7 100644
--- a/fs/binfmt_misc_bpf.c
+++ b/fs/binfmt_misc_bpf.c
@@ -178,15 +178,22 @@ __bpf_kfunc int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
  * O flags: BPF_BINPRM_PRESERVE_ARGV0 keeps the caller's argv[0],
  * BPF_BINPRM_CREDENTIALS computes credentials from the binary, and
  * BPF_BINPRM_EXECFD hands the binary to the interpreter through AT_EXECFD.
- * Calling it again replaces the flags, passing zero clears them again.
+ * BPF_BINPRM_TRANSPARENT additionally leaves the argument vector untouched,
+ * making the exec look like a direct execution of the binary. Calling it
+ * again replaces the flags, passing zero clears them again.
  *
- * Return: 0 on success, -EINVAL if @flags contains an unknown bit
+ * Return: 0 on success, -EINVAL if @flags contains an unknown bit or an
+ * invalid combination
  */
 __bpf_kfunc int bpf_binprm_set_flags(struct linux_binprm *bprm,
 				     enum bpf_binprm_flags flags)
 {
 	if (flags & ~(BPF_BINPRM_PRESERVE_ARGV0 | BPF_BINPRM_CREDENTIALS |
-		      BPF_BINPRM_EXECFD))
+		      BPF_BINPRM_EXECFD | BPF_BINPRM_TRANSPARENT))
+		return -EINVAL;
+
+	/* Transparency preserves the whole argv, argv[0] included. */
+	if ((flags & BPF_BINPRM_TRANSPARENT) && (flags & BPF_BINPRM_PRESERVE_ARGV0))
 		return -EINVAL;
 
 	bprm->bpf_flags = flags;
diff --git a/include/linux/binfmt_misc.h b/include/linux/binfmt_misc.h
index d3112a00cc19..26da749391b4 100644
--- a/include/linux/binfmt_misc.h
+++ b/include/linux/binfmt_misc.h
@@ -16,6 +16,9 @@ struct user_namespace;
  * @BPF_BINPRM_CREDENTIALS: compute credentials from the binary; implies execfd
  *                          (like the 'C' flag)
  * @BPF_BINPRM_EXECFD: pass the binary via AT_EXECFD (like the 'O' flag)
+ * @BPF_BINPRM_TRANSPARENT: leave argv untouched, the interpreter takes the
+ *                          binary from AT_EXECFD (like the 'T' flag); implies
+ *                          execfd, excludes preserve-argv0
  *
  * Set from a load program with bpf_binprm_set_flags(). Unlike a static entry,
  * a bpf handler chooses these per exec rather than once at registration.
@@ -24,6 +27,7 @@ enum bpf_binprm_flags {
 	BPF_BINPRM_PRESERVE_ARGV0	= (1ULL << 0),
 	BPF_BINPRM_CREDENTIALS		= (1ULL << 1),
 	BPF_BINPRM_EXECFD		= (1ULL << 2),
+	BPF_BINPRM_TRANSPARENT		= (1ULL << 3),
 };
 
 /**

-- 
2.53.0


