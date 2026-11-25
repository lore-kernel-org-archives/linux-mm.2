Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430C3606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 16:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UqK2qb3F
Received: by kanga.kvack.org (Postfix)
	id 641446B0A75; Wed, 25 Nov 2026 11:24:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1C36B0A77; Wed, 25 Nov 2026 11:24:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0A86B0A78; Wed, 25 Nov 2026 11:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2435F6B0A75
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:24:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB22B160EEC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:24:22 +0000 (UTC)
X-FDA: 85474163964.21.C4B4984
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12B39180005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:24:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqK2qb3F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795623861;
	b=casI9woAnQEIr8K45/iwznoHQOp+xRX72MKK3Bg5nbvtWlO1LP9qrjuHlf5LHBvVaPLD01
	l6rj5noPYiNXIvJlWndaFmd8zQjL5WnryoM7sEd5UiqV/Zxp0sSXSK7zgbyeAbkOoRSBPa
	mhyiqZV5tvtCfCy/jQ+9X3hAzH1XXJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795623861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93PlHQzdBd5hDciyifgipa2sETM6WYe2vvJEu0EdaIE=;
	b=NuQlB35csr7FO5LKGLmj5pAJt5GNw1+tok2hDN+2uz6wXgoqFP9sml0uHhq20aJ8jlWM1I
	TdWX2gF4FeC8Wb0ZwRccvJ+xALw11VpAk2dVLvRDTPHml5tFQ1iEha1oIvc0/FgBBX5+qb
	ZD9SjdFVH0NUytCZ9JQFEzVgCu4cuAk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UqK2qb3F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 85FA96341F;
	Wed, 25 Nov 2026 16:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7624A1F000C4;
	Wed, 25 Nov 2026 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795623860;
	bh=93PlHQzdBd5hDciyifgipa2sETM6WYe2vvJEu0EdaIE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UqK2qb3FQVwmTqV8oUUCeEtkJg9SD6RlxBIdsewlju3Y6yf64LEDRua/CP8PuokUM
	 o1vJ05+rehtnQ3lsUqLX4G48iP71LMVhvqDAURRrlVkTETRCB1t1zf1GLgSh8PC6ov
	 hrTGvDOKmlnQrx8Cvm6tsUTJp5p4ASihgzfEEEV9BP/JDjAgo9v0Ev7deWEw5eoLci
	 fb4P7fSbUfxBYC/3IBYMbAUeM92yF05ODOER00oMYavQQn/fmId7+9baSwIFZ01rf+
	 WElptmHmI3QPFYytegFUZC4SluG5bFEfaeSzufIKLwi0d+u4kuLU63S4GkWl1Ozxst
	 DzmuADMR9Ln/A==
Date: Wed, 25 Nov 2026 18:24:16 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
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
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awcLsCALUwJ1Qlcc@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awYJnFNt9kkBqj59@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awYJnFNt9kkBqj59@kernel.org>
X-Stat-Signature: atfj3xqcqykonch148qb35t6hegdqttu
X-Rspamd-Queue-Id: 12B39180005
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795623860-24317
X-HE-Meta: U2FsdGVkX1+UaAIqrNhk+e6v8SmV8ulhxmuuGTaaDl/gn1mCSQ5t0f6zQm5AgHQU9l5pEqEo4xLd1h+0UUb3Ui2plLDxe/Li33T263MpNIYaK71tKZIQVU73m9AvDBWMXZUjTGetC8YjjtDH+9NyuWn/hi+o+ScT8MI9gbEooBIdrRXgUY/B1E+Bs4kU2tWuZkJiof5lxwPs4XYYteC9sqdAWhhCse3MwqETsrc+gv0GQHdN5TbwWo3fV1OJT9czwDzzKZ8Wto1IBkScZMtL9ZbMF58XaVKdFGdsROEA3Ho8Dnu4OvAWd5tMPRj6Tt+Ul6WC2o2tVs2JRh3BcYlbvQzD5o1gLuvD0t4lfcbByFfToDkqwxZkrkIJilWBvVo0hq2CMpcQbUIlgcPtKvBkR8wSLxluh1TQqiVHReVzrhVf4QEYQEVR1Z4C0GtAENnW9SsGbDaCV4R304V70x3Y+g5kr6Oz5BsxSBy/H5RLSp1cn9eb9I/6Q6f5X0rnTaQ3+sAIjYKcL7xrFcHwmgq7ZLuH6sIeYPcP92eJO9HwYbj0Lg11cyjHp83wF9PIyqv8FvREtI1I4LF3lGZ4F+QvZOAPKPhUbl/tnyT96ZfeRiTxxqzcgElfpg1fcGEcsM0BfnbfZHSnJ9to4gk/PLqo626mVKke+X43tbym7aymDuzy5Tihtzq84nYCylmldDV/45NKk4pwmQyT3Oo9YqQnG/YdCL3QRFnTaJJDOql2lg6w0Tu0iKweRSLOopQN8zLBZzHMQim1P2Tzw3t5i+RtI+iHVkWiN4xQ+KLCOStCuKDrfjeSHM4d6xpq7KQljz021ESrFeVR37fbNrS+ITeQazeypkUyBGwXCHaY6+i20ehc+uUGHOhBg7YWc3WHFk4NBi699DInoNex5o5vKZd3dPQKwPnax04WJ/atmKvtTZbn2chauDEEkpAqQ92WPhWAiLaNKzHLzdkPG9979Yc
 LZV8Zn3H
 UQYSTwOhYCkacqhQQn2R2cfODUihk3WYJ2QzXulN08f5uEZSmqfPI2lAZGXr8nZOIRZuHzYkUCIbvy+Le4eMSjkjaWhRokYerqsRmbNam/gnY+mXBTgAZfsqihtFqnDj97IoyKPNTEXMB6f9r8ttiV/okvVTaR0VRVmvGJjeBgAxS0ln+b2465zDuKN4BqCzf8bdCMeQEta08GgQ3inKEdGaNumV/H/PwKfa2XD6rzwDYCkXTqfBuDM7kRq97orofKBZFJ/CRlDY7BqI2jgmmCZAmX5grg0UPuZbNyOUzhBzOxwzMXHvBAU8ZWLlS+AUM2HvFA5dRtil0WeT9JoWfZZyh+YQJFINipzWgRQeuQV9W9mwqYj+0gcfxkcXhSQCol70oHlxLmXFh1ju2v+dHPmxSfCLc0TyNENqgXPsuSr5Bq1N3oGwoJoVVuDw/39GyB9ifMg/goo6O/GtpGmUMQVeXAKNtDuKtYeGKisauXhEoBJ4TtXi6v4RNDjKiOkw14DO+f2qqkAQNN3CLTTqZfzaWzGw1zb/b6vJNZpBOP5RIXkbQQRDwbNG3EPpWPeol8BmD6JcyzeAItRblP4yG0IlGFsbSeHTnoSxa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 12:03:12AM +0200, Jarkko Sakkinen wrote:
> On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > OVERVIEW
> > ========
> > 
> > A userland is an anonymous-inode control object with separate build and
> > live phases that binds together:
> > 
> > 1. A full set of detached namespaces owned by a fresh user namespace,
> >    with optional build-phase opt-in sharing (USERLAND_SHARE_NSFD).
> > 2. A dedicated PID namespace for spawning processes into, signaling
> >    members, and polling or waiting on PID 1 exit.
> > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
> >    directly in its target user namespace before going live, without
> >    inheriting host mounts or cloning staged trees, while still allowing
> >    new mounts to be attached at runtime.
> > 
> > Work on this feature started in 2025 after reviewing David Howells'
> > container object patch set [1], whose underlying mechanics made sense to
> > me as a continuation of earlier container object efforts [2]. The
> > lifecycle follows a staircase initialization model similar to the Intel
> > SGX driver, without an embryonic task state or a parallel namespace
> > syscall API, pairing a compact policy-agnostic implementation with an
> > allow-list security model (with LSM hooks) and runtime mount hotplug.
> > 
> > While the patch set is manually written, the original motivation came
> > from isolating LLM agents. Running untrusted agent workloads made it
> > clear that OCI runtimes need to minimize their live configuration
> > surface.
> > 
> > Assembling mounts, credentials, and namespaces inside helper processes
> > with a half-configured container is what I see as the main challenge,
> > and the existential debate around namespaces and container objects is an
> > unfocused discussion topic.
> > 
> > [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> > [2] https://lwn.net/Articles/1102593/
> > 
> > IMPLEMENTATION
> > ==============
> > 
> > Standalone fd-based namespace configuration (patches 01-07) decouples
> > user and mount namespace setup from live helper tasks. userns_set_idmap()
> > atomically configures USERNS_SETGROUPS_ALLOWED policy and UID, GID, and
> > project ID mappings on a CLONE_NEWUSER nsfs fd, checking current_cred()
> > so an unprivileged creator can delegate the fd via SCM_RIGHTS to a
> > privileged mapping daemon. move_mount(..., MOVE_MOUNT_T_MNTNS) operates
> > on any non-anonymous mount namespace fd: on an empty mount namespace it
> > installs "/" onto the nullfs root once, attaches relative submounts both
> > before entry and into live mount namespaces, and supports
> > MOVE_MOUNT_CLONE for recursive bind mounts without OPEN_TREE_CLONE.
> > 
> > userland_open() allocates a userland instance backed by a pollable
> > anonymous-inode fd, creating a fresh owning user namespace and a full
> > set of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS,
> > IPC, network, cgroup, and time. ioctl(ufd, USERLAND_GET_NSFD, nstype)
> > returns nsfs file descriptors for member namespaces, and
> > ioctl(ufd, USERLAND_SHARE_NSFD, ns_fd) replaces a member cgroup, IPC,
> > UTS, network, or time namespace while the userland is in USERLAND_INIT.
> > 
> > Superblocks are configured directly in the target user namespace via
> > fsopen(), FSCONFIG_SET_USERLAND, and fsmount() for filesystems opting
> > into FS_USERLAND_MOUNT (tmpfs, ramfs, devpts, proc, mqueue) or
> > FS_USERNS_DELEGATABLE, allowing unprivileged callers to assemble mounts
> > without holding CAP_SYS_ADMIN in their own user namespace or entering
> > the target user namespace first.
> > 
> > Once "/" is installed, processes are spawned into the userland via
> > clone3() with CLONE_INTO_USERLAND and struct clone_args.userland,
> > without modifying the calling process's own live state first. Pairing
> > CLONE_INTO_USERLAND with CLONE_VFORK and opening the target binary via
> > openat2(..., RESOLVE_IN_ROOT) on the retained "/" mount fd allows
> > spawning with execveat() directly into the target root.
> > 
> > The first entrant becomes PID 1; once it exits and
> > zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> > waitid(P_USERLAND, ufd, infop, options, NULL) returns init's exit
> > status without consuming it. pidfd_send_signal(ufd, sig, NULL, 0) walks
> > pid_ns->idr under tasklist_lock to signal member thread groups, and
> > dedicated LSM hooks mediate userland allocation, teardown, namespace
> > sharing, process entry, and signal delivery.
> > 
> > SYSCALLS
> > ========
> > 
> > Two new system calls are proposed:
> > 
> > 1. userland_open(): open an opaque staircase-initialized container
> >    object (modeled on Intel SGX enclave initialization with separate
> >    build and live states) with no embryonic state, opting selected
> >    shared namespaces in via an allow-list instead of unshare semantics.
> > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> >    extents for a container user namespace in a single atomic system
> >    call.
> > 
> > Extensions to existing system calls:
> > 
> > 1. move_mount() (MOVE_MOUNT_T_MNTNS, MOVE_MOUNT_CLONE): install "/" and
> >    relative submounts into a mount namespace fd before entry or at
> >    runtime, and recursively bind-clone mount trees without
> >    OPEN_TREE_CLONE.
> > 2. clone3() (CLONE_INTO_USERLAND, struct clone_args.userland): spawn
> >    PID 1 and subsequent processes directly into a userland without
> >    modifying the calling process's own live state first.
> > 3. fsopen() / fsconfig() / fsmount() (FSCONFIG_SET_USERLAND): bind a
> >    filesystem context to a userland's namespaces and create mounts
> >    without entering its user namespace.
> > 4. waitid() (P_USERLAND): wait on a userland fd for PID 1 exit and read
> >    its exit status without consuming it.
> > 5. pidfd_send_signal(): broadcast signals to member thread groups via a
> >    userland fd.
> > 6. ioctl() (USERLAND_GET_NSFD, USERLAND_SHARE_NSFD): open member nsfs
> >    file descriptors and opt selected namespaces into existing nsfs fds
> >    during USERLAND_INIT.
> > 
> > HOTPLUG
> > =======
> > 
> > 1. Host calls userland_open().
> > 2. Host sets uid/gid maps with userns_set_idmap().
> > 3. Host populates "/" with MOVE_MOUNT_T_MNTNS, optionally combined with
> >    MOVE_MOUNT_CLONE for bind mounts.
> > 4. Host spawns PID 1 with clone3(CLONE_INTO_USERLAND) (optionally
> >    passing an AF_UNIX socketpair fd for communication).
> > 5. PID 1 watches /proc/self/ns/mnt via fanotify(FAN_REPORT_MNT |
> >    FAN_MARK_MNTNS, FAN_MNT_ATTACH) or polls /proc/self/mountinfo.
> > 6. On hotplug, host mounts the filesystem via fsopen() /
> >    fsconfig(FSCONFIG_SET_USERLAND) / fsmount() (plus optional
> >    MOUNT_ATTR_IDMAP).
> > 7. Host creates the mountpoint with openat2(RESOLVE_IN_ROOT) + mkdirat()
> >    and attaches the mount with MOVE_MOUNT_T_MNTNS.
> > 8. PID 1 receives FAN_MNT_ATTACH and queries the new mount via
> >    statmount().
> 
> The initial ad-hoc testing of hotplug using a bare metal x86-64 machine
> and systemd-nspawn has been successful. The kselftest seems provide
> pretty good guarantees for the basic stability; using the syscalls has
> caused no issues so far.
> 
> I took some time to go through my experimental SystemD patch files and
> sliced them so that they ought to be easy to bisect and refactor. They
> should be also quite easy to read, understand and evaluate. Finally, I
> removed the shitty patch files from my test harness repository.
> 
> Resulting outcomes of all of this are:
> 
> 1. Rebased RFC v7 patches with refined LSM support and fixes to the
>    known issues as of today:
>    https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=userland
> 2. SystemD patches:
>    https://github.com/jarkkojs/systemd/commits/userland/
> 
> No new issues were found during testing, other than fixing the issues
> reported to this thread. This is all feels fairly nice, clean and
> stable.

Possibly userns_set_idmap() should be cut into a patch set of its own,
as it stands as a feature on its own, and is likely agreeable part for
any possible solution. I'm open to that.

Br, Jarkko

