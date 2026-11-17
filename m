Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A878E606A338
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gxf3CeZg
Received: by kanga.kvack.org (Postfix)
	id 7B3C96B05B0; Tue, 17 Nov 2026 18:14:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763716B05B2; Tue, 17 Nov 2026 18:14:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679186B05B3; Tue, 17 Nov 2026 18:14:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB3C6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CCE33A061E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:13 +0000 (UTC)
X-FDA: 85446166386.18.9765AFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 501822000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxf3CeZg;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957252;
	b=Mj6QZ3C+3C7Medr6fKPDE54uFo2vhTvHamIgr8lF1cl78uRMkheNqoIlnZ4fQn7trBDgFB
	k+HAkHNinIPO1ZN1b1onhn8/nUfyUK6DMXKZM8LX7o+3QxqStTypl6wOBYExh/Ed20t1cg
	YoyFjkcTebWDarLuPdtN9v/xT8e7/CQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yp6+Hwad/NBoam++rgWwhCOLZpBfJyHe1i278jtj9/A=;
	b=0Kc5KavRRIFeFbgoa3PlgJiOoaLpE+zx6UzuEJ2BA4ASgLIPJ/j9NZakcGf8nD8WJ995Wz
	ffWzX5x/V6PkpS/YeKybZ8tsyxUMVX5S6Zv3V8dgbyVEpK3Om4XYVGDjbPCODo/oHQUKJ5
	qBjTecr2z3eYDp7so43Ae/wc+qo9ruc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gxf3CeZg;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 08A64605C8;
	Tue, 17 Nov 2026 23:14:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 00C0C1F000C4;
	Tue, 17 Nov 2026 23:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957250;
	bh=yp6+Hwad/NBoam++rgWwhCOLZpBfJyHe1i278jtj9/A=;
	h=From:To:Cc:Subject:Date;
	b=gxf3CeZgQiYInmwTCsJEpC9Q9rV3XfEnkpMfqYKKQLHrsz2tF88DlZadPUvGDmLHY
	 JhDrjDv6JsOFbRcfejD3ARsnyggY8gv6rSAqj9Q/EE5lOo0/KtkapgPsJVCDvxTDjZ
	 Anec1m6erHqQ5vTQWyAgScKHqeo8H0BnCCaOL8NwC2wWLw+8F11lo4zoqyA0J3IaRc
	 eUB4bdzBxQwPCE0m7ywlRNS0Xaej4i0kGTBNg2IdenE0LzY51zebpn9mmrsrWLuBWF
	 paBGkkIYjNP9b5XMebOD4pW6qK1i/Q/FyCDqA7vser6WO1NxHFV+ecP7etOYBgybdw
	 4E2nhRf97F6Eg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 00/13] Namespace for namespace roots
Date: Wed, 18 Nov 2026 01:13:39 +0200
Message-ID: <20261117231352.3816603-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 501822000A
X-Rspam-User:
X-Stat-Signature: 44fpx7y1t5d3zzbotywpiojxkx4znews
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794957252-396068
X-HE-Meta: U2FsdGVkX182xLGy9QNtzCurAgGWlsLIt0aZ9lr6L9zAWwflbkIa7mo/SV7jQoLfiUtR9dV4BRbWDmWr6nxjMlM7gJwKVMbfHjXr13XFsmoHaq2o0jE0Owzrdjz/xBlzLm3y1rcIQhyToolc0HBRiS51gStlWChjnFrpcaRQ+c/wopjBwU4kDfTr+MQBuxKw+Rj05SUrFG991evQpwY5H82H8GQUkVNZTecYFjKpXNzXJ3vZHjvYWc2hKV/OrVtb30UId/Z2FiRB5VsWjz/PYUQLNatoVI2d+IhWcTmoLsR4NeNP2kjl1QUBXGfWtC2E9Jv/YuZWNGniwMKtnvD5PRIMnKGgfqy0byPV3guC2WCotlAaGnnx+kv2rHxtas2rR1YlfUi1sKdap2wMbT8DHAczeZhWA0sut/zCYkjaO3/xBpnffB5wMB++cDhIkX/WXTrnKMTxmhDDuzI1MfC4iCcNGLKS1uP3cSLM0uS05tkEOEvR4dzpZkU8XhCi1dqKXwZPfElVXYTQ4ViTc7aLF5wtnuXVo3iDvWuT8h/XAoSOoe3LLc3gkBqy3a5TVBjKBueygF8OX+RQf+qop0rSnoTAygtAiKWmmAzT2L6ik4HvL0bCdFgpnwcCPBdtVBR+4Zw9rrgif2O1mNBAtWeLzPhiCTDzb5dP9LZDAqJMtCJVIC1KJb4hDH8qh5i0UoyQu4ieItJ6uwaf7sTcbcVLhtKPPBZwtzNzvlIcoHSBeLCasXhINSh5wj1AsL/ahxgyL8byDiAqnLJskFs1T8k3iPg9BYiSMEkxTXoquY594tQEdMTzwzQr5/XYRu4KpYCVgu98zgIRLOvlEfMK+NeedZRom27hJpF0tCyDbjbdGMUxIjDk5AYCubxozerFWez1QLWkxkpX5clk5O3QLnQ3i3lJVV22OvrHzY0pCz4uUWPkNyEZEMRK+vO3ZNTF75elx71eyiQkqNV+iCb4BKv
 hjhuLmSm
 +uog8CGRgk2lU0uWpOjTrAh1cDXlU4WZLC2Zr212/TLhh96+pah5HMHljlOrBtNY/AO2gcQBinG68qaBBXSSJBhA+1/lwzCQI696dHvybWaseiqpm7G2jyMUE74dEOn+BuDDr9k5NMlEgaQdWtj2ZgDXpqgVlDZLXuV/u9780LMCwPsxastqRoxarnxjhWgiNl98eIyZuZvki7a2W7HjfhNQaVwfo+fjW6p6MrAFWSIrFx8K60Bp16oPLxwA3tqkSlKZToyU6qBPCKpnEExU8tPw8/SVG48GnKXutwZ50CqcpjwbTV2JnfoeDw6rNpX3uyj+cBlWYisSpbGmnGIlT48F/nepc5yD2HtpC9u987WdxtTh61as1klte8oIS3EuTQWcqjg8cLJO1vmfgP43hWWLGkdv4c8T5h3JKCTQG4r4UttSsFazIHcfppu8qsEj8kcMLp1isc+JdZL2XP6RpF3qo7G6C4PLrtVoNsWoNyF7kxsBktSNEhr5hbe8W4ZsxjW8mtpz/Nwb4vXApOj20ZHTOWrSx7uAjUW8bcvgmAFnua905ry0t1j5JSoQxRYqTQIwLBW2sMUbauRoKuSwOdb8g1QZLrClfaaX2jA9XEXGufHhD6exzzZ/i5cvDvEbdvBLQasl6ixV2XHC3rwbckLrvgaiYFmIwGxkn7v+a/ua79+ZXaHJBMI/f63SkMm517aFbhSrVHdxj0tq7xSuC7aewtND2zAtvaMMmJPK1HijAjssyKPERoiGj558YHdNs/+5PMPZghntV99bIZv2PHUTYV912ud7Lz1hi7Zay3B+6mEu/VlPKdvHoxerm2JI7vNlQrC3qFLLWuNRarqXEGjeEA/c5cyzYyY1nYmfowF//gBf6bGchQfX3VW2ZnB3RFLXstGOQUEOjDrPncvTSOXfFo87aLenpDkXQzF9OarvuM39gCGh7EncjqyxPAk/5BB1KK765GwhmjicA8AubBLKgEwGr
 12qQR84t
 d3m6J23cxx3rn7Cf5JZb0Pl0v/sAL8/ql9Mk1pzqbAmISSlXZqmr43J7SjzYRjaGM7G90jyd7iEd3B6LLr+3sRVCeaUGyM/+OmiUY26zpPktKgP0tkk3RLXkZBhWJXcnxWI3ZFrAJDZrcgz34kPa+H46nEuaI95ZBe9My2tvZLf3NjnRz6Ox5tgTT4oxFF2SwtqOcYMSi+8UHxwaGFeQ/eZoCxDEdlwXR2VKyxDisjQMTP6dly1ztUBhbLDeXLRRpKBFOs2/D65PyioRolXpo5svrOcbKeFReTpb0RiV0lh+Sdso5Vi61xVrw0XJbiuoyh3a8oE3wTPyzm/Cg55H+LIYCpYyZEOll9Z05BTKVHs8Qwkqo8UuC4rhEGKfCH3S7SLMV8f3hob+e5pg34pd1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

OVERVIEW
========

A root namespace (rootns) is a kernel object backed by a file descriptor
that binds together:

1. A full or partial set of detached namespaces.
2. A dedicated PID namespace for spawning processes into, signaling
   members, and polling or waiting on PID 1 exit.
3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) that must be
   populated before going live, without inheriting host mount-tree
   ancestors.

Work on this feature started in 2025 from David Howells' container object
patch set [1], which I turned into a namespace for namespace roots and
rebuilt around that premise.

While the patch set is manually written, the original motivation came
from isolating LLM agents. Running untrusted agent workloads made it
clear that OCI runtimes need to minimize their live configuration
surface.

Assembling mounts, credentials, and namespaces inside helper processes
with a half-configured container is what I see as the main challenge,
and the existential debate around namespaces and container objects is an
unfocused discussion topic.

[1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/

IMPLEMENTATION
==============

rootns_create() allocates a rootns instance backed by a pollable
anonymous inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and
PID namespaces along with any optional namespaces selected in flags.

Before entry, userspace populates the mount tree through the control fd:
FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the
nullfs root once (transitioning the rootns to ROOTNS_READY) and attaches
relative submounts beneath it.

Processes are spawned into a ready rootns via clone3() with
CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
retained "/" mount fd allows spawning with execveat() without copying
page tables.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
rootns_wait() returns init's exit status and rusage. rootns_kill() walks
pid_ns->idr under RCU to signal member thread groups.

CHANGES
=======

v2:
- Drop rootns provenance tracking (rootns_id and rootns_may_setns()) and
  rely on user_namespace ownership for setns() isolation (Andy
  Lutomirski).
- Replace the rootns_enter() system call with clone3(CLONE_INTO_ROOTNS)
  and struct clone_args.rootns (CLONE_ARGS_SIZE_VER3), allowing
  CLONE_VM | CLONE_VFORK and compatible per-child clone3() flags (Andy
  Lutomirski).
- Drop the spurious task_no_new_privs() check in may_enter_rootns_creds()
  (Andy Lutomirski).
- Update documentation, Kconfig, syscall tables, and kselftests for
  CLONE_INTO_ROOTNS.

VERSIONS
========

v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/

Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Kees Cook <kees@kernel.org>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>

Jarkko Sakkinen (13):
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns_create() system call
  rootns: Add rootns_wait() system call
  rootns: Add rootns_kill() system call
  fork: Support CLONE_INTO_ROOTNS in clone3()
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  fs: Support installing rootns mount trees via move_mount()
  arch: Wire up rootns system calls
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst       |    1 +
 Documentation/userspace-api/rootns.rst      |   40 +
 MAINTAINERS                                 |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl      |    3 +
 arch/arm/tools/syscall.tbl                  |    3 +
 arch/arm64/tools/syscall_32.tbl             |    3 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    3 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    3 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    3 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    3 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    3 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    3 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    3 +
 arch/s390/kernel/syscalls/syscall.tbl       |    3 +
 arch/sh/kernel/syscalls/syscall.tbl         |    3 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    3 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    3 +
 fs/fsopen.c                                 |   76 +-
 fs/namespace.c                              |  178 ++-
 fs/proc/root.c                              |   13 +
 include/linux/compat.h                      |    4 +
 include/linux/cred.h                        |    4 +-
 include/linux/fs_context.h                  |    3 +
 include/linux/nsproxy.h                     |    9 +-
 include/linux/pid_namespace.h               |    4 +
 include/linux/rootns.h                      |   92 ++
 include/linux/sched/task.h                  |    8 +
 include/linux/syscalls.h                    |    4 +
 include/uapi/asm-generic/unistd.h           |   10 +-
 include/uapi/linux/mount.h                  |    4 +-
 include/uapi/linux/rootns.h                 |   38 +
 include/uapi/linux/sched.h                  |    5 +
 init/Kconfig                                |    9 +
 ipc/mqueue.c                                |   12 +
 kernel/Makefile                             |    2 +
 kernel/cred.c                               |   70 +-
 kernel/fork.c                               |   67 +-
 kernel/nsproxy.c                            |   41 +-
 kernel/pid_namespace.c                      |    2 +
 kernel/rootns.c                             |  593 ++++++++
 kernel/sys_ni.c                             |    6 +
 scripts/syscall.tbl                         |    3 +
 tools/testing/selftests/Makefile            |    1 +
 tools/testing/selftests/rootns/.gitignore   |    2 +
 tools/testing/selftests/rootns/Makefile     |    5 +
 tools/testing/selftests/rootns/config       |    9 +
 tools/testing/selftests/rootns/smoke.c      | 1381 +++++++++++++++++++
 49 files changed, 2680 insertions(+), 75 deletions(-)
 create mode 100644 Documentation/userspace-api/rootns.rst
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c
 create mode 100644 tools/testing/selftests/rootns/.gitignore
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100644 tools/testing/selftests/rootns/smoke.c

--
2.47.3


