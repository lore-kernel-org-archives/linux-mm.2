Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DE7DC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE4B6B00AD; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9859F6B00B3; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8720E6B00AD; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31B966B00B3
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1C99140263
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:27 +0000 (UTC)
X-FDA: 85018036614.30.CF95ACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BFE4F40003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n5XrAiJt;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jf8N+muOOOR1x/1LsHGmGDd6QX1OCcv82RqKwanAaY=;
	b=3T5u2WPZs5gBvl06TFC0VmjJEm5ca5zc4m8Nd6dwrgOpwb8xJC4fVLZvnTJZBz7+Pz8xjt
	jF/EJYiymSartg7HalsL0gENoKNmmiWWY7h5Dl+xDOGczrqM88wMxewFP+picuXeb3AleG
	FT1cXCk+khCZIIPte2zXbdheejmbRAA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n5XrAiJt;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763685;
	b=5aieKRHajvb2HNWt/mF8GP5/hbZubYQwDxf8gxYI23zVhmPHQW20crx56HlRPleJo9pvRn
	hBc+prV8CIvjrtk35w6OEY/ywEjT0gGMoBlIq0EqpCYYwpzs0n6doJG2KEbItZ8JV2FqgP
	kSHyuUqm/SufH4wo58CDqtZUoDVl5qs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F29B145170;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D09D0C2BD00;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=IvYXLwNv9XVwtXfs6wx9Pgfw6OcM69QiA8/wA9jWf4E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=n5XrAiJtdeU8ncx5O9FD8WiOOKHr22PVoJUwVt3dU/yMA1mPX6KOnGz8xs8JN0WM9
	 IL/Hak3kVoSwWAj4nOQX44Ey67veSST8wrTKm7NVlTCnfPXk/FtDgGQ2S9RwzDrevv
	 tf8ilUHi2LPn3JFSip6Egi+3SfeBzGji1+zSeGJL3dGM+4MhxKLsJ+ITQAomH9zK6Q
	 XEIx2GcO5EHiJew3LMnftTZhcw3G4uQqkj4beRoRLygHJHucRuE3VLUUY9qWyD7az9
	 bHy+n3S+FCVmjFWW/dlg5Tx69EvnRlvzACYlb3axPi6tdcNggnHXR3lCaM+wqnU3el
	 pOYPjoDQgo0OA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA0DC44536;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:23 -0700
Subject: [PATCH v4 15/16] WIP: Reproducer for false restoration on shared
 HugeTLB mappings
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-15-88e8b81970dc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=7594;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nOc8hfbJ6YqAx29c86ZvsVDaWXvf89VuywJtSWZG1aU=;
 b=Ygf0ukiFfgWAOGov+mR9/g6iSz7wYPk1CkPXmJ7JASb36TG2/VHmKkIqNjbjhnVjLSzBvjNWm
 YF93xaa9IcrC4rhyvTWK3PH5804ubxkt3tuOoT9BAJXzFCKMO4dUDtv
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: BFE4F40003
X-Rspamd-Server: rspam01
X-Stat-Signature: 8xqwg7467e94b6dy34cnu7bzwgc1x7fs
X-HE-Tag: 1784763685-377839
X-HE-Meta: U2FsdGVkX1/SQA/5BAqPsw67EKHLZkvnTyizh0FyBv3rwpXJweYb1UhRS+Ncm1YU9gpAPz9tXq3iP/5O8tuUiyrBdnsFCfloAnFszG6a2UzK3S7/7N5tMxq0zfdb+OYK+TKy+EIv1ml1CVQznHzDjChsmvgSUz+Yd8v0dzxs1ParTWgmci3jxvR/9NgCq+m5l1tFd9r6vGVW4jk1t0ianmnHlxkx1n1k6+TDPl/EMeLEy2NvkeftNI5+eVnOWDs0pt5uu0HPLrgXoPbvMLAJpqI//JL63SccxwIymAJLPB5dtN6PIf+HTuuucE/s/UZnvocE9eBqUriQ++0WRMfSSfAhHtO0/0oYSmI2qVUVi2imMbwxK6rrFIVVqnH2yVZMAmFRKWaSPPqt/KhQG/+OHjmPomD2/Hp4jrOXXkOGWeoNl07FpTgqzQb9YcQ1TE/htE4JcOqMcsai4+aEQYqbcV5urF4r6yuPbasS+FinOtLVzCIalQftIRAQsjRLhIUn5ZjTgDCBn/daLyg/vXrxC0rSMH5XWfzpw+O5LC23QxBymJVH0LIF1FTjbdPWCpzt0FMk4jb9OIS8BVhz4wlCnRjhKGnTqhFwybO6PJiPheakQq7YLYHQqiNBtqNW70k1fEV4Zh72Vz5Y3zpHKG4OMGJ1hrvTVgYtzCxSvyjcqgZUJzP+Htz1mc0axSo3A3ZRvp37tf4bAeli9cg7z7KGsWWX15tvAUNzGYG7OHjXQW3j6dROunkoTRvxVghojNjm3nvNiRYJ0TpGQxSzjeDgJAdYR7mNREjPIrWqKACkErvEm0Yi/7G++WXH1Gz9GIUujhWkbsReVFA8r6XiOII+YA4JY+Ab4BFssL0wv9s8p8YjWsaHJPKi8zRFuPS/30fNgssAd0fJPVTxo85Zwz9klTQPGBlbskmkp2Pux9mxfMJsKMRywrSCjppRQPg1Z2z2tdVT8zi10Uq0B/wiFD2
 3byL2YEl
 mpfK0FY0y+K+ISwL0SeQJjEdo0b7JLwZmc8871roPa+pt0RccaqriUyOytQtXjaAPiMvjOKSR4ZJaeUgQNlk68xcOmtkQpccdmTOkHHqOfVg/R/XGMZlRmdPCmsaMlCZcWn+W+0O5T9kpvOAqPkRls2g1IbaYVDOrqfH8EPxkrv+Tk59+O8dJZhGJIhvsSHtjoH5MW+6YBC1PEvvguGZgWTHIdPi1FyvprnGIlB9txD6xo6o/Y4xsLrm+6YFAw0PJbRT7A81r85eXaN0t9bYlhds9TQIwwTuihHMH7oclBosa3KL7YG6JCNREIXv/CA35lBK0IcgrkJyZ/UTGvBUNd84nngVpiYtu0jh0blEMOuxAEIlw1/AWmwVMhfSw22GDIPNKMXda4FxtYbWnnCyscUGqxgOC3Nz3fL0f3aQVHk8/PZM6dx56sFO6Op9Nw60urxkCAFkicJ/jYfenHi8uTRrc36OgC6D/fA7GSvIrMJxypIzFAwPswtQfCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

(This reproducer was hacked up and not meant to be merged.)

hugetlb_unreserve_pages() unconditionally returns reservations to the subpool
(via hugepage_subpool_put_pages()). This means that regardless of whether a
subpool reservation was actually used, the reservation is processed by the
subpool structure.

To create a false restoration, the reproducer performs these steps:

1.  Mount with min_size=2M (1 page). Global resv_hugepages becomes 1.
2.  The program maps 4MB (2 pages) shared (which also grows the file to
    4MB). Global resv_hugepages becomes 2 (1 from the mount, 1 new global
    reservation).
3.  The program populates only the first page. Global resv_hugepages decrements
    to 1 (reservation consumed by allocation).
4.  The program exits (closing VMAs/fds). For shared mappings, reservations are
    associated with the file inode, so they remain active. Global resv_hugepages
    remains 1.
5.  The script truncates the file to 2MB (truncate -s 2M).
    +   This synchronously triggers hugetlb_unreserve_pages() to release the
        reservation of the truncated range (the unallocated 2nd page).
    +   It calls hugepage_subpool_put_pages(spool, 1).
    +   On Vanilla Kernel (Buggy):
        +   used_hpages is 0 (not tracked).
        +   used_hpages (0) < min_hpages (1) is TRUE.
        +   The subpool incorrectly restores the reservation (spool->rsv_hpages
            becomes 1), even though Page 0 is still allocated and satisfies the
            mount's minimum guarantee.
        +   hugepage_subpool_put_pages() returns 0, skipping
            hugetlb_acct_memory(h, -1).
        +   Result: Global resv_hugepages remains stuck at 1 (Leak).
    +   On Fixed Kernel:
        +   used_hpages is tracked and is initially 2.
        +   hugepage_subpool_put_pages(1) decrements used_hpages to 1.
        +   used_hpages (1) < min_hpages (1) is FALSE.
        +   The subpool does not restore the reservation.
        +   hugepage_subpool_put_pages() returns 1.
        +   hugetlb_acct_memory(h, -1) is called.
        +   Result: Global resv_hugepages decrements to 0 (No leak).

When the filesystem is unmounted, hugetlbfs_put_super drops the subpool
reference. Since the filesystem is being unmounted, the reference count drops to
0, triggering unlock_or_release_subpool.

Inside unlock_or_release_subpool, the kernel checks if the subpool is free using
subpool_is_free.
+ On the buggy kernel, subpool_is_free checks if spool->rsv_hpages is equal to
  spool->min_hpages. Because of the phantom reservation, spool->rsv_hpages was
  restored to 1. Since min_hpages is 1, the check (1 == 1) returns true.
+ Since the subpool is considered free, the kernel releases the initial
  mount-time reservation by calling hugetlb_acct_memory to decrement
  resv_huge_pages by spool->min_hpages (which is 1).
+ This decrement reduces resv_huge_pages from 1 (the leaked state) to 0.

As a result, the leaked reservation is cleaned up during unmount and does not
persist afterward.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 subpool_shared_leak.c  | 43 +++++++++++++++++++++++++
 subpool_shared_leak.sh | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+)

diff --git a/subpool_shared_leak.c b/subpool_shared_leak.c
new file mode 100644
index 0000000000000..80b972af1c5ce
--- /dev/null
+++ b/subpool_shared_leak.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#define HPAGE_SIZE (2 * 1024 * 1024)
+
+int main(int argc, char **argv)
+{
+	const char *file_path;
+	void *addr;
+	int fd;
+
+	if (argc < 2) {
+		fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
+		return 1;
+	}
+	file_path = argv[1];
+
+	fd = open(file_path, O_CREAT | O_RDWR, 0666);
+	if (fd < 0) {
+		perror("open");
+		return 1;
+	}
+
+	addr = mmap(NULL, 2 * HPAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		perror("mmap");
+		close(fd);
+		return 1;
+	}
+
+	/* Allocate 1st page only. 2nd page remains unallocated (but reserved). */
+	*(char *)addr = 1;
+
+	munmap(addr, 2 * HPAGE_SIZE);
+	close(fd);
+
+	return 0;
+}
diff --git a/subpool_shared_leak.sh b/subpool_shared_leak.sh
new file mode 100755
index 0000000000000..619036145c523
--- /dev/null
+++ b/subpool_shared_leak.sh
@@ -0,0 +1,87 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+if [ "$EUID" -ne 0 ]; then
+    echo "Please run as root"
+    exit 1
+fi
+
+MNT_PATH="/tmp/mnt_hugetlb_shared_leak"
+FILE_PATH="$MNT_PATH/test_file"
+
+# Save original values
+orig_nr=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages)
+
+cleanup() {
+    echo "Cleaning up..."
+    rm -f "$FILE_PATH"
+    umount "$MNT_PATH" 2>/dev/null
+    rmdir "$MNT_PATH" 2>/dev/null
+    echo "$orig_nr" > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+    echo "Cleanup done."
+}
+trap cleanup EXIT
+
+# 1. Set nr_hugepages to 2
+echo 2 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
+
+# 2. Mount hugetlbfs with min_size=2M (1 page)
+mkdir -p "$MNT_PATH"
+if ! mount -t hugetlbfs -o min_size=2M none "$MNT_PATH"; then
+    echo "Failed to mount hugetlbfs"
+    exit 1
+fi
+
+# Check resv_hugepages after mount (should be 1)
+initial_resv=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages)
+echo "Initial resv_hugepages (after mount): $initial_resv"
+if [ "$initial_resv" -ne 1 ]; then
+    echo "ERROR: Initial resv_hugepages is not 1!"
+    exit 1
+fi
+
+# Verify reproducer binary exists
+if [ ! -x ./subpool_shared_leak ]; then
+    echo "reproducer binary './subpool_shared_leak' not found or not executable."
+    echo "Please compile it first: gcc -static -o subpool_shared_leak subpool_shared_leak.c"
+    exit 1
+fi
+
+# 3. Run helper to map 4MB, allocate 2MB, and close.
+# This creates 2 reservations, consumes 1 (by allocating Page 0).
+# The unallocated Page 1 reservation remains active in the inode's resv_map.
+echo "Running helper..."
+./subpool_shared_leak "$FILE_PATH"
+
+resv_after_helper=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages)
+echo "resv_hugepages after helper (should be 1): $resv_after_helper"
+# Page 0 is allocated (no longer reserved). Page 1 is reserved.
+# So resv_hugepages should be 1.
+if [ "$resv_after_helper" -ne 1 ]; then
+    echo "ERROR: resv_hugepages is not 1 after helper run!"
+    exit 1
+fi
+
+# 4. Truncate file to 2MB (releases Page 1 reservation)
+echo "Truncating file to 2MB (releasing 1 page reservation)..."
+truncate -s 2M "$FILE_PATH"
+
+# Check resv_hugepages after truncate.
+# Since Page 0 is still allocated (and in page cache), and satisfies the
+# min_size=2M guarantee, we should have 0 reservations remaining.
+# If the bug is present, the truncate path will incorrectly restore the
+# reservation to the subpool and skip releasing it globally, leaving
+# resv_hugepages at 1.
+final_resv=$(cat /sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages)
+echo "Final resv_hugepages (after 2MB truncate): $final_resv"
+
+if [ "$final_resv" -eq 1 ]; then
+    echo "RESULT: LEAK DETECTED (FAIL)"
+    exit 1
+elif [ "$final_resv" -eq 0 ]; then
+    echo "RESULT: NO LEAK (PASS)"
+    exit 0
+else
+    echo "RESULT: UNEXPECTED STATE ($final_resv)"
+    exit 2
+fi

-- 
2.55.0.229.g6434b31f56-goog



