Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C2AC87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 02:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7276B008A; Fri, 25 Jul 2025 22:52:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7ECC6B008C; Fri, 25 Jul 2025 22:52:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CD96B0092; Fri, 25 Jul 2025 22:52:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B65EC6B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 22:52:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82946140950
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:35 +0000 (UTC)
X-FDA: 83704892670.04.9E85689
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id A33A8120007
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:52:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fml9um8i;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753498353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=KKpl8DqiU4T+LlwO/dmHQhI3ixta3VqtYXolbjdyqb0=;
	b=DAuURzUTFt+eQR2H69ocqCDJSRseIChN1dC9N/F6tqXSzqAYMSm68VSu5lY7QNatnKHJgL
	J4cm8FNTKf+it+vW69cJ5a0S7oMkLoQQgZrp+gSyZrBwAwsHTbqo6jA9bZMS8ED3raPhdP
	9JXfX7jw4/o4vJaoWIZPRNf7h5Oib3o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fml9um8i;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753498353; a=rsa-sha256;
	cv=none;
	b=JbKnfwWPixS6ZP6GJUe75/Ql2PW/sf/KAyZC7TBd7q0LRHBQ16F5ze4BL+/g8z8xTqwdkh
	wkjkf5M8b1f4R7m0bEvcoWF8BjhYLAT3AGaW9kT/63Ua6wfndtHW4om3t5u/yxwuK0RUyv
	IFXJr9R5FWuan6flXyxd+g8qncVxkFo=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6088d856c6eso5235905a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 19:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753498352; x=1754103152; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KKpl8DqiU4T+LlwO/dmHQhI3ixta3VqtYXolbjdyqb0=;
        b=fml9um8isJI3oiqsWRxNuIqhK+qJFktgtFdsRwLdOvcE9B19bybWlxA5Eq2eGcUijH
         rYkUvcSFcI4aF23KlDUDzjWtdvXl8KxXVrQE61gL7BGv33452qqx6bnr0RxgZhDSCRfw
         27CC9pOtuiKz+/nphbD1LGCNgG3k2feUNgWlKp1PaMitsnuEUfcam57ubUcxJB1QYcHK
         xpQQaRUq5FN5wm/f5vn3zaQA2ZJtQgJ0Adv5CHLnlBAVcRyJC4yYpLTQHqUrIO9H/pFO
         1R6+UN/hyEqHVeOwjnTRjczHhvWFDCqzwgSf7WskkLOdo51mrDHh1I6u97XadGHwxROF
         EfJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753498352; x=1754103152;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KKpl8DqiU4T+LlwO/dmHQhI3ixta3VqtYXolbjdyqb0=;
        b=les9Lf6t7Lv6zvwT/RPAdGHheiN01/QbLhGQ+9lvwpz7EsOLf5i/AS5KdFiThavtDB
         Nmid1PKXv6pj6i2/9OmFldEt1B5D8e+MmnLkRJX11MMfvY/PbBzFIQXdtYVkzlMSxCrA
         xYUQpPBd93ht+raQ8qZ8DohwQT6n8WgfWV2IQxNojx0SSOCJlIXk9SvAP4wBHMUReU0o
         xryyE61WQlD5hHzTVeJlFiOcBnIfqUpiok4O62HaGxdCdt3UcpnKgJKg9JgilRUezSdw
         0aryc/6qfpjf2gL4ZUHh5T7RgzmUi0ulZiR3rSPCiCYXBd6rgBDfF7lVSQJiXM5vrTPs
         Gp/A==
X-Gm-Message-State: AOJu0YypMdLd8/VscMFC7HeIMdidh+ao/VzSqjv1pj/UEU80P+ACQENO
	atrmw5TRGHlb1AkWT6v7rUC1xN5GUlwd68lwVsrwDJkoc8Mk3XKaOpeh
X-Gm-Gg: ASbGnctOVUT5FPUApZldl5gmeRdI01fcDLEjVKQZCumrZRc2QvN7egYqFDLprJDPtc1
	j0rt+LXycKYPTmqyJPU3Hqh1BxITXJG0ACCf64kvyUZb16DP4ANaj6QSRdOqMIeg2WoiKvagOTf
	er/5sptks9lVfcfPnlf+1fFZtMwUtUqquT2t+cooqSSUlSKsZA4uxJnEfiRYSZoFsAhtpHBTWZI
	vxYO9FyZjqqZhxDxE7XuFnzHyka2n1G4c48e00w6ercml0Kj5gignLW5lkP+rElL9q1JZnxhqRD
	MIQ8jWN9JGASw0oZeqSYDVX4/HG+XOmLF2x5vcRJiqVIMLYM97QtHZtzNfyh8hV4vbGJroqL/Z1
	vKazfPwSvO2Z85b2+uzvSNheImm1mx92r
X-Google-Smtp-Source: AGHT+IF8KhyQxbprDVAFo9KawNJm0w13UiTXc3MbdfGOVcoEHesE6NlpdGn0PKRQnYaOjcJ6b6+d6Q==
X-Received: by 2002:a17:907:d78b:b0:ae0:660f:2b15 with SMTP id a640c23a62f3a-af61a0fa8d6mr445595166b.60.1753498351581;
        Fri, 25 Jul 2025 19:52:31 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af635860023sm77809566b.22.2025.07.25.19.52.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 25 Jul 2025 19:52:31 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [Patch v2 2/2] selftests/mm: assert rmap behave as expected
Date: Sat, 26 Jul 2025 02:52:23 +0000
Message-Id: <20250726025223.350-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250726025223.350-1-richard.weiyang@gmail.com>
References: <20250726025223.350-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A33A8120007
X-Rspamd-Server: rspam06
X-Stat-Signature: 13s3oikfexqk49qr3mm9k143j1kawobn
X-HE-Tag: 1753498353-272724
X-HE-Meta: U2FsdGVkX19yWA0brHzTeOE4LR1l91iX/gX1snz3Nk6wzyx3f1kcqqHVsmlhUduhuFHxe4THbhFTGjD2F6ZgYypqsiT2xoUnDUYGoNTPZCg27pa7amzQynuCbQqSCO76ADgDkJwv02TkoPC1Ty+sjg7lZbjkvfRHZ69oosLrIdeokZR5DZU88cZyJEVtsBM9KLCQ6s5qNhsMr4AyAVY1o1RnS3b9v7NZnhxPkUwIXerI7zS8zWPlMCiQ0Qahj1eYxHOcFzn7lUlyTCsSVM4Z+PHzMRobbm60AZradczzehVg4lj6HO3EPzGmphJhVpmv9o+PY7V7qxn6py2LLaTioKOJncEM/R6MKHjQZtsHPoGUt4vF/k3UkNlvyTJFDVtc7Uqf65VVfTmJmWOd23eTrM3ZkURxSXTw2F5AIMRlZoUls28RaF9FcbhvSqyYzaLNSd75n+9ouhI/b93EtaUEsuPCxjY1SFY9N7xXNzPrwyPLtXWVL/mAzIRAKZ593DX6S0cLIPOwvn0yHGO0jEcguEUuQsFvPDmGRM8G0UKy8Fl7mBQ3QW+ioVQBfFDgdANW3eBfUwI6hlsrT1BsLbXmpSXRdlL7D9Kp83D2aExwhhmJFESjbf1k8O3YFauF9VRTWAVFCNrWbKNWeY5Q4QyuQEnlvsRkXm7SasjIsFDQhc6aqNEJVAWFhdMb8GSBhhxu6A+bDlattFvS2dHRPs3N0+7kKVRv4Am15auPEh0jZ2WWpDM1iexl5rbDEOuDGoR0QmUhBD22oTxcNphtHBf31oetcriSsM0BvWOysvMnNsRptGGGYvBy6twbz41zgbTWMusRshD+heHl3iNvAgkkDjjLzboC8tYTpQh8BE7fN+2HzAqYX+fz65r8SN54Nxreqk8YXVGgc9sifSKkhxdxMFp5Q3kwqD3zJ2Z/fnhPYddDZeFTK1apdE/G3/xmGUoRG/ZJr8iWSXEMMrZwoCN
 vZU6ramU
 M2cfT93E74hIL0P/koLn0757/AJWkI4jjA4pFRyvl3QEaZxhC2m6mrrUVlY1NrMVFNjeHLQS85w15rQTrFMO8fu4GOZX6Y1s+C8phVJxvsp+wt4yRFHYgxMYIrvfxmKoAeg6pnhswTeBU/cI5UX0M6HlUbN2A6RgftmfJ2oKiFa3boZKDmixUYQtAVY90rVUT/57C2mN8luLjq0sZOaKXWzYgouh+SyWpMLWFpzLzneOb4+JEqajWyd6RpsERcMvbxR9ksjbJLImYiR0Mux9RyUmSZ0+oFWoh17RKUmICuW2Z2sLtlRZ6BH1gH4QtIQ9GJU6s6HFtx3R1gV9xeWZFAzmcomKFpFuIBafkRcp4HUdGel7CnikcEvll3ZFOsS/OuqxKWpTo525+boy/JoZRM8rEwO0RBAJoCRLy6Gs43W+JdqE3UxvMtiNJy3s7pgKoY+uvPGKPKcllOuejHW+HyqrfzupWXwh++46X/InELMEClDG5K4YON8JGLhHrzr77kAigXKPIqGWE9YO9uWCi6QTa0l5uFmUqJ+v9zjbeS5S2mu6Z9ykmRSaCP4eZbDQTqHD/W2CSrRWOxzdqi+UYQGuOFA9ECifdNYDGJOPyz4P7jjMjnCbj2KQNy9m61kQcfqO8lgjXg7jLb5ClG+09cQxBzYH6oU1r98WuffKE4DocFKdUmEScr7OKxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As David suggested, currently we don't have a high level test case to
verify the behavior of rmap. This patch introduce the verification on
rmap by migration.

The general idea is if migrate one shared page between processes, this
would be reflected in all related processes. Otherwise, we have problem
in rmap.

Currently it covers following four scenarios:

  * anonymous page
  * shmem page
  * pagecache page
  * ksm page

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>

---
v2:
  * skip instead of assert if numa not available
  * check ksm sys file before continue
  * use private anonymous map instead of shared map
  * check pfn instead of content
  * retry migrate
  * fault in region for each process by FORCE_READ()
  * behave -> behaves
v1: fault in region by just accessing it instead of print it
---
 MAINTAINERS                               |   1 +
 tools/testing/selftests/mm/.gitignore     |   1 +
 tools/testing/selftests/mm/Makefile       |   3 +
 tools/testing/selftests/mm/rmap.c         | 432 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   4 +
 5 files changed, 441 insertions(+)
 create mode 100644 tools/testing/selftests/mm/rmap.c

diff --git a/MAINTAINERS b/MAINTAINERS
index bf38917addda..3c6cbdd88720 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15970,6 +15970,7 @@ S:	Maintained
 F:	include/linux/rmap.h
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
+F:	tools/testing/selftests/mm/rmap.c
 
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index e7b23a8a05fe..92af0ae0fa7f 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+rmap
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d13b3cef2a2b..d4f19f87053b 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -101,6 +101,7 @@ TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
+TEST_GEN_FILES += rmap
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -228,6 +229,8 @@ $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
 $(OUTPUT)/migration: LDLIBS += -lnuma
 
+$(OUTPUT)/rmap: LDLIBS += -lnuma
+
 local_config.mk local_config.h: check_config.sh
 	/bin/sh ./check_config.sh $(CC)
 
diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
new file mode 100644
index 000000000000..ae9373782972
--- /dev/null
+++ b/tools/testing/selftests/mm/rmap.c
@@ -0,0 +1,432 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * RMAP functional tests
+ *
+ * Author(s): Wei Yang <richard.weiyang@gmail.com>
+ */
+
+#include "../kselftest_harness.h"
+#include <strings.h>
+#include <pthread.h>
+#include <numa.h>
+#include <numaif.h>
+#include <sys/mman.h>
+#include <sys/prctl.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <time.h>
+#include <sys/sem.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "vm_util.h"
+
+#define TOTAL_LEVEL 5
+#define MAX_CHILDREN 3
+
+#define FAIL_ON_CHECK	(1 << 0)
+#define FAIL_ON_WORK	(1 << 1)
+
+struct sembuf sem_wait = {0, -1, 0};
+struct sembuf sem_signal = {0, 1, 0};
+
+enum backend_type {
+	ANON,
+	SHM,
+	NORM_FILE,
+};
+
+#define PREFIX "kst_rmap"
+#define MAX_FILENAME_LEN 256
+const char *suffixes[] = {
+	"",
+	"_shm",
+	"_file",
+};
+
+struct global_data;
+typedef int (*work_fn)(struct global_data *data);
+typedef int (*check_fn)(struct global_data *data);
+typedef void (*prepare_fn)(struct global_data *data);
+
+struct global_data {
+	int worker_level;
+
+	int semid;
+	int pipefd[2];
+
+	unsigned int mapsize;
+	unsigned int rand_seed;
+	char *region;
+
+	prepare_fn do_prepare;
+	work_fn do_work;
+	check_fn do_check;
+
+	enum backend_type backend;
+	char filename[MAX_FILENAME_LEN];
+
+	unsigned long *expected_pfn;
+};
+
+/*
+ * Create a process tree with TOTAL_LEVEL height and at most MAX_CHILDREN
+ * children for each.
+ *
+ * It will randomly select one process as 'worker' process which will
+ * 'do_work' until all processes are created. And all other processes will
+ * wait until 'worker' finish its work.
+ */
+void propagate_children(struct __test_metadata *_metadata, struct global_data *data)
+{
+	pid_t root_pid, pid;
+	unsigned int num_child;
+	int status;
+	int ret = 0;
+	int curr_child, worker_child;
+	int curr_level = 1;
+	bool is_worker = true;
+
+	root_pid = getpid();
+repeat:
+	num_child = rand_r(&data->rand_seed) % MAX_CHILDREN + 1;
+	worker_child = is_worker ? rand_r(&data->rand_seed) % num_child : -1;
+
+	for (curr_child = 0; curr_child < num_child; curr_child++) {
+		pid = fork();
+
+		if (pid < 0) {
+			perror("Error: fork\n");
+		} else if (pid == 0) {
+			curr_level++;
+
+			if (curr_child != worker_child)
+				is_worker = false;
+
+			if (curr_level == TOTAL_LEVEL)
+				break;
+
+			data->rand_seed += curr_child;
+			goto repeat;
+		}
+	}
+
+	if (data->do_prepare)
+		data->do_prepare(data);
+
+	close(data->pipefd[1]);
+
+	if (is_worker && curr_level == data->worker_level) {
+		/* This is the worker process, first wait last process created */
+		char buf;
+
+		while (read(data->pipefd[0], &buf, 1) > 0)
+			;
+
+		if (data->do_work)
+			ret = data->do_work(data);
+
+		/* Kick others */
+		semctl(data->semid, 0, IPC_RMID);
+	} else {
+		/* Wait worker finish */
+		semop(data->semid, &sem_wait, 1);
+		if (data->do_check)
+			ret = data->do_check(data);
+	}
+
+	/* Wait all child to quit */
+	while (wait(&status) > 0) {
+		if (WIFEXITED(status))
+			ret |= WEXITSTATUS(status);
+	}
+
+	if (getpid() == root_pid) {
+		if (ret & FAIL_ON_WORK)
+			SKIP(return, "Failed in worker");
+
+		ASSERT_EQ(ret, 0);
+	} else {
+		exit(ret);
+	}
+}
+
+FIXTURE(migrate)
+{
+	struct global_data data;
+};
+
+FIXTURE_SETUP(migrate)
+{
+	struct global_data *data = &self->data;
+
+	if (numa_available() < 0)
+		SKIP(return, "NUMA not available");
+	if (numa_bitmask_weight(numa_all_nodes_ptr) <= 1)
+		SKIP(return, "Not enough NUMA nodes available");
+
+	data->mapsize = getpagesize();
+
+	data->expected_pfn = mmap(0, sizeof(unsigned long),
+				PROT_READ | PROT_WRITE,
+				MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(data->expected_pfn, MAP_FAILED);
+
+	/* Prepare semaphore */
+	data->semid = semget(IPC_PRIVATE, 1, 0666 | IPC_CREAT);
+	ASSERT_NE(data->semid, -1);
+	ASSERT_NE(semctl(data->semid, 0, SETVAL, 0), -1);
+
+	/* Prepare pipe */
+	ASSERT_NE(pipe(data->pipefd), -1);
+
+	data->rand_seed = time(NULL);
+	srand(data->rand_seed);
+
+	data->worker_level = rand() % TOTAL_LEVEL + 1;
+
+	data->do_prepare = NULL;
+	data->do_work = NULL;
+	data->do_check = NULL;
+
+	data->backend = ANON;
+};
+
+FIXTURE_TEARDOWN(migrate)
+{
+	struct global_data *data = &self->data;
+
+	if (data->region != MAP_FAILED)
+		munmap(data->region, data->mapsize);
+	data->region = MAP_FAILED;
+	if (data->expected_pfn != MAP_FAILED)
+		munmap(data->expected_pfn, sizeof(unsigned long));
+	data->expected_pfn = MAP_FAILED;
+	semctl(data->semid, 0, IPC_RMID);
+	data->semid = -1;
+
+	close(data->pipefd[0]);
+
+	switch (data->backend) {
+	case ANON:
+		break;
+	case SHM:
+		shm_unlink(data->filename);
+		break;
+	case NORM_FILE:
+		unlink(data->filename);
+		break;
+	}
+}
+
+void access_region(struct global_data *data)
+{
+	/*
+	 * Force read "region" to make sure page fault in.
+	 */
+	FORCE_READ(data->region);
+}
+
+int try_to_move_page(char *region)
+{
+	int ret;
+	int node;
+	int status = 0;
+	int failures = 0;
+
+	ret = move_pages(0, 1, (void **)&region, NULL, &status, MPOL_MF_MOVE_ALL);
+	if (ret != 0) {
+		perror("Failed to get original numa");
+		return FAIL_ON_WORK;
+	}
+
+	/* Pick up a different target node */
+	for (node = 0; node <= numa_max_node(); node++) {
+		if (numa_bitmask_isbitset(numa_all_nodes_ptr, node) && node != status)
+			break;
+	}
+
+	if (node > numa_max_node()) {
+		ksft_print_msg("Couldn't find available numa node for testing\n");
+		return FAIL_ON_WORK;
+	}
+
+	while (1) {
+		ret = move_pages(0, 1, (void **)&region, &node, &status, MPOL_MF_MOVE_ALL);
+
+		/* migrate successfully */
+		if (!ret)
+			break;
+
+		/* error happened */
+		if (ret < 0) {
+			ksft_perror("Failed to move pages");
+			return FAIL_ON_WORK;
+		}
+
+		/* migration is best effort; try again */
+		if (++failures >= 100)
+			return FAIL_ON_WORK;
+	}
+
+	return 0;
+}
+
+int move_region(struct global_data *data)
+{
+	int ret;
+	int pagemap_fd;
+
+	ret = try_to_move_page(data->region);
+	if (ret != 0)
+		return ret;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_WORK;
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+
+	return 0;
+}
+
+int has_same_pfn(struct global_data *data)
+{
+	unsigned long pfn;
+	int pagemap_fd;
+
+	if (data->region == MAP_FAILED)
+		return 0;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_CHECK;
+
+	pfn = pagemap_get_pfn(pagemap_fd, data->region);
+	if (pfn != *data->expected_pfn)
+		return FAIL_ON_CHECK;
+
+	return 0;
+}
+
+TEST_F(migrate, anon)
+{
+	struct global_data *data = &self->data;
+
+	/* Map an area and fault in */
+	data->region = mmap(0, data->mapsize, PROT_READ | PROT_WRITE,
+				MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(data->region, MAP_FAILED);
+	memset(data->region, 0xcf, data->mapsize);
+
+	data->do_prepare = access_region;
+	data->do_work = move_region;
+	data->do_check = has_same_pfn;
+
+	propagate_children(_metadata, data);
+}
+
+TEST_F(migrate, shm)
+{
+	int shm_fd;
+	struct global_data *data = &self->data;
+
+	snprintf(data->filename, MAX_FILENAME_LEN, "%s%s", PREFIX, suffixes[SHM]);
+	shm_fd = shm_open(data->filename, O_CREAT | O_RDWR, 0666);
+	ASSERT_NE(shm_fd, -1);
+	ftruncate(shm_fd, data->mapsize);
+	data->backend = SHM;
+
+	/* Map a shared area and fault in */
+	data->region = mmap(0, data->mapsize, PROT_READ | PROT_WRITE,
+				MAP_SHARED, shm_fd, 0);
+	ASSERT_NE(data->region, MAP_FAILED);
+	memset(data->region, 0xcf, data->mapsize);
+	close(shm_fd);
+
+	data->do_prepare = access_region;
+	data->do_work = move_region;
+	data->do_check = has_same_pfn;
+
+	propagate_children(_metadata, data);
+}
+
+TEST_F(migrate, file)
+{
+	int fd;
+	struct global_data *data = &self->data;
+
+	snprintf(data->filename, MAX_FILENAME_LEN, "%s%s", PREFIX, suffixes[NORM_FILE]);
+	fd = open(data->filename, O_CREAT | O_RDWR | O_EXCL, 0666);
+	ASSERT_NE(fd, -1);
+	ftruncate(fd, data->mapsize);
+	data->backend = NORM_FILE;
+
+	/* Map a shared area and fault in */
+	data->region = mmap(0, data->mapsize, PROT_READ | PROT_WRITE,
+				MAP_SHARED, fd, 0);
+	ASSERT_NE(data->region, MAP_FAILED);
+	memset(data->region, 0xcf, data->mapsize);
+	close(fd);
+
+	data->do_prepare = access_region;
+	data->do_work = move_region;
+	data->do_check = has_same_pfn;
+
+	propagate_children(_metadata, data);
+}
+
+void prepare_local_region(struct global_data *data)
+{
+	/* Allocate range and set the same data */
+	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
+			   MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		return;
+
+	memset(data->region, 0xcf, data->mapsize);
+}
+
+int merge_and_migrate(struct global_data *data)
+{
+	int pagemap_fd;
+	int ret = 0;
+
+	if (data->region == MAP_FAILED)
+		return FAIL_ON_WORK;
+
+	ksm_start();
+
+	ret = try_to_move_page(data->region);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_WORK;
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+
+	return ret;
+}
+
+TEST_F(migrate, ksm)
+{
+	int ret;
+	struct global_data *data = &self->data;
+
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\") failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\") failed");
+
+	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (ret < 0 && errno == EINVAL)
+		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
+	else if (ret)
+		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");
+
+	data->do_prepare = prepare_local_region;
+	data->do_work = merge_and_migrate;
+	data->do_check = has_same_pfn;
+
+	propagate_children(_metadata, data);
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 471e539d82b8..75b94fdc915f 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -85,6 +85,8 @@ separated by spaces:
 	test handling of page fragment allocation and freeing
 - vma_merge
 	test VMA merge cases behave as expected
+- rmap
+	test rmap behaves as expected
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
@@ -532,6 +534,8 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh aligned
 
 CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
+CATEGORY="rmap" run_test ./rmap
+
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
-- 
2.34.1


