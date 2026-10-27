Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FCE606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=jgFfNHb7
Received: by kanga.kvack.org (Postfix)
	id D5CCB6B05B0; Mon, 26 Oct 2026 23:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34A46B05B1; Mon, 26 Oct 2026 23:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23C46B05B2; Mon, 26 Oct 2026 23:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3AD6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:34:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96DA5120644
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:34:34 +0000 (UTC)
X-FDA: 85366988868.07.D49C31C
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id BBBEF1C0005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:34:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jgFfNHb7;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793072072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJLvmVV2iFndDkwChBmGVao/pICrf/b8G6/BBv8WQzs=;
	b=4ClKueVs/wgyOQBzOdJ5OKItPb4LXBpsqw0vjkY1/iBV1KUQXYiSWB2zNK3sY+hsjg8cwl
	sRL+JZdHlxySk7zWsc2w709FXgH4z+JWYVrD8+PItnqIbgFnlm2iT0vUTTbtBCoC4vJb8v
	xOYGKhykBRXT+06J/ycr4rVigDLjeJs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jgFfNHb7;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.218.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793072072;
	b=OVpo4s9DDuxEZzUAUOryPg1jDzI5VLOGROmwoZbOCJg1r02B8kh4VSM/ZhZNVGkIXN3zbs
	53KnlZY+3kv+I+jch/OusLPIFE8SBFRWWM+zZNRCzaOSrgyRsZ6Dp49qiuJnwGR2smX+sj
	7C6XNtr89to/6W4+QQXieJJSFnibsvI=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c169ae1cb26so78221166b.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793072071; x=1793676871; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JJLvmVV2iFndDkwChBmGVao/pICrf/b8G6/BBv8WQzs=;
        b=jgFfNHb7wH8Y6l5IV4LulMDLibZWFlMaQaIOD7mvCQyPSDj6JYs3bia99UUSvCwa6V
         Gqz0Kp1Z+SKNorzkDcqFpsbCpajZMJXC9PL5NUFVFAC8ImplTgz/7w3nLdIhFT+nsixc
         AVlZsRbxc+xSyu9ciJo20pdiO6aZ0lv3e70QGnpx1eLuZwZRqcBSOk1G9ZRfY77gZLG7
         Rz6KzotkpDeejyh5RPf9HFvrOCpe206naDH+nWgHK3xmBU1de1cb5iNhKAXf6rZh8sP3
         9riqRc1TqerQLsKFDkPikIACE5nz9BT6wTaHPIPbpazuieFWzTEFqzsMIL78wGgCAI+T
         Z1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793072071; x=1793676871;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JJLvmVV2iFndDkwChBmGVao/pICrf/b8G6/BBv8WQzs=;
        b=iTG06JAb5po3QVoqPkhspslZyiOaCKVGzxX+GM1S77e52sNzx4N9SnqyrRBB6y42yQ
         s7Z5X9VMT5TQb9lYaQsWrpZwJXpoAtAPSjNjVdGhRKnFqKDlUUJzkVt/clmqHk+tVZnu
         5s9SDyPINoamCnwRLB78ZDub5Utst5DiVjxbzAW/cjvN4R4v8fEjrtia8mtxt5wh8mzb
         J4F8Crfq7Rr1jctX+wNOZ5OykSaOurjkgms/ff8B73aVaDY1994rMpOuRTf/XE+2YkPN
         NO1mw9IkT58/fl4oy+Nf93nkOvyNxa6DgdABgApa6F4GKrnoNQ61hwOd00TpibHC1yqx
         /0KQ==
X-Forwarded-Encrypted: i=1; AKwUvBw+QWTzlZ2au6UQ4SDA7h5Lx0UpZEvoytf3zjOMedjMkX5cfd1siSLGXn4XU+UmHEcZjuLquR9cow==@kvack.org
X-Gm-Message-State: AFq9FYJrVuqK36xpArHnjV9XRs31YlG/oO3OyVPtin1LRtqQxAo//Brr
	C0YT3NUC7ZIO01ZTI9GheuTDWRhXRMGoKEQugeMJwE7ilgE2cAQ0OYoGcYBA7gxSjBA=
X-Gm-Gg: AYBFou2hCZL3lAPxJX3l/ahNUHcE6MG7BAyc6Zs+mt8qWEKlHUN3qvFItYuUEY4Szrc
	cyM4mUVgkioak/keRW/8l9opDHt/svVKag9GEOYtFqRAwwPLHbaP9jvfBdwbMsBnO3E80legeTg
	KaLlgk2q1VSlvKLKmwZhzvF/3bMgfnfURRBclb33kSp/HqyeG4vhTLXmBLgMKreJRtuvpl7q8g9
	znJa/Y7MtiVE6tVBmoRxLh/KBG+g7/TbF5YeFFfODeeu9WbFy05hJPnJOdAfLUCDKjMdHpITaCd
	e4CkVFh9Yjg8XEq51FWUUPg/53otyfrLWeflebAXUPyZDuAKLg9iJt1GZBq1OdOfiTpQGZ/70ct
	8mqneEHUrKmlex+qMT4sZKyIUn9KbdYaB8D1wEYq0ikXC0zr+rYVZjUpKayTX4hcgkdakVFZwOl
	mKWx7QcfnMH86OFaVWgwOiz1quctdnRIZG0CRwiSVwg8/ouUPRqJpDwhS6mD5IInC8Sea7s7ieR
	mAOsG6006AXj+R22F+4hVT9YYzXacnxEcz67fxSG46Oxg==
X-Received: by 2002:a17:907:9303:b0:c46:7de7:e41d with SMTP id a640c23a62f3a-c49a7417cabmr116191366b.18.1793072071043;
        Mon, 26 Oct 2026 20:34:31 -0700 (PDT)
Received: from localhost ([2a03:2880:32ff:9::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd52435asm380825966b.36.2026.10.26.20.34.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:34:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
Date: Mon, 26 Oct 2026 20:34:28 -0700
Message-Id: <179307206859.1171062.6841971971647864368.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBBEF1C0005
X-Stat-Signature: 5o15atxbrr6q68xum1cp661ak37bnaof
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793072072-465035
X-HE-Meta: U2FsdGVkX1/65h11qsZ7cDJwBm9+eCoSqQsFs4zEyyP4iun51hHF55nVz5p2o0WsNsVaOUfftAnnp0G0EKUGW2s7hPhtbBMIMZlscNPUjKN5QsZ0+hEoDV7/YnyOXvELquYcgo0vCDWD9U1uE/bCYgD8Vl8ffAam3iGf4JHadJbl79R60fKK5QayM7ahuN3QbXdLD++Kw0hV1tPU5Zq6jUkzj8bu8ZmqRqwJnYVP2AAOrNKUmihPlHD5a0Tjrw6ZeWxngTHcwO5senFinGkGvT9U6/qn/toi+puCupatkkmeXSFKoxY0YEskpBz/YBf/zVzwsmqjzVs1ErxjM6djjssV9C8sHu3/ddG02686zL/kdtrowwc3usD4MRiECxZbZ2CqwV5tio8BVvI0r/YgVFHoapO4gYIGYWFqh0q0AVgZSMWyMMxdc3C0bhRYIfDdYuN/z6VzhT0P5tHPKIQ7/0fNkTK80GEKDLdGYTo0gZv/m5Tzqwel8vfw+GXUrSNr0OQT4Hqi/X3E70JGjPNtyMW07TNBL7rRyB3Zjw2wUzZGumBrVlZKdrT63L1NgsADL3ZmRksPA7oJ2rhbsd0XWCNQZ4CYcrTMsVj4eYwbPcrzJ8m9umJBnJyKg0lnL81FeRn8XgyQa4dPfFulhX916EnyphSceHa2ErBAC5g97fMU0uPvIAn3Tg1M3zqRuC93kbl5CwFJsuag1WB16ZGeRqpnaodSZC0GUt2fsvzhy+Tpx4AmiuIzJhgKNzlZbtOSQr4EZtU4ifLXPIYP4yQOIFxMARfMabvJBiXRtDmozfH4UtFhoWVCSKim28RrUUBA96dNrD9Q5v+ajdphn1uLbqZRRIgpLL5czbtvjtStmYSef12dHUhgwfkL6FXG+jDjEJa6cVakYDGhkOuptXbW9KFkATLz5Po7huIVUWQYrDxhFzQjMRY9JJLc8DUr9/FlshtO1HucgW2s3qiY4oI
 gJrErdYd
 7ygkZZS849j53FsSjY1A05Ls+q+jUhlsX1NYwmuY51j+DzeEC+n3Lv6VPaymzkqFfn0ZQvM71XkR94/kko0hkrvAwB69YkRk6a3aoB/arbprWl1Cpujr6yKLUglehcepVWUW4Oks4cjXqJMWYMz/uiH8VKVEJ6hM+EDpqXYwJL/FVvwCLAj8X62ju+aD2wOXH9ixOGG1wJjwtX7bJuHdIexveZl+sSHtjJ0DxEH5caGCk0IZ67egPjcC1j/pDv6g99xpXsnhgffDBYgEmGEL7B7JwdhPelVEoa+3NZCstPKhL4pCOgeKXrEdPSKSkGL1JjX7amGmnewbtNFzBcQOss8gvvm4r4P0vPeIpI4LUFGyoP9MHT/FGMddaWmcwt8eHX7B9FPNccnQ8CvuFgYIJKwNKGHrs3rnj80FjeBRvkd9h4/TpkYFpqwC19DPMe3K+h2bjTTIP/VTs1ANE8eUTP9qZ2Vr4pdVwXY6flLg21OYiyHSSbOZSFPYygYBRiKIuuT0JWScIRIhen3w/7J+3nk+FGpO1Br0onzkngbJ5EBjntkxRrb+uhpzy92jQczjPnQHg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 00:17 +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
> read(), write() and lseek() on a shared open file description of a regular
> file serialize on ->f_pos_lock.  The flag that asks for it,
> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
> too, but its struct file comes from alloc_file_pseudo() and never passes
> through do_dentry_open(), so it does not get the flag:
> 
... snip ...
> 
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

This one arguably should have at least a trivial selftest.

Test attatched
-- >8 --
From: Gregory Price <gourry@gourry.net>
Subject: [PATCH] selftests/memfd: test shared file position atomicity

Without FMODE_ATOMIC_POS, concurrent reads or writes on a shared memfd
can use the same file position. Two writers can overwrite each other's
records:

    CPU 1                         CPU 2
    pos = file->f_pos
                                  pos = file->f_pos
    write a record at pos
                                  write a record at pos
    file->f_pos = pos + size
                                  file->f_pos = pos + size

Add separate shared-read and shared-write tests using the kselftest
harness. Check the final offset, file size and exactly-once record delivery
rather than requiring a particular interleaving.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/memfd/.gitignore  |   1 +
 tools/testing/selftests/memfd/Makefile    |   3 +-
 tools/testing/selftests/memfd/memfd_pos.c | 136 ++++++++++++++++++++++
 3 files changed, 139 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/memfd/memfd_pos.c

diff --git a/tools/testing/selftests/memfd/.gitignore b/tools/testing/selftests/memfd/.gitignore
index dd9a051f608e2..574ab97ebd982 100644
--- a/tools/testing/selftests/memfd/.gitignore
+++ b/tools/testing/selftests/memfd/.gitignore
@@ -2,4 +2,5 @@
 fuse_mnt
 fuse_test
 memfd_test
+memfd_pos
 memfd-test-file
diff --git a/tools/testing/selftests/memfd/Makefile b/tools/testing/selftests/memfd/Makefile
index 163b6f68631c4..67a95c34541cd 100644
--- a/tools/testing/selftests/memfd/Makefile
+++ b/tools/testing/selftests/memfd/Makefile
@@ -2,7 +2,7 @@
 CFLAGS += -D_FILE_OFFSET_BITS=64
 CFLAGS += $(KHDR_INCLUDES)
 
-TEST_GEN_PROGS := memfd_test
+TEST_GEN_PROGS := memfd_test memfd_pos
 TEST_PROGS := run_fuse_test.sh run_hugetlbfs_test.sh
 TEST_GEN_FILES := fuse_test fuse_mnt
 
@@ -22,6 +22,7 @@ include ../lib.mk
 
 $(OUTPUT)/fuse_mnt: LDLIBS += $(VAR_LDLIBS)
 
+$(OUTPUT)/memfd_pos: LDLIBS += -pthread
 $(OUTPUT)/memfd_test: memfd_test.c common.c
 $(OUTPUT)/fuse_test: fuse_test.c common.c
 
diff --git a/tools/testing/selftests/memfd/memfd_pos.c b/tools/testing/selftests/memfd/memfd_pos.c
new file mode 100644
index 0000000000000..5f3749d13f561
--- /dev/null
+++ b/tools/testing/selftests/memfd/memfd_pos.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <errno.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+#define THREADS 4
+#define RECORDS 16384
+#define TOTAL (THREADS * RECORDS)
+
+struct worker {
+	int fd;
+	unsigned int id;
+	bool reading;
+	pthread_barrier_t *barrier;
+	atomic_uint *seen;
+	int error;
+};
+
+static void *transfer(void *arg)
+{
+	struct worker *w = arg;
+	unsigned int i;
+
+	pthread_barrier_wait(w->barrier);
+	for (i = 0; i < RECORDS; i++) {
+		uint32_t value = w->id * RECORDS + i;
+		ssize_t n;
+
+		do {
+			n = w->reading ? read(w->fd, &value, sizeof(value)) :
+				write(w->fd, &value, sizeof(value));
+		} while (n < 0 && errno == EINTR);
+		if (n != sizeof(value) || value >= TOTAL) {
+			w->error = 1;
+			break;
+		}
+		if (w->reading)
+			atomic_fetch_add(&w->seen[value], 1);
+	}
+	return NULL;
+}
+
+FIXTURE(memfd_pos) {
+	int fd;
+	atomic_uint *seen;
+};
+
+FIXTURE_SETUP(memfd_pos)
+{
+	self->fd = memfd_create("position", MFD_CLOEXEC);
+	if (self->fd < 0 && errno == ENOSYS)
+		SKIP(return, "memfd_create unavailable");
+	ASSERT_GE(self->fd, 0);
+	self->seen = calloc(TOTAL, sizeof(*self->seen));
+	ASSERT_NE(self->seen, NULL);
+	for (unsigned int i = 0; i < TOTAL; i++)
+		atomic_init(&self->seen[i], 0);
+}
+
+FIXTURE_TEARDOWN(memfd_pos)
+{
+	close(self->fd);
+	free(self->seen);
+}
+
+static int run_workers(int fd, bool reading, atomic_uint *seen)
+{
+	pthread_barrier_t barrier;
+	pthread_t threads[THREADS];
+	struct worker workers[THREADS];
+	int ret = 0;
+	unsigned int i;
+
+	if (pthread_barrier_init(&barrier, NULL, THREADS))
+		return 1;
+	for (i = 0; i < THREADS; i++) {
+		workers[i] = (struct worker) {
+			.fd = fd, .id = i, .reading = reading,
+			.barrier = &barrier, .seen = seen,
+		};
+		/* The harness isolates this test in a child; abort on setup failure. */
+		if (pthread_create(&threads[i], NULL, transfer, &workers[i]))
+			abort();
+	}
+	for (i = 0; i < THREADS; i++) {
+		if (pthread_join(threads[i], NULL) || workers[i].error)
+			ret = 1;
+	}
+	pthread_barrier_destroy(&barrier);
+	return ret;
+}
+
+/* Concurrent writes sharing an open file description must not overlap. */
+TEST_F(memfd_pos, shared_write)
+{
+	struct stat st;
+	uint32_t value;
+	unsigned int i;
+
+	ASSERT_EQ(run_workers(self->fd, false, self->seen), 0);
+	ASSERT_EQ(fstat(self->fd, &st), 0);
+	ASSERT_EQ(st.st_size, (off_t)(TOTAL * sizeof(value)));
+	ASSERT_EQ(lseek(self->fd, 0, SEEK_CUR), st.st_size);
+	ASSERT_EQ(lseek(self->fd, 0, SEEK_SET), 0);
+	for (i = 0; i < TOTAL; i++) {
+		ASSERT_EQ(read(self->fd, &value, sizeof(value)), sizeof(value));
+		ASSERT_LT(value, TOTAL);
+		atomic_fetch_add(&self->seen[value], 1);
+	}
+	for (i = 0; i < TOTAL; i++)
+		ASSERT_EQ(atomic_load(&self->seen[i]), 1);
+}
+
+/* Concurrent reads must consume every record exactly once. */
+TEST_F(memfd_pos, shared_read)
+{
+	uint32_t i;
+
+	for (i = 0; i < TOTAL; i++)
+		ASSERT_EQ(write(self->fd, &i, sizeof(i)), sizeof(i));
+	ASSERT_EQ(lseek(self->fd, 0, SEEK_SET), 0);
+	ASSERT_EQ(run_workers(self->fd, true, self->seen), 0);
+	ASSERT_EQ(lseek(self->fd, 0, SEEK_CUR), (off_t)(TOTAL * sizeof(i)));
+	for (i = 0; i < TOTAL; i++)
+		ASSERT_EQ(atomic_load(&self->seen[i]), 1);
+}
+
+TEST_HARNESS_MAIN

-- 
Gregory Price <gourry@gourry.net>

