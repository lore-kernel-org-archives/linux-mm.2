Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56710C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8566B009E; Mon, 14 Sep 2026 06:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6798B6B009F; Mon, 14 Sep 2026 06:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5914F6B00A0; Mon, 14 Sep 2026 06:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA856B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:45:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 698E180281
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:38 +0000 (UTC)
X-FDA: 85212036756.04.F597F4E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9920620005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QN8+fBDx;
	spf=pass (imf31.hostedemail.com: domain of matthias.goergens@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789382736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP4c2SklkdAq8uJAifC1BRbJPGJDoqcc2YiW0fKnZ+4=;
	b=jHnX3gCvndQQVl41wR/jAXrXMB+hhwVniYRVZRW9izDXNmuPLoDFDfF87bENYLr5Kdp3M1
	OOGKMqf9RJTZzlUeGHUWfhkWhbpo39unHranQk1HmVJXsOjEc/BB1nX262AVLGnEGZj0zc
	m/+fVpTnOERZZcel/YIIq1R6iCtnseg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789382736;
	b=NfDi3i/yOK4jhzE/eAtM64KT/a802zkYOgMDnB2XIbvdmik0sCHS13XCDjPoE/4t0y6sZr
	sEzVj33HKHvGQUrzBzPhFLcFhcgnYBeVjl0GPEZiSrh9mE+MUre43ZE4orw8Jbz3FAj8Br
	Ghv0wi2aR4eXnExV3xuSHrqzWx3uhKo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QN8+fBDx;
	spf=pass (imf31.hostedemail.com: domain of matthias.goergens@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-86ec25cf7ecso674467b3a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789382735; x=1789987535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pP4c2SklkdAq8uJAifC1BRbJPGJDoqcc2YiW0fKnZ+4=;
        b=QN8+fBDxv4iP2pIAmSaFKip5AoT1ihkzIzVpke7AOgeAA8UH1rWXqCJjG8cGhANfq1
         +Ex9WVsahyxh/5r6oFpwBrzGEujJLfGT6nn1pazvwPorfugQ4OrYTarJfSpFlb4uIdzo
         hIhj4PkuDGKCsa8jgVoMRL8f0mjdTA7BFSRuTjtuvmYT3lmBQVO/4qH8dKjUxt7lbZPH
         6Ut6iFlyscNwE8+pVm5pE7bKKlHpL7jpvloG9bODhkaBjlNyk9VhweIpO/3ePytgYe4D
         boB0gsZ8GvTg/hJ4LSxd7hgBuzlx1Krlmktj9O6Chb2K9Y24HH2G9MV0XQ12kj/FiKSH
         b/+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789382735; x=1789987535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pP4c2SklkdAq8uJAifC1BRbJPGJDoqcc2YiW0fKnZ+4=;
        b=Qj5qGISPdsTgZkekH5nsy7H3TIM6B1rTh/CHaZEdRgNWf8Mzovd3unWH90wTlmMBC4
         uHyGKQHsX0CbThyJZdsGQCjSl5wP5RcQmxPmgk48TrnemgjGy/ZIUKBy9OtkbHzbuyeP
         tFbwW0UryY1F7cVV6i5hS1JxfYYkzpgAww1foC01fxmwdqqySCc59+Fevoq9gGNK84wh
         fvmpl6+f+1sYSK9lykpBcdj8sNEavnFO8akSI0VAH6VPbx07+CU/R81iDFa75yJEXwwU
         pXI4V0oMm3LRjMRu6xtkN3SfZUzOJ9vtgFOyAaWWwCbgCTS5TDp06ftQSoM+eepUKx25
         0OsQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2XTt2r2QZvm+QUC1BqRk8MrRXAoD/cqOizKKAl5NWutM6IJhkjIjce+di0QasVVAiL26sUIcLeA==@kvack.org
X-Gm-Message-State: AFuF++muWMtKcxcCrGdSq8vgzw7EUZji5Dkac6bVUV7P81NciOjWlMmY
	kINrYH0WJAyOL0mCvPBxYutEw6ipNC8P6aZQMncTqiA7EcBvXwghb3FN
X-Gm-Gg: AYBFou3Bp41Y7HIRTSRdU8Ra7K7cILSF67XpLzwYAzeiEWywkfFhMRxMPPquQhxwU1b
	qhoVKisyst5kZTVxDxonW/rYLJfCxFdMjiYeWOyQsOYsxr7xKJrLNcVt/2SEYUDhZXAc9AxZiwa
	MF/0pPEuSRNYMENfdacjqnuyzGeRjknnfl16KVGXPZqGIdnK6Ag2dr3LRliKJMa5XJ6WMYvnxCr
	0KOxHKDuPYkZuvm1QMhUlySD8yTWCs95RDIZ6xGUGWELZzlPqt18P0Y9CTE7GyYoKDx4uY3SHj0
	vCmdfy/lGi1vqPOMa/t2FFvKp8IqaTOKiqJPiHkPaDcpUHu3q7ZoU5yI/V0TEt3zalgnk1JRvfG
	owlYnXuDGqGxHKwDv5RaTe8qQMbPZrel94cz0KfHE4L43M/1tMK2ptggtblkHjYH5zOu6lZ5p0u
	okdod3QaiFcw5QdYmjNjeno8k2QeTpJCt0UE4QFUPA9QUD+vy9p1LVs2algnE5yeDNg4K2uo3ZO
	mdGInLz3hepQBban16IqN7xD0QBBdI7XT3SFaPuE6Irp1psFv4YOM6II66E20IZFUPnHH8kohTY
	cHJ1h55M1zbjg/h/NqjV2boi56s//LPugm6K5BkSJxPXJ7e0RMvSZdUZfInXDxg=
X-Received: by 2002:a05:6a00:4397:b0:853:ffd0:93f3 with SMTP id d2e1a72fcca58-86e2a8cce3amr6578637b3a.11.1789382735182;
        Mon, 14 Sep 2026 03:45:35 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.252.203.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b28fd0e0dsm4234386b3a.26.2026.09.14.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:45:34 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH 3/3] selftests: zram: cover retained offload-only entries
Date: Mon, 14 Sep 2026 18:45:01 +0800
Message-ID: <20260914104501.3960616-4-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260914104501.3960616-1-matthias.goergens@gmail.com>
References: <20260914104501.3960616-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: piuoegbt5ndiqh9qkknz9sm5pidk9i47
X-Rspamd-Queue-Id: 9920620005
X-HE-Tag: 1789382736-280824
X-HE-Meta: U2FsdGVkX19Y/22bd3rjbi8nmySVuqOIFVsA3uS72oDSMd+r+m2/XAFfgf7BDx6iiYMPdlTRKgRaBni803nOOLwWx1ckFX22v9MWpt+ZDPXnq0f5Qs8W+PD7jYhJ4U42QT4rDSZa1UpcDShQMuvPySJbxaV/xVvMMPMLytkO9wV2nOIu7r+xs+EoL6s1M3VzG06tt3HOb4Q7CLuUVMz+POWzxb0Fmmw9hjXvnmUqIBUFsNXP6ZsjvQQuc9pZv0LbsUFPQwzz7VoNBQ+NkvDuJWWMOfA712AQWDhhuJ860NO8nZ2KUvzfTIJu2AJdn3LCzSAsTmiAOO9N6YCvYjP2KHegIkQY8iXGUv7Rtjuo/2l1bPyyX+zpFDczcehbgj7xJpQzp9DoOmnHIyQWgKsBrieeVqBX7WhiHQaOE9l2/+zT1BOc7Tygs6+2xvLXvZ52h6AzwUD1H5TWbIbU0tTtvfQbexNgs/YMSmXsgI2coMD30ZJpOjOwfagBz9xvPjBKsCYced7E1JM6W7UZ4FDHTss33+w/DvlZFX7EXhEHEucljTiErLsApvoDmNeWYf7PYucMhLnnfP/MDfzd62M+Xo43wtT7Bq233lJQZdqf5KjKVbZh02NcbcEHpkbpJnK8lBTvDWKcfkE3tryxgZrMD7NtnCtSxJnvr6xFsr2gsXB8j1XsJ67IzPvbuP/G/SNot+usil2yNlKy6EcYvWqIrQO9JFikq9pjuh6Xd1OQDZ4CygWHsf6RxQ4PlLW+O8oRBauEaU4eADxxdA/0HIZjjaZBRjLIzcKOQqWI9LiSqJDslJU74YrRMEzfM5FfMXyvRWASY+Ioi+wC2Q7nYUR88h3aSO+ds5HYkqn6wQnfwVkCn9Odw/daA3ozODIrCExDXRM93gD+CR74vQ2UaspjpC3n9JRHJr+5aUzAGqh/P+y254Y5Ym+lfhlMX0/knuA33GDTTvw8Yl+/SWtMY5e
 NK+JU1VG
 PwjwygfkI9TZQpLvHBuVhsOe6Z2B3wm5d4PeYZUSe2GKav5KvtbcEDFdsnG036xP2xOXWbA5vt52BIZicXcNbeZHQ3rJDbrXYuL66i2X4qSkyY7u7TwIM/uSA/F5KSrOy/kvXIvJL2CfkGaUZds8CpFIA9Wlm4HE/8o8FjJKeHD0jAZE3JjEI/x63F0V8/lDs7tfDC+K2eMf9Q6aWc/oA3q/muDIoqfmwMBm4ePK4vfGFRfR+S99ombUjTc4ii6syBceD08Hqofrz8Dfqzr/CH4S7IWbr8dFRRgqg+qw2gxr+ev1OAInwu/m3yZEjXM/NR1TJggc9lfvWnQLFOGIcLxZYhRRnUtTcSas5YXoCchp3H4uk0O0fNMLz+kgzKfFzbJCcyGjQLh0rxjF7BDdxVpI4facYRicq+JcPE3AVmV2wAgpstB5ZQ8oLBwjSAwtZhjo9dsuChJp9BVzuV1s8+RHq5ZJZs56Ly9S5SIFD7KpY5E8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Faulting and dirtying one page of a swapped-out large folio can leave
sibling PTEs referring to its existing offload-only swap allocation.
Exercise this path with zram behind dm-delay: ordinary reclaim must not
rewrite the allocation, while proactive reclaim must still be able to.

Check backing-device writes, refusal counters and data integrity. Derive
the folio and expected I/O sizes from the architecture's PMD huge-page
size. Keep this test separate from basic routing coverage because it
also requires transparent huge pages, MADV_COLLAPSE and dm-delay.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tools/testing/selftests/zram/Makefile       |   2 +-
 tools/testing/selftests/zram/config         |   4 +
 tools/testing/selftests/zram/swap_offload.c | 182 +++++++++-
 tools/testing/selftests/zram/zram05.sh      | 360 ++++++++++++++++++++
 4 files changed, 546 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/zram/zram05.sh

diff --git a/tools/testing/selftests/zram/Makefile b/tools/testing/selftests/zram/Makefile
index 781d10a20e56..b83e6a1563b2 100644
--- a/tools/testing/selftests/zram/Makefile
+++ b/tools/testing/selftests/zram/Makefile
@@ -2,7 +2,7 @@
 all:
 
 TEST_GEN_FILES := swap_offload workingset_offload
-TEST_PROGS := zram.sh zram03.sh zram04.sh
+TEST_PROGS := zram.sh zram03.sh zram04.sh zram05.sh
 TEST_FILES := zram01.sh zram02.sh zram_lib.sh
 EXTRA_CLEAN := err.log
 
diff --git a/tools/testing/selftests/zram/config b/tools/testing/selftests/zram/config
index c59b8c3806a5..018429d8f5ca 100644
--- a/tools/testing/selftests/zram/config
+++ b/tools/testing/selftests/zram/config
@@ -1,6 +1,10 @@
 CONFIG_CGROUPS=y
+CONFIG_BLK_DEV_DM=y
+CONFIG_DM_DELAY=y
 CONFIG_MEMCG=y
 CONFIG_SWAP=y
+CONFIG_TRANSPARENT_HUGEPAGE=y
+CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_ZSMALLOC=y
 CONFIG_ZRAM=y
 CONFIG_ZSWAP=y
diff --git a/tools/testing/selftests/zram/swap_offload.c b/tools/testing/selftests/zram/swap_offload.c
index b2b94cd6ee3a..1850b3b4809f 100644
--- a/tools/testing/selftests/zram/swap_offload.c
+++ b/tools/testing/selftests/zram/swap_offload.c
@@ -3,6 +3,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <limits.h>
 #include <sched.h>
 #include <signal.h>
 #include <stdio.h>
@@ -17,6 +18,7 @@
 #define SWAP_FLAG_DISCARD_ONCE	0x20000
 #define SWAP_FLAG_DISCARD_PAGES	0x40000
 #define SWAP_FLAG_OFFLOAD_ONLY	0x80000
+#define KSFT_SKIP	4
 
 static int activate(const char *path, int priority, int discard_flags)
 {
@@ -201,11 +203,187 @@ static int allocate(const char *size_arg, const char *procs,
 		pause();
 }
 
+static int create_marker(const char *path, int write_pid)
+{
+	char *temporary;
+	int fd, ret = 1;
+
+	if (asprintf(&temporary, "%s.XXXXXX", path) < 0) {
+		perror("asprintf marker path");
+		return 1;
+	}
+	fd = mkstemp(temporary);
+	if (fd < 0) {
+		perror(path);
+		goto out_free;
+	}
+	if (write_pid && dprintf(fd, "%d\n", getpid()) < 0) {
+		perror("write marker");
+		close(fd);
+		goto out_unlink;
+	}
+	if (close(fd)) {
+		perror("close marker");
+		goto out_unlink;
+	}
+	/* Publish only after the payload is complete for the shell reader. */
+	if (rename(temporary, path)) {
+		perror("publish marker");
+		goto out_unlink;
+	}
+	ret = 0;
+out_unlink:
+	unlink(temporary);
+out_free:
+	free(temporary);
+	return ret;
+}
+
+static unsigned char retained_byte(unsigned long offset, long page_size,
+				   int touched)
+{
+	unsigned char value = offset / page_size % 251 + 1;
+
+	if (touched && !offset)
+		value ^= 0x5a;
+	return value;
+}
+
+static int verify_retained(unsigned char *memory, unsigned long size,
+			   long page_size, int full)
+{
+	unsigned long limit = full ? size : 1;
+
+	for (unsigned long offset = 0; offset < limit; offset++) {
+		unsigned char expected = retained_byte(offset, page_size, 1);
+
+		if (memory[offset] != expected) {
+			fprintf(stderr,
+				"retained data mismatch at %lu: got %u, expected %u\n",
+				offset, memory[offset], expected);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int retained(const char *size_arg, const char *procs,
+		    const char *ready, const char *touched,
+		    const char *verified)
+{
+	unsigned long allocation_size, mapping_start, size;
+	unsigned char *mapping, *memory;
+	char *end;
+	sigset_t signals;
+	long page_size;
+	int signal;
+
+	errno = 0;
+	size = strtoul(size_arg, &end, 0);
+	if (errno || *end || !size || (size & (size - 1))) {
+		fprintf(stderr, "allocation size must be a power of two\n");
+		return 1;
+	}
+	if (join_cgroup(procs))
+		return 1;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size <= 0) {
+		perror("sysconf _SC_PAGESIZE");
+		return 1;
+	}
+	if (size < (unsigned long)page_size || size % page_size) {
+		fprintf(stderr, "allocation size must contain whole pages\n");
+		return 1;
+	}
+	if (size > ULONG_MAX / 2) {
+		fprintf(stderr, "allocation size is too large\n");
+		return 1;
+	}
+	allocation_size = size * 2;
+	mapping = mmap(NULL, allocation_size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mapping == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+	mapping_start = (unsigned long)mapping;
+	memory = (unsigned char *)((mapping_start + size - 1) & ~(size - 1));
+	if ((unsigned long)memory != mapping_start)
+		munmap((void *)mapping_start,
+		       (unsigned long)memory - mapping_start);
+	munmap(memory + size, allocation_size - size -
+	       ((unsigned long)memory - mapping_start));
+	if (madvise(memory, size, MADV_HUGEPAGE)) {
+		perror("madvise MADV_HUGEPAGE");
+		return 1;
+	}
+	for (unsigned long offset = 0; offset < size; offset += page_size)
+		memset(memory + offset, retained_byte(offset, page_size, 0),
+		       page_size);
+#ifdef MADV_COLLAPSE
+	if (madvise(memory, size, MADV_COLLAPSE)) {
+		int error = errno;
+
+		perror("madvise MADV_COLLAPSE");
+		if (error == EAGAIN || error == EINVAL || error == ENOMEM)
+			return KSFT_SKIP;
+		return 1;
+	}
+#else
+	fprintf(stderr, "MADV_COLLAPSE is unavailable\n");
+	return KSFT_SKIP;
+#endif
+
+	sigemptyset(&signals);
+	sigaddset(&signals, SIGUSR1);
+	sigaddset(&signals, SIGUSR2);
+	sigaddset(&signals, SIGALRM);
+	if (sigprocmask(SIG_BLOCK, &signals, NULL)) {
+		perror("sigprocmask");
+		return 1;
+	}
+	if (create_marker(ready, 1))
+		return 1;
+
+	for (;;) {
+		errno = sigwait(&signals, &signal);
+		if (errno) {
+			perror("sigwait");
+			return 1;
+		}
+		if (signal == SIGUSR1) {
+			unsigned char value;
+
+			if (mprotect(memory, page_size, PROT_READ)) {
+				perror("mprotect read");
+				return 1;
+			}
+			value = memory[0];
+			if (mprotect(memory, page_size, PROT_READ | PROT_WRITE)) {
+				perror("mprotect write");
+				return 1;
+			}
+			memory[0] = value ^ 0x5a;
+			if (create_marker(touched, 0))
+				return 1;
+		} else {
+			if (verify_retained(memory, size, page_size,
+					    signal == SIGALRM))
+				return 1;
+			if (create_marker(verified, 0))
+				return 1;
+		}
+	}
+}
+
 int main(int argc, char **argv)
 {
 	if (argc == 4 && !strcmp(argv[1], "activate"))
 		return activate(argv[2], atoi(argv[3]),
 				SWAP_FLAG_DISCARD | SWAP_FLAG_DISCARD_ONCE);
+	if (argc == 4 && !strcmp(argv[1], "activate-no-discard"))
+		return activate(argv[2], atoi(argv[3]), 0);
 	if (argc == 4 && !strcmp(argv[1], "reject-page-discard"))
 		return reject_page_discard(argv[2], atoi(argv[3]));
 	if (argc == 4 && !strcmp(argv[1], "accept-discard-once-pages"))
@@ -214,9 +392,11 @@ int main(int argc, char **argv)
 		return pin_to_one_cpu(argv[2]);
 	if (argc == 6 && !strcmp(argv[1], "allocate"))
 		return allocate(argv[2], argv[3], argv[4], argv[5]);
+	if (argc == 7 && !strcmp(argv[1], "retained"))
+		return retained(argv[2], argv[3], argv[4], argv[5], argv[6]);
 
 	fprintf(stderr,
-		"usage: %s activate DEVICE PRIORITY | reject-page-discard DEVICE PRIORITY | accept-discard-once-pages DEVICE PRIORITY | pin PID | allocate BYTES CGROUP.PROCS READY VERIFIED\n",
+		"usage: %s activate|activate-no-discard DEVICE PRIORITY | reject-page-discard DEVICE PRIORITY | accept-discard-once-pages DEVICE PRIORITY | pin PID | allocate BYTES CGROUP.PROCS READY VERIFIED | retained BYTES CGROUP.PROCS READY TOUCHED VERIFIED\n",
 		argv[0]);
 	return 1;
 }
diff --git a/tools/testing/selftests/zram/zram05.sh b/tools/testing/selftests/zram/zram05.sh
new file mode 100755
index 000000000000..e4bbf6bfa0e9
--- /dev/null
+++ b/tools/testing/selftests/zram/zram05.sh
@@ -0,0 +1,360 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+# Test retained offload-only entries under ordinary and proactive reclaim.
+
+set -eu
+
+# shellcheck source=zram_lib.sh
+. ./zram_lib.sh
+
+TCID="zram05"
+cg="/sys/fs/cgroup/zram-retained-$$"
+cgroup_root="/sys/fs/cgroup"
+tmp="${TMPDIR:-/var/tmp}/zram-retained-$$"
+ready="$tmp/ready"
+touched="$tmp/touched"
+verified="$tmp/verified"
+holder_pid=""
+safe=""
+safe_active=0
+offload_backing=""
+offload=""
+offload_active=0
+dm_name="zram-retained-$$"
+dm_active=0
+dm_node_created=0
+zswap_enabled=""
+thp_size=0
+thp_kib=0
+thp_sectors=0
+page_kib=0
+
+fail()
+{
+	echo "$TCID: [FAIL] $*" >&2
+	exit 1
+}
+
+skip()
+{
+	echo "$TCID: [SKIP] $*" >&2
+	exit "$ksft_skip"
+}
+
+cleanup()
+{
+	set +e
+	if [ -n "$holder_pid" ]; then
+		kill "$holder_pid"
+		wait "$holder_pid"
+	fi
+	if [ "$offload_active" -eq 1 ]; then
+		swapoff "$offload" >/dev/null 2>&1
+	fi
+	if [ "$safe_active" -eq 1 ]; then
+		swapoff "$safe" >/dev/null 2>&1
+	fi
+	if [ "$dm_active" -eq 1 ]; then
+		dmsetup --noudevsync --noudevrules remove "$dm_name" \
+			>/dev/null 2>&1
+	fi
+	if [ "$dm_node_created" -eq 1 ]; then
+		rm -f "$offload"
+	fi
+	rm -rf "$tmp"
+	rmdir "$cg"
+	cgroup_disable_memory_controller "$cgroup_root"
+	if [ "$dev_end" -ge "$dev_start" ]; then
+		zram_cleanup
+	fi
+	if [ -n "$zswap_enabled" ]; then
+		echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled
+	fi
+}
+
+wait_file()
+{
+	for _ in $(seq 1 400); do
+		[ -e "$1" ] && return 0
+		if [ -n "$holder_pid" ]; then
+			holder_state=$(awk '{ print $3 }' \
+				"/proc/$holder_pid/stat" 2>/dev/null || :)
+		else
+			holder_state=""
+		fi
+		if [ -n "$holder_pid" ] &&
+		   { ! kill -0 "$holder_pid" 2>/dev/null ||
+		     [ "$holder_state" = Z ]; }; then
+			if wait "$holder_pid"; then
+				helper_status=0
+			else
+				helper_status=$?
+			fi
+			holder_pid=""
+			return 2
+		fi
+		sleep 0.05
+	done
+	return 1
+}
+
+require_helper_file()
+{
+	if wait_file "$1"; then
+		return 0
+	else
+		status=$?
+	fi
+	if [ "$status" -eq 2 ]; then
+		[ "$helper_status" -eq "$ksft_skip" ] && skip "$2 is unavailable"
+		fail "retained helper exited with status $helper_status while $2"
+	fi
+	fail "retained helper timed out while $2"
+}
+
+written_sectors()
+{
+	awk '{ print $7 }' "/sys/block/${offload_backing##*/}/stat"
+}
+
+vmstat_value()
+{
+	awk -v name="$1" '$1 == name { print $2 }' /proc/vmstat
+}
+
+wait_offload_quiet()
+{
+	# A bio queued inside dm-delay is not yet visible in either the backing
+	# device statistics or the mapped device's inflight counters.
+	sleep 4
+	previous=-1
+	stable=0
+	for _ in $(seq 1 240); do
+		current=$(written_sectors)
+		read -r reads writes < "$dm_inflight"
+		if [ "$current" -eq "$previous" ] && \
+		   [ "$reads" -eq 0 ] && [ "$writes" -eq 0 ]; then
+			stable=$((stable + 1))
+			[ "$stable" -ge 20 ] && return 0
+		else
+			stable=0
+		fi
+		previous=$current
+		sleep 0.05
+	done
+	return 1
+}
+
+check_prereqs
+[ -x ./swap_offload ] || skip "swap_offload helper is unavailable"
+command -v dmsetup >/dev/null 2>&1 || skip "dmsetup is unavailable"
+command -v blockdev >/dev/null 2>&1 || skip "blockdev is unavailable"
+[ -e /sys/fs/cgroup/cgroup.controllers ] ||
+	skip "cgroup v2 controllers are unavailable"
+grep -qw memory /sys/fs/cgroup/cgroup.controllers ||
+	skip "memory controller is unavailable"
+[ -d /sys/kernel/mm/transparent_hugepage ] ||
+	skip "transparent huge pages are unavailable"
+[ -r /sys/kernel/mm/transparent_hugepage/hpage_pmd_size ] ||
+	skip "PMD huge-page size is unavailable"
+grep -q '^swpout_offload_refused ' /proc/vmstat ||
+	skip "offload refusal counters are unavailable"
+
+thp_size=$(cat /sys/kernel/mm/transparent_hugepage/hpage_pmd_size)
+case "$thp_size" in
+	''|*[!0-9]*) skip "invalid PMD huge-page size: $thp_size" ;;
+esac
+[ "$thp_size" -gt 0 ] || skip "PMD huge-page size is zero"
+page_kib=$(awk '/KernelPageSize:/ { print $2; exit }' /proc/self/smaps)
+[ "${page_kib:-0}" -gt 0 ] || skip "cannot determine the base page size"
+page_size=$((page_kib * 1024))
+[ "$page_size" -gt 0 ] || skip "base page size is zero"
+[ $((thp_size % page_size)) -eq 0 ] ||
+	skip "PMD huge-page size is not page aligned"
+thp_kib=$((thp_size / 1024))
+thp_sectors=$((thp_size / 512))
+expected_retained_kib=$((thp_kib - page_kib))
+expected_refused=$((thp_size / page_size))
+
+mkdir "$tmp"
+trap cleanup EXIT
+trap 'exit 129' HUP
+trap 'exit 130' INT
+trap 'exit 143' TERM
+dmsetup targets > "$tmp/dm-targets" 2>/dev/null ||
+	skip "cannot query device-mapper targets"
+grep -q '^delay[[:space:]]' "$tmp/dm-targets" ||
+	skip "device-mapper delay target is unavailable"
+
+if [ -e /sys/module/zswap/parameters/enabled ]; then
+	zswap_enabled=$(cat /sys/module/zswap/parameters/enabled)
+	echo N > /sys/module/zswap/parameters/enabled ||
+		skip "cannot disable zswap"
+fi
+
+# Swap priorities are global.  The ordinary zram device must be preferred to
+# any pre-existing swap, while the delayed offload device remains first for
+# eligible proactive reclaim.
+max_prio=$(awk 'BEGIN { max = -1 } NR > 1 && $5 > max { max = $5 } END { print max }' /proc/swaps)
+[ "$max_prio" -le 32765 ] ||
+	skip "cannot outrank existing swap priority $max_prio"
+safe_prio=$((max_prio + 1))
+offload_prio=$((max_prio + 2))
+
+dev_num=2
+zram_size=$((thp_size * 4))
+[ "$zram_size" -ge 67108864 ] || zram_size=67108864
+zram_sizes="$zram_size $zram_size"
+zram_load
+zram_set_disksizes
+safe="/dev/zram${dev_start}"
+offload_backing="/dev/zram$((dev_start + 1))"
+
+sectors=$(blockdev --getsz "$offload_backing") ||
+	skip "cannot read offload backing size"
+[ "$sectors" -gt 0 ] || skip "offload backing has zero size"
+dm_table="0 $sectors delay $offload_backing 0 0 $offload_backing 0 3000"
+dmsetup --noudevsync --noudevrules create "$dm_name" --table "$dm_table" ||
+	skip "cannot create delayed offload device"
+dm_active=1
+dmsetup --noudevsync --noudevrules info --columns --noheadings \
+	--separator ' ' -o major,minor "$dm_name" > "$tmp/dm-devno" ||
+	skip "cannot identify delayed offload device"
+read -r dm_major dm_minor < "$tmp/dm-devno"
+offload="/dev/mapper/$dm_name"
+if [ ! -e "$offload" ]; then
+	mkdir -p /dev/mapper
+	mknod "$offload" b "$dm_major" "$dm_minor" ||
+		skip "cannot create delayed offload device node"
+	dm_node_created=1
+fi
+dm_inflight="/sys/dev/block/$dm_major:$dm_minor/inflight"
+[ -r "$dm_inflight" ] || skip "cannot observe delayed offload I/O"
+
+mkswap "$safe" >/dev/null || fail "cannot initialise safe swap"
+mkswap "$offload" >/dev/null || fail "cannot initialise offload swap"
+swapon -p "$safe_prio" "$safe" || fail "cannot activate safe swap"
+dev_makeswap=$dev_start
+safe_active=1
+./swap_offload activate-no-discard "$offload" "$offload_prio" ||
+	fail "cannot activate offload-only swap"
+offload_active=1
+
+cgroup_enable_memory_controller "$cgroup_root" ||
+	skip "cannot enable the cgroup v2 memory controller"
+mkdir "$cg" || skip "cannot create test cgroup"
+[ -e "$cg/memory.max" ] ||
+	skip "cgroup v2 memory controller is unavailable"
+echo max > "$cg/memory.swap.max"
+
+./swap_offload retained "$thp_size" "$cg/cgroup.procs" "$ready" \
+	"$touched" "$verified" &
+holder_pid=$!
+require_helper_file "$ready" "creating a PMD-sized anonymous huge folio"
+read -r reported_pid < "$ready"
+[ "$reported_pid" -eq "$holder_pid" ] ||
+	fail "retained helper reported the wrong pid"
+anon_huge_kib=$(awk '/AnonHugePages:/ { print $2 }' \
+	"/proc/$holder_pid/smaps_rollup")
+[ "${anon_huge_kib:-0}" -ge "$thp_kib" ] ||
+	skip "anonymous huge folio was not created"
+echo "$TCID: anonymous_huge_kib=$anon_huge_kib"
+
+# This is the only reclaim before the retained entry is made dirty.  It puts
+# the whole folio on offload-only swap so the later single-page fault leaves
+# sibling swap PTEs referring to the existing slot.
+echo "$thp_size swappiness=max" > "$cg/memory.reclaim" 2>/dev/null || :
+wait_offload_quiet || fail "offload device did not quiesce after setup"
+kill -0 "$holder_pid" || fail "retained helper died during setup reclaim"
+kill -USR1 "$holder_pid" || fail "cannot request the dirty-page transition"
+require_helper_file "$touched" "faulting and dirtying the retained entry"
+retained_kib=$(awk '/VmSwap:/ { print $2 }' "/proc/$holder_pid/status")
+[ "${retained_kib:-0}" -eq "$expected_retained_kib" ] ||
+	fail "retained $retained_kib KiB, expected $expected_retained_kib KiB"
+echo "$TCID: retained_kib=$retained_kib"
+
+wait_offload_quiet || fail "offload device did not quiesce before pressure"
+ordinary_before=$(written_sectors)
+refused_before=$(vmstat_value swpout_offload_refused)
+echo $((thp_size / 2)) > "$cg/memory.high" ||
+	fail "ordinary pressure reclaim failed"
+wait_offload_quiet || fail "offload device did not quiesce after pressure"
+ordinary_after=$(written_sectors)
+refused_after=$(vmstat_value swpout_offload_refused)
+ordinary_writes=$((ordinary_after - ordinary_before))
+refused_pages=$((refused_after - refused_before))
+echo "$TCID: ordinary_sectors=$ordinary_writes refused_pages=$refused_pages"
+[ "$ordinary_writes" -eq 0 ] ||
+	fail "ordinary reclaim wrote $ordinary_writes offload sectors"
+[ "$refused_pages" -ge "$expected_refused" ] ||
+	fail "ordinary reclaim refused $refused_pages pages, expected at least $expected_refused"
+kill -0 "$holder_pid" || fail "retained helper died after refused write"
+rm -f "$verified"
+kill -USR2 "$holder_pid" || fail "cannot request dirty-byte verification"
+require_helper_file "$verified" "verifying the dirty retained byte"
+
+# Proactive reclaim must still be able to rewrite the retained PMD-sized slot.
+# Repeated requests make the test insensitive to a short-lived writeback
+# collision; the backing-sector delta still requires exactly one folio write.
+wait_offload_quiet || fail "offload device did not quiesce before recovery"
+recovery_before=$(written_sectors)
+echo max > "$cg/memory.high"
+for _ in $(seq 1 8); do
+	echo "$thp_size swappiness=max" > "$cg/memory.reclaim" 2>/dev/null || :
+done
+wait_offload_quiet || fail "offload device did not quiesce after recovery"
+recovery_after=$(written_sectors)
+recovery_writes=$((recovery_after - recovery_before))
+echo "$TCID: recovery_sectors=$recovery_writes"
+[ "$recovery_writes" -eq "$thp_sectors" ] ||
+	fail "proactive recovery wrote $recovery_writes sectors, expected $thp_sectors"
+kill -0 "$holder_pid" || fail "retained helper died during recovery"
+rm -f "$verified"
+kill -ALRM "$holder_pid" || fail "cannot request full data verification"
+require_helper_file "$verified" "verifying all retained data"
+kill -0 "$holder_pid" || fail "retained helper failed full data verification"
+
+kill "$holder_pid" || fail "cannot stop retained helper"
+if wait "$holder_pid"; then
+	:
+else
+	status=$?
+	[ "$status" -eq 143 ] || fail "retained helper exited with status $status"
+fi
+holder_pid=""
+swapoff "$offload" || fail "cannot deactivate offload-only swap"
+offload_active=0
+swapoff "$safe" || fail "cannot deactivate safe swap"
+safe_active=0
+dev_makeswap=-1
+dmsetup --noudevsync --noudevrules remove "$dm_name" ||
+	fail "cannot remove delayed offload device"
+dm_active=0
+if [ "$dm_node_created" -eq 1 ]; then
+	rm -f "$offload" || fail "cannot remove delayed offload device node"
+	dm_node_created=0
+fi
+rmdir "$cg" || fail "cannot remove test cgroup"
+cg=""
+cgroup_disable_memory_controller "$cgroup_root" ||
+	fail "cannot restore the cgroup memory controller"
+for i in $(seq "$dev_start" "$dev_end"); do
+	echo 1 > "/sys/block/zram${i}/reset" || fail "cannot reset zram$i"
+	if [ "$sys_control" -eq 1 ]; then
+		echo "$i" > /sys/class/zram-control/hot_remove ||
+			fail "cannot remove zram$i"
+	fi
+done
+if [ "$module_load" -eq 1 ]; then
+	rmmod zram || fail "cannot unload zram"
+fi
+dev_end=-1
+if [ -n "$zswap_enabled" ]; then
+	echo "$zswap_enabled" > /sys/module/zswap/parameters/enabled ||
+		fail "cannot restore zswap"
+	zswap_enabled=""
+fi
+rm -rf "$tmp" || fail "cannot remove temporary files"
+tmp=""
+
+echo "$TCID: [PASS]"
-- 
2.55.0


