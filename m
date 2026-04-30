Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CA8FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413B76B0088; Thu, 30 Apr 2026 12:49:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2156B0092; Thu, 30 Apr 2026 12:49:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B6D6B0093; Thu, 30 Apr 2026 12:49:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 140206B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:49:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C98261209CC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:04 +0000 (UTC)
X-FDA: 84715766688.19.8061531
Received: from mail-m823.xmail.ntesmail.com (mail-m823.xmail.ntesmail.com [156.224.82.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD718C0015
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Yop29xIRoFCvVcrmFZ2dlcbOxMkkQWMntQKDNXZnuIk=;
	b=IBvtD9rTvUwJp2SSe+cGB5F4DpVzvTMqrk6KNTuZxHvG7vKBlYh80WXjW1KZ0eVUT5PWT4
	paoTTmB+FmjK/KiNjYMeWba+iZg2ZRA8wi7kYXgj8IOxJ81kOcrx2VU35lBtcIH0GK7s0R
	vnkvBCwqXJCVxbZX1ftJoSF1vndYNGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566783; a=rsa-sha256;
	cv=none;
	b=Fhl/7ldLCtypIr6qlVpI54yO45iHJYhNX1lMwc3w16o1Fo4xHkVpdes52CR9kSbTm/1xkO
	KQ1dNXdnniqifZczE3tZD3rdBJralc/0fg5eKXF1Pw+Nud+9lDMGHQCaRmXtWgi15kij0E
	20dd5cHppvZSJZ0tx8hT//qiC8nOx40=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:e24:8c24:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 199a96d4e;
	Fri, 1 May 2026 00:32:56 +0800 (GMT+08:00)
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
Subject: [PATCH v4 0/3] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Fri,  1 May 2026 00:32:44 +0800
Message-Id: <20260430163247.13628-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddf3c7c1f0229kunm7d32d45d8a80
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSB8ZVh1DHk9CHh4dHRlLTFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklPQUMYSU9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD718C0015
X-Stat-Signature: xgbxfgi1xwb9wqpqf4844azkyxy1om15
X-Rspam-User: 
X-HE-Tag: 1777566781-284484
X-HE-Meta: U2FsdGVkX18aXhYtsAa/PEDllt8w7YkLLzOjlzYy5VW+HJsqX+99/N4qucy0OMd6jqMG7C6yilKahqlp0hPu9Uw4FES0dmNLGd5vSsVgcN5IMxSBeF4Shjkwl3DOtVImRin0CG9WhnjFO3E51j5CELIDfxUoXhAGTt9upY8VfXU6pgyiV/m6XkIjjAilB1EGnz5N/3h+GoJHJWm7aB1UvcoBKsaMcZ9Qfzxiq31bhHUvoAN8m8/KlHthA3Aq2RKHbuqnyqtiKS8F40S8Q6GKC6VMwtScC/HTmY1FZkeEvL3pyltKCtrtn4cPHqcWx3+lR9yku+v9uZWs9uS4MHVby140DJvXBVWVq96CgsAKVnDOhcKwiko3JIPIn48pZg2fNBPW8Ey5T5CfN9ivZvKykjVl1gyCTmI2x5sWwqmVuroiSKokVquI3FhOIUJusSuOoW5zm9PWwsIC5pvFXfYKYwyYncaBMvWkOmiseHvagZX6QsX0EYKCmye9/S67fzKEPU7wlOZISXpQHTPJdbKwEgVa8XCU+38DCFMMXJSBQhhTkcjx3PfN2up3fmxhDU6IPreNlLN2Yw2TGrC5u0jj1Z5a2gek9oahdKYAz/6xE2ODVardVltx2Jli3imPUhScDKHwq7YbztSApzf5JaGSJwSfkPwZDk9JSuqbmNC9ECx9V6SZM72N717Mrq9Oy3scSfyuzTHHmu6winCXyC0mP3uALC/nvuRZCLsMuJckx4JQfqR5GYs8my/UuFJoKPVPp7dldEVP4bhweveXEf+ZvdmuwSSff/okc+YPdXkgYxRzfeDas7xpPpZO/lXsjnT0QLFWir20npn3tV45+tqcBnoVhFoZoyaQFvahBLNlcERrPC2bfXNeCdfLuZ8/3ZyYMdDK5zQuZUim7Q6cyaYmNaWkX17l/frqqEXKJhTpqFqMEitOm0x4k2PEbP2TaEI14YZ81x3mk/s4dSJzIaI
 KdtxWZ9D
 Ylp6jxToBczluHsPcacnE1/y/rUEenJ2kr06WSQfk5YFonlz6w9CWSeWpTK5KjmETM+FDMfeQQTzH+QFtms8MA5oeIig7Avji59A1Mo7TA6E+08MOdQyo5AuhTgxhUqOFRAgKfjyfHTxeOG8brs/dNcl4/N9zCJ7z78pcwPqGUUs0qcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

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
 mm/page_owner.c                 | 180 +++++++++++++++++++++++++++++++-
 2 files changed, 238 insertions(+), 3 deletions(-)

--
2.20.1

