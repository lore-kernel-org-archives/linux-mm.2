Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB91ECAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBB18E0012; Tue, 30 Sep 2025 01:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B528E0002; Tue, 30 Sep 2025 01:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43038E0012; Tue, 30 Sep 2025 01:58:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4ED68E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:58:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A2CC59BED
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:58:48 +0000 (UTC)
X-FDA: 83944862736.22.795E88F
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id 27229A000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:58:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHRgbqdU;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ihgFJK/hrdm2ozrNRIDtzWSBK8PaIduT7qsk3UXMbBc=;
	b=sUL1Yqa4a8vEP1RvfdJajrU55cR2JP1D+sUBPzleHrj+ly1Gh10gA+sb47Xp91mq31jIs4
	btsZc9eY4jJeAnn69HwyxgCC70EzAiyG3b6EBRgZnQ3IoqaQXcANULQuzsBUHEe/zbHyux
	WfStanCGMJKJjz26p/LQwt3rofgFKhc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VHRgbqdU;
	spf=pass (imf25.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211926; a=rsa-sha256;
	cv=none;
	b=yPPlFjMe2DxXPJlhofY1hwUVM5zCxg0O5lxNejB5njCAOJBWswxrHDUtiQSNXzYgavgXT2
	8u21ujQwmBwJhqXF/QvvstzldZwZtZKGJBNeY4PyoGEFrHL0JguwIUtaRAMuCCmzOqq1I4
	YuTCvmw+n7om1Ou/FI7eSHpJ42xOj5g=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b556284db11so5336547a12.0
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759211925; x=1759816725; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihgFJK/hrdm2ozrNRIDtzWSBK8PaIduT7qsk3UXMbBc=;
        b=VHRgbqdUga53jFhh0hwNYnYcFXYbieYNb5KrbPPsGEa7CmIBUEGgVvPdJ3ZMcWMMVP
         bmtTF4cR92nIwnVL1dUMtqBFXbmx8wO8HYbehlz6V6ePHiw0pGYJ6vejbWvAkinn9EtU
         1qHQCASqBXR6yyyTEMCOHg3VJdOGdeNSL1wX8mWEjRNgmM2qK2GgP0TUrYTp1yLWesDR
         WKLEAynws4eTk5u+wJQuXH70j6LAtTOIFxUohahEa6RuXNbXvBmczZ+653d1sglcUqxa
         IlOU51xCEY/4QW5jj937AVcSf9eopthkUak10WG3S067lFwdGJx9d/j1YC+sYE1vpvqQ
         /Uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759211925; x=1759816725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihgFJK/hrdm2ozrNRIDtzWSBK8PaIduT7qsk3UXMbBc=;
        b=F1Jv9PETrUxwi5uySLkegSMrwjP+Gq+M+VxBnHubHL+uVDUCzftGoSY41VBtXLPhJs
         624DxCzNSTgy2YjBJ/t2nyVDx+Z4aoB5HT5/ZXRMfVisM+m8uaihHWheTu6S8xaQD/9V
         d88r6k9Mn7+oU58rGrt8PAbCiiM+39Iz5CVY9YQmyphZHy/78o3rcVBIc+GZI18JZXwj
         8F6z58FYCZurPidN6fh79WGpfrXW+0f5SK6USzvU+rdNqWGwHqDSZHFGrXcT3W9kgbdS
         Cl7OHXZltI6aPSIJRH1JXAXQHUD0Vx3MMExODQlFqaq/pG2/Gp5pMMORqJxKsfoApIk4
         GiOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwtc24pTwPDQ1gtywtjdsZ7T1NVX8yPJjztuHVu7MFkbKDJss4uSvrBQosg4ZTdKbtBRgmGUfsDw==@kvack.org
X-Gm-Message-State: AOJu0Yx3pmMncHv8eh37Xi0O9vseFURMSLRVEeb+3DVQCc8aqUagkjb5
	Sbm8wbUC6FbYfqt5I6WVPGfRzhWHEwDmMWEutCyn4ThcwNQsjh8f0Kma
X-Gm-Gg: ASbGnctSSNAdWDz0R1ZduBi5pcTdHlbzcIpKvDOqXqNV6NSNfMrpdg4fyhWjPdVCLgw
	hc+MDToc02scXFZv53HvBDD5qNjwQWLamQgaESHjQ7AIxPxjcwjeulCyXwR15/cK74tgZtkfMgM
	UiPLqR2B1DGj5nQJaQ/AOkEyxks31AJz8nr6X8RiE+iLuCX4MmpYHAJKqk5o6FO44qDK+HDfO+8
	3JGyEgtK71oCgGR5Py3F0rCw3Hzo5NBz4y0YTKabxm2JMLNCedNuUQfS558Z6HPN8r8n9hgKrW2
	uvFU2mztf8ba5XsKbebbgq6DtnWUaoSs3fWuADVyjIn1PashSHa/13dkXRD+qE5t56RNe1LaW2w
	ZDnzn+YKlEQPE6Cxk8nq8tJfY8HuhPZ45YWh6T5+5KqMSJyH45z35bwapxmGVoPmVivvCF2wczk
	Max3aCQpkwlj9sJqBWB6iS5IHc7DY=
X-Google-Smtp-Source: AGHT+IFntPFFlj85fEiZeM5Pd02bKLRIUhwlROhx5OaOWZn/dQwP+mD9Ce3ho2TxRyVB5qxpNQDa5A==
X-Received: by 2002:a17:903:1c9:b0:24b:4a9a:703a with SMTP id d9443c01a7336-27ed49fceb0mr262128995ad.17.1759211924738;
        Mon, 29 Sep 2025 22:58:44 -0700 (PDT)
Received: from localhost.localdomain ([61.171.228.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed66d43b8sm148834065ad.9.2025.09.29.22.58.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Sep 2025 22:58:44 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v9 mm-new 00/11] mm, bpf: BPF based THP order selection
Date: Tue, 30 Sep 2025 13:58:15 +0800
Message-Id: <20250930055826.9810-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27229A000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: f9imdrcuyrxn7d14ae5jbpxjiimh6uwf
X-HE-Tag: 1759211925-514600
X-HE-Meta: U2FsdGVkX18iLC5PCO+fPYKPF2h/FG+NNCyiRbu25D+7QbWmQImzgoMyLc5E8rilrNljWKcNf/8vs/VrOkLxzEMnT4IfKsnSTHg5s6ShKg85fs1MpQCRBf2ej7DMwZDmMWBC+3DW8Q61owA1UJHiDVVaQ2ILvIkx+HHgGo3/PsXTixmRf0VpS0iJCMymgN/L92w6t1lk1ZWFqfvWtyKpceRaZDNiV9CN9SLJJeKh4TOUSCMN+jfmmrC5WMzFpH3mEJUCjoWgl7l6/Pqup9NdBCKt8428NEO5xx3gqLaa+bJnIs0+iH6MfzicNLgf4zD1K1NTOl61Pbjyg5Ccf0WNrJPct1fLNBx/kI61WNZ/lgcm3EUpy2VzvvEDoHAGgKWhrzR3cU0g2u/ej0z9Y+5pOEdqW/UqDhey5I45rRSIu2kCBG0MMm2p6uagS7mCVOySWeAsQzOzXywnRnTuiJ4iVB5UY4IeO4FFuvv4rXOASs9tdu011PHe5H5cCP2b+Rd/j/AvWyBkvvy+/f86zie3QCz2pv6ttbac2kWNW1WfT/NHnUbCDO4Klu0ybFjbs6osbvnGhQZnFRAvKsDaGihafu9RlIdtmkagJ7lulv8w5Ppzs/bPM7EMHKXrf1u+iIqemdS3njLP7xb0aCjXYBX4j9NdFJlWMZHRAI2+53lYw0/ncc8GCBEMVXlyoRoV2dXjUPzTBiJndAmSk5NQyZV7GuQjbzEZMAa56KA1bSRl3MQsne9HZIamS1RDNInYyNIL5pkOswUmnqjG9Z2821BN9EbA8S+O0k31/y7zPTTOuVBxWFGxdC3OWgh8c3hHEB9GQ8KJ9v/I90Pz3Nw33IL7O0hyyZTw+GgyI//EDlfmRmJYk1xWKc20E5ZP0JgMaGAcKzP6lMAL7PjsbIPRoWzOC+aCOvVtmTOPXOxOnkNmKm4pznztOTFAUJrqt+rhzWcsugr3HDMTj7JEW3oratZ
 sE+D4Bge
 tZjwnES8b/fl9OdnSun7ngu5pgEWGAJab3TicyFkwuQDX4LnKL3MGTGxfLtwOr0/nSEkN14EKuhunolwpukux14srx72kjGLmPiINEmBYag37IEa/wKixoxZsFHcDg8JVdRNXjg++2+NGqEDoUBZ5GwCrkptwhWAHq4bIbsbEAU6nv9BhK623pJv2KRCHVD9jhjnjP/Kb9Q6zdn0tE6ull5z+5KtmJc3QmVf+5S8dB7Vg8At37I2D6YFL/e5LCZcIS1qHKbpv7BUF7o70ADxHBcn8ADLFIgeIPaH0s4YY/k5amYLxTo715qjbExioQBNWqSPmRPAPd1oDGIO5BW/qoE6FFWkUtqdjmXvULC1GdNYCr1ceuOLGLL//0/Yyt4Y5XZTdrTui+rP1adtXJL0gHGcMdkqSCo56oPezjyH5BipcJBSQkCoNDwr6BCNjqu7Xirp4xzjzP2OgceAgXSADRhjE39G299zcJAcTN1IsCwzHdjcwFvOECuWtKvyxO8hBELCD8H2i+/xGpSrFHKVflReyXUIBFqEX/BY49CYl4ikrvSiP7p0DZLuoNH6IgWp1dGc/IDw5jyrFfL6bDHZopEidMzRzU/wFD70VAVnJW8MrXLLTkHtLm63nZQOkxlDV6pd27qz3VsgSCQqmRhlZxYE4HubcR/cT1MdoR1B9GkQRv9DVUb9YYMAKG/mIHi8ulSJsYF77eXW+a9+llWAyHTS5Qa2mf/52DSk/XioVhaOcREqQcGoyk8VvjrI4M36frPg1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
==========

Our production servers consistently configure THP to "never" due to
historical incidents caused by its behavior. Key issues include:
- Increased Memory Consumption
  THP significantly raises overall memory usage, reducing available memory
  for workloads.

- Latency Spikes
  Random latency spikes occur due to frequent memory compaction triggered
  by THP.

- Lack of Fine-Grained Control
  THP tuning is globally configured, making it unsuitable for containerized
  environments. When multiple workloads share a host, enabling THP without
  per-workload control leads to unpredictable behavior.

Due to these issues, administrators avoid switching to madvise or always
modes—unless per-workload THP control is implemented.

To address this, we propose BPF-based THP policy for flexible adjustment.
Additionally, as David mentioned, this mechanism can also serve as a
policy prototyping tool (test policies via BPF before upstreaming them).

Proposed Solution
=================

This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
THP tuning. It includes a hook thp_get_order(), allowing BPF programs to
influence THP order selection based on factors such as:

- Workload identity
  For example, workloads running in specific containers or cgroups.
- Allocation context
  Whether the allocation occurs during a page fault, khugepaged, swap or
  other paths.
- VMA's memory advice settings
  MADV_HUGEPAGE or MADV_NOHUGEPAGE
- Memory pressure
  PSI system data or associated cgroup PSI metrics

The new interface for the BPF program is as follows:

/**
 * thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
 * @vma: vm_area_struct associated with the THP allocation
 * @type: TVA type for current @vma
 * @orders: Bitmask of available THP orders for this allocation
 *
 * Return: The suggested THP order for allocation from the BPF program. Must be
 *         a valid, available order.
 */
typedef int thp_order_fn_t(struct vm_area_struct *vma,
			   enum tva_type type,
			   unsigned long orders);

Only a single BPF program can be attached at any given time, though it can
be dynamically updated to adjust the policy. The implementation supports
anonymous THP, shmem THP, and mTHP, with future extensions planned for
file-backed THP.

This functionality is only active when system-wide THP is configured to
madvise or always mode. It remains disabled in never mode. Additionally,
if THP is explicitly disabled for a specific task via prctl(), this BPF
functionality will also be unavailable for that task

Rationale Behind the Non-Cgroup Design
--------------------------------------

cgroups are designed as nested hierarchies for partitioning resources. They
are a poor fit for enforcing arbitrary, non-hierarchical policies.

The THP policy is a quintessential example of such an arbitrary
setting. Even within a single cgroup, it is often necessary to enable
THP for performance-critical tasks while disabling it for others to
avoid latency spikes. Implementing this policy through a cgroup
interface that propagates hierarchically would eliminate the crucial
ability to configure it on a per-task basis.

While the bpf-thp mechanism has a global scope, this does not limit
its application to a single system-wide policy. In contrast to a
hierarchical cgroup-based setting, bpf-thp offers the flexibility to
set policies per-task, per-cgroup, or globally.

Fundamentally, it is a more powerful variant of prctl(), not a variant of
cgroup interface file.

WARNING
-------

- This feature requires CONFIG_BPF_THP (marked EXPERIMENTAL) to
  be enabled.
- The interface may change
- Behavior may differ in future kernel versions
- We might remove it in the future

Selftests
=========

BPF CI 
------

Patch #8:  Implements a basic BPF THP policy
Patch #9: Provides tests for dynamic BPF program updates and replacement.
Patch #10: Includes negative tests for invalid BPF helper usage, verifying
           proper verification by the BPF verifier.

Currently, several dependency patches reside in mm-new but haven't been
merged into bpf-next. To enable BPF CI testing, these dependencies were
manually applied to bpf-next. All selftests in this series pass 
successfully [0].

Performance Evaluation
----------------------

Performance impact was measured given the page fault handler modifications.
The standard `perf bench mem memset` benchmark was employed to assess page
fault performance.

Testing was conducted on an AMD EPYC 7W83 64-Core Processor (single NUMA
node). Due to variance between individual test runs, a script executed
10000 iterations to calculate meaningful averages.

- Baseline (without this patch series)
- With patch series but no BPF program attached
- With patch series and BPF program attached

The results across three configurations show negligible performance impact:

  Number of runs: 10,000
  Average throughput: 40-41 GB/sec

Production verification
-----------------------

We have successfully deployed a variant of this approach across numerous
Kubernetes production servers. The implementation enables THP for specific
workloads (such as applications utilizing ZGC [1]) while disabling it for
others. This selective deployment has operated flawlessly, with no
regression reports to date.

For ZGC-based applications, our verification demonstrates that shmem THP
delivers significant improvements:
- Reduced CPU utilization
- Lower average latencies

We are continuously extending its support to more workloads, such as
TCMalloc-based services. [2]

Deployment Steps in our production servers are as follows,

1. Initial Setup:
- Set THP mode to "never" (disabling THP by default).
- Attach the BPF program and pin the BPF maps and links.
- Pinning ensures persistence (like a kernel module), preventing
disruption under system pressure.
- A THP whitelist map tracks allowed cgroups (initially empty -> no THP
allocations).

2. Enable THP Control:
- Switch THP mode to "always" or "madvise" (BPF now governs actual allocations).

3. Dynamic Management:
- To permit THP for a cgroup, add its ID to the whitelist map.
- To revoke permission, remove the cgroup ID from the map.
- The BPF program can be updated live (policy adjustments require no
task interruption).

4. To roll back, disable THP and remove this BPF program. 

**WARNING**
Be aware that the maintainers do not suggest this use case, as the BPF hook
interface is unstable and might be removed from the upstream kernel—unless
you have your own kernel team to maintain it ;-)

Tested By
---------

This v7 patch series has been tested by Lance. Thanks a lot!

  Tested-by: Lance Yang <lance.yang@linux.dev> (for v7)

Since the changes from v7 are minimal, I've retained the Tested-by tag
in the current version.

Future work
===========

Per-Task Defrag Policy
----------------------

In our production environment, applications handle memory allocation in two
ways: some pre-touch all memory at startup, while others allocate
dynamically.

For pre-touching applications, we prefer to allocate THP via direct reclaim
during their initial phase. For dynamic allocators, however, we prefer to
defer THP allocation to khugepaged to prevent latency spikes.

To support both strategies effectively, the defrag setting must be
configurable on a per-task basis.

File-backed THP Policy
----------------------

Based on our validation with production workloads, we observed mixed
results with XFS large folios (also known as file-backed THP):

- Performance Benefits
  Some workloads demonstrated significant improvements with XFS large
  folios enabled
- Performance Regression
  Some workloads experienced degradation when using XFS large folios

These results demonstrate that file-backed THP, similar to anonymous THP,
requires a more granular approach instead of a uniform implementation.

We will extend the BPF-based order selection mechanism to support
file-backed THP allocation policies.

Hooking fork() with BPF for Task Configuration
----------------------------------------------

The current method for controlling a newly fork()-ed task involves calling
prctl() (e.g., with PR_SET_THP_DISABLE) to set flags in its mm->flags. This
requires explicit userspace modification.

A more efficient alternative is to implement a new BPF hook within the
fork() path. This hook would allow a BPF program to set the task's
mm->flags directly after mm initialization, leveraging BPF helpers for a
solution that is transparent to userspace. This is particularly valuable in
data center environments for fleet-wide management. 

Link: https://github.com/kernel-patches/bpf/pull/9893 [0] 
Link: https://wiki.openjdk.org/display/zgc/Main#Main-EnablingTransparentHugePagesOnLinux [1] 
Link: https://google.github.io/tcmalloc/tuning.html#system-level-optimizations [2]

Changes:
=======:

v8->v9:
- Rename CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL to CONFIG_BPF_THP for
  future extensionis. (Usama, Randy)
- Remove the first patch and send it separately (Usama)

v7->v8: https://lwn.net/Articles/1039689/
Key Changes:
From Lorenzo:
  - Remove the @vma_type parameter and get it from @vma instead
  - Rename the config to BPF_THP_GET_ORDER_EXPERIMENTAL for highlighting
  - Code improvement around the returned order
- Fix the buiding error reported by kernel test robot in patch #1
  (Lance, Zi, Lorenzo)

v6->v7: https://lwn.net/Articles/1037490/
Key Changes Implemented Based on Feedback:
From Lorenzo:
  - Rename the hook from get_suggested_order() to bpf_hook_get_thp_order(). 
  - Rename bpf_thp.c to huge_memory_bpf.c
  - Focuse the current patchset on THP order selection
  - Add the BPF hook into thp_vma_allowable_orders()
  - Make the hook VMA-based and remove the mm parameter
  - Modify the BPF program to return a single order
  - Stop passing vma_flags directly to BPF programs
  - Mark vma->vm_mm as trusted_or_null
  - Change the MAINTAINER file
From Andrii:
  - Mark mm->owner as rcu_or_null to avoid introducing new helpers
From Barry:
  - decouple swap from the normal page fault path
kernel test robot:
  - Fix a sparse warning
Shakeel helped clarify the implementation.

RFC v5-> v6: https://lwn.net/Articles/1035116/
- Code improvement around the RCU usage (Usama)
- Add selftests for khugepaged fork (Usama)
- Add performance data for page fault (Usama)
- Remove the RFC tag

RFC v4->v5: https://lwn.net/Articles/1034265/
- Add support for vma (David)
- Add mTHP support in khugepaged (Zi)
- Use bitmask of all allowed orders instead (Zi)
- Retrieve the page size and PMD order rather than hardcoding them (Zi)

RFC v3->v4: https://lwn.net/Articles/1031829/
- Use a new interface get_suggested_order() (David)
- Mark it as experimental (David, Lorenzo)
- Code improvement in THP (Usama)
- Code improvement in BPF struct ops (Amery)

RFC v2->v3: https://lwn.net/Articles/1024545/
- Finer-graind tuning based on madvise or always mode (David, Lorenzo)
- Use BPF to write more advanced policies logic (David, Lorenzo)

RFC v1->v2: https://lwn.net/Articles/1021783/
The main changes are as follows,
- Use struct_ops instead of fmod_ret (Alexei)
- Introduce a new THP mode (Johannes)
- Introduce new helpers for BPF hook (Zi)
- Refine the commit log

RFC v1: https://lwn.net/Articles/1019290/

Yafang Shao (11):
  mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
  mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
  mm: thp: add support for BPF based THP order selection
  mm: thp: decouple THP allocation between swap and page fault paths
  mm: thp: enable THP allocation exclusively through khugepaged
  bpf: mark mm->owner as __safe_rcu_or_null
  bpf: mark vma->vm_mm as __safe_trusted_or_null
  selftests/bpf: add a simple BPF based THP policy
  selftests/bpf: add test case to update THP policy
  selftests/bpf: add test cases for invalid thp_adjust usage
  Documentation: add BPF-based THP policy management

 Documentation/admin-guide/mm/transhuge.rst    |  39 +++
 MAINTAINERS                                   |   3 +
 fs/proc/task_mmu.c                            |   3 +-
 include/linux/huge_mm.h                       |  42 ++-
 include/linux/khugepaged.h                    |  10 +-
 kernel/bpf/verifier.c                         |   8 +
 mm/Kconfig                                    |  11 +
 mm/Makefile                                   |   1 +
 mm/huge_memory.c                              |   7 +-
 mm/huge_memory_bpf.c                          | 204 +++++++++++++
 mm/khugepaged.c                               |  35 +--
 mm/madvise.c                                  |   7 +
 mm/memory.c                                   |  22 +-
 mm/shmem.c                                    |   2 +-
 mm/vma.c                                      |   6 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 287 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   8 +-
 .../selftests/bpf/progs/test_thp_adjust.c     |  55 ++++
 .../bpf/progs/test_thp_adjust_sleepable.c     |  22 ++
 .../bpf/progs/test_thp_adjust_trusted_owner.c |  30 ++
 .../bpf/progs/test_thp_adjust_trusted_vma.c   |  27 ++
 22 files changed, 779 insertions(+), 53 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c

-- 
2.47.3


