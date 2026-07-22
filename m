Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC93C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3856B00B2; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE466B00B5; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C9F6B00B2; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F50D6B00B4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E6F1B40341
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:27 +0000 (UTC)
X-FDA: 85018036614.14.FD3BFE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D906C100006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Da/RE/zo";
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFfIAxTMBj9xuekExLT1vVUgr038bNTuXro3FkByEwA=;
	b=gnpnNuIiwmPgPj3DEfpBbfqq4xpNduk7uWzantB8vxCVPNArFSrue/i72Jea0dL91Gv3fw
	UGlfNH2gLVil5pOIJiJo4LXmNV8Xw3SMzf9Ndi61FjpV8tddT6dkPo3UqrSxQ611Cb+YiR
	YY74t0stdnkT+VoPvaR6dZCFe4J1jz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763686;
	b=5RnPdIFzfWjvqk1/0G9qLoWUGI3iRWSb19kEPqL1cZZjDawlyw3XVUxkMLkPS3Zar1qey0
	P3p+sxWEjAMbmVyvF/PgHpTytbQX51odCDZk8WGSR19khCQheYy4bxGVfVireBNNXQDXjX
	oxaA3y0QEpEnCiL6Og4Eq/2KSY6OPtg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Da/RE/zo";
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1D6945161;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ADAE6C19425;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=tQO4lhRXKQ6uEvJGNjKAll868IKX9d/or000tzu8DAA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Da/RE/zoJl4bsjzKC3/H6wBhxJjhv27xrkhGf2e6DeYX9aq6zIh+n6ytW5Gp6GUll
	 ec3Y3rU+Amik1YEt1lejx7UURMqrjTazilzUhYdGgWMKY9/ZJIUN0xPOctaL6JwcSe
	 KnAZyPXxm6Nb9oGSP0ap2pMOrlBKq6jvUtnEKc8YW/omG8kzGSvdj89nppnrvSATBA
	 jU5l+YcJFIA3ooIyyd4Fi4fQARsM5hg+hUek35mgd8ozVwjLqWesvg5WNaiwE2ItoU
	 qOjtW/Fl4hCjl3LsF1sG0Oivg+ODaW0T/kECmSYG+7Ln163AXtbZNgzJY4z44n0y0K
	 724cJdjfF3u3g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99666C4453A;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:21 -0700
Subject: [PATCH v4 13/16] WIP: Reproducer for allocation failure due to
 cgroup v2 memory limits
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-13-88e8b81970dc@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=6966;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=JlTcWmu4YylYJqF+iA2BMg6mM33pft18C72PLT5bBdc=;
 b=CsPLTCLuBSVGQbXs8wDx4crR6XxCc1FrWqzQJTSbrryBKU8/Kqta9FxI5P4Zfib63Gi8X9Vyh
 BLsF9HAKYoDCxA69jvJVKW35iNPeQTIvHSYzk03E2p3reohwsAxU8Hk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D906C100006
X-Stat-Signature: 84o377eot3munstcpq87zapeb947c4eb
X-HE-Tag: 1784763685-665318
X-HE-Meta: U2FsdGVkX188ehIhNElQB7hHYGi0OHbrB0zdmXnu9hlUug/5HFtkg5db/zhqRW6gTFGALjyMiS0nrKeyIg7LJJJRF/OKdDJ41sXyl55J+cvsMFSbFmNl84UtpO6eumqSBSLErSxn9DZ9AepnQ43rnkskiw4jDzaNebmIJVbzJ8ErvxfNYqEQPMAMME2FKpg/NGvpn46ZgnrUPretI3PR0yGzn3k4Y8zwwIoCM2r92VYqnGBW+7aNUvGUdsRb000huvxH3goxzlQ0SfX+DSAo0Xm1F5dSvlWlsuBcoodHMiZfreSEQn6sD+Mvt43rqwsqfMqkI0XSVirlqs5exWT29cDPVOgYLEIH8DQfTsbfIZTWhwHafCO7y/+lixbSrRmEypTQ/jA4mQq4W3OyirGvfZGsqdPDq4sJaIE3CaztZ1rEzk6RkhwRi5zHdhazWTLU/wsmnzgZ2UO8buX1srkITip/1GD5vYQC3yHaCRu1X/x8YojHCuwug8BNwcDT1CPnAD6MzGJrtExHZznFYw3oXnEC8oWgr0Zwm8t0CbC+DmwhY+dNVP2wX1DDc38GfS3lW0j7zXUUB3XNSJkNqbza2Fy9TGTCqPdqFmRER1DpN28ef6lFgYR3IZvmJFk5Be2sZzpVR50Bm+27bIHO3j92qr/ipT7MJLVvBGnPQD6sd9d1RGeuMgViUoFNuciaVea0SbGfmU8B68hfgDgmci23trLTToiOQI4VuNZmMT6MpUWhQDvds4+PKcJXkx54qGvqyvr7yfLJQxD+StV5NMLbdJuBzq/aFU5q0hm7RjKaVNgw8viDjGNBArtEONfyyfae56WblEcFdSOHAcSLgSuB1JB0y9nSLgcVENOEs8kruI1jfsOfc4uEuwmeNc2dEzJZEJvI2maoJy5xOZg1zOoZ5++y0zNlqPwj8ri3doK/dTyBoAhWUtkqaOnRPkytCtWxqeLSFU/8RhiIlJKq8+P
 N56WJVXa
 XK/LhvHB35V3F5H8PlldSDZ050/Dol4+PVB7M7DgNFcGy6blizZz2UuFC1ff63r3nldJ/sjgkRsGnTbE7GkSJ9OsDVIecfS7hOQfLQxNZIHYyUV046Vde0Cgr58aQFasxflgpX9XppbIG4dVsYPfHajuQeIEWyjnkh/9qTWWCLpdwWg5KRI/q/m76RZOJgx9vv8G/ASXd4cppOotj6Zu052zuZEk0dZpQ2thXugcirDNw9k1sN7Wfx1OkCrfwHf6C6PMcm/JeoFweu+FZ+5cs7a8rvmRZKxSnhQkkZLUTOAgwf2VvKtRt3O740j+67i2pdNMLEro8DyYZ7kBPTTQEdc0qLTm1UFuqX9tlJoaYRz+ISIZeSFe5fc1VYzIl3Q8JJ08iHvY3OSvEKw+gCWMvxe58zAHFS9gOX5BTo+AA2RvBW8TwXtftbXaaVwaW8Jcxv63UeGa7xldoPZ6jOvHQlBGCF4VaPAodXVP+Bdz1imHnFHNf07qhOHxWSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

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

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 cgroup_v2_allocation_failure.c | 169 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/cgroup_v2_allocation_failure.c b/cgroup_v2_allocation_failure.c
new file mode 100644
index 0000000000000..1a813678d8cd2
--- /dev/null
+++ b/cgroup_v2_allocation_failure.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0
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
+static void write_file_val(const char *path, const char *val)
+{
+	int fd = open(path, O_WRONLY);
+
+	if (fd < 0) {
+		fprintf(stderr, "Failed to open %s: %s\n", path, strerror(errno));
+		exit(1);
+	}
+	if (write(fd, val, strlen(val)) < 0) {
+		fprintf(stderr, "Failed to write %s to %s: %s\n", val, path, strerror(errno));
+		close(fd);
+		exit(1);
+	}
+	close(fd);
+}
+
+static int is_hugetlb_accounting_enabled(void)
+{
+	char spec[256], file[256], type[256], opts[512];
+	char line[1024];
+	int enabled = 0;
+	FILE *fp;
+
+	fp = fopen("/proc/mounts", "r");
+	if (!fp) {
+		perror("fopen /proc/mounts");
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (sscanf(line, "%255s %255s %255s %511s", spec, file, type, opts) == 4) {
+			if (strcmp(file, CGROUP_PATH) == 0 && strcmp(type, "cgroup2") == 0) {
+				if (strstr(opts, "memory_hugetlb_accounting") != NULL)
+					enabled = 1;
+				break;
+			}
+		}
+	}
+	fclose(fp);
+	return enabled;
+}
+
+static int enable_hugetlb_accounting(void)
+{
+	int ret;
+
+	printf("Attempting to remount cgroup2 with memory_hugetlb_accounting...\n");
+	ret = system("mount -o remount,memory_hugetlb_accounting " CGROUP_PATH);
+	if (ret != 0) {
+		fprintf(stderr, "Failed to remount: system() returned %d\n", ret);
+		return -1;
+	}
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct stat st;
+	size_t size;
+	void *addr;
+	pid_t pid;
+	int enabled;
+	int status;
+	int fd;
+
+	if (stat(CGROUP_PATH, &st) != 0 || !S_ISDIR(st.st_mode)) {
+		fprintf(stderr, "cgroup v2 not mounted at %s\n", CGROUP_PATH);
+		return 1;
+	}
+
+	enabled = is_hugetlb_accounting_enabled();
+	if (enabled < 0)
+		return 1;
+
+	if (!enabled) {
+		if (enable_hugetlb_accounting() != 0) {
+			fprintf(stderr, "Could not enable memory_hugetlb_accounting\n");
+			return 1;
+		}
+		/* Re-check */
+		enabled = is_hugetlb_accounting_enabled();
+		if (enabled <= 0) {
+			fprintf(stderr, "Failed to enable memory_hugetlb_accounting (re-check failed)\n");
+			return 1;
+		}
+		printf("Successfully enabled memory_hugetlb_accounting\n");
+	} else {
+		printf("memory_hugetlb_accounting is already enabled\n");
+	}
+
+	/* Enable memory controller in subtree */
+	fd = open(CGROUP_PATH "/cgroup.subtree_control", O_WRONLY);
+	if (fd >= 0) {
+		(void)write(fd, "+memory", 7);
+		close(fd);
+	}
+
+	if (mkdir(TEST_CGROUP_PATH, 0755) != 0) {
+		if (errno != EEXIST) {
+			perror("mkdir test_reproducer");
+			return 1;
+		}
+	}
+
+	/* Set memory limit to 1MB (less than 2MB hugepage) */
+	write_file_val(TEST_CGROUP_PATH "/memory.max", "1M");
+
+	pid = fork();
+	if (pid < 0) {
+		perror("fork");
+		return 1;
+	}
+
+	if (pid == 0) {
+		/* Child: Move to cgroup */
+		write_file_val(TEST_CGROUP_PATH "/cgroup.procs", "0");
+
+		printf("Child: Attempting to allocate and touch 2MB hugepage...\n");
+		/* Allocate 2MB hugepage */
+		size = 2 * 1024 * 1024;
+		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+		if (addr == MAP_FAILED) {
+			perror("Child: mmap MAP_HUGETLB");
+			exit(1);
+		}
+
+		printf("Child: mmap succeeded at %p, touching it now...\n", addr);
+		*(char *)addr = 1;
+
+		printf("Child: Successfully touched page (bug not triggered?).\n");
+		munmap(addr, size);
+		exit(0);
+	}
+
+	/* Parent */
+	waitpid(pid, &status, 0);
+
+	printf("Parent: Child exited. Cleaning up.\n");
+	rmdir(TEST_CGROUP_PATH);
+
+	if (WIFSIGNALED(status)) {
+		printf("Parent: Child killed by signal %d (%s)\n",
+		       WTERMSIG(status), strsignal(WTERMSIG(status)));
+		if (WTERMSIG(status) == SIGBUS)
+			printf("Parent: Child got SIGBUS as expected.\n");
+	} else if (WIFEXITED(status)) {
+		printf("Parent: Child exited with status %d\n", WEXITSTATUS(status));
+	}
+
+	return 0;
+}

-- 
2.55.0.229.g6434b31f56-goog



