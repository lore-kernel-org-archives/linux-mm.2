Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89548C4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5546B0096; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B186B009B; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FBDE6B0098; Mon, 20 Jul 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D99946B0099
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:53:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C2C8A03BB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:12 +0000 (UTC)
X-FDA: 85011262224.21.AA50BA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4069640002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZOhggKih;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784602390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atPykDcptr9Vp0vkIQEAqfvEmmMmlzjJYJC/GYPFV5w=;
	b=Vbb76vjdsmBSr/cMfSwCZIT+SeaEYlCQrQ0E9dobQXna8j30LSF0mD7H4WU2ZrezPZofDb
	T+Ic/9gAqzx5ng9F2oQVwxBWojXaxh3iS57dtCDEXhaqPUmKtlfw8dg0eoLW5NOHoPek25
	jpOxjhRrFnDeWihHoF+oOfN9RjSIDW8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZOhggKih;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784602390;
	b=mjnjabfy5BU/vlNoDBAMP0AMn3cbEYRJ6UqW/WvXCFBQDn9YK6aKFAduT75uRDGRjskMbs
	i0SL3TzYrJrI1sRfjx02h56g3pVncuIphKQIjBgH+wocOOe63B990Hc2Tj5GxfWgRnFJWw
	0EccA55p+D90AxkScNn6Q5v7Wgqd79U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6D5860A93;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 881F8C2BCF7;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784602389;
	bh=kttlEIrRapL9va7fSljR3xrwSzOf2bb6snXuzZxqZ30=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZOhggKih7xOk/MyAuJWaa130N+z1Q9x1F+XEfuajwBORDjzg1QKcUta3uHiqj+QLu
	 vXPnHaoq/uE8J/O1kfEKI1trcY97vfO1cjJWnRJ5bVIInHaZKKPS7o/onuZMvZHEl9
	 LAwiKs1u5gGTP7z4Ryki0KHNtoZjge6VdqF30jE+gdXuNxEbmj1DVXW5r0C0RYOudc
	 PD9DBKg7uiMcqKXwVe7X6R2Ql3/vjd9aXtc55UfZJYuLdnIEiRN7YRFPzHzeWx+1SX
	 tNqIrk8XWy6dodqh62rbSfIA/XoCoKUGkTpjdK2cYvI0HZilpYvioLpoO72CBstkUT
	 wYy9P+MUM4i7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74A0BC44524;
	Tue, 21 Jul 2026 02:53:09 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 20 Jul 2026 17:25:14 -0700
Subject: [PATCH v3 11/13] WIP: Reproducer for subpool usage leak
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hugetlb-alloc-failure-fixes-v3-11-7d2a169aa9ee@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784602387; l=4607;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=inX7G11YaaxbwEU3Aj5PB0crlLMuo9T1V2I+32/3MYg=;
 b=2snhi0Fk67JboBtC3TcQ7c/BnoASl8jauKmvWjHDI4B5pTaAhEL4c/GXuRyTy283zI1c7EcHa
 Em1FnEeYordAxOBRStKhF9bHrxmCLw+F4rYPMhqRBYEn6LJ0/c0I9V8
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4069640002
X-Stat-Signature: 8m47xtii1q9j1dxa977mqs88am63z6su
X-HE-Tag: 1784602390-466182
X-HE-Meta: U2FsdGVkX1+pG/MjIpez0DoXwLWe2OwcBc94Y94WC2aCBi/imuwLAB7/wbZ0/8D2C46QvakuOMVtdLecAAyXNOxorsHUijHhtS8SbygL/GFWLKxTGFdh1IUrsLw0sVz+rx45QmsmJ1vLZzWkLcBDj2QJG70aSSt+C/3ANqSn76M2bIggmuDb++L5Ws6/WbmVG5PzToAmhxaIft/CnRP/KBfpVI5SeMrCqk8Bu04qadzZafK8OkeVK9q8ZF5vrPA2s3UZVASSErBub3viBt127TnTuCGVwDoueq58nBeqigAqKgt01bUr9RYve4hDIRGWuOtuG5uwQmjbrqeK48Uxh7oxHYQ30rpkcVGBBNS7qkM/oBUZYfXeMyxe/ybEArzhQzmomVDP07S5wRhvAsnQu5eKS7vjfysDxnLSPi8q0gB3qi+fHCTEUUZvga3Y4W3H64lZbm6maTmhHEGmsjkTAqkQuLugPrbzYuCIGBZ2i0KjZdyxOPsPMXvMsLTsSwCT6GPEYD8UJaPXKNsKyXFJ/qOemyNyWFY5RkAyLXxqBGkH/fIFTzp9rNWznOpmMapKONnTQ8N5Wqk2LutLxvZM79CDw7Q32JrXkn1v4xtFCkx+Dcs9h9u88ebg10ZP0Q0oXqiqxdo6db351Dre/Hym6x+VvmLzOZZs/7g190/ZIVe82hkLk+oEEc45FMqZJU29hMPisUjej8ZcVTGsAt6uzlhmoBTUvNxpc2gTigTqSfEtruf1u7ts2VPPAtME4CBNvI7ipbcBvNNMZIX9BakV/rdi7+USjP2H/Lj1YsWXl7TqTaxs1qPDw305tp8nTn8w/RZTXEoAWRPd5AbxV0RT/2Jivinkgn/Q3ONSM9S4tbuFxhvd6tL3uA7WmqOxMBbBwrH30T4Z36+RXxZ6dhc4RwdvNm5QUj04rgKrsL6jzhrAcXhew8CmXlbB+7obdv/bYe9YCVe4mmws4T9fjJc
 ekyDhRrp
 PQEVWWcGEOkUYtyfGAnfTVYQMiWbnKhokQB1VKVzl3ENnCcNFvgV6UhPposlPVM4o2A61GJYuOIskOKhF4TOqBNaovqSKz0S1lQjZI+gO7oqV9EhTCds14/VGJFH/88pVIMK83WGkzdC8z5DKrcku475omALrz78oxSxLTTYLlpvTNZNdWpbBAWOAoYIalNhyHLBscByrMdv+G1vDp1VfOMdHCyXXP3AsyZeuVpex9xEFsKtxSynizUpAyWb14Y7IVlI/T4dgigv495iQElFAT3YiWpgrhauSvobG+e4FY5B787e5aKwvlhlbyXkaKWJ4+wGI0XURsPoNd2VhU5ptQFQOHwC5BYEHpdMOfL0Z/6zGHA8TMhUOfOUKXgoG9HOBKWoCdqK7goe1tbrXd6Hsy6yeOL+9rRVX7dMweKsP69aD4IoYHnEoSU6UIIJFmhXVGNQ22taBBNL98G2ZelSYwEQmIVQ9xpTA8GO17yJ54d/Kr3g=
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
 subpool_leak_max_size.sh | 71 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/subpool_leak_max_size.sh b/subpool_leak_max_size.sh
new file mode 100755
index 0000000000000..bfafa1ba074ea
--- /dev/null
+++ b/subpool_leak_max_size.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
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



