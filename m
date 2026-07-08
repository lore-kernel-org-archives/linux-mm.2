Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9134C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7806B0092; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 897496B0095; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD606B0096; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44D996B0095
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 837C114018B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:23 +0000 (UTC)
X-FDA: 84967034166.22.DE9F79A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id BE820100003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p8MuGrCP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3m81OagsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3m81OagsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783549340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMn5rOQ8G0MdN/j3eEgjALE6UNgIkquz76Y7IvgCOJ8=;
	b=BgSakINeXzNEdweixdxp/amIKrXe6zFZr8AQNUxAWgdxHNHU7DOM0JFG8BWwrVnZpBqwYP
	U2RJKaGVRB1PNZrjALnN4Pg3fgad2zl4riKnlvlKM86viZckeE6rOwpoXld7dglINNM5fU
	tRgkU577G1dP2Q9RNrGcn1ykd+yOI4A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p8MuGrCP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3m81OagsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3m81OagsKCMoqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783549340;
	b=aoQBb75kFNX4xmC1JBb4tDwg+vTRoS07r4DkJ7Ye2hsS0knMWsaIbk6n6zC0Ggt7OQvCMP
	PL5lkHz+G3ZcZCEaLGvQSpSEXMvUDCXRqyMQn0CM+LwdAsIgKJuoPJg+/uuzp18ZEMcYeV
	gXbq6ap0tgPqnrFlM1M65qIe+XTjBMY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ccb6823efcso11834745ad.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 15:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783549340; x=1784154140; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FMn5rOQ8G0MdN/j3eEgjALE6UNgIkquz76Y7IvgCOJ8=;
        b=p8MuGrCPrTjxNXt6+zxmOgO1Wn6oQNShR8IzduF2r/6RxrKOnmbWahkOULum23vrqK
         TA8nbj/0unB1NyVztN/W++Po1jV4M3DN1x1vZ+m6C8cF1nGbUH6rMzGWI8aQtEbqhE6k
         aHycWVH0unwgzowUziLSftDnfpPCWNt49F3/WhPOs90g7aj+gaTmJ8LLMp4j65Ut/43l
         5g+OO4zBFNx80jzwtpEAdW9HzeSMxPAaOcDz3Ct9DRQL6qOncx/RrUN81uHcCm72QLDV
         oqXZEvnIfLVAOGIABHVQ9JZxROYMPFPoaHJYU6M7b0symmMV0V0x6VId6QE/YIrmTWNg
         hLuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783549340; x=1784154140;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FMn5rOQ8G0MdN/j3eEgjALE6UNgIkquz76Y7IvgCOJ8=;
        b=YogpdPlUSG5Nlw0VSVNX9uWdgoQxKW5VivR9JFalnB8L9OdfZB8da9ys0dewsuNEHF
         NUzDGfZSv0tR7B3ulkgK+NJPL3d8AyJVr4vOIyngbu//iqsHG/HASNyMWKDc08w2+cDs
         Qy5EL1IDpJCQvhPATERlCdRirj+eVQcN0Kf4AqRPlucbR53OS5i2lQi94Rm+t82thgDl
         P5cCoVcrZ/g/bEmBQIEYGQqiR3fPMHX8dXGshPGuxJYhoBR0oxeTfO+zHEHe/j39EUMD
         OdMaFSc21rbKIX8hZrRNcgHcFoX4hlFK7cAALqjR1GgR+uNVYb8DGI31PGnMmMl4YHzl
         LNyg==
X-Forwarded-Encrypted: i=1; AHgh+RpFqFtoxRGUemZUMD1CW9SN15JrEVnjf1stbOsjEMPZRYQWxnnrfSEbTXkbGOZ4U2qOkGn+DXZ3RA==@kvack.org
X-Gm-Message-State: AOJu0Yyvjm5u4fmitgNccoAwVeB6rSkuFlRAlksX6ZrBS2VLQrhVjDzW
	XJiHC3GVWe6dXdOA4BHVFpkLPRa+RO/B8U9JV+CYFmdH/lzxT4S4DjrfWdeYYdQRUuRSucQJgNn
	j8BdFl2oFzJYWAn2ghyfJoAnGkw==
X-Received: from pldd21.prod.google.com ([2002:a17:902:c195:b0:2c8:4c1:883a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1670:b0:2ca:52ce:6f74 with SMTP id d9443c01a7336-2ccea464790mr52655045ad.29.1783549339459;
 Wed, 08 Jul 2026 15:22:19 -0700 (PDT)
Date: Wed,  8 Jul 2026 15:22:11 -0700
In-Reply-To: <cover.1783549129.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
 <cover.1783549129.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <1db8819133a88e03297aea7924878582c28e3dbc.1783549129.git.ackerleytng@google.com>
Subject: [POC PATCH 1/3] Reproducer for false restoration on shared HugeTLB mappings
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, david@kernel.org, 
	erdemaktas@google.com, fvdl@google.com, joshua.hahnjy@gmail.com, 
	jthoughton@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mawupeng1@huawei.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	shakeel.butt@linux.dev, stable@vger.kernel.org, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: BE820100003
X-Stat-Signature: 9fosmw18nhsbh6kxx4ejpy54ni4n8x1o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783549340-292368
X-HE-Meta: U2FsdGVkX1/ZhHKsWH8RuTwqjEID2HKlRSO3D+Sp9GmVhM/yDMaohN2fmDUXgKTQdcjzN9QTBZhxd/VBSHOIunxI+rCdu6QZtm1xrzTPKv1fgwfDbFrhXLHbOhDpRLCiQF4TCrfqV2+pl1taf+3ZKPSB7MVvORLYknjVRHZ2BwUhDpBKay4sF4KEYcrXdAqnYnGANDAajA/EPHcixUMdC4+XLFjc4+rHS91tcNWUMnujsLY1Gr3+QaYaZibkvN2ktzPHTzyJkp8PRBkDaWbrcuxFth3+rYUPUXDfaiMTcsv+YUlvUHTYaLCqGhSC6HIQT9EkhHIWKfQPiuj10ptivW2qigS5u8JGwPCWkj9aAejUCdz0BwsbfsWmW4X57T0y2Qo+04Nkj9TTGbuuCIWddRWQivcVlX4hzyO1pyJGtF9ZxyeJ1kypm4RXfGlMar1ej5aCMiXAAdL+c6OVPaqNPPVRJ1CDDdpIcwqkOjLgqRr1VkJwFVvCvSOO5RCkbNwb3zfAtfTElrw3Doa6C/fEBe9mK3JNkLyh2gHLSGM2/Xe3n9yzIW5c/7h/N0mKPwQWY5djWLRszXy7opelEufRwrBQfGwTm5ZVwgPgEPHUjesMcV3DiHM8cfq1C+xuHI+VT/PfnGo7wlJ6BxPXzq1hvXLBYBQyf6MGIQgrjSbDl3XJgvh3lPnsAR9TBNBqLibNeyBa+b1d5CBklvf4mUiCIomWEtod9nWBAO1j71qDufAxL/EIkSEuFTakhmivUOHLghDWSz0QYMi6p1QVhWiqJjgYK8QhRquQtOqRCKRxg0o7gKySrsqfQVjXI+vSRPivqn5JX7bffrqb+beIgL6jyWdXHAV6y9M8c+filOH8xKx6w0PbbPalUhy4T36IPBM2EVJ9Rte/qeg38sce9wA0Zt0Vjtj/H3MAHR0JiZCNa5nEdMyC9TwC0mTzgNnYPlSIK0c02o8Yq/BVpsHU3nz
 DVe4XXLZ
 BNIrT4sbY8bFIo4BSBgGiQj9yR6u3pBwOjsSwQOijIB1/EbPvM40UodIqIicSyox6ptRV5RFRKqP+rdIiEOJ3el+oJqLe97ICCC1HyX3aC83m+jyOK37tFCT3hYvXOEDcR9RE7mN6bOUU26FiTgmoOPaoOGOmdJzO+aS+Nyfc3p4WiCy7GcsamTbhSVRWfPdC3C5e/JU5TJq5M6SNQ81D1dk9xZUAA2H2hBP5DY43wG4XpPLAMDOh5fsOUWwbzLUqcfTOfe/j2qM+rJPPNbmGBcFMkWVN2Dg0J8j6H6/ti8JevOk53XYk3mducbbUvn/bzdwtJy+1XtfgIyKJ9CtUWIWT18A53L0wPip/AQAbhkE7nnxaQLIh+deauwiWw4ORZcTRgPjz1GrYgIPBfPMwHk6VPzC5OD3ruxP7Wdlc7I9On8s259Zn38kFJuloCIT2YqWLhvxuvfjSEPTN5wwOFhs2KQba86K8HxeVanBaf+bjj7JoiRHfkZPb6gVF+vg7VNITZD98WUypstBZuk3z1OxRO91Pz41VDrMQGK263parT4Ex1gim63R5YHD3ILVgrcKdHdbtamjK1Ev+owTDwaBIc/QkCO4CU/DApfSpd+/hZpc8wxnFOxpHDvLtALRzihqXsvjGUzYcg+7gd91kfdjDgb9TtGfJDSTPAykAPHSqTjExPmwQB2IWxNmpl6Kc5aq6Iat++dfk5x0bY/mROz5LNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 subpool_shared_leak.c  | 29 ++++++++++++++
 subpool_shared_leak.sh | 86 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 115 insertions(+)
 create mode 100644 subpool_shared_leak.c
 create mode 100755 subpool_shared_leak.sh

diff --git a/subpool_shared_leak.c b/subpool_shared_leak.c
new file mode 100644
index 0000000000000..5811e18d7f8be
--- /dev/null
+++ b/subpool_shared_leak.c
@@ -0,0 +1,29 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+#define HPAGE_SIZE (2 * 1024 * 1024)
+
+int main(int argc, char **argv) {
+    if (argc < 2) {
+        fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
+        return 1;
+    }
+    const char *file_path = argv[1];
+
+    int fd = open(file_path, O_CREAT | O_RDWR, 0666);
+    if (fd < 0) { perror("open"); return 1; }
+
+    void *addr = mmap(NULL, 2 * HPAGE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+    if (addr == MAP_FAILED) { perror("mmap"); close(fd); return 1; }
+
+    *(volatile char *)addr = 1; // Allocate 1st page only. 2nd page remains unallocated (but reserved).
+
+    munmap(addr, 2 * HPAGE_SIZE);
+    close(fd);
+
+    return 0;
+}
diff --git a/subpool_shared_leak.sh b/subpool_shared_leak.sh
new file mode 100755
index 0000000000000..46c622b18559a
--- /dev/null
+++ b/subpool_shared_leak.sh
@@ -0,0 +1,86 @@
+#!/bin/bash
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
2.55.0.795.g602f6c329a-goog


