Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8898ECA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DBD6B010F; Tue, 19 Aug 2025 04:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FAE6B0110; Tue, 19 Aug 2025 04:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12C486B0111; Tue, 19 Aug 2025 04:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA5AB6B010F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:01:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF2901402C0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:26 +0000 (UTC)
X-FDA: 83792762172.20.8E77F8A
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAA1F20004
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hGtlXc5R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590484; a=rsa-sha256;
	cv=none;
	b=aJzYWROehHZkhfKFK06x1AUzbq8Na2LUqxydQbxgE5bAJvihHLSrFnwjo8RJ8hy9Y45hmG
	QpcQgegYTnQaRQvFPFPmeUDfs9ezCLw5iRJikl10SPP4+JOJcXYs8uZQDp+J3N+xC5X9r7
	QfH9FS3vGFZfHM9LTuCCG/xusgdsu+4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hGtlXc5R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CsmTiTkptP99n7HLZ1jhOD2kv455+wPrtctEKZvu8rM=;
	b=46eipyMv+aLXnKkrXsB9L4R4e5yQ9zaJXMHTMVdokC+ZDm4G0aMFT0GNoJhCb8xA2zrPOD
	zwWKn0z3V77Ugu5LyLcuswwqKfFWSL8JJ6XBOOliFK5NT/GlGd33LxPrWJfCwvap6KuF03
	aar2px0vjmIVSiXROk8ZfoLvh12oHGk=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-61868d83059so9646173a12.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755590483; x=1756195283; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CsmTiTkptP99n7HLZ1jhOD2kv455+wPrtctEKZvu8rM=;
        b=hGtlXc5RS5GA3tzys/LyFXfQSTCkyG3YtuHtBtSTyttJqavYOIZMI0rjbffA4RagFH
         HnXqnmLQZVHH1sKzg4EHmBRFkVolv1bjPOVz0XCl2brAH300me3MgRbqkrfy7EUbBM//
         uiDOFVUsd9V4Cr03xd8AYFtCUEjhsP+Lf1ndp2qrAucXY8mXGWdrIKCkwqhyqhrJdYml
         xUE0VkdrZBxxyAohvxMi4J9XMnDJRJ56L9yeyfOjfubFZB8XD5VtsFeCB8LPN0vbDg3y
         8lx4079bnO9gTAl6qZcGYeJiDSkTObt6kJkDvbzqigoJB0Ywb6Z9Zf4/QoSWxRk6HC5l
         Lv1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755590483; x=1756195283;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsmTiTkptP99n7HLZ1jhOD2kv455+wPrtctEKZvu8rM=;
        b=CHiV+3Hv8KgUUv8+CuMlwik4xTryN7R9S3wWwe9Gzo4pLQWA1GUnGv9OUr84juTa++
         vl39S0FhycWz0zDD32+8TYLekZjvIfD4d+TTE9Z/Iu6OWpfpEbfcu2Aa4pTEFyKUNZu+
         i1KNefiXXbHOmoMTyY3aLf4GALddyXEY7Plb9LH8fpOIeclFZaoMde89bmajXiH5INEL
         MjztVxVWatPjjksRmTGpHb+RrXIvGPUCIh99t84MwamINuyjSAHfoytnJEHw22GPvy01
         JhSczjrCZeX7WEjLc7YjKf9wzi7h0DwJi55RWdqri6jgeb9/wEX3CjLipJz6YKAuaqIs
         idIw==
X-Gm-Message-State: AOJu0YwGLe5orj+CdRynFz2iiMqFVnRk6FJ1FFk6fUIk3E9e3yEB1Mhy
	7Vfh28mZpNIioZrkWTBs8Mt8ZtvNH9Z7rSw/c6BOCYQYpWhb+lt9keBGk2i0Ig==
X-Gm-Gg: ASbGnctEkTJiV4LpQ/4g6LC+1QaRmEmGb7F5TFAOaS5PrhrUrQsvDJc/hugYpK9CL0M
	gPL0mFifNMW3r4dKq7G6B1ajQqgz8Tv/XdTRsnXw0ylEOfxPT6CXg17jVsYY7DVIL0EnVfGtYL4
	Jfd4cEsY5W5ptGdYjz5GBb5ZDA4hzOeL8JAjteDE3b/gKRH+lnsAaYAbA0U9U4daW/+pnfj5kZ4
	Bt3UVelkk9BMVoMAjAk4d82p0zjfcNTf1SQWnh+1/EQwVkTLmYniomrHde6ZcZ/YQZDemGo6Pko
	4QLBn4/uYelbI82IR2ZJfvqDh2CqKJyF9zxNr1UpkWR4LLtqrPho0j0HIEJqljCDLVdUGfU+ngi
	y6JUBxUxhadBsh+8oqXarcQ==
X-Google-Smtp-Source: AGHT+IHzPuzmuRTq3VcCGcp1G2nwzCEHaW4T6A0wPWqHnU5RaaPIAhSqu7RITBdpJ6FM0lfsiWGJxg==
X-Received: by 2002:a05:6402:4545:b0:618:2533:f735 with SMTP id 4fb4d7f45d1cf-61a7fa3812amr982982a12.7.1755590483040;
        Tue, 19 Aug 2025 01:01:23 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61a755f8760sm1240748a12.15.2025.08.19.01.01.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 01:01:22 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	riel@surriel.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v4 2/2] selftests/mm: test that rmap behave as expected
Date: Tue, 19 Aug 2025 08:00:47 +0000
Message-Id: <20250819080047.10063-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250819080047.10063-1-richard.weiyang@gmail.com>
References: <20250819080047.10063-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: AAA1F20004
X-Stat-Signature: qs7s6yg9d5j4syh9bbk6x7ou4mmxytau
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755590484-594400
X-HE-Meta: U2FsdGVkX19eg90FFvC0b8EeSUpFZ4kQ5DPkIHIihObF1prgCntNfoyrJn+MjvLNVXHjbMg1jfAHiBE9tYXZ7Cy/rIBjhqumHItoXjdqNz9AoERZTJAzGzmEr9D0Q04qhwgObG6YYT26gRuBnKsiGYBtC3N1HAACGlffAxXN5/joclPg+iaumObYhACj6yKNzw/TQukciXOrOjh5yzUIykO7gQcdl3Jt3+Azw5wJEzZxufHAkopTQ/ox9yHAj8ttesIPwBwvx2/CHtAgd2uDdfoF4JyhldDkC7vrtdSryX9ctjSH/vBHtwDC53A6fwkCcwzoxlJw5/1ZmoBuveD+NvsEb2SZsVB0onsCLlChXH55C9m5PFiL0WaiGRqyB7Zw+8iXZ6cSj9IL/l7nMGE9VIH3py47/F+ZBJLb9tRZROSJ70JV8xfFdZMhlcRUjAUrYmzastzd/2aN3f8UhP/NesDpcm2bwf/bJg+6phCGsBGqb4gKc3CZnBcoqH2RDuchH1Hj8S2lc8hz++KGsMK9yCs3KPmC+fPVZ2iuKhlFLJDpgtfGS9VnfPk9WSza8odz0xvmQyZDpIGiMC/RKthBbKIZkM8nZK62LbwAc/ZKg+2mw70uur6wvba3OnRSoK8yf22l9unIs9LqLI5RAoE4d8182/+M4jkFaXAvkUEo6imYBeeyFN2h9pwhF8L1yAj4yZk+Xum0Wb04+Z8XZoZEkACIbHHk8NXFJKy5Ob/gtoCtrVfU/eP4dkGRRYi2TM4vxs2giF1EyXH9aYK7iRODhxkStHTdpECcLiJQ3ETnqFZ/1RdfKspPyqeEuJzsDJiX2oTk7dagh+Wq3iwshJ2Dfrrk80Ecm913uPYovCb9SAn3TMohY1qwZk+DUSllqp3qy6qlXoTo1+q166Iq4jpiiNGTvb/5qFCf86d6a46dI+vgq8hnPCtwK7RUw2eUQKjGODLwNtsU9cL/hzkB1xy
 8QnxHH23
 5FJd/jA7QQgQuGfrx8SabOSq+8P5z9S2bIRXX9ggkM1gP0hp+zfvB9QgddWjmbk+X97sfg5ZP+pX9NIcdazDIUUZZo1u2ds8AaCqZuL4B6sruzzKA+Y78TyG2HPSrP7fgSgWNadNKdpzn0y2Rza3o/fYmVQb4l4HLs3FiRlkHvECrpkw=
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
v4:
  * rebase on mm-new(dd1510cefdfe)
  * "assert" -> "test that" in subject
v3:
  * handle ksm failure in worker
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
 tools/testing/selftests/mm/rmap.c         | 433 ++++++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh |   4 +
 5 files changed, 442 insertions(+)
 create mode 100644 tools/testing/selftests/mm/rmap.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 390829ae9803..c0a4bda39f8e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16192,6 +16192,7 @@ S:	Maintained
 F:	include/linux/rmap.h
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
+F:	tools/testing/selftests/mm/rmap.c
 
 MEMORY MANAGEMENT - SECRETMEM
 M:	Andrew Morton <akpm@linux-foundation.org>
diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index eb023ea857b3..c2a8586e51a1 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -59,3 +59,4 @@ pkey_sighandler_tests_64
 guard-regions
 merge
 prctl_thp_disable
+rmap
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index bd5d17beafa6..810bd615b8c3 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -103,6 +103,7 @@ TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
+TEST_GEN_FILES += rmap
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -230,6 +231,8 @@ $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
 $(OUTPUT)/migration: LDLIBS += -lnuma
 
+$(OUTPUT)/rmap: LDLIBS += -lnuma
+
 local_config.mk local_config.h: check_config.sh
 	/bin/sh ./check_config.sh $(CC)
 
diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
new file mode 100644
index 000000000000..13f7bccfd0a9
--- /dev/null
+++ b/tools/testing/selftests/mm/rmap.c
@@ -0,0 +1,433 @@
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
+	FORCE_READ(*data->region);
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
+	if (ksm_start() < 0)
+		return FAIL_ON_WORK;
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


