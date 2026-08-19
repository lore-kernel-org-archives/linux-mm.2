Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74840C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753326B0088; Wed, 19 Aug 2026 19:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B3E6B00BA; Wed, 19 Aug 2026 19:11:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642286B00BB; Wed, 19 Aug 2026 19:11:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3725A6B00BA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56B48049B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:42 +0000 (UTC)
X-FDA: 85119568044.08.C3354D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 02CAF20002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai4y0Ksr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/dZRQuMzP9Hzjr65eI75u+N7atv415intEiHoxjlmo=;
	b=yWyLEoODWG6iVxx+HeoZdajWKMA4mmFVJjJtTpApFDyEkhaAw6TWCmf9+Bo/aLmOg07qwq
	l0Gmuh4UK9knqHRHChSKvsTutz6IRuALQHm2J+z6J7IAtKVG2Kgv7/oALo/3WPPbYlNNfI
	xCNDZoLmf5Jils6MNAkh5wvUEDJvQY0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ai4y0Ksr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181101;
	b=TGJh2OcGVfUNCGu45hiXIgp46XdZYey/pAQZVqlbk/pCWcYr32FAUIqQYpO9JF09ey+8ZD
	lyx4OXrK9x5isT0s1L3DU2z578/MxedVbHKJwzwm1rSfzHgMaQsj3qpJV0lsXzQpqc/3fm
	oytTSMlx9qEZ5AfraCuVzLlCrMGQUVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B71040876;
	Wed, 19 Aug 2026 23:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5171F00A3D;
	Wed, 19 Aug 2026 23:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181100;
	bh=8/dZRQuMzP9Hzjr65eI75u+N7atv415intEiHoxjlmo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ai4y0Ksri+atGcnLlZi35XChT8fsG4OTn09VpOStrUGeToNPSQu2aF18PZZrITltj
	 VpOu8eIQbPVn3Y1m2OuW0ZKlq8Teu5jo2jQJ67RuEms5tuZyb+/wrp42EiNORWlZBn
	 x86KZQbBZc5VYGWo3AP11rTTb6K8/fyRy0fWU9UaaG/3sX6J7cdf3f4i11tYPgtZey
	 t45ju00YO8ME3wECwtOczckrI7sc+RJk+CnXEKjQVXP84vH5h0Jon/a37sTHLox1tT
	 6QloIUMNNXdEjZVsKmkUoVQ+swD7O5Ng5U9L5TgeBZwm50ydmIXYmVEUa49uzJQuQF
	 uDkApgjool/hg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:35 +0200
Subject: [PATCH v2 18/22] selftests/coredump: test COREDUMP_RECORDS and
 COREDUMP_SPARSE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-18-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=21632; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KGhH0y6sYut8V3smoQ1J6RzT5y+nhXB9gW0T39mWjtw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me933SJn8C9Hufazwq6vlh7RWzu33382cVLiAVHrp
 rVLsuLPdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEWZeRYdmiG/fKfa5de3Cj
 7DbH3yd7vHwdI288uqJ58Ovy0+JP1s1n+Ke03fvBvX+3Fp3rMDrZZab99pbdokaeRUUqbD6Z/6Y
 +cOMBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 02CAF20002
X-Rspamd-Server: rspam07
X-Stat-Signature: y5zpjwk3dc9wny85rka6snnprihe6h3k
X-HE-Tag: 1787181100-729870
X-HE-Meta: U2FsdGVkX182SDzPA3I/5Xog+YAxV1KEj3qHz6mCiRJzm0eyxWY0uux5PDQ/+EtIHETfMgxri2e/o+l8mY3JU6VnzcS2BflJ7Fnf8Vtyl+mZHgrAx97jbA/fuXkzUYQZSwQoUbLnMDWMLW3xkQbThPxWAxcZkEdh9KGp2TRJkZvIdDvMmifWdXuqYjcEKOCU4S81rYyyFjxZ5eR/S49xmRyJjLQ4qvIO7ii8AF4YBCww8rsuBZZmLxyfxG2Y4OhudSmygB9/NZmG/X0MZ5mC7WIWxiw1IPFAPKTUnb1Dc6W4BB1S5G/ZQgqQqvBOs18tj575OPDW5WG1zfRHTeWWPjtj52Ezf3mu7lck+Ch68IG6bkkNLsb1lqW5yYa32ETN3eyrlux2fRtoLU7+hmjmQ87wyGf4dgUnhbXhOJPROzABKsdyXCv4uWYg9JU+8B3wwxPzy9f1Axg12O6kW5LDckbG+Svw13lZx9jFh3pe1bceovmTJ66UH5hHxHaCTrGCNpOkzVe4HgOY49UxAL/Ed9zuRkCe7epsrXP4zOwEYHNhY4pTTyaI4oiD3JC5o5fq75xPYPikLIFb3FoYeduWbAWGhwZAUKlrOd95JpZa2X0qwaWye9KprXlf/7HmgBNhOTaLK+4LturH6nK3zN1h5RsMJC7eJwdt3TCBdQAJAFeMiSblkgb2JJ4lwDfDjZxW6jOEU6KvY8V7ePIPVZQhb3L31aAIYAa6hKpiBunPNSv4diDKCzi2urnbYf3bblHs9le7wcNPgKBIrRR9R5yLppg5e7AIzwWR6BK5kFX01mDcOWqhg2FBrA0GFnf6+Tvq7t3LArcf3/dlER9iTCWc9gI1Z384uCbOzdoYElBthekRX41aommsWnQT2CqA8MtEVMVzktxHnKIuK/l42AcUawOdRuMFjI2qNzlqEAQvYizbABcbY/yFt/1lMQ5GdBT11T8fdT0Y+nkBx/ZQB4w
 xKe90Skt
 NNsj6Cmpn7XkU82ETV8w2Ylq4w4TcSkyjwUiYMdRtoRChT+yuS0w4Gc5IW5TekYN2NVCtuCGx8Q1G9JcATyrCt233xUMFLrnWBofxM+6/qIbVX+F9PSF9NWPq/77o31SHtR8NPvPzXIZGx6gZVDhGoWMaFEU1bz1EloYhFfNoAyiipLSqcVcV0mECyX6soKJt2kPJYLhCBg1uWnOtWUXmIexOI750Kr7n19J/pee1U4yWE/EoJ3xZU0lM9c2Gc1HRcSHqRpFOB0J6/ZGqq/l5bxedYKGKRhmvQUDjPKlL62zOkuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the new COREDUMP_RECORDS and COREDUMP_SPARSE flags.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 407 +++++++++++++++++++++
 .../selftests/coredump/coredump_test_helpers.c     | 236 +++++++++++-
 .../selftests/coredump/coredump_test_helpers.h     |   8 +
 3 files changed, 650 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index 60a357e628eb..abf6e2c4c354 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -1573,4 +1573,411 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps_epoll_workers, 500)
 	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
 }
 
+/*
+ * Reassemble a record stream and check that what comes out is an ELF
+ * core file. The records themselves are validated by recv_coredump_records().
+ */
+TEST_F(coredump, socket_request_sparse_reassemble)
+{
+	int fd_core_file, pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int fd_file = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+
+		close(ipc_sockets[0]);
+
+		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
+		if (fd_server < 0)
+			goto out;
+
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0)
+			goto out;
+
+		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
+		if (fd_peer_pidfd < 0)
+			goto out;
+
+		fd_file = creat("/tmp/coredump.file", 0644);
+		if (fd_file < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req,
+				       COREDUMP_KERNEL | COREDUMP_RECORDS |
+				       COREDUMP_SPARSE | COREDUMP_WAIT, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		if (recv_coredump_records(fd_coredump, fd_file, NULL, NULL, -1) < 0)
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		if (fd_file >= 0)
+			close(fd_file);
+		if (fd_peer_pidfd >= 0)
+			close(fd_peer_pidfd);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child();
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+
+	/* What the records reassemble into has to be an ELF core file. */
+	fd_core_file = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd_core_file, 0);
+	ASSERT_TRUE(is_elf_core(fd_core_file));
+	EXPECT_EQ(close(fd_core_file), 0);
+}
+
+/*
+ * Crash a child with a mostly-unpopulated mapping and reassemble its
+ * record stream, reporting what crossed the socket and the coredump
+ * size the records describe. With @kill_peer the server kills the task
+ * once the coredump is under way so the kernel has to cut it short.
+ */
+static void check_record_dump(struct __test_metadata *const _metadata,
+			      FIXTURE_DATA(coredump) *self, __u64 ack_mask,
+			      bool kill_peer, ssize_t *received,
+			      off_t *coredump_size)
+{
+	bool truncated = false;
+	int pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	int pipefds[2];
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_EQ(pipe(pipefds), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int fd_file = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+		bool is_truncated = false;
+		off_t size = 0;
+		ssize_t ret;
+
+		close(ipc_sockets[0]);
+		close(pipefds[0]);
+
+		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
+		if (fd_server < 0)
+			goto out;
+
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0)
+			goto out;
+
+		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
+		if (fd_peer_pidfd < 0)
+			goto out;
+
+		/*
+		 * The reassembled coredump is bigger than the mapping the
+		 * child made, so keep it on the detached tmpfs and sparse.
+		 */
+		fd_file = open_coredump_tmpfile(self->fd_tmpfs_detached);
+		if (fd_file < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		ret = recv_coredump_records(fd_coredump, fd_file, &size, &is_truncated,
+					    kill_peer ? fd_peer_pidfd : -1);
+		if (ret < 0)
+			goto out;
+
+		if (write_nointr(pipefds[1], &ret, sizeof(ret)) != sizeof(ret))
+			goto out;
+		if (write_nointr(pipefds[1], &size, sizeof(size)) != sizeof(size))
+			goto out;
+		if (write_nointr(pipefds[1], &is_truncated,
+				 sizeof(is_truncated)) != sizeof(is_truncated))
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		close(pipefds[1]);
+		if (fd_file >= 0)
+			close(fd_file);
+		if (fd_peer_pidfd >= 0)
+			close(fd_peer_pidfd);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	EXPECT_EQ(close(pipefds[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_sparse(SPARSE_MAPPING_SIZE);
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+
+	ASSERT_EQ(read_nointr(pipefds[0], received, sizeof(*received)),
+		  sizeof(*received));
+	ASSERT_EQ(read_nointr(pipefds[0], coredump_size, sizeof(*coredump_size)),
+		  sizeof(*coredump_size));
+	ASSERT_EQ(read_nointr(pipefds[0], &truncated, sizeof(truncated)),
+		  sizeof(truncated));
+	EXPECT_EQ(close(pipefds[0]), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+
+	if (kill_peer) {
+		/* The kernel gave up partway, so no end record closed the stream. */
+		ASSERT_TRUE(truncated);
+		ASSERT_FALSE(WCOREDUMP(status));
+		ASSERT_LT(*coredump_size, (off_t)SPARSE_MAPPING_SIZE);
+		return;
+	}
+
+	ASSERT_FALSE(truncated);
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	/* The mapping is in the coredump, holes included. */
+	ASSERT_GT(*coredump_size, (off_t)SPARSE_MAPPING_SIZE);
+}
+
+/*
+ * A mapping that has been written to is dumped whole, including the parts
+ * of it that were never faulted in. With COREDUMP_SPARSE the holes stay
+ * off the wire.
+ */
+TEST_F(coredump, socket_request_sparse_hole)
+{
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+
+	check_record_dump(_metadata, self,
+			  COREDUMP_KERNEL | COREDUMP_RECORDS |
+			  COREDUMP_SPARSE | COREDUMP_WAIT,
+			  false, &received, &coredump_size);
+
+	/* The holes didn't have to go over the socket. */
+	ASSERT_LT(received, coredump_size / 8);
+}
+
+/*
+ * COREDUMP_RECORDS alone splits the stream into records but elides
+ * nothing: the holes cross the socket as data records.
+ */
+TEST_F(coredump, socket_request_records_hole)
+{
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+
+	check_record_dump(_metadata, self,
+			  COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_WAIT,
+			  false, &received, &coredump_size);
+
+	/* Records alone elide nothing, so everything crossed the socket. */
+	ASSERT_GT(received, coredump_size);
+}
+
+/*
+ * A coredump the kernel gives up on halfway still ends in an end record,
+ * and that record says the coredump is incomplete. COREDUMP_SPARSE is left
+ * out on purpose: the holes have to cross the socket so the coredump is
+ * far larger than the socket buffer and the kernel is still writing it
+ * when the kill lands.
+ */
+TEST_F(coredump, socket_request_records_truncated)
+{
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+
+	check_record_dump(_metadata, self,
+			  COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_WAIT,
+			  true, &received, &coredump_size);
+
+	/* The end record crossed the socket even though the task was killed. */
+	ASSERT_GT(received, 0);
+}
+
+/* Ack @ack_mask, expect the kernel to refuse it as conflicting. */
+static void check_conflicting_ack(struct __test_metadata *const _metadata,
+				  FIXTURE_DATA(coredump) *self, __u64 ack_mask)
+{
+	int pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+
+		close(ipc_sockets[0]);
+
+		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
+		if (fd_server < 0)
+			goto out;
+
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0)
+			goto out;
+
+		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
+		if (fd_peer_pidfd < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_CONFLICTING))
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		if (fd_peer_pidfd >= 0)
+			close(fd_peer_pidfd);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child();
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_FALSE(WCOREDUMP(status));
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+}
+
+/* COREDUMP_RECORDS applies to a coredump the kernel writes, nothing else. */
+TEST_F(coredump, socket_request_records_without_kernel)
+{
+	check_conflicting_ack(_metadata, self, COREDUMP_USERSPACE | COREDUMP_RECORDS);
+}
+
+/* A zero record can't exist outside a record stream. */
+TEST_F(coredump, socket_request_sparse_without_records)
+{
+	check_conflicting_ack(_metadata, self, COREDUMP_KERNEL | COREDUMP_SPARSE);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index a5b9cde47239..5b2ffe17f7b7 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <assert.h>
+#include <elf.h>
 #include <errno.h>
 #include <fcntl.h>
 #include <limits.h>
+#include <link.h>
 #include <linux/coredump.h>
 #include <linux/fs.h>
 #include <pthread.h>
@@ -13,6 +15,7 @@
 #include <string.h>
 #include <sys/epoll.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/un.h>
@@ -23,6 +26,12 @@
 
 #include "coredump_test_helpers.h"
 
+#if __ELF_NATIVE_CLASS == 64
+#define COREDUMP_ELFCLASS ELFCLASS64
+#else
+#define COREDUMP_ELFCLASS ELFCLASS32
+#endif
+
 void *do_nothing(void *arg)
 {
 	(void)arg;
@@ -44,6 +53,228 @@ void crashing_child(void)
 	i = *(volatile int *)NULL;
 }
 
+void crashing_child_sparse(size_t size)
+{
+	char *p;
+
+	/*
+	 * Touch the first page only. The whole mapping is dumped because
+	 * it has been written to, but all of it save that one page is a
+	 * hole.
+	 */
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (p != MAP_FAILED)
+		p[0] = 'x';
+
+	/* crash on purpose */
+	*(volatile int *)NULL = 0;
+}
+
+/* Read @len bytes off the socket, writing them at @offset if @fd_out >= 0. */
+static ssize_t recv_record_bytes(int fd_coredump, __u64 len, int fd_out,
+				 off_t offset)
+{
+	ssize_t received = 0;
+
+	while (len) {
+		char buffer[PAGE_SIZE];
+		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
+		ssize_t ret;
+
+		ret = recv(fd_coredump, buffer, chunk, MSG_WAITALL);
+		if (ret <= 0) {
+			fprintf(stderr, "%s: short read %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+
+		if (fd_out >= 0 &&
+		    pwrite(fd_out, buffer, ret, offset + received) != ret) {
+			fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
+			return -1;
+		}
+
+		received += ret;
+		len -= ret;
+	}
+
+	return received;
+}
+
+/*
+ * Reassemble a record stream. If @fd_peer_pidfd is valid the task behind
+ * it is killed once a data record has arrived, so the kernel has to cut
+ * the coredump short with the stream already under way.
+ */
+ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
+			      off_t *coredump_size, bool *truncated,
+			      int fd_peer_pidfd)
+{
+	ssize_t received = 0;
+	off_t size = 0;
+	bool is_truncated = false;
+	bool ended = false;
+	char trailing;
+
+	while (!ended) {
+		struct coredump_record_header record = {};
+		size_t known_size;
+		ssize_t ret;
+
+		/* Peek the header size the way read_coredump_req() does. */
+		ret = recv(fd_coredump, &record, sizeof(record.size),
+			   MSG_PEEK | MSG_WAITALL);
+		if (ret == 0) {
+			/* Nothing closed the stream, so the coredump was cut short. */
+			if (truncated) {
+				is_truncated = true;
+				break;
+			}
+			fprintf(stderr, "%s: stream ended without an end record\n",
+				__func__);
+			return -1;
+		}
+		if (ret != sizeof(record.size)) {
+			fprintf(stderr, "%s: short record peek %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+
+		if (record.size < COREDUMP_RECORD_HEADER_SIZE_VER0) {
+			fprintf(stderr, "%s: header size %u below minimum %u\n",
+				__func__, record.size,
+				COREDUMP_RECORD_HEADER_SIZE_VER0);
+			return -1;
+		}
+
+		/* Consume as much of the header as we know about. */
+		known_size = record.size < sizeof(record) ? record.size : sizeof(record);
+		ret = recv(fd_coredump, &record, known_size, MSG_WAITALL);
+		if (ret != (ssize_t)known_size) {
+			fprintf(stderr, "%s: short record read %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+		received += ret;
+
+		/*
+		 * A flag changes what the record means, so refuse one we
+		 * don't know rather than guess.
+		 */
+		if (record.flags) {
+			fprintf(stderr, "%s: unknown header flags 0x%llx\n",
+				__func__, (unsigned long long)record.flags);
+			return -1;
+		}
+
+		/* Discard any part of the header we have no use for. */
+		ret = recv_record_bytes(fd_coredump, record.size - known_size, -1, 0);
+		if (ret < 0)
+			return -1;
+		received += ret;
+
+		/* Records are sent in order and they don't leave gaps. */
+		if (record.offset != (__u64)size) {
+			fprintf(stderr, "%s: record at %llu, expected %llu\n",
+				__func__, (unsigned long long)record.offset,
+				(unsigned long long)size);
+			return -1;
+		}
+
+		switch (record.type) {
+		case COREDUMP_RECORD_ZERO:
+			/* A hole. It comes with no data and needs none. */
+			break;
+		case COREDUMP_RECORD_DATA:
+			ret = recv_record_bytes(fd_coredump, record.len,
+						fd_core_file, size);
+			if (ret < 0)
+				return -1;
+			received += ret;
+			if (fd_peer_pidfd >= 0) {
+				if (sys_pidfd_send_signal(fd_peer_pidfd, SIGKILL,
+							  NULL, 0)) {
+					fprintf(stderr, "%s: kill failed: %m\n",
+						__func__);
+					return -1;
+				}
+				fd_peer_pidfd = -1;
+			}
+			break;
+		case COREDUMP_RECORD_END:
+			/* The coredump ends here and nothing follows it. */
+			if (record.len) {
+				fprintf(stderr, "%s: end record covers %llu bytes\n",
+					__func__,
+					(unsigned long long)record.len);
+				return -1;
+			}
+			ended = true;
+			break;
+		default:
+			fprintf(stderr, "%s: unknown record type %u\n",
+				__func__, record.type);
+			return -1;
+		}
+
+		size += record.len;
+	}
+
+	/* The end record is the last thing on the wire. */
+	if (recv(fd_coredump, &trailing, sizeof(trailing), MSG_DONTWAIT) > 0) {
+		fprintf(stderr, "%s: data after the end record\n", __func__);
+		return -1;
+	}
+
+	if (truncated)
+		*truncated = is_truncated;
+
+	/*
+	 * Nothing is written for a hole, so grow the file to the size the
+	 * records describe in case the coredump ended in one.
+	 */
+	if (ftruncate(fd_core_file, size) < 0) {
+		fprintf(stderr, "%s: ftruncate to %llu failed: %m\n",
+			__func__, (unsigned long long)size);
+		return -1;
+	}
+
+	if (coredump_size)
+		*coredump_size = size;
+
+	fprintf(stderr, "Received %zd bytes for a %s coredump of %llu bytes\n",
+		received, is_truncated ? "truncated" : "complete",
+		(unsigned long long)size);
+	return received;
+}
+
+/* The ELF header of a native core file. */
+static bool is_core_ehdr(const ElfW(Ehdr) *ehdr)
+{
+	return !memcmp(ehdr->e_ident, ELFMAG, SELFMAG) &&
+	       ehdr->e_ident[EI_CLASS] == COREDUMP_ELFCLASS &&
+	       ehdr->e_type == ET_CORE;
+}
+
+/* Whatever the server ends up with has to be an ELF core file. */
+bool is_elf_core(int fd)
+{
+	ElfW(Ehdr) ehdr;
+
+	if (pread(fd, &ehdr, sizeof(ehdr), 0) != sizeof(ehdr)) {
+		fprintf(stderr, "%s: short read: %m\n", __func__);
+		return false;
+	}
+
+	if (!is_core_ehdr(&ehdr)) {
+		fprintf(stderr, "%s: not an ELF core file\n", __func__);
+		return false;
+	}
+
+	return true;
+}
+
 int create_detached_tmpfs(void)
 {
 	int fd_context, fd_tmpfs;
@@ -86,6 +317,7 @@ int create_and_listen_unix_socket(const char *path)
 	return fd;
 
 out:
+	fprintf(stderr, "%s: %s: %m\n", __func__, path);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -264,8 +496,10 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 	large_ack.ack.mask = mask;
 	large_ack.ack.size = size_ack;
 	ret = send(fd, &large_ack, size_ack, MSG_NOSIGNAL);
-	if (ret != size_ack)
+	if (ret != size_ack) {
+		fprintf(stderr, "%s: short send %zd: %m\n", __func__, ret);
 		return false;
+	}
 
 	fprintf(stderr, "Sent coredump ack with size %zu and mask 0x%llx\n",
 		size_ack, (unsigned long long)mask);
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index 45904bd177b8..fe0a88a71b05 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -15,9 +15,17 @@
 
 #define NUM_THREAD_SPAWN 128
 
+/* Size of the mostly unpopulated mapping the sparse coredump test maps. */
+#define SPARSE_MAPPING_SIZE (256 * 1024 * 1024)
+
 /* Shared helper function declarations */
 void *do_nothing(void *arg);
 void crashing_child(void);
+void crashing_child_sparse(size_t size);
+ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
+			      off_t *coredump_size, bool *truncated,
+			      int fd_peer_pidfd);
+bool is_elf_core(int fd);
 int create_detached_tmpfs(void);
 int create_and_listen_unix_socket(const char *path);
 bool set_core_pattern(const char *pattern);

-- 
2.53.0


