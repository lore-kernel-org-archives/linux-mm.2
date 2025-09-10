Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50F2CAC582
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB306B0010; Tue,  9 Sep 2025 22:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2E06B0011; Tue,  9 Sep 2025 22:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9006B0012; Tue,  9 Sep 2025 22:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264E36B0010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:45:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B692686E14
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:07 +0000 (UTC)
X-FDA: 83871798654.04.A5F56AC
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id E93512000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:45:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJ7Hc4pj;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ECymoV0afChIph3b2IQOw2gRJYGDzpM8kCcLRfRhoGM=;
	b=ujLsmj2YTeXoXIUZWfXfDY/4v6Wjo592P4SveFSJU3Hyrqxd0PmEVg7f1v167h6talCdaP
	ZGXOjPOnakc7xe5PWXxXA6wokSyfJWlsrXbQARk69WhDhy9KY9fGjPldVdvT8CwM5CedMc
	Pi3ajap5IGe8ycJHBplAbzaiWBALDV0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PJ7Hc4pj;
	spf=pass (imf13.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472306; a=rsa-sha256;
	cv=none;
	b=y9yXiAHznc6nsDrWCU6uHSZhNA4OQxQT6iZQtFPHZPPRppB8A8y05IWjC3cEpxPXYLX8nR
	CTMILmv8K6WNC6dj3AX+CG6ssV1k7sg2aYjN4RLj+d9g0Vqd93rh6mmBMUPxHkXZqh1FEe
	QI6YKhWewPY0JJWx1IlRZRhZrcftvNY=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4cb3367d87so4272645a12.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 19:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757472305; x=1758077105; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ECymoV0afChIph3b2IQOw2gRJYGDzpM8kCcLRfRhoGM=;
        b=PJ7Hc4pjb9FndDK65+HkBt8iJgPiEHQfG3PHcAdsU1673pLKIso0s2/VMVgNexgv5d
         h2P2s6N6SbKWB9t79rtW11Xqy85KofCDdlj2ZGM8SKgkxNHjBOKaCbnLkH+iCvg/63l1
         fm1Xqme4z38POXb2V1/VlPp1PcsZON7ogGJe54k6sfgaHm6evinWDbWydjSfjYyeXh3g
         3t8WFUNyV/pZvWoP3O6BEKgok0zEOlSlnmJ5bX4fXCSZNFOn3m44xDNKla0KYidrinRH
         Zx675Hr0x+AuitrO/xg5wvYDnSYvYgBQCx42bMj2odxCK5l7/ALA/7bniXi6c0OjRhe8
         V9Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757472305; x=1758077105;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ECymoV0afChIph3b2IQOw2gRJYGDzpM8kCcLRfRhoGM=;
        b=IR9egS/8gbKfixwDL+uA+SyqjoqkI9nntpPzEBgQvDMVdTU8XHhCnCX4Fewkm/Yrc7
         9+Umsx2aojIop36hUgFZ+PsfMnMeY3yDlZZFOucWK33CnYFLlqnh21ibRM6C3caJ+Rm1
         QUL5zvvCY23RJbKn8pjjRpoRl+f34YatdX0yhkZyk/JD+bAqplYCEaYLnSCgVOI4nQVb
         +a5GtZvq18R8XybIn5CgB4djJDykhQUigzpdNE7rRvDHxr/fL9uVVmkEbgRQR5E4ENll
         b3Ox0ZxyE4LK+BZQnsDXM+Aq4u0W9egfI9za9k5LO3EvKle3MESni7fubRzrD4XKY06v
         +RBA==
X-Forwarded-Encrypted: i=1; AJvYcCWUdZhNCMy1KFTITnopygj4Z3v9n+D97lzLzIIPBACVkM/8GaCqZu516Q+hqF5SfQjFuDHy+mvidA==@kvack.org
X-Gm-Message-State: AOJu0YyyDN2DCwrOG6IHKa2e/tI49go+jvrkoXlDwro0DZBPNuMxT/zE
	k0fpKTFTFlxroA9vWdVPmw8OqDvQQJt9n1aO7wpczRWRfK84CjbjUktt
X-Gm-Gg: ASbGncuaiUAQADlVDycZBXC6s/SlKO4MO407hwcNtrJVUpehyz7AAzCuXpg4sKp2g9h
	/s5hMQqu71K6kZVd6VYUpZrBagbrNANoe0EG1n5ewGGD22lYgCgxzdlgW3alf2RjKou4XaH3jbF
	+40du78tee9XX5nMJdGwzT1nYep/jUjgGUohRBYyRmeBuRwPg55qKeLnBcn0i0k40JQvRsDHJfK
	QsUqr5B8VCIbGKa38KnZR3uSt/piiBS0gqqjMA5cT+pa1UNtOnCoUIusGQ8akf+mBrMgnZje7dd
	uhWuwqiv861edVaQepmisFhsjPTsUMUY1hLLtPAKXewXrk/MqCxEcb+kiCBvw2MeIJl8NSzE0iN
	ubY8Q8RZyHVhV1/o1qlmuk4WTaEfEvnvPABhnWawrCnOsh5kDvdgutLvdhzApWp2akp5vFeV9kc
	3bK3rlSGY+ehGBog==
X-Google-Smtp-Source: AGHT+IGVVMHoxwQuixztdbo1+fcy9gAa8fVWkaDB65TP0G/V80AaCegKULeF4WMABeBE44UXwnfeTg==
X-Received: by 2002:a17:902:e802:b0:24b:1625:5fa5 with SMTP id d9443c01a7336-2516d33edd9mr221042545ad.11.1757472304575;
        Tue, 09 Sep 2025 19:45:04 -0700 (PDT)
Received: from localhost.localdomain ([101.82.183.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dbb314bcesm635831a91.12.2025.09.09.19.44.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 09 Sep 2025 19:45:03 -0700 (PDT)
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
	shakeel.butt@linux.dev
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v7 mm-new 0/9] mm, bpf: BPF based THP order selection
Date: Wed, 10 Sep 2025 10:44:37 +0800
Message-Id: <20250910024447.64788-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E93512000E
X-Rspamd-Server: rspam05
X-Stat-Signature: jy1sr1humajwqa3i4agdbsfwxjek9c51
X-Rspam-User: 
X-HE-Tag: 1757472305-648894
X-HE-Meta: U2FsdGVkX1/OMJlF/6M4Lw5dqM71py9WEbI4Z0jCRSaoXu+R+qJRAd5nUb0fKtaEr6Ec1j+Ofm13Psjux7T17T9+qeURdw0RsjKFknTRLYWS1U16spLvvg7ySGn5UO3jQMx/HCoJrGDpNrfRL4YGlhI+6vCbE6p0o6Y6DOQ9wWu4L/yMcTQ3yTa+3nLVnoDbJP6Y/zao1juOYHH/Z1Wu6sgYSsQYDsfEOVRci91PDJM9aBFC5arkPLgP+uq+QcRIlbAQZoSka5nfb5pigRzNSSMvBmdb6zMi9nJ2RR0TIJNz1UxbpAqOXuUwzwp0wnVMoJqKBMebuA5jGegqsezFOtddG2wVfwpBTKREtq07fCB7CpapHRSJ/BJkGQtKHKzRoiraLKvd/o6gZWfPh/D+ZwXTTpTfRf8edYqVBwnf3gsDch628oMSUsgsgMeHbGuJHY9oDNgYzwuQ28Es53LmgjoBOOUrITk05byIlvaI3HdZXpOCcylU0kJQnIYxkKeLa1VNUOFYDiqyiRWcUknKi/6KTR5gKI1G5KBToEMDSQrt9+Bs1YfhxBT457mBlATl7Buw5pb5QQgKnut+kl+PwgX2RCx4FtnkSZ3hzKgBUNmu0WAABbDgrYoTgmBIOQcIhRyNYUHq7Ntm7WIgHONd/YFGowN0l29MPY+nv8zoGRID/qA5vcclYNzC91BM3aFWSD9QFKfAeQG0p3BkxLtUUaeQQNNqmMAhZKAySYAKTgMDdI/O9GK3MTKKxSDRINhfMI1++CrKd/Wdoa24Bfjp0TaHkdAaT9k7D1cGL2u/7dJyp4k61aGlhZVBwKb1N/pvVluRw5RJ98Vt9E/Qvy3NfaB6WXwaPD/YzZM/aWpfOx4B043ydYDQdeUtwHbWRJJDxDq72SB5QxKSyccKMmzBwNfCt1Fv1DFMhezdYdKZ/mKFLf9tpu+xKH5NV8/LlDDCps5G9ADNFTfeTTPN7ma
 a58XoMzk
 w8tP1mO5yCI2X6vaigixsPwBAyaFEkX+9JXKcXrLCxh1iEDGPr2acDFtuzEgBMNXvxL21COvL9kVXoHWla7/vMiuYuQveJKF8uWGBZFv37NVcScZYGJPDhqpXjKJQQyEgd/Af
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
 * @thp_get_order: Get the suggested THP orders from a BPF program for allocation
 * @vma: vm_area_struct associated with the THP allocation
 * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is set
 *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_VM_NONE
 *            if neither is set.
 * @tva_type: TVA type for current @vma
 * @orders: Bitmask of requested THP orders for this allocation
 *          - PMD-mapped allocation if PMD_ORDER is set
 *          - mTHP allocation otherwise
 *
 * Return: The suggested THP order from the BPF program for allocation. It will
 *         not exceed the highest requested order in @orders. Return -1 to
 *         indicate that the original requested @orders should remain unchanged.
 */

int thp_get_order(struct vm_area_struct *vma,
                  enum bpf_thp_vma_type vma_type,
                  enum tva_type tva_type,
                  unsigned long orders);

Only a single BPF program can be attached at any given time, though it can
be dynamically updated to adjust the policy. The implementation supports
anonymous THP, shmem THP, and mTHP, with future extensions planned for
file-backed THP.

This functionality is only active when system-wide THP is configured to
madvise or always mode. It remains disabled in never mode. Additionally,
if THP is explicitly disabled for a specific task via prctl(), this BPF
functionality will also be unavailable for that task

**WARNING**
- This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to
  be enabled.
- The interface may change
- Behavior may differ in future kernel versions
- We might remove it in the future

Selftests
=========

BPF CI 
------

Patch #7: Implements a basic BPF THP policy that restricts THP allocation
          via khugepaged to tasks within a specified memory cgroup.
Patch #8: Provides tests for dynamic BPF program updates and replacement.
Patch #9: Includes negative tests for invalid BPF helper usage, verifying
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

Future work
===========

file-backed THP policy
----------------------

Based on our validation with production workloads, we observed mixed
results with XFS large folios (also known as file-backed THP):

- Performance Benefits
  Some workloads demonstrated significant improvements with XFS large
  folios enabled
- Performance Regression
  Some workloads experienced degradation when using XFS large folios

These results demonstrate that File THP, similar to anonymous THP, requires
a more granular approach instead of a uniform implementation.

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

Link: https://github.com/kernel-patches/bpf/pull/9706 [0] 
Link: https://wiki.openjdk.org/display/zgc/Main#Main-EnablingTr... [1]
Link: https://google.github.io/tcmalloc/tuning.html#system-level-optimizations [2]

Changes:
=======:

v6->v7:
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

Yafang Shao (10):
  mm: thp: remove disabled task from khugepaged_mm_slot
  mm: thp: add support for BPF based THP order selection
  mm: thp: decouple THP allocation between swap and page fault paths
  mm: thp: enable THP allocation exclusively through khugepaged
  bpf: mark mm->owner as __safe_rcu_or_null
  bpf: mark vma->vm_mm as __safe_trusted_or_null
  selftests/bpf: add a simple BPF based THP policy
  selftests/bpf: add test case to update THP policy
  selftests/bpf: add test cases for invalid thp_adjust usage
  Documentation: add BPF-based THP policy management

 Documentation/admin-guide/mm/transhuge.rst    |  46 +++
 MAINTAINERS                                   |   3 +
 include/linux/huge_mm.h                       |  29 +-
 include/linux/khugepaged.h                    |   1 +
 kernel/bpf/verifier.c                         |   8 +
 kernel/sys.c                                  |   6 +
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   1 +
 mm/huge_memory.c                              |   3 +-
 mm/huge_memory_bpf.c                          | 243 +++++++++++++++
 mm/khugepaged.c                               |  19 +-
 mm/memory.c                                   |  15 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 284 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   8 +-
 .../selftests/bpf/progs/test_thp_adjust.c     | 114 +++++++
 .../bpf/progs/test_thp_adjust_sleepable.c     |  22 ++
 .../bpf/progs/test_thp_adjust_trusted_owner.c |  30 ++
 .../bpf/progs/test_thp_adjust_trusted_vma.c   |  27 ++
 19 files changed, 849 insertions(+), 25 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_owner.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust_trusted_vma.c

-- 
2.47.3


