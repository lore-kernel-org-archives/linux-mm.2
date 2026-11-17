Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803F9606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jzh263Ql
Received: by kanga.kvack.org (Postfix)
	id A8F5E6B05B4; Tue, 17 Nov 2026 06:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67436B05B5; Tue, 17 Nov 2026 06:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C986B05B6; Tue, 17 Nov 2026 06:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 713B16B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:11:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 116F4A0399
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:11:00 +0000 (UTC)
X-FDA: 85444343880.20.98222DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 65B44180003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:10:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jzh263Ql;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913858;
	b=AfkJllqNQF+f1FT8tssnNORH743cJ6tpJ5uupZ9DQXEbGPAMVVz3gJBlxA0w2BPoqqiDB/
	DCCKL6DPBDh+cwNTVbFAOoyqDgwgJzd2NaGdzG60psWV/MEAkviXvM2LCTwngYiu424Ihg
	XW8WjttNIPjFsRmj2QssI6hkeBgvYX4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jzh263Ql;
	spf=pass (imf24.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvoI2Z2WNg5T4pHtVZggNJofexwqVtIKLoTu7i4tUi0=;
	b=Fh2tZbhQQdTK6WW5bKBQNuIAXSA3wU1x0cz5Arz/2CT0fpIt04T3uI3I0nRKbO+SOce4q6
	dUJu4dKeqm4rfh4StVARaWEgGvIYPMdBrVS5wq1uxcea+FQHxfPcrxx9btMU89QWgUAK3A
	DSv2t+7djL+K38zD/lxjyNl9MECyTKs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id EEBEE63404;
	Tue, 17 Nov 2026 11:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E7C381F000C5;
	Tue, 17 Nov 2026 11:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794913857;
	bh=dvoI2Z2WNg5T4pHtVZggNJofexwqVtIKLoTu7i4tUi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jzh263Ql3sBter/ir2vEmp5ydzrO1Ocnawrz5yyuG8H2PDbQVGRjsJXHQWpO0WGc1
	 0Md5oRqYRswExKLjJJOhnfgc9Ra9y4DdR/o+KFMDN0Dc9pwJZRZFgLkYyiPjCWvYkq
	 HWtKlatBkGAq5Lcfkr+wGDncmORVwP8qu2nxVmXzyf7USdQI+q7v9wSvOEn59jsXTP
	 TkzX70xBQ6eNPKsGdV5CZuoOp28EROPCKU1y+ni3GR6GTAk5lP4pTWXA+pVVeuckB+
	 ujIkONmElPUvhm86ckJvNb/akAMGbPgn/MU/kqFLEE6MJv3eGg8kmt5ISV5nOJSVBr
	 d/ByM9U/IzS4Q==
Date: Tue, 17 Nov 2026 13:10:54 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	John Johansen <john.johansen@canonical.com>
Subject: Re: [RFC PATCH 00/13] Namespace for namespace roots
Message-ID: <avw2PlAWYbPtZzhE@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 65B44180003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: spy86og6k7rjj91taobbskxt7gmm8gcn
X-Rspam-User: 
X-HE-Tag: 1794913858-680221
X-HE-Meta: U2FsdGVkX1/ZDtW0gWmDxBrzmiguzqZIjs+4yXYuD/sgiWnaWcZ9mj9zkLORKMyF6E+8NCG0jDZUelReo9PmV5hk5sCGmSZvKQ+7lSj3GuFNQhhh5Dfdoj5gK447Jxw1FwC3ErDWYpDt7mX/Xzek1K3SvpsX46DiDkkiphjV4BKuythpYdE/LK0MPFvQFvic6Rfp20oC3AO0hDcjjacpG0muj4ZQmnoVu+bo4tD+Pyo7X2Rue2uWYtFOhOD3usJ5FxYjyZ6tVs1etu08NBv2vy/9gaQTZbzK+Fk6tGAYCBLLmKyud3AuSHf567VuMl+HyGP5iwykRCd/gptAidT3h7etHVtu67P1yfk8qYo1yAtIjiLOU+SCNKGXfXLfXunO2Rpa55YBwXHxtEfQhfmVVeQw/R5T1KOCenzx8jCaSU6UBmNrwq+rbIt9sstHzy6BOlQ4TDJSxsd651l7zXLvHx6E65C1VEfXz41awnMT8AdtCUnw06QH88YOvCZBLhI22sHmSF9fvo0njhXAMXbRA7qac+o70qb/ZUN42Y3udN3WodB3cSdLmJoPyHRRhwolVeXVo2Ds6lTG5/mfrOa4VleR3OoABQuEguyfVLo1psmnD6FL27lUNIozK+zpUIJxZcA18FlV4q5LG6f5YZXp9XK+ow91BOHef3elgiMmTnepzUkS7iFDTukXDQtxmZV2nJe1A2OfKrXLCmh9dgF1SG+J42lBvpzAklhvXxlEzQ6jUMY5OblGTNzNRrKmv9n8InjpBUqujdRQS4UPmyR241lx/irptLOi6wkycIXBkhd8Se5MtTKV/Vs5hvCmT6s8M6V3pkCOr6LXm8FHb+a9/q1u+aWUbNQKmin678UXcryD7YEV2ucmaxWx8ABQpZ7mf5tH1RjhGky2xkljighfR5a4O8QzPGlxCnvdF8Gx/zQzp5llRjmXgEdXmI2Raenhdo1ddD7ZSaEBLk0rNL9
 bWvBCYF4
 dT6sENFZISWeg0lxoljOf/dwBQLG9lrZ/KSSVkRzSDbFkG9N/Ry3AAxywF2DIbOi+NVjXxmULqzf9X2UMM4wgZjp7PyRiUv9vK2AeA7zNBrjL4IySyfJN1lBuL1q7HoF9TS1kcFw2m+k0iYmHoMKZ1fcMNaDUH3nLMR5afz0J+tRMQ/g0DsA1OYx3m/AqqMe7DfpDo1kDEovdhala1Z9gUc2BUMF/5J3N4NSBhyVLxpJK2T6ZC4XU45L8rFiFxE4MLQwA5MGXN0hRUE5GhbNia4DDPI/UPLXzcIx1pO34sIR76ypb4QvPhmy0gmkdxtKrCEjUn+OOMFRdRu0lBi4XpSjnxnSFxuPwn8yqmHmm8OTItRPqBwjwcQdKtu9tUo5hB795IxV07EJv0PCnb5q8xNDTAJ3BPamJ+CttvQHMiMtpfBeTut37g6AAUg+ttaiCNgKyuxsU7ZRRAn4LTbBuqBETDVhwAo76Ki0FAjfXlLn3j2AiYKE6zfZzkshjpd3BChFXdnsHmKZUQHjsianBTxfXJDZc/vAYklttsUIRHOEE7Ckz62bUNOszAKbFFhr3Q+c/cDvdmvyQpIaawzph7HEKtXtSDaMdCFddp9BH0TCDrkEvOTnoawia6frTCdmkze87hZJd+btX+FX6C/ijvNmowOLZViS3NEPEfsClZQzI/Z7CG+RU0L2fiC12VNXre4dlNIYmIxJhCtiKLfss0lYCJEHvnEdDK3CB5gYtXPuigfWX8tOKhfNWbO+ES+SXUTTBdKym2So3vJPou5xFdGrKDRWLoG5Lb9KXzvyYudPDRzcrOXpdtpupwnp5KqfIA24gl4FDOLgYB4D7J2DcM8KSuytDQJmu3rWM9zE8x+vS6o9vRXQVITDfLcDM6mOiBaDu2HdhmDQn3/lCQbwA9JIdDV2PHsadrfZaNXLWkyXLv6hhRTL/wJ/pM6jQmSDVYYt4BTPT+56doyqpwx4TRXcQS+a9
 RIwIZKcd
 j3C9rUcyVyLomx8GJFhlWgHSRQMLKZeI2pf8ZZ9Z86jdGTvViWe83iggq+TMgrMm6gJpoPRYTo/wjF8+NWsESqSuz5MC1taPgddG4L5WsY1prCwSm03TL36fhnuss+AttfJsyqPSbETG38OnVWa48V8YEfNBcTGKeDYwi0Zoc+TK5i9/lclqegdklPOqMjKhqpxj+PQpMywVsiNOK2SJxt/BlFpsOVWh2xKhHbTvHi9z0W01MUT54JY5Vq3jT0lillkN7NvdlyTnapQZAYt3V6qEZq0JOarXGSZ+UQnA12/v5Hkr6rm/JB2m8/Jw0t62YKkzdumzu2FEs75kCCL56A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Possibly also:

	Cc: John Johansen <john.johansen@canonical.com>

The cc list was generated via:

	./scripts/get_maintainer.pl --nogit --nogit-fallback --norolestats 00[0-9][1-9]*.patch |  awk '{print "Cc: " $0}' | sort

Br, Jarkko

On Tue, Nov 17, 2026 at 07:08:28AM +0200, Jarkko Sakkinen wrote:
> OVERVIEW
> ========
> 
> The problem that root namespaces try to resolve is starting a container
> from a root mount tree that is pre-populated before any process is allowed
> to run, without inheriting any host mount-tree ancestors.
> 
> Work on this feature started originally in 2025 from David Howells'
> container object patch set [1], but I turned container objects into a
> namespace of namespace roots and built a new implementation around this
> premise.
> 
> In early 2026, the patch set was left to gather dust in my kernel tree
> [2]. Then, the other day I saw [3] as was shocked by its over the top
> complexity and thus, here we are.
> 
> Not doubling the number of container frameworks inside Linux kernel is at
> least a benefit over container object based solutions. Parallel plumbing is
> an inherent flaw of container objects, and it directly affects on
> development and maintenance cost of container runtimes.
> 
> Also, thanks to better scoped implementation surface, verifying rootns
> correctness is factors easier than with container objects, and even my
> early kselftest is meaningful. We know what and where we are testing,
> which is always great.
> 
> Finally, it is more compatible with pre-existing container tooling
> whereas container objects would have much higher cost.
> 
> [1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
> [3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc9095937a84@toxicpanda.com/
> 
> IMPLEMENTATION
> ==============
> 
> rootns_create() allocates a rootns object backed by a pollable anonymous
> inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
> namespaces along with any optional namespaces selected in flags.
> 
> Before entry, a manager prepares the mount tree through the control fd:
> FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
> and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullfs
> root once and attaches relative submounts beneath it.
> 
> rootns_enter() forks a child directly into the rootns credentials,
> nsproxy, and root path without mutating the caller in place. The first
> entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
> members, poll() reports EPOLLHUP and rootns_wait() returns init's status
> and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
> thread groups.
> 
> Namespaces allocated by member tasks inherit the owning rootns ID in
> __ns_common_init() so intra-rootns clone(), unshare(), open_tree(), and
> setns() work while foreign setns() calls fail with -EPERM.
> 
> Cc: linux-api@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-kselftest@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Kees Cook <kees@kernel.org>
> Cc: K Prateek Nayak <kprateek.nayak@amd.com>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Manfred Spraul <manfred@colorfullife.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Neal Gompa <neal@gompa.dev>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Serge Hallyn <sergeh@kernel.org>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> 
> Jarkko Sakkinen (13):
>   nsproxy: Pass nsproxy to create_new_namespaces()
>   rootns: Add core infrastructure for root namespaces
>   rootns: Track init lifecycle via copy_process() and pid_namespace
>   rootns: Add rootns_create() system call
>   rootns: Add rootns_wait() system call
>   rootns: Add rootns_kill() system call
>   rootns: Add rootns_enter() system call
>   fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
>   fs: Support installing rootns mount trees via move_mount()
>   arch: Wire up rootns system calls
>   docs: Document root namespace uAPI
>   selftests/rootns: Add root namespace test suite
>   MAINTAINERS: Add entry for ROOT NAMESPACE
> 
>  Documentation/userspace-api/index.rst       |    1 +
>  Documentation/userspace-api/rootns.rst      |   35 +
>  MAINTAINERS                                 |   11 +
>  arch/alpha/kernel/syscalls/syscall.tbl      |    4 +
>  arch/arm/tools/syscall.tbl                  |    4 +
>  arch/arm64/tools/syscall_32.tbl             |    4 +
>  arch/m68k/kernel/syscalls/syscall.tbl       |    4 +
>  arch/microblaze/kernel/syscalls/syscall.tbl |    4 +
>  arch/mips/kernel/syscalls/syscall_n32.tbl   |    4 +
>  arch/mips/kernel/syscalls/syscall_n64.tbl   |    4 +
>  arch/mips/kernel/syscalls/syscall_o32.tbl   |    4 +
>  arch/parisc/kernel/syscalls/syscall.tbl     |    4 +
>  arch/powerpc/kernel/syscalls/syscall.tbl    |    4 +
>  arch/s390/kernel/syscalls/syscall.tbl       |    4 +
>  arch/sh/kernel/syscalls/syscall.tbl         |    4 +
>  arch/sparc/kernel/syscalls/syscall.tbl      |    4 +
>  arch/x86/entry/syscalls/syscall_32.tbl      |    4 +
>  arch/x86/entry/syscalls/syscall_64.tbl      |    4 +
>  arch/xtensa/kernel/syscalls/syscall.tbl     |    4 +
>  fs/fsopen.c                                 |   74 +-
>  fs/namespace.c                              |  176 ++-
>  fs/proc/root.c                              |   13 +
>  include/linux/compat.h                      |    4 +
>  include/linux/cred.h                        |    4 +-
>  include/linux/fs_context.h                  |    3 +
>  include/linux/ns/ns_common_types.h          |    4 +
>  include/linux/nsproxy.h                     |   27 +-
>  include/linux/pid_namespace.h               |    4 +
>  include/linux/rootns.h                      |   87 ++
>  include/linux/sched/task.h                  |    4 +
>  include/linux/syscalls.h                    |    5 +
>  include/uapi/asm-generic/unistd.h           |   12 +-
>  include/uapi/linux/mount.h                  |    4 +-
>  include/uapi/linux/rootns.h                 |   38 +
>  init/Kconfig                                |    9 +
>  ipc/mqueue.c                                |   12 +
>  kernel/Makefile                             |    2 +
>  kernel/cred.c                               |   70 +-
>  kernel/fork.c                               |   29 +-
>  kernel/nscommon.c                           |    8 +
>  kernel/nsproxy.c                            |   49 +-
>  kernel/pid_namespace.c                      |    2 +
>  kernel/rootns.c                             |  599 +++++++++
>  kernel/sys_ni.c                             |    7 +
>  scripts/syscall.tbl                         |    4 +
>  tools/testing/selftests/Makefile            |    1 +
>  tools/testing/selftests/rootns/.gitignore   |    2 +
>  tools/testing/selftests/rootns/Makefile     |    5 +
>  tools/testing/selftests/rootns/config       |    9 +
>  tools/testing/selftests/rootns/smoke.c      | 1254 +++++++++++++++++++
>  50 files changed, 2559 insertions(+), 73 deletions(-)
>  create mode 100644 Documentation/userspace-api/rootns.rst
>  create mode 100644 include/linux/rootns.h
>  create mode 100644 include/uapi/linux/rootns.h
>  create mode 100644 kernel/rootns.c
>  create mode 100644 tools/testing/selftests/rootns/.gitignore
>  create mode 100644 tools/testing/selftests/rootns/Makefile
>  create mode 100644 tools/testing/selftests/rootns/config
>  create mode 100644 tools/testing/selftests/rootns/smoke.c
> 
> --
> 2.47.3
> 

