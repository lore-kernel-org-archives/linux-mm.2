Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E51606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HOD98SOo
Received: by kanga.kvack.org (Postfix)
	id 822BC6B05B3; Wed, 18 Nov 2026 15:42:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8D46B05B4; Wed, 18 Nov 2026 15:42:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F1E6B05B9; Wed, 18 Nov 2026 15:42:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3666B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:42:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D516C12089D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:42:17 +0000 (UTC)
X-FDA: 85449412314.29.C4AE491
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 409378000C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:42:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOD98SOo;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795034536;
	b=UFUdiDaoXFd1UtHDbdR+GZ+nDNj6MySXDU2uJd+muLY11/ZQ1dpV0R3IaunWDazuHLKfha
	pn/KOlzkGnLdGdmHNsjnV9XhkBGR4YVgXu6Sulm7kmOEF3BqHNCv0KJxcDFEiW3UWevgb2
	oY2DCMHutQGqCyLPTUbvAeCcZ80mwZc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795034536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGYFAZyPSCRNjDclcP1I3y+zEfg7NXEfs5NTufJGWEA=;
	b=lxocp7lf0dt+41g5q2Kx+c6ptRwKzRnjS9H5b7wnt1BnBK4YYZ4iF/rGod7Kb+z/Fv0DOl
	Bz1n0MQV28Pr0KhcDuYw0KsZ+ui6G4tivTgpQH8vhaZmmWa2SHJ+XCU/QEaTHY7BCVze/Y
	00vtT3B5I8mHrbTt+aej8wpLRXR/RuE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOD98SOo;
	spf=pass (imf02.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 0B70863BDD;
	Wed, 18 Nov 2026 20:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 04AA41F000C5;
	Wed, 18 Nov 2026 20:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795034534;
	bh=yGYFAZyPSCRNjDclcP1I3y+zEfg7NXEfs5NTufJGWEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HOD98SOo2y7LisIyear+vmT71uL7GcKw4TOcb4yz+HJhLShq9FVnXgPGBj0IeH7nB
	 NkHXUPLZ6DRpt4YwIsK/2RvI8yv0k+FRz+5enF8Ej27HdLMrk4C6B2ytR0+pLqQK/z
	 oMprkQ42FVzf6Xihen6u2RRCEMBBDP6MuBmjUaMjT1cdjCXVhnN+aewx89/JyIs4Gi
	 z3B+N334YoohR8XLQNcnWbDUIliIcKGMIxLBPHjkMAQHHjbscX63CQ3tBhM7+cFll9
	 GoLv7GUXN2rPT8+o/rRkgW8EvF037oveTAIM4TQRC1KdjuJH1V1Z49qgse9IJGO+tp
	 XSe3e2bfxSr/A==
Date: Wed, 18 Nov 2026 22:42:10 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
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
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>, Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Neal Gompa <neal@gompa.dev>,
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
Subject: Re: [RFC PATCH v3 00/13] Namespace for namespace roots
Message-ID: <av4NonrcCxzMoDyz@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av4CdM-eW73oO4wB@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 409378000C
X-Rspam-User:
X-Stat-Signature: mqx4hpekaxsmfjco6mf5hrocknm39or5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795034536-114459
X-HE-Meta: U2FsdGVkX1+jGrotWbo3K9ZQ8XmFbdMZ2lB2uhN0Pg7460C0WNLojSa88vglN84kn4GzXr1WBZXODBcCOcsLguv3WTTicdxvYX/RV6xQl5pDIewT58OrNxwStXvhHe61vAJK0C6zn9/+Q++INIqLx6qW72Sp6zKJxXiiNX/UpkikRUA1/roTOjt5I6XRWFhzJwa3LuSVMt72oVVW6B/KTVXJkPjKsKYONvwtobEwbPGIS2AAOEIneEULFTPJ3/rwwfRHtvRU/eZ18rfD+TvBBIaubteaxPX8+FDBNkajrnmUahzymI7NHYXkcdL1AhMxcNvfBhjMBtK9H9KTdNKMtNmbhkBd4p3yYKd4+470B/kwubP0R53iIVfbwcUw4dQWbMtMOzfcz9orAP1qhFIXoLrKZTmFsri/VmavFMMZtO7Uv5nKvpNHpstRurUsBEDFT62vc2zibROXUkHbymIHJf+0K3wNfESXFwTwUjdex+BzBJa0Cl8Stdbqyp863vdjWSlvCS2plfKD7B6z0CtEz6Sw+An2EvnX6w67zyG+PQAIPKQ08ttLOKUuVJGUll8WdKQbvPq4TzOX8czHrkbJtHuSOu9RrGijKk4k1qdGLgBa37fwn6Mo3nN+WLABdKMGxOXo08KdJJj7Lg1cHFeJ+36KdQk1FMS7HMywR40D5RZ6swEbzNSLiFTWcG4qOQRM06yJNS+y11+ktCN7zTkvJmsilOCWfAere14h2+25FjznuTQK9kiS2qcGGAiKHFKAdM0eZGlC5WIB3WKAtmchc5g4WbzRupM5o5jt26JIQVz4J5Onry4rOEysWQujdeXbzlDUkwRbVA5sTcALzddqYalroIQmBhfR+t1zEVt6t/Q5EpWp+h1yjGpkKtzlvQALWqhZ/Wrx//NxS1f6F+iDtZ5JKdVQ7QMKF/6SySm6lQoGmYe0rCoDi3ouh6m6JvytsrVxkp+TLBCeFllsLsr
 IZnmOw+T
 xHXj0kxqDHo7Kyxsp5nPwdC+EzQv0fN8PkC8ldGFgp9EZ7GzR5RBwfz4di+6T0wrRv8HTiM878oZHgoz5iQiNOOyX4U04P3468pMVFkM47HxfdUt/BpzVGhc/nzLfMuh/QCfUWcfQeQgswAQPQ2zy3ymYig8ywAs6kmgUEEV66acQLtUYzJHzyxiv2VKTNDXysTxEPTlPkUhBabxyZOimqsNv4CDCMw9fur+8uE6BESN2QuYhjpfBHISRYVzzsTK01xucdHCb9+O4L8jPvED8ycV2EyZRkcQVUZmvPxVsoA9XPQkPfm6UWlNgXFCtJn5gH23I5UOhcAB3SC8HUOe39gExB55zO6w3waXdbLekP7AZRCwTU+uKNM70S1oks9WGZUnjSCKbIBHHcfmrR3iZC6UbnZHKOymvOSAB1zmZl0Y4Rzf6snce2Qt19UkZVuuk/bp9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:54:32PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 09:35:26PM +0200, Jarkko Sakkinen wrote:
> > OVERVIEW
> > ========
> > 
> > A root namespace (rootns) is a kernel object backed by a file descriptor
> > that binds together:
> > 
> > 1. A full set of detached namespaces owned by a fresh user namespace.
> > 2. A dedicated PID namespace for spawning processes into, signaling
> >    members, and polling or waiting on PID 1 exit.
> > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
> >    directly in its target user namespace before going live, without
> >    inheriting host mounts or cloning staged trees, while still allowing
> >    new mounts to be attached at runtime.
> > 
> > Work on this feature started in 2025 from David Howells' container object
> > patch set [1], which I turned into a namespace for namespace roots and
> > rebuilt around that premise.
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
> > 
> > IMPLEMENTATION
> > ==============
> > 
> > rootns_create() allocates a rootns instance backed by a pollable
> > anonymous inode fd, creating a fresh owning user namespace and a full set
> > of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
> > network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
> > returns nsfs file descriptors for individual member namespaces when
> > standalone namespace operations are needed.
> > 
> > Superblocks are configured directly in the target user namespace via
> > fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
> > callers to assemble FS_USERNS_MOUNT filesystems without holding
> > CAP_SYS_ADMIN in their own user namespace or entering the target user
> > namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
> > non-anonymous mount namespace fd: on an empty mount namespace it installs
> > "/" onto the nullfs root once, and it attaches relative submounts both
> > before entry and into live mount namespaces.
> > 
> > Once "/" is installed, processes are spawned into the rootns via clone3()
> > with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
> > caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
> > and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
> > retained "/" mount fd allows spawning with execveat() without copying
> > page tables.
> > 
> > The first entrant becomes PID 1; once it exits and
> > zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> > rootns_wait() returns init's exit status and rusage. rootns_kill() walks
> > pid_ns->idr under tasklist_lock to signal member thread groups.
> > 
> > CHANGES
> > =======
> > 
> > v3:
> > - The patch set size increased predominantly because the coverage of
> >   kselftest had to widened to cover the introduced changes.
> > - Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
> >   mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
> >   namespace fds (Andy Lutomirski).
> > - Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
> >   configure and mount FS_USERNS_MOUNT filesystems directly in the target
> >   user namespace without entering it first (Andy Lutomirski).
> > - Fix locking, refcounting, credential/dumpability/timens setup,
> >   pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
> >   CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
> >   (Sashiko).
> > - Mark PowerPC rootns syscalls nospu (Sashiko).
> > - Update documentation and kselftests.
> 
> I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> than root nsfd can be acquired as follows:
> 
> 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);


Unprivileged caller becomes the owner of rootns->user_ns. Each mount
syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.

The user space wiring goes along the lines of:

        int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
        int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);

        int tmpfs_fd = fsopen("tmpfs", 0);
        fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
        fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
        int rootfs_fd = fsmount(tmpfs_fd, 0, 0);

        move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);

        struct clone_args args = {
                .flags  = CLONE_INTO_ROOTNS,
                .rootns = root_fd,
        };
        pid_t pid = clone3(&args, sizeof(args));

Note that example is uncompiled :-)

This example makes me feel that perhaps RootNS is not the best possible
name for this but this rather should be e.g., NullNS?

Br, Jarkko

