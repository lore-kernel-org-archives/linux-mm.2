Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1419B606BB7F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcK7Vsdt
Received: by kanga.kvack.org (Postfix)
	id 312916B05B7; Wed, 18 Nov 2026 14:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E9A56B05B8; Wed, 18 Nov 2026 14:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FFBA6B05B9; Wed, 18 Nov 2026 14:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC46D6B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:35:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D2E212082F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:35:51 +0000 (UTC)
X-FDA: 85449244902.11.36EF528
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DD42D40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:35:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NcK7Vsdt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030549;
	b=Z67eIJ1UfhxdM94utbRvq+mfvtg8sobYVujxnmY7H0NNFMDBR0t93VEtbIu7oyEa91ahat
	yMiiq1iO6x7JLd0gptHnL3xOyNkIpEbDHe8uEXNCYRU/jClNF4yZ//UQeT9rd1og4s+aI7
	KUJSeVu2EBfxVK7YKDVU3MOumJu7JA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xbv8g5bxpp2Fv6cOGTi8DfU9uX0lynk14/2FpTbovbA=;
	b=ZaSvaLby9YwQnTpMXe3Roah7OOxbPcngdhjCRlNFlQWyt88N557j8tsQPoioz+EZ91IbeY
	etnAXAQqHbRZPt65OQCP/dM5Cr6g2+eiZy6FmRxFrWjNqDM3lguJM7QJcYsJPi6AYMeggd
	0hoYKhwHGdOT9LHGPtFobT/YIt/abEM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NcK7Vsdt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 786DA6396D;
	Wed, 18 Nov 2026 19:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 737FB1F000C4;
	Wed, 18 Nov 2026 19:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030549;
	bh=Xbv8g5bxpp2Fv6cOGTi8DfU9uX0lynk14/2FpTbovbA=;
	h=From:To:Cc:Subject:Date;
	b=NcK7VsdtvHoJgcXaV0TXp0y8rUaVA1fHsvuAI0bdUxLAiNbpOHaKUUKDr+kaQXuNN
	 GJd6qLHrw9kqqA44KUimbBJzkuHXOzB4mDLIPEgmydmjED+CFkPpXEB1GcJ57xRCms
	 dwEX+7UjRdt27DhXVp1zTfCqNaDf6luApDpvkC13ga1d0TMEGFHMh/xUmvwwem85NZ
	 +2+rQKqMKSMg1ww54PcDaWQHqQ02YEUTQ3O4mILCODtFpd6HNf9bBfBkDJ3au9VcaP
	 zDP1f8/UlQdjPhp5NkA3S6VgR8ITsGH7oB0gkGrC7WhacgFyv+wR5L/qum7/RoaQqF
	 4Wtpqkxr1fSQQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
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
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 00/13] Namespace for namespace roots
Date: Wed, 18 Nov 2026 21:35:26 +0200
Message-ID: <20261118193539.240065-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mobndo9bsr1yrw4ofats6t6o39og67pd
X-Rspamd-Queue-Id: DD42D40009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1795030549-991787
X-HE-Meta: U2FsdGVkX19h7E6ktWxnfauiIvdkBd07UXDR9xT8R2q/onp+XebLlGxOfK7/Yn/yOiT5pHfihGkciVtu9tkFkZoBRb2BVy0wmR8/H/nbmStqYOfUCzfFNM32NdApwFg29STIUI4zQYj251AHLIexx6V6ent83wyzkVZXLWHzYUnwYdg5w2m5TR+l71sQmSBoOcBKGJC9fI62NBcK+zX/IW2EE3wPEU1UuAbsTj7Z2OnVG6ldUWnSatXGGMIhlkZcBOvZRAvZO99tZuR0bTuQktLJnnUr/TQa8f0UQsNbm2LGESjB2XHb/dBtMGLp9XSBq1T9D8HCnzqbs4hMubOJqxDDgu+Napahtux+LA+jxKg55pVUrqgO6VTAszRFniD5UYw5De9dppciLoN878+igbSXs8W+TLwiHUL2CCjnd8SubEGcuqlwK+RhZYzUDHTQzI7yk9iMGTQSzopYzLakBcQvbuw0twGb4DYoIbRjRPY8BT7eGM6KMSVtmYck4r4sTND0F2H664d3UMYRCOJWP6Gqj32BttRXRkQ8jqSCXLqN+KgGFSKqXD1Ux/k3iPjg5o1dTQzPIy6+J7kYXWIWPAsZkrsm7sh+6sY24uEJ+6bq42kQpCoznVihNl27kt3icRc3gFdKIg6XDjci6+kFxKGMgjw6utmyjGy0C5vJPY3pP49G8Ps+FYDZIsYlf1J6Hd5DdGz5b53LhSmO5EsrG5WOW4yP3uER014BUFECHPDyLSmaeQirQp9BXRfnutZy7anw1n5suVE5V64eLY0/n4LlDPbDOZxdOpR5W6SPvtRvYbwO0o9YrsxF9zJmyrgobmNGUmOTODmmu9HxoAjK8Xc4v3rswhHK6SUYawvYKbq28suDRl+H52WbNse6CkDAPuwDV4l0a5cAeFLFGaHsJN0/IZInF9vrW1BHy6a7KXzFbI3nM3P3yGygqS85VbTM4aKVWFUYAQMT0eiYhpT
 glBfvAew
 +ircD7lKRL6K8sl/y5ajeiJrHG9gMSTO3OrNrXcM8FsZxUkDvvJlILyFRcTFxIPLDWWM9obXs7ro1ytGk0WUw7GQTvI+WpdAow8JwUH40lbNwSJLj7lQxqP0PviWqyDRsVj/giW/RasdAHMDy3fzQT7M2ozbZs7CoJGpdZiVY1ujoJMCip7p9r8cYKtwAF50dux2tBnNL5zu9LLdAEuFz1IOSDozN0TjnbgOo7fPTEDh1wcKS885IJtUzFDC8oRY8/CQEsunmP1tMDkM1vJtNVvPl0z7eH55tem5P3Bh1V/liSxV9ofQstSD5/btPqDFBUAYUnljfvhkbVOrGgqiTn++MYKLIUuYfgcgphN44ZsO22YhZ0zURx6BT60LPy9uW/8UqNlhSse1t43FG4uNYbPT5RK8wCXgUJfjWVzZZjbeLELC3LZAeDJ6rFFoy8McX0yAO/dXiBXhuDHa0EsQDEMNR4PXn10wiQ2c1N+6yb8OpxEDgZyudQnu23YS2XKc+Nwy442W8UfBwILxrYk6u1BSUgoeEuyIEx1bemuaNgf4Koyjab2lI5UcnS8rrF9kIUe5HB3TiE3GWiewo/j2IYo526a64Z6p/BtV4QcKuYJs1URwKt/ze90SZDFkacMZ4iI9TB8/zQaG4Ae7F77CB0SzkzOU8RSnlX5tdZovwsp8zP0n4UXq2u2NcTUy/9VuFCRvnX7KsJMpTCod70+5R/6WvEiXhUN6WQ3QKTJ2fD5hAYeYhulK+iCqzMGCFS87gt9X/omGSwgCeJJymEGLKRW6ReofNEdIV/tm3e0u1xu55VAIW6WuBkmwczsjfeEstV+dMZov5728MBJ43T7YLBqyNg2WKc3w+vEW8BxMoVn9YfUdUr4TFMG0oEkrEcsuMBmXsuIFPym8Yv83FFIEy8IljWNVJl8IduOKAwcpW2gVo556atVlwaKBrgJ9dALPg9+b7r4SbhImawL98Vh+NGZ++4PSR
 VoZpZ2V1
 JDF4ij7cr5Lr+8N+8RlAal6tFw7HeV5fjz5ACuQjwPdHsWADQhYICoIfLVtutV3ri/HvQIlOQ++/PhoaBa5yQ9B3Zzps/SUcMIThu+Ue73fxhFXQTJPUeVgZXEtKNH6BcccwT1QPjI/+ulinsCdyO8yAWvKeyt+A0uw0N+GKvAIgrkB2EepWiXMKx2kJXuPafDl1tXzW7BvrZWDK8oc9iAOFptCgOVQbHxzphZCLnfheNpOri3GxvUKstrTjFJFsi9QrZy1lf8NgSt+yKRJjriiBlZxLxvPY6czZDyET8v4pfEcM30yOTay3FfhuIwKES8IU1GT0lqz8J/TocmKJhEUVun/gajdMYvvCcHbAF/G9+8VdRn5k2dL/4BR0vIn+9lWWyR9ovwprlsZ7kA/X8RkomnGq43b5J6Ow+6tMOpI/68dlmduc/iW9w4mK3cof
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

1. A full set of detached namespaces owned by a fresh user namespace.
2. A dedicated PID namespace for spawning processes into, signaling
   members, and polling or waiting on PID 1 exit.
3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
   directly in its target user namespace before going live, without
   inheriting host mounts or cloning staged trees, while still allowing
   new mounts to be attached at runtime.

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
anonymous inode fd, creating a fresh owning user namespace and a full set
of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
returns nsfs file descriptors for individual member namespaces when
standalone namespace operations are needed.

Superblocks are configured directly in the target user namespace via
fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
callers to assemble FS_USERNS_MOUNT filesystems without holding
CAP_SYS_ADMIN in their own user namespace or entering the target user
namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
non-anonymous mount namespace fd: on an empty mount namespace it installs
"/" onto the nullfs root once, and it attaches relative submounts both
before entry and into live mount namespaces.

Once "/" is installed, processes are spawned into the rootns via clone3()
with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
retained "/" mount fd allows spawning with execveat() without copying
page tables.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
rootns_wait() returns init's exit status and rusage. rootns_kill() walks
pid_ns->idr under tasklist_lock to signal member thread groups.

CHANGES
=======

v3:
- The patch set size increased predominantly because the coverage of
  kselftest had to widened to cover the introduced changes.
- Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
  mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
  namespace fds (Andy Lutomirski).
- Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
  configure and mount FS_USERNS_MOUNT filesystems directly in the target
  user namespace without entering it first (Andy Lutomirski).
- Fix locking, refcounting, credential/dumpability/timens setup,
  pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
  CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
  (Sashiko).
- Mark PowerPC rootns syscalls nospu (Sashiko).
- Update documentation and kselftests.

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

v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
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
Cc: Anna-Maria Behnsen <anna-maria@linutronix.de>
Cc: Ben Segall <bsegall@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Jonathan Corbet <corbet@lwn.net>
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
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
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
  fs: Support MOVE_MOUNT_T_MNTNS in move_mount()
  arch: Wire up rootns system calls
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/rootns.rst        |   47 +
 MAINTAINERS                                   |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl        |    3 +
 arch/arm/tools/syscall.tbl                    |    3 +
 arch/arm64/tools/syscall_32.tbl               |    3 +
 arch/m68k/kernel/syscalls/syscall.tbl         |    3 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |    3 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |    3 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |    3 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |    3 +
 arch/parisc/kernel/syscalls/syscall.tbl       |    3 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |    3 +
 arch/s390/kernel/syscalls/syscall.tbl         |    3 +
 arch/sh/kernel/syscalls/syscall.tbl           |    3 +
 arch/sparc/kernel/syscalls/syscall.tbl        |    3 +
 arch/x86/entry/syscalls/syscall_32.tbl        |    3 +
 arch/x86/entry/syscalls/syscall_64.tbl        |    3 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |    3 +
 fs/filesystems.c                              |   15 +
 fs/fs_context.c                               |   20 +-
 fs/fsopen.c                                   |  121 +-
 fs/internal.h                                 |    6 +
 fs/namespace.c                                |  245 ++-
 fs/nsfs.c                                     |   64 +
 fs/proc/root.c                                |   18 +
 include/linux/compat.h                        |    4 +
 include/linux/cred.h                          |    4 +-
 include/linux/fs_context.h                    |    5 +
 include/linux/mnt_namespace.h                 |    2 +
 include/linux/nsfs.h                          |    2 +
 include/linux/nsproxy.h                       |    9 +-
 include/linux/pid_namespace.h                 |    4 +
 include/linux/rootns.h                        |   91 +
 include/linux/sched/task.h                    |    8 +
 include/linux/syscalls.h                      |    4 +
 include/linux/time_namespace.h                |   21 +
 include/linux/user_namespace.h                |    7 +
 include/uapi/asm-generic/unistd.h             |   10 +-
 include/uapi/linux/mount.h                    |    4 +-
 include/uapi/linux/rootns.h                   |   44 +
 include/uapi/linux/sched.h                    |    5 +
 init/Kconfig                                  |    9 +
 ipc/mqueue.c                                  |   13 +
 kernel/Makefile                               |    2 +
 kernel/cred.c                                 |   31 +-
 kernel/fork.c                                 |   97 +-
 kernel/nsproxy.c                              |   44 +-
 kernel/pid_namespace.c                        |    2 +
 kernel/rootns.c                               |  609 ++++++
 kernel/sys_ni.c                               |    6 +
 kernel/time/namespace_vdso.c                  |    8 +
 kernel/user_namespace.c                       |   12 +-
 scripts/syscall.tbl                           |    3 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/rootns/.gitignore     |    2 +
 tools/testing/selftests/rootns/Makefile       |    5 +
 tools/testing/selftests/rootns/config         |   10 +
 tools/testing/selftests/rootns/smoke.c        | 1934 +++++++++++++++++
 60 files changed, 3529 insertions(+), 80 deletions(-)
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


