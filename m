Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39D5E8538E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 19:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563646B0096; Fri,  3 Apr 2026 15:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AD86B0099; Fri,  3 Apr 2026 15:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42A0C6B009B; Fri,  3 Apr 2026 15:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 324D26B0096
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 15:40:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B85A21401E6
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:42 +0000 (UTC)
X-FDA: 84618261924.02.D20011E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFCCD180005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 19:40:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dIPziEqe;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775245241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bUcpQH60YW+JjRXCirKvU4VYPvJvicfeah63AyAjJU=;
	b=c1LojYQh8C9g6E3gBv6oJS2BNIhUmnCG+WeNF2UJ7swNbpYiIm7ZZRcEKb6AQxD3SleVmi
	OFZ/MTt48NZvd+izRk75dStWILyIYmj1l8TJmHDqt6ONF288ygYZf0AMy4lXUp5p//MHLU
	1AiVuWKkDIj5Z9DgyQPtbGE6B1hiacA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775245241; a=rsa-sha256;
	cv=none;
	b=y5vW8Ge1RlHFFqYg7kxxWjRuOoQl1C/3f4clhGAgbPEEwLOgXhfBv3B0spu6h+JwUoehJL
	5AZ1H75QccS6NpuLT6krd6ObpW0L+SSyHk/332CdD6M+yH4rMdPHb/02jRCKApbkCzfluL
	HwMU55TG/o09PWKic8R8Vh9L7f4kkEQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dIPziEqe;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 150734194B;
	Fri,  3 Apr 2026 19:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C21C2BCAF;
	Fri,  3 Apr 2026 19:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775245239;
	bh=CUyr5fNZuY4RKq1OLQXkrBMqLq0EWre1SrQk+TC1ABM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dIPziEqeVeRPRUf4x4dKXgETATxg/MOMCYRoLEjhgV8QqBul4R0BXSVDkR+Bj4atL
	 60u03+RgXPzKHlpyTtqMgHuraKDXu1UbtDtkvlz8aA2DPEAgrLXwEafafyB5n1nu5L
	 GBmrAEGKPzhW5UxwVcfYjCPcob+fgZab75SHf9oMpcvmc1pQg5MFCil3RFvVla1/4b
	 NHrofvyYG8y52AWHiZJyf1Chrsbs43bQaaFYTuJVTHM+W6Kk363WBZIm1MfMjZdBFp
	 ZXrfd5PK2CsWXen6CjqDW/aFNZ6ZWw3emXkj8gD+0+zCVSCZJly7hhQaaRy5Roldry
	 ieEgLRH/JLpqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 6/6] selftests/liveupdate: add fallocate test for memfd
Date: Fri,  3 Apr 2026 19:40:12 +0000
Message-ID: <20260403194014.3704180-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403194014.3704180-1-pratyush@kernel.org>
References: <20260403194014.3704180-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EFCCD180005
X-Stat-Signature: yno6mnic5yrtow8g1sb3y7m4q7uaeyht
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775245240-134274
X-HE-Meta: U2FsdGVkX195ReF8cImws/uTF70eIGhhc9UH3YqiPYnl5//PielJLIkliVKFgcRN/lblt1umt/c6DZDDvXgeIEUWdk9mNa6hrLpX5rswT6hj3wgTcqz4b+JAVYUwC3ZxIWH+3v3cYmvN8AT++1eGOt8Zl3YoGajCCEQgIQ18QUZ6UhgaEjxFJeODo5qa1Yj7RF1vdYGq1+q3+GFa42SHTX6XRC0gI6HvLXoYGvVK+hinM/I44lXQXwczHqJg3SQ5t3mTuXaptd4OIxtinxh7T2FWLDx7+gXvnyjOdQ/9cN9J6rsxR/LMRLCf/TgtE899RwhgnDIIC1eZxXQiQBiBgfsf1PN2CRfcSu11jkPe/EWtVlBaRNPqnbnWSN3JpuM8ESA5lHVkD+nSutm/f7398ngKGnNQEzdtbhFFjo2vdly3sxVqNpQiAcPEMcjltQMQ7lyRDuDipxv2UxeoMvsTE2N6TA+N3XKmpDkQZTgyaTUbSE0FCfKWNnj+LQYX79eYe7bvragaZeYda1MCp2poaLyNPtPW93V45m+YVBJZGBsMopY/mVK5TqG4TENkGGZRmB83Z1+aI0FH1YKEcL6wLtmLccCit74IhOq27HB//1pGGzgwS2EL9jN3O+TYpe+dwZjNx2Bphd7r5zF0hiOdL+6YpQe6HfFIp7ZN4BcvgPcdhrUHHEnDkSh0mAltGFafPFGX1LZrX+Ye9jcS1nOdnm16JXCgwJs1Uc5wwp/Ahx8gzPDvy57tPB790Yrek935F76oVDd4Otsrs9nQSyfA/Gi2Hx9c9gf51SYoIdMipp8cSBQmUEigwTDY7qyR5eG8cJSQQWFsenGZqYGZf102XzpcCzZM4OocQR8rvKTuzyU8z39f8D5cbdzRrlHJd5Bqe3EmEHbDUaRiI6ZwguEMOFnXopPlNQIinyVe36ssVKjZCX8MMxgOCzR3hPE8ZvEy980IPCyzblCHsDG5ad3
 STICO/en
 s7ywwFYmPMzpo0QgimRBc6MZVJW9zeX3g1idHFhDhR1UWaoUi+Qlo6OetLZw2Sjb+2A5F1rA/bYOAl3ackOEaCYdoby3CNFBjXu4IWttd/99ySsCHmugPk4b5GU7aTlkarf3k6KnD7hDMxFBJNcfXYW1n54c8Su8RAhHbu4IDZdWr7C2MJ6BrtWyOWOze/HwAlsp3sxizOF8EdMulSgsf7pH9z25CElrymG2Q9SXEmtGaU48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

When memory is added to a memfd via fallocate(), it does not get zeroed
immediately. This is tracked by the absence of the uptodate folio flag.
Initially, memfd preservation simply saved the folio flags at preserve
time. This led to a bug, where all writes to un-initialized fallocated
memory after preserve were lost after live update. This is fixed by
commit 50d7b4332f27 ("mm: memfd_luo: always make all folios uptodate").

Add a test that fallocates some memory in a memfd, preserves it, writes
to it. Then in stage 2 it verifies the written content is still present.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../testing/selftests/liveupdate/luo_memfd.c  | 83 +++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
index a1e9f34da006..bc6ab063363f 100644
--- a/tools/testing/selftests/liveupdate/luo_memfd.c
+++ b/tools/testing/selftests/liveupdate/luo_memfd.c
@@ -43,6 +43,11 @@
 #define PRESERVED_MEMFD_TOKEN 1
 #define PRESERVED_BUFFER_SIZE SZ_1M
 
+#define FALLOCATE_SESSION_NAME "fallocate_session"
+#define FALLOCATE_MEMFD_TOKEN 1
+#define FALLOCATE_BUFFER_SIZE SZ_1M
+#define FALLOCATE_DATA_FS_COPY "fallocate_data_fs_copy.bin"
+
 static int luo_fd = -1;
 static int stage;
 
@@ -222,6 +227,84 @@ TEST(preserved_ops)
 	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
 }
 
+static void fallocate_memfd_stage_1(struct __test_metadata *_metadata)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
+
+	buffer = malloc(FALLOCATE_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_create_session(luo_fd, FALLOCATE_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	fd = memfd_create("fallocate_memfd", 0);
+	ASSERT_GE(fd, 0);
+
+	/* Fallocate memory but do not write to it yet */
+	ASSERT_EQ(fallocate(fd, 0, 0, FALLOCATE_BUFFER_SIZE), 0);
+
+	preserve_arg.fd = fd;
+	preserve_arg.token = FALLOCATE_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_PRESERVE_FD, &preserve_arg), 0);
+
+	/* Now write to it after preserving */
+	ASSERT_GE(generate_random_data(buffer, FALLOCATE_BUFFER_SIZE), 0);
+	ASSERT_EQ(save_test_data(FALLOCATE_DATA_FS_COPY, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+	ASSERT_GE(lseek(fd, 0, SEEK_SET), 0);
+	ASSERT_EQ(write_size(fd, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+	daemonize_and_wait();
+}
+
+static void fallocate_memfd_stage_2(struct __test_metadata *_metadata)
+{
+	int fd, session;
+	char *buffer;
+	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
+
+	buffer = malloc(FALLOCATE_BUFFER_SIZE);
+	ASSERT_NE(buffer, NULL);
+
+	session = luo_retrieve_session(luo_fd, FALLOCATE_SESSION_NAME);
+	ASSERT_GE(session, 0);
+
+	ASSERT_EQ(load_test_data(FALLOCATE_DATA_FS_COPY, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+	retrieve_arg.token = FALLOCATE_MEMFD_TOKEN;
+	ASSERT_GE(ioctl(session, LIVEUPDATE_SESSION_RETRIEVE_FD, &retrieve_arg), 0);
+	fd = retrieve_arg.fd;
+	ASSERT_GE(fd, 0);
+
+	ASSERT_EQ(verify_fd_content_read(fd, buffer, FALLOCATE_BUFFER_SIZE), 0);
+
+	ASSERT_EQ(luo_session_finish(session), 0);
+}
+
+/*
+ * Test that an fallocated memfd is preserved across live update and can be
+ * written to after being preserved.
+ */
+TEST(fallocate_memfd)
+{
+	if (cwd_is_tmpfs())
+		SKIP(return, "test saves data to rootfs, cannot run on tmpfs");
+
+	switch (stage) {
+	case 1:
+		fallocate_memfd_stage_1(_metadata);
+		break;
+	case 2:
+		fallocate_memfd_stage_2(_metadata);
+		break;
+	default:
+		TH_LOG("Unknown stage %d\n", stage);
+		ASSERT_FALSE(true);
+	}
+}
+
 int main(int argc, char *argv[])
 {
 	int expected_stage = 0;
-- 
2.53.0.1213.gd9a14994de-goog


