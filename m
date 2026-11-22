Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDB7606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=afSm/rTg
Received: by kanga.kvack.org (Postfix)
	id 4527B6B00EF; Sun, 22 Nov 2026 14:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402AB6B05B0; Sun, 22 Nov 2026 14:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2066B05B1; Sun, 22 Nov 2026 14:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 04EDA6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 14:35:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CA094052C
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:35:59 +0000 (UTC)
X-FDA: 85463760438.15.B5C5F38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D53CF180005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:35:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="afSm/rTg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795376158;
	b=KrYbX0LiRXT8ezea3uWmXvRCsb4XoRx08l3CXm+6FDMNyWOxdXxIB8YCttRk39k/wUv8QQ
	EhKEBHGlTNKA2LTIBd7a5erY9hyiq0cOUlAN4UT2Oc5fqj//EMJTw77GjGBxBijErstR93
	uaKuLIHYMeSMl7Iehuyb0r3C1wRnyxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795376158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z6BC8bTNkW2Kb/oWzgzzW0J38AL7u1XskPs2J4J0IMs=;
	b=Nid9zuGFWZaRCKFsxhCllHb8zEFFmNPPadWqEVRo+s5fmw4Sz2R5J+VxwgiyvQqhs8JpAu
	TwV50jR+pIe7bsgZd1DKQv3Dk6MqDeOxyDzUSmLQvMMH9ek+N+mpMW4QD7OHLcIni027Kt
	54TGNk05SnOcpzdjkgU8CeA4AoQSFec=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="afSm/rTg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id BB9E740167;
	Sun, 22 Nov 2026 19:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B9F611F000C4;
	Sun, 22 Nov 2026 19:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376156;
	bh=z6BC8bTNkW2Kb/oWzgzzW0J38AL7u1XskPs2J4J0IMs=;
	h=From:To:Cc:Subject:Date;
	b=afSm/rTgzZFMW4Yd8GBsTnSi9/k2rA1cJD3HY1AclLcTYC2Pw31SwD5cb38UUnt5h
	 moA+Kqi0QCm1/F/hxeBnTNyIYcLusk85RFidS1GsWr5couz3pL+I1T1yIBypCTASGe
	 XbUbdKrwjOFZa83YcBPm9SlCo8TjRp9S7RKJlOrFkc0NnR2SSFGLcS4WL3H/twPPag
	 f8GxIQ+hSsoK3ofc5Ng5+leToB1vwlHPQ2DMkJItOwKoQm9xxNT6/xhH/V5k7PWBEw
	 Mo/UCOByeRZwlG+JM1WWvB9HxaWLPKpZqmjCV+KRpaC0URJL4yccz9+7La7yWzW88A
	 HVkmmV/DgCtYg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v7 00/26] userland: Userland containers
Date: Sun, 22 Nov 2026 21:35:13 +0200
Message-ID: <20261122193539.3334213-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D53CF180005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kpybi66snddsza8wypjkto5qjzufgcyx
X-HE-Tag: 1795376157-299916
X-HE-Meta: U2FsdGVkX19qKoCZsNpFS5Qd848EgcKoKCdCn6eoMpSVmT30WTfhFQEXr7lSLE3CYMQtiAG8Vh+wnndQK6a9EtjyCypmthOy6FiC32mdqI8eI3rFSY7J0Gd4SWdUQq9+Y2mzp4ZBPzwjjwZ6CETRfMZCXkgMV1s3qi6wvU1kku1N6smhH4IgQddGmad+p+nslrvwJkiO21SFfFI1QxLu6OVYsNFZhCSW+JDIPhO6CGPSydhSgtsiqf4YWlpTUDALcwp0rRz1fMAwsuxIgtt6Ylhlo90La/zaJYBqrBbySYYiuU4cVQpEy8eDavUY2JQ+zwrDQAu7yzAhU/ozTDWoS2oXanXI0NTaUlVV3JiY5SGD+AX6vqCbJTlN/+epkxFJL/avqMHVq0bBJaASxpOMTrbzKiLtk+jXRbkYsaaxnVqNBBFjaIYWC689FiQ7AOidpYc55P0m/r0lLG4HtN6Ax1mooyrbltUloYtMZ9aej/4WUOlAR3QPv6zeQeCXJ1HAK+3BRN7b2Mef9bdlARseTILbwuXrYmOa7rzOasgl+iJ9Ck1RJ2oauOdjQjDGVAsbEhCPNR0QDuuABcjq0i7xGKGYaIRoDU5Q9RyWKGEJwdSe8foUOY/51nqXZ7rJUhLMtE7m6JNeggYpibtTn9sMr2Nl8J/S6+847VBBLFPi+rkPw9B6WpJgjIGJS6KaP3LKZdaKsyfbO4wN9P2gvyJnV2GSu5OqrLNPTQKBzMFNcIwL12WQHlMPUGrFM234mctbwRXACBqKPNCKKtec8VxL1ytxJ7KwoTN+fBolAA8hHVI7wy5argf1GyS8stglwkFNPpU/ziglIzUcZfvosMP7y+hwqNDlXXGDhFCkpyrhmwiFMmUmUQU0rC3rKZD1WyEvPak/UlZwVHbI2CAmNKLn/jBathbOycPG7UO4SXWI3ACeXNd+0xpxT/RCVBxi7PLMGUXdTrVPvtoX4GkWv5C
 0PUkx2Ks
 Eu/m+HG0qYT/LkGIwiX3OLWRQX9n6Te00EkDmGQinZ6tdIfw2CpMSlD3LqO6n1Czah6w96bgHxt48D0D9Mf8Uqcf6k1D2Szpsnj/8ZIKZIoRCPG2o4vXvTQojciKDs9iYiVhTRvn1HNeKJPMW2bGEbt5/6SkAf23C+/Ut8jcxi27D4Es0pTtGQ3RYP1M2HcQP84TaXBh/0jxXr6i+nlCmkKBviFpuRMGzs1amVCRYtVUqwmtOvbDV4WBc07k9FAgzEkPpqevP+ZbJstMEayedGjb0S/Gchud0xRo9gec8ZOCuci4yHSW39Rhje/Ne61tMTrlrQdQZHsm0iZB207Q+kRwRRh1iSO5Amc3P8cra+Eech4LWRcaOwVO5nVfWmShVAwNY7HtfjeSO0BdaeJXXS1MDhFxsBEi6N220Hz6GROYF1B9brUZS38tCIMdmUizHadNX8aKgalFRh2cMkf+nXvaCBqTAdcEOovJuYAPA1uveTpf1GulPhtI4hPR9FFsdWIwuAFODcIZpjGNxGl99Pud7CP+9fxwHvWPD/dj/zI9YSa4S2mLjo+XH0sPAbTrbi35PH9cp25bDvLDYRnIp/VFvEr7B+TJNMg3/wABcCV7wdjp9I22bLc0ehnkVvSTFSxgeqjmIwjafMskhTHCfPKLJ32/W2V1iEmihNjPji72imBDjAso4tUoddLf+CRtIn0dCqzKF8scSvVIiO/v4p/lMaHDQThZ59NLx34tvepO8JPy1tcZjWdxIVUGdaAbTJRh4jG5Of9yVYgJXHusQcHU+e1vQ7oGjstOyB69d3DMr6X7RhwIk9gNzFin21WQ8YSI8UaGXbV6Z12J8e40CoifdgK9UoeVzBmH470vTbjpqPu0RGCKEGZipy8m+ZI7DZLvISDVAph6jutGzb3kwbT51PGT9OF9Xbqwcz5xoQwJxBm3a6meHBAk3cfNnVcnlzOXpEqQF+BeFrwxcOGCSROiVaq4P
 qronTPRK
 RdQ5ASYT1hy4WMWL23UwqajAhPY3A2CQtVaRl3mbLHAEfItratBcVY9Bhph+WXTaMqVn30W29kD56HxWvMitX2rK0JJjOcqMf8YxpaeAbrQJAbtz24gfpRIGHLmZ7+lxljsws/YWSz3DiGCRxhiZGOIuj7lCcJeNYV/SQ5dYzCLLrfIIr7INEbyvpRnD+Kz8NM5M75pYjoXS3Z3kr10O2Tec+N5gj+oIMhW86CX+4Dyw7XC54aVVfp2RzpCZTlsPyGtmO3RyK2MH8j3KiZRiDbamwgiBnPqTycvXFp6YNJzWCLEl5A1nDz2Mu0IZOCOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

OVERVIEW
========

A userland is an anonymous-inode control object with separate build and
live phases that binds together:

1. A full set of detached namespaces owned by a fresh user namespace,
   with optional build-phase opt-in sharing (USERLAND_SHARE_NSFD).
2. A dedicated PID namespace for spawning processes into, signaling
   members, and polling or waiting on PID 1 exit.
3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
   directly in its target user namespace before going live, without
   inheriting host mounts or cloning staged trees, while still allowing
   new mounts to be attached at runtime.

Work on this feature started in 2025 after reviewing David Howells'
container object patch set [1], whose underlying mechanics made sense to
me as a continuation of earlier container object efforts [2]. The
lifecycle follows a staircase initialization model similar to the Intel
SGX driver, without an embryonic task state or a parallel namespace
syscall API, pairing a compact policy-agnostic implementation with an
allow-list security model (with LSM hooks) and runtime mount hotplug.

While the patch set is manually written, the original motivation came
from isolating LLM agents. Running untrusted agent workloads made it
clear that OCI runtimes need to minimize their live configuration
surface.

Assembling mounts, credentials, and namespaces inside helper processes
with a half-configured container is what I see as the main challenge,
and the existential debate around namespaces and container objects is an
unfocused discussion topic.

[1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
[2] https://lwn.net/Articles/1102593/

IMPLEMENTATION
==============

Standalone fd-based namespace configuration (patches 01-07) decouples
user and mount namespace setup from live helper tasks. userns_set_idmap()
atomically configures USERNS_SETGROUPS_ALLOWED policy and UID, GID, and
project ID mappings on a CLONE_NEWUSER nsfs fd, checking current_cred()
so an unprivileged creator can delegate the fd via SCM_RIGHTS to a
privileged mapping daemon. move_mount(..., MOVE_MOUNT_T_MNTNS) operates
on any non-anonymous mount namespace fd: on an empty mount namespace it
installs "/" onto the nullfs root once, attaches relative submounts both
before entry and into live mount namespaces, and supports
MOVE_MOUNT_CLONE for recursive bind mounts without OPEN_TREE_CLONE.

userland_open() allocates a userland instance backed by a pollable
anonymous-inode fd, creating a fresh owning user namespace and a full
set of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS,
IPC, network, cgroup, and time. ioctl(ufd, USERLAND_GET_NSFD, nstype)
returns nsfs file descriptors for member namespaces, and
ioctl(ufd, USERLAND_SHARE_NSFD, ns_fd) replaces a member cgroup, IPC,
UTS, network, or time namespace while the userland is in USERLAND_INIT.

Superblocks are configured directly in the target user namespace via
fsopen(), FSCONFIG_SET_USERLAND, and fsmount() for filesystems opting
into FS_USERLAND_MOUNT (tmpfs, ramfs, devpts, proc, mqueue) or
FS_USERNS_DELEGATABLE, allowing unprivileged callers to assemble mounts
without holding CAP_SYS_ADMIN in their own user namespace or entering
the target user namespace first.

Once "/" is installed, processes are spawned into the userland via
clone3() with CLONE_INTO_USERLAND and struct clone_args.userland,
without modifying the calling process's own live state first. Pairing
CLONE_INTO_USERLAND with CLONE_VFORK and opening the target binary via
openat2(..., RESOLVE_IN_ROOT) on the retained "/" mount fd allows
spawning with execveat() directly into the target root.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
waitid(P_USERLAND, ufd, infop, options, NULL) returns init's exit
status without consuming it. pidfd_send_signal(ufd, sig, NULL, 0) walks
pid_ns->idr under tasklist_lock to signal member thread groups, and
dedicated LSM hooks mediate userland allocation, teardown, namespace
sharing, process entry, and signal delivery.

SYSCALLS
========

Two new system calls are proposed:

1. userland_open(): open an opaque staircase-initialized container
   object (modeled on Intel SGX enclave initialization with separate
   build and live states) with no embryonic state, opting selected
   shared namespaces in via an allow-list instead of unshare semantics.
2. userns_set_idmap(): configure all UID, GID, and project ID map
   extents for a container user namespace in a single atomic system
   call.

Extensions to existing system calls:

1. move_mount() (MOVE_MOUNT_T_MNTNS, MOVE_MOUNT_CLONE): install "/" and
   relative submounts into a mount namespace fd before entry or at
   runtime, and recursively bind-clone mount trees without
   OPEN_TREE_CLONE.
2. clone3() (CLONE_INTO_USERLAND, struct clone_args.userland): spawn
   PID 1 and subsequent processes directly into a userland without
   modifying the calling process's own live state first.
3. fsopen() / fsconfig() / fsmount() (FSCONFIG_SET_USERLAND): bind a
   filesystem context to a userland's namespaces and create mounts
   without entering its user namespace.
4. waitid() (P_USERLAND): wait on a userland fd for PID 1 exit and read
   its exit status without consuming it.
5. pidfd_send_signal(): broadcast signals to member thread groups via a
   userland fd.
6. ioctl() (USERLAND_GET_NSFD, USERLAND_SHARE_NSFD): open member nsfs
   file descriptors and opt selected namespaces into existing nsfs fds
   during USERLAND_INIT.

HOTPLUG
=======

1. Host calls userland_open().
2. Host sets uid/gid maps with userns_set_idmap().
3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
   MOVE_MOUNT_CLONE for bind mounts.
4. Host spawns PID 1 with clone3(CLONE_INTO_USERLAND) (optionally
   passing an AF_UNIX socketpair fd for communication).
5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
   FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
6. On hotplug, host mounts the filesystem via fsopen() /
   fsconfig(FSCONFIG_SET_USERLAND) / fsmount() (plus optional
   MOUNT_ATTR_IDMAP).
7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
   and attaches the mount with MOVE_MOUNT_T_MNTNS.
8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
   statmount().

CHANGES
=======

v7:
- Run userland_copy() after dropping tasklist_lock in copy_process() so
  userland->lock is never acquired with interrupts disabled, and loop
  under userland->lock in userland_waitid() so blocking
  waitid(P_USERLAND) never returns -EAGAIN across concurrent bootstrap
  retries (Sashiko).
- Defer may_mount() in fsmount() until neither FSMOUNT_NAMESPACE nor
  fc->userland_bound applies, deduplicate idmap_maps_root() and
  unpriv_idmap_permitted() in kernel/user_namespace.c, compute
  foreign_ns once in mount_too_revealing(), hoist cross_child_src in
  attach_recursive_mnt(), and drop unreachable !current->nsproxy checks
  (Sashiko).
- Document ->set_userland() and userland_bound in mount_api.rst, move
  all userland.rst prose into kernel-doc comments including lifecycle
  states and credential rules, and narrow pidfd_send_signal() commit
  description to forks by member processes (Sashiko).
- Add TEST_INCLUDES for ksft.py, distinguish i386 from x32 on x86_64,
  tolerate CONFIG_TIME_NS=n in test_get_nsfd(), and switch AF_UNIX fd
  passing to SOCK_SEQPACKET in selftests/userland (Sashiko).

v6:
- Rename rootns to userland (CONFIG_USERLAND, userland_open(),
  userland_ prefix, CLONE_INTO_USERLAND, FSCONFIG_SET_USERLAND,
  P_USERLAND, USERLAND_GET_NSFD).
- Replace ROOTNS_WAIT and ROOTNS_KILL ioctls with waitid(P_USERLAND) and
  pidfd_send_signal() support for userland file descriptors.
- Add build-phase USERLAND_SHARE_NSFD ioctl and security_userland_share()
  LSM hook to opt cgroup, IPC, UTS, network, or time namespaces into an
  existing nsfs fd before process entry.
- Pass USERNS_SETGROUPS_ALLOWED via userns_set_idmap() flags instead of
  in-struct request flags.
- Gate FSCONFIG_SET_USERLAND and unprivileged fsopen() on explicit
  FS_USERLAND_MOUNT opt-in (tmpfs, ramfs, devpts, proc, mqueue), refresh
  fc->cred on bind, bound userns_set_idmap() size to PAGE_SIZE (-E2BIG),
  enforce projid_map privilege checks and atomic ns->flags updates, fix
  cross-userns slave mount locking in attach_recursive_mnt(), reject
  SB_NOUSER and cross-mntns nsfs loops in MOVE_MOUNT_CLONE, and walk
  ancestor PIDNS_ADDING flags in CLONE_INTO_USERLAND (Sashiko).

v5:
- Heavy reduction of cc-list. More added by request.
- Re-slice the patch set into standalone fd-based user and mount
  namespace configuration (01-07) followed by rootns (08-25), and split
  proc, ipc/mqueue, and bpf_lsm changes into separate commits.
- Add userns_set_idmap() system call to atomically configure setgroups
  and UID, GID, and project ID mappings on CLONE_NEWUSER nsfs fds
  without /proc/<pid>/*_map, checking current_cred() so unprivileged
  userns fds can be delegated via SCM_RIGHTS to a privileged mapping
  daemon (Andy Lutomirski).
- Add MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS in move_mount() to
  recursively bind-clone host mount subtrees into a target mount
  namespace fd without OPEN_TREE_CLONE.
- Clarify in overview and uAPI documentation that rootns is an
  anonymous-inode control object rather than an nsfs namespace.
- Fix upfront pidns ancestry check in ROOTNS_WAIT, bootstrap -EINVAL
  preservation in CLONE_INTO_ROOTNS, FSCONFIG_SET_ROOTNS user_ns
  delegation and fsmount() rootns_bound/seq_origin handling, proc
  pidns= mount option override check, cross-userns anonymous mount
  MNT_LOCKED propagation, and selftest wide-arch _IOC_NONE, socket
  blocking, and cleanup handling (Sashiko).
- Extend selftests/rootns with userns_set_idmap(), SCM_RIGHTS
  delegation, MOVE_MOUNT_CLONE, and hotplug mount coverage.

v4:
- A single syscall API (and shenanigans e.g., in fsconfig).
- I use a similar API model as I used in SGX driver, as like enclaves,
  containers are "closures". Instead of /dev/sgx_enclave like device
  file, anon inode is used.
- Consolidate rootns_create(), rootns_wait(), and rootns_kill() into a
  single rootns() system call plus ROOTNS_WAIT and ROOTNS_KILL ioctls,
  dropping rusage from ROOTNS_WAIT.
- LSM: lbs_rootns security blob management and security_rootns_alloc(),
  security_rootns_free(), security_rootns_clone(), and
  security_rootns_kill() LSM hooks wired into bpf_lsm.
- Disallow CLONE_VM with CLONE_INTO_ROOTNS across time namespaces, require
  CAP_SYS_CHROOT, preserve caller umask, reset dumpability on user
  namespace transitions, and fix ROOTNS_WAIT, FSCONFIG_SET_ROOTNS,
  fsmount(), and MOVE_MOUNT_T_MNTNS locking and permission checks
  (Sashiko).
- Rewrite selftests/rootns in Python. I used similar structure as I've
  used in selftests/tpm2. This "along the lines" mimics Cells style
  container manager. Rootns is a quite typical no policy solution and
  Cells is a managed solution, and they are at the far ends, which can
  also be witnessed from the patch set sizes.

  The question really is where we want to draw the borderline. I'm
  neither favoring nor supporting any possible solution because I don't
  know. I'm just saying where they live as a software stack.
- Update documentation and architecture syscall tables for rootns().

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

v6: https://lore.kernel.org/linux-fsdevel/20261122011809.2667684-1-jarkko@kernel.org/
v5: https://lore.kernel.org/linux-fsdevel/20261121000844.1863324-1-jarkko@kernel.org/
v4: https://lore.kernel.org/linux-fsdevel/20261119224312.1037966-1-jarkko@kernel.org/
v3: https://lore.kernel.org/linux-fsdevel/20261118193539.240065-1-jarkko@kernel.org/
v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/

Cc: bpf@vger.kernel.org
Cc: containers@lists.linux.dev
Cc: linux-api@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Aleksa Sarai <aleksa@amutable.com>
Cc: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kees Cook <kees@kernel.org>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>

Jarkko Sakkinen (26):
  userns: Factor out idmap validation and commit helpers
  userns: Add userns_set_idmap() system call
  arch: Wire up userns_set_idmap() system call
  mount: Add mnt_ns_get_root()
  mount: Enforce mount_too_revealing() for foreign mntns
  mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
  mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
  userns: Factor out install_user_ns_cred()
  nsproxy: Expose create_new_namespaces()
  userland: Add core infrastructure
  userland: Track init lifecycle via copy_process() and pid_namespace
  userland: Add userland_open() system call
  userland: Add USERLAND_GET_NSFD ioctl
  userland: Add USERLAND_SHARE_NSFD ioctl
  exit: Support P_USERLAND in waitid()
  signal: Support userland fds in pidfd_send_signal()
  fork: Support CLONE_INTO_USERLAND in clone3()
  fs: Support FSCONFIG_SET_USERLAND in fsconfig()
  proc: Implement ->set_userland() fs_context operation
  ipc/mqueue: Implement ->set_userland() fs_context operation
  security: Add userland LSM hooks
  bpf: Register userland LSM hooks
  arch: Wire up userland_open() system call
  docs: Document userland uAPI
  selftests/userland: Add userland test suite
  MAINTAINERS: Add entry for USERLAND

 Documentation/filesystems/mount_api.rst       |   32 +-
 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/userland.rst      |   77 +
 MAINTAINERS                                   |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl        |    2 +
 arch/arm/tools/syscall.tbl                    |    2 +
 arch/arm64/tools/syscall_32.tbl               |    2 +
 arch/m68k/kernel/syscalls/syscall.tbl         |    2 +
 arch/microblaze/kernel/syscalls/syscall.tbl   |    2 +
 arch/mips/kernel/syscalls/syscall_n32.tbl     |    2 +
 arch/mips/kernel/syscalls/syscall_n64.tbl     |    2 +
 arch/mips/kernel/syscalls/syscall_o32.tbl     |    2 +
 arch/parisc/kernel/syscalls/syscall.tbl       |    2 +
 arch/powerpc/kernel/syscalls/syscall.tbl      |    2 +
 arch/s390/kernel/syscalls/syscall.tbl         |    2 +
 arch/sh/kernel/syscalls/syscall.tbl           |    2 +
 arch/sparc/kernel/syscalls/syscall.tbl        |    2 +
 arch/x86/entry/syscalls/syscall_32.tbl        |    2 +
 arch/x86/entry/syscalls/syscall_64.tbl        |    2 +
 arch/xtensa/kernel/syscalls/syscall.tbl       |    2 +
 fs/devpts/inode.c                             |    4 +-
 fs/filesystems.c                              |   15 +
 fs/fs_context.c                               |   21 +-
 fs/fsopen.c                                   |  137 +-
 fs/internal.h                                 |    7 +-
 fs/namespace.c                                |  358 ++-
 fs/proc/root.c                                |   26 +-
 fs/ramfs/inode.c                              |    2 +-
 include/linux/cred.h                          |    4 +-
 include/linux/fs.h                            |    1 +
 include/linux/fs_context.h                    |    6 +
 include/linux/lsm_hook_defs.h                 |    8 +
 include/linux/lsm_hooks.h                     |    3 +
 include/linux/mnt_namespace.h                 |    2 +
 include/linux/nsfs.h                          |    1 +
 include/linux/nsproxy.h                       |    8 +-
 include/linux/pid_namespace.h                 |    4 +
 include/linux/sched/task.h                    |    6 +
 include/linux/security.h                      |   37 +
 include/linux/syscalls.h                      |    5 +
 include/linux/user_namespace.h                |    9 +-
 include/linux/userland.h                      |  135 +
 include/uapi/asm-generic/unistd.h             |   10 +-
 include/uapi/linux/mount.h                    |    5 +-
 include/uapi/linux/nsfs.h                     |   46 +
 include/uapi/linux/sched.h                    |    5 +
 include/uapi/linux/userland.h                 |   58 +
 include/uapi/linux/wait.h                     |    1 +
 init/Kconfig                                  |   10 +
 ipc/mqueue.c                                  |   18 +-
 kernel/Makefile                               |    2 +
 kernel/bpf/bpf_lsm.c                          |   11 +
 kernel/cred.c                                 |   27 +-
 kernel/exit.c                                 |    4 +
 kernel/fork.c                                 |   72 +-
 kernel/nsproxy.c                              |   15 +-
 kernel/pid_namespace.c                        |    2 +
 kernel/signal.c                               |    4 +
 kernel/sys_ni.c                               |    4 +
 kernel/user_namespace.c                       |  459 +++-
 kernel/userland.c                             |  717 +++++
 mm/shmem.c                                    |    5 +-
 scripts/syscall.tbl                           |    2 +
 security/lsm_init.c                           |    6 +
 security/security.c                           |   72 +
 tools/include/uapi/asm-generic/unistd.h       |   10 +-
 .../perf/arch/arm/entry/syscalls/syscall.tbl  |    2 +
 .../arch/mips/entry/syscalls/syscall_n64.tbl  |    2 +
 .../arch/powerpc/entry/syscalls/syscall.tbl   |    2 +
 .../perf/arch/s390/entry/syscalls/syscall.tbl |    2 +
 tools/perf/arch/sh/entry/syscalls/syscall.tbl |    2 +
 .../arch/sparc/entry/syscalls/syscall.tbl     |    2 +
 .../arch/x86/entry/syscalls/syscall_32.tbl    |    2 +
 .../arch/x86/entry/syscalls/syscall_64.tbl    |    2 +
 .../arch/xtensa/entry/syscalls/syscall.tbl    |    2 +
 tools/scripts/syscall.tbl                     |    2 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/userland/Makefile     |    6 +
 tools/testing/selftests/userland/config       |   10 +
 .../testing/selftests/userland/test_smoke.sh  |   10 +
 .../selftests/userland/userland_cells.py      | 1088 ++++++++
 .../selftests/userland/userland_test.py       | 2330 +++++++++++++++++
 83 files changed, 5782 insertions(+), 201 deletions(-)
 create mode 100644 Documentation/userspace-api/userland.rst
 create mode 100644 include/linux/userland.h
 create mode 100644 include/uapi/linux/userland.h
 create mode 100644 kernel/userland.c
 create mode 100644 tools/testing/selftests/userland/Makefile
 create mode 100644 tools/testing/selftests/userland/config
 create mode 100755 tools/testing/selftests/userland/test_smoke.sh
 create mode 100644 tools/testing/selftests/userland/userland_cells.py
 create mode 100755 tools/testing/selftests/userland/userland_test.py

--
2.47.3


