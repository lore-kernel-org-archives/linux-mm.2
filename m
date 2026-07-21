Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B503DC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17B56B00BA; Tue, 21 Jul 2026 10:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7716B00BC; Tue, 21 Jul 2026 10:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9064A6B00BD; Tue, 21 Jul 2026 10:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 426C96B00BA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:15:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD7E1120163
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:25 +0000 (UTC)
X-FDA: 85012981410.08.AF22BDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3F058000C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:15:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bzm0LzOm;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woNR9nUmR4fnrmuwxeA19vlJY8p3K9kHmFu6j7jog6U=;
	b=7r3ChRYvYE22I1DB+5K/JFQYP2o8jhL2obKwPP7NWpnPV1hHuZlM8kVAK5XG6HpjvKqCf7
	yxM0AIxXMfZdI7+dd+dWm+V83MUAH4262tg89GYivAptxoLLJdjy4JzLfCJG9ytKDBTmHz
	RUPRW63me8ru112bW+AGf2Kg4wj0gZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bzm0LzOm;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643324;
	b=z+52Myr7d1QF6hVDqnfAN7vF+Ri1ygUB+cJS/ZA6TYpQw58SYj1UevdeYSqxDlC3pu7alV
	6OQq/YvijqpSBl8QX7WAHUF+YW/DSpAJuvsLMGnq91qYnmYqWir5Lxpp4ld8mR0qQzryX6
	KDgLBwm2Jf9FpRmPK+aBEPddEaqFHqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BDAC405AC;
	Tue, 21 Jul 2026 14:15:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA001F000E9;
	Tue, 21 Jul 2026 14:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643323;
	bh=woNR9nUmR4fnrmuwxeA19vlJY8p3K9kHmFu6j7jog6U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Bzm0LzOmuw3ZP/Yn70Vbui30ezGB96gmFNfjQZFYm8Io/qZifqjqI6dHKJO8RAelv
	 dSQtV89iB/jOsR0D4e16JviawBR1BG7oZEkLIlbO+0zk5b73dvf15MgKTxpcOjmjxn
	 FHkXkeSbhZ+Qak8FkPF4YPzGT1pK8CPxgXv4vclawkkn1wmR91CYrylDIDnLYZ7qLy
	 EDj0CovKoPV2ol4lgaR4zHyDMGSGcUhOJkWSkkn2d0ZeEd1VFY4wcx8CXQIw8JcLqi
	 0CkdL0bs/ppIP2dinLwlTb4AZu/O5kWN8/vvsrR9VeY/6FGcH2C6UDfU7Ws+v4LEkf
	 KFVxvOe2Ntrcw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 21 Jul 2026 16:14:00 +0200
Subject: [PATCH v2 18/21] binfmt_misc: add the 'L' loader substitution flag
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-18-e57866e4ae0f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=6343; i=brauner@kernel.org;
 h=from:subject:message-id; bh=wdkZgOe/8vQSPskeqBA3ngJtdEFYbMDm4FoSAnRSB8A=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1x14+mPlT6NLC2astjKa7691K7LIR/71FIE9lnbu3
 JbODRsOdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzE5jzDX9lY5qaOo8V6d+pe
 /Xb4xvJ69Y4Y5aw65cnnze+e4fuaac7wz6i8Q8/zAidr5M20PxeuRm09Fee/+IjC9okq8rbq3y/
 +4wIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E3F058000C
X-Stat-Signature: 1o35hkkzqz5k87pzj3apwwnxy8nffjzy
X-HE-Tag: 1784643323-683505
X-HE-Meta: U2FsdGVkX18wiPBnYuXD8Z5ahxhW83v7I2o5/0XRx4kxJXqYyloUKBCgHMkfhWoLsLwJykf1G0fu847m5sr9vChoU6moX0l3F0cAYd6IVh4rWF8zBZeuaWi9ipD3fuGb1OZx58AlSJwmes1UE3eQcaV3J4PY4MEQT6cQ6v9jkGqnP3Kf9cy0UEybuajJGyJdJFu3iagIMv7MZwQmUvvJoJfhmCY3rqCfGpnn2H4VErBJOdfsH9h4Aj94p6KEurjzEnS3DWixO6Nd+sXxpRRpf6mlI2FOxyjgsXWn540h8gvDY48gdp3hXreIc79nX3G5VmFMpHTWEDZSeCjH5oO/V9FT0Fx2+cLJR5Sr3ez9YGpEmDqcX864X54M6fKE6I378g2JeULli9c1sPA4L//3DwMNvAoEisQZJO4ghIzF5bxz33EDjNf2e5KnACmbOSqk4Dr/TsTMutzmmMY6zLHUYewuLES9KB1LkU5H2sPqddMvNrRKjKmSEqWixB31q+UoAgWnOcQGIOPQMxfAxUI+qI2qEXlxPeK6+hVt/pnBi1hUhXhp4C0YZkJTlOJUJyCnjLeMVHjgC5Br0PBFhJcwwyz7RHudcUEgbWgMmc+P8rUpVNeCi8lUk2Q27HEFJsk9qwqz5o9JqznhMrx1tVaJ91Q/zE9TsnFszv/wQqr2Gfsyg8DKO4ZKvmey1bAWoHsVRENbsartm9gjREsKBy8QYEYcjU7IQ2mxuMaJnI3DJ1rdRGJyu0LcfiNF9DVcBG/7BIgsNQGUGeV2YLz8zPcrD73PjW4Y7fUDlyu2g+G0ADc2W6UjWKQ7joTdyF3qCaWtjeBS++l5noEw4QkR01brIax/6ASbUTywnP0h3aQkWE1J8gnYynM0hcRfdXtZlqPfWrsvaOfNf8fQX7swRw3Ky4MwTLOR/NppZgZjI61r/WlCJ4kuujPAApOe3A50QY1Zy7Zss4vKM01HAnT8Ei2
 tnFPcIXt
 gLYQSSCGyG1aiO9iy8hpI13FOjhXvdNU5ktV43DSFGfkjLvW+fMWvnnQaZ9upAp1B00s/O8qWfRR0igwuiJgPzMQ8J0IqrOUnQo1TuWmRf5aM9rNfQqD7fqk/zJ5HTpMfI46ZyON2BAseBfaKq9e7MCXHElbzC6/0FRst9r8Il2IFTpvH+jUFXOUrDAW5FwfhkMiLME2OuqDeniQPwVn9zamNEUPF3NsqIq6HrogExAtVEv1cPU8Vnl7hizCXKEH1J43MSUblasbC3zOqru6VpQXU1gLnsRxuIS2FGwqL6tlp7YoC3gTKYGcfHqNzeWx540DCBwDPwYRDT0+ibUxmCS0+5qTt6elovwrmVKbT6RP7749e/U2B2lEl6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the first activation of the PT_INTERP substitution machinery. A
static entry registered with the new 'L' flag no longer runs the
registered interpreter with the binary as payload. It stashes the
interpreter as bprm->loader and declines the match with -ENOEXEC. The
format search continues in the same round. binfmt_elf claims the binary
as a fully native exec and substitutes the stashed file for the binary's
PT_INTERP.

'L' rejects every classic-dispatch flag at registration. 'T', 'P' and
'O' have nothing to act on (no argv splice, no execfd) and 'C' is
subsumed (credentials derive from the binary natively). 'F' composes and
is valuable: with it the substitute is pre-opened at registration time
and immune to mount namespace changes. Without it the substitute is
opened at exec time in the exec'ing task's context, so 'L' joins 'C' in
the requirement that the interpreter be named by an absolute path. As
with 'C', only trusted interpreters should be registered. The
substituted loader runs with credentials derived from the binary.

Like the other flag characters 'L' cannot be used as the field
delimiter. The flag scan would run off the registration buffer.

The interpreter open is shared with the classic path via the
entry_open_interpreter() helper. An open error fails the exec. Map
-ENOEXEC to -EACCES to avoid letting the binary run with its own
PT_INTERP.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/admin-guide/binfmt-misc.rst | 15 ++++++++++----
 fs/binfmt_misc.c                          | 33 +++++++++++++++++++++++++++++--
 2 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/binfmt-misc.rst b/Documentation/admin-guide/binfmt-misc.rst
index ea1c1c0676c8..a9f685077925 100644
--- a/Documentation/admin-guide/binfmt-misc.rst
+++ b/Documentation/admin-guide/binfmt-misc.rst
@@ -100,6 +100,13 @@ Here is what the fields mean:
             ``AT_FLAGS_TRANSPARENT_INTERP`` contract. Combining ``T``
             with ``P`` is rejected: transparency preserves the whole
             argument vector, argv[0] included.
+      ``L`` - loader substitution
+            Do not run the interpreter on the binary at all: load the
+            binary itself as a fully native exec and substitute the
+            interpreter for the loader named in the binary's
+            ``PT_INTERP``. See the "Loader substitution" section
+            below. ``L`` rejects ``T``, ``P``, ``O`` and ``C``;
+            ``F`` composes.
 
 
 There are some restrictions:
@@ -108,10 +115,10 @@ There are some restrictions:
  - the magic must reside in the first 128 bytes of the file, i.e.
    offset+size(magic) has to be less than 128
  - the interpreter string may not exceed 127 characters
- - an interpreter used with ``C`` but without ``F`` has to be named by an
-   absolute path. It is opened when the binary is executed, so a relative
-   one would be resolved against the working directory of whoever runs
-   the binary
+ - an interpreter used with ``C`` or ``L`` but without ``F`` has to be
+   named by an absolute path. It is opened when the binary is executed, so
+   a relative one would be resolved against the working directory of
+   whoever runs the binary
 
 
 To use binfmt_misc you have to mount it first. You can mount it with
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 622c62ee6683..a60e69e4514f 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -51,6 +51,7 @@ enum binfmt_misc_entry_flags {
 	MISC_FMT_CREDENTIALS	= (1U << 29),
 	MISC_FMT_OPEN_FILE	= (1U << 28),
 	MISC_FMT_TRANSPARENT	= (1U << 27),
+	MISC_FMT_LOADER		= (1U << 26),
 };
 
 /**
@@ -73,6 +74,7 @@ static const struct binfmt_misc_flag misc_flags[] = {
 	{ 'C', MISC_FMT_CREDENTIALS,	MISC_FMT_OPEN_BINARY,	"credentials from the binary"	},
 	{ 'F', MISC_FMT_OPEN_FILE,	0,			"open interpreter file now"	},
 	{ 'T', MISC_FMT_TRANSPARENT,	MISC_FMT_OPEN_BINARY,	"transparent"			},
+	{ 'L', MISC_FMT_LOADER,		0,			"loader substitution"		},
 };
 
 /* Look up a flag character, NULL if @c is not one. */
@@ -458,6 +460,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	unsigned long flags;
 	int retval;
 
+	/* Only binfmt_misc stages one and exec_binprm() clears it per round. */
+	WARN_ON_ONCE(bprm->loader);
+
 	misc = current_binfmt_misc();
 	if (!READ_ONCE(misc->enabled))
 		return -ENOEXEC;
@@ -473,9 +478,27 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	flags = entry_invocation_flags(fmt, bprm);
 
 	/* No argv is built for a staged argument to land in. */
-	if ((flags & MISC_FMT_TRANSPARENT) && bprm->bpf_interp_arg)
+	if ((flags & (MISC_FMT_LOADER | MISC_FMT_TRANSPARENT)) &&
+	    bprm->bpf_interp_arg)
 		return -EINVAL;
 
+	/*
+	 * Stash the interpreter for binfmt_elf to consume in place of the
+	 * binary's PT_INTERP and decline the match, so the search continues
+	 * to the real format in the same round.
+	 */
+	if (flags & MISC_FMT_LOADER) {
+		interp_file = entry_open_interpreter(fmt, interpreter);
+		if (IS_ERR(interp_file)) {
+			retval = PTR_ERR(interp_file);
+			/* Declining here would run the binary's own PT_INTERP. */
+			return retval == -ENOEXEC ? -EACCES : retval;
+		}
+
+		bprm->loader = interp_file;
+		return -ENOEXEC;
+	}
+
 	if (!(flags & MISC_FMT_TRANSPARENT)) {
 		retval = build_interp_argv(bprm, interpreter, flags);
 		if (retval)
@@ -772,13 +795,19 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	    (e->flags & MISC_FMT_PRESERVE_ARGV0))
 		return ERR_PTR(-EINVAL);
 
+	/* A native exec splices no argv, passes no execfd and needs no creds. */
+	if ((e->flags & MISC_FMT_LOADER) &&
+	    (e->flags & (MISC_FMT_TRANSPARENT | MISC_FMT_PRESERVE_ARGV0 |
+			 MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY)))
+		return ERR_PTR(-EINVAL);
+
 	if (*p == '\n')
 		p++;
 	if (p != buf + count)
 		return ERR_PTR(-EINVAL);
 
 	/* Non-F opens the interp at exec against the caller's cwd; require absolute. */
-	if ((e->flags & MISC_FMT_CREDENTIALS) &&
+	if ((e->flags & (MISC_FMT_LOADER | MISC_FMT_CREDENTIALS)) &&
 	    !(e->flags & MISC_FMT_OPEN_FILE) &&
 	    e->interpreter[0] != '/')
 		return ERR_PTR(-EINVAL);

-- 
2.53.0


