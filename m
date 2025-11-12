Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F2FFCD3445
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3738B8E000C; Wed, 12 Nov 2025 14:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34AFB8E0002; Wed, 12 Nov 2025 14:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261758E000C; Wed, 12 Nov 2025 14:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13FCA8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:29:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B915C12DF59
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:50 +0000 (UTC)
X-FDA: 84102944940.19.EE0ADC0
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id DEBCAC0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="kjUK/jA1";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4+0KzZp8SwB3qOByrtp+OoMjU8q91P/BfZmx06JIMXk=;
	b=F04LB0zAYo3VMwieFjSVnA6ThTTOsIApe/iKboTTXvUkL2SvZ9jNYlC54YT3JyXpK38Ztt
	e2DEaC3+X9voxFw7/pV6zVSqs3JXP7Dh6ES+hKzV8jpBMw3Ru1OpLF+8UgU8+Fz36Nn4JF
	zTB/VGsHRNdRbznHlj4dfBUNws2lvRM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="kjUK/jA1";
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975789; a=rsa-sha256;
	cv=none;
	b=UFJlC9nRnHg5ph9aJpjiMD6yX/gNmwda/2YNxwSErEyqBxxb05lRZy61X1bbVans7OuNj5
	8xG1P7bP1tSfiKiQAj+ei6OBWLz9zqYObVH8mSW4l8KRZdQ8svveY3T5TdSgo46NqGdkQX
	ki8Pv7MeyZUrPUxpxv89S1tvLprHACM=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8b26b12be9eso4216385a.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975788; x=1763580588; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4+0KzZp8SwB3qOByrtp+OoMjU8q91P/BfZmx06JIMXk=;
        b=kjUK/jA1/UyZURJo+Fdm9ywEL15SAO7UE6wlz6vXC8qmoonaVZvFzd/7x2sVhS6HQ0
         Oj7YeFeLKa0SxqwNi32aFHeP6A5S/McgwVi1hjcwZOM2CCKlQfuC+SP8HtsWgGkPPS4P
         Ci+40bfOxFtdgezDOlZIwXfHJbmOtmPuTIk7EmfHwMrUN1uRemp3Z/D1MV1hpnffoKvk
         dKNm4D9SHzrhTVdd/6XwMJ/kHLmbZUf3fRbzFXWwXmA6WDr/3qjKT0FSdCGVdVlsB4MY
         DJXgjP+bGJscdDqRJyRMkd/4RfAeNnKB1k1ZgI1yQ+/jEu0uxDETpKLRZWKxmXY4OBU3
         BTkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975788; x=1763580588;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+0KzZp8SwB3qOByrtp+OoMjU8q91P/BfZmx06JIMXk=;
        b=rjHaWwRrj3e6fenWQ6XnuhkrWqGVPuKookpyNhcV6QDucXuIty3ue+iiWfD3QuQC4w
         tB5rZyQigaWUO++SsFeSlP6Cr2iBJGJm0bbmYOT7GuDp0+pbFGV1dNizcZyG71/xfpJ1
         KnDfDEu1Ieqrlykad2n71Pug6QjnnJ6h99boZxMRHxROATBd/oRjVAMPJnKitwoXlkpa
         bR7OR4WKXkXG4NwgjLOtVp3viLYB7M9b20eY9+VY0qMgNTnm8PNu22qosgLjSNjNlOJo
         un3QsgrfJUZ7AuDfZoiObEDW+U5vH3HAFMgdcP1wZ15v47DXMRRHE031dIf9CYQ/7Zgg
         XSVA==
X-Gm-Message-State: AOJu0Yy7QfgvbZRPZMstwrziPHngnaM0QMvotKKLAimxAVvEU03m9cA2
	7BMCevhkOqfF0GbZfkiBEEeW3OP2jYCVbacQzRsS2vauVZdny7F6q/t1ASM+qpZII8wqRqIiE6d
	Kc24i
X-Gm-Gg: ASbGncsT5hC3kz9nq/Q7vK9CxsV/tdOxMBFV8OP0F9BVToB8h6WTwPptjBM5G+U6gGk
	8O7+WBeZAtEl9BkhzrwSRxF2XtKnI0wJeDbrQHN+hjgjrbxHN3+vpXW6qLp99zgmMzVxCSCJAI9
	n0fOiolFCR9pV+vkVLqN0QbXWrmgOTHKwsnkJZ8AdcAJRg3rHqUEpbPWQXkM63wiVKtaSxA3xUx
	/x0l1zACG+0AVauap/oXaa9ZryQGgdg9rsOQVf3RbVe+ckQwYdgOJagvdV1WR/p/gzEFAziXGCy
	HnT33zDPSMwD9Dy/Kvsnpx93pRievV9e81PAGBeGIshOvXWr9A4Zse0ceZFzkT/84kad88ZEJNg
	9UQnOa//D75o779JHzFidIkGNODZS0blDlaT9qUlKQSO2uQzTlYFafbFizKmEN5GzBYgVdw6wQq
	368tzSv5SQZf1yNedvlTrFVyLcDZyQRvLikEnXc2hxhs0+CYlELAgpmqoGjte0BCvN
X-Google-Smtp-Source: AGHT+IED/6odDPyQbULX4YBs7xZBD1FyA57cRMNb3Lw5e2EsWmuJNVD+txeZjw/L/EjeaGulzMWhyA==
X-Received: by 2002:a05:620a:f15:b0:892:8439:2efa with SMTP id af79cd13be357-8b29b77ab2bmr557638985a.23.1762975787508;
        Wed, 12 Nov 2025 11:29:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:47 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
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
Subject: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
Date: Wed, 12 Nov 2025 14:29:16 -0500
Message-ID: <20251112192936.2574429-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DEBCAC0003
X-Stat-Signature: tksiu3ddu19eotmcyxy63zetg48j9r7e
X-Rspam-User: 
X-HE-Tag: 1762975788-166147
X-HE-Meta: U2FsdGVkX1/znwXiLYo3lCbxRT0su0UuOTfmRLGrJqES5kQksEZjaVkjUVt+HZ7rOq1ey0PW5B620FyjW6lephDk7YKFIUHHI1BMBGTGzPoVO2F9C4yu7ZmBSX9KHDcmoLD1mVjqtLiVYqyXphtp0YFbYoxWWfJuGOfTpgVs2f33VjMJ+LlaeLvAN+uL8XRJbf3DFnYyItt79Ri/sOFjIm4FKPZScHRDGNksWniR5ZwQumx5gUmjkYdi7wT9dmHUKR/9PkJSq95WHF1Ye9cjaG2BVQ5sN9GFSU1Zf6C1PvzeI1JHDBFfzC+X7oML+jhEm6E4DpEDaYbU95+x16pCq50ErYrjCQP3RDT7+0IGX/0Yq7Fy7SBdh70I2MifDgE++bveAi7ZNUnoF72gBPK8C6FrtX6CktruhhwJmjOzuzNL02ob6dxbNGpR7myDewVWMIiW1ZwVMLWYzNxTQK1vcVXYRZBhS1rhiFwX7ZV0AU7OAiM+f+nU7PJlF5xz+ZjxGw8lGOpLVyriXFy7hGxQ9eBkg3I1xBpUfRo2+K+4XDI0k79UGrRGbXSFewCpdSQNu+SUKPBNOSFAwXHu9CXPiJ2AU0YxCEyAQJ2oAaJwtVLNYoSNNb/298kSDRJgPaGK731PbVzXxbzEJdqTfbMI/JCxtvf4qI2sRMT12+h9sjlOzyMsOWapTufz0gWOe3IC1Gn+AJsyRtqW7NEUNtORErk6XnoykHjPUDhpLpi88jXIn4I3aPaqj/V7xq2cSWVmcoaOj2tlSA4R5HMOtRvH4BsnjA/WiOiJW3yushDhSvMXW4kkqVi9VB7haEhHePpdqCuzOGNQDF6gsuC+akUrFlyNFftZG9PqkzaiW9AlFYu3xehjP1B3rE3/PW7CL+cp7C6CEkit7/WGLzD+12RI0wi8RB6xT+1dn26y65x1gPFNPe6Afnt+x0udI8CkeF26Kx8Xe8KABOneAxV1G04
 X91YaUu2
 UqLKctIpxBJQxFpdVgoEXCR9didmHN17/Ei8B6Mm1iCQtygoyWP7uDIRsVECH7g/Hk4UiH7CdjuZOFb18Gcmi+bWY4OphWZw8rDBe3qADs7JxpICLXwMZSXhOzJ2yO0v3zDr9yNlKz17xpGIEXd0lmnTuWOUdaideCpAflkM+Egm0FsucNnRsS3etSn2vdM1vmwRmEsv2+njPOzEKo1m9tFC0mjfYZ6cVfq1nwxLzCsFJnN7UAdyMfj26FLtWKX/bcuf0v/AKzpfYZXeP0+PFu9WfEC//VhahhkiWeyQCe+PCFWEXKT6PWf0k5axX1Mmk27Inn9fb2yHXXxbrPfAfwFE09esAPTTDuTLumVrqPXGB2D2IhgxkI6UQtCg5YJBLU3ZnlFQxJ18LFHVJDVDxrUUps0/4nnxfM3pLBZbM0Wdh/eUQIQWTFrws+MMuESwKETOWWg3+pTyzDlpBf8ZukfNCdJPqTpaXqASWnQoDUJhXc1AUu0BMDAPK2Exeu5o/hVFbcsMgBRINwmc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a code RFC for discussion related to

"Mempolicy is dead, long live memory policy!"
https://lpc.events/event/19/contributions/2143/

base-commit: 24172e0d79900908cf5ebf366600616d29c9b417
(version notes at end)

At LSF 2026, I plan to discuss:
- Why? (In short: shunting to DAX is a failed pattern for users)
- Other designs I considered (mempolicy, cpusets, zone_device)
- Why mempolicy.c and cpusets as-is are insufficient
- SPM types seeking this form of interface (Accelerator, Compression)
- Platform extensions that would be nice to see (SPM-only Bits)

Open Questions
- Single SPM nodemask, or multiple based on features?
- Apply SPM/SysRAM bit on-boot only or at-hotplug?
- Allocate extra "possible" NUMA nodes for flexbility?
- Should SPM Nodes be zone-restricted? (MOVABLE only?)
- How to handle things like reclaim and compaction on these nodes.


With this set, we aim to enable allocation of "special purpose memory"
with the page allocator (mm/page_alloc.c) without exposing the same
memory as "System RAM".  Unless a non-userland component, and does so
with the GFP_SPM_NODE flag, memory on these nodes cannot be allocated.

This isolation mechanism is a requirement for memory policies which
depend on certain sets of memory never being used outside special
interfaces (such as a specific mm/component or driver).

We present an example of using this mechanism within ZSWAP, as-if
a "compressed memory node" was present.  How to describe the features
of memory present on nodes is left up to comment here and at LPC '26.

Userspace-driven allocations are restricted by the sysram_nodes mask,
nothing in userspace can explicitly request memory from SPM nodes.

Instead, the intent is to create new components which understand memory
features and register those nodes with those components. This abstracts
the hardware complexity away from userland while also not requiring new
memory innovations to carry entirely new allocators.

The ZSwap example demonstrates this with the `mt_spm_nodemask`.  This
hack treats all spm nodes as-if they are compressed memory nodes, and
we bypass the software compression logic in zswap in favor of simply
copying memory directly to the allocated page.  In a real design

There are 4 major changes in this set:

1) Introducing mt_sysram_nodelist in mm/memory-tiers.c which denotes
   the set of nodes which are eligible for use as normal system ram

   Some existing users now pass mt_sysram_nodelist into the page
   allocator instead of NULL, but passing a NULL pointer in will simply
   have it replaced by mt_sysram_nodelist anyway.  Should a fully NULL
   pointer still make it to the page allocator, without GFP_SPM_NODE
   SPM node zones will simply be skipped.

   mt_sysram_nodelist is always guaranteed to contain the N_MEMORY nodes
   present during __init, but if empty the use of mt_sysram_nodes()
   will return a NULL to preserve current behavior.


2) The addition of `cpuset.mems.sysram` which restricts allocations to
   `mt_sysram_nodes` unless GFP_SPM_NODE is used.

   SPM Nodes are still allowed in cpuset.mems.allowed and effective.

   This is done to allow separate control over sysram and SPM node sets
   by cgroups while maintaining the existing hierarchical rules.

   current cpuset configuration
   cpuset.mems_allowed
    |.mems_effective         < (mems_allowed ∩ parent.mems_effective)
    |->tasks.mems_allowed    < cpuset.mems_effective

   new cpuset configuration
   cpuset.mems_allowed
    |.mems_effective         < (mems_allowed ∩ parent.mems_effective)
    |.sysram_nodes           < (mems_effective ∩ default_sys_nodemask)
    |->task.sysram_nodes     < cpuset.sysram_nodes

   This means mems_allowed still restricts all node usage in any given
   task context, which is the existing behavior.

3) Addition of MHP_SPM_NODE flag to instruct memory_hotplug.c that the
   capacity being added should mark the node as an SPM Node. 

   A node is either SysRAM or SPM - never both.  Attempting to add
   incompatible memory to a node results in hotplug failure.

   DAX and CXL are made aware of the bit and have `spm_node` bits added
   to their relevant subsystems.

4) Adding GFP_SPM_NODE - which allows page_alloc.c to request memory
   from the provided node or nodemask.  It changes the behavior of
   the cpuset mems_allowed and mt_node_allowed() checks.

v1->v2:
- naming improvements
    default_node -> sysram_node
    protected    -> spm (Specific Purpose Memory)
- add missing constify patch
- add patch to update callers of __cpuset_zone_allowed
- add additional logic to the mm sysram_nodes patch
- fix bot build issues (ifdef config builds)
- fix out-of-tree driver build issues (function renames)
- change compressed_nodelist to spm_nodelist
- add latch mechanism for sysram/spm nodes (Dan Williams)
  this drops some extra memory-hotplug logic which is nice
v1: https://lore.kernel.org/linux-mm/20251107224956.477056-1-gourry@gourry.net/

Gregory Price (11):
  mm: constify oom_control, scan_control, and alloc_context nodemask
  mm: change callers of __cpuset_zone_allowed to cpuset_zone_allowed
  gfp: Add GFP_SPM_NODE for Specific Purpose Memory (SPM) allocations
  memory-tiers: Introduce SysRAM and Specific Purpose Memory Nodes
  mm: restrict slub, oom, compaction, and page_alloc to sysram by
    default
  mm,cpusets: rename task->mems_allowed to task->sysram_nodes
  cpuset: introduce cpuset.mems.sysram
  mm/memory_hotplug: add MHP_SPM_NODE flag
  drivers/dax: add spm_node bit to dev_dax
  drivers/cxl: add spm_node bit to cxl region
  [HACK] mm/zswap: compressed ram integration example

 drivers/cxl/core/region.c       |  30 ++++++
 drivers/cxl/cxl.h               |   2 +
 drivers/dax/bus.c               |  39 ++++++++
 drivers/dax/bus.h               |   1 +
 drivers/dax/cxl.c               |   1 +
 drivers/dax/dax-private.h       |   1 +
 drivers/dax/kmem.c              |   2 +
 fs/proc/array.c                 |   2 +-
 include/linux/cpuset.h          |  62 +++++++------
 include/linux/gfp_types.h       |   5 +
 include/linux/memory-tiers.h    |  47 ++++++++++
 include/linux/memory_hotplug.h  |  10 ++
 include/linux/mempolicy.h       |   2 +-
 include/linux/mm.h              |   4 +-
 include/linux/mmzone.h          |   6 +-
 include/linux/oom.h             |   2 +-
 include/linux/sched.h           |   6 +-
 include/linux/swap.h            |   2 +-
 init/init_task.c                |   2 +-
 kernel/cgroup/cpuset-internal.h |   8 ++
 kernel/cgroup/cpuset-v1.c       |   7 ++
 kernel/cgroup/cpuset.c          | 158 ++++++++++++++++++++------------
 kernel/fork.c                   |   2 +-
 kernel/sched/fair.c             |   4 +-
 mm/compaction.c                 |  10 +-
 mm/hugetlb.c                    |   8 +-
 mm/internal.h                   |   2 +-
 mm/memcontrol.c                 |   3 +-
 mm/memory-tiers.c               |  66 ++++++++++++-
 mm/memory_hotplug.c             |   7 ++
 mm/mempolicy.c                  |  34 +++----
 mm/migrate.c                    |   4 +-
 mm/mmzone.c                     |   5 +-
 mm/oom_kill.c                   |  11 ++-
 mm/page_alloc.c                 |  57 +++++++-----
 mm/show_mem.c                   |  11 ++-
 mm/slub.c                       |  15 ++-
 mm/vmscan.c                     |   6 +-
 mm/zswap.c                      |  66 ++++++++++++-
 39 files changed, 532 insertions(+), 178 deletions(-)

-- 
2.51.1


