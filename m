Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B852CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EF48E001A; Fri,  7 Nov 2025 17:50:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8258E0006; Fri,  7 Nov 2025 17:50:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0678E001A; Fri,  7 Nov 2025 17:50:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 723C38E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:05 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E8EE1A062F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:05 +0000 (UTC)
X-FDA: 84085305570.17.A2EB5AE
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id 36C7480004
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LsMT2DPS;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555803; a=rsa-sha256;
	cv=none;
	b=RF5TfzgnMKWneJDiwrB3ol7FdIUpMKthLFv6JCqoCTYC6s2ZEzXE43H6gno3/OhHnUmb1q
	nBQ84usgejXoqoU3ueKwUYdjGwobvP5qmJZPYYXNOB8Xu+5JHKzlYHjgjiympN7N8d7T2k
	oBkRC8eifIeYusUCh1l8SDBjPG1M/ds=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LsMT2DPS;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W/i5+G+JXNuEj74b+jlkiB1ru0BZu3qaV0THAJdKUHE=;
	b=bNy0QqFvmLki6zCSUq2jvvxO3YHpa2xjIEgCoB6h5PkDy+UOzIjemeI8TFyu/YgXeozc4n
	6f4jSTaebIWhjXbDWWj4FpeH9IivkaLetuQ5RTKK6ZiQQEN1kaNwXChBSYZkjan3qNRyMN
	YVPlUeRXYfw90IyUr+9MiBSDTUB0si0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4eda26a04bfso6109231cf.2
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555802; x=1763160602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W/i5+G+JXNuEj74b+jlkiB1ru0BZu3qaV0THAJdKUHE=;
        b=LsMT2DPSaKswqV18miPVdFhu/Rx0HXOF0o80y+7kFYtqqx7vPDfM90Eqrg4ecKbnWA
         OIUhpNCi/tBDnhECQWMxRzFi7sRo+69wfEqECaE0dbUWdlkNkIKV8DehcD3LrQNvgb5p
         +qYHS7qIfp+ZJ7n/Z3l5kViw73FM5+x42OogWGk3sS6Jaun/Yq7DHfs9gbcyXRNGcHQ9
         uocvgfLy5aib0AtBWj2yD6xEwpe0vnXIG/TdCurpQXkWrEGGWoGWZhqpTvLRq5KnbioU
         gfluY7WILtWad9iEeZNySkWDCmn/FlJcbPr00O33ubhm98B/Q/wktZjqFjd0Xgv1Nq8s
         3xRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555802; x=1763160602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/i5+G+JXNuEj74b+jlkiB1ru0BZu3qaV0THAJdKUHE=;
        b=Fq0ddSwlC1dY9zIdEe3FXDhhkVb/HtUoxszW0MM0EGloQ0fEiOkdeS1ygBE8/4DCgm
         mvrpuYRt7H/vPu5zgRiBPGZ9BniP2Ju0SS8lVJ3DARrGy5QeDKxGxWI8afDxs+DAnKZJ
         OYcqMqh+xWQ77c0WAnQaCdGgapgM1qz/rk2QfS+kp+gfKR1f00j2J5ocNedgXYn5FuhE
         RS+Xijf3WAz8HxL/LmXoTwOjqbGUhVm83x9gK5J5ERbKmF1Y9Kl0x12DKcSEg9WgT+eW
         PFDCOnGLL0rAvGWsxEddJcrqnw0XOriibcGR/8ZB/+/jeLStr/abjupXIGhe3Of+zRmP
         Ho1A==
X-Gm-Message-State: AOJu0YzWW2a3HEI9w71Pxl2nZhisRb7b2GOgSYV+vxwERJEC8866piFP
	QIphEBKamBe/xzvXFj1InTttkE41ge6Go4lEt2FlENdp7zntjT9xfzgj1eoYvINEdxLVvqPvILe
	EWpjX
X-Gm-Gg: ASbGncsa2EHRoZy8ojApAJHeEVoZGKPEXZaPKnLO0yUOi3JIYum6bMoM0RTZnvfNcMI
	5BuVQcYZ4nqRq42hubqOZ4A8kDrOSilNtBmrMXKgLl2FhiU2kia2JA4GhRLBn1G+TA20hkJQBQP
	RE31wrGvXWP+F+3LlFLxD+DCJBr8iWIbb7xuMSyRC0SlCV2ltkJDzdGWf1uwpB/s086Nn0W4aFP
	/C4pCnq9MDjV/4D/2zH3DgVo26EGI9e1g7VHnqzJzCRAdeb/Wqp2yY6YtAnoh+yOjEsnXH0Aau4
	7BNI5Sr0A6duCYMyQ+AcMoI20YB8wyZPQibf59qAPadEKf9jeFwbFMEjj+jGl7xVcATv5aJ1fWi
	bUc8SXTnTGxW2oaTzTHQr8OcVA7+7sHo8lLxZ4QEaOmtx/oXV7IuEqancqPnMrsvtPFJ8fDRI+0
	JdRCOgS/n0S8E4EFYXbGGenefCNK4wZjpZH3ZXJn7fYLYh6X4ExWp+MBSlwhmkhpokqCoGPwgxd
	CdbDPsLHjm3sQ==
X-Google-Smtp-Source: AGHT+IEnnHkz/BZSg5DKCpmGTuSxg9EESDNIjBwNYfeFy3KOQNMlwaNzTyo63eXXhJ12ZyZIPB9YSg==
X-Received: by 2002:ac8:59cb:0:b0:4b6:299d:dfe4 with SMTP id d75a77b69052e-4eda4f0a4a4mr12390191cf.32.1762555801614;
        Fri, 07 Nov 2025 14:50:01 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.49.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:01 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC LPC2026 PATCH 0/9] Protected Memory NUMA Nodes
Date: Fri,  7 Nov 2025 17:49:45 -0500
Message-ID: <20251107224956.477056-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36C7480004
X-Stat-Signature: t36s9cz9n8k6wj846p3k3tr7kob4b7jn
X-HE-Tag: 1762555803-118703
X-HE-Meta: U2FsdGVkX1/WcIf5cPj3Tzzz7IW/iyjS7rqgodp6sd8i/pFg44XoYYyQS6JABvZjmJEGdJof21YQZb1ARu6aatc59FeXid0O/PbdccRqOti4Na9Me5Cbb3Eh/qm+TcEKQRotuUGG5yhdAqe5PMPNhuuhihTAaEEzLMk7l3YUdLFGCqBTtiGomo67bPVHywpvjCwK9/ps/pJeGbFgxDomakA46cNsMs172JxXCXm9dKbhyQ7qGSBZnROxyV5BqmEjVmIgeKelhZKGaJInRM61Fw4s1g1LZ7tTe4qNRsTlHz/qNDXBTqQhO7qupg9HIX93WC/UnNAy+fJOyJUWA+KkKmLIluoyuTe8nff7oG994Ln7nZqnFOnl0GjV9Qeo7FScityhBYXq/naMT987u+bFdnPOHH4q4yVEFZt0ZpsH78soHQPcBkYYZr53i5QMnvrywY8IJo5/aOpRq2eCWMOanGq6NyI60KYDffg18O5FAIZedBflkT1C+WMa+gQXTciqe9m0EFL/o/pKxSxhspPRN0HXEF3rqKgeTH5PBKOpMOPNfOJt4qpYPis0OtoPQRcJ9E2Q/Hlprk50q89ocm+09evHeWSydh17LyLGwv9h38tMvKUewD6xdxNcWUvZ7BPtfmbyVDV0Sw/rz2fIGm2QczU7we3nzFqFT05krAQExVCpVhA4zrMio/A491kk3cMXlzF9svOayCCcUX3CeY0/QmJLpuyflVCz+h6X9so8/mq5rXAiM4wGk8wi60qaX4aQxgJI7m10YjJafMXP9xoUPSFwYZXrmW6wXCc/1Fb/z09qd0IuwS0+ueTw6m/Zgrgm1LwhAMN4zOb20i1oAr/96mRBtiazHUInFwUnoytQNl7UjKCIViYbIrJ/F93vVqU8XST0YNYtKY2mCKnEKNV3fsXtl2KBx6PncqrjjOBXuV27i3sWcEtZPCdUUDvTpHhFQRnCEH72fMmp/EkLj77
 v2jPdWDC
 1HIJfsz9r7E/aEtblHu3ChdsSKTLU5vM5hDUQh6xXObcgsqACIhiZhCMFriHJ8Lw++KE8+feTYWc7xyd2za1Vq/hhc0LrOX3xcBT18QjwcT9quRKVXYp0nNkMk/UDX7xfg1HjGt3W7xAw0IJWyYsSeo1ipuHhsL6WX2EkrBuNSS4++HqgrVhrpeRgR/jFJ1U7kyFRElcw2PcJM2AJR5U9+O4/+uCt11zXZlcCTJr/TV81+oNGjSJZ+YNdvGiZnHqCqqdvxr9KkcvaV6Isp/uRnH7O0yj43rqmj+BzfrxLkmqw9+ha74QxY4qzlmZhF1q1MBCqDIYHMrBX8tIjw23md/UTPwYBy958CVQYbke5fwolO5CQGhILoEkgzosn4FJwtiEs+/tk20ulDZTBoACLdlGy+Dv2wcJReZMWNRm4x51dKGscijMgmOsanw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Author Note
-----------
This is a code RFC for discussion related to

"Mempolicy is dead, long live memory policy!"
https://lpc.events/event/19/contributions/2143/

Given the subtlety of some of these changes, and the upcoming holidays
I wanted to publish this well ahead of time for discussion. This is
the baseline patch set which predicates a new kind of mempolicy based
on NUMA node memory features - which can be defined by the components
adding memory to such NUMA nodes.

Included is an example of a Compressed Memory Node, and how compressed
RAM could be managed by zswap.  Compressed memory is its own rabbit
hole - I recommend not getting hung up on the example. 

The core discussion should be around whether such a "Protected Node"
based system is reasonable - and whether there are sufficient potential
users to warrant support.

Also please do not get hung up on naming. "Protected" just means
"Not-System-RAM".  If you see "Default" just assume "Systam RAM".

base-commit: 1c353dc8d962de652bc7ad2ba2e63f553331391c
-----------

With this set, we aim to enable allocation of "special purpose memory"
with the page allocator (mm/page_alloc.c) without exposing the same
memory as "Typical System RAM".  Unless a non-userland component
explicitly asks for the node, and does so with a GFP_PROTECTED flag,
memory on that node cannot be "accidentally" used as normal ram.

We present an example of using this mechanism within ZSWAP, as-if
a "compressed memory node" was present.  How to describe the features
of memory present on nodes is left up to comment here and at LPC '26.

Important Note: Since userspace interfaces are restricted by the
default_node mask (sysram), nothing in userspace can explicitly
request memory from protected nodes.  Instead, the intent is to
create new components which understand different node features,
which abstracts the hardware complexity away from userland.

The ZSWAP example demonstrates this with `mt_compressed_nodemask`
which is simply a hack to simply demonstrate the idea.

There are 4 major changes in this set:

1) Introducing default_sysram_nodes in mm/memory-tiers.c which denotes
   the set of default nodes which are eligible for use as normal sysram

   Some existing users noew pass default_sysram_nodes into the page
   allocator instead of NULL, but passing a NULL pointer in will simply
   have it replaced by default_sysram_nodes anyway.

   default_sysram_nodes is always guaranteed to contain the N_MEMORY
   nodes that were present at boot time, and so it can never be empty.


2) The addition of `cpuset.mems.default` which restricts cgroups to
   using `default_sysram_nodes` by default, while allowing non-sysram
   nodes into mems_effective (mems_allowed).

   This is done to allow separate control over sysram and protected node
   sets by cgroups while maintaining the hierarchical rules.

   current cpuset configuration
   cpuset.mems_allowed
    |.mems_effective         < (mems_allowed ∩ parent.mems_effective)
    |->tasks.mems_allowed    < cpuset.mems_effective

   new cpuset configuration
   cpuset.mems_allowed
    |.mems_effective        < (mems_allowed ∩ parent.mems_effective)
    |.mems_default          < (mems_effective ∩ default_sys_nodemask)
      |->task.mems_default  < cpuset.mems_default - (note renamed)

3) Addition of MHP_PROTECTED_MEMORY flag to denote to memory-hotplug
   that the memory capacity being added should mark the node as a
   protected memory node.  A node is either SysRAM or Protected, and
   cannot contain both (adding protected to an existing SysRAM node
   will result in EINVAL).

   DAX and CXL are made aware of the bit and have `protected_memory`
   bits added to their relevant subsystems.

4) Adding GFP_PROTECTED - which allows page_alloc.c to request memory
   from the provided node or nodemask.  It changes the behavior of
   the cpuset mems_allowed check.

   Probably there needs to be some additional work done here to
   restrict non-cgroup kernels.

Gregory Price (9):
  gfp: Add GFP_PROTECTED for protected-node allocations
  memory-tiers: create default_sysram_nodes
  mm: default slub, oom_kill, compaction, and page_alloc to sysram
  mm,cpusets: rename task->mems_allowed to task->mems_default
  cpuset: introduce cpuset.mems.default
  mm/memory_hotplug: add MHP_PROTECTED_MEMORY flag
  drivers/dax: add protected memory bit to dev_dax
  drivers/cxl: add protected_memory bit to cxl region
  [HACK] mm/zswap: compressed ram integration example

 drivers/cxl/core/region.c       |  30 ++++++
 drivers/cxl/cxl.h               |   2 +
 drivers/dax/bus.c               |  39 ++++++++
 drivers/dax/bus.h               |   1 +
 drivers/dax/cxl.c               |   1 +
 drivers/dax/dax-private.h       |   1 +
 drivers/dax/kmem.c              |   2 +
 fs/proc/array.c                 |   2 +-
 include/linux/cpuset.h          |  52 +++++------
 include/linux/gfp_types.h       |   3 +
 include/linux/memory-tiers.h    |   4 +
 include/linux/memory_hotplug.h  |  10 ++
 include/linux/mempolicy.h       |   2 +-
 include/linux/sched.h           |   6 +-
 init/init_task.c                |   2 +-
 kernel/cgroup/cpuset-internal.h |   8 ++
 kernel/cgroup/cpuset-v1.c       |   7 ++
 kernel/cgroup/cpuset.c          | 157 +++++++++++++++++++++-----------
 kernel/fork.c                   |   2 +-
 kernel/sched/fair.c             |   4 +-
 mm/hugetlb.c                    |   8 +-
 mm/memcontrol.c                 |   2 +-
 mm/memory-tiers.c               |  25 ++++-
 mm/memory_hotplug.c             |  25 +++++
 mm/mempolicy.c                  |  34 +++----
 mm/migrate.c                    |   4 +-
 mm/oom_kill.c                   |  11 ++-
 mm/page_alloc.c                 |  28 +++---
 mm/show_mem.c                   |   2 +-
 mm/slub.c                       |   4 +-
 mm/vmscan.c                     |   2 +-
 mm/zswap.c                      |  65 ++++++++++++-
 32 files changed, 411 insertions(+), 134 deletions(-)

-- 
2.51.1


