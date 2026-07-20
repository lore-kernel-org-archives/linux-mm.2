Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F1FC44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365346B0093; Sun, 19 Jul 2026 23:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315456B0095; Sun, 19 Jul 2026 23:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204A36B0096; Sun, 19 Jul 2026 23:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC2376B0093
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:04:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66D9EA0719
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:04:04 +0000 (UTC)
X-FDA: 85007660808.30.26613A9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9866640008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:04:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rCWMHess;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784516642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zbv8c6XPjklVCkXRSa81M3HIzY/Ff3msBnn5ibeFm/4=;
	b=HT8+SgIAhUd5usPpyIcVW8TPA6UUUuZ4oaisX3gmkGhK3jzLU265+jM6uE0bDHaWE0Gx3w
	et5x9Aa8TFNQZG2YAS6L7NDunxU7hXMiriAYijGAQGyABeXjRChEyj1fhVbVkBBtwyhY/C
	IAmh8ut6M7GSYr2DA5cpyftPdUgiZoU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rCWMHess;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784516642;
	b=HQSKdH+xfWwmbz4iO76nDdUslVnrwMhqe21+rnSOdPc/2PRYuCG7NPLqhmFUk5uiCKkqAA
	EwLIzvVdBKvH2GZBAT/joIB8ejDOpcy9to9oFiJcRHxszvAYldaa8bHdfjegPDMNSR8pPl
	SMtz+DBCfqfpAd5eVuIAk4DG/gWCGhI=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cad4170e8eso129901565ad.3
        for <linux-mm@kvack.org>; Sun, 19 Jul 2026 20:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784516641; x=1785121441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Zbv8c6XPjklVCkXRSa81M3HIzY/Ff3msBnn5ibeFm/4=;
        b=rCWMHessEm4izRMEM9et6hLgLJ/QlQe96T/1CTJE00mnJhcSK1h5vAXlU6lakHCayx
         u5L3UIFr/c/FTkbgcQDcE16NbJySVk4WMkzXEZ3/QQFsbvl5CPaG5PjW88H6yhhzLhzG
         vdkIIad8gmKxAAmqgdm1A9VJghzrzY424vBGyMRJmN2cVGx9rpAmM078G4WDraRdbhUR
         GGxgaXHjntY0vYJDHbybc1xXOhcpp4G9xfS/sVgQAcR/TUe2NRd2NNe06gxgYrzqugMX
         i62hl6R/W/aRP8Ht5G41uaxXyYntHzpC6N0XifpESaOdlOh4cHSojSGBoTM21IkLbn8+
         KPSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784516641; x=1785121441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Zbv8c6XPjklVCkXRSa81M3HIzY/Ff3msBnn5ibeFm/4=;
        b=V/kDtjtB2IzOMLPpgAUHDs8K6Me7Qxt7JppgXekvYm7T8Eq/Bh+E++S9bDPxAlEVCJ
         SACRi/WV3E1QQMK9+8d4FuMM23oSf1VQjAgRl8teZ0rkaJ+sMOz0Bm2GwRGKk7rsOV0/
         jY0LKDs57G0Qj5WIG95VRAjYYk54zvVPyDxZ5iuglbDIf8G47yaO/3vojh2/f6JsnVk2
         5Zozh+eIMX060KlYykRjeyBjVUa+ovkaYY6vL4Pb6QRKX7gcZfeMcOa7aiZUteZ/cL++
         SKM6z5PseTw5XWp3DcsqHZkLm2vOxCf2qYrfU/tTmw0fsdebXRLGleoXoVc+72SlvgwW
         Z7Ow==
X-Forwarded-Encrypted: i=1; AHgh+RoOpSSDqN+aD81gcxTCyBJ86g9HdhyZfb/01EFCW4QOFnj7Rhg1x4w9DrSUh8S9EFPF7eXOctDf3A==@kvack.org
X-Gm-Message-State: AOJu0YyS+Xt3+xQ0QLJDgWSlhqUsqLS4srblux2rN/ab1SzrMug5+PHY
	KKRwGruRHTaR24S1JmL9GJAMzn9xP3SaSEjODbsJO0OP1Sze8151j+oV
X-Gm-Gg: AfdE7ck9novfFauvKuMQMVAEtXPZfL6scBOshJppoDqx/fJAgiWXviJhKHaR7jH3ukI
	zjE5PKpauNpqfBuRS33D/M9jr9aP8e2iC9SxqQ4Imw/lA/tNG4Bx8Qfoz6dAFQFFDrfXmQu8n2W
	JdpmhQtP1Fp84YXzd3wp9UO8bnShkLQ0bfk2GBU9UB2u1NXe7e/rultviT+w1zEd88b6a6p9qiY
	IKD25aYTdpTz+YgzWtrvi3l3eJaU7V9bYa3QbmdFahl758IMkc4nvWYKgYu646LUWlNP903b06i
	23CqVgwDo27fydmvcm5RxQpz+FdUcxyk8TDvCbVu8VZKi0ywHlyuTA9rqqUhHDBkvMBiK8UykfN
	XOVQizjeIhjZ9iOziY2/bzoXnuExoaptX/5cjuHQH+V0SGjG5d5vuCLBuw03o72X80q13trQQZj
	/E2SQsFcn6GjPtGnDwoH64/z4UdGY=
X-Received: by 2002:a17:902:d4cc:b0:2c9:e9db:8167 with SMTP id d9443c01a7336-2cf348193f5mr133308615ad.7.1784516641437;
        Sun, 19 Jul 2026 20:04:01 -0700 (PDT)
Received: from localhost.localdomain ([112.65.87.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf344d80e6sm47783065ad.29.2026.07.19.20.03.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Jul 2026 20:04:01 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	npache@redhat.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	daichaobing@sangfor.com.cn,
	wangkefeng.wang@huawei.com,
	gutierrez.asier@huawei-partners.com,
	zengheng4@huawei.com,
	kasong@tencent.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	lianux.mm@gmail.com,
	lianux.wang@processmission.com,
	kunwu.chan@linux.dev
Subject: [RFC PATCH v3 3/3] selftests/damon: add functional test for DAMOS_SPLIT
Date: Mon, 20 Jul 2026 11:03:27 +0800
Message-ID: <20260720030327.80153-4-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720030327.80153-1-lianux.mm@gmail.com>
References: <20260720030327.80153-1-lianux.mm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9866640008
X-Stat-Signature: iu97e83etm4fkg9tw1w8o48oniqzje15
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784516642-140120
X-HE-Meta: U2FsdGVkX1+Uy2qN/rY0JUD/xrlU0BSbskOp2lbmLhl8cISRDjwrbXJsCdYf352N5NR/HtR9/90HGoZVu8RvrK9hxqqg6pyaA4h/w50teI3l1kSJ5YZ4sfDYJyH7KcaVAj5DNCdJ06x/+EcIozvsNWHaji2dwRyXcVSpxVoaOB5mLKaJu9k+RdOinX0jiiMH2SkJWiUD1CXTfASdHEUOJE30YlEg1BYxXj/f5LL2KGEYmAy4OJHZZu41jBdMeNg8JYn62w0YZKoabB7togE/Vv80qkmVURuA2dYSf9olnC28g/FhkgZv7ULuX/TE5nIPhiwCXZI8n4/dW9bkbBU+4cIITa+tkoy4r59oVHDJYyyINzjmD52H2buk0rFP1d7z1f25rNgQVw4AJTxTcpISzzBzcfTXe9Ob9VBVGsZXUYH4N/Rs0iDy4fXbc6TnxfPGvwVd3hOfAAlgwh8VHLkyu6i5mNFV3PpAYFEnpeD0wa1Zy8B6RZIXBRs8tZ4Ez8YXnujdoWjq4bJ6ZSXtDsczX0aO9x27PU3xomAKAGTEwnOJK6FT6hE67gb8OPHwvsXjpemsNN9WDLVRvMajRBAEJVb6RNDBhKiZOa7aZOd3fQgOlhpaKPYmrWZ/f+x5XQsGD4kRVri0wyqsEt2UJO4HSnRCUzTOy0+nk5+zWsS8cGY0iUmKIv3GPC7EL6nZF3XLBVGUbgH4qroEbrg1pUG14NPVU2Qf3V6xAxmBhiTF7WaHHD3S0y8hj/qzbIM2GR2jHoUV/59JJps48prguYNLvHwcQpFnkpdSJcvHuLzmhn/tjN41TaV8jjCD/3zE7WOT86qjgjFE24MfHYg7S6uAc7omCC+1ZMDyHcklE/lRJvnp8g2w3I/rAOilfaR8hZjhyE1ONlRBb1+WuAeAFcNCtuj0XzN5Y9p7KaVbrhRy2iZjxk8EzoTtB7Td0f4QSlSD6n60jGvCLOhWVUY9V5/
 qd4Bcl+W
 auRWVipflHL9X0d43iTwStsP6rc/b2HWAASV7XQqX4tQoTGwb/E9dIaGPDmtCfWfsvGipnOh+yF7F8CB7cvat44/S45Sy7nWwO97zGDOJ1ZCOrAVAXGhxK3qL5qJH5RCeR/ei6HTf8yXn1/k3L2CGUDHHBEGgVUC6hw3Ju8+uszludQn1xfz5L35ih3HPBlJcX1GWIqert9u1BLeaYfblydOhefv26O0Lk8O669uxeN2793VaQp3J3zHbQG1QS7s0i1dVFSQN4/Ht1JHRIJse0QJqY9DGTZPLQMbK1FewgxcmCBwLnRrDmxvnoyge+nmgdSseDCl40RPmeqvgGy5HnpaPqsDW0Zc7D4cbU0RGCye+M646Wwdp7f2RBcaq+8LpbbA1LSEOqSpeWnf/wlFuAo1uRuRnt2xATdb1MPX07J9R2ERYTVTqtv7rV/ze0zH0YZ/aM4rt4leQ2cnTFlIpyB3kuSaKLFyEPOFo0yDI9DGRvmzQuplNvCduTvklUjpjRBIXA/2I6pdyTXV6Z4ofi9pBGQrOaR86UJHw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add damos_split.py, which allocates a MADV_HUGEPAGE-backed region in a
child process and runs a DAMON/DAMOS scheme with action 'split' and
target_order 0 against it, then verifies the huge pages are split into
base pages (the child's AnonHugePages drops).

Extend the _damon_sysfs.py Damos helper with the target_order parameter
so a scheme's split target can be expressed.



Co-developed-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Kunwu Chan <kunwu.chan@linux.dev>
Signed-off-by: Lian Wang (Processmission) <lianux.mm@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |   1 +
 tools/testing/selftests/damon/_damon_sysfs.py |   9 +-
 tools/testing/selftests/damon/damos_split.py  | 125 ++++++++++++++++++
 3 files changed, 134 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/damon/damos_split.py

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index ece244e5c5b9..a623c271355f 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS += sysfs.sh
 TEST_PROGS += sysfs.py
 TEST_PROGS += sysfs_update_schemes_tried_regions_wss_estimation.py
 TEST_PROGS += damos_quota.py damos_quota_goal.py damos_apply_interval.py
+TEST_PROGS += damos_split.py
 TEST_PROGS += damos_tried_regions.py damon_nr_regions.py
 TEST_PROGS += sysfs_refresh.py
 TEST_PROGS += reclaim.sh lru_sort.sh
diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index e6a2265d721e..5a01f31ad9f2 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -419,6 +419,7 @@ class Damos:
     filters = None
     apply_interval_us = None
     target_nid = None
+    target_order = None
     dests = None
     idx = None
     context = None
@@ -429,7 +430,7 @@ class Damos:
     def __init__(self, action='stat', access_pattern=DamosAccessPattern(),
                  quota=DamosQuota(), watermarks=DamosWatermarks(),
                  core_filters=[], ops_filters=[], filters=[], target_nid=0,
-                 dests=DamosDests(), apply_interval_us=0):
+                 target_order=0, dests=DamosDests(), apply_interval_us=0):
         self.action = action
         self.access_pattern = access_pattern
         self.access_pattern.scheme = self
@@ -448,6 +449,7 @@ class Damos:
         self.filters.scheme = self
 
         self.target_nid = target_nid
+        self.target_order = target_order
         self.dests = dests
         self.dests.scheme = self
 
@@ -492,6 +494,11 @@ class Damos:
         if err is not None:
             return err
 
+        err = write_file(os.path.join(self.sysfs_dir(), 'target_order'), '%d' %
+                         self.target_order)
+        if err is not None:
+            return err
+
         err = self.dests.stage()
         if err is not None:
             return err
diff --git a/tools/testing/selftests/damon/damos_split.py b/tools/testing/selftests/damon/damos_split.py
new file mode 100644
index 000000000000..089fbe0f0d4d
--- /dev/null
+++ b/tools/testing/selftests/damon/damos_split.py
@@ -0,0 +1,125 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+#
+# Functional test for the DAMOS_SPLIT action.
+#
+# A child process allocates a MADV_HUGEPAGE-backed anonymous region and
+# faults it in so that it is backed by (m)THPs.  The parent then runs a
+# DAMON/DAMOS scheme with action 'split' and target_order 0 against the
+# child and checks that the huge pages are split into base pages, i.e. the
+# child's AnonHugePages (as reported by /proc/<pid>/smaps) drops.
+
+import ctypes
+import os
+import signal
+import sys
+import time
+
+import _damon_sysfs
+
+PMD_SIZE = 2 * 1024 * 1024
+MADV_HUGEPAGE = 14
+PROT_READ_WRITE = 0x1 | 0x2
+MAP_PRIVATE_ANON = 0x2 | 0x20
+REGION_SIZE = 32 * PMD_SIZE
+
+def child_workload():
+    '''Allocate a PMD-aligned, THP-backed region, fault it in, then idle.'''
+    libc = ctypes.CDLL('libc.so.6', use_errno=True)
+    libc.mmap.restype = ctypes.c_void_p
+    libc.mmap.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int,
+                          ctypes.c_int, ctypes.c_int, ctypes.c_long]
+    libc.madvise.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_int]
+
+    # Over-allocate so that a PMD-aligned window is available.
+    raw = libc.mmap(None, REGION_SIZE + PMD_SIZE, PROT_READ_WRITE,
+                    MAP_PRIVATE_ANON, -1, 0)
+    if raw is None or raw == ctypes.c_void_p(-1).value:
+        os._exit(2)
+    base = (raw + PMD_SIZE - 1) & ~(PMD_SIZE - 1)
+    libc.madvise(ctypes.c_void_p(base), REGION_SIZE, MADV_HUGEPAGE)
+
+    buf = (ctypes.c_char * REGION_SIZE).from_address(base)
+    for off in range(0, REGION_SIZE, 4096):
+        buf[off] = 1
+
+    # Ready; idle until the parent tears us down.
+    signal.pause()
+
+def anon_huge_kb(pid):
+    total = 0
+    try:
+        with open('/proc/%d/smaps' % pid) as f:
+            for line in f:
+                if line.startswith('AnonHugePages:'):
+                    total += int(line.split()[1])
+    except FileNotFoundError:
+        return -1
+    return total
+
+def main():
+    if not os.path.exists('/sys/kernel/mm/transparent_hugepage/enabled'):
+        print('SKIP: transparent hugepage is not available')
+        exit(0)
+
+    pid = os.fork()
+    if pid == 0:
+        child_workload()
+        os._exit(0)
+
+    try:
+        # Give the child time to fault in its huge pages.
+        time.sleep(2)
+        before = anon_huge_kb(pid)
+        if before <= 0:
+            print('SKIP: workload did not get any THP (AnonHugePages=%d)'
+                  % before)
+            os.kill(pid, signal.SIGKILL)
+            exit(0)
+
+        # Split every large folio in the target down to order-0 base pages.
+        kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
+            contexts=[_damon_sysfs.DamonCtx(
+                ops='vaddr',
+                targets=[_damon_sysfs.DamonTarget(pid=pid)],
+                schemes=[_damon_sysfs.Damos(
+                    action='split',
+                    target_order=0,
+                    # match every region regardless of access/age/size, so
+                    # the ARM64 stale-TLB blind spot cannot mask the target
+                    access_pattern=_damon_sysfs.DamosAccessPattern(
+                        size=[0, 2**64 - 1],
+                        nr_accesses=[0, 2**64 - 1],
+                        age=[0, 2**64 - 1]),
+                    apply_interval_us=0)])])])
+        err = kdamonds.start()
+        if err is not None:
+            print('kdamonds start failed: %s' % err)
+            os.kill(pid, signal.SIGKILL)
+            exit(1)
+
+        # Let the scheme find and split the regions.
+        after = before
+        for _ in range(50):
+            time.sleep(0.2)
+            after = anon_huge_kb(pid)
+            if after == 0:
+                break
+
+        kdamonds.stop()
+        os.kill(pid, signal.SIGKILL)
+
+        if after >= before:
+            print('FAIL: AnonHugePages did not shrink: before=%d KiB '
+                  'after=%d KiB' % (before, after))
+            exit(1)
+        print('PASS: AnonHugePages %d KiB -> %d KiB after DAMOS_SPLIT'
+              % (before, after))
+    finally:
+        try:
+            os.kill(pid, signal.SIGKILL)
+        except ProcessLookupError:
+            pass
+
+if __name__ == '__main__':
+    main()

