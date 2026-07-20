Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10723C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F105E6B00BD; Mon, 20 Jul 2026 05:34:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE79F6B00BF; Mon, 20 Jul 2026 05:34:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24E66B00C0; Mon, 20 Jul 2026 05:34:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCFCC6B00BD
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:34:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 458031A07AE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:34:01 +0000 (UTC)
X-FDA: 85008643482.11.54E6EF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 723C940003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:33:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PaPQZpT9;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784540039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+9PXAdO2UaKVPzoZ3fyXMbuva8Rkou9JBquEiugdjeY=;
	b=stN9c/juQpeFmAhfkuL1VdlqKk6HA6XYi9DKAB2IhSjA8OxxMtLUrLbR2pa/QirpFs9vmT
	Kmg7QgSKAiZWKD1caOnkEsl4Rd0max5AyOy00F9LERaIuYIAyALmCFIa64niysthveQFm9
	df0MwW3QbuvnUEjrr3o6YZolPK+fQbQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PaPQZpT9;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784540039;
	b=W5RGt4pa4RIkHHLhjoKGCQPLa8j4E0xFpbrEjmkjM5VePOLtCddSc1FfwxzI33ze0VwzRc
	eDZ6tqRpRSVpAt2ZA58o6ctzG8FMYzOERjCobcwZZ/H6dAt7kZTcJVgUnJWoOWzosNhvCF
	8B1WYVxcICDE0PVw9dLWoD78D4ZoTqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3E0C40968;
	Mon, 20 Jul 2026 09:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D03B1F000E9;
	Mon, 20 Jul 2026 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784540038;
	bh=+9PXAdO2UaKVPzoZ3fyXMbuva8Rkou9JBquEiugdjeY=;
	h=From:Subject:Date:To:Cc;
	b=PaPQZpT9AypcLIyTPiymUQ9bR4BxLN5723OTJO2Hy94rYPFYShPcgTZTrEhUlwnZN
	 0rkzwmu/Jxve/MbklLs4iksRScglZr+9b8ldkM8hTk5O4C9dg9KG0uVqKCEsoYAn41
	 iiOj6L8+wZIxxrBWAzwky3/Ch7PxR1WOgdctVBRjfurPqwnjjDXjvDTGlJbabcvhtv
	 G9BwGGNOqBGC0l651Cx9gnBseDqOQFulTRO5UBZkIe+TsoJR5ugUXA12ntH+ybmZt0
	 Bd4KQEUDZx1lJZZ3tZyBy4KsShy9W9yZdBqlE7TtH8ZLJ2IOTmvEZr3bBaMqLV4o7Q
	 HEyO1/9X9FaUg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/21] binfmt_misc: transparent interpreters and PT_INTERP
 loader substitution
Date: Mon, 20 Jul 2026 11:33:23 +0200
Message-Id: <20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGTrXWoC/yXMUQ6CMBBF0a2Q+XYIYFKsWzHGtHUqo6E0nYomh
 L1b5PO+vJwFhBKTwLlaINHMwlMo0R4qcIMJD0K+l4au6VTTtxo/U3qhjR4tBz/m28jiMGYOmVJ
 EUkRae6+sOUExYiLP379/ue4tb/sklzd0e1gjhDaZ4IZtmr1gXx/rXYd1/QGWS9xDogAAAA==
X-Change-ID: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5288; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GUeN9dHieuYG+yyaxuSbwHPegRQEq5n2SNXT4eMbQKo=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTFvm6MrXjC+ffp8wl93Xw+x3ZrLDeanLL4/d5/axzq7
 m/esrrvfUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEOKYzMjQLLfzjOuPTxtWW
 LB9cqw3fusbILbf4u/D7mXPbN1kvVqli+CuZ9oxx0n+t2UcvnSqerLMlNr9j9ZeLR4t6jgv7trC
 eEmUEAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 723C940003
X-Stat-Signature: gsrossiodomytgba9t7onqhnfts3kdej
X-HE-Tag: 1784540039-14187
X-HE-Meta: U2FsdGVkX1/4EZ4ZwzfYIQ7XY9ZKpvcZolH1dI79ymoKrRdQ5soIi4c03v0Rc7ablRqq8h8c0o9nHIUhog9LMp8ewmFZj5h1sx7JY5EGt0U4LO3NM9eGfwMBMGMvqZ/Dww/2UufZYNZyIS2vnzSE2U2Vf2mCSdR1RaSkaO3oJoUOLdi3soBFItR7QGtxyDVs6RH4dgjMDQACB7J59/+92SIU2nPuPARjfZgDbTgHmptCjW1LQp/Zei9VkN8YKUh7G7sT2776F9yCdsFBza2N9sYkUXmciTYnwSdc1187w6cKjAmO+PAvcvWIrgrhWknJ9x0YuqIQ0u6l0wQ9WnE+v8mKa8wsaOfEPTftX/HSYdb8gwQKNbdvwn5qJzPOMCo/7kaZZKkHnx8m7EuYGaAZ7lUzMskKSSbMjC++ICvsbtHIKprbiCjFQRhKHJZj3phRkqMco67gi8Rcjn9+lHtk20WSJI5tztqruFAMJxqrHfkzePqqe855l2bbf/smaiHfdPa/tvzf5VMwL1KNJnrwdpnzP2dj7CtYdHSpDVs3eVWAUGsanaU+yaRQKHICD9rN/7eytk9Dc04zitx/y19/ay8TsFAFB8bWgW+jcyePwQrm4j5R5yUMv/hIf1kz8xWzvci32N5iz0Gc8cpjEYr+pUlV8qwXrDRXnYmcCh2Ko3aJKKwExR0XANvSdm/0iOA9yBYZZXvnaoUKd/FxLz7oSuj6MIy5mCFY5RAhmv3Syoe7PY5+iYdsd+if1hem+btohukjspKOi1eD1+JxRkaN78sVTx8BItgiJZo1IG4fD02j2P8qds6+oKYnETru2XTYXqXQVaKLCWwZ7O36lfE1QkP7yVI5AfPfbnbS1leSVtqWuls9criDtrApHRwctFbQomUACC36igjxpEZDN3XzQGYV59BmNnFtPl+sDpOWEetiVtIn7G2CWcoU+9Sm9NP+Epi8nsAhDOsUaI3Hgkg
 oHavluK1
 gyhfuwJMx+MTk1HkpwrXPvfVQJDD80rkxY5egLMYyGSmZax8nUaIU3ilNYflPlemr1idYzUX+kkqLHyrqu0SfO0ZlIaPCcLDSbxXiZO7nxBROHH/2kOma7wpG4tDPu9Ejcz/aCv9NbVl+3Ui9Zt43lYMwJpA8HM3o+6UUJ8jep82V0zm7aC31ASuFWExZbvBEEv+QqMIcejcv/fz8hzAREp3Png/P11obG9oVwWpqOtM1yZWPyrbqhgl1nIcdEJbQEqcmJ29ikn782FvXnvaHJ7kDaZusvDRpp9L4MfF0fbkruaHw62uP7KssoL7kaXDzVcYQfL7t2dieZO0A4eBzqlJn6AMGIu9m1HpndTTKC/imiY+Uy1zyqZ6alw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binfmt_misc has exactly one execution model where the registered
interpreter becomes the executed program and the matched binary is
handed to it as an argument. For wine or qemu-user that is the point.
For a per-binary loader it is backwards. The interpreter is an
implementation detail of running the binary, yet it owns the entire
process identity:

- argv[0] and /proc/pid/cmdline show the interpreter invocation, not
  what the caller executed.

- /proc/self/exe names the interpreter. Relocatable programs commonly
  locate themselves through it and find the dynamic linker instead.

- A binary passed to execveat() as an inaccessible O_CLOEXEC fd
  cannot run at all as the interpreter has no path to open it by.

- gdb cross-validates AT_ENTRY/AT_PHDR against the exe file and
  discards the load displacement on mismatch leaving PIE symbols
  unrelocated.

This series adds two dispatch modes that close the gap from opposite
ends:

(1) transparent dispatch

   Registered with the 'T' flag or chosen per exec with
   BPF_BINPRM_TRANSPARENT. The binary travels through AT_EXECFD, the
   argument vector stays exactly as the caller built it, and the kernel
   labels mm->exe_file and comm with the binary. A new aux vector bit,
   AT_FLAGS_TRANSPARENT_INTERP, is raised indicating that nothing
   was spliced, argv belongs to the program, and to load it from the
   descriptor.

   The interpreter keeps control of mapping the binary, so the mode
   covers foreign architectures and non-ELF payloads.

   The exe label is not a new privilege. It names precisely the file the
   caller passed to execve(), not a file of the process's choosing. That
   file is permission-checked, write-denied while the process runs and
   recorded by audit. Credential derivation does not change exactly as
   today.

(2) The second is loader substitution. The kernel executes the matched
    binary natively as the main image and substitutes the registered
    interpreter for the loader named in the binary's PT_INTERP.
    binfmt_misc stops meaning becomes a PT_INTERP override. There is no
    contract and no identity to reconstruct, so a stock dynamic loader
    works unchanged. So 'L' is for native-arch ELF with PT_INTERP. The
    modes compose. A bpf handler reads the ELF header from bprm->buf and
    grades per binary, picking 'L' where it applies and 'T' or classic
    dispatch for the rest.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (21):
      exec: do not act on a stale execfd request without an executable
      docs, binfmt_misc: keep general usage out of the handler sections
      binfmt_misc: table-drive the register string flags
      binfmt_misc: normalize the per-exec invocation flags
      binfmt_misc: split out entry_open_interpreter()
      binfmt_misc: split out build_interp_argv()
      exec: release the replaced file with do_close_execat()
      exec: add AT_FLAGS_TRANSPARENT_INTERP
      exec: label mm->exe_file with the binary for a transparent dispatch
      binfmt_misc: add transparent interpreter dispatch
      binfmt_misc: add a static transparent flag 'T'
      binfmt_misc: let a bpf handler run the interpreter transparently
      selftests/exec: convert the binfmt_misc bpf test to the kselftest harness
      selftests/exec: test the transparent binfmt_misc mode
      binfmt_misc: document the transparent identity contract
      exec: carry a PT_INTERP substitute in struct linux_binprm
      binfmt_elf: consume a stashed PT_INTERP substitute
      binfmt_misc: add the 'L' loader substitution flag
      binfmt_misc: let a bpf handler request loader substitution
      selftests/exec: test binfmt_misc loader substitution
      binfmt_misc: document loader substitution

 Documentation/admin-guide/binfmt-misc.rst          | 159 +++++++--
 fs/binfmt_elf.c                                    |  20 +-
 fs/binfmt_elf_fdpic.c                              |   5 +-
 fs/binfmt_misc.c                                   | 311 ++++++++++++------
 fs/binfmt_misc_bpf.c                               |  18 +-
 fs/exec.c                                          |  54 ++-
 include/linux/binfmt_misc.h                        |   8 +
 include/linux/binfmts.h                            |   9 +-
 include/uapi/linux/binfmts.h                       |   7 +
 tools/testing/selftests/exec/.gitignore            |   5 +
 tools/testing/selftests/exec/Makefile              |  30 +-
 .../testing/selftests/exec/binfmt_loader_payload.c | 196 +++++++++++
 tools/testing/selftests/exec/binfmt_misc_bpf.c     | 362 +++++++++++---------
 tools/testing/selftests/exec/binfmt_misc_common.h  | 146 +++++++++
 tools/testing/selftests/exec/binfmt_misc_loader.c  | 363 +++++++++++++++++++++
 .../selftests/exec/binfmt_misc_transparent.c       | 108 ++++++
 .../selftests/exec/binfmt_transparent_interp.c     | 130 ++++++++
 tools/testing/selftests/exec/loader.bpf.c          |  56 ++++
 tools/testing/selftests/exec/transparent.bpf.c     |  57 ++++
 19 files changed, 1748 insertions(+), 296 deletions(-)
---
base-commit: 34296289b1a63a5394271b4e35918d3c9ad530dc
change-id: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8


