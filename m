Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DDFCD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 03:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8E36B0088; Sun, 10 May 2026 23:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8636B008A; Sun, 10 May 2026 23:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 697A86B0092; Sun, 10 May 2026 23:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56CE56B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 23:30:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB77AC2092
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:34 +0000 (UTC)
X-FDA: 84753711588.09.EE65706
Received: from mail-m823.xmail.ntesmail.com (mail-m823.xmail.ntesmail.com [156.224.82.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id E5F0F100008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778470233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=BDwu7vuG7QoJDhXTOWutLGmq/qQUlWlS4HNH22UOJCo=;
	b=IavA3Ga9JLbs4pf9AlaigC2WYrRuwHT02Ze4wBLJLqrI04WZ8vB3EZNPRjbeeWRwxFQD0S
	pH+rbo0RMVkuKFTom0DEofBudWd908T5+36jvyLcPi7LXex7+K/q4R0ji48jJz8xJZXgnn
	ksw5xuM0WEPfgPmZtB6giywV+niplbo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778470233; a=rsa-sha256;
	cv=none;
	b=n3PBaEdomtc2WFzXLMNmdxLQmvFU1whd4jVg3R7LalckOJx7qDQZ5pYxatu9ZiW5lruFCi
	CnLgHUq/pqG4H2mCoa/EbiWG7mhkz90joSct92JE/hEKyDi8Ir1K6mrrJ7rZsB5SmdENtj
	snLpGHXgknG++i/e7qpBCkgQVXE4jJY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.3 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f36186b;
	Mon, 11 May 2026 11:30:25 +0800 (GMT+08:00)
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
Subject: [PATCH v6 0/3] mm/page_owner: add filter infrastructure for print_mode and NUMA filtering
Date: Mon, 11 May 2026 11:30:14 +0800
Message-Id: <20260511033017.747781-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e151605f50229kunm0464dab52dcef4
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZQh4aVkJJTBlKHk9MGhpPHlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5F0F100008
X-Stat-Signature: sjqc3ssxbsuw7efj9x49xc8goq51fxw6
X-Rspam-User: 
X-HE-Tag: 1778470231-691670
X-HE-Meta: U2FsdGVkX18cywJTpW/cSovIuGAQs8WadHQUhtOykkJOxbZqmHRI4HPemQy3BoSjQbzadoH6iTl1a3CS8bLKTLM5jHhEzvOK+C3Nn7jjypagvgY4SP1l7LlaYE8ou8lziNbd8hiTqpmPBJCuQyWrYglEHwxBR6AmrSQ0p8VpaiXiUP4xCOodS7gqmFQfwiWLoXWGBukjf4ZOslrPdrzVevNjpst4mR8BTE5fUYidnF5moC1skQWGEv0vs0WmEIHojlML1NAhoqH8EC6RjkO7aFuRo1VXLIEP6+23oaGBE/3e8S28asTpDkjBEZiqND96csMT0xSvQm3kPuQVVd4Fx0jkurzKbp9Pkunk5w1T9z6N0O2PMlCMcsHy+Cz+IbJpDmloET8SUDZFy+rTgFO6mwuureikpTyDwz7MXdST8hbTokmewDOdk3jb41ij4t2btTBRaLZTqzzi7aoX4g1tw7k269I3IZbOBY1uMkOM1a7q7kcPxy+4rKToDCQISjm0ffkF2j0bc473AcXuC8RXDU5/T52c8RoVwbEA7jNE1J4AjcIR7auKoJtc+Hir25C6qQXmHoiMrBeL32i/U8vkqCUkx7ldMg3MR2yQnM7EWATsmp6i33gM3HZtppE3wkzzkKpwiZncTcTGKzksuWpKowR7mzZOgWmQN5gb/BfZavW+fKu4Lcgsa7rj5wZWJxepYDd/EYTTgJkJB99k3yXaccvBQB/DtZA1Zme5n87g8kx8bIFk1V1RM7ULoH1r6SNzaoxqCBB3yZxsXzMtn/dtupKln7BfKtzM+0zMPDvEkdRsldsQpQ8jNr5RtpyMAHt+U5urgH2RiMkmTahRXmREzkmhj9asvzBFWaPNHHEtyrYAtY6HLbbANC5uxR+gEo4ttY1m66DEEt0R0J7UCTYYNOBvKRAhXBMF/PxwlM4SkQfHgK/6GtiTJhnGWxnImR8y1us7zGs+2+fAj/adWcs
 cKIJWJr1
 XFHeD0X5qIcol6ckerNQzPe6ueCC4K7L/6J3PmMMv46KNazl2IbqYKceGrIYJF0TL+UzVppNSuZ7nFERVvSRiRINYvcdDUiS6JZGOU9KznBbIinD13nOG3lW7mYdRgLVoSpiuvTEtv6Ev8+vvEDTToOKk+sAOSLKpFI7tQhT0mgmCU/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces filtering capabilities to the page_owner
feature to address storage and performance challenges in production
environments.

Changes from v5:
- Address SeongJae Park's review comments for patch 1/3:
  * Remove unnecessary braces in if/else statement
  * Use stack array instead of kmalloc for input buffer
- Address SeongJae Park's review comments for patch 2/3:
  * Add node validity check using nodes_subset() to reject non-existent nodes
  * Separate variable declaration and statement
  * Use kmalloc_objs() for consistency with kernel patterns
  * Remove 100 bytes overhead
- Add lore links to all previous versions

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
  * v6: Add node validity check to reject non-existent nodes
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
- Node validity check correctly rejects non-existent nodes
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
    # echo "10" > nid
    -bash: echo: write error: Invalid argument
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

v5: https://lore.kernel.org/linux-mm/20260507064643.179187-1-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-1-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-1-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-1-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-1-zhen.ni@easystack.cn/

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Zhen Ni (3):
  mm/page_owner: add print_mode filter
  mm/page_owner: add NUMA node filter with nodelist support
  mm/page_owner: document page_owner filter features

 Documentation/mm/page_owner.rst |  61 ++++++++++-
 mm/page_owner.c                 | 174 +++++++++++++++++++++++++++++++-
 2 files changed, 232 insertions(+), 3 deletions(-)

--
2.20.1

