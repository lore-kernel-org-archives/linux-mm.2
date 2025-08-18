Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23C8CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DB46B00AE; Sun, 17 Aug 2025 22:29:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 108A56B00AF; Sun, 17 Aug 2025 22:29:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4C66B00B0; Sun, 17 Aug 2025 22:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5FBC6B00AE
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:29:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9BD0E1A0805
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:28 +0000 (UTC)
X-FDA: 83788296816.24.D7E0231
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8823C0008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:29:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L9F9ZSnH;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Qwo4EvSaKVtxWlwvzyu407UTggYXnJoPLedJSXgskLw=;
	b=0WANdn24kb15wsfbMW5i6noIbYrRWIDILNxPew3CwySjRuRWiyp/x61JbXDoo3GZaf/N1t
	ohTbQg7pzyRIseaXlZI4Wb5zNgsiaG5P3DnIZLlbTHbOWTXkIzQ5C99CCmXHBfSeR18RPF
	DK+4W3Jbm3lB6feu94xMl/jjG+W6MSs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L9F9ZSnH;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484166; a=rsa-sha256;
	cv=none;
	b=PzF+GrlLEc1Hb+hhowVmKfEtpYqmnCBvKQQaGAlvK43diVDkz6vcug2lwnZBM/zUBDn0Y0
	UuX16RJCu6WAXZHdbyq/P8rvKXb8g+JogSeZGIAXBwTHc4aBQ3jJU+gN5uPUC818MRryo1
	4Ihn7WUZn7uvMrPei5dCBb48cgoWZ0o=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6197efa570eso3142392a12.1
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 19:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755484165; x=1756088965; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qwo4EvSaKVtxWlwvzyu407UTggYXnJoPLedJSXgskLw=;
        b=L9F9ZSnHwj4zCcx3STIqYE+CaKUC9lTv5ZXCkMyRxljQa0DtLcbkCcjenwSItH1jS5
         jb/pMy3lxljSwxuEDfPJuCgjjjNyMFUAFeNlCBq80RszVwCA2bEFd/OZ3iyhE795+1BP
         hyfUXbSIDxa3mKw88g/CNhLI6NByhaG9iRPATkfkkRfdaFROECtCLSND3bTJdFm2azfR
         yKVVRoCUHw1wrjSO8rsueajNzondKL9rSwp88WIZAwatVu/8Yj62LFo/eShyB6i0Z07E
         Um2jGVnF9jRiZU+faFUw6KFATB2blPc9nZtmdx+VcKF0DJEu74IL+UqTW4U5SJntotA2
         zBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755484165; x=1756088965;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qwo4EvSaKVtxWlwvzyu407UTggYXnJoPLedJSXgskLw=;
        b=R2oLPfP+TTZQCCP+KCmMy+HEha/syl9VmPjW5SUPENdQsncPLYoF6XyuVf/2Mp+hJg
         VyHZxi4U/J4X59k5/TCGQ6MYAUURviPfAbiiJHHSVyZsaMZ/HE3Tr/Elh9mz+L5pdTHh
         dyUuNaHzTjzOSJ1AuuJXgKUrhpmI/nWw6qyDhHeqA0166ZQjD4q2/1VSrWDccIqAws32
         UHLWPHbigqdNaiPt0ilDQvlaNWzfyd1aYkBnVAbOb4YV75zvGROGJs/n5/sLuejl70RC
         b3U88JipZnrlgspEMfWkhtqgrlAvqLCjUB4ozLUKllgtYeUJyQLw6Br9UW8AOIEOcgRe
         gqIA==
X-Gm-Message-State: AOJu0YyISKIUEROs3fdPsQTWH7t7YCFHDkISoqRTz2PW9BeWya++WZsi
	BIErNg9eH9Cu/qyBC5VCJSOypp6+ghlyGWRyPDkBmvp2b7sqwrJMoKj2
X-Gm-Gg: ASbGncsWKQ/ZUkAVDUOO8MisuLr9YS37neqlalX6yTIGIPwR7aXDmeAHVGgwFCG8zHN
	t0kVmE4qyMYqPhMz0LQwqH7y0sAaRwlfJRssQgC+LabOtBDVKSLN77MlUni8nJVFaRemyRks8mQ
	2S7HnNTgVDY1b2NuImVLa5o5Pa61NBTY3fCT1KzbvZiDM9xu963xzZJf9wqd68C2neWnUm6cL/D
	kOWMwYOJpbYlHbgAoOI053Um4tV1R2iF8mPkMwtgbNWFdOgxuT4LArTdMllSDpSn7UK3h6gP4d6
	MhrN3n+mSjPnDYFzQO52I+TsAE/EaWMHzKEixe09NPh9ezD+RV8/03XJJzNe7ppqjbFWCp5zxhv
	aYEIhz4daz6LKUx9+Of0zlw==
X-Google-Smtp-Source: AGHT+IHVh8tue+C1eIwBRg7SjuJPzgsjaqMdL1emRsyOkClQe9r5Z04vQX1onMb5dw8yd3T+j0YkSg==
X-Received: by 2002:a05:6402:848:b0:615:d142:70 with SMTP id 4fb4d7f45d1cf-619b707d164mr6191239a12.11.1755484165057;
        Sun, 17 Aug 2025 19:29:25 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af9da5d9sm6127914a12.16.2025.08.17.19.29.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 17 Aug 2025 19:29:24 -0700 (PDT)
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
Subject: [Patch v3 2/2] selftests/mm: assert rmap behave as expected
Date: Mon, 18 Aug 2025 02:29:05 +0000
Message-Id: <20250818022905.15428-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250818022905.15428-1-richard.weiyang@gmail.com>
References: <20250818022905.15428-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8823C0008
X-Stat-Signature: jhheif7rs5835q69dij3skfckng7ucua
X-Rspam-User: 
X-HE-Tag: 1755484166-363602
X-HE-Meta: U2FsdGVkX1+MPLpdOzClnAt7nXKMa0DFOftpoGCKWzTSSixTiylqyLcGl3jB44u/TPLuBtVp47u2Nda4SHtPo2kBVatSbETXCIzlUD/74CHI9zveYr2mPNLIKHYXSMQZiVrWW4hdjjwbhy0O1Avj8hkV7bQbdin1vwlbSDAD5PmTCOL4v7p10piM8964Mc5X01NeZn+KP1N1LvTG1XysXZBcycL3ClcUe/dV9pWK4K6WollwZ3p7Z0l+VHCy39YGbNtwSkhKq55ElBqdaE1Ed3DUO38yMtrQG7Nr7mymwMuO5yCccqnvYRx+889kIhuBVEVPjWJqEx7GeV0HImlI8UaurOQQq8hxmdpDi3Wa6KeKa2QhI3aOvf/8mbZRswXagyufR6pJHpC0MRGAKm+X07fs7SjpcD8LsS82t6hUUDkdvut5tiG+e42XL/wUKNHoYzgF3jCxqh1fTMEL5t/lJxrxI9oxyPKIPDYKMO357YaI4WoFfg6gqFokMEOqowtqkw62aWGNvhUiZGt06qcSlyNKQ/EYO/jN8a4NYovBhgfZ1+/u99C1FzP+VxuRy25J4C0dhg5/lqnmnzoDonIKn4FbEzLs2zmscRhxnc4ozoPvi5mFuw70jwnK8/HKWMONz6YYx6Dt9jLmIA0kn5hXUqRxB1QsThNfRR6JYrXyx0JjF4MF6cUI7yUqzrYx8cvGBEW4kxXKL5aweDjLEO0+b/6Wy+pQ9ZyAFCpuQe4xO2HdbmSr81IHKwouPVUsdMc+CgEpDBEkLWqm2roZ6T7J95aYHtTo4noJcnRfM4plnY5C6Yz/M/sX+4+itpyr4cjt3AXenWRW377ip9RZwp5YAxD3DUq1um1f9pcTefrnAAmOs6Q9RFEUdJrPN1Z20UEiK9nLS9LRrQsXnSkloft9hTtLhRCVCIpi4HnLB6DYgu5MVRffjThXODwzs4kDJU1fgHr9OZk/1zQKwZPRZuz
 fK8lDTvW
 Auk3/ExuHwDpMlz0z9khYW2WhNSJ1OtNlQU0WupY+ijfPUpftgmmHOZnhmxBzrZVMvzUqtCQ1Fd+F7/hAti9wzaBbqwsAjTwSBkOce3b8jhQ9+jl15HFlaAK52+fKOeJJDMvQdD2z0pQx+kQVTsxRVG1cYReVJjR2McCfXLewbz+8pa+KdrvloVaKl+Bkdb916oZZ1WoKoZ6KI6NdP8O+kbtBXAAuDwHSAx4CFt4hCU56bVz2eNU7DZU/FwfS61S4OZkn71dXT+G2PUt9bRFeYmNRTQCF0OLWJBR9dhYP9x4pJ0cIXrzCSRxXeStMYEsTIoXEbG+TLDbinArvIT5Y3+sJwbKcKu9QgcUwfPhP5fYu3c+MmEIaMoEEjP6pK5xZrCASHQsk5VsiJIgHctORLrYzjnySrpQE6N+5TlkTL8MvOQsrZT0dRolcw+Ef7RLGsNQoOM/0uOTV2P9JWR2ZrmPi+IAOOPIhNa3GWAA4vTJo8JqoJhUPXjYWhLLvDlIhJ80sVQ0DPZ+KBgAW2CyHdGTYpBn7vGYa08QoQ9UTKp6XJMOhyatPyRkrcEguY0LRREOrNn4jqJ+3pn87xPo85QFZdk+XvdfnQATPD5O+C5RPxmdWKD5Bn/f85UZ+6xBb+daPs3HdSsLBTLzM5N+fvyIGPg2Y9tUBbW2CLXEasCNrlcqkUYpxeozDJA==
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
index e7b23a8a05fe..92af0ae0fa7f 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -58,3 +58,4 @@ pkey_sighandler_tests_32
 pkey_sighandler_tests_64
 guard-regions
 merge
+rmap
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index d75f1effcb79..1a156637207f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -102,6 +102,7 @@ TEST_GEN_FILES += hugetlb_dio
 TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
+TEST_GEN_FILES += rmap
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
@@ -229,6 +230,8 @@ $(OUTPUT)/ksm_tests: LDLIBS += -lnuma
 
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


