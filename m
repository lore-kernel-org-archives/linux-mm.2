Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0616C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64F76B008C; Tue, 21 Jul 2026 10:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C3B6B0092; Tue, 21 Jul 2026 10:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954536B0093; Tue, 21 Jul 2026 10:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BACC6B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:14:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEA5316018D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:30 +0000 (UTC)
X-FDA: 85012979100.29.8344C1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0F52E1A000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:14:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVxseVZt;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tqbxt3y278iXN6ohccdVVcDmD1G+Sg1keCQvLR/Ac7Y=;
	b=BRU/sSzkzL8ExPGDsFgLP3znQ29GqnFwJPXQ2JEqL01pmwWq2wfj7RjYSS1GtvhFqxqvZy
	vDEm4zx125yKhjsckwHqgUVAYp5RcaR4mxVKvXH0tLk05jcQy8pkk/DJOZOfb32Y5YAItu
	vjWAalvIbuO89n5BcTycF11XmU4XSts=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HVxseVZt;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643269;
	b=uN4/Huhsny9O+lepAUEiIVPw7KAcFKUgszRj8+J+INLNoTZCQhv9co2GVJkyjgyNQEHAH/
	uPBa71sGnUqIqu5pWBk6eJtblihNjKWbTf0belS/8ZGZ7JWt63b57LV07WbKk2DpGmDeYr
	lseK6xqiK84PBaZlYimdLfhYryxI1o0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF8D8400A9;
	Tue, 21 Jul 2026 14:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F01C1F00A3A;
	Tue, 21 Jul 2026 14:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784643267;
	bh=tqbxt3y278iXN6ohccdVVcDmD1G+Sg1keCQvLR/Ac7Y=;
	h=From:Subject:Date:To:Cc;
	b=HVxseVZtpHJNvvLXnLl1GQ1lEMzzXBHTOOy5tjPGmFa6SBNTKBgdHkPRxEQka/3YG
	 R1IX5BGQ9X87JcEjEwViXps8HVUykF5nWwVA9XN+lvr6X1EdubiForupJwvENJun5r
	 auS7f10xxc6PY4sK6liwLXqUJhxx+4I3Key3OfBSkK7aO8CXnbThLDs9e9tMXxeQwc
	 GO0yKsj8guKveR9mVJzzqn0W7yFrOjrXrO/0JbZSL4L4hJajRSPHvOwOvsol6TRyTl
	 MMONtQcHg+yFjKOeRVl3lY2a3IDj8q2Ln4mXrIe5jeYdlniRQWn6G1G5n0QFdW0Rp9
	 T+6P4y8LLyqSA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH v2 00/21] binfmt_misc: transparent interpreters and
 PT_INTERP loader substitution
Date: Tue, 21 Jul 2026 16:13:42 +0200
Message-Id: <20260721-work-bpf-binfmt_misc-ptinterp-v2-0-e57866e4ae0f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJd+X2oC/4WOyw6CMBBFf4V07ZCCkYcr/8MY05YpjEgh04oaw
 79L1b3Lc3Nzcl7CIxN6sU9egnEmT6NbId8kwnTKtQjUrCxymReyzGq4j9yDnixocnYI54G8gSm
 QC8gTYIFY19YWWlVidUyMlh4f//H0ZX/TFzQhSuNDK4+gWTnTxWm2Hsp0m37t8dCRDyM/P4VzF
 kW/mFz+iZkzkNA0uixMrXaywkOP7PCajtyK07Isb4Caa4D+AAAA
X-Change-ID: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8
To: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 linux-fsdevel@vger.kernel.org
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6322; i=brauner@kernel.org;
 h=from:subject:message-id; bh=E1xjytujcSid3WpFAgBvYYkChqfWuL8uWCM2ZU8eHpI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTF1+3XWfU7e9nvsLur45sZI1R9uv/+W978LUw892vtf
 rvJ66y0OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayXYSR4eS9Mx2Si/5LX2rd
 wrZi1vtdm66Ip73yvN0z4Vzjnyqv628Y/kp5vq7ryZMu3OYvL+ean3DsrJkbr4DRvoB/JU5pUgu
 MWAE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0F52E1A000E
X-Stat-Signature: 9b8poyna437b9xsejpxdoopn8ugg6581
X-HE-Tag: 1784643268-534782
X-HE-Meta: U2FsdGVkX1/SnJybc24aUsgsAIA/w1e7bj44UAUipa5KvI59edwUv55Lgyu5Ex8Bcl8UNSCgW1zcv4WREqvAhbtX0o5jssDfHdD4m2W3bxT9O9l1OfyrTjPsFs+MVDMGKHUfoFCQwlFuPK1AP56xYWTo97cRZ3/w97MGOBizdGGVPMt9l+RaLTOiK5C6lBdRVKEXmAiv4oLLV6Ll9OZiT6L5ZW7HxUFFuPNP9+e5S/fqmJZJ5zRaKjmJWWG/Tqx+ZleTh0UlGT1a7yM3yr8ddFJO7ne+ZSC+Vqh/rwUeeXyaD1A5BEWPElEmA/a3XpFKQXhNwGhz4+6SnrhRq3k7jWWDJZEtSYNVq4pnL+yobBNwoUQAu8NcLHOPp2wApqizqIm2/Y2LMpvNXW0fnIP1X49/eeVxe6rUV3m6fIhJwCrhbmQ+z0At1kr+8g1izQsx10VI+6hDwq/UREoPYf8buBszqDmElLBEUOf03GftQ5A4Lm7iUTzMHZdUQQEuhXcn3tW279sUkRJDk+GW/0G53CJ9VGBWot+/a2vnPg6WZ9Dap/4P4ukjRF7LsI672jl2i/Y0oq9yhKQ4kPFfDQtKVJW22ng3RKzcPFvpU9YA7JOhh4QcUgjxYFogl+f2u6Y+bvgiHLThbJXExo0XT6qM8nBK/14f5keWVbajSJXGclI7ISVI0VODWugm0lpmuvZeuTkJqkWf8rq+kv/+Vd04Ruh6nM9XHQ/1DlwpckU3UnRdIKntRDRZu0ZfQQlHeUpJScnD937Q+a7nZZppg+m6lwdlCVQALQ/SvtWNrr1Wud2tW77HLOD+y3i+x46maXJRJsIHTk8IQMVqEzAbS9eNLUDvnpOIhqC6TzLrBnFUXUwFl41kjzmOKzbX+Oyk+sC7Y4ljVf2/yy17NA2G3lf/YmLgmeQT7NVJHOLkwPjzIXJxG3zFIDqzOhO2d0f0RbP2LxEqNH9ePB4Q8q3Slvz
 nJhdyg5u
 X//nCvpR+wwO7HE8+5bpmrpzoYrxxdBxutD1v7a30kXTXF43GTkZg23lus/GjPuBF6wxkFpKdUD+R4kiTTUosc8bgTVgklw9JCJypZiENsujGpM1ARKKf8BjV4B1FCV4c00TnKosoAsVSH2nnyEoMFTeLzLubpdg1tnIf8AusKPLQuZ0ErxSfnqQsmIr9ulE08i9njh2/+QYC65FwLm4IfamToxtbA1skcwchYP4n7osEsaAmAs+2qbOqO22VMARPqNggVkPKucNKO9RDS13dYU3hXioATDFXEjcf7P9Syc28UwjnsLREeKyhDVkO5st7tZMqP6xoHk3qWgbCB7GBMB7Z9653vGHnl7x5C0VULL/MBiJafFnFy0FFYOOPubRuNWmR/25bN6JGEK69iFMxPc+N8az+32a+Jq/eJg3WnLcdJUwnCMYvdKvtRgrdQN5x92mWDfLialw8XaG/c6htcGg4crSoLCElQbyf
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
    BPF_BINPRM_TRANSPARENT. The binary is sent to the interpreter through
    AT_EXECFD, the argument vector stays exactly as the caller built it,
    and the kernel labels mm->exe_file and comm with the binary. A new
    AT_FLAGS_TRANSPARENT_INTERP aux vector bit is raised indicating that
    nothing was spliced, argv belongs to the program, and to load it from
    the descriptor.

    The interpreter keeps control of mapping the binary, so the mode
    covers foreign architectures and non-ELF payloads.

    The exe label is not a new privilege. It names precisely the file the
    caller passed to execve(), not a file of the process's choosing. That
    file is permission-checked, write-denied while the process runs and
    recorded by audit. Credential derivation does not change exactly as
    today.

(2) loader substitution

    The kernel executes the matched binary natively as the main image
    and substitutes the registered interpreter for the binary's
    PT_INTERP. binfmt_misc functions as a PT_INTERP override. There is
    no contract and no identity to reconstruct. So a stock dynamic
    loader works unchanged. Hence, 'L' is for native-arch ELF with
    PT_INTERP.

The two modes compose. A bpf handler reads the ELF header from bprm->buf
and grades per binary, picking 'L' where it applies and 'T' or classic
dispatch for the rest. If userspace control over relocation is wanted
'T' is the way to go.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- Move "exec: do not act on a stale execfd request without an
  executable" into vfs.fixes.
  Link: https://patch.msgid.link/20260720-beglichen-kognitiv-organismus-5e1e55326c56@brauner
- support 'L' for binfmt_elf_fdpic
- Share the substitution between the two ELF loaders instead of
  open-coding it twice.
- Reject a relative interpreter path when registering an 'L' or 'C'
  entry without 'F'.
- Map -ENOEXEC from the loader-substitution interpreter open to -EACCES.
- Keep the write denial on bprm->executable unconditionally until
  begin_new_exec() hands the file over.
- Reject a staged interpreter argument for a transparent dispatch
  instead of silently discarding it.
- WARN_ON_ONCE() a loader staged by an earlier format in
  load_misc_binary().
- Fix various selftests issues.
- Link to v1: https://patch.msgid.link/20260720-work-bpf-binfmt_misc-ptinterp-v1-0-ddb76c9a508e@kernel.org

---
Christian Brauner (21):
      binfmt_misc: require an absolute interpreter path with 'C'
      docs, binfmt_misc: keep general usage out of the handler sections
      binfmt_misc: table-drive the register string flags
      binfmt_misc: normalize the per-exec invocation flags
      binfmt_misc: split out entry_open_interpreter() and build_interp_argv()
      exec: release the replaced file with do_close_execat()
      selftests/exec: convert the binfmt_misc bpf test to the kselftest harness
      exec: add AT_FLAGS_TRANSPARENT_INTERP
      exec: label mm->exe_file with the binary for a transparent dispatch
      binfmt_misc: add transparent interpreter dispatch
      binfmt_misc: add a static transparent flag 'T'
      binfmt_misc: let a bpf handler run the interpreter transparently
      selftests/exec: test the transparent binfmt_misc mode
      binfmt_misc: document the transparent identity contract
      exec: carry a PT_INTERP substitute in struct linux_binprm
      binfmt_elf: consume a stashed PT_INTERP substitute
      binfmt_elf_fdpic: consume a stashed PT_INTERP substitute
      binfmt_misc: add the 'L' loader substitution flag
      binfmt_misc: let a bpf handler request loader substitution
      selftests/exec: test binfmt_misc loader substitution
      binfmt_misc: document loader substitution

 Documentation/admin-guide/binfmt-misc.rst          | 177 ++++++++--
 fs/binfmt_elf.c                                    |  10 +-
 fs/binfmt_elf_fdpic.c                              |  11 +-
 fs/binfmt_misc.c                                   | 314 +++++++++++------
 fs/binfmt_misc_bpf.c                               |  22 +-
 fs/exec.c                                          |  84 ++++-
 include/linux/binfmt_misc.h                        |   8 +
 include/linux/binfmts.h                            |  25 ++
 include/uapi/linux/binfmts.h                       |   7 +
 tools/testing/selftests/exec/.gitignore            |   5 +
 tools/testing/selftests/exec/Makefile              |  27 +-
 .../testing/selftests/exec/binfmt_loader_payload.c | 167 ++++++++++
 tools/testing/selftests/exec/binfmt_misc_bpf.c     | 342 ++++++++++---------
 tools/testing/selftests/exec/binfmt_misc_common.h  | 205 ++++++++++++
 tools/testing/selftests/exec/binfmt_misc_loader.c  | 371 +++++++++++++++++++++
 .../selftests/exec/binfmt_misc_transparent.c       | 108 ++++++
 .../selftests/exec/binfmt_transparent_interp.c     | 130 ++++++++
 tools/testing/selftests/exec/loader.bpf.c          |  56 ++++
 tools/testing/selftests/exec/transparent.bpf.c     |  57 ++++
 19 files changed, 1823 insertions(+), 303 deletions(-)
---
base-commit: 6cea93ff6fe97df34b63fe94487473e16c73b74b
change-id: 20260719-work-bpf-binfmt_misc-ptinterp-e6ee99ff6ba8


