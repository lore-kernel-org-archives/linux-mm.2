Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB6BAC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 653C56B00AF; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568026B00AD; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1536B00B1; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC3106B00AD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 731631602D3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:27 +0000 (UTC)
X-FDA: 85018036614.16.29B70C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 730071C000A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XlQib/ow";
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdIFcw63nI55tXnnq9HyDHNflovMasXB+BvJ6U9DMyA=;
	b=KYkFg+vaBxidDoBSyC6Lz5QBMWm2L0a4yfAhr5DZzxThdJWQjwLIOM19vLP87RtObcWNg4
	qSAgSB3DZLdKsNZfuLKhv77XOlYVbc+vp+6hf/d6H2IyW17yJPc6pJ8k+kenOjFs9xzrE7
	/49ECM4q2QZ47UHBOkoMF0VZvN7M2tM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763685;
	b=Nqg6UdYnH3Gc+kbqBMMkVB5cAqaphFknNahYbEOv3CxfE6Y32awV6mbEOos9f/c9LfwAtn
	CG/9Xnc9lyEeGL7sBunLOK9rdX1OUbwm53Q9sE0nBKXPow+gEobmTqRwYgdVhpyJgFh/Be
	PFbgmTQ7YUc0fENSbN77Q0YsMKyyhsY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XlQib/ow";
	spf=pass (imf20.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E208E45168;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF269C2BCF7;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=IaSkp3fdmtv7NRhfe3SroO5xQIMOPLdrrRcj/2IEtlE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XlQib/owPAVh3H7KfaNS4PyZkmlCbiHxJjSJbi29AcA2PUhaNCMdYbn3nFoRKC9xf
	 9z7uj6VoT2q8h7zOKugYJorEvmpU3Ogas/oag/J0kR4AO2H+LU63b7FxgJ4Gr1HRvm
	 XgUXx2mabgUEG1SbqIrZybG/YFb+q/b8g/7wgFb08ytsJltdsj4feTnw9aEAejYHuR
	 E9YKl0Fbd/Wm5TdI5yiu0eV1JkPbKkcLxscGACQJPCWJW1kfX8kMWHjTV0SZP4ji1m
	 zTuPDeKmBWVqyzfVfxxz5YIWSu284D3KT0zYL+zxGSRlK87q7wKxeFgXEQCE/u3/cC
	 j7G2h1Adnf0Mw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA00C4453F;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:22 -0700
Subject: [PATCH v4 14/16] WIP: Reproducer for subpool usage leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-14-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=4644;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=E4drmq1mZkjUTuE98aQslvvt9cikJbWZghcgFkli30k=;
 b=HiSFLR0mil6K38uaer8wl9Fy+05WtiROHkCptxCr9umgO7pDRf//LRN/q++nLpLWmSKUyE1xs
 3Zjk/paa3R0Cx5A8PWmokVRUBC6lXEwTZfCv4jw5HxO6WGQpOvLFmfx
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 730071C000A
X-Stat-Signature: 8qguf8r1ud9af5kx86r46af7m5dxt9re
X-Rspam-User: 
X-HE-Tag: 1784763685-754372
X-HE-Meta: U2FsdGVkX1/Si1SNJekA+Vp+FAbWgBNda/HfJRlWp5KScFrWTjhqC1iVsi+CQwJxFKg0b/PYHTCSrxenFVfvr4ev6qUSS5nv6Mw9HcURo8htAwRHoZbibEITXWAdCA9/gqBHQauq7V9Hyl08J5JHMQkkZStGBHHZ92xhViVqwxIGGgWxe6ex0lPM0O/koseoVDl/XikRbwddSKRF3ME0Ha+0E2Qu3CUZDsQxAr63VxjqfKwRJY/R2m7pfYlpxjkqD7uEw8+TGMLMGZrX/mKBgRIjzZQDMgK8vjVVm2HNXmDcxnOS947UrakycuhEnI/AknqoTYs5oKHvTeOeUNqdl/qXddXU8TfZV5QamqFzn20mEHVmkdybLeLsjAG4xufJiPheBgqzgJiNbQOOMeVYB9khvUck4RoCIUiOoV+ySzqwFW5RAKjeJBnV8w/zCiekkg29HNXBedPIEFRCVXKgtaAAJCV5+Mw2JZ3qzGnxzXw7VLjnKenSDODMRWGcmkOcWrGQ8kqreb+ADRaiPE3sCAdHXfv0CLp/Yde89kxlvufkalmqWNWyqA6mJndoypqLA1yzYl/Qsf3/srlJiErEIoRViHlxi0qbUWLYvkAXWl2NtwbQDkShvuFstqrlGOj4lp4Wtf0W+flP9Q9yPCFORbyOmxnHWU6u2yS3k2pwq/wMNxNnFvJAGDscaYQN2jlroEVjzr79GWA6WTVekBO2tWq+WDrIt6nIz0a4Tp6g884XvvcSZqpLJeX5m4vwrAh2JqXJ2qUx2r3yT9iyIgzbOXR/JqXvZ7f/CXnw1QSphrTlgCAm0e+iodCWbonN6SdkJF022fbU/UV7IcQkA1UKLDY0/7uGZqMcUmTTMkyppCYaDLxZophI58YV6SLh8BmQu7z/H3qim2KRy4pmpc4xGwiBqgcUxd9F3rfHu+Un32BSMCELMREYn/XcBU8JP1EtT/hHYNBzBGsjBmQ6b2i
 CQniwX/K
 zBuA88sZkrM5KCjWJK60UKAuS16aV9j8ILtNFXp5uvkKhWs90Dy21P2tTqdfkMT/2DW+aP+Oacw5FNA4WfPks+MiiaSM3fukb9q5Mb///Q6cInvkXqjIOpy/Wifr05X6mKfblVbAeHggN4l8abiQ/84PphFYsyYeYe23TXktGQFnxz0IP6hoU7oe5GoIucWmKtyRq1msLkc5R2TFdTQ9TwjEBCo/KkIw6Aqh4pwuTJsOp37y8KBieypqMORNurrLOtATxFVhq1fQi03aTD4ZeuxAd2tFq1B8D8U2ItJkzEpRmGzLtYNHiVSkuuBoeL3r6IYTyh2O31w6WSzOoy5uiYJrogeHnHEdTozQboZh8EVvEIaY40RqDxNCzjytnlL2URsOsvMSs9bj7NepnltD8rk0Scwu7ZdGO4QvZTQPeAIOOYFX7FJIu1yd+Ipg6ia5Ae6iINba9HuqfkMaoOOD4CxzTMWmLmj069fgeLiMU0ewhelapyW7L9ej32A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

(This reproducer was hacked up and not meant to be merged.)

The kernel leaks subpool usage and the subpool structure itself if a HugeTLBfs
mount specifying size (which sets max_hpages on the subpool) is created.

subpool_leak_max_size.sh reproduces this with the following steps:

1. Create mount, specifying size=2M (1 page). This sets max_hpages = 1 on the
   subpool, but does not reserve any pages.
2. Set nr_hugepages = 0 and nr_overcommit_hugepages = 0 so that physical
   allocations will fail.
3. Run fallocate -l 2M on a file in the mount.
     + This calls hugetlbfs_fallocate, which attempts to allocate a page by
       calling alloc_hugetlb_folio.
     + alloc_hugetlb_folio calls hugepage_subpool_get_pages to track the
       allocation against the subpool limit. This increments used_hpages to 1.
     + Physical allocation fails because nr_hugepages is 0.
     + Before patch (Buggy):
         + The error path in alloc_hugetlb_folio sees gbl_chg is 1 (indicating
           we tried to allocate a global page) and incorrectly skips calling
           hugepage_subpool_put_pages.
         + fallocate fails and returns to userspace, but the subpool used_hpages
           counter remains leaked at 1.
     + After patch:
         + The error path always calls hugepage_subpool_put_pages if map_chg is
           true, restoring used_hpages to 0.

4. Unmount the filesystem.
     + During unmount, the kernel calls unlock_or_release_subpool to clean up
       the subpool.
     + It checks if the subpool is free using subpool_is_free, which returns
       whether used_hpages is 0.
     + Before patch (Buggy):
         + Since used_hpages leaked and is 1, subpool_is_free returns false.
         + The kernel skips freeing the subpool structure, leaking the
           hugepage_subpool structure in kernel memory.
     + After patch:
         + Since used_hpages is 0, subpool_is_free returns true, and the subpool
           structure is correctly freed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 subpool_leak_max_size.sh | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/subpool_leak_max_size.sh b/subpool_leak_max_size.sh
new file mode 100755
index 0000000000000..226fd2766c4d0
--- /dev/null
+++ b/subpool_leak_max_size.sh
@@ -0,0 +1,72 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [ "$EUID" -ne 0 ]; then
+    echo "Please run as root"
+    exit 1
+fi
+
+MNT_PATH="/tmp/mnt_hugetlb"
+FILE_PATH="$MNT_PATH/test_file"
+
+# Save original values
+orig_nr=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+orig_overcommit=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages)
+
+cleanup() {
+    echo "Cleaning up..."
+    rm -f "$FILE_PATH"
+    umount "$MNT_PATH" 2>/dev/null
+    rmdir "$MNT_PATH" 2>/dev/null
+    echo "$orig_nr" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+    echo "$orig_overcommit" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
+    echo "Cleanup done."
+}
+trap cleanup EXIT
+
+# 1. Mount hugetlbfs with size=2M (1 page)
+mkdir -p "$MNT_PATH"
+if ! mount -t hugetlbfs -o size=2M none "$MNT_PATH"; then
+    echo "Failed to mount hugetlbfs"
+    exit 1
+fi
+
+# 2. Set nr_hugepages to 0, overcommit to 0
+echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
+
+# Check subpool usage before running
+read total free < <(stat -f -c "%b %f" "$MNT_PATH")
+used_before=$((total - free))
+echo "Before test - Subpool total blocks: $total"
+echo "Before test - Subpool free blocks:  $free"
+echo "Before test - Subpool used blocks:  $used_before"
+if [ "$used_before" -ne 0 ]; then
+    echo "ERROR: Subpool is not clean before test starts!"
+    exit 1
+fi
+
+# Run fallocate (expecting failure)
+echo "Running fallocate (expecting failure)..."
+if fallocate -l 2M "$FILE_PATH" 2>/dev/null; then
+    echo "ERROR: fallocate succeeded but should have failed (nr_hugepages is 0)"
+    exit 1
+fi
+
+# Check subpool usage via statfs
+# %b: Total blocks
+# %f: Free blocks
+read total free < <(stat -f -c "%b %f" "$MNT_PATH")
+used=$((total - free))
+
+echo "Subpool total blocks: $total"
+echo "Subpool free blocks:  $free"
+echo "Subpool used blocks (leaked if > 0): $used"
+
+if [ "$used" -gt 0 ]; then
+    echo "RESULT: LEAK DETECTED (FAIL)"
+    exit 1
+else
+    echo "RESULT: NO LEAK (PASS)"
+    exit 0
+fi

-- 
2.55.0.229.g6434b31f56-goog



