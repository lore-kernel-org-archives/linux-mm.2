Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864EE60A261E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eHGDS24t
Received: by kanga.kvack.org (Postfix)
	id 8645C6B05B0; Wed, 18 Nov 2026 14:54:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814FB6B05B1; Wed, 18 Nov 2026 14:54:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7045A6B05B3; Wed, 18 Nov 2026 14:54:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3978B6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:54:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E7B7160896
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:54:34 +0000 (UTC)
X-FDA: 85449292068.20.049C148
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E24051C0012
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:54:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHGDS24t;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795031673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOMAgC0XvS4nP90YCQcBU0h+fNv/5Kz+lJp/v4CzlRY=;
	b=qqKf+yK6QjsndP9rLcmnFGF7LRE+bGdgMNxFgT1JbBkDUJzO4zIH4F9KNQzt+mmbKIF8sR
	i2WCaU0u0Ul4jmwFwfLVdmGGucyF/WGcOJPaMDMihArpd6lhj16S39ykv9B4uAGYZfjcZb
	dfSD4fqcF2FWpYiBxPGmFsLRPFiewuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795031673;
	b=d0hrho8GyaU2V8fUV5jRN6RJr5vtbDJ7WuQxM0vzsK8JZ9H8blxIpZaBjJIzliLwlwoCxc
	QYNPWdvxnS7UwvvtcVGOrjETsp7ul3+ovnGZDT7uqdbLPbv/484hJsL5ETiSm/DIHCAHyU
	ByycyTG1z3ouqfYUa9txVxDUkjqYltE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eHGDS24t;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 14C4F40A61;
	Wed, 18 Nov 2026 19:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 409C51F000C4;
	Wed, 18 Nov 2026 19:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795031671;
	bh=dOMAgC0XvS4nP90YCQcBU0h+fNv/5Kz+lJp/v4CzlRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eHGDS24tKkdUdQSDE+m8Q9U7FzbKLF5B1bDQj4MZxp+NpFTpVSXqOqxZkSbRrYUCu
	 xtJKC8BPP86kLhKQWSGTmh00sX0NKvq9TjDCRYonSH8rUaaTLB11cllHumX66RUYyH
	 ScOEhGBFrGL7aznIPo29PaJXS63D224351P4tQaIaa4C2w33oRPpGvjOVaJF1GWXp0
	 yn3LJKcQWVn44OuzVcIAi7Xe0ILvDdblzEOdRn+tnrG+OFiaNe8nBeMUP2hyUdRH6G
	 ezABsk4drujjXkdYoPEJuXtySKLyTCVIg2d2O1x+lXwN8EOL9gzFhw3UcfphSBmKst
	 FR/hJTy4y6ubA==
Date: Wed, 18 Nov 2026 21:54:28 +0200
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
Message-ID: <av4CdM-eW73oO4wB@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E24051C0012
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: fkyiracqdn1nsefb6xmqsox37pithn68
X-HE-Tag: 1795031672-513829
X-HE-Meta: U2FsdGVkX1/StBAfAPw4A674LHLU4xdYA/Q4KqJKpdz/quc4DcfgAdlfSOPtyEC/5OWzUQK26Ibhxh7IrsFTflTkDVDxOt7ka55xcEYs0+us4S4MoPySFdhuWAReHC0XZDh7QXX2xlzCaJKRNUv+V9PyDmfKXixGrrOx0oeKpg4Q2q6HoLvTX65lJ6buQTuZP9eJ2Up7jxGOcRz5HG9QKIbiTaIGMCXpoSbqIq1FmYwblMPVItJh1ZMdGvUm8yjzaKt79k72rSOwmXFZ6DosvRYaCz5Tib/I9HJyRxrOYU7JQ8Iy2+/uMhNp9gTOluzNPPXjulldx6SwPinhjSsNUxGHovK0o+amt2Y5nvIsmxG1JrIIUR+1ZF8c51qbxccXFB0jpWC5maklWeX0bU5nhTOf3Dop85GiRT4AihgAdaRla96pFGYur0QuIrfDixc7sK7Lu3Jr2a0HYCNgbWqOmp8RfuJOh3WJilR2O2YwTrt8MajBQ8rpxSbCY9N460HtJjFur0bb/KrdeOlm//IvrtdyDal91su+uQ7cWL6owr8waj3f6r9UbON7wKZ87O7EOyTAm5hCtgSyf26xuRdX/E8a5+gDhzk1Pa+WAa8vEQXnMsZIxPLLPiS6tCIYzIqvN0faaETc+uTJS27lUZL8+dhrR3Gjp6kMHQwmaPIQDa+NPEum0JGYysTJLjMQQgYPA/kKOjCaPcGERqV66Iht0E85hzOt59jDEWv5pfm5dk6TpJ6ctmacxRU3oiDBgvHvGhV9uGCGBLyW/gQ78YFPe/kvFG1r0Rw/NH652Gz0ND6S6w7yfRck3eFEc9mmZmSxb4xPTmyvvWI9NsgjmaCOyWXSl/ds4Oy+7pNfRd5W7QlZ/yCirkp++fkotinPqMbUt6ju7kFXI2P/zwLS9Xfz7b0WH6KqSKMezC7R/+fVTfw/aV3+KwYoixlVF9N485gsLsx87us5PXhqwtd6ZNG
 N1OWmzZ3
 WjzLUryzcy//+ZkidQOJMoU6IidQvNSMu3J1x7fJYPviQ2BAiSDA37cAsv+7ILyNJhWVLqsIUjzjrD/mP9qT8qj5TNFHwYPR59qu7rAqARrfI2bc774qDKbeKy1m5KVlbALe0AKl0epn14VGXHzgLj+MN1ty53vM673txZ1z91s4dbDd2jzlDZ7h1AZgcSTEHj/M9Wp8UcePrOvFqnqzIQdfSo8OD561ieAIXGPw4eD/uPzWnnBv5Uwx1AWepfDRkj9BxDC76NdRMnFIGirjmxS1QW9vccxl6JQp+B7I2fi3k6Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 09:35:26PM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> A root namespace (rootns) is a kernel object backed by a file descriptor
> that binds together:
> 
> 1. A full set of detached namespaces owned by a fresh user namespace.
> 2. A dedicated PID namespace for spawning processes into, signaling
>    members, and polling or waiting on PID 1 exit.
> 3. An initially empty mount namespace (CLONE_EMPTY_MNTNS) populated
>    directly in its target user namespace before going live, without
>    inheriting host mounts or cloning staged trees, while still allowing
>    new mounts to be attached at runtime.
> 
> Work on this feature started in 2025 from David Howells' container object
> patch set [1], which I turned into a namespace for namespace roots and
> rebuilt around that premise.
> 
> While the patch set is manually written, the original motivation came
> from isolating LLM agents. Running untrusted agent workloads made it
> clear that OCI runtimes need to minimize their live configuration
> surface.
> 
> Assembling mounts, credentials, and namespaces inside helper processes
> with a half-configured container is what I see as the main challenge,
> and the existential debate around namespaces and container objects is an
> unfocused discussion topic.
> 
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> 
> IMPLEMENTATION
> ==============
> 
> rootns_create() allocates a rootns instance backed by a pollable
> anonymous inode fd, creating a fresh owning user namespace and a full set
> of detached namespaces: empty mount (CLONE_EMPTY_MNTNS), PID, UTS, IPC,
> network, cgroup, and time. ioctl(rootnsfd, ROOTNS_GET_NSFD, nstype)
> returns nsfs file descriptors for individual member namespaces when
> standalone namespace operations are needed.
> 
> Superblocks are configured directly in the target user namespace via
> fsopen(), FSCONFIG_SET_ROOTNS, and fsmount(), allowing unprivileged
> callers to assemble FS_USERNS_MOUNT filesystems without holding
> CAP_SYS_ADMIN in their own user namespace or entering the target user
> namespace first. move_mount(..., MOVE_MOUNT_T_MNTNS) operates on any
> non-anonymous mount namespace fd: on an empty mount namespace it installs
> "/" onto the nullfs root once, and it attaches relative submounts both
> before entry and into live mount namespaces.
> 
> Once "/" is installed, processes are spawned into the rootns via clone3()
> with CLONE_INTO_ROOTNS and struct clone_args.rootns, without mutating the
> caller in place. Pairing CLONE_INTO_ROOTNS with CLONE_VM | CLONE_VFORK
> and opening the target binary via openat2(..., RESOLVE_IN_ROOT) on the
> retained "/" mount fd allows spawning with execveat() without copying
> page tables.
> 
> The first entrant becomes PID 1; once it exits and
> zap_pid_ns_processes() reaps all members, poll() reports EPOLLHUP and
> rootns_wait() returns init's exit status and rusage. rootns_kill() walks
> pid_ns->idr under tasklist_lock to signal member thread groups.
> 
> CHANGES
> =======
> 
> v3:
> - The patch set size increased predominantly because the coverage of
>   kselftest had to widened to cover the introduced changes.
> - Replace MOVE_MOUNT_T_ROOTNS_ROOT with MOVE_MOUNT_T_MNTNS targeting
>   mnt_ns nsfs fds, and add ioctl(ROOTNS_GET_NSFD) to open member
>   namespace fds (Andy Lutomirski).
> - Allow unprivileged fsopen(), FSCONFIG_SET_ROOTNS, and fsmount() to
>   configure and mount FS_USERNS_MOUNT filesystems directly in the target
>   user namespace without entering it first (Andy Lutomirski).
> - Fix locking, refcounting, credential/dumpability/timens setup,
>   pivot_root() lookup, and cross-userns mount checks across copy_rootns(),
>   CLONE_INTO_ROOTNS, rootns_kill(), FSCONFIG_SET_ROOTNS, and move_mount()
>   (Sashiko).
> - Mark PowerPC rootns syscalls nospu (Sashiko).
> - Update documentation and kselftests.

I.e. before PID 1 and /proc/<pid>/ns/* existss, nsfd for namespace other
than root nsfd can be acquired as follows:

	int mnts_fd = ioctl(root_fd, ROOTNS_GET_NSFD, CLONE_NEWNS);

Br, Jarkko

