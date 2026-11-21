Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51C8606A685
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Qy+nfG9k
Received: by kanga.kvack.org (Postfix)
	id 2ACBD6B00EF; Fri, 20 Nov 2026 19:09:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236926B05B0; Fri, 20 Nov 2026 19:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFA56B05B1; Fri, 20 Nov 2026 19:09:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF3656B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:08:59 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 432E5160260
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:08:59 +0000 (UTC)
X-FDA: 85457190798.16.57B972B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 94950C0003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:08:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qy+nfG9k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219737;
	b=BvhV69XTkmMTOULv9Y3ZMrTGQMhueyl5DnVgG2pA40sJ1YMm4Serze2tRcbwLO2LJq6bE8
	9qP09SpVR5cf64gMRV6X/hWB01lgZ7rzXQY1TVv+AzPrtNuins6WdlYNMvfJl3CKAwWYej
	UjyVIriuCQ4OQ6+0544cN0CELFFDcdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1uAsKefbzilc6PMu577PfNWiDJqL44RmMPtTEi72U3A=;
	b=n1GQPzQExfR7Koyd7KPLmcgyZIvzlOt9Pj1aqsZOl/iOxCFCKbCu4m/EeXugtqCxQQCpVq
	aoi9mTMeiKM1KASigKUP1OqFQAkeRnRinhxBkVKVDtA7lN7Ic1UzOsTgftcILqgb5jR5q/
	FkYQcuT4kIiE/GfR08WAlfDh5zl/Ud4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qy+nfG9k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 11A0861D28;
	Sat, 21 Nov 2026 00:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F29591F000C0;
	Sat, 21 Nov 2026 00:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219735;
	bh=1uAsKefbzilc6PMu577PfNWiDJqL44RmMPtTEi72U3A=;
	h=From:To:Cc:Subject:Date;
	b=Qy+nfG9kndsGCWByIvx1D1qx5JMhbSigttGOpcfYj//YpOKAKVZXZGl+6zNKVzgws
	 HdcUIlX1NWuRqUuo5jcF3521ZG5+P4mHk+xULIs0qrUb3OHyJRhwF/Spy/ArdB9Feb
	 EipXNfNxnaQ+062S2zkRQRIxhQ8qddaUeBJ5a2MHpQVXbBQFi915KNLNhpWOhq80Iq
	 ZabN8IZPjmZKM4qqzAN4jTIXyVIj8vPnp2u2vLY+cm6oyAWuqsmrjCsw3xveIMq5yz
	 r3yLERHoO/2Zg8UHXnIY+/BZGAZasDl0BUpF2nLfv6GMAvMu9+eYljXdKmTs0Ke4Uv
	 uj5V45q7TNajw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 00/25] rootns: fd-bound process closures
Date: Sat, 21 Nov 2026 02:08:19 +0200
Message-ID: <20261121000844.1863324-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 94950C0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mg6cxxwq1z8ahijwf7jsywgo1crwmip1
X-Rspam-User:
X-HE-Tag: 1795219737-482198
X-HE-Meta: U2FsdGVkX18JSrSCzEWlQuGzfF557ionHIrteM9+eFfa0jc/c0s3BR4qjwMJIAJDMqEuGFgZtASBJ/VWaBq0iypvM7qrkSbhhGWW2sMin1N7d5eatGoBmh9mWKkk916AfXoGWarvIqoFGt9AWcqMG4BV22GxxZyhikzFvsZRb5T3KmYZ4xpziHICY0XaA01sMtCMcsC4BiGXq7Yfjvd1TWVYoiv0D4rW4jBigAZ/smAI8C9GBESKGru0zJQA9dl5wAzUqbv66zNRVv5teeofcUH+oDk/toxr44OsqaAnZlBvAg6hcJB0Tjr36Oqoxv9+8IiYZbJt1IxY0l6uFJyhQQYfCnU5p19xkVvkIdYA8yfe3vzJp13XPCtuPJfnZqd4ziCyranDpcYVKOKyFCWeay5eYVaG7RH5xn+YlpgQ77iogpHsEF2aofF7g1U96xytaI0rWov/wxRdCTjz2A18CB20nIUoo6UXKCTz4wvm/08rwDiR1as2XckAwSB9IjKaRCoFSg610y5fM98Zx95l5nOqaJNTior7RPC7fiqU5mPRn/PGtwTwojUVhzGnnTQv8lcM2VjTXOlH/zMH3jGYIrY3kBXgDIv2zktB3mcM0q4MWZIS4tVQk0jkf30c6HEdxvjXRLL0ff5i3XF65gVs1GafXXp8NVeFV5V5fV0lWkqqwdsmpwqH0Jemx2IijIRrdeGF22Zw/yjGbyjd/BTt4m9DEPRxkHoApSg6j7wYwIAM7im+aKxzSM4kjKFtPv0v9QeV2GzEVzJTjdePXrkv1mq5MIXf0Qpm7o4fmenA7/B7fclapAYMBFfpfTlX1TVEPuSG0lTZ36DErFOKHBI2L4QYqbLeG9nSWNfLbyIDcJTeh76OBX8tN0KY2AwKg7pQIW+y4UAI85fWlhCil9utPxuJ9X/3OS6cMZwYZbT0n/3ULvRwCQCyeeXPznS7kvTAjeYZxqLH2Yh0NZKTuRQ
 z6any6KA
 7aYjQWS5e+1l1mJElGkcG61f+EePXQJV4yIWmHxOZbX21eukqvZDIKM8DXNM51Fzlnvgiq9nb7WvUxz1QeyyrZHXCKT3bdL/L72MZylG2Ch89WTfEY47GFarIK6EzQ5I1n64b+K1emrkkCPrJSEurDOzkvMM6sOYIw92CL1MwK6PpFxnb1oeJCSQKm+A/xigBqHrlSbEo/ku8eeVb0lLx3ngkvN6xQ7WpKR+8sxaSZCLt8kzqxaeKGTHYE+ccdtnb9vhTS9JVe3ycBqmL9DR2dcLgJU+nmF37+O/xy9BfVZi88uvNXUPy93TKFYD4GC1H7tifwSzThHuaScoO1IzHITYpotmN9c2ogBwRFoWrmnnUl3Bu2A/QyJyQueZ6O1T0torpg/xNBwMvGk28Hde2WL9jAMzf0YvBYuQawH1l6XSTO4EPt48QqMOZ86VXOw1wkvLMYG61fk1ZznspWiIOqZ/tPqh5uQFEiXYRYCFfuHaIInCccB0aHctPXw9veGp5Muu3tO6KD0zgbXEUmVCZd2oymUSemCkFP45EB4nRd/+aayRuiOy3/sQ7vsj69F+yUldSqGc1k1pR995JrWxUb6GgVykhR0xPucwFssPCDoQ4RnAZ7j92HHiEXqmSvUyO9dnuRYx44xKWUdfC9A50GJDFoiX3fA5/St7UFcwhMX2FHvKkWK1tJQAs09SfkZfe6g1uWBk6U7VWYRu/BbKvZDHIpLE5vf5vd5Y2gZEpjarYpMVSuKPxzYHDIkF4L6BDqaT8iZzx23fVcxWaEoTjDWbi9541zFKQ1w8PQYKZmg/6wDOTdm3iPQ+gzVNrfoQjHRCgd3VnSiXjNaXAA6FRgybtqJ9VLGj0cukUi4WRNNaLDPxLtpx+iHNwXBkCy5JgVBiXez+80mP3u3Yf5zLO4vm6jU8caiq7oDmpQBVthlsOdBCkrD3MuDpBGv3d5Nhra74rjulfNPKgXlJESgZbP8HIzv9L
 Lncg++fg
 awoxwgVpKGJ/4EhPOxfMnZC8kYbsTlDNHKWuNPhvHO675VuRjhzn5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

OVERVIEW
========

A rootns is an anonymous-inode control object (not an nsfs namespace
itself) with separate build and live phases that binds together:

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

Standalone fd-based namespace configuration (patches 01-07) decouples
user and mount namespace setup from live helper tasks. userns_set_idmap()
atomically configures setgroups policy and UID, GID, and project ID
mappings on a CLONE_NEWUSER nsfs fd, checking current_cred() so an
unprivileged creator can delegate the fd via SCM_RIGHTS to a privileged
mapping daemon. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
non-anonymous mount namespace fd: on an empty mount namespace it installs
"/" onto the nullfs root once, attaches relative submounts both before
entry and into live mount namespaces, and supports MOVE_MOUNT_CLONE for
recursive bind mounts without OPEN_TREE_CLONE.

rootns() allocates a rootns instance backed by a pollable anonymous
inode fd, creating a fresh owning user namespace and a full set of
detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
returns nsfs file descriptors for individual member namespaces when
standalone namespace operations are needed.

Superblocks are configured directly in the target user namespace via
fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
callers to assemble FS_USERNS_MOUNT filesystems without holding
CAP_SYS_ADMIN in their own user namespace or entering the target user
namespace first.

Once "/" is installed, processes are spawned into the rootns via clone3()
with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VFORK and opening
the target binary via openat2(..., RESOLVE_IN_ROOT) on the retained "/"
mount fd allows spawning with execveat() directly into the target root.

The first entrant becomes PID 1; once it exits and
zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
ioctl(rootnsfd, ROOTNS_WAIT, &args) returns init's exit status.
ioctl(rootnsfd, ROOTNS_KILL, sig) walks pid_ns->idr under tasklist_lock
to signal member thread groups, and dedicated LSM hooks mediate rootns
allocation, teardown, process entry, and signal delivery.

HOTPLUG
=======

1. Host creates rootns().
2. Host sets uid/gid maps with userns_set_idmap().
3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
   MOVE_MOUNT_CLONE for bind mounts.
4. Host spawns PID 1 with clone3(CLONE_INTO_ROOTNS) (optionally passing
   an AF_UNIX socketpair fd for communication).
5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
   FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
6. On hotplug, host mounts the filesystem via fsopen()/fsmount() (plus
   optional MOUNT_ATTR_IDMAP).
7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
   and attaches the mount with MOVE_MOUNT_T_MNTNS.
8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
   statmount().

CHANGES
=======

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

v4: https://lore.kernel.org/linux-fsdevel/20261119224312.1037966-1-jarkko@kernel.org/
v3: https://lore.kernel.org/linux-fsdevel/20261118193539.240065-1-jarkko@kernel.org/
v2: https://lore.kernel.org/linux-fsdevel/20261117231352.3816603-1-jarkko@kernel.org/
v1: https://lore.kernel.org/linux-fsdevel/20261117050841.3289652-1-jarkko@kernel.org/

Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Alexander Mikhalitsyn <alex@amutable.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Serge Hallyn <sergeh@kernel.org>
Cc: Zygmunt Krynicki <zygmunt.krynicki@canonical.com>

Jarkko Sakkinen (25):
  userns: Factor out idmap validation and commit helpers
  userns: Add userns_set_idmap() system call
  arch: Wire up userns_set_idmap() system call
  mount: Add mnt_ns_get_root()
  mount: Enforce mount_too_revealing() for foreign mntns
  mount: Support MOVE_MOUNT_T_MNTNS in move_mount()
  mount: Support MOVE_MOUNT_CLONE with MOVE_MOUNT_T_MNTNS
  userns: Factor out install_user_ns_cred()
  nsfs: Add nsproxy_open_namespace()
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns() system call
  rootns: Add ROOTNS_WAIT ioctl
  rootns: Add ROOTNS_KILL ioctl
  fork: Support CLONE_INTO_ROOTNS in clone3()
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  proc: Implement ->set_rootns() fs_context operation
  ipc/mqueue: Implement ->set_rootns() fs_context operation
  security: Add rootns LSM hooks
  bpf: Register rootns LSM hooks
  arch: Wire up rootns() system call
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst         |    1 +
 .../userspace-api/ioctl/ioctl-number.rst      |    1 +
 Documentation/userspace-api/rootns.rst        |   65 +
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
 fs/devpts/inode.c                             |    2 +
 fs/filesystems.c                              |   15 +
 fs/fs_context.c                               |   21 +-
 fs/fsopen.c                                   |  140 +-
 fs/internal.h                                 |    6 +
 fs/namespace.c                                |  348 +++-
 fs/nsfs.c                                     |   64 +
 fs/proc/root.c                                |   22 +
 include/linux/cred.h                          |    4 +-
 include/linux/fs_context.h                    |    6 +
 include/linux/lsm_hook_defs.h                 |    7 +
 include/linux/lsm_hooks.h                     |    3 +
 include/linux/mnt_namespace.h                 |    2 +
 include/linux/nsfs.h                          |    2 +
 include/linux/nsproxy.h                       |    9 +-
 include/linux/pid_namespace.h                 |    4 +
 include/linux/rootns.h                        |   93 +
 include/linux/sched/task.h                    |    8 +
 include/linux/security.h                      |   30 +
 include/linux/syscalls.h                      |    5 +
 include/linux/time_namespace.h                |   13 +
 include/linux/user_namespace.h                |    7 +
 include/uapi/asm-generic/unistd.h             |   10 +-
 include/uapi/linux/mount.h                    |    5 +-
 include/uapi/linux/nsfs.h                     |   53 +
 include/uapi/linux/rootns.h                   |   83 +
 include/uapi/linux/sched.h                    |    5 +
 init/Kconfig                                  |    9 +
 ipc/mqueue.c                                  |   13 +
 kernel/Makefile                               |    2 +
 kernel/bpf/bpf_lsm.c                          |   10 +
 kernel/cred.c                                 |   32 +-
 kernel/fork.c                                 |   95 +-
 kernel/nsproxy.c                              |   41 +-
 kernel/pid_namespace.c                        |    2 +
 kernel/rootns.c                               |  588 ++++++
 kernel/sys_ni.c                               |    4 +
 kernel/user_namespace.c                       |  420 ++++-
 scripts/syscall.tbl                           |    2 +
 security/lsm_init.c                           |    6 +
 security/security.c                           |   86 +
 tools/testing/selftests/Makefile              |    1 +
 tools/testing/selftests/rootns/Makefile       |    5 +
 tools/testing/selftests/rootns/config         |   10 +
 .../testing/selftests/rootns/rootns_cells.py  | 1400 ++++++++++++++
 tools/testing/selftests/rootns/rootns_test.py | 1645 +++++++++++++++++
 tools/testing/selftests/rootns/test_smoke.sh  |   10 +
 67 files changed, 5286 insertions(+), 172 deletions(-)
 create mode 100644 Documentation/userspace-api/rootns.rst
 create mode 100644 include/linux/rootns.h
 create mode 100644 include/uapi/linux/rootns.h
 create mode 100644 kernel/rootns.c
 create mode 100644 tools/testing/selftests/rootns/Makefile
 create mode 100644 tools/testing/selftests/rootns/config
 create mode 100755 tools/testing/selftests/rootns/rootns_cells.py
 create mode 100755 tools/testing/selftests/rootns/rootns_test.py
 create mode 100755 tools/testing/selftests/rootns/test_smoke.sh

--
2.47.3


