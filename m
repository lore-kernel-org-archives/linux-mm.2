Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D10860A3829
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=oCYoWKZF
Received: by kanga.kvack.org (Postfix)
	id 5C9106B0304; Mon, 19 Oct 2026 13:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDB16B0305; Mon, 19 Oct 2026 13:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356F76B0306; Mon, 19 Oct 2026 13:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06BF56B0304
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:12:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86E7640751
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:17 +0000 (UTC)
X-FDA: 85340019114.10.D08A8CA
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id C1AF440003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:12:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oCYoWKZF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792429935;
	b=KzFQ81s+kUKNN4vDgwMvqrbpSmbtSmiMuD0Hh2bpGta8ySv8efPr22OyqnzBgD0ckgPO9P
	Z1iR6Z+smlGfRpJDZIzcKGFGIWk0c1zwcy2ytqwaj6ovxTr6V5oXnl3TXTniWsRp0M/8sq
	uzR+UDctL2C5Iq3FB9C3+M/XcbjzxFk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oCYoWKZF;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792429935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8qFckcVknZKC1C4pPWUrwsUrEjWk0AoowGLlvfAhkn0=;
	b=bTxHgAir92uHaX5PVfGtjcH07TeUi/TGsJKcNPXEjGAitT6y3g/iIXrg75jTorSlg2ITTQ
	d1+ljetiJCRTM3nJc1+2j3hOiE4qWYT2DKEM0mMlqVQPAlt7Ypd5UtiKlbWyjOYgu2gJtV
	eC4un1tSe9kavIJyRb/biDAdQJoLW5E=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93f1ca4132bso215769785a.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792429935; x=1793034735; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8qFckcVknZKC1C4pPWUrwsUrEjWk0AoowGLlvfAhkn0=;
        b=oCYoWKZFjNb5pJo7Rnt6qiDGP0fb28bBsJQToi7Lmwrdh5JOFDAZyTxUA1gJ7R6lAy
         MFDj8OXOE/NexS6EV84ImG6ba734dQRX6cbkJJuLheYGWbuuEjnQQuVrzx++AlMlPlfw
         orAC6yPfTPJ9E0mf1BkD84QKyLTBJT5NwgqWq6r8YPHhQLCf1SijOYt4/eTmBlEO1Z3r
         PYwsf++Y7Z3FTX0nl5eURiWfTgfKRtq0xS/HmvKA0tkbRNp7tjucnb6JArzHgqBtbO00
         UUuur2fy99JrDBNwKePm30v22zHlYQfH6hruODiLEWuIn0+xdf+OmI8Frls/K3y//iHr
         Jhtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792429935; x=1793034735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8qFckcVknZKC1C4pPWUrwsUrEjWk0AoowGLlvfAhkn0=;
        b=pTnrgBSHFO4evZmlslLNg58wperpKZwzAzAVrD43DQa1ZaAbPMf+ZeuNd9ek38PEAw
         snuDcjWsmiNLbedJul8ZJLLJOz0/7qUJHcu14LJu5ZJ+6WjAsQTK/7IkhBoJeMvxffQp
         w0VULpdU5GEDHNO9KSKLOkslTCGaVqV/KD/kKbLm1veuRIh9Dfs53ro0MzYDci3l5Qxx
         gbOSJY8ym4nfHP7dvDyDZqNVGLAWQx1cH/icjLu+Rp+wPne+hzU/+vSu8B0Utc9SvJSU
         rimEl2hlM77WO4wbilyOsl4/b1Hj61L33IAAi9Aar3U6zjkUYRX0YjcIcAnNoDoNYXJE
         +qEg==
X-Gm-Message-State: AFq9FYJbnjFeUGpfRai/4ZMw6FScoclmukQlM9n/4TLDIlgzDrMYlvDS
	i+R/99NnkA5HFTprRbw8IHGu4EJ1722S1y2YSPRyOQafkt1dzi8jd/15UCp6PbLRNEE=
X-Gm-Gg: AYBFou2zl6f9gK+lNclRO0OK3u0i/eydKgM383Xiu67VMdoSVPwEiEKd+mqHtz3TGXV
	yjMJyvAUmwQs36UCu9jlrFjSRMXhTMdQWw4ZOR84QRE81cEoB2CYwDsf5eJPGdGEpmuhYzYKdvD
	H9G2hysC4N2zNICgtWUyYSxw4oi4TBmwRIAM8K/wTcUR0qf7EO8nWiRFDY6XY2VliXLCI2sW78d
	ko4k977DkHD1oy9RpWciNHwugVe3tglV7ZsTsISA3/5ECqW/S3x4c7gEdwlyDnkYmpGiNOf/FZ/
	v2O9tPVtLh6GhG+KAQTO4I0FvAcDc5k43l/HcNTkXWC8FONtrpCGjVNMU+o6feiSBrVrLngm21f
	Kr+3dpe+5FoCye5br02wL2Xamtkajaf4MAkrK5nDOIHpisJ/+LGCQX1FOXXC5T4Cqm0KXCyb1En
	wRtS2hS11p1Ys4t8LnemPh59oZD5rFRem8JVuGjF/0zpi4PfosyO5iz9qsAZtIK8UK/XJX6jHcs
	zQEz9MJfOYu7yVLAAgZSs4P74TmfVlJmOwMOx4P7yATSNv2rDvznruDQtysWO0d5MT7aOW7g56A
	YCwXM7CStvKc6NPIf1jrM/MDXFwuRBIpmDo57+7cVypKpxCxTgsvDO2igwIGrjU=
X-Received: by 2002:a05:620a:489b:b0:93e:7192:191c with SMTP id af79cd13be357-93f29cc8286mr1416628785a.17.1792429934790;
        Mon, 19 Oct 2026 10:12:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c040d4cedsm723116d6.34.2026.10.19.10.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:12:14 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
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
Subject: [PATCH v3 4/7] selftests/mm: check that MADV_COLD and MADV_PAGEOUT preserve shared memory
Date: Mon, 19 Oct 2026 13:12:03 -0400
Message-ID: <20261019171206.3331374-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019171206.3331374-1-gourry@gourry.net>
References: <20261019171206.3331374-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1AF440003
X-Stat-Signature: mrfee9f7399z8wdmcbr5rhb6x98htjm3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792429935-713686
X-HE-Meta: U2FsdGVkX188WyeOe7AJ301siqztns1L2px2ybdkZq9XMzRwGblfOLVbbqGMButVFiKOz2BwgSbc91TdNdsKB1g0ZCh4LBbVRxpJA2i5XUZeLzjPK3btdStGCYT5Ido/IHcR9ca8A04G56zbn7rk7bH8v2/8ndgaYxV1Pd/j+zhZsMP3ucwSbL9hOmpIK/cGDfj6JF7X8yB1ENCBlDx6jhjPltgBTzExxuxsEQOEPtPHmJ2aOsTzyBUJov7AwvOHKAfAlcWjw1okn7Jkz7DlRWNqqlC3VpeFv4rIZcL2oe5wH2Uf+aooxWCRK10SKsdCRgwXs1/77TW6g79TarEPxWfipB4zYUVra9L61l9tvmiOz74EqycSmSIALi6FpX7H1LrFJGEsddzj/BPz+r4o9KyJlsTmt9h8gTQZV5oUC6QJdmfSyCrBGlUPBgb6jhzKt3wy2isNdv70jONDjRVsjbH1XkZfNKkQKM/6JSfaYklypC7ZujuCzcz+cF2PPNI44NLBWUhUNAAJvHo0WL0RRQexCXNs0PLEvXwiyGNmhtdccSlLx4U2GwO84XYmG1B2aHxTPiAOK+Sr6aM56bmhO6iss+Pa9+cGUy1I4s1QEAQWCHSIuzxy5YklQuE/mBHPktjESVuMqs5uKt3DBDkCntTZAy6OtuodGK2DsCAVJjugKTmaTqCz1FYtcEwW+WMisExO7prhbN/rF6zBmgrDNez0/jNIioOASA+yk8nR7EjfRpS74cUpcs6RU8QgHjv055c1/Eo4cO14fG7m69OCCqfBPRguM+4vkK5tgg/EtEhuu982YyfwFCoLh/NitusxDLkFPs5vwH0Hz4Vu7b0/1Y+Hxmi9tghg3fLDpz2KMCgVQxn6SNo8k0gUVEKxEAQ0Fk9WXdn9HjeGATuD2bt0e6TJ0xW5cRmDznJ+6aaeT3RmETdCZ4j+siKHabQhzrk5Ba03Bc2GD7xOsQbC+bz
 jrAc6M5o
 pQBZ2y1iqVXNH8I7CcgEkXdmwNu4BtnQrVahbx/azoLNmMUJWMRin3bSiVihrPlb1CwlJM/deR7t3d9a5J85mL2ZMgD/xzcLSU8ua0nfGGq8a/rnpp7Icjp3irhqY9p905abFIUaZgzYZWPt1aEOOAos7eL6rk4/5KzTXs+vwh5YXJXFX7Q8SHMCMtZkLT2OEE4TMRkLPPWF3h8fkOVMqecUvMStIXxUJxFhUtU0VvC8JXKMaZ8RE6pOfhZedZMnX1iMuzRcUFBHcUif9FVasLlt0ZuzimFv+azr7hmTwiRNF6vFI7Xp/M+vWaTiscItzAKxRTjpt0gMFRsZOTnLOHoLcg0vPS/QIZay8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both hints are non-destructive, but the tests so far only check that for
private anonymous memory. Shared memory reaches reclaim differently:

Test the following:
 - a dirty shared file page must be written back or left resident,
 - shared anonymous memory is paged out through shmem
 - a SHM_LOCK'd segment is unevictable without its VMA being VM_LOCKED.

MADV_PAGEOUT unmaps a shmem page before it tries to swap it out
so none of these needs swap.

The SHM_LOCK test confirms the page is unevictable and skips otherwise.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
v3: Dropped Sarthak's Reviewed-by from v2 5/8: added the fixture check
    for hidden PFNs and create_temp_file(), and the shared anonymous
    test now fails rather than skips when the page is not unmapped.
---
 .../testing/selftests/mm/madv_cold_pageout.c  | 177 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   1 +
 2 files changed, 178 insertions(+)

diff --git a/tools/testing/selftests/mm/madv_cold_pageout.c b/tools/testing/selftests/mm/madv_cold_pageout.c
index 0874726ec141..7d92f0ecbd27 100644
--- a/tools/testing/selftests/mm/madv_cold_pageout.c
+++ b/tools/testing/selftests/mm/madv_cold_pageout.c
@@ -7,7 +7,11 @@
 #include <fcntl.h>
 #include <sched.h>
 #include <stdbool.h>
+#include <stdint.h>
+#include <sys/ipc.h>
 #include <sys/mman.h>
+#include <sys/shm.h>
+#include <sys/stat.h>
 #include <unistd.h>
 
 #include "kselftest_harness.h"
@@ -44,19 +48,47 @@ static void pin_to_current_cpu(void)
 	CPU_FREE(mask);
 }
 
+/* Whether pagemap shows PFNs, which it only does with CAP_SYS_ADMIN. */
+static bool pagemap_shows_pfns(struct __test_metadata *_metadata,
+			       int pagemap_fd)
+{
+	unsigned long pfn;
+	char *page;
+
+	page = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(page, MAP_FAILED);
+	page[0] = 1;
+	pfn = pagemap_get_pfn(pagemap_fd, page);
+	ASSERT_EQ(munmap(page, page_size), 0);
+
+	return pfn && pfn != -1UL;
+}
+
 FIXTURE(madv_cold_pageout)
 {
 	int pagemap_fd;
+	/* Needs root, and is -1 unless pagemap also shows PFNs. */
+	int kpageflags_fd;
 };
 
 FIXTURE_SETUP(madv_cold_pageout)
 {
 	self->pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	ASSERT_GE(self->pagemap_fd, 0);
+	self->kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	/* Page flags are no use without the PFNs to look them up by. */
+	if (self->kpageflags_fd >= 0 &&
+	    !pagemap_shows_pfns(_metadata, self->pagemap_fd)) {
+		close(self->kpageflags_fd);
+		self->kpageflags_fd = -1;
+	}
 }
 
 FIXTURE_TEARDOWN(madv_cold_pageout)
 {
+	if (self->kpageflags_fd >= 0)
+		close(self->kpageflags_fd);
 	close(self->pagemap_fd);
 }
 
@@ -76,6 +108,58 @@ static bool pageout_until_swapped(char *mapping, size_t size, int pagemap_fd)
 	return false;
 }
 
+/* Page out the range until its first page is unmapped, or madvise() fails. */
+static bool pageout_until_unmapped(char *mapping, size_t size, int pagemap_fd)
+{
+	int retry;
+
+	for (retry = 0; retry < PAGEOUT_RETRIES; retry++) {
+		if (madvise(mapping, size, MADV_PAGEOUT))
+			return false;
+		if (!pagemap_is_populated(pagemap_fd, mapping))
+			return true;
+		usleep(10000);
+	}
+
+	return false;
+}
+
+/* Create an unlinked, zero-filled temporary file, or return -1. */
+static int create_temp_file(size_t size)
+{
+	char template[] = "/tmp/madv_cold_pageout-XXXXXX";
+	int fd;
+
+	fd = mkstemp(template);
+	if (fd < 0)
+		return -1;
+	unlink(template);
+	if (ftruncate(fd, size)) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+/* Map an unlinked, zero-filled temporary file with the given permissions. */
+static char *map_temp_file(struct __test_metadata *_metadata, size_t size,
+			   int flags, mode_t mode)
+{
+	char *mapping;
+	int fd;
+
+	fd = create_temp_file(size);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(fchmod(fd, mode), 0);
+
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, fd, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	close(fd);
+
+	return mapping;
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -275,6 +359,99 @@ TEST_F(madv_cold_pageout, pageout_skips_swapped_pte)
 	check_skips_swapped_pte(_metadata, self->pagemap_fd, MADV_PAGEOUT);
 }
 
+/* MADV_COLD must not discard a dirty page of a shared file mapping. */
+TEST_F(madv_cold_pageout, cold_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
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
+TEST_F(madv_cold_pageout, pageout_preserves_dirty_shared_file_page)
+{
+	char *mapping;
+
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
+	mapping[0] = 1;
+
+	if (!pageout_until_unmapped(mapping, page_size, self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not unmap the page");
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/* MADV_PAGEOUT must not lose the contents of shared anonymous memory. */
+TEST_F(madv_cold_pageout, pageout_preserves_shared_anon_page)
+{
+	char *mapping;
+
+	mapping = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		       MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(mapping, MAP_FAILED);
+	mapping[0] = 1;
+
+	/* MADV_PAGEOUT unmaps a shmem page even when it cannot swap it out. */
+	ASSERT_TRUE(pageout_until_unmapped(mapping, page_size,
+					   self->pagemap_fd));
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * SHM_LOCK makes shmem pages unevictable without setting VM_LOCKED on the
+ * VMA, so MADV_PAGEOUT accepts the range but must not reclaim the page.
+ */
+TEST_F(madv_cold_pageout, pageout_skips_unevictable_page)
+{
+	unsigned long pfn;
+	uint64_t flags;
+	char *mapping;
+	int shmid;
+
+	if (self->kpageflags_fd < 0)
+		SKIP(return, "cannot read page flags");
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
 /* Swap out an anonymous page, to see whether swap works at all. */
 static bool probe_swap(int pagemap_fd)
 {
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


