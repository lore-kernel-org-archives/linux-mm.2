Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B931C606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LEczq6rN
Received: by kanga.kvack.org (Postfix)
	id B64476B05B6; Tue, 17 Nov 2026 00:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15956B05B7; Tue, 17 Nov 2026 00:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04716B05B8; Tue, 17 Nov 2026 00:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 644E66B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:08:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2735A0117
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:08:51 +0000 (UTC)
X-FDA: 85443431262.18.2313487
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4C29D1C0004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:08:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEczq6rN;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892130;
	b=d3f46EJZcqem6G4OdsYT+cGiyUuaeDYIQcp99K7j2AG8LSyRrHvh+vE6zu5bau7I4NBl15
	K6gc4E7kgPngZIqCSe1qKqf5XMYU/Q2vPnM3lyzbquVbGs4MgtJp3I5FCxyQuPvTwJhyrn
	exowTnTLZcvyqzkb3MGlKhO86UgJCAk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEczq6rN;
	spf=pass (imf20.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EHOaglGu01L1Blez6rThdkeRSDoeQsisrNfdJmtnDfw=;
	b=1v54Ju0YKvl1Ne/+T/IkG8rq5ho7LFNO4ARwbIQLDFncTDNPeQNWTh0CnMNlaiRq3W8Z/8
	k4+HM3sK5JURKogOiGVVU9uvBZaU4pfE4jCTFBTktxq6vvM5kGk/IrnnfgJvYY0CELD0yR
	t9MJyoyIkyhKeuuejP9EjsEczpmryk4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 6704A447F1;
	Tue, 17 Nov 2026 05:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9A8CC1F000C5;
	Tue, 17 Nov 2026 05:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892129;
	bh=EHOaglGu01L1Blez6rThdkeRSDoeQsisrNfdJmtnDfw=;
	h=From:To:Cc:Subject:Date;
	b=LEczq6rNDD7/cZElMucuSr8e9ue2aG8F06dN2crHVgmE7ZPKTXCa7tv+Xg5QuIC1J
	 xycva1j6I8rXKchoZy3SblemaCtNsHXPwWgLGsMfvy2S7ruepM7D9KUXZb3ny81NGO
	 8MWnS8r6SViQfto5mHPABF2iC4OAlQrjDCB5zp419SJcpQ7hahNnNMbEUgldJL4Sh+
	 jTOhvPMAcTPyM9Y06iGqVZ+rZ6hRsJ64zi9p+dcXKE+v0MQHVcM8BEmJQRU3B908Jr
	 q+vVswDXYKILSq1zDUtt96nII0FBEln74u0FpB4+9SWdxzNO3xNNvb+h0dlWA7d60E
	 7EjJRf+RRy4Uw==
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
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 00/13] Namespace for namespace roots
Date: Tue, 17 Nov 2026 07:08:28 +0200
Message-ID: <20261117050841.3289652-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ouqjsedjebk8wh7zhk8j6fg57tukcp1z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C29D1C0004
X-HE-Tag: 1794892130-350447
X-HE-Meta: U2FsdGVkX18eqUe2LymWhqPFpQ23+A21/S2fC9REBWeoQJZ8D9WOppiYQpL08fTinFGhSmnVwTO4OH0T9IjZEPgpXjUJrnZm3yocC8pSL+kLcWRgBhfr6u7kK6pTvGR6mE5RJfLPHxJOP7byV5fQ4YXVF78Y3toLW6+8uZaY+t18pTG9qQYVuHBNmX/ZiHKU7DfRskU5XT9f67g2MAOlRiKtFWwO9sghnw/Ocy5fpa9bo48iDRSCh/xkt1d0ZzH50sUNUBfWYlvrRzjnS8Rz7j3VO3vHCunbuv93RxeBKXtkSONEIGATHFlxcjHPf/27XOo5uSy/6/fk0+FJ7WQqJKHRw3+PGN1AS9zud/p+ubRLxwKA+mAOWTNhvYdCd9IV54bhKnczlOmrdqPbZLLDCuAuLw9T+yjWLELfNswFyP7LWjjyBmxiuEvuFMSQZ2ferW6ivG3tQKCD92/Ww5aDy4+VD+g0H15R3XOv+HkEmHeCH1rJQM+Kr1ImoqeRX5ycx+XrqJL4+w6WBrxwmx3WuRZtePym6iK3KzqzDE/Z8AEOhTen6+e01FxKHR5NuLmH93u1MURGbz7Y6AaYgW2qhOI/LDmqBju5bu9jCLJ3jJLKqGk89o3XQH0eLmUybXMNHCYeLxpDd5Pwv5NBVCVP3Q7kSrn16oXTI19mXdd2oemV9xF7FcjdEBuss5k8/em4ptvpwF4rq6i8/pKVhovgmMiAfdixE6G/IPEmuz7umuQbFLOzZCCzyMs92kOzc4CGtWW3eMcKS6yLZ/ZU7OtVCHH5Y3Oul1nwfWpyVUmmdjp7DD/KCEw3G/5OcILaR18FGX+eDSK9yG7Hus1lnlAckhoHNGc685pnMikOpzhcMKb2l168Xc82WAuOzyho7nwl41a5lINM62wQu0FTIxvnYb5pOKVA5a7LU90QflT1aobnGl20XykOKhCkKBaipnO3PJxdYTJKwdC9SRSV3mW
 CVzuWTGW
 uzLVag4pd0smMoCURWFnwAZ48LiyCBU82TTyGtcRVoGxq8UFqEN2kkwY696CfVPN90c+6hfm4hn3N0J0Z6Vc5uBR6yEhtgOj2IvwdgF982qJIPq0ban+nuVpa+f/GUwdkgfKn+IubzgEPA5hHDVlHNfYuivDO1tWLsXs1+HoH+jWp60Le/FGzMXOG3Xl+uPdYFAl925uI905bdPEC5MVVjK6/FFXP/kq/J1aI27X1lcpywuiv8PIynNSYdj3fwUlfMogiudjMTxv1hl6tedAnYUBvq1Rcl47paZTIQjRevutOlXiIOBb/BfedJ9Y5keBIuE67UUB0CuLoD4XMt0335OJyYoj/sMgSqiituPSVmfaRfvfLgKdhwkuSs65SpyQ3aZn3KPnJgkSQzLzT3Zyu3HgV0+DMGJCTf8Al+Vwgoanl1UDKJGGuRvlj+IyOU0dZImcimDHgCdPPnLh0KrQ2n4xn34n4KE0OGyXC14uH5fC7aDZ2NPPMKGVTq8kb2Qz1gz68uxzBu0fiYiVipLdYZ8uTiZFkbijvwdN7AELsaeUgOtpFZ1XshvqTV2AmlxrY7mIHzaniS7FUX3R4Pc60Ymzcmoj55z+UyrTQdkoNjWhE842bUGByLD+l/FYfk54GvM6rWApphruCE3bNCa+aiNVTepNJ922/cV3+EQtCgUxCBzD1hqKn1Vv+u7SV/6XHf1CV0TXoilKhf5gvytIbn5CAHX5jA7jeb6st0nc+pCqdoJhnSoeG98i1elM6XTMI5ZTMlVJ+0AvCeTr8Q6jjYCSuiHSiJzWRzSYUxZyDMRQFN1gh0RDv3EAGw4yCU5b232DfKM1Yxt/sw+G3Hk3SWbQiUZ0QmBq3/wIw0Lu4EG5RvROY9vjBuEqQl2mb62wMglkXsolBqaixDu2Cu4Hdly13A6hAqx01hrEKIv0JCIX1aYhDCVO4mX9SndwJqLY6aebOZ8CLhXQny3mUJy6zWEyXLcDN
 1WNyykpu
 1rVw+O+jnWdhHTjRZIs+OF9jrBTbTD6Au7NSHp6JiVY38wfGe2+ng6rK2syzfPm9EvPFRacjdM7lV6xyzYD7huGK7H49EfyKaHnMAvox9SMzngRlQ88G8R4MblsCIvvqKMKuAjhRTx8sEET7GtZNfBxCYepr0/Fqz1x8kL5j7abY6tWqUY26lQxvbUHRGZQiz3HN6JnKKaNRaMrbM9SSjKyuD+HdmyLdDihMvHp77R8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

OVERVIEW
========

The problem that root namespaces try to resolve is starting a container
from a root mount tree that is pre-populated before any process is allowed
to run, without inheriting any host mount-tree ancestors.

Work on this feature started originally in 2025 from David Howells'
container object patch set [1], but I turned container objects into a
namespace of namespace roots and built a new implementation around this
premise.

In early 2026, the patch set was left to gather dust in my kernel tree
[2]. Then, the other day I saw [3] as was shocked by its over the top
complexity and thus, here we are.

Not doubling the number of container frameworks inside Linux kernel is at
least a benefit over container object based solutions. Parallel plumbing is
an inherent flaw of container objects, and it directly affects on
development and maintenance cost of container runtimes.

Also, thanks to better scoped implementation surface, verifying rootns
correctness is factors easier than with container objects, and even my
early kselftest is meaningful. We know what and where we are testing,
which is always great.

Finally, it is more compatible with pre-existing container tooling
whereas container objects would have much higher cost.

[1] https://lore.kernel.org/all/155059610368.17079.2220554006494174417.stgit@warthog.procyon.org.uk/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=rootns
[3] https://lore.kernel.org/linux-fsdevel/20261105-b4-cells-v3-0-bc9095937a84@toxicpanda.com/

IMPLEMENTATION
==============

rootns_create() allocates a rootns object backed by a pollable anonymous
inode fd, pinning dedicated empty mount (CLONE_EMPTY_MNTNS) and PID
namespaces along with any optional namespaces selected in flags.

Before entry, a manager prepares the mount tree through the control fd:
FSCONFIG_SET_ROOTNS binds a newly opened fs_context to the target rootns,
and move_mount(..., MOVE_MOUNT_T_ROOTNS_ROOT) installs "/" onto the nullfs
root once and attaches relative submounts beneath it.

rootns_enter() forks a child directly into the rootns credentials,
nsproxy, and root path without mutating the caller in place. The first
entrant becomes PID 1; once it exits and zap_pid_ns_processes() reaps all
members, poll() reports EPOLLHUP and rootns_wait() returns init's status
and rusage. rootns_kill() walks pid_ns->idr under RCU to signal member
thread groups.

Namespaces allocated by member tasks inherit the owning rootns ID in
__ns_common_init() so intra-rootns clone(), unshare(), open_tree(), and
setns() work while foreign setns() calls fail with -EPERM.

Cc: linux-api@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
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

Jarkko Sakkinen (13):
  nsproxy: Pass nsproxy to create_new_namespaces()
  rootns: Add core infrastructure for root namespaces
  rootns: Track init lifecycle via copy_process() and pid_namespace
  rootns: Add rootns_create() system call
  rootns: Add rootns_wait() system call
  rootns: Add rootns_kill() system call
  rootns: Add rootns_enter() system call
  fs: Support FSCONFIG_SET_ROOTNS in fsconfig()
  fs: Support installing rootns mount trees via move_mount()
  arch: Wire up rootns system calls
  docs: Document root namespace uAPI
  selftests/rootns: Add root namespace test suite
  MAINTAINERS: Add entry for ROOT NAMESPACE

 Documentation/userspace-api/index.rst       |    1 +
 Documentation/userspace-api/rootns.rst      |   35 +
 MAINTAINERS                                 |   11 +
 arch/alpha/kernel/syscalls/syscall.tbl      |    4 +
 arch/arm/tools/syscall.tbl                  |    4 +
 arch/arm64/tools/syscall_32.tbl             |    4 +
 arch/m68k/kernel/syscalls/syscall.tbl       |    4 +
 arch/microblaze/kernel/syscalls/syscall.tbl |    4 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   |    4 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   |    4 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   |    4 +
 arch/parisc/kernel/syscalls/syscall.tbl     |    4 +
 arch/powerpc/kernel/syscalls/syscall.tbl    |    4 +
 arch/s390/kernel/syscalls/syscall.tbl       |    4 +
 arch/sh/kernel/syscalls/syscall.tbl         |    4 +
 arch/sparc/kernel/syscalls/syscall.tbl      |    4 +
 arch/x86/entry/syscalls/syscall_32.tbl      |    4 +
 arch/x86/entry/syscalls/syscall_64.tbl      |    4 +
 arch/xtensa/kernel/syscalls/syscall.tbl     |    4 +
 fs/fsopen.c                                 |   74 +-
 fs/namespace.c                              |  176 ++-
 fs/proc/root.c                              |   13 +
 include/linux/compat.h                      |    4 +
 include/linux/cred.h                        |    4 +-
 include/linux/fs_context.h                  |    3 +
 include/linux/ns/ns_common_types.h          |    4 +
 include/linux/nsproxy.h                     |   27 +-
 include/linux/pid_namespace.h               |    4 +
 include/linux/rootns.h                      |   87 ++
 include/linux/sched/task.h                  |    4 +
 include/linux/syscalls.h                    |    5 +
 include/uapi/asm-generic/unistd.h           |   12 +-
 include/uapi/linux/mount.h                  |    4 +-
 include/uapi/linux/rootns.h                 |   38 +
 init/Kconfig                                |    9 +
 ipc/mqueue.c                                |   12 +
 kernel/Makefile                             |    2 +
 kernel/cred.c                               |   70 +-
 kernel/fork.c                               |   29 +-
 kernel/nscommon.c                           |    8 +
 kernel/nsproxy.c                            |   49 +-
 kernel/pid_namespace.c                      |    2 +
 kernel/rootns.c                             |  599 +++++++++
 kernel/sys_ni.c                             |    7 +
 scripts/syscall.tbl                         |    4 +
 tools/testing/selftests/Makefile            |    1 +
 tools/testing/selftests/rootns/.gitignore   |    2 +
 tools/testing/selftests/rootns/Makefile     |    5 +
 tools/testing/selftests/rootns/config       |    9 +
 tools/testing/selftests/rootns/smoke.c      | 1254 +++++++++++++++++++
 50 files changed, 2559 insertions(+), 73 deletions(-)
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


