Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82939CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68EA6B008A; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FA26B008C; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9555E6B0093; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B86E6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE9DF1C4A96
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:11 +0000 (UTC)
X-FDA: 84891675582.12.2C43310
Received: from mail-m82158.xmail.ntesmail.com (mail-m82158.xmail.ntesmail.com [156.224.82.158])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1ECA94000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.158 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781755090;
	b=zAmRhLhz9f0IuF+CYhwowj7Q3+A5ZjH/c45l0ueCAcfgLuX5O/gN+izbUqk9nDPcLG7+6m
	t9Hr16UduuBn5FbAP+vheI998xSbNRwAa6O+CvGBrjrL4pWBEQFuKs1KOGw+j1/6/xTxL+
	wEmu5y3ViMI8MOOoVTd4AkHZhLXrKBE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.158 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781755090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EdT8F8/iHbtDtsFNS16mcMDefpy3F3ytk23hFfO+Y7U=;
	b=Gzs01lhDQWsMvgjZEcihxUnRyOaNhGUqOCULV6IYh7w8a5HF4L7EcI51uM6IjvfYXflBbP
	o+J6V/q4rylBDvN4Lz+lrU1zCWp18HPYXQ9GSFCxhtjjY1cFdC40ySawRUnpmbZyKJWzv8
	NMcjWu7BMehPi+B+c6NFcj60EGZ3E7o=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b9899908;
	Thu, 18 Jun 2026 11:58:00 +0800 (GMT+08:00)
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
Subject: [PATCH v10 0/4] mm/page_owner: add per-fd filter infrastructure for print_mode and NUMA filtering
Date: Thu, 18 Jun 2026 11:57:46 +0800
Message-Id: <20260618035750.3724613-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed8e0f0610229kunm88c9600fdda74
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHhlJVkxLTkwaHUhNQkodSVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1ECA94000B
X-Rspam-User: 
X-Stat-Signature: a5oq14aqparpqftgr7tohtq1tixmmqxx
X-HE-Tag: 1781755087-277941
X-HE-Meta: U2FsdGVkX18Zy9xL6vp0FjjNYP/cdth6UZtIU1Pvm9rZES0tM/+u5BvLHQat8y1O8OmKhQu8zS7F22KZbh8hdn7aJcFbnUxNRht915jMKHFEXAYco85yEBpdU7I7rr4CgRZ70NW6eYRYAm/XR/pQClqKJrnNm1fXtwSwWrABqOmFd/HmrMNsJrVqqsORe28qN7WhGQYId0az+TtyHnHaAoCf5LM+I5+DM2z4EETq2TAZYl1kw3fqa+ZRrncqE+GvJpafvrwSG02kUwMKFfgOK3ItvtPyPyNAZRYi5u+daleulWZKuGwM04f7lkRyCNQSmFOLOEwt6gEpCikz6c0TA7dm0DP1I8ev6bKvatdTLuHVnj23KJtbUp8wWWukQeoujvVp9tLe7Isw9yJKfVrXkkuyWOnTt0DTuUWVDRK3/MAeI2wlR2s9fOUtqgW4ei+zJzwDlsgMieDE593kKvY2Dp2UAc5IrU/kAXKmvlsfhbmIv4c4ronr90qVchj6EAkvv90IOVqafEHQ/3C+AwH5EHYcieHc6IYcXZwkjNa8SeHsQvrkR009CCXNSlPTGq0Iobgu77ScEdjOx6evDvNL4hD5pL8ygd+iiS8ZYH3F64+DI57gMpwjSb0gTfSu5X7hMlL3R4oHEam7EW1e9a17mgMIelZG/6BbqgIwPJepsueUfjEwkUNJnRR3JREMenNtOcOH6XtxxfyPbJk9l+/zvzTWQzD/07d+HGtRm7GNPQAaslk5/7DH4iyLUB2n6ByIIvpEA3qLm4a92xLYFfZx5tm+82jSk1fAQENwQjKD1GiXQaVQUSeMsyYx8Irl4FWy1Wb4jSdYMKXvx8/TCGdn5Q/XsLOvycrE+n+NjDqR3mQQnsh04AQ+or6m7CTwHXpSlL2+ysNDny8rGG7KLTm3mdpHaZed31Bm/X9zY4a0SVAZZXR616o8sVn3NNteyublu/Vhq+tATJ+B7Sxheji
 kT5N/ChE
 raulnxYZnEgDxrnFvNMqre2lp4/J7qUo8hhsaMv3sdSeJNfL6kqHWa//t1re8R/lDySQ+vBaF+4j0TKIJLsUfbnd6Cnd4CMpgS3RsYAff5fd/5+GUw8ogQGR3rr6Eafns7fJcNJsMtZ4eOeGnn6FEAVCg/ysHuZTm5t5W3fj5RWaxQjFT2od/vgHTRN8pzEoXDqg1+31VincdlAE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces per-file-descriptor filtering capabilities to the
page_owner feature.

Changes in v10:
- Add 'nid' member to struct page_owner and record it at allocation time
- Remove cond_resched() in page iteration loop (unconditional call)
- Improve error handling: check fwrite() and fflush() return values
- Handle EPIPE correctly: treat broken pipe as success

Changes in v9:
- Add spinlock_t lock to struct page_owner_filter_state
- Use memdesc_nid() instead of page_to_nid()
- Fix isdigit() usage
- Optimize I/O performance

Changes in v8:
- Fix buffer overflow, strsep() memory corruption, and unsafe string handling issues
- Add cond_resched() to prevent RCU stalls in page iteration loop
- Improve validation and error handling (e.g., "1-2-3") in userspace tool
- Fix documentation warnings and improve code comments

v8 additional testing with invalid inputs:
  ./page_owner_filter -n 1-2-3
  Error: Multiple dashes in nid_list

  ./page_owner_filter -n 0,1-2-3
  Error: Multiple dashes in nid_list

  ./page_owner_filter -n 1-2-3,2-3
  Error: Multiple dashes in nid_list

Changes in v7:
- print_mode and NUMA node filter implementation (patches 1-2)
- Add page_owner_filter userspace tool (patch 3)
- Update documentation for per-fd interface (patch 4)

Changes in v6:
- Address SeongJae Park's review comments for patch 1/3:
  * Remove unnecessary braces in if/else statement
  * Use stack array instead of kmalloc for input buffer
- Address SeongJae Park's review comments for patch 2/3:
  * Add node validity check using nodes_subset() to reject non-existent nodes
  * Separate variable declaration and statement
  * Use kmalloc_objs() for consistency with kernel patterns
  * Remove 100 bytes overhead
- Add lore links to all previous versions

Changes in v5:
- Optimize nodes_empty() check in page iteration loop
- Add __data_racy qualifier to nid_mask field

Changes in v4:
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

Changes in v3:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
  * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
  * Direct assignment is safe for this use case
- Add comment explaining input length calculation formula
  * 6 bytes = ",NNNNN" (comma + 5-digit node number)
- Simplify "-1" check using kstrtoint() instead of dual strcmp()
- Move nodemask_t mask read outside PFN iteration loop for performance
  * Avoids 128-byte structure copy on each iteration
- Add documentation for filter features (patch 3/3)

Changes in v2:
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
Previously, page_owner could not filter by NUMA node, forcing users to
collect and analyze data for all nodes.

Solution
========

This patch series introduces a per-file-descriptor filter infrastructure
with two initial filters:

1. **Print Mode Filter**: Outputs only stack handles instead of
   full stack traces. The handle-to-stack mapping can be retrieved
   from the existing show_stacks_handles interface. This dramatically
   reduces output size while preserving all allocation metadata.

2. **NUMA Node Filter**: Allows filtering pages by specific NUMA node(s)
   using flexible nodelist format, enabling targeted analysis of memory
   issues in NUMA-aware deployments.

The per-fd design allows multiple concurrent page_owner reads with
different filters, solving coordination issues in multi-user production
environments.

Implementation
==============

The series is structured as follows:

- Patch 1: Implement print_mode filter infrastructure
  * Add file->private_data to store per-fd filter state
  * Add .open, .release, and .write file operations
  * Support "stack", "handle", and "stack_handle" modes via "mode=" write commands
- Patch 2: Implement NUMA node filter infrastructure
  * Add nid_filter field to per-fd state
  * Support flexible nodelist format via "nid=" write commands (single, multiple, ranges)
  * Validate nodes and reject non-existent nodes using nodes_subset()
- Patch 3: Add page_owner_filter userspace tool
  * Manages per-fd filters via write() interface
  * Provides user-friendly command-line interface
  * Includes comprehensive input validation
- Patch 4: Document filter features and usage

Usage Example
=============

Using the page_owner_filter tool with per-fd filters:

    # ./page_owner_filter -m stack_handle -n "0,2-3" -o page_owner.txt

The tool opens /sys/kernel/debug/page_owner, sets filters via write(),
then reads the filtered output to the specified file (or stdout).

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

Tested on a 4-node NUMA system. Verified that:

1. **Kernel without page_owner enabled**:
   Tool properly detects and reports missing page_owner support:
   ```
   $ ./page_owner_filter -m stack
   Error: /sys/kernel/debug/page_owner does not exist
   Make sure page_owner is enabled in kernel
   ```

2. **Kernel without per-fd filter support**:
   Tool properly detects and reports missing filter support:
   ```
   $ ./page_owner_filter -m stack
   Error: Kernel rejected the filter command.
   Possible causes:
     - Kernel does not support per-fd filtering
     - NUMA node has no memory
     - Unknown reason
   ```

3. **Comprehensive userspace tool testing**:
   Tested 26 test cases covering:
   - Help messages (-h, --help)
   - Invalid inputs (mode, nid format, range validation)
   - Valid modes (stack, handle, stack_handle)
   - Valid nid filters (single node, multiple nodes, ranges)
   - Combined mode and nid filters
   - Node validity verification (grep-based verification)
   - Error handling for out-of-range nodes

   Test script (test_page_owner_filter.sh):
   ```bash
   #!/bin/bash
   # Test script for page_owner_filter tool

   cd "$(dirname "$0")"

   echo "========================================="
   echo "page_owner_filter Test Suite"
   echo "========================================="
   echo

   echo "Test 1: -h"
   echo "./page_owner_filter -h"
   ./page_owner_filter -h
   echo

   echo "Test 2: --help"
   echo "./page_owner_filter --help"
   ./page_owner_filter --help
   echo

   echo "Test 3: Invalid mode"
   echo ./page_owner_filter -m invalid
   ./page_owner_filter -m invalid
   echo

   echo "Test 4: Invalid nid with letters"
   echo ./page_owner_filter -n 0,a,2
   ./page_owner_filter -n 0,a,2
   echo

   echo "Test 5: Invalid nid with double comma"
   echo ./page_owner_filter -n 0,,2
   ./page_owner_filter -n 0,,2
   echo

   echo "Test 6: Invalid nid starting with comma"
   echo ./page_owner_filter -n ,0,1
   ./page_owner_filter -n ,0,1
   echo

   echo "Test 7: Invalid nid ending with comma"
   echo ./page_owner_filter -n "0,1,"
   ./page_owner_filter -n "0,1,"
   echo

   echo "Test 8: No filters specified"
   echo ./page_owner_filter
   ./page_owner_filter
   echo

   echo "Test 9: Invalid nid - node 4 (out of range)"
   echo ./page_owner_filter -n 4
   ./page_owner_filter -n 4
   echo

   echo "Test 10: Invalid nid - large number"
   echo './page_owner_filter -n 65535'
   ./page_owner_filter -n 65535
   echo

   echo "Test 11: Invalid mode AND invalid nid"
   echo ./page_owner_filter -m wrong -n abc
   ./page_owner_filter -m wrong -n abc
   echo

   echo "Test 12: Two invalid modes (try both)"
   echo ./page_owner_filter -m wrong1 -m wrong2
   ./page_owner_filter -m wrong1 -m wrong2
   echo

   echo "Test 13: Valid mode - stack"
   echo './page_owner_filter -m stack | head -20'
   ./page_owner_filter -m stack | head -20
   echo

   echo "Test 14: Valid mode - handle"
   echo './page_owner_filter -m handle | head -20'
   ./page_owner_filter -m handle | head -20
   echo

   echo "Test 15: Valid mode - stack_handle"
   echo './page_owner_filter -m stack_handle | head -20'
   ./page_owner_filter -m stack_handle | head -20
   echo

   echo "Test 16: All modes"
   echo './page_owner_filter -m stack -m handle -m stack_handle | head -20'
   ./page_owner_filter -m stack -m handle -m stack_handle | head -20
   echo

   echo "Test 17: Valid nid - single"
   echo './page_owner_filter -n 0 | head -20'
   ./page_owner_filter -n 0 | head -20
   echo 'Verify: should have node=0, should NOT have node=1,2,3'
   echo './page_owner_filter -n 0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 18: Valid nid - multiple"
   echo 'Verify: should have node=0,1,3, should NOT have node=2'
   echo './page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 19: Valid nid - range"
   echo 'Verify: should have node=2,3, should NOT have node=0,1'
   echo './page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 20: Valid nid - range"
   echo 'Verify: should have node=0,1,2,3'
   echo './page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 21: Valid nid - range"
   echo 'Verify: should have node=2, should NOT have node=0,1,3'
   echo './page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 22: Invalid nid - range start must be <= end"
   echo './page_owner_filter -n 3-0'
   ./page_owner_filter -n 3-0
   echo

   echo './page_owner_filter -n 1-0,0-1'
   ./page_owner_filter -n 1-0,0-1
   echo

   echo './page_owner_filter -n 2-3,1-0,0-1'
   ./page_owner_filter -n 2-3,1-0,0-1
   echo

   echo './page_owner_filter -n 3,1-0,1'
   ./page_owner_filter -n 3,1-0,1
   echo

   echo "Test 23: Invalid nid - NUMA node 4 and above have no memory"
   echo './page_owner_filter -n 0-4'
   ./page_owner_filter -n 0-4
   echo

   echo './page_owner_filter -n 1,0-4'
   ./page_owner_filter -n 1,0-4
   echo

   echo './page_owner_filter -n 7-8'
   ./page_owner_filter -n 7-8
   echo

   echo './page_owner_filter -n 8-1'
   ./page_owner_filter -n 8-1
   echo

   echo "Test 24: Valid nid - range and comma mixed"
   echo 'Verify: should have node=0,2,3, should NOT have node=1'
   echo './page_owner_filter -n 2-3,0| grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 2-3,0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 25: Valid nid - range and comma mixed"
   echo 'Verify: should have node=1,2,3, should NOT have node=0'
   echo './page_owner_filter -n 1,2-3| grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -n 1,2-3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo

   echo "Test 26: Valid handle mode + nid filter"
   echo './page_owner_filter -m handle -n "0,1" | head -20'
   ./page_owner_filter -m handle -n "0,1" | head -20
   echo 'Verify: should show stacks, and only node=0,1 (not 2,3)'
   echo './page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c'
   ./page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
   echo


   echo "========================================="
   echo "Tests completed. Please check output above."
   echo "========================================="
   ```
       
   Test output:
   ```
   =========================================
   page_owner_filter Test Suite
   =========================================

   Test 1: -h
   ./page_owner_filter -h
   Usage: ./page_owner_filter [OPTIONS]

   Options:
     -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
     -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
     -o, --output FILE    : output file (default: stdout)
     -h, --help           : show this help message

   Examples:
     ./page_owner_filter -m stack
     ./page_owner_filter -m handle
     ./page_owner_filter -m stack_handle
     ./page_owner_filter -m stack -o output.txt
     ./page_owner_filter -n 0,1,2
     ./page_owner_filter -m stack -n 0

   Test 2: --help
   ./page_owner_filter --help
   Usage: ./page_owner_filter [OPTIONS]

   Options:
     -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
     -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
     -o, --output FILE    : output file (default: stdout)
     -h, --help           : show this help message

   Examples:
     ./page_owner_filter -m stack
     ./page_owner_filter -m handle
     ./page_owner_filter -m stack_handle
     ./page_owner_filter -m stack -o output.txt
     ./page_owner_filter -n 0,1,2
     ./page_owner_filter -m stack -n 0

   Test 3: Invalid mode
   ./page_owner_filter -m invalid
   Error: Invalid mode 'invalid'
   Valid modes: stack, handle, stack_handle

   Test 4: Invalid nid with letters
   ./page_owner_filter -n 0,a,2
   Error: Invalid character 'a' in nid_list

   Test 5: Invalid nid with double comma
   ./page_owner_filter -n 0,,2
   Error: Invalid nid_list format

   Test 6: Invalid nid starting with comma
   ./page_owner_filter -n ,0,1
   Error: Invalid nid_list format

   Test 7: Invalid nid ending with comma
   ./page_owner_filter -n 0,1,
   Error: Invalid nid_list format

   Test 8: No filters specified
   ./page_owner_filter
   Error: At least one filter (-m or -n) must be specified

   Usage: ./page_owner_filter [OPTIONS]

   Options:
     -m, --mode MODE      : print_mode (stack, handle, or stack_handle)
     -n, --nid NID_LIST   : NUMA node IDs (comma-separated or ranges)
     -o, --output FILE    : output file (default: stdout)
     -h, --help           : show this help message

   Examples:
     ./page_owner_filter -m stack
     ./page_owner_filter -m handle
     ./page_owner_filter -m stack_handle
     ./page_owner_filter -m stack -o output.txt
     ./page_owner_filter -n 0,1,2
     ./page_owner_filter -m stack -n 0

   Test 9: Invalid nid - node 4 (out of range)
   ./page_owner_filter -n 4
   Error: Kernel rejected the filter command.
   Possible causes:
     - Kernel does not support per-fd filtering
     - NUMA node has no memory
     - Unknown reason

   Test 10: Invalid nid - large number
   ./page_owner_filter -n 65535
   write filter command: Numerical result out of range

   Test 11: Invalid mode AND invalid nid
   ./page_owner_filter -m wrong -n abc
   Error: Invalid mode 'wrong'
   Valid modes: stack, handle, stack_handle

   Test 12: Two invalid modes (try both)
   ./page_owner_filter -m wrong1 -m wrong2
   Error: Invalid mode 'wrong1'
   Valid modes: stack, handle, stack_handle

   Test 13: Valid mode - stack
   ./page_owner_filter -m stack | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c

   Test 14: Valid mode - handle
   ./page_owner_filter -m handle | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40003 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40004 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577


   Test 15: Valid mode - stack_handle
   ./page_owner_filter -m stack_handle | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460

   Test 16: All modes
   ./page_owner_filter -m stack -m handle -m stack_handle | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460

   Test 17: Valid nid - single
   ./page_owner_filter -n 0 | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
    register_early_stack+0x2c/0x70
    init_page_owner+0x2c/0x460
    page_ext_init+0x204/0x298
    mm_core_init+0xdc/0x14c
   Verify: should have node=0, should NOT have node=1,2,3
   ./page_owner_filter -n 0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     91327 node=0

   Test 18: Valid nid - multiple
   Verify: should have node=0,1,3, should NOT have node=2
   ./page_owner_filter -n 0,1,3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     91299 node=0
     43515 node=1
    110404 node=3

   Test 19: Valid nid - range
   Verify: should have node=2,3, should NOT have node=0,1
   ./page_owner_filter -n 2-3 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     19391 node=2
    110287 node=3

   Test 20: Valid nid - range
   Verify: should have node=0,1,2,3
   ./page_owner_filter -n 2-3,0-1 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     91562 node=0
     43527 node=1
     19495 node=2
    110286 node=3

   Test 21: Valid nid - range
   Verify: should have node=2, should NOT have node=0,1,3
   ./page_owner_filter -n 2-2 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     19505 node=2

   Test 22: Invalid nid - range start must be <= end
   ./page_owner_filter -n 3-0
   Error: Invalid range 3-0 (start must be <= end)

   ./page_owner_filter -n 1-0,0-1
   Error: Invalid range 1-0 (start must be <= end)

   ./page_owner_filter -n 2-3,1-0,0-1
   Error: Invalid range 1-0 (start must be <= end)

   ./page_owner_filter -n 3,1-0,1
   Error: Invalid range 1-0 (start must be <= end)

   Test 23: Invalid nid - NUMA node 4 and above have no memory
   ./page_owner_filter -n 0-4
   Error: Kernel rejected the filter command.
   Possible causes:
     - Kernel does not support per-fd filtering
     - NUMA node has no memory
     - Unknown reason

   ./page_owner_filter -n 1,0-4
   Error: Kernel rejected the filter command.
   Possible causes:
     - Kernel does not support per-fd filtering
     - NUMA node has no memory
     - Unknown reason

   ./page_owner_filter -n 7-8
   Error: Kernel rejected the filter command.
   Possible causes:
     - Kernel does not support per-fd filtering
     - NUMA node has no memory
     - Unknown reason

   ./page_owner_filter -n 8-1
   Error: Invalid range 8-1 (start must be <= end)

   Test 24: Valid nid - range and comma mixed
   Verify: should have node=0,2,3, should NOT have node=1
   ./page_owner_filter -n 2-3,0| grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     91741 node=0
     19389 node=2
    110286 node=3

   Test 25: Valid nid - range and comma mixed
   Verify: should have node=1,2,3, should NOT have node=0
   ./page_owner_filter -n 1,2-3| grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     43462 node=1
     19402 node=2
    110288 node=3

   Test 26: Valid handle mode + nid filter
   ./page_owner_filter -m handle -n "0,1" | head -20
   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40000 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40001 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40002 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40003 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000000(node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Page allocated via order 0, mask 0x0(), pid 0, tgid 0 (swapper), ts 0 ns
   PFN 0x40004 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   handle: 1048577

   Verify: should show stacks, and only node=0,1 (not 2,3)
   ./page_owner_filter -m handle -n "0,1" | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
     91677 node=0
     43458 node=1

   =========================================
   Tests completed. Please check output above.
   =========================================
   ```

Future Enhancements
===================

The per-fd filter infrastructure is designed to be extensible. Potential
future filters could include:
- PID/TGID filtering
- Time range filtering (allocation timestamp windows)
- GFP flag filtering
- Migration type filtering

v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-1-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-1-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-1-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511024748.183550-1-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-1-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-1-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-1-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-1-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-1-zhen.ni@easystack.cn/

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Zhen Ni (4):
  mm/page_owner: add print_mode filter
  mm/page_owner: add NUMA node filter
  tools/mm: add page_owner_filter userspace tool
  mm/page_owner: document page_owner filter

 Documentation/mm/page_owner.rst |  77 +++++++-
 mm/page_owner.c                 | 177 ++++++++++++++++++-
 tools/mm/Makefile               |   4 +-
 tools/mm/page_owner_filter.c    | 302 ++++++++++++++++++++++++++++++++
 4 files changed, 550 insertions(+), 10 deletions(-)
 create mode 100644 tools/mm/page_owner_filter.c

-- 
2.20.1


