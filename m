Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 137FBC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1288C6B009F; Mon, 20 Jul 2026 22:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063546B00A3; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0EE96B00A2; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D93C6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB49D1C0537
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:14 +0000 (UTC)
X-FDA: 85011262308.05.9F47358
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA77B14000A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpCXHLn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602392;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbf5eLS2e39OJDUCMHKxmz5aD7igM84bb8Ql7ZbyUko=;
	b=5hpkz791X3DYD5jrYF6NXbq7OtXcyAbM1pu1KNyYkqy8h8YDJLgDZXViXq4qDmE1Bt1wM/
	EMJqkTeyxw3kYPeQBeYIZ5C3gB71C2gxX/X0PMQzMLLGxTpjWY53rkeUTcminXwDVQqTtE
	iagPp6E3U6Huf72YnqpikvmvqDK/6zM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OpCXHLn0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602392;
	b=PCRiw0gh3iEzR/rAJW8fobMEy1cEKguPNAufeZgm0ZxNeM6gqyg5jxdiKq1UaGK9d6pTmV
	1+wlG7UElYqks0eIB4GIRhWwLC1xUSspkO1vsde3MGa8POk7PljhLsaHJ0Cg+JS58RHXH+
	79wdDShi03MN5MEuOmdWk/4rGk2JT74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4A154502C;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A882CC2BCFF;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=JpV22Go91sm1l5ZmXhWEkSXKUuaRnYmpd8p8KT1aw60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OpCXHLn0A3bJ+aa4MSCA7kUV7uxqiXXIHvcVUPlhOaV6rW/hWTJmuZBsf+xrNpnNu
	 CiQAOCxPsCbbbBEJd54KRvYlI82kTX3/oZD5SyI520eoBfneSQTM5mN4NcNz5USZmp
	 NkwxBsEvZ0D0aWlbRrJAshs+wikoaIIhHYL8noEKlxlMjD1B+qtXAWitnr5YFbaI2g
	 S/PaJKCoiQcPaQeJiREfIzTmpuB7udzRgNo5QAK1Yq9sxcoF4uwBrEWnyQiqWvrjgv
	 6nL2NjUI6QVS3PRr5SGYteQRaCi74yLa8C1srWFbpu718vcNmPwf8bR8sQ9G+2NCz/
	 3+JfTzZLQVWMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A4CC44532;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:16 -0700
Subject: [PATCH v3 13/13] WIP: Reproducer for out_put_pages subpool reserve
 leakage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-13-7d2a169aa9ee@google.com>
References: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
In-Reply-To: <20260720-hugetlb-alloc-failure-fixes-v3-0-7d2a169aa9ee@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=9148;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=C8+RXWPxhEZ0iEc4milJz3Gk4NI1eHcFg/eirCB7vkk=;
 b=q6N14FCm455WC6E/wtqOt21WQ9EGTtEaTl7luRiBu/0vYOPvnC8ObL8G6bHnPziiAVISRL15X
 x6XxCY8nTsCCLmEJMu1UapNUs92xUAIHuzRe/7jowOLIze6pP5/0MsE
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CA77B14000A
X-Rspam-User: 
X-Stat-Signature: zhmzygq6brbt47wepj1y8x8bq9bcpqq3
X-HE-Tag: 1784602392-180471
X-HE-Meta: U2FsdGVkX19lmWZBfTUCCPZAMFWWaGSiCVdBb6hql1yXNd/oycQYoESM+Am+adhzmqqUbCFOejtWbTXSJtB6KXcfr4daAoEoUmDPBcZugXxHsWbfMZnB1LNxY8JRvuniabM+1XWVbpRP7UNeSw/hxw6ymuUdYbqqatRmBUE08QXcDNu+Zo+OFp6AqRT9swJ/VSO5JpPZoS38OLpg9zFg5XcvBKlpo9dO/q0o9oqoegzdg7iyQjL7uhrbC3g/NsvzxFLgl6MUqrInNEpV9jBWqnOn6WYFwbfKAzz5lm6DTY+eHU0rNvO56i7WzpHKcL+VMksT9L0SgF226NhL1Pt+3hHz1KhEE3DoALBuZ/Zir8eGWxF97jGaKAZv8zqfafkXESZPrOrILKcDly6/wAwhA1XH3wEK/36LGqfg0JrBDmVOkrTtTOtK9mt7yMR42MQSeIs7cESsKN6ntNdNz/zq1mTyHosOIfzlc0CcBON8+E0j/K5iiedCR0qoZEMcufU/2kGp47EIdFIZRaAAONx4aqr0krvb8NFgyNxCTLIvEvmVpStNZD7u2mi8kjrGY03ptSw729i4DnTaIVKIpF/brCXPtT3K4RI1JJeI0ATMGHLnblKrZ55uinHoxc3l0bKBgyO7fqSjzF+kBHt6/x6AiKa+hFJjvjDSVhVcynOmfidpvQEsVINpVBizRda/Ci12+iNqOBmFHj4tZyyi1jZvRNiiQyiGDReEnn9TIODZlMKrAEw8xqnWecXvBTqJQFQrD3xu5zLS7lppso4xWvD8/0DDybV/cS+WNgG27GQVDCTjos3osZoNf/cxAxBdS3QVXfvd1bU+E1ShZYoehvkJAYp7qAyWBdn5GwiJYLNpDVRMRc69xm3abCjiAZJs1VijJLwzpSoWI/8Md3AUW5v1UJuBV2O4NE177E2Scp8FAvfzcuCrkAM4tmiZWDNsMpNvzfGUJJZlL7P+i4RhB5E
 eq9w9NIi
 t0/VXx8SIOGI82J14XLmi1VLhwUJz+8MqdxFHmVuxjYajgGWbWGNFIMBOBe1Y4yAppKuiPNIpPg/qAGINMkVrf2CJw7e9S885XLDX//nd2ez43un509JsfG08ZLgGMts5GCTwav2IFLA/Zqa4z7VLKYagzBBDT4rpNtxsPRmXzVsiuyneZoI1o6GgFJ+hzMS8NYAe5ImCUGcLIyHaGv9aOpx3kJ3TI2N00wBQfQ1wnVj7DQi+IjLy0G5F1rAdXh5dOg7Sl0/XGt4+9AgLiVhwP3MizcS4XN3rmZ7AUKZl2T8Og5rJ18GzckzhKcXAwasurpjt1jOp6EAiMR2LqqStl6UldNtAiC9XxQmPR4OifB1e4SfrRf8HQqghf7aEvtHw15U1RkY2KEopRrCPRSwSkPCafozaQigqkDhMgYccPBgb4J+c+zCt/uMLEamKUJTK3QpuI0hlc98HLpZObkl1B9lyFtXmTYUVmd9btfOP6r8ZLZQKyXLylcYwSWhRMjrTdeulNxAqL69W1YbmwwqBR5ojLhOS0DAxvta1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a highly precise C reproducer and accompanying bash execution script
to exercise, validate, and stress-test the `out_put_pages` error path
rollback semantics in `hugetlb_reserve_pages()`.

How it works:
1. The bash script sets the system-wide HugeTLB pool to a highly constrained
   baseline of exactly `nr_hugepages = 1` and `nr_overcommit_hugepages = 0`.
2. It mounts a `hugetlbfs` instance with `-o pagesize=2M,min_size=2M,size=4M`,
   which causes the kernel to immediately consume the 1 available global page
   as the subpool's mount-time minimum size reserve (`rsv_hugepages` becomes 1).
3. The C reproducer then attempts a shared `mmap()` for `4M` (2 pages).
   - `hugepage_subpool_get_pages()` requests 2 pages, sees 1 reserved, and
     requests 1 additional global page.
   - `hugetlb_acct_memory()` attempts to secure that global page but immediately
     fails with `-ENOMEM` because the pool is exhausted.
   - The kernel jumps to the `out_put_pages` error path, calling
     `hugepage_subpool_put_pages()` to symmetrically roll back the reservation.
4. The script verifies that the subpool successfully retains its 1reserved page
   during the failure and returns it cleanly to the global pool upon unmount,
   proving that no underflow, double-free, or reserve leakage occurs in the
   `out_put_pages` boundary path.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 hugetlb_reserve_pages_out_put_pages.c  |  49 +++++++++++
 hugetlb_reserve_pages_out_put_pages.sh | 153 +++++++++++++++++++++++++++++++++
 2 files changed, 202 insertions(+)

diff --git a/hugetlb_reserve_pages_out_put_pages.c b/hugetlb_reserve_pages_out_put_pages.c
new file mode 100644
index 0000000000000..9e63fc8997d57
--- /dev/null
+++ b/hugetlb_reserve_pages_out_put_pages.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <fcntl.h>
+#include <err.h>
+#include <errno.h>
+
+int main(int argc, char **argv)
+{
+	const char *file_path;
+	size_t size;
+	int fd;
+	void *addr;
+
+	if (argc < 3) {
+		fprintf(stderr, "Usage: %s <hugetlbfs_file> <size_in_bytes>\n",
+			argv[0]);
+		return 1;
+	}
+
+	file_path = argv[1];
+	size = strtoull(argv[2], NULL, 0);
+
+	fd = open(file_path, O_CREAT | O_RDWR, 0666);
+	if (fd < 0)
+		err(1, "open");
+
+	printf("Attempting to mmap %zu bytes shared on %s...\n", size,
+	       file_path);
+	addr = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	if (addr == MAP_FAILED) {
+		if (errno == ENOMEM) {
+			printf("mmap failed with ENOMEM as expected.\n");
+			close(fd);
+			return 0;
+		}
+		perror("mmap failed with unexpected error");
+		close(fd);
+		return 1;
+	}
+
+	printf("ERROR: mmap SUCCEEDED unexpectedly at %p\n", addr);
+	munmap(addr, size);
+	close(fd);
+	return 1;
+}
diff --git a/hugetlb_reserve_pages_out_put_pages.sh b/hugetlb_reserve_pages_out_put_pages.sh
new file mode 100755
index 0000000000000..030e1915539b4
--- /dev/null
+++ b/hugetlb_reserve_pages_out_put_pages.sh
@@ -0,0 +1,153 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+set -e
+
+if [ "$EUID" -ne 0 ]; then
+    echo "Please run as root"
+    exit 1
+fi
+
+SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
+cd "$SCRIPT_DIR"
+
+# Detect default hugepage size to support both 2MB and 1GB pages robustly
+hpz=$(grep -i hugepagesize /proc/meminfo | awk '{print $2}')
+kb=$hpz
+mb=$((kb / 1024))
+hpage_size_bytes=$((kb * 1024))
+
+hpage_dir="hugepages-${kb}kB"
+SYSFS_PATH="/sys/kernel/mm/hugepages/$hpage_dir"
+
+MNT_PATH="/tmp/mnt_hugetlb_repro"
+FILE_PATH="$MNT_PATH/test_file"
+
+# Save original values for safe restoration
+orig_nr=$(cat "$SYSFS_PATH/nr_hugepages")
+orig_overcommit=$(cat "$SYSFS_PATH/nr_overcommit_hugepages")
+
+cleanup() {
+    echo "Cleaning up..."
+    rm -f "$FILE_PATH"
+    umount "$MNT_PATH" 2>/dev/null
+    rmdir "$MNT_PATH" 2>/dev/null
+    echo "$orig_nr" > "$SYSFS_PATH/nr_hugepages"
+    echo "$orig_overcommit" > "$SYSFS_PATH/nr_overcommit_hugepages"
+    echo "Cleanup done."
+}
+trap cleanup EXIT
+
+# Verify reproducer binary exists
+if [ ! -x ./hugetlb_reserve_pages_out_put_pages ]; then
+    echo "reproducer binary './hugetlb_reserve_pages_out_put_pages' not found or not executable."
+    echo "Please compile it first: gcc -static -o hugetlb_reserve_pages_out_put_pages hugetlb_reserve_pages_out_put_pages.c"
+    exit 1
+fi
+
+# 1. Set global pool such that only the mount-time reservation can succeed
+echo 1 > "$SYSFS_PATH/nr_hugepages"
+echo 0 > "$SYSFS_PATH/nr_overcommit_hugepages"
+
+initial_resv=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "Initial resv_hugepages (before mount): $initial_resv"
+
+# 2. Mount with min_size = 1 page, max size = 2 pages
+min_size_str="${mb}M"
+max_size_str="$((mb * 2))M"
+mmap_size_bytes=$((hpage_size_bytes * 2))
+
+mkdir -p "$MNT_PATH"
+echo "Mounting hugetlbfs with pagesize=${mb}M, min_size=$min_size_str, size=$max_size_str..."
+if ! mount -t hugetlbfs -o "pagesize=${mb}M,min_size=$min_size_str,size=$max_size_str" none "$MNT_PATH"; then
+    echo "Failed to mount hugetlbfs"
+    exit 1
+fi
+
+resv_after_mount=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "resv_hugepages after mount: $resv_after_mount"
+expected_after_mount=$((initial_resv + 1))
+if [ "$resv_after_mount" != "$expected_after_mount" ]; then
+    echo "ERROR: resv_hugepages is not $expected_after_mount after mount (actual: $resv_after_mount)!"
+    exit 1
+fi
+
+# Check mount stats after mount
+expected_bsize=$hpage_size_bytes
+bsize_S=$(stat -f -c "%S" "$MNT_PATH")
+bsize_s=$(stat -f -c "%s" "$MNT_PATH")
+echo "Mount block size after mount: $bsize_S / $bsize_s (expected: $expected_bsize)"
+if [ "$bsize_S" != "$expected_bsize" ] && [ "$bsize_s" != "$expected_bsize" ]; then
+    echo "ERROR: Unexpected mount block size after mount (actual S:$bsize_S s:$bsize_s, expected: $expected_bsize)"
+    exit 1
+fi
+
+actual_stats_mount=$(stat -f -c "%b %f %a" "$MNT_PATH")
+expected_stats_mount="2 2 2"
+echo "Mount stats after mount (total free avail): $actual_stats_mount (expected: $expected_stats_mount)"
+if [ "$actual_stats_mount" != "$expected_stats_mount" ]; then
+    echo "ERROR: Unexpected mount stats after mount: $actual_stats_mount (expected: $expected_stats_mount)"
+    exit 1
+fi
+
+# 3. Run the reproducer to trigger the out_put_pages failure path
+echo "Running reproducer (expecting mmap failure with ENOMEM)..."
+if ./hugetlb_reserve_pages_out_put_pages "$FILE_PATH" "$mmap_size_bytes"; then
+    echo "Reproducer finished successfully."
+    resv_after_mmap=$(cat "$SYSFS_PATH/resv_hugepages")
+    echo "resv_hugepages after failed mmap: $resv_after_mmap"
+    expected_after_mmap=$expected_after_mount
+    if [ "$resv_after_mmap" = "$expected_after_mmap" ]; then
+        echo "RESULT: out_put_pages EXERCISED (resv_hugepages preserved at $expected_after_mmap as expected)"
+
+        # Check mount stats
+        expected_bsize=$hpage_size_bytes
+        bsize_S=$(stat -f -c "%S" "$MNT_PATH")
+        bsize_s=$(stat -f -c "%s" "$MNT_PATH")
+        echo "Mount block size: $bsize_S / $bsize_s (expected: $expected_bsize)"
+        if [ "$bsize_S" != "$expected_bsize" ] && [ "$bsize_s" != "$expected_bsize" ]; then
+            echo "ERROR: Unexpected mount block size (actual S:$bsize_S s:$bsize_s, expected: $expected_bsize)"
+            exit 1
+        fi
+
+        actual_stats=$(stat -f -c "%b %f %a" "$MNT_PATH")
+        expected_stats="2 2 2"
+        echo "Mount stats (total free avail): $actual_stats (expected: $expected_stats)"
+        if [ "$actual_stats" != "$expected_stats" ]; then
+            echo "RESULT: Unexpected mount stats after failed mmap (FAIL)"
+            exit 1
+        else
+            echo "RESULT: Mount stats restored to $expected_stats as expected (PASS)"
+        fi
+    else
+        echo "RESULT: Unexpected resv_hugepages value: $resv_after_mmap (expected: $expected_after_mmap)"
+        exit 1
+    fi
+else
+    echo "FAIL: Reproducer returned non-zero (mmap didn't fail with ENOMEM)"
+    exit 1
+fi
+
+# 4. Disable trap and do manual cleanup to check for final unmount underflow
+trap - EXIT
+
+echo "Unmounting..."
+umount "$MNT_PATH"
+rmdir "$MNT_PATH"
+
+final_resv=$(cat "$SYSFS_PATH/resv_hugepages")
+echo "Final resv_hugepages (after unmount): $final_resv"
+
+# Restore original values
+echo "Restoring original hugepage settings..."
+echo "$orig_nr" > "$SYSFS_PATH/nr_hugepages"
+echo "$orig_overcommit" > "$SYSFS_PATH/nr_overcommit_hugepages"
+
+if [ "$final_resv" = "$initial_resv" ]; then
+    echo "RESULT: State restored to $initial_resv (or cleaned up if fixed)"
+    echo "ALL DONE."
+    exit 0
+else
+    echo "RESULT: Underflow/Leak/Incorrect state detected! (final_resv = $final_resv, expected = $initial_resv)"
+    echo "ALL DONE."
+    exit 1
+fi

-- 
2.55.0.229.g6434b31f56-goog



