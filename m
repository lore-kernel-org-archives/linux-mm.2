Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75290C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:00:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B43D6B00C6; Thu,  3 Sep 2026 08:00:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064FE6B00C7; Thu,  3 Sep 2026 08:00:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95756B00CA; Thu,  3 Sep 2026 08:00:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB31A6B00C6
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:00:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD581120526
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:00:11 +0000 (UTC)
X-FDA: 85172307822.08.60A33C3
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id D145F1C000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:00:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788436810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=exe9gH8ZCgXsjgub53/pgdClh+0J3naTnNaDlq3M7PA=;
	b=wKCKAid//qzfTb/ymo507o7ml0f7d9Zlys3PgsMwG6f+i8p71mIGCDcqnuAc4qcLA7sD8O
	TCZbpQ+j0NBYGW8U2zrQ+2sz0hoxvDr9pkrcKE6aK6Fx5Pp6mN3zSoY93U3RgwVYAiqFuR
	DyLFvXSMUmPBXFhNhQx3V/2+eFVe+pk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788436810;
	b=AVWRt2q16sWRoCRrLFFTHFPujkWzlIfEmT6pOKIxuuJX4UXUZoii18ITXOdYQEYaPuhg8S
	B4rEhGCyTDGG9l9XZQcvYRXfFs3gXCucAMgnfbIPCIWC1qhNPb4eMlvOm6tPxgtieEuSSN
	1JXYqIzP5Tmt0RNvhwkX+XDV13aTM2M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf20.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1ea93ff09;
	Thu, 3 Sep 2026 20:00:02 +0800 (GMT+08:00)
Message-ID: <1fa33d97-2e53-4ad1-9e15-8b4aa4e09875@easystack.cn>
Date: Thu, 3 Sep 2026 20:00:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup
 filtering
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260903041819.1776630-1-zhen.ni@easystack.cn>
 <20260902221225.228fb4b18e115ba55b29fe29@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhen Ni <zhen.ni@easystack.cn>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260902221225.228fb4b18e115ba55b29fe29@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa06723eac10229kunm4cefcc8e55b31
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCS0xPVkIfTExMSUIZGEJIQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	hKSkJMVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D145F1C000E
X-Stat-Signature: o9m83jrbfmfptuymd3tj6w6qkk56b6e4
X-HE-Tag: 1788436808-605414
X-HE-Meta: U2FsdGVkX1/AWUX6vjosUx+LAYJDhejKx6gNEG7q+aqKVXTgsRuCiVTvpwaI7XShCDVSBC9IaIhrcHLjDgaMS2n9t3IeG0Zh0VDEOee6VX7Lgj6C0ec3JgmkY01Bj9CSRjxHM4Qk3M2cq7Q+aGg0h8sMrt4Uk53CEiWLOERWZ/ZzaqO5ROBhzOTqlUxK23hbZqmd2jQM554yqHSqOroSgonZwsdMmdpwfKEjkzEPgoI1Ph9RO//i5QY0O2Age1NsbgYIJ7pleW63DeT2AnzsCYjqTfmiRR4//6nTfmqGffEr5/4/vgz4ZcCG4EfDUfoecmnVlyD1cb7H0vDfKlTFzJo6I1V6qLzuG5WB/iZ0QjEEDmu9sdyE29LOESOFF4YkvnZNbKf/0K9T4hFRxCdA4hy7fH4vhX6i+xFkNRqraB77l9MMfpEGM46A+7Wiof3Rg+drhOJPYymfW1/IsK81jNlu6EmC7e+k+vL3ZAJrxKlcYfvpFj3EUHZ8aVIxZd1cEktEyY3yv/ApKSB05hSABgX1J56NC5+9IfB5vw5UbXghsE2tSbzU/ObiZbq74rdvSGKKHeLdGMnPIXOxzA0rg61zPd0eiIyz1YbdB/3b30huk+r0EHKTutf9FSboeKJ2kxXOlDm5SjkjewxWAsBMZ9wcLdEnUf8JIuxuSvBu+CNIUis7nxwBX+uJvc2sPaY56EpLNFmt8bWFE7tJ+03Ii4YadiFFE8wJSVTAw1m5j0TnU2HE34NvPefzgSDTX5F4okDNTjrgMlcG2LWaSc0UWH7QcqpeYrORyV1aWk7J7z9HLK0PMxx1tnd2NMTPoqnkpL+7rF2HfL5dgKK6Gd5pslgdK/F8++TqBeEB5KA1XowTgUysLOn82eEekfGz7kUNHNXGS3jTTNS8+jZSpoovQcBjR5yEQn3w+0F5wqKyM26aMIYCZ0Mz+acTvoh63bxW2RXok5ZLNwPUGPceBGv
 u3dRxDDE
 0waxNNYqQqPKXPlD1YL5wH1LJi2THB8TKpPqpIFRD6NILmPo/fKJRAU970xiF1Imx8hg7nbVtUrFuDnvvCplxuZKyRzw+hWlswouRGBgU0fcbimIqvpoLeo3ta0h7ADqSS31Ex2XWJ5IjC5UQmrdnjiei5mfBjfAkXDOuJKMsmDkb5gKI8QiEzSf1h3QuQmXs9Isv/zmrk+FEdFZYSim84oq3/vwloNj1rPaEfiQ8wmt7IaHW+yoP3Yq34pO82XyhAvdZgKojAWGQQB7HgGK1R4ML3cl45b8wQ2pR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/3 13:12, Andrew Morton 写道:
> On Thu,  3 Sep 2026 12:18:11 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series adds process and memory cgroup filtering support to
>> page_owner.
> 
> Cool.  Is any of this useful?
> 	https://sashiko.dev/#/patchset/20260903041819.1776630-1-zhen.ni@easystack.cn
> 
> 

Hi Andrew,

All findings that v2 fixed are confirmed gone. Replies to the new
findings below, quoted verbatim, in report order.

 > Will this comparison safely handle concurrent updates to the PID?
 >
 > Since cmp_int() is a macro that evaluates the arguments twice:
 > ((a) > (b)) - ((a) < (b))
 >
 > And bsearch() below receives a pointer to page_owner->pid which can 
be updated
 > concurrently without locks, could the dereferenced pointer change 
between the
 > two evaluations?
 >
 > If the value changes from being less than the target to greater than the
 > target, both comparisons evaluate to false. This would cause cmp_int() to
 > incorrectly return 0 and falsely match unrelated processes.

[Shared-fd concurrency] Will not fix.
Reproducing it needs a concurrent writer updating page records while the
same fd is being read, which is outside the designed configure-then-read
usage. Whether to add spinlock protection for shared-fd read/write on a
non-production-grade debugging interface was already discussed at
length in the earlier series "mm/page_owner: add per-fd filter
infrastructure for print_mode and NUMA filtering"; the conclusion there
was that the locking cost does not match the benefit, shared-fd
read/write is not a recommended usage, and the recommendation is to
simply use the tool.

 > Does this array need to be zero-initialized?

Will not fix.
Nothing reads past the NUL terminator or beyond the valid entries.

 > Is new_proc_filter_enabled ever read after being initialized here?
 >
 > It seems this unused variable masks a logic bug below where 
state->pid_count
 > fails to clear when the filter is disabled.

The variable itself is indeed unused - the commit path recomputes the
flag from new_pid_count/new_tgid_count/new_comm_count directly, so the
staging copy can be dropped. Will remove it in v3.

[No clear-filter operation] But it masks no logic bug. There is no
clear operation by design. To start over, close the fd and open a
fresh one; the page_owner_filter tool already works this way. This
also matches the semantics of the original filter introduction (mode
and nid have always worked this way). A clear operation would be
over-design: the recommended page_owner_filter tool never needs it.
If one run does not produce the wanted result, the simplest fix is to
adjust the arguments and run it again, not to fight the already-set
filters on an open fd.

 > When a user writes a filter with fewer than MAX_FILTER_PIDS, does this
 > unconditional copy of sizeof(state->pid_list) capture uninitialized 
kernel
 > stack memory from new_pid_list into the heap-allocated state object?

Will not fix. The uninitialized tail is never read: bsearch is bounded
by state->pid_count.

 > If the filter is explicitly disabled (new_pid_count == 0), this block is
 > skipped and state->pid_count is not reset to 0.
 >
 > Will this cause the filter to be unintentionally re-enabled if a user
 > subsequently writes a different configuration like "mode=stack"?
 >
 > The old state->pid_count would be copied to new_pid_count during
 > initialization, causing state->proc_filter_enabled to be incorrectly set
 > back to true.

[No clear-filter operation] (see above).

 > Will this allocate the new_tgid_list array on the stack without
 > initialization?

Will not fix. bsearch on the tgid list is bounded by
state->tgid_count, so the uninitialized tail is never consumed.

 > If a user tries to clear a PID filter by writing "pid=" while a TGID
 > filter is still active, new_pid_count will be 0 but
 > state->proc_filter_enabled remains true.
 >
 > Will state->pid_count fail to update to 0 since the update block requires
 > new_pid_count > 0, resulting in the page_owner output continuing to 
filter
 > on stale criteria?

[No clear-filter operation] (see above).

 > When the filter is initially empty (state->tgid_count == 0),
 > new_tgid_list remains mostly uninitialized if only one element is set
 > (for example, writing "tgid=123").
 >
 > Does this unconditional copy of sizeof(state->tgid_list) copy 
uninitialized
 > stack memory into the heap-allocated state, potentially triggering a 
KMSAN
 > uninit-value warning?

Will not fix. Same as the pid list.

 > Similar to the PID filter above, if a user attempts to clear an active
 > TGID filter while a PID filter is active, does this new_tgid_count > 0
 > check prevent state->tgid_count from being zeroed and retain the stale
 > data?

[No clear-filter operation] (see above).

 > Can this lockless read of state->comm_list observe unterminated strings?
 > Without guaranteed NUL padding, this could cause an out-of-bounds 
access in
 > glob_match() if data races occur.

[Shared-fd concurrency] Will not fix.

 > Does this leave the trailing padding of the 16-byte slot uninitialized?
 > Since only up to the string length is initialized, the remainder of the
 > buffer may contain garbage.

Will not fix. glob_match() stops at the NUL written by strscpy(), so
the padding past it is never read.

 > Does returning -EINVAL for an empty list prevent users from clearing the
 > filter? If a user writes comm= to the /sys/kernel/debug/page_owner file,
 > the parser aborts. Other filters allow clearing their state by 
providing an
 > empty list.

[No clear-filter operation] (see above).

 > Does allocating this array without zero-initialization leave trailing 
bytes
 > as uninitialized memory? Replacing kmalloc_array() with kcalloc() (or 
using
 > kzalloc()) would prevent uninitialized heap memory from being used.

Will not fix. No consumer of the list reads past strscpy()'s NUL
terminator, so uninitialized bytes are unreachable.

 > Can this lockless update copy uninitialized heap memory into the shared
 > state structure? This can trigger KMSAN use-of-uninitialized-memory 
warnings.

Will not fix. Same reasoning as above; the relocated bytes are never
read.

 > Even if parse_comm_list() were modified to successfully return with
 > new_comm_count == 0, would skipping the update here permanently leave 
the old
 > filter active? state->comm_count is never reset to 0 in this function,
 > which breaks filter management on an open file descriptor.

[No clear-filter operation] (see above).

 > Can this lead to a NULL pointer dereference in strcmp() on weakly-ordered
 > architectures?
 >
 > A thread calling pwrite() on the page_owner file could be updating 
the filter
 > state while another thread concurrently calls pread(). Since 
page_owner_write()
 > updates the state without memory barriers:
 >
 > page_owner_write():
 >     strscpy(state->memcg_path, new_memcg_path, PATH_MAX);
 >     state->memcg_filter_enabled = true;
 >
 > Could the CPU commit the true flag to memory before the state->memcg_path
 > pointer is allocated or written? If the reader observes
 > state->memcg_filter_enabled == true but state->memcg_path is still NULL,
 > strcmp() will crash.

[Shared-fd concurrency], but with a distinction: a torn read that
mis-filters one or two pages is acceptable, a crash is not - so this
one is worth fixing without any locking. The fix is to snapshot the
pointer once:

	char *filter_path = READ_ONCE(state->memcg_path);


	if (!memcg_info.path || !filter_path ||
	    strcmp(memcg_info.path, filter_path) != 0)
		goto ext_put_continue;

Will include this in v3.

 > Is there a risk of a memory leak here if two threads write to the 
page_owner
 > file concurrently?
 >
 > VFS pwrite() does not hold f_pos_lock, so multiple threads could observe
 > !state->memcg_path simultaneously, perform the kzalloc(), and 
sequentially
 > overwrite the state->memcg_path pointer. Would this irrevocably lose the
 > first allocation?

[Shared-fd concurrency] (see above).

 > Since this filter accepts wildcard patterns like -c "[a-zA-Z]*worker*",
 > should the length check allow for patterns that exceed TASK_COMM_LEN?
 >
 > A valid glob pattern string can easily exceed the 15-character limit of
 > a process name because character classes and wildcards take up more 
space
 > than the literal characters they match.
 >
 > By applying TASK_COMM_LEN to the pattern string here, does this prevent
 > the use of complex but valid glob patterns?

Will not fix. The kernel itself truncates comm to TASK_COMM_LEN at
source - complex over-long wildcards are a corner case.
"[a-zA-Z]*worker*" works as "[a-z]*worker*" or simply "*worker*".

 > Similarly, does applying the TASK_COMM_LEN limit here incorrectly reject
 > valid wildcard strings for the last entry in the list?

Will not fix, same as above.

 > Does this limit prevent the use of maximum-length cgroup paths?
 >
 > Kernel path limits are typically 4096 bytes. Since the command buffer 
here is
 > limited to 2048 bytes, deeply nested but valid cgroup paths may fail to
 > process.

[Tool buffer sizes]
Will not fix. The kernel limit is indeed PATH_MAX (4096), but that is
an edge case - realistic cgroup paths are around 100 bytes, and the
buffer is already a 512-byte allowance, 5x the common case. The
MAX_CMD_LEN 2048 is likewise an estimate, not a design limit: a
precise worst-case sum of every parameter's maximum size would not be
worth the complexity, and the generous budget is more than enough in
practice.

 > Could this 512-byte array silently truncate long but valid cgroup paths?
 >
 > When snprintf is used later in this function, paths longer than this 
buffer
 > will be truncated. This will cause the access check to operate on an
 > incomplete path, failing validation and presenting a confusing error 
to the
 > user instead of correctly validating the path.

[Tool buffer sizes] (see above).

 > Is this heuristic reliable for detecting cgroup v2?
 >
 > On a cgroup v2 system, "memory" is a completely valid name for a 
cgroup. If
 > an administrator or runtime creates a cgroup named "memory" at the 
root, this
 > directory will exist.
 >
 > The tool would then incorrectly assume cgroup v1 semantics, which 
would cause
 > valid v2 paths to be falsely rejected during validation.

"/sys/fs/cgroup/memory" is indeed potentially not robust enough, but 
here our purpose is not to determine whether the cgroup is v1 or 
v2—rather, it is to check whether the memory controller itself is v1 or 
v2. Other mixed v1/v2 scenarios are not our concern, so we can directly 
check, similar to the code below.

	snprintf(cgroup_path, sizeof(cgroup_path),
		"/sys/fs/cgroup/%s/memory.stat", input_path);
	if (access(cgroup_path, F_OK) == 0)
		return 0;

	snprintf(cgroup_path, sizeof(cgroup_path),
		"/sys/fs/cgroup/memory/%s/memory.stat", input_path);
	if (access(cgroup_path, F_OK) == 0)
		return 0;

	fprintf(stderr, "Error: Cgroup path '%s': "
		"not found or no memory controller\n", path);
	return -1;

 > Will this fail to validate the root cgroup on v2 systems?
 >
 > If a user tries to filter by the root cgroup by passing "-g /", 
input_path
 > becomes an empty string. This snprintf call will then construct
 > "/sys/fs/cgroup//memory.stat".
 >
 > Since cgroup v2 does not expose memory.stat at the root hierarchy 
level, the
 > access check will fail, incorrectly rejecting the valid root filter and
 > preventing analysis of root-level allocations.

Not a bug, and the probe above covers it: for "-g /" the v2 candidate
is "/sys/fs/cgroup//memory.stat", path resolution collapses the double
slash, access() succeeds, and "-g /" passes on both cgroup v1 and v2
(cover letter, section 2.4).

If the above solution is acceptable, I will send the corresponding v3 
version.

Thanks,
Zhen Ni


