Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C17D606A686
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N507s/tl
Received: by kanga.kvack.org (Postfix)
	id C8F806B00EF; Sat, 21 Nov 2026 20:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C405B6B05B0; Sat, 21 Nov 2026 20:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F276B05B1; Sat, 21 Nov 2026 20:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 874DF6B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:18:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 741D214040D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:22 +0000 (UTC)
X-FDA: 85460994444.28.A185B01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5F411C0005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:18:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N507s/tl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310301;
	b=US0/nbyQ7PTZMT7qM/7QSaFeKarq2VDQAAtia2ck5+KTKxfCsywf0P2DFKVMcHEPlxA1+B
	qFmQiaNFtjuRFa9KaRy9Xi1u1iKrCxswXS+bRvTEUyOpzavgeN2uNO7fSp8Le8gKIbUAYx
	NeWEWyeR1cU91gZ4kc9LY8xHAVDLoXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RY0oC16g4pVcARSzM2cC6w4tme3da83DOQJt8X7iSwg=;
	b=PJ1XfKgoHbHfhMNNUXugpBXZtYfJzhpMCJEDvTgBg+02TFfsgbqB5oMDn3Lb7GQfBqQubN
	UtohwCmm6lQfkn5KN3TOGGA1ur+ionc/NxY9imB54UsV6WoWtAD9lBzMfOpnaffajvGMAQ
	I4xKGrRNdHXdDEdllVJflCeq2aoeuyw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N507s/tl";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id C7169434F8;
	Sun, 22 Nov 2026 01:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 036241F000C6;
	Sun, 22 Nov 2026 01:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310299;
	bh=RY0oC16g4pVcARSzM2cC6w4tme3da83DOQJt8X7iSwg=;
	h=From:To:Cc:Subject:Date;
	b=N507s/tlkoHOxx6TlHiV6IAIlT7/JdsZZYDP6YtVcSExTAASZD7EArKUs3HwLAVB8
	 uFZMfjWx+uScMKGec3tIy7EuqvXCmhjRhBxKH0fBY1glCk+epOTu3LZ48piiF2ejrR
	 7fiHPi+1n/oshzItBvA7E8AmLlJrvutZCQ3AGVB+SdFqRCk7QDzqAZRL+3RxxlwGWE
	 OUie0JL3S/aBSEhnkAOYw73ATAc4dj9sKJUEdB8ook4NlmCCIw+FCQ0KxBXCnwaKui
	 zxJUmS2E+w6nGmYz6tp3NKfeWyx7GeDZLOUnBWhMLerAxu+RX8ErJM2msJ02thriZl
	 LrAizr8IaGuIQ==
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
Subject: [RFC PATCH v6 00/26] userland: Userland containers
Date: Sun, 22 Nov 2026 03:17:43 +0200
Message-ID: <20261122011809.2667684-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D5F411C0005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wj5f3o3m6by7r5675hfkhg9mweufyjb3
X-HE-Tag: 1795310300-33760
X-HE-Meta: U2FsdGVkX1+K0cWhPoZ+d0y5/5vxZJpJgsi+39VBn67o2pGOaa3/Va8Svvyu3LNIsvEbP7HHudysPFm2WlPNlBltNRSG+bE20pWv7p43ZtjZG5tnu1i/UYcf7FYHXwoUlWHr/P34RHoaNpET++VJS7Y7fv9UwcrtU/AkgPIjQNfeJyKVnOC4NAOzS5e7D37uhxCGsOAY+gR+BEpfrwG8/Vc5dKhhZPVKpdK6y4MEmqXOxhIOIVvRI/PWbijErClF0yUmn3rl8SGa1tMf+V9T37DPVCT22PmFvEDgjlWAMfv4eiJN2dNQezLsSHwrOqc6iQuA+/85HyaLNrJgacuV0sRs8mQmGp7mYw+PeKig4ITAtl9XcCbAvSxRKDOmPUlqLgeyctTcY1LfTMczdl/uBUwyYZqwim4t+x9luksDVDam80Lj29TbDvX8CP1Z4wxpSC0WnWd0QybsEACGbxsiiMZemJ2/YEyrbcc+Z3rbvoWPzN9bjlqWilAH0hwOD2Ihf2pw9r5knqrkQwVoRLyRm2D1dTbFE59eAeikCV1Vd7vyEPBJUS5RoU22uLhC4MQd7JGkoc8oR4HNSN3CAFQSu5S2gCf1U0u42MnADzebwKhnE4QYDHeiil8gQ5v+Uz0QU0iDhRtao0Q8Bh8q6UJDeGcGxq2U8OljQuFCj4c+sCgWmcv1gdk3uIcTEGD1iLEfibh2VcBMdimT8ap+kdNaZJ9rCXV0TqMF3ICaDqr2j21pi+/HbariEitlxlwLy4w94Dv46hvgB2yvwrKOlnK8P2XnDvHqoNIMfyn+9jQwE5/uEWLlBM6QsXMRhg23WBB6ai/OIxb5YBMX0EmH6mIe42RZ704KwNWtFjNmss3/QLHWEfG25gNyLoVRD9ZgcNVfcZ+LliLPGDAlbUqIjEfesxFfa3Kf2jC+DbH6vhQBxOSfLQaGyBNoqE5dhzkVCd9yAU3n6kOLkxupgg+0MNY
 zyx2DC9I
 FkVrgGi2fT27zMnUOXSlkKNRhOy8iNACv208ZhBWd1Q/u/dSW5snoD8LVQhhtf7HWdpqSl3uyQpgdmiO0CDNwBqzv442eW5UdX5Z5uGIdKI58G7A6Y8/aSt/HQD+qLkYO55kVYqNUG1286C8bNV2ZCkzVIWAzssVJB15vM0487dr4Qiq/OiZHdcqPLb0aoyuU5VZJpJW4AuXYulBFOppgM7jIQ0+YgFugE4k0+3ipYPIq1s1DCi29Iocm998rA2FOfn1F9ye++sRJdn+IQzZNc7gaSPk8UF/tFaS3X2xsS/GBKcatp4Tqh8zMP6fikF5+smwrl0/wscYxkkVluFjgS3VwgUiNM63Y19cfLTOPGG4kbTQtWvAyWoWzkLj92X3jIKEPXFlB7FNtl7VXdNXiwMx89mhBVj8r1mKvFP8N3BkyUoeU3VcFopwNGrdZuNoRo9hVEMF34bYbuO3s0peF+yB8AOGzDcVtOHH/n8WiMy9iW5Rcic7IvoF8uAnIj3lvUIo8/DUyUhGYeM4ws6KaZ+yoq6H5gb61/L9rZ3axiXZLIg5wTO/Ym9YQUMz0M0Wac03YsIVaqc3NPrSqDi6znOBzKaplxCztSY8N4bC2IYLPsRop2qKf612eoy0lmEaX19kra+jTbufI88X//Vb7Zrb9/BaMKT3Tq8txWxlf7/BIzy8zJuh1raO1B3IwWJK+8ZGTv/A+fi+dJIQ2T2WEesklu/J8Z/yP5dvcXZHcMzKhrrihqAy0AaPNUrypY1hnwZQI9MWwsEawuK8ZhTVebA2P43kBEZ2hwiN1StXJHcAwZpceMlT2DF/trYmcbkuYc6QSem37E0Bv9z0ZuhAX12wPddEM8AYpXY/PUo+x43FaCi2FQsVmqz5bAOmueFBUdPNoxJXiIDvlau3LdHSueMjy2MM/VQG8uD2SWSm5VeaKuOTXJB1Oh5IntOsIFozVEdqcvriVtKfpRUADaTeX7mPcjl4c
 vXUMCXHf
 lZoUwsBuo4uO3C52jtoYyXV+UF8tVrBfMhdrRzns8EUkMoF12uDvL6xhK/FqAs+i2hbjBAkCKEKT+W0aYxX9+fo9OEWAY/zIsH3SivoQEIVhZfjtamMGRCMGcnPFka5sDI0bnPkAouNKM9n1MkhL5/jwmVOk43ADRR1dITiUNv0pHpiHvGSxzmeuo4StDJ2O0/0qh/J1YP4jdYe9QutDuRFHOqzZtneTNOCDZIO6gMT6I12AwR7u5J66SvD/jWCNjuDVBMzyFgLdE9NHTNKIGFRRic0nXpTDOTcNJZcK9+h/nFipCkMl1v0t0RVLQriL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

OVERVIEW
========

A userland is an anonymous-inode control object (not an nsfs namespace
itself) with separate build and live phases that binds together:

1. A full set of detached namespaces owned by a fresh user namespace,
   with optional build-phase opt-in sharing (USERLAND_SHARE_NSFD).
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
clone3() with CLONE_INTO_USERLAND and struct clone_args.userland, without
mutating the caller in place. Pairing CLONE_INTO_USERLAND with
CLONE_VFORK and opening the target binary via openat2(...,
RESOLVE_IN_ROOT) on the retained "/" mount fd allows spawning with
execveat() directly into the target root.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
waitid(P_USERLAND, ufd, &infop, options, NULL) returns init's exit
status without consuming it. pidfd_send_signal(ufd, sig, NULL, 0) walks
pid_ns->idr under tasklist_lock to signal member thread groups, and
dedicated LSM hooks mediate userland allocation, teardown, namespace
sharing, process entry, and signal delivery.

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

 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/userland.rst      |   73 +
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
 fs/namespace.c                                |  352 ++-
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
 include/linux/userland.h                      |  107 +
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
 kernel/fork.c                                 |   71 +-
 kernel/nsproxy.c                              |   15 +-
 kernel/pid_namespace.c                        |    2 +
 kernel/signal.c                               |    4 +
 kernel/sys_ni.c                               |    4 +
 kernel/user_namespace.c                       |  419 ++-
 kernel/userland.c                             |  701 +++++
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
 tools/testing/selftests/userland/Makefile     |    5 +
 tools/testing/selftests/userland/config       |   10 +
 .../testing/selftests/userland/test_smoke.sh  |   10 +
 .../selftests/userland/userland_cells.py      | 1088 ++++++++
 .../selftests/userland/userland_test.py       | 2306 +++++++++++++++++
 82 files changed, 5663 insertions(+), 168 deletions(-)
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


