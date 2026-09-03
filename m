Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC04DC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 04:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7208D6B008A; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CFE26B008C; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570AD6B0099; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 16D406B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:18:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D4F5C0428
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:40 +0000 (UTC)
X-FDA: 85171144800.02.A0684F8
Received: from mail-m82101.xmail.ntesmail.com (mail-m82101.xmail.ntesmail.com [156.224.82.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BC9140007
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 04:18:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf07.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.101 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788409118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=Pp1QRvlXWqJJ9lh6fdZ2eCvMKWAdZwhen+KgFrDVHOw=;
	b=Df3QVmfmnf7pp2ux1oCbc2QBHCFHTNm187I/p2mB6tcUdIU1/0/InhW2hArR9mTec2J3BK
	bSb6PTav4Zo+OL4oLOznmSkKQkPgtEZKUNcKL1TfQpBwadg0BNW9DNRuCQm/NiwaQVZy5y
	NR6I9nE17SkVO4aZHPKkWtQuiMKxL/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788409118;
	b=bDb/35VIyvvad50Tp+e/GILlUQYmz13Loti/KBtPmqJ7MfxxqRFCCH03HO6AGmK715ROzy
	778dgAEUxJWpkb+PVMhltrqm1EAcmle19P/TCT2VzQdxO/mJhfmXR2V7NQ1mCPgQhz+rBF
	d83fQKle2sJNt0S+zwaEHCJhwxu9pQA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf07.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.101 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea3ea3aa;
	Thu, 3 Sep 2026 12:18:29 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
Date: Thu,  3 Sep 2026 12:18:11 +0800
Message-Id: <20260903041819.1776630-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0657d5d130229kunm7336907a3309b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHRpNVh8fHh1NSxkZHhoaQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2BC9140007
X-Stat-Signature: fxk5p4t9ssbooaaz6atpmz9wwy6tpion
X-HE-Tag: 1788409116-504137
X-HE-Meta: U2FsdGVkX1/bbsLNDX32GwD4FRb1DM3CZ/OGVaWJvOTn0qktdjgtHoHQlLJTQl8dLgQPDLGDskz7o+twXiRS7ra9XmTl1wEZMtN21zEWZixN2SCz5LSE5S6VZKQAQvBNJb++9ktSi/oOdj1kE5WkmIUkz9WksOryZMGnfRx8EuYmWxUH0eYvuqK2O3sdVOp3v8NWP3cf/AbBnFGmu4sw9O2i/I/IzVPNT1Ywf3t9Rv6WG2LQhPTOXUH/lwq9Vc2QCl4j8wVUtNhh01T8Rn5jEgIm31cXaVE6BI0M5bSqE9lUhFqaUUkLZWmZezlkchwiBKyV+YmjkeP6wqbZOBv197xEadlF4CzpyPz6sf/e7WGFazAt1lNaTJtYGkvmCHhTRJ844gxTZpY452xc/N6dRqkHT429lgN9Zw37y4ji4wKnD8Surg7nU9GFmfhbAkkI1wz4wyLEeq+Zr94hGr64Od3mnTHUkivabkidKIOr+e3mO5IqWWIDCjeCH+8PcAmXDZ8xEo78vSoCjkImDE3BWud8aojkl2xfbmIcaokZ1ZY/LuMFKk4cEPm8FWSrbm3fQ6H9PM2zGyY9U1pNAMsJfDgnQFQBpFEGjcVKJTiH+WN7wnUI+of37m6fSZDRYaL/EAhICNsZ8W4rW3BW5sa1GtCwbcsiLKuZq3ZLz+k9QIHUzwGNMCKB/wXTxQmyRukbVluKBNV5yOyBxEhTZCNeLhWbanTKyP0dCsGcUBojvUzvbggmheXDDO54yy6/XIo2Zp697+9C8FB9EJE6mt7I8PfCYmfqs4YbgYV1k+EFxaPCykqxFwVCTscxj4SvF5SuIxyf85h/Z/UF6QbqjpKFb8kEXigaDOuX4amEQb3QtTOaT8WBLVRpPU53qpSovQGOH8rWAAoBnAXfHsAZ4UmYYqu1DytVZ2617FXIEhKUdOF6H3ighGzGOX+iWNHUBlf1i4fLz7rsv8ezx1/uB2Z
 X0invMCb
 +WbZ56LeWfkdXo4h/s/dZvO/0T7Lvq7nROfY05oz3367xsVZc9f6Xq2bUVgu2ol0W8bF3aNZnsgZfcVAsn2GJgWx05Wqa1/wcaRDEatbl0LNtgLp8AJ/pn3gkUTEHjB1z2/GKKW3HVBumgUEFifuJSSMeZV2rz33Tixo5v3SsZfyMCAqnjem/YPvHab6idVP3SdF6Vvs6kxFOmdX3j+ffSpaonyzAqrK9emZnC7QihSbcX4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series adds process and memory cgroup filtering support to
page_owner. Following the previous series that introduced print_mode and
NUMA node filters:
  https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easystack.cn/

This series adds filtering capabilities to page_owner, allowing users to
filter output by specific processes and memory cgroups. Users can now
filter page_owner output by PID, TGID, COMM (with wildcard support), and
memory cgroup path. This makes page_owner debugging more focused and
efficient for tracking memory allocations in specific contexts.

Targeted filtering provides significant performance benefits on large memory
servers by reducing both execution time and output size. By filtering at the
kernel level before reading, only relevant page allocations are processed,
dramatically reducing the amount of data that needs to be handled in userspace.

This series extends page_owner filtering capabilities with:
- PID filtering
- TGID filtering
- COMM filtering with wildcard support
- Cgroup (memcg) filtering for containerized environments

The series is organized as follows:

Patches 1-3: Add PID, TGID, and COMM filtering support to page_owner
  - Support filtering by process ID
  - Support filtering by thread group ID
  - Support filtering by command name with wildcards

Patch 4: Refactor memcg handling to prepare for cgroup filter support
Patch 5: Add memory cgroup filtering support

Patches 6-7: Update page_owner_filter tool with corresponding features

Patch 8: Update documentation

These filters are particularly useful for:
- Debugging memory leaks in specific processes
- Analyzing memory usage in containerized environments
- Isolating allocations from specific services or applications

Changes in v2
=============

Patch 1:
- Drop the kstrdup() copy in parse_pid_t_list(); parse the token in
  place. This also fixes a leak on success and a kfree() of an advanced
  pointer on error in v1.
- Use cmp_int() in cmp_pid_t() to avoid overflow on subtraction.
- Reject pids exceeding PID_MAX_LIMIT.

Patch 2:
- No change.

Patch 3:
- Select GLOB from PAGE_OWNER so that glob_match() is always linked in
  when the feature is enabled.
- Drop the kstrdup() copy in parse_comm_list(); parse the token in
  place, matching patch 1.

Patch 4:
- No change.

Patch 5:
- Allocate the cgroup path buffer once per read() outside the loop
  instead of per page inside get_page_memcg_info(); a GFP_KERNEL
  allocation must not sleep inside the page_ext RCU read-side critical
  section.
- Guard the memcg= parsing branch with CONFIG_MEMCG.

Patch 6:
- Print error messages for empty -p/-t and -c arguments.

Patch 7:
- Print an error message for an empty -g argument.

Patch 8:
- Quote the wildcard pattern in the -c example.

v1: https://lore.kernel.org/linux-mm/20260828031339.1270699-1-zhen.ni@easystack.cn/

Test Setup
===========

The filtering functionality has been tested with the following tools:

1. page_owner_test_alloc.c - Test allocation program

   Build: gcc page_owner_test_alloc.c -o page_owner_test_alloc

   Run: ./page_owner_test_alloc

   Creates 3 threads in separate cgroups (test_a, test_b, test_c), each
   allocating 1MB continuously. Allows verification of PID/TGID/COMM/cgroup
   filtering accuracy by comparing page counts. Automatically cleans up
   cgroups on Ctrl+C (SIGINT) or SIGTERM.

2. test_page_owner_filters.sh - Comprehensive test script

   Run: ./test_page_owner_filters.sh

   Covers invalid inputs, PID 1 filtering, cgroup filtering, combination
   filters, and page count verification using the test program above.

Test Results
============

1. Start test program (keep it running)::

   $ ./page_owner_test_alloc 
   TGID: 792 PID: 793 COMM: po_thread_a CGROUP: /test_a
   TGID: 792 PID: 794 COMM: po_thread_b CGROUP: /test_b
   TGID: 792 PID: 795 COMM: po_thread_c CGROUP: /test_c

   [Keep this terminal running, open a new terminal for the test script]

2. Run test script in another terminal::

   $ ./test_page_owner_filters.sh

   Test environment: 4-node NUMA system.

   The same script was tested on both cgroup v1 and cgroup v2, and the
   results matched expectations on both.

   The cgroup v1 testing requires CONFIG_MEMCG_V1 to be enabled at build
   time, plus the following kernel boot parameters::

     systemd.unified_cgroup_hierarchy=0
     systemd.legacy_systemd_cgroup_controller=1

   The output below is from the cgroup v2 environment.

   root@ubuntu:~/pid# ./test_page_owner_filters.sh
   =========================================
   Page Owner Filter Tests
   =========================================

   === I. INVALID INPUT TESTS ===

   --- 1.1 PID Invalid Inputs ---
   Test: Negative PID
   ./page_owner_filter -p -1
   Error: Invalid character '-' in pid_list (only digits allowed)

   Test: Non-numeric PID
   ./page_owner_filter -p abc
   Error: Invalid character 'a' in pid_list (only digits allowed)

   Test: Empty PID argument
   ./page_owner_filter -p
   ./page_owner_filter: option requires an argument -- 'p'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   Test: PID with letters (mixed invalid)
   ./page_owner_filter -p 123abc
   Error: Invalid character 'a' in pid_list (only digits allowed)

   Test: Multiple invalid PIDs
   ./page_owner_filter -p -1,-2,-3
   Error: Invalid character '-' in pid_list (only digits allowed)

   Test: Excessive PID value (> max PID)
   ./page_owner_filter -p 4294967296
   write filter command: Invalid argument

   Test: Too many PIDs (17 PIDs, max is 16)
   ./page_owner_filter -p 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
   Error: Too many PIDs (max 16)


   --- 1.2 TGID Invalid Inputs ---
   Test: Negative TGID
   ./page_owner_filter -t -1
   Error: Invalid character '-' in pid_list (only digits allowed)

   Test: Non-numeric TGID
   ./page_owner_filter -t xyz
   Error: Invalid character 'x' in pid_list (only digits allowed)

   Test: Empty TGID argument
   ./page_owner_filter -t
   ./page_owner_filter: option requires an argument -- 't'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   Test: TGID with special characters
   ./page_owner_filter -t '$$'
   Error: Invalid character '$' in pid_list (only digits allowed)

   Test: Mixed valid/invalid TGID
   ./page_owner_filter -t 1,abc,2
   Error: Invalid character 'a' in pid_list (only digits allowed)


   --- 1.3 COMM Invalid Inputs ---
   Test: Empty COMM argument
   ./page_owner_filter -c
   ./page_owner_filter: option requires an argument -- 'c'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   Test: COMM with only spaces
   ./page_owner_filter -c '   '
   write filter command: Invalid argument

   Test: COMM with path separator
   Verify: Non-existent COMM is accepted but produces no output
   ./page_owner_filter -c 'invalid/name'

   Test: Empty COMM in list (consecutive commas)
   ./page_owner_filter -c 'test,,another'
   Error: Empty COMM in list

   Test: Empty COMM at end
   ./page_owner_filter -c 'test,'
   Error: Empty COMM at end of list

   Test: Empty COMM at start
   ./page_owner_filter -c ',test'
   Error: Empty COMM in list

   Test: Extremely long COMM in a list
   ./page_owner_filter -c 'short,very_long_process_name,another'
   Error: COMM too long (max 15 chars)
   Near: very_long_proce...


   --- 1.4 Cgroup Invalid Inputs ---
   Test: Empty cgroup path
   ./page_owner_filter -g
   ./page_owner_filter: option requires an argument -- 'g'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   Test: Non-existent cgroup path
   ./page_owner_filter -g /nonexistent/path/that/does/not/exist
   Error: Cgroup path '/nonexistent/path/that/does/not/exist': not found or no memory controller

   Test: Cgroup path with spaces
   ./page_owner_filter -g '/path with spaces'
   Error: Cgroup path '/path with spaces': not found or no memory controller

   Test: Cgroup exists but has no memory controller
   ✓ Created: /sys/fs/cgroup/test_no_memcg_parent_796/test_child
   ✓ Verified: /sys/fs/cgroup/test_no_memcg_parent_796/test_child/memory.stat does not exist
   Note: page_owner_filter should detect missing memory.stat
   ./page_owner_filter -g /test_no_memcg_parent_796/test_child
   Error: Cgroup path '/test_no_memcg_parent_796/test_child': not found or no memory controller

   Test: Cgroup path exceeding PATH_MAX
   Generated path length: 4101
   ./page_owner_filter -g '<very long path>'
   Error: Cgroup path '/aaa...aaaa': not found or no memory controller

   Test: Multiple cgroup paths (last one wins)
   ./page_owner_filter -g /user.slice -g /sys/fs/cgroup
   Verify: Tool accepts multiple -g and uses the last one
   Note: /sys/fs/cgroup is invalid
   Error: Cgroup path '/sys/fs/cgroup': not found or no memory controller


   --- 1.5 General Invalid Options ---
   Test: Invalid option flag
   ./page_owner_filter -x
   ./page_owner_filter: invalid option -- 'x'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   Test: Unknown filter combination
   ./page_owner_filter -q 123
   ./page_owner_filter: invalid option -- 'q'
   Usage: ./page_owner_filter [OPTIONS]

   Options:
   -m, --mode MODE       : print_mode (stack, handle, stack_handle)
   -n, --nid NID_LIST    : NUMA nodes (comma-separated or ranges)
   -p, --pid PID_LIST    : Process IDs (comma-separated, max 16)
   -t, --tgid TGID_LIST  : Thread Group IDs (comma-separated, max 16)
   -c, --comm COMM_LIST  : Process names (comma-separated, max 8)
                           Supports wildcards: * ? [a-z]
   -g, --cgroup PATH     : Memory cgroup path
   -o, --output FILE     : output file (default: stdout)
   -h, --help            : show this help message

   Examples:
   ./page_owner_filter -m handle -o output.txt
   ./page_owner_filter -n 0,1 -c bash
   ./page_owner_filter -c "python*" -g user.slice

   --- 1.6 Mixed Invalid ---
   Test: Valid PID + valid cgroup + invalid NID (node 4 doesn't exist)
   Verify: Invalid NID should cause rejection even with valid other filters
   ./page_owner_filter -p 1 -g / -n 4
   write filter command: Invalid argument


   === II. PID 1 AND ROOT CGROUP TESTS ===

   --- 2.1 PID Filter with PID 1 ---
   Test: Filter by PID 1 (init/systemd)
   ./page_owner_filter -p 1 | head -20
   Page allocated via order 3, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 5991990 ns
   PFN 0x400c8 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   refill_objects+0x204/0x278
   __pcs_replace_empty_main+0x130/0x3ec
   __kmalloc_noprof+0x354/0x42c
   bitmap_zalloc+0x24/0x30
   asids_init+0x64/0xf0
   do_one_initcall+0x70/0x1b8
   kernel_init_freeable+0x108/0x2ec
   kernel_init+0x2c/0x1e0
   ret_from_fork+0x10/0x20

   Page allocated via order 2, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 11666300 ns
   PFN 0x400e0 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   Verify: All pages should be from PID 1
   ./page_owner_filter -p 1 | grep -o "pid [0-9]*," | sort | uniq -c
   14919 pid 1,

   --- 2.2 TGID Filter with PID 1's TGID ---
   Test: Filter by TGID of PID 1
   ./page_owner_filter -t 1 | head -20
   Page allocated via order 3, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 5991990 ns
   PFN 0x400c8 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   refill_objects+0x204/0x278
   __pcs_replace_empty_main+0x130/0x3ec
   __kmalloc_noprof+0x354/0x42c
   bitmap_zalloc+0x24/0x30
   asids_init+0x64/0xf0
   do_one_initcall+0x70/0x1b8
   kernel_init_freeable+0x108/0x2ec
   kernel_init+0x2c/0x1e0
   ret_from_fork+0x10/0x20

   Page allocated via order 2, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (swapper/0), ts 11666300 ns
   PFN 0x400e0 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   Verify: All pages should be from TGID 1
   ./page_owner_filter -t 1 | grep -o "tgid [0-9]* " | sort | uniq -c
   14919 tgid 1 

   --- 2.3 COMM Filter with systemd/init ---
   Test: Filter by systemd (or init if systemd not present)
   ./page_owner_filter -c systemd | head -20
   Page allocated via order 1, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 170, tgid 170 (systemd), ts 4340986430 ns
   PFN 0x40172 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   refill_objects+0x204/0x278
   __pcs_replace_empty_main+0x130/0x3ec
   __kmalloc_noprof+0x354/0x42c
   load_elf_phdrs+0x68/0xec
   load_elf_binary+0xac/0x1664
   bprm_execve+0x274/0x4c4
   do_execveat_common.isra.0+0x164/0x1c4
   __arm64_sys_execve+0x44/0x68
   invoke_syscall+0x54/0x110
   el0_svc_common.constprop.0+0x40/0xe8
   do_el0_svc+0x20/0x2c
   el0_svc+0x30/0x198
   el0t_64_sync_handler+0xa0/0xe4

   Page allocated via order 1, mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 1, tgid 1 (systemd), ts 3621526030 ns
   Verify: All pages should be from systemd
   ./page_owner_filter -c systemd | grep -o "([a-z]*)," | sort | uniq -c
      2290 (systemd),

   --- 2.4 Cgroup Filter with Root Cgroup ---
   Test: Filter by root cgroup /
   ./page_owner_filter -g / | head -20
   Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 162339490 ns
   PFN 0x40b33 type Unmovable Block 517 type Unmovable Flags 0x3fffe0000004124(referenced|lru|active|private|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   alloc_pages_mpol+0x70/0x1c4
   alloc_frozen_pages_noprof+0x4c/0xc8
   folio_alloc_noprof+0x14/0x6c
   filemap_alloc_folio_noprof.part.0+0x134/0x148
   __filemap_get_folio_mpol+0x260/0x50c
   __getblk_slow+0x94/0x2c4
   bdev_getblk+0x68/0x7c
   ext4_sb_breadahead_unmovable+0x1c/0x84
   __ext4_get_inode_loc+0x334/0x520
   __ext4_get_inode_loc_noinmem+0x44/0xb0
   __ext4_iget+0x1cc/0xd38
   ext4_get_journal_inode+0x30/0x110
   ext4_fill_super+0x1624/0x2be0
   get_tree_bdev_flags+0x140/0x1ec
   Charged to memcg /

   Verify: All pages with memcg info should be charged to root cgroup
   Total pages:
      ./page_owner_filter -g / | grep -c "^Page allocated"
   14187
   Charged memcg paths (should only show memcg /):
      ./page_owner_filter -g / | grep "Charged to" | grep -o "memcg [^"]*" | sort | uniq -c
   14187 memcg /


   === III. TEST PROGRAM FILTERS (WITH PAGE COUNT VERIFICATION) ===

   Found test program with main PID: 792
   TGID: 792
   Thread 1: PID=793, COMM=po_thread_a, cgroup=/test_a
   Thread 2: PID=794, COMM=po_thread_b, cgroup=/test_b
   Thread 3: PID=795, COMM=po_thread_c, cgroup=/test_c

   Note: Each thread allocates 1MB (~256 pages)
   --- 3.1 Thread 1 (po_thread_a) Verification ---
   ./page_owner_filter -p 793 | grep -c PFN
   ./page_owner_filter -c po_thread_a | grep -c PFN
   ./page_owner_filter -g test_a | grep -c PFN
   By PID (-p 793):   262 pages
   By COMM (-c po_thread_a): 262 pages
   By cgroup (-g test_a):   267 pages

   --- 3.2 Thread 2 (po_thread_b) ---
   ./page_owner_filter -p 794 | grep -c PFN
   ./page_owner_filter -c po_thread_b | grep -c PFN
   ./page_owner_filter -g test_b | grep -c PFN
   By PID (-p 794):   263 pages
   By COMM (-c po_thread_b): 263 pages
   By cgroup (-g test_b):   268 pages

   --- 3.3 Thread 3 (po_thread_c) ---
   ./page_owner_filter -p 795 | grep -c PFN
   ./page_owner_filter -c po_thread_c | grep -c PFN
   ./page_owner_filter -g test_c | grep -c PFN
   By PID (-p 795):   264 pages
   By COMM (-c po_thread_c): 264 pages
   By cgroup (-g test_c):   257 pages

   --- 3.4 Summary: All Thread Counts ---
   Thread          By PID          By COMM         By Cgroup      
   --------------- --------------- --------------- ---------------
   po_thread_a     262             262             267            
   po_thread_b     263             263             268            
   po_thread_c     264             264             257            
   TOTAL           789             789             792            

   --- 3.6 Multi-PID List Test ---
   Verify: PID list equals sum of individual PIDs
   Expected count: 789
   ./page_owner_filter -p 793,794,795 | grep -c PFN
   789

   ./page_owner_filter -p 792 | grep -c PFN
   50

   ./page_owner_filter -p 792,793,794,795 | grep -c PFN
   839

   Verify: TGID equals sum of all PIDs in thread group (4 PIDs)
   Expected count: -p 792,793,794,795
   ./page_owner_filter -t 792 | grep -c PFN
   839

   --- 3.7 COMM Wildcard Test ---
   Verify: Wildcard matches all thread COMMs (should equal sum of thread counts)
   Expected count: 789
   ./page_owner_filter -c 'po_thread_*' | grep -c PFN
   789

   ./page_owner_filter -c 'page_owner_test' | grep -c PFN
   52

   Verify: COMM list equals sum of individual COMMs
   Expected count: 789 + -c 'page_owner_test'
   ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -c PFN
   841

   Verify: Should only show current test PIDs
   ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -o "pid [0-9]*," | sort | uniq -c
         1 pid 684,
         1 pid 685,
         1 pid 686,
         1 pid 785,
         1 pid 786,
         1 pid 787,
      46 pid 792,
      262 pid 793,
      263 pid 794,
      264 pid 795,
   Note: Previous test program PIDs may appear with small page counts (~10-20) due to kernel cache


   === IV. COMBINATION FILTER TESTS ===

   --- 4.1 PID + Cgroup Combination ---
   Test: PID 1 with Root Cgroup
   Verify: Should only show PID 1 pages in root cgroup
   ./page_owner_filter -p 1 -g / | grep -o "pid [0-9]*," | sort | uniq -c
      9779 pid 1,
   Verify: All pages should be charged to root cgroup (total pages = charged pages count)
   Total pages:
      ./page_owner_filter -p 1 -g / | grep -c "^Page allocated"
   9779
   Charged memcg paths:
      ./page_owner_filter -p 1 -g / | grep "Charged to" | grep -o "memcg [^"]*" | sort | uniq -c
      9779 memcg /

   --- 4.2 COMM + NID Combination ---
   Test: systemd with Node 0 filter
   ./page_owner_filter -c systemd -n 0 | head -10
   Page allocated via order 1, mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 170, tgid 170 (systemd), ts 4340986430 ns
   PFN 0x40172 type Unmovable Block 512 type Unmovable Flags 0x3fffe0000000040(head|node=0|zone=0|lastcpupid=0x1ffff)
   get_page_from_freelist+0x17d8/0x1a60
   __alloc_frozen_pages_noprof+0x198/0x133c
   new_slab+0xd0/0x4e8
   refill_objects+0x204/0x278
   __pcs_replace_empty_main+0x130/0x3ec
   __kmalloc_noprof+0x354/0x42c
   load_elf_phdrs+0x68/0xec
   load_elf_binary+0xac/0x1664
   Verify: Should only show systemd pages on node 0
      ./page_owner_filter -c systemd -n 0 | grep -o "([a-z]*)," | sort | uniq -c
      191 (systemd),
      ./page_owner_filter -c systemd -n 0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
      191 node=0

   --- 4.3 Test Program Filter Combinations ---
   Note: Process filters (PID/TGID/COMM) use OR logic among themselves,
         but AND logic with other filters (e.g., cgroup)

   expected: TGID page count, max of PID or TGID count)
   ./page_owner_filter -p 793 -t 792 | grep -c PFN
   839

   expected: max of PID or COMM count
   ./page_owner_filter -p 793 -c po_thread_a | grep -c PFN
   264

   expected: TGID page count,max of TGID or COMM count
   ./page_owner_filter -t 792 -c po_thread_a | grep -c PFN
   841

   AND logic: both must match
   ./page_owner_filter -p 793 -g /test_a | grep -c PFN
   257


   =========================================
   Tests completed
   =========================================

   Summary of test categories:
   I.   Invalid inputs for all filters
   II.  PID 1 and root cgroup tests
   III. Test program specific tests (with page count verification)
   IV.  Combination filter tests

   Please review output above for any errors or unexpected behavior.

Appendix - Test Programs
========================

1. page_owner_test_alloc.c - Test allocation program::

// SPDX-License-Identifier: GPL-2.0
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <sys/prctl.h>
#include <sys/stat.h>

#define ALLOC_MB 1
#define NUM_THREADS 3

static volatile sig_atomic_t shutdown = 0;
static char cgroup_names[NUM_THREADS][16] = {"test_a", "test_b", "test_c"};

static void sig_handler(int signo)
{
	shutdown = 1;
}

static void cleanup(void)
{
	FILE *f;

	/* Move self to root cgroup first */
	f = fopen("/sys/fs/cgroup/cgroup.procs", "w");
	if (!f)
		f = fopen("/sys/fs/cgroup/memory/cgroup.procs", "w");
	if (f) {
		fprintf(f, "%d", getpid());
		fclose(f);
	}

	/* Give threads time to exit cgroup */
	usleep(50000);

	/* Now remove the cgroups */
	for (int i = 0; i < NUM_THREADS; i++) {
		char path[128];
		snprintf(path, sizeof(path), "/sys/fs/cgroup/%s", cgroup_names[i]);
		rmdir(path);
		snprintf(path, sizeof(path), "/sys/fs/cgroup/memory/%s", cgroup_names[i]);
		rmdir(path);
	}
}

static void *thread_func(void *arg)
{
	int id = *(int *)arg;
	char comm[16], path[256];
	FILE *f;

	snprintf(comm, sizeof(comm), "po_thread_%c", 'a' + id);
	prctl(PR_SET_NAME, comm);

	/* Create cgroup and move thread (try v2, fallback to v1) */
	snprintf(path, sizeof(path), "/sys/fs/cgroup/%s", cgroup_names[id]);
	mkdir(path, 0755);
	strcat(path, "/cgroup.procs");
	f = fopen(path, "w");
	if (!f) {
		/* Try cgroup v1 memory controller */
		snprintf(path, sizeof(path), "/sys/fs/cgroup/memory/%s", cgroup_names[id]);
		mkdir(path, 0755);
		strcat(path, "/cgroup.procs");
		f = fopen(path, "w");
	}
	if (f) {
		fprintf(f, "%d", gettid());
		fclose(f);
	}

	/* Allocate memory */
	size_t sz = ALLOC_MB * 1024 * 1024;
	char *p = malloc(sz);
	if (p) {
		for (size_t i = 0; i < sz; i += 4096)
			p[i] = (char)i;
	}

	printf("TGID: %d PID: %d COMM: %s CGROUP: /%s\n",
	       getpid(), gettid(), comm, cgroup_names[id]);
	fflush(stdout);

	while (!shutdown) sleep(1);
	return NULL;
}

int main(void)
{
	pthread_t threads[NUM_THREADS];
	int ids[NUM_THREADS];

	signal(SIGINT, sig_handler);
	signal(SIGTERM, sig_handler);

	for (int i = 0; i < NUM_THREADS; i++) {
		ids[i] = i;
		pthread_create(&threads[i], NULL, thread_func, &ids[i]);
		usleep(100000);
	}

	while (!shutdown) pause();

	shutdown = 1;
	for (int i = 0; i < NUM_THREADS; i++)
		pthread_join(threads[i], NULL);

	cleanup();
	return 0;
}

2. test_page_owner_filters.sh - Comprehensive test script::

#!/bin/bash
# Comprehensive test script for page_owner filters
# Tests: PID/TGID/COMM/Cgroup filters (invalid cases, PID 1, test program, combinations)

cd "$(dirname "$0")"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Page Owner Filter Tests"
echo "========================================="
echo

# ============================================================================
# Section I: Invalid Input Tests
# ============================================================================
echo -e "${YELLOW}=== I. INVALID INPUT TESTS ===${NC}"
echo

echo "--- 1.1 PID Invalid Inputs ---"
echo "Test: Negative PID"
echo "  ./page_owner_filter -p -1"
./page_owner_filter -p -1
echo

echo "Test: Non-numeric PID"
echo "  ./page_owner_filter -p abc"
./page_owner_filter -p abc
echo

echo "Test: Empty PID argument"
echo "  ./page_owner_filter -p"
./page_owner_filter -p
echo

echo "Test: PID with letters (mixed invalid)"
echo "  ./page_owner_filter -p 123abc"
./page_owner_filter -p 123abc
echo

echo "Test: Multiple invalid PIDs"
echo "  ./page_owner_filter -p -1,-2,-3"
./page_owner_filter -p -1,-2,-3
echo

echo "Test: Excessive PID value (> max PID)"
echo "  ./page_owner_filter -p 4294967296"
./page_owner_filter -p 4294967296
echo

echo "Test: Too many PIDs (17 PIDs, max is 16)"
echo "  ./page_owner_filter -p 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17"
./page_owner_filter -p 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17
echo

echo
echo "--- 1.2 TGID Invalid Inputs ---"
echo "Test: Negative TGID"
echo "  ./page_owner_filter -t -1"
./page_owner_filter -t -1
echo

echo "Test: Non-numeric TGID"
echo "  ./page_owner_filter -t xyz"
./page_owner_filter -t xyz
echo

echo "Test: Empty TGID argument"
echo "  ./page_owner_filter -t"
./page_owner_filter -t
echo

echo "Test: TGID with special characters"
echo "  ./page_owner_filter -t '\$\$'"
./page_owner_filter -t '$$'
echo

echo "Test: Mixed valid/invalid TGID"
echo "  ./page_owner_filter -t 1,abc,2"
./page_owner_filter -t 1,abc,2
echo

echo
echo "--- 1.3 COMM Invalid Inputs ---"
echo "Test: Empty COMM argument"
echo "  ./page_owner_filter -c"
./page_owner_filter -c
echo

echo "Test: COMM with only spaces"
echo "  ./page_owner_filter -c '   '"
./page_owner_filter -c "   "
echo

echo "Test: COMM with path separator"
echo "  Verify: Non-existent COMM is accepted but produces no output"
echo "  ./page_owner_filter -c 'invalid/name'"
./page_owner_filter -c "invalid/name"
echo

echo "Test: Empty COMM in list (consecutive commas)"
echo "  ./page_owner_filter -c 'test,,another'"
./page_owner_filter -c "test,,another"
echo

echo "Test: Empty COMM at end"
echo "  ./page_owner_filter -c 'test,'"
./page_owner_filter -c "test,"
echo

echo "Test: Empty COMM at start"
echo "  ./page_owner_filter -c ',test'"
./page_owner_filter -c ",test"
echo

echo "Test: Extremely long COMM in a list"
echo "  ./page_owner_filter -c 'short,very_long_process_name,another'"
./page_owner_filter -c "short,very_long_process_name,another"
echo

echo
echo "--- 1.4 Cgroup Invalid Inputs ---"
echo "Test: Empty cgroup path"
echo "  ./page_owner_filter -g"
./page_owner_filter -g
echo

echo "Test: Non-existent cgroup path"
echo "  ./page_owner_filter -g /nonexistent/path/that/does/not/exist"
./page_owner_filter -g /nonexistent/path/that/does/not/exist
echo

echo "Test: Cgroup path with spaces"
echo "  ./page_owner_filter -g '/path with spaces'"
./page_owner_filter -g "/path with spaces"
echo

echo "Test: Cgroup exists but has no memory controller"
TEST_PARENT_DIR="test_no_memcg_parent_$$"
TEST_CHILD_DIR="test_child"

if [ -d "/sys/fs/cgroup/memory" ]; then
	# cgroup v1: /cpuset exists but lacks memory controller
	echo "  ./page_owner_filter -g /cpuset"
	echo "  Note: /cpuset exists under memory/ but lacks memory.stat (cgroup v1)"
	./page_owner_filter -g /cpuset
else
	# cgroup v2: create parent without memory in subtree_control
	TEST_PARENT_PATH="/sys/fs/cgroup/$TEST_PARENT_DIR"
	TEST_CHILD_PATH="$TEST_PARENT_PATH/$TEST_CHILD_DIR"

	if mkdir -p "$TEST_PARENT_PATH" 2>/dev/null && \
	   echo "-memory" > "$TEST_PARENT_PATH/cgroup.subtree_control" 2>/dev/null && \
	   mkdir "$TEST_CHILD_PATH" 2>/dev/null; then
		if [ -d "$TEST_CHILD_PATH" ]; then
			echo "  ✓ Created: $TEST_CHILD_PATH"
			if [ -f "$TEST_CHILD_PATH/memory.stat" ]; then
				echo "  ✗ Test setup failed: $TEST_CHILD_PATH/memory.stat exists (should not)"
			else
				echo "  ✓ Verified: $TEST_CHILD_PATH/memory.stat does not exist"
			fi
			echo "  Note: page_owner_filter should detect missing memory.stat"
			echo "  ./page_owner_filter -g /$TEST_PARENT_DIR/$TEST_CHILD_DIR"
			./page_owner_filter -g "/$TEST_PARENT_DIR/$TEST_CHILD_DIR"
		else
			echo "  ✗ Failed to create: $TEST_CHILD_PATH"
		fi
		rmdir "$TEST_CHILD_PATH" 2>/dev/null
		rmdir "$TEST_PARENT_PATH" 2>/dev/null
	else
		echo "  (skipped - cannot create test cgroup)"
	fi
fi
echo

echo "Test: Cgroup path exceeding PATH_MAX"
LONG_PATH="/$(head -c 4100 /dev/zero | tr '\0' 'a')"
echo "  Generated path length: ${#LONG_PATH}"
echo "  ./page_owner_filter -g '<very long path>'"
./page_owner_filter -g "$LONG_PATH"
echo

echo "Test: Multiple cgroup paths (last one wins)"
echo "  ./page_owner_filter -g /user.slice -g /sys/fs/cgroup"
echo "  Verify: Tool accepts multiple -g and uses the last one"
echo "  Note: /sys/fs/cgroup is invalid"
./page_owner_filter -g /user.slice -g /sys/fs/cgroup
echo

echo
echo "--- 1.5 General Invalid Options ---"
echo "Test: Invalid option flag"
echo "  ./page_owner_filter -x"
./page_owner_filter -x
echo

echo "Test: Unknown filter combination"
echo "  ./page_owner_filter -q 123"
./page_owner_filter -q 123
echo

echo "--- 1.6 Mixed Invalid ---"
echo "Test: Valid PID + valid cgroup + invalid NID (node 4 doesn't exist)"
echo "  Verify: Invalid NID should cause rejection even with valid other filters"
echo "  ./page_owner_filter -p 1 -g / -n 4"
./page_owner_filter -p 1 -g / -n 4
echo

# ============================================================================
# Section II: PID 1 and Root Cgroup Tests
# ============================================================================
echo
echo -e "${YELLOW}=== II. PID 1 AND ROOT CGROUP TESTS ===${NC}"
echo

echo "--- 2.1 PID Filter with PID 1 ---"
echo "Test: Filter by PID 1 (init/systemd)"
echo "  ./page_owner_filter -p 1 | head -20"
./page_owner_filter -p 1 | head -20
echo "Verify: All pages should be from PID 1"
echo "  ./page_owner_filter -p 1 | grep -o \"pid [0-9]*,\" | sort | uniq -c"
./page_owner_filter -p 1 | grep -o "pid [0-9]*," | sort | uniq -c
echo

echo "--- 2.2 TGID Filter with PID 1's TGID ---"
echo "Test: Filter by TGID of PID 1"
echo "  ./page_owner_filter -t 1 | head -20"
./page_owner_filter -t 1 | head -20
echo "Verify: All pages should be from TGID 1"
echo "  ./page_owner_filter -t 1 | grep -o \"tgid [0-9]* \" | sort | uniq -c"
./page_owner_filter -t 1 | grep -o "tgid [0-9]* " | sort | uniq -c
echo

echo "--- 2.3 COMM Filter with systemd/init ---"
echo "Test: Filter by systemd (or init if systemd not present)"
echo "  ./page_owner_filter -c systemd | head -20"
./page_owner_filter -c systemd | head -20
echo "Verify: All pages should be from systemd"
echo "  ./page_owner_filter -c systemd | grep -o \"([a-z]*),\" | sort | uniq -c"
./page_owner_filter -c systemd | grep -o "([a-z]*)," | sort | uniq -c
echo

echo "--- 2.4 Cgroup Filter with Root Cgroup ---"
echo "Test: Filter by root cgroup /"
echo "  ./page_owner_filter -g / | head -20"
./page_owner_filter -g / | head -20
echo "Verify: All pages with memcg info should be charged to root cgroup"
echo "  Total pages:"
echo "    ./page_owner_filter -g / | grep -c \"^Page allocated\""
./page_owner_filter -g / | grep -c '^Page allocated'
echo "  Charged memcg paths (should only show memcg /):"
echo "    ./page_owner_filter -g / | grep \"Charged to\" | grep -o \"memcg [^\"]*\" | sort | uniq -c"
./page_owner_filter -g / | grep "Charged to" | grep -o "memcg [^\"]*" | sort | uniq -c
echo

# ============================================================================
# Section III: Test Program (page_owner_test_alloc) Tests
# ============================================================================
echo
echo -e "${YELLOW}=== III. TEST PROGRAM FILTERS (WITH PAGE COUNT VERIFICATION) ===${NC}"
echo

# Find the running test_alloc process and get all 5 variables
TEST_PID=$(pgrep -f "page_owner_test_alloc" | head -1)
if [ -z "$TEST_PID" ]; then
    echo -e "${RED}ERROR: page_owner_test_alloc not running!${NC}"
    echo "Please start it first: ./page_owner_test_alloc &"
    echo
else
    echo "Found test program with main PID: $TEST_PID"

    # Get TGID (main process TGID, same for all threads)
    TEST_TGID=$(cat /proc/$TEST_PID/status 2>/dev/null | grep -i "^Tgid:" | awk '{print $2}')
    echo "TGID: $TEST_TGID"

    # Get the 3 thread PIDs (po_thread_a, po_thread_b, po_thread_c)
    THREAD_PIDS=$(ls -1 /proc/$TEST_PID/task/ | grep -v "^$TEST_PID$" | sort -n)
    TEST_PID_1=$(echo "$THREAD_PIDS" | sed -n '1p')
    TEST_PID_2=$(echo "$THREAD_PIDS" | sed -n '2p')
    TEST_PID_3=$(echo "$THREAD_PIDS" | sed -n '3p')

    # Get COMM names for each thread
    TEST_COMM_1=$(cat /proc/$TEST_PID_1/comm 2>/dev/null | tr -d '\n')
    TEST_COMM_2=$(cat /proc/$TEST_PID_2/comm 2>/dev/null | tr -d '\n')
    TEST_COMM_3=$(cat /proc/$TEST_PID_3/comm 2>/dev/null | tr -d '\n')

    echo "Thread 1: PID=$TEST_PID_1, COMM=$TEST_COMM_1, cgroup=/test_a"
    echo "Thread 2: PID=$TEST_PID_2, COMM=$TEST_COMM_2, cgroup=/test_b"
    echo "Thread 3: PID=$TEST_PID_3, COMM=$TEST_COMM_3, cgroup=/test_c"
    echo

    # --- 3.1 Individual Filter Tests with Page Counts ---
    echo "Note: Each thread allocates 1MB (~256 pages)"

    echo "--- 3.1 Thread 1 (po_thread_a) Verification ---"
    echo "  ./page_owner_filter -p $TEST_PID_1 | grep -c PFN"
    PID1_COUNT=$(./page_owner_filter -p "$TEST_PID_1" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -c $TEST_COMM_1 | grep -c PFN"
    COMM1_COUNT=$(./page_owner_filter -c "$TEST_COMM_1" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -g test_a | grep -c PFN"
    CGROUP1_COUNT=$(./page_owner_filter -g test_a 2>/dev/null | grep -c "PFN" || echo "0")

    echo "  By PID (-p $TEST_PID_1):   $PID1_COUNT pages"
    echo "  By COMM (-c $TEST_COMM_1): $COMM1_COUNT pages"
    echo "  By cgroup (-g test_a):   $CGROUP1_COUNT pages"
    echo

    echo "--- 3.2 Thread 2 (po_thread_b) ---"
    echo "  ./page_owner_filter -p $TEST_PID_2 | grep -c PFN"
    PID2_COUNT=$(./page_owner_filter -p "$TEST_PID_2" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -c $TEST_COMM_2 | grep -c PFN"
    COMM2_COUNT=$(./page_owner_filter -c "$TEST_COMM_2" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -g test_b | grep -c PFN"
    CGROUP2_COUNT=$(./page_owner_filter -g test_b 2>/dev/null | grep -c "PFN" || echo "0")

    echo "  By PID (-p $TEST_PID_2):   $PID2_COUNT pages"
    echo "  By COMM (-c $TEST_COMM_2): $COMM2_COUNT pages"
    echo "  By cgroup (-g test_b):   $CGROUP2_COUNT pages"
    echo

    echo "--- 3.3 Thread 3 (po_thread_c) ---"
    echo "  ./page_owner_filter -p $TEST_PID_3 | grep -c PFN"
    PID3_COUNT=$(./page_owner_filter -p "$TEST_PID_3" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -c $TEST_COMM_3 | grep -c PFN"
    COMM3_COUNT=$(./page_owner_filter -c "$TEST_COMM_3" 2>/dev/null | grep -c "PFN" || echo "0")
    echo "  ./page_owner_filter -g test_c | grep -c PFN"
    CGROUP3_COUNT=$(./page_owner_filter -g test_c 2>/dev/null | grep -c "PFN" || echo "0")

    echo "  By PID (-p $TEST_PID_3):   $PID3_COUNT pages"
    echo "  By COMM (-c $TEST_COMM_3): $COMM3_COUNT pages"
    echo "  By cgroup (-g test_c):   $CGROUP3_COUNT pages"
    echo

    # --- 3.4 Summary Table ---
    TOTAL_PID_COUNT=$((PID1_COUNT + PID2_COUNT + PID3_COUNT))
    TOTAL_COMM_COUNT=$((COMM1_COUNT + COMM2_COUNT + COMM3_COUNT))
    TOTAL_CGROUP_COUNT=$((CGROUP1_COUNT + CGROUP2_COUNT + CGROUP3_COUNT))
    echo "--- 3.4 Summary: All Thread Counts ---"
    printf "%-15s %-15s %-15s %-15s\n" "Thread" "By PID" "By COMM" "By Cgroup"
    printf "%-15s %-15s %-15s %-15s\n" "---------------" "---------------" "---------------" "---------------"
    printf "%-15s %-15s %-15s %-15s\n" "$TEST_COMM_1" "$PID1_COUNT" "$COMM1_COUNT" "$CGROUP1_COUNT"
    printf "%-15s %-15s %-15s %-15s\n" "$TEST_COMM_2" "$PID2_COUNT" "$COMM2_COUNT" "$CGROUP2_COUNT"
    printf "%-15s %-15s %-15s %-15s\n" "$TEST_COMM_3" "$PID3_COUNT" "$COMM3_COUNT" "$CGROUP3_COUNT"
    printf "%-15s %-15s %-15s %-15s\n" "TOTAL" "$TOTAL_PID_COUNT" "$TOTAL_COMM_COUNT" "$TOTAL_CGROUP_COUNT"
    echo

    echo "--- 3.6 Multi-PID List Test ---"
    echo "  Verify: PID list equals sum of individual PIDs"
    echo "  Expected count: $TOTAL_PID_COUNT"
    ALL_PIDS="$TEST_PID_1,$TEST_PID_2,$TEST_PID_3"
    echo "  ./page_owner_filter -p $ALL_PIDS | grep -c PFN"
    ./page_owner_filter -p "$ALL_PIDS"| grep -c "PFN"
    echo

    echo "  ./page_owner_filter -p $TEST_PID | grep -c PFN"
    ./page_owner_filter -p "$TEST_PID" | grep -c "PFN"
    echo

    FOUR_PIDS="$TEST_PID,$ALL_PIDS"
    echo "  ./page_owner_filter -p $FOUR_PIDS | grep -c PFN"
    ./page_owner_filter -p "$FOUR_PIDS" | grep -c "PFN"
    echo

    echo "  Verify: TGID equals sum of all PIDs in thread group (4 PIDs)"
    echo "  Expected count: -p $FOUR_PIDS"
    echo "  ./page_owner_filter -t $TEST_TGID | grep -c PFN"
    ./page_owner_filter -t "$TEST_TGID" | grep -c "PFN"
    echo

    echo "--- 3.7 COMM Wildcard Test ---"
    echo "  Verify: Wildcard matches all thread COMMs (should equal sum of thread counts)"
    echo "  Expected count: $TOTAL_COMM_COUNT"
    echo "  ./page_owner_filter -c 'po_thread_*' | grep -c PFN"
    ./page_owner_filter -c 'po_thread_*' | grep -c "PFN"
    echo

    echo "  ./page_owner_filter -c 'page_owner_test' | grep -c PFN"
    ./page_owner_filter -c 'page_owner_test' | grep -c "PFN"
    echo

    echo "  Verify: COMM list equals sum of individual COMMs"
    echo "  Expected count: $TOTAL_COMM_COUNT + -c 'page_owner_test'"
    echo "  ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -c PFN"
    ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -c "PFN"
    echo
    echo "  Verify: Should only show current test PIDs"
    echo "  ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -o \"pid [0-9]*,\" | sort | uniq -c"
    ./page_owner_filter -c 'po_thread_*,page_owner_test' | grep -o "pid [0-9]*," | sort | uniq -c
    echo "  Note: Previous test program PIDs may appear with small page counts (~10-20) due to kernel cache"
    echo

fi

# ============================================================================
# Section IV: Combination Filter Tests
# ============================================================================
echo
echo -e "${YELLOW}=== IV. COMBINATION FILTER TESTS ===${NC}"
echo

echo "--- 4.1 PID + Cgroup Combination ---"
echo "Test: PID 1 with Root Cgroup"
echo "  Verify: Should only show PID 1 pages in root cgroup"
echo "  ./page_owner_filter -p 1 -g / | grep -o \"pid [0-9]*,\" | sort | uniq -c"
./page_owner_filter -p 1 -g / | grep -o "pid [0-9]*," | sort | uniq -c
echo "  Verify: All pages should be charged to root cgroup (total pages = charged pages count)"
echo "  Total pages:"
echo "    ./page_owner_filter -p 1 -g / | grep -c \"^Page allocated\""
./page_owner_filter -p 1 -g / | grep -c "^Page allocated"
echo "  Charged memcg paths:"
echo "    ./page_owner_filter -p 1 -g / | grep \"Charged to\" | grep -o \"memcg [^\"]*\" | sort | uniq -c"
./page_owner_filter -p 1 -g / | grep "Charged to" | grep -o "memcg [^\"]*" | sort | uniq -c
echo

echo "--- 4.2 COMM + NID Combination ---"
echo "Test: systemd with Node 0 filter"
echo "  ./page_owner_filter -c systemd -n 0 | head -10"
./page_owner_filter -c systemd -n 0 | head -10
echo "  Verify: Should only show systemd pages on node 0"
echo "    ./page_owner_filter -c systemd -n 0 | grep -o \"([a-z]*),\" | sort | uniq -c"
./page_owner_filter -c systemd -n 0 | grep -o "([a-z]*)," | sort | uniq -c
echo "    ./page_owner_filter -c systemd -n 0 | grep \"PFN\" | grep -o \"node=[0-9]\" | sort | uniq -c"
./page_owner_filter -c systemd -n 0 | grep "PFN" | grep -o "node=[0-9]" | sort | uniq -c
echo

if [ -n "$TEST_PID_1" ]; then
    echo "--- 4.3 Test Program Filter Combinations ---"
    echo "  Note: Process filters (PID/TGID/COMM) use OR logic among themselves,"
    echo "        but AND logic with other filters (e.g., cgroup)"
    echo
    echo "  expected: TGID page count, max of PID or TGID count)"
    echo "  ./page_owner_filter -p $TEST_PID_1 -t $TEST_TGID | grep -c PFN"
    ./page_owner_filter -p "$TEST_PID_1" -t "$TEST_TGID" | grep -c "PFN"
    echo

    echo "  expected: max of PID or COMM count"
    echo "  ./page_owner_filter -p $TEST_PID_1 -c $TEST_COMM_1 | grep -c PFN"
    ./page_owner_filter -p "$TEST_PID_1" -c "$TEST_COMM_1" | grep -c "PFN"
    echo

    echo " expected: TGID page count,max of TGID or COMM count"
    echo " ./page_owner_filter -t $TEST_TGID -c $TEST_COMM_1 | grep -c PFN"
    ./page_owner_filter -t "$TEST_TGID" -c "$TEST_COMM_1" | grep -c "PFN"
    echo

    echo " AND logic: both must match"
    echo "  ./page_owner_filter -p $TEST_PID_1 -g /test_a | grep -c PFN"
    ./page_owner_filter -p "$TEST_PID_1" -g /test_a | grep -c "PFN"
    echo
fi

# ============================================================================
# Summary
# ============================================================================
echo
echo "========================================="
echo -e "${YELLOW}Tests completed${NC}"
echo "========================================="
echo
echo "Summary of test categories:"
echo "  I.   Invalid inputs for all filters"
echo "  II.  PID 1 and root cgroup tests"
echo "  III. Test program specific tests (with page count verification)"
echo "  IV.  Combination filter tests"
echo
echo "Please review output above for any errors or unexpected behavior."

Zhen Ni (8):
  mm/page_owner: Add PID filtering support
  mm/page_owner: Add TGID filtering support
  mm/page_owner: Add COMM filtering with wildcard support
  mm/page_owner: Refactor memcg handling for cgroup filter support
  mm/page_owner: Add memcg filter support
  tools/mm: Add PID/TGID/COMM filtering support to page_owner_filter
  tools/mm: Add memory cgroup filtering support to page_owner_filter
  Documentation: page_owner: Document PID/TGID/COMM and cgroup filters

 Documentation/mm/page_owner.rst |  25 ++-
 mm/Kconfig.debug                |   1 +
 mm/page_owner.c                 | 308 +++++++++++++++++++++++++++++---
 tools/mm/page_owner_filter.c    | 226 ++++++++++++++++++++---
 4 files changed, 514 insertions(+), 46 deletions(-)

-- 
2.20.1


