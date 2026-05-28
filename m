Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36115CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08206B008A; Thu, 28 May 2026 05:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4B46B008C; Thu, 28 May 2026 05:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FC16B0093; Thu, 28 May 2026 05:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD2E76B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 581EDC282A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:15 +0000 (UTC)
X-FDA: 84816365550.11.901C450
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7287B1A0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=DfSYQ56A;
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779961993; a=rsa-sha256;
	cv=pass;
	b=aXGzUUda3K2l5GsO2zFf+jyn7scF/gQGwD86ybVw1uoBsgFKe3GV7ahgFnUiN85a54Gye/
	mGQsgyTwM8gCu9FShVkDbFtjvwGZxVxaZrag7hDwNP7Z7Frnv0hbebM+bmPeZgICKg5oSi
	C+OivFXThNA+zpt5gy7tHcywC7WLfGg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=DfSYQ56A;
	spf=pass (imf19.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zYZjJmq/v2k7XZXptq1VTDQbNRTjIht89217mgdV0uw=;
	b=f8Te2s0LuY73WORJtEbwpdKapV00lJcb18HI5Y7N2eegkZE0cJ3FHUHNDAQZRPOhmKFauC
	X9uqLHFQgvwp5RWrEXL1j7w7wtxqQPPjybnEsnKE27Bnc16ooj4GQeDkcTB7U5g9Xep0TU
	iB9gLNYK8LJwBenXs1yDZKPBaD6c6ZA=
ARC-Seal: i=1; a=rsa-sha256; t=1779961977; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=NAkz0SOOQjM2W1IWbe8FHDI2ymZWX/CCi43appKxaUbubD1pgY0UI6O7diyjpjdaW9Q6uV7e/8bG/pmIKNFthuFvABkpmc44s4IfoyEjFLDVsVe/2NPRFxS3qor1wN8SpBIZvq5KFIPVM2PxDHP0N9hXSUTCHWsEmAkNleE4dK0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779961977; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zYZjJmq/v2k7XZXptq1VTDQbNRTjIht89217mgdV0uw=; 
	b=OA2Q3PQfADtBhDNrKr2INK2o4NyExUuPqlkKxUakcRmRfXWb3nY6cBdIZJP+DAF/vyPs9UAkcI8ZbZw5sdFp12KODA9VzSn4kUIvSGEnUt+CLBQyWPB6tE8tdV2VN27Iz9/lP9/1cdacue7PqyWSFB+7WIOFcuI0Kf5ZK8ywXBA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779961977;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=zYZjJmq/v2k7XZXptq1VTDQbNRTjIht89217mgdV0uw=;
	b=DfSYQ56AiaiAMjT0uY8uKVXcmFmmXwWBaeU6a1/PqiqdDvUb2knMtnHjB4xYjOOe
	Rpibfj90vJyzR5JTJdsKSAlYWMcd/Igextbkf2fLlHWQDJAVwBvpEsRppc6c9mezwtX
	reqwjIhX2t06gNoIeGcHljkyHUWQ15EOOMoFWIG4=
Received: by mx.zohomail.com with SMTPS id 17799619745921012.7078084271373;
	Thu, 28 May 2026 02:52:54 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [RFC PATCH v1 00/13] exec: add spawn templates for repeated executable startup
Date: Thu, 28 May 2026 17:52:21 +0800
Message-ID: <20260528095235.2491226-1-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 7287B1A0003
X-Rspamd-Server: rspam03
X-Stat-Signature: adgpwk5zh1yhzynf168hdnzxf76sh9nk
X-HE-Tag: 1779961993-289003
X-HE-Meta: U2FsdGVkX1/nsu6dubWOBif1T1W6O0NXWVZbVBNxctDxIU8yS68m9mBEF+roDeE/pNiiTms3I1z3c+TkV4N6wopIZdDv+5TEiQ+2KDcYep8A/XvjEk2nbz8UFIzTjoEQkUE7kxwPuAwRb1aEmnzirhQPcUS3XpuYiLnDfuv4A0Z7nGiUWvnd8wELz/HyiGjq9vLvP734bd+zlOyrs0X9rG8X0vrD+wCw8nwJ4g4VyDaZiXw8U2Y7b+OJyoAD/0/mXyKcYS/ZeA+sz+Qn0jpWcMUheJcnD5wZvZfOy8dKIHkGlKaHM4YSlG6xtHmI3ihbncu1qiy5fbLbOUOLBPgPWV3w2prsO+hFU6iaxkTAI+pmM8M5mg8CdmkV+Dfl3zPTY0+VcwSAWyOdLASufw+nbB0eVjW3of8FgrkA5cHSiXkODoeSqFf0CgbNScuelYFGpZKUqO5ML3FywJBq6P2EjuV1NYEFJcDpr92sYynbuw2Of7RBYSNSgTTZMZjpoNnD+D3EEM6zelaK0CQfsyW5HjRcgu4354srvOn/z8OT1ltOoOEum3yPYwpQJCGFgHSQSdlJXpt3qoJwKpgpLXniPpGB2MAK5lcnBR5KMjfs1p4FocvAydWp1JBlYCSBUbbB1YB98VtTbZRqEFFaCVwGyHfDPuXEH9t0mq5ZTwJq9m7pccFYjhzdZCWjaMSy2syOryZseFyr4ARX4Fyk4gIbwmbjTwEZaDXO27hwQcXvqQAiZnZgAh3I34lNhDy9ynTrcDCHPugIlwRxJTczOAHicJUOgY7EUhaiG1iaFLj6uvXrten09w3R3PUEv2q0fMLIeiNkZ6QJ42D3Hq6qCBxxuu9Zp+BKJgOaw9qc2tnaAalfeFNCRILv49F9E2E+7WKFKu7ICFM0naITbQNcrp6OU2dV+vHoi7xixvzvpK6Y0zRJdA0u+EmCVrj4ANBOqLCmIxfEBxCHmD9VXk2EUbk
 OSaf1IvA
 0WPBk8d7vOva4RWhUQEpswq5hVoAR2J9z2+h5T+MbFpqBoq6FsrrpcAzzids62WOTw06ChfaikxQe8OTurSA7p4KO4OZ2NT+cjsZ8pAe6F88N8n1YPXMJOU7C90T2tQI1RvrgRxTkKeYsadE/W8e6de7o+jXURaV2xEPevcRuysJ1Kq47COgCb4+scq6LAuIyMPckTUv/1WRvezDok2j2yrKa0kC/H02ugrF+rTfK5LzAxuQ8bcmLYxtodTxjLqQFG64aejORPmJ+JCmjhcZhqktwCXUrVjc1+OBkEphlMlMSQKuIJlCMDCyX6Ue5BlBmVo3KV/xpyoyGby6AEK4XyA48E0VycS8mu3YizL+SvfjVydSl26WJ3NDH6qd7pN2YHb2lLtAKqve4n0T28svrTSq3ZAWwZorP7qyjzyb90lpO65DBZKRQLtlqYT8SeLDZ/eNLqoA0QfLIEOvHQjM185YAIFzKauvmfGlPiS8k4hvbMjs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is an early RFC for an idea that is probably still rough in both the
UAPI and implementation details. Sorry for the rough edges; I am sending
it now to check whether this direction is worth pursuing and to get
feedback on the kernel/userspace boundary.

The series is based on linux-next version 20260518.

This RFC adds spawn_template, a userspace-controlled exec acceleration
mechanism for runtimes that repeatedly start the same executable with
different argv, envp, and per-spawn file descriptor setup.

The main target is agent runtimes. Modern coding agents repeatedly start
short-lived helper tools such as rg, git, sed, awk, python, node, and
shell wrappers while they inspect and edit a workspace. Those runtimes
already know which tools are hot, and they are also the right place to
decide policy. The kernel does not choose names such as rg, git, or sed.
Userspace opts in by creating a template fd for one executable, then uses
that fd for later spawns. Launchers, shells, and build systems have a
similar repeated-startup shape and could use the same primitive, but the
agent runtime case is the main motivation for this RFC.

The mechanism applies to the executable that userspace asks the kernel to
start. If an agent runtime directly starts /usr/bin/rg, the rg executable
is the template target. If the runtime starts /usr/bin/bash -c "rg ... |
head", the shell is the template target unless the shell itself opts in
when it starts rg and head. The kernel does not parse the shell command
string or rewrite inner commands into template spawns. Userspace has to
call spawn_template for those inner commands explicitly:

    direct exec                 shell wrapper
    -----------                 -------------
    agent                       agent
      template("/usr/bin/rg")     template("/usr/bin/bash")
      spawn rg argv              spawn bash -c "rg ... | head"

    kernel target: rg          kernel target: bash
    rg startup benefits        rg/head need shell opt-in

Several agent runtime discussions are moving toward direct argv-style
exec tools for both security and policy clarity. For example, opencode
issue #2206 proposes an exec tool as a safer alternative to a shell-only
bash tool:

https://github.com/anomalyco/opencode/issues/2206

spawn_template is meant to support both models. Direct exec users can
cache the actual hot tool. Shell-wrapper users can cache the shell and
still reduce shell startup cost. If a shell or an agent runtime later
uses the same API for commands started inside a shell command, those
inner tools can benefit too.

Each spawn still goes through the normal exec path. The template reuses
only metadata that can be revalidated before use. Credential preparation,
permission checks, binary handler checks, secure-exec handling, and LSM
hooks remain on the normal execve path.

The UAPI has two operations. spawn_template_create() creates an
anonymous-inode template fd from either an executable fd or an absolute
executable path. spawn_template_spawn() starts one child from that
template, applies per-spawn fd, cwd, and signal actions, and returns both
pid and pidfd.

fd inheritance is deliberately conservative. By default, after the
requested per-spawn actions have run, the child closes fds above stderr.
An agent runtime can still request traditional inheritance explicitly,
but helper tools do not inherit unrelated secret files or sockets by
accident. The create-time actions fields are reserved and rejected in
this RFC because fd numbers are per-process state, not stable reusable
objects. The caller supplies fd actions for each spawn instead.

A typical agent runtime would keep one template per hot executable and
still build argv, envp, cwd, and pipe wiring for each tool call:

    rg_tmpl = spawn_template_create("/usr/bin/rg");

    for each search request:
        out_r, out_w = pipe_cloexec();
        err_r, err_w = pipe_cloexec();
        actions = [
            FCHDIR(worktree_fd),
            DUP2(out_w, STDOUT_FILENO),
            DUP2(err_w, STDERR_FILENO),
        ];
        child = spawn_template_spawn(rg_tmpl, rg_argv, envp, actions);
        close(out_w);
        close(err_w);
        read out_r and err_r;
        waitid(P_PIDFD, child.pidfd, ...);

A shell-wrapper runtime would use the same shape with a template for
/usr/bin/bash and argv such as ["/usr/bin/bash", "-c", command]. That
reduces shell startup cost, but it does not cache rg or head inside that
command unless the shell also opts into spawn_template for commands it
starts internally.

The template pins the executable and denies writes to that file while the
template fd is alive, so cached executable metadata cannot race with a
writer changing the same inode. This means direct in-place writes to the
executable can fail while a runtime keeps a template open. It does not
block the common package-manager update pattern where a new inode is
written and then atomically renamed over the old path. In that case the
old path-created template becomes stale, spawn_template_spawn() rejects
it with ESTALE, and the runtime should close and recreate the template
for the new executable.

    in-place write              package-manager update
    --------------              ----------------------
    template pins old inode     write new inode
    write(old inode) denied     rename(new, "/usr/bin/rg")

    cached metadata safe        old template sees path mismatch
                                spawn_template_spawn() = -ESTALE
                                recreate template for new inode

Each spawn revalidates executable identity before cached metadata is
used. Path-created templates only accept absolute paths: a relative path
such as ./tool depends on cwd, and the same string can name a different
file after chdir. For an absolute path template, each spawn reopens the
path and checks that it still resolves to the executable recorded when
the template was created. If the path now names a replaced file, the
template is stale and userspace should close and recreate it.

A template fd can be passed over SCM_RIGHTS like any other fd, but this
RFC does not treat that as delegation. spawn_template_spawn() only works
while the caller still has the same struct cred object that created the
template. If another task, or the same task after a credential change,
receives the fd, spawn fails instead of running the executable using the
creator's launch authority:

    ordinary fd                         spawn_template fd
    -----------                         -----------------
    A: open log                         A: create rg template
    A -> B: SCM_RIGHTS(fd)              A -> B: SCM_RIGHTS(tfd)

    B: read(fd) = ok                    B: spawn(tfd) = -EACCES
                                        B: create own rg template
                                        B: spawn(own_tfd) = ok

    open-file use is delegated          spawn authority is not delegated

The cached state is intentionally small. The template fd keeps the opened
main executable file, an optional absolute path string, the creator
credential pointer, and the deny-write state. The executable identity key
records device, inode, size, mode, owner, ctime, and mtime, and is
rechecked before cached metadata is used. The ELF cache keeps only the
main executable's ELF header, program header table, and program header
count.

    cached in this RFC          not cached in this RFC
    ------------------          ----------------------
    opened main executable      PT_INTERP metadata
    executable identity key     shared-library graph
    main ELF header             VMA layout metadata
    main ELF program headers    cross-process metadata sharing
    creator cred pointer
    deny-write state

This RFC does not cache ELF interpreter metadata, shared-library
dependency state, or derived mapping-layout state. Shared-library
resolution is dynamic linker policy and depends on LD_LIBRARY_PATH,
RPATH, RUNPATH, /etc/ld.so.cache, mount namespaces, and secure-exec
state. It also does not share cached executable metadata between template
fds created by different processes. Each template owns its small cached
metadata object in this RFC.

Performance
===========

The numbers below come from my separate local autogen-bench project.
autogen-bench uses AutoGen [1] Core as the agent harness: RoutedAgent
instances run under SingleThreadedAgentRuntime, and RPC-style dispatch
fans out concurrent tool-call requests to worker agents. The workload
definitions, generated test files, and subprocess/spawn_template backends
are local to autogen-bench.

The agent-tools preset includes direct tool calls and shell-wrapper forms
for:

rg, grep, sed, awk, cat, head, tail, find, stat, ls, git-status, git-diff,
python-small, node-small, sh-c, and bash-c.

The benchmark is launch-heavy but not no-op: it searches generated
Python-like source files, reads sample files, runs small Python and
Node.js programs, and runs git status and git diff in a small repository.
It does not include model inference or long-running tool work, so the
numbers mainly describe the short-tool regime.

The subprocess column starts each tool call through the existing
userspace launch path. The spawn_template column creates templates for
hot executables and uses spawn_template_spawn() for later calls.

Total in-flight tool calls stay at 16; only the worker-process split
changes. For example, 4x4 means 4 worker processes with 4 in-flight tool
calls each. The two time_s values are subprocess/spawn_template wall
times.

Workload     Calls  subprocess  spawn_template  time_s       Delta
(workers)    calls  calls/s     calls/s         seconds
1x16         6144      411.04          420.32   14.95/14.62  +2.26%
2x8          6144      666.78          690.08    9.21/8.90   +3.49%
4x4          6144      955.61         1003.25    6.43/6.12   +4.99%
8x2          6144     1048.25         1069.18    5.86/5.75   +2.00%

The table measures the whole mixed workload, including both process
startup and the short tool work done after exec. Since this workload is
launch-heavy, the possible launch-side savings include:

- the template fd keeps an opened executable, avoiding repeated ordinary
  open/path setup for that executable;
- the kernel can reuse cached main-executable ELF header and program
  header metadata after revalidation;
- the fork-and-exec-style launch is submitted as one
  spawn_template_spawn() operation;
- fd, cwd, and signal actions run in the child kernel path instead of
  being driven one syscall at a time by userspace child glue;
- pid and pidfd are returned by the same operation, reducing some
  runtime-side bookkeeping.

In local experiments before this RFC, I also tried caching ELF
interpreter metadata and derived ELF mapping-layout metadata. A focused
repeated-exec benchmark did not show a stable standalone throughput gain
for those two optimizations, so this RFC leaves them out and keeps only
the main executable metadata cache.

I also tried sharing main-executable ELF metadata across template fds
created by different processes for the same executable identity. That can
reduce duplicated metadata memory when many agent worker processes create
their own templates for /usr/bin/rg, /usr/bin/git, and similar tools, but
it did not show a stable throughput win in local multi-agent tests. It
also adds cache keying, lifetime, invalidation, credential, and namespace
questions to the RFC. This version therefore keeps per-template metadata
ownership and leaves cross-process sharing out.

Sorry again for the rough edges in this RFC. I would appreciate feedback
on whether this direction is useful and what the right API boundary
should be.

Thanks,
Li

[1]: https://github.com/microsoft/autogen

Li Chen (13):
  exec: factor argument setup out of do_execveat_common()
  exec: add an internal helper for opened executables
  file: expose helpers for in-kernel fd actions
  exec: add spawn template UAPI definitions
  exec: add spawn template file descriptors
  exec: add spawn_template_spawn()
  exec: validate spawn template executable identity
  binfmt_elf: cache ELF metadata for spawn templates
  Documentation: describe spawn templates
  exec: require absolute paths for path-created templates
  exec: let close-range actions target the max fd
  syscalls: add generic spawn template entries
  selftests/exec: cover spawn template basics

 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/spawn_template.rst          | 153 +++
 MAINTAINERS                                   |   6 +
 arch/x86/entry/syscalls/syscall_64.tbl        |   3 +-
 fs/Makefile                                   |   2 +-
 fs/binfmt_elf.c                               | 104 +-
 fs/exec.c                                     | 162 ++-
 fs/file.c                                     |  11 +-
 fs/spawn_template.c                           | 619 +++++++++++
 include/linux/binfmts.h                       |  10 +
 include/linux/fdtable.h                       |   2 +
 include/linux/spawn_template.h                |  72 ++
 include/linux/syscalls.h                      |   7 +
 include/uapi/asm-generic/unistd.h             |   7 +-
 include/uapi/linux/spawn_template.h           |  62 ++
 scripts/syscall.tbl                           |   2 +
 tools/testing/selftests/exec/Makefile         |   1 +
 tools/testing/selftests/exec/spawn_template.c | 997 ++++++++++++++++++
 18 files changed, 2179 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/userspace-api/spawn_template.rst
 create mode 100644 fs/spawn_template.c
 create mode 100644 include/linux/spawn_template.h
 create mode 100644 include/uapi/linux/spawn_template.h
 create mode 100644 tools/testing/selftests/exec/spawn_template.c

-- 
2.52.0

