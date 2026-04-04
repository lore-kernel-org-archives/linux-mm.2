Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300A2E88D97
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 10:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0266B0096; Sat,  4 Apr 2026 06:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080CE6B0098; Sat,  4 Apr 2026 06:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE366B0099; Sat,  4 Apr 2026 06:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CAA656B0096
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 06:25:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 863475B172
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:18 +0000 (UTC)
X-FDA: 84620491116.24.9D35DC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 007E2100002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 10:25:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AhXhT4mL;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775298317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQaphpDNRhHJmUFnDNcPz0xvantHpVtmcmGzUXg79zw=;
	b=XYwhuJA31+w/0vWh5XiYCAvm7qaHCTzbpLNszoFWWwIjUa2h4sG+fEolsbOpqag5zV35Hg
	V0KqduHPoTzBNY+rRf542wmrbUpActWFBR2okhNjBnbVeUtnq5lDMqq2X9+FXbkk5tFygf
	q2bpPd6h3w79PX/Ap3sAUJpBXgLY2Z8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AhXhT4mL;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775298317; a=rsa-sha256;
	cv=none;
	b=kK4sUO4+Jql32XSZopqLbLWgMNiOqRSqt8K4YS3Q2PDV/4zek8n+ZWLHHPzv/swJO9uPVz
	IWjXt+P6JWmcET8OqmA7Sl3LkpfKTUp8ta4A+FIGWH/TuQqNgzbBjL0GloGZM8y8heaW6v
	VbHDG/sLv14zGsVHzU5cKb5z6tRWdB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82B0060123;
	Sat,  4 Apr 2026 10:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC74C19425;
	Sat,  4 Apr 2026 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775298316;
	bh=HbTfOVPJ6K/pRH8J6grgNsnP9Mdw6sr2NEXeLDO74i4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhXhT4mLjF4Cf8C62FA/KA/9pEoCDE47gsVmIFBWLTITZCgMIKZDwQxCeMJRdFQMj
	 6DzWIngvuCeXyHjq+VYiAel/m4+T9MFxPuzN+qt+FBc1yHJ0A2xm5BKVz67jHyu64e
	 nUfgw1V7azXDK8pTO8KL20Fn4FKyiNBlMZyuw7vSfuDfgosIxZw9sRQqlTxJHpTMSg
	 mQvrxFhl2s615uwDAyhc0HbqI2yVMaz/uetKKnpkeoxFLF+VR0cTop5P0FCkmgpl8l
	 rJbHS3S3ESSNJx+pV78/ntAZa3Abas8QBmDb0TXu0HjbaPA8Ge7qEDX0PSQd7GizcN
	 ZIlyNzFx1kxTQ==
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
Subject: [PATCH v3 6/6] selftests/liveupdate: add fallocate test for memfd
Date: Sat,  4 Apr 2026 10:24:49 +0000
Message-ID: <20260404102452.4091740-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t4ncyfc89fk4kh53nh6pf7apbymsho5m
X-Rspamd-Queue-Id: 007E2100002
X-Rspamd-Server: rspam09
X-HE-Tag: 1775298316-616641
X-HE-Meta: U2FsdGVkX19jwVdDbTIKoKY5LTpdFcJvZ9YjoxJtIDAtTMwVI76jgJ+N5vnDlZNFXq3mQB7DZoGInMEzY2T0/3wkw3U5g881frLdbGayWhRqJfFN8jhXsz6EmODEBHafSPsUYMRtwqth43Ug3mELjR66WCErDhqTV6ArQ/gU0MybJCeJ1rNFdWGxXo6oED0+fubH28ePzCLciwDUT03+Py/EsAHxYO6/+x1kH6Jm/oa8+/b7xo1wl23WjFa/cnnVhv/uSbeyxMl35D6S/1DNFJ16HCJoC9ZVtajtYcx7w0ERgissOWFULWYHaBxfmP5yR8BBw8CK2/ul8kQWwHz+yYQ0R5YMu7crlSK8q9hbvZFGd7kJdPfx7bQ4jdBD2P5cBDG4saZ2oMkQXp3IS2dKh7k8UwEmqhZMAP7tixCMEKyw7rtKr5e30GuObAnS8V6Ck+kGgTnCcd9yGOtu03gOGBzZbI/iU+DyhHiPgeP6QezOzSVxqSVnnjusI55TO6k+azn9pERnRjFEWHftgd+1zkrzPmwoGYZoiyXt3YJGmyf1PjLcu6biT+lisT+S7NRZJTvZx2GgrJG1CX2Tz8LGNvXh+C6BwQwUONagsFBvkhP5s9xy8jSU7j0UdGM6fwQlObGqZDVPPrfZE1hPPkApdcWtHNQw3GKajOsQeN/5kxeYL8zzcFxXHlI8CgJH40/EQFjAeXoNUgo7AfBmOv01h1dtJpeS8gfo3n+zA+Sctcld920LYB5EdHAVsd7CcCn2GTiV3QSxXEmOZKakbKrtemIeenTRZD08+7CR5rzUHEZl4lI90gYQla4LVlAExuyOW2OCRYOS45u5+LnXL2Yms8eh9Bdaq8QVil7lABgC1JFTi4d69lJNShc6vW2/s6mmc2JTF5q8XwKdSWG4TX5a169AQqIZ16BSnHBUJOaE2IZ4OB0RSavc9tj+MR2Kfga7jcXiuM/vMJn6+N2IVKA
 IJeMNHT1
 63QQhVsig2xCgMFdiBqK/PgZ8XNnqcaN0lBFIBv8MJJt8gn90qSxS03UI4NSFBR8kGe+eFWlyHLbEag3i6eFFB6uIRWRp5XV1pe2/fZXXhT+ZCN7IMzx0VYVVgvtrYCCKckYqU5M5KwhKAfV74NRrN28yUB2OVFTjUKpvvcFPlTbmlOiZbuC6Rn1xgdn4l4nQ1sTE5rNWDx11bFdy+39LZwwtXsb5n5XORucPq7kfUjVYpPo=
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
index 661a7c922e9d..4a90044ecf1d 100644
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


