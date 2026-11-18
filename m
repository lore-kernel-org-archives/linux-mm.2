Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 762B7606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ml+aVGKv
Received: by kanga.kvack.org (Postfix)
	id 586566B05E3; Wed, 18 Nov 2026 16:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5351B6B05E4; Wed, 18 Nov 2026 16:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424C96B05E5; Wed, 18 Nov 2026 16:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06A916B05E2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:22:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 884421C429C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:22:58 +0000 (UTC)
X-FDA: 85449514836.21.8653CCB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F35D512000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:22:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ml+aVGKv;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795036977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqtZas3t5wXmBF7qeLP24ETZ+NnHhg0AAw7WUrgO5/M=;
	b=QKfpsYDud5uJ7THu7R5KQ9Ymwd+WD3MQyAR8mqN/+Pq8tl+eBfapnP4uTb2yG0SyIF/W3M
	JjR4awo+l07valJZSxX+apsfQjC3pi1unJXzVtvlQbt1w+hSd2Z4Sgdv/voAbNyZ8ybfbr
	Di6O+57QuSPEMN+bZ9DWIePvC3MJB98=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ml+aVGKv;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795036977;
	b=R/RzOLUlBcspj6HxPkt/qIJnJ3d9vn84uYnI27skHiTNL7B8S1sLjEGwuGoimOV4O8Kdrd
	k7QxtE2gf/uQIcVrWW0TOrXV/+kX8BenutyVn47emEs47KjZ/Y6unR3slgCEZxVT7i1g1p
	Q83E2ZutlI5WAYAaYlTWqN2pzc+yMCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 78EDA63E2F;
	Wed, 18 Nov 2026 21:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 733A41F000C4;
	Wed, 18 Nov 2026 21:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795036976;
	bh=vqtZas3t5wXmBF7qeLP24ETZ+NnHhg0AAw7WUrgO5/M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ml+aVGKvvIC5pcrzx9ZzwGHLtrNZnut1ESXjSEU2HVNx6KxFl13Zr+qffUFbbPCwW
	 V83mH7Py3EnQBPKdeQ6gpt7TyHQQlg5bEPLKqrq2wu1xjOrLWufishv37LqIoW8BFs
	 YQp1QvRsDrJQWGENlrzay8K370ntnq0LSRLNiftl+fd7XrzLs8QDVSKZwPJ3ElX+vi
	 OjP/miHHrlWI0I0NTP6aPNfvZ2Uz7sgVwWjL+HOqy7hVzjmWfdLN31G6Jok2wePmbd
	 RziLHmPCbpggAo4Y/HUC9dK4Gjc1b5IRHx6l3+MHzVFmMxy1ndqJ3CxDspiyEHOVVd
	 1GWZ+a/AyLQMA==
Date: Wed, 18 Nov 2026 23:22:52 +0200
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
Message-ID: <av4XLJcO0y8CbGT-@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
 <av4CdM-eW73oO4wB@kernel.org>
 <av4NonrcCxzMoDyz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <av4NonrcCxzMoDyz@kernel.org>
X-Stat-Signature: xb6pd8qet43sdemmaawd58sa7fn7x6bo
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F35D512000A
X-HE-Tag: 1795036976-839163
X-HE-Meta: U2FsdGVkX18sT1vK+ckuLzWUpmxOkzIMTePRMDbyMtddyShst2O48NBW8lUhZ1CmZ2cNb68zS9TmjRQWwzBxSUaViWEByR7I5+vZ4cFbvvVUW5fTStay6mX9NiaCwzsRHc5xzT52MuoRaWkMlgcOAY+BAjGR/3mGAD1DReudslKGwqHppjBFnSlX09OutaF3gj/0E8DgT8PT8PsSKviCwYRSac31uUL57o9/ncQMMzRl2WHsbyUhlNmoB82YlzrFCNxL/dkTSwgpzvguPBDmHRszIyofZmT2M8G2t7gKTnpD+HFAzqgqcjexqL5irk44iw8Awmgaw976ssCOnBEw8CGOYTDOTEMr4uVNRzR6akaLegscC9wFWjnIl9sIAcN/FYJwyESramWxJZ5ECDfKjyqWpJDfCJmHpDzW5erDOFxHWS4OVj0YbNG7189hhDhooKh9XXhK7aD/rSqzEDiJiVD9QSOyYObXjJvxqdBZAmec7a00iVa5JqGPoYHIAo2oYf8jMFxQtTMEQWRSnHrfjZ23QFXP81bxVvGLtPHuDnMimPtDkZQmhgIo1AJq3ceBV8MEOP5A6RIw2M8cRq7bR5e9MHoHfCDUtUPIAqbG9VOHexfyksBXWPm1nIRkWTxWggaF1rdl53Q8v4rvsx/l2+TztcY/S1uN40/IV5o8Y87+rilHa1YUu24iPybyoWxnuT6eAaG73NMH8Q6p3DoaY6YcJmD78WsvVQZJL1buwFvn0NItzPdSoVJKKHFZ59oH9yAyVGJ6bUzeM4kQuu1+sIyJ2Dav5KRymw7FrV4+w2zddmlm+nGd4cQBC5oyhKb2wGDzwAJ0lyg1O5UgdwLPl+oC7Fjlg4skf3MU3szl54UfHEWUk5oXVTUcGoOTRUtu904MVcTrIQfOhV0RTfTRpPrv/jOMBy24BSrV0e64V1UQGctEDOvnpSF2fRO0OHFUK3XeyuQWSlYWk1OdYFR
 z5RSDMx+
 /LqgRGWSKfl80y+LU+O5DuhjyfZEayhDLJ3llpZM9Z1p5VoajrR11WDBrbrpfIYluZaea3kLhrQaNgY72gjhNtfVNZeMV8+zUj1Ai5bYS7+MK0Wtu0xY6An7qLttQHjHyFlRhHzvaSLPFOvdNl1XsEnpMWWJQCP25lProPj5gAx2zMoNelG4cIw2PPiaV74Z0dZ1zA898z12SkSlOKhyJTsfMH4b7havWYxWonqiEJy3iSlpuTZ5QR37gAe7glwj2sLP1ljTtOlw+s2cTWlh0LCifEJCXDVWi7ynG9Yn2HYCsmfA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 10:42:15PM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 18, 2026 at 09:54:32PM +0200, Jarkko Sakkinen wrote:
> > On Wed, Nov 18, 2026 at 09:35:26PM +0200, Jarkko Sakkinen wrote:
> > > OVERVIEW
> > > ========
> > > 
> > > A root namespace (rootns) is a kernel object backed by a file descriptor
> > > that binds together:
> > > 
> > > 1. A full set of detached namespaces owned by a fresh user namespace.
> > > 2. A dedicated PID namespace for spawning processes into, signaling
> > >    members, and polling or waiting on PID 1 exit.
> > > 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
> > >    directly in its target user namespace before going live, without
> > >    inheriting host mounts or cloning staged trees, while still allowing
> > >    new mounts to be attached at runtime.
> > > 
> > > Work on this feature started in 2025 from David Howells' container object
> > > patch set [1], which I turned into a namespace for namespace roots and
> > > rebuilt around that premise.
> > > 
> > > While the patch set is manually written, the original motivation came
> > > from isolating LLM agents. Running untrusted agent workloads made it
> > > clear that OCI runtimes need to minimize their live configuration
> > > surface.
> > > 
> > > Assembling mounts, credentials, and namespaces inside helper processes
> > > with a half-configured container is what I see as the main challenge,
> > > and the existential debate around namespaces and container objects is an
> > > unfocused discussion topic.
> > > 
> > > [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> > > 
> > > IMPLEMENTATION
> > > ==============
> > > 
> > > rootns_create() allocates a rootns instance backed by a pollable
> > > anonymous inode fd, creating a fresh owning user namespace and a full set
> > > of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
> > > network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
> > > returns nsfs file descriptors for individual member namespaces when
> > > standalone namespace operations are needed.
> > > 
> > > Superblocks are configured directly in the target user namespace via
> > > fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
> > > callers to assemble FS_USERNS_MOUNT filesystems without holding
> > > CAP_SYS_ADMIN in their own user namespace or entering the target user
> > > namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
> > > non-anonymous mount namespace fd: on an empty mount namespace it installs
> > > "/" onto the nullfs root once, and it attaches relative submounts both
> > > before entry and into live mount namespaces.
> > > 
> > > Once "/" is installed, processes are spawned into the rootns via clone3()
> > > with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
> > > caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
> > > and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
> > > retained "/" mount fd allows spawning with execveat() without copying
> > > page tables.
> > > 
> > > The first entrant becomes PID 1; once it exits and
> > > zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> > > rootns_wait() returns init's exit status and rusage. rootns_kill() walks
> > > pid_ns->idr under tasklist_lock to signal member thread groups.
> > > 
> > > CHANGES
> > > =======
> > > 
> > > v3:
> > > - The patch set size increased predominantly because the coverage of
> > >   kselftest had to widened to cover the introduced changes.
> > > - Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
> > >   mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
> > >   namespace fds (Andy Lutomirski).
> > > - Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
> > >   configure and mount FS_USERNS_MOUNT filesystems directly in the target
> > >   user namespace without entering it first (Andy Lutomirski).
> > > - Fix locking, refcounting, credential/dumpability/timens setup,
> > >   pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
> > >   CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
> > >   (Sashiko).
> > > - Mark PowerPC rootns syscalls nospu (Sashiko).
> > > - Update documentation and kselftests.
> > 
> > I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
> > than root nsfd can be acquired as follows:
> > 
> > 	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
> 
> Unprivileged caller becomes the owner of rootns->user_ns. Each mount
> syscall then just checks CAP_SYS_ADMIN against rootns->user_ns.
> 
> The user space wiring goes along the lines of:
> 
>         int root_fd = rootns_create(ROOTNS_KILL_ON_CLOSE | ROOTNS_CLOSE_ON_EXEC);
>         int mntns_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);
> 
>         int tmpfs_fd = fsopen("tmpfs", 0);
>         fsconfig(tmpfs_fd, FSCONFIG_SET_ROOTNS, NULL, NULL, root_fd);
>         fsconfig(tmpfs_fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
>         int rootfs_fd = fsmount(tmpfs_fd, 0, 0);
> 
>         move_mount(rootfs_fd, "", mntns_fd, "/", MOVE_MOUNT_F_EMPTY_PATH | MOVE_MOUNT_T_MNTNS);
> 
>         struct clone_args args = {
>                 .flags  = CLONE_INTO_ROOTNS,
>                 .rootns = root_fd,
>         };
>         pid_t pid = clone3(&args, sizeof(args));
> 
> Note that example is uncompiled :-)
> 
> This example makes me feel that perhaps RootNS is not the best possible
> name for this but this rather should be e.g., NullNS?

Before judging this, keep in mind that I've not just suddenly invented
this. I first encountered the topic when David posted his patches, and
felt that they were a bit unfairly judged.

Somewhere at 2025 David rebased his branch when I asked, and slow-cooked
the result that we're seeing during a period of 1.5 years. It has not
been a priority topic at work so this has been more like a spare time
sudoku.

So if you count the David's original patch set version, this has
history spanning since 2017.

Br, Jarkko

