Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11F81C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56AAA6B00B0; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A57E6B00AF; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CFE96B00B2; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC33B6B00AF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85E2A140330
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:27 +0000 (UTC)
X-FDA: 85018036614.23.DF7C56C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95B75180003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P5pONj5x;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763685;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wbf5eLS2e39OJDUCMHKxmz5aD7igM84bb8Ql7ZbyUko=;
	b=Hw9e8MWLOiGDaPmXLy9bcWVLNsr6diCY8wEv/QYVFAkqY6/PaKVVYAOBRGqbg32buI1WTW
	eC8sD2gVsV/xdbqrC5kz7wu1RHx4Ls4G6AmYvBYLjKhd6Q53WIZsecxX8mjejMQKQjtHBw
	zub/lJkxQmxUWpLyoxldpW5d5lstN/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763685;
	b=Pd6/42Sk5R3fnrWLlahCyTEGP1kHsgZ9UcR2XH/34VW8OlXNhP0W1FxyGWm7/TbuyZ+q8/
	IU2D9jjBbAeIlB2l0h7Hb3Qypg3dTHPwtba/FTK0TQ3fUHSPajpSNdrLukqmo6fzg1epNf
	QQrqHaXsGNWSbQ3jLSc1g1o1GecLfiE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P5pONj5x;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F66545178;
	Wed, 22 Jul 2026 23:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E3B5CC2BCF6;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=JpV22Go91sm1l5ZmXhWEkSXKUuaRnYmpd8p8KT1aw60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=P5pONj5xGeyu106b1q17XIEyoT1RAq/C73XmAEdk4j8QmpiPk+M6PqsgRsJJLs82B
	 N7lEBWCUKHJ93Kr5JJRGJqPCg7R8z0abyWjyHqGfj6RXRa/5nOmY4Mn0S61+xdwSxJ
	 CYB3nrqzjZKDxEyucLbdkSB1JYysJjctP/QxdkYVMAhJ62UQZ9MFydyvb1dXbixLhJ
	 i6Gm28HnED6PXjKrrQRYh2rbxiESMgJAkc0GGlqBPRcPG87HExLeJJj4JqUIx3l5Yb
	 QKGf0DnCpUFx3KYFxxAj+PPoZIA4RR9MAG7av6mQ+kkp8BHHl5aand/40mdHeFSljE
	 n1q0Fd0Jy44vQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0752C44532;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:24 -0700
Subject: [PATCH v4 16/16] WIP: Reproducer for out_put_pages subpool reserve
 leakage
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-16-88e8b81970dc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=9148;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=C8+RXWPxhEZ0iEc4milJz3Gk4NI1eHcFg/eirCB7vkk=;
 b=FRykE6OsJj6rPG7Phjv7msN60z3TEeSAhyZioTGAlFZtw0k8YLFxH2S4I/+sdh6xff0dBk5Tf
 ghANT0I23YjCosFVyKBGVj4L7p83snFB5riN4HkN1XQMb0K95tBSTR9
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 95B75180003
X-Stat-Signature: 1i375jkew6e3f39npigo141rgo6grcht
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784763685-378210
X-HE-Meta: U2FsdGVkX1/91RBdmntw9cl1EvIflRUK3AWIM5+TMOfSOe47fhEpJugVVqpP9Br3/Shsi3wcqkluZf5P20U25fEQIRGvTN731P3wCSSFZb5gDjMdeJ+PkeOZVuWnNY9yBXVl61+FBEU1fzftmDpXlVrRAUPfIv7hdQUpyNdmqo4VoxENoch/OwO8rHCnO7NO2oMmqGr26xoNdpinUzCPb8NyAuJL3IL701E5Ps/qj2owkayFqm2IwEKu5rZ/3f/FROESqK0oRgSYnzYm/90KeF/hUGSZOG25NKClOwSsRGzj2coA3OUujcJ7HdMZpskYyIz5NvGJX0USgOQgzjGE8GoMXvYYKZso8/ZHnkyI5yHF8pMXn+fsBbc6jFFmgOJgzbPXM4iPA43s3xRT9Z6+LBo0CxfW6d6RRpOOApSN3SYQVtC5UWvap5ulwmKegNlpeTDWQitGNMUHQ1W7HUGAe1mkUtIq/uTcc+HeDu+tEJDoa3/RiXw8HEbi8xL/I/N9Ol6xY9gerIVosYcIrhgVCknAFNSdRrADJsrjmZXjIJzfaIbEea4x/hKlhEFamukD78TSZG0MHpq3NZ240xJ7hZGE44q4pAZLmLI0l/sgcz9is3cCTc6OG/NYzOI7b/LdkFhxLUZ1qtz7w72gIMpKpI9UNbINoM04a3dcUdZJhp+CsY6S83Uud/zBHtjqrDjjQGWkck3C7i2feS60H6HUYBt42dluP6bR6a/eXQ0xR3ozxs+MoMsGszy/2iHZ76cebZB2GdbrsEOF6ez8sC1mCNCoFQC9Yy1crNKrtGRnNnd8UKlE6oqlm7rbHaW0W3eN6zGn4VwO/102lVt5A9dPmq/2hbiQY1RqVxAHZafyjmDnVWnGbkMTgd9Mlmws72RbyguIYRKnRvSUipfVqPWjHtTVuq4lfdUZ8jzhG2Uqzz/Uc+PgOmWmQsAeSlkv9EyVlFUEW8Jmify0N2rWCfO
 5SRjAh9/
 bE5VzvxKb05eHgNondewTLJPXYu1wgE9EiuuOa+RtLZVzD8hhEzAjJRFl5dqVsHLrFIP2Rh1pxHVbEJlaW/G6H1OjvIhj9/WBEwyzPmXgl1LZdCIA60Yz7EDDpJZQhWtu2fvCFFrpBhvIG7ZxcL4FR+B7eGUSO0HIixiN37ikl3MMJsU4TfUSaO4AhvNLn+rcYnUQRc9oL+hKOZleMkNrNzL/oh6cEtk0ZMV4X/EGLy9MdbY3BOq0zxPNF7XrHBLZfhbud8o+uJCEivvSSau43L2035Ztu27Rq1u0GG7FNgrq0pG2+tRZyGT4zNBBojlFZaAaBAZetJ8krqWZLuXgY83Y6YBh9anwhdGl53OYz0AQx3eIjhmFE/TyfDIGb22RRTOr5UHc8tlEQskXcHojIT/lPZ8E1eBAFFq7Bn3S5GDeeUAz+6eGTR4Vssxp8sxkxEvIzzBM2IdLeKTpwn5VAJLFoFSY/3COZBdRuI9ZdcXFz3jthOaCZ0K81f/dufn1R0A83GyaZScAoJ/vwjTPYDKlEzG2Pe/nKhHE
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



