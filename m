Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B598CD343B
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85346B008A; Thu,  7 May 2026 02:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36526B008C; Thu,  7 May 2026 02:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CA06B0092; Thu,  7 May 2026 02:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1B986B008A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:47:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E9E0C1AE7
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:17 +0000 (UTC)
X-FDA: 84739692114.28.66E3C52
Received: from mail-m82133.xmail.ntesmail.com (mail-m82133.xmail.ntesmail.com [156.224.82.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 85623C000E
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778136435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LwbW02XS6GQHPblwoN32p3C52W4xO4/P3yIHCDNvueE=;
	b=6SX1/6VhiAOBf2qxB/3JACxEhkOnX11EjtqwZhPkIXSwlabD9680g5kTJWTOTQt6oNdSLp
	USnTKwmo4WOFlqwzprDwG6Dyp7AT56TghGRRDZGjtssNu5mTwj3gqqjoRlsn7lB6hrgvht
	FhO02+jPhl9NHXNaiLajsJfwSpGkpSA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778136435; a=rsa-sha256;
	cv=none;
	b=U24M0jc1c3RzrGb/1oGYWxKxtqFXWocMwQAShjMljngCimwkls6iF/KK/Qxw7oFFxLvewY
	umr2gFlWPWpoS5oa3pmc/BkKfX4tQKTv4B7FEXnpSQFbGAVerXNHehEPYvl0v757C0f6EL
	HMEEKAWhHsDSEz5yANQWMWbYrGNmyJU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf22.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.133 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19cdddfaf;
	Thu, 7 May 2026 14:47:05 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v5 0/3] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Thu,  7 May 2026 14:46:40 +0800
Message-Id: <20260507064643.179187-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0130a3e40229kunm3f68df491bc93f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHklPVktCHUIaQkNDSkxLGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85623C000E
X-Rspam-User: 
X-Stat-Signature: 6ahdzdjpjt9631yuhryxphtw4tujhmkd
X-HE-Tag: 1778136434-239864
X-HE-Meta: U2FsdGVkX180KQ25+EoDkos+y2BYGsQRn0JXoaz4K6XMBpbnv94z81UOkl8HNEQe0xMdRci2iDcoYkJMiHDmhsy7C2GrCpwF72whB9xDifSTV320fE9ty2h2XYE3sUa1ij78yG9+hyzxOMBhFLRHTpoVR6/oRaBzU0Psuk3pP1L/mbtmXHj6PjLn8nMw/AWO3mwPA5i8PM/voO7ZowVqNHuyG6OpHs7u30cLd/cfA+vNhPkn9QDzkR3hPqZKdTxW6QNc4nT/5HYd32ipWLkLMwI8KJ/yLe+l4CZ6VRxkRSNQueHfqoPZT24sh+Ga25tV5eVXVLDqqSDvPIbLY0tc3X9/8/X2d0XEkU0SkFO40H1BmHiHHHRrIYGr6U+MClP1sLnBgQ1GxloEPK79FsVjj3Rb8F3gJHgxU1EdzV5OgV69slQta2Hyl7w3SfDlB0tBdqiVl/ZTCXx6lqXw+FZxWGMPbC/HEZrqZbXSVs8oiOWgNO0HYtGgLwHgNhwFZ9fXePq5hizQOL75o8cKRvVBDru84ChoU2GOpgFUzH0lC4ZsLh4TZLn8+bMPFq9xlBMRx6+VDtl6/mwR5DwphG2x999Tw3aZCB8QzpTEHkZL/NM1RhdLwLVW1hGuzETjHVVSOwmpHjXJCLUZwJbYeUnH+3acU9L7Mnhhp2Ovc8bfBTUiOYWEVOfkh9MUyyLB5tIhUo+U1nwkad5WU6mZmVCpF7JDmid57YF+O3Qqt+paDu9l3tEgX/g2jevybxlzaVU16w9xTTGMnjZSKR+XVS1QuqMAeZFLNlwb8bAJuFWtl2AkCmCJ18IU7i4jwBM2jyghUPesy+ti1nieq8VBJ44NxCOhMcgpETFAAUZNXr45RcrRX5tD9sm1aaKIdaiRzZgNwng5XT0dHz97IhbF9dMnA1l6dOrgczSxAIORasUDxOs6GUv2m77tAUAk2nlcE735qY7r4Xw67aXg3VvUKqf
 F7/CCfl9
 qWb2M2dmmZWrto0z0XaYWd/pzVU/ecFr3ES/270R7ha9KJLHC4h23IZcQqYi9i25/L2nxMzQwUhhrgS1RIwXfssZ92EMvtcNI700BO0jl9tAkA1sGa8wu1Q3C64CPkJ8uYeUH9EdevItNBUxxlX+3SKjd/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

Changes from v4:
- Optimize nodes_empty() check in page iteration loop
- Add __data_racy qualifier to nid_mask field

Changes from v3:
- Change print_mode from numeric (0/1) to string-based interface
  * Use "full_stack"/"stack_handle" strings instead of numbers
  * Display current mode with bracket notation: "[full_stack] stack_handle"
- Remove "-1" support from NUMA filter
  * Use empty string to clear filter (echo > nid)
- Use strncpy_from_user() instead of copy_from_user()
- Rename nid_filter_fops to page_owner_nid_filter_fops for consistency
- Merge patch 1 (infrastructure) and patch 2 (print_mode) from v3
- Update documentation to match new interface
  * String-based examples
  * Tab indentation in code blocks

Changes from v2:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
  * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
  * Direct assignment is safe for this use case
- Add comment explaining input length calculation formula
  * 6 bytes = ",NNNNN" (comma + 5-digit node number)
- Simplify "-1" check using kstrtoint() instead of dual strcmp()
- Move nodemask_t mask read outside PFN iteration loop for performance
  * Avoids 128-byte structure copy on each iteration
- Add documentation for filter features (patch 3/3)

Changes from v1:
- Renamed 'compact' to 'print_mode' with enum type for better clarity
  * PAGE_OWNER_PRINT_FULL_STACK (0): print full stack traces
  * PAGE_OWNER_PRINT_STACK_HANDLE (1): print only stack handles
- Changed NUMA filter from single node to nodelist with bitmask support
  * Uses nodelist_parse() to support "0", "0,2", "0-3", "0,2-4,7" formats
  * Uses nodemask_t internally for efficient multi-node filtering
  * Output uses %*pbl format (e.g., "0-2", "0,2-4,7")
- Improved memory handling in nid_filter_write using dynamic allocation
  * Limit: (100 + 6 * MAX_NUMNODES) to handle worst-case input


Problem Statement
=================

In production environments with large memory configurations (e.g., 250GB+),
collecting page_owner information often results in files ranging from
several gigabytes to over 10GB. This creates significant challenges:

1. Storage pressure on production systems
2. Difficulty transferring large files from production environments
3. Post-processing overhead with tools/mm/page_owner_sort.c

The primary contributor to file size is redundant stack trace
information. While the kernel already deduplicates stacks via
stackdepot, page_owner retrieves and stores full stack traces for
each page, only to deduplicate them again during post-processing.

Additionally, in NUMA-aware environments (e.g., DPDK-based cloud
deployments where QEMU processes are bound to specific NUMA nodes),
OOM events are often node-specific rather than system-wide.
Currently, page_owner cannot filter by NUMA node, forcing users to
collect and analyze data for all nodes.

Solution
========

This patch series introduces a flexible filter infrastructure with
two initial filters:

1. **Print Mode Filter**: Outputs only stack handles instead of
   full stack traces. The handle-to-stack mapping can be retrieved
   from the existing show_stacks_handles interface. This dramatically
   reduces output size while preserving all allocation metadata.

2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
   using flexible nodelist format, enabling targeted analysis of memory
   issues in NUMA-aware deployments.

Implementation
==============

The series is structured as follows:

- Patch 1: Implement print_mode filter with string-based interface
  (merges infrastructure + print_mode from v3)
- Patch 2: Implement NUMA node filter with nodelist support
- Patch 3: Document filter features

Usage Example
=============

Enable print_mode and filter for NUMA nodes 0,2-3:

    # cd /sys/kernel/debug/page_owner_filter/
    # echo stack_handle > print_mode
    # echo "0,2-3" > nid
    # cat /sys/kernel/debug/page_owner > page_owner.txt

Sample print_mode output (showing handles only):

    Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x40000 type Unmovable Block 512 type Unmovable
    Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

    Page allocated via order 0, mask 0x252000(__GFP_NOWARN|
    __GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 0, tgid 0 (swapper),
    ts 0 ns PFN 0x40002 type Unmovable Block 512 type Unmovable
    Flags 0x23fffe0000000200(workingset|node=0|zone=0|lastcpupid=0x1ffff)
    handle: 1048577

Testing
=======

Tested on a system with multiple NUMA nodes. Verified that:
- Filters work independently and in combination
- Print_mode output correlates correctly with show_stacks_handles
- Default behavior (filters disabled) remains unchanged
- NUMA filter works with single node, multiple nodes, and ranges
- String-based interface works correctly ("full_stack"/"stack_handle")
- Empty string clears NUMA filter
- Code compiles without warnings or errors (allmodconfig tested)

Example test session:
    # cat print_mode
    [full_stack] stack_handle
    # echo stack_handle > print_mode
    # cat print_mode
    full_stack [stack_handle]
    # echo "0,1-2" > nid
    # cat nid
    0-2
    # echo "0,2-3" > nid
    # cat nid
    0,2-3
    # echo > nid
    # cat nid

    (empty - filter cleared)

Future Enhancements
===================

The filter infrastructure is designed to be extensible. Potential
future filters could include:
- PID/TGID filtering
- Time range filtering (allocation timestamp windows)
- GFP flag filtering
- Migration type filtering

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Zhen Ni (3):
  mm/page_owner: add print_mode filter
  mm/page_owner: add NUMA node filter with nodelist support
  mm/page_owner: document page_owner filter features

 Documentation/mm/page_owner.rst |  61 ++++++++++-
 mm/page_owner.c                 | 179 +++++++++++++++++++++++++++++++-
 2 files changed, 237 insertions(+), 3 deletions(-)

--
2.20.1

