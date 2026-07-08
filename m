Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118A8C44501
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390B06B008C; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368186B0092; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E256B0095; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E69246B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:22:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DACE4033C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:23 +0000 (UTC)
X-FDA: 84967034166.14.6DD31B9
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9AE2640008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdua3rKN;
	spf=pass (imf01.hostedemail.com: domain of 3nM1OagsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3nM1OagsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783549341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjLxz+SrWa7Pn13CuDqaEisDU6zq2N+GJpXd2lET7Lg=;
	b=saiF9TLVBMZvmtyw3slp7wvGzEZ4C49cxXeh36S/isA9GiGNKkq7QZ42pClp+3OM80gd4X
	TjF4lM2XrSH8H3apcXaaOwtXb7hMMH6Dulje2IF+HuGuIKDvSHB4xZMbkl4s/dC/KWbSiu
	frCsJjrbKPq5T3KIQF887lI/GbUCDB4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783549341;
	b=WwTbmRlOq9eI5xsfNVgfjFQD0YXemWX2sdOVgKdnfgQ3AO98ar82V4a4N/LtkkxwG/lHIm
	fyoHxS+oE7bF9ACBmudauSDx78Sn+2XuBgwNon/Yy83mGPFI0KVgTkT6J2lAt4bqBFCKEv
	Gxcyrvo+0sZGnNxb2K5aa/V/Z1rVNtQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mdua3rKN;
	spf=pass (imf01.hostedemail.com: domain of 3nM1OagsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3nM1OagsKCMsrt1v82vFA4xx55x2v.t532z4BE-331Crt1.58x@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8478ff5d801so2217622b3a.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 15:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783549340; x=1784154140; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fjLxz+SrWa7Pn13CuDqaEisDU6zq2N+GJpXd2lET7Lg=;
        b=mdua3rKN5snzmrQgUOP+CJgYtbM7qLihqYBLZD82uFeOMHTHReKixBsrUCtMA15ADW
         iAG7mApEbKU3qHV/zrDEQTywxuNB+Z82k4oLREucmGFAYeRf1wWTmERJ+WEtUXtoN2bj
         iGZWUfZth7Thx07U14WCfPqEWi1vSXFy35ScWhpTwO3MBuLI7D5Pvdj5XxIk0vQaAPll
         gBBt39gGv6OJR/SommcO+cYELS4XoZxSXkZGhmFLBVk2+NBaX+Q+/n99wI0TJzRKylP/
         u6abuADqGyUBkJXvyZvr5kWHHloTHMW8soScz3qbaAJpp8hRvlL94qE8rMqQBW0a34LI
         TBtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783549340; x=1784154140;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fjLxz+SrWa7Pn13CuDqaEisDU6zq2N+GJpXd2lET7Lg=;
        b=GqRPADE9944gA8DjHGfWDOL585hG5Juk3GVXhgxmFAdOxtjDGH1mDW72SyzV/h/M7X
         gzyixAqnQ/AL46GSv8AtG7k5OixIElvD1Dq54CfMNc02RwdcvHlc/CsPpb9NlpKY3G0R
         qVeIlCMyyRPhwCkM9GE6yO6P2o6IlNe6ysAc05TElsIGaBibrdDd1EK3uBzKMFzWGsCw
         hUNFARid2ZtmzejjK5Xcp3PF6+DrS4tP12FsWcF0Y5k5GTcC4L3rljFItHVQan2N2BIh
         oq616an83nGGzqL/xmAgAATYPw2zNpFGrGPuBw4zFBwrJLVl4BqS6zoqmsJg2hOkp6gE
         kBJg==
X-Forwarded-Encrypted: i=1; AHgh+Rrn9jjuvocKSDJ1+4T51iOwB/18ZJ+RcmZOGcqx6OVnpxMi8Ih6u+IubWQY8NciopG62tqI875EqQ==@kvack.org
X-Gm-Message-State: AOJu0YzXky5IALbsm4V3ij1UCTVjjsQ+W5T0JbRfVnVunLpggYJbHHOg
	xgY0D9vFt/Ecn3kGgf3KXj44sJE7Qr5nxaXlRTSBG4tu2V706m8mEsU19PMw0j1rYRSi9ddQWiN
	JwQvY4LfE79f1NkXKI9tmqfhCag==
X-Received: from pfbim8.prod.google.com ([2002:a05:6a00:8d88:b0:847:93d8:2813])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:66ca:b0:848:587f:8acc with SMTP id d2e1a72fcca58-848587f902bmr474336b3a.54.1783549340213;
 Wed, 08 Jul 2026 15:22:20 -0700 (PDT)
Date: Wed,  8 Jul 2026 15:22:12 -0700
In-Reply-To: <cover.1783549129.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
 <cover.1783549129.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <0b8165bc4558d5bea490eb6fca08398db829438f.1783549129.git.ackerleytng@google.com>
Subject: [POC PATCH 2/3] Reproducer for subpool usage leak
From: Ackerley Tng <ackerleytng@google.com>
To: devnull+ackerleytng.google.com@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, david@kernel.org, 
	erdemaktas@google.com, fvdl@google.com, joshua.hahnjy@gmail.com, 
	jthoughton@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mawupeng1@huawei.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	shakeel.butt@linux.dev, stable@vger.kernel.org, vannapurve@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9AE2640008
X-Stat-Signature: mnnc3njanthhx7y8ezebo8igmo19rfgn
X-HE-Tag: 1783549341-458290
X-HE-Meta: U2FsdGVkX1+ExOLRSNXidpybcrP0PtmaYtI21vi/hq8422AttkXXVTyA0FcHxngggDaCdhiwAKigAiX2EnQ58g71RZLt6MS/ghrhcKfqoaogMU0OXxH4+nkZg4JiLiraKZY83jlows4HS3S7l79TW/CXvq+pA9Vb9cTeJR10a/D5xiYxER0pUqu0T+ilG4Cbga98vmGeDt29o9FHabg8EWVDF0GY7YOqeVHj4KDxPjAvFeF1V9u7fjyhGva5texJyIO/aCLOWjxI+9L5slPUUJ3UscHamqnBtGRDv0jah9RvxXHHjZs8TnnOpr+RDkushroGcG5bjDi5CAw3TGnlREgrQBzXkY1xvBV+vhUpXLxvJ1KBc5UmsXi5i4IdEQ9Xfiz9Wl4mOBmjg+W2h1CYvs0lx//9imZZaRyJOWlslE4HPNTDB0eG5EgEOxBrhwiiz5x1X06lDWVCtyNaNJH1IwneornWM+v5D5xzXHKSYA+OTsgkG0M/BFr2e2JFRymog1KHDpTnptCDD7THYvxH+r/n9GRm1mz9xA9kRZmaMrx8x6fGVA8jveMRrf6IbaSNWj3cZk6LsYfDT5rVHlXLrAb4iLIA9CdpK4HrfgntwbPl55QAaF8ieQHIb9HLhmDTAANbejw7IKu7ZnVK/tMijNZb83fhFLvhEG+sbpPKhfHlsscYdLSxzH7A8CCmfgt3KPP6nYxArhUmNvsRHEMUKQV2Zq+GPqAoACAFITHGk1ExVn+LBQjq9klKcPc6qjWBdfNZetWI2TzXEnnmPjca0FCdDhg3IxX1EC9Jc4T6gxN5A8/HHD6rUg8uo1lpuD4oZbnjX7lHpH2l2GZ056Lxyo+qbvpEPWVZw67aMMmu2DTuVLpmCO6mf+dEL09bveBxsoUqzkhEPkJmFnnIiHCoSWoara+JxKA67q2MCLQp7VmyQXA54TrMxbCfMLAVGcHnspclmWxUdpArVlmWjG0
 LbLrWVSR
 LwiSMu3OisQZROdOux1l3yRLnrZtaGmQCc0h9w0BBzhE2ioUWWM1RMfoJQc1h2GduaFWPDsK7v2tRSGIE4OnNp9DNfuF1GUl/R7e75LyOxKgLxt4pPXKgEqoT41GGun3gCKgsga3Emjr9MrvRcTuN9MMvSVHP+3zAkZumDizBsntalEbtmvh1PGzgCPySw9vP7INii5WU7BhSgabpbt/mQgnrB8QsWoVOGAfLN/KBY4DpXllMC8kXdEJjKIOnJLS0qay6J9o/CEOTXMD0/Pqkkr3uMaJWsXxC0w2c9x6lVXYZSpQT854PEcDBuUzas/fakvBMh/LXABmcsttq6iXt7d6EaNGFApeiNQcVVcle2vurO5FDjJcpCyePYmP9FNUrzeCH8enRMxHROvHsswbhU5EvLJ6p1jDEMbQhgBU5YI5dNdLOv9Q/r8GiA5SXqAVMp8nFW+pjQ84Es9KvrJ5cLlrmDa9jqPEhRt3PIQRPYquh5kiWBm9IlWePxxkIRPwIS+EJj/u6Yb9DYNstKhefecsILSYGMaaoZfVbr12Z/gCW4AY/a2CdxwaInyz570KTX8kSp3PCxjPZE0oDDvfZHoORfp/1NrcQhwVZnQwzm1deeo/v/PoUtte7fyH/2f6d84plIY5e3yEsUhMHjMdp6/1UwsmitdIypXBTHW91jzt0xhJmbpZ0tHtiWaUmYKP1hPzAdrFYS9/DByR1bNIkfynM9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 subpool_leak_max_size.sh | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)
 create mode 100755 subpool_leak_max_size.sh

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
2.55.0.795.g602f6c329a-goog


