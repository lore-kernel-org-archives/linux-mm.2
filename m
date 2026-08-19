Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0777C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:05:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049E06B009F; Wed, 19 Aug 2026 03:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022556B00A3; Wed, 19 Aug 2026 03:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA02F6B00A5; Wed, 19 Aug 2026 03:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C15B76B009F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:05:57 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 371CE80474
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:57 +0000 (UTC)
X-FDA: 85117134354.19.29CCD9F
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id 73E652000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:05:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oEE4TbhT;
	spf=pass (imf03.hostedemail.com: domain of 30lWFaggKCO0YPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=30lWFaggKCO0YPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787123155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E95q1x2DT6McfvZlrwH4oQfSk4gruvw+vn9eniPurXw=;
	b=0iQ1jbH5chJ1tvEum4tZIctfCp9P9tfAQMHxK9QJK5duED68pYKITPgYUWJHfiHYTVcXBj
	yBF1aMUiNN0wRxCTFX3yQMz+PGxBdbHKGIZFz5Ym0pcjAOsibx/DGvhB6UOCkGtoBaTr7G
	YqzpBmq5snAz69H7Q6slqrkdquN4DV0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oEE4TbhT;
	spf=pass (imf03.hostedemail.com: domain of 30lWFaggKCO0YPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=30lWFaggKCO0YPhdcbXjVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787123155;
	b=MHqnFfYg2opTJS5ZTVzFM54vwATk85qBg3XCKflMPJsM1ellM67eEi2XGMC08llCTnj8ew
	wXejchLicW5PIqmvwJ7uqAqC3jeTBBk9TNCcQQvSh/SC5na6eCnvFOJFM19TMh3QUKVifn
	8mkHBAbPO7cj8vMJPrjR7FJVTkguFag=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so1159071a91.3
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787123154; x=1787727954; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E95q1x2DT6McfvZlrwH4oQfSk4gruvw+vn9eniPurXw=;
        b=oEE4TbhTVnIjIIS7GQeEDJ4ilW/1lZ2H9B9PtYQ70RsspbpB7D0lFnqxXKiMNFh5GG
         z7c+0M9oRJUmcqpAf27pRNcdILDUR/xW4j/PDGQoLc09Y5u0yA4+6zIQVUMmBJHEgRrv
         nfSGh1D1k8QrSpYl8+PPbcUat5WQyBIE2eHklZq2XPsGWcE6iVqMqBOtaG69fgPWM7TO
         jal1XTehf+eTavH03AEWmiYhze7P26q4dBjkkWEFCe1BnYmtjvBFv+kU6oX+5CIMPKX7
         dXUklGE9t6HEaOsicGevALnoLfGd/kuxt8J0FGQVR6TWCGKcTAIj5Q7PC4Rn2ADbwKzL
         swcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787123154; x=1787727954;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E95q1x2DT6McfvZlrwH4oQfSk4gruvw+vn9eniPurXw=;
        b=OlbwbySBFPP8ospcXPTbGRmB7++B3NKNoZl/pIeAl+fJeO/jTwP5QVzHxAIB66u1N6
         j62fYRN8v9VPPn5ZpzWPSxMrgWOe9U8sS9gjWzWAld9PcYPMN7poc6zDlj/9VE57dZDi
         hKrVO4h9aTKGjG99VAyPOBkG6/eSzBcVBstWzgfxTLpfglY6O3b8FVt2+F1iKSx5QJ86
         I2MKLbUoVZ7fnq3Xq6W+nd3xj1fIZLEqLbeh9+wGQywOyTUsqu364XUMenmRJaFGZMAI
         PAIOkDoA6XTJrppB0NkuHxJerw/r7OeEbdgJwVYNi24jIYhQAZMQ94gPXWvwwm73A5ev
         ROEg==
X-Forwarded-Encrypted: i=1; AHgh+RpNzbdx2UxqjPOX2ndBUM2WSTAdlA4AKT3rE+SvNgmtoeAYnzzmvKTrg6rj7Io4Zhp2WRp3VbLUSw==@kvack.org
X-Gm-Message-State: AOJu0YxiZ6+2zpPSDfkDCuF4/kkcCG3TYLvGHodGvaklTCgWHNuwMxX1
	4GPg1flFWFSjM8en86jF32iZ0BeGLyleQT0EYyx3EJwopYFF63vHDz54m2INs2eTF13jQ+7jImK
	OrtDj9OQeYi+8cw==
X-Received: from dyctz24.prod.google.com ([2002:a05:7301:9f18:b0:327:b132:c5a9])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5250:b0:381:9028:5945 with SMTP id 98e67ed59e1d1-3958125375amr5159730a91.14.1787123154083;
 Wed, 19 Aug 2026 00:05:54 -0700 (PDT)
Date: Wed, 19 Aug 2026 00:05:37 -0700
In-Reply-To: <20260819070538.2404983-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20260819070538.2404983-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.55.0.737.g08866a6d13-goog
Message-ID: <20260819070538.2404983-3-jasonmiu@google.com>
Subject: [PATCH 2/3] selftests: mm: add script to induce userspace memory contention
From: Jason Miu <jasonmiu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Greg Thelen <gthelen@google.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, Jason Miu <jasonmiu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73E652000C
X-Stat-Signature: ngs1a6o9ccyt7zbugi861jm1miym6eij
X-Rspam-User: 
X-HE-Tag: 1787123155-891014
X-HE-Meta: U2FsdGVkX180PAHwdUyUTCEzfPmzBsJ6lSQ0OGs58CL7MQHPBHdwPiJNMgDtdgTH1Oja7/7Y0x9W3UyVCV+25Bth6AUF+LOEmC25KcGEElRSBIoooFnAhaQvzMw2cpK7Ze1lGKkYuDNSFbRu9k+viLzPC+cOa36cmfVfFfooXsNrbbLn9jmII/aV3LjHIxsi2ZjdLtHptEh2fQ3YKxOEkkMyOKvHxLSzC6j6ah9hMNrPCNy8zhp8WsnydLiDMTk7fZFaxJr2Fpr+TWlnUaD5VzLXZ76wIqgmvdFb2s2ZEqJ9tRSOUqmybTAvr+B4nB9b+TxlgJ2SPo+4sNsiYQktXcM2aRxbhLpNu1ZR11CvSdE/JRsUJGQb9WIb27AGjfq/+i3zEl68a4rKDT2zPOoW0xOI/FwRJS67J8RDFfzru3m2sG5g3V0BzRENKvjjQdctug07WFSbUZ1UQGmVZ45SC30V7mFyzk3z+c2YZmtro4qN9V0G1YlQNFwIshX7wMWQtQh++TLiXQ/kZ5fc7E8LR47m9qj/7NgbEEOE/prV4Soh8Iq+BLU0WPAYkpU5JkAdsHlDkEOHJ45gjbVRzYDL5GurQxyjWz22iA3ZZm/3iQwHl48LMsMGnTq8sQnx6ro2bR7cpymJ11iJqMF8aURk0IT28UWhZPbbFTkvJNB1462PNIL+g4jceUI0VSUu8QRCDrSOTaCqlTcKju8n9w6DdycMtqa0wUBM7VFRewXRJzMctbZrGDdYjoBpYOrg1k5UPXmeS92Jeen8fe0A6UD+y7JdNH37bkXmetLaSqBGN0LW52NwcTMgO7VduGe1qt23tX/pr5dSMdOUvuHQfgvlRpWO/HjpEe+YGaJ+SL0uSpIupcfHDoCzblFttDVfGR17nRKNa4WH8H9tHWQV84vio4zAhrS1tZXpN1k+0qfEWlKICt+bjjK41KtQoltWFP/W7F87XXM36z9MqFC9dsl
 OgTMWxB9
 r4zeVF+7k1JPLb4ScPbPxp9K+b+0HZB//iugHJPMhG595b0kIDCVYlHpIIi9N1I5NcSY4KNGq4gt+ljZ5DjNW0So00CxwkZcXWgARW2eVP0kqGNgHlmXQv6M/+5vQ92yEUmCIw0B3J3Ir0BfuEpJ5bRAYWsZD5UeEp9MVCnks/gDFyDnFG3C7ZTaIyNYEhdexRw2w8QFk91ghgBcpNLfbdV71HXFw5eUU1axMvZwWtxQcXuytuldrOeQxFXvH1fC7Xjb9SzssiDlItGLGN5lWjKyVrZErcxMGiNPjWjx4ntEIyClTwhg2X7iaurkDRteYonYMc5bHirhV5wzskvq5OlJDZJYUUP5KE+rvl0Lcp/7oW/uMdX0/oEWxrpLy66jDMKOXOp3dD/epuqHEGw8f2WOOXtfdXk3rxvOAJq3OQ1yH4yT3+YRbYT1XBX+AkXfjQYSyLbQckIiCI2Zp7h7MMDpM8TELsGe7QgW4fXK3Tqi0xL9LNW6Wgg+tBa2tIlcakDZ9bifaptT9ygTyo3BNSpbufFw7rYFYp+jDCqYmnP/2d9ARy/wUJr/ZT94dQtPJhEIHBVZOJ23ZBOH0sJm7DQvDHfiHphtjIG0rz9iBfRkJf/2WaFKSH22CCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce page_alloc_stall_pressure.py, a userspace workload generator
designed to saturate available system memory and force high-frequency
page swapping.

Implement a dual-process architecture:
1. Map a specified percentage of system memory into a primary memory
   hogger process to establish a low-watermark state.
2. Spawn concurrent worker processes to continuously overcommit the
   remaining memory and touch anonymous pages, driving rapid page
   replacement activity.

Provide this script to orchestrate artificial userspace memory demands.

Note: Execution requires the external memtoy binary
(https://github.com/kosaki/memtoy) to handle underlying anonymous memory
block mappings.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 .../selftests/mm/page_alloc_stall_pressure.py | 235 ++++++++++++++++++
 1 file changed, 235 insertions(+)
 create mode 100644 tools/testing/selftests/mm/page_alloc_stall_pressure.py

diff --git a/tools/testing/selftests/mm/page_alloc_stall_pressure.py b/tools/testing/selftests/mm/page_alloc_stall_pressure.py
new file mode 100644
index 000000000000..5e95a2355198
--- /dev/null
+++ b/tools/testing/selftests/mm/page_alloc_stall_pressure.py
@@ -0,0 +1,235 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0
+"""
+page_alloc_stall_pressure.py
+
+Executes a multi-threaded userspace workload to consume and touch anonymous
+memory. It serves as a workload generator to create system memory contention.
+
+Mechanism:
+1. Instantiates a primary memory hogger process to occupy a predetermined
+   percentage of system memory, mimicking a low-watermark memory state.
+2. Spawns multiple concurrent worker processes to intentionally overcommit the
+   remaining memory, generating high-frequency page replacement and swapping
+   activity.
+
+Parameters:
+ - hog_percent:      Percentage of available system memory to lock strictly
+                     inside the primary memory hogger process. (Default: 50.0)
+ - num_workers:      Number of concurrent worker processes mapping anonymous
+                     memory. (Default: 64)
+ - overcommit_ratio: Ratio of remaining free memory intentionally overcommitted
+                     and mapped across all workers. (Default: 2.5)
+ - memtoy_path:      Local filesystem path to the compiled memtoy binary.
+                     (Source available at: https://github.com/kosaki/memtoy)
+                     The binary is operated via stdin and must support commands
+                     to allocate, map, and continuously touch anonymous memory
+                     regions. (Default: "memtoy/memtoy")
+
+Usage:
+ python3 page_alloc_stall_pressure.py <hog_percent> <num_workers> \
+          <overcommit_ratio> <memtoy_path>
+"""
+
+import os
+import sys
+import subprocess
+import time
+import threading
+
+def get_mem_free_bytes():
+    with open("/proc/meminfo") as f:
+        for line in f:
+            if line.startswith("MemFree:"):
+                return int(line.split()[1]) * 1024
+    return 0
+
+def get_cgroup_root():
+    # Check for both v2 and v1.
+    if os.path.exists("/sys/fs/cgroup/cgroup.controllers"):
+        return "/sys/fs/cgroup"
+    if os.path.exists("/sys/fs/cgroup/memory"):
+        return "/sys/fs/cgroup/memory"
+    if os.path.exists("/dev/cgroup/memory"):
+        return "/dev/cgroup/memory"
+
+    raise FileNotFoundError("Neither Cgroup v1 nor v2 controllers found.")
+
+def create_memcg(cg_name):
+    cg_root = get_cgroup_root()
+    path = os.path.join(cg_root, cg_name)
+    try:
+        os.makedirs(path, exist_ok=True)
+    except Exception as e:
+        print(f"Failed to create cgroup {path}: {e}")
+
+def remove_memcg(cg_name):
+    cg_root = get_cgroup_root()
+    path = os.path.join(cg_root, cg_name)
+    try:
+        os.rmdir(path)
+    except Exception as e:
+        print(f"Failed to remove cgroup {path}: {e}")
+
+def run_mem_hogger(cg_name, size_bytes, memtoy_path):
+    cg_root = get_cgroup_root()
+    try:
+        full_cg_path = os.path.join(cg_root, cg_name)
+        def assign_memcg():
+            pid = os.getpid()
+            with open(os.path.join(full_cg_path, "cgroup.procs"), "w") as f:
+                f.write(str(pid))
+            # Protect it from the OOM killing
+            with open(f"/proc/{pid}/oom_score_adj", "w") as f:
+                f.write("-1000")
+
+        p = subprocess.Popen([memtoy_path],
+                             preexec_fn=assign_memcg,
+                             stdin=subprocess.PIPE, stdout=subprocess.PIPE, universal_newlines=True)
+
+        size_mb = int(size_bytes / 1024 / 1024)
+
+        p.stdin.write(f"anon region {size_mb}m\n")
+        p.stdin.write("map region\n")
+        p.stdin.write("lock region\n") # Do not swap out the hogged memory
+        p.stdin.write("touch region write 1\n")
+        p.stdin.flush()
+
+        for line in p.stdout:
+            if "touched" in line:
+                print(f"Mem Hogger (PID {p.pid}) allocated {size_mb} MB RAM.")
+                break
+
+        return p
+    except Exception as e:
+        print(f"Failed to run Mem Hogger: {e}")
+
+class WorkerThread(threading.Thread):
+    def __init__(self, name, cg_name, size_bytes, memtoy_path):
+        super().__init__(name=name)
+        self.cg_name = cg_name
+        self.size_bytes = size_bytes
+        self.process = None
+        self.daemon = True
+        self.should_stop = False
+        self.memtoy_path = memtoy_path
+
+    def run(self):
+        full_cg_path = os.path.join(get_cgroup_root(), self.cg_name)
+        def assign_memcg():
+            with open(os.path.join(full_cg_path, "cgroup.procs"), "w") as f:
+                f.write(str(os.getpid()))
+
+        # Allocating a region of memory with size_bytes.
+        while not self.should_stop:
+            try:
+                self.process = subprocess.Popen([self.memtoy_path],
+                                                preexec_fn=assign_memcg,
+                                                stdin=subprocess.PIPE, stdout=subprocess.PIPE,
+                                                universal_newlines=True)
+                size_mb = int(self.size_bytes / 1024 / 1024)
+
+                self.process.stdin.write(f"anon region {size_mb}m\n")
+                self.process.stdin.write("map region\n")
+                self.process.stdin.write("touch region write 1\n")
+                self.process.stdin.flush()
+
+                print(f"Worker {self.name} (PID {self.process.pid}) allocated {size_mb} MB RAM.")
+
+                while True:
+                    try:
+                        # Access the newly allocated memory continuously.
+                        # If it get killed during stdin write, it is ok.
+                        self.process.stdin.write("touch region read\n")
+                        self.process.stdin.flush()
+                    except (BrokenPipeError, ValueError):
+                        break
+
+                    for line in self.process.stdout:
+                        if "touched" in line:
+                            break
+
+                    if self.process.poll() is not None:
+                        break
+
+            except Exception as e:
+                print(f"Worker {self.name} process terminated: {e}. Respawning.")
+                if self.process:
+                    try:
+                        self.process.terminate()
+                    except Exception:
+                        pass
+                self.process = None
+                time.sleep(0.1) # Don't respawn too fast
+
+def main(hog_percent, num_workers, overcommit_ratio, memtoy_path):
+    free_mem_bytes = get_mem_free_bytes()
+    hogger_bytes = int(free_mem_bytes * (hog_percent / 100))
+    remain_bytes = free_mem_bytes - hogger_bytes
+
+    hogger_memcg_name = "mem_hogger"
+
+    print(f"Allocating {hogger_bytes} for the memory hogger.")
+
+    create_memcg(hogger_memcg_name)
+    hogger_process = run_mem_hogger(hogger_memcg_name, hogger_bytes, memtoy_path)
+
+    worker_size_bytes = int(remain_bytes / num_workers * overcommit_ratio)
+    print(f"Spawning {num_workers} with {worker_size_bytes} memory allocation each.")
+
+    threads = []
+    for i in range(num_workers):
+        worker_cg_name = f"worker_cg_{i}"
+        create_memcg(worker_cg_name)
+        t = WorkerThread(f"Worker_{i}", worker_cg_name, worker_size_bytes, memtoy_path)
+        threads.append(t)
+        t.start()
+        time.sleep(0.05)
+
+    try:
+        print("All memory loads are created. Will run for 10mins, or Ctrl-C to exit.")
+        start_time = time.time()
+        while time.time() - start_time < 600:
+            time.sleep(10)
+    except KeyboardInterrupt:
+        print("Got Ctrl-C. Exiting.")
+    finally:
+        print("Cleaning the processes and cgroups...")
+
+        if hogger_process:
+            try:
+                hogger_process.terminate()
+                if hogger_process.stdin: hogger_process.stdin.close()
+                if hogger_process.stdout: hogger_process.stdout.close()
+                hogger_process.wait()
+            except Exception:
+                pass
+
+        for t in threads:
+            t.should_stop = True
+            if t.process:
+                try:
+                    t.process.terminate()
+                    if t.process.stdin: t.process.stdin.close()
+                    if t.process.stdout: t.process.stdout.close()
+                    t.process.wait()
+                except Exception:
+                    pass
+
+        # let the kernel settle down
+        time.sleep(1)
+
+        remove_memcg(hogger_memcg_name)
+        for i in range(num_workers):
+            remove_memcg(f"worker_cg_{i}")
+
+        print("Cleanup done.")
+
+        return 0
+
+if __name__ == "__main__":
+    hog_percent = float(sys.argv[1]) if len(sys.argv) > 1 else 50.0
+    num_workers = int(sys.argv[2]) if len(sys.argv) > 2 else 64
+    overcommit_ratio = float(sys.argv[3]) if len(sys.argv) > 3 else 2.5
+    memtoy_path = sys.argv[4] if len(sys.argv) > 4 else "memtoy/memtoy"
+    sys.exit(main(hog_percent, num_workers, overcommit_ratio, memtoy_path))
-- 
2.55.0.691.gc56d675ccc-goog


