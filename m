Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB5BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EB86B00BF; Mon, 21 Sep 2026 15:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5A16B00C1; Mon, 21 Sep 2026 15:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD3A6B00C2; Mon, 21 Sep 2026 15:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 388236B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:26:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0DA68028A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:17 +0000 (UTC)
X-FDA: 85238750394.09.C3626E2
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf24.hostedemail.com (Postfix) with ESMTP id DADA7180008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:26:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WJ0vlo2Z;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790018776;
	b=jBD+oa01ZIV5Qh8PkEEegjh8NdzFJt/WUnm/9E3yM2WnDyv/v7UfF7Cj+7OOzLtyTmqE4E
	CPL8yqisd0N3E8nOUwHbJtEU1TCBql8iozRd0yVMfUwYCcCtM8T+9ySMCrTGwtSiUuU9kN
	RC7U6rHeSOrvKfyBvubOPXydBmY+85o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WJ0vlo2Z;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790018776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aTfQGqnFv2H6XSnim3pCybzHHL3GfufSovD4HuyA3x4=;
	b=GioKeUtKRD+dw1jz/OPyngMiu57Al7tkSaWd6Ga5EPR1FRqepZdIfRCwPeMHCQ34YP67KJ
	3VmLBrZUm+7ylU2HKxi8oYVhwN2F5EFXy5RDMQn2nuHlU0OZ04YE7J8M6eUMt2i8/Bqmmg
	SSIlg5+z6hwSGN29EB6ULDrcjuTrUTY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2pYTdTUDa+84wU/MBEvg0yRS7fWJdgAm4Nn22PbXQOE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790018770; v=1; x=1790623570;
 b=WJ0vlo2ZQ7viQgGEOnZ3qLJXfuswTpzTZ8OSaIevTOld4GE7QYYF6ScTny6m25PIkJqhtrY3
 O1GJfTnbUONm6wiWNAFLus2gLMSFvuLC4MraMhUxJ0iw9SoDQVLWyvbkMLjX4SGYWuMY3OfkPFZ
 Ef1sx4RueOw+ArgBQyTmjfUk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7a90df4d3bdf44a9;
	Mon, 21 Sep 2026 19:26:10 +0000
X-Mizu-Trace-ID: 7a90df4d3bdf44a9
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached struct_ops
Date: Mon, 21 Sep 2026 12:25:55 -0700
Message-ID: <20260921192559.2619635-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DADA7180008
X-Stat-Signature: zfhgq8tqimfco7s88i9iwcn1541tbgid
X-HE-Tag: 1790018773-87371
X-HE-Meta: U2FsdGVkX1+QgHJmJ1Ry9glNq8DYwDH/VwHTAfOIPom1pX/0pjng3rTj4F+cEHnMUVQC1+H1mcWR/dFXKBqfHpcViLmTcEpiAjjb2e1fS3UK4NE5c0zuTtlA8UgWMlGRpoXYTUmQcak/0bjTjMcBEoMAWPgFzP4Q55p10s3rt4UySUEdX+UYKInyu9Fuk6AJrLOT+tpDCcChKMdsTj0MCViMUz0GNUtFt+3tpYgXpyi0fRzsOCW8RECnmFmCD32ChLkLQYEruxlk9fc+bNM8R3/jFwYjPOl7u3kK1wMRN364B1G1Wt0Svjp397gipPxES6Q7ATjaIjqCJqlNZHehsbtDaNLkfzIpYwp15ypFv01CjM9TPDsckXLDtv8VpexWvemTubuvVuvRDWaSCfUeUmQyPyf9YxpWk0675ivsWI5kN993czvdPIIBpmOXwq8lAv6I/m30OMx7/bD0j5oKL2GSuUefNscZzJ9sTdlePm0+2nOT8idPjMOZ3ZG5jFuWtFIx4BgQs1WZsuvqVtPeP6mw3+/qPQf2idNEbwl+suirXoflEKwfrJ4FB20pEG9co6qBjzi+jwDXKd8q0MgVUAFAkClIelgAD/ZejvZHR7tZjLwSIze+BoKWgeO7ZG9169BdAhC1kJzKA4rIaRUvTWb9RvS4TA8qLbJBmPqn8WSBBosTEejnlXqcgIzg/Nk38UkUg0YpL27S0mfc1wscKWbcjmfeIjoWxnM2V0jCl/bZ/c2JQaelYluEf8nlUpD67lSORkyXbsuWLi/pxUNoQr9Ch+KFfm9J6NmXhnvUC3nvgioOu/T5r0DWcs8h1O/4BwTKnQ6TSbUERnscX0TpPUsCREfSNc1n6kQujGImfueZn7tGUsSsExLKx3waUyOx2SydISemc/N3BkxLxanhMA0u2Vzo1M3krZhbw6nZ82QGEvEmppwaWsmrj7ZI5CYqIoWaGDdyFXPNlkU5wNY
 v9/yashn
 Opwg/akP4RCbpJgr9eR0VuIouV3WCDDUc2pNXkFVIbGGBdgxaEydgoO+qIL6vIV6JSeDfqfD3aThenHUvk98PDNgMGqTyxnVP0p2Z20yUoEw1sgmio1wsQHSDAwQo8zqMhTCfmHZfuYuF67XBkBEScovUePYIyB9Pkaasc3Ud3+oZY//2b8OnLilWyXQZSl/054kvXnX5TGUgXpdiD3qxHiTK4S7jIqyinQKXuUDqZ0nohVzGxrHSoJ5IqtWRAbJMRLqvR8h9O9DXWDNVz7a/iJtserWCSIWyeW9+YRVajxBgfIXuoJAP8XXzTbBqkwM7A3OIW27f2VHkDnqDDxzb7hhCbkR2YKAK90KulQIzpwcB/2YzCOOyiFXFE4IA14txEyW1bOEnKrOHgFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the first series of memcg_ext, proposed at [1].  It adds
bpf_memcg_ops, a struct_ops type through which memory controller policy is
attached to a cgroup.  A charge runs the policies of its cgroup and of
every ancestor, and the kernel combines what they return.  BPF picks
between things the kernel already does; it never does the work itself and
never touches a page counter.

The plan is to grow this one member at a time, and to add a member only
when there is a concrete problem it solves and a measurement showing it
does.  Nothing is added because it might be useful later.  So this first
series adds one member, for one problem.

The problem
===========

try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
which reclaims and can throttle the task.  That happens wherever the charge
happens, so a task holding a kernel lock can be stuck there, and everything
waiting on that lock is stuck behind it.

One concrete scenario which can be resolved by this new feature is the
kernfs notify worker. It delivers notifications with the cgroup2
kernfs_rwsem held for read, and the charge for the delivery allocation goes
to the cgroup that set the watch, usually one already under pressure. So
the worker reclaims while holding the lock, a waiting writer blocks every
later reader, and anything touching cgroupfs stalls for seconds. The patch
proposed in [2] fixes that one path in the kernel only for kernfs_rwsem.
The same path still takes kernfs_supers_rwsem.

One can make an argument that if we know the source of the issue in the
kernel, why not fix it similarly to [2] instead of having a generic
solution? The reason is that it will be an uphill and continuous battle as
the kernel keeps evolving and new sources of lock holders doing allocations
keep coming up. In addition, there will be cases where it might not be
possible to move the allocations out of locks, or where doing so would
make the code really ugly [3].

high_policy() lets a policy say where memory.high should be enforced
instead.  Its one request, BPF_MEMCG_HIGH_DEFER_INLINE, skips the inline
call, leaving the debt to be paid at the return to userspace.

Results
=======

Measured on a kernel without [2], with a policy that marks cgroupfs kernfs
lock holders.  Reproducer at [4].

                                      baseline    policy    upstream fix
  max kernfs_rwsem hold, worker        2.049 s     199 us   not taken
  max kernfs_supers_rwsem hold         2.049 s     4.8 ms   2.056 s
  max kernfs_rwsem write wait          4.096 s     6.2 ms   8.7 ms
  walker passes over /sys/fs/cgroup        352       5711   6700
  churn mkdir+rmdir ops                 13 059    364 832   415 488
  churn max latency                     30.7 s    15.1 ms   12.7 ms

The policy matches the fix on the bystander numbers, and does better on
kernfs_supers_rwsem, which the fix does not help: it drops kernfs_rwsem
from the delivery loop, while the policy stops the worker stalling at all,
so every lock it holds benefits.

The patches
===========

Patch 1 is a build fix.  __cgroup_bpf_query() only works because
CGROUP_TCP_SOCK_OPS is the one struct_ops attach type; a second one breaks
the build and makes a query for type 0 return the wrong thing.

Patch 2 adds the type and its registration, with no members, so nothing is
dispatched and behaviour does not change.  It also moves the attach type
enum out of CONFIG_CGROUP_BPF and fixes the register_bpf_struct_ops() no-op
stub, which never compiled because no caller reached it.

Patch 3 adds high_policy() and wires it into try_charge_memcg().

Patch 4 is the sample.  It tracks the two cgroupfs kernfs locks by hooking
the rwsem primitives rather than the forty-odd functions that take them.

Known open questions
====================

The semantics of memory.high for remote chargers or kernel threads is a
grey area and this series does not aim to resolve that.

Another open question is whether a bound on debt deferral is needed. At
the moment, we think that rather than putting a limit on deferral for
memory.high, it will be better to handle that through an async worker like
memcg->high_work.  We aim to introduce that later, along with the right CPU
accounting for that async work.

There is no prog_tests harness, so the numbers above come from the
reproducer and not from the test suite.

The sample's lock tracking costs about 8% throughput, because it
instruments every rwsem operation on the system.  That is fine for a sample
that has to cover every path, but it argues for a cheaper way to track
locks that cause isolation problems between unrelated workloads.

Future work
===========

Asking the kernel to reclaim on the policy's behalf, so a task that cannot
be throttled still pays. More members, each with a use case: hard-limit
policy, reclaim shaping, dynamic protection.

This builds on "bpf: A common way to attach struct_ops to a cgroup", which
supplies attach, detach, ordering, update, query and the RCU rules.
bpf_memcg_ops is its second user.

[1] https://lore.kernel.org/20260307182424.2889780-1-shakeel.butt@linux.dev/
[2] https://lore.kernel.org/20260910045406.485295-1-shakeel.butt@linux.dev/
[3] https://lore.kernel.org/20260917-wehten-achtfach-getarnt-c85a4812337d@brauner/
[4] https://github.com/shakeelb/mempressure-repros/tree/main/kernfs-notify-memcg

Shakeel Butt (4):
  bpf, cgroup: fix cgroup struct_ops query for a second attach type
  memcg_ext: add cgroup-attached bpf_memcg_ops
  memcg_ext: allow BPF to defer memory.high enforcement
  selftests/bpf: add a cgroupfs lock-holder bpf_memcg_ops sample

 MAINTAINERS                                   |   1 +
 include/linux/bpf-cgroup-defs.h               |  22 +-
 include/linux/bpf-cgroup.h                    |  14 +-
 include/linux/bpf.h                           |   2 +-
 include/linux/bpf_memcontrol.h                |  66 ++++++
 include/linux/cgroup.h                        |   7 +
 include/linux/sched.h                         |   4 +
 kernel/bpf/cgroup.c                           |   3 +-
 mm/bpf_memcontrol.c                           | 188 ++++++++++++++-
 mm/memcontrol.c                               |  31 ++-
 .../bpf/progs/memcg_ops_lockholder.c          | 222 ++++++++++++++++++
 11 files changed, 546 insertions(+), 14 deletions(-)
 create mode 100644 include/linux/bpf_memcontrol.h
 create mode 100644 tools/testing/selftests/bpf/progs/memcg_ops_lockholder.c


base-commit: 6e36e099b15bed1e8e5b3e3136c5e3eb56a15aa7
-- 
2.53.0-Meta


