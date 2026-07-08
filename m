Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1591BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B026B0095; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D52966B0096; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F2B6B0098; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 940416B0096
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:22:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0480C1C30C5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:23 +0000 (UTC)
X-FDA: 84967034208.07.15E12F8
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CDB240005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:22:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i7DzvVvL;
	spf=pass (imf27.hostedemail.com: domain of 3nc1OagsKCMwsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3nc1OagsKCMwsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783549342;
	b=LwSIToVDFWQ5XqRzyWHP+rObDAKyGVSpoG78QE/EhenzUEVWQrcaF7X6erO7daoV6yS+Ly
	25zXPOTJnAuMov2ysZjTEkfukCkcFBQ7IL275oVUGrVmHBrJ3i/FvUzKb8mM0lrkMFTyr7
	2eB+tB08t3KHcTxQfs4+k4AU37nJVAk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i7DzvVvL;
	spf=pass (imf27.hostedemail.com: domain of 3nc1OagsKCMwsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3nc1OagsKCMwsu2w93wGB5yy66y3w.u64305CF-442Dsu2.69y@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783549342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ez2sGXr0ImIl6qeGIDRJYiog01DgnPS7oVjoUBzVAs4=;
	b=mfYo+Pvel7eQY51aLrWvOYHZPpArnVIjyWREVIKGDR2OaTjo4FfCUX4/UKGx+u2jsameW2
	9oMLpxMCyqSrEDBt5qKQGIh6pKTqgvsHQiQFsvGSn3E//eIKg5g16wFdGoF19qn5od/HKN
	ibQCL6/v8+Hp0u6Nl1fL8CYQ8284Nxs=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-848474825ffso284007b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 15:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783549341; x=1784154141; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ez2sGXr0ImIl6qeGIDRJYiog01DgnPS7oVjoUBzVAs4=;
        b=i7DzvVvL8Dg0pbd1JM07EIcuzlR1OmibhaEwvuIcpDS6asGuGsRSM6vSXtFrPJloVh
         ANXttNcplnli1M0KFR1z9iumBc9G3tvf/EgDFSny3C8ON/edCpePI47PpRqF1Q2ijWNc
         ZDBnJOqnzEBblaDIz2AxfLqj5FWEYAy4LqncGCRuuTxTVmqS7P+LHOdD1agjSkuDSitE
         POVBYM4lWGX219yzdrYEG8hkx1J0SW9TDfrwqloKfkM4cjlK5aUxmUT57aXZqdp28O4Q
         qIKiUqFCsK0l7oWJBGO9DDumXVBCbuTCDQdaO9HB2Dojh+ov7vkVm/bkA5qGUHpaMszM
         Xmmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783549341; x=1784154141;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ez2sGXr0ImIl6qeGIDRJYiog01DgnPS7oVjoUBzVAs4=;
        b=kt69fop2KKOCRYCXmK2+nM6N5gBI0zY8zUhsWrVjrD/UXT/ITGdyLZx1q08i2tNm30
         HBb5lzmnLSQSZcd8GJHv8KxZkB/0H25t4ZNKAf4sA3enqhk410t+sVqRy+idGW7ve2GY
         ybRsgl3idiHSg/1HcHMnuXEtGLMpbDuVRdIWKTGDAbKVLH4+rYSAGRRFv4UxZUI/baBv
         3RV6qDvAna4S8H7Mr0MljjWqL+KrcWI7uc0ZANoTcbM5c8/qWxNImQbANTGR9g+AI5xY
         S4r+ukFUA2pGQjTO2Cp6wcqrGSue3KBz/HRrXgumnw5/WUNUuLfNuj0KhTte6z1J8E6a
         nPtw==
X-Forwarded-Encrypted: i=1; AHgh+Rod3ixIjp4i88BzpEOkXXgh75XFGlmtvrqppqamA7tkasYeEJWSVs3aQdKIaoZAdjMoh0/Iz3466Q==@kvack.org
X-Gm-Message-State: AOJu0YxjwuJ66bs/3iwRyiZRWH8c4ocQ314KWK+1nZtsu6/iIlhs9qej
	1TfncCsa4CEkCpA7ruXnCBmzJO4H28M54p+/qou0LUR6q3RCFdLmOgo6aW5hvDm3jrQAb9GHTgY
	i5qbL7Zk8i1I3BmZi+x5znJgLxw==
X-Received: from pfbna42.prod.google.com ([2002:a05:6a00:3e2a:b0:848:4809:51c6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2e28:b0:847:8791:f54f with SMTP id d2e1a72fcca58-8485ab7c6d2mr193415b3a.29.1783549341021;
 Wed, 08 Jul 2026 15:22:21 -0700 (PDT)
Date: Wed,  8 Jul 2026 15:22:13 -0700
In-Reply-To: <cover.1783549129.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
 <cover.1783549129.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <946c52b1d2bf058d8a61128a1490cbeab56b20a6.1783549129.git.ackerleytng@google.com>
Subject: [POC PATCH 3/3] Reproducer for allocation failure due to cgroup v2
 memory limits
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5CDB240005
X-Stat-Signature: ea6oewr86oa3pkp9xk9tnuoipx8pitb4
X-HE-Tag: 1783549342-468070
X-HE-Meta: U2FsdGVkX1/jCg8daIwvTm8wQAlu1luV7OHntQNMf/YBbOHFPfNwizFeF1722895sAk1tedWnK3GxIEbZUcKoSoi0s/XzaOUdezwmzwVxagLutt6DHVjt6F2vdbx/rjGovpugDpgsCRsmY3GnJVuGdoQDrHlIz6OnGgTn4QROD81qRbHdQg2PaozM080QVWi+8hW+5MDhSmGkRUf7HgoZyQWc/BSzU/9c9b5ZHZcvYSybd5aA+l1sZw6rqOp+8LK3kq2gsXc+sA0XXyL5s1LG9ehTw6xPM2yLTK2GGKYqntrhYOK8PYYtcCPD8Y/UqRN3zv2LAKz7oLLlmcPJfw7Tpad4VPP/8kHaurNF2AU2Gy6oLNOM3s0gGsUy5ARjG9W5ViRmXCi7A1NfyNPVGU8zJd1OCUvfAfIGWOHy4Szy/ZQtGJug6QPwTwruBU9Eg+pyCbvlFq3bP5zxFU2QyPgtyvrddm75GcAv+X8rhxAxCwOZumxh1PACR57B9H9SFeK7aiFipAwkn/bj1rB1DCMaiP1WJ957qV+xw3Jh7r3gvNxvvPx9eyt3h4qP6Ar4BPLYi/zvLHALV/MOf0/XvVbuxXNymHmTmTjbvT9sUqdA+E+aQ4/TJy6vXvRiVkcZ+cO7GK80F2UtzgEQA7EvfXxyGu11LZ9ClaLXmlMkLCsZt7MDLOzuIfe0AsyK7dNmqIzZrcbhD9iAz0aaCRQRDX2gpLcrc67Jyot7jw7CxMyVs/NuXEZPtvteDnzR6zmYhCXZEf2iBmPZTrqv/CBMsF0QRzQa4NkroLuTePR3/N4F6BRQsx93eeE8I/fYKFeoryrrDP9IxZwbzwCC4U1wcDBomd/EV17hZl3o6MQploV/qJ9R+ypKngynzawuTtxjHisIupf3nwldaQelacKMNgNTlkNXbdRIrlUdef9Yy8hixC1yBh6gBdzfJUBxsutWxVqzde6knDUgmLooKs0uHW
 +VrioMUE
 4IMWQPRw9Ss7Setr1eBY3WW0ArisdtUGdmyqDSnV8tk8+zhiTotYXcJ9zptVlQ1bi+QgmZDC+PvpU/BL9PtzYR3QseLOzjwkPde/3idbBnFPkQA4QqCgADMolmUG+IciwLyW5RcYrIMqljuPv0e+OH+a8sosevmP1CWZaXx5lq8ZPjK6KajAZRUWEYVtQwF3JA6U/w5e5BpgG9pCtpFZT4mk+j5oPBBenK/oyV7qtmjvGNMZYtG1XgZoWkNPZoKPGshSP0igKV7RfXGdd1K1CrkvH+7H1uFAK6/cXGcmtA9QId13qj3D7W8caVL1SwJiznRGJIvWVPRaskvOplZBpJo9QH0ioF9TGGy8Q34jijctgylDfgtl7ak1iJ8OATKDeq9laSvhkbSqTdYneiXOQyR28OIvQ+uqgKzq/KIRZxqdTGWuVYaglCad1U6HYDySmmVzrZDejXKYVG+5yjiUxMwXgROgpzr4mHz0zb44SJtvNpD8PxjYWf9zI956KTkTWAiEDLj5yfugE7wjR8pdPmsL0ATjKzYLvE0J4+RsQGvt+n9alXZqZ3M+oLhV4HoyozBzOtRj92zNVP423MTovv+1pmx/deg5fPntJ2e1iXMgE1okUzoVonFJ4/C/T2j5xavqgEf8db2pHxxbgkj5w/GtcM9k//bRooPjBqiU594YRlYL/Qhca1DcYdzAosERPNU3LdlQZAY0IpNaR1Tf8u2PuXvAyI9IWsNbU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(This reproducer was hacked up and not meant to be merged.)

cgroup_v2_allocation_failure.c triggers HugeTLB allocation failure by exploiting
cgroup v2 memory limits. This allows testing the error paths in the kernel when
memory control charging fails, even when physical huge pages are available.

The program performs the following steps to trigger the failure:

1. Enable hugetlb accounting in cgroup v2.
     + The program checks if memory_hugetlb_accounting is enabled in the cgroup2
       mount options. If not, it remounts /sys/fs/cgroup with this option
       enabled. This ensures that HugeTLB allocations are charged against the
       cgroup memory limits.

2. Create a test cgroup and set limits.
     + The program creates a new cgroup subdirectory named test_reproducer under
       /sys/fs/cgroup.
     + It sets the memory.max limit of this cgroup to 1MB (which is less than
       the 2MB huge page size).

3. Fork a child process and move it to the test cgroup.
     + The program forks a child process.
     + The child process moves itself into the test_reproducer cgroup by writing
       its PID (using 0 for current process) to cgroup.procs in the test cgroup
       directory.

4. Attempt to allocate and touch a 2MB huge page.
     + The child process maps a 2MB anonymous huge page using mmap with
       MAP_PRIVATE, MAP_ANONYMOUS, and MAP_HUGETLB.
     + The child process writes to the mapped address, triggering a page fault.

5. Triggering the kernel bugs.
     + The page fault handler calls alloc_hugetlb_folio to allocate the huge
       page.
     + The allocation of the physical page from buddy allocator succeeds
       (assuming nr_hugepages is sufficient).
     + The kernel then attempts to charge this allocation to the child process's
       cgroup by calling mem_cgroup_charge_hugetlb.
     + Since the child's cgroup memory limit is 1MB and the page is 2MB, the
       charge fails and mem_cgroup_charge_hugetlb returns -ENOMEM.
     + This triggers the error path in alloc_hugetlb_folio where the bugs (folio
       refcount mismatch, infinite loop on ENOMEM, and reservation leaks) are
       handled.
---
 cgroup_v2_allocation_failure.c | 160 +++++++++++++++++++++++++++++++++
 1 file changed, 160 insertions(+)
 create mode 100644 cgroup_v2_allocation_failure.c

diff --git a/cgroup_v2_allocation_failure.c b/cgroup_v2_allocation_failure.c
new file mode 100644
index 0000000000000..938cbf02ae6f7
--- /dev/null
+++ b/cgroup_v2_allocation_failure.c
@@ -0,0 +1,160 @@
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <string.h>
+#include <errno.h>
+
+#define CGROUP_PATH "/sys/fs/cgroup"
+#define TEST_CGROUP "test_reproducer"
+#define TEST_CGROUP_PATH CGROUP_PATH "/" TEST_CGROUP
+
+void write_file(const char *path, const char *val) {
+    int fd = open(path, O_WRONLY);
+    if (fd < 0) {
+        fprintf(stderr, "Failed to open %s: %s\n", path, strerror(errno));
+        exit(1);
+    }
+    if (write(fd, val, strlen(val)) < 0) {
+        fprintf(stderr, "Failed to write %s to %s: %s\n", val, path, strerror(errno));
+        close(fd);
+        exit(1);
+    }
+    close(fd);
+}
+
+int is_hugetlb_accounting_enabled() {
+    FILE *fp = fopen("/proc/mounts", "r");
+    if (!fp) {
+        perror("fopen /proc/mounts");
+        return -1;
+    }
+
+    char line[1024];
+    int enabled = 0;
+    while (fgets(line, sizeof(line), fp)) {
+        char spec[256], file[256], type[256], opts[512];
+        if (sscanf(line, "%255s %255s %255s %511s", spec, file, type, opts) == 4) {
+            if (strcmp(file, CGROUP_PATH) == 0 && strcmp(type, "cgroup2") == 0) {
+                if (strstr(opts, "memory_hugetlb_accounting") != NULL) {
+                    enabled = 1;
+                }
+                break;
+            }
+        }
+    }
+    fclose(fp);
+    return enabled;
+}
+
+int enable_hugetlb_accounting() {
+    printf("Attempting to remount cgroup2 with memory_hugetlb_accounting...\n");
+    int ret = system("mount -o remount,memory_hugetlb_accounting " CGROUP_PATH);
+    if (ret != 0) {
+        fprintf(stderr, "Failed to remount: system() returned %d\n", ret);
+        return -1;
+    }
+    return 0;
+}
+
+int main() {
+    struct stat st;
+    if (stat(CGROUP_PATH, &st) != 0 || !S_ISDIR(st.st_mode)) {
+        fprintf(stderr, "cgroup v2 not mounted at %s\n", CGROUP_PATH);
+        return 1;
+    }
+
+    int enabled = is_hugetlb_accounting_enabled();
+    if (enabled < 0) {
+        return 1;
+    }
+    if (!enabled) {
+        if (enable_hugetlb_accounting() != 0) {
+            fprintf(stderr, "Could not enable memory_hugetlb_accounting\n");
+            return 1;
+        }
+        // Re-check
+        enabled = is_hugetlb_accounting_enabled();
+        if (enabled <= 0) {
+            fprintf(stderr, "Failed to enable memory_hugetlb_accounting (re-check failed)\n");
+            return 1;
+        }
+        printf("Successfully enabled memory_hugetlb_accounting\n");
+    } else {
+        printf("memory_hugetlb_accounting is already enabled\n");
+    }
+
+    // Enable memory controller in subtree
+    int fd = open(CGROUP_PATH "/cgroup.subtree_control", O_WRONLY);
+    if (fd >= 0) {
+        if (write(fd, "+memory", 7) < 0) {
+            // Might fail if already enabled or not supported, ignore for now
+        }
+        close(fd);
+    }
+
+    if (mkdir(TEST_CGROUP_PATH, 0755) != 0) {
+        if (errno != EEXIST) {
+            perror("mkdir test_reproducer");
+            return 1;
+        }
+    }
+
+    // Set memory limit to 1MB (less than 2MB hugepage)
+    write_file(TEST_CGROUP_PATH "/memory.max", "1M");
+
+    pid_t pid = fork();
+    if (pid < 0) {
+        perror("fork");
+        return 1;
+    }
+
+    if (pid == 0) {
+        // Child
+        // Move to cgroup
+        write_file(TEST_CGROUP_PATH "/cgroup.procs", "0");
+
+        printf("Child: Attempting to allocate and touch 2MB hugepage...\n");
+        // Allocate 2MB hugepage
+        size_t size = 2 * 1024 * 1024;
+        void *addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+                          MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+        if (addr == MAP_FAILED) {
+            perror("Child: mmap MAP_HUGETLB");
+            exit(1);
+        }
+
+        printf("Child: mmap succeeded at %p, touching it now (should trigger fault)...\n", addr);
+        // This should trigger the fault and call alloc_hugetlb_folio -> mem_cgroup_charge_hugetlb
+        // which should fail and trigger the bug.
+        *(volatile char *)addr = 1;
+
+        printf("Child: Successfully touched page (bug not triggered?).\n");
+        munmap(addr, size);
+        exit(0);
+    }
+
+    // Parent
+    int status;
+    waitpid(pid, &status, 0);
+
+    printf("Parent: Child exited. Cleaning up.\n");
+    rmdir(TEST_CGROUP_PATH);
+
+    if (WIFSIGNALED(status)) {
+        printf("Parent: Child killed by signal %d (%s)\n",
+               WTERMSIG(status), strsignal(WTERMSIG(status)));
+        if (WTERMSIG(status) == SIGBUS) {
+            printf("Parent: Child got SIGBUS as expected (if kernel didn't crash).\n");
+        }
+    } else if (WIFEXITED(status)) {
+        printf("Parent: Child exited with status %d\n", WEXITSTATUS(status));
+    }
+
+    return 0;
+}
-- 
2.55.0.795.g602f6c329a-goog


