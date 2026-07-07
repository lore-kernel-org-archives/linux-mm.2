Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A2FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E026B009D; Tue,  7 Jul 2026 15:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B561E6B009E; Tue,  7 Jul 2026 15:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A445E6B009F; Tue,  7 Jul 2026 15:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6900E6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:37:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF762168CCE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:09 +0000 (UTC)
X-FDA: 84962988978.03.6547D12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 475E012000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:37:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaMgFmqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783453028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gPg3vEkTcsR+KYYDQEQ2rLyjD9CYaZB6AwFxCwPiuy0=;
	b=usT5ss75UZsTXWOSNm9AWmQ1x2NSeO7EOzbXWQ3lVv4a+ahKUIUvF7XvgtzCQ+YyCpHt7b
	x3b5ddw4cXwq2++ReZm4PAEzQM8J6ywYoO4dDXH0QIPD4dba/pzlxWtshl0E2G2SpGW4FM
	205yAZe8o9mB2ueDzu9X5yA6atmsLuk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IaMgFmqU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783453028;
	b=x4/CluTqnioNjRvdxgbscOeLUNgPap9bMGQGf7gqQ1WZAcHKFzT2wWXxU8YSKWnmh36ygJ
	Cr20ycijupE7GgxqKkZqnGJsPrC15yBEYPV8cnOLYm+223T4JOIMAsmR/36VoLluUP4iN/
	+0gLwRMC3hwlwfSe/Psvlh/MhSXrze0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA36B601EC;
	Tue,  7 Jul 2026 19:37:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEFD1F000E9;
	Tue,  7 Jul 2026 19:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783453027;
	bh=gPg3vEkTcsR+KYYDQEQ2rLyjD9CYaZB6AwFxCwPiuy0=;
	h=From:Subject:Date:To:Cc;
	b=IaMgFmqU5pubSutB4iA1G7DbzzM5RtlUJsfqzS2sQXdzTzfjZMrYd20PogFsSLOBc
	 p8qBZ+n50ZcMzHX3QujgzaxCBEqACvFhoEQx972siupx1b4zBAKPcZSS7eOoocx3Hr
	 /+G2/b/La0Rvtfl/RonslsVnGXwyOFVTr3yKIPxGf7dTs3KVD3ABUtS/2uArK2ZK3F
	 3BB7ahSY0kTShyiXiJldj61HeTt2Md+01Tpf3MYJKpvqBS8TSMuyvC9wEZRm752n3E
	 DHkW2RP0vTvgN4PZ2iMGLLezxFtd5qM31XAk5iRuRjHmAbPGP+2k81K1ZMSoV14GCQ
	 SMFe37CVIsftQ==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC POC 0/4] binfmt_misc: bpf-backed binary type handlers
Date: Tue, 07 Jul 2026 21:36:44 +0200
Message-Id: <20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE1VTWoC/yWMTQuCQBCG/4rMuZFVq4WuQteia0TsbmNO4SozZ
 oH439M6Pu/HM4KSMCnskhGEBlZu4wzZKoFQu3gn5NvMkJt8a6yx+G7lib6r0HOsmv7asAYk4+2
 mWGe2KAjmaydU8eenPcNpXybHQwmXf6Ev/6DQL9Jl6p0SenEx1EvUOO1J0sGmOUrIYJq+9tK5e
 aMAAAA=
X-Change-ID: 20260707-work-bpf-binfmt_misc-e0b75341733e
To: Farid Zakaria <farid.m.zakaria@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, 
 Alexei Starovoitov <ast@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 jannh@google.com, linux-mm@kvack.org, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=6770; i=brauner@kernel.org;
 h=from:subject:message-id; bh=yKu5qj7eKjA1JXXIoGTmnPEVv3FdKvaF/LpZwd0PtMw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5hiZs5W7tKJ86Sab+qgaX08U2icTV382fiCZbKzimH
 WJnurGlo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCIm/Ax/BW0mZEgy+pvWLWA+
 OfXUJ9Hvy1e8kdP/eH9pwEY2n6AHCQz/0+f8uSTUkeh/9LbzblEJdvsU+6kv1HhvXhGzOKcc/N2
 ZHQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 475E012000A
X-Stat-Signature: mksftusdwzrc7pze3sdzggw6gezu3sbg
X-Rspam-User: 
X-HE-Tag: 1783453028-700378
X-HE-Meta: U2FsdGVkX18tH/sOWGFNOHyA1C8gyenbrtEoNw9HfvxLx9NxsEIzlP5l7vFAo1XsGwvlCzsYNW3BFMzlESmAIK5mbEkDjtFirVfoWhuyeY4O/9vjdZJ4smGBVctpOL5YZ6mH4gNnYWPB0Yk6J6deWQ1Up4UrKmWKLlcRqsCgHWoWckNWzt5tRFG8mLHOlSxDMYzW80LWOawdQZk4HCQnXMWSOoRmPC9PGVvRUBHW9XDZJUhGaSI1UW6YFTcrF+GfyhtpTEDkmYnQghVEtXWjMJBhPv6+MmfSJQosii2ySfrnP7d3NZHDYDH1EnG0PJ2w2vIKv4Ts9uoxJsuc1ibM8umNvRFlu3BrCpWkzT2RnjWQndrJ6RwMhaOi635wtsdI09CtYbvK+iQBgwa3z0LZaS93wJufuceqZxfUa9DOJhVBFc+RI2Hap7iBDqGVnDNK9hDlAEjcAUGCYFkq/HBEanRg6Mh1aVDoX73+ce4/5NTLvfO2kZcoiNdihbQFH4UwEZyfS1W0LRYNqRp5aKpUFM8yQgW8J6MabU2eE7pwD/FeoVLYH2UVJMuhNinobJ5GyyDWcG90l6bDKFYurg3MpIZcrmFq/y2xQo6QZasI5xMjgk7/aYw55sKPmapl97qHh/4PRLRwaq98cEq3GwVB0SBAqKI/uXVuB6ccMlSwagVflpH7rE7xU403ueWcQCN4yo+G704qkdSVVv51H5FMaHAQ/TpDkW4Dvsl5J0Bl1j34dVr4hn3Nj7e9tm/pIlkAn7uW1wh2/TjYJQxjBb7siNf3wzvIWtjOVo/1tBfcY4dIGee1Mei1fxu1VeD0ovDYCGq1+2TsON8Va+DayUXoKy/ClNP02KVfTL878VB5zH0z2rq5wqrqi7nxnxI5FbkuQpOPR6H4E5Ypf4xlX8Q4PHhM416VjcybYtbZkLrjy8Ku6M7qTmxfrLizmCdRH8wDAlXTUUYNm+QzsBiz+gk
 86XSxEEw
 11b/EdqUCyT6rCCFneFIHOjMja0Son/Nch0VhDlXaWkmX+Om9Peb3dMk/mpT6mjtqmgWlMP3jvbeCbp6Ukv+a6NVYLRLPX6Y5qjctGqB/ouIfwnCA+dgFHm94qsZrOnCEegS2kF0ai+ykFG+ruL44FeZPRUM6OTMqJmhF7vKuSH3C22R4ZCaEgloZKxsDJ17BWbYJWpLQ/ZJAcXeWlAYfg2ixN5lTo/F+uFMkYm3QV4i8yXAA91R6ErnfC696a0iw1EIKkxSC6hZ1sEPM7KvkgPuoOtHHQrjmXTMFtxTF7q48dhFIstyo+G/iKr8aXUKEBys4MThaol4te5/+VL5PZvVhUgvX8dY/6Fr3xQIe9xBuc7a2rrdSIm1n5oU5ar6SYgGgTrVQbptkliaXMmnfDlriLF9XaCd4JnPQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a POC for the nix people and Farid and Eric in particular. I
would take my hands off the wheel now that I POCed this and hand it to
Farid if he likes to take it forward.

VL;MR (very long, must read):

For a while now Farid has been trying to make relocatable, hermetic
binaries (think Nix-style store layouts) work without patchelf tricks
or wrapper scripts. For such binaries the right dynamic loader can only
be determined relative to the location of the binary itself, which
neither PT_INTERP nor a fixed binfmt_misc interpreter string can
express.

The first attempt was $ORIGIN expansion in PT_INTERP [1]. I pushed back
on that. Userspace guards $ORIGIN behind AT_SECURE so the kernel would
have to make the used loader depend on the type of binary, LSMs would
need a say, it changes long-standing behavior in ways that are ripe for
loader injection attacks, and bprm->file may not have a usable path at
all (memfds, deleted files, unresolvable paths). Making the kernel
splice bprm->file back together with PT_INTERP is terrible. The second
attempt was a pluggable ELF interpreter loader registry [2] which would
mean actual kernel modules for custom binary formats. Also no.
binfmt_misc was invented to kill exactly this horrendous past.

What I suggested instead [3] was to put this where delegating binary
formats to userspace already lives: binfmt_misc. The only things
binfmt_misc cannot do today are matching programmatically and computing
the interpreter per binary instead of using a fixed string recorded at
registration time. Farid prototyped that with an eBPF program [4] and
it turned out quite workable, but the prototype ran a SOCKET_FILTER
program over bprm->buf, added a new helper to the frozen uapi helper
list, and returned the computed path through per-CPU memory.

This series is the proposal turned into what I think the bpf side
{c,sh}ould actually look like. It is a POC: it builds, the design is
what I want to discuss, selftests and runtime testing are still missing.

A handler is an instance of the new binfmt_misc_ops struct_ops with a
single sleepable op and a name:

	struct binfmt_misc_ops {
		int (*load)(struct linux_binprm *bprm);
		char name[BINFMT_MISC_OPS_NAME_MAX];
	};

The load program receives the bprm as a trusted BTF pointer, so it can
match on the header in bprm->buf, read arbitrary file content through
bpf_dynptr_from_file() (e.g. to parse ELF program headers), and resolve
the binary's location via bpf_path_d_path() on &bprm->file->f_path. That
also solves the prototype's limitation of only seeing the first 256
bytes of the file.

The one genuinely new piece of bpf surface is a single kfunc:

	int bpf_binprm_set_interp(struct linux_binprm *bprm,
				  const char *path, size_t path__sz);

which stages an absolute path in the bprm. It cannot go through
bprm_change_interp() directly because load_misc_binary() copies
bprm->interp into argv[1] after the program ran, hence the staging field
added in patch 1.

Registering (attaching) the struct_ops map publishes the handler under
its name in a registry keyed by the registering task's user namespace.
Activation reuses the existing text interface with a new 'B' type where
the offset field carries the handler name and magic, mask, and
interpreter must be empty:

	echo ':origin:B:nix::::' > /proc/sys/fs/binfmt_misc/register

This keeps the existing permission and namespacing model completely
intact. Activating a handler requires the same write access to a
binfmt_misc instance as any other registration, a container mounting
its own instance escapes the host's entries exactly as before, and
shadowing e.g. all ELF binaries takes the same privilege as a static
'M' entry matching \x7fELF does today.

The only novelty is that matching becomes programmable. Handler lookup
walks the user namespace hierarchy upwards, mirroring how binfmt_misc
instances themselves are resolved, so a handler registered on the host
can be activated from a container's own instance without being forced
upon it.

The computed interpreter is opened with open_exec() under the caller's
credentials and goes through the full LSM vetting as the next binprm
level, exactly like a statically registered interpreter, so the program
cannot widen access. It only ever redirects the caller to something the
caller could exec anyway.

The 'C' and 'F' flags are rejected for 'B' entries. 'F' has no fixed
interpreter to pre-open and 'C' would let a program-chosen interpreter
run with a setuid binary's credentials. AT_EXECVE_CHECK never invokes
programs and interpreter chains stay capped by the usual ELOOP depth.

A handler for the Nix case then looks roughly like:

	SEC("struct_ops.s/load")
	int BPF_PROG(nix_load, struct linux_binprm *bprm)
	{
		char path[256];
		long n;

		if (bpf_strncmp(bprm->buf, 4, "\x7f" "ELF"))
			return 0;

		n = bpf_path_d_path(&bprm->file->f_path, path, sizeof(path));
		if (n < 0)
			return 0;

		/* derive the loader location from the binary's path */

		return bpf_binprm_set_interp(bprm, path, sizeof(path)) ?: 1;
	}

	SEC(".struct_ops.link")
	struct binfmt_misc_ops nix = {
		.load = (void *)nix_load,
		.name = "nix",
	};

Farid, this should slot underneath your qemu demo from [4] with the
program ported to struct_ops. Feel free to take it from here.

[1]: https://lore.kernel.org/20260622043934.179879-1-farid.m.zakaria@gmail.com
[2]: https://lore.kernel.org/20260702214247.1253741-1-farid.m.zakaria@gmail.com
[3]: https://lore.kernel.org/20260703-meditation-ratsuchende-moratorium-9ecdf1f3f8bb@brauner
[4]: https://lore.kernel.org/20260704211409.1978485-1-farid.m.zakaria@gmail.com

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (4):
      exec: stash a bpf-selected interpreter in struct linux_binprm
      binfmt_misc: add binfmt_misc_ops bpf struct_ops
      binfmt_misc: wire up bpf-backed 'B' entries
      bpf: allow fs kfuncs for binfmt_misc_ops programs

 Documentation/admin-guide/binfmt-misc.rst |  40 ++++-
 fs/Kconfig.binfmt                         |  14 ++
 fs/Makefile                               |   1 +
 fs/binfmt_misc.c                          | 143 ++++++++++++++--
 fs/binfmt_misc_bpf.c                      | 275 ++++++++++++++++++++++++++++++
 fs/bpf_fs_kfuncs.c                        |  23 ++-
 fs/exec.c                                 |   1 +
 include/linux/binfmt_misc.h               |  49 ++++++
 include/linux/binfmts.h                   |   1 +
 9 files changed, 529 insertions(+), 18 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260707-work-bpf-binfmt_misc-e0b75341733e


