Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E70ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DE246B0099; Wed, 14 Oct 2026 13:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56BBA6B009D; Wed, 14 Oct 2026 13:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BBC46B009E; Wed, 14 Oct 2026 13:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B816B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87A34806ED
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:14 +0000 (UTC)
X-FDA: 85321990908.24.E3FE854
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8B7EE18000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qhrx53UD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oyatGRUxoFSks0yTidJFm5V0CZohajxsNca07bWmCFc=;
	b=REXpRdBjC49WfOLmbMDY/b55ZuchF/q40OiX3JesinaMGucQVHRUOTPN78/Gu/WfUMlA38
	5KcIs7ViVY/SL2wqXlILmAYgBRCazBnuWEC6oNt1oEgOXjETbRCLnGqxZ5qNNqnZXgZep0
	niFKOuA4SkOMrby4mb6k1Fh3PsSuoVk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qhrx53UD;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.49 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000692;
	b=lFTEmbabiLwetcRwH4mr7BsqAV0oIFtErK1gyt8bbopxyhvEICGtOOJt1bVx1izIbUDEBH
	dnUrbG1pZGujuVaJPIeh8cQys1OX0kzNMp9pUSz6HpMO5UVtYH5IRyjiAz3SD/pykdiBRH
	1m4nDiNgice8DhcfH2XsdRyiH5S5R7w=
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-917a707f37eso56385156d6.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000692; x=1792605492; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oyatGRUxoFSks0yTidJFm5V0CZohajxsNca07bWmCFc=;
        b=qhrx53UDOkuqziApxxOhuF6Q9Wpgy7Z+YG9Ld69537Su/covdt8UD9xT6vr7AtWywY
         Oqg383xynxWPq4nMeEIHWtKT/VVegPfv9/A6Zx1XT9zFtX2vVosQSovLCIfhPJ1TweL8
         EZtA7AtYmvw3mCQzg5vl4yCKdSjaZ0ALYZz/mJP+Q7ObkW7wEDxkNLeAiLrNWr3jXsMB
         Ne/MqBUUq9y+omwx0EsV1r6iIxjxb35a6hqvG8JrES9RacgH5cqH8QbjqP1wtE/6qhze
         TyweMMd/FAU5V7b3kMxJoGaGRoLtfeI4RkG1IOMPhcaNvIqpRh9kmPtRuAi94HDxbzcb
         VPTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000692; x=1792605492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oyatGRUxoFSks0yTidJFm5V0CZohajxsNca07bWmCFc=;
        b=fBsC8/vCipnoqYOZSLTYvbR2RbuxxSOSi+QCYyn0iDZ6JCzXTVjB7sIzPjPsO/0UWc
         FDohTUYR08vr2+s1n6QRcmUU3CZumX4Cx0C20DYmO9GvCcgGPsELppExknisG+8tHKwH
         TdmiAh6TuiB7kwyMN8ZZFh2SHXH7tPZ00jo+qlJFhntoxQoEp0n4h2VjfDO7xUCCsg9U
         NhZ21HcjbnnK6YNuNQtuQqMa2OvPRn+i1V1N+ugYsq50K9RyC+a6tl6DA1eTKobHqMFB
         lIcnH2gP0bbtmYLTPYhcfgeOaLscItwSqXwMd+LzblgY41BD3fvJUJyGu8ZgteM+dWH2
         4r+g==
X-Forwarded-Encrypted: i=1; AKwUvBwx7EPfw1dsLBQAwpSz2oKTXwiWiFnkf33oppz2RM/5TuFDEiQHzexKesCEC7JdqHJ0Oz3ZJ4s9iA==@kvack.org
X-Gm-Message-State: AFq9FYIWurbi4H4U4B4ELxqIYVckdqCXio8S9aBlhNV/ykZQVWdhpamF
	c6wMt+vKr210QrcDNPvImTkTgD9UggRs/nu+G4z6vFlb8Xwzl8rwkAYgMwJQSC8ioP00sLcoJlY
	iEE0253A=
X-Gm-Gg: AYBFou307P/5lrM8nZxHO2ykAcfmhDf6Ze6jKe1N1xsIdNc2c6nYGwdNtPip9f6OGGQ
	sSr+0bJZwwLWgosI4tm4jEQdrjlBlG7WtL3C8sTLjR+nQlDPZvsN28/FDIg90GZyM7ZVnrQePcX
	BWN0SD/yWXPXUiZ5kcyhtblKmV/mb63WfMtpcIDFZjvmBst9AcuncZUHofLT3WTXt3nZ09TqtxI
	EYrTdj7xDOav3fKLT1nbztRva+sQ6fXMUtGZWZa8wbPieNdIWq4yjTtDu5SFrRzT0PSFxl1h6x3
	RU81kuiFgmc5Q2D2Q3VP1pWkr8AJoKMV2J5W+SKZJpbXJc1gyzcG74YoF5GaNzxnUkBaAcHUGdF
	x/Etz0rGciXbNRStbWEOUOqFO9YcKvnrdH7dU8gkRI4s9kdzReu8BjhQwiqMyMqpZPxKQ4JYkEs
	nxqGfVjw1mvyTvKDrCvsa2XernZV2VHdzf0+K5pShP9Z5CLz7+iSr2MN3jPY2BXnK8EtuYVs62Y
	cUzyQo5i6V+detrZWbdJ0JLKkpdrIMUhLz4vk+ubWUiaT0RG+WR1SvPjpGS
X-Received: by 2002:a05:6214:4c42:b0:91b:5d3b:4ac1 with SMTP id 6a1803df08f44-91b5d3b4e3cmr222099726d6.54.1792000691642;
        Wed, 14 Oct 2026 10:58:11 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:11 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 5/8] selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared memory
Date: Wed, 14 Oct 2026 13:57:53 -0400
Message-ID: <20261014175756.2035176-6-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8B7EE18000E
X-Rspam-User: 
X-Stat-Signature: xhudzktq5u3f7oix7fr16jnx56r8ezhk
X-HE-Tag: 1792000692-257304
X-HE-Meta: U2FsdGVkX19LNXUePtwMKC7hNLzB7kT+kawnP37MwE2Od5uXaecrBwIWoiiHsvijjfbHG1/DCCwq4qU6NhS/ARVOQcQcCXhlNq8B49dWac+pRXi5D25J8WdsLOYdBo9KARp3EHnJvmgC/pjrx8p+QZa0rtDWNpxwlXY6z5qdBM44nSYWG7nKoo9EZOL5vCiueZ98y8H1lUKd6RJ2BYrTSs9xL2zKXtP70HVTaV9zZmYxqyelyyZN0EiXSGptThgag1KWROede2yqmP1fGDrH28D9fgF55R99+eZcsuOdUB3bQmTgbAx/hRFv12VZ+KbobRMcn+1p/oyWScr0QsEQWagBGdaccRDrDIjWiVsPYOe2KAHc26nGIhfNVDlP2sW/HWYTW4ZiFps7Vt1PaVljBJ/wT4tyCYvGU6mAgLHkrPfum7awUoSyTsoxPwwv4RGQOvEeAUJ0Q4SdT3DsHtqb3T1qSMRBr/WHtRL+ZJwI8oackOWnxraFkUAqu+DH+AN7n0ido23B+ZbaxVoPlzzaw9klLRhBPi6U2idkwCSuDcKAS3YlGcNObMqnoAhN+Aqw+kqMckZUOIiQ//LW7kbHwPeWIF8pWFcEwf0Oeb4siG8sY5OqFteob3jGYclrZgzEpo1t9Nr3i7/lZEOHhR41hxmd97ugdzTKCwPGnjYV5t/Aj1d0f0bAIf3q/6MNcE3KOPRR67JO5Ors7M5svzBH7kXMwut9VMJkNLPt03HC/Xq2TU53MSPa08L3fEkocgOoF+RwRHx8y3pPWY5qdbWmR51SuvanjEq2PufXgGV1lu6MBFJSMTfcSHmsmXVtgGIO9Ic2aLAomQ5KpsjRVWoaWUhXa1PZZu8TIiBreKfsYvtjx0ffCbBWgOPkrDj3RoanvN0g7DqrPd9NO2fuZ045gRj0BsdLbCiyt+OSLOmN6rMUueJ9Y856udxsPzSQUP9rw1MDpgC9LAzlKotGovT
 h32zoe69
 0h3c7+bKLgSkzXHoUf/8RITnZJ6kbn2STFmN5I56eyYsYBSMuIKjDw6mZyooNQVsj8LYQ+ScCquALK5SHz0XbSScvLbxBRWzU7h3V4c/1+RbtQH2kJRnMtDVx6UdJdwdk1mopO93Xb96GXItAVNZYLlw/66KZr0tU83wrL0+Ha3UHoemPKfUKs8c8dTgew0Yp1UhfP7Es0Emqm5YzYo1Xcj57XoN3gnhR0AVvEJTrEiJUeDnrAy4R1OofNuhSNM2onpl98dDBMB4Va5t+7JCTEBr1b0d3Tl+2V5qbSmcqitQcJRFRyDH01vU88T5dGtKtQ39Ucj/0vjk78/j/YHo1iZIb0XPdxzMzz2MC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both hints are non-destructive, but the tests so far only check that for
private anonymous memory. Shared memory reaches reclaim through different
paths: a dirty shared file page must be written back or left resident,
shared anonymous memory is paged out through shmem, and a SHM_LOCK'd
segment is unevictable without its VMA being VM_LOCKED.

Check that MADV_COLD and MADV_PAGEOUT preserve a dirty shared file page,
that MADV_PAGEOUT preserves a shared anonymous page, and that it leaves a
SHM_LOCK'd page resident. The SHM_LOCK test needs root to confirm through
/proc/kpageflags that the page is unevictable, and skips if it is not.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 138 +++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h |   1 +
 2 files changed, 139 insertions(+)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index bd78f63f1314..0851f5428e3d 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -7,7 +7,10 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
+#include <stdint.h>
+#include <sys/ipc.h>
 #include <sys/mman.h>
+#include <sys/shm.h>
 #include <unistd.h>
 
 #include "kselftest_harness.h"
@@ -21,6 +24,8 @@ static size_t page_size;
 FIXTURE(madvise)
 {
 	int pagemap_fd;
+	/* Opening it needs CAP_SYS_ADMIN, -1 otherwise. */
+	int kpageflags_fd;
 };
 
 FIXTURE_SETUP(madvise)
@@ -29,10 +34,13 @@ FIXTURE_SETUP(madvise)
 
 	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	ASSERT_GE(self->pagemap_fd, 0);
+	self->kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
 }
 
 FIXTURE_TEARDOWN(madvise)
 {
+	if (self->kpageflags_fd >= 0)
+		close(self->kpageflags_fd);
 	close(self->pagemap_fd);
 }
 
@@ -52,6 +60,22 @@ static bool pageout_until_swapped(struct __test_metadata *_metadata,
 	return false;
 }
 
+/* Page out the range until its first page is no longer mapped. */
+static bool pageout_until_evicted(struct __test_metadata *_metadata,
+				  char *mapping, size_t size, int pagemap_fd)
+{
+	int retry;
+
+	for (retry = 0; retry < PAGEOUT_RETRIES; retry++) {
+		ASSERT_EQ(madvise(mapping, size, MADV_PAGEOUT), 0);
+		if (!pagemap_is_populated(pagemap_fd, mapping))
+			return true;
+		usleep(10000);
+	}
+
+	return false;
+}
+
 /*
  * Keep this task on one CPU, so that draining that CPU's LRU batches drains
  * the folios this task faulted in.
@@ -67,6 +91,25 @@ static void pin_to_current_cpu(struct __test_metadata *_metadata)
 	ASSERT_EQ(sched_setaffinity(0, sizeof(mask), &mask), 0);
 }
 
+/* Map a shared mapping of an unlinked, zero-filled temporary file. */
+static char *map_temp_file(struct __test_metadata *_metadata, size_t size)
+{
+	char template[] = "/tmp/madvise-pageout-XXXXXX";
+	char *mapping;
+	int fd;
+
+	fd = mkstemp(template);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(unlink(template), 0);
+	ASSERT_EQ(ftruncate(fd, size), 0);
+
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	close(fd);
+
+	return mapping;
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -267,4 +310,99 @@ TEST_F(madvise, pageout_skips_swapped_pte)
 	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_PAGEOUT);
 }
 
+/* MADV_COLD must not discard a dirty page of a shared file mapping. */
+TEST_F(madvise, cold_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size);
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), 0);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * MADV_PAGEOUT may write a dirty shared file page back or leave it resident,
+ * but must not discard it.
+ */
+TEST_F(madvise, pageout_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size);
+	mapping[0] = 1;
+
+	if (!pageout_until_evicted(_metadata, mapping, page_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not unmap the page");
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* MADV_PAGEOUT must not lose the contents of shared anonymous memory. */
+TEST_F(madvise, pageout_preserves_shared_anon_page)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+
+	if (!pageout_until_evicted(_metadata, mapping, page_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not evict the page");
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * SHM_LOCK makes shmem pages unevictable without setting VM_LOCKED on the
+ * VMA, so MADV_PAGEOUT accepts the range but must not reclaim the page.
+ */
+TEST_F(madvise, pageout_skips_unevictable_page)
+{
+	unsigned long pfn;
+	uint64_t flags;
+	char *mapping;
+	int shmid;
+
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "requires root to read page flags");
+	shmid = shmget(IPC_PRIVATE, page_size, IPC_CREAT | 0600);
+	ASSERT_GE(shmid, 0);
+	if (shmctl(shmid, SHM_LOCK, NULL)) {
+		shmctl(shmid, IPC_RMID, NULL);
+		SKIP(return, "could not lock a shmem segment");
+	}
+	mapping = shmat(shmid, NULL, 0);
+	/* The segment is destroyed once it is detached. */
+	shmctl(shmid, IPC_RMID, NULL);
+	ASSERT_NE(mapping, (void *)-1);
+	pin_to_current_cpu(_metadata);
+	mapping[0] = 1;
+
+	/*
+	 * MADV_COLD drains this CPU's LRU add batch, which makes the page
+	 * unevictable.
+	 */
+	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), 0);
+	pfn = pagemap_get_pfn(self->pagemap_fd, mapping);
+	ASSERT_NE(pfn, -1UL);
+	ASSERT_EQ(pageflags_get(pfn, self->kpageflags_fd, &flags), 0);
+	if (!(flags & KPF_UNEVICTABLE))
+		SKIP(return, "could not make the page unevictable");
+
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(shmdt(mapping), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d432..95898e045bac 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -24,6 +24,7 @@
 
 #define KPF_COMPOUND_HEAD             BIT_ULL(15)
 #define KPF_COMPOUND_TAIL             BIT_ULL(16)
+#define KPF_UNEVICTABLE               BIT_ULL(18)
 #define KPF_HWPOISON                  BIT_ULL(19)
 #define KPF_THP                       BIT_ULL(22)
 /*
-- 
2.56.0


